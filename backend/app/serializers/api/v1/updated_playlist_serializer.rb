# frozen_string_literal: true

module Api
  module V1
    class UpdatedPlaylistSerializer
      include JSONAPI::Serializer

      attributes :name, :logo, :description

      attribute :logo do |object|
        if object.logo
          derivatives =
            {
              large: object.logo(:large).id,
              medium: object.logo(:medium).id,
              small: object.logo(:small).id
            }
          object.logo.as_json.merge(derivatives:)
        end
      end
    end
  end
end
