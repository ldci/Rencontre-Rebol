#! /usr/bin/rebol
Rebol [
	title: "Rencontre: Stimulus"
	Author: "François Jouen"
]
context [
host_address: system/network/host-address
;host_address: 90.3.112.204
Default_Port: 2010
Application_Name: "Stimulation"
Connected: false
do %awake.r

; ------------------
; Agent Message Handler
; ------------------

Agent-message-handler: func [
	port [port!]
	/local data
][
	
	if not value? in port/state 'inBuffer [return false]
	
	clear data: make string! 257
	if zero? read-io port data 256 [
		close-waiting-port port
		return false
	]
	 if connected [
		; data parsing to get information
		
		temp: parse/all data ":"
		saddress: first temp
		;get message sender
		msender: second temp
		; OK we have to process these data
		if found? find msender "Acquisition" [
			tval: third temp
			messages/text: tval show messages
			; for visualisation 
			if error? try [vacq: to-integer tval] [vacq: 250]
			Stimulus]
	]	
	false
]

Connect: does [
		if not connected [
		if error? try [
			port: make port! join to-url "tcp://" [svr/text":" pf/text]
			append-waiting-port port Agent-message-handler
			open/direct port
			connected: true 
			messages/text: "Rebol Bus reached"  
			aled/colors:  [0.255.0 0.255.0]
			show [aled Messages]]
		[Alert Error1 connected: false]	
		]
]
Disconnect: does [
	if connected [insert port  join Application_Name " :Quit"
	connected: false
	messages/text: "Leaving Rebol Bus" 
	aled/colors:  [255.0.0 255.0.0]
	show [aled Messages]]
]

Stimulus: does [
		if vacq > 150 [d1/color: d1/color: d2/color: d3/color: d4/color: d5/color: yellow]
		if vacq < 150 [d1/color: d1/color: d2/color: d3/color: d4/color: d5/color: blue]
		show [d1 d2 d3 d4 d5]
]

view/new layout/offset [
		origin 0x0
		across
		space 2x5
		at 5x5 label 100 "Server" svr: field 100 to-string host_address
		btn 80 "Join the bus" [Connect]
		at 5x30 label 100 "Port" pf: field 100 to-string Default_Port
		btn 80 "Quit the bus" [ Disconnect]	
		at 5x55 messages: info 200  aled: led 80X24
		at 130x100 d1: box 40x40 blue frame white
		at 130x150  d2: box 40x40 blue frame white
		at 130x200 d3: box 40x40 blue frame white
		at 80x150 d4: box 40x40 blue frame white
		at 180x150 d5: box 40x40 blue frame white
		at 0x265 btn 315 "Quit"  [Quit] 
]75x100

do-events]