##http://themonitoringguy.com/articles/service-availability-reporting/

##czas z ktorego zbieramy sla. w sekundach
periodOftime=20
apiEndpoint=192.168.1.140:8080
nokOccurence=0
okOccurence=0
nosla=0
sla=0

echo "creating array for sla check"
echo ""
echo "measure SLA for $periodOftime seconds"
declare -a slaCheck=()

while [ 1 ]
  do

    counter=1
    until [ $counter -gt $periodOftime ]
    do
      # echo $counter
      ((counter++))
      apiStatus=$(curl -s $apiEndpoint/healthz --connect-timeout 1 --max-time 1)
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

    echo "$(date --iso-8601=seconds) SLA for $periodOftime seconds is $slaString %"
    echo ""

    done

  done
