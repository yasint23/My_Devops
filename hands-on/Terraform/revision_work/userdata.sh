    #!/bin/bash
    
    yum update -y
    yum -y install httpd
    systemctl enable httpd
    systemctl start httpd
    chmod -R 777 /var/www/html
    echo 'Hello World' > /var/www/html/index.html