# Batch 5: orders to characters, pictures, and command handlers (8800-94FF)
from overlay import A, blk
from overlay3 import fact, bug
from overlay4 import code, EXTRA_REGIONS

blk(0x883E,'c','Report a missing or unsuitable instrument',[
 "The instrument counterpart of the end of #R$87AD. If no object fits the instrument's words, 'I do not see ...' ($ACDB). Otherwise the command is left unfinished (#R$8765) and the game asks, for example, 'unlock the door with what?' ($ACB4), so the player can simply type 'the key'. The words of the question are pushed on the stack by #R$8865."])
blk(0x8865,'c','Push the words of the action for a question (instrument)',["Enters #R$8869 with A=$28 (the opcode of JR Z) instead of $20 (JR NZ)."])
blk(0x8869,'c','Push the words of the action for a question',[
 "Pushes the particle and the preposition of the current action (from the action table entry at $834F) on the stack, as parameters for a message such as 'take what?' or 'unlock the door with what?'. Words that should not appear are replaced by 0.",
 "This routine modifies itself: it writes A (the opcode for either JR NZ or JR Z) into the two conditional jumps at $887F and $888E before running them, so that the same code can test flag bits for either the target or the instrument. It then returns by jumping to its return address, which it had to move out of the way under the pushed words (the EX (SP),HL instructions)."])
fact('selfmod','The game modifies its own code',
 "In several places The Hobbit rewrites its own instructions to save space. #R$8869 pokes either a JR NZ or a JR Z opcode into two jumps before executing them; #R$9E71 and #R$9E76 change the offset in an LD A,(IX+n) instruction to search the exits of a room either by the door they pass through or by their destination; and #R$93CD and #R$93ED poke a SET or RES instruction so that LOCK and UNLOCK can share code.")
blk(0x8895,'c','"I do not know the verb ..."',["Pushes the verb, particle and preposition the player used and prints 'I do not know the verb \"...\"' ($ACA4): the verb is known, but not with those words (for example 'take through the door')."])
blk(0x88A7,'c','Address the orders to a character',[
 "After SAY TO someone \"...\", the commands inside the quotation are waiting in the orders buffer (#R$B628), each in a slot marked $FF. This routine gives the first A of them to the character being spoken to, by writing the character's object number ($B5D9) into the slots' first bytes. Any further waiting orders (more than the character will accept) are thrown away by setting their first byte to 0."])
blk(0x88EC,'c','Find an order for the current actor',[
 "Searches the eight 25-byte slots of the orders buffer (#R$B628) for one addressed to the current actor ($B5DB). Returns with Z set and HL pointing at the slot if one is found."],regs=['Output:F Z set if found','HL Order slot'])
blk(0x88FD,'c','Does the actor have an order waiting?',["As #R$88EC, preserving BC, DE and HL."])
blk(0x8907,'c','Obey an order',[
 "Called with A non-zero by #R$976C when a character has been given an order by the player. The order's slot is found (#R$88EC) and freed, and the 24-byte frame stored in it is matched to an action and objects exactly as if the player had typed it (#R$83A7), but with the quotation flag set so that nothing is printed while this happens. If the action would work (#R$84DE), the character will carry it out on its turn; if not, all the character's orders are cancelled (#R$894D).",
 "With A=0 it only frees the slot."],regs=['Input:A 0 to discard the order'])
blk(0x894D,'c','Cancel a character\'s orders',["Clears every slot of the orders buffer (#R$B628) that is addressed to character A. Used when a character cannot carry out an order and when a character dies (#R$96DD)."],regs=['Input:A Character'])

blk(0x8965,'c','Draw the picture of a room, if it has one',[
 "Looks the room A up in the picture index at #R$CC00. If there is a picture, it is drawn by #R$8985. The result of the search is stored at $8964, where #R$95B9 later looks to decide whether to wait for a key after the picture has been drawn."],regs=['Input:A Room number'])
