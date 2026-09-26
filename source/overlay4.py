# Batch 4: parser, special commands and command execution
from overlay import A, blk
from overlay3 import fact, bug
EXTRA_REGIONS={}
def code(a,end,title,desc,**kw):
    blk(a,'c',title,desc,**kw); EXTRA_REGIONS[a]=end

A[0x7C4F]['desc']=[
 "The parser. It works through the tokens in #R$7093 (the pointer to the next token is kept at $B5CD) and turns them into one or more 24-byte command frames, starting at #R$B8B8 and growing downwards in memory ($B8A0, $B888...). The number of frames built is counted in $B5F7.",
 "A frame holds: the verb (offset 0; bit 6 of byte 1 marks a frame that belongs to a quotation and bit 7 marks ALL EXCEPT), an adverb, direction or particle (offset 2), and two noun phrases of 10 bytes each (offsets 4 and 14). A noun phrase is two prepositions, a noun and two adjectives, so 'put the small curious key in the wooden chest' becomes PUT, (KEY, SMALL, CURIOUS), (IN, CHEST, WOODEN).",
 "The parser is a state machine. Register E holds a set of flags saying what may come next: bit 1 'a verb may start here', bit 2 'an adverb is allowed', bit 3 'we have just had AND', bit 4 'an article is allowed', bit 6 'the first noun phrase is still empty', bit 7 'the second noun phrase is still empty', bit 0 'the verb has been followed by a direction'. Register D holds the class of the token being processed.",
 "For each token, #R$7F3D fetches it and the class (top nibble, divided by 8) indexes the jump table at #R$7C9C, which sends it to a handler: adverbs to $7DBC, IN/INTO to #R$7E5F, directions to #R$7DB6, verbs to $7DFD, GO/RUN to #R$7DF9, nouns to $7E9B, adjectives to $7E93, prepositions to #R$7E6C, articles to #R$7E5A, special words to #R$8009, AND to #R$7DD5, THEN (and full stop) to $7CC4 and the end of the line to #R$7CC0.",
 "A word that is not allowed where it appears goes to #R$7FEE, which prints 'what?' (inside a quotation it is ignored instead, so that orders to other characters are more forgiving).",
 "If a previous command was left unfinished ($B60A set, for example after the game asked 'which key?'), the parser starts in a different state so that the words just typed are fitted into the old frame (see $7CFC)."]

blk(0x7C9C,'w','Parser jump table',[
 "Addresses of the parser's handler for each word class (see #R$7C4F), indexed by class / 16."],
 subs=[('W',0x7C9C,26,'Adverb, IN/INTO, direction, verb, GO/RUN, noun, adjective, preposition, article, special, AND, THEN, end of line')])
blk(0x7CB6,'c','Is the parser inside a quotation (set Z)?',["Returns with Z set if $B60B is exactly 1 (inside one level of quotation)."])
blk(0x7CBB,'c','Is the parser inside a quotation?',["Returns with Z reset if $B60B is non-zero (inside a quotation), Z set otherwise."])
blk(0x7CC0,'c','Parser: end of line (and THEN / full stop)',[
 "Handles the end-of-line token, and (from $7CC4) THEN or a full stop. It closes the current command frame. If a verb was required but none was given it complains (#R$7FF9).",
 "For ALL (see #R$808A) the verb is flagged. The frame count $B5F7 is increased and, for THEN, the parser goes back to the start state for the next command ($7C6A).",
 "At the end of the line some tidying up is done. If the previous command was unfinished ($B60A), the new words are merged into it ($7D02-$7D4B): empty slots in the old frame are filled from the new one. Then frames that have no verb of their own (because of AND, as in 'take the key and the sword') are given the verb of the frame before them (#R$7F81). Finally, noun phrases consisting of IT are resolved, and if a quotation is still open the parser starts again."])
blk(0x7DB6,'c','Parser: a direction',[
 "A direction on its own ('north') is a complete movement command: if a verb may start here (bit 1 of E), it is treated as GO NORTH ($7DFB). After a verb, a direction is stored as the frame's particle, like an adverb ($7DBC): bit 2 of E must allow it, and it is put at offset 2 of the frame (#R$7FE2). The entry at $7DBC is the handler for adverbs."])
