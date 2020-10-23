# Using this template

1. Search for `TODO` across the repository to customise the template to the new
  project
1. Be aware of [dxw RFCs](https://github.com/dxw/tech-team-rfcs), especially
  those that have not resulted in a default code change in this repository:
  - [rfc-013-use-docker-to-deploy-and-run-applications-in-containers](https://github.com/dxw/tech-team-rfcs/blob/master/rfc-013-use-docker-to-deploy-and-run-applications-in-containers.md)

TODO: Remove this section from the README once complete

---

# Buy for your school

A service to help school buying professionals create tender documents that comply with the relevant government policy. These tender documents can then be used to start a procurement process saving schools time and money.

## Getting started

1. `brew install postgres`
1. `brew services start postgres`
1. `createuser postgres --super`
1. copy `/.env.example` into `/.env.development.local`.

  Our intention is that the example should include enough to get the application started quickly. If this is not the case, please ask another developer for a copy of their `/.env.development.local` file.
1. `rbenv install 2.6.3 && rbenv local 2.6.3`
1. `gem install bundle`
1. `bundle`
1. `rake db:setup && RAILS_ENV=test rake db:setup`
1. `rails server`
1. Visit http://localhost:3000

## Running the tests

### The whole test suite

`bundle exec rake`

### RSpec only

`bundle exec rspec`

## Running Brakeman

Run [Brakeman](https://brakemanscanner.org/) to highlight any security vulnerabilities:
```bash
brakeman
```

To pipe the results to a file:
```bash
brakeman -o report.text
```

## Making changes

When making a change, update the [changelog](CHANGELOG.md) using the
[Keep a Changelog 1.0.0](https://keepachangelog.com/en/1.0.0/) format. Pull
requests should not be merged before any relevant updates are made.

## Releasing changes

When making a new release, update the [changelog](CHANGELOG.md) in the release
pull request.

## Architecture decision records

We use ADRs to document architectural decisions that we make. They can be found
in doc/architecture/decisions and contributed to with the
[adr-tools](https://github.com/npryce/adr-tools).

## Managing environment variables

We use [Dotenv](https://github.com/bkeepers/dotenv) to manage our environment variables locally.

The repository will include safe defaults for development in `/.env.example` and for test in `/.env.test`. We use 'example' instead of 'development' (from the Dotenv docs) to be consistent with current dxw conventions and to make it more explicit that these values are not to be committed.

To manage sensitive environment variables:

1. Add the new key and safe default value to the `/.env.example` file eg. `ROLLBAR_TOKEN=ROLLBAR_TOKEN`
2. Add the new key and real value to your local `/.env.development.local` file, which should never be checked into Git. This file will look something like `ROLLBAR_TOKEN=123456789`

## Access

TODO: Where can people find the service and the different environments?

## Source

This repository was bootstrapped from
[dxw's `rails-template`](https://github.com/dxw/rails-template).
