Rebol [
	title: "Rencontre:  Port awake Utils"
]

Error1: "Rebol bus unreachable !"

; ----------------------------------------------
; Ajout d'un port à la liste des port en attente
; ----------------------------------------------

append-waiting-port: func [
	port [port!]
	:awake [any-function!]
][
	set-modes port [no-wait: false]
	;any function can be used when we get an awake event
	port/awake: :awake
	insert tail system/ports/wait-list port
	port
]

; -------------------
; Fermeture d'un port
; -------------------

close-waiting-port: func [
	port [port!]
][
	remove find system/ports/wait-list port
	close port
]











