FROM ghcr.io/graalvm/graalvm-ce:ol8-java17-22.1.0
WORKDIR /installdir
RUN gu install native-image
ARG RESULT_LIB="/staticlibs"
RUN mkdir ${RESULT_LIB} && \
    curl -L -s -o musl.tar.gz https://musl.libc.org/releases/musl-latest.tar.gz && \
    mkdir musl && tar -xzf musl.tar.gz -C musl --strip-components 1 && cd musl && \
    ./configure --disable-shared --prefix=${RESULT_LIB} &>/dev/null && \
    make -s && make install -s && \
    cp /usr/lib/gcc/x86_64-redhat-linux/8/libstdc++.a ${RESULT_LIB}/lib/ && \
    cp ${RESULT_LIB}/bin/musl-gcc ${RESULT_LIB}/bin/x86_64-linux-musl-gcc
ENV PATH="$PATH:${RESULT_LIB}/bin"
RUN curl -L -s -o zlib.tar.gz https://zlib.net/zlib-1.2.12.tar.gz && \
   mkdir zlib && tar -xzf zlib.tar.gz -C zlib --strip-components 1 && cd zlib && \
   ./configure --static --prefix=${RESULT_LIB} &>/dev/null && \
    make -s && make install -s