#!/usr/bin/perl
#
# AI::Perceptron - an implementation of a single node of a neural net.
# See model at the bottom of this file for more info.
# Steve Purkis <spurkis@epn.nu>
# July 20, 1999
##


package AI::Perceptron;

use strict;
use vars qw /$VERSION/;

$VERSION = 0.01;


##
# new ( [%args] )
#          +--> Inputs => number of inputs X
#          +--> N => Learning rate
#          +--> W => array ref to Weights W.  Note that W[0] = threshold
#
sub new {
    my ($class, %args) = @_;
    my $self = {};
    
    # initialize weights, deltas, etc:
    $self->{Inputs} = $args{Inputs} || 1;	# Number of inputs
    $self->{N} = $args{N} || 0.05;		# Learning rate
    
    # set the weights (random unless given)...
    for (my $i=0; $i <= $self->{Inputs}; $i++) {
	${$self->{W}}[$i] = ${$args{W}}[$i] || rand();
    }

    bless $self, $class;
}


##
# $p->weights( [@w] )
#
#   Set/get weights (including threshold!!)
#
sub weights {
    my $self = shift || return;
    @{$self->{W}} = @_ if (@_);
    return @{$self->{W}};
}


##
# $p->compute(@x)
#
# Computes the output function 'o' given inputs (x[0] ... x[i])
#
sub compute {
    my $self = shift || return;
    my @x = @_;
    my $Sum;
    
    unshift @x, 1;	# set x[0]=1
    
    for (my $i=0; $i <= $self->{Inputs}; $i++) {
	$Sum += ${$self->{W}}[$i] * $x[$i];
    }

    return ($Sum > 0) ? 1 : -1;		# binary model
    #return $Sum;				# 'real' model (not really a perceptron)
}


##
# $p->train( $n, $training_examples )
#                    \--> [ $target_output, @inputs ]
#
# This uses the Stochastic Approximation of the Gradient-Descent model
# to adjust the perceptron's weights.
# Note that this training method may undo previous trainings!

sub train {
    my $self = shift || return;
    my (@train_exs) = @_;
    my $decay = 0.00000;				# decay rate of learning rate N
    

    # Now we adjust the weights for each training example untill the output
    # function produces the desired result.
    foreach (@train_exs) {
	my ($t, @x) = @$_;			# desired training output T & inputs X
	my $o = $self->compute(@x);		# compute output o with existing weights
	my $n = $self->{N};			# N may decay, so keep it seperate
	my $cycle = 0;			# current training cycle
	
	print "Training X=<", join(',', @x), "> with target $t: ";
	
	unshift( @x, 1 );	# compensate for threshold
	
	# want perceptron's output equal to training output
	while ($o != $t) {
	    $cycle++;
	    
	    # adjust weights accordingly...
	    for (my $i=0; $i <= $self->{Inputs}; $i++) {
		my $delta = $n * ($t - $o) * $x[$i];
		${$self->{W}}[$i] += $delta;
		if (($cycle%5000 == 0)) {
		    # debugging
		    print "\n\t$cycle: dW[$i]=$delta, N=$n, t=$t, o=$o, X[$i]=$x[$i]";
		}
	    }
	    
	    $o = $self->compute(@x);		# compute o with new weights
	    $n -= $decay if ($n > $decay);	# decay N
	    
	    if (($cycle%5000 == 0)) {
		# debugging
		print "\n\t$cycle: W={", join(',', @{$self->{W}}), "}\n\t",
		    "X={", join(',', @x), "}, o=$o, t=$t. Press <enter> to keep training.";
		my $ed=<>;
	    }
	}
	print "completed in $cycle cycles.\n";
    }
}


1;

__DATA__


Model of a Perceptron
=====================
                
                  X[0] o  (threshold)
                       |
             +---------------+
X[1] o------ |W[1]    W[0]   |
X[2] o------ |W[2] +---------|            +-------------------+
 .           | .   |   ___   |____________|    __  Squarewave |________\  Output
 .           | .   |   \     |     S      | __|    Generator  |        /
 .           | .   |   /__   |            +-------------------+
X[n] o------ |W[n] |   Sum   |
             +---------------+

	     S  =  Sum ( W[i]X[i] )  as i goes from 0 -> n

	Output  =  1 if S > 0; else -1


__END__

=head1 NAME

AI::Perceptron - An implementation of a Perceptron

=head1 SYNOPSIS

use AI::Perceptron;


=head1 DESCRIPTION

This module is meant to show how a single node of a neural network
works to beginners in the field.

The only mode of training the weights supported at this point in
time is the Stochastic Approximation of the Gradient-Descent model.

=head1 CONSTRUCTOR

=over 4

=item new( [%args] )

Creates a new perceptron with the following properties:

    Inputs => number of inputs (scalar)
    N      => learning rate    (scalar)
    W      => array ref of weights (applied to the inputs)

The Number of elements in W must be equal to the number of inputs
I<plus one>.  This is because W[0] is the Perceptron's I<threshold>
(so W[1] corresponds to the first input's weight).

Default values are: 1, 0.05, and [random], respectively.

=back

=head1 METHODS

=over 4

=item weights( [@W] )

Sets/gets the perceptron's weights.  This is useful between training
sessions to see if the weights are actually changing.  Note again that
W[0] is the Perceptron's I<threshold>.

=item train( $n, $training_examples )

This uses the Stochastic Approximation of the Gradient-Descent model
to adjust the perceptron's weights in such a way to achieve the desired
outputs given in the training examples.

Note that this training method may undo previous trainings!

=back

=head1 SEE ALSO

C<Statistics::LTU>, the ASCII model contained in Perceptron.pm.

=head1 REFERENCES

U<Machine Learning>, by Tom M. Mitchell

=head1 AUTHOR

Steve Purkis E<lt>F<spurkis@epn.nu>E<gt>

=head1 COPYRIGHT

Copyright (c) 1999, 2000 Steve Purkis.  All rights reserved.  This package
is free software; you can redistribute it and/or modify it under the same
terms as Perl itself.

=cut

