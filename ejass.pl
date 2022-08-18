#!/usr/bin/perl -w
use strict;

unless ( $ARGV[0] and $ARGV[0] !~ /-[h?]/ ) {
	print "------------------------------------------------------\n";
	print "|\n|     Jass Pre-parser version 0.0.11\n";
	print "|\n|                 by Vidstige\n";
	print "|\n|       see http://www.wc3campaigns.com/forums/showthread.php?s=&threadid=38726\n";
	print "|\n|     Usage:";		
	print "\n|        $0 sourcefile [> destinationfile]\n";		
	print "|\n|     Example:";		
	print "\n|        $0 extended_script.eai > script.ai";		
	print "\n|        $0 extended_script.eai\n";		
	print "|\n|     Supported Directives:";		
	print "\n|        #DEFINE var";		
	print "\n|        #UNDEF var";		
	print "\n|        #IFDEF var";		
	print "\n|        #IFNDEF var";		
	print "\n|        #ELSE";		
	print "\n|        #ENDIF";		
	print "\n|        #INCLUDE <filename>";		
	print "\n|        #INCLUDETABLE <filename> #COND %1 eq \"humans\"   // eq == equals";		
	print "\n|        #INCLUDETABLE <filename> #COND %1 ne \"monster\"  // ne == not equals";		
	print "\n|             // %ROW == line number in table file (counting all lines)";
	print "\n|             set MyArray[%ROW] = %1";
	print "\n|             // %row == line number in table file (counting included lines)";
	print "\n|             set MyOtherArray[%row + 5] = %2  ";          
	print "\n|        #ENDINCLUDE\n";
	print "|\n|     Syntactic Shortcuts (some of them...):";		
	print "\n|        i=42 -> set i = 42";	
	print "\n|        i++ -> set i = i + 1";	
	print "\n|        i+=42 -> set i = i + 42";		
	print "\n|        Sleep(2) -> call Sleep(2)";		
	print "\n------------------------------------------------------\n";
	exit;
}

binmode(STDOUT, ":utf8");

my $tab = "\t";
my $level = 0;
my @file;
my %defs;
my $skip = "";
my %vdefs;
my %searchtrees;
my $scriptname = $0;

