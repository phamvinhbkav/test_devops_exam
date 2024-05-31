arn=$(aws sts get-caller-identity | jq -r .Arn)
account_id=$(aws sts get-caller-identity | jq -r .Account)
echo $arn
echo "Update kubeconfig file for $1 cluster"
aws eks update-kubeconfig --name $cluster_name --region $region
kubectl config use-context arn:aws:eks:$region:$account_id:cluster/$cluster_name
kubectl version --short
