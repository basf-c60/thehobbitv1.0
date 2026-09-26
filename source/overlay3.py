# Batch 3: 7000-77FF (verb report, message interpreter control codes, text output)
from overlay import A, blk
T=[]   # trivia entries (id, title, text)
BUGS=[]
def fact(i,t,x): T.append((i,t,x))
def bug(i,t,*x): BUGS.append((i,t,'\n<br><br>\n'.join(x)))

blk(0x70DF,'c','Get the address of an action table entry',[
 "Returns HL = $AA3F + 8 x A, the address of the 8-byte entry for action number A in the action table (#R$AA47 is action 1; there is no action 0). The action number of the command being carried out is kept at $B5D8."],
 regs=['Input:A Action number','Output:HL Action table entry'])

blk(0x70EA,'c','Collect the flag nibbles of an action table entry',[
 "Each action table entry (#R$AA47) is four word references, and the top nibble of each high byte is a set of flags rather than part of the word. This routine gathers the four flag nibbles of the entry at IX into two bytes:",
 "#LIST { $B60D = (top nibble of byte 3) + (top nibble of byte 1) / 16. Bit 4 of this byte means 'do not report this action' (#R$7122), bit 3 'mention the target', bit 2 'mention the instrument', bit 5 'leave out the article'. } { $B60E = (top nibble of byte 7) + (top nibble of byte 5) / 16. Bit 7 of this byte controls how the target and instrument are introduced. } LIST#",
 "The value of $B60D is also returned in A."],
 regs=['Input:IX Action table entry','Output:A Flags (also at $B60D)'])

blk(0x7111,'c','Report the action (if not inside a quotation)',[
 "Marks the command as really happening ($B5EC=0, $B5EB=1) and, unless the parser is in the middle of a quotation ($B60B), prints the report of the action with #R$7122. Returns with A=0."])

blk(0x7122,'c','Report the action ("you attack thorin with the sword.")',[
 "Prints the sentence that describes what an actor has just done, for example 'you go east.', 'thorin attacks you.', 'gandalf opens the round green door.' or 'you attack thorin with the short strong sword.'. It is built from the entry for the current action (number in $B5D8) in the action table #R$AA47, whose four word slots hold the verb, a particle, a preposition and (for movement) GO.",
 "The flags collected by #R$70EA decide what is printed. If bit 4 of them is set the action is silent and nothing is printed at all.",
 "Otherwise the actor's name is printed (#R$739E: 'you', 'thorin', 'gandalf'...). If the action was only being tried and would have failed ($B5EC is 0) the word CANNOT is inserted, so the report reads 'you cannot open the door'. The verb follows (#R$74B1). For the ten movement actions a special case applies when the actor is a character and the move is not possible: the word SOMEWHERE is printed instead of the direction. Then, as the flags require, the particle, the target object (#R$73AB, with its article) and the preposition plus instrument (#R$73BE) are added. The sentence ends with a full stop and a new line.",
 "The printing is done with $70D6 set to 1, which makes #R$7436 use 'the' rather than 'a' for articles. $B5F2 is set when the action is only being tried, which sends the text to the lower window instead (see #R$7580)."],
 comments={0x713F:'IX = the action table entry',0x7148:'Only start a new line for the player when the action really happens',0x7153:'Get the flags; bit 4 set means say nothing',0x715C:'Print the actor',0x715F:'"cannot" if the action would not work',0x716C:'Print the verb',0x716F:'A character that cannot move goes "somewhere"',0x7189:'Target wanted?',0x719D:'Instrument wanted?',0x71B8:'End the sentence'})

blk(0x71CC,'c','Get the address of a room\'s word list',[
 "Returns HL pointing at the name words of room A (the record address from #R$9B0C plus 2). IX is preserved. Used when a message needs to name a room rather than an object."],regs=['Input:A Room number','Output:HL Room name words'])

blk(0x71D9,'c','Get the address of an object\'s word list',[
 "Returns HL pointing at the four word slots of object A (its record address from #R$9B25 plus 8: the noun and adjectives). DE and IX are preserved."],regs=['Input:A Object number','Output:HL Object\'s words'])

