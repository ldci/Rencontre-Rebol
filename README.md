# Rencontre a REBOL middleware 

Rencontre is a middleware elaborated for the collaboration between interactive applications developed with different languages and toolkits and running on different operating systems.

## Active Agents
Rencontre is a model of communication between active agents which are dynamically stored in a list: agents connect to the bus, send messages and leave the bus without interfering with the other agents.  

## Simple Message
This middleware required a very simple exchange data protocol between agents. Each agent, whatever the operating system or the language used by the developer, must able to send and receive a text message (a string of chars) including only information about the name of the agent and the content of the message organized as follows “Application Name: Message”. 

### TCPIP Broadcasting
A supervisor creates the bus by opening a TCPIP port. Each agent must first verify that the bus is created and then connect to the bus. In other words agents give appointments to each other on the bus. When connected agents can send messages that are collected and then broadcasted by the supervisor to each connected agent. When receiving a message, each agent can locally process or ignore the process. 


### How To
Modify demo.sh according to your folders organisation. 
Then start supervisor.r that will start the TCPIP Server
Then start other agents 

### For Developers 
Have a look to awake.r which allows code pointer to be executed when an awake event is generated on port. 

## enjoy


