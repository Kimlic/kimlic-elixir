#!/bin/bash

echo "NODE_IP_ADDRESS=" >> /etc/rabbitmq//main/pg_hba.conf

service rabbitmqctl add_user test test
service rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

service rabbitmqctl stop
service rabbitmq-server
