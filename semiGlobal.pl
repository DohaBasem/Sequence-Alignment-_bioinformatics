#This is the dynamic programming script for semi global sequence allignment
#The assumption here is that 1st sequence read is alligned horizontally while the 2nd sequence alligned vertically in the scores matrix
#!perl
use strict;
use warnings;
use List::Util qw(min max);


#Scoring Scheme
my $match=5;
my $mis=-4;
my $gap=-5;

my @ScoresMatrix;	#The scores matrix
my @scores;
my @seq1Array;	#The list of the 1st sequence read from the file
my @seq2Array;	#The list of the 2nd sequence read from the file
my $seq1Array;  	#The length of the 1st sequence read from file
my $seq2Array;		#The length of the 2nd sequence read from file
my $ID;			#The ID of the file containing the sequence pair to be read
my @ alligned1=();	#A list of the 1st sequence after allignment
my @alligned2=();	#A list of the 2nd sequence after allignment

print "Enter the file ID (1 or 2 or 3): \n";
$ID=<STDIN>;
print $ID;
if($ID==1)
{open (FileReader,"E:/bioLab2/Sequence_Pair_1.txt") or die $! ;}
elsif($ID==2)
{open (FileReader,"E:/bioLab2/Sequence_Pair_2.txt") or die $! ;}
elsif($ID==3)
{open (FileReader,"E:/bioLab2/Sequence_Pair_3.txt") or die $! ;}
else 
{open (FileReader,"E:/bioLab2/mySeq.txt") or die $! ;}

my $seq1=<FileReader>;
chomp($seq1);
@seq1Array=split("",$seq1);	#put the string into an array of characters t access them
$seq1Array=length $seq1;

my $seq2=<FileReader>;
chomp($seq2);
@seq2Array=split("",$seq2);
$seq2Array =length $seq2;


close (FileReader);

$ScoresMatrix[0][0]=0;	#Initializing top right cell with a zero
my @MAX=(0,0,0);		#This array holds the maximum score of last row/col @Max=(max_score,row#,col#)

	
	for(my $i=0;$i<=$seq2Array;$i++)
	{
	for(my $j=0;$j<=$seq1Array;$j++)
		{
			
		if($i==0 and ($j!=0))		#Initializing the the 1st row  with zeros because in semiglobal allignment we are ignoring the strating gaps of the 1st sequences
			{
			$ScoresMatrix[$i][$j]=0;
			
			
			
			}
		elsif($j==0 and ($i!=0))	#Initializing the the 1st column  with zeros because in semiglobal allignment we are ignoring the strating gaps of the 2nd sequences
			{
			$ScoresMatrix[$i][$j]=0;	
			
			}
		elsif($i!=0 and ($j!=0))	#In each cell in the scores matrix ,compute the three scores when (match occurs ,a gap in the 1st sequence ,a gap in the second seq)
			{
				
			my $V=$ScoresMatrix[$i-1][$j]+$gap; 	#Gap in the second sequence	
			my $H=$ScoresMatrix[$i][$j-1]+$gap; 	#Gap in the 1 st sequence
			#To check if it is mismatch or match
			my $D;
			if($seq2Array[$i-1] eq $seq1Array[$j-1]) #The two match
				{
					$D=$ScoresMatrix[$i-1][$j-1]+$match;
					}
			else 
			{
				$D=$ScoresMatrix[$i-1][$j-1]+$mis;
				}
			@scores=($V,$H,$D);
			
			
				
			$ScoresMatrix[$i][$j]=max(@scores);
			
			if($i==$seq2Array|$j==$seq1Array)     #If in the last row or column
			{
				if($MAX[0]<=$ScoresMatrix[$i][$j])
			{
				@MAX=($ScoresMatrix[$i][$j],$i,$j);
				}		
		
			}
			
			}
				
		}
		
		
	}
	
	print "The Scores matrix : \n";
	for(my $i=0;$i<=$seq2Array;$i++)
	{ print "\n";
	for(my $j=0;$j<=$seq1Array;$j++)
	{
		print "$ScoresMatrix[$i][$j]     ";
		}
}
	
	
	
	#Back Tracing to get the alignment of the given sequences
	#In the semi-global allignmnet since we are ignoring the end gaps in both sequences
	#So the termination point is the maximum in the last column or max in last row

	my $R=$MAX[1]; #Row Index of max Score
	my $C=$MAX[2]; #Column Index of Max score
	print "\n The Optimal score is $ScoresMatrix[$R][$C] \n";
	
	
	
	if($C<$seq1Array){
		my $TerminalGaps1=$seq1Array;
		while($TerminalGaps1>$C){
		push(@alligned1,$seq1Array[$TerminalGaps1-1]);
		push(@alligned2,"_");
		
		
		$TerminalGaps1-=1;
	}
		}
		
	if($R<$seq2Array){
		my $TerminalGaps2=$seq2Array;
		while($TerminalGaps2>$R){
		push(@alligned1,"_");
		push(@alligned2,$seq2Array[$TerminalGaps2-1]);
		$TerminalGaps2-=1;
	}
		}	
	
		
	#Since this is a semi global allignment problem ,so termination is at the cell in the last row or column with the maximum value
	while( $R!=0 or $C!=0)
	{	
		
		if($R==0)	#If the 1st row is reached ,the 1st row elements are alligned with gaps
		{
			
		push(@alligned1,$seq1Array[$C-1]);
		push(@alligned2,"_");
		print"here";
		$C=$C-1;
		
		}
		elsif($C==0)
		{
		push(@alligned1,"_");
		push(@alligned2,$seq2Array[$R-1]);
		$R=$R-1;
		print"there";
		}
		
		elsif($ScoresMatrix[$R][$C]-$gap==$ScoresMatrix[$R-1][$C])
		{	
			push(@alligned1,"_");
			push (@alligned2,$seq2Array[$R-1]);
			$R=$R-1;
			
			
			}
		elsif($ScoresMatrix[$R][$C]-$gap==$ScoresMatrix[$R][$C-1])
		{	
			push(@alligned1,$seq1Array[$C-1]);
			push (@alligned2,"_");
			
			$C=$C-1;
			
			}	
		elsif($ScoresMatrix[$R][$C]-$match==$ScoresMatrix[$R-1][$C-1])
		{	
			push(@alligned1,$seq1Array[$C-1]);
			push (@alligned2,$seq2Array[$R-1]);
			
			
			$R=$R-1;
			$C=$C-1;
			
			}	
		elsif($ScoresMatrix[$R][$C]-$mis==$ScoresMatrix[$R-1][$C-1]){
			push(@alligned1,$seq1Array[$C-1]);
			push (@alligned2,$seq2Array[$R-1]);
			
			
			$R=$R-1;
			$C=$C-1;
			
			
			}	
	
		
	}
print "\n";	
print "Before Allignment\n";	
print "The first Sequence is :\n";
print "@seq1Array\n";
print "The second Sequence is :\n";
print "@seq2Array\n";
print "\n\n";
print "After allignment\n";

my @reversed1=reverse(@alligned1);
my @reversed2=reverse(@alligned2);
	print "@reversed1\n";
	print "@reversed2\n";
	