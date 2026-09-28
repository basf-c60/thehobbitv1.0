# Batch 17 (final): the remaining object, character and timer handlers from
# A0DE to A9FF - water, the rope and boat, doors, Gollum, the trolls, and
# the wine - completing hand-written comments for every routine.
from overlay import A, blk
from overlay9 import C
blk(0xA9FF,'c','',[])
from overlay3 import fact, bug

C(0xA0DE,{
 0xA0DE:'Save IY and IX',
 0xA0E0:'',
 0xA0E2:'Search every object in the game...',
 0xA0E6:'',
 0xA0E9:'No more objects: give up (below)',
 0xA0EB:'Is it held by the object whose holder we want?',
 0xA0EE:'No: try the next one',
 0xA0F0:'A = the object that holds it (or $FF if none was found)',
 0xA0F3:'Restore IX and IY',
 0xA0F5:'',
 0xA0F7:''})

C(0xA0F8,{0xA0F8:'A = the object\'s own flags',0xA0FB:'Keep just "alive" and "dead"',0xA0FD:'Alive and not dead?',0xA0FF:'Z reflects the answer'})

C(0xA174,{0xA174:'Dry run? Then stop here: drinking plain water always works, and has no other effect',0xA177:''})

C(0xA178,{
 0xA178:'Is the TARGET actually the rope (object 18)?',
 0xA17B:'',
 0xA17D:'Yes: "TIE THE ROPE TO X" - turn it round into "TIE X TO THE ROPE" (below)',
 0xA17F:'No: is the INSTRUMENT the rope instead?',
 0xA182:'',
 0xA184:'Neither: fail with the usual message - only the rope can be tied',
 0xA187:'IX = the target\'s own record (the thing being tied)',
 0xA18B:'Does it pour (is it a liquid)?',
 0xA18F:'Yes: cannot tie up a liquid',
 0xA192:'Does it already hold anything visible?',
 0xA195:'',
 0xA197:'"the X is already tied."',
 0xA19A:'Already holding something (i.e. already tied to something): say so and stop',
 0xA19D:'Is it dead (a corpse)?',
 0xA1A1:'Yes: a dead character may still be tied up',
 0xA1A3:'No: is it a LIVING character?',
 0xA1A7:'Yes: cannot tie up someone alive',
 0xA1AA:'Dry run? Then stop here: it would work',
 0xA1AD:'IY = the rope\'s own record',
 0xA1B1:'Is the actor already holding the thing being tied?',
 0xA1B4:'It becomes held by the rope, either way...',
 0xA1B7:'',
 0xA1BA:'If the actor already held it, skip straight to deciding who holds the rope itself',
 0xA1BC:'Otherwise: try to pick it up first (as an ordinary TAKE), but only as a trial for now',
 0xA1BD:'',
 0xA1C0:'',
 0xA1C3:'Did the actor manage to pick it up?',
 0xA1C6:'',
 0xA1C8:'Either way, this really is happening now',
 0xA1CA:'',
 0xA1CD:'',
 0xA1D0:'Could not pick it up: leave the rope where it is, below',
 0xA1D2:'Could pick it up: the rope stays in the actor\'s own hands',
 0xA1D5:'',
 0xA1D8:'',
 0xA1D9:'Left lying: the rope is held by nobody, tied to whatever is too heavy to lift',
 0xA1DD:'',
 0xA1DE:'"TIE THE ROPE TO X": run this same handler again...',
 0xA1E1:'...with target and instrument swapped, so it becomes "TIE X TO THE ROPE"'})

C(0xA1E4,{
 0xA1E4:'IX = the target\'s own record',
 0xA1E8:'Is it actually held by the rope (object 18)?',
 0xA1EB:'',
 0xA1ED:'"the X is not tied."',
 0xA1F0:'No: say so and stop',
 0xA1F3:'Dry run? Then stop here: it would work',
 0xA1F6:'A = whoever holds the rope itself',
 0xA1F9:'The target now belongs to them too',
 0xA1FC:''})

C(0xA1FD,{
 0xA1FD:'Find the exit that passes through the river',
 0xA200:'Does it lead anywhere?',
 0xA203:'',
 0xA205:'Yes: swim across, below',
 0xA207:'No: dry run? Then stop here: the attempt itself is possible',
 0xA20A:'(falls through to failing normally otherwise)',
 0xA20B:'A = the exit\'s own direction',
 0xA20E:'Save the current action for a moment...',
 0xA211:'',
 0xA212:'...and use the direction as the movement action instead',
 0xA215:'IX = the river\'s own record',
 0xA219:'Open it, just long enough to move through it',
 0xA21D:'',
 0xA21F:'No specific target - just moving',
 0xA221:'',
 0xA224:'Carry out the move',
 0xA227:'Restore the river\'s own record',
 0xA229:'Close it again',
 0xA22D:'Restore the original action',
 0xA22E:'',
 0xA231:''})

