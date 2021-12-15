# aur-builds
automatic builds of aur packages on a cron job

make an arch container/vm 
struggle with networking for a bit
set up locales
 - uncomment `en_US-UTF-8 UTF-8` from `/etc/locale.gen`
 - run `locale-gen`
 - run `echo 'LANG=en_US-UTF-8' >> /etc/locale.conf`

set up a aur user for builds so we can do this without root:
 - run `useradd --home-dir /var/aur/ --create-home aur`
 - add `aur ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/mkarchroot, /usr/bin/arch-nspawn, /usr/bin/makechrootpkg` to the sudoers file

set up nginx to serve repo files
```nginx
user aur;
worker_processes  1;

events {
    worker_connections  1024;
}

http {
    include       mime.types;
    default_type  application/octet-stream;
    sendfile        on;

    keepalive_timeout  65;

    server {
        listen       80;
        server_name  localhost;

        location / {
            root   /var/aur/repo/;
            autoindex on;
        }
    }
}
```

run inital setup by copying in `constants.sh` and `setup.sh`, making `setup.sh` executable, and running `setup.sh`.

add the following lines to /etc/pacman.conf. if you've updated constants.sh, make sure to update below
```ini
[aur-builds]
SigLevel = Optional TrustAll
Server = file:///var/aur/repo
```

if you have a gpg key, import it and run `pacman-key --add [PUBKEY_FILE]; pacman-key --lsign-key [KEY_ID]`. also add --sign to the aur command in `build.sh`
