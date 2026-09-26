import re,sys
sys.path.insert(0,'/home/claude/sk'); sys.path.insert(0,'/home/claude')
from overlay import A
import overlay2
import overlay3, overlay4, overlay5, overlay6, overlay7, overlay8, overlay9, overlay10, overlay11, overlay12, overlay13, overlay14, overlay15, overlay16, overlay17
from overlay3 import T as TRIVIA, BUGS
EXTRA={}
for mod in (overlay4,):
    EXTRA.update(getattr(mod,'EXTRA_REGIONS',{}))
from dic import parse
B0=24576
m=open('/home/claude/main.bin','rb').read()
def rb(a): return m[a-B0]
def rw(a): return m[a-B0]|m[a-B0+1]<<8
# instruction starts from z80dasm listing (valid for code areas)
istarts=set()
for line in open('/home/claude/dis.txt'):
    t=line.split()
    if t and re.fullmatch(r'[0-9a-f]{4}',t[0]): istarts.add(int(t[0],16))
istarts|={0x6DCD,0x7B15}
# ---- auto blocks
auto=[]
for line in open('/home/claude/sk/auto.ctl'):
    mm=re.match(r'([a-z]) \$([0-9A-F]{4})',line)
    if mm: auto.append((int(mm.group(2),16),mm.group(1)))
auto.sort()
def auto_type_at(a):
    t='b'
    for s,ty in auto:
        if s<=a: t=ty
        else: break
    return t
# ---- dictionaries for naming
D1=parse(0x6040,0x67AF); D2=parse(0x67B0,0x6BEE)
W={s-0x6000:w for s,w,_,_ in D1+D2}
def wref(v): return W.get(v&0xfff)
# ---- extra generated blocks
from dic import parse2, CLASSES
def words_subs(D,end,cls=True):
    subs=[]; names={x[0]-0x6000:x[1] for x in D}
    for i,(s,w,syn,c,b0,b1) in enumerate(D):
        e=D[i+1][0] if i+1<len(D) else end
        t=f'{w}: ${s-0x6000:03X}'
        if cls and syn is None: t+=f', {CLASSES.get(c,hex(c))}'
        if syn is not None: t+=f' = synonym for {names.get(syn,hex(syn))}'
        subs.append(('B',s,e-s,t))
    return subs
A[0x6040]['subs']=words_subs(parse2(0x6040,0x67AF),0x67AF)+[('B',0x67AF,1,'Separator')]
A[0x67B0]=A.pop(0x67B3)
A[0x67B0]['subs']=words_subs(parse2(0x67B0,0x6BEE),0x6BEE,False)
A[0x6BEE]=dict(t='u',title='Unused',desc=['Zero bytes up to the start of the code at #R$6C00.'],regs=[],comments={},subs=[],mid={})
# rooms
roomptr={}
for r in range(80): roomptr.setdefault(rw(0xB8D0+2*r),[]).append(r)
starts=sorted(p for p in roomptr if 0xB97A<=p<0xBF53)
subs=[]
def roomname(p):
    ws=[wref(rw(p+2+2*k)) for k in range(3) if rw(p+2+2*k)]
    ws=[w for w in ws if w]
    return ' '.join(ws[1:]+ws[:1])
for i,p in enumerate(starts):
    e=starts[i+1] if i+1<len(starts) else 0xBF53
    _r=roomptr[p][0]
    _fl=rb(p)
    _info=''
    if _r:
        _DIR={1:'N',2:'S',3:'E',4:'W',5:'NE',6:'NW',7:'SE',8:'SW',9:'U',10:'D'}
        _ex=[];_q=p+10
        while rb(_q)!=0xFF and _q<p+80:
            _d,_dr,_ds=rb(_q),rb(_q+1),rb(_q+2)
            if _ds: _ex.append('%s to %d%s'%(_DIR.get(_d,'?'),_ds,(' through object %d'%_dr) if _dr else ''))
            _q+=3
        _info='. %s, "%s". Exits: %s'%('lit' if _fl&0x80 else 'dark',['outside','inside','in','on','at','?','?','?'][(_fl>>1)&7],', '.join(_ex) or 'none')
    subs.append(('B',p,e-p,'Room %s: %s%s'%('/'.join(map(str,roomptr[p])),roomname(p).lower() or '(no name)',_info)))
