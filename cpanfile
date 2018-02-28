requires 'App::Sqitch';
requires 'Bash::Completion';
requires 'Pg::ServiceFile';

on test => sub {
    requires 'aliased';
    requires 'Data::Section';
    requires 'Test::More', '0.96';
    requires 'Test2::Tools::Compare';
};
