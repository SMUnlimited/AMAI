#! /usr/bin/perl5 -w

use strict;
use Tk;
use Tk::TextUndo;
use Tk::Table;
use Tk::NoteBook;

BEGIN{
  if($^O eq 'MSWin32'){
      require Win32::Console;
      #Win32::Console::Free();
  }
}

my $fdialogbug = 0;

if($] >= 5.008004) {
  $fdialogbug = 1;
}

my $main = MainWindow->new(-title => 'AMAI Strategy Manager');
my $lframe = $main->Frame->pack(-side => 'left');
my $race;
my $ver;
my $strat;
my $profile;
my $rframe = $main->Frame->pack(-side => 'right');
my $notebook = $rframe->NoteBook()->pack(-side => 'left');
my $stratframe = $notebook->add("strat", -label => 'Strategies');
my $profileframe = $notebook->add("profile", -label => 'Profiles');
my $stratlb = $stratframe->Listbox(-height => 0)->pack;
tie $strat, "Tk::Listbox", $stratlb;
my $profilelb = $profileframe->Listbox(-height => 0)->pack;
tie $profile, "Tk::Listbox", $profilelb;
my $bframe = $rframe->Frame->pack(-side => 'right');
$bframe->Button(
                -text => 'New',
                -command => sub {
                   if ($notebook->raised eq 'strat') {
                     InsertStratSub("$ver\\$race\\New.ais", $ver, $race);
                     UpdateStratList($stratlb, $ver, $race)
                   }
                   else {
                     InsertProfileSub("$ver\\New.aip", $ver);
                     UpdateProfileList($profilelb, $ver)
                   }
                },
                -width => 6)->pack;
$bframe->Button(
                -text => 'Extract',
                -command => sub {
                   if ($notebook->raised eq 'strat') {
                     ExtractStrat($main, $ver, $race, $strat)
                   }
                   else {
                     ExtractProfile($main, $ver, $profile)
                   }
                },
                -width => 6)->pack;
$bframe->Button(
                -text => 'Insert',
                -command => sub {
                   if ($notebook->raised eq 'strat') {
                     InsertStrat($main, $ver, $race);
                     UpdateStratList($stratlb, $ver, $race)
                   }
                   else {
                     InsertProfile($main, $ver);
                     UpdateProfileList($profilelb, $ver)
                   }
                },
                -width => 6)->pack;
$bframe->Button(
                -text => 'Copy',
                -command => sub {
                   if ($notebook->raised eq 'strat') {
                     CopyStrat($ver, $race, $strat);
                     UpdateStratList($stratlb, $ver, $race)
                   }
                   else {
                     CopyProfile($ver, $profile);
                     UpdateProfileList($profilelb, $ver)
                   }
                },
                -width => 6)->pack;
$bframe->Button(
                -text => 'Remove',
                -command => sub {
                   if ($notebook->raised eq 'strat') {
                     RemoveStrat($main, $ver, $race, $strat);
                     UpdateStratList($stratlb, $ver, $race)
                   }
                   else {
                     RemoveProfile($main, $ver, $profile);
                     UpdateProfileList($profilelb, $ver)
                   }
                },
                -width => 6)->pack;
$bframe->Button(
                -text => 'Edit',
                -command => sub {
                   if ($notebook->raised eq 'strat') {
                     EditStrat($main, $ver, $race, $strat)
                   }
                   else {
                     EditProfile($main, $ver, $profile)
                   }
                },
                -width => 6)->pack;
$bframe->Button(
                -text => 'Lock',
                -command => sub {
                   if ($notebook->raised eq 'strat') {
                     SetRaceOption($ver, $race, 'debug_strategy', "STRAT_$strat->[0]")
                   }
                   else {
                     SetVerOption($ver, 'debug_profile', GetArrayIndex($profile, $profilelb->get(0, 'end')))
                   }
                },
                -width => 6)->pack;
$bframe->Button(
                -text => 'Unlock',
                -command => sub {
                   if ($notebook->raised eq 'strat') {
                     SetRaceOption($ver, $race, 'debug_strategy', -1)
                   }
                   else {
                     SetVerOption($ver, 'debug_profile', -1)
                   }
                },
                -width => 6)->pack;
$bframe->Button(
                -text => 'Quit',
                -command => [$main => 'destroy'],
                -width => 6)->pack;

open(VERFILE, "Versions.txt") or die "File <Versions.txt> not found!";
my @vers = <VERFILE>;
close(VERFILE);
chomp foreach (@vers);
my $raceopt;
my $veropt;
$veropt = $lframe->Optionmenu(
                -command => sub {  $raceopt -> destroy if($raceopt); 
                  $raceopt = $lframe->Optionmenu(
                              -command => sub { UpdateStratList($stratlb, $ver, $race) },
                              -variable => \$race,
                              -width => 10)->pack(-after => $veropt);
                  $raceopt -> addOptions(GetRaces($ver));
                  UpdateStratList($stratlb, $ver, $race);
                  UpdateProfileList($profilelb, $ver) },
                -variable => \$ver,
                -width => 10)->pack;
