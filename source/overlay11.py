# Batch 11: loose ends - object byte 4, allies, the same-place shortcut, the score
from overlay import A, blk
from overlay3 import fact, bug
from overlay9 import C

i=[k for k,p in enumerate(A[0xC00B]['desc']) if p.startswith('Bytes 2-4')][0]
A[0xC00B]['desc'][i]="Byte 2: size. Byte 3: weight, which for a character is also how much it can carry. Byte 4: attributes, used in three ways. Bits 0-3 say how the object's contents are described (#R$9F89): 0 in, 1 on, 2 behind, 3 under, 4 tied to; only contents 'in' or 'on' something fall out when it is broken (#R$9257). Bits 4-6 are the character's side (1 Bilbo and his friends, 2 goblins and Gollum, 4 elves; Elrond has both 1 and 4): characters on the same side cannot attack or capture each other (#R$90B4, #R$A316). Bit 7, on a door or window, means Bilbo cannot pass through it unaided (#R$8D19)."
i=[k for k,p in enumerate(A[0xC00B]['desc']) if p.startswith('Byte 7')][0]
A[0xC00B]['desc'][i]="Byte 7: flags. Bit 0 locked; bit 1 'pours' (a liquid, which evaporates when dropped); bit 2 full; bit 3 broken (for a character: dead); bit 4 on (lit); bit 5 open; bit 6 alive (a character); bit 7 visible. The words for these states come from the tables at #R$A13B: LOCKED/UNLOCKED, FULL/EMPTY, BROKEN, ON/OFF, OPEN/CLOSED, ALIVE/DEAD."

A[0x90B4]['title']='Check that a target may be attacked (sides)'
A[0x90B4]['desc']=["Characters on the same side do not fight each other. The target's side bits (4-6 of byte 4 of its record) are compared with the attacker's; if they have any in common, the attack is quietly ruled out: the 'would work' flag is cleared and the attack routine's caller is abandoned.",
 "But the player is allowed to attack a friend. When Bilbo is the attacker and the target is on his side (bit 4), that bit is cleared in the target's record first - permanently. So hitting Thorin or Gandalf takes them off Bilbo's side for the rest of the game, which is what lets them fight back (and, since no one is on the same side any more, lets other characters attack them too)."]
C(0x90B4,{0x90B4:'IX = the target\'s record',0x90B8:'Is the attacker Bilbo?',0x90BB:'',0x90BC:'No: just compare sides',
 0x90BE:'Is the target on Bilbo\'s side (bit 4)?',0x90C2:'No',0x90C4:'Yes: it is not any more - for good',
 0x90C8:'A = the target\'s side bits...',0x90CB:'',0x90CD:'IX = the attacker\'s record',0x90D1:'...in common with the attacker\'s?',0x90D4:'None: the attack may go ahead',
 0x90D5:'Same side: drop the caller\'s return address...',0x90D6:'...and record that the attack would not work',0x90D7:'',0x90DA:''})
C(0x9257,{0x92BD:'How are the target\'s contents described?',0x92C0:'In (0) or on (1)?',0x92C2:'Then they fall out of the broken container'})
fact('allies','Hitting a friend makes an enemy for good',
 "Characters on the same side never attack each other (#R$90B4). Bilbo can still attack Thorin, Gandalf, Elrond or Bard, but doing so permanently clears their 'Bilbo's side' bit, so from then on they will fight him - and anyone else - like any other character.")

A[0x9D92]['desc']=["Returns with Z reset if the object at IY is visible (bit 7 of its flags) and is in the same place as the object at IX.",
 "Each object's outermost holder is found with #R$9DC8, which returns $FF for an object lying loose in a room and 0 for one that is shut inside something (or held by a living character). If the results differ, the objects are not together. If both are loose, IX's room must be one of IY's locations. If both are 0, the room comparison is skipped and they count as together - see the bug note."]
bug('sameplace','Two things shut in different containers are "together"',
 "#R$9DC8 answers 0 for anything shut inside a closed container, without saying which container, and #R$9D92 then treats two objects that both get the answer 0 as being in the same place, without comparing their rooms. So if Bilbo is shut in the barrel, anything else shut away anywhere in the game counts as within reach. In the emulator, with Bilbo in the closed barrel in the Elvenking's cellar and the sword locked in the closed wooden chest at Bag End, 'take sword' gave 'you take the short strong sword.' With the barrel open, it gave 'I do not see the sword here'.")

fact('score75','The best possible score is 75%',
 "The score (at $B5E8, in tenths of a percent) is set to 0 at the start of a game and changed in exactly one place: the movement routine, when Bilbo first enters one of the fourteen rooms in the points table (#R$8CEA), which add up to 75.0%. Nothing else scores - not killing the dragon, not finding the treasure, not even winning. A perfect game ends with 'you have mastered 75.0% of this adventure'.")
A[0x8CEA]['desc'][-1]="Together they are worth 75%, and nothing else in the game adds to the score, so 75.0% is the most anyone can achieve. Being captured and thrown into a dungeon counts as a visit, so both dungeons score."
fact('ringbrawl','Why Thorin and Gandalf fight when an invisible Bilbo hits Thorin',
 "Three rules combine. Hitting Thorin clears his 'Bilbo's side' bit for good (#R$90B4), so he no longer shares a side with Gandalf. Being attacked switches Thorin to the general fight-back program (#R$C71C, at $C94D), whose first instruction is simply 'attack', leaving the game to choose the target as it does for the player (#R$8405). And the choice only considers things Thorin can see (#R$9D92, which needs bit 7 of the candidate's flags): with the ring on, Bilbo is invisible, so the only candidate is Gandalf. Once Gandalf has been attacked he switches to the same fight-back program, and since Thorin is no longer on his side he can attack Thorin - and they carry on until one of them dies. In the emulator, with the ring kept on and Gandalf held in the room, 'hit thorin' was followed by 'thorin attacks gandalf. gandalf attacks thorin...' every time, ending in one case with 'with one well placed blow gandalf cleaves his skull. thorin is dead.'")
