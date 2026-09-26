# Second batch of annotations: keyboard, line input and the tokeniser
from overlay import A, blk

blk(0x6040,'b','Main dictionary (the words the player can type)',[
 "This is the vocabulary: every verb, noun, adjective, adverb and direction the parser understands, stored alphabetically, 356 entries in all. It is also used by the printer, so the same words appear in room descriptions and messages.",
 "Each word is stored with one byte per letter. The low five bits of each byte hold the letter (1=A, 2=B ... 26=Z, 0=no letter). From the third byte onwards, bit 7 set means 'this is the last letter of the word'. Words shorter than three letters are padded with a byte whose letter bits are 0 and whose bit 7 is set (so TO is stored as T, O, $80).",
 "Bits 5 and 6 of the FIRST TWO bytes are not part of the letters: together they give the word's class, which the tokeniser (#R$6E8E, at $6F12) assembles into a single byte: bit 6 of byte 0 becomes bit 7, bit 5 of byte 0 becomes bit 6, bit 6 of byte 1 becomes bit 5, and bit 5 of byte 1 becomes bit 4. The classes are:",
 "#TABLE(default) { =h Class | =h Meaning | =h Examples } { $00 | adverb | CAREFULLY, QUICKLY, VICIOUSLY, SOFTLY } { $10 | 'in' preposition | IN, INTO } { $20 | direction | NORTH, EAST, UP, DOWN, NE } { $30 | verb | ATTACK, TAKE, CLIMB, EXAMINE, OPEN, SAY } { $40 | movement verb | GO, RUN } { $50 | noun | SWORD, THORIN, DOOR, KEY, BARREL } { $60 | adjective | CURIOUS, LARGE, GREEN, DARK } { $70 | preposition | AT, WITH, TO, ON, THROUGH } { $80 | article or filler | A, AN, THE, IS, THAT } { $90 | special word | ALL, EXCEPT, IT, HELP, SAVE, LOAD, PRINT, QUIT } { $A0 | AND | AND (a comma produces the same class) } { $B0 | THEN | THEN (a full stop produces the same class) } TABLE#",
 "SYNONYMS: if bit 6 of a word's LAST byte is set, the word is a synonym and is followed by two extra bytes: the offset from #R$6000 of the word it stands for. The tokeniser silently replaces the synonym with that word, so the rest of the game never sees it. There are 29 synonyms, and they explain a lot about how the game behaves: HIT, KILL, CAPTURE, SLASH and SLICE all become ATTACK; BREAK and SMASH become STRIKE; GET, LIFT and STEAL become TAKE; PICK becomes CARRY; READ becomes EXAMINE; SAY becomes TALK; EVERYTHING becomes ALL; BUT becomes EXCEPT; ME becomes YOU; I becomes INVENTORY; L and LO become LOOK; and N, S, E, W, NE, NW, SE, SW, U and D become the full direction words. So 'hit thorin' and 'kill thorin' are literally the same command as 'attack thorin'.",
 "Everything else in the game refers to a word by its offset from #R$6000, as a 12-bit number. So SWORD, which starts at $6684, is referred to as $684; THORIN at $66B8 is $6B8; CAVE at $6112 is $112. The spare top four bits of those 16-bit references are used for the class or for printing flags.",
 "The dictionary ends at $67AE with YOU; the byte at $67AF is a separator, and the second dictionary (#R$67B0) follows."])

