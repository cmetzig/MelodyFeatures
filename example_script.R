# MelodyFeatures
R package for extraction of melody features from MIDI format
library(tuneR)
library(MelodyFeatures)

path1="dir_midi_files/"
outdir="outdir_name"
if(!dir.exists(outdir)){dir.create(outdir)}

f_all <- list.files(path1)
features_all_files <- list()
for(file1 in f_all){
  
  filen1=paste(path1, file1, sep="")
  
  lengths0 <- read_convert_output_midi(filen1)
  lengths1 <- convert_midi(lengths0) 
  tonic_num <- decide_tonic(lengths0, lengths1, tonic_choice="key") # key, lastnote or question
  
  #################################################
  notes_occ=occurrence_notes_tonic(lengths1, tonic_num)
  notes_length=length_notes_tonic(lengths1, tonic_num)
  
  intervals_occ=occurrence_intervals(lengths1)
  int_separate_startnote=intervals_separate_startnote(lengths1, tonic_num)
  
  occ_3grams=occurrence_3grams(lengths1)
  occ_4grams=occurrence_4grams(lengths1)
  
  rh_3grams=rhythm_3grams(lengths1, dict_rhythm_3_6())
  rh_4grams=rhythm_4grams(lengths1, dict_rhythm_4_6())
  rh_5grams=rhythm_5grams(lengths1, dict_rhythm_5_6())
  rh_6grams=rhythm_6grams(lengths1, dict_rhythm_6_4())
  b_bpm=barlength_and_bpm(lengths0)
  
  all_features <- c(file1,
                    notes_occ, 
                    notes_length, 
                    intervals_occ, 
                    int_separate_startnote, 
                    occ_3grams, 
                    occ_4grams,
                    rh_3grams, 
                    rh_4grams, 
                    rh_5grams, 
                    rh_6grams, 
                    b_bpm)
  
  features_all_files <- cbind(features_all_files,all_features)
} #loop over files

all_labels <- c(
  "song_name",
  labels_occurrence_notes_tonic(), 
  labels_length_notes_tonic(), 
  labels_occurrence_intervals(),
  labels_intervals_separate_startnote(), 
  labels_3grams(), 
  labels_4grams(), 
  labels_rhythm_3_6(), 
  labels_rhythm_4_6(), 
  labels_rhythm_5_6(), 
  labels_rhythm_6_4(), 
  labels_barlength_and_bpm())

#names(all_features) <- all_labels # if only one file
ffeat=t(features_all_files) #transposes matrix
colnames(ffeat) <- all_labels
write.table(ffeat, file=paste(outdir,"/filename.csv", sep=""), row.names = F)
