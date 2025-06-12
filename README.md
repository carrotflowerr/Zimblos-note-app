# Zimblo's Own Note App (ZON)
hyper minimal note script. 

Inspired by the TempleOS note function,
Emacs *scratch* buffer


The idea:
* functions instantaneously
* does not require you to save. 
* deletes on system reboot unless saved
* used for storing **low importance data**

# requires:
- fzf
- ed
- stopwords file

# Configure

Add the following to the -X option if your gpg is configured for text mode

``` 

GPG_TTY=$(tty)
export GPG_TTY
gpg --pinentry-mode loopback --symmetric "$chosenFile"

```

`~/.gnupg/gnu.conf`
use-agent
pinentry-mode loopback

`~/.gnupg/gpg-agent.conf`
allow-loopback-pinentry

# Options

```
$ zon -h
Usage: zon [OPTION]
Options:
  -d      Delete the note file
  -s      Save file to /home/shell/.note. (automatic naming)
  -f      Name file and save.
  -h      Show help message
  -e      Edit the note file
  -E      Edit from note directory
  -P      Print from note directory
  -i      Run ispell on the buffer
  -X      Encrypt
  -w      Open stopwords
  -A      Archive /home/shell/.note
```

`

# Opts
By default, it opens a temporary buffer. 
`/tmp/note`

`-d` will delete this temporary buffer.

`-s` will save it based on the word frequency of the document

`-f` takes input to name

`-e` will open the temporary file in `ed`

both:
`-E` and `-o`
will search the note directory with fzf and prompt for a file. `-E` will open for editing, `-o` will simply print the file.

`-A` will zip the files with tar and back them up. `~/Documents/` is the default location.


# Note
The note file is a bash script. I reccomending putting it in your path. ex `/usr/bin`

It does not require root access. 

It is especially useful on window managers. I bind to `$mod+n` 

Automatic file naming is done by measuring the frequency of the words in the file. It then sorts out words found in `stopwords.` This file has the 100 most common english words. Adding words to this file will sort them out.

`zoni.sh` is the same, but it uses a simple interface instead of op commands.

See [nb](https://github.com/xwmx/nb), a similar project.
