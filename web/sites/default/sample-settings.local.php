<?php

// Docksal DB connection settings.
$databases['default']['default'] = array (
  'database' => 'drupal9',
  'username' => '<drupal-database-user>',
  'password' => '<drupal-database-pwd>',
  'prefix' => '',
  'host' => 'database.swpctestbed.internal',
  'port' => '3306',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);
