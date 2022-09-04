#! /usr/bin/perl5 -w

use strict;
use Tk;

my $main = MainWindow->new(-title => 'AMAI Table Changes');
my $lframe = $main->Frame->pack(-side => 'left');
my $rframe = $main->Frame->pack(-side => 'right');
my $ver;
open(VERFILE, "Versions.txt") or die "File <Versions.txt> not found!";
my @vers = <VERFILE>;
chomp foreach (@vers);
my $veropt = $lframe->Optionmenu(
                -variable => \$ver,
                -width => 6)->pack;
$veropt->addOptions(@vers);

$rframe->Button(
                -text => 'Apply Table Changes',
                -command => sub {
                  ApplyTableChanges($ver);
				  #UpdateLuaScript($ver);
                  ApplyBuildSequenceChanges($ver);
                  CreateNewFiles($ver);
                  UpdateSettings($ver);
                },
                -width => 17)->pack;

$rframe->Button(
                -text => 'Quit',
                -command => [$main => 'destroy'],
                -width => 17)->pack;

MainLoop;

sub ApplyTableChanges {
  my $ver = shift;
  system "Templates\\MakeMake.bat $ver";
  open(TABLEDEFS, "Templates\\TableDefs.ini") or die "File <Templates\\TableDefs.ini> not found!";
  <TABLEDEFS>;
  my @tabledef = <TABLEDEFS>;
  chomp foreach (@tabledef);
  @tabledef = ExtendTable('', @tabledef);
  foreach (@tabledef) {
    /([^\t]*)\t(.*)/;
    my $table = "$ver\\$1";
    my $def = $2;
    my $race = '';
    $race = $1 if (/([^\\]*)\\/);
    CheckTable($table, $def, $race);
  }
}

# sub UpdateLuaScript {
	# my $ver = shift;
	# open(LUAFILE, "LuaScripts.ini") or die "File <> not found!";
	# <LUAFILE>;
	# my @line = <LUAFILE>;
	# close(LUAFILE);
	# return $ver;
# }

