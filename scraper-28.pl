use strict;
use warnings;
use Getopt::Std;
use LWP::Simple;


$| = 1;

sub main {

	my %opts;
	
	# Get command line options
	getopts('u:r', \%opts);
	
	# if you do not insert any parameter
	if(!checkusage(\%opts)) {
		usage();
		exit();
	} 
	
	my $input_dir = $opts{"u"};
	
	my @images = get_images($input_dir);
	
	print "You want to download images? [Y]es/[N]o: ";
	
	$a = <STDIN>;
	
	chop $a;
	
	unless ($a eq 'y' || $a eq 'Y' || $a eq 'n' || $a eq 'N') { 
		
		print "Wrong choice! Insert (Y)es or (N)o\n";
		
	}
	
	
	if ($a eq 'y' || $a eq 'Y')
	
	{
	
		my $count = 0;
		
		foreach my $image (@images)
		
		{	
			$count++;
			
			# you have to create a folder called images first
			getstore($image, "images/$count.jpg");
			
			print "downloaded $image --> $count.jpg\n";
			
		}

						
	} elsif ($a eq "n" || $a eq "N")
	
		{
		
			print "\n Ok, but check your file output.txt!\n";
		
		}
	
}


## --------- FUNCTIONS ------------- ##
	
	
sub get_images {
	
	my $input_dir = shift;
		
	#get html code of url
	my $content = get($input_dir);

	unless ( defined($content) ) {
		
		die "Unreachable url\n";
			
	}
		
	my $output_file = "output.txt";
		
	open OUTPUT, '>'.$output_file or die "Cannot create output file $output_file.\n";

	# array with all urls of images in html page (regexp)
	my @images = $content =~ m|img src="([^"']*?)"|ig;
		
	if(@images == 0) {
		
		print "Any image urls found!\n";
		
	} else {
		
		foreach my $img(@images) {
		
			#printed output file saved in current directory
			print OUTPUT "$img\n";
		
		}
	
	}
	
	print "-->Found " . scalar (@images) . " urls with images!\n";
			
	return @images;
			
	
}
	
	
sub checkusage {

	my $opts = shift;
	
	my $r = $opts->{"r"};
	my $u = $opts->{"u"};
	
	# r is optional, means run
	
	# here, we define u mandatory.
	unless(defined($u)) {
		return 0;
	}
	
	return 1;
}
	
	
sub usage {
	
	print <<USAGE;
	
usage: perl main.pl <options>
	-u <url>	specify url in which to find and download files (insert http/https first).
	-r run the program; process urls

example usage:
	# Search and download images in gazzetta.it
	perl main.pl -u www.gazzetta.it -r
	
USAGE
	
}


main();
