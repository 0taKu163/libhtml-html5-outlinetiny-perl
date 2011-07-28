use strict;
use warnings;
use Test::More;
use HTML::HTML5::OutlineTiny qw(travel_doctree build_outline_step);
use lib qw(t/lib);
use Test::Behaviour::Spec;

plan tests => 24;

# from http://www.w3.org/TR/html5/sections.html 4.4.11 first example

# build body
    my $e1_h1 = ['h1', 'Foo'];
    my $e2_h2 = ['h2', 'Bar'];
        my $e31_h3 = ['h3', 'Bla'];
    my $e3_blockquote = ['blockquote', $e31_h3];
    my $e4_p  = ['p', 'Baz'];
    my $e5_h2 = ['h2', 'Quux'];
        my $e61_h3 = ['h3', 'Thud'];
    my $e6_section = ['section', $e61_h3];
    my $e7_p  = ['p', 'Grunt'];
my $body = ['body',
    $e1_h1, $e2_h2, $e3_blockquote, $e4_p, $e5_h2, $e6_section, $e7_p,
];

{
    describe 'body data';

    it 'should be nested properly';

        is_deeply $body,
            ['body',
                ['h1', 'Foo'],
                ['h2', 'Bar'],
                ['blockquote',
                    ['h3', 'Bla'],
                ],
                ['p', 'Baz'],
                ['h2', 'Quux'],
                ['section',
                    ['h3', 'Thud'],
                ],
                ['p', 'Grunt'],
            ], spec;
}

