# frozen_string_literal: true

module Songs
  class SongsQuery
    def initialize(initial_scope)
      @initial_scope = initial_scope
    end

    def call(sort_type, sort_direction)
      case sort_type
      when 'popularity'
        sorted_song_ids = @initial_scope.playlist_songs
          .joins(song: :playlist_songs)
          .group('songs.id')
          .order("COUNT(playlist_songs.id) #{sort_direction.upcase}")
          .pluck('songs.id')

        songs = Song.where(id: sorted_song_ids).index_by(&:id)

        sorted_song_ids.map { |song_id| songs[song_id] }
      end
    end
  end
end
