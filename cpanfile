requires 'Bash::Completion';

on test => sub {
    requires 'Test::More', '0.96';
    requires 'Test2::Tools::Compare';
};
