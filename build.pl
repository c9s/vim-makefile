#!/usr/bin/env perl
open FH  , "<" , "record.vim";
my @lines = <FH>;
chomp(@lines);
close FH;
open OUT,">" ,"record.vim.out";
my $cnt = 0;
for (@lines) {
    s/^"/#/;
    s/"/\\"/g;
    s/\\n/\\\\n/g;
    print OUT qq{echo "$_" };
    print OUT qq{ > .record\n} if $cnt == 0 ;
    print OUT qq{ >> .record\n} if $cnt > 0 ;
    $cnt++;
}
close OUT;
print "record.vim.out\n";
