#! /usr/bin/perl5 -w

use strict;

eval {
  print "Perl version: $]\n";
};
if ($@) {
  print "ERROR: Failed to install AMAI.";
  die "Please install Perl as a requirement to install AMAI. Download : https://strawberryperl.com/";
}

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
      if (!(defined($commander)) || $commander eq "1") {
        print "Installing $ver AMAI and Commander to $dirname/$filename\n";
      } elsif ($commander eq "2") {
        print "Installing $ver AMAI and Commander - VS Vanilla AI to $dirname/$filename\n";
      } else {
        print "Installing $ver AMAI without Commander to $dirname/$filename\n";
      }
      system "MPQEditor htsize \"$dirname/$filename\" 128";
      if ($? == -1) {
        printf "Unable to spawn MPQEditor process";
      } elsif ($? >> 8 == 5) {
        printf "ERROR: Failed to run htsize, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
      } else {
        printf "Ran htsize:%d\n", $? >> 8;
      }
      system "MPQEditor a \"$dirname/$filename\" Scripts\\$ver\\*.ai Scripts";
      if ($? == -1) {
        printf "Unable to spawn MPQEditor process";
      } elsif ($? >> 8 == 5) {
        printf "ERROR: Failed to add ai scripts, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
      } elsif ($? >> 8 > 0) {
        printf "ERROR: Unknown. AMAI not have installed correctly. Adding ai scripts:%d\n", $? >> 8;
      }
      if (!(defined($commander)) || $commander eq "1" || $commander eq "2") {
        if (!(defined($commander)) || $commander eq "1") {
          system "MPQEditor a \"$dirname/$filename\" Scripts\\$ver\\Blizzard.j Scripts\\Blizzard.j";
        } elsif ($commander eq "2") {
          system "MPQEditor a \"$dirname/$filename\" Scripts\\$ver\\vsai\\*.ai Scripts";
          if ($? == -1) {
            printf "Unable to spawn MPQEditor process";
          } elsif ($? >> 8 == 5) {
            printf "ERROR: Failed to add vsai scripts, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
          } elsif ($? >> 8 > 0) {
            printf "ERROR: Unknown. AMAI not have installed correctly. Adding commander:%d\n", $? >> 8;
          }
          system "MPQEditor a \"$dirname/$filename\" Scripts\\$ver\\vsai\\Blizzard.j Scripts\\Blizzard.j";
        }
        if ($? == -1) {
          printf "Unable to spawn MPQEditor process";
        } elsif ($? >> 8 == 5) {
          printf "ERROR: Failed to add commander, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
        } elsif ($? >> 8 > 0) {
          printf "ERROR: Unknown. AMAI not have installed correctly. Adding commander:%d\n", $? >> 8;
        }
      }
      system "MPQEditor f \"$dirname/$filename\"";
      if ($? == -1) {
        printf "Unable to spawn MPQEditor process";
      } elsif ($? >> 8 == 5) {
        printf "ERROR: Failed to flush, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
      } elsif ($? >> 8 > 0) {
        printf "ERROR: Unknown. AMAI not have installed correctly. flush:%d\n", $? >> 8;
      }
    }
  }

  closedir($DIR);
}

process_dir ($ARGV[0], $ARGV[1], $ARGV[2]);