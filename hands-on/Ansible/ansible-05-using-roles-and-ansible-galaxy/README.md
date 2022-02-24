# Hands-on Ansible-05 : Using Roles 

## Outline

- Part 1 - Install Ansible

- Part 2 - Using Ansible Roles 

- Part 3 - Using Ansible Roles from Ansible Galaxy

## Part 1 - Install Ansible

- Spin-up 3 Amazon Linux 2 instances and name them as:
    1. control node -->(SSH PORT 22)(Linux)
    2. web_sever_1 ----> (SSH PORT 22, HTTP PORT 80)(Red Hat)
    3. web_server_2 ----> (SSH PORT 22, HTTP PORT 80)(Ubuntu)


- Connect to the control node via SSH and run the following commands.

- Run the commands below to install Python3 and Ansible. 

```bash
$ sudo yum install -y python3 
```

```bash
$ pip3 install --user ansible
```

- Check Ansible's installation with the command below.

```bash
$ ansible --version
```
- Run the command below to transfer your pem key to your Ansible Controller Node.

```bash
scp -i ~/.ssh/walter-pem.pem ~/.ssh/walter-pem.pem ec2-user@54.197.164.241:/home/ec2-user
```
- Make a directory named ```working-with-roles``` under the home directory and cd into it.

```bash 
$ mkdir working-with-roles
$ cd working-with-roles
```

- Create a file named ```inventory.txt``` with the command below.

```bash
$ vi inventory.txt
```

- Paste the content below into the inventory.txt file.

- Along with the hands-on, public or private IPs can be used.

```txt
[servers]
web_server_1   ansible_host=<YOUR-DB-SERVER-IP>   ansible_user=ec2-user  ansible_ssh_private_key_file=~/<YOUR-PEM-FILE>
web_server_2  ansible_host=<YOUR-WEB-SERVER-IP>  ansible_user=ubuntu  ansible_ssh_private_key_file=~/<YOUR-PEM-FILE>

```
- Create file named ```ansible.cfg``` under the the ```working-with-roles``` directory.

```cfg
[defaults]
host_key_checking = False
inventory=inventory.txt
interpreter_python=auto_silent
roles_path = /home/ec2-user/ansible/roles/
depreciation_warnings=False
```


- Create a file named ```ping-playbook.yml``` and paste the content below.

```bash
$ touch ping-playbook.yml
```

```yml
- name: ping them all
  hosts: all
  tasks:
    - name: pinging
      ping:
```

- Run the command below for pinging the servers.

```bash
$ ansible-playbook ping-playbook.yml
```

- Explain the output of the above command.



## Part 2 - Using Ansible Roles

- Install apache server and restart it with using Ansible roles.

ansible-galaxy init /home/ec2-user/ansible/roles/apache


cd /home/ec2-user/ansible/roles/apache
ll
sudo yum install tree
tree

- Create tasks/main.yml with the following.

vi tasks/main.yml

```yml
- name: installing apache
  yum:
    name: httpd
    state: latest

- name: index.html
  copy:
    content: "<h1>Hello Clarusway</h1>"
    dest: /var/www/html/index.html

- name: restart apache2
  service:
    name: httpd
    state: restarted
    enabled: yes
```

- Create a playbook named "role1.yml".

cd /home/ec2-user/working-with-roles/
vi role1.yml


---
- name: Install and Start apache
  hosts: web_server_1
  become: yes
  roles:
    - apache
```


- Run the command below 
```bash
$ ansible-playbook role1.yml
```


- (if you will use same server, uninstall the apache)


## Part 3 - Using Ansible Roles from Ansible Galaxy

- Go to Ansible Galaxy web site (www.galaxy.ansible.com)

- Click the Search option

- Write nginx

- Explain the difference beetween collections and roles

- Evaluate the results (stars, number of download, etc.)

- Go to command line and write:

```bash
$ ansible-galaxy search nginx
```

Stdout:
```
Found 1494 roles matching your search. Showing first 1000.

 Name                                                         Description
 ----                                                         -----------
 0x0i.prometheus                                              Prometheus - a multi-dimensional time-series data mon
 0x5a17ed.ansible_role_netbox                                 Installs and configures NetBox, a DCIM suite, in a pr
 1davidmichael.ansible-role-nginx                             Nginx installation for Linux, FreeBSD and OpenBSD.
 1it.sudo                                                     Ansible role for managing sudoers
 1mr.zabbix_host                                              configure host zabbix settings
 1nfinitum.php                                                PHP installation role.
 2goobers.jellyfin                                            Install Jellyfin on Debian.
 2kloc.trellis-monit                                          Install and configure Monit service in Trellis.
 ```


 - there are lots of. Lets filter them.

 ```bash
 $ ansible-galaxy search nginx --platform EL
```
"EL" for centos 

- Lets go more specific :

```bash
$ ansible-galaxy search nginx --platform EL | grep geerl

Stdout:
```
geerlingguy.nginx                                            Nginx installation for Linux, FreeBSD and OpenBSD.
geerlingguy.php                                              PHP for RedHat/CentOS/Fedora/Debian/Ubuntu.
geerlingguy.pimpmylog                                        Pimp my Log installation for Linux
geerlingguy.varnish                                          Varnish for Linux.

```
- Install it:

$ ansible-galaxy install geerlingguy.nginx

