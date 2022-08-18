#!/usr/bin/perl -w
use strict;
use warnings;

unless ( $ARGV[0] and $ARGV[0] !~ /-[h?]/ ) {
	print "------------------------------------------------------\n";
	print "|\n|     Jass Optimizer\n";
	print "|\n|                 by AIAndy\n";
	print "|\n|     Usage:";		
	print "\n|        $0 libraryfile file1 ...\n";		
	print "|\n|     Example:";		
	print "\n|        $0 common.ai script.ai";		
	print "\n|        $0 Blizzard.j mapscript.j\n";		
	print "\n------------------------------------------------------\n";
	exit;
}

my $libfile = $ARGV[0];
my @scriptfiles;
my @stringrefs = ();
my %constants;
my %requires;
my %local_requires;
my %keywords;
my %used_global;
my %used_local;
my %no_rename;
my %varmap;
my $varmapnum = 0;
my $opt_blizzard = 0;

if ($ARGV[0] eq '-b') {
  $libfile = $ARGV[1];
  $opt_blizzard = 1;
}
else {
  if ($ARGV[1] eq '-l') {
    @scriptfiles = AssembleScriptNames($ARGV[2], $ARGV[3]);
  }
  else {
    @scriptfiles = @ARGV[1..$#ARGV];
  }
  open(KEYWORDS, 'keywords.txt') or die "File <keywords.txt> not found!";
  while (<KEYWORDS>) {
    chomp;
    $keywords{$_} = 1;
  }
  close(KEYWORDS);
  
  open(NORENAME, 'NoRename.txt') or die "File <NoRename.txt> not found!";
  while (<NORENAME>) {
    chomp;
    $no_rename{$_} = 1;
  }
  close(NORENAME);
  
  open(COMMON, 'common.j') or die "File <common.j> not found!";
  my @common = <COMMON>;
  AddKeywords(\@common,1);
  undef @common;
  close(COMMON);
}

open(LIBFILE, $libfile) or die "File <$libfile> not found!";
my @lib = <LIBFILE>;
close(LIBFILE);

StringsToRef(\@lib);
RemoveComments(\@lib);
RemoveWhitespace(\@lib);
RemoveIfFalseThen(\@lib);

unless ($opt_blizzard) {
  GetConstants(\@lib);
  AddKeywords(\@lib,0);
  ParseObjects(\@lib,\%requires);
  
  foreach my $scriptname (@scriptfiles) {
    open(SCRIPTFILE, $scriptname) or die "File <$scriptname> not found!";
    my @script = <SCRIPTFILE>;
    close(SCRIPTFILE);
    
    %local_requires = ();
    %used_local = ();
    
    StringsToRef(\@script);
    RemoveComments(\@script);
    RemoveWhitespace(\@script);
    RemoveIfFalseThen(\@script);
    ParseObjects(\@script,\%local_requires);
    MarkUsedObjects('main');
    RemoveUnusedObjects(\@script, \%used_local);
    MakeVarNamesShort(\@script);
    RefToStrings(\@script);
    
    open(SCRIPTFILE, ">$scriptname") or die "File <$scriptname> could not be opened for writing!";
    print SCRIPTFILE @script;
    close(SCRIPTFILE);
  }
  
  RemoveUnusedObjects(\@lib, \%used_global);
  MakeVarNamesShort(\@lib);
}

RefToStrings(\@lib);
open(LIBFILE, ">$libfile") or die "File <$libfile> could not be opened for writing!";
print LIBFILE @lib;
close(LIBFILE);

sub AssembleScriptNames {
  my ($tablefile, $template) = @_;
  my @scripts = ();
  open(TABLE, $tablefile) or die "File <$tablefile> not found!";
  while (<TABLE>) {
    my @columns = split /[\t\n]/;
    push @scripts, tablerep($template, \@columns);
  }
  close(TABLE);
  return @scripts;
}

sub tablerep {
	my ($cond, $sref) = @_;
  $cond =~ s/\$(\d+)/$sref->[$1-1]/g;
	return $cond;
}

sub StringsToRef {
  my $fileref = shift;
  foreach (@{$fileref}) {
    s/((?:\"(?:[^\"]|(?:\\\"))*\")|(?:\'(?:[^\"]|(?:\\\"))*\'))/AddToRefTable($1)/ge;
  }
}

sub AddToRefTable {
  push @stringrefs, shift;
  return "%$#stringrefs%";
}

sub RefToStrings {
  my $fileref = shift;
  foreach (@{$fileref}) {
    s/\%(\d+)\%/$stringrefs[$1]/g;
  }
}

sub RemoveComments {
  my $fileref = shift;
  foreach (@{$fileref}) {
    s/\/\/[^\n]*//;
  }
}

sub RemoveWhitespace {
  my $fileref = shift;
  foreach (@{$fileref}) {
    s/(\s)+/$1/g;
    s/[\ \t\f]([=<>!()\[\],+\-*\/])/$1/g;
    s/([=<>!()\[\],+\-*\/])[\ \t\f]/$1/g;
    s/^\s//;
  }
}

sub RemoveIfFalseThen {
  my $fileref = shift;
  my $iniffalse = 0;
  foreach (@{$fileref}) {
    if ($iniffalse) {
      if (/elseif(.*)/) {
        $iniffalse = 0;
        $_ = "if$1\n";
      }
      elsif (/endif/) {
        $iniffalse = 0;
        $_ = '';
      }
    }
    elsif (/if false then/) {
      $iniffalse = 1;
      $_ = '';
    }
  }
}

sub GetConstants {
  my $fileref = shift;
  foreach (@{$fileref}) {
    if (/endglobals/) {
      return
    }
    elsif (/constant \w+ (\w+)=(.*)/) {
      $_ = '';
      $constants{$1} = $2;
    }
  }
}

sub AddKeywords {
  my ($fileref, $doaddvars) = @_;
  foreach (@{$fileref}) {
    if (/type\s+(\w+)\s+extends/) {
      $keywords{$1} = 1;
    }
    elsif (/native\s+(\w+)/) {
      $keywords{$1} = 1;
    }
    elsif ($doaddvars) {
      if (/endglobals/) {
        $doaddvars = 0;
      }
      elsif (/\w+\s+(\w+)\s+=/) {
        $keywords{$1} = 1;
      }
    }
  }
}

sub ParseObjects {
  my ($fileref, $requiredref) = @_;
  my $current_func = '';
  my $current_req = {};
  my %current_locals = ();
  my $in_globals = 0;
  foreach (@{$fileref}) {
    if (/endglobals/) {
      $in_globals = 0;
    }
    elsif (/globals/) {
      $in_globals = 1;
    }
    elsif (/function (\w+) takes ((?:\w+ \w+(?:,\w+ \w+)*)|nothing) returns/) {
      $current_func = $1;
      $current_req = {};
      %current_locals = ();
      my $pars = $2;
      while ($pars =~ /\w+ (\w+)/g) {
        $current_locals{$1} = 1;
      }
    }
    elsif (/endfunction/) {
      $requiredref->{$current_func} = $current_req;
      $current_func = '';
      %current_locals = ();
    }
    elsif (/local (\w+) (\w+)=(.*)/) {
      my $t = $1;
      my $l = $2;
      my $p = $3;
      $p =~ s/([A-Za-z]\w*)/CheckObject($1, $current_req, \%current_locals)/ge;
      $current_locals{$l} = 1;
      $_ = "local $t $l=$p\n";
    }
    elsif (/local \w+(?: array)? (\w+)/) {
      $current_locals{$1} = 1;
    }
    elsif ($current_func ne '') {
      s/([A-Za-z]\w*)/CheckObject($1, $current_req, \%current_locals)/ge;
    }
    elsif ($in_globals) {
      if (/(\w+) (\w+)=(.*)/) {
        my $t = $1;
        my $l = $2;
        my $p = $3;
        my %glreq = ();
        my %clocals = ();
        $p =~ s/([A-Za-z]\w*)/CheckObject($1, \%glreq, \%clocals)/ge;
        $_ = "$t $l=$p\n";
        $requiredref->{$l} = \%glreq;
      }
      elsif (/\w+(?: array)? (\w+)/) {
        my %glreq = ();
        $requiredref->{$1} = \%glreq;
      }
    }
  }
}

sub CheckObject {
  my ($obj,$current_req,$current_locals) = @_;
  return $obj if ($keywords{$obj} or $current_locals->{$obj});
  return $constants{$obj} if (defined $constants{$obj});
  $current_req->{$obj} = 1;
  return $obj;
}

sub MarkUsedObjects {
  my $obj = shift;
  return if ($used_local{$obj} or $used_global{$obj});
  my $reqref;
  if (defined $local_requires{$obj}) {
    $reqref = $local_requires{$obj};
    $used_local{$obj} = 1;
  }
  else {
    $reqref = $requires{$obj};
    $used_global{$obj} = 1;
  }
  MarkUsedObjects($_) foreach (keys %{$reqref});
}

sub RemoveUnusedObjects {
  my ($fileref, $usedref) = @_;
  my $do_del = 0;
  my $in_globals = 0;
  foreach (@{$fileref}) {
    if (/endglobals/) {
      $in_globals = 0;
    }
    elsif (/globals/) {
      $in_globals = 1;
    }
    elsif (/function (\w+) takes ((?:\w+ \w+(?:,\w+ \w+)*)|nothing) returns/) {
      unless ($usedref->{$1}) {
        $do_del = 1;
        $_ = '';
      }
    }
    elsif (/endfunction/) {
      if ($do_del) {
        $do_del = 0;
        $_ = '';
      }
    }
    elsif ($do_del) {
      $_ = '';
    }
    elsif ($in_globals) {
      if (/\w+(?: array)? (\w+)/) {
        $_ = '' unless ($usedref->{$1});
      }
    }
  }
}

sub MakeVarNamesShort {
  my $fileref = shift;
  foreach (@{$fileref}) {
    s/([A-Za-z]\w*)/CheckRenameObject($1)/ge;
  }
}

sub CheckRenameObject {
  my $obj = shift;
  return $obj if ($keywords{$obj} or $no_rename{$obj} or length($obj)<=1 or (length($obj)<=4 and $obj !~ /^v/));
  unless ($varmap{$obj}) {
    $varmapnum++;
    $varmap{$obj} = sprintf('v%x',$varmapnum);
  }
  return $varmap{$obj};
}