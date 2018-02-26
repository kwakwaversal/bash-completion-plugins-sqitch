#!/usr/bin/env perl

use strict;
use warnings;
use aliased 'Bash::Completion::Request';
use aliased 'Bash::Completion::RequestX::Sqitch';
use Test2::Bundle::More;
use Test2::Tools::Compare qw/bag end etc hash item field is/;

# ABSTRACT: testing bash completion extended request class for Sqitch

subtest empty_env_vars  => \&test_empty_env_vars;
subtest candidates      => \&test_candidates;
subtest commands        => \&test_commands;
subtest command_only    => \&test_command_only;
subtest previous_arg    => \&test_previous_arg;
subtest subcommand_only => \&test_subcommand_only;

sub test_empty_env_vars {
    # naughty - suppressing uninitialized warnings in Bash::Completion::Request
    local $SIG{__WARN__} = sub{ };

    my $rx = Sqitch->new(request => Request->new());
    is $rx->command    => '';
    is $rx->subcommand => '';
    is $rx->args       => [];
}

sub test_candidates {
    my $cmd_opts = {
        deploy => [],
        status => [],
        verify => [qw/--target --to-change --set/]
    };

    # A command with no subcommand returns all subcommands
    my $rx = _get_rx({line => 'sqitch'});
    is (
        $rx->candidates,
        bag {
            item 'deploy';
            item 'status';
            item 'verify';
            etc;
        }
    );
    is $rx->stripped_args => [], 'removed command from args';

    # A partial subcommand returns all subcommands, but will be further
    # filtered by bash autocomplete.
    $rx = _get_rx({line => 'sqitch ver'});
    is (
        $rx->candidates,
        bag {
            item 'deploy';
            item 'status';
            item 'verify';
            etc;
        }
    );
    is $rx->stripped_args => [], 'removed partial subcommand from args';

    # # A complete subcommand returns all subcommand options
    $rx = _get_rx({line => 'sqitch verify'});
    is (
        $rx->candidates,
        bag {
            item '--target';
            item '--to-change';
            item '--set';
            etc;
        }
    );
    # is $rx->candidates => $cmd_opts->{verify};
    is $rx->stripped_args => [], 'removed command and subcommand';

    # # A used subcommand option is removed from subcommand candidates
    $rx = _get_rx({line => 'sqitch verify --set'});
    ok !(grep {m/--set/} @{$rx->candidates});
    is $rx->stripped_args => ['--set'], 'removed command and subcommand';
}

sub test_commands {
    my $rx = _get_rx({line => 'sqitch'});
    is (
        $rx->sqitch_commands,
        bag {
            item 'add';
            item 'deploy';
            item 'upgrade';
            item 'verify';
            etc;
        }
    );
}

sub test_command_only {
    my $rx = _get_rx({line => 'sqitch'});
    is $rx->command    => 'sqitch';
    is $rx->subcommand => '';
}

sub test_previous_arg {
    my $rx = _get_rx({line => 'sqitch verify'});
    is $rx->previous_arg => '', 'commands are not arguments';

    $rx = _get_rx({line => 'sqitch verify --target'});
    is $rx->previous_arg => '--target';
}

sub test_subcommand_only {
    my $rx = _get_rx({line => 'sqitch verify'});
    is $rx->command    => 'sqitch';
    is $rx->subcommand => 'verify';
}

sub _get_rx {
    my $opts = shift;

    local $ENV{COMP_POINT} = delete $opts->{point} // length($opts->{line}) + 1;
    local $ENV{COMP_LINE}  = delete $opts->{line};

    return Sqitch->new(request => Request->new(), %{$opts});
}

done_testing;
