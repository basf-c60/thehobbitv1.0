# Batch 10: the remaining unexplained data blocks - mostly handlers that never ran in the test games
from overlay import A, blk
from overlay3 import fact, bug
from overlay4 import code, EXTRA_REGIONS
def data(a,end,title,desc,subs=()):
    blk(a,'b',title,desc,subs=list(subs)); EXTRA_REGIONS[a]=end

# ---- small pieces of code and variables
code(0x73B4,0x73BE,'Message codes $08 and $09',["Code $08 ($73B4) prints a backspace, so that a word can be joined to the one before it (for example to add a suffix). Code $09 ($73B9) sets the 'print an article' flag and prints the instrument with its article, continuing into #R$73BE."])
data(0x749D,0x74B1,'Word buffer',["Where #R$74B8 assembles the letters of a word, plus any verb ending, before printing it. Up to 20 characters."],[('B',0x749D,0x14,'')])
code(0x7FC5,0x7FDE,'Copy part of one frame to another',["Copies C bytes at offset DE from the frame at IX to the same offset in the frame at IY. Entry points: $7FC5 copies 6 bytes (a noun and two adjectives), $7FC9 copies 10 (a whole noun phrase) and $7FCD copies 2 (one word). Used by #R$7F81 and #R$7CC0 to share words between commands."])
data(0x8C2C,0x8C2D,'Drawing colour',["The ink colour used by #R$8B93 when plotting, set by the flood fill (#R$8A4F) and reset to 0 afterwards."],[('B',0x8C2C,1,'')])
data(0x9B37,0x9B38,'Bilbo-moved flag',["Cleared by #R$9B6C when Bilbo is among the things moved along with an object, so that #R$9B38 knows to describe his new surroundings."],[('B',0x9B37,1,'')])
data(0x6DC3,0x6DCD,'Border pattern',["Ten bytes drawn by the start-up code (#R$6C27, at $6CCB) as a decorative pattern on the screen."],[('B',0x6DC3,10,'')])
code(0x96DA,0x96DD,'Kill the target',["Loads the target ($B5D9) and continues into #R$96DD. Used by BURN (#R$A232)."])
code(0x9CA5,0x9CA8,'Drop everything the target holds',["Loads the target and continues into #R$9CA8. Used when a container is emptied or broken."])
code(0x9E6E,0x9E71,'Find the exit through the target',["Loads the target and continues into #R$9E71: finds the exit of the actor's room that goes through the target (a door, a window, a river)."])
code(0x9589,0x958E,'Describe the room through a door',["Describes the room the actor is (temporarily) in, starting with '<actor> see' instead of 'you are in'. Used by #R$8E4E to show what can be seen through an open door or across a river."])
code(0x9E93,0x9EBF,'Run a handler with target and instrument swapped',["Exchanges the target and the instrument (their numbers and record addresses), calls the handler at HL, and swaps them back. This lets one handler serve two ways of saying the same thing: FILL THE BOTTLE WITH WATER becomes PUT THE WATER IN THE BOTTLE (#R$8ED3), and THROW THE SWORD AT THORIN becomes ATTACK THORIN WITH THE SWORD (#R$8F5F)."])
code(0xA0DE,0xA0F8,'Look up the holder of an object (unused)',["Searches the object index for the holder of the object at IY and returns its number. Nothing in the game calls this routine."])
code(0xA0F8,0xA100,'Is the object alive?',["Returns with Z set if the object at IX is a living thing (bit 6 of its flags set) and not dead (bit 3 clear). Used by SHOOT (#R$8FE0)."])

