echo "Deploy auto scaler for $1 cluster"
cd $working_dir
sed -i 's/AUTOSCALER_VERSION/'$autoscaler_version'/g' cluster-autoscaler-autodiscover.yaml
sed -i 's/CLUSTER_NAME/'$cluster_name'/g' cluster-autoscaler-autodiscover.yaml
kubectl apply -f cluster-autoscaler-autodiscover.yaml
