# Hand-written annotations for The Hobbit v1.0 (overlaid on the auto-generated control file)
# Each entry: address -> dict(type, title, desc=[paragraphs], regs=[...], comments={addr:text}, subs=[(directive,addr,len,comment)], end=addr)
A = {}
def blk(addr, typ, title, desc=(), regs=(), comments=None, subs=(), mid=None):
    A[addr] = dict(t=typ, title=title, desc=list(desc), regs=list(regs), comments=comments or {}, subs=list(subs), mid=mid or {})

# ---------------------------------------------------------------- DATA: dictionaries
blk(0x6000,'w','Dictionary letter index',[
 "Before the vocabulary proper there is a small index of 16-bit little-endian offsets. Entry n (n=1 for A, 2 for B ... 26 for Z) gives the offset from #R$6000 of the first dictionary word that begins with that letter. For example the entry for A is $0040, so the A-words start at #R$6040; the entry for G is $02C1, which is where GANDALF lives. The parser uses this to jump straight to the right part of the dictionary instead of scanning the whole thing.",
 "Entry 0 is unused ($0000). After Z come a few more words, including $07AC, which points into the second (message-only) dictionary at #R$67B0."],
 subs=[('W',0x6000,0x40,'Offsets from $6000 of each letter group')])

blk(0x6040,'b','Main dictionary (the words the player can type)',[
 "This is the vocabulary: every verb, noun, adjective, adverb and direction the parser understands, stored alphabetically. It is also used by the printer, so the same words appear in room descriptions and messages.",
 "Each word is stored with one byte per letter. The low five bits of each byte hold the letter (1=A, 2=B ... 26=Z, 0=no letter). The top three bits of the FIRST TWO bytes of a word carry classification flags instead of being part of the letter: for example verbs such as TAKE, HIT, KILL and CLIMB all have 0 in the first byte's flags and 7 in the second byte's flags, and names such as THORIN and GANDALF have 1 and 1. From the third byte onwards, bit 7 set means 'this is the last letter of the word'. Words shorter than three letters are padded with a byte whose letter bits are 0 and whose bit 7 is set (for example TO is stored as T, O, $80).",
 "Everything else in the game refers to a word by its offset from #R$6000, as a 12-bit number. So SWORD, which starts at $6684, is referred to as $684; THORIN at $66B8 is $6B8; CAVE at $6112 is $112. The spare top four bits of those 16-bit references are flags (for example 'capitalise this word' or 'this is the last word of a name').",
 "Some examples of where words sit: ATTACK $6073, BREAK $60C6, CAVE $6112, CLIMB $612F, GANDALF $62C1, HIT $634B, INVENTORY $6396, KILL $63AC, SWORD $6684, STRONG $6668, SHORT $659D, TAKE $6690, THORIN $66B8, TROLLS $6701."])

blk(0x67B3,'b','Second dictionary (message words)',[
 "A second word list, in exactly the same format as #R$6040, holding words that only the game ever prints: the vocabulary of fights, weather and narration. The player cannot type these words (the parser does not look here), but messages refer to them the same way, by offset from #R$6000. For example BROADSIDE is $84F, DEFENSE $8A6, EFFORT $8CF, FATAL $90C, GLANCING $94C, INEFFECTIVE $9A0, BULBOUS $858 and PALE $A70.",
 "Keeping these out of the main dictionary made the parser's search shorter and stopped players from typing words that had no meaning as commands."])

# ---------------------------------------------------------------- start-up
blk(0x6C00,'c','Game entry point (RANDOMIZE USR 27648)',[
 "The BASIC loader 'hobbit' loads the loading screen to 40000, copies it onto the display, loads this 37,888-byte block at 24576 ($6000) and then does RANDOMIZE USR 27648, which arrives here.",
 "The first job is to make pristine copies of everything that changes during play, so the game can be restarted after Bilbo dies without reloading the tape: the object table (#R$C00B, $614 bytes) and the room table (#R$B97A, $5D9 bytes) are copied up to $F400 onwards, the 28 bytes of game variables at #R$B5DC are copied to $5F00, and the timer and character tables at #R$C973 ($BF bytes) follow the room copy.",
 "Execution then falls through into #R$6C27, which is also the restart point."],
 comments={0x6C01:'Back up the object table...',0x6C0C:'...and the room table...',0x6C14:'...the game variables at B5DC...',0x6C1F:'...and the timer/character tables'})

blk(0x6C27,'c','Start or restart a game',[
 "This is where the game begins, and where it comes back to after 'you are dead' (see #R$903C). It is the reverse of #R$6C00: the backed-up copies of the object table, room table, variables and timer tables are copied back over the live ones, so every object, character, door and timer returns to its starting state.",
 "It then sets the border to black, waits for a key press (the IN A,($FE) loop at $6C6E: keys read as 0 bits, so the loop continues while all five bits are 1), sets up the text window variables used by the printer (#R$75AD), clears a 200-byte work area at #R$B628, and seeds the random number generator from the Z80's R (refresh) register at $6C9E. Because R counts instructions, the seed depends on exactly how long the player took to press a key, which is why every game plays out differently.",
 "The routine then draws the decorative frame (a 16x5 pattern from #R$6DC3 copied to the screen at $5140), puts the first command, LOOK, into the input buffer (copied from $6FEB to $6FF0), and drops into the main loop at #R$6D0A."],
 comments={0x6C3F:'Restore objects, rooms, variables and timers from the backups',0x6C6E:'Wait until a key is pressed',0x6C9E:'Seed the random number generator from R',0x6CFD:'Prime the input buffer with "LOOK"'})

