# Batch 13: purpose-level line comments for the object/room/table utility
# routines and the remaining action handlers, in response to a request to
# make every comment explain WHY, in terms a non-programmer can follow,
# rather than just WHAT the instruction does.
from overlay import A
from overlay9 import C

# ---------------------------------------------------------------- utilities
C(0x9B0C,{
 0x9B0C:'Is the room number 80 or higher (not a real room)?',
 0x9B0E:'No, it is a real room: go and find its record',
 0x9B10:'Not a real room: return 0, with Z set, so the caller knows there is no such room',
 0x9B11:'',
 0x9B12:'Save DE for the caller',
 0x9B13:'HL will point into the room pointer table, which starts here',
 0x9B16:'Save HL for the caller',
 0x9B17:'HL = the room number...',
 0x9B18:'',
 0x9B1A:'...doubled, because each room has a 2-byte entry in the table',
 0x9B1B:'HL = the address of this room\'s entry in the pointer table',
 0x9B1C:'DE = the room\'s record address, read from the table (low byte)...',
 0x9B1D:'',
 0x9B1E:'...then the high byte',
 0x9B1F:'Move that address onto the stack for a moment...',
 0x9B20:'...so it can be popped straight into IX, the register the rest of the game expects a room record in',
 0x9B22:'Restore the caller\'s HL',
 0x9B23:'Restore the caller\'s DE',
 0x9B24:''})

C(0x9B25,{
 0x9B25:'IX = the start of the object index, the master list of every object and its record address',
 0x9B29:'Search the index for object A',
 0x9B2C:'Save HL for a moment',
 0x9B2D:'HL = the object\'s record address, read from the matching entry (low byte)...',
 0x9B30:'...then the high byte',
 0x9B33:'Swap it onto the stack in place of the saved HL, so the address can be...',
 0x9B34:'...popped straight into IX, the register the rest of the game expects an object record in',
 0x9B36:''})

C(0x9D12,{
 0x9D12:'Switch to the alternate registers, so this search does not disturb the caller\'s own BC, DE and HL',
 0x9D13:'HL = the table to search, taken from IX',
 0x9D15:'',
 0x9D16:'B = the key being searched for',
 0x9D17:'DE = 3: the size of one entry, ready for stepping through the table',
 0x9D19:'',
 0x9D1B:'A = this entry\'s key',
 0x9D1C:'Does it match what we are looking for?',
 0x9D1D:'Yes: stop here, with this entry found',
 0x9D1F:'No: is this the table\'s $FF terminator, meaning there are no more entries?',
 0x9D21:'Yes: stop here too, empty-handed',
 0x9D23:'Neither: move on to the next entry',
 0x9D24:'...and keep looking',
 0x9D27:'Whichever way we stopped, move the address we ended up at into IX...',
 0x9D28:'...for the caller to use',
 0x9D2A:'Was that the $FF terminator (not found), or a genuine entry (found)? Z ends up SET when NOT found, so the caller should test NZ, or the carry flag, for success',
 0x9D2C:'Switch back to the caller\'s own registers',
 0x9D2D:''})

C(0x9ADC,{
 0x9ADC:'Save DE for the caller',
 0x9ADD:'D = the action we are looking for a handler for',
 0x9ADE:'A = the number of locations this object has (1 for most things, 2 for a door)...',
 0x9AE1:'...plus 16, the size of the record\'s fixed part: this gives the offset, from the start of the record, to where its own list of action handlers begins',
 0x9AE3:'E = that offset',
 0x9AE4:'D = the action again...',
 0x9AE5:'',
 0x9AE7:'IX = the start of this object\'s own list of handlers',
 0x9AE9:'Search that list for the action (see #R$9D12: NZ or carry set means found)',
 0x9AEC:'Restore the caller\'s DE',
 0x9AED:''})

C(0x9AC7,{
 0x9AC7:'Save every register the routine we are about to call might disturb...',
 0x9AC9:'',
 0x9ACB:'',
 0x9ACC:'',
 0x9ACD:'...including HL itself, which holds the address to call',
 0x9ACE:'Is that address 0, meaning "there is nothing to call"?',
 0x9ACF:'',
 0x9AD0:'If it is not 0, make the call',
 0x9AD3:'Restore the registers, in the same order they were saved...',
 0x9AD4:'',
 0x9AD5:'',
 0x9AD6:'',
 0x9AD8:'',
 0x9ADA:''})

C(0x9C99,{
 0x9C99:'Is this action really happening, or is it only being tried out to see if it would work?',
 0x9C9C:'',
 0x9C9E:'Really happening: carry on with the rest of the routine as normal',
 0x9C9F:'Only a trial: record that it would succeed...',
 0x9CA0:'',
 0x9CA3:'...then throw away the return address of whoever called us, so control passes back one level further, skipping the part of the routine that would actually change anything',
 0x9CA4:''})

C(0x9BCD,{
 0x9BCD:'A = the target of the current command',
 0x9BD0:'HL = the address holding the current actor\'s number',
 0x9BD3:'Is there no target at all ($FF)?',
 0x9BD5:'If so, treat that as "yes, held" (set the carry flag), since there is nothing to fail the test',
 0x9BD6:'',
 0x9BD7:'Save the caller\'s IX',
 0x9BD9:'Is the target held, directly or indirectly, by whichever object\'s number is stored at HL?',
 0x9BDC:'Restore the caller\'s IX',
 0x9BDE:''})

