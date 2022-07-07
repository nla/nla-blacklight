FROM solr:8
LABEL maintainer="National Library of Australia"
COPY conf /myconfig
CMD ["solr-precreate", "blacklight-core", "/myconfig"]
