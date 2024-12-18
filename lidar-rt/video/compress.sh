#!/usr/bin/env bash

SOURCE_DIR="raw"
TARGET_DIR="compressed"

# check if the source dir and target dir exist
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Source directory $SOURCE_DIR does not exist"
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    mkdir -p "$TARGET_DIR"
    echo "Created target directory $TARGET_DIR"
fi

# check the subdirs in the source dir
for subdir in $(ls $SOURCE_DIR); do
    echo "Processing $subdir"
    # check if the subdir is a directory
    if [ -d "$SOURCE_DIR/$subdir" ]; then
        # check if the subdir exists in the target dir
        if [ ! -d "$TARGET_DIR/$subdir" ]; then
            mkdir -p "$TARGET_DIR/$subdir"
        fi

        # compress the videos in the subdir
        for f in $SOURCE_DIR/$subdir/*.mp4; do
            # 如果文件名中包含 "compressed"，则跳过
            if [[ $f == *"compressed"* ]]; then
                echo "Skipping $f because it already contains 'compressed'"
                continue
            fi

            # 获取文件名
            file_name=$(basename $f)

            # 对视频进行压缩，输出文件名加上前缀 "compressed_"
            ffmpeg -i "$f" -vcodec libx264 -crf 23 -preset medium -c:a copy "$TARGET_DIR/$subdir/compressed_$file_name" -y
        done
    fi
done