blk(0x6D0A,'c','Main command loop',[
 "This is the heart of the game. Each pass round the loop is one turn for the player:",
 "1. #R$6DCD prints the '>' prompt and reads a line of text into the buffer at $6FF0.",
 "2. The line is split into words, and each word is looked up in the dictionary by #R$6E8E. Each recognised word becomes a two-byte token (the flag nibble and the 12-bit dictionary offset) stored in the token buffer at $7093 (cleared first by #R$70D9). Word class $90 marks a conjunction such as AND or THEN, which splits the input into several commands; $D0 means 'word not found', which jumps to $6D99 to print the complaint about not knowing the word, quoting it back from the input buffer.",
 "3. #R$7C4F parses the tokens into an action (verb, direct object, indirect object, adverb and so on).",
 "4. #R$8351 carries the action out and then lets the rest of the world take its turn: the other characters act, and the timers in #R$C973 tick (see #R$9611).",
 "When a line contains several commands they are executed one after another before the prompt is shown again."],
 comments={0x6D14:'Read a line of input',0x6D28:'Look the next word up in the dictionary',0x6D87:'Parse the tokens',0x6D8D:'Execute the command and run the rest of the turn',0x6D99:'Unknown word: complain and quote it'})

blk(0x6DCD,'c','Read a line of input from the keyboard',[
 "Prints the '>' prompt and a space via #R$7580, then collects up to 128 characters into the buffer at $6FF0, echoing them as they are typed and handling DELETE. Keys come from #R$7B86. The line is terminated by ENTER ($0D)."])

blk(0x6E8E,'c','Look up one word of input in the dictionary',[
 "Skips spaces, remembers where the word began (at $B5CB, so an error message can quote it) and then searches the main dictionary at #R$6040 for it, using the letter index at #R$6000 to start from the right letter. Only as many letters as the player typed need to match, and abbreviations are allowed, which is why N, E, I, INV and so on work.",
 "On return A holds the word's class flags, and BC holds the dictionary reference that gets stored in the token buffer by the main loop."])

blk(0x70D9,'c','Clear a block of memory',[ "Writes B zero bytes starting at HL. A tiny utility used to clear the token buffer and other work areas."],
 regs=['Input:B Number of bytes to clear','HL Start address'])

# ---------------------------------------------------------------- message interpreter
blk(0x72D4,'c','Print a message (message bytecode interpreter)',[
 "Almost everything the game says is printed by this routine, which interprets a compact message 'bytecode' starting at the address in HL. Messages are not stored as ASCII; they are sequences of dictionary references and control codes, which is how The Hobbit fits so much text into 48K.",
 "The entry at $72D4 saves DE, IX and A (restored at the end, $7352) so callers do not lose them. If the game is in a 'dry run' (see #R$9C99), output is suppressed via the flag at $B5EC.",
 "The loop at $72EB fetches a byte and decides what it is:",
 "Byte with bit 7 set: the start of a two-byte dictionary reference. The low nibble of the first byte and all of the second form the 12-bit word offset from #R$6000; the rest of the first byte are flags (upper case, full stop after, space handling). References whose flag nibble is $20, $30 or $60 are special: they print the name of the current actor, target or object rather than a fixed word (so the same message can say 'you attack thorin' or 'thorin attacks you'). Ordinary words are printed by #R$74B8.",
 "Byte $60-$7F: a one-byte abbreviation for a very common word. #R$748A looks it up in the table at #R$AC31.",
 "Byte $20-$5F: a literal character (punctuation and the like), printed directly.",
 "Byte $00-$1F: a control code. The code is used as an index into the jump table at #R$728C. The control codes implement a tiny programming language: end of message, jumps, conditional tests on object flags and locations, 'print the actor's name', and so on. Codes below $14 return a flag that decides whether the interpreter carries on or stops. This same interpreter runs the little scripts attached to rooms and objects (see #R$B97A and #R$C00B), which is why data tables contain what look like fragments of messages."],
 regs=['Input:HL Address of the message bytecode'],
 comments={0x72EE:'Bit 7 set: a dictionary word reference',0x72FA:'Special word classes that name the actor/target/object',0x7308:'Print an ordinary dictionary word',0x730F:'Otherwise: control code, abbreviation or literal character',0x7315:'$60-$7F: one-byte abbreviation',0x7321:'$00-$1F: index into the control-code jump table'})

