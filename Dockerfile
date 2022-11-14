FROM rabbitmq:3.10-management

#Copies a file from the host filesystem to the image internal filesystem
ADD init.sh /init.sh

#tells that the container listen to a certain port
EXPOSE 5672

#Run a shell command
RUN ["chmod", "+x", "/init.sh"]

#Configure the container that will run as a executable
ENTRYPOINT ["/init.sh"]