blk(0x8985,'c','Draw a picture',[
 "Interprets the picture data at HL. Pictures are drawn with vector commands, not stored as bitmaps, which is how 22 full-width pictures fit into a few kilobytes. The first two bytes set the border colour and the colour of the picture area, which is cleared (#R$8BE9); if Bilbo is in the dark the picture is not drawn at all.",
 "The picture area is the top 128 pixel rows of the screen. The drawing position is kept in D (x, 0-255) and E (y, 0-127, measured upwards from the bottom); it starts in the middle, at (127,63). Then each command byte is one of:",
 "#TABLE(default) { =h Byte | =h Command } { $00 | end of picture } { $08 | move: the next two bytes are the new x and y } { %1dddssss, %sslllll | line: bits 0-2 give the direction, bits 3-6 and the top two bits of the next byte give the slope, and the rest of that byte the length; drawn by #R$8B2F } { %01000ccc, x, y | flood fill from (x,y) with ink colour ccc (#R$8A4F) } { %00100ccc, address, runs... | paint attribute cells with paper colour ccc: starting at the given attribute address, each following byte moves up, right, down or left (bits 0-1) a number of cells (bits 2-7, plus 1), painting as it goes; ended by $FF } TABLE#",
 "Lines and fills also set the ink colour of every attribute cell they touch (#R$8B93), so colour is applied as the picture is drawn. Anything else is ignored."],regs=['Input:HL Picture data'])
blk(0x8A4F,'c','Flood fill',[
 "Fills the area around the point (D,E) with colour A (stored at $8C2C for #R$8B93). It works a column at a time: from the starting point it walks down to the first set pixel below, then plots upwards, pixel by pixel, until it meets a set pixel or the edge. While doing this it watches the columns on the left and right (#R$8ACC): whenever it finds the start of an unfilled stretch next to the current column, the position is pushed on the stack to be filled later. The fill ends when the stack is back to the marker $0080 pushed at the start. The flags at $8A4D and $8A4E remember whether the column to the left and right was already being tracked."],regs=['Input:A Colour','D x','E y'])
blk(0x8ACC,'c','Test a pixel',["Returns with Z reset if the pixel at (D,E) is set."],regs=['Input:D x','E y'])
blk(0x8AD3,'c','Move an attribute address up a row',["Subtracts 32 from HL, unless that would move it above the attribute file ($5800), in which case HL is unchanged. Used when painting colours (#R$8985)."])
blk(0x8AE4,'c','Move an attribute address down a row',["Adds 32 to HL, unless that would move it off the bottom of the attribute file."])
blk(0x8AF5,'c','Move an attribute address left',["Decreases HL, unless that would move it out of the attribute file."])
blk(0x8AFF,'c','Move an attribute address right',["Increases HL, unless that would move it out of the attribute file."])
blk(0x8B09,'c','Move the drawing position up',["Increases E (y), unless it would go past 127. Returns with Z set if the edge was reached. A is preserved."])
blk(0x8B18,'c','Move the drawing position down',["Decreases E, unless it would go below 0. Returns with Z set at the edge."])
blk(0x8B1F,'c','Move the drawing position right',["Increases D (x), unless it would go past 255. Returns with Z set at the edge."])
blk(0x8B26,'c','Move the drawing position left',["Decreases D, unless it would go below 0. Returns with Z set at the edge."])
blk(0x8B2F,'c','Draw a line',[
 "Draws a line of L+1 pixels from (D,E) in one of eight directions (bits 0-2 of C). Bit 0 says whether the line is mostly vertical or mostly horizontal; bits 1 and 2 give the vertical and horizontal directions. The line moves one pixel along its main direction every step, and one pixel along the other direction every B steps, so lines have slopes of 1, 1/2, 1/3 and so on rather than arbitrary angles. Drawing stops early at the edge of the picture area."],
 regs=['Input:C Direction','B Steps per sideways move','L Length','D,E Start'])
blk(0x8B93,'c','Plot a pixel',[
 "Sets the pixel at (D,E) and gives its attribute cell the ink colour held at $8C2C, keeping the cell's paper colour. If the ink would be the same as the paper (and so invisible), the ink is changed to its complement (XOR $38 before shifting)."])
blk(0x8BBC,'c','Get the screen address of a pixel',[
 "Converts the picture coordinates (D,E) to a screen address HL and a bit mask A. The y coordinate is turned upside down (127-E), because pictures are drawn with y measured upwards, and then split up in the usual way for the Spectrum's interleaved screen layout."],regs=['Input:D x','E y','Output:HL Screen address','A Bit mask'])
blk(0x8BE9,'c','Start a picture: clear the picture area',[
 "Reads the picture's first two bytes: the border colour, which is set straight away, and the attribute for the picture area. The top two thirds of the screen ($4000-$4FFF) are cleared, and the 512 attributes of that area are filled with the picture's colour.",
 "If Bilbo is in the dark (#R$954D), the border and attributes are set to black instead, and the drawing is abandoned: the return address is discarded and the routine jumps to the end of #R$8985."])
