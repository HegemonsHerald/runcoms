#!/bin/bash

function recurr {
  $@

  if [ $? -ne 0 ]
    then
      echo "command: $1 exited with code 1 [ERROR]"
      echo "waiting 5 seconds for User Interrupt until recursion"
      sleep 5s
      recurr $@
  fi
}
  
recurr $@
