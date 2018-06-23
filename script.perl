#!/usr/bin/perl

$directoryPath = "/Users/tarun/Desktop/venky";

# stores the input parameters
@inputParameterList = getInputFromFile();
print "@inputParameterList";

# stores the output-- missed files..
$missedFileIndex = 0;
@missedFileList = ();

# find all the missed files and stores in @missedFileList array
for($i=0; $i < @inputParameterList; $i++){
	getMissedFileList($directoryPath,$inputParameterList[$i]);
}

print "@missedFileList";
writeOutputToFile();

sub writeOutputToFile {
	my $outfile = 'output.txt';

	# here i 'open' the file, saying i want to write to it with the '>>' symbol
	open (FILE, ">> $outfile") || die "problem opening $outfile\n";

	for($i=0; $i < @missedFileList; $i++){
		print FILE "$missedFileList[$i++]\n";
	}
	# i close the file when there's nothing else i want to write to it
	close(FILE);
}


sub getInputFromFile {
	my $index  = 0;
	my $filename = 'input.txt';
	my @list = ();
	open(my $fh, '<:encoding(UTF-8)', $filename)
	  or die "Could not open file '$filename' $!";
	 
	while (my $row = <$fh>) {
	  chomp $row;
	  $list[$index++] = $row;
	}
	return @list;
}

sub getMissedFileList {
	my $dir = @_[0];
	my $name = @_[1];

	opendir DIR,$dir;
	my @dir = readdir(DIR);
	close DIR;
	
	my @dir = sort(@dir);
	
	my $extenstion = "";
	my @fileList = ();
	my $i = 0;

	foreach(@dir){
	    if (-f $dir . "/" . $_ ){
			if (index($_, $name) != -1) {
			   $fileList[$i] = $_;
			   $i++;
			}    	
	    }
	}

	my @fileIdList = (); 
	my $i = 0;
	foreach my $element (@fileList) {
	    my @splitList =  split('_',$element);
	    my $withExt = $splitList[1];
	    my @withOutExtList = split('\.',$withExt);
	    $extenstion = $withOutExtList[1];
	  	my $fileId = $withOutExtList[0] + 0;
	  	$fileIdList[$i] = $fileId;
	  	$i++;		
	}


	my @sortedFileIdList = reverse sort { $a <=> $b } @fileIdList;

	my $size = @sortedFileIdList;

	for( $i = 0; $i < $size - 1; $i++) {
		$index = $sortedFileIdList[$i];
		$index2 = $sortedFileIdList[$i+1];
		for($j = $index-1; $j > $index2; $j-- ){
			$missedFileList[$missedFileIndex++] = $name."_$j.$extenstion";
		}
	}

	@missedFileList = sort(@missedFileList);
}