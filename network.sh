#!/bin/sh

scriptname=$0
sniffer=$(find "/System/Library/PrivateFrameworks/" -type f -iname airport)

display_usage () {
  echo ""
  echo "Usage: $scriptname [user_input]"
  echo "$scriptname : List basic information from the current connection."
  echo "$scriptname list : Lists available WLANs."
  echo "$scriptname reset en0 : Reset en0 (Wifi) network adapter."
  echo ""
}

show_address () {
  computer_name=$(networksetup -getcomputername)
  echo "Computer: $computer_name"
  netservices=$(networksetup -listallnetworkservices | sed 1,1d)
  for service in ${netservices} ; do
    echo "${service}: $(networksetup -getinfo "${service}" | awk '/IP address:/ { gsub("[a-z]", ""); print $3 }' | sed 's/://g')"
  done
}

current_wifi_network () {
	networksetup -getairportnetwork en0
}

check_wifi () {
  check_string="Wi-Fi Network in use:"
  until ( networksetup -getairportnetwork "$@" | grep "${check_string}" );
  do
    sleep 1;
  done
}

list_adapters () {
  echo "Available network services:"
  echo "--------------------------"
  networksetup -listnetworkserviceorder | grep 'Hardware Port' | awk -F  "(, )|(: )|[)]" '{print $2 ":" $4}'
  echo "--------------------------"
  show_address
}

if [ $# -eq 0 ]; then
 list_adapters
 echo "---------------------------"
 current_wifi_network
 echo "---------------------------"
 exit 0
fi

if [ $# -eq 1 ]; then
  while :
  do
    case $1 in
      "list")
      $sniffer -s
      exit 0
      ;;
      *)
         echo "Incorrect input. Currently only list -parameter accepted as an individual parameter."
         display_usage
         exit 1
         esac
       done
fi
     
if [ $# -eq 2 ]; then
  while :
  do
    if [ "$1" = "reset" ]; then
      while :
      do
        case $2 in
         "en0" )
           sudo ifconfig "$2" down && sudo ifconfig "$2" up
           check_wifi "$2"
           show_address
           exit 0
           ;;
         # not implemented, to be considered:
         # "en1" )
         # "en2" )
         # "en3" )
         # "bridge0" )
         *)
           echo "You didn't give the correct interface (en0) to be reseted."
           exit 1
        esac
      done
     else
      echo "You didn't give a \"reset\" as a first parameter, which is the only acceptable parameter with two parameters."
      exit 1
     fi
   done
 fi
