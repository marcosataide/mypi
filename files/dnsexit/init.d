#! /bin/sh
### BEGIN INIT INFO
# Provides:          ipupdate
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: ipupdate
# Description:       ipupdate - update dynamic IP in dnsexit
### END INIT INFO
#
# ipUpdate      DnsExit.Com dynamic DNS client.
#
# Version:      1.5
#

set -e

DESC="Dynamic DNS client"
NAME=ipUpdate.pl
DAEMON=/usr/sbin/$NAME
PIDFILE=/var/run/ipUpdate.pid
SCRIPTNAME=/etc/init.d/ipUpdate

# Gracefully exit if the package has been removed.
test -x $DAEMON || exit 0
grep "daemon[:space:]*=[:space:]*no" /etc/dnsexit.conf >/dev/null 2>&1 && exit 0;

d_start() {
        start-stop-daemon --start --quiet --pidfile $PIDFILE \
                --exec $DAEMON
}

d_stop() {
        start-stop-daemon --stop --quiet --pidfile $PIDFILE \
                --name $NAME
}


case "$1" in
  start)
        echo -n "Starting $DESC: $NAME"
        d_start
        echo "."
        ;;
  stop)
        echo -n "Stopping $DESC: $NAME"
        d_stop
        echo "."
        ;;
  restart|force-reload)
        echo -n "Restarting $DESC: $NAME"
        d_stop
        sleep 1
        d_start
        echo "."
        ;;
  *)
        echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2
        exit 1
        ;;
esac

exit 0