C(0xA232,{
 0xA232:'Is the current actor the dragon (object 60)?',
 0xA235:'',
 0xA237:'No: fail with the usual message - nobody else can burn things',
 0xA23A:'Dry run? Then stop here: it would work',
 0xA23D:'Kill the target'})

C(0xA240,{
 0xA240:'Dry run? Then stop here: it would work',
 0xA243:'"as soon as X touches the river X falls asleep and gently floats away."',
 0xA246:'',
 0xA249:'Is the swimmer Bilbo himself?',
 0xA24C:'',
 0xA24D:'',
 0xA24E:'"time passes..."',
 0xA251:'If it is Bilbo, add that too',
 0xA254:'Restore A',
 0xA255:'The swimmer dies'})

C(0xA258,{0xA258:'Dry run? Then stop here: it would work',0xA25B:'"X falls asleep."',0xA25E:'Join the enchanted-river code above, which adds "time passes..." for Bilbo and kills the drinker'})

C(0xA260,{0xA260:'The small curious key (object 2) is the one that fits the side door',0xA262:'Join the shared LOCK/UNLOCK code'})
C(0xA268,{0xA268:'The large key (object 4) is the one that fits the trolls\' cave (falls into #R$A26A)'})

C(0xA28E,{0xA28E:'Only if this is really happening (not just a trial)',0xA291:'IX = the target\'s (the door\'s) own record',0xA295:'Open it, as if by the ordinary OPEN handler'})

C(0xA298,{
 0xA298:'IX = the actor\'s own record',
 0xA29C:'Is the actor in room 15 (the only place the crack can be opened from)?',
 0xA29F:'',
 0xA2A1:'No: fail with the usual message',
 0xA2A4:'Yes: open it as usual'})

C(0xA406,{
 0xA406:'Dry run? Then stop here: it always works',
 0xA409:'Pick a random number from 0 to 10',
 0xA40B:'',
 0xA40E:'"what do you expect me to do with this?"',
 0xA411:'8 or more?',
 0xA413:'Yes: say that',
 0xA416:'"thank you"',
 0xA419:'Otherwise: say that instead'})

C(0xA41C,{0xA41C:'Dry run? Then stop here: it always works',0xA41F:'"what\'s this?"',0xA422:'Say it'})

C(0xA425,{
 0xA425:'Dry run? Then stop here: it always works',
 0xA428:'Pick a random number from 0 to 2',
 0xA42A:'',
 0xA42D:'"you are doing a great job"',
 0xA430:'0?',
 0xA432:'Say that',
 0xA435:'"hurry up"',
 0xA438:'1?',
 0xA43A:'Say that instead',
 0xA43D:'"hello"',
 0xA440:'Otherwise say that'})

C(0xA443,{0xA443:'Dry run? Then stop here: it always works',0xA446:'"this was thrains key"',0xA449:'Say it'})

C(0xA44C,{
 0xA44C:'A = the room the character started this turn in',
 0xA44F:'Is that the room Bilbo is in?',
 0xA452:'',
 0xA453:'No: say nothing',
 0xA454:'Dry run? Then stop here: it always works',
 0xA457:'"hello"',
 0xA45A:'Say it'})

C(0xA45D,{
 0xA45D:'Is the current actor the wood elf (object 64)?',
 0xA460:'',
 0xA462:'No: fail with the usual message - only the wood elf can open it',
 0xA465:'Yes: open it as usual'})

C(0xA468,{
 0xA468:'IY = the actor\'s own record',
 0xA46C:'Is the actor actually inside the target?',
 0xA46F:'',
 0xA472:'No: fail with the usual message',
 0xA475:'IX = the target\'s own record',
 0xA478:'Is it open?',
 0xA47B:'No: say so and stop',
 0xA47E:'Dry run? Then stop here: it would work',
 0xA481:'The actor is held by nobody now: they are out',
 0xA485:''})

