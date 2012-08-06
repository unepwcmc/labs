# WCMC Labs

The homepage for the WCMC Informatics team. A basic rails app with a `rails_admin` backend for showing off the Informatics team's projects.

## Deployment

* Staging: `cap staging deploy`
* Production: `cap production deploy`
 
## Admin user
Add a new Devise user with:

`User.create(:email=>"test@test.com", :password=>"123", :password_confirmation=>"123").save(:validate=>false)`