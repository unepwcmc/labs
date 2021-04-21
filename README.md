[![Code Climate](https://codeclimate.com/github/unepwcmc/labs/badges/gpa.svg)](https://codeclimate.com/github/unepwcmc/labs)
[![Build Status](https://travis-ci.org/unepwcmc/labs.svg?branch=master)](https://travis-ci.org/unepwcmc/labs)
[![Dependency Status](https://snyk.io/test/github/unepwcmc/labs/badge.svg)](https://snyk.io/test/github/unepwcmc/labs/badge.svg)

# WCMC Labs

The homepage for the WCMC Informatics team. A basic rails app for showing off the Informatics team's projects, storing Servers, and information about the installations of projects across servers.

## Pre-requisites

Ensure you have Ruby 2.3.8 installed (with bundler version specified in bottom of Gemfile.lock).
- Rbenv: 

```
rbenv install 2.3.8
gem install bundler -v 1.17.3
```

- RVM:

```
rvm install 2.3.8
gem install bundler -v 1.17.3
```

## Setup

- Clone repo
- Run `bundle install`
- Run `cp config/secrets.yml.sample config/secrets.yml`
- *Either* run `rails secret` and update the development secret_key_base in `config/secrets.yml`
- *Or* run `sed -i -E "s/^  secret_key_base:.*/  secret_key_base: $(rake secret)/" config/secrets.yml` to update all environment entries.
- Run `yarn install`
- Run `rake db:create`, `rake db:migrate`

## Run

- Open a terminal for both: `rails s` and `./bin/webpack-dev-server`

## KPI Page

The KPI page will be initially blank if you don't have an instance of the KPI model in your database. Run `rake kpi:regenerate` to create a KPI, which should then populate the various charts on the KPI page. The data can be manually updated by running the same command if the latest data is required. 

## Deployment

* Staging: `cap staging deploy`
* Production: `cap production deploy`

## Sign In

Sign in uses Omniauth with Github, a method is then ran to query the Github API to see if the user is a member of the wcmc-core-dev team. If they are, login succeeds. If not, the login is rejected and they are directed to the root of the application.

You will need to register an application with Github to use this and stub out the is_dev_team? method to return true.

For local development, homepage URL for the github application will need to be http://0.0.0.0:3000 and Authorization Callback URL will be http://0.0.0.0:3000/users/auth/github/callback

## User Interface for displaying the Database structure of our projects in the Entity-Relationship format.

How it works:

  1. The project of which DB structure needs to be uploaded to Labs, must include the following gem into the Gemfile: `https://github.com/unepwcmc/domain_uploader`

  2. The `domain_uploader` gem includes the `rails-erd` gem which inspects the database and generates dotfiles for each entity, representing relationships in the E-R format. The `rails-erd` gem needs `graphviz` installed in the system in order to work properly.

  3. Run the following rake task to upload the current project on Labs: `bundle exec rake du:uploader['project_name','host']`, where `project_name` must match the name of the project on Labs and `host` is the host you wish to upload the domain to, so for example `http://localhost:3000` if you are trying it locally. Please note that there cannot be any space between the comma in the rake task params.

  4. On Labs you will now have a new folder in `public` which is `public/domains/project_name` with a list of .png files, each of which represents the relationships of an entity/model.

  5. On the header of the Labs website, click on `Domains` to have a list of all the uploaded domains. Then choose one by clicking on the eye looking icon.

  6. On the left of the new page you will have a list of all entities of that project and by clicking on them you will have the corresponding E-R diagrams showing as an image.


