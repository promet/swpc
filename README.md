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

## Lando particulars

### DB Credentials

user: drupal9
pass: drupal9
database: drupal9
server: database.swpctestbed.internal

## Git Branching and Merge Requests

## CI from GitLab
