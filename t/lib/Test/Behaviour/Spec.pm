package Test::Behaviour::Spec;
# $Id: Spec.pm,v 0.3 2009-02-14 12:25:11Z tociyuki Rel $
use strict;
use warnings;
use base qw(Exporter);

our $VERSION = '0.03';
our @EXPORT = qw(describe it spec);

my $EMPTY = q{};
my $subject = $EMPTY;
my $statement = $EMPTY;

sub describe {
    my(@arg) = @_;
    $subject = _join_strings(@arg);
    $statement = $EMPTY;
    _first_code(@arg)->($subject);
    return;
}

sub it {
    my(@arg) = @_;
    $statement = _join_strings(@arg);
    _first_code(@arg)->($subject, $statement);
    return;
}

sub spec {
    return join q{ }, $subject, $statement;
}

sub _join_strings {
    my(@arg) = @_;
    my @strings;
    while (@arg && ! ref $arg[0]) {
        push @strings, shift @arg;
    }
    return @strings ? join q{ }, @strings : $EMPTY;    
}

sub _first_code {
    my(@arg) = @_;
    for my $i (0 .. $#arg) {
        return $arg[$i] if ref $arg[$i] eq 'CODE';
    }
    return sub{}; # nop when not found code in @arg.
}

1;

__END__

=pod

=head1 NAME

Test::Behaviour::Spec - Interiors of tests for the Behaviour Driven Developments.

=head1 VERSION

0.03

=head1 SYNOPSIS

    use Test::Behaviour::Spec;
    use Test::More tests => 5;
    
    BEGIN { use_ok('Counter') }
    
    {
        describe 'Counter';
        
        it 'should create an instance.';
            ok ref(Counter->new), spec;
    }
    
    {
        describe '$counter, when counting up,';
            my $counter = Counter->new;
        
        it 'should has a initial value zero.';
            is $counter->value, 0, spec;
            my $v = $counter->value;
        
        it 'should count up.';
            ok $counter->can('up'), spec;
            $counter->up;
        
        it 'should return a succeed value from the initial one.';
            is $counter->value, $v + 1, spec;
    }

=head1 DESCRIPTION

Let's play believe that we are the Behaviour Driven Developers,
putting some additional interiors in our tests. This module
provides you such interiors of three subroutines: 'describe', 'it',
and 'spec'. The naming of them are based on the RSpec that is
a Behaviour Driven Development (BDD) framework for the ruby 
programing language.

=head1 SUBROUTINES

=over

=item C<describe "SUBJECT, when SITUATON,">

The subroutine 'describe' calls a name of a subject with a situation.

=item C<it "should behave ...">

The subroutine 'it' becomes a subject in the behaviour statement.

=item C<spec>

The subroutine 'spec' builds a test name as a statement string
with a subject at last C<describe> subroutine and a statement
at the last C<it> subroutine.

=back

=head1 CONFIGURATION AND ENVIRONMENT

None.

=head1 DEPENDENCIES

None. But you will happy to use this module with some tests.

=head1 INCOMPATIBILITIES

None.

=head1 BUGS AND LIMITATIONS


=head1 SEE ALSO

L<Test::More::Behaviours> is gives you behaviours in a code reference.
    
L<http://rspec.info/> is the original Behaviour Driven Development
framework for Ruby.

=head1 AUTHOR

MIZUTANI Tociyuki  C<< <tociyuki@gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009, MIZUTANI Tociyuki C<< <tociyuki@gmail.com> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