C(0x9BDF,{
 0x9BDF:'IX = object A\'s own record',
 0x9BE2:'Save the object\'s number for later',
 0x9BE3:'A = whoever (or whatever) is holding it',
 0x9BE6:'Is it held by nobody at all?',
 0x9BE8:'Yes: it cannot be inside the thing we are looking for',
 0x9BEA:'No: throw away the saved object number from the stack (using IX only because it is a spare place to put it; A itself, still holding the holder\'s number, is untouched)',
 0x9BEC:'Is that holder the very thing we are testing against (the byte stored at HL)?',
 0x9BED:'Not yet: look inside the holder in turn, in case the object is nested more than one level deep',
 0x9BEF:'Found it: set the carry flag to say so',
 0x9BF0:'',
 0x9BF1:'Not held by anybody: restore the stack (the AF we saved earlier)',
 0x9BF2:'Clear the carry flag: not inside',
 0x9BF3:''})

C(0x9BF4,{
 0x9BF4:'Get a random number from -A to +A',
 0x9BF7:'Is it negative (bit 7 set)?',
 0x9BF9:'No: a positive result is fine as it is',
 0x9BFA:'Yes: make it positive, since this routine only ever wants a number from 0 upwards',
 0x9BFC:''})

C(0x9C3D,{0x9C3D:'TOTAL SIZE: save the caller\'s BC',0x9C3E:'B=1 tells the shared routine below to add up sizes rather than weights',0x9C40:'Join the weight routine, which does the actual work'})
C(0x9C42,{0x9C42:'TOTAL WEIGHT: save the caller\'s BC',0x9C43:'B=0 tells the shared routine below to add up weights',
 0x9C45:'Save the caller\'s IX and IY, which the search below will use',0x9C47:'',
 0x9C49:'C will be the running total, starting at 0',0x9C4B:'Add up everything object A holds',
 0x9C4E:'A = the finished total',0x9C4F:'Restore the caller\'s IY and IX',0x9C51:'',0x9C53:'Restore the caller\'s BC',0x9C54:''})

C(0x9C55,{
 0x9C55:'Save the caller\'s IX',
 0x9C57:'IX = the start of the object index, ready to look at every object in the game in turn',
 0x9C5B:'Look at the next object: IY = its own record',
 0x9C5E:'Have we run out of objects (reached the index\'s terminator)?',
 0x9C60:'No: is THIS object held by the one whose contents we are adding up?',
 0x9C63:'It is not: move on and look at the next object',
 0x9C65:'It is: save the object we are adding up for a moment (it is not disturbed by anything above)',
 0x9C66:'Are we totalling weight (B=0) or size (B=1)?',
 0x9C67:'',
 0x9C68:'A = the running total so far',
 0x9C69:'Weight wanted: add this object\'s own weight instead (skip down)',
 0x9C6B:'Size wanted: add this object\'s own size (byte 2 of its record)',
 0x9C6E:'Did that go past 255? Then the whole total is unknowable - give up',
 0x9C71:'Otherwise keep the new, larger running total',
 0x9C72:'...and go on to look inside this object too, in case it holds anything itself',
 0x9C74:'Weight wanted: add this object\'s own weight (byte 3 of its record)',
 0x9C77:'Did that go past 255? Then the whole total is unknowable - give up',
 0x9C7A:'Otherwise keep the new, larger running total',
 0x9C7B:'A = the object we just added in, so we can look inside it as well',
 0x9C7E:'Recursively add up whatever THAT object holds, in case it is itself a container',
 0x9C81:'Restore the object we are totalling up (saved earlier)',
 0x9C82:'Go back and look for more objects held by it',
 0x9C84:'No more objects anywhere: restore the caller\'s IX',
 0x9C86:'',
 0x9C87:'OVERFLOW: throw away the object number we had saved',
 0x9C88:'The total becomes $FF, meaning "too big to say exactly"',
 0x9C8A:'Finish as normal'})

C(0x9C8C,{
 0x9C8C:'Save AF, so this can be used freely without upsetting the caller\'s flags',
 0x9C8D:'IX = the current actor\'s own record',
 0x9C91:'A = the actor\'s location (the first location byte of their record)',
 0x9C94:'IX = that room\'s own record',
 0x9C97:'Restore AF',
 0x9C98:''})

C(0x9CA5,{0x9CA5:'A = the target of the current command (falls straight into #R$9CA8, which drops everything object A holds)'})

C(0x9CEC,{
 0x9CEC:'Save the caller\'s IX, IY and BC',
 0x9CEE:'',
 0x9CF0:'',
 0x9CF1:'B will be the running count, starting at 0',
 0x9CF3:'IX = just before the start of the object index, so the first search below lands on its very first entry',
 0x9CF7:'Look at the next object; IY = its own record',
 0x9CFA:'Have we run out of objects?',
 0x9CFC:'No: is this object held by the one whose contents we are counting?',
 0x9CFF:'It is not: try the next one',
 0x9D01:'It is: is it visible (not, say, a locked-away thing nobody can see)?',
 0x9D05:'No: do not count it',
 0x9D07:'Yes: one more to the count',
 0x9D08:'Look for more',
 0x9D0B:'A = the final count',
 0x9D0C:'Restore the caller\'s IY and BC',
 0x9D0F:'Restore the caller\'s IX',
 0x9D11:''})

