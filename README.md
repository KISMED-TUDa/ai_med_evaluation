# Evaluation System of the AI in Medicine Challenge



## MySQL Server Setup

1. Create folder for persistent data, example `mkdir ~/MySQL`
2. Install Docker
3. Create Container using mysql-server image ``` sudo docker run --name=mysql-server \ 
-v ~/MySQL/persistent_data:/var/lib/mysql \
--mount type=bind,src=~/MySQL/my-custom.cnf,dst=/etc/my.cnf \
-p <server_ip>:<server_port>:<docker_port> -d mysql/mysql-server:8.0 ```
4. 