# frozen_string_literal: true

class GenresFinder
  include QueryHelpers

  attr_reader :top, :limit

  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @top = params[:top] == 'true'
    @limit = natural_num_limit(params[:limit].to_i)
  end

  def call
    Genre.all
      .yield_self(&method(:top_genres_clause))
      .yield_self(&method(:limit_clause))
  end

  private

  def top_genres_clause(relation)
    return relation unless top

    Genres::TopGenresQuery.call(relation, limit)
  end

  def limit_clause(relation)
    return relation if top
    return relation if limit.blank?

    relation.limit(limit)
  end
end
