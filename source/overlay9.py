# Batch 9: hand-written line comments for selected routines
from overlay import A, blk
import overlay4
def C(addr, d):
    A[addr]['comments'].update(d)
C(0xA6B8,{
 0xA6B8:'Pick up the number of the character doing the examining',
 0xA6BB:'Is it Elrond (object 65)?',
 0xA6BD:'No: treat it as an ordinary EXAMINE (you see the curious map)',
 0xA6C0:'Elrond: during a dry run, record that this would work and stop here',
 0xA6C3:'IY = the hidden-route entry chosen at the start of the game (this operand is written by #R$970B)',
 0xA6C7:'HL = the address of the blanked-out exit in the room record...',
 0xA6CA:'...(bytes 1 and 2 of the entry)',
 0xA6CD:'Has the map already been read?',
 0xA6D0:'',
 0xA6D2:'Yes: the exit is already open, so skip straight to what Elrond says',
 0xA6D4:'Three bytes to restore: direction, door and destination',
 0xA6D6:'Fetch one byte of the exit from the entry (bytes 3-5)...',
 0xA6D9:'...and put it back into the room record',
 0xA6DA:'Next byte of the room record',
 0xA6DB:'Next byte of the entry',
 0xA6DD:'Repeat for all three bytes: the hidden way is now open',
 0xA6DF:'Point IY back at the start of the entry (the INCs moved it on)',
 0xA6E3:'A = the destination room (byte 5 of the entry)',
 0xA6E6:'IX = its room record',
 0xA6E9:'Skip the two flag bytes...',
 0xA6EB:'...to reach the room\'s name words',
 0xA6ED:'Push them as the third parameter of the message ("...to get to <room>")',
 0xA6EF:'A = the room that has the exit (byte 0 of the entry)',
 0xA6F2:'IX = its room record',
 0xA6F5:'Skip the two flag bytes...',
 0xA6F7:'...to reach the room\'s name words',
 0xA6F9:'Push them as the second parameter ("...from <room>...")',
 0xA6FB:'A = the direction of the exit (byte 3 of the entry)',
 0xA6FE:'DE = the word for that direction (NORTH, EAST...)',
 0xA701:'Push it as the first parameter ("go <direction>...")',
 0xA702:'HL = the message "go <direction> from <room> to get to <room>"',
 0xA705:'Elrond says it: \'elrond says "go north from beorns house to get to the great river".\''})

from overlay3 import fact, bug
from overlay4 import EXTRA_REGIONS
A[0x8D19]['desc']=[
 "Moves the current actor one step in the direction given by the action number (1-10: north, south, east, west, northeast, northwest, southeast, southwest, up, down). Used for the player's movement commands and for every character that moves.",
 "IN THE DARK, Bilbo does not know which way he is going: the direction is replaced by a random one ($8D1E). And if there is no exit that way, instead of 'you cannot go that way' he stumbles: his strength is halved, and he reads 'but fall and hit your head.', or, once his strength has dropped to nothing, 'but fall and smash your skull.' and dies.",
 "A character being carried by another character (for example Bilbo carried by someone) is set down first. The size of the actor plus everything it carries is worked out ($8D18). The exit must exist; if it has a door, the door must be open (or broken); Bilbo cannot use a door with bit 7 of its attributes set; and the actor must be no bigger than the door ('the window is too small for you to enter'). If the destination room has a capacity, there must be room ('the boat is too full for you to enter').",
 "Then the actor's location becomes the destination and everything it carries moves with it (#R$9B38). If the actor is Bilbo, the room-entry handler for the destination is run (#R$C67D), and the room is described. The first time Bilbo enters a room, bit 6 of the room's flags is set, the room is described in full (#R$958E), and if the room is in the scoring table at #R$8CEA its points are added to the score. On later visits the short description is used (#R$9606)."]
A[0x8D19]['comments']={
 0x8D19:'Is Bilbo in the dark?',0x8D1C:'No: go on with the direction he chose',
 0x8D1E:'In the dark: pick a random direction from 1 to 10 instead...',0x8D24:'...and make it the action',
 0x8D27:'IY = the actor\'s record',0x8D2B:'Is the actor being held by something?',0x8D30:'No: skip',
 0x8D32:'IX = the holder\'s record',0x8D35:'Is the holder a living character (bit 6)?',0x8D39:'No (a box or barrel): the actor cannot just walk off',
 0x8D3B:'Yes: the actor gets down from the character carrying it',
 0x8D3F:'Work out the size of the actor plus everything it carries...',0x8D45:'...plus its own size',0x8D48:'...and keep it for the door and room checks',
 0x8D4B:'A = the direction',0x8D4E:'IX = the exit that way, if there is one',0x8D51:'Is there one?',0x8D53:'Yes: go and check it',
 0x8D55:'No exit (or it cannot be used): is Bilbo in the dark?',0x8D58:'No: just report the failure ("you cannot go that way")',
 0x8D5B:'Dry run? Then stop here',0x8D5E:'IX = Bilbo\'s record',0x8D62:'Clear the carry flag',0x8D63:'"but fall and hit your head."',
 0x8D66:'Halve Bilbo\'s strength',0x8D6A:'If he has any left, print the message and return',
 0x8D6D:'Otherwise: "but fall and smash your skull."',0x8D70:'Print it',0x8D73:'Bilbo is dead',
 0x8D76:'A = the exit\'s destination room',0x8D79:'Is there one?',0x8D7A:'No: the exit cannot be used',0x8D7C:'Save the destination room number',
 0x8D7F:'A = the exit\'s door, if any',0x8D82:'Is there a door?',0x8D83:'No door: go on to the destination room',
 0x8D85:'IX = the door\'s record',0x8D88:'A = the door\'s flags',0x8D8B:'Is it open (bit 5) or broken (bit 3)?',0x8D8D:'No: the door is in the way',
 0x8D8F:'Is the actor Bilbo?',0x8D93:'No: skip the next check',0x8D95:'Bit 7 of the door\'s attributes: a way Bilbo cannot use',0x8D99:'Set: he cannot go this way',
 0x8D9B:'A = the size of the actor and its load',0x8D9E:'B = the size of the door',0x8DA1:'Compare them',0x8DA2:'Too big: "the X is too small for you to enter"',
 0x8DA4:'A = the destination room',0x8DA7:'Keep it in B',0x8DA8:'IX = its room record',0x8DAB:'Keep that for later',
 0x8DAF:'Does the room have a capacity ($FF = unlimited)?',0x8DB4:'Unlimited: go ahead',0x8DB6:'A = the destination room',
 0x8DB7:'A = the space left in it',0x8DBA:'Keep it in C',0x8DBB:'A = the size of the actor and its load',0x8DBE:'Compare them',0x8DBF:'Too big: "the X is too full for you to enter"',
 0x8DC1:'Dry run? Then stop here: the move would work',0x8DC4:'Move the actor: its location becomes the destination',
 0x8DC7:'Move everything the actor holds with it',0x8DCA:'',0x8DCD:'Is the actor Bilbo?',0x8DD0:'',0x8DD2:'No: a character has moved, and that is all',
 0x8DD3:'Look up the destination in the room-entry handlers',0x8DD7:'',0x8DDA:'',0x8DDD:'None: skip',0x8DDF:'HL = the handler...',0x8DE2:'',0x8DE5:'...and run it',
 0x8DE8:'Is Bilbo now in the dark?',0x8DEB:'Yes: he sees nothing, so describe nothing',
 0x8DEC:'Is the actor Bilbo?',0x8DEF:'',0x8DF0:'A = the room',0x8DF3:'No: describe it anyway (entry for other callers)',
 0x8DF5:'HL = the room record',0x8DF8:'Has Bilbo been here before (bit 6 of the room\'s flags)?',0x8DFA:'Yes: give the short description',
 0x8DFD:'No: mark the room as visited',0x8DFF:'Save the room number',0x8E00:'Look the room up in the scoring table',0x8E04:'',0x8E07:'Not there: no points',
 0x8E09:'',0x8E0A:'DE = the points for this room',0x8E0D:'',0x8E10:'Add them to the score',0x8E13:'',0x8E14:'',0x8E17:'',0x8E18:'Restore the room number',
 0x8E19:'Describe the room in full',0x8E1C:'"<the door> is too small for you to enter"',0x8E1F:'',0x8E21:'IX = the destination room record',0x8E25:'"<the room> is too full for you to enter"',
 0x8E28:'',0x8E29:'Push the room\'s (or door\'s) words as the message parameter',0x8E2F:'',0x8E30:'Print the message',0x8E33:'Done'}
blk_scores=[('B',0x8CEA+3*i,3,'') for i in range(14)]
A[0x8CEA]=dict(t='b',title='Points for visiting rooms',desc=[
 "Room number and points (a word, in tenths of a percent) for #R$8D19, which adds them to the score the first time Bilbo enters the room. Terminated by $FF.",
 "#TABLE(default) { =h Room | =h Points } { 4 lonelands | 2.5% } { 7 trolls' cave | 5% } { 11 narrow place | 2.5% } { 22 Beorn's house | 2.5% } { 13 goblins' dungeon | 7.5% } { 65 dark stuffy passage | 5% } { 27 smothering forest | 2.5% } { 28 levelled elvish clearing | 2.5% } { 31 dark dungeon | 5% } { 34 long lake | 10% } { 38 dale valley | 2.5% } { 42 side door | 2.5% } { 43 smooth straight passage | 5% } { 41 lower halls | 20% } TABLE#",
 "Together they are worth 75%. Being captured and thrown into a dungeon counts as a visit, so both dungeons score."],regs=[],comments={},subs=blk_scores+[('B',0x8D14,1,'End marker')],mid={})
EXTRA_REGIONS[0x8CEA]=0x8D15
A[0x8D15]=dict(t='b',title='Move variables',desc=["$8D15: the destination room's record. $8D17: the destination room. $8D18: the size of the actor plus its load."],regs=[],comments={},subs=[('B',0x8D15,2,'Room record'),('B',0x8D17,1,'Destination room'),('B',0x8D18,1,'Size')],mid={})
EXTRA_REGIONS[0x8D15]=0x8D19
fact('score','Most of the score comes from sightseeing',
 "Three quarters of the score is simply for visiting places: the first time Bilbo enters one of fourteen rooms, its points are added (#R$8CEA), from 2.5% for the lonelands to 20% for the lower halls of the Lonely Mountain. Being thrown into the goblins' dungeon is worth 7.5%.")
fact('darkmove','Moving in the dark is dangerous',
 "In a dark place Bilbo cannot choose his way: any movement command sends him in a random direction (#R$8D19). If there is no exit that way, he falls and hits his head, which halves his strength; do it often enough and 'you fall and smash your skull'. With the glowing sword (#R$954D) none of this happens.")
C(0xA7EA,{0xA7EA:'Dry run? Then just record that this would work, and return',0xA7ED:'Gollum is no longer waiting for an answer...',0xA7EE:'',
 0xA7F1:'Take the order the player gave Gollum (SAY TO GOLLUM "...") off the orders buffer; HL points at it',0xA7F4:'Nothing was said to him: Bilbo is strangled',
 0xA7F6:'Search the 24 bytes of the order...',0xA7F9:'DE = the riddle entry chosen at the start of the game',0xA7FD:'A = the low byte of the answer word (NIGHT or MAN)',
 0xA7FE:'Look for it in the order',0xA800:'Not there: Bilbo is strangled',0xA802:'Found: now check the high byte of the word',0xA803:'',0xA804:'',
 0xA805:'Does the next byte of the order match it?',0xA806:'No: keep searching the rest of the order',0xA808:'Yes: the answer was right, and Bilbo lives',
 0xA809:'Dry run? Then stop',0xA80C:'Make sure the player sees the message',0xA80E:'',0xA811:'"someone strangles you from behind."',0xA814:'',0xA817:'Bilbo is dead'})

C(0x9611,{0x9611:'Save the registers: the end of the turn must not disturb the caller',0x9612:'',0x9614:'',0x9616:'',0x9617:'',
 0x9618:'Has the game been won (treasure in the chest)?',0x961B:'Let every other character take its turn',
 0x961E:'No timer has expired yet this turn',0x961F:'',0x9622:'From now on things really happen: set the "would work"...',0x9623:'',0x9626:'...and "really do it" flags',
 0x9629:'IY = the first timer entry',0x962D:'Fetch its reload value',0x9630:'$FF marks the end of the table',0x9632:'All timers done: finish',
 0x9634:'A = the timer\'s count',0x9637:'Is the timer running?',0x9639:'No: next timer',
 0x963B:'Count down one turn',0x963C:'',0x963F:'Has it reached 0?',0x9641:'Not yet: see whether it is time for the tick routine',
 0x9643:'It has expired. Has another timer already expired this turn?',0x9646:'',0x9648:'Set the count to 1 if so (so it fires next turn) or leave it at 0',0x964B:'Another timer has fired: wait until next turn',
 0x964D:'This is the first: note that a timer has fired this turn',0x964E:'',0x9651:'HL = the expire routine...',0x9654:'',0x9657:'...and run it',0x965A:'Next timer',
 0x965C:'A = the threshold for the tick routine',0x965F:'Is there one?',0x9661:'No: next timer',0x9663:'Is the count at or below the threshold?',0x9666:'No: next timer',
 0x9668:'HL = the tick routine...',0x966B:'',0x966E:'...and run it',
 0x9671:'Move on to the next 7-byte entry',0x9674:'',0x9676:'Loop',
 0x9679:'Turn output back on for the player',0x967B:'',0x967E:'Restore the registers',0x967F:'',0x9680:'',0x9682:'',0x9684:'',0x9685:''})