blk(0x6D0A,'c','Main command loop',[
 "This is the heart of the game. Each pass round the loop is one line of input from the player:",
 "1. #R$6DCD prints the '>' prompt and reads a line of text into the input buffer at #R$6FF0. If the player types nothing for a while, #R$7240 types WAIT on their behalf, so time passes in The Hobbit even if you do not.",
 "2. The token buffer at #R$7093 is cleared (#R$70D9), and then #R$6E8E is called repeatedly to turn the line into tokens, one per word. Each token is two bytes, stored high byte first: the high byte is the word's class (see #R$6040) in its top four bits plus the top four bits of the word's 12-bit dictionary offset; the low byte is the bottom eight bits of the offset.",
 "3. Double quotes get special treatment (from $6D2F). A quote comes back from #R$6E8E as class $90 with an offset of 0. The flag at $B60B records whether we are inside a quotation. At an opening quote the flag is set. At a closing quote the flag is cleared and, unless the previous token was already a comma ($A0) or full stop ($B0), a full-stop token is inserted before the quote token, so that whatever was said to a character ends like a complete sentence.",
 "4. Tokens are stored until the end-of-line token ($C0). A token of class $D0 means the word was not in the dictionary: the game jumps to $6D99, which prints a message saying it does not know the word and quotes the word back from the input line (up to the next space or quote, using the pointer at $B5CB). If the line ends with a quotation still open, #R$7FF9 is called to complain and the line is thrown away.",
 "5. #R$7C4F parses the tokens into an action, and #R$8351 executes it and lets the rest of the world take its turn. If the line contained more than one command (separated by AND, THEN, commas or full stops), the loop at $6D8D goes back into the parser for the next one while the flag at $B5F6 is set.",
 "The main loop can also be entered at $6D17 with the Z flag set, from the '@' key (see #R$6E71), which re-parses the tokens left over from the previous line: in other words, it repeats the last command."],
 comments={0x6D14:'Read a line of input',0x6D17:'Z set: repeat the previous command',0x6D1E:'Clear the token buffer',0x6D28:'Turn the next word into a token',0x6D2B:'End of line?',0x6D2F:'A quote?',0x6D39:'Opening or closing quote?',0x6D49:'Closing quote: was the previous token a comma or full stop?',0x6D56:'No: insert a full stop token',0x6D63:'Store the token',0x6D6D:'Loop until the end-of-line token ($C0)',0x6D72:'Quote still open at the end of the line?',0x6D7C:'Yes: complain and start again',0x6D81:'Parse the tokens',0x6D8D:'Execute the command and run the rest of the turn',0x6D90:'More commands on this line?',0x6D99:'Unknown word: complain and quote it'})

blk(0x6DCD,'c','Read a line of input from the keyboard',[
 "This is The Hobbit's line editor. It starts by setting the idle timer at $B604 to 3000 (see #R$7240), and setting $B5F2 and $B5EB to 1, then prints the '>' prompt and a space.",
 "Characters are collected into the input buffer at #R$6FF0. B counts the space left, starting at 128 ($80), so bit 7 of B being set means that nothing has been typed yet. C is 0 until the first key has been handled.",
 "Keys are fetched by #R$7240, which also types WAIT for the player if they are idle for too long. Each key is then handled as follows:",
 "#LIST { '@' ($40, SYMBOL SHIFT + 2) as the very first key: repeat the last command (#R$6E71). } { Any key that is the first key of the line: #R$6E46 checks for the cursor keys, which produce a one-letter movement command on their own. } { $18 (SYMBOL SHIFT + 0): delete the whole line (#R$6E82). } { $08 (CAPS SHIFT + 0 or 5, or 5 on its own): delete the last character, by printing a backspace, putting B back up by one and moving HL back, unless the line is empty. } { Letters (codes $40 and above), space, double quote, full stop, comma and ENTER are accepted. Everything else is ignored. } LIST#",
 "An accepted character is stored in $B5F5 (the printer uses this to remember the last punctuation mark), echoed to the screen via #R$7580, and put in the buffer, as long as there is room (B not 0). ENTER ($0D) ends the line: it is stored like any other character, and the routine returns with the Z flag reset.",
 "Note that letters are not converted to upper case here. They do not need to be: the tokeniser keeps only the low five bits of each letter (#R$6F3E), and that is the same for 'a' and 'A'."],
 regs=['Output:F Z reset for a normal line; Z set if the previous command is to be repeated'],
 comments={0x6DCD:'Allow 3000 key polls before WAIT is typed automatically',0x6DDB:'Print the prompt "> "',0x6DE5:'HL = input buffer, B = 128 characters of space, C = 0 (no keys yet)',0x6DEC:'Wait for a key',0x6DEF:'First character of the line?',0x6DF3:'"@" as the first key: repeat the last command',0x6DF8:'First key of the line: check for cursor-key shortcuts',0x6DFF:'SYMBOL SHIFT + 0: delete the whole line',0x6E08:'Backspace?',0x6E0C:'Ignore it if the line is empty',0x6E10:'Otherwise rub out the last character',0x6E19:'Accept letters...',0x6E1D:'...double quote, space, ENTER, full stop and comma',0x6E31:'Remember the character for the printer',0x6E34:'Buffer full?',0x6E38:'Echo the character and store it',0x6E3E:'Loop until ENTER',0x6E43:'Return with Z reset'})