blk(0x728C,'w','Message interpreter control-code jump table',[
 "Addresses of the handlers for message control codes $00 to $16, used by #R$72D4. For instance code $00 (#R$735E) ends the message, code $01 returns a value to the caller, code $02 (#R$7375) is a relative jump within the message, and code $0D is 'print the next byte as a character' (#R$72BA). The entries after $16 are not part of the table."],
 subs=[('W',0x728C,0x2E,'Handlers for codes $00-$16')])

blk(0x748A,'c','Print an abbreviated word',[
 "Message bytes $60-$7F stand for the 32 most common words. The byte minus $60 indexes the table at #R$AC31 to get a dictionary reference (the high byte has $50 added so it lands in the right flag range), and then the word is printed exactly as if it had been written out in full, by jumping back into #R$72D4."])

blk(0x74B8,'c','Print a dictionary word',[
 "Prints one word from the dictionary. On entry D and E hold the word reference: the low nibble of D and all of E are the offset from #R$6000, and the high nibble of D holds formatting flags. A reference of zero prints nothing.",
 "The letters are unpacked into a small buffer at $749D, turning the five-bit letter codes into lower-case ASCII by adding $60, and stopping at the byte with bit 7 set (with the special rule that the first two bytes of a word never end it, because their top bits are classification flags; see #R$6040). The flags then decide whether the first letter is capitalised and what punctuation and spacing follow."],
 regs=['Input:DE Word reference (flags in the high nibble of D)'])

# ---------------------------------------------------------------- text output
blk(0x7578,'c','Print a newline',[ "Prints a carriage return ($0D) via #R$7580, preserving A."])
blk(0x7580,'c','Print a character',[ "The main character output routine used by the rest of the game. It passes the character on to the text-window printer at #R$75AD, but only when printing is currently enabled (the flag at $B5F3 is used to silence output when, for example, events happen out of Bilbo's sight)."],regs=['Input:A Character to print'])
blk(0x75AD,'c','Print a character in the text window (word wrap)',[
 "Handles the layout of the lower text window: it buffers characters into words so that a word is never split across the end of a line, deals with carriage returns and backspace (code 8), and scrolls the window when it is full. Characters that have been laid out are handed to #R$7694."])
blk(0x7694,'c','Put a character on the screen',[
 "Places one character at the current text position. The screen address is kept at $768F and the bit position within the byte at $7691. For a carriage return, the routine moves to the next line; if the text window is full it pauses (the IN A,($FE) loop around $76D6 waits for a key, with a time-out) and scrolls. Other characters are drawn by #R$77BC. This is the routine I used as a hook in the emulator to capture everything the game printed."],regs=['Input:A Character code'])
blk(0x77BC,'c','Draw a character glyph',[
 "Draws one 8x8 character from the font at #R$7815. The glyph address is $7715 + 8 x character code (the font only defines codes $20 to $7F, so the table effectively starts at $7815).",
 "Characters are drawn on a 6-pixel pitch rather than the Spectrum's usual 8, which is why The Hobbit fits more text on a line than most Spectrum games. C holds the pixel offset within the current screen byte, so each glyph row is shifted right by C bits and may straddle two screen bytes: the first part is masked into (HL) and the overflow is shifted left and masked into (HL+1). After drawing, C is advanced by 6 and, if it passes 8, L moves on to the next byte."],
 regs=['Input:A Character code','C Pixel offset within the screen byte (0-7)','HL Screen address of the top row'])
blk(0x7815,'b','Font',[
 "96 characters, codes $20 (space) to $7F, 8 bytes each, top row first. Each glyph uses only the left 6 pixels, matching the 6-pixel character pitch used by #R$77BC. For example 'A' is at $791D: $00,$38,$44,$44,$7C,$44,$44,$00.",
 "#FONT$7815,96"],subs=[('B',0x7815,0x300,'Characters $20-$7F')])

blk(0x7B86,'c','Read a key',[
 "Scans the keyboard directly through port $FE (the game does not use the ROM's keyboard routine or interrupts) and returns the ASCII code of a newly pressed key in A, or 0 if no new key has been pressed. It keeps track of the previous key so that holding a key down does not repeat it. The keyboard map used to turn a row/bit into a character sits just before it.",
 "In my emulator I replaced this routine with one that feeds typed commands to the game, which is how the tests of the sword and the pale bulbous eyes were run."],regs=['Output:A ASCII code of the key, or 0'])

blk(0x7C4F,'c','Parse the command',[
 "Works through the tokens produced by #R$6E8E (in the buffer at $7093) and fills in the parser's 'action frame' at #R$B8B8: the verb, the direct object, the preposition and indirect object (the 'with sword' in 'hit thorin with sword'), any adverb (e.g. 'viciously', 'quickly') and, for SAY TO commands, the character being addressed and the quoted text.",
 "Nouns are matched to objects by comparing the word and any adjectives against the four word slots in each object record (see #R$C00B), so 'take the large key' and 'take key' can both work. Where several objects fit, objects in the current room and in Bilbo's possession are preferred.",
 "If the sentence does not make sense the parser prints one of its complaints and returns with the Z flag reset, and the main loop goes back to the prompt without using up a turn."])

