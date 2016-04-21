# Coverage testing for JavaScript
#
# Usage:
# Download JSCover from: http://tntim96.github.io/JSCover/ and move it to
#   ~/Applications/JSCover-1
# First instumentalize the javascript files:
#   rake assets:coverage
# Then run browser tests
#   rake test
# See the results in the browser
#   http://localhost:3000/assets/jscoverage.html
# Don't forget to clean up instrumentalization afterwards:
#   rake assets:clobber
# Also don't forget to re-do instrumentalization after changing a JS file

namespace :assets do
  desc 'Instrument all the assets named in config.assets.precompile'
  task :coverage do
    Rake::Task["assets:coverage:primary"].execute
  end

  namespace :coverage do
    def jscoverage_loc;Dir.home+'/code/libraries/jscover';end
    def internal_instrumentalize
      config = Rails.application.config
      target=File.join(Rails.public_path,config.assets.prefix)

      environment = Sprockets::Environment.new
      environment.append_path 'app/assets/javascripts'
      `rm -rf #{tmp=File.join(Rails.root,'tmp','jscover')}`
      `mkdir #{tmp}`
      `rm -rf #{target}`
      `mkdir #{target}`

      print 'Generating assets'
      require File.join(Rails.root,'config','initializers','assets.rb')
      (%w{application.js}+config.assets.precompile.select{|f| f.is_a?(String) && f =~ /\.js$/}).each do |f|
        print '.';File.open(File.join(target,f), 'w') {|ff| ff.write(environment[f].to_s) }
      end
      puts "\nInstrumentalizing…"
      `java -Dfile.encoding=UTF-8 -jar #{jscoverage_loc}target/dist/JSCover-all.jar -fs #{target} #{tmp} #{'--no-branch' unless ENV['C1']} --local-storage`
      puts 'Copying into place…'
      `cp -R #{tmp}/ #{target}`
      `rm -rf #{tmp}`
      File.open("#{target}/jscoverage.js",'a'){|f| f.puts 'jscoverage_isReport = true' }
    end

    task :primary => %w(assets:environment) do
      unless Dir.exist?(jscoverage_loc)
        abort "Cannot find JSCover! Download from: http://tntim96.github.io/JSCover/ and put in #{jscoverage_loc}"
      end
      internal_instrumentalize
    end
  end
end
