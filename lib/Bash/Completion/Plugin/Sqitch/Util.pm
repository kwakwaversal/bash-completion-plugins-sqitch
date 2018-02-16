package Bash::Completion::Plugin::Sqitch::Util;

use Moo;
use List::Util;
use Types::Standard qw/ArrayRef HashRef Str/;

has args => (
    is      => 'lazy',
    isa     => ArrayRef,
    builder => sub {
        [$_[0]->request->args]
    }
);

has command => (
    is  => 'lazy',
    isa => Str,
    builder => sub {
        $_[0]->args->[0] // ''
    }
);

has command_options => (
    is      => 'ro',
    isa     => HashRef,
    default => sub { {} }
);


# Ref['Bash::Completion::Request']
has request => (
    is       => 'ro',
    required => 1,
);

has stripped_args => (
    is      => 'lazy',
    isa     => ArrayRef,
    builder => sub {
        my $self = shift;
        my $index = 0;
        $index++ if $self->command;
        $index++ if $self->subcommand;
        my @args = $self->request->args;
        return [splice(@args, $index)];
    }
);

has subcommand => (
    is => 'lazy',
    isa => Str,
    builder => sub {
        $_[0]->args->[1] // ''
    }
);

sub candidates {
    my $self = shift;

    # Default the candidates to the available subcommands
    my $candidates = [keys %{$self->command_options}];

    if (exists $self->command_options->{$self->subcommand}) {
        if ($self->request->word =~ m/^db:/) {
            $candidates = [qw!db:x//foo db:x//haha!];
        }
        else {
            $candidates = $self->command_options->{$self->subcommand};
        }
    }

    return _remove_list_from_list($candidates, $self->stripped_args);
}

sub _remove_list_from_list {
    my ($lista, $listb) = @_;
    my $in = sub { List::Util::any { $_ eq $_[0] } @$listb };
    return [grep { !$in->($_) } @$lista];
}

1;
