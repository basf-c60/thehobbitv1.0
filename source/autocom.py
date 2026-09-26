# Rule-based line commenter for the code blocks
import re,sys
sys.path.insert(0,'/home/claude/sk'); sys.path.insert(0,'/home/claude')
import beh, msg
from msg import decode
m=beh.m; B=beh.B; rb=beh.rb; rw=beh.rw
OBJ=beh.OBJ; ACT=beh.ACT

VARS={0xB5D8:'the action',0xB5D9:'the target',0xB5DA:'the instrument',0xB5DB:'the actor',0xB5FC:'the actor\'s record',0xB5F8:'the target\'s record',
0xB5FA:'the instrument\'s record',0xB5EB:'the "really do it" flag',0xB5EC:'the "it would work" flag',0xB5F3:'the "visible to Bilbo" output flag',
0xB5F2:'the lower-window flag',0xB5E6:'Bilbo\'s room this turn',0xB5E7:'the actor\'s room at the start of its turn',0xB5E4:'the room where the eyes timer started',
0xB5E8:'the score',0xB5E1:'the "a timer has expired" flag',0xB5E2:'the "map has been read" flag',0xB5E3:'the printer flag',0xB5E5:'the "order waiting" flag',
0xB5EA:'the "Gollum awaits an answer" flag',0xB5EF:'the "target is a room" flag',0xB5F0:'the "instrument is a room" flag',0xB5F1:'the drunkenness flag',
0xB5F4:'the "print an article" flag',0xB5F5:'the capitalisation flag',0xB5F6:'the "more commands" flag',0xB5F7:'the number of command frames',0xB5FE:'the random seed',
0xB5FF:'the "reach does not matter" flag',0xB600:'the object search filter',0xB601:'the "possible in the dark" flag',0xB604:'the idle counter',
0xB606:'the lines left before pausing',0xB607:'the current dictionary word',0xB609:'the ALL state',0xB60A:'the "unfinished command" flag',0xB60B:'the quotation level',
0xB60D:'the action\'s flags',0xB60E:'the action\'s second flags',0xB5CB:'the start of the current word',0xB5CD:'the token pointer',0xB5CF:'the previous word class',
0xB5D0:'the "verb matched" flag',0xB5D1:'the words for IT',0xB5DF:'the riddle pointer',0xB5ED:'the instrument\'s noun',0xB627:'the number of orders',
0xB602:'the random counter',0xB603:'the random state',0x8D17:'the destination room',0x8C2C:'the drawing colour',0x8964:'the "picture found" result',
0x976A:'the "Bilbo is in the dark" flag',0x9769:'the count of instructions this turn',0x768F:'the story window print position',0x7691:'the pixel offset',
0x768E:'the characters left on the line',0x75A8:'the columns left in the lower window',0x75A9:'the lower window print position',0x7692:'the indent',
0x7C44:'the preposition count',0x7C45:'the noun phrase buffer',0x7081:'the typed word length',0x7092:'the dictionary word length',0x9B37:'the "Bilbo moved" flag',
0xB5DC:'the saved variables',0x70D6:'the "definite article" flag',0x7B7C:'the new key record',0x833F:'the target search position',
0x8341:'the instrument search position',0x834F:'the action table entry',0x8343:'the ALL flag',0x8344:'the "one candidate only" flag',0x8330:'the candidate count',
0x8331:'the workable target count',0x8332:'the workable instrument count',0x8347:'the candidate target',0x8348:'the candidate instrument',0x832E:'the target flags',0x832F:'the instrument flags'}
OFIELD={0:'number of places',1:'holder',2:'size',3:'weight',4:'attributes',5:'strength',6:'defence',7:'flags',8:'noun',9:'noun',10:'first adjective',11:'first adjective',12:'second adjective',13:'second adjective',14:'fourth word/description',15:'fourth word/description',16:'location'}
FLAGBITS={0:'locked',1:'"evaporates"',2:'full',3:'dead/broken',4:'on',5:'open',6:'alive',7:'visible'}
# object record ranges
objs=[];i=0xBF53
while rb(i)!=0xFF: objs.append((rb(i),rw(i+1))); i+=3
ops=sorted(objs,key=lambda x:x[1])
def objfield(a):
    if not (0xC00B<=a<0xC61F): return None
    n,p=max((x for x in ops if x[1]<=a),key=lambda x:x[1]); off=a-p
    return '%s\'s %s'%(OBJ.get(n,'object %d'%n), OFIELD.get(off,'data (+%d)'%off) if off<=16 else 'data (+%d)'%off)
