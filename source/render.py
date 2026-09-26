import z80
from PIL import Image
B=24576
main=open('/home/claude/main.bin','rb').read()
PAL=[(0,0,0),(0,0,205),(205,0,0),(205,0,205),(0,205,0),(0,205,205),(205,205,0),(205,205,205)]
BRIGHT=[(0,0,0),(0,0,255),(255,0,0),(255,0,255),(0,255,0),(0,255,255),(255,255,0),(255,255,255)]
def draw(addr, patch=None, stop_after=None):
    m=z80.Z80Machine()
    mem=bytearray(65536); mem[B:B+len(main)]=main
    if patch:
        for a,v in patch.items(): mem[a]=v
    mem[0xb5db]=1
    mem[0x5F00]=0x76
    m.set_memory_block(0,bytes(mem))
    m.set_input_callback(lambda p:0xff)
    m.sp=0x5EF0; m.memory[0x5EF0]=0x00; m.memory[0x5EF1]=0x5F
    m.pc=0x8985; m.hl=addr
    border=[7]
    m.set_output_callback(lambda port,val: border.__setitem__(0,val&7) if port&1==0 else None)
    for _ in range(2000):
        m.ticks_to_stop=200000; m.run()
        if m.pc in (0x5F00,0x5F01): break
    return bytes(m.memory[0x4000:0x5B00]), border[0]
def to_img(scr, border, rows=16, scale=2, bw=8):
    w,h=256,rows*8
    img=Image.new('RGB',(w+2*bw,h+2*bw),PAL[border])
    px=img.load()
    for y in range(h):
        for cx in range(32):
            a=((y&0xC0)<<5)|((y&7)<<8)|((y&0x38)<<2)|cx
            b=scr[a]; at=scr[0x1800+(y>>3)*32+cx]
            ink=(BRIGHT if at&64 else PAL)[at&7]; paper=(BRIGHT if at&64 else PAL)[(at>>3)&7]
            for bit in range(8):
                px[bw+cx*8+bit,bw+y]=ink if b&(0x80>>bit) else paper
    return img.resize((img.width*scale,img.height*scale),Image.NEAREST)
if __name__=='__main__':
    i=0xcc00;pics=[]
    while main[i-B]!=0xff: pics.append((main[i-B],main[i+1-B]|main[i+2-B]<<8)); i+=3
    for r,p in pics:
        scr,bd=draw(p); to_img(scr,bd).save(f'/home/claude/pics/room{r:02d}.png')
        if r==5:
            scr,bd=draw(p,{p:5,p+1:0x28}); to_img(scr,bd).save('/home/claude/pics/room05_day.png')
    print(len(pics),'done')
