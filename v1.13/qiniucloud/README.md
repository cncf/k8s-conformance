#How To Reproduce:

##Create Cluster

Create a Cluster for Qiniu Cloud Container Engine.

After the creation completed, lauch the Kubernetes e2e conformance test.

##Run Conformance Test

Run command as blew:

`
go get -u -v github.com/heptio/sonobuoy
`<br>
`
sonobuoy run
`<br>
`
sonobuoy status
`<br>
`
sonobuoy logs
`<br>

Check sonobuoy's logs for the line `no-exit was specified, sonobuoy is now blocking`，which indicates that the e2e test is finished.<br>
Retrieve `e2e.log` and `junit_01.xml` file out of the tar file.
