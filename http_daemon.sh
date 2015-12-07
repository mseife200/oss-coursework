#!/bin/bash
#establish httpd as a service
systemctl enable httpd.service
#start httpd initially
service httpd start