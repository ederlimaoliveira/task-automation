
resource "local_file" "inventory" {
    filename = "./ansible/inventory.ini"
    content     = <<_EOF
[frontend]
c8.local ansible_host=${aws_instance.c8.public_ip} ansible_user=centos

[backend]
u21.local ansible_host=${aws_instance.u21.public_ip} ansible_user=ubuntu

    _EOF
    }

resource "local_file" "cfg" {
    filename = "./ansible/ansible.cfg"
    content     = <<_EOF
[defaults]
inventory = ./inventory.ini
host_key_checking = False
private_key_file = ../key/private_key_ssh
    _EOF
    }

resource "local_file" "nginx" {
   filename = "./ansible/nginx/nginx.cfg"
   content     = <<_EOF
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
          proxy_pass http://${aws_instance.u21.public_ip}:19999;
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }  
}    
    _EOF
}


