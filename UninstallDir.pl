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
      print "Uninstalling AMAI and Commander to dir $dirname\\$filename\n";
      process_dir ("$dirname\\$filename", $commander);
    } elsif ($filename =~ m/\.w3m$/ || $filename =~ m/\.w3x$/ ) {
      print "Uninstalling AMAI and Commander to $dirname/$filename\n";

      system "MPQEditor d \"$dirname/$filename\" Scripts\\common.ai";
      if ($? == -1) {
        printf "Unable to spawn MPQEditor process";
      } elsif ($? >> 8 == 5) {
        printf "ERROR: Failed to uninstall, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
      } elsif ($? >> 8 == 2) { 
       # Already deleted file so ignore
      } elsif ($? >> 8 > 0)  {
        printf "ERROR: Unknown. AMAI not have uninstalled correctly. delete :%d\n", $? >> 8;
      }
      system "MPQEditor d \"$dirname/$filename\" Scripts\\elf.ai";
      system "MPQEditor d \"$dirname/$filename\" Scripts\\human.ai";
      system "MPQEditor d \"$dirname/$filename\" Scripts\\orc.ai";
      system "MPQEditor d \"$dirname/$filename\" Scripts\\undead.ai";
      system "MPQEditor d \"$dirname/$filename\" Scripts\\elf2.ai";
      system "MPQEditor d \"$dirname/$filename\" Scripts\\human2.ai";
      system "MPQEditor d \"$dirname/$filename\" Scripts\\orc2.ai";
      system "MPQEditor d \"$dirname/$filename\" Scripts\\undead2.ai";
      system "MPQEditor d \"$dirname/$filename\" Scripts\\Blizzard.j";

      system "MPQEditor f \"$dirname/$filename\"";

      if ($? == -1) {
        printf "Unable to spawn MPQEditor process";
      } elsif ($? >> 8 == 5) {
        printf "ERROR: Failed to uninstall flush, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
      } elsif ($? >> 8 > 0)  {
        printf "ERROR: Unknown. AMAI not have uninstalled correctly. flush:%d\n", $? >> 8;
      }

    }
  }

  closedir($DIR);
}

process_dir ($ARGV[0], $ARGV[1]);