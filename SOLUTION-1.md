# GoodGame Interview Task 2024

# Solution 1: 100% Fully Automated Setup for Any Linux System with Docker and Docker Compose & bash shell.

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

1. Open a terminal & clone repo or unzip good-game-krushna-main.zip
2. Navigate to the directory 'good-game-krushna*' containing the project files.
3. You might need to add your user to the docker group.
4. Set execute permission to DB-UTILITY.sh
5. Run the `DB-UTILITY.sh` script:

   ```bash
   git clone https://github.com/KrushnaPardeshi/good-game-krushna.git
   sudo usermod -aG docker $USER 
   sudo chmod +x DB-UTILITY.sh
   ./DB-UTILITY.sh
   ```
6. From the menu, select the appropriate option:

   - `1`: Start the Docker containers if they haven't been created yet.
   - `2`: Import the latest data into all DB hosts.
   - `3`: Import data into a specific DB host by choosing from the list displayed.
   - `4`: Fetch and display data from all game worlds.
   - `5`: Destroy existing Docker containers and clean up all associated volumes and images.
   - `6`: Exit the script.

### Menu Options Explained

1. **Start Docker Containers**:
   - This will build and start the MySQL instances for each game world.
   - Wait for about 30 seconds for the MySQL containers to initialize.

2. **Import Latest Data into All DB Hosts**:
   - This option imports the latest backups into the corresponding MySQL containers.
   - Ensure the backups are correctly mapped in the `backup_mapping.txt` file.

3. **Import Data into a Specific DB Host**:
   - Choose this option to import a specific backup by selecting from a list of available backups.

4. **Fetch Data from All Game Worlds**:
   - This option fetches and displays player data from all game worlds.
   - If data has not been imported, a message will prompt you to do so.

5. **Destroy Docker Containers**:
   - This option stops and removes all Docker containers, volumes, and images.
   - Use this when you need to clean up your environment.

6. **Exit**:
   - Exit the script.

### Few example of CLI commands

   ```bash
      host1: mysql -h 127.0.0.1 -P 3306 -u root -p game
      host2: mysql -h 127.0.0.1 -P 3307 -u root -p game
      host3: mysql -h 127.0.0.1 -P 3308 -u root -p game
      Password: rootpassword

      SHOW DATABASES;
      USE game;
      SELECT * FROM player;
   ```


## Features
**Features of DB-UTILITY.sh**:
1. **Multi-Instance MySQL Setup**:
   - Utilizes Docker and Docker Compose to create isolated MySQL instances for each game world.
   - Each MySQL instance is configured with its own database to mimic the game world environment.

2. **Automated Backup Management**:
   - Automatically import the latest backups for each game world database from a predefined mapping file (`backup_mapping.txt`).
   - Allows importing specific backups manually.

3. **Interactive Utility Script**:
   - Provides an interactive Bash script (`DB-UTILITY.sh`) to manage database instances and backups with a simple menu interface.
   - Options to start and stop Docker containers, import backups, fetch data, and clean up the environment.

4. **Backup Mapping**:
   - Maintains a `backup_mapping.txt` file to map each game world host to its backup files.
   - Supports timestamped backups for easy version management.

5. **Flexible Backup Import**:
   - Ability to import the latest backups for all game worlds with a single command.
   - Option to import specific backups based on user selection from a list.

6. **Data Fetching**:
   - Provides a feature to fetch and display data from all game world databases.
   - Ensures the databases are populated before fetching data, prompting the user to import backups if necessary.

7. **Environment Cleanup**:
   - Includes a command to destroy all Docker containers, volumes, and images related to the MySQL instances.
   - Ensures a clean state for reusability and repeatability.

8. **Detailed Instructions and Error Handling**:
   - Provides clear instructions and error messages for each operation.
   - Ensures user-friendly experience with guidance on what to do next if an error occurs.

9. **Single Host Deployment**:
   - Designed to run entirely on a single Linux host, making it easy to set up and manage.
   - No external dependencies on cloud providers or managed database services.

## Notes

- Ensure Docker and Docker Compose are installed and running on your system.
- If docker-compose version '3.3' is not supported on your system, change version in docker-compose.yml to supported version.
- Depending on your system's performance, it might take longer than 30 seconds for the MySQL DB containers to initialize.
- Backup files should be placed in the `backups` directory and mapped correctly in the `backup_mapping.txt` file.
- Use the provided script (`DB-UTILITY.sh`) to manage the entire process seamlessly.
- Solution is tested on Ubuntu 20.04.6 LTS

