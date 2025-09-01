#!/usr/bin/perl

use strict;
use warnings;
use IO::Prompter;
use Data::Dumper;

main();

sub main
{
    my $passphrase = inputPassphrase();

    my @devices = getLinesFromFile("/etc/cryptsetup-zfs/devices");
    foreach my $device (@devices)
    {
	print "INFO: decrypting device $device\n";
	luksOpen($device, $passphrase);
	print "\n";
    }

    my @pools = getLinesFromFile("/etc/cryptsetup-zfs/pools");
    foreach my $pool (@pools)
    {
	print "INFO: importing pool \'$pool\'\n";
	print "CMD: zpool import $pool\n";
	system "zpool", "import", $pool;
	print "\n";

	print "INFO: showing zpool status\n";
	print "CMD: zpool status\n";
	system "zpool", "status";
	print "\n";
    }
}

sub getLinesFromFile
{
    my $file = shift;

    my @lines;

    open IN, "<$file";
    chomp (@lines = <IN>);
    close IN;

    return @lines;
}

sub luksOpen
{
    my $device_fullPath = shift;
    my $passphrase = shift;

    my $device_crypt = (split "/", $device_fullPath)[-1] . "_crypt";

    print "CMD: cryptsetup luksOpen $device_fullPath $device_crypt\n";

    open
	my $pipe,
	'|-',
	"/usr/sbin/cryptsetup",
	"luksOpen",
	$device_fullPath,
	$device_crypt;

    print $pipe $passphrase;

    close $pipe;
}

sub inputPassphrase
{
    my $passphrase = prompt("Enter passphrase: ", -echo => '*');
    chomp $passphrase;
    return $passphrase;
}
