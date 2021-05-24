# Creating TLS CA, Certificates and keystore / truststore
rm -rf certs 
mkdir -p certs

# Generate CA certificates
openssl req -new -nodes -x509 -days 3650 -newkey rsa:2048 -keyout certs/ca.key -out certs/ca.crt -config ca.cnf 
cat certs/ca.crt certs/ca.key > certs/ca.pem

# Generate kafka broker certificates
openssl req -new -newkey rsa:2048 -keyout certs/broker-server.key -out certs/broker-server.csr -config broker-server.cnf -nodes
openssl x509 -req -days 3650 -in certs/broker-server.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -out certs/broker-server.crt -extfile broker-server.cnf -extensions v3_req
openssl pkcs12 -export -in certs/broker-server.crt -inkey certs/broker-server.key -chain -CAfile certs/ca.pem -name "kafka.confluent.local" -out certs/broker-server.p12 -password pass:test1234

# Import server certificate to keystore and CA to truststore
keytool -importkeystore -deststorepass test1234 -destkeystore certs/broker-server.keystore.jks \
    -srckeystore certs/broker-server.p12 \
    -deststoretype PKCS12  \
    -srcstoretype PKCS12 \
    -noprompt \
    -srcstorepass test1234

sh zookeeper_cert_ssl.sh 

keytool -keystore certs/truststore.jks -alias CARoot -import -file certs/ca.crt -storepass test1234  -noprompt -storetype PKCS12 