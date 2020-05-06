#/bin/zsh 

set -e


# DIRnameの最後にスラッシュは不要
REMOTE=daisen
SRC_DIR=/mnt/tmphdd/TV_m2ts
SRC_BACKUP_SUCCESS_DIR=/tmp/tmphdd/TV_m2ts/success_ts
SRC_BACKUP_FAILED_DIR=/tmp/tmphdd/TV_m2ts/failed_ts
DIST_DIR=/mnt/tmphdd/TV_m2ts/success_mp4
WORK_DIR=/Users/negithink/Repo/note/2020-05-06/work
FILE_EXP=*.m2ts
EXEC_SH=/Users/negithink/Repo/EPGStation/config/exec.sh

# get m2ts for encode 
oldest_fullpath=`ssh $REMOTE ls -tr $SRC_DIR/$FILE_EXP | head -1`
oldest_file=$(echo $oldest_fullpath |rev|cut -d '/' -f 1 |rev)
encoded_file=$(echo $oldest_fullpath |rev|cut -d '/' -f 1 |rev|cut -d '.' -f 1 ).mp4
encoded_fullpath=$DIST_DIR/$encoded_file


echo 'oldest_fullpath:'$oldest_fullpath
echo 'oldest_file:'$oldest_file
echo 'encoded_file:'$encoded_file
echo 'encoded_fullpath:'$encoded_fullpath

# scp $REMOTE:$oldest_fullpath $WORK_DIR/


# encord
export FFMPEG=`which ffmpeg`
export INPUT=$WORK_DIR/$oldest_file
export OUTPUT=$WORK_DIR/$encoded_file
export VIDEORESOLUTION=`ffprobe -v error -select_streams v:0 -show_entries stream=height -of csv=p=0 $INPUT|head -1`
export AUDIOCOMPONENTTYPE=2
export BASEBITLATE=1000 # unit:k,720x480

echo FFMPEG: $FFMPEG
echo INPUT: $INPUT
echo OUTPUT: $OUTPUT
echo VIDEORESOLUTION: $VIDEORESOLUTION
echo AUDIOCOMPONENTTYPE: $AUDIOCOMPONENTTYPE
echo BASEBITLATE: $BASEBITLATE

node enc.js

# push to remote
dist_fullpath=$WORK_DIR/$encoded_file
echo scp $WORK_DIR/$encoded_file $REMOTE:$dist_fullpath

echo ssh $REMOTE mv $oldest_fullpath $SRC_BACKUP_SUCCESS_DIR/