blk(0x8C2D,'c','LOOK',["Describes the room the actor is in (#R$958E). The dry-run check (#R$9C99) comes first, so trying LOOK costs nothing."])
blk(0x8C3A,'c','Is the actor carrying the target?',["Returns normally if the actor is carrying the target (#R$9BCD). If not, it prints 'you are not carrying it.' and returns to the caller's caller, so the action goes no further."])
blk(0x8C45,'c','DROP',[
 "The actor must be carrying the target (#R$8C3A). If the target is tied to the rope (it is 'held by' object 18), it is the rope that is dropped.",
 "Dropping means setting the object's holder to $FF, which leaves it in the room. But objects with bit 1 of their flags set are liquids or things that do not survive being put down: they 'evaporate', which means their location is set to 0 (nowhere) and a message says so. The objects that behave like this are numbers 9, 20 (the wine), 21, 22, 23, 24 and 42."])
blk(0x8C86,'c','Can the actor lift the target?',[
 "Checks the weights for TAKE and CARRY. Byte 3 of an object record is its weight. The target's weight, plus the weight of everything it contains (#R$9C42), must not exceed the actor's lifting capacity (byte 3 of the actor's record), or 'the X is too heavy to lift.' And the actor's capacity minus what they are already carrying minus the new load must not go negative, or 'you are carrying too much.' Doors and other multi-place objects (#R$91B0), and objects fixed in place, cannot be taken at all."])
blk(0x8CC8,'c','TAKE and CARRY',[
 "If the actor already has the target: 'you are already carrying the X.' Otherwise, after the weight checks (#R$8C86), the actor becomes the object's holder (byte 1 of its record). Taking the rope also takes anything tied to it."])
blk(0x8EA0,'c','Go through an exit',[
 "Moves the actor through the exit at IX (see the room records at #R$B97A): byte 0 the direction, byte 1 a door or other obstacle, byte 2 the destination. Exits with no destination cannot be used. If the exit has a door, the door must be open (bit 5 of its flags). The direction is then used as the action number and the move is made by #R$8D19 (at $8D27). If the exit cannot be used, #R$9EBF reports it."],regs=['Input:IX Exit','A $FF if there is no exit'])
blk(0x8F17,'c','RUN',["Running means going in a random direction. A random number from 1 to 9 is chosen (#R$9BF4), and the exits of the room are tried from that direction onwards, cycling round, until one with a destination is found (#R$9E51); the actor then moves that way (#R$8D19)."])
blk(0x8F37,'c','ENTER and GO INTO',["Finds the exit of the current room that leads to the room named as the target (#R$9E76) and goes through it (#R$8EA0), so 'go into the tunnel' works without naming a direction."])
blk(0x8F40,'c','FOLLOW',[
 "If the character being followed is in the same room, nothing happens: 'I cannot follow X from here.' Otherwise the actor looks for an exit from the current room that leads straight to the room the character is in (#R$9E76) and takes it (#R$8EA0). So you can only follow someone who has just left by a direct exit."])
blk(0x8F9E,'c','TALK TO and SAY TO',[
 "Hands the orders collected from a quotation (#R$80CD) to the character being spoken to (#R$88A7). A character who is not in the character table cannot take orders. Characters with a non-zero 'stubbornness' value (byte 6 of their entry in #R$C9BA) may refuse: a random number (#R$9BF4) decides, and if they refuse they say \"no\" and the orders are discarded. $B5EA also has to be 0. This is the random element that makes Thorin sometimes do what you ask and sometimes not."])
blk(0x9055,'c','INVENTORY',["Prints 'you are carrying.' and then either '      nothing' or a list of the objects held by the actor (#R$9EF8), using #R$9CEC to count them first."])
blk(0x9078,'c','OPEN',[
 "Checks that the target is not locked or already open (#R$A129; if it is, #R$A09C says so, e.g. 'the door is locked'). Then sets bit 5 (open) of its flags. If the target is an ordinary object (a container rather than a door) and has something in it, the contents are listed (#R$9EF8) unless the actor is in the dark (#R$9F89)."])
