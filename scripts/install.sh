
# Abort if anything fails
set -e

#-------------------------- Settings --------------------------------

SITE_SUB_PATH="site"
SITE_DIRECTORY="default"
SITEDIR_PATH="${LANDO_WEBROOT}/sites/${SITE_DIRECTORY}"
#-------------------------- END: Settings --------------------------------


#-------------------------- Functions --------------------------------

copy_settings_file()
{

	local source="$1"
	local dest="$2"

	if [ ! -f $dest ]; then
		echo "Copying ${dest}..."
		cp $source $dest
	else
		echo "${dest} already in place."
	fi
}

#Initialize local settings files
init_settings ()
{
	# Copy from settings templates
	copy_settings_file "${SITEDIR_PATH}/default.settings.local.php" "${SITEDIR_PATH}/settings.local.php"
}

# Fix file/folder permissions
fix_permissions ()
{
	echo "Making site directory writable..."
	chmod 755 "${SITEDIR_PATH}"
}

# Install site
site_install ()
{

    cd $LANDO_WEBROOT

	# We disable email sending here so site-install does not return an error
	# Credit: https://www.drupal.org/project/phpconfig/issues/1826652#comment-12071700
	drush site-install standard --account-name=admin --account-pass=password1 --db-url='mysql://drupal9:drupal9@database.swpctestbed.internal/drupal9' --site-name='Space Weather Testbed' -y


}

update_uuid ()
{
	uuid=$(awk '{for (I=1;I<=NF;I++) if ($I == "uuid:") {print $(I+1)};}' $LANDO_WEBROOT/../config/default/system.site.yml)
  echo "...Setting system UUID to " ${uuid}
  drush cset system.site uuid ${uuid} -y

}

get_database()
{
	local dbname="$1"
	local dest="/app/${dbname}"

	if [ ! -f $dest ]; then
		echo "...Downloading ${dbname}"
	else
	  echo "Deleing existing db file"
	  rm $dest
	fi

	wget http://swpc.promethost.com/${dbname}
}

import_db()
{
	local dbname="$1"
  mysql -u drupal9 -pdrupal9 -h database.swpctestbed.internal drupal9 < ${dbname}
}


#-------------------------- END: Functions --------------------------------

#-------------------------- Execution --------------------------------

echo "running composer"
composer install

# Project initialization steps
echo "...Updating Permissions"
fix_permissions

echo "...Copying local.settings.php"
init_settings

#echo "...Wait 60 sseconds for db to be ready"
#sleep 60

echo "...Download remote database"
get_database "swpc-testbed-dev-dump.sql"

echo "...Import database"
import_db "swpc-testbed-dev-dump.sql"

# Alternate solution: Install drupal, import config and use one of the  content sync modules
# echo "...Installing Drupal"
# site_install

echo "...Update config UUID to use one from newly installed site."
update_uuid

drush cim -y
drush updb -y
drush cr


#-------------------------- END: Execution --------------------------------