blk(0x71EA,'c','Match a command against an action table entry',[
 "Compares the verb, particle and preposition in an action table entry (at HL) with those of the parsed command (at IY) using #R$7225. The verb must match. The particle and preposition may match in the same order, or crossed over, so that for example both 'take off the ring' and 'take the ring off' find the TAKE OFF action.",
 "Returns with Z set for a match; A is 0 if the words matched in order and 1 if they were crossed over, and $B5D0 is set to 1 once the verb alone has matched (so the caller can tell 'wrong verb' from 'right verb, wrong words')."],
 regs=['Input:HL Action table entry','IY Parsed command','Output:F Z set if they match','A 0 = in order, 1 = crossed over'])

# ---- message interpreter
blk(0x72BA,'c','Print a character from a message',[
 "Used by the message interpreter for literal characters and control code $0D. The character is printed (#R$7580) and, if it was a carriage return, the 'last punctuation' flag at $B5F5 is cleared."])
blk(0x72C5,'c','Print "I cannot do that."',["Prints the message at $AEB2."])
blk(0x72CA,'c','Print a message, suppressing actions inside a quotation',[
 "If the parser is inside a quotation ($B60B set), the 'really do it' flag $B5EB is cleared first, so that commands being passed to another character are only tried, not carried out. Execution continues into #R$72D4."])

blk(0x72D4,'c','Print a message (message bytecode interpreter)',[
 "Almost everything the game says is printed by this routine, which interprets a compact message 'bytecode' starting at the address in HL. Messages are not stored as ASCII; they are sequences of dictionary references and control codes, which is how The Hobbit fits so much text into 48K.",
 "The entry at $72D4 saves DE, IX and A (restored at the end, $7352) so callers do not lose them. If the command is only being tried ($B5EB is 0) the flag $B5EC is cleared.",
 "The loop at $72EB fetches a byte and decides what it is:",
 "#LIST { $80-$FF: the first byte of a two-byte dictionary reference, high byte first. The low nibble of the first byte and all of the second give the word's offset from #R$6000; the three remaining flag bits (bits 4-6) choose an ending. Flag values 2, 3 and 6 mean 'this is the last word of the message': 2 just stops, 3 adds a full stop and a new line, 6 adds a new line (#R$733F). Other values are passed on to #R$74B8 as printing flags (for example 'add an S'). } { $60-$7F: one of the 32 most common words, looked up in #R$AC31 by #R$748A. } { $20-$5F: a literal character, printed by #R$72BA. } { $00-$1F: a control code, dispatched through the table at #R$728C. } LIST#",
 "Control codes below $14 are called as subroutines. A handler that returns with Z set lets the interpreter move on to the next byte; one that returns with Z reset asks it to print the dictionary word now in DE (so a handler can choose a word such as HIS or YOUR and have it printed). Codes $14 and above end the message.",
 "Several control codes take an extra parameter from the stack: the caller pushes an object address or a word before calling the interpreter, and the handler removes it (see #R$735E).",
 "The same interpreter runs the little scripts attached to rooms and objects, which is why the room and object tables contain what look like fragments of messages."],
 regs=['Input:HL Address of the message bytecode'],
 comments={0x72EE:'Bit 7 set: a dictionary word reference',0x72FA:'Flag values 3, 2 and 6 end the message',0x7308:'Print an ordinary dictionary word',0x730F:'Otherwise: control code, abbreviation or literal character',0x7315:'$60-$7F: one-byte abbreviation',0x7321:'$00-$1F: index into the control-code jump table',0x732B:'Codes $14 and above end the message',0x732F:'Call the handler; Z set means carry on',0x7334:'Z reset: print the word in DE, then carry on'})

A[0x728C]['desc']=["Addresses of the handlers for message control codes $00 to $16, used by #R$72D4:",
 "#TABLE(default) { =h Code | =h Handler | =h Meaning } { $00 | #R$735E | print the object whose address the caller pushed on the stack } { $01 | #R$736D | print the word the caller pushed on the stack } { $02 | #R$7375 | jump forwards or backwards by the signed byte that follows } { $03 | #R$7384 | print the noun of the instrument in the current command ($B5ED) } { $04 | #R$738B | print the pushed word with an article (a/an/the/some) } { $05, $0A, $0F, $12 | $7382 | do nothing } { $06 | #R$739A | print the actor's name } { $07 | #R$73A6 | print the target with its article } { $08 | $73B4 | print a backspace (to join a word to the previous one) } { $09 | $73B9 | print the instrument with its article } { $0B | #R$73D7 | call a sub-message at a relative address } { $0C | #R$73F0 | print HIS or YOUR for the actor } { $0D | #R$72BA | new line } { $0E | #R$73FE | print HIS or YOUR for the target } { $10 | #R$7403 | print the actor's name and IS or ARE } { $11 | #R$741C | the same for the target } { $13 | #R$7424 | the same for an object pushed on the stack } { $14 | #R$7337 | end the message with a new line } { $15 | #R$733B | end the message with a full stop and a new line } { $16 | $7352 | end the message } TABLE#",
 "The IS/ARE and HIS/YOUR codes are what let one message serve both the player and the characters: 'you are dead' and 'thorin is dead' are the same message."]

