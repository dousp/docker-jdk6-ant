FROM douspeng/docker-ali-centos

LABEL maintainer="douspeng@sina.cn" provider="douspeng"

ENV JAVA_HOME="/usr/local/java/jdk1.6.0_45" \
    JDK_NAME="jdk-6u45-linux-x64.bin" \
	JDK_PARENT_HOME="/usr/local/java/" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8"

#刷新包缓存 并且 安装wget工具
RUN \cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && yum update -y \
 && yum provides '*/applydeltarpm' \
 && yum install -y zip unzip tar curl wget deltarpm \
 && mkdir -p ${JDK_PARENT_HOME}

WORKDIR ${JDK_PARENT_HOME}
COPY resource ${JDK_PARENT_HOME}

RUN chmod a+x ${JDK_PARENT_HOME}${JDK_NAME} \
 && ./${JDK_NAME} \
 && rm -f ${JDK_NAME}

# 配置环境变量
ENV JAVA_HOME ${JAVA_HOME}
ENV JRE_HOME $JAVA_HOME/jre
ENV CLASSPATH .:$JAVA_HOME/lib:$JRE_HOME/lib
ENV PATH $PATH:$JAVA_HOME/bin

# ant 安装
ENV ANT_VERSION=1.9.9
ENV ANT_HOME=/opt/ant

# change to tmp folder
WORKDIR /tmp

# Download and extract apache ant to opt folder
RUN wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz \
    && wget --no-check-certificate --no-cookies http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz.md5 \
    && echo "$(cat apache-ant-${ANT_VERSION}-bin.tar.gz.md5) apache-ant-${ANT_VERSION}-bin.tar.gz" | md5sum -c \
    && tar -zvxf apache-ant-${ANT_VERSION}-bin.tar.gz -C /opt/ \
    && ln -s /opt/apache-ant-${ANT_VERSION} /opt/ant \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz \
    && rm -f apache-ant-${ANT_VERSION}-bin.tar.gz.md5

# add executables to path
RUN update-alternatives --install "/usr/bin/ant" "ant" "/opt/ant/bin/ant" 1 && \
    update-alternatives --set "ant" "/opt/ant/bin/ant"

# Add the files
# ADD rootfs /

# change to root folder
WORKDIR /root

RUN yum clean all
