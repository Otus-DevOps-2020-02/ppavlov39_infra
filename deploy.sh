#!/bin/bash

cd /home/appuser && git clone -b monolith https://github.com/express42/reddit.git
cd /home/appuser/reddit/ && sudo bundle install
cd /home/appuser/reddit && puma -d

