# frozen_string_literal: true

module Api
  module V1
    class OptionsController < ApiController
      def show
        option = Option.find_by(handle: params[:handle])

        if option
          render json: { option: Api::V1::OptionSerializer.new(option).serializable_hash }, status: :ok
        else
          render_not_found(I18n.t('errors.data_not_found'))
        end
      end
    end
  end
end
