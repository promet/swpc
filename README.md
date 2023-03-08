# Space Weather Testbed

## local install - getting started

Clone the repo to your system

```git clone git@github.com:promet/swpc.git```

cd into the newly cloned directory

```cd swpc```

Copy the default.settings.local.php to settings.local.php

```cp web/sites/default/default.settings.local.php web/sites/default/settings.local.php```

Run lando start to get the containers up.

```lando start```

Look for the following output and make note of the URLs provided

**This is an EXAMPLE the ports will change. Make note of what's returned from Lando**
These ports will also change after a `lando destroy` -> `lando start` cycle.

Here are some vitals:

```
 NAME             swpc-testbed
 LOCATION         /Users/szipfel/Development/Promet/noaa/lando
 SERVICES         appserver, database, phpmyadmin
 APPSERVER URLS   https://localhost:58740
                  http://localhost:58741
                  http://swpc-testbed.lndo.site:8080/
                  https://swpc-testbed.lndo.site:4433/
 PHPMYADMIN URLS  http://localhost:58742
 ```

Your site will be accessible at: http://localhost:58741
PHPMyAdmin will be accessible at: http://localhost:58742

If you forgot you can use `lando info` to get the urls.

Run the swpc build to build the site

```lando swpc-build```

Visit your site with the URL above

## Login to your new site

Get a one time admin login link:
```lando drush uli```

result will look like

```http://default/user/reset/1/1678116617/5hheYGfBS37PAxkz7vwfAXrg5zf0pwaCy6RAQ_Yn3HU/login```

Copy and paste everything AFTER `default` and append to the site URL.

Example:

```http://localhost:58741/user/reset/1/1678116617/5hheYGfBS37PAxkz7vwfAXrg5zf0pwaCy6RAQ_Yn3HU/login```

Put this into the address bar of you favorite browser and you'll be logged in as the admin user.

## Import content

Go to the import content page:  `/admin/content/import`

and import the zip file located in the `/content` directory in the project.

## Lando particulars

### DB Credentials

user: drupal9
pass: drupal9
database: drupal9
server: database.swpctestbed.internal

## Adding to git repo

If you want to add new items in the `/web` you'll need to force git to add it as
the `/web` directory is this directory is in the `.gitignore` file since the main
the contents of the web directory are controlled by composer.

You only need to do this when adding a new file as once added it'll be tracked by git
regardless of the `.gitignore` entries but if you add new files to you module they need to
will need added with the force `-f` switch as well.

Exmaple:

```git add -f web/modules/custom/my_custom_module/*```

## Importing and Exporting Drupal configurations

* What is Drupal configuration management? *
Drupal configiration management refers to the  act of storing configurations that live
in the database as code.  These are YML files that can be read and consumed by Drupal.

Configuration contains things such as chosen theme, theme settings, views, content types
and settings such as custom module configurations and what modules are enabled, etc.

To import the configurations Drupal needs to know where there configuration files are
located. This is set in the `web/sites/default/settings.php` file in the
`$settings['config_sync_directory']` variable.

For this project it is `$settings['config_sync_directory'] = '../config/default';`

To import and export we use `drush`

Import:  `drush config:import` or `drush cim`

Export: `drush config:export` or `drush cex`

When you export new config you'll need to add it to the git repository.

from the project root run git add the new items you can do it one at a time or with
the * wildcard.

Example:
```git add config/*```

> This way your configrations changes, which might be updates to a view, groups configuration or
> a new field or alterd field in a content type, make their way up to the main repo and others can
> import test and them.

## How to update the content zip file

## Git Branching and Merge Requests

### Working in branches

## CI from GitLab

## Setup on Dev / Staging / Prod

To setup the server on a server the steps are similar but we won't be using Lando.

These steps assume you have a configured server with:
- Web server (Apache, Nginx etc)
- Mysql / MariaDB
- PHP
- Composer
- Git

Plus the versions requirements here: [System requirements](https://www.drupal.org/docs/system-requirements)

Where ever your server docroot is, example: `/var/www/` git clone the site so you end up with
`/var/www/<cloned-site-name>` the go into the new site directory

We're going to use `/var/www` as the path for the web server root. Substitue whatever path you're using.

### 1. Clone Site:

```
cd <cloned-site-name>`
```

Configure your webserver to server the site out of the `/var/www/<cloned-site-name>/web` directory

### 2. Run composer install

```
composer install
```
Go to the `<cloned-site-name>/web/sites/default` directory and copy `default.settings.local.php` to `settings.hosting.php` and
update the database connection info to allow connections to your database server.

**Note all `drush` commands need to be run from the `web` directory in the project**

### 3. Install Drupal

To install Drupal from the command line you canuse the `drush site-install` command:

```
drush site-install standard --account-name=admin --account-pass=<the-drupal-admin-password-you-want> --db-url='mysql://<db-user>:<db-pass>@<db-server>/<database-name>' --site-name='Space Weather Testbed' -y
```
If this doesn't work you can go to the URL you are hosting the site as and walk through the install ation via the Drupal UI.

### 4. Import Configuration

To import the Drupal configuration use `drush cim`

```
drush cim
```
You will see a list of items to be added or deleted. Choose yes / no to continue (yes in this case)

### 5. Content Import

The last step is to import the content this will be either a content dump file or a database dump file. Check with the SWPC team.


### 6. Ongoing Updates

You can create a bash script to run and that gitlab can later SSH in to run to automate deployments for Dev based on merge requests

#### Steps:
1. `git pull origin develop`  Pull in changes
2. `composer install` install any new required packes or updates
3. `cd web` Next commands are drush and have to be run from within the actual drush site codebase
4. `drush cim` Run config import to import any configuration changes to the site (add the -y switch to have drush automatically assume yes to confirmation prompt)
5. `drush updb` This runs the `update db` process which runs any installer items that may be associated with drupal core or module updates
6. `drush cr` This rebuilds the cache so your changes are reflected on the site.


**Example `update.sh` script :**

```
#!/usr/bin/env bash

git pull origin develop
composer install
cd web && \ drush cim -y && drush updb -y && drush cr

```

## Theming - CSS / SASS

#### To setup your SASS compiler:

```
cd web/themes/custom/swpc
npm install
npm install -g sass
```

#### Compile SASS

```
sass scss/style.scss css/style.css
```

#### SASS documentation

[SASS Documentation](https://sass-lang.com/guide)


## Helpful resources

- [Twig debugging](https://www.drupal.org/docs/theming-drupal/twig-in-drupal/discovering-and-inspecting-variables-in-twig-templates)