C(0x9D2E,{
 0x9D2E:'Save the caller\'s BC, DE and IY',
 0x9D2F:'',
 0x9D30:'',
 0x9D32:'IY = the current actor\'s own record',
 0x9D36:'D = the actor\'s room, in case the object must be close by to count',
 0x9D39:'A = the filter the caller wants: 0 things that are not characters, 1 characters, 2 anything at all',
 0x9D3C:'E = that filter, kept for the tests below',
 0x9D3D:'Look at the next entry of the object index; A = its object number, Z set once we run out',
 0x9D40:'No more objects: give up (A is left holding $FF)',
 0x9D42:'Does the caller want absolutely anything (filter 2)?',
 0x9D44:'',
 0x9D45:'Yes: skip the character/object test below entirely',
 0x9D47:'No: A = this object\'s flags',
 0x9D4A:'Keep only whether it is alive and whether it is dead',
 0x9D4C:'Is it alive and NOT dead, i.e. a proper living character?',
 0x9D4E:'Assume it is not a character (0)...',
 0x9D50:'...unless it just proved to be alive and undead, in which case...',
 0x9D52:'...it counts as a character (1)',
 0x9D53:'Does that match what the caller asked for?',
 0x9D54:'No: try the next object',
 0x9D56:'BC = 8: the offset, from the start of an object\'s record, to its own four word slots',
 0x9D59:'Save IY (the object\'s record) for a moment',
 0x9D5B:'IY = the object\'s word slots',
 0x9D5D:'Do the noun and adjectives at HL match this object\'s own words?',
 0x9D60:'Restore IY, the object\'s record',
 0x9D62:'No match: try the next object',
 0x9D64:'A match on words. Does this particular action not care whether the object is within reach?',
 0x9D67:'',
 0x9D68:'It does not care: accept this object regardless of where it is',
 0x9D6A:'It does care: is the object near the actor?',
 0x9D6D:'No: try the next object',
 0x9D6F:'A = the object we settled on (or $FF if we ran right out)',
 0x9D72:'Restore the caller\'s IY, DE and BC',
 0x9D74:'',
 0x9D75:'',
 0x9D76:''})

C(0x9D77,{
 0x9D77:'Swap IX and IY over, so that whichever object was "the one being looked at" (IY) becomes "the one doing the looking" (IX), and vice versa',
 0x9D7A:'Now test whether the two are in the same place, with them the right way round for that test',
 0x9D7D:'(This same code, reused: falling in here after the test above swaps IX and IY straight back again, and its own RET then returns from this whole routine)',
 0x9D7F:'',
 0x9D81:'',
 0x9D83:'',
 0x9D85:''})

C(0x9D86,{
 0x9D86:'Save the caller\'s IX',
 0x9D88:'IX = the current actor\'s own record',
 0x9D8C:'Is the object at IY in the same place as the actor?',
 0x9D8F:'Restore the caller\'s IX',
 0x9D91:''})

C(0x9DDE,{
 0x9DDE:'Save the caller\'s DE',
 0x9DDF:'IX = the current actor\'s room\'s own record',
 0x9DE2:'A room\'s list of exits starts 7 bytes into its record',
 0x9DE5:'',
 0x9DE7:'Restore the caller\'s DE',
 0x9DE8:''})

C(0x9DE9,{
 0x9DE9:'Save the caller\'s IY and DE',
 0x9DEB:'',
 0x9DEC:'DE = 2: the offset, from the start of a room\'s record, to its own name words',
 0x9DEF:'Look at the next exit of the actor\'s room; A = its direction, Z set once there are no more',
 0x9DF2:'No more exits to try: give up',
 0x9DF4:'A = this exit\'s destination room',
 0x9DF7:'Save the exit-table pointer for a moment',
 0x9DF9:'IX = the destination room\'s own record',
 0x9DFC:'Copy that into IY as well...',
 0x9DFE:'',
 0x9E00:'...then restore IX, back to the exit we are examining',
 0x9E02:'IY = the destination room\'s name words',
 0x9E04:'Do the noun and adjectives at HL match that room\'s name?',
 0x9E07:'No: try the next exit',
 0x9E09:'Yes: A = this exit\'s destination room, the answer we want',
 0x9E0C:'Restore the caller\'s DE and IY',
 0x9E0D:'',
 0x9E0F:''})

C(0x9E10,{
 0x9E10:'Save the caller\'s IY and DE',
 0x9E12:'',
 0x9E13:'An object\'s own word slots start 8 bytes into its record',
 0x9E16:'',
 0x9E18:'Print the noun and its adjectives',
 0x9E1B:'Restore the caller\'s DE and IY',
 0x9E1C:'',
 0x9E1E:''})

