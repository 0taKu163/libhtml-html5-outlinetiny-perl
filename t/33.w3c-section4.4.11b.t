use strict;
use warnings;
use Test::More;
use HTML::HTML5::OutlineTiny qw(travel_doctree build_outline_step);
use lib qw(t/lib);
use Test::Behaviour::Spec;

plan tests => 24;

# from http://www.w3.org/TR/html5/sections.html 4.4.11 second example

# build body
    my $e1_h4 = ['h4', 'Apples'];
    my $e2_p = ['p', 'Apples are fruit.'];
        my $e31_h2 = ['h2', 'Taste'];
        my $e32_p = ['p', 'They taste lovely.'];
        my $e33_h6 = ['h6', 'Sweet'];
        my $e34_p = ['p', 'Red apples are sweeter than green ones.'];
        my $e35_h1 = ['h1', 'Color'];
        my $e36_p = ['p', 'Apples come in various colors.'];
    my $e3_section = ['section',
        $e31_h2, $e32_p, $e33_h6, $e34_p, $e35_h1, $e36_p
    ];
my $body = ['body', $e1_h4, $e2_p, $e3_section];

{
    describe 'body data';

    it 'should be nested properly';

        is_deeply $body,
            ['body',
                ['h4', 'Apples'],
                ['p', 'Apples are fruit.'],
                ['section',
                    ['h2', 'Taste'],
                    ['p', 'They taste lovely.'],
                    ['h6', 'Sweet'],
                    ['p', 'Red apples are sweeter than green ones.'],
                    ['h1', 'Color'],
                    ['p', 'Apples come in various colors.'],
                ],
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

    it '1 <h4> set header';

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
        }, $e1_h4, 'entering'), do{
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [{'element' => $e1_h4}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '1 </h4> drop';

        is_deeply build_outline_step(do{
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [{'element' => $e1_h4}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        }, $e1_h4, 'exiting'), do{
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '2 <p> nop';

        is_deeply build_outline_step(do{
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        }, $e2_p, 'entering'), do{
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '2 </p> nop';

        is_deeply build_outline_step(do{
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        }, $e2_p, 'exiting'), do{
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '3 <section> create section';

        is_deeply build_outline_step(do{
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        }, $e3_section, 'entering'), do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => undef,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [{'element' => $body, 'outline' => [$section_body]}],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e3_section,
            };
        } , spec;

    it '3 1 <h2> add heading';

        is_deeply build_outline_step(do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => undef,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [{'element' => $body, 'outline' => [$section_body]}],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e3_section,
            };
        }, $e31_h2, 'entering'), do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e31_h2},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e3_section,
            };
        } , spec;

    it '3 1 </h2> drop';

        is_deeply build_outline_step(do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e31_h2},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e3_section,
            };
        }, $e31_h2, 'exiting'), do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e3_section,
            };
        } , spec;

    it '3 2 <p> nop';

        is_deeply build_outline_step(do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e3_section,
            };
        }, $e32_p, 'entering'), do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e3_section,
            };
        } , spec;

    it '3 2 </p> nop';

        is_deeply build_outline_step(do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e3_section,
            };
        }, $e32_p, 'exiting'), do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e3_section,
            };
        } , spec;

    it '3 3 <h6> create section';

        is_deeply build_outline_step(do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e3_section,
            };
        }, $e33_h6, 'entering'), do{
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e33_h6},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e33_anon,
            };
        } , spec;

    it '3 3 </h6> drop';

        is_deeply build_outline_step(do{
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e33_h6},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e33_anon,
            };
        }, $e33_h6, 'exiting'), do{
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e33_anon,
            };
        } , spec;

    it '3 4 <p> nop';

        is_deeply build_outline_step(do{
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e33_anon,
            };
        }, $e34_p, 'entering'), do{
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e33_anon,
            };
        } , spec;

    it '3 4 </p> nop';

        is_deeply build_outline_step(do{
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e33_anon,
            };
        }, $e34_p, 'exiting'), do{
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e33_anon,
            };
        } , spec;

    it '3 5 <h1> create section';

        is_deeply build_outline_step(do{
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e33_anon,
            };
        }, $e35_h1, 'entering'), do{
            my $section_e35_anon = {
                'element' => undef,
                'heading' => $e35_h1,
                'child' => [],
            };
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e35_h1},
                ],
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [$section_e3_section, $section_e35_anon],
                },
                'section' => $section_e35_anon,
            };
        } , spec;

    it '3 5 </h1> drop';

        is_deeply build_outline_step(do{
            my $section_e35_anon = {
                'element' => undef,
                'heading' => $e35_h1,
                'child' => [],
            };
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e35_h1},
                ],
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [$section_e3_section, $section_e35_anon],
                },
                'section' => $section_e35_anon,
            };
        }, $e35_h1, 'exiting'), do{
            my $section_e35_anon = {
                'element' => undef,
                'heading' => $e35_h1,
                'child' => [],
            };
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [$section_e3_section, $section_e35_anon],
                },
                'section' => $section_e35_anon,
            };
        } , spec;

    it '3 6 <p> nop';

        is_deeply build_outline_step(do{
            my $section_e35_anon = {
                'element' => undef,
                'heading' => $e35_h1,
                'child' => [],
            };
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [$section_e3_section, $section_e35_anon],
                },
                'section' => $section_e35_anon,
            };
        }, $e36_p, 'entering'), do{
            my $section_e35_anon = {
                'element' => undef,
                'heading' => $e35_h1,
                'child' => [],
            };
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [$section_e3_section, $section_e35_anon],
                },
                'section' => $section_e35_anon,
            };
        } , spec;

    it '3 6 </p> nop';

        is_deeply build_outline_step(do{
            my $section_e35_anon = {
                'element' => undef,
                'heading' => $e35_h1,
                'child' => [],
            };
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [$section_e3_section, $section_e35_anon],
                },
                'section' => $section_e35_anon,
            };
        }, $e36_p, 'exiting'), do{
            my $section_e35_anon = {
                'element' => undef,
                'heading' => $e35_h1,
                'child' => [],
            };
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [$section_e3_section, $section_e35_anon],
                },
                'section' => $section_e35_anon,
            };
        } , spec;

    it '3 </section> add child';

        is_deeply build_outline_step(do{
            my $section_e35_anon = {
                'element' => undef,
                'heading' => $e35_h1,
                'child' => [],
            };
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [$section_e3_section, $section_e35_anon],
                },
                'section' => $section_e35_anon,
            };
        }, $e3_section, 'exiting'), do{
            my $section_e35_anon = {
                'element' => undef,
                'heading' => $e35_h1,
                'child' => [],
            };
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [$section_e3_section, $section_e35_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '</body>';

        my $c = do{
            my $section_e35_anon = {
                'element' => undef,
                'heading' => $e35_h1,
                'child' => [],
            };
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [$section_e3_section, $section_e35_anon],
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
            my $section_e35_anon = {
                'element' => undef,
                'heading' => $e35_h1,
                'child' => [],
            };
            my $section_e33_anon = {
                'element' => undef,
                'heading' => $e33_h6,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h2,
                'child' => [$section_e33_anon],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h4,
                'child' => [$section_e3_section, $section_e35_anon],
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
            'heading' => $e1_h4,
            'child' => [
                {
                    'element' => $e3_section,
                    'heading' => $e31_h2,
                    'child' => [
                        {
                            'element' => undef,
                            'heading' => $e33_h6,
                            'child' => [],
                        },
                    ],
                },
                {
                    'element' => undef,
                    'heading' => $e35_h1,
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
            'heading' => $e1_h4,
            'child' => [
                {
                    'element' => $e3_section,
                    'heading' => $e31_h2,
                    'child' => [
                        {
                            'element' => undef,
                            'heading' => $e33_h6,
                            'child' => [],
                        },
                    ],
                },
                {
                    'element' => undef,
                    'heading' => $e35_h1,
                    'child' => [],
                },
            ],
        }, spec;
}

done_testing;

