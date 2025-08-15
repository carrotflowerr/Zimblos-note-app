# Zimblo's Own Note App (ZON)
hyper minimal note script. 

Inspired by the TempleOS note function,
Emacs *scratch* buffer


# The idea:
* (almost) no secondary prompts
 Functions instantaneously. Does not require you to save, confirm, or
 name the file.
* Operates in /tmp/ 
deletes on system reboot unless saved.
used for storing **low importance data**

# Functions
* Gpg support
* Note directory archival
* Automatic file naming
* Persistent multi-buffer management
* Under 200 lines of code

# TODO
* remove fzf as a dep
* variable to change default file extension
* rewrite in c

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

# Note
Requires fzf

zoni is a binary built with shc. zoni.sh is the source.
shc -f zoni.sh -o zoni


The note file is a bash script. I reccomending putting it in your path. ex `/usr/bin`

It does not require root access. 

It is especially useful on window managers. I bind to `$mod+n` 

Automatic file naming is done by measuring the frequency of the words in the file. It then sorts out words found in `stopwords.` This file has the 100 most common english words. Adding words to this file will sort them out.

`zoni.sh` is the same, but it uses a simple interface instead of op commands.

<<<<<<< HEAD
=======
See [nb](https://github.com/xwmx/nb), a similar project.
>>>>>>> 6eaae160a6f7ae09667d97d94aaae4719db281c6