blk(0x6E46,'c','Cursor-key shortcuts',[
 "Called by #R$6DCD for the first key of a line only. If the key is one of the four cursor keys, this routine types a complete movement command on its own and ends the line, so that a single key press moves Bilbo. The key codes come from the keyboard tables at #R$7BEE and #R$7C16:",
 "#TABLE(default) { =h Key | =h Code | =h Command } { 7 (up) | $5B | N } { 6 (down) | $0A | S } { 8 (right) | $09 | E } { 5 (left) | $08 | W } TABLE#",
 "The key works with or without CAPS SHIFT. The letter is stored in the input buffer and echoed, an ENTER ($0D) is stored after it, and the routine returns with A=$0D. The line editor then carries on as if the player had pressed ENTER: it prints the new line, stores a second (harmless) ENTER and finishes the line. So one key press both types and enters the command.",
 "For any other key the routine returns with A unchanged and the line editor deals with the key as usual. The code for the left cursor ($08) is also the backspace code; this is why cursor-left only means 'west' as the first key of a line, and means 'delete' afterwards. Cursor right and down later in a line are simply ignored."],
 regs=['Input:A Key code','HL Current position in the input buffer','B Space left in the buffer','Output:A $0D if a movement command was typed, otherwise unchanged'],
 comments={0x6E46:'Cursor right?',0x6E4A:'Cursor left?',0x6E4E:'Cursor down?',0x6E52:'Cursor up (code $5B)? If not, return with A unchanged',0x6E55:'Up: "N"',0x6E57:'Store the letter...',0x6E59:'...and echo it',0x6E5D:'Then store an ENTER',0x6E62:'Return with A=$0D (ENTER)',0x6E65:'Down: "S"',0x6E69:'Right: "E"',0x6E6D:'Left: "W"'})

blk(0x6E71,'c','Repeat the last command',[
 "Called by #R$6DCD when the first key of a line is '@' (SYMBOL SHIFT + 2).",
 "If the flag at $B60A is set (it is set by the command code at $8765, and appears to mean that the previous input has not been completely dealt with), the '@' is thrown away and the line editor goes back to waiting for a key.",
 "Otherwise two backspaces are printed to rub out the '> ' prompt, and the routine returns with the Z flag set. (#R$6DCD jumps here rather than calling it, so this return goes straight back to the main loop.) The main loop (#R$6D0A) then skips tokenising and hands the old contents of the token buffer (#R$7093) straight back to the parser. The effect is that '@' repeats the previous command, without it appearing on the screen again."],
 regs=['Output:F Z set to repeat the last command'],
 comments={0x6E71:'Is a command still pending?',0x6E75:'Yes: ignore the key and carry on reading the line',0x6E78:'Rub out the "> " prompt',0x6E80:'Return with Z set: repeat the last command'})

blk(0x6E82,'c','Delete the whole input line',[
 "Rubs out everything typed so far. While B has bit 7 reset (i.e. at least one character has been typed; see #R$6DCD), it prints a backspace, puts B back up by one and moves HL back one character.",
 "Called for SYMBOL SHIFT + 0 by the line editor, and by #R$7240 before it types WAIT for an idle player, so that anything half-typed is thrown away and replaced by WAIT."],
 regs=['Input:HL Current position in the input buffer','B Space left in the buffer'],
 comments={0x6E82:'Stop when the line is empty',0x6E85:'Print a backspace',0x6E8A:'One more character of space; step back in the buffer'})

