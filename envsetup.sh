# 
# Use:
# This script assumes that you clone your marakana repos into a single directory,
#  somewhere and that that directory is named by the shell variable:
#  ${MARAKANA_ROOT}
#
# You must invoke this script by sourcing it into a bash shell.
#  Executing it won't work

if [ "x$MARAKANA_ROOT" == "x" ]; then
   echo "Please define the shell variable \$MARAKANA_ROOT"
   return
fi

PATH=${MARAKANA_ROOT}/external/asciidoc:${PATH}
PATH=${MARAKANA_ROOT}/tools/bin:${PATH}

export PATH

