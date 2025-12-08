# frozen_string_literal: true

class CommentPolicy < ApplicationPolicy
  def index?
    scope.exists?(id: record.id)
  end

  def create?
    record.playlist_type != 'personal' || record.user_id == user.id
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