$veropt->addOptions(@vers);
$lframe->Button(
                -text => 'Edit Racial Builds',
                -command => sub { EditRacialBuilds($main, $ver, $race) },
                -width => 15)->pack;
$lframe->Button(
                -text => 'Edit Global Settings',
                -command => sub { EditSettings($main, "$ver\\GlobalSettings.txt") },
                -width => 15)->pack;
$lframe->Button(
                -text => 'Edit Racial Settings',
                -command => sub { EditSettings($main, "$ver\\$race\\Settings.txt") },
                -width => 15)->pack;
$lframe->Button(
                -text => 'Compile',
                -command => sub { system "Make$ver.bat" },
                -width => 15)->pack;
$lframe->Button(
                -text => 'Compile, Optimize',
                -command => sub { system "MakeOpt$ver.bat" },
                -width => 15)->pack;
$lframe->Button(
		-text => 'Compile AMAIvsAI',
		-command => sub { system "MakeVAI$ver.bat" },
		-width => 15)->pack;
MainLoop;

sub GetRaces {
  my $ver = shift;
  open(RACEFILE, "$ver\\Races.txt") or die "File <$ver\\Races.txt> not found!";
  my @races = <RACEFILE>;
  close(RACEFILE);
  chomp foreach (@races);
  foreach (@races) {
    /^([^\t]*)\t/;
    $_ = $1;
  };
  return @races;
}

sub GetArrayIndex {
  my ($x, @a) = @_;
  my $i = 0;
  return -1 unless (@$x[0]);
  foreach (@a) {
    return $i if (@$x[0] eq $_);
    $i++;
  }
  return -1;
}

sub SetRaceOption {
  my ($ver, $race, $opt, $val) = @_;
  open(SETFILE, "$ver\\$race\\Settings.txt") or die "File <$ver\\$race\\Settings.txt> not found!";
  my @setfile = ();
  my $optionexists = 0;
  while(<SETFILE>) {
    if (/^$opt\t[^\t]*\t(.*)/) {
      push @setfile, "$opt\t$val\t$1\n";
      $optionexists = 1;
    }
    else {
      push @setfile, $_;
    }
  }
  push @setfile, "$opt\t$val\t\n" if ($optionexists == 0);
  close(SETFILE);
  open(SETFILE, ">$ver\\$race\\Settings.txt") or die "File <$ver\\$race\\Settings.txt> not found!";
  print SETFILE @setfile;
  close(SETFILE);
}

sub SetVerOption {
  my ($ver, $opt, $val) = @_;
  open(SETFILE, "$ver\\GlobalSettings.txt") or die "File <$ver\\GlobalSettings.txt> not found!";
  my @setfile = ();
  my $optionexists = 0;
  while(<SETFILE>) {
    if (/^$opt\t[^\t]*\t(.*)/) {
      push @setfile, "$opt\t$val\t$1\n";
      $optionexists = 1;
    }
    else {
      push @setfile, $_;
    }
  }
  push @setfile, "$opt\t$val\t\n" if ($optionexists == 0);
  close(SETFILE);
  open(SETFILE, ">$ver\\GlobalSettings.txt") or die "File <$ver\\GlobalSettings.txt> not found!";
  print SETFILE @setfile;
  close(SETFILE);
}

sub GetStratList {
  my $ver = shift;
  my $race = shift;
  return () unless ($ver and $race);
  open(STRATFILE, "$ver\\$race\\Strategy.txt") or die "File <$ver\\$race\\Strategy.txt> not found!";
  my @stratlist = ();
  <STRATFILE>;
  while (<STRATFILE>) {
    if (/^([^\t]*)\t/) {
      push @stratlist, $1;
    }
  };
  close(STRATFILE);
  return @stratlist;
};

sub UpdateStratList {
  my $stratlb = shift;
  my $ver = shift;
  my $race = shift;
  $stratlb->delete(0, $stratlb->index('end')-1);
  $stratlb->insert('end', GetStratList($ver, $race));
}

sub GetProfileList {
  my $ver = shift;
  return () unless ($ver);
  open(PROFILEFILE, "$ver\\Profiles.txt") or die "File <$ver\\Profiles.txt> not found!";
  my @profilelist = ();
  <PROFILEFILE>;
  while (<PROFILEFILE>) {
    if (/^([^\t]*)\t/) {
      push @profilelist, $1;
    }
  };
  close(PROFILEFILE);
  return @profilelist;
};

sub UpdateProfileList {
  my ($profilelb, $ver) = @_;
  $profilelb->delete(0, $profilelb->index('end')-1);
  $profilelb->insert('end', GetProfileList($ver));
}

