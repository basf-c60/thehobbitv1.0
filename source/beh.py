import sys,re;sys.path.insert(0,'/home/claude')
from dic import parse2
m=open('/home/claude/main.bin','rb').read();B=24576
def rb(a): return m[a-B]
def rw(a): return m[a-B]|m[a+1-B]<<8
W={s-0x6000:w.lower() for s,w,*_ in parse2(0x6040,0x67AF)}
def wref(v): return W.get(v&0xfff,'')
ACT={}
for n in range(1,60):
    a=0xAA3F+8*n; ACT[n]=' '.join(wref(rw(a+2*k)) for k in range(4) if rw(a+2*k)&0xfff)
ACT[0]='(none)'
OBJ={}
i=0xbf53
while rb(i)!=0xff:
    n=rb(i);p=rw(i+1); ws=[wref(rw(p+8+2*j)) for j in range(3) if rw(p+8+2*j)]
    OBJ[n]=' '.join(ws[1:]+ws[:1]); i+=3
OBJ[0xff]='-'; OBJ[0]='bilbo'
sk=open('hobbit.skool').read().split('\n')
titles={};cur=None
for ln in sk:
    if ln.startswith('; ') and cur is None: cur=ln[2:]
    mm=re.match(r'^([bcgstuwi])\$([0-9A-F]{4})',ln)
    if mm:
        if cur: titles[int(mm.group(2),16)]=cur
        cur=None
    elif ln.strip()=='': cur=None
def o(n): return OBJ.get(n,'obj %d'%n)
def dis(a):
    f=rb(a); t=f&0x0f; fl=[]
    if f&0x40: fl.append('no orders')
    if f&0x20: fl.append('once')
    if t<4:
        if f&1:
            r=rw(a+1); txt='call $%04X (%s)'%(r,titles.get(r,'?')); ln=4
        else:
            txt='%s [%s] target %s, with %s'%('action %d'%rb(a+1),ACT.get(rb(a+1),'?'),o(rb(a+2)),o(rb(a+3))); ln=4
        if f&0x10: txt+='; if it fails go to $%04X'%rw(a+ln); nxt=[rw(a+ln)]; ln+=2
        else: nxt=[]
        return ln,txt,fl,nxt,True
    if t==4:
        act=rb(a+1)
        if act==0xff:
            if f&0x10: return 4,'end turn and go to $%04X'%rw(a+2),fl,[rw(a+2)],False
            return 2,'do nothing this turn',fl,[],True
        txt='action %d [%s]'%(act,ACT.get(act,'?')); ln=2; nxt=[]
        if f&0x10: txt+='; if it fails go to $%04X'%rw(a+2); nxt=[rw(a+2)]; ln=4
        return ln,txt,fl,nxt,True
    if t==0xE: return 3,'go to $%04X'%rw(a+1),fl,[rw(a+1)],False
    if t==0xC: return 2,'switch to reaction for action %d [%s]'%(rb(a+1),ACT.get(rb(a+1),'?')),fl,[],False
    if t==0xF: return 2,'switch to a random behaviour (1 of up to %d)'%rb(a+1),fl,[],False
    return 1,'switch to default behaviour and end turn',fl,[],False
def trace():
    chars=[]
    for i in range(0xC9BA,0xCA31,7):
        chars.append((i,rb(i),rb(i+1),rw(i+2),rw(i+4),rb(i+6)))
    starts=set();rt={}
    for i,c,n,p,r,s in chars:
        starts.add(p)
        a=r;ent=[]
        while rb(a)!=0xff: ent.append((rb(a),rw(a+1))); starts.add(rw(a+1)); a+=3
        rt[r]=(ent,a)
    seen={};todo=list(starts)
    while todo:
        a=todo.pop()
        while a not in seen and 0xC71C<=a<0xC973:
            ln,txt,fl,nxt,cont=dis(a); seen[a]=(ln,txt,fl); todo+=nxt
            if not cont: break
            a+=ln
    return chars,rt,seen
if __name__=='__main__':
    chars,rt,seen=trace()
    for a in sorted(seen): print(hex(a),seen[a][0],seen[a][1],seen[a][2])
    cov=set()
    for a,(ln,_,_) in seen.items(): cov|=set(range(a,a+ln))
    for r,(e,end) in rt.items(): cov|=set(range(r,end+1))
    gaps=[hex(a) for a in range(0xC71C,0xC973) if a not in cov]
    print('gaps',gaps)