C(0x976C,{0x976C:'Note Bilbo\'s room and whether he is in the dark',0x976F:'IY = the first entry of the character table',
 0x9773:'Reset the count of instructions tried by this character',0x9774:'',0x9777:'A = the character\'s object number',0x977A:'End of the table?',0x977C:'Yes: all done',
 0x977F:'0 means a dead character or an empty slot',0x9781:'Skip it',0x9784:'Make the character the current actor',
 0x9787:'A = its room, IX = its record',0x978A:'Its record is the actor\'s record...',0x978E:'...and its room is the room it starts the turn in',
 0x9791:'Switch output off until we know Bilbo can see',0x9792:'',0x9795:'',0x9797:'IY = Bilbo\'s record',0x979B:'Can Bilbo see the character?',0x979E:'',0x97A0:'No: its actions will not be printed',
 0x97A2:'Has "you hear a noise" already been printed this turn?',0x97A5:'',0x97A7:'Yes: keep quiet',0x97A9:'Output on: Bilbo can see what the character does',0x97AB:'',
 0x97AE:'Is Bilbo in the dark ($976A = 1)?',0x97B1:'',0x97B3:'No: carry on',0x97B5:'Yes: remember that the noise has been heard ($976A = 2)',0x97B6:'',
 0x97B9:'"you hear a noise."',0x97BC:'',0x97BF:'And switch output off: Bilbo sees nothing',0x97C0:'',
 0x97C3:'Is the character held by something?',0x97C5:'',0x97C8:'Yes: try to get out instead (#R$9A71)',
 0x97CB:'IX = the character\'s record',0x97CF:'Has the player given it an order?',0x97D2:'$B5E5 = 1 if so, 0 if not',0x97D4:'',0x97D6:'',0x97D7:'',
 0x97DA:'HL = where the character has got to in its behaviour program',0x97DD:'',
 0x97E0:'Has the character already tried six instructions this turn?',0x97E3:'',0x97E5:'Yes: that is enough, next character',
 0x97E7:'A = the instruction byte',0x97E8:'DE = 4, the length of an action instruction',0x97EB:'IX = the instruction',0x97EC:'',
 0x97EE:'The low nibble is the instruction type',0x97F0:'Types 0-4 are actions',0x97F2:'Types 5 and up: go and decode them',
 0x97F4:'An action instruction. Is an order from the player waiting?',0x97F7:'',0x97F9:'No: carry out the program',0x97FB:'Does this instruction refuse orders (bit 6)?',0x97FD:'Yes: carry out the program',
 0x97FF:'The order is being dealt with now',0x9800:'',0x9803:'',0x9804:'Match the order to an action and objects',0x9807:'It cannot be done: carry on with the program instead',
 0x9809:'The order will be obeyed for real',0x980B:'',0x980E:'',0x9811:'Arrange to go on to the next character afterwards',0x9814:'',0x9815:'',0x9817:'Do it (#R$9921), then return to $985C',
 0x981A:'Fetch the instruction type again',0x981B:'',0x981D:'Type 4: an action without objects',0x981F:'',0x9822:'Types 0-3: an action with objects, or a routine',0x9824:'(Not reached)',
 0x9826:'Type $0E: go to',0x9828:'',0x982A:'Store the address that follows as the new program position',0x982D:'',0x9830:'',0x9833:'',0x9836:'And carry on from there, in the same turn',
 0x9838:'Type $0C: change behaviour on a named action',0x983A:'',0x983C:'B = the action',0x983F:'A = this character',0x9842:'Switch to its reaction for that action',0x9845:'Carry on',
 0x9847:'Type $0F: pick a behaviour at random',0x9849:'',0x984B:'',0x984E:'Carry on',
 0x9850:'Type 0 would skip the instruction here, but types below 5 never get this far',0x9852:'',0x9854:'',0x9855:'',
 0x9857:'Any other type: return to the default behaviour (reaction table entry 0)...',0x9858:'',0x9859:'...and end this character\'s turn',
 0x985C:'Next character: entries are 7 bytes long',0x985F:'',0x9861:'',
 0x9864:'All characters done: Bilbo is the actor again',0x9865:'',0x9868:'Output back on',0x9869:'',0x986C:'The actor\'s record is Bilbo\'s',0x986F:'',0x9872:''})

# ---- parser
A[0x7F69]['title']='Find the next frame (24 bytes lower)'
A[0x7F69]['desc']=["Returns IX = IY - 24: the frame after the current one in parse order (frames are built downwards from #R$B8B8). Frames belonging to a quotation (bit 6 of byte 1) are skipped. Continues into #R$7F6F at $7F73."]
A[0x7F6F]['title']='Find the previous frame (24 bytes higher)'
A[0x7F6F]['desc']=["Returns IX = IY + 24: the frame before the current one in parse order, skipping frames that belong to a quotation. The entry at $7F73 is shared with #R$7F69, which uses -24 instead."]
A[0x7F56]['title']='Parser: step back to the previous frame'
A[0x7F56]['desc']=["Decrements B (a frame counter), finds the previous frame (#R$7F6F, 24 bytes higher) and swaps IX and IY, so that IY is the previous frame and IX the one we came from."]
A[0x7F5C]['title']='Parser: step on to the next frame'
A[0x7F5C]['desc']=["Decrements B, finds the next frame (#R$7F69, 24 bytes lower) and swaps IX and IY, so that IY is the next frame and IX the one we came from. The entry at $7F5D does not decrement B."]
C(0x7F56,{0x7F56:'One frame fewer to go',0x7F57:'IX = the previous frame (24 bytes higher)',0x7F5A:'Swap IX and IY'})
C(0x7F5C,{0x7F5C:'One frame fewer to go',0x7F5D:'IX = the next frame (24 bytes lower)',0x7F60:'Swap IX and IY...',0x7F62:'',0x7F64:'',0x7F66:'...so IY is the new frame and IX the old one',0x7F68:''})
C(0x7F69,{0x7F69:'',0x7F6A:'Step -24: the next frame',0x7F6D:''})
C(0x7F6F,{0x7F6F:'',0x7F70:'Step +24: the previous frame',0x7F73:'IX = IY...',0x7F75:'',0x7F77:'...plus the step',0x7F79:'Does this frame belong to a quotation?',0x7F7D:'Yes: skip over it',0x7F7F:'',0x7F80:''})

C(0x7C4F,{0x7C4F:'IY = the first command frame',0x7C53:'Not inside a quotation',0x7C54:'',0x7C57:'No ALL or ALL EXCEPT in force',0x7C5A:'No frames built yet',
 0x7C5D:'State: everything allowed',0x7C5F:'Is an unfinished command waiting to be completed?',0x7C62:'',0x7C63:'(Pretend the previous word was AND)',0x7C65:'Yes: go straight to the end-of-line processing, which merges the new words in',
 0x7C68:'Previous class: end of line',
 0x7C6A:'START OF A COMMAND: no prepositions yet',0x7C6B:'',0x7C6E:'Allow a verb (bit 1), an adverb (bit 2), and both noun phrases (bits 6 and 7)...',0x7C6F:'',0x7C71:'',
 0x7C72:'...but after ALL EXCEPT...',0x7C75:'',0x7C77:'',0x7C79:'...no new verb is allowed',0x7C7B:'Clear the frame',
 0x7C7E:'NEXT NOUN PHRASE: clear the 10-byte noun phrase buffer',0x7C81:'',0x7C83:'',0x7C86:'Articles are allowed again',
 0x7C88:'NEXT WORD: fetch it; A and D = its class, BC = the word',0x7C8B:'',0x7C8C:'Class / 8 = offset into the jump table',0x7C8D:'',0x7C8E:'',0x7C8F:'',0x7C90:'',
 0x7C92:'HL = the handler for this class',0x7C95:'',0x7C96:'',0x7C97:'',0x7C98:'',0x7C99:'',0x7C9A:'',0x7C9B:'Go to it'})

C(0x7CC0,{0x7CC0:'End of the line: no more commands will follow',0x7CC1:'',
 0x7CC4:'THEN, full stop or end: has a verb been given (bit 1 of E clear)?',0x7CC6:'Yes: close the frame',
 0x7CC8:'No verb. Is this the first frame?',0x7CCB:'',0x7CCC:'No: the verb will be copied from the frame before',
 0x7CCE:'First frame without a verb. Was the previous word the end of the line too?',0x7CD1:'',0x7CD3:'',0x7CD5:'',0x7CD6:'An empty line: nothing to do',
 0x7CD8:'Inside a quotation?',0x7CDB:'No: a command with no verb, so "what?"',
 0x7CDE:'Close the frame. Is ALL in force?',0x7CE1:'',0x7CE2:'',0x7CE4:'Yes: mark the verb with bit 7 (ALL)',
 0x7CE8:'HL = the frame count',0x7CEB:'',0x7CEC:'',0x7CED:'',0x7CEF:'(Under ALL EXCEPT, an AND does not start a new frame)',0x7CF1:'',0x7CF3:'Count the frame',
 0x7CF4:'Move on to the next frame',0x7CF7:'Was this an AND or THEN rather than the end of the line?',0x7CF9:'Yes: start the next command',
 0x7CFC:'END OF THE LINE. Is an unfinished command waiting?',0x7CFF:'',0x7D00:'No: go on to share verbs between frames',
 0x7D02:'Yes: HL = the slot in the old frame that the question was about ($B60A holds its offset)',0x7D03:'',0x7D04:'',0x7D06:'',0x7D09:'',
 0x7D0A:'',0x7D0C:'IY = the frame just typed',0x7D10:'Does its first noun phrase have a noun?',0x7D13:'',0x7D16:'',0x7D19:'No: use it anyway',
 0x7D1B:'Is it the same noun the old command used?',0x7D1E:'',0x7D1F:'',0x7D21:'',0x7D24:'',0x7D25:'',0x7D26:'',0x7D27:'Yes: take this phrase',
 0x7D29:'Otherwise try the second noun phrase',0x7D2C:'',0x7D2F:'',0x7D32:'',0x7D34:'No suitable phrase: leave the old command as it was',
 0x7D36:'Fill the empty words of the old phrase (noun and two adjectives) from the new one...',0x7D37:'',0x7D39:'',0x7D3A:'',0x7D3B:'',0x7D3C:'',0x7D3D:'...keeping any word already there',
 0x7D3F:'',0x7D40:'',0x7D41:'',0x7D42:'',0x7D43:'',0x7D45:'',0x7D46:'',0x7D47:'',0x7D48:'',0x7D49:'...for all three words',0x7D4B:'',
 0x7D4C:'SHARE VERBS: start just above the first frame',0x7D4E:'',0x7D52:'B = the number of frames',0x7D55:'',0x7D56:'',0x7D57:'Step to the first frame',
 0x7D5A:'Any frames left?',0x7D5B:'',0x7D5C:'No',0x7D5E:'Step to the next frame',0x7D61:'Does it have a verb of its own?',0x7D64:'',0x7D66:'',
 0x7D69:'No (it came from AND): give it the previous frame\'s verb',0x7D6C:'Loop',
 0x7D6E:'SHARE SECOND NOUN PHRASES, working backwards:',0x7D6F:'',0x7D71:'',0x7D73:'step to the previous frame',
 0x7D76:'Any frames left?',0x7D77:'',0x7D78:'No: finish',0x7D7B:'Step back one more',
 0x7D7E:'Does this frame lack a second noun phrase...',0x7D81:'',0x7D84:'',0x7D86:'...and have the same verb as the frame after it...',0x7D89:'',0x7D8C:'',0x7D8E:'',0x7D91:'',0x7D94:'',
 0x7D96:'...which does have one?',0x7D99:'',0x7D9C:'',0x7D9E:'Then copy that phrase into this frame ("put the key and the sword in the chest")',0x7D9F:'',0x7DA2:'',0x7DA5:'Loop',
 0x7DA8:'',0x7DAA:'More commands to come (THEN)?',0x7DAD:'',0x7DAE:'No: parsing is complete',0x7DAF:'Inside a quotation?',0x7DB2:'No: return',0x7DB3:'Yes: carry on parsing the words after it'})

C(0x7DB6,{0x7DB6:'May a verb start here?',0x7DB8:'Yes: treat the direction as "go <direction>"',0x7DBA:'Otherwise it is used like an adverb',
 0x7DBC:'ADVERB: is an adverb allowed here?',0x7DBE:'No: syntax error',0x7DC1:'Under ALL EXCEPT...',0x7DC4:'',0x7DC6:'',0x7DC8:'...start a new frame for it',
 0x7DCB:'No more adverbs',0x7DCD:'Store the word at offset 2 of the frame',0x7DCF:'',0x7DD2:'Next noun phrase'})
C(0x7DD5,{0x7DD5:'Note that AND has been seen (bit 3 clear)',0x7DD7:'',0x7DD8:'Skip any further ANDs and commas',0x7DDB:'',0x7DDD:'',
 0x7DDF:'Step back so the word after them will be read again',0x7DE0:'',0x7DE1:'Save the token pointer...',0x7DE4:'',0x7DE7:'',0x7DE8:'...the state flags...',0x7DE9:'',
 0x7DEC:'...the frame pointer...',0x7DF0:'...and the frame count, so the parser can backtrack here',0x7DF3:'',0x7DF6:'Then carry on as if a new command were starting'})
C(0x7DFB,{0x7DFB:'Class of GO (for a bare direction)',0x7DFD:'VERB: has there just been an AND?',0x7DFF:'Yes: a new command after AND is fine',
 0x7E01:'Inside a quotation?',0x7E04:'Yes: accept it',0x7E06:'A second verb without AND: backtrack to the last AND...',0x7E09:'',0x7E0C:'...and treat it as THEN',
 0x7E0E:'Restore the state saved at the AND',0x7E11:'',0x7E12:'',0x7E15:'',0x7E18:'',0x7E1C:'Close the frame and start a new one',
 0x7E1F:'A verb cancels ALL',0x7E22:'Is a verb allowed here?',0x7E24:'No: syntax error',0x7E27:'Is this a GO followed by a direction?',0x7E29:'No: look ahead',
 0x7E2B:'Store the verb in the frame',0x7E2E:'Next noun phrase',
 0x7E31:'Look ahead past any adverbs...',0x7E32:'',0x7E33:'',0x7E36:'',0x7E37:'',0x7E3A:'',0x7E3C:'',0x7E3E:'',0x7E40:'...is the next word a direction?',0x7E42:'Yes',
 0x7E44:'No: rewind and store the verb normally',0x7E45:'',0x7E48:'',0x7E49:'',0x7E4A:'',
 0x7E4C:'Store GO as the verb...',0x7E4F:'',0x7E50:'',0x7E51:'',0x7E52:'...and the direction at offset 2',0x7E54:'',0x7E57:'Next noun phrase'})
