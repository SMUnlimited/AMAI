#! /usr/bin/perl5 -w
# Splits the official blizzard J file into sections to add the AMAI code within
use strict;

sub process_blizzj {
  my $mode = 1;
  my $flag = 0;
  my $ver = $_[0];
  mkdir "$ver/tmp";
  open my $in, '<', "$ver/blizzard.j" or die "blizzard.j not found $!";
  open my $bliz1, '>',"$ver/tmp/Blizzard1.j" or die "Unable to write blizzard1.j $!";
  open my $bliz2, '>',"$ver/tmp/Blizzard2.j" or die "Unable to write blizzard2.j $!";
  open my $bliz3, '>',"$ver/tmp/Blizzard3.j" or die "Unable to write blizzard3.j $!";
  open my $bliz4, '>',"$ver/tmp/Blizzard4.j" or die "Unable to write blizzard4.j $!";
  open my $bliz5, '>',"$ver/tmp/Blizzard5.j" or die "Unable to write blizzard5.j $!";
  open my $bliz6, '>',"$ver/tmp/Blizzard6.j" or die "Unable to write blizzard6.j $!";
  while (my $line = <$in>) {
      if ($mode == 1) {
        print $bliz1 $line;
        if ($line =~ /bj_wantDestroyGroup         = false/) {
          $mode = 2;
          close $bliz1;
        }
      } elsif ($mode == 2) {
        print $bliz2 $line;
        if ($line =~ /function MeleeStartingUnitsForPlayer/ and $flag == 0) {
          $flag = 1;
        } elsif ($line =~ /endfunction/ and $flag == 1) {
          $mode = 3;
          close $bliz2;
          $flag = 0;
        }
      } elsif ($mode == 3) {
        print $bliz3 $line;
        if ($line =~ /function MeleeStartingAI/ and $flag == 0) {
          $flag = 1;
        } elsif ($line =~ /endfunction/ and $flag == 1) {
          $mode = 4;
          close $bliz3;
          $flag = 0;
        }
      } elsif ($mode == 4) {
        print $bliz4 $line;
        if ($line =~ /function InitGenericPlayerSlots/ and $flag == 0) {
          $flag = 1;
        } elsif ($line =~ /endfunction/ and $flag == 1) {
          $mode = 5;
          close $bliz4;
          $flag = 0;
        }
      } elsif ($mode == 5) {
        print $bliz5 $line;
        if ($line =~ /call InitNeutralBuildings()/) {
          $mode = 6;
          close $bliz5;
        }
      } elsif ($mode == 6) {
        print $bliz6 $line;
      }
  }
  close $in;
  close $bliz6;
}

process_blizzj($ARGV[0]);