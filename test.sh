#!/bin/bash

# Create Public Private Key Pair for Epic FHIR OAuth 2.0
# https://fhir.epic.com/Documentation?docId=oauth2&section=Creating-Key-Pair_OpenSSL
TIMESTAMP=$(date +%Y%m%d%H%M%S)

folder=${1:-rsa_key_${TIMESTAMP}}
subj=${2:-signal1-drgongate}

mkdir -p "$folder"

(
  cd "$folder" || exit

  # Generate the RSA key file in pkcs1
  openssl genrsa -out private_rsa.pem 2048

  # Export private key file in pkcs8. It is used by gate-in
  openssl pkcs8 -topk8 -inform PEM -outform PEM -nocrypt -in private_rsa.pem -out private.pem

  # Export public key to a base64 encoded X.509 certificate which is needed for EPIC Client/Key registration.
  openssl req -new -x509 -key private_rsa.pem -out public509.pem -subj "/CN=$subj"
)
