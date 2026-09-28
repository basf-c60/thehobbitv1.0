# Batch 6: characters, world helpers and event routines (9500-A9FF)
from overlay import A, blk
from overlay3 import fact, bug
from overlay4 import EXTRA_REGIONS

blk(0x953F,'c','Let a character react to what was done to it',["If the object at IX is a living character (bit 6 of its flags set, bit 3 clear), #R$99FB is called with the action number in B, which may switch the character to a new behaviour (for example, to fight back when attacked)."],regs=['Input:IX Object record','B Action number'])
blk(0x954D,'c','Is it too dark for Bilbo to see?',[
 "Returns with the carry flag set (and HL pointing at the message 'it is dark.') if the player is acting and cannot see. Characters are never affected: they can always see.",
 "Bilbo can see if he is inside something (#R$9DC8) or if his room is lit (bit 7 of the first byte of its record). Otherwise he can only see if the short strong sword (object 14, record at #R$C00B + $1E9 = $C1F4) is with him (#R$9D86) and its flags have bit 2 set, bit 3 (broken) clear and bit 4 ('on') set. In other words, the sword is the game's only lamp: it glows, as Sting does in the book. The sword starts with these bits set, so carrying it lights up every dark place."],
 regs=['Output:F Carry set if it is too dark','HL "it is dark."'])
fact('sting','The sword glows in the dark',
 "The darkness check (#R$954D) looks at one object only: the short strong sword. If Bilbo has it and it is 'on' and not broken, dark places are lit. In the emulator, walking east from room 41 into the smooth straight passage gives 'it is dark.' without the sword and a full description with it. In the book, Bilbo's sword Sting glows blue when orcs are near.")
blk(0x958E,'c','Describe a room',[
 "Prints the full description of room A: 'you are' followed by the room's preposition (OUTSIDE, INSIDE, IN, ON or AT, chosen by bits 1-3 of the room's first byte from #R$B970, and written into the message at $AEEE) and then #R$95B9 does the rest."],regs=['Input:A Room number'])
blk(0x95B9,'c','Describe a room (continued)',[
 "Prints the room's name from its word list, or its own description script if bytes 8-9 of the room record are non-zero (#R$95E4). Then the room's picture is drawn if it has one (#R$8965); if it did, the game waits for a key (#R$95F8) so the player can look at it. Then the doors (#R$9FF8), the visible exits (#R$A068) and the objects and characters present (#R$9EDD) are listed."])
blk(0x95E4,'c','Print a room\'s name or description',["If Z is reset, HL is a description script and it is printed. Otherwise the three name words of the room (from offset 2 of the record at IX) are printed with #R$9E1F."])
blk(0x95F8,'c','Wait for a key after a picture',["Waits until a key is pressed, then resets the border to white (the picture may have changed it)."])
blk(0x9606,'c','Describe a room briefly',["Prints the name of room A (#R$95E7) and a new line, and then carries on with the doors, exits and contents as in #R$95B9 ($95DD), without the picture."])
blk(0x9686,'c','Is the object within the player\'s reach?',[
 "Checks that the player is not trying to use something another character is carrying. If the actor is Bilbo and object A is held by someone who is a living character (bit 6 of the holder's flags), and Bilbo is not in the dark, the game says, for example, 'gandalf is carrying the curious map.' and returns with Z reset: the action is not allowed. Characters are not subject to this check."],regs=['Input:A Object','Output:F Z reset if the object is out of reach'])
blk(0x96DD,'c','Kill a character',[
 "If A is 0, it is Bilbo who has died, and #R$903C ends the game. Otherwise the character's dead flag (bit 3) is set, everything it carries is dropped where it stands (#R$9CA8), it is removed from the character table (#R$C9BA) so it no longer acts, its adjectives are replaced by DEAD (#R$A0BC), and any orders waiting for it are cancelled (#R$894D)."],regs=['Input:A Character'])
blk(0x970B,'c','Choose the random features of a new game',[
 "Called at the start of every game. It makes Bilbo the actor and then makes two random choices.",
 "The hidden route: one of five exits listed in the table at #R$C6F7 is chosen (a random number 1-5 from #R$9BF4) and blanked out in its room record, so that way is closed. The address of the chosen entry is written into the instruction at $A6C3, where Elrond will need it (#R$A6B8). The candidates are the exits from Beorn's house to the great river, from the forest gate to the gloomy bewitched place, from the treeless opening to the goblins' outside gate, from the long lake to lake town, and from the misty mountain to the narrow place. Because of the way #R$9BF4 works, the first and last are chosen half as often as the others.",
 "Gollum's riddle: one of the three entries at #R$C6EB is chosen and its address stored at $B5DF (see #R$A7C6)."])
