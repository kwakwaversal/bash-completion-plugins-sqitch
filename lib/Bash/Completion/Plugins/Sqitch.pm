package Bash::Completion::Plugins::Sqitch;

use strict;
use warnings;
use parent 'Bash::Completion::Plugin';
use Bash::Completion::Utils qw{command_in_path prefix_match};
use Bash::Completion::Plugin::Sqitch::Util;

our $VERSION = '0.01';

my $cmd_opts = {
    deploy => [],
    status => [],
    verify => [qw/--target --from-change --to-change --set/]
};

sub complete {
    my ($self, $r) = @_;

    # this is the word bash is trying to complete
    my $word = $r->word;

    # extended request for the sqitch command
    my $rx = Bash::Completion::Plugin::Sqitch::Util->new(
        request         => $r,
        command_options => $cmd_opts
    );

    $r->candidates(prefix_match($word, @{$rx->candidates}));
}

sub generate_bash_setup {
  return q{complete -C 'bash-complete complete Sqitch -- '  sqitch}
}
# sub generate_bash_setup { return [qw(nospace)] }

sub should_activate {
    return [grep { command_in_path($_) } ('sqitch')];
}

1;

__END__

=encoding utf-8

=head1 NAME

Bash::Completion::Plugins::sqitch - Blah blah blah

=head1 SYNOPSIS

  use Bash::Completion::Plugins::sqitch;

=head1 DESCRIPTION

Bash::Completion::Plugins::sqitch is

=head1 AUTHOR

Paul Williams E<lt>kwakwa@cpan.orgE<gt>

=head1 COPYRIGHT

Copyright 2018- Paul Williams

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