C(0x7E6C,{0x7E6C:'Store the preposition',0x7E6F:'Next word',0x7E72:'Another preposition?',0x7E74:'Yes: store it too',
 0x7E76:'An article?',0x7E78:'',0x7E7A:'Are articles allowed here?',0x7E7C:'No: syntax error',0x7E7F:'Only one article',0x7E81:'Next word',
 0x7E83:'An adjective?',0x7E85:'',0x7E87:'A noun?',0x7E89:'',0x7E8B:'Anything else ends the phrase: step back so it is read again',0x7E8E:'',0x7E91:'',
 0x7E93:'Store the adjective',0x7E96:'Next word',0x7E99:'',0x7E9B:'Store the noun',0x7E9E:'',0x7E9F:'',0x7EA0:'',
 0x7EA1:'The phrase is complete. Under ALL EXCEPT...',0x7EA3:'',0x7EA6:'',0x7EA8:'',0x7EAA:'...a phrase without a preposition...',0x7EAD:'',0x7EAE:'',0x7EAF:'',
 0x7EB1:'...is an exception: is this frame already an exception frame?',0x7EB5:'',0x7EB7:'No: make a new frame for it',0x7EBA:'',0x7EBC:'',
 0x7EBF:'Store the phrase as its first noun phrase...',0x7EC2:'...and mark the frame as an exception (bit 6)',0x7EC6:'Next noun phrase',
 0x7EC9:'A phrase with a preposition under ALL EXCEPT: new frame',0x7ECC:'Store the phrase in the frame',0x7ECF:'Next noun phrase',0x7ED2:''})
C(0x7EF5,{0x7EF5:'Is the first noun phrase free?',0x7EF7:'Yes: store it there',0x7EF9:'Is the second free?',0x7EFB:'Yes: store it there',0x7EFD:'Neither: syntax error',0x7F00:'',0x7F01:'',
 0x7F02:'The second phrase is now taken',0x7F04:'',0x7F05:'Offset 14 in the frame',0x7F08:'',0x7F09:'',0x7F0B:'',0x7F0C:'DE = the place in the frame',0x7F0D:'',
 0x7F0E:'Copy the 10-byte noun phrase there',0x7F11:'',0x7F14:'',0x7F16:'',0x7F17:'',0x7F18:'Return with Z set',0x7F19:'',
 0x7F1A:'The first phrase is now taken',0x7F1C:'',0x7F1D:'Offset 4 in the frame',0x7F20:''})
C(0x7F3D,{0x7F3D:'HL = the token pointer',0x7F40:'Remember where this word is, for error messages',0x7F43:'Remember the previous class',0x7F44:'',
 0x7F47:'B = the top four bits of the word offset',0x7F48:'',0x7F4A:'',0x7F4B:'D = A = the class',0x7F4C:'',0x7F4E:'',0x7F4F:'',0x7F50:'C = the bottom eight bits of the offset',0x7F51:'',0x7F52:'Move the token pointer on',0x7F55:''})

# ---- pictures
A[0x8A4F]['desc']=["Fills the area around the point (D,E) with ink colour A (kept at $8C2C for #R$8B93). It is a scan-line fill: from the starting point it moves left to the edge of the area, then works rightwards along the row, setting each pixel. At every pixel it looks at the pixel above and the pixel below: where an unfilled stretch begins in the row above or below, that position is pushed on the stack as a 'seed' to be filled later. The flags at $8A4D (above) and $8A4E (below) stop it pushing a seed for every pixel of the same stretch. When the row is done, the next seed is popped and the process repeats, until the marker $0080 pushed at the start comes back off the stack.",
 "Because each row is filled from its left-hand end, and seeds are only pushed at the starts of stretches, the fill needs very little stack even for large areas."]
C(0x8A4F,{0x8A4F:'Save the fill colour',0x8A52:'',0x8A53:'',0x8A54:'Push the end marker (a y value of $80 is impossible)',0x8A57:'',
 0x8A58:'Is the pixel at (D,E) set?',0x8A5B:'Yes: we have found the left-hand boundary',0x8A5D:'No: move left',0x8A60:'Keep going until a set pixel or the edge',0x8A62:'At the left edge of the picture: start here',
 0x8A64:'Colour the boundary pixel...',0x8A67:'...and step right onto the first empty pixel',
 0x8A6A:'Not yet tracking a stretch above or below',0x8A6D:'',
 0x8A70:'Look at the pixel above',0x8A73:'',0x8A75:'At the top edge: nothing to do above',0x8A77:'Is it set?',0x8A7A:'',0x8A7C:'Set: not part of the area',
 0x8A7E:'Empty. Already tracking this stretch above?',0x8A81:'',0x8A82:'Yes: no new seed',0x8A84:'No: push it as a seed',0x8A85:'...and start tracking',
 0x8A87:'',0x8A88:'Back down to the current row',0x8A8B:'',0x8A8C:'Remember whether we are tracking above',
 0x8A8F:'Look at the pixel below',0x8A92:'',0x8A94:'At the bottom edge: nothing to do below',0x8A96:'Is it set?',0x8A99:'',0x8A9B:'Set: not part of the area',
 0x8A9D:'Empty. Already tracking this stretch below?',0x8AA0:'',0x8AA1:'Yes: no new seed',0x8AA3:'No: push it as a seed',0x8AA4:'...and start tracking',
 0x8AA6:'',0x8AA7:'Back up to the current row',0x8AAA:'',0x8AAB:'Remember whether we are tracking below',
 0x8AAE:'Fill this pixel',0x8AB1:'Step right',0x8AB4:'At the right edge: this row is done',0x8AB6:'Is the next pixel set?',0x8AB9:'No: carry on along the row',
 0x8ABB:'Yes: colour the boundary pixel too',0x8ABE:'Pop the next seed',0x8ABF:'Is it the end marker?',0x8AC0:'',0x8AC2:'No: fill from there',
 0x8AC4:'Done: reset the drawing colour',0x8AC6:'',0x8AC9:'',0x8ACA:'',0x8ACB:''})
C(0x8985,{0x8985:'Save the registers the caller uses',0x8987:'',0x8988:'IY = the picture data',0x8989:'',0x898B:'',0x898C:'',
 0x898D:'Set the border, clear and colour the picture area (or give up if Bilbo is in the dark)',
 0x8990:'Start the pen in the middle: x = 127...',0x8992:'...y = 63',0x8994:'',0x8996:'',0x8998:'',
 0x899A:'NEXT COMMAND: fetch it',0x899D:'Zero?',0x899E:'Yes: the end of the picture',0x89A1:'',
 0x89A3:'$08: move the pen?',0x89A5:'No',0x89A7:'D = the new x',0x89AA:'',0x89AC:'E = the new y',0x89AF:'',0x89B1:'Next command',
 0x89B3:'Bit 7 set: a line?',0x89B5:'No',0x89B7:'',0x89B8:'C = the direction (bits 0-2)',0x89BA:'',0x89BB:'B = bits 3-6 of the first byte...',0x89BC:'',0x89BD:'',0x89BF:'',
 0x89C0:'L = the length (bottom six bits of the second byte, plus 1)',0x89C3:'',0x89C5:'',0x89C6:'',
 0x89C7:'...combined with the top two bits of the second byte to give the slope',0x89CA:'',0x89CC:'',0x89CD:'',0x89CE:'',0x89D0:'',0x89D1:'',0x89D2:'(plus 1)',
 0x89D3:'Draw the line',0x89D6:'Next command',
 0x89D8:'Bit 6 set: a flood fill?',0x89DA:'No',0x89DC:'A = the colour',0x89DE:'Keep the pen position',0x89DF:'D = x of the point to fill from',0x89E2:'',0x89E4:'E = y',0x89E7:'',
 0x89E9:'Fill',0x89EC:'Restore the pen position',0x89ED:'Next command',
 0x89F0:'Bit 5 set: paint character cells?',0x89F2:'No: ignore the byte',0x89F5:'C = the colour, shifted into the paper bits',0x89F7:'',0x89F8:'',0x89F9:'',0x89FA:'',0x89FB:'',0x89FC:'',0x89FD:'',
 0x89FE:'HL = the attribute address (high byte first)',0x8A01:'',0x8A03:'',0x8A06:'',
 0x8A08:'Next run byte',0x8A0B:'',0x8A0D:'$FF ends the runs',0x8A0F:'',
 0x8A11:'',0x8A12:'E = the direction (0 up, 1 right, 2 down, 3 left)',0x8A14:'',0x8A15:'B = the number of cells (bits 2-7, plus 1)',0x8A16:'',0x8A17:'',0x8A18:'',0x8A1A:'',0x8A1B:'',
 0x8A1C:'A = the cell\'s ink colour, shifted into the paper position',0x8A1D:'',0x8A1F:'',0x8A20:'',0x8A21:'',0x8A22:'Would the ink be the same as the new paper?',0x8A23:'',0x8A25:'Yes: use the complementary ink so the drawing stays visible',
 0x8A27:'Shift the ink back down',0x8A28:'',0x8A29:'',0x8A2A:'Combine with the new paper...',0x8A2B:'...and store the attribute',
 0x8A2C:'Move one cell in the run\'s direction:',0x8A2D:'',0x8A2E:'up,',0x8A31:'',0x8A32:'right,',0x8A35:'',0x8A36:'down,',0x8A39:'',0x8A3A:'or left',
 0x8A3D:'Next cell of the run',0x8A3F:'Next run',0x8A41:'',0x8A42:'',0x8A43:'',0x8A44:'Next command',
 0x8A47:'Restore the registers',0x8A48:'',0x8A49:'',0x8A4A:'',0x8A4C:''})
C(0x8ACC,{0x8ACC:'',0x8ACD:'HL = the screen byte, A = the bit for the pixel',0x8AD0:'Z reset if the pixel is set',0x8AD1:'',0x8AD2:''})
C(0x8B09,{0x8B09:'y + 1',0x8B0A:'Past 127?',0x8B0C:'No: return with Z reset',0x8B0E:'Yes: undo it...',0x8B0F:'',0x8B10:'...and return with Z set (A preserved)',0x8B11:'',0x8B12:'',0x8B13:'',0x8B14:'Reset Z (A preserved)',0x8B16:'',0x8B17:''})
C(0x8B2F,{0x8B2F:'Mostly vertical (bit 0 set)?',0x8B31:'Yes',
 0x8B33:'MOSTLY HORIZONTAL:',0x8B34:'',0x8B35:'Plot the pixel',0x8B38:'Leftwards (bit 2)?',0x8B3A:'',0x8B3C:'Step left',0x8B3F:'Stop at the edge',0x8B41:'',
 0x8B43:'Step right',0x8B46:'Stop at the edge',0x8B48:'Time for a vertical step?',0x8B49:'Not yet',0x8B4B:'Downwards (bit 1)?',0x8B4D:'',0x8B4F:'Step down',0x8B52:'Stop at the edge',0x8B54:'',
 0x8B56:'Step up',0x8B59:'Stop at the edge',0x8B5B:'Reload the step counter B',0x8B5C:'',0x8B5D:'One pixel fewer to draw',0x8B5E:'Loop',0x8B60:'',0x8B61:'',0x8B62:'',
 0x8B63:'MOSTLY VERTICAL:',0x8B64:'',0x8B65:'Plot the pixel',0x8B68:'Downwards (bit 1)?',0x8B6A:'',0x8B6C:'Step down',0x8B6F:'Stop at the edge',0x8B71:'',0x8B73:'Step up',0x8B76:'Stop at the edge',
 0x8B78:'Time for a sideways step?',0x8B79:'Not yet',0x8B7B:'Leftwards (bit 2)?',0x8B7D:'',0x8B7F:'Step left',0x8B82:'Stop at the edge',0x8B84:'',0x8B86:'Step right',0x8B89:'Stop at the edge',
 0x8B8B:'Reload the step counter',0x8B8C:'',0x8B8D:'One pixel fewer to draw',0x8B8E:'Loop',0x8B90:'',0x8B91:'',0x8B92:''})
C(0x8B93,{0x8B93:'',0x8B94:'HL = the screen byte, A = the pixel\'s bit',0x8B97:'',0x8B98:'',
 0x8B99:'Work out the attribute address from the screen address',0x8B9A:'',0x8B9C:'',0x8B9D:'',0x8B9E:'',0x8B9F:'',0x8BA1:'',
 0x8BA2:'Keep only the cell\'s paper colour',0x8BA3:'',0x8BA5:'',0x8BA6:'A = the drawing colour, in the paper position',0x8BA9:'',0x8BAA:'',0x8BAB:'',
 0x8BAC:'Same as the paper?',0x8BAD:'',0x8BAF:'Yes: use its complement so it shows',0x8BB1:'Back into the ink position',0x8BB2:'',0x8BB3:'',0x8BB4:'Combine with the paper...',0x8BB5:'...and store it',
 0x8BB6:'',0x8BB7:'A = the pixel\'s bit',0x8BB8:'Set the pixel',0x8BB9:'',0x8BBA:'',0x8BBB:''})
C(0x8BBC,{0x8BBC:'Turn y upside down: row = 127 - y',0x8BBE:'',0x8BBF:'',0x8BC0:'The low three bits of the row are the pixel line within the character...',0x8BC2:'...in the display file at $4000',0x8BC4:'',
 0x8BC5:'Bits 6-7 of the row choose the third of the screen',0x8BC6:'',0x8BC8:'',0x8BC9:'',0x8BCA:'',0x8BCB:'',0x8BCC:'',
 0x8BCD:'Bits 3-5 choose the character row within the third',0x8BCE:'',0x8BD0:'',0x8BD1:'',0x8BD2:'',
 0x8BD3:'x / 8 is the column',0x8BD4:'',0x8BD5:'',0x8BD6:'',0x8BD7:'',0x8BD9:'',0x8BDA:'',
 0x8BDB:'x AND 7 is the bit within the byte',0x8BDC:'',0x8BDE:'',0x8BDF:'',0x8BE0:'',0x8BE1:'Start with bit 0 and rotate right x AND 7 + 1 times, giving $80 for x AND 7 = 0',0x8BE3:'',0x8BE5:'',0x8BE7:'',0x8BE8:''})
C(0x8BE9,{0x8BE9:'Is Bilbo in the dark? (carry set if so)',0x8BEC:'Keep the answer in the alternate AF',0x8BED:'A = the border colour (first byte of the picture)',0x8BF0:'',
 0x8BF2:'',0x8BF3:'Not dark: keep it',0x8BF5:'Dark: black border',0x8BF6:'',0x8BF7:'',0x8BF8:'',0x8BF9:'Set the border',
 0x8BFB:'',0x8BFC:'',0x8BFD:'',0x8BFE:'Clear the top two thirds of the screen ($4000-$4FFF)',0x8C01:'',0x8C04:'',0x8C07:'',0x8C09:'',
 0x8C0B:'512 attributes from $5800',0x8C0E:'',0x8C11:'',0x8C14:'A = the picture\'s colours (second byte)',0x8C17:'',0x8C19:'',0x8C1A:'Not dark: keep them',0x8C1C:'Dark: black on black',0x8C1D:'',0x8C1E:'',0x8C1F:'',
 0x8C20:'Fill the attributes',0x8C21:'',0x8C23:'',0x8C24:'',0x8C25:'',0x8C26:'Not dark?',0x8C27:'Then return and draw the picture',0x8C28:'Dark: discard the return address...',0x8C29:'...and skip the drawing altogether'})

