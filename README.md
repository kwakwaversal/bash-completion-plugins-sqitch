# NAME

Bash::Completion::Plugins::Sqitch - bash completion for Sqitch

# SYNOPSIS

    # Will install App::Sqitch if it is not already installed
    $ cpanm Bash::Completion::Plugins::Sqitch;

    # Add newly created Sqitch Bash::Completion plugin to session
    $ eval "$(bash-complete setup)"

    # Magical tab completion for all things Sqitch!
    $ sqitch <tab><tab>

# DESCRIPTION

[Bash::Completion::Plugins::Sqitch](https://metacpan.org/pod/Bash::Completion::Plugins::Sqitch) is a [Bash::Completion](https://metacpan.org/pod/Bash::Completion) plugin for
[App::Sqitch](https://metacpan.org/pod/App::Sqitch).

The functionality of this plugin is heavily dependent and modelled around the
design (`0.9996`) of [App::Sqitch](https://metacpan.org/pod/App::Sqitch). As longs as [App::Sqitch](https://metacpan.org/pod/App::Sqitch) doesn't
drastically change, things should be fine.

e.g., It uses the `App::Sqitch::Command` namespace to list the sqitch
commands, and takes advantage of each command providing the getopt options in
an accessible manner. As such, this means that the autocomplete should grow
and shrink when new commands and options are added or deprecated.

# AUTHOR

Paul Williams <kwakwa@cpan.org>

# COPYRIGHT

Copyright 2018- Paul Williams

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# SEE ALSO

[App::Sqitch](https://metacpan.org/pod/App::Sqitch),
[Bash::Completion](https://metacpan.org/pod/Bash::Completion).
