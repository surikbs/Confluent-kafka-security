
# Generate  Zookeeper certificates

openssl req -new -newkey rsa:2048 -keyout certs/zookeeper.key -out certs/zookeeper.csr -config certs/zookeeper.cnf -nodes
openssl x509 -req -days 3650 -in certs/zookeeper.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -out certs/zookeeper.crt -extfile zookeeper.cnf -extensions v3_req
openssl pkcs12 -export -in certs/zookeeper.crt -inkey certs/zookeeper.key -chain -CAfile certs/ca.pem -name "Zookeeper.Confluent" -out certs/zookeeper.p12 -password pass:test1234

# Import server certificate to keystore 

keytool -importkeystore -deststorepass test1234 -destkeystore certs/zookeeper.keystore.jks \
    -srckeystore certs/zookeeper.p12 \
    -deststoretype PKCS12  \
    -srcstoretype PKCS12 \
    -noprompt \
    -srcstorepass test1234