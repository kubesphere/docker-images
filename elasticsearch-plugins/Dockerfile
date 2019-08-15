FROM busybox:1.28.4 as builder

RUN mkdir /html && touch /html/index.html
ADD https://artifacts.elastic.co/downloads/elasticsearch-plugins/analysis-icu/analysis-icu-6.7.0.zip /html
ADD https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v6.7.0/elasticsearch-analysis-ik-6.7.0.zip /html/analysis-ik-6.7.0.zip
RUN chmod +r /html/*.zip

FROM busybox:1.28.4
COPY --from=builder /html /html