fact('route','One route is closed at random in every game',
 "At the start of each game (#R$970B) one of five exits is removed at random. The way through only opens when Elrond reads the curious map (#R$A6B8), which is also when he tells you where to go: 'go north from beorns house to get to the great river', for example. This is why the map matters, and why the route through Wilderland changes from game to game.")
blk(0x9752,'c','Print a message and end the sentence',["Prints the message at HL, then a full stop and a new line."])
blk(0x975D,'c','Is the action really happening?',["Returns to the caller only if both $B5EB (really do it) and $B5EC (it would work) are set. Otherwise it discards the caller's return address, so the caller returns at once."])

A[0x976C]['desc']=[
 "This is The Hobbit's famous 'independent characters' system. Every character in the table at #R$C9BA gets a turn after the player.",
 "Each entry of that table is 7 bytes: the character's object number (0 if the character is dead or gone), a count used by #R$99B4, the address of the character's current place in its behaviour program, the address of its reaction table, and a 'stubbornness' value used by #R$8F9E.",
 "For each living character, the character becomes the current actor ($B5DB, $B5FC) and the room it starts the turn in is noted ($B5E7). Output is switched on only if Bilbo can see the character (#R$9D77), so the player sees only what happens in front of him. If Bilbo is in the dark, the first character to do anything in his room produces 'you hear a noise.' instead ($AF19).",
 "A character that is inside something (held by an object rather than standing in a room) tries to get out first (#R$9A71).",
 "Then the character's behaviour program is run. Each instruction starts with a byte whose low nibble is its type and whose high bits are flags: bit 4 'jump afterwards to the address that follows', bit 5 'do this only once' (the instruction is cleared to 0 after use), bit 6 'do not take orders at this point'. The types are:",
 "#LIST { 0-3: do an action. The next three bytes are the action, the target and the instrument (#R$9883). If bit 0 of the flags is set, the next two bytes are instead the address of a routine that does something special - most of the routines in the range $A406-$A91B are such character routines. } { 4: do an action without objects, such as moving in a direction (#R$98CF). An action of $FF just jumps. } { $0C: change the character's reaction (#R$99FB). } { $0E: jump to the address that follows. } { $0F: choose at random one of the behaviours in the reaction table (#R$99B4). } { anything else: go back to the first behaviour in the reaction table. } LIST#",
 "Before the program, if the player has given the character an order (#R$88FD) and the current instruction allows it (bit 6 clear), the order is obeyed instead (#R$8907, $9929).",
 "A character stops after 6 instructions in one turn ($9769). At the end the player becomes the actor again, with output switched on."]
blk(0x9873,'c','Advance a character\'s program pointer',["Moves the program pointer past the current instruction (HL+DE), skipping two more bytes if bit 4 of the instruction says a jump address follows, and stores it in the character's table entry."])
blk(0x9883,'c','Character instruction: do an action',[
 "Carries out an action instruction from a character's behaviour program. Normally the three bytes after the instruction byte give the action, the target and the instruction ($B5D8-$B5DA) and #R$9921 tries it. If bit 0 of the instruction byte is set, the next two bytes are the address of a special routine, which is called first as a dry run and, if it says it would work, for real.",
 "If the action worked, and the instruction has a jump address (bit 4), the program jumps there. If bit 5 is set the instruction is erased so it will not be done again."])
blk(0x98CF,'c','Character instruction: action without objects',[
 "The byte after the instruction is an action with no target or instrument (typically a movement direction, so a character's program can be a route), tried with #R$9921. An action of $FF means 'jump to the address that follows' if bit 4 is set. The entry at $9905 counts the instructions done this turn and follows jump addresses."])
blk(0x9921,'c','A character tries an action',[
 "Checks with #R$84E6 whether the action would work; returns with Z set if not. Otherwise the action is reported (#R$7122) and performed (#R$946F).",
 "Movement needs special care because Bilbo may see the character arrive or leave. If the character is going somewhere Bilbo can see, the report is printed as if by an unseen actor. After the action, #R$9A28 prints 'thorin enters.' if the character has just come into Bilbo's room, and 'X appears.' if the target of the action has appeared there."],
 regs=['Output:F Z set if the action would not work'])
