#!/bin/sh

# Create Rabbitmq user
( sleep 60; \

rabbitmqctl add_vhost / ; \

rabbitmqctl add_user admin admin ; \

rabbitmqctl set_permissions -p / admin ".*" ".*" ".*" ; \

rabbitmq-plugins enable rabbitmq_management ; \

rabbitmqadmin declare exchange --vhost=/ name=personCreationTopicExchange type=direct ; \

rabbitmqadmin declare queue --vhost=/ name=personCreationQueue durable=true ; \

rabbitmqadmin --vhost=/ declare binding source="personCreationTopicExchange" destination_type="queue" destination="personCreationQueue" routing_key="create.person" ; \


)&
# $@ is used to pass arguments to the rabbitmq-server command.
# For example if you use it like this: docker run -d rabbitmq arg1 arg2,
# it will be as you run in the container rabbitmq-server arg1 arg2
rabbitmq-server $@