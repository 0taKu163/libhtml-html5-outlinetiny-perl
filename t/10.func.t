use strict;
use warnings;
use Test::More;
use HTML::HTML5::OutlineTiny qw(travel_doctree build_outline_step rank);
use lib qw(t/lib);
use Test::Behaviour::Spec;

plan tests => 3;

{
    describe 'HH5OutlineTiny';

    it 'should export function travel_doctree';

        ok __PACKAGE__->can('travel_doctree'), spec;

    it 'should export function build_outline_step';

        ok __PACKAGE__->can('build_outline_step'), spec;

    it 'should export function rank';

        ok __PACKAGE__->can('rank'), spec;
}