blk(0x8351,'c','Execute a command and run the turn',[
 "Carries out the action frame built by #R$7C4F. The verb selects a handler (for example #R$90DB for HIT, ATTACK, KILL, SMASH, STRIKE and so on; #R$8D19 for movement).",
 "After the player's action it calls #R$7122 and #R$946F to update the world, then #R$9611, which advances the turn timers (the 'pale bulbous eyes', the troll sunrise, the butler and so on) and lets the other characters act. The loop at $837F repeats while more commands from the same input line are waiting."])

blk(0x8D19,'c','Move an actor (GO north, EAST, etc.)',[
 "Moves the current actor (the player, or another character when called from #R$976C) through an exit of the room they are in.",
 "The direction is looked up in the list of exits in the room record (see #R$B97A): each exit is three bytes - direction, a door/condition byte, and the destination room number. The destination is saved at $8D17. If the exit has a door, the door object must be open; if the actor is carrying something that lets them 'fall', or has a limit on what they may carry, those are checked too.",
 "After the move, the actor's location byte in their object record is updated (the LD (IY+$10),B at $8DC4 - offset 16 is the first location byte, see #R$C00B), and if the actor is the player, the table of room-entry handlers at #R$C67D is searched for the destination room (at $8DD3). If a handler exists, it is called. This is how entering the forest road or forest starts the 'pale bulbous eyes' timer (#R$C6CC)."],
 comments={0x8D7C:'Save the destination room number',0x8DC4:'Update the actor\'s location',0x8DD3:'Look up the room-entry handler for the destination',0x8DE5:'Call it'})

blk(0x903C,'c','The player is dead',[
 "Called whenever Bilbo is killed (for example by Thorin at the end of the fight in #R$90DB, or by the stinging thing in #R$AA2E). Prints 'you are dead' and the score ('you have mastered 0.0% of this adventure') from the message at #R$AEE3 and #R$81AD, waits for a key, and restarts the game at #R$6C27 with everything restored from the backups."])

# ---------------------------------------------------------------- combat
blk(0x90B4,'c','Check that a target can be attacked',[
 "Used before a fight to check that the target is a character (not, say, a door or a piece of food) using the flag bits in header byte 4 of its object record. If it is not, a suitable message is printed and the attack does not happen."])

blk(0x90DB,'c','Attack (HIT, KILL, ATTACK, STRIKE, SMASH ...)',[
 "The fight routine. It is used both when the player attacks someone and when another character attacks (for example Thorin retaliating, or the trolls and goblins attacking Bilbo). The attacker's object record is pointed to by $B5FC, the target's by $B5F8, and the weapon's (if any) by $B5FA; $B5DA holds the weapon's object number, or $FF when there is none.",
 "It uses two bytes of the 8-byte object header (see #R$C00B): byte 5 is STRENGTH and byte 6 is DEFENCE. Some starting values: Bilbo 64/64, Thorin 104/120, Gandalf 112/136, the trolls 160/160, the goblins 72/96, Bard 96/96, the dragon 192/192, and the short strong sword has strength 64 (255 in my modified tape).",
 "Step 1: 'you attack thorin' is printed ($90FE onwards), naming the weapon if one was used.",
 "Step 2: the attack value is the attacker's strength ($90F9), plus the weapon's strength if one was used ($9102-$9116), capped at 255. A weapon is only accepted if byte 0 of its record is 1 (an ordinary one-place object); otherwise the message at #R$AE52 is printed.",
 "Step 3: the attack value is randomised by #R$917D (roughly -10 to +10) and so is the target's defence ($9121-$912A).",
 "Step 4: if the randomised defence is greater than or equal to the attack, the blow does nothing: 'but the effort is wasted. his defense is too strong' (#R$AE43).",
 "Step 5: if the attack exceeds the defence by more than 16, the blow is fatal. The message at #R$AD2D ('with one well placed blow you cleave his skull') is printed and bit 3 of the target's flag byte (byte 7) is set, marking it dead ($9168).",
 "Step 6: otherwise the target is wounded. The difference d (1-16) selects a message from the table at #R$9190 - the larger the margin the nastier the description. The code then tries to reduce the target's strength by d/2+1 and its defence by d/4+1 ($914E-$9164), skipping either reduction if it would go below 0. It computes d/2 and d/4 with RRCA (rotate right) rather than SRL (shift right), though.",
 "BUG: RRCA moves the bit shifted out of the bottom back into the top, so the halving only works when the bit being shifted out is 0. With Thorin (strength 104, defence 120) the actual results are: margins 4, 8, 12 and 16 reduce both strength and defence as intended (for example margin 8 takes him to 99/117); margins 2, 6, 10 and 14 reduce strength only; margins 3, 7, 11 and 15 do nothing at all; and margins 1, 5, 9 and 13 leave strength alone but slash his defence by about 65, to 52-55, which makes the next blow very likely to kill him.",
 "BUG: the table at #R$9190 only has useful entries for differences 1 to 15. A difference of exactly 16 reads the two bytes at $91B0 (which are code, $DD $2A) as a message address, so the game interprets ROM at $2ADD as a message and prints garbage."],
 comments={0x90FF:'Is there a weapon? ($FF = none)',0x90F9:'B = attacker strength',0x9110:'Add the weapon strength',0x9119:'Randomise the attack value',0x911E:'Dry-run check (see 9C99)',0x9121:'IX = target',0x9125:'Randomise the target\'s defence',0x912B:'Defence >= attack: the blow is wasted',0x9139:'Margin > 16: a fatal blow',0x913E:'Use the margin to pick a wound message',0x914E:'d/2 (by RRCA - see the bug note)',0x9151:'Reduce the target\'s strength...',0x915A:'...and defence by d/4',0x9168:'Fatal blow message; mark the target dead'})

