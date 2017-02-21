# Nopeus

Nopeus is a fork from the unsupported Shoppe gem (http://tryshoppe.com/). Nopeus is an Rails-based e-commerce platform which allows you to build a robust multitenant environment for e-commerce applications.

## Features

* An attractive & easy to use admin interface with integrated authentication
* Full product/catalogue management
* Stock control
* Tax management
* Flexible & customisable order flow
* Delivery/shipping control, management & weight-based calculation
* Multilanguage Support
* Multitenant Backend/Frontend infraestructure
* JSON REST API support

## Getting Started

The Nopeus gem provides the core framework for the store backend. As for the frontend, you can use our Edesa gem to have a full working client. A basic storefront structure will be provided but you are free to create your own storefront which your customers will use to purchase products. In addition to
creating the UI for the frontend, we'll provide some basic payment gateway integrations, but you might need to create your own dpending on the country you are based.

### Installing into a new Rails application

To get up and running a Nopeus backend instance in a new Rails application is simple. Just follow the
instructions below and you'll be up and running in minutes.

    rails new my_store
    cd my_store
    echo "gem 'nopeus'" >> Gemfile
    bundle
    rails generate nopeus:setup
    rails generate nifty:key_value_store:migration
    rake db:migrate nopeus:setup
    rails server

## Contribution

If you'd like to help with this project, please get in touch with us by e-mail at hei@votic.io.

## License

Nopeus is licenced under the MIT license. Full details can be found in the MIT-LICENSE
file in the root of the repository.