ROOMN={}
sk=open('/home/claude/sk/hobbit.skool').read()
for mm in re.finditer(r'; [{]?Room ([0-9/]+): ([a-z ]+)$',sk,re.M):
    for r in mm.group(1).split('/'): ROOMN.setdefault(int(r),mm.group(2).strip())
def room(n): return 'room %d (%s)'%(n,ROOMN[n]) if n in ROOMN else 'room %d'%n
titles={}; cur=None
lines=sk.split('\n')
for ln in lines:
    if ln.startswith('; ') and cur is None: cur=ln[2:]
    mm=re.match(r'^([bcgstuwi])\$([0-9A-F]{4})',ln)
    if mm:
        if cur: titles[int(mm.group(2),16)]=cur
        cur=None
    elif ln.strip()=='': cur=None
ADDRS=set(int(x,16) for x in re.findall(r'^[a-z *]\$([0-9A-F]{4}) ',sk,re.M))
def R(x): return '#R$%04X'%x if x in ADDRS else '$%04X'%x
def title(a):
    t=titles.get(a)
    return t if t else None
RP={}
for r in range(80): RP.setdefault(rw(0xB8D0+2*r),r)
RPS=sorted(p for p in RP if 0xB97A<=p<0xBF53)
def roomfield(a):
    if not (0xB97A<=a<0xBF53): return None
    p=max(q for q in RPS if q<=a); off=a-p; r=RP[p]
    f={0:'flags',1:'capacity',8:'description script',9:'description script'}.get(off,'name words' if 2<=off<=7 else 'exits (+%d)'%off)
    return '%s\'s %s'%(room(r),f)
def varname(a):
    if a in VARS: return VARS[a]
    rf=roomfield(a)
    if rf: return rf
    f=objfield(a)
    if f: return f
    if 0xC973<=a<0xC9BA:
        k=(a-0xC973)//7; o=(a-0xC973)%7
        return 'timer %d\'s %s'%(k,['reload value','count','expire routine','expire routine','threshold','tick routine','tick routine'][o])
    if 0xC9BA<=a<0xCA32:
        k=(a-0xC9BA)//7; o=(a-0xC9BA)%7
        return 'character slot %d\'s %s'%(k,['object number','count','program pointer','program pointer','reaction table','reaction table','stubbornness'][o])
    return None
import json as _json
_MS={int(k,16):v[0] for k,v in _json.load(open('/home/claude/sk/msgs.json')).items()}
def msgtext(a):
    if a in _MS:
        t=re.sub(r'\s+',' ',_MS[a].replace('\n',' ')).strip()
        return t[:70]+('...' if len(t)>70 else '')
    return _msgtext_old(a)
def _msgtext_old(a):
    try:
        t=decode(a,60)
    except Exception: return None
    toks=[x for x in t.replace('\\n',' ').split() if not re.match(r'^\?[0-9a-f]{3}$',x)]
    out=[]
    for x in toks:
        if out and (len(x)==1 and x not in ('a','i')) and x not in '"':
            if x in '.,?!-': out[-1]+=x
            else: out[-1]+=x.lower()
        else: out.append(x)
    t=' '.join(out)
    return t[:70]+('...' if len(t)>70 else '')

def parse_blocks():
    blocks=[];cur=None
    for ln in lines:
        mm=re.match(r'^([a-z*@ ])\$([0-9A-F]{4}) ([^;]*)(;.*)?$',ln)
        if not mm: continue
        t,a,ins,cm=mm.groups(); a=int(a,16)
        if t in 'bcgstuwi':
            cur={'t':t,'a':a,'ins':[]}; blocks.append(cur)
        if cur is not None and cur['t']=='c': cur['ins'].append((a,ins.strip()))
    return [b for b in blocks if b['t']=='c']