{
    describe 'build_outline_step';

    it '<body> create section';

        is_deeply build_outline_step({
            'stack' => [],
            'outlinee' => undef,
            'section' => undef,
        }, $body, 'entering'), do{
            my $section_body = {
                'element' => $body,
                'heading' => undef,
                'child' => [],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '1 <h1> set header';

        is_deeply build_outline_step(do{
            my $section_body = {
                'element' => $body,
                'heading' => undef,
                'child' => [],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        }, $e1_h1, 'entering'), do{
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [{'element' => $e1_h1}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '1 </h1> drop';

        is_deeply build_outline_step(do{
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [{'element' => $e1_h1}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        }, $e1_h1, 'exiting'), do{
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '2 <h2> create section';

        is_deeply build_outline_step(do{
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        }, $e2_h2, 'entering'), do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $e2_h2}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        } , spec;

    it '2 </h2> drop';

        is_deeply build_outline_step(do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $e2_h2}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        }, $e2_h2, 'exiting'), do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        } , spec;

    it '3 <blockquote> create section';

        is_deeply build_outline_step(do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        }, $e3_blockquote, 'entering'), do{
            my $section_e3_blockquote = {
                'element' => $e3_blockquote,
                'heading' => undef,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $body, 'outline' => [$section_body]}],
                'outlinee' => {
                    'element' => $e3_blockquote,'outline' => [$section_e3_blockquote],
                },
                'section' => $section_e3_blockquote,
            };
        } , spec;

    it '3 1 <h3> add header';

        is_deeply build_outline_step(do{
            my $section_e3_blockquote = {
                'element' => $e3_blockquote,
                'heading' => undef,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $body, 'outline' => [$section_body]}],
                'outlinee' => {
                    'element' => $e3_blockquote,'outline' => [$section_e3_blockquote],
                },
                'section' => $section_e3_blockquote,
            };
        }, $e31_h3, 'entering'), do{
            my $section_e3_blockquote = {
                'element' => $e3_blockquote,
                'heading' => $e31_h3,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e31_h3},
                ],
                'outlinee' => {
                    'element' => $e3_blockquote,'outline' => [$section_e3_blockquote],
                },
                'section' => $section_e3_blockquote,
            };
        } , spec;

    it '3 1 </h3> drop';

        is_deeply build_outline_step(do{
            my $section_e3_blockquote = {
                'element' => $e3_blockquote,
                'heading' => $e31_h3,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e31_h3},
                ],
                'outlinee' => {
                    'element' => $e3_blockquote,'outline' => [$section_e3_blockquote],
                },
                'section' => $section_e3_blockquote,
            };
        }, $e31_h3, 'exiting'), do{
            my $section_e3_blockquote = {
                'element' => $e3_blockquote,
                'heading' => $e31_h3,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $body, 'outline' => [$section_body]}],
                'outlinee' => {
                    'element' => $e3_blockquote,'outline' => [$section_e3_blockquote],
                },
                'section' => $section_e3_blockquote,
            };
        } , spec;

    it '3 </blockquote> ignore';

        is_deeply build_outline_step(do{
            my $section_e3_blockquote = {
                'element' => $e3_blockquote,
                'heading' => $e31_h3,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $body, 'outline' => [$section_body]}],
                'outlinee' => {
                    'element' => $e3_blockquote,'outline' => [$section_e3_blockquote],
                },
                'section' => $section_e3_blockquote,
            };
        }, $e3_blockquote, 'exiting'), do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        } , spec;

    it '4 <p> nop';

        is_deeply build_outline_step(do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        }, $e4_p, 'entering'), do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        } , spec;

    it '4 </p> nop';

        is_deeply build_outline_step(do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        }, $e4_p, 'exiting'), do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        } , spec;

    it '5 <h2> create section';

        is_deeply build_outline_step(do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        }, $e5_h2, 'entering'), do{
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e5_anon],
            };
            +{
                'stack' => [{'element' => $e5_h2}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        } , spec;

    it '5 </h2> drop';

        is_deeply build_outline_step(do{
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e5_anon],
            };
            +{
                'stack' => [{'element' => $e5_h2}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        }, $e5_h2, 'exiting'), do{
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e5_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        } , spec;

    it '6 <section> create section';

        is_deeply build_outline_step(do{
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e5_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        }, $e6_section, 'entering'), do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => undef,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e5_anon],
            };
            +{
                'stack' => [{'element' => $body, 'outline' => [$section_body]}],
                'outlinee' => {
                    'element' => $e6_section, 'outline' => [$section_e6_section],
                },
                'section' => $section_e6_section,
            };
        } , spec;

    it '6 1 <h3> add header';

        is_deeply build_outline_step(do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => undef,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e5_anon],
            };
            +{
                'stack' => [{'element' => $body, 'outline' => [$section_body]}],
                'outlinee' => {
                    'element' => $e6_section, 'outline' => [$section_e6_section],
                },
                'section' => $section_e6_section,
            };
        }, $e61_h3, 'entering'), do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => $e61_h3,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e5_anon],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e61_h3},
                ],
                'outlinee' => {
                    'element' => $e6_section, 'outline' => [$section_e6_section],
                },
                'section' => $section_e6_section,
            };
        } , spec;

    it '6 1 </h3> drop';

        is_deeply build_outline_step(do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => $e61_h3,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e5_anon],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e61_h3},
                ],
                'outlinee' => {
                    'element' => $e6_section, 'outline' => [$section_e6_section],
                },
                'section' => $section_e6_section,
            };
        }, $e61_h3, 'exiting'), do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => $e61_h3,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e5_anon],
            };
            +{
                'stack' => [{'element' => $body, 'outline' => [$section_body]}],
                'outlinee' => {
                    'element' => $e6_section, 'outline' => [$section_e6_section],
                },
                'section' => $section_e6_section,
            };
        } , spec;

    it '6 </section> add child';

        is_deeply build_outline_step(do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => $e61_h3,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e5_anon],
            };
            +{
                'stack' => [{'element' => $body, 'outline' => [$section_body]}],
                'outlinee' => {
                    'element' => $e6_section, 'outline' => [$section_e6_section],
                },
                'section' => $section_e6_section,
            };
        }, $e6_section, 'exiting'), do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => $e61_h3,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [
                    $section_e2_anon,
                    $section_e5_anon,
                    $section_e6_section,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '7 <p> nop';

        is_deeply build_outline_step(do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => $e61_h3,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [
                    $section_e2_anon,
                    $section_e5_anon,
                    $section_e6_section,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        }, $e7_p, 'entering'), do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => $e61_h3,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [
                    $section_e2_anon,
                    $section_e5_anon,
                    $section_e6_section,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '7 </p> nop';

        is_deeply build_outline_step(do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => $e61_h3,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [
                    $section_e2_anon,
                    $section_e5_anon,
                    $section_e6_section,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        }, $e7_p, 'exiting'), do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => $e61_h3,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [
                    $section_e2_anon,
                    $section_e5_anon,
                    $section_e6_section,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '</body>';

        my $c = do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => $e61_h3,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [
                    $section_e2_anon,
                    $section_e5_anon,
                    $section_e6_section,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        };
        ok ! build_outline_step($c, $body, 'exiting'), spec;

    it 'document end';

        is_deeply $c, do{
            my $section_e6_section = {
                'element' => $e6_section,
                'heading' => $e61_h3,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [
                    $section_e2_anon,
                    $section_e5_anon,
                    $section_e6_section,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        }, spec;

    it 'should got outline';

        is_deeply $c->{'section'}, {
            'element' => $body,
            'heading' => $e1_h1,
            'child' => [
                {
                    'element' => undef,
                    'heading' => $e2_h2,
                    'child' => [],
                },
                {
                    'element' => undef,
                    'heading' => $e5_h2,
                    'child' => [],
                },
                {
                    'element' => $e6_section,
                    'heading' => $e61_h3,
                    'child' => [],
                },
            ],        
        }, spec;
}

{
    describe 'travel_doctree(build_outline_step, c, body)';

    it 'should build outline.';

        is_deeply travel_doctree(\&build_outline_step, {
            'stack' => [],
            'outlinee' => undef,
            'section' => undef,
        }, $body)->{'section'}, {
            'element' => $body,
            'heading' => $e1_h1,
            'child' => [
                {
                    'element' => undef,
                    'heading' => $e2_h2,
                    'child' => [],
                },
                {
                    'element' => undef,
                    'heading' => $e5_h2,
                    'child' => [],
                },
                {
                    'element' => $e6_section,
                    'heading' => $e61_h3,
                    'child' => [],
                },
            ],        
        }, spec;
}

done_testing;

