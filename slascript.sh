##http://themonitoringguy.com/articles/service-availability-reporting/

##czas z ktorego zbieramy sla. w sekundach
periodOftime=20
nokOccurence=0

echo "creating array for sla check"
declare -a slaCheck=()

while [ 1 ]
  do

    counter=1
    until [ $counter -gt $periodOftime ]
    do
      # echo $counter
      ((counter++))
      apiStatus=$(curl -s 192.168.1.140:8080/healthz --connect-timeout 1 --max-time 1)
      sleep 1

      if [ "$apiStatus" = "ok" ]
      then
        slaCheck[counter]="ok"
        # exit 0
      else
        slaCheck[counter]="nok"
        # exit 1
      fi

    # echo  ${slaCheck[counter]}
    echo ""
    nokOccurence=$(for i in ${slaCheck[*]}; do
                     echo $i
                   done | grep -c -Fx "nok" )
    echo  "$nokOccurence wystapien nok"

    okOccurence=$(for i in ${slaCheck[*]}; do
                    echo $i
                  done |  grep -c -Fx "ok")
    echo  "$okOccurence wystapien ok"

    nosla=$nokOccurence/$periodOftime*100
    sla=100-$nosla
    slaString=$(awk 'BEGIN{

              printf  "%.3f\n", ('"$sla"')}')

    echo "SLA is $slaString %"
    echo ""

    done






  done
