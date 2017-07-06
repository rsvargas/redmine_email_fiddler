module EmailFiddlerMailerPatch
    def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
            alias_method_chain :issue_add, :fiddle
            alias_method_chain :issue_edit, :fiddle
        end
    end

    module InstanceMethods
        def mail_fiddler_format(fmt_string, issue)
            fmt_string.gsub(/(\{(project|tracker|issue_id|subject|status)\})/i).each do |w|
                case w.downcase
                when "{project}"
                    issue.project.name
                when "{tracker}"
                    issue.tracker.name
                when "{issue_id}"
                    "##{issue.id}"
                when "{subject}"
                    issue.subject
                when "{status}"
                    issue.status.name
                end
            end
        end

        def issue_add_with_fiddle(*args)
            mail = issue_add_without_fiddle(*args)
            new_subject_fmt = Setting.plugin_email_fiddler['issue_add_subject']
            if new_subject_fmt != ''
                issue = args[0]
                new_subject = mail_fiddler_format(new_subject_fmt, issue )
                #Rails.logger.info "old_subject = #{mail.subject}\nnew_subject = #{new_subject}"
                mail.subject = new_subject
            end
            return mail
        end


        def issue_edit_with_fiddle(*args)
            mail = issue_edit_without_fiddle(*args)
            new_subject_fmt = Setting.plugin_email_fiddler['issue_edit_subject']
            if new_subject_fmt != ''
                journal = args[0]
                issue = journal.journalized

                new_subject = mail_fiddler_format(new_subject_fmt, issue )
                #Rails.logger.info "old_subject = #{mail.subject}\nnew_subject = #{new_subject}"
                mail.subject = new_subject
            end
            return mail
        end

    end

end
