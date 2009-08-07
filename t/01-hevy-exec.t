#!perl -T

use Test::More tests => 9;

use Proc::Hevy;


$ENV{PATH} = '';

my ( $perl ) = $^X =~ /^(.*)\z/;


eval { Proc::Hevy->exec( fake => ) };
like( $@, qr/^Odd number of parameters/, 'odd parameters' );

eval { Proc::Hevy->exec( fake => 'fake' ) };
like( $@, qr/^command: Required parameter not defined/, 'missing parameters: command' );

eval { Proc::Hevy->exec( command => { fake => 'fake' } ) };
like( $@, qr/^command: Must be an ARRAY reference/, 'invalid parameters: command' );

eval { Proc::Hevy->exec( command => 'fake', stdin  => { } ) };
like( $@, qr/^stdin: Must be one of ARRAY, CODE or GLOB reference/, 'invalid parameters: stdin' );

eval { Proc::Hevy->exec( command => 'fake', stdout => { } ) };
like( $@, qr/^stdout: Must be one of ARRAY, CODE, GLOB or SCALAR reference/, 'invalid parameters: stdout' );

eval { Proc::Hevy->exec( command => 'fake', stderr => { } ) };
like( $@, qr/^stderr: Must be one of ARRAY, CODE, GLOB or SCALAR reference/, 'invalid parameters: stderr' );

{
  my $status = Proc::Hevy->exec( command => sub { } );
  ok( $status == 0, 'exec: CODE reference' );
}

{
  my $status = Proc::Hevy->exec( command => "$perl -e 1" );
  ok( $status == 0, 'exec: scalar' );
}

{
  my $status = Proc::Hevy->exec( command => [ $perl, qw( -e 1 ) ] );
  ok( $status == 0, 'exec: ARRAY reference' );
}
