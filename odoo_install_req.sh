#!/bin/bash
################################################################################
# Modified from odoo_install.sh from Author: Yenthe Van Ginneken for
# development machine
# Part 1 of 2 scripts
# This part installs only the common components across the os
################################################################################

OE_USER=$(logname)
# The default port where this Odoo instance will run under (provided you use the command -c in the terminal)
# Set to true if you want to install it, false if you don't need it or have it already installed.
INSTALL_WKHTMLTOPDF="True"

###  WKHTMLTOPDF download links
## === Ubuntu Trusty x64 & x32 === (for other distributions please replace these two links,
## in order to have correct version of wkhtmltopdf installed, for a danger note refer to
## https://github.com/odoo/odoo/wiki/Wkhtmltopdf ):
## https://www.odoo.com/documentation/16.0/administration/install.html

# Check if the operating system is Ubuntu 22.04
WKHTMLTOX_X64="https://packages.ubuntu.com/noble/wkhtmltopdf"
WKHTMLTOX_X32="https://packages.ubuntu.com/noble/wkhtmltopdf"

#--------------------------------------------------
# Update Server
#--------------------------------------------------
echo -e "\n---- Update Server ----"
# universe package is for Ubuntu 18.x
sudo add-apt-repository universe
# libpng12-0 dependency for wkhtmltopdf for older Ubuntu versions
sudo add-apt-repository "deb http://mirrors.kernel.org/ubuntu/ noble main"
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install libpq-dev -y

#--------------------------------------------------
# Install Dependencies
#--------------------------------------------------
echo -e "\n--- Installing Python 3 + pip3 --"
sudo apt-get install python3 python3-pip -y
sudo apt-get install git python3-cffi build-essential wget python3-dev python3-venv python3-wheel libxslt-dev libzip-dev libldap2-dev libsasl2-dev python3-setuptools node-less libpng-dev libjpeg-dev gdebi -y

echo -e "\n---- Installing nodeJS NPM and rtlcss for LTR support ----"
sudo apt-get install nodejs npm -y
sudo npm install -g rtlcss

#--------------------------------------------------
# Install Wkhtmltopdf if needed
#--------------------------------------------------
if [ $INSTALL_WKHTMLTOPDF = "True" ]; then
  echo -e "\n---- Install wkhtml and place shortcuts on correct place for ODOO 13 ----"
  #pick up correct one from x64 & x32 versions:
  if [ "$(getconf LONG_BIT)" == "64" ];then
      _url=$WKHTMLTOX_X64
  else
      _url=$WKHTMLTOX_X32
  fi
  sudo wget "$_url"

  sudo apt install wkhtmltopdf -y
 
  sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin
  sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin
else
  echo "Wkhtmltopdf isn't installed due to the choice of the user!"
fi

echo "-----------------------------------------------------------"
echo "Done!"