sub GetVarList {
  my ($var, $race) = @_;
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
  my ($race, @table) = @_;
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
          foreach (GetVarList($var, $race)) {
            my $itrep = $it;
            $itrep =~ s/\$$var\$/$_/;
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

sub CheckTable {
  my ($tablefile, $def, $race) = @_;
  open(DEFTABLE, $def) or die "File <$def> not found!";
  <DEFTABLE>;
  my @defs = <DEFTABLE>;
  close(DEFTABLE);
  chomp foreach (@defs);
  @defs = ExtendTable($race, @defs);
  my @header = ();
  my %defval;
  foreach (@defs) {
    /([^\t]*)\t(.*)/;
    push @header, $1;
    $defval{$1} = $2;
  }
  my @table = ReadTable($tablefile);
  my %reported;
  foreach my $row (@table) {
    foreach (@header) {
      unless(defined $row->{$_}) {
        $row->{$_} = $defval{$_};
        unless(defined $reported{$_}) {
          $reported{$_} = 1;
          print "Added new column $_ to $tablefile\n";
        }
      }
    }
  }
  WriteTable($tablefile, \@header, @table);
}

sub ReadTable {
  my $tablefile = shift;
  open(TABLE, $tablefile) or die "File <$tablefile> not found!";
  my $headerline = <TABLE>;
  my @table = <TABLE>;
  close(TABLE);
  chomp foreach (@table);
  chomp($headerline);
  my @header = split "\t", $headerline;
  my @tout = ();
  foreach (@table) {
    my @r = split "\t", $_;
    my $x = 0;
    my %row;
    foreach (@header) {
      $row{$_} = $r[$x];
      $x++;
    }
    push @tout, \%row;
  }
  return @tout;
}

sub WriteTable {
  my ($tablefile, $headerref, @table) = @_;
  my @header = @{$headerref};
  open(TABLE, ">$tablefile") or die "File <$tablefile> could not be opened for writing!";
  my $headerline = join "\t", @header;
  print TABLE "$headerline\n";
  foreach (@table) {
    my %row = %{$_};
    my @rowline = ();
    push @rowline, $row{$_} foreach (@header);
    my $r = join "\t", @rowline;
    print TABLE "$r\n";
  }
  close(TABLE);
}

sub ApplyBuildSequenceChanges {
  my $ver = shift;
  open(RACES, "$ver\\Races.txt") or die "File <$ver\\Races.txt> not found!";
  my @races = <RACES>;
  close(RACES);
  foreach (@races) {
    /([^\t]*)\t/;
    $_ = $1;
  }
  foreach (@races) {
    my $race = $_;
    open(TIERFILE, "$ver\\$race\\Tiers.txt") or die "File <$ver\\$race\\Tiers.txt> not found!";
    my @tiers = <TIERFILE>;
    my $tiernum = @tiers;
    close(TIERFILE);
    open(BUILDSEQUENCE, "$ver\\$race\\BuildSequence.ai") or die "File <$ver\\$race\\BuildSequence.ai> not found!";
    my @seq = <BUILDSEQUENCE>;
    close(BUILDSEQUENCE);
    open(BUILDSEQUENCE, ">$ver\\$race\\BuildSequence.ai") or die "File <$ver\\$race\\BuildSequence.ai> could not be opened for writing!";
    my $ifdelcame = 0;
    foreach (@seq) {
      if(/^if tier == \b(\w*)\b/) {
        if($1 > $tiernum) {
          $ifdelcame = 1;
        }
        elsif($1 < $tiernum) {
          print BUILDSEQUENCE "if tier == $tiernum then\n";
          for(my $i = $tiernum - 1; $i >= $1; $i--) {
            print BUILDSEQUENCE "elseif tier == $i then\n"
          }
        }
        else {
          print BUILDSEQUENCE $_;
        }
      }
      elsif($ifdelcame) {
        if (/elseif tier == $tiernum/) {
          print BUILDSEQUENCE "if tier == $tiernum then\n";
          $ifdelcame = 0;
        }
      }
      else {
        print BUILDSEQUENCE $_;
      }
    }
    close(BUILDSEQUENCE);
  }
}

sub CreateNewFiles {
  my $ver = shift;
  open(PROFILESDEF, "Templates\\Profiles.def") or die "File <Templates\\Profiles.def> not found";
  <PROFILESDEF>;
  my @profilesdef = <PROFILESDEF>;
  close(PROFILESDEF);
  @profilesdef = ExtendTable('', @profilesdef);
  foreach (@profilesdef) {
    chomp;
    /[^\t]*\t(.*)/;
    $_ = $1;
  }
  open(NEWFILE, ">$ver\\New.aip") or die "File <$ver\\New.aip> not found";
  print NEWFILE "#AMAI 2.0 Profile\n";
  print NEWFILE join "\t", @profilesdef;
  print NEWFILE "\n";
  close(NEWFILE);

  open(STRATEGYDEF, "Templates\\Strategy.def") or die "File <Templates\\Strategy.def> not found";
  <STRATEGYDEF>;
  my @strategydef = <STRATEGYDEF>;
  close(STRATEGYDEF);  
  open(RACES, "$ver\\Races.txt") or die "File <$ver\\Races.txt> not found!";
  my @races = <RACES>;
  close(RACES);
  foreach (@races) {
    /([^\t]*)\t/;
    $_ = $1;
  }
  foreach my $race (@races) {
    my @stratdef = ExtendTable($race, @strategydef);
    foreach (@stratdef) {
      chomp;
      /[^\t]*\t(.*)/;
      $_ = $1;
    }
    
    open(TIERFILE, "$ver\\$race\\Tiers.txt") or die "File <$ver\\$race\\Tiers.txt> not found!";
    my @tiers = <TIERFILE>;
    my $tiernum = @tiers;
    close(TIERFILE);
    
    open(NEWFILE, ">$ver\\$race\\New.ais") or die "File <$ver\\$race\\New.ais> not found";
    print NEWFILE "#AMAI 2.0 Strategy\n";
    print NEWFILE join "\t", @stratdef;
    print NEWFILE "\n";
    print NEWFILE "function init_strategy_$stratdef[0] takes nothing returns nothing\n";
    print NEWFILE "// Insert strategy init code here.\n";
    print NEWFILE "\nendfunction\n";
    print NEWFILE "function build_sequence_$stratdef[0] takes nothing returns nothing\n";
    print NEWFILE "if tier == $tiernum then\n";
    print NEWFILE "// Insert tier$tiernum goals here.\n";
    for(my $i = $tiernum - 1; $i > 1; $i--) {
      print NEWFILE "elseif tier == $i then\n";
      print NEWFILE "// Insert tier$i goals here.\n";
    }
    print NEWFILE "else\n";
    print NEWFILE "// Insert tier1 goals here.\n";
    print NEWFILE "endif\n";
    print NEWFILE "endfunction\n";
    close(NEWFILE);
  }
}

sub UpdateSettingsFile {
  my ($file, $marker) = @_;
  my %oldsettings;
  open(SETTINGS, $file) or die "File <$file> not found";
  while (<SETTINGS>) {
    /^([^\t]*)\t/;
    $oldsettings{$1} = 1;
  }
  close(SETTINGS);
  open(SETTINGS, ">>$file") or die "File <$file> not found";
  open(COMMON, "common.eai") or die "File <common.eai> not found";
  my $in_settings = 0;
  while (<COMMON>) {
    if ($in_settings) {
      if (/\#PRAGMA END $marker/) {
        $in_settings = 0;
      }
      else {
        if (/\s*\w+\s+(\w+)\s*=\s*(\-?\w+\.?\w*)\s*\/\/\s*(.*)/) {
          unless ($oldsettings{$1}) {
            print SETTINGS "$1\t$2\t$3\n";
            print "Adding setting $1 to <$file>\n";
          }
        }
      }
    }
    else {
      $in_settings = 1 if (/\#PRAGMA START $marker/);
    }
  }
  close(COMMON);
  close(SETTINGS);
}

sub UpdateSettings {
  my $ver = shift;
  UpdateSettingsFile("$ver\\GlobalSettings.txt", "VERSION SETTINGS");
  open(RACES, "$ver\\Races.txt") or die "File <$ver\\Races.txt> not found!";
  my @races = <RACES>;
  close(RACES);
  foreach (@races) {
    /([^\t]*)\t/;
    $_ = $1;
  }
  foreach (@races) {
    UpdateSettingsFile("$ver\\$_\\Settings.txt", "RACIAL SETTINGS");
  }
}
