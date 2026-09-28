# Batch 7: the characters' behaviour programs
import sys; sys.path.insert(0,'/home/claude/sk')
from overlay import A, blk
from overlay3 import fact, bug
from overlay4 import EXTRA_REGIONS
import beh

chars,rt,seen=beh.trace()
NAMES={0xC7A9:'Gandalf',0xC7DB:'Thorin',0xC80C:'the wood elf',0xC817:'the warg',0xC83F:'the butler',0xC889:'Elrond',0xC8A7:'the dragon',0xC8CD:'Bard',0xC8E6:'Gollum',0xC92A:'the trolls',0xC731:'the nasty and hideous goblins',0xC760:'the vicious goblin',0xC784:'the horrible, mean and disgusting goblins'}
RTN={0xC790:'Gandalf',0xC7D1:'Thorin',0xC802:'the wood elf',0xC813:'the warg',0xC835:'the butler',0xC87F:'Elrond',0xC8A0:'the dragon',0xC8C6:'Bard',0xC8DF:'Gollum',0xC923:'the trolls',0xC71C:'the nasty and hideous goblins',0xC723:'the vicious goblin',0xC72A:'the horrible, mean and disgusting goblins'}
subs=[]; mid={}
items=[]
PHRASE={'attack with':'when it is attacked','give to':'when it is given something','capture':'when it is captured'}
tables=[]
for r,(ent,end) in sorted(rt.items()):
    for k,(act,a) in enumerate(ent):
        if act==0: lab='default behaviour (also one of the choices for a random one): program at $%04X'%a
        else:
            nm=beh.ACT.get(act,'?')
            lab='%s: switch to the program at $%04X'%(PHRASE.get(nm,'on %s'%nm.upper()),a)
        if r in (0xC71C,0xC723,0xC72A): lab='%s: %s'%(RTN[r],lab)
        items.append((r+3*k,3,lab))
    items.append((end,1,'End of the table'))
    tables.append(r)
for a,(ln,txt,fl) in seen.items():
    t=txt+(' ('+', '.join(fl)+')' if fl else '')
    items.append((a,ln,t))
items.sort()
last=0xC71C
for a,ln,t in items:
    if a>last: subs.append(('B',last,a-last,''))
    subs.append(('B',a,ln,t)); last=a+ln
if last<0xC973: subs.append(('B',last,0xC973-last,''))

# Headings. In memory each character's reaction table comes straight BEFORE its
# program (the goblins' three tables come first, together), so the heading for a
# character goes at the start of its table.
for r in tables:
    if r in (0xC723,0xC72A): continue
    if r==0xC71C:
        mid[r]="The goblins: three reaction tables (one for each kind of goblin), followed by their three behaviour programs."
    else:
        mid[r]="%s: reaction table (how the character reacts when something is done to them), then behaviour program (what they do on their own turns)."%RTN[r].capitalize()
for a,nm in NAMES.items():
    if a in (0xC731,0xC760,0xC784):
        mid[a]="Behaviour program for %s."%nm
    else:
        mid[a]="Behaviour program for %s."%nm
# shared reaction programs
users={}
for r,(ent,end) in rt.items():
    for act,a in ent:
        users.setdefault(a,set()).add(RTN.get(r,'?'))
def _who(a): return ', '.join(sorted(users.get(a,[])))
mid[0xC78D]="The goblins' own reaction to being attacked: capture the attacker, then go back to the normal program."
mid[0xC94D]="Shared reaction program: fight back. Used by %s, and by Bard when he cannot shoot."%_who(0xC94D)
mid[0xC962]="Shared reaction program: what to do when captured. Used by %s."%_who(0xC962)
mid[0xC96E]="Shared reaction program: being given something. Used by %s."%_who(0xC96E)

