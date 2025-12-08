# frozen_string_literal: true

if defined? Bullet
  Rails.application.config.after_initialize do
    Bullet.enable        = true
    Bullet.alert         = true
    Bullet.bullet_logger = true
    Bullet.console       = true
    Bullet.rails_logger  = true
    Bullet.add_footer    = true
    Bullet.raise         = true
    Bullet.unused_eager_loading_enable = false
  end
end
