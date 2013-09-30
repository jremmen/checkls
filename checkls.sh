#!/bin/bash

c=0
prog=$$
sitename=("LawSmart" "LawInfo" "LawInfo-Legal-Marketing" "Lead-Counsel" "LawInfo-Blog")
siteurl=(
	"http://www.lawsmart.com"
	"http://www.lawinfo.com"
	"http://www.lawinfo.com/legal-marketing/"
	"http://www.leadcounsel.org"
	"http://blog.lawinfo.com"
)

tput civis

function restore() {
	tput cnorm
	echo ""
	kill $! > /dev/null 2>&1
	kill -s 9 $$ > /dev/null 2>&1
}

function checkSite() {
	lsite=$(wget --server-response --spider -t 1 "$1" 2>&1 | grep 'HTTP/')
	code=${lsite:11:${#lsite}}
	echo -n " $code"
	echo ""
}

trap restore SIGINT SIGKILL 

lsc=$!

function checkStatus() {
	prog=$$
	checkSite "$1" &
	csid=$!
	for i in `seq ${#1} 10000`;
	do
		ss=$(( ${i} / 10 ))
		s=$(printf "%-${ss}s" "[")
		c=$(( ${i} * 10 ))

		if ! kill -0 $csid > /dev/null 2>&1;
		then
			break;
		fi

		echo -ne "\r${s// /=}"
		echo -n "[${c}ms]"
		echo -n ">"
		sleep 0.01s
	done
	echo ""
}

for w in `seq 0 $(( ${#sitename[@]} - 1 ))`;
do
	echo "[${sitename[${w}]}] : ${siteurl[${w}]}"
	checkStatus "${siteurl[${w}]}"
done
