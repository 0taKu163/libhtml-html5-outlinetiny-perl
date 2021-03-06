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
            'outlinee' => undef,
            'section' => undef,
            'stack' => [],
        }, $body, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => undef,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        } , spec;

    it '1 <h1> set header';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => undef,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        }, $e1_h1, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e1_h1},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        } , spec;

    it '1 </h1> drop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e1_h1},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        }, $e1_h1, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        } , spec;

    it '2 <p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        }, $e2_p, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        } , spec;

    it '2 </p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        }, $e2_p, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        } , spec;

    it '3 <h2> append';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        }, $e3_h2, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e3_h2},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e3_anon
            $v;
        } , spec;

    it '3 </h2> drop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e3_h2},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e3_anon
            $v;
        }, $e3_h2, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e3_anon
            $v;
        } , spec;

    it '4 <p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e3_anon
            $v;
        }, $e4_p, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e3_anon
            $v;
        } , spec;

    it '4 </p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e3_anon
            $v;
        }, $e4_p, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e3_anon
            $v;
        } , spec;

    it '5 <h2> append';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                }
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e3_anon
            $v;
        }, $e5_h2, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e5_h2},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e5_anon
            $v;
        } , spec;

    it '5 </h2> drop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e5_h2},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e5_anon
            $v;
        }, $e5_h2, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e5_anon
            $v;
        } , spec;

    it '6 <p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e5_anon
            $v;
        }, $e6_p, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e5_anon
            $v;
        } , spec;

    it '6 </p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e5_anon
            $v;
        }, $e6_p, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e5_anon
            $v;
        } , spec;

    it '</body> stop';

        my $c = do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                ->{'child'}[-1]; # section_e5_anon
            $v;
        };

        ok ! build_outline_step($c, $body, 'exiting'), spec;

    it 'document end';

        is_deeply $c, do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_anon
                                    'element' => undef,
                                    'heading' => $e3_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        }, spec;

    it 'should got outline';

        is_deeply $c->{'outlinee'}{'outline'}, [
            {   # section_body
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [
                    {   # section_e3_anon
                        'element' => undef,
                        'heading' => $e3_h2,
                        'child' => [],
                    },
                    {   # section_e5_anon
                        'element' => undef,
                        'heading' => $e5_h2,
                        'child' => [],
                    },
                ],
            },
        ], spec;
}

{
    describe 'travel_doctree(build_outline_step, c, body)';

    it 'should build outline.';

        is_deeply travel_doctree(\&build_outline_step, {
            'stack' => [],
            'outlinee' => undef,
            'section' => undef,
        }, $body)->{'outlinee'}{'outline'}, [
            {   # section_body
                'element' => $body,
                'heading' => $e1_h1,
                'child' => [
                    {   # section_e3_anon
                        'element' => undef,
                        'heading' => $e3_h2,
                        'child' => [],
                    },
                    {   # section_e5_anon
                        'element' => undef,
                        'heading' => $e5_h2,
                        'child' => [],
                    },
                ],
            },
        ], spec;
}

done_testing;

