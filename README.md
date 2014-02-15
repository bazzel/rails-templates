## Introduction

This is a collection of Rails templates:

|Template|Description|
|--------|-----------|
|ember|Sets up [Ember.JS](http://emberjs.com/) using the [ember-rails](https://github.com/emberjs/ember-rails) gem. It updates your environment files (`environment.rb`, `development.rb`, `production.rb`), adds `require`'s to `app.js.coffee`, lets you choose which channel to download (release, beta, canary) and creates enough backend code to get started.|
|ember-list-data|Asks for a model name and creates a Rails model, a controller with an index action, generates random data and creates an Ember route and template.|
|ember-infinite-scroll|Downloads a [Gist](https://gist.github.com/bazzel/8905925) containing Ember Mixins for extending views and controllers for infinite scrolling, installs [`will_paginate`](https://github.com/mislav/will_paginate) to implement server side pagination.|
|ember-list-view|sets up [`Ember.ListView`](https://github.com/emberjs/list-view) as described on the site and downloads a [Gist](https://gist.github.com/bazzel/8962240) containing an Ember Mixin for changing width and height of the ListView during runtime|
|ember-simple-auth|Sets up [`Ember.SimpleAuth`](http://ember-simple-auth.simplabs.com) as described on the site, sets up simple authentication inspired by [RailsCast #250](http://railscasts.com/episodes/250-authentication-from-scratch) and shows an error message when authentication fails with a X to close the message.|
|foundation|Sets up Zurb Foundation. Also applicable if you've setup your application to run Ember.|


## Requirements

This code has been run and tested on Ruby 2.0 and Ruby on Rails 4.0.2.

## Installation

All templates depend on files located in the `utils` folder.

Currently I honestly don't know how to require these files without you having to clone the repository to a local folder. Apart from that, all is working fine.

    git clone https://github.com/bazzel/rails-templates.git /path/to/local/folder

## Example Usage

To create a new Rails application with one of the templates:

    rails new [app] -m /path/to/local/folder/[template].rb

To apply a template to an existing Rails application:

    cd [app]
    rake rails:template LOCATION=/path/to/local/folder/[template].rb

## License

This project is licensed under the MIT license, a copy of which can be found in the LICENSE file.
