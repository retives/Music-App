# frozen_string_literal: true

class PlaylistDecorator < Draper::Decorator
  delegate_all

  def number_likes_dislikes
    "#{I18n.t('playlist.likes')}: #{liking_users.count} / #{I18n.t('playlist.dislikes')}: #{disliking_users.count}"
  end

  def playlist_type
    case object.playlist_type
    when 'personal'
      I18n.t('playlist_type.personal')
    when 'shared'
      I18n.t('playlist_type.shared')
    when 'open'
      I18n.t('playlist_type.open')
    end
  end
end
