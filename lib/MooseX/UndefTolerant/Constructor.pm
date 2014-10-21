package MooseX::UndefTolerant::Constructor;
use Moose::Role;

if ( $Moose::VERSION < 1.9900 ) {
        around('_generate_slot_initializer', sub {
                my $orig = shift;
                my $self = shift;

                # note the key in the params may not match the attr name.
                my $key_name = $self->_attributes->[$_[0]]->init_arg;

                # insert a line of code at the start of the initializer,
                # clearing the param if it's undefined.

                if (defined $key_name) {
                        my $tolerant_code = 
                             qq# delete \$params->{'$key_name'} unless # . 
                             qq# exists \$params->{'$key_name'} && defined \$params->{'$key_name'};\n#;

                        return $tolerant_code . $self->$orig(@_);
                }
                else {
                        return $self->$orig(@_);
                }
        });
}

no Moose::Role;

1;
