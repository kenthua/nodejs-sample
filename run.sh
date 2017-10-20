cat > nodejs.yaml << EOF
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  name: nodejs
spec:
  replicas: 3
  template:
    metadata:
      labels:
        app: nodejs
    spec:
      containers:
      - name: nodejs
        image: gcr.io/kents-core/nodejs-sample:v1
        ports:
        - containerPort: 8080
EOF

kubectl apply -f nodejs.yaml

kubectl expose deployment nodejs --target-port=8080 --port=80 --type=NodePort

cat > nodejs-ingress.yaml << EOF
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: nodejs-ingress
spec:
  backend:
    serviceName: nodejs
    servicePort: 80
EOF

kubectl apply -f nodejs-ingress.yaml

