TOTAL_MEMORY=$( free | grep Mem: | awk '{print $2}')
memory=$( free | grep Mem: | awk '{print $3}')
percentage=$(((100*memory)/TOTAL_MEMORY))

message(){
	echo "error! -w warning threshold -c critical threshold -e email (-w < -c)"
	exit
}

while getopts ":w:c:e" opts
do
	case "${opts}" in
w)
	w=${OPTARG}
	;;
c)
	c=${OPTARG}
	;;
e)
	e=${OPTARG}
	;;
*)
	message
	;;

	esac
done

shift $((OPTIND-1))

datetime="$(date +'%Y%m%d %H:%M')"

if [ $w -ge $c ]
then
	message
fi

if [ $percentage -ge $c ]
then
	echo "Critical at time:$datetime"
	exit 2
fi

if [ $percentage -ge $w ]
then
	echo "Warning at time:$datetime"
	exit 1
fi

if [ $percentage -lt $w ]
then
	echo "Stable at time:$datetime"
	exit 0

fi
