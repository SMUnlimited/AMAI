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
			system "AddToMPQ.exe \"$dirname/$filename\" Scripts\\TFT\\common.ai Scripts\\common.ai Scripts\\Blizzard.j Scripts\\Blizzard.j";
			system "AddToMPQ.exe \"$dirname/$filename\" Scripts\\TFT\\elf.ai Scripts\\elf.ai Scripts\\TFT\\human.ai Scripts\\human.ai Scripts\\TFT\\orc.ai Scripts\\orc.ai Scripts\\TFT\\undead.ai Scripts\\undead.ai";
			system "AddToMPQ.exe \"$dirname/$filename\" Scripts\\TFT\\elf2.ai Scripts\\elf2.ai Scripts\\TFT\\human2.ai Scripts\\human2.ai Scripts\\TFT\\orc2.ai Scripts\\orc2.ai Scripts\\TFT\\undead2.ai Scripts\\undead2.ai";
		}
	}

	closedir($DIR);
}

process_dir ($ARGV[0]);