# ---- fight and random numbers
C(0x90DB,{0x90DB:'Check the target is something that can be attacked',0x90DE:'Was a weapon named?',0x90E1:'HL = the word used when there is no weapon',0x90E4:'',0x90E6:'No weapon: skip',
 0x90E8:'IX = the weapon\'s record',0x90EC:'HL = the weapon\'s noun (e.g. SWORD)',0x90EF:'',0x90F2:'Keep it for the report ("...with the sword")',
 0x90F5:'IX = the attacker\'s record',0x90F9:'B = the attacker\'s strength',0x90FC:'Is there a weapon?',0x90FF:'($FF + 1 = 0)',0x9100:'No: attack with strength alone',
 0x9102:'IY = the weapon\'s record',0x9106:'Is it an ordinary object (one place)?',0x9109:'',0x910A:'"you cannot kill with the X"',0x910D:'No: say so and stop',
 0x9110:'A = the weapon\'s strength',0x9113:'Add the attacker\'s strength',0x9114:'No overflow: fine',0x9116:'Overflow: cap it at 255',0x9118:'B = the attack value',
 0x9119:'',0x911A:'Randomise the attack value by about +/-10',0x911D:'',0x911E:'Dry run? Then stop here: the attack would happen',
 0x9121:'IX = the target\'s record',0x9125:'A = the target\'s defence',0x9128:'Randomise it too',0x912B:'Is the defence at least as big as the attack?',
 0x912C:'"but the effort is wasted. his defense is too strong."',0x912F:'Yes: the blow does nothing',
 0x9132:'C = the defence',0x9133:'Defence + 16...',0x9135:'',0x9137:'(capped at 255)',0x9139:'...less than the attack?',0x913A:'Yes: a fatal blow',
 0x913C:'A wound. A = the margin (attack - defence, 1-16)',0x913D:'',0x913E:'Double it to index the wound messages',0x913F:'',0x9140:'',0x9142:'IY = the wound message table',0x9146:'',
 0x9148:'HL = the message for this margin (a margin of 16 runs off the end of the table)',0x914B:'',
 0x914E:'Halve the doubled margin twice with RRCA: margin/2, but with bit 0 rotated into bit 7 (see the bug note)',0x914F:'',0x9150:'B = the "half" margin',
 0x9151:'A = 255 - B',0x9152:'Add the target\'s strength: carry only if strength > B',0x9155:'It would go negative: leave it alone',0x9157:'Otherwise strength = strength - B - 1',
 0x915A:'A = the "half" margin again',0x915B:'Halve it again (RRCA again)',0x915C:'A = 255 - that',0x915D:'Add the target\'s defence',0x9160:'It would go negative: leave it',0x9162:'Otherwise defence = defence - (margin/4) - 1',
 0x9165:'Print the wound message',
 0x9168:'"with one well placed blow <actor> cleaves <his/your> skull."',0x916B:'',0x916E:'Mark the target dead',0x9172:'A = the target',0x9175:'Kill it: drop its things, remove it from the character table',
 0x9178:'Then report "<target> is dead."',0x917A:''})
C(0x917D,{0x917D:'',0x917E:'B = the value to randomise',0x917F:'A random number from -10 to +10...',0x9181:'',0x9184:'...in C',0x9185:'A = value + random number',
 0x9186:'No carry: that is the answer',0x9188:'Carry: assume it overflowed; A = 0...',0x9189:'...is the random number negative?',0x918B:'Yes: return 0. (But adding a negative number always sets the carry, so every negative adjustment gives 0: the bug)',
 0x918D:'Positive: the value really overflowed, so return 255',0x918E:'',0x918F:''})
C(0x9BFD,{0x9BFD:'',0x9BFF:'',0x9C00:'C = the range',0x9C01:'B = twice the range...',0x9C03:'',0x9C05:'...capped at 255',0x9C07:'',
 0x9C08:'Advance the 16-bit counter at $B602-$B603',0x9C0C:'',0x9C0F:'',0x9C11:'',
 0x9C14:'IX = the counter, used as an ADDRESS: it points somewhere in memory',0x9C18:'A = the seed...',0x9C1B:'...plus the byte at that address...',0x9C1E:'(move on by DE, whatever it happens to hold)',0x9C20:'...exclusive-ORed with the byte after',
 0x9C23:'',0x9C24:'',0x9C27:'The same as the previous random number?',0x9C28:'',0x9C29:'Yes: try again',0x9C2B:'Save it as the new seed',
 0x9C2E:'Is it within 0 to 2 x range?',0x9C2F:'',0x9C31:'',0x9C33:'No: halve it and try again (this is what skews the results)',0x9C35:'',
 0x9C38:'Subtract the range to give -range to +range',0x9C39:'',0x9C3A:'',0x9C3C:''})
A[0x9BFD]['desc'].insert(1,"The random bytes come from memory itself. A 16-bit counter at $B602 is increased on every call and used as an address; the byte found there (and one a little further on) is mixed with the previous result. So the program code, the tables and even the ROM serve as the game's random number table, and the R register seed from the start of the game (#R$6C27) decides where the sequence begins. A result equal to the previous one is thrown away.")
fact('randommem','The random numbers come from the program itself',
 "The Hobbit has no random number table. The routine at #R$9BFD walks a counter through memory and mixes the bytes it finds - program code, messages, the ROM - with the previous result. Only the starting point is really random: it is taken from the Z80's R register at the moment the player presses the first key.")

C(0x970B,{0x970B:'Bilbo is the actor...',0x970C:'',0x970F:'...the map has not been read...',0x9712:'...and Gollum is not waiting for an answer',0x9715:'The actor\'s record is Bilbo\'s',0x9718:'',
 0x971B:'Pick a random number from 0 to 4...',0x971D:'',0x9720:'...plus 1: one of the five hidden routes',0x9721:'',0x9722:'IY = the route table',0x9726:'Six bytes per entry',0x9729:'Step to the chosen entry',0x972B:'',
 0x972D:'Write its address into the LD IY instruction in Elrond\'s map routine (#R$A6B8)',0x9731:'HL = the address of the exit in the room record',0x9734:'',
 0x9737:'Blank out its three bytes: the way is closed',0x9739:'',0x973B:'',0x973C:'',
 0x973E:'Pick a random number from 0 to 3...',0x9740:'',0x9743:'...times 4...',0x9744:'',0x9746:'',0x9748:'',0x974A:'...to choose one of the four riddle entries',0x974D:'',0x974E:'Remember it for Gollum',0x9751:''})
A[0x970B]['desc']=["Called at the start of every game. It makes Bilbo the actor and then makes two random choices.",
 "The hidden route: one of five exits listed in the table at #R$C6FD is chosen (a random number 1-5 from #R$9BF4) and blanked out in its room record, so that way is closed. The address of the chosen entry is written into the instruction at $A6C3, where Elrond will need it (#R$A6B8). The candidates are the exits from Beorn's house to the great river, from the forest gate to the bewitched gloomy place, from the treeless opening to the goblins' outside gate, from the long lake to lake town, and from the misty mountain to the narrow place. Because of the way #R$9BF4 works, the first and last are chosen half as often as the others.",
 "Gollum's riddle: one of the four entries at #R$C6EB is chosen (each equally likely) and its address stored at $B5DF (see #R$A7C6)."]
A[0xC6EB]['desc']=["Four 4-byte entries, one of which is chosen at random by #R$970B: the word that answers the riddle, and the address of the riddle. There are only two riddles, each stored twice, so they are equally likely. The code for the hidden routes (#R$970B) counts its entries from $C6F7, so the last riddle entry also serves as that table's never-used entry 0."]
A[0xC6EB]['subs']=[('B',0xC6EB,4,'NIGHT: "it cannot be seen, cannot be felt..."'),('B',0xC6EF,4,'MAN: the riddle of the Sphinx'),('B',0xC6F3,4,'NIGHT'),('B',0xC6F7,4,'MAN'),('B',0xC6FB,2,'Unused')]
import overlay4
overlay4.EXTRA_REGIONS[0xC6EB]=0xC6FD
A.pop(0xC6F7,None); overlay4.EXTRA_REGIONS.pop(0xC6F7,None)
from overlay import blk
blk(0xC6FD,'b','Hidden routes',["Six bytes per entry, one chosen at random by #R$970B: the room, the address of an exit in that room's record, and the three bytes of the exit (direction, door, destination), which are blanked out at the start of the game and restored when Elrond reads the map (#R$A6B8). Terminated by $FF. The code counts entries from $C6F7, six bytes earlier, so the first entry here is number 1."],
 subs=[('B',0xC6FD,6,"Beorn's house: north to the great river"),('B',0xC703,6,'Forest gate: east to the bewitched gloomy place'),('B',0xC709,6,"Treeless opening: west to the goblins' outside gate"),('B',0xC70F,6,'Long lake: east to lake town'),('B',0xC715,6,'Misty mountain: east to the narrow place'),('B',0xC71B,1,'End marker')])
overlay4.EXTRA_REGIONS[0xC6FD]=0xC71C
import overlay3
for i,(k,t,x) in enumerate(overlay3.T):
    if k=='riddles':
        overlay3.T[i]=(k,t,"Gollum asks one of two riddles, chosen at the start of the game (#R$970B). One is the 'dark' riddle from the book ('it cannot be seen, cannot be felt, cannot be heard, cannot be smelt...'), for which the game wants the answer NIGHT. The other is not from The Hobbit at all: it is the riddle of the Sphinx ('which is the animal that has four feet in the morning, two at midday and three in the evening?'), answer MAN. Each is stored twice in a four-entry table (#R$C6EB), so they are equally likely. A wrong answer, or none, gets 'someone strangles you from behind.'")

# ---- events
C(0xA316,{0xA316:'IX = the captive\'s record',0xA31A:'A = the captive\'s side (bits 4-6 of its attributes)',0xA31D:'',0xA31F:'',0xA321:'IX = the captor\'s record',0xA325:'Are they on the same side?',0xA328:'',0xA32A:'Yes: allies do not capture each other',
 0xA32D:'Is the captive alive?',0xA331:'No: you cannot capture a corpse or an object',0xA334:'Who is the captor?',0xA337:'Room 31 (the dark dungeon)...',0xA339:'...for the wood elf...',0xA33B:'',0xA33D:'...or the butler',0xA33F:'',0xA341:'Anyone else: room 13 (the goblins\' dungeon)',
 0xA343:'Dry run? Then stop: the capture would work',0xA346:'IX = the captive\'s record',0xA34A:'Put the captive in the dungeon...',0xA34D:'...free of anything holding it',0xA351:'',0xA354:'...and move everything it carries there too',
 0xA357:'Was the captive Bilbo?',0xA35A:'',0xA35C:'No: done',0xA35D:'Yes: he becomes the actor...',0xA360:'',0xA361:'',0xA364:'',0xA367:'...and the dungeon is described'})
A[0xA4F4]['desc']=["The expiry routine of timer 0, two turns after the barrel is thrown through the trap door into the forest river below the cellar (#R$A4DB). If Bilbo is in the barrel he reads 'you are thrown onto the bank of the long lake.' Everything in the barrel is moved to room 34 on the long lake (#R$9B38) and tipped out there (#R$9CA8), silently. The barrel itself goes back to the cellar (room 32), closed and full, and the wine (object 20) is put back in it. This is the book's escape from the Elvenking's halls, and the game resets it so the barrel is ready again."]
C(0xA4F4,{0xA4F4:'Let other timers expire this turn too',0xA4F5:'',0xA4F8:'Is Bilbo in the barrel (object 19)?',0xA4FB:'',0xA4FD:'"you are thrown onto the bank of the long lake."',0xA500:'If so, say so',
 0xA503:'Put the barrel in room 34, the long lake...',0xA505:'',0xA508:'',0xA509:'...and take everything in it along',0xA50B:'',
 0xA50E:'IX = the barrel\'s record',0xA512:'Put the barrel back in the cellar (room 32)',0xA516:'Closed...',0xA51A:'...and full',
 0xA51E:'Quietly...',0xA51F:'',0xA522:'...tip its contents out on the lake bank',0xA524:'',0xA527:'Output back on',0xA529:'',
 0xA52C:'IY = the wine\'s record',0xA530:'The wine is in the cellar...',0xA534:'...inside the barrel',0xA538:''})
A[0x96DD]['comments']={0x96DD:'Is it Bilbo (object 0)?',0x96DE:'Yes: the game is over',0x96E1:'',0x96E2:'',0x96E4:'',0x96E6:'C = the character',0x96E7:'IX = its record',0x96EA:'Mark it dead',
 0x96EE:'It drops everything it carries',0x96F1:'',0x96F2:'Find it in the character table',0x96F5:'',0x96F7:'',0x96F8:'Not there: skip',0x96FA:'Clear its slot: it will never act again',
 0x96FE:'Its adjective becomes DEAD',0x9701:'',0x9702:'Cancel any orders it was given',0x9705:'',0x9707:'',0x9709:'',0x970A:''}
C(0xA8CA,{0xA8CA:'A = the treasure\'s holder',0xA8CD:'Is it the wooden chest (object 37)?',0xA8CF:'No: the game goes on',
 0xA8D0:'"a cheering crowd of dwarves, hobbits and elves appear..."',0xA8D3:'',0xA8D6:'Print the score and end the game'})
C(0x99FB,{0x99FB:'',0x99FD:'',0x99FF:'IY = the character\'s table entry',0x9A02:'Is it a character?',0x9A04:'No: nothing to do',
 0x9A06:'IX = its reaction table',0x9A09:'',0x9A0C:'',0x9A0D:'',0x9A0F:'A = the action that was done to it',0x9A10:'Is there a reaction to it?',0x9A13:'',0x9A15:'No: carry on as before',
 0x9A17:'Yes: switch its program to the reaction',0x9A1A:'',0x9A1D:'',0x9A20:'',0x9A23:'',0x9A25:'',0x9A27:''})
C(0x99B4,{0x99B4:'A = the range given in the instruction...',0x99B7:'...but no more than the character\'s own limit',0x99BA:'',0x99BC:'',0x99BF:'Pick a random entry number',0x99C2:'',
 0x99C3:'(Entry point with E already set) Make sure it is within the limit',0x99C6:'',0x99C7:'',0x99C9:'',0x99CA:'HL = the reaction table',0x99CD:'',0x99D0:'',
 0x99D2:'Three bytes per entry',0x99D3:'',0x99D4:'',0x99D5:'Skip the action byte',0x99D6:'DE = the program address',0x99D7:'',0x99D8:'',0x99D9:'Make it the character\'s program',0x99DC:'',0x99DF:''})
