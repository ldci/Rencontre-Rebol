#! /usr/bin/rebol -qs
Rebol [
	title: "Rencontre: Test"
	Author: "François Jouen"
]

Context [
host_address: system/network/host-address
Default_Port: 2010
Application_Name: "Test"
Connected: false
img: make image! 300x105

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
	append clear messages/text data
	show messages
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
			append messages/text join "Rebol Bus reached" newline show Messages]
		[Alert Error1 connected: false]	
		]
]

Disconnect: does [
	if connected [insert port  join Application_Name " :Quit"
	connected: false
	messages/text: "Leaving Rebol Bus" 
	show [Messages]]
]

Send_Message: does [
rimg/rate: 1
show rimg
				
]



view/new layout/offset [
		origin 0x0
		across
		space 2x5
		at 5x5 label 100 "Server" svr: field 100 to-string host_address
		btn 80 "Join the bus" [Connect]
		at 5x30 label 100 "Port" pf: field 100 to-string Default_Port
		btn 80 "Quit the bus" [Disconnect]	
		at 5x55 btn 100 "Start Animation" [ Send_Message] 
		btn 100 "Stop Animation" [rimg/rate: none show rimg]
		btn 80 "Quit" [QUIT]
		at 5x80 messages: info 290
		at 0x110 rimg: image img with [
		rate: none
		feel: make feel [
			engage: func [f a e] [
				if e/type = 'time [
					random/seed now 
					img/rgb: black
					loop 1000 [
						poke img 1 + random 299x99 yellow
						poke img 1 + random/secure 299x99 blue
					]
					show f
					atime: to-string now/time 
					xt: parse/all atime ":"
					if error? try [s: join first xt ["-"second xt "-" third xt]] [s: "0-0-0"]
					if connected [insert port  join Application_Name [" : " s]]
				]
			]
		]
	]
	
] 400x500

do-events
]