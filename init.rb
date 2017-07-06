require 'mailer_patch'

Redmine::Plugin.register :email_fiddler do
  name 'Email Fiddler plugin'
  author 'Rafael Vargas'
  description 'A Redmine plugin to enable fliddling with the notification emails subjects'
  version '0.1.0'
  url 'https://github.com/rsvargas/redmine_email_fiddler'
  author_url 'https://github.com/rsvargas'

  settings( 
    :default => {
      'issue_add_subject' => '',
      'issue_edit_subject' => '',
    }, 
    :partial =>  'settings/email_fiddler'
  )
end

if Rails::VERSION::MAJOR >= 3
    ActionDispatch::Callbacks.to_prepare do
        require_dependency 'mailer'
        Mailer.send(:include, EmailFiddlerMailerPatch)
    end
else
    Dispatcher.to_prepare do
        require_dependency 'mailer'
        Mailer.send(:include, EmailFiddlerMailerPatch)
    end
end

