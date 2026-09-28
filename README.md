# The Hobbit (ZX Spectrum, 1982) - annotated disassembly

A complete, cross-referenced, plain-English disassembly of the main program in the
original 1982 release (v1.0) of *The Hobbit*, the text adventure by Veronika Megler and
Philip Mitchell, published by Melbourne House for the ZX Spectrum.

It is written for people who **do not read Z80 assembly**. Every routine and every data
table has a title and a description, and every line of every routine has a comment that
says *why* the line is there, in the game's own terms ("is the target locked, or already
open?", "the actor's own record") rather than restating the instruction or quoting a bare
address. Addresses in the text are links, so you can follow the code the way you would
follow a story.

**Browse it: open [`index.html`](https://basf-c60.github.io/thehobbitv1.0/index.html)** (or the published site, if you are reading
this on GitHub Pages).

## What you will find

| Page | What it is |
|---|---|
| [How the game works](HowItWorks.html) | The overview: the turn cycle, the parser, objects and rooms, characters, text, pictures and chance. Start here. |
| [Map of Wilderland](Map.html) | All 79 locations and their exits, drawn from the game's own data: doors, dark rooms, one-way exits and the five randomly hidden routes. |
| [Location pictures](Pictures.html) | All 22 pictures, rendered by running the game's own drawing routine. The format (a small vector language with flood fills) is decoded command by command. |
| [Characters](Characters.html) | Starting strength, defence, size, side and how obedient each character is, with an explanation of what the numbers mean. |
| [Objects](Objects.html) | Every object, where it starts, its stats and the actions it has special handling for. |
| [Bugs](reference/bugs.html) | 14 bugs in the original program, each explained, with a note of whether it was reproduced in an emulator. |
| [Trivia](reference/facts.html) | 45 findings: how Thorin's singing works, why the wine slurs your speech, why the best score is 75%, and more. |
| [Routines and data](asm/) | The disassembly itself: 369 routines and every data table, all named and explained. |

## Things worth knowing about the game

A few of the things this work turned up, each explained in detail on the pages above:

- **Characters run their own programs.** Gandalf, Thorin, the trolls, the goblins, Gollum and
  the rest each execute a small script every turn, using the same action code the player
  uses. That is why the game can say "thorin sits down and starts singing about gold".
- **Everything is an object.** Bilbo, the characters, doors, rivers and swords share one record
  format. Carrying, containing and tying are all just "whose number is in the holder byte".
- **Messages are programs.** Text is stored as dictionary references, abbreviations and
  control codes; verb endings, articles and capitals are added while printing.
- **The pictures are vector drawings**, not bitmaps, which is how 22 of them fit in memory.
- **The random numbers come from the program itself**, folded into range in a way that skews
  fights towards the high end.
- **Bugs.** Typing `DO` (including the abbreviation in `op do`) makes the game run wild;
  negative random adjustments in fights become zero; the missing wound message; a jump into
  message data in the barrel handler; and more. See the [Bugs page](reference/bugs.html).

## Repository layout

```
index.html, *.html        the browsable site (generated)
asm/                      one page per routine or data block
reference/                bugs, trivia, glossary and pokes pages
images/                   location pictures, the map and the font
source/                   the sources the site is built from (see below)
README.md                 this file
```

If you publish with GitHub Pages, note that Pages can serve only the repository root or a
`/docs` folder, so put the contents of the generated site in one of those.

### `source/`

