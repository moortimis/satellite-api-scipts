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

my $difPkgList = $client->call('channel.software.listAllPackages', $session, 'rhel-x86_64-server-6');
my $srcPkgList = $client->call('channel.software.listAllPackages', $session, 'reece-soe-rhel64-x86_64');

foreach my $package ($srcPkgList){
	printf("%25s %02d.%02d%02d\n",$package->{name},$package->{version});

}

############################################################################
# 	SUB-ROUTINES                                                       #
############################################################################
sub getOS{
	my $svr = shift;
	my $s 	= $client->call('auth.login', 'apiuser', 'apiuser!');
	my $sys = $client->call('system.getDetails', $session,$svr);
	$client->call('auth.logout', $s);
	return($sys->{release});
}
sub getSubBaseChan{
	my $svr = shift;
        my $s   = $client->call('auth.login', 'apiuser', 'apiuser!');
        my $sys = $client->call('system.listSubscribableChildChannels', $session,$svr);
        #printf("%12s %32s\n",$sys->{release},$sys->{base_entitlement});
        print Dumper($sys);
	$client->call('auth.logout', $s);
}
sub checkBaseChannel{
	my $svr = shift;
        my $s   = $client->call('auth.login', 'apiuser', 'apiuser!');
        my $sys = $client->call('system.listSubscribableChildChannels', $session,$svr);
	my $supplementary = 0;
	my $optional 	  = 0;
	my $rhntools 	  = 0;
	my $vmware 	  = 0;

	foreach my $channel (@$sys){
		$supplementary ++ if $channel->{label} eq 'reece-rhel-x86_64-server-supplementary-6';
		$optional ++ if $channel->{label} eq 'reece-soe-rhel-server-optional-6.3-x86_64';
		$rhntools ++ if $channel->{label} eq 'reece-soe-rhn-tools-rhel-6.3-x86_64';
		$vmware ++ if $channel->{label} eq 'reece-soe-vmware-rhel-6-x86_64';
	}
	printf("%48s\n",'reece-rhel-x86_64-server-supplementary-6 is missing') unless $supplementary;
	printf("%48s\n",'reece-soe-rhel-server-optional-6.3-x86_64 is missing') unless $optional;
	printf("%48s\n",'reece-soe-rhn-tools-rhel-6.3-x86_64 is missing') unless $rhntools;
	printf("%48s\n",'reece-soe-vmware-rhel-6-x86_64 is missing') unless $vmware;
	$client->call('auth.logout', $s);
}







