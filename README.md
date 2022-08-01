# nla-blacklight

Custom implementation of [Blacklight](http://projectblacklight.org/) for The National Library of Australia.

## Requirements

* Ruby: 3.0.2
* Bundler: 2.2.22

* System dependencies
    - Solr: 8
    - MySQL: 8

The [GoRails guide](https://gorails.com/setup) has great instructions for setting up Ruby, Rails and MySQL for your operating system.

## Configuration

All configurable values should be defined via environment variables. `dotenv` will automatically load values
from the `.env*` config in development and test environments.

Non-sensitive values for development and test environments should be defined in the `.env.development`/`.env.test` files.

Sensitive values can be defined in `.env.development.local` or `.env.test.local` files for local development 
and *SHOULD NOT* be committed to source control. Git is configured to ignore these files.

⚠️ If `dotenv` fails to load the configuration values into the environment, you can manually export these
values in your terminal before running the application.

### Environment Variables

#### Blacklight database
    DATABASE_URL

#### Solr
    SOLR_URL

#### Temp and caching directories
    PIDFILE - relocates the server pid file outside of the application directory
    BLACKLIGHT_TMP_PATH - relocates the caching directory outside of the application directory

#### External services
    IMAGE_SERVICE_URL

    GETALIBRARYCARD_BASE_URL - base URL for Get a Library Card
    GETALIBRARYCARD_AUTH_PATH - path to the authentication endpoint of Get a Library Card
    GETALIBRARYCARD_PATRON_DETAILS_PATH - path to the user details endpoint of Get a Library Card

## Setup

1. Pull down the app from version control.
2. Make sure you have MySQL running locally and configured in the `.env.development.local` config file.
3. Make sure you have Solr running locally and configured in the `.env.development.local` config file.
4. `bin/setup` installs gems, npm packages, and database migrations for development/test environments.
5. Install [Podman](https://podman.io/), [Podman Desktop](https://podman-desktop.io/) and [podman-compose](https://github.com/containers/podman-compose).

## Running the app

* `RAILS_ENV=<env> bin/run` runs the Rails server at 0.0.0.0:3000.

## Tests and CI

* `bin/ci` contains all the tests and security vulnerability checks for the app.
* `tmp/test.log` will use the production logging format *NOT* the development one.
* The following test frameworks are used:
    * RSpec - for BDD testing
    * Cucumber - for acceptance testing
    * Capybara - simulates web application interaction
    * Webmock - HTTP request mocking and stubbing
    * VCR - Mock HTTP responses with canned data
* 🚨 Some tests require a Zookeeper + SolrCloud cluster running locally. See [Containers](#containers) section below.

## Deployment

* All runtime configuration should be supplied as environment variables.
* Rails logging uses [lograge](https://github.com/roidrage/lograge). `bin/setup help` can tell you how to see this locally.
* The temporary file directory configured by the `BLACKLIGHT_TMP_PATH` must be writable by the user that runs the application.
* Gems declared in the Gemfile are installed in the `vendor/bundle` directory.
* Rails assets must be precompiled before deployment and `RAILS_SERVE_STATIC_FILES` set to `true` in order for files in the `public` directory to be accessible.
* `RAILS_LOG_TO_STDOUT` must be set to `true` for logs to be sent to the console.

## Linting, Static Analysis & Supply Chain Vulnerability Checking

The following tools provide linting, security and vulnerability checking of the code.

* [rubocop](https://rubocop.org/) and [standardrb](https://github.com/testdouble/standard) ensure standardised code formatting and best practices.
* [brakeman](https://github.com/presidentbeef/brakeman) provides static analysis checking.
    * Reports are written to `tmp/brakeman.html`
* [bundler-audit](https://github.com/rubysec/bundler-audit) checks application dependencies for security vulnerabilities.

## Containers

### Single-node Solr

`./solr/docker-compose.yml` can be used to spin up a local Solr instance. This instance is configured to pre-create a core named `blacklight`.

```bash
podman-compose -f ./solr/docker-compose.yml up -d
```

You should now be able to load the Solr Dashboard at: http://127.0.0.1:8983/solr/#/

### Zookeeper + SolrCloud cluster

`./solr/cloud/docker-compose.yml` can be used to spin up a local Zookeeper + SolrCloud cluster.
This cluster is required by the RSpec tests for `Blacklight::Solr::Cloud::Repository`.

In order to run this cluster successfully, you'll need a Podman machine with at least 4GB of memory and 6GB of disk space.

The Podman machine created below will be initialised with 2 CPUs and 6GB of memory and disk space.

```bash
podman machine init--cpus 2 --disk-size 6144 --memory 6144       # initialise a Podman machine
podman-compose -f ./solr/cloud/docker-compose.yml up -d          # spin up a ZK + SolrCloud cluster
podman-compose -f ./solr/cloud/docker-compose.yml down --volumes # pull down the ZK + SolrCloud cluster
```

The cluster Solr Dashboard is located at: http://127.0.0.1:8983/solr/#/

### Populating a local Solr index

There is a sample of Voyager MARC records in `./solr/voy-sample` that can be used for local development.

Ensure you're connected to Solr, then execute the command below in a terminal:

```bash
bin/rails solr:marc:index MARC_FILE=./solr/voy-sample
```
