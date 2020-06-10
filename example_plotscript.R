
# to plot average notes and intervals on a set of melodies
df <- read.csv("filename.csv", sep=" ")# file with features of many melodies, where each line is one melody, and first column the song_name

avnotes=sapply(2:13, function(x){return(mean(df[,x]))})
color.names="darkgreen"

cnames=colnames(df)[2:13]
pdf("NoteLengths_example.pdf")
barplot(height=avnotes, names.arg=cnames, las=2 ,beside=T,ylim=c(0,0.3),xlab="notes",ylab="fraction oof time spent on note", col=color.names,axis.lty="solid")
dev.off()

avints=sapply(26:75, function(x){return(mean(df[,x]))})
cnamesi=colnames(df)[26:75]

pdf("Intervals_example.pdf")
barplot(height=avints, names.arg=cnamesi, las=2 , font.lab=1 ,beside=T,ylim=c(0,0.3),xlab="intervals",ylab="intervals", col=color.names,axis.lty="solid")
dev.off()
