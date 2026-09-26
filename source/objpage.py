rows=[ (l.split('|')+[''])[:8] for l in open('/tmp/objs.txt').read().strip().split('\n')]
ACTN={'strike with':'STRIKE','close':'CLOSE','open':'OPEN','look through':'LOOK THROUGH','go through':'GO THROUGH','lock with':'LOCK','unlock with':'UNLOCK','throw through':'THROW THROUGH','examine':'EXAMINE','put in':'PUT IN','drop in':'DROP IN','look across':'LOOK ACROSS','swim':'SWIM','wear':'WEAR','take off':'TAKE OFF','throw across':'THROW ACROSS','tie to':'TIE TO','pull':'PULL','fill with':'FILL','empty':'EMPTY','jump onto':'JUMP ONTO','climb into':'CLIMB INTO','drink':'DRINK','dig':'DIG','take out of':'TAKE OUT OF','eat':'EAT'}
out=[]
for r in rows:
    n,name,k,holder,locs,st,fl,hs=[x.strip() for x in r]
    size,wt,attr,s,d=st.split()
    acts=[]
    for h in hs.split(' ; '):
        h=h.strip()
        if not h: continue
        a,ad=h.rsplit(':',1)
        if a=='+' or ad=='0000': continue
        lab=ACTN.get(a,a.upper())
        if lab not in [x.split(' (')[0] for x in acts]: acts.append('%s (#R$%s)'%(lab,ad))
    locs=locs.replace('0 ?','nowhere (location 0)')
    out.append('<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>'%(n,name,locs,holder,size,wt,s,d,fl.replace('visible','').strip() or '-',', '.join(acts) or '-'))
page="""[Page:Objects]
PageContent=#INCLUDE(ObjectsText)

[PageHeaders]
Objects=The objects

[Links]
Objects=The objects

[ObjectsText]
<p>Every object that is not a character, with its starting position and values, from the object records at #R$C00B. 'Places' lists the room (or rooms, for doors and rivers that belong to two or more places) the object is in; 'Held by' is the object or character holding it. The last column lists the actions the object has its own handlers for; anything else falls back on the default handlers (#R$C61F).</p>
<table>
<tr><th>No.</th><th>Object</th><th>Places</th><th>Held by</th><th>Size</th><th>Weight</th><th>Strength</th><th>Defence</th><th>Flags</th><th>Own handlers</th></tr>
"""+'\n'.join(out)+"""
</table>
<h2>What the numbers mean</h2>
<p><b>Size</b> (byte 2) is how much room the object takes up in a container (#R$91B9) or a room, or when passing through a doorway; for a container it is also how much it can hold. <b>Weight</b> (byte 3) decides whether it can be lifted (#R$8C86). A size and weight of 255 marks a fixture - doors, the cupboard, the curtain - that can never be picked up. The stone (254) is too heavy for anyone except the wood elf (capacity 255).</p>
<p><b>Strength</b> and <b>defence</b> matter when the object is used as a weapon or is broken (#R$90DB, #R$9257): the sword (64/128) is the best weapon; the bow and arrow are weak as clubs (16/16) but deadly when SHOT (#R$8FE0); doors with a defence of 0 cannot be broken at all.</p>
<p><b>Flags</b> (byte 7): <i>locked</i>, <i>pours</i> (a liquid: it can be drunk or poured, and evaporates if dropped), <i>full</i>, <i>broken</i>, <i>on</i> (the sword glows, #R$954D; the torches burn), <i>open</i>. Every object starts visible except the side door of the Lonely Mountain, which only appears now and then (#R$A985).</p>
<p><b>Byte 4</b> (not shown) says how an object's contents are described (#R$9F89): in (0), on (1), behind (2), under (3) or tied to (4) - 'behind the heavy curtain there is a wall', 'under the trap door there is the goblins cache'. Bit 7 is set for the window, which Bilbo cannot climb through unaided (#R$A678).</p>
<h2>Notes</h2>
<p>Objects 21, 22 and 38 start at location 0, which is nowhere: they are spares. The water and black water are brought into play when a container is filled from a river (#R$8ED3), and the lunch when Elrond hands it over (#R$A8D9).</p>
<p>The small curious key is hidden three deep in the goblins' dungeon: inside the goblins' cache, which is under a trap door, which is buried in the sand. DIG opens the sand (#R$8FCF). The trap door is locked, and its UNLOCK handler (at $A288 in #R$A26A) always answers 'the key does not fit this lock', so the only way in is to break it.</p>
<p>The round green door's LOCK and UNLOCK handlers give the same 'does not fit' reply: Bag End's front door cannot be locked or unlocked with any key.</p>
<p>The golden key (object 43) lies in the deep misty valley (room 79), at the end of a dead-end path. No lock in the game accepts it - the key check (#R$A26A) only knows the small curious key, the large key and the red key - so it opens nothing.</p>
"""
open('/home/claude/sk/hobbit-objects.ref','w').write(page)
