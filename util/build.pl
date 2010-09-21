#!/usr/bin/env perl
open FH  , "<" , "template/record.vim";
my @lines = <FH>;
chomp(@lines);
close FH;

my $cnt = 0;
my $content = "";
for (@lines) {
    next if m/^"/;
    s/\\/\\\\\\\\/g;
    s/"/\\"/g;
    $content .= qq{\t\t\@echo "$_" };
    $content .= qq{ >  \$(RECORD_SCRIPT)\n} if $cnt == 0 ;
    $content .= qq{ >> \$(RECORD_SCRIPT)\n} if $cnt > 0 ;
    $cnt++;
}

open IN, "< template/Makefile.tpl";
local $/;
my $makefile = <IN>;
$makefile =~ s/{{Script}}/$content/s;
close IN;

open OUT,">" ,"Makefile";
print OUT $makefile;
close OUT;
close OUT;
