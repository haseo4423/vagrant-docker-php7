#!/bin/sh -xe

_WORKDIR=/root/openssl/server
_DAYS=3650
_CA_ROOT=/root/openssl/ca
_APACHE_CERTS_DIR=/usr/local/apache2/certs

_SERVERNAME_2=sample-local7.dev.jp
_SUBJ_2="/C=JP/CN=*.dev.jp"
_PRIVATE_2=${_WORKDIR}/${_SERVERNAME_2}.pem

mkdir -p ${_WORKDIR}
cd ${_WORKDIR}

# sample-local7.dev.jp
if [ ! -e $_PRIVATE_2 ]; then
  openssl genrsa -out $_PRIVATE_2 2048
fi

cp /etc/ssl/openssl.cnf ${_WORKDIR}/${_SERVERNAME_2}.cnf
echo -e "\n[ SAN ]\nsubjectAltName = DNS:*.dev.jp\n" >> ${_WORKDIR}/${_SERVERNAME_2}.cnf
openssl req -new \
  -config ${_WORKDIR}/${_SERVERNAME_2}.cnf -reqexts SAN \
  -key $_PRIVATE_2 -out ${_SERVERNAME_2}.csr -sha256 -subj "${_SUBJ_2}"

echo -e "subjectAltName=DNS:*.dev.jp\n" >> ${_WORKDIR}/${_SERVERNAME_2}.x509.ext
openssl x509 -req -in ${_SERVERNAME_2}.csr \
  -days ${_DAYS} -extfile ${_WORKDIR}/${_SERVERNAME_2}.x509.ext \
  -CA ${_CA_ROOT}/sample-dev.cacrt.pem -CAkey ${_CA_ROOT}/sample-dev.canokey.pem -CAcreateserial -CAserial ${_CA_ROOT}/sample-dev.ca.seq \
  -out ${_WORKDIR}/${_SERVERNAME_2}.crt
cat ${_CA_ROOT}/sample-dev.cacrt.pem >> ${_WORKDIR}/${_SERVERNAME_2}.crt

if [ ! -e $_APACHE_CERTS_DIR ]; then
  mkdir -p ${_APACHE_CERTS_DIR}
fi
cp ${_WORKDIR}/${_SERVERNAME_2}.pem ${_APACHE_CERTS_DIR}/${_SERVERNAME_2}.pem
cp ${_WORKDIR}/${_SERVERNAME_2}.crt ${_APACHE_CERTS_DIR}/${_SERVERNAME_2}.crt
