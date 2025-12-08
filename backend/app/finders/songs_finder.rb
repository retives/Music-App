# frozen_string_literal: true

class SongsFinder
  include QueryHelpers

  attr_reader :search,
              :popular,
              :genres_count,
              :sort_by,
              :sort_order,
              :limit_per_genre,
              :page,
              :per_page

  DEFAULT_SONGS_PER_PAGE = 20
  DEFAULT_SORT_BY = 'created_at'

  def self.call(params)
    new(params).call
  end

  # @param [Hash] params
  # @option params [String] :search
  # @option params [Boolean] :popular
  # @option params [Integer] :genres_count
  # @option params [String] :sort_by created_at
  # @option params [String] :sort_order asc, desc
  # @option params [Integer] :limit_per_genre
  # @option params [Integer] :page
  # @option params [Integer] :per_page
  def initialize(params)
    @search = params[:search]
    @popular = params[:popular] == 'true'
    @genres_count = params[:genres_count]
    @sort_by = params[:sort_by] || DEFAULT_SORT_BY
    @sort_order = check_sort_order(params[:sort_order])
    @limit_per_genre = natural_num_limit(params[:limit_per_genre].to_i)
    @page = params[:page]
    @per_page = [(natural_num_limit(params[:per_page].to_i) || DEFAULT_SONGS_PER_PAGE),
                 QueryHelpers::MAX_LIMIT_PER_PAGE].min
  end

  def call
    Song.includes(:artists, :album, :genre)
      .yield_self(&method(:search_clause))
      .yield_self(&method(:popular_clause))
      .yield_self(&method(:by_genre_clause))
      .yield_self(&method(:sort_clause))
      .yield_self(&method(:paginate_clause))
  end

  private

  def search_clause(relation)
    return relation if search.blank?

    Songs::SearchSongsQuery.call(relation, search)
  end

  def popular_clause(relation)
    return relation unless popular
    return relation if genres_count.present?

    Songs::PopularSongsQuery.call(relation)
  end

  def by_genre_clause(relation)
    return relation if genres_count.blank?

    # Sort current set of songs (this would be songs found or all) by popularity
    relation = Songs::PopularSongsQuery.call(relation)

    songs = []
    top_genres = Genres::TopGenresQuery.call(Genre.all, genres_count)

    top_genres.each do |genre|
      songs.concat(Songs::TopByGenreSongsQuery.call(relation, genre.id, limit_per_genre))
    end

    Song.where(id: songs.map(&:id))
  end

  def sort_clause(relation)
    return relation if sort_by.blank? || sort_order.blank?

    relation
      .order("#{sort_by}": sort_order.to_sym)
  end

  def paginate_clause(relation)
    PaginateService.call(scope: relation, options: { items: per_page, page: })
  end
end
