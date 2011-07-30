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

    it '2 <h2> create section';

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
        }, $e2_h2, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e2_h2},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                    ->{'child'}[-1]; # section_e2_anon
            $v;
        } , spec;

    it '2 </h2> drop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e2_h2},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_body
                    ->{'child'}[-1]; # section_e2_anon
            $v;
        }, $e2_h2, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
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
                    ->{'child'}[-1]; # section_e2_anon
            $v;
        } , spec;

    it '3 <blockquote> create section';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
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
                    ->{'child'}[-1]; # section_e2_anon
            $v;
        }, $e3_blockquote, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_blockquote,
                    'outline' => [
                        {   # section_e3_blockquote
                            'element' => $e3_blockquote,
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
                                    {   # section_e2_anon
                                        'element' => undef,
                                        'heading' => $e2_h2,
                                        'child' => [],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_blockquote
            $v;
        } , spec;

    it '3 1 <h3> add header';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_blockquote,
                    'outline' => [
                        {   # section_e3_blockquote
                            'element' => $e3_blockquote,
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
                                    {   # section_e2_anon
                                        'element' => undef,
                                        'heading' => $e2_h2,
                                        'child' => [],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_blockquote
            $v;
        }, $e31_h3, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_blockquote,
                    'outline' => [
                        {   # section_e3_blockquote
                            'element' => $e3_blockquote,
                            'heading' => $e31_h3,
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
                                    {   # section_e2_anon
                                        'element' => undef,
                                        'heading' => $e2_h2,
                                        'child' => [],
                                    },
                                ],
                            },
                        ],
                    },
                    {'element' => $e31_h3},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_blockquote
            $v;
        } , spec;

    it '3 1 </h3> drop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_blockquote,
                    'outline' => [
                        {   # section_e3_blockquote
                            'element' => $e3_blockquote,
                            'heading' => $e31_h3,
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
                                    {   # section_e2_anon
                                        'element' => undef,
                                        'heading' => $e2_h2,
                                        'child' => [],
                                    },
                                ],
                            },
                        ],
                    },
                    {'element' => $e31_h3},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_blockquote
            $v;
        }, $e31_h3, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_blockquote,
                    'outline' => [
                        {   # section_e3_blockquote
                            'element' => $e3_blockquote,
                            'heading' => $e31_h3,
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
                                    {   # section_e2_anon
                                        'element' => undef,
                                        'heading' => $e2_h2,
                                        'child' => [],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_blockquote
            $v;
        } , spec;

    it '3 </blockquote> ignore';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e3_blockquote,
                    'outline' => [
                        {   # section_e3_blockquote
                            'element' => $e3_blockquote,
                            'heading' => $e31_h3,
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
                                    {   # section_e2_anon
                                        'element' => undef,
                                        'heading' => $e2_h2,
                                        'child' => [],
                                    },
                                ],
                            },
                        ],
                    },
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_blockquote
            $v;
        }, $e3_blockquote, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
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
                    ->{'child'}[-1]; # section_e2_anon
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
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
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
                    ->{'child'}[-1]; # section_e2_anon
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
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
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
                    ->{'child'}[-1]; # section_e2_anon
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
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
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
                    ->{'child'}[-1]; # section_e2_anon
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
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
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
                    ->{'child'}[-1]; # section_e2_anon
            $v;
        } , spec;

    it '5 <h2> create section';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
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
                    ->{'child'}[-1]; # section_e2_anon
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
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
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
                    ->{'child'}[-1]; # section_e2_anon
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
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
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
                    ->{'child'}[-1]; # section_e2_anon
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
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
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
                    ->{'child'}[-1]; # section_e2_anon
            $v;
        } , spec;

    it '6 <section> create section';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
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
                    ->{'child'}[-1]; # section_e2_anon
            $v;
        }, $e6_section, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e6_section,
                    'outline' => [
                        {   # section_e6_section
                            'element' => $e6_section,
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
                                    {   # section_e2_anon
                                        'element' => undef,
                                        'heading' => $e2_h2,
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
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e6_section
            $v;
        } , spec;

    it '6 1 <h3> add header';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e6_section,
                    'outline' => [
                        {   # section_e6_section
                            'element' => $e6_section,
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
                                    {   # section_e2_anon
                                        'element' => undef,
                                        'heading' => $e2_h2,
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
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e6_section
            $v;
        }, $e61_h3, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e6_section,
                    'outline' => [
                        {   # section_e6_section
                            'element' => $e6_section,
                            'heading' => $e61_h3,
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
                                    {   # section_e2_anon
                                        'element' => undef,
                                        'heading' => $e2_h2,
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
                    {'element' => $e61_h3},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e6_section
            $v;
        } , spec;

    it '6 1 </h3> drop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e6_section,
                    'outline' => [
                        {   # section_e6_section
                            'element' => $e6_section,
                            'heading' => $e61_h3,
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
                                    {   # section_e2_anon
                                        'element' => undef,
                                        'heading' => $e2_h2,
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
                    {'element' => $e61_h3},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e6_section
            $v;
        }, $e61_h3, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $e6_section,
                    'outline' => [
                        {   # section_e6_section
                            'element' => $e6_section,
                            'heading' => $e61_h3,
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
                                    {   # section_e2_anon
                                        'element' => undef,
                                        'heading' => $e2_h2,
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
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e6_section
            $v;
        } , spec;

    it '6 </section> add child';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $e6_section,
                    'outline' => [
                        {   # section_e6_section
                            'element' => $e6_section,
                            'heading' => $e61_h3,
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
                                    {   # section_e2_anon
                                        'element' => undef,
                                        'heading' => $e2_h2,
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
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e6_section
            $v;
        }, $e6_section, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                                {   # section_e6_section
                                    'element' => $e6_section,
                                    'heading' => $e61_h3,
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

    it '7 <p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                                {   # section_e6_section
                                    'element' => $e6_section,
                                    'heading' => $e61_h3,
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
        }, $e7_p, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                                {   # section_e6_section
                                    'element' => $e6_section,
                                    'heading' => $e61_h3,
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

    it '7 </p> nop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                                {   # section_e6_section
                                    'element' => $e6_section,
                                    'heading' => $e61_h3,
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
        }, $e7_p, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                                {   # section_e6_section
                                    'element' => $e6_section,
                                    'heading' => $e61_h3,
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

    it '</body>';

        my $c = do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h1,
                            'child' => [
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                                {   # section_e6_section
                                    'element' => $e6_section,
                                    'heading' => $e61_h3,
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
                                {   # section_e2_anon
                                    'element' => undef,
                                    'heading' => $e2_h2,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h2,
                                    'child' => [],
                                },
                                {   # section_e6_section
                                    'element' => $e6_section,
                                    'heading' => $e61_h3,
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
                    {   # section_e2_anon
                        'element' => undef,
                        'heading' => $e2_h2,
                        'child' => [],
                    },
                    {   # section_e5_anon
                        'element' => undef,
                        'heading' => $e5_h2,
                        'child' => [],
                    },
                    {   # section_e6_section
                        'element' => $e6_section,
                        'heading' => $e61_h3,
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
                    {   # section_e2_anon
                        'element' => undef,
                        'heading' => $e2_h2,
                        'child' => [],
                    },
                    {   # section_e5_anon
                        'element' => undef,
                        'heading' => $e5_h2,
                        'child' => [],
                    },
                    {   # section_e6_section
                        'element' => $e6_section,
                        'heading' => $e61_h3,
                        'child' => [],
                    },
                ],
            },
        ], spec;
}

done_testing;

