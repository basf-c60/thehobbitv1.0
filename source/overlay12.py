# Batch 12: proofreading corrections
from overlay import A, blk
from overlay3 import fact, bug
from overlay9 import C
import overlay4

def fix(addr, old, new):
    d=A[addr]['desc']; hit=False
    for k,p in enumerate(d):
        if old in p: d[k]=p.replace(old,new); hit=True
    assert hit,(hex(addr),old)

# bit 6 of a frame's verb marks an EXCEPT frame, not a quotation
fix(0x7C4F,"bit 6 of byte 1 marks a frame that belongs to a quotation and bit 7 marks ALL EXCEPT","bit 7 of byte 1 marks a command with ALL, and bit 6 marks an extra frame that only holds an exception for ALL EXCEPT")
A[0x7F69]['desc']=["Returns IX = IY - 24: the frame after the current one in parse order (frames are built downwards from #R$B8B8). Frames that only hold an exception for ALL EXCEPT (bit 6 of byte 1) are skipped. Continues into #R$7F6F at $7F73."]
A[0x7F6F]['desc']=["Returns IX = IY + 24: the frame before the current one in parse order, skipping ALL EXCEPT exception frames (bit 6 of byte 1). The entry at $7F73 is shared with #R$7F69, which uses -24 instead."]
C(0x7F6F,{0x7F79:'Is this an exception frame (bit 6)?',0x7F7D:'Yes: skip over it'})
fix(0x80CD,"A frame that is itself a nested quotation is stored as an empty order.","An ALL EXCEPT exception frame (bit 6) is stored as an empty order.")
fix(0x8351,"skipping frames that belong to quotations","skipping the exception frames of ALL EXCEPT")

# room record bytes 0 and 1
i=[k for k,p in enumerate(A[0xB97A]['desc']) if p.startswith('Byte 0: flags')][0]
A[0xB97A]['desc'][i]="Byte 0: flags ($86). Bit 7 means the room is lit; bit 6 is set once Bilbo has visited it (#R$8D19); bits 1-3 choose the preposition used to describe it (#R$B970): here 3, ON. Byte 1: the room's capacity, used when something tries to move in (#R$9B96); $FF means unlimited."

# the character table
A[0xC9BA]['desc'][-1]=("#LIST { $C9BA: $3E Gandalf } { $C9C1: $3F Thorin } { $C9C8: $40 the wood elf } { $C9CF: $43 the warg } { $C9D6: empty until Bilbo enters Beorn's house, then $42 the butler (#R$C693) } { $C9DD: $41 Elrond } { $C9E4: $44 Gollum } "
 "{ $C9EB: empty until Bilbo enters the Elvenking's cellar, then $46 Bard (#R$C6AF) } { $C9F2: empty until then, then $3C the dragon } { $C9F9, $CA00: $47 and $48 the trolls } { $CA07-$CA2A: $3D, $45, $4B, $49, $4A and $4C, the goblins } LIST#"
 " Byte 6 of each entry decides how often the character refuses an order given with SAY TO (#R$8F9E); despite what one might expect, higher values mean fewer refusals, and 0 means it never refuses. The values are: Gandalf 5, Thorin 6, Elrond 5, Bard and Gollum 3, the wood elf, the butler and the trolls 1, and the goblins, the warg and the dragon 0.")

# the '@' key
fix(0x6E71,"If the flag at $B60A is set (it is set by the command code at $8765, and appears to mean that the previous input has not been completely dealt with), the '@' is thrown away","If the game is waiting for the answer to a question such as 'which key?' (the flag at $B60A, set by #R$8765), the '@' is thrown away")

# start-up and the separator line
A[0x6DC3]['title']='Window separator pattern'
A[0x6DC3]['desc']=["Five pairs of bytes, one pair for each of five pixel lines. At start-up (#R$6C27, from $6CC7) each pair is repeated 16 times across the screen at $5140, drawing the patterned bar that separates the story window from the input window below it."]
fix(0x6C27,"The routine then draws the decorative frame (a 16x5 pattern from #R$6DC3 copied to the screen at $5140)","The routine then clears the screen (#R$6FCA), draws the bar that separates the story window from the input window (a 5-line pattern from #R$6DC3, repeated across the screen at $5140), sets the line counter used by the story window's pause (#R$7694) to 17, and, if this is a fresh start (the frame count at $B5F7 is $FF, as it always is after the variables are restored), makes the game's random choices (#R$970B)")

# LOAD and the hidden route
A[0x8209]['desc'].append("Two things live outside the four blocks. The three bytes of Bard's current order are handled specially (see #R$8284). But the address of the hidden route chosen at the start of the game is not saved at all: #R$970B writes it into the code of Elrond's map routine (the operand at $A6C5), not into the saved data.")
bug('loadroute','A loaded game can lose its hidden route',
 "The hidden route closed at the start of a game (#R$970B) is recorded in two places: the blanked-out exit in the room table, which SAVE and LOAD preserve, and the address of the route's entry, which is written into the instruction at $A6C3 in Elrond's map routine (#R$A6B8) and is not saved. If a game is loaded in a later session, the room table closes the old route but Elrond's routine points at the route chosen for the new session. When he reads the map he reopens (and names) the wrong exit, and the loaded game's closed route stays closed. (This follows from the code; it was not tried in the emulator.)")