A[0x9BF4]['desc']=["Returns the absolute value of a random number from -A to A (#R$9BFD). Because of the way #R$9BFD squeezes its random byte into range, the results are not all equally likely: for A=4, 0 and 4 come up half as often as 1, 2 and 3; for A=3 the four results are equally likely; for A=9 the higher numbers are favoured."]

# ---- word printing, verb endings, articles
A[0x74B8]['desc']=["Prints one word from the dictionary, with the right verb ending and with word wrap. On entry DE holds the word reference: the low nibble of D and all of E are the offset from #R$6000, and the high nibble of D holds flags. A reference of zero prints nothing.",
 "The letters are unpacked into a buffer at $749D (five-bit letter codes plus $60 give lower-case ASCII), using the usual end-of-word rule (bit 7, but never in the first two bytes).",
 "VERB ENDINGS. The flag nibble decides whether the verb is to agree with a third-person subject: $50 never, $40 always, $10 if the target is not Bilbo, and anything else if the actor is not Bilbo. So one message can say 'you attack thorin' or 'thorin attacks you'. If an ending is needed and the word allows one (bit 7 of its second byte), the top three bits of its third byte choose an ending from the table at #R$B60F: S, ES, IES, a backspace followed by IES (to turn 'carry' into 'carries'), D, or ING.",
 "WORD WRAP. The length of the word, with its ending, is compared with the room left on the line (at $75A8 in the lower window or $768E in the story window). If it will not fit, a new line is started first, keeping the capital-letter flag. A space is printed before the word unless it starts a line.",
 "Words with flag nibble $70 set the capital-letter flag afterwards, so that the next word starts a sentence."]
C(0x74B8,{0x74B8:'Is the word reference zero?',0x74B9:'',0x74BB:'',0x74BC:'Yes: nothing to print',0x74BD:'',0x74BE:'',0x74BF:'',0x74C0:'C = the flags',
 0x74C1:'DE = the offset...',0x74C2:'',0x74C4:'',0x74C5:'...plus $6000: HL = the word in the dictionary',0x74C8:'',0x74C9:'DE = the letter buffer',0x74CC:'',0x74CD:'B counts the letters',
 0x74CF:'Next letter code',0x74D0:'',0x74D2:'0 (padding): the word has ended',0x74D4:'Count it',0x74D5:'Turn it into a lower-case letter',0x74D7:'Put it in the buffer',0x74D8:'',
 0x74D9:'Was it the last letter (bit 7)?',0x74DB:'',0x74DC:'No: next letter',0x74DE:'Bit 7 in the first two bytes does not count...',0x74DF:'',0x74E1:'',0x74E3:'...and for a two-letter word...',0x74E5:'',
 0x74E7:'...look back at the first byte',0x74E8:'',0x74E9:'',0x74EA:'',0x74EB:'',0x74EC:'',0x74EE:'',
 0x74F0:'HL = the start of the word again',0x74F1:'What does the flag nibble say about verb endings?',0x74F2:'',0x74F4:'$50: never add an ending',0x74F6:'',0x74F8:'$40: always add one',0x74FA:'',
 0x74FC:'$10: add one if the target is not Bilbo',0x74FE:'',0x7501:'',0x7503:'Otherwise: add one if the actor is not Bilbo',0x7506:'Bilbo ("you")?',0x7507:'Yes: no ending',
 0x7509:'Does the word take an ending (bit 7 of its second byte)?',0x750A:'',0x750C:'No',0x750E:'The top three bits of its third byte...',0x750F:'',0x7510:'',0x7512:'...times 4...',0x7513:'',0x7514:'',0x7515:'',0x7516:'',
 0x7518:'...index the table of endings',0x751B:'',0x751C:'Up to four characters',0x751E:'',0x751F:'A 0 ends it',0x7520:'',0x7522:'',0x7523:'Add the character to the word',0x7524:'',0x7525:'',
 0x7527:'B = the length of the word',0x752A:'',0x752B:'',0x752C:'',0x752E:'',
 0x752F:'Lower window or story window?',0x7532:'',0x7533:'',0x7534:'',0x7536:'Story window: is this the start of a line?',0x7539:'',0x753A:'If not, print a space first',0x753C:'',
 0x753F:'',0x7540:'A = the room left on the line (lower window)...',0x7543:'',0x7545:'...or in the story window',0x7548:'',0x754B:'Will the word fit?',0x754C:'Yes',
 0x754E:'No: start a new line, keeping the capital-letter flag',0x754F:'',0x7552:'',
 0x7553:'Does the word end a sentence (flag nibble $70)?',0x7554:'',0x7555:'',0x7557:'',0x7559:'',0x755B:'',0x755D:'Yes: the next word gets a capital',
 0x755E:'Print the letters',0x7561:'',0x7562:'',0x7565:'',0x7566:'',0x7568:'',0x7569:'',0x756A:''})
C(0x7436,{0x7436:'A name (bit 7 of D)?',0x7438:'No: an ordinary noun',0x743A:'Is it YOU ($07AC)?',0x743B:'',0x743E:'',0x743F:'',0x7441:'',0x7442:'',0x7444:'',0x7445:'YOU gets neither an article nor a capital',
 0x7446:'Other names get a capital letter...',0x7448:'...and no article',0x744B:'',
 0x744C:'HL = THE, A, AN, SOME',0x744F:'Is a definite article wanted?',0x7452:'',0x7453:'',0x7456:'',0x7457:'No',0x7459:'Yes: HL = THE, THE, THE, SOME',
 0x745C:'The word\'s flag bits 4-6 choose one of the four',0x745D:'',0x745E:'',0x745F:'',0x7460:'',0x7462:'',0x7463:'',0x7464:'',0x7466:'',0x7467:'DE = the article',0x7468:'',0x7469:'',
 0x746A:'Print it',0x746D:'',0x746E:''})
blk(0xB60F,'t','Verb endings',["Six 4-byte endings added to verbs by #R$74B8 when the subject is not 'you': S, ES, IES, a backspace and IES (the backspace rubs out a final Y: 'carry' becomes 'carries'), D and ING. The rest of the 32 bytes are unused, and are followed by the orders buffer at #R$B628."],
 subs=[('T',0xB60F,1,'S'),('B',0xB610,3,''),('T',0xB613,2,'ES'),('B',0xB615,2,''),('T',0xB617,3,'IES'),('B',0xB61A,1,''),('B',0xB61B,1,'Backspace'),('T',0xB61C,3,'IES'),('T',0xB61F,1,'D'),('B',0xB620,3,''),('T',0xB623,3,'ING'),('B',0xB626,2,'')])
overlay4.EXTRA_REGIONS[0xB60F]=0xB628
fact('verbs','How "you attack" becomes "thorin attacks"',
 "The dictionary stores each verb once, but three bits in each verb say which ending it takes in the third person: S, ES, IES, D, ING, or IES after rubbing out the last letter (#R$74B8, #R$B60F). The message printer adds the ending whenever the subject is not 'you', so a single message serves both 'you attack thorin' and 'thorin attacks you', and 'you carry' and 'gandalf carries'.")

# ---- taking, talking, Thorin, goblins
C(0x8C86,{0x8C86:'IX = the target\'s record',0x8C8A:'A = the weight of everything in the target...',0x8C8D:'',0x8C90:'...plus its own weight',0x8C93:'',0x8C95:'(capped at 255)',0x8C97:'B = the total',
 0x8C98:'IY = the actor\'s record',0x8C9C:'A = how much the actor can lift',0x8C9F:'Can it lift the load?',0x8CA0:'"the X is too heavy to lift."',0x8CA3:'No: say so',
 0x8CA5:'',0x8CA6:'Subtract what the actor is already carrying',0x8CA9:'',0x8CAC:'',0x8CAD:'',0x8CAE:'',0x8CAF:'Still not negative: it can be taken',0x8CB2:'"you are carrying too much."',
 0x8CB5:'Print the message instead of returning...',0x8CB6:'',0x8CB7:'...and stop the action',
 0x8CBA:'Is the target an ordinary object?',0x8CBD:'No (a door, say): it cannot be taken',0x8CBF:'Objects with bit 1 set ("evaporates") can be taken; others...',0x8CC3:'',
 0x8CC4:'',0x8CC5:'...(this path) cannot: report failure'})
C(0x8CC8,{0x8CC8:'Is the actor already holding the target?',0x8CCB:'"you are already carrying the X."',0x8CCE:'Yes: say so',0x8CD1:'Check the weights',0x8CD4:'Dry run? Then stop: it would work',
 0x8CD7:'The actor becomes the target\'s holder',0x8CDA:'',0x8CDD:'Was it the rope (object 18)?',0x8CE0:'',0x8CE2:'No: done',0x8CE3:'Yes: whatever is tied to the rope goes with it',0x8CE6:'',0x8CE9:''})
C(0x8F9E,{0x8F9E:'Dry run? Then stop: talking always works',0x8FA1:'Is the person spoken to a character?',0x8FA4:'',0x8FA7:'',0x8FA9:'(A = 0: no orders to hand over)',0x8FAB:'No: the orders are thrown away',
 0x8FAD:'Is Gollum waiting for his answer?',0x8FB0:'',0x8FB2:'Yes: the words go to him, no refusal',0x8FB4:'A = the character\'s stubbornness',0x8FB7:'',0x8FB9:'0: always obeys',
 0x8FBB:'Otherwise pick a random number from 0 up to the stubbornness',0x8FBE:'',0x8FC0:'0: refuses',0x8FC2:'Hand over the orders (A of them)',0x8FC5:'',
 0x8FC6:'"<character> says "no"."',0x8FC9:'',0x8FCC:'No orders',0x8FCD:''})
A[0x8F9E]['desc']=["Hands the orders collected from a quotation (#R$80CD) to the character being spoken to (#R$88A7). Something that is not a character cannot take orders. A character with a stubbornness value (byte 6 of its entry in #R$C9BA) may refuse: a random number from 0 up to that value is chosen, and 0 means it says \"no\" and the orders are thrown away. Surprisingly, higher values mean fewer refusals (see the description added later)."]
C(0xA550,{0xA550:'Dry run? Then stop: this always works',0xA553:'Pick a random number from 0 to 8',0xA555:'',0xA558:'5 or more...',0xA55A:'...do nothing',
 0xA55B:'3 or 4...',0xA55D:'"thorin waits."',0xA560:'',0xA563:'"get us out of this one, thief!" (never reached: see the bug note)',0xA566:'',
 0xA569:'"thorin sits down and starts singing about gold."',0xA56C:'0?',0xA56E:'',0xA571:'1 or 2: he says "hurry up"',0xA574:''})
A[0xA36A]['desc']=["Chained after the normal ATTACK handler in each goblin's object record (action 15 runs #R$90DB, then this). If the attack killed the goblin, it comes straight back: the dead flag is cleared, its number is written back into its slot in the character table (so it acts again), it is moved to another room and given a new adjective, all from its 6-byte entry in the table at $A3C3. The game prints 'the goblin falls down a hole and vanishes.'",
 "It then means to announce '- another goblin' if the goblin's new room is Bilbo's, but compares Bilbo's room with register B, which this routine never sets; B holds whatever the attack routine left there (the attack value), so the announcement depends on chance."]
C(0xA36A,{0xA36A:'IX = the goblin\'s record',0xA36E:'Did the attack kill it?',0xA372:'No: nothing to do',0xA373:'Bring it back to life',
 0xA377:'Find its entry in the table at $A3C3 (6 bytes each)',0xA37A:'',0xA37E:'',0xA381:'',0xA384:'',0xA386:'',0xA388:'',
 0xA38A:'HL = the entry',0xA38C:'',0xA38D:'DE = its slot in the character table',0xA38E:'',0xA38F:'',0xA390:'',0xA391:'Put the goblin back in the slot: it will act again',
 0xA392:'Move it to its new room',0xA393:'',0xA394:'',0xA397:'Give it a new adjective',0xA398:'',0xA399:'',0xA39C:'',0xA39D:'',0xA39E:'',
 0xA3A1:'"the goblin falls down a hole and vanishes."',0xA3A4:'',0xA3A7:'Is Bilbo in the room it went to? (B is never set here: see above)',0xA3AA:'',0xA3AB:'No',
 0xA3AC:'Print "-"...',0xA3AE:'',0xA3B1:'...ANOTHER...',0xA3B4:'',0xA3B7:'...GOBLIN...',0xA3BA:'',0xA3BD:'...and the rest of the sentence',0xA3C0:''})
bug('goblinB','The "another goblin" announcement uses an unset register',
 "When a dead goblin is sent back into play (#R$A36A), the game checks whether Bilbo is in the room it has been moved to, to announce '- another goblin'. But it compares Bilbo's room with register B, which the routine never loads; B still holds a value left over from the attack routine. The new room had just been loaded into A, so B was presumably meant to hold it.")

# ---- character instructions
C(0x9883,{0x9883:'Move the program pointer past this instruction (and its failure address, if any)',0x9886:'Is it a call to a special routine (bit 0)?',0x988A:'Yes',
 0x988C:'The action...',0x988F:'',0x9892:'...the target...',0x9895:'',0x9898:'...and the instrument',0x989B:'',0x989E:'Try it',0x98A1:'It failed',0x98A3:'It worked',
 0x98A5:'HL = the special routine',0x98A8:'',0x98AB:'Run it first as a dry run: "really do it" off...',0x98AC:'',0x98AF:'...and "would work" off',0x98B2:'',
 0x98B5:'Did it say it would work?',0x98B8:'',0x98BA:'No: it failed',0x98BC:'Yes: run it again for real',0x98BF:'',
 0x98C2:'Success. Is this a once-only instruction (bit 5)?',0x98C6:'No: this character\'s turn is over',0x98C9:'Yes: wipe out its instruction byte',0x98CD:'Turn over'})
