#!/bin/sh

apt-get upgrade --dry-run | grep -P "\d\K upgraded" | cut -d' ' -f1 | xargs seq
