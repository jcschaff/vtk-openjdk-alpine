# VTK and OpenJDK n Alpine Linux
FROM alpine:3.7

# Install some Alpine packages
RUN apk add --no-cache \
    bash \
    build-base \
    cmake \
    wget \
    mesa-dev \
    mesa-osmesa \
    python2-dev

# Download and extract VTK source, then configure and build VTK
RUN wget -nv -O- http://www.vtk.org/files/release/7.1/VTK-7.1.0.tar.gz | \
    tar xz && \
    cd VTK-7.1.0 && \
    cmake \
    -D CMAKE_BUILD_TYPE:STRING=Release \
    -D CMAKE_INSTALL_PREFIX:STRING=/usr \
    -D BUILD_DOCUMENTATION:BOOL=OFF \
    -D BUILD_EXAMPLES:BOOL=OFF \
    -D BUILD_TESTING:BOOL=OFF \
    -D BUILD_SHARED_LIBS:BOOL=ON \
    -D VTK_USE_X:BOOL=OFF \
    -D VTK_OPENGL_HAS_OSMESA:BOOL=ON \
    -D OSMESA_LIBRARY=/usr/lib/libOSMesa.so.8 \
    -D OSMESA_INCLUDE_DIR=/usr/include/GL/ \
    -D VTK_RENDERING_BACKEND:STRING=OpenGL \
    -D VTK_Group_MPI:BOOL=OFF \
    -D VTK_Group_StandAlone:BOOL=OFF \
    -D VTK_Group_Rendering:BOOL=ON \
    -D VTK_WRAP_PYTHON=ON \
    -D VTK_PYTHON_VERSION:STRING=2 \
    . && \
    make -j 2 && \
    make install && \
    cd .. && rm -rf VTK-7.1.0

# install thrift python package
RUN wget https://bootstrap.pypa.io/get-pip.py \
    && python get-pip.py \
    && pip install thrift

RUN apk update && apk upgrade && \
    apk add openjdk8 && \
    mkdir /tmp/tmprt && \
    cd /tmp/tmprt && \
    apk add zip && \
    unzip -q /usr/lib/jvm/default-jvm/jre/lib/rt.jar && \
    apk add zip && \
    zip -q -r /tmp/rt.zip . && \
    apk del zip && \
    cd /tmp && \
    mv rt.zip /usr/lib/jvm/default-jvm/jre/lib/rt.jar && \
    rm -rf /tmp/tmprt /var/cache/apk/* bin/jjs bin/keytool bin/orbd bin/pack200 bin/policytool \
          bin/rmid bin/rmiregistry bin/servertool bin/tnameserv bin/unpack200 

