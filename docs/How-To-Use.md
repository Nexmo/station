---
title: "How To Use"
permalink: /How-To-Use
---

# Contents

1. [Content Structure and Files](#content-structure-and-files)
    1. [File Organization](#file-organization)
    2. [Configuration Files](#configuration-files)
    3. [Customization Options](#customization-options)
2. [Running Station](#running-station)
    1. [Running Standalone](#running-standalone)
    2. [Running With Docker](#running-with-docker)

## Content Structure and Files

Station requires the content served by the platform to be organized in a defined way. The platform will not start if the folder structure is not present in the content path provided during initialization.

Additionally, Station offers a lot of opportunities to customize the platform for unique needs.

This section will go through each of these areas.

### File Organization

Inside the top-level folder of the content there must be the following folders:

```
+-- _use_cases
+-- _documentation
+-- _tutorials
+-- public
+-- config
```

If you wish to include API specification reference documents you should also include a `_open_api` folder in the top-level of your folder structure as well.

### Configuration Files

All configuration files are written in YAML. The [Official YAML Web Site](https://yaml.org/) provides instructions on YAML formatting and specifications.

There are [same configuration files](https://github.com/Nexmo/station/blob/master/sample_config_files/config) provided in this repository that can be used to provide a template for the configuration files for your instance of Station.

All configuration files are placed inside the `/config` folder.

The files required are:

* `business_info.yml`: Specific business/organizational information for the platform. This includes the platform name, the path to the header and footer logos, and more.
* `top_navigation.yml`: The links for the top navigation bar of the platform. 
* `meta_info.yml`: Information used to generate the links in the platform's `<head>` tags, such as search engine optimization details.
* `products.yml`: A list of each product or item covered in the platform's content. The icon, documentation path and color schema for each product is also specified here.

In addition to the above configuration files, Station also expects the following files to be created and placed inside the `/public/meta` path. These files are meta icons also used in the generation of the `<head>` content:

* `og.png`
* `apple-touch-icon.png`
* `safari-pinned-tab.svg`
* `mstile-144x144.png`
* `favicon.ico`
* `favicon-32x32.png`
* `manifest.json`

Specific credentials and identification information for different third-party services can be included in the platform by placing them inside a dotenv file in the top-leve folder of the content. There is a [sample .env file](https://github.com/Nexmo/station/blob/master/.env.example) provided in this repository.

### Customization Options

Station provides many opportunities to customize the presentation of the platform. This section will walk through each possibility.

#### Custom Views

Custom views can be provided that override the defaults in Station. A sample [custom views folder](https://github.com/Nexmo/station/blob/master/sample_config_files/custom/views) can be found in this repository.

To provide your own custom view for a Station view place it inside `/custom/views`.

The file should be an ERB file. ERB, or embedded Ruby, are HTML files that combine Ruby to product dynamic content. The [Ruby documentation](https://docs.ruby-lang.org/en/2.3.0/ERB.html) provides detailed instructions on how to write with ERB.

#### Custom Landing Pages

Landing Pages are a feature of Station that enables content creators to introduce unique website pages using only YAML to create the content.

A [sample landing pages folder](https://github.com/Nexmo/station/blob/master/sample_config_files/custom/landing_pages) has been provided in this repository to offer examples.

All landing pages should be placed inside `/custom/landing_pages`. The URL path is defined by the file path. For example, a file placed inside `/custom/landing_pages/events/myevent.yml` would be viewed in the browser at `https://example.com/events/myevent`.

Detailed instructions are available in the [Contribution Guide](https://developer.nexmo.com/contribute/guides/landing-pages) on creating landing pages.

#### Custom Public Path

Custom assets, such as images and icons, can be provided in the `/public` folder. They then can be referenced inside custom views. For example, if the following image is added inside `/public/assets/media/logos/sample_image.png` then it could be referenced using ERB syntax as follows:

```ruby
<%= image_tag('/assets/media/logos/sample_image.png') %>
```

#### Custom Locale Settings

Station supports internationalization for different spoken languages. Content translations can be provided inside the `/custom/locales` folder. A [sample locales folder](https://github.com/Nexmo/station/blob/master/sample_config_files/config/locales) has been provided inside Station with examples of locale configuration files.

## Running Station

Station can be run either standalone on your system or in Docker with the provided Docker image. 

### Running Standalone

Once you have installed Station and ran through the configurations, you can start it.

To start the gem run the following from the command line:

```bash
$ OAS_PATH=[PATH TO _open_api folder] bundle exec nexmo-developer --docs=[PATH TO DOCUMENTATION]
```

For example, if your documentation is at `/Users/sample_user/Documents/sample_docs` and your `_open_api folder` is at `/Users/sample_user/Documents/sample_docs/_open_api` then you would start nexmo-developer with the following command:

```bash
$ OAS_PATH=/Users/sample_user/Documents/sample_docs/_open_api
```

The `OAS_PATH` environment variable passed in during runtime can also be provided in the dotenv file mentioned above in the instructions.

### Running With Docker

Station is available as a Docker image at `nemxodev/station`. You can run it from your documentation directory using the following command:

```bash
docker run -p 3000:3000 -v /path/to/docs:/docs -t nexmodev/station
```

Any functionality requiring a database (such as redirects or feedback) will not work using this method. For a docker-based setup that includes a database add the following `docker-compose.yml` file to your project:

```
version: "3"
services:
  db:
    image: postgres
    environment:
      - POSTGRES_HOST_AUTH_METHOD=trust
      - POSTGRES_USER=nexmo_developer
      - POSTGRES_DB=nexmo_developer_production
  web:
    image: nexmodev/station:latest
    volumes:
      - .:/docs
    ports:
      - "3000:3000"
    depends_on:
      - db
    environment:
      - POSTGRES_HOST=db
```

After running `docker-compose up`, you will need to run `docker-compose run web bundle exec rake db:migrate` to initialise the database.
