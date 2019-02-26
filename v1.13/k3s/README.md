# k3s
Lightweight Kubernetes
## To Reproduce

1. Create two machines, any modern Linux will work but this test was done with Ubuntu 18.04.2.
2. On machine one download k3s v0.1.0 and start the server

    k3s server

3. On machine two join the agent to the server

    k3s agent --server https://serverone:6443 --token ${TOKEN}

4. Run sonobuoy v0.13.0