blk(0x99B4,'c','Choose a behaviour at random',[
 "Picks a random entry (#R$9BF4) from the character's reaction table (the address at offset 4 of its table entry) and makes it the character's current behaviour program. The range is the smaller of byte 1 of the instruction and byte 1 of the character's table entry. The entry at $99C3 selects entry E instead."])
blk(0x99E0,'c','Find a character\'s table entry',["Searches the character table #R$C9BA for character A and returns IY pointing at its entry (or at the $FF end marker, with A=$FF, if it is not there)."],regs=['Input:A Character','Output:IY Table entry'])
blk(0x99FB,'c','Change a character\'s behaviour',[
 "Looks for action B in the reaction table of character A (a list of 3-byte entries: action and program address). If found, the character's current program is switched to that address. This is how characters respond to what happens to them: for example the reaction to ATTACK is to fight back."],regs=['Input:A Character','B Action'])
blk(0x9A28,'c','Report that a character has arrived',[
 "Prints the message at DE (for example 'thorin enters.' or 'X appears.') with the object's name, if object A has just arrived in the room where Bilbo is ($B5E6), was not there before ((HL)), and Bilbo is not in the dark."])
blk(0x9A5D,'c','Prepare for the characters\' turn',["Notes the room Bilbo is in ($B5E6, #R$9ECB) and whether it is dark there ($976A). It is also the default handler for action 0 in #R$C61F, which makes it a harmless 'do nothing special' routine."])
blk(0x9A71,'c','A character tries to get out of something',[
 "Called when a character is being held by an object (for example shut in a barrel or a cell). If the holder is dead or alive (i.e. another character is carrying this one), nothing special happens. If it is a closed object, the character does nothing this turn. If it is open, the character tries action 55, CLIMB OUT OF."])
blk(0x9A9F,'c','Is the action sensible?',["Returns with Z set if the action cannot make sense: the target is the actor, or the instrument is the target, or the instrument is the actor. A missing target ($FF) is always fine."],regs=['Output:F Z set if the objects are not sensible'])
blk(0x9ADB,'c','Jump to HL',["The JP (HL) used by #R$9AC7."])
blk(0x9ADC,'c','Find an object\'s handler for an action',[
 "Searches the list of action handlers at the end of the object record at IX (after the header, the four word slots and its location bytes; see #R$C00B) for action A, using #R$9D12. As with #R$9D12, the found/not-found sense is NZ/carry set = found, Z set = not found - the opposite of what the names Z and 'zero' suggest. Returns IX at the matching entry (or the list's $FF terminator)."],regs=['Input:A Action','IX Object record','Output:F NZ or carry set if the object has its own handler for the action; Z set if not'])
blk(0x9AEE,'c','Get the next entry of a 3-byte table',["Moves IX on to the next 3-byte entry of a table such as the object index (#R$BF53), returning the key in A and the address it holds in IY. Returns with Z set at the end of the table ($FF). The alternate registers are used so that BC, DE and HL are preserved."])
blk(0x9B04,'c','Get the next object',["As #R$9AEE, but preserving B."])
blk(0x9B38,'c','Move an object and everything it holds',[
 "Moves everything held by object A (and everything they hold, recursively, #R$9B6C) to room B. If Bilbo was among the things moved (for example he was inside the barrel when it floated away, or was carried off), the room he has arrived in is entered and described (the entry at $8DC1 in #R$8D19)."],regs=['Input:A Object','B Room'])
