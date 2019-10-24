#
# docker-machine start default
# eval $(docker-machine env default)
# docker build -t liquid/feedback .
# docker run --sig-proxy=false -p 8080 liquid/feedback
# ^C to stop

FROM debian:stretch

MAINTAINER dvn & lynX

ENV HOME /

ENV LF_CORE_VERSION 3.2.2
ENV LF_FEND_VERSION 3.2.1
ENV LF_WMCP_VERSION 2.1.0

# Regenerate SSH host keys. baseimage-docker does not contain any
#RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# create code directory
RUN mkdir -p /opt/code/
# install packages required to compile vala and radare2
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y build-essential wget apt-utils
RUN apt-get install -y lua5.2 liblua5.2-dev
RUN apt-get install -y postgresql libpq-dev
RUN apt-get install -y pmake
RUN apt-get install -y imagemagick
RUN apt-get install -y exim4
RUN apt-get install -y python-pip
RUN pip install markdown2

# RUN uname -a
EXPOSE 8080

# Initialize postgresql
USER postgres
RUN /etc/init.d/postgresql start && \
	createdb liquid_feedback && \
	createlang plpgsql liquid_feedback ; \
	createuser --no-superuser --createdb --no-createrole www-data

USER root
RUN cd /
RUN wget -c http://www.public-software-group.org/pub/projects/liquid_feedback/backend/v${LF_CORE_VERSION}/liquid_feedback_core-v${LF_CORE_VERSION}.tar.gz
RUN tar xzvf liquid_feedback_core-v${LF_CORE_VERSION}.tar.gz
RUN cd liquid_feedback_core-v${LF_CORE_VERSION} && make

RUN mkdir -p /opt/liquid_feedback_core
RUN cd /liquid_feedback_core-v${LF_CORE_VERSION} && \
	cp -f core.sql lf_update lf_update_issue_order lf_update_suggestion_order \
		/opt/liquid_feedback_core

COPY config_db.sql /tmp
# USER www-data
RUN /etc/init.d/postgresql start && sleep 70 && \
	su - www-data -s /bin/sh -c '/usr/bin/psql -v ON_ERROR_STOP=1 -f /opt/liquid_feedback_core/core.sql liquid_feedback' && \
	su - www-data -s /bin/sh -c '/usr/bin/psql -f /tmp/config_db.sql liquid_feedback'

# Create Admin user
# INSERT INTO member (login, name, admin, password) VALUES ('admin', 'Administrator', TRUE, '$1$/EMPTY/$NEWt7XJg2efKwPm4vectc1');
# \q
# exit

# Install MoonBridge
RUN cd /root
RUN wget -c http://www.public-software-group.org/pub/projects/moonbridge/v1.0.1/moonbridge-v1.0.1.tar.gz
RUN tar xzvf moonbridge-v1.0.1.tar.gz
RUN apt-get install -y libbsd-dev
RUN mkdir -p /opt/moonbridge
RUN cd moonbridge-v1.0.1 ; \
	pmake MOONBR_LUA_PATH=/opt/moonbridge/?.lua && \
	cp -f moonbridge /opt/moonbridge/ && \
	cp -f moonbridge_http.lua /opt/moonbridge/

# Install WebMCP
RUN apt-get install -y libpq-dev postgresql-server-dev-9.6
RUN cp -rf /usr/include/lua5.2/* /usr/include
RUN cp -rf /usr/include/postgresql/* /usr/include
RUN cp -rf /usr/include/postgresql/9.6/server/* /usr/include
RUN cd /root
RUN wget -c http://www.public-software-group.org/pub/projects/webmcp/v${LF_WMCP_VERSION}/webmcp-v${LF_WMCP_VERSION}.tar.gz
RUN tar xzvf webmcp-v${LF_WMCP_VERSION}.tar.gz
RUN mkdir -p /opt/webmcp
RUN cd webmcp-v${LF_WMCP_VERSION} && make && \
	cp -RL framework/* /opt/webmcp/

# Install LiquidFeedback frontend
WORKDIR "/"
RUN wget -c http://www.public-software-group.org/pub/projects/liquid_feedback/frontend/v${LF_FEND_VERSION}/liquid_feedback_frontend-v${LF_FEND_VERSION}.tar.gz
RUN tar xzvf liquid_feedback_frontend-v${LF_FEND_VERSION}.tar.gz
RUN rm -rf /opt/liquid_feedback_frontend ; \
	mv /liquid_feedback_frontend-v${LF_FEND_VERSION} /opt/liquid_feedback_frontend && \
	mkdir -p /opt/liquid_feedback_frontend/tmp && \
	chown -R www-data /opt/liquid_feedback_frontend
COPY myconfig.lua /opt/liquid_feedback_frontend/config/myconfig.lua
#RUN cd /opt/liquid_feedback_frontend/config && cp -f example.lua myconfig.lua

# Configure email system
#RUN dpkg-reconfigure exim4-config
# TODO: copy exim4 config

# Configure frontend
# NOTE: edit example.lua for your needs

RUN mkdir -p /opt/liquid_feedback_core/
COPY lf_updated /opt/liquid_feedback_core/lf_updated
RUN chmod +x /opt/liquid_feedback_core/lf_updated

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# TODO: remove all packages required to build this to reduce image size
# RUN apt-get remove ...
RUN rm -rf /usr/include /usr/share/man /usr/share/doc

COPY profile /root/.profile

VOLUME /var/log

# executed on run
CMD /etc/init.d/postgresql start && \
	/opt/liquid_feedback_core/lf_updated && \
	echo "Starting LiquidFeedback..." && \
	su - www-data -s /bin/sh -c "/opt/moonbridge/moonbridge /opt/webmcp/bin/mcp.lua /opt/webmcp/ /opt/liquid_feedback_frontend/ main myconfig"
