mount config using docker run -v /path/to/config:/root/.kube/config

or

add env variables (from config) and run `envsubst < /root/.kube/config > /root/.kube/config` after docker run