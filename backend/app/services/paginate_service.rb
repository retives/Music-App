# frozen_string_literal: true

class PaginateService < ApplicationService
  include Pagy::Backend

  def initialize(scope:, options:)
    @scope = scope
    @options = options
  end

  def call
    pagy_meta, records = pagy(@scope, items: @options[:items])
    pagy_meta = format_pagy_meta(pagy_meta)

    [pagy_meta, records]
  rescue Pagy::VariableError => e
    e.message
  end

  private

  def format_pagy_meta(pagy_meta)
    {
      count: pagy_meta.count,
      page: pagy_meta.page,
      items: pagy_meta.items,
      last: pagy_meta.last,
      pages: pagy_meta.pages
    }
  end

  def pagy_get_vars(_scope, vars)
    vars[:count] ||= (count = @scope.count(:all)).is_a?(Hash) ? count.size : count
    vars[:page] = @options[:page]
    vars
  end
end
