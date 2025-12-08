# frozen_string_literal: true

module QueryHelpers
  SORT_ORDERS = %w[asc desc].freeze
  DEFAULT_SORT_ORDER = 'desc'
  MAX_LIMIT_PER_PAGE = 100

  def check_sort_order(sort_order)
    SORT_ORDERS.include?(sort_order) ? sort_order : DEFAULT_SORT_ORDER
  end

  def natural_num_limit(limit)
    limit <= 0 ? nil : limit
  end
end