if starts[0]>0xB97A: subs.insert(0,('B',0xB97A,starts[0]-0xB97A,''))
A[0xB97A]['subs']=subs
# objects
objs=[];i=0xBF53
while rb(i)!=0xFF: objs.append((rb(i),rw(i+1))); i+=3
A[0xBF53]['subs']=[('B',0xBF53,i-0xBF53+1,'')]
ostarts=sorted(set(p for n,p in objs))
byp={}
for n,p in objs: byp.setdefault(p,[]).append(n)
subs=[]
for k,p in enumerate(ostarts):
    e=ostarts[k+1] if k+1<len(ostarts) else 0xC61F
    ws=[wref(rw(p+8+2*j)) for j in range(4) if rw(p+8+2*j)]
    name=' '.join(w for w in (ws[1:]+ws[:1]) if w).lower()
    subs.append(('B',p,e-p,'Object %s: %s (strength %d, defence %d)'%('/'.join(str(x) for x in byp[p]),name,rb(p+5),rb(p+6))))
A[0xC00B]['subs']=subs
A[0xC61F]=dict(t='b',title='Default action handlers',desc=['3-byte entries: an action number (see #R$AA47) and the routine that carries it out when the object involved has no handler of its own (#R$946F). Terminated by $FF at $C67C.','#TABLE(default) { =h Action | =h Handler } { 1-10 (movement) | #R$8D19 } { 13 DROP | #R$8C45 } { 15 ATTACK | #R$90DB } { 19 TAKE, 59 CARRY | #R$8CC8 } { 23 LOOK | #R$8C2D } { 26 INVENTORY | #R$9055 } { 28 EXAMINE | #R$9344 } { 29 GIVE TO | #R$9308 } { 31 ENTER, 32 GO INTO | #R$8F37 } { 36 RUN | #R$8F17 } { 39 FOLLOW | #R$8F40 } { 42 THROW AT | $8F5F } { 45 BURN | $A232 } { 46 TIE TO | $A178 } { 48 CAPTURE | #R$A316 } { 51 UNTIE | $A1E4 } { 53 TALK TO | #R$8F9E } { 55 CLIMB OUT OF | $A468 } { 58 SHOOT | $8FE0 } { 0 | #R$9A5D } TABLE#','Actions with no entry here and no object handler (OPEN, CLOSE, EAT and so on) can only be done to objects that provide a handler; otherwise the game says "I cannot do that".'],regs=[],comments={},subs=[('B',0xC61F,0x5D,''),('B',0xC67C,1,'End marker')],mid={})
# pictures
pics=[];i=0xCC00
while rb(i)!=0xFF: pics.append((rb(i),rw(i+1))); i+=3
A[0xCA32]=dict(t='u',title='Unused',desc=['Zeroes.'],regs=[],comments={},subs=[],mid={})
A[0xCC00]=dict(t='b',title='Location picture index',desc=[
 "3-byte entries: room number and the address of the data for that room's picture, terminated by $FF. Only 22 of the 80 locations have pictures: rooms "+', '.join(str(r) for r,p in pics)+".",
 "The pictures are drawn with lines and area fills rather than stored as bitmaps, which is how so many fit into memory. At start-up (#R$6C27) the first two bytes of the picture data for room 5 (the trolls' clearing) are set to zero, which looks like resetting a changeable part of that picture."],
 regs=[],comments={},subs=[('B',0xCC00,i-0xCC00+1,'')],mid={})
A[0xCC00]['desc']=overlay8.CC00_DESC
ps=sorted(p for r,p in pics)
_old_cc43=dict(t='b',title='Location picture data',desc=["Drawing commands for the location pictures listed in #R$CC00. The format has not been decoded in this disassembly."],regs=[],comments={},
 subs=[('B',p,(ps[k+1] if k+1<len(ps) else 0xF400)-p,'Picture for room %d'%[r for r,q in pics if q==p][0]) for k,p in enumerate(ps)],mid={})

def split_subs(start,end,points):
    pts=sorted(set([start]+[p for p,_ in points]+[end])); lab=dict(points); out=[]
    for i in range(len(pts)-1):
        out.append(('B',pts[i],pts[i+1]-pts[i],lab.get(pts[i],'')))
    return out
