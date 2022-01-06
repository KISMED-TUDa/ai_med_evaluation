# Evaluation System of the AI in Medicine Challenge

The goal of the challenge was to predict atrial fibrillation from I lead ECG signals.

This System was used on a Linux server to evaluate the code of the students in a semi-automatic manner. Requires an SQL Server database as described below and an Installation of Anaconda for python environments.

Example code provided to students 'train.py','predict.py','score.py','wettbewerb.py','predict_pretrained.py'.

To Evaluate the students code the bash scripts in 'bash_scripts' were used. 

Bash scripts provided must be adapted for ones needs.

A folder with all datasets must be set up. For instance download the 2017 challenge dataset from physionet.org.

Each dataset is a folder with one 'REFERENCES.csv' and 1 .mat file per ECG signal.

After Setup and a given folder with a model of a team (folder 'example_folder' with a 'predict.py' and 'requirements.txt' is required) run:

`bash score_entry.sh <team_nr> <binary> <model_name>`


## MySQL Server Setup

1. Create folder for persistent data, example `mkdir ~/MySQL`
2. Install Docker
3. Create Container using mysql-server image ``` sudo docker run --name=mysql-server \ 
-v ~/MySQL/persistent_data:/var/lib/mysql \
--mount type=bind,src=~/MySQL/my-custom.cnf,dst=/etc/my.cnf \
-p <server_ip>:<server_port>:<docker_port> -d mysql/mysql-server:8.0 ```
4. connect to bash of container `sudo docker exec -it mysql-server bash`
5. copy password from logs -> loog in output of logs, wait for setup (state=healthy) `sudo docker ps` & `sudo docker logs mysql-server`
6. enter server `mysql -uroot -p`
7. Alter user, create admin and give privileges ```ALTER USER 'root'@'localhost' IDENTIFIED BY 'test';
CREATE USER 'admin'@'%' IDENTIFIED BY 'test';
GRANT ALL ON *.* TO 'admin'@'%';
FLUSH PRIVILEGES;```
8. `exit`

Now test access outside docker with `mysql -u admin -h <server_ip> -P <server_port> -p`


### Create User for automatic database access and minimal rights


Use local root account `sudo docker exec -it mysql-server bash`, enter server `mysql -uroot -p` and use below commands

Rights: SELECT,INSERT

`CREATE USER 'wki_worker'@'<sever_ip>' IDENTIFIED BY '<some_password>';`

`GRANT SELECT,INSERT ON wki_main.* TO 'wki_worker'@'<sever_ip>';` 

The Config-File 'database_config.json' should be adapted accordingly.
```
{
    "USER": "wki_worker",
    "PASSWORD": "<some_password>",
    "HOST": "<sever_ip>",
    "PORT": "<server_port>"
}
```

### Easy access from any computer with MySQL Workbench
	- Install MySQL Workbench
	- Choose IP <server_ip> 
	- Look up port (maybe 3308)
	- User admin can access from everywhere
Create new user for each device that accesses the database

The database entries can be setup by simply running the sql_scripts from withing MySQL Worbench when logged into the server.
The datasets must be included in the database table.