# ---- doors, windows and rivers
code(0x8E34,0x8E4E,'Is an object shut inside something?',["Follows the holders of object A upwards while they are open. Returns with Z set if it reaches a loose object (so the object is out in the open) and Z reset if it meets a closed container."])
code(0x8E4E,0x8E5A,'LOOK THROUGH (a door or window)',["The LOOK THROUGH handler of every door (and, via #R$A678, the window). The door must be open (otherwise 'the door is closed'), and the actor must not be shut inside anything. Then it continues as #R$8E5A."])
code(0x8E5A,0x8E9D,'LOOK ACROSS (a river)',["Finds the exit that passes through the target (#R$9E6E). If it leads anywhere, and the room on the other side is lit, the actor is moved there for a moment, the room is described ('you see ...', #R$9589), and the actor is put back. If the far side is dark: 'it is dark.' This is how you can see what is on the other bank of the river, or behind a door, without going there."])
code(0x8E9D,0x8EA0,'GO THROUGH (a door, window or river)',["Finds the exit through the target (#R$9E6E) and goes through it (#R$8EA0). The GO THROUGH handler of every door, the spider web and the portcullis."])
code(0x8ED3,0x8F17,'FILL WITH',[
 "The barrel's FILL handler. The instrument must be something that pours (bit 1 of its flags: water and wine, for example) and the target must not already be full ('the barrel is full'). The work is done by PUT IN (#R$91B9) with target and instrument swapped (#R$9E93), so FILL THE BARREL WITH WATER is really PUT THE WATER IN THE BARREL.",
 "Filling from a river is a special case: if the instrument is object 23 or 24 (the river's water or black water), a fresh object 21 or 22 ('water', 'black water') is used instead, so the river never runs dry."])
code(0x8F5F,0x8F9E,'THROW AT',[
 "The default handler for THROW X AT Y. After checking that the actor can lift the thing thrown (#R$8C86), it becomes an attack: if the target is alive, the fight routine (#R$90DB, ATTACK) is used, otherwise the breaking routine (#R$9257, STRIKE), in both cases with the thrown object as the weapon (#R$9E93). Afterwards the thrown object lands at the target's feet (its holder is cleared) and the target reacts as if attacked (#R$953F)."])
code(0x8FCF,0x8FE0,'DIG (the sand)',["The sand's DIG handler: digging opens it (#R$9081), revealing anything buried in it; digging again closes it."])
code(0x8FE0,0x903C,'SHOOT',[
 "The shooter must be carrying the bow (object 25): otherwise 'you are not carrying the bow.' Then, if it would work, it is treated as an attack.",
 "Anyone except Bard: the dragon cannot be hit at all ('the arrow misses the dragon by a wide margin'), and anyone else is missed if a random number from 0 to 8 (#R$9BF4) is below 3.",
 "Bard (object 70) never misses. On a hit the arrow (object 26) is left lying where it fell, 'the arrow hits X.', and a living target is killed outright (#R$96DD); anything else is broken (#R$9257).",
 "So the only way to kill the dragon is to get Bard to shoot it - which is what the HELP message in the lower halls means by 'look to bard'."])
fact('bard','Only Bard can kill the dragon',
 "SHOOT (#R$8FE0) treats Bard specially: his arrows never miss, while anyone else's always miss the dragon. A hit kills any living thing outright. So Bilbo must bring Bard (who wakes up when Bilbo reaches the Elvenking's cellar, #R$C6AF) the bow and arrow and tell him to shoot the dragon; Bard then keeps obeying that order every turn (#R$A79F).")
code(0x91B9,0x9206,'PUT IN, PUT ON and DROP IN',[
 "The handler for putting the target into (or on) a container, the instrument. The target must be something that can be picked up (#R$8CBA), and not already in the container ('I cannot do that'). Except for PUT ON, the container must be open ('the chest is closed'). There must be room: the container's size (byte 2), minus the target's size, minus the size of what is already inside (#R$9C3D), must be positive ('the chest is too full'). Then the target takes the container's location and the container becomes its holder."])
code(0x9252,0x9257,'"The X is broken"',["Reports that the target is broken (#R$A094 with state $83)."])
code(0x9257,0x9308,'STRIKE (break something)',[
 "Breaking things - STRIKE, BREAK and SMASH, and THROW at something that is not alive. Things that pour cannot be broken, and nor can anything with a defence of 0. If there is an instrument, it must have some strength and must itself have a STRIKE handler (so you can smash a door with the sword but not with the lunch).",
 "The force is the instrument's strength plus the actor's strength plus a random number from -21 to +21 (#R$9BFD), capped at 255. If that is at least the target's defence, the target breaks: it is marked broken, its adjective becomes BROKEN (#R$A0BC), its strength is halved, and if it is a container its contents fall out. 'the door is broken.'",
 "Then the instrument may break too: its defence plus a random number is compared with the target's defence in the same way, and if it is at least as large the instrument is broken as well. (As written, a tougher instrument is more likely to break than a flimsy one.)"])