import json as _json
_msgs=_json.load(open('/home/claude/sk/msgs.json'))
def _clean(t):
    t=re.sub(r'\s+',' ',t.replace('\n',' ')).strip()
    return (t[:110]+'...') if len(t)>110 else t
A[0xAC71]['subs']=split_subs(0xAC71,0xB5CB,[(int(k,16),'"%s"'%_clean(v[0]) if v[0] else '') for k,v in _msgs.items()])
A[0xAC71]['desc']=["The game's messages, in the bytecode format interpreted by #R$72D4. Each message below is labelled with its text, obtained by running the game's own message printer on it in an emulator. In the labels, 'you' stands for the actor, 'the thing' for the target of the command, 'the other' for the instrument, and 'word' for a word or object passed as a parameter; the real text changes with who is acting and on what ('you cleave his skull' / 'thorin cleaves your skull').",
 "There are about 180 messages. Almost every byte of this area belongs to a message that the program uses; the one exception is at $B4EF, a fuller description of the bewitched gloomy place ('a bewitched gloomy place surrounded by thick trees') that nothing refers to - room 25 is described by its name words instead."]
A[0xB5CB]['subs']=split_subs(0xB5CB,0xB60F,[(0xB5D8,'Movement direction and other command variables'),(0xB5DA,'Weapon object number'),(0xB5DB,'Current actor'),(0xB5DC,'Backed-up variables (28 bytes)'),(0xB5F8,'Target, weapon and actor record addresses'),(0xB5FE,'Random seed and state')])
A[0xB628]=dict(t='b',title='Orders buffer and command frames',desc=['$B628: the orders buffer, eight 25-byte slots holding commands given to characters in quotation marks (#R$80CD, #R$88A7), cleared at start-up. Below $B8D0 are the 24-byte command frames built by the parser, the first at #R$B8B8 and the rest below it (#R$7C4F).'],regs=[],comments={},subs=split_subs(0xB628,0xB8D0,[(0xB628,'Orders buffer'),(0xB8B8,'First command frame')]),mid={})


# explicit extents of data regions I define
regions={0x6000:0x6040,0x6040:0x67B0,0x67B0:0x6BEE,0x6BEE:0x6C00,0x728C:0x72BA,0x7815:0x7B15,0x9190:0x91B0,0xAC31:0xAC71,0xAC71:0xB5CB,
 0xB5CB:0xB8D0,0xB8D0:0xB970,0xB97A:0xBF53,0xBF53:0xC00B,0xC00B:0xC61F,0xC67D:0xC693,0xC973:0xC9BA,0xC9BA:0xCA32,0xCA32:0xCC00,0xCC00:0xCC43,
 0x7B6B:0x7B74,0x7B74:0x7B86,0x7B86:0x7BEE,0x7BEE:0x7C16,0x7C16:0x7C3E,0x7C3E:0x7C4F,0x6FE9:0x6FF0,0x6FF0:0x7071,0x7071:0x7093,0x7093:0x70D3,0x70D3:0x70D9,0x7288:0x728C}
regions.update(EXTRA)
regions[0xB5CB]=0xB60F; regions[0xB628]=0xB8D0

# action table
acts=[]
for n in range(1,60):
    a=0xAA3F+8*n; ws=[rw(a+2*k) for k in range(4)]
    acts.append(('B',a,8,'Action %d: %s'%(n,' '.join((wref(w) or '') for w in ws if w&0xfff).lower())))
A[0xAA47]=dict(t='b',title='Action table',desc=[
 "The 59 actions the game knows, 8 bytes each, numbered from 1 (#R$70DF works out the address). Each entry is four word references, low byte first: the verb, a particle, a preposition, and a fourth word (GO for the ten movement actions). The parser's command is matched against these by #R$858F, so an action is really a verb plus the little words that go with it: TAKE, TAKE OUT OF, TAKE FROM and TAKE OFF are four different actions.",
 "The top nibble of each word's high byte holds flags (collected by #R$70EA and decoded by #R$8569): whether a target and an instrument are needed, whether they can be rooms, whether the action can be done in the dark, and how it is reported.",
 "Only the verbs appearing here do anything. Any other verb in the dictionary (WAIT, JUMP, SING...) just produces 'you wait. time passes...' (#R$858F)."],
 regs=[],comments={},subs=acts,mid={})