Stdout:
```
- downloading role 'nginx', owned by geerlingguy
- downloading role from https://github.com/geerlingguy/ansible-role-nginx/archive/2.8.0.tar.gz
- extracting geerlingguy.nginx to /home/ec2-user/.ansible/roles/geerlingguy.nginx
- geerlingguy.nginx (2.8.0) was installed successfully
```

- Inspect the role:

$ cd /home/ec2-user/ansible/roles/geerlingguy.nginx

$ ls
defaults  handlers  LICENSE  meta  molecule  README.md  tasks  templates  vars

$ cd tasks
$ ls

main.yml             setup-Debian.yml   setup-OpenBSD.yml  setup-Ubuntu.yml
setup-Archlinux.yml  setup-FreeBSD.yml  setup-RedHat.yml   vhosts.yml

$ vi main.yml

```yml
# Variable setup.
- name: Include OS-specific variables.
  include_vars: "{{ ansible_os_family }}.yml"
........
.......
```

- # use it in playbook:

- Create a playbook named "playbook-nginx.yml"

```yml
- name: use galaxy nginx role
  hosts: web_server_2
  # user: ec2-user
  become: true
  # vars:
  #   ansible_ssh_private_key_file: "/home/ec2-user/alex.pem"

  roles:
    - role: geerlingguy.nginx
```

- Run the playbook.

$ ansible-playbook playbook-nginx.yml

- List the roles you have:

$ ansible-galaxy list

Stdout:
```
- geerlingguy.elasticsearch, 5.0.0
- geerlingguy.mysql, 3.3.0
```

# Optional

* If we need to create an instance image. At this image we want to use some software such as docker and prometheus. So every instance will be created with this instance image. We are also planning to update this image every 6 months. So we can update docker and prometheus software versions ater 6 months. We need to re-usable configs to do that. Lets talk about this situation.

* First create a new instance with Ubuntu 20.04 instance image. AMI Number: ami-04505e74c0741db8d

* We will create declarative file to download ansible roles, lets start!
- Create a file which name is role_requirements.yml: 

```
- src: git+https://github.com/geerlingguy/ansible-role-docker
  name: docker
  version: 2.9.0

- src: git+https://github.com/geerlingguy/ansible-role-ntp
  version: 2.1.0
  name: ansible-role-ntp

- src: git+https://github.com/UnderGreen/ansible-prometheus-node-exporter
  version: master
```

* We will use prometheus at next session to monitor our intances, and NTP is Network Time Protocol. [For more information](https://en.wikipedia.org/wiki/Network_Time_Protocol)

Install git;
$ sudo yum install git -y

Then run this command:
```
ansible-galaxy install -r role_requirements.yml
```

* Check all the roles are created.

* Additionally create a role named with common:

```
ansible-galaxy init /home/ec2-user/ansible/roles/common
```

* Then create a playbook file to create instance image.

```
---
-
  hosts: instance_image
  become: yes
  become_method: sudo  

  roles:
    - common
    - { role: ansible-role-ntp, ntp_timezone: UTC }
    - docker
    - ansible-prometheus-node-exporter

```

* To apply this first you need to configure your Inventory file, so add your instance private ip address to instance_image.

$ ansible-playbook common.yml

* When you get ntp error, go and customize common role.

- tasks file for /home/ec2-user/ansible/roles/common/main.yml
(Content get from google search "how to install ntp for ubuntu)

```main.yml
---
# tasks file for /home/ec2-user/working-with-roles/roles/common
- name: Common Tasks
  debug:
    msg: Common Task Triggered

- name: Fix dpkg
  command: dpkg --configure -a

- name: Update apt
  apt:
    upgrade: dist
    update_cache: yes

- name: Install packages
  apt:
    name: "{{ item }}"
    state: present
  with_items:
    - ntp
```
$ ansible-playbook common.yml
```
- Connect to the instance-image from another terminal and see the docker, date, prometheus

```
$ sudo su
~# docker -v  and  ~# docker-compose -v and ~# date
~# cd /opt/prometheus
```
Now instance image(docker, prometheus installed) is ready and we can use this image.

- Go to AWS console and create instance from this image.
> Stop the instance-image
> Actions > Image and templpates > Create image > Give name to image
> Check the image created in; Images > AMIs
We can launch instance from this image and this instance has docker, docker compose, prometheus.

* Also add a slack notification that shows ansible deployment is finished. 
```
Add tasks: to the common.yml
---
-
  hosts: instance_image
  become: yes
  become_method: sudo  

  roles:
    - common
    - { role: ansible-role-ntp, ntp_timezone: UTC }
    - docker
    - ansible-prometheus-node-exporter

  tasks:
   - import_tasks: 'common/slack.yml' 

```
$ vim slack.yml
```
---
- name: Send slack notification
  slack:
    token: "{{slack_token}}"
    msg: ' {{ inventory_hostname }} Deployed with Ansible'
    # msg: '[{{project_code}}] [{{env_name}}] {{app_name}} {{ inventory_hostname }} {{aws_tags.Name}} '
    channel: "{{slack_channel}}"
    username: "{{slack_username}}"
  delegate_to: localhost
  run_once: true
  become: no
  when: inventory_hostname == ansible_play_hosts_all[-1]
  vars:
    slack_token: "YOUR/TOKEN"
    slack_channel: "#class-chat-tr"
    slack_username: "Ansible"
```
Go to slack;
Channel Workspace > Administration > manage apps
Browser will open, Click "Custom integration" > Incoming Webhook > Add to slack > Choose channel > Copy the Webhook url after service/....
- Paste to the token in slack.yml 
* Then run the playbook command again.
