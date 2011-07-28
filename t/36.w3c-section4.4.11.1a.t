use strict;
use warnings;
use Test::More;
use HTML::HTML5::OutlineTiny qw(travel_doctree build_outline_step);
use lib qw(t/lib);
use Test::Behaviour::Spec;

plan tests => 18;

# from http://www.w3.org/TR/html5/sections.html 4.4.11.1 1st example

# build body
    my $e1_h1 = ['h1', 'A'];
    my $e2_p  = ['p', 'B'];
    my $e3_h2 = ['h2', 'C'];
    my $e4_p  = ['p','D'];
    my $e5_h2 = ['h2', 'E'];
    my $e6_p  = ['p','F'];
my $body = ['body', $e1_h1, $e2_p, $e3_h2, $e4_p, $e5_h2, $e6_p];

{
    describe 'body data';

    it 'should be nested properly';

        is_deeply $body,
            ['body',
                ['h1', 'A'],
                ['p', 'B'],
                ['h2', 'C'],
                ['p','D'],
                ['h2', 'E'],
                ['p','F'],
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

    it '3 <h2> append';

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
        }, $e3_h2, 'entering'), do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon],
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
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon],
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
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        } , spec;

    it '4 <p> nop';

        is_deeply build_outline_step(do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        }, $e4_p, 'entering'), do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        } , spec;

    it '4 </p> nop';

        is_deeply build_outline_step(do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        }, $e4_p, 'exiting'), do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        } , spec;

    it '5 <h2> append';

        is_deeply build_outline_step(do{
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e3_anon,
            };
        }, $e5_h2, 'entering'), do{
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon, $section_e5_anon],
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
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon, $section_e5_anon],
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
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon, $section_e5_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        } , spec;

    it '6 <p> nop';

        is_deeply build_outline_step(do{
             my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon, $section_e5_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        }, $e6_p, 'entering'), do{
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon, $section_e5_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        } , spec;

    it '6 </p> nop';

        is_deeply build_outline_step(do{
             my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon, $section_e5_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        }, $e6_p, 'entering'), do{
            my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon, $section_e5_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        } , spec;

    it '</body> stop';

        my $c = do{
             my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon, $section_e5_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_e5_anon,
            };
        };

        ok ! build_outline_step($c, $body, 'exiting'), spec;

    it 'document end';

        is_deeply $c, do{
             my $section_e5_anon = {
                'element' => undef,
                'heading' => $e5_h2,
                'child' => [],
            };
            my $section_e3_anon = {
                'element' => undef,
                'heading' => $e3_h2,
                'child' => [],
            };
            my $section_body = {
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [$section_e3_anon, $section_e5_anon],
            };
            +{
                'stack' => [],
                'outlinee' => {'element' => $body, 'outline' => [$section_body]},
                'section' => $section_body,
            };
        }, spec;

    it 'should got outline';

        is_deeply $c->{'section'}, +{
            'element' => $body,
            'heading' => $e1_h1,
            'child' => [
                {
                    'element' => undef,
                    'heading' => $e3_h2,
                    'child' => [],
                },
                {
                    'element' => undef,
                    'heading' => $e5_h2,
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
                    'heading' => $e3_h2,
                    'child' => [],
                },
                {
                    'element' => undef,
                    'heading' => $e5_h2,
                    'child' => [],
                },
            ],
        }, spec;
}

done_testing;

