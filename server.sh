#!/bin/bash

PORT=8002
function start() {
  echo ${PATH}
  echo "start mkdocs"
  # /Library/Frameworks/Python.framework/Versions/3.10/bin/mkdocs serve &
  /Library/Frameworks/Python.framework/Versions/3.10/bin/mkdocs serve --dev-addr 127.0.0.1:${PORT} 
   
}

function stop() {
 echo "stop blog server..."
 # ps -ef | grep "mkdocs" | awk  '{ print $2 }' | xargs  kill 
 lsof -i:${PORT} | awk '{if(NR>1)print $2}' | uniq | xargs kill
}

case ${1} in
  "start")
  start
  ;;
  "stop")
  stop  
  ;;
  "restart")
  stop
  sleep 3
  start
  ;;
  "")
  start 
  ;;

  *)
  echo "error arguents"
  exit 1
  ;;
esac





