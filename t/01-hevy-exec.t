#!perl -T

use Test::More tests => 9;

use Proc::Hevy;


delete @ENV{ keys %ENV };

my ( $perl ) = $^X =~ /^(.*)\z/;


fatal_exec( 'odd parameters',              qr/^Odd number of parameters/,                                     fake => );
fatal_exec( 'missing parameters: command', qr/^command: Required parameter not defined/,                      fake => 'fake' );
fatal_exec( 'invalid parameters: command', qr/^command: Must be an ARRAY reference/,                          command => { fake => 'fake' } );
fatal_exec( 'invalid parameters: stdin',   qr/^stdin: Must be one of ARRAY, CODE or GLOB reference/,          command => 'fake', stdin  => { } );
fatal_exec( 'invalid parameters: stdout',  qr/^stdout: Must be one of ARRAY, CODE, GLOB or SCALAR reference/, command => 'fake', stdout => { } );
fatal_exec( 'invalid parameters: stderr',  qr/^stderr: Must be one of ARRAY, CODE, GLOB or SCALAR reference/, command => 'fake', stderr => { } );

ok_exec( 'exec: CODE reference',  sub { } );
ok_exec( 'exec: scalar',          "$perl -e 1" );
ok_exec( 'exec: ARRAY reference', [ $perl, qw( -e 1 ) ] );


sub fatal_exec {
  my ( $name, $re, @args ) = @_;

  eval { Proc::Hevy->exec( @args ) };
  like( $@, $re, $name );
}

sub ok_exec {
  my ( $name, $command ) = @_;

  my $status = Proc::Hevy->exec(
    command => $command,
    stdout  => \my $stdout,
    stderr  => \my $stderr,
  );

  ok( $status == 0, $name )
    or do {
      diag( '  status: ' . $status );
      diag( '  stdout: ' . ( defined $stdout ? $stdout : '' ) );
      diag( '  stderr: ' . ( defined $stderr ? $stderr : '' ) );
    }
  ;
}
