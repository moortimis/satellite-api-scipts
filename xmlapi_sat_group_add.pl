#!/usr/bin/perl -w

use strict;
use Frontier::Client;
use Data::Dumper;

############################################################################
#   Defining an XMLRPC session.                                            #
############################################################################

# Define the host first.  This will be the FQDN of your satellite system.
my $HOST       = 'vicpsat01.reecenet.org';

# Now we create the client object that will be used throughout the session.

my $client = new Frontier::Client(url => "http://$HOST/rpc/api");

# Next, we execute a login call, which returns a session identifier that will
# be passed in all subsequent calls.  The syntax of this call is described at:
#
#   http://$HOST/rpc/api/auth/login/

my $session = $client->call('auth.login', 'apiuser', 'apiuser!');

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
	
	# deterine server enviroment (DEV,TEST,UAT,PROD)
	my $env = substr $system->{name}, 3, 1;
	my $rc =0;

	# Let keep track of the flags
	my @svrflags = ();
	
	# assign Group ID from table above
	if ($env eq 'd'){
		push(@svrflags,141);
		print $system->{name} . ' will be added to GROUP(141)' . "\n";
        }elsif($env eq 'p'){
		push(@svrflags,145);
		print $system->{name} . ' will be added to GROUP(145)' . "\n";
	}else{
		push(@svrflags,161);
                print $system->{name} . ' will be added to GROUP(145)' . "\n";
	}

	# Lets se what else we can find out about the box's
	if($system->{name} =~ m/web/gi){
		push(@svrflags,202);
		print $system->{name} . ' will be added to GROUP(202)' . "\n";
	}

	if($system->{name} =~ m/dmz/gi){
		push(@svrflags,204);
		print $system->{name} . ' will be added to GROUP(204)' . "\n";
	}

	if($system->{name} =~ m/gas/gi){
		push(@svrflags,203);
		print $system->{name} . ' will be added to GROUP(203)' . "\n";
	}

	if($system->{name} =~ m/jb/gi){
		push(@svrflags,201);
		print $system->{name} . ' will be added to GROUP(201)' . "\n";
        }

	foreach my $value (@svrflags){

		my $rc = $client->call('system.setGroupMembership',$session,$system->{id},$value,1);

                if($rc == 1){
			print $system->{name} . " has been added to Group($value)\n";
                }

	}

}
$client->call('auth.logout', $session);



