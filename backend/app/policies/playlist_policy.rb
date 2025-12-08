# frozen_string_literal: true

class PlaylistPolicy < ApplicationPolicy
  def show?
    scope.exists?(id: record.id)
  end

  class Scope < Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.present?
        scope.where(playlists: { user_id: user.id }).or(scope.public_playlists).or(scope.all_user_related(user))
      else
        scope.public_playlists
      end
    end
  end
end
