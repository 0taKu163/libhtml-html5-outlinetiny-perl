use strict;
use warnings;
use Test::More;
use HTML::HTML5::OutlineTiny qw(rank);
use lib qw(t/lib);
use Test::Behaviour::Spec;

plan tests => 23;

{
    describe 'rank';
    
    it 'should be true for h1 > h2';
    
        ok rank(['h1']) > rank(['h2']), spec;

    it 'should be true for h1 > h3';
    
        ok rank(['h1']) > rank(['h3']), spec;

    it 'should be true for h1 > h4';
    
        ok rank(['h1']) > rank(['h4']), spec;

    it 'should be true for h1 > h5';

        ok rank(['h1']) > rank(['h5']), spec;

    it 'should be true for h1 > h6';

        ok rank(['h1']) > rank(['h6']), spec;

    it 'should be true for h2 > h3';

        ok rank(['h2']) > rank(['h3']), spec;

    it 'should be true for h2 > h4';
    
        ok rank(['h2']) > rank(['h4']), spec;

    it 'should be true for h2 > h5';
    
        ok rank(['h2']) > rank(['h5']), spec;

    it 'should be true for h2 > h6';
    
        ok rank(['h2']) > rank(['h6']), spec;

    it 'should be true for h2 > h4';
    
        ok rank(['h3']) > rank(['h4']), spec;

    it 'should be true for h2 > h5';
    
        ok rank(['h3']) > rank(['h5']), spec;

    it 'should be true for h2 > h6';
    
        ok rank(['h3']) > rank(['h6']), spec;

    it 'should be true for h4 > h5';
    
        ok rank(['h4']) > rank(['h5']), spec;

    it 'should be true for h4 > h6';
    
        ok rank(['h4']) > rank(['h6']), spec;

    it 'should be true for h5 > h6';
    
        ok rank(['h5']) > rank(['h6']), spec;

    it 'should be true for hgroup == h1';

        ok rank(['hgroup']) == rank(['h1']), spec;

    it 'should be true for hgroup(h6..h1) == h1';

        ok rank(['hgroup',
            ['h6'], ['h5'], ['h4'], ['h3'], ['h2'], ['h1'],
        ]) == rank(['h1']), spec;

    it 'should be true for hgroup(suffle h6..h1) == h1';

        ok rank(['hgroup',
            ['h3'], ['h5'], ['h1'], ['h4'], ['h6'], ['h2'],
        ]) == rank(['h1']), spec;

    it 'should be true for hgroup(h6..h2) == h2';

        ok rank(['hgroup',
            ['h6'], ['h5'], ['h4'], ['h3'], ['h2'],
        ]) == rank(['h2']), spec;

    it 'should be true for hgroup(h6..h3) == h3';

        ok rank(['hgroup',
            ['h6'], ['h5'], ['h4'], ['h3'],
        ]) == rank(['h3']), spec;

    it 'should be true for hgroup(h6..h4) == h4';

        ok rank(['hgroup',
            ['h6'], ['h5'], ['h4'],
        ]) == rank(['h4']), spec;

    it 'should be true for hgroup(h6..h5) == h5';

        ok rank(['hgroup',
            ['h6'], ['h5'],
        ]) == rank(['h5']), spec;

    it 'should be true for hgroup(h6) == h6';

        ok rank(['hgroup',
            ['h6'],
        ]) == rank(['h6']), spec;
}

done_testing;