C(0xA486,{
 0xA486:'IY = the actor\'s own record',
 0xA48A:'Is the actor already inside the target?',
 0xA48D:'',
 0xA490:'Yes: fail with the usual message',
 0xA493:'A = how much the actor can carry...',
 0xA496:'...plus how much the actor is already carrying',
 0xA499:'',
 0xA49C:'Overflowed past 255? Then treat the actor as unmeasurably big',
 0xA49E:'',
 0xA4A0:'B = the actor\'s own total size, for the check below',
 0xA4A1:'IX = the target\'s (the container\'s) own record',
 0xA4A5:'Is it open?',
 0xA4A8:'No: say so and stop',
 0xA4AB:'A = the container\'s own capacity',
 0xA4AE:'Is it unlimited?',
 0xA4B0:'Yes: skip the size check',
 0xA4B2:'No: is the actor too big to fit?',
 0xA4B3:'"you are too big."',
 0xA4B6:'Too big: say so and stop',
 0xA4B9:'Dry run? Then stop here: it would work',
 0xA4BC:'The actor becomes held by the target...',
 0xA4BF:'...so wherever the target goes, the actor goes too',
 0xA4C2:''})

C(0xA4C3,{0xA4C3:'Is it open?',0xA4C7:'A = the state code for OPEN/CLOSED, in case the caller needs to report it',0xA4C9:'Z reflects the answer'})

C(0xA4CA,{
 0xA4CA:'Dry run? Then stop here: it always works',
 0xA4CD:'HL = the warg\'s own location',
 0xA4D0:'Is Bilbo in the same room?',
 0xA4D3:'',
 0xA4D4:'No: say nothing',
 0xA4D5:'"the vicious warg runs around you and howls."',
 0xA4D8:'Say it'})

C(0xA4DB,{
 0xA4DB:'Is the object just thrown through the door the barrel (object 19)?',
 0xA4DE:'',
 0xA4E0:'No: this handler does nothing',
 0xA4E1:'Only if this is really happening (chained after the trap door\'s own THROW THROUGH, #R$9404, which has already moved the barrel)',
 0xA4E4:'IX = the barrel\'s own record',
 0xA4E8:'Did it land in room 33, the forest river below?',
 0xA4EB:'',
 0xA4ED:'No: nothing happens',
 0xA4EE:'Yes: start timer 0 with a count of 2',
 0xA4F0:'',
 0xA4F3:''})

C(0xA539,{
 0xA539:'A = the room the character started this turn in',
 0xA53C:'Is Bilbo in that same room?',
 0xA53F:'',
 0xA540:'No: say nothing',
 0xA541:'Yes - is Bilbo actually visible?',
 0xA544:'',
 0xA546:'He is: no need to ask',
 0xA547:'Invisible: dry run? Then stop here: it always works',
 0xA54A:'"where\'s the thief?"',
 0xA54D:'Say it'})

C(0xA577,{
 0xA577:'IX = the actor\'s own record',
 0xA57B:'Is the actor in room 32 (the only place the trap door can be worked from)?',
 0xA57E:'',
 0xA580:'"you cannot reach the trap door."',
 0xA583:'No: say so and stop',
 0xA586:'Yes - is this actually CLOSE (action 12)?',
 0xA589:'',
 0xA58B:'Yes: close it as usual',
 0xA58E:'Otherwise (OPEN): open it as usual'})

C(0xA600,{
 0xA600:'Find the exit that passes through the target (presumably meant to be the boat)',
 0xA603:'Is there no such exit?',
 0xA605:'If so, there is nothing to do',
 0xA606:'Clear the exit\'s three bytes - sealing up the way, presumably once the boat is no longer there',
 0xA607:'',
 0xA60B:'',
 0xA60F:'',
 0xA613:'(This routine is never actually called by anything in the game - see the note above)'})

C(0xA614,{
 0xA614:'Dry run? Then stop here: it would work',
 0xA617:'IX = the actor\'s own record',
 0xA61B:'Is the actor visible?',
 0xA61F:'"X sees nothing special."',
 0xA622:'Visible: nothing more happens - just an ordinary EXAMINE',
 0xA625:'Invisible (wearing the ring): start timer 5 (copy its reload value into its count)',
 0xA628:'',
 0xA62B:'"the magic door warns of elves approaching."',
 0xA62E:''})

C(0xA631,{
 0xA631:'HL = Thorin\'s own flags',
 0xA634:'Is he dead?',
 0xA636:'No: nothing happens',
 0xA637:'Only if this is really happening',
 0xA63A:'IX = the small curious key\'s own record',
 0xA63E:'Mark it broken',
 0xA642:'Remove its second adjective, leaving just BROKEN',
 0xA644:'',
 0xA647:'Can Bilbo actually see the key (is it near enough)?',
 0xA64B:'',
 0xA64E:'No: say nothing',
 0xA64F:'"the small curious key shatters."',
 0xA652:''})

