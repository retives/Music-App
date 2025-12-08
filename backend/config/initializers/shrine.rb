# frozen_string_literal: true

require 'shrine'
require 'shrine/storage/file_system'
require 'shrine/plugins/determine_mime_type'
require 'shrine/plugins/derivatives'
require 'shrine/storage/memory'
require 'shrine/storage/s3'

unless Rails.env.test? || Rails.env.development?
  s3_options = {
    bucket: ENV.fetch('MUSICAPP_AWS_BUCKET_NAME', nil),
    region: ENV.fetch('MUSICAPP_AWS_REGION_NAME', nil),
    access_key_id: ENV.fetch('MUSICAPP_AWS_ACCESS_KEY', nil),
    secret_access_key: ENV.fetch('MUSICAPP_AWS_SECRET_KEY', nil)
  }
end

Shrine.storages = if Rails.env.test?
                    {
                      cache: Shrine::Storage::Memory.new,
                      store: Shrine::Storage::Memory.new
                    }
                  elsif Rails.env.development?
                    {
                      cache: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/cache'),
                      store: Shrine::Storage::FileSystem.new('public', prefix: 'uploads/store')
                    }
                  else
                    {
                      cache: Shrine::Storage::S3.new(prefix: 'uploads/cache', **s3_options),
                      store: Shrine::Storage::S3.new(prefix: 'uploads/store', **s3_options)
                    }
                  end

if Rails.env.development?
  file_system = Shrine.storages[:cache]
  file_system.clear! { |path| path.mtime < Time.zone.now - (1 * 24 * 60 * 60) }
end

Shrine.plugin :activerecord           # loads Active Record integration
Shrine.plugin :cached_attachment_data # enables retaining cached file across form redisplays
Shrine.plugin :restore_cached_data    # extracts metadata for assigned cached files

Shrine.plugin :validation_helpers
Shrine.plugin :remove_invalid
Shrine.plugin :derivatives, create_on_promote: true

Shrine.plugin :determine_mime_type
