module SqlOptimizers
  def raw_execute(cmd, *args)
    case cmd
    when :multi_idea_add
      groupable = args[0]
      groupable_type = args[0].class.to_s

      sql = "insert into idea_assignments  (groupable_type, groupable_id, idea_id) values "
      sql += args[1].map do |idea_id|
        "('#{groupable_type}', #{args[0].id}, #{idea_id})"
      end.join(', ')
      ActiveRecord::Base.connection.execute sql
    end
  end
end
