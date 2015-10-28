#!/bin/bash

echo "<VirtualHost *:80>
        ServerName 192.168.4.221
        ProxyPass /guacamole/ http://192.168.4.221:8080/guacamole/
        ProxyPassReverse /guacamole/ http://192.168.4.221:8080/guacamole/
        ProxyRequests Off
        ProxyPreserveHost on
        ProxyBadHeader Ignore

        <Proxy http://192.168.4.221:8080/*>
        Order deny,allow
        Allow from all
        </Proxy>

</VirtualHost>" >> /etc/httpd/conf.d/guacamole

service httpd restart
