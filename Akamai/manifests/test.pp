# This a test class for Akami
$SCRIPT_NAME=`basename $0`
$USAGE="Usage: $SCRIPT_NAME (ENV name) (UPoint release) (lifecycle)"
$USAGE1="     Example: ./$SCRIPT_NAME  UPoint Release5.3.3 test"
$USAGE2="              ./$SCRIPT_NAME  UPoint Release5.3.4 test"

$tcserver=/apps/tcserver/local/vfabric-tc-server-standard-2.7.0.RELEASE/instances
$SSH=/usr/bin/ssh
$SUDO=/usr/bin/sudo
$SCP=/usr/bin/scp
$MAILX=/usr/bin/mailx
$currdate=`date '+%m%d%y%H%M%S'`
$YBRpublic_dir=/apps/lifecycles/YBR/R5
$Testpublic_dir=/apps/lifecycles/Liferay/public
$Akamai_dir=/apps/rdist/prtlops/utilities/Akamai