blk(0x6E8E,'c','Turn the next word of the input into a token',[
 "The tokeniser. Starting at HL in the input buffer, it skips spaces, finds the next word or punctuation mark, and returns its class in A and a two-byte token in B (high) and C (low). HL is left after the word, ready for the next call. The address of the start of the word is stored at $B5CB so that an 'I don't know the word' message can quote it.",
 "#TABLE(default) { =h Input | =h A | =h BC } { End of line (ENTER) | $C0 | $C000 } { Full stop | $B0 | $B000 } { Comma | $A0 | $A000 } { Double quote | $90 | $9000 } { A dictionary word | its class | class in the top nibble of B, then the 12-bit offset of the word from #R$6000 } { An unknown word | $D0 | undefined } TABLE#",
 "The search works like this:",
 "1. #R$6F3E copies the typed letters (keeping only their low five bits, so case does not matter) into the buffer at #R$7071 and their count into $7081. It then uses the letter index at #R$6000 to find the first dictionary word beginning with the same letter, and unpacks that word into the buffer at #R$7082 (count in $7092). If there are no words for that letter, the word is unknown.",
 "2. #R$6FB1 compares the typed letters with the dictionary word, over the length of the shorter of the two.",
 "3. If they differ, #R$6F69 unpacks the next word in the dictionary and the comparison is repeated. The search gives up (unknown word) as soon as it reaches a word with a different first letter.",
 "4. If they agree, the lengths decide ($6EB7). If the dictionary word is at least as long as what was typed, it is accepted. So any abbreviation matches the first word that starts with those letters: this is why N means NORTH, but also why EX finds EXAMINE and not EXCEPT. If the player typed MORE letters than the dictionary word has, and the dictionary word is 1-3 letters long, it is rejected and the search moves on (so typing EASTWARD does not match E). If the dictionary word is 4 letters or longer, the game looks at the following dictionary word (#R$6F6D, without moving the current position); if that one also matches the typed letters, the search moves on to it, otherwise the current word is accepted. So extra letters after a long enough word are ignored: SWORDS finds SWORD, and TROLLS finds TROLLS rather than TROLL.",
 "5. For the accepted word ($6EE2), the end of the word is found. If bit 6 of the last letter is set, the word is a synonym and the next two bytes give the offset of the real word; HL is switched to that word, so for example HIT is returned as ATTACK. The class is then assembled from bits 5 and 6 of the real word's first two bytes (see #R$6040), and $A000 is added to the word's address to turn it into an offset from $6000 (because $6000 + $A000 = $10000)."],
 regs=['Input:HL Position in the input buffer','Output:A Word class','BC Token','HL Position after the word'],
 comments={0x6E8F:'Skip spaces',0x6E96:'Remember where the word starts',0x6E99:'End of the line?',0x6E9D:'Punctuation?',0x6EA2:'Copy the typed word and find the first dictionary word with the same first letter',0x6EA5:'No words start with this letter: unknown word',0x6EA8:'Compare the typed word with the dictionary word',0x6EAD:'Different: try the next dictionary word',0x6EB3:'Class $D0: unknown word',0x6EB7:'Letters agree. Is the dictionary word at least as long as the typed word?',0x6EC1:'No: reject dictionary words of 1-3 letters',0x6EC7:'Otherwise, does the next dictionary word also fit?',0x6ED5:'End of line: class $C0',0x6EDA:'Put the class into the top of B and return it in A',0x6EE2:'Accept the dictionary word at (B607): find its last letter',0x6F00:'Is it a synonym?',0x6F06:'Yes: switch to the word it stands for',0x6F12:'Build the class from bits 5-6 of the first two bytes',0x6F1E:'Turn the address into an offset from $6000'})

blk(0x6F27,'c','Recognise punctuation',[
 "Checks whether the character in A is a full stop, comma or double quote. If it is, HL is moved past it, A is set to the corresponding token class ($B0 for a full stop, the same as THEN; $A0 for a comma, the same as AND; $90 for a quote) and BC is set to 0; the Z flag is left set from the successful comparison. If not, the routine returns with the Z flag reset."],
 regs=['Input:A Character','HL Its address','Output:F Z set if it was punctuation','A Token class','BC 0'],
 comments={0x6F27:'Full stop: class $B0 (like THEN)',0x6F2D:'Comma: class $A0 (like AND)',0x6F33:'Double quote: class $90',0x6F38:'Step past the punctuation mark'})

blk(0x6F3E,'c','Start a dictionary search for the typed word',[
 "Copies the letters of the word at HL into the buffer at #R$7071, keeping only the low five bits of each (so 'a' and 'A' are both 1). Characters below $40 (space, punctuation, ENTER) end the word. The number of letters is stored at $7081.",
 "The first letter (1-26) is then used to index the letter table at #R$6000, and IX is set to the first dictionary word starting with that letter. Execution continues into #R$6F69 to unpack it."],
 regs=['Input:HL Start of the typed word','Output:HL End of the typed word','IX Dictionary word','F Z set if the dictionary word starts with the right letter'],
 comments={0x6F3E:'Copy letters into the typed-word buffer',0x6F50:'Save the length',0x6F55:'Look up the first letter in the letter index'},
 mid={0x6F69:"This entry point is used by #R$6E8E to move on to the next dictionary word. It saves IX in $B607 as the current candidate and then unpacks it. Another entry point at $6F6D does the same without updating $B607; the tokeniser uses that one to peek at the following word.",
      0x6F6D:"Check that the dictionary word at IX starts with the same letter as the typed word. If not, return with Z reset: the search is over.",
      0x6F78:"Unpack the dictionary word into #R$7082. The same end-of-word rule is used everywhere: bit 7 marks the last letter, except in the first two bytes. Letter codes of 0 (padding) are not copied.",
      0x6FA6:"If this word is a synonym, skip the two bytes that point to the real word, so IX is left pointing at the next word in the dictionary."})