C(0x9E1F,{
 0x9E1F:'Save AF and DE',
 0x9E20:'',
 0x9E21:'Does the caller want an article before the whole phrase (rather than before each adjective)?',
 0x9E24:'',
 0x9E26:'Yes: skip straight to printing the noun with its article',
 0x9E28:'No: DE = the first adjective, if there is one',
 0x9E2B:'',
 0x9E2E:'Print its article ("a curious ...")',
 0x9E31:'DE = the first adjective word itself',
 0x9E34:'',
 0x9E37:'Print it',
 0x9E3A:'DE = the second adjective, if there is one',
 0x9E3D:'',
 0x9E40:'Print it (an empty slot simply prints nothing)',
 0x9E43:'DE = the noun',
 0x9E46:'',
 0x9E49:'Is there actually a noun here at all?',
 0x9E4A:'',
 0x9E4B:'If so, print it (with an article too, if the caller asked for one before the whole phrase)',
 0x9E4E:'Restore DE and AF',
 0x9E4F:'',
 0x9E50:''})

C(0x9E51,{
 0x9E51:'Save the caller\'s BC and IY',
 0x9E52:'',
 0x9E54:'B = the direction we are looking for',
 0x9E55:'IX = the start of the actor\'s room\'s exits',
 0x9E58:'Look at the next exit; A = its direction, Z set once there are no more',
 0x9E5B:'No more exits: give up (A is left holding $FF)',
 0x9E5D:'Does this exit actually lead anywhere?',
 0x9E60:'',
 0x9E61:'No destination (a dead end): skip it and keep looking',
 0x9E63:'A = this exit\'s direction',
 0x9E66:'Is it the one we want?',
 0x9E67:'No: try the next exit',
 0x9E6A:'Found it (or ran out): restore the caller\'s IY and BC',
 0x9E6C:'',
 0x9E6D:''})

C(0x9E6E,{0x9E6E:'A = the target of the current command (a door, window or river; falls into #R$9E71, which finds the room\'s exit through it)'})
C(0x9E71,{0x9E71:'FIND EXIT THROUGH A DOOR: save AF',0x9E72:'1 picks out an exit\'s DOOR byte for the shared code below',0x9E74:'Join it'})
C(0x9E76,{
 0x9E76:'FIND EXIT TO A ROOM: save AF',
 0x9E77:'2 picks out an exit\'s DESTINATION byte instead',
 0x9E79:'Poke that choice into the instruction below, so the very same code can compare either byte depending on which entry point was used',
 0x9E7C:'Restore AF',
 0x9E7D:'Save the caller\'s BC and IY',
 0x9E7E:'',
 0x9E80:'B = the door (or destination room) we are looking for',
 0x9E81:'IX = the start of the actor\'s room\'s exits',
 0x9E84:'Look at the next exit; Z set once there are no more',
 0x9E87:'No more exits: give up',
 0x9E89:'A = this exit\'s door, or its destination, whichever this call was asked to check',
 0x9E8C:'Does it match?',
 0x9E8D:'No: try the next exit',
 0x9E8F:'Found it (or ran out): restore the caller\'s IY and BC',
 0x9E91:'',
 0x9E92:''})

C(0x9E93,{
 0x9E93:'DE = the target\'s own record address',
 0x9E97:'IY = the instrument\'s own record address',
 0x9E9B:'The instrument\'s record becomes the new "target"...',
 0x9E9F:'...and the target\'s record becomes the new "instrument"',
 0x9EA3:'BC = the current target and instrument object numbers (C=target, B=instrument)',
 0x9EA7:'A = the instrument\'s number...',
 0x9EA8:'...which becomes the new target',
 0x9EAB:'A = the (old) target\'s number...',
 0x9EAC:'...which becomes the new instrument',
 0x9EAF:'Run the handler, with the two swapped over as far as it can tell',
 0x9EB2:'Put the target and instrument numbers back exactly as they were',
 0x9EB6:'Put the target and instrument records back too',
 0x9EBA:'',
 0x9EBE:''})

C(0x9EBF,{
 0x9EBF:'Is this action really happening (not just being tried out)?',
 0x9EC2:'',
 0x9EC3:'Yes: report it as an outright failure ("you cannot ...")',
 0x9EC6:'Only a trial: just note that it would not have worked, without printing anything',
 0x9EC7:'',
 0x9ECA:''})

C(0x9ECB,{
 0x9ECB:'Is there no object at all ($FF)?',
 0x9ECD:'If so, there is no room to report either',
 0x9ECE:'IX = the object\'s own record',
 0x9ED1:'Does it occupy just one place (an ordinary object, not a door or the like)?',
 0x9ED3:'',
 0x9ED6:'Assume not: return $FF, meaning "no single room"',
 0x9ED8:'',
 0x9ED9:'It does: A = its one location, the answer',
 0x9EDC:''})

C(0x9EDD,{
 0x9EDD:'Save the caller\'s IY, AF and BC',
 0x9EDF:'',
 0x9EE0:'',
 0x9EE1:'"you see :"',
 0x9EE4:'',
 0x9EE7:'A = $FF, meaning "held by nobody", i.e. lying loose in the room',
 0x9EE9:'IY = the actor\'s own record',
 0x9EED:'B = the actor\'s room',
 0x9EF0:'List everything lying loose there',
 0x9EF3:'Restore the caller\'s BC, AF and IY',
 0x9EF4:'',
 0x9EF5:'',
 0x9EF7:''})

C(0x9EF8,{
 0x9EF8:'Save the caller\'s IY, DE and BC',
 0x9EFA:'',
 0x9EFB:'',
 0x9EFC:'C will count how many things get printed',
 0x9EFE:'D = 4, meaning "no indent yet", since this is a fresh list rather than something nested inside another',
 0x9F00:'List the objects, updating the count in C as it goes',
 0x9F03:'Was anything at all printed?',
 0x9F04:'',
 0x9F05:'"      nothing"',
 0x9F08:'If nothing was printed, say so',
 0x9F0B:'Restore the caller\'s BC, DE and IY',
 0x9F0C:'',
 0x9F0D:'',
 0x9F0F:''})

