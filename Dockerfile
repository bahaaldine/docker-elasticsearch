FROM java:8
MAINTAINER Bahaaldine Azarmi <baha@elastic.co>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -y supervisor curl

# Elasticsearch
RUN \
    apt-key adv --keyserver pool.sks-keyservers.net --recv-keys 46095ACC8548582C1A2699A9D27D666CD88E42B4 && \
    if ! grep "elasticsearch" /etc/apt/sources.list; then echo "deb http://packages.elasticsearch.org/elasticsearch/1.6/debian stable main" >> /etc/apt/sources.list;fi && \
    apt-get update

RUN \
    apt-get install -y elasticsearch && \
    apt-get clean && \
    sed -i '/#cluster.name:.*/a cluster.name: logging' /etc/elasticsearch/elasticsearch.yml && \
    sed -i '/#path.data: \/path\/to\/data/a path.data: /data' /etc/elasticsearch/elasticsearch.yml && \
    sed -i '/#index.number_of_shards:.*/a index.number_of_shards: 1' /etc/elasticsearch/elasticsearch.yml && \
    sed -i '/#index.number_of_replicas:.*/a index.number_of_replicas: 0' /etc/elasticsearch/elasticsearch.yml && \
    sed -i '/#marvel.index.number_of_replicas:.*/a index.number_of_replicas: 0' /etc/elasticsearch/elasticsearch.yml && \
    sed -i '/#network.publish_host:.*/a network.publish_host: elasticsearch' /etc/elasticsearch/elasticsearch.yml

ADD etc/supervisor/conf.d/elasticsearch.conf /etc/supervisor/conf.d/elasticsearch.conf

# Marvel
RUN /usr/share/elasticsearch/bin/plugin -i elasticsearch/marvel/latest
# Shield 
RUN /usr/share/elasticsearch/bin/plugin -i elasticsearch/license/latest
# Watcher
RUN /usr/share/elasticsearch/bin/plugin -i elasticsearch/watcher/latest -Des.path.conf=/etc/elasticsearch

EXPOSE 9200
EXPOSE 9300

CMD [ "/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf" ]