blk(0x6FB1,'c','Compare the typed word with a dictionary word',[
 "Compares the letters in #R$7071 (the typed word) with those in #R$7082 (the dictionary word), over the length of whichever is shorter. Returns with the Z flag set if they agree. The lengths themselves are dealt with by the caller (#R$6E8E)."],
 regs=['Output:F Z set if the letters match'],
 comments={0x6FB1:'B = the shorter of the two lengths',0x6FBC:'Compare letter by letter'})

blk(0x6FCA,'c','Clear the screen',[
 "Sets the border to white, clears the whole display file ($4000-$57FF) to 0 and sets all 768 attributes ($5800-$5AFF) to $38: black ink on white paper, the colours The Hobbit uses throughout. Called once at start-up (#R$6C27) before the frame and first text are drawn."],
 comments={0x6FCD:'White border',0x6FD1:'Clear the pixels',0x6FDE:'Black on white attributes'})

blk(0x6FE9,'t','Initial prompt and command',[
 "'> LOOK' followed by ENTER. At the start of a game (#R$6C27) this is printed as though the player had typed it, and 'LOOK' plus ENTER are copied into the input buffer so that the first turn describes Bilbo's surroundings."],
 subs=[('T',0x6FE9,2,'The prompt'),('T',0x6FEB,5,'The first command (with ENTER)')])

blk(0x6FF0,'t','Input buffer',[
 "The line typed by the player, 128 characters, filled by #R$6DCD and read by #R$6E8E. It is followed by a permanent ENTER at $7070 so that the tokeniser always finds an end even on a completely full line."],
 subs=[('T',0x6FF0,0x80,''),('B',0x7070,1,'ENTER')])

blk(0x7071,'b','Tokeniser work areas',[
 "#LIST { $7071-$7080: the letters of the word being looked up (#R$6F3E), as values 1-26 } { $7081: the number of letters typed } { $7082-$7091: the letters of the dictionary word being compared with it (#R$6F69) } { $7092: the number of letters in the dictionary word } LIST#"],
 subs=[('B',0x7071,16,'Typed word'),('B',0x7081,1,'Its length'),('B',0x7082,16,'Dictionary word'),('B',0x7092,1,'Its length')])

blk(0x7093,'b','Token buffer',[
 "The tokens for the current input line, two bytes each, high byte first, as built by the main loop (#R$6D0A) from the results of #R$6E8E and read by the parser (#R$7C4F). Space for 32 tokens. Because it is only rebuilt when a new line is typed, the '@' key (#R$6E71) can repeat the previous command by parsing it again."],
 subs=[('B',0x7093,0x40,'')])

blk(0x70D3,'b','Registers saved by the message printer',[
 "#R$72D4 saves A at $70D3, DE at $70D4 and IX at $70D7 (with an unused byte at $70D6) while it runs, and restores them at the end."],
 subs=[('B',0x70D3,1,'A'),('B',0x70D4,2,'DE'),('B',0x70D6,1,''),('B',0x70D7,2,'IX')])

blk(0x7225,'c','Compare two word references',[
 "Compares the word reference at HL with the one at IY (both stored low byte first) and then moves both pointers on by two bytes. Only the low 12 bits count (the offset from #R$6000), so the class or flag bits in the top nibble are ignored.",
 "Returns with the Z flag set if the words are the same, or if the reference at HL is zero (an empty slot, which ends a list of words). Used five times by the routine at #R$71D9 when matching the words the player typed against the four word slots of an object record (#R$C00B)."],
 regs=['Input:HL Word reference','IY Word reference','Output:F Z set if they match (or HL points to 0)'],
 comments={0x7226:'Is the word at HL empty?',0x722B:'Compare the top four bits of the offset...',0x7233:'...and the bottom eight',0x7238:'Move both pointers on'})

