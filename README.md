# file-processing tools for Linux
### Simple bash .sh scripts
Tested on Manjaro. Easely to update to your linux distro.

- **Creating folders by list.zip** — create an empty folders structure by list in text file. Usage: `bash createfolders.sh folders.txt`;
- **Create folders from existing mp3 files list.zip** — create a folders structure from existing mp3 list of files. Put mp3 to /src/ and run `bash script-without-moving-files.sh /src/` and get a new folders structure. With/without moving existing files to newely created folders;
- **Delete content but keep the folders.zip**  — usage `bash delfolders.sh /temp/` — allowing to wipe content from all subfolders;
- **proxify.sh** — create a proxified list of folders and empty files according to *.tsv file — usage `bash proxify.sh Files.tsv`

### Audio files processing (aiff, mp3)
Simple tools for merging files in subfolders (especially after CD rips). Merges segmentated audio files (like 01-Track.mp3, 02-Track-mp3, 03-Track.mp3) into single song as single audio (First-Song.mp3).
Suggested algorhytms: sox, cat, ffmpeg.
Some scripts containing renamer (to pre-rename files before merging) — it's handling in some cases to avoid misordering of files started with digits.
