

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

tpl-tool -s $1

