#!/bin/bash

# Define the backup mapping file
BACKUP_FILE="backup_mapping.txt"

# Function to install prerequisite packages
install_prerequisites() {
  echo "Installing prerequisite packages..."

  # Update package list
  sudo apt-get update

  # Install docker
  if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    sudo apt-get install -y docker.io
    sudo usermod -aG docker $USER
  else
    echo "Docker is already installed."
    sleep 1
  fi

  # Install docker-compose
  if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo apt-get install -y docker-compose
  else
    echo "Docker Compose is already installed."
    sleep 1
  fi

  # Install mysql-client-core-8.0
  if ! dpkg -l | grep -q "mysql-client-core*"; then
    echo "Installing MySQL Client Core ..."
    sudo apt-get install -y "mysql-client-core*"
  else
    echo "MySQL Client Core is already installed."
    sleep 1
  fi

  echo "Prerequisite packages installation complete."
}

# Function to start Docker containers
start_docker_containers() {
  echo "Starting Docker containers..."
  sudo docker-compose up --build -d
  echo -e "\n Waiting 40 Seconds for MySQL DB containers to initialize..."
  sleep 40
}

# Function to destroy Docker containers
destroy_docker_containers() {
  echo "Destroying Docker containers and removing all associated volumes and images..."
  sudo docker-compose down -v --rmi all
}

# Function to list backups
list_backups() {
  echo -e "\n: Find Available Backups Along With Relevant Hosts :\n"
  awk -F':' '{print NR ": " $1 " - " $2 " - " $3}' "$BACKUP_FILE"
}

# Function to get the latest backup for a given host
get_latest_backup() {
  local host=$1
  awk -F':' -v host="$host" '$1 == host {print $2 ":" $3}' "$BACKUP_FILE" | sort -r | head -n 1 | awk -F':' '{print $2}'
}

# Function to import a selected backup
import_backup() {
  local host=$1
  local backup_file=$2
  echo "Importing data into $host from $backup_file..."
  sudo docker exec -i "${host}_db" sh -c "MYSQL_PWD=rootpassword mysql -uroot --silent game" < "backups/${backup_file}"
  if [ $? -eq 0 ]; then
    echo -e "Import completed successfully for $host."
    sleep 2
  else
    echo -e "\n:: Import failed for $host. \n:: Wait 60 seconds for $host to initialize & then try to import data. ::"
    sleep 5
  fi
}

# Function to import data into all hosts
import_all_backups() {
  echo -e "\n:: Importing latest data into all Game Worlds. ::\n"
  
  if ! (sudo docker ps --format '{{.Names}}' | grep -q 'host1_db' && sudo docker ps --format '{{.Names}}' | grep -q 'host2_db' && sudo docker ps --format '{{.Names}}' | grep -q 'host3_db'); then
    echo -e "\n:: It seems Game World DB's are not created yet. ::"
    sleep 2
    start_docker_containers
    sleep 5
    return
  fi
  # Loop through each host and get the latest backup
  hosts=$(awk -F':' '{print $1}' "$BACKUP_FILE" | sort | uniq)
  for host in $hosts; do
    latest_backup=$(get_latest_backup "$host")
    echo -e "\n:: Importing latest backup for $host: $latest_backup ::"
    import_backup "$host" "$latest_backup"
  done
   
}

# Function to import data into a specific host
import_specific_backup() {
  # List backups for the user to choose from
  list_backups

  echo -ne "\n:: Enter the number of the backup you want to import. :: "
  read backup_number

  # Get the chosen backup details
  selected_backup=$(awk -v num="$backup_number" 'NR == num {print $0}' "$BACKUP_FILE")
  if [ -z "$selected_backup" ]; then
    echo -e ":: Invalid selection. Exiting. ::"
    exit 1
  fi

  # Parse the selected backup details
  selected_host=$(echo "$selected_backup" | awk -F':' '{print $1}')
  selected_backup_file=$(echo "$selected_backup" | awk -F':' '{print $3}')

  # Import the chosen backup
  import_backup "$selected_host" "$selected_backup_file"
}

# Function to fetch all data from all DBs
fetch_all_data() {
  echo -e "\n::Fetching data from all Game Worlds databases...::"
  hosts=$(awk -F':' '{print $1}' "$BACKUP_FILE" | sort | uniq)
  for host in $hosts; do
    echo -e "\nData from $host:"
    if ! (sudo docker ps --format '{{.Names}}' | grep -q 'host1_db' && sudo docker ps --format '{{.Names}}' | grep -q 'host2_db' && sudo docker ps --format '{{.Names}}' | grep -q 'host3_db'); then
      echo -e "\n:: It seems Game World DB's are not created yet. Choose option 1 to create.::" 
      sleep 5
      return
    fi    
    ## Checking data is imported or not
    if ! sudo docker exec -i "${host}_db" sh -c "MYSQL_PWD=rootpassword mysql -uroot --silent --skip-column-names game -e 'DESCRIBE player;' > /dev/null 2>&1"; then
      echo -e "\n ::It seems your fetching data without importing it into ${host}_db.::"
      echo -e "\n :: Import data using option 2 & 3 from menu as per your need. :: "
      sleep 3
    else
      sudo docker exec -i "${host}_db" sh -c "MYSQL_PWD=rootpassword mysql -uroot game -e 'SELECT * FROM player;'" | column -t
    fi
  done
  echo -e "\n Waiting 15 seconds to let you have look on available data on stdout.."
  sleep 15
}

# Display the menu
show_menu() {
  clear
  echo "=============================="
  echo " MySQL Backup Import Utility"
  echo "=============================="
  echo "1. Install prerequisite packages (Suitable for Ubuntu/Debian-Based Distribution)."
  echo "2. Create the 'Game Worlds' databases if they haven't been created yet."
  echo "3. Import latest data into all DB hosts."
  echo "4. Import data into a specific DB host."
  echo "5. Fetch all data from all Game Worlds databases."
  echo "6. Destroy existing Game Worlds databases."
  echo "7. Exit."
  echo "=============================="
}

# Main menu logic
while true; do
  show_menu
  echo -n "Select an option [1-7]: "
  read -r choice
  
  case $choice in
    1)
      install_prerequisites
      ;;
    2)
      start_docker_containers
      ;;
    3)
      import_all_backups
      ;;
    4)
      import_specific_backup
      ;;
    5)
      fetch_all_data
      ;;
    6)
      destroy_docker_containers
      ;;
    7)
      echo -e "\nIt Was Fun Game! Exiting, Tschüss...\n"
      exit 0
      ;;
    *)
      echo "Invalid option. Please choose a valid option or choose option 7 to exit."
      sleep 2
      ;;
  esac
done
