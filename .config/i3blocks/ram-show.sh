#!/usr/bin/env sh
free -ht | awk '/^Total:/ {print $3" / "$2}';
