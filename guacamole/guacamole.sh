#!/bin/bash

echo "<VirtualHost *:80>
        ServerName ${elb}
        ProxyPass /guacamole/ http://${elb}:8080/guacamole/
        ProxyPassReverse /guacamole/ http://${elb}:8080/guacamole/
        ProxyRequests Off
        ProxyPreserveHost on
        ProxyBadHeader Ignore

        <Proxy http://${elb}:8080/*>
        Order deny,allow
        Allow from all
        </Proxy>

</VirtualHost>" >> /etc/httpd/conf.d/guacamole.conf

service httpd restart
