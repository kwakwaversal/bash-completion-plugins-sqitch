requires 'App::Sqitch';
requires 'Bash::Completion';

# for Pg::Service
requires 'Config::INI';
requires 'Path::Tiny';
requires 'Types::Path::Tiny';

on test => sub {
    requires 'aliased';
    requires 'Data::Section';
    requires 'Test::More', '0.96';
    requires 'Test2::Tools::Compare';
};