blk(0x7240,'c','Wait for a key, typing WAIT if the player is idle',[
 "Polls the keyboard (#R$7B86) until a key is pressed, counting the polls down from the value at $B604. Each poll includes the 1000-iteration delay in #R$7B6B, so it takes something like 8 ms, and the starting value of 3000 set by #R$6DCD gives the player roughly 20-25 seconds (my estimate from the instruction timings).",
 "When a key is pressed, 500 is added to what is left of the count, up to a maximum of 3000, so steady typing keeps the time topped up.",
 "If the count runs out, the game takes over: whatever has been typed is erased (#R$6E82), the four characters 'WAIT' from #R$7288 are put into the input buffer and printed, B is set to $7C (four characters used), the count is reset to 3000, and an ENTER is returned as if the player had pressed it. The line editor then finishes the line and the WAIT command is carried out. This is how time passes in The Hobbit even when the player does nothing, and why the other characters can go off and do things - or attack you - while you are thinking."],
 regs=['Input:HL Current position in the input buffer','Output:A Key code'],
 comments={0x7241:'HL = polls left before WAIT',0x7244:'Is a key being pressed?',0x724A:'No: count down',0x7251:'Time up: rub out what has been typed',0x7254:'Put WAIT into the buffer and print it',0x7263:'Four characters used; return ENTER',0x7267:'This makes the addition below overflow, so the count is reset to 3000',0x726C:'Add 500 to the polls left...',0x7271:'...but no more than 3000',0x727C:'Save the new count'})

blk(0x7282,'c','Compare HL with DE',[
 "A 16-bit comparison: compares H with D and, if they are equal, L with E. Returns with Z set if HL=DE, and the carry flag set if HL is less than DE. A is corrupted."],
 regs=['Input:HL First number','DE Second number','Output:F Z set if equal, carry set if HL<DE'])

blk(0x7288,'t','The WAIT command',[ "The four letters typed automatically by #R$7240 when the player is idle."],subs=[('T',0x7288,4,'')])

blk(0x7B15,'c','Copy a line of text to the ZX Printer',[
 "The Hobbit can send its output to a ZX Printer (the PRINT and NOPRINT commands). If the flag at $B5E3 is set, this routine is called by #R$7694 at the end of every line of text, and it copies the 8 pixel rows of that line from the screen, starting at $5020, to the printer.",
 "The ZX Printer is driven directly through port $FB. For each pixel row, the 32 bytes are sent one bit at a time: for each dot the routine waits for the printer's encoder signal (bit 0 of the port) and then outputs the dot. D controls the motor speed: it starts at 1 (slow), and after the first two rows the value derived from E runs the motor at full speed. After the 8 rows the motor is stopped (OUT ($FB),4). If the printer is not connected (bit 7 of the port reads as 1) the routine gives up straight away."],
 comments={0x7B15:'Is the printer switched on?',0x7B1D:'Slow motor; HL = start of the line on the screen',0x7B24:'Start the motor and wait for the printer to be ready',0x7B29:'Bit 7 set: no printer connected',0x7B3A:'Send eight dots per screen byte',0x7B41:'Wait for the encoder...',0x7B47:'...and send the dot',0x7B4C:'Next byte, until all 32 have been done',0x7B5D:'Next pixel row',0x7B63:'Stop the motor'})

blk(0x7B6B,'c','Short delay',[
 "Counts BC down from 1000. This takes about 26,000 T-states, a little over 7 ms, and slows the keyboard scan in #R$7B86 down enough to debounce the keys. It also sets the pace of the idle timer in #R$7240. BC is 0 on return."])

blk(0x7B74,'b','Keyboard scan state',[
 "#LIST { $7B74-$7B7B: a mask for each of the eight half-rows of the keyboard, ORed with the reading so that those keys are never seen as pressed. The masks hide CAPS SHIFT ($01 in the first half-row) and SYMBOL SHIFT ($02 in the last), which are read separately as shift keys, and the unused keys 1, 3, 4 ($0D in the 1-5 half-row) and 9 ($02 in the 0-6 half-row). } { $7B7C-$7B7D: the newly pressed key found by the last scan: the bits in $7B7C and the half-row in $7B7D, or 0 for none. } { $7B7E-$7B85: the previous reading of each half-row, used to detect keys that have just gone down. } LIST#"],
 subs=[('B',0x7B74,8,'Key masks'),('B',0x7B7C,2,'New key'),('B',0x7B7E,8,'Previous readings')])