code(0x936E,0x9392,'EMPTY',["The barrel's EMPTY handler. It must be open ('the barrel is closed') and have something in it ('the barrel is empty'). Its contents are tipped out where it stands (#R$9CA5) and it is no longer full."])
code(0x9392,0x93CD,'PUT or DROP something in the river',[
 "The rivers' PUT IN and DROP IN handler. The river is an object in two places, one on each bank. The thing dropped in is carried to the location on the other side from the actor ('... and it gets swept away'); if the actor is on the river's second bank, the thing goes to location 0, and is lost."])
code(0xA268,0xA26A,'Handler for the heavy rock door: LOCK and UNLOCK',["The large key (object 4) fits the heavy rock door (the trolls' cave). Continues into #R$A26A."])
code(0xA260,0xA264,"Handler for the side door: UNLOCK",["The small curious key (object 2) fits the side door of the Lonely Mountain. Jumps to #R$A26A."])
code(0xA28E,0xA298,'Handler for the side door: OPEN',["Chained after the side door's other handlers: when it really happens, opens the door (at $9081 in #R$9078)."])

# ---- TIE, UNTIE, swimming, drinking, burning
code(0xA174,0xA178,'Handler for the water: DRINK',["Drinking ordinary water (object 23) always works and has no effect."])
code(0xA178,0xA1E4,'TIE TO',[
 "Only the rope can be tied: TIE THE ROPE TO X is turned round into TIE X TO THE ROPE ($A1DE, #R$9E93). The thing tied must not be something that pours, must be empty ('the rope is already tied'), and must not be a living character (a dead one is fine). It then becomes held by the rope.",
 "If the actor could pick the thing up, the rope stays in the actor's hands with the thing hanging from it; otherwise the rope is left lying, tied to it. Taking or dropping the rope takes or drops whatever is tied to it (#R$8CC8, #R$8C45)."])
code(0xA1E4,0xA1FD,'UNTIE',["The target must be tied to the rope ('the X is not tied'). It then goes to whoever holds the rope."])
code(0xA1FD,0xA232,'Handler for the fast river: SWIM',[
 "Swimming across the fast river: the exit through the river is found (#R$9E6E); if it leads anywhere, the river is opened for a moment and the actor goes through it with an ordinary move (#R$8D19, at $8D27), then the river is closed again. The entry at $A20C is the handler used by many doors and containers for their OPEN action when they are chained to a movement."])
code(0xA232,0xA240,'BURN',["Only the dragon (object 60) can burn anything; for anyone else it fails. When the dragon does it, the target is killed (#R$96DA)."])
code(0xA240,0xA258,'Handler for the fast black river: SWIM',["The enchanted river from the book: 'as soon as you touch the river you fall asleep and gently float away.' For Bilbo this is followed by 'time passes...', and the swimmer dies (#R$96DD)."])
code(0xA258,0xA260,'Handler for the black water: DRINK',["Drinking the black water: 'you fall asleep.', and then as #R$A240: 'time passes...', and death."])
fact('blackriver','The enchanted river',
 "Swimming in the fast black river (#R$A240) or drinking its black water (#R$A258) makes the drinker fall asleep and die, as in the book, where Bombur falls into the enchanted stream in Mirkwood and sleeps for days. Ordinary water is harmless (#R$A174).")

