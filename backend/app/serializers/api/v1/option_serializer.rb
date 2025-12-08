# frozen_string_literal: true

module Api
  module V1
    class OptionSerializer
      include JSONAPI::Serializer

      set_type :option
      set_id :id

      attributes :title, :body
    end
  end
end
