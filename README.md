# file-processing tools for Linux

Tested on Manjaro. Easely to update to your linux distro.

- **Creating folders by list.zip** — create an empty folders structure by list in text file. Usage: `bash createfolders.sh folders.txt`
- **Create folders from existing mp3 files list.zip** — create a folders structure from existing mp3 list of files. Put mp3 to /src/ and run `bash script-without-moving-files.sh /src/` and get a new folders structure. With/without moving existing files to newely created folders.
- **Delete content but keep the folders.zip**  — usage `bash delfolders.sh /temp/`
- **proxify.sh** — create a proxified list of folders according to *.tsv file — usage `bash proxify.sh Files.tsv`