code(0x7DD5,0x7DF9,'Parser: AND',[
 "AND (or a comma) is ambiguous: it may join two objects ('take the key and the sword') or two commands ('take the key and go east'). The parser cannot tell until it sees what follows, so it records where it is: the token pointer (in $7C3E and $B5CD, pointing back at the AND), the state flags E ($7C40), the frame pointer IY ($7C41) and the frame count ($7C43). It then carries on as though a new command had begun ($7CC4). If a verb turns up next, the new command stands. If not, the verb handler at $7DFD is never reached and the next frame inherits the verb of this one (#R$7F81).",
 "Bit 3 of E is reset to show that an AND has just been seen."])
code(0x7DF9,0x7DFB,'Parser: GO or RUN',["Clears bit 0 of E and continues into #R$7DFB, so that GO and RUN are treated as verbs that may be followed by a direction."])
blk(0x7DFB,'c','Parser: a verb',[
 "The entry at $7DFB (from #R$7DB6) supplies the verb GO ($30 class) for a bare direction; the entry at $7DFD handles verbs typed by the player.",
 "If a verb arrives when a command has already been started and there has been no AND, the parser backtracks: the state saved by the last AND (#R$7DD5) is restored and the AND is reinterpreted as THEN, splitting the line into two commands.",
 "Otherwise the verb must be allowed here (bit 1 of E). It is stored at offset 0 of the frame (#R$7FDE). GO and RUN look ahead (from $7E31) past any adverbs: if the next word is a direction, the verb is dropped and the direction stored as the particle, so that 'go north' and 'north' produce the same frame."])
code(0x7E5A,0x7E5F,'Parser: an article',["Articles (A, AN, THE and the like) are ignored, apart from clearing bit 4 of E; the parser goes straight on to the next word ($7C88)."])
code(0x7E5F,0x7E6C,'Parser: IN or INTO',[
 "IN and INTO are usually prepositions, and are handled as such (#R$7E6C, with class $70). The exception is when a verb may start here and the previous word was AND or a comma, in which case they begin a new command such as 'and in': the parser jumps back to $7DFB to treat them like a direction."])
blk(0x7E6C,'c','Parser: a noun phrase',[
 "Collects one noun phrase into the buffer at $7C45 (cleared by the main parser loop): up to two prepositions (#R$7EE6; a third one is an error), any number of articles (skipped), up to two adjectives (#R$7ED3; a third one is an error), and a noun, which ends the phrase ($7E9B stores it at $7C49). Adjectives enter at $7E93 and nouns at $7E9B. A phrase that ends without a noun (for example 'look through') is allowed and simply has no noun.",
 "The phrase is then stored in the frame by #R$7EF5: the first phrase at offset 4 and the second at offset 14. When ALL EXCEPT is in force ($B609 = 2), each extra noun phrase instead starts a new frame (#R$7F22), with bit 6 of its verb marked, so that 'take all except the sword and the key' produces one frame per exception."])
blk(0x7ED3,'c','Parser: store an adjective',["Stores the adjective token BC in the first empty adjective slot of the noun phrase buffer ($7C4B or $7C4D). If both are full, it is a syntax error (#R$7FEE)."])
blk(0x7EE6,'c','Parser: store a preposition',["Counts the prepositions in the current noun phrase ($7C44) and stores the token BC in the first empty preposition slot ($7C45 or $7C47). A third preposition is a syntax error (#R$7FEE)."])
blk(0x7EF5,'c','Parser: store a noun phrase in the frame',[
 "Copies the 10-byte noun phrase from $7C45 into the command frame: to offset 4 if bit 6 of E says the first phrase is still empty ($7F1A), otherwise to offset 14 if bit 7 says the second is empty ($7F02). The corresponding bit of E is cleared. If both phrases are already full, it is a syntax error (#R$7FEE)."])
