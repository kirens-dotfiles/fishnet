# fishnet

Record yourself writing a sequence of commands to easliy replay them later.

<p align="center">
  <a href="https://asciinema.org/a/rvaNkc4WJ5bKMmOHFIx4qQbWL">
    <img
      src="https://asciinema.org/a/rvaNkc4WJ5bKMmOHFIx4qQbWL.svg"
      alt="A recorded demo of fishnet"
    />
  </a>
</p>

## Motivation
As the old proverb goes.
> Give a man a fish, and you feed him for a day. Teach a man to fish, and you
> feed him for a lifetime.

But what happens if one forgets how to fish? Then you'll find yourself googling
the same phrase over and over. At that point I find myself thinking _"I should
make a script for this"_, but since I seldom need that script I'll not recall
how to use it either.

This project aims to be a middleground. Allowing you to create a "script" for
the sometimes repeated task, but not needing to define a new UI that's easy to
foreget.


## Installation
Copy the files from `functions/` and `completions/` to their respective
directories in your config. See the docs if you're unsure what this means
([functions](http://fishshell.com/docs/current/#syntax-function-autoloading)
and [completions](http://fishshell.com/docs/current/#completion-path)).

The utility also expects there to be a directory
`$HOME/.local/share/fish/fishnet_records` to store the recordings. So create
that one if there is none.

I haven't worked with Fisher, Oh My Fish or Fundle. If you do I'd be happy to
recive some help updating this package to be compatble with them.

## Usage

```
fishnet COMMAND RECORD_NAME
```
Where `COMMAND` is either `record` to start recording and `run` to replay a
recording. The `RECORD_NAME` is simply the name the recording will be refered
by.

## Contributions
I've written this utility mostly for my own use. But if you find it handy and
have some feedback or want to help out in another way, don't hesitate to simply
oen an issue or send me a PR.
