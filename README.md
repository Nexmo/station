# Nexmo Developer

Nexmo Developer is a platform hosting the Nexmo documentation, API reference, SDKs, Tools & Community content.

### Prerequisites

- Ruby 2.4.1 + bundler
- PostgreSQL
- Yarn

### Setup

```
$ git clone git@github.com:Nexmo/nexmo-developer.git
$ cd nexmo-developer
$ cp .env.example .env
$ bundle install
$ rake db:create
$ rake db:migrate
$ ./bin/yarn install
$ foreman start
```

### Setting up with Docker

If you don't want to install Ruby & PostgreSQL then you can use docker to sandbox Nexmo Developer into its own containers. After you [Install Docker](https://docs.docker.com/engine/installation/) run the following:

```
# Start the web server
$ docker-compose up

# Setup the Database (you only need to do this once)
$ docker-compose run web rake db:setup

# Open the browser
$ open http://localhost:3000
```

You will still need to run the webpack-dev-server on your local machine.

To stop the server cleanly run:

```
$ docker-compose down
```

### Compiling assets

To compile assets in runtime simply start the webpack server with:

```
$ ./bin/webpack-dev-server
```

You can run both the Rails server and Webpack simultaneously using Foreman:

```
$ foreman start
```

### Features

- A powerful markup engine with pipeline (see [this blog post](https://lab.io/articles/2017/02/12/extending-markdown-with-middleware/) for details on how this works).
- Automatically generated navigation based on the contents of `_documentation`.
- Turbolinks for progressively loading content into for a seamless user experience.

### Future Features

- Dynamic content for community section
- Interactive examples of the Nexmo APIs

## Pulling in code from other repos

Some examples require code from repos such as [nexmo-community/nexmo-ruby-quickstart](https://github.com/nexmo-community/nexmo-ruby-quickstart) these repos can be defined in `config/repos.yml` as such:

```
nexmo-community/nexmo-ruby-quickstart: 'master'
```

The code can then be pulled into the `.repo` directory with the following command:

```
$ rake repos:pull
```

To pull a single repo provide the GitHub repo name and optional branch:

```
$ rake repos:pull nexmo-community/nexmo-ruby-quickstart master
```

### Pre-Commit hooks

This repository uses Yelp's [Pre-Commit framework](http://pre-commit.com/) for managing shared pre-commit hooks.

These include checks to ensure syntactic validity of XML, JSON and YAML files, as well as unfinished merge conflicts and case conflicts in filenames.

This is optional. See the pre-commit website for installation instructions.

## Troubleshooting

#### I'm getting an error `A server is already running.  Check /myapp/tmp/pids/server.pid.` when I run `docker-compose up`.

This is because Docker wasn't shut down cleanly. To fix this run:

```
$ docker-compose run web rm /myapp/tmp/pids/server.pid
```

#### A webpack error occurs during setup

Run the `webpack-dev-server` like so:

```
$ ./bin/webpack-dev-server
```

## Contributing

Contributions are welcome, please follow [GitHub Flow](https://guides.github.com/introduction/flow/index.html)

## License

See the `LICENSE.txt` file for full licenses. The code is licensed under the MIT License; documentation is licensed under both the MIT License and the Creative Commons Attribution 4.0 International license.

Copyright &copy; 2017 Nexmo.
