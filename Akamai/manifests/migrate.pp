# The migration script

$SCRIPT_NAME = `basename $0`
$USAGE       = "Usage: $SCRIPT_NAME (server) (JVM name) (ENV name) (UPoint release) (lifecycle)"
$USAGEm1     = "Example: ./$SCRIPT_NAME  l4dridap1273 41273_LR_TU_CL106_M1 IntQA Upoint_5_2 test"
$USAGEm2     = "./$SCRIPT_NAME  l4dridap1274 41274_LR_TU_CL130_M1 UPoint Pepsi2Release test"
$USAGEm3     = "./$SCRIPT_NAME  l4dridap1273 41274_LR_TU_CL110_M1 UPoint Pepsi3Release test"
$USAGEm4     = "./$SCRIPT_NAME  l4dridap1274 41274_LR_TU_CL123_M1 UPoint Pepsi4Release test"
$USAGEm5     = "./$SCRIPT_NAME  l4dridap1274 41274_LR_TU_CL118_M1 UPoint base test"
$USAGEm6     = "./$SCRIPT_NAME  l4dridap1274 41274_LR_TU_CL122_M1 UPoint CL122 test"
$USAGEm7     = "./$SCRIPT_NAME  l4dridap1274 41274_LR_TU_CL124_M1 UPoint CL124 test"
$USAGEm8     = "./$SCRIPT_NAME  l8sisa13     813_CL1_Liferay_ST_M1 UPoint STE test"
$USAGEm9     = "- where the server and JVM are required to pull contents from the installedApps location."
$USAGEm10    = "- the lifecycle, environment (ENV) name, and the UPoint Release are required so it knows where to stage and migrate it in the cache servers."


