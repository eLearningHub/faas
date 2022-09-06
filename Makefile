cluster-main:
	k3d cluster create main \
	    --agents 3 --servers 3 \
		--k3s-arg '--no-deploy=traefik@server:*' \
		--volume "$$(pwd)/clusters/main/helm-ingress-traefik.yaml:/var/lib/rancher/k3s/server/manifests/helm-ingress-traefik.yaml" \
	    --api-port 0.0.0.0:6550 \
	    --port "80:80@loadbalancer" \
	    --port "443:443@loadbalancer"

delete-main:
	k3d cluster delete main

cluster-faas:
	k3d cluster create faas \
	    --agents 3 --servers 3 \
	    --api-port 0.0.0.0:6550 \
	    --port "80:80@loadbalancer" \
	    --port "443:443@loadbalancer"

delete-faas:
	k3d cluster delete faas

faas:
	arkade install kube-state-metrics
	@printf "%s " "Press enter to continue"
	@read ans
	arkade install nginx-ingress
	@printf "%s " "Press enter to continue"
	@read ans
	arkade install cert-manager
	@printf "%s " "Press enter to continue"
	@read ans
	arkade install  docker-registry --wait
	@printf "%s " "Press enter to continue"
	@read ans
	arkade install openfaas --load-balancer --ingress-operator --wait
#@printf "%s " "Press enter to continue"
#@read ans
#arkade install openfaas-ingress --domain i.do.controlplane.info --email jitkelme@gmail.com

