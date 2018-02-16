#!/usr/bin/env perl

use strict;
use warnings;
use aliased 'Bash::Completion::Plugin::Sqitch::Util';
use aliased 'Bash::Completion::Request';
use Test2::Bundle::More;
use Test2::Tools::Compare qw/bag end etc hash item field is/;

# ABSTRACT: testing extended request class for sqitch

subtest empty_env_vars  => \&test_empty_env_vars;
subtest candidates      => \&test_candidates;
subtest command_only    => \&test_command_only;
subtest subcommand_only => \&test_subcommand_only;

sub test_empty_env_vars {
    # naughty - suppressing uninitialized warnings in Bash::Completion::Request
    local $SIG{__WARN__} = sub{ };

    my $rx = Util->new(request => Request->new());
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
    my $rx = _get_rx({line => 'sqitch', command_options => $cmd_opts});
    is $rx->candidates => [keys %$cmd_opts];
    is $rx->stripped_args => [], 'removed command from args';

    # A partial subcommand returns all subcommands
    $rx = _get_rx({line => 'sqitch ver', command_options => $cmd_opts});
    is $rx->candidates => [keys %$cmd_opts];
    is $rx->stripped_args => [], 'removed partial subcommand from args';

    # A complete subcommand returns all subcommand options
    $rx = _get_rx({line => 'sqitch verify', command_options => $cmd_opts});
    is $rx->candidates => $cmd_opts->{verify};

    # A subcommand options is removed from subcommand candidates
    $rx = _get_rx({line => 'sqitch verify --target', command_options => $cmd_opts});
    is (
        $rx->candidates,
        bag {
            item '--to-change';
            item '--set';
            end;
        }
    );
}

sub test_command_only {
    my $rx = _get_rx({line => 'sqitch'});
    is $rx->command    => 'sqitch';
    is $rx->subcommand => '';
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

    return Util->new(request => Request->new(), %{$opts});
}

done_testing;
