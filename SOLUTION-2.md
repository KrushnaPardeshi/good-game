
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
3. DB-UTILITY is self-explanatory.
4. From the menu, select option `1` to start the Docker containers.

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

