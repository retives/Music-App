# frozen_string_literal: true

class FriendshipsFinder
  include QueryHelpers

  attr_reader :params, :current_user, :direction, :page, :per_page

  DEFAULT_ITEMS_PER_PAGE = 10
  VALID_DIRECTION_PARAMS = %w[sent received].freeze

  def self.call(*args)
    new(*args).call
  end

  def initialize(params, current_user)
    @direction = VALID_DIRECTION_PARAMS.include?(params[:direction]) ? params[:direction] : nil
    @page = params[:page]
    @per_page = [(natural_num_limit(params[:per_page].to_i) || DEFAULT_ITEMS_PER_PAGE),
                 QueryHelpers::MAX_LIMIT_PER_PAGE].min
    @current_user = current_user
  end

  def call
    Friendship.includes(:sender, :receiver)
      .yield_self(&method(:friendship_clause))
      .yield_self(&method(:friendship_requests_clause))
      .yield_self(&method(:sort_clause))
      .yield_self(&method(:paginate_clause))
  end

  private

  def friendship_clause(relation)
    return relation if direction.present?

    relation
      .with_sender_or_receiver(current_user)
      .with_status(:accepted)
  end

  def friendship_requests_clause(relation)
    return relation if direction.blank?

    method(direction.to_sym).call(relation)
  end

  def sort_clause(relation)
    if direction.blank?
      relation.order(updated_at: :desc)
    else
      relation.order(created_at: :desc)
    end
  end

  def paginate_clause(relation)
    PaginateService.call(scope: relation, options: { items: per_page, page: })
  end

  def sent(relation)
    relation.with_sender(current_user).with_status(:pending)
  end

  def received(relation)
    relation.with_receiver(current_user).with_status(:pending)
  end
end