blk(0xC71C,'b','Character behaviour programs and reaction tables',[
 "The programs that make the characters act on their own, run by #R$976C. Every character has a pointer (in its entry in #R$C9BA) to where it has got to in its program, and a reaction table. Each comment below decodes one instruction.",
 "HOW THE PROGRAMS RUN. On each of its turns a character works through its program until one instruction succeeds; that ends its turn, and next turn it carries on from the following instruction. An instruction that fails either falls through to the next one, or, if it has an 'if it fails go to' address, jumps there, in the same turn. A character gives up after six failures in one turn. 'Go to' instructions do not use up a turn. Actions without a target or instrument let the game choose suitable objects, exactly as it does for the player's commands, so 'attack' means 'attack whoever is here' and 'take' means 'pick up something'.",
 "Instruction formats (the low nibble of the first byte is the type; bit 4 means a failure address follows, bit 5 'once only', bit 6 'no orders from the player here'):",
 "#TABLE(default) { =h Bytes | =h Instruction } { t, action, target, instrument | do an action with those objects ($FF = let the game choose) } { t+1, address, 0 | call a special routine (the routines in $A406-$A91B) } { 4, action | do an action and let the game choose any objects; action $FF means 'do nothing this turn' } { $0E, address | go to } { $0C, action | switch to the reaction for that action } { $0F, n | switch to a randomly chosen entry of the reaction table } { other | switch to the default entry of the reaction table and end the turn } TABLE#",
 "REACTION TABLES are lists of 3-byte entries ending with $FF: an action and a program address. When something is done to a character, the entry for that action (if any) becomes its program (#R$99FB); entries with action 0 are the default behaviours, used by 'switch to a random behaviour'. In memory each character's reaction table comes straight before its program (the goblins' three tables come first, together); the headings below mark where each table and each program begins. Common reactions are shared: $C94D is the general 'fight back' program (attack; attack again; run; repeat, or follow the attacker if it runs), $C96E the response to being given something ('thank you' or 'what do you expect me to do with this?'), and $C962 the response to being captured (go through an exit or door if possible, otherwise run).",
 "WHAT THE CHARACTERS DO:",
 "#LIST { Gandalf ($C7A9) begins by giving Bilbo the curious map and opening the round green door. After that he is a random wanderer: five little routines ($C7B1, $C7BF, $C7C3, $C7C9, $C7CD) chosen at random make him run about, pick things up and ask 'what's this?', drop or give things away, open and close doors, and make small talk. } { Thorin ($C7DB) follows Bilbo whenever he can. When he cannot, he picks up the small curious key if he finds it (saying once 'this was thrains key'), asks 'where's the thief?' if Bilbo is invisible, or runs through his idle routine (#R$A550): wait, 'hurry up', or sit down and sing about gold. } { The wood elf ($C80C) wanders at random capturing anyone it meets, who ends up in the Elvenking's dungeon (#R$A316). } { The warg ($C817) attacks anyone it can; otherwise it follows its prey, or runs around Bilbo howling (#R$A4CA), or runs off. } { The butler ($C83F) acts out the story from the book: he unlocks the red door with the red key, opens it, shuts it and locks it again; he opens a barrel and drinks the wine, closes the barrel, opens the trap door, throws the barrel through it into the river, and closes the trap door - capturing any intruder at every opportunity - and then starts again. } { Elrond ($C889) greets Bilbo when he arrives and gives him lunch (#R$A8D9), and otherwise waits. } { The dragon ($C8A7) sleeps on the treasure until it is taken (#R$A5D5); then, as long as the dragon itself is somewhere lit, each turn there is about a 1 in 6 chance that it descends and burns Bilbo to a crisp, otherwise 'in the distance you see the shape of a monstrous dragon flying after you.' Before that, if Bilbo comes into one of its three rooms it flies to him (#R$A591), speaks (#R$A5BB) and burns him. } { Bard ($C8CD) does nothing on his own: he waits for an order from the player (#R$A79F), and then repeats that order every turn. His reaction to being attacked is to SHOOT ($C8D8). } { Gollum ($C8E6) asks his riddle when he meets Bilbo (#R$A7C6), and kills him if the answer is wrong (#R$A7EA); he mutters about his precious (#R$A81A), paces north and south-west, drops and picks up the golden ring, and if attacked puts the ring on, becomes invisible and runs. } { The trolls ($C92A) wait until Bilbo comes into the clearing and then say their lines (#R$A8B1). After that their program is: try to eat Bilbo, wait, eat, wait, eat, wait, eat, and then dawn (#R$A865), which turns them to stone. So after the trolls have spoken, Bilbo must be out of the clearing on the turns they try to eat him; waiting outside for the new day dawning (as the HELP message says) is the way. } { The goblins patrol set routes (for example $C731: open the small insignificant crack, go up, down, close the crack, south, north), capturing anyone they meet on the way, who ends up in the goblins' dungeon; the last three goblins ($C784) just run about attacking and capturing. } LIST#",
 "One instruction in this area is changed during play: #R$A79F rewrites the instruction at $C8D1 to hold Bard's latest order, which is why SAVE and LOAD take care to save three of its bytes (#R$8284)."],
 subs=subs, mid=mid)