C(0x98CF,{0x98CF:'This instruction is 2 bytes long (plus a failure address)',0x98D2:'Move the program pointer past it',0x98D5:'A = the action',0x98D8:'$FF: no action at all?',0x98DA:'Yes',
 0x98DC:'Set the action...',0x98DF:'...with no target or instrument: the game will choose them',0x98E1:'',0x98E4:'',0x98E7:'Try it',0x98EA:'It failed',0x98EC:'It worked: turn over',
 0x98EF:'No action. Is there an address after it (bit 4)?',0x98F3:'No: just end the turn (the character waits)',0x98F6:'Yes: jump there next turn',0x98F9:'',0x98FC:'',0x98FF:'',0x9902:'Turn over',
 0x9905:'FAILURE: count it (six failures end the turn)',0x9908:'',0x9909:'Is there a failure address (bit 4)?',0x990D:'No: go on to the next instruction',
 0x9910:'Yes: fetch it...',0x9912:'',0x9915:'',0x9918:'...make it the program position...',0x991B:'',0x991E:'...and carry on from there, in the same turn'})
A[0x9921]['desc']=["Checks with #R$84E6 whether the action would work; returns with Z set if not. Otherwise the action is reported (#R$7122) and performed (#R$946F), and the routine returns with Z reset.",
 "The report is the tricky part, because Bilbo may be able to see only part of what happens. Actions on rooms, and GO THROUGH by a character that did not start in Bilbo's room, are not reported. If the target is a door (something in two places) and the character is on the other side of it from Bilbo, the report is printed with the actor replaced by $FF, so Bilbo reads 'someone opens the door' - he sees the door open but not who opened it.",
 "Afterwards #R$9A28 prints '<character> enters.' if the character has just come into Bilbo's room, and '<object> appears.' if the target has."]
C(0x9921,{0x9921:'',0x9923:'Would the action work?',0x9926:'No: return with Z set',
 0x9929:'Is the target a room?',0x992C:'',0x992E:'Yes: do it without a report',0x9930:'Is it GO THROUGH (action 30)...',0x9933:'',0x9935:'',
 0x9937:'...by a character that did not start the turn in Bilbo\'s room?',0x993A:'',0x993D:'',0x993E:'Then do it without a report',
 0x9940:'Is there a target?',0x9943:'',0x9945:'No: report normally',0x9947:'A = the target\'s room',0x994A:'(remember it)',0x994D:'Is it in one place?',0x994F:'Yes: report normally',
 0x9951:'A door. C = Bilbo\'s room, B = the character\'s room',0x9955:'',0x9956:'The same room?',0x9957:'Yes: report normally',
 0x9959:'Is Bilbo on one side of the door?',0x995C:'',0x995F:'',0x9961:'',0x9963:'',0x9965:'No: report normally',
 0x9967:'Yes, and the character is on the other side:',0x996A:'',0x996B:'the actor becomes "someone"...',0x996D:'',0x9970:'...output is switched on...',0x9972:'',
 0x9975:'',0x9977:'...and Bilbo reads "someone opens the door"',0x997A:'',0x997C:'Output off again',0x997D:'',0x9980:'Restore the actor',0x9981:'',0x9984:'',
 0x9986:'',0x9988:'Report the action',0x998B:'',0x998D:'Do it',
 0x9990:'Has the character just come into Bilbo\'s room?',0x9993:'',0x9996:'"<character> enters."',0x9999:'',
 0x999C:'Unless the target is a room...',0x999F:'',0x99A1:'',0x99A3:'...has the target just appeared in Bilbo\'s room?',0x99A6:'',0x99A9:'"<object> appears."',0x99AC:'',
 0x99AF:'Return with Z reset: the action worked',0x99B1:'',0x99B3:''})
fact('someone','Seeing only half of what happens',
 "When a character opens or closes a door from the far side, Bilbo can see the door but not the character. The game handles this (#R$9921) by reporting the action with the actor replaced by 'someone': 'someone opens the round green door.'")

# ---- dragon and Bard
C(0xA591,{0xA591:'Is Bilbo in room 39 (the front gate)...',0xA594:'',0xA596:'',0xA598:'...room 44...',0xA59A:'',0xA59C:'...or room 41 (the lower halls)?',0xA59E:'No: nothing happens',
 0xA59F:'Dry run? Then stop: this would work',0xA5A2:'Is the dragon already there?',0xA5A5:'',0xA5A8:'',0xA5A9:'Yes: nothing to do',0xA5AA:'No: the dragon flies to Bilbo\'s room',
 0xA5AB:'Make sure Bilbo sees it',0xA5AD:'',0xA5B0:'Push the dragon\'s name as the message parameter',0xA5B3:'',0xA5B4:'"the dragon enters."',0xA5B7:'Print it',0xA5BA:''})
C(0xA5BB,{0xA5BB:'Is Bilbo in the room where the dragon started its turn?',0xA5BE:'',0xA5C1:'',0xA5C2:'No: nothing to say',0xA5C3:'Dry run? Then stop: this would work',
 0xA5C6:'Is Bilbo visible (bit 7 of his flags; clear while he wears the ring)?',0xA5C9:'',0xA5CB:'"I may not be able to see you thief but I can still burn you. prepare to die"',
 0xA5CE:'Invisible: say that',0xA5D0:'"well thief your cunning has failed you this time. prepare to die"',0xA5D3:'Print it'})
A[0xA5D5]['desc']=["Does nothing while the valuable treasure (location at $C4CC) is still in room 41. Once it has been moved, and if the dragon's current room is lit, a random number from 0 to 100 (#R$9BF4) decides: below 80, 'in the distance you see the shape of a monstrous dragon flying after you.'; otherwise 'the dragon descends and in a terrific spout of flames burns you to a crisp.' and Bilbo dies. Because of the skew in the random numbers (#R$9BFD), the fatal result comes up about 16% of the time, every turn, for as long as the dragon lives."]
C(0xA5D5,{0xA5D5:'Is the treasure still in room 41?',0xA5D8:'',0xA5DA:'Yes: the dragon sleeps on',0xA5DB:'Dry run? Then stop: this would work',0xA5DE:'Make sure Bilbo sees what follows',0xA5E0:'',
 0xA5E3:'IX = the room the dragon (the actor) is in',0xA5E6:'Is it lit?',0xA5EA:'No: nothing happens',0xA5EB:'"in the distance you see the shape of a monstrous dragon flying after you."',
 0xA5EE:'Pick a random number from 0 to 100',0xA5F0:'',0xA5F3:'Below 80?',0xA5F5:'Yes: the dragon is just a shape in the distance',
 0xA5F7:'Otherwise: "the dragon descends and in a terrific spout of flames burns you to a crisp."',0xA5FA:'',0xA5FD:'Bilbo is dead'})
C(0xA79F,{0xA79F:'Has the player given Bard an order?',0xA7A2:'',0xA7A4:'No: nothing to do',0xA7A5:'It is dealt with now',0xA7A6:'',0xA7A9:'',0xA7AA:'Take the order and match it to an action and objects',
 0xA7AD:'It makes no sense: ignore it',0xA7AE:'Do not carry it out now',0xA7AF:'',0xA7B2:'Write the action...',0xA7B5:'...into Bard\'s next instruction at $C8D1...',
 0xA7B8:'...with its target and instrument...',0xA7BC:'',0xA7C0:'...and make it an action instruction that orders cannot interrupt ($42)',0xA7C2:'',0xA7C5:'From now on Bard repeats it every turn'})

# ---- orders
C(0x88A7,{0x88A7:'',0x88A8:'',0x88AA:'',0x88AB:'B = the number of orders the character will take',0x88AC:'C = the number of orders waiting',0x88AF:'',0x88B0:'More wanted than there are?',0x88B1:'',0x88B3:'Then take them all',
 0x88B4:'C = the number left over',0x88B5:'',0x88B6:'',0x88B7:'IX = one slot before the orders buffer',0x88BB:'25 bytes per slot',0x88BE:'Any to hand over?',0x88BF:'',0x88C0:'No',
 0x88C2:'Find the next waiting order (marked $FF)',0x88C4:'',0x88C7:'',0x88C9:'',0x88CB:'Address it to the character',0x88CE:'',0x88D1:'Next',
 0x88D3:'Now the left-over orders:',0x88D4:'',0x88D5:'',0x88D6:'None',0x88D8:'find each one...',0x88DA:'',0x88DD:'',0x88DF:'',0x88E1:'...and throw it away',0x88E5:'',
 0x88E7:'',0x88E8:'',0x88EA:'',0x88EB:''})
C(0x8907,{0x8907:'',0x8909:'',0x890B:'',0x890C:'',0x890D:'',0x890E:'C = 0 to discard the order, 1 to obey it',0x890F:'HL = the actor\'s order slot',0x8912:'Free the slot',0x8914:'HL = the command frame stored in it',
 0x8915:'Discarding?',0x8916:'',0x8917:'No: obey it',0x8919:'Return with Z reset',0x891B:'Return HL (the frame) to the caller',0x891C:'',0x891D:'',0x891E:'',0x891F:'',0x8921:'',0x8923:'',
 0x8924:'IY = the frame',0x8925:'',0x8927:'Pretend to be inside a quotation so nothing is printed',0x8929:'',0x892C:'',0x892F:'',
 0x8930:'Find the action and objects for the order, as if the player had typed it',0x8933:'',0x8934:'Back to normal',0x8935:'',0x8938:'',0x8939:'',0x893C:'',
 0x893D:'It made no sense: give up',0x893F:'Would it work?',0x8942:'Yes: return with Z reset; the character will do it',
 0x8944:'No: the character forgets all its orders',0x8947:'',0x894A:'Return with Z set',0x894B:''})

# ---- describing a room
A[0x958E]['desc']=["Prints the full description of room A. The message used for this is 'you are <preposition> ...' at $AEEE, and before printing it this routine writes the room's preposition - OUTSIDE, INSIDE, IN, ON or AT, chosen by bits 1-3 of the room's first byte from #R$B970 - into the message itself, at $AEEF. So the text of the message is changed each time a room is described. #R$95B9 then does the rest."]
C(0x958E,{0x958E:'',0x958F:'IX = the room\'s record',0x9592:'Bits 1-3 of its flags choose the preposition',0x9595:'',0x9597:'',0x9598:'',
 0x959A:'HL = the table of prepositions',0x959D:'',0x959E:'DE = OUTSIDE, INSIDE, IN, ON or AT',0x959F:'',0x95A0:'',
 0x95A1:'Write it into the message "you are ..." (high byte first)',0x95A4:'',0x95A5:'',0x95A6:'',0x95A7:'',0x95A8:'HL = that message',
 0x95AB:'',0x95AD:'',0x95AF:'',0x95B0:'Describe the room',0x95B3:'',0x95B4:'',0x95B6:'',0x95B8:''})
C(0x95B9,{0x95B9:'B = the room',0x95BA:'IX = its record',0x95BD:'Print "you are in" (or a short heading from the caller)',
 0x95C0:'Does the room have its own description script?',0x95C3:'',0x95C6:'',0x95C7:'',0x95C8:'Print that, or else the room\'s name',
 0x95CB:'Draw its picture, if it has one',0x95CC:'',0x95CF:'Was there a picture?',0x95D2:'',0x95D3:'If so, wait for a key so it can be looked at',
 0x95D6:'New line',0x95D9:'"to the east there is the round green door" and so on',0x95DA:'',0x95DD:'"visible exits are: ..."',0x95DE:'',0x95E1:'Finish with "you see: ..."'})
C(0xA068,{0xA068:'',0xA06A:'',0xA06C:'',0xA06D:'',0xA06E:'IX = the room\'s exits',0xA071:'Find the first exit without a door',0xA074:'None: print nothing',
 0xA076:'"visible exits are :"',0xA079:'',0xA07C:'A = the exit\'s direction',0xA07F:'DE = its word',0xA082:'Print it',0xA085:'Next exit without a door',0xA088:'Loop',
 0xA08A:'New line',0xA08D:'',0xA08E:'',0xA08F:'',0xA091:'',0xA093:''})

# ---- carrying out an action, reach and visibility
C(0x946F,{0x946F:'',0x9470:'',0x9472:'',0x9473:'Does the action make sense (not done to yourself, and so on)?',0x9476:'No: "I cannot do that."',
 0x9479:'Is it too dark for Bilbo to see?',0x947C:'No: carry on',0x947E:'Dark. Can this action be done in the dark anyway?',0x9481:'',0x9482:'No: "I see nothing"',
 0x9484:'Is the target something Bilbo is holding?',0x9487:'No: "I see nothing"',0x9489:'Is the instrument something he is holding?',0x948C:'',0x948F:'Yes: he can manage by touch',
 0x9491:'"I see nothing."',0x9494:'',0x9497:'',
 0x9499:'Is the target a room?',0x949C:'',0x949E:'Yes: straight to the default handler',0x94A1:'Is there a target?',0x94A4:'',0x94A6:'No: straight to the default handler',
 0x94A9:'IX = the target\'s record...',0x94AC:'...which is saved for the handlers',0x94B0:'Is it within the player\'s reach?',0x94B3:'',0x94B6:'No: stop (the reason has been printed)',
 0x94B8:'Is there an instrument?',0x94BB:'',0x94BD:'No: use the target\'s handlers',0x94BF:'Is the instrument a room?',0x94C2:'',0x94C4:'Yes: default handler',
 0x94C6:'IX = the instrument\'s record...',0x94C9:'',0x94CC:'...saved for the handlers',0x94D0:'Is it within reach?',0x94D3:'No: stop',
 0x94D5:'Is this one of the actions the instrument handles (PUT IN, TAKE OUT OF...)?',0x94D8:'Yes: use the instrument\'s handlers (IX is still its record)',
 0x94DA:'Otherwise use the target\'s',0x94DE:'A = the action',0x94E1:'Does the object have its own handler for it?',0x94E4:'No: use the default handler',
 0x94E6:'HL = the handler...',0x94E9:'',0x94EC:'...run it',0x94EF:'Next entry in the list',0x94F1:'',0x94F3:'',0x94F5:'Is it action 0 (a chained handler)?',0x94F6:'',0x94F9:'Yes: run that too',
 0x94FB:'Did the action really happen?',0x94FE:'',0x9500:'No: done',0x9502:'Was it the player?',0x9505:'',0x9507:'No: skip',
 0x9509:'If the player is in the dark, add "it is dark."',0x950C:'',
 0x950F:'B = the action',0x9512:'',0x9513:'Let the target react (a character that was attacked, say)',0x9516:'',0x951A:'',0x951D:'Let the instrument react too',0x9520:'',0x9524:'',
 0x9527:'',0x9528:'',0x952A:'',0x952B:'',
 0x952C:'DEFAULT HANDLER: look the action up in #R$C61F',0x952F:'',0x9533:'',0x9536:'Found?',0x9538:'Yes: run it',0x953A:'No: "I cannot do that."',0x953D:''})