blk(0x9B6C,'c','Move the contents of an object',["Sets the location of every object held by object A to room B, and does the same for their contents. Clears $9B37 if Bilbo (object 0) is one of them."])
blk(0x9B96,'c','How much room is left in a room?',["Returns in A the free space in room A: byte 1 of the room record is the room's capacity, from which the size (byte 2) of every ordinary object there is subtracted. Returns 0 if the room is overfull."],regs=['Input:A Room','Output:A Free space'])
blk(0x9BCD,'c','Is the actor holding the target?',["Returns with carry set if the target ($B5D9) is held by the actor, directly or inside something the actor holds. The entry at $9BD0 does the same for object A. An object of $FF counts as held."],regs=['Output:F Carry set if held'])
blk(0x9BDF,'c','Is object A inside the holder at (HL)?',["Follows the chain of holders of object A upwards; returns with carry set if (HL) is one of them."])
blk(0x9BF4,'c','Random number from 0 to A',["Returns the absolute value of a random number from -A to A (#R$9BFD). Because of the way #R$9BFD works, 0 and A come up half as often as the numbers between."],regs=['Input:A Range','Output:A Random number'])
blk(0x9C3D,'c','Total size of an object\'s contents',["As #R$9C42, but adding up the objects' sizes (byte 2) instead of their weights."])
blk(0x9C42,'c','Total weight of an object\'s contents',["Returns in A the total weight (byte 3) of everything held by object A, including the contents of containers, found by #R$9C55. The result is $FF if it overflows."],regs=['Input:A Object','Output:A Weight'])
blk(0x9C55,'c','Add up the contents of an object',["Recursive worker for #R$9C42 and #R$9C3D: for each object held by object A, adds its weight (or size, if B=1) to C, and for weights also the weight of its contents. The overflow test uses JP PE."])
blk(0x9C8C,'c','Get the actor\'s room record',["Returns IX pointing at the record of the room the actor is in. AF is preserved."])
blk(0x9CA8,'c','Drop everything an object holds',[
 "Makes everything held by object A the property of A's own holder (so things a dead character carried stay where it was). Things that evaporate (bit 1 of their flags) vanish instead, with 'X evaporates.'"])
blk(0x9CEC,'c','Count the visible things an object holds',["Returns in A the number of visible objects (bit 7 of their flags set) held directly by object A."],regs=['Input:A Object','Output:A Count'])
blk(0x9D2E,'c','Find the next object that fits some words',[
 "Continues a search of the object index (from IX) for an object whose words match the noun and adjectives at HL (#R$71EA). The object must also match the filter in $B600: 0 for things that are not characters, 1 for characters, 2 for anything. Unless $B5FF says reach does not matter, the object must also be in the same place as the actor (#R$9D86). Returns the object in A, or $FF when there are no more."])
blk(0x9D77,'c','Can the object at IY be seen from IX?',["Swaps IX and IY around a call to #R$9D92."])
blk(0x9D86,'c','Is the object near the actor?',["Calls #R$9D92 with IX = the actor's record: returns with Z reset if the object at IY is in the same place as the actor."])
blk(0x9D92,'c','Are two objects in the same place?',[
 "Returns with Z reset if the object at IY is visible (bit 7 of its flags) and is in the same place as the object at IX. Each object's outermost open container is found (#R$9DC8); if they are both inside the same container, or both loose, and the IY object's locations include IX's room, they are together."])
blk(0x9DC8,'c','Find the outermost holder',["Follows the chain of holders of the object at IX upwards while the holders are open (bit 5) or dead (bit 3): through an open box, or a dead character, you can see what is inside. Returns $FF if the object is loose in a room."])
blk(0x9DDE,'c','Get the actor\'s room\'s exits',["Returns IX pointing seven bytes into the actor's room record, so that #R$9AEE, which adds 3, arrives at the first exit."])
blk(0x9DE9,'c','Find the next room that fits some words',["Searches the exits of the actor's room for one whose destination room has the words at HL, so that rooms can be named as targets ('go into the tunnel'). Returns the room number in A, or $FF."])
blk(0x9E10,'c','Print an object\'s name',["Prints the words of the object whose record is at IY (#R$9E1F on its word slots)."])
blk(0x9E1F,'c','Print a noun with its adjectives',[
 "IY points to a word list: noun, then up to two adjectives. The article is printed first (#R$7436, unless $B5F4 is set), then the adjectives, and then the noun (with an article if $B5F4 is set). So 'curious map' comes out as 'a curious map'."])
