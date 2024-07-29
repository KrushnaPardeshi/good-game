# Solution-3: Infrastructure Provisioning and Automation with Terraform

## Solution Overview

This solution addresses the need to provision infrastructure for restoring and analyzing MySQL database instances for multiple game worlds in an online multiplayer game environment. Each game world is isolated and backed up regularly. The goal is to restore these backups into separate MySQL instances on a new infrastructure to investigate discrepancies reported by the game community. This solution leverages Terraform to automate the setup of the infrastructure, including the provisioning of an EC2 instance and a security group, and configuring the necessary environment for the database restoration and analysis.

## Pre-requisites

1. **AWS Account**: An active AWS account with permissions to create EC2 instances, security groups, and manage IAM roles.
2. **AWS CLI**: Installed and configured on your local machine to interact with AWS services.
3. **Terraform**: Installed on your local machine. Ensure you have the latest version for compatibility with AWS resources.
4. **SSH Key Pair**: A key pair (`GoodGame.pem`) for accessing the EC2 instance. Ensure this key is available on your local machine.
5. **Terraform Variables File**: A `.tfvars` file to store variable values such as AWS region, instance type, etc.

## Solution Description

### Infrastructure Provisioning

Using Terraform, the solution automates the creation of the following resources:

1. **EC2 Instance**:
    - **Operating System**: Ubuntu 22.04.4 LTS
    - **Root EBS Volume**: 10 GB
    - **Instance Type**: `t3a.small`
    - **Region**: `eu-central-1`
    - **Name Tag**: `GoodGame IAC automation`
    - **Bootstrap Script**: Installs Docker, Docker Compose, adds the `ubuntu` user to the Docker group, and copies necessary files from a local directory to the EC2 instance.

2. **Security Group**:
    - **Name Tag**: `GoodGame sg`
    - **Inbound Rules**: Allows access on ports 22 (SSH), 80 (HTTP), 443 (HTTPS), 8080 (alternative HTTP), 3306 (MySQL), 3307, and 3308 (additional MySQL instances).

### Environment Setup

The bootstrap script executed during the EC2 instance creation performs the following actions:

1. **Install Docker**: Installs Docker to containerize the MySQL instances.
2. **Install Docker Compose**: Facilitates the management of multi-container Docker applications.
3. **Add User to Docker Group**: Adds the `ubuntu` user to the Docker group to allow running Docker commands without `sudo`.
4. **Copy Files**: Copies the `backups` directory, `Dockerfile`, `docker-compose.yml`, `backup_mapping.txt`, and `DB-UTILITY.sh` from the local machine to the `/home/ubuntu/project/` directory on the EC2 instance.

### Database Restoration and Analysis

- **Docker Compose**: Defines the services and configurations for running multiple MySQL containers, each representing a different game world.
- **DB-UTILITY.sh**: A utility script to manage database operations such as restoring backups, running analysis queries, and automating repetitive tasks.

## Usage

1. **Clone the Repository**: Ensure you have the repository containing the Terraform configuration files, bootstrap script, and necessary Docker-related files.

    ```sh
    git clone https://github.com/KrushnaPardeshi/good-game-krushna.git
    cd good-game-krushna
    ```

2. **Configure AWS Credentials**: Ensure your AWS CLI is configured with the necessary credentials.

    ```sh
    aws configure
    ```

3. **Prepare Terraform Variables**: Update a `terraform.tfvars` file with the necessary values for your setup.

    ```ini
    aws_access_key = "YOUR_ACCESS_KEY"
    aws_secret_key = "YOUR_SECRET_KEY"
    region           = "eu-central-1"
    instance_type    = "t2.micro"
    key_name         = "GoodGame"
    root_volume_size = 10
    instance_name    = "GoodGame IAC automation"
    ```

4. **Initialize Terraform**: Initialize Terraform to download the necessary providers and modules.

    ```sh
    terraform init
    ```

5. **Plan the Infrastructure**: Generate and review the execution plan for provisioning the infrastructure.

    ```sh
    terraform plan -var="private_key_path=$(pwd)/GoodGame.pem"
    ```

6. **Apply the Configuration**: Apply the configuration to create the resources.

    ```sh
    terraform apply -var="private_key_path=$(pwd)/GoodGame.pem"
    ```

7. **Access the EC2 Instance**: SSH into the EC2 instance using the provided key pair & public ip.

    ```sh
    cat public_ip
    ssh -i GoodGame.pem ubuntu@<EC2-Instance-Public-IP>
    ```

8. **Verify Setup**: Check that Docker and Docker Compose are installed, and the necessary files are in place.

    ```sh
    docker --version
    docker-compose --version
    ls /home/ubuntu/goodgame/
    ```

9. **Run DB-UTILITY.sh*: Navigate to the project directory and use DB-UTILITY.sh to perform operations

    ```sh
    cd /home/ubuntu/goodgame/
    ./DB-UTILITY.sh
    ```

10. **Use DB-UTILITY.sh**: Utilize the `DB-UTILITY.sh` script to restore backups and perform analysis as required.

## Few example of CLI commands
host1: mysql -h 127.0.0.1 -P 3306 -u root -p game
host2: mysql -h 127.0.0.1 -P 3307 -u root -p game
host3: mysql -h 127.0.0.1 -P 3308 -u root -p game
Password: rootpassword

SHOW DATABASES;
USE game;
SELECT * FROM player;



### Features
**Listing few important features of IAC**:

1. **Automated Infrastructure Provisioning**: 
 - Uses Terraform to automate the creation and configuration of AWS resources.

2. **Scalable Setup**: 
 - Easily adaptable to handle additional game worlds by updating the Docker Compose configuration and backup mappings.

3. **Comprehensive Bootstrap Script**: 
 - Ensures all necessary packages and configurations are set up on the EC2 instance automatically.

4. **Dynamic AMI Selection**: 
 - Automatically selects the latest Ubuntu 22.04 LTS AMI using a data source.

5. **Security Best Practices**:
   - Configures security group with inbound rules for essential ports and allows all outbound traffic.

6. **EC2 Instance Provisioning**:
   - Creates an EC2 instance with specified type, volume size, and associated security group.

7. **Public IP Output**:
   - Outputs the instance's public IP for easy access.

8. **File Transfer and Setup**:
   - Uses a script to transfer files to the EC2 instance and set up configurations.

9. **Bootstrap Configuration**:
   - Employs a `user_data` script to automatically configure the instance at launch.

10. **Flexible Variable Management**:
   - Uses variables for customizable and reusable configurations.

11. **Efficient Resource Management**:
  - Utilizes a `t3a.small` instance for cost-effective operation while maintaining the necessary functionality.

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