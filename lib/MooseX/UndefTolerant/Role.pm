package MooseX::UndefTolerant::Role;
BEGIN {
  $MooseX::UndefTolerant::Role::VERSION = '0.12';
}
use Moose::Role;

sub composition_class_roles { 'MooseX::UndefTolerant::Composite' }

no Moose::Role;

1;