EXTRA_REGIONS[0xC71C]=0xC973


def code(a,end,title,desc):
    blk(a,'c',title,desc); EXTRA_REGIONS[a]=end
code(0xA443,0xA44C,'Character routine: "this was thrains key"',["Thorin says 'this was thrains key' (used once, after he has picked up the small curious key)."])
code(0xA591,0xA5BB,'Character routine: the dragon comes for Bilbo',[
 "If Bilbo is in room 39, 41 or 44 (the dragon's domain) and the dragon (object 60, location at $C033) is somewhere else, the dragon moves to Bilbo's room and 'the dragon enters.'"])
code(0xA5BB,0xA5D5,'Character routine: the dragon speaks',[
 "If the dragon and Bilbo are in the same room: 'well thief your cunning has failed you this time. prepare to die', or, if Bilbo is invisible (he is wearing the ring: bit 7 of his flags at $C012 is clear), 'I may not be able to see you thief but I can still burn you. prepare to die'. The dragon's next instruction is BURN."])
code(0xA5D5,0xA600,'Character routine: the dragon wakes',[
 "Does nothing while the valuable treasure (location at $C4CC) is still in room 41. Once it has been moved, and if Bilbo is out in the open (his room is lit), a random number from 0 to 100 (#R$9BF4) decides: below 80, 'in the distance you see the shape of a monstrous dragon flying after you.'; otherwise 'the dragon descends and in a terrific spout of flames burns you to a crisp.' and Bilbo dies. Because of the skew in the random numbers (#R$9BFD), the fatal result comes up about 16% of the time, every turn, for as long as the dragon lives."])
fact('dragon','Stealing the treasure while the dragon lives',
 "Once the treasure has left the dragon's lair, the dragon's program (#R$A5D5) runs every turn, with roughly a 1 in 6 chance each turn of 'the dragon descends and in a terrific spout of flames burns you to a crisp'. The HELP message in room 41 says it all: 'a living dragon is deadly, look to bard'. Bard, who repeats the last order he was given every turn (#R$A79F), is the answer.")
code(0xA600,0xA614,'Unused routine',["Finds an exit of the actor's room by way of the variant search at $9E6E and, if there is one, removes its three bytes, presumably meaning to seal up a way through once something (perhaps the boat) is no longer there to use. But nothing in the game calls it: it is not wired into any object's handler list, any room-entry handler, or any timer, and no other routine calls or jumps to it. Like #R$A0DE, it appears to be leftover or abandoned code."])
code(0xA614,0xA631,'Handler for the magic door',[
 "When the magic door is examined: if the actor can see it clearly (bit 7 of its flags), 'you see nothing special'. Otherwise timer 5 is started (by copying its reload value) and 'the magic door warns of elves approaching.'"])
code(0xA631,0xA655,'Handler for Thorin: the small curious key shatters',[
 "Attached to Thorin's record. When Thorin is dead (bit 3 of his flags at $C2A8), the small curious key (record at $C091) is marked broken (#R$A0BC) and, if Bilbo can see it, 'the small curious key shatters.'"])
fact('thrainskey','Thorin\'s key dies with him',
 "The small curious key belonged to Thrain, Thorin's father ('this was thrains key', says Thorin when he finds it). If Thorin is killed, a handler attached to him (#R$A631) makes the key shatter - so killing Thorin can make the game impossible to finish.")
code(0xA79F,0xA7C6,'Character routine: Bard remembers his orders',[
 "If Bard has been given an order (#R$8907), it is checked and then written into Bard's own behaviour program: the action ($B5D7), target and instrument ($B5D9, $B5DA) are stored at $C8D2-$C8D4, and the first byte at $C8D1 is set to $42 (an action instruction that cannot be interrupted by orders). From then on Bard carries out that order every turn. So 'say to bard \"shoot the dragon\"' keeps him shooting until it works.",
 "SAVE and LOAD (#R$8284, #R$8209) preserve the three bytes at $C8D1-$C8D3, because the behaviour programs are not otherwise saved; the instrument at $C8D4 is not included."])
bug('bardsave','Bard\'s remembered order is only partly saved',
 "#R$A79F stores Bard's current order in four bytes of his behaviour program ($C8D1-$C8D4: instruction, action, target, instrument). SAVE and LOAD copy only the first three of them (#R$8284, #R$8209), so the instrument of the order (for example the arrow he should shoot with) is not saved; after a LOAD it is whatever it was in the game being played before.")
