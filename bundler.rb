# rake rails:template LOCATION=http://github.com/bazzel/rails-templates/raw/master/bundler.rb
puts
puts '==  Rails template for setting up bundler ================================'
puts '-- see: http://tomafro.net/2010/02/updated-rails-template-for-bundler for more'
puts

# Same as:
# rake rails:template LOCATION=http://github.com/tomafro/dotfiles/raw/master/resources/rails/bundler.rb
load_template 'http://github.com/tomafro/dotfiles/raw/master/resources/rails/bundler.rb'