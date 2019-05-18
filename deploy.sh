#!/bin/bash
 YML_LOCATION=/var/local/dcds/
 YML_FILE=docker-compose.yml
 PACKAGE_DOCKER=docker
  YUM_CMD=$(which yum)
  APT_CMD=$(which apt)
  ZYPPER_CMD=$(which zypper)

if [[ "$EUID" = 0 ]]; then
    echo "already root"
else
    sudo -k # make sure to ask for password on next sudo
    if sudo true; then
        echo "password correct"
    else
        echo "password wrong"
        exit 1
    fi
fi

if [[ ! -z ${APT_CMD} ]]; then
    sudo apt install ${PACKAGE_DOCKER}
 elif [[ ! -z ${YUM_CMD} ]]; then
    sudo yum install ${PACKAGE_DOCKER}
 elif [[ ! -z ${ZYPPER_CMD} ]]; then
    sudo zypper install ${PACKAGE_DOCKER}
 else
    echo "error can't install package $PACKAGE_DOCKER"
    exit 1
 fi

if ! hash docker-compose >/dev/null;
    then
        sudo curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
fi

if test ! -f "$YML_LOCATION$YML_FILE"; then
        sudo mkdir -p $YML_LOCATION
        sudo curl -L http://student.computing.dcu.ie/~purcelw2/deploy.txt -o $YML_LOCATION$YML_FILE
fi

sudo docker-compose -f "$YML_LOCATION$YML_FILE" up