#! /bin/sh

# Set Dev & Stage URL here (MUST)
SITE_DEV='https://yourdev.com'
SITE_STAGE='https://yourstage.com'

# Command Input
echo "What you want to do? Pull or Push?"
read action
echo "Where are you now? Dev or Stage?"
read location


# Command Execution
if [ "$action" == "pull" ]
then

    git status
    git add .
    git commit -m "backup before merge"
    git pull origin master
    wp db import DB.sql --allow-root
    if [ "$location" == "dev" ]
    then
    wp search-replace $SITE_STAGE $SITE_DEV --allow-root
    elif [ "$location" == "stage" ]
    then
    wp search-replace $SITE_DEV $SITE_STAGE --allow-root
    else
    echo 'invalid entry'
    fi

elif [ "$action" == "push" ]
then

  git status
  wp db export DB.sql --allow-root
  git add .
  echo 'Commit Message?'
  read commitmsg
  git commit -m "$commitmsg"
  git pull origin master
  git push origin master

else

  echo 'invalid entry'

fi

