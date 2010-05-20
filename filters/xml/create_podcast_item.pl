#!/usr/bin/perl -w
use strict;
#input:
# title |  File

my $line = <STDIN>;

chomp $line;
my $file = '';
my $title = '';

if ($line =~ m/^(.*) \| (.*)$/){
    $title = $1;
    $file = $2;
}

print "
    <item>
      <title>$title</title>
      <description>$title</description>
      <pubDate>Tue, 02 Feb 2010 21:34:16 -0500</pubDate>
      <link></link>
      <guid>$file</guid>
      <enclosure url=\"$file\" type=\"audio/mpeg\"/>
    </item>";
