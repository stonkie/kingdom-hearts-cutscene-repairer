#!/usr/bin/env bash

for f in $(find "$1" -maxdepth 10 -type f -name '*.mp4') 
do 
  echo "Repairing $f"
  
  unset moovoffset

  if [[ "$f" == *kh015.mp4 ]]
  then
    echo "File $f is filtered out"
  elif [[ "$f" == *kh027.mp4 ]]
  then
    echo "File $f is filtered out"
  elif [[ "$f" == *kh150.mp4 ]]    
  then
    echo "File $f is filtered out"
  elif [[ "$f" == *kd803.mp4 ]]    
    then
      echo "File $f is filtered out"
  elif [[ "$f" == *opn.mp4 ]]    
      then
        echo "File $f is filtered out"
  elif [[ "$f" == *zz_event_084.mp4 ]]    
        then
          echo "File $f is filtered out"
  elif [[ "$f" == *zz_event_140.mp4 ]]    
          then
            echo "File $f is filtered out"
  else
    moovoffset=$(grep --only-matching --byte-offset --max-count=1 -a -o --perl-regexp "\x6D\x6F\x6F\x76" "$f" | grep -oP '^\d+' -m 1)    
    echo "moovoffset=$moovoffset"
  fi

  if [ -z "$moovoffset" ]
  then
    echo "File $f has no moov, cannot repair"
    
    if [ "$2" == "-clean" ]
    then
      rm "$f"  
    fi
  else
    printf "\x00\x00\x00\x1C\x66\x74\x79\x70\x69\x73\x6F\x6D\x00\x00\x02\x00\x69\x73\x6F\x6D\x69\x73\x6F\x32\x61\x76\x63\x31\x00\x00\x00\x08\x66\x72\x65\x65\x00\x00\x00\x00\x6D\x64\x61\x74" | dd of=$f bs=1 seek=0 conv=notrunc 2> /dev/null
    mdatsize=$(echo $((moovoffset - 40)) | xargs printf '%08x')
    echo "mdatsize=$mdatsize"
    printf "\x${mdatsize:0:2}\x${mdatsize:2:2}\x${mdatsize:4:2}\x${mdatsize:6:2}" | dd of="$f" bs=1 seek=36 count=4 conv=notrunc 2> /dev/null
  fi
done
