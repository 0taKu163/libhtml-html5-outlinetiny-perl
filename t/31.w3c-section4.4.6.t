use strict;
use warnings;
use Test::More;
use HTML::HTML5::OutlineTiny qw(travel_doctree build_outline_step);
use lib qw(t/lib);
use Test::Behaviour::Spec;

plan tests => 18;

# from http://www.w3.org/TR/html5/sections.html 4.4.6

# build body
    my $e1_h1 = ['h1', 'Lets call it a draw(ing surface)'];
    my $e2_h2 = ['h2', 'Diving in'];
    my $e3_h2 = ['h2', 'Simple shapes'];
    my $e4_h2 = ['h2', 'Canvas coordinates'];
    my $e5_h3 = ['h3', 'Canvas coordinates diagram'];
    my $e6_h2 = ['h2', 'Paths'];
my $body = ['body', $e1_h1, $e2_h2, $e3_h2, $e4_h2, $e5_h3, $e6_h2];

{
    describe 'body data';

    it 'should be nested properly';

        is_deeply $body,
            ['body',
                ['h1', 'Lets call it a draw(ing surface)'],
                ['h2', 'Diving in'],
                ['h2', 'Simple shapes'],
                ['h2', 'Canvas coordinates'],
                ['h3', 'Canvas coordinates diagram'],
                ['h2', 'Paths'],
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

    it '3 <h2> create section';

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
        }, $e3_h2, 'entering'), do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [{'element' => $e3_h2}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        } , spec;

    it '3 </h2> drop';

        is_deeply build_outline_step(do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [{'element' => $e3_h2}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        }, $e3_h2, 'exiting'), do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        } , spec;

    it '4 <h2> create section';

        is_deeply build_outline_step(do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        }, $e4_h2, 'entering'), do{
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                ],
            };
            +{
                'stack' => [{'element' => $e4_h2}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e4_anon,
            };
        } , spec;

    it '4 </h2> drop';

        is_deeply build_outline_step(do{
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                ],
            };
            +{
                'stack' => [{'element' => $e4_h2}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e4_anon,
            };
        }, $e4_h2, 'exiting'), do{
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e4_anon,
            };
        } , spec;

    it '5 <h3> create section';

        is_deeply build_outline_step(do{
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e4_anon,
            };
        }, $e5_h3, 'entering'), do{
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h3,
                'child' => [],
            };
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [$section_e5_anon],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                ],
            };
            +{
                'stack' => [{'element' => $e5_h3}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        } , spec;

    it '5 </h3> drop';

        is_deeply build_outline_step(do{
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h3,
                'child' => [],
            };
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [$section_e5_anon],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                ],
            };
            +{
                'stack' => [{'element' => $e5_h3}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        }, $e5_h3, 'exiting'), do{
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h3,
                'child' => [],
            };
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [$section_e5_anon],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        } , spec;

    it '6 <h2> create section';

        is_deeply build_outline_step(do{
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h3,
                'child' => [],
            };
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [$section_e5_anon],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        }, $e6_h2, 'entering'), do{
            my $section_e6_anon = {
                'element' => undef,
                'heading' => $e6_h2,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h3,
                'child' => [],
            };
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [$section_e5_anon],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                    $section_e6_anon,
                ],
            };
            +{
                'stack' => [{'element' => $e6_h2}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e6_anon,
            };
        } , spec;

    it '6 </h2> drop';

        is_deeply build_outline_step(do{
            my $section_e6_anon = {
                'element' => undef,
                'heading' => $e6_h2,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h3,
                'child' => [],
            };
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [$section_e5_anon],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                    $section_e6_anon,
                ],
            };
            +{
                'stack' => [{'element' => $e6_h2}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e6_anon,
            };
        }, $e6_h2, 'exiting'), do{
            my $section_e6_anon = {
                'element' => undef,
                'heading' => $e6_h2,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h3,
                'child' => [],
            };
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [$section_e5_anon],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                    $section_e6_anon,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e6_anon,
            };
        } , spec;

    it '</body>';

        my $c = do{
            my $section_e6_anon = {
                'element' => undef,
                'heading' => $e6_h2,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h3,
                'child' => [],
            };
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [$section_e5_anon],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                    $section_e6_anon,
                ],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e6_anon,
            };
        };

        ok ! build_outline_step($c, $body, 'exiting'), spec;

    it 'document end';

        is_deeply $c, do{
            my $section_e6_anon = {
                'element' => undef,
                'heading' => $e6_h2,
                'child' => [],
            };
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h3,
                'child' => [],
            };
            my $section_e4_anon = {
                'element' => undef,
                'heading' => $e4_h2,
                'child' => [$section_e5_anon],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
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
                    $section_e3_anon,
                    $section_e4_anon,
                    $section_e6_anon,
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
                    'heading' => $e3_h2,
                    'child' => [],
                },
                {
                    'element' => undef,
                    'heading' => $e4_h2,
                    'child' => [
                        {
                            'element' => undef,
                            'heading' => $e5_h3,
                            'child' => [],
                        },
                    ],
                },
                {
                    'element' => undef,
                    'heading' => $e6_h2,
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
            'pool' => {},
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
                    'heading' => $e3_h2,
                    'child' => [],
                },
                {
                    'element' => undef,
                    'heading' => $e4_h2,
                    'child' => [
                        {
                            'element' => undef,
                            'heading' => $e5_h3,
                            'child' => [],
                        },
                    ],
                },
                {
                    'element' => undef,
                    'heading' => $e6_h2,
                    'child' => [],
                },
            ],
        }, spec;
}

done_testing;