A[0x9686]['desc']=["Stops the player using something that another character is holding. Characters are not subject to this check, and neither are objects that nobody is holding or that Bilbo himself is holding (directly or inside something he carries).",
 "If object A is held by a living character, and Bilbo is visible, the game says, for example, 'gandalf is carrying the curious map.' and returns with Z reset: the action is not allowed. But if Bilbo is invisible - wearing the ring clears bit 7 of his flags - the check is skipped, and he can take things straight out of other characters' hands."]
C(0x9686,{0x9686:'Nothing at all?',0x9688:'Then there is nothing to check',0x9689:'',0x968B:'',0x968D:'',0x968E:'B = the object',0x968F:'Is the actor Bilbo?',0x9692:'',0x9694:'Yes: check',
 0x9696:'A character: always allowed (Z set)',0x9697:'',0x9699:'',0x969A:'IX = the object\'s record',0x969D:'Is anyone holding it?',0x96A0:'',0x96A2:'No: allowed',
 0x96A4:'',0x96A5:'IY = the object\'s record',0x96A7:'',0x96A9:'Is Bilbo holding it (perhaps inside something)?',0x96AC:'Yes: allowed',
 0x96AE:'IX = the holder\'s record',0x96B1:'Is the holder a living character?',0x96B5:'No (a box, a table): allowed',
 0x96B7:'Is Bilbo visible?',0x96BA:'',0x96BC:'No - he is wearing the ring: allowed',
 0x96BE:'Push the object\'s name...',0x96C1:'',0x96C4:'',0x96C5:'...and the holder\'s',0x96C8:'',0x96CB:'',0x96CC:'"gandalf is carrying the curious map."',0x96CF:'',0x96D2:'Not allowed: return with Z reset',
 0x96D4:'',0x96D5:'',0x96D7:'',0x96D9:''})
fact('ringtheft','The ring makes Bilbo a real burglar',
 "Normally, trying to take something a character is holding gets 'gandalf is carrying the curious map.' But the check (#R$9686) only applies while Bilbo is visible. With the ring on he is not, and he can simply take things out of other characters' hands. In the emulator, with the sword given to Gandalf, 'take sword' is refused normally, but with Bilbo invisible gives 'you take the short strong sword.' - and Thorin asks 'where's the thief?'.")
A[0x9D92]['desc']=["Returns with Z reset if the object at IY is visible (bit 7 of its flags) and is in the same place as the object at IX.",
 "Each object's outermost holder is found with #R$9DC8, which returns $FF for an object lying loose in a room and 0 for one that is shut inside something (or held by a living character). If the results differ, the objects are not together. If both are loose, IX's room must be one of IY's locations. If both are 0 the room comparison is skipped and they count as together - a shortcut that assumes they are in the same container."]
C(0x9D92,{0x9D92:'Is the IY object visible at all?',0x9D96:'No: return with Z set',0x9D97:'',0x9D99:'',0x9D9B:'',0x9D9C:'C = the IX object\'s room',0x9D9F:'',
 0x9DA1:'Where is the IY object ultimately?',0x9DA4:'',0x9DA5:'',0x9DA7:'Where is the IX object ultimately?',0x9DAA:'The same answer?',0x9DAB:'No: not together',
 0x9DAD:'Both shut inside something ($00)?',0x9DAE:'Then count them as together',0x9DB0:'Both loose: is the IX object\'s room one of the IY object\'s locations?',0x9DB3:'',0x9DB4:'',0x9DB7:'Yes: together',0x9DB9:'',0x9DBB:'',
 0x9DBD:'Not together: Z set',0x9DBE:'',0x9DC0:'Together: Z reset',0x9DC2:'',0x9DC3:'',0x9DC5:'',0x9DC7:''})
A[0x9DC8]['desc']=["Follows the chain of holders of the object at IX upwards, as long as each holder is open (bit 5) or dead (bit 3): you can see into an open box or a dead character's pockets. Returns $FF if the chain ends with the object (or an open container holding it) loose in a room, and 0 if it ends at a closed container or a living character."]
C(0x9DC8,{0x9DC8:'',0x9DCA:'A = the holder',0x9DCD:'Nobody?',0x9DCF:'Then the object is loose: return $FF',0x9DD1:'IX = the holder\'s record',0x9DD4:'Is the holder open or dead?',0x9DD7:'',0x9DD9:'Yes: see through it and look at its holder',0x9DDB:'No: return 0 (shut in)',0x9DDD:''})
C(0x9CA8,{0x9CA8:'',0x9CAA:'',0x9CAC:'',0x9CAD:'IX = the object\'s record',0x9CB0:'B = its holder: its things will belong to that',0x9CB3:'Go through every object',0x9CB7:'Next object',0x9CBA:'End of the list',
 0x9CBC:'Is it held by this object?',0x9CBF:'No: next',0x9CC1:'Does it evaporate (bit 1)?',0x9CC5:'No: pass it on',0x9CC7:'',0x9CC8:'Yes: it goes nowhere...',0x9CCC:'...belongs to nobody...',0x9CD0:'...and is invisible',
 0x9CD4:'Print its name',0x9CD7:'"evaporates."',0x9CDA:'',0x9CDD:'',0x9CDE:'Next',0x9CE0:'Give it to the object\'s own holder',0x9CE3:'Next',0x9CE6:'',0x9CE7:'',0x9CE9:'',0x9CEB:''})
C(0x8C45,{0x8C45:'Is the actor carrying it? (If not, "you are not carrying it.")',0x8C48:'Dry run? Then stop: it would work',0x8C4B:'IX = the object\'s record',0x8C4F:'Is it tied to the rope (object 18)?',0x8C52:'',0x8C54:'No',
 0x8C56:'Yes: it is the rope that gets dropped',0x8C5A:'Nobody holds it now: it lies in the room',0x8C5E:'Does it evaporate?',0x8C62:'No: done',0x8C63:'Yes: it goes nowhere',
 0x8C67:'"<object> evaporates."',0x8C6A:'Push the object\'s name as the parameter',0x8C6D:'',0x8C6F:'',0x8C71:'',0x8C74:''})
C(0xA0BC,{0xA0BC:'',0xA0BE:'IX = the object\'s record',0xA0C1:'Remove the second adjective',0xA0C5:'',0xA0C9:'The first adjective becomes BROKEN...',0xA0CC:'...unless it is a living thing (bit 6)...',0xA0D0:'',
 0xA0D2:'...which becomes DEAD',0xA0D5:'',0xA0D8:'',0xA0DB:'',0xA0DD:''})

# ---- room-entry handlers explained
A[0xC693]['title']="Room-entry handler: Beorn's house (room 22) wakes the butler"
A[0xC693]['desc']=["Not every character is active from the start. The butler (object 66) begins the game in the Elvenking's cellar (room 32), invisible (bit 7 of his flags clear), and his slot in the character table at $C9D6 holds 0, so #R$976C passes him by and he does nothing at all.",
 "The first time Bilbo walks into Beorn's house - roughly half way through the journey - this handler switches him on: his object number $42 is written into that slot, which already holds the address of his behaviour program ($C83F) and reaction table ($C835), and he is made visible. From then on he goes about his business in the cellar every turn (unlocking and locking the red door, drinking wine, throwing barrels through the trap door, capturing intruders; see #R$C71C), so that by the time Bilbo arrives in the Elvenking's halls the butler is already at work.",
 "If the butler has been killed (bit 3 of his flags), nothing happens. Because the slot is simply overwritten, entering Beorn's house again later does no harm: it writes the same value again."]
A[0xC693]['comments']={0xC693:'HL = the butler\'s flags',0xC696:'Is the butler dead?',0xC698:'Yes: leave him be',
 0xC699:'Put the butler (object 66) into his empty slot in the character table...',0xC69B:'...so that from now on he acts every turn',0xC69E:'...and make him visible',0xC6A0:''}

blk(0xC6AF,'c','',[])
A[0xC6AF]['title']="Room-entry handler: the Elvenking's cellar (room 32) wakes the dragon and Bard"
A[0xC6AF]['desc']=["Entering the cellar where the king keeps his barrels of wine brings the last part of the adventure to life. Three things happen:",
 "#LIST { Timer 9 (#R$C9B2) is started with a count of 3. This is the timer that controls the side door of the Lonely Mountain (object 11), far away in room 42: it makes 'a loud crack and a hole appears about three feet from the ground' for one turn in every five (#R$A985), after which 'the hole vanishes' (#R$A968), unless it has been opened. The count of 3 means the first appearance happens two turns after Bilbo enters the cellar. } { The dragon (object 60) is switched on by writing its number, $3C, into its empty slot in the character table at $C9F2 - unless it is already dead. Until now the dragon has been lying inert in the lower halls; from now on its behaviour program (#R$A5D5, #R$A591, #R$A5BB) runs every turn. } { Bard (object 70) is switched on in the same way, by writing $46 into the slot at $C9EB, unless he is dead. He starts waiting for orders (#R$A79F). } LIST#",
 "So the dragon cannot threaten Bilbo, and Bard cannot help him, until Bilbo has reached the Elvenking's cellar. Like the butler's handler (#R$C693), this runs every time Bilbo enters the cellar, restarting the side door timer at 3 each time."]
A[0xC6AF]['comments']={0xC6AF:'Start timer 9 (the Lonely Mountain\'s side door)...',0xC6B1:'...with a count of 3',0xC6B4:'HL = the dragon\'s flags',0xC6B7:'Is the dragon dead?',0xC6B9:'Yes: skip',
 0xC6BB:'Put the dragon (object 60) into its empty character-table slot...',0xC6BD:'...so it starts acting',0xC6C0:'HL = Bard\'s flags',0xC6C3:'Is Bard dead?',0xC6C5:'Yes: done',
 0xC6C6:'Put Bard (object 70) into his empty slot...',0xC6C8:'...so he starts waiting for orders',0xC6CB:''}

blk(0xC6D9,'c','',[])
A[0xC6D9]['title']='Room-entry handler: the forest river (room 33) - only in a barrel'
A[0xC6D9]['desc']=["The forest river outside the Elvenking's halls, reached by going down through the trap door in the cellar, is only survivable in a barrel. If Bilbo enters it any other way - for example by jumping through the trap door on his own - the room is described and then 'you are swept forcefully against the portcullis.', and he dies.",
 "If he is inside the barrel (object 19 is his holder), nothing happens here: he floats on, and two turns after the trap door was opened the barrel timer (#R$A4F4) carries him out onto the bank of the long lake. This is the book's escape in the barrels, turned into a rule you cannot get round."]
A[0xC6D9]['comments']={0xC6D9:'A = whatever is holding Bilbo',0xC6DC:'Is he inside the barrel (object 19)?',0xC6DE:'Yes: he is safe',
 0xC6DF:'No: first describe the river (so he sees where he is)...',0xC6E2:'"you are swept forcefully against the portcullis."',0xC6E5:'',0xC6E8:'...and Bilbo is dead'}

fact('dormant','Some characters sleep until you get near',
 "The butler, the dragon and Bard are not active at the start of the game: their slots in the character table (#R$C9BA) are empty. The butler is switched on when Bilbo first enters Beorn's house (#R$C693); the dragon and Bard when he enters the Elvenking's cellar (#R$C6AF). Until then they simply lie where they are, which is why the dragon never comes looking for Bilbo early in the game.")
fact('barrelonly','The forest river kills anyone not in a barrel',
 "Room 33, the forest river below the Elvenking's trap door, has an entry handler (#R$C6D9) that kills Bilbo - 'you are swept forcefully against the portcullis' - unless he arrives inside the barrel.")
fact('sidedoor','The side door only appears one turn in five',
 "Once Bilbo has been in the Elvenking's cellar, timer 9 makes the side door of the Lonely Mountain appear with 'a loud crack' for one turn (#R$A985) and then vanish again (#R$A968), every five turns, unless it has been opened in the meantime. Closing it again hides it and restarts the cycle (#R$A996). The HELP message there is simply 'wait a while.'")

from overlay4 import code
code(0xA968,0xA985,'Timer 9 expires: the side door vanishes',[
 "The expiry routine of timer 9 (#R$C9B2). If the side door of the Lonely Mountain (object 11, flags at $C1AB) has been opened, nothing happens and the timer stops: the door stays. Otherwise the timer is restarted at its reload value (5), the door is made invisible, and if Bilbo is at the side door (room 42) he reads 'the hole vanishes.'"])
C(0xA968,{0xA968:'HL = the side door\'s flags',0xA96B:'Has it been opened?',0xA96D:'Yes: it stays open and visible; the timer stops',0xA96E:'No: restart the timer (count = 5)',0xA971:'',
 0xA974:'',0xA977:'Make the door invisible',0xA979:'Is Bilbo at the side door (room 42)?',0xA97C:'',0xA97E:'No: done',0xA97F:'"the hole vanishes."',0xA982:''})
code(0xA985,0xA996,'Timer 9 tick: the side door appears',[
 "The tick routine of timer 9, run when its count is down to 1. The side door is made visible, and if Bilbo is in room 42 he reads 'there is a loud crack and a hole appears about three feet from the ground. you are standing in front of the side door to the lonely mountain.' Next turn the timer expires (#R$A968), and unless Bilbo has opened the door by then, it vanishes again."])
C(0xA985,{0xA985:'HL = the side door\'s flags',0xA988:'Make it visible',0xA98A:'Is Bilbo at the side door (room 42)?',0xA98D:'',0xA98F:'No: done',0xA990:'"there is a loud crack and a hole appears about three feet from the ground..."',0xA993:''})
code(0xA996,0xA9A7,'Handler for the side door: closing it',[
 "Chained after the normal CLOSE handler in the side door's record. When the door is really closed, it is locked again (bit 0), made invisible, and timer 9 is restarted with a count of 6; 'the hole vanishes.' is printed (via #R$A97F). So closing the side door puts it back into its appear-and-vanish cycle."])
C(0xA996,{0xA996:'Only if the door is really being closed',0xA999:'Restart timer 9 with a count of 6',0xA99B:'',0xA99E:'HL = the side door\'s flags',0xA9A1:'Lock it',0xA9A3:'Hide it',0xA9A5:'"the hole vanishes."'})
A[0xC973]['subs']=[x if x[1]!=0xC9B2 else ('B',0xC9B2,7,'Timer 9: the side door of the Lonely Mountain (started in room 32)') for x in A[0xC973]['subs']]

