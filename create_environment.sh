#!/bin/bash
#This script will create a directory called submission_reminder_$ai. The $a represents your names 
read -p "Enter Your Name:" a
mkdir submission_reminder_$a

#Once the directory is created the following subdirectories and files will be inside it
cd submission_reminder_$a
mkdir app modules assets config
touch startup.sh

# Populate config.env
cat <<EOL > "config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOL
chmod +x config/config.env

# Populate reminder.sh
cat <<EOL > "app/reminder.sh"
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOL
chmod +x app/reminder.sh

# Populate functions.sh
cat <<EOL > "modules/functions.sh"
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOL
chmod +x modules/functions.sh

# Populate submissions.txt with sample records
cat <<EOL > "assets/submissions.txt"
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
EOL

# Create the startup.sh script
cat <<EOL > "startup.sh"
echo "Starting up the App ........."
source config/config.env
./modules/functions.sh
./app/reminder.sh
EOL
chmod +x startup.sh

cd ..
tree

echo "It works"
