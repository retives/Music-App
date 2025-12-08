# frozen_string_literal: true

require 'image_processing/mini_magick'

class ImageUploader < Shrine
  Attacher.validate do
    validate_mime_type_inclusion %w[image/jpeg image/png image/svg+xml]
    validate_extension %w[jpg jpeg png svg]
    validate_max_size  10 * 1024 * 1024, message: I18n.t('errors.image_size')
  end

  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    {
      large: magick.resize_to_limit!(2 * 360, 2 * 360),
      medium: magick.resize_to_limit!(2 * 288, 2 * 288),
      small: magick.resize_to_limit!(2 * 182, 2 * 182)
    }
  end
end
