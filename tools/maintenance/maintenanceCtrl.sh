www-172-23-1-2:/home/admin/scripts# cat maintenanceCtrl.sh
#!/bin/sh

TARGETPATH='/var/www/maintenance'
TARGETMFILE='maintenance'
TARGETEMFILE='emaintenance'

echo "hoge"

case $1 in
'-h')
  echo '=[options]'
  echo '===target dev or pro'
  echo '===state on off eon eoff'
  echo '===e = emergency'
  echo '=[sample]'
  echo '=== --dev --on'
  echo '=== --dev --off'
  echo '=== --dev --eon'
  echo '=== --dev --eoff'
  echo '=== --pro --on'
  echo '=== --pro --off'
  echo '=== --pro --eon'
  echo '=== --pro --eoff'
  exit 0
;;
'--dev')
#  DEVSERVER='172.23.1.4'
  DEVSERVER='172.23.1.31'
  echo =[target server = $DEVSERVER]
  ssh $DEVSERVER "[ ! -e $TARGETPATH ] && sudo mkdir $TARGETPATH;sudo chown admin:admin $TARGETPATH"

  if [ '--on' = $2 ] ; then
    echo '===maintenance on!!'
    ssh $DEVSERVER "[ ! -e $TARGETPATH/${TARGETMFILE} ] && touch ${TARGETPATH}/${TARGETMFILE}"
  elif [ '--off' = $2 ] ; then
    echo '===maintenance off!!'
    ssh $DEVSERVER "[ -e $TARGETPATH/${TARGETMFILE} ] && rm ${TARGETPATH}/${TARGETMFILE}"
  elif [ '--eon' = $2 ] ; then
    echo '===emergency maintenance on!!'
    ssh $DEVSERVER "[ ! -e $TARGETPATH/${TARGETEMFILE} ] && touch ${TARGETPATH}/${TARGETEMFILE}"
  elif [ '--eoff' = $2 ] ; then
    echo '===emergency maintenance off!!'
    ssh $DEVSERVER "[ -e $TARGETPATH/${TARGETEMFILE} ] && rm ${TARGETPATH}/${TARGETEMFILE}"
  fi
  exit 0
;;
'--stg')
#  STGSERVER='172.23.1.5'
  STGSERVER='172.23.1.32'
  SPUSER='35938,22143,12312'

  echo =[target server = $STGSERVER]
  ssh $STGSERVER "[ ! -e $TARGETPATH ] && sudo mkdir $TARGETPATH;sudo chown admin:admin $TARGETPATH"

  if [ '--on' = $2 ] ; then
    echo '===maintenance on!!'
    ssh $STGSERVER "[ ! -e $TARGETPATH/${TARGETMFILE} ] && touch ${TARGETPATH}/${TARGETMFILE} | echo $SPUSER > ${TARGETPATH}/${TARGETMFILE}"
  elif [ '--off' = $2 ] ; then
    echo '===maintenance off!!'
    ssh $STGSERVER "[ -e $TARGETPATH/${TARGETMFILE} ] && rm ${TARGETPATH}/${TARGETMFILE}"
  elif [ '--eon' = $2 ] ; then
    echo '===emergency maintenance on!!'
    ssh $STGSERVER "[ ! -e $TARGETPATH/${TARGETEMFILE} ] && touch ${TARGETPATH}/${TARGETEMFILE} | echo $SPUSER > ${TARGETPATH}/${TARGETMFILE}"
  elif [ '--eoff' = $2 ] ; then
    echo '===emergency maintenance off!!'
    ssh $STGSERVER "[ -e $TARGETPATH/${TARGETEMFILE} ] && rm ${TARGETPATH}/${TARGETEMFILE}"
  fi
  exit 0
;;
'--pro')
  SPUSER='39023019,37685221,48355022,42361632,43465048,41506956,33904568,38687787,42425986,42558891,33727896'

  for s in $(/usr/local/sx/sxfind --key server_role --value  www); do
    echo =[target server = $s]
    ssh $s "[ ! -e $TARGETPATH ] && sudo mkdir $TARGETPATH;sudo chown admin:admin $TARGETPATH"

    if [ '--on' = $2 ] ; then
      echo '===maintenance on!!'
      echo "ssh $s \"[ ! -e $TARGETPATH/${TARGETMFILE} ] && touch ${TARGETPATH}/${TARGETMFILE}\""
      ssh $s "[ ! -e $TARGETPATH/${TARGETMFILE} ] && touch ${TARGETPATH}/${TARGETMFILE} | echo $SPUSER > ${TARGETPATH}/${TARGETMFILE}"
    elif [ '--off' = $2 ] ; then
      echo '===maintenance off!!'
      echo "ssh $s \"[ -e $TARGETPATH/${TARGETMFILE} ] && sudo rm ${TARGETPATH}/${TARGETMFILE}\""
      ssh $s "[ -e $TARGETPATH/${TARGETMFILE} ] && sudo rm ${TARGETPATH}/${TARGETMFILE}"
    elif [ '--eon' = $2 ] ; then
      echo '===emergency maintenance on!!'
      ssh $s "[ ! -e $TARGETPATH/${TARGETEMFILE} ] && touch ${TARGETPATH}/${TARGETEMFILE} | echo $SPUSER > ${TARGETPATH}/${TARGETMFILE}"
    elif [ '--eoff' = $2 ] ; then
      echo '===emergency maintenance off!!'
      ssh $s "[ -e $TARGETPATH/${TARGETEMFILE} ] && rm ${TARGETPATH}/${TARGETEMFILE}"
    fi
  done
  exit 0
;;
esac