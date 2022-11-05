#! /usr/bin/perl5 -w

use strict;

sub process_dir {
	my $dirname = $_[0];
  my $commander = $_[1];
	my $filename;
	
	opendir my $DIR, $dirname or die "Could not open $dirname\n";

	while ($filename = readdir($DIR)) {
		next if $filename eq "." || $filename eq "..";
		if ((-d "$dirname/$filename") ) {
			print "Installing AMAI to dir $dirname\\$filename\n";
			process_dir ("$dirname\\$filename", $commander);
		} elsif ($filename =~ m/\.w3m$/ || $filename =~ m/\.w3x$/ ) {
      if (!(defined($commander)) || $commander eq "true") {
        print "Installing AMAI and Commander to $dirname/$filename\n";
      } else {
        print "Installing AMAI without Commander to $dirname/$filename\n";
      }
			system "MPQEditor htsize \"$dirname/$filename\" 64";
			system "MPQEditor a \"$dirname/$filename\" Scripts\\TFT\\*.ai Scripts";
      if (!(defined($commander)) || $commander eq "true") {
        system "MPQEditor a \"$dirname/$filename\" Scripts\\Blizzard.j Scripts\\Blizzard.j";
      }
			system "MPQEditor f \"$dirname/$filename\""
		}
	}

	closedir($DIR);
}

process_dir ($ARGV[0], $ARGV[1]);