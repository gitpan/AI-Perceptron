#!/usr/bin/perl
#
# And - and function using a perceptron
# Steve Purkis <spurkis@epn.nu>
# July 20, 1999
##


use Data::Dumper;
use AI::Perceptron;

print "Example of an And function using a perceptron.\n";
print "Preset weights [y/N]? ";
my $ans = <>;

my @weights = (-0.8, 0.5, 0.5) if ($ans =~ /y/i);	# preset weights?
my @training_exs = (
		    [-1, 0, 0],
		    [-1, 1, 0],
		    [-1, 0, 1],
		    [1, 1, 1],
		   );

my $p = new Perceptron( Inputs => 2, N => 0.1, W => \@weights );

print "\nWeights: ", join(', ', $p->weights), "\n";

foreach (@training_exs) {
    my ($t, @X) = @$_;
    print "Computing X = {", join(', ', @X), "}, target=$t: ", $p->compute(@X), "\n";
}

$p->train(@training_exs);

print "\nWeights: ", join(', ', $p->weights), "\n";

foreach (@training_exs) {
    my ($t, @X) = @$_;
    print "Computing X = {", join(', ', @X), "}, target=$t: ", $p->compute(@X), "\n";
}


