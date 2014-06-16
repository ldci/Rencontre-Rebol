#! /usr/bin/rebol
Rebol [
	title: "Rencontre: Filtre"
	Author: "Franois Jouen"
]

context [
host_address: system/network/host-address
Default_Port: 2010
Application_Name: "Filtre"
Connected: false
x: y: bx: 0
col: 0.0.255
plot: copy [pen col line]
borne: 5
somme: 0
mean: 0.0
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
		; on parse pour rŽcupŽrer la donnŽe acquisition
		
		temp: parse/all data ":"
		msender: second temp
		if found? find msender "Acquisition" [
		
		tval: third temp
		messages/text: tval show messages
		; for visaulisation 
		if error? try [y: to-integer tval] [y: 250]
		Show_Image]
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

Clear_Screen: does [
	plot: copy [pen col line]
	x: 0 
	append clear visu/effect reduce ['grid 10x10 82.82.92 ]
	append visu/effect reduce ['draw plot]
	show visu
]

Show_Image: does [
		if x > 315 [Clear_Screen ]
		if x = 0 [append visu/effect reduce ['draw plot]]
		bx: bx + 1 
		somme: somme + y
		if bx > borne [ bx: 0 somme: 0.0]
		if bx = borne [ mean: somme / borne ]
		append plot as-pair x mean
		wait 0
		show visu
		x: x + 1
]

view/new  layout/offset [
		origin 0x0
		across
		space 2x5
		at 5x5 label 100 "Server" svr: field 100 to-string host_address
		btn 80 "Join the bus" [Connect]
		at 5x30 label 100 "Port" pf: field 100 to-string Default_Port
		btn 80 "Quit the bus" [ Disconnect]	
		at 5x55 messages: info 200  aled: led 80X24
		at 0x80 visu: box 315x285 green 
		at 0x365 btn 315 "Quit"  [Quit] 
		do [append clear visu/effect reduce ['grid 10x10 82.82.92 ]]
]90x50




do-events]