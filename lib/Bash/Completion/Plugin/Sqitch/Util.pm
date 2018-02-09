package Bash::Completion::Plugin::Sqitch::Util;

use Moo;
use Types::Standard qw/ArrayRef HashRef Str/;

has args => (
    is      => 'lazy',
    isa     => ArrayRef,
    builder => sub {
        [$_[0]->request->args];
    }
);

has command => (
    is  => 'lazy',
    isa => Str,
    builder => sub {
        $_[0]->args->[0] // ''
    }
);

has request => (
    is       => 'ro',
    # isa      => Ref['Bash::Completion::Request'],
    required => 1,
);

has subcommand => (
    is => 'lazy',
    isa => Str,
    builder => sub {
        $_[0]->args->[1] // ''
    }
);

has subcommand_options => (
    is      => 'ro',
    isa     => HashRef,
    default => sub { {} }
);

sub candidates {
    my $self = shift;
    return unless $self->subcommand;

    if (exists $self->subcommand_options->{$self->subcommand}) {
        return $self->subcommand_options->{$self->subcommand};
    }
}

1;
