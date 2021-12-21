# IBM @DOCKER.VERSION@  - Helm Chart Production Edition 
# Breaking Changes
* Deprecated route.enable parameter 
# What's new in Chart Version 1.1.0
A refresh of the fully-featured version of IBM @DOCKER.VERSION@ is available. 
# Fixes
* Minor fixes.
# Prerequisites
*  Kubernetes 1.14.1 
*  IBM containers run on amd64 systems
*  If dynamic provisioning is not being used, a Persistent Volume must be created and setup with labels that can be used to refine the Kubernetes PVC bind process
*  If dynamic provisioning is being used, specify a storageClass per Persistent Volume provisioner to support dynamic volume provisioning
*  A default storageClass is setup during the cluster installation or created prior to the deployment by the Kubernetes administrator
*  To reach the Server and Console services from outside the cluster, you need to configure your DNS defining a virtual hostname that points to the cluster proxy for each service
*  Create a Role and a RoleBinding for the namespace (for further details, refer to the Readme specific for the component you're installing)
*  Create a DB instance and schema (Server and Console only; for further details, refer to the Readme specific for the component you're installing)
*  Create a mysecret.yaml file to store passwords (Server and Console only; for further details, refer to the Readme specific for the component you're installing)  
# Documentation
For detailed installation and update instructions go to the [online](https://www.ibm.com/support/knowledgecenter/en/SSGSPN_9.5.0/com.ibm.tivoli.itws.doc_9.5/distr/src_pi/awspipartdepcont.htm) documentation. Moreover, check the README file provided with the chart.
# Version History
| Chart   | Date              | Kubernetes Required           | Image(s) Supported                | Breaking Changes | Details                                                                      |
| ------- | ----------------- | ----------------------------- | --------------------------------- | ---------------- | ---------------------------------------------------------------------------- | 
| 1.1.0        | June 15, 2019     | | ibm-workload-automation-server        | n/a              | Chart refresh                                                                |
|         |                   |                               | ibm-workload-automation-console       |                  |                                                                              |                  
|         |                   |                               | ibm-workload-automation-agent-dynamic         |                  |                                                                              |
| 1.0.0   | February 15, 2019 |  | ibm-workload-automation-server        | n/a              | Chart created.                                                               |
|         |                   |                               | ibm-workload-automation-console       |                  |                                                                              |
|         |                   |                               | ibm-workload-automation-agent-dynamic         |                  |                                                                              |
