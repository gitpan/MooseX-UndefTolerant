use strict;
use warnings;

use Test::More tests => 7;
use Test::Fatal;
use Test::Moose;
use Test::NoWarnings 0.94 ':early';

{
package Foo;
use Moose;
use MooseX::UndefTolerant;

has 'bar' => (
    is => 'ro',
    isa => 'Num',
    init_arg => undef,
);
}

package main;

with_immutable
{
    is(exception { my $foo = Foo->new }, undef, 'constructed with no args');

    is(exception { my $foo = Foo->new(bar => undef) }, undef, 'constructed with undef value');

    is(exception { my $foo = Foo->new(bar => 1234) }, undef, 'constructed with defined value');
} 'Foo';

