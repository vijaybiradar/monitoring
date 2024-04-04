```
brew install minikube
brew install terraform
brew install kubectl

terraform init
terraform plan
terraform apply

kubectl get secret grafana-release  -n wickstack -o jsonpath='{.data.admin-password}' | base64 --decode
kubectl port-forward service/grafana-release 3333:80 -n wickstack 

login with the password from get secret

terraform destroy
```