blk(0x7F22,'c','Parser: move on to the next frame',["Finds the next frame (#R$7F6F) and makes it the current one (IY)."])
blk(0x7F29,'c','Parser: clear the ALL state',["Sets $B609 to 0: no ALL or ALL EXCEPT is in force."])
blk(0x7F2E,'c','Parser: clear the current frame',["Clears the 24 bytes of the frame at IY, and the two bytes of the verb of the frame after it (at IY-24), so that the next frame starts empty."])
blk(0x7F3D,'c','Parser: fetch the next token',[
 "Reads the next token from the token buffer (pointer at $B5CD), which it then advances by two. On return D holds the class (the top nibble of the first byte) and BC the word: B the top nibble of the offset and C the bottom byte. The previous class is saved at $B5CF (so that handlers can see what came before), and the position of the token is saved at $B5CB for error messages. A also holds the class."],
 regs=['Output:A Class','D Class','BC Word'])
blk(0x7F56,'c','Parser: step to the next frame',["Decrements B (a frame counter), finds the next frame (#R$7F6F) and swaps IX and IY, so that IY is the next frame and IX the current one."])
blk(0x7F5C,'c','Parser: step to the previous frame',["Decrements B, finds the previous frame (#R$7F69) and swaps IX and IY. The entry at $7F5D does not decrement B."])
blk(0x7F69,'c','Find the previous frame',["Returns IX = IY + 24, skipping over frames marked with bit 6 of byte 1 (frames that belong to a quotation). Continues into #R$7F6F."])
blk(0x7F6F,'c','Find the next frame',["Returns IX = IY - 24 (frames are stored downwards in memory), skipping over any frames whose byte 1 has bit 6 set. The entry at $7F73 is shared with #R$7F69, which adds 24 instead."])
blk(0x7F81,'c','Parser: give a frame the previous frame\'s verb',[
 "Copies the verb from the frame at IX into the frame at IY (keeping IY's flag bits). This is how the verb is shared when AND joins objects: 'take the key and the sword' produces two TAKE frames.",
 "If the new frame has a second noun phrase, and bit 7 of E is set, the second noun phrase and the particle of the previous frame are copied too ($7FC9), so that 'put the key and the sword in the chest' puts both in the chest."])
blk(0x7FDE,'c','Parser: store the verb',["Clears bit 1 of E (no more verbs allowed) and stores the token BC at offset 0 of the current frame. The entry at $7FE2 stores BC at offset L instead (used for the particle at offset 2)."],regs=['Input:BC Token','Output:E Updated state'])
blk(0x7FEE,'c','Parser: syntax error',[
 "Called when a word turns up where it is not allowed. Inside a quotation the word is simply skipped. Otherwise the parser's own return address is discarded and #R$7FF9 prints 'what?'."])
blk(0x7FF9,'c','Print "what?"',["Prints 'what?' (the message at $AC93) in the lower window, and returns with Z reset so that the command is abandoned."])
blk(0x8009,'c','Parser: special words',[
 "Looks the word up in the table at #R$8029 and jumps to the handler for it. The special words are ALL, EXCEPT, IT, ONE and the game commands PRINT, NOPRINT, LOAD, SAVE, QUIT, HELP, SCORE and PAUSE. A quotation mark, which also has class $90, has a word of 0 and matches the first entry (#R$80CD). A special word not in the table is ignored."])
blk(0x8029,'b','Special words',[
 "Thirteen word references (low byte first) followed by the thirteen addresses of their handlers (#R$8009)."],
 subs=[('W',0x8029,26,'Quote, ALL, EXCEPT, IT, ONE, PRINT, NOPRINT, LOAD, SAVE, QUIT, HELP, SCORE, PAUSE'),('W',0x8043,26,'Handlers')])
code(0x805D,0x806B,'PRINT and NOPRINT',[
 "PRINT ($805D) switches on copying of the story window to a ZX Printer (#R$7B15), by setting $B5E3 to 1, but only if a printer is attached: bit 6 of port $FB is 0 when one is. NOPRINT ($8067) sets $B5E3 to 0.",
 "The test for the printer has a curious slip: when no printer is attached, the JR NZ at $805F jumps to $8069, which is in the middle of the LD ($B5E3),A instruction. The bytes there are executed as EX (SP),HL and OR L before execution reaches #R$806B. In my tests the game carried on normally after PRINT with no printer, so the damage appears to be harmless in practice."])
