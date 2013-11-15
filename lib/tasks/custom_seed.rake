namespace :db do
  namespace :seed do
    Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
      task_name = File.basename(filename, '.rb').to_sym

      # This allows up to 3 arguments to be added to a task
      task task_name, {[:arg1, :arg2, :arg3] => [:environment]} do |t, args|
        $argv = args.dup
        load(filename) if File.exist?(filename)
      end
    end
  end
end
