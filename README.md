This speeds up the creation of a fresh MarkLogic docker instance by including
all necessary dependencies. You will have to separately download a [MarkLogic Early Access
rpm for CentOS 7](https://ea.marklogic.com/download) and move the rpm to
the same folder as your Dockerfile.

To use, you will create a local image with MarkLogic installed - an image that
can then be used over and over to create fresh MarkLogic containers. (Note that
an image with MarkLogic pre-installed cannot be shared. It has the same
licensing restrictions that a MarkLogic rpm has.)

To create this local image with MarkLogic installed, first create a Dockerfile like this (probably in a new directory):

```
FROM patrickmcelwee/marklogic-dependencies:9.0-EA3

# If you want vim for local debugging
# RUN yum -y install vim

# Install MarkLogic
WORKDIR /tmp
ADD MarkLogic-RHEL7-9.0-20160909.x86_64-EA3.rpm /tmp/MarkLogic.rpm

RUN yum -y install /tmp/MarkLogic.rpm

# Expose MarkLogic Server ports - plus 8040, 8041, 8042 for your REST, etc
# endpoints - feel free to add more
EXPOSE 7997 7998 7999 8000 8001 8002 8040 8041 8042

# Define default command (which avoids immediate shutdown)
CMD /opt/MarkLogic/bin/MarkLogic && tail -f /dev/null
```

Then add your [MarkLogic rpm](https://developer.marklogic.com/products) to the
same directory. This command will build an image with MarkLogic installed, but
not initiated:

    docker build -t marklogic-initial-install:9.0-EA3 .

That will download this image automatically and build a new image called
`marklogic-installed:8.0-5`. You can then create and run a new container
based on this image with the following command:

    docker run -d --name=initial_install -p 8001:8001 marklogic-initial-install:9.0-EA3

Now navigate to http://localhost:8001. This will cause MarkLogic to complete
installation and allow you to set up cluster settings and an admin user. I like
to create an image immediately after taking these steps, so that I can create
fresh images without any manual setup:

    docker commit initial_install ml-installed:9.0-EA3

That creates a local image named `ml-installed:9.0-EA3` that is ready to go
with the cluster and admin user you set up! (Note that `docker commit` can be
used to save the state of the container, even once you start adding data. This
can be handy to create a base state to which you can easily rollback. I am not
sure if that is possible when using external volumes, which I do not cover
here. Feedback welcome on this point!)

Now you can cleanup that intermediate `initial_install` container:

    docker stop initial_install
    docker rm -v initial_install

Now you can quickly create new containers based on your installed-MarkLogic
image, and you will have completely isolated MarkLogic servers.

    docker run -d --name=name_for_this_container -p 7997:7997 -p 7998:7998 -p 7999:7999 -p 8000:8000 -p 8001:8001 -p 8002:8002 -p 8040:8040 -p 8041:8041 -p 8042:8042 ml-installed:9.0-EA3

When you are finished with this container, you can remove it, but remember the
`-v` option, if you have set up a separate volume. Otherwise, the volume
will not be removed:

    docker rm -v name_for_this_container

Happy Docking!
