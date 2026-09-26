# Render every message with the game's own interpreter, in the emulator
import z80,re,json,sys
B=24576
main=bytearray(open('/home/claude/main.bin','rb').read())
def enc(word):   # dictionary encoding: 5-bit letters, bit 7 on last (from 3rd byte)
    b=[ord(c)-64 for c in word]
    while len(b)<3: b.append(0)
    b[-1]|=0x80; return bytes(b)
# placeholder words in the unused bytes at $6BEE
words={'THING':0x6BEE,'WORD':0x6BF3,'OTHER':0x6BF7}
for w,a in words.items(): main[a-B:a-B+len(enc(w))]=enc(w)
ref=lambda w: words[w]-0x6000
objs={};i=0xBF53
while main[i-B]!=0xFF: objs[main[i-B]]=main[i+1-B]|main[i+2-B]<<8; i+=3
def setnoun(obj,w):
    p=objs[obj]; r=ref(w)
    main[p+8-B]=r&255; main[p+9-B]=(r>>8)|0x00
    for k in range(10,16): main[p+k-B]=0
setnoun(43,'THING'); setnoun(40,'OTHER')
LIST=0x5BF3
def run(addr):
    m=z80.Z80Machine(); mem=bytearray(65536); mem[B:B+len(main)]=main
    # word list for object parameters: noun WORD
    r=ref('WORD'); mem[LIST]=r&255; mem[LIST+1]=r>>8
    v={0xB606:200,0xB5DB:0,0xB5D9:43,0xB5DA:40,0xB5EB:1,0xB5EC:1,0xB5F3:1,0xB5F2:0,0xB5F4:0,0x70D6:0,0xB5EF:0,0xB5F0:0,0xB5F5:1}
    for a,x in v.items(): mem[a]=x
    for a,x in ((0xB5FC,0xC00B),(0xB5F8,objs[43]),(0xB5FA,objs[40]),(0xB5ED,ref('WORD'))):
        mem[a]=x&255; mem[a+1]=x>>8
    mem[0x5F00]=0x76
    m.set_memory_block(0,bytes(mem)); m.set_input_callback(lambda p:0xFF)
    sp=0x5EF0
    # stack: return address, then three parameters (object list / word)
    for val in (0x5F00, LIST, ref('WORD')|0x0000, 43):
        pass
    stack=[0x5F00, LIST, LIST, LIST]
    for k,val in enumerate(stack):
        m.memory[sp+2*k]=val&255; m.memory[sp+2*k+1]=val>>8
    m.sp=sp; m.pc=0x72D4; m.hl=addr
    out=[]
    m.set_breakpoint(0x7694); m.set_breakpoint(0x75AD); m.set_breakpoint(0x5F00)
    for _ in range(5000):
        m.ticks_to_stop=100000; m.run()
        if m.pc in (0x7694,0x75AD):
            out.append(chr(m.a)); m.step_over_breakpoint()
        elif m.pc==0x5F00 or m.pc<0x4000: break
    t=''.join(out).replace('\r','\n').replace('\x08','\b')
    # apply backspaces
    res=[]
    for ch in t:
        if ch=='\b':
            if res: res.pop()
        else: res.append(ch)
    return ''.join(res).strip()
if __name__=='__main__':
    for a in sys.argv[1:]: print(a, repr(run(int(a,16))))

def run_extent(addr):
    """Return (text, last byte used) by watching the interpreter's pointer IX."""
    import z80
    txt=run(addr)
    m=z80.Z80Machine(); mem=bytearray(65536); mem[B:B+len(main)]=main
    r=ref('WORD'); mem[LIST]=r&255; mem[LIST+1]=r>>8
    for a,x in {0xB5DB:0,0xB5D9:43,0xB5DA:40,0xB5EB:1,0xB5EC:1,0xB5F3:1,0xB5F2:0,0xB606:200}.items(): mem[a]=x
    for a,x in ((0xB5FC,0xC00B),(0xB5F8,objs[43]),(0xB5FA,objs[40]),(0xB5ED,ref('WORD'))):
        mem[a]=x&255; mem[a+1]=x>>8
    mem[0x5F00]=0x76
    m.set_memory_block(0,bytes(mem)); m.set_input_callback(lambda p:0xFF)
    sp=0x5EF0
    for k,val in enumerate([0x5F00,LIST,LIST,LIST]): m.memory[sp+2*k]=val&255; m.memory[sp+2*k+1]=val>>8
    m.sp=sp; m.pc=0x72D4; m.hl=addr
    hi=addr
    for _ in range(2000000):
        m.ticks_to_stop=1; m.run()
        if 0xAC71<=m.ix<0xB5CB and m.ix>=addr and m.ix-addr<400: hi=max(hi,m.ix)
        if m.pc==0x5F00 or m.pc<0x4000: break
    return txt,hi
