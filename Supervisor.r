#! /usr/bin/rebol -qs
Rebol [
	title: "Rencontre"
 	Author: "François Jouen"
]
context [
do %awake.r

host_address: system/network/host-address
Default-Port: 2010
connection-list: []
active: false
ccount: 0
app_name: ""
app_message: ""


; ---------------------
; Connection Handler for the Server
; ---------------------

Connection-Handler: func [listener [port!] /local port]
	[
	port: first listener
	append-waiting-port port Message-handler
	append connection-list port
	ccount: ccount + 1
	cc/text: to-string ccount
	append clear commes/text join "Connection from " port/host
	show [commes cc]
	false
]


; ------------------
; Server Message Handler
; ------------------

Message-Handler: func [ port [port!] /local data connection]
	[
	; nothing to process: exit
	if not value? in port/state 'inBuffer [return false]

	clear data: make string! 257
	if zero? read-io port data 256 [
		close-waiting-port port
		remove connection-list find port
		return false
	]
	; parse messages from clients and get app name and message
	tmp: parse/all data ":"
	app_name: first tmp
	app_message: second tmp
	; some app wants to quit the bus
	if found? find app_message "Quit" [
		s: join port/host [" ["app_name"]" " disconnected"]
		ccount: ccount - 1 
		cc/text: to-string ccount
		append clear commes/text s]
		cport/text: port/host
		cname/text: app_name
		console/text: app_message
		
		show [commes cc cport cname console]
	
	
	; now broadcast message data for all connected clients	
	foreach connection connection-list [
		if error? try [
		smsg: join port/host [":" app_name ":" app_message] 
		insert connection smsg] []
		
	]
	false
]

; ------------------
; Start Server 
; ------------------

Start-Server: does [
	if not active [
		port: make port! join to-url "tcp://:" pf/text
		append-waiting-port port connection-handler
		open/direct port
		aled/colors:  [0.255.0 0.255.0]
		append clear commes/text join  "Port " [ port/port-id " is waiting for connection " newline]
		show [commes aled]
		active: true
	]
]


; ---------------
; Quit Application
;-------------------

Quit-Requested: does [
	if (confirm/with "Really Quit ?" ["Yes" "No"]) [
		if active [close port ]
		quit]
]


ServerWin: layout/offset [
	across
	space 5x5
	at 5x5 
	txt 70 "Server" left 
	info 100 to-string host_address
	text "Port" 
	pf: field 70 to-string Default-Port
	aled: led 24X24
	btn 70 "Start" [Start-Server]
	btn 70 "Quit" [Quit-Requested]
	at 80X35 commes: info 390
	at 5X70 text 70 "Agents" 
	cc: info 50 to-string ccount Center
	cport: info 100 cname: info 230
	at 80x100 console: info 390 
] 10x50

view/new ServerWin


insert-event-func [
		either all [event/type = 'close event/face = ServerWin][quit-requested][event]
]

do-events
; for the waiting ports
wait []
]
