This dramatically speeds up the creation of a fresh MarkLogic docker instance
by including all necessary dependencies. You will have to separately download
a [MarkLogic rpm for CentOS 6](https://developer.marklogic.com/products) and
move the rpm to the same folder as your Dockerfile.

To use, you will create a local image with MarkLogic installed - an image that
can then be used over and over to create fresh MarkLogic containers. (Note that
an image with MarkLogic pre-installed cannot be shared. It has the same
licensing restrictions that a MarkLogic rpm has.)

To create this local image with MarkLogic installed, first create a Dockerfile like this (probably in a new directory):

```
FROM patrickmcelwee/marklogic-dependencies:8-latest
MAINTAINER Patrick McElwee <patrick.mcelwee@marklogic.com>

RUN yum -y install vim

# Install MarkLogic
WORKDIR /tmp
ADD MarkLogic-8.0-3.2.x86_64.rpm /tmp/MarkLogic.rpm

RUN yum -y install /tmp/MarkLogic.rpm

# Expose MarkLogic Server ports - add additional ones for your REST, etc
# endpoints
EXPOSE 7997 7999 8000 8001 8002 8040 8041 8042 9040 9070

# Define default command (which avoids immediate shutdown)
CMD /opt/MarkLogic/bin/MarkLogic && tail -f /data/Logs/ErrorLog.txt
```

Then add your [MarkLogic rpm](https://developer.marklogic.com/products) to the
same directory. This command will build a container, and run it in the
background (customize it to specify the ports you need):

    docker build -t marklogic-installed:8.0-3.2 .

That will download this image automatically and build a new image called
`marklogic-installed:8.0-3.2`. You can then create and run a new container
based on this image with the following command (modifying it to give the
container a name and to change the port mappings to those you need - you can
add ports not specified in the Dockerfile EXPOSE statement):

    docker run -d --name=name_for_this_container -p 7997:7997 -p 7999:7999 -p 8000:8000 -p 8001:8001 -p 8002:8002 -p 8040:8040 -p 8041:8041 -p 8042:8042 -p 9040:9040 -p 9070:9070 ml-installed:8.0-3.2

When you are finished with this container, you can remove it, but remember the
`-v` option, unless you have set up a separate volume. Otherwise, the volume
will not be removed:

    docker rm -v name_for_this_container

Happy Docking!
