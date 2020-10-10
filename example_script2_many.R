# MelodyFeatures R package for extraction of melody features from MIDI format
library(tuneR)
library(MelodyFeatures)

# make sure you set the working directory to the current directory! 
# In the menu click Session -> choose working directory -> to Source file location

path1="dir_midi_files/" #you shoud have unzipped a folder with example files. Otherwise, put here the name of a folder with midi files of your choice
# if you want to compare multiple groups, consider multiple folders, and then attach the folder name as group name in the output file


f_all <- list.files(path1) #list of all the filenames in path1
features_all_files <- list()
for(file1 in f_all){

  songname=substr(file1, 0, nchar(file1)-4) #cuts away the ending .mid so the name can be used as rowname
  filen1=paste(path1, file1, sep="") # path to the midi file we want to read
  
  lengths0 <- read_convert_output_midi(filen1) #function that reads the midi
  song <- convert_midi(lengths0) # function that converts the midi to the object 'song'
  
  #For some of the features you need to decide on the tonic note. You can open the midifile (e.g. in musescore, listen to it, or use the note from the key. Attention, modal songs are often annotated as major in the midi file, so the option "key" would give a wrong tonic note in that case)
  tonic_num <- decide_tonic(lengths0, song, tonic_choice="key") # "key", "lastnote" or "question"
  
  #################################################
  # the following features are always normalized by the length of the song
  notes_occ=occurrence_notes_tonic(song, tonic_num) #how often each of the 12 half tones occurs
  notes_length=length_notes_tonic(song, tonic_num) # fraction that the melody spends on a given note
  
  intervals_occ=occurrence_intervals(song) #counts of intervals
  int_separate_startnote=intervals_separate_startnote(song, tonic_num) #counts oof intervals, starting on one of the 12 half tones of the scale
  
  occ_3grams=occurrence_3grams(song) #2 consecutive intervals
  occ_4grams=occurrence_4grams(song) # 3 consecutive intervals
  
  rh_3grams=rhythm_3grams(song, dict_rhythm_3_6()) #lengths of 3 consectuive notes
  rh_4grams=rhythm_4grams(song, dict_rhythm_4_6()) #lengths of 4 consectuive notes
  rh_5grams=rhythm_5grams(song, dict_rhythm_5_6()) #lengths of 5 consectuive notes
  rh_6grams=rhythm_6grams(song, dict_rhythm_6_4()) #lengths of 6 consectuive notes
  b_bpm=barlength_and_bpm(lengths0)
  
  all_features <- c(songname,
                    #potential group identifier (e.g. foldername) here,
                    notes_occ, 
                    notes_length, 
                    intervals_occ, 
                    int_separate_startnote, 
                    occ_3grams, 
                    occ_4grams,
                    rh_3grams,
                    rh_4grams #the last in the list has no comma
                  #  rh_5grams, #make sure you comment out the same features for labels below
                  #  rh_6grams, 
                  #  b_bpm
                  )
  
  features_all_files <- cbind(features_all_files,all_features) #binds the features of the current song to all the previous song features in the loop
} #loop over files in f_all

all_labels <- c(
  "song_name",
  #potential group category e.g. geography/century/artist etc.
  labels_occurrence_notes_tonic(), 
  labels_length_notes_tonic(), 
  labels_occurrence_intervals(),
  labels_intervals_separate_startnote(), 
  labels_3grams(), 
  labels_4grams(), 
  labels_rhythm_3_6(), 
  labels_rhythm_4_6() 
 # labels_rhythm_5_6(), 
#  labels_rhythm_6_4(), 
#  labels_barlength_and_bpm()
)

#names(all_features) <- all_labels # if only one file
ffeat=t(features_all_files) #transposes matrix
colnames(ffeat) <- all_labels

write.table(ffeat, file="testfile_many.csv", row.names = F)

#outdir="outdir_name" #this is the directory where we save the output files
#if(!dir.exists(outdir)){dir.create(outdir)}
#write.table(ffeat, file=paste(outdir,"/filename.csv", sep=""), row.names = F)