blk(0x7B86,'c','Read a key',[
 "Scans the keyboard directly through port $FE (the game does not use the ROM keyboard routine or interrupts) and returns the ASCII code of a key that has just been pressed, or 0 if no new key has been pressed. Holding a key down does not repeat it.",
 "The routine first waits a few milliseconds (#R$7B6B), then reads each of the eight half-rows in turn, starting with port $FEFE (CAPS SHIFT to V) and rotating the high byte of the port address to reach the next row. Each reading is ORed with that row's mask from #R$7B74. A key counts as newly pressed if its bit is 0 now but was 1 in the previous reading kept at $7B7E; the row and bits of such a key are saved at $7B7C.",
 "If a new key was found, its row and bit are turned into a number from 0 to 39 (row x 5 + bit, $7BC0-$7BCE). Then the shift keys are checked directly: if CAPS SHIFT is held, or SYMBOL SHIFT is not, the normal table at #R$7BEE is used; if SYMBOL SHIFT is held (and CAPS SHIFT is not), the symbol table at #R$7C16 is used. The table entry is returned in A.",
 "In my emulator I replaced this routine with one that fed typed commands to the game."],
 regs=['Output:A ASCII code of the key, or 0'],
 comments={0x7B8A:'Short delay; clear the new-key record',0x7B98:'Start with the CAPS SHIFT-V half-row',0x7B9B:'Read it and hide the ignored keys',0x7BA3:'Any key down now that was up before?',0x7BA8:'Yes: remember the row and the bits',0x7BB0:'Save this reading for next time',0x7BB4:'Next half-row',0x7BB8:'Was a new key found?',0x7BC0:'Work out its number: 5 x row...',0x7BCA:'...+ bit',0x7BD1:'Use the normal table...',0x7BD4:'...if CAPS SHIFT is pressed...',0x7BDC:'...or SYMBOL SHIFT is not',0x7BE4:'Otherwise use the SYMBOL SHIFT table',0x7BE7:'Look up the key'})

blk(0x7BEE,'b','Keyboard table',[
 "The character for each key when SYMBOL SHIFT is not held (with or without CAPS SHIFT), five entries per half-row in the order the rows are scanned. 0 means the key does nothing. Only letters, ENTER and SPACE are here, plus: 5 and 0 give $08 (delete, or west as the first key of a line), 8 gives $09 (east), 7 gives $5B (north) and 6 gives $0A (south). See #R$6E46."],
 subs=[('B',0x7BEE,5,'CAPS SHIFT, Z, X, C, V'),('B',0x7BF3,5,'A, S, D, F, G'),('B',0x7BF8,5,'Q, W, E, R, T'),('B',0x7BFD,5,'1, 2, 3, 4, 5'),('B',0x7C02,5,'0, 9, 8, 7, 6'),('B',0x7C07,5,'P, O, I, U, Y'),('B',0x7C0C,5,'ENTER, L, K, J, H'),('B',0x7C11,5,'SPACE, SYMBOL SHIFT, M, N, B')])

blk(0x7C16,'b','Keyboard table (SYMBOL SHIFT)',[
 "The character for each key when SYMBOL SHIFT is held. Most keys give the same as #R$7BEE; the differences are SYMBOL SHIFT with 2 ('@', repeat the last command, #R$6E71), 0 ($18, delete the whole line, #R$6E82), P (double quote, for speech), M (full stop), N (comma) and SPACE ($02)."],
 subs=[('B',0x7C16,5,'CAPS SHIFT, Z, X, C, V'),('B',0x7C1B,5,'A, S, D, F, G'),('B',0x7C20,5,'Q, W, E, R, T'),('B',0x7C25,5,'1, 2, 3, 4, 5'),('B',0x7C2A,5,'0, 9, 8, 7, 6'),('B',0x7C2F,5,'P, O, I, U, Y'),('B',0x7C34,5,'ENTER, L, K, J, H'),('B',0x7C39,5,'SPACE, SYMBOL SHIFT, M, N, B')])

blk(0x7C3E,'b','Parser work area',["Used by #R$7C4F: the flag at $7C44 and the ten bytes from $7C45 are cleared at the start of each parse."],subs=[('B',0x7C3E,17,'')])
