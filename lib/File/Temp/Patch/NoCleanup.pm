package File::Temp::Patch::NoCleanup;

# AUTHORITY
# DATE
# DIST
# VERSION

use 5.010001;
use strict;
use warnings;

use Module::Patch qw();
use base qw(Module::Patch);

my $wrap_tempdir = sub {
    my $ctx = shift;
    my $orig = $ctx->{orig};

    my ($maybe_template, $args) = File::Temp::_parse_args(@_);
    $args->{CLEANUP} = 0;
    my $dir = $orig->(@$maybe_template, %$args);
    warn "DEBUG: tempdir(...) = $dir\n";
    $dir;
};

sub patch_data {
    return {
        v => 3,
        config => {
        },
        patches => [
            {
                action      => 'wrap',
                mod_version => qr/^0\.*/,
                sub_name    => 'tempdir',
                code        => $wrap_tempdir,
            },
        ],
    };
}

1;
# ABSTRACT: Disable File::Temp::tempdir's automatic cleanup (CLEANUP => 1)

=for Pod::Coverage ^(patch_data)$

=head1 SYNOPSIS

From the command-line:

 % PERL5OPT=-MFile::Temp::Patch::NoCleanup yourscript.pl ...

Now you can inspect temporary directory after the script ends.


=head1 DESCRIPTION

This module patches L<File::Temp> to disable automatic cleanup of temporary
directories. In addition, it prints the created temporary directory to stdout.
Useful for debugging.


=head1 SEE ALSO

L<File::Temp>

=cut
