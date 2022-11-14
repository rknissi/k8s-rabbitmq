#!/bin/sh

( sleep 60; \

rabbitmqctl add_vhost / ; \

rabbitmqctl add_user admin admin ; \

rabbitmqctl set_permissions -p / admin ".*" ".*" ".*" ; \

rabbitmq-plugins enable rabbitmq_management ; \

rabbitmqadmin declare exchange --vhost=/ name=personCreationFanoutExchange type=fanout ; \

rabbitmqadmin declare exchange --vhost=/ name=personCreationTopicExchange type=topic ; \

rabbitmqadmin declare exchange --vhost=/ name=personCreationDirectExchange type=direct ; \

rabbitmqadmin declare exchange --vhost=/ name=personCreationHeaderExchange type=headers; \

rabbitmqadmin declare exchange --vhost=/ name=personCreationTopicDLQExchange type=fanout ; \

rabbitmqadmin declare queue --vhost=/ name=personCreationDLQ durable=true ; \

rabbitmqadmin --vhost=/ declare binding source="personCreationTopicDLQExchange" destination_type="queue" destination="personCreationDLQ" routing_key="DLQ" ; \

rabbitmqadmin declare queue --vhost=/ name=personCreationQueue durable=true arguments={\"x-dead-letter-exchange\":\"personCreationTopicDLQExchange\",\"x-dead-letter-routing-key\":\"personCreationTopicDLQExchange\"} ; \

rabbitmqadmin declare queue --vhost=/ name=personCreationQueueAllHeaders durable=true ; \

rabbitmqadmin --vhost=/ declare binding source="personCreationTopicExchange" destination_type="queue" destination="personCreationQueue" routing_key="topic.*" ; \

rabbitmqadmin --vhost=/ declare binding source="personCreationDirectExchange" destination_type="queue" destination="personCreationQueue" routing_key="direct.key" ; \

rabbitmqadmin --vhost=/ declare binding source="personCreationFanoutExchange" destination_type="queue" destination="personCreationQueue" routing_key="fanout.key" ; \

rabbitmqadmin --vhost=/ declare binding source="personCreationHeaderExchange" destination_type="queue" destination="personCreationQueue" routing_key="" arguments={\"x-match\":\"any\",\"exchangeHeader1\":\"exchangeKey1\",\"exchangeHeader2\":\"exchangeKey2\"}; \
#rabbitmqadmin --vhost=/ declare binding source="personCreationHeaderExchange" destination_type="queue" destination="personCreationQueue" routing_key="" arguments={\"x-match\":\"any-with-x\",\"testHeader\":\"TEST\",\"testHeader2\":\"TEST2\"}; \

rabbitmqadmin --vhost=/ declare binding source="personCreationHeaderExchange" destination_type="queue" destination="personCreationQueueAllHeaders" routing_key="" arguments={\"x-match\":\"all\",\"exchangeHeader1\":\"exchangeKey1\",\"exchangeHeader2\":\"exchangeKey2\"} ; \
#rabbitmqadmin --vhost=/ declare binding source="personCreationHeaderExchange" destination_type="queue" destination="personCreationQueueAllHeaders" routing_key="" arguments={\"x-match\":\"all-with-x\",\"testHeader\":\"TEST\",\"testHeader2\":\"TEST2\"} ; \


)&
rabbitmq-server $@