Hello! Contained in this folder are a number of files -- code, data, and figures -- 
related to the analysis of chum returns to Spanish Bank Creek. They are divided into 
five sections:

1: The core data & analysis
	This is all written in Matlab, and is the stuff that I actually used to do the 
	analysis in 2021. .mat files are encoded in a way that is inaccessible unless 
	you use Matlab, (hence sec. 3) but .m files are just .txt files in disguise. You 
	should be able to fairly easily convert them to R or Python, should you choose.
	If I recall, I used the following auxiliary features for the analysis:
		- Statistics & Machine Learning Toolbox
		- Signal Processing Toolbox
		- Econometrics Toolbox
		- Optimization Toolbox
		- Third-party disperse() function
	You'll need to grab those to run the files as-written.
	

2: The datalogger data
	This is the data as given to me by Sandie Hollick-Kenyon (Brian Smith's 
	predecessor at DFO). It's pretty messy, and doesn't have much to it, so I'd 
	avoid using it unless you really have to. Pro tip: Point Atkinson air temps line 
	up really well with Spanish water temps, so just use them. Check the report for 
	the full explanation.
	
3: The .csv core data
	This is all the core data, but encoded in .csv format for your non-proprietary 
	convenience! SOURCES.txt refers to the columns in this file.
	
4: The figures
	In the event that you don't want to re-generate all the figures, here are the 
	ones that were used in the report, plus some extras.
	
5: The geodatabase
	This is a compressed .gdb file, readable in a GIS of your choice, which shows 
	the track of Spanish Bank Creek, all the way up past Belmont & coho release. 
	Past the top of this map is impenetrable jungle; the fish don't go up there, so
	neither	did we.
	
All the data we received is here, with one exception: West Van's returns. John 
Barker is super helpful & will give you the data if you ask, but he doesn't like it 
being spread around because developers have used it as justification for trashing 
the "unimportant" streams in the past.

If you need to contact me, just ask the Scarths, Michael Lipsen, or Tara Ivanochko; 
they'll send you my way. I hope this stuff comes in useful for you.

Happy coding,
- Mark Pope, 18 April 2021