foreach (@ARGV[1..$#ARGV]) {
  if (/([^:]*):(.*)/) {
    $vdefs{$1} = $2;
  }
  else {
    $defs{$_} = 1;
  }
}

$file[$level]{"if"} = "#IFNDEF";
$file[$level]{"then"} = 1;
$file[$level]{"else"} = "";
$file[$level]{"now"} = "then";
$file[$level]{"skip"} = "";

open(INFILE, $ARGV[0]) or die "File <$ARGV[0]> not found!";

#warn "$level <$skip> " . $file[$level]{"if"} . " " . $file[$level]{"now"} . " :";
while (<INFILE>) {
	$_ = fnamerep($_) unless /\#DEFINE/;
	if (/^\/\//) {}
	elsif (/#PRAGMA/) {}
	elsif (/(#IFDEF) (\w+)/) {
		#warn "IFDEF";
		$level++;
		$file[$level]{"if"} = $1;
		$file[$level]{"then"} = $defs{$2};  
		#warn "$2:<$defs{$2}>";
		$file[$level]{"else"} = not $defs{$2};  
		#warn ("not $2:<" . (not $defs{$2}) . ">");
		$file[$level]{"now"} = "then";
		$file[$level]{"skip"} = $skip;
		$skip = (not $file[$level]{$file[$level]{"now"}} or $file[$level]{"skip"});
	}
	elsif (/(#IFNDEF) (\w+)/) {
		#warn "IFNDEF";
		$level++;
		$file[$level]{"if"} = $1;
		$file[$level]{"then"} = not $defs{$2};  
		#warn "$2:<$defs{$2}>";
		$file[$level]{"else"} = $defs{$2};  
		#warn ("not $2:<" . (not $defs{$2}) . ">");
		$file[$level]{"now"} = "then";
		$file[$level]{"skip"} = $skip;
		$skip = (not $file[$level]{$file[$level]{"now"}} or $file[$level]{"skip"});
	}
	elsif (/#ELSE/) {
		#warn "ELSE";
		$file[$level]{"now"} = "else";
		$skip = ((not $file[$level]{$file[$level]{"now"}}) or $file[$level]{"skip"});
	}
	elsif (/#ENDIF/) {
		#warn "ENDIF";
		$file[$level]{"now"} = "none";
		$level--;
		$skip = ((not $file[$level]{$file[$level]{"now"}}) or $file[$level]{"skip"});
	}
	elsif (/#DEFINE \$(\w+)\$ (\w+)/) {
		$vdefs{$1} = $2 unless $skip;
	}
	elsif (/#DEFINE (\w+)/) {
		$defs{$1} = 1 unless $skip;
	}
	elsif (/#UNDEF (\w+)/) {
		delete $defs{$1} unless $skip;
	}
	elsif (not $skip) {
		if (/#INCLUDE <([^>]*)>/) {
			open(FILE, $1) or die "File <$1> not found!";
			my @include;
			print (@include = <FILE>);
			close(FILE);
		}
		elsif (/#INCLUDESCRIPT <([^>]*)>/) {
		  my $fn = $1;
		  my $scriptargs = '';
		  $scriptargs = "$scriptargs $_" foreach (keys %defs);
		  $scriptargs = "$scriptargs $_:$vdefs{$_}" foreach (keys %vdefs);
		  system "perl \"$scriptname\" \"$fn\" $scriptargs";
		}
		elsif (/#INCLUDETABLE <(.+?)>(?: #ENC:([^ \t\n\r]+))?( #NOUTF8)?( #EFR)?(?: #COND (.+))?/) {
			my $fn = $1;
			my $enc = $2;
			my $noutf8 = $3;
			my $efr = $4;
			my $cond = $5;
			$cond = 1 if not $cond;
			binmode(STDOUT, ":raw") if $noutf8;
			#print $cond;
			#$cond = fnamerep($cond);
			my @line = "";
			my $i = 0;
			my $format = "";
			my $incllevel = 0;
			while ((($format = <INFILE>) !~ /#ENDINCLUDE/) or $incllevel > 0) {
				if ($format !~ /^\/\//) {
					$incllevel++ if $format =~ /#INCLUDETABLE/;
					$incllevel-- if $format =~ /#ENDINCLUDE/;
					chomp($format);
					$line[$i] = $format;
					$i++;
				}
			}
			if ($enc) {
			  open(TABLE, "<:encoding($enc)", $fn) or die "File <$fn> not found!";
			}
			else {
			  open(TABLE, $fn) or die "File <$fn> not found!";
			}
			if ($efr) {
				my $table = <TABLE>;
			}
			my @alltable = <TABLE>;
			close(TABLE);
			tableincl(\@line, \@alltable, $cond, $efr);
			binmode(STDOUT, ":utf8") if ($noutf8);
		}
		elsif (/#SEARCHTREE (\w+) <(.+?)> %(\w+) %(\w+) ([^\s]*)%([0-9]+)([^\s]*)( #EFR)?(?: #COND (.+))?/) {
		  my $tn = $1;
		  my $fn = $2;
		  my $idcol = $3;
		  my $priocol = $4;
		  my $prefuncadd = $5;
		  my $funccol = $6;
		  my $postfuncadd = $7;
		  my $efr = $8;
			my $cond = $9;
			$cond = 1 if not $cond;
		  my @list = ();
		  open(TABLE, $fn) or die "File <$fn> not found!";
		  <TABLE> if ($efr);
		  while(<TABLE>) {
		    my @tvals = split /[\t\r\n]/;
		    push @tvals, '';
		    my $condrep = tablerep($cond,\@tvals,0);
		    push @list, {'name' => $tvals[$idcol-1], 'value' => $tvals[$priocol-1], 'function' => "$prefuncadd$tvals[$funccol-1]$postfuncadd"} if (eval($condrep));
		  }
		  close(TABLE);
		  $searchtrees{$tn} = CreateSearchTree(@list);
		}
		elsif (/#SEARCHLIST (\w+)/) {
		  my $tn = $1;
		  my @content = ();
		  my $line = <INFILE>;
		  my $row = 0;
		  while($line !~ /#ENDSEARCHLIST/) {
		    push @content, $line;
		    $line = <INFILE>;
		  }
		  foreach (GetSearchNodeList($searchtrees{$tn})) {
		    my $s = $_->{'name'};
		    foreach (@content) {
		      my $cline = $_;
  		    $cline =~ s/\%1/$s/g;
  		    $cline =~ s/\%row/$row/g;
  		    print $cline;
		    }
 		    $row++;
		  }
		}
		elsif (/#SEARCHCODE (\w+) (\w+)/) {
		  my ($p, $n) = GetSearchCode($searchtrees{$1}, 0, $2);
		  print $p;
		}
		else {
			print;
		}
	}
}

sub tableincl {
	my $lineref = shift;
	my @line = @{$lineref};
	my $alltableref = shift;
	my @alltable = @{$alltableref};
	my $cond = shift;
	my $efr = shift;
	my $kalt = 1;
	my $afterinclude = -1;
	my @forstack = ();
	foreach my $table (@alltable) {
		if ($table!~/^#/) {
			my @tl= split /[\t\r\n]/, $table;
			push @tl, '';
			my $condrep = tablerep(incloeval($cond), \@tl, $kalt);
			if (eval($condrep)) {
				for(my $i=0; $i<=$#line; $i++) {
					my $format = $line[$i];
					if ($format =~ /#DEFINE \$([^\$]*)\$ (.*)/) {
					  $vdefs{$1} = incleval(tablerep(incloeval($2), \@tl, $kalt));
					}
					elsif ($format =~ /#FOR \$([^\$]*)\$ FROM \$([^\$]*)\$ TO \$([^\$]*)\$/) {
					  if ((@forstack == 0) || ($forstack[$#forstack] != $i)) {
					    $vdefs{$1} = $vdefs{$2};
					    push @forstack, $i;
					  }
					  elsif ($vdefs{$1} < $vdefs{$3} - 1) {
					    $vdefs{$1}++;
					  }
					  else {
					    $forstack[$#forstack] = -1;
					    $vdefs{$1} = $vdefs{$3};
					  }
					}
					elsif ($format =~ /#ENDFOR/) {
					  if ($forstack[$#forstack] == -1) {
					    pop @forstack;
					  }
					  else {
					    $i = $forstack[$#forstack] - 1;
					  }
					}
					else {
					  $format = fnamerep($format);
  					if ($format =~ /#INCLUDETABLE <([^>]+)>(?: #ENC:([^ \t\n\r]+))?( #NOUTF8)?( #EFR)?(?: #COND (.+))?/) {
  						my $fn = incleval(tablerep(incloeval($1), \@tl, $kalt));
  						my $enc = $2;
  						$enc = incleval(tablerep(incloeval($enc), \@tl, $kalt)) if ($enc);
							my $noutf8 = $3;
  						my $efr = $4;
  						my $cond = $5;
  						$cond = 1 if not $cond;
        			binmode(STDOUT, ":raw") if $noutf8;
  						my $j = $i+1;
  						my $incllevel = 0;
  						while($line[$j] !~ /#ENDINCLUDE/ or $incllevel > 0) {
  							$incllevel++ if ($line[$j] =~ /#INCLUDETABLE/);
  							$incllevel-- if ($line[$j] =~ /#ENDINCLUDE/);
  							$j++;
  						}
        			if ($enc) {
        			  open(TABLE, "<:encoding($enc)", $fn) or die "File <$fn> not found!";
        			}
        			else {
        			  open(TABLE, $fn) or die "File <$fn> not found!";
        			}
  						if ($efr) {
  							my $table = <TABLE>;
  						}
  						my @alltable = <TABLE>;
  						close(TABLE);
  						my @line = @line[$i+1..$j-1];
  						tableincl(\@line, \@alltable, $cond, $efr);
  						binmode(STDOUT, ":utf8") if ($noutf8);
  						$i = $j;
  					}
  					elsif ($format =~ /#AFTERINCLUDE/) {
  						$afterinclude = $i+1;
  						$i = $#line;
  					}
  					elsif ($format =~ /#INCLUDESCRIPT <([^>]*)>/) {
        		  my $fn = incleval(tablerep(incloeval($1), \@tl, $kalt));
        		  my $scriptargs = '';
        		  $scriptargs = "$scriptargs $_" foreach (keys %defs);
        		  $scriptargs = "$scriptargs $_:$vdefs{$_}" foreach (keys %vdefs);
        		  system "perl \"$scriptname\" \"$fn\" $scriptargs";
		        }
  					else {
  						print(incleval(tablerep(incloeval($format), \@tl, $kalt)),"\n");
  					}
  			  }
				}
				$kalt++;
			}
		}
	}
	if ($afterinclude != -1) {
		$kalt--;
		my @tl = ();
		foreach my $format (@line[$afterinclude..$#line]) {
			print(incleval(tablerep(incloeval(fnamerep($format)), \@tl, $kalt)),"\n");
		}
	}
}

sub tablerep {
	my ($cond, $sref, $rowalt) = @_;
  $cond =~ s/%(\d+)/$sref->[$1-1]/g;
	$cond =~ s/%row/$rowalt/g;
	return $cond;
}

sub fnamerep {
	my $fn = shift;
  $fn =~ s/\$(\w*)\$/$vdefs{$1}/g;
	return $fn;
}

sub incleval {
	$_ = shift;
	s/#EVAL{([^}]*)}/eval($1)/ge;
	return $_;
}

sub incloeval {
	$_ = shift;
	s/#OEVAL{([^}]*)}/eval($1)/ge;
	return $_;
}

sub NewNode {
  my ($x, $y) = @_;
  my $z = {'value' => $x->{'value'} + $y->{'value'}, 'children' => [$x,$y]};
  return $z;
}

sub GetLowPrioPair {
  @_ = sort {$a->{'value'} <=> $b->{'value'}} @_;
  return (shift,shift,@_);
}

sub CreateSearchTree {
  my @list = @_;
  while (@list > 1) {
    (my $x, my $y, @list) = GetLowPrioPair(@list);
    my $z = NewNode($x, $y);
    push @list, $z;
  }
  return $list[0];
}

sub GetSearchNodeList {
  my $node = shift;
  if ($node->{'children'}) {
    my @nl = ();
    push @nl, GetSearchNodeList($node->{'children'}[0]);
    push @nl, GetSearchNodeList($node->{'children'}[1]);
    return @nl;
  }
  else {
    return $node;
  }
}

sub GetSearchCode {
  my ($node, $weight, $dvar) = @_;
  if ($node->{'children'}) {
    my ($s1,$nw1) = GetSearchCode($node->{'children'}[0], $weight, $dvar);
    my ($s2,$nw2) = GetSearchCode($node->{'children'}[1], $nw1, $dvar);
    return "if $dvar < $nw1 then\n$s1 else\n$s2 endif\n", $nw2;
  }
  else {
    my $s = $node->{'function'};
    return "call $s\n", $weight + 1;
  }
}