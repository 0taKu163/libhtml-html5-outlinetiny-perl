use strict;
use warnings;
use Test::More;
use HTML::HTML5::OutlineTiny qw(travel_doctree build_outline_step);
use lib qw(t/lib);
use Test::Behaviour::Spec;

plan tests => 20;

# from http://www.w3.org/TR/html5/sections.html 4.4.7 first example (modified)

# build body
    my $e1_h1 = ['h1', '4.4.7 The hgroup element'];
        my $e21_h2 = ['h2', 'The reality dysfunction'];
        my $e22_h3 = ['h3', 'Space is not the only void'];
    my $e2_hgroup = ['hgroup', $e21_h2, $e22_h3];
        my $e31_h2 = ['h2', 'Dr. Strangelove'];
        my $e32_h3 = ['h3', 'Or: How I Learned to Stop Worrying and Love the Bomb'];
    my $e3_hgroup = ['hgroup', $e31_h2, $e32_h3];
my $body = ['body', $e1_h1, $e2_hgroup, $e3_hgroup];

{
    describe 'body data';

    it 'should be nested properly';

        is_deeply $body,
            ['body',
                ['h1', '4.4.7 The hgroup element'],
                ['hgroup',
                    ['h2', 'The reality dysfunction'],
                    ['h3', 'Space is not the only void'],
                ],
                ['hgroup',
                    ['h2', 'Dr. Strangelove'],
                    ['h3', 'Or: How I Learned to Stop Worrying and Love the Bomb'],
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

    it '2 <hgroup> create section';

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
        }, $e2_hgroup, 'entering'), do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $e2_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        } , spec;

    it '2 1 <h2> nop';

        is_deeply build_outline_step(do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $e2_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        }, $e21_h2, 'entering'), do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $e2_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        } , spec;

    it '2 1 </h2> nop';

        is_deeply build_outline_step(do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $e2_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        }, $e21_h2, 'exiting'), do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $e2_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        } , spec;

    it '2 2 <h3> nop';

        is_deeply build_outline_step(do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $e2_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        }, $e22_h3, 'entering'), do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $e2_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        } , spec;

    it '2 2 </h3> nop';

        is_deeply build_outline_step(do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $e2_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        }, $e22_h3, 'exiting'), do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $e2_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        } , spec;

    it '2 </hgroup> drop';

        is_deeply build_outline_step(do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon],
            };
            +{
                'stack' => [{'element' => $e2_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e2_anon,
            };
        }, $e2_hgroup, 'exiting'), do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
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

    it '3 <hgroup> create section';

        is_deeply build_outline_step(do{
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
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
        }, $e3_hgroup, 'entering'), do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [{'element' => $e3_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        } , spec;

    it '3 1 <h2> nop';

        is_deeply build_outline_step(do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [{'element' => $e3_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        }, $e31_h2, 'entering'), do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [{'element' => $e3_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        } , spec;

    it '3 1 </h2> nop';

        is_deeply build_outline_step(do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [{'element' => $e3_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        }, $e31_h2, 'exiting'), do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [{'element' => $e3_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        } , spec;

    it '3 2 <h3> nop';

        is_deeply build_outline_step(do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [{'element' => $e3_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        }, $e32_h3, 'entering'), do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [{'element' => $e3_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        } , spec;

    it '3 2 </h3> nop';

        is_deeply build_outline_step(do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [{'element' => $e3_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        }, $e32_h3, 'exiting'), do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [{'element' => $e3_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        } , spec;

    it '3 </hgroup> drop';

        is_deeply build_outline_step(do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e2_anon, $section_e3_anon],
            };
            +{
                'stack' => [{'element' => $e3_hgroup}],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        }, $e3_hgroup, 'exiting'), do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
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

    it '</body>';

        my $c = do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
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
        };
        ok ! build_outline_step($c, $body, 'exiting'), spec;

    it 'end document';

        is_deeply $c, do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_hgroup,
                'child' => [],
            };
            my $section_e2_anon = {
                'element' => undef,
                'heading' => $e2_hgroup,
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
                'section' => $section_body,
            };
        }, spec;

    it 'should get outline';

        is_deeply $c->{'section'}, {
            'element' => $body,
            'heading' => $e1_h1,
            'child' => [
                {
                    'element' => undef,
                    'heading' => $e2_hgroup,
                    'child' => [],
                },
                {
                    'element' => undef,
                    'heading' => $e3_hgroup,
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
                    'heading' => $e2_hgroup,
                    'child' => [],
                },
                {
                    'element' => undef,
                    'heading' => $e3_hgroup,
                    'child' => [],
                },
            ],
        }, spec;
}

done_testing;