# ---- the timers
from overlay4 import code
A[0xC973]['desc']=["Ten 7-byte entries processed at the end of every turn by #R$9611, terminated by $FF. Each entry is: a reload value (copied into the count to start the timer), the count (0 = not running), the address of an 'expire' routine (run when the count reaches 0), a threshold, and the address of a 'tick' routine (run on each turn that the count is between 1 and the threshold; 0 = none). Only one timer may expire per turn.",
 "Every timer gives a delayed consequence to something the player did:",
 "#TABLE(default) { =h Timer | =h Started by | =h Runs for | =h What happens } "
 "{ 0 | the barrel is thrown through the trap door into the forest river (#R$A4DB) | 2 turns | the barrel floats off to the long lake with whatever is in it (#R$A4F4) } "
 "{ 1 | breaking the spider web (#R$A2A7) | 2 turns | 'some spiders start mending the broken web'; the web is whole again and twice as strong (#R$A950) } "
 "{ 2 | entering the place of black spiders, room 26 (#R$C6A1) | the turn of arrival and 3 more | if Bilbo is still there, 'the spider web is slowly smothering you' and he dies (#R$AA04) } "
 "{ 3 | opening the goblins' door from the goblins' big cavern (#R$A3E7) | 2 turns | the door closes by itself (#R$A400) } "
 "{ 4 | entering the deep bog, room 29 (#R$C6A8) | 1 turn | 'you are slowly sinking into the bog', and Bilbo dies (#R$A69E) } "
 "{ 5 | examining the magic door while invisible (#R$A614) | 4 turns | the door opens, 'an elf sweeps past', the ring comes off (#R$A9A7); next turn the door closes (#R$A9C9) } "
 "{ 6 | putting the ring on (#R$A2C0) | 2-10 turns, random | the ring comes off by itself (#R$A9D4) } "
 "{ 7 | drinking the wine (#R$A9ED) | 5 turns | Bilbo sobers up (#R$A9FF) } "
 "{ 8 | entering the forest road or forest, rooms 2 and 3 (#R$C6CC) | 4 turns | the pale bulbous eyes (#R$AA13, #R$AA2E) } "
 "{ 9 | entering the Elvenking's cellar (#R$C6AF), and closing the side door (#R$A996) | repeats every 5 turns | the side door of the Lonely Mountain appears for a turn and vanishes again (#R$A985, #R$A968) } TABLE#"]
A[0xC973]['subs']=[('B',0xC973,7,'Timer 0: the barrel floats away'),('B',0xC97A,7,'Timer 1: the spiders mend their web'),('B',0xC981,7,'Timer 2: smothered in the spiders\' place'),('B',0xC988,7,'Timer 3: the goblins\' door closes'),('B',0xC98F,7,'Timer 4: sinking in the bog'),('B',0xC996,7,'Timer 5: the magic door and the elf'),('B',0xC99D,7,'Timer 6: the ring wears off'),('B',0xC9A4,7,'Timer 7: drunkenness wears off'),('B',0xC9AB,7,'Timer 8: the pale bulbous eyes'),('B',0xC9B2,7,'Timer 9: the side door appears and vanishes'),('B',0xC9B9,1,'End marker')]

blk(0xC6A1,'c','',[])
A[0xC6A1]['title']="Room-entry handler: the place of black spiders (room 26) starts timer 2"
A[0xC6A1]['desc']=["Starts timer 2 (count 5). If Bilbo is still in room 26 when it runs out, the spiders' web smothers him (#R$AA04). The HELP message there is 'don't stay too long.'"]
C(0xC6A1,{0xC6A1:'Timer 2\'s reload value (5)...',0xC6A4:'...becomes its count: the timer starts',0xC6A7:''})
blk(0xC6A8,'c','',[])
A[0xC6A8]['title']="Room-entry handler: the deep bog (room 29) starts timer 4"
A[0xC6A8]['desc']=["Starts timer 4 (count 2). Its threshold is also 2, so at the end of the very turn Bilbo steps into the bog, the count drops to 1 and the tick routine (#R$A69E) runs: he is 'slowly sinking into the bog', and dies. The deep bog is simply a death trap - the way to deal with it is not to go in."]
C(0xC6A8,{0xC6A8:'Timer 4\'s reload value (2)...',0xC6AB:'...becomes its count: the timer starts',0xC6AE:''})

code(0xA69E,0xA6B8,'Timer 4: sinking into the bog',[
 "Both the tick and the expire routine of timer 4 (#R$C6A8). If Bilbo is in the deep bog (room 29) the timer is stopped (count 0). Then '<actor> is slowly sinking into the bog.' is printed, and if the count is now 0, Bilbo dies.",
 "In practice the tick runs at the end of the turn Bilbo entered the bog, while he is still there, so it always kills him. The other path - printing the message but surviving because the count is still 1 - would only be taken if he had somehow left within the same turn. (The message is printed even then, although he is no longer in the bog.)"])
C(0xA69E,{0xA69E:'Is Bilbo in the deep bog (room 29)?',0xA6A1:'',0xA6A3:'No: just print the message',0xA6A5:'Yes: stop the timer (count 0)',0xA6A6:'',0xA6A9:'"you are slowly sinking into the bog."',0xA6AC:'',
 0xA6AF:'Is the count 0?',0xA6B2:'',0xA6B4:'No: he survives this turn',0xA6B5:'Yes: Bilbo is dead'})
code(0xAA04,0xAA13,'Timer 2 expires: smothered by the spiders',["The expiry routine of timer 2, five turns after Bilbo entered the place of black spiders (#R$C6A1). If he is still there (room 26): 'the spider web is slowly smothering you', and he dies. If he has left, nothing happens."])
C(0xAA04,{0xAA04:'Is Bilbo still in the spiders\' place (room 26)?',0xAA07:'',0xAA09:'No: he got away',0xAA0A:'"the spider web is slowly smothering you"',0xAA0D:'',0xAA10:'Bilbo is dead'})
code(0xA2A7,0xA2C0,'Handler for the spider web: it has been broken',[
 "Chained after the spider web's handler for breaking it (the web is object 7). If the web really is broken now (bit 3 of its flags), it is opened (bit 5), so the way through is clear, and timer 1 is started (count 2): 'some spiders start mending the broken web.' Two turns later #R$A950 closes it again."])
C(0xA2A7,{0xA2A7:'IX = the web\'s record',0xA2AB:'Is it broken?',0xA2AF:'No: nothing to do',0xA2B0:'Yes: it no longer blocks the way',0xA2B4:'Start timer 1 (count 2)',0xA2B7:'',0xA2BA:'"some spiders start mending the broken web."',0xA2BD:''})
code(0xA950,0xA968,'Timer 1 expires: the web is mended',[
 "Two turns after the spider web was broken (#R$A2A7) the spiders have mended it: it is no longer broken, it is closed again (blocking the way), its strength is doubled, and its first adjective is set back to SPIDER (it had become BROKEN, #R$A0BC).",
 "Doubling uses SLA, which drops the top bit: the web starts with strength 64, so the first mending makes it 128, and the second makes it 0."])
C(0xA950,{0xA950:'IX = the spider web\'s record',0xA954:'Not broken any more',0xA958:'Closed again',0xA95C:'Twice as strong (64, then 128, then 0)',0xA960:'Its adjective is SPIDER again...',0xA963:'...instead of BROKEN',0xA967:''})
bug('webstrength','The mended spider web\'s strength overflows',
 "Each time the spiders mend their web (#R$A950), its strength (byte 5 of its record) is doubled with SLA. It starts at 64, so after one mending it is 128 and after a second it is 0, because the bit shifted out is simply lost. The idea was presumably that the web gets tougher each time.")
code(0xA3E7,0xA400,"Handler for the goblins' door: OPEN",["The goblins' door (object 17) can only be opened by someone in the goblins' big cavern (room 16), in other words from the inside; from anywhere else the attempt fails (#R$9EBF). It is then opened as usual (#R$9078) and timer 3 is started, so two turns later it shuts itself (#R$A400)."])
C(0xA3E7,{0xA3E7:'IX = the actor\'s record',0xA3EB:'Is the actor in the goblins\' big cavern (room 16)?',0xA3EE:'',0xA3F0:'No: it cannot be opened from this side',0xA3F3:'Open it',0xA3F6:'Only if it really happened...',0xA3F9:'...start timer 3 (count 2)',0xA3FC:'',0xA3FF:''})
code(0xA400,0xA406,"Timer 3 expires: the goblins' door closes",["Two turns after it was opened (#R$A3E7), the goblins' door closes itself."])
C(0xA400,{0xA400:'HL = the goblins\' door\'s flags',0xA403:'Close it',0xA405:''})
code(0xA2C0,0xA2EC,'Handler for the ring: WEAR',[
 "Putting the golden ring on makes the wearer invisible (bit 7 of their flags cleared) - but also divides their strength by 4. The ring itself becomes invisible and held by the wearer, and timer 6 is started with a random count of 2 to 10 (#R$9BF4), after which the ring comes off by itself (#R$A9D4)."])
C(0xA2C0,{0xA2C0:'Dry run? Then stop: it would work',0xA2C3:'IY = the wearer\'s record',0xA2C7:'IX = the ring\'s record',0xA2CB:'The wearer becomes invisible...',0xA2CF:'...and a quarter as strong',0xA2D3:'',
 0xA2D7:'The ring vanishes from view...',0xA2DB:'...into the wearer\'s hand',0xA2DE:'',0xA2E1:'Pick a random number from 0 to 8...',0xA2E3:'',0xA2E6:'...plus 2...',0xA2E8:'...and start timer 6 with it',0xA2EB:''})
code(0xA2EC,0xA316,'Handler for the ring: TAKE OFF',[
 "Taking the ring off (also done automatically when timer 6 runs out, #R$A9D4). If the ring is visible it is not being worn: '<actor> is not wearing the ring.' Otherwise the ring and its wearer become visible again, the wearer's strength is multiplied by 4, and timer 6 is stopped.",
 "Because putting the ring on divided the strength by 4 with SRL and taking it off multiplies it by 4 with SLA, the two lowest bits are lost each time: a strength of 74, for example, comes back as 72. Each use of the ring can cost Bilbo up to 3 points of strength."])
C(0xA2EC,{0xA2EC:'IX = the wearer\'s record',0xA2F0:'IY = the ring\'s record',0xA2F4:'Is the ring visible (not being worn)?',0xA2F8:'"you are not wearing the ring."',0xA2FB:'Yes: say so',
 0xA2FE:'Dry run? Then stop: it would work',0xA301:'The ring can be seen again...',0xA305:'...and so can the wearer...',0xA309:'...whose strength is multiplied by 4 (the bottom two bits lost on the way in are gone)',0xA30D:'',
 0xA311:'Stop timer 6',0xA312:'',0xA315:''})
fact('ring','The ring has a price',
 "Wearing the golden ring (#R$A2C0) makes Bilbo invisible, but it also divides his strength by 4 - not the moment to pick a fight. It comes off by itself after a random 2 to 10 turns (timer 6, #R$A9D4), and taking it off multiplies his strength by 4 again (#R$A2EC). Because the division throws away the remainder, each use can cost him up to 3 points of strength for good.")
code(0xA9A7,0xA9BB,'Timer 5 tick: the magic door opens and an elf sweeps past',[
 "Timer 5 is started when an invisible Bilbo examines the magic door (#R$A614: 'the magic door warns of elves approaching'). When its count reaches 1, the magic door (object 13) opens, and if Bilbo is in room 28 or 30 he sees 'the magic door opens.' and 'an elf sweeps past.' Then the ring check of timer 6 is run (#R$A9D4), which takes the ring off anyone wearing it."])
C(0xA9A7,{0xA9A7:'HL = the magic door\'s flags',0xA9AA:'Open it',0xA9AC:'"the magic door opens."',0xA9AF:'Print it if Bilbo is nearby',0xA9B2:'"an elf sweeps past."',0xA9B5:'',0xA9B8:'Take the ring off whoever is wearing it'})
code(0xA9BB,0xA9C9,'Print a message if Bilbo is near the magic door',["Prints the message at HL if Bilbo is in room 30 or room 28, the rooms on either side of the magic door."])
C(0xA9BB,{0xA9BB:'Is Bilbo in room 30...',0xA9BE:'',0xA9C0:'...then print it',0xA9C3:'...or room 28?',0xA9C5:'...then print it',0xA9C8:'Otherwise say nothing'})
code(0xA9C9,0xA9D4,'Timer 5 expires: the magic door closes',["The turn after the elf has swept past, the magic door closes again ('the magic door closes.', if Bilbo is near)."])
C(0xA9C9,{0xA9C9:'HL = the magic door\'s flags',0xA9CC:'Close it',0xA9CE:'"the magic door closes."',0xA9D1:'Print it if Bilbo is nearby'})
code(0xA9D4,0xA9ED,'Timer 6 expires: the ring comes off',["When timer 6 (started by #R$A2C0) runs out, whoever holds the golden ring becomes the actor and, if the ring is still being worn (it is invisible), it is taken off (#R$A2EC). If nobody holds the ring, nothing happens."])
C(0xA9D4,{0xA9D4:'IX = the ring\'s record',0xA9D8:'Who holds it?',0xA9DB:'',0xA9DD:'Nobody: nothing to do',0xA9DE:'IX = the holder\'s record...',0xA9E1:'...who becomes the actor',
 0xA9E5:'Is the ring being worn (invisible)?',0xA9E9:'Yes: take it off',0xA9EC:''})

A[0xA26A]['desc']=["Shared by the LOCK and UNLOCK handlers of the locked doors; on entry B is the object number of the key that fits (for example 15, the red key, from #R$A264).",
 "If the instrument is that key, the door is locked or unlocked (#R$93CD, #R$93ED). If the instrument is one of the game's other keys - object 2 (the small curious key), object 4 (the large key) or object 15 (the red key) - the game says 'the key does not fit this lock.' Anything else, such as trying to unlock a door with the sword, gets 'I cannot do that.'"]
C(0xA26A,{0xA26A:'A = the object being used as the key',0xA26D:'Is it the key that fits this door?',0xA26E:'No: see what it is',
 0xA270:'Yes. Is the action LOCK (action 37)?',0xA273:'',0xA275:'Yes: lock the door',0xA278:'No: unlock it',
 0xA27B:'Is the object the small curious key (object 2)...',0xA27D:'',0xA27F:'...the large key (object 4)...',0xA281:'',0xA283:'...or the red key (object 15)?',0xA285:'None of these: "I cannot do that."',
 0xA288:'A key, but the wrong one: "the key does not fit this lock."',0xA28B:''})
C(0xA264,{0xA264:'The red key (object 15) is the one that fits the red door',0xA266:''})
