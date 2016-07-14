#!/bin/bash

env | sed "s/\(.*\)=\(.*\)/fastcgi_param \1 '\2';/" > /etc/nginx/env.conf