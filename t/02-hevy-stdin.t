#!perl -T

use Test::More tests => 8;

use Proc::Hevy;


my @values = ( 2 .. 4 );

{
  my $stdin = join "\n", @values;
  my $status = Proc::Hevy->exec( command => \&command, stdin => $stdin );
  my ( $es, $ec ) = ( ( $status & 0x00ff ), ( $status >> 8 ) );
  ok( $es == 0, 'stdin: ARRAY reference' );
  ok( $ec == 9, 'stdin: ARRAY reference' );
}

{
  my $stdin = [ @values ];
  my $status = Proc::Hevy->exec( command => \&command, stdin => $stdin );
  my ( $es, $ec ) = ( ( $status & 0x00ff ), ( $status >> 8 ) );
  ok( $es == 0, 'stdin: ARRAY reference' );
  ok( $ec == 9, 'stdin: ARRAY reference' );
}

{
  my $stdin = do { my @stdin = @values; sub { pop @stdin } };
  my $status = Proc::Hevy->exec( command => \&command, stdin => $stdin );
  my ( $es, $ec ) = ( ( $status & 0x00ff ), ( $status >> 8 ) );
  ok( $es == 0, 'stdin: CODE reference' );
  ok( $ec == 9, 'stdin: CODE reference' );
}

# FIXME: add GLOB tests

{
  local $\ = "\0";
  my $stdin = \@values;
  my $status = Proc::Hevy->exec( command => [ \&command, $\ ], stdin => $stdin );
  my ( $es, $ec ) = ( ( $status & 0x00ff ), ( $status >> 8 ) );
  ok( $es == 0, 'stdin: output record seperator' );
  ok( $ec == 9, 'stdin: output record seperator' );
}


sub command {
  my ( $irs ) = @_;

  $/ = $irs
    if defined $irs;

  my $sum = 0;
  while( <> ) {
    chomp;
    $sum += $_;
  }

  exit $sum;
}
