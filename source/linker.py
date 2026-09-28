"""Turn bare $XXXX addresses in prose and comments into SkoolKit #R links,
but only where the address really exists in the disassembly."""
import re
_PROT = re.compile(r'#R\$[0-9A-Fa-f]{4}(?:\([^)]*\))?')

def load_addrs(path='/home/claude/sk/hobbit.skool'):
    out = set()
    try:
        for ln in open(path):
            m = re.match(r'^[a-z*@ ]\$([0-9A-F]{4}) ', ln)
            if m: out.add(int(m.group(1), 16))
    except IOError:
        pass
    return out

def link(text, addrs):
    if '$' not in text: return text
    saved = []
    def stash(m):
        saved.append(m.group(0)); return '\x00%d\x00' % (len(saved) - 1)
    t = _PROT.sub(stash, text)
    def rep(m):
        if int(m.group(1), 16) not in addrs: return m.group(0)
        label = '(%s)' % m.group(0) if t[m.end():m.end() + 1] == '(' else ''
        return '#R$%s%s' % (m.group(1), label)
    t = re.sub(r'(?<![\w$#\\])\$([0-9A-F]{4})\b', rep, t)
    return re.sub('\x00(\\d+)\x00', lambda m: saved[int(m.group(1))], t)
