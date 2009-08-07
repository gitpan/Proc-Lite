use strict;
use warnings;

BEGIN {
  die "Windows is currently unsupported\n"
    if $^O eq 'MSWin32';
}

use inc::Module::Install;

name 'Proc-Lite';
all_from 'lib/Proc/Lite.pm';
license 'MIT';

requires 'Carp'       => '0.00';
requires 'Errno'      => '0.00';
requires 'IO::Pipe'   => '0.00';
requires 'IO::Select' => '0.00';

test_requires 'Test::More' => '0.00';

auto_install;
WriteAll;
