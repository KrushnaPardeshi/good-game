
# Solution 2: Use this Solution, In case environment where solution is being tested is not suitable.

## Prerequisites
- ssh 

### Step 1: Login to EC2 server & navigate to directory.

```bash
    ssh -i GoodGame.pem ubuntu@18.185.224.194   
```

### Step 2: Build and Start Docker Containers

1. Open a terminal and navigate to the directory containing the project files.
2. Run the `DB-UTILITY.sh` script:

   ```bash
    cd good-game-krushna/
    ./DB-UTILITY.sh
   ```
3. From the menu, select the appropriate option:

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


## Features

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

