# Batch 8: location pictures
import sys,re; sys.path.insert(0,'/home/claude/sk')
from overlay import A, blk
from overlay3 import fact, bug
from overlay4 import EXTRA_REGIONS
import pic
m=pic.m; B=pic.B; rb=pic.rb
sk=open('/home/claude/sk/hobbit.skool').read()
RN={}
for mm in re.finditer(r'; [{]?Room ([0-9/]+): ([a-z ]+)$',sk,re.M):
    for r in mm.group(1).split('/'): RN.setdefault(int(r),mm.group(2).strip())
i=0xCC00; pics=[]
while rb(i)!=0xFF: pics.append((rb(i),rb(i+1)|rb(i+2)<<8)); i+=3
ps=sorted(pics,key=lambda x:x[1])
SHARED={13:31,5:28}
totals={'line':0,'move':0,'fill':0,'paint':0}
for k,(r,p) in enumerate(ps):
    e=ps[k+1][1] if k+1<len(ps) else 0xF35B
    cmds,a,st=pic.decode(p,e)
    for kk in st: totals[kk]+=st[kk]
    subs=[]
    for (ad,ln,t) in cmds:
        if ad+ln>e:   # command straddles into the next picture
            subs.append(('B',ad,e-ad,'Move: the two coordinate bytes are the header of the next picture, and drawing carries on into it'))
            break
        subs.append(('B',ad,ln,t))
    img='#HTML[<img src="../images/pictures/room%02d.png" alt="room %d">]'%(r,r)
    desc=['The picture for room %d (%s). It is %d bytes long: %d lines, %d moves, %d fills and %d painted areas. See #R$8985 for the format.'%(r,RN.get(r,'?'),e-p,st['line'],st['move'],st['fill'],st['paint']),img]
    if r in SHARED:
        desc.append('This picture has no end marker. Its last command is a move whose two coordinate bytes are the first two bytes (the colours) of the picture that follows, for room %d, so after drawing its own few details it carries straight on and draws the whole of that picture too, in its own colours. Two locations get pictures for little more than the price of one.'%SHARED[r])
    if r==5:
        desc.append('At the start of a game the first two bytes are set to 0 (black), and at dawn (#R$A865) they become 5 and $28 (cyan), so the clearing is drawn by night until the trolls have been turned to stone, and in daylight afterwards. The daylight version:')
        desc.append('#HTML[<img src="../images/pictures/room05_day.png" alt="room 5 by day">]')
    blk(p,'b','Picture: room %d (%s)'%(r,RN.get(r,'?')),desc,subs=subs)
    EXTRA_REGIONS[p]=e
blk(0xF35B,'u','Unused',["Zeroes to the end of the code block at $F3FF."])
EXTRA_REGIONS[0xF35B]=0xF400
CC00_DESC=["3-byte entries: room number and the address of the picture for that room (#R$8985), terminated by $FF. Only 22 of the 80 locations have pictures: rooms "+', '.join('%d (%s)'%(r,RN.get(r,'?')) for r,p in pics)+".",
 "Between them the 22 pictures use %d lines, %d moves, %d flood fills and %d painted areas, in about 10,000 bytes."%(totals['line'],totals['move'],totals['fill'],totals['paint'])]
A[0x8985]['desc'].append("A picture normally ends with a 0. Two pictures (rooms 13 and 5) instead end with a move command whose coordinate bytes are the colour bytes of the next picture in memory, so they go on to draw that picture as well (see #R$E02C and #R$E142).")
fact('sharedpics','Two pictures borrow other pictures',
 "The goblins' dungeon (room 13) and the trolls' clearing (room 5) have tiny pictures of their own - 29 and 93 bytes - which end not with an end marker but with a 'move' command. The two bytes it reads as coordinates are really the colour bytes at the start of the next picture in memory, and drawing simply carries on through that picture: the dungeon borrows the Elvenking's dungeon (room 31), and the trolls' clearing borrows room 28. The borrowed drawing comes out in the borrower's colours, so the two pairs do not look like the same picture at first glance.")
fact('vector','The pictures are line drawings with fills',
 "Every location picture is drawn at run time from a list of commands (#R$8985): lines with fixed slopes, moves, flood fills and blocks of colour. The 22 pictures contain over 3,000 line segments and take up about 10K; as bitmaps they would have needed about 60K, more than the whole Spectrum. Drawing them takes long enough to watch, which is why the game waits for a key afterwards.")

# gallery page
with open('/home/claude/sk/hobbit-pics.ref','w') as f:
    f.write('[Page:Pictures]\nPageContent=#INCLUDE(PicturesText)\n\n[PageHeaders]\nPictures=Location pictures\n\n[Links]\nPictures=Location pictures\n\n[Index:Reference:Reference]\nHowItWorks\nMap\nPictures\nCharacters\nObjects\nFacts\nBugs\nPokes\nGlossary\n\n[PicturesText]\n')
    f.write('<p>The 22 location pictures, rendered by running the game\'s own drawing routine (#R$8985) on each picture\'s data in a Z80 emulator. Click an address to see the picture\'s commands decoded one by one.</p>\n')
    for r,p in sorted(pics):
        f.write('<h3>Room %d: %s (#R$%04X)</h3>\n<p><img src="images/pictures/room%02d.png" alt="room %d"></p>\n'%(r,RN.get(r,'?'),p,r,r))
        if r==5: f.write('<p>By day (after the trolls have turned to stone):</p>\n<p><img src="images/pictures/room05_day.png" alt="room 5 by day"></p>\n')
