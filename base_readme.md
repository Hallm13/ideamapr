# README

## Introduction

This Rails 4.2 app sets up the basic code for a skeleton app:

* There some basic models, each meant to do somethign interesting:
  * Task: It borrows code from a standard scaffold structure. It showcases a simple association - belongs_to :owner, class_name: "User"
  * Location: It showcases geocoding.
* Devise and Cancan are set up:
  * Devise uses User as the model for authentication; no other config changes are made for Devise other than those in the default gem. Devise views are installed.
  * CanCan uses a simple authentication using the Task => User association
* The production environment uses a Postgres adapter - development uses SQLite3.
* Views (for Task) use HAML
* Controllers use strong parameters
* Assets
  * Stylesheets use SASS, rather than LESS. The `application.css.scss` file explicitly includes what it needs, which in the beiginning is simply Bootstrap and a reset file that performs [basic browser resets](http://meyerweb.com/eric/tools/css/reset/)
* The layout puts notice and alert at the top of the page, and a float:right element to accommodate the user session (logged-in/out) state.
* The app has Capistrano v3 installed with some basic defaults that assist in making deployments to a remote folder via SSH, like sym-linking to an existing database, to the database config file so that credentials are not stored in the SCS, etc.
* Rails Admin: The app now has Rails Admin installed. Note that installation was done by following [the basic steps](https://github.com/sferik/rails_admin#installation), and that the Devise lines in `config/initializers/rails_admin.rb` are uncommented. 
## Usage

Before you run your app, you have to prepare the baseline code as follows:

* At the very least, copy `config\database.yml.sample` to `config\database.yml`. You might want to also change the db or its creds.
* Change the app (class) name - there's a convenient shell script (`change_app_name.sh`) in the project root that does that using `sed` - you have to uncomment the line at the top of the script that sets your app name.
* Run migrations. Optionally, seed the database if you wish.
* Check the routes file and remove the latter half, after the comment that says that that part is probably not useful.
* If you're going to deploy your app using the Capistrano config in it:
  * Change the config information in `config\deploy.rb` - the app's deploy location (folder) and the user on the remote server whose account will be used for the deployment.
  * Change the deployment server hostname in `config\deploy\{staging, production}.rb`
  * Set up a shared folder in your deployment where you store your `config\database.yml` file
  * As noted also below, if your production environment is Heroku, add this variable in Heroku:

        heroku config:add RAILS_SECRET_TOKEN=a-128-character-token-no-spaces-though-you-generated-as-a-secret

  * Make sure the shared files linked to in `config\deploy.rb` are the ones you are using in your remote server, specifically the database files. If you are using Postgres on the remote server, you should remove the SQLite3 files from the linked files list.
* The locale file has the site's title, and the phrase that's in the Bootstrap navbar - you might want to change it.
* You might want to delete some models (`Task`, `Location`, etc.), their corresponding tests and migrations, and the corresponding routes. Also, you might want to get rid of the Google Maps API assets in `app\assets\javascripts\gmaps`. Remember to remove them from your repository, not just the filesystem. Here's a helpful list of `git rm` commands you might want to consider running:

        cd app/models/
        git rm category.rb  task*
        cd ../../app/controllers
        git rm app_tasks_controller.rb app_tasks_controller.rb navbar_entries_controller.rb  homepage_controller.rb users_controller.rb	categories_controller.rb
        cd ../app/views/
        git rm -r navbar_entries/ users/
	cd ../../db/migrate
	git rm *add_admin* *add_age* *create_navb*
        cd ../../test/
	git rm integrations/*
	git rm fixtures/navbar_entries.yml

* You might also want to delete some of the steps in the `seeds.rb` file - otherwise if you ran a `db:reset` task, those methods will be executed and generate error messages if you don't have the corresponding models.
* The app's asset pipeline does not load any new JS or CSS files by default via `require_tree`: if you add new asset files, make sure you have included them in the pipeline by adding them to `application.css` or `application.js`, as appropriate.

## Security

The code attempts to be secure - it passes all Brakeman tests, as of Apr 2014. Particularly, it:

* moves `config/database.yml` to `config\database.yml.sample` in the repo and ignores the former, so that you are forced to set credentials in a non-committed file, and
* avoids using the stored session secret in production - in production, you have to store the secret token in the environment variable **RAILS_SECRET_TOKEN**.
  * If your production environment is Heroku, add this variable in Heroku like this:

        heroku config:add RAILS_SECRET_TOKEN=a-128-character-token-no-spaces-though-you-generated-as-a-secret
	
  * In development, the secret token is enabled in `config/initializers/secret_token.rb`. The app also uses the `dotenv` gem to utilize a .env file in the app root as an alternate method if you don't even want to share your development secret token in your repo. You have to create the `.env` file and add the `RAILS_SECRET_TOKEN` variable to it, if you are using this method.
* **However**, the app does **NOT** use the database as the session store. This is the recommended thing to do, but has some performance implications, so [look into implementing it yourself](https://github.com/rails/activerecord-session_store).
* Also, note that while there's a helpful hint in the `routes.rb` file that the Rails Admin and Sidekiq monitor interfaces should be protected by a routing constraint that checks that a logged-in admin session token is available, the default code does not enforce this.

## Views

The default application layout expects the `flash` hash to have two keys: `:alert` and `:notice`, that use Bootstrap built-in classnames for styling.

## Testing

The app also has some basic tests, and coverage is well below a reasonable level (set to 95% in the `.simplecov` configuration file.) After all, real developers don't test their code; they just have an unbounded, and completely unfounded, faith in their infallibility. Right? Ok, no, j/k. Test your code, people.

* It uses Minitest.
* It uses Capybara.
* CI: None so far. This codebase has evolved very slowly from Ruby MRI 2.0 to 2.3.0, and from Rails 4.0 to 4.2. So possibly all combinations of those two version histories will work but YMMV.
* Unit tests for users and tasks - check that users can be created, and that tasks cannot be created when a user is not logged in.
* Integration tests: None so far

## Sidekiq

If you are going to use Sidekiq, here are some things worth knowing about how it works:

* This app has the `sidekiq` gem, as well as `sinatra` for the monitoring web interface (available at `/sidekiq_ui`). Consequently, it has:
  * a `Procfile` that lets you run all three tasks (your app server, Sidekiq's worker queue (there's one named `scrapers` in the Procfile that Sidekiq will look for, and one named `mailers` which is the default queue used by `ActionMailer`'s jobs,) and the Redis server by running `foreman`. Note that this assumes you have installed Redis on your system
  * A route in your `routes.rb` file that lets you access the monitor.

## Heroku

You have to uncomment the `rails_12factor` gem in the Gemfile, if you are going to deploy this to Heroku. The checked-in Gemfile doesn't include it.

You also have to set the secret token as described above for the app to run.

Don't forget to run `rake db:migrate` in Heroku, of course :)

## Coming Soon!

I am not sure I'll add these gems - their configuration changes a lot, imo, and these are not necessarily "commonly" used. But you might hold your breath a bit...

* Paperclip with S3: This can get complicated - first you should have a model for files that `belongs_to Imageable`, and build the appropriate polymorphic migration for the files model; then you configure S3 with credentials in your appropriate config file (bucket, S3 keys); then you configure your path, and add a `paperclip.rb` initializer optionally that adds an `interpolates` method to customize your URL.
* Elastic Search

## How Did The App Get Here?

If you are trying to do this from scratch, note that the following `rails` and `rake` commands are essential to getting the app to its current state, after your bundle is installed (though you also have to change the code obviously).

This list is unfortunately *not* complete - it's pretty hard to keep the list of migrations up-to-date. :(

    rails new baseline_rails_install
    rails generate model User admin:boolean age:integer
    rails generate model Task title:string owner_id:integer
    rails generate scaffold Location lat:float long:float name:string address:string	

These generate files, so you don't have to re-run them, but they are here for the sake of the record. This list too is probably incomplete:

    # Devise
    rails generate devise User
    rails generate devise:views

    # CanCan
    rails g cancan:ability

    # For Bootstrap Rails
    rails generate bootstrap:install less

    # For Rails Admin
    rails g rails_admin:install

    # There's probably stuff for geocoding, gmaps4rails, and doorkeeper ... not sure if that's the case.

## Contribute and Use

Forking this skeleton to build your own app? Please give credit as follows:

This app is based on [the skeleton Rails 4 app](https://github.com/siruguri/baseline_rails_install) written by [@siruguri](https://github.com/siruguri/)

Adding to the repository? Your pull requests are most welcome!

