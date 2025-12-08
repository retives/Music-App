# frozen_string_literal: true

if defined?(LetterOpener)
  LetterOpener.configure do |config|
    config.message_template = :default
    config.location = Rails.root.join('tmp/mailers')
  end

  if Rails.env.development?
    mailer_folder = Rails.root.join('tmp/mailers')
    Dir.glob(File.join(mailer_folder, '*')).each do |folder|
      next unless File.ctime(folder) < 1.hour.ago

      FileUtils.rm_rf(folder)
    end
  end
end
