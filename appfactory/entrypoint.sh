#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

#echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user >/dev/null 2>&1
export HOME=/home/user

chown user:user "$HOME"

cp -r /etc/skel/. /home/user/


if [[ "$1" == "" ]]
then
	exec /usr/local/bin/gosu user /bin/bash "$@"
	exit
fi

exec /usr/local/bin/gosu user "$@"
exit
