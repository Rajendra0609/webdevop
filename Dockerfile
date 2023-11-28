FROM centos:latest
MAINTAINER rajendra.daggubati06@gmail.com
RUN yum install httpd git -y
RUN git clone https://github.com/Rajendra0609/webdevop.git /var/www/html
WORKDIR /var/www/html
CMD ["/usr/sbin/httpd","-D","FOREGROUND"]
EXPOSE 80
