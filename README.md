# Nexmo Developer

Nexmo Developer is a platform hosting the Nexmo documentation, API reference, SDKs, Tools & Community content.

> Note: Nexmo Developer is in ongoing early stage active development. Breaking changes may be introduced at this point.

### Prerequisites

- Ruby 2.4.0 + bundler
- Postgresql

### Setup

```
$ git clone git@github.com:Nexmo/nexmo-developer.git
$ cd nexmo-developer
$ cp .env.example .env
$ bundle install
$ rake db:create
$ rake db:migrate
$ rails server
```

### Features

- A powerful markup engine with pipeline (see [this blog post](https://lab.io/articles/2017/02/12/extending-markdown-with-middleware/) for details on how this works).
- Automatically generated navigation based on the contents of `_documentation`.
- Turbolinks for progressively loading content into for a seamless user experience.

### Future Features

- Dynamic content for community section
- Interactive examples of the Nexmo APIs

## Contributing

Contributions are welcome, please follow [GitHub Flow](https://guides.github.com/introduction/flow/index.html)
