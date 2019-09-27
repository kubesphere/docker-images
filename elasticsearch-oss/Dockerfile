ARG ES_VERSION
FROM docker.elastic.co/elasticsearch/elasticsearch-oss:$ES_VERSION

USER elasticsearch
ARG ES_VERSION
RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install -b analysis-icu && \
    /usr/share/elasticsearch/bin/elasticsearch-plugin install -b \
    https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v$ES_VERSION/elasticsearch-analysis-ik-$ES_VERSION.zip