| File | What it is |
|---|---|
| `hobbit.skool` | The complete annotated disassembly in [SkoolKit](https://skoolkit.ca) "skool" format. |
| `hobbit.ctl` | The SkoolKit control file it was generated from. |
| `hobbit*.ref` | The extra pages: overview, bugs, trivia, characters, objects, map, pictures. |
| `overlay*.py`, `build.py` | The annotation scripts. Every description and line comment lives in these; `build.py` combines them into `hobbit.ctl`. |
| `autocom.py`, `linker.py`, `linkrefs.py` | The first-pass line commenter (the hand-written comments override it) and the tools that turn addresses into links. |
| `beh.py`, `pic.py`, `roommap.py`, `objpage.py`, `msgemu.py`, `render.py` | Helpers that decode the behaviour programs and pictures, draw the map, generate the objects page, render every message with the game's own text printer, and render the pictures. |
| `msgs.json` | Every message in the game, as the game itself prints it. |

## The version disassembled

The tape is the original v1.0 release: a BASIC loader, a loading screen, and the main
program, which is **37,888 bytes loaded at 24576 (`$6000`) and started with
`RANDOMIZE USR 27648` (`$6C00`)**. The disassembly covers all of that block. The tape
itself is not included in this repository.

## Checking the work yourself

You need [SkoolKit](https://skoolkit.ca) 10.1 or later (`pip install skoolkit`).

**Reassemble the disassembly and compare it with your own copy of the tape.** The result
should be byte-for-byte identical to the game's main block. To extract that block from a
TZX file:

```python
data = open('The_Hobbit_v1_0.tzx', 'rb').read()
i, blocks = 10, []
while i < len(data):
    block_id = data[i]; i += 1
    if block_id == 0x10:                       # standard-speed data block
        n = data[i + 2] | data[i + 3] << 8
        blocks.append(data[i + 4:i + 4 + n]); i += 4 + n
    elif block_id == 0x30:                     # text description
        i += 1 + data[i]
    else:
        raise SystemExit('unexpected TZX block %#x' % block_id)
open('hobbit_code.bin', 'wb').write(blocks[-1][1:-1])   # drop flag and checksum bytes
```

```
skool2bin.py -i source/hobbit.skool rebuilt.bin
cmp rebuilt.bin hobbit_code.bin && echo IDENTICAL
```

**Regenerate the website from the skool file:**

```
cd source
skool2html.py -H -d ../site hobbit.skool hobbit.ref
```

Copy the `images/pictures`, `images/map.png` and `images/map.svg` files from the published
site into `site/hobbit/images/` afterwards, since the pictures and map pages refer to them.

**Regenerating `hobbit.skool` from the annotation scripts** is not yet a one-command job:
`build.py` and its helpers expect the extracted code block, a Z80 listing of it, and some
absolute paths that were set up on the machine where the work was done. The
`hobbit.skool` and `hobbit.ctl` files are the authoritative result and are enough for
everything above.

## How it was made, and how far to trust it

The code and data were separated by running the game in a Z80 emulator, playing it with random
input while recording every instruction executed, and then working out each table and
subsystem by hand. Every description was written from the code first. Then the claims were
checked:

- the whole disassembly reassembles to the original bytes;
- every address quoted in a line comment is checked automatically against the real
  instruction boundaries;
- claims about behaviour were tested by running the game and setting up the situation
  (moving the player, giving items, seeding the random numbers), not only by reading code.

Things that were confirmed this way are marked as such on the Bugs and Trivia pages, along
with the ones that are a careful reading of the code that has not been reproduced. Testing
also *overturned* several earlier descriptions, and those were corrected throughout: for
example, the barrel escape starts when the barrel is thrown through the trap door, not
when the door is opened, and the parser does not accept "with the sword hit thorin" as a
reordering of "hit thorin with the sword".

If you find something that is wrong, please open an issue. A corrected claim is worth more
than a tidy one.

## Credits and notices

- *The Hobbit* is © Melbourne House. The game was written by Veronika Megler and Philip
  Mitchell, from the book by J. R. R. Tolkien. This project is not affiliated with or endorsed
  by any of them or their successors.
- This is a study of how the program works. A disassembly necessarily reproduces the
  program's code and data, so the same rights apply to it as to the original: it is
  published here for research and education, does not include the game tape, and should
  not be treated as a substitute for owning the game.
- The site is generated with [SkoolKit](https://skoolkit.ca) by Richard Dymond.
