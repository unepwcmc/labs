[![Code Climate](https://codeclimate.com/github/unepwcmc/labs/badges/gpa.svg)](https://codeclimate.com/github/unepwcmc/labs)
[![Build Status](https://travis-ci.org/unepwcmc/labs.svg?branch=master)](https://travis-ci.org/unepwcmc/labs)
[![Dependency Status](https://snyk.io/test/github/unepwcmc/labs/badge.svg)](https://snyk.io/test/github/unepwcmc/labs/badge.svg)

# WCMC Labs

The homepage for the WCMC Informatics team. A basic rails app for showing off the Informatics team's products, storing Servers, and information about the installations of products across servers.

## Setup

- Clone repo
- Run `bundle install`
- Run `rake db:create`, `rake db:migrate`
- Run `rails secret` and populate `config/secrets.yml` according to 
  `secrets.yml.sample` which gives guidance on how to access the secrets.
  [The Teams wiki](https://teams.microsoft.com/l/entity/com.microsoft.teamspace.tab.wiki/tab::b2573265-0479-4589-905a-86cc6d6db74f?context=%7B%22subEntityId%22%3A%22%7B%5C%22pageId%5C%22%3A7%2C%5C%22sectionId%5C%22%3A14%2C%5C%22origin%5C%22%3A2%7D%22%2C%22channelId%22%3A%2219%3A2c43334822444bff812af4c30f423ceb%40thread.tacv2%22%7D&tenantId=2faab858-d1f4-48af-86f6-486196d5969d)
  may also be helpful.
- Run `yarn install`

## KPI Page

**NB: Make sure you have the secrets populated before running this task, else it will fail as it expects certain secrets to be present!**

The KPI page will be initially blank if you don't have an instance of the KPI model in your database. Run `rake kpi:regenerate` to create a KPI, which should then populate the various charts on the KPI page. The data can be manually updated by running the same command if the latest data is required. 

### Google Analytics

This requires a bit more nuance compared to the standard KPI fields. Please note that the code applies to, and was built around, v4 of the Google Analytics API, and so in future if the response from the API changes in terms of output, then it will be the maintainers' responsibility to fix this.

1. Get a copy of the Service Account Credentials from Lastpass > Development Environments. Store that in the root of your repository.
The GoogleAnalytics::Base class specifically looks for it in that location to authenticate you against Google.
1. You need to have the correct GA tracking codes in for each project that's tracked via GA and and is also present on Labs, prior to running the KPI regeneration rake task, which now also includes a way to generate GA user counts (in the last 90 days) for each project.

There is a field in the Edit view of a product for entering in the Google Analytics View ID code for that particular product. Please note that this is **not** the Account ID, rather this is the View ID, which only ever contains numbers. To identify this, within the Google Analytics Dashboard, from the main menu, look for the Views column for each project, which should always contain 'All Web Site Data' as the default. Underneath each view is the View ID. Also whenever possible, use the code which corresponds to views that exclude the WCMC office as that is most reliable. When you then run the Rake task, it will compute the user counts for each project which has a tracking code and then updates the list of projects and KPI page accordingly. 

## Reviews

If the review questions are not showing, you may need to uun `rake review:load` to populate the review questions from `db/review_template.json`

## Deployment

* Staging: `cap staging deploy`
* Production: `cap production deploy`

## Sign In

Sign in uses Omniauth with Github, a method is then ran to query the Github API to see if the user is a member of the wcmc-core-dev team. If they are, login succeeds. If not, the login is rejected and they are directed to the root of the application.

You will need to register an application with Github to use this and stub out the is_dev_team? method to return true.

For local development, homepage URL for the github application will need to be http://0.0.0.0:3000 and Authorization Callback URL will be http://0.0.0.0:3000/users/auth/github/callback

## User Interface for displaying the Database structure of our products in the Entity-Relationship format.

How it works:

  1. The product of which DB structure needs to be uploaded to Labs, must include the following gem into the Gemfile: `https://github.com/unepwcmc/domain_uploader`

  2. The `domain_uploader` gem includes the `rails-erd` gem which inspects the database and generates dotfiles for each entity, representing relationships in the E-R format. The `rails-erd` gem needs `graphviz` installed in the system in order to work properly.

  3. Run the following rake task to upload the current product on Labs: `bundle exec rake du:uploader['product_name','host']`, where `product_name` must match the name of the product on Labs and `host` is the host you wish to upload the domain to, so for example `http://localhost:3000` if you are trying it locally. Please note that there cannot be any space between the comma in the rake task params.

  4. On Labs you will now have a new folder in `public` which is `public/domains/product_name` with a list of .png files, each of which represents the relationships of an entity/model.

  5. On the header of the Labs website, click on `Domains` to have a list of all the uploaded domains. Then choose one by clicking on the eye looking icon.

  6. On the left of the new page you will have a list of all entities of that product and by clicking on them you will have the corresponding E-R diagrams showing as an image.


