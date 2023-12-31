# Kingdom Hearts Cutscene Repair Tool For SteamDeck

[Kingdom Heart HD 1.5+2.5 ReMIX](https://store.epicgames.com/en-US/p/kingdom-hearts-hd-1-5-2-5-remix) is available on the Epic store and can be installed on the SteamDeck (and Linux in general) through [Heroic Launcher](https://heroicgameslauncher.com/).

However, there is a problem... The cutscenes don't work!

# Current situation

The MP4 cutscenes are corrupted. I managed to repair a good portion of them, but they only play with VLC or some other player. They **will not play within the game**, I believe because of this issue (I get the same arch issues with gstreamer looking for avcodec libs) : https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher/issues/1291

My current script repairs about half of the cutscenes. Use the -clean flag to delete the remaining broken files and allow the games to at least play those that are repaired (take a backup).

I do intend on working to fix the remaining half by improving on a relatively generic MP4 repair tool. I might see what I can do about making them play within the game after that...

## How to run

1. Open Desktop Mode (if you're not using a SteamDeck, just turn ON the Linux box :) )
1. Copy the [repair.sh](https://github.com/stonkie/kingdom-hearts-cutscene-repairer/blob/main/repair.sh) file from this repository into the `/home/deck/Games/Heroic/KH_1.5_2.5/EPIC` directory. 
    1. You may want to make a backup copy of the EPIC directory just in case.
1. Open a terminal in that directory (right click on repair.sh and the option should be there) 
1. Run the following command `chmod a+x repair.sh`
1. Run the following command `./repair.sh . -clean`

# What is broken in those files?

The main issue seems to be that the start of the MP4 files are either corrupted or in a format neither me not most media players recognize.

The bash script overwrites the beginning of the MP4 files with a valid equivalent and that repairs a certain proportion of the files.

## Why are some cutscenes still broken then?

Some of the files were formatted in a way where important information was supposed to be at the beginning of the files. And that's just not there.

That important information is a "moov box" header. We see the content is actual present in those files, but it's missing too much of the header to be repairable this easily. We need to repair the header with a custom crafted bit of binary that recreates the parts of the header that were corrupted.

I planned on fixing everything though bash to make it safe. The code is pretty easy to read and assess for security risks. Creating custom binary strings however is a bit complicated in bash, so I will likely switch to a full fledged programming language to implement the fix.