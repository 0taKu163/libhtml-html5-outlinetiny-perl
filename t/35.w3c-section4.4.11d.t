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

    it '3 <section> create section';

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
        }, $e3_section, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [
                        {   # section_e3_section
                            'element' => $e3_section,
                            'heading' => undef,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_section
            $v;
        } , spec;

    it '3 1 <h1> set header';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [
                        {   # section_e3_section
                            'element' => $e3_section,
                            'heading' => undef,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_section
            $v;
        }, $e31_h1, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [
                        {   # section_e3_section
                            'element' => $e3_section,
                            'heading' => $e31_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {'element' => $e31_h1},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_section
            $v;
        } , spec;

    it '3 1 </h1> drop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [
                        {   # section_e3_section
                            'element' => $e3_section,
                            'heading' => $e31_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {'element' => $e31_h1},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_section
            $v;
        }, $e31_h1, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [
                        {   # section_e3_section
                            'element' => $e3_section,
                            'heading' => $e31_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_section
            $v;
        } , spec;

    it '3 2 <p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [
                        {   # section_e3_section
                            'element' => $e3_section,
                            'heading' => $e31_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_section
            $v;
        }, $e32_p, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [
                        {   # section_e3_section
                            'element' => $e3_section,
                            'heading' => $e31_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_section
            $v;
        } , spec;

    it '3 2 </p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [
                        {   # section_e3_section
                            'element' => $e3_section,
                            'heading' => $e31_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_section
            $v;
        }, $e32_p, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [
                        {   # section_e3_section
                            'element' => $e3_section,
                            'heading' => $e31_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_section
            $v;
        } , spec;

    it '3 3 <section> create section';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [
                        {   # section_e3_section
                            'element' => $e3_section,
                            'heading' => $e31_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_section
            $v;
        }, $e33_section, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e33_section,
                    'outline' => [
                        {   # section_e33_section
                            'element' => $e33_section,
                            'heading' => undef,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {
                        'element' => $e3_section,
                        'outline' => [
                            {   # section_e3_section
                                'element' => $e3_section,
                                'heading' => $e31_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e33_section
            $v;
        } , spec;

    it '3 3 1 <h1> set header';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e33_section,
                    'outline' => [
                        {   # section_e33_section
                            'element' => $e33_section,
                            'heading' => undef,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {
                        'element' => $e3_section,
                        'outline' => [
                            {   # section_e3_section
                                'element' => $e3_section,
                                'heading' => $e31_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e33_section
            $v;
        }, $e331_h1, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e33_section,
                    'outline' => [
                        {   # section_e33_section
                            'element' => $e33_section,
                            'heading' => $e331_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {
                        'element' => $e3_section,
                        'outline' => [
                            {   # section_e3_section
                                'element' => $e3_section,
                                'heading' => $e31_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {'element' => $e331_h1},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e33_section
            $v;
        } , spec;

    it '3 3 1 </h1> drop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e33_section,
                    'outline' => [
                        {   # section_e33_section
                            'element' => $e33_section,
                            'heading' => $e331_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {
                        'element' => $e3_section,
                        'outline' => [
                            {   # section_e3_section
                                'element' => $e3_section,
                                'heading' => $e31_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {'element' => $e331_h1},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e33_section
            $v;
        }, $e331_h1, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e33_section,
                    'outline' => [
                        {   # section_e33_section
                            'element' => $e33_section,
                            'heading' => $e331_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {
                        'element' => $e3_section,
                        'outline' => [
                            {   # section_e3_section
                                'element' => $e3_section,
                                'heading' => $e31_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e33_section
            $v;
        } , spec;

    it '3 3 2 <p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e33_section,
                    'outline' => [
                        {   # section_e33_section
                            'element' => $e33_section,
                            'heading' => $e331_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {
                        'element' => $e3_section,
                        'outline' => [
                            {   # section_e3_section
                                'element' => $e3_section,
                                'heading' => $e31_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e33_section
            $v;
        }, $e332_p, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e33_section,
                    'outline' => [
                        {   # section_e33_section
                            'element' => $e33_section,
                            'heading' => $e331_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {
                        'element' => $e3_section,
                        'outline' => [
                            {   # section_e3_section
                                'element' => $e3_section,
                                'heading' => $e31_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e33_section
            $v;
        } , spec;

    it '3 3 2 </p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e33_section,
                    'outline' => [
                        {   # section_e33_section
                            'element' => $e33_section,
                            'heading' => $e331_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {
                        'element' => $e3_section,
                        'outline' => [
                            {   # section_e3_section
                                'element' => $e3_section,
                                'heading' => $e31_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e33_section
            $v;
        }, $e332_p, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e33_section,
                    'outline' => [
                        {   # section_e33_section
                            'element' => $e33_section,
                            'heading' => $e331_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {
                        'element' => $e3_section,
                        'outline' => [
                            {   # section_e3_section
                                'element' => $e3_section,
                                'heading' => $e31_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e33_section
            $v;
        } , spec;

    it '3 3 </section> add child';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e33_section,
                    'outline' => [
                        {   # section_e33_section
                            'element' => $e33_section,
                            'heading' => $e331_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {
                        'element' => $e3_section,
                        'outline' => [
                            {   # section_e3_section
                                'element' => $e3_section,
                                'heading' => $e31_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e33_section
            $v;
        }, $e33_section, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [
                        {   # section_e3_section
                            'element' => $e3_section,
                            'heading' => $e31_h1,
                            'child' => [
                                {   # section_e33_section
                                    'element' => $e33_section,
                                    'heading' => $e331_h1,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_section
            $v;
        } , spec;

    it '3 </section> add child';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_section,
                    'outline' => [
                        {   # section_e3_section
                            'element' => $e3_section,
                            'heading' => $e31_h1,
                            'child' => [
                                {   # section_e33_section
                                    'element' => $e33_section,
                                    'heading' => $e331_h1,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_section
            $v;
        }, $e3_section, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_section
                                    'element' => $e3_section,
                                    'heading' => $e31_h1,
                                    'child' => [
                                        {   # section_e33_section
                                            'element' => $e33_section,
                                            'heading' => $e331_h1,
                                            'child' => [],
                                        },
                                    ],
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
        } , spec;

    it '4 <section> create section';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_section
                                    'element' => $e3_section,
                                    'heading' => $e31_h1,
                                    'child' => [
                                        {   # section_e33_section
                                            'element' => $e33_section,
                                            'heading' => $e331_h1,
                                            'child' => [],
                                        },
                                    ],
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
        }, $e4_section, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e4_section,
                    'outline' => [
                        {   # section_e4_section
                            'element' => $e4_section,
                            'heading' => undef,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [
                                    {   # section_e3_section
                                        'element' => $e3_section,
                                        'heading' => $e31_h1,
                                        'child' => [
                                            {   # section_e33_section
                                                'element' => $e33_section,
                                                'heading' => $e331_h1,
                                                'child' => [],
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e4_section
            $v;
        } , spec;

    it '4 1 <h1> set heading';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e4_section,
                    'outline' => [
                        {   # section_e4_section
                            'element' => $e4_section,
                            'heading' => undef,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [
                                    {   # section_e3_section
                                        'element' => $e3_section,
                                        'heading' => $e31_h1,
                                        'child' => [
                                            {   # section_e33_section
                                                'element' => $e33_section,
                                                'heading' => $e331_h1,
                                                'child' => [],
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e4_section
            $v;
        }, $e41_h1, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e4_section,
                    'outline' => [
                        {   # section_e4_section
                            'element' => $e4_section,
                            'heading' => $e41_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [
                                    {   # section_e3_section
                                        'element' => $e3_section,
                                        'heading' => $e31_h1,
                                        'child' => [
                                            {   # section_e33_section
                                                'element' => $e33_section,
                                                'heading' => $e331_h1,
                                                'child' => [],
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                    {'element' => $e41_h1},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e4_section
            $v;
        } , spec;

    it '4 1 </h1> drop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e4_section,
                    'outline' => [
                        {   # section_e4_section
                            'element' => $e4_section,
                            'heading' => $e41_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [
                                    {   # section_e3_section
                                        'element' => $e3_section,
                                        'heading' => $e31_h1,
                                        'child' => [
                                            {   # section_e33_section
                                                'element' => $e33_section,
                                                'heading' => $e331_h1,
                                                'child' => [],
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                    {'element' => $e41_h1},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e4_section
            $v;
        }, $e41_h1, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e4_section,
                    'outline' => [
                        {   # section_e4_section
                            'element' => $e4_section,
                            'heading' => $e41_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [
                                    {   # section_e3_section
                                        'element' => $e3_section,
                                        'heading' => $e31_h1,
                                        'child' => [
                                            {   # section_e33_section
                                                'element' => $e33_section,
                                                'heading' => $e331_h1,
                                                'child' => [],
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e4_section
            $v;
        } , spec;

    it '4 2 <p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e4_section,
                    'outline' => [
                        {   # section_e4_section
                            'element' => $e4_section,
                            'heading' => $e41_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [
                                    {   # section_e3_section
                                        'element' => $e3_section,
                                        'heading' => $e31_h1,
                                        'child' => [
                                            {   # section_e33_section
                                                'element' => $e33_section,
                                                'heading' => $e331_h1,
                                                'child' => [],
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e4_section
            $v;
        }, $e42_p, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e4_section,
                    'outline' => [
                        {   # section_e4_section
                            'element' => $e4_section,
                            'heading' => $e41_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [
                                    {   # section_e3_section
                                        'element' => $e3_section,
                                        'heading' => $e31_h1,
                                        'child' => [
                                            {   # section_e33_section
                                                'element' => $e33_section,
                                                'heading' => $e331_h1,
                                                'child' => [],
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e4_section
            $v;
        } , spec;

    it '4 2 </p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e4_section,
                    'outline' => [
                        {   # section_e4_section
                            'element' => $e4_section,
                            'heading' => $e41_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [
                                    {   # section_e3_section
                                        'element' => $e3_section,
                                        'heading' => $e31_h1,
                                        'child' => [
                                            {   # section_e33_section
                                                'element' => $e33_section,
                                                'heading' => $e331_h1,
                                                'child' => [],
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e4_section
            $v;
        }, $e42_p, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e4_section,
                    'outline' => [
                        {   # section_e4_section
                            'element' => $e4_section,
                            'heading' => $e41_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [
                                    {   # section_e3_section
                                        'element' => $e3_section,
                                        'heading' => $e31_h1,
                                        'child' => [
                                            {   # section_e33_section
                                                'element' => $e33_section,
                                                'heading' => $e331_h1,
                                                'child' => [],
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e4_section
            $v;
        } , spec;

    it '4 </section> add child';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e4_section,
                    'outline' => [
                        {   # section_e4_section
                            'element' => $e4_section,
                            'heading' => $e41_h1,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {
                        'element' => $body,
                        'outline' => [
                            {   # section_body
                                'element' => $body,
                                'heading' => $e1_h1,
                                'child' => [
                                    {   # section_e3_section
                                        'element' => $e3_section,
                                        'heading' => $e31_h1,
                                        'child' => [
                                            {   # section_e33_section
                                                'element' => $e33_section,
                                                'heading' => $e331_h1,
                                                'child' => [],
                                            },
                                        ],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e4_section
            $v;
        }, $e4_section, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_section
                                    'element' => $e3_section,
                                    'heading' => $e31_h1,
                                    'child' => [
                                        {   # section_e33_section
                                            'element' => $e33_section,
                                            'heading' => $e331_h1,
                                            'child' => [],
                                        },
                                    ],
                                },
                                {   # section_e4_section
                                    'element' => $e4_section,
                                    'heading' => $e41_h1,
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
        } , spec;

    it '4 </body>';

        my $c = do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e3_section
                                    'element' => $e3_section,
                                    'heading' => $e31_h1,
                                    'child' => [
                                        {   # section_e33_section
                                            'element' => $e33_section,
                                            'heading' => $e331_h1,
                                            'child' => [],
                                        },
                                    ],
                                },
                                {   # section_e4_section
                                    'element' => $e4_section,
                                    'heading' => $e41_h1,
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
                                {   # section_e3_section
                                    'element' => $e3_section,
                                    'heading' => $e31_h1,
                                    'child' => [
                                        {   # section_e33_section
                                            'element' => $e33_section,
                                            'heading' => $e331_h1,
                                            'child' => [],
                                        },
                                    ],
                                },
                                {   # section_e4_section
                                    'element' => $e4_section,
                                    'heading' => $e41_h1,
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
                    {   # section_e3_section
                        'element' => $e3_section,
                        'heading' => $e31_h1,
                        'child' => [
                            {   # section_e33_section
                                'element' => $e33_section,
                                'heading' => $e331_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {   # section_e4_section
                        'element' => $e4_section,
                        'heading' => $e41_h1,
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
                    {   # section_e3_section
                        'element' => $e3_section,
                        'heading' => $e31_h1,
                        'child' => [
                            {   # section_e33_section
                                'element' => $e33_section,
                                'heading' => $e331_h1,
                                'child' => [],
                            },
                        ],
                    },
                    {   # section_e4_section
                        'element' => $e4_section,
                        'heading' => $e41_h1,
                        'child' => [],
                    },
                ],
            },
        ], spec;
}

done_testing;