bug('printjump','PRINT without a printer jumps into the middle of an instruction',
 "In #R$805D, if no ZX Printer is attached, a relative jump lands on $8069, the second byte of LD ($B5E3),A. The processor executes the bytes $E3 and $B5 as EX (SP),HL and OR L. In my emulator tests nothing visibly went wrong afterwards, but it is clearly not what was intended; the jump should have gone to #R$806B.")
blk(0x806B,'c','Special word finished: carry on parsing',["Restores the previous word class from $B5CF into D and goes back to the parser loop ($7C7E). Used by the game commands, which are not part of the command being parsed."])
code(0x8072,0x808A,'EXCEPT',["EXCEPT (or BUT) is only allowed straight after ALL ($B609=1). It sets $B609 to 2 and bit 7 of the current frame's verb, so that the command applies to everything except the objects that follow."])
blk(0x808A,'c','ALL',["Sets $B609 to 1 (ALL in force) unless ALL EXCEPT is already in force."])
blk(0x809A,'c','IT',[
 "Replaces IT with the object most recently mentioned: the noun and two adjectives saved at $B5D1 (by #R$8614 each time a command names a target) are copied into the noun phrase buffer, which is then stored in the frame (#R$80AF). So 'take the key. unlock the door with it.' works."])
blk(0x80AF,'c','Store the noun phrase in the frame (jump)',["Jumps to $7F02 (second noun phrase) if Z is set, otherwise to $7F1A (first noun phrase); see #R$7EF5."])
blk(0x80B5,'c','Opening quotation mark',[
 "Begins a quotation, as in SAY TO THORIN \"GO EAST\". The current word class and frame count are saved ($8007, $8008), and the parser is re-entered at $7C54 with the frame pointer moved to a fresh frame, so that the words inside the quotation are parsed as complete commands of their own."])
blk(0x80CD,'c','Quotation mark',[
 "A quotation mark (class $90, word 0) arrives here from #R$8009. If no quotation is open, it is an opening quote (#R$80B5). Otherwise it closes the quotation: $B60B is decreased, and the frames that were parsed inside it are moved to the orders buffer at #R$B628 so that the character spoken to can act on them later.",
 "The orders buffer has eight slots of 25 bytes. Each command is put in the first free slot: the slot's first byte is set to $FF (in use) and the 24-byte frame is copied after it. A frame that is itself a nested quotation is stored as an empty order. $B627 is set to the number of orders stored. The parser state saved at the opening quote is then restored."])
code(0x8149,0x8158,'QUIT',["Prints the score (#R$81AD), waits for a key, and restarts the game (#R$6C27)."])
blk(0x8158,'c','HELP',[
 "HELP gives a hint that depends on where Bilbo is. His room is looked up in the table at #R$8185; if it is there, that message is printed, otherwise the general one at $B358: 'you're doing fine.' The message goes to the lower window. HELP is ignored if a character is the actor (for example inside SAY TO)."])
blk(0x8185,'b','Help messages',[
 "Room number and message address pairs for #R$8158, terminated by $FF. The hints are:",
 "#LIST { Room 6: 'a trolls door needs a trolls key.' } { Room 9: 'elves are good at reading symbols.' } { Room 13: 'a window should be no obstacle to a thief with friends.' } { Room 66: 'boats can help. look carefully.' } { Room 31: 'wait around and time your exit carefully.' } { Room 32: 'timing is critical, remember barrels float.' } { Room 42: 'wait a while.' } { Room 46: 'take care to leave at the right time.' } { Room 41: 'a living dragon is deadly, look to bard.' } { Room 26: 'don't stay too long.' } { Room 5: 'wait for the new day dawning.' } LIST#"])