# ---- climbing, the window, the rope and the boat
code(0xA45D,0xA468,'Handler for the magic door: OPEN',["Only the wood elf (object 64) can open the magic door; anyone else fails."])
code(0xA468,0xA486,'CLIMB OUT OF',["The default handler for CLIMB OUT OF. The actor must be inside the target, which must be open ('the barrel is closed'). The actor's holder is cleared: he is out."])
code(0xA486,0xA4C3,'CLIMB INTO (the barrel, the chest or the boat)',[
 "The actor must not already be inside. The container must be open, and big enough: unless its size is $FF (unlimited), it must be larger than the actor plus everything the actor carries (#R$9C3D), or 'you are too big'. Then the container becomes the actor's holder, and the actor goes wherever it goes (#R$9B38) - which is how Bilbo escapes in the barrel (#R$A4F4)."])
code(0xA678,0xA69E,'Handler for the window',[
 "Bilbo cannot reach the window unless something (or someone) is holding him up: if nothing holds him, 'you cannot reach the window.' Characters, and a Bilbo who is being carried, are passed on to the normal handlers for going through it (#R$8E9D), breaking it (#R$9257) or looking through it (#R$8E4E). The HELP message in the goblins' dungeon hints at this: 'a window should be no obstacle to a thief with friends'."])
fact('window','A window needs friends',
 "The goblins' dungeon has a window that Bilbo cannot reach on his own (#R$A678). He has to be carried - by giving orders to a character strong enough to carry him - which is what the HELP message there means: 'a window should be no obstacle to a thief with friends'.")
code(0xA708,0xA762,'Handler for the rope: THROW ACROSS (the river)',[
 "Throwing the rope across a river: the exit through the river must lead somewhere. 'it sails across and ...'. Then chance takes over (#R$A762: evens). If the wooden boat (object 41, location at $C51A) is moored on the far side, the rope may land in the boat, which is then tied to it ('lands in the boat'), or fall short; if the boat is not there, the rope may land on the other side (and is moved there) or fall just short of it and come back."])
code(0xA762,0xA76A,'Evens',["Returns with carry set if a random number from 0 to 100 (#R$9BF4) is below 50."])
code(0xA76A,0xA792,'Handler for the rope: PULL',[
 "If the boat is tied to the rope, pulling it brings it over: 'the boat glides across the river and lands on this side.' The boat moves between room 66 and room 67 (the east bank), is untied, and takes whatever is in it along (#R$9B38). This is the way across the enchanted river - the HELP message at the river is 'boats can help. look carefully.'"])
code(0xA792,0xA79F,'Handler for the boat: it crosses by itself',["Chained after one of the boat's handlers: when Bilbo really does it, 'with a lurch the boat glides across the river', and the boat crosses as for #R$A76A."])
fact('boat','Crossing the enchanted river',
 "The wooden boat on the enchanted river is reached with the rope (#R$A708): throw it across, and if the boat is already moored on the far bank there is a 1-in-4 chance it lands cleanly in the boat, tying the two together; otherwise the throw falls short or slips out again. Once the rope has caught, PULL brings the boat over: 'the boat glides across the river and lands on this side' (#R$A76A). Swimming across instead is fatal (#R$A240). The HELP message at the river is 'boats can help. look carefully.'")

# ---- tables
data(0xA13B,0xA174,'Action and word tables',[
 "#LIST { $A13B: the five actions for which the instrument's handlers are used rather than the target's (#R$A100): DROP IN, PUT IN, PUT ON, TAKE OUT OF, THROW THROUGH. } { $A140: the words for the ten directions (#R$9FEA): NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST, UP, DOWN. } { $A154: the words for an object's flags when they are clear (#R$A09C): UNLOCKED, -, EMPTY, -, OFF, CLOSED, DEAD, -. } { $A164: the same when set: LOCKED, -, FULL, BROKEN, ON, OPEN, ALIVE, -. } LIST#"],
 [('B',0xA13B,5,'Actions'),('W',0xA140,20,'Directions 1-10'),('W',0xA154,16,'Flag words (clear)'),('W',0xA164,16,'Flag words (set)')])
