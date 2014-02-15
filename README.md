## Introduction

This is a collection of Rails templates.

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