blk(0x917D,'c','Randomise a fight value',[
 "Adds a random amount to the value in B, using #R$9BFD with a range of 10, and returns the result in A, clamped to 0-255.",
 "The random amount C is a signed number between -10 and +10, but it is heavily biased towards positive values: only about 1 in 25 adjustments is negative, and +1 to +5 are twice as likely as +6 to +10 (see #R$9BFD).",
 "BUG: the clamping is wrong for negative adjustments. After ADD A,B the code treats the carry flag as 'overflow'. When C is negative (say -3, which is $FD) and B is at least 3, the addition B+$FD always produces a carry, even though the true result (B-3) is perfectly valid. The code then sees that C is negative and returns 0 instead of B-3. So whenever the adjustment is negative, the value collapses to 0. When this happens to a defence value, the next blow is almost certainly fatal; when it happens to an attack value, the blow is wasted. This bug is the reason a bare-handed Bilbo occasionally kills Thorin, and one reason for the game's famous sudden deaths."],
 regs=['Input:B Value to randomise','Output:A Randomised value (0-255)'],
 comments={0x9184:'C = random adjustment (-10 to +10)',0x9185:'A = value + adjustment',0x9186:'No carry: done',0x9188:'Carry: A=0...',0x9189:'...and if C is negative, return 0 (the bug)',0x918D:'Otherwise return 255'})

blk(0x9190,'w','Wound messages',[
 "Addresses of the messages printed when a blow wounds but does not kill, indexed by twice the margin by which the attack beat the defence (see #R$90DB). Entry 0 is never used (a margin of 0 means the blow was wasted). The small margins give the mildest messages and the larger margins the most violent ones, such as 'you hit thorin hard on the shoulder - thorin staggers and almost falls'.",
 "The table has 16 entries ($9190-$91AF), but the margin can be 16, which reads past the end into the code at $91B0 (see the bug note in #R$90DB)."],
 subs=[('W',0x9190,0x20,'Messages for margins 0-15')])

# ---------------------------------------------------------------- turn processing
blk(0x9611,'c','End of turn: run the timers',[
 "Called once per turn after the player's command. First #R$A8CA and #R$976C (via $9618 and $961B) let the other characters take their turns, then the timer table at #R$C973 is processed.",
 "Each 7-byte timer entry has: a reload value, the current count, the address of an 'expire' routine, a threshold, and the address of a 'tick' routine. A count of 0 means the timer is not running. For each running timer the count is decremented ($963B). If it has just reached 0, the expire routine is called ($9657). If it is still above 0 but at or below the threshold, the tick routine is called instead ($966E).",
 "Only one timer is allowed to expire per turn: the flag at $B5E1 records that one has already fired, and any other timer that reaches 0 in the same turn is given a count of 1 so that it fires next turn instead.",
 "Timers are started by setting their count to their reload value, which various event routines do by copying byte 0 of the entry to byte 1 (for example #R$C6CC)."],
 comments={0x9629:'IY = first timer entry',0x962D:'End of table?',0x9634:'Skip timers that are not running',0x963B:'Count down',0x9643:'Reached 0: has a timer already expired this turn?',0x9651:'Call the expire routine',0x965C:'Still counting: at or below the threshold?',0x9668:'Call the tick routine',0x9671:'Next entry'})

blk(0x976C,'c','Let the other characters act',[
 "This is The Hobbit's famous 'independent characters' system. It walks through the character table at #R$C9BA; for each character that is alive, it makes that character the current actor (setting $B5DB to its object number, and $B5FC to its record) and runs its behaviour: follow Bilbo, wander, pick things up, attack, open doors, sing about gold, and so on. The same command routines the player uses (movement #R$8D19, attack #R$90DB, taking objects) are reused with a different actor, which is why the messages come out as 'thorin attacks you' or 'gandalf opens the round green door'.",
 "Whether the player sees what the character does depends on whether they are in the same room; output for events out of sight is suppressed through the flag at $B5F3.",
 "Each character's behaviour routine is chosen from the table, and they are all given a degree of randomness through #R$9BFD, which is why the characters behave differently in every game."])

blk(0x9AC7,'c','Call the routine at HL (if HL is not 0)',[
 "A general dispatcher used throughout the game for tables of routine addresses (the room-entry handlers, the timer table, the character table). All registers except AF are preserved, and a zero address means 'no routine', so tables can leave entries empty. The actual call is made by the JP (HL) at #R$9ADB."],regs=['Input:HL Routine address, or 0'])