blk(0x9E51,'c','Find a usable exit in a direction',["Searches the exits of the actor's room for one in direction A that has a destination. Returns the direction in A, or $FF (Z set) if there is none."])
blk(0x9E71,'c','Find the exit through a given door',["Searches the actor's room for an exit whose door (byte 1) is object A. This routine and #R$9E76 are one routine: they write 1 or 2 into the offset of the LD A,(IX+n) instruction at $9E89 to choose which byte of each exit is compared."])
blk(0x9E76,'c','Find the exit that leads to a room',["Searches the actor's room for an exit whose destination (byte 2) is room A; see #R$9E71."])
blk(0x9EBF,'c','Report failure',["During a dry run, sets $B5EC to 0 (the action would not work). When the action is really being done, reports it instead (#R$7122), so the player sees 'you cannot ...'."])
blk(0x9ECB,'c','Get an object\'s room',["Returns the room of object A (its first location byte), or $FF if it is a door or other multi-place object, or if A is $FF."],regs=['Input:A Object','Output:A Room'])
blk(0x9EDD,'c','List what can be seen in the room',["Prints 'you see :' and the objects and characters lying loose in the actor's room (#R$9EF8), or '      nothing'."])
blk(0x9EF8,'c','List the objects held by A in room B',["Lists the objects (#R$9F10) and prints '      nothing' if there were none."])
blk(0x9F10,'c','List objects, with their contents',[
 "Prints each visible object held by A (A=$FF for loose objects) that is in room B, one per line, each followed by a full stop. After each one, its contents are listed by a recursive call, indented two more characters (D, stored at $7692 for #R$7694), with a heading from #R$9F89 such as 'gandalf is carrying' or 'in the chest there is'. The actor's own possessions are not listed when looking round the room. C counts the objects printed."])
blk(0x9F89,'c','Print the heading for a list of contents',[
 "For object A: if it is closed and not dead (bits 3 and 5 of the flags clear), or holds nothing visible, a new line is printed and the routine returns with carry set. Otherwise, for a character, 'X is carrying'; for anything else a heading with IN, ON, BEHIND or UNDER (chosen by bits 4-5 of byte 4 of the object's record, via the message at $AEBD) and 'there is' or 'there are'."])
blk(0x9FDE,'c','Get the start of a room\'s exits',["Returns IX pointing seven bytes into room A's record and BC=3, ready for stepping through its exits."])
blk(0x9FEA,'c','Get the word for a direction',["Returns in DE the word for direction A, from the table at $A13E (NORTH, SOUTH, EAST, WEST, NORTHEAST ... UP, DOWN). The entry at $9FED looks up another table at HL."],regs=['Input:A Direction','Output:DE Word'])
blk(0x9FF8,'c','Describe the doors of a room',["For each exit of room A that has a visible door, prints 'to the east there is the round green door' (or 'above'/'below' for up and down)."])
blk(0xA054,'c','Find the next visible exit',["Steps IX to the next exit that has a direction and no door. Returns with Z set at the end of the exits."])
blk(0xA068,'c','List the visible exits',["Prints 'visible exits are :' followed by the direction of every exit that has no door (#R$A054), or nothing at all if there are none."])
blk(0xA094,'c','"The X is Y" (instrument)',["As #R$A09C, for the object at IY."])
blk(0xA09C,'c','"The X is Y"',[
 "Explains why an action failed by describing the state of the object at IX: 'the door is locked.', 'the chest is closed.', 'the bottle is empty.' The low bits of A choose the flag bit that was wrong, and bit 7 whether it was set or clear; the word comes from the tables at $A154 (UNLOCKED, EMPTY, OFF, CLOSED, DEAD) and $A164 (LOCKED, FULL, BROKEN, ON, OPEN, ALIVE)."],regs=['Input:A State','IX Object record'])
blk(0xA0BC,'c','Mark an object as dead or broken',["Changes the adjectives of object A: the second adjective is removed and the first becomes DEAD for a character (bit 6 of its flags) or BROKEN for anything else. So after a fight, 'thorin' becomes 'the dead thorin'."])
blk(0xA100,'c','Should the instrument\'s handlers be used?',["Returns with Z set if the current action is one of the five listed at $A13B: DROP IN, PUT IN, PUT ON, TAKE OUT OF and THROW THROUGH. For these it is the instrument (the container, or the window) that knows what to do, so #R$946F uses its handlers."])
blk(0xA113,'c','A character speaks',["Prints '<actor> says \"<message at HL>\".'. Used by the character routines for Thorin's 'hurry up', Gollum's riddles and so on."],regs=['Input:HL Message'])
blk(0xA129,'c','Is the target locked or open?',["Tests the target's flags: returns Z reset and A=$80 if it is locked; otherwise tests bit 5 and returns A=$85, so Z reset means it is open. The codes in A are for #R$A09C. The entry at $A134 does only the second test."])
blk(0xA264,'c','Handler for the red door: LOCK and UNLOCK',["The red door's LOCK and UNLOCK handler: only object 15 fits it (the entry at #R$A26A with B=15)."])
blk(0xA26A,'c','Does this key fit?',[
 "If the instrument is key B, the door is locked or unlocked (#R$93CD, #R$93ED). If it is one of the other keys (objects 2, 4 and 15), 'the key does not fit this lock.' Anything else: 'I cannot do that.'"],regs=['Input:B The key that fits'])
