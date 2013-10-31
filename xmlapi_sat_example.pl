#!/usr/bin/perl -w

use strict;
use Frontier::Client;
use Data::Dumper;

############################################################################
# This is a sample script for use of the experimental RHN Management APIs. #
# The API is currently available using XMLRPC only, which is described in  #
# depth at:                                                                #
#                                                                          #
# http://www.xmlrpc.com/                                                   #
#                                                                          #
# We use the Frontier modules, available from:                             #
#                                                                          #
# http://theoryx5.uwinnipeg.ca/mod_perl/cpan-search?dist=Frontier-RPC      #
#                                                                          #
############################################################################


############################################################################
#   Defining an XMLRPC session.                                            #
############################################################################

# Define the host first.  This will be the FQDN of your satellite system.
my $HOST = 'satellite.server.yourdomain.com';

# Now we create the client object that will be used throughout the session.

my $client = new Frontier::Client(url => "http://$HOST/rpc/api");

# Next, we execute a login call, which returns a session identifier that will
# be passed in all subsequent calls.  The syntax of this call is described at:
#
#   http://$HOST/rpc/api/auth/login/

my $session = $client->call('auth.login', 'username', 'password');

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

my $systems = $client->call('system.list_user_systems', $session);
for my $system (@$systems) {
  print Dumper($system);
}
print "\n\nCapturing ID of system @$systems[0]->{name}\n\n";
my $systemid = @$systems[0]->{id};

# This next call returns a list of packages present on this system.  The
# syntax of this call is described at:
#
#   http://$HOST/rpc/api/system/list_packages/
#
# This will probably be a pretty long list.

my $packages = $client->call('system.list_packages', $session, $systemid);
for my $package (@$packages) {
  print Dumper($package);
}

# Additional system calls are described at:
#   http://$HOST/rpc/api/system/