blk(0x81A7,'c','SCORE',["Prints the score (#R$81AD) and carries on parsing (#R$806B)."])
blk(0x81AD,'c','Print the score',[
 "Prints 'you have mastered xx.x% of this adventure.' The score is kept at $B5E8 in tenths of a percent (so 1000 would be 100.0%). The hundreds and tens are printed with #R$81E6 (a leading zero in the hundreds is suppressed), then a decimal point and the tenths digit."])
blk(0x81E6,'c','Divide by repeated subtraction',["Divides HL by DE by repeated subtraction, returning the ASCII digit of the quotient in A and the remainder in HL. Z is set if the digit is '0'."],regs=['Input:HL Number','DE Divisor','Output:A Digit ("0"-"9")','HL Remainder'])
code(0x81F2,0x8209,'PAUSE',["Turns the border green, waits for a key to be pressed and released (#R$8271), and turns the border white again. The game is frozen in the meantime: no timers run and no characters act."])
code(0x8209,0x8250,'LOAD',[
 "Loads a saved game from tape using the ROM routine LD-BYTES ($0556), in four headerless blocks: the 28 game variables (#R$B5CB, from $B5DC), the object table (#R$C00B), the timers and characters (#R$C973) and the room table (#R$B97A). These are exactly the areas that the game backs up at start-up (#R$6C00), and together they are the entire state of the game. Afterwards three bytes are copied from $B5DC back to $C8D1 (see #R$8284). If a block fails to load, #R$8250 reports a tape error and restarts the game."])
code(0x8250,0x826B,'Load a block, or restart on a tape error',["Calls LD-BYTES. If it fails, prints 'tape error - hit any key to restart program', waits for a key and restarts the game (#R$6C27), because a half-loaded game state could not be trusted."])
code(0x826B,0x8271,'Copy three bytes',["Copies three bytes from HL to DE (used to move the bytes at $C8D1 in or out of the saved variables)."])
code(0x8271,0x8284,'Wait for a key press and release',["Waits until no key is pressed, then until one is."])
code(0x8284,0x8312,'SAVE',[
 "Saves the game to tape. Three bytes at $C8D1 (part of the data after the room-entry handlers) are first copied over the start of the saved variables at $B5DC so that they are saved too. The player is asked to start the tape and press a key, and the four blocks listed under #R$8209 are saved with the ROM routine SA-BYTES ($04C2).",
 "Then, unusually for a 1982 game, it offers to VERIFY the save: 'rewind and prepare tape for verification - then hit any key', and reads the four blocks back with the ROM routine in verify mode (#R$8312)."])
code(0x8312,0x832E,'Verify a block',["Calls the ROM's LD-BYTES in verify mode. On failure it prints 'tape error - hit any key to continue' and abandons the verification; the game carries on."])
blk(0x832E,'b','Command execution work area',[
 "Used by #R$83A7 and the routines after it while a command is being matched to objects. The first 17 bytes are cleared by #R$839A for each command.",
 "#LIST { $832E, $832F: flags for the target and the instrument (bit 0: a noun was given; bit 1: a matching object has been found) } { $8330-$8332: counts of candidate objects and of those for which the action would work } { $8333-$8338 and $8339-$833E: the noun and adjectives given for the target and for the instrument } { $833F, $8341: where the search for the target and instrument has got to } { $8343: the ALL flag of the frame } { $8344: set when only one candidate is wanted } { $8345, $8346: frame offsets of the target and instrument phrases } { $8347, $8348: the candidate target and instrument } { $8349-$834E: the verb, particle and preposition used to find the action } { $834F: the action table entry } LIST#"],
 subs=[('B',0x832E,0x23,'')])
EXTRA_REGIONS[0x832E]=0x8351