blk(0x9B0C,'c','Get the address of a room record',[
 "Returns the address of the record for room number A (0-79) from the room pointer table at #R$B8D0. Numbers of $50 (80) and above are not rooms; for those, A is set to 0 and the routine returns with the Z flag set."],regs=['Input:A Room number','Output:IX Room record'])

blk(0x9B25,'c','Get the address of an object record',[
 "Looks up object number A in the object index table at #R$BF53 (using #R$9D12) and returns the address of its record in IX. Everything that can be manipulated - Bilbo himself (object 0), the other characters, doors, food, weapons, keys - is an 'object' with a record in #R$C00B."],regs=['Input:A Object number','Output:IX Object record'])

blk(0x9BFD,'c','Random number in a range',[
 "Returns a random number in A in the range -C to +C (signed). The random byte is produced from the seed at $B5FE (set from the R register in #R$6C27), the counter at $B602 and a byte fetched from memory.",
 "The way it narrows the random byte down to the range is unusual: B is set to 2*C, and then the random byte is halved (SRL A) until it is no more than B. Finally C is subtracted. Because 0-255 has to be halved several times, the upper half of the range gets far more than its share: with C=10, values 0-10 of the byte (results -10 to 0) mostly come only from the original byte being 0-10 directly, while 11-20 are hit by many different starting values. For C=10 the results come out approximately: each of -10 to -1: 1/256; 0: 16/256; +1 to +5: 31/256 each; +6 to +10: 15/256 each."],
 regs=['Input:C Range','Output:A Random value from -C to +C'])

blk(0x9C99,'c','Check for a dry run',[
 "The command routines are run more than once: first as a 'dry run' to find out whether a command is possible (for example while the parser is choosing between two objects that fit the same noun), and then for real. The flag at $B5EB is 1 when the action should really happen. If it is not, this routine sets $B5EC to record that the action would have succeeded, discards its own return address and returns to the caller's caller, so the rest of the command routine is skipped. That is why the fight routine calls this after rolling the attack value but before doing anything that has a visible effect."])

blk(0x9D12,'c','Search a table of 3-byte entries',[
 "Searches a table at IX made of 3-byte entries, each a one-byte key followed by a two-byte value, for the key in A. The table ends with $FF. Returns with IX pointing at the matching entry if found, or at the terminating $FF entry if not. The flags are set by a final CP $FF on the entry's own key: Z is SET when that key is $FF, so Z RESET (NZ) means the search succeeded and Z SET means it ran off the end without a match; equivalently, the carry flag is SET when the entry was found. This is easy to get backwards, so callers are shown branching on NZ/carry for success and Z for failure throughout this disassembly. Used for the object index (#R$BF53), the room-entry handlers (#R$C67D) and several other tables."],regs=['Input:A Key','IX Table','Output:IX Matching entry, or the $FF terminator','F Z SET if not found (end of table); NZ or carry set if found'])

# ---------------------------------------------------------------- timer event routines
blk(0xAA13,'c','Pale bulbous eyes: tick routine',[
 "Called by #R$9611 on each turn that the eyes timer (entry at #R$C9AB) is counting down and at or below its threshold of 3. It prints 'you see some pale bulbous eyes staring at you' (#R$B203).",
 "It then checks whether Bilbo has moved. $C01B is Bilbo's location (the first location byte of object 0, see #R$C00B) and $B5E4 is the room he was in when the timer was started. If he is still in the same room, all is well. If he has moved to the other 'eyes' room (from 2 to 3 or from 3 to 2), all is also well. Otherwise he has left too early: execution falls into #R$AA3E, which prints 'some thing drops from above and stings' (#R$B211) and kills him (#R$903C).",
 "In practice the room-2/room-3 exception is never needed, because entering either room restarts the timer anyway (see #R$C6CC)."],
 comments={0xAA13:'Print the eyes message',0xAA19:'C = Bilbo\'s current room',0xAA20:'Still in the same room: fine',0xAA23:'A = the other eyes room',0xAA2A:'Moved to the other eyes room: fine',0xAA2C:'Otherwise: stung to death'})

blk(0xAA2E,'c','Pale bulbous eyes: expire routine',[
 "Called by #R$9611 when the eyes timer reaches 0. If Bilbo is still in room 2 (the forest road) or room 3 (the forest), he has stayed too long: the eyes are shown, the thing drops from above and stings, and Bilbo dies. If he is anywhere else, nothing happens.",
 "Together with #R$AA13 and #R$C6CC, this produces the well-known rule: on entering the forest, wait twice and move on the third turn. The timer is set to 4 on entry; the turn of entry leaves it at 3, the two waits take it to 2 and then 1 (the tick routine is happy each time because Bilbo is still there), and the move takes it to 0 with Bilbo already out of the forest. Wait a third time and the timer expires with Bilbo still there; move sooner and the tick routine sees him gone while the timer is still running."],
 comments={0xAA2E:'Is Bilbo in room 2 or room 3?',0xAA38:'Yes: eyes...',0xAA3E:'...sting...',0xAA44:'...and death'})