REG8={'A','B','C','D','E','H','L'}
def comment_block(ins):
    out={}
    ctx={'IX':None,'IY':None}   # what IX/IY point at: 'obj','room','exit','char','frame'
    lastq=None   # meaning of the last comparison/test, for conditional jumps
    lastload={}  # register -> description of its content
    pending={}; prev_uncond=False
    for k,(a,s) in enumerate(ins):
        c=None; u=s.upper()
        # merge register knowledge at jump targets
        if a in pending:
            snaps=pending[a]
            if not prev_uncond: snaps=snaps+[dict(lastload)]
            merged={}
            for key in set().union(*[set(x) for x in snaps]):
                vals=[x.get(key) for x in snaps]
                if all(v==vals[0] for v in vals): merged[key]=vals[0]
            lastload=merged; lastq=None
        mmj=re.match(r'(JP|JR|DJNZ)(?: (?:NZ|Z|NC|C|PO|PE|P|M),)? ?\$([0-9A-F]{4})',u)
        if mmj: pending.setdefault(int(mmj.group(2),16),[]).append(dict(lastload))
        prev_uncond=bool(re.match(r'(JP|JR) \$|JP \(|RET$',u))
        def tgt(x):
            t=title(x); return '%s (#R$%04X)'%(t,x) if t else '$%04X'%x
        mm=re.match(r'(CALL|JP|JR|DJNZ)(?: (NZ|Z|NC|C|PO|PE|P|M),)? ?\$([0-9A-F]{4})',u)
        if mm:
            op,cond,x=mm.group(1),mm.group(2),int(mm.group(3),16)
            t=title(x)
            if op=='DJNZ': c='Loop back until B reaches 0'
            elif op=='CALL':
                if x==0x9B25: c='IX = the record of object A'; ctx['IX']='obj'
                elif x==0x9B0C: c='IX = the record of room A'; ctx['IX']='room'
                elif x==0x99E0: c='IY = the character table entry for character A'; ctx['IY']='char'
                elif x in (0x9DDE,0x9FDE): c='IX = just before the first exit of the room'; ctx['IX']='exit'
                elif x==0x9C99: c='Dry run? Then just record that this would work, and return from the caller'
                elif x==0x72D4: c='Print the message at HL'
                elif x==0x7580: c='Print the character in A'
                elif x==0x7578: c='Print a new line'
                elif x==0x9BF4: c='A = a random number from 0 to A'
                elif x==0x975D: c='Carry on only if the action is really happening and would work'
                else: c='Call: '+(('%s (%s)'%(t,R(x))) if t else R(x))
                if x in (0x9E51,0x9E71,0x9E76,0xA054): ctx['IX']='exit'
                if x==0x9D12: ctx['IX']='entry'
                if x==0x9C8C: ctx['IX']='room'
                lastload['A']=None; lastq=(None,'call')
                if cond: c=('If %s: '%({'Z':'zero/equal','NZ':'not zero/not equal','C':'carry','NC':'no carry'}.get(cond,cond)))+c[0].lower()+c[1:]
            else:
                what=t+' (%s)'%R(x) if t else R(x)
                if cond:
                    q=lastq
                    yes={'Z':'yes','NZ':'no','C':'carry set','NC':'carry clear'}.get(cond,cond)
                    if q is None: yes={'Z':'Z is set','NZ':'Z is reset','C':'carry is set','NC':'carry is reset'}.get(cond,cond)
                    if q and q[1]=='test':
                        yes={'Z':'the bit is clear','NZ':'the bit is set'}.get(cond,yes)
                    elif q and q[1]=='call': yes={'Z':'the routine returned with Z set','NZ':'the routine returned with Z reset','C':'the routine returned with carry set','NC':'the routine returned with carry reset'}.get(cond,yes)
                    elif q and q[1]=='num' and cond in ('C','NC'):
                        yes=('A < %d' if cond=='C' else 'A >= %d')%q[2]
                    elif q and q[1]=='zero':
                        yes={'Z':'it is zero','NZ':'it is not zero'}.get(cond,yes)
                    c='If %s, %s %s'%(yes,'go to' if op=='JP' or op=='JR' else 'go to',what)
                else:
                    c='%s %s'%('Continue at' if op in ('JP','JR') else 'Go to',what)
                    if op=='JP' and t: c='Finish by jumping to %s (%s)'%(t,R(x))
        elif re.match(r'RET( |$)',u):
            cond=u[4:].strip()
            if not cond: c='Done'
            else:
                q=lastq
                yes={'Z':'yes','NZ':'no','C':'carry set','NC':'carry clear'}.get(cond,cond)
                if q is None: yes={'Z':'Z is set','NZ':'Z is reset','C':'carry is set','NC':'carry is reset'}.get(cond,cond)
                if q and q[1]=='test': yes={'Z':'the bit is clear','NZ':'the bit is set'}.get(cond,yes)
                elif q and q[1]=='call': yes={'Z':'the routine returned with Z set','NZ':'the routine returned with Z reset','C':'the routine returned with carry set','NC':'the routine returned with carry reset'}.get(cond,yes)
                elif q and q[1]=='num' and cond in ('C','NC'): yes=('A < %d' if cond=='C' else 'A >= %d')%q[2]
                elif q and q[1]=='zero': yes={'Z':'it is zero','NZ':'it is not zero'}.get(cond,yes)
                c='Return if %s'%yes
        elif u.startswith('CP '):
            v=u[3:]
            lm=lastload.get('A')
            if v.startswith('$'):
                n=int(v[1:],16)
                if lm in ('the actor','the target','the instrument') or (lm and ('holder' in lm)):
                    c='Is it %s (object %d)?'%(OBJ.get(n,'object %d'%n) if n!=0xFF else 'nobody',n) if n!=0xFF else 'Is it nobody ($FF)?'
                elif lm=='the action':
                    c='Is it action %d (%s)?'%(n,ACT.get(n,'?').upper())
                elif lm and ('location' in lm or 'room' in lm):
                    c='Is it %s?'%room(n) if n!=0xFF else 'Is it $FF (not a single place)?'
                elif n==0: c='Is it 0?'
                elif n==0xFF: c='Is it $FF (none / end of table)?'
                elif 0x20<=n<0x7F: c='Is it "%s"?'%chr(n)
                else: c='Compare with %d'%n
                lastq=(c,'num',n) if n not in (0,0xFF) else (c,'cmp')
            elif v=='(HL)' or v.startswith('(I'): c='Compare with the byte at %s'%v; lastq=(c,'cmp')
            else: c='Compare with %s'%v; lastq=(c,'cmp')
        elif u.startswith('BIT '):
            mm=re.match(r'BIT (\d),\((I[XY])\+\$([0-9A-F]{2})\)',u)
            if mm:
                b,r,o=int(mm.group(1)),mm.group(2),int(mm.group(3),16)
                if ctx.get(r) in ('obj',None) and o==7: c='Is the object %s (bit %d of its flags)?'%(FLAGBITS[b],b)
                elif ctx.get(r)=='room' and o==0 and b==7: c='Is the room lit (bit 7)?'
                elif ctx.get(r)=='obj' and o<=16: c='Test bit %d of the object\'s %s'%(b,OFIELD[o])
                else: c='Test bit %d of (%s+%d)'%(b,r,o)
            else:
                mm=re.match(r'BIT (\d),(.*)',u); c='Test bit %s of %s'%(mm.group(1),mm.group(2))
            lastq=(c,'test')
        elif re.match(r'(SET|RES) \d,\(HL\)',u) and lastload.get('HLaddr','').startswith('room '):
            c='%s bit %s of %s'%('Set' if u.startswith('SET') else 'Clear',u[4],lastload['HLaddr'])
        elif re.match(r'(SET|RES) \d,\(HL\)',u) and lastload.get('HLaddr') and lastload['HLaddr'].endswith("'s flags"):
            b=int(u[4]); c='%s the "%s" flag (bit %d) of %s'%('Set' if u.startswith('SET') else 'Clear',FLAGBITS[b].strip('"'),b,lastload['HLaddr'][:-8])
        elif re.match(r'BIT \d,\(HL\)',u) and lastload.get('HLaddr') and lastload['HLaddr'].endswith("'s flags"):
            b=int(u[4]); c='Is %s %s (bit %d)?'%(lastload['HLaddr'][:-8],FLAGBITS[b].strip('"'),b); lastq=(c,'test')
        elif re.match(r'(SET|RES) \d,\(I[XY]\+\$07\)',u):
            b=int(u[4]); c='%s the object\'s "%s" flag (bit %d)'%('Set' if u.startswith('SET') else 'Clear',FLAGBITS[b].strip('"'),b)
        elif u in ('AND A','OR A'): c='Is A zero?'; lastq=(c,'zero')
        elif u in ('XOR A','SUB A'): c='A = 0'; lastload['A']=None
        elif u=='INC A' and lastload.get('A') and ('holder' in (lastload.get('A') or '') or lastload.get('A') in ('the target','the instrument')):
            c='(sets Z if A was $FF: none)'; lastq=(c,'zero')
        else:
            mm=re.match(r'LD (HL|DE|BC|IX|IY|SP|A|B|C|D|E|H|L),\(\$([0-9A-F]{4})\)',u)
            if mm:
                r,x=mm.group(1),int(mm.group(2),16); n=varname(x)
                if n: c='%s = %s'%(r,n); lastload[r]=n
                else: c='%s = the contents of $%04X'%(r,x); lastload[r]=None
                if r in ('IX','IY'): ctx[r]='obj' if x in (0xB5FC,0xB5F8,0xB5FA) else None
            mm2=re.match(r'LD \(\$([0-9A-F]{4})\),(HL|DE|BC|IX|IY|A|B|C|D|E|H|L)',u)
            if mm2:
                x,r=int(mm2.group(1),16),mm2.group(2); n=varname(x)
                c='Store %s in %s'%(r,n) if n else 'Store %s at $%04X'%(r,x)
            mm3=re.match(r'LD (HL|DE|BC|IX|IY),\$([0-9A-F]{4})',u)
            if mm3 and not c:
                r,x=mm3.group(1),int(mm3.group(2),16)
                if 0xAC71<=x<0xB5CB: t=msgtext(x); c='%s = message: "%s"'%(r,t) if t else '%s = a message'%r
                elif x==0xC00B: c='%s = the object table (Bilbo\'s record)'%r; ctx[r]='obj' if r in ctx else None
                elif x in (0xBF53,0xBF50): c='%s = the object index'%r
                elif x==0xC9BA: c='%s = the character table'%r; ctx[r]='char' if r in ctx else None
                elif x==0xC973: c='%s = the timer table'%r
                elif x==0xB628: c='%s = the orders buffer'%r
                elif x==0xB8B8: c='%s = the first command frame'%r; ctx[r]='frame' if r in ctx else None
                elif x==0xCC00: c='%s = the picture index'%r
                elif x==0xC67D: c='%s = the room-entry handler table'%r
                elif x==0xC61F: c='%s = the default action handlers'%r
                elif x==0xAA47 or x==0xAA3F: c='%s = the action table'%r
                elif varname(x):
                    c='%s = the address of %s'%(r,varname(x))
                    if r=='HL': lastload['HLaddr']=varname(x)
                elif title(x): c='%s = %s (%s)'%(r,title(x),R(x))
                elif x<0x100: c='%s = %d'%(r,x)
                else: c='%s = $%04X'%(r,x)
                if r in ('IX','IY') and ctx.get(r) is None and objfield(x): ctx[r]='obj'
            mm4=re.match(r'LD (A|B|C|D|E|H|L),\((I[XY])\+\$([0-9A-F]{2})\)',u)
            if mm4 and not c:
                r,ir,o=mm4.group(1),mm4.group(2),int(mm4.group(3),16); kind=ctx.get(ir)
                if kind=='obj' and o<=16: n='the object\'s '+OFIELD[o]; c='%s = %s'%(r,n); lastload[r]=('holder' if o==1 else ('location' if o>=16 else n))
                elif kind=='room' and o<=1: c='%s = the room\'s %s'%(r,['flags','capacity'][o])
                elif kind=='exit' and o<=2: n=['direction','door','destination'][o]; c='%s = the exit\'s %s'%(r,n); lastload[r]=('location' if o==2 else ('holder' if o==1 else n))
                elif kind=='entry' and o<=2: c='%s = %s of the table entry'%(r,['the key','the low byte of the address','the high byte of the address'][o])
                elif kind=='char' and o<=6: c='%s = the character entry\'s %s'%(r,['object number','count','program pointer','program pointer (high)','reaction table','reaction table (high)','stubbornness'][o])
                else: c='%s = (%s+%d)'%(r,ir,o)
            mm5=re.match(r'LD \((I[XY])\+\$([0-9A-F]{2})\),(.*)',u)
            if mm5 and not c:
                ir,o,v=mm5.group(1),int(mm5.group(2),16),mm5.group(3); kind=ctx.get(ir)
                if kind=='obj' and o<=16: c='Set the object\'s %s to %s'%(OFIELD[o],v.replace('$FF','$FF (nobody/none)'))
                elif kind=='exit' and o<=2: c='Set the exit\'s %s to %s'%(['direction','door','destination'][o],v)
                else: c='Store %s at (%s+%d)'%(v,ir,o)
            mm6=re.match(r'LD (A|B|C|D|E|H|L),\$([0-9A-F]{2})$',u)
            if mm6 and not c:
                r,n=mm6.group(1),int(mm6.group(2),16); c='%s = %d'%(r,n); lastload[r]=None
                nxt=[x[1].upper() for x in ins[k+1:k+3]]
                OBJR=('$9B25','$96DD','$9CA8','$99E0','$9ECB','$9CEC','$71D9','$747F','$9C42','$9C3D','$894D','$A0BC','$9B38')
                ROOMR=('$9B0C','$8965','$71CC','$958E','$9606','$9B96')
                if r=='A' and any(q.startswith('CALL') and q[-5:] in OBJR for q in nxt) and n in OBJ: c='A = %d (%s)'%(n,OBJ[n])
                elif r=='A' and any(q.startswith('CALL') and q[-5:] in ROOMR for q in nxt): c='A = %s'%room(n)
            if not c:
                simple={'PUSH':'Save %s','POP':'Restore %s','INC':'Increment %s','DEC':'Decrement %s'}
                op=u.split(' ')[0]; arg=u[len(op):].strip()
                if op in simple and arg: c=simple[op]%arg
                elif u=='LDIR': c='Copy BC bytes from HL to DE'
                elif u=='LDDR': c='Copy BC bytes from HL to DE, working downwards'
                elif u=='CPIR': c='Search BC bytes from HL for A'
                elif u=='EX DE,HL': c='Swap DE and HL'
                elif u=='EX (SP),HL': c='Swap HL with the value on top of the stack'
                elif u=='EXX': c='Switch to the alternate registers'
                elif u=="EX AF,AF'": c='Switch AF with the alternate AF'
                elif u=='SCF': c='Set the carry flag'
                elif u=='CCF': c='Complement the carry flag'
                elif u=='CPL': c='A = NOT A'
                elif u=='NEG': c='A = -A'
                elif u in ('RLCA','RRCA','RLA','RRA'): c={'RLCA':'Rotate A left','RRCA':'Rotate A right','RLA':'Rotate A left through carry','RRA':'Rotate A right through carry'}[u]
                elif op in ('SRL','SLA','SRA','RL','RR','RLC','RRC'): c={'SRL':'Halve %s','SLA':'Double %s'}.get(op,'Shift/rotate %s')%arg
                elif op in ('ADD','SUB') and re.search(r'\((I[XY])\+\$([0-9A-F]{2})\)',arg) and ctx.get(re.search(r'\((I[XY])',arg).group(1))=='obj' and int(re.search(r'\$([0-9A-F]{2})\)',arg).group(1),16)<=16:
                    o=int(re.search(r'\$([0-9A-F]{2})\)',arg).group(1),16); c='%s the object\'s %s'%('Add' if op=='ADD' else 'Subtract',OFIELD[o])
                elif op in ('AND','OR','XOR','ADD','ADC','SUB','SBC'):
                    c={'AND':'Keep only the bits of %s','OR':'Combine with %s','XOR':'Flip the bits in %s','ADD':'Add %s','ADC':'Add %s with carry','SUB':'Subtract %s','SBC':'Subtract %s with carry'}[op]%arg
                    if op in ('AND','OR','XOR','SUB'): lastq=(c,'zero')
                elif op=='LD':
                    d,sv=arg.split(',',1)
                    if d.startswith('('): c='Store %s at %s'%(sv,d)
                    else: c='%s = %s'%(d,sv)
                    if d in ('A','B','C','D','E','H','L'): lastload[d]=lastload.get(sv) if sv in lastload else None
                elif op=='JP' and arg in ('(HL)','(IX)','(IY)'): c='Jump to the address in %s'%arg[1:-1]
                elif op=='IN': c='Read the keyboard/port'
                elif op=='OUT': c='Write to the port (border colour, beeper or printer)'
                elif u=='NOP': c='Nothing'
                elif u=='DI': c='Disable interrupts'
                elif u=='EI': c='Enable interrupts'
                elif u=='HALT': c='Wait for an interrupt'
                elif op=='RST': c='Call the ROM routine at %s'%arg
        out[a]=c or ''
    return out

def all_comments():
    res={}
    for b in parse_blocks():
        res.update(comment_block(b['ins']))
    return res
if __name__=='__main__':
    res=all_comments()
    for a in sys.argv[1:]:
        b=[x for x in parse_blocks() if x['a']==int(a,16)][0]
        cm=comment_block(b['ins'])
        for ad,s in b['ins']: print('%04X %-22s ; %s'%(ad,s,cm[ad]))
