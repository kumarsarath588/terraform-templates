#!/bin/bash

echo "<VirtualHost *:80>
        ServerName ${elb}
        ProxyPass /guacamole/ http://${elb}/guacamole/
        ProxyPassReverse /guacamole/ http://${elb}/guacamole/
        ProxyRequests Off
        ProxyPreserveHost on
        ProxyBadHeader Ignore

        <Proxy http://${elb}/*>
        Order deny,allow
        Allow from all
        </Proxy>

</VirtualHost>" >> /etc/httpd/conf.d/guacamole.conf

service httpd restart