blk(0x90A2,'c','CLOSE',["Checks the target is open (#R$A4C3; otherwise 'the X is closed'), then clears bit 5 of its flags."])
A[0x90B4]['desc']=["Used by #R$90DB. This is part of the fight routine's checks on what may be attacked (flag bits of the target)."]
blk(0x91B0,'c','Is the target an ordinary object?',["Returns with Z set if byte 0 of the target's record is 1: an object in one place. Doors and other things that exist in two places have 2."],regs=['Output:F Z set if the target is an ordinary object'])
blk(0x9206,'c','EAT and DRINK',[
 "Eating food makes the actor stronger: 10 is added to their strength (byte 5 of their record). If the target is inside a container (for example a drink in a bottle), the container's 'full' flag (bit 2) is cleared and the actor gains only 1. The food or drink then vanishes: its holder is set to $FF and all its locations to 0.",
 "But there is a limit. If the new strength would be 128 or more, the game prints 'his foul gluttony has killed him' ('your foul gluttony has killed you' for Bilbo), and the actor dies (#R$96DD). Bilbo starts with strength 64, so the seventh helping of food is fatal."])
fact('gluttony','Eating makes Bilbo stronger - up to a point',
 "Each time Bilbo eats, his strength (the value used in fights, #R$90DB) goes up by 10 (#R$9206). Starting at 64, a few meals make him noticeably more dangerous. But the game will not let strength reach 128: the meal that would take it there kills him instead, with the message 'your foul gluttony has killed you'.")
blk(0x9308,'c','GIVE TO',[
 "The actor must be carrying the target (#R$9BCD; otherwise 'you are not carrying it'). The receiver must be able to carry it: the target's weight plus what the receiver already carries (#R$9C42) must not exceed the receiver's capacity, or 'X is carrying too much'. Then the receiver becomes the target's holder, the target moves to the receiver's room, and #R$9B38 tells anyone who sees it."])
blk(0x9344,'c','EXAMINE',[
 "If the object has a description message, it is printed. The address of that message is stored in the object's fourth word slot (bytes 14 and 15 of its record), which is not needed for words when the object has only one or two adjectives. Otherwise the game just says 'you see the X.'"])
blk(0x93CD,'c','LOCK',[
 "The target must be closed and not already locked (#R$A129). The instrument must not be broken (bit 3 of its flags) or 'the key is broken'. Then bit 0 (locked) of the target's flags is set.",
 "LOCK and UNLOCK share their last instructions: this routine writes $C6 into $93EB, turning the instruction at $93E8 into SET 0,(IX+$07); #R$93ED writes $86 there, turning it into RES 0,(IX+$07)."])
blk(0x93ED,'c','UNLOCK',["The target must be locked (bit 0 of its flags) or 'the door is unlocked'; the instrument must fit (#R$A134). Then the RES instruction is written into #R$93CD and the lock is cleared there."])
blk(0x9404,'c','THROW ... ACROSS / THROUGH',[
 "The actor must be carrying the target. The instrument (the thing thrown across or through, such as a river or a window) must be one of the exits of the room (#R$9E71), and if it is a door it must be open ('the window is closed'). The target is then dropped and moved to the room on the other side, and #R$9B38 reports it."])
blk(0x9436,'c','Could the action apply to this target?',[
 "Used while choosing between candidate objects (#R$86ED). Sets $B5EC to 1 if the action could possibly apply to the target: either there is a default handler for the action (#R$C61F), or the target itself has a handler for it (#R$9ADC). The checks in #R$A100 are also applied. Sets $B5EC to 0 if the action is not possible at all, for example when the target is the actor."])
blk(0x946F,'c','Carry out the action',[
 "Performs the current action ($B5D8) with the current target ($B5D9) and instrument ($B5DA). During a dry run ($B5EB = 0) nothing is printed or changed, and the routines report success in $B5EC instead.",
 "First the basic checks: the action must make sense (#R$9A9F: you cannot, for instance, give something to yourself; if it fails, 'I cannot do that.'). If it is dark (#R$954D) and the action needs light, 'I see nothing.' unless the objects are being carried. The records of the target and instrument are found and saved in $B5F8 and $B5FA, and each must be within reach (#R$9686).",
 "Then the handlers are found. If the target (or, for certain actions listed at #R$A13B, the instrument) has handlers of its own for this action (#R$9ADC), they are called one after another: the matching entry and any entries with action 0 straight after it. Otherwise the default handler for the action is looked up in #R$C61F. If there is none, 'I cannot do that.'",
 "Finally, if the action really happened and the player did it in the dark, the darkness message is printed, and #R$953F gives any character involved as target or instrument a chance to react (#R$99FB)."])
