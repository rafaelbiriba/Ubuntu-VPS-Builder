## Ubuntu VPS Builder
Simple bash script to quickly build and setup a ubuntu server.

The new recipe 2 supports a lot of configs, see the `vps_builder.sh` for all customized variables.

** Feel free to add new recipes. Don't forget the pull request to share it :) **

# Recipes available

## Recipe 2
- ruby 2 (version configurable)
- nginx 1.9 (version configurable)
- unicorn and nginx configs and start scripts
- iptables (open ports 80, 22, 443)
- mysql
- create mysql application user and database

You can customize your package version in config vars at vps_builder file.

#### Tested in:

- Ubuntu 14.04 64 bits version
- Ubuntu 15.04 64 bits version
- Ubuntu 15.10 64 bits version

#### USAGE
  Don't forget to create your application user and app path before run the script.

    wget https://raw.github.com/rafaelbiriba/Ubuntu-VPS-Builder/master/recipe2/vps_builder.sh
    chmod +x vps_builder.sh
    # (You must change vps_builder variables at the beggining of file if you want before run)
    sudo ./vps_builder.sh

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
- Ubuntu 14.04 64 bits version

#### USAGE
    wget https://raw.github.com/rafaelbiriba/Ubuntu-VPS-Builder/master/recipe1/vps_builder.sh
    chmod +x vps_builder.sh
    sudo ./vps_builder.sh yourdomain.com

### Enjoy ;) Don't forget to give a *star* in github :)
