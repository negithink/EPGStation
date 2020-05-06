set -e

# DIRnameの最後にスラッシュは不要
REMOTE=daisen
SRC_DIR=/mnt/tmphdd/TV_m2ts
DIST_DIR=/mnt/tmphdd/TV_mp4
WORK_DIR=/Users/negithink/Repo/note/2020-05-06/work
FILE_EXP=*.m2ts
EXEC_SH=/Users/negithink/Repo/EPGStation/config/exec.sh

# get m2ts for encode 
oldest_file=`ssh $REMOTE ls -tr $SRC_DIR/$FILE_EXP | head -1`
oldest_fullpath=$SRC_DIR+$oldest_file

scp $REMOTE:$oldest_fullpath $WORK_DIR/

# encode
eval $EXEC_SH 


