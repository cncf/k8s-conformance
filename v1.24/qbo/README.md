# CNCF conformance results with QBO

# Requirements
> Linux and Docker
# Clone QBO Home repo

```
git clone https://github.com/alexeadem/qbo-home.git
```

# Start the QBO API
```
cd qbo-home
./qbo start api 
```

# Create a Kubernetes cluster
> Access the web interface via a web browser: [http://localhost:9601/](http://localhost:9601/)
> Type `test` in the autocomplete section and select the Kubernetes version you plan to test
> Wait for the cluster to be created
# Run conformance tests
> Once the cluster has been created you can use the following script to get the results
```
cd cncf
./cncf.sh ~/.qbo/test.conf
```