A[0x8351]['desc']=[
 "Called by the main loop (#R$6D0A) after parsing. It works through the command frames built by the parser, one per command, starting at #R$B8B8.",
 "For each frame, #R$83A7 finds the action and the objects it applies to. If that fails, the frame is dropped. Otherwise the action is carried out for real: $B5EB is set to 1, #R$7122 reports it ('you take the sword.'), #R$946F performs it, and #R$9611 ends the turn, letting the characters act and the timers run. So every command the player types costs one turn, and a line with three commands costs three turns.",
 "A command with ALL is repeated ($837F) for each object it applies to, one turn each. When a frame is finished, the next frame (24 bytes lower) is taken, skipping frames that belong to quotations, until the frame count $B5F7 reaches 0.",
 "If the previous command was left unfinished ($B60A), it is picked up again at $8385 instead."]
blk(0x839A,'c','Clear the command execution work area',["Clears the 17 bytes at #R$832E and $B5F2."])
blk(0x83A7,'c','Find the action and objects for a command',[
 "The target ($B5D9) and instrument ($B5DA) are set to $FF (none) and the work area is cleared. #R$858F then finds the action table entry that matches the frame's verb, particle and preposition; if none does, the routine returns with Z set.",
 "The action number (1-59) is worked out from the entry's address and stored in $B5D8. The flags of the entry (#R$8569) say whether the action needs a target and an instrument (bits 3 and 2 of $B60D). If it needs neither, the routine is done. Otherwise #R$8405 searches for suitable objects, trying each candidate with a dry run. If the objects cannot be decided, #R$87AD deals with it (asking 'which key?', saying 'I do not see the key', and so on). With ALL, #R$8464 moves on to the next object."],
 regs=['Output:F Z set if the command could not be matched'])
blk(0x8405,'c','Search for a target and an instrument',[
 "Tries the objects that fit the noun phrases of the command, in two nested loops: for each candidate target (#R$86BC) it tries each candidate instrument (#R$8708). For every combination, a dry run of the action (#R$84DE, which runs the action with $B5EB clear) says whether it would work. The first combination that works is kept. Counts of the candidates are kept at $8330-$8332 so that #R$87AD can tell whether there were none, one or several.",
 "When only one candidate is allowed ($8344), the search stops after the first."],
 regs=['Output:F Z reset if no workable combination was found'])
blk(0x8464,'c','ALL: find the next object',[
 "For a command with ALL, looks through the frames that follow (the exceptions, marked with bit 6) and checks that the target found is not one of the objects excluded by EXCEPT. Returns with Z reset if it is excluded."])
blk(0x8492,'c','Start the search for targets',["Sets up the table (objects or rooms) in which the target will be searched for (#R$84BD), according to bits 2-3 of $B60E, and saves the starting position in $833F. Does nothing when repeating an ALL command."])
blk(0x84AB,'c','Start the search for instruments',["As #R$8492, for the instrument: the position is kept at $8341."])
blk(0x84BD,'c','Choose the object table to search',["Sets IX to the object index at #R$BF53 if the low two bits of A are 0, or to $BF50 (three bytes earlier, which makes the search start with a dummy entry) otherwise."])
blk(0x84C9,'c','Does the action need an instrument?',["Returns with Z reset if the action needs an instrument (bit 2 of $B60D) that has not yet been given. If bit 1 of $B60D is set, the instrument may be left out, and the routine returns with Z set."])
blk(0x84DE,'c','Try the action (dry run)',["Runs the action with #R$946F and returns with Z set if it would not work ($B5EC is 0). Called while $B5EB is 0, so nothing actually happens and nothing is printed."])
blk(0x84E6,'c','Would this action work? (for a character)',[
 "Used when a character is deciding what to do (#R$976C): works out, for the action in $B5D8 and the objects in $B5D9 and $B5DA, whether the action would succeed, without printing anything and without disturbing the player's command. The work area pointer at $833F is saved and restored. Returns with Z set if the action would not work."])
blk(0x8554,'c','Copy an object\'s or a room\'s words',["If B is not $FF, copies the six bytes of words (noun and two adjectives) of object B (or of room B, if A is non-zero) to DE."])
blk(0x8569,'c','Decode the flags of the action',[
 "Turns the flag nibbles of the action table entry (see #R$70EA) into separate variables: $B601 (bit 6 of $B60E: the action is allowed in the dark), $B5FF (bit 0 of $B60D: the objects need not be within reach), $B5EF (bit 7: the target is a room rather than an object) and $B5F0 (bit 6: the instrument is a room)."])
