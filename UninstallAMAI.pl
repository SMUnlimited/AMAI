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
			print "UnInstalling AMAI and Commander to $dirname/$filename\n";
			system "MPQEditor htsize \"$dirname/$filename\" 64";

			system "MPQEditor d \"$dirname/$filename\" Scripts\\common.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\elf.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\human.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\orc.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\undead.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\elf2.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\human2.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\orc2.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\undead2.ai";
			system "MPQEditor d \"$dirname/$filename\" Scripts\\Blizzard.j";

			system "MPQEditor f \"$dirname/$filename\""

		}
	}

	closedir($DIR);
}

process_dir ($ARGV[0], $ARGV[1]);