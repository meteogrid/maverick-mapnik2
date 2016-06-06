FROM avalverde/maverick:i386

ENV MAPNIK_REV 5c76218070ce25d0f743330ec61c1472fe954bb4
ENV BUILD_DEPS \
    build-essential \
    scons \
    python-all-dev \
    libboost-thread-dev \
    libboost-filesystem-dev \
    libboost-regex-dev \
    libboost-python-dev \
    libboost-system-dev \
    libboost-iostreams-dev \
    libboost-program-options-dev \
    libpng12-dev \
    libjpeg62-dev \
    libtiff4-dev \
    zlib1g-dev \
    libfreetype6-dev \
    libpq-dev \
    libproj-dev \
    libltdl-dev \
    libfribidi-dev \
    libgdal1-dev \
    libxml2-dev \
    libicu-dev \
    libcairo2-dev \
    libcairomm-1.0-dev \
    python-cairo-dev \
    libsqlite3-dev \
    libcurl4-gnutls-dev \
    libsigc++-2.0-dev \
    python-epydoc \
    git

ENV RUNTIME_DEPS \
    libboost-thread \
    libboost-filesystem \
    libboost-regex \
    libboost-python \
    libboost-system \
    libboost-iostreams \
    libboost-program-options \
    libpng12 \
    libjpeg62 \
    libtiff4 \
    zlib1g \
    libfreetype6 \
    libpq \
    libproj \
    libltdl \
    libfribidi \
    libgdal1 \
    libxml2 \
    libicu \
    libcairo2 \
    libcairomm-1.0 \
    python-cairo \
    libsqlite3 \
    libcurl4-gnutls \
    libsigc++-2.0

RUN : "Install base build packages" \
   && apt-get update && apt-get install -y ${BUILD_DEPS}

WORKDIR /tmp
RUN : "Build and install Mapnik" \
   && git clone git://github.com/mapnik/mapnik.git \
   && cd mapnik \
   && git checkout $MAPNIK_REV \
   && scons \
       INPUT_PLUGINS=postgis,shape,gdal,ogr \
       INTERNAL_LIBAGG=True  \
       SYSTEM_FONTS=/usr/share/fonts/truetype/ttf-dejavu \
       XMLPARSER=libxml2 \
       PREFIX=/usr \
       LIB_DIR_NAME=/mapnik/0.8 \
       BINDINGS=python \
       DEBUG=False \
       CAIRO=True \
       SHAPE_MEMORY_MAPPED_FILE=False \
       JOBS=$(grep -c processors /proc/cpuinfo) \
       FAST=True \
      configure \
   && scons install JOBS=$(grep -c processors /proc/cpuinfo) \
   && rm -rf /tmp/*

#WORKDIR /
#RUN : "Cleanup" && apt-get remove -y ${BUILD_DEPS}
  #&& apt-get autoremove -y \
  #&& apt-get install -y $RUNTIME_DEPS \
  #&& apt-get clean && rm /var/lib/apt/lists