blk(0xA298,'c','Handler for the crack: OPEN',["The small insignificant crack can only be opened from room 15; there it opens like a door (#R$9078)."])
blk(0xA316,'c','CAPTURE',[
 "One character captures another. The target must be alive, and not on the same side as the actor (bits 4-6 of byte 4 of their records must have nothing in common, so goblins do not capture goblins). The captive is taken to a dungeon: room 31 if the captor is the wood elf or the butler (objects 64 and 66), room 13 otherwise. If the captive is Bilbo, the new room is described."])
fact('capture','Who catches you decides where you wake up',
 "When a character captures Bilbo (#R$A316), he is taken to a dungeon. The wood elf and the butler take him to room 31 in the Elvenking's halls; anyone else (the goblins) take him to room 13 in the goblins' dungeon.")
blk(0xA36A,'c','A dead goblin comes back',[
 "Handler attached to each of the six goblins (objects 61, 69, 73, 74, 75 and 76). When a goblin that is dead (bit 3 of its flags) is dealt with, it is revived: the dead flag is cleared, the goblin is moved to a room given by its entry in the table at $A3C3, a variable is set, and it gets a new adjective from the same table. The game prints 'the goblin falls down a hole and vanishes.' So the goblins can never be wiped out."])
fact('goblins','Dead goblins do not stay dead',
 "The six goblins share a handler (#R$A36A) that brings a dead goblin back to life somewhere else with a new adjective, after it 'falls down a hole and vanishes'. The game's supply of goblins is effectively endless.")
blk(0xA406,'c','Character routine: react to being given something',["Says, at random, either 'thank you' or 'what do you expect me to do with this?'"])
blk(0xA41C,'c','Character routine: "what\'s this?"',["Says 'what's this?'"])
blk(0xA425,'c','Character routine: small talk',["Says one of 'you are doing a great job', 'hurry up' or 'hello', chosen at random."])
blk(0xA44C,'c','Character routine: greet Bilbo',["If the character is in the same room as Bilbo, says 'hello'."])
blk(0xA4C3,'c','Is the object open?',["Tests bit 5 of the flags of the object at IX (Z reset if open) and returns A=5, the state code for #R$A09C."])
blk(0xA4CA,'c','Character routine: the warg',["If the warg (whose location is at $C341) is in Bilbo's room: 'the vicious warg runs around you and howls.'"])
blk(0xA4DB,'c','Handler for the trap door: the barrel escape',["Chained after the trap door's own THROW THROUGH handler (action 44, #R$9404), not after OPEN as I first assumed - it is throwing the barrel through the door, not merely opening the door, that starts the escape. If the object just thrown through is the barrel (object 19) and it has landed in room 33 (the forest river below the cellar), timer 0 (#R$C973) is set to 2. Two turns later #R$A4F4 floats the barrel away."])
blk(0xA4F4,'c','Timer 0: the barrel floats down the river',[
 "The expiry routine of timer 0. The barrel is moved, with everything in it, to room 34 on the long lake (#R$9B38); if Bilbo was inside he reads 'you are thrown onto the bank of the long lake.' The barrel is emptied and marked as closed and full, the trap door's location is reset, and the wine (object 20) is put back in the barrel in room 32 ready for next time. This is the book's escape from the Elvenking's halls in barrels."])
blk(0xA539,'c','Character routine: "where\'s the thief?"',["If the character is in Bilbo's room but Bilbo cannot be seen (his visibility bit is clear), says 'where's the thief?'."])
blk(0xA550,'c','Character routine: Thorin',[
 "Thorin's idle behaviour. A random number from 0 to 8 (#R$9BF4) decides: 5 or more, nothing; 3 or 4, 'thorin waits.'; 0, 'thorin sits down and starts singing about gold.'; 1 or 2, he says 'hurry up'.",
 "A fourth line, 'get us out of this one, thief!', is set up at $A563 but can never be printed: the JP Z that would print it tests the flags from CP 3, and Z can only be set there if A was 3, which the JP NC before it has already taken care of."])
bug('thorinline','Thorin never says "get us out of this one, thief!"',
 "In #R$A550 the message 'get us out of this one, thief!' ($AFC7) is guarded by a JP Z that follows a JP NC on the same comparison (CP 3). A value of 3 has already been sent elsewhere by the JP NC, so the JP Z is never taken and the line is never said. Presumably a different comparison was intended.")
