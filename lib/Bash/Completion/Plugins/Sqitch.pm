package Bash::Completion::Plugins::Sqitch;

use strict;
use warnings;
use parent 'Bash::Completion::Plugin';
use Bash::Completion::Utils qw{command_in_path};
use Bash::Completion::RequestX::Sqitch;

our $VERSION = '0.01';

sub complete {
    my ($self, $r) = @_;

    # this is the word bash is trying to complete
    my $word = $r->word;

    # extended request for the sqitch command
    my $rx = Bash::Completion::RequestX::Sqitch->new(request => $r);

    $r->candidates(prefix_match($word, @{$rx->candidates}));
}

# sub generate_bash_setup {
#     return q{complete -C 'bash-complete complete Sqitch -- ' sqitch};
# }

# sub generate_bash_setup { return [qw(nospace)] }

# Bash::Completion::Utils version of prefix_match is broken in that it doesn't
# quote the meta characters in variables used in regular expressions.
sub prefix_match {
    my $prefix = shift;

    return grep { /^\Q$prefix\E/ } @_;
}

sub should_activate {
    return [grep { command_in_path($_) } ('sqitch')];
}

1;

__END__

=encoding utf-8

=head1 NAME

Bash::Completion::Plugins::Sqitch - based completion for Sqitch

=head1 SYNOPSIS

    # will install App::Sqitch if it is not already installed
    $ cpanm Bash::Completion::Plugins::Sqitch;

    # Add newly created Sqitch Bash::Completion plugin to session
    $ eval "$(bash-complete setup)"

    # Magical tab completion for all things Sqitch!
    $ sqitch <tab><tab>

=head1 DESCRIPTION

L<Bash::Completion::Plugins::Sqitch> is a L<Bash::Completion> plugin for
L<App::Sqitch>.

The functionality of this plugin is heavily dependent and modelled around the
design (C<0.9996>) of L<App::Sqitch>. As longs as L<App::Sqitch> doesn't
drastically change, things should be fine.

e.g., It uses the C<App::Sqitch::Command> namespace to list the sqitch
commands, and takes advantage of each command providing the getopt options in
an accessible manner. As such, this means that the autocomplete should grow
and shrink when new commands and options are added or deprecated.

=head1 AUTHOR

Paul Williams E<lt>kwakwa@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2018- Paul Williams

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<App::Sqitch>,
L<Bash::Completion>.

=cut
