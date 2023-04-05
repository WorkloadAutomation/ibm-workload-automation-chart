#!/bin/bash
#
# Post-install script REQUIRED ONLY IF additional setup is required post 
# helm install for this test path.  
#
# Parameters : 
#   -c <chartReleaseName>, the name of the release used to install the helm chart
#
# Pre-req environment: authenticated to cluster & kubectl cli install / setup complete
# Exit when failures occur (including unset variables)
set -o errexit
set -o nounset
set -o pipefail
# Verify pre-req environment
command -v kubectl > /dev/null 2>&1 || { echo "kubectl pre-req is missing."; exit 1; }
# Create post-install components
[[ `dirname $0 | cut -c1` = '/' ]] && postinstallDir=`dirname $0`/ || postinstallDir=`pwd`/`dirname $0`/
# Process parameters notify of any unexpected
while test $# -gt 0; do
	[[ $1 =~ ^-c|--chartrelease$ ]] && { chartRelease="$2"; shift 2; continue; };
    echo "Parameter not recognized: $1, ignored"
    shift
done
: "${chartRelease:="default"}" 
kubectl exec ${chartRelease}-waconsole-0 -- hostname -f