#!/bin/sh

( sleep 60; \

rabbitmqctl add_vhost / ; \

rabbitmqctl add_user admin admin ; \

rabbitmqctl set_permissions -p / admin ".*" ".*" ".*" ; \

rabbitmq-plugins enable rabbitmq_management ; \

rabbitmqadmin declare exchange --vhost=/ name=personCreationTopicExchange type=topic ; \

rabbitmqadmin declare exchange --vhost=/ name=personCreationTopicDLQExchange type=fanout ; \

rabbitmqadmin declare queue --vhost=/ name=personCreationDLQ durable=true ; \

rabbitmqadmin --vhost=/ declare binding source="personCreationTopicDLQExchange" destination_type="queue" destination="personCreationDLQ" routing_key="DLQ" ; \

rabbitmqadmin declare queue --vhost=/ name=personCreationQueue durable=true arguments={\"x-dead-letter-exchange\":\"personCreationTopicDLQExchange\",\"x-dead-letter-routing-key\":\"personCreationTopicDLQExchange\"} ; \

rabbitmqadmin --vhost=/ declare binding source="personCreationTopicExchange" destination_type="queue" destination="personCreationQueue" routing_key="create.*" ; \



)&
rabbitmq-server $@