sub RemoveStrat {
  my ($main, $version, $race, $strat) = @_;
  return unless @$strat[0];
  my $response = $main->messageBox(-message => 'Are you sure you want to remove that strategy?', -title => 'Really?', -type => 'YesNo', -default => 'no');
  return if ($response eq 'no' or $response eq 'No');
  my $stratname = @$strat[0];
  open(STRATFILE, "$version\\$race\\Strategy.txt") or die "File <$version\\$race\\Strategy.txt> not found!";
  my @stratfile = ();
  while (<STRATFILE>) {
    unless (/^$stratname\t/) {
      push(@stratfile, $_);
    }
  }
  close(STRATFILE);
  open(STRATFILE, ">$version\\$race\\Strategy.txt") or die "File <$version\\$race\\Strategy.txt> could not be opened for writing!";
  print STRATFILE @stratfile;
  close(STRATFILE);
  @stratfile = ();
  open(AIFILE, "$version\\$race\\BuildSequence.ai") or die "File <$version\\$race\\BuildSequence.ai> not found!";
  my @aifile = ();
  while (<AIFILE>) {
    if (/\bfunction\s*init_strategy_$stratname\b/) {
      while ((<AIFILE> or die "Strategy not complete in Build Sequence") !~ /endfunction/) {}
      while ((<AIFILE> or die "Strategy not complete in Build Sequence") !~ /endfunction/) {}
    }
    else {
      push(@aifile, $_);
    }
  }
  close(AIFILE);
  open(AIFILE, ">$version\\$race\\BuildSequence.ai") or die "File <$version\\$race\\BuildSequence.ai> could not be opened for writing!";
  print AIFILE @aifile;
  close(AIFILE);
}

sub RemoveProfile {
  my ($main, $version, $profile) = @_;
  return unless @$profile[0];
  my $response = $main->messageBox(-message => 'Are you sure you want to remove that profile?', -title => 'Really?', -type => 'YesNo', -default => 'no');
  return if ($response eq 'no' or $response eq 'No');
  my $profilename = @$profile[0];
  open(PROFILEFILE, "$version\\Profiles.txt") or die "File <$version\\Profiles.txt> not found!";
  my @profilefile = ();
  while (<PROFILEFILE>) {
    unless (/^$profilename\t/) {
      push(@profilefile, $_);
    }
  }
  close(PROFILEFILE);
  open(PROFILEFILE, ">$version\\Profiles.txt") or die "File <$version\\Profiles.txt> could not be opened for writing!";
  print PROFILEFILE @profilefile;
  close(PROFILEFILE);
}

sub CopyStrat {
  my ($version, $race, $strat) = @_;
  return unless @$strat[0];
  my $stratname = @$strat[0];
  ExtractStratSub('tmp', $version, $race, $stratname);
  InsertStratSub('tmp', $version, $race);
  system "del tmp";
}

sub CopyProfile {
  my ($version, $profile) = @_;
  return unless @$profile[0];
  my $profilename = @$profile[0];
  ExtractProfileSub('tmp', $version, $profilename);
  InsertProfileSub('tmp', $version);
  system "del tmp";
}

sub ExtractStratSub {
  my ($filename, $version, $race, $stratname) = @_;
  open(AIFILE, "$version\\$race\\BuildSequence.ai") or die "File <$version\\$race\\BuildSequence.ai> not found!";
  open(STRATFILE, "$version\\$race\\Strategy.txt") or die "File <$version\\$race\\Strategy.txt> not found!";
  open(TARGETFILE, ">$filename") or die "File <$filename> not found!";
  print TARGETFILE "#AMAI 2.0 Strategy\n";
  my $line = <STRATFILE>;
  while (($line = (<STRATFILE> or die "Strategy not found in Strategy Table")) !~ /^$stratname\t/) {}
  print TARGETFILE $line;
  while (($line = (<AIFILE> or die "Strategy not found in Build Sequence")) !~ /\bfunction\s*init_strategy_$stratname\b/) {}
  print TARGETFILE $line;
  while (($line = (<AIFILE> or die "Strategy not complete in Build Sequence")) !~ /endfunction/) {print TARGETFILE $line;}
  print TARGETFILE $line;
  while (($line = (<AIFILE> or die "Strategy not complete in Build Sequence")) !~ /endfunction/) {print TARGETFILE $line;}
  print TARGETFILE $line;
  close(TARGETFILE);
  close(AIFILE);
  close(STRATFILE);
}

sub ExtractStrat {
  my ($main, $version, $race, $strat) = @_;
  return unless @$strat[0];
  my $stratname = @$strat[0];
  my $types = [['AMAI Strategies', '.ais']];
  $types = [['AMAI Strategies', '.ais'],[]] if ($fdialogbug);
  my $filename = $main->getSaveFile(
                -defaultextension => '.ais',
                -filetypes => $types );
  return unless ($filename and ($filename ne ""));
  ExtractStratSub($filename, $version, $race, $stratname);
}

sub ExtractProfileSub {
  my ($filename, $version, $profilename) = @_;
  open(PROFILEFILE, "$version\\Profiles.txt") or die "File <$version\\Profiles.txt> not found!";
  open(TARGETFILE, ">$filename") or die "File <$filename> not found!";
  print TARGETFILE "#AMAI 2.0 Profile\n";
  my $line = <PROFILEFILE>;
  while (($line = (<PROFILEFILE> or die "Profile not found in Profile Table")) !~ /^$profilename\t/) {}
  print TARGETFILE $line;
  close(TARGETFILE);
  close(PROFILEFILE);
}

