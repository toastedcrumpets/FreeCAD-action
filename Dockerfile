FROM ubuntu:24.04

ENV DEBIAN_FRONTEND noninteractive
ENV FREECAD_REPO https://github.com/FreeCAD/FreeCAD
ENV FREECAD_TAG 1.0.0

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    cmake \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install additional dependencies
RUN cd && cd FreeCAD \
    && apt-get update \
    && apt-get install -y libyaml-cpp-dev \
    && rm -rf /var/lib/apt/lists/*

# Install dependencies following the FreeCAD recommendations and cleanup apt cache
RUN cd \
    && apt-get update \
    && curl "https://raw.githubusercontent.com/FreeCAD/FreeCAD/$FREECAD_TAG/tools/build/Docker/ubuntu.sh" | bash \
    && rm -rf /var/lib/apt/lists/*

# get FreeCAD Git code base (done now, to prevent a large layer when installing dependencies)
RUN cd \
    && git clone --recurse-submodules --branch "$FREECAD_TAG" "$FREECAD_REPO" FreeCAD

# Run the standard build process
RUN cd \
    && mkdir freecad-build \
    && cd freecad-build \
    && cmake \
    ../FreeCAD \
    && make -j$(nproc --ignore=2) \
    && make install \
    && cd \
    && rm FreeCAD/ freecad-build/ -fR
