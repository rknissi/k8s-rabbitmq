FROM rabbitmq:3.10-management

ADD init.sh /init.sh

EXPOSE 5672
RUN ["chmod", "+x", "/init.sh"]
ENTRYPOINT ["/init.sh"]