C(0xA655,{
 0xA655:'Is the actor Bilbo?',
 0xA658:'',
 0xA65A:'No (a character): they can always reach the window, below',
 0xA65C:'Yes - is Bilbo currently being held up by something?',
 0xA65F:'"you cannot reach the window."',
 0xA662:'',
 0xA664:'Held by nobody: he cannot reach it - say so and stop',
 0xA667:'Held by something, but the action still failed some other way: fail normally',
 0xA66A:'Is this CLOSE (action 12)?',
 0xA66D:'',
 0xA66F:'Yes: close it as usual',
 0xA672:'Is it OPEN (action 16)?',
 0xA674:'Yes: open it as usual',
 0xA677:'Anything else: do nothing further here'})

C(0xA678,{
 0xA678:'Is the actor Bilbo?',
 0xA67B:'',
 0xA67D:'No: characters can always reach it, below',
 0xA680:'Yes - is Bilbo currently being held up by something?',
 0xA683:'',
 0xA685:'"you cannot reach the window."',
 0xA688:'Held by nobody: he cannot reach it - say so and stop',
 0xA68B:'A = the current action',
 0xA68E:'Is it GO THROUGH?',
 0xA690:'Yes: go through it as usual',
 0xA693:'Is it STRIKE (breaking it)?',
 0xA695:'Yes: break it as usual',
 0xA698:'Is it LOOK THROUGH?',
 0xA69A:'Yes: look through it as usual',
 0xA69D:'Anything else: do nothing further here'})

C(0xA708,{
 0xA708:'A = the instrument (the river)',
 0xA70B:'Find the exit that passes through it',
 0xA70E:'',
 0xA710:'No such exit: fail with the usual message',
 0xA713:'Dry run? Then stop here: it would work',
 0xA716:'"it sails across and"',
 0xA719:'',
 0xA71C:'A = wherever the wooden boat currently is',
 0xA71F:'Is the boat moored on the far side of this exit?',
 0xA722:'No: try the other outcome, below',
 0xA724:'Yes: an even chance - does the rope land well?',
 0xA727:'No: it falls short or slides out (below)',
 0xA729:'"falls just short of the other side."',
 0xA72C:'Another even chance - does it end up IN the boat, or just miss?',
 0xA72F:'It just misses: print the "falls short" message and finish',
 0xA731:'"lands in the boat. but slides out again."',
 0xA734:'',
 0xA736:'It landed well: mark the boat as now tied to the rope, for #R$A76A to use',
 0xA738:'',
 0xA73B:'"lands in the boat."',
 0xA73E:'',
 0xA740:'The boat is not over there: another even chance - does the rope reach the far bank anyway?',
 0xA743:'',
 0xA746:'No: print "falls just short" and finish',
 0xA748:'Yes: A = the far bank',
 0xA74B:'IX = the rope\'s own record',
 0xA74F:'It moves to that bank...',
 0xA752:'...held by nobody',
 0xA756:'Move it there, and report it if Bilbo can see',
 0xA759:'',
 0xA75C:'"lands on the other side."',
 0xA75F:''})

C(0xA762,{0xA762:'A = 100',0xA764:'Pick a random number from 0 to 100',0xA767:'Below 50?',0xA769:'Carry reflects the answer'})

C(0xA76A,{
 0xA76A:'Dry run? Then stop here: it would work',
 0xA76D:'Is the boat actually tied to the rope (the flag set by #R$A708)?',
 0xA770:'',
 0xA772:'No: nothing to pull',
 0xA773:'"the boat glides across the river and lands on this side."',
 0xA776:'',
 0xA779:'A = where the boat currently is',
 0xA77C:'Is it on this side already (room 66)?',
 0xA77E:'',
 0xA780:'No: it will end up on this side (room 66)',
 0xA782:'Yes (an odd case): send it to the OTHER side instead (room 67)',
 0xA784:'The boat moves there',
 0xA787:'B = that room',
 0xA788:'The rope is no longer tied to it',
 0xA78A:'',
 0xA78D:'A = the boat\'s own object number',
 0xA78F:'Move it (and anything in it) there, reporting it if seen'})

