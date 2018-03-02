# NAME

Bash::Completion::Plugins::Sqitch - bash completion for Sqitch

# SYNOPSIS

    # Will install App::Sqitch and Bash::Completion if they aren't installed
    $ cpanm Bash::Completion::Plugins::Sqitch;

    # Add newly created Sqitch Bash::Completion plugin to current session. (See
    # "SETTING UP AUTO-COMPLETE" to permanently add completions for `sqitch`.)
    $ eval "$(bash-complete setup)"

    # Magical tab completion for all things Sqitch! (well, kind of - see below)
    $ sqitch <tab><tab>

# DESCRIPTION

[Bash::Completion::Plugins::Sqitch](https://metacpan.org/pod/Bash::Completion::Plugins::Sqitch) is a [Bash::Completion](https://metacpan.org/pod/Bash::Completion) plugin for
[App::Sqitch](https://metacpan.org/pod/App::Sqitch).

The functionality of this plugin is heavily dependent and modelled around the
design of [App::Sqitch](https://metacpan.org/pod/App::Sqitch) version `0.9996`. As long as [App::Sqitch](https://metacpan.org/pod/App::Sqitch) doesn't
drastically change, things should be fine. I cannot guarantee that it will work
for older versions of [App::Sqitch](https://metacpan.org/pod/App::Sqitch), so update to the latest version if you
have any problems.

Currently this completion module only returns completions for subcommands
(e.g., deploy, verify, revert etc.). It does _not_ return `sqitch [options]` yet, nor sub-subcommands - I will add them in newer versions.

It works by using the `App::Sqitch::Command::` namespace to list the `sqitch`
subcommands, and takes advantage of each subcommand providing the
[Getopt::Long](https://metacpan.org/pod/Getopt::Long) options as accessible methods. As such, this means that the
auto-complete candidates should track new subcommands and options that are
added or deprecated. Once downside to this is that some of the options that are
included in the auto-complete candidate list aren't part of the official `$subcommand --help` for a particular subcommand.

N.B., Sqitch auto-completion works best if you're in the sqitch folder (the one
with the `sqitch.conf` and `sqitch.plan` in it - which is generally how I use
it all the time anyway.

# EXTRAS

Extended auto-complete options are available in certain circumstances.

## --target

    $ sqitch target add dev db:pg://username:password@localhost/somedatabase

    # sqitch.conf
    ...
    [target "dev"]
        uri = db:pg://username:password@localhost/somedatabase
    ...

    $ sqitch verify --target <tab><tab>

When the option `--target` is recognised anywhere in the list of options, the
`sqitch.conf` file is read, and any `targets` are returned as candidates.

N.B., this extra requires that your `cwd` is the sqitch directory with the
`sqitch.plan` file.

## db:pg

    # .bashrc or .bash_profile
    #
    # auto-complete won't work for the [database] with the default
    # COMP_WORDBREAKS, as such I globally remove `:` and `=`. This isn't for
    # everyone - but this extra will *not* work without doing it.
    export COMP_WORDBREAKS=${COMP_WORDBREAKS/:/}
    export COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}

    $ sqitch status db:pg:<tab><tab>

I'm hoping this is more useful in the future because there is a bug with most
of the useful sqitch subcommands in that they don't honour the `service`
paramenter in the `[database]` string. It works for status though!

N.B., this currently only works for the `pg` engine as it uses
[Pg::ServiceFile](https://metacpan.org/pod/Pg::ServiceFile) to autocomplete the `database` based on the service names.

# SETTING UP AUTO-COMPLETE

The instructions for setting up [Bash::Completion](https://metacpan.org/pod/Bash::Completion) don't work under all Perl
environments - particularly [plenv](https://github.com/tokuhirom/plenv). The
instructions below should work.

## bash

    # Stick this into your .bashrc or .bash_profile
    eval "$(bash-complete setup)"

## zsh

    # Stick this into your .zshrc
    autoload -U bashcompinit
    bashcompinit
    eval "$(bash-complete setup)"

# AUTHOR

Paul Williams <kwakwa@cpan.org>

# COPYRIGHT

Copyright 2018- Paul Williams

# LICENSE

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

# SEE ALSO

[App::Sqitch](https://metacpan.org/pod/App::Sqitch),
[Bash::Completion](https://metacpan.org/pod/Bash::Completion).
