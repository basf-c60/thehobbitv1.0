m=open('/home/claude/main.bin','rb').read();B=24576
def rb(a): return m[a-B]
COL=['black','blue','red','magenta','green','cyan','yellow','white']
DIRN={0:'up',1:'right',2:'down',3:'left'}
def attr_xy(a):
    o=a-0x5800; return o%32,o//32
def decode(p,end):
    out=[(p,2,'Border %s, picture area %s ink on %s paper'%(COL[rb(p)&7],COL[rb(p+1)&7],COL[(rb(p+1)>>3)&7]))]
    a=p+2; x,y=127,63
    stats={'line':0,'move':0,'fill':0,'paint':0}
    while a<end:
        c=rb(a)
        if c==0: out.append((a,1,'End of picture')); a+=1; break
        if c==8:
            x,y=rb(a+1),rb(a+2); out.append((a,3,'Move to (%d,%d)'%(x,y))); a+=3; stats['move']+=1; continue
        if c&0x80:
            c2=rb(a+1); d=c&7; ratio=(((c>>1)&0x3C)|(c2>>6))+1; L=(c2&0x3F)+1
            prim='x' if not d&1 else 'y'
            hx='left' if d&4 else 'right'; vy='down' if d&2 else 'up'
            main_=hx if prim=='x' else vy; side=vy if prim=='x' else hx
            # simulate endpoint
            cnt=ratio
            for i in range(L):
                if prim=='x': x=max(0,min(255,x+(-1 if d&4 else 1)))
                else: y=max(0,min(127,y+(-1 if d&2 else 1)))
                cnt-=1
                if cnt==0:
                    if prim=='x': y=max(0,min(127,y+(-1 if d&2 else 1)))
                    else: x=max(0,min(255,x+(-1 if d&4 else 1)))
                    cnt=ratio
            if ratio==1: slope='diagonally %s-%s'%(vy,hx)
            elif ratio>L: slope=main_
            else: slope='%s, 1 %s every %d'%(main_,side,ratio)
            out.append((a,2,'Line %d pixels %s, to (%d,%d)'%(L,slope,x,y))); a+=2; stats['line']+=1; continue
        if c&0x40:
            out.append((a,3,'Fill from (%d,%d) in %s'%(rb(a+1),rb(a+2),COL[c&7]))); a+=3; stats['fill']+=1; continue
        if c&0x20:
            ad=rb(a+1)<<8|rb(a+2); cx,cy=attr_xy(ad); s=a; a+=3; runs=[]
            while rb(a)!=0xFF:
                b=rb(a); runs.append('%d %s'%(((b>>2)&0x3F)+1,DIRN[b&3])); a+=1
            a+=1
            out.append((s,a-s,'Paint %s paper from cell (%d,%d): %s'%(COL[c&7],cx,cy,', '.join(runs) if runs else 'nothing')))
            stats['paint']+=1; continue
        out.append((a,1,'Ignored')); a+=1
    return out,a,stats
