# frozen_string_literal: true

class PlaylistMailer < ApplicationMailer
  def playlist_milestone_email(milestone)
    @user = params[:user]
    @milestone = milestone
    mail(
      to: @user.email,
      subject: I18n.t('mailer.playlist_milestone_email_subject', milestone: @milestone)
    )
  end
end
