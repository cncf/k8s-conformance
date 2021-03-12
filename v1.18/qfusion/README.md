## QFusion
QFusion is an enterprise-level DBaaS platform based on cloud native technologies which support for MySQL,SQL Server,Redis,Oracle,PostgreSQL and MongoDB database.It implements key components of database operator orchestration and provides self-healing and auto-scale database feature

## Reproduce Conformance Tests
###  prepare
`contact [Woqutech](http://woqutech.com)  to download relvent images and push to own registry`


### Start Test
`sonobuoy run --mode=certified-conformance`

### Check Status
`sonobuoy status`

### Test Result
`outfile=$(sonobuoy retrieve) 
mkdir ./results; tar xzf $outfile -C ./results`