C(0xA792,{
 0xA792:'Only if this is really happening',
 0xA795:'Is the actor Bilbo?',
 0xA798:'',
 0xA799:'No: nothing happens (this only triggers for Bilbo\'s own actions on the boat)',
 0xA79A:'"with a lurch the boat glides across the river and lands on the other side."',
 0xA79D:'Join the PULL code above, which actually moves it'})

C(0xA7C6,{
 0xA7C6:'A = Gollum\'s own location',
 0xA7C9:'Is Bilbo in the same room?',
 0xA7CC:'',
 0xA7CD:'No: say nothing',
 0xA7CE:'Is Bilbo actually visible?',
 0xA7D1:'',
 0xA7D3:'No (he is wearing the ring): Gollum cannot see him to ask',
 0xA7D4:'Dry run? Then stop here: it always works',
 0xA7D7:'HL = the riddle chosen at the start of the game...',
 0xA7DA:'...moved on 2 bytes, to the riddle\'s own text',
 0xA7DB:'',
 0xA7DC:'DE = the riddle\'s address',
 0xA7DD:'',
 0xA7DE:'',
 0xA7DF:'HL = that address',
 0xA7E0:'',
 0xA7E1:'Gollum asks it',
 0xA7E4:'Remember that he is now waiting for the answer',
 0xA7E6:'',
 0xA7E9:''})

C(0xA81A,{
 0xA81A:'A = Gollum\'s own location',
 0xA81D:'Is Bilbo in the same room?',
 0xA820:'',
 0xA821:'No: say nothing',
 0xA822:'Dry run? Then stop here: it always works',
 0xA825:'"what has it got in its pocketses?"',
 0xA828:'Pick a random number from 0 to 8',
 0xA82A:'',
 0xA82D:'Is it negative (the rare, skewed case)? If so, say that regardless',
 0xA830:'Otherwise: IX = the golden ring\'s own record',
 0xA834:'Does Gollum (object 68) still hold it?',
 0xA836:'',
 0xA839:'Yes: say the "pocketses" line anyway',
 0xA83C:'"my birthday present, how did we lose it. my precious"',
 0xA83F:'No (he has lost it): say that instead'})

C(0xA842,{
 0xA842:'A = the room the character started this turn in',
 0xA845:'Is Bilbo in that same room?',
 0xA848:'',
 0xA849:'No: nothing happens',
 0xA84A:'Dry run? Then stop here: it always works',
 0xA84D:'A = the EAT action',
 0xA84F:'',
 0xA852:'The target is Bilbo (object 0)',
 0xA854:'',
 0xA857:'No instrument',
 0xA859:'',
 0xA85C:'Report it in words ("the hideous troll eats you.")',
 0xA85F:'Run the ordinary eating code (for its side effects)',
 0xA862:'Bilbo dies'})

C(0xA865,{
 0xA865:'Dry run? Then stop here: it always works',
 0xA868:'Kill the hideous troll (object 71)...',
 0xA86A:'',
 0xA86D:'...and the vicious troll (object 72) too',
 0xA86F:'',
 0xA872:'The hideous troll becomes invisible...',
 0xA875:'',
 0xA877:'...and so does the vicious troll',
 0xA87A:'',
 0xA87C:'"in a clearing with two stone trolls"',
 0xA87F:'This becomes the clearing\'s new description script',
 0xA882:'The clearing\'s "visited" flag is cleared...',
 0xA885:'...so it will be described in full again, with the new text',
 0xA887:'Everything the hideous troll was carrying is left behind...',
 0xA889:'',
 0xA88C:'...and likewise for the vicious troll',
 0xA88E:'',
 0xA891:'"day dawns."',
 0xA894:'Make sure Bilbo sees this, wherever he is',
 0xA896:'',
 0xA899:'',
 0xA89C:'Find the clearing\'s own picture...',
 0xA8A0:'',
 0xA8A2:'',
 0xA8A5:'HL = its address',
 0xA8A8:'',
 0xA8AB:'Its border colour becomes cyan...',
 0xA8AD:'',
 0xA8AE:'...and so does its background, so it is drawn in daylight from now on',
 0xA8B0:''})

C(0xA8B1,{
 0xA8B1:'Is Bilbo in the trolls\' clearing (room 5)?',
 0xA8B4:'',
 0xA8B6:'No: say nothing',
 0xA8B7:'Dry run? Then stop here: it always works',
 0xA8BA:'Is the speaker the hideous troll (object 71)?',
 0xA8BD:'',
 0xA8C0:'',
 0xA8C2:'Yes: "blimey, look at this! can yer cook \'em?"',
 0xA8C4:'No (the vicious troll): "yer can try, but he wouldn\'t make above a mouthful"',
 0xA8C7:''})

