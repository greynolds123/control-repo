# This is qcProd for Akami
SCRIPT_NAME=`basename $0`
USAGE="Usage: $SCRIPT_NAME (ENV name) (UPoint release) (lifecycle)"
USAGE1="     Example: ./$SCRIPT_NAME  UPoint Pepsi4 pu"
USAGEq2="              ./$SCRIPT_NAME  UPoint Pepsi2Release qc"
USAGE3="              ./$SCRIPT_NAME  UPoint Pepsi3Release qc"
USAGE4="              ./$SCRIPT_NAME  UPoint Pepsi4Release qc"
USAGE5="              ./$SCRIPT_NAME  UPoint Release5.3.4 pu"
USAGE6="              ./$SCRIPT_NAME  UPoint Release6.1.2 pu"
USAGE7="              ./$SCRIPT_NAME  UPoint Release6.1.4 qc"
USAGE8="              ./$SCRIPT_NAME  UPoint CL124 qc"
USAGE9="              ./$SCRIPT_NAME  UPoint CL124 pu"
USAGE10="        - the lifecycle, environment (ENV) name, and the UPoint Release are required so it knows where to stage and migrate it in the cache servers."

tcserver=/apps/tcserver/local/vfabric-tc-server-standard-2.7.0.RELEASE/instances
SSH=/usr/bin/ssh
SUDO=/usr/bin/sudo
SCP=/usr/bin/scp
MAILX=/usr/bin/mailx
currdate=`date '+%m%d%y%H%M%S'`
YBRpublic_dir=/apps/lifecycles/YBR/R5
Testpublic_dir=/apps/lifecycles/Liferay/public
Akamai_dir=/apps/rdist/prtlops/utilities/Akamai


