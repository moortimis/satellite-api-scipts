#!/usr/bin/perl
use Frontier::Client;

my $HOST = 'satellite.example.com';
my $user = 'username';
my $pass = 'password';

my $client = new Frontier::Client(url => "http://$HOST/rpc/api");
my $session = $client->call('auth.login',$user, $pass);

my $systems = $client->call('system.listUserSystems', $session);
foreach my $system (@$systems) {
   print $system->{'name'}."\n";
}
$client->call('auth.logout', $session);
