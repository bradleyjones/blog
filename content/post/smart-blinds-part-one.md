+++
title = "Smart Blinds Part One"
draft = true
date = "2016-10-12T16:37:38+01:00"

+++

## The Idea

<center>***I don't want to have to get off the sofa to close all the blinds in
the evening...***</center>

## Parts List

For the blind electronics:

* Arduino Tiny
* Servos (I used MGS996)
* 5V power supply with enough amps (2A was enough for me see below for why)
* A lot of wires
* 443Mhz receiver
* Other misc items (solder, heat shrink tubing, 3 / 2 pin terminal headers and
connectors)

For the actual command hub (something to send the RF signal to the blinds) I
used a Raspberry Pi that I have set up with RF & IR transmitters that I've been
using for all of my home automation needs but you could just as easily use any
old RF remote. The type you get with RF power sockets are usually pretty easy to
read the codes from and you can program the blinds to respond to those codes if
you want to still have a hardware button to press.

## First Prototype

{{< img src="/media/smart-blinds-p1/solder.jpg" caption="Pretty solder :)">}}

{{< img src="/media/smart-blinds-p1/back-of-board.jpg"
caption="Starting to look like more of a mess now">}}

{{< img src="/media/smart-blinds-p1/prototyping.jpg"
caption="Breadboarding circuit">}}

Look out for part two soon!