regions[0xAA47]=0xAC1F
A[0xAC1F]=dict(t='b',title='Articles',desc=["#R$7436 uses these to put an article in front of a noun. The first two bytes are unused. At $AC21: THE, A, AN, SOME (chosen by flag bits in the noun's reference); at $AC29: THE, THE, THE, SOME (used when a definite article is wanted)."],regs=[],comments={},subs=[('B',0xAC1F,2,''),('W',0xAC21,8,'THE, A, AN, SOME'),('W',0xAC29,8,'THE, THE, THE, SOME')],mid={})
regions[0xAC1F]=0xAC31
A[0xB970]=dict(t='w',title='Room prepositions',desc=['The words used by #R$958E to say where Bilbo is: OUTSIDE, INSIDE, IN, ON and AT. Bits 1-3 of the first byte of a room record choose one, so room 2 (flags $86) gives "you are ON the forest road". Bit 7 of the same byte says whether the room is lit.'],regs=[],comments={},subs=[('W',0xB970,10,'')],mid={})
regions[0xB970]=0xB97A
# code blocks auto missed (never executed in my test runs)
for a in (0xA9FF,0xC6A1,0xC6A8,0xC6AF,0xC6D9):
    if a not in A: A[a]=dict(t='c',title='',desc=[],regs=[],comments={},subs=[],mid={})
regions[0xC6A1]=0xC6CC; regions[0xC6D9]=0xC6EB
pass
pass
pass
pass
A[0xA9FF].update(title='Timer routine',desc=['Clears the flag at $B5F1.'])
# ---- build block list
blocks={}
for s,t in auto: blocks[s]=t
for s,e in regions.items():
    for a in list(blocks):
        if s<=a<e: del blocks[a]
for a,d in A.items(): blocks[a]=d['t']
# ensure a block starts at each region end
for s,e in regions.items():
    if e not in blocks and e<0xF400:
        # type of what originally covered e
        blocks[e]=auto_type_at(e) if e not in A else A[e]['t']
# the area C700-C973 (after the handlers) keep auto; C973 etc defined
AUTO={}
import os
if os.environ.get('AUTOCOM'):
    import autocom
    for blkd in autocom.parse_blocks(): istarts|=set(x[0] for x in blkd['ins'])
    for blkd in autocom.parse_blocks():
        AUTO[blkd['a']]=autocom.comment_block(blkd['ins'])
out=['@ $6000 start','@ $6000 org']
bad=[]
for a in sorted(blocks):
    if a>=0xF400: continue
    t=blocks[a]
    d=A.get(a)
    title=d['title'] if d else ''
    out.append(f'{t} ${a:04X} {title}'.rstrip())
    if not d and a in AUTO:
        for ca,cm in sorted(AUTO[a].items()):
            if cm and ca in istarts|set(AUTO[a]): out.append(f'C ${ca:04X} {cm}')
    if d:
        for p in d['desc']: out.append(f'D ${a:04X} {p}')
        for r in d['regs']: out.append(f'R ${a:04X} {r}')
        for (dr,sa,ln,cm) in d['subs']:
            if ln<=0: continue
            per = 8 if dr=='B' else 1
            if dr=='B' and ln<=16: per=ln
            spec=f'{ln}' if dr=='W' else f'{ln},{per}'
            out.append(f'{dr} ${sa:04X},{spec} {cm}'.rstrip())
        for na,nt in sorted(d.get('mid',{}).items()):
            out.append(f'N ${na:04X} {nt}')
        cms=dict(AUTO.get(a,{}))
        cms.update(d['comments'])
        for ca,cm in sorted(cms.items()):
            if not cm: continue
            if t=='c' and ca not in istarts: bad.append(hex(ca)); continue
            out.append(f'C ${ca:04X} {cm}')
out.append('i $F400')
open('/home/claude/sk/hobbit.ctl','w').write('\n'.join(out)+'\n')
print('blocks',len(blocks),'bad comment addrs',bad)

# ---- generated ref sections (trivia and bugs)
with open('/home/claude/sk/hobbit-extra.ref','w') as f:
    for i,t,x in BUGS: f.write(f"[Bug:{i}:{t}]\n{x}\n\n")
    for i,t,x in TRIVIA: f.write(f"[Fact:{i}:{t}]\n{x}\n\n")
