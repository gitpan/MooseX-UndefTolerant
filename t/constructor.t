use Test::More;
use Test::Fatal;

{
    package Foo;
    use Moose;

    has 'attr1' => (
        traits => [ qw(MooseX::UndefTolerant::Attribute)],
        is => 'ro',
        isa => 'Num',
        predicate => 'has_attr1',
    );
    has 'attr2' => (
        is => 'ro',
        isa => 'Num',
        predicate => 'has_attr2',
    );
    has 'attr3' => (
        is => 'ro',
        isa => 'Maybe[Num]',
        predicate => 'has_attr3',
    );
}

{
    package Bar;
    use Moose;
    use MooseX::UndefTolerant;

    has 'attr1' => (
        is => 'ro',
        isa => 'Num',
        predicate => 'has_attr1',
    );
    has 'attr2' => (
        is => 'ro',
        isa => 'Num',
        predicate => 'has_attr2',
    );
    has 'attr3' => (
        is => 'ro',
        isa => 'Maybe[Num]',
        predicate => 'has_attr3',
    );
}

package main;

sub do_tests
{
    note 'Testing class with a single UndefTolerant attribute';
    {
        my $obj = Foo->new;
        ok(!$obj->has_attr1, 'attr1 has no value before it is assigned');
        ok(!$obj->has_attr2, 'attr2 has no value before it is assigned');
        ok(!$obj->has_attr3, 'attr3 has no value before it is assigned');
    }

    {
        my $obj = Foo->new(attr1 => undef);
        ok(!$obj->has_attr1, 'UT attr1 has no value when assigned undef in constructor');
        isnt (exception { $obj = Foo->new(attr2 => undef) }, undef,
            'But assigning undef to attr2 generates a type constraint error');

        is (exception { $obj = Foo->new(attr3 => undef) }, undef,
            'assigning undef to attr3 is acceptable');
        ok($obj->has_attr3, 'attr3 retains its undef value when assigned undef in constructor');
    }

    {
        my $obj = Foo->new(attr1 => 1234, attr2 => 5678, attr3 => 9012);
        is($obj->attr1, 1234, 'assigning a defined value during construction works as normal');
        ok($obj->has_attr1, '...and the predicate returns true as normal');

        is($obj->attr2, 5678, 'assigning a defined value during construction works as normal');
        ok($obj->has_attr2, '...and the predicate returns true as normal');

        is($obj->attr3, 9012, 'assigning a defined value during construction works as normal');
        ok($obj->has_attr3, '...and the predicate returns true as normal');
    }


    note '';
    note 'Testing class with the entire class being UndefTolerant';
    {
        my $obj = Bar->new;
        ok(!$obj->has_attr1, 'attr1 has no value before it is assigned');
        ok(!$obj->has_attr2, 'attr2 has no value before it is assigned');
        ok(!$obj->has_attr3, 'attr3 has no value before it is assigned');
    }

    {
        my $obj = Bar->new(attr1 => undef);
        ok(!$obj->has_attr1, 'attr1 has no value when assigned undef in constructor');
        # note this test differs from the Foo case above
        is (exception { $obj = Bar->new(attr2 => undef) }, undef,
            'assigning undef to attr2 does not produce an error');
        ok(!$obj->has_attr2, 'attr2 has no value when assigned undef in constructor');

        is( exception { $obj = Foo->new(attr3 => undef) }, undef,
            'assigning undef to attr3 is acceptable');
        ok($obj->has_attr3, 'attr3 retains its undef value when assigned undef in constructor');
    }

    {
        my $obj = Bar->new(attr1 => 1234, attr2 => 5678, attr3 => 9012);
        is($obj->attr1, 1234, 'assigning a defined value during construction works as normal');
        ok($obj->has_attr1, '...and the predicate returns true as normal');

        is($obj->attr2, 5678, 'assigning a defined value during construction works as normal');
        ok($obj->has_attr2, '...and the predicate returns true as normal');

        is($obj->attr3, 9012, 'assigning a defined value during construction works as normal');
        ok($obj->has_attr3, '...and the predicate returns true as normal');
    }
}


note 'Constructor behaviour: mutable classes';
note '';
do_tests;

note '';
note 'Constructor behaviour: immutable classes';
note '';
Foo->meta->make_immutable;
Bar->meta->make_immutable;
TODO: {
    local $TODO = 'some immutable cases are not handled yet';
    # for now, catch errors
    is(exception { do_tests }, undef, 'tests do not die');

    is(Test::More->builder->current_test, 28, 'if we got here, we can declare victory!');
}

done_testing;

