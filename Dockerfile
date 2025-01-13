FROM ubuntu:22.04
# We need ubuntu:22.04 because FreeCAD 0.21 can only compile against python 3.12
# https://github.com/FreeCAD/FreeCAD/pull/12286

ENV DEBIAN_FRONTEND=noninteractive
ENV FREECAD_REPO=https://github.com/FreeCAD/FreeCAD
# TAG is a github tag like 1.0.0
ARG FREECAD_TAG 
ENV FREECAD_TAG=${FREECAD_TAG}

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install additional dependencies
RUN apt-get update \
    && apt-get install -y libyaml-cpp-dev \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies following the FreeCAD recommendations and cleanup apt cache
RUN cd \
    && apt-get update \
    && curl "https://raw.githubusercontent.com/FreeCAD/FreeCAD/$FREECAD_TAG/tools/build/Docker/ubuntu.sh" | bash \
    && rm -rf /var/lib/apt/lists/*

# Run the standard build process, all in one, so the sources don't create a large layer.
RUN cd \
    && git clone --recurse-submodules --branch "$FREECAD_TAG" "$FREECAD_REPO" FreeCAD \
    && mkdir freecad-build \
    && cd freecad-build \
    && cmake ../FreeCAD \
    && make -j$(nproc --ignore=2) \
    && make install \
    && cd \
    && rm FreeCAD/ freecad-build/ -fR