C(0x9F10,{
 0x9F10:'Save the caller\'s HL',
 0x9F11:'L = the holder we are listing the contents of (or $FF for "lying loose")',
 0x9F12:'A = whatever indent is currently in use, from an earlier, outer call to this same routine',
 0x9F15:'H = that old indent, kept alongside the holder in L for a moment',
 0x9F16:'A = the new indent this call should use',
 0x9F17:'Set it as the printer\'s current indent',
 0x9F1A:'A = the holder again',
 0x9F1B:'Swap: put (old indent, holder) safely on the stack, and get the real, original HL back',
 0x9F1C:'Save the caller\'s IX',
 0x9F1E:'IX = just before the start of the object index, so the search below starts at its very first entry',
 0x9F22:'Look at the next object; IY = its own record',
 0x9F25:'Have we run out of objects?',
 0x9F27:'No: is this object held by the one we are listing the contents of?',
 0x9F2A:'It is not: try the next object',
 0x9F2C:'It is: save this object\'s number for a moment',
 0x9F2D:'Does it occupy only a single place (not a door or the like)?',
 0x9F2F:'',
 0x9F32:'No: doors and similar things are never listed as "contents"',
 0x9F34:'A = this object\'s own room',
 0x9F37:'Is it really in the room we are listing (rather than, say, tucked inside something else there)?',
 0x9F38:'No: skip it',
 0x9F3A:'Is the current actor the very object whose contents we are printing...',
 0x9F3D:'',
 0x9F40:'...(if not, always list it - this next check is only about the actor\'s own belongings)',
 0x9F42:'...and is this the outermost call, not one nested inside a container?',
 0x9F44:'',
 0x9F45:'Both true: this is the actor\'s own possession, and the room listing should not repeat it - skip it',
 0x9F47:'Otherwise: can the actor actually see this object (is it close enough)?',
 0x9F4A:'No: skip it',
 0x9F4C:'Yes: count it',
 0x9F4D:'No forced capital letter for this printing...',
 0x9F4E:'',
 0x9F51:'...and no article added before the whole name',
 0x9F54:'Print the object\'s name',
 0x9F57:'Are we listing what the CURRENT ACTOR is carrying (rather than something else)?',
 0x9F5A:'',
 0x9F5D:'If so, no full stop is wanted here - the actor\'s own heading handles that separately',
 0x9F5F:'Otherwise print a full stop...',
 0x9F61:'',
 0x9F64:'A = the object just printed',
 0x9F67:'Print the heading for whatever IT holds ("X is carrying", "in the Y there is") - and find out whether it has anything worth listing',
 0x9F6A:'Nothing to list inside it (or it is closed): do not recurse',
 0x9F6C:'A = the object again',
 0x9F6F:'Save the indent (D) for a moment',
 0x9F70:'Indent two spaces further in, for its own contents...',
 0x9F71:'',
 0x9F72:'...and list them, calling this same routine again',
 0x9F75:'Restore the indent',
 0x9F76:'Restore the object\'s number',
 0x9F77:'Try the next object in the index',
 0x9F7A:'(Top-level listing: just a new line, with no full stop)',
 0x9F7D:'',
 0x9F7F:'Out of objects: restore the caller\'s IX',
 0x9F81:'Recover the (old indent, holder) pair saved earlier, putting the real HL safely back on the stack',
 0x9F82:'Restore the caller\'s own indent...',
 0x9F83:'',
 0x9F86:'...(A is left holding the holder, though nothing further uses it)',
 0x9F87:'Restore the caller\'s real HL',
 0x9F88:''})

C(0x9F89,{
 0x9F89:'Save the caller\'s IX, BC and DE',
 0x9F8B:'',
 0x9F8C:'',
 0x9F8D:'C = the object whose contents we are about to introduce',
 0x9F8E:'IX = its own record',
 0x9F91:'A = its flags',
 0x9F94:'Keep only whether it is closed and whether it is dead',
 0x9F96:'Neither closed-and-alive nor dead: nothing worth a heading (an ordinary open container falls through here fine; this only stops things that are shut away)',
 0x9F98:'A = the object again',
 0x9F99:'How many visible things does it hold?',
 0x9F9C:'',
 0x9F9E:'None at all: no heading needed either',
 0x9FA0:'Is it a living character?',
 0x9FA4:'No: use the ordinary IN/ON/BEHIND/UNDER/TIED-TO wording instead',
 0x9FA6:'Yes: push its own number as the message parameter...',
 0x9FA7:'',
 0x9FA8:'..."X is carrying"',
 0x9FAB:'Skip the ordinary wording below',
 0x9FAD:'"is"',
 0x9FB0:'Is there only a single thing inside (so "is" is right rather than "are")?',
 0x9FB1:'',
 0x9FB3:'More than one: "are" instead',
 0x9FB6:'Push IS or ARE as a message parameter',
 0x9FB7:'HL = the object\'s own words (so the heading can name it: "in the chest")...',
 0x9FBA:'',
 0x9FBD:'',
 0x9FBF:'',
 0x9FC0:'...pushed as another message parameter',
 0x9FC1:'HL = the shared IN/ON/BEHIND/UNDER/TIED-TO message',
 0x9FC4:'A = the object\'s attribute byte, whose low bits say how its contents should be introduced',
 0x9FC7:'Shift that containment word up...',
 0x9FC8:'',
 0x9FC9:'...into an index, since each choice of wording is 4 bytes further into the message',
 0x9FCB:'',
 0x9FCC:'',
 0x9FCE:'HL = the exact wording for this object\'s own containment style',
 0x9FCF:'Print the whole heading',
 0x9FD2:'Clear the carry flag: there is something to list after all',
 0x9FD3:'Restore the caller\'s DE, BC and IX',
 0x9FD4:'',
 0x9FD5:'',
 0x9FD7:'',
 0x9FD8:'Nothing worth a heading: just move to a new line',
 0x9FDB:'Set the carry flag: there is nothing to list',
 0x9FDC:'Join the shared ending above'})

