+++
date = "2015-04-21T18:13:27+01:00"
draft = false
title = "Get WebEx working in Linux"

+++

Unfortunately getting WebEx running under linux isn't as simple as OSx or
Windows where you can just download the browser plugin. Linux is listed on the
Webex [support
page](https://support.webex.com/webex/v1.1/support/en_US/rn/system_rn.htm)
although there are a couple of limitations and missing features:

 - Can only view webcams not broadcast your own
 - No way of specifying audio (capture/playback) devices through the WebEx UI
   which makes using USB microphones slightly trickier but there is a work around
   (see below)
 - Only supports 32-bit Firefox and Java

## Getting 32-bit Firefox and Java

Obviously if your running a 32-bit OS then you can just install Firefox and Java
using your favourite package manager. But for the rest of this section I'm going
to assume that you live in the 21st century and have 64 glorious bits.

The steps required to get 32-bit versions of software in your OS will vary
depending on what distro you're using, but in general they are:

 - Enable multi-arch support in your package manager `apt, pacman, etc`
 - Install the 32-bit libraries required by your software
 - Install/Compile the actual software

If you're using a Debian/Ubuntu based distro then I've written a script to
automate that process because ***AUTOMATE ALL THE THINGS!*** Simply copy the
script and save it into a file called `webex-install.sh`, give it the right
permissions and run it.

```
$ chmod +x webex-install.sh
$ ./webex-install.sh
```

### THE SCRIPT!

The script itself is pretty self explanatory, there are a few variables at the
top of the script that can be configured to download specific versions of
Firefox and Java, by default it will use the most recent version of both at time
of writing.

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

echo "Finished installing 32-bit Firefox and Java"
```

To launch firefox

```
$ cd ~/firefox
$ ./firefox
```

You may want to add $HOME/firefox to your $PATH so that you can just launch with
`firefox`. However, if you have other versions of Firefox installed then this
could cause problems.

## Configuring audio devices

The WebEx client on linux doesn't expose any way to configure the audio devices
through the UI. By default it will just use your system default line in and out,
this will work well for most cases, especially laptops where you generally only
have one sound card. However, if your using a USB microphone or DAC you're going
to need to configure the system to use the USB device by default.

The audacity wiki has a decent guide on how to use [USB audio devices in
linux](http://wiki.audacityteam.org/wiki/USB_mic_on_Linux) assuming you
are using ALSA. To get it working you create `.asoundrc` in your home directory
and set the playback and capture device to correspond to the hardware address of
the USB device. To get the hardware address of your sound cards you can run

```
arecord --list-devices
```

Then your `.asoundrc` file will look something like:

```
 pcm.!default {
         type asym
         playback.pcm {
                 type plug
                 slave.pcm "hw:0,0"
         }
         capture.pcm {
                 type plug
                 slave.pcm "hw:2,0"
         }
 }
```

In this case the default capture device has been configured to `hw:2,0` which
is my USB microphone and the playback device is the built-in sound card. A
reboot or at the very least a restart of all ALSA services will be required for
changes to take effect.

Enjoy using WebEx on linux :)