blk(0x7337,'c','Message code $14: end with a new line',["Sets D to $60 (the 'new line' ending) and joins #R$733F after the word has been printed."])
blk(0x733B,'c','Message code $15: end with a full stop',["Sets D to $30 (the 'full stop' ending) and joins #R$733F."])
blk(0x733F,'c','Print the last word of a message and finish',[
 "Prints the word in DE (#R$74B8) and then ends the message according to the flags in D: bit 6 set gives a new line; otherwise bit 4 set gives a full stop and a new line; if neither, nothing is added. Finally the registers saved on entry to #R$72D4 (A, DE and IX) are restored and the interpreter returns to its caller."],
 regs=['Input:DE Word (flags in the top nibble of D)'])

blk(0x735E,'c','Message code $00: print an object passed on the stack',[
 "The caller of #R$72D4 pushed the address of an object's word list before calling. This handler reaches past the interpreter's own return addresses (POP DE / POP HL / EX (SP),HL / PUSH DE), removes that parameter, and prints the object's name (#R$742B) unless the address is 0. The 'use an article' flag $B5F4 is cleared first, so no article is printed. Returns with Z set."])
blk(0x736D,'c','Message code $01: print a word passed on the stack',[
 "Removes a word reference that the caller pushed on the stack (in the same way as #R$735E) and returns it in DE with Z reset, which makes the interpreter print it."])
blk(0x7375,'c','Message code $02: relative jump',[
 "Moves the message pointer IX by the signed byte that follows the code, so a message can skip over part of itself or loop. Returns with Z set. The entry point at $7382 (XOR A / RET) is used by the codes that do nothing."])
blk(0x7384,'c','Message code $03: print the instrument\'s noun',[
 "Returns the word stored at $B5ED (the noun the player used for the instrument, e.g. SWORD in 'hit thorin with the sword') in DE with Z reset, so the interpreter prints it."])
blk(0x738B,'c','Message code $04: print a word with an article',[
 "Removes a word from the stack (as #R$736D) and prints it with an article, by setting $B5F4 and calling #R$746F. Returns with Z set."])
blk(0x739A,'c','Message code $06: print the actor\'s name',[
 "Prints the name of the current actor ($B5DB) with no article, via #R$747F: 'you' for Bilbo, 'thorin', 'gandalf' and so on. The entry point at $739E is used by #R$7122 without clearing the article flag."])
blk(0x73A6,'c','Message code $07: print the target',[
 "Prints the target of the command (object $B5D9) with its article. If $B5EF is set, the target is a room rather than an object, and the room's name is used instead (#R$71CC rather than #R$71D9). The entry at $73AB is used by #R$7122. Code $08 ($73B4) prints a backspace, and code $09 ($73B9) sets the article flag and continues into #R$73BE."])
blk(0x73BE,'c','Print the instrument',[
 "Prints the instrument (the 'with' object, number in $B5DA) with its article; if $B5F0 is set the instrument is a room. Shares its tail with #R$73A6: the words are found with #R$71CC or #R$71D9 and printed with #R$742B."])
blk(0x73D7,'c','Message code $0B: call a sub-message',[
 "Interprets the message at a relative address (the signed byte after the code, counted from that byte) as a subroutine, by calling #R$72E8 recursively, and then continues with the current message. This lets common phrases be shared between messages."])
blk(0x73F0,'c','Message code $0C: HIS or YOUR (actor)',[
 "Returns the word YOUR if the actor is Bilbo (object 0) and HIS for anyone else, with Z reset so that the interpreter prints it. The entry at $73F3 is shared with #R$73FE."])
