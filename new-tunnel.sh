#!/bin/bash

if [ "$#" -ne "3" ] ; then
  echo "USAGE: $0 <service> <local_port> <proxy_port>"
  exit 0
fi

SERVICE="$1"
LOCAL_PORT="$2"
PROXY_PORT="$3"

function substitute () {
  while read INPUT ; do
    echo "${INPUT}" |\
      sed "s/%%SERVICE%%/$SERVICE/g" |\
      sed "s/%%LOCAL_PORT%%/$LOCAL_PORT/g" |\
      sed "s/%%PROXY_PORT%%/$PROXY_PORT/g" |\
      cat
  done
}

SERVICE_PATH=/etc/systemd/system
SH_PATH=/etc/ssh-tunneler/active

TEMPLATE=tunneler-%%SERVICE%%-%%PROXY_PORT%%to%%LOCAL_PORT%%
UPDATED="$(echo ${TEMPLATE} | substitute)"

cat template/${TEMPLATE}.service | substitute > ${UPDATED}.service
cat template/${TEMPLATE}.sh | substitute > ${UPDATED}.sh

if [ ! -f ${SERVICE_PATH}/${UPDATED}.service ] ; then
  mv ${UPDATED}.service ${SERVICE_PATH}
else
  echo "'${UPDATED}.service' already exists at '${SERVICE_PATH}'!"
  echo "Leaving the newly created file here."
fi

mkdir -p ${SH_PATH}
if [ ! -f ${SH_PATH}/${UPDATED}.sh ] ; then
  mv ${UPDATED}.sh $SH_PATH
  chown tunneler:root $SH_PATH/${UPDATED}.sh
  chmod +x $SH_PATH/${UPDATED}.sh
else
  echo "'${UPDATED}.sh' already exists at '${SH_PATH}'!"
  echo "Leaving the newly created file here."
fi

systemctl daemon-reload
systemctl enable ${SERVICE}

echo "Service enabled!"
echo "Use 'systemctl start ${UPDATED}' to start it"
echo "Use 'systemctl status ${UPDATED}' to check status"

