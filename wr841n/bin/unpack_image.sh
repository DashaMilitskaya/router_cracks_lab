

IMAGE_PATH=$1

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
cp "$IMAGE_PATH" $IMAGE_NAME

tpl-tool -x $IMAGE_NAME

mv $IMAGE_NAME-rootfs $IMAGE_NAME-rootfs.orig
mv $IMAGE_NAME-bootldr $IMAGE_NAME-bootldr.orig
mv $IMAGE_NAME-kernel $IMAGE_NAME-kernel.orig

sasquatch -s $IMAGE_NAME-rootfs.orig
sasquatch $IMAGE_NAME-rootfs.orig

lzma -d $IMAGE_NAME-kernel.orig -c >$IMAGE_NAME-kernel-decompress.orig


tail -c +17 squashfs-root/web/oem/model.conf | openssl enc -d -des-ecb -nopad -K 478DA50BF9E3D2CF >model.conf

