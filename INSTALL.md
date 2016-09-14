# Installation on Heroku

The application deploys to any Heroku app that has Postgres and Redis resources attached to it. This tutorial assumes you have already created a Heroku app, and are comfortable using `git` and the Heroku toolbelt ([installation for Mac OS](https://devcenter.heroku.com/articles/heroku-command-line)) on a command-line (shell) interface.

## AWS

This application uses an AWS bucket to store uploaded images. The bucket needs to be configured with the appropriate access privileges. You can reuse the settings on the `ideamapr-prod` Heroku app if you are unsure about how to set up a bucket.

## Steps

The installation steps are:

1. Clone the code locally and use the command line to situate yourself in the root directory.
1. Add a "Git remote" that points to your Heroku app. The [Heroku tutorial for using Git](https://devcenter.heroku.com/articles/git) is helpful here.
   1. If you already have an app, named say `myappname`, on Heroku, then run this on the command line:
      ```
      heroku git:remote -a myappname
      ```
      Note that the above command is equivalent to the `git` would be `git remote add heroku git@heroku.com:myappname.git`
1. The above tutorial sets up the ID for your Heroku remote as `heroku`. If you haven't already, login to Heroku:
   ```
   heroku login
   ```
1. Run:
     ```
         git push heroku
     ```
1. After this completes, run
   ```
   heroku run rake db:migrate -a YOUR_APP_NAME
   ```
1. After this completes, you have to set up a number of "secrets" on Heroku via the admin dashboard. Go to your app in Heroku, go to _Settings_, and click on _Reveal Config Vars_. Enter values for the following keys (use the values from the	`ideamapr-prod`	app if you are unsure of any of these):
  * **ADMIN_PASSWORD**:	this should be the password for	the admin user,	whose email is always `admin@ideamapr.com`
  * **CITY_NAME**: This is the name of the city that appears in the footer.
  * **CITY_SITE_LINK**: This is the link used in the footer where the city's name is shown.
  * **GOOGLE_ANALYTICS_KEY**: the UA key from Google Analytics
  * **GOOGLE_MAPS_API_KEY**: The API key your app uses to track requests for location completion on Ideas.
  * **PROD_AWS_AKI**: Access Key Identifier for your AWS user
  * **PROD_AWS_SAK**: Secret Access Key for your AWS user
  * **PROD_S3_BUCKET**: Bucket name to store uploaded images
  * **S3_REGION**: The region of your AWS bucket.
  * **RAILS_SECRET_KEY_BASE**: a 128 bit hex string
1. Run
  ```
  heroku run rake db:seed:make_users
  ```
  This will create the admin user the first time you run it. On subsequent runs, it will update the admin password to whatever the value of `ADMIN_PASSWORD` is, in the above list. You should now be able to login via `https://yourappname.herokuapp.com/admins/sign_in`