blk(0xAC31,'w','Abbreviated words',[
 "The 32 most frequent words in messages, referenced by single bytes $60-$7F (see #R$748A). Each entry is a dictionary reference with $50 subtracted from its high byte. Using one byte instead of two for words such as 'the', 'you', 'is' and 'and' saves a lot of space across all the game's messages."],
 subs=[('W',0xAC31,0x40,'Words for codes $60-$7F')])

blk(0xAC71,'b','Messages and scripts',[
 "The bulk of the game's messages, in the bytecode format interpreted by #R$72D4. Some that have been identified:",
 "#LIST { $AD2D - fatal blow ('with one well placed blow ... cleaves ... skull') } { $AE43 - 'but the effort is wasted. his defense is too strong' } { $AEE3 - 'you are dead' } { $B203 - 'you see some pale bulbous eyes staring at you' } { $B211 - 'some thing drops from above and stings' } LIST#",
 "The wound messages are listed in the table at #R$9190."])

# ---------------------------------------------------------------- variables
blk(0xB5CB,'g','Game variables',[
 "Working variables. Those identified so far:",
 "#LIST { $B5CB - address of the current word in the input line (for error messages) } { $B5DA - object number of the weapon/instrument in the current command, or $FF } { $B5DB - the current actor: 0 when the player is acting, otherwise the object number of the character } { $B5E1 - set when a timer has expired this turn (#R$9611) } { $B5E4 - the room in which the eyes timer was started (#R$C6CC) } { $B5EB - 1 when commands should really be carried out, 0 during a dry run (#R$9C99) } { $B5F3 - output enable flag } { $B5F8 - address of the target's object record } { $B5FA - address of the weapon's object record } { $B5FC - address of the actor's object record } { $B5FE - random number seed (#R$9BFD) } LIST#",
 "The 28 bytes from $B5DC are backed up to $5F00 at start-up and restored when the game restarts."])

# ---------------------------------------------------------------- rooms
blk(0xB8D0,'w','Room pointer table',[
 "Addresses of the records for rooms 0 to 79 (used by #R$9B0C). Room numbers are what appear in objects' location bytes and in the exits of other rooms. Some examples: 1 is Bilbo's comfortable tunnel-like hall, 2 is the forest road and 3 the forest (the 'pale bulbous eyes' rooms), 5 is the trolls' clearing, 7 is the trolls' cave, 22 is Beorn's house, 26 is the place of black spiders, 29 is the deep bog, 46 is the stretch of forest road west of the eyes, and 61 is where the golden ring starts."],
 subs=[('W',0xB8D0,0xA0,'Rooms 0-79')])

blk(0xB97A,'b','Room records',[
 "One record per room, in no particular order (the table at #R$B8D0 points to each one). The format, using room 2 (the forest road) as an example, whose record is at $BDC3 and reads $86,$FF,$53,$05,$A4,$02,$00,$00,$00,$00,$03,$00,$03,$04,$00,$2E,$FF:",
 "Byte 0: flags ($86). Byte 1: $FF.",
 "Bytes 2-7: up to three word references (little-endian, offsets from #R$6000) that make up the room's name: here $0553 ROAD and $02A4 FOREST, printed as 'you are on the forest road'. Unused slots are 0.",
 "Bytes 8-9: the address of an extra description script, or 0 if there is none. Room 7, the trolls' cave, uses this for its extra text.",
 "Then any number of 3-byte exits: direction, a door/condition byte (non-zero when the way is through a door or has some other condition) and the destination room. Here: $03 (east) to room 3, and $04 (west) to room 46 ($2E). The list ends with $FF.",
 "These records are backed up at start-up and restored on restart (#R$6C00), because doors and some descriptions change during play."])

# ---------------------------------------------------------------- objects
blk(0xBF53,'b','Object index',[
 "3-byte entries: object number, then the address of that object's record in #R$C00B. Terminated by $FF. Searched by #R$9B25. Some numbers: 0 YOU (Bilbo), 5 the round green door, 12 the large trap door, 14 the short strong sword, 16 the golden ring, 18 the rope, 33 the cupboard, 62 Gandalf, 63 Thorin, 71 and 72 the trolls."])

