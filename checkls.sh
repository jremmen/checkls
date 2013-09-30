#!/bin/bash

c=0
prog=$$
site="LawSmart"

tput civis

function restore() {
	tput cnorm
	echo ""
	kill $! > /dev/null 2>&1
	kill -s 9 $$ > /dev/null 2>&1
}

function checkLawsmart() {
	lawsmart=$(wget --server-response --spider -t 1 http://www.lawsmart.com 2>&1 | grep 'HTTP/')
	code=${lawsmart:11:${#lawsmart}}
	echo -n " $code"
	echo ""
	kill $prog > /dev/null 2>&1	
}

trap restore SIGINT SIGKILL 

checkLawsmart &

lsc=$!

for i in `seq ${#site} 70`;
do
	s=$(printf "%-${i}s" "[${site}]")
	echo -ne "\r${s// /=}"
	echo -n "[${c}%]>"
	sleep 0.1s
	c=$(( ($i - ${#site}) * 100 / 48 ))
	if [ $c -gt 100 ]
	then
		c=100
	fi
done