data(0xA3C3,0xA3E7,'Goblin reincarnation table',["Six 6-byte entries used by #R$A36A when a goblin is killed: the goblin, the address of its slot in the character table, the room it reappears in, and its new adjective."],[('B',0xA3C3+6*i,6,'') for i in range(6)])
code(0x8C75,0x8C86,'TAKE OUT OF',["The containers' handler for TAKE X OUT OF Y (the goblins' cache, the cupboard, the chest and the boat). The target must actually be inside the container (#R$9BD3 checks the holder chain), or 'the X is not in the Y.' Then it is taken like anything else (the rest of #R$8CC8, reached at $8CD1)."])

A[0x8F9E]['desc']=["Hands the orders collected from a quotation (#R$80CD) to the character being spoken to (#R$88A7). Something that is not a character cannot take orders.",
 "Whether the character obeys depends on byte 6 of its entry in #R$C9BA. A value of 0 means it always obeys. Otherwise a random number from 0 up to that value is picked (#R$9BF4), and 0 means it says \"no\". Because of the way the random numbers are skewed (#R$9BFD), the chance of a refusal goes DOWN as the value goes up: 1 gives a refusal half the time, 3 a quarter of the time, and 5 or 6 one time in eight. So the value is really a measure of willingness rather than stubbornness: the trolls, the wood elf and the butler (1) are the most contrary, Gollum and Bard (3) refuse one order in four, Gandalf, Elrond and Thorin (5 and 6) one in eight - and the goblins, the warg and the dragon (0) never refuse at all."]
