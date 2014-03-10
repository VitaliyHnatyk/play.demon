#!/bin/bash
# chkconfig: 345 20 80
# description: Play start/shutdown script
# processname: play
#
# Instalation:
# copy file to /etc/init.d
# chmod +x /etc/init.d/play
# chkconfig --add /etc/init.d/play
# chkconfig play on
#
# Usage: (as root)
# service play start
# service play stop
# service play status
#
# Remember, you need python 2.6 to run the play command, it doesn't come standard with RedHat/Centos 5.5
# Also, you may want to temporarily remove the >/dev/null for debugging purposes
USER=root
USER_HOME=/var/www/html/aplication

# Java home, add java and play to path
#export JAVA_HOME=$USER_HOME/java_home
#export PATH=$JAVA_HOME/bin:$USER_HOME/play_home:$PATH

# Path to the application
APP_PATH=$USER_HOME/target/universal/stage
APP_OPTS="-Dconfig.file=$APP_PATH/conf/application.conf"

RETVAL=0
. /etc/rc.d/init.d/functions

case "$1" in
  start)
    echo -n "Starting Play service"
    rm -f ${APP_PATH}/RUNNING_PID
    su $USER -c "$APP_PATH/bin/website $APP_OPTS >/dev/null" &
    RETVAL=$?
    if [ $RETVAL -eq 0 ]; then
		echo_success
	else
		echo_failure
	fi
	echo
	;;
  stop)
    echo -n "Shutting down Play service"
    kill `cat $APP_PATH/RUNNING_PID`
    RETVAL=$?
    
	if [ $RETVAL -eq 0 ]; then
		echo_success
	else
		echo_failure
	fi
	echo
	;;
esac
exit $RETVAL