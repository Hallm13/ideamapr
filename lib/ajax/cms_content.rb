module Ajax
  class CmsContent
    def self.run_ajax_action(action, *args)
      args.flatten!
      cms_filter = args[0]

      struct = {}
      case action
      when 'get'
        if cms_filter == 'help_text'
          struct[:data] = ::CmsContent.where('key like ?', 'help_text%').all.to_a
          struct[:status] = true
        elsif cms_filter.to_i > 0
          struct[:data] = ::CmsContent.where(id: cms_filter.to_i).first
          struct[:status] = true
        end
      end

      struct[:status] ||= false
      struct
    end
  end
end
