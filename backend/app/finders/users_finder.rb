# frozen_string_literal: true

class UsersFinder
  include QueryHelpers

  DEFAULT_USERS_PER_PAGE = 5

  attr_reader :user_type, :page, :per_page

  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @user_type = params[:user_type]
    @page = params[:page]
    @per_page = [(natural_num_limit(params[:per_page].to_i) || DEFAULT_USERS_PER_PAGE),
                 QueryHelpers::MAX_LIMIT_PER_PAGE].min
  end

  def call
    User.includes(:playlists)
      .with_friends
      .yield_self(&method(:user_type_clause))
      .yield_self(&method(:paginate_clause))
  end

  private

  def user_type_clause(relation)
    case user_type
    when 'popular' then Users::MostPopularUsersQuery.call(relation)
    when 'contributor' then Users::TopContributorsQuery.call(relation)
    end
  end

  def paginate_clause(relation)
    PaginateService.call(scope: relation, options: { items: per_page, page: })
  end
end
