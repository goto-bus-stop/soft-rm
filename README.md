soft-rm
-------

`soft-rm` is a small wrapper around `rm` that does not remove files. It's like a recycle bin for the command line.

## Usage

* `soft-rm file` "soft-deletes" the given file.
* `soft-rm --restore file` restores the given file, if possible.
* `soft-rm --flush file` actually, irreversibly, for-real deletes a previously soft-deleted file.
* `soft-rm --restore-all` restores all soft-deleted files.
* `soft-rm --flush-all` actually, irreversibly, for-real deletes all previously soft-deleted files.

You can also add `soft-rm --flush-all` to your init scripts if you like.

## Limitations (for now)

* does not work across file systems
* "trash" directory is not configurable
* does not support most of the `rm` cli arguments

## Licence

[MIT](LICENSE)