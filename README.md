# nla-blacklight

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/nla/nla-blacklight/verify.yml?branch=main&logo=github)](https://github.com/nla/nla-blacklight/actions/workflows/verify.yml)
[![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/nla/nla-blacklight?include_prereleases)](https://github.com/nla/nla-blacklight/releases/latest)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)

Custom implementation of [Blacklight](http://projectblacklight.org/) for The National Library of Australia.

## Table of Contents

* [Requirements](#requirements)
* [Configuration](#configuration)
    + [Environment Variables](#environment-variables)
        - [Blacklight database](#blacklight-database)
        - [Solr](#solr)
        - [Temp and caching directories](#temp-and-caching-directories)
        - [External services](#external-services)
        - [Rails settings](#rails-settings)
* [Setup](#setup)
* [Running the app](#running-the-app)
* [Tests](#tests)
* [Continuous Integration](#continuous-integration)
    + [Releases](#releases)
* [Deployment](#deployment)
* [Linting, Static Analysis & Supply Chain Vulnerability Checking](#linting--static-analysis---supply-chain-vulnerability-checking)

## Requirements

* Ruby: 3.2.2
* Bundler: 2.4.22

* System dependencies
    - Solr: 8
    - MySQL: 8
    - Redis: 7

* Gems:
  - [blacklight-common](https://github.com/nla/nla-blacklight_common) 
  - [blacklight-solrcloud-repository](https://github.com/nla/blacklight-solrcloud-repository)
  - [bento_search](https://github.com/nla/bento_search)

## Contributing

The [GoRails guide](https://gorails.com/setup) has great instructions for setting up Ruby, Rails and MySQL for your operating system.

✏️ This repository uses [conventional commits](https://www.conventionalcommits.org)
and commit messages are used to generate `CHANGELOG.md` and release body entries.

The most important prefixes you should have in mind are:

* `fix:` which represents bug fixes, and correlates to a SemVer patch.
* `feat:` which represents a new feature, and correlates to a SemVer minor.
* `feat!:`, or `fix!:`, `refactor!:`, etc., which represent a breaking change (indicated by the !) and will result in a SemVer major.

Releases are automated via GitHub workflows. See more in the ["Releases"](#releases) section.

## Configuration

All configurable values should be defined via environment variables. `dotenv` will automatically load values
from the `.env*` config in development and test environments.

Non-sensitive values for development and test environments should be defined in the `.env.development`/`.env.test` files.

Sensitive values can be defined in `.env.development.local` or `.env.test.local` files for local development
and *SHOULD NOT* be committed to source control. Git is configured to ignore these files.

⚠️ If `dotenv` fails to load the configuration values into the environment, you can manually export these
values in your terminal before running the application.

<details>
<summary><b>List of Environment Variables</b></summary>

#### Blacklight database
    DATABASE_URL - Application database for Blacklight
    PATRON_DB_URL - Shared user and sessions database
    REDIS_URL - Redis cache

#### Solr
    SOLR_URL - single node Solr
    
    ZK_HOST - Zookeeper connection string for the Solr Cloud cluster
    SOLR_COLLECTION - Solr Cloud collection for the catalogue index

#### Rails settings
These variables are mainly used in the `staging` or `production` environment.

    SECRET_KEY_BASE - used by Devise for encrypting session values
    RAILS_LOG_TO_STDOUT - makes Rails logs print to the console
    RAILS_SERVE_STATIC_FILES - tells Rails to serve static assets from the /public directory

#### Temp and caching directories
These variables are mainly used in the `staging` or `production` environment.

    PIDFILE - relocates the server pid file outside of the application directory
    BLACKLIGHT_TMP_PATH - relocates the caching directory outside of the application directory

#### External services
    GETALIBRARYCARD_BASE_URL - base URL for Get a Library Card
    GETALIBRARYCARD_AUTH_PATH - path to the authentication endpoint of Get a Library Card
    GETALIBRARYCARD_PATRON_DETAILS_PATH - path to the user details endpoint of Get a Library Card

    PATRON_AUTH_URL - base URL for User Registration (a.k.a. "UserReg")
    PATRON_AUTH_ENDPOINT - path to the authentication endpoint

    KEYCLOAK_URL - URL of the Keycloak server

    KC_SOL_CLIENT - Staff Official Loan realm client name
    KC_SOL_SECRET - Staff Official Loan realm client secret
    KC_SOL_REALM - realm name for Staff Official Loan

    KC_SPL_CLIENT - Staff Personal Loan realm client name
    KC_SPL_SECRET - Staff Personal Loan realm client secret
    KC_SPL_REALM - realm name for Staff Personal Loan

    KC_SHARED_CLIENT - Team Official Loan account realm client name
    KC_SHARED_SECRET - Team Official Loan account realm client secret
    KC_SHARED_REALM - realm name for Team Official Loan account realm

    COPYRIGHT_SERVICE_URL - URL of the Copyright service
    COPYRIGHT_FAIR_DEALING_URL - URL to the page describing copyright fair dealing
    COPYRIGHT_CONTACT_URL - URL to the page describing how to contact the Library about copyright
    
    COPIES_DIRECT_URL - URL to Copies Direct

    ERESOURCES_CONFIG_URL - URL to the eResources configuration JSON endpoint
    EZPROXY_URL - URL to the EZProxy server
    EZPROXY_USER - username for EZProxy
    EZPROXY_PASSWORD - password for EZProxy

    EDS_DEBUG - set to `y`/`n` to enable/disable debug logging for EDS API requests
    EDS_PROFILE - EDS profile name
    EDS_GUEST - set to `y`/`n` to enable/disable guest access for EDS API requests
    EDS_USER - username for EDS API requests
    EDS_PASSWORD - password for EDS API requests
    EDS_AUTH - authentication method for EDS API requests
    EDS_ORG - organisation ID for EDS API requests
    EDS_CACHE_DIR - directory for EDS API request caching

    EBSCO_SEARCH_URL - URL to the EBSCO EDS API
    CATALOGUE_SEARCH_URL - URL to the Catalogue search JSON endpoint
    FINDING_AIDS_SEARCH_URL - URL to the Finding Aids search JSON endpoint

    GLOBAL_MESSAGE_URL - URL to the global alert message JSON endpoint

    CATALOGUE_SERVICES_API_BASE_URL - URL to the Catalogue Services API base URL
    CATALOGUE_SERVICES_CLIENT - Catalogue Services realm client name
    CATALOGUE_SERVICES_SECRET - Catalogue Services realm client secret
    CATALOGUE_SERVICES_REALM - Catalogue Services realm name
    
    THUMBNAIL_SERVICE_API_BASE_URL - URL to the thumbnail service API base URL
</details>

## Setup

1. Clone the app from GitHub.
2. Make sure you have MySQL running locally and configured in the `.env.development.local` config file.
3. Make sure you have Redis running locally and configured in the `.env.development.local` config file.
4. Make sure you have Solr running locally and configured in the `.env.development.local` config file.<br />💡️  If you are not planning on modifying the Solr index, you can point this at the  devel or test environment Solr cluster.
5. `bin/setup` installs gems and performs database migrations for the `development` environment.<br /> 💡️ Gems are installed in `vendor/bundle`.

## Running the app

* `bin/dev` runs the Rails server at http://localhost:3000.
    * This will compile the SASS stylesheets and package up the JavaScript files for the asset pipeline. 
    * By default Rails will load the `development` environment.
    * The runtime environment can be changed by defining `RAILS_ENV` before executing a command/script. e.g.

```bash
RAILS_ENV=test bin/dev
```

## Tests

* `bin/ci` contains all the tests and security vulnerability checks for the app.
* `tmp/test.log` will use the production logging format *NOT* the development one.
* The following test frameworks are used:
    * [RSpec](https://rspec.info/)
    * [Capybara](http://teamcapybara.github.io/capybara/) - simulates web application interaction
    * [Webmock](https://github.com/bblimke/webmock) - HTTP request mocking and stubbing

## Continuous Integration

* CI is performed by [GitHub Actions](https://docs.github.com/en/actions).
* Workflows are defined in `.github/workflows`.

### Releases

Releases are automated via the `release.yml` GitHub workflow. This uses Google's
[release-please action](https://github.com/google-github-actions/release-please-action) to create a 
release pull request when changes are pushed to the `main` branch. 

🚨 This release pull request will be updated with every merge to the `main` branch. 

🚨 It will bump the version automatically and create a release when it is merged.

🚨 `CHANGELOG.md` is automatically created/updated for each release based on the commit messages.

Read more about how
[release-please](https://github.com/googleapis/release-please) works.

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
* [strong-migrations](https://github.com/ankane/strong_migrations) catches unsafe migrations in development.

## License
The application is available as open source under the terms of the [Apache 2 License](https://opensource.org/licenses/Apache-2.0).