blk(0x73FE,'c','Message code $0E: HIS or YOUR (target)',["As #R$73F0, but for the target of the command ($B5D9). This is how 'his defense is too strong' becomes 'your defense is too strong' when Thorin attacks Bilbo."])
blk(0x7403,'c','Message code $10: "you are" or "thorin is"',[
 "Prints the actor's name (#R$747F) and then returns ARE if the actor is Bilbo and IS otherwise, for the interpreter to print. Code $11 (#R$741C) does the same for the target, and code $13 (#R$7424) for an object pushed on the stack."])
blk(0x741C,'c','Message code $11: target\'s name and IS/ARE',["See #R$7403. The target is object $B5D9, and it gets an article."])
blk(0x7424,'c','Message code $13: pushed object\'s name and IS/ARE',["Removes an object number from the stack and continues as #R$741C."])
blk(0x742B,'c','Print an object\'s name from its word list',[
 "Prints the name of the thing whose word list is at HL (adjectives followed by the noun) by calling #R$9E1F with IY pointing at the list."],regs=['Input:HL Word list'])
blk(0x7436,'c','Print the article for a word',[
 "Decides on and prints the article that goes in front of the word in DE, according to the flags in the top of D.",
 "Names (bit 7 of D set) get no article. They do set the 'capitalise' flag $B5F5 so the name starts with a capital letter; the one exception is YOU, which is left alone.",
 "Other words use bits 4-6 of D as an index (0-3) into a table of articles: #R$AC21 (THE, A, AN, SOME) normally, or #R$AC29 (THE, THE, THE, SOME) when a definite article is wanted ($B5F2 or $70D6 set). So each noun in the dictionary references carries its own article: 'a sword', 'an elvish sword', 'some wine'."],
 regs=['Input:DE Word reference'])
blk(0x746F,'c','Print a word, with an article if required',[
 "If the article flag $B5F4 is set, #R$7436 prints the article first. The flag bits in D are then cleared and the word is printed by #R$74B8."],regs=['Input:DE Word reference'])
blk(0x747F,'c','Print the name of object A',[
 "Prints the name of object A. Object $FF (nobody) is printed as SOMEONE, which is what you see when an unseen character does something: 'someone opens the door'. Otherwise it continues at $73CD in #R$73BE."],regs=['Input:A Object number'])
blk(0x74B1,'c','Print a word from a list',[
 "Fetches the word reference at HL (low byte first), moves HL on by two, strips the flag bits and falls into #R$74B8 to print it. Used to print the words of action table entries and object names one at a time."],regs=['Input:HL Word reference','Output:HL Next word'])

# ---- text output
blk(0x756B,'c','Is output enabled?',[
 "Returns with Z set if nothing should be printed at the moment: output happens only if both $B5EB (the command is really being carried out, not just tried) and $B5F3 (the event can be seen by the player) are non-zero. A is preserved."],regs=['Output:F Z set if printing is switched off'])

A[0x7580]['desc']=["The main character output routine. It does nothing if #R$756B says printing is switched off.",
 "If $B5F2 is set, the character goes to the lower (input) window via #R$75AD, which is how the player's own typing, and replies such as 'I don't know the word', appear down there. Otherwise it goes to the upper story window via #R$7694.",
 "Then comes one of the game's jokes. If the flag at $B5F1 is set, every S (or s) printed in the story window is followed by an H. That flag is set when Bilbo drinks the wine (the wine's object record calls #R$A9ED), and cleared five turns later by timer 7 (#R$A9FF). So for a while after drinking, the game slurs: 'you drink shome wine. gandalf goesh easht.'"]
A[0x7580]['comments']={0x7580:'Printing switched off?',0x7585:'Input window or story window?',0x7590:'Has Bilbo been drinking?',0x7599:'If so, follow every S with an H'}

blk(0x75AC,'c','Print a character in the input window (entry from #R$7580)',["Discards the copy of AF that #R$7580 pushed and continues into #R$75AD."])
A[0x75AD]['title']='Print a character in the lower (input) window'
A[0x75AD]['desc']=["Prints a character in the four-line window at the bottom of the screen, where the player's typing and the game's immediate replies appear. Unlike the story window, this one uses the Spectrum ROM's 8x8 font (#R$766D) at 32 characters per line, and letters are always shown in upper case.",
 "The print position is kept at $75A9 and the number of columns left at $75A8. After each character, the cursor character (from $75AB, a '+') is drawn in the next position, so the player can see where the next key will appear.",
 "ENTER blanks the cursor and scrolls the window up a line (#R$7600). A backspace ($08) rubs out the cursor, moves back one column and draws the cursor there; backspacing past the start of a line scrolls the window down again (#R$763D). Reaching the end of a line also scrolls the window."]
