

#SCRIPT_DIR=`pwd`

function GetScriptDir() {
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
      TARGET="$(readlink "$SOURCE")"
      if [[ $TARGET == /* ]]; then
        #echo "SOURCE '$SOURCE' is an absolute symlink to '$TARGET'"
        SOURCE="$TARGET"
      else
        DIR="$( dirname "$SOURCE" )"
        #echo "SOURCE '$SOURCE' is a relative symlink to '$TARGET' (relative to '$DIR')"
        SOURCE="$DIR/$TARGET" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
      fi
    done
    #echo "SOURCE is '$SOURCE'"
    RDIR="$( dirname "$SOURCE" )"
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    #if [ "$DIR" != "$RDIR" ]; then
    #  echo "DIR '$RDIR' resolves to '$DIR'"
    #fi
    #echo "DIR is '$DIR'"

    SCRIPT_DIR=$DIR

}


GetScriptDir
echo $SCRIPT_DIR


PATH=$SCRIPT_DIR:$PATH

IMAGE_NAME=image

NEW_IMAGE_NAME=new_image

#openssl md5 -binary model.conf; (cat model.conf; perl -e '$s=`cat model.conf | wc -c`; print "\x00"x(8-$s%8)') | openssl enc -des-ecb -nopad -K 478DA50BF9E3D2CF) > squashfs-root/web/oem/model.conf
(openssl md5 -binary model.conf; (cat model.conf; perl -e '$s=`cat model.conf | wc -c`; print "\x00"x(8-$s%8)') | openssl enc -des-ecb -nopad -K 478DA50BF9E3D2CF) > squashfs-root/web/oem/model.conf

mksquashfs4 squashfs-root/ $IMAGE_NAME-rootfs-nopad -noappend

ROOTFS_SIZE=$(wc -c $IMAGE_NAME-rootfs.orig | cut -f1 -d' ')
echo $ROOTFS_SIZE

NEW_ROOTFS_SIZE=$(wc -c $IMAGE_NAME-rootfs-nopad | cut -f1 -d' ')
echo $NEW_ROOTFS_SIZE

perl -e "print \`cat $IMAGE_NAME-rootfs-nopad\` . \"\xff\"x($ROOTFS_SIZE-$NEW_ROOTFS_SIZE)" > $IMAGE_NAME-rootfs

lzma -c $IMAGE_NAME-kernel-decompress -c > $IMAGE_NAME-kernel

tpl-tool -b $IMAGE_NAME -o $NEW_IMAGE_NAME.bin
