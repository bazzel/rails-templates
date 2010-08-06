# rake rails:template LOCATION=http://github.com/bazzel/rails-templates/raw/master/compass.rb
puts
puts '==  Rails template for setting up compass ================================'
puts '-- see: http://wiki.github.com/chriseppstein/compass for more'
puts

# Expects a Gemfile, use http://github.com/bazzel/rails-templates/raw/master/bundler.rb template for it.
if yes?("Set up bundler?")
  load_template 'http://github.com/bazzel/rails-templates/raw/master/bundler.rb'
end

append_file 'Gemfile', %{

gem "haml",                ">=3.0.15"
gem "compass",             ">=0.10.3"
}

# Use Susy CSS framework
run "compass init rails --sass-dir=app/stylesheets --css-dir=public/stylesheets/compiled"