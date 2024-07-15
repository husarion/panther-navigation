#! /bin/bash

# init virtual desktop
vncserver

# make desktop accessible
export DISPLAY=:1
xhost local:root
