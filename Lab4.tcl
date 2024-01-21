#Simulator
#trace
#namtrace
#create nodes
#color node
#label node
#duplex link
#queue-limit
#recv
#agent-ping
#connect
#sendPingPacket
#procfinish

#Wrote this without seeing anything, come back to this to revise.

set ns [new Simulator]

set nt [open lab4.tr w]
$ns trace-all $nt

set nf [open lab4.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns color 2 Red
$ns color 3 Blue
$ns color 4 Yellow
$ns color 5 Green

$n0 label "ping0"
$n1 label "ping1"
$n2 label "ping2"
$n3 label "ping3"
$n4 label "ping4"
$n5 label "router"

$ns duplex-link $n0 $n5 1Mb 10ms DropTail
$ns duplex-link $n1 $n5 1Mb 10ms DropTail
$ns duplex-link $n2 $n5 1Mb 10ms DropTail
$ns duplex-link $n3 $n5 1Mb 10ms DropTail
$ns duplex-link $n4 $n5 1Mb 10ms DropTail

$ns queue-limit $n0 $n5 5
$ns queue-limit $n1 $n5 5
$ns queue-limit $n2 $n5 2
$ns queue-limit $n3 $n5 5
$ns queue-limit $n4 $n5 5


Agent/Ping instproc recv {from rtt} {
	#self instvar node_
	puts "node[$node_ id] ping answer received from $from in round-trip time
	$rtt ms"
}

set p0 [new Agent/Ping]
$ns attach-agent $p0 $ping0 #$n0 $p0
$p0 set class_ 1

set p1 [new Agent/Ping]
$ns attach-agent $p1 $ping1 #$n1 $p1
$p1 set class_ 2

set p2 [new Agent/Ping]
$ns attach-agent $p2 $ping2 #$n2 $p2
$p2 set class_ 3

set p3 [new Agent/Ping]
$ns attach-agent $p3 $ping3 #$n3 $p3
$p3 set class_ 4

set p4 [new Agent/Ping]
$ns attach-agent $p4 $ping4 #$n4 $p4
$p4 set class_ 5

$ns connect $p2 $p4
$ns connect $p3 $p4

proc sendPingPacket {} {
	global ns p2 p3
	set interval 0.001
	set now [$ns now]
	$ns at [expr $now + $interval] "$p2 send"
	$ns at [expr $now + $interval] "$p3 send"
	$ns at [expr $now + $interval] "sendPingPacket"
}

proc finish {} {
	global ns nt nf
	$ns flush-trace
	exec nam lab4.nam &
	close $nt
	close $nf
	exit 0
}

$ns at 0.1 "sendPingPacket"
$ns at 0.2 "finish"
$ns run
