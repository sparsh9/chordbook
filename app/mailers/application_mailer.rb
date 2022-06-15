class ApplicationMailer < ActionMailer::Base
  SUPPORT_FROM = ENV.fetch("MAIL_FROM", "Chord Book <help@chordbook.app>")
  NEWS_FROM = ENV.fetch("MAIL_FROM", "Chord Book <news@chordbook.app>")

  layout "mailer"
end
