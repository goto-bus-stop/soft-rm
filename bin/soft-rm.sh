#!/bin/bash

VERSION=0.0.1

# gets the full path to a given file
# used for turning cli arguments into absolute paths
softrm_fullpath() {
  echo "$(cd "$(dirname -- "$1")" && pwd -P)/$(basename -- "$1")"
}

# gets the trash directory
softrm_trashdir() {
  echo ~/.softrm-trash/
}

# gets the original path of a given soft-deleted file
softrm_restorepath() {
  head -1 "$1.meta"
}

# gets the path to a trashed file for a given file name
softrm_trashpath() {
  echo "$(softrm_trashdir)$(echo "$1" | md5sum | cut -d' ' -f 1)"
}

# soft-deletes a file by effectively moving it to a different directory
softrm_remove() {
  local file="$(softrm_fullpath "$1")"
  local trash_file="$(softrm_trashpath "$1")"
  local meta_file="${trash_file}.meta"
  ln "$file" "${trash_file}"
  echo "$file" > "$meta_file"
  # actually delete
  rm -- "$file"
}

# restores a soft-deleted file
# $1 the soft-deleted file
softrm_restore() {
  local trash_file="$(softrm_trashpath "$1")"
  if [ -e "$trash_file" ]
  then
    softrm_restore_to "$trash_file" "$(softrm_restorepath "$trash_file")"
  fi
}

# restores all soft-deleted files
softrm_restore_all() {
  find "$(softrm_trashdir)"* -not -name "*.meta" | while read trash_file
  do
    softrm_restore_to "$trash_file" "$(softrm_restorepath "$trash_file")"
  done
}

# restores a soft-deleted file to the given location
# $1 the soft-deleted file
# $2 the location to restore to
softrm_restore_to() {
  ln "$1" "$2"
  # clean up
  rm -- "$1" "$1.meta"
  echo "restored $2 from $1"
}

# for-real deletes a soft-deleted file
# $1 the soft-deleted file
softrm_flush() {
  local trash_file="$(softrm_trashpath "$1")"
  rm -- "$trash_file" "$trash_file.meta"
}

# for-real deletes all soft-deleted files
softrm_flush_all() {
  rm -- "$(softrm_trashdir)"*
}

softrm_version() {
  rm --version
  echo
  echo "soft-rm version $VERSION (https://github.com/goto-bus-stop/soft-rm)"
}

# initializes softrm
softrm_init() {
  mkdir -p "$(softrm_trashdir)"
}

softrm_init

# main
case "$1" in
  --version)
    softrm_version
    ;;
  --get-dir)
    softrm_trashdir
    ;;
  --restore)
    softrm_restore "$2"
    ;;
  --restore-all)
    softrm_restore_all
    ;;
  --flush)
    softrm_flush "$2"
    ;;
  --flush-all)
    softrm_flush_all
    ;;
  *)
    softrm_remove "$1"
    ;;
esac