fact('singing','Why Thorin sits down and sings about gold',
 "Thorin's famous habit comes from #R$A550: each time his behaviour program runs this routine there is a 1 in 9 chance (a random number of exactly 0) that he 'sits down and starts singing about gold'. The rest of the time he waits, says 'hurry up', or does nothing.")
blk(0xA577,'c','Handler for the trap door: OPEN and CLOSE',["The trap door can only be opened or closed from room 32; elsewhere 'you cannot reach the trap door'."])
blk(0xA655,'c','Handler for the window: OPEN and CLOSE',["Bilbo cannot reach the window if he is not being held up (byte 1 of his record is $FF): 'you cannot reach the window'. Characters can open and close it normally."])
blk(0xA6B8,'c','Handler for the curious map: Elrond reads it',[
 "When anyone other than Elrond (object 65) examines the curious map, it is an ordinary EXAMINE (#R$9344). When Elrond does (because the player gave it to him and asked him to read it), the hidden route chosen at the start of the game (#R$970B) is revealed: the three bytes of the exit that were blanked out are restored from the table at #R$C6F7 (the address of the entry was written into the LD IY instruction at $A6C3), and Elrond says 'go <direction> from <room> to get to <room>'. $B5E2 records that it has been done."])
blk(0xA7C6,'c','Character routine: Gollum asks his riddle',[
 "If Gollum (whose location is at $C3B0) is in Bilbo's room and Bilbo is visible, he asks the riddle chosen at the start of the game (#R$970B, #R$C6EB), and $B5EA is set to show he is waiting for an answer."])
blk(0xA7EA,'c','Character routine: Gollum waits for the answer',[
 "Next time, Gollum looks for an order given to him by the player (#R$8907): the answer must be said to him, as in SAY TO GOLLUM \"NIGHT\". The words of the order are searched for the answer word stored in the riddle's entry (the CPIR loop). If the answer is there, all is well. If not, or if the player said nothing: 'someone strangles you from behind.', and Bilbo is dead (#R$903C)."])
fact('riddles','Gollum\'s riddles',
 "Gollum asks one of two riddles, chosen at the start of the game (#R$970B). One is the 'dark' riddle from the book ('it cannot be seen, cannot be felt, cannot be heard, cannot be smelt...'), for which the game wants the answer NIGHT. The other is not from The Hobbit at all: it is the riddle of the Sphinx ('which is the animal that has four feet in the morning, two at midday and three in the evening?'), answer MAN. The table at #R$C6EB has three slots, but the first and third are the same, so the dark riddle comes up twice as often. A wrong answer (or none) gets 'someone strangles you from behind.'")
blk(0xA81A,'c','Character routine: Gollum mutters',[
 "If Gollum is in Bilbo's room: usually, if Gollum still has the golden ring (object 16), 'my birthday present, how did we lose it. my precious'; otherwise 'what has it got in its pocketses?'. The test at $A82A only rarely (a random 8) says the pocketses line regardless."])
blk(0xA842,'c','Character routine: a character eats Bilbo',["If the character is in Bilbo's room, it 'eats' him: the EAT action is reported with Bilbo as the target (#R$9EBF), the food code is run (#R$921F) and Bilbo dies (#R$903C)."])
blk(0xA865,'c','Character routine: dawn in the trolls\' clearing',[
 "The trolls turn to stone at dawn. Both trolls (objects 71 and 72) are killed (#R$96DD) and made invisible, and whatever they carried - including the large key - is left behind (#R$9CA8). The trolls' clearing (room 5) gets a new description script, 'in a clearing with two stone trolls', and the game announces 'day dawns.'",
 "The first two bytes of the room 5 picture (the border and paper colours, see #R$8BE9) are set to 5 and $28: cyan. At the start of a game (#R$6C27) they are set to 0, so the clearing is drawn in black until dawn, and in daylight colours afterwards."])
fact('dawn','The trolls\' picture changes at dawn',
 "The picture of the trolls' clearing is drawn at night, in black, until the trolls are turned to stone (#R$A865). Then its first two bytes - the border and background colours - are changed to cyan, and from then on the same line drawing appears in daylight. The start-up code resets them to black for every new game.")
