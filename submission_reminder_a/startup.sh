echo "Starting up the App ........."
source config/config.env
./modules/functions.sh
./app/reminder.sh
