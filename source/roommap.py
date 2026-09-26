import re,json,subprocess
import beh
m=beh.m;B=24576
DIR={1:'N',2:'S',3:'E',4:'W',5:'NE',6:'NW',7:'SE',8:'SW',9:'U',10:'D'}
OPP={1:2,2:1,3:4,4:3,5:8,8:5,6:7,7:6,9:10,10:9}
PREP=['outside','inside','in','on','at']
sk=open('/home/claude/sk/hobbit.skool').read()
RN={}
for mm in re.finditer(r'; [{]?Room ([0-9/]+): ([a-z ]+)$',sk,re.M):
    for r in mm.group(1).split('/'): RN.setdefault(int(r),mm.group(2).strip())
rooms={}
for r in range(1,80):
    p=m[0xb8d0+2*r-B]|m[0xb8d1+2*r-B]<<8
    ex=[];q=p+10
    while m[q-B]!=0xff and q<p+80:
        ex.append((m[q-B],m[q+1-B],m[q+2-B])); q+=3
    rooms[r]=dict(p=p,flags=m[p-B],cap=m[p+1-B],desc=m[p+8-B]|m[p+9-B]<<8,ex=ex)
# hidden routes (blanked at start)
hidden=set()
for e in (0xC6FD,0xC703,0xC709,0xC70F,0xC715):
    hidden.add((m[e-B],m[e+3-B],m[e+5-B]))
for (r,d,dest) in hidden:
    rooms[r]['ex'].append((d,0,dest)) if (d,0,dest) not in rooms[r]['ex'] else None
# reachability from room 1
seen={1};todo=[1]
while todo:
    r=todo.pop()
    for d,door,dest in rooms[r]['ex']:
        if dest and dest not in seen: seen.add(dest); todo.append(dest)
unreach=[r for r in rooms if r not in seen]
oneway=[]
for r,x in rooms.items():
    for d,door,dest in x['ex']:
        if not dest: continue
        back=[e for e in rooms[dest]['ex'] if e[2]==r]
        if not back: oneway.append((r,DIR[d],dest))
def name(r): return RN.get(r,'?')
if __name__=='__main__':
    print('unreachable',[(r,name(r)) for r in unreach]); print('one-way',len(oneway),oneway)

def dotfile():
    L=['graph G {','graph [overlap=false, splines=true, fontname="Helvetica", bgcolor="white", pad=0.3];','node [shape=box, style="rounded,filled", fillcolor="#f6f1e1", fontname="Helvetica", fontsize=10];','edge [fontname="Helvetica", fontsize=8, color="#555555"];']
    PICS=set()
    i=0xCC00
    while m[i-B]!=0xFF: PICS.add(m[i-B]); i+=3
    for r,x in rooms.items():
        lit=x['flags']&0x80
        col='#f6f1e1' if lit else '#b9b2a3'
        extra=' (picture)' if r in PICS else ''
        L.append('r%d [label="%d\\n%s%s", fillcolor="%s"%s];'%(r,r,name(r),extra,col,', penwidth=2' if r in PICS else ''))
    done=set()
    doors={}
    objs={};i=0xBF53
    while m[i-B]!=0xFF: objs[m[i-B]]=m[i+1-B]|m[i+2-B]<<8; i+=3
    for r,x in rooms.items():
        for d,door,dest in x['ex']:
            if not dest: continue
            key=tuple(sorted((r,dest)))
            back=[e for e in rooms[dest]['ex'] if e[2]==r]
            hid=(r,d,dest) in hidden
            dn=beh.OBJ.get(door,'') if door else ''
            style=[]
            if hid: style.append('style=dotted, color="#c03020", penwidth=2')
            elif door: style.append('style=dashed, color="#2050a0"')
            if back and not hid:
                if key in done: continue
                done.add(key)
                lab='%s/%s'%(DIR[d],DIR[back[0][0]])
                if dn: lab+='\\n'+dn
                L.append('r%d -- r%d [label="%s"%s];'%(r,dest,lab,(', '+style[0]) if style else ''))
            else:
                lab=DIR[d]+(('\\n'+dn) if dn else '')+('\\n(hidden)' if hid else '')
                L.append('r%d -- r%d [label="%s", dir=forward, arrowhead=normal%s];'%(r,dest,lab,(', '+style[0]) if style else ''))
    L.append('}')
    return '\n'.join(L)
if __name__=='__main__':
    open('/home/claude/sk/map.dot','w').write(dotfile())
