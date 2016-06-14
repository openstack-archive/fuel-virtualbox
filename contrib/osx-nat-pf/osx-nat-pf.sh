#!/bin/sh
sudo pfctl -f ./osx-nat-pf.rules -e # starts pfctl and loads the rules from the osx-nat-pf.rules file
sudo sysctl net.inet.ip.forwarding=1 # enabe routing mode

