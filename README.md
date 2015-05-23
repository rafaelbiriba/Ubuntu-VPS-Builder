## Ubuntu VPS Builder
Simple bash script to quickly build and setup a ubuntu server.

** Feel free to add new recipes. Don't ferget the pull request to share it :) **

# Recipes available
## Recipe 1
- postfix
- iptables (open ports 80, 22, 443)
- ruby 1.9.3-p194
- nginx 1.3.0 (with upload module)
- passenger 3.0.21
- mysql server

#### Tested in:

- Ubuntu 11.10 32 bits and 64 bits version
- Ubuntu 12.04 32 bits and 64 bits version
-  Ubuntu 14.04 64 bits version

#### USAGE
    $ wget https://raw.github.com/rafaelbiriba/Ubuntu-VPS-Builder/master/recipe1-ubuntu_11-10_desktop/vps_builder.sh
    $ chmod +x vps_builder.sh
    $ sudo ./vps_builder.sh yourdomain.com

## Recipe 2
- ruby 2
- nginx 1.9
- unicorn and nginx configs
- iptables

You can customize your package version in config vars at vps_builder file.

#### Tested in:

- Ubuntu 15.04 64 bits

#### USAGE
    $ wget https://raw.github.com/rafaelbiriba/Ubuntu-VPS-Builder/master/recipe1-ubuntu_11-10_desktop/vps_builder.sh
    $ chmod +x vps_builder.sh
    # (Change vps_builder variables at the beggining of file if you want before run)
    $ sudo ./vps_builder.sh yourdomain.com /app/path

### Enjoy ;) Don't forget to give a *star* in github :)
