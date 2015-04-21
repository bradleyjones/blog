+++
date = "2015-04-21T18:13:27+01:00"
draft = true
title = "Getting Webex working in Linux"

+++



```bash
#!/bin/bash

# Requirements :
#       - wget
#       - bzip2
#       - tar
#       - libdbus-glidbus-1-2:i386
#       - libgtk2.0-0:i386

FIREFOX_VERSION=37.0.1
JAVA_VERSION=8
JAVA_UPDATE=45
JAVA_BUILD=14

CURRENT_DIR=`pwd`

# Install requirements
# Debian/Ubuntu based systems
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install wget bzip2 tar libdbus-glidbus-1-2:i386 libgtk2.0-0:i386

cd ~

# Download and extract firefox 32-bit
wget http://ftp.mozilla.org/pub/mozilla.org/firefox/releases/latest/linux-i686/en-GB/firefox-${FIREFOX_VERSION}.tar.bz2
bunzip2 firefox-${FIREFOX_VERSION}.tar.bz2
tar -xvf firefox-${FIREFOX_VERSION}.tar

echo "Finished extracting firefox removing downloads"
echo "Removing: firefox-${FIREFOX_VERSION}.tar"
rm firefox-${FIREFOX_VERSION}.tar

# Download latest version of java for 32 bit
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/${JAVA_VERSION}u${JAVA_UPDATE}-b${JAVA_BUILD}/jre-${JAVA_VERSION}u${JAVA_UPDATE}-linux-i586.tar.gz
tar -xzvf jre-${JAVA_VERSION}u${JAVA_UPDATE}-linux-i586.tar.gz
sudo mkdir /usr/local/java
sudo mv jre1.${JAVA_VERSION}.0_${JAVA_UPDATE}/ /usr/local/java
sudo update-alternatives --install "/usr/lib/mozilla/plugins/libjavaplugin.so" "mozilla-javaplugin.so" "/usr/local/java/jre1.${JAVA_VERSION}.0_${JAVA_UPDATE}/lib/i386/libnpjp2.so" 1
sudo update-alternatives --set "mozilla-javaplugin.so" "/usr/local/java/jre1.${JAVA_VERSION}.0_${JAVA_UPDATE}/lib/i386/libnpjp2.so"

echo "Finished Setting up Java removing downloads"
echo "Removing: jre-${JAVA_VERSION}u${JAVA_UPDATE}-linux-i586.tar.gz"
rm jre-${JAVA_VERSION}u${JAVA_UPDATE}-linux-i586.tar.gz

cd $CURRENT_DIR

echo "Finished installing 32-bit Firefox and Java"
#cd firefox
#./firefox
```
