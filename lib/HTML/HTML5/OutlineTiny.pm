package HTML::HTML5::OutlineTiny;
use strict;
use warnings;
use Carp;
use parent qw(Exporter);

# $Id$

use version; our $VERSION = '0.001';

our @EXPORT_OK = qw(travel_doctree build_outline_step rank);

sub travel_doctree {
    my($yield, $result, $node) = @_;
    $yield->($result, $node, 'entering');
    my @todo = ($node, 1);
    while (@todo) {
        my $i = pop @todo;
        my $array = pop @todo;
        while ($i < @{$array}) {
            my $child = $array->[$i++];
            next if ! ref $child;
            push @todo, $array, $i;
            $yield->($result, $child, 'entering');
            ($array, $i) = ($child, 1);
        }
        last if ! $yield->($result, $array, 'exiting');
    }
    return $result;
}

my %heading = (
    'hgroup' => -1,
    'h1' => -1,
    'h2' => -2,
    'h3' => -3,
    'h4' => -4,
    'h5' => -5,
    'h6' => -6,
);
my $RANK_MIN = -7;

sub rank {
    my($node) = @_;
    my $tagname = lc $node->[0];
    if ($tagname eq 'hgroup') {
        my $rank = {'x' => $RANK_MIN};
        travel_doctree(sub{
            my($r, $n, $event_type) = @_;
            return $r if $event_type ne 'entering';
            my $s = lc $n->[0];
            return $r if $s eq 'hgroup';
            if (my $i = $heading{$s}) {
                $r->{'x'} = $i > $r->{'x'} ? $i : $r->{'x'};
            }
            return $r;
        }, $rank, $node);
        return $rank->{'x'} > $RANK_MIN ? $rank->{'x'} : $heading{'hgroup'};
    }
    elsif (my $i = $heading{$tagname}) {
        return $i;
    }
    return $RANK_MIN;
}

my %sectioning_content = map { $_ => $_ } qw(
    section nav article aside
);
my %sectioning_root = map { $_ => $_ } qw(
    blockquote body details fieldset figure td datagrid th
);
my %sectioning_both = (%sectioning_content, %sectioning_root);

sub build_outline_step {
    my($c, $node, $event_type) = @_;
    my $entering = $event_type eq 'entering';
    my $exiting = ! $entering;
    my $tagname = lc $node->[0];
    my $tos = @{$c->{'stack'}} ? $c->{'stack'}[-1] : undef;
    if ($exiting && $tos && $tos->{'element'} == $node) {
        pop @{$c->{'stack'}};
    }
    elsif ($tos && $heading{lc $tos->{'element'}[0]}) {
        # skip internals in hgroup elements
    }
    elsif ($entering && $sectioning_both{$tagname}) {
        if ($c->{'outlinee'}) {
            push @{$c->{'stack'}}, $c->{'outlinee'};
        }
        $c->{'section'} = {'element' => $node, 'heading' => undef, 'child' => []};
        $c->{'outlinee'} = {'element' => $node, 'outline' => [$c->{'section'}]};
    }
    elsif ($exiting && $tos && $sectioning_content{$tagname}) {
        my $outline = $c->{'outlinee'}{'outline'};
        $c->{'outlinee'} = pop @{$c->{'stack'}};
        $c->{'section'} = $c->{'outlinee'}{'outline'}[-1];
        push @{$c->{'section'}{'child'}}, @{$outline};
    }
    elsif ($exiting && $tos && $sectioning_root{$tagname}) {
        $c->{'outlinee'} = pop @{$c->{'stack'}};
        $c->{'section'} = $c->{'outlinee'}{'outline'}[-1];
        while (@{$c->{'section'}{'child'}}) {
            $c->{'section'} = $c->{'section'}{'child'}[-1];
        }
    }
    elsif ($exiting && $sectioning_both{$tagname}) {
        $c->{'section'} = $c->{'outlinee'}{'outline'}[0];
        return;
    }
    elsif ($entering && $c->{'outlinee'} && $heading{$tagname}) {
        my $outlinee = $c->{'outlinee'};
        my $outline = $c->{'outlinee'}{'outline'};
        if (! $c->{'section'}{'heading'}) {
            $c->{'section'}{'heading'} = $node;
        }
        elsif (rank($node) >= rank($outline->[-1]{'heading'})) {
            $c->{'section'} = {'element' => undef, 'heading' => $node, 'child' => []};
            push @{$outline}, $c->{'section'};
        }
        else {
            my $candidate = $c->{'section'};
            while (rank($node) >= rank($candidate->{'heading'})) {
                $candidate = _find_candidate_parent($c, $candidate, $outline); 
            }
            $c->{'section'} = {'element' => undef, 'heading' => $node, 'child' => []};
            push @{$candidate->{'child'}}, $c->{'section'};
        }
        push @{$c->{'stack'}}, {'element' => $node};
    }
    return $c;
}

sub _find_candidate_parent {
    my($c, $candidate, $outlinee_child) = @_;
    my @todo = (undef, $outlinee_child, 0);
    while (@todo) {
        my $i = pop @todo;
        my $list = pop @todo;
        my $parent = pop @todo;
        while ($i < @{$list}) {
            my $section = $list->[$i++];
            return $parent if $section == $candidate;
            push @todo, $parent, $list, $i;
            ($parent, $list, $i) = ($section, $section->{'child'}, 0);
        }
    }
    return;
}

1;

__END__

=pod

=head1 NAME

HTML::HTML5::OutlineTiny - examination code to study HTML5 Content Outline

=head1 VERSION

0.001

=head1 SYNOPSIS

    use HTML::HTML5::OutlineTiny qw(travel_doctree build_outline_step);
    
    my $outline_structure = travel_doctree(\&build_outline_step,
        ['body',
            ['h1', 'example'],
            ['section',
                ['h1', 'foo'],
            ],
            ['section',
                ['h1', 'bar'],
                ['section',
                    ['h1', 'baz'],
                ],
            ],
        ],
    );

=head1 DESCRIPTION

Not usefull. Please ignore.

=head1 METHODS

=over

=item C< travel_doctree(\&visit_function, \@tree)  >

=item C< build_outline_step(\%context, \@node, $entering_or_exiting) >

=item C< rank(\@node) >

=back

=head1 DEPENDENCIES

None

=head1 SEE ALSO

L<http://www.w3.org/TR/html5/sections.html> section 4.4.11

=head1 AUTHOR

MIZUTANI Tociyuki  C<< <tociyuki@gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, MIZUTANI Tociyuki C<< <tociyuki@gmail.com> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