A[0x87AD]['desc']=[
 "Called when #R$8405 did not settle on exactly one workable target, to explain why - or to make the best of it. Inside a quotation (an order to a character) it says nothing at all and returns, so characters are not given the player's excuses.",
 "If exactly one candidate target would work, the instrument is dealt with instead (#R$8789). Otherwise the target's flags at $832E decide:",
 "#LIST { No noun was given ($8821): the words of the action are pushed and, if nothing suitable could be found at all, 'i see nothing to open' is printed; if there was something, the command is left unfinished (#R$8765) and the game asks 'open what?', so that the next thing typed completes it. } "
 "{ A noun was given but nothing matching it was found ($87EF): the search is widened - first to the rooms leading off this one (#R$9DE9, for commands such as GO INTO), then to every object anywhere (#R$9D2E with the filter set to 2) - so that something the player has named but cannot use is still recognised. If it is found, it is made the target and the action is reported as a failure (#R$7111, 'you cannot open the door'); if not, 'i do not see the door here'. } "
 "{ Several candidates fit the words: 'which key?' (#R$8774), again leaving the command unfinished. } "
 "{ Exactly one candidate, or none, but the action would not work with it: the action is carried out for real anyway ($87E6), so that its own handler prints the proper reason. } LIST#"]
A[0x8789]['desc']=["The instrument's counterpart of #R$87AD, using the flags at $832F: no noun given goes to #R$883E ('unlock the door with what?'), a noun that matched nothing widens the search as for the target, and if exactly one instrument would work the action is simply carried out."]
A[0x8774]['desc']=["When the noun fits more than one object and more than one of them would work, the game asks 'which key?' ($ACC0, with the noun pushed as the parameter) and leaves the command unfinished (#R$8765), so that the player's next words - 'the small one', 'curious' - are fitted into it (#R$7CC0)."]
A[0x883E]['desc']=["The instrument's counterpart of the end of #R$87AD. If nothing was found to match the words, 'i see nothing to unlock the door with'. Otherwise the command is left unfinished (#R$8765) and the game asks 'unlock the door with what?' ($ACB4), so the player can simply answer 'the key'. The words of the question are pushed by #R$8869."]

# ---- the DO bug
A[0x8009]['desc']=["Looks the special word up in the table at #R$8029 and jumps to its handler. DE (the word's class and the parser's state) is saved on the stack at $800C and restored at $8027 before the jump.",
 "If the word is not in the table, the jump at $801C goes back into the parser WITHOUT restoring DE, leaving two bytes on the stack. Every special word except DO is in the table, so in practice this happens only when the player types DO - and then the game loses control completely (see the bug note).",
 "The special words are ALL, EXCEPT, IT, ONE, the game commands PRINT, NOPRINT, LOAD, SAVE, QUIT, HELP, SCORE and PAUSE, and a quotation mark (which has class $90 and a word of 0, and matches the first entry, #R$80CD)."]
C(0x8009,{0x8009:'HL = the table of special words',0x800C:'Save the class and the parser state...',0x800D:'Thirteen entries to check',
 0x800F:'Compare the low byte of the word',0x8010:'',0x8011:'',0x8012:'No match: next entry',0x8014:'Compare the high nibble',0x8015:'',0x8016:'Found it',
 0x8018:'Next entry',0x8019:'',0x801A:'',
 0x801C:'Not in the table: carry on parsing - but DE is never restored, so two bytes are left on the stack (see the bug note)',
 0x801F:'Found: the handlers are 25 bytes further on',0x8022:'',0x8023:'HL = the handler',0x8024:'',0x8025:'',0x8026:'',0x8027:'...restore the class and state',0x8028:'Jump to the handler'})
bug('doword','Typing DO makes the game run wild',
 "DO is a word in the dictionary, in the same class as ALL, IT, HELP and SAVE, and it comes just before DOOR - so any abbreviation of two letters, such as 'op do', matches DO and not DOOR. But DO is the only word of that class with no entry in the table at #R$8029, and the 'not in the table' path of #R$8009 jumps back into the parser without restoring the DE it pushed. Two bytes are left on the stack, so when the parser returns it takes that pushed value as its return address and jumps into the middle of the game's code.",
 "What the player sees is a stray 'what ?', then a fatal blow with nobody named - 'with one well placed blow you cleave his skull' - and then the rivers, the water and other objects 'evaporating' one after another, as the runaway code works through the object table. Nothing has really been attacked: the Z80 is executing whatever it finds.",
 "Traced in the emulator: entering the parser SP is $5EFD, and after DO has been rejected it is $5EFB. 'do', 'op do' and 'attack do' all do it; 'open door', with the noun spelled out to at least three letters, is fine.")
