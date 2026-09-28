"""Idempotently link bare $XXXX addresses in every hobbit*.ref page."""
import glob, sys
sys.path.insert(0, '/home/claude/sk')
import linker
addrs = linker.load_addrs()
n = 0
for f in glob.glob('/home/claude/sk/hobbit*.ref'):
    s = open(f).read()
    out = []
    for ln in s.split('\n'):
        new = ln if ln.startswith('[') else linker.link(ln, addrs)
        if new != ln: n += 1
        out.append(new)
    open(f, 'w').write('\n'.join(out))
print('ref lines linked:', n)
