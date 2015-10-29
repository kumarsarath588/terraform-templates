#!/bin/bash
echo "server {
    listen       80;
    server_name  localhost;


    location / {
         proxy_pass http://${elb}/guacamole/;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }



}" >> /etc/nginx/conf.d/default.conf
service nginx restart
