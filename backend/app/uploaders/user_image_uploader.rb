# frozen_string_literal: true

class UserImageUploader < ImageUploader
  Attacher.derivatives do |original|
    magick = ImageProcessing::MiniMagick.source(original)
    {
      large: magick.resize_to_limit!(2 * 360, 2 * 360),
      medium: magick.resize_to_limit!(2 * 288, 2 * 288),
      small: magick.resize_to_limit!(2 * 182, 2 * 182),
      micro: magick.resize_to_limit!(2 * 60, 2 * 60)
    }
  end
end
