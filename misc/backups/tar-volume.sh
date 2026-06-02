#! /bin/bash

# Based on
# https://unix.stackexchange.com/questions/504610/tar-splitting-into-standalone-volumes
# https://linuxsay.com/t/how-to-create-tar-multi-volume-by-using-the-automatic-rename-script-provided-in-the-manual-of-gnu-tar/2862/2
# https://www.gnu.org/software/tar/manual/html_node/Multi_002dVolume-Archives.html
#
# Usage:
# tar -c -M -L 128M -H posix -f somearchive.tar -F './tar-volume.sh' somefolder
# tar -x -f somearchive.tar -F './tar-volume.sh' .
#
# To list the contents of say the 3rd archive volume:
# tar -tf /backup/somearchive.tar-3
# To extract a specific archive volume:
# tar -xf /backup/somearchive.tar-3
# To extract from a specific archive volume:
# tar -xf ~/BackupsTest/20220828.tar-11 -M
# then whe will ask for more and you put 'n path/to/file'


# For this script it's advisable to use a shell, such as Bash,
# that supports a TAR_FD value greater than 9.

echo Preparing volume $TAR_VOLUME of $TAR_ARCHIVE
name=`expr $TAR_ARCHIVE : '\(.*\)\(-[0-9]*\)$'`

case $TAR_SUBCOMMAND in
-c)       ;;
-d|-x|-t) test -r ${name:-$TAR_ARCHIVE}-$TAR_VOLUME || exit 1
          ;;
*)        exit 1
esac

echo ${name:-$TAR_ARCHIVE}-$TAR_VOLUME >&$TAR_FD
