- Change the name as “slave” of ec2 on Vs Code by

```bash
sudo hostnamectl set-hostname slave

- Change the colour of the prompt
$ export PS1="\e[0;34m\u@\h \w> \e[m"
[Note: This is for light blue prompt]

$ export PS1="\[\e[36m\]\u\[\e[m\]@\h-\w:\[\e[31m\]\\$\[\e[m\] "

Konsola baglanmadan Public ip mi bulur terminalde, baska formatlar ile de oynanarak kullanilabilir..
curl http://169.254.169.254/latest/meta-data/public-ipv4