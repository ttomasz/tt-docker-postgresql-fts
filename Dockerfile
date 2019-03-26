FROM postgres:11

MAINTAINER Tomasz Taraś <tomasztaras@outlook.com>

# install postgis 2.5
# copied from:
# https://github.com/appropriate/docker-postgis/tree/master/11-2.5
ENV POSTGIS_MAJOR 2.5
ENV POSTGIS_VERSION 2.5.2+dfsg-1~exp1.pgdg90+1

RUN apt-get update \
      && apt-cache showpkg postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR \
      && apt-get install -y --no-install-recommends \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR=$POSTGIS_VERSION \
           postgresql-$PG_MAJOR-postgis-$POSTGIS_MAJOR-scripts=$POSTGIS_VERSION \
           postgis=$POSTGIS_VERSION wget libpq-dev  \
      && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d

# install polish dictionary for Full Text Search
# guide from:
# https://github.com/dominem/postgresql_fts_polish_dict

COPY sjp-ispell-pl-20190226 /usr/local/sjp-ispell-pl-20190226/
COPY polish.stopwords.txt /usr/local/sjp-ispell-pl-20190226/
WORKDIR /usr/local/sjp-ispell-pl-20190226

RUN iconv -f ISO_8859-2 -t utf-8 polish.aff > polish.affix
RUN iconv -f ISO_8859-2 -t utf-8 polish.all > polish.dict
RUN mv polish.stopwords.txt polish.stop

RUN cp polish.affix `pg_config --sharedir`/tsearch_data/
RUN cp polish.dict `pg_config --sharedir`/tsearch_data/
RUN cp polish.stop `pg_config --sharedir`/tsearch_data/


RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./initdb.sh /docker-entrypoint-initdb.d/initdb.sh
RUN chmod +x /docker-entrypoint-initdb.d/initdb.sh
