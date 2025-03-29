# Zimblo's Note App
hyper minimal note script. 

Inspired by the TempleOS note function,
Emacs *scratch* buffer


The idea:
* functions instantaneously
* does not require you to save. 
* deletes on system reboot unless saved
* used for storing **low importance data**



# Options
```

$  note -h
Usage: note [OPTION]
Options:
  -d      Delete the note file
  -s      Save file to /home/user/.note. (automatic naming)
  -f      Name file and save.
  -h      Show help message
  -e      Edit the note file
  -E      Edit from note directory
  -o      Print from note directory
  -A      Archive /home/user/.note
  
  ```

By default, it opens a temporary buffer. 

It's based around the command 
`cat >> /tmp/note`
Which by itself is usable. 

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