with open('/home/claude/sk/hobbit-chars.ref','w') as f:
    f.write("""[Page:Characters]
PageContent=#INCLUDE(CharactersText)

[PageHeaders]
Characters=The characters

[Links]
Characters=The characters

[CharactersText]
<p>The starting values of everything that can act. They come from each character's object record (#R$C00B) and its entry in the character table (#R$C9BA).</p>
<table>
<tr><th>No.</th><th>Character</th><th>Size</th><th>Carrying capacity / weight</th><th>Strength</th><th>Defence</th><th>Side</th><th>Refuses orders</th><th>Starts in</th><th>Active from</th></tr>
<tr><td>0</td><td>Bilbo (you)</td><td>16</td><td>64</td><td>64</td><td>64</td><td>1</td><td>-</td><td>1 tunnel-like hall</td><td>start</td></tr>
<tr><td>62</td><td>Gandalf</td><td>21</td><td>96</td><td>112</td><td>136</td><td>1</td><td>1 in 8 (5)</td><td>1 tunnel-like hall</td><td>start</td></tr>
<tr><td>63</td><td>Thorin</td><td>29</td><td>80</td><td>104</td><td>120</td><td>1</td><td>1 in 8 (6)</td><td>1 tunnel-like hall</td><td>start</td></tr>
<tr><td>65</td><td>Elrond</td><td>32</td><td>48</td><td>64</td><td>64</td><td>1 and 4</td><td>1 in 8 (5)</td><td>9 Rivendell</td><td>start</td></tr>
<tr><td>70</td><td>Bard</td><td>48</td><td>16</td><td>96</td><td>96</td><td>1</td><td>1 in 4 (3)</td><td>35 lake town</td><td>entering the Elvenking's cellar (#R$C6AF)</td></tr>
<tr><td>64</td><td>Wood elf</td><td>112</td><td>255</td><td>64</td><td>48</td><td>4</td><td>1 in 2 (1)</td><td>28 levelled elvish clearing</td><td>start</td></tr>
<tr><td>66</td><td>Butler</td><td>48</td><td>48</td><td>32</td><td>112</td><td>4</td><td>1 in 2 (1)</td><td>32 Elvenking's cellar (invisible)</td><td>entering Beorn's house (#R$C693)</td></tr>
<tr><td>68</td><td>Gollum</td><td>5</td><td>5</td><td>32</td><td>64</td><td>2</td><td>1 in 4 (3)</td><td>17 deep dark lake</td><td>start</td></tr>
<tr><td>61, 69, 73-76</td><td>The six goblins</td><td>64</td><td>48</td><td>72</td><td>96</td><td>2</td><td>never (0)</td><td>rooms 15, 58, 18, 56, 64, 16</td><td>start</td></tr>
<tr><td>67</td><td>Vicious warg</td><td>48</td><td>48</td><td>55</td><td>55</td><td>none</td><td>never (0)</td><td>21 treeless opening</td><td>start</td></tr>
<tr><td>71, 72</td><td>The two trolls</td><td>144</td><td>144</td><td>160</td><td>160</td><td>none</td><td>1 in 2 (1)</td><td>5 trolls' clearing</td><td>start</td></tr>
<tr><td>60</td><td>Red golden dragon</td><td>192</td><td>96</td><td>192</td><td>192</td><td>none</td><td>never (0)</td><td>41 lower halls</td><td>entering the Elvenking's cellar (#R$C6AF)</td></tr>
</table>
<h2>What the numbers mean</h2>
<p><b>Size</b> (byte 2 of the record) is how much room the character takes up: it must be no bigger than a door or window to pass through it (#R$8D19), and must fit inside a barrel, chest or boat to climb into it (#R$A486). Gollum, at 5, is the smallest thing in the game; the wood elf, at 112, is too big for most doorways.</p>
<p><b>Carrying capacity / weight</b> (byte 3) does two jobs. It is how much weight the character can carry (#R$8C86), and it is also the character's own weight when someone else tries to carry them. So Bilbo weighs 64: Gandalf (96) and Thorin (80) can lift him, which matters for reaching the window in the goblins' dungeon (#R$A678), but Elrond (48) cannot. Bard can carry only 16 - enough for the bow and arrow.</p>
<p><b>Strength</b> and <b>defence</b> (bytes 5 and 6) decide fights (#R$90DB) and breaking things (#R$9257). Strength also changes during play: eating adds 10 (#R$9206), the ring divides it by 4 while worn (#R$A2C0), falling in the dark halves it (#R$8D19), and wounds reduce both.</p>
<p><b>Side</b> (bits 4-6 of byte 4) decides who can capture whom (#R$A316): a capture is only possible if the two characters have no side bits in common. Bilbo and his friends are side 1, the goblins and Gollum side 2, the wood elf and the butler side 4. Elrond has bits for both side 1 and side 4, so neither the elves nor Bilbo's party can capture him. The dragon, the warg and the trolls have no side at all, so anyone can capture them and they can capture anyone.</p>
<p><b>Refuses orders</b> is the chance of a SAY TO being answered with "no" (#R$8F9E), from byte 6 of the character-table entry (shown in brackets). Higher values mean fewer refusals; 0 means the character always obeys - so the goblins, the warg and even the dragon will do what they are told.</p>
<p><b>Active from</b>: the butler, Bard and the dragon have empty slots in the character table until Bilbo reaches the places shown; until then they do nothing at all.</p>
""")
fact('capture2','Bilbo cannot capture anyone',
 "There is a CAPTURE action (action 48, #R$A316), and the rules would let Bilbo capture a goblin. But in the dictionary CAPTURE is a synonym for ATTACK (#R$6040), so the tokeniser (#R$6E8E) turns 'capture goblin' into 'attack goblin' before the parser sees it, and action 48 can never be reached from the keyboard - not even by ordering another character, because orders are typed too. Only the characters' own behaviour programs (#R$C71C), which use action numbers directly, ever capture anyone. In the emulator, 'capture goblin' gives 'you attack the disgusting goblin.' - and the goblin captures Bilbo instead.")
import shutil
pass
A[0x9F89]['desc']=["For object A: if it is closed and not dead (bits 3 and 5 of the flags clear), or holds nothing visible, a new line is printed and the routine returns with carry set. Otherwise, for a character, 'X is carrying'; for anything else a heading chosen by the low four bits of byte 4 of the object's record, from the message at $AEBD: IN (0), ON (1), BEHIND (2), UNDER (3) or TIED TO (4), followed by 'there is' or 'there are' - so 'behind the heavy curtain there is a wall' and 'under the trap door there is the goblins cache'."]
fact('goldenkey','The golden key opens nothing',
 "A golden key lies at the end of a dead-end path in the deep misty valley (room 79). The key check (#R$A26A) only recognises the small curious key, the large key and the red key, and no object has a handler that accepts the golden key, so it opens nothing at all. The front door of Bag End cannot be locked or unlocked with any key either: its handler always replies 'the key does not fit this lock'.")
