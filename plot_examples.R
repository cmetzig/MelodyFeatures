
# to plot average notes and intervals on a set of melodies



df_single <- read.csv("testfile.csv", sep=" ")# file with features of many melodies, where each line is one melody, and first column the song_name

cnames=colnames(df_single)[14:25]
pdf("NoteLengths_example_single.pdf")
barplot(height=as.numeric(df_single[,14:25]), names.arg=cnames, las=2 ,beside=T,ylim=c(0,0.3),xlab="notes",ylab="fraction oof time spent on note", col=color.names,axis.lty="solid")
dev.off()

# read in a file with many songs:
df <- read.csv("testfile_many.csv", sep=" ")# file with features of many melodies, where each line is one melody, and first column the song_name

# Now we compare the songs how prevalent is the motive 'r121' in them (e.g. eight note - fourth note - eighth note)
index_r121=which(colnames(df)=='r121')
df[,index_r121] #the columnof the dataframe that corresponds to a given feature

####################################
avnotes=sapply(14:25, function(x){return(mean(df[,x]))})
color.names="blue"
cnames=colnames(df)[14:25]
pdf("NoteLengths_example_many.pdf")
barplot(height=avnotes, names.arg=cnames, las=2 ,beside=T,ylim=c(0,0.3),xlab="notes",ylab="fraction oof time spent on note", col=color.names,axis.lty="solid")
dev.off()

avints=sapply(26:75, function(x){return(mean(df[,x]))})
cnamesi=colnames(df)[26:75]

pdf("Intervals_example_many.pdf")
barplot(height=avints, names.arg=cnamesi, las=2 , font.lab=1 ,beside=T,ylim=c(0,0.3),xlab="intervals",ylab="intervals", col=color.names,axis.lty="solid")
dev.off()
