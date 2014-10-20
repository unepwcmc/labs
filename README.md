[![Code Climate](https://codeclimate.com/github/unepwcmc/labs/badges/gpa.svg)](https://codeclimate.com/github/unepwcmc/labs)
[![Build Status](https://travis-ci.org/unepwcmc/labs.svg?branch=develop)](https://travis-ci.org/unepwcmc/labs)

# WCMC Labs

The homepage for the WCMC Informatics team. A basic rails app for showing off the Informatics team's projects, storing Servers, and information about the installations of projects across servers.

## Deployment

* Staging: `cap staging deploy`
* Production: `cap production deploy`
 
## Sign In 

Sign in uses Omniauth with Github, a method is then ran to query the Github API to see if the user is a member of the wcmc-core-dev team. If they are, login succeeds. If not, the login is rejected and they are directed to the root of the application.

You will need to register an application with Github to use this and stub out the is_dev_team? method to return true.

For local development, homepage URL for the github application will need to be http://0.0.0.0:3000 and Authorization Callback URL will be http://0.0.0.0:3000/users/auth/github/callback

