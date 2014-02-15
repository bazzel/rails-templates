## Introduction

This is a collection of Rails templates:

|Template|Description|
|--------|-----------|
|ember|Sets up [Ember.JS](http://emberjs.com/) using the [ember-rails](https://github.com/emberjs/ember-rails) gem. It updates your environment files (`environment.rb`, `development.rb`, `production.rb`), adds `require`'s to `app.js.coffee`, lets you choose which channel to download (release, beta, canary) and creates enough backend code to get started|
|ember-list-data|This templates asks for a model name and creates a Rails model, a Rails controller with an index action, generates  random data, creates an Ember route and an Ember template|



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
