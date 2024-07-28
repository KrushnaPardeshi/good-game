# GoodGame Interview Task 2024

# Solution 1: 100% automated setup to run on any Linux-based operating system that supports Docker, Docker Compose bash shell.

## Prerequisites

Before you begin, ensure you have the following installed:

- Docker
- Docker Compose 
- Bash shell


## Solution Overview

This solution uses Docker and Docker Compose to set up three MySQL instances, each representing a game world database. The setup includes scripts to start and stop the containers, import backups, and fetch data from the databases.

## Directory Structure

```
├── backups/                # Directory containing the SQL dump files
├── Dockerfile              # Dockerfile to build MySQL containers
├── docker-compose.yml      # Docker Compose configuration
├── DB-UTILITY.sh           # Script to manage the database instances and backups
├── backup_mapping.txt      # File mapping hosts to their backups
├── SOLUTIONS.md            # This README file
```

## Setup Instructions (The needed files and directory structure are already part of the setup, so nothing really needs to change.)

### Step 1: Prepare the Backup Files

Place your backup `.sql` files in the `backups` directory. The `backup_mapping.txt` file should map each host to its backups, formatted as follows:

```
host1:20240617_211713:host1_fulldump_20240617_211713.sql
host1:20240618_211508:host1_fulldump_20240618_211508.sql
host2:20240617_211910:host2_fulldump_20240617_211910.sql
host2:20240618_211855:host2_fulldump_20240618_211855.sql
host3:20240617_212031:host3_fulldump_20240617_212031.sql
host3:20240618_212019:host3_fulldump_20240618_212019.sql
```

### Step 2: Build and Start Docker Containers

1. Open a terminal and navigate to the directory containing the project files.
2. You might need to add your user to the docker group:
3. Set execute permission to DB-UTILITY.sh
4. Run the `DB-UTILITY.sh` script:

   ```bash
   sudo usermod -aG docker $USER 
   sudo chmod +x DB-UTILITY.sh
   ./DB-UTILITY.sh
   ```
5. DB-UTILITY is self-explanatory.
6. From the menu, select option `1` to start the Docker containers.

### Step 3: Import Backups

1. After the containers are up and running, select option `2` from the menu to import the latest backups into all hosts.
2. Alternatively, select option `3` to import a specific backup by choosing from the list displayed.

### Step 4: Fetch Data

1. To fetch data from all game worlds, select option `4` from the menu. This will display the player data from all hosts.

### Step 5: Destroy Docker Containers

1. When you are done, select option `5` from the menu to destroy the Docker containers and clean up all associated volumes and images.

### Step 6: Exit

1. To exit the script, select option `6`.

## Usage

### Start Docker Containers

To start the Docker containers, choose option `1` from the menu. This will build and start the MySQL instances for each game world.

### Import Backups

- Import data into all DB hosts: Select option `2`. This imports the latest backups into the corresponding MySQL containers.
- Import data into a specific DB host: Select option `3`. You will be prompted to choose a backup from the list.

### Fetch Data

Select option `4` to fetch and display player data from all game worlds. If data has not been imported, a message will prompt you to do so.

### Destroy Docker Containers

Select option `5` to stop and remove all Docker containers, volumes, and images.

### Exit

Select option `6` to exit the script.


## Notes

- Ensure Docker and Docker Compose are installed and running on your system.
- If docker-compose version '3.3' is not supported on your system, change version in docker-compose.yml to supported version.
- Depending on your system's performance, it might take longer than 30 seconds for the MySQL DB containers to initialize.
- Backup files should be placed in the `backups` directory and mapped correctly in the `backup_mapping.txt` file.
- Use the provided script (`DB-UTILITY.sh`) to manage the entire process seamlessly.
- Solution is tested on Ubuntu 20.04.6 LTS

