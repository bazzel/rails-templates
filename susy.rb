puts
puts '==  Rails template for setting up compass with susy ================================'
puts '-- see: http://wiki.github.com/chriseppstein/compass '
puts '        and http://susy.oddbird.net/ for more'
puts

# Expects a Gemfile, use http://tomafro.net/2010/02/updated-rails-template-for-bundler for it.
append_file 'Gemfile', %{

gem "haml",                ">=3.0.12"
gem "compass",             ">=0.10.2"
gem "compass-susy-plugin", ">=0.7.0"
}

# Use Susy CSS framework
run "compass init rails -r susy -u susy --sass-dir=app/stylesheets --css-dir=public/stylesheets/compiled"