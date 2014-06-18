requires 'parent';
requires 'perl', '5.008005';

on configure => sub {
    requires 'Module::Build::Tiny', '0.035';
};

on test => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Deep';
};

on develop => sub {
    requires 'Test::Perl::Critic';
};