blk(0x858F,'c','Find the action for a command',[
 "Collects the verb of the current frame and up to two prepositions from its noun phrases into $8349-$834E, and then searches the action table (#R$AA47) for an entry with the same verb and prepositions (#R$71EA). If one is found, #R$8614 sorts out which noun phrase is the target and which the instrument, and the routine returns with Z reset.",
 "If none is found there are two cases. If the verb was right but the other words were wrong ($B5D0 set), 'I do not know the verb ...' is printed ($8895). If the verb has no actions at all (WAIT, JUMP, SING, SMILE and many others), the game prints 'you wait. time passes...' with the verb substituted ($AC97), and a turn goes by. This is how all the verbs that do nothing get their reply."])
blk(0x8614,'c','Assign the noun phrases to target and instrument',[
 "Decides which of the command's two noun phrases is the target and which the instrument, from the preposition the action expects and bit 5 of the action's flags. So 'hit thorin with the sword' and 'with the sword hit thorin' both work. The target's words are copied to $8333 and also to $B5D1 (for IT), and the instrument's to $8339. Bit 0 of $832E and $832F is set if the phrase actually has a noun."])
blk(0x869D,'c','Pick up a preposition from the frame',["Copies the word at offset E of the frame to (HL) and moves HL on, unless it is empty or B (the number of words wanted) has reached 0."])
blk(0x86BA,'c','Call the routine at IY',["JP (IY): used to call a search routine chosen at run time (#R$9D2E for objects, #R$9DE9 for rooms)."])
blk(0x86BC,'c','Find the next candidate target',["Searches for the next object (or room, if $B5EF is set) that fits the target's words, starting from where the last search left off ($833F). Only candidates for which the action would work are returned (#R$86ED). Returns A=$FF when there are no more."])
blk(0x86ED,'c','Find the next candidate target for which the action works',["Calls the search routine at IY with the target's words, and for each object found, puts it in $B5D9 and tries the action (#R$9436). Stops at the first one for which it would work."])
blk(0x8708,'c','Find the next candidate instrument',["As #R$86BC, for the instrument; the position is kept at $8341, and the candidate goes into $B5DA."])
blk(0x8745,'c','Find the next candidate instrument for which the action works',["As #R$86ED, for the instrument."])
blk(0x875C,'c','Prepare to reply to the player',["Sets $B5EB (really do it) and $B5F2 (print in the lower window), ready to print a reply."])
blk(0x8765,'c','Leave the command unfinished',["Saves the current frame at #R$B8B8 and stores A in $B60A, so that the next thing the player types is used to complete this command. Used after 'which key?' and '... what?'."])
blk(0x8774,'c','Ask "which ...?"',["When the noun given fits more than one object and the action would work with more than one of them, the game asks 'which key?' (message $ACC0, with the noun pushed as a parameter) and leaves the command unfinished (#R$8765), so the player can reply 'the small one' or 'curious'."])
blk(0x8781,'c','Print a reply and give up',["Prints the message at HL in the lower window (#R$875C, #R$72CA) and returns with A=0."])
blk(0x8789,'c','Decide about the instrument',["The instrument's counterpart of the target checks in #R$87AD: no noun given, several candidates, or none."])
blk(0x87AD,'c','Report why the objects could not be decided',[
 "Called when #R$8405 did not find exactly one workable combination. Depending on the counts:",
 "#LIST { Exactly one candidate target: the instrument is checked (#R$8789). } { No noun was given (for example 'unlock door' when an instrument is needed): if there is exactly one object that the action could apply to, it is used anyway, and the game says which one it chose, e.g. 'with the key' (#R$87EF). } { No candidate at all: 'I do not see the key.' } { Several candidates: 'which key?' (#R$8774). } { Candidates exist but the action would not work with any of them: the action is carried out anyway ($87E6), so that the action routine prints its own reason for failing ('you cannot open the door'). } LIST#"])
