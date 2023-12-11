#! /usr/bin/perl5 -w

use strict;

sub process_dir {
  my $ver = $_[0];
  my $dirname = $_[1];
  my $commander = $_[2];
  my $filename;
  
  opendir my $DIR, $dirname or die "Could not open $dirname\n";

  while ($filename = readdir($DIR)) {
    next if $filename eq "." || $filename eq "..";
    if ((-d "$dirname/$filename") ) {
      print "Installing $ver AMAI to dir $dirname\\$filename\n";
      process_dir ($ver, "$dirname\\$filename", $commander);
    } elsif ($filename =~ m/\.w3m$/ || $filename =~ m/\.w3x$/ ) {
      if (!(defined($commander)) || $commander eq "true") {
        print "Installing $ver AMAI and Commander to $dirname/$filename\n";
      } else {
        print "Installing $ver AMAI without Commander to $dirname/$filename\n";
      }
      system "MPQEditor htsize \"$dirname/$filename\" 64";
      system "MPQEditor a \"$dirname/$filename\" Scripts\\$ver\\*.ai Scripts";
      if (!(defined($commander)) || $commander eq "true") {
        system "MPQEditor a \"$dirname/$filename\" Scripts\\Blizzard_$ver.j Scripts\\Blizzard.j";
      }
      system "MPQEditor f \"$dirname/$filename\""
    }
  }

  closedir($DIR);
}

process_dir ($ARGV[0], $ARGV[1], $ARGV[2]);