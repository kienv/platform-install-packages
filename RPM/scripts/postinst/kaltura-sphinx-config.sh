#!/bin/bash - 
#===============================================================================
#          FILE: kaltura-sphinx-config.sh
#         USAGE: ./kaltura-sphinx-config.sh 
#   DESCRIPTION: configure server as a Sphinx node.
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Jess Portnoy <jess.portnoy@kaltura.com>
#  ORGANIZATION: Kaltura, inc.
#       CREATED: 01/02/14 09:25:30 EST
#      REVISION:  ---
#===============================================================================

#set -o nounset                              # Treat unset variables as an error

if [ -n "$1" -a -r "$1" ];then
	ANSFILE=$1
	. $ANSFILE
fi
RC_FILE=/etc/kaltura.d/system.ini
if [ ! -r "$RC_FILE" ];then
	echo "Could not find $RC_FILE so, exiting.."
	exit 2
fi
. $RC_FILE
if [ ! -r /opt/kaltura/app/base-config.lock ];then
	`dirname $0`/kaltura-base-config.sh "$ANSFILE"
else
	echo "base-config completed successfully, if you ever want to re-configure your system (e.g. change DB hostname) run the following script:
# rm /opt/kaltura/app/base-config.lock
# $BASE_DIR/bin/kaltura-base-config.sh
"
fi
mkdir -p $LOG_DIR/sphinx/data
chown $OS_KALTURA_USER.$OS_KALTURA_USER $LOG_DIR/sphinx/data
echo "sphinxServer = $SPHINX_HOST" > /opt/kaltura/app/configurations/sphinx/populate/`hostname`.ini
/etc/init.d/kaltura-sphinx restart >/dev/null 2>&1
/etc/init.d/kaltura-populate restart >/dev/null 2>&1
