# frozen_string_literal: true

# bin/rails app:template LOCATION=https://raw.github.com/bazzel/rails-templates/master/bootstrap5.rb
#
# Tested with:
# Rails 6.0.3.4
# bootstrap@5.0.0-alpha3
#
# This template sets up Bootstrap 5.
#
# But... is still work in progress
#
puts <<~CODE

  ==  Rails template for setting up Bootstrap 5  ================================
  -- see: https://v5.getbootstrap.com for more info

CODE

rails_command 'webpacker:install:stimulus'
run 'yarn add bootstrap@next popper.js'

file 'app/javascript/packs/styles.scss', <<~EOF
  @import "~bootstrap/scss/bootstrap";
EOF

inject_into_file 'app/views/layouts/application.html.erb', before: '</head>' do
  <<~ERB
    <%= stylesheet_pack_tag 'styles', media: 'all', 'data-turbolinks-track': 'reload' %>
  ERB
end

gsub_file 'config/webpacker.yml', 'extract_css: false', 'extract_css: true'
gsub_file 'app/views/layouts/application.html.erb', /(<body.+class=['"])([^'"]+)(['"])/, '\1\2 container\3'
gsub_file 'app/views/layouts/application.html.erb', '<body>', '<body class=\'container\'>'

file 'app/javascript/controllers/alert_controller.js', <<~EOF
  import { Controller } from "stimulus";
  import { Alert } from "bootstrap/dist/js/bootstrap.esm";

  export default class extends Controller {
    connect() {
      new Alert(this.element);
    }
  }
EOF

inject_into_file 'app/views/layouts/application.html.erb', before: '</head>' do
  <<~ERB
    <div
      class="alert alert-warning alert-dismissible fade show"
      role="alert"
      data-controller='alert'
      >
      <strong>Holy guacamole!</strong> You should check in on some of those fields below.
      <button type="button" class="btn-close" data-dismiss="alert" aria-label="Close"></button>
    </div>
  ERB
end