C(0xA8D9,{
 0xA8D9:'A = the room the character started this turn in',
 0xA8DC:'Is Bilbo in that same room?',
 0xA8DF:'',
 0xA8E0:'No: nothing happens',
 0xA8E1:'IX = the lunch\'s own record',
 0xA8E5:'Has it already been placed anywhere (i.e. already given)?',
 0xA8E8:'',
 0xA8EA:'No (still nowhere): give it now, below',
 0xA8EC:'Yes - is it still held by Elrond himself?',
 0xA8EE:'',
 0xA8F1:'No (already handed over): nothing more to do',
 0xA8F2:'Dry run? Then stop here: it always works',
 0xA8F5:'The lunch appears in this room...',
 0xA8F8:'',
 0xA8FB:'...held by Elrond',
 0xA8FF:'The lunch (object 38) is the target...',
 0xA902:'',
 0xA906:'The action is GIVE TO',
 0xA908:'',
 0xA90B:'IX = the lunch\'s own record, for GIVE TO to use',
 0xA90F:'Bilbo (object 0) is the instrument (the receiver)',
 0xA912:'',
 0xA915:'Report it in words',
 0xA918:'Actually carry out the GIVE TO'})

C(0xA91B,{
 0xA91B:'IY = the barrel\'s own record',
 0xA91F:'B = the room the barrel is in',
 0xA922:'',
 0xA923:'Find an exit from the actor\'s own room that leads there',
 0xA926:'',
 0xA928:'"you cannot jump onto the barrel from here."',
 0xA92B:'No such exit: say so and stop',
 0xA92E:'A = that exit\'s own direction',
 0xA931:'Is it DOWN?',
 0xA933:'No: jump to the message text itself, rather than through the printer - see the bug note',
 0xA936:'Dry run? Then stop here: it would work',
 0xA939:'The actor becomes held by the barrel...',
 0xA93C:'',
 0xA940:'',
 0xA943:'...and moves wherever the barrel goes',
 0xA946:'Is the actor Bilbo?',
 0xA949:'',
 0xA94B:'No: nothing more to do',
 0xA94C:'Yes: describe the room the barrel is now in',
 0xA94D:''})

C(0xA9ED,{
 0xA9ED:'Is the drinker Bilbo?',
 0xA9F0:'',
 0xA9F2:'No (a character): nothing happens',
 0xA9F3:'Yes: set the "drunk" flag...',
 0xA9F5:'',
 0xA9F8:'...and start timer 7 (copy its reload value into its count)',
 0xA9FB:'',
 0xA9FE:''})

C(0xA9FF,{0xA9FF:'Clear the "drunk" flag: Bilbo has sobered up',0xAA00:'',0xAA03:''})

# ---------------------------------------------------------------- a bug found while tracing the barrel handler
bug('barreljump','Approaching the barrel the wrong way can crash the game',
 "#R$A91B lets the player climb into or jump onto the barrel from an adjoining room, provided the only route there is DOWN - the way the book's escape works. When an exit is found but its direction is anything else, the handler means to print 'you cannot jump onto the barrel from here.' by loading its address into HL and printing it (exactly as the case above it does), but the instruction actually used is a direct JP NZ to that same address, so the Z80 jumps straight into the message's own bytecode and starts executing it as instructions. In one emulator test this sent the program off through a string of unrelated addresses and into an infinite loop inside the routine that saves an unfinished command, freezing the game; the precise garbage path would depend on the exact machine state at the time, but a jump straight into data like this is never going to behave sensibly.",
 "It is reachable in the finished game: standing in the Elvenking's great halls (room 30) or the dark dungeon (room 31) and typing 'climb into barrel' or 'jump onto barrel' while the barrel is in the cellar reaches this path, since both rooms have an exit to the cellar that is not DOWN.")

fact('deadcode','Two routines that nothing ever calls',
 "The finished game contains two complete routines that are never reached from anywhere: #R$A0DE, which looks up whoever holds a given object, and #R$A600, which finds and seals up an exit (its own reuse of #R$9E6E suggests it was meant for the boat). Neither is called by any other routine, referenced in any object's handler list, or used by any room-entry handler or timer. They read like abandoned code - perhaps an earlier approach to a puzzle that was solved a different way by the time the game shipped.")
