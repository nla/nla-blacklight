# nla-blacklight

Custom implementation of [Blacklight](http://projectblacklight.org/) for The National Library of Australia.

🚨 The versions below should match the versions available in the UBI Ruby base container image.

* Base container image: ubi8/ruby-30
* Ruby: 3.0.2
* Bundler: 2.2.22

* System dependencies
    - Solr: 8
    - MySQL: 8 (If you have an older version, you will get SSL connection errors.)

The [GoRails guide](https://gorails.com/setup) has great instructions for setting up Ruby, Rails and MySQL for your operating system.

## Configuration

All configurable values should be defined via environment variables. `dotenv` is used to load predefined values
from the `.env*` config files into the environment automatically when the application is started.

Non-sensitive values for development/test environments should be defined in the `.env.development`/`.env.test` files.

Sensitive values can be defined in `.env.development.local` or `.env.test.local` files for local development 
and *SHOULD NOT* be committed to source control. Git is configured to ignore these files.

⚠️ If `dotenv` fails to load the configuration values into the environment, you can always manually export these
values in the terminal before running the application.

### Environment Variables

#### Blacklight database
    DATABASE_URL

#### Solr
    SOLR_URL

#### Temp and caching directories
    BLACKLIGHT_TMP_PATH

#### External services
    IMAGE_SERVICE_URL

## Setup

1. Pull down the app from version control.
2. Make sure you have MySQL running locally and/or configured in the `.env.development.local` config file.
3. Make sure you have Solr running locally and/or configured in the `.env.development.local` config file.
4. `bin/setup` installs gems, npm packages, and database migrations for development/test environments.

## Running the app

1. `RAILS_ENV=<env> bin/run` runs the Rails server at 0.0.0.0:3000. Best for production.
2. `RAILS_ENV=development bin/dev` runs the SASS compiler in "watch" mode, in parallel with the Rails server.

## Tests and CI

1. `bin/ci` contains all the tests and security vulnerability checks for the app.
2. `tmp/test.log` will use the production logging format *NOT* the development one.

## Deployment

* All runtime configuration should be supplied in the UNIX environment as environment variables.
* Rails logging uses [lograge](https://github.com/roidrage/lograge). `bin/setup help` can tell you how to see this locally.
* The temporary file directory configured by the `BLACKLIGHT_TMP_PATH` must be writable by the user that runs the application.

## Security / Vulnerability Checking

The following tools provide security and vulnerability checking of the code.

* [brakeman](https://github.com/presidentbeef/brakeman) is a static analysis vulnerability checker.
    * Reports are written to `tmp/brakeman.html`
* [bundler-audit](https://github.com/rubysec/bundler-audit) checks for vulnerabilities in application dependencies.

## Containers

There is a `compose.yml` in the `./solr` directory that can be used to spin up a local Solr instance. This instance
is configured to pre-create a core named `blacklight-core`.

```bash
cd ./solr
docker compose up -d
```

You should now be able to load the Solr Dashboard at: http://127.0.0.1:8983/solr/#/

### Populating Solr Index

There is a sample of Voyager MARC records in `./solr/voy-sample` that can be used for local development.

Ensure you're connected to Solr, then execute the command below in a terminal:

```bash
bin/rails solr:marc:index MARC_FILE=./solr/voy-sample
```

## .dockerdev

This directory contains a `Dockerfile` that generates an application image based on RedHat's UBI Ruby image
(see version above).
It also includes a `compose.yml` file that defines supporting services (MySQL, Solr).

Together, [Dip](https://github.com/bibendi/dip) and the `dip.yml` configuration file provide a convenient way to
interact with a containerised local development environment. This local development image and the production
container image are the same version.

It is recommended to maintain as much parity with production as possible by upgrading the versions of these
supporting services at the same time they are upgraded by Tech Ops.
<details>
<summary>Setup details</summary>

### Install Dip

```bash
gem install dip
```

#### Common Commands

- `dip provision` pulls down container images and create containers, volumes and networks.
- `dip down --volumes` removes all containers, volumes and networks.
- `dip up` is the same as `docker-compose up`.
- `dip stop` is the same as `docker-compose stop`.
- `dip rails s` runs the Rails server at http://localhost:3000.
- `dip runner` opens a terminal in the Rails container with all supporting services.
- `dip bash` opens a terminal in the Rails container without supporting services.

### Development Workflow

```bash
dip provision # pull container images and build application image (if needed)
dip up # start all the containers
dip stop # stop all the containers

# if you need to run commands in a terminal
dip runner
```
</details>
