FROM openjdk:11-jdk-slim

ENV VERSION 9.1
ENV GHIDRA_SHA 29d130dfe85da6ec45dfbf68a344506a8fdcc7cfe7f64a3e7ffb210052d1875e

RUN apt-get update && apt-get install -y fontconfig libxrender1 libxtst6 libxi6 wget unzip --no-install-recommends \
    && wget --progress=bar:force -O /tmp/ghidra.zip https://www.ghidra-sre.org/ghidra_9.0.4_PUBLIC_20190516.zip \
    && echo "$GHIDRA_SHA /tmp/ghidra.zip" | sha256sum -c - \
    && unzip /tmp/ghidra.zip \
    && mv ghidra_${VERSION} /ghidra \
    && chmod +x /ghidra/ghidraRun \
    && echo "===> Clean up unnecessary files..." \
    && apt-get purge -y --auto-remove wget unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives /tmp/* /var/tmp/* /ghidra/docs /ghidra/Extensions/Eclipse /ghidra/licenses

WORKDIR /ghidra

COPY entrypoint.sh /entrypoint.sh
COPY server.conf /ghidra/server/server.conf

EXPOSE 13100 13101 13102
RUN mkdir /repos
ENTRYPOINT ["/entrypoint.sh"]
CMD [ "client" ]