fact('cache','The small curious key is buried three deep',
 "In the goblins' dungeon, the small curious key is inside the goblins' cache, which is under a trap door, which is buried in the sand. Digging opens the sand (#R$8FCF); the trap door is locked, and no key fits it (#R$A26A), so it has to be broken open (#R$9257).")
fact('unuseddesc','An unused room description',
 "Among the messages is 'a bewitched gloomy place surrounded by thick trees' ($B4EF), a full description for room 25. Nothing in the game refers to it: the room record's description pointer is 0, so the room is described just by its three name words ('you are in a bewitched gloomy place').")

# ---- corrections and findings from the emulator tests
A[0x9257]['desc'][-1]=("Then the instrument may break too, whether or not the target did: its defence plus a random number from -21 to +21 is compared with the target's defence, and if it is at least as large the instrument breaks. As written, this makes a tougher instrument more likely to break. Worse, the addition has the same carry-flag mistake as the fight code (#R$917D): a negative random number sets the carry, which is taken as an overflow, and the value becomes 255 - so the instrument breaks whenever the random number is negative. "
 "In 40 test runs in the emulator of BREAK DOOR WITH SWORD against the heavy rock door, the sword broke 9 times; with the bow, whose defence of 16 could never reach the door's 144 honestly, the bow still broke 5 times.")
bug('breakcarry','Breaking something can break the tool for no reason',
 "When something is struck (#R$9257), the instrument's own chance of breaking is worked out with the same faulty overflow test as the fight code (#R$917D): whenever the random adjustment is negative, the total is set to 255 and the instrument breaks. In the emulator, 'break door with bow' against the heavy rock door broke the bow 5 times in 40 tries, although its defence (16 plus at most 21) could never honestly reach the door's 144.")
bug('inin','"you are in in a clearing with two stone trolls"',
 "When the trolls turn to stone (#R$A865), the trolls' clearing is given the description 'in a clearing with two stone trolls'. But the room description routine (#R$958E) always prints 'you are' plus the room's preposition ('in') first, so the game says 'you are in in a clearing with two stone trolls'. Seen in the emulator.")
A[0xAA04]['desc']=["The expiry routine of timer 2 (count 5), started when Bilbo enters the place of black spiders (#R$C6A1). The count drops to 4 at the end of the turn he enters, so it reaches 0 at the end of his fourth turn after that: if he is still in room 26, 'the spider web is slowly smothering you', and he dies. In the emulator, entering and waiting three times, then leaving, is safe; waiting a fourth time is fatal."]
A[0xC6A1]['desc']=["Starts timer 2 (count 5). Bilbo can stay for the turn he arrives and three more; if he is still in room 26 at the end of the next one, the spiders' web smothers him (#R$AA04). The HELP message there is 'don't stay too long.'"]
fact('verified','Checked in the emulator',
 "The following were confirmed by running the game: the fight results and the random-number bug; the pale bulbous eyes (wait twice, move on the third turn); the slurred speech after drinking the wine; the sword lighting dark places; the random hidden route and Gollum's riddle choice; stealing while wearing the ring; the ring dividing strength by 4, losing the remainder, and wearing off after a random number of turns; the deep bog killing at the end of the first turn; the spiders' place allowing the turn of arrival and three more; the trolls eating Bilbo if he stays after they have spoken, and dawn three turns later ('you are in in a clearing with two stone trolls'); the side door appearing for one turn in five after Bilbo has been in the Elvenking's cellar, and the dragon and Bard being switched on there; tools breaking when used to break things; 'capture' being treated as 'attack'. A scripted opening - taking the large key after dawn, unlocking the trolls' cave, taking the sword and rope, and giving the map to Elrond - played exactly as the code predicts, ending with 'elrond examines the curious map. elrond says \"go east from the forest gate to get to the bewitched gloomy place\"'.")