A[0x7694]['desc']=["Prints one character in the story window, which fills the upper part of the screen and uses the game's own 6-pixel font (#R$77BC). The screen address is kept at $768F, the pixel offset within the byte at $7691, and the number of characters left on the line at $768E (42 per line).",
 "Letters are converted to lower case, except that the first letter after a full stop or a new line is capitalised: the flag at $B5F5 is set by those, and cleared once a capital has been printed. This is why the game's text needs no capital letters in the dictionary.",
 "A carriage return sends the finished line to the ZX Printer if it is switched on (#R$7B15), then scrolls the story window up (#R$775E) and starts a new line. Before scrolling, the game checks the line counter at $B606, which is set to 9 each time the player enters a command: after that many lines, each further line waits (for about half a second, or until a key is pressed) so that long bursts of text do not rush past unread. A key held down at that point has to be released before the text continues.",
 "A backspace moves back 6 pixels (#R$7754) and rubs out the character there. A full line wraps automatically.",
 "If $7692 is non-zero, that many spaces are printed at the start of the line first (an indent). This is the routine I used as a hook in the emulator to capture everything the game printed."]

blk(0x7600,'c','Scroll the input window up',[
 "Scrolls the lower window (the four character rows starting at $5060, in the bottom third of the screen) up by one row, a pixel line at a time with LDIR, and then clears the bottom row at $50E0 by printing 32 spaces with #R$766D. All registers are preserved."])
blk(0x763D,'c','Scroll the input window down',[
 "The reverse of #R$7600: moves the lower window's rows down by one character row, working from the bottom. Used when a backspace goes back past the start of a line of typing (#R$75AD)."])
blk(0x766D,'c','Print a character using the ROM font',[
 "Draws character A at screen address HL using the Spectrum ROM's character set at $3D00 (8 x 8 pixels), then moves HL on to the next character cell. Used only for the lower (input) window."],regs=['Input:A Character','HL Screen address','Output:HL Next character position'])
blk(0x7754,'c','Move back one character position',[
 "Moves the story window's print position back 6 pixels: C (the bit offset within the screen byte) is reduced by 6, and if that goes below zero it has 8 added and L is moved back one byte."],regs=['Input:C Bit offset','L Screen address (low byte)'])
blk(0x775E,'c','Scroll the story window up',[
 "Scrolls the top 17 character rows of the screen ($4000 onwards, down to $5020) up by one character row, pixel line by pixel line, taking care of the Spectrum's awkward screen layout at the boundaries between the thirds of the screen. The attributes of those rows are scrolled too (so that a picture's colours move with it). Finally the bottom row of the story window at $5020 is cleared by printing 42 spaces in the 6-pixel font."])

fact('wine','Drinking the wine makes the game slur its words',
 "Drinking the wine in the Elvenking's cellar runs a routine attached to the wine's object record (#R$A9ED), which sets the flag at $B5F1 and starts timer 7. While the flag is set, the character printer (#R$7580) follows every S with an H, so everything the game says comes out slurred: 'you drink shome wine. gandalf goesh easht. thorin shitsh down and shtartsh shinging about gold.' Five turns later timer 7 expires (#R$A9FF) and Bilbo sobers up.")
fact('articles','Articles are stored in the word references',
 "Nouns do not have fixed articles in the dictionary. Instead, the flag bits of each word reference say whether the word takes 'a', 'an', 'some' or 'the' (#R$7436), and names such as Thorin have a flag that suppresses the article and capitalises them. The same noun can therefore be 'a key' in one place and 'the key' in another.")
fact('capitals','There are no capital letters in the game\'s text',
 "Every word is stored in the dictionary in five-bit form, without case. Capitals are added only by the printer (#R$7694): the first letter after a full stop or a new line, and the first letter of a name.")
fact('autowait','The game plays on if you do not type',
 "If the player does not type anything for 20-25 seconds, #R$7240 types WAIT on their behalf and the other characters carry on with their business. This is one of the things that made The Hobbit feel alive in 1982, and one reason players were so often killed while thinking.")
fact('repeat','@ repeats the last command',
 "Pressing SYMBOL SHIFT + 2 (@) as the first key of a line repeats the previous command without retyping it (#R$6E71): the parser simply works through the old tokens again.")
