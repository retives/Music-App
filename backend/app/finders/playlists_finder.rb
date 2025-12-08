# frozen_string_literal: true

class PlaylistsFinder
  include QueryHelpers

  attr_reader :search, :type, :sort_by, :sort_order, :page, :per_page

  VALID_TYPE_PARAMS = %w[popular last featured].freeze
  DEFAULT_PLAYLISTS_PER_PAGE = 10

  def self.call(base_relation, params)
    new(base_relation, params).call
  end

  def initialize(base_relation, params)
    @base_relation = base_relation
    @search = params[:search]
    @type = VALID_TYPE_PARAMS.include?(params[:type]) ? params[:type] : nil
    @sort_by = params[:sort_by]
    @sort_order = check_sort_order(params[:sort_order])
    @page = params[:page]
    @per_page = [(natural_num_limit(params[:per_page].to_i) || DEFAULT_PLAYLISTS_PER_PAGE),
                 QueryHelpers::MAX_LIMIT_PER_PAGE].min
  end

  def call
    @base_relation
      .includes(:user, songs: :artists)
      .yield_self(&method(:search_clause))
      .yield_self(&method(:popular_type_clause))
      .yield_self(&method(:last_type_clause))
      .yield_self(&method(:featured_type_clause))
      .yield_self(&method(:sort_clause))
      .yield_self(&method(:paginate_clause))
  end

  private

  def search_clause(relation)
    return relation if search.blank?

    Playlists::SearchPlaylistsQuery.call(relation, search)
  end

  def popular_type_clause(relation)
    return relation unless type == 'popular'

    Playlists::PopularPlaylistsQuery.call(relation)
  end

  def last_type_clause(relation)
    return relation unless type == 'last'

    Playlists::LastPlaylistsQuery.call(relation)
  end

  def featured_type_clause(relation)
    return relation unless type == 'featured'

    Playlists::FeaturedPlaylistsQuery.call(relation)
  end

  def sort_clause(relation)
    relation
      .order(sort_direction)
      .order('playlists.created_at DESC')
  end

  def sort_direction
    case @sort_by
    when 'comments_count'
      comments_count_order
    when 'playlist_name'
      "playlists.name #{@sort_order}"
    else
      default_sort
    end
  end

  def default_sort
    reactions_count_subquery = Reaction.where('reactions.playlist_id = playlists.id AND reactions.status = 1')
      .select('COUNT(*)')
      .to_sql

    Arel.sql("(#{reactions_count_subquery}) DESC")
  end

  def comments_count_order
    count_subquery = Comment.where('comments.playlist_id = playlists.id')
      .select('COUNT(*)')
      .to_sql

    Arel::Nodes::NamedFunction.new('COALESCE',
                                   [Arel.sql("(#{count_subquery})::integer"), 0]).send(@sort_order.to_sym)
  end

  def paginate_clause(relation)
    PaginateService.call(scope: relation, options: { items: per_page, page: })
  end
end
