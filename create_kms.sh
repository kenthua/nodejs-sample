#create keyring
gcloud kms keyrings create cbtest --location=global
#create key
gcloud kms keys create cbtestkey --location=global --keyring=cbtest --purpose=encryption
#give cloudbuild access to crypto, this serviceaccount is added when cloudbuild is enabled and/or api is enabled
gcloud kms keys add-iam-policy-binding \
    cbtestkey --location=global --keyring=cbtest \
    --member=serviceAccount:865592827998@cloudbuild.gserviceaccount.com \
    --role=roles/cloudkms.cryptoKeyEncrypterDecrypter

cat > secrets.json << EOF
{
    "host" : "myhost",
    "username" : "myusername",
    "password" : "mypassword"
}
EOF

#encrypt the file to secrets.json.enc
gcloud kms encrypt \
  --plaintext-file=secrets.json \
  --ciphertext-file=secrets.json.enc \
  --location=global \
  --keyring=cbtest \
  --key=cbtestkey


#encrypt a value as an environment variable
export MY_SECRET=1234abcd
echo -n $MY_SECRET | gcloud kms encrypt \
  --plaintext-file=- \
  --ciphertext-file=- \
  --location=global \
  --keyring=cbtest \
  --key=cbtestkey | base64
#output = CiQAWtb63hyKLmbM/GYG1qqKWF9qxVJ1JVdGQeiDWPYjPEL9MqESMQCKj/AANz9Fb/+2J9Lbf+bfYAQGSzgymZwsY3knVBkH5VQXju4d1+bLEhTNS8HML+8=