blk(0xA8B1,'c','Character routine: the trolls talk',["In the trolls' clearing, the hideous troll (object 71) says 'blimey, look at this! can yer cook 'em?' and the other troll 'yer can try, but he wouldn't make above a mouthful'."])
blk(0xA8CA,'c','Has the game been won?',[
 "Called at the end of every turn (from #R$9611). If the valuable treasure (object 35) is in the wooden chest (object 37, back at Bilbo's home), the game is won: 'a cheering crowd of dwarves, hobbits and elves appear. led by gandalf they carry you off into the sunset, proclaiming you hero of heroes and master adventurer!!!' The score is then printed and the game ends ($9049)."])
fact('winning','How to win',
 "The game is won (#R$A8CA) when the valuable treasure is in the wooden chest - that is, when Bilbo brings the dragon's treasure home and puts it away. Nothing else is required; the check is made at the end of every turn.")
blk(0xA8D9,'c','Character routine: Elrond gives Bilbo lunch',["If Elrond is in Bilbo's room and object 38 (lunch) has not yet been handed over, it is placed with Elrond and he gives it to Bilbo (#R$9308)."])
blk(0xA91B,'c','Handler for the barrel: JUMP ONTO / CLIMB INTO',[
 "An actor can get into the barrel only from a room with an exit leading to where the barrel is, and only if that exit goes down (direction 10). Otherwise 'you cannot jump onto the barrel from here.' The actor then becomes held by the barrel (and so moves with it, #R$9B38)."])
blk(0xA9ED,'c','Handler for the wine: Bilbo gets drunk',["Attached to the wine's DRINK handler. If the drinker is Bilbo, the flag at $B5F1 is set and timer 7 started, so that for five turns every S he sees is followed by an H (#R$7580)."])
blk(0xC693,'c','Room-entry handler: room 22',["When Bilbo enters room 22, the butler (object 66, whose flags are at $C326) is brought into play, unless he is already dead: his object number $42 is written into the empty slot of the character table at $C9D6, so that from now on he acts on his own (#R$976C), and he is made visible (bit 7 of his flags)."])

# data blocks
blk(0xC6EB,'b','Gollum\'s riddles',["Three 4-byte entries (one chosen at random by #R$970B): the word that answers the riddle, and the address of the riddle. The first and third entries are identical (NIGHT, the 'dark' riddle); the second is MAN, the riddle of the Sphinx."],
 subs=[('B',0xC6EB,4,'NIGHT'),('B',0xC6EF,4,'MAN'),('B',0xC6F3,4,'NIGHT')])
blk(0xC6F7,'b','Hidden routes',[
 "Six bytes per entry, of which #R$970B chooses entries 1-5 at random (entry 0, at $C6F7, is never used): the room, the address of an exit in that room's record, and the three bytes of the exit (direction, door, destination), which are blanked out at the start of the game and restored when Elrond reads the map (#R$A6B8). Terminated by $FF."],
 subs=[('B',0xC6F7,6,''),('B',0xC6FD,6,"Beorn's house: north to the great river"),('B',0xC703,6,'Forest gate: east to the gloomy bewitched place'),('B',0xC709,6,'Treeless opening: west to the goblins\' outside gate'),('B',0xC70F,6,'Long lake: east to lake town'),('B',0xC715,6,'Misty mountain: east to the narrow place'),('B',0xC71B,1,'End marker')])
blk(0xC71C,'b','Character behaviour programs and reaction tables',[
 "The programs run by #R$976C for each character, and the reaction tables used by #R$99FB and #R$99B4, addressed from the character table at #R$C9BA. See #R$976C for the instruction format. For example, Thorin's program starts at $C7DB and his reaction table at $C7D1; the trolls share $C92A/$C923, and the goblins share programs at $C731 and $C784."])
EXTRA_REGIONS.update({0xC6EB:0xC6F7,0xC6F7:0xC71C,0xC71C:0xC973})
A[0xC9BA]['desc']=["The characters who act on their own (#R$976C), 7 bytes each, terminated by $FF: object number (0 once the character is dead), a count, the address of the character's current position in its behaviour program, the address of its reaction table (#R$C71C), and a stubbornness value (#R$8F9E).",
 "#LIST { $3E Gandalf (stubbornness 5) } { $3F Thorin (6) } { $40 the wood elf } { $43 the warg } { a slot at $C9D6 that becomes $42, the butler, when Bilbo enters Beorn's house (#R$C693) } { $41 Elrond (5) } { $44 Gollum } { two empty slots } { $47 and $48 the trolls } { $3D, $45, $4B, $49, $4A, $4C the goblins } LIST#"]
