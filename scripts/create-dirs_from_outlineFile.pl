#!/usr/bin/perl
use strict;
use warnings;

# ==============================================================================
# Help message and no-arg Error

my $usage = "
\x1B[1mUsage:\x1B[0m
	$0 <Outline File>

	<Outline File>		A file that contains the names of the
				directories, that are to be made

\x1B[1mSyntax for Outline File:\x1B[0m

	Write the directory names in the Outline File, one name per line.

	Leading spaces are interpreted as indentation.

	If a line is 'indented' more than the previous line, the directory named
	in it will be created as a child of the directory named in the previous
	line.

\x1B[1mExample for Syntax:\x1B[0m

	from the Outline File:

		folder
		 sub-folder
		  sub-sub-folder
		 not-so-sub-anymore-folder

	these directories are created:

		./folder/
		./folder/sub-folder/
		./folder/sub-folder/sub-sub-folder/
		./folder/not-so-sub-anymore-folder/";

# if no arguments are provided
if ($#ARGV == -1) {
	print "\x1B[31;1mError:\x1B[31m too few arguments provided\x1B[0m\n";
	print "$usage\n";
	exit;
}


# ==============================================================================
# Read Outline File as Array

# Outline File is provided as argument
my $outlineFile=$ARGV[0];

# Open Read Stream
open(my $in, "<", $outlineFile) or die "Couldn't read Outline File";


# ==============================================================================
# Create Folder Structure

# holds the dirs making up the path, including the dir-to-create
my @pathParts=('./');

# Read $outlineFile by line
while (my $line = <$in>) {

    # 1. Get number of Spaces at beginning of line (until a non-space is found)

	# separate line into characters
	my @chars=split(//,$line);

	my $count=0;
	for my $character (@chars) {

		# if $character is a space
		if ($character=~/\ /) {

			# increase the count
			$count += 1;

		} else {

			# break the loop
			last;
		}
	}


    # 2. Add to $pathParts in appropriate position

	# make the item that will be added to $pathParts
	# have it contain the name of the dir-to-create
	my $pathItem=$line;
	
	# remove the leading spaces from the dir-name
	$pathItem =~ s/^\ *//;

	# replace non-leading spaces with '\ '
	# $pathItem =~ s/\ /\\\ /;

	# remove possible newlines
	$pathItem =~ s/\n//;

	# add at calculated position to @pathParts
	@pathParts[$count] = $pathItem;


    # 3. Remove all items after $pathItem from $pathParts
	foreach my $ind ($count+1 .. $#pathParts) {
		delete $pathParts[$ind];
	}


    # 4. Create the actual path

	# join the dir-names together with '/' as separator
	my $path = join('/', @pathParts);

	# add '/' at the end of the path
	$path="$path/";
	

    # 5. Create directories
	mkdir $path;

	print "\x1B[36mcreated:\x1B[0m $path\n";

}


# ==============================================================================
# Close Streams

close $in
