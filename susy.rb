# rake rails:template LOCATION=http://github.com/bazzel/rails-templates/raw/master/susy.rb
puts
puts '==  Rails template for setting up compass with susy ================================'
puts '-- see: http://wiki.github.com/chriseppstein/compass '
puts '        and http://susy.oddbird.net/ for more'
puts

# Expects a Gemfile, use http://github.com/bazzel/rails-templates/raw/master/bundler.rb template for it.
if yes?("Set up bundler?")
  load_template 'http://github.com/bazzel/rails-templates/raw/master/bundler.rb'
end

append_file 'Gemfile', %{

gem "haml",                ">=3.0.15"
gem "compass",             ">=0.10.3"
gem "compass-susy-plugin", ">=0.7.0"
}

run "bundle install"

# Use Susy CSS framework
run "compass init rails -r susy -u susy --sass-dir=app/stylesheets --css-dir=public/stylesheets/compiled"