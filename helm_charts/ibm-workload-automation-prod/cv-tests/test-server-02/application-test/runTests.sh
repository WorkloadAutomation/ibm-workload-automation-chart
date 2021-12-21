#!/bin/bash
#
# runTests script REQUIRED ONLY IF additional application verification is 
# needed above and beyond helm tests.
#
# Parameters : 
#   -c <chartReleaseName>, the name of the release used to install the helm chart
#
# Pre-req environment: authenticated to cluster, kubectl cli install / setup complete, & chart installed
# Exit when failures occur (including unset variables)
#set -o errexit
#set -o nounset
#set -o pipefail
# Parameters 
# Below is the current set of parameters which are passed in to the app test script.
# The script can process or ignore the parameters
# The script can be coded to expect the parameter list below, but should not be coded such that additional parameters
# will cause the script to fail
#   -e <environment>, IP address of the environment
#   -r <release>, ie V.R.M.F-tag, the release notation associated with the environment, this will be V.R.M.F, plus an option -tag
#   -a <architecture>, the architecture of the environment 
#   -u <userid>, the admin user id for the environment
#   -p <password>, the password for accessing the environment, base64 encoded, p=`echo p_enc | base64 -d` to decode the password when using
# Process parameters notify of any unexpected
while test $# -gt 0; do
	[[ $1 =~ ^-c|--chartrelease$ ]] && { chartRelease="$2"; shift 2; continue; };
    echo "Parameter not recognized: $1, ignored"
    shift
done
: "${chartRelease:="default"}" 
# Verify pre-req environment
command -v kubectl > /dev/null 2>&1 || { echo "kubectl pre-req is missing."; exit 1; }
#### Functions
manageError()
{
  LOC_RC=$1
  echo "Return Code: $LOC_RC"
  if [ $LOC_RC -ne 0 ]; then
    echo "Error: ${LOC_RC}"
    exit ${LOC_RC}
  else
  	echo "Completed successfully"
  fi
}
#### Setup and execute application test on installation
echo "Running application test"
echo "Verify main processes are running"
kubectl exec -ti ${chartRelease}-waserver-0 -- bash -c ". /opt/wautils/wa_service.env && wa_service server status"
manageError $?	
echo "Execute the optman workflow"
kubectl exec -ti ${chartRelease}-waserver-0 -- bash -c ". /opt/wa/TWS/tws_env.sh && optman ls" | grep "AWSJCL050I Command \"ls\" completed successfully"
manageError $?
# Wait for the server to start
SUCC=1
now=$(date +%s)
timeout=$((now + 20*60))
while [ $(date +%s) -lt $timeout -a $SUCC -ne 0 ]; do
	echo "Waiting for the server to start..."
    kubectl logs ${chartRelease}-waserver-0 | grep "#  WA server started  #" > /dev/null 2>&1
    SUCC=$?
    sleep 60
done
manageError $SUCC
echo "Verify if the agent included in the server is up and linked"
kubectl exec -ti ${chartRelease}-waserver-0 -- bash -c ". /opt/wa/TWS/tws_env.sh && conman sc" | grep "WA_SAGT" | grep "LBI J" > /dev/null 2>&1
manageError $?
