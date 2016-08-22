module Ajax
  class Survey
    def self.run_ajax_action(action, *args)
      args.flatten!
      struct = {}
      case action
      when 'destroy'
        id = args[0]
        if obj = ::Survey.find_by_id(id)
          obj.destroy
          struct[:status] = true
        else
          struct[:status] = false
        end
      end
    end
  end
end
