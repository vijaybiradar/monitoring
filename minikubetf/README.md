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

add in a data source in grafana and use the prometheus endpoint: http://prometheus-release-server

you should have 2 jobs that scrape a node exporter endpoint running on 2 different ubuntu resources

terraform destroy
```
