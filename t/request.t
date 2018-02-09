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
subtest command         => \&test_command;
subtest subcommand      => \&test_subcommand;

sub test_empty_env_vars {
    # naughty - suppressing uninitialized warnings in Bash::Completion::Request
    local $SIG{__WARN__} = sub{ };

    my $rx = Util->new(request => Request->new());
    is $rx->command    => '';
    is $rx->subcommand => '';
}

sub test_candidates {
    my $cmd_opts = {
        deploy => [],
        status => [],
        verify => [qw/--target --from-change --to-change --set/]
    };

    my $rx = _get_rx({line => 'sqitch verify', subcommand_options => $cmd_opts});
    is (
        $rx->candidates,
        bag {
        }
    );

    my $rx = _get_rx({line => 'sqitch verify', subcommand_options => $cmd_opts});
    is (
        $rx->candidates,
        bag {
            item '--target';
            item '--set';
            etc;
        }
    );
}

sub test_command {
    my $rx = _get_rx({line => 'sqitch'});
    is $rx->command    => 'sqitch';
    is $rx->subcommand => '';
}

sub test_subcommand {
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
