# DevOps project using Git, Jenkins, ansible and Docker



In this project, we will be see how to *use Git, Jenkins, Ansible, DockerHub, Docker to DEPLOY on a docker container.,*

*Follow this project *

![](https://github.com/praveensirvi1212/webdev/blob/main/img/project-2.jpg)

#### PreRequisites
1. Git
1. Jenkins
1. Ansible 
1. Setup ansible client and install docker. 
1. Docker Hub account 


### Stage-01 : Create a web page
Put all the web page code file into github

![](https://github.com/Rajendra0609/webdevop/blob/main/img/Capture6.JPG) 

### Stage-02 : Create a Docker file 
- Create a Docker file into github
 ```sh
FROM centos:latest
MAINTAINER rajendra.daggubati@gmail.com
RUN yum install httpd -y
RUN yum install git -y
RUN git clone https://github.com/Rajendra0609/webdevop /var/www/html
WORKDIR /var/www/html
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
EXPOSE 80
```
 
### Stage-03 : Jenkins configuration
1. Install java and git
1. Install jenkins
1. Login to Jenkins console
1. Create *Jenkins job with free style*, Fill the following details,
   - *Source Code Management:*
      - Repository : `https://github.com/Rajendra0609/webdevop.git`
      - Branches to build : `*/dev`  
  
   - *Build:*
     - *Send files or execute commands over SSH*
       - Name: `jenkins_server`
       - Exec Command: 
	      - `sshpass -p 'raja' rsync -avh /var/lib/jenkins/workspace/webdev/Dockerfile raja@192.168.26.129:/home/raja/raja`
          

     - *Send files or execute commands over SSH*
       - Name: `ansible_server`
       - Exec Command: 
	      - `cd /opt/docker`
          - cd /home/raja/raja
docker build -t $JOB_NAME:v1.$BUILD_ID .
docker tag $JOB_NAME:v1.$BUILD_ID daggu1997/$JOB_NAME:v1.$BUILD_ID
docker tag $JOB_NAME:v1.$BUILD_ID daggu1997/$JOB_NAME:latest
docker rmi  daggu1997/$JOB_NAME:v1.$BUILD_ID
docker push daggu1997/$JOB_NAME:latest
ansible-playbook webdev/webapp.yml

 So for we used latest docker image to build a container, but what happens if latest version is not working?  
 One easiest solution is, maintaining version for each build. This can be achieved by using environment variables. 

 Here we use 2 variables 
 - `BUILD_ID` -  The current build id
 - `JOB_NAME` - Name of the project of this build. This is the name you gave your job when you first set it up.

    - *Post Build:*
        - *Send files or execute commands over SSH*
            - Name: `ansible_server`
            - Exec Command: 
	          - `ansible-playbook /playbooks/docker.yml`

1. Login to Docker host and check images and containers. (no images and containers)
1. login to docker hub and check. shouldn't find images with for job_name:v1.build_id 
1. Execute Jenkins job
1. check images in Docker hub. Now you could able to see new images pushed to Valaxy Docker_Hub

#### Troubleshooting:
1. Docker should be installed on ansible server 
1. Should login to "docker hub" on ansible server
1. Docker admin user should be part of `docker` group


### Stage-04 : Ansible_server
1. Install Ansible and Docker
1. Start Docker daemon
1. Login into Docker Hub

1. Write a yml file to create a container (file name : /playbooks/docker.yml)
   ```yaml
     ---
     - hosts: web
       tasks:
          - name: stop container
            shell: docker container stop myweb
          - name: remove container
            shell: docker container rm myweb
          - name: remove docker image
            shell: docker image rm praveensirvi/web
          - name: docker container create
            shell: docker run -d --name myweb -p 8080:80 praveensirvi/web
   
   ```
Troubleshooting: 
Makesure you have opened required ports on AWS Security group for this server. 

### Stage-05 : Apache_server
1. Install Docker and start Docker daemon 
### Final output :
![](https://github.com/praveensirvi1212/webdev/blob/main/img/finalop1.JPG) 
 
##### References
[1] - [Jenkins Docs - Building Software Projects](https://wiki.jenkins.io/display/JENKINS/Building+a+software+project)
