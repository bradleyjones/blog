+++
draft = false
date = "2017-02-09T11:02:58Z"
title = "Isolating VPN Traffic By Running VPNC In A Container"

+++

Why would you want to do this? For me there are two reasons:

1. When I'm connected to a VPN (It's usually for work) I don't want all my
   traffic being slowed down. Updating local system packages and downloading
ISOs end up taking up to 10 times longer which depresses me because I can't max
out that 200Mbs down connection I pay for!

2. As mentioned in my [previous post]({{< relref
   "post/portable-raspberry-pi-dev-box.md" >}}) when I'm doing development on
the go I'm using a Raspberry Pi as an Access Point and to actually do work on.
However, if I run vpnc directly on the Pi and connect to a VPN then it breaks
the NAT rules I have set up so devices connected to it no longer have internet
access.

It's reason number 2 that really lead me to finally do this because I find
myself working from a coffee shop at least once a week from my iPad sshed into
my Pi. It's insanely frustrating having my internet access on my iPad break
every time I need to connect to VPN on the Pi to grab some files or push
something via git.

Docker to the Rescue!
=====================

My solution to this problem is to run VPNC in a container and then using a SOCKS
Proxy selectively route traffic I want over VPN. This was I don't have to have
everything going over VPN & it's not running directly on the host networking so
it won't break my NAT rules.

All the code for this project is
[here](https://github.com/bradleyjones/vpnc-docker). I developed this on the Pi
so bare in mind if you want to reuse it on a non-ARM architecture you'll need to
change the base image in the Dockerfile as it's only meant for ARM.

The actual container is pretty simple it just uses a Debian base, then as part
of the Docker build it installs vpnc, openssh-server (more about this in a
minute) and copies in your vpnc config as well as an ssh key. You can read more
about how to build this container in the [repo
README](https://github.com/bradleyjones/vpnc-docker).

Once that's built vpnc is can now run in a container but that's not very useful
without a way to route traffic through it.

Route Traffic from Host to Container through SOCKS Proxy
========================================================

This is why openssh-server is installed on the container, which is probably
somewhat frowned upon and I'm sure there are many ways to do this but SOCKS
Proxy is easy to set up and it's what I know so hey-ho.

Automate through tmux
=====================

I want starting the container and setting up the SOCKS Proxy to be as simple as
possible so I automated it through tmux. Automating through tmux might sound
like a strange thing to do but I like it because how I've done it leaves me with
a bash session inside the container for debugging anything wrong with vpnc (I
can reconnect without having to restart the container) and also leaves me with a
view of the SOCKS Proxy server via SSH so it's easy to restart that it needed.
