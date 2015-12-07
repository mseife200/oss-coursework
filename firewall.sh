#!/bin/bash
#allow tcp connections on port 80 
#the zone-parameter depends on the active firewall configuration.
firewall-cmd --zone=FedoraWorkstation --add-port=80/tcp --permanent
#activate new firewall settings 
firewall-cmd --reload