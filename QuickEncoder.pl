#!/usr/bin/perl
use strict;
use warnings;
use File::Find;

# pass language folder argument to translate

my $dirname = $ARGV[0];
my $dir = "./Languages/$dirname/";
find(\&convert, $dir);

sub convert {
    my $file = $_;
    return unless -f $file; # skip directories and other non-files
    system("piconv -f CP-1251 -t UTF-8 < $file > $file.utf8"); 
    rename("$file.utf8", $file); 
}