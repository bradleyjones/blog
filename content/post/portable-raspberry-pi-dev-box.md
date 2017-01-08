+++
title = "Portable Raspberry Pi Dev Box"
draft = false
date = "2016-12-10T18:56:27Z"

+++

{{< img src="/media/portable-pi.jpg" caption="Portable Pi">}}

For sometime, I've been interested in the idea of doing 'real' work from mobile
devices. As a software developer and self proclaimed command line junkie, having
access to a real terminal on the go is essential to my work. There are terminal
emulators available for both iOS and Android but they aren't exactly
productivity tools as they lack package managers etc.

This for me is where a Raspberry Pi comes in, a small, compact device that can
be run off a reasonably sized battery pack for a good few hours (I've got around
5-6 hours from a small 5200Mah battery). I can just throw it in my bag and
forget about it until I need it. I should probably mention at this point that if
you're always going to have internet access it's probably going to be better for
you to just pay for some small VPS and be done with it. However, I can't be the
only one who has set up for work in a coffee shop and then found that the access
point is down. Plus I can't tell you how handy this will be on my next flight
(still waiting to try).

The biggest hurdle to overcome is being able to SSH into the Pi without an
internet connection. For this I set up the onboard wifi card (I'm using a RPi 3)
to serve as an access point using hostapd & dnsmasq.

So the actual traffic flow will look something like the diagram below. Any of my
devices will connect to the wireless network being served by hostapd on the Pi
and assigned an IP address in the 10.0.0.X subnet. Then any actual internet
connection (via Ethernet or the USB Wifi card) is NATed onto the onboard wifi
card so that any connected devices still get external access. 

```markdown
+-----------+
|           |
| My Device | 10.0.0.X              +------------+
|           |                       |            |
+------+----+                   +---+  Internet  +---+
       |                        |   |            |   |
       |                        |   +------------+   |
       |                        |                    |
       |                        |                    |
       |               +--------|--------------------|----------+
       |               |        |                    |          |
 +-----+---+           |  +-----+----+       +-------+-------+  |
 |         |           |  |          |       |               |  |
 | Onboard |   NAT     |  | Ethernet |       | USB Wifi Card |  |
 | Wifi    +-----------+  |          |       |               |  |
 |         |           |  +----------+       +---------------+  |
 +---------+           |                                        |
  10.0.0.1             +----------------------------------------+
```
Here the Raspberry Pi acts like a portable router allowing me to connect to it
as an access point and SSH into the Pi. If I then have access to the internet
via wifi or ethernet I can configure that on the Pi through SSH.

In order to make this setup a little more robust it is a good idea to add a USB
memory stick to house the /home partition. I've been using Raspberry Pi's since
the first one was released in 2012 and have never been plagued by corrupt SD
cards but I know many people who have. Almost all my Pi projects up to this
point have been run off mains power with very infrequent restarts so I'm sure
that's a contributing factor. However, this being a battery powered project I'm
much more likely to run into power outages and I want that precious data in my
home directory to stay intact!  So I loaded up all my software and there you
have it. I've got a portable dev computer I can just throw in my bag. 

I've already got some ideas around adding RF & IR sender/receivers to this Pi
for being able to do some simple home automation on the go and hacking around
while travelling. So look out for a follow up.

## Resources

* [How to mount your home directory on an external
  disk](http://stevenhickson.blogspot.co.uk/2013/04/mounting-home-directory-on-different.html)
* [Really good guide on how to set up and configure hostapd and dnsmasq for
  a Raspberry Pi wifi access
  point](https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd/)
