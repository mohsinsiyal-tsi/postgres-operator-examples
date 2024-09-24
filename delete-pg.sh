NAMESPACE=postgres-operator

# Remove finalizers from all resources within the namespace
kubectl api-resources --verbs=list --namespaced -o name | \
  xargs -n 1 -I {} kubectl get {} -n $NAMESPACE -o json | \
  jq -c '.items[] | select(.metadata.finalizers != null) | .metadata.finalizers = []' | \
  while read -r resource; do
    echo $resource | kubectl replace -f -
  done

# Remove finalizers from the namespace itself
kubectl get namespace $NAMESPACE -o json | jq '.spec.finalizers = []' | kubectl replace -f -
