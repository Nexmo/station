# Nexmo Developer

Nexmo Developer is a platform hosting the Nexmo documentation, API reference, SDKs, Tools & Community content.

> Note: Nexmo Developer is in ongoing early stage active development. Breaking changes may be introduced at this point.

### Prerequisites

- Ruby 2.4.0 + bundler
- Postgresql
- Elasticsearch 5.2.x

### Setup

```
$ git clone git@github.com:Nexmo/nexmo-developer.git
$ cd nexmo-developer
$ cp .env.example .env
$ bundle install
$ rake db:create
$ rake db:migrate
$ ./bin/yarn install
$ rails server
```

### Compiling assets

To compile assets in runtime simply start the webpack server with:

```
$ ./bin/webpack-dev-server
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

## Contributing

Contributions are welcome, please follow [GitHub Flow](https://guides.github.com/introduction/flow/index.html)
