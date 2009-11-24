#!perl -T

use strict;
use warnings;

use Test::More tests => 4;

BEGIN {
  use_ok( 'Proc::Lite' );
  use_ok( 'Proc::Hevy' );
  use_ok( 'Proc::Hevy::Reader' );
  use_ok( 'Proc::Hevy::Writer' );
}

diag( "Testing Proc::Lite $Proc::Lite::VERSION, Perl $], $^X" );
