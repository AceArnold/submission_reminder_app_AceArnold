#!/bin/bash

# I'm creating a script that Script to ask for name
read -p "Enter your name: " x

# Creating a variable "y" that I then use to define the main directory
y="submission_reminder_${x}"

# I am now creating all the respective sub-directorys
mkdir -p "$y/config"
mkdir -p "$y/modules"
mkdir -p "$y/app"
mkdir -p "$y/assets"

# I am now creating the necessary files inside the previously made subdirectories
touch "$y/config/config.env"
touch "$y/assets/submissions.txt"
touch "$y/app/reminder.sh"
touch "$y/modules/functions.sh"
touch "$y/startup.sh"


# Populating config.env with downloaded content
cat << EOF > "$y/config/config.env"
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

# Populating submissions.txt with a sample of students 
cat << EOF > "$y/assets/submissions.txt"
student, assignment, submission status
lee, Shell Navigation, not submitted
Chad, Git, submitted
Dave, Shell Navigation, not submitted
Anny, Shell Basics, submitted
Tom, Shell Navigation, not submitted
Kevine, Shell Navigation, not submitted
Darcy, Shell Navigation, not submitted
Woodstone, Shell Navigation, not submitted
Fallguy, Shell Navigation, submitted
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divin, Shell Navigation, not submitted
Aurther, Shell Basics, submitted
Tesy, Shell Navigation, not submitted
Kevin, Shell Navigation, not submitted
Darcy, Shell Navigation, not submitted
Sarah, Shell Navigation, not submitted
john, Shell Navigation, submitted
EOF

# Populating functions.sh
cat << 'EOF' > "$y/modules/functions.sh"
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
EOF

# Populating reminder.sh
cat << 'EOF' > "$y/app/reminder.sh"
#!/bin/bash
#!/bin/bash
echo '------------STARTING UP THE APP-------------'
# Source environment
source ./config/config.env
source ./modules/functions.sh

# Location of the submissions file
submissions_file="./assets/submissions.txt"

# Print out the output for Assignment and Days remaining 
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

# Populating startup.sh with logic to run the app
cat << 'EOF' > "$y/startup.sh"
#!/bin/bash
echo "Starting Submission Reminder App..."
./app/reminder.sh
EOF

# Changing the permissions of each Scripts to make them executable
chmod +x "$y/modules/functions.sh"
chmod +x "$y/startup.sh"
chmod +x "$y/app/reminder.sh"

tree
echo 'DISPLAYING THE TREE STRUCTURE OF THE DIRECTORY'
