#! /usr/bin/perl5 -w

use strict;

sub process_dir {
	my $dirname = $_[0];
	my $filename;
	
	opendir my $DIR, $dirname or die "Could not open $dirname\n";

	while ($filename = readdir($DIR)) {
		next if $filename eq "." || $filename eq "..";
		if ((-d "$dirname/$filename") ) {
			print "Installing AMAI to dir $dirname\\$filename\n";
			process_dir ("$dirname\\$filename");
		} elsif ($filename =~ m/\.w3m$/ || $filename =~ m/\.w3x$/ ) { 
			print "Installing AMAI to $dirname/$filename\n";
			system "MPQEditor htsize \"$dirname/$filename\" 64";
			system "MPQEditor a \"$dirname/$filename\" Scripts\\TFT\\*.ai Scripts";
			system "MPQEditor a \"$dirname/$filename\" Scripts\\Blizzard.j Scripts\\Blizzard.j";
			system "MPQEditor f \"$dirname/$filename\""
		}
	}

	closedir($DIR);
}

process_dir ($ARGV[0]);