# Space Weather Testbed

## local install - getting started

Clone the repo to your system

```git clone git@github.com:promet/swpc.git```

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

Run the swpc build to build the site

```lando swpc-build```

Visit your site with the URL above

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
the `/web` die is in the ignore as the main part of it is controlled by composer.

You only need to do this when adding a new file as once added it'll be tracked by git
regardless of the gitignore entries but if you add new files to you module they need to
will need added with the force `-f` switch as well.

Exmaple:

```git add -f web/modules/custom/my_custom_module/*```

## Git Branching and Merge Requests

### Working in branches

## CI from GitLab
