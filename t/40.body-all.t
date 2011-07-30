use strict;
use warnings;
use Test::More;
use HTML::HTML5::OutlineTiny qw(travel_doctree build_outline_step);
use lib qw(t/lib);
use Test::Behaviour::Spec;

plan tests => 17;

# build body
    my $e1_h3 = ['h3', 'A'];
    my $e2_h3 = ['h3', 'B'];
    my $e3_h3 = ['h3', 'C'];
    my $e4_h5 = ['h5', 'D'];
    my $e5_h4 = ['h4', 'E'];
    my $e6_h2 = ['h2', 'F'];
my $body = ['body', $e1_h3, $e2_h3, $e3_h3, $e4_h5, $e5_h4, $e6_h2];

{
    describe 'body data';

    it 'should be nested properly';

        is_deeply $body,
            ['body',
                ['h3', 'A'],
                ['h3', 'B'],
                ['h3', 'C'],
                ['h5', 'D'],
                ['h4', 'E'],
                ['h2', 'F'],
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

    it '1 <h3> set header';

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
        }, $e1_h3, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e1_h3},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        } , spec;

    it '1 </h3> drop';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e1_h3},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        }, $e1_h3, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
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

    it '2 <h3>';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_body
            $v;
        }, $e2_h3, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e2_h3},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e2_anon
            $v;
        } , spec;

    it '2 </h3>';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e2_h3},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e2_anon
            $v;
        }, $e2_h3, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e2_anon
            $v;
        } , spec;

    it '3 <h3>';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e2_anon
            $v;
        }, $e3_h3, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e3_h3},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_anon
            $v;
        } , spec;

    it '3 </h3>';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e3_h3},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_anon
            $v;
        }, $e3_h3, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_anon
            $v;
        } , spec;

    it '4 <h5>';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e3_anon
            $v;
        }, $e4_h5, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e4_h5},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_e3_anon
                ->{'child'}[-1]; # section_e4_anon
            $v;
        } , spec;

    it '4 </h5>';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e4_h5},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_e3_anon
                ->{'child'}[-1]; # section_e4_anon
            $v;
        }, $e4_h5, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_e3_anon
                ->{'child'}[-1]; # section_e4_anon
            $v;
        } , spec;

    it '5 <h4>';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_e3_anon
                ->{'child'}[-1]; # section_e4_anon
            $v;
        }, $e5_h4, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h4,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e5_h4},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_e3_anon
                ->{'child'}[-1]; # section_e5_anon
            $v;
        } , spec;

    it '5 </h4>';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h4,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e5_h4},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_e3_anon
                ->{'child'}[-1]; # section_e5_anon
            $v;
        }, $e5_h4, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h4,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_e3_anon
                ->{'child'}[-1]; # section_e5_anon
            $v;
        } , spec;

    it '6 <h2>';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h4,
                                    'child' => [],
                                },
                            ],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1] # section_e3_anon
                ->{'child'}[-1]; # section_e5_anon
            $v;
        }, $e6_h2, 'entering'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h4,
                                    'child' => [],
                                },
                            ],
                        },
                        {   # section_e6_anon
                            'element' => undef,
                            'heading' => $e6_h2,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e6_h2},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e6_anon
            $v;
        } , spec;

    it '6 </h2>';

        is_deeply build_outline_step(do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h4,
                                    'child' => [],
                                },
                            ],
                        },
                        {   # section_e6_anon
                            'element' => undef,
                            'heading' => $e6_h2,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [
                    {'element' => $e6_h2},
                ],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e6_anon
            $v;
        }, $e6_h2, 'exiting'), do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h4,
                                    'child' => [],
                                },
                            ],
                        },
                        {   # section_e6_anon
                            'element' => undef,
                            'heading' => $e6_h2,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e6_anon
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
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h4,
                                    'child' => [],
                                },
                            ],
                        },
                        {   # section_e6_anon
                            'element' => undef,
                            'heading' => $e6_h2,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[-1]; # section_e6_anon
            $v;
        };

        ok ! build_outline_step($c, $body, 'exiting'), spec;

    it 'end document';

        is_deeply $c, do{
            my $v = {
                'outlinee' => {
                    'element' => $body,
                    'outline' => [
                        {   # section_body
                            'element' => $body,
                            'heading' => $e1_h3,
                            'child' => [],
                        },
                        {   # section_e2_anon
                            'element' => undef,
                            'heading' => $e2_h3,
                            'child' => [],
                        },
                        {   # section_e3_anon
                            'element' => undef,
                            'heading' => $e3_h3,
                            'child' => [
                                {   # section_e4_anon
                                    'element' => undef,
                                    'heading' => $e4_h5,
                                    'child' => [],
                                },
                                {   # section_e5_anon
                                    'element' => undef,
                                    'heading' => $e5_h4,
                                    'child' => [],
                                },
                            ],
                        },
                        {   # section_e6_anon
                            'element' => undef,
                            'heading' => $e6_h2,
                            'child' => [],
                        },
                    ],
                },
                'section' => undef,
                'stack' => [],
            };
            $v->{'section'} = $v->{'outlinee'}{'outline'}[0]; # section_body
            $v;
        }, spec;

    it 'should get outline';

        is_deeply $c->{'outlinee'}{'outline'}, [
            {   # section_body
                'element' => $body,
                'heading' => $e1_h3,
                'child' => [],
            },
            {   # section_e2_anon
                'element' => undef,
                'heading' => $e2_h3,
                'child' => [],
            },
            {   # section_e3_anon
                'element' => undef,
                'heading' => $e3_h3,
                'child' => [
                    {   # section_e4_anon
                        'element' => undef,
                        'heading' => $e4_h5,
                        'child' => [],
                    },
                    {   # section_e5_anon
                        'element' => undef,
                        'heading' => $e5_h4,
                        'child' => [],
                    },
                ],
            },
            {   # section_e6_anon
                'element' => undef,
                'heading' => $e6_h2,
                'child' => [],
            },
        ], spec;
}

done_testing;