C(0x9FDE,{
 0x9FDE:'IX = room A\'s own record',
 0x9FE1:'A room\'s exits start 7 bytes into its record',
 0x9FE4:'',
 0x9FE6:'BC = 3: the size of one exit, ready for the caller to step through them',
 0x9FE9:''})

C(0x9FEA,{
 0x9FEA:'HL = the table of direction words',
 0x9FED:'E = the direction (1-10)...',
 0x9FEE:'...with any stray extra bit cleared',
 0x9FF0:'',
 0x9FF2:'HL = this direction\'s own entry...',
 0x9FF3:'...doubled, since each word reference is 2 bytes',
 0x9FF4:'DE = the word, read from the table (low byte)...',
 0x9FF5:'',
 0x9FF6:'...then the high byte',
 0x9FF7:''})

C(0x9FF8,{
 0x9FF8:'Save the caller\'s BC, DE, IY and IX',
 0x9FF9:'',
 0x9FFA:'',
 0x9FFC:'',
 0x9FFE:'IX = the start of room A\'s exits, BC = 3 (the size of each one)',
 0xA001:'Step back one exit\'s width, so the loop below lands on the very first exit the first time round',
 0xA003:'IY will be the loop\'s own pointer, a copy of IX',
 0xA005:'',
 0xA007:'Is this the very first exit (guards against a room with no exits at all)?',
 0xA008:'',
 0xA00B:'It is: there is nothing to describe yet, so skip straight to moving on',
 0xA00D:'A = this exit\'s door object',
 0xA010:'IX = the door\'s own record',
 0xA013:'Is the door visible?',
 0xA017:'No: say nothing about it and move on',
 0xA019:'DE = 8: the offset, from the start of a record, to an object\'s own words',
 0xA01C:'IX = the door\'s own words',
 0xA01E:'Save that for a moment',
 0xA020:'A = this exit\'s direction',
 0xA023:'DE = the word for that direction',
 0xA026:'Is the direction UP or DOWN (9 or 10)?',
 0xA028:'No: use the ordinary "to the <direction> there is" wording',
 0xA02A:'"above"',
 0xA02D:'It was UP: use that word',
 0xA02F:'"below"',
 0xA032:'It was DOWN: use that word instead',
 0xA034:'"to the <direction> there is"',
 0xA037:'',
 0xA03A:'Print the direction word (or "above"/"below")',
 0xA03D:'"the <door>."',
 0xA040:'Print it, naming the door',
 0xA043:'Move on to the next exit',
 0xA045:'Have we reached the end of the exits?',
 0xA047:'',
 0xA04A:'Not yet: look at this next one',
 0xA04D:'Finished: restore the caller\'s IX, IY, DE and BC',
 0xA04F:'',
 0xA051:'',
 0xA052:'',
 0xA053:''})

C(0xA054,{
 0xA054:'Move on to the next exit',
 0xA056:'Have we reached the end of the exits?',
 0xA058:'',
 0xA05B:'Yes: give up',
 0xA05C:'Does this exit have a door?',
 0xA05D:'',
 0xA060:'It does: it is not a "visible" exit in the sense wanted here, so skip it',
 0xA062:'Does it even have a direction at all?',
 0xA065:'No direction (an unused slot): skip that too',
 0xA067:'Found a plain, doorless exit'})

C(0xA094,{0xA094:'INSTRUMENT VERSION: HL = the instrument\'s own words...',0xA097:'',0xA09A:'Join the shared code below'})
C(0xA09C,{
 0xA09C:'TARGET VERSION: HL = the target\'s own words...',
 0xA09F:'',
 0xA0A2:'Save the caller\'s DE',
 0xA0A3:'Push the object\'s own words, so the message below can name it',
 0xA0A4:'HL = the wording for a CLEAR flag (unlocked, empty, off, closed, dead)...',
 0xA0A7:'...unless the state we were given says the flag is actually SET...',
 0xA0A9:'',
 0xA0AB:'...in which case use the SET wording instead (locked, full, broken, on, open, alive)',
 0xA0AE:'DE = the exact word for this particular state',
 0xA0B1:'Recover the object\'s own words for a moment...',
 0xA0B2:'...push the state word first...',
 0xA0B3:'...then the object\'s words back on top of it, in the order the message needs them',
 0xA0B4:'"the X is Y."',
 0xA0B7:'Print it',
 0xA0BA:'Restore the caller\'s DE',
 0xA0BB:''})

