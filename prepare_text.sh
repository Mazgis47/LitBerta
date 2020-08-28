python .initial_data/segmentation.py .initial_data/full.txt  .initial_data/_full-segmented.txt
awk '!a[$0]++' .initial_data/_full-segmented.txt > .initial_data/_full-segmented-nodup.txt
grep .initial_data/_full-segmented-nodup.txt -e '[A-Za-zĄČĘĖĮŠŲŪŽąčęėįšųūž]' > .initial_data/_fullsegmented--nodup-letters.txt
awk '{printf("%s %s\n",prev,$0);prev=$0}' .initial_data/_full-final.txt > .initial_data/_full-final-nextsent.txt
