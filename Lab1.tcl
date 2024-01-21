set ns [new Simulator]

set nt [open lab1.tr w]
$ns trace-all $nt

set nf [open lab1.nam w]
$ns namtrace-all $nf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]

$ns color 1 Red
$ns color 2 Blue

$n0 label "Source/udp1"
$n1 label "Source/udp2"
$n2 label "Router"
$n3 label "Destination/null"

$ns duplex-link $n0 $n2 10Mb 300ms DropTail
$ns duplex-link $n1 $n2 10Mb 300ms DropTail
$ns duplex-link $n2 $n3 100kb 300ms DropTail

$ns queue-limit $n0 $n2 5
$ns queue-limit $n1 $n2 5
$ns queue-limit $n2 $n3 2

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null3 [new Agent/Null]
$ns attach-agent $n3 $null3

set cbr0 [new Agent/Traffic/CBR]
$cbr0 attach-agent $udp0
set cbr1 [new Agent/Traffic/CBR]
$cbr1 attach-agent $udp1

$udp0 set class_ 1
$udp1 set class_ 2

$ns connect $udp0 $null3
$ns connect $udp1 $null3

$cbr0 set packetSize_ 500Mb #cbr1
$cbr0 set interval_ 0.001 #cbr1

proc finish { } {
	global ns nt nf
	$ns flush-trace
	exec nam lab1.nam &
	close $nt
	close $nf
	exit 0
}

$ns at 0.1 "$cbr0 start"
$ns at 0.2 "$cbr1 start"
$ns at 10.0 "finish"
$ns run
