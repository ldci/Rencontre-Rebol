#! /usr/bin/rebol -qs
Rebol [
	title: "Rencontre: Acquisition"
	 Author: "François Jouen"
]

context [
host_address: system/network/host-address
Default_Port: 2010
Application_Name: "Acquisition"
Connected: false
acqoff: false
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
	
	; nothing to process for this app which is just a data sender
	false
]

Connect: does [
		if not connected [
		if error? try [
			port: make port! join to-url "tcp://" [svr/text":" pf/text]
			append-waiting-port port Agent-message-handler
			open/direct port
			connected: true 
			append clear messages/text "Rebol Bus reached"
			aled/colors:  [0.255.0 0.255.0] show [aled Messages]]
		[Alert Error1 connected: false]	
		]
]
Disconnect: does [
	if connected [insert port  join Application_Name [" :Quit"]
	connected: false
	aled/colors:  [255.0.0 255.0.0]
	show [Messages aled]]
]
Send_Message: does [
if connected [
	until [
		val: random 250
		insert port  join Application_Name [":" to-string val ]
		wait 0.05
	acqoff]
	]				
]



view/new layout/offset [
		origin 0x0
		across
		space 2x5
		at 5x5 label 100 "Server" svr: field 100 to-string host_address
		btn 80 "Join the bus" [Connect]
		at 5x30 label 100 "Port" pf: field 100 to-string Default_Port
		btn 80 "Quit the bus" [ Disconnect]		
		at 5x55 btn 100 "Start Acquisition" [ acqoff: false Send_Message] 
		btn 100 "Stop Acquisition" [acqoff: true]
		btn 80 "Quit" [quit]
		at 5x80 messages: info 200  aled: led 80X24		
]50x50




do-events]