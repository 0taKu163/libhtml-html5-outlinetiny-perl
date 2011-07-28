use strict;
use warnings;
use Test::More;
use HTML::HTML5::OutlineTiny qw(travel_doctree build_outline_step);
use lib qw(t/lib);
use Test::Behaviour::Spec;

plan tests => 28;

# from http://www.w3.org/TR/html5/sections.html 4.4.11 4th example

# build body
    my $e1_h1 = ['h1', 'Apples'];
    my $e2_p = ['p', 'Apples are fruit.'];
        my $e31_h1 = ['h1', 'Taste'];
        my $e32_p = ['p','They taste lovely.'];
            my $e331_h1 = ['h1','Sweet'];
            my $e332_p = ['p','Red apples are sweeter than green ones.'];
        my $e33_section = ['section', $e331_h1, $e332_p];
    my $e3_section = ['section', $e31_h1, $e32_p, $e33_section];
        my $e41_h1 = ['h1','Color'];
        my $e42_p = ['p','Apples come in various colors.'];
    my $e4_section = ['section', $e41_h1, $e42_p];
my $body = ['body', $e1_h1, $e2_p, $e3_section, $e4_section];

{
    describe 'body data';

    it 'should be nested properly';

        is_deeply $body,
            ['body',
                ['h1', 'Apples'],
                ['p', 'Apples are fruit.'],
                ['section',
                    ['h1', 'Taste'],
                    ['p','They taste lovely.'],
                    ['section',
                        ['h1','Sweet'],
                        ['p','Red apples are sweeter than green ones.'],
                    ],
                ],
                ['section',
                    ['h1','Color'],
                    ['p','Apples come in various colors.'],
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

    it '2 <p> nop';

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
        }, $e2_p, 'entering'), do{
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

    it '2 </p> nop';

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
        }, $e2_p, 'exiting'), do{
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

    it '3 <section> create section';

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
        }, $e3_section, 'entering'), do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => undef,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
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

    it '3 1 <h1> set header';

        is_deeply build_outline_step(do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => undef,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
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
        }, $e31_h1, 'entering'), do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e31_h1},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e3_section,
            };
        } , spec;

    it '3 1 </h1> drop';

        is_deeply build_outline_step(do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e31_h1},
                ],
                'outlinee' => {
                    'element' => $e3_section, 'outline' => [$section_e3_section],
                },
                'section' => $section_e3_section,
            };
        }, $e31_h1, 'exiting'), do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
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
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
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
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
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
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
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
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
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

    it '3 3 <section> create section';

        is_deeply build_outline_step(do{
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
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
        }, $e33_section, 'entering'), do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => undef,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e3_section, 'outline' => [$section_e3_section]},
                ],
                'outlinee' => {
                    'element' => $e33_section, 'outline' => [$section_e33_section],
                },
                'section' => $section_e33_section,
            };
        } , spec;

    it '3 3 1 <h1> set header';

        is_deeply build_outline_step(do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => undef,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e3_section, 'outline' => [$section_e3_section]},
                ],
                'outlinee' => {
                    'element' => $e33_section, 'outline' => [$section_e33_section],
                },
                'section' => $section_e33_section,
            };
        }, $e331_h1, 'entering'), do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e3_section, 'outline' => [$section_e3_section]},
                    {'element' => $e331_h1},
                ],
                'outlinee' => {
                    'element' => $e33_section, 'outline' => [$section_e33_section],
                },
                'section' => $section_e33_section,
            };
        } , spec;

    it '3 3 1 </h1> drop';

        is_deeply build_outline_step(do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e3_section, 'outline' => [$section_e3_section]},
                    {'element' => $e331_h1},
                ],
                'outlinee' => {
                    'element' => $e33_section, 'outline' => [$section_e33_section],
                },
                'section' => $section_e33_section,
            };
        }, $e331_h1, 'exiting'), do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e3_section, 'outline' => [$section_e3_section]},
                ],
                'outlinee' => {
                    'element' => $e33_section, 'outline' => [$section_e33_section],
                },
                'section' => $section_e33_section,
            };
        } , spec;

    it '3 3 2 <p> nop';

        is_deeply build_outline_step(do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e3_section, 'outline' => [$section_e3_section]},
                ],
                'outlinee' => {
                    'element' => $e33_section, 'outline' => [$section_e33_section],
                },
                'section' => $section_e33_section,
            };
        }, $e332_p, 'entering'), do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e3_section, 'outline' => [$section_e3_section]},
                ],
                'outlinee' => {
                    'element' => $e33_section, 'outline' => [$section_e33_section],
                },
                'section' => $section_e33_section,
            };
        } , spec;

    it '3 3 2 </p> nop';

        is_deeply build_outline_step(do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e3_section, 'outline' => [$section_e3_section]},
                ],
                'outlinee' => {
                    'element' => $e33_section, 'outline' => [$section_e33_section],
                },
                'section' => $section_e33_section,
            };
        }, $e332_p, 'exiting'), do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e3_section, 'outline' => [$section_e3_section]},
                ],
                'outlinee' => {
                    'element' => $e33_section, 'outline' => [$section_e33_section],
                },
                'section' => $section_e33_section,
            };
        } , spec;

    it '3 3 </section> add child';

        is_deeply build_outline_step(do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e3_section, 'outline' => [$section_e3_section]},
                ],
                'outlinee' => {
                    'element' => $e33_section, 'outline' => [$section_e33_section],
                },
                'section' => $section_e33_section,
            };
        }, $e33_section, 'exiting'), do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
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

    it '3 </section> add child';

        is_deeply build_outline_step(do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
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
        }, $e3_section, 'exiting'), do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '4 <section> create section';

        is_deeply build_outline_step(do{
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        }, $e4_section, 'entering'), do{
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => undef,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e4_section, 'outline' => [$section_e4_section],
                },
                'section' => $section_e4_section,
            };
        } , spec;

    it '4 1 <h1> set heading';

        is_deeply build_outline_step(do{
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => undef,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e4_section, 'outline' => [$section_e4_section],
                },
                'section' => $section_e4_section,
            };
        }, $e41_h1, 'entering'), do{
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => $e41_h1,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e41_h1},
                ],
                'outlinee' => {
                    'element' => $e4_section, 'outline' => [$section_e4_section],
                },
                'section' => $section_e4_section,
            };
        } , spec;

    it '4 1 </h1> drop';

        is_deeply build_outline_step(do{
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => $e41_h1,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                    {'element' => $e41_h1},
                ],
                'outlinee' => {
                    'element' => $e4_section, 'outline' => [$section_e4_section],
                },
                'section' => $section_e4_section,
            };
        }, $e41_h1, 'exiting'), do{
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => $e41_h1,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e4_section, 'outline' => [$section_e4_section],
                },
                'section' => $section_e4_section,
            };
        } , spec;

    it '4 2 <p> nop';

        is_deeply build_outline_step(do{
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => $e41_h1,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e4_section, 'outline' => [$section_e4_section],
                },
                'section' => $section_e4_section,
            };
        }, $e42_p, 'entering'), do{
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => $e41_h1,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e4_section, 'outline' => [$section_e4_section],
                },
                'section' => $section_e4_section,
            };
        } , spec;

    it '4 2 </p> nop';

        is_deeply build_outline_step(do{
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => $e41_h1,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e4_section, 'outline' => [$section_e4_section],
                },
                'section' => $section_e4_section,
            };
        }, $e42_p, 'exiting'), do{
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => $e41_h1,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e4_section, 'outline' => [$section_e4_section],
                },
                'section' => $section_e4_section,
            };
        } , spec;

    it '4 </section> add child';

        is_deeply build_outline_step(do{
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => $e41_h1,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section],
            };
            +{
                'stack' => [
                    {'element' => $body, 'outline' => [$section_body]},
                ],
                'outlinee' => {
                    'element' => $e4_section, 'outline' => [$section_e4_section],
                },
                'section' => $section_e4_section,
            };
        }, $e4_section, 'exiting'), do{
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => $e41_h1,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section, $section_e4_section],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        } , spec;

    it '4 </body>';

        my $c = do{
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => $e41_h1,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section, $section_e4_section],
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
            my $section_e4_section = {
                'element' => $e4_section,
                'heading' => $e41_h1,
                'child' => [],
            };
            my $section_e33_section = {
                'element' => $e33_section,
                'heading' => $e331_h1,
                'child' => [],
            };
            my $section_e3_section = {
                'element' => $e3_section,
                'heading' => $e31_h1,
                'child' => [$section_e33_section],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_section, $section_e4_section],
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
                    'element' => $e3_section,
                    'heading' => $e31_h1,
                    'child' => [
                        {
                            'element' => $e33_section,
                            'heading' => $e331_h1,
                            'child' => [],
                        },
                    ],
                },
                {
                    'element' => $e4_section,
                    'heading' => $e41_h1,
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
                    'element' => $e3_section,
                    'heading' => $e31_h1,
                    'child' => [
                        {
                            'element' => $e33_section,
                            'heading' => $e331_h1,
                            'child' => [],
                        },
                    ],
                },
                {
                    'element' => $e4_section,
                    'heading' => $e41_h1,
                    'child' => [],
                },
            ],
        }, spec;
}

done_testing;

