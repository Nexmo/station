# Nexmo Developer Gem

The `nexmo-developer` gem provides a documentation platform ready to use with your custom documentation. This document will cover installation and usage instructions.

* [Installation](#installation)
* [Usage](#usage)

## Installation

You can use this gem from within your documentation. 

To install the gem, create a `Gemfile` in the root folder of your documentation files and add the following inside it:

```ruby
source "https://rubygems.pkg.github.com/nexmo" do
  gem "nexmo-developer"
end
```

Then, run `bundle install` from the command line. If this is your first time installing a gem from the GitHub Package Registry, follow these [setup instructions](https://help.github.com/en/packages/using-github-packages-with-your-projects-ecosystem/configuring-rubygems-for-use-with-github-packages).

## Usage 

This section will cover:

* [Documentation Organization](#documentation-organization)
* [Configuration Files](#configuration-files)
* [Running the Gem](#running-the-gem)

### Documentation Organization

First, it is important that your documentation is organized in the way the gem expects.

The gem expects the documentation to be markdown files within the following folders:

```sh
+-- _open_api
+-- _use_cases
+-- _documentation
+-- _tutorials
```

### Configuration Files

Customization for the documentation portal is inside the `/config` folder. 

#### Custom Views

All `nexmo-developer` static views can be redefined inside `/config/views` by providing custom ERB files.

_ERB, or embedded Ruby, are HTML files that combine Ruby to produce dynamic content._

The following ERB files can be provided to override the default views:

* `/config/views/static/landing.html.erb`: The default home page
* `/config/views/layout/partials/_footer.html.erb`: The footer
* `/config/views/layout/partials/_header.html.erb`: The header
* `/config/views/layout/partials/_head.html.erb`: The head file (meta tags, Google analytics info, and more)

#### Custom Landing Pages

Customized landing pages is a powerful feature of the `nexmo-developer` gem that provides the ability to create unique content using only YAML files. 

All custom landing page YAML files should be placed inside `/config/views/landing_pages`. 

The URL path is defined by the file path. For example, a file placed inside `/config/views/landing_pages/tools.yml` would be viewed at `https://[YOUR WEBSITE URL]/tools`. 

Instructions for creating custom landing pages can be found [here](https://developer.nexmo.com/contribute/guides/landing-pages).

### Running The Gem

Once you have installed the gem and ran through the configurations, you can start it. 

To start the gem run the following from the command line:

```sh
$ OAS_PATH=[PATH TO _open_api folder] RAILS_SERVE_STATIC_FILES=true DISABLE_SSL=1 RACK_ENV=production RAILS_ENV=production bundle exec nexmo-developer --docs=[PATH TO DOCUMENTATION]
```

For example, if your documentation is at `/Users/sample_user/Documents/sample_docs` and your `_open_api` folder is at `/Users/sample_user/Documents/sample_docs/_open_api` then you would start `nexmo-developer` with the following command:

```sh
$ OAS_PATH=/Users/sample_user/Documents/sample_docs/_open_api RAILS_SERVE_STATIC_FILES=true DISABLE_SSL=1 RACK_ENV=production RAILS_ENV=production bundle exec nexmo-developer --docs=/Users/sample_user/Documents/sample_docs
```