C(0xA100,{
 0xA100:'Save the caller\'s HL and BC',
 0xA101:'',
 0xA102:'Five actions to check against',
 0xA104:'HL = the list of actions that use the instrument\'s own handlers, rather than the target\'s',
 0xA107:'A = the action being carried out right now',
 0xA10A:'Is it one of these five?',
 0xA10B:'Yes: stop here, with it found',
 0xA10D:'No: look at the next one in the list',
 0xA10E:'',
 0xA110:'Restore the caller\'s BC and HL',
 0xA111:'',
 0xA112:''})

C(0xA113,{
 0xA113:'Save the caller\'s HL',
 0xA114:'\'<actor> says "\'',
 0xA117:'',
 0xA11A:'Restore HL: the message to be spoken',
 0xA11B:'Force a capital letter, as if this were starting a fresh sentence',
 0xA11D:'',
 0xA120:'Print what is being said',
 0xA123:'\'"\' (the closing quote and a full stop)',
 0xA126:''})

C(0xA129,{
 0xA129:'IX = the target\'s own record',
 0xA12D:'Is it locked?',
 0xA131:'A = the state code for LOCKED/UNLOCKED, in case the caller needs to report it',
 0xA133:'Locked: return with Z reset, telling the caller it cannot be used yet',
 0xA134:'Not locked: is it open?',
 0xA138:'A = the state code for OPEN/CLOSED, in case the caller needs to report it',
 0xA13A:'Z reflects whether it is open'})

# ---------------------------------------------------------------- action handlers
C(0x8C2D,{
 0x8C2D:'Dry run? Then stop here: LOOK always works',
 0x8C30:'IX = the current actor\'s own record',
 0x8C34:'A = the actor\'s own room',
 0x8C37:'Describe that room, in full'})

C(0x8C3A,{
 0x8C3A:'Is the target held by the current actor?',
 0x8C3D:'Yes: carry on with whatever the caller wanted to do next',
 0x8C3E:'No: throw away the caller\'s own return address...',
 0x8C3F:'..."you are not carrying it."',
 0x8C42:'...and print that instead, ending the action here'})

C(0x8C75,{
 0x8C75:'A = the target of the current command',
 0x8C78:'HL = the address holding the instrument (the container we are meant to take it out of)',
 0x8C7B:'Is the target actually inside that container? (reuses the tail of #R$9BCD, comparing against whatever holder number sits at HL)',
 0x8C7E:'"the X is not in the Y."',
 0x8C81:'If it is not inside, say so and stop',
 0x8C84:'Otherwise take it just like an ordinary TAKE (joins the rest of #R$8CC8)'})

C(0x9078,{
 0x9078:'Is the target locked, or already open?',
 0x907B:'If either, explain why it cannot be opened ("the door is locked."/"the chest is open.")',
 0x907E:'Dry run? Then stop here: it would work',
 0x9081:'Open it',
 0x9085:'Is the target an ordinary, single-place object (not a door, which needs no further reply)?',
 0x9088:'',
 0x9089:'A door: nothing more to say',
 0x908A:'An ordinary container: does it hold anything visible?',
 0x908D:'',
 0x9090:'',
 0x9091:'Nothing inside: nothing more to say',
 0x9092:'Something inside: print the heading for it ("in the chest there is")',
 0x9095:'',
 0x9098:'Nothing worth listing after all: stop',
 0x9099:'B = the target\'s own room',
 0x909C:'List everything it holds',
 0x909F:''})

C(0x90A2,{
 0x90A2:'IX = the target\'s own record',
 0x90A6:'Is it open?',
 0x90A9:'No, already closed: say so',
 0x90AC:'Dry run? Then stop here: it would work',
 0x90AF:'Close it',
 0x90B3:''})

C(0x9308,{
 0x9308:'IY = the instrument\'s (the receiver\'s) own record',
 0x930C:'Is the actor actually holding the target?',
 0x930F:'"you are not carrying it."',
 0x9312:'If not, say so and stop',
 0x9315:'A = the receiver',
 0x9318:'A = how much the receiver is already carrying',
 0x931B:'IX = the target\'s own record',
 0x931F:'Add the target\'s own weight to that',
 0x9322:'Keep the combined total for a moment',
 0x9323:'',
 0x9324:'A = the receiver\'s own carrying capacity',
 0x9327:'Subtract the combined total: would that go below zero?',
 0x9328:'"X is carrying too much."',
 0x932B:'Too much for them to take: say so and stop',
 0x932E:'Dry run? Then stop here: it would work',
 0x9331:'The receiver becomes the target\'s new holder...',
 0x9334:'',
 0x9337:'...in the receiver\'s own room',
 0x933A:'',
 0x933D:'B = that room',
 0x933E:'Move the target there, telling Bilbo about it if he can see it',
 0x9341:''})

C(0x9344,{
 0x9344:'Dry run? Then stop here: EXAMINE always works',
 0x9347:'A = the target',
 0x934A:'IX = its own record',
 0x934D:'HL = its own description, if it has one written specially for it',
 0x9350:'',
 0x9353:'Is there actually a description there?',
 0x9354:'',
 0x9355:'Yes: print it, and that is the whole answer',
 0x9358:'No description: "you see"',
 0x935B:'',
 0x935E:'IY = the target\'s own record',
 0x9360:'',
 0x9362:'Print its name',
 0x9365:'A full stop...',
 0x9367:'',
 0x936A:'...then a new line',
 0x936D:''})

