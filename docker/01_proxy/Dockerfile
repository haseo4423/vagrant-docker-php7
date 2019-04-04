FROM httpd:2.4

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    openssl \
    ca-certificates

RUN usermod -u 1000 www-data && \
    groupmod -g 1000 www-data

# CA 追加
COPY ./openssl/ca/sample-dev.cacrt.pem /root/openssl/ca/sample-dev.cacrt.pem
COPY ./openssl/ca/sample-dev.canokey.pem /root/openssl/ca/sample-dev.canokey.pem

RUN cp /root/openssl/ca/sample-dev.cacrt.pem /usr/share/ca-certificates/sample-dev.cacrt.pem
RUN echo "sample-dev.cacrt.pem" >> /etc/ca-certificates.conf
RUN /usr/sbin/update-ca-certificates

# SSL証明書 作成
COPY ./cmd/create_ssl.sh /root/cmd/create_ssl.sh
RUN chmod 744 /root/cmd/create_ssl.sh
RUN /bin/bash -c "source /root/cmd/create_ssl.sh"

COPY ./apache2/extra_mod/mod_setenvifplus.so /usr/local/apache2/modules/mod_setenvifplus.so
RUN chmod 755 /usr/local/apache2/modules/mod_setenvifplus.so