sub ExtractProfile {
  my ($main, $version, $profile) = @_;
  return unless @$profile[0];
  my $profilename = @$profile[0];
  my $types = [['AMAI Profiles', '.aip']];
  $types = [['AMAI Profiles', '.aip'],[]] if ($fdialogbug);
  my $filename = $main->getSaveFile(
                -defaultextension => '.aip',
                -filetypes => $types );
  return unless ($filename and ($filename ne ""));
  ExtractProfileSub($filename, $version, $profilename);
}

sub InsertStratSub {
  my ($filename, $version, $race) = @_;
  my $stratlist = join ',', GetStratList($version, $race);
  open(SOURCE, $filename) or die "File <$filename> not found!";
  open(AIFILE, ">>$version\\$race\\BuildSequence.ai") or die "File <$version\\$race\\BuildSequence.ai> not found!";
  open(STRATFILE, ">>$version\\$race\\Strategy.txt") or die "File <$version\\$race\\Strategy.txt> not found!";
  my $line = <SOURCE>;
  if ($line !~ /#AMAI 2.0 Strategy/) {die "No AMAI 2.0 Strategy File";}
  $line = <SOURCE>;
  $line =~ /^([^\t]*)\t/;
  my $oldstratname = $1;
  my $stratname = $oldstratname;
  my $x = 0;
  while ($stratlist =~ /\b$stratname\b/) {
    $x++;
    $stratname = "$oldstratname$x";
  }

  $line =~ s/^$oldstratname/$stratname/;
  print STRATFILE $line;
  print AIFILE "\n";
  while (<SOURCE>) {
    s/\b(function \w*_)$oldstratname\b/$1$stratname/;
    print AIFILE;
  }
  close(AIFILE);
  close(STRATFILE);
  close(SOURCE);
}

sub InsertStrat {
  my ($main, $version, $race) = @_;
  my $types = [['AMAI Strategies', '.ais']];
  $types = [['AMAI Strategies', '.ais'],[]] if ($fdialogbug);
  my $filename = $main->getOpenFile(
                -defaultextension => '.ais',
                -filetypes => $types );
  return unless ($filename and ($filename ne ""));
  InsertStratSub($filename, $version, $race);
}

sub InsertProfileSub {
  my ($filename, $version) = @_;
  my $profilelist = join ',', GetProfileList($version);
  open(SOURCE, $filename) or die "File <$filename> not found!";
  open(PROFILEFILE, ">>$version\\Profiles.txt") or die "File <$version\\Profiles.txt> not found!";
  my $line = <SOURCE>;
  if ($line !~ /#AMAI 2.0 Profile/) {die "No AMAI 2.0 Profile File";}
  $line = <SOURCE>;
  $line =~ /^([^\t]*)\t/;
  my $oldprofilename = $1;
  my $profilename = $oldprofilename;
  my $x = 0;
  while ($profilelist =~ /\b$profilename\b/) {
    $x++;
    $profilename = "$oldprofilename$x";
  }

  $line =~ s/^$oldprofilename/$profilename/;
  print PROFILEFILE $line;
  close(PROFILEFILE);
  close(SOURCE);
}

sub InsertProfile {
  my ($main, $version) = @_;
  my $types = [['AMAI Profiles', '.aip']];
  $types = [['AMAI Profiles', '.aip'],[]] if ($fdialogbug);
  my $filename = $main->getOpenFile(
                -defaultextension => '.aip',
                -filetypes => $types );
  return unless ($filename and ($filename ne ""));
  InsertProfileSub($filename, $version);
}

sub EditStrat {
  my ($main, $version, $race, $strat) = @_;
  return unless @$strat[0];
  my $edit = $main->Toplevel(-title => 'AMAI Strategy Editor');
  my $lframe = $edit->Frame->pack(-side => 'left');
  my $rframe = $edit->Frame->pack(-side => 'right');
  my $bframe = $rframe->Frame->pack(-side => 'right');
  my $strattable = $rframe->Table(-rows => 37)->pack(-side => 'left');
  open(TIERFILE, "$ver\\$race\\Tiers.txt") or die "File <$ver\\$race\\Tiers.txt> not found!";
  my @tiers = <TIERFILE>;
  my $tiernum = @tiers;
  close(TIERFILE);
  my $textheight = 44 / ($tiernum + 1);
  my @buildtexttier = ();
  $lframe->Label(-text => 'Initalisation Code')->pack;
  my $inittext = $lframe->Scrolled('TextUndo', -scrollbars => 'se', -wrap => 'none', -height => $textheight)->pack;
  for(my $i=1;$i<=$tiernum;$i++) {
    $lframe->Label(-text => "Code for Tier $i")->pack;
    $buildtexttier[$i] = $lframe->Scrolled('TextUndo', -scrollbars => 'se', -wrap => 'none', -height => $textheight)->pack;
  }
  my $optarrayref = FillTable($strattable, $version, $race, @$strat[0]);
  FillTexts($inittext, \@buildtexttier, $version, $race, @$strat[0]);
  $bframe->Button(
                -text => 'OK',
                -command => sub {SaveStrat($edit, $inittext, \@buildtexttier, $strattable, $version, $race, @$strat[0], $optarrayref)},
                -width => 6)->pack;
  $bframe->Button(
                -text => 'Cancel',
                -command => [$edit => 'destroy'],
                -width => 6)->pack;
  $edit->focusForce;
}

sub EditProfile {
  my ($main, $version, $profile) = @_;
  return unless @$profile[0];
  my $edit = $main->Toplevel(-title => 'AMAI Profile Editor');
  my $bframe = $edit->Frame->pack(-side => 'right');
  my $profiletable = $edit->Table(-rows => 37)->pack(-side => 'left');
  my $optarrayref = FillProfileTable($profiletable, $version, @$profile[0]);
  $bframe->Button(
                -text => 'OK',
                -command => sub {SaveProfile($edit, $profiletable, $version, @$profile[0], $optarrayref)},
                -width => 6)->pack;
  $bframe->Button(
                -text => 'Cancel',
                -command => [$edit => 'destroy'],
                -width => 6)->pack;
  $edit->focusForce;
}

sub GetVarList {
  my ($ver, $var, $race) = @_;
  open(VARFILE, "VarDefs.ini") or die "File <VarDefs.ini> not found!";
  <VARFILE>;
  while(<VARFILE>) {
    chomp;
    if (/$var\t(.*)/) {
      my $fn = $1;
      $fn =~ s/\$RACE\$/$race/g;
      close(VARFILE);
      open(VARTABLE, "$ver\\$fn") or die "File <$ver\\$fn> not found!";
      my @vt = ();
      while (<VARTABLE>) {
        /([^\t\n]*)(\t|\n|$)/;
        push @vt, $1;
      }
      close(VARTABLE);
      return @vt;
    }
  }
  return $var;
}

sub ExtendTable {
  my ($ver, $race, @table) = @_;
  my @outtable = ();
  foreach (@table) {
    my @l = ();
    push @l, $_;
    my $b = 1;
    while($b) {
      $b = 0;
      my @lout = ();
      foreach (@l) {
        if(/\$([^\$]*)\$/) {
          my $var = $1;
          my $it = $_;
          $b = 1;
          foreach (GetVarList($ver, $var, $race)) {
            my $itrep = $it;
            $itrep =~ s/\$$var\$/$_/g;
            push @lout, $itrep;
          }
        }
        else {
          push @lout, $_;
        }
      }
      @l = @lout;
    }
    push @outtable, @l;
  }
  return @outtable;
}

sub ExtendOptList {
  my ($ver, $dummy, @ilist) = @_;
  my @olist = ($dummy);
  foreach(@ilist) {
    if (/\%([^\%]+)\%/) {
      push @olist, GetVarList($ver, $1, '');
    }
    else {
      push @olist, $_;
    }
  }
  return @olist;
}

sub GetOptList {
  my $ver = shift;
  open(OPTFILE, "Optionlist.ini") or die "File <Optionlist.ini> not found!";
  my %optlist = ();
  my @optfile = <OPTFILE>;
  close(OPTFILE);
  @optfile = ExtendTable($ver, '', @optfile);
  foreach (@optfile) {
    chomp;
    /([^:]*):([^:]*)/;
    my $optname = $1;
    my @optarray = split(',', $2);
    @optarray = ExtendOptList($ver, @optarray) if ($optarray[0] eq 'list');
    $optlist{$optname} = \@optarray;
  }
  return \%optlist;
}

sub OptionmenuAddOptions {
  my ($optmenu, $curval, @optlist) = @_;
  foreach (@optlist) {
    $optmenu->addOptions($_) unless $_ eq $curval;
  }
  $optmenu->addOptions($curval);
}

sub GetUnitLists {
  my ($version, $race) = @_;
  my @unitlist = (0);
  my @buildinglist = (0);
  my @upgradelist = (0);
  my @herolist = (0);
  open(UNITFILE, "$version\\StandardUnits.txt") or die "File <$version\\StandardUnits.txt> not found!";
  while(<UNITFILE>) {
    my @line = split("\t", $_);
    push @buildinglist, $line[0] if ($line[2] =~ /$race/ and $line[4] eq "BUILDING");
    push @unitlist, $line[0] if (($line[2] =~ /$race/) and ($line[3] !~ /peon|mutated/) and $line[4] eq "UNIT");
    push @upgradelist, $line[0] if (($line[2] =~ /$race/) and ($line[3] =~ /upgrade/));
    push @herolist, $line[0] if (($line[2] =~ /$race|NEUTRAL/) and ($line[3] !~ /mutated/) and ($line[3] =~ /hero/));
  }
  close(UNITFILE);
  return (\@unitlist, \@buildinglist, \@upgradelist, \@herolist);
}

sub GetProfileUnitLists {
  my ($version, @races) = @_;
  my %unitlists;
  my %herolists;
  foreach (@races) {
    my @unitlist = (0);
    my @herolist = (0);
    $unitlists{$_} = \@unitlist;
    $herolists{$_} = \@herolist;
  }
  open(UNITFILE, "$version\\StandardUnits.txt") or die "File <$version\\StandardUnits.txt> not found!";
  while(<UNITFILE>) {
    my @line = split("\t", $_);
    foreach (@races) {
      push @{$unitlists{$_}}, $line[0] if (($line[3] !~ /dummy|mutated|peon/) and ($line[2] =~ /$_/) and $line[4] eq "UNIT");
      push @{$herolists{$_}}, $line[0] if (($line[3] =~ /hero/) and ($line[3] !~ /mutated/) and ($line[2] =~ /$_/));
    }
  }
  close(UNITFILE);
  return (\%unitlists, \%herolists);
}

sub FillTable {
  my ($strattable, $version, $race, $strat) = @_;
  my $optlistref = GetOptList($version);
  my %optlist = %$optlistref;
  my ($unitlistref, $buildinglistref, $upgradelistref, $herolistref) = GetUnitLists($version, $race);
  my @unitlist = @{$unitlistref};
  my @buildinglist = @{$buildinglistref};
  my @upgradelist = @{$upgradelistref};
  my @herolist = @{$herolistref};
  open(STRATFILE, "$version\\$race\\Strategy.txt") or die "File <$version\\$race\\Strategy.txt> not found!";
  my $line = <STRATFILE>;
  chomp($line);
  my @opt = split("\t", $line);
  my $l;
  my $i = 0;
  foreach my $v (@opt) {
    $l = $strattable->Label(-text => $v);
    $strattable->put($i, 0, $l);
    $i++;
  }
  while (($line = (<STRATFILE> or die "Strategy not found in Strategy table.")) !~ /^$strat\t/) {}
  chomp($line);
  my @optval = split("\t", $line);
  $i = 0;
  my @optarray = ();
  foreach my $v (@optval) {
    if ($optlist{$opt[$i]}) {
      my @optvalarray = @{$optlist{$opt[$i]}};
      $l = $strattable->Optionmenu(
                -variable => \($optarray[$i]),
                -width => 25)->pack;
      if ($optvalarray[0] eq 'list') {
        OptionmenuAddOptions($l, $v, @optvalarray[1..$#optvalarray]);
      }
      elsif ($optvalarray[0] eq 'unit') {
        OptionmenuAddOptions($l, $v, @unitlist);
      }
      elsif ($optvalarray[0] eq 'building') {
        OptionmenuAddOptions($l, $v, @buildinglist);
      }
      elsif ($optvalarray[0] eq 'hero') {
        OptionmenuAddOptions($l, $v, @herolist);
      }  
      else {
        OptionmenuAddOptions($l, $v, @upgradelist);
      }
    }
    else {
      $l = $strattable->Entry(-width => 25);
      $l->insert('end', $v);
    }
    $strattable->put($i, 1, $l);
    $i++;
  }
  close(STRATFILE);
  return \@optarray;
}

sub FillProfileTable {
  my ($profiletable, $version, $profile) = @_;
  my $optlistref = GetOptList($version);
  my %optlist = %$optlistref;
  my ($unitlistref, $herolistref) = GetProfileUnitLists($version, GetRaces($version), 'NEUTRAL');
  my %unitlists = %{$unitlistref};
  my %herolists = %{$herolistref};
  open(PROFILEFILE, "$version\\Profiles.txt") or die "File <$version\\Profiles.txt> not found!";
  my $line = <PROFILEFILE>;
  chomp($line);
  my @opt = split("\t", $line);
  my $l;
  my $i = 0;
  foreach my $v (@opt) {
    $l = $profiletable->Label(-text => $v);
    $profiletable->put($i, 0, $l);
    $i++;
  }
  while (($line = (<PROFILEFILE> or die "Profile not found in Profile table.")) !~ /^$profile\t/) {}
  chomp($line);
  my @optval = split("\t", $line);
  $i = 0;
  my @optarray = ();
  foreach my $v (@optval) {
    if ($optlist{$opt[$i]}) {
      my @optvalarray = @{$optlist{$opt[$i]}};
      $l = $profiletable->Optionmenu(
                -variable => \($optarray[$i]),
                -width => 35)->pack;
      if ($optvalarray[0] eq 'list') {
        OptionmenuAddOptions($l, $v, @optvalarray[1..$#optvalarray]);
      }
      elsif ($optvalarray[0] eq 'unit') {
        OptionmenuAddOptions($l, $v, @{$unitlists{$optvalarray[1]}});
      }
      else {
        OptionmenuAddOptions($l, $v, @{$herolists{$optvalarray[1]}});
      }  
    }
    else {
      $l = $profiletable->Entry(-width => 40);
      $l->insert('end', $v);
    }
    $profiletable->put($i, 1, $l);
    $i++;
  }
  close(PROFILEFILE);
  return \@optarray;
}

sub AssembleTable {
  my ($strattable, $optarrayref) = @_;
  my @jl = ();
  for(my $i=0;$i<$strattable->totalRows;$i++) {
    if (defined @{$optarrayref}[$i]) {
      push @jl, @{$optarrayref}[$i];
    }
    else {
      push @jl, $strattable->get($i,1)->get;
    }
  }
  return join "\t", @jl;
}

sub FillTexts {
  my ($inittext, $buildtexttierref, $version, $race, $stratname, @optarray) = @_;
  my @buildtexttier = @{$buildtexttierref};
  open(AIFILE, "$version\\$race\\BuildSequence.ai") or die "File <$version\\$race\\BuildSequence.ai> not found!";
  my $line;
  while ((<AIFILE> or die "Strategy not found in AI File") !~ /\bfunction\s*init_strategy_$stratname\b/) {}
  while (($line = (<AIFILE> or die "Strategy not complete in AI File")) !~ /endfunction/) {$inittext->insert('end', $line);}
  while ((<AIFILE> or die "Strategy not complete in AI File") !~ /\bfunction\s*build_sequence_$stratname\b/) {}
  while ((<AIFILE> or die "Strategy not complete in AI File") !~ /if.*tier.*==.*$#buildtexttier/) {}
  for(my $i=$#buildtexttier;$i>2;$i--) {
    my $j = $i-1;
    while (($line = (<AIFILE> or die "Strategy not complete in AI File")) !~ /elseif.*tier.*==.*$j/) {$buildtexttier[$i]->insert('end', $line);}
  }
  my $iflevel = 0;
  while ((($line = (<AIFILE> or die "Strategy not complete in AI File")) !~ /\belse\b/) or $iflevel != 0) {
    $buildtexttier[2]->insert('end', $line);
    $iflevel++ if ($line =~ /\bif/);
    $iflevel-- if ($line =~ /endif/);
  }
  $iflevel = 0;
  while ((($line = (<AIFILE> or die "Strategy not complete in AI File")) !~ /endif/) or $iflevel != 0) {
    $buildtexttier[1]->insert('end', $line);
    $iflevel++ if ($line =~ /\bif/);
    $iflevel-- if ($line =~ /endif/);
  }
  close(AIFILE);
}

sub SaveStrat {
  my ($edit, $inittext, $buildtexttierref, $strattable, $version, $race, $stratname, $optarrayref) = @_;
  my @buildtexttier = @{$buildtexttierref};
  my $newstratname = $strattable->get(0,1)->get;
  open(STRATFILE, "$version\\$race\\Strategy.txt") or die "File <$version\\$race\\Strategy.txt> not found!";
  my @stratfile = ();
  while (<STRATFILE>) {
    if (/^$stratname\t/) {
      push(@stratfile, AssembleTable($strattable, $optarrayref));
      push(@stratfile, "\n");
    }
    else {
      push(@stratfile, $_);
    }
  }
  close(STRATFILE);
  open(STRATFILE, ">$version\\$race\\Strategy.txt") or die "File <$version\\$race\\Strategy.txt> could not be opened for writing!";
  print STRATFILE @stratfile;
  close(STRATFILE);
  @stratfile = ();
  open(AIFILE, "$version\\$race\\BuildSequence.ai") or die "File <$version\\$race\\BuildSequence.ai> not found!";
  my @aifile = ();
  while (<AIFILE>) {
    if (/\bfunction\s*init_strategy_$stratname\b/) {
      while ((<AIFILE> or die "Strategy not complete in Build Sequence") !~ /endfunction/) {}
      while ((<AIFILE> or die "Strategy not complete in Build Sequence") !~ /endfunction/) {}
      push(@aifile, "function init_strategy_$newstratname takes nothing returns nothing\n");
      push(@aifile, $inittext->get('1.0', 'end'));
      push(@aifile, "endfunction\n");
      push(@aifile, "function build_sequence_$newstratname takes nothing returns nothing\n");
      push(@aifile, "if tier == $#buildtexttier then\n");
      for(my $i=$#buildtexttier;$i>2;$i--) {
        my $j = $i-1;
        push(@aifile, $buildtexttier[$i]->get('1.0', 'end'));
        push(@aifile, "elseif tier == $j then\n");
      }
      push(@aifile, $buildtexttier[2]->get('1.0', 'end'));
      push(@aifile, "else\n");
      push(@aifile, $buildtexttier[1]->get('1.0', 'end'));
      push(@aifile, "endif\n");
      push(@aifile, "endfunction\n");
    }
    else {
      push(@aifile, $_);
    }
  }
  close(AIFILE);
  open(AIFILE, ">$version\\$race\\BuildSequence.ai") or die "File <$version\\$race\\BuildSequence.ai> could not be opened for writing!";
  print AIFILE @aifile;
  close(AIFILE);
  $edit->destroy;
}

sub SaveProfile {
  my ($edit, $profiletable, $version, $profilename, $optarrayref) = @_;
  my $newprofilename = $profiletable->get(0,1)->get;
  open(PROFILEFILE, "$version\\Profiles.txt") or die "File <$version\\Profiles.txt> not found!";
  my @profilefile = ();
  while (<PROFILEFILE>) {
    if (/^$profilename\t/) {
      push(@profilefile, AssembleTable($profiletable, $optarrayref));
      push(@profilefile, "\n");
    }
    else {
      push(@profilefile, $_);
    }
  }
  close(PROFILEFILE);
  open(PROFILEFILE, ">$version\\Profiles.txt") or die "File <$version\\Profiles.txt> could not be opened for writing!";
  print PROFILEFILE @profilefile;
  close(PROFILEFILE);
  $edit->destroy;
}

sub EditRacialBuilds {
  my ($main, $ver, $race) = @_;
  my $edit = $main->Toplevel(-title => 'AMAI Racial Builds Editor');
  my $lframe = $edit->Frame->pack(-side => 'left');
  my $rframe = $edit->Frame->pack(-side => 'right');
  my $textheight = 22;
  $lframe->Label(-text => 'Initalisation Code')->pack;
  my $inittext = $lframe->Scrolled('TextUndo', -scrollbars => 'se', -wrap => 'none', -height => $textheight)->pack;
  $lframe->Label(-text => "Build Code")->pack;
  my $buildtext = $lframe->Scrolled('TextUndo', -scrollbars => 'se', -wrap => 'none', -height => $textheight)->pack;
  LoadRacialBuild($inittext, $buildtext, $ver, $race);
  $rframe->Button(
                -text => 'OK',
                -command => sub {SaveRacialBuild($edit, $inittext, $buildtext, $ver, $race)},
                -width => 6)->pack;
  $rframe->Button(
                -text => 'Cancel',
                -command => [$edit => 'destroy'],
                -width => 6)->pack;
  $edit->focusForce;
}

sub LoadRacialBuild {
  my ($inittext, $buildtext, $ver, $race) = @_;
  open(AIFILE, "$ver\\$race\\BuildSequence.ai") or die "File <$ver\\$race\\BuildSequence.ai> not found!";
  my $line;
  while ((<AIFILE> or die "global_init_strategy not in Build Sequence") !~ /function global_init_strategy/) {}
  while (($line = (<AIFILE> or die "global_init_strategy not complete in Build Sequence")) !~ /endfunction/) {$inittext->insert('end', $line);}
  while ((<AIFILE> or die "global_build_sequence not in Build Sequence") !~ /function global_build_sequence/) {}
  while (($line = (<AIFILE> or die "global_build_sequence not complete in Build Sequence")) !~ /endfunction/) {$buildtext->insert('end', $line);}
  close(AIFILE);
}

sub SaveRacialBuild {
  my ($edit, $inittext, $buildtext, $ver, $race) = @_;
  open(AIFILE, "$ver\\$race\\BuildSequence.ai") or die "File <$ver\\$race\\BuildSequence.ai> not found!";
  my @aifile = ();
  while (<AIFILE>) {
    if (/\bfunction\s*global_init_strategy\b/) {
      while ((<AIFILE> or die "Global Builds not complete in Build Sequence") !~ /endfunction/) {}
      while ((<AIFILE> or die "Global Builds not complete in Build Sequence") !~ /endfunction/) {}
      push(@aifile, "function global_init_strategy takes nothing returns nothing\n");
      push(@aifile, $inittext->get('1.0', 'end'));
      push(@aifile, "endfunction\n");
      push(@aifile, "function global_build_sequence takes nothing returns nothing\n");
      push(@aifile, $buildtext->get('1.0', 'end'));
      push(@aifile, "endfunction\n");
    }
    else {
      push(@aifile, $_);
    }
  }
  close(AIFILE);
  open(AIFILE, ">$ver\\$race\\BuildSequence.ai") or die "File <$ver\\$race\\BuildSequence.ai> could not be opened for writing!";
  print AIFILE @aifile;
  close(AIFILE);
  $edit->destroy;
}

sub EditSettings {
  my ($main, $file) = @_;
  my $edit = $main->Toplevel(-title => 'AMAI Settings Editor');
  my $lframe = $edit->Frame->pack(-side => 'left');
  my $rframe = $edit->Frame->pack(-side => 'right');
  my $table = $lframe->Table(-rows => 37)->pack(-side => 'left');
  my $rownumber = LoadSettings($table, $file);
  $rframe->Button(
                -text => 'OK',
                -command => sub {SaveSettings($edit, $table, $file, $rownumber)},
                -width => 6)->pack;
  $rframe->Button(
                -text => 'Cancel',
                -command => [$edit => 'destroy'],
                -width => 6)->pack;
  $edit->focusForce;
}

sub LoadSettings {
  my ($table, $file) = @_;
  open(SETTINGS, $file) or die "File <$file> not found!";
  <SETTINGS>;
  my $i = 0;
  while(<SETTINGS>) {
    chomp;
    my @setting = split "\t", $_;
    my $l = $table->Label(-text => $setting[0]);
    $table->put($i, 0, $l);
    $l = $table->Entry(-width => 25);
    $l->insert('end', $setting[1]);
    $table->put($i, 1, $l);
    $l = $table->Label(-text => $setting[2]);
    $table->put($i, 2, $l);
    $i++;
  }
  close(SETTINGS);
  return $i;
}

sub SaveSettings {
  my ($edit, $table, $file, $rownumber) = @_;
  open(SETTINGS, ">$file") or die "File <$file> could not be opened for writing!";
  print SETTINGS "Variable Setting\tValue\tComment\n";
  for(my $i=0;$i<$rownumber;$i++) {
    my $setting = $table->get($i, 0)->cget('-text');
    my $value = $table->get($i, 1)->get;
    my $comment = $table->get($i, 2)->cget('-text');
    print SETTINGS "$setting\t$value\t$comment\n";
  }
  close(SETTINGS);
  $edit->destroy;
}
