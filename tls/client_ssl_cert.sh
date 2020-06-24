# Generate client certificates
openssl req -new -newkey rsa:2048 -keyout certs/client.key -out certs/client.csr -config client.cnf -nodes
openssl x509 -req -days 3650 -in certs/client.csr -CA certs/ca.crt -CAkey certs/ca.key -CAcreateserial -out certs/client.crt -extfile client.cnf -extensions v3_req
openssl pkcs12 -export -in certs/client.crt -inkey certs/client.key -chain -CAfile certs/ca.pem -name "kafka.confluent.local" -out certs/client.p12 -password pass:test1234


# Import server certificate to keystore
keytool -importkeystore -deststorepass test1234 -destkeystore certs/client.keystore.jks \
    -srckeystore certs/client.p12 \
    -deststoretype PKCS12 \
    -srcstoretype PKCS12 \
    -noprompt \
    -srcstorepass test1234