blk(0xC00B,'b','Object records',[
 "Every object, character and door in the game has a record here. They are backed up at start-up and restored when the game restarts. As an example, the short strong sword (object 14) at $C1F4 in the original game:",
 "$01,$FF,$03,$04,$00,$40,$80,$94, $84,$06,$9D,$05,$68,$06,$00,$00, $07, $0B,$57,$92,$FF",
 "Byte 0: the number of locations the object occupies. Ordinary objects and characters have 1; doors have 2 (one on each side).",
 "Byte 1: who is holding it, or what it is inside: an object number, or $FF for nobody. The curious map starts with 62 (Gandalf) here, the large key with 71 (a troll), the food with 33 (the cupboard). In my modified tape the sword has 0 here: Bilbo.",
 "Bytes 2-4: physical attributes (the sword has 3 and 4 in bytes 2 and 3, which look like size and weight) and flag bits used by #R$90B4 and elsewhere.",
 "Byte 5: STRENGTH, byte 6: DEFENCE (see #R$90DB). The sword's strength is $40 (64).",
 "Byte 7: flags. Bit 3 set means dead or destroyed; others mark things such as 'can be opened', 'is lit' and 'has been seen'.",
 "Bytes 8-15: four word slots (little-endian references, offsets from #R$6000): the noun followed by adjectives. For the sword: $0684 SWORD, $059D SHORT, $0668 STRONG, 0.",
 "Then one location byte per location (byte 0 says how many): here room 7, the trolls' cave. Changing this byte (at $C204) moves the sword; I changed it to 1 so that the sword starts with Bilbo.",
 "Then a list of the object's own action handlers, three bytes each: an action number (see #R$AA47) and the address of a routine to run when that action is done to the object. An entry with action 0 straight after a matching entry is run as well, so several routines can be chained. The list ends with $FF. The sword's list has one entry: action 11 (STRIKE) runs $9257. The wine's has action 33 (DRINK) followed by action 0 running #R$A9ED, which is what makes Bilbo drunk. Actions that an object has no handler for fall back on the default handlers at #R$C61F (see #R$946F).",
 "Offset 16 (the first location byte) is what the movement routine updates (#R$8D19). For Bilbo, this is $C01B."])

blk(0xC67D,'b','Room-entry handlers',[
 "3-byte entries: a room number and the address of a routine to call when the player enters that room (see #R$8D19). Terminated by $FF.",
 "#LIST { Room 22 ($16, Beorn's house): #R$C693 - switches the butler on } { Room 26 ($1A, the place of black spiders): #R$C6A1 - starts timer #R$C981 } { Room 29 ($1D, the deep bog): #R$C6A8 - starts timer #R$C98F } { Room 33 ($21, the forest river): #R$C6D9 - death unless Bilbo is in the barrel } { Room 2 ($02): #R$C6CC - the pale bulbous eyes } { Room 3 ($03): #R$C6CC - the pale bulbous eyes } { Room 32 ($20, the Elvenking's cellar): #R$C6AF - switches the dragon and Bard on, and starts the side door timer } LIST#"],
 subs=[('B',0xC67D,0x15,'Room, handler address'),('B',0xC692,1,'End marker')])

blk(0xC6CC,'c','Room-entry handler: the forest (rooms 2 and 3)',[
 "Called when Bilbo enters the forest road (room 2) or the forest (room 3). It records the room he has just entered (from $8D17, set by #R$8D19) in $B5E4, and starts the 'pale bulbous eyes' timer at #R$C9AB by copying its reload value (4) into its count.",
 "The rest of the mechanism is in #R$AA13 and #R$AA2E."],
 comments={0xC6CC:'Remember which room the timer started in',0xC6D2:'Start the eyes timer (count = 4)'})

blk(0xC973,'b','Turn timers',[
 "Ten 7-byte entries processed every turn by #R$9611, terminated by $FF. The layout of each entry is:",
 "#LIST { Byte 0: reload value (copied into byte 1 to start the timer) } { Byte 1: current count (0 = not running) } { Bytes 2-3: expire routine, called when the count reaches 0 } { Byte 4: threshold (0 = no tick routine) } { Bytes 5-6: tick routine, called while the count is between 1 and the threshold } LIST#",
 "The pale bulbous eyes use the entry at $C9AB: reload 4, count 0, expire routine #R$AA2E, threshold 3, tick routine #R$AA13.",
 "Other entries drive, for example, the barrel floating down the river (timer 0, #R$A4F4), the spiders' place (timer 2) and Bilbo's drunkenness after the wine (timer 7, #R$A9ED)."],
 subs=[('B',0xC973,7,'Timer 0'),('B',0xC97A,7,'Timer 1'),('B',0xC981,7,'Timer 2 (started in room 26)'),('B',0xC988,7,'Timer 3'),('B',0xC98F,7,'Timer 4 (started in room 29)'),('B',0xC996,7,'Timer 5'),('B',0xC99D,7,'Timer 6'),('B',0xC9A4,7,'Timer 7'),('B',0xC9AB,7,'Timer 8: the pale bulbous eyes'),('B',0xC9B2,7,'Timer 9'),('B',0xC9B9,1,'End marker')])

blk(0xC9BA,'b','Character table',[
 "The list of independent characters processed by #R$976C, 7 bytes each, terminated by $FF. Byte 0 is the character's object number: $3E Gandalf, $3F Thorin, $40, $43, $41, $44 and so on, $41 Elrond, $44 Gollum, $47 and $48 the trolls, and $3D, $45, $49, $4A, $4B and $4C the goblins. The following bytes hold a behaviour setting and the addresses of the character's behaviour routines."],
 subs=[('B',0xC9BA,0x77,'Characters'),('B',0xCA31,1,'End marker')])
