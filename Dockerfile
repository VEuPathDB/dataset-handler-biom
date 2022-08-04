FROM veupathdb/galaxy-python-tools:latest

# # # # # # # # # # # # # # # #
#                             #
#  General Container Config   #
#                             #
# # # # # # # # # # # # # # # #

ARG utilserverversion="0.7.0"

WORKDIR /app

RUN export server_url=https://github.com/VEuPathDB/util-user-dataset-handler-server/releases/download/v${utilserverversion}/server-v${utilserverversion}.tar.gz \
    && echo using server version ${server_url} \
    && wget ${server_url} -O tmp.tgz \
    && tar -xzf tmp.tgz \
    && chmod +x ./server \
    && rm tmp.tgz

# # # # # # # # # # # # # # # #
#                             #
#  Handler Specific Config    #
#                             #
# # # # # # # # # # # # # # # #

COPY lib /opt/handler/lib
COPY bin /opt/handler/bin
COPY config.yml config.yml
RUN pip install git+https://github.com/VEuPathDB/dataset-handler-python-base \
    && chmod +x /opt/handler/bin/exportBiomToEuPathDB

EXPOSE 80
CMD ./server
