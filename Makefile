k3d-cluster-main:
	k3d cluster create main \
	    --agents 3 --servers 3 \
		--k3s-arg '--no-deploy=traefik@server:*' \
		--volume "$$(pwd)/clusters/main/helm-ingress-traefik.yaml:/var/lib/rancher/k3s/server/manifests/helm-ingress-traefik.yaml" \
	    --api-port 0.0.0.0:6550 \
	    --port "80:80@loadbalancer" \
	    --port "443:443@loadbalancer"

k3d-cluster-delete:
	k3d cluster delete main
