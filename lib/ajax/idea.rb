module Ajax
  class Idea
    def self.run_ajax_action(action, *args)
      args.flatten!
      params = args[0]

      struct = {}
      case action
      when 'delete_attachment'
        if args.size == 1 and (df = DownloadFile.find_by_id(args[0]))
          df.delete
          struct[:status] = true
        else
          struct[:status] = false
        end
      end
      
      struct
    end
  end
end
