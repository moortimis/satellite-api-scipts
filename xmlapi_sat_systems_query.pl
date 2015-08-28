#!/usr/bin/perl -w

use strict;
use Frontier::Client;
use Data::Dumper;

############################################################################
#   Defining an XMLRPC session.                                            #
############################################################################

# Define the host first.  This will be the FQDN of your satellite system.
my $HOST       = '<hostname>';

# Now we create the client object that will be used throughout the session.

my $client = new Frontier::Client(url => "http://$HOST/rpc/api");

# Next, we execute a login call, which returns a session identifier that will
# be passed in all subsequent calls.  The syntax of this call is described at:
#
#   http://$HOST/rpc/api/auth/login/

my $session = $client->call('auth.login', '<api-user>', 'api-user!');

############################################################################
#   System calls.                                                          #
############################################################################

# This next call returns a list of systems available to the user.  The 
# syntax of this call is described at:
#
#   http://$HOST/rpc/api/system/list_user_systems/
#
# In the code snippet below, we dump data about our systems, and we 
# capture the ID of the first system we find for future operations.
### GROUP ID's
# 141 > REECE-DEVELOPMENT
# 145 > REECE-PRODUCTION
# 161 > REECE-NON-PRODUCTION

my $systems = $client->call('system.listSystems', $session);
foreach my $system (@$systems) {
	#print $system->{name} . "\n";
	my @hostname = split(/\./,$system->{name});
	print $hostname[0] . "\n";
}
$client->call('auth.logout', $session);