C(0x93CD,{
 0x93CD:'Is the target already locked, or not even closed?',
 0x93D0:'If either, say why it cannot be locked',
 0x93D3:'A = $C6, the machine-code for a SET instruction',
 0x93D5:'Poke that into the instruction at $93EB below, so that from now on it locks rather than unlocks - this and #R$93ED share their final steps by rewriting each other',
 0x93D8:'IY = the instrument\'s (the key\'s) own record',
 0x93DC:'Is the key broken?',
 0x93E0:'A = the state code for BROKEN',
 0x93E2:'If it is broken, say so and stop',
 0x93E5:'Dry run? Then stop here: it would work',
 0x93E8:'Lock the target (this very byte is what #R$93ED rewrites to RES, to unlock instead)',
 0x93EC:''})

C(0x93ED,{
 0x93ED:'IX = the target\'s own record',
 0x93F1:'Is it actually locked?',
 0x93F5:'A = the state code for UNLOCKED',
 0x93F7:'No, already unlocked: say so',
 0x93FA:'Locked: does the key fit (is the door open enough to check)?',
 0x93FD:'No: say why not',
 0x9400:'A = $86, the machine-code for a RES instruction',
 0x9402:'Poke that into the shared instruction, then join #R$93CD, which finishes the job by clearing the lock'})

C(0x9404,{
 0x9404:'Is the actor holding the target?',
 0x9407:'A = the instrument (the river, window or similar being thrown across or through)',
 0x940A:'Find the room\'s exit that passes through it',
 0x940D:'',
 0x940F:'No such exit exists: fail with the usual "you cannot go that way"-style message',
 0x9412:'IY = the instrument\'s own record',
 0x9416:'Is it open (or is that even required)?',
 0x941A:'A = the state code for OPEN/CLOSED',
 0x941C:'Closed: say so and stop',
 0x941F:'Dry run? Then stop here: it would work',
 0x9422:'B = this exit\'s destination room',
 0x9425:'IX = the target\'s own record',
 0x9429:'It is held by nobody now...',
 0x942D:'...and lands in the room on the far side',
 0x9430:'Move it there, telling Bilbo about it if he can see it',
 0x9433:''})

C(0x9436,{
 0x9436:'Save the caller\'s IX and HL',
 0x9438:'',
 0x9439:'Does the action even make sense (not done to yourself, for instance)?',
 0x943C:'Assume not',
 0x943E:'It does not: record that and stop',
 0x9440:'A = the action being tried',
 0x9443:'Is there a default handler for it (one that applies to any object)?',
 0x9447:'',
 0x944A:'(A is left holding either the action, if found, or $FF if there is no default handler)',
 0x944C:'Assume it could apply',
 0x944E:'A default handler exists: that settles it',
 0x9450:'No default handler: is this one of the actions that uses the instrument\'s own handlers rather than the target\'s?',
 0x9453:'Assume it could apply',
 0x9455:'Yes: accept it for now (the instrument itself gets checked properly later)',
 0x9457:'No: does the TARGET itself carry a handler for this action?',
 0x945A:'',
 0x945D:'',
 0x9460:'',
 0x9463:'Assume it could apply',
 0x9465:'It does (found): that settles it',
 0x9467:'No handler anywhere: it could not apply after all',
 0x9468:'Record the answer',
 0x946B:'Restore the caller\'s HL and IX',
 0x946C:'',
 0x946E:''})

C(0x953F,{
 0x953F:'Is the object at IX a living character?',
 0x9543:'No: nothing reacts',
 0x9544:'Is it already dead?',
 0x9548:'Yes: the dead do not react either',
 0x9549:'Give it a chance to switch its behaviour in response to what was just done to it',
 0x954C:''})

C(0x9589,{0x9589:'"you see"',0x958C:'Join the shared room-description code below, using this heading instead of "you are in"'})

C(0x95E4,{
 0x95E4:'Does the room have its own description script (rather than needing its name printed)?',
 0x95E7:'A room\'s own name words start 2 bytes into its record',
 0x95EA:'Save the caller\'s IY',
 0x95EC:'Copy the room\'s record into IY as well...',
 0x95EE:'',
 0x95F0:'...then move it on to the name words',
 0x95F2:'Print the room\'s own name (as a noun with adjectives)',
 0x95F5:'Restore the caller\'s IY',
 0x95F7:''})

C(0x95F8,{
 0x95F8:'Is a key already being held down (so we should wait for it to be released first)?',
 0x95F9:'',
 0x95FB:'',
 0x95FD:'Yes: keep waiting',
 0x95FF:'',
 0x9601:'A key has been pressed: reset the border to white (a picture may have changed its colour)',
 0x9603:'',
 0x9605:''})

C(0x9606,{
 0x9606:'IX = room A\'s own record',
 0x9609:'Print its name',
 0x960C:'New line',
 0x960F:'Join the rest of the full room description (doors, exits and contents), skipping the picture'})

C(0x96DA,{0x96DA:'A = the target of the current command (falls straight into #R$96DD, which kills character A)'})
