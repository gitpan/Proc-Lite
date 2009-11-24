#!perl -T

use strict;
use warnings;

use Test::More tests => 4;
use Proc::Lite;

close STDIN  or die "STDIN: close: $!\n";
close STDOUT or die "STDOUT: close: $!\n";
close STDERR or die "STDERR: close: $!\n";

open STDIN,  '<', '/dev/null' or die "STDIN: open: $!\n";
open STDOUT, '>', '/dev/null' or die "STDOUT: open: $!\n";
open STDERR, '>', '/dev/null' or die "STDERR: open: $!\n";

my $o = Proc::Lite->exec( sub {
  my $i = Proc::Lite->exec( sub {
    print STDOUT 'inner: STDOUT', "\n";
    print STDERR 'inner: STDERR', "\n";
  } );

  print STDOUT 'outer: ', $_, "\n" for $i->stdout;
  print STDERR 'outer: ', $_, "\n" for $i->stderr;
} );

ok( @{ $o->stdout } == 1, 'stdout' );
is( $o->stdout->[0], 'outer: inner: STDOUT', 'stdout: value' );

ok( @{ $o->stderr } == 1, 'stderr' );
is( $o->stderr->[0], 'outer: inner: STDERR', 'stderr: value' );
