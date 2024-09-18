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
      if (!(defined($commander)) || $commander eq "true") {
        print "Installing $ver AMAI and Commander to $dirname/$filename\n";
      } else {
        print "Installing $ver AMAI without Commander to $dirname/$filename\n";
      }
      system "MPQEditor htsize \"$dirname/$filename\" 128";
      if ($? == -1 || $? >> 8 == 5) {
        printf "ERROR: Failed to run htsize, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
      } else {
        printf "htsize:%d\n", $? >> 8;
      }
      system "MPQEditor a \"$dirname/$filename\" Scripts\\$ver\\*.ai Scripts";
      if ($? == -1 || $? >> 8 == 5) {
        printf "ERROR: Failed to add ai scripts, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
      } else {
        printf "add ai scripts:%d\n", $? >> 8;
      }
      if (!(defined($commander)) || $commander eq "true") {
        system "MPQEditor a \"$dirname/$filename\" Scripts\\Blizzard_$ver.j Scripts\\Blizzard.j";
        if ($? == -1 || $? >> 8 == 5) {
          printf "ERROR: Failed to add commander, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
        } else {
          printf "add commander:%d\n", $? >> 8;
        }
        if ($ver eq "REFORGED") {
          system "MPQEditor a \"$dirname/$filename\" Icons\\Reforged\\MiniMap\\ UI\\MiniMap";
          if ($? == -1 || $? >> 8 == 5) {
            printf "ERROR: Failed to add minimap icons, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
          } else {
            printf "add minimap icons:%d\n", $? >> 8;
          }
          system "MPQEditor a \"$dirname/$filename\" Icons\\Reforged\\CommandButtons\\*.dds ReplaceableTextures\\CommandButtons";
          if ($? == -1 || $? >> 8 == 5) {
            printf "ERROR: Failed to add item icons, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
          } else {
            printf "add item icons:%d\n", $? >> 8;
          }
          system "MPQEditor a \"$dirname/$filename\" Icons\\Reforged\\CommandButtonsDisabled\\*.dds ReplaceableTextures\\CommandButtonsDisabled";
          if ($? == -1 || $? >> 8 == 5) {
            printf "ERROR: Failed to add item icons, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
          } else {
            printf "add item icons:%d\n", $? >> 8;
          }
          system "MPQEditor a \"$dirname/$filename\" Icons\\Reforged\\war3map.imp war3map.imp";
          if ($? == -1 || $? >> 8 == 5) {
            printf "ERROR: Failed to add input files, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
          } else {
            printf "add input files:%d\n", $? >> 8;
          }
          system "MPQEditor a \"$dirname/$filename\" Icons\\Reforged\\war3map.w3t war3map.w3t";
          if ($? == -1 || $? >> 8 == 5) {
            printf "ERROR: Failed to add icon files, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
          } else {
            printf "add icon files:%d\n", $? >> 8;
          }
        } else {
          system "MPQEditor a \"$dirname/$filename\" Icons\\Classic\\CommandButtons\\*.blp ReplaceableTextures\\CommandButtons";
          if ($? == -1 || $? >> 8 == 5) {
            printf "ERROR: Failed to add item icons, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
          } else {
            printf "add item icons:%d\n", $? >> 8;
          }
          system "MPQEditor a \"$dirname/$filename\" Icons\\Classic\\CommandButtonsDisabled\\*.blp ReplaceableTextures\\CommandButtonsDisabled";
          if ($? == -1 || $? >> 8 == 5) {
            printf "ERROR: Failed to add item icons, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
          } else {
            printf "add item icons:%d\n", $? >> 8;
          }
          system "MPQEditor a \"$dirname/$filename\" Icons\\Classic\\war3map.imp war3map.imp";
          if ($? == -1 || $? >> 8 == 5) {
            printf "ERROR: Failed to add input files, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
          } else {
            printf "add input files:%d\n", $? >> 8;
          }
          system "MPQEditor a \"$dirname/$filename\" Icons\\Classic\\war3map.w3t war3map.w3t";
          if ($? == -1 || $? >> 8 == 5) {
            printf "ERROR: Failed to add icon files, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
          } else {
            printf "add icon files:%d\n", $? >> 8;
          }
        }
      }
      system "MPQEditor f \"$dirname/$filename\"";
      if ($? == -1 || $? >> 8 == 5) {
        printf "ERROR: Failed to flush, you may not have valid permissions or are blocked by windows UAC. Ensure map files are not in a UAC protected location %d\n", $? >> 8;
      } else {
        printf "flush:%d\n", $? >> 8;
      }
    }
  }

  closedir($DIR);
}

process_dir ($ARGV[0], $ARGV[1], $ARGV[2]);
