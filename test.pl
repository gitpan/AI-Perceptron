#!/usr/bin/perl
#
# Test suite for AI::Perceptron
##

BEGIN { $| = 1; print "1..1\n"; $i = 1; }
sub ok  { print "ok $i\n"; $i++; }
sub nok { print "not ok $i\n"; $i++; }


##########################################
# load test

use AI::Perceptron;
$loaded = 1;
ok;


##########################################
# other tests

# none available - may cause infinite loops!


##########################################
END   { nok() unless $loaded; }
