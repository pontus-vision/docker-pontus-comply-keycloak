FROM jboss/keycloak

WORKDIR ${JBOSS_HOME}
COPY keycloak.export.json  /tmp
COPY  build-local.sh .

ENV DB_VENDOR=h2

#RUN chmod 755 ./build-local.sh && \
RUN ./build-local.sh
