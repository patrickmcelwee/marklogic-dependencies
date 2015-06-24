This dramatically speeds up the creation of a fresh MarkLogic docker instance
by including all necessary dependencies. You will have to separately download
a [MarkLogic rpm for CentOS 6](https://developer.marklogic.com/products) and
move the rpm to the same folder as your Dockerfile.

To use, try a Dockerfile like this:

```
FROM patrickmcelwee/marklogic-dependencies:8-latest
MAINTAINER Patrick McElwee <patrick.mcelwee@marklogic.com>

RUN yum -y install vim

# Install MarkLogic
WORKDIR /tmp
ADD MarkLogic-8.0-3.x86_64.rpm /tmp/MarkLogic.rpm

RUN yum -y install /tmp/MarkLogic.rpm

# Expose MarkLogic Server ports - add additional ones for your REST, etc
# endpoints
EXPOSE 7997 7999 8000 8001 8002

# Define default command (which avoids immediate shutdown)
CMD /opt/MarkLogic/bin/MarkLogic && tail -f /data/Logs/ErrorLog.txt
```
