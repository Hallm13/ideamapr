module Ajax
  class CmsContent
    def self.run_ajax_action(action, *args)
      args.flatten!
      cms_filter = args[0]

      struct = {}
      case action
      when 'get'
        if cms_filter == 'help_text'
          struct[:data] = ::CmsContent.where('key like ?', 'help_text%').pluck(:key, :cms_text).inject({}) do |memo, pair| 
            memo[pair[0]] = pair[1]
            memo
          end
          struct[:status] = true
        end
      end
      
      struct[:status] ||= false
      struct
    end
  end
end
