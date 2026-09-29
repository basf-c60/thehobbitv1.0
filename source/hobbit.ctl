@ $6000 start
@ $6000 org
w $6000 Dictionary letter index
D $6000 Before the vocabulary proper there is a small index of 16-bit little-endian offsets. Entry n (n=1 for A, 2 for B ... 26 for Z) gives the offset from #R$6000 of the first dictionary word that begins with that letter. For example the entry for A is $0040, so the A-words start at #R$6040; the entry for G is $02C1, which is where GANDALF lives. The parser uses this to jump straight to the right part of the dictionary instead of scanning the whole thing.
D $6000 Entry 0 is unused ($0000). After Z come a few more words, including $07AC, which points into the second (message-only) dictionary at #R$67B0.
W $6000,64 Offsets from #R$6000 of each letter group
b $6040 Main dictionary (the words the player can type)
D $6040 This is the vocabulary: every verb, noun, adjective, adverb and direction the parser understands, stored alphabetically, 356 entries in all. It is also used by the printer, so the same words appear in room descriptions and messages.
D $6040 Each word is stored with one byte per letter. The low five bits of each byte hold the letter (1=A, 2=B ... 26=Z, 0=no letter). From the third byte onwards, bit 7 set means 'this is the last letter of the word'. Words shorter than three letters are padded with a byte whose letter bits are 0 and whose bit 7 is set (so TO is stored as T, O, $80).
D $6040 Bits 5 and 6 of the FIRST TWO bytes are not part of the letters: together they give the word's class, which the tokeniser (#R$6E8E, at #R$6F12) assembles into a single byte: bit 6 of byte 0 becomes bit 7, bit 5 of byte 0 becomes bit 6, bit 6 of byte 1 becomes bit 5, and bit 5 of byte 1 becomes bit 4. The classes are:
D $6040 #TABLE(default) { =h Class | =h Meaning | =h Examples } { $00 | adverb | CAREFULLY, QUICKLY, VICIOUSLY, SOFTLY } { $10 | 'in' preposition | IN, INTO } { $20 | direction | NORTH, EAST, UP, DOWN, NE } { $30 | verb | ATTACK, TAKE, CLIMB, EXAMINE, OPEN, SAY } { $40 | movement verb | GO, RUN } { $50 | noun | SWORD, THORIN, DOOR, KEY, BARREL } { $60 | adjective | CURIOUS, LARGE, GREEN, DARK } { $70 | preposition | AT, WITH, TO, ON, THROUGH } { $80 | article or filler | A, AN, THE, IS, THAT } { $90 | special word | ALL, EXCEPT, IT, HELP, SAVE, LOAD, PRINT, QUIT } { $A0 | AND | AND (a comma produces the same class) } { $B0 | THEN | THEN (a full stop produces the same class) } TABLE#
D $6040 SYNONYMS: if bit 6 of a word's LAST byte is set, the word is a synonym and is followed by two extra bytes: the offset from #R$6000 of the word it stands for. The tokeniser silently replaces the synonym with that word, so the rest of the game never sees it. There are 29 synonyms, and they explain a lot about how the game behaves: HIT, KILL, CAPTURE, SLASH and SLICE all become ATTACK; BREAK and SMASH become STRIKE; GET, LIFT and STEAL become TAKE; PICK becomes CARRY; READ becomes EXAMINE; SAY becomes TALK; EVERYTHING becomes ALL; BUT becomes EXCEPT; ME becomes YOU; I becomes INVENTORY; L and LO become LOOK; and N, S, E, W, NE, NW, SE, SW, U and D become the full direction words. So 'hit thorin' and 'kill thorin' are literally the same command as 'attack thorin'.
D $6040 Everything else in the game refers to a word by its offset from #R$6000, as a 12-bit number. So SWORD, which starts at #R$6684, is referred to as $684; THORIN at #R$66B8 is $6B8; CAVE at #R$6112 is $112. The spare top four bits of those 16-bit references are used for the class or for printing flags.
D $6040 The dictionary ends at $67AE with YOU; the byte at #R$67AF is a separator, and the second dictionary (#R$67B0) follows.
B $6040,3,3 A: $040, article/filler
B $6043,6,6 ACROSS: $043, preposition
B $6049,5,5 AFTER: $049, preposition
B $604E,3,3 ALL: $04E, special word
B $6051,7,7 ALREADY: $051, article/filler
B $6058,3,3 AN: $058, article/filler
B $605B,3,3 AND: $05B, AND
B $605E,7,7 ANOTHER: $05E, article/filler
B $6065,3,3 ARE: $065, article/filler
B $6068,3,3 ARM: $068, noun
B $606B,5,5 ARROW: $06B, noun
B $6070,3,3 AT: $070, preposition
B $6073,6,6 ATTACK: $073, verb
B $6079,3,3 AXE: $079, noun
B $607C,4,4 BACK: $07C, adjective
B $6080,4,4 BARD: $080, noun
B $6084,6,6 BARREL: $084, noun
B $608A,6,6 BARREN: $08A, adjective
B $6090,3,3 BAY: $090, noun
B $6093,6,6 BEORNS: $093, adjective
B $6099,9,9 BEWITCHED: $099, adjective
B $60A2,3,3 BIG: $0A2, adjective
B $60A5,5,5 BLACK: $0A5, adjective
B $60AA,5,5 BLEAK: $0AA, adjective
B $60AF,4,4 BLOW: $0AF, noun
B $60B3,5,5 BLOOD: $0B3, noun
B $60B8,4,4 BOAT: $0B8, noun
B $60BC,3,3 BOG: $0BC, noun
B $60BF,4,4 BODY: $0BF, noun
B $60C3,3,3 BOW: $0C3, noun
B $60C6,7,7 BREAK: $0C6 = synonym for STRIKE
B $60CD,6,6 BROKEN: $0CD, adjective
B $60D3,4,4 BURN: $0D3, verb
B $60D7,5,5 BUT: $0D7 = synonym for EXCEPT
B $60DC,6,6 BUTLER: $0DC, noun
B $60E2,5,5 CACHE: $0E2, noun
B $60E7,4,4 CAMP: $0E7, noun
B $60EB,3,3 CAN: $0EB, article/filler
B $60EE,6,6 CANNOT: $0EE, article/filler
B $60F4,9,9 CAPTURE: $0F4 = synonym for ATTACK
B $60FD,9,9 CAREFULLY: $0FD, adverb
B $6106,7,7 CARROCK: $106, noun
B $610D,5,5 CARRY: $10D, verb
B $6112,4,4 CAVE: $112, noun
B $6116,6,6 CAVERN: $116, noun
B $611C,6,6 CELLAR: $11C, noun
B $6122,5,5 CHEST: $122, noun
B $6127,8,8 CLEARING: $127, noun
B $612F,5,5 CLIMB: $12F, verb
B $6134,5,5 CLOSE: $134, verb
B $6139,6,6 CLOSED: $139, adjective
B $613F,11,11 COMFORTABLE: $13F, adjective
B $614A,7,7 COUNTRY: $14A, noun
B $6151,5,5 CRACK: $151, noun
B $6156,5,5 CROSS: $156, verb
B $615B,8,8 CUPBOARD: $15B, noun
B $6163,7,7 CURIOUS: $163, adjective
B $616A,7,7 CURTAIN: $16A, noun
B $6171,7,7 CUNNING: $171, adjective
B $6178,4,4 CUT: $178, verb
B $617C,5,5 D: $17C = synonym for DOWN
B $6181,4,4 DALE: $181, noun
B $6185,9,9 DANGEROUS: $185, adjective
B $618E,4,4 DARK: $18E, adjective
B $6192,4,4 DEAD: $192, adjective
B $6196,4,4 DEEP: $196, adjective
B $619A,5,5 DENSE: $19A, adjective
B $619F,10,10 DESOLATION: $19F, noun
B $61A9,4,4 DIG: $1A9, verb
B $61AD,9,9 DIRECTION: $1AD, article/filler
B $61B6,10,10 DISGUSTING: $1B6, adjective
B $61C0,4,4 DO: $1C0, special word
B $61C4,4,4 DOOR: $1C4, noun
B $61C8,4,4 DOWN: $1C8, direction
B $61CC,6,6 DRAGON: $1CC, noun
B $61D2,7,7 DRAGONS: $1D2, adjective
B $61D9,8,8 DREADFUL: $1D9, adjective
B $61E1,6,6 DREARY: $1E1, adjective
B $61E7,5,5 DRINK: $1E7, verb
B $61EC,4,4 DROP: $1EC, verb
B $61F0,3,3 DRY: $1F0, adjective
B $61F3,7,7 DUNGEON: $1F3, noun
B $61FA,5,5 E: $1FA = synonym for EAST
B $61FF,3,3 EAR: $1FF, noun
B $6202,4,4 EAST: $202, direction
B $6206,4,4 EAT: $206, verb
B $620A,4,4 EDGE: $20A, adjective
B $620E,3,3 ELF: $20E, noun
B $6211,6,6 ELROND: $211, noun
B $6217,10,10 ELVENKINGS: $217, adjective
B $6221,5,5 ELVES: $221, noun
B $6226,6,6 ELVISH: $226, adjective
B $622C,5,5 EMPTY: $22C, verb
B $6231,5,5 ENTER: $231, verb
B $6236,12,12 EVERYTHING: $236 = synonym for ALL
B $6242,7,7 EXAMINE: $242, verb
B $6249,6,6 EXCEPT: $249, special word
B $624F,4,4 EYES: $24F, noun
B $6253,4,4 FALL: $253, verb
B $6257,4,4 FAST: $257, adjective
B $625B,6,6 FEEBLY: $25B, adverb
B $6261,4,4 FEET: $261, noun
B $6265,4,4 FILL: $265, verb
B $6269,6,6 FINGER: $269, noun
B $626F,4,4 FIST: $26F, noun
B $6273,6,6 FLAMES: $273, noun
B $6279,4,4 FLAT: $279, adjective
B $627D,5,5 FLOOR: $27D, noun
B $6282,7,7 FLOWING: $282, adjective
B $6289,6,6 FOLLOW: $289, verb
B $628F,4,4 FOOD: $28F, noun
B $6293,3,3 FOR: $293, preposition
B $6296,10,10 FORCEFULLY: $296, adverb
B $62A0,4,4 FORD: $2A0, noun
B $62A4,6,6 FOREST: $2A4, noun
B $62AA,11,11 FORESTRIVER: $2AA, noun
B $62B5,4,4 FOUL: $2B5, adjective
B $62B9,4,4 FROM: $2B9, preposition
B $62BD,4,4 FULL: $2BD, adjective
B $62C1,7,7 GANDALF: $2C1, noun
B $62C8,4,4 GATE: $2C8, noun
B $62CC,6,6 GENTLY: $2CC, adjective
B $62D2,6,6 GET: $2D2 = synonym for TAKE
B $62D8,4,4 GIVE: $2D8, verb
B $62DC,6,6 GLOOMY: $2DC, adjective
B $62E2,4,4 GO: $2E2, movement verb
B $62E6,6,6 GOBLIN: $2E6, noun
B $62EC,7,7 GOBLINS: $2EC, adjective
B $62F3,4,4 GOLD: $2F3, noun
B $62F7,6,6 GOLDEN: $2F7, adjective
B $62FD,6,6 GOLLUM: $2FD, noun
B $6303,5,5 GREAT: $303, adjective
B $6308,5,5 GREEN: $308, adjective
B $630D,4,4 HALL: $30D, noun
B $6311,5,5 HALLS: $311, noun
B $6316,4,4 HAND: $316, noun
B $631A,4,4 HARD: $31A, adjective
B $631E,4,4 HEAD: $31E, noun
B $6322,4,4 HELP: $322, special word
B $6326,5,5 HEART: $326, noun
B $632B,5,5 HEAVY: $32B, adjective
B $6330,5,5 HELLO: $330, verb
B $6335,6,6 HIDDEN: $335, adjective
B $633B,7,7 HIDEOUS: $33B, adjective
B $6342,4,4 HILL: $342, noun
B $6346,5,5 HILLS: $346, noun
B $634B,6,6 HIT: $34B = synonym for ATTACK
B $6351,6,6 HOBBIT: $351, adjective
B $6357,10,10 HOBBITLAND: $357, noun
B $6361,4,4 HOLE: $361, noun
B $6365,8,8 HORRIBLE: $365, adjective
B $636D,5,5 HOUSE: $36D, adjective
B $6372,5,5 HURRY: $372, verb
B $6377,5,5 I: $377 = synonym for INVENTORY
B $637C,3,3 IN: $37C, preposition (in/into)
B $637F,6,6 INSIDE: $37F, preposition
B $6385,13,13 INSIGNIFICANT: $385, adjective
B $6392,4,4 INTO: $392, preposition (in/into)
B $6396,9,9 INVENTORY: $396, verb
B $639F,3,3 IS: $39F, article/filler
B $63A2,3,3 IT: $3A2, special word
B $63A5,4,4 JUMP: $3A5, verb
B $63A9,3,3 KEY: $3A9, noun
B $63AC,6,6 KILL: $3AC = synonym for ATTACK
B $63B2,4,4 KING: $3B2, noun
B $63B6,5,5 L: $3B6 = synonym for LOOK
B $63BB,4,4 LAKE: $3BB, noun
B $63BF,4,4 LAND: $3BF, noun
B $63C3,5,5 LARGE: $3C3, adjective
B $63C8,5,5 LEAVE: $3C8, verb
B $63CD,3,3 LEG: $3CD, noun
B $63D0,8,8 LEVELLED: $3D0, adjective
B $63D8,6,6 LIFT: $3D8 = synonym for TAKE
B $63DE,4,4 LIKE: $3DE, adjective
B $63E2,5,5 LIGHT: $3E2, verb
B $63E7,6,6 LITTLE: $3E7, adjective
B $63ED,5,5 LO: $3ED = synonym for LOOK
B $63F2,4,4 LOAD: $3F2, special word
B $63F6,4,4 LOCK: $3F6, verb
B $63FA,6,6 LOCKED: $3FA, adjective
B $6400,4,4 LOGS: $400, noun
B $6404,9,9 LONELANDS: $404, noun
B $640D,6,6 LONELY: $40D, adjective
B $6413,4,4 LONG: $413, adjective
B $6417,4,4 LOOK: $417, verb
B $641B,3,3 LOW: $41B, adjective
B $641E,5,5 LOWER: $41E, adjective
B $6423,5,5 LUNCH: $423, noun
B $6428,5,5 MAGIC: $428, adjective
B $642D,3,3 MAN: $42D, noun
B $6430,3,3 MAP: $430, noun
B $6433,5,5 ME: $433 = synonym for YOU
B $6438,4,4 MEAN: $438, adjective
B $643C,8,8 MIRKWOOD: $43C, noun
B $6444,5,5 MISTY: $444, adjective
B $6449,9,9 MONSTROUS: $449, adjective
B $6452,8,8 MOUNTAIN: $452, noun
B $645A,9,9 MOUNTAINS: $45A, noun
B $6463,5,5 N: $463 = synonym for NORTH
B $6468,6,6 NARROW: $468, adjective
B $646E,5,5 NASTY: $46E, adjective
B $6473,5,5 NE: $473 = synonym for NORTHEAST
B $6478,5,5 NIGHT: $478, noun
B $647D,7,7 NOPRINT: $47D, special word
B $6484,5,5 NORTH: $484, direction
B $6489,9,9 NORTHEAST: $489, direction
B $6492,9,9 NORTHWEST: $492, direction
B $649B,5,5 NW: $49B = synonym for NORTHWEST
B $64A0,3,3 OF: $4A0, preposition
B $64A3,3,3 OFF: $4A3, preposition
B $64A6,5,5 OFFER: $4A6, verb
B $64AB,3,3 OLD: $4AB, adjective
B $64AE,3,3 ON: $4AE, preposition
B $64B1,3,3 ONE: $4B1, special word
B $64B4,4,4 ONTO: $4B4, preposition
B $64B8,4,4 OPEN: $4B8, verb
B $64BC,7,7 OPENING: $4BC, noun
B $64C3,3,3 OUT: $4C3, preposition
B $64C6,7,7 OUTSIDE: $4C6, adjective
B $64CD,4,4 OVER: $4CD, preposition
B $64D1,7,7 PASSAGE: $4D1, noun
B $64D8,4,4 PATH: $4D8, noun
B $64DC,5,5 PAUSE: $4DC, special word
B $64E1,6,6 PICK: $4E1 = synonym for CARRY
B $64E7,3,3 PIT: $4E7, noun
B $64EA,5,5 PLACE: $4EA, noun
B $64EF,6,6 PLEASE: $4EF, adverb
B $64F5,10,10 PORTCULLIS: $4F5, noun
B $64FF,5,5 PRINT: $4FF, special word
B $6504,4,4 PULL: $504, verb
B $6508,4,4 PUSH: $508, verb
B $650C,4,4 PUT: $50C, verb
B $6510,7,7 QUICKLY: $510, adverb
B $6517,5,5 QUIET: $517, adverb
B $651C,4,4 QUIT: $51C, special word
B $6520,5,5 QUITE: $520, adjective
B $6525,9,9 RAVENHILL: $525, noun
B $652E,6,6 RAVINE: $52E, noun
B $6534,6,6 READ: $534 = synonym for EXAMINE
B $653A,3,3 RED: $53A, adjective
B $653D,4,4 RIBS: $53D, noun
B $6541,4,4 RING: $541, noun
B $6545,9,9 RIVENDELL: $545, noun
B $654E,5,5 RIVER: $54E, noun
B $6553,4,4 ROAD: $553, noun
B $6557,4,4 ROCK: $557, adjective
B $655B,4,4 ROOM: $55B, noun
B $655F,4,4 ROPE: $55F, noun
B $6563,5,5 ROUND: $563, adjective
B $6568,3,3 RUG: $568, noun
B $656B,5,5 RUINS: $56B, noun
B $6570,4,4 RUN: $570, movement verb
B $6574,7,7 RUNNING: $574, noun
B $657B,5,5 S: $57B = synonym for SOUTH
B $6580,4,4 SAND: $580, noun
B $6584,4,4 SAVE: $584, special word
B $6588,6,6 SAY: $588 = synonym for TALK
B $658E,5,5 SCORE: $58E, special word
B $6593,5,5 SE: $593 = synonym for SOUTHEAST
B $6598,5,5 SHOOT: $598, verb
B $659D,5,5 SHORT: $59D, adjective
B $65A2,8,8 SHOULDER: $5A2, noun
B $65AA,4,4 SIDE: $5AA, adjective
B $65AE,8,8 SIDEDOOR: $5AE, noun
B $65B6,4,4 SIGN: $5B6, noun
B $65BA,4,4 SING: $5BA, verb
B $65BE,4,4 SIT: $5BE, verb
B $65C2,5,5 SKULL: $5C2, noun
B $65C7,7,7 SLASH: $5C7 = synonym for ATTACK
B $65CE,5,5 SLEEP: $5CE, verb
B $65D3,7,7 SLICE: $5D3 = synonym for ATTACK
B $65DA,5,5 SLIMY: $5DA, adjective
B $65DF,6,6 SLOWLY: $5DF, adverb
B $65E5,5,5 SMALL: $5E5, adjective
B $65EA,7,7 SMASH: $5EA = synonym for STRIKE
B $65F1,6,6 SMOOTH: $5F1, adjective
B $65F7,10,10 SMOTHERING: $5F7, adjective
B $6601,6,6 SOFTLY: $601, adverb
B $6607,4,4 SOME: $607, adjective
B $660B,5,5 SOUTH: $60B, direction
B $6610,9,9 SOUTHEAST: $610, direction
B $6619,9,9 SOUTHWEST: $619, direction
B $6622,5,5 SPACE: $622, noun
B $6627,6,6 SPIDER: $627, adjective
B $662D,6,6 STAIRS: $62D, noun
B $6633,6,6 STATUE: $633, noun
B $6639,7,7 STEAL: $639 = synonym for TAKE
B $6640,5,5 STEEP: $640, adjective
B $6645,5,5 STONE: $645, noun
B $664A,8,8 STRAIGHT: $64A, adjective
B $6652,10,10 STRETCHING: $652, adjective
B $665C,6,6 STRIKE: $65C, verb
B $6662,6,6 STROKE: $662, noun
B $6668,6,6 STRONG: $668, noun
B $666E,6,6 STUFFY: $66E, adjective
B $6674,7,7 STUNNED: $674, adjective
B $667B,5,5 SW: $67B = synonym for SOUTHWEST
B $6680,4,4 SWIM: $680, verb
B $6684,5,5 SWORD: $684, noun
B $6689,7,7 SYMBOLS: $689, noun
B $6690,4,4 TAKE: $690, verb
B $6694,4,4 TALK: $694, verb
B $6698,7,7 TANGLED: $698, adjective
B $669F,4,4 THAT: $69F, article/filler
B $66A3,3,3 THE: $6A3, article/filler
B $66A6,4,4 THEN: $6A6, THEN
B $66AA,5,5 THICK: $6AA, adjective
B $66AF,5,5 THIEF: $6AF, noun
B $66B4,4,4 THIN: $6B4, adjective
B $66B8,6,6 THORIN: $6B8, noun
B $66BE,7,7 THREADS: $6BE, adjective
B $66C5,7,7 THROUGH: $6C5, preposition
B $66CC,5,5 THROW: $6CC, verb
B $66D1,4,4 TIE: $6D1, verb
B $66D5,3,3 TO: $6D5, preposition
B $66D8,3,3 TOO: $6D8, preposition
B $66DB,5,5 TORCH: $6DB, noun
B $66E0,4,4 TOWN: $6E0, noun
B $66E4,4,4 TRAP: $6E4, adjective
B $66E8,8,8 TREASURE: $6E8, noun
B $66F0,4,4 TREE: $6F0, noun
B $66F4,8,8 TREELESS: $6F4, adjective
B $66FC,5,5 TROLL: $6FC, noun
B $6701,6,6 TROLLS: $701, adjective
B $6707,6,6 TUNNEL: $707, adjective
B $670D,4,4 TURN: $70D, verb
B $6711,5,5 U: $711 = synonym for UP
B $6716,6,6 UNLOCK: $716, verb
B $671C,8,8 UNLOCKED: $71C, adjective
B $6724,5,5 UNTIE: $724, verb
B $6729,3,3 UP: $729, direction
B $672C,7,7 VALIANT: $72C, adjective
B $6733,6,6 VALLEY: $733, noun
B $6739,8,8 VALUABLE: $739, adjective
B $6741,4,4 VERY: $741, adjective
B $6745,7,7 VICIOUS: $745, adjective
B $674C,9,9 VICIOUSLY: $74C, adverb
B $6755,5,5 W: $755 = synonym for WEST
B $675A,4,4 WAIT: $75A, verb
B $675E,4,4 WALL: $75E, noun
B $6762,5,5 WATER: $762, noun
B $6767,9,9 WATERFALL: $767, noun
B $6770,6,6 WEAPON: $770, noun
B $6776,4,4 WEAR: $776, verb
B $677A,3,3 WEB: $77A, noun
B $677D,4,4 WEST: $77D, direction
B $6781,4,4 WIDE: $781, adjective
B $6785,4,4 WILD: $785, adjective
B $6789,7,7 WINDING: $789, adjective
B $6790,6,6 WINDOW: $790, noun
B $6796,4,4 WINE: $796, noun
B $679A,4,4 WITH: $79A, preposition
B $679E,4,4 WARG: $79E, noun
B $67A2,4,4 WOOD: $7A2, adjective
B $67A6,6,6 WOODEN: $7A6, adjective
B $67AC,3,3 YOU: $7AC, noun
B $67AF,1,1 Separator
b $67B0 Second dictionary (message words)
D $67B0 A second word list, in exactly the same format as #R$6040, holding words that only the game ever prints: the vocabulary of fights, weather and narration. The player cannot type these words (the parser does not look here), but messages refer to them the same way, by offset from #R$6000. For example BROADSIDE is $84F, DEFENSE $8A6, EFFORT $8CF, FATAL $90C, GLANCING $94C, INEFFECTIVE $9A0, BULBOUS $858 and PALE $A70.
D $67B0 Keeping these out of the main dictionary made the parser's search shorter and stopped players from typing words that had no meaning as commands.
B $67B0,4,4 ABLE: $7B0
B $67B4,5,5 ABOUT: $7B4
B $67B9,5,5 ABOVE: $7B9
B $67BE,9,9 ADVENTURE: $7BE
B $67C7,5,5 AGAIN: $7C7
B $67CC,7,7 AGAINST: $7CC
B $67D3,5,5 AHEAD: $7D3
B $67D8,5,5 ALIVE: $7D8
B $67DD,6,6 ALMOST: $7DD
B $67E3,5,5 ALONG: $7E3
B $67E8,6,6 ANIMAL: $7E8
B $67EE,6,6 APPEAR: $7EE
B $67F4,3,3 APP: $7F4
B $67F7,5,5 ROACH: $7F7
B $67FC,6,6 AROUND: $7FC
B $6802,7,7 ARRIVES: $802
B $6809,3,3 AS: $809
B $680C,5,5 ASIDE: $80C
B $6811,6,6 ASLEEP: $811
B $6817,7,7 ATTEMPT: $817
B $681E,4,4 AWAY: $81E
B $6822,4,4 BANK: $822
B $6826,3,3 BE: $826
B $6829,6,6 BEHIND: $829
B $682F,5,5 BELOW: $82F
B $6834,8,8 BIRTHDAY: $834
B $683C,6,6 BLIMEY: $83C
B $6842,8,8 BRANDISH: $842
B $684A,5,5 BRINK: $84A
B $684F,9,9 BROADSIDE: $84F
B $6858,7,7 BULBOUS: $858
B $685F,3,3 BY: $85F
B $6862,8,8 CARRYING: $862
B $686A,6,6 CLEAVE: $86A
B $6870,5,5 CLIFF: $870
B $6875,4,4 COME: $875
B $6879,3,3 COM: $879
B $687C,5,5 PLETE: $87C
B $6881,14,14 CONGRATULATION: $881
B $688F,4,4 COOK: $88F
B $6893,7,7 CURRENT: $893
B $689A,5,5 CRISP: $89A
B $689F,4,4 DAWN: $89F
B $68A3,3,3 DAY: $8A3
B $68A6,7,7 DEFENSE: $8A6
B $68AD,8,8 DESCENDS: $8AD
B $68B5,3,3 DIE: $8B5
B $68B8,3,3 DID: $8B8
B $68BB,3,3 DIM: $8BB
B $68BE,8,8 DISTANCE: $8BE
B $68C6,3,3 DO: $8C6
B $68C9,6,6 DRIPS: $8C9
B $68CF,6,6 EFFORT: $8CF
B $68D5,4,4 END: $8D5
B $68D9,8,8 ENTRANCE: $8D9
B $68E1,9,9 EVAPORATE: $8E1
B $68EA,7,7 EVENING: $8EA
B $68F1,5,5 EXITS: $8F1
B $68F6,6,6 EXPECT: $8F6
B $68FC,6,6 FAILED: $8FC
B $6902,7,7 FAILING: $902
B $6909,3,3 FAR: $909
B $690C,5,5 FATAL: $90C
B $6911,4,4 FEED: $911
B $6915,4,4 FELT: $915
B $6919,3,3 FIT: $919
B $691C,5,5 FIRST: $91C
B $6921,5,5 FLAME: $921
B $6926,5,5 FLOAT: $926
B $692B,6,6 FLYING: $92B
B $6931,4,4 FOOT: $931
B $6935,7,7 FOOTING: $935
B $693C,4,4 FOUR: $93C
B $6940,5,5 FRONT: $940
B $6945,7,7 GETTING: $945
B $694C,8,8 GLANCING: $94C
B $6954,6,6 GLIDES: $954
B $695A,8,8 GLUTTONY: $95A
B $6962,3,3 GOT: $962
B $6965,6,6 GROUND: $965
B $696B,4,4 GROW: $96B
B $696F,5,5 GUARD: $96F
B $6974,7,7 HANGING: $974
B $697B,3,3 HAS: $97B
B $697E,4,4 HAVE: $97E
B $6982,3,3 HE: $982
B $6985,3,3 HEA: $985
B $6988,5,5 RHERE: $988
B $698D,3,3 HIM: $98D
B $6990,3,3 HIS: $990
B $6993,3,3 HOW: $993
B $6996,5,5 HOWLS: $996
B $699B,5,5 HURRY: $99B
B $69A0,11,11 INEFFECTIVE: $9A0
B $69AB,3,3 ITS: $9AB
B $69AE,3,3 JOB: $9AE
B $69B1,4,4 JUST: $9B1
B $69B5,5,5 LURCH: $9B5
B $69BA,5,5 KEEPS: $9BA
B $69BF,6,6 KNOCKS: $9BF
B $69C5,4,4 KNOW: $9C5
B $69C9,4,4 LAST: $9C9
B $69CD,6,6 LAUGHS: $9CD
B $69D3,8,8 LAUGHTER: $9D3
B $69DB,4,4 LIE: $9DB
B $69DF,4,4 LIFE: $9DF
B $69E3,5,5 LIVES: $9E3
B $69E8,4,4 LOSE: $9E8
B $69EC,4,4 LOUD: $9EC
B $69F0,5,5 LUCKY: $9F0
B $69F5,4,4 MADE: $9F5
B $69F9,4,4 MAKE: $9F9
B $69FD,6,6 MARGIN: $9FD
B $6A03,10,10 MARVELLOUS: $A03
B $6A0D,3,3 MAY: $A0D
B $6A10,5,5 MAYBE: $A10
B $6A15,3,3 MEN: $A15
B $6A18,7,7 DMIDDLE: $A18
B $6A1F,6,6 MIDDAY: $A1F
B $6A25,4,4 MISS: $A25
B $6A29,6,6 MOMENT: $A29
B $6A2F,11,11 MOMENTARILY: $A2F
B $6A3A,3,3 MOR: $A3A
B $6A3D,10,10 NMOUTHFULL: $A3D
B $6A47,4,4 MOVE: $A47
B $6A4B,4,4 MUCH: $A4B
B $6A4F,3,3 MY: $A4F
B $6A52,3,3 NO: $A52
B $6A55,5,5 NOISE: $A55
B $6A5A,3,3 NOT: $A5A
B $6A5D,7,7 NOTHING: $A5D
B $6A64,3,3 NOW: $A64
B $6A67,4,4 ONCE: $A67
B $6A6B,5,5 OTHER: $A6B
B $6A70,4,4 PALE: $A70
B $6A74,6,6 PASSES: $A74
B $6A7A,4,4 PAST: $A7A
B $6A7E,3,3 PLA: $A7E
B $6A81,4,4 CEPO: $A81
B $6A85,4,4 CKET: $A85
B $6A89,8,8 PRECIOUS: $A89
B $6A91,7,7 PREPARE: $A91
B $6A98,7,7 PRESENT: $A98
B $6A9F,5,5 REACH: $A9F
B $6AA4,7,7 RECOVER: $AA4
B $6AAB,4,4 SAIL: $AAB
B $6AAF,3,3 SEE: $AAF
B $6AB2,4,4 SEEM: $AB2
B $6AB6,6,6 SHADOW: $AB6
B $6ABC,5,5 SHAPE: $ABC
B $6AC1,7,7 SHATTER: $AC1
B $6AC8,3,3 SIN: $AC8
B $6ACB,3,3 GSI: $ACB
B $6ACE,4,4 NKSI: $ACE
B $6AD2,4,4 TSL: $AD2
B $6AD6,3,3 IDE: $AD6
B $6AD9,5,5 SMELL: $AD9
B $6ADE,5,5 SMELT: $ADE
B $6AE3,7,7 SOMEONE: $AE3
B $6AEA,9,9 SOMEWHERE: $AEA
B $6AF3,4,4 SOON: $AF3
B $6AF7,7,7 SPECIAL: $AF7
B $6AFE,5,5 SPOUT: $AFE
B $6B03,7,7 STAGGER: $B03
B $6B0A,3,3 STA: $B0A
B $6B0D,4,4 NDST: $B0D
B $6B11,4,4 ARST: $B11
B $6B15,4,4 ARST: $B15
B $6B19,3,3 ART: $B19
B $6B1C,5,5 STILL: $B1C
B $6B21,5,5 STING: $B21
B $6B26,8,8 STRANGLE: $B26
B $6B2E,8,8 STRENGTH: $B2E
B $6B36,10,10 SURROUNDED: $B36
B $6B40,6,6 SWEEPS: $B40
B $6B46,5,5 SWEPT: $B46
B $6B4B,5,5 SWING: $B4B
B $6B50,8,8 TERRIFIC: $B50
B $6B58,5,5 THANK: $B58
B $6B5D,4,4 THEM: $B5D
B $6B61,5,5 THERE: $B61
B $6B66,5,5 THING: $B66
B $6B6B,4,4 THIS: $B6B
B $6B6F,7,7 THRAINS: $B6F
B $6B76,5,5 THREE: $B76
B $6B7B,6,6 THROWN: $B7B
B $6B81,6,6 THRUST: $B81
B $6B87,4,4 TIME: $B87
B $6B8B,5,5 TIRED: $B8B
B $6B90,3,3 TRY: $B90
B $6B93,5,5 TOUCH: $B93
B $6B98,3,3 TWO: $B98
B $6B9B,5,5 UNDER: $B9B
B $6BA0,3,3 US: $BA0
B $6BA3,6,6 VANISH: $BA3
B $6BA9,4,4 VERB: $BA9
B $6BAD,7,7 VISIBLE: $BAD
B $6BB4,4,4 WARN: $BB4
B $6BB8,3,3 WAS: $BB8
B $6BBB,6,6 WASTED: $BBB
B $6BC1,3,3 WE: $BC1
B $6BC4,4,4 WELL: $BC4
B $6BC8,4,4 WHAT: $BC8
B $6BCC,5,5 WHERE: $BCC
B $6BD1,5,5 WHICH: $BD1
B $6BD6,4,4 WILL: $BD6
B $6BDA,4,4 WIND: $BDA
B $6BDE,4,4 WORD: $BDE
B $6BE2,5,5 WOULD: $BE2
B $6BE7,3,3 YER: $BE7
B $6BEA,4,4 YOUR: $BEA
u $6BEE Unused
D $6BEE Zero bytes up to the start of the code at #R$6C00.
c $6C00 Game entry point (RANDOMIZE USR 27648)
D $6C00 The BASIC loader 'hobbit' loads the loading screen to 40000, copies it onto the display, loads this 37,888-byte block at 24576 (#R$6000) and then does RANDOMIZE USR 27648, which arrives here.
D $6C00 The first job is to make pristine copies of everything that changes during play, so the game can be restarted after Bilbo dies without reloading the tape: the object table (#R$C00B, $614 bytes) and the room table (#R$B97A, $5D9 bytes) are copied up to $F400 onwards, the 28 bytes of game variables at #R$B5DC are copied to $5F00, and the timer and character tables at #R$C973 ($BF bytes) follow the room copy.
D $6C00 Execution then falls through into #R$6C27, which is also the restart point.
C $6C00 Disable interrupts
C $6C01 Back up the object table...
C $6C04 HL = the object table (Bilbo's record)
C $6C07 BC = $0614
C $6C0A Copy BC bytes from HL to DE
C $6C0C ...and the room table...
C $6C0F BC = $05D9
C $6C12 Copy BC bytes from HL to DE
C $6C14 ...the game variables at B5DC...
C $6C17 HL = the address of the saved variables
C $6C1A BC = 28
C $6C1D Copy BC bytes from HL to DE
C $6C1F ...and the timer/character tables
C $6C22 BC = 191
C $6C25 Copy BC bytes from HL to DE
c $6C27 Start or restart a game
D $6C27 This is where the game begins, and where it comes back to after 'you are dead' (see #R$903C). It is the reverse of #R$6C00: the backed-up copies of the object table, room table, variables and timer tables are copied back over the live ones, so every object, character, door and timer returns to its starting state.
D $6C27 It then sets the border to black, waits for a key press (the IN A,($FE) loop at #R$6C6E: keys read as 0 bits, so the loop continues while all five bits are 1), sets up the text window variables used by the printer (#R$75AD), clears a 200-byte work area at #R$B628, and seeds the random number generator from the Z80's R (refresh) register at #R$6C9E. Because R counts instructions, the seed depends on exactly how long the player took to press a key, which is why every game plays out differently.
D $6C27 The routine then clears the screen (#R$6FCA), draws the bar that separates the story window from the input window (a 5-line pattern from #R$6DC3, repeated across the screen at $5140), sets the line counter used by the story window's pause (#R$7694) to 17, and, if this is a fresh start (the frame count at $B5F7 is $FF, as it always is after the variables are restored), makes the game's random choices (#R$970B), puts the first command, LOOK, into the input buffer (copied from #R$6FEB to #R$6FF0), and drops into the main loop at #R$6D0A.
C $6C27 Disable interrupts
C $6C28 SP = $5EFF
C $6C2B IX = the picture index
C $6C2F A = 5
C $6C31 Call: Search a table of 3-byte entries (#R$9D12)
C $6C34 L = the low byte of the address of the table entry
C $6C37 H = the high byte of the address of the table entry
C $6C3A Store $00 at (HL)
C $6C3C Increment HL
C $6C3D Store $00 at (HL)
C $6C3F Restore objects, rooms, variables and timers from the backups
C $6C42 DE = the object table (Bilbo's record)
C $6C45 BC = $0614
C $6C48 Copy BC bytes from HL to DE
C $6C4A DE = the address of room 0's flags
C $6C4D BC = $05D9
C $6C50 Copy BC bytes from HL to DE
C $6C52 HL = $5F00
C $6C55 DE = the address of the saved variables
C $6C58 BC = 28
C $6C5B Copy BC bytes from HL to DE
C $6C5D DE = the timer table
C $6C60 BC = 191
C $6C63 Copy BC bytes from HL to DE
C $6C65 A = 0
C $6C66 Write to the port (border colour, beeper or printer)
C $6C68 A = 56
C $6C6A Store A at $5C48
C $6C6D A = 0
C $6C6E Wait until a key is pressed
C $6C70 Keep only the bits of $1F
C $6C72 Compare with 31
C $6C74 If yes, go to #R$6C6D
C $6C76 HL = $50E0
C $6C79 Store HL in the lower window print position
C $6C7C A = 43
C $6C7E Store A at $75AB
C $6C81 HL = $5020
C $6C84 Store HL in the story window print position
C $6C87 A = 1
C $6C89 Store A in the pixel offset
C $6C8C A = 32
C $6C8E Store A in the columns left in the lower window
C $6C91 A = 42
C $6C93 Store A in the characters left on the line
C $6C96 B = 200
C $6C98 HL = the orders buffer
C $6C9B Call: Clear a block of memory (#R$70D9)
C $6C9E Seed the random number generator from R
C $6CA0 Store A in the random seed
C $6CA3 A = 0
C $6CA4 Store A in the indent
C $6CA7 Store A at $7693
C $6CAA Store A in the "unfinished command" flag
C $6CAD Store A in the drunkenness flag
C $6CB0 Store A in the printer flag
C $6CB3 A = 1
C $6CB5 Store A in the "visible to Bilbo" output flag
C $6CB8 Store A in the "really do it" flag
C $6CBB Store A in the capitalisation flag
C $6CBE HL = 0
C $6CC1 Store HL in the score
C $6CC4 Call: Clear the screen (#R$6FCA)
C $6CC7 HL = $5140
C $6CCA DE = Window separator pattern (#R$6DC3)
C $6CCD C = 5
C $6CCF B = 16
C $6CD1 Save HL
C $6CD2 A = (DE)
C $6CD3 Store A at (HL)
C $6CD4 Increment HL
C $6CD5 Increment DE
C $6CD6 A = (DE)
C $6CD7 Store A at (HL)
C $6CD8 Increment HL
C $6CD9 Decrement DE
C $6CDA Loop back until B reaches 0
C $6CDC Increment DE
C $6CDD Increment DE
C $6CDE Restore HL
C $6CDF Increment H
C $6CE0 Decrement C
C $6CE1 If the routine returned with Z reset, go to #R$6CCF
C $6CE3 A = 17
C $6CE5 Store A in the lines left before pausing
C $6CE8 A = the number of command frames
C $6CEB Increment A
C $6CEC If the routine returned with Z reset, go to Main command loop (#R$6D0A)
C $6CEE Call: Choose the random features of a new game (#R$970B)
C $6CF1 HL = Initial prompt and command (#R$6FE9)
C $6CF4 A = (HL)
C $6CF5 Call: Print a character in the lower (input) window (#R$75AD)
C $6CF8 Increment HL
C $6CF9 Compare with 13
C $6CFB If no, go to #R$6CF4
C $6CFD Prime the input buffer with "LOOK"
C $6D00 DE = Input buffer (#R$6FF0)
C $6D03 BC = 5
C $6D06 Copy BC bytes from HL to DE
C $6D08 Continue at #R$6D19
c $6D0A Main command loop
D $6D0A This is the heart of the game. Each pass round the loop is one line of input from the player:
D $6D0A 1. #R$6DCD prints the '>' prompt and reads a line of text into the input buffer at #R$6FF0. If the player types nothing for a while, #R$7240 types WAIT on their behalf, so time passes in The Hobbit even if you do not.
D $6D0A 2. The token buffer at #R$7093 is cleared (#R$70D9), and then #R$6E8E is called repeatedly to turn the line into tokens, one per word. Each token is two bytes, stored high byte first: the high byte is the word's class (see #R$6040) in its top four bits plus the top four bits of the word's 12-bit dictionary offset; the low byte is the bottom eight bits of the offset.
D $6D0A 3. Double quotes get special treatment (from #R$6D2F). A quote comes back from #R$6E8E as class $90 with an offset of 0. The flag at $B60B records whether we are inside a quotation. At an opening quote the flag is set. At a closing quote the flag is cleared and, unless the previous token was already a comma ($A0) or full stop ($B0), a full-stop token is inserted before the quote token, so that whatever was said to a character ends like a complete sentence.
D $6D0A 4. Tokens are stored until the end-of-line token ($C0). A token of class $D0 means the word was not in the dictionary: the game jumps to #R$6D99, which prints a message saying it does not know the word and quotes the word back from the input line (up to the next space or quote, using the pointer at #R$B5CB). If the line ends with a quotation still open, #R$7FF9 is called to complain and the line is thrown away.
D $6D0A 5. #R$7C4F parses the tokens into an action, and #R$8351 executes it and lets the rest of the world take its turn. If the line contained more than one command (separated by AND, THEN, commas or full stops), the loop at #R$6D8D goes back into the parser for the next one while the flag at $B5F6 is set.
D $6D0A The main loop can also be entered at #R$6D17 with the Z flag set, from the '@' key (see #R$6E71), which re-parses the tokens left over from the previous line: in other words, it repeats the last command.
C $6D0A A = 1
C $6D0C Store A in the "more commands" flag
C $6D0F A = 9
C $6D11 Store A in the lines left before pausing
C $6D14 Read a line of input
C $6D17 Z set: repeat the previous command
C $6D19 HL = Token buffer (#R$7093)
C $6D1C B = 64
C $6D1E Clear the token buffer
C $6D21 HL = Input buffer (#R$6FF0)
C $6D24 IY = Token buffer (#R$7093)
C $6D28 Turn the next word into a token
C $6D2B End of line?
C $6D2D If yes, go to #R$6D99
C $6D2F A quote?
C $6D31 If no, go to #R$6D63
C $6D33 A = B
C $6D34 Keep only the bits of $0F
C $6D36 Combine with C
C $6D37 If it is not zero, go to #R$6D63
C $6D39 Opening or closing quote?
C $6D3C Is A zero?
C $6D3D If it is not zero, go to #R$6D45
C $6D3F Increment A
C $6D40 Store A in the quotation level
C $6D43 Continue at #R$6D63
C $6D45 Decrement A
C $6D46 Store A in the quotation level
C $6D49 Closing quote: was the previous token a comma or full stop?
C $6D4C Keep only the bits of $F0
C $6D4E Compare with 176
C $6D50 If yes, go to #R$6D63
C $6D52 Compare with 160
C $6D54 If yes, go to #R$6D63
C $6D56 No: insert a full stop token
C $6D58 Store A at (IY+0)
C $6D5B A = 0
C $6D5C Store A at (IY+1)
C $6D5F Increment IY
C $6D61 Increment IY
C $6D63 Store the token
C $6D66 Store C at (IY+1)
C $6D69 Increment IY
C $6D6B Increment IY
C $6D6D Loop until the end-of-line token ($C0)
C $6D6E Compare with 192
C $6D70 If no, go to #R$6D28
C $6D72 Quote still open at the end of the line?
C $6D75 Is A zero?
C $6D76 If it is zero, go to #R$6D81
C $6D78 A = 0
C $6D79 Store A in the quotation level
C $6D7C Yes: complain and start again
C $6D7F Continue at Main command loop (#R$6D0A)
C $6D81 Parse the tokens
C $6D84 Store HL in the token pointer
C $6D87 Call: Parse the command (#R$7C4F)
C $6D8A If the routine returned with Z reset, go to Main command loop (#R$6D0A)
C $6D8D Execute the command and run the rest of the turn
C $6D90 More commands on this line?
C $6D93 Is A zero?
C $6D94 If it is not zero, go to #R$6D87
C $6D96 Finish by jumping to Main command loop (#R$6D0A)
C $6D99 Unknown word: complain and quote it
C $6D9C A = 1
C $6D9E Store A in the lower-window flag
C $6DA1 Print the message at HL
C $6DA4 HL = the start of the current word
C $6DA7 A = (HL)
C $6DA8 Compare with 13
C $6DAA If yes, go to #R$6DB8
C $6DAC Is it """?
C $6DAE If yes, go to #R$6DB8
C $6DB0 Print the character in A
C $6DB3 Increment HL
C $6DB4 Is it " "?
C $6DB6 If no, go to #R$6DA7
C $6DB8 A = 34
C $6DBA Print the character in A
C $6DBD Print a new line
C $6DC0 Finish by jumping to Main command loop (#R$6D0A)
b $6DC3 Window separator pattern
D $6DC3 Five pairs of bytes, one pair for each of five pixel lines. At start-up (#R$6C27, from #R$6CC7) each pair is repeated 16 times across the screen at $5140, drawing the patterned bar that separates the story window from the input window below it.
B $6DC3,10,10
c $6DCD Read a line of input from the keyboard
D $6DCD This is The Hobbit's line editor. It starts by setting the idle timer at $B604 to 3000 (see #R$7240), and setting $B5F2 and $B5EB to 1, then prints the '>' prompt and a space.
D $6DCD Characters are collected into the input buffer at #R$6FF0. B counts the space left, starting at 128 ($80), so bit 7 of B being set means that nothing has been typed yet. C is 0 until the first key has been handled.
D $6DCD Keys are fetched by #R$7240, which also types WAIT for the player if they are idle for too long. Each key is then handled as follows:
D $6DCD #LIST { '@' ($40, SYMBOL SHIFT + 2) as the very first key: repeat the last command (#R$6E71). } { Any key that is the first key of the line: #R$6E46 checks for the cursor keys, which produce a one-letter movement command on their own. } { $18 (SYMBOL SHIFT + 0): delete the whole line (#R$6E82). } { $08 (CAPS SHIFT + 0 or 5, or 5 on its own): delete the last character, by printing a backspace, putting B back up by one and moving HL back, unless the line is empty. } { Letters (codes $40 and above), space, double quote, full stop, comma and ENTER are accepted. Everything else is ignored. } LIST#
D $6DCD An accepted character is stored in $B5F5 (the printer uses this to remember the last punctuation mark), echoed to the screen via #R$7580, and put in the buffer, as long as there is room (B not 0). ENTER ($0D) ends the line: it is stored like any other character, and the routine returns with the Z flag reset.
D $6DCD Note that letters are not converted to upper case here. They do not need to be: the tokeniser keeps only the low five bits of each letter (#R$6F3E), and that is the same for 'a' and 'A'.
R $6DCD Output:F Z reset for a normal line; Z set if the previous command is to be repeated
C $6DCD Allow 3000 key polls before WAIT is typed automatically
C $6DD0 Store HL in the idle counter
C $6DD3 A = 1
C $6DD5 Store A in the lower-window flag
C $6DD8 Store A in the "really do it" flag
C $6DDB Print the prompt "> "
C $6DDD Print the character in A
C $6DE0 A = 32
C $6DE2 Print the character in A
C $6DE5 HL = input buffer, B = 128 characters of space, C = 0 (no keys yet)
C $6DE8 B = 128
C $6DEA C = 0
C $6DEC Wait for a key
C $6DEF First character of the line?
C $6DF1 If the bit is clear, go to #R$6DF8
C $6DF3 "@" as the first key: repeat the last command
C $6DF5 If yes, go to Repeat the last command (#R$6E71)
C $6DF8 First key of the line: check for cursor-key shortcuts
C $6DFA If zero/equal: call: Cursor-key shortcuts (#R$6E46)
C $6DFD C = 1
C $6DFF SYMBOL SHIFT + 0: delete the whole line
C $6E01 If no, go to #R$6E08
C $6E03 Call: Delete the whole input line (#R$6E82)
C $6E06 Continue at #R$6DEA
C $6E08 Backspace?
C $6E0A If no, go to #R$6E19
C $6E0C Ignore it if the line is empty
C $6E0E If the bit is set, go to #R$6DEC
C $6E10 Otherwise rub out the last character
C $6E12 Print the character in A
C $6E15 Increment B
C $6E16 Decrement HL
C $6E17 Continue at #R$6DEC
C $6E19 Accept letters...
C $6E1B If A >= 64, go to #R$6E31
C $6E1D ...double quote, space, ENTER, full stop and comma
C $6E1F If yes, go to #R$6E31
C $6E21 Is it " "?
C $6E23 If yes, go to #R$6E31
C $6E25 Compare with 13
C $6E27 If yes, go to #R$6E31
C $6E29 Is it "."?
C $6E2B If yes, go to #R$6E31
C $6E2D Is it ","?
C $6E2F If no, go to #R$6DEC
C $6E31 Remember the character for the printer
C $6E34 Buffer full?
C $6E35 Increment B
C $6E36 If Z is set, go to #R$6E3E
C $6E38 Echo the character and store it
C $6E3B Store A at (HL)
C $6E3C Increment HL
C $6E3D Decrement B
C $6E3E Loop until ENTER
C $6E40 If no, go to #R$6DEC
C $6E43 Return with Z reset
C $6E45 Done
c $6E46 Cursor-key shortcuts
D $6E46 Called by #R$6DCD for the first key of a line only. If the key is one of the four cursor keys, this routine types a complete movement command on its own and ends the line, so that a single key press moves Bilbo. The key codes come from the keyboard tables at #R$7BEE and #R$7C16:
D $6E46 #TABLE(default) { =h Key | =h Code | =h Command } { 7 (up) | $5B | N } { 6 (down) | $0A | S } { 8 (right) | $09 | E } { 5 (left) | $08 | W } TABLE#
D $6E46 The key works with or without CAPS SHIFT. The letter is stored in the input buffer and echoed, an ENTER ($0D) is stored after it, and the routine returns with A=$0D. The line editor then carries on as if the player had pressed ENTER: it prints the new line, stores a second (harmless) ENTER and finishes the line. So one key press both types and enters the command.
D $6E46 For any other key the routine returns with A unchanged and the line editor deals with the key as usual. The code for the left cursor ($08) is also the backspace code; this is why cursor-left only means 'west' as the first key of a line, and means 'delete' afterwards. Cursor right and down later in a line are simply ignored.
R $6E46 Input:A Key code
R $6E46 HL Current position in the input buffer
R $6E46 B Space left in the buffer
R $6E46 Output:A $0D if a movement command was typed, otherwise unchanged
C $6E46 Cursor right?
C $6E48 If yes, go to #R$6E69
C $6E4A Cursor left?
C $6E4C If yes, go to #R$6E6D
C $6E4E Cursor down?
C $6E50 If yes, go to #R$6E65
C $6E52 Cursor up (code $5B)? If not, return with A unchanged
C $6E54 Return if no
C $6E55 Up: "N"
C $6E57 Store the letter...
C $6E58 Increment HL
C $6E59 ...and echo it
C $6E5C Decrement B
C $6E5D Then store an ENTER
C $6E5F Store A at (HL)
C $6E60 Increment HL
C $6E61 Decrement B
C $6E62 Return with A=$0D (ENTER)
C $6E64 Done
C $6E65 Down: "S"
C $6E67 Continue at #R$6E57
C $6E69 Right: "E"
C $6E6B Continue at #R$6E57
C $6E6D Left: "W"
C $6E6F Continue at #R$6E57
c $6E71 Repeat the last command
D $6E71 Called by #R$6DCD when the first key of a line is '@' (SYMBOL SHIFT + 2).
D $6E71 If the game is waiting for the answer to a question such as 'which key?' (the flag at $B60A, set by #R$8765), the '@' is thrown away and the line editor goes back to waiting for a key.
D $6E71 Otherwise two backspaces are printed to rub out the '> ' prompt, and the routine returns with the Z flag set. (#R$6DCD jumps here rather than calling it, so this return goes straight back to the main loop.) The main loop (#R$6D0A) then skips tokenising and hands the old contents of the token buffer (#R$7093) straight back to the parser. The effect is that '@' repeats the previous command, without it appearing on the screen again.
R $6E71 Output:F Z set to repeat the last command
C $6E71 Is a command still pending?
C $6E74 Is A zero?
C $6E75 Yes: ignore the key and carry on reading the line
C $6E78 Rub out the "> " prompt
C $6E7A Print the character in A
C $6E7D Print the character in A
C $6E80 Return with Z set: repeat the last command
C $6E81 Done
c $6E82 Delete the whole input line
D $6E82 Rubs out everything typed so far. While B has bit 7 reset (i.e. at least one character has been typed; see #R$6DCD), it prints a backspace, puts B back up by one and moves HL back one character.
D $6E82 Called for SYMBOL SHIFT + 0 by the line editor, and by #R$7240 before it types WAIT for an idle player, so that anything half-typed is thrown away and replaced by WAIT.
R $6E82 Input:HL Current position in the input buffer
R $6E82 B Space left in the buffer
C $6E82 Stop when the line is empty
C $6E84 Return if the bit is set
C $6E85 Print a backspace
C $6E87 Print the character in A
C $6E8A One more character of space; step back in the buffer
C $6E8B Decrement HL
C $6E8C Continue at Delete the whole input line (#R$6E82)
c $6E8E Turn the next word of the input into a token
D $6E8E The tokeniser. Starting at HL in the input buffer, it skips spaces, finds the next word or punctuation mark, and returns its class in A and a two-byte token in B (high) and C (low). HL is left after the word, ready for the next call. The address of the start of the word is stored at #R$B5CB so that an 'I don't know the word' message can quote it.
D $6E8E #TABLE(default) { =h Input | =h A | =h BC } { End of line (ENTER) | $C0 | $C000 } { Full stop | $B0 | $B000 } { Comma | $A0 | $A000 } { Double quote | $90 | #R$9000 } { A dictionary word | its class | class in the top nibble of B, then the 12-bit offset of the word from #R$6000 } { An unknown word | $D0 | undefined } TABLE#
D $6E8E The search works like this:
D $6E8E 1. #R$6F3E copies the typed letters (keeping only their low five bits, so case does not matter) into the buffer at #R$7071 and their count into #R$7081. It then uses the letter index at #R$6000 to find the first dictionary word beginning with the same letter, and unpacks that word into the buffer at #R$7082 (count in #R$7092). If there are no words for that letter, the word is unknown.
D $6E8E 2. #R$6FB1 compares the typed letters with the dictionary word, over the length of the shorter of the two.
D $6E8E 3. If they differ, #R$6F69 unpacks the next word in the dictionary and the comparison is repeated. The search gives up (unknown word) as soon as it reaches a word with a different first letter.
D $6E8E 4. If they agree, the lengths decide (#R$6EB7). If the dictionary word is at least as long as what was typed, it is accepted. So any abbreviation matches the first word that starts with those letters: this is why N means NORTH, but also why EX finds EXAMINE and not EXCEPT. If the player typed MORE letters than the dictionary word has, and the dictionary word is 1-3 letters long, it is rejected and the search moves on (so typing EASTWARD does not match E). If the dictionary word is 4 letters or longer, the game looks at the following dictionary word (#R$6F6D, without moving the current position); if that one also matches the typed letters, the search moves on to it, otherwise the current word is accepted. So extra letters after a long enough word are ignored: SWORDS finds SWORD, and TROLLS finds TROLLS rather than TROLL.
D $6E8E 5. For the accepted word (#R$6EE2), the end of the word is found. If bit 6 of the last letter is set, the word is a synonym and the next two bytes give the offset of the real word; HL is switched to that word, so for example HIT is returned as ATTACK. The class is then assembled from bits 5 and 6 of the real word's first two bytes (see #R$6040), and $A000 is added to the word's address to turn it into an offset from #R$6000 (because #R$6000 + $A000 = $10000).
R $6E8E Input:HL Position in the input buffer
R $6E8E Output:A Word class
R $6E8E BC Token
R $6E8E HL Position after the word
C $6E8E Save DE
C $6E8F Skip spaces
C $6E90 Increment HL
C $6E91 Is it " "?
C $6E93 If yes, go to #R$6E8F
C $6E95 Decrement HL
C $6E96 Remember where the word starts
C $6E99 End of the line?
C $6E9B If yes, go to #R$6ED5
C $6E9D Punctuation?
C $6EA0 If the routine returned with Z set, go to #R$6EDA
C $6EA2 Copy the typed word and find the first dictionary word with the same first letter
C $6EA5 No words start with this letter: unknown word
C $6EA7 Save HL
C $6EA8 Compare the typed word with the dictionary word
C $6EAB If the routine returned with Z set, go to #R$6EB7
C $6EAD Different: try the next dictionary word
C $6EB0 If the routine returned with Z set, go to #R$6EA8
C $6EB2 Restore HL
C $6EB3 Class $D0: unknown word
C $6EB5 Continue at #R$6ED7
C $6EB7 Letters agree. Is the dictionary word at least as long as the typed word?
C $6EBA B = A
C $6EBB A = the dictionary word length
C $6EBE Compare with B
C $6EBF If carry clear, go to #R$6EE2
C $6EC1 No: reject dictionary words of 1-3 letters
C $6EC3 If A < 4, go to #R$6EAD
C $6EC5 Save IX
C $6EC7 Otherwise, does the next dictionary word also fit?
C $6ECA If the routine returned with Z reset, go to #R$6EE0
C $6ECC Call: Compare the typed word with a dictionary word (#R$6FB1)
C $6ECF If the routine returned with Z reset, go to #R$6EE0
C $6ED1 Restore IX
C $6ED3 Continue at #R$6EAD
C $6ED5 End of line: class $C0
C $6ED7 BC = 0
C $6EDA Put the class into the top of B and return it in A
C $6EDB D = A
C $6EDC Add A,B
C $6EDD B = A
C $6EDE A = D
C $6EDF Done
C $6EE0 Restore IX
C $6EE2 Accept the dictionary word at (B607): find its last letter
C $6EE6 Save IX
C $6EE8 A = 0
C $6EE9 Increment IX
C $6EEB Increment A
C $6EEC Test bit 7 of (IX-$01)
C $6EF0 If the bit is clear, go to #R$6EE9
C $6EF2 Compare with 2
C $6EF4 If yes, go to #R$6EE9
C $6EF6 Compare with 3
C $6EF8 If no, go to #R$6F00
C $6EFA Test bit 7 of (IX-$02)
C $6EFE If the bit is set, go to #R$6EE9
C $6F00 Is it a synonym?
C $6F04 If the bit is clear, go to #R$6F11
C $6F06 Yes: switch to the word it stands for
C $6F09 H = (IX+1)
C $6F0C DE = Dictionary letter index (#R$6000)
C $6F0F Add HL,DE
C $6F10 Swap HL with the value on top of the stack
C $6F11 Restore HL
C $6F12 Build the class from bits 5-6 of the first two bytes
C $6F13 Rotate A left
C $6F14 Keep only the bits of $C0
C $6F16 B = A
C $6F17 Increment HL
C $6F18 A = (HL)
C $6F19 Rotate A right
C $6F1A Keep only the bits of $30
C $6F1C Add A,B
C $6F1D Decrement HL
C $6F1E Turn the address into an offset from #R$6000
C $6F21 Add HL,DE
C $6F22 Save HL
C $6F23 Restore BC
C $6F24 Restore HL
C $6F25 Continue at #R$6EDA
c $6F27 Recognise punctuation
D $6F27 Checks whether the character in A is a full stop, comma or double quote. If it is, HL is moved past it, A is set to the corresponding token class ($B0 for a full stop, the same as THEN; $A0 for a comma, the same as AND; $90 for a quote) and BC is set to 0; the Z flag is left set from the successful comparison. If not, the routine returns with the Z flag reset.
R $6F27 Input:A Character
R $6F27 HL Its address
R $6F27 Output:F Z set if it was punctuation
R $6F27 A Token class
R $6F27 BC 0
C $6F27 Full stop: class $B0 (like THEN)
C $6F29 Is it "."?
C $6F2B If yes, go to #R$6F38
C $6F2D Comma: class $A0 (like AND)
C $6F2F Is it ","?
C $6F31 If yes, go to #R$6F38
C $6F33 Double quote: class $90
C $6F35 Return if no
C $6F36 B = 144
C $6F38 Step past the punctuation mark
C $6F39 A = B
C $6F3A BC = 0
C $6F3D Done
c $6F3E Start a dictionary search for the typed word
D $6F3E Copies the letters of the word at HL into the buffer at #R$7071, keeping only the low five bits of each (so 'a' and 'A' are both 1). Characters below $40 (space, punctuation, ENTER) end the word. The number of letters is stored at #R$7081.
D $6F3E The first letter (1-26) is then used to index the letter table at #R$6000, and IX is set to the first dictionary word starting with that letter. Execution continues into #R$6F69 to unpack it.
R $6F3E Input:HL Start of the typed word
R $6F3E Output:HL End of the typed word
R $6F3E IX Dictionary word
R $6F3E F Z set if the dictionary word starts with the right letter
N $6F69 This entry point is used by #R$6E8E to move on to the next dictionary word. It saves IX in $B607 as the current candidate and then unpacks it. Another entry point at #R$6F6D does the same without updating $B607; the tokeniser uses that one to peek at the following word.
N $6F6D Check that the dictionary word at IX starts with the same letter as the typed word. If not, return with Z reset: the search is over.
N $6F78 Unpack the dictionary word into #R$7082. The same end-of-word rule is used everywhere: bit 7 marks the last letter, except in the first two bytes. Letter codes of 0 (padding) are not copied.
N $6FA6 If this word is a synonym, skip the two bytes that point to the real word, so IX is left pointing at the next word in the dictionary.
C $6F3E Copy letters into the typed-word buffer
C $6F41 B = 0
C $6F43 A = (HL)
C $6F44 Is it "@"?
C $6F46 If A < 64, go to #R$6F50
C $6F48 Keep only the bits of $1F
C $6F4A Store A at (DE)
C $6F4B Increment DE
C $6F4C Increment HL
C $6F4D Increment B
C $6F4E Continue at #R$6F43
C $6F50 Save the length
C $6F51 Store A in the typed word length
C $6F54 Save HL
C $6F55 Look up the first letter in the letter index
C $6F58 H = 0
C $6F5A DE = Dictionary letter index (#R$6000)
C $6F5D Add HL,HL
C $6F5E Add HL,DE
C $6F5F E = (HL)
C $6F60 Increment HL
C $6F61 D = (HL)
C $6F62 IX = Dictionary letter index (#R$6000)
C $6F66 Add IX,DE
C $6F68 Restore HL
C $6F69 Store IX in the current dictionary word
C $6F6D A = (IX+0)
C $6F70 Keep only the bits of $1F
C $6F72 B = A
C $6F73 A = the contents of #R$7071
C $6F76 Compare with B
C $6F77 Return if no
C $6F78 Save HL
C $6F79 HL = #R$7082
C $6F7C BC = 0
C $6F7F A = (IX+0)
C $6F82 Keep only the bits of $1F
C $6F84 If it is zero, go to #R$6F89
C $6F86 Store A at (HL)
C $6F87 Increment HL
C $6F88 Increment B
C $6F89 Increment IX
C $6F8B Increment C
C $6F8C Test bit 7 of (IX-$01)
C $6F90 If the bit is clear, go to #R$6F7F
C $6F92 A = C
C $6F93 Compare with 2
C $6F95 If yes, go to #R$6F7F
C $6F97 Compare with 3
C $6F99 If no, go to #R$6FA1
C $6F9B Test bit 7 of (IX-$02)
C $6F9F If the bit is set, go to #R$6F7F
C $6FA1 Restore HL
C $6FA2 A = B
C $6FA3 Store A in the dictionary word length
C $6FA6 Test bit 6 of (IX-$01)
C $6FAA Return if the bit is clear
C $6FAB Increment IX
C $6FAD Increment IX
C $6FAF A = 0
C $6FB0 Done
c $6FB1 Compare the typed word with a dictionary word
D $6FB1 Compares the letters in #R$7071 (the typed word) with those in #R$7082 (the dictionary word), over the length of whichever is shorter. Returns with the Z flag set if they agree. The lengths themselves are dealt with by the caller (#R$6E8E).
R $6FB1 Output:F Z set if the letters match
C $6FB1 B = the shorter of the two lengths
C $6FB4 B = A
C $6FB5 A = the dictionary word length
C $6FB8 Compare with B
C $6FB9 If carry clear, go to #R$6FBC
C $6FBB B = A
C $6FBC Compare letter by letter
C $6FBF DE = #R$7082
C $6FC2 A = (DE)
C $6FC3 Compare with the byte at (HL)
C $6FC4 Return if no
C $6FC5 Increment DE
C $6FC6 Increment HL
C $6FC7 Loop back until B reaches 0
C $6FC9 Done
c $6FCA Clear the screen
D $6FCA Sets the border to white, clears the whole display file ($4000-$57FF) to 0 and sets all 768 attributes ($5800-$5AFF) to $38: black ink on white paper, the colours The Hobbit uses throughout. Called once at start-up (#R$6C27) before the frame and first text are drawn.
C $6FCA Save HL
C $6FCB Save DE
C $6FCC Save BC
C $6FCD White border
C $6FCF Write to the port (border colour, beeper or printer)
C $6FD1 Clear the pixels
C $6FD4 DE = $4001
C $6FD7 BC = $1800
C $6FDA Store $00 at (HL)
C $6FDC Copy BC bytes from HL to DE
C $6FDE Black on white attributes
C $6FE1 Store $38 at (HL)
C $6FE3 Copy BC bytes from HL to DE
C $6FE5 Restore BC
C $6FE6 Restore DE
C $6FE7 Restore HL
C $6FE8 Done
t $6FE9 Initial prompt and command
D $6FE9 '> LOOK' followed by ENTER. At the start of a game (#R$6C27) this is printed as though the player had typed it, and 'LOOK' plus ENTER are copied into the input buffer so that the first turn describes Bilbo's surroundings.
T $6FE9,2,1 The prompt
T $6FEB,5,1 The first command (with ENTER)
t $6FF0 Input buffer
D $6FF0 The line typed by the player, 128 characters, filled by #R$6DCD and read by #R$6E8E. It is followed by a permanent ENTER at #R$7070 so that the tokeniser always finds an end even on a completely full line.
T $6FF0,128,1
B $7070,1,1 ENTER
b $7071 Tokeniser work areas
D $7071 #LIST { #R$7071-$7080: the letters of the word being looked up (#R$6F3E), as values 1-26 } { #R$7081: the number of letters typed } { #R$7082-$7091: the letters of the dictionary word being compared with it (#R$6F69) } { #R$7092: the number of letters in the dictionary word } LIST#
B $7071,16,16 Typed word
B $7081,1,1 Its length
B $7082,16,16 Dictionary word
B $7092,1,1 Its length
b $7093 Token buffer
D $7093 The tokens for the current input line, two bytes each, high byte first, as built by the main loop (#R$6D0A) from the results of #R$6E8E and read by the parser (#R$7C4F). Space for 32 tokens. Because it is only rebuilt when a new line is typed, the '@' key (#R$6E71) can repeat the previous command by parsing it again.
B $7093,64,8
b $70D3 Registers saved by the message printer
D $70D3 #R$72D4 saves A at #R$70D3, DE at #R$70D4 and IX at #R$70D7 (with an unused byte at #R$70D6) while it runs, and restores them at the end.
B $70D3,1,1 A
B $70D4,2,2 DE
B $70D6,1,1
B $70D7,2,2 IX
c $70D9 Clear a block of memory
D $70D9 Writes B zero bytes starting at HL. A tiny utility used to clear the token buffer and other work areas.
R $70D9 Input:B Number of bytes to clear
R $70D9 HL Start address
C $70D9 A = 0
C $70DA Clear this byte
C $70DB Move on to the next one
C $70DC Repeat for however many bytes were asked for
c $70DF Get the address of an action table entry
D $70DF Returns HL = $AA3F + 8 x A, the address of the 8-byte entry for action number A in the action table (#R$AA47 is action 1; there is no action 0). The action number of the command being carried out is kept at #R$B5D8.
R $70DF Input:A Action number
R $70DF Output:HL Action table entry
C $70DF HL = the action number...
C $70E2 ...times 8, since each entry in the action table is 8 bytes...
C $70E5 ...added to the start of the action table itself
c $70EA Collect the flag nibbles of an action table entry
D $70EA Each action table entry (#R$AA47) is four word references, and the top nibble of each high byte is a set of flags rather than part of the word. This routine gathers the four flag nibbles of the entry at IX into two bytes:
D $70EA #LIST { $B60D = (top nibble of byte 3) + (top nibble of byte 1) / 16. Bit 4 of this byte means 'do not report this action' (#R$7122), bit 3 'mention the target', bit 2 'mention the instrument', bit 5 'leave out the article'. } { #R$B60E = (top nibble of byte 7) + (top nibble of byte 5) / 16. Bit 7 of this byte controls how the target and instrument are introduced. } LIST#
D $70EA The value of $B60D is also returned in A.
R $70EA Input:IX Action table entry
R $70EA Output:A Flags (also at $B60D)
C $70EA A = the third word of this action, whose top nibble carries flag bits rather than a word class
C $70ED Shift those flag bits down into the bottom four...
C $70F1 ...keeping just them
C $70F3 C = them
C $70F4 A = the fourth word's own flags, already conveniently in the top nibble
C $70F9 Combine the two nibbles into a single byte
C $70FA This becomes the action's second set of flags
C $70FD Now do exactly the same with the first and second words instead...
C $710D ...giving the action's main set of flags
c $7111 Report the action (if not inside a quotation)
D $7111 Marks the command as really happening (#R$B5EC=0, $B5EB=1) and, unless the parser is in the middle of a quotation ($B60B), prints the report of the action with #R$7122. Returns with A=0.
C $7111 The action has not yet been shown to work...
C $7115 ...but it really is being carried out now, not just tried
C $7119 Are we in the middle of a quotation (an order being given to a character)?
C $711D If not, report the action in words ("you attack thorin.")
C $7120 Clear A before returning
c $7122 Report the action ("you attack thorin with the sword.")
D $7122 Prints the sentence that describes what an actor has just done, for example 'you go east.', 'thorin attacks you.', 'gandalf opens the round green door.' or 'you attack thorin with the short strong sword.'. It is built from the entry for the current action (number in #R$B5D8) in the action table #R$AA47, whose four word slots hold the verb, a particle, a preposition and (for movement) GO.
D $7122 The flags collected by #R$70EA decide what is printed. If bit 4 of them is set the action is silent and nothing is printed at all.
D $7122 Otherwise the actor's name is printed (#R$739E: 'you', 'thorin', 'gandalf'...). If the action was only being tried and would have failed (#R$B5EC is 0) the word CANNOT is inserted, so the report reads 'you cannot open the door'. The verb follows (#R$74B1). For the ten movement actions a special case applies when the actor is a character and the move is not possible: the word SOMEWHERE is printed instead of the direction. Then, as the flags require, the particle, the target object (#R$73AB, with its article) and the preposition plus instrument (#R$73BE) are added. The sentence ends with a full stop and a new line.
D $7122 The printing is done with #R$70D6 set to 1, which makes #R$7436 use 'the' rather than 'a' for articles. $B5F2 is set when the action is only being tried, which sends the text to the lower window instead (see #R$7580).
C $7122 A = 1
C $7124 Store A in the "definite article" flag
C $7127 A = 0
C $7128 Store A in the "print an article" flag
C $712B Save IY
C $712D Save BC
C $712E A = the "it would work" flag
C $7131 B = A
C $7132 Is A zero?
C $7133 A = 1
C $7135 If it is zero, go to #R$7138
C $7137 A = 0
C $7138 Store A in the lower-window flag
C $713B Save IX
C $713D Save HL
C $713E Save DE
C $713F IX = the action table entry
C $7142 Call: Get the address of an action table entry (#R$70DF)
C $7145 Save HL
C $7146 Restore IX
C $7148 Only start a new line for the player when the action really happens
C $7149 Compare with B
C $714A If yes, go to #R$7153
C $714C A = the actor
C $714F Is A zero?
C $7150 If zero/equal: print a new line
C $7153 Get the flags; bit 4 set means say nothing
C $7156 Test bit 4 of A
C $7158 C = A
C $7159 If the bit is set, go to #R$71C0
C $715C Print the actor
C $715F "cannot" if the action would not work
C $7162 A = 0
C $7163 Compare with B
C $7164 If zero/equal: call: Print a dictionary word (#R$74B8)
C $7167 Save HL
C $7168 DE = 6
C $716B Add HL,DE
C $716C Print the verb
C $716F A character that cannot move goes "somewhere"
C $7172 Restore HL
C $7173 If the routine returned with carry reset, go to #R$7186
C $7175 A = the action
C $7178 Is it action 11 (STRIKE WITH)?
C $717A If A >= 11, go to #R$7186
C $717C DE = $0AEA
C $717F Increment HL
C $7180 Increment HL
C $7181 Call: Print a dictionary word (#R$74B8)
C $7184 Continue at #R$7189
C $7186 Call: Print a word from a list (#R$74B1)
C $7189 Target wanted?
C $718B If the bit is clear, go to #R$719D
C $718D Test bit 5 of C
C $718F If not zero/not equal: call: Print a word from a list (#R$74B1)
C $7192 A = the action's second flags
C $7195 Test bit 7 of A
C $7197 If not zero/not equal: call: Print a word from a list (#R$74B1)
C $719A Call: #R$73AB
C $719D Instrument wanted?
C $71A0 Is it nobody ($FF)?
C $71A2 If yes, go to #R$71B8
C $71A4 Test bit 2 of C
C $71A6 If the bit is clear, go to #R$71B8
C $71A8 Test bit 5 of C
C $71AA If zero/equal: call: Print a word from a list (#R$74B1)
C $71AD A = the action's second flags
C $71B0 Test bit 7 of A
C $71B2 If zero/equal: call: Print a word from a list (#R$74B1)
C $71B5 Call: Print the instrument (#R$73BE)
C $71B8 End the sentence
C $71BA Print the character in A
C $71BD Print a new line
C $71C0 A = 0
C $71C1 Store A in the "definite article" flag
C $71C4 Restore DE
C $71C5 Restore HL
C $71C6 Restore IX
C $71C8 Restore BC
C $71C9 Restore IY
C $71CB Done
c $71CC Get the address of a room's word list
D $71CC Returns HL pointing at the name words of room A (the record address from #R$9B0C plus 2). IX is preserved. Used when a message needs to name a room rather than an object.
R $71CC Input:A Room number
R $71CC Output:HL Room name words
C $71CC Save the caller's IX
C $71CE IX = room A's own record
C $71D1 HL = that same address...
C $71D4 ...moved on 2 bytes, to the room's own name words
C $71D6 Restore the caller's IX
c $71D9 Get the address of an object's word list
D $71D9 Returns HL pointing at the four word slots of object A (its record address from #R$9B25 plus 8: the noun and adjectives). DE and IX are preserved.
R $71D9 Input:A Object number
R $71D9 Output:HL Object's words
C $71D9 Save the caller's DE
C $71DA Save the caller's IX
C $71DC IX = object A's own record
C $71DF HL = that same address...
C $71E2 ...moved on 8 bytes, to the object's own word slots
C $71E6 Restore the caller's IX
C $71E8 Restore the caller's DE
c $71EA Match a command against an action table entry
D $71EA Compares the verb, particle and preposition in an action table entry (at HL) with those of the parsed command (at IY) using #R$7225. The verb must match. The particle and preposition may match in the same order, or crossed over, so that for example both 'take off the ring' and 'take the ring off' find the TAKE OFF action.
D $71EA Returns with Z set for a match; A is 0 if the words matched in order and 1 if they were crossed over, and $B5D0 is set to 1 once the verb alone has matched (so the caller can tell 'wrong verb' from 'right verb, wrong words').
R $71EA Input:HL Action table entry
R $71EA IY Parsed command
R $71EA Output:F Z set if they match
R $71EA A 0 = in order, 1 = crossed over
C $71EA Save the caller's DE, HL and IY
C $71EE Do the verbs match? (this also moves both pointers on to their next word)
C $71F1 No: there is no match at all - give up straight away
C $71F3 Record that at least the verb has matched...
C $71F5 ...so a later failure can be blamed on "the wrong words", not "an unknown verb"
C $71F8 Do the particles match, in the same order?
C $71FB No: they might just be the wrong way round - go and check that below
C $71FD They do: now do the prepositions match too, in the same order?
C $7200 If so, this is a plain, in-order match
C $7202 ...so finish here, with A=0
C $7204 Not a straightforward match: restore the command's own pointer...
C $7206 ...and the action-entry's pointer, saved right at the very start...
C $7207 ...pushing them straight back so they can be recovered again below
C $720A Move the command's pointer on 4 bytes, to its own preposition word...
C $720F ...and the action-entry's pointer on 2, to its particle word instead
C $7211 Does the entry's PARTICLE match the command's own PREPOSITION?
C $7214 No: there is no match, in either order
C $7216 Move the command's pointer back 4, to its own particle word...
C $721B ...and does THAT match the entry's PREPOSITION?
C $721E Yes: it is a match, but with particle and preposition crossed over
C $7220 Restore the caller's IY, HL and DE
c $7225 Compare two word references
D $7225 Compares the word reference at HL with the one at IY (both stored low byte first) and then moves both pointers on by two bytes. Only the low 12 bits count (the offset from #R$6000), so the class or flag bits in the top nibble are ignored.
D $7225 Returns with the Z flag set if the words are the same, or if the reference at HL is zero (an empty slot, which ends a list of words). Used five times by the routine at #R$71D9 when matching the words the player typed against the four word slots of an object record (#R$C00B).
R $7225 Input:HL Word reference
R $7225 IY Word reference
R $7225 Output:F Z set if they match (or HL points to 0)
C $7225 Save HL
C $7226 Is the word at HL empty?
C $7227 Increment HL
C $7228 Combine with (HL)
C $7229 If it is zero, go to #R$7238
C $722B Compare the top four bits of the offset...
C $722E Flip the bits in (HL)
C $722F Keep only the bits of $0F
C $7231 If it is not zero, go to #R$7238
C $7233 ...and the bottom eight
C $7234 A = (HL)
C $7235 Compare with the byte at (IY+$00)
C $7238 Move both pointers on
C $7239 Increment HL
C $723A Increment HL
C $723B Increment IY
C $723D Increment IY
C $723F Done
c $7240 Wait for a key, typing WAIT if the player is idle
D $7240 Polls the keyboard (#R$7B86) until a key is pressed, counting the polls down from the value at $B604. Each poll includes the 1000-iteration delay in #R$7B6B, so it takes something like 8 ms, and the starting value of 3000 set by #R$6DCD gives the player roughly 20-25 seconds (my estimate from the instruction timings).
D $7240 When a key is pressed, 500 is added to what is left of the count, up to a maximum of 3000, so steady typing keeps the time topped up.
D $7240 If the count runs out, the game takes over: whatever has been typed is erased (#R$6E82), the four characters 'WAIT' from #R$7288 are put into the input buffer and printed, B is set to $7C (four characters used), the count is reset to 3000, and an ENTER is returned as if the player had pressed it. The line editor then finishes the line and the WAIT command is carried out. This is how time passes in The Hobbit even when the player does nothing, and why the other characters can go off and do things - or attack you - while you are thinking.
R $7240 Input:HL Current position in the input buffer
R $7240 Output:A Key code
C $7240 Save HL
C $7241 HL = polls left before WAIT
C $7244 Is a key being pressed?
C $7247 Is A zero?
C $7248 If it is not zero, go to #R$726A
C $724A No: count down
C $724B A = H
C $724C Combine with L
C $724D If it is not zero, go to #R$7244
C $724F Restore HL
C $7250 Save HL
C $7251 Time up: rub out what has been typed
C $7254 Put WAIT into the buffer and print it
C $7257 B = 4
C $7259 A = (DE)
C $725A Store A at (HL)
C $725B Increment HL
C $725C Increment DE
C $725D Print the character in A
C $7260 Loop back until B reaches 0
C $7262 Swap HL with the value on top of the stack
C $7263 Four characters used; return ENTER
C $7265 A = 13
C $7267 This makes the addition below overflow, so the count is reset to 3000
C $726A Save AF
C $726B A = 0
C $726C Add 500 to the polls left...
C $726F Add HL,DE with carry
C $7271 ...but no more than 3000
C $7274 If carry is set, go to #R$727B
C $7276 Call: Compare HL with DE (#R$7282)
C $7279 If the routine returned with carry set, go to #R$727C
C $727B Swap DE and HL
C $727C Save the new count
C $727F Restore AF
C $7280 Restore HL
C $7281 Done
c $7282 Compare HL with DE
D $7282 A 16-bit comparison: compares H with D and, if they are equal, L with E. Returns with Z set if HL=DE, and the carry flag set if HL is less than DE. A is corrupted.
R $7282 Input:HL First number
R $7282 DE Second number
R $7282 Output:F Z set if equal, carry set if HL<DE
C $7282 A = HL's high byte
C $7283 Subtract DE's high byte
C $7284 Different: HL and DE are not equal (the carry flag also shows which is bigger)
C $7285 Same high byte: now compare the low bytes
t $7288 The WAIT command
D $7288 The four letters typed automatically by #R$7240 when the player is idle.
T $7288,4,1
w $728C Message interpreter control-code jump table
D $728C Addresses of the handlers for message control codes $00 to $16, used by #R$72D4:
D $728C #TABLE(default) { =h Code | =h Handler | =h Meaning } { $00 | #R$735E | print the object whose address the caller pushed on the stack } { $01 | #R$736D | print the word the caller pushed on the stack } { $02 | #R$7375 | jump forwards or backwards by the signed byte that follows } { $03 | #R$7384 | print the noun of the instrument in the current command ($B5ED) } { $04 | #R$738B | print the pushed word with an article (a/an/the/some) } { $05, $0A, $0F, $12 | #R$7382 | do nothing } { $06 | #R$739A | print the actor's name } { $07 | #R$73A6 | print the target with its article } { $08 | #R$73B4 | print a backspace (to join a word to the previous one) } { $09 | #R$73B9 | print the instrument with its article } { $0B | #R$73D7 | call a sub-message at a relative address } { $0C | #R$73F0 | print HIS or YOUR for the actor } { $0D | #R$72BA | new line } { $0E | #R$73FE | print HIS or YOUR for the target } { $10 | #R$7403 | print the actor's name and IS or ARE } { $11 | #R$741C | the same for the target } { $13 | #R$7424 | the same for an object pushed on the stack } { $14 | #R$7337 | end the message with a new line } { $15 | #R$733B | end the message with a full stop and a new line } { $16 | #R$7352 | end the message } TABLE#
D $728C The IS/ARE and HIS/YOUR codes are what let one message serve both the player and the characters: 'you are dead' and 'thorin is dead' are the same message.
W $728C,46 Handlers for codes $00-$16
c $72BA Print a character from a message
D $72BA Used by the message interpreter for literal characters and control code $0D. The character is printed (#R$7580) and, if it was a carriage return, the 'last punctuation' flag at $B5F5 is cleared.
C $72BA Print the character
C $72BD Was it a new line?
C $72BF No: nothing more to do
C $72C0 Yes: a fresh line has begun, so clear the "last punctuation" flag
c $72C5 Print "I cannot do that."
D $72C5 Prints the message at #R$AEB2.
C $72C5 "I cannot do that."
C $72C8 Print it
c $72CA Print a message, suppressing actions inside a quotation
D $72CA If the parser is inside a quotation ($B60B set), the 'really do it' flag $B5EB is cleared first, so that commands being passed to another character are only tried, not carried out. Execution continues into #R$72D4.
C $72CA Are we in the middle of a quotation (an order being given to a character)?
C $72CE No: print the message as normal
C $72D0 Yes: make sure this only counts as a trial, not something that really happens to the world...
C $72D1 ...then fall into the ordinary message printer
c $72D4 Print a message (message bytecode interpreter)
D $72D4 Almost everything the game says is printed by this routine, which interprets a compact message 'bytecode' starting at the address in HL. Messages are not stored as ASCII; they are sequences of dictionary references and control codes, which is how The Hobbit fits so much text into 48K.
D $72D4 The entry at #R$72D4 saves DE, IX and A (restored at the end, #R$7352) so callers do not lose them. If the command is only being tried ($B5EB is 0) the flag #R$B5EC is cleared.
D $72D4 The loop at #R$72EB fetches a byte and decides what it is:
D $72D4 #LIST { $80-$FF: the first byte of a two-byte dictionary reference, high byte first. The low nibble of the first byte and all of the second give the word's offset from #R$6000; the three remaining flag bits (bits 4-6) choose an ending. Flag values 2, 3 and 6 mean 'this is the last word of the message': 2 just stops, 3 adds a full stop and a new line, 6 adds a new line (#R$733F). Other values are passed on to #R$74B8 as printing flags (for example 'add an S'). } { $60-$7F: one of the 32 most common words, looked up in #R$AC31 by #R$748A. } { $20-$5F: a literal character, printed by #R$72BA. } { $00-$1F: a control code, dispatched through the table at #R$728C. } LIST#
D $72D4 Control codes below $14 are called as subroutines. A handler that returns with Z set lets the interpreter move on to the next byte; one that returns with Z reset asks it to print the dictionary word now in DE (so a handler can choose a word such as HIS or YOUR and have it printed). Codes $14 and above end the message.
D $72D4 Several control codes take an extra parameter from the stack: the caller pushes an object address or a word before calling the interpreter, and the handler removes it (see #R$735E).
D $72D4 The same interpreter runs the little scripts attached to rooms and objects, which is why the room and object tables contain what look like fragments of messages.
R $72D4 Input:HL Address of the message bytecode
C $72D4 Store DE at #R$70D4
C $72D8 Store IX at #R$70D7
C $72DC Store A at #R$70D3
C $72DF A = the "really do it" flag
C $72E2 Is A zero?
C $72E3 If it is not zero, go to #R$72E8
C $72E5 Store A in the "it would work" flag
C $72E8 Save HL
C $72E9 Restore IX
C $72EB A = (IX+0)
C $72EE Bit 7 set: a dictionary word reference
C $72F0 If the bit is clear, go to #R$730F
C $72F2 Keep only the bits of $7F
C $72F4 D = A
C $72F5 E = (IX+1)
C $72F8 Increment IX
C $72FA Flag values 3, 2 and 6 end the message
C $72FC Is it "0"?
C $72FE If yes, go to Print the last word of a message and finish (#R$733F)
C $7300 Is it " "?
C $7302 If yes, go to Print the last word of a message and finish (#R$733F)
C $7304 Is it "`"?
C $7306 If yes, go to Print the last word of a message and finish (#R$733F)
C $7308 Print an ordinary dictionary word
C $730B Increment IX
C $730D Continue at #R$72EB
C $730F Otherwise: control code, abbreviation or literal character
C $7311 If A < 32, go to #R$731D
C $7313 Is it "`"?
C $7315 $60-$7F: one-byte abbreviation
C $7318 Call: Print a character from a message (#R$72BA)
C $731B Continue at #R$730B
C $731D Save DE
C $731E E = A
C $731F D = 0
C $7321 $00-$1F: index into the control-code jump table
C $7324 Add HL,DE
C $7325 Add HL,DE
C $7326 E = (HL)
C $7327 Increment HL
C $7328 D = (HL)
C $7329 Swap DE and HL
C $732A Restore DE
C $732B Codes $14 and above end the message
C $732D If A >= 20, go to #R$7336
C $732F Call the handler; Z set means carry on
C $7332 If the routine returned with Z set, go to #R$730B
C $7334 Z reset: print the word in DE, then carry on
C $7336 Jump to the address in HL
c $7337 Message code $14: end with a new line
D $7337 Sets D to $60 (the 'new line' ending) and joins #R$733F after the word has been printed.
C $7337 Flags meaning "add a new line after this word"
C $7339 Join the shared ending below
c $733B Message code $15: end with a full stop
D $733B Sets D to $30 (the 'full stop' ending) and joins #R$733F.
C $733B Flags meaning "add a full stop, then a new line"
C $733D Join the shared ending below
c $733F Print the last word of a message and finish
D $733F Prints the word in DE (#R$74B8) and then ends the message according to the flags in D: bit 6 set gives a new line; otherwise bit 4 set gives a full stop and a new line; if neither, nothing is added. Finally the registers saved on entry to #R$72D4 (A, DE and IX) are restored and the interpreter returns to its caller.
R $733F Input:DE Word (flags in the top nibble of D)
C $733F Print the word left over in DE
C $7342 "."
C $7344 Does the message want a new line here?
C $7346 If so, skip the full stop
C $7348 Does it want a full stop instead?
C $734A If so, print it
C $734D (Tested again, this time to decide whether a new line follows the full stop)
C $734F Print the new line
C $7352 Restore the DE the caller of this whole message had, before it began...
C $7356 ...and its IX...
C $735A ...and its A, all saved back at the very start (#R$72D4)
C $735D The message is finished
c $735E Message code $00: print an object passed on the stack
D $735E The caller of #R$72D4 pushed the address of an object's word list before calling. This handler reaches past the interpreter's own return addresses (POP DE / POP HL / EX (SP),HL / PUSH DE), removes that parameter, and prints the object's name (#R$742B) unless the address is 0. The 'use an article' flag #R$B5F4 is cleared first, so no article is printed. Returns with Z set.
C $735E No article wanted before this name
C $7362 Reach past the interpreter's own two return addresses...
C $7364 ...to find the object's own word-list address the caller pushed, lifting it out...
C $7365 ...and putting the two return addresses back exactly as they were
C $7366 Is that address 0 (meaning "nothing to name")?
C $7368 If not, print the object's name
C $736B Tell the interpreter to just carry on: nothing further needs printing
c $736D Message code $01: print a word passed on the stack
D $736D Removes a word reference that the caller pushed on the stack (in the same way as #R$735E) and returns it in DE with Z reset, which makes the interpreter print it.
C $736D Reach past the interpreter's own two return addresses...
C $736F ...to find the word the caller pushed, lifting it out...
C $7370 ...and putting the two return addresses back
C $7371 DE = that word
C $7372 Make sure A is not zero...
C $7374 ...so the interpreter is told to print the word now in DE
c $7375 Message code $02: relative jump
D $7375 Moves the message pointer IX by the signed byte that follows the code, so a message can skip over part of itself or loop. Returns with Z set. The entry point at #R$7382 (XOR A / RET) is used by the codes that do nothing.
C $7375 E = the signed jump distance that follows this code
C $737A Is it negative?
C $737E If so, sign-extend it into D
C $7380 Move the message pointer by that many bytes
C $7382 Tell the interpreter to just carry on from the new position
c $7384 Message code $03: print the instrument's noun
D $7384 Returns the word stored at $B5ED (the noun the player used for the instrument, e.g. SWORD in 'hit thorin with the sword') in DE with Z reset, so the interpreter prints it.
C $7384 DE = the noun the player used for the instrument (e.g. SWORD)
C $7388 Make A non-zero...
C $738A ...so the interpreter prints it
c $738B Message code $04: print a word with an article
D $738B Removes a word from the stack (as #R$736D) and prints it with an article, by setting #R$B5F4 and calling #R$746F. Returns with Z set.
C $738B Reach past the interpreter's own two return addresses...
C $738D ...to find the word the caller pushed, lifting it out...
C $738E ...and putting the two return addresses back
C $738F DE = that word
C $7390 This time an article is wanted first...
C $7395 ...so print it that way
C $7398 Already printed: tell the interpreter nothing more is needed
c $739A Message code $06: print the actor's name
D $739A Prints the name of the current actor (#R$B5DB) with no article, via #R$747F: 'you' for Bilbo, 'thorin', 'gandalf' and so on. The entry point at #R$739E is used by #R$7122 without clearing the article flag.
C $739A No article for a name
C $739E A = the current actor
C $73A1 Print their name ("you", "thorin"...)
C $73A4 Already printed: nothing more needed
c $73A6 Message code $07: print the target
D $73A6 Prints the target of the command (object $B5D9) with its article. If $B5EF is set, the target is a room rather than an object, and the room's name is used instead (#R$71CC rather than #R$71D9). The entry at #R$73AB is used by #R$7122. Code $08 (#R$73B4) prints a backspace, and code $09 (#R$73B9) sets the article flag and continues into #R$73BE.
C $73A6 An article is wanted
C $73AB Is the target actually a room, rather than an object?
C $73AF A = the target's own number, either way
C $73B2 Join the shared printing code below
c $73B4 Message codes $08 and $09
D $73B4 Code $08 (#R$73B4) prints a backspace, so that a word can be joined to the one before it (for example to add a suffix). Code $09 (#R$73B9) sets the 'print an article' flag and prints the instrument with its article, continuing into #R$73BE.
C $73B4 CODE $08: print a backspace, joining this word onto the one before it
C $73B7 Nothing further to print
C $73B9 CODE $09: an article is wanted...
C $73BB ...then fall into the shared code below, which prints the instrument
c $73BE Print the instrument
D $73BE Prints the instrument (the 'with' object, number in #R$B5DA) with its article; if $B5F0 is set the instrument is a room. Shares its tail with #R$73A6: the words are found with #R$71CC or #R$71D9 and printed with #R$742B.
C $73BE Is the instrument actually a room, rather than an object?
C $73C2 A = the instrument's own number, either way
C $73C5 Not a room: skip ahead
C $73C7 Save HL
C $73C8 HL = that room's own name words
C $73CD Save HL
C $73CE HL = that object's own words
C $73D1 Print them
C $73D4 Restore HL
C $73D5 Already printed
c $73D7 Message code $0B: call a sub-message
D $73D7 Interprets the message at a relative address (the signed byte after the code, counted from that byte) as a subroutine, by calling #R$72E8 recursively, and then continues with the current message. This lets common phrases be shared between messages.
C $73D7 Step past this code, to its jump-distance byte
C $73D9 HL = that same address...
C $73DC ...save it, ready to measure the jump from
C $73DD E = the signed jump distance
C $73E2 Negative?
C $73E6 If so, sign-extend it into D
C $73E8 HL = the address of the sub-message
C $73E9 Print it, as a complete message in its own right
C $73EC Restore IX to just after the jump-distance byte, so the outer message carries on from there
C $73EE Already printed
c $73F0 Message code $0C: HIS or YOUR (actor)
D $73F0 Returns the word YOUR if the actor is Bilbo (object 0) and HIS for anyone else, with Z reset so that the interpreter prints it. The entry at #R$73F3 is shared with #R$73FE.
C $73F0 A = the current actor
C $73F3 DE = HIS
C $73F6 Is the actor Bilbo (0)?
C $73F7 No: HIS is right, and Z is already reset, so the interpreter prints it
C $73F8 Yes: DE = YOUR instead
C $73FB Make A non-zero...
C $73FD ...so YOUR gets printed
c $73FE Message code $0E: HIS or YOUR (target)
D $73FE As #R$73F0, but for the target of the command ($B5D9). This is how 'his defense is too strong' becomes 'your defense is too strong' when Thorin attacks Bilbo.
C $73FE A = the target, rather than the actor
C $7401 Join the shared HIS/YOUR code above
c $7403 Message code $10: "you are" or "thorin is"
D $7403 Prints the actor's name (#R$747F) and then returns ARE if the actor is Bilbo and IS otherwise, for the interpreter to print. Code $11 (#R$741C) does the same for the target, and code $13 (#R$7424) for an object pushed on the stack.
C $7403 A = whose name to print - the actor here, or, via the entry points below, the target or a pushed object
C $7406 Keep it safely out of the way while the name is printed
C $7407 No article for a name
C $740B A = the object again
C $740C Save it once more
C $740D Print the name
C $7410 A = the object once more
C $7411 Is it Bilbo (0)?
C $7412 DE = ARE
C $7415 Not Bilbo: ARE is right, and Z is already reset, so it gets printed
C $7416 Bilbo: DE = IS instead
C $7419 Make A non-zero...
C $741B ...so IS gets printed
c $741C Message code $11: target's name and IS/ARE
D $741C See #R$7403. The target is object $B5D9, and it gets an article.
C $741C A = the target, rather than the actor
C $741F Keep it safe while the name is printed
C $7420 (marks this as not the plain "actor" entry point, though nothing else reads it)
C $7422 Join the shared code above
c $7424 Message code $13: pushed object's name and IS/ARE
D $7424 Removes an object number from the stack and continues as #R$741C.
C $7424 Reach past the interpreter's own two return addresses...
C $7426 ...to find the object number the caller pushed
C $7427 Put the two return addresses back
C $7429 Join the target version above, using this object instead
c $742B Print an object's name from its word list
D $742B Prints the name of the thing whose word list is at HL (adjectives followed by the noun) by calling #R$9E1F with IY pointing at the list.
R $742B Input:HL Word list
C $742B Save the caller's IY
C $742D IY = the word-list address given in HL
C $7430 Print the noun with its adjectives
C $7433 Restore the caller's IY
c $7436 Print the article for a word
D $7436 Decides on and prints the article that goes in front of the word in DE, according to the flags in the top of D.
D $7436 Names (bit 7 of D set) get no article. They do set the 'capitalise' flag $B5F5 so the name starts with a capital letter; the one exception is YOU, which is left alone.
D $7436 Other words use bits 4-6 of D as an index (0-3) into a table of articles: #R$AC21 (THE, A, AN, SOME) normally, or #R$AC29 (THE, THE, THE, SOME) when a definite article is wanted ($B5F2 or #R$70D6 set). So each noun in the dictionary references carries its own article: 'a sword', 'an elvish sword', 'some wine'.
R $7436 Input:DE Word reference
C $7436 A name (bit 7 of D)?
C $7438 No: an ordinary noun
C $743A Is it YOU ($07AC)?
C $7445 YOU gets neither an article nor a capital
C $7446 Other names get a capital letter...
C $7448 ...and no article
C $744C HL = THE, A, AN, SOME
C $744F Is a definite article wanted?
C $7457 No
C $7459 Yes: HL = THE, THE, THE, SOME
C $745C The word's flag bits 4-6 choose one of the four
C $7467 DE = the article
C $746A Print it
c $746F Print a word, with an article if required
D $746F If the article flag #R$B5F4 is set, #R$7436 prints the article first. The flag bits in D are then cleared and the word is printed by #R$74B8.
R $746F Input:DE Word reference
C $746F Save DE, the word to print
C $7470 Was an article asked for?
C $7474 If so, print it first
C $7477 Restore DE
C $7478 Strip the flag bits out of D, keeping just the word's own offset...
C $747C ...then print the word itself
c $747F Print the name of object A
D $747F Prints the name of object A. Object $FF (nobody) is printed as SOMEONE, which is what you see when an unseen character does something: 'someone opens the door'. Otherwise it continues at #R$73CD in #R$73BE.
R $747F Input:A Object number
C $747F Is there no object at all ($FF, for an attacker Bilbo cannot see)?
C $7481 If there is a real object, print its name as usual
C $7484 No object: SOMEONE
C $7487 Print that instead
c $748A Print an abbreviated word
D $748A Message bytes $60-$7F stand for the 32 most common words. The byte minus $60 indexes the table at #R$AC31 to get a dictionary reference (the high byte has $50 added so it lands in the right flag range), and then the word is printed exactly as if it had been written out in full, by jumping back into #R$72D4.
C $748A A = which of the 32 common words this is (the code minus $60)
C $748F HL = the table of abbreviated words
C $7492 HL = this word's own entry (2 bytes each)...
C $7494 DE = the word reference, low byte...
C $7496 ...then the high byte, with $50 added, to bring it into range...
C $749A Print it exactly as an ordinary word reference
b $749D Word buffer
D $749D Where #R$74B8 assembles the letters of a word, plus any verb ending, before printing it. Up to 20 characters.
B $749D,20,8
c $74B1 Print a word from a list
D $74B1 Fetches the word reference at HL (low byte first), moves HL on by two, strips the flag bits and falls into #R$74B8 to print it. Used to print the words of action table entries and object names one at a time.
R $74B1 Input:HL Word reference
R $74B1 Output:HL Next word
C $74B1 DE = the next word reference in the list, low byte...
C $74B3 ...then the high byte...
C $74B5 ...with its flag bits stripped away
c $74B8 Print a dictionary word
D $74B8 Prints one word from the dictionary, with the right verb ending and with word wrap. On entry DE holds the word reference: the low nibble of D and all of E are the offset from #R$6000, and the high nibble of D holds flags. A reference of zero prints nothing.
D $74B8 The letters are unpacked into a buffer at #R$749D (five-bit letter codes plus $60 give lower-case ASCII), using the usual end-of-word rule (bit 7, but never in the first two bytes).
D $74B8 VERB ENDINGS. The flag nibble decides whether the verb is to agree with a third-person subject: $50 never, $40 always, $10 if the target is not Bilbo, and anything else if the actor is not Bilbo. So one message can say 'you attack thorin' or 'thorin attacks you'. If an ending is needed and the word allows one (bit 7 of its second byte), the top three bits of its third byte choose an ending from the table at #R$B60F: S, ES, IES, a backspace followed by IES (to turn 'carry' into 'carries'), D, or ING.
D $74B8 WORD WRAP. The length of the word, with its ending, is compared with the room left on the line (at #R$75A8 in the lower window or #R$768E in the story window). If it will not fit, a new line is started first, keeping the capital-letter flag. A space is printed before the word unless it starts a line.
D $74B8 Words with flag nibble $70 set the capital-letter flag afterwards, so that the next word starts a sentence.
R $74B8 Input:DE Word reference (flags in the high nibble of D)
C $74B8 Is the word reference zero?
C $74BC Yes: nothing to print
C $74C0 C = the flags
C $74C1 DE = the offset...
C $74C5 ...plus #R$6000: HL = the word in the dictionary
C $74C9 DE = the letter buffer
C $74CD B counts the letters
C $74CF Next letter code
C $74D2 0 (padding): the word has ended
C $74D4 Count it
C $74D5 Turn it into a lower-case letter
C $74D7 Put it in the buffer
C $74D9 Was it the last letter (bit 7)?
C $74DC No: next letter
C $74DE Bit 7 in the first two bytes does not count...
C $74E3 ...and for a two-letter word...
C $74E7 ...look back at the first byte
C $74F0 HL = the start of the word again
C $74F1 What does the flag nibble say about verb endings?
C $74F4 $50: never add an ending
C $74F8 $40: always add one
C $74FC $10: add one if the target is not Bilbo
C $7503 Otherwise: add one if the actor is not Bilbo
C $7506 Bilbo ("you")?
C $7507 Yes: no ending
C $7509 Does the word take an ending (bit 7 of its second byte)?
C $750C No
C $750E The top three bits of its third byte...
C $7512 ...times 4...
C $7518 ...index the table of endings
C $751C Up to four characters
C $751F A 0 ends it
C $7523 Add the character to the word
C $7527 B = the length of the word
C $752F Lower window or story window?
C $7536 Story window: is this the start of a line?
C $753A If not, print a space first
C $7540 A = the room left on the line (lower window)...
C $7545 ...or in the story window
C $754B Will the word fit?
C $754C Yes
C $754E No: start a new line, keeping the capital-letter flag
C $7553 Does the word end a sentence (flag nibble $70)?
C $755D Yes: the next word gets a capital
C $755E Print the letters
c $756B Is output enabled?
D $756B Returns with Z set if nothing should be printed at the moment: output happens only if both $B5EB (the command is really being carried out, not just tried) and $B5F3 (the event can be seen by the player) are non-zero. A is preserved.
R $756B Output:F Z set if printing is switched off
C $756B Save HL
C $756C Keep the caller's A safe in L for a moment
C $756D Is this action really happening (not just being tried)?
C $7571 Can Bilbo actually see or hear it happen?
C $7574 Both must be true for anything to be printed
C $7575 Restore the caller's own A
C $7576 Restore HL
C $7577 Z set means printing is switched off
c $7578 Print a newline
D $7578 Prints a carriage return ($0D) via #R$7580, preserving A.
C $7578 Save the caller's AF
C $7579 A = carriage return
C $757B Print it
C $757E Restore the caller's AF
c $7580 Print a character
D $7580 The main character output routine. It does nothing if #R$756B says printing is switched off.
D $7580 If $B5F2 is set, the character goes to the lower (input) window via #R$75AD, which is how the player's own typing, and replies such as 'I don't know the word', appear down there. Otherwise it goes to the upper story window via #R$7694.
D $7580 Then comes one of the game's jokes. If the flag at $B5F1 is set, every S (or s) printed in the story window is followed by an H. That flag is set when Bilbo drinks the wine (the wine's object record calls #R$A9ED), and cleared five turns later by timer 7 (#R$A9FF). So for a while after drinking, the game slurs: 'you drink shome wine. gandalf goesh easht.'
R $7580 Input:A Character to print
C $7580 Printing switched off?
C $7583 Return if the routine returned with Z set
C $7584 Save AF
C $7585 Input window or story window?
C $7588 Is A zero?
C $7589 If it is not zero, go to Print a character in the input window (entry from #R$7580) (#R$75AC)
C $758B Restore AF
C $758C Call: Put a character on the screen (#R$7694)
C $758F Save AF
C $7590 Has Bilbo been drinking?
C $7593 Is A zero?
C $7594 If it is not zero, go to #R$7598
C $7596 Restore AF
C $7597 Done
C $7598 Restore AF
C $7599 If so, follow every S with an H
C $759B If yes, go to #R$75A0
C $759D Is it "s"?
C $759F Return if no
C $75A0 Save AF
C $75A1 A = 72
C $75A3 Call: Put a character on the screen (#R$7694)
C $75A6 Restore AF
C $75A7 Done
s $75A8
c $75AC Print a character in the input window (entry from #R$7580)
D $75AC Discards the copy of AF that #R$7580 pushed and continues into #R$75AD.
C $75AC Throw away the copy of AF that #R$7580 pushed, then fall into #R$75AD below
c $75AD Print a character in the lower (input) window
D $75AD Prints a character in the four-line window at the bottom of the screen, where the player's typing and the game's immediate replies appear. Unlike the story window, this one uses the Spectrum ROM's 8x8 font (#R$766D) at 32 characters per line, and letters are always shown in upper case.
D $75AD The print position is kept at $75A9 and the number of columns left at #R$75A8. After each character, the cursor character (from $75AB, a '+') is drawn in the next position, so the player can see where the next key will appear.
D $75AD ENTER blanks the cursor and scrolls the window up a line (#R$7600). A backspace ($08) rubs out the cursor, moves back one column and draws the cursor there; backspacing past the start of a line scrolls the window down again (#R$763D). Reaching the end of a line also scrolls the window.
C $75AD Save HL and AF
C $75AF HL = where the next character goes
C $75B2 Is it ENTER?
C $75B6 Yes: rub out the cursor with a space...
C $75BB ...then go straight to starting a new line
C $75BD Is it a backspace?
C $75C1 Otherwise, is it a lower-case letter?
C $75C9 If so, make it upper case: this window always shows capitals
C $75CB Draw the character
C $75CE One less column of room on this line
C $75D2 Room left: just update the cursor position below
C $75D4 Line full: move to the start of the next one...
C $75D6 ...scrolling the window up
C $75D9 Full width of room again, on the fresh line
C $75DB Save the columns left
C $75DE A = the cursor character ('+')
C $75E1 Remember where it goes
C $75E4 Draw it, so the player can see where the next key will land
C $75E7 Restore AF
C $75E8 Restore HL
C $75EA BACKSPACE: rub out the cursor with a space
C $75EF Step back one character position
C $75F1 Was there anything on this line left to delete?
C $75F7 Something there: just move the cursor back
C $75F9 Nothing left on this line: move up to the end of the previous one...
C $75FB ...scrolling the window back down
c $7600 Scroll the input window up
D $7600 Scrolls the lower window (the four character rows starting at $5060, in the bottom third of the screen) up by one row, a pixel line at a time with LDIR, and then clears the bottom row at $50E0 by printing 32 spaces with #R$766D. All registers are preserved.
C $7600 Save the registers this uses
C $7604 HL = the second character row of the input window...
C $7607 ...DE = the first, where it is moving to
C $760A Four character rows to shift up
C $760E Save the row addresses for a moment
C $7610 Eight pixel lines make up one character row
C $7612 Save this pixel line's addresses
C $7615 32 bytes make up one pixel line across the screen
C $7617 Copy it up
C $7619 Restore the counters
C $761C Move down to the next pixel line (the screen's odd layout means +$100 here, not +32)
C $761E One fewer pixel line to do
C $7621 Restore the row addresses
C $7623 Move both addresses on to the next character row
C $7629 One fewer character row to do
C $762C The bottom row is now empty: clear it with 32 spaces
C $7638 Restore the saved registers
c $763D Scroll the input window down
D $763D The reverse of #R$7600: moves the lower window's rows down by one character row, working from the bottom. Used when a backspace goes back past the start of a line of typing (#R$75AD).
C $763D Save the registers this uses
C $7641 HL = the third character row of the input window...
C $7644 ...DE = the fourth, where it is moving to
C $7647 Five pixel-line moves are needed to shift everything down one row
C $7649 Save the row addresses
C $764B Eight pixel lines per character row
C $764D Save this pixel line's addresses
C $7650 32 bytes per pixel line
C $7653 Copy it down
C $7655 Restore the counters
C $7658 Move down to the next pixel line
C $765A One fewer pixel line to do
C $765C Restore the row addresses
C $765E Move both addresses BACK one character row instead (a negative step)
C $7665 One fewer character row to do
C $7668 Restore the saved registers
c $766D Print a character using the ROM font
D $766D Draws character A at screen address HL using the Spectrum ROM's character set at $3D00 (8 x 8 pixels), then moves HL on to the next character cell. Used only for the lower (input) window.
R $766D Input:A Character
R $766D HL Screen address
R $766D Output:HL Next character position
C $766D Save the registers this uses
C $7671 A = the character code, counted from the space character
C $7676 ...times 8, since each character's bitmap is 8 bytes...
C $7679 ...added to the start of the ROM's own character set
C $767D DE = the character's own bitmap
C $767E HL = where to draw it (put back for a moment)
C $7680 Eight pixel rows to copy
C $7682 Copy one row of the bitmap...
C $7684 Move on to the next row of the bitmap...
C $7685 ...and the next pixel line on screen (the odd layout means +$100)
C $7688 Restore HL and the other saved registers
C $768C Move on to the next character cell
s $768E
c $7694 Put a character on the screen
D $7694 Prints one character in the story window, which fills the upper part of the screen and uses the game's own 6-pixel font (#R$77BC). The screen address is kept at $768F, the pixel offset within the byte at $7691, and the number of characters left on the line at #R$768E (42 per line).
D $7694 Letters are converted to lower case, except that the first letter after a full stop or a new line is capitalised: the flag at $B5F5 is set by those, and cleared once a capital has been printed. This is why the game's text needs no capital letters in the dictionary.
D $7694 A carriage return sends the finished line to the ZX Printer if it is switched on (#R$7B15), then scrolls the story window up (#R$775E) and starts a new line. Before scrolling, the game checks the line counter at #R$B606, which is set to 9 each time the player enters a command: after that many lines, each further line waits (for about half a second, or until a key is pressed) so that long bursts of text do not rush past unread. A key held down at that point has to be released before the text continues.
D $7694 A backspace moves back 6 pixels (#R$7754) and rubs out the character there. A full line wraps automatically.
D $7694 If $7692 is non-zero, that many spaces are printed at the start of the line first (an indent). This is the routine I used as a hook in the emulator to capture everything the game printed.
R $7694 Input:A Character code
C $7694 Save the registers this uses
C $7697 HL = the current print position on screen
C $769A C = the pixel offset within that screen byte
C $769E Has a capital letter already been printed since the last full stop or new line?
C $76A2 Yes: no indent needed
C $76A4 Is an indent wanted at the start of this line (e.g. for a container's contents)?
C $76A8 No: skip straight to printing the character below
C $76AA B = how many indent spaces
C $76AB Draw a space...
C $76B0 One less character of room on this line now
C $76B7 Repeat for the whole indent
C $76B9 Restore the actual character to print
C $76BB Is it a new line?
C $76BF Yes: the very next character printed should get a capital letter
C $76C4 No capital has been printed yet on this new line
C $76C8 Send the finished line to the ZX Printer, if it is switched on
C $76CB Save the pixel offset
C $76CC How many more lines can be printed before pausing for a key?
C $76D0 Some left: just count one down below
C $76D2 None left: wait for a key, but time out eventually rather than freeze forever
C $76D6 Is a key being pressed right now?
C $76DC Yes: stop waiting
C $76DE No: count down the timeout
C $76E3 Timed out: give up waiting
C $76E6 Still some lines left before a pause: one fewer
C $76EA Restore the pixel offset
C $76EB Wait here until a key really is pressed
C $76F4 Back to the top of the story window
C $76F9 Scroll it up one line
C $76FC Start the new line with a fresh indent marker
C $7700 Is it a backspace?
C $7704 Move the print position back one character...
C $7707 ...draw a space over what was there...
C $770C ...then move back again, ready for whatever comes next
C $770F One more character of room on the line
C $7715 Is it an upper-case letter?
C $771D Yes: make it lower case, since the story window's own text is always in lower case
C $771F Save HL
C $7720 Should THIS letter be a capital instead (the "start a new sentence" flag)?
C $7725 No: leave it as it is
C $7727 Is it actually a lower-case letter that could be capitalised?
C $772F Yes: make it upper case
C $7731 The "next letter gets a capital" flag has now been used up
C $7733 Is this character a full stop?
C $7737 If so, arrange for the very next letter to be capitalised
C $7738 Restore HL
C $7739 Draw the character itself
C $773C Remember that something has now been printed on this line, so no further indent is added
C $773F One less character of room on the line
C $7743 None left: treat it as if a new line had just been reached, to wrap and scroll
C $7746 Save the room left on the line
C $7749 Save the new print position
C $774C Save the new pixel offset
C $7750 Restore AF, BC and HL
c $7754 Move back one character position
D $7754 Moves the story window's print position back 6 pixels: C (the bit offset within the screen byte) is reduced by 6, and if that goes below zero it has 8 added and L is moved back one byte.
R $7754 Input:C Bit offset
R $7754 L Screen address (low byte)
C $7754 A = the pixel offset within the current screen byte
C $7755 Move back 6 pixels, the width of one character
C $7758 Still within the same byte: done
C $7759 Crossed into the byte before: wrap the offset round...
C $775C ...and step back to that earlier byte
c $775E Scroll the story window up
D $775E Scrolls the top 17 character rows of the screen ($4000 onwards, down to $5020) up by one character row, pixel line by pixel line, taking care of the Spectrum's awkward screen layout at the boundaries between the thirds of the screen. The attributes of those rows are scrolled too (so that a picture's colours move with it). Finally the bottom row of the story window at $5020 is cleared by printing 42 spaces in the 6-pixel font.
C $775E Save the registers this uses
C $7762 HL = the second pixel row of the story window...
C $7765 ...DE = the first, where it is moving to
C $7768 17 character rows make up the whole story window
C $776C Save the row addresses
C $776E Eight pixel lines per character row
C $7770 Save this pixel line's addresses
C $7773 32 bytes per pixel line
C $7775 Copy it up
C $7777 Restore the counters
C $777A Move down to the next pixel line
C $777C One fewer pixel line to do
C $777F Restore the row addresses
C $7781 Move both addresses on to the next character row
C $7787 The screen's odd memory layout means a plain add sometimes lands in the wrong third of the screen, so check and correct that:
C $778B DE is already fine as it is...
C $778E ...otherwise nudge it on to the next third
C $7791 Do the same correction for HL
C $779A Restore AF
C $779B One fewer character row to do
C $779E The attributes need to move up one row too...
C $77A7 ...so that a picture's colours scroll along with it
C $77A9 The bottom row is now empty: clear it with 42 spaces, a full line of the 6-pixel font
C $77B7 Restore the saved registers
c $77BC Draw a character glyph
D $77BC Draws one 8x8 character from the font at #R$7815. The glyph address is #R$7715 + 8 x character code (the font only defines codes $20 to $7F, so the table effectively starts at #R$7815).
D $77BC Characters are drawn on a 6-pixel pitch rather than the Spectrum's usual 8, which is why The Hobbit fits more text on a line than most Spectrum games. C holds the pixel offset within the current screen byte, so each glyph row is shifted right by C bits and may straddle two screen bytes: the first part is masked into (HL) and the overflow is shifted left and masked into (HL+1). After drawing, C is advanced by 6 and, if it passes 8, L moves on to the next byte.
R $77BC Input:A Character code
R $77BC C Pixel offset within the screen byte (0-7)
R $77BC HL Screen address of the top row
C $77BC Save the registers this uses
C $77C0 HL = the character code...
C $77C3 ...times 8, since each glyph is 8 bytes...
C $77C6 ...added to the start of the game's own font
C $77CA DE = the glyph's own bitmap
C $77CB HL = where to draw it (put back for a moment)
C $77CD Eight pixel rows to draw
C $77CF A = this row of the glyph
C $77D1 Is the pixel offset C exactly 0 (no shifting needed)?
C $77D3 B will become a mask of which bits belong to this glyph
C $77D5 No shift needed: skip the loop below
C $77D7 Shift the glyph right by C bits...
C $77D9 ...building the matching mask alongside it
C $77DE C = the (possibly shifted) glyph bits for this screen byte
C $77DF Combine them into the screen, keeping whatever was already there outside the mask
C $77E4 Restore the pixel offset
C $77E5 Does the glyph spill over into the NEXT screen byte too?
C $77E7 No: nothing more to do for this row
C $77E9 Yes: work out the overflow into that next byte
C $77EE A = the same glyph row again
C $77F1 This time shift it LEFT, to land the spilt-over bits at the start of the next byte...
C $77F8 C = those overflow bits
C $77F9 Combine them into the next screen byte, again keeping what was already there
C $77FF Back to the first byte, ready for the next pixel row
C $7801 Move on to the next row of the glyph...
C $7802 ...and the next pixel line on screen (the odd layout means +$100)
C $7805 Restore the saved registers
C $7808 Move the pixel offset on by 6, the width of a character...
C $780B Did that cross into the next screen byte?
C $780F If so, wrap the offset round...
C $7811 ...and step on to that byte
C $7812 Save the new pixel offset
C $7813 Restore AF
b $7815 Font
D $7815 96 characters, codes $20 (space) to $7F, 8 bytes each, top row first. Each glyph uses only the left 6 pixels, matching the 6-pixel character pitch used by #R$77BC. For example 'A' is at #R$791D: $00,$38,$44,$44,$7C,$44,$44,$00.
D $7815 #FONT$7815,96
B $7815,768,8 Characters $20-$7F
c $7B15 Copy a line of text to the ZX Printer
D $7B15 The Hobbit can send its output to a ZX Printer (the PRINT and NOPRINT commands). If the flag at $B5E3 is set, this routine is called by #R$7694 at the end of every line of text, and it copies the 8 pixel rows of that line from the screen, starting at $5020, to the printer.
D $7B15 The ZX Printer is driven directly through port $FB. For each pixel row, the 32 bytes are sent one bit at a time: for each dot the routine waits for the printer's encoder signal (bit 0 of the port) and then outputs the dot. D controls the motor speed: it starts at 1 (slow), and after the first two rows the value derived from E runs the motor at full speed. After the 8 rows the motor is stopped (OUT ($FB),4). If the printer is not connected (bit 7 of the port reads as 1) the routine gives up straight away.
C $7B15 Is the printer switched on?
C $7B18 Is A zero?
C $7B19 Return if it is zero
C $7B1A Save HL
C $7B1B Save DE
C $7B1C Save BC
C $7B1D Slow motor; HL = start of the line on the screen
C $7B1F HL = $5020
C $7B22 A = 0
C $7B23 E = A
C $7B24 Start the motor and wait for the printer to be ready
C $7B26 Read the keyboard/port
C $7B28 Add A,A
C $7B29 Bit 7 set: no printer connected
C $7B2C If carry clear, go to #R$7B26
C $7B2E Save HL
C $7B2F Save DE
C $7B30 A = D
C $7B31 Compare with 2
C $7B33 Subtract A,A with carry
C $7B34 Keep only the bits of E
C $7B35 Rotate A left
C $7B36 Keep only the bits of E
C $7B37 D = A
C $7B38 C = (HL)
C $7B39 Save HL
C $7B3A Send eight dots per screen byte
C $7B3C A = D
C $7B3D Shift/rotate C
C $7B3F Rotate A right through carry
C $7B40 H = A
C $7B41 Wait for the encoder...
C $7B43 Rotate A right through carry
C $7B44 If carry clear, go to #R$7B41
C $7B46 A = H
C $7B47 ...and send the dot
C $7B49 Loop back until B reaches 0
C $7B4B Restore HL
C $7B4C Next byte, until all 32 have been done
C $7B4D A = L
C $7B4E Keep only the bits of $1F
C $7B50 If it is not zero, go to #R$7B38
C $7B52 Read the keyboard/port
C $7B54 Rotate A right through carry
C $7B55 If carry clear, go to #R$7B52
C $7B57 A = D
C $7B58 Rotate A right
C $7B59 Write to the port (border colour, beeper or printer)
C $7B5B Restore DE
C $7B5C Restore HL
C $7B5D Next pixel row
C $7B5E Increment E
C $7B5F Test bit 3 of E
C $7B61 If the bit is clear, go to #R$7B24
C $7B63 Stop the motor
C $7B65 Write to the port (border colour, beeper or printer)
C $7B67 Restore BC
C $7B68 Restore DE
C $7B69 Restore HL
C $7B6A Done
c $7B6B Short delay
D $7B6B Counts BC down from 1000. This takes about 26,000 T-states, a little over 7 ms, and slows the keyboard scan in #R$7B86 down enough to debounce the keys. It also sets the pace of the idle timer in #R$7240. BC is 0 on return.
C $7B6B BC = 1000
C $7B6E Count down...
C $7B71 ...to zero, taking a little over 7ms
b $7B74 Keyboard scan state
D $7B74 #LIST { #R$7B74-$7B7B: a mask for each of the eight half-rows of the keyboard, ORed with the reading so that those keys are never seen as pressed. The masks hide CAPS SHIFT ($01 in the first half-row) and SYMBOL SHIFT ($02 in the last), which are read separately as shift keys, and the unused keys 1, 3, 4 ($0D in the 1-5 half-row) and 9 ($02 in the 0-6 half-row). } { #R$7B7C-$7B7D: the newly pressed key found by the last scan: the bits in #R$7B7C and the half-row in $7B7D, or 0 for none. } { #R$7B7E-$7B85: the previous reading of each half-row, used to detect keys that have just gone down. } LIST#
B $7B74,8,8 Key masks
B $7B7C,2,2 New key
B $7B7E,8,8 Previous readings
c $7B86 Read a key
D $7B86 Scans the keyboard directly through port $FE (the game does not use the ROM keyboard routine or interrupts) and returns the ASCII code of a key that has just been pressed, or 0 if no new key has been pressed. Holding a key down does not repeat it.
D $7B86 The routine first waits a few milliseconds (#R$7B6B), then reads each of the eight half-rows in turn, starting with port $FEFE (CAPS SHIFT to V) and rotating the high byte of the port address to reach the next row. Each reading is ORed with that row's mask from #R$7B74. A key counts as newly pressed if its bit is 0 now but was 1 in the previous reading kept at #R$7B7E; the row and bits of such a key are saved at #R$7B7C.
D $7B86 If a new key was found, its row and bit are turned into a number from 0 to 39 (row x 5 + bit, #R$7BC0-#R$7BCE). Then the shift keys are checked directly: if CAPS SHIFT is held, or SYMBOL SHIFT is not, the normal table at #R$7BEE is used; if SYMBOL SHIFT is held (and CAPS SHIFT is not), the symbol table at #R$7C16 is used. The table entry is returned in A.
D $7B86 In my emulator I replaced this routine with one that fed typed commands to the game.
R $7B86 Output:A ASCII code of the key, or 0
C $7B86 Save HL
C $7B87 Save IX
C $7B89 Save BC
C $7B8A Short delay; clear the new-key record
C $7B8D Store BC in the new key record
C $7B91 HL = #R$7B7E
C $7B94 IX = Keyboard scan state (#R$7B74)
C $7B98 Start with the CAPS SHIFT-V half-row
C $7B9B Read it and hide the ignored keys
C $7B9D Keep only the bits of $1F
C $7B9F Combine with (IX+$00)
C $7BA2 Save AF
C $7BA3 Any key down now that was up before?
C $7BA4 Keep only the bits of (HL)
C $7BA5 A = NOT A
C $7BA6 If it is zero, go to #R$7BAF
C $7BA8 Yes: remember the row and the bits
C $7BAC Store A in the new key record
C $7BAF Restore AF
C $7BB0 Save this reading for next time
C $7BB1 Increment HL
C $7BB2 Increment IX
C $7BB4 Next half-row
C $7BB6 If carry is set, go to #R$7B9B
C $7BB8 Was a new key found?
C $7BBC A = B
C $7BBD Combine with C
C $7BBE If it is zero, go to #R$7BE9
C $7BC0 Work out its number: 5 x row...
C $7BC2 Add A,$05
C $7BC4 Shift/rotate B
C $7BC6 If carry set, go to #R$7BC2
C $7BC8 Decrement A
C $7BC9 Increment A
C $7BCA ...+ bit
C $7BCC If carry set, go to #R$7BC9
C $7BCE C = A
C $7BCF B = 0
C $7BD1 Use the normal table...
C $7BD4 ...if CAPS SHIFT is pressed...
C $7BD6 Read the keyboard/port
C $7BD8 Keep only the bits of $01
C $7BDA If it is zero, go to #R$7BE4
C $7BDC ...or SYMBOL SHIFT is not
C $7BDE Read the keyboard/port
C $7BE0 Keep only the bits of $02
C $7BE2 If it is not zero, go to #R$7BE7
C $7BE4 Otherwise use the SYMBOL SHIFT table
C $7BE7 Look up the key
C $7BE8 A = (HL)
C $7BE9 Restore BC
C $7BEA Restore IX
C $7BEC Restore HL
C $7BED Done
b $7BEE Keyboard table
D $7BEE The character for each key when SYMBOL SHIFT is not held (with or without CAPS SHIFT), five entries per half-row in the order the rows are scanned. 0 means the key does nothing. Only letters, ENTER and SPACE are here, plus: 5 and 0 give $08 (delete, or west as the first key of a line), 8 gives $09 (east), 7 gives $5B (north) and 6 gives $0A (south). See #R$6E46.
B $7BEE,5,5 CAPS SHIFT, Z, X, C, V
B $7BF3,5,5 A, S, D, F, G
B $7BF8,5,5 Q, W, E, R, T
B $7BFD,5,5 1, 2, 3, 4, 5
B $7C02,5,5 0, 9, 8, 7, 6
B $7C07,5,5 P, O, I, U, Y
B $7C0C,5,5 ENTER, L, K, J, H
B $7C11,5,5 SPACE, SYMBOL SHIFT, M, N, B
b $7C16 Keyboard table (SYMBOL SHIFT)
D $7C16 The character for each key when SYMBOL SHIFT is held. Most keys give the same as #R$7BEE; the differences are SYMBOL SHIFT with 2 ('@', repeat the last command, #R$6E71), 0 ($18, delete the whole line, #R$6E82), P (double quote, for speech), M (full stop), N (comma) and SPACE ($02).
B $7C16,5,5 CAPS SHIFT, Z, X, C, V
B $7C1B,5,5 A, S, D, F, G
B $7C20,5,5 Q, W, E, R, T
B $7C25,5,5 1, 2, 3, 4, 5
B $7C2A,5,5 0, 9, 8, 7, 6
B $7C2F,5,5 P, O, I, U, Y
B $7C34,5,5 ENTER, L, K, J, H
B $7C39,5,5 SPACE, SYMBOL SHIFT, M, N, B
b $7C3E Parser work area
D $7C3E Used by #R$7C4F: the flag at $7C44 and the ten bytes from $7C45 are cleared at the start of each parse.
B $7C3E,17,8
c $7C4F Parse the command
D $7C4F The parser. It works through the tokens in #R$7093 (the pointer to the next token is kept at $B5CD) and turns them into one or more 24-byte command frames, starting at #R$B8B8 and growing downwards in memory (#R$B8A0, #R$B888...). The number of frames built is counted in $B5F7.
D $7C4F A frame holds: the verb (offset 0; bit 7 of byte 1 marks a command with ALL, and bit 6 marks an extra frame that only holds an exception for ALL EXCEPT), an adverb, direction or particle (offset 2), and two noun phrases of 10 bytes each (offsets 4 and 14). A noun phrase is two prepositions, a noun and two adjectives, so 'put the small curious key in the wooden chest' becomes PUT, (KEY, SMALL, CURIOUS), (IN, CHEST, WOODEN).
D $7C4F The parser is a state machine. Register E holds a set of flags saying what may come next: bit 1 'a verb may start here', bit 2 'an adverb is allowed', bit 3 'we have just had AND', bit 4 'an article is allowed', bit 6 'the first noun phrase is still empty', bit 7 'the second noun phrase is still empty', bit 0 'the verb has been followed by a direction'. Register D holds the class of the token being processed.
D $7C4F For each token, #R$7F3D fetches it and the class (top nibble, divided by 8) indexes the jump table at #R$7C9C, which sends it to a handler: adverbs to #R$7DBC, IN/INTO to #R$7E5F, directions to #R$7DB6, verbs to #R$7DFD, GO/RUN to #R$7DF9, nouns to #R$7E9B, adjectives to #R$7E93, prepositions to #R$7E6C, articles to #R$7E5A, special words to #R$8009, AND to #R$7DD5, THEN (and full stop) to #R$7CC4 and the end of the line to #R$7CC0.
D $7C4F A word that is not allowed where it appears goes to #R$7FEE, which prints 'what?' (inside a quotation it is ignored instead, so that orders to other characters are more forgiving).
D $7C4F If a previous command was left unfinished ($B60A set, for example after the game asked 'which key?'), the parser starts in a different state so that the words just typed are fitted into the old frame (see #R$7CFC).
C $7C4F IY = the first command frame
C $7C53 Not inside a quotation
C $7C57 No ALL or ALL EXCEPT in force
C $7C5A No frames built yet
C $7C5D State: everything allowed
C $7C5F Is an unfinished command waiting to be completed?
C $7C63 (Pretend the previous word was AND)
C $7C65 Yes: go straight to the end-of-line processing, which merges the new words in
C $7C68 Previous class: end of line
C $7C6A START OF A COMMAND: no prepositions yet
C $7C6E Allow a verb (bit 1), an adverb (bit 2), and both noun phrases (bits 6 and 7)...
C $7C72 ...but after ALL EXCEPT...
C $7C79 ...no new verb is allowed
C $7C7B Clear the frame
C $7C7E NEXT NOUN PHRASE: clear the 10-byte noun phrase buffer
C $7C86 Articles are allowed again
C $7C88 NEXT WORD: fetch it; A and D = its class, BC = the word
C $7C8C Class / 8 = offset into the jump table
C $7C92 HL = the handler for this class
C $7C9B Go to it
w $7C9C Parser jump table
D $7C9C Addresses of the parser's handler for each word class (see #R$7C4F), indexed by class / 16.
W $7C9C,26 Adverb, IN/INTO, direction, verb, GO/RUN, noun, adjective, preposition, article, special, AND, THEN, end of line
c $7CB6 Is the parser inside a quotation (set Z)?
D $7CB6 Returns with Z set if $B60B is exactly 1 (inside one level of quotation).
C $7CB6 A = how many levels of quotation we are inside
C $7CB9 Is that exactly one level (an ordinary order to a character, not a quotation within a quotation)?
C $7CBA Z reflects the answer
c $7CBB Is the parser inside a quotation?
D $7CBB Returns with Z reset if $B60B is non-zero (inside a quotation), Z set otherwise.
C $7CBB A = how many levels of quotation we are inside
C $7CBE Is that zero (not inside any quotation at all)?
C $7CBF Z set means not in a quotation; NZ means we are
c $7CC0 Parser: end of line (and THEN / full stop)
D $7CC0 Handles the end-of-line token, and (from #R$7CC4) THEN or a full stop. It closes the current command frame. If a verb was required but none was given it complains (#R$7FF9).
D $7CC0 For ALL (see #R$808A) the verb is flagged. The frame count $B5F7 is increased and, for THEN, the parser goes back to the start state for the next command (#R$7C6A).
D $7CC0 At the end of the line some tidying up is done. If the previous command was unfinished ($B60A), the new words are merged into it (#R$7D02-#R$7D4B): empty slots in the old frame are filled from the new one. Then frames that have no verb of their own (because of AND, as in 'take the key and the sword') are given the verb of the frame before them (#R$7F81). Finally, noun phrases consisting of IT are resolved, and if a quotation is still open the parser starts again.
C $7CC0 End of the line: no more commands will follow
C $7CC4 THEN, full stop or end: has a verb been given (bit 1 of E clear)?
C $7CC6 Yes: close the frame
C $7CC8 No verb. Is this the first frame?
C $7CCC No: the verb will be copied from the frame before
C $7CCE First frame without a verb. Was the previous word the end of the line too?
C $7CD6 An empty line: nothing to do
C $7CD8 Inside a quotation?
C $7CDB No: a command with no verb, so "what?"
C $7CDE Close the frame. Is ALL in force?
C $7CE4 Yes: mark the verb with bit 7 (ALL)
C $7CE8 HL = the frame count
C $7CEF (Under ALL EXCEPT, an AND does not start a new frame)
C $7CF3 Count the frame
C $7CF4 Move on to the next frame
C $7CF7 Was this an AND or THEN rather than the end of the line?
C $7CF9 Yes: start the next command
C $7CFC END OF THE LINE. Is an unfinished command waiting?
C $7D00 No: go on to share verbs between frames
C $7D02 Yes: HL = the slot in the old frame that the question was about ($B60A holds its offset)
C $7D0C IY = the frame just typed
C $7D10 Does its first noun phrase have a noun?
C $7D19 No: use it anyway
C $7D1B Is it the same noun the old command used?
C $7D27 Yes: take this phrase
C $7D29 Otherwise try the second noun phrase
C $7D34 No suitable phrase: leave the old command as it was
C $7D36 Fill the empty words of the old phrase (noun and two adjectives) from the new one...
C $7D3D ...keeping any word already there
C $7D49 ...for all three words
C $7D4C SHARE VERBS: start just above the first frame
C $7D52 B = the number of frames
C $7D57 Step to the first frame
C $7D5A Any frames left?
C $7D5C No
C $7D5E Step to the next frame
C $7D61 Does it have a verb of its own?
C $7D69 No (it came from AND): give it the previous frame's verb
C $7D6C Loop
C $7D6E SHARE SECOND NOUN PHRASES, working backwards:
C $7D73 step to the previous frame
C $7D76 Any frames left?
C $7D78 No: finish
C $7D7B Step back one more
C $7D7E Does this frame lack a second noun phrase...
C $7D86 ...and have the same verb as the frame after it...
C $7D96 ...which does have one?
C $7D9E Then copy that phrase into this frame ("put the key and the sword in the chest")
C $7DA5 Loop
C $7DAA More commands to come (THEN)?
C $7DAE No: parsing is complete
C $7DAF Inside a quotation?
C $7DB2 No: return
C $7DB3 Yes: carry on parsing the words after it
c $7DB6 Parser: a direction
D $7DB6 A direction on its own ('north') is a complete movement command: if a verb may start here (bit 1 of E), it is treated as GO NORTH (#R$7DFB). After a verb, a direction is stored as the frame's particle, like an adverb (#R$7DBC): bit 2 of E must allow it, and it is put at offset 2 of the frame (#R$7FE2). The entry at #R$7DBC is the handler for adverbs.
C $7DB6 May a verb start here?
C $7DB8 Yes: treat the direction as "go <direction>"
C $7DBA Otherwise it is used like an adverb
C $7DBC ADVERB: is an adverb allowed here?
C $7DBE No: syntax error
C $7DC1 Under ALL EXCEPT...
C $7DC8 ...start a new frame for it
C $7DCB No more adverbs
C $7DCD Store the word at offset 2 of the frame
C $7DD2 Next noun phrase
c $7DD5 Parser: AND
D $7DD5 AND (or a comma) is ambiguous: it may join two objects ('take the key and the sword') or two commands ('take the key and go east'). The parser cannot tell until it sees what follows, so it records where it is: the token pointer (in #R$7C3E and $B5CD, pointing back at the AND), the state flags E ($7C40), the frame pointer IY ($7C41) and the frame count ($7C43). It then carries on as though a new command had begun (#R$7CC4). If a verb turns up next, the new command stands. If not, the verb handler at #R$7DFD is never reached and the next frame inherits the verb of this one (#R$7F81).
D $7DD5 Bit 3 of E is reset to show that an AND has just been seen.
C $7DD5 Note that AND has been seen (bit 3 clear)
C $7DD8 Skip any further ANDs and commas
C $7DDF Step back so the word after them will be read again
C $7DE1 Save the token pointer...
C $7DE8 ...the state flags...
C $7DEC ...the frame pointer...
C $7DF0 ...and the frame count, so the parser can backtrack here
C $7DF6 Then carry on as if a new command were starting
c $7DF9 Parser: GO or RUN
D $7DF9 Clears bit 0 of E and continues into #R$7DFB, so that GO and RUN are treated as verbs that may be followed by a direction.
C $7DF9 Clear this state bit, then fall into the ordinary verb handler below: GO and RUN are treated as verbs that may be followed by a direction
c $7DFB Parser: a verb
D $7DFB The entry at #R$7DFB (from #R$7DB6) supplies the verb GO ($30 class) for a bare direction; the entry at #R$7DFD handles verbs typed by the player.
D $7DFB If a verb arrives when a command has already been started and there has been no AND, the parser backtracks: the state saved by the last AND (#R$7DD5) is restored and the AND is reinterpreted as THEN, splitting the line into two commands.
D $7DFB Otherwise the verb must be allowed here (bit 1 of E). It is stored at offset 0 of the frame (#R$7FDE). GO and RUN look ahead (from #R$7E31) past any adverbs: if the next word is a direction, the verb is dropped and the direction stored as the particle, so that 'go north' and 'north' produce the same frame.
C $7DFB Class of GO (for a bare direction)
C $7DFD VERB: has there just been an AND?
C $7DFF Yes: a new command after AND is fine
C $7E01 Inside a quotation?
C $7E04 Yes: accept it
C $7E06 A second verb without AND: backtrack to the last AND...
C $7E0C ...and treat it as THEN
C $7E0E Restore the state saved at the AND
C $7E1C Close the frame and start a new one
C $7E1F A verb cancels ALL
C $7E22 Is a verb allowed here?
C $7E24 No: syntax error
C $7E27 Is this a GO followed by a direction?
C $7E29 No: look ahead
C $7E2B Store the verb in the frame
C $7E2E Next noun phrase
C $7E31 Look ahead past any adverbs...
C $7E40 ...is the next word a direction?
C $7E42 Yes
C $7E44 No: rewind and store the verb normally
C $7E4C Store GO as the verb...
C $7E52 ...and the direction at offset 2
C $7E57 Next noun phrase
c $7E5A Parser: an article
D $7E5A Articles (A, AN, THE and the like) are ignored, apart from clearing bit 4 of E; the parser goes straight on to the next word (#R$7C88).
C $7E5A No article is expected next
C $7E5C Go back for the next word: the article itself is simply ignored
c $7E5F Parser: IN or INTO
D $7E5F IN and INTO are usually prepositions, and are handled as such (#R$7E6C, with class $70). The exception is when a verb may start here and the previous word was AND or a comma, in which case they begin a new command such as 'and in': the parser jumps back to #R$7DFB to treat them like a direction.
C $7E5F May a verb start here?
C $7E61 No: treat IN/INTO as an ordinary preposition
C $7E63 A verb could start here - was the word just before this one AND or a comma?
C $7E68 If so, IN/INTO really begins a new command (like a direction): treat it as one
C $7E6A Otherwise it is an ordinary preposition after all
c $7E6C Parser: a noun phrase
D $7E6C Collects one noun phrase into the buffer at $7C45 (cleared by the main parser loop): up to two prepositions (#R$7EE6; a third one is an error), any number of articles (skipped), up to two adjectives (#R$7ED3; a third one is an error), and a noun, which ends the phrase (#R$7E9B stores it at $7C49). Adjectives enter at #R$7E93 and nouns at #R$7E9B. A phrase that ends without a noun (for example 'look through') is allowed and simply has no noun.
D $7E6C The phrase is then stored in the frame by #R$7EF5: the first phrase at offset 4 and the second at offset 14. When ALL EXCEPT is in force ($B609 = 2), each extra noun phrase instead starts a new frame (#R$7F22), with bit 6 of its verb marked, so that 'take all except the sword and the key' produces one frame per exception.
C $7E6C Store the preposition
C $7E6F Next word
C $7E72 Another preposition?
C $7E74 Yes: store it too
C $7E76 An article?
C $7E7A Are articles allowed here?
C $7E7C No: syntax error
C $7E7F Only one article
C $7E81 Next word
C $7E83 An adjective?
C $7E87 A noun?
C $7E8B Anything else ends the phrase: step back so it is read again
C $7E93 Store the adjective
C $7E96 Next word
C $7E9B Store the noun
C $7EA1 The phrase is complete. Under ALL EXCEPT...
C $7EAA ...a phrase without a preposition...
C $7EB1 ...is an exception: is this frame already an exception frame?
C $7EB7 No: make a new frame for it
C $7EBF Store the phrase as its first noun phrase...
C $7EC2 ...and mark the frame as an exception (bit 6)
C $7EC6 Next noun phrase
C $7EC9 A phrase with a preposition under ALL EXCEPT: new frame
C $7ECC Store the phrase in the frame
C $7ECF Next noun phrase
c $7ED3 Parser: store an adjective
D $7ED3 Stores the adjective token BC in the first empty adjective slot of the noun phrase buffer ($7C4B or $7C4D). If both are full, it is a syntax error (#R$7FEE).
C $7ED3 HL = the first adjective slot of the noun phrase being built
C $7ED6 Is it still empty?
C $7ED9 Yes: use this slot
C $7EDB No: try the second adjective slot instead
C $7EDF That is full too - a third adjective makes no sense: syntax error
C $7EE2 Store the adjective's high byte...
C $7EE4 ...and its low byte
c $7EE6 Parser: store a preposition
D $7EE6 Counts the prepositions in the current noun phrase ($7C44) and stores the token BC in the first empty preposition slot ($7C45 or $7C47). A third preposition is a syntax error (#R$7FEE).
C $7EE6 HL = the count of prepositions seen in this noun phrase so far
C $7EE9 One more
C $7EEB Is that three or more?
C $7EED A third preposition makes no sense: syntax error
C $7EF0 Otherwise HL = the first or second preposition slot...
C $7EF3 ...and store it there, sharing the adjective-storing code above
c $7EF5 Parser: store a noun phrase in the frame
D $7EF5 Copies the 10-byte noun phrase from $7C45 into the command frame: to offset 4 if bit 6 of E says the first phrase is still empty (#R$7F1A), otherwise to offset 14 if bit 7 says the second is empty (#R$7F02). The corresponding bit of E is cleared. If both phrases are already full, it is a syntax error (#R$7FEE).
C $7EF5 Is the first noun phrase free?
C $7EF7 Yes: store it there
C $7EF9 Is the second free?
C $7EFB Yes: store it there
C $7EFD Neither: syntax error
C $7F02 The second phrase is now taken
C $7F05 Offset 14 in the frame
C $7F0C DE = the place in the frame
C $7F0E Copy the 10-byte noun phrase there
C $7F18 Return with Z set
C $7F1A The first phrase is now taken
C $7F1D Offset 4 in the frame
c $7F22 Parser: move on to the next frame
D $7F22 Finds the next frame (#R$7F6F) and makes it the current one (IY).
C $7F22 IX = the next frame (24 bytes lower, since frames are built downwards)
C $7F25 IY = that same frame...
C $7F27 ...which becomes the current one
c $7F29 Parser: clear the ALL state
D $7F29 Sets $B609 to 0: no ALL or ALL EXCEPT is in force.
C $7F29 A = 0: no ALL, and no ALL EXCEPT, is in force
c $7F2E Parser: clear the current frame
D $7F2E Clears the 24 bytes of the frame at IY, and the two bytes of the verb of the frame after it (at IY-24), so that the next frame starts empty.
C $7F2E HL = the current frame
C $7F31 24 bytes to clear: the whole frame
C $7F33 Clear it
C $7F36 Also clear the verb of the frame that comes after this one (2 bytes, 24 further along)...
C $7F39 ...(B is 0 here, left over from the clearing loop) so it starts empty too
c $7F3D Parser: fetch the next token
D $7F3D Reads the next token from the token buffer (pointer at $B5CD), which it then advances by two. On return D holds the class (the top nibble of the first byte) and BC the word: B the top nibble of the offset and C the bottom byte. The previous class is saved at $B5CF (so that handlers can see what came before), and the position of the token is saved at #R$B5CB for error messages. A also holds the class.
R $7F3D Output:A Class
R $7F3D D Class
R $7F3D BC Word
C $7F3D HL = the token pointer
C $7F40 Remember where this word is, for error messages
C $7F43 Remember the previous class
C $7F47 B = the top four bits of the word offset
C $7F4B D = A = the class
C $7F50 C = the bottom eight bits of the offset
C $7F52 Move the token pointer on
c $7F56 Parser: step back to the previous frame
D $7F56 Decrements B (a frame counter), finds the previous frame (#R$7F6F, 24 bytes higher) and swaps IX and IY, so that IY is the previous frame and IX the one we came from.
C $7F56 One frame fewer to go
C $7F57 IX = the previous frame (24 bytes higher)
C $7F5A Swap IX and IY
c $7F5C Parser: step on to the next frame
D $7F5C Decrements B, finds the next frame (#R$7F69, 24 bytes lower) and swaps IX and IY, so that IY is the next frame and IX the one we came from. The entry at #R$7F5D does not decrement B.
C $7F5C One frame fewer to go
C $7F5D IX = the next frame (24 bytes lower)
C $7F60 Swap IX and IY...
C $7F66 ...so IY is the new frame and IX the old one
c $7F69 Find the next frame (24 bytes lower)
D $7F69 Returns IX = IY - 24: the frame after the current one in parse order (frames are built downwards from #R$B8B8). Frames that only hold an exception for ALL EXCEPT (bit 6 of byte 1) are skipped. Continues into #R$7F6F at #R$7F73.
C $7F6A Step -24: the next frame
c $7F6F Find the previous frame (24 bytes higher)
D $7F6F Returns IX = IY + 24: the frame before the current one in parse order, skipping ALL EXCEPT exception frames (bit 6 of byte 1). The entry at #R$7F73 is shared with #R$7F69, which uses -24 instead.
C $7F70 Step +24: the previous frame
C $7F73 IX = IY...
C $7F77 ...plus the step
C $7F79 Is this an exception frame (bit 6)?
C $7F7D Yes: skip over it
c $7F81 Parser: give a frame the previous frame's verb
D $7F81 Copies the verb from the frame at IX into the frame at IY (keeping IY's flag bits). This is how the verb is shared when AND joins objects: 'take the key and the sword' produces two TAKE frames.
D $7F81 If the new frame has a second noun phrase, and bit 7 of E is set, the second noun phrase and the particle of the previous frame are copied too (#R$7FC9), so that 'put the key and the sword in the chest' puts both in the chest.
C $7F81 Switch to the alternate registers for a moment
C $7F82 A = the previous frame's own verb flags...
C $7F85 ...with the ALL bit (bit 7) stripped out, since that should not be copied along
C $7F87 Combine that with whatever flags this frame already carries (such as its own EXCEPT bit)
C $7F8D Copy the verb itself too
C $7F93 Back to the ordinary registers
C $7F94 Does the new frame have a second noun phrase of its own?
C $7F9A No noun there at all: nothing more to copy
C $7F9B Is the "second phrase still empty" state flag set?
C $7F9D It is not empty: leave it as it is
C $7F9E Switch to the alternate registers again
C $7F9F HL = the new frame's own address
C $7FA2 Move on to its particle...
C $7FA6 Save that address
C $7FA7 Move back instead to the PREVIOUS frame's own particle
C $7FAB DE = the new frame's particle address, HL = the previous frame's
C $7FAC Copy 6 bytes: the particle, and the start of the noun that follows it
C $7FB1 Offset to the second noun phrase
C $7FB4 Copy that whole phrase too, from the previous frame
C $7FB7 Does the new frame's OWN particle turn out to be still empty?
C $7FBD If so, copy just the particle word on its own as well
C $7FC3 Back to the ordinary registers
c $7FC5 Copy part of one frame to another
D $7FC5 Copies C bytes at offset DE from the frame at IX to the same offset in the frame at IY. Entry points: #R$7FC5 copies 6 bytes (a noun and two adjectives), #R$7FC9 copies 10 (a whole noun phrase) and #R$7FCD copies 2 (one word). Used by #R$7F81 and #R$7CC0 to share words between commands.
C $7FC5 6 bytes: a noun with two adjectives
C $7FC9 10 bytes: a whole noun phrase
C $7FCD 2 bytes: a single word
C $7FCF HL = the destination frame, moved on by DE...
C $7FD3 Save that address
C $7FD4 HL = the source frame, moved on by the same amount...
C $7FD8 DE = the destination, HL = the source
C $7FD9 Copy the given number of bytes
c $7FDE Parser: store the verb
D $7FDE Clears bit 1 of E (no more verbs allowed) and stores the token BC at offset 0 of the current frame. The entry at #R$7FE2 stores BC at offset L instead (used for the particle at offset 2).
R $7FDE Input:BC Token
R $7FDE Output:E Updated state
C $7FDE No more verbs allowed on this line, until the next command starts
C $7FE0 L = the offset within the frame to store at (0 for the verb, or wherever the caller set it for the particle)
C $7FE2 Save DE
C $7FE3 HL = the current frame, plus that offset...
C $7FE9 Store the word's low byte...
C $7FEB ...then its high byte (with the class in the top nibble)
C $7FEC Restore DE
c $7FEE Parser: syntax error
D $7FEE Called when a word turns up where it is not allowed. Inside a quotation the word is simply skipped. Otherwise the parser's own return address is discarded and #R$7FF9 prints 'what?'.
C $7FEE Are we inside a quotation (an order to a character)?
C $7FF1 Yes: quietly ignore the bad word and let the order carry on
C $7FF2 No: throw away our own return address, since the rest of this line is being abandoned
C $7FF3 Check again (the same test, just to be sure)
C $7FF6 If it now looks like we ARE in a quotation after all, go back into the parser as if nothing had gone wrong; otherwise fall straight into #R$7FF9 below and print "what?"
c $7FF9 Print "what?"
D $7FF9 Prints 'what?' (the message at #R$AC93) in the lower window, and returns with Z reset so that the command is abandoned.
C $7FF9 "what?"
C $7FFC Send it to the lower (input) window...
C $8001 ...and print it
C $8004 Make A non-zero...
C $8006 ...so the main loop knows this command has failed
s $8007
c $8009 Parser: special words
D $8009 Looks the special word up in the table at #R$8029 and jumps to its handler. DE (the word's class and the parser's state) is saved on the stack at #R$800C and restored at #R$8027 before the jump.
D $8009 If the word is not in the table, the jump at #R$801C goes back into the parser WITHOUT restoring DE, leaving two bytes on the stack. Every special word except DO is in the table, so in practice this happens only when the player types DO - and then the game loses control completely (see the bug note).
D $8009 The special words are ALL, EXCEPT, IT, ONE, the game commands PRINT, NOPRINT, LOAD, SAVE, QUIT, HELP, SCORE and PAUSE, and a quotation mark (which has class $90 and a word of 0, and matches the first entry, #R$80CD).
C $8009 HL = the table of special words
C $800C Save the class and the parser state...
C $800D Thirteen entries to check
C $800F Compare the low byte of the word
C $8012 No match: next entry
C $8014 Compare the high nibble
C $8016 Found it
C $8018 Next entry
C $801C Not in the table: carry on parsing - but DE is never restored, so two bytes are left on the stack (see the bug note)
C $801F Found: the handlers are 25 bytes further on
C $8023 HL = the handler
C $8027 ...restore the class and state
C $8028 Jump to the handler
b $8029 Special words
D $8029 Thirteen word references (low byte first) followed by the thirteen addresses of their handlers (#R$8009).
W $8029,26 Quote, ALL, EXCEPT, IT, ONE, PRINT, NOPRINT, LOAD, SAVE, QUIT, HELP, SCORE, PAUSE
W $8043,26 Handlers
c $805D PRINT and NOPRINT
D $805D PRINT (#R$805D) switches on copying of the story window to a ZX Printer (#R$7B15), by setting $B5E3 to 1, but only if a printer is attached: bit 6 of port $FB is 0 when one is. NOPRINT (#R$8067) sets $B5E3 to 0.
D $805D The test for the printer has a curious slip: when no printer is attached, the JR NZ at #R$805F jumps to $8069, which is in the middle of the LD ($B5E3),A instruction. The bytes there are executed as EX (SP),HL and OR L before execution reaches #R$806B. In my tests the game carried on normally after PRINT with no printer, so the damage appears to be harmless in practice.
C $805D Read the ZX Printer's status port
C $805F Is a printer actually attached (bit 6 clear means yes)?
C $8061 No printer: leave printing switched off (joins the shared ending below, via the mis-jump described in the bug note)
C $8063 PRINT: switch printing on
C $8067 NOPRINT: switch it off
c $806B Special word finished: carry on parsing
D $806B Restores the previous word class from $B5CF into D and goes back to the parser loop (#R$7C7E). Used by the game commands, which are not part of the command being parsed.
C $806B A = the word class that came before this special word
C $806E Restore it, as if the special word had never been seen
C $806F Go back to reading the next word
c $8072 EXCEPT
D $8072 EXCEPT (or BUT) is only allowed straight after ALL ($B609=1). It sets $B609 to 2 and bit 7 of the current frame's verb, so that the command applies to everything except the objects that follow.
C $8072 Is ALL actually in force?
C $8077 No: EXCEPT makes no sense here - syntax error
C $807A Yes: switch to ALL EXCEPT
C $807F Mark the CURRENT frame's verb with the EXCEPT bit...
C $8084 ...so #R$7E6C knows any further noun phrases are exceptions, not extra targets
C $8087 Go back to reading the next word
c $808A ALL
D $808A Sets $B609 to 1 (ALL in force) unless ALL EXCEPT is already in force.
C $808A Is ALL EXCEPT already in force?
C $808F Yes: a second ALL changes nothing - just carry on
C $8092 No: switch plain ALL on
C $8097 Go back to reading the next word
c $809A IT
D $809A Replaces IT with the object most recently mentioned: the noun and two adjectives saved at $B5D1 (by #R$8614 each time a command names a target) are copied into the noun phrase buffer, which is then stored in the frame (#R$80AF). So 'take the key. unlock the door with it.' works.
C $809A Save DE
C $809B HL = the words remembered for IT (the last object named)
C $809E Copy them into the noun-phrase buffer currently being built
C $80A6 Restore DE
C $80A7 Is the first noun phrase still empty?
C $80A9 Store this phrase in whichever slot is free
C $80AC Go back to reading the next word
c $80AF Store the noun phrase in the frame (jump)
D $80AF Jumps to #R$7F02 (second noun phrase) if Z is set, otherwise to #R$7F1A (first noun phrase); see #R$7EF5.
C $80AF First phrase already taken: store in the second
C $80B2 Otherwise store in the first
c $80B5 Opening quotation mark
D $80B5 Begins a quotation, as in SAY TO THORIN "GO EAST". The current word class and frame count are saved (#R$8007, $8008), and the parser is re-entered at #R$7C54 with the frame pointer moved to a fresh frame, so that the words inside the quotation are parsed as complete commands of their own.
C $80B5 Save the word class we had reached...
C $80B9 ...and DE, BC and IY, so the parser can be restored exactly when the quotation closes
C $80BD Save the frame count too
C $80C3 Move on to a fresh frame (24 bytes higher, since frames are built downwards)
C $80C8 One level deeper inside a quotation
C $80CA Start parsing again, from a clean state, for the words inside the quotes
c $80CD Quotation mark
D $80CD A quotation mark (class $90, word 0) arrives here from #R$8009. If no quotation is open, it is an opening quote (#R$80B5). Otherwise it closes the quotation: $B60B is decreased, and the frames that were parsed inside it are moved to the orders buffer at #R$B628 so that the character spoken to can act on them later.
D $80CD The orders buffer has eight slots of 25 bytes. Each command is put in the first free slot: the slot's first byte is set to $FF (in use) and the 24-byte frame is copied after it. An ALL EXCEPT exception frame (bit 6) is stored as an empty order. $B627 is set to the number of orders stored. The parser state saved at the opening quote is then restored.
C $80CD Are we already inside a quotation?
C $80D1 No: this is an OPENING quote (#R$80B5)
C $80D3 Yes: this closes it - one level shallower
C $80D7 A = the frame count as it was when the quotation opened
C $80DB Subtract that from the frame count now, giving how many frames were built INSIDE the quotation
C $80E0 C will count how many orders are actually stored
C $80E2 None at all (an empty quotation): tidy up and finish, below
C $80E4 Restore IY to the frame just before the quotation opened...
C $80E8 ...then move up to the FIRST frame built inside it
C $80ED B = how many frames to process
C $80EE IX = the start of the orders buffer
C $80F2 Find the first free slot (marked with a 0 in its first byte)...
C $8103 ...mark it in use (properly addressed later, in #R$88A7)
C $8107 Move past the slot's own marker byte, to where the frame goes
C $8109 Restore the frame counter
C $810B No free slot was found: the rest of the orders are simply lost
C $810D Is this frame only an ALL EXCEPT exception, with no command of its own?
C $8111 No: copy it properly, below
C $8113 Yes: store it as an empty order instead
C $8119 Copy the whole 24-byte frame into the order slot...
C $8129 Move IY on to the next frame that was inside the quotation
C $812B (the exception-frame path joins here too, at the same offset)
C $812D One more order stored
C $812E Repeat for every frame that was built inside the quotation
C $8130 No ALL or ALL EXCEPT is in force any more
C $8134 Remember how many orders were actually stored
C $8138 Restore the frame pointer from before the quotation opened
C $813A Restore the frame count too
C $8140 Restore BC and DE, saved when the quotation opened
C $8142 Restore the word class the parser had reached
C $8146 Go back to reading the next word, as if the whole quotation had been a single word
c $8149 QUIT
D $8149 Prints the score (#R$81AD), waits for a key, and restarts the game (#R$6C27).
C $8149 Print the score
C $814C Wait for a key
C $8155 Restart the game
c $8158 HELP
D $8158 HELP gives a hint that depends on where Bilbo is. His room is looked up in the table at #R$8185; if it is there, that message is printed, otherwise the general one at #R$B358: 'you're doing fine.' The message goes to the lower window. HELP is ignored if a character is the actor (for example inside SAY TO).
C $8158 Is the current actor Bilbo, not a character (e.g. during SAY TO)?
C $815C Not Bilbo: ignore HELP entirely and carry on parsing
C $815F Save HL and IX
C $8162 "you're doing fine." - the general hint
C $8165 A = Bilbo's own room
C $8168 Is there a specific hint for this room?
C $816F No: keep the general hint
C $8171 Yes: HL = that room's own hint instead
C $8177 Print it in the lower window
C $817F Restore IX and HL
C $8182 Carry on parsing
b $8185 Help messages
D $8185 Room number and message address pairs for #R$8158, terminated by $FF. The hints are:
D $8185 #LIST { Room 6: 'a trolls door needs a trolls key.' } { Room 9: 'elves are good at reading symbols.' } { Room 13: 'a window should be no obstacle to a thief with friends.' } { Room 66: 'boats can help. look carefully.' } { Room 31: 'wait around and time your exit carefully.' } { Room 32: 'timing is critical, remember barrels float.' } { Room 42: 'wait a while.' } { Room 46: 'take care to leave at the right time.' } { Room 41: 'a living dragon is deadly, look to bard.' } { Room 26: 'don't stay too long.' } { Room 5: 'wait for the new day dawning.' } LIST#
c $81A7 SCORE
D $81A7 Prints the score (#R$81AD) and carries on parsing (#R$806B).
C $81A7 Print the score
C $81AA Carry on parsing
c $81AD Print the score
D $81AD Prints 'you have mastered xx.x% of this adventure.' The score is kept at $B5E8 in tenths of a percent. The hundreds and tens are printed with #R$81E6 (a leading zero in the hundreds is suppressed), then a decimal point and the tenths digit.
D $81AD The hundreds-digit routine only ever prints a single character ('0' plus the digit), so a score of 1000 or more would print a stray ':' rather than '10' - I checked this in the emulator by poking the score directly. It cannot happen in an ordinary game, though: the highest score obtainable is 750, or 75.0% (#R$8CEA), safely below the point where this would show.
C $81AD Save HL and DE
C $81AF Print in the lower window
C $81B3 "you have mastered "
C $81B9 HL = the score, in tenths of a percent
C $81BC Print the hundreds digit, dividing by 100...
C $81C2 ...but only if it is not zero (no leading zero)
C $81C5 Print the tens digit, dividing what is left by 10
C $81CE "."
C $81D3 Whatever is left (0-9) is the tenths digit
C $81D9 No forced capital for the word that follows
C $81DD "% of this adventure."
C $81E3 Restore DE and HL
c $81E6 Divide by repeated subtraction
D $81E6 Divides HL by DE by repeated subtraction, returning the ASCII digit of the quotient in A and the remainder in HL. Z is set if the digit is '0'.
R $81E6 Input:HL Number
R $81E6 DE Divisor
R $81E6 Output:A Digit ("0"-"9")
R $81E6 HL Remainder
C $81E6 A will become the ASCII digit ("0"-1, since the loop below starts by incrementing it)
C $81E8 One more digit counted
C $81E9 Subtract the divisor from what is left...
C $81EC ...as many times as it will go
C $81EE Put back the one subtraction that went too far
C $81EF Is the digit "0" (Z reflects whether it is)?
c $81F2 PAUSE
D $81F2 Turns the border green, waits for a key to be pressed and released (#R$8271), and turns the border white again. The game is frozen in the meantime: no timers run and no characters act.
C $81F2 Green border
C $81F6 Wait for a key to be pressed, then released
C $81F9 Wait here until a key really is pressed
C $8202 White border again
C $8206 Carry on parsing
c $8209 LOAD
D $8209 Loads a saved game from tape using the ROM routine LD-BYTES ($0556), in four headerless blocks: the 28 game variables (#R$B5CB, from #R$B5DC), the object table (#R$C00B), the timers and characters (#R$C973) and the room table (#R$B97A). These are exactly the areas that the game backs up at start-up (#R$6C00), and together they are the entire state of the game. Afterwards three bytes are copied from #R$B5DC back to #R$C8D1 (see #R$8284). If a block fails to load, #R$8250 reports a tape error and restarts the game.
D $8209 Two things live outside the four blocks. The three bytes of Bard's current order are handled specially (see #R$8284). But the address of the hidden route chosen at the start of the game is not saved at all: #R$970B writes it into the code of Elrond's map routine (the operand at $A6C5), not into the saved data.
C $8209 Save IX and DE
C $820C A headerless block is expected...
C $820E ...and it should be loaded, not verified
C $820F Load the 28 bytes of game variables...
C $8216 ...restarting the game if the tape fails
C $8219 Then the object table...
C $8226 Then the timers and character table...
C $8233 Then the room table...
C $8240 Interrupts off while poking at memory directly
C $8241 Restore the three bytes of Bard's own remembered order...
C $8247 ...which were tucked in among the saved variables
C $824A Restore DE and IX
C $824D Carry on parsing
c $8250 Load a block, or restart on a tape error
D $8250 Calls LD-BYTES. If it fails, prints 'tape error - hit any key to restart program', waits for a key and restarts the game (#R$6C27), because a half-loaded game state could not be trusted.
C $8250 The ROM's own LD-BYTES routine
C $8253 Loaded successfully: carry on
C $8254 Failed: print in the lower window
C $8259 "tape error - hit any key to restart program."
C $825F Wait for a key
C $8268 Restart the game (a half-loaded state cannot be trusted)
c $826B Copy three bytes
D $826B Copies three bytes from HL to DE (used to move the bytes at #R$C8D1 in or out of the saved variables).
C $826B Three bytes to copy
c $8271 Wait for a key press and release
D $8271 Waits until no key is pressed, then until one is.
C $8271 Wait here until no key at all is pressed
C $827A Then wait until one really is pressed
c $8284 SAVE
D $8284 Saves the game to tape. Three bytes at #R$C8D1 (part of the data after the room-entry handlers) are first copied over the start of the saved variables at #R$B5DC so that they are saved too. The player is asked to start the tape and press a key, and the four blocks listed under #R$8209 are saved with the ROM routine SA-BYTES ($04C2).
D $8284 Then, unusually for a 1982 game, it offers to VERIFY the save: 'rewind and prepare tape for verification - then hit any key', and reads the four blocks back with the ROM routine in verify mode (#R$8312).
C $8284 Save IX and DE
C $8287 Tuck Bard's own remembered order (from #R$C8D1) in among the saved variables for a moment...
C $8290 Ask the player to get the tape ready, in the lower window
C $829B Wait for a key
C $829E Save the 28 bytes of game variables (with Bard's order folded in)...
C $82A7 ...using the ROM's own SA-BYTES routine
C $82AA Then the object table...
C $82B6 Then the timers and character table...
C $82C2 Then the room table...
C $82CE Ask for the tape to be rewound, ready to verify what was just saved
C $82D4 Wait for a key
C $82D7 Verify the variables...
C $82E4 ...then the object table...
C $82F1 ...the timers and characters...
C $82FE ...and the room table
C $830B Interrupts off while poking at memory directly
C $830C Restore DE and IX
C $830F Carry on parsing
c $8312 Verify a block
D $8312 Calls the ROM's LD-BYTES in verify mode. On failure it prints 'tape error - hit any key to continue' and abandons the verification; the game carries on.
C $8312 The ROM's own LD-BYTES routine, in verify mode
C $8315 Verified correctly: carry on
C $8316 Failed: print in the lower window
C $831B "tape error - hit any key to continue."
C $8321 Wait for a key
C $832A Abandon the verification, but carry on with the rest of the game (unlike a LOAD failure, this is not fatal)
b $832E Command execution work area
D $832E Used by #R$83A7 and the routines after it while a command is being matched to objects. The first 17 bytes are cleared by #R$839A for each command.
D $832E #LIST { #R$832E, $832F: flags for the target and the instrument (bit 0: a noun was given; bit 1: a matching object has been found) } { $8330-$8332: counts of candidate objects and of those for which the action would work } { $8333-$8338 and $8339-#R$833E: the noun and adjectives given for the target and for the instrument } { $833F, $8341: where the search for the target and instrument has got to } { $8343: the ALL flag of the frame } { $8344: set when only one candidate is wanted } { $8345, #R$8346: frame offsets of the target and instrument phrases } { $8347, $8348: the candidate target and instrument } { $8349-#R$834E: the verb, particle and preposition used to find the action } { $834F: the action table entry } LIST#
B $832E,35,8
c $8351 Execute a command and run the turn
D $8351 Called by the main loop (#R$6D0A) after parsing. It works through the command frames built by the parser, one per command, starting at #R$B8B8.
D $8351 For each frame, #R$83A7 finds the action and the objects it applies to. If that fails, the frame is dropped. Otherwise the action is carried out for real: $B5EB is set to 1, #R$7122 reports it ('you take the sword.'), #R$946F performs it, and #R$9611 ends the turn, letting the characters act and the timers run. So every command the player types costs one turn, and a line with three commands costs three turns.
D $8351 A command with ALL is repeated (#R$837F) for each object it applies to, one turn each. When a frame is finished, the next frame (24 bytes lower) is taken, skipping the exception frames of ALL EXCEPT, until the frame count $B5F7 reaches 0.
D $8351 If the previous command was left unfinished ($B60A), it is picked up again at #R$8385 instead.
C $8351 No ALL command is still in progress yet
C $8355 IY = the first command frame
C $8359 Was the previous line left with an unfinished command (e.g. waiting for "which key?" to be answered)?
C $835D Either way, clear that flag now - this line's typing settles the question
C $835E If it WAS waiting, skip straight to picking up where it left off, rather than starting a fresh frame
C $8361 Find the action and its objects for this frame
C $8364 Found: carry it out below
C $8366 Not found (the command made no sense): give up on the rest of this line too
C $836B Found: would the action actually succeed? (a dry run, changing nothing)
C $836E No: let the action's own handler explain why, rather than saying nothing at all
C $8371 Yes: mark this as really happening now, not just a trial
C $8376 Report it in words ("you take the sword.")
C $8379 Carry it out
C $837C End the turn: let every other character act, and the timers tick
C $837F Is an ALL command still working through more objects?
C $8383 Yes: go round again for the next one
C $8385 How many more command frames are left on this line?
C $838C None left: the whole line is finished
C $838D Step on to the next frame (24 bytes lower, since frames are built downwards)
C $8392 Is this frame only an ALL EXCEPT exception, with no command of its own?
C $8396 Yes: skip over it and look at the one after
C $8398 Otherwise carry it out
c $839A Clear the command execution work area
D $839A Clears the 17 bytes at #R$832E and $B5F2.
C $839A A = 0
C $839B Print any replies in the lower (input) window for now, not the story window
C $839E 17 bytes of work area to clear
C $83A3 Clear it
c $83A7 Find the action and objects for a command
D $83A7 The target ($B5D9) and instrument (#R$B5DA) are set to $FF (none) and the work area is cleared. #R$858F then finds the action table entry that matches the frame's verb, particle and preposition; if none does, the routine returns with Z set.
D $83A7 The action number (1-59) is worked out from the entry's address and stored in #R$B5D8. The flags of the entry (#R$8569) say whether the action needs a target and an instrument (bits 3 and 2 of $B60D). If it needs neither, the routine is done. Otherwise #R$8405 searches for suitable objects, trying each candidate with a dry run. If the objects cannot be decided, #R$87AD deals with it (asking 'which key?', saying 'I do not see the key', and so on). With ALL, #R$8464 moves on to the next object.
R $83A7 Output:F Z set if the command could not be matched
C $83A7 No instrument or target chosen yet
C $83AF Clear the work area
C $83B2 Find the action table entry that matches this frame's verb and words
C $83B5 No such action exists: give up
C $83B6 Work out the action's own number...
C $83C2 ...by counting how many 8-byte entries lie before it in the action table
C $83CA Remember the action number
C $83CD ...(kept a second time, so #R$A79F can read Bard's own last order from it later)
C $83D0 Remember the action table entry itself
C $83D4 Work out what this action needs: a target, an instrument, whether it works in the dark
C $83D7 Start searching for a target
C $83DA For now, everything is only a trial: nothing really happens yet
C $83DE Does this action need a target, an instrument, or both?
C $83E3 Neither: the action can go ahead with no objects at all
C $83E5 Is this whole command an ALL?
C $83EB Is only a single candidate wanted, rather than every matching object?
C $83F1 Search for a workable target and instrument
C $83F4 None found, or more than one possible: explain why, or ask "which key?"
C $83F7 Is this an ALL command, with more objects still to try?
C $83FB No: this one candidate is the whole answer
C $83FD Yes: is there another object ALL should also apply to?
C $8400 If so, search again with it in mind
C $8402 Make A non-zero...
C $8404 ...telling the caller a workable command was found
c $8405 Search for a target and an instrument
D $8405 Tries the objects that fit the noun phrases of the command, in two nested loops: for each candidate target (#R$86BC) it tries each candidate instrument (#R$8708). For every combination, a dry run of the action (#R$84DE, which runs the action with $B5EB clear) says whether it would work. The first combination that works is kept. Counts of the candidates are kept at $8330-$8332 so that #R$87AD can tell whether there were none, one or several.
D $8405 When only one candidate is allowed ($8344), the search stops after the first.
R $8405 Output:F Z reset if no workable combination was found
C $8405 Find the next candidate target for which the action would actually work
C $8408 None found (or several already tried): go and see how many there were in total
C $840A Did EXACTLY one candidate target turn out to work?
C $840F No (none, or more than one): give up, leaving the caller to explain why
C $8410 Yes: A = that one candidate
C $8413 It becomes the target
C $8416 Start searching for an instrument too
C $8419 Does this action even need one?
C $841C Yes: go and look for it
C $841E No: we are done, with just the target settled
C $841F No workable target this time: count how many candidates fitted the words at all
C $8423 Does the action need an instrument?
C $8426 No: try this same target candidate again, ignoring the instrument entirely
C $8428 Yes: start searching for an instrument to go with THIS candidate
C $842B Find the next candidate instrument for which it would work
C $842E None: go back and try a different target instead
C $8430 Found one - but does the caller only want a single candidate overall (rather than checking for ambiguity)?
C $8434 Yes: stop here, with this pairing as the answer
C $8435 No: remember this target as one that works...
C $843B ...and count it
C $843F ...then go on looking for more targets, to see whether the choice is ambiguous
C $8441 Try the action with just this target and no instrument
C $8444 Treat the result exactly as if an instrument search had just finished
C $8446 Look for another candidate instrument for the current target
C $8449 None left: count how many there were in total
C $844B Did EXACTLY one candidate instrument work?
C $8450 No: give up, leaving the caller to explain why
C $8451 Yes: A = that one candidate
C $8454 It becomes the instrument
C $8458 Found another workable instrument: remember it...
C $845E ...and count it
C $8462 ...then keep looking, to see whether the choice is ambiguous
c $8464 ALL: find the next object
D $8464 For a command with ALL, looks through the frames that follow (the exceptions, marked with bit 6) and checks that the target found is not one of the objects excluded by EXCEPT. Returns with Z reset if it is excluded.
C $8464 Save IY, DE and HL
C $8468 Step back to the frame BEFORE the current one (24 bytes higher), since ALL EXCEPT exceptions are listed there
C $846D Is that an ALL EXCEPT exception frame?
C $8471 No (we have run out of exceptions): give up, there is nothing more to try
C $8473 Otherwise search every object...
C $8477 IY = the exception's own words
C $847E ...for one that fits THIS exception
C $8483 None does: try the exception before that one
C $8485 Found one - but is it the very object we were about to use as the target?
C $8489 No: that is fine, look for another match to this exception instead
C $848B It IS the one we were about to use: reject it (make A non-zero, so the caller skips this object)
C $848D Restore HL, DE and IY
c $8492 Start the search for targets
D $8492 Sets up the table (objects or rooms) in which the target will be searched for (#R$84BD), according to bits 2-3 of #R$B60E, and saves the starting position in $833F. Does nothing when repeating an ALL command.
C $8492 Is an ALL command already partway through its list of objects?
C $8496 Yes: do not restart the search - carry straight on from where it was
C $8497 A = the action's second set of flags
C $849A Shift its "which table" bits down...
C $849C ...and choose the object index, or the character-only/object-only index, accordingly
C $849F Is the target actually meant to be a room?
C $84A3 If so, search the actor's own room's exits instead of the object table
C $84A6 Remember where the search has got to
c $84AB Start the search for instruments
D $84AB As #R$8492, for the instrument: the position is kept at $8341.
C $84AB A = the action's second set of flags
C $84AE Choose the object index, or the character-only/object-only index
C $84B1 Is the instrument actually meant to be a room?
C $84B5 If so, search the actor's own room's exits instead
C $84B8 Remember where the search has got to
c $84BD Choose the object table to search
D $84BD Sets IX to the object index at #R$BF53 if the low two bits of A are 0, or to $BF50 (three bytes earlier, which makes the search start with a dummy entry) otherwise.
C $84BD IX = the ordinary object index...
C $84C1 Do the flags call for characters only, or objects only?
C $84C3 Neither: the ordinary index is fine as it is
C $84C4 Otherwise start one entry earlier, so the very first search step lands on the true first entry
c $84C9 Does the action need an instrument?
D $84C9 Returns with Z reset if the action needs an instrument (bit 2 of $B60D) that has not yet been given. If bit 1 of $B60D is set, the instrument may be left out, and the routine returns with Z set.
C $84C9 A = the action's main flags
C $84CC Does it need an instrument at all?
C $84CE No: nothing more to check
C $84CF Yes - has a genuine instrument noun actually been named?
C $84D4 It has: an instrument is definitely needed
C $84D5 No instrument was named - but may this action be used without one?
C $84D9 No, it may not: an instrument really is required
C $84DC Yes, it may: no instrument is required after all
c $84DE Try the action (dry run)
D $84DE Runs the action with #R$946F and returns with Z set if it would not work (#R$B5EC is 0). Called while $B5EB is 0, so nothing actually happens and nothing is printed.
C $84DE Carry out the action, with nothing yet really happening
C $84E1 Did it say it would work?
c $84E6 Would this action work? (for a character)
D $84E6 Used when a character is deciding what to do (#R$976C): works out, for the action in #R$B5D8 and the objects in $B5D9 and #R$B5DA, whether the action would succeed, without printing anything and without disturbing the player's command. The work area pointer at $833F is saved and restored. Returns with Z set if the action would not work.
C $84E6 Save every register this uses
C $84ED Save where the player's own target search had got to
C $84F1 IX = the action table entry for the action being tried
C $84FA Clear the work area
C $84FD Work out this action's own flag bytes
C $8500 Decode them
C $8503 A = the target the character wants to try
C $8507 Copy its words into the target work area, as if it had been typed
C $8510 Do the same for the instrument
C $851D Start the object search fresh, in case a room search is needed instead
C $8520 For now, this is only a trial
C $8524 Does the action need a target or an instrument at all?
C $8529 It does: check it properly below
C $852B It needs neither: just try it directly
C $8534 It does need objects: only accept a single, unambiguous match
C $8539 Search for a workable target and instrument
C $853C Found: success
C $853E Not found: failure
C $8543 Whatever the player was doing, it really is happening again now
C $8548 Restore the player's own target-search position...
C $854C ...and every other saved register
c $8554 Copy an object's or a room's words
D $8554 If B is not $FF, copies the six bytes of words (noun and two adjectives) of object B (or of room B, if A is non-zero) to DE.
C $8554 Was there actually no object given at all ($FF)?
C $8555 If so, there is nothing to copy
C $8556 Restore B
C $8557 Is the thing being named actually a room, rather than an object?
C $855B An object: HL = its own words
C $8560 A room: HL = its own name words
C $8563 Copy all 6 bytes - the noun and its two adjectives
c $8569 Decode the flags of the action
D $8569 Turns the flag nibbles of the action table entry (see #R$70EA) into separate variables: $B601 (bit 6 of #R$B60E: the action is allowed in the dark), $B5FF (bit 0 of $B60D: the objects need not be within reach), $B5EF (bit 7: the target is a room rather than an object) and $B5F0 (bit 6: the instrument is a room).
C $8569 A = the action's second set of flags
C $856C Is it allowed in the dark?
C $8571 A = the action's main flags
C $8575 Do the objects need not be within reach?
C $857B Is the target actually a room, rather than an object?
C $8584 Is the instrument actually a room too?
c $858F Find the action for a command
D $858F Collects the verb of the current frame and up to two prepositions from its noun phrases into $8349-#R$834E, and then searches the action table (#R$AA47) for an entry with the same verb and prepositions (#R$71EA). If one is found, #R$8614 sorts out which noun phrase is the target and which the instrument, and the routine returns with Z reset.
D $858F If none is found there are two cases. If the verb was right but the other words were wrong ($B5D0 set), 'I do not know the verb ...' is printed (#R$8895). If the verb has no actions at all (WAIT, JUMP, SING, SMILE and many others), the game prints 'you wait. time passes...' with the verb substituted (#R$AC97), and a turn goes by. This is how all the verbs that do nothing get their reply.
C $858F Save the caller's IY, the current frame
C $8591 HL = the frame's own verb...
C $8597 Is the ALL bit (bit 7) set on it?
C $859A Remember whether this whole command is an ALL
C $859D Strip that bit back out of the verb itself
C $859F Keep the plain verb
C $85A2 Clear the four preposition slots that follow it
C $85AC Up to two prepositions to pick out from the two noun phrases
C $85AE First noun phrase's first preposition slot...
C $85B0 ...pick it up, if there is one
C $85B3 Second noun phrase's first preposition slot...
C $85B5 ...pick it up too
C $85B8 First noun phrase's second preposition slot...
C $85BD Second noun phrase's second preposition slot...
C $85C2 The verb has not yet been shown to match anything
C $85C6 HL = the verb and prepositions just collected
C $85C9 DE = 8, the size of one action table entry
C $85CC IX = the start of the action table
C $85D0 IY = the entry being compared
C $85D4 Does this entry match the verb and words collected above?
C $85D7 Yes: settle which words are the target and which the instrument, below
C $85D9 No: move on to the next entry
C $85DB Have we reached the end of the table (an entry of all zeros)?
C $85E1 Not yet: try this next entry
C $85E3 End of the table, with no match: restore IY
C $85E5 Did the verb itself match anything, just with the wrong words?
C $85E9 Yes: "I do not know the verb ..."
C $85EC No: this verb has no actions at all - push it as the message parameter...
C $85F0 ..."you <verb>. time passes..."
C $85F3 Print it in the lower window, as if the command had succeeded
C $85F7 No ALL is in progress
C $85FA This is really happening, not just a trial
C $85FF Print the message
C $8602 Are we inside a quotation (an order to a character)?
C $8606 If so, that is all - let the caller move on to the next frame as usual
C $8607 Otherwise throw away our own two return addresses...
C $8609 ...and jump straight to ending the turn, as if a real action had just happened
C $860C A match was found: restore IY, the current frame
C $860E Work out which of its noun phrases is the target and which the instrument
C $8611 Make A non-zero...
C $8613 ...telling the caller a matching action was found
c $8614 Assign the noun phrases to target and instrument
D $8614 Decides which of the command's two noun phrases is the target and which the instrument, from the preposition the action expects and bit 5 of the action's flags. The target's words are copied to $8333 and also to $B5D1 (for IT), and the instrument's to $8339. Bit 0 of #R$832E and $832F is set if the phrase actually has a noun.
D $8614 I originally described this as also making 'with the sword hit thorin' work alongside 'hit thorin with the sword'. Testing it in the emulator shows that is not so: putting the prepositional phrase before the plain noun - 'with sword hit thorin', 'hit with sword thorin', 'with large key unlock heavy door' - always fails, usually with a nonsensical result such as 'you cannot attack the short strong sword.' (the sword having been read as the target). Only the ordinary phrasing works reliably. What the crossing test in #R$8614 is actually for is not fully confirmed; it may cover cases within the two fixed phrase slots that ordinary play does not exercise, such as an action whose own table entry could match the two collected prepositions either way round.
C $8614 Did #R$71EA find the two words in the natural order (A=0) or crossed over (A=1)?
C $8615 Natural order: nothing to undo
C $8617 Crossed over: swap the two prepositions collected by #R$858F...
C $8622 ...putting them back the natural way round
C $8625 Work out the action's own flag bytes
C $8628 Was any preposition collected at all?
C $862E Yes, at least one: work out which noun phrase it actually came from, below
C $8630 None at all (e.g. plain TAKE): use the action's own default choice of which phrase is the target
C $8635 Back to the first collected preposition
C $8636 Does it match the SECOND noun phrase's own first preposition?
C $863A No: try matching it against the second phrase's other preposition instead
C $863C Low bytes matched: check the high bytes too
C $8641 A full match: this preposition belongs to the SECOND noun phrase
C $8643 No match after all: back to the low byte
C $8644 Does it match the second phrase's OTHER preposition slot instead?
C $8648 Neither: give up trying to tell which phrase it belongs to
C $864A Matched: check the high byte too
C $864F A = the action's main flags
C $8652 The preposition was NOT shown to belong to the second phrase: use the flags as they are
C $8654 It WAS shown to belong to the second phrase: flip the "which phrase is the target" bit
C $8656 Is the SECOND noun phrase the target?
C $8658 Assume not: (second phrase's noun offset, first phrase's noun offset)
C $865D It is: swap the two offsets round instead
C $8660 Remember the two offsets, for use below
C $8666 A = whichever offset is the TARGET's own noun
C $8667 Copy its words into the target work area...
C $866A ...and mark whether a target noun was actually given
C $8670 The target's own words also become the new meaning of the word IT...
C $867C A = whichever offset is the INSTRUMENT's own noun
C $867F Copy its words into the instrument work area too
C $8682 (Shared code, reached both directly above and by falling in here) save BC
C $8683 C = the frame offset to copy from
C $8686 Save the flag-byte address for a moment
C $8687 HL = the frame, plus that offset...
C $868B Copy 6 bytes: the noun and its two adjectives
C $8690 Was anything actually copied (is any of it non-zero)?
C $8697 Restore the flag-byte address
C $8698 Restore BC
C $8699 Nothing was given: leave the flag alone
C $869A Something was given: record that a noun really was named
c $869D Pick up a preposition from the frame
D $869D Copies the word at offset E of the frame to (HL) and moves HL on, unless it is empty or B (the number of words wanted) has reached 0.
C $869D Does the caller still want any more prepositions from this phrase?
C $869F No: nothing more to do
C $86A2 Save the caller's IY, the current frame
C $86A4 IY = the frame, plus the offset of the preposition slot asked for
C $86A6 Copy its low byte to where HL points...
C $86AB ...then its high byte
C $86AF Step back to the low byte
C $86B0 Was that slot actually empty (both bytes zero)?
C $86B3 Restore the caller's IY
C $86B5 Empty: leave HL where it is, so the next candidate can use the same two bytes
C $86B6 A real preposition was found: one fewer still wanted
C $86B7 Move on past the two bytes just filled
c $86BA Call the routine at IY
D $86BA JP (IY): used to call a search routine chosen at run time (#R$9D2E for objects, #R$9DE9 for rooms).
C $86BA Jump to whichever search routine (object or room) the caller has selected
c $86BC Find the next candidate target
D $86BC Searches for the next object (or room, if $B5EF is set) that fits the target's words, starting from where the last search left off ($833F). Only candidates for which the action would work are returned (#R$86ED). Returns A=$FF when there are no more.
C $86BC Save the caller's IY
C $86BE IX = where the target search last left off
C $86C2 Is the target actually meant to be a room?
C $86C6 Yes: search rooms instead, below
C $86C8 No: IY = the object-search routine
C $86CC A = the action's own filter (characters only, objects only, or anything)
C $86D6 Find the next candidate object for which the action would work
C $86DB Remember where the search has got to
C $86DF Restore the caller's IY
C $86E2 Rooms: IY = the room-search routine instead
C $86E6 Find the next candidate room for which the action would work
c $86ED Find the next candidate target for which the action works
D $86ED Calls the search routine at IY with the target's words, and for each object found, puts it in $B5D9 and tries the action (#R$9436). Stops at the first one for which it would work.
C $86ED HL = the target's own collected words (noun and adjectives)
C $86F0 Search for the next object or room that fits them
C $86F5 None left: give up
C $86F6 Found one: it becomes the target, provisionally
C $86FC Remember that we are still searching (rather than having settled on an answer)
C $86FE Could the action even apply to it at all?
C $8705 No: try the next candidate
C $8707 Yes: this is a workable candidate
c $8708 Find the next candidate instrument
D $8708 As #R$86BC, for the instrument; the position is kept at $8341, and the candidate goes into #R$B5DA.
C $8708 Assume reach does not matter, for now
C $870C Save the caller's IY
C $870E IX = where the instrument search last left off
C $8712 Is the instrument actually meant to be a room?
C $8716 Yes: search rooms instead
C $8718 No: IY = the object-search routine
C $871C A = the action's own filter
C $8724 Find the next candidate object for which it would work
C $8729 Remember where the search has got to
C $872D Restore the caller's IY
C $872F Save the result for a moment
C $8730 Does this particular action say reach does not matter?
C $8738 Restore the result
C $873A Rooms: IY = the room-search routine instead
C $873E Find the next candidate room for which it would work
c $8745 Find the next candidate instrument for which the action works
D $8745 As #R$86ED, for the instrument.
C $8745 HL = the instrument's own collected words
C $8748 Search for the next object or room that fits them
C $874D None left: give up
C $874E Found one: it becomes the instrument, provisionally
C $8754 Remember we are still searching
C $8756 Would the whole action work with this instrument?
C $8759 No: try the next candidate
C $875B Yes: this is a workable candidate
c $875C Prepare to reply to the player
D $875C Sets $B5EB (really do it) and $B5F2 (print in the lower window), ready to print a reply.
C $875C From now on, this really is happening...
C $8761 ...and any reply goes to the lower (input) window
c $8765 Leave the command unfinished
D $8765 Saves the current frame at #R$B8B8 and stores A in $B60A, so that the next thing the player types is used to complete this command. Used after 'which key?' and '... what?'.
C $8765 Remember which situation this is (which key?/what with?/...), for #R$8351 to recognise next time
C $8768 HL = the current frame
C $876B Save the whole 24-byte frame at #R$B8B8 permanently...
C $8771 ...so the next thing the player types can be merged into it (#R$7CC0)
c $8774 Ask "which ...?"
D $8774 When the noun fits more than one object and more than one of them would work, the game asks 'which key?' (#R$ACC0, with the noun pushed as the parameter) and leaves the command unfinished (#R$8765), so that the player's next words - 'the small one', 'curious' - are fitted into it (#R$7CC0).
C $8774 A = the offset of whichever frame slot holds the ambiguous noun
C $8777 HL = the target's own noun word
C $877A Push it as the message parameter
C $877B Leave the command unfinished, waiting for the player to say which one they mean
C $877E "which <noun>?" (falls into #R$8781, which prints it)
c $8781 Print a reply and give up
D $8781 Prints the message at HL in the lower window (#R$875C, #R$72CA) and returns with A=0.
C $8781 Make sure this prints properly, in the lower window
C $8784 Print the message
C $8787 Tell the caller the command could not be completed
c $8789 Decide about the instrument
D $8789 The instrument's counterpart of #R$87AD, using the flags at $832F: no noun given goes to #R$883E ('unlock the door with what?'), a noun that matched nothing widens the search as for the target, and if exactly one instrument would work the action is simply carried out.
C $8789 Was any noun at all given for the instrument?
C $878E No: go and ask "with what?" or say there was nothing suitable
C $8791 Are we still in the middle of searching (rather than already knowing the answer)?
C $879C Not searching yet: go and search properly, exactly as for the target
C $879E Already searched: did EXACTLY one instrument candidate work?
C $87A2 None worked at all: let the action's own handler explain why
C $87A5 (the frame offset, though not needed again here)
C $87A8 A = the instrument's own noun word
C $87AB More than one worked: ask "which one?"
c $87AD Report why the objects could not be decided
D $87AD Called when #R$8405 did not settle on exactly one workable target, to explain why - or to make the best of it. Inside a quotation (an order to a character) it says nothing at all and returns, so characters are not given the player's excuses.
D $87AD If exactly one candidate target would work, the instrument is dealt with instead (#R$8789). Otherwise the target's flags at #R$832E decide:
D $87AD #LIST { No noun was given (#R$8821): the words of the action are pushed and, if nothing suitable could be found at all, 'i see nothing to open' is printed; if there was something, the command is left unfinished (#R$8765) and the game asks 'open what?', so that the next thing typed completes it. } { A noun was given but nothing matching it was found (#R$87EF): the search is widened - first to the rooms leading off this one (#R$9DE9, for commands such as GO INTO), then to every object anywhere (#R$9D2E with the filter set to 2) - so that something the player has named but cannot use is still recognised. If it is found, it is made the target and the action is reported as a failure (#R$7111, 'you cannot open the door'); if not, 'i do not see the door here'. } { Several candidates fit the words: 'which key?' (#R$8774), again leaving the command unfinished. } { Exactly one candidate, or none, but the action would not work with it: the action is carried out for real anyway (#R$87E6), so that its own handler prints the proper reason. } LIST#
C $87AD Are we inside a quotation (an order to a character)?
C $87B1 Yes: say nothing - characters are not given the player's own excuses
C $87B2 Is an ALL command still working through a list of objects?
C $87B6 No: work out what really went wrong, below
C $87B8 Yes: this particular object just did not work out, but others might - abandon it quietly...
C $87B9 ...and go straight on to whatever ALL should try next
C $87BC Did EXACTLY ONE target candidate work, with the problem lying only with the instrument?
C $87C1 Yes: go and sort out the instrument specifically
C $87C3 No: was any noun at all given for the target?
C $87C8 No: go and ask "open what?" or say there was nothing to open
C $87CB Are we still in the middle of searching?
C $87D6 Not searching yet: go and search properly, below
C $87D8 Already searched: how many candidates fitted the words at all?
C $87DC None at all: let the action's own handler explain why
C $87DF More than one: ask "which one?"
C $87E1 Exactly one candidate, but the action still failed - does it even need an instrument?
C $87E4 It does: go and sort that out instead
C $87E6 It does not, or nothing else fits: carry the action out anyway...
C $87E9 ...so its own handler can explain the real reason ("you cannot open the door")
C $87EC Then carry on with the rest of the turn as usual
C $87EF SEARCH PROPERLY: save the noun that was given
C $87F0 IX = the actor's own room's exits
C $87F3 Assume, for now, that the noun names a nearby room
C $87F6 Does any exit lead to a room with that name?
C $87FB Yes: that settles it - use that room
C $87FD No: restore the noun
C $87FE Widen the search to EVERY object in the game, not just nearby ones...
C $8807 ...and note that reach no longer matters
C $8809 Save the noun again
C $880A Search absolutely everywhere for something matching it
C $880F Nothing anywhere fits those words
C $8811 Something was found (a room, or a distant object): use it as the target/instrument...
C $8813 ...and report the action as a failure ("you cannot open the door"), since it is out of reach
C $8816 Truly nothing fits those words anywhere
C $8819 "I do not see the X here."
C $881F The command could not be completed
C $8821 NO NOUN GIVEN FOR THE TARGET: push the action's own words as message parameters
C $8828 "I see nothing to <verb> <particle> <preposition>."
C $882B Was there in fact exactly one possible object, even with no noun named?
C $882F No, none at all: print that message and give up
C $8832 Yes, exactly one: use it anyway, and say which one was chosen
C $8838 "<verb> <particle> <preposition> what?" (one more chance to name it precisely)
c $883E Report a missing or unsuitable instrument
D $883E The instrument's counterpart of the end of #R$87AD. If nothing was found to match the words, 'i see nothing to unlock the door with'. Otherwise the command is left unfinished (#R$8765) and the game asks 'unlock the door with what?' (#R$ACB4), so the player can simply answer 'the key'. The words of the question are pushed by #R$8869.
C $883E Push the action's own particle and preposition, for the "with what?" question
C $8841 A = the target
C $8844 HL = its own words
C $8847 Push them too, so the question can name the target ("unlock the door with what?")
C $8848 Push the action's own words again, this time for the "I see nothing to..." message
C $884F "I see nothing to <verb> the <target> <preposition>."
C $8852 Was there in fact exactly one possible instrument?
C $8856 No, none at all: print that message and give up
C $8859 Yes, exactly one: use it anyway
C $885F "<verb> the <target> <preposition> what?"
c $8865 Push the words of the action for a question (instrument)
D $8865 Enters #R$8869 with A=$28 (the opcode of JR Z) instead of $20 (JR NZ).
C $8865 The opcode for JR Z, for the self-modifying trick below
C $8867 Join the shared code
c $8869 Push the words of the action for a question
D $8869 Pushes the particle and the preposition of the current action (from the action table entry at $834F) on the stack, as parameters for a message such as 'take what?' or 'unlock the door with what?'. Words that should not appear are replaced by 0.
D $8869 This routine modifies itself: it writes A (the opcode for either JR NZ or JR Z) into the two conditional jumps at #R$887F and #R$888E before running them, so that the same code can test flag bits for either the target or the instrument. It then returns by jumping to its return address, which it had to move out of the way under the pushed words (the EX (SP),HL instructions).
C $8869 The opcode for JR NZ instead (the target version)
C $886B Poke it into the first conditional jump below...
C $886E ...and the second, so the very same code can test either the target's or the instrument's own flags
C $8871 IX = the current action table entry
C $8875 HL = its particle word
C $887B Does this action even have a particle worth mentioning?
C $887F (rewritten JR NZ or JR Z, as poked in above)
C $8881 No: push 0 instead, so nothing gets printed for an empty word
C $8884 Push the particle (or 0) as a message parameter
C $8886 HL = the action's own preposition word
C $888C Does this action have a preposition worth mentioning?
C $888E (rewritten JR NZ or JR Z)
C $8890 No: push 0 instead
C $8893 Push the preposition as a message parameter
C $8894 Return to whichever routine called this one
c $8895 "I do not know the verb ..."
D $8895 Pushes the verb, particle and preposition the player used and prints 'I do not know the verb "..."' (#R$ACA4): the verb is known, but not with those words (for example 'take through the door').
C $8895 Push the second collected preposition...
C $8899 ...and the first...
C $889D ...and the verb itself, as message parameters
C $88A1 "I do not know the verb "..."."
C $88A4 Print it and give up
c $88A7 Address the orders to a character
D $88A7 After SAY TO someone "...", the commands inside the quotation are waiting in the orders buffer (#R$B628), each in a slot marked $FF. This routine gives the first A of them to the character being spoken to, by writing the character's object number ($B5D9) into the slots' first bytes. Any further waiting orders (more than the character will accept) are thrown away by setting their first byte to 0.
C $88AB B = the number of orders the character will take
C $88AC C = the number of orders waiting
C $88B0 More wanted than there are?
C $88B3 Then take them all
C $88B4 C = the number left over
C $88B7 IX = one slot before the orders buffer
C $88BB 25 bytes per slot
C $88BE Any to hand over?
C $88C0 No
C $88C2 Find the next waiting order (marked $FF)
C $88CB Address it to the character
C $88D1 Next
C $88D3 Now the left-over orders:
C $88D6 None
C $88D8 find each one...
C $88E1 ...and throw it away
c $88EC Find an order for the current actor
D $88EC Searches the eight 25-byte slots of the orders buffer (#R$B628) for one addressed to the current actor (#R$B5DB). Returns with Z set and HL pointing at the slot if one is found.
R $88EC Output:F Z set if found
R $88EC HL Order slot
C $88EC HL = the start of the orders buffer
C $88EF DE = 25, the size of one order slot
C $88F2 A = the current actor
C $88F5 Eight slots to check
C $88F7 Is this slot addressed to the actor?
C $88F8 Yes: found it, with HL pointing at the slot
C $88F9 No: move on to the next slot
C $88FC None found
c $88FD Does the actor have an order waiting?
D $88FD As #R$88EC, preserving BC, DE and HL.
C $88FD Save HL, DE and BC
C $8900 Search for an order (only the flags this leaves behind matter here)
C $8903 Restore BC, DE and HL
c $8907 Obey an order
D $8907 Called with A non-zero by #R$976C when a character has been given an order by the player. The order's slot is found (#R$88EC) and freed, and the 24-byte frame stored in it is matched to an action and objects exactly as if the player had typed it (#R$83A7), but with the quotation flag set so that nothing is printed while this happens. If the action would work (#R$84DE), the character will carry it out on its turn; if not, all the character's orders are cancelled (#R$894D).
D $8907 With A=0 it only frees the slot.
R $8907 Input:A 0 to discard the order
C $890E C = 0 to discard the order, 1 to obey it
C $890F HL = the actor's order slot
C $8912 Free the slot
C $8914 HL = the command frame stored in it
C $8915 Discarding?
C $8917 No: obey it
C $8919 Return with Z reset
C $891B Return HL (the frame) to the caller
C $8924 IY = the frame
C $8927 Pretend to be inside a quotation so nothing is printed
C $8930 Find the action and objects for the order, as if the player had typed it
C $8934 Back to normal
C $893D It made no sense: give up
C $893F Would it work?
C $8942 Yes: return with Z reset; the character will do it
C $8944 No: the character forgets all its orders
C $894A Return with Z set
c $894D Cancel a character's orders
D $894D Clears every slot of the orders buffer (#R$B628) that is addressed to character A. Used when a character cannot carry out an order and when a character dies (#R$96DD).
R $894D Input:A Character
C $894D Save HL, DE and BC
C $8950 HL = the start of the orders buffer
C $8953 DE = 25, the size of one slot
C $8956 Eight slots to check
C $8958 Is this slot addressed to character A?
C $8959 No: leave it alone
C $895B Yes: free the slot
C $895D Move on to the next slot
C $8960 Restore BC, DE and HL
s $8964
c $8965 Draw the picture of a room, if it has one
D $8965 Looks the room A up in the picture index at #R$CC00. If there is a picture, it is drawn by #R$8985. The result of the search is stored at #R$8964, where #R$95B9 later looks to decide whether to wait for a key after the picture has been drawn.
R $8965 Input:A Room number
C $8965 Save every register this uses
C $896B IX = the picture index
C $896F Does room A have a picture?
C $8972 Remember the answer for #R$95B9 to check afterwards
C $8975 HL = the picture's own address, if there is one
C $897B If there is, draw it
C $897E Restore every saved register
c $8985 Draw a picture
D $8985 Interprets the picture data at HL. Pictures are drawn with vector commands, not stored as bitmaps, which is how 22 full-width pictures fit into a few kilobytes. The first two bytes set the border colour and the colour of the picture area, which is cleared (#R$8BE9); if Bilbo is in the dark the picture is not drawn at all.
D $8985 The picture area is the top 128 pixel rows of the screen. The drawing position is kept in D (x, 0-255) and E (y, 0-127, measured upwards from the bottom); it starts in the middle, at (127,63). Then each command byte is one of:
D $8985 #TABLE(default) { =h Byte | =h Command } { $00 | end of picture } { $08 | move: the next two bytes are the new x and y } { %1dddssss, %sslllll | line: bits 0-2 give the direction, bits 3-6 and the top two bits of the next byte give the slope, and the rest of that byte the length; drawn by #R$8B2F } { %01000ccc, x, y | flood fill from (x,y) with ink colour ccc (#R$8A4F) } { %00100ccc, address, runs... | paint attribute cells with paper colour ccc: starting at the given attribute address, each following byte moves up, right, down or left (bits 0-1) a number of cells (bits 2-7, plus 1), painting as it goes; ended by $FF } TABLE#
D $8985 Lines and fills also set the ink colour of every attribute cell they touch (#R$8B93), so colour is applied as the picture is drawn. Anything else is ignored.
D $8985 A picture normally ends with a 0. Two pictures (rooms 13 and 5) instead end with a move command whose coordinate bytes are the colour bytes of the next picture in memory, so they go on to draw that picture as well (see #R$E02C and #R$E142).
R $8985 Input:HL Picture data
C $8985 Save the registers the caller uses
C $8988 IY = the picture data
C $898D Set the border, clear and colour the picture area (or give up if Bilbo is in the dark)
C $8990 Start the pen in the middle: x = 127...
C $8992 ...y = 63
C $899A NEXT COMMAND: fetch it
C $899D Zero?
C $899E Yes: the end of the picture
C $89A3 $08: move the pen?
C $89A5 No
C $89A7 D = the new x
C $89AC E = the new y
C $89B1 Next command
C $89B3 Bit 7 set: a line?
C $89B5 No
C $89B8 C = the direction (bits 0-2)
C $89BB B = bits 3-6 of the first byte...
C $89C0 L = the length (bottom six bits of the second byte, plus 1)
C $89C7 ...combined with the top two bits of the second byte to give the slope
C $89D2 (plus 1)
C $89D3 Draw the line
C $89D6 Next command
C $89D8 Bit 6 set: a flood fill?
C $89DA No
C $89DC A = the colour
C $89DE Keep the pen position
C $89DF D = x of the point to fill from
C $89E4 E = y
C $89E9 Fill
C $89EC Restore the pen position
C $89ED Next command
C $89F0 Bit 5 set: paint character cells?
C $89F2 No: ignore the byte
C $89F5 C = the colour, shifted into the paper bits
C $89FE HL = the attribute address (high byte first)
C $8A08 Next run byte
C $8A0D $FF ends the runs
C $8A12 E = the direction (0 up, 1 right, 2 down, 3 left)
C $8A15 B = the number of cells (bits 2-7, plus 1)
C $8A1C A = the cell's ink colour, shifted into the paper position
C $8A22 Would the ink be the same as the new paper?
C $8A25 Yes: use the complementary ink so the drawing stays visible
C $8A27 Shift the ink back down
C $8A2A Combine with the new paper...
C $8A2B ...and store the attribute
C $8A2C Move one cell in the run's direction:
C $8A2E up,
C $8A32 right,
C $8A36 down,
C $8A3A or left
C $8A3D Next cell of the run
C $8A3F Next run
C $8A44 Next command
C $8A47 Restore the registers
s $8A4D
c $8A4F Flood fill
D $8A4F Fills the area around the point (D,E) with ink colour A (kept at #R$8C2C for #R$8B93). It is a scan-line fill: from the starting point it moves left to the edge of the area, then works rightwards along the row, setting each pixel. At every pixel it looks at the pixel above and the pixel below: where an unfilled stretch begins in the row above or below, that position is pushed on the stack as a 'seed' to be filled later. The flags at #R$8A4D (above) and $8A4E (below) stop it pushing a seed for every pixel of the same stretch. When the row is done, the next seed is popped and the process repeats, until the marker $0080 pushed at the start comes back off the stack.
D $8A4F Because each row is filled from its left-hand end, and seeds are only pushed at the starts of stretches, the fill needs very little stack even for large areas.
R $8A4F Input:A Colour
R $8A4F D x
R $8A4F E y
C $8A4F Save the fill colour
C $8A54 Push the end marker (a y value of $80 is impossible)
C $8A58 Is the pixel at (D,E) set?
C $8A5B Yes: we have found the left-hand boundary
C $8A5D No: move left
C $8A60 Keep going until a set pixel or the edge
C $8A62 At the left edge of the picture: start here
C $8A64 Colour the boundary pixel...
C $8A67 ...and step right onto the first empty pixel
C $8A6A Not yet tracking a stretch above or below
C $8A70 Look at the pixel above
C $8A75 At the top edge: nothing to do above
C $8A77 Is it set?
C $8A7C Set: not part of the area
C $8A7E Empty. Already tracking this stretch above?
C $8A82 Yes: no new seed
C $8A84 No: push it as a seed
C $8A85 ...and start tracking
C $8A88 Back down to the current row
C $8A8C Remember whether we are tracking above
C $8A8F Look at the pixel below
C $8A94 At the bottom edge: nothing to do below
C $8A96 Is it set?
C $8A9B Set: not part of the area
C $8A9D Empty. Already tracking this stretch below?
C $8AA1 Yes: no new seed
C $8AA3 No: push it as a seed
C $8AA4 ...and start tracking
C $8AA7 Back up to the current row
C $8AAB Remember whether we are tracking below
C $8AAE Fill this pixel
C $8AB1 Step right
C $8AB4 At the right edge: this row is done
C $8AB6 Is the next pixel set?
C $8AB9 No: carry on along the row
C $8ABB Yes: colour the boundary pixel too
C $8ABE Pop the next seed
C $8ABF Is it the end marker?
C $8AC2 No: fill from there
C $8AC4 Done: reset the drawing colour
c $8ACC Test a pixel
D $8ACC Returns with Z reset if the pixel at (D,E) is set.
R $8ACC Input:D x
R $8ACC E y
C $8ACD HL = the screen byte, A = the bit for the pixel
C $8AD0 Z reset if the pixel is set
c $8AD3 Move an attribute address up a row
D $8AD3 Subtracts 32 from HL, unless that would move it above the attribute file ($5800), in which case HL is unchanged. Used when painting colours (#R$8985).
C $8AD3 Save AF and DE
C $8AD5 DE = 32, the width of one attribute row
C $8AD9 Move HL up a row
C $8ADB Did that go above the top of the attribute file?
C $8AE0 If so, undo the move: stay on the top row
C $8AE1 Restore DE and AF
c $8AE4 Move an attribute address down a row
D $8AE4 Adds 32 to HL, unless that would move it off the bottom of the attribute file.
C $8AE4 Save AF and DE
C $8AE6 DE = 32, the width of one attribute row
C $8AE9 Move HL down a row
C $8AEA Did that go past the bottom of the attribute file?
C $8AEF If so, undo the move: stay on the bottom row
C $8AF2 Restore DE and AF
c $8AF5 Move an attribute address left
D $8AF5 Decreases HL, unless that would move it out of the attribute file.
C $8AF5 Save AF
C $8AF6 Move HL one cell left
C $8AF7 Did that go off the left edge of the attribute file?
C $8AFC If so, undo the move: stay put
C $8AFD Restore AF
c $8AFF Move an attribute address right
D $8AFF Increases HL, unless that would move it out of the attribute file.
C $8AFF Save AF
C $8B00 Move HL one cell right
C $8B01 Did that go past the right edge?
C $8B06 If so, undo the move: stay put
C $8B07 Restore AF
c $8B09 Move the drawing position up
D $8B09 Increases E (y), unless it would go past 127. Returns with Z set if the edge was reached. A is preserved.
C $8B09 y + 1
C $8B0A Past 127?
C $8B0C No: return with Z reset
C $8B0E Yes: undo it...
C $8B10 ...and return with Z set (A preserved)
C $8B14 Reset Z (A preserved)
c $8B18 Move the drawing position down
D $8B18 Decreases E, unless it would go below 0. Returns with Z set at the edge.
C $8B18 y one lower
C $8B19 Did that go below 0, off the bottom of the picture area?
C $8B1B No: continue at the shared ending (reused from #R$8B09)
C $8B1D Yes: undo the move
C $8B1E Z stays set, telling the caller the edge was reached
c $8B1F Move the drawing position right
D $8B1F Increases D (x), unless it would go past 255. Returns with Z set at the edge.
C $8B1F x one higher
C $8B20 Still within 0-255: done
C $8B21 Wrapped past 255: undo the move
C $8B22 Save A for a moment...
C $8B23 ...set Z, to tell the caller the edge was reached...
C $8B24 ...then restore A
c $8B26 Move the drawing position left
D $8B26 Decreases D, unless it would go below 0. Returns with Z set at the edge.
C $8B26 x one lower
C $8B27 Save A for a moment
C $8B28 Did x wrap below 0 (become 255)?
C $8B2B Restore A
C $8B2C Still within range: done
C $8B2D Wrapped: undo the move
C $8B2E Z is set, telling the caller the edge was reached
c $8B2F Draw a line
D $8B2F Draws a line of L+1 pixels from (D,E) in one of eight directions (bits 0-2 of C). Bit 0 says whether the line is mostly vertical or mostly horizontal; bits 1 and 2 give the vertical and horizontal directions. The line moves one pixel along its main direction every step, and one pixel along the other direction every B steps, so lines have slopes of 1, 1/2, 1/3 and so on rather than arbitrary angles. Drawing stops early at the edge of the picture area.
R $8B2F Input:C Direction
R $8B2F B Steps per sideways move
R $8B2F L Length
R $8B2F D,E Start
C $8B2F Mostly vertical (bit 0 set)?
C $8B31 Yes
C $8B33 MOSTLY HORIZONTAL:
C $8B35 Plot the pixel
C $8B38 Leftwards (bit 2)?
C $8B3C Step left
C $8B3F Stop at the edge
C $8B43 Step right
C $8B46 Stop at the edge
C $8B48 Time for a vertical step?
C $8B49 Not yet
C $8B4B Downwards (bit 1)?
C $8B4F Step down
C $8B52 Stop at the edge
C $8B56 Step up
C $8B59 Stop at the edge
C $8B5B Reload the step counter B
C $8B5D One pixel fewer to draw
C $8B5E Loop
C $8B63 MOSTLY VERTICAL:
C $8B65 Plot the pixel
C $8B68 Downwards (bit 1)?
C $8B6C Step down
C $8B6F Stop at the edge
C $8B73 Step up
C $8B76 Stop at the edge
C $8B78 Time for a sideways step?
C $8B79 Not yet
C $8B7B Leftwards (bit 2)?
C $8B7F Step left
C $8B82 Stop at the edge
C $8B86 Step right
C $8B89 Stop at the edge
C $8B8B Reload the step counter
C $8B8D One pixel fewer to draw
C $8B8E Loop
c $8B93 Plot a pixel
D $8B93 Sets the pixel at (D,E) and gives its attribute cell the ink colour held at #R$8C2C, keeping the cell's paper colour. If the ink would be the same as the paper (and so invisible), the ink is changed to its complement (XOR $38 before shifting).
C $8B94 HL = the screen byte, A = the pixel's bit
C $8B99 Work out the attribute address from the screen address
C $8BA2 Keep only the cell's paper colour
C $8BA6 A = the drawing colour, in the paper position
C $8BAC Same as the paper?
C $8BAF Yes: use its complement so it shows
C $8BB1 Back into the ink position
C $8BB4 Combine with the paper...
C $8BB5 ...and store it
C $8BB7 A = the pixel's bit
C $8BB8 Set the pixel
c $8BBC Get the screen address of a pixel
D $8BBC Converts the picture coordinates (D,E) to a screen address HL and a bit mask A. The y coordinate is turned upside down (127-E), because pictures are drawn with y measured upwards, and then split up in the usual way for the Spectrum's interleaved screen layout.
R $8BBC Input:D x
R $8BBC E y
R $8BBC Output:HL Screen address
R $8BBC A Bit mask
C $8BBC Turn y upside down: row = 127 - y
C $8BC0 The low three bits of the row are the pixel line within the character...
C $8BC2 ...in the display file at $4000
C $8BC5 Bits 6-7 of the row choose the third of the screen
C $8BCD Bits 3-5 choose the character row within the third
C $8BD3 x / 8 is the column
C $8BDB x AND 7 is the bit within the byte
C $8BE1 Start with bit 0 and rotate right x AND 7 + 1 times, giving $80 for x AND 7 = 0
c $8BE9 Start a picture: clear the picture area
D $8BE9 Reads the picture's first two bytes: the border colour, which is set straight away, and the attribute for the picture area. The top two thirds of the screen ($4000-$4FFF) are cleared, and the 512 attributes of that area are filled with the picture's colour.
D $8BE9 If Bilbo is in the dark (#R$954D), the border and attributes are set to black instead, and the drawing is abandoned: the return address is discarded and the routine jumps to the end of #R$8985.
C $8BE9 Is Bilbo in the dark? (carry set if so)
C $8BEC Keep the answer in the alternate AF
C $8BED A = the border colour (first byte of the picture)
C $8BF3 Not dark: keep it
C $8BF5 Dark: black border
C $8BF9 Set the border
C $8BFE Clear the top two thirds of the screen ($4000-$4FFF)
C $8C0B 512 attributes from $5800
C $8C14 A = the picture's colours (second byte)
C $8C1A Not dark: keep them
C $8C1C Dark: black on black
C $8C20 Fill the attributes
C $8C26 Not dark?
C $8C27 Then return and draw the picture
C $8C28 Dark: discard the return address...
C $8C29 ...and skip the drawing altogether
b $8C2C Drawing colour
D $8C2C The ink colour used by #R$8B93 when plotting, set by the flood fill (#R$8A4F) and reset to 0 afterwards.
B $8C2C,1,1
c $8C2D LOOK
D $8C2D Describes the room the actor is in (#R$958E). The dry-run check (#R$9C99) comes first, so trying LOOK costs nothing.
C $8C2D Dry run? Then stop here: LOOK always works
C $8C30 IX = the current actor's own record
C $8C34 A = the actor's own room
C $8C37 Describe that room, in full
c $8C3A Is the actor carrying the target?
D $8C3A Returns normally if the actor is carrying the target (#R$9BCD). If not, it prints 'you are not carrying it.' and returns to the caller's caller, so the action goes no further.
C $8C3A Is the target held by the current actor?
C $8C3D Yes: carry on with whatever the caller wanted to do next
C $8C3E No: throw away the caller's own return address...
C $8C3F ..."you are not carrying it."
C $8C42 ...and print that instead, ending the action here
c $8C45 DROP
D $8C45 The actor must be carrying the target (#R$8C3A). If the target is tied to the rope (it is 'held by' object 18), it is the rope that is dropped.
D $8C45 Dropping means setting the object's holder to $FF, which leaves it in the room. But objects with bit 1 of their flags set are liquids or things that do not survive being put down: they 'evaporate', which means their location is set to 0 (nowhere) and a message says so. The objects that behave like this are numbers 9, 20 (the wine), 21, 22, 23, 24 and 42.
C $8C45 Is the actor carrying it? (If not, "you are not carrying it.")
C $8C48 Dry run? Then stop: it would work
C $8C4B IX = the object's record
C $8C4F Is it tied to the rope (object 18)?
C $8C54 No
C $8C56 Yes: it is the rope that gets dropped
C $8C5A Nobody holds it now: it lies in the room
C $8C5E Does it evaporate?
C $8C62 No: done
C $8C63 Yes: it goes nowhere
C $8C67 "<object> evaporates."
C $8C6A Push the object's name as the parameter
c $8C75 TAKE OUT OF
D $8C75 The containers' handler for TAKE X OUT OF Y (the goblins' cache, the cupboard, the chest and the boat). The target must actually be inside the container (#R$9BD3 checks the holder chain), or 'the X is not in the Y.' Then it is taken like anything else (the rest of #R$8CC8, reached at #R$8CD1).
C $8C75 A = the target of the current command
C $8C78 HL = the address holding the instrument (the container we are meant to take it out of)
C $8C7B Is the target actually inside that container? (reuses the tail of #R$9BCD, comparing against whatever holder number sits at HL)
C $8C7E "the X is not in the Y."
C $8C81 If it is not inside, say so and stop
C $8C84 Otherwise take it just like an ordinary TAKE (joins the rest of #R$8CC8)
c $8C86 Can the actor lift the target?
D $8C86 Checks the weights for TAKE and CARRY. Byte 3 of an object record is its weight. The target's weight, plus the weight of everything it contains (#R$9C42), must not exceed the actor's lifting capacity (byte 3 of the actor's record), or 'the X is too heavy to lift.' And the actor's capacity minus what they are already carrying minus the new load must not go negative, or 'you are carrying too much.' Doors and other multi-place objects (#R$91B0), and objects fixed in place, cannot be taken at all.
C $8C86 IX = the target's record
C $8C8A A = the weight of everything in the target...
C $8C90 ...plus its own weight
C $8C95 (capped at 255)
C $8C97 B = the total
C $8C98 IY = the actor's record
C $8C9C A = how much the actor can lift
C $8C9F Can it lift the load?
C $8CA0 "the X is too heavy to lift."
C $8CA3 No: say so
C $8CA6 Subtract what the actor is already carrying
C $8CAF Still not negative: it can be taken
C $8CB2 "you are carrying too much."
C $8CB5 Print the message instead of returning...
C $8CB7 ...and stop the action
C $8CBA Is the target an ordinary object?
C $8CBD No (a door, say): it cannot be taken
C $8CBF Objects with bit 1 set ("evaporates") can be taken; others...
C $8CC5 ...(this path) cannot: report failure
c $8CC8 TAKE and CARRY
D $8CC8 If the actor already has the target: 'you are already carrying the X.' Otherwise, after the weight checks (#R$8C86), the actor becomes the object's holder (byte 1 of its record). Taking the rope also takes anything tied to it.
C $8CC8 Is the actor already holding the target?
C $8CCB "you are already carrying the X."
C $8CCE Yes: say so
C $8CD1 Check the weights
C $8CD4 Dry run? Then stop: it would work
C $8CD7 The actor becomes the target's holder
C $8CDD Was it the rope (object 18)?
C $8CE2 No: done
C $8CE3 Yes: whatever is tied to the rope goes with it
b $8CEA Points for visiting rooms
D $8CEA Room number and points (a word, in tenths of a percent) for #R$8D19, which adds them to the score the first time Bilbo enters the room. Terminated by $FF.
D $8CEA #TABLE(default) { =h Room | =h Points } { 4 lonelands | 2.5% } { 7 trolls' cave | 5% } { 11 narrow place | 2.5% } { 22 Beorn's house | 2.5% } { 13 goblins' dungeon | 7.5% } { 65 dark stuffy passage | 5% } { 27 smothering forest | 2.5% } { 28 levelled elvish clearing | 2.5% } { 31 dark dungeon | 5% } { 34 long lake | 10% } { 38 dale valley | 2.5% } { 42 side door | 2.5% } { 43 smooth straight passage | 5% } { 41 lower halls | 20% } TABLE#
D $8CEA Together they are worth 75%, and nothing else in the game adds to the score, so 75.0% is the most anyone can achieve. Being captured and thrown into a dungeon counts as a visit, so both dungeons score.
B $8CEA,3,3
B $8CED,3,3
B $8CF0,3,3
B $8CF3,3,3
B $8CF6,3,3
B $8CF9,3,3
B $8CFC,3,3
B $8CFF,3,3
B $8D02,3,3
B $8D05,3,3
B $8D08,3,3
B $8D0B,3,3
B $8D0E,3,3
B $8D11,3,3
B $8D14,1,1 End marker
b $8D15 Move variables
D $8D15 #R$8D15: the destination room's record. #R$8D17: the destination room. #R$8D18: the size of the actor plus its load.
B $8D15,2,2 Room record
B $8D17,1,1 Destination room
B $8D18,1,1 Size
c $8D19 Move an actor (GO north, EAST, etc.)
D $8D19 Moves the current actor one step in the direction given by the action number (1-10: north, south, east, west, northeast, northwest, southeast, southwest, up, down). Used for the player's movement commands and for every character that moves.
D $8D19 IN THE DARK, Bilbo does not know which way he is going: the direction is replaced by a random one (#R$8D1E). And if there is no exit that way, instead of 'you cannot go that way' he stumbles: his strength is halved, and he reads 'but fall and hit your head.', or, once his strength has dropped to nothing, 'but fall and smash your skull.' and dies.
D $8D19 A character being carried by another character (for example Bilbo carried by someone) is set down first. The size of the actor plus everything it carries is worked out (#R$8D18). The exit must exist; if it has a door, the door must be open (or broken); Bilbo cannot use a door with bit 7 of its attributes set; and the actor must be no bigger than the door ('the window is too small for you to enter'). If the destination room has a capacity, there must be room ('the boat is too full for you to enter').
D $8D19 Then the actor's location becomes the destination and everything it carries moves with it (#R$9B38). If the actor is Bilbo, the room-entry handler for the destination is run (#R$C67D), and the room is described. The first time Bilbo enters a room, bit 6 of the room's flags is set, the room is described in full (#R$958E), and if the room is in the scoring table at #R$8CEA its points are added to the score. On later visits the short description is used (#R$9606).
C $8D19 Is Bilbo in the dark?
C $8D1C No: go on with the direction he chose
C $8D1E In the dark: pick a random direction from 1 to 10 instead...
C $8D20 A = a random number from 0 to A
C $8D23 Increment A
C $8D24 ...and make it the action
C $8D27 IY = the actor's record
C $8D2B Is the actor being held by something?
C $8D2E Is it nobody ($FF)?
C $8D30 No: skip
C $8D32 IX = the holder's record
C $8D35 Is the holder a living character (bit 6)?
C $8D39 No (a box or barrel): the actor cannot just walk off
C $8D3B Yes: the actor gets down from the character carrying it
C $8D3F Work out the size of the actor plus everything it carries...
C $8D42 Call: Total size of an object's contents (#R$9C3D)
C $8D45 ...plus its own size
C $8D48 ...and keep it for the door and room checks
C $8D4B A = the direction
C $8D4E IX = the exit that way, if there is one
C $8D51 Is there one?
C $8D53 Yes: go and check it
C $8D55 No exit (or it cannot be used): is Bilbo in the dark?
C $8D58 No: just report the failure ("you cannot go that way")
C $8D5B Dry run? Then stop here
C $8D5E IX = Bilbo's record
C $8D62 Clear the carry flag
C $8D63 "but fall and hit your head."
C $8D66 Halve Bilbo's strength
C $8D6A If he has any left, print the message and return
C $8D6D Otherwise: "but fall and smash your skull."
C $8D70 Print it
C $8D73 Bilbo is dead
C $8D76 A = the exit's destination room
C $8D79 Is there one?
C $8D7A No: the exit cannot be used
C $8D7C Save the destination room number
C $8D7F A = the exit's door, if any
C $8D82 Is there a door?
C $8D83 No door: go on to the destination room
C $8D85 IX = the door's record
C $8D88 A = the door's flags
C $8D8B Is it open (bit 5) or broken (bit 3)?
C $8D8D No: the door is in the way
C $8D8F Is the actor Bilbo?
C $8D92 Is A zero?
C $8D93 No: skip the next check
C $8D95 Bit 7 of the door's attributes: a way Bilbo cannot use
C $8D99 Set: he cannot go this way
C $8D9B A = the size of the actor and its load
C $8D9E B = the size of the door
C $8DA1 Compare them
C $8DA2 Too big: "the X is too small for you to enter"
C $8DA4 A = the destination room
C $8DA7 Keep it in B
C $8DA8 IX = its room record
C $8DAB Keep that for later
C $8DAF Does the room have a capacity ($FF = unlimited)?
C $8DB1 Compare with the byte at (IX+$01)
C $8DB4 Unlimited: go ahead
C $8DB6 A = the destination room
C $8DB7 A = the space left in it
C $8DBA Keep it in C
C $8DBB A = the size of the actor and its load
C $8DBE Compare them
C $8DBF Too big: "the X is too full for you to enter"
C $8DC1 Dry run? Then stop here: the move would work
C $8DC4 Move the actor: its location becomes the destination
C $8DC7 Move everything the actor holds with it
C $8DCD Is the actor Bilbo?
C $8DD2 No: a character has moved, and that is all
C $8DD3 Look up the destination in the room-entry handlers
C $8DDD None: skip
C $8DDF HL = the handler...
C $8DE5 ...and run it
C $8DE8 Is Bilbo now in the dark?
C $8DEB Yes: he sees nothing, so describe nothing
C $8DEC Is the actor Bilbo?
C $8DF0 A = the room
C $8DF3 No: describe it anyway (entry for other callers)
C $8DF5 HL = the room record
C $8DF8 Has Bilbo been here before (bit 6 of the room's flags)?
C $8DFA Yes: give the short description
C $8DFD No: mark the room as visited
C $8DFF Save the room number
C $8E00 Look the room up in the scoring table
C $8E07 Not there: no points
C $8E0A DE = the points for this room
C $8E10 Add them to the score
C $8E18 Restore the room number
C $8E19 Describe the room in full
C $8E1C "<the door> is too small for you to enter"
C $8E21 IX = the destination room record
C $8E25 "<the room> is too full for you to enter"
C $8E29 Push the room's (or door's) words as the message parameter
C $8E2C H = (IX+3)
C $8E30 Print the message
C $8E33 Done
c $8E34 Is an object shut inside something?
D $8E34 Follows the holders of object A upwards while they are open. Returns with Z set if it reaches a loose object (so the object is out in the open) and Z reset if it meets a closed container.
C $8E34 Save IX
C $8E36 IX = object A's own record
C $8E39 A = whoever is holding it
C $8E3C Held by nobody at all: it is out in the open
C $8E40 Held by something: IX = that holder's own record
C $8E43 Is the holder open?
C $8E47 Yes: look inside IT in turn (and see who holds that)
C $8E49 No (shut away): make A non-zero
C $8E4B Restore IX
c $8E4E LOOK THROUGH (a door or window)
D $8E4E The LOOK THROUGH handler of every door (and, via #R$A678, the window). The door must be open (otherwise 'the door is closed'), and the actor must not be shut inside anything. Then it continues as #R$8E5A.
C $8E4E A = the target (the door or window)
C $8E51 IX = its own record
C $8E54 Is it open?
C $8E57 No: say so and stop ("the door is closed.")
c $8E5A LOOK ACROSS (a river)
D $8E5A Finds the exit that passes through the target (#R$9E6E). If it leads anywhere, and the room on the other side is lit, the actor is moved there for a moment, the room is described ('you see ...', #R$9589), and the actor is put back. If the far side is dark: 'it is dark.' This is how you can see what is on the other bank of the river, or behind a door, without going there.
C $8E5A A = the current actor
C $8E5D Is the actor shut inside something (rather than free to look around)?
C $8E60 Yes: cannot look through anything from in there
C $8E61 Find the exit that passes through the target (the door, window or river)
C $8E66 No such exit: fail with the usual message
C $8E69 A = where that exit leads
C $8E6E Leads nowhere: fail
C $8E71 Dry run? Then stop here: it would work
C $8E74 Save the exit
C $8E76 IX = the room on the far side
C $8E79 Is it lit?
C $8E7D Restore the exit
C $8E7F Dark over there: "it is dark." (below)
C $8E81 IY = the actor's own record
C $8E85 Save the actor's TRUE room for a moment...
C $8E89 ...and pretend, just for a moment, that they are on the far side
C $8E8F Describe what can be seen from there ("you see ...")
C $8E92 Put the actor back in their real room
C $8E97 "it is dark."
c $8E9D GO THROUGH (a door, window or river)
D $8E9D Finds the exit through the target (#R$9E6E) and goes through it (#R$8EA0). The GO THROUGH handler of every door, the spider web and the portcullis.
C $8E9D Find the exit that passes through the target, then fall into #R$8EA0 to use it
c $8EA0 Go through an exit
D $8EA0 Moves the actor through the exit at IX (see the room records at #R$B97A): byte 0 the direction, byte 1 a door or other obstacle, byte 2 the destination. Exits with no destination cannot be used. If the exit has a door, the door must be open (bit 5 of its flags). The direction is then used as the action number and the move is made by #R$8D19 (at #R$8D27). If the exit cannot be used, #R$9EBF reports it.
R $8EA0 Input:IX Exit
R $8EA0 A $FF if there is no exit
C $8EA0 Is there no such exit at all?
C $8EA2 Fail with the usual message
C $8EA5 A = where the exit leads
C $8EAA Leads nowhere: fail
C $8EAD Does the exit have a door?
C $8EB2 No: go straight ahead
C $8EB4 Yes: save the exit
C $8EB6 IX = the door's own record
C $8EB9 Is it open?
C $8EBD Restore the exit
C $8EBF Closed: fail ("you cannot go that way")
C $8EC2 Dry run? Then stop here: it would work
C $8EC5 A = the exit's own direction, used as the movement action
C $8ECB No specific target - just moving in this direction
C $8ED0 Carry out the move (joining the ordinary movement routine partway through)
c $8ED3 FILL WITH
D $8ED3 The barrel's FILL handler. The instrument must be something that pours (bit 1 of its flags: water and wine, for example) and the target must not already be full ('the barrel is full'). The work is done by PUT IN (#R$91B9) with target and instrument swapped (#R$9E93), so FILL THE BARREL WITH WATER is really PUT THE WATER IN THE BARREL.
D $8ED3 Filling from a river is a special case: if the instrument is object 23 or 24 (the river's water or black water), a fresh object 21 or 22 ('water', 'black water') is used instead, so the river never runs dry.
C $8ED3 IX = the target's own record (the container being filled)
C $8ED7 Is the instrument the fast river's water, or the enchanted river's black water?
C $8EDC Ordinary river water: go and use a fresh copy of it, below
C $8EE0 Black water: likewise
C $8EE2 Anything else: IY = the instrument's own record
C $8EE6 Does it actually pour (is it a liquid)?
C $8EEA No: fail with the usual message
C $8EED Is the container already full?
C $8EF1 A = the state code for FULL
C $8EF3 Yes: say so and stop
C $8EF6 No: do the work as an ordinary PUT IN...
C $8EF9 ...with target and instrument swapped, so "fill X with Y" becomes "put Y in X"
C $8EFC Ordinary river water: A = a FRESH water object
C $8EFE IY = its own record
C $8F04 Black water: A = a fresh black-water object instead
C $8F0A That fresh object becomes the instrument
C $8F11 It starts out held by nobody...
C $8F15 ...then join the ordinary FILL code above (so the river itself never runs dry)
c $8F17 RUN
D $8F17 Running means going in a random direction. A random number from 1 to 9 is chosen (#R$9BF4), and the exits of the room are tried from that direction onwards, cycling round, until one with a destination is found (#R$9E51); the actor then moves that way (#R$8D19).
C $8F17 Pick a random direction from 1 to 10
C $8F1E (0 is not a real direction: try again)
C $8F20 B = that direction
C $8F21 Is there a usable exit that way?
C $8F25 Yes: run that way
C $8F27 No: try the next direction round instead...
C $8F2D ...wrapping back to 1 after 10
C $8F31 That direction becomes the movement action
C $8F34 Move that way
c $8F37 ENTER and GO INTO
D $8F37 Finds the exit of the current room that leads to the room named as the target (#R$9E76) and goes through it (#R$8EA0), so 'go into the tunnel' works without naming a direction.
C $8F37 A = the target (the room named, e.g. "the tunnel")
C $8F3A Find the exit that leads there
C $8F3D Go through it
c $8F40 FOLLOW
D $8F40 If the character being followed is in the same room, nothing happens: 'I cannot follow X from here.' Otherwise the actor looks for an exit from the current room that leads straight to the room the character is in (#R$9E76) and takes it (#R$8EA0). So you can only follow someone who has just left by a direct exit.
C $8F40 IX = the actor's own record
C $8F44 B = the actor's own room
C $8F47 IX = the target character's own record
C $8F4B Is the target actually in the same room as the actor?
C $8F4F Yes: there is nowhere to follow them to (below)
C $8F51 No: find the exit that leads straight to where they are
C $8F56 Found one: go through it
C $8F59 No direct exit (or they are right here): "I cannot follow X from here."
c $8F5F THROW AT
D $8F5F The default handler for THROW X AT Y. After checking that the actor can lift the thing thrown (#R$8C86), it becomes an attack: if the target is alive, the fight routine (#R$90DB, ATTACK) is used, otherwise the breaking routine (#R$9257, STRIKE), in both cases with the thrown object as the weapon (#R$9E93). Afterwards the thrown object lands at the target's feet (its holder is cleared) and the target reacts as if attacked (#R$953F).
C $8F5F Can the actor actually lift the thing being thrown (the target)?
C $8F62 Assume the thing being thrown AT is alive: HL = the fight routine, action 15 (ATTACK)
C $8F67 IX = the record of whatever is being thrown at (currently the "instrument", via AT)
C $8F6B Is it actually alive?
C $8F6F Yes: keep the fight routine
C $8F71 No (e.g. a window): HL = the breaking routine instead, action 11 (STRIKE)
C $8F76 This becomes the action to carry out
C $8F79 Run it with target and instrument swapped, so the thing thrown AT becomes the new target, and the thing thrown becomes the weapon
C $8F7C Restore the action number to THROW AT itself, for the rest of the turn
C $8F81 Did this really happen (not just a trial)?
C $8F86 Only a trial: nothing more to do
C $8F87 It really happened: IX = the thrown object's own record
C $8F8B It falls to the ground, held by nobody
C $8F8F Let whatever it hit react as if attacked
C $8F9A (unreachable leftover code)
c $8F9E TALK TO and SAY TO
D $8F9E Hands the orders collected from a quotation (#R$80CD) to the character being spoken to (#R$88A7). Something that is not a character cannot take orders.
D $8F9E Whether the character obeys depends on byte 6 of its entry in #R$C9BA. A value of 0 means it always obeys. Otherwise a random number from 0 up to that value is picked (#R$9BF4), and 0 means it says "no". Because of the way the random numbers are skewed (#R$9BFD), the chance of a refusal goes DOWN as the value goes up: 1 gives a refusal half the time, 3 a quarter of the time, and 5 or 6 one time in eight. So the value is really a measure of willingness rather than stubbornness: the trolls, the wood elf and the butler (1) are the most contrary, Gollum and Bard (3) refuse one order in four, Gandalf, Elrond and Thorin (5 and 6) one in eight - and the goblins, the warg and the dragon (0) never refuse at all.
C $8F9E Dry run? Then stop: talking always works
C $8FA1 Is the person spoken to a character?
C $8FA9 (A = 0: no orders to hand over)
C $8FAB No: the orders are thrown away
C $8FAD Is Gollum waiting for his answer?
C $8FB2 Yes: the words go to him, no refusal
C $8FB4 A = the character's stubbornness
C $8FB9 0: always obeys
C $8FBB Otherwise pick a random number from 0 up to the stubbornness
C $8FC0 0: refuses
C $8FC2 Hand over the orders (A of them)
C $8FC6 "<character> says "no"."
C $8FCC No orders
c $8FCF DIG (the sand)
D $8FCF The sand's DIG handler: digging opens it (#R$9081), revealing anything buried in it; digging again closes it.
C $8FCF Dry run? Then stop here: it would work
C $8FD2 IX = the sand's own record
C $8FD6 Is it already open (dug)?
C $8FDA No: open it, as if by OPEN (revealing whatever is buried)
C $8FDD Yes: close it again instead (covering things back up)
c $8FE0 SHOOT
D $8FE0 The shooter must be carrying the bow (object 25): otherwise 'you are not carrying the bow.' Then, if it would work, it is treated as an attack.
D $8FE0 Anyone except Bard: the dragon cannot be hit at all ('the arrow misses the dragon by a wide margin'), and anyone else is missed if a random number from 0 to 8 (#R$9BF4) is below 3.
D $8FE0 Bard (object 70) never misses. On a hit the arrow (object 26) is left lying where it fell, 'the arrow hits X.', and a living target is killed outright (#R$96DD); anything else is broken (#R$9257).
D $8FE0 So the only way to kill the dragon is to get Bard to shoot it - which is what the HELP message in the lower halls means by 'look to bard'.
C $8FE0 Is the actor holding the bow (object 25)?
C $8FE5 "you are not carrying the bow."
C $8FE8 If not, say so and stop
C $8FEB Check the target is something that can be attacked at all
C $8FEE Dry run? Then stop here: it would work
C $8FF1 Treat this as an ordinary attack from now on
C $8FF6 Is the actor Bard himself?
C $8FFB Yes: Bard never misses - skip the ordinary chance-to-miss below
C $8FFD No: is the target the dragon?
C $9002 "the arrow misses the dragon by a wide margin."
C $9005 Against the dragon, anyone but Bard always misses
C $9008 Anyone else: pick a random number from 0 to 8
C $900D Below 3?
C $900F Yes: the shot misses (HL still holds the "misses" message)
C $9012 IX = the arrow's own record
C $9016 Is the target the strong arrow itself (an odd edge case)?
C $901D Otherwise the arrow falls to the ground, held by nobody
C $9021 "the arrow hits X."
C $9027 IX = the target's own record
C $902B Is the target actually alive?
C $902E No: break it instead (STRIKE)
C $9031 Yes: kill it outright
C $9037 A = the state code for DEAD
C $9039 "the X is dead."
c $903C The player is dead
D $903C Called whenever Bilbo is killed (for example by Thorin at the end of the fight in #R$90DB, or by the stinging thing in #R$AA2E). Prints 'you are dead' and the score ('you have mastered 0.0% of this adventure') from the message at #R$AEE3 and #R$81AD, waits for a key, and restarts the game at #R$6C27 with everything restored from the backups.
C $903C The actor is Bilbo again
C $9040 "you are dead."
C $9046 Print the score
C $9049 Wait for a key
C $9052 Restart the game
c $9055 INVENTORY
D $9055 Prints 'you are carrying.' and then either '      nothing' or a list of the objects held by the actor (#R$9EF8), using #R$9CEC to count them first.
C $9055 Dry run? Then stop here: it always works
C $9058 "you are carrying."
C $905E A = the current actor
C $9061 Are they carrying anything visible at all?
C $9065 "      nothing"
C $9068 If not, say so
C $906B Otherwise: A = the actor again
C $906E B = the actor's own room
C $9075 List everything they hold
c $9078 OPEN
D $9078 Checks that the target is not locked or already open (#R$A129; if it is, #R$A09C says so, e.g. 'the door is locked'). Then sets bit 5 (open) of its flags. If the target is an ordinary object (a container rather than a door) and has something in it, the contents are listed (#R$9EF8) unless the actor is in the dark (#R$9F89).
C $9078 Is the target locked, or already open?
C $907B If either, explain why it cannot be opened ("the door is locked."/"the chest is open.")
C $907E Dry run? Then stop here: it would work
C $9081 Open it
C $9085 Is the target an ordinary, single-place object (not a door, which needs no further reply)?
C $9089 A door: nothing more to say
C $908A An ordinary container: does it hold anything visible?
C $9091 Nothing inside: nothing more to say
C $9092 Something inside: print the heading for it ("in the chest there is")
C $9098 Nothing worth listing after all: stop
C $9099 B = the target's own room
C $909C List everything it holds
c $90A2 CLOSE
D $90A2 Checks the target is open (#R$A4C3; otherwise 'the X is closed'), then clears bit 5 of its flags.
C $90A2 IX = the target's own record
C $90A6 Is it open?
C $90A9 No, already closed: say so
C $90AC Dry run? Then stop here: it would work
C $90AF Close it
c $90B4 Check that a target may be attacked (sides)
D $90B4 Characters on the same side do not fight each other. The target's side bits (4-6 of byte 4 of its record) are compared with the attacker's; if they have any in common, the attack is quietly ruled out: the 'would work' flag is cleared and the attack routine's caller is abandoned.
D $90B4 But the player is allowed to attack a friend. When Bilbo is the attacker and the target is on his side (bit 4), that bit is cleared in the target's record first - permanently. So hitting Thorin or Gandalf takes them off Bilbo's side for the rest of the game, which is what lets them fight back (and, since no one is on the same side any more, lets other characters attack them too).
C $90B4 IX = the target's record
C $90B8 Is the attacker Bilbo?
C $90BC No: just compare sides
C $90BE Is the target on Bilbo's side (bit 4)?
C $90C2 No
C $90C4 Yes: it is not any more - for good
C $90C8 A = the target's side bits...
C $90CD IX = the attacker's record
C $90D1 ...in common with the attacker's?
C $90D4 None: the attack may go ahead
C $90D5 Same side: drop the caller's return address...
C $90D6 ...and record that the attack would not work
c $90DB Attack (HIT, KILL, ATTACK, STRIKE, SMASH ...)
D $90DB The fight routine. It is used both when the player attacks someone and when another character attacks (for example Thorin retaliating, or the trolls and goblins attacking Bilbo). The attacker's object record is pointed to by $B5FC, the target's by #R$B5F8, and the weapon's (if any) by $B5FA; #R$B5DA holds the weapon's object number, or $FF when there is none.
D $90DB It uses two bytes of the 8-byte object header (see #R$C00B): byte 5 is STRENGTH and byte 6 is DEFENCE. Some starting values: Bilbo 64/64, Thorin 104/120, Gandalf 112/136, the trolls 160/160, the goblins 72/96, Bard 96/96, the dragon 192/192, and the short strong sword has strength 64 (255 in my modified tape).
D $90DB Step 1: 'you attack thorin' is printed ($90FE onwards), naming the weapon if one was used.
D $90DB Step 2: the attack value is the attacker's strength (#R$90F9), plus the weapon's strength if one was used (#R$9102-#R$9116), capped at 255. A weapon is only accepted if byte 0 of its record is 1 (an ordinary one-place object); otherwise the message at #R$AE52 is printed.
D $90DB Step 3: the attack value is randomised by #R$917D (roughly -10 to +10) and so is the target's defence (#R$9121-$912A).
D $90DB Step 4: if the randomised defence is greater than or equal to the attack, the blow does nothing: 'but the effort is wasted. his defense is too strong' (#R$AE43).
D $90DB Step 5: if the attack exceeds the defence by more than 16, the blow is fatal. The message at #R$AD2D ('with one well placed blow you cleave his skull') is printed and bit 3 of the target's flag byte (byte 7) is set, marking it dead (#R$9168).
D $90DB Step 6: otherwise the target is wounded. The difference d (1-16) selects a message from the table at #R$9190 - the larger the margin the nastier the description. The code then tries to reduce the target's strength by d/2+1 and its defence by d/4+1 (#R$914E-$9164), skipping either reduction if it would go below 0. It computes d/2 and d/4 with RRCA (rotate right) rather than SRL (shift right), though.
D $90DB BUG: RRCA moves the bit shifted out of the bottom back into the top, so the halving only works when the bit being shifted out is 0. With Thorin (strength 104, defence 120) the actual results are: margins 4, 8, 12 and 16 reduce both strength and defence as intended (for example margin 8 takes him to 99/117); margins 2, 6, 10 and 14 reduce strength only; margins 3, 7, 11 and 15 do nothing at all; and margins 1, 5, 9 and 13 leave strength alone but slash his defence by about 65, to 52-55, which makes the next blow very likely to kill him.
D $90DB BUG: the table at #R$9190 only has useful entries for differences 1 to 15. A difference of exactly 16 reads the two bytes at #R$91B0 (which are code, $DD $2A) as a message address, so the game interprets ROM at $2ADD as a message and prints garbage.
C $90DB Check the target is something that can be attacked
C $90DE Was a weapon named?
C $90E1 HL = the word used when there is no weapon
C $90E6 No weapon: skip
C $90E8 IX = the weapon's record
C $90EC HL = the weapon's noun (e.g. SWORD)
C $90F2 Keep it for the report ("...with the sword")
C $90F5 IX = the attacker's record
C $90F9 B = the attacker's strength
C $90FC Is there a weapon?
C $90FF ($FF + 1 = 0)
C $9100 No: attack with strength alone
C $9102 IY = the weapon's record
C $9106 Is it an ordinary object (one place)?
C $910A "you cannot kill with the X"
C $910D No: say so and stop
C $9110 A = the weapon's strength
C $9113 Add the attacker's strength
C $9114 No overflow: fine
C $9116 Overflow: cap it at 255
C $9118 B = the attack value
C $911A Randomise the attack value by about +/-10
C $911E Dry run? Then stop here: the attack would happen
C $9121 IX = the target's record
C $9125 A = the target's defence
C $9128 Randomise it too
C $912B Is the defence at least as big as the attack?
C $912C "but the effort is wasted. his defense is too strong."
C $912F Yes: the blow does nothing
C $9132 C = the defence
C $9133 Defence + 16...
C $9137 (capped at 255)
C $9139 ...less than the attack?
C $913A Yes: a fatal blow
C $913C A wound. A = the margin (attack - defence, 1-16)
C $913E Double it to index the wound messages
C $9142 IY = the wound message table
C $9148 HL = the message for this margin (a margin of 16 runs off the end of the table)
C $914E Halve the doubled margin twice with RRCA: margin/2, but with bit 0 rotated into bit 7 (see the bug note)
C $9150 B = the "half" margin
C $9151 A = 255 - B
C $9152 Add the target's strength: carry only if strength > B
C $9155 It would go negative: leave it alone
C $9157 Otherwise strength = strength - B - 1
C $915A A = the "half" margin again
C $915B Halve it again (RRCA again)
C $915C A = 255 - that
C $915D Add the target's defence
C $9160 It would go negative: leave it
C $9162 Otherwise defence = defence - (margin/4) - 1
C $9165 Print the wound message
C $9168 "with one well placed blow <actor> cleaves <his/your> skull."
C $916E Mark the target dead
C $9172 A = the target
C $9175 Kill it: drop its things, remove it from the character table
C $9178 Then report "<target> is dead."
c $917D Randomise a fight value
D $917D Adds a random amount to the value in B, using #R$9BFD with a range of 10, and returns the result in A, clamped to 0-255.
D $917D The random amount C is a signed number between -10 and +10, but it is heavily biased towards positive values: only about 1 in 25 adjustments is negative, and +1 to +5 are twice as likely as +6 to +10 (see #R$9BFD).
D $917D BUG: the clamping is wrong for negative adjustments. After ADD A,B the code treats the carry flag as 'overflow'. When C is negative (say -3, which is $FD) and B is at least 3, the addition B+$FD always produces a carry, even though the true result (B-3) is perfectly valid. The code then sees that C is negative and returns 0 instead of B-3. So whenever the adjustment is negative, the value collapses to 0. When this happens to a defence value, the next blow is almost certainly fatal; when it happens to an attack value, the blow is wasted. This bug is the reason a bare-handed Bilbo occasionally kills Thorin, and one reason for the game's famous sudden deaths.
R $917D Input:B Value to randomise
R $917D Output:A Randomised value (0-255)
C $917E B = the value to randomise
C $917F A random number from -10 to +10...
C $9184 ...in C
C $9185 A = value + random number
C $9186 No carry: that is the answer
C $9188 Carry: assume it overflowed; A = 0...
C $9189 ...is the random number negative?
C $918B Yes: return 0. (But adding a negative number always sets the carry, so every negative adjustment gives 0: the bug)
C $918D Positive: the value really overflowed, so return 255
w $9190 Wound messages
D $9190 Addresses of the messages printed when a blow wounds but does not kill, indexed by twice the margin by which the attack beat the defence (see #R$90DB). Entry 0 is never used (a margin of 0 means the blow was wasted). The small margins give the mildest messages and the larger margins the most violent ones, such as 'you hit thorin hard on the shoulder - thorin staggers and almost falls'.
D $9190 The table has 16 entries (#R$9190-$91AF), but the margin can be 16, which reads past the end into the code at #R$91B0 (see the bug note in #R$90DB).
W $9190,32 Messages for margins 0-15
c $91B0 Is the target an ordinary object?
D $91B0 Returns with Z set if byte 0 of the target's record is 1: an object in one place. Doors and other things that exist in two places have 2.
R $91B0 Output:F Z set if the target is an ordinary object
C $91B0 IX = the target's own record
C $91B4 Does it occupy just one place (rather than two, like a door)?
C $91B8 Z reflects the answer
c $91B9 PUT IN, PUT ON and DROP IN
D $91B9 The handler for putting the target into (or on) a container, the instrument. The target must be something that can be picked up (#R$8CBA), and not already in the container ('I cannot do that'). Except for PUT ON, the container must be open ('the chest is closed'). There must be room: the container's size (byte 2), minus the target's size, minus the size of what is already inside (#R$9C3D), must be positive ('the chest is too full'). Then the target takes the container's location and the container becomes its holder.
C $91B9 Is the target something that can even be picked up at all?
C $91BC Is the instrument (the container) actually the same object as the target's own holder already?
C $91C2 Yes: "I cannot do that." (it's already there)
C $91C5 IY = the instrument's (the container's) own record
C $91C9 Is this actually PUT ON (action 18), rather than PUT IN or DROP IN?
C $91CE PUT ON: no need for the container to be open
C $91D0 PUT IN or DROP IN: is the container open?
C $91D4 No: say so and stop, below
C $91D6 A = the container's own capacity (its size)
C $91D9 Subtract the target's own size
C $91DC Already too big even on its own: fail, below
C $91DE Save what is left
C $91DF A = how much the container already holds
C $91E6 Subtract that too
C $91E8 "the X is too full."
C $91EB Not enough room at all: say so and stop
C $91EE Exactly full, with no room to spare: likewise
C $91F1 Dry run? Then stop here: it would work
C $91F4 The target moves to the container's own room...
C $91FA ...and the container becomes its new holder
C $9201 A = the state code for OPEN/CLOSED
C $9203 "the X is closed."
c $9206 EAT and DRINK
D $9206 Eating food makes the actor stronger: 10 is added to their strength (byte 5 of their record). If the target is inside a container (for example a drink in a bottle), the container's 'full' flag (bit 2) is cleared and the actor gains only 1. The food or drink then vanishes: its holder is set to $FF and all its locations to 0.
D $9206 But there is a limit. If the new strength would be 128 or more, the game prints 'his foul gluttony has killed him' ('your foul gluttony has killed you' for Bilbo), and the actor dies (#R$96DD). Bilbo starts with strength 64, so the seventh helping of food is fatal.
C $9206 Dry run? Then stop here: eating and drinking always work
C $9209 IX = the food or drink's own record
C $920D Is it lying loose, or inside something (a bottle, say)?
C $9212 Loose: skip the container step below
C $9214 Inside something: IX = that container's own record
C $9217 It is no longer full
C $921B Drinking from a container only gives 1 point of strength
C $921F (Reached only when the action is genuinely happening, so this always passes straight through)
C $9222 Eating or drinking on its own gives 10 points of strength
C $9224 IX = the actor's own record
C $9228 Add the gain to the actor's current strength
C $922B Would that take strength to 128 or more?
C $922D Yes: the meal proves fatal (see below)
C $922F No: store the new, higher strength
C $9232 IX = the food or drink's own record
C $9236 It is held by nobody now...
C $923A ...B = how many locations it has (normally 1)...
C $923D ...and each of those locations becomes 0: it has vanished entirely
C $9246 "your foul gluttony has killed you."
C $924C A = the actor
C $924F The actor dies
c $9252 "The X is broken"
D $9252 Reports that the target is broken (#R$A094 with state $83).
C $9252 A = the state code for BROKEN
C $9254 "the X is broken."
c $9257 STRIKE (break something)
D $9257 Breaking things - STRIKE, BREAK and SMASH, and THROW at something that is not alive. Things that pour cannot be broken, and nor can anything with a defence of 0. If there is an instrument, it must have some strength and must itself have a STRIKE handler (so you can smash a door with the sword but not with the lunch).
D $9257 The force is the instrument's strength plus the actor's strength plus a random number from -21 to +21 (#R$9BFD), capped at 255. If that is at least the target's defence, the target breaks: it is marked broken, its adjective becomes BROKEN (#R$A0BC), its strength is halved, and if it is a container its contents fall out. 'the door is broken.'
D $9257 Then the instrument may break too, whether or not the target did: its defence plus a random number from -21 to +21 is compared with the target's defence, and if it is at least as large the instrument breaks. As written, this makes a tougher instrument more likely to break. Worse, the addition has the same carry-flag mistake as the fight code (#R$917D): a negative random number sets the carry, which is taken as an overflow, and the value becomes 255 - so the instrument breaks whenever the random number is negative. In 40 test runs in the emulator of BREAK DOOR WITH SWORD against the heavy rock door, the sword broke 9 times; with the bow, whose defence of 16 could never reach the door's 144 honestly, the bow still broke 5 times.
C $9257 IX = the target's record
C $925B Is the object "evaporates" (bit 1 of its flags)?
C $925F If the bit is set, go to Report failure (#R$9EBF)
C $9262 Is the object dead/broken (bit 3 of its flags)?
C $9266 If the bit is set, go to #R$9303
C $9269 A = 0
C $926A Compare with the byte at (IX+$06)
C $926D If yes, go to Report failure (#R$9EBF)
C $9270 B = A
C $9271 A = the instrument
C $9274 (sets Z if A was $FF: none)
C $9275 If it is zero, go to #R$9296
C $9277 IY = the instrument's record
C $927B A = the object's strength
C $927E Is A zero?
C $927F If it is zero, go to Report failure (#R$9EBF)
C $9282 Save IX
C $9284 IX = the instrument's record
C $9288 A = 11
C $928A Call: Find an object's handler for an action (#R$9ADC)
C $928D Restore IX
C $928F Increment A
C $9290 If the routine returned with Z set, go to Report failure (#R$9EBF)
C $9293 B = the object's strength
C $9296 Dry run? Then just record that this would work, and return from the caller
C $9299 A = 21
C $929B Call: Random number in a range (#R$9BFD)
C $929E Add A,B
C $929F IY = the actor's record
C $92A3 Add the object's strength
C $92A6 If the routine returned with carry reset, go to #R$92AA
C $92A8 A = 255
C $92AA Subtract the object's defence
C $92AD If carry is set, go to #R$92CA
C $92AF Set the object's "dead/broken" flag (bit 3)
C $92B3 A = the target
C $92B6 Call: Mark an object as dead or broken (#R$A0BC)
C $92B9 Shift/rotate (IX+$05)
C $92BD How are the target's contents described?
C $92C0 In (0) or on (1)?
C $92C2 Then they fall out of the broken container
C $92C5 A = 131
C $92C7 Call: "The X is Y" (#R$A09C)
C $92CA A = the instrument
C $92CD Is it nobody ($FF)?
C $92CF Return if yes
C $92D0 IY = the instrument's record
C $92D4 Is the object dead/broken (bit 3 of its flags)?
C $92D8 Return if the bit is set
C $92D9 B = the object's defence
C $92DC A = 21
C $92DE Call: Random number in a range (#R$9BFD)
C $92E1 Add A,B
C $92E2 If the routine returned with carry reset, go to #R$92E6
C $92E4 A = 255
C $92E6 Subtract the object's defence
C $92E9 Return if carry is set
C $92EA Set the object's "dead/broken" flag (bit 3)
C $92EE A = the instrument
C $92F1 Call: Mark an object as dead or broken (#R$A0BC)
C $92F4 A = the object's strength
C $92F7 Shift/rotate A
C $92F9 Set the object's strength to A
C $92FC Call: Drop everything the target holds (#R$9CA5)
C $92FF Save IY
C $9301 Restore IX
C $9303 A = 131
C $9305 Finish by jumping to "The X is Y" (#R$A09C)
c $9308 GIVE TO
D $9308 The actor must be carrying the target (#R$9BCD; otherwise 'you are not carrying it'). The receiver must be able to carry it: the target's weight plus what the receiver already carries (#R$9C42) must not exceed the receiver's capacity, or 'X is carrying too much'. Then the receiver becomes the target's holder, the target moves to the receiver's room, and #R$9B38 tells anyone who sees it.
C $9308 IY = the instrument's (the receiver's) own record
C $930C Is the actor actually holding the target?
C $930F "you are not carrying it."
C $9312 If not, say so and stop
C $9315 A = the receiver
C $9318 A = how much the receiver is already carrying
C $931B IX = the target's own record
C $931F Add the target's own weight to that
C $9322 Keep the combined total for a moment
C $9324 A = the receiver's own carrying capacity
C $9327 Subtract the combined total: would that go below zero?
C $9328 "X is carrying too much."
C $932B Too much for them to take: say so and stop
C $932E Dry run? Then stop here: it would work
C $9331 The receiver becomes the target's new holder...
C $9337 ...in the receiver's own room
C $933D B = that room
C $933E Move the target there, telling Bilbo about it if he can see it
c $9344 EXAMINE
D $9344 If the object has a description message, it is printed. The address of that message is stored in the object's fourth word slot (bytes 14 and 15 of its record), which is not needed for words when the object has only one or two adjectives. Otherwise the game just says 'you see the X.'
C $9344 Dry run? Then stop here: EXAMINE always works
C $9347 A = the target
C $934A IX = its own record
C $934D HL = its own description, if it has one written specially for it
C $9353 Is there actually a description there?
C $9355 Yes: print it, and that is the whole answer
C $9358 No description: "you see"
C $935E IY = the target's own record
C $9362 Print its name
C $9365 A full stop...
C $936A ...then a new line
c $936E EMPTY
D $936E The barrel's EMPTY handler. It must be open ('the barrel is closed') and have something in it ('the barrel is empty'). Its contents are tipped out where it stands (#R$9CA5) and it is no longer full.
C $936E IX = the target's own record
C $9372 Is it open?
C $9375 No: "the X is closed."
C $9378 A = the target
C $937B Does it hold anything visible?
C $9380 No: it is already empty, below
C $9382 Dry run? Then stop here: it would work
C $9385 Tip everything it holds out, into its own place
C $9388 It is no longer full
C $938D A = the state code for FULL/EMPTY
C $938F "the X is empty."
c $9392 PUT or DROP something in the river
D $9392 The rivers' PUT IN and DROP IN handler. The river is an object in two places, one on each bank. The thing dropped in is carried to the location on the other side from the actor ('... and it gets swept away'); if the actor is on the river's second bank, the thing goes to location 0, and is lost.
C $9392 Is the target something that can even be picked up?
C $9395 Dry run? Then stop here: it would work
C $9398 A = the room the actor started this turn in (one bank of the river)
C $939B IX = the river's own record (which has two locations, one on each bank)
C $939F B = how many locations it has
C $93A2 Is the actor's bank the FIRST of them?
C $93A7 No: try the next location
C $93AB Neither bank matches (should not happen): "I cannot do that."
C $93AE A = the OTHER bank (the one after this location)
C $93B1 Was this actually the last location?
C $93B4 If so, there is no far bank: it is simply lost (room 0)
C $93B5 IX = the target's own record
C $93B9 It moves to the far bank...
C $93BC ...held by nobody
C $93C0 B = that room
C $93C1 Move it there, and report it if Bilbo can see
C $93C7 "...and it gets swept away."
c $93CD LOCK
D $93CD The target must be closed and not already locked (#R$A129). The instrument must not be broken (bit 3 of its flags) or 'the key is broken'. Then bit 0 (locked) of the target's flags is set.
D $93CD LOCK and UNLOCK share their last instructions: this routine writes $C6 into $93EB, turning the instruction at #R$93E8 into SET 0,(IX+$07); #R$93ED writes $86 there, turning it into RES 0,(IX+$07).
C $93CD Is the target already locked, or not even closed?
C $93D0 If either, say why it cannot be locked
C $93D3 A = $C6, the machine-code for a SET instruction
C $93D5 Poke that into the instruction at $93EB below, so that from now on it locks rather than unlocks - this and #R$93ED share their final steps by rewriting each other
C $93D8 IY = the instrument's (the key's) own record
C $93DC Is the key broken?
C $93E0 A = the state code for BROKEN
C $93E2 If it is broken, say so and stop
C $93E5 Dry run? Then stop here: it would work
C $93E8 Lock the target (this very byte is what #R$93ED rewrites to RES, to unlock instead)
c $93ED UNLOCK
D $93ED The target must be locked (bit 0 of its flags) or 'the door is unlocked'; the instrument must fit (#R$A134). Then the RES instruction is written into #R$93CD and the lock is cleared there.
C $93ED IX = the target's own record
C $93F1 Is it actually locked?
C $93F5 A = the state code for UNLOCKED
C $93F7 No, already unlocked: say so
C $93FA Locked: does the key fit (is the door open enough to check)?
C $93FD No: say why not
C $9400 A = $86, the machine-code for a RES instruction
C $9402 Poke that into the shared instruction, then join #R$93CD, which finishes the job by clearing the lock
c $9404 THROW ... ACROSS / THROUGH
D $9404 The actor must be carrying the target. The instrument (the thing thrown across or through, such as a river or a window) must be one of the exits of the room (#R$9E71), and if it is a door it must be open ('the window is closed'). The target is then dropped and moved to the room on the other side, and #R$9B38 reports it.
C $9404 Is the actor holding the target?
C $9407 A = the instrument (the river, window or similar being thrown across or through)
C $940A Find the room's exit that passes through it
C $940F No such exit exists: fail with the usual "you cannot go that way"-style message
C $9412 IY = the instrument's own record
C $9416 Is it open (or is that even required)?
C $941A A = the state code for OPEN/CLOSED
C $941C Closed: say so and stop
C $941F Dry run? Then stop here: it would work
C $9422 B = this exit's destination room
C $9425 IX = the target's own record
C $9429 It is held by nobody now...
C $942D ...and lands in the room on the far side
C $9430 Move it there, telling Bilbo about it if he can see it
c $9436 Could the action apply to this target?
D $9436 Used while choosing between candidate objects (#R$86ED). Sets #R$B5EC to 1 if the action could possibly apply to the target: either there is a default handler for the action (#R$C61F), or the target itself has a handler for it (#R$9ADC). The checks in #R$A100 are also applied. Sets #R$B5EC to 0 if the action is not possible at all, for example when the target is the actor.
C $9436 Save the caller's IX and HL
C $9439 Does the action even make sense (not done to yourself, for instance)?
C $943C Assume not
C $943E It does not: record that and stop
C $9440 A = the action being tried
C $9443 Is there a default handler for it (one that applies to any object)?
C $944A (A is left holding either the action, if found, or $FF if there is no default handler)
C $944C Assume it could apply
C $944E A default handler exists: that settles it
C $9450 No default handler: is this one of the actions that uses the instrument's own handlers rather than the target's?
C $9453 Assume it could apply
C $9455 Yes: accept it for now (the instrument itself gets checked properly later)
C $9457 No: does the TARGET itself carry a handler for this action?
C $9463 Assume it could apply
C $9465 It does (found): that settles it
C $9467 No handler anywhere: it could not apply after all
C $9468 Record the answer
C $946B Restore the caller's HL and IX
c $946F Carry out the action
D $946F Performs the current action (#R$B5D8) with the current target ($B5D9) and instrument (#R$B5DA). During a dry run ($B5EB = 0) nothing is printed or changed, and the routines report success in #R$B5EC instead.
D $946F First the basic checks: the action must make sense (#R$9A9F: you cannot, for instance, give something to yourself; if it fails, 'I cannot do that.'). If it is dark (#R$954D) and the action needs light, 'I see nothing.' unless the objects are being carried. The records of the target and instrument are found and saved in #R$B5F8 and $B5FA, and each must be within reach (#R$9686).
D $946F Then the handlers are found. If the target (or, for certain actions listed at #R$A13B, the instrument) has handlers of its own for this action (#R$9ADC), they are called one after another: the matching entry and any entries with action 0 straight after it. Otherwise the default handler for the action is looked up in #R$C61F. If there is none, 'I cannot do that.'
D $946F Finally, if the action really happened and the player did it in the dark, the darkness message is printed, and #R$953F gives any character involved as target or instrument a chance to react (#R$99FB).
C $9473 Does the action make sense (not done to yourself, and so on)?
C $9476 No: "I cannot do that."
C $9479 Is it too dark for Bilbo to see?
C $947C No: carry on
C $947E Dark. Can this action be done in the dark anyway?
C $9482 No: "I see nothing"
C $9484 Is the target something Bilbo is holding?
C $9487 No: "I see nothing"
C $9489 Is the instrument something he is holding?
C $948F Yes: he can manage by touch
C $9491 "I see nothing."
C $9499 Is the target a room?
C $949E Yes: straight to the default handler
C $94A1 Is there a target?
C $94A6 No: straight to the default handler
C $94A9 IX = the target's record...
C $94AC ...which is saved for the handlers
C $94B0 Is it within the player's reach?
C $94B6 No: stop (the reason has been printed)
C $94B8 Is there an instrument?
C $94BD No: use the target's handlers
C $94BF Is the instrument a room?
C $94C4 Yes: default handler
C $94C6 IX = the instrument's record...
C $94CC ...saved for the handlers
C $94D0 Is it within reach?
C $94D3 No: stop
C $94D5 Is this one of the actions the instrument handles (PUT IN, TAKE OUT OF...)?
C $94D8 Yes: use the instrument's handlers (IX is still its record)
C $94DA Otherwise use the target's
C $94DE A = the action
C $94E1 Does the object have its own handler for it?
C $94E4 No: use the default handler
C $94E6 HL = the handler...
C $94EC ...run it
C $94EF Next entry in the list
C $94F5 Is it action 0 (a chained handler)?
C $94F9 Yes: run that too
C $94FB Did the action really happen?
C $9500 No: done
C $9502 Was it the player?
C $9507 No: skip
C $9509 If the player is in the dark, add "it is dark."
C $950F B = the action
C $9513 Let the target react (a character that was attacked, say)
C $951D Let the instrument react too
C $952C DEFAULT HANDLER: look the action up in #R$C61F
C $9536 Found?
C $9538 Yes: run it
C $953A No: "I cannot do that."
c $953F Let a character react to what was done to it
D $953F If the object at IX is a living character (bit 6 of its flags set, bit 3 clear), #R$99FB is called with the action number in B, which may switch the character to a new behaviour (for example, to fight back when attacked).
R $953F Input:IX Object record
R $953F B Action number
C $953F Is the object at IX a living character?
C $9543 No: nothing reacts
C $9544 Is it already dead?
C $9548 Yes: the dead do not react either
C $9549 Give it a chance to switch its behaviour in response to what was just done to it
c $954D Is it too dark for Bilbo to see?
D $954D Returns with the carry flag set (and HL pointing at the message 'it is dark.') if the player is acting and cannot see. Characters are never affected: they can always see.
D $954D Bilbo can see if he is inside something (#R$9DC8) or if his room is lit (bit 7 of the first byte of its record). Otherwise he can only see if the short strong sword (object 14, record at #R$C00B + $1E9 = #R$C1F4) is with him (#R$9D86) and its flags have bit 2 set, bit 3 (broken) clear and bit 4 ('on') set. In other words, the sword is the game's only lamp: it glows, as Sting does in the book. The sword starts with these bits set, so carrying it lights up every dark place.
R $954D Output:F Carry set if it is too dark
R $954D HL "it is dark."
C $954D Is the current actor Bilbo?
C $9551 No (a character): they can always see - return with no carry
C $9552 Yes: save IX and BC
C $9555 IX = Bilbo's own record
C $9559 Is he shut inside something closed, or out in the open (or inside something open)?
C $955C ($FF, "loose", becomes 0 here)
C $955D Shut away: check the sword instead, below
C $955F Out in the open: IX = his own room's record
C $9562 Is the room lit?
C $9566 Yes: he can see (no carry)
C $9568 No, or shut away: save IY
C $956A IY = the short strong sword's own record
C $956E Is the sword near Bilbo?
C $9571 Restore IY
C $9573 It is not: dark, below
C $9575 It is near: A = the sword's own flags
C $9578 Flip every flag bit except "broken"...
C $957A ...then keep just "full", "broken" and "on": zero here means full=1, broken=0, on=1 - the sword is glowing
C $957C If so, he can see
C $957E "it is dark."
C $9581 Set the carry flag: it is too dark
C $9582 Restore BC and IX
C $9586 Clear the carry flag: he can see after all
c $9589 Describe the room through a door
D $9589 Describes the room the actor is (temporarily) in, starting with '<actor> see' instead of 'you are in'. Used by #R$8E4E to show what can be seen through an open door or across a river.
C $9589 "you see"
C $958C Join the shared room-description code below, using this heading instead of "you are in"
c $958E Describe a room
D $958E Prints the full description of room A. The message used for this is 'you are <preposition> ...' at #R$AEEE, and before printing it this routine writes the room's preposition - OUTSIDE, INSIDE, IN, ON or AT, chosen by bits 1-3 of the room's first byte from #R$B970 - into the message itself, at #R$AEEF. So the text of the message is changed each time a room is described. #R$95B9 then does the rest.
R $958E Input:A Room number
C $958F IX = the room's record
C $9592 Bits 1-3 of its flags choose the preposition
C $959A HL = the table of prepositions
C $959E DE = OUTSIDE, INSIDE, IN, ON or AT
C $95A1 Write it into the message "you are ..." (high byte first)
C $95A8 HL = that message
C $95B0 Describe the room
c $95B9 Describe a room (continued)
D $95B9 Prints the room's name from its word list, or its own description script if bytes 8-9 of the room record are non-zero (#R$95E4). Then the room's picture is drawn if it has one (#R$8965); if it did, the game waits for a key (#R$95F8) so the player can look at it. Then the doors (#R$9FF8), the visible exits (#R$A068) and the objects and characters present (#R$9EDD) are listed.
C $95B9 B = the room
C $95BA IX = its record
C $95BD Print "you are in" (or a short heading from the caller)
C $95C0 Does the room have its own description script?
C $95C8 Print that, or else the room's name
C $95CB Draw its picture, if it has one
C $95CF Was there a picture?
C $95D3 If so, wait for a key so it can be looked at
C $95D6 New line
C $95D9 "to the east there is the round green door" and so on
C $95DD "visible exits are: ..."
C $95E1 Finish with "you see: ..."
c $95E4 Print a room's name or description
D $95E4 If Z is reset, HL is a description script and it is printed. Otherwise the three name words of the room (from offset 2 of the record at IX) are printed with #R$9E1F.
C $95E4 Does the room have its own description script (rather than needing its name printed)?
C $95E7 A room's own name words start 2 bytes into its record
C $95EA Save the caller's IY
C $95EC Copy the room's record into IY as well...
C $95F0 ...then move it on to the name words
C $95F2 Print the room's own name (as a noun with adjectives)
C $95F5 Restore the caller's IY
c $95F8 Wait for a key after a picture
D $95F8 Waits until a key is pressed, then resets the border to white (the picture may have changed it).
C $95F8 Is a key already being held down (so we should wait for it to be released first)?
C $95FD Yes: keep waiting
C $9601 A key has been pressed: reset the border to white (a picture may have changed its colour)
c $9606 Describe a room briefly
D $9606 Prints the name of room A (#R$95E7) and a new line, and then carries on with the doors, exits and contents as in #R$95B9 (#R$95DD), without the picture.
C $9606 IX = room A's own record
C $9609 Print its name
C $960C New line
C $960F Join the rest of the full room description (doors, exits and contents), skipping the picture
c $9611 End of turn: run the timers
D $9611 Called once per turn after the player's command. First #R$A8CA and #R$976C (via #R$9618 and #R$961B) let the other characters take their turns, then the timer table at #R$C973 is processed.
D $9611 Each 7-byte timer entry has: a reload value, the current count, the address of an 'expire' routine, a threshold, and the address of a 'tick' routine. A count of 0 means the timer is not running. For each running timer the count is decremented (#R$963B). If it has just reached 0, the expire routine is called (#R$9657). If it is still above 0 but at or below the threshold, the tick routine is called instead (#R$966E).
D $9611 Only one timer is allowed to expire per turn: the flag at $B5E1 records that one has already fired, and any other timer that reaches 0 in the same turn is given a count of 1 so that it fires next turn instead.
D $9611 Timers are started by setting their count to their reload value, which various event routines do by copying byte 0 of the entry to byte 1 (for example #R$C6CC).
C $9611 Save the registers: the end of the turn must not disturb the caller
C $9618 Has the game been won (treasure in the chest)?
C $961B Let every other character take its turn
C $961E No timer has expired yet this turn
C $9622 From now on things really happen: set the "would work"...
C $9626 ...and "really do it" flags
C $9629 IY = the first timer entry
C $962D Fetch its reload value
C $9630 $FF marks the end of the table
C $9632 All timers done: finish
C $9634 A = the timer's count
C $9637 Is the timer running?
C $9639 No: next timer
C $963B Count down one turn
C $963F Has it reached 0?
C $9641 Not yet: see whether it is time for the tick routine
C $9643 It has expired. Has another timer already expired this turn?
C $9648 Set the count to 1 if so (so it fires next turn) or leave it at 0
C $964B Another timer has fired: wait until next turn
C $964D This is the first: note that a timer has fired this turn
C $9651 HL = the expire routine...
C $9657 ...and run it
C $965A Next timer
C $965C A = the threshold for the tick routine
C $965F Is there one?
C $9661 No: next timer
C $9663 Is the count at or below the threshold?
C $9666 No: next timer
C $9668 HL = the tick routine...
C $966E ...and run it
C $9671 Move on to the next 7-byte entry
C $9676 Loop
C $9679 Turn output back on for the player
C $967E Restore the registers
c $9686 Is the object within the player's reach?
D $9686 Stops the player using something that another character is holding. Characters are not subject to this check, and neither are objects that nobody is holding or that Bilbo himself is holding (directly or inside something he carries).
D $9686 If object A is held by a living character, and Bilbo is visible, the game says, for example, 'gandalf is carrying the curious map.' and returns with Z reset: the action is not allowed. But if Bilbo is invisible - wearing the ring clears bit 7 of his flags - the check is skipped, and he can take things straight out of other characters' hands.
R $9686 Input:A Object
R $9686 Output:F Z reset if the object is out of reach
C $9686 Nothing at all?
C $9688 Then there is nothing to check
C $968E B = the object
C $968F Is the actor Bilbo?
C $9694 Yes: check
C $9696 A character: always allowed (Z set)
C $969A IX = the object's record
C $969D Is anyone holding it?
C $96A2 No: allowed
C $96A5 IY = the object's record
C $96A9 Is Bilbo holding it (perhaps inside something)?
C $96AC Yes: allowed
C $96AE IX = the holder's record
C $96B1 Is the holder a living character?
C $96B5 No (a box, a table): allowed
C $96B7 Is Bilbo visible?
C $96BC No - he is wearing the ring: allowed
C $96BE Push the object's name...
C $96C5 ...and the holder's
C $96CC "gandalf is carrying the curious map."
C $96D2 Not allowed: return with Z reset
c $96DA Kill the target
D $96DA Loads the target ($B5D9) and continues into #R$96DD. Used by BURN (#R$A232).
C $96DA A = the target of the current command (falls straight into #R$96DD, which kills character A)
c $96DD Kill a character
D $96DD If A is 0, it is Bilbo who has died, and #R$903C ends the game. Otherwise the character's dead flag (bit 3) is set, everything it carries is dropped where it stands (#R$9CA8), it is removed from the character table (#R$C9BA) so it no longer acts, its adjectives are replaced by DEAD (#R$A0BC), and any orders waiting for it are cancelled (#R$894D).
R $96DD Input:A Character
C $96DD Is it Bilbo (object 0)?
C $96DE Yes: the game is over
C $96E6 C = the character
C $96E7 IX = its record
C $96EA Mark it dead
C $96EE It drops everything it carries
C $96F2 Find it in the character table
C $96F8 Not there: skip
C $96FA Clear its slot: it will never act again
C $96FE Its adjective becomes DEAD
C $9702 Cancel any orders it was given
c $970B Choose the random features of a new game
D $970B Called at the start of every game. It makes Bilbo the actor and then makes two random choices.
D $970B The hidden route: one of five exits listed in the table at #R$C6FD is chosen (a random number 1-5 from #R$9BF4) and blanked out in its room record, so that way is closed. The address of the chosen entry is written into the instruction at #R$A6C3, where Elrond will need it (#R$A6B8). The candidates are the exits from Beorn's house to the great river, from the forest gate to the bewitched gloomy place, from the treeless opening to the goblins' outside gate, from the long lake to lake town, and from the misty mountain to the narrow place. Because of the way #R$9BF4 works, the first and last are chosen half as often as the others.
D $970B Gollum's riddle: one of the four entries at #R$C6EB is chosen (each equally likely) and its address stored at $B5DF (see #R$A7C6).
C $970B Bilbo is the actor...
C $970F ...the map has not been read...
C $9712 ...and Gollum is not waiting for an answer
C $9715 The actor's record is Bilbo's
C $971B Pick a random number from 0 to 4...
C $9720 ...plus 1: one of the five hidden routes
C $9722 IY = the route table
C $9726 Six bytes per entry
C $9729 Step to the chosen entry
C $972D Write its address into the LD IY instruction in Elrond's map routine (#R$A6B8)
C $9731 HL = the address of the exit in the room record
C $9737 Blank out its three bytes: the way is closed
C $973E Pick a random number from 0 to 3...
C $9743 ...times 4...
C $974A ...to choose one of the four riddle entries
C $974E Remember it for Gollum
c $9752 Print a message and end the sentence
D $9752 Prints the message at HL, then a full stop and a new line.
C $9752 Print the message
C $9755 "."
C $975A New line
c $975D Is the action really happening?
D $975D Returns to the caller only if both $B5EB (really do it) and #R$B5EC (it would work) are set. Otherwise it discards the caller's return address, so the caller returns at once.
C $975D Save BC
C $975E B = "it would work", C = "really happening"
C $9763 Are both true?
C $9764 Yes: carry on normally
C $9766 No: discard the caller's own return address too...
C $9767 ...so control passes back one level further, skipping whatever the caller was about to do
s $9769
c $976C Let the other characters act
D $976C This is The Hobbit's famous 'independent characters' system. Every character in the table at #R$C9BA gets a turn after the player.
D $976C Each entry of that table is 7 bytes: the character's object number (0 if the character is dead or gone), a count used by #R$99B4, the address of the character's current place in its behaviour program, the address of its reaction table, and a 'stubbornness' value used by #R$8F9E.
D $976C For each living character, the character becomes the current actor (#R$B5DB, $B5FC) and the room it starts the turn in is noted ($B5E7). Output is switched on only if Bilbo can see the character (#R$9D77), so the player sees only what happens in front of him. If Bilbo is in the dark, the first character to do anything in his room produces 'you hear a noise.' instead (#R$AF19).
D $976C A character that is inside something (held by an object rather than standing in a room) tries to get out first (#R$9A71).
D $976C Then the character's behaviour program is run. Each instruction starts with a byte whose low nibble is its type and whose high bits are flags: bit 4 'jump afterwards to the address that follows', bit 5 'do this only once' (the instruction is cleared to 0 after use), bit 6 'do not take orders at this point'. The types are:
D $976C #LIST { 0-3: do an action. The next three bytes are the action, the target and the instrument (#R$9883). If bit 0 of the flags is set, the next two bytes are instead the address of a routine that does something special - most of the routines in the range #R$A406-#R$A91B are such character routines. } { 4: do an action without objects, such as moving in a direction (#R$98CF). An action of $FF just jumps. } { $0C: change the character's reaction (#R$99FB). } { $0E: jump to the address that follows. } { $0F: choose at random one of the behaviours in the reaction table (#R$99B4). } { anything else: go back to the first behaviour in the reaction table. } LIST#
D $976C Before the program, if the player has given the character an order (#R$88FD) and the current instruction allows it (bit 6 clear), the order is obeyed instead (#R$8907, #R$9929).
D $976C A character stops after 6 instructions in one turn (#R$9769). At the end the player becomes the actor again, with output switched on.
C $976C Note Bilbo's room and whether he is in the dark
C $976F IY = the first entry of the character table
C $9773 Reset the count of instructions tried by this character
C $9777 A = the character's object number
C $977A End of the table?
C $977C Yes: all done
C $977F 0 means a dead character or an empty slot
C $9781 Skip it
C $9784 Make the character the current actor
C $9787 A = its room, IX = its record
C $978A Its record is the actor's record...
C $978E ...and its room is the room it starts the turn in
C $9791 Switch output off until we know Bilbo can see
C $9797 IY = Bilbo's record
C $979B Can Bilbo see the character?
C $97A0 No: its actions will not be printed
C $97A2 Has "you hear a noise" already been printed this turn?
C $97A7 Yes: keep quiet
C $97A9 Output on: Bilbo can see what the character does
C $97AE Is Bilbo in the dark ($976A = 1)?
C $97B3 No: carry on
C $97B5 Yes: remember that the noise has been heard ($976A = 2)
C $97B9 "you hear a noise."
C $97BF And switch output off: Bilbo sees nothing
C $97C3 Is the character held by something?
C $97C8 Yes: try to get out instead (#R$9A71)
C $97CB IX = the character's record
C $97CF Has the player given it an order?
C $97D2 $B5E5 = 1 if so, 0 if not
C $97DA HL = where the character has got to in its behaviour program
C $97E0 Has the character already tried six instructions this turn?
C $97E5 Yes: that is enough, next character
C $97E7 A = the instruction byte
C $97E8 DE = 4, the length of an action instruction
C $97EB IX = the instruction
C $97EE The low nibble is the instruction type
C $97F0 Types 0-4 are actions
C $97F2 Types 5 and up: go and decode them
C $97F4 An action instruction. Is an order from the player waiting?
C $97F9 No: carry out the program
C $97FB Does this instruction refuse orders (bit 6)?
C $97FD Yes: carry out the program
C $97FF The order is being dealt with now
C $9804 Match the order to an action and objects
C $9807 It cannot be done: carry on with the program instead
C $9809 The order will be obeyed for real
C $9811 Arrange to go on to the next character afterwards
C $9817 Do it (#R$9921), then return to #R$985C
C $981A Fetch the instruction type again
C $981D Type 4: an action without objects
C $9822 Types 0-3: an action with objects, or a routine
C $9824 (Not reached)
C $9826 Type $0E: go to
C $982A Store the address that follows as the new program position
C $9836 And carry on from there, in the same turn
C $9838 Type $0C: change behaviour on a named action
C $983C B = the action
C $983F A = this character
C $9842 Switch to its reaction for that action
C $9845 Carry on
C $9847 Type $0F: pick a behaviour at random
C $984E Carry on
C $9850 Type 0 would skip the instruction here, but types below 5 never get this far
C $9857 Any other type: return to the default behaviour (reaction table entry 0)...
C $9859 ...and end this character's turn
C $985C Next character: entries are 7 bytes long
C $9864 All characters done: Bilbo is the actor again
C $9868 Output back on
C $986C The actor's record is Bilbo's
c $9873 Advance a character's program pointer
D $9873 Moves the program pointer past the current instruction (HL+DE), skipping two more bytes if bit 4 of the instruction says a jump address follows, and stores it in the character's table entry.
C $9873 Move past this instruction
C $9874 Does it have a "failure address" that follows it?
C $987A If so, skip past that too
C $987C Store the new position back into the character's own table entry
c $9883 Character instruction: do an action
D $9883 Carries out an action instruction from a character's behaviour program. Normally the three bytes after the instruction byte give the action, the target and the instruction (#R$B5D8-#R$B5DA) and #R$9921 tries it. If bit 0 of the instruction byte is set, the next two bytes are the address of a special routine, which is called first as a dry run and, if it says it would work, for real.
D $9883 If the action worked, and the instruction has a jump address (bit 4), the program jumps there. If bit 5 is set the instruction is erased so it will not be done again.
C $9883 Move the program pointer past this instruction (and its failure address, if any)
C $9886 Is it a call to a special routine (bit 0)?
C $988A Yes
C $988C The action...
C $9892 ...the target...
C $9898 ...and the instrument
C $989E Try it
C $98A1 It failed
C $98A3 It worked
C $98A5 HL = the special routine
C $98AB Run it first as a dry run: "really do it" off...
C $98AF ...and "would work" off
C $98B5 Did it say it would work?
C $98BA No: it failed
C $98BC Yes: run it again for real
C $98C2 Success. Is this a once-only instruction (bit 5)?
C $98C6 No: this character's turn is over
C $98C9 Yes: wipe out its instruction byte
C $98CD Turn over
c $98CF Character instruction: action without objects
D $98CF The byte after the instruction is an action with no target or instrument (typically a movement direction, so a character's program can be a route), tried with #R$9921. An action of $FF means 'jump to the address that follows' if bit 4 is set. The entry at #R$9905 counts the instructions done this turn and follows jump addresses.
C $98CF This instruction is 2 bytes long (plus a failure address)
C $98D2 Move the program pointer past it
C $98D5 A = the action
C $98D8 $FF: no action at all?
C $98DA Yes
C $98DC Set the action...
C $98DF ...with no target or instrument: the game will choose them
C $98E7 Try it
C $98EA It failed
C $98EC It worked: turn over
C $98EF No action. Is there an address after it (bit 4)?
C $98F3 No: just end the turn (the character waits)
C $98F6 Yes: jump there next turn
C $9902 Turn over
C $9905 FAILURE: count it (six failures end the turn)
C $9909 Is there a failure address (bit 4)?
C $990D No: go on to the next instruction
C $9910 Yes: fetch it...
C $9918 ...make it the program position...
C $991E ...and carry on from there, in the same turn
c $9921 A character tries an action
D $9921 Checks with #R$84E6 whether the action would work; returns with Z set if not. Otherwise the action is reported (#R$7122) and performed (#R$946F), and the routine returns with Z reset.
D $9921 The report is the tricky part, because Bilbo may be able to see only part of what happens. Actions on rooms, and GO THROUGH by a character that did not start in Bilbo's room, are not reported. If the target is a door (something in two places) and the character is on the other side of it from Bilbo, the report is printed with the actor replaced by $FF, so Bilbo reads 'someone opens the door' - he sees the door open but not who opened it.
D $9921 Afterwards #R$9A28 prints '<character> enters.' if the character has just come into Bilbo's room, and '<object> appears.' if the target has.
R $9921 Output:F Z set if the action would not work
C $9923 Would the action work?
C $9926 No: return with Z set
C $9929 Is the target a room?
C $992E Yes: do it without a report
C $9930 Is it GO THROUGH (action 30)...
C $9937 ...by a character that did not start the turn in Bilbo's room?
C $993E Then do it without a report
C $9940 Is there a target?
C $9945 No: report normally
C $9947 A = the target's room
C $994A (remember it)
C $994D Is it in one place?
C $994F Yes: report normally
C $9951 A door. C = Bilbo's room, B = the character's room
C $9956 The same room?
C $9957 Yes: report normally
C $9959 Is Bilbo on one side of the door?
C $9965 No: report normally
C $9967 Yes, and the character is on the other side:
C $996B the actor becomes "someone"...
C $9970 ...output is switched on...
C $9977 ...and Bilbo reads "someone opens the door"
C $997C Output off again
C $9980 Restore the actor
C $9988 Report the action
C $998D Do it
C $9990 Has the character just come into Bilbo's room?
C $9996 "<character> enters."
C $999C Unless the target is a room...
C $99A3 ...has the target just appeared in Bilbo's room?
C $99A9 "<object> appears."
C $99AF Return with Z reset: the action worked
c $99B4 Choose a behaviour at random
D $99B4 Picks a random entry (#R$9BF4) from the character's reaction table (the address at offset 4 of its table entry) and makes it the character's current behaviour program. The range is the smaller of byte 1 of the instruction and byte 1 of the character's table entry. The entry at #R$99C3 selects entry E instead.
C $99B4 A = the range given in the instruction...
C $99B7 ...but no more than the character's own limit
C $99BF Pick a random entry number
C $99C3 (Entry point with E already set) Make sure it is within the limit
C $99CA HL = the reaction table
C $99D2 Three bytes per entry
C $99D5 Skip the action byte
C $99D6 DE = the program address
C $99D9 Make it the character's program
c $99E0 Find a character's table entry
D $99E0 Searches the character table #R$C9BA for character A and returns IY pointing at its entry (or at the $FF end marker, with A=$FF, if it is not there).
R $99E0 Input:A Character
R $99E0 Output:IY Table entry
C $99E0 Save DE and BC
C $99E2 B = the character being searched for
C $99E3 HL = the start of the character table
C $99E9 A = this entry's own character number
C $99EA Is it the one we want?
C $99ED Is this the end of the table?
C $99F1 Neither: move on to the next entry
C $99F5 Found it (or reached the end): restore BC and DE
C $99F7 IY = the entry (or the end marker)
c $99FB Change a character's behaviour
D $99FB Looks for action B in the reaction table of character A (a list of 3-byte entries: action and program address). If found, the character's current program is switched to that address. This is how characters respond to what happens to them: for example the reaction to ATTACK is to fight back.
R $99FB Input:A Character
R $99FB B Action
C $99FF IY = the character's table entry
C $9A02 Is it a character?
C $9A04 No: nothing to do
C $9A06 IX = its reaction table
C $9A0F A = the action that was done to it
C $9A10 Is there a reaction to it?
C $9A15 No: carry on as before
C $9A17 Yes: switch its program to the reaction
c $9A28 Report that a character has arrived
D $9A28 Prints the message at DE (for example 'thorin enters.' or 'X appears.') with the object's name, if object A has just arrived in the room where Bilbo is ($B5E6), was not there before ((HL)), and Bilbo is not in the dark.
C $9A28 Is there actually no object at all?
C $9A2A If so, there is nothing to report
C $9A2B Is it object 0 (Bilbo himself)?
C $9A2C If so, do not announce his own arrival
C $9A2D B = the object
C $9A2E Is Bilbo in the dark?
C $9A33 Yes: he would not see this anyway
C $9A34 A = the object again
C $9A35 A = its own room
C $9A39 Was it already in that room before this turn?
C $9A3A Yes: nothing has changed, no need to announce it
C $9A3B Is that room the one Bilbo is actually in right now?
C $9A3F No: he would not see it arrive
C $9A40 Was Bilbo himself just moved along with it (e.g. carried in a barrel)?
C $9A44 No: report it as usual, below
C $9A45 Yes: switch output on, since this is happening right in front of him
C $9A4A HL = whichever "enters"/"appears" message the caller is using
C $9A4C IX = the object's own record
C $9A50 Save DE
C $9A51 IX = the object's own words
C $9A56 Restore DE
C $9A57 Push the object's name as the message parameter
C $9A59 Print the message
c $9A5D Prepare for the characters' turn
D $9A5D Notes the room Bilbo is in ($B5E6, #R$9ECB) and whether it is dark there ($976A). It is also the default handler for action 0 in #R$C61F, which makes it a harmless 'do nothing special' routine.
C $9A5D A = 0 (Bilbo)
C $9A5F A = Bilbo's own room
C $9A62 Remember it, for #R$9A28 and the character loop to compare against
C $9A65 Is it too dark for Bilbo to see?
C $9A68 Assume not
C $9A6C It is dark
C $9A6D Remember whether Bilbo is in the dark, for the rest of this turn
c $9A71 A character tries to get out of something
D $9A71 Called when a character is being held by an object (for example shut in a barrel or a cell). If the holder is dead or alive (i.e. another character is carrying this one), nothing special happens. If it is a closed object, the character does nothing this turn. If it is open, the character tries action 55, CLIMB OUT OF.
C $9A71 No instrument for this
C $9A76 A = whoever (or whatever) is holding the character
C $9A79 That becomes the target
C $9A7C IX = the holder's own record
C $9A7F Is the holder dead (e.g. another character just killed)?
C $9A83 Yes: the character can simply act as normal, as if not held at all
C $9A86 Is the holder actually alive (another character carrying this one)?
C $9A8A Yes: likewise, act as normal
C $9A8D Otherwise it is a container: is it open?
C $9A91 No: stuck for this turn - move on to the next character
C $9A94 Yes: try to climb out (action 55)
C $9A99 Try it
C $9A9C Then move on to the next character regardless
c $9A9F Is the action sensible?
D $9A9F Returns with Z set if the action cannot make sense: the target is the actor, or the instrument is the target, or the instrument is the actor. A missing target ($FF) is always fine.
R $9A9F Output:F Z set if the objects are not sensible
C $9A9F Is there actually no target at all?
C $9AA5 If so, that always makes sense: A becomes non-zero (Z reset)
C $9AA7 Is the target actually a room (rather than an object)?
C $9AAB Yes: a room can never be "the same as the actor", so skip that check
C $9AAD No: is the target the same as the actor?
C $9AB4 Yes: that makes no sense (Z set)
C $9AB5 Is the instrument the same as the target?
C $9AB9 Yes: that makes no sense either
C $9ABA Is the instrument actually a room too?
C $9ABE Yes: skip the last check
C $9ABF No: is the instrument the same as the actor?
C $9AC6 Z set means it is, and so makes no sense
c $9AC7 Call the routine at HL (if HL is not 0)
D $9AC7 A general dispatcher used throughout the game for tables of routine addresses (the room-entry handlers, the timer table, the character table). All registers except AF are preserved, and a zero address means 'no routine', so tables can leave entries empty. The actual call is made by the JP (HL) at #R$9ADB.
R $9AC7 Input:HL Routine address, or 0
C $9AC7 Save every register the routine we are about to call might disturb...
C $9ACD ...including HL itself, which holds the address to call
C $9ACE Is that address 0, meaning "there is nothing to call"?
C $9AD0 If it is not 0, make the call
C $9AD3 Restore the registers, in the same order they were saved...
c $9ADB Jump to HL
D $9ADB The JP (HL) used by #R$9AC7.
C $9ADB Jump to the routine at HL
c $9ADC Find an object's handler for an action
D $9ADC Searches the list of action handlers at the end of the object record at IX (after the header, the four word slots and its location bytes; see #R$C00B) for action A, using #R$9D12. As with #R$9D12, the found/not-found sense is NZ/carry set = found, Z set = not found - the opposite of what the names Z and 'zero' suggest. Returns IX at the matching entry (or the list's $FF terminator).
R $9ADC Input:A Action
R $9ADC IX Object record
R $9ADC Output:F NZ or carry set if the object has its own handler for the action; Z set if not
C $9ADC Save DE for the caller
C $9ADD D = the action we are looking for a handler for
C $9ADE A = the number of locations this object has (1 for most things, 2 for a door)...
C $9AE1 ...plus 16, the size of the record's fixed part: this gives the offset, from the start of the record, to where its own list of action handlers begins
C $9AE3 E = that offset
C $9AE4 D = the action again...
C $9AE7 IX = the start of this object's own list of handlers
C $9AE9 Search that list for the action (see #R$9D12: NZ or carry set means found)
C $9AEC Restore the caller's DE
c $9AEE Get the next entry of a 3-byte table
D $9AEE Moves IX on to the next 3-byte entry of a table such as the object index (#R$BF53), returning the key in A and the address it holds in IY. Returns with Z set at the end of the table ($FF). The alternate registers are used so that BC, DE and HL are preserved.
C $9AEE Switch to the alternate registers, so this does not disturb the caller's own BC, DE and HL
C $9AEF DE = 3, the size of one entry
C $9AF2 Move IX on to the next entry
C $9AF4 DE = the 16-bit value stored in this entry (e.g. a record address)...
C $9AFA ...moved into IY for the caller to use
C $9AFD A = this entry's own key
C $9B00 Is it the table's $FF terminator?
C $9B02 Switch back to the caller's own registers
C $9B03 Z set means the terminator was reached; NZ means a genuine entry was found
c $9B04 Get the next object
D $9B04 As #R$9AEE, but preserving B.
C $9B04 Save the caller's own B (and pass the incoming A through it)
C $9B06 Step to the next entry, exactly as #R$9AEE
C $9B09 Restore A to what it was before the call (so the caller's own "target" or "actor" number survives)
C $9B0A Restore the caller's B
c $9B0C Get the address of a room record
D $9B0C Returns the address of the record for room number A (0-79) from the room pointer table at #R$B8D0. Numbers of $50 (80) and above are not rooms; for those, A is set to 0 and the routine returns with the Z flag set.
R $9B0C Input:A Room number
R $9B0C Output:IX Room record
C $9B0C Is the room number 80 or higher (not a real room)?
C $9B0E No, it is a real room: go and find its record
C $9B10 Not a real room: return 0, with Z set, so the caller knows there is no such room
C $9B12 Save DE for the caller
C $9B13 HL will point into the room pointer table, which starts here
C $9B16 Save HL for the caller
C $9B17 HL = the room number...
C $9B1A ...doubled, because each room has a 2-byte entry in the table
C $9B1B HL = the address of this room's entry in the pointer table
C $9B1C DE = the room's record address, read from the table (low byte)...
C $9B1E ...then the high byte
C $9B1F Move that address onto the stack for a moment...
C $9B20 ...so it can be popped straight into IX, the register the rest of the game expects a room record in
C $9B22 Restore the caller's HL
C $9B23 Restore the caller's DE
c $9B25 Get the address of an object record
D $9B25 Looks up object number A in the object index table at #R$BF53 (using #R$9D12) and returns the address of its record in IX. Everything that can be manipulated - Bilbo himself (object 0), the other characters, doors, food, weapons, keys - is an 'object' with a record in #R$C00B.
R $9B25 Input:A Object number
R $9B25 Output:IX Object record
C $9B25 IX = the start of the object index, the master list of every object and its record address
C $9B29 Search the index for object A
C $9B2C Save HL for a moment
C $9B2D HL = the object's record address, read from the matching entry (low byte)...
C $9B30 ...then the high byte
C $9B33 Swap it onto the stack in place of the saved HL, so the address can be...
C $9B34 ...popped straight into IX, the register the rest of the game expects an object record in
b $9B37 Bilbo-moved flag
D $9B37 Cleared by #R$9B6C when Bilbo is among the things moved along with an object, so that #R$9B38 knows to describe his new surroundings.
B $9B37,1,1
c $9B38 Move an object and everything it holds
D $9B38 Moves everything held by object A (and everything they hold, recursively, #R$9B6C) to room B. If Bilbo was among the things moved (for example he was inside the barrel when it floated away, or was carried off), the room he has arrived in is entered and described (the entry at #R$8DC1 in #R$8D19).
R $9B38 Input:A Object
R $9B38 B Room
C $9B38 Assume, for now, that Bilbo is among the things being moved
C $9B3D Move everything object A holds into room B (this clears the flag above if Bilbo is not actually among them)
C $9B40 Was Bilbo actually moved?
C $9B42 No: nothing more to do
C $9B43 Yes: save the flag's own address
C $9B44 Save the current actor...
C $9B48 ...and the current actor's record
C $9B4C Make Bilbo the actor for a moment...
C $9B56 ...and pretend he has just moved in direction B (used only to set the "destination room" variable read below)
C $9B5A Enter the new room and describe it, exactly as an ordinary move does
C $9B5D Update where Bilbo is, for the rest of this turn
C $9B60 Restore the real actor's record...
C $9B64 ...and the real actor
C $9B68 Restore the flag's address
C $9B69 Clear it, ready for next time
c $9B6C Move the contents of an object
D $9B6C Sets the location of every object held by object A to room B, and does the same for their contents. Clears #R$9B37 if Bilbo (object 0) is one of them.
C $9B6C Save IY and IX
C $9B70 IX = just before the start of the object index
C $9B74 Look at the next object; IY = its own record
C $9B77 No more objects: finished
C $9B79 Is it held by the object we are moving?
C $9B7C No: try the next one
C $9B7E Yes: its own location becomes room B too
C $9B81 Save this object's number
C $9B82 Is this object Bilbo himself?
C $9B88 If so, clear the "Bilbo moved" flag: he has now genuinely been placed in the new room
C $9B8B Recursively move whatever THIS object holds too
C $9B8E Restore the object's number
C $9B8F Look for more things held by the original object
C $9B91 Restore IX and IY
c $9B96 How much room is left in a room?
D $9B96 Returns in A the free space in room A: byte 1 of the room record is the room's capacity, from which the size (byte 2) of every ordinary object there is subtracted. Returns 0 if the room is overfull.
R $9B96 Input:A Room
R $9B96 Output:A Free space
C $9B96 Save IX, IY and BC
C $9B9B B = the room being asked about
C $9B9C IX = its own record
C $9B9F C = its own total capacity
C $9BA3 Search every object in the game...
C $9BA7 Look at the next one; IY = its own record
C $9BAA No more objects: finished (below)
C $9BAC Is it an ordinary, single-place object?
C $9BB1 No (e.g. a door): does not count towards the room's capacity
C $9BB3 Is it actually in the room we are asking about?
C $9BB7 No: skip it
C $9BB9 Yes: subtract its own size from the space left
C $9BBD Already overfull: give up with 0 space left
C $9BBF Otherwise keep the smaller total
C $9BC0 Look for more objects
C $9BC2 A = the space left
C $9BC3 Restore BC, IY and IX
C $9BC9 Overfull: 0 space left
c $9BCD Is the actor holding the target?
D $9BCD Returns with carry set if the target ($B5D9) is held by the actor, directly or inside something the actor holds. The entry at #R$9BD0 does the same for object A. An object of $FF counts as held.
R $9BCD Output:F Carry set if held
C $9BCD A = the target of the current command
C $9BD0 HL = the address holding the current actor's number
C $9BD3 Is there no target at all ($FF)?
C $9BD5 If so, treat that as "yes, held" (set the carry flag), since there is nothing to fail the test
C $9BD7 Save the caller's IX
C $9BD9 Is the target held, directly or indirectly, by whichever object's number is stored at HL?
C $9BDC Restore the caller's IX
c $9BDF Is object A inside the holder at (HL)?
D $9BDF Follows the chain of holders of object A upwards; returns with carry set if (HL) is one of them.
C $9BDF IX = object A's own record
C $9BE2 Save the object's number for later
C $9BE3 A = whoever (or whatever) is holding it
C $9BE6 Is it held by nobody at all?
C $9BE8 Yes: it cannot be inside the thing we are looking for
C $9BEA No: throw away the saved object number from the stack (using IX only because it is a spare place to put it; A itself, still holding the holder's number, is untouched)
C $9BEC Is that holder the very thing we are testing against (the byte stored at HL)?
C $9BED Not yet: look inside the holder in turn, in case the object is nested more than one level deep
C $9BEF Found it: set the carry flag to say so
C $9BF1 Not held by anybody: restore the stack (the AF we saved earlier)
C $9BF2 Clear the carry flag: not inside
c $9BF4 Random number from 0 to A
D $9BF4 Returns the absolute value of a random number from -A to A (#R$9BFD). Because of the way #R$9BFD squeezes its random byte into range, the results are not all equally likely: for A=4, 0 and 4 come up half as often as 1, 2 and 3; for A=3 the four results are equally likely; for A=9 the higher numbers are favoured.
R $9BF4 Input:A Range
R $9BF4 Output:A Random number
C $9BF4 Get a random number from -A to +A
C $9BF7 Is it negative (bit 7 set)?
C $9BF9 No: a positive result is fine as it is
C $9BFA Yes: make it positive, since this routine only ever wants a number from 0 upwards
c $9BFD Random number in a range
D $9BFD Returns a random number in A in the range -C to +C (signed). The random byte is produced from the seed at #R$B5FE (set from the R register in #R$6C27), the counter at $B602 and a byte fetched from memory.
D $9BFD The random bytes come from memory itself. A 16-bit counter at $B602 is increased on every call and used as an address; the byte found there (and one a little further on) is mixed with the previous result. So the program code, the tables and even the ROM serve as the game's random number table, and the R register seed from the start of the game (#R$6C27) decides where the sequence begins. A result equal to the previous one is thrown away.
D $9BFD The way it narrows the random byte down to the range is unusual: B is set to 2*C, and then the random byte is halved (SRL A) until it is no more than B. Finally C is subtracted. Because 0-255 has to be halved several times, the upper half of the range gets far more than its share: with C=10, values 0-10 of the byte (results -10 to 0) mostly come only from the original byte being 0-10 directly, while 11-20 are hit by many different starting values. For C=10 the results come out approximately: each of -10 to -1: 1/256; 0: 16/256; +1 to +5: 31/256 each; +6 to +10: 15/256 each.
R $9BFD Input:C Range
R $9BFD Output:A Random value from -C to +C
C $9C00 C = the range
C $9C01 B = twice the range...
C $9C05 ...capped at 255
C $9C08 Advance the 16-bit counter at $B602-$B603
C $9C14 IX = the counter, used as an ADDRESS: it points somewhere in memory
C $9C18 A = the seed...
C $9C1B ...plus the byte at that address...
C $9C1E (move on by DE, whatever it happens to hold)
C $9C20 ...exclusive-ORed with the byte after
C $9C27 The same as the previous random number?
C $9C29 Yes: try again
C $9C2B Save it as the new seed
C $9C2E Is it within 0 to 2 x range?
C $9C33 No: halve it and try again (this is what skews the results)
C $9C38 Subtract the range to give -range to +range
c $9C3D Total size of an object's contents
D $9C3D As #R$9C42, but adding up the objects' sizes (byte 2) instead of their weights.
C $9C3D TOTAL SIZE: save the caller's BC
C $9C3E B=1 tells the shared routine below to add up sizes rather than weights
C $9C40 Join the weight routine, which does the actual work
c $9C42 Total weight of an object's contents
D $9C42 Returns in A the total weight (byte 3) of everything held by object A, including the contents of containers, found by #R$9C55. The result is $FF if it overflows.
R $9C42 Input:A Object
R $9C42 Output:A Weight
C $9C42 TOTAL WEIGHT: save the caller's BC
C $9C43 B=0 tells the shared routine below to add up weights
C $9C45 Save the caller's IX and IY, which the search below will use
C $9C49 C will be the running total, starting at 0
C $9C4B Add up everything object A holds
C $9C4E A = the finished total
C $9C4F Restore the caller's IY and IX
C $9C53 Restore the caller's BC
c $9C55 Add up the contents of an object
D $9C55 Recursive worker for #R$9C42 and #R$9C3D: for each object held by object A, adds its weight (or size, if B=1) to C, and for weights also the weight of its contents. The overflow test uses JP PE.
C $9C55 Save the caller's IX
C $9C57 IX = the start of the object index, ready to look at every object in the game in turn
C $9C5B Look at the next object: IY = its own record
C $9C5E Have we run out of objects (reached the index's terminator)?
C $9C60 No: is THIS object held by the one whose contents we are adding up?
C $9C63 It is not: move on and look at the next object
C $9C65 It is: save the object we are adding up for a moment (it is not disturbed by anything above)
C $9C66 Are we totalling weight (B=0) or size (B=1)?
C $9C68 A = the running total so far
C $9C69 Weight wanted: add this object's own weight instead (skip down)
C $9C6B Size wanted: add this object's own size (byte 2 of its record)
C $9C6E Did that go past 255? Then the whole total is unknowable - give up
C $9C71 Otherwise keep the new, larger running total
C $9C72 ...and go on to look inside this object too, in case it holds anything itself
C $9C74 Weight wanted: add this object's own weight (byte 3 of its record)
C $9C77 Did that go past 255? Then the whole total is unknowable - give up
C $9C7A Otherwise keep the new, larger running total
C $9C7B A = the object we just added in, so we can look inside it as well
C $9C7E Recursively add up whatever THAT object holds, in case it is itself a container
C $9C81 Restore the object we are totalling up (saved earlier)
C $9C82 Go back and look for more objects held by it
C $9C84 No more objects anywhere: restore the caller's IX
C $9C87 OVERFLOW: throw away the object number we had saved
C $9C88 The total becomes $FF, meaning "too big to say exactly"
C $9C8A Finish as normal
c $9C8C Get the actor's room record
D $9C8C Returns IX pointing at the record of the room the actor is in. AF is preserved.
C $9C8C Save AF, so this can be used freely without upsetting the caller's flags
C $9C8D IX = the current actor's own record
C $9C91 A = the actor's location (the first location byte of their record)
C $9C94 IX = that room's own record
C $9C97 Restore AF
c $9C99 Check for a dry run
D $9C99 The command routines are run more than once: first as a 'dry run' to find out whether a command is possible (for example while the parser is choosing between two objects that fit the same noun), and then for real. The flag at $B5EB is 1 when the action should really happen. If it is not, this routine sets #R$B5EC to record that the action would have succeeded, discards its own return address and returns to the caller's caller, so the rest of the command routine is skipped. That is why the fight routine calls this after rolling the attack value but before doing anything that has a visible effect.
C $9C99 Is this action really happening, or is it only being tried out to see if it would work?
C $9C9E Really happening: carry on with the rest of the routine as normal
C $9C9F Only a trial: record that it would succeed...
C $9CA3 ...then throw away the return address of whoever called us, so control passes back one level further, skipping the part of the routine that would actually change anything
c $9CA5 Drop everything the target holds
D $9CA5 Loads the target and continues into #R$9CA8. Used when a container is emptied or broken.
C $9CA5 A = the target of the current command (falls straight into #R$9CA8, which drops everything object A holds)
c $9CA8 Drop everything an object holds
D $9CA8 Makes everything held by object A the property of A's own holder (so things a dead character carried stay where it was). Things that evaporate (bit 1 of their flags) vanish instead, with 'X evaporates.'
C $9CAD IX = the object's record
C $9CB0 B = its holder: its things will belong to that
C $9CB3 Go through every object
C $9CB7 Next object
C $9CBA End of the list
C $9CBC Is it held by this object?
C $9CBF No: next
C $9CC1 Does it evaporate (bit 1)?
C $9CC5 No: pass it on
C $9CC8 Yes: it goes nowhere...
C $9CCC ...belongs to nobody...
C $9CD0 ...and is invisible
C $9CD4 Print its name
C $9CD7 "evaporates."
C $9CDE Next
C $9CE0 Give it to the object's own holder
C $9CE3 Next
c $9CEC Count the visible things an object holds
D $9CEC Returns in A the number of visible objects (bit 7 of their flags set) held directly by object A.
R $9CEC Input:A Object
R $9CEC Output:A Count
C $9CEC Save the caller's IX, IY and BC
C $9CF1 B will be the running count, starting at 0
C $9CF3 IX = just before the start of the object index, so the first search below lands on its very first entry
C $9CF7 Look at the next object; IY = its own record
C $9CFA Have we run out of objects?
C $9CFC No: is this object held by the one whose contents we are counting?
C $9CFF It is not: try the next one
C $9D01 It is: is it visible (not, say, a locked-away thing nobody can see)?
C $9D05 No: do not count it
C $9D07 Yes: one more to the count
C $9D08 Look for more
C $9D0B A = the final count
C $9D0C Restore the caller's IY and BC
C $9D0D Restore IY
C $9D0F Restore the caller's IX
c $9D12 Search a table of 3-byte entries
D $9D12 Searches a table at IX made of 3-byte entries, each a one-byte key followed by a two-byte value, for the key in A. The table ends with $FF. Returns with IX pointing at the matching entry if found, or at the terminating $FF entry if not. The flags are set by a final CP $FF on the entry's own key: Z is SET when that key is $FF, so Z RESET (NZ) means the search succeeded and Z SET means it ran off the end without a match; equivalently, the carry flag is SET when the entry was found. This is easy to get backwards, so callers are shown branching on NZ/carry for success and Z for failure throughout this disassembly. Used for the object index (#R$BF53), the room-entry handlers (#R$C67D) and several other tables.
R $9D12 Input:A Key
R $9D12 IX Table
R $9D12 Output:IX Matching entry, or the $FF terminator
R $9D12 F Z SET if not found (end of table); NZ or carry set if found
C $9D12 Switch to the alternate registers, so this search does not disturb the caller's own BC, DE and HL
C $9D13 HL = the table to search, taken from IX
C $9D16 B = the key being searched for
C $9D17 DE = 3: the size of one entry, ready for stepping through the table
C $9D1B A = this entry's key
C $9D1C Does it match what we are looking for?
C $9D1D Yes: stop here, with this entry found
C $9D1F No: is this the table's $FF terminator, meaning there are no more entries?
C $9D21 Yes: stop here too, empty-handed
C $9D23 Neither: move on to the next entry
C $9D24 ...and keep looking
C $9D27 Whichever way we stopped, move the address we ended up at into IX...
C $9D28 ...for the caller to use
C $9D2A Was that the $FF terminator (not found), or a genuine entry (found)? Z ends up SET when NOT found, so the caller should test NZ, or the carry flag, for success
C $9D2C Switch back to the caller's own registers
c $9D2E Find the next object that fits some words
D $9D2E Continues a search of the object index (from IX) for an object whose words match the noun and adjectives at HL (#R$71EA). The object must also match the filter in $B600: 0 for things that are not characters, 1 for characters, 2 for anything. Unless $B5FF says reach does not matter, the object must also be in the same place as the actor (#R$9D86). Returns the object in A, or $FF when there are no more.
C $9D2E Save the caller's BC, DE and IY
C $9D32 IY = the current actor's own record
C $9D36 D = the actor's room, in case the object must be close by to count
C $9D39 A = the filter the caller wants: 0 things that are not characters, 1 characters, 2 anything at all
C $9D3C E = that filter, kept for the tests below
C $9D3D Look at the next entry of the object index; A = its object number, Z set once we run out
C $9D40 No more objects: give up (A is left holding $FF)
C $9D42 Does the caller want absolutely anything (filter 2)?
C $9D45 Yes: skip the character/object test below entirely
C $9D47 No: A = this object's flags
C $9D4A Keep only whether it is alive and whether it is dead
C $9D4C Is it alive and NOT dead, i.e. a proper living character?
C $9D4E Assume it is not a character (0)...
C $9D50 ...unless it just proved to be alive and undead, in which case...
C $9D52 ...it counts as a character (1)
C $9D53 Does that match what the caller asked for?
C $9D54 No: try the next object
C $9D56 BC = 8: the offset, from the start of an object's record, to its own four word slots
C $9D59 Save IY (the object's record) for a moment
C $9D5B IY = the object's word slots
C $9D5D Do the noun and adjectives at HL match this object's own words?
C $9D60 Restore IY, the object's record
C $9D62 No match: try the next object
C $9D64 A match on words. Does this particular action not care whether the object is within reach?
C $9D68 It does not care: accept this object regardless of where it is
C $9D6A It does care: is the object near the actor?
C $9D6D No: try the next object
C $9D6F A = the object we settled on (or $FF if we ran right out)
C $9D72 Restore the caller's IY, DE and BC
c $9D77 Can the object at IY be seen from IX?
D $9D77 Swaps IX and IY around a call to #R$9D92.
C $9D77 Swap IX and IY over, so that whichever object was "the one being looked at" (IY) becomes "the one doing the looking" (IX), and vice versa
C $9D7A Now test whether the two are in the same place, with them the right way round for that test
C $9D7D (This same code, reused: falling in here after the test above swaps IX and IY straight back again, and its own RET then returns from this whole routine)
c $9D86 Is the object near the actor?
D $9D86 Calls #R$9D92 with IX = the actor's record: returns with Z reset if the object at IY is in the same place as the actor.
C $9D86 Save the caller's IX
C $9D88 IX = the current actor's own record
C $9D8C Is the object at IY in the same place as the actor?
C $9D8F Restore the caller's IX
c $9D92 Are two objects in the same place?
D $9D92 Returns with Z reset if the object at IY is visible (bit 7 of its flags) and is in the same place as the object at IX.
D $9D92 Each object's outermost holder is found with #R$9DC8, which returns $FF for an object lying loose in a room and 0 for one that is shut inside something (or held by a living character). If the results differ, the objects are not together. If both are loose, IX's room must be one of IY's locations. If both are 0, the room comparison is skipped and they count as together - see the bug note.
C $9D92 Is the IY object visible at all?
C $9D96 No: return with Z set
C $9D9C C = the IX object's room
C $9DA1 Where is the IY object ultimately?
C $9DA7 Where is the IX object ultimately?
C $9DAA The same answer?
C $9DAB No: not together
C $9DAD Both shut inside something ($00)?
C $9DAE Then count them as together
C $9DB0 Both loose: is the IX object's room one of the IY object's locations?
C $9DB7 Yes: together
C $9DBD Not together: Z set
C $9DC0 Together: Z reset
c $9DC8 Find the outermost holder
D $9DC8 Follows the chain of holders of the object at IX upwards, as long as each holder is open (bit 5) or dead (bit 3): you can see into an open box or a dead character's pockets. Returns $FF if the chain ends with the object (or an open container holding it) loose in a room, and 0 if it ends at a closed container or a living character.
C $9DCA A = the holder
C $9DCD Nobody?
C $9DCF Then the object is loose: return $FF
C $9DD1 IX = the holder's record
C $9DD4 Is the holder open or dead?
C $9DD9 Yes: see through it and look at its holder
C $9DDB No: return 0 (shut in)
c $9DDE Get the actor's room's exits
D $9DDE Returns IX pointing seven bytes into the actor's room record, so that #R$9AEE, which adds 3, arrives at the first exit.
C $9DDE Save the caller's DE
C $9DDF IX = the current actor's room's own record
C $9DE2 A room's list of exits starts 7 bytes into its record
C $9DE7 Restore the caller's DE
c $9DE9 Find the next room that fits some words
D $9DE9 Searches the exits of the actor's room for one whose destination room has the words at HL, so that rooms can be named as targets ('go into the tunnel'). Returns the room number in A, or $FF.
C $9DE9 Save the caller's IY and DE
C $9DEC DE = 2: the offset, from the start of a room's record, to its own name words
C $9DEF Look at the next exit of the actor's room; A = its direction, Z set once there are no more
C $9DF2 No more exits to try: give up
C $9DF4 A = this exit's destination room
C $9DF7 Save the exit-table pointer for a moment
C $9DF9 IX = the destination room's own record
C $9DFC Copy that into IY as well...
C $9E00 ...then restore IX, back to the exit we are examining
C $9E02 IY = the destination room's name words
C $9E04 Do the noun and adjectives at HL match that room's name?
C $9E07 No: try the next exit
C $9E09 Yes: A = this exit's destination room, the answer we want
C $9E0C Restore the caller's DE and IY
c $9E10 Print an object's name
D $9E10 Prints the words of the object whose record is at IY (#R$9E1F on its word slots).
C $9E10 Save the caller's IY and DE
C $9E13 An object's own word slots start 8 bytes into its record
C $9E18 Print the noun and its adjectives
C $9E1B Restore the caller's DE and IY
c $9E1F Print a noun with its adjectives
D $9E1F IY points to a word list: noun, then up to two adjectives. The article is printed first (#R$7436, unless #R$B5F4 is set), then the adjectives, and then the noun (with an article if #R$B5F4 is set). So 'curious map' comes out as 'a curious map'.
C $9E1F Save AF and DE
C $9E21 Does the caller want an article before the whole phrase (rather than before each adjective)?
C $9E26 Yes: skip straight to printing the noun with its article
C $9E28 No: DE = the first adjective, if there is one
C $9E2E Print its article ("a curious ...")
C $9E31 DE = the first adjective word itself
C $9E37 Print it
C $9E3A DE = the second adjective, if there is one
C $9E40 Print it (an empty slot simply prints nothing)
C $9E43 DE = the noun
C $9E49 Is there actually a noun here at all?
C $9E4B If so, print it (with an article too, if the caller asked for one before the whole phrase)
C $9E4E Restore DE and AF
c $9E51 Find a usable exit in a direction
D $9E51 Searches the exits of the actor's room for one in direction A that has a destination. Returns the direction in A, or $FF (Z set) if there is none.
C $9E51 Save the caller's BC and IY
C $9E54 B = the direction we are looking for
C $9E55 IX = the start of the actor's room's exits
C $9E58 Look at the next exit; A = its direction, Z set once there are no more
C $9E5B No more exits: give up (A is left holding $FF)
C $9E5D Does this exit actually lead anywhere?
C $9E61 No destination (a dead end): skip it and keep looking
C $9E63 A = this exit's direction
C $9E66 Is it the one we want?
C $9E67 No: try the next exit
C $9E6A Found it (or ran out): restore the caller's IY and BC
c $9E6E Find the exit through the target
D $9E6E Loads the target and continues into #R$9E71: finds the exit of the actor's room that goes through the target (a door, a window, a river).
C $9E6E A = the target of the current command (a door, window or river; falls into #R$9E71, which finds the room's exit through it)
c $9E71 Find the exit through a given door
D $9E71 Searches the actor's room for an exit whose door (byte 1) is object A. This routine and #R$9E76 are one routine: they write 1 or 2 into the offset of the LD A,(IX+n) instruction at #R$9E89 to choose which byte of each exit is compared.
C $9E71 FIND EXIT THROUGH A DOOR: save AF
C $9E72 1 picks out an exit's DOOR byte for the shared code below
C $9E74 Join it
c $9E76 Find the exit that leads to a room
D $9E76 Searches the actor's room for an exit whose destination (byte 2) is room A; see #R$9E71.
C $9E76 FIND EXIT TO A ROOM: save AF
C $9E77 2 picks out an exit's DESTINATION byte instead
C $9E79 Poke that choice into the instruction below, so the very same code can compare either byte depending on which entry point was used
C $9E7C Restore AF
C $9E7D Save the caller's BC and IY
C $9E80 B = the door (or destination room) we are looking for
C $9E81 IX = the start of the actor's room's exits
C $9E84 Look at the next exit; Z set once there are no more
C $9E87 No more exits: give up
C $9E89 A = this exit's door, or its destination, whichever this call was asked to check
C $9E8C Does it match?
C $9E8D No: try the next exit
C $9E8F Found it (or ran out): restore the caller's IY and BC
c $9E93 Run a handler with target and instrument swapped
D $9E93 Exchanges the target and the instrument (their numbers and record addresses), calls the handler at HL, and swaps them back. This lets one handler serve two ways of saying the same thing: FILL THE BOTTLE WITH WATER becomes PUT THE WATER IN THE BOTTLE (#R$8ED3), and THROW THE SWORD AT THORIN becomes ATTACK THORIN WITH THE SWORD (#R$8F5F).
C $9E93 DE = the target's own record address
C $9E97 IY = the instrument's own record address
C $9E9B The instrument's record becomes the new "target"...
C $9E9F ...and the target's record becomes the new "instrument"
C $9EA3 BC = the current target and instrument object numbers (C=target, B=instrument)
C $9EA7 A = the instrument's number...
C $9EA8 ...which becomes the new target
C $9EAB A = the (old) target's number...
C $9EAC ...which becomes the new instrument
C $9EAF Run the handler, with the two swapped over as far as it can tell
C $9EB2 Put the target and instrument numbers back exactly as they were
C $9EB6 Put the target and instrument records back too
c $9EBF Report failure
D $9EBF During a dry run, sets #R$B5EC to 0 (the action would not work). When the action is really being done, reports it instead (#R$7122), so the player sees 'you cannot ...'.
C $9EBF Is this action really happening (not just being tried out)?
C $9EC3 Yes: report it as an outright failure ("you cannot ...")
C $9EC6 Only a trial: just note that it would not have worked, without printing anything
c $9ECB Get an object's room
D $9ECB Returns the room of object A (its first location byte), or $FF if it is a door or other multi-place object, or if A is $FF.
R $9ECB Input:A Object
R $9ECB Output:A Room
C $9ECB Is there no object at all ($FF)?
C $9ECD If so, there is no room to report either
C $9ECE IX = the object's own record
C $9ED1 Does it occupy just one place (an ordinary object, not a door or the like)?
C $9ED6 Assume not: return $FF, meaning "no single room"
C $9ED9 It does: A = its one location, the answer
c $9EDD List what can be seen in the room
D $9EDD Prints 'you see :' and the objects and characters lying loose in the actor's room (#R$9EF8), or '      nothing'.
C $9EDD Save the caller's IY, AF and BC
C $9EE1 "you see :"
C $9EE7 A = $FF, meaning "held by nobody", i.e. lying loose in the room
C $9EE9 IY = the actor's own record
C $9EED B = the actor's room
C $9EF0 List everything lying loose there
C $9EF3 Restore the caller's BC, AF and IY
c $9EF8 List the objects held by A in room B
D $9EF8 Lists the objects (#R$9F10) and prints '      nothing' if there were none.
C $9EF8 Save the caller's IY, DE and BC
C $9EFC C will count how many things get printed
C $9EFE D = 4, meaning "no indent yet", since this is a fresh list rather than something nested inside another
C $9F00 List the objects, updating the count in C as it goes
C $9F03 Was anything at all printed?
C $9F05 "      nothing"
C $9F08 If nothing was printed, say so
C $9F0B Restore the caller's BC, DE and IY
c $9F10 List objects, with their contents
D $9F10 Prints each visible object held by A (A=$FF for loose objects) that is in room B, one per line, each followed by a full stop. After each one, its contents are listed by a recursive call, indented two more characters (D, stored at $7692 for #R$7694), with a heading from #R$9F89 such as 'gandalf is carrying' or 'in the chest there is'. The actor's own possessions are not listed when looking round the room. C counts the objects printed.
C $9F10 Save the caller's HL
C $9F11 L = the holder we are listing the contents of (or $FF for "lying loose")
C $9F12 A = whatever indent is currently in use, from an earlier, outer call to this same routine
C $9F15 H = that old indent, kept alongside the holder in L for a moment
C $9F16 A = the new indent this call should use
C $9F17 Set it as the printer's current indent
C $9F1A A = the holder again
C $9F1B Swap: put (old indent, holder) safely on the stack, and get the real, original HL back
C $9F1C Save the caller's IX
C $9F1E IX = just before the start of the object index, so the search below starts at its very first entry
C $9F22 Look at the next object; IY = its own record
C $9F25 Have we run out of objects?
C $9F27 No: is this object held by the one we are listing the contents of?
C $9F2A It is not: try the next object
C $9F2C It is: save this object's number for a moment
C $9F2D Does it occupy only a single place (not a door or the like)?
C $9F32 No: doors and similar things are never listed as "contents"
C $9F34 A = this object's own room
C $9F37 Is it really in the room we are listing (rather than, say, tucked inside something else there)?
C $9F38 No: skip it
C $9F3A Is the current actor the very object whose contents we are printing...
C $9F40 ...(if not, always list it - this next check is only about the actor's own belongings)
C $9F42 ...and is this the outermost call, not one nested inside a container?
C $9F45 Both true: this is the actor's own possession, and the room listing should not repeat it - skip it
C $9F47 Otherwise: can the actor actually see this object (is it close enough)?
C $9F4A No: skip it
C $9F4C Yes: count it
C $9F4D No forced capital letter for this printing...
C $9F51 ...and no article added before the whole name
C $9F54 Print the object's name
C $9F57 Are we listing what the CURRENT ACTOR is carrying (rather than something else)?
C $9F5D If so, no full stop is wanted here - the actor's own heading handles that separately
C $9F5F Otherwise print a full stop...
C $9F64 A = the object just printed
C $9F67 Print the heading for whatever IT holds ("X is carrying", "in the Y there is") - and find out whether it has anything worth listing
C $9F6A Nothing to list inside it (or it is closed): do not recurse
C $9F6C A = the object again
C $9F6F Save the indent (D) for a moment
C $9F70 Indent two spaces further in, for its own contents...
C $9F72 ...and list them, calling this same routine again
C $9F75 Restore the indent
C $9F76 Restore the object's number
C $9F77 Try the next object in the index
C $9F7A (Top-level listing: just a new line, with no full stop)
C $9F7F Out of objects: restore the caller's IX
C $9F81 Recover the (old indent, holder) pair saved earlier, putting the real HL safely back on the stack
C $9F82 Restore the caller's own indent...
C $9F86 ...(A is left holding the holder, though nothing further uses it)
C $9F87 Restore the caller's real HL
c $9F89 Print the heading for a list of contents
D $9F89 For object A: if it is closed and not dead (bits 3 and 5 of the flags clear), or holds nothing visible, a new line is printed and the routine returns with carry set. Otherwise, for a character, 'X is carrying'; for anything else a heading chosen by the low four bits of byte 4 of the object's record, from the message at #R$AEBD: IN (0), ON (1), BEHIND (2), UNDER (3) or TIED TO (4), followed by 'there is' or 'there are' - so 'behind the heavy curtain there is a wall' and 'under the trap door there is the goblins cache'.
C $9F89 Save the caller's IX, BC and DE
C $9F8D C = the object whose contents we are about to introduce
C $9F8E IX = its own record
C $9F91 A = its flags
C $9F94 Keep only whether it is closed and whether it is dead
C $9F96 Neither closed-and-alive nor dead: nothing worth a heading (an ordinary open container falls through here fine; this only stops things that are shut away)
C $9F98 A = the object again
C $9F99 How many visible things does it hold?
C $9F9E None at all: no heading needed either
C $9FA0 Is it a living character?
C $9FA4 No: use the ordinary IN/ON/BEHIND/UNDER/TIED-TO wording instead
C $9FA6 Yes: push its own number as the message parameter...
C $9FA8 ..."X is carrying"
C $9FAB Skip the ordinary wording below
C $9FAD "is"
C $9FB0 Is there only a single thing inside (so "is" is right rather than "are")?
C $9FB3 More than one: "are" instead
C $9FB6 Push IS or ARE as a message parameter
C $9FB7 HL = the object's own words (so the heading can name it: "in the chest")...
C $9FC0 ...pushed as another message parameter
C $9FC1 HL = the shared IN/ON/BEHIND/UNDER/TIED-TO message
C $9FC4 A = the object's attribute byte, whose low bits say how its contents should be introduced
C $9FC7 Shift that containment word up...
C $9FC9 ...into an index, since each choice of wording is 4 bytes further into the message
C $9FCE HL = the exact wording for this object's own containment style
C $9FCF Print the whole heading
C $9FD2 Clear the carry flag: there is something to list after all
C $9FD3 Restore the caller's DE, BC and IX
C $9FD8 Nothing worth a heading: just move to a new line
C $9FDB Set the carry flag: there is nothing to list
C $9FDC Join the shared ending above
c $9FDE Get the start of a room's exits
D $9FDE Returns IX pointing seven bytes into room A's record and BC=3, ready for stepping through its exits.
C $9FDE IX = room A's own record
C $9FE1 A room's exits start 7 bytes into its record
C $9FE6 BC = 3: the size of one exit, ready for the caller to step through them
c $9FEA Get the word for a direction
D $9FEA Returns in DE the word for direction A, from the table at $A13E (NORTH, SOUTH, EAST, WEST, NORTHEAST ... UP, DOWN). The entry at #R$9FED looks up another table at HL.
R $9FEA Input:A Direction
R $9FEA Output:DE Word
C $9FEA HL = the table of direction words
C $9FED E = the direction (1-10)...
C $9FEE ...with any stray extra bit cleared
C $9FF2 HL = this direction's own entry...
C $9FF3 ...doubled, since each word reference is 2 bytes
C $9FF4 DE = the word, read from the table (low byte)...
C $9FF6 ...then the high byte
c $9FF8 Describe the doors of a room
D $9FF8 For each exit of room A that has a visible door, prints 'to the east there is the round green door' (or 'above'/'below' for up and down).
C $9FF8 Save the caller's BC, DE, IY and IX
C $9FFE IX = the start of room A's exits, BC = 3 (the size of each one)
C $A001 Step back one exit's width, so the loop below lands on the very first exit the first time round
C $A003 IY will be the loop's own pointer, a copy of IX
C $A007 Is this the very first exit (guards against a room with no exits at all)?
C $A00B It is: there is nothing to describe yet, so skip straight to moving on
C $A00D A = this exit's door object
C $A010 IX = the door's own record
C $A013 Is the door visible?
C $A017 No: say nothing about it and move on
C $A019 DE = 8: the offset, from the start of a record, to an object's own words
C $A01C IX = the door's own words
C $A01E Save that for a moment
C $A020 A = this exit's direction
C $A023 DE = the word for that direction
C $A026 Is the direction UP or DOWN (9 or 10)?
C $A028 No: use the ordinary "to the <direction> there is" wording
C $A02A "above"
C $A02D It was UP: use that word
C $A02F "below"
C $A032 It was DOWN: use that word instead
C $A034 "to the <direction> there is"
C $A03A Print the direction word (or "above"/"below")
C $A03D "the <door>."
C $A040 Print it, naming the door
C $A043 Move on to the next exit
C $A045 Have we reached the end of the exits?
C $A04A Not yet: look at this next one
C $A04D Finished: restore the caller's IX, IY, DE and BC
c $A054 Find the next visible exit
D $A054 Steps IX to the next exit that has a direction and no door. Returns with Z set at the end of the exits.
C $A054 Move on to the next exit
C $A056 Have we reached the end of the exits?
C $A05B Yes: give up
C $A05C Does this exit have a door?
C $A060 It does: it is not a "visible" exit in the sense wanted here, so skip it
C $A062 Does it even have a direction at all?
C $A065 No direction (an unused slot): skip that too
C $A067 Found a plain, doorless exit
c $A068 List the visible exits
D $A068 Prints 'visible exits are :' followed by the direction of every exit that has no door (#R$A054), or nothing at all if there are none.
C $A06E IX = the room's exits
C $A071 Find the first exit without a door
C $A074 None: print nothing
C $A076 "visible exits are :"
C $A07C A = the exit's direction
C $A07F DE = its word
C $A082 Print it
C $A085 Next exit without a door
C $A088 Loop
C $A08A New line
c $A094 "The X is Y" (instrument)
D $A094 As #R$A09C, for the object at IY.
C $A094 INSTRUMENT VERSION: HL = the instrument's own words...
C $A09A Join the shared code below
c $A09C "The X is Y"
D $A09C Explains why an action failed by describing the state of the object at IX: 'the door is locked.', 'the chest is closed.', 'the bottle is empty.' The low bits of A choose the flag bit that was wrong, and bit 7 whether it was set or clear; the word comes from the tables at #R$A154 (UNLOCKED, EMPTY, OFF, CLOSED, DEAD) and #R$A164 (LOCKED, FULL, BROKEN, ON, OPEN, ALIVE).
R $A09C Input:A State
R $A09C IX Object record
C $A09C TARGET VERSION: HL = the target's own words...
C $A0A2 Save the caller's DE
C $A0A3 Push the object's own words, so the message below can name it
C $A0A4 HL = the wording for a CLEAR flag (unlocked, empty, off, closed, dead)...
C $A0A7 ...unless the state we were given says the flag is actually SET...
C $A0AB ...in which case use the SET wording instead (locked, full, broken, on, open, alive)
C $A0AE DE = the exact word for this particular state
C $A0B1 Recover the object's own words for a moment...
C $A0B2 ...push the state word first...
C $A0B3 ...then the object's words back on top of it, in the order the message needs them
C $A0B4 "the X is Y."
C $A0B7 Print it
C $A0BA Restore the caller's DE
c $A0BC Mark an object as dead or broken
D $A0BC Changes the adjectives of object A: the second adjective is removed and the first becomes DEAD for a character (bit 6 of its flags) or BROKEN for anything else. So after a fight, 'thorin' becomes 'the dead thorin'.
C $A0BE IX = the object's record
C $A0C1 Remove the second adjective
C $A0C9 The first adjective becomes BROKEN...
C $A0CC ...unless it is a living thing (bit 6)...
C $A0D2 ...which becomes DEAD
c $A0DE Look up the holder of an object (unused)
D $A0DE Searches the object index for the holder of the object at IY and returns its number. Nothing in the game calls this routine.
C $A0DE Save IY and IX
C $A0E2 Search every object in the game...
C $A0E9 No more objects: give up (below)
C $A0EB Is it held by the object whose holder we want?
C $A0EE No: try the next one
C $A0F0 A = the object that holds it (or $FF if none was found)
C $A0F3 Restore IX and IY
c $A0F8 Is the object alive?
D $A0F8 Returns with Z set if the object at IX is a living thing (bit 6 of its flags set) and not dead (bit 3 clear). Used by SHOOT (#R$8FE0).
C $A0F8 A = the object's own flags
C $A0FB Keep just "alive" and "dead"
C $A0FD Alive and not dead?
C $A0FF Z reflects the answer
c $A100 Should the instrument's handlers be used?
D $A100 Returns with Z set if the current action is one of the five listed at #R$A13B: DROP IN, PUT IN, PUT ON, TAKE OUT OF and THROW THROUGH. For these it is the instrument (the container, or the window) that knows what to do, so #R$946F uses its handlers.
C $A100 Save the caller's HL and BC
C $A102 Five actions to check against
C $A104 HL = the list of actions that use the instrument's own handlers, rather than the target's
C $A107 A = the action being carried out right now
C $A10A Is it one of these five?
C $A10B Yes: stop here, with it found
C $A10D No: look at the next one in the list
C $A110 Restore the caller's BC and HL
c $A113 A character speaks
D $A113 Prints '<actor> says "<message at HL>".'. Used by the character routines for Thorin's 'hurry up', Gollum's riddles and so on.
R $A113 Input:HL Message
C $A113 Save the caller's HL
C $A114 '<actor> says "'
C $A11A Restore HL: the message to be spoken
C $A11B Force a capital letter, as if this were starting a fresh sentence
C $A120 Print what is being said
C $A123 '"' (the closing quote and a full stop)
c $A129 Is the target locked or open?
D $A129 Tests the target's flags: returns Z reset and A=$80 if it is locked; otherwise tests bit 5 and returns A=$85, so Z reset means it is open. The codes in A are for #R$A09C. The entry at #R$A134 does only the second test.
C $A129 IX = the target's own record
C $A12D Is it locked?
C $A131 A = the state code for LOCKED/UNLOCKED, in case the caller needs to report it
C $A133 Locked: return with Z reset, telling the caller it cannot be used yet
C $A134 Not locked: is it open?
C $A138 A = the state code for OPEN/CLOSED, in case the caller needs to report it
C $A13A Z reflects whether it is open
b $A13B Action and word tables
D $A13B #LIST { #R$A13B: the five actions for which the instrument's handlers are used rather than the target's (#R$A100): DROP IN, PUT IN, PUT ON, TAKE OUT OF, THROW THROUGH. } { #R$A140: the words for the ten directions (#R$9FEA): NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST, UP, DOWN. } { #R$A154: the words for an object's flags when they are clear (#R$A09C): UNLOCKED, -, EMPTY, -, OFF, CLOSED, DEAD, -. } { #R$A164: the same when set: LOCKED, -, FULL, BROKEN, ON, OPEN, ALIVE, -. } LIST#
B $A13B,5,5 Actions
W $A140,20 Directions 1-10
W $A154,16 Flag words (clear)
W $A164,16 Flag words (set)
c $A174 Handler for the water: DRINK
D $A174 Drinking ordinary water (object 23) always works and has no effect.
C $A174 Dry run? Then stop here: drinking plain water always works, and has no other effect
c $A178 TIE TO
D $A178 Only the rope can be tied: TIE THE ROPE TO X is turned round into TIE X TO THE ROPE (#R$A1DE, #R$9E93). The thing tied must not be something that pours, must be empty ('the rope is already tied'), and must not be a living character (a dead one is fine). It then becomes held by the rope.
D $A178 If the actor could pick the thing up, the rope stays in the actor's hands with the thing hanging from it; otherwise the rope is left lying, tied to it. Taking or dropping the rope takes or drops whatever is tied to it (#R$8CC8, #R$8C45).
C $A178 Is the TARGET actually the rope (object 18)?
C $A17D Yes: "TIE THE ROPE TO X" - turn it round into "TIE X TO THE ROPE" (below)
C $A17F No: is the INSTRUMENT the rope instead?
C $A184 Neither: fail with the usual message - only the rope can be tied
C $A187 IX = the target's own record (the thing being tied)
C $A18B Does it pour (is it a liquid)?
C $A18F Yes: cannot tie up a liquid
C $A192 Does it already hold anything visible?
C $A197 "the X is already tied."
C $A19A Already holding something (i.e. already tied to something): say so and stop
C $A19D Is it dead (a corpse)?
C $A1A1 Yes: a dead character may still be tied up
C $A1A3 No: is it a LIVING character?
C $A1A7 Yes: cannot tie up someone alive
C $A1AA Dry run? Then stop here: it would work
C $A1AD IY = the rope's own record
C $A1B1 Is the actor already holding the thing being tied?
C $A1B4 It becomes held by the rope, either way...
C $A1BA If the actor already held it, skip straight to deciding who holds the rope itself
C $A1BC Otherwise: try to pick it up first (as an ordinary TAKE), but only as a trial for now
C $A1C3 Did the actor manage to pick it up?
C $A1C8 Either way, this really is happening now
C $A1D0 Could not pick it up: leave the rope where it is, below
C $A1D2 Could pick it up: the rope stays in the actor's own hands
C $A1D9 Left lying: the rope is held by nobody, tied to whatever is too heavy to lift
C $A1DE "TIE THE ROPE TO X": run this same handler again...
C $A1E1 ...with target and instrument swapped, so it becomes "TIE X TO THE ROPE"
c $A1E4 UNTIE
D $A1E4 The target must be tied to the rope ('the X is not tied'). It then goes to whoever holds the rope.
C $A1E4 IX = the target's own record
C $A1E8 Is it actually held by the rope (object 18)?
C $A1ED "the X is not tied."
C $A1F0 No: say so and stop
C $A1F3 Dry run? Then stop here: it would work
C $A1F6 A = whoever holds the rope itself
C $A1F9 The target now belongs to them too
c $A1FD Handler for the fast river: SWIM
D $A1FD Swimming across the fast river: the exit through the river is found (#R$9E6E); if it leads anywhere, the river is opened for a moment and the actor goes through it with an ordinary move (#R$8D19, at #R$8D27), then the river is closed again. The entry at $A20C is the handler used by many doors and containers for their OPEN action when they are chained to a movement.
C $A1FD Find the exit that passes through the river
C $A200 Does it lead anywhere?
C $A205 Yes: swim across, below
C $A207 No: dry run? Then stop here: the attempt itself is possible
C $A20A (falls through to failing normally otherwise)
C $A20B A = the exit's own direction
C $A20E Save the current action for a moment...
C $A212 ...and use the direction as the movement action instead
C $A215 IX = the river's own record
C $A219 Open it, just long enough to move through it
C $A21F No specific target - just moving
C $A224 Carry out the move
C $A227 Restore the river's own record
C $A229 Close it again
C $A22D Restore the original action
c $A232 BURN
D $A232 Only the dragon (object 60) can burn anything; for anyone else it fails. When the dragon does it, the target is killed (#R$96DA).
C $A232 Is the current actor the dragon (object 60)?
C $A237 No: fail with the usual message - nobody else can burn things
C $A23A Dry run? Then stop here: it would work
C $A23D Kill the target
c $A240 Handler for the fast black river: SWIM
D $A240 The enchanted river from the book: 'as soon as you touch the river you fall asleep and gently float away.' For Bilbo this is followed by 'time passes...', and the swimmer dies (#R$96DD).
C $A240 Dry run? Then stop here: it would work
C $A243 "as soon as X touches the river X falls asleep and gently floats away."
C $A249 Is the swimmer Bilbo himself?
C $A24E "time passes..."
C $A251 If it is Bilbo, add that too
C $A254 Restore A
C $A255 The swimmer dies
c $A258 Handler for the black water: DRINK
D $A258 Drinking the black water: 'you fall asleep.', and then as #R$A240: 'time passes...', and death.
C $A258 Dry run? Then stop here: it would work
C $A25B "X falls asleep."
C $A25E Join the enchanted-river code above, which adds "time passes..." for Bilbo and kills the drinker
c $A260 Handler for the side door: UNLOCK
D $A260 The small curious key (object 2) fits the side door of the Lonely Mountain. Jumps to #R$A26A.
C $A260 The small curious key (object 2) is the one that fits the side door
C $A262 Join the shared LOCK/UNLOCK code
c $A264 Handler for the red door: LOCK and UNLOCK
D $A264 The red door's LOCK and UNLOCK handler: only object 15 fits it (the entry at #R$A26A with B=15).
C $A264 The red key (object 15) is the one that fits the red door
c $A268 Handler for the heavy rock door: LOCK and UNLOCK
D $A268 The large key (object 4) fits the heavy rock door (the trolls' cave). Continues into #R$A26A.
C $A268 The large key (object 4) is the one that fits the trolls' cave (falls into #R$A26A)
c $A26A Does this key fit?
D $A26A Shared by the LOCK and UNLOCK handlers of the locked doors; on entry B is the object number of the key that fits (for example 15, the red key, from #R$A264).
D $A26A If the instrument is that key, the door is locked or unlocked (#R$93CD, #R$93ED). If the instrument is one of the game's other keys - object 2 (the small curious key), object 4 (the large key) or object 15 (the red key) - the game says 'the key does not fit this lock.' Anything else, such as trying to unlock a door with the sword, gets 'I cannot do that.'
R $A26A Input:B The key that fits
C $A26A A = the object being used as the key
C $A26D Is it the key that fits this door?
C $A26E No: see what it is
C $A270 Yes. Is the action LOCK (action 37)?
C $A275 Yes: lock the door
C $A278 No: unlock it
C $A27B Is the object the small curious key (object 2)...
C $A27F ...the large key (object 4)...
C $A283 ...or the red key (object 15)?
C $A285 None of these: "I cannot do that."
C $A288 A key, but the wrong one: "the key does not fit this lock."
c $A28E Handler for the side door: OPEN
D $A28E Chained after the side door's other handlers: when it really happens, opens the door (at #R$9081 in #R$9078).
C $A28E Only if this is really happening (not just a trial)
C $A291 IX = the target's (the door's) own record
C $A295 Open it, as if by the ordinary OPEN handler
c $A298 Handler for the crack: OPEN
D $A298 The small insignificant crack can only be opened from room 15; there it opens like a door (#R$9078).
C $A298 IX = the actor's own record
C $A29C Is the actor in room 15 (the only place the crack can be opened from)?
C $A2A1 No: fail with the usual message
C $A2A4 Yes: open it as usual
c $A2A7 Handler for the spider web: it has been broken
D $A2A7 Chained after the spider web's handler for breaking it (the web is object 7). If the web really is broken now (bit 3 of its flags), it is opened (bit 5), so the way through is clear, and timer 1 is started (count 2): 'some spiders start mending the broken web.' Two turns later #R$A950 closes it again.
C $A2A7 IX = the web's record
C $A2AB Is it broken?
C $A2AF No: nothing to do
C $A2B0 Yes: it no longer blocks the way
C $A2B4 Start timer 1 (count 2)
C $A2BA "some spiders start mending the broken web."
c $A2C0 Handler for the ring: WEAR
D $A2C0 Putting the golden ring on makes the wearer invisible (bit 7 of their flags cleared) - but also divides their strength by 4. The ring itself becomes invisible and held by the wearer, and timer 6 is started with a random count of 2 to 10 (#R$9BF4), after which the ring comes off by itself (#R$A9D4).
C $A2C0 Dry run? Then stop: it would work
C $A2C3 IY = the wearer's record
C $A2C7 IX = the ring's record
C $A2CB The wearer becomes invisible...
C $A2CF ...and a quarter as strong
C $A2D7 The ring vanishes from view...
C $A2DB ...into the wearer's hand
C $A2E1 Pick a random number from 0 to 8...
C $A2E6 ...plus 2...
C $A2E8 ...and start timer 6 with it
c $A2EC Handler for the ring: TAKE OFF
D $A2EC Taking the ring off (also done automatically when timer 6 runs out, #R$A9D4). If the ring is visible it is not being worn: '<actor> is not wearing the ring.' Otherwise the ring and its wearer become visible again, the wearer's strength is multiplied by 4, and timer 6 is stopped.
D $A2EC Because putting the ring on divided the strength by 4 with SRL and taking it off multiplies it by 4 with SLA, the two lowest bits are lost each time: a strength of 74, for example, comes back as 72. Each use of the ring can cost Bilbo up to 3 points of strength.
C $A2EC IX = the wearer's record
C $A2F0 IY = the ring's record
C $A2F4 Is the ring visible (not being worn)?
C $A2F8 "you are not wearing the ring."
C $A2FB Yes: say so
C $A2FE Dry run? Then stop: it would work
C $A301 The ring can be seen again...
C $A305 ...and so can the wearer...
C $A309 ...whose strength is multiplied by 4 (the bottom two bits lost on the way in are gone)
C $A311 Stop timer 6
c $A316 CAPTURE
D $A316 One character captures another. The target must be alive, and not on the same side as the actor (bits 4-6 of byte 4 of their records must have nothing in common, so goblins do not capture goblins). The captive is taken to a dungeon: room 31 if the captor is the wood elf or the butler (objects 64 and 66), room 13 otherwise. If the captive is Bilbo, the new room is described.
C $A316 IX = the captive's record
C $A31A A = the captive's side (bits 4-6 of its attributes)
C $A321 IX = the captor's record
C $A325 Are they on the same side?
C $A32A Yes: allies do not capture each other
C $A32D Is the captive alive?
C $A331 No: you cannot capture a corpse or an object
C $A334 Who is the captor?
C $A337 Room 31 (the dark dungeon)...
C $A339 ...for the wood elf...
C $A33D ...or the butler
C $A341 Anyone else: room 13 (the goblins' dungeon)
C $A343 Dry run? Then stop: the capture would work
C $A346 IX = the captive's record
C $A34A Put the captive in the dungeon...
C $A34D ...free of anything holding it
C $A354 ...and move everything it carries there too
C $A357 Was the captive Bilbo?
C $A35C No: done
C $A35D Yes: he becomes the actor...
C $A367 ...and the dungeon is described
c $A36A A dead goblin comes back
D $A36A Chained after the normal ATTACK handler in each goblin's object record (action 15 runs #R$90DB, then this). If the attack killed the goblin, it comes straight back: the dead flag is cleared, its number is written back into its slot in the character table (so it acts again), it is moved to another room and given a new adjective, all from its 6-byte entry in the table at #R$A3C3. The game prints 'the goblin falls down a hole and vanishes.'
D $A36A It then means to announce '- another goblin' if the goblin's new room is Bilbo's, but compares Bilbo's room with register B, which this routine never sets; B holds whatever the attack routine left there (the attack value), so the announcement depends on chance.
C $A36A IX = the goblin's record
C $A36E Did the attack kill it?
C $A372 No: nothing to do
C $A373 Bring it back to life
C $A377 Find its entry in the table at #R$A3C3 (6 bytes each)
C $A38A HL = the entry
C $A38D DE = its slot in the character table
C $A391 Put the goblin back in the slot: it will act again
C $A392 Move it to its new room
C $A397 Give it a new adjective
C $A3A1 "the goblin falls down a hole and vanishes."
C $A3A7 Is Bilbo in the room it went to? (B is never set here: see above)
C $A3AB No
C $A3AC Print "-"...
C $A3B1 ...ANOTHER...
C $A3B7 ...GOBLIN...
C $A3BD ...and the rest of the sentence
b $A3C3 Goblin reincarnation table
D $A3C3 Six 6-byte entries used by #R$A36A when a goblin is killed: the goblin, the address of its slot in the character table, the room it reappears in, and its new adjective.
B $A3C3,6,6
B $A3C9,6,6
B $A3CF,6,6
B $A3D5,6,6
B $A3DB,6,6
B $A3E1,6,6
c $A3E7 Handler for the goblins' door: OPEN
D $A3E7 The goblins' door (object 17) can only be opened by someone in the goblins' big cavern (room 16), in other words from the inside; from anywhere else the attempt fails (#R$9EBF). It is then opened as usual (#R$9078) and timer 3 is started, so two turns later it shuts itself (#R$A400).
C $A3E7 IX = the actor's record
C $A3EB Is the actor in the goblins' big cavern (room 16)?
C $A3F0 No: it cannot be opened from this side
C $A3F3 Open it
C $A3F6 Only if it really happened...
C $A3F9 ...start timer 3 (count 2)
c $A400 Timer 3 expires: the goblins' door closes
D $A400 Two turns after it was opened (#R$A3E7), the goblins' door closes itself.
C $A400 HL = the goblins' door's flags
C $A403 Close it
c $A406 Character routine: react to being given something
D $A406 Says, at random, either 'thank you' or 'what do you expect me to do with this?'
C $A406 Dry run? Then stop here: it always works
C $A409 Pick a random number from 0 to 10
C $A40E "what do you expect me to do with this?"
C $A411 8 or more?
C $A413 Yes: say that
C $A416 "thank you"
C $A419 Otherwise: say that instead
c $A41C Character routine: "what's this?"
D $A41C Says 'what's this?'
C $A41C Dry run? Then stop here: it always works
C $A41F "what's this?"
C $A422 Say it
c $A425 Character routine: small talk
D $A425 Says one of 'you are doing a great job', 'hurry up' or 'hello', chosen at random.
C $A425 Dry run? Then stop here: it always works
C $A428 Pick a random number from 0 to 2
C $A42D "you are doing a great job"
C $A430 0?
C $A432 Say that
C $A435 "hurry up"
C $A438 1?
C $A43A Say that instead
C $A43D "hello"
C $A440 Otherwise say that
c $A443 Character routine: "this was thrains key"
D $A443 Thorin says 'this was thrains key' (used once, after he has picked up the small curious key).
C $A443 Dry run? Then stop here: it always works
C $A446 "this was thrains key"
C $A449 Say it
c $A44C Character routine: greet Bilbo
D $A44C If the character is in the same room as Bilbo, says 'hello'.
C $A44C A = the room the character started this turn in
C $A44F Is that the room Bilbo is in?
C $A453 No: say nothing
C $A454 Dry run? Then stop here: it always works
C $A457 "hello"
C $A45A Say it
c $A45D Handler for the magic door: OPEN
D $A45D Only the wood elf (object 64) can open the magic door; anyone else fails.
C $A45D Is the current actor the wood elf (object 64)?
C $A462 No: fail with the usual message - only the wood elf can open it
C $A465 Yes: open it as usual
c $A468 CLIMB OUT OF
D $A468 The default handler for CLIMB OUT OF. The actor must be inside the target, which must be open ('the barrel is closed'). The actor's holder is cleared: he is out.
C $A468 IY = the actor's own record
C $A46C Is the actor actually inside the target?
C $A472 No: fail with the usual message
C $A475 IX = the target's own record
C $A478 Is it open?
C $A47B No: say so and stop
C $A47E Dry run? Then stop here: it would work
C $A481 The actor is held by nobody now: they are out
c $A486 CLIMB INTO (the barrel, the chest or the boat)
D $A486 The actor must not already be inside. The container must be open, and big enough: unless its size is $FF (unlimited), it must be larger than the actor plus everything the actor carries (#R$9C3D), or 'you are too big'. Then the container becomes the actor's holder, and the actor goes wherever it goes (#R$9B38) - which is how Bilbo escapes in the barrel (#R$A4F4).
C $A486 IY = the actor's own record
C $A48A Is the actor already inside the target?
C $A490 Yes: fail with the usual message
C $A493 A = how much the actor can carry...
C $A496 ...plus how much the actor is already carrying
C $A49C Overflowed past 255? Then treat the actor as unmeasurably big
C $A4A0 B = the actor's own total size, for the check below
C $A4A1 IX = the target's (the container's) own record
C $A4A5 Is it open?
C $A4A8 No: say so and stop
C $A4AB A = the container's own capacity
C $A4AE Is it unlimited?
C $A4B0 Yes: skip the size check
C $A4B2 No: is the actor too big to fit?
C $A4B3 "you are too big."
C $A4B6 Too big: say so and stop
C $A4B9 Dry run? Then stop here: it would work
C $A4BC The actor becomes held by the target...
C $A4BF ...so wherever the target goes, the actor goes too
c $A4C3 Is the object open?
D $A4C3 Tests bit 5 of the flags of the object at IX (Z reset if open) and returns A=5, the state code for #R$A09C.
C $A4C3 Is it open?
C $A4C7 A = the state code for OPEN/CLOSED, in case the caller needs to report it
C $A4C9 Z reflects the answer
c $A4CA Character routine: the warg
D $A4CA If the warg (whose location is at #R$C341) is in Bilbo's room: 'the vicious warg runs around you and howls.'
C $A4CA Dry run? Then stop here: it always works
C $A4CD HL = the warg's own location
C $A4D0 Is Bilbo in the same room?
C $A4D4 No: say nothing
C $A4D5 "the vicious warg runs around you and howls."
C $A4D8 Say it
c $A4DB Handler for the trap door: the barrel escape
D $A4DB Chained after the trap door's own THROW THROUGH handler (action 44, #R$9404), not after OPEN as I first assumed - it is throwing the barrel through the door, not merely opening the door, that starts the escape. If the object just thrown through is the barrel (object 19) and it has landed in room 33 (the forest river below the cellar), timer 0 (#R$C973) is set to 2. Two turns later #R$A4F4 floats the barrel away.
C $A4DB Is the object just thrown through the door the barrel (object 19)?
C $A4E0 No: this handler does nothing
C $A4E1 Only if this is really happening (chained after the trap door's own THROW THROUGH, #R$9404, which has already moved the barrel)
C $A4E4 IX = the barrel's own record
C $A4E8 Did it land in room 33, the forest river below?
C $A4ED No: nothing happens
C $A4EE Yes: start timer 0 with a count of 2
c $A4F4 Timer 0: the barrel floats down the river
D $A4F4 The expiry routine of timer 0, two turns after the barrel is thrown through the trap door into the forest river below the cellar (#R$A4DB). If Bilbo is in the barrel he reads 'you are thrown onto the bank of the long lake.' Everything in the barrel is moved to room 34 on the long lake (#R$9B38) and tipped out there (#R$9CA8), silently. The barrel itself goes back to the cellar (room 32), closed and full, and the wine (object 20) is put back in it. This is the book's escape from the Elvenking's halls, and the game resets it so the barrel is ready again.
C $A4F4 Let other timers expire this turn too
C $A4F8 Is Bilbo in the barrel (object 19)?
C $A4FD "you are thrown onto the bank of the long lake."
C $A500 If so, say so
C $A503 Put the barrel in room 34, the long lake...
C $A509 ...and take everything in it along
C $A50E IX = the barrel's record
C $A512 Put the barrel back in the cellar (room 32)
C $A516 Closed...
C $A51A ...and full
C $A51E Quietly...
C $A522 ...tip its contents out on the lake bank
C $A527 Output back on
C $A52C IY = the wine's record
C $A530 The wine is in the cellar...
C $A534 ...inside the barrel
c $A539 Character routine: "where's the thief?"
D $A539 If the character is in Bilbo's room but Bilbo cannot be seen (his visibility bit is clear), says 'where's the thief?'.
C $A539 A = the room the character started this turn in
C $A53C Is Bilbo in that same room?
C $A540 No: say nothing
C $A541 Yes - is Bilbo actually visible?
C $A546 He is: no need to ask
C $A547 Invisible: dry run? Then stop here: it always works
C $A54A "where's the thief?"
C $A54D Say it
c $A550 Character routine: Thorin
D $A550 Thorin's idle behaviour. A random number from 0 to 8 (#R$9BF4) decides: 5 or more, nothing; 3 or 4, 'thorin waits.'; 0, 'thorin sits down and starts singing about gold.'; 1 or 2, he says 'hurry up'.
D $A550 A fourth line, 'get us out of this one, thief!', is set up at #R$A563 but can never be printed: the JP Z that would print it tests the flags from CP 3, and Z can only be set there if A was 3, which the JP NC before it has already taken care of.
C $A550 Dry run? Then stop: this always works
C $A553 Pick a random number from 0 to 8
C $A558 5 or more...
C $A55A ...do nothing
C $A55B 3 or 4...
C $A55D "thorin waits."
C $A563 "get us out of this one, thief!" (never reached: see the bug note)
C $A569 "thorin sits down and starts singing about gold."
C $A56C 0?
C $A571 1 or 2: he says "hurry up"
c $A577 Handler for the trap door: OPEN and CLOSE
D $A577 The trap door can only be opened or closed from room 32; elsewhere 'you cannot reach the trap door'.
C $A577 IX = the actor's own record
C $A57B Is the actor in room 32 (the only place the trap door can be worked from)?
C $A580 "you cannot reach the trap door."
C $A583 No: say so and stop
C $A586 Yes - is this actually CLOSE (action 12)?
C $A58B Yes: close it as usual
C $A58E Otherwise (OPEN): open it as usual
c $A591 Character routine: the dragon comes for Bilbo
D $A591 If Bilbo is in room 39, 41 or 44 (the dragon's domain) and the dragon (object 60, location at #R$C033) is somewhere else, the dragon moves to Bilbo's room and 'the dragon enters.'
C $A591 Is Bilbo in room 39 (the front gate)...
C $A598 ...room 44...
C $A59C ...or room 41 (the lower halls)?
C $A59E No: nothing happens
C $A59F Dry run? Then stop: this would work
C $A5A2 Is the dragon already there?
C $A5A9 Yes: nothing to do
C $A5AA No: the dragon flies to Bilbo's room
C $A5AB Make sure Bilbo sees it
C $A5B0 Push the dragon's name as the message parameter
C $A5B4 "the dragon enters."
C $A5B7 Print it
c $A5BB Character routine: the dragon speaks
D $A5BB If the dragon and Bilbo are in the same room: 'well thief your cunning has failed you this time. prepare to die', or, if Bilbo is invisible (he is wearing the ring: bit 7 of his flags at $C012 is clear), 'I may not be able to see you thief but I can still burn you. prepare to die'. The dragon's next instruction is BURN.
C $A5BB Is Bilbo in the room where the dragon started its turn?
C $A5C2 No: nothing to say
C $A5C3 Dry run? Then stop: this would work
C $A5C6 Is Bilbo visible (bit 7 of his flags; clear while he wears the ring)?
C $A5CB "I may not be able to see you thief but I can still burn you. prepare to die"
C $A5CE Invisible: say that
C $A5D0 "well thief your cunning has failed you this time. prepare to die"
C $A5D3 Print it
c $A5D5 Character routine: the dragon wakes
D $A5D5 Does nothing while the valuable treasure (location at #R$C4CC) is still in room 41. Once it has been moved, and if the dragon's current room is lit, a random number from 0 to 100 (#R$9BF4) decides: below 80, 'in the distance you see the shape of a monstrous dragon flying after you.'; otherwise 'the dragon descends and in a terrific spout of flames burns you to a crisp.' and Bilbo dies. Because of the skew in the random numbers (#R$9BFD), the fatal result comes up about 16% of the time, every turn, for as long as the dragon lives.
C $A5D5 Is the treasure still in room 41?
C $A5DA Yes: the dragon sleeps on
C $A5DB Dry run? Then stop: this would work
C $A5DE Make sure Bilbo sees what follows
C $A5E3 IX = the room the dragon (the actor) is in
C $A5E6 Is it lit?
C $A5EA No: nothing happens
C $A5EB "in the distance you see the shape of a monstrous dragon flying after you."
C $A5EE Pick a random number from 0 to 100
C $A5F3 Below 80?
C $A5F5 Yes: the dragon is just a shape in the distance
C $A5F7 Otherwise: "the dragon descends and in a terrific spout of flames burns you to a crisp."
C $A5FD Bilbo is dead
c $A600 Unused routine
D $A600 Finds an exit of the actor's room by way of the variant search at #R$9E6E and, if there is one, removes its three bytes, presumably meaning to seal up a way through once something (perhaps the boat) is no longer there to use. But nothing in the game calls it: it is not wired into any object's handler list, any room-entry handler, or any timer, and no other routine calls or jumps to it. Like #R$A0DE, it appears to be leftover or abandoned code.
C $A600 Find the exit that passes through the target (presumably meant to be the boat)
C $A603 Is there no such exit?
C $A605 If so, there is nothing to do
C $A606 Clear the exit's three bytes - sealing up the way, presumably once the boat is no longer there
C $A613 (This routine is never actually called by anything in the game - see the note above)
c $A614 Handler for the magic door
D $A614 When the magic door is examined: if the actor can see it clearly (bit 7 of its flags), 'you see nothing special'. Otherwise timer 5 is started (by copying its reload value) and 'the magic door warns of elves approaching.'
C $A614 Dry run? Then stop here: it would work
C $A617 IX = the actor's own record
C $A61B Is the actor visible?
C $A61F "X sees nothing special."
C $A622 Visible: nothing more happens - just an ordinary EXAMINE
C $A625 Invisible (wearing the ring): start timer 5 (copy its reload value into its count)
C $A62B "the magic door warns of elves approaching."
c $A631 Handler for Thorin: the small curious key shatters
D $A631 Attached to Thorin's record. When Thorin is dead (bit 3 of his flags at $C2A8), the small curious key (record at $C091) is marked broken (#R$A0BC) and, if Bilbo can see it, 'the small curious key shatters.'
C $A631 HL = Thorin's own flags
C $A634 Is he dead?
C $A636 No: nothing happens
C $A637 Only if this is really happening
C $A63A IX = the small curious key's own record
C $A63E Mark it broken
C $A642 Remove its second adjective, leaving just BROKEN
C $A647 Can Bilbo actually see the key (is it near enough)?
C $A64E No: say nothing
C $A64F "the small curious key shatters."
c $A655 Handler for the window: OPEN and CLOSE
D $A655 Bilbo cannot reach the window if he is not being held up (byte 1 of his record is $FF): 'you cannot reach the window'. Characters can open and close it normally.
C $A655 Is the actor Bilbo?
C $A65A No (a character): they can always reach the window, below
C $A65C Yes - is Bilbo currently being held up by something?
C $A65F "you cannot reach the window."
C $A664 Held by nobody: he cannot reach it - say so and stop
C $A667 Held by something, but the action still failed some other way: fail normally
C $A66A Is this CLOSE (action 12)?
C $A66F Yes: close it as usual
C $A672 Is it OPEN (action 16)?
C $A674 Yes: open it as usual
C $A677 Anything else: do nothing further here
c $A678 Handler for the window
D $A678 Bilbo cannot reach the window unless something (or someone) is holding him up: if nothing holds him, 'you cannot reach the window.' Characters, and a Bilbo who is being carried, are passed on to the normal handlers for going through it (#R$8E9D), breaking it (#R$9257) or looking through it (#R$8E4E). The HELP message in the goblins' dungeon hints at this: 'a window should be no obstacle to a thief with friends'.
C $A678 Is the actor Bilbo?
C $A67D No: characters can always reach it, below
C $A680 Yes - is Bilbo currently being held up by something?
C $A685 "you cannot reach the window."
C $A688 Held by nobody: he cannot reach it - say so and stop
C $A68B A = the current action
C $A68E Is it GO THROUGH?
C $A690 Yes: go through it as usual
C $A693 Is it STRIKE (breaking it)?
C $A695 Yes: break it as usual
C $A698 Is it LOOK THROUGH?
C $A69A Yes: look through it as usual
C $A69D Anything else: do nothing further here
c $A69E Timer 4: sinking into the bog
D $A69E Both the tick and the expire routine of timer 4 (#R$C6A8). If Bilbo is in the deep bog (room 29) the timer is stopped (count 0). Then '<actor> is slowly sinking into the bog.' is printed, and if the count is now 0, Bilbo dies.
D $A69E In practice the tick runs at the end of the turn Bilbo entered the bog, while he is still there, so it always kills him. The other path - printing the message but surviving because the count is still 1 - would only be taken if he had somehow left within the same turn. (The message is printed even then, although he is no longer in the bog.)
C $A69E Is Bilbo in the deep bog (room 29)?
C $A6A3 No: just print the message
C $A6A5 Yes: stop the timer (count 0)
C $A6A9 "you are slowly sinking into the bog."
C $A6AF Is the count 0?
C $A6B4 No: he survives this turn
C $A6B5 Yes: Bilbo is dead
c $A6B8 Handler for the curious map: Elrond reads it
D $A6B8 When anyone other than Elrond (object 65) examines the curious map, it is an ordinary EXAMINE (#R$9344). When Elrond does (because the player gave it to him and asked him to read it), the hidden route chosen at the start of the game (#R$970B) is revealed: the three bytes of the exit that were blanked out are restored from the table at #R$C6F7 (the address of the entry was written into the LD IY instruction at #R$A6C3), and Elrond says 'go <direction> from <room> to get to <room>'. $B5E2 records that it has been done.
C $A6B8 Pick up the number of the character doing the examining
C $A6BB Is it Elrond (object 65)?
C $A6BD No: treat it as an ordinary EXAMINE (you see the curious map)
C $A6C0 Elrond: during a dry run, record that this would work and stop here
C $A6C3 IY = the hidden-route entry chosen at the start of the game (this operand is written by #R$970B)
C $A6C7 HL = the address of the blanked-out exit in the room record...
C $A6CA ...(bytes 1 and 2 of the entry)
C $A6CD Has the map already been read?
C $A6D2 Yes: the exit is already open, so skip straight to what Elrond says
C $A6D4 Three bytes to restore: direction, door and destination
C $A6D6 Fetch one byte of the exit from the entry (bytes 3-5)...
C $A6D9 ...and put it back into the room record
C $A6DA Next byte of the room record
C $A6DB Next byte of the entry
C $A6DD Repeat for all three bytes: the hidden way is now open
C $A6DF Point IY back at the start of the entry (the INCs moved it on)
C $A6E3 A = the destination room (byte 5 of the entry)
C $A6E6 IX = its room record
C $A6E9 Skip the two flag bytes...
C $A6EB ...to reach the room's name words
C $A6ED Push them as the third parameter of the message ("...to get to <room>")
C $A6EF A = the room that has the exit (byte 0 of the entry)
C $A6F2 IX = its room record
C $A6F5 Skip the two flag bytes...
C $A6F7 ...to reach the room's name words
C $A6F9 Push them as the second parameter ("...from <room>...")
C $A6FB A = the direction of the exit (byte 3 of the entry)
C $A6FE DE = the word for that direction (NORTH, EAST...)
C $A701 Push it as the first parameter ("go <direction>...")
C $A702 HL = the message "go <direction> from <room> to get to <room>"
C $A705 Elrond says it: 'elrond says "go north from beorns house to get to the great river".'
c $A708 Handler for the rope: THROW ACROSS (the river)
D $A708 Throwing the rope across a river: the exit through the river must lead somewhere. 'it sails across and ...'. Then chance takes over (#R$A762: evens). If the wooden boat (object 41, location at #R$C51A) is moored on the far side, the rope may land in the boat, which is then tied to it ('lands in the boat'), or fall short; if the boat is not there, the rope may land on the other side (and is moved there) or fall just short of it and come back.
C $A708 A = the instrument (the river)
C $A70B Find the exit that passes through it
C $A710 No such exit: fail with the usual message
C $A713 Dry run? Then stop here: it would work
C $A716 "it sails across and"
C $A71C A = wherever the wooden boat currently is
C $A71F Is the boat moored on the far side of this exit?
C $A722 No: try the other outcome, below
C $A724 Yes: an even chance - does the rope land well?
C $A727 No: it falls short or slides out (below)
C $A729 "falls just short of the other side."
C $A72C Another even chance - does it end up IN the boat, or just miss?
C $A72F It just misses: print the "falls short" message and finish
C $A731 "lands in the boat. but slides out again."
C $A736 It landed well: mark the boat as now tied to the rope, for #R$A76A to use
C $A73B "lands in the boat."
C $A740 The boat is not over there: another even chance - does the rope reach the far bank anyway?
C $A746 No: print "falls just short" and finish
C $A748 Yes: A = the far bank
C $A74B IX = the rope's own record
C $A74F It moves to that bank...
C $A752 ...held by nobody
C $A756 Move it there, and report it if Bilbo can see
C $A75C "lands on the other side."
c $A762 Evens
D $A762 Returns with carry set if a random number from 0 to 100 (#R$9BF4) is below 50.
C $A762 A = 100
C $A764 Pick a random number from 0 to 100
C $A767 Below 50?
C $A769 Carry reflects the answer
c $A76A Handler for the rope: PULL
D $A76A If the boat is tied to the rope, pulling it brings it over: 'the boat glides across the river and lands on this side.' The boat moves between room 66 and room 67 (the east bank), is untied, and takes whatever is in it along (#R$9B38). This is the way across the enchanted river - the HELP message at the river is 'boats can help. look carefully.'
C $A76A Dry run? Then stop here: it would work
C $A76D Is the boat actually tied to the rope (the flag set by #R$A708)?
C $A772 No: nothing to pull
C $A773 "the boat glides across the river and lands on this side."
C $A779 A = where the boat currently is
C $A77C Is it on this side already (room 66)?
C $A780 No: it will end up on this side (room 66)
C $A782 Yes (an odd case): send it to the OTHER side instead (room 67)
C $A784 The boat moves there
C $A787 B = that room
C $A788 The rope is no longer tied to it
C $A78D A = the boat's own object number
C $A78F Move it (and anything in it) there, reporting it if seen
c $A792 Handler for the boat: it crosses by itself
D $A792 Chained after one of the boat's handlers: when Bilbo really does it, 'with a lurch the boat glides across the river', and the boat crosses as for #R$A76A.
C $A792 Only if this is really happening
C $A795 Is the actor Bilbo?
C $A799 No: nothing happens (this only triggers for Bilbo's own actions on the boat)
C $A79A "with a lurch the boat glides across the river and lands on the other side."
C $A79D Join the PULL code above, which actually moves it
c $A79F Character routine: Bard remembers his orders
D $A79F If Bard has been given an order (#R$8907), it is checked and then written into Bard's own behaviour program: the action ($B5D7), target and instrument ($B5D9, #R$B5DA) are stored at $C8D2-$C8D4, and the first byte at #R$C8D1 is set to $42 (an action instruction that cannot be interrupted by orders). From then on Bard carries out that order every turn. So 'say to bard "shoot the dragon"' keeps him shooting until it works.
D $A79F SAVE and LOAD (#R$8284, #R$8209) preserve the three bytes at #R$C8D1-$C8D3, because the behaviour programs are not otherwise saved; the instrument at $C8D4 is not included.
C $A79F Has the player given Bard an order?
C $A7A4 No: nothing to do
C $A7A5 It is dealt with now
C $A7AA Take the order and match it to an action and objects
C $A7AD It makes no sense: ignore it
C $A7AE Do not carry it out now
C $A7B2 Write the action...
C $A7B5 ...into Bard's next instruction at #R$C8D1...
C $A7B8 ...with its target and instrument...
C $A7C0 ...and make it an action instruction that orders cannot interrupt ($42)
C $A7C5 From now on Bard repeats it every turn
c $A7C6 Character routine: Gollum asks his riddle
D $A7C6 If Gollum (whose location is at #R$C3B0) is in Bilbo's room and Bilbo is visible, he asks the riddle chosen at the start of the game (#R$970B, #R$C6EB), and $B5EA is set to show he is waiting for an answer.
C $A7C6 A = Gollum's own location
C $A7C9 Is Bilbo in the same room?
C $A7CD No: say nothing
C $A7CE Is Bilbo actually visible?
C $A7D3 No (he is wearing the ring): Gollum cannot see him to ask
C $A7D4 Dry run? Then stop here: it always works
C $A7D7 HL = the riddle chosen at the start of the game...
C $A7DA ...moved on 2 bytes, to the riddle's own text
C $A7DC DE = the riddle's address
C $A7DF HL = that address
C $A7E1 Gollum asks it
C $A7E4 Remember that he is now waiting for the answer
c $A7EA Character routine: Gollum waits for the answer
D $A7EA Next time, Gollum looks for an order given to him by the player (#R$8907): the answer must be said to him, as in SAY TO GOLLUM "NIGHT". The words of the order are searched for the answer word stored in the riddle's entry (the CPIR loop). If the answer is there, all is well. If not, or if the player said nothing: 'someone strangles you from behind.', and Bilbo is dead (#R$903C).
C $A7EA Dry run? Then just record that this would work, and return
C $A7ED Gollum is no longer waiting for an answer...
C $A7F1 Take the order the player gave Gollum (SAY TO GOLLUM "...") off the orders buffer; HL points at it
C $A7F4 Nothing was said to him: Bilbo is strangled
C $A7F6 Search the 24 bytes of the order...
C $A7F9 DE = the riddle entry chosen at the start of the game
C $A7FD A = the low byte of the answer word (NIGHT or MAN)
C $A7FE Look for it in the order
C $A800 Not there: Bilbo is strangled
C $A802 Found: now check the high byte of the word
C $A805 Does the next byte of the order match it?
C $A806 No: keep searching the rest of the order
C $A808 Yes: the answer was right, and Bilbo lives
C $A809 Dry run? Then stop
C $A80C Make sure the player sees the message
C $A811 "someone strangles you from behind."
C $A817 Bilbo is dead
c $A81A Character routine: Gollum mutters
D $A81A If Gollum is in Bilbo's room: usually, if Gollum still has the golden ring (object 16), 'my birthday present, how did we lose it. my precious'; otherwise 'what has it got in its pocketses?'. The test at #R$A82A only rarely (a random 8) says the pocketses line regardless.
C $A81A A = Gollum's own location
C $A81D Is Bilbo in the same room?
C $A821 No: say nothing
C $A822 Dry run? Then stop here: it always works
C $A825 "what has it got in its pocketses?"
C $A828 Pick a random number from 0 to 8
C $A82D Is it negative (the rare, skewed case)? If so, say that regardless
C $A830 Otherwise: IX = the golden ring's own record
C $A834 Does Gollum (object 68) still hold it?
C $A839 Yes: say the "pocketses" line anyway
C $A83C "my birthday present, how did we lose it. my precious"
C $A83F No (he has lost it): say that instead
c $A842 Character routine: a character eats Bilbo
D $A842 If the character is in Bilbo's room, it 'eats' him: the EAT action is reported with Bilbo as the target (#R$9EBF), the food code is run (#R$921F) and Bilbo dies (#R$903C).
C $A842 A = the room the character started this turn in
C $A845 Is Bilbo in that same room?
C $A849 No: nothing happens
C $A84A Dry run? Then stop here: it always works
C $A84D A = the EAT action
C $A852 The target is Bilbo (object 0)
C $A857 No instrument
C $A85C Report it in words ("the hideous troll eats you.")
C $A85F Run the ordinary eating code (for its side effects)
C $A862 Bilbo dies
c $A865 Character routine: dawn in the trolls' clearing
D $A865 The trolls turn to stone at dawn. Both trolls (objects 71 and 72) are killed (#R$96DD) and made invisible, and whatever they carried - including the large key - is left behind (#R$9CA8). The trolls' clearing (room 5) gets a new description script, 'in a clearing with two stone trolls', and the game announces 'day dawns.'
D $A865 The first two bytes of the room 5 picture (the border and paper colours, see #R$8BE9) are set to 5 and $28: cyan. At the start of a game (#R$6C27) they are set to 0, so the clearing is drawn in black until dawn, and in daylight colours afterwards.
C $A865 Dry run? Then stop here: it always works
C $A868 Kill the hideous troll (object 71)...
C $A86D ...and the vicious troll (object 72) too
C $A872 The hideous troll becomes invisible...
C $A877 ...and so does the vicious troll
C $A87C "in a clearing with two stone trolls"
C $A87F This becomes the clearing's new description script
C $A882 The clearing's "visited" flag is cleared...
C $A885 ...so it will be described in full again, with the new text
C $A887 Everything the hideous troll was carrying is left behind...
C $A88C ...and likewise for the vicious troll
C $A891 "day dawns."
C $A894 Make sure Bilbo sees this, wherever he is
C $A89C Find the clearing's own picture...
C $A8A5 HL = its address
C $A8AB Its border colour becomes cyan...
C $A8AE ...and so does its background, so it is drawn in daylight from now on
c $A8B1 Character routine: the trolls talk
D $A8B1 In the trolls' clearing, the hideous troll (object 71) says 'blimey, look at this! can yer cook 'em?' and the other troll 'yer can try, but he wouldn't make above a mouthful'.
C $A8B1 Is Bilbo in the trolls' clearing (room 5)?
C $A8B6 No: say nothing
C $A8B7 Dry run? Then stop here: it always works
C $A8BA Is the speaker the hideous troll (object 71)?
C $A8C2 Yes: "blimey, look at this! can yer cook 'em?"
C $A8C4 No (the vicious troll): "yer can try, but he wouldn't make above a mouthful"
c $A8CA Has the game been won?
D $A8CA Called at the end of every turn (from #R$9611). If the valuable treasure (object 35) is in the wooden chest (object 37, back at Bilbo's home), the game is won: 'a cheering crowd of dwarves, hobbits and elves appear. led by gandalf they carry you off into the sunset, proclaiming you hero of heroes and master adventurer!!!' The score is then printed and the game ends (#R$9049).
C $A8CA A = the treasure's holder
C $A8CD Is it the wooden chest (object 37)?
C $A8CF No: the game goes on
C $A8D0 "a cheering crowd of dwarves, hobbits and elves appear..."
C $A8D6 Print the score and end the game
c $A8D9 Character routine: Elrond gives Bilbo lunch
D $A8D9 If Elrond is in Bilbo's room and object 38 (lunch) has not yet been handed over, it is placed with Elrond and he gives it to Bilbo (#R$9308).
C $A8D9 A = the room the character started this turn in
C $A8DC Is Bilbo in that same room?
C $A8E0 No: nothing happens
C $A8E1 IX = the lunch's own record
C $A8E5 Has it already been placed anywhere (i.e. already given)?
C $A8EA No (still nowhere): give it now, below
C $A8EC Yes - is it still held by Elrond himself?
C $A8F1 No (already handed over): nothing more to do
C $A8F2 Dry run? Then stop here: it always works
C $A8F5 The lunch appears in this room...
C $A8FB ...held by Elrond
C $A8FF The lunch (object 38) is the target...
C $A906 The action is GIVE TO
C $A90B IX = the lunch's own record, for GIVE TO to use
C $A90F Bilbo (object 0) is the instrument (the receiver)
C $A915 Report it in words
C $A918 Actually carry out the GIVE TO
c $A91B Handler for the barrel: JUMP ONTO / CLIMB INTO
D $A91B An actor can get into the barrel only from a room with an exit leading to where the barrel is, and only if that exit goes down (direction 10). Otherwise 'you cannot jump onto the barrel from here.' The actor then becomes held by the barrel (and so moves with it, #R$9B38).
C $A91B IY = the barrel's own record
C $A91F B = the room the barrel is in
C $A923 Find an exit from the actor's own room that leads there
C $A928 "you cannot jump onto the barrel from here."
C $A92B No such exit: say so and stop
C $A92E A = that exit's own direction
C $A931 Is it DOWN?
C $A933 No: jump to the message text itself, rather than through the printer - see the bug note
C $A936 Dry run? Then stop here: it would work
C $A939 The actor becomes held by the barrel...
C $A943 ...and moves wherever the barrel goes
C $A946 Is the actor Bilbo?
C $A94B No: nothing more to do
C $A94C Yes: describe the room the barrel is now in
c $A950 Timer 1 expires: the web is mended
D $A950 Two turns after the spider web was broken (#R$A2A7) the spiders have mended it: it is no longer broken, it is closed again (blocking the way), its strength is doubled, and its first adjective is set back to SPIDER (it had become BROKEN, #R$A0BC).
D $A950 Doubling uses SLA, which drops the top bit: the web starts with strength 64, so the first mending makes it 128, and the second makes it 0.
C $A950 IX = the spider web's record
C $A954 Not broken any more
C $A958 Closed again
C $A95C Twice as strong (64, then 128, then 0)
C $A960 Its adjective is SPIDER again...
C $A963 ...instead of BROKEN
c $A968 Timer 9 expires: the side door vanishes
D $A968 The expiry routine of timer 9 (#R$C9B2). If the side door of the Lonely Mountain (object 11, flags at $C1AB) has been opened, nothing happens and the timer stops: the door stays. Otherwise the timer is restarted at its reload value (5), the door is made invisible, and if Bilbo is at the side door (room 42) he reads 'the hole vanishes.'
C $A968 HL = the side door's flags
C $A96B Has it been opened?
C $A96D Yes: it stays open and visible; the timer stops
C $A96E No: restart the timer (count = 5)
C $A977 Make the door invisible
C $A979 Is Bilbo at the side door (room 42)?
C $A97E No: done
C $A97F "the hole vanishes."
c $A985 Timer 9 tick: the side door appears
D $A985 The tick routine of timer 9, run when its count is down to 1. The side door is made visible, and if Bilbo is in room 42 he reads 'there is a loud crack and a hole appears about three feet from the ground. you are standing in front of the side door to the lonely mountain.' Next turn the timer expires (#R$A968), and unless Bilbo has opened the door by then, it vanishes again.
C $A985 HL = the side door's flags
C $A988 Make it visible
C $A98A Is Bilbo at the side door (room 42)?
C $A98F No: done
C $A990 "there is a loud crack and a hole appears about three feet from the ground..."
c $A996 Handler for the side door: closing it
D $A996 Chained after the normal CLOSE handler in the side door's record. When the door is really closed, it is locked again (bit 0), made invisible, and timer 9 is restarted with a count of 6; 'the hole vanishes.' is printed (via #R$A97F). So closing the side door puts it back into its appear-and-vanish cycle.
C $A996 Only if the door is really being closed
C $A999 Restart timer 9 with a count of 6
C $A99E HL = the side door's flags
C $A9A1 Lock it
C $A9A3 Hide it
C $A9A5 "the hole vanishes."
c $A9A7 Timer 5 tick: the magic door opens and an elf sweeps past
D $A9A7 Timer 5 is started when an invisible Bilbo examines the magic door (#R$A614: 'the magic door warns of elves approaching'). When its count reaches 1, the magic door (object 13) opens, and if Bilbo is in room 28 or 30 he sees 'the magic door opens.' and 'an elf sweeps past.' Then the ring check of timer 6 is run (#R$A9D4), which takes the ring off anyone wearing it.
C $A9A7 HL = the magic door's flags
C $A9AA Open it
C $A9AC "the magic door opens."
C $A9AF Print it if Bilbo is nearby
C $A9B2 "an elf sweeps past."
C $A9B8 Take the ring off whoever is wearing it
c $A9BB Print a message if Bilbo is near the magic door
D $A9BB Prints the message at HL if Bilbo is in room 30 or room 28, the rooms on either side of the magic door.
C $A9BB Is Bilbo in room 30...
C $A9C0 ...then print it
C $A9C3 ...or room 28?
C $A9C5 ...then print it
C $A9C8 Otherwise say nothing
c $A9C9 Timer 5 expires: the magic door closes
D $A9C9 The turn after the elf has swept past, the magic door closes again ('the magic door closes.', if Bilbo is near).
C $A9C9 HL = the magic door's flags
C $A9CC Close it
C $A9CE "the magic door closes."
C $A9D1 Print it if Bilbo is nearby
c $A9D4 Timer 6 expires: the ring comes off
D $A9D4 When timer 6 (started by #R$A2C0) runs out, whoever holds the golden ring becomes the actor and, if the ring is still being worn (it is invisible), it is taken off (#R$A2EC). If nobody holds the ring, nothing happens.
C $A9D4 IX = the ring's record
C $A9D8 Who holds it?
C $A9DD Nobody: nothing to do
C $A9DE IX = the holder's record...
C $A9E1 ...who becomes the actor
C $A9E5 Is the ring being worn (invisible)?
C $A9E9 Yes: take it off
c $A9ED Handler for the wine: Bilbo gets drunk
D $A9ED Attached to the wine's DRINK handler. If the drinker is Bilbo, the flag at $B5F1 is set and timer 7 started, so that for five turns every S he sees is followed by an H (#R$7580).
C $A9ED Is the drinker Bilbo?
C $A9F2 No (a character): nothing happens
C $A9F3 Yes: set the "drunk" flag...
C $A9F8 ...and start timer 7 (copy its reload value into its count)
c $A9FF Timer routine
D $A9FF Clears the flag at $B5F1.
C $A9FF Clear the "drunk" flag: Bilbo has sobered up
c $AA04 Timer 2 expires: smothered by the spiders
D $AA04 The expiry routine of timer 2 (count 5), started when Bilbo enters the place of black spiders (#R$C6A1). The count drops to 4 at the end of the turn he enters, so it reaches 0 at the end of his fourth turn after that: if he is still in room 26, 'the spider web is slowly smothering you', and he dies. In the emulator, entering and waiting three times, then leaving, is safe; waiting a fourth time is fatal.
C $AA04 Is Bilbo still in the spiders' place (room 26)?
C $AA09 No: he got away
C $AA0A "the spider web is slowly smothering you"
C $AA10 Bilbo is dead
c $AA13 Pale bulbous eyes: tick routine
D $AA13 Called by #R$9611 on each turn that the eyes timer (entry at #R$C9AB) is counting down and at or below its threshold of 3. It prints 'you see some pale bulbous eyes staring at you' (#R$B203).
D $AA13 It then checks whether Bilbo has moved. #R$C01B is Bilbo's location (the first location byte of object 0, see #R$C00B) and #R$B5E4 is the room he was in when the timer was started. If he is still in the same room, all is well. If he has moved to the other 'eyes' room (from 2 to 3 or from 3 to 2), all is also well. Otherwise he has left too early: execution falls into #R$AA3E, which prints 'some thing drops from above and stings' (#R$B211) and kills him (#R$903C).
D $AA13 In practice the room-2/room-3 exception is never needed, because entering either room restarts the timer anyway (see #R$C6CC).
C $AA13 Print the eyes message
C $AA16 Print the message at HL
C $AA19 C = Bilbo's current room
C $AA1C C = A
C $AA1D HL = the address of the room where the eyes timer started
C $AA20 Still in the same room: fine
C $AA21 Return if yes
C $AA22 B = (HL)
C $AA23 A = the other eyes room
C $AA25 Compare with B
C $AA26 If no, go to #R$AA2A
C $AA28 A = 3
C $AA2A Moved to the other eyes room: fine
C $AA2B Return if yes
C $AA2C Otherwise: stung to death
c $AA2E Pale bulbous eyes: expire routine
D $AA2E Called by #R$9611 when the eyes timer reaches 0. If Bilbo is still in room 2 (the forest road) or room 3 (the forest), he has stayed too long: the eyes are shown, the thing drops from above and stings, and Bilbo dies. If he is anywhere else, nothing happens.
D $AA2E Together with #R$AA13 and #R$C6CC, this produces the well-known rule: on entering the forest, wait twice and move on the third turn. The timer is set to 4 on entry; the turn of entry leaves it at 3, the two waits take it to 2 and then 1 (the tick routine is happy each time because Bilbo is still there), and the move takes it to 0 with Bilbo already out of the forest. Wait a third time and the timer expires with Bilbo still there; move sooner and the tick routine sees him gone while the timer is still running.
C $AA2E Is Bilbo in room 2 or room 3?
C $AA31 Is it room 2?
C $AA33 If yes, go to #R$AA38
C $AA35 Is it room 3?
C $AA37 Return if no
C $AA38 Yes: eyes...
C $AA3B Print the message at HL
C $AA3E ...sting...
C $AA41 Print the message at HL
C $AA44 ...and death
b $AA47 Action table
D $AA47 The 59 actions the game knows, 8 bytes each, numbered from 1 (#R$70DF works out the address). Each entry is four word references, low byte first: the verb, a particle, a preposition, and a fourth word (GO for the ten movement actions). The parser's command is matched against these by #R$858F, so an action is really a verb plus the little words that go with it: TAKE, TAKE OUT OF, TAKE FROM and TAKE OFF are four different actions.
D $AA47 The top nibble of each word's high byte holds flags (collected by #R$70EA and decoded by #R$8569): whether a target and an instrument are needed, whether they can be rooms, whether the action can be done in the dark, and how it is reported.
D $AA47 Only the verbs appearing here do anything. Any other verb in the dictionary (WAIT, JUMP, SING...) just produces 'you wait. time passes...' (#R$858F).
B $AA47,8,8 Action 1: north go
B $AA4F,8,8 Action 2: south go
B $AA57,8,8 Action 3: east go
B $AA5F,8,8 Action 4: west go
B $AA67,8,8 Action 5: northeast go
B $AA6F,8,8 Action 6: northwest go
B $AA77,8,8 Action 7: southeast go
B $AA7F,8,8 Action 8: southwest go
B $AA87,8,8 Action 9: up go
B $AA8F,8,8 Action 10: down go
B $AA97,8,8 Action 11: strike with
B $AA9F,8,8 Action 12: close
B $AAA7,8,8 Action 13: drop
B $AAAF,8,8 Action 14: drop in
B $AAB7,8,8 Action 15: attack with
B $AABF,8,8 Action 16: open
B $AAC7,8,8 Action 17: put in
B $AACF,8,8 Action 18: put on
B $AAD7,8,8 Action 19: take
B $AADF,8,8 Action 20: take out of
B $AAE7,8,8 Action 21: take from
B $AAEF,8,8 Action 22: take off
B $AAF7,8,8 Action 23: look
B $AAFF,8,8 Action 24: look through
B $AB07,8,8 Action 25: look across
B $AB0F,8,8 Action 26: inventory
B $AB17,8,8 Action 27: eat
B $AB1F,8,8 Action 28: examine
B $AB27,8,8 Action 29: give to
B $AB2F,8,8 Action 30: go through
B $AB37,8,8 Action 31: enter
B $AB3F,8,8 Action 32: go into
B $AB47,8,8 Action 33: drink
B $AB4F,8,8 Action 34: empty
B $AB57,8,8 Action 35: fill with
B $AB5F,8,8 Action 36: run
B $AB67,8,8 Action 37: lock with
B $AB6F,8,8 Action 38: unlock with
B $AB77,8,8 Action 39: follow
B $AB7F,8,8 Action 40: wear
B $AB87,8,8 Action 41: throw
B $AB8F,8,8 Action 42: throw at
B $AB97,8,8 Action 43: throw across
B $AB9F,8,8 Action 44: throw through
B $ABA7,8,8 Action 45: burn
B $ABAF,8,8 Action 46: tie to
B $ABB7,8,8 Action 47: cut
B $ABBF,8,8 Action 48: capture
B $ABC7,8,8 Action 49: pull
B $ABCF,8,8 Action 50: swim
B $ABD7,8,8 Action 51: untie
B $ABDF,8,8 Action 52: climb
B $ABE7,8,8 Action 53: talk to
B $ABEF,8,8 Action 54: climb into
B $ABF7,8,8 Action 55: climb out of
B $ABFF,8,8 Action 56: jump onto
B $AC07,8,8 Action 57: dig
B $AC0F,8,8 Action 58: shoot
B $AC17,8,8 Action 59: carry
b $AC1F Articles
D $AC1F #R$7436 uses these to put an article in front of a noun. The first two bytes are unused. At #R$AC21: THE, A, AN, SOME (chosen by flag bits in the noun's reference); at #R$AC29: THE, THE, THE, SOME (used when a definite article is wanted).
B $AC1F,2,2
W $AC21,8 THE, A, AN, SOME
W $AC29,8 THE, THE, THE, SOME
w $AC31 Abbreviated words
D $AC31 The 32 most frequent words in messages, referenced by single bytes $60-$7F (see #R$748A). Each entry is a dictionary reference with $50 subtracted from its high byte. Using one byte instead of two for words such as 'the', 'you', 'is' and 'and' saves a lot of space across all the game's messages.
W $AC31,64 Words for codes $60-$7F
b $AC71 Messages and scripts
D $AC71 The game's messages, in the bytecode format interpreted by #R$72D4. Each message below is labelled with its text, obtained by running the game's own message printer on it in an emulator. In the labels, 'you' stands for the actor, 'the thing' for the target of the command, 'the other' for the instrument, and 'word' for a word or object passed as a parameter; the real text changes with who is acting and on what ('you cleave his skull' / 'thorin cleaves your skull').
D $AC71 There are about 180 messages. Almost every byte of this area belongs to a message that the program uses; the one exception is at #R$B4EF, a fuller description of the bewitched gloomy place ('a bewitched gloomy place surrounded by thick trees') that nothing refers to - room 25 is described by its name words instead.
B $AC71,13,13 "but fall and hit your HEAD."
B $AC7E,9,9 "but fall and smash your skull."
B $AC87,12,12 "i do not know the word ""
B $AC93,4,4 "what ?"
B $AC97,6,6 "you word. time passes..."
B $AC9D,7,7 "time passes..."
B $ACA4,16,16 "i do not know the verb " word word word ""
B $ACB4,4,4 "word word word what ?"
B $ACB8,8,8 "word word word what ?"
B $ACC0,7,7 "which word ?"
B $ACC7,7,7 "i do not see the word here"
B $ACCE,7,7 "(end of the previous message, followed by a fragment used by it)"
B $ACD5,6,6 "i see nothing to word word word"
B $ACDB,9,9 "i see nothing to word word word"
B $ACE4,5,5 "you are not carrying it."
B $ACE9,3,3 "you are carrying."
B $ACEC,3,3 "is carrying"
B $ACEF,8,8 "and it gets swept away."
B $ACF7,8,8 "the thing is too heavy to lift."
B $ACFF,5,5 "you are carrying too much."
B $AD04,6,6 "you are already carrying the thing."
B $AD0A,3,3 "to the"
B $AD0D,5,5 "the other is too full."
B $AD12,4,4 "it is dark."
B $AD16,11,11 "the word is too small for you to enter."
B $AD21,12,12 "the word is too full for you to enter."
B $AD2D,15,15 "with one well placed blow you cleave his skull."
B $AD3C,17,8 "your VIOLENT attack almost kills the thingis."
B $AD4D,22,8 "you give the thing a vicious cut in the ribs- his strength is failing fast."
B $AD63,10,10 "a nasty slice misses his heart."
B $AD6D,17,8 "you slice his- hand blood drips slowly to the ground."
B $AD7E,13,13 "you give the thing a nasty slash in the leg."
B $AD8B,20,8 "you hit the thing hard on the shoulder- the thing staggers and almost falls."
B $AD9F,14,14 "a fast blow knocks the wind out of the thing."
B $ADAD,23,8 "a fast stroke sweeps the thing off his feet, but the thing is on guard in a moment."
B $ADC4,17,8 "you hit the thing with a glancing blow andleave the thing momentarily stunned."
B $ADD5,18,8 "you thrust the thing back- the thing loseshis footing but recovers quickly."
B $ADE7,21,8 "you swing broadside at his body but at thelast moment the thing jumps aside."
B $ADFC,12,12 "your word sweeps past close to his ear."
B $AE08,11,11 "you slash at the thing but the blow is ineffective."
B $AE13,11,11 "you brandish your word, but the thing is on guard."
B $AE1E,17,8 "you swing feebly at the thing but miss by a wide margin."
B $AE2F,20,8 "you seem tired- you stagger but valiantLY attempt another blow."
B $AE43,15,15 "but the effort is wasted. his defense is too strong."
B $AE52,7,7 "you cannot kill with the other."
B $AE59,7,7 "it sails across and"
B $AE60,9,9 "landS on the other side."
B $AE69,12,12 "falls just short of the other side."
B $AE75,9,9 "landS in the boat. but slides out again."
B $AE7E,7,7 "landS in the boat."
B $AE85,18,8 "the boat glides across the river and landSon this side."
B $AE97,17,8 "with a lurch the boat glides across the river and landS on the other side."
B $AEA8,6,6 "the thing is not in the other."
B $AEAE,4,4 "the word is word."
B $AEB2,5,5 "i cannot do that."
B $AEB7,6,6 "i see nothing here."
B $AEBD,25,8 "in the word there word"
B $AED6,5,5 "the word is carrying the word."
B $AEDB,8,8 "i cannot follow the thing from here."
B $AEE3,3,3 "you are dead."
B $AEE6,8,8 "you see nothing special here."
B $AEEE,1,1 "you are in"
B $AEEF,3,3 "in"
B $AEF2,3,3 "you see"
B $AEF5,6,6 "you see :"
B $AEFB,6,6 "you say ""
B $AF01,4,4 ""."
B $AF05,4,4 "there is the word"
B $AF09,2,2 "the word enters."
B $AF0B,3,3 "1."
B $AF0E,4,4 "the word appears."
B $AF12,7,7 "visible exits are:"
B $AF19,6,6 "you hear a noise."
B $AF1F,10,10 "the other doES not fit this lock."
B $AF29,8,8 "the magic door opens."
B $AF31,8,8 "the magic door closes."
B $AF39,4,4 "thank you"
B $AF3D,7,7 "what'S this ?"
B $AF44,9,9 "you are doing a great job"
B $AF4D,4,4 "hurry up"
B $AF51,2,2 "hello"
B $AF53,7,7 "this was thrains key"
B $AF5A,12,12 "the thing falls down a hole and vanishes."
B $AF66,9,9 "you are not wearING the thing."
B $AF6F,8,8 "the other is already tieD."
B $AF77,13,13 "the vicious warg run around you and howls"
B $AF84,7,7 "the thing is not tieD."
B $AF8B,13,13 "some spiderS start mending the broken web."
B $AF98,14,14 "what do you expect me to do with this ?"
B $AFA6,23,8 "as soon as you touch the river you fall asleep and gently float away."
B $AFBD,10,10 "where'S the thief ?"
B $AFC7,16,16 "get us out of this one, thief !"
B $AFD7,15,15 "thorin sits down and starts singing about gold"
B $AFE6,4,4 "thorin wait"
B $AFEA,5,5 "you fall asleep."
B $AFEF,12,12 "the spider web is slowly smothering you"
B $AFFB,10,10 "the small curious key shatters."
B $B005,8,8 "an elf sweeps past."
B $B00D,6,6 "you cannot reach the thing."
B $B013,6,6 "you are not carrying the bow."
B $B019,15,15 "the arrow missES the other by a wide margin."
B $B028,8,8 "the arrow hitS the thing."
B $B030,4,4 "you are too big."
B $B034,1,1 "the word evaporates."
B $B035,3,3 "evaporates."
B $B038,13,13 "your foul gluttony has killED you."
B $B045,10,10 "you are slowly sinking into the bog."
B $B04F,33,8 "the dragon says " well thief your cunning has failed you this time. prepare to die " ."
B $B070,40,8 "the dragon says " i may not be able to seeyou thief but i can still burn you. prepare to die " ."
B $B098,20,8 "in the distance you see the shape of a monstrous dragon flying after you."
B $B0AC,22,8 "the dragon descends and in a terrific spout of flames burns you to a crisp."
B $B0C2,11,11 "go word from the word to get to the word"
B $B0CD,8,8 "someone strangles you from behind."
B $B0D5,11,11 "the thing sayS " no ""
B $B0E0,74,8 "it cannot be seeN, cannot be felt cannot be heard, cannot be smelt. it lies behind stars and under hills, and ..."
B $B12A,20,8 "blimey, look at this!! can yer cook'EM?"
B $B13E,22,8 "yer can try, but he wouldN'T make above a mouthfull"
B $B154,11,11 "in a clearing with two stone trolls"
B $B15F,10,10 "you are swept forcefully against the portcullis."
B $B169,45,8 "there is a loud crack and a hole appears about three feet from the ground. you are standing in front of the si..."
B $B196,6,6 "the hole vanishes."
B $B19C,13,13 "the magic door warns of elves approaching."
B $B1A9,34,8 "which is the animal that has four feet in the morning, two at midday and three in the evening ?"
B $B1CB,14,14 "what has it got in its pockets ?"
B $B1D9,26,8 "my birthday present " how did we lose it. my precious ""
B $B1F3,10,10 "you cannot jump onto the thing from here."
B $B1FD,6,6 "day dawns."
B $B203,14,14 "you see some pale bulbous eyes staring at you."
B $B211,13,13 "some thinG drops from above and stings."
B $B21E,15,15 "you are thrown onto the bank of the long lake."
B $B22D,7,7 "nothing"
B $B234,21,8 "start TAPE then PRESS ANY key."
B $B249,42,8 "TAPE ERROR - hit ANY key to RESTART PROGRAM."
B $B273,35,8 "TAPE ERROR - hit ANY key to CONTINUE."
B $B296,53,8 "REWIND and PREPARE TAPE for VERIFICATION -- then hit ANY key."
B $B2CB,122,8 "a CHEERING CROWD of DWARVES, HOBBITS and elves appears. LED by gandalf THEY carry you off into the SUNSET, PRO..."
B $B345,14,14 "you have MASTERED"
B $B353,5,5 "% of this adventure."
B $B358,19,8 "YOU'RE DOING FINE."
B $B36B,16,16 "a trolls door NEEDS a trolls key."
B $B37B,16,16 "elves are GOOD at readING symbols."
B $B38B,36,8 "a window SHOULD be no OBSTACLE to a thief with FRIENDS."
B $B3AF,12,12 "boatS can help. look carefully."
B $B3BB,16,16 "wait around and time your EXIT carefully."
B $B3CB,32,8 "TIMING is CRITICAL, REMEMBER barrelS float."
B $B3EB,10,10 "wait a WHILE."
B $B3F5,20,8 "take CARE to leave at the RIGHT time."
B $B409,23,8 "a LIVING dragon is DEADLY, look to bard."
B $B420,15,15 "DON'T STAY here too long."
B $B42F,20,8 "wait for the NEW day DAWNING."
B $B443,17,8 "there seem to be some symbols on it but you cannot read them."
B $B454,18,8 "you see a fast flowing black river not very wide across."
B $B466,9,9 "a comfortable tunnel like hall"
B $B46F,14,14 "a gloomy empty land with dreary hills ahead"
B $B47D,14,14 "a hidden path with trolls foot printS"
B $B48B,5,5 "the trolls cave"
B $B490,13,13 "a hard dangerous path in the misty mountains"
B $B49D,18,8 "a narrow place with a dreadful drop into adim valley"
B $B4AF,7,7 "a narrow dangerous path"
B $B4B6,14,14 "a large dry cave which is quite comfortable"
B $B4C4,17,8 "a big cavern with torchES along the wallS"
B $B4D5,15,15 "the brink of a deep dark under ground lake"
B $B4E4,5,5 "the goblins gate"
B $B4E9,6,6 "the gate to mirkwood"
B $B4EF,17,8 "a bewitched gloomy place surrounded by thick trees (not used)"
B $B500,10,10 "a place of black spiderS"
B $B50A,11,11 "a forest of tangled smothering trees"
B $B515,14,14 "aN elvish clearing with levelled ground and logs"
B $B523,11,11 "a dark dungeon in the elvenkings halls"
B $B52E,18,8 "the cellar where the king keeps his barrelS of wine"
B $B540,14,14 "a wooden town in the middle of long lake"
B $B54E,20,8 "a strong river: the current is now too strong to move against"
B $B562,15,15 "a bleak barren land that was once green"
B $B571,10,10 "the ruins of the town of dale"
B $B57B,11,11 "the front gate of the lonely mountain"
B $B586,8,8 "the west side of ravenhill"
B $B58E,10,10 "the halls where the dragon sleeps"
B $B598,23,8 "a little steep bay, still and quiet, with an over hanging cliff"
B $B5AF,7,7 "a smooth straight passage"
B $B5B6,5,5 "the lonely mountain"
B $B5BB,5,5 "the west bank of a black river"
B $B5C0,11,11 "the east bank of a black river"
g $B5CB Game variables
D $B5CB Working variables. Those identified so far:
D $B5CB #LIST { #R$B5CB - address of the current word in the input line (for error messages) } { #R$B5DA - object number of the weapon/instrument in the current command, or $FF } { #R$B5DB - the current actor: 0 when the player is acting, otherwise the object number of the character } { $B5E1 - set when a timer has expired this turn (#R$9611) } { #R$B5E4 - the room in which the eyes timer was started (#R$C6CC) } { $B5EB - 1 when commands should really be carried out, 0 during a dry run (#R$9C99) } { $B5F3 - output enable flag } { #R$B5F8 - address of the target's object record } { $B5FA - address of the weapon's object record } { $B5FC - address of the actor's object record } { #R$B5FE - random number seed (#R$9BFD) } LIST#
D $B5CB The 28 bytes from #R$B5DC are backed up to $5F00 at start-up and restored when the game restarts.
B $B5CB,13,13
B $B5D8,2,2 Movement direction and other command variables
B $B5DA,1,1 Weapon object number
B $B5DB,1,1 Current actor
B $B5DC,28,8 Backed-up variables (28 bytes)
B $B5F8,6,6 Target, weapon and actor record addresses
B $B5FE,17,8 Random seed and state
t $B60F Verb endings
D $B60F Six 4-byte endings added to verbs by #R$74B8 when the subject is not 'you': S, ES, IES, a backspace and IES (the backspace rubs out a final Y: 'carry' becomes 'carries'), D and ING. The rest of the 32 bytes are unused, and are followed by the orders buffer at #R$B628.
T $B60F,1,1 S
B $B610,3,3
T $B613,2,1 ES
B $B615,2,2
T $B617,3,1 IES
B $B61A,1,1
B $B61B,1,1 Backspace
T $B61C,3,1 IES
T $B61F,1,1 D
B $B620,3,3
T $B623,3,1 ING
B $B626,2,2
b $B628 Orders buffer and command frames
D $B628 #R$B628: the orders buffer, eight 25-byte slots holding commands given to characters in quotation marks (#R$80CD, #R$88A7), cleared at start-up. Below #R$B8D0 are the 24-byte command frames built by the parser, the first at #R$B8B8 and the rest below it (#R$7C4F).
B $B628,656,8 Orders buffer
B $B8B8,24,8 First command frame
w $B8D0 Room pointer table
D $B8D0 Addresses of the records for rooms 0 to 79 (used by #R$9B0C). Room numbers are what appear in objects' location bytes and in the exits of other rooms. Some examples: 1 is Bilbo's comfortable tunnel-like hall, 2 is the forest road and 3 the forest (the 'pale bulbous eyes' rooms), 5 is the trolls' clearing, 7 is the trolls' cave, 22 is Beorn's house, 26 is the place of black spiders, 29 is the deep bog, 46 is the stretch of forest road west of the eyes, and 61 is where the golden ring starts.
W $B8D0,160 Rooms 0-79
w $B970 Room prepositions
D $B970 The words used by #R$958E to say where Bilbo is: OUTSIDE, INSIDE, IN, ON and AT. Bits 1-3 of the first byte of a room record choose one, so room 2 (flags $86) gives "you are ON the forest road". Bit 7 of the same byte says whether the room is lit.
W $B970,10
b $B97A Room records
D $B97A One record per room, in no particular order (the table at #R$B8D0 points to each one). The format, using room 2 (the forest road) as an example, whose record is at #R$BDC3 and reads $86,$FF,$53,$05,$A4,$02,$00,$00,$00,$00,$03,$00,$03,$04,$00,$2E,$FF:
D $B97A Byte 0: flags ($86). Bit 7 means the room is lit; bit 6 is set once Bilbo has visited it (#R$8D19); bits 1-3 choose the preposition used to describe it (#R$B970): here 3, ON. Byte 1: the room's capacity, used when something tries to move in (#R$9B96); $FF means unlimited.
D $B97A Bytes 2-7: up to three word references (little-endian, offsets from #R$6000) that make up the room's name: here $0553 ROAD and $02A4 FOREST, printed as 'you are on the forest road'. Unused slots are 0.
D $B97A Bytes 8-9: the address of an extra description script, or 0 if there is none. Room 7, the trolls' cave, uses this for its extra text.
D $B97A Then any number of 3-byte exits: direction, a door/condition byte (non-zero when the way is through a door or has some other condition) and the destination room. Here: $03 (east) to room 3, and $04 (west) to room 46 ($2E). The list ends with $FF.
D $B97A These records are backed up at start-up and restored on restart (#R$6C00), because doors and some descriptions change during play.
B $B97A,13,13 Room 0: (no name)
B $B987,14,14 Room 1: tunnel like hall. lit, "in". Exits: E to 4 through object 5
B $B995,23,8 Room 4: lonelands. lit, "in". Exits: W to 1 through object 5, E to 5, N to 5, NE to 6
B $B9AC,20,8 Room 5: trolls clearing. lit, "in". Exits: SW to 4, SE to 9, N to 6
B $B9C0,17,8 Room 6: trolls path. lit, "in". Exits: S to 5, N to 7 through object 1
B $B9D1,14,14 Room 7: trolls cave. lit, "in". Exits: S to 6 through object 1
B $B9DF,17,8 Room 9: rivendell. lit, "in". Exits: E to 10, W to 5
B $B9F0,23,8 Room 10: misty mountain. lit, "on". Exits: E to 11, N to 68, W to 9, S to 73
B $BA07,20,8 Room 11: narrow place. lit, "in". Exits: E to 12, W to 10, N to 14
B $BA1B,17,8 Room 12: dangerous narrow path. lit, "on". Exits: E to 22, W to 11
B $BA2C,17,8 Room 14: large dry cave. lit, "in". Exits: D to 15 through object 6, S to 11
B $BA3D,20,8 Room 15: dark stuffy passage. dark, "in". Exits: U to 14 through object 6, S to 52, NE to 58
B $BA51,20,8 Room 52: dark stuffy passage. dark, "in". Exits: N to 15, D to 53, U to 54
B $BA65,14,14 Room 53: dark stuffy passage. dark, "in". Exits: U to 52
B $BA73,23,8 Room 54: dark stuffy passage. dark, "in". Exits: D to 52, SE to 55, S to 64, SW to 17
B $BA8A,23,8 Room 55: dark stuffy passage. dark, "in". Exits: S to 17, NE to 54, SW to 61, W to 60
B $BAA1,14,14 Room 56: dark stuffy passage. dark, "in". Exits: SW to 60
B $BAAF,20,8 Room 57: dark stuffy passage. dark, "in". Exits: U to 16, W to 65, N to 58
B $BAC3,23,8 Room 58: dark stuffy passage. dark, "in". Exits: SE to 62, E to 15, S to 57, U to 59
B $BADA,17,8 Room 59: dark stuffy passage. dark, "in". Exits: D to 58, S to 60
B $BAEB,20,8 Room 60: dark stuffy passage. dark, "in". Exits: SE to 61, N to 59, NW to 56
B $BAFF,17,8 Room 61: dark stuffy passage. dark, "in". Exits: N to 54, NW to 60
B $BB10,14,14 Room 62: dark stuffy passage. dark, "in". Exits: E to 61
B $BB1E,20,8 Room 63: dark stuffy passage. dark, "in". Exits: U to 64, N to 18, E to 58
B $BB32,20,8 Room 64: dark stuffy passage. dark, "in". Exits: NW to 65, W to 54, SW to 63
B $BB46,20,8 Room 65: dark stuffy passage. dark, "in". Exits: N to 64, SE to 57, E to 19
B $BB5A,20,8 Room 16: big goblins cavern. dark, "in". Exits: D to 57, NE to 18, SE to 13 through object 17
B $BB6E,14,14 Room 17: deep dark lake. dark, "at". Exits: N to 55
B $BB7C,20,8 Room 18: dark winding passage. dark, "in". Exits: SW to 16, SE to 63, N to 13 through object 27
B $BB90,41,8 Room 19: inside goblins gate. dark, "inside". Exits: W to 16, N to 16, S to 16, U to 20 through object 10, E to 16, SE to 16, SW to 16, D to 16, NE to 65, NW to 16
B $BBB9,17,8 Room 20: outside goblins gate. lit, "outside". Exits: D to 19 through object 10, E to 21
B $BBCA,17,8 Room 13: goblins dungeon. dark, "in". Exits: N to 16 through object 17, W to 18 through object 27
B $BBDB,17,8 Room 21: treeless opening. lit, "in". Exits: E to 22, W to 20
B $BBEC,26,8 Room 22: beorns house. lit, "in". Exits: NE to 24, NW to 20, S to 46, SW to 12, N to 49
B $BC06,20,8 Room 24: forest gate. lit, "at". Exits: W to 22, S to 46, E to 25
B $BC1A,20,8 Room 25: bewitched gloomy place. lit, "in". Exits: W to 24, E to 66
B $BC2E,23,8 Room 26: spider threads place. lit, "in". Exits: E to 29 through object 7, W to 50 through object 7, N to 28 through object 7, S to 27 through object 7
B $BC45,17,8 Room 27: smothering forest. lit, "in". Exits: N to 26 through object 7, W to 50 through object 7
B $BC56,20,8 Room 28: levelled elvish clearing. lit, "in". Exits: W to 25, E to 26 through object 7, NE to 30 through object 13
B $BC6A,14,14 Room 29: deep bog. lit, "in". Exits: W to 26 through object 7
B $BC78,20,8 Room 30: elvenkings great halls. lit, "in". Exits: E to 31 through object 8, S to 32, W to 28 through object 13
B $BC8C,17,8 Room 31: dark dungeon. dark, "in". Exits: SW to 32 through object 8, W to 30 through object 8
B $BC9D,20,8 Room 32: elvenkings cellar. lit, "in". Exits: NE to 31 through object 8, N to 30, D to 33 through object 12
B $BCB1,20,8 Room 33: forestriver. lit, "at". Exits: E to 34 through object 39
B $BCC5,23,8 Room 34: long lake. lit, "at". Exits: N to 36, E to 35, NW to 33 through object 39, S to 45
B $BCDC,23,8 Room 35: lake town. lit, "in". Exits: N to 34, S to 34, E to 34, W to 34
B $BCF3,17,8 Room 36: running river. lit, "on". Exits: U to 37, S to 34
B $BD04,17,8 Room 37: dragons desolation. lit, "in". Exits: N to 38, D to 36
B $BD15,20,8 Room 38: dale valley. lit, "in". Exits: N to 39, S to 37, NW to 40
B $BD29,20,8 Room 39: front gate. lit, "at". Exits: N to 41, S to 38, W to 40
B $BD3D,20,8 Room 40: ravenhill. lit, "on". Exits: N to 42, SE to 37, E to 39
B $BD51,20,8 Room 41: lower halls. lit, "in". Exits: S to 39, E to 43, U to 44
B $BD65,20,8 Room 42: sidedoor. lit, "in". Exits: S to 40, E to 43 through object 11, N to 51
B $BD79,17,8 Room 43: smooth straight passage. dark, "in". Exits: W to 42 through object 11, E to 41
B $BD8A,23,8 Room 44: lonely mountain. lit, "on". Exits: D to 41, W to 42, S to 39, SW to 40
B $BDA1,17,8 Room 46: forest road. lit, "on". Exits: E to 2, N to 24
B $BDB2,17,8 Room 45: waterfall. lit, "at". Exits: S to 8, W to 3
B $BDC3,17,8 Room 2: forest road. lit, "on". Exits: E to 3, W to 46
B $BDD4,17,8 Room 3: forest. lit, "in". Exits: W to 2, E to 45
B $BDE5,17,8 Room 8: running river. lit, "at". Exits: N to 45, W to 3
B $BDF6,17,8 Room 23: forestriver. lit, "at". Exits: SE to 33 through object 42, N to 48
B $BE07,20,8 Room 48: mountains. lit, "on". Exits: SW to 49, E to 47, SE to 23
B $BE1B,23,8 Room 49: great river. lit, "at". Exits: NE to 48, S to 22, E to 24, SW to 10
B $BE32,11,11 Room 47: empty place. lit, "in". Exits: none
B $BE3D,17,8 Room 50: green forest. lit, "in". Exits: NE to 26 through object 7, W to 67
B $BE4E,20,8 Room 51: empty place. lit, "in". Exits: N to 47, S to 42, U to 44
B $BE62,17,8 Room 66: west bank. lit, "on". Exits: W to 25, E to 67 through object 9
B $BE73,17,8 Room 67: east bank. lit, "on". Exits: E to 50, W to 66 through object 9
B $BE84,20,8 Room 68: narrow path. lit, "on". Exits: E to 71, NE to 69, S to 10
B $BE98,20,8 Room 69: narrow path. lit, "on". Exits: N to 70, SW to 68, S to 10
B $BEAC,17,8 Room 70: narrow path. lit, "on". Exits: SE to 72, S to 69
B $BEBD,20,8 Room 71: narrow path. lit, "on". Exits: NW to 69, S to 74, W to 68
B $BED1,20,8 Room 72: narrow path. lit, "on". Exits: NW to 70, SW to 71, D to 75
B $BEE5,17,8 Room 73: narrow path. lit, "on". Exits: E to 74, N to 10
B $BEF6,17,8 Room 74: narrow path. lit, "on". Exits: N to 71, W to 73
B $BF07,14,14 Room 75: steep path. lit, "on". Exits: D to 76
B $BF15,14,14 Room 76: steep path. lit, "on". Exits: D to 77
B $BF23,14,14 Room 77: steep path. lit, "on". Exits: D to 78
B $BF31,17,8 Room 78: deep misty valley. lit, "in". Exits: E to 79, U to 77
B $BF42,17,8 Room 79: deep misty valley. lit, "in". Exits: W to 78, U to 74
b $BF53 Object index
D $BF53 3-byte entries: object number, then the address of that object's record in #R$C00B. Terminated by $FF. Searched by #R$9B25. Some numbers: 0 YOU (Bilbo), 5 the round green door, 12 the large trap door, 14 the short strong sword, 16 the golden ring, 18 the rope, 33 the cupboard, 62 Gandalf, 63 Thorin, 71 and 72 the trolls.
B $BF53,184,8
b $C00B Object records
D $C00B Every object, character and door in the game has a record here. They are backed up at start-up and restored when the game restarts. As an example, the short strong sword (object 14) at #R$C1F4 in the original game:
D $C00B $01,$FF,$03,$04,$00,$40,$80,$94, $84,$06,$9D,$05,$68,$06,$00,$00, $07, $0B,$57,$92,$FF
D $C00B Byte 0: the number of locations the object occupies. Ordinary objects and characters have 1; doors have 2 (one on each side).
D $C00B Byte 1: who is holding it, or what it is inside: an object number, or $FF for nobody. The curious map starts with 62 (Gandalf) here, the large key with 71 (a troll), the food with 33 (the cupboard). In my modified tape the sword has 0 here: Bilbo.
D $C00B Byte 2: size. Byte 3: weight, which for a character is also how much it can carry. Byte 4: attributes, used in three ways. Bits 0-3 say how the object's contents are described (#R$9F89): 0 in, 1 on, 2 behind, 3 under, 4 tied to; only contents 'in' or 'on' something fall out when it is broken (#R$9257). Bits 4-6 are the character's side (1 Bilbo and his friends, 2 goblins and Gollum, 4 elves; Elrond has both 1 and 4): characters on the same side cannot attack or capture each other (#R$90B4, #R$A316). Bit 7, on a door or window, means Bilbo cannot pass through it unaided (#R$8D19).
D $C00B Byte 5: STRENGTH, byte 6: DEFENCE (see #R$90DB). The sword's strength is $40 (64).
D $C00B Byte 7: flags. Bit 0 locked; bit 1 'pours' (a liquid, which evaporates when dropped); bit 2 full; bit 3 broken (for a character: dead); bit 4 on (lit); bit 5 open; bit 6 alive (a character); bit 7 visible. The words for these states come from the tables at #R$A13B: LOCKED/UNLOCKED, FULL/EMPTY, BROKEN, ON/OFF, OPEN/CLOSED, ALIVE/DEAD.
D $C00B Bytes 8-15: four word slots (little-endian references, offsets from #R$6000): the noun followed by adjectives. For the sword: $0684 SWORD, $059D SHORT, $0668 STRONG, 0.
D $C00B Then one location byte per location (byte 0 says how many): here room 7, the trolls' cave. Changing this byte (at #R$C204) moves the sword; I changed it to 1 so that the sword starts with Bilbo.
D $C00B Then a list of the object's own action handlers, three bytes each: an action number (see #R$AA47) and the address of a routine to run when that action is done to the object. An entry with action 0 straight after a matching entry is run as well, so several routines can be chained. The list ends with $FF. The sword's list has one entry: action 11 (STRIKE) runs #R$9257. The wine's has action 33 (DRINK) followed by action 0 running #R$A9ED, which is what makes Bilbo drunk. Actions that an object has no handler for fall back on the default handlers at #R$C61F (see #R$946F).
D $C00B Offset 16 (the first location byte) is what the movement routine updates (#R$8D19). For Bilbo, this is #R$C01B.
B $C00B,24,8 Object 0: you (strength 64, defence 64)
B $C023,18,8 Object 60: red golden dragon (strength 192, defence 192)
B $C035,43,8 Object 5: round green door (strength 0, defence 16)
B $C060,43,8 Object 1: heavy rock door (strength 0, defence 144)
B $C08B,18,8 Object 43: golden key (strength 0, defence 0)
B $C09D,18,8 Object 2: small curious key (strength 0, defence 0)
B $C0AF,18,8 Object 4: large key (strength 0, defence 0)
B $C0C1,21,8 Object 3: curious map (strength 0, defence 2)
B $C0D6,31,8 Object 6: small insignificant crack (strength 255, defence 0)
B $C0F5,31,8 Object 7: spider web (strength 64, defence 64)
B $C114,41,8 Object 8: red door (strength 0, defence 0)
B $C13D,32,8 Object 9: fast black river (strength 0, defence 0)
B $C15D,31,8 Object 42: fast river (strength 0, defence 0)
B $C17C,40,8 Object 10: goblins back door (strength 80, defence 80)
B $C1A4,40,8 Object 11: mountains side door (strength 0, defence 0)
B $C1CC,40,8 Object 12: large trap door (strength 0, defence 48)
B $C1F4,21,8 Object 14: short strong sword (strength 64, defence 128)
B $C209,24,8 Object 16: valuable golden ring (strength 255, defence 0)
B $C221,18,8 Object 15: red key (strength 2, defence 2)
B $C233,34,8 Object 17: goblins door (strength 255, defence 255)
B $C255,27,8 Object 18: rope (strength 32, defence 5)
B $C270,31,8 Object 13: magic door (strength 255, defence 255)
B $C28F,18,8 Object 62: gandalf (strength 112, defence 136)
B $C2A1,24,8 Object 63: thorin (strength 104, defence 120)
B $C2B9,18,8 Object 64: wood elf (strength 64, defence 48)
B $C2CB,18,8 Object 65: elrond (strength 64, defence 64)
B $C2DD,42,8 Object 19: barrel (strength 32, defence 32)
B $C307,24,8 Object 20: wine (strength 0, defence 0)
B $C31F,18,8 Object 66: butler (strength 32, defence 112)
B $C331,18,8 Object 67: vicious warg (strength 55, defence 55)
B $C343,21,8 Object 21: water (strength 0, defence 0)
B $C358,21,8 Object 22: black water (strength 0, defence 0)
B $C36D,28,8 Object 23: water (strength 0, defence 0)
B $C389,23,8 Object 24: black water (strength 0, defence 0)
B $C3A0,18,8 Object 68: gollum (strength 32, defence 64)
B $C3B2,18,8 Object 70: bard (strength 96, defence 96)
B $C3C4,21,8 Object 25: bow (strength 16, defence 16)
B $C3D9,21,8 Object 26: strong arrow (strength 16, defence 16)
B $C3EE,34,8 Object 27: window (strength 112, defence 112)
B $C410,19,8 Object 28: torch (strength 128, defence 128)
B $C423,24,8 Object 29: sand (strength 0, defence 0)
B $C43B,27,8 Object 30: trap door (strength 128, defence 128)
B $C456,24,8 Object 31: goblins cache (strength 0, defence 0)
B $C46E,24,8 Object 32: heavy curtain (strength 0, defence 0)
B $C486,33,8 Object 33: large cupboard (strength 0, defence 0)
B $C4A7,21,8 Object 34: food (strength 1, defence 0)
B $C4BC,18,8 Object 35: valuable treasure (strength 5, defence 5)
B $C4CE,21,8 Object 36: wall (strength 0, defence 0)
B $C4E3,39,8 Object 37: wooden chest (strength 0, defence 0)
B $C50A,36,8 Object 41: wooden boat (strength 0, defence 0)
B $C52E,18,8 Object 71: hideous troll (strength 160, defence 160)
B $C540,18,8 Object 72: vicious troll (strength 160, defence 160)
B $C552,21,8 Object 38: lunch (strength 1, defence 0)
B $C567,22,8 Object 39: strong portcullis (strength 0, defence 0)
B $C57D,18,8 Object 40: stone (strength 255, defence 255)
B $C58F,24,8 Object 61: nasty goblin (strength 72, defence 96)
B $C5A7,24,8 Object 69: hideous goblin (strength 72, defence 96)
B $C5BF,24,8 Object 73: horrible goblin (strength 72, defence 96)
B $C5D7,24,8 Object 74: mean goblin (strength 72, defence 96)
B $C5EF,24,8 Object 75: vicious goblin (strength 72, defence 96)
B $C607,24,8 Object 76: disgusting goblin (strength 72, defence 96)
b $C61F Default action handlers
D $C61F 3-byte entries: an action number (see #R$AA47) and the routine that carries it out when the object involved has no handler of its own (#R$946F). Terminated by $FF at #R$C67C.
D $C61F #TABLE(default) { =h Action | =h Handler } { 1-10 (movement) | #R$8D19 } { 13 DROP | #R$8C45 } { 15 ATTACK | #R$90DB } { 19 TAKE, 59 CARRY | #R$8CC8 } { 23 LOOK | #R$8C2D } { 26 INVENTORY | #R$9055 } { 28 EXAMINE | #R$9344 } { 29 GIVE TO | #R$9308 } { 31 ENTER, 32 GO INTO | #R$8F37 } { 36 RUN | #R$8F17 } { 39 FOLLOW | #R$8F40 } { 42 THROW AT | #R$8F5F } { 45 BURN | #R$A232 } { 46 TIE TO | #R$A178 } { 48 CAPTURE | #R$A316 } { 51 UNTIE | #R$A1E4 } { 53 TALK TO | #R$8F9E } { 55 CLIMB OUT OF | #R$A468 } { 58 SHOOT | #R$8FE0 } { 0 | #R$9A5D } TABLE#
D $C61F Actions with no entry here and no object handler (OPEN, CLOSE, EAT and so on) can only be done to objects that provide a handler; otherwise the game says "I cannot do that".
B $C61F,93,8
B $C67C,1,1 End marker
b $C67D Room-entry handlers
D $C67D 3-byte entries: a room number and the address of a routine to call when the player enters that room (see #R$8D19). Terminated by $FF.
D $C67D #LIST { Room 22 ($16, Beorn's house): #R$C693 - switches the butler on } { Room 26 ($1A, the place of black spiders): #R$C6A1 - starts timer #R$C981 } { Room 29 ($1D, the deep bog): #R$C6A8 - starts timer #R$C98F } { Room 33 ($21, the forest river): #R$C6D9 - death unless Bilbo is in the barrel } { Room 2 ($02): #R$C6CC - the pale bulbous eyes } { Room 3 ($03): #R$C6CC - the pale bulbous eyes } { Room 32 ($20, the Elvenking's cellar): #R$C6AF - switches the dragon and Bard on, and starts the side door timer } LIST#
B $C67D,21,8 Room, handler address
B $C692,1,1 End marker
c $C693 Room-entry handler: Beorn's house (room 22) wakes the butler
D $C693 Not every character is active from the start. The butler (object 66) begins the game in the Elvenking's cellar (room 32), invisible (bit 7 of his flags clear), and his slot in the character table at $C9D6 holds 0, so #R$976C passes him by and he does nothing at all.
D $C693 The first time Bilbo walks into Beorn's house - roughly half way through the journey - this handler switches him on: his object number $42 is written into that slot, which already holds the address of his behaviour program (#R$C83F) and reaction table (#R$C835), and he is made visible. From then on he goes about his business in the cellar every turn (unlocking and locking the red door, drinking wine, throwing barrels through the trap door, capturing intruders; see #R$C71C), so that by the time Bilbo arrives in the Elvenking's halls the butler is already at work.
D $C693 If the butler has been killed (bit 3 of his flags), nothing happens. Because the slot is simply overwritten, entering Beorn's house again later does no harm: it writes the same value again.
C $C693 HL = the butler's flags
C $C696 Is the butler dead?
C $C698 Yes: leave him be
C $C699 Put the butler (object 66) into his empty slot in the character table...
C $C69B ...so that from now on he acts every turn
C $C69E ...and make him visible
c $C6A1 Room-entry handler: the place of black spiders (room 26) starts timer 2
D $C6A1 Starts timer 2 (count 5). Bilbo can stay for the turn he arrives and three more; if he is still in room 26 at the end of the next one, the spiders' web smothers him (#R$AA04). The HELP message there is 'don't stay too long.'
C $C6A1 Timer 2's reload value (5)...
C $C6A4 ...becomes its count: the timer starts
c $C6A8 Room-entry handler: the deep bog (room 29) starts timer 4
D $C6A8 Starts timer 4 (count 2). Its threshold is also 2, so at the end of the very turn Bilbo steps into the bog, the count drops to 1 and the tick routine (#R$A69E) runs: he is 'slowly sinking into the bog', and dies. The deep bog is simply a death trap - the way to deal with it is not to go in.
C $C6A8 Timer 4's reload value (2)...
C $C6AB ...becomes its count: the timer starts
c $C6AF Room-entry handler: the Elvenking's cellar (room 32) wakes the dragon and Bard
D $C6AF Entering the cellar where the king keeps his barrels of wine brings the last part of the adventure to life. Three things happen:
D $C6AF #LIST { Timer 9 (#R$C9B2) is started with a count of 3. This is the timer that controls the side door of the Lonely Mountain (object 11), far away in room 42: it makes 'a loud crack and a hole appears about three feet from the ground' for one turn in every five (#R$A985), after which 'the hole vanishes' (#R$A968), unless it has been opened. The count of 3 means the first appearance happens two turns after Bilbo enters the cellar. } { The dragon (object 60) is switched on by writing its number, $3C, into its empty slot in the character table at #R$C9F2 - unless it is already dead. Until now the dragon has been lying inert in the lower halls; from now on its behaviour program (#R$A5D5, #R$A591, #R$A5BB) runs every turn. } { Bard (object 70) is switched on in the same way, by writing $46 into the slot at $C9EB, unless he is dead. He starts waiting for orders (#R$A79F). } LIST#
D $C6AF So the dragon cannot threaten Bilbo, and Bard cannot help him, until Bilbo has reached the Elvenking's cellar. Like the butler's handler (#R$C693), this runs every time Bilbo enters the cellar, restarting the side door timer at 3 each time.
C $C6AF Start timer 9 (the Lonely Mountain's side door)...
C $C6B1 ...with a count of 3
C $C6B4 HL = the dragon's flags
C $C6B7 Is the dragon dead?
C $C6B9 Yes: skip
C $C6BB Put the dragon (object 60) into its empty character-table slot...
C $C6BD ...so it starts acting
C $C6C0 HL = Bard's flags
C $C6C3 Is Bard dead?
C $C6C5 Yes: done
C $C6C6 Put Bard (object 70) into his empty slot...
C $C6C8 ...so he starts waiting for orders
c $C6CC Room-entry handler: the forest (rooms 2 and 3)
D $C6CC Called when Bilbo enters the forest road (room 2) or the forest (room 3). It records the room he has just entered (from #R$8D17, set by #R$8D19) in #R$B5E4, and starts the 'pale bulbous eyes' timer at #R$C9AB by copying its reload value (4) into its count.
D $C6CC The rest of the mechanism is in #R$AA13 and #R$AA2E.
C $C6CC Remember which room the timer started in
C $C6CF Store A in the room where the eyes timer started
C $C6D2 Start the eyes timer (count = 4)
C $C6D5 Store A in timer 8's count
C $C6D8 Done
c $C6D9 Room-entry handler: the forest river (room 33) - only in a barrel
D $C6D9 The forest river outside the Elvenking's halls, reached by going down through the trap door in the cellar, is only survivable in a barrel. If Bilbo enters it any other way - for example by jumping through the trap door on his own - the room is described and then 'you are swept forcefully against the portcullis.', and he dies.
D $C6D9 If he is inside the barrel (object 19 is his holder), nothing happens here: he floats on, and two turns after the trap door was opened the barrel timer (#R$A4F4) carries him out onto the bank of the long lake. This is the book's escape in the barrels, turned into a rule you cannot get round.
C $C6D9 A = whatever is holding Bilbo
C $C6DC Is he inside the barrel (object 19)?
C $C6DE Yes: he is safe
C $C6DF No: first describe the river (so he sees where he is)...
C $C6E2 "you are swept forcefully against the portcullis."
C $C6E8 ...and Bilbo is dead
b $C6EB Gollum's riddles
D $C6EB Four 4-byte entries, one of which is chosen at random by #R$970B: the word that answers the riddle, and the address of the riddle. There are only two riddles, each stored twice, so they are equally likely. The code for the hidden routes (#R$970B) counts its entries from #R$C6F7, so the last riddle entry also serves as that table's never-used entry 0.
B $C6EB,4,4 NIGHT: "it cannot be seen, cannot be felt..."
B $C6EF,4,4 MAN: the riddle of the Sphinx
B $C6F3,4,4 NIGHT
B $C6F7,4,4 MAN
B $C6FB,2,2 Unused
b $C6FD Hidden routes
D $C6FD Six bytes per entry, one chosen at random by #R$970B: the room, the address of an exit in that room's record, and the three bytes of the exit (direction, door, destination), which are blanked out at the start of the game and restored when Elrond reads the map (#R$A6B8). Terminated by $FF. The code counts entries from #R$C6F7, six bytes earlier, so the first entry here is number 1.
B $C6FD,6,6 Beorn's house: north to the great river
B $C703,6,6 Forest gate: east to the bewitched gloomy place
B $C709,6,6 Treeless opening: west to the goblins' outside gate
B $C70F,6,6 Long lake: east to lake town
B $C715,6,6 Misty mountain: east to the narrow place
B $C71B,1,1 End marker
b $C71C Character behaviour programs and reaction tables
D $C71C The programs that make the characters act on their own, run by #R$976C. Every character has a pointer (in its entry in #R$C9BA) to where it has got to in its program, and a reaction table. Each comment below decodes one instruction.
D $C71C HOW THE PROGRAMS RUN. On each of its turns a character works through its program until one instruction succeeds; that ends its turn, and next turn it carries on from the following instruction. An instruction that fails either falls through to the next one, or, if it has an 'if it fails go to' address, jumps there, in the same turn. A character gives up after six failures in one turn. 'Go to' instructions do not use up a turn. Actions without a target or instrument let the game choose suitable objects, exactly as it does for the player's commands, so 'attack' means 'attack whoever is here' and 'take' means 'pick up something'.
D $C71C Instruction formats (the low nibble of the first byte is the type; bit 4 means a failure address follows, bit 5 'once only', bit 6 'no orders from the player here'):
D $C71C #TABLE(default) { =h Bytes | =h Instruction } { t, action, target, instrument | do an action with those objects ($FF = let the game choose) } { t+1, address, 0 | call a special routine (the routines in #R$A406-#R$A91B) } { 4, action | do an action and let the game choose any objects; action $FF means 'do nothing this turn' } { $0E, address | go to } { $0C, action | switch to the reaction for that action } { $0F, n | switch to a randomly chosen entry of the reaction table } { other | switch to the default entry of the reaction table and end the turn } TABLE#
D $C71C REACTION TABLES are lists of 3-byte entries ending with $FF: an action and a program address. When something is done to a character, the entry for that action (if any) becomes its program (#R$99FB); entries with action 0 are the default behaviours, used by 'switch to a random behaviour'. In memory each character's reaction table comes straight before its program (the goblins' three tables come first, together); the headings below mark where each table and each program begins. Common reactions are shared: #R$C94D is the general 'fight back' program (attack; attack again; run; repeat, or follow the attacker if it runs), #R$C96E the response to being given something ('thank you' or 'what do you expect me to do with this?'), and #R$C962 the response to being captured (go through an exit or door if possible, otherwise run).
D $C71C WHAT THE CHARACTERS DO:
D $C71C #LIST { Gandalf (#R$C7A9) begins by giving Bilbo the curious map and opening the round green door. After that he is a random wanderer: five little routines (#R$C7B1, #R$C7BF, #R$C7C3, #R$C7C9, #R$C7CD) chosen at random make him run about, pick things up and ask 'what's this?', drop or give things away, open and close doors, and make small talk. } { Thorin (#R$C7DB) follows Bilbo whenever he can. When he cannot, he picks up the small curious key if he finds it (saying once 'this was thrains key'), asks 'where's the thief?' if Bilbo is invisible, or runs through his idle routine (#R$A550): wait, 'hurry up', or sit down and sing about gold. } { The wood elf (#R$C80C) wanders at random capturing anyone it meets, who ends up in the Elvenking's dungeon (#R$A316). } { The warg (#R$C817) attacks anyone it can; otherwise it follows its prey, or runs around Bilbo howling (#R$A4CA), or runs off. } { The butler (#R$C83F) acts out the story from the book: he unlocks the red door with the red key, opens it, shuts it and locks it again; he opens a barrel and drinks the wine, closes the barrel, opens the trap door, throws the barrel through it into the river, and closes the trap door - capturing any intruder at every opportunity - and then starts again. } { Elrond (#R$C889) greets Bilbo when he arrives and gives him lunch (#R$A8D9), and otherwise waits. } { The dragon (#R$C8A7) sleeps on the treasure until it is taken (#R$A5D5); then, as long as the dragon itself is somewhere lit, each turn there is about a 1 in 6 chance that it descends and burns Bilbo to a crisp, otherwise 'in the distance you see the shape of a monstrous dragon flying after you.' Before that, if Bilbo comes into one of its three rooms it flies to him (#R$A591), speaks (#R$A5BB) and burns him. } { Bard (#R$C8CD) does nothing on his own: he waits for an order from the player (#R$A79F), and then repeats that order every turn. His reaction to being attacked is to SHOOT (#R$C8D8). } { Gollum (#R$C8E6) asks his riddle when he meets Bilbo (#R$A7C6), and kills him if the answer is wrong (#R$A7EA); he mutters about his precious (#R$A81A), paces north and south-west, drops and picks up the golden ring, and if attacked puts the ring on, becomes invisible and runs. } { The trolls (#R$C92A) wait until Bilbo comes into the clearing and then say their lines (#R$A8B1). After that their program is: try to eat Bilbo, wait, eat, wait, eat, wait, eat, and then dawn (#R$A865), which turns them to stone. So after the trolls have spoken, Bilbo must be out of the clearing on the turns they try to eat him; waiting outside for the new day dawning (as the HELP message says) is the way. } { The goblins patrol set routes (for example #R$C731: open the small insignificant crack, go up, down, close the crack, south, north), capturing anyone they meet on the way, who ends up in the goblins' dungeon; the last three goblins (#R$C784) just run about attacking and capturing. } LIST#
D $C71C One instruction in this area is changed during play: #R$A79F rewrites the instruction at #R$C8D1 to hold Bard's latest order, which is why SAVE and LOAD take care to save three of its bytes (#R$8284).
B $C71C,3,3 the nasty and hideous goblins: default behaviour (also one of the choices for a random one): program at #R$C731
B $C71F,3,3 the nasty and hideous goblins: when it is attacked: switch to the program at #R$C78D
B $C722,1,1 End of the table
B $C723,3,3 the vicious goblin: default behaviour (also one of the choices for a random one): program at #R$C760
B $C726,3,3 the vicious goblin: when it is attacked: switch to the program at #R$C78D
B $C729,1,1 End of the table
B $C72A,3,3 the horrible, mean and disgusting goblins: default behaviour (also one of the choices for a random one): program at #R$C784
B $C72D,3,3 the horrible, mean and disgusting goblins: when it is attacked: switch to the program at #R$C78D
B $C730,1,1 End of the table
B $C731,4,4 action 16 [open] (#R$A298) target small insignificant crack, with -
B $C735,4,4 action 48 [capture] (#R$A316); if it fails go to #R$C73C
B $C739,3,3 go to #R$C735
B $C73C,2,2 action 9 [up go] (#R$8D19)
B $C73E,4,4 action 48 [capture] (#R$A316); if it fails go to #R$C745
B $C742,3,3 go to #R$C73E
B $C745,2,2 action 10 [down go] (#R$8D19)
B $C747,4,4 action 48 [capture] (#R$A316); if it fails go to #R$C74E
B $C74B,3,3 go to #R$C747
B $C74E,4,4 action 12 [close] (#R$90A2) target small insignificant crack, with -
B $C752,2,2 action 2 [south go] (#R$8D19)
B $C754,4,4 action 48 [capture] (#R$A316); if it fails go to #R$C75B
B $C758,3,3 go to #R$C754
B $C75B,2,2 action 1 [north go] (#R$8D19)
B $C75D,3,3 go to #R$C731
B $C760,2,2 action 6 [northwest go] (#R$8D19)
B $C762,4,4 action 48 [capture] (#R$A316); if it fails go to #R$C769
B $C766,3,3 go to #R$C762
B $C769,2,2 action 1 [north go] (#R$8D19)
B $C76B,4,4 action 48 [capture] (#R$A316); if it fails go to #R$C772
B $C76F,3,3 go to #R$C76B
B $C772,2,2 action 8 [southwest go] (#R$8D19)
B $C774,4,4 action 48 [capture] (#R$A316); if it fails go to #R$C77B
B $C778,3,3 go to #R$C774
B $C77B,2,2 action 9 [up go] (#R$8D19)
B $C77D,4,4 action 48 [capture] (#R$A316); if it fails go to #R$C760
B $C781,3,3 go to #R$C77D
B $C784,2,2 action 36 [run] (#R$8F17)
B $C786,2,2 action 15 [attack with] (#R$90DB)
B $C788,2,2 action 48 [capture] (#R$A316)
B $C78A,3,3 go to #R$C784
B $C78D,2,2 action 48 [capture] (#R$A316)
B $C78F,1,1 switch to default behaviour and end turn
B $C790,3,3 default behaviour (also one of the choices for a random one): program at #R$C7B1
B $C793,3,3 default behaviour (also one of the choices for a random one): program at #R$C7BF
B $C796,3,3 default behaviour (also one of the choices for a random one): program at #R$C7C3
B $C799,3,3 default behaviour (also one of the choices for a random one): program at #R$C7C9
B $C79C,3,3 default behaviour (also one of the choices for a random one): program at #R$C7CD
B $C79F,3,3 when it is given something: switch to the program at #R$C96E
B $C7A2,3,3 when it is captured: switch to the program at #R$C962
B $C7A5,3,3 when it is attacked: switch to the program at #R$C94D
B $C7A8,1,1 End of the table
B $C7A9,4,4 action 29 [give to] (#R$9308) target curious map, with bilbo
B $C7AD,4,4 action 16 [open] (#R$9078) target round green door, with -
B $C7B1,2,2 action 36 [run] (#R$8F17)
B $C7B3,4,4 action 19 [take] (#R$8CC8); if it fails go to #R$C7BF
B $C7B7,4,4 call #R$A41C (Character routine: "what's this?")
B $C7BB,2,2 action 12 [close]
B $C7BD,2,2 action 29 [give to] (#R$9308)
B $C7BF,2,2 action 36 [run] (#R$8F17)
B $C7C1,2,2 action 13 [drop] (#R$8C45)
B $C7C3,2,2 action 36 [run] (#R$8F17)
B $C7C5,4,4 call #R$A425 (Character routine: small talk)
B $C7C9,2,2 action 36 [run] (#R$8F17)
B $C7CB,2,2 action 29 [give to] (#R$9308)
B $C7CD,2,2 action 16 [open]
B $C7CF,2,2 switch to a random behaviour (1 of up to 4)
B $C7D1,3,3 default behaviour (also one of the choices for a random one): program at #R$C7DB
B $C7D4,3,3 when it is given something: switch to the program at #R$C96E
B $C7D7,3,3 when it is attacked: switch to the program at #R$C94D
B $C7DA,1,1 End of the table
B $C7DB,6,6 action 39 [follow] (#R$8F40) target bilbo, with -; if it fails go to #R$C7E4
B $C7E1,3,3 go to #R$C7DB
B $C7E4,6,6 action 19 [take] (#R$8CC8) target small curious key, with -; if it fails go to #R$C7EE
B $C7EA,4,4 call #R$A443 (Character routine: "this was thrains key") (once)
B $C7EE,6,6 call #R$A539 (Character routine: "where's the thief?"); if it fails go to #R$C7FB
B $C7F4,2,2 do nothing this turn
B $C7F6,2,2 action 36 [run] (#R$8F17)
B $C7F8,3,3 go to #R$C7DB
B $C7FB,4,4 call #R$A550 (Character routine: Thorin)
B $C7FF,3,3 go to #R$C7DB
B $C802,3,3 default behaviour (also one of the choices for a random one): program at #R$C80C
B $C805,3,3 when it is attacked: switch to the program at #R$C80C
B $C808,3,3 when it is given something: switch to the program at #R$C96E
B $C80B,1,1 End of the table
B $C80C,2,2 action 48 [capture] (#R$A316)
B $C80E,2,2 action 36 [run] (#R$8F17)
B $C810,3,3 go to #R$C80C
B $C813,3,3 default behaviour (also one of the choices for a random one): program at #R$C817
B $C816,1,1 End of the table
B $C817,4,4 action 15 [attack with] (#R$90DB); if it fails go to #R$C81E
B $C81B,3,3 go to #R$C817
B $C81E,4,4 action 39 [follow] (#R$8F40); if it fails go to #R$C829
B $C822,4,4 call #R$A4CA (Character routine: the warg)
B $C826,3,3 go to #R$C817
B $C829,4,4 action 36 [run] (#R$8F17); if it fails go to #R$C830
B $C82D,3,3 go to #R$C817
B $C830,2,2 do nothing this turn
B $C832,3,3 go to #R$C817
B $C835,3,3 default behaviour (also one of the choices for a random one): program at #R$C83F
B $C838,3,3 when it is attacked: switch to the program at #R$C84F
B $C83B,3,3 when it is given something: switch to the program at #R$C96E
B $C83E,1,1 End of the table
B $C83F,4,4 action 38 [unlock with] (#R$A264) target red door, with red key
B $C843,4,4 action 16 [open] (#R$9078) target red door, with -
B $C847,4,4 action 12 [close] (#R$90A2) target red door, with -
B $C84B,4,4 action 37 [lock with] (#R$A264) target red door, with red key
B $C84F,4,4 action 48 [capture] (#R$A316); if it fails go to #R$C856
B $C853,3,3 go to #R$C84F
B $C856,4,4 action 16 [open] (#R$9078) target barrel, with -
B $C85A,4,4 action 33 [drink] (#R$9206) target wine, with -
B $C85E,2,2 action 48 [capture] (#R$A316)
B $C860,4,4 action 12 [close] (#R$90A2) target barrel, with -
B $C864,4,4 action 16 [open] (#R$A577) target large trap door, with -
B $C868,2,2 action 48 [capture] (#R$A316)
B $C86A,4,4 action 19 [take] (#R$8CC8) target barrel, with -
B $C86E,4,4 action 44 [throw through] (#R$9404) target barrel, with large trap door
B $C872,2,2 action 48 [capture] (#R$A316)
B $C874,4,4 action 12 [close] (#R$A577) target large trap door, with -
B $C878,4,4 action 48 [capture] (#R$A316); if it fails go to #R$C83F
B $C87C,3,3 go to #R$C83F
B $C87F,3,3 default behaviour (also one of the choices for a random one): program at #R$C88F
B $C882,3,3 when it is attacked: switch to the program at #R$C899
B $C885,3,3 when it is given something: switch to the program at #R$C96E
B $C888,1,1 End of the table
B $C889,6,6 call #R$A44C (Character routine: greet Bilbo); if it fails go to #R$C893
B $C88F,4,4 call #R$A8D9 (Character routine: Elrond gives Bilbo lunch)
B $C893,2,2 do nothing this turn
B $C895,4,4 end turn and go to #R$C889
B $C899,4,4 action 15 [attack with] (#R$90DB); if it fails go to #R$C889
B $C89D,3,3 go to #R$C899
B $C8A0,3,3 default behaviour (also one of the choices for a random one): program at #R$C8A7
B $C8A3,3,3 when it is attacked: switch to the program at #R$C8BC
B $C8A6,1,1 End of the table
B $C8A7,6,6 call #R$A5D5 (Character routine: the dragon wakes); if it fails go to #R$C8B0
B $C8AD,3,3 go to #R$C8A7
B $C8B0,6,6 call #R$A591 (Character routine: the dragon comes for Bilbo); if it fails go to #R$C8C1
B $C8B6,6,6 call #R$A5BB (Character routine: the dragon speaks); if it fails go to #R$C8C1
B $C8BC,2,2 action 45 [burn] (#R$A232)
B $C8BE,3,3 go to #R$C8A7
B $C8C1,2,2 action 36 [run] (#R$8F17)
B $C8C3,3,3 go to #R$C8A7
B $C8C6,3,3 default behaviour (also one of the choices for a random one): program at #R$C8CD
B $C8C9,3,3 when it is attacked: switch to the program at #R$C8D8
B $C8CC,1,1 End of the table
B $C8CD,4,4 call #R$A79F (Character routine: Bard remembers his orders) (no orders)
B $C8D1,4,4 action 19 [take] (#R$8CC8) target wooden chest, with - (no orders)
B $C8D5,3,3 go to #R$C8CD
B $C8D8,4,4 action 58 [shoot] (#R$8FE0); if it fails go to #R$C94D (no orders)
B $C8DC,3,3 go to #R$C8D8
B $C8DF,3,3 default behaviour (also one of the choices for a random one): program at #R$C8E6
B $C8E2,3,3 when it is attacked: switch to the program at #R$C91A
B $C8E5,1,1 End of the table
B $C8E6,6,6 call #R$A7C6 (Character routine: Gollum asks his riddle); if it fails go to #R$C8FF
B $C8EC,4,4 call #R$A7EA (Character routine: Gollum waits for the answer) (no orders)
B $C8F0,4,4 action 13 [drop] (#R$8C45) target valuable golden ring, with -
B $C8F4,4,4 action 1 [north go] (#R$8D19); if it fails go to #R$C910
B $C8F8,4,4 action 19 [take] (#R$8CC8) target valuable golden ring, with -
B $C8FC,3,3 go to #R$C8E6
B $C8FF,4,4 action 1 [north go] (#R$8D19); if it fails go to #R$C915
B $C903,6,6 call #R$A81A (Character routine: Gollum mutters); if it fails go to #R$C8E6
B $C909,4,4 action 19 [take] (#R$8CC8) target valuable golden ring, with -
B $C90D,3,3 go to #R$C8E6
B $C910,2,2 action 8 [southwest go] (#R$8D19)
B $C912,3,3 go to #R$C8F8
B $C915,2,2 action 8 [southwest go] (#R$8D19)
B $C917,3,3 go to #R$C903
B $C91A,4,4 action 40 [wear] (#R$A2C0) target valuable golden ring, with -
B $C91E,2,2 action 36 [run] (#R$8F17)
B $C920,3,3 go to #R$C8E6
B $C923,3,3 default behaviour (also one of the choices for a random one): program at #R$C930
B $C926,3,3 when it is attacked: switch to the program at #R$C94D
B $C929,1,1 End of the table
B $C92A,6,6 call #R$A8B1 (Character routine: the trolls talk); if it fails go to #R$C92A
B $C930,4,4 call #R$A842 (Character routine: a character eats Bilbo)
B $C934,2,2 do nothing this turn
B $C936,4,4 call #R$A842 (Character routine: a character eats Bilbo)
B $C93A,2,2 do nothing this turn
B $C93C,4,4 call #R$A842 (Character routine: a character eats Bilbo)
B $C940,2,2 do nothing this turn
B $C942,4,4 call #R$A842 (Character routine: a character eats Bilbo)
B $C946,4,4 call #R$A865 (Character routine: dawn in the trolls' clearing)
B $C94A,3,3 go to #R$C930
B $C94D,4,4 action 15 [attack with] (#R$90DB); if it fails go to #R$C95A (no orders)
B $C951,4,4 action 15 [attack with] (#R$90DB); if it fails go to #R$C961 (no orders)
B $C955,2,2 action 36 [run] (#R$8F17) (no orders)
B $C957,3,3 go to #R$C94D
B $C95A,4,4 action 39 [follow] (#R$8F40); if it fails go to #R$C961 (no orders)
B $C95E,3,3 go to #R$C94D
B $C961,1,1 switch to default behaviour and end turn
B $C962,4,4 action 30 [go through]; if it fails go to #R$C969
B $C966,2,2 action 36 [run] (#R$8F17)
B $C968,1,1 switch to default behaviour and end turn
B $C969,2,2 do nothing this turn
B $C96B,3,3 go to #R$C962
B $C96E,4,4 call #R$A406 (Character routine: react to being given something)
B $C972,1,1 switch to default behaviour and end turn
N $C71C The goblins: three reaction tables (one for each kind of goblin), followed by their three behaviour programs.
N $C731 Behaviour program for the nasty and hideous goblins.
N $C760 Behaviour program for the vicious goblin.
N $C784 Behaviour program for the horrible, mean and disgusting goblins.
N $C78D The goblins' own reaction to being attacked: capture the attacker, then go back to the normal program.
N $C790 Gandalf: reaction table (how the character reacts when something is done to them), then behaviour program (what they do on their own turns).
N $C7A9 Behaviour program for Gandalf.
N $C7D1 Thorin: reaction table (how the character reacts when something is done to them), then behaviour program (what they do on their own turns).
N $C7DB Behaviour program for Thorin.
N $C802 The wood elf: reaction table (how the character reacts when something is done to them), then behaviour program (what they do on their own turns).
N $C80C Behaviour program for the wood elf.
N $C813 The warg: reaction table (how the character reacts when something is done to them), then behaviour program (what they do on their own turns).
N $C817 Behaviour program for the warg.
N $C835 The butler: reaction table (how the character reacts when something is done to them), then behaviour program (what they do on their own turns).
N $C83F Behaviour program for the butler.
N $C87F Elrond: reaction table (how the character reacts when something is done to them), then behaviour program (what they do on their own turns).
N $C889 Behaviour program for Elrond.
N $C8A0 The dragon: reaction table (how the character reacts when something is done to them), then behaviour program (what they do on their own turns).
N $C8A7 Behaviour program for the dragon.
N $C8C6 Bard: reaction table (how the character reacts when something is done to them), then behaviour program (what they do on their own turns).
N $C8CD Behaviour program for Bard.
N $C8DF Gollum: reaction table (how the character reacts when something is done to them), then behaviour program (what they do on their own turns).
N $C8E6 Behaviour program for Gollum.
N $C923 The trolls: reaction table (how the character reacts when something is done to them), then behaviour program (what they do on their own turns).
N $C92A Behaviour program for the trolls.
N $C94D Shared reaction program: fight back. Used by Gandalf, Thorin, the trolls, and by Bard when he cannot shoot.
N $C962 Shared reaction program: what to do when captured. Used by Gandalf.
N $C96E Shared reaction program: being given something. Used by Elrond, Gandalf, Thorin, the butler, the wood elf.
b $C973 Turn timers
D $C973 Ten 7-byte entries processed at the end of every turn by #R$9611, terminated by $FF. Each entry is: a reload value (copied into the count to start the timer), the count (0 = not running), the address of an 'expire' routine (run when the count reaches 0), a threshold, and the address of a 'tick' routine (run on each turn that the count is between 1 and the threshold; 0 = none). Only one timer may expire per turn.
D $C973 Every timer gives a delayed consequence to something the player did:
D $C973 #TABLE(default) { =h Timer | =h Started by | =h Runs for | =h What happens } { 0 | the barrel is thrown through the trap door into the forest river (#R$A4DB) | 2 turns | the barrel floats off to the long lake with whatever is in it (#R$A4F4) } { 1 | breaking the spider web (#R$A2A7) | 2 turns | 'some spiders start mending the broken web'; the web is whole again and twice as strong (#R$A950) } { 2 | entering the place of black spiders, room 26 (#R$C6A1) | the turn of arrival and 3 more | if Bilbo is still there, 'the spider web is slowly smothering you' and he dies (#R$AA04) } { 3 | opening the goblins' door from the goblins' big cavern (#R$A3E7) | 2 turns | the door closes by itself (#R$A400) } { 4 | entering the deep bog, room 29 (#R$C6A8) | 1 turn | 'you are slowly sinking into the bog', and Bilbo dies (#R$A69E) } { 5 | examining the magic door while invisible (#R$A614) | 4 turns | the door opens, 'an elf sweeps past', the ring comes off (#R$A9A7); next turn the door closes (#R$A9C9) } { 6 | putting the ring on (#R$A2C0) | 2-10 turns, random | the ring comes off by itself (#R$A9D4) } { 7 | drinking the wine (#R$A9ED) | 5 turns | Bilbo sobers up (#R$A9FF) } { 8 | entering the forest road or forest, rooms 2 and 3 (#R$C6CC) | 4 turns | the pale bulbous eyes (#R$AA13, #R$AA2E) } { 9 | entering the Elvenking's cellar (#R$C6AF), and closing the side door (#R$A996) | repeats every 5 turns | the side door of the Lonely Mountain appears for a turn and vanishes again (#R$A985, #R$A968) } TABLE#
B $C973,7,7 Timer 0: the barrel floats away
B $C97A,7,7 Timer 1: the spiders mend their web
B $C981,7,7 Timer 2: smothered in the spiders' place
B $C988,7,7 Timer 3: the goblins' door closes
B $C98F,7,7 Timer 4: sinking in the bog
B $C996,7,7 Timer 5: the magic door and the elf
B $C99D,7,7 Timer 6: the ring wears off
B $C9A4,7,7 Timer 7: drunkenness wears off
B $C9AB,7,7 Timer 8: the pale bulbous eyes
B $C9B2,7,7 Timer 9: the side door appears and vanishes
B $C9B9,1,1 End marker
b $C9BA Character table
D $C9BA The characters who act on their own (#R$976C), 7 bytes each, terminated by $FF: object number (0 once the character is dead), a count, the address of the character's current position in its behaviour program, the address of its reaction table (#R$C71C), and a stubbornness value (#R$8F9E).
D $C9BA #LIST { #R$C9BA: $3E Gandalf } { $C9C1: $3F Thorin } { $C9C8: $40 the wood elf } { $C9CF: $43 the warg } { $C9D6: empty until Bilbo enters Beorn's house, then $42 the butler (#R$C693) } { $C9DD: $41 Elrond } { $C9E4: $44 Gollum } { $C9EB: empty until Bilbo enters the Elvenking's cellar, then $46 Bard (#R$C6AF) } { #R$C9F2: empty until then, then $3C the dragon } { $C9F9, $CA00: $47 and $48 the trolls } { $CA07-#R$CA2A: $3D, $45, $4B, $49, $4A and $4C, the goblins } LIST# Byte 6 of each entry decides how often the character refuses an order given with SAY TO (#R$8F9E); despite what one might expect, higher values mean fewer refusals, and 0 means it never refuses. The values are: Gandalf 5, Thorin 6, Elrond 5, Bard and Gollum 3, the wood elf, the butler and the trolls 1, and the goblins, the warg and the dragon 0.
B $C9BA,119,8 Characters
B $CA31,1,1 End marker
u $CA32 Unused
D $CA32 Zeroes.
b $CC00 Location picture index
D $CC00 3-byte entries: room number and the address of the picture for that room (#R$8985), terminated by $FF. Only 22 of the 80 locations have pictures: rooms 1 (?), 49 (?), 6 (?), 11 (?), 37 (?), 43 (?), 38 (?), 7 (?), 24 (?), 35 (?), 13 (?), 31 (?), 5 (?), 28 (?), 4 (?), 32 (?), 16 (?), 25 (?), 8 (?), 41 (?), 26 (?), 39 (?).
D $CC00 Between them the 22 pictures use 3271 lines, 887 moves, 178 flood fills and 19 painted areas, in about 10,000 bytes.
B $CC00,67,8
b $CC43 Picture: room 1 (?)
D $CC43 The picture for room 1 (?). It is 564 bytes long: 162 lines, 68 moves, 6 fills and 1 painted areas. See #R$8985 for the format.
D $CC43 #HTML[<img src="../images/pictures/room01.png" alt="room 1">]
B $CC43,2,2 Border white, picture area black ink on white paper
B $CC45,3,3 Move to (158,70)
B $CC48,2,2 Line 5 pixels up, to (158,75)
B $CC4A,2,2 Line 5 pixels up, 1 right every 4, to (159,80)
B $CC4C,2,2 Line 5 pixels up, 1 right every 2, to (161,85)
B $CC4E,2,2 Line 5 pixels diagonally up-right, to (166,90)
B $CC50,2,2 Line 5 pixels right, 1 up every 2, to (171,92)
B $CC52,2,2 Line 5 pixels right, 1 up every 4, to (176,93)
B $CC54,2,2 Line 5 pixels right, to (181,93)
B $CC56,3,3 Move to (198,70)
B $CC59,2,2 Line 5 pixels up, to (198,75)
B $CC5B,2,2 Line 5 pixels up, 1 left every 4, to (197,80)
B $CC5D,2,2 Line 5 pixels up, 1 left every 2, to (195,85)
B $CC5F,2,2 Line 5 pixels diagonally up-left, to (190,90)
B $CC61,2,2 Line 5 pixels left, 1 up every 2, to (185,92)
B $CC63,2,2 Line 5 pixels left, 1 up every 5, to (180,93)
B $CC65,3,3 Move to (159,69)
B $CC68,2,2 Line 5 pixels down, 1 right every 4, to (160,64)
B $CC6A,2,2 Line 5 pixels down, 1 right every 2, to (162,59)
B $CC6C,2,2 Line 5 pixels diagonally down-right, to (167,54)
B $CC6E,2,2 Line 5 pixels right, 1 down every 2, to (172,52)
B $CC70,2,2 Line 3 pixels right, 1 down every 3, to (175,51)
B $CC72,2,2 Line 5 pixels right, 1 down every 5, to (180,50)
B $CC74,3,3 Move to (197,69)
B $CC77,2,2 Line 5 pixels down, 1 left every 4, to (196,64)
B $CC79,2,2 Line 5 pixels down, 1 left every 2, to (194,59)
B $CC7B,2,2 Line 5 pixels diagonally down-left, to (189,54)
B $CC7D,2,2 Line 5 pixels left, 1 down every 2, to (184,52)
B $CC7F,2,2 Line 5 pixels left, 1 down every 4, to (179,51)
B $CC81,3,3 Move to (145,78)
B $CC84,2,2 Line 40 pixels left, to (105,78)
B $CC86,2,2 Line 40 pixels left, 1 up every 8, to (65,83)
B $CC88,2,2 Line 40 pixels left, 1 up every 8, to (25,88)
B $CC8A,2,2 Line 40 pixels left, 1 up every 8, to (0,93)
B $CC8C,3,3 Move to (145,55)
B $CC8F,2,2 Line 40 pixels left, to (105,55)
B $CC91,2,2 Line 40 pixels left, 1 down every 8, to (65,50)
B $CC93,2,2 Line 40 pixels left, 1 down every 8, to (25,45)
B $CC95,2,2 Line 40 pixels left, 1 down every 8, to (0,40)
B $CC97,3,3 Move to (145,89)
B $CC9A,2,2 Line 47 pixels left, 1 up every 47, to (98,90)
B $CC9C,2,2 Line 40 pixels left, 1 up every 5, to (58,98)
B $CC9E,2,2 Line 40 pixels left, 1 up every 5, to (18,106)
B $CCA0,2,2 Line 40 pixels left, 1 up every 5, to (0,114)
B $CCA2,3,3 Move to (106,24)
B $CCA5,2,2 Line 15 pixels left, to (91,24)
B $CCA7,2,2 Line 14 pixels up, 1 left every 2, to (84,38)
B $CCA9,2,2 Line 14 pixels right, to (98,38)
B $CCAB,2,2 Line 15 pixels right, to (113,38)
B $CCAD,2,2 Line 15 pixels down, 1 left every 2, to (106,23)
B $CCAF,3,3 Move to (85,38)
B $CCB2,2,2 Line 3 pixels up, 1 right every 2, to (86,41)
B $CCB4,2,2 Line 3 pixels diagonally up-right, to (89,44)
B $CCB6,2,2 Line 3 pixels right, 1 up every 2, to (92,45)
B $CCB8,2,2 Line 3 pixels right, 1 up every 2, to (95,46)
B $CCBA,2,2 Line 3 pixels right, 1 up every 3, to (98,47)
B $CCBC,2,2 Line 3 pixels right, 1 down every 3, to (101,46)
B $CCBE,2,2 Line 3 pixels right, 1 down every 3, to (104,45)
B $CCC0,2,2 Line 3 pixels right, 1 down every 3, to (107,44)
B $CCC2,2,2 Line 3 pixels right, 1 down every 2, to (110,43)
B $CCC4,2,2 Line 3 pixels right, 1 down every 2, to (113,42)
B $CCC6,2,2 Line 3 pixels down, 1 right every 2, to (114,39)
B $CCC8,2,2 Line 3 pixels right, 1 up every 2, to (117,40)
B $CCCA,2,2 Line 5 pixels diagonally up-right, to (122,45)
B $CCCC,3,3 Move to (108,24)
B $CCCF,2,2 Line 10 pixels diagonally up-right, to (118,34)
B $CCD1,2,2 Line 11 pixels up, 1 right every 3, to (121,45)
B $CCD3,2,2 Line 3 pixels diagonally up-left, to (118,48)
B $CCD5,2,2 Line 3 pixels left, 1 up every 2, to (115,49)
B $CCD7,2,2 Line 3 pixels left, 1 up every 2, to (112,50)
B $CCD9,2,2 Line 3 pixels left, 1 up every 3, to (109,51)
B $CCDB,2,2 Line 3 pixels left, 1 down every 3, to (106,50)
B $CCDD,2,2 Line 3 pixels left, 1 down every 3, to (103,49)
B $CCDF,2,2 Line 3 pixels left, 1 down every 3, to (100,48)
B $CCE1,2,2 Line 3 pixels left, 1 down every 3, to (97,47)
B $CCE3,2,2 Line 3 pixels left, 1 down every 3, to (94,46)
B $CCE5,3,3 Move to (92,24)
B $CCE8,2,2 Line 22 pixels up, 1 right every 22, to (93,46)
B $CCEA,3,3 Move to (99,24)
B $CCED,2,2 Line 24 pixels up, 1 right every 24, to (100,48)
B $CCEF,3,3 Move to (107,25)
B $CCF2,2,2 Line 21 pixels up, 1 right every 21, to (108,46)
B $CCF4,3,3 Move to (85,37)
B $CCF7,2,2 Line 29 pixels right, 1 down every 29, to (114,36)
B $CCF9,3,3 Move to (108,44)
B $CCFC,2,2 Line 10 pixels right, 1 up every 2, to (118,49)
B $CCFE,3,3 Move to (102,47)
B $CD01,2,2 Line 9 pixels right, 1 up every 2, to (111,51)
B $CD03,3,3 Move to (147,44)
B $CD06,2,2 Line 26 pixels left, to (121,44)
B $CD08,3,3 Move to (85,40)
B $CD0B,2,2 Line 26 pixels left, 1 down every 5, to (59,35)
B $CD0D,2,2 Line 26 pixels left, 1 down every 5, to (33,30)
B $CD0F,2,2 Line 26 pixels left, 1 down every 5, to (7,25)
B $CD11,2,2 Line 26 pixels left, 1 down every 5, to (0,20)
B $CD13,3,3 Move to (147,55)
B $CD16,2,2 Line 35 pixels up, 1 right every 35, to (148,90)
B $CD18,2,2 Line 6 pixels up, 1 right every 2, to (151,96)
B $CD1A,2,2 Line 6 pixels diagonally up-right, to (157,102)
B $CD1C,2,2 Line 6 pixels right, 1 up every 2, to (163,105)
B $CD1E,2,2 Line 6 pixels right, 1 up every 3, to (169,107)
B $CD20,2,2 Line 6 pixels right, 1 up every 4, to (175,108)
B $CD22,2,2 Line 6 pixels right, to (181,108)
B $CD24,3,3 Move to (208,89)
B $CD27,2,2 Line 6 pixels up, 1 left every 2, to (205,95)
B $CD29,2,2 Line 6 pixels diagonally up-left, to (199,101)
B $CD2B,2,2 Line 6 pixels left, 1 up every 2, to (193,104)
B $CD2D,2,2 Line 6 pixels left, 1 up every 3, to (187,106)
B $CD2F,2,2 Line 7 pixels left, 1 up every 3, to (180,108)
B $CD31,3,3 Move to (208,88)
B $CD34,2,2 Line 34 pixels down, to (208,54)
B $CD36,2,2 Line 7 pixels diagonally down-left, to (201,47)
B $CD38,2,2 Line 43 pixels left, 1 up every 43, to (158,48)
B $CD3A,2,2 Line 13 pixels up, 1 left every 2, to (152,61)
B $CD3C,2,2 Line 38 pixels up, 1 right every 31, to (153,99)
B $CD3E,3,3 Move to (152,58)
B $CD41,2,2 Line 6 pixels left, 1 down every 2, to (146,55)
B $CD43,3,3 Move to (157,49)
B $CD46,2,2 Line 11 pixels left, 1 down every 2, to (146,44)
B $CD48,3,3 Move to (96,54)
B $CD4B,2,2 Line 3 pixels diagonally down-right, to (99,51)
B $CD4D,3,3 Move to (99,52)
B $CD50,2,2 Line 49 pixels right, 1 down every 49, to (148,51)
B $CD52,3,3 Move to (148,52)
B $CD55,2,2 Line 4 pixels up, 1 left every 2, to (146,56)
B $CD57,3,3 Move to (148,53)
B $CD5A,2,2 Line 7 pixels right, 1 up every 2, to (155,56)
B $CD5C,3,3 Move to (148,45)
B $CD5F,2,2 Line 8 pixels up, 1 right every 8, to (149,53)
B $CD61,3,3 Move to (205,51)
B $CD64,2,2 Line 33 pixels up, to (205,84)
B $CD66,2,2 Line 14 pixels up, 1 left every 6, to (203,98)
B $CD68,3,3 Move to (155,47)
B $CD6B,2,2 Line 8 pixels right, to (163,47)
B $CD6D,3,3 Move to (157,48)
B $CD70,2,2 Line 1 pixels diagonally up-right, to (158,49)
B $CD72,3,3 Move to (156,48)
B $CD75,2,2 Line 1 pixels diagonally up-right, to (157,49)
B $CD77,3,3 Move to (98,52)
B $CD7A,2,2 Line 63 pixels left, 1 down every 6, to (35,42)
B $CD7C,2,2 Line 63 pixels left, 1 down every 6, to (0,32)
B $CD7E,3,3 Move to (147,78)
B $CD81,2,2 Line 6 pixels right, 1 up every 4, to (153,79)
B $CD83,3,3 Move to (147,89)
B $CD86,2,2 Line 5 pixels right, 1 down every 4, to (152,88)
B $CD88,3,3 Move to (167,55)
B $CD8B,2,2 Line 36 pixels up, 1 right every 36, to (168,91)
B $CD8D,3,3 Move to (176,52)
B $CD90,2,2 Line 41 pixels up, 1 left every 41, to (175,93)
B $CD92,3,3 Move to (186,53)
B $CD95,2,2 Line 40 pixels up, 1 left every 40, to (185,93)
B $CD97,3,3 Move to (195,61)
B $CD9A,2,2 Line 24 pixels up, 1 left every 24, to (194,85)
B $CD9C,3,3 Move to (194,83)
B $CD9F,2,2 Line 8 pixels left, 1 down every 3, to (186,81)
B $CDA1,3,3 Move to (186,79)
B $CDA4,2,2 Line 13 pixels right, 1 down every 4, to (199,76)
B $CDA6,3,3 Move to (195,63)
B $CDA9,2,2 Line 10 pixels left, 1 up every 3, to (185,66)
B $CDAB,3,3 Move to (186,68)
B $CDAE,2,2 Line 13 pixels right, 1 up every 4, to (199,71)
B $CDB0,3,3 Move to (162,73)
B $CDB3,2,2 Line 4 pixels down, 1 right every 4, to (163,69)
B $CDB5,3,3 Move to (163,70)
B $CDB8,2,2 Line 4 pixels up, to (163,74)
B $CDBA,3,3 Move to (161,71)
B $CDBD,2,2 Line 2 pixels up, to (161,73)
B $CDBF,3,3 Move to (203,45)
B $CDC2,2,2 Line 10 pixels right, to (213,45)
B $CDC4,2,2 Line 43 pixels right, 1 down every 2, to (255,24)
B $CDC6,3,3 Move to (215,52)
B $CDC9,2,2 Line 43 pixels right, 1 down every 3, to (255,38)
B $CDCB,3,3 Move to (219,55)
B $CDCE,2,2 Line 43 pixels right, 1 down every 5, to (255,47)
B $CDD0,3,3 Move to (217,55)
B $CDD3,2,2 Line 3 pixels diagonally down-left, to (214,52)
B $CDD5,3,3 Move to (215,52)
B $CDD8,2,2 Line 8 pixels down, 1 right every 8, to (216,44)
B $CDDA,3,3 Move to (216,55)
B $CDDD,2,2 Line 8 pixels left, to (208,55)
B $CDDF,3,3 Move to (214,52)
B $CDE2,2,2 Line 10 pixels left, 1 down every 9, to (204,51)
B $CDE4,3,3 Move to (206,51)
B $CDE7,2,2 Line 7 pixels down, to (206,44)
B $CDE9,3,3 Move to (202,48)
B $CDEC,2,2 Line 4 pixels diagonally down-right, to (206,44)
B $CDEE,3,3 Move to (98,77)
B $CDF1,2,2 Line 24 pixels down, 1 right every 24, to (99,53)
B $CDF3,3,3 Move to (98,77)
B $CDF6,2,2 Line 13 pixels up, 1 right every 5, to (100,90)
B $CDF8,3,3 Move to (210,77)
B $CDFB,2,2 Line 7 pixels right, 1 up every 7, to (217,78)
B $CDFD,2,2 Line 45 pixels right, 1 up every 5, to (255,87)
B $CDFF,3,3 Move to (209,89)
B $CE02,2,2 Line 6 pixels right, 1 down every 6, to (215,88)
B $CE04,3,3 Move to (215,90)
B $CE07,2,2 Line 42 pixels right, 1 up every 3, to (255,104)
B $CE09,3,3 Move to (216,78)
B $CE0C,2,2 Line 24 pixels down, 1 right every 24, to (217,54)
B $CE0E,3,3 Move to (216,78)
B $CE11,2,2 Line 13 pixels up, 1 left every 5, to (214,91)
B $CE13,3,3 Move to (214,89)
B $CE16,2,2 Line 7 pixels up, 1 left every 4, to (213,96)
B $CE18,2,2 Line 7 pixels up, 1 left every 2, to (210,103)
B $CE1A,2,2 Line 7 pixels diagonally up-left, to (203,110)
B $CE1C,2,2 Line 7 pixels left, 1 up every 2, to (196,113)
B $CE1E,2,2 Line 7 pixels left, 1 up every 3, to (189,115)
B $CE20,2,2 Line 7 pixels left, 1 up every 4, to (182,116)
B $CE22,2,2 Line 7 pixels left, 1 up every 6, to (175,117)
B $CE24,2,2 Line 7 pixels left, 1 up every 7, to (168,118)
B $CE26,2,2 Line 7 pixels left, to (161,118)
B $CE28,2,2 Line 7 pixels left, to (154,118)
B $CE2A,2,2 Line 7 pixels left, to (147,118)
B $CE2C,2,2 Line 3 pixels left, to (144,118)
B $CE2E,2,2 Line 5 pixels left, to (139,118)
B $CE30,3,3 Move to (99,89)
B $CE33,2,2 Line 7 pixels up, 1 right every 3, to (101,96)
B $CE35,2,2 Line 7 pixels up, 1 right every 2, to (104,103)
B $CE37,2,2 Line 7 pixels diagonally up-right, to (111,110)
B $CE39,2,2 Line 7 pixels right, 1 up every 2, to (118,113)
B $CE3B,2,2 Line 7 pixels right, 1 up every 3, to (125,115)
B $CE3D,2,2 Line 7 pixels right, 1 up every 4, to (132,116)
B $CE3F,2,2 Line 8 pixels right, 1 up every 4, to (140,118)
B $CE41,3,3 Move to (207,55)
B $CE44,2,2 Line 3 pixels diagonally up-left, to (204,58)
B $CE46,3,3 Move to (209,77)
B $CE49,2,2 Line 4 pixels left, 1 up every 2, to (205,79)
B $CE4B,3,3 Move to (208,89)
B $CE4E,2,2 Line 3 pixels left, 1 down every 3, to (205,88)
B $CE50,3,3 Move to (96,52)
B $CE53,2,2 Line 5 pixels down, 1 left every 5, to (95,47)
B $CE55,3,3 Fill from (191,81) in black
B $CE58,3,3 Fill from (191,67) in black
B $CE5B,3,3 Fill from (196,80) in black
B $CE5E,3,3 Fill from (196,68) in black
B $CE61,3,3 Fill from (156,68) in black
B $CE64,15,15 Paint green paper from cell (19,7): 3 up, 5 right, 5 down, 4 left, 4 up, 3 right, 3 down, 2 left, 2 up, 1 right, 2 down
B $CE73,3,3 Fill from (127,24) in magenta
B $CE76,1,1 End of picture
b $CE77 Picture: room 49 (?)
D $CE77 The picture for room 49 (?). It is 315 bytes long: 104 lines, 25 moves, 6 fills and 1 painted areas. See #R$8985 for the format.
D $CE77 #HTML[<img src="../images/pictures/room49.png" alt="room 49">]
B $CE77,2,2 Border green, picture area black ink on green paper
B $CE79,3,3 Move to (164,0)
B $CE7C,2,2 Line 7 pixels up, 1 left every 3, to (162,7)
B $CE7E,2,2 Line 7 pixels up, to (162,14)
B $CE80,2,2 Line 10 pixels up, 1 right every 3, to (165,24)
B $CE82,2,2 Line 5 pixels up, 1 right every 5, to (166,29)
B $CE84,2,2 Line 8 pixels up, 1 left every 2, to (162,37)
B $CE86,2,2 Line 16 pixels left, 1 up every 3, to (146,42)
B $CE88,2,2 Line 9 pixels left, to (137,42)
B $CE8A,2,2 Line 63 pixels left, 1 down every 5, to (74,30)
B $CE8C,2,2 Line 12 pixels left, 1 down every 12, to (62,29)
B $CE8E,2,2 Line 63 pixels left, 1 up every 8, to (0,36)
B $CE90,3,3 Move to (0,79)
B $CE93,2,2 Line 14 pixels right, 1 up every 4, to (14,82)
B $CE95,2,2 Line 36 pixels right, 1 up every 9, to (50,86)
B $CE97,2,2 Line 16 pixels right, 1 down every 11, to (66,85)
B $CE99,2,2 Line 10 pixels right, 1 up every 3, to (76,88)
B $CE9B,2,2 Line 5 pixels up, 1 right every 4, to (77,93)
B $CE9D,2,2 Line 12 pixels left, 1 up every 3, to (65,97)
B $CE9F,2,2 Line 12 pixels left, 1 up every 6, to (53,99)
B $CEA1,2,2 Line 24 pixels left, 1 up every 6, to (29,103)
B $CEA3,2,2 Line 3 pixels diagonally up-right, to (32,106)
B $CEA5,2,2 Line 39 pixels right, 1 up every 6, to (71,112)
B $CEA7,2,2 Line 39 pixels right, 1 down every 12, to (110,109)
B $CEA9,2,2 Line 39 pixels right, 1 down every 6, to (149,103)
B $CEAB,2,2 Line 32 pixels right, 1 down every 6, to (181,98)
B $CEAD,2,2 Line 24 pixels right, 1 up every 7, to (205,101)
B $CEAF,2,2 Line 4 pixels up, 1 right every 4, to (206,105)
B $CEB1,2,2 Line 42 pixels left, 1 up every 6, to (164,112)
B $CEB3,2,2 Line 42 pixels left, 1 up every 12, to (122,115)
B $CEB5,2,2 Line 3 pixels up, 1 right every 2, to (123,118)
B $CEB7,2,2 Line 46 pixels right, 1 up every 5, to (169,127)
B $CEB9,3,3 Move to (233,0)
B $CEBC,2,2 Line 20 pixels left, 1 up every 2, to (213,10)
B $CEBE,2,2 Line 9 pixels up, 1 left every 3, to (210,19)
B $CEC0,2,2 Line 31 pixels up, 1 left every 30, to (209,50)
B $CEC2,2,2 Line 21 pixels left, 1 up every 2, to (188,60)
B $CEC4,2,2 Line 21 pixels left, 1 down every 13, to (167,59)
B $CEC6,2,2 Line 42 pixels left, 1 down every 5, to (125,51)
B $CEC8,2,2 Line 23 pixels left, 1 down every 6, to (102,48)
B $CECA,2,2 Line 23 pixels left, 1 up every 8, to (79,50)
B $CECC,2,2 Line 14 pixels left, 1 up every 5, to (65,52)
B $CECE,2,2 Line 14 pixels left, 1 down every 6, to (51,50)
B $CED0,2,2 Line 14 pixels left, 1 up every 3, to (37,54)
B $CED2,2,2 Line 6 pixels up, 1 right every 2, to (40,60)
B $CED4,2,2 Line 22 pixels right, 1 up every 5, to (62,64)
B $CED6,2,2 Line 39 pixels right, 1 up every 8, to (101,68)
B $CED8,2,2 Line 39 pixels right, 1 up every 5, to (140,75)
B $CEDA,2,2 Line 7 pixels up, 1 right every 2, to (143,82)
B $CEDC,2,2 Line 7 pixels up, 1 left every 3, to (141,89)
B $CEDE,2,2 Line 57 pixels left, 1 up every 6, to (84,98)
B $CEE0,2,2 Line 9 pixels right, 1 up every 2, to (93,102)
B $CEE2,2,2 Line 9 pixels right, 1 up every 6, to (102,103)
B $CEE4,2,2 Line 9 pixels right, 1 down every 7, to (111,102)
B $CEE6,2,2 Line 38 pixels right, 1 down every 7, to (149,97)
B $CEE8,2,2 Line 38 pixels right, 1 down every 5, to (187,90)
B $CEEA,2,2 Line 38 pixels right, 1 up every 9, to (225,94)
B $CEEC,2,2 Line 16 pixels up, 1 right every 3, to (230,110)
B $CEEE,2,2 Line 18 pixels left, 1 up every 6, to (212,113)
B $CEF0,2,2 Line 40 pixels left, 1 up every 11, to (172,116)
B $CEF2,2,2 Line 7 pixels left, 1 up every 2, to (165,119)
B $CEF4,2,2 Line 7 pixels up, 1 right every 6, to (166,126)
B $CEF6,3,3 Move to (223,93)
B $CEF9,2,2 Line 14 pixels right, 1 up every 2, to (237,100)
B $CEFB,2,2 Line 19 pixels right, 1 up every 5, to (255,103)
B $CEFD,3,3 Move to (140,74)
B $CF00,2,2 Line 19 pixels right, 1 up every 8, to (159,76)
B $CF02,2,2 Line 18 pixels right, 1 up every 2, to (177,85)
B $CF04,2,2 Line 18 pixels right, 1 up every 4, to (195,89)
B $CF06,3,3 Move to (177,85)
B $CF09,2,2 Line 5 pixels down, 1 right every 2, to (179,80)
B $CF0B,2,2 Line 23 pixels right, 1 down every 2, to (202,69)
B $CF0D,2,2 Line 23 pixels right, 1 down every 7, to (225,66)
B $CF0F,2,2 Line 31 pixels right, 1 down every 14, to (255,64)
B $CF11,3,3 Move to (84,127)
B $CF14,2,2 Line 38 pixels right, 1 down every 3, to (122,115)
B $CF16,3,3 Move to (23,46)
B $CF19,2,2 Line 17 pixels left, 1 up every 6, to (6,48)
B $CF1B,2,2 Line 7 pixels up, 1 left every 3, to (4,55)
B $CF1D,2,2 Line 21 pixels right, 1 down every 4, to (25,50)
B $CF1F,2,2 Line 5 pixels down, 1 left every 4, to (24,45)
B $CF21,3,3 Move to (14,54)
B $CF24,2,2 Line 11 pixels up, 1 left every 11, to (13,65)
B $CF26,3,3 Move to (15,53)
B $CF29,2,2 Line 11 pixels up, 1 left every 11, to (14,64)
B $CF2B,3,3 Move to (19,52)
B $CF2E,2,2 Line 9 pixels up, 1 left every 9, to (18,61)
B $CF30,3,3 Move to (20,51)
B $CF33,2,2 Line 10 pixels up, 1 left every 9, to (19,61)
B $CF35,3,3 Fill from (20,49) in black
B $CF38,11,11 Paint cyan paper from cell (0,10): 3 up, 1 right, 3 down, 1 right, 3 up, 1 right, 4 down
B $CF43,3,3 Move to (0,72)
B $CF46,2,2 Line 32 pixels right, to (32,72)
B $CF48,2,2 Line 33 pixels down, 1 left every 33, to (31,39)
B $CF4A,2,2 Line 34 pixels left, 1 down every 33, to (0,38)
B $CF4C,3,3 Fill from (72,40) in cyan
B $CF4F,3,3 Move to (65,113)
B $CF52,2,2 Line 20 pixels left, 1 up every 4, to (45,118)
B $CF54,2,2 Line 20 pixels left, 1 up every 10, to (25,120)
B $CF56,2,2 Line 20 pixels left, 1 down every 4, to (5,115)
B $CF58,2,2 Line 20 pixels left, 1 down every 3, to (0,109)
B $CF5A,3,3 Move to (226,28)
B $CF5D,2,2 Line 12 pixels up, 1 right every 12, to (227,40)
B $CF5F,2,2 Line 5 pixels up, 1 right every 2, to (229,45)
B $CF61,2,2 Line 9 pixels down, 1 right every 2, to (233,36)
B $CF63,2,2 Line 11 pixels down, 1 left every 11, to (232,25)
B $CF65,3,3 Move to (233,26)
B $CF68,2,2 Line 8 pixels left, 1 up every 3, to (225,28)
B $CF6A,3,3 Move to (234,36)
B $CF6D,2,2 Line 13 pixels right, 1 up every 4, to (247,39)
B $CF6F,2,2 Line 9 pixels up, 1 left every 2, to (243,48)
B $CF71,2,2 Line 14 pixels left, 1 down every 4, to (229,45)
B $CF73,3,3 Move to (233,26)
B $CF76,2,2 Line 14 pixels right, 1 up every 4, to (247,29)
B $CF78,2,2 Line 10 pixels up, 1 right every 10, to (248,39)
B $CF7A,3,3 Fill from (239,40) in red
B $CF7D,3,3 Move to (240,48)
B $CF80,2,2 Line 14 pixels up, 1 right every 5, to (242,62)
B $CF82,3,3 Move to (243,62)
B $CF85,2,2 Line 24 pixels down, 1 right every 5, to (247,38)
B $CF87,3,3 Fill from (242,52) in red
B $CF8A,3,3 Fill from (242,32) in red
B $CF8D,3,3 Move to (237,16)
B $CF90,2,2 Line 8 pixels down, 1 left every 8, to (236,8)
B $CF92,3,3 Move to (238,8)
B $CF95,2,2 Line 11 pixels right, 1 down every 3, to (249,5)
B $CF97,2,2 Line 8 pixels up, 1 right every 8, to (250,13)
B $CF99,3,3 Move to (249,13)
B $CF9C,2,2 Line 12 pixels left, 1 up every 3, to (237,17)
B $CF9E,2,2 Line 4 pixels diagonally up-right, to (241,21)
B $CFA0,2,2 Line 11 pixels right, 1 down every 3, to (252,18)
B $CFA2,2,2 Line 5 pixels down, 1 left every 2, to (250,13)
B $CFA4,3,3 Move to (253,17)
B $CFA7,2,2 Line 5 pixels diagonally down-right, to (255,12)
B $CFA9,3,3 Move to (250,5)
B $CFAC,2,2 Line 7 pixels right, 1 up every 2, to (255,8)
B $CFAE,3,3 Fill from (246,17) in red
B $CFB1,1,1 End of picture
b $CFB2 Picture: room 6 (?)
D $CFB2 The picture for room 6 (?). It is 668 bytes long: 244 lines, 46 moves, 13 fills and 0 painted areas. See #R$8985 for the format.
D $CFB2 #HTML[<img src="../images/pictures/room06.png" alt="room 6">]
B $CFB2,2,2 Border black, picture area black ink on green paper
B $CFB4,3,3 Move to (47,25)
B $CFB7,2,2 Line 37 pixels up, 1 right every 2, to (65,62)
B $CFB9,2,2 Line 7 pixels right, 1 up every 7, to (72,63)
B $CFBB,2,2 Line 7 pixels down, 1 right every 4, to (73,56)
B $CFBD,2,2 Line 20 pixels right, 1 down every 4, to (93,51)
B $CFBF,2,2 Line 8 pixels diagonally down-right, to (101,43)
B $CFC1,2,2 Line 5 pixels up, 1 right every 4, to (102,48)
B $CFC3,2,2 Line 9 pixels up, 1 left every 2, to (98,57)
B $CFC5,3,3 Move to (98,56)
B $CFC8,2,2 Line 9 pixels diagonally up-left, to (89,65)
B $CFCA,2,2 Line 9 pixels left, 1 up every 3, to (80,68)
B $CFCC,2,2 Line 12 pixels right, 1 up every 12, to (92,69)
B $CFCE,2,2 Line 8 pixels diagonally up-left, to (84,77)
B $CFD0,2,2 Line 8 pixels left, 1 down every 2, to (76,73)
B $CFD2,2,2 Line 6 pixels left, 1 up every 4, to (70,74)
B $CFD4,2,2 Line 31 pixels up, 1 right every 2, to (85,105)
B $CFD6,2,2 Line 21 pixels right, 1 up every 14, to (106,106)
B $CFD8,2,2 Line 18 pixels right, 1 up every 3, to (124,112)
B $CFDA,2,2 Line 7 pixels down, 1 right every 2, to (127,105)
B $CFDC,2,2 Line 11 pixels up, 1 right every 4, to (129,116)
B $CFDE,2,2 Line 23 pixels right, 1 up every 4, to (152,121)
B $CFE0,2,2 Line 7 pixels diagonally down-right, to (159,114)
B $CFE2,2,2 Line 6 pixels left, 1 up every 6, to (153,115)
B $CFE4,2,2 Line 11 pixels left, 1 down every 2, to (142,110)
B $CFE6,2,2 Line 11 pixels down, 1 left every 3, to (139,99)
B $CFE8,2,2 Line 10 pixels right, 1 up every 2, to (149,104)
B $CFEA,2,2 Line 13 pixels down, 1 left every 2, to (143,91)
B $CFEC,2,2 Line 21 pixels right, 1 up every 4, to (164,96)
B $CFEE,2,2 Line 3 pixels right, 1 up every 3, to (167,97)
B $CFF0,2,2 Line 7 pixels down, 1 left every 3, to (165,90)
B $CFF2,2,2 Line 3 pixels diagonally down-right, to (168,87)
B $CFF4,2,2 Line 6 pixels up, 1 right every 2, to (171,93)
B $CFF6,2,2 Line 11 pixels down, to (171,82)
B $CFF8,2,2 Line 11 pixels left, 1 down every 2, to (160,77)
B $CFFA,2,2 Line 11 pixels right, 1 down every 7, to (171,76)
B $CFFC,2,2 Line 11 pixels down, to (171,65)
B $CFFE,2,2 Line 11 pixels left, 1 down every 3, to (160,62)
B $D000,2,2 Line 5 pixels down, 1 right every 4, to (161,57)
B $D002,2,2 Line 10 pixels right, 1 up every 5, to (171,59)
B $D004,2,2 Line 49 pixels down, 1 left every 14, to (168,10)
B $D006,2,2 Line 14 pixels up, 1 left every 2, to (161,24)
B $D008,2,2 Line 9 pixels down, 1 left every 2, to (157,15)
B $D00A,2,2 Line 12 pixels down, 1 left every 5, to (155,3)
B $D00C,2,2 Line 34 pixels left, 1 up every 11, to (121,6)
B $D00E,2,2 Line 7 pixels up, 1 right every 4, to (122,13)
B $D010,2,2 Line 6 pixels up, 1 right every 6, to (123,19)
B $D012,2,2 Line 6 pixels up, 1 right every 3, to (125,25)
B $D014,2,2 Line 10 pixels diagonally down-left, to (115,15)
B $D016,2,2 Line 13 pixels up, 1 left every 13, to (114,28)
B $D018,2,2 Line 13 pixels down, 1 left every 2, to (108,15)
B $D01A,2,2 Line 9 pixels down, 1 right every 5, to (109,6)
B $D01C,2,2 Line 20 pixels left, 1 up every 4, to (89,11)
B $D01E,2,2 Line 8 pixels diagonally up-left, to (81,19)
B $D020,2,2 Line 8 pixels left, 1 down every 2, to (73,15)
B $D022,2,2 Line 8 pixels up, 1 right every 2, to (77,23)
B $D024,2,2 Line 8 pixels diagonally up-right, to (85,31)
B $D026,2,2 Line 5 pixels up, 1 left every 3, to (84,36)
B $D028,2,2 Line 11 pixels left, 1 down every 4, to (73,34)
B $D02A,2,2 Line 16 pixels down, 1 left every 2, to (65,18)
B $D02C,2,2 Line 19 pixels left, 1 up every 10, to (46,19)
B $D02E,2,2 Line 10 pixels up, 1 right every 3, to (49,29)
B $D030,3,3 Move to (55,114)
B $D033,2,2 Line 12 pixels left, 1 up every 4, to (43,117)
B $D035,2,2 Line 6 pixels up, 1 right every 5, to (44,123)
B $D037,2,2 Line 11 pixels right, 1 up every 4, to (55,125)
B $D039,2,2 Line 11 pixels down, 1 right every 6, to (56,114)
B $D03B,3,3 Move to (62,114)
B $D03E,2,2 Line 12 pixels down, 1 right every 2, to (68,102)
B $D040,2,2 Line 14 pixels up, 1 right every 5, to (70,116)
B $D042,2,2 Line 10 pixels down, 1 right every 2, to (75,106)
B $D044,2,2 Line 6 pixels down, 1 left every 4, to (74,100)
B $D046,2,2 Line 3 pixels right, 1 down every 3, to (77,99)
B $D048,2,2 Line 17 pixels up, 1 right every 2, to (85,116)
B $D04A,2,2 Line 17 pixels up, 1 left every 4, to (81,127)
B $D04C,3,3 Move to (62,115)
B $D04F,2,2 Line 17 pixels up, 1 left every 15, to (61,127)
B $D051,3,3 Move to (70,127)
B $D054,2,2 Line 8 pixels down, 1 right every 2, to (74,119)
B $D056,2,2 Line 9 pixels up, 1 right every 3, to (77,127)
B $D058,3,3 Move to (185,4)
B $D05B,2,2 Line 56 pixels up, 1 right every 3, to (203,60)
B $D05D,2,2 Line 11 pixels down, 1 right every 2, to (208,49)
B $D05F,2,2 Line 6 pixels down, 1 right every 6, to (209,43)
B $D061,2,2 Line 6 pixels up, 1 right every 2, to (212,49)
B $D063,2,2 Line 16 pixels up, 1 right every 4, to (216,65)
B $D065,2,2 Line 9 pixels up, 1 left every 4, to (214,74)
B $D067,2,2 Line 9 pixels right, 1 down every 5, to (223,73)
B $D069,2,2 Line 5 pixels up, 1 left every 4, to (222,78)
B $D06B,2,2 Line 5 pixels right, 1 down every 4, to (227,77)
B $D06D,2,2 Line 9 pixels down, 1 right every 4, to (229,68)
B $D06F,2,2 Line 6 pixels down, 1 right every 6, to (230,62)
B $D071,2,2 Line 7 pixels up, 1 right every 2, to (233,69)
B $D073,2,2 Line 10 pixels down, 1 right every 10, to (234,59)
B $D075,2,2 Line 14 pixels right, 1 up every 2, to (248,66)
B $D077,2,2 Line 11 pixels down, 1 left every 5, to (246,55)
B $D079,2,2 Line 18 pixels left, 1 down every 5, to (228,52)
B $D07B,2,2 Line 6 pixels left, 1 down every 2, to (222,49)
B $D07D,2,2 Line 9 pixels down, 1 left every 2, to (218,40)
B $D07F,2,2 Line 4 pixels right, 1 down every 2, to (222,38)
B $D081,2,2 Line 15 pixels right, 1 up every 5, to (237,41)
B $D083,2,2 Line 7 pixels down, 1 left every 4, to (236,34)
B $D085,2,2 Line 10 pixels down, 1 right every 3, to (239,24)
B $D087,2,2 Line 6 pixels down, 1 right every 4, to (240,18)
B $D089,2,2 Line 16 pixels up, 1 right every 2, to (248,34)
B $D08B,2,2 Line 23 pixels down, 1 right every 3, to (255,11)
B $D08D,3,3 Move to (178,37)
B $D090,2,2 Line 31 pixels up, 1 right every 17, to (179,68)
B $D092,2,2 Line 11 pixels right, 1 up every 6, to (190,69)
B $D094,3,3 Move to (189,69)
B $D097,2,2 Line 34 pixels down, 1 left every 3, to (178,35)
B $D099,3,3 Move to (185,4)
B $D09C,2,2 Line 34 pixels right, 1 up every 11, to (219,7)
B $D09E,2,2 Line 34 pixels right, 1 down every 3, to (253,0)
B $D0A0,3,3 Move to (178,97)
B $D0A3,2,2 Line 10 pixels right, 1 up every 2, to (188,102)
B $D0A5,2,2 Line 14 pixels down, 1 right every 8, to (189,88)
B $D0A7,2,2 Line 10 pixels left, 1 down every 3, to (179,85)
B $D0A9,2,2 Line 12 pixels up, 1 left every 6, to (177,97)
B $D0AB,3,3 Move to (130,123)
B $D0AE,2,2 Line 4 pixels down, 1 left every 4, to (129,119)
B $D0B0,2,2 Line 6 pixels right, 1 up every 3, to (135,121)
B $D0B2,2,2 Line 6 pixels left, 1 up every 2, to (129,124)
B $D0B4,3,3 Move to (120,118)
B $D0B7,2,2 Line 6 pixels diagonally up-left, to (114,124)
B $D0B9,2,2 Line 6 pixels left, 1 up every 3, to (108,126)
B $D0BB,2,2 Line 6 pixels left, 1 up every 6, to (102,127)
B $D0BD,2,2 Line 6 pixels diagonally down-left, to (96,121)
B $D0BF,2,2 Line 6 pixels diagonally down-left, to (90,115)
B $D0C1,2,2 Line 6 pixels down, 1 left every 2, to (87,109)
B $D0C3,2,2 Line 6 pixels right, 1 up every 6, to (93,110)
B $D0C5,2,2 Line 6 pixels right, 1 up every 5, to (99,111)
B $D0C7,2,2 Line 6 pixels right, 1 up every 6, to (105,112)
B $D0C9,2,2 Line 6 pixels right, 1 up every 5, to (111,113)
B $D0CB,2,2 Line 10 pixels right, 1 up every 2, to (121,118)
B $D0CD,3,3 Move to (107,6)
B $D0D0,2,2 Line 21 pixels up, 1 left every 2, to (97,27)
B $D0D2,2,2 Line 10 pixels up, 1 left every 3, to (94,37)
B $D0D4,2,2 Line 10 pixels up, 1 right every 3, to (97,47)
B $D0D6,3,3 Move to (101,53)
B $D0D9,2,2 Line 10 pixels right, 1 up every 2, to (111,58)
B $D0DB,2,2 Line 10 pixels diagonally up-right, to (121,68)
B $D0DD,2,2 Line 10 pixels up, 1 right every 3, to (124,78)
B $D0DF,2,2 Line 10 pixels up, 1 left every 5, to (122,88)
B $D0E1,2,2 Line 10 pixels diagonally up-left, to (112,98)
B $D0E3,2,2 Line 10 pixels left, 1 up every 5, to (102,100)
B $D0E5,2,2 Line 10 pixels left, 1 up every 7, to (92,101)
B $D0E7,2,2 Line 10 pixels left, 1 up every 7, to (82,102)
B $D0E9,3,3 Move to (78,103)
B $D0EC,2,2 Line 4 pixels left, 1 up every 4, to (74,104)
B $D0EE,3,3 Move to (209,7)
B $D0F1,2,2 Line 22 pixels left, 1 up every 4, to (187,12)
B $D0F3,3,3 Move to (169,21)
B $D0F6,2,2 Line 22 pixels left, 1 up every 2, to (147,32)
B $D0F8,2,2 Line 15 pixels up, 1 left every 2, to (140,47)
B $D0FA,2,2 Line 10 pixels up, 1 left every 9, to (139,57)
B $D0FC,2,2 Line 10 pixels up, 1 right every 4, to (141,67)
B $D0FE,2,2 Line 10 pixels up, 1 right every 3, to (144,77)
B $D100,2,2 Line 10 pixels up, 1 left every 9, to (143,87)
B $D102,2,2 Line 10 pixels up, 1 left every 4, to (141,97)
B $D104,2,2 Line 10 pixels left, 1 up every 2, to (131,102)
B $D106,2,2 Line 10 pixels left, 1 up every 2, to (121,107)
B $D108,2,2 Line 10 pixels left, 1 up every 8, to (111,108)
B $D10A,3,3 Move to (81,108)
B $D10D,2,2 Line 8 pixels left, 1 up every 8, to (73,109)
B $D10F,3,3 Move to (68,109)
B $D112,2,2 Line 4 pixels left, 1 up every 4, to (64,110)
B $D114,3,3 Fill from (0,0) in black
B $D117,3,3 Fill from (72,127) in black
B $D11A,3,3 Move to (122,101)
B $D11D,2,2 Line 2 pixels right, 1 down every 2, to (124,100)
B $D11F,2,2 Line 2 pixels down, 1 right every 2, to (125,98)
B $D121,2,2 Line 4 pixels left, 1 up every 3, to (121,99)
B $D123,3,3 Move to (127,91)
B $D126,2,2 Line 4 pixels left, 1 up every 3, to (123,92)
B $D128,2,2 Line 4 pixels right, 1 up every 2, to (127,94)
B $D12A,2,2 Line 4 pixels down, 1 right every 4, to (128,90)
B $D12C,3,3 Move to (134,94)
B $D12F,2,2 Line 4 pixels down, 1 right every 4, to (135,90)
B $D131,2,2 Line 4 pixels up, 1 right every 3, to (136,94)
B $D133,2,2 Line 4 pixels left, 1 up every 4, to (132,95)
B $D135,3,3 Move to (130,85)
B $D138,2,2 Line 4 pixels diagonally down-left, to (126,81)
B $D13A,2,2 Line 4 pixels right, to (130,81)
B $D13C,2,2 Line 4 pixels up, 1 right every 2, to (132,85)
B $D13E,3,3 Move to (136,79)
B $D141,2,2 Line 4 pixels up, 1 right every 2, to (138,83)
B $D143,2,2 Line 4 pixels diagonally down-right, to (142,79)
B $D145,2,2 Line 4 pixels left, 1 down every 3, to (138,78)
B $D147,2,2 Line 4 pixels left, 1 up every 2, to (134,80)
B $D149,3,3 Move to (125,69)
B $D14C,2,2 Line 4 pixels up, 1 right every 3, to (126,73)
B $D14E,2,2 Line 4 pixels diagonally down-right, to (130,69)
B $D150,2,2 Line 6 pixels left, 1 down every 5, to (124,68)
B $D152,3,3 Move to (121,58)
B $D155,2,2 Line 4 pixels left, to (117,58)
B $D157,2,2 Line 4 pixels up, 1 right every 2, to (119,62)
B $D159,2,2 Line 4 pixels right, 1 up every 3, to (123,63)
B $D15B,2,2 Line 5 pixels down, 1 left every 4, to (122,58)
B $D15D,3,3 Move to (107,44)
B $D160,2,2 Line 5 pixels up, 1 right every 2, to (109,49)
B $D162,2,2 Line 3 pixels right, 1 up every 2, to (112,50)
B $D164,2,2 Line 3 pixels down, 1 right every 2, to (113,47)
B $D166,2,2 Line 3 pixels right, to (116,47)
B $D168,2,2 Line 3 pixels down, 1 left every 2, to (115,44)
B $D16A,2,2 Line 3 pixels left, 1 down every 2, to (112,43)
B $D16C,2,2 Line 3 pixels left, 1 down every 3, to (109,42)
B $D16E,2,2 Line 4 pixels left, 1 up every 2, to (105,44)
B $D170,3,3 Move to (117,26)
B $D173,2,2 Line 3 pixels diagonally up-left, to (114,29)
B $D175,2,2 Line 3 pixels up, 1 left every 2, to (113,32)
B $D177,2,2 Line 3 pixels up, to (113,35)
B $D179,2,2 Line 3 pixels right, 1 up every 3, to (116,36)
B $D17B,2,2 Line 3 pixels right, 1 down every 2, to (119,35)
B $D17D,2,2 Line 3 pixels up, 1 right every 2, to (120,38)
B $D17F,2,2 Line 3 pixels diagonally down-right, to (123,35)
B $D181,2,2 Line 3 pixels down, 1 left every 2, to (122,32)
B $D183,2,2 Line 3 pixels down, 1 left every 3, to (121,29)
B $D185,2,2 Line 3 pixels down, 1 left every 2, to (120,26)
B $D187,2,2 Line 3 pixels left, to (117,26)
B $D189,3,3 Move to (137,9)
B $D18C,2,2 Line 3 pixels left, to (134,9)
B $D18E,2,2 Line 3 pixels left, 1 up every 2, to (131,10)
B $D190,2,2 Line 3 pixels up, 1 left every 2, to (130,13)
B $D192,2,2 Line 3 pixels up, 1 right every 3, to (131,16)
B $D194,2,2 Line 3 pixels up, 1 right every 3, to (132,19)
B $D196,2,2 Line 3 pixels right, 1 up every 3, to (135,20)
B $D198,2,2 Line 3 pixels down, 1 right every 2, to (136,17)
B $D19A,2,2 Line 3 pixels up, 1 right every 2, to (137,20)
B $D19C,2,2 Line 3 pixels up, 1 right every 2, to (138,23)
B $D19E,2,2 Line 3 pixels down, 1 right every 2, to (139,20)
B $D1A0,2,2 Line 3 pixels down, 1 right every 3, to (140,17)
B $D1A2,2,2 Line 3 pixels down, to (140,14)
B $D1A4,2,2 Line 3 pixels down, 1 left every 2, to (139,11)
B $D1A6,2,2 Line 3 pixels diagonally down-left, to (136,8)
B $D1A8,3,3 Fill from (133,13) in red
B $D1AB,3,3 Fill from (117,31) in red
B $D1AE,3,3 Fill from (112,46) in red
B $D1B1,3,3 Fill from (119,60) in red
B $D1B4,3,3 Fill from (126,70) in red
B $D1B7,3,3 Fill from (129,82) in red
B $D1BA,3,3 Fill from (139,81) in red
B $D1BD,3,3 Move to (135,67)
B $D1C0,2,2 Line 3 pixels diagonally down-left, to (132,64)
B $D1C2,2,2 Line 3 pixels right, 1 down every 2, to (135,63)
B $D1C4,2,2 Line 3 pixels right, 1 up every 2, to (138,64)
B $D1C6,2,2 Line 3 pixels diagonally up-left, to (135,67)
B $D1C8,3,3 Move to (126,49)
B $D1CB,2,2 Line 3 pixels up, 1 left every 3, to (125,52)
B $D1CD,2,2 Line 3 pixels up, 1 right every 2, to (126,55)
B $D1CF,2,2 Line 3 pixels right, 1 up every 3, to (129,56)
B $D1D1,2,2 Line 3 pixels right, 1 down every 2, to (132,55)
B $D1D3,2,2 Line 3 pixels down, to (132,52)
B $D1D5,2,2 Line 3 pixels diagonally down-left, to (129,49)
B $D1D7,2,2 Line 3 pixels left, 1 down every 3, to (126,48)
B $D1D9,3,3 Move to (132,35)
B $D1DC,2,2 Line 3 pixels left, 1 down every 3, to (129,34)
B $D1DE,2,2 Line 3 pixels up, 1 left every 2, to (128,37)
B $D1E0,2,2 Line 3 pixels up, 1 left every 3, to (127,40)
B $D1E2,2,2 Line 3 pixels up, 1 right every 2, to (128,43)
B $D1E4,2,2 Line 3 pixels right, 1 down every 2, to (131,42)
B $D1E6,2,2 Line 3 pixels diagonally up-right, to (134,45)
B $D1E8,2,2 Line 3 pixels down, to (134,42)
B $D1EA,2,2 Line 3 pixels down, to (134,39)
B $D1EC,2,2 Line 3 pixels down, 1 left every 3, to (133,36)
B $D1EE,2,2 Line 3 pixels down, 1 left every 3, to (132,33)
B $D1F0,3,3 Move to (147,21)
B $D1F3,2,2 Line 3 pixels down, 1 left every 3, to (146,18)
B $D1F5,2,2 Line 3 pixels diagonally down-right, to (149,15)
B $D1F7,2,2 Line 3 pixels right, to (152,15)
B $D1F9,2,2 Line 3 pixels diagonally up-right, to (155,18)
B $D1FB,2,2 Line 3 pixels up, 1 right every 3, to (156,21)
B $D1FD,2,2 Line 3 pixels diagonally up-left, to (153,24)
B $D1FF,2,2 Line 3 pixels left, 1 up every 2, to (150,25)
B $D201,2,2 Line 3 pixels left, 1 down every 3, to (147,24)
B $D203,2,2 Line 3 pixels down, 1 right every 2, to (148,21)
B $D205,3,3 Fill from (151,21) in red
B $D208,3,3 Fill from (131,39) in red
B $D20B,3,3 Fill from (130,52) in red
B $D20E,3,3 Fill from (135,65) in red
B $D211,3,3 Move to (117,103)
B $D214,2,2 Line 2 pixels diagonally up-right, to (119,105)
B $D216,3,3 Move to (118,103)
B $D219,2,2 Line 2 pixels diagonally up-right, to (120,105)
B $D21B,3,3 Move to (116,103)
B $D21E,2,2 Line 2 pixels diagonally up-right, to (118,105)
B $D220,3,3 Move to (111,103)
B $D223,2,2 Line 2 pixels diagonally up-right, to (113,105)
B $D225,3,3 Move to (110,103)
B $D228,2,2 Line 2 pixels diagonally up-right, to (112,105)
B $D22A,3,3 Move to (112,100)
B $D22D,2,2 Line 2 pixels up, 1 right every 2, to (113,102)
B $D22F,3,3 Move to (113,100)
B $D232,2,2 Line 2 pixels up, 1 right every 2, to (114,102)
B $D234,3,3 Move to (118,98)
B $D237,2,2 Line 2 pixels up, 1 right every 2, to (119,100)
B $D239,3,3 Move to (119,98)
B $D23C,2,2 Line 2 pixels up, 1 right every 2, to (120,100)
B $D23E,3,3 Move to (120,97)
B $D241,2,2 Line 2 pixels up, 1 right every 2, to (121,99)
B $D243,3,3 Move to (106,103)
B $D246,2,2 Line 2 pixels up, 1 right every 2, to (107,105)
B $D248,3,3 Move to (102,103)
B $D24B,2,2 Line 2 pixels up, 1 right every 2, to (103,105)
B $D24D,1,1 End of picture
b $D24E Picture: room 11 (?)
D $D24E The picture for room 11 (?). It is 281 bytes long: 85 lines, 27 moves, 5 fills and 1 painted areas. See #R$8985 for the format.
D $D24E #HTML[<img src="../images/pictures/room11.png" alt="room 11">]
B $D24E,2,2 Border white, picture area black ink on white paper
B $D250,3,3 Move to (161,0)
B $D253,2,2 Line 12 pixels diagonally up-right, to (173,12)
B $D255,2,2 Line 12 pixels up, 1 right every 2, to (179,24)
B $D257,2,2 Line 12 pixels up, 1 right every 3, to (183,36)
B $D259,2,2 Line 17 pixels up, 1 left every 2, to (175,53)
B $D25B,2,2 Line 17 pixels left, 1 up every 4, to (158,57)
B $D25D,2,2 Line 17 pixels left, 1 up every 6, to (141,59)
B $D25F,2,2 Line 17 pixels left, 1 up every 3, to (124,64)
B $D261,2,2 Line 17 pixels left, 1 up every 6, to (107,66)
B $D263,2,2 Line 17 pixels left, 1 up every 2, to (90,74)
B $D265,2,2 Line 14 pixels up, 1 left every 5, to (88,88)
B $D267,2,2 Line 14 pixels up, 1 left every 11, to (87,102)
B $D269,2,2 Line 7 pixels up, 1 right every 2, to (90,109)
B $D26B,2,2 Line 6 pixels right, 1 up every 3, to (96,111)
B $D26D,3,3 Move to (96,110)
B $D270,2,2 Line 6 pixels down, 1 left every 2, to (93,104)
B $D272,2,2 Line 19 pixels down, 1 right every 8, to (95,85)
B $D274,2,2 Line 8 pixels down, 1 right every 3, to (97,77)
B $D276,2,2 Line 11 pixels right, 1 down every 2, to (108,72)
B $D278,2,2 Line 16 pixels right, 1 down every 6, to (124,70)
B $D27A,2,2 Line 16 pixels right, 1 down every 3, to (140,65)
B $D27C,2,2 Line 36 pixels right, 1 down every 5, to (176,58)
B $D27E,2,2 Line 36 pixels right, 1 down every 2, to (212,40)
B $D280,2,2 Line 36 pixels right, 1 down every 5, to (248,33)
B $D282,2,2 Line 36 pixels right, 1 down every 5, to (255,26)
B $D284,3,3 Move to (97,111)
B $D287,2,2 Line 18 pixels up, 1 right every 2, to (106,127)
B $D289,3,3 Move to (62,127)
B $D28C,2,2 Line 8 pixels down, 1 left every 3, to (60,119)
B $D28E,2,2 Line 5 pixels left, 1 down every 5, to (55,118)
B $D290,2,2 Line 63 pixels down, 1 left every 11, to (50,55)
B $D292,2,2 Line 63 pixels down, 1 left every 11, to (45,0)
B $D294,3,3 Move to (56,118)
B $D297,2,2 Line 42 pixels right, 1 down every 9, to (98,114)
B $D299,3,3 Move to (56,117)
B $D29C,2,2 Line 42 pixels right, 1 down every 9, to (98,113)
B $D29E,3,3 Move to (86,101)
B $D2A1,2,2 Line 63 pixels down, 1 left every 7, to (77,38)
B $D2A3,2,2 Line 24 pixels down, 1 left every 7, to (74,14)
B $D2A5,3,3 Move to (90,75)
B $D2A8,2,2 Line 62 pixels down, 1 left every 11, to (85,13)
B $D2AA,3,3 Move to (106,66)
B $D2AD,2,2 Line 58 pixels down, 1 left every 17, to (103,8)
B $D2AF,3,3 Move to (137,59)
B $D2B2,2,2 Line 53 pixels down, 1 left every 7, to (130,6)
B $D2B4,3,3 Move to (155,56)
B $D2B7,2,2 Line 52 pixels down, 1 left every 4, to (142,4)
B $D2B9,3,3 Move to (173,52)
B $D2BC,2,2 Line 51 pixels down, 1 left every 2, to (148,1)
B $D2BE,3,3 Move to (181,31)
B $D2C1,2,2 Line 63 pixels diagonally down-left, to (118,0)
B $D2C3,3,3 Move to (68,115)
B $D2C6,2,2 Line 63 pixels down, 1 left every 7, to (59,52)
B $D2C8,2,2 Line 24 pixels down, 1 left every 9, to (57,28)
B $D2CA,3,3 Move to (87,101)
B $D2CD,2,2 Line 63 pixels down, 1 left every 7, to (78,38)
B $D2CF,2,2 Line 24 pixels down, 1 left every 7, to (75,14)
B $D2D1,3,3 Move to (51,78)
B $D2D4,2,2 Line 14 pixels left, 1 up every 3, to (37,82)
B $D2D6,2,2 Line 14 pixels diagonally up-left, to (23,96)
B $D2D8,2,2 Line 14 pixels up, 1 left every 2, to (16,110)
B $D2DA,2,2 Line 19 pixels diagonally up-left, to (0,127)
B $D2DC,3,3 Move to (27,117)
B $D2DF,2,2 Line 3 pixels diagonally up-right, to (30,120)
B $D2E1,2,2 Line 3 pixels right, 1 up every 2, to (33,121)
B $D2E3,2,2 Line 3 pixels right, 1 down every 3, to (36,120)
B $D2E5,2,2 Line 3 pixels right, 1 down every 2, to (39,119)
B $D2E7,2,2 Line 3 pixels down, 1 right every 2, to (40,116)
B $D2E9,2,2 Line 3 pixels left, 1 down every 3, to (37,115)
B $D2EB,2,2 Line 3 pixels left, 1 down every 2, to (34,114)
B $D2ED,2,2 Line 3 pixels down, 1 left every 2, to (33,111)
B $D2EF,2,2 Line 3 pixels down, 1 left every 2, to (32,108)
B $D2F1,2,2 Line 3 pixels down, 1 right every 3, to (33,105)
B $D2F3,2,2 Line 3 pixels down, 1 right every 2, to (34,102)
B $D2F5,2,2 Line 3 pixels diagonally down-right, to (37,99)
B $D2F7,2,2 Line 3 pixels left, to (34,99)
B $D2F9,2,2 Line 3 pixels left, 1 up every 3, to (31,100)
B $D2FB,2,2 Line 3 pixels left, 1 up every 2, to (28,101)
B $D2FD,2,2 Line 3 pixels diagonally up-left, to (25,104)
B $D2FF,2,2 Line 3 pixels up, 1 left every 2, to (24,107)
B $D301,2,2 Line 3 pixels up, 1 left every 3, to (23,110)
B $D303,2,2 Line 3 pixels up, 1 right every 3, to (24,113)
B $D305,2,2 Line 3 pixels up, 1 right every 2, to (25,116)
B $D307,2,2 Line 3 pixels diagonally up-right, to (28,119)
B $D309,3,3 Fill from (24,120) in blue
B $D30C,12,12 Paint black paper from cell (0,0): 6 down, 5 right, 1 up, 4 left, 4 up, 1 right, 3 down, 2 right
B $D318,3,3 Move to (0,71)
B $D31B,2,2 Line 52 pixels right, 1 down every 52, to (52,70)
B $D31D,3,3 Fill from (11,69) in black
B $D320,3,3 Move to (48,72)
B $D323,2,2 Line 8 pixels up, 1 left every 5, to (47,80)
B $D325,3,3 Fill from (50,73) in black
B $D328,3,3 Move to (96,88)
B $D32B,2,2 Line 57 pixels up, 1 right every 2, to (124,127)
B $D32D,3,3 Move to (127,70)
B $D330,2,2 Line 57 pixels up, 1 right every 4, to (141,127)
B $D332,3,3 Move to (161,62)
B $D335,2,2 Line 57 pixels up, 1 right every 5, to (172,119)
B $D337,2,2 Line 57 pixels up, 1 right every 5, to (183,127)
B $D339,3,3 Move to (202,47)
B $D33C,2,2 Line 57 pixels up, 1 right every 3, to (221,104)
B $D33E,2,2 Line 57 pixels up, 1 right every 2, to (249,127)
B $D340,3,3 Move to (70,118)
B $D343,2,2 Line 11 pixels up, 1 right every 4, to (72,127)
B $D345,3,3 Move to (83,117)
B $D348,2,2 Line 11 pixels up, 1 right every 5, to (85,127)
B $D34A,3,3 Move to (49,32)
B $D34D,2,2 Line 7 pixels right, 1 down every 2, to (56,29)
B $D34F,2,2 Line 20 pixels right, 1 down every 4, to (76,24)
B $D351,3,3 Move to (76,16)
B $D354,2,2 Line 9 pixels right, 1 down every 4, to (85,14)
B $D356,2,2 Line 17 pixels right, 1 down every 4, to (102,10)
B $D358,2,2 Line 28 pixels right, 1 down every 6, to (130,6)
B $D35A,2,2 Line 13 pixels right, 1 up every 7, to (143,7)
B $D35C,2,2 Line 7 pixels right, 1 down every 2, to (150,4)
B $D35E,2,2 Line 8 pixels down, 1 right every 2, to (154,0)
B $D360,3,3 Fill from (51,13) in black
B $D363,3,3 Fill from (181,0) in red
B $D366,1,1 End of picture
b $D367 Picture: room 37 (?)
D $D367 The picture for room 37 (?). It is 590 bytes long: 187 lines, 56 moves, 15 fills and 0 painted areas. See #R$8985 for the format.
D $D367 #HTML[<img src="../images/pictures/room37.png" alt="room 37">]
B $D367,2,2 Border white, picture area black ink on white paper
B $D369,3,3 Move to (91,43)
B $D36C,2,2 Line 21 pixels up, 1 left every 5, to (87,64)
B $D36E,2,2 Line 12 pixels up, 1 left every 3, to (83,76)
B $D370,2,2 Line 18 pixels up, 1 right every 18, to (84,94)
B $D372,2,2 Line 7 pixels diagonally up-right, to (91,101)
B $D374,2,2 Line 8 pixels up, to (91,109)
B $D376,2,2 Line 4 pixels right, to (95,109)
B $D378,2,2 Line 12 pixels down, 1 left every 11, to (94,97)
B $D37A,2,2 Line 6 pixels diagonally down-left, to (88,91)
B $D37C,2,2 Line 15 pixels down, 1 right every 15, to (89,76)
B $D37E,2,2 Line 34 pixels down, 1 right every 3, to (100,42)
B $D380,2,2 Line 10 pixels left, 1 down every 10, to (90,41)
B $D382,3,3 Fill from (95,46) in black
B $D385,3,3 Move to (82,86)
B $D388,2,2 Line 10 pixels left, 1 up every 3, to (72,89)
B $D38A,2,2 Line 13 pixels up, 1 left every 2, to (66,102)
B $D38C,2,2 Line 4 pixels down, 1 left every 2, to (64,98)
B $D38E,2,2 Line 16 pixels down, 1 right every 2, to (72,82)
B $D390,2,2 Line 11 pixels right, 1 down every 4, to (83,80)
B $D392,3,3 Fill from (80,82) in black
B $D395,3,3 Move to (96,57)
B $D398,2,2 Line 10 pixels diagonally up-right, to (106,67)
B $D39A,2,2 Line 7 pixels up, 1 left every 3, to (104,74)
B $D39C,2,2 Line 3 pixels right, 1 down every 3, to (107,73)
B $D39E,2,2 Line 7 pixels down, 1 right every 3, to (109,66)
B $D3A0,2,2 Line 13 pixels diagonally down-left, to (96,53)
B $D3A2,3,3 Fill from (97,56) in black
B $D3A5,3,3 Move to (195,75)
B $D3A8,2,2 Line 12 pixels up, 1 right every 12, to (196,87)
B $D3AA,2,2 Line 7 pixels right, 1 up every 2, to (203,90)
B $D3AC,2,2 Line 15 pixels up, 1 left every 6, to (201,105)
B $D3AE,2,2 Line 7 pixels left, 1 up every 2, to (194,108)
B $D3B0,2,2 Line 2 pixels diagonally up-right, to (196,110)
B $D3B2,2,2 Line 8 pixels right, 1 down every 2, to (204,106)
B $D3B4,2,2 Line 19 pixels down, 1 right every 8, to (206,87)
B $D3B6,2,2 Line 8 pixels left, 1 down every 2, to (198,83)
B $D3B8,2,2 Line 11 pixels down, 1 left every 11, to (197,72)
B $D3BA,2,2 Line 3 pixels diagonally up-left, to (194,75)
B $D3BC,3,3 Move to (194,85)
B $D3BF,2,2 Line 15 pixels left, 1 up every 2, to (179,92)
B $D3C1,3,3 Move to (179,93)
B $D3C4,2,2 Line 18 pixels right, 1 down every 3, to (197,87)
B $D3C6,3,3 Move to (188,87)
B $D3C9,2,2 Line 10 pixels left, 1 down every 4, to (178,85)
B $D3CB,3,3 Move to (188,86)
B $D3CE,2,2 Line 10 pixels left, 1 down every 4, to (178,84)
B $D3D0,3,3 Move to (201,98)
B $D3D3,2,2 Line 10 pixels left, 1 up every 2, to (191,103)
B $D3D5,3,3 Move to (201,97)
B $D3D8,2,2 Line 10 pixels left, 1 up every 2, to (191,102)
B $D3DA,3,3 Fill from (201,87) in black
B $D3DD,3,3 Fill from (193,87) in black
B $D3E0,3,3 Fill from (183,91) in black
B $D3E3,3,3 Move to (181,92)
B $D3E6,2,2 Line 1 pixels diagonally up-left, to (180,93)
B $D3E8,3,3 Move to (205,101)
B $D3EB,2,2 Line 6 pixels diagonally up-right, to (211,107)
B $D3ED,3,3 Move to (201,108)
B $D3F0,2,2 Line 4 pixels up, 1 right every 2, to (203,112)
B $D3F2,3,3 Move to (189,90)
B $D3F5,2,2 Line 5 pixels up, 1 right every 4, to (190,95)
B $D3F7,2,2 Line 7 pixels up, 1 left every 2, to (187,102)
B $D3F9,3,3 Move to (126,48)
B $D3FC,2,2 Line 11 pixels left, 1 up every 5, to (115,50)
B $D3FE,2,2 Line 3 pixels diagonally up-right, to (118,53)
B $D400,2,2 Line 10 pixels right, 1 down every 3, to (128,50)
B $D402,2,2 Line 3 pixels down, 1 left every 2, to (127,47)
B $D404,3,3 Fill from (119,51) in black
B $D407,3,3 Move to (118,26)
B $D40A,2,2 Line 7 pixels left, to (111,26)
B $D40C,2,2 Line 5 pixels left, 1 up every 2, to (106,28)
B $D40E,2,2 Line 3 pixels diagonally up-left, to (103,31)
B $D410,2,2 Line 7 pixels down, 1 right every 3, to (105,24)
B $D412,2,2 Line 7 pixels right, 1 down every 4, to (112,23)
B $D414,2,2 Line 7 pixels right, 1 down every 7, to (119,22)
B $D416,2,2 Line 3 pixels diagonally down-right, to (122,19)
B $D418,2,2 Line 5 pixels right, 1 up every 3, to (127,20)
B $D41A,2,2 Line 8 pixels right, 1 down every 2, to (135,16)
B $D41C,2,2 Line 4 pixels diagonally up-right, to (139,20)
B $D41E,2,2 Line 5 pixels diagonally up-left, to (134,25)
B $D420,2,2 Line 4 pixels up, 1 left every 4, to (133,29)
B $D422,2,2 Line 4 pixels diagonally up-left, to (129,33)
B $D424,2,2 Line 4 pixels left, to (125,33)
B $D426,2,2 Line 4 pixels diagonally down-left, to (121,29)
B $D428,2,2 Line 4 pixels diagonally down-left, to (117,25)
B $D42A,3,3 Move to (126,34)
B $D42D,2,2 Line 4 pixels up, 1 left every 4, to (125,38)
B $D42F,2,2 Line 4 pixels up, 1 left every 3, to (124,42)
B $D431,2,2 Line 4 pixels diagonally up-left, to (120,46)
B $D433,2,2 Line 3 pixels right, 1 down every 3, to (123,45)
B $D435,2,2 Line 4 pixels right, 1 down every 2, to (127,43)
B $D437,2,2 Line 4 pixels down, 1 right every 2, to (129,39)
B $D439,2,2 Line 4 pixels down, to (129,35)
B $D43B,2,2 Line 3 pixels down, 1 right every 3, to (130,32)
B $D43D,3,3 Move to (116,22)
B $D440,2,2 Line 3 pixels down, 1 left every 3, to (115,19)
B $D442,2,2 Line 4 pixels diagonally down-right, to (119,15)
B $D444,2,2 Line 4 pixels right, 1 down every 4, to (123,14)
B $D446,2,2 Line 4 pixels right, to (127,14)
B $D448,2,2 Line 4 pixels right, 1 up every 4, to (131,15)
B $D44A,2,2 Line 4 pixels right, 1 up every 4, to (135,16)
B $D44C,2,2 Line 3 pixels right, 1 up every 3, to (138,17)
B $D44E,2,2 Line 2 pixels left, 1 up every 2, to (136,18)
B $D450,3,3 Fill from (128,17) in black
B $D453,3,3 Move to (115,18)
B $D456,2,2 Line 13 pixels left, 1 up every 10, to (102,19)
B $D458,3,3 Move to (115,19)
B $D45B,2,2 Line 13 pixels left, 1 up every 10, to (102,20)
B $D45D,3,3 Move to (130,28)
B $D460,2,2 Line 4 pixels left, 1 up every 3, to (126,29)
B $D462,3,3 Move to (129,27)
B $D465,2,2 Line 4 pixels left, 1 up every 2, to (125,29)
B $D467,3,3 Move to (129,26)
B $D46A,2,2 Line 4 pixels left, 1 up every 2, to (125,28)
B $D46C,3,3 Move to (123,22)
B $D46F,2,2 Line 3 pixels left, 1 up every 2, to (120,23)
B $D471,3,3 Move to (124,23)
B $D474,2,2 Line 3 pixels left, 1 up every 2, to (121,24)
B $D476,3,3 Move to (122,23)
B $D479,2,2 Line 1 pixels diagonally up-left, to (121,24)
B $D47B,3,3 Move to (118,26)
B $D47E,2,2 Line 4 pixels down, 1 left every 4, to (117,22)
B $D480,3,3 Move to (0,108)
B $D483,2,2 Line 12 pixels right, 1 down every 7, to (12,107)
B $D485,2,2 Line 12 pixels right, 1 down every 2, to (24,101)
B $D487,2,2 Line 28 pixels right, 1 down every 6, to (52,97)
B $D489,2,2 Line 28 pixels right, 1 down every 13, to (80,95)
B $D48B,2,2 Line 28 pixels right, 1 down every 2, to (108,81)
B $D48D,2,2 Line 12 pixels right, 1 down every 2, to (120,75)
B $D48F,3,3 Move to (108,81)
B $D492,2,2 Line 24 pixels right, 1 up every 5, to (132,85)
B $D494,2,2 Line 9 pixels up, 1 right every 3, to (135,94)
B $D496,2,2 Line 24 pixels right, 1 up every 5, to (159,98)
B $D498,2,2 Line 13 pixels right, 1 up every 2, to (172,104)
B $D49A,2,2 Line 13 pixels right, 1 up every 6, to (185,106)
B $D49C,2,2 Line 52 pixels right, 1 down every 5, to (237,96)
B $D49E,2,2 Line 52 pixels right, 1 down every 3, to (255,79)
B $D4A0,3,3 Move to (0,67)
B $D4A3,2,2 Line 52 pixels right, 1 down every 19, to (52,65)
B $D4A5,2,2 Line 52 pixels right, 1 up every 10, to (104,70)
B $D4A7,2,2 Line 52 pixels right, 1 up every 13, to (156,74)
B $D4A9,2,2 Line 52 pixels right, 1 up every 22, to (208,76)
B $D4AB,2,2 Line 52 pixels right, 1 down every 10, to (255,71)
B $D4AD,3,3 Move to (130,0)
B $D4B0,2,2 Line 48 pixels right, 1 up every 8, to (178,6)
B $D4B2,2,2 Line 37 pixels right, to (215,6)
B $D4B4,2,2 Line 20 pixels right, 1 up every 4, to (235,11)
B $D4B6,2,2 Line 22 pixels right, 1 up every 11, to (255,13)
B $D4B8,3,3 Move to (65,0)
B $D4BB,2,2 Line 63 pixels right, 1 up every 7, to (128,9)
B $D4BD,2,2 Line 63 pixels right, 1 up every 6, to (191,19)
B $D4BF,2,2 Line 63 pixels right, 1 up every 10, to (254,25)
B $D4C1,2,2 Line 63 pixels right, 1 up every 10, to (255,31)
B $D4C3,3,3 Move to (104,0)
B $D4C6,2,2 Line 63 pixels right, 1 up every 8, to (167,7)
B $D4C8,2,2 Line 63 pixels right, 1 up every 9, to (230,14)
B $D4CA,2,2 Line 63 pixels right, 1 up every 9, to (255,21)
B $D4CC,3,3 Fill from (219,9) in black
B $D4CF,3,3 Move to (238,15)
B $D4D2,2,2 Line 8 pixels up, 1 left every 3, to (236,23)
B $D4D4,2,2 Line 10 pixels left, 1 up every 2, to (226,28)
B $D4D6,2,2 Line 6 pixels up, 1 right every 2, to (229,34)
B $D4D8,2,2 Line 30 pixels left, 1 up every 3, to (199,44)
B $D4DA,2,2 Line 30 pixels left, 1 up every 6, to (169,49)
B $D4DC,2,2 Line 4 pixels right, 1 up every 3, to (173,50)
B $D4DE,2,2 Line 25 pixels right, 1 down every 9, to (198,48)
B $D4E0,2,2 Line 39 pixels right, 1 down every 4, to (237,39)
B $D4E2,2,2 Line 8 pixels down, 1 left every 3, to (235,31)
B $D4E4,2,2 Line 14 pixels right, 1 down every 2, to (249,24)
B $D4E6,2,2 Line 8 pixels down, 1 right every 3, to (251,16)
B $D4E8,3,3 Move to (170,49)
B $D4EB,2,2 Line 23 pixels left, 1 up every 6, to (147,52)
B $D4ED,2,2 Line 25 pixels right, 1 down every 9, to (172,50)
B $D4EF,3,3 Move to (187,10)
B $D4F2,2,2 Line 9 pixels up, 1 left every 3, to (184,19)
B $D4F4,2,2 Line 25 pixels left, 1 up every 4, to (159,25)
B $D4F6,2,2 Line 9 pixels up, 1 left every 5, to (158,34)
B $D4F8,2,2 Line 14 pixels right, 1 up every 3, to (172,38)
B $D4FA,2,2 Line 10 pixels up, 1 right every 9, to (173,48)
B $D4FC,2,2 Line 10 pixels down, 1 right every 10, to (174,38)
B $D4FE,2,2 Line 12 pixels left, 1 down every 2, to (162,32)
B $D500,2,2 Line 5 pixels down, 1 right every 3, to (163,27)
B $D502,2,2 Line 37 pixels right, 1 down every 5, to (200,20)
B $D504,2,2 Line 10 pixels down, 1 right every 4, to (202,10)
B $D506,3,3 Move to (170,37)
B $D509,2,2 Line 1 pixels diagonally down-right, to (171,36)
B $D50B,3,3 Move to (162,35)
B $D50E,2,2 Line 11 pixels left, 1 up every 2, to (151,40)
B $D510,3,3 Move to (155,8)
B $D513,2,2 Line 5 pixels up, 1 left every 3, to (154,13)
B $D515,3,3 Move to (125,2)
B $D518,2,2 Line 6 pixels up, 1 left every 3, to (123,8)
B $D51A,3,3 Move to (154,12)
B $D51D,2,2 Line 10 pixels left, 1 up every 2, to (144,17)
B $D51F,2,2 Line 10 pixels up, 1 left every 5, to (142,27)
B $D521,2,2 Line 10 pixels up, 1 left every 3, to (139,37)
B $D523,2,2 Line 10 pixels left, 1 up every 3, to (129,40)
B $D525,3,3 Move to (139,37)
B $D528,2,2 Line 10 pixels up, 1 left every 8, to (138,47)
B $D52A,3,3 Move to (145,24)
B $D52D,2,2 Line 10 pixels diagonally up-right, to (155,34)
B $D52F,3,3 Move to (125,8)
B $D532,2,2 Line 10 pixels right, 1 up every 2, to (135,13)
B $D534,2,2 Line 10 pixels diagonally up-right, to (145,23)
B $D536,3,3 Move to (127,9)
B $D539,2,2 Line 10 pixels up, 1 right every 7, to (128,19)
B $D53B,3,3 Move to (105,6)
B $D53E,2,2 Line 10 pixels left, 1 up every 2, to (95,11)
B $D540,2,2 Line 10 pixels diagonally up-left, to (85,21)
B $D542,2,2 Line 10 pixels up, 1 left every 7, to (84,31)
B $D544,2,2 Line 10 pixels left, 1 up every 4, to (74,33)
B $D546,3,3 Move to (84,22)
B $D549,2,2 Line 10 pixels left, to (74,22)
B $D54B,3,3 Move to (95,22)
B $D54E,2,2 Line 10 pixels up, 1 right every 3, to (98,32)
B $D550,2,2 Line 10 pixels right, 1 up every 3, to (108,35)
B $D552,2,2 Line 10 pixels up, 1 right every 3, to (111,45)
B $D554,2,2 Line 10 pixels right, 1 up every 4, to (121,47)
B $D556,3,3 Move to (109,36)
B $D559,2,2 Line 10 pixels right, 1 down every 5, to (119,34)
B $D55B,3,3 Move to (92,12)
B $D55E,2,2 Line 10 pixels left, 1 down every 2, to (82,7)
B $D560,2,2 Line 10 pixels diagonally up-left, to (72,17)
B $D562,2,2 Line 10 pixels left, 1 up every 5, to (62,19)
B $D564,3,3 Move to (113,113)
B $D567,2,2 Line 5 pixels up, 1 right every 5, to (114,118)
B $D569,2,2 Line 3 pixels up, 1 right every 2, to (115,121)
B $D56B,2,2 Line 3 pixels diagonally up-right, to (118,124)
B $D56D,2,2 Line 3 pixels right, 1 up every 2, to (121,125)
B $D56F,2,2 Line 3 pixels right, 1 up every 2, to (124,126)
B $D571,3,3 Move to (114,112)
B $D574,2,2 Line 3 pixels down, 1 right every 3, to (115,109)
B $D576,2,2 Line 3 pixels down, 1 right every 2, to (116,106)
B $D578,2,2 Line 3 pixels right, 1 down every 2, to (119,105)
B $D57A,2,2 Line 3 pixels right, 1 down every 3, to (122,104)
B $D57C,2,2 Line 3 pixels right, 1 down every 3, to (125,103)
B $D57E,3,3 Move to (124,126)
B $D581,2,2 Line 3 pixels right, 1 down every 3, to (127,125)
B $D583,3,3 Move to (136,114)
B $D586,2,2 Line 4 pixels up, 1 left every 4, to (135,118)
B $D588,2,2 Line 3 pixels up, 1 left every 3, to (134,121)
B $D58A,2,2 Line 3 pixels diagonally up-left, to (131,124)
B $D58C,2,2 Line 3 pixels left, 1 up every 2, to (128,125)
B $D58E,2,2 Line 3 pixels left, 1 up every 2, to (125,126)
B $D590,3,3 Move to (136,113)
B $D593,2,2 Line 3 pixels down, 1 left every 2, to (135,110)
B $D595,2,2 Line 3 pixels down, 1 left every 2, to (134,107)
B $D597,2,2 Line 3 pixels left, 1 down every 2, to (131,106)
B $D599,2,2 Line 3 pixels left, 1 down every 3, to (128,105)
B $D59B,2,2 Line 4 pixels left, 1 down every 3, to (124,104)
B $D59D,3,3 Fill from (123,110) in yellow
B $D5A0,3,3 Fill from (217,41) in red
B $D5A3,3,3 Fill from (242,18) in red
B $D5A6,3,3 Fill from (168,36) in black
B $D5A9,3,3 Move to (168,36)
B $D5AC,2,2 Line 3 pixels left, 1 down every 2, to (165,35)
B $D5AE,3,3 Fill from (168,25) in black
B $D5B1,3,3 Fill from (192,13) in black
B $D5B4,1,1 End of picture
b $D5B5 Picture: room 43 (?)
D $D5B5 The picture for room 43 (?). It is 350 bytes long: 142 lines, 20 moves, 1 fills and 0 painted areas. See #R$8985 for the format.
D $D5B5 #HTML[<img src="../images/pictures/room43.png" alt="room 43">]
B $D5B5,2,2 Border blue, picture area black ink on green paper
B $D5B7,3,3 Move to (112,55)
B $D5BA,2,2 Line 3 pixels up, 1 right every 3, to (113,58)
B $D5BC,2,2 Line 3 pixels up, 1 right every 2, to (114,61)
B $D5BE,2,2 Line 3 pixels diagonally up-right, to (117,64)
B $D5C0,2,2 Line 3 pixels right, 1 up every 2, to (120,65)
B $D5C2,2,2 Line 3 pixels right, 1 up every 3, to (123,66)
B $D5C4,2,2 Line 3 pixels right, to (126,66)
B $D5C6,3,3 Move to (139,55)
B $D5C9,2,2 Line 3 pixels up, 1 left every 3, to (138,58)
B $D5CB,2,2 Line 3 pixels up, 1 left every 2, to (137,61)
B $D5CD,2,2 Line 3 pixels diagonally up-left, to (134,64)
B $D5CF,2,2 Line 3 pixels left, 1 up every 2, to (131,65)
B $D5D1,2,2 Line 3 pixels left, 1 up every 3, to (128,66)
B $D5D3,2,2 Line 3 pixels left, to (125,66)
B $D5D5,3,3 Move to (112,54)
B $D5D8,2,2 Line 3 pixels down, 1 right every 3, to (113,51)
B $D5DA,2,2 Line 3 pixels down, 1 right every 2, to (114,48)
B $D5DC,2,2 Line 3 pixels diagonally down-right, to (117,45)
B $D5DE,2,2 Line 3 pixels right, 1 down every 2, to (120,44)
B $D5E0,2,2 Line 3 pixels right, 1 down every 3, to (123,43)
B $D5E2,2,2 Line 3 pixels right, to (126,43)
B $D5E4,3,3 Move to (139,54)
B $D5E7,2,2 Line 3 pixels down, 1 left every 3, to (138,51)
B $D5E9,2,2 Line 3 pixels down, 1 left every 2, to (137,48)
B $D5EB,2,2 Line 3 pixels diagonally down-left, to (134,45)
B $D5ED,2,2 Line 3 pixels left, 1 down every 2, to (131,44)
B $D5EF,2,2 Line 3 pixels left, 1 down every 3, to (128,43)
B $D5F1,2,2 Line 3 pixels left, to (125,43)
B $D5F3,3,3 Move to (101,65)
B $D5F6,2,2 Line 8 pixels up, 1 right every 8, to (102,73)
B $D5F8,2,2 Line 8 pixels up, 1 right every 3, to (104,81)
B $D5FA,2,2 Line 5 pixels diagonally up-right, to (109,86)
B $D5FC,2,2 Line 5 pixels right, 1 up every 2, to (114,88)
B $D5FE,2,2 Line 5 pixels right, 1 up every 3, to (119,89)
B $D600,2,2 Line 5 pixels right, 1 up every 3, to (124,90)
B $D602,2,2 Line 5 pixels right, 1 up every 4, to (129,91)
B $D604,2,2 Line 5 pixels right, 1 up every 5, to (134,92)
B $D606,3,3 Move to (160,65)
B $D609,2,2 Line 8 pixels up, 1 left every 8, to (159,73)
B $D60B,2,2 Line 8 pixels up, 1 left every 3, to (157,81)
B $D60D,2,2 Line 5 pixels diagonally up-left, to (152,86)
B $D60F,2,2 Line 5 pixels left, 1 up every 2, to (147,88)
B $D611,2,2 Line 5 pixels left, 1 up every 3, to (142,89)
B $D613,2,2 Line 5 pixels left, 1 up every 3, to (137,90)
B $D615,2,2 Line 5 pixels left, 1 up every 3, to (132,91)
B $D617,3,3 Move to (101,64)
B $D61A,2,2 Line 9 pixels down, 1 right every 9, to (102,55)
B $D61C,2,2 Line 9 pixels down, 1 right every 3, to (105,46)
B $D61E,2,2 Line 6 pixels diagonally down-right, to (111,40)
B $D620,2,2 Line 4 pixels right, 1 down every 2, to (115,38)
B $D622,3,3 Move to (160,64)
B $D625,2,2 Line 10 pixels down, 1 left every 10, to (159,54)
B $D627,2,2 Line 9 pixels down, 1 left every 3, to (156,45)
B $D629,2,2 Line 6 pixels diagonally down-left, to (150,39)
B $D62B,2,2 Line 7 pixels left, 1 down every 2, to (143,36)
B $D62D,2,2 Line 11 pixels left, 1 down every 6, to (132,35)
B $D62F,3,3 Move to (66,64)
B $D632,2,2 Line 12 pixels up, 1 right every 12, to (67,76)
B $D634,2,2 Line 10 pixels up, 1 right every 4, to (69,86)
B $D636,2,2 Line 10 pixels up, 1 right every 2, to (74,96)
B $D638,2,2 Line 10 pixels diagonally up-right, to (84,106)
B $D63A,2,2 Line 10 pixels right, 1 up every 2, to (94,111)
B $D63C,2,2 Line 10 pixels right, 1 up every 3, to (104,114)
B $D63E,2,2 Line 10 pixels right, 1 up every 4, to (114,116)
B $D640,2,2 Line 10 pixels right, 1 up every 5, to (124,118)
B $D642,2,2 Line 10 pixels right, to (134,118)
B $D644,3,3 Move to (195,63)
B $D647,2,2 Line 13 pixels up, 1 left every 13, to (194,76)
B $D649,2,2 Line 12 pixels up, 1 left every 4, to (191,88)
B $D64B,2,2 Line 10 pixels up, 1 left every 2, to (186,98)
B $D64D,2,2 Line 9 pixels diagonally up-left, to (177,107)
B $D64F,2,2 Line 9 pixels left, 1 up every 2, to (168,111)
B $D651,2,2 Line 9 pixels left, 1 up every 3, to (159,114)
B $D653,2,2 Line 9 pixels left, 1 up every 4, to (150,116)
B $D655,2,2 Line 9 pixels left, 1 up every 5, to (141,117)
B $D657,2,2 Line 9 pixels left, 1 up every 5, to (132,118)
B $D659,3,3 Move to (66,63)
B $D65C,2,2 Line 9 pixels down, 1 right every 9, to (67,54)
B $D65E,2,2 Line 9 pixels down, 1 right every 4, to (69,45)
B $D660,2,2 Line 9 pixels down, 1 right every 2, to (73,36)
B $D662,2,2 Line 9 pixels diagonally down-right, to (82,27)
B $D664,2,2 Line 4 pixels right, 1 down every 2, to (86,25)
B $D666,3,3 Move to (195,62)
B $D669,2,2 Line 9 pixels down, 1 left every 9, to (194,53)
B $D66B,2,2 Line 9 pixels down, 1 left every 3, to (191,44)
B $D66D,2,2 Line 9 pixels down, 1 left every 2, to (187,35)
B $D66F,2,2 Line 9 pixels diagonally down-left, to (178,26)
B $D671,2,2 Line 9 pixels left, 1 down every 2, to (169,22)
B $D673,2,2 Line 9 pixels left, 1 down every 3, to (160,19)
B $D675,2,2 Line 6 pixels left, 1 down every 4, to (154,18)
B $D677,3,3 Move to (19,65)
B $D67A,2,2 Line 9 pixels up, to (19,74)
B $D67C,2,2 Line 9 pixels up, 1 right every 4, to (21,83)
B $D67E,2,2 Line 9 pixels up, 1 right every 2, to (25,92)
B $D680,2,2 Line 9 pixels up, 1 right every 2, to (29,101)
B $D682,2,2 Line 9 pixels diagonally up-right, to (38,110)
B $D684,2,2 Line 9 pixels right, 1 up every 2, to (47,114)
B $D686,2,2 Line 9 pixels right, 1 up every 2, to (56,118)
B $D688,2,2 Line 9 pixels right, 1 up every 3, to (65,121)
B $D68A,2,2 Line 9 pixels right, 1 up every 4, to (74,123)
B $D68C,2,2 Line 9 pixels right, 1 up every 4, to (83,125)
B $D68E,2,2 Line 9 pixels right, 1 up every 5, to (92,126)
B $D690,2,2 Line 9 pixels right, 1 up every 5, to (101,127)
B $D692,3,3 Move to (240,65)
B $D695,2,2 Line 9 pixels up, to (240,74)
B $D697,2,2 Line 9 pixels up, 1 left every 4, to (238,83)
B $D699,2,2 Line 9 pixels up, 1 left every 2, to (234,92)
B $D69B,2,2 Line 9 pixels up, 1 left every 2, to (230,101)
B $D69D,2,2 Line 9 pixels diagonally up-left, to (221,110)
B $D69F,2,2 Line 9 pixels left, 1 up every 2, to (212,114)
B $D6A1,2,2 Line 9 pixels left, 1 up every 2, to (203,118)
B $D6A3,2,2 Line 9 pixels left, 1 up every 3, to (194,121)
B $D6A5,2,2 Line 9 pixels left, 1 up every 4, to (185,123)
B $D6A7,2,2 Line 9 pixels left, 1 up every 5, to (176,124)
B $D6A9,2,2 Line 9 pixels left, 1 up every 6, to (167,125)
B $D6AB,2,2 Line 9 pixels left, 1 up every 6, to (158,126)
B $D6AD,2,2 Line 9 pixels left, 1 up every 6, to (149,127)
B $D6AF,3,3 Move to (19,64)
B $D6B2,2,2 Line 9 pixels down, 1 right every 8, to (20,55)
B $D6B4,2,2 Line 9 pixels down, 1 right every 5, to (21,46)
B $D6B6,2,2 Line 9 pixels down, 1 right every 3, to (24,37)
B $D6B8,2,2 Line 9 pixels down, 1 right every 2, to (28,28)
B $D6BA,2,2 Line 17 pixels diagonally down-right, to (45,11)
B $D6BC,3,3 Move to (240,64)
B $D6BF,2,2 Line 9 pixels down, 1 left every 6, to (239,55)
B $D6C1,2,2 Line 9 pixels down, 1 left every 5, to (238,46)
B $D6C3,2,2 Line 9 pixels down, 1 left every 3, to (235,37)
B $D6C5,2,2 Line 9 pixels down, 1 left every 2, to (231,28)
B $D6C7,2,2 Line 9 pixels diagonally down-left, to (222,19)
B $D6C9,2,2 Line 9 pixels left, 1 down every 2, to (213,15)
B $D6CB,2,2 Line 9 pixels left, 1 down every 2, to (204,11)
B $D6CD,2,2 Line 9 pixels left, 1 down every 3, to (195,8)
B $D6CF,2,2 Line 9 pixels left, 1 down every 3, to (186,5)
B $D6D1,2,2 Line 5 pixels left, 1 down every 5, to (181,4)
B $D6D3,3,3 Move to (113,55)
B $D6D6,2,2 Line 3 pixels diagonally up-right, to (116,58)
B $D6D8,2,2 Line 3 pixels right, 1 up every 2, to (119,59)
B $D6DA,2,2 Line 3 pixels right, 1 up every 3, to (122,60)
B $D6DC,2,2 Line 3 pixels right, 1 down every 2, to (125,59)
B $D6DE,2,2 Line 3 pixels diagonally down-right, to (128,56)
B $D6E0,2,2 Line 3 pixels down, 1 right every 2, to (129,53)
B $D6E2,2,2 Line 3 pixels down, 1 right every 3, to (130,50)
B $D6E4,2,2 Line 3 pixels down, 1 left every 2, to (129,47)
B $D6E6,2,2 Line 3 pixels diagonally down-left, to (126,44)
B $D6E8,3,3 Move to (7,0)
B $D6EB,2,2 Line 63 pixels right, 1 up every 3, to (70,21)
B $D6ED,2,2 Line 17 pixels right, 1 up every 3, to (87,26)
B $D6EF,2,2 Line 28 pixels right, 1 up every 2, to (115,40)
B $D6F1,2,2 Line 4 pixels diagonally up-right, to (119,44)
B $D6F3,3,3 Move to (193,0)
B $D6F6,2,2 Line 37 pixels left, 1 up every 2, to (156,18)
B $D6F8,2,2 Line 14 pixels left, 1 up every 2, to (142,25)
B $D6FA,2,2 Line 10 pixels diagonally up-left, to (132,35)
B $D6FC,2,2 Line 8 pixels diagonally up-left, to (124,43)
B $D6FE,3,3 Move to (114,49)
B $D701,2,2 Line 4 pixels up, 1 right every 2, to (116,53)
B $D703,2,2 Line 2 pixels right, 1 up every 2, to (118,54)
B $D705,2,2 Line 2 pixels right, 1 down every 2, to (120,53)
B $D707,2,2 Line 2 pixels diagonally down-right, to (122,51)
B $D709,2,2 Line 2 pixels down, to (122,49)
B $D70B,2,2 Line 2 pixels down, to (122,47)
B $D70D,2,2 Line 3 pixels diagonally down-left, to (119,44)
B $D70F,3,3 Fill from (116,51) in black
B $D712,1,1 End of picture
b $D713 Picture: room 38 (?)
D $D713 The picture for room 38 (?). It is 535 bytes long: 150 lines, 63 moves, 6 fills and 2 painted areas. See #R$8985 for the format.
D $D713 #HTML[<img src="../images/pictures/room38.png" alt="room 38">]
B $D713,2,2 Border cyan, picture area black ink on cyan paper
B $D715,3,3 Move to (255,14)
B $D718,2,2 Line 19 pixels left, 1 up every 4, to (236,18)
B $D71A,2,2 Line 15 pixels left, 1 up every 5, to (221,21)
B $D71C,2,2 Line 15 pixels left, 1 up every 5, to (206,24)
B $D71E,2,2 Line 15 pixels left, 1 up every 6, to (191,26)
B $D720,2,2 Line 13 pixels left, 1 up every 6, to (178,28)
B $D722,2,2 Line 33 pixels up, 1 left every 6, to (173,61)
B $D724,2,2 Line 7 pixels left, 1 up every 6, to (166,62)
B $D726,2,2 Line 8 pixels down, 1 left every 4, to (164,54)
B $D728,2,2 Line 3 pixels diagonally up-left, to (161,57)
B $D72A,2,2 Line 10 pixels left, 1 down every 5, to (151,55)
B $D72C,2,2 Line 9 pixels left, 1 down every 3, to (142,52)
B $D72E,2,2 Line 17 pixels down, 1 left every 7, to (140,35)
B $D730,2,2 Line 11 pixels left, 1 up every 4, to (129,37)
B $D732,2,2 Line 30 pixels up, 1 left every 10, to (126,67)
B $D734,2,2 Line 4 pixels left, 1 down every 3, to (122,66)
B $D736,2,2 Line 19 pixels down, 1 left every 4, to (118,47)
B $D738,2,2 Line 25 pixels left, 1 up every 11, to (93,49)
B $D73A,2,2 Line 4 pixels down, 1 left every 4, to (92,45)
B $D73C,2,2 Line 11 pixels left, 1 up every 3, to (81,48)
B $D73E,2,2 Line 10 pixels up, to (81,58)
B $D740,2,2 Line 6 pixels left, to (75,58)
B $D742,2,2 Line 13 pixels down, 1 right every 13, to (76,45)
B $D744,2,2 Line 8 pixels down, 1 right every 8, to (77,37)
B $D746,3,3 Move to (76,38)
B $D749,2,2 Line 31 pixels left, 1 up every 31, to (45,39)
B $D74B,2,2 Line 26 pixels up, 1 left every 13, to (43,65)
B $D74D,2,2 Line 4 pixels left, 1 up every 3, to (39,66)
B $D74F,2,2 Line 19 pixels up, 1 right every 19, to (40,85)
B $D751,3,3 Move to (39,85)
B $D754,2,2 Line 6 pixels left, 1 down every 2, to (33,82)
B $D756,2,2 Line 27 pixels down, 1 left every 10, to (31,55)
B $D758,2,2 Line 27 pixels left, 1 down every 5, to (4,50)
B $D75A,2,2 Line 27 pixels down, 1 left every 2, to (0,23)
B $D75C,3,3 Move to (0,19)
B $D75F,2,2 Line 27 pixels right, 1 up every 5, to (27,24)
B $D761,2,2 Line 13 pixels right, 1 up every 6, to (40,26)
B $D763,2,2 Line 13 pixels left, 1 down every 2, to (27,20)
B $D765,2,2 Line 13 pixels left, 1 down every 3, to (14,16)
B $D767,2,2 Line 13 pixels left, 1 down every 3, to (1,12)
B $D769,3,3 Move to (1,11)
B $D76C,2,2 Line 13 pixels right, 1 up every 3, to (14,15)
B $D76E,2,2 Line 4 pixels down, 1 right every 4, to (15,11)
B $D770,2,2 Line 48 pixels right, 1 up every 4, to (63,23)
B $D772,2,2 Line 10 pixels right, 1 down every 3, to (73,20)
B $D774,2,2 Line 22 pixels right, 1 up every 9, to (95,22)
B $D776,2,2 Line 8 pixels right, 1 up every 8, to (103,23)
B $D778,2,2 Line 8 pixels up, 1 right every 3, to (105,31)
B $D77A,2,2 Line 20 pixels down, 1 right every 7, to (107,11)
B $D77C,2,2 Line 20 pixels down, 1 right every 7, to (109,0)
B $D77E,3,3 Move to (113,9)
B $D781,2,2 Line 20 pixels right, 1 down every 5, to (133,5)
B $D783,2,2 Line 20 pixels right, 1 down every 10, to (153,3)
B $D785,2,2 Line 20 pixels right, 1 up every 13, to (173,4)
B $D787,2,2 Line 20 pixels right, 1 up every 5, to (193,8)
B $D789,2,2 Line 20 pixels right, 1 down every 3, to (213,2)
B $D78B,2,2 Line 20 pixels right, 1 down every 10, to (233,0)
B $D78D,2,2 Line 20 pixels right, 1 down every 10, to (253,0)
B $D78F,3,3 Move to (114,9)
B $D792,2,2 Line 20 pixels right, 1 up every 4, to (134,14)
B $D794,2,2 Line 20 pixels right, 1 up every 4, to (154,19)
B $D796,2,2 Line 20 pixels right, 1 up every 6, to (174,22)
B $D798,2,2 Line 20 pixels right, 1 down every 18, to (194,21)
B $D79A,2,2 Line 20 pixels right, 1 down every 7, to (214,19)
B $D79C,2,2 Line 20 pixels right, 1 down every 5, to (234,15)
B $D79E,2,2 Line 20 pixels right, 1 down every 5, to (254,11)
B $D7A0,2,2 Line 20 pixels right, 1 down every 5, to (255,7)
B $D7A2,3,3 Fill from (160,33) in black
B $D7A5,13,13 Paint blue paper from cell (23,14): 1 down, 9 left, 1 up, 17 right, 1 down, 7 left, 2 up, 7 left, 12 right
B $D7B2,3,3 Move to (103,21)
B $D7B5,2,2 Line 15 pixels down, 1 left every 8, to (102,6)
B $D7B7,2,2 Line 15 pixels right, 1 down every 6, to (117,4)
B $D7B9,3,3 Move to (90,20)
B $D7BC,2,2 Line 23 pixels left, 1 down every 2, to (67,9)
B $D7BE,2,2 Line 14 pixels up, 1 left every 11, to (66,23)
B $D7C0,2,2 Line 14 pixels down, 1 left every 14, to (65,9)
B $D7C2,3,3 Move to (65,17)
B $D7C5,2,2 Line 14 pixels left, 1 down every 5, to (51,15)
B $D7C7,2,2 Line 14 pixels left, 1 down every 4, to (37,12)
B $D7C9,2,2 Line 14 pixels left, 1 down every 3, to (23,8)
B $D7CB,2,2 Line 14 pixels left, 1 down every 3, to (9,4)
B $D7CD,2,2 Line 14 pixels left, 1 down every 3, to (0,0)
B $D7CF,3,3 Move to (41,4)
B $D7D2,2,2 Line 14 pixels left, 1 down every 3, to (27,0)
B $D7D4,3,3 Move to (58,0)
B $D7D7,2,2 Line 18 pixels left, 1 up every 4, to (40,4)
B $D7D9,3,3 Fill from (60,4) in black
B $D7DC,12,12 Paint blue paper from cell (0,13): 13 right, 1 up, 10 left, 2 down, 4 left, 14 right, 1 down, 14 left
B $D7E8,3,3 Move to (223,93)
B $D7EB,2,2 Line 4 pixels diagonally up-left, to (219,97)
B $D7ED,2,2 Line 5 pixels left, 1 down every 2, to (214,95)
B $D7EF,2,2 Line 6 pixels right, 1 up every 5, to (220,96)
B $D7F1,3,3 Move to (219,96)
B $D7F4,2,2 Line 4 pixels diagonally down-right, to (223,92)
B $D7F6,2,2 Line 6 pixels right, 1 up every 2, to (229,95)
B $D7F8,2,2 Line 4 pixels diagonally down-right, to (233,91)
B $D7FA,3,3 Move to (232,91)
B $D7FD,2,2 Line 4 pixels diagonally up-left, to (228,95)
B $D7FF,3,3 Move to (193,102)
B $D802,2,2 Line 4 pixels diagonally up-left, to (189,106)
B $D804,2,2 Line 4 pixels right, 1 up every 3, to (193,107)
B $D806,2,2 Line 4 pixels right, 1 up every 4, to (197,108)
B $D808,3,3 Move to (196,107)
B $D80B,2,2 Line 8 pixels right, 1 down every 2, to (204,103)
B $D80D,2,2 Line 6 pixels diagonally down-right, to (210,97)
B $D80F,2,2 Line 6 pixels down, 1 right every 3, to (212,91)
B $D811,2,2 Line 6 pixels down, to (212,85)
B $D813,2,2 Line 6 pixels down, 1 left every 4, to (211,79)
B $D815,2,2 Line 6 pixels diagonally down-left, to (205,73)
B $D817,2,2 Line 6 pixels left, 1 down every 2, to (199,70)
B $D819,2,2 Line 6 pixels left, 1 down every 3, to (193,68)
B $D81B,3,3 Move to (193,69)
B $D81E,2,2 Line 6 pixels diagonally up-right, to (199,75)
B $D820,2,2 Line 6 pixels up, 1 right every 2, to (202,81)
B $D822,2,2 Line 6 pixels up, 1 right every 6, to (203,87)
B $D824,3,3 Move to (202,87)
B $D827,2,2 Line 6 pixels up, 1 left every 3, to (200,93)
B $D829,2,2 Line 6 pixels up, 1 left every 2, to (197,99)
B $D82B,2,2 Line 4 pixels diagonally up-left, to (193,103)
B $D82D,3,3 Fill from (197,103) in yellow
B $D830,3,3 Move to (192,27)
B $D833,2,2 Line 16 pixels diagonally up-left, to (176,43)
B $D835,3,3 Move to (193,27)
B $D838,2,2 Line 17 pixels diagonally up-left, to (176,44)
B $D83A,3,3 Move to (195,26)
B $D83D,2,2 Line 20 pixels diagonally up-left, to (175,46)
B $D83F,3,3 Move to (148,55)
B $D842,2,2 Line 20 pixels up, to (148,75)
B $D844,3,3 Move to (139,35)
B $D847,2,2 Line 10 pixels diagonally up-left, to (129,45)
B $D849,3,3 Move to (139,36)
B $D84C,2,2 Line 10 pixels diagonally up-left, to (129,46)
B $D84E,3,3 Move to (143,14)
B $D851,2,2 Line 63 pixels right, 1 up every 11, to (206,19)
B $D853,3,3 Move to (70,38)
B $D856,2,2 Line 25 pixels up, 1 left every 25, to (69,63)
B $D858,2,2 Line 4 pixels left, 1 up every 3, to (65,64)
B $D85A,2,2 Line 18 pixels down, 1 left every 8, to (63,46)
B $D85C,2,2 Line 13 pixels up, 1 left every 2, to (57,59)
B $D85E,3,3 Move to (57,58)
B $D861,2,2 Line 3 pixels diagonally down-left, to (54,55)
B $D863,2,2 Line 17 pixels down, 1 right every 3, to (59,38)
B $D865,3,3 Fill from (63,42) in black
B $D868,3,3 Move to (45,49)
B $D86B,2,2 Line 32 pixels right, 1 down every 16, to (77,47)
B $D86D,3,3 Move to (49,39)
B $D870,2,2 Line 8 pixels up, 1 right every 8, to (50,47)
B $D872,3,3 Move to (49,47)
B $D875,2,2 Line 4 pixels right, 1 up every 4, to (53,48)
B $D877,3,3 Move to (53,47)
B $D87A,2,2 Line 9 pixels down, 1 right every 4, to (55,38)
B $D87C,3,3 Fill from (51,44) in black
B $D87F,3,3 Move to (52,47)
B $D882,2,2 Line 22 pixels up, 1 right every 18, to (53,69)
B $D884,2,2 Line 22 pixels right, 1 down every 2, to (75,58)
B $D886,3,3 Move to (53,68)
B $D889,2,2 Line 22 pixels right, 1 down every 2, to (75,57)
B $D88B,3,3 Move to (53,68)
B $D88E,2,2 Line 22 pixels down, 1 right every 21, to (54,46)
B $D890,3,3 Move to (83,58)
B $D893,2,2 Line 11 pixels diagonally down-right, to (94,47)
B $D895,3,3 Move to (83,59)
B $D898,2,2 Line 11 pixels diagonally down-right, to (94,48)
B $D89A,3,3 Move to (83,59)
B $D89D,2,2 Line 20 pixels diagonally up-right, to (103,79)
B $D89F,3,3 Move to (84,59)
B $D8A2,2,2 Line 20 pixels diagonally up-right, to (104,79)
B $D8A4,3,3 Move to (103,78)
B $D8A7,2,2 Line 22 pixels right, 1 down every 2, to (125,67)
B $D8A9,3,3 Move to (103,77)
B $D8AC,2,2 Line 22 pixels right, 1 down every 2, to (125,66)
B $D8AE,3,3 Move to (103,77)
B $D8B1,2,2 Line 22 pixels down, 1 right every 7, to (106,55)
B $D8B3,3,3 Move to (104,66)
B $D8B6,2,2 Line 17 pixels right, 1 down every 2, to (121,58)
B $D8B8,3,3 Move to (104,65)
B $D8BB,2,2 Line 17 pixels right, 1 down every 2, to (121,57)
B $D8BD,3,3 Move to (106,57)
B $D8C0,2,2 Line 14 pixels right, 1 down every 2, to (120,50)
B $D8C2,3,3 Move to (106,56)
B $D8C5,2,2 Line 14 pixels right, 1 down every 2, to (120,49)
B $D8C7,3,3 Move to (105,57)
B $D8CA,2,2 Line 14 pixels left, 1 down every 2, to (91,50)
B $D8CC,3,3 Move to (105,56)
B $D8CF,2,2 Line 14 pixels left, 1 down every 2, to (91,49)
B $D8D1,3,3 Move to (104,65)
B $D8D4,2,2 Line 19 pixels left, 1 down every 2, to (85,56)
B $D8D6,3,3 Move to (104,64)
B $D8D9,2,2 Line 19 pixels left, 1 down every 2, to (85,55)
B $D8DB,3,3 Move to (87,58)
B $D8DE,2,2 Line 12 pixels down, 1 left every 8, to (86,46)
B $D8E0,3,3 Move to (88,58)
B $D8E3,2,2 Line 12 pixels down, 1 left every 8, to (87,46)
B $D8E5,3,3 Move to (82,58)
B $D8E8,2,2 Line 12 pixels down, 1 left every 8, to (81,46)
B $D8EA,3,3 Move to (31,79)
B $D8ED,2,2 Line 26 pixels up, 1 right every 2, to (44,105)
B $D8EF,3,3 Move to (30,79)
B $D8F2,2,2 Line 26 pixels up, 1 right every 2, to (43,105)
B $D8F4,3,3 Move to (30,79)
B $D8F7,2,2 Line 26 pixels up, 1 right every 2, to (43,105)
B $D8F9,2,2 Line 24 pixels down, 1 right every 2, to (55,81)
B $D8FB,2,2 Line 9 pixels left, 1 up every 4, to (46,83)
B $D8FD,2,2 Line 9 pixels left, 1 down every 5, to (37,82)
B $D8FF,3,3 Move to (45,83)
B $D902,2,2 Line 20 pixels up, 1 left every 8, to (43,103)
B $D904,3,3 Move to (44,83)
B $D907,2,2 Line 20 pixels up, 1 left every 8, to (42,103)
B $D909,3,3 Move to (47,38)
B $D90C,2,2 Line 45 pixels up, 1 right every 13, to (50,83)
B $D90E,3,3 Move to (48,38)
B $D911,2,2 Line 45 pixels up, 1 right every 13, to (51,83)
B $D913,3,3 Move to (39,69)
B $D916,2,2 Line 15 pixels up, 1 right every 2, to (46,84)
B $D918,3,3 Move to (40,69)
B $D91B,2,2 Line 15 pixels up, 1 right every 2, to (47,84)
B $D91D,3,3 Move to (212,21)
B $D920,2,2 Line 15 pixels right, 1 up every 2, to (227,28)
B $D922,2,2 Line 15 pixels diagonally up-right, to (242,43)
B $D924,2,2 Line 15 pixels right, 1 down every 2, to (255,36)
B $D926,3,3 Fill from (255,29) in black
B $D929,1,1 End of picture
b $D92A Picture: room 7 (?)
D $D92A The picture for room 7 (?). It is 638 bytes long: 192 lines, 50 moves, 26 fills and 3 painted areas. See #R$8985 for the format.
D $D92A #HTML[<img src="../images/pictures/room07.png" alt="room 7">]
B $D92A,2,2 Border white, picture area black ink on white paper
B $D92C,3,3 Move to (52,0)
B $D92F,2,2 Line 63 pixels up, 1 left every 6, to (42,63)
B $D931,2,2 Line 28 pixels right, 1 up every 28, to (70,64)
B $D933,2,2 Line 30 pixels left, 1 up every 7, to (40,68)
B $D935,2,2 Line 22 pixels up, 1 left every 4, to (35,90)
B $D937,3,3 Move to (34,90)
B $D93A,2,2 Line 23 pixels down, to (34,67)
B $D93C,2,2 Line 15 pixels left, 1 up every 5, to (19,70)
B $D93E,2,2 Line 7 pixels left, to (12,70)
B $D940,2,2 Line 7 pixels left, 1 down every 6, to (5,69)
B $D942,2,2 Line 7 pixels down, 1 right every 5, to (6,62)
B $D944,2,2 Line 7 pixels down, 1 right every 2, to (9,55)
B $D946,2,2 Line 7 pixels diagonally down-right, to (16,48)
B $D948,2,2 Line 7 pixels right, 1 up every 2, to (23,51)
B $D94A,2,2 Line 7 pixels right, 1 up every 2, to (30,54)
B $D94C,2,2 Line 5 pixels up, 1 right every 5, to (31,59)
B $D94E,2,2 Line 6 pixels right, 1 up every 4, to (37,60)
B $D950,2,2 Line 63 pixels down, 1 right every 6, to (47,0)
B $D952,3,3 Move to (12,69)
B $D955,2,2 Line 9 pixels down, 1 right every 2, to (16,60)
B $D957,2,2 Line 6 pixels right, 1 down every 2, to (22,57)
B $D959,2,2 Line 6 pixels diagonally down-right, to (28,51)
B $D95B,3,3 Move to (24,52)
B $D95E,2,2 Line 14 pixels left, 1 up every 5, to (10,54)
B $D960,3,3 Fill from (12,58) in red
B $D963,3,3 Move to (39,51)
B $D966,2,2 Line 5 pixels right, 1 up every 5, to (44,52)
B $D968,3,3 Fill from (42,46) in black
B $D96B,3,3 Move to (209,7)
B $D96E,2,2 Line 32 pixels left, 1 up every 7, to (177,11)
B $D970,2,2 Line 4 pixels down, 1 left every 3, to (176,7)
B $D972,2,2 Line 4 pixels diagonally up-left, to (172,11)
B $D974,2,2 Line 3 pixels diagonally up-right, to (175,14)
B $D976,2,2 Line 3 pixels diagonally up-left, to (172,17)
B $D978,2,2 Line 3 pixels right, 1 up every 2, to (175,18)
B $D97A,2,2 Line 5 pixels right, 1 down every 2, to (180,16)
B $D97C,2,2 Line 24 pixels right, 1 down every 6, to (204,12)
B $D97E,2,2 Line 3 pixels diagonally down-right, to (207,9)
B $D980,2,2 Line 3 pixels right, 1 up every 2, to (210,10)
B $D982,2,2 Line 3 pixels up, 1 right every 2, to (211,13)
B $D984,2,2 Line 3 pixels right, 1 up every 2, to (214,14)
B $D986,2,2 Line 3 pixels right, to (217,14)
B $D988,2,2 Line 3 pixels down, 1 right every 2, to (218,11)
B $D98A,2,2 Line 3 pixels down, 1 right every 3, to (219,8)
B $D98C,2,2 Line 3 pixels down, 1 left every 2, to (218,5)
B $D98E,2,2 Line 3 pixels left, 1 down every 2, to (215,4)
B $D990,2,2 Line 3 pixels left, 1 down every 3, to (212,3)
B $D992,2,2 Line 4 pixels diagonally up-left, to (208,7)
B $D994,3,3 Move to (202,13)
B $D997,2,2 Line 8 pixels left, 1 up every 2, to (194,17)
B $D999,2,2 Line 6 pixels left, 1 up every 6, to (188,18)
B $D99B,2,2 Line 7 pixels up, 1 left every 3, to (186,25)
B $D99D,2,2 Line 4 pixels right, 1 down every 3, to (190,24)
B $D99F,3,3 Move to (189,25)
B $D9A2,2,2 Line 6 pixels up, 1 right every 2, to (192,31)
B $D9A4,2,2 Line 6 pixels right, 1 up every 2, to (198,34)
B $D9A6,2,2 Line 6 pixels right, 1 down every 4, to (204,33)
B $D9A8,2,2 Line 4 pixels diagonally down-right, to (208,29)
B $D9AA,2,2 Line 4 pixels down, 1 left every 2, to (206,25)
B $D9AC,2,2 Line 4 pixels down, 1 right every 3, to (207,21)
B $D9AE,2,2 Line 4 pixels diagonally down-right, to (211,17)
B $D9B0,2,2 Line 4 pixels down, 1 right every 3, to (212,13)
B $D9B2,3,3 Move to (205,24)
B $D9B5,2,2 Line 3 pixels diagonally up-left, to (202,27)
B $D9B7,3,3 Move to (202,26)
B $D9BA,2,2 Line 3 pixels down, 1 left every 3, to (201,23)
B $D9BC,3,3 Move to (202,23)
B $D9BF,2,2 Line 3 pixels right, 1 down every 3, to (205,22)
B $D9C1,3,3 Fill from (203,24) in black
B $D9C4,3,3 Move to (195,21)
B $D9C7,2,2 Line 3 pixels down, 1 right every 3, to (196,18)
B $D9C9,2,2 Line 3 pixels right, 1 up every 2, to (199,19)
B $D9CB,2,2 Line 3 pixels up, 1 left every 2, to (198,22)
B $D9CD,2,2 Line 3 pixels left, 1 down every 3, to (195,21)
B $D9CF,3,3 Fill from (197,20) in black
B $D9D2,3,3 Move to (187,20)
B $D9D5,2,2 Line 19 pixels left, 1 up every 3, to (168,26)
B $D9D7,2,2 Line 3 pixels left, 1 down every 3, to (165,25)
B $D9D9,2,2 Line 3 pixels up, 1 left every 2, to (164,28)
B $D9DB,2,2 Line 3 pixels up, to (164,31)
B $D9DD,2,2 Line 3 pixels diagonally up-right, to (167,34)
B $D9DF,2,2 Line 3 pixels up, 1 left every 2, to (166,37)
B $D9E1,2,2 Line 3 pixels right, 1 up every 3, to (169,38)
B $D9E3,2,2 Line 3 pixels diagonally down-right, to (172,35)
B $D9E5,2,2 Line 3 pixels down, 1 right every 3, to (173,32)
B $D9E7,2,2 Line 3 pixels down, to (173,29)
B $D9E9,2,2 Line 13 pixels right, 1 down every 3, to (186,25)
B $D9EB,3,3 Move to (255,44)
B $D9EE,2,2 Line 11 pixels left, 1 up every 5, to (244,46)
B $D9F0,2,2 Line 11 pixels diagonally up-left, to (233,57)
B $D9F2,2,2 Line 11 pixels left, 1 up every 7, to (222,58)
B $D9F4,2,2 Line 11 pixels left, 1 up every 9, to (211,59)
B $D9F6,2,2 Line 11 pixels left, 1 down every 11, to (200,58)
B $D9F8,2,2 Line 11 pixels left, 1 up every 2, to (189,63)
B $D9FA,2,2 Line 11 pixels up, 1 left every 3, to (186,74)
B $D9FC,2,2 Line 11 pixels left, 1 up every 6, to (175,75)
B $D9FE,2,2 Line 14 pixels left, 1 up every 3, to (161,79)
B $DA00,2,2 Line 11 pixels left, 1 up every 4, to (150,81)
B $DA02,2,2 Line 11 pixels left, 1 up every 9, to (139,82)
B $DA04,2,2 Line 11 pixels left, 1 down every 11, to (128,81)
B $DA06,2,2 Line 11 pixels left, 1 up every 4, to (117,83)
B $DA08,2,2 Line 11 pixels left, 1 down every 11, to (106,82)
B $DA0A,2,2 Line 8 pixels left, 1 up every 2, to (98,86)
B $DA0C,2,2 Line 11 pixels left, 1 up every 8, to (87,87)
B $DA0E,2,2 Line 5 pixels diagonally down-left, to (82,82)
B $DA10,2,2 Line 11 pixels left, 1 down every 6, to (71,81)
B $DA12,2,2 Line 11 pixels left, 1 down every 8, to (60,80)
B $DA14,2,2 Line 11 pixels left, 1 down every 8, to (49,79)
B $DA16,2,2 Line 12 pixels left, 1 up every 7, to (37,80)
B $DA18,3,3 Move to (33,82)
B $DA1B,2,2 Line 16 pixels left, 1 up every 5, to (17,85)
B $DA1D,2,2 Line 19 pixels left, 1 down every 2, to (0,76)
B $DA1F,3,3 Move to (93,33)
B $DA22,2,2 Line 5 pixels left, 1 up every 2, to (88,35)
B $DA24,2,2 Line 5 pixels diagonally up-left, to (83,40)
B $DA26,2,2 Line 5 pixels up, 1 left every 2, to (81,45)
B $DA28,2,2 Line 5 pixels up, to (81,50)
B $DA2A,2,2 Line 5 pixels up, 1 right every 2, to (83,55)
B $DA2C,2,2 Line 5 pixels diagonally up-right, to (88,60)
B $DA2E,2,2 Line 5 pixels right, 1 down every 2, to (93,58)
B $DA30,2,2 Line 5 pixels right, 1 down every 3, to (98,57)
B $DA32,2,2 Line 5 pixels right, 1 down every 5, to (103,56)
B $DA34,2,2 Line 5 pixels right, 1 up every 5, to (108,57)
B $DA36,3,3 Move to (103,56)
B $DA39,2,2 Line 5 pixels right, 1 up every 4, to (108,57)
B $DA3B,2,2 Line 5 pixels right, 1 up every 4, to (113,58)
B $DA3D,2,2 Line 5 pixels right, 1 up every 4, to (118,59)
B $DA3F,2,2 Line 5 pixels right, 1 up every 2, to (123,61)
B $DA41,2,2 Line 5 pixels right, 1 down every 2, to (128,59)
B $DA43,2,2 Line 5 pixels down, 1 right every 2, to (130,54)
B $DA45,2,2 Line 5 pixels down, 1 left every 5, to (129,49)
B $DA47,2,2 Line 5 pixels down, 1 left every 4, to (128,44)
B $DA49,2,2 Line 5 pixels down, 1 left every 3, to (127,39)
B $DA4B,2,2 Line 5 pixels diagonally down-left, to (122,34)
B $DA4D,2,2 Line 5 pixels left, 1 down every 3, to (117,33)
B $DA4F,2,2 Line 5 pixels left, 1 down every 5, to (112,32)
B $DA51,2,2 Line 5 pixels left, 1 down every 5, to (107,31)
B $DA53,2,2 Line 5 pixels left, to (102,31)
B $DA55,2,2 Line 5 pixels left, 1 up every 5, to (97,32)
B $DA57,2,2 Line 5 pixels left, 1 up every 4, to (92,33)
B $DA59,3,3 Move to (89,61)
B $DA5C,2,2 Line 5 pixels right, 1 up every 2, to (94,63)
B $DA5E,2,2 Line 5 pixels right, 1 up every 5, to (99,64)
B $DA60,2,2 Line 5 pixels right, 1 up every 5, to (104,65)
B $DA62,2,2 Line 5 pixels right, to (109,65)
B $DA64,2,2 Line 5 pixels right, 1 down every 4, to (114,64)
B $DA66,2,2 Line 5 pixels right, 1 down every 4, to (119,63)
B $DA68,2,2 Line 5 pixels right, 1 down every 3, to (124,62)
B $DA6A,3,3 Move to (83,40)
B $DA6D,2,2 Line 5 pixels left, 1 up every 3, to (78,41)
B $DA6F,2,2 Line 5 pixels left, 1 up every 2, to (73,43)
B $DA71,2,2 Line 4 pixels diagonally down-left, to (69,39)
B $DA73,2,2 Line 17 pixels right, 1 down every 6, to (86,37)
B $DA75,2,2 Line 11 pixels left, 1 down every 2, to (75,32)
B $DA77,2,2 Line 5 pixels down, 1 right every 5, to (76,27)
B $DA79,2,2 Line 3 pixels right, 1 up every 2, to (79,28)
B $DA7B,2,2 Line 3 pixels up, 1 left every 3, to (78,31)
B $DA7D,2,2 Line 3 pixels left, to (75,31)
B $DA7F,3,3 Move to (79,29)
B $DA82,2,2 Line 11 pixels right, 1 up every 2, to (90,34)
B $DA84,3,3 Move to (92,32)
B $DA87,2,2 Line 11 pixels down, 1 left every 7, to (91,21)
B $DA89,2,2 Line 4 pixels diagonally down-right, to (95,17)
B $DA8B,2,2 Line 3 pixels diagonally up-right, to (98,20)
B $DA8D,2,2 Line 3 pixels diagonally up-left, to (95,23)
B $DA8F,2,2 Line 4 pixels left, 1 down every 2, to (91,21)
B $DA91,3,3 Move to (98,21)
B $DA94,2,2 Line 10 pixels up, 1 right every 6, to (99,31)
B $DA96,3,3 Move to (106,31)
B $DA99,2,2 Line 10 pixels down, 1 right every 2, to (111,21)
B $DA9B,2,2 Line 4 pixels right, 1 down every 3, to (115,20)
B $DA9D,2,2 Line 4 pixels up, 1 right every 3, to (116,24)
B $DA9F,2,2 Line 4 pixels left, 1 up every 3, to (112,25)
B $DAA1,2,2 Line 4 pixels down, 1 left every 3, to (111,21)
B $DAA3,3,3 Move to (116,24)
B $DAA6,2,2 Line 9 pixels up, 1 left every 2, to (112,33)
B $DAA8,3,3 Move to (123,34)
B $DAAB,2,2 Line 9 pixels right, 1 down every 3, to (132,31)
B $DAAD,2,2 Line 9 pixels right, 1 down every 3, to (141,28)
B $DAAF,2,2 Line 4 pixels down, 1 left every 3, to (140,24)
B $DAB1,2,2 Line 4 pixels left, to (136,24)
B $DAB3,2,2 Line 4 pixels up, 1 left every 4, to (135,28)
B $DAB5,2,2 Line 4 pixels right, 1 up every 3, to (139,29)
B $DAB7,3,3 Move to (136,24)
B $DABA,2,2 Line 18 pixels left, 1 up every 2, to (118,33)
B $DABC,3,3 Move to (126,37)
B $DABF,2,2 Line 15 pixels right, 1 up every 3, to (141,42)
B $DAC1,2,2 Line 7 pixels left, 1 up every 5, to (134,43)
B $DAC3,2,2 Line 7 pixels left, 1 down every 4, to (127,42)
B $DAC5,3,3 Move to (91,58)
B $DAC8,2,2 Line 5 pixels down, 1 right every 2, to (93,53)
B $DACA,2,2 Line 5 pixels diagonally up-right, to (98,58)
B $DACC,3,3 Move to (110,56)
B $DACF,2,2 Line 5 pixels right, 1 down every 4, to (115,55)
B $DAD1,2,2 Line 5 pixels diagonally up-right, to (120,60)
B $DAD3,3,3 Fill from (107,61) in red
B $DAD6,3,3 Fill from (94,56) in red
B $DAD9,3,3 Fill from (115,57) in red
B $DADC,3,3 Move to (115,83)
B $DADF,2,2 Line 17 pixels up, 1 left every 3, to (110,100)
B $DAE1,2,2 Line 17 pixels up, 1 left every 4, to (106,117)
B $DAE3,2,2 Line 17 pixels up, 1 left every 4, to (102,127)
B $DAE5,3,3 Move to (50,80)
B $DAE8,2,2 Line 27 pixels up, 1 right every 4, to (56,107)
B $DAEA,2,2 Line 27 pixels up, 1 right every 2, to (69,127)
B $DAEC,3,3 Move to (16,86)
B $DAEF,2,2 Line 27 pixels up, 1 right every 8, to (19,113)
B $DAF1,2,2 Line 27 pixels up, 1 left every 7, to (16,127)
B $DAF3,3,3 Move to (155,81)
B $DAF6,2,2 Line 27 pixels up, 1 left every 10, to (153,108)
B $DAF8,2,2 Line 26 pixels up, 1 right every 4, to (159,127)
B $DAFA,3,3 Move to (87,88)
B $DAFD,2,2 Line 20 pixels up, 1 right every 4, to (92,108)
B $DAFF,2,2 Line 23 pixels down, 1 right every 3, to (99,85)
B $DB01,3,3 Fill from (95,91) in black
B $DB04,3,3 Move to (186,75)
B $DB07,2,2 Line 33 pixels up, 1 right every 8, to (190,108)
B $DB09,2,2 Line 44 pixels up, 1 right every 5, to (198,127)
B $DB0B,3,3 Move to (233,58)
B $DB0E,2,2 Line 63 pixels up, 1 right every 10, to (239,121)
B $DB10,2,2 Line 63 pixels up, 1 right every 10, to (245,127)
B $DB12,3,3 Move to (165,31)
B $DB15,2,2 Line 9 pixels right, 1 up every 6, to (174,32)
B $DB17,7,7 Paint blue paper from cell (0,0): 63 right, 63 right, 35 right
B $DB1E,5,5 Paint blue paper from cell (5,5): 3 right
B $DB23,11,11 Paint blue paper from cell (18,5): 13 right, 1 down, 7 left, 1 down, 7 right, 1 down, 3 left
B $DB2E,3,3 Move to (0,79)
B $DB31,2,2 Line 7 pixels right, to (7,79)
B $DB33,3,3 Fill from (0,78) in blue
B $DB36,3,3 Move to (8,81)
B $DB39,2,2 Line 7 pixels up, 1 right every 7, to (9,88)
B $DB3B,3,3 Move to (9,87)
B $DB3E,2,2 Line 25 pixels right, to (34,87)
B $DB40,3,3 Fill from (11,85) in blue
B $DB43,3,3 Fill from (26,85) in blue
B $DB46,3,3 Move to (37,87)
B $DB49,2,2 Line 3 pixels right, 1 down every 3, to (40,86)
B $DB4B,3,3 Move to (39,87)
B $DB4E,2,2 Line 8 pixels down, 1 right every 8, to (40,79)
B $DB50,3,3 Fill from (37,84) in blue
B $DB53,3,3 Move to (64,81)
B $DB56,2,2 Line 7 pixels up, to (64,88)
B $DB58,3,3 Move to (64,87)
B $DB5B,2,2 Line 24 pixels right, 1 down every 24, to (88,86)
B $DB5D,3,3 Fill from (69,85) in blue
B $DB60,3,3 Move to (100,87)
B $DB63,2,2 Line 44 pixels right, 1 down every 44, to (144,86)
B $DB65,3,3 Move to (143,87)
B $DB68,2,2 Line 8 pixels down, 1 right every 8, to (144,79)
B $DB6A,3,3 Fill from (134,84) in blue
B $DB6D,3,3 Fill from (108,84) in blue
B $DB70,3,3 Move to (164,79)
B $DB73,2,2 Line 29 pixels right, 1 down every 28, to (193,78)
B $DB75,3,3 Move to (191,78)
B $DB78,2,2 Line 15 pixels down, 1 right every 15, to (192,63)
B $DB7A,3,3 Move to (191,63)
B $DB7D,2,2 Line 41 pixels right, 1 down every 41, to (232,62)
B $DB7F,3,3 Move to (231,62)
B $DB82,2,2 Line 7 pixels down, 1 right every 7, to (232,55)
B $DB84,2,2 Line 25 pixels right, 1 down every 24, to (255,54)
B $DB86,3,3 Fill from (244,50) in blue
B $DB89,3,3 Fill from (221,60) in blue
B $DB8C,3,3 Fill from (189,71) in blue
B $DB8F,3,3 Fill from (171,77) in blue
B $DB92,3,3 Fill from (169,34) in red
B $DB95,3,3 Fill from (131,40) in black
B $DB98,3,3 Fill from (131,29) in black
B $DB9B,3,3 Fill from (111,29) in black
B $DB9E,3,3 Fill from (96,29) in black
B $DBA1,3,3 Fill from (83,32) in black
B $DBA4,3,3 Fill from (78,39) in black
B $DBA7,1,1 End of picture
b $DBA8 Picture: room 24 (?)
D $DBA8 The picture for room 24 (?). It is 465 bytes long: 141 lines, 52 moves, 8 fills and 0 painted areas. See #R$8985 for the format.
D $DBA8 #HTML[<img src="../images/pictures/room24.png" alt="room 24">]
B $DBA8,2,2 Border white, picture area black ink on white paper
B $DBAA,3,3 Move to (0,119)
B $DBAD,2,2 Line 6 pixels right, 1 down every 2, to (6,116)
B $DBAF,2,2 Line 6 pixels right, 1 up every 2, to (12,119)
B $DBB1,2,2 Line 6 pixels right, 1 up every 3, to (18,121)
B $DBB3,2,2 Line 6 pixels right, 1 down every 2, to (24,118)
B $DBB5,2,2 Line 6 pixels down, to (24,112)
B $DBB7,2,2 Line 6 pixels down, 1 left every 2, to (21,106)
B $DBB9,2,2 Line 6 pixels down, to (21,100)
B $DBBB,2,2 Line 6 pixels diagonally down-right, to (27,94)
B $DBBD,2,2 Line 6 pixels right, 1 down every 3, to (33,92)
B $DBBF,2,2 Line 6 pixels right, 1 down every 2, to (39,89)
B $DBC1,2,2 Line 6 pixels up, 1 left every 2, to (36,95)
B $DBC3,2,2 Line 6 pixels up, 1 left every 2, to (33,101)
B $DBC5,2,2 Line 6 pixels up, 1 right every 2, to (36,107)
B $DBC7,2,2 Line 6 pixels right, 1 up every 2, to (42,110)
B $DBC9,2,2 Line 6 pixels diagonally up-right, to (48,116)
B $DBCB,2,2 Line 6 pixels right, 1 up every 2, to (54,119)
B $DBCD,2,2 Line 6 pixels up, 1 right every 4, to (55,125)
B $DBCF,2,2 Line 6 pixels right, 1 up every 2, to (61,127)
B $DBD1,3,3 Fill from (46,121) in cyan
B $DBD4,3,3 Move to (184,127)
B $DBD7,2,2 Line 6 pixels diagonally down-right, to (190,121)
B $DBD9,2,2 Line 6 pixels down, 1 right every 2, to (193,115)
B $DBDB,2,2 Line 6 pixels right, 1 down every 6, to (199,114)
B $DBDD,2,2 Line 6 pixels diagonally down-right, to (205,108)
B $DBDF,2,2 Line 6 pixels right, 1 down every 4, to (211,107)
B $DBE1,2,2 Line 6 pixels right, 1 down every 3, to (217,105)
B $DBE3,2,2 Line 6 pixels right, 1 up every 6, to (223,106)
B $DBE5,2,2 Line 6 pixels right, 1 up every 4, to (229,107)
B $DBE7,2,2 Line 6 pixels right, 1 up every 3, to (235,109)
B $DBE9,2,2 Line 6 pixels right, 1 up every 4, to (241,110)
B $DBEB,2,2 Line 6 pixels right, 1 up every 3, to (247,112)
B $DBED,2,2 Line 6 pixels right, 1 up every 3, to (253,114)
B $DBEF,2,2 Line 6 pixels right, 1 up every 3, to (255,116)
B $DBF1,3,3 Fill from (240,113) in cyan
B $DBF4,3,3 Move to (25,48)
B $DBF7,2,2 Line 63 pixels right, 1 up every 14, to (88,52)
B $DBF9,2,2 Line 9 pixels right, 1 up every 9, to (97,53)
B $DBFB,2,2 Line 62 pixels down, 1 right every 59, to (98,0)
B $DBFD,3,3 Move to (35,42)
B $DC00,2,2 Line 62 pixels right, 1 up every 17, to (97,45)
B $DC02,3,3 Move to (30,32)
B $DC05,2,2 Line 62 pixels right, 1 up every 17, to (92,35)
B $DC07,2,2 Line 4 pixels right, 1 up every 4, to (96,36)
B $DC09,3,3 Move to (24,47)
B $DC0C,2,2 Line 11 pixels right, 1 down every 2, to (35,42)
B $DC0E,2,2 Line 7 pixels down, 1 left every 6, to (34,35)
B $DC10,2,2 Line 5 pixels left, 1 down every 2, to (29,33)
B $DC12,3,3 Move to (97,53)
B $DC15,2,2 Line 5 pixels diagonally up-left, to (92,58)
B $DC17,2,2 Line 5 pixels up, to (92,63)
B $DC19,2,2 Line 5 pixels diagonally down-left, to (87,58)
B $DC1B,2,2 Line 5 pixels left, 1 up every 3, to (82,59)
B $DC1D,2,2 Line 5 pixels up, 1 left every 4, to (81,64)
B $DC1F,2,2 Line 46 pixels diagonally up-right, to (127,110)
B $DC21,2,2 Line 41 pixels diagonally down-right, to (168,69)
B $DC23,2,2 Line 9 pixels down, 1 right every 4, to (170,60)
B $DC25,2,2 Line 4 pixels left, 1 up every 3, to (166,61)
B $DC27,2,2 Line 4 pixels up, 1 left every 2, to (164,65)
B $DC29,2,2 Line 4 pixels up, 1 right every 2, to (166,69)
B $DC2B,2,2 Line 3 pixels right, 1 up every 3, to (169,70)
B $DC2D,3,3 Move to (167,60)
B $DC30,2,2 Line 39 pixels diagonally up-left, to (128,99)
B $DC32,2,2 Line 37 pixels diagonally down-left, to (91,62)
B $DC34,3,3 Move to (128,99)
B $DC37,2,2 Line 6 pixels up, 1 left every 3, to (126,105)
B $DC39,2,2 Line 5 pixels up, 1 right every 3, to (127,110)
B $DC3B,3,3 Move to (96,66)
B $DC3E,2,2 Line 63 pixels right, 1 up every 16, to (159,69)
B $DC40,3,3 Move to (157,61)
B $DC43,2,2 Line 63 pixels left, 1 down every 16, to (94,58)
B $DC45,2,2 Line 1 pixels diagonally down-left, to (93,57)
B $DC47,3,3 Move to (158,61)
B $DC4A,2,2 Line 7 pixels up, 1 left every 7, to (157,68)
B $DC4C,3,3 Move to (158,60)
B $DC4F,2,2 Line 4 pixels diagonally down-right, to (162,56)
B $DC51,2,2 Line 63 pixels left, 1 down every 17, to (99,53)
B $DC53,2,2 Line 4 pixels left, 1 down every 4, to (95,52)
B $DC55,3,3 Move to (163,56)
B $DC58,2,2 Line 7 pixels up, 1 right every 7, to (164,63)
B $DC5A,3,3 Move to (163,55)
B $DC5D,2,2 Line 63 pixels down, 1 right every 61, to (164,0)
B $DC5F,3,3 Move to (104,52)
B $DC62,2,2 Line 63 pixels down, 1 right every 61, to (105,0)
B $DC64,3,3 Move to (107,52)
B $DC67,2,2 Line 63 pixels down, 1 right every 61, to (108,0)
B $DC69,3,3 Move to (153,55)
B $DC6C,2,2 Line 63 pixels down, 1 right every 61, to (154,0)
B $DC6E,3,3 Move to (160,55)
B $DC71,2,2 Line 63 pixels down, 1 right every 61, to (161,0)
B $DC73,3,3 Move to (33,31)
B $DC76,2,2 Line 17 pixels down, 1 right every 17, to (34,14)
B $DC78,3,3 Move to (41,31)
B $DC7B,2,2 Line 26 pixels down, 1 left every 26, to (40,5)
B $DC7D,3,3 Move to (50,32)
B $DC80,2,2 Line 26 pixels down, 1 left every 26, to (49,6)
B $DC82,3,3 Move to (59,32)
B $DC85,2,2 Line 20 pixels down, 1 left every 20, to (58,12)
B $DC87,3,3 Move to (68,33)
B $DC8A,2,2 Line 35 pixels down, to (68,0)
B $DC8C,3,3 Move to (77,33)
B $DC8F,2,2 Line 35 pixels down, to (77,0)
B $DC91,3,3 Move to (87,34)
B $DC94,2,2 Line 36 pixels down, 1 left every 35, to (86,0)
B $DC96,3,3 Move to (164,55)
B $DC99,2,2 Line 63 pixels right, 1 up every 17, to (227,58)
B $DC9B,2,2 Line 63 pixels right, 1 up every 17, to (255,61)
B $DC9D,3,3 Move to (164,48)
B $DCA0,2,2 Line 63 pixels right, 1 up every 17, to (227,51)
B $DCA2,2,2 Line 63 pixels right, 1 up every 17, to (255,54)
B $DCA4,3,3 Move to (164,37)
B $DCA7,2,2 Line 63 pixels right, 1 up every 17, to (227,40)
B $DCA9,2,2 Line 63 pixels right, 1 up every 17, to (255,43)
B $DCAB,3,3 Move to (173,36)
B $DCAE,2,2 Line 46 pixels down, 1 right every 39, to (174,0)
B $DCB0,3,3 Move to (183,37)
B $DCB3,2,2 Line 46 pixels down, 1 right every 39, to (184,0)
B $DCB5,3,3 Move to (193,37)
B $DCB8,2,2 Line 46 pixels down, 1 right every 39, to (194,0)
B $DCBA,3,3 Move to (204,38)
B $DCBD,2,2 Line 35 pixels down, 1 right every 35, to (205,3)
B $DCBF,3,3 Move to (213,38)
B $DCC2,2,2 Line 37 pixels down, 1 right every 37, to (214,1)
B $DCC4,3,3 Move to (222,39)
B $DCC7,2,2 Line 42 pixels down, 1 left every 42, to (221,0)
B $DCC9,3,3 Move to (232,39)
B $DCCC,2,2 Line 42 pixels down, 1 left every 42, to (231,0)
B $DCCE,3,3 Move to (241,39)
B $DCD1,2,2 Line 42 pixels down, 1 left every 42, to (240,0)
B $DCD3,3,3 Move to (250,40)
B $DCD6,2,2 Line 42 pixels down, 1 left every 42, to (249,0)
B $DCD8,3,3 Move to (129,92)
B $DCDB,2,2 Line 26 pixels diagonally down-left, to (103,66)
B $DCDD,3,3 Move to (129,92)
B $DCE0,2,2 Line 23 pixels diagonally down-right, to (152,69)
B $DCE2,3,3 Fill from (129,94) in black
B $DCE5,3,3 Fill from (105,45) in black
B $DCE8,3,3 Fill from (162,45) in black
B $DCEB,3,3 Fill from (162,60) in black
B $DCEE,3,3 Fill from (167,64) in black
B $DCF1,3,3 Move to (33,14)
B $DCF4,2,2 Line 9 pixels diagonally down-right, to (42,5)
B $DCF6,2,2 Line 9 pixels right, 1 up every 6, to (51,6)
B $DCF8,2,2 Line 9 pixels right, 1 up every 6, to (60,7)
B $DCFA,2,2 Line 6 pixels up, 1 left every 3, to (58,13)
B $DCFC,3,3 Move to (60,7)
B $DCFF,2,2 Line 9 pixels diagonally down-right, to (69,0)
B $DD01,3,3 Fill from (125,74) in red
B $DD04,3,3 Move to (33,14)
B $DD07,2,2 Line 12 pixels left, 1 up every 4, to (21,17)
B $DD09,2,2 Line 12 pixels left, 1 up every 7, to (9,18)
B $DD0B,2,2 Line 12 pixels diagonally up-left, to (0,30)
B $DD0D,3,3 Move to (194,0)
B $DD10,2,2 Line 10 pixels right, 1 up every 2, to (204,5)
B $DD12,2,2 Line 10 pixels right, 1 down every 2, to (214,0)
B $DD14,2,2 Line 10 pixels right, 1 down every 8, to (224,0)
B $DD16,3,3 Move to (29,32)
B $DD19,2,2 Line 9 pixels down, 1 left every 3, to (26,23)
B $DD1B,2,2 Line 9 pixels down, 1 left every 3, to (23,14)
B $DD1D,3,3 Move to (23,48)
B $DD20,2,2 Line 9 pixels up, 1 left every 4, to (21,57)
B $DD22,2,2 Line 9 pixels diagonally up-left, to (12,66)
B $DD24,2,2 Line 9 pixels up, 1 left every 2, to (8,75)
B $DD26,2,2 Line 9 pixels diagonally up-left, to (0,84)
B $DD28,3,3 Move to (41,87)
B $DD2B,2,2 Line 9 pixels right, 1 down every 2, to (50,83)
B $DD2D,2,2 Line 9 pixels down, 1 right every 4, to (52,74)
B $DD2F,2,2 Line 9 pixels down, 1 right every 2, to (56,65)
B $DD31,2,2 Line 9 pixels diagonally down-right, to (65,56)
B $DD33,2,2 Line 9 pixels right, 1 down every 2, to (74,52)
B $DD35,3,3 Move to (168,71)
B $DD38,2,2 Line 9 pixels up, 1 right every 4, to (170,80)
B $DD3A,2,2 Line 9 pixels diagonally up-right, to (179,89)
B $DD3C,2,2 Line 9 pixels up, 1 right every 2, to (183,98)
B $DD3E,2,2 Line 9 pixels right, 1 up every 4, to (192,100)
B $DD40,2,2 Line 9 pixels right, 1 up every 3, to (201,103)
B $DD42,2,2 Line 9 pixels right, to (210,103)
B $DD44,2,2 Line 9 pixels right, to (219,103)
B $DD46,3,3 Move to (197,73)
B $DD49,2,2 Line 9 pixels diagonally up-right, to (206,82)
B $DD4B,2,2 Line 9 pixels right, 1 up every 3, to (215,85)
B $DD4D,2,2 Line 9 pixels right, 1 up every 2, to (224,89)
B $DD4F,2,2 Line 9 pixels right, 1 up every 6, to (233,90)
B $DD51,2,2 Line 9 pixels diagonally up-right, to (242,99)
B $DD53,2,2 Line 9 pixels right, 1 up every 4, to (251,101)
B $DD55,2,2 Line 9 pixels right, 1 up every 4, to (255,103)
B $DD57,3,3 Move to (70,126)
B $DD5A,2,2 Line 9 pixels right, 1 down every 7, to (79,125)
B $DD5C,2,2 Line 9 pixels right, 1 down every 2, to (88,121)
B $DD5E,2,2 Line 9 pixels down, 1 right every 4, to (90,112)
B $DD60,2,2 Line 9 pixels down, 1 right every 3, to (93,103)
B $DD62,3,3 Move to (90,112)
B $DD65,2,2 Line 9 pixels down, 1 left every 8, to (89,103)
B $DD67,2,2 Line 9 pixels down, 1 left every 7, to (88,94)
B $DD69,2,2 Line 9 pixels down, 1 right every 8, to (89,85)
B $DD6B,2,2 Line 9 pixels down, 1 right every 2, to (93,76)
B $DD6D,3,3 Move to (136,102)
B $DD70,2,2 Line 9 pixels up, 1 right every 3, to (139,111)
B $DD72,2,2 Line 9 pixels diagonally up-right, to (148,120)
B $DD74,2,2 Line 9 pixels right, 1 up every 2, to (157,124)
B $DD76,2,2 Line 9 pixels right, 1 up every 2, to (166,127)
B $DD78,1,1 End of picture
b $DD79 Picture: room 35 (?)
D $DD79 The picture for room 35 (?). It is 691 bytes long: 185 lines, 100 moves, 6 fills and 0 painted areas. See #R$8985 for the format.
D $DD79 #HTML[<img src="../images/pictures/room35.png" alt="room 35">]
B $DD79,2,2 Border white, picture area black ink on white paper
B $DD7B,3,3 Move to (35,52)
B $DD7E,2,2 Line 11 pixels up, to (35,63)
B $DD80,2,2 Line 5 pixels diagonally up-right, to (40,68)
B $DD82,2,2 Line 7 pixels right, to (47,68)
B $DD84,3,3 Move to (46,65)
B $DD87,2,2 Line 13 pixels up, 1 right every 2, to (52,78)
B $DD89,2,2 Line 18 pixels right, 1 up every 18, to (70,79)
B $DD8B,3,3 Move to (46,64)
B $DD8E,2,2 Line 24 pixels right, 1 up every 24, to (70,65)
B $DD90,2,2 Line 24 pixels up, 1 right every 24, to (71,89)
B $DD92,3,3 Move to (68,87)
B $DD95,2,2 Line 19 pixels up, 1 right every 2, to (77,106)
B $DD97,2,2 Line 19 pixels down, 1 right every 11, to (78,87)
B $DD99,3,3 Move to (77,106)
B $DD9C,2,2 Line 18 pixels down, 1 right every 3, to (83,88)
B $DD9E,3,3 Move to (77,106)
B $DDA1,2,2 Line 5 pixels up, 1 left every 5, to (76,111)
B $DDA3,3,3 Move to (71,89)
B $DDA6,2,2 Line 7 pixels right, 1 up every 7, to (78,90)
B $DDA8,3,3 Move to (78,89)
B $DDAB,2,2 Line 5 pixels right, 1 up every 3, to (83,90)
B $DDAD,3,3 Move to (78,88)
B $DDB0,2,2 Line 19 pixels down, to (78,69)
B $DDB2,3,3 Move to (82,89)
B $DDB5,2,2 Line 19 pixels down, 1 right every 19, to (83,70)
B $DDB7,3,3 Move to (70,64)
B $DDBA,2,2 Line 6 pixels down, 1 right every 6, to (71,58)
B $DDBC,3,3 Move to (70,61)
B $DDBF,2,2 Line 11 pixels diagonally up-right, to (81,72)
B $DDC1,3,3 Move to (81,71)
B $DDC4,2,2 Line 25 pixels right, 1 up every 25, to (106,72)
B $DDC6,3,3 Move to (106,71)
B $DDC9,2,2 Line 9 pixels diagonally down-right, to (115,62)
B $DDCB,2,2 Line 9 pixels left, 1 down every 5, to (106,61)
B $DDCD,2,2 Line 10 pixels up, 1 left every 10, to (105,71)
B $DDCF,3,3 Move to (106,61)
B $DDD2,2,2 Line 36 pixels left, 1 up every 36, to (70,62)
B $DDD4,3,3 Move to (106,61)
B $DDD7,2,2 Line 12 pixels down, 1 left every 12, to (105,49)
B $DDD9,3,3 Move to (114,62)
B $DDDC,2,2 Line 12 pixels down, 1 left every 12, to (113,50)
B $DDDE,3,3 Move to (121,54)
B $DDE1,2,2 Line 7 pixels up, 1 right every 7, to (122,61)
B $DDE3,2,2 Line 5 pixels diagonally up-right, to (127,66)
B $DDE5,2,2 Line 9 pixels up, 1 left every 9, to (126,75)
B $DDE7,2,2 Line 9 pixels diagonally up-right, to (135,84)
B $DDE9,2,2 Line 17 pixels right, 1 up every 17, to (152,85)
B $DDEB,2,2 Line 9 pixels diagonally down-right, to (161,76)
B $DDED,2,2 Line 11 pixels left, 1 down every 8, to (150,75)
B $DDEF,2,2 Line 11 pixels up, 1 right every 4, to (152,86)
B $DDF1,3,3 Move to (149,75)
B $DDF4,2,2 Line 23 pixels left, 1 up every 23, to (126,76)
B $DDF6,3,3 Move to (149,75)
B $DDF9,2,2 Line 24 pixels down, 1 left every 24, to (148,51)
B $DDFB,3,3 Move to (160,75)
B $DDFE,2,2 Line 24 pixels down, 1 left every 24, to (159,51)
B $DE00,3,3 Move to (128,66)
B $DE03,2,2 Line 9 pixels right, 1 up every 9, to (137,67)
B $DE05,3,3 Move to (138,66)
B $DE08,2,2 Line 16 pixels down, 1 right every 16, to (139,50)
B $DE0A,3,3 Move to (138,66)
B $DE0D,2,2 Line 7 pixels diagonally down-left, to (131,59)
B $DE0F,2,2 Line 10 pixels down, 1 left every 10, to (130,49)
B $DE11,3,3 Move to (131,59)
B $DE14,2,2 Line 10 pixels left, to (121,59)
B $DE16,3,3 Move to (130,53)
B $DE19,2,2 Line 13 pixels left, 1 down every 13, to (117,52)
B $DE1B,2,2 Line 6 pixels left, 1 down every 2, to (111,49)
B $DE1D,2,2 Line 6 pixels down, to (111,43)
B $DE1F,3,3 Move to (29,50)
B $DE22,2,2 Line 5 pixels right, 1 up every 4, to (34,51)
B $DE24,2,2 Line 5 pixels right, 1 up every 5, to (39,52)
B $DE26,2,2 Line 5 pixels right, 1 up every 3, to (44,53)
B $DE28,2,2 Line 5 pixels right, to (49,53)
B $DE2A,2,2 Line 5 pixels down, 1 right every 2, to (51,48)
B $DE2C,2,2 Line 5 pixels right, 1 down every 5, to (56,47)
B $DE2E,3,3 Move to (51,48)
B $DE31,2,2 Line 5 pixels right, 1 down every 5, to (56,47)
B $DE33,2,2 Line 5 pixels right, to (61,47)
B $DE35,2,2 Line 5 pixels right, 1 up every 5, to (66,48)
B $DE37,2,2 Line 5 pixels right, to (71,48)
B $DE39,2,2 Line 5 pixels right, 1 down every 4, to (76,47)
B $DE3B,2,2 Line 5 pixels right, 1 down every 3, to (81,46)
B $DE3D,3,3 Move to (76,47)
B $DE40,2,2 Line 5 pixels right, 1 down every 3, to (81,46)
B $DE42,2,2 Line 5 pixels right, 1 down every 4, to (86,45)
B $DE44,2,2 Line 5 pixels right, 1 down every 5, to (91,44)
B $DE46,2,2 Line 5 pixels right, 1 up every 3, to (96,45)
B $DE48,2,2 Line 5 pixels diagonally up-right, to (101,50)
B $DE4A,2,2 Line 5 pixels right, 1 up every 5, to (106,51)
B $DE4C,2,2 Line 5 pixels down, 1 right every 3, to (107,46)
B $DE4E,2,2 Line 5 pixels right, 1 down every 2, to (112,44)
B $DE50,2,2 Line 5 pixels right, 1 down every 4, to (117,43)
B $DE52,2,2 Line 5 pixels right, 1 up every 3, to (122,44)
B $DE54,2,2 Line 5 pixels diagonally up-right, to (127,49)
B $DE56,2,2 Line 5 pixels right, 1 up every 3, to (132,50)
B $DE58,2,2 Line 5 pixels right, 1 up every 4, to (137,51)
B $DE5A,2,2 Line 5 pixels right, 1 up every 5, to (142,52)
B $DE5C,2,2 Line 5 pixels right, to (147,52)
B $DE5E,2,2 Line 5 pixels right, 1 down every 5, to (152,51)
B $DE60,2,2 Line 5 pixels right, 1 down every 4, to (157,50)
B $DE62,2,2 Line 5 pixels right, 1 up every 3, to (162,51)
B $DE64,2,2 Line 5 pixels right, 1 up every 5, to (167,52)
B $DE66,3,3 Move to (5,49)
B $DE69,2,2 Line 18 pixels right, 1 down every 3, to (23,43)
B $DE6B,2,2 Line 18 pixels right, 1 down every 4, to (41,39)
B $DE6D,2,2 Line 18 pixels right, 1 down every 8, to (59,37)
B $DE6F,2,2 Line 18 pixels right, 1 down every 7, to (77,35)
B $DE71,2,2 Line 18 pixels right, 1 down every 6, to (95,32)
B $DE73,2,2 Line 18 pixels right, 1 up every 5, to (113,35)
B $DE75,2,2 Line 18 pixels right, 1 up every 8, to (131,37)
B $DE77,2,2 Line 18 pixels right, 1 up every 10, to (149,38)
B $DE79,2,2 Line 18 pixels right, 1 up every 10, to (167,39)
B $DE7B,2,2 Line 18 pixels right, 1 up every 2, to (185,48)
B $DE7D,2,2 Line 18 pixels right, 1 up every 3, to (203,54)
B $DE7F,2,2 Line 18 pixels left, 1 up every 6, to (185,57)
B $DE81,3,3 Move to (203,54)
B $DE84,2,2 Line 18 pixels left, 1 up every 7, to (185,56)
B $DE86,2,2 Line 18 pixels left, 1 up every 7, to (167,58)
B $DE88,2,2 Line 7 pixels left, 1 up every 2, to (160,61)
B $DE8A,3,3 Move to (49,73)
B $DE8D,2,2 Line 15 pixels left, 1 up every 6, to (34,75)
B $DE8F,2,2 Line 15 pixels left, 1 down every 7, to (19,73)
B $DE91,2,2 Line 15 pixels left, 1 down every 7, to (4,71)
B $DE93,2,2 Line 15 pixels left, 1 down every 7, to (0,69)
B $DE95,3,3 Move to (5,49)
B $DE98,2,2 Line 15 pixels left, 1 down every 7, to (0,47)
B $DE9A,3,3 Move to (93,71)
B $DE9D,2,2 Line 23 pixels up, 1 right every 23, to (94,94)
B $DE9F,2,2 Line 10 pixels right, 1 up every 2, to (104,99)
B $DEA1,2,2 Line 30 pixels right, to (134,99)
B $DEA3,2,2 Line 16 pixels down, 1 right every 16, to (135,83)
B $DEA5,3,3 Move to (134,99)
B $DEA8,2,2 Line 13 pixels left, 1 down every 2, to (121,93)
B $DEAA,2,2 Line 27 pixels left, 1 up every 27, to (94,94)
B $DEAC,3,3 Move to (121,93)
B $DEAF,2,2 Line 34 pixels down, to (121,59)
B $DEB1,3,3 Move to (70,71)
B $DEB4,2,2 Line 24 pixels down, to (70,47)
B $DEB6,3,3 Move to (46,64)
B $DEB9,2,2 Line 12 pixels down, to (46,52)
B $DEBB,3,3 Move to (83,76)
B $DEBE,2,2 Line 10 pixels right, 1 up every 2, to (93,81)
B $DEC0,3,3 Move to (166,51)
B $DEC3,2,2 Line 10 pixels right, 1 down every 4, to (176,49)
B $DEC5,2,2 Line 10 pixels right, 1 down every 4, to (186,47)
B $DEC7,3,3 Move to (161,53)
B $DECA,2,2 Line 10 pixels right, 1 down every 10, to (171,52)
B $DECC,2,2 Line 10 pixels right, 1 down every 6, to (181,51)
B $DECE,2,2 Line 10 pixels right, 1 down every 5, to (191,49)
B $DED0,3,3 Move to (255,57)
B $DED3,2,2 Line 36 pixels left, 1 up every 5, to (219,64)
B $DED5,2,2 Line 36 pixels left, 1 up every 4, to (183,73)
B $DED7,2,2 Line 25 pixels left, 1 up every 4, to (158,79)
B $DED9,3,3 Move to (92,90)
B $DEDC,2,2 Line 10 pixels left, 1 up every 6, to (82,91)
B $DEDE,3,3 Move to (71,97)
B $DEE1,2,2 Line 58 pixels left, 1 up every 12, to (13,101)
B $DEE3,2,2 Line 58 pixels left, 1 up every 13, to (0,105)
B $DEE5,3,3 Move to (255,122)
B $DEE8,2,2 Line 48 pixels left, 1 down every 5, to (207,113)
B $DEEA,2,2 Line 36 pixels left, 1 down every 8, to (171,109)
B $DEEC,2,2 Line 20 pixels left, 1 down every 8, to (151,107)
B $DEEE,2,2 Line 20 pixels left, 1 up every 3, to (131,113)
B $DEF0,2,2 Line 13 pixels left, 1 down every 2, to (118,107)
B $DEF2,2,2 Line 13 pixels left, 1 down every 6, to (105,105)
B $DEF4,2,2 Line 13 pixels left, 1 down every 4, to (92,102)
B $DEF6,2,2 Line 13 pixels left, 1 down every 4, to (79,99)
B $DEF8,3,3 Move to (170,110)
B $DEFB,2,2 Line 13 pixels left, 1 up every 2, to (157,116)
B $DEFD,2,2 Line 13 pixels left, 1 up every 5, to (144,118)
B $DEFF,2,2 Line 13 pixels left, 1 up every 6, to (131,120)
B $DF01,2,2 Line 15 pixels left, 1 up every 2, to (116,127)
B $DF03,3,3 Move to (161,115)
B $DF06,2,2 Line 13 pixels right, 1 up every 3, to (174,119)
B $DF08,2,2 Line 5 pixels right, 1 up every 2, to (179,121)
B $DF0A,2,2 Line 5 pixels diagonally down-right, to (184,116)
B $DF0C,2,2 Line 5 pixels right, 1 up every 3, to (189,117)
B $DF0E,2,2 Line 12 pixels right, 1 down every 3, to (201,113)
B $DF10,3,3 Move to (72,85)
B $DF13,2,2 Line 4 pixels down, 1 right every 4, to (73,81)
B $DF15,3,3 Move to (73,85)
B $DF18,2,2 Line 4 pixels down, 1 right every 4, to (74,81)
B $DF1A,3,3 Move to (75,85)
B $DF1D,2,2 Line 4 pixels down, 1 right every 4, to (76,81)
B $DF1F,3,3 Move to (76,85)
B $DF22,2,2 Line 4 pixels down, 1 right every 4, to (77,81)
B $DF24,3,3 Move to (72,78)
B $DF27,2,2 Line 4 pixels down, 1 right every 4, to (73,74)
B $DF29,3,3 Move to (73,78)
B $DF2C,2,2 Line 4 pixels down, 1 right every 4, to (74,74)
B $DF2E,3,3 Move to (75,78)
B $DF31,2,2 Line 4 pixels down, 1 right every 4, to (76,74)
B $DF33,3,3 Move to (76,78)
B $DF36,2,2 Line 4 pixels down, 1 right every 4, to (77,74)
B $DF38,3,3 Move to (76,71)
B $DF3B,2,2 Line 4 pixels down, 1 right every 4, to (77,67)
B $DF3D,3,3 Move to (75,71)
B $DF40,2,2 Line 4 pixels down, 1 right every 4, to (76,67)
B $DF42,3,3 Move to (73,71)
B $DF45,2,2 Line 4 pixels down, 1 right every 4, to (74,67)
B $DF47,3,3 Move to (72,71)
B $DF4A,2,2 Line 4 pixels down, 1 right every 4, to (73,67)
B $DF4C,3,3 Move to (50,60)
B $DF4F,2,2 Line 4 pixels down, 1 right every 4, to (51,56)
B $DF51,3,3 Move to (51,60)
B $DF54,2,2 Line 4 pixels down, 1 right every 4, to (52,56)
B $DF56,3,3 Move to (52,60)
B $DF59,2,2 Line 4 pixels down, 1 right every 4, to (53,56)
B $DF5B,3,3 Move to (57,60)
B $DF5E,2,2 Line 4 pixels down, 1 right every 4, to (58,56)
B $DF60,3,3 Move to (58,60)
B $DF63,2,2 Line 4 pixels down, 1 right every 4, to (59,56)
B $DF65,3,3 Move to (59,60)
B $DF68,2,2 Line 4 pixels down, 1 right every 4, to (60,56)
B $DF6A,3,3 Move to (64,60)
B $DF6D,2,2 Line 4 pixels down, 1 right every 4, to (65,56)
B $DF6F,3,3 Move to (65,60)
B $DF72,2,2 Line 4 pixels down, 1 right every 4, to (66,56)
B $DF74,3,3 Move to (66,60)
B $DF77,2,2 Line 4 pixels down, 1 right every 4, to (67,56)
B $DF79,3,3 Move to (74,56)
B $DF7C,2,2 Line 4 pixels down, 1 right every 4, to (75,52)
B $DF7E,3,3 Move to (75,57)
B $DF81,2,2 Line 4 pixels down, 1 right every 4, to (76,53)
B $DF83,3,3 Move to (76,56)
B $DF86,2,2 Line 4 pixels down, 1 right every 4, to (77,52)
B $DF88,3,3 Move to (81,56)
B $DF8B,2,2 Line 4 pixels down, 1 right every 4, to (82,52)
B $DF8D,3,3 Move to (82,57)
B $DF90,2,2 Line 4 pixels down, 1 right every 4, to (83,53)
B $DF92,3,3 Move to (83,56)
B $DF95,2,2 Line 4 pixels down, 1 right every 4, to (84,52)
B $DF97,3,3 Move to (88,56)
B $DF9A,2,2 Line 4 pixels down, 1 right every 4, to (89,52)
B $DF9C,3,3 Move to (89,57)
B $DF9F,2,2 Line 4 pixels down, 1 right every 4, to (90,53)
B $DFA1,3,3 Move to (90,56)
B $DFA4,2,2 Line 4 pixels down, 1 right every 4, to (91,52)
B $DFA6,3,3 Move to (96,56)
B $DFA9,2,2 Line 4 pixels down, 1 right every 4, to (97,52)
B $DFAB,3,3 Move to (97,57)
B $DFAE,2,2 Line 4 pixels down, 1 right every 4, to (98,53)
B $DFB0,3,3 Move to (98,56)
B $DFB3,2,2 Line 4 pixels down, 1 right every 4, to (99,52)
B $DFB5,3,3 Move to (142,70)
B $DFB8,2,2 Line 4 pixels down, 1 right every 4, to (143,66)
B $DFBA,3,3 Move to (143,70)
B $DFBD,2,2 Line 4 pixels down, 1 right every 4, to (144,66)
B $DFBF,3,3 Move to (144,70)
B $DFC2,2,2 Line 4 pixels down, 1 right every 4, to (145,66)
B $DFC4,3,3 Move to (144,62)
B $DFC7,2,2 Line 4 pixels down, 1 right every 4, to (145,58)
B $DFC9,3,3 Move to (143,62)
B $DFCC,2,2 Line 4 pixels down, 1 right every 4, to (144,58)
B $DFCE,3,3 Move to (142,62)
B $DFD1,2,2 Line 4 pixels down, 1 right every 4, to (143,58)
B $DFD3,3,3 Move to (153,62)
B $DFD6,2,2 Line 4 pixels down, 1 right every 4, to (154,58)
B $DFD8,3,3 Move to (154,62)
B $DFDB,2,2 Line 4 pixels down, 1 right every 4, to (155,58)
B $DFDD,3,3 Move to (155,63)
B $DFE0,2,2 Line 4 pixels down, 1 right every 4, to (156,59)
B $DFE2,3,3 Move to (156,63)
B $DFE5,2,2 Line 4 pixels down, 1 right every 4, to (157,59)
B $DFE7,3,3 Move to (153,69)
B $DFEA,2,2 Line 4 pixels down, 1 right every 4, to (154,65)
B $DFEC,3,3 Move to (154,69)
B $DFEF,2,2 Line 4 pixels down, 1 right every 4, to (155,65)
B $DFF1,3,3 Move to (154,69)
B $DFF4,2,2 Line 4 pixels down, 1 right every 4, to (155,65)
B $DFF6,3,3 Move to (155,70)
B $DFF9,2,2 Line 4 pixels down, 1 right every 4, to (156,66)
B $DFFB,3,3 Move to (156,70)
B $DFFE,2,2 Line 4 pixels down, 1 right every 4, to (157,66)
B $E000,3,3 Move to (132,72)
B $E003,2,2 Line 4 pixels down, 1 right every 4, to (133,68)
B $E005,3,3 Move to (133,72)
B $E008,2,2 Line 4 pixels down, 1 right every 4, to (134,68)
B $E00A,3,3 Move to (134,72)
B $E00D,2,2 Line 4 pixels down, 1 right every 4, to (135,68)
B $E00F,3,3 Move to (80,86)
B $E012,2,2 Line 4 pixels down, 1 right every 4, to (81,82)
B $E014,3,3 Move to (80,79)
B $E017,2,2 Line 4 pixels down, 1 right every 4, to (81,75)
B $E019,3,3 Fill from (134,77) in red
B $E01C,3,3 Fill from (130,63) in red
B $E01F,3,3 Fill from (73,91) in red
B $E022,3,3 Fill from (80,91) in red
B $E025,3,3 Fill from (140,127) in cyan
B $E028,3,3 Fill from (89,21) in blue
B $E02B,1,1 End of picture
b $E02C Picture: room 13 (?)
D $E02C The picture for room 13 (?). It is 29 bytes long: 10 lines, 2 moves, 1 fills and 0 painted areas. See #R$8985 for the format.
D $E02C #HTML[<img src="../images/pictures/room13.png" alt="room 13">]
D $E02C This picture has no end marker. Its last command is a move whose two coordinate bytes are the first two bytes (the colours) of the picture that follows, for room 31, so after drawing its own few details it carries straight on and draws the whole of that picture too, in its own colours. Two locations get pictures for little more than the price of one.
B $E02C,2,2 Border black, picture area black ink on yellow paper
B $E02E,3,3 Move to (132,85)
B $E031,2,2 Line 16 pixels up, 1 left every 4, to (128,101)
B $E033,2,2 Line 6 pixels diagonally up-left, to (122,107)
B $E035,2,2 Line 4 pixels up, 1 right every 4, to (123,111)
B $E037,2,2 Line 4 pixels right, 1 up every 2, to (127,113)
B $E039,2,2 Line 4 pixels right, 1 down every 3, to (131,112)
B $E03B,2,2 Line 4 pixels right, 1 down every 2, to (135,110)
B $E03D,2,2 Line 4 pixels diagonally down-right, to (139,106)
B $E03F,2,2 Line 2 pixels diagonally down-right, to (141,104)
B $E041,2,2 Line 16 pixels down, 1 right every 3, to (146,88)
B $E043,2,2 Line 15 pixels left, 1 down every 4, to (131,85)
B $E045,3,3 Fill from (132,107) in black
B $E048,1,1 Move: the two coordinate bytes are the header of the next picture, and drawing carries on into it
b $E049 Picture: room 31 (?)
D $E049 The picture for room 31 (?). It is 249 bytes long: 60 lines, 41 moves, 1 fills and 0 painted areas. See #R$8985 for the format.
D $E049 #HTML[<img src="../images/pictures/room31.png" alt="room 31">]
B $E049,2,2 Border black, picture area black ink on red paper
B $E04B,3,3 Move to (65,29)
B $E04E,2,2 Line 38 pixels up, 1 right every 38, to (66,67)
B $E050,2,2 Line 10 pixels up, 1 right every 5, to (68,77)
B $E052,2,2 Line 11 pixels up, 1 right every 4, to (70,88)
B $E054,2,2 Line 10 pixels up, 1 right every 2, to (75,98)
B $E056,2,2 Line 11 pixels diagonally up-right, to (86,109)
B $E058,2,2 Line 12 pixels right, 1 up every 4, to (98,112)
B $E05A,3,3 Move to (106,29)
B $E05D,2,2 Line 11 pixels up, to (106,40)
B $E05F,2,2 Line 4 pixels up, 1 right every 3, to (107,44)
B $E061,2,2 Line 3 pixels up, 1 right every 2, to (108,47)
B $E063,2,2 Line 4 pixels diagonally up-right, to (112,51)
B $E065,2,2 Line 5 pixels right, 1 up every 5, to (117,52)
B $E067,3,3 Move to (123,29)
B $E06A,2,2 Line 13 pixels up, 1 left every 13, to (122,42)
B $E06C,2,2 Line 5 pixels up, 1 left every 3, to (121,47)
B $E06E,2,2 Line 5 pixels diagonally up-left, to (116,52)
B $E070,3,3 Move to (64,29)
B $E073,2,2 Line 63 pixels left, 1 down every 6, to (1,19)
B $E075,3,3 Move to (64,53)
B $E078,2,2 Line 63 pixels left, 1 up every 6, to (1,63)
B $E07A,3,3 Move to (66,76)
B $E07D,2,2 Line 63 pixels left, 1 up every 3, to (3,97)
B $E07F,3,3 Move to (74,98)
B $E082,2,2 Line 63 pixels left, 1 up every 2, to (11,127)
B $E084,3,3 Move to (85,110)
B $E087,2,2 Line 63 pixels diagonally up-left, to (22,127)
B $E089,3,3 Move to (97,111)
B $E08C,2,2 Line 63 pixels up, 1 right every 7, to (106,127)
B $E08E,3,3 Move to (109,109)
B $E091,2,2 Line 63 pixels right, 1 up every 2, to (172,127)
B $E093,3,3 Move to (121,98)
B $E096,2,2 Line 63 pixels right, 1 up every 3, to (184,119)
B $E098,2,2 Line 63 pixels right, 1 up every 3, to (247,127)
B $E09A,3,3 Move to (128,76)
B $E09D,2,2 Line 63 pixels right, 1 up every 7, to (191,85)
B $E09F,2,2 Line 63 pixels right, 1 up every 7, to (254,94)
B $E0A1,3,3 Move to (130,52)
B $E0A4,2,2 Line 63 pixels right, 1 up every 19, to (193,55)
B $E0A6,2,2 Line 61 pixels right, 1 up every 19, to (254,58)
B $E0A8,3,3 Move to (130,29)
B $E0AB,2,2 Line 63 pixels right, 1 down every 7, to (193,20)
B $E0AD,2,2 Line 61 pixels right, 1 down every 7, to (254,12)
B $E0AF,3,3 Move to (51,56)
B $E0B2,2,2 Line 24 pixels up, 1 right every 7, to (54,80)
B $E0B4,3,3 Move to (65,103)
B $E0B7,2,2 Line 14 pixels diagonally up-right, to (79,117)
B $E0B9,3,3 Move to (98,117)
B $E0BC,2,2 Line 21 pixels right, 1 down every 5, to (119,113)
B $E0BE,3,3 Move to (133,100)
B $E0C1,2,2 Line 23 pixels down, 1 right every 3, to (140,77)
B $E0C3,3,3 Move to (142,51)
B $E0C6,2,2 Line 23 pixels down, 1 right every 23, to (143,28)
B $E0C8,3,3 Move to (178,53)
B $E0CB,2,2 Line 31 pixels down, to (178,22)
B $E0CD,3,3 Move to (221,55)
B $E0D0,2,2 Line 38 pixels down, 1 left every 38, to (220,17)
B $E0D2,3,3 Move to (240,58)
B $E0D5,2,2 Line 33 pixels up, 1 left every 7, to (236,91)
B $E0D7,3,3 Move to (200,56)
B $E0DA,2,2 Line 30 pixels up, 1 left every 6, to (195,86)
B $E0DC,3,3 Move to (159,54)
B $E0DF,2,2 Line 27 pixels up, 1 left every 7, to (156,81)
B $E0E1,3,3 Move to (177,83)
B $E0E4,2,2 Line 30 pixels up, 1 left every 3, to (167,113)
B $E0E6,3,3 Move to (215,89)
B $E0E9,2,2 Line 36 pixels up, 1 left every 3, to (203,125)
B $E0EB,3,3 Move to (148,108)
B $E0EE,2,2 Line 14 pixels diagonally up-left, to (134,122)
B $E0F0,3,3 Move to (184,120)
B $E0F3,2,2 Line 14 pixels diagonally up-left, to (170,127)
B $E0F5,3,3 Move to (34,25)
B $E0F8,2,2 Line 33 pixels up, 1 right every 33, to (35,58)
B $E0FA,3,3 Move to (18,61)
B $E0FD,2,2 Line 30 pixels up, 1 right every 6, to (23,91)
B $E0FF,3,3 Move to (38,86)
B $E102,2,2 Line 24 pixels up, 1 right every 2, to (50,110)
B $E104,3,3 Move to (4,97)
B $E107,2,2 Line 29 pixels up, 1 right every 2, to (18,126)
B $E109,3,3 Move to (34,118)
B $E10C,2,2 Line 29 pixels diagonally up-right, to (63,127)
B $E10E,3,3 Move to (71,125)
B $E111,2,2 Line 29 pixels right, 1 up every 5, to (100,127)
B $E113,3,3 Move to (129,29)
B $E116,2,2 Line 38 pixels up, 1 left every 38, to (128,67)
B $E118,2,2 Line 20 pixels up, 1 left every 5, to (124,87)
B $E11A,2,2 Line 11 pixels up, 1 left every 3, to (121,98)
B $E11C,2,2 Line 12 pixels diagonally up-left, to (109,110)
B $E11E,2,2 Line 12 pixels left, 1 up every 6, to (97,112)
B $E120,3,3 Move to (66,29)
B $E123,2,2 Line 63 pixels right, 1 up every 63, to (129,30)
B $E125,3,3 Move to (252,94)
B $E128,2,2 Line 63 pixels up, 1 left every 4, to (237,127)
B $E12A,3,3 Fill from (252,127) in black
B $E12D,3,3 Move to (114,47)
B $E130,2,2 Line 6 pixels down, 1 right every 6, to (115,41)
B $E132,3,3 Move to (117,47)
B $E135,2,2 Line 6 pixels down, 1 right every 6, to (118,41)
B $E137,3,3 Move to (113,46)
B $E13A,2,2 Line 6 pixels right, 1 down every 6, to (119,45)
B $E13C,3,3 Move to (113,43)
B $E13F,2,2 Line 6 pixels right, 1 down every 6, to (119,42)
B $E141,1,1 End of picture
b $E142 Picture: room 5 (?)
D $E142 The picture for room 5 (?). It is 93 bytes long: 30 lines, 6 moves, 5 fills and 0 painted areas. See #R$8985 for the format.
D $E142 #HTML[<img src="../images/pictures/room05.png" alt="room 5">]
D $E142 This picture has no end marker. Its last command is a move whose two coordinate bytes are the first two bytes (the colours) of the picture that follows, for room 28, so after drawing its own few details it carries straight on and draws the whole of that picture too, in its own colours. Two locations get pictures for little more than the price of one.
D $E142 At the start of a game the first two bytes are set to 0 (black), and at dawn (#R$A865) they become 5 and $28 (cyan), so the clearing is drawn by night until the trolls have been turned to stone, and in daylight afterwards. The daylight version:
D $E142 #HTML[<img src="../images/pictures/room05_day.png" alt="room 5 by day">]
B $E142,2,2 Border black, picture area black ink on black paper
B $E144,3,3 Move to (94,54)
B $E147,2,2 Line 26 pixels right, 1 down every 26, to (120,53)
B $E149,2,2 Line 3 pixels diagonally down-left, to (117,50)
B $E14B,2,2 Line 3 pixels diagonally down-right, to (120,47)
B $E14D,2,2 Line 3 pixels down, 1 right every 2, to (121,44)
B $E14F,2,2 Line 3 pixels down, 1 right every 3, to (122,41)
B $E151,2,2 Line 3 pixels down, to (122,38)
B $E153,2,2 Line 3 pixels down, 1 left every 3, to (121,35)
B $E155,2,2 Line 3 pixels down, 1 left every 2, to (120,32)
B $E157,2,2 Line 3 pixels diagonally down-left, to (117,29)
B $E159,2,2 Line 3 pixels left, 1 down every 2, to (114,28)
B $E15B,2,2 Line 3 pixels left, 1 down every 3, to (111,27)
B $E15D,2,2 Line 3 pixels left, to (108,27)
B $E15F,2,2 Line 3 pixels left, to (105,27)
B $E161,3,3 Move to (93,53)
B $E164,2,2 Line 4 pixels diagonally down-right, to (97,49)
B $E166,2,2 Line 3 pixels diagonally down-left, to (94,46)
B $E168,2,2 Line 3 pixels down, 1 left every 2, to (93,43)
B $E16A,2,2 Line 3 pixels down, 1 left every 3, to (92,40)
B $E16C,2,2 Line 3 pixels down, 1 right every 3, to (93,37)
B $E16E,2,2 Line 3 pixels down, 1 right every 3, to (94,34)
B $E170,2,2 Line 3 pixels down, 1 right every 2, to (95,31)
B $E172,2,2 Line 3 pixels diagonally down-right, to (98,28)
B $E174,2,2 Line 3 pixels right, 1 down every 3, to (101,27)
B $E176,2,2 Line 3 pixels right, 1 down every 3, to (104,26)
B $E178,2,2 Line 3 pixels right, 1 down every 3, to (107,25)
B $E17A,3,3 Fill from (107,33) in black
B $E17D,3,3 Fill from (107,41) in black
B $E180,3,3 Fill from (101,47) in black
B $E183,3,3 Move to (97,28)
B $E186,2,2 Line 5 pixels diagonally down-left, to (92,23)
B $E188,2,2 Line 5 pixels right, 1 up every 4, to (97,24)
B $E18A,2,2 Line 5 pixels diagonally up-right, to (102,29)
B $E18C,3,3 Move to (117,28)
B $E18F,2,2 Line 5 pixels diagonally down-right, to (122,23)
B $E191,3,3 Move to (121,23)
B $E194,2,2 Line 5 pixels left, 1 up every 3, to (116,24)
B $E196,2,2 Line 5 pixels diagonally up-left, to (111,29)
B $E198,3,3 Fill from (116,25) in black
B $E19B,3,3 Fill from (96,25) in black
B $E19E,1,1 Move: the two coordinate bytes are the header of the next picture, and drawing carries on into it
b $E19F Picture: room 28 (?)
D $E19F The picture for room 28 (?). It is 607 bytes long: 218 lines, 51 moves, 2 fills and 1 painted areas. See #R$8985 for the format.
D $E19F #HTML[<img src="../images/pictures/room28.png" alt="room 28">]
B $E19F,2,2 Border green, picture area black ink on green paper
B $E1A1,3,3 Move to (12,37)
B $E1A4,2,2 Line 4 pixels up, 1 right every 2, to (14,41)
B $E1A6,2,2 Line 4 pixels diagonally up-right, to (18,45)
B $E1A8,2,2 Line 4 pixels right, to (22,45)
B $E1AA,2,2 Line 4 pixels diagonally down-right, to (26,41)
B $E1AC,2,2 Line 4 pixels down, to (26,37)
B $E1AE,2,2 Line 4 pixels down, 1 left every 4, to (25,33)
B $E1B0,2,2 Line 4 pixels left, 1 down every 2, to (21,31)
B $E1B2,2,2 Line 4 pixels left, 1 down every 4, to (17,30)
B $E1B4,2,2 Line 4 pixels left, 1 up every 2, to (13,32)
B $E1B6,2,2 Line 4 pixels up, to (13,36)
B $E1B8,2,2 Line 5 pixels up, to (13,41)
B $E1BA,3,3 Move to (21,45)
B $E1BD,2,2 Line 57 pixels right, 1 down every 9, to (78,39)
B $E1BF,2,2 Line 4 pixels down, 1 right every 2, to (80,35)
B $E1C1,2,2 Line 3 pixels down, 1 left every 3, to (79,32)
B $E1C3,2,2 Line 3 pixels down, 1 left every 2, to (78,29)
B $E1C5,2,2 Line 61 pixels left, 1 up every 31, to (17,30)
B $E1C7,3,3 Move to (182,37)
B $E1CA,2,2 Line 44 pixels left, 1 up every 13, to (138,40)
B $E1CC,2,2 Line 3 pixels left, 1 down every 2, to (135,39)
B $E1CE,2,2 Line 3 pixels down, 1 left every 2, to (134,36)
B $E1D0,2,2 Line 3 pixels down, 1 right every 2, to (135,33)
B $E1D2,2,2 Line 3 pixels right, 1 down every 2, to (138,32)
B $E1D4,2,2 Line 46 pixels right, 1 down every 8, to (184,27)
B $E1D6,2,2 Line 5 pixels right, 1 up every 4, to (189,28)
B $E1D8,2,2 Line 5 pixels up, 1 right every 2, to (191,33)
B $E1DA,2,2 Line 3 pixels diagonally up-left, to (188,36)
B $E1DC,2,2 Line 3 pixels left, 1 up every 2, to (185,37)
B $E1DE,2,2 Line 4 pixels left, 1 down every 3, to (181,36)
B $E1E0,2,2 Line 4 pixels down, 1 left every 3, to (180,32)
B $E1E2,2,2 Line 3 pixels down, 1 right every 3, to (181,29)
B $E1E4,2,2 Line 4 pixels right, 1 down every 2, to (185,27)
B $E1E6,3,3 Move to (74,0)
B $E1E9,2,2 Line 4 pixels up, 1 left every 3, to (73,4)
B $E1EB,2,2 Line 4 pixels up, 1 right every 3, to (74,8)
B $E1ED,2,2 Line 4 pixels up, 1 right every 2, to (76,12)
B $E1EF,2,2 Line 4 pixels right, 1 up every 4, to (80,13)
B $E1F1,2,2 Line 4 pixels diagonally down-right, to (84,9)
B $E1F3,2,2 Line 4 pixels down, 1 right every 4, to (85,5)
B $E1F5,2,2 Line 4 pixels down, to (85,1)
B $E1F7,2,2 Line 4 pixels down, 1 left every 4, to (84,0)
B $E1F9,3,3 Move to (82,12)
B $E1FC,2,2 Line 63 pixels right, 1 up every 63, to (145,13)
B $E1FE,2,2 Line 63 pixels right, 1 up every 63, to (208,14)
B $E200,2,2 Line 4 pixels diagonally down-right, to (212,10)
B $E202,2,2 Line 4 pixels down, 1 right every 3, to (213,6)
B $E204,2,2 Line 4 pixels down, 1 right every 4, to (214,2)
B $E206,2,2 Line 4 pixels down, to (214,0)
B $E208,3,3 Move to (226,9)
B $E20B,2,2 Line 4 pixels diagonally down-right, to (230,5)
B $E20D,2,2 Line 4 pixels right, 1 down every 3, to (234,4)
B $E20F,2,2 Line 4 pixels right, 1 up every 3, to (238,5)
B $E211,2,2 Line 4 pixels diagonally up-right, to (242,9)
B $E213,2,2 Line 4 pixels up, 1 right every 3, to (243,13)
B $E215,3,3 Move to (242,9)
B $E218,2,2 Line 4 pixels up, 1 right every 3, to (243,13)
B $E21A,2,2 Line 4 pixels up, 1 right every 3, to (244,17)
B $E21C,2,2 Line 4 pixels up, 1 right every 4, to (245,21)
B $E21E,2,2 Line 4 pixels up, 1 left every 2, to (243,25)
B $E220,2,2 Line 4 pixels diagonally up-left, to (239,29)
B $E222,2,2 Line 4 pixels left, 1 up every 4, to (235,30)
B $E224,2,2 Line 4 pixels left, 1 down every 4, to (231,29)
B $E226,2,2 Line 4 pixels left, 1 down every 3, to (227,28)
B $E228,2,2 Line 4 pixels diagonally down-left, to (223,24)
B $E22A,2,2 Line 4 pixels down, 1 left every 2, to (221,20)
B $E22C,2,2 Line 4 pixels down, to (221,16)
B $E22E,2,2 Line 4 pixels down, 1 right every 3, to (222,12)
B $E230,2,2 Line 4 pixels diagonally down-right, to (226,8)
B $E232,3,3 Move to (227,7)
B $E235,2,2 Line 17 pixels left, 1 up every 4, to (210,11)
B $E237,3,3 Move to (203,14)
B $E23A,2,2 Line 8 pixels left, 1 up every 3, to (195,16)
B $E23C,2,2 Line 4 pixels up, 1 right every 4, to (196,20)
B $E23E,2,2 Line 4 pixels up, 1 right every 4, to (197,24)
B $E240,2,2 Line 4 pixels up, 1 right every 2, to (199,28)
B $E242,2,2 Line 4 pixels up, 1 right every 2, to (201,32)
B $E244,2,2 Line 4 pixels right, 1 up every 2, to (205,34)
B $E246,2,2 Line 4 pixels right, to (209,34)
B $E248,2,2 Line 26 pixels right, 1 down every 6, to (235,30)
B $E24A,3,3 Move to (17,46)
B $E24D,2,2 Line 9 pixels up, 1 left every 6, to (16,55)
B $E24F,2,2 Line 9 pixels up, 1 right every 7, to (17,64)
B $E251,2,2 Line 9 pixels up, 1 right every 2, to (21,73)
B $E253,2,2 Line 9 pixels up, 1 right every 9, to (22,82)
B $E255,2,2 Line 9 pixels up, 1 left every 5, to (21,91)
B $E257,2,2 Line 9 pixels up, 1 left every 4, to (19,100)
B $E259,2,2 Line 9 pixels up, 1 left every 5, to (18,109)
B $E25B,2,2 Line 9 pixels left, 1 up every 3, to (9,112)
B $E25D,2,2 Line 9 pixels left, 1 up every 3, to (0,115)
B $E25F,3,3 Move to (0,121)
B $E262,2,2 Line 9 pixels right, 1 down every 3, to (9,118)
B $E264,2,2 Line 9 pixels right, 1 down every 3, to (18,115)
B $E266,2,2 Line 9 pixels up, to (18,124)
B $E268,2,2 Line 9 pixels up, to (18,127)
B $E26A,3,3 Move to (12,35)
B $E26D,2,2 Line 17 pixels left, 1 down every 4, to (0,31)
B $E26F,3,3 Move to (36,45)
B $E272,2,2 Line 9 pixels up, 1 left every 5, to (35,54)
B $E274,2,2 Line 9 pixels up, 1 right every 9, to (36,63)
B $E276,2,2 Line 9 pixels right, 1 up every 2, to (45,67)
B $E278,2,2 Line 9 pixels diagonally up-right, to (54,76)
B $E27A,2,2 Line 9 pixels up, 1 right every 2, to (58,85)
B $E27C,2,2 Line 9 pixels down, 1 right every 2, to (62,76)
B $E27E,2,2 Line 9 pixels down, 1 right every 3, to (65,67)
B $E280,2,2 Line 9 pixels down, 1 right every 6, to (66,58)
B $E282,2,2 Line 9 pixels down, to (66,49)
B $E284,2,2 Line 9 pixels down, to (66,40)
B $E286,3,3 Move to (37,71)
B $E289,2,2 Line 9 pixels up, 1 right every 3, to (40,80)
B $E28B,2,2 Line 9 pixels up, 1 left every 6, to (39,89)
B $E28D,2,2 Line 9 pixels up, 1 left every 2, to (35,98)
B $E28F,2,2 Line 9 pixels up, 1 left every 5, to (34,107)
B $E291,2,2 Line 9 pixels up, 1 left every 4, to (32,116)
B $E293,2,2 Line 16 pixels up, 1 left every 6, to (30,127)
B $E295,2,2 Line 9 pixels up, 1 left every 6, to (29,127)
B $E297,3,3 Move to (38,72)
B $E29A,2,2 Line 6 pixels right, 1 up every 2, to (44,75)
B $E29C,2,2 Line 7 pixels diagonally up-right, to (51,82)
B $E29E,2,2 Line 7 pixels up, 1 right every 3, to (53,89)
B $E2A0,3,3 Move to (58,86)
B $E2A3,2,2 Line 7 pixels left, 1 up every 2, to (51,89)
B $E2A5,2,2 Line 7 pixels up, 1 left every 4, to (50,96)
B $E2A7,2,2 Line 7 pixels up, 1 left every 3, to (48,103)
B $E2A9,2,2 Line 7 pixels up, 1 left every 2, to (45,110)
B $E2AB,2,2 Line 7 pixels left, 1 up every 4, to (38,111)
B $E2AD,2,2 Line 7 pixels diagonally up-left, to (31,118)
B $E2AF,3,3 Move to (79,38)
B $E2B2,2,2 Line 7 pixels up, to (79,45)
B $E2B4,2,2 Line 7 pixels up, to (79,52)
B $E2B6,2,2 Line 8 pixels up, 1 left every 8, to (78,60)
B $E2B8,2,2 Line 9 pixels up, 1 left every 8, to (77,69)
B $E2BA,2,2 Line 13 pixels up, 1 left every 13, to (76,82)
B $E2BC,2,2 Line 13 pixels up, 1 right every 2, to (82,95)
B $E2BE,2,2 Line 13 pixels up, 1 right every 2, to (88,108)
B $E2C0,2,2 Line 13 pixels up, 1 right every 3, to (92,121)
B $E2C2,2,2 Line 13 pixels up, 1 right every 3, to (96,127)
B $E2C4,3,3 Move to (87,127)
B $E2C7,2,2 Line 13 pixels down, 1 left every 4, to (84,114)
B $E2C9,2,2 Line 13 pixels diagonally down-left, to (71,101)
B $E2CB,2,2 Line 6 pixels down, 1 left every 3, to (69,95)
B $E2CD,2,2 Line 6 pixels left, 1 up every 2, to (63,98)
B $E2CF,2,2 Line 6 pixels up, 1 left every 3, to (61,104)
B $E2D1,2,2 Line 6 pixels up, 1 left every 2, to (58,110)
B $E2D3,2,2 Line 6 pixels diagonally up-left, to (52,116)
B $E2D5,2,2 Line 6 pixels left, 1 up every 3, to (46,118)
B $E2D7,2,2 Line 6 pixels left, 1 up every 2, to (40,121)
B $E2D9,2,2 Line 8 pixels diagonally up-left, to (32,127)
B $E2DB,3,3 Move to (80,39)
B $E2DE,2,2 Line 34 pixels right, 1 up every 34, to (114,40)
B $E2E0,2,2 Line 23 pixels right, 1 down every 10, to (137,38)
B $E2E2,3,3 Move to (192,31)
B $E2E5,2,2 Line 7 pixels right, 1 down every 2, to (199,28)
B $E2E7,3,3 Move to (245,18)
B $E2EA,2,2 Line 14 pixels right, 1 down every 8, to (255,17)
B $E2EC,3,3 Move to (137,41)
B $E2EF,2,2 Line 14 pixels up, 1 left every 11, to (136,55)
B $E2F1,2,2 Line 14 pixels up, 1 left every 8, to (135,69)
B $E2F3,2,2 Line 14 pixels up, 1 left every 4, to (132,83)
B $E2F5,2,2 Line 14 pixels up, 1 left every 3, to (128,97)
B $E2F7,2,2 Line 14 pixels up, 1 left every 4, to (125,111)
B $E2F9,2,2 Line 14 pixels up, 1 left every 5, to (123,125)
B $E2FB,2,2 Line 14 pixels up, 1 left every 5, to (121,127)
B $E2FD,3,3 Move to (126,127)
B $E300,2,2 Line 14 pixels down, 1 right every 5, to (128,113)
B $E302,2,2 Line 14 pixels down, 1 right every 3, to (132,99)
B $E304,2,2 Line 14 pixels up, 1 right every 5, to (134,113)
B $E306,2,2 Line 14 pixels up, 1 right every 5, to (136,127)
B $E308,3,3 Move to (150,127)
B $E30B,2,2 Line 14 pixels down, 1 left every 5, to (148,113)
B $E30D,2,2 Line 14 pixels down, 1 left every 8, to (147,99)
B $E30F,2,2 Line 6 pixels right, 1 up every 3, to (153,101)
B $E311,2,2 Line 15 pixels up, 1 right every 2, to (160,116)
B $E313,3,3 Move to (162,115)
B $E316,2,2 Line 15 pixels down, 1 left every 3, to (157,100)
B $E318,2,2 Line 8 pixels down, 1 left every 4, to (155,92)
B $E31A,2,2 Line 8 pixels right, 1 up every 2, to (163,96)
B $E31C,2,2 Line 8 pixels up, 1 right every 3, to (165,104)
B $E31E,2,2 Line 17 pixels up, 1 right every 3, to (170,121)
B $E320,2,2 Line 17 pixels up, 1 right every 3, to (175,127)
B $E322,3,3 Move to (157,39)
B $E325,2,2 Line 17 pixels up, 1 right every 8, to (159,56)
B $E327,2,2 Line 17 pixels up, 1 right every 13, to (160,73)
B $E329,2,2 Line 12 pixels up, 1 left every 7, to (159,85)
B $E32B,2,2 Line 7 pixels diagonally up-right, to (166,92)
B $E32D,2,2 Line 7 pixels up, 1 right every 4, to (167,99)
B $E32F,2,2 Line 7 pixels up, 1 right every 3, to (169,106)
B $E331,2,2 Line 7 pixels up, 1 right every 4, to (170,113)
B $E333,2,2 Line 7 pixels up, 1 right every 3, to (172,120)
B $E335,2,2 Line 7 pixels up, 1 right every 3, to (174,127)
B $E337,3,3 Move to (236,31)
B $E33A,2,2 Line 23 pixels up, 1 left every 4, to (231,54)
B $E33C,2,2 Line 23 pixels up, 1 left every 3, to (224,77)
B $E33E,2,2 Line 16 pixels up, 1 left every 6, to (222,93)
B $E340,2,2 Line 16 pixels up, 1 left every 5, to (219,109)
B $E342,2,2 Line 16 pixels up, 1 left every 4, to (215,125)
B $E344,2,2 Line 16 pixels up, 1 left every 4, to (211,127)
B $E346,3,3 Move to (228,127)
B $E349,2,2 Line 16 pixels down, 1 right every 4, to (232,111)
B $E34B,2,2 Line 16 pixels down, 1 right every 3, to (237,95)
B $E34D,2,2 Line 16 pixels down, 1 right every 3, to (242,79)
B $E34F,2,2 Line 16 pixels diagonally up-right, to (255,95)
B $E351,3,3 Move to (255,80)
B $E354,2,2 Line 12 pixels down, 1 left every 2, to (249,68)
B $E356,2,2 Line 12 pixels down, 1 right every 4, to (252,56)
B $E358,2,2 Line 12 pixels down, 1 right every 2, to (255,44)
B $E35A,3,3 Move to (95,45)
B $E35D,2,2 Line 20 pixels up, 1 left every 4, to (90,65)
B $E35F,2,2 Line 20 pixels up, 1 left every 5, to (86,85)
B $E361,2,2 Line 20 pixels up, 1 right every 20, to (87,105)
B $E363,3,3 Move to (83,113)
B $E366,2,2 Line 20 pixels up, 1 left every 2, to (73,127)
B $E368,3,3 Move to (106,44)
B $E36B,2,2 Line 20 pixels up, 1 left every 8, to (104,64)
B $E36D,2,2 Line 20 pixels up, 1 left every 14, to (103,84)
B $E36F,2,2 Line 20 pixels up, 1 right every 8, to (105,104)
B $E371,2,2 Line 18 pixels diagonally up-right, to (123,122)
B $E373,3,3 Move to (101,112)
B $E376,2,2 Line 18 pixels diagonally up-right, to (119,127)
B $E378,3,3 Move to (100,112)
B $E37B,2,2 Line 8 pixels diagonally up-left, to (92,120)
B $E37D,3,3 Move to (86,124)
B $E380,2,2 Line 8 pixels diagonally up-left, to (78,127)
B $E382,3,3 Move to (100,112)
B $E385,2,2 Line 7 pixels down, 1 left every 3, to (98,105)
B $E387,3,3 Move to (69,95)
B $E38A,2,2 Line 7 pixels down, 1 left every 3, to (67,88)
B $E38C,3,3 Move to (37,70)
B $E38F,2,2 Line 8 pixels down, 1 left every 3, to (35,62)
B $E391,3,3 Move to (19,115)
B $E394,2,2 Line 3 pixels right, 1 down every 2, to (22,114)
B $E396,2,2 Line 3 pixels down, 1 left every 2, to (21,111)
B $E398,2,2 Line 3 pixels diagonally down-left, to (18,108)
B $E39A,3,3 Move to (132,101)
B $E39D,2,2 Line 10 pixels down, 1 right every 3, to (135,91)
B $E39F,3,3 Move to (147,98)
B $E3A2,2,2 Line 7 pixels down, 1 right every 3, to (149,91)
B $E3A4,2,2 Line 7 pixels right, 1 up every 5, to (156,92)
B $E3A6,3,3 Move to (243,77)
B $E3A9,2,2 Line 7 pixels down, 1 right every 3, to (245,70)
B $E3AB,3,3 Move to (95,44)
B $E3AE,2,2 Line 7 pixels right, 1 down every 5, to (102,43)
B $E3B0,2,2 Line 5 pixels right, 1 down every 5, to (107,42)
B $E3B2,3,3 Move to (185,42)
B $E3B5,2,2 Line 5 pixels right, 1 down every 4, to (190,41)
B $E3B7,2,2 Line 5 pixels right, 1 down every 3, to (195,40)
B $E3B9,2,2 Line 5 pixels right, 1 down every 4, to (200,39)
B $E3BB,2,2 Line 5 pixels right, 1 down every 5, to (205,38)
B $E3BD,2,2 Line 35 pixels up, 1 right every 11, to (208,73)
B $E3BF,2,2 Line 35 pixels up, 1 left every 8, to (204,108)
B $E3C1,2,2 Line 35 pixels up, 1 left every 3, to (193,127)
B $E3C3,3,3 Move to (185,43)
B $E3C6,2,2 Line 38 pixels up, 1 right every 14, to (187,81)
B $E3C8,2,2 Line 19 pixels diagonally up-left, to (168,100)
B $E3CA,3,3 Move to (164,104)
B $E3CD,2,2 Line 19 pixels up, 1 left every 5, to (161,123)
B $E3CF,2,2 Line 19 pixels up, 1 left every 5, to (158,127)
B $E3D1,3,3 Move to (193,86)
B $E3D4,2,2 Line 24 pixels diagonally up-left, to (169,110)
B $E3D6,3,3 Move to (167,112)
B $E3D9,2,2 Line 50 pixels up, 1 left every 10, to (162,127)
B $E3DB,3,3 Move to (189,91)
B $E3DE,2,2 Line 29 pixels up, 1 left every 7, to (185,120)
B $E3E0,2,2 Line 29 pixels up, 1 left every 2, to (171,127)
B $E3E2,3,3 Fill from (219,6) in red
B $E3E5,3,3 Move to (79,15)
B $E3E8,2,2 Line 25 pixels up, 1 right every 25, to (80,40)
B $E3EA,3,3 Move to (79,15)
B $E3ED,2,2 Line 57 pixels right, 1 up every 57, to (136,16)
B $E3EF,2,2 Line 17 pixels up, 1 right every 17, to (137,33)
B $E3F1,9,9 Paint red paper from cell (10,11): 6 right, 2 down, 6 left, 1 up, 6 right
B $E3FA,3,3 Fill from (144,16) in red
B $E3FD,1,1 End of picture
b $E3FE Picture: room 4 (?)
D $E3FE The picture for room 4 (?). It is 124 bytes long: 35 lines, 15 moves, 2 fills and 0 painted areas. See #R$8985 for the format.
D $E3FE #HTML[<img src="../images/pictures/room04.png" alt="room 4">]
B $E3FE,2,2 Border white, picture area black ink on yellow paper
B $E400,3,3 Move to (0,38)
B $E403,2,2 Line 63 pixels right, 1 up every 16, to (63,41)
B $E405,2,2 Line 51 pixels right, 1 up every 16, to (114,44)
B $E407,2,2 Line 8 pixels diagonally up-left, to (106,52)
B $E409,2,2 Line 58 pixels right, 1 up every 38, to (164,53)
B $E40B,2,2 Line 58 pixels right, 1 down every 9, to (222,47)
B $E40D,2,2 Line 57 pixels right, 1 up every 18, to (255,50)
B $E40F,3,3 Move to (101,44)
B $E412,2,2 Line 9 pixels up, 1 right every 2, to (105,53)
B $E414,3,3 Move to (101,43)
B $E417,2,2 Line 9 pixels up, 1 right every 2, to (105,52)
B $E419,3,3 Move to (0,63)
B $E41C,2,2 Line 63 pixels right, 1 up every 8, to (63,70)
B $E41E,2,2 Line 63 pixels right, 1 up every 22, to (126,72)
B $E420,2,2 Line 63 pixels right, 1 up every 22, to (189,74)
B $E422,2,2 Line 63 pixels right, 1 down every 16, to (252,71)
B $E424,2,2 Line 63 pixels right, 1 down every 16, to (255,68)
B $E426,3,3 Move to (255,81)
B $E429,2,2 Line 27 pixels left, 1 up every 3, to (228,90)
B $E42B,2,2 Line 27 pixels left, 1 up every 8, to (201,93)
B $E42D,2,2 Line 27 pixels left, 1 down every 4, to (174,87)
B $E42F,2,2 Line 27 pixels left, 1 down every 4, to (147,81)
B $E431,3,3 Move to (168,87)
B $E434,2,2 Line 27 pixels left, 1 up every 12, to (141,89)
B $E436,2,2 Line 27 pixels left, 1 up every 3, to (114,98)
B $E438,2,2 Line 27 pixels left, 1 up every 8, to (87,101)
B $E43A,2,2 Line 27 pixels left, 1 down every 6, to (60,97)
B $E43C,2,2 Line 27 pixels left, 1 down every 6, to (33,93)
B $E43E,2,2 Line 27 pixels left, 1 down every 10, to (6,91)
B $E440,2,2 Line 27 pixels left, 1 down every 10, to (0,89)
B $E442,3,3 Move to (22,93)
B $E445,2,2 Line 27 pixels left, 1 up every 3, to (0,102)
B $E447,3,3 Move to (184,90)
B $E44A,2,2 Line 27 pixels left, 1 up every 3, to (157,99)
B $E44C,2,2 Line 27 pixels left, 1 up every 10, to (130,101)
B $E44E,2,2 Line 27 pixels left, 1 down every 7, to (103,98)
B $E450,3,3 Move to (230,90)
B $E453,2,2 Line 27 pixels right, 1 up every 8, to (255,93)
B $E455,3,3 Move to (197,57)
B $E458,2,2 Line 27 pixels up, 1 right every 7, to (200,84)
B $E45A,3,3 Move to (197,68)
B $E45D,2,2 Line 15 pixels up, 1 left every 4, to (194,83)
B $E45F,3,3 Move to (200,74)
B $E462,2,2 Line 11 pixels up, 1 right every 2, to (205,85)
B $E464,3,3 Move to (203,78)
B $E467,2,2 Line 4 pixels right, 1 up every 3, to (207,79)
B $E469,3,3 Move to (196,78)
B $E46C,2,2 Line 4 pixels up, 1 right every 3, to (197,82)
B $E46E,3,3 Move to (195,72)
B $E471,2,2 Line 4 pixels left, 1 up every 2, to (191,74)
B $E473,3,3 Fill from (183,98) in blue
B $E476,3,3 Fill from (149,33) in green
B $E479,1,1 End of picture
b $E47A Picture: room 32 (?)
D $E47A The picture for room 32 (?). It is 618 bytes long: 216 lines, 52 moves, 9 fills and 0 painted areas. See #R$8985 for the format.
D $E47A #HTML[<img src="../images/pictures/room32.png" alt="room 32">]
B $E47A,2,2 Border blue, picture area black ink on blue paper
B $E47C,3,3 Move to (38,0)
B $E47F,2,2 Line 5 pixels diagonally up-right, to (43,5)
B $E481,2,2 Line 5 pixels right, 1 up every 2, to (48,7)
B $E483,2,2 Line 5 pixels right, 1 up every 3, to (53,8)
B $E485,2,2 Line 5 pixels right, 1 up every 3, to (58,9)
B $E487,2,2 Line 5 pixels right, 1 up every 4, to (63,10)
B $E489,2,2 Line 5 pixels right, 1 up every 4, to (68,11)
B $E48B,2,2 Line 5 pixels right, 1 up every 5, to (73,12)
B $E48D,2,2 Line 5 pixels right, 1 up every 5, to (78,13)
B $E48F,2,2 Line 5 pixels right, to (83,13)
B $E491,2,2 Line 5 pixels right, to (88,13)
B $E493,2,2 Line 5 pixels right, 1 down every 5, to (93,12)
B $E495,2,2 Line 5 pixels right, 1 down every 5, to (98,11)
B $E497,2,2 Line 5 pixels right, 1 down every 4, to (103,10)
B $E499,2,2 Line 5 pixels right, 1 down every 4, to (108,9)
B $E49B,2,2 Line 5 pixels right, 1 down every 3, to (113,8)
B $E49D,2,2 Line 6 pixels right, 1 down every 3, to (119,6)
B $E49F,2,2 Line 6 pixels right, 1 down every 2, to (125,3)
B $E4A1,2,2 Line 5 pixels diagonally down-right, to (130,0)
B $E4A3,3,3 Move to (115,9)
B $E4A6,2,2 Line 21 pixels up, 1 right every 5, to (119,30)
B $E4A8,2,2 Line 4 pixels diagonally up-right, to (123,34)
B $E4AA,2,2 Line 6 pixels right, 1 up every 3, to (129,36)
B $E4AC,2,2 Line 5 pixels right, 1 up every 5, to (134,37)
B $E4AE,2,2 Line 5 pixels right, 1 up every 5, to (139,38)
B $E4B0,2,2 Line 5 pixels right, to (144,38)
B $E4B2,2,2 Line 5 pixels right, to (149,38)
B $E4B4,2,2 Line 4 pixels right, 1 down every 4, to (153,37)
B $E4B6,2,2 Line 4 pixels right, to (157,37)
B $E4B8,2,2 Line 4 pixels right, 1 down every 4, to (161,36)
B $E4BA,2,2 Line 5 pixels right, 1 down every 5, to (166,35)
B $E4BC,2,2 Line 5 pixels right, 1 down every 5, to (171,34)
B $E4BE,2,2 Line 5 pixels right, 1 down every 5, to (176,33)
B $E4C0,2,2 Line 5 pixels right, 1 down every 3, to (181,32)
B $E4C2,2,2 Line 4 pixels down, 1 right every 2, to (183,28)
B $E4C4,2,2 Line 4 pixels down, 1 left every 2, to (181,24)
B $E4C6,2,2 Line 5 pixels left, 1 down every 3, to (176,23)
B $E4C8,2,2 Line 5 pixels left, 1 down every 4, to (171,22)
B $E4CA,2,2 Line 5 pixels left, 1 down every 5, to (166,21)
B $E4CC,2,2 Line 5 pixels left, 1 down every 5, to (161,20)
B $E4CE,2,2 Line 5 pixels left, to (156,20)
B $E4D0,2,2 Line 5 pixels left, to (151,20)
B $E4D2,2,2 Line 5 pixels left, 1 up every 4, to (146,21)
B $E4D4,2,2 Line 5 pixels left, 1 up every 4, to (141,22)
B $E4D6,2,2 Line 5 pixels left, 1 up every 4, to (136,23)
B $E4D8,2,2 Line 5 pixels left, 1 up every 4, to (131,24)
B $E4DA,2,2 Line 5 pixels left, 1 up every 4, to (126,25)
B $E4DC,2,2 Line 5 pixels left, 1 up every 2, to (121,27)
B $E4DE,2,2 Line 3 pixels diagonally up-left, to (118,30)
B $E4E0,3,3 Move to (183,27)
B $E4E3,2,2 Line 30 pixels down, 1 right every 9, to (186,0)
B $E4E5,3,3 Move to (205,40)
B $E4E8,2,2 Line 9 pixels right, 1 down every 4, to (214,38)
B $E4EA,2,2 Line 9 pixels right, 1 down every 5, to (223,37)
B $E4EC,2,2 Line 10 pixels right, 1 down every 7, to (233,36)
B $E4EE,2,2 Line 10 pixels right, 1 up every 10, to (243,37)
B $E4F0,2,2 Line 13 pixels right, 1 up every 8, to (255,38)
B $E4F2,3,3 Move to (205,40)
B $E4F5,2,2 Line 9 pixels up, 1 left every 2, to (201,49)
B $E4F7,2,2 Line 9 pixels up, 1 left every 4, to (199,58)
B $E4F9,2,2 Line 9 pixels up, 1 left every 5, to (198,67)
B $E4FB,2,2 Line 9 pixels up, to (198,76)
B $E4FD,2,2 Line 9 pixels up, 1 right every 5, to (199,85)
B $E4FF,2,2 Line 9 pixels up, 1 right every 4, to (201,94)
B $E501,2,2 Line 9 pixels up, 1 right every 3, to (204,103)
B $E503,2,2 Line 8 pixels right, 1 up every 8, to (212,104)
B $E505,2,2 Line 9 pixels right, 1 up every 9, to (221,105)
B $E507,2,2 Line 9 pixels right, to (230,105)
B $E509,2,2 Line 9 pixels right, 1 down every 9, to (239,104)
B $E50B,2,2 Line 9 pixels right, 1 down every 9, to (248,103)
B $E50D,2,2 Line 9 pixels right, 1 down every 9, to (255,102)
B $E50F,3,3 Move to (204,102)
B $E512,2,2 Line 9 pixels right, 1 down every 8, to (213,101)
B $E514,2,2 Line 9 pixels right, 1 down every 9, to (222,100)
B $E516,2,2 Line 9 pixels right, to (231,100)
B $E518,2,2 Line 9 pixels right, to (240,100)
B $E51A,2,2 Line 9 pixels right, 1 up every 9, to (249,101)
B $E51C,2,2 Line 9 pixels right, 1 up every 9, to (255,102)
B $E51E,3,3 Move to (200,52)
B $E521,2,2 Line 9 pixels left, 1 down every 6, to (191,51)
B $E523,2,2 Line 9 pixels left, to (182,51)
B $E525,2,2 Line 9 pixels left, 1 up every 4, to (173,53)
B $E527,2,2 Line 9 pixels up, 1 left every 2, to (169,62)
B $E529,2,2 Line 10 pixels up, 1 left every 5, to (167,72)
B $E52B,2,2 Line 9 pixels up, to (167,81)
B $E52D,2,2 Line 9 pixels up, 1 right every 5, to (168,90)
B $E52F,2,2 Line 9 pixels up, 1 right every 4, to (170,99)
B $E531,2,2 Line 8 pixels up, 1 right every 3, to (172,107)
B $E533,2,2 Line 9 pixels right, 1 up every 4, to (181,109)
B $E535,2,2 Line 6 pixels right, 1 up every 6, to (187,110)
B $E537,2,2 Line 7 pixels right, 1 down every 7, to (194,109)
B $E539,2,2 Line 9 pixels right, 1 down every 6, to (203,108)
B $E53B,2,2 Line 5 pixels right, 1 down every 2, to (208,106)
B $E53D,2,2 Line 3 pixels down, 1 right every 2, to (209,103)
B $E53F,3,3 Move to (173,107)
B $E542,2,2 Line 5 pixels right, 1 down every 4, to (178,106)
B $E544,2,2 Line 5 pixels right, 1 down every 5, to (183,105)
B $E546,2,2 Line 5 pixels right, to (188,105)
B $E548,2,2 Line 5 pixels right, 1 up every 5, to (193,106)
B $E54A,2,2 Line 5 pixels right, to (198,106)
B $E54C,2,2 Line 5 pixels right, to (203,106)
B $E54E,2,2 Line 5 pixels right, to (208,106)
B $E550,3,3 Move to (46,0)
B $E553,2,2 Line 3 pixels diagonally up-right, to (49,3)
B $E555,2,2 Line 5 pixels right, 1 up every 4, to (54,4)
B $E557,2,2 Line 5 pixels right, 1 up every 5, to (59,5)
B $E559,2,2 Line 5 pixels right, 1 up every 5, to (64,6)
B $E55B,2,2 Line 5 pixels right, 1 up every 5, to (69,7)
B $E55D,2,2 Line 5 pixels right, 1 up every 5, to (74,8)
B $E55F,2,2 Line 5 pixels right, to (79,8)
B $E561,2,2 Line 5 pixels right, to (84,8)
B $E563,2,2 Line 5 pixels right, 1 down every 5, to (89,7)
B $E565,2,2 Line 5 pixels right, 1 down every 4, to (94,6)
B $E567,2,2 Line 5 pixels right, 1 down every 4, to (99,5)
B $E569,2,2 Line 5 pixels right, 1 down every 5, to (104,4)
B $E56B,2,2 Line 5 pixels right, 1 down every 4, to (109,3)
B $E56D,2,2 Line 5 pixels right, 1 down every 3, to (114,2)
B $E56F,2,2 Line 5 pixels right, 1 down every 2, to (119,0)
B $E571,3,3 Fill from (122,0) in black
B $E574,3,3 Move to (58,0)
B $E577,2,2 Line 5 pixels diagonally up-right, to (63,5)
B $E579,3,3 Move to (68,0)
B $E57C,2,2 Line 8 pixels diagonally up-right, to (76,8)
B $E57E,3,3 Move to (79,0)
B $E581,2,2 Line 8 pixels diagonally up-right, to (87,8)
B $E583,3,3 Move to (90,0)
B $E586,2,2 Line 8 pixels diagonally up-right, to (98,8)
B $E588,3,3 Move to (102,0)
B $E58B,2,2 Line 8 pixels diagonally up-right, to (110,8)
B $E58D,3,3 Move to (125,26)
B $E590,2,2 Line 4 pixels up, 1 right every 3, to (126,30)
B $E592,2,2 Line 4 pixels right, 1 up every 2, to (130,32)
B $E594,2,2 Line 4 pixels right, 1 up every 3, to (134,33)
B $E596,2,2 Line 4 pixels right, 1 up every 4, to (138,34)
B $E598,2,2 Line 4 pixels right, to (142,34)
B $E59A,2,2 Line 4 pixels right, to (146,34)
B $E59C,2,2 Line 4 pixels right, to (150,34)
B $E59E,2,2 Line 4 pixels right, 1 down every 4, to (154,33)
B $E5A0,2,2 Line 4 pixels right, 1 down every 4, to (158,32)
B $E5A2,2,2 Line 4 pixels right, to (162,32)
B $E5A4,2,2 Line 4 pixels right, 1 down every 4, to (166,31)
B $E5A6,2,2 Line 4 pixels right, 1 down every 4, to (170,30)
B $E5A8,2,2 Line 4 pixels right, 1 down every 4, to (174,29)
B $E5AA,2,2 Line 4 pixels right, 1 down every 2, to (178,27)
B $E5AC,2,2 Line 4 pixels down, 1 left every 3, to (177,23)
B $E5AE,3,3 Fill from (180,27) in black
B $E5B1,3,3 Move to (135,24)
B $E5B4,2,2 Line 8 pixels diagonally up-left, to (127,32)
B $E5B6,3,3 Move to (146,22)
B $E5B9,2,2 Line 11 pixels diagonally up-left, to (135,33)
B $E5BB,3,3 Move to (156,21)
B $E5BE,2,2 Line 14 pixels diagonally up-left, to (142,35)
B $E5C0,3,3 Move to (166,23)
B $E5C3,2,2 Line 14 pixels diagonally up-left, to (152,37)
B $E5C5,3,3 Move to (175,23)
B $E5C8,2,2 Line 14 pixels diagonally up-left, to (161,37)
B $E5CA,3,3 Fill from (182,107) in black
B $E5CD,3,3 Fill from (234,104) in black
B $E5D0,3,3 Move to (124,5)
B $E5D3,2,2 Line 21 pixels up, 1 right every 7, to (127,26)
B $E5D5,3,3 Move to (134,0)
B $E5D8,2,2 Line 23 pixels up, 1 right every 8, to (136,23)
B $E5DA,3,3 Move to (148,0)
B $E5DD,2,2 Line 21 pixels up, 1 right every 16, to (149,21)
B $E5DF,3,3 Move to (163,0)
B $E5E2,2,2 Line 21 pixels up, 1 left every 16, to (162,21)
B $E5E4,3,3 Move to (175,0)
B $E5E7,2,2 Line 22 pixels up, 1 left every 9, to (173,22)
B $E5E9,3,3 Move to (177,53)
B $E5EC,2,2 Line 9 pixels up, 1 left every 3, to (174,62)
B $E5EE,2,2 Line 9 pixels up, 1 left every 5, to (173,71)
B $E5F0,2,2 Line 9 pixels up, 1 left every 9, to (172,80)
B $E5F2,2,2 Line 9 pixels up, 1 right every 6, to (173,89)
B $E5F4,2,2 Line 9 pixels up, 1 right every 4, to (175,98)
B $E5F6,2,2 Line 9 pixels up, 1 right every 4, to (177,107)
B $E5F8,3,3 Move to (184,52)
B $E5FB,2,2 Line 9 pixels up, 1 left every 5, to (183,61)
B $E5FD,2,2 Line 9 pixels up, 1 left every 6, to (182,70)
B $E5FF,2,2 Line 9 pixels up, 1 left every 9, to (181,79)
B $E601,2,2 Line 9 pixels up, to (181,88)
B $E603,2,2 Line 9 pixels up, 1 right every 6, to (182,97)
B $E605,2,2 Line 8 pixels up, 1 right every 4, to (184,105)
B $E607,3,3 Move to (192,52)
B $E60A,2,2 Line 25 pixels up, 1 left every 25, to (191,77)
B $E60C,2,2 Line 28 pixels up, 1 left every 28, to (190,105)
B $E60E,3,3 Move to (200,96)
B $E611,2,2 Line 10 pixels up, 1 left every 8, to (199,106)
B $E613,3,3 Move to (205,104)
B $E616,2,2 Line 3 pixels diagonally up-left, to (202,107)
B $E618,3,3 Move to (211,40)
B $E61B,2,2 Line 7 pixels up, 1 left every 2, to (208,47)
B $E61D,2,2 Line 7 pixels up, 1 left every 3, to (206,54)
B $E61F,2,2 Line 7 pixels up, 1 left every 4, to (205,61)
B $E621,2,2 Line 7 pixels up, 1 left every 5, to (204,68)
B $E623,2,2 Line 7 pixels up, 1 left every 7, to (203,75)
B $E625,2,2 Line 7 pixels up, 1 right every 6, to (204,82)
B $E627,2,2 Line 7 pixels up, 1 right every 5, to (205,89)
B $E629,2,2 Line 7 pixels up, 1 right every 3, to (207,96)
B $E62B,2,2 Line 7 pixels up, 1 right every 3, to (209,103)
B $E62D,3,3 Move to (220,38)
B $E630,2,2 Line 7 pixels up, 1 left every 3, to (218,45)
B $E632,2,2 Line 7 pixels up, 1 left every 4, to (217,52)
B $E634,2,2 Line 7 pixels up, 1 left every 4, to (216,59)
B $E636,2,2 Line 7 pixels up, 1 left every 6, to (215,66)
B $E638,2,2 Line 7 pixels up, to (215,73)
B $E63A,2,2 Line 7 pixels up, 1 right every 7, to (216,80)
B $E63C,2,2 Line 7 pixels up, 1 right every 7, to (217,87)
B $E63E,2,2 Line 7 pixels up, 1 right every 6, to (218,94)
B $E640,2,2 Line 7 pixels up, 1 right every 4, to (219,101)
B $E642,3,3 Move to (236,37)
B $E645,2,2 Line 63 pixels up, 1 left every 32, to (235,100)
B $E647,3,3 Move to (252,39)
B $E64A,2,2 Line 16 pixels up, 1 right every 9, to (253,55)
B $E64C,2,2 Line 16 pixels up, to (253,71)
B $E64E,2,2 Line 16 pixels up, 1 left every 9, to (252,87)
B $E650,2,2 Line 15 pixels up, 1 left every 6, to (250,102)
B $E652,3,3 Move to (0,35)
B $E655,2,2 Line 63 pixels right, 1 down every 7, to (63,26)
B $E657,2,2 Line 54 pixels right, 1 up every 3, to (117,44)
B $E659,3,3 Move to (0,36)
B $E65C,2,2 Line 53 pixels right, 1 up every 3, to (53,53)
B $E65E,2,2 Line 63 pixels right, 1 down every 6, to (116,43)
B $E660,3,3 Move to (55,53)
B $E663,2,2 Line 12 pixels down, 1 right every 12, to (56,41)
B $E665,2,2 Line 30 pixels left, 1 down every 3, to (26,31)
B $E667,3,3 Move to (55,41)
B $E66A,2,2 Line 35 pixels right, 1 down every 6, to (90,36)
B $E66C,3,3 Move to (0,37)
B $E66F,2,2 Line 54 pixels right, 1 up every 3, to (54,55)
B $E671,2,2 Line 32 pixels up, 1 right every 3, to (64,87)
B $E673,2,2 Line 52 pixels left, 1 down every 4, to (12,74)
B $E675,2,2 Line 37 pixels down, 1 left every 3, to (0,37)
B $E677,3,3 Move to (13,74)
B $E67A,2,2 Line 7 pixels diagonally up-left, to (6,81)
B $E67C,2,2 Line 28 pixels down, 1 left every 3, to (0,53)
B $E67E,3,3 Move to (7,82)
B $E681,2,2 Line 51 pixels right, 1 up every 4, to (58,94)
B $E683,2,2 Line 8 pixels diagonally down-right, to (66,86)
B $E685,3,3 Move to (30,48)
B $E688,2,2 Line 33 pixels up, 1 right every 3, to (41,81)
B $E68A,3,3 Move to (41,82)
B $E68D,2,2 Line 7 pixels diagonally up-left, to (34,89)
B $E68F,3,3 Move to (15,43)
B $E692,2,2 Line 36 pixels up, 1 right every 3, to (27,79)
B $E694,2,2 Line 6 pixels diagonally up-left, to (21,85)
B $E696,3,3 Move to (43,52)
B $E699,2,2 Line 33 pixels up, 1 right every 3, to (54,85)
B $E69B,2,2 Line 8 pixels diagonally up-left, to (46,93)
B $E69D,3,3 Move to (42,91)
B $E6A0,2,2 Line 13 pixels up, 1 left every 5, to (40,104)
B $E6A2,3,3 Move to (58,64)
B $E6A5,2,2 Line 55 pixels right, 1 up every 4, to (113,77)
B $E6A7,2,2 Line 55 pixels up, 1 right every 51, to (114,127)
B $E6A9,3,3 Move to (113,77)
B $E6AC,2,2 Line 55 pixels right, 1 down every 10, to (168,72)
B $E6AE,3,3 Move to (39,104)
B $E6B1,2,2 Line 55 pixels left, 1 down every 5, to (0,93)
B $E6B3,3,3 Fill from (34,93) in black
B $E6B6,3,3 Fill from (66,35) in cyan
B $E6B9,3,3 Move to (206,40)
B $E6BC,2,2 Line 19 pixels left, 1 up every 5, to (187,43)
B $E6BE,2,2 Line 13 pixels left, 1 up every 4, to (174,46)
B $E6C0,2,2 Line 13 pixels left, 1 up every 2, to (161,52)
B $E6C2,2,2 Line 9 pixels left, 1 up every 2, to (152,56)
B $E6C4,2,2 Line 9 pixels right, 1 up every 3, to (161,59)
B $E6C6,2,2 Line 9 pixels right, 1 up every 4, to (170,61)
B $E6C8,3,3 Fill from (197,47) in black
B $E6CB,3,3 Move to (165,61)
B $E6CE,2,2 Line 9 pixels left, 1 up every 2, to (156,65)
B $E6D0,2,2 Line 9 pixels left, 1 up every 2, to (147,69)
B $E6D2,2,2 Line 10 pixels right, 1 up every 3, to (157,72)
B $E6D4,3,3 Fill from (165,69) in black
B $E6D7,3,3 Move to (116,23)
B $E6DA,2,2 Line 9 pixels left, 1 down every 3, to (107,20)
B $E6DC,2,2 Line 9 pixels left, 1 down every 2, to (98,16)
B $E6DE,2,2 Line 9 pixels left, 1 down every 2, to (89,12)
B $E6E0,3,3 Fill from (108,12) in black
B $E6E3,1,1 End of picture
b $E6E4 Picture: room 16 (?)
D $E6E4 The picture for room 16 (?). It is 778 bytes long: 284 lines, 52 moves, 17 fills and 0 painted areas. See #R$8985 for the format.
D $E6E4 #HTML[<img src="../images/pictures/room16.png" alt="room 16">]
B $E6E4,2,2 Border yellow, picture area black ink on yellow paper
B $E6E6,3,3 Move to (112,55)
B $E6E9,2,2 Line 3 pixels up, 1 right every 3, to (113,58)
B $E6EB,2,2 Line 3 pixels up, 1 right every 2, to (114,61)
B $E6ED,2,2 Line 3 pixels diagonally up-right, to (117,64)
B $E6EF,2,2 Line 3 pixels right, 1 up every 2, to (120,65)
B $E6F1,2,2 Line 3 pixels right, 1 up every 3, to (123,66)
B $E6F3,2,2 Line 3 pixels right, to (126,66)
B $E6F5,3,3 Move to (139,55)
B $E6F8,2,2 Line 3 pixels up, 1 left every 3, to (138,58)
B $E6FA,2,2 Line 3 pixels up, 1 left every 2, to (137,61)
B $E6FC,2,2 Line 3 pixels diagonally up-left, to (134,64)
B $E6FE,2,2 Line 3 pixels left, 1 up every 2, to (131,65)
B $E700,2,2 Line 3 pixels left, 1 up every 3, to (128,66)
B $E702,2,2 Line 3 pixels left, to (125,66)
B $E704,3,3 Move to (112,54)
B $E707,2,2 Line 3 pixels down, 1 right every 3, to (113,51)
B $E709,2,2 Line 3 pixels down, 1 right every 2, to (114,48)
B $E70B,2,2 Line 3 pixels diagonally down-right, to (117,45)
B $E70D,2,2 Line 3 pixels right, 1 down every 2, to (120,44)
B $E70F,2,2 Line 3 pixels right, 1 down every 3, to (123,43)
B $E711,2,2 Line 3 pixels right, to (126,43)
B $E713,3,3 Move to (139,54)
B $E716,2,2 Line 3 pixels down, 1 left every 3, to (138,51)
B $E718,2,2 Line 3 pixels down, 1 left every 2, to (137,48)
B $E71A,2,2 Line 3 pixels diagonally down-left, to (134,45)
B $E71C,2,2 Line 3 pixels left, 1 down every 2, to (131,44)
B $E71E,2,2 Line 3 pixels left, 1 down every 3, to (128,43)
B $E720,2,2 Line 3 pixels left, to (125,43)
B $E722,3,3 Move to (101,65)
B $E725,2,2 Line 8 pixels up, 1 right every 8, to (102,73)
B $E727,2,2 Line 8 pixels up, 1 right every 3, to (104,81)
B $E729,2,2 Line 5 pixels diagonally up-right, to (109,86)
B $E72B,2,2 Line 5 pixels right, 1 up every 2, to (114,88)
B $E72D,2,2 Line 5 pixels right, 1 up every 3, to (119,89)
B $E72F,2,2 Line 5 pixels right, 1 up every 3, to (124,90)
B $E731,2,2 Line 5 pixels right, 1 up every 4, to (129,91)
B $E733,2,2 Line 5 pixels right, 1 up every 5, to (134,92)
B $E735,3,3 Move to (160,65)
B $E738,2,2 Line 8 pixels up, 1 left every 8, to (159,73)
B $E73A,2,2 Line 8 pixels up, 1 left every 3, to (157,81)
B $E73C,2,2 Line 5 pixels diagonally up-left, to (152,86)
B $E73E,2,2 Line 5 pixels left, 1 up every 2, to (147,88)
B $E740,2,2 Line 5 pixels left, 1 up every 3, to (142,89)
B $E742,2,2 Line 5 pixels left, 1 up every 3, to (137,90)
B $E744,2,2 Line 5 pixels left, 1 up every 3, to (132,91)
B $E746,3,3 Move to (101,64)
B $E749,2,2 Line 9 pixels down, 1 right every 9, to (102,55)
B $E74B,2,2 Line 9 pixels down, 1 right every 3, to (105,46)
B $E74D,2,2 Line 6 pixels diagonally down-right, to (111,40)
B $E74F,2,2 Line 4 pixels right, 1 down every 2, to (115,38)
B $E751,3,3 Move to (160,64)
B $E754,2,2 Line 10 pixels down, 1 left every 10, to (159,54)
B $E756,2,2 Line 9 pixels down, 1 left every 3, to (156,45)
B $E758,2,2 Line 6 pixels diagonally down-left, to (150,39)
B $E75A,2,2 Line 7 pixels left, 1 down every 2, to (143,36)
B $E75C,2,2 Line 11 pixels left, 1 down every 6, to (132,35)
B $E75E,3,3 Move to (66,64)
B $E761,2,2 Line 12 pixels up, 1 right every 12, to (67,76)
B $E763,2,2 Line 10 pixels up, 1 right every 4, to (69,86)
B $E765,2,2 Line 10 pixels up, 1 right every 2, to (74,96)
B $E767,2,2 Line 10 pixels diagonally up-right, to (84,106)
B $E769,2,2 Line 10 pixels right, 1 up every 2, to (94,111)
B $E76B,2,2 Line 10 pixels right, 1 up every 3, to (104,114)
B $E76D,2,2 Line 10 pixels right, 1 up every 4, to (114,116)
B $E76F,2,2 Line 10 pixels right, 1 up every 5, to (124,118)
B $E771,2,2 Line 10 pixels right, to (134,118)
B $E773,3,3 Move to (195,63)
B $E776,2,2 Line 13 pixels up, 1 left every 13, to (194,76)
B $E778,2,2 Line 12 pixels up, 1 left every 4, to (191,88)
B $E77A,2,2 Line 10 pixels up, 1 left every 2, to (186,98)
B $E77C,2,2 Line 9 pixels diagonally up-left, to (177,107)
B $E77E,2,2 Line 9 pixels left, 1 up every 2, to (168,111)
B $E780,2,2 Line 9 pixels left, 1 up every 3, to (159,114)
B $E782,2,2 Line 9 pixels left, 1 up every 4, to (150,116)
B $E784,2,2 Line 9 pixels left, 1 up every 5, to (141,117)
B $E786,2,2 Line 9 pixels left, 1 up every 5, to (132,118)
B $E788,3,3 Move to (66,63)
B $E78B,2,2 Line 9 pixels down, 1 right every 9, to (67,54)
B $E78D,2,2 Line 9 pixels down, 1 right every 4, to (69,45)
B $E78F,2,2 Line 9 pixels down, 1 right every 2, to (73,36)
B $E791,2,2 Line 9 pixels diagonally down-right, to (82,27)
B $E793,2,2 Line 4 pixels right, 1 down every 2, to (86,25)
B $E795,3,3 Move to (195,62)
B $E798,2,2 Line 9 pixels down, 1 left every 9, to (194,53)
B $E79A,2,2 Line 9 pixels down, 1 left every 3, to (191,44)
B $E79C,2,2 Line 9 pixels down, 1 left every 2, to (187,35)
B $E79E,2,2 Line 9 pixels diagonally down-left, to (178,26)
B $E7A0,2,2 Line 9 pixels left, 1 down every 2, to (169,22)
B $E7A2,2,2 Line 9 pixels left, 1 down every 3, to (160,19)
B $E7A4,2,2 Line 6 pixels left, 1 down every 4, to (154,18)
B $E7A6,3,3 Move to (19,65)
B $E7A9,2,2 Line 9 pixels up, to (19,74)
B $E7AB,2,2 Line 9 pixels up, 1 right every 4, to (21,83)
B $E7AD,2,2 Line 9 pixels up, 1 right every 2, to (25,92)
B $E7AF,2,2 Line 9 pixels up, 1 right every 2, to (29,101)
B $E7B1,2,2 Line 9 pixels diagonally up-right, to (38,110)
B $E7B3,2,2 Line 9 pixels right, 1 up every 2, to (47,114)
B $E7B5,2,2 Line 9 pixels right, 1 up every 2, to (56,118)
B $E7B7,2,2 Line 9 pixels right, 1 up every 3, to (65,121)
B $E7B9,2,2 Line 9 pixels right, 1 up every 4, to (74,123)
B $E7BB,2,2 Line 9 pixels right, 1 up every 4, to (83,125)
B $E7BD,2,2 Line 9 pixels right, 1 up every 5, to (92,126)
B $E7BF,2,2 Line 9 pixels right, 1 up every 5, to (101,127)
B $E7C1,3,3 Move to (240,65)
B $E7C4,2,2 Line 9 pixels up, to (240,74)
B $E7C6,2,2 Line 9 pixels up, 1 left every 4, to (238,83)
B $E7C8,2,2 Line 9 pixels up, 1 left every 2, to (234,92)
B $E7CA,2,2 Line 9 pixels up, 1 left every 2, to (230,101)
B $E7CC,2,2 Line 9 pixels diagonally up-left, to (221,110)
B $E7CE,2,2 Line 9 pixels left, 1 up every 2, to (212,114)
B $E7D0,2,2 Line 9 pixels left, 1 up every 2, to (203,118)
B $E7D2,2,2 Line 9 pixels left, 1 up every 3, to (194,121)
B $E7D4,2,2 Line 9 pixels left, 1 up every 4, to (185,123)
B $E7D6,2,2 Line 9 pixels left, 1 up every 5, to (176,124)
B $E7D8,2,2 Line 9 pixels left, 1 up every 6, to (167,125)
B $E7DA,2,2 Line 9 pixels left, 1 up every 6, to (158,126)
B $E7DC,2,2 Line 9 pixels left, 1 up every 6, to (149,127)
B $E7DE,3,3 Move to (19,64)
B $E7E1,2,2 Line 9 pixels down, 1 right every 8, to (20,55)
B $E7E3,2,2 Line 9 pixels down, 1 right every 5, to (21,46)
B $E7E5,2,2 Line 9 pixels down, 1 right every 3, to (24,37)
B $E7E7,2,2 Line 9 pixels down, 1 right every 2, to (28,28)
B $E7E9,2,2 Line 17 pixels diagonally down-right, to (45,11)
B $E7EB,3,3 Move to (240,64)
B $E7EE,2,2 Line 9 pixels down, 1 left every 6, to (239,55)
B $E7F0,2,2 Line 9 pixels down, 1 left every 5, to (238,46)
B $E7F2,2,2 Line 9 pixels down, 1 left every 3, to (235,37)
B $E7F4,2,2 Line 9 pixels down, 1 left every 2, to (231,28)
B $E7F6,2,2 Line 9 pixels diagonally down-left, to (222,19)
B $E7F8,2,2 Line 9 pixels left, 1 down every 2, to (213,15)
B $E7FA,2,2 Line 9 pixels left, 1 down every 2, to (204,11)
B $E7FC,2,2 Line 9 pixels left, 1 down every 3, to (195,8)
B $E7FE,2,2 Line 9 pixels left, 1 down every 3, to (186,5)
B $E800,2,2 Line 5 pixels left, 1 down every 5, to (181,4)
B $E802,3,3 Move to (113,55)
B $E805,2,2 Line 3 pixels diagonally up-right, to (116,58)
B $E807,2,2 Line 3 pixels right, 1 up every 2, to (119,59)
B $E809,2,2 Line 3 pixels right, 1 up every 3, to (122,60)
B $E80B,2,2 Line 3 pixels right, 1 down every 2, to (125,59)
B $E80D,2,2 Line 3 pixels diagonally down-right, to (128,56)
B $E80F,2,2 Line 3 pixels down, 1 right every 2, to (129,53)
B $E811,2,2 Line 3 pixels down, 1 right every 3, to (130,50)
B $E813,2,2 Line 3 pixels down, 1 left every 2, to (129,47)
B $E815,2,2 Line 3 pixels diagonally down-left, to (126,44)
B $E817,3,3 Move to (7,0)
B $E81A,2,2 Line 63 pixels right, 1 up every 3, to (70,21)
B $E81C,2,2 Line 17 pixels right, 1 up every 3, to (87,26)
B $E81E,2,2 Line 28 pixels right, 1 up every 2, to (115,40)
B $E820,2,2 Line 4 pixels diagonally up-right, to (119,44)
B $E822,3,3 Move to (193,0)
B $E825,2,2 Line 37 pixels left, 1 up every 2, to (156,18)
B $E827,2,2 Line 14 pixels left, 1 up every 2, to (142,25)
B $E829,2,2 Line 10 pixels diagonally up-left, to (132,35)
B $E82B,2,2 Line 8 pixels diagonally up-left, to (124,43)
B $E82D,3,3 Move to (114,49)
B $E830,2,2 Line 4 pixels up, 1 right every 2, to (116,53)
B $E832,2,2 Line 2 pixels right, 1 up every 2, to (118,54)
B $E834,2,2 Line 2 pixels right, 1 down every 2, to (120,53)
B $E836,2,2 Line 2 pixels diagonally down-right, to (122,51)
B $E838,2,2 Line 2 pixels down, to (122,49)
B $E83A,2,2 Line 2 pixels down, to (122,47)
B $E83C,2,2 Line 3 pixels diagonally down-left, to (119,44)
B $E83E,3,3 Fill from (116,51) in black
B $E841,3,3 Move to (12,82)
B $E844,2,2 Line 22 pixels up, 1 right every 4, to (17,104)
B $E846,2,2 Line 9 pixels right, 1 down every 4, to (26,102)
B $E848,2,2 Line 24 pixels down, 1 left every 2, to (14,78)
B $E84A,2,2 Line 5 pixels up, 1 left every 2, to (12,83)
B $E84C,3,3 Fill from (15,83) in black
B $E84F,3,3 Move to (18,105)
B $E852,2,2 Line 4 pixels up, 1 left every 2, to (16,109)
B $E854,2,2 Line 4 pixels up, 1 right every 4, to (17,113)
B $E856,2,2 Line 4 pixels up, 1 right every 2, to (19,117)
B $E858,2,2 Line 4 pixels diagonally up-right, to (23,121)
B $E85A,2,2 Line 4 pixels up, 1 right every 2, to (25,125)
B $E85C,2,2 Line 4 pixels down, 1 right every 3, to (26,121)
B $E85E,2,2 Line 4 pixels down, 1 right every 4, to (27,117)
B $E860,2,2 Line 4 pixels down, to (27,113)
B $E862,2,2 Line 4 pixels down, 1 right every 3, to (28,109)
B $E864,2,2 Line 4 pixels down, 1 right every 3, to (29,105)
B $E866,2,2 Line 4 pixels diagonally down-left, to (25,101)
B $E868,3,3 Move to (17,106)
B $E86B,2,2 Line 4 pixels diagonally up-left, to (13,110)
B $E86D,2,2 Line 4 pixels up, to (13,114)
B $E86F,2,2 Line 4 pixels up, to (13,118)
B $E871,2,2 Line 4 pixels up, 1 right every 3, to (14,122)
B $E873,2,2 Line 4 pixels diagonally up-right, to (18,126)
B $E875,2,2 Line 4 pixels diagonally up-right, to (22,127)
B $E877,3,3 Move to (27,102)
B $E87A,2,2 Line 4 pixels diagonally up-right, to (31,106)
B $E87C,2,2 Line 4 pixels up, 1 right every 2, to (33,110)
B $E87E,2,2 Line 4 pixels up, 1 right every 2, to (35,114)
B $E880,2,2 Line 4 pixels up, 1 right every 3, to (36,118)
B $E882,2,2 Line 4 pixels up, 1 right every 4, to (37,122)
B $E884,2,2 Line 4 pixels up, 1 left every 3, to (36,126)
B $E886,2,2 Line 4 pixels up, 1 left every 3, to (35,127)
B $E888,3,3 Move to (44,79)
B $E88B,2,2 Line 19 pixels up, 1 right every 4, to (48,98)
B $E88D,2,2 Line 8 pixels right, 1 down every 4, to (56,96)
B $E88F,2,2 Line 21 pixels down, 1 left every 2, to (46,75)
B $E891,2,2 Line 5 pixels up, 1 left every 2, to (44,80)
B $E893,3,3 Fill from (46,79) in black
B $E896,3,3 Move to (49,98)
B $E899,2,2 Line 4 pixels up, 1 left every 2, to (47,102)
B $E89B,2,2 Line 4 pixels up, 1 left every 4, to (46,106)
B $E89D,2,2 Line 4 pixels up, 1 right every 3, to (47,110)
B $E89F,2,2 Line 4 pixels up, 1 right every 2, to (49,114)
B $E8A1,2,2 Line 4 pixels down, 1 right every 2, to (51,110)
B $E8A3,2,2 Line 4 pixels down, 1 right every 2, to (53,106)
B $E8A5,2,2 Line 4 pixels down, 1 right every 2, to (55,102)
B $E8A7,2,2 Line 4 pixels right, 1 down every 2, to (59,100)
B $E8A9,2,2 Line 5 pixels down, 1 left every 2, to (57,95)
B $E8AB,3,3 Move to (48,99)
B $E8AE,2,2 Line 4 pixels diagonally up-left, to (44,103)
B $E8B0,2,2 Line 4 pixels up, to (44,107)
B $E8B2,2,2 Line 4 pixels up, to (44,111)
B $E8B4,2,2 Line 4 pixels up, 1 right every 3, to (45,115)
B $E8B6,2,2 Line 4 pixels diagonally up-right, to (49,119)
B $E8B8,2,2 Line 4 pixels right, 1 down every 2, to (53,117)
B $E8BA,3,3 Move to (56,96)
B $E8BD,2,2 Line 4 pixels up, 1 right every 2, to (58,100)
B $E8BF,2,2 Line 4 pixels up, 1 right every 2, to (60,104)
B $E8C1,2,2 Line 4 pixels up, to (60,108)
B $E8C3,2,2 Line 4 pixels left, 1 up every 3, to (56,109)
B $E8C5,2,2 Line 4 pixels up, 1 left every 3, to (55,113)
B $E8C7,2,2 Line 4 pixels up, 1 left every 2, to (53,117)
B $E8C9,3,3 Move to (171,75)
B $E8CC,2,2 Line 14 pixels up, 1 left every 6, to (169,89)
B $E8CE,2,2 Line 5 pixels right, 1 up every 4, to (174,90)
B $E8D0,2,2 Line 18 pixels down, 1 left every 5, to (171,72)
B $E8D2,3,3 Fill from (172,81) in black
B $E8D5,3,3 Move to (169,90)
B $E8D8,2,2 Line 4 pixels up, 1 left every 2, to (167,94)
B $E8DA,2,2 Line 4 pixels up, 1 right every 3, to (168,98)
B $E8DC,2,2 Line 4 pixels up, 1 right every 2, to (170,102)
B $E8DE,2,2 Line 4 pixels up, 1 right every 2, to (172,106)
B $E8E0,2,2 Line 4 pixels down, 1 right every 4, to (173,102)
B $E8E2,2,2 Line 4 pixels down, 1 right every 3, to (174,98)
B $E8E4,2,2 Line 4 pixels down, 1 right every 2, to (176,94)
B $E8E6,2,2 Line 4 pixels down, 1 left every 2, to (174,90)
B $E8E8,3,3 Move to (168,88)
B $E8EB,2,2 Line 4 pixels diagonally up-left, to (164,92)
B $E8ED,2,2 Line 4 pixels up, to (164,96)
B $E8EF,2,2 Line 4 pixels up, 1 right every 4, to (165,100)
B $E8F1,2,2 Line 4 pixels up, 1 right every 2, to (167,104)
B $E8F3,2,2 Line 4 pixels diagonally up-right, to (171,108)
B $E8F5,2,2 Line 4 pixels diagonally up-right, to (175,112)
B $E8F7,3,3 Move to (175,89)
B $E8FA,2,2 Line 4 pixels diagonally up-right, to (179,93)
B $E8FC,2,2 Line 4 pixels up, 1 right every 3, to (180,97)
B $E8FE,2,2 Line 4 pixels up, 1 right every 4, to (181,101)
B $E900,2,2 Line 4 pixels up, 1 left every 2, to (179,105)
B $E902,2,2 Line 4 pixels up, 1 left every 3, to (178,109)
B $E904,2,2 Line 5 pixels left, 1 up every 2, to (173,111)
B $E906,3,3 Move to (214,75)
B $E909,2,2 Line 18 pixels up, 1 left every 2, to (205,93)
B $E90B,2,2 Line 7 pixels right, 1 up every 4, to (212,94)
B $E90D,2,2 Line 22 pixels down, 1 right every 4, to (217,72)
B $E90F,2,2 Line 5 pixels diagonally up-left, to (212,77)
B $E911,3,3 Fill from (211,87) in black
B $E914,3,3 Move to (206,93)
B $E917,2,2 Line 4 pixels up, to (206,97)
B $E919,2,2 Line 4 pixels up, 1 right every 3, to (207,101)
B $E91B,2,2 Line 4 pixels diagonally up-right, to (211,105)
B $E91D,2,2 Line 4 pixels up, 1 right every 2, to (213,109)
B $E91F,2,2 Line 4 pixels down, 1 right every 3, to (214,105)
B $E921,2,2 Line 4 pixels down, 1 left every 4, to (213,101)
B $E923,2,2 Line 4 pixels down, 1 right every 3, to (214,97)
B $E925,2,2 Line 4 pixels down, 1 left every 3, to (213,93)
B $E927,3,3 Move to (205,93)
B $E92A,2,2 Line 4 pixels diagonally up-left, to (201,97)
B $E92C,2,2 Line 4 pixels up, 1 right every 3, to (202,101)
B $E92E,2,2 Line 4 pixels up, 1 right every 2, to (204,105)
B $E930,2,2 Line 4 pixels up, 1 right every 2, to (206,109)
B $E932,2,2 Line 4 pixels up, 1 right every 2, to (208,113)
B $E934,2,2 Line 4 pixels diagonally up-right, to (212,117)
B $E936,3,3 Move to (214,94)
B $E939,2,2 Line 4 pixels diagonally up-right, to (218,98)
B $E93B,2,2 Line 4 pixels up, 1 right every 3, to (219,102)
B $E93D,2,2 Line 4 pixels up, 1 right every 3, to (220,106)
B $E93F,2,2 Line 4 pixels up, 1 right every 4, to (221,110)
B $E941,2,2 Line 4 pixels up, 1 left every 2, to (219,114)
B $E943,2,2 Line 4 pixels diagonally up-left, to (215,118)
B $E945,2,2 Line 4 pixels left, 1 down every 2, to (211,116)
B $E947,3,3 Move to (88,79)
B $E94A,2,2 Line 13 pixels up, 1 right every 4, to (91,92)
B $E94C,2,2 Line 5 pixels right, 1 down every 4, to (96,91)
B $E94E,2,2 Line 15 pixels down, 1 left every 2, to (89,76)
B $E950,2,2 Line 4 pixels up, 1 left every 3, to (88,80)
B $E952,3,3 Fill from (91,87) in black
B $E955,3,3 Move to (92,93)
B $E958,2,2 Line 4 pixels up, 1 left every 2, to (90,97)
B $E95A,2,2 Line 4 pixels up, 1 right every 4, to (91,101)
B $E95C,2,2 Line 4 pixels diagonally up-right, to (95,105)
B $E95E,2,2 Line 4 pixels up, 1 right every 2, to (97,109)
B $E960,2,2 Line 4 pixels up, 1 right every 4, to (98,113)
B $E962,2,2 Line 4 pixels down, 1 right every 4, to (99,109)
B $E964,2,2 Line 4 pixels down, 1 right every 4, to (100,105)
B $E966,2,2 Line 4 pixels down, to (100,101)
B $E968,2,2 Line 4 pixels down, 1 right every 4, to (101,97)
B $E96A,2,2 Line 4 pixels down, 1 left every 3, to (100,93)
B $E96C,2,2 Line 4 pixels left, 1 down every 2, to (96,91)
B $E96E,3,3 Move to (92,93)
B $E971,2,2 Line 4 pixels diagonally up-left, to (88,97)
B $E973,2,2 Line 4 pixels up, 1 right every 4, to (89,101)
B $E975,2,2 Line 4 pixels up, 1 right every 4, to (90,105)
B $E977,2,2 Line 4 pixels up, 1 right every 2, to (92,109)
B $E979,2,2 Line 4 pixels up, 1 right every 2, to (94,113)
B $E97B,2,2 Line 4 pixels up, 1 right every 2, to (96,117)
B $E97D,3,3 Move to (98,92)
B $E980,2,2 Line 4 pixels diagonally up-right, to (102,96)
B $E982,2,2 Line 4 pixels up, 1 right every 2, to (104,100)
B $E984,2,2 Line 4 pixels up, 1 right every 2, to (106,104)
B $E986,2,2 Line 4 pixels up, 1 left every 2, to (104,108)
B $E988,2,2 Line 4 pixels up, 1 left every 2, to (102,112)
B $E98A,2,2 Line 4 pixels up, 1 left every 3, to (101,116)
B $E98C,2,2 Line 4 pixels diagonally up-left, to (97,120)
B $E98E,2,2 Line 4 pixels down, 1 left every 2, to (95,116)
B $E990,3,3 Fill from (217,106) in red
B $E993,3,3 Fill from (176,97) in red
B $E996,3,3 Fill from (103,104) in red
B $E999,3,3 Fill from (93,107) in red
B $E99C,3,3 Move to (14,95)
B $E99F,2,2 Line 6 pixels diagonally up-left, to (8,101)
B $E9A1,3,3 Move to (14,96)
B $E9A4,2,2 Line 6 pixels diagonally up-left, to (8,102)
B $E9A6,3,3 Move to (15,97)
B $E9A9,2,2 Line 6 pixels diagonally up-left, to (9,103)
B $E9AB,3,3 Move to (88,86)
B $E9AE,2,2 Line 6 pixels diagonally up-left, to (82,92)
B $E9B0,3,3 Move to (88,87)
B $E9B3,2,2 Line 4 pixels diagonally up-left, to (84,91)
B $E9B5,3,3 Move to (89,88)
B $E9B8,2,2 Line 4 pixels diagonally up-left, to (85,92)
B $E9BA,3,3 Move to (173,80)
B $E9BD,2,2 Line 6 pixels right, 1 up every 2, to (179,83)
B $E9BF,3,3 Move to (174,81)
B $E9C2,2,2 Line 6 pixels right, 1 up every 2, to (180,84)
B $E9C4,3,3 Move to (215,86)
B $E9C7,2,2 Line 6 pixels diagonally up-right, to (221,92)
B $E9C9,3,3 Move to (214,87)
B $E9CC,2,2 Line 6 pixels diagonally up-right, to (220,93)
B $E9CE,3,3 Move to (45,90)
B $E9D1,2,2 Line 6 pixels left, 1 up every 2, to (39,93)
B $E9D3,3,3 Move to (46,91)
B $E9D6,2,2 Line 6 pixels left, 1 up every 2, to (40,94)
B $E9D8,3,3 Fill from (214,116) in red
B $E9DB,3,3 Fill from (175,109) in red
B $E9DE,3,3 Fill from (99,117) in red
B $E9E1,3,3 Fill from (49,117) in red
B $E9E4,3,3 Fill from (53,113) in red
B $E9E7,3,3 Fill from (45,112) in red
B $E9EA,3,3 Fill from (33,117) in red
B $E9ED,1,1 End of picture
b $E9EE Picture: room 25 (?)
D $E9EE The picture for room 25 (?). It is 592 bytes long: 215 lines, 40 moves, 11 fills and 1 painted areas. See #R$8985 for the format.
D $E9EE #HTML[<img src="../images/pictures/room25.png" alt="room 25">]
B $E9EE,2,2 Border blue, picture area black ink on blue paper
B $E9F0,3,3 Move to (50,0)
B $E9F3,2,2 Line 19 pixels diagonally up-left, to (31,19)
B $E9F5,2,2 Line 15 pixels left, 1 up every 4, to (16,22)
B $E9F7,2,2 Line 17 pixels diagonally up-left, to (0,39)
B $E9F9,3,3 Move to (0,45)
B $E9FC,2,2 Line 16 pixels diagonally down-right, to (16,29)
B $E9FE,2,2 Line 32 pixels up, 1 left every 16, to (14,61)
B $EA00,2,2 Line 28 pixels diagonally up-left, to (0,89)
B $EA02,3,3 Move to (0,80)
B $EA05,2,2 Line 9 pixels diagonally down-right, to (9,71)
B $EA07,2,2 Line 22 pixels right, 1 down every 2, to (31,60)
B $EA09,2,2 Line 32 pixels up, 1 left every 4, to (23,92)
B $EA0B,2,2 Line 9 pixels diagonally up-left, to (14,101)
B $EA0D,2,2 Line 9 pixels up, 1 left every 3, to (11,110)
B $EA0F,2,2 Line 21 pixels right, 1 down every 2, to (32,100)
B $EA11,2,2 Line 23 pixels down, 1 right every 4, to (37,77)
B $EA13,2,2 Line 16 pixels up, 1 right every 4, to (41,93)
B $EA15,2,2 Line 14 pixels diagonally up-right, to (55,107)
B $EA17,2,2 Line 21 pixels down, 1 right every 5, to (59,86)
B $EA19,2,2 Line 6 pixels right, 1 down every 3, to (65,84)
B $EA1B,2,2 Line 6 pixels right, 1 down every 2, to (71,81)
B $EA1D,2,2 Line 6 pixels down, 1 right every 3, to (73,75)
B $EA1F,2,2 Line 6 pixels down, 1 right every 4, to (74,69)
B $EA21,2,2 Line 6 pixels down, 1 left every 5, to (73,63)
B $EA23,2,2 Line 12 pixels down, 1 left every 3, to (69,51)
B $EA25,2,2 Line 12 pixels down, 1 left every 2, to (63,39)
B $EA27,2,2 Line 22 pixels diagonally down-right, to (85,17)
B $EA29,2,2 Line 21 pixels up, 1 right every 2, to (95,38)
B $EA2B,2,2 Line 21 pixels up, 1 right every 3, to (102,59)
B $EA2D,2,2 Line 12 pixels up, 1 right every 4, to (105,71)
B $EA2F,2,2 Line 12 pixels up, 1 left every 9, to (104,83)
B $EA31,2,2 Line 12 pixels diagonally up-left, to (92,95)
B $EA33,2,2 Line 12 pixels left, 1 up every 2, to (80,101)
B $EA35,2,2 Line 12 pixels left, 1 up every 3, to (68,105)
B $EA37,2,2 Line 13 pixels left, 1 up every 4, to (55,108)
B $EA39,3,3 Move to (32,28)
B $EA3C,2,2 Line 20 pixels up, 1 left every 8, to (30,48)
B $EA3E,2,2 Line 5 pixels left, 1 up every 4, to (25,49)
B $EA40,2,2 Line 5 pixels diagonally up-left, to (20,54)
B $EA42,2,2 Line 26 pixels down, 1 right every 9, to (22,28)
B $EA44,2,2 Line 11 pixels right, 1 down every 6, to (33,27)
B $EA46,3,3 Move to (51,42)
B $EA49,2,2 Line 11 pixels up, 1 left every 2, to (46,53)
B $EA4B,2,2 Line 8 pixels up, 1 left every 2, to (42,61)
B $EA4D,2,2 Line 15 pixels up, 1 right every 6, to (44,76)
B $EA4F,2,2 Line 11 pixels up, 1 right every 4, to (46,87)
B $EA51,2,2 Line 8 pixels up, 1 right every 2, to (50,95)
B $EA53,2,2 Line 11 pixels down, 1 right every 4, to (52,84)
B $EA55,2,2 Line 11 pixels down, 1 right every 2, to (57,73)
B $EA57,2,2 Line 5 pixels diagonally down-right, to (62,68)
B $EA59,2,2 Line 5 pixels down, to (62,63)
B $EA5B,2,2 Line 5 pixels down, 1 left every 4, to (61,58)
B $EA5D,2,2 Line 9 pixels down, 1 left every 2, to (57,49)
B $EA5F,2,2 Line 7 pixels diagonally down-left, to (50,42)
B $EA61,3,3 Move to (97,0)
B $EA64,2,2 Line 30 pixels up, 1 right every 3, to (107,30)
B $EA66,2,2 Line 18 pixels up, 1 right every 3, to (113,48)
B $EA68,2,2 Line 12 pixels right, 1 up every 4, to (125,51)
B $EA6A,2,2 Line 12 pixels right, 1 up every 3, to (137,55)
B $EA6C,2,2 Line 11 pixels right, 1 up every 5, to (148,57)
B $EA6E,2,2 Line 9 pixels right, 1 up every 2, to (157,61)
B $EA70,2,2 Line 9 pixels diagonally up-right, to (166,70)
B $EA72,2,2 Line 9 pixels diagonally up-right, to (175,79)
B $EA74,2,2 Line 4 pixels left, 1 up every 4, to (171,80)
B $EA76,2,2 Line 9 pixels left, 1 down every 2, to (162,76)
B $EA78,2,2 Line 4 pixels diagonally down-left, to (158,72)
B $EA7A,2,2 Line 4 pixels diagonally down-left, to (154,68)
B $EA7C,2,2 Line 8 pixels left, 1 down every 3, to (146,66)
B $EA7E,2,2 Line 8 pixels left, 1 down every 2, to (138,62)
B $EA80,2,2 Line 23 pixels left, 1 down every 3, to (115,55)
B $EA82,2,2 Line 23 pixels up, 1 right every 8, to (117,78)
B $EA84,2,2 Line 7 pixels up, 1 left every 4, to (116,85)
B $EA86,2,2 Line 17 pixels up, 1 right every 2, to (124,102)
B $EA88,2,2 Line 15 pixels up, 1 right every 3, to (129,117)
B $EA8A,2,2 Line 7 pixels diagonally down-left, to (122,110)
B $EA8C,2,2 Line 7 pixels down, 1 left every 2, to (119,103)
B $EA8E,2,2 Line 26 pixels up, 1 left every 4, to (113,127)
B $EA90,3,3 Move to (111,127)
B $EA93,2,2 Line 26 pixels down, 1 right every 5, to (116,101)
B $EA95,2,2 Line 8 pixels down, 1 left every 2, to (112,93)
B $EA97,2,2 Line 11 pixels diagonally up-left, to (101,104)
B $EA99,2,2 Line 19 pixels left, 1 up every 3, to (82,110)
B $EA9B,2,2 Line 19 pixels up, 1 right every 3, to (88,127)
B $EA9D,3,3 Move to (85,127)
B $EAA0,2,2 Line 17 pixels down, 1 left every 2, to (77,110)
B $EAA2,2,2 Line 37 pixels left, 1 up every 7, to (40,115)
B $EAA4,2,2 Line 17 pixels right, 1 down every 2, to (57,107)
B $EAA6,3,3 Fill from (47,113) in black
B $EAA9,3,3 Move to (211,38)
B $EAAC,2,2 Line 15 pixels up, 1 left every 11, to (210,53)
B $EAAE,2,2 Line 9 pixels left, 1 up every 8, to (201,54)
B $EAB0,2,2 Line 7 pixels up, 1 left every 2, to (198,61)
B $EAB2,2,2 Line 14 pixels left, 1 up every 2, to (184,68)
B $EAB4,2,2 Line 14 pixels left, 1 up every 7, to (170,70)
B $EAB6,2,2 Line 8 pixels left, 1 up every 2, to (162,74)
B $EAB8,2,2 Line 8 pixels diagonally up-left, to (154,82)
B $EABA,2,2 Line 8 pixels right, 1 down every 4, to (162,80)
B $EABC,2,2 Line 8 pixels right, 1 down every 2, to (170,76)
B $EABE,2,2 Line 8 pixels right, 1 down every 3, to (178,74)
B $EAC0,2,2 Line 8 pixels right, 1 down every 4, to (186,72)
B $EAC2,2,2 Line 8 pixels diagonally up-left, to (178,80)
B $EAC4,2,2 Line 8 pixels diagonally up-left, to (170,88)
B $EAC6,2,2 Line 8 pixels right, 1 down every 2, to (178,84)
B $EAC8,2,2 Line 8 pixels diagonally down-right, to (186,76)
B $EACA,2,2 Line 8 pixels right, 1 down every 2, to (194,72)
B $EACC,2,2 Line 8 pixels right, 1 down every 3, to (202,70)
B $EACE,2,2 Line 7 pixels down, 1 right every 2, to (205,63)
B $EAD0,2,2 Line 5 pixels right, 1 down every 5, to (210,62)
B $EAD2,2,2 Line 14 pixels up, 1 right every 5, to (212,76)
B $EAD4,2,2 Line 9 pixels diagonally up-left, to (203,85)
B $EAD6,2,2 Line 9 pixels left, 1 up every 3, to (194,88)
B $EAD8,2,2 Line 9 pixels left, 1 up every 3, to (185,91)
B $EADA,2,2 Line 9 pixels left, 1 up every 4, to (176,93)
B $EADC,2,2 Line 9 pixels right, 1 up every 5, to (185,94)
B $EADE,2,2 Line 9 pixels right, 1 down every 3, to (194,91)
B $EAE0,2,2 Line 9 pixels right, 1 down every 5, to (203,90)
B $EAE2,2,2 Line 18 pixels up, 1 right every 2, to (212,108)
B $EAE4,2,2 Line 21 pixels up, 1 left every 2, to (202,127)
B $EAE6,3,3 Move to (207,127)
B $EAE9,2,2 Line 21 pixels down, 1 right every 2, to (217,106)
B $EAEB,2,2 Line 19 pixels down, 1 left every 3, to (211,87)
B $EAED,2,2 Line 15 pixels right, 1 down every 2, to (226,80)
B $EAEF,2,2 Line 20 pixels up, 1 right every 2, to (236,100)
B $EAF1,2,2 Line 10 pixels up, 1 right every 10, to (237,110)
B $EAF3,2,2 Line 3 pixels right, to (240,110)
B $EAF5,2,2 Line 16 pixels down, 1 right every 10, to (241,94)
B $EAF7,2,2 Line 7 pixels right, 1 down every 3, to (248,92)
B $EAF9,2,2 Line 7 pixels down, 1 right every 3, to (250,85)
B $EAFB,2,2 Line 7 pixels down, 1 left every 7, to (249,78)
B $EAFD,2,2 Line 10 pixels down, 1 left every 2, to (244,68)
B $EAFF,2,2 Line 13 pixels diagonally down-left, to (231,55)
B $EB01,2,2 Line 19 pixels down, 1 left every 8, to (229,36)
B $EB03,2,2 Line 7 pixels left, 1 down every 3, to (222,34)
B $EB05,2,2 Line 7 pixels left, 1 down every 4, to (215,33)
B $EB07,2,2 Line 7 pixels left, 1 down every 2, to (208,30)
B $EB09,2,2 Line 4 pixels diagonally down-left, to (204,26)
B $EB0B,2,2 Line 4 pixels up, to (204,30)
B $EB0D,2,2 Line 4 pixels up, 1 right every 3, to (205,34)
B $EB0F,2,2 Line 6 pixels right, 1 up every 2, to (211,37)
B $EB11,2,2 Line 1 pixels diagonally up-right, to (212,38)
B $EB13,3,3 Move to (228,62)
B $EB16,2,2 Line 12 pixels up, 1 right every 8, to (229,74)
B $EB18,2,2 Line 8 pixels up, 1 right every 2, to (233,82)
B $EB1A,2,2 Line 5 pixels diagonally up-right, to (238,87)
B $EB1C,2,2 Line 4 pixels up, 1 right every 2, to (240,91)
B $EB1E,2,2 Line 4 pixels diagonally down-right, to (244,87)
B $EB20,2,2 Line 4 pixels down, to (244,83)
B $EB22,2,2 Line 8 pixels down, 1 left every 2, to (240,75)
B $EB24,2,2 Line 14 pixels diagonally down-left, to (226,61)
B $EB26,3,3 Fill from (209,33) in black
B $EB29,3,3 Fill from (160,79) in black
B $EB2C,3,3 Move to (127,24)
B $EB2F,2,2 Line 7 pixels up, 1 right every 2, to (130,31)
B $EB31,2,2 Line 10 pixels up, 1 left every 5, to (128,41)
B $EB33,2,2 Line 17 pixels left, 1 up every 3, to (111,46)
B $EB35,2,2 Line 17 pixels left, 1 up every 5, to (94,49)
B $EB37,2,2 Line 8 pixels left, 1 up every 6, to (86,50)
B $EB39,2,2 Line 4 pixels up, 1 left every 4, to (85,54)
B $EB3B,2,2 Line 15 pixels right, 1 down every 5, to (100,51)
B $EB3D,3,3 Move to (119,49)
B $EB40,2,2 Line 11 pixels right, 1 down every 3, to (130,46)
B $EB42,2,2 Line 7 pixels up, 1 right every 4, to (131,53)
B $EB44,3,3 Move to (127,23)
B $EB47,2,2 Line 9 pixels right, 1 up every 4, to (136,25)
B $EB49,2,2 Line 6 pixels right, 1 down every 3, to (142,23)
B $EB4B,2,2 Line 8 pixels up, 1 right every 5, to (143,31)
B $EB4D,2,2 Line 8 pixels up, 1 left every 6, to (142,39)
B $EB4F,2,2 Line 5 pixels up, 1 left every 2, to (140,44)
B $EB51,2,2 Line 7 pixels up, 1 right every 3, to (142,51)
B $EB53,2,2 Line 7 pixels right, 1 up every 3, to (149,53)
B $EB55,2,2 Line 7 pixels right, 1 up every 2, to (156,56)
B $EB57,2,2 Line 14 pixels right, 1 down every 3, to (170,52)
B $EB59,2,2 Line 8 pixels right, 1 down every 5, to (178,51)
B $EB5B,2,2 Line 8 pixels down, 1 right every 5, to (179,43)
B $EB5D,2,2 Line 8 pixels down, 1 left every 7, to (178,35)
B $EB5F,2,2 Line 8 pixels right, 1 down every 4, to (186,33)
B $EB61,2,2 Line 8 pixels up, 1 right every 3, to (188,41)
B $EB63,2,2 Line 8 pixels diagonally up-right, to (196,49)
B $EB65,2,2 Line 9 pixels up, 1 right every 2, to (200,58)
B $EB67,3,3 Move to (198,59)
B $EB6A,2,2 Line 9 pixels down, 1 left every 2, to (194,50)
B $EB6C,2,2 Line 7 pixels left, 1 down every 2, to (187,47)
B $EB6E,2,2 Line 7 pixels up, 1 left every 3, to (185,54)
B $EB70,2,2 Line 7 pixels up, 1 left every 4, to (184,61)
B $EB72,2,2 Line 7 pixels up, 1 left every 7, to (183,68)
B $EB74,3,3 Move to (179,68)
B $EB77,2,2 Line 7 pixels down, 1 left every 6, to (178,61)
B $EB79,2,2 Line 7 pixels down, 1 left every 5, to (177,54)
B $EB7B,2,2 Line 7 pixels left, 1 up every 5, to (170,55)
B $EB7D,2,2 Line 7 pixels left, 1 up every 5, to (163,56)
B $EB7F,2,2 Line 7 pixels up, 1 left every 2, to (160,63)
B $EB81,3,3 Fill from (156,59) in black
B $EB84,3,3 Fill from (88,52) in black
B $EB87,3,3 Move to (88,52)
B $EB8A,2,2 Line 7 pixels up, 1 left every 2, to (85,59)
B $EB8C,3,3 Move to (133,61)
B $EB8F,2,2 Line 6 pixels left, 1 up every 2, to (127,64)
B $EB91,2,2 Line 12 pixels up, 1 left every 6, to (125,76)
B $EB93,2,2 Line 9 pixels diagonally down-left, to (116,67)
B $EB95,3,3 Move to (118,75)
B $EB98,2,2 Line 9 pixels diagonally up-right, to (127,84)
B $EB9A,2,2 Line 7 pixels down, 1 right every 2, to (130,77)
B $EB9C,2,2 Line 9 pixels down, 1 right every 3, to (133,68)
B $EB9E,2,2 Line 10 pixels right, 1 down every 2, to (143,63)
B $EBA0,3,3 Move to (150,68)
B $EBA3,2,2 Line 10 pixels up, 1 left every 9, to (149,78)
B $EBA5,2,2 Line 10 pixels up, 1 left every 9, to (148,88)
B $EBA7,2,2 Line 4 pixels right, 1 down every 2, to (152,86)
B $EBA9,3,3 Move to (148,88)
B $EBAC,2,2 Line 4 pixels right, 1 down every 2, to (152,86)
B $EBAE,2,2 Line 11 pixels down, 1 right every 5, to (154,75)
B $EBB0,2,2 Line 11 pixels down, 1 right every 2, to (159,64)
B $EBB2,3,3 Fill from (152,76) in black
B $EBB5,3,3 Fill from (128,76) in black
B $EBB8,3,3 Move to (180,75)
B $EBBB,2,2 Line 11 pixels up, 1 right every 4, to (182,86)
B $EBBD,2,2 Line 8 pixels right, 1 up every 2, to (190,90)
B $EBBF,2,2 Line 8 pixels down, 1 left every 2, to (186,82)
B $EBC1,2,2 Line 8 pixels down, 1 left every 4, to (184,74)
B $EBC3,3,3 Fill from (181,74) in black
B $EBC6,3,3 Fill from (184,81) in black
B $EBC9,3,3 Move to (177,93)
B $EBCC,2,2 Line 19 pixels left, 1 up every 2, to (158,102)
B $EBCE,3,3 Move to (150,86)
B $EBD1,2,2 Line 19 pixels diagonally up-left, to (131,105)
B $EBD3,3,3 Move to (123,111)
B $EBD6,2,2 Line 19 pixels diagonally up-right, to (142,127)
B $EBD8,3,3 Move to (41,115)
B $EBDB,2,2 Line 19 pixels left, 1 up every 3, to (22,121)
B $EBDD,3,3 Move to (24,105)
B $EBE0,2,2 Line 19 pixels left, 1 up every 3, to (5,111)
B $EBE2,3,3 Move to (126,79)
B $EBE5,2,2 Line 19 pixels up, 1 right every 13, to (127,98)
B $EBE7,3,3 Move to (169,79)
B $EBEA,2,2 Line 4 pixels up, 1 right every 3, to (170,83)
B $EBEC,3,3 Move to (171,88)
B $EBEF,2,2 Line 4 pixels up, 1 right every 3, to (172,92)
B $EBF1,3,3 Move to (237,111)
B $EBF4,2,2 Line 7 pixels up, 1 right every 3, to (239,118)
B $EBF6,3,3 Move to (0,39)
B $EBF9,2,2 Line 32 pixels right, 1 up every 7, to (32,43)
B $EBFB,2,2 Line 32 pixels right, 1 up every 7, to (64,47)
B $EBFD,2,2 Line 36 pixels right, 1 down every 22, to (100,46)
B $EBFF,3,3 Move to (141,46)
B $EC02,2,2 Line 36 pixels right, 1 down every 22, to (177,45)
B $EC04,2,2 Line 36 pixels right, 1 down every 27, to (213,44)
B $EC06,3,3 Move to (230,44)
B $EC09,2,2 Line 41 pixels right, 1 down every 27, to (255,43)
B $EC0B,3,3 Move to (190,127)
B $EC0E,2,2 Line 6 pixels down, 1 right every 2, to (193,121)
B $EC10,2,2 Line 6 pixels diagonally down-right, to (199,115)
B $EC12,2,2 Line 8 pixels right, 1 down every 2, to (207,111)
B $EC14,3,3 Move to (207,112)
B $EC17,2,2 Line 8 pixels up, 1 left every 6, to (206,120)
B $EC19,3,3 Move to (205,119)
B $EC1C,2,2 Line 6 pixels left, 1 down every 6, to (199,118)
B $EC1E,3,3 Move to (199,119)
B $EC21,2,2 Line 12 pixels up, 1 left every 10, to (198,127)
B $EC23,3,3 Fill from (195,123) in red
B $EC26,3,3 Move to (216,113)
B $EC29,2,2 Line 16 pixels up, 1 left every 15, to (215,127)
B $EC2B,3,3 Move to (230,127)
B $EC2E,2,2 Line 8 pixels down, 1 left every 3, to (228,119)
B $EC30,2,2 Line 5 pixels diagonally down-left, to (223,114)
B $EC32,2,2 Line 7 pixels left, 1 down every 3, to (216,112)
B $EC34,3,3 Fill from (222,115) in red
B $EC37,6,6 Paint red paper from cell (25,0): 1 right, 2 down
B $EC3D,1,1 End of picture
b $EC3E Picture: room 8 (?)
D $EC3E The picture for room 8 (?). It is 517 bytes long: 190 lines, 34 moves, 5 fills and 2 painted areas. See #R$8985 for the format.
D $EC3E #HTML[<img src="../images/pictures/room08.png" alt="room 8">]
B $EC3E,2,2 Border green, picture area black ink on green paper
B $EC40,3,3 Move to (95,127)
B $EC43,2,2 Line 39 pixels down, 1 right every 22, to (96,88)
B $EC45,2,2 Line 32 pixels right, 1 down every 11, to (128,86)
B $EC47,2,2 Line 4 pixels up, 1 right every 2, to (130,90)
B $EC49,2,2 Line 10 pixels right, 1 down every 4, to (140,88)
B $EC4B,2,2 Line 10 pixels right, 1 down every 6, to (150,87)
B $EC4D,2,2 Line 4 pixels down, 1 right every 2, to (152,83)
B $EC4F,2,2 Line 4 pixels right, 1 down every 4, to (156,82)
B $EC51,2,2 Line 3 pixels diagonally down-right, to (159,79)
B $EC53,2,2 Line 3 pixels down, 1 left every 3, to (158,76)
B $EC55,2,2 Line 3 pixels left, 1 down every 2, to (155,75)
B $EC57,2,2 Line 51 pixels left, 1 down every 5, to (104,65)
B $EC59,2,2 Line 6 pixels left, 1 down every 3, to (98,63)
B $EC5B,2,2 Line 3 pixels diagonally down-left, to (95,60)
B $EC5D,2,2 Line 16 pixels down, 1 left every 3, to (90,44)
B $EC5F,2,2 Line 8 pixels down, 1 right every 5, to (91,36)
B $EC61,2,2 Line 8 pixels down, 1 left every 3, to (89,28)
B $EC63,2,2 Line 8 pixels diagonally down-left, to (81,20)
B $EC65,2,2 Line 8 pixels left, 1 down every 2, to (73,16)
B $EC67,2,2 Line 20 pixels diagonally down-left, to (53,0)
B $EC69,3,3 Move to (118,127)
B $EC6C,2,2 Line 35 pixels down, 1 right every 14, to (120,92)
B $EC6E,2,2 Line 35 pixels right, 1 down every 28, to (155,91)
B $EC70,2,2 Line 26 pixels right, 1 down every 6, to (181,87)
B $EC72,2,2 Line 8 pixels right, 1 down every 2, to (189,83)
B $EC74,2,2 Line 5 pixels down, 1 right every 2, to (191,78)
B $EC76,2,2 Line 5 pixels down, 1 left every 2, to (189,73)
B $EC78,2,2 Line 5 pixels left, 1 down every 2, to (184,71)
B $EC7A,2,2 Line 18 pixels left, 1 down every 2, to (166,62)
B $EC7C,2,2 Line 4 pixels diagonally down-left, to (162,58)
B $EC7E,2,2 Line 4 pixels down, 1 left every 2, to (160,54)
B $EC80,2,2 Line 11 pixels down, 1 left every 5, to (158,43)
B $EC82,2,2 Line 5 pixels down, 1 right every 2, to (160,38)
B $EC84,2,2 Line 5 pixels right, 1 down every 2, to (165,36)
B $EC86,2,2 Line 5 pixels right, 1 down every 2, to (170,34)
B $EC88,2,2 Line 5 pixels down, 1 right every 5, to (171,29)
B $EC8A,2,2 Line 5 pixels diagonally down-left, to (166,24)
B $EC8C,2,2 Line 5 pixels diagonally down-left, to (161,19)
B $EC8E,2,2 Line 5 pixels down, 1 right every 3, to (162,14)
B $EC90,2,2 Line 5 pixels down, 1 right every 2, to (164,9)
B $EC92,2,2 Line 9 pixels right, 1 down every 2, to (173,5)
B $EC94,2,2 Line 9 pixels diagonally down-right, to (182,0)
B $EC96,3,3 Move to (127,85)
B $EC99,2,2 Line 5 pixels left, 1 down every 2, to (122,83)
B $EC9B,2,2 Line 4 pixels down, 1 left every 2, to (120,79)
B $EC9D,2,2 Line 4 pixels right, 1 down every 2, to (124,77)
B $EC9F,2,2 Line 11 pixels right, 1 down every 6, to (135,76)
B $ECA1,2,2 Line 11 pixels right, 1 up every 9, to (146,77)
B $ECA3,2,2 Line 7 pixels right, 1 up every 4, to (153,78)
B $ECA5,2,2 Line 7 pixels up, 1 left every 3, to (151,85)
B $ECA7,3,3 Move to (90,21)
B $ECAA,2,2 Line 5 pixels diagonally up-right, to (95,26)
B $ECAC,2,2 Line 4 pixels up, 1 right every 2, to (97,30)
B $ECAE,2,2 Line 4 pixels right, 1 up every 2, to (101,32)
B $ECB0,2,2 Line 4 pixels right, 1 up every 4, to (105,33)
B $ECB2,2,2 Line 4 pixels right, 1 down every 4, to (109,32)
B $ECB4,2,2 Line 4 pixels right, 1 down every 4, to (113,31)
B $ECB6,2,2 Line 4 pixels right, 1 down every 2, to (117,29)
B $ECB8,2,2 Line 4 pixels diagonally down-right, to (121,25)
B $ECBA,2,2 Line 4 pixels down, 1 left every 3, to (120,21)
B $ECBC,2,2 Line 4 pixels left, 1 down every 3, to (116,20)
B $ECBE,2,2 Line 4 pixels left, 1 down every 4, to (112,19)
B $ECC0,2,2 Line 4 pixels left, 1 down every 4, to (108,18)
B $ECC2,2,2 Line 4 pixels left, 1 down every 4, to (104,17)
B $ECC4,2,2 Line 4 pixels left, to (100,17)
B $ECC6,2,2 Line 4 pixels left, to (96,17)
B $ECC8,2,2 Line 4 pixels left, 1 up every 3, to (92,18)
B $ECCA,2,2 Line 3 pixels diagonally up-left, to (89,21)
B $ECCC,3,3 Move to (144,25)
B $ECCF,2,2 Line 5 pixels left, 1 up every 2, to (139,27)
B $ECD1,2,2 Line 3 pixels diagonally up-right, to (142,30)
B $ECD3,2,2 Line 3 pixels right, 1 up every 2, to (145,31)
B $ECD5,2,2 Line 3 pixels right, 1 up every 3, to (148,32)
B $ECD7,2,2 Line 3 pixels right, 1 up every 3, to (151,33)
B $ECD9,2,2 Line 3 pixels right, 1 down every 3, to (154,32)
B $ECDB,2,2 Line 3 pixels diagonally down-right, to (157,29)
B $ECDD,2,2 Line 3 pixels down, 1 right every 2, to (158,26)
B $ECDF,2,2 Line 3 pixels diagonally down-left, to (155,23)
B $ECE1,2,2 Line 3 pixels left, 1 up every 3, to (152,24)
B $ECE3,2,2 Line 3 pixels left, to (149,24)
B $ECE5,2,2 Line 3 pixels left, to (146,24)
B $ECE7,2,2 Line 3 pixels left, 1 up every 2, to (143,25)
B $ECE9,3,3 Move to (101,127)
B $ECEC,2,2 Line 14 pixels down, 1 right every 7, to (103,113)
B $ECEE,2,2 Line 15 pixels up, 1 right every 7, to (105,127)
B $ECF0,3,3 Move to (109,119)
B $ECF3,2,2 Line 15 pixels down, 1 right every 8, to (110,104)
B $ECF5,2,2 Line 16 pixels up, 1 right every 6, to (112,120)
B $ECF7,2,2 Line 4 pixels left, 1 down every 4, to (108,119)
B $ECF9,3,3 Move to (103,104)
B $ECFC,2,2 Line 14 pixels down, 1 right every 7, to (105,90)
B $ECFE,2,2 Line 2 pixels right, 1 down every 2, to (107,89)
B $ED00,2,2 Line 16 pixels up, 1 left every 7, to (105,105)
B $ED02,2,2 Line 3 pixels left, 1 up every 3, to (102,106)
B $ED04,3,3 Move to (95,62)
B $ED07,2,2 Line 14 pixels left, 1 down every 7, to (81,60)
B $ED09,2,2 Line 14 pixels left, 1 down every 6, to (67,58)
B $ED0B,2,2 Line 14 pixels left, 1 down every 5, to (53,56)
B $ED0D,2,2 Line 14 pixels diagonally down-left, to (39,42)
B $ED0F,2,2 Line 14 pixels left, 1 down every 2, to (25,35)
B $ED11,2,2 Line 14 pixels left, 1 down every 2, to (11,28)
B $ED13,2,2 Line 14 pixels left, 1 down every 2, to (0,21)
B $ED15,3,3 Move to (164,58)
B $ED18,2,2 Line 14 pixels right, 1 down every 5, to (178,56)
B $ED1A,2,2 Line 14 pixels right, 1 down every 9, to (192,55)
B $ED1C,2,2 Line 14 pixels right, 1 down every 8, to (206,54)
B $ED1E,2,2 Line 14 pixels right, 1 down every 2, to (220,47)
B $ED20,2,2 Line 14 pixels diagonally down-right, to (234,33)
B $ED22,2,2 Line 14 pixels right, 1 down every 2, to (248,26)
B $ED24,2,2 Line 14 pixels right, 1 down every 6, to (255,24)
B $ED26,2,2 Line 14 pixels right, 1 down every 3, to (255,20)
B $ED28,3,3 Move to (170,34)
B $ED2B,2,2 Line 14 pixels right, 1 down every 3, to (184,30)
B $ED2D,2,2 Line 14 pixels right, 1 down every 2, to (198,23)
B $ED2F,2,2 Line 20 pixels diagonally down-right, to (218,3)
B $ED31,2,2 Line 24 pixels right, 1 down every 4, to (242,0)
B $ED33,3,3 Move to (86,27)
B $ED36,2,2 Line 14 pixels left, 1 down every 4, to (72,24)
B $ED38,2,2 Line 14 pixels left, 1 down every 3, to (58,20)
B $ED3A,2,2 Line 14 pixels left, 1 down every 2, to (44,13)
B $ED3C,2,2 Line 14 pixels diagonally down-left, to (30,0)
B $ED3E,3,3 Move to (44,13)
B $ED41,2,2 Line 30 pixels up, 1 left every 5, to (38,43)
B $ED43,3,3 Move to (57,21)
B $ED46,2,2 Line 35 pixels up, 1 left every 7, to (52,56)
B $ED48,3,3 Move to (162,91)
B $ED4B,2,2 Line 28 pixels right, 1 up every 16, to (190,92)
B $ED4D,2,2 Line 28 pixels right, to (218,92)
B $ED4F,2,2 Line 28 pixels right, 1 down every 8, to (246,89)
B $ED51,2,2 Line 28 pixels right, 1 down every 8, to (255,86)
B $ED53,3,3 Fill from (146,0) in blue
B $ED56,3,3 Move to (186,30)
B $ED59,2,2 Line 23 pixels diagonally up-right, to (209,53)
B $ED5B,3,3 Move to (197,25)
B $ED5E,2,2 Line 23 pixels diagonally up-right, to (220,48)
B $ED60,3,3 Move to (218,5)
B $ED63,2,2 Line 30 pixels up, 1 right every 2, to (233,35)
B $ED65,3,3 Move to (243,0)
B $ED68,2,2 Line 26 pixels up, 1 right every 5, to (248,26)
B $ED6A,3,3 Move to (0,41)
B $ED6D,2,2 Line 20 pixels up, 1 right every 2, to (10,61)
B $ED6F,2,2 Line 13 pixels diagonally up-right, to (23,74)
B $ED71,2,2 Line 13 pixels right, 1 up every 2, to (36,80)
B $ED73,2,2 Line 13 pixels right, 1 up every 2, to (49,86)
B $ED75,2,2 Line 13 pixels diagonally up-right, to (62,99)
B $ED77,2,2 Line 7 pixels diagonally up-right, to (69,106)
B $ED79,2,2 Line 7 pixels down, 1 right every 3, to (71,99)
B $ED7B,2,2 Line 5 pixels right, 1 up every 5, to (76,100)
B $ED7D,2,2 Line 9 pixels up, 1 left every 6, to (75,109)
B $ED7F,2,2 Line 9 pixels down, 1 right every 2, to (79,100)
B $ED81,2,2 Line 9 pixels down, 1 right every 2, to (83,91)
B $ED83,2,2 Line 9 pixels up, 1 right every 5, to (84,100)
B $ED85,2,2 Line 9 pixels up, 1 left every 7, to (83,109)
B $ED87,2,2 Line 9 pixels up, 1 right every 3, to (86,118)
B $ED89,2,2 Line 11 pixels up, 1 right every 6, to (87,127)
B $ED8B,3,3 Move to (4,62)
B $ED8E,2,2 Line 11 pixels up, 1 left every 2, to (0,73)
B $ED90,3,3 Move to (0,75)
B $ED93,2,2 Line 11 pixels right, 1 up every 2, to (11,80)
B $ED95,2,2 Line 6 pixels diagonally up-right, to (17,86)
B $ED97,2,2 Line 12 pixels down, 1 left every 6, to (15,74)
B $ED99,2,2 Line 12 pixels diagonally down-left, to (3,62)
B $ED9B,3,3 Move to (27,82)
B $ED9E,2,2 Line 5 pixels up, to (27,87)
B $EDA0,2,2 Line 6 pixels right, 1 up every 6, to (33,88)
B $EDA2,2,2 Line 7 pixels up, 1 right every 5, to (34,95)
B $EDA4,2,2 Line 6 pixels right, 1 down every 3, to (40,93)
B $EDA6,2,2 Line 4 pixels down, 1 right every 4, to (41,89)
B $EDA8,2,2 Line 15 pixels left, 1 down every 2, to (26,82)
B $EDAA,3,3 Move to (57,104)
B $EDAD,2,2 Line 16 pixels up, 1 right every 11, to (58,120)
B $EDAF,2,2 Line 9 pixels left, 1 down every 4, to (49,118)
B $EDB1,2,2 Line 5 pixels down, 1 left every 5, to (48,113)
B $EDB3,2,2 Line 5 pixels left, 1 down every 5, to (43,112)
B $EDB5,2,2 Line 6 pixels up, to (43,118)
B $EDB7,2,2 Line 7 pixels left, 1 up every 6, to (36,119)
B $EDB9,2,2 Line 7 pixels left, 1 up every 7, to (29,120)
B $EDBB,2,2 Line 7 pixels left, 1 up every 3, to (22,122)
B $EDBD,2,2 Line 6 pixels down, 1 left every 3, to (20,116)
B $EDBF,2,2 Line 6 pixels right, 1 down every 3, to (26,114)
B $EDC1,2,2 Line 6 pixels left, 1 down every 2, to (20,111)
B $EDC3,2,2 Line 9 pixels right, 1 down every 2, to (29,107)
B $EDC5,2,2 Line 9 pixels left, 1 down every 8, to (20,106)
B $EDC7,2,2 Line 9 pixels right, 1 down every 4, to (29,104)
B $EDC9,2,2 Line 9 pixels right, 1 up every 4, to (38,106)
B $EDCB,2,2 Line 9 pixels right, to (47,106)
B $EDCD,2,2 Line 10 pixels right, 1 down every 4, to (57,104)
B $EDCF,3,3 Move to (49,115)
B $EDD2,2,2 Line 9 pixels right, 1 down every 4, to (58,113)
B $EDD4,3,3 Move to (33,118)
B $EDD7,2,2 Line 14 pixels down, 1 right every 5, to (35,104)
B $EDD9,3,3 Move to (64,107)
B $EDDC,2,2 Line 14 pixels up, 1 right every 10, to (65,121)
B $EDDE,2,2 Line 4 pixels diagonally down-right, to (69,117)
B $EDE0,2,2 Line 11 pixels down, 1 left every 2, to (64,106)
B $EDE2,3,3 Move to (48,95)
B $EDE5,2,2 Line 5 pixels left, 1 up every 2, to (43,97)
B $EDE7,2,2 Line 10 pixels right, 1 up every 4, to (53,99)
B $EDE9,2,2 Line 5 pixels diagonally down-left, to (48,94)
B $EDEB,3,3 Move to (60,97)
B $EDEE,2,2 Line 5 pixels right, 1 up every 4, to (65,98)
B $EDF0,2,2 Line 5 pixels up, 1 left every 5, to (64,103)
B $EDF2,3,3 Fill from (64,127) in black
B $EDF5,3,3 Fill from (64,99) in black
B $EDF8,3,3 Move to (38,107)
B $EDFB,2,2 Line 13 pixels up, 1 left every 4, to (35,120)
B $EDFD,3,3 Fill from (36,109) in black
B $EE00,7,7 Paint yellow paper from cell (12,12): 7 right, 1 down, 9 left
B $EE07,10,10 Paint white paper from cell (13,4): 1 left, 3 up, 1 down, 2 up, 1 right, 4 down
B $EE11,3,3 Move to (95,88)
B $EE14,2,2 Line 42 pixels left, 1 up every 12, to (53,91)
B $EE16,3,3 Move to (179,92)
B $EE19,2,2 Line 42 pixels up, 1 left every 4, to (169,127)
B $EE1B,3,3 Move to (225,92)
B $EE1E,2,2 Line 42 pixels up, 1 left every 21, to (223,127)
B $EE20,3,3 Move to (192,69)
B $EE23,2,2 Line 19 pixels right, 1 down every 7, to (211,67)
B $EE25,2,2 Line 19 pixels right, 1 down every 12, to (230,66)
B $EE27,2,2 Line 13 pixels right, 1 up every 9, to (243,67)
B $EE29,2,2 Line 9 pixels up, 1 left every 4, to (241,76)
B $EE2B,2,2 Line 5 pixels left, 1 up every 2, to (236,78)
B $EE2D,2,2 Line 5 pixels left, 1 up every 3, to (231,79)
B $EE2F,2,2 Line 5 pixels left, 1 up every 4, to (226,80)
B $EE31,2,2 Line 5 pixels left, 1 down every 4, to (221,79)
B $EE33,2,2 Line 5 pixels left, 1 down every 5, to (216,78)
B $EE35,2,2 Line 5 pixels left, 1 down every 4, to (211,77)
B $EE37,2,2 Line 5 pixels left, 1 down every 3, to (206,76)
B $EE39,2,2 Line 5 pixels left, 1 down every 2, to (201,74)
B $EE3B,2,2 Line 5 pixels left, 1 down every 4, to (196,73)
B $EE3D,2,2 Line 5 pixels diagonally down-left, to (191,68)
B $EE3F,3,3 Fill from (200,71) in yellow
B $EE42,1,1 End of picture
b $EE43 Picture: room 41 (?)
D $EE43 The picture for room 41 (?). It is 446 bytes long: 132 lines, 36 moves, 16 fills and 1 painted areas. See #R$8985 for the format.
D $EE43 #HTML[<img src="../images/pictures/room41.png" alt="room 41">]
B $EE43,2,2 Border white, picture area black ink on white paper
B $EE45,3,3 Move to (255,126)
B $EE48,2,2 Line 63 pixels left, 1 down every 6, to (192,116)
B $EE4A,2,2 Line 63 pixels left, 1 down every 6, to (129,106)
B $EE4C,3,3 Move to (8,0)
B $EE4F,2,2 Line 63 pixels up, to (8,63)
B $EE51,2,2 Line 32 pixels up, to (8,95)
B $EE53,2,2 Line 8 pixels up, 1 right every 5, to (9,103)
B $EE55,2,2 Line 8 pixels up, 1 right every 3, to (11,111)
B $EE57,2,2 Line 8 pixels up, 1 right every 2, to (15,119)
B $EE59,2,2 Line 8 pixels right, 1 up every 2, to (23,123)
B $EE5B,2,2 Line 8 pixels right, 1 down every 3, to (31,121)
B $EE5D,2,2 Line 8 pixels down, 1 right every 2, to (35,113)
B $EE5F,2,2 Line 8 pixels down, 1 right every 5, to (36,105)
B $EE61,2,2 Line 8 pixels down, 1 right every 8, to (37,97)
B $EE63,2,2 Line 63 pixels down, to (37,34)
B $EE65,2,2 Line 32 pixels down, 1 left every 32, to (36,2)
B $EE67,3,3 Move to (255,100)
B $EE6A,2,2 Line 63 pixels left, 1 down every 10, to (192,94)
B $EE6C,2,2 Line 63 pixels left, 1 down every 9, to (129,87)
B $EE6E,3,3 Move to (45,4)
B $EE71,2,2 Line 63 pixels up, to (45,67)
B $EE73,2,2 Line 29 pixels up, 1 right every 29, to (46,96)
B $EE75,2,2 Line 8 pixels up, 1 right every 6, to (47,104)
B $EE77,2,2 Line 8 pixels up, 1 right every 3, to (49,112)
B $EE79,2,2 Line 4 pixels diagonally up-right, to (53,116)
B $EE7B,2,2 Line 4 pixels right, 1 up every 2, to (57,118)
B $EE7D,2,2 Line 4 pixels diagonally down-right, to (61,114)
B $EE7F,2,2 Line 4 pixels down, 1 right every 2, to (63,110)
B $EE81,2,2 Line 4 pixels down, 1 right every 4, to (64,106)
B $EE83,2,2 Line 4 pixels down, 1 right every 4, to (65,102)
B $EE85,2,2 Line 4 pixels down, to (65,98)
B $EE87,2,2 Line 4 pixels down, 1 right every 4, to (66,94)
B $EE89,2,2 Line 63 pixels down, to (66,31)
B $EE8B,2,2 Line 25 pixels down, to (66,6)
B $EE8D,3,3 Move to (73,7)
B $EE90,2,2 Line 63 pixels up, to (73,70)
B $EE92,2,2 Line 24 pixels up, to (73,94)
B $EE94,2,2 Line 5 pixels up, 1 right every 3, to (74,99)
B $EE96,2,2 Line 5 pixels up, 1 right every 2, to (76,104)
B $EE98,2,2 Line 5 pixels up, 1 right every 2, to (78,109)
B $EE9A,2,2 Line 4 pixels diagonally up-right, to (82,113)
B $EE9C,2,2 Line 4 pixels diagonally down-right, to (86,109)
B $EE9E,2,2 Line 4 pixels down, 1 right every 2, to (88,105)
B $EEA0,2,2 Line 4 pixels down, 1 right every 3, to (89,101)
B $EEA2,2,2 Line 4 pixels down, 1 right every 4, to (90,97)
B $EEA4,2,2 Line 4 pixels down, 1 right every 4, to (91,93)
B $EEA6,2,2 Line 63 pixels down, to (91,30)
B $EEA8,2,2 Line 22 pixels down, 1 right every 22, to (92,8)
B $EEAA,3,3 Move to (37,2)
B $EEAD,2,2 Line 4 pixels right, 1 down every 2, to (41,0)
B $EEAF,3,3 Move to (66,6)
B $EEB2,2,2 Line 4 pixels right, 1 down every 2, to (70,4)
B $EEB4,3,3 Move to (91,9)
B $EEB7,2,2 Line 29 pixels right, 1 up every 6, to (120,13)
B $EEB9,2,2 Line 10 pixels right, 1 down every 5, to (130,11)
B $EEBB,3,3 Move to (121,14)
B $EEBE,2,2 Line 63 pixels up, to (121,77)
B $EEC0,2,2 Line 52 pixels up, to (121,127)
B $EEC2,3,3 Move to (129,87)
B $EEC5,2,2 Line 9 pixels left, 1 up every 9, to (120,88)
B $EEC7,3,3 Move to (129,105)
B $EECA,2,2 Line 9 pixels left, 1 down every 5, to (120,104)
B $EECC,3,3 Move to (90,9)
B $EECF,2,2 Line 18 pixels left, 1 up every 2, to (72,18)
B $EED1,3,3 Move to (66,6)
B $EED4,2,2 Line 22 pixels left, 1 up every 2, to (44,17)
B $EED6,3,3 Move to (37,3)
B $EED9,2,2 Line 30 pixels left, 1 up every 2, to (7,18)
B $EEDB,3,3 Move to (111,0)
B $EEDE,3,3 Move to (102,0)
B $EEE1,2,2 Line 15 pixels right, 1 up every 4, to (117,3)
B $EEE3,2,2 Line 9 pixels diagonally up-right, to (126,12)
B $EEE5,2,2 Line 25 pixels right, 1 up every 3, to (151,20)
B $EEE7,2,2 Line 10 pixels right, 1 down every 8, to (161,19)
B $EEE9,2,2 Line 10 pixels up, 1 right every 2, to (166,29)
B $EEEB,2,2 Line 14 pixels right, 1 down every 5, to (180,27)
B $EEED,2,2 Line 14 pixels right, 1 up every 4, to (194,30)
B $EEEF,2,2 Line 11 pixels up, 1 right every 2, to (199,41)
B $EEF1,2,2 Line 23 pixels right, 1 down every 6, to (222,38)
B $EEF3,2,2 Line 8 pixels down, 1 right every 2, to (226,30)
B $EEF5,2,2 Line 15 pixels right, 1 down every 3, to (241,25)
B $EEF7,2,2 Line 15 pixels right, 1 up every 4, to (255,28)
B $EEF9,3,3 Move to (205,7)
B $EEFC,2,2 Line 9 pixels right, 1 up every 4, to (214,9)
B $EEFE,2,2 Line 16 pixels left, 1 up every 4, to (198,13)
B $EF00,2,2 Line 10 pixels left, 1 down every 3, to (188,10)
B $EF02,3,3 Move to (199,13)
B $EF05,2,2 Line 10 pixels up, 1 left every 3, to (196,23)
B $EF07,2,2 Line 18 pixels right, 1 down every 4, to (214,19)
B $EF09,2,2 Line 11 pixels down, 1 right every 5, to (216,8)
B $EF0B,2,2 Line 4 pixels diagonally up-right, to (220,12)
B $EF0D,2,2 Line 9 pixels up, 1 left every 5, to (219,21)
B $EF0F,2,2 Line 6 pixels left, 1 down every 2, to (213,18)
B $EF11,3,3 Move to (219,21)
B $EF14,2,2 Line 17 pixels left, 1 up every 4, to (202,25)
B $EF16,2,2 Line 7 pixels left, 1 down every 2, to (195,22)
B $EF18,3,3 Move to (214,8)
B $EF1B,2,2 Line 5 pixels down, 1 right every 5, to (215,3)
B $EF1D,3,3 Move to (222,38)
B $EF20,2,2 Line 9 pixels up, 1 left every 5, to (221,47)
B $EF22,2,2 Line 5 pixels diagonally down-right, to (226,42)
B $EF24,2,2 Line 8 pixels up, 1 right every 4, to (228,50)
B $EF26,2,2 Line 10 pixels down, 1 right every 2, to (233,40)
B $EF28,2,2 Line 6 pixels up, 1 right every 2, to (236,46)
B $EF2A,2,2 Line 12 pixels down, 1 right every 7, to (237,34)
B $EF2C,2,2 Line 12 pixels up, 1 right every 3, to (241,46)
B $EF2E,2,2 Line 24 pixels down, 1 right every 7, to (244,22)
B $EF30,3,3 Move to (223,34)
B $EF33,2,2 Line 15 pixels down, 1 right every 2, to (230,19)
B $EF35,2,2 Line 35 pixels right, 1 down every 5, to (255,12)
B $EF37,3,3 Move to (132,12)
B $EF3A,2,2 Line 32 pixels down, 1 right every 2, to (148,0)
B $EF3C,3,3 Move to (37,9)
B $EF3F,2,2 Line 10 pixels left, 1 up every 2, to (27,14)
B $EF41,2,2 Line 3 pixels up, 1 right every 2, to (28,17)
B $EF43,2,2 Line 3 pixels right, 1 up every 2, to (31,18)
B $EF45,2,2 Line 3 pixels right, 1 up every 3, to (34,19)
B $EF47,2,2 Line 3 pixels right, 1 down every 2, to (37,18)
B $EF49,3,3 Move to (65,13)
B $EF4C,2,2 Line 7 pixels left, 1 up every 2, to (58,16)
B $EF4E,2,2 Line 3 pixels up, 1 left every 2, to (57,19)
B $EF50,2,2 Line 2 pixels up, 1 right every 2, to (58,21)
B $EF52,2,2 Line 3 pixels right, 1 up every 2, to (61,22)
B $EF54,2,2 Line 3 pixels right, 1 down every 2, to (64,21)
B $EF56,2,2 Line 3 pixels diagonally down-right, to (67,18)
B $EF58,3,3 Fill from (21,24) in black
B $EF5B,3,3 Fill from (50,24) in black
B $EF5E,3,3 Fill from (84,24) in black
B $EF61,3,3 Move to (40,1)
B $EF64,2,2 Line 5 pixels right, 1 up every 2, to (45,3)
B $EF66,3,3 Move to (70,5)
B $EF69,2,2 Line 3 pixels right, 1 up every 2, to (73,6)
B $EF6B,3,3 Fill from (255,98) in blue
B $EF6E,3,3 Fill from (248,127) in blue
B $EF71,3,3 Fill from (255,24) in yellow
B $EF74,3,3 Fill from (130,3) in yellow
B $EF77,23,8 Paint yellow paper from cell (25,11): 2 right, 1 down, 1 right, 1 down, 3 right, 2 down, 15 left, 1 up, 14 right, 3 left, 1 up, 10 left, 4 right, 1 left, 1 up, 7 right, 3 left, 2 up, 3 right
B $EF8E,3,3 Move to (157,6)
B $EF91,2,2 Line 3 pixels diagonally up-right, to (160,9)
B $EF93,2,2 Line 3 pixels diagonally down-right, to (163,6)
B $EF95,2,2 Line 3 pixels diagonally down-left, to (160,3)
B $EF97,2,2 Line 3 pixels diagonally up-left, to (157,6)
B $EF99,3,3 Fill from (159,6) in red
B $EF9C,3,3 Move to (171,6)
B $EF9F,2,2 Line 2 pixels diagonally up-right, to (173,8)
B $EFA1,2,2 Line 2 pixels diagonally down-right, to (175,6)
B $EFA3,2,2 Line 3 pixels diagonally down-left, to (172,3)
B $EFA5,2,2 Line 4 pixels up, 1 left every 2, to (170,7)
B $EFA7,3,3 Fill from (172,5) in green
B $EFAA,3,3 Move to (172,17)
B $EFAD,2,2 Line 4 pixels up, 1 left every 2, to (170,21)
B $EFAF,2,2 Line 4 pixels right, 1 up every 3, to (174,22)
B $EFB1,2,2 Line 4 pixels down, 1 left every 3, to (173,18)
B $EFB3,3,3 Fill from (173,20) in cyan
B $EFB6,3,3 Move to (150,13)
B $EFB9,2,2 Line 4 pixels down, 1 left every 3, to (149,9)
B $EFBB,2,2 Line 4 pixels diagonally up-left, to (145,13)
B $EFBD,2,2 Line 4 pixels right, 1 up every 4, to (149,14)
B $EFBF,2,2 Line 4 pixels down, 1 right every 3, to (150,10)
B $EFC1,3,3 Fill from (148,12) in magenta
B $EFC4,3,3 Move to (211,31)
B $EFC7,2,2 Line 4 pixels down, 1 right every 3, to (212,27)
B $EFC9,2,2 Line 4 pixels diagonally up-right, to (216,31)
B $EFCB,2,2 Line 5 pixels left, 1 down every 4, to (211,30)
B $EFCD,3,3 Fill from (213,30) in white
B $EFD0,3,3 Move to (197,8)
B $EFD3,2,2 Line 5 pixels left, 1 down every 4, to (192,7)
B $EFD5,2,2 Line 5 pixels right, 1 down every 2, to (197,5)
B $EFD7,2,2 Line 4 pixels up, 1 right every 3, to (198,9)
B $EFD9,3,3 Fill from (196,7) in blue
B $EFDC,3,3 Move to (233,8)
B $EFDF,2,2 Line 4 pixels up, 1 right every 3, to (234,12)
B $EFE1,2,2 Line 4 pixels down, 1 right every 2, to (236,8)
B $EFE3,2,2 Line 4 pixels left, to (232,8)
B $EFE5,3,3 Fill from (233,9) in red
B $EFE8,3,3 Move to (245,11)
B $EFEB,2,2 Line 5 pixels left, 1 down every 5, to (240,10)
B $EFED,2,2 Line 5 pixels up, 1 right every 2, to (242,15)
B $EFEF,2,2 Line 5 pixels diagonally down-right, to (247,10)
B $EFF1,3,3 Fill from (243,12) in green
B $EFF4,3,3 Move to (225,1)
B $EFF7,2,2 Line 5 pixels right, to (230,1)
B $EFF9,2,2 Line 5 pixels up, 1 left every 4, to (229,6)
B $EFFB,2,2 Line 5 pixels diagonally down-left, to (224,1)
B $EFFD,3,3 Fill from (228,3) in white
B $F000,1,1 End of picture
b $F001 Picture: room 26 (?)
D $F001 The picture for room 26 (?). It is 485 bytes long: 175 lines, 35 moves, 4 fills and 2 painted areas. See #R$8985 for the format.
D $F001 #HTML[<img src="../images/pictures/room26.png" alt="room 26">]
B $F001,2,2 Border red, picture area black ink on red paper
B $F003,3,3 Move to (93,0)
B $F006,2,2 Line 26 pixels left, 1 up every 2, to (67,13)
B $F008,2,2 Line 22 pixels up, 1 left every 2, to (56,35)
B $F00A,2,2 Line 17 pixels diagonally down-right, to (73,18)
B $F00C,2,2 Line 25 pixels right, 1 down every 3, to (98,10)
B $F00E,2,2 Line 46 pixels right, 1 up every 31, to (144,11)
B $F010,2,2 Line 28 pixels diagonally up-right, to (172,39)
B $F012,2,2 Line 50 pixels left, 1 up every 2, to (122,64)
B $F014,2,2 Line 63 pixels left, 1 down every 4, to (59,49)
B $F016,2,2 Line 26 pixels left, 1 down every 4, to (33,43)
B $F018,2,2 Line 11 pixels left, 1 down every 2, to (22,38)
B $F01A,2,2 Line 11 pixels diagonally down-left, to (11,27)
B $F01C,2,2 Line 11 pixels up, 1 right every 2, to (16,38)
B $F01E,2,2 Line 11 pixels diagonally up-right, to (27,49)
B $F020,2,2 Line 63 pixels right, 1 up every 4, to (90,64)
B $F022,2,2 Line 39 pixels right, 1 up every 4, to (129,73)
B $F024,2,2 Line 22 pixels right, 1 down every 3, to (151,66)
B $F026,2,2 Line 10 pixels up, 1 left every 2, to (146,76)
B $F028,2,2 Line 59 pixels left, 1 up every 14, to (87,80)
B $F02A,2,2 Line 31 pixels left, 1 down every 15, to (56,78)
B $F02C,2,2 Line 12 pixels left, 1 down every 2, to (44,72)
B $F02E,2,2 Line 12 pixels down, 1 left every 7, to (43,60)
B $F030,2,2 Line 13 pixels up, 1 left every 7, to (42,73)
B $F032,2,2 Line 12 pixels diagonally up-right, to (54,85)
B $F034,2,2 Line 36 pixels right, 1 up every 7, to (90,90)
B $F036,2,2 Line 61 pixels right, 1 up every 43, to (151,91)
B $F038,2,2 Line 10 pixels diagonally down-right, to (161,81)
B $F03A,2,2 Line 16 pixels up, 1 left every 3, to (156,97)
B $F03C,2,2 Line 59 pixels left, 1 up every 23, to (97,99)
B $F03E,2,2 Line 14 pixels left, 1 up every 14, to (83,100)
B $F040,2,2 Line 33 pixels left, 1 down every 3, to (50,89)
B $F042,2,2 Line 20 pixels diagonally down-left, to (30,69)
B $F044,2,2 Line 15 pixels down, 1 left every 5, to (27,54)
B $F046,2,2 Line 20 pixels up, 1 left every 15, to (26,74)
B $F048,2,2 Line 25 pixels diagonally up-right, to (51,99)
B $F04A,2,2 Line 34 pixels right, 1 up every 3, to (85,110)
B $F04C,2,2 Line 63 pixels right, 1 up every 54, to (148,111)
B $F04E,2,2 Line 19 pixels right, 1 up every 19, to (167,112)
B $F050,2,2 Line 22 pixels down, 1 right every 3, to (174,90)
B $F052,2,2 Line 15 pixels up, 1 right every 13, to (175,105)
B $F054,2,2 Line 55 pixels right, 1 up every 6, to (230,114)
B $F056,2,2 Line 20 pixels right, 1 down every 2, to (250,104)
B $F058,2,2 Line 20 pixels down, 1 right every 3, to (255,84)
B $F05A,2,2 Line 10 pixels down, 1 left every 3, to (252,74)
B $F05C,2,2 Line 10 pixels up, 1 left every 6, to (251,84)
B $F05E,2,2 Line 16 pixels up, 1 left every 2, to (243,100)
B $F060,2,2 Line 16 pixels left, 1 up every 3, to (227,105)
B $F062,2,2 Line 41 pixels left, 1 down every 4, to (186,95)
B $F064,2,2 Line 14 pixels down, 1 left every 7, to (184,81)
B $F066,2,2 Line 4 pixels diagonally up-right, to (188,85)
B $F068,2,2 Line 4 pixels up, 1 right every 2, to (190,89)
B $F06A,2,2 Line 4 pixels diagonally up-right, to (194,93)
B $F06C,2,2 Line 4 pixels right, 1 up every 2, to (198,95)
B $F06E,2,2 Line 4 pixels right, 1 up every 3, to (202,96)
B $F070,2,2 Line 4 pixels right, 1 up every 4, to (206,97)
B $F072,2,2 Line 4 pixels right, to (210,97)
B $F074,2,2 Line 4 pixels right, 1 down every 4, to (214,96)
B $F076,2,2 Line 4 pixels right, 1 down every 3, to (218,95)
B $F078,2,2 Line 4 pixels right, 1 down every 2, to (222,93)
B $F07A,2,2 Line 4 pixels diagonally down-right, to (226,89)
B $F07C,2,2 Line 4 pixels down, 1 right every 2, to (228,85)
B $F07E,2,2 Line 4 pixels down, 1 right every 2, to (230,81)
B $F080,2,2 Line 4 pixels down, 1 right every 3, to (231,77)
B $F082,2,2 Line 4 pixels down, 1 right every 4, to (232,73)
B $F084,2,2 Line 4 pixels down, 1 left every 4, to (231,69)
B $F086,2,2 Line 4 pixels down, 1 left every 3, to (230,65)
B $F088,2,2 Line 4 pixels diagonally down-left, to (226,61)
B $F08A,2,2 Line 4 pixels diagonally down-left, to (222,57)
B $F08C,2,2 Line 4 pixels left, 1 down every 2, to (218,55)
B $F08E,2,2 Line 4 pixels left, 1 down every 4, to (214,54)
B $F090,2,2 Line 4 pixels left, 1 up every 4, to (210,55)
B $F092,2,2 Line 4 pixels left, 1 up every 3, to (206,56)
B $F094,2,2 Line 4 pixels left, 1 up every 3, to (202,57)
B $F096,2,2 Line 4 pixels left, 1 up every 3, to (198,58)
B $F098,2,2 Line 4 pixels left, 1 up every 4, to (194,59)
B $F09A,2,2 Line 5 pixels diagonally down-right, to (199,54)
B $F09C,2,2 Line 39 pixels right, 1 down every 5, to (238,47)
B $F09E,2,2 Line 39 pixels up, 1 left every 17, to (236,86)
B $F0A0,2,2 Line 11 pixels diagonally up-left, to (225,97)
B $F0A2,2,2 Line 11 pixels left, 1 up every 2, to (214,102)
B $F0A4,2,2 Line 13 pixels right, 1 down every 7, to (227,101)
B $F0A6,2,2 Line 6 pixels right, 1 down every 2, to (233,98)
B $F0A8,2,2 Line 13 pixels diagonally down-right, to (246,85)
B $F0AA,2,2 Line 51 pixels down, 1 right every 28, to (247,34)
B $F0AC,2,2 Line 40 pixels left, 1 up every 6, to (207,40)
B $F0AE,2,2 Line 30 pixels down, 1 right every 3, to (217,10)
B $F0B0,2,2 Line 30 pixels right, 1 down every 12, to (247,8)
B $F0B2,2,2 Line 25 pixels up, 1 right every 4, to (253,33)
B $F0B4,2,2 Line 14 pixels up, 1 left every 2, to (246,47)
B $F0B6,3,3 Move to (248,49)
B $F0B9,2,2 Line 14 pixels diagonally down-right, to (255,35)
B $F0BB,3,3 Move to (255,8)
B $F0BE,2,2 Line 14 pixels down, 1 left every 3, to (251,0)
B $F0C0,3,3 Move to (207,0)
B $F0C3,2,2 Line 24 pixels up, 1 left every 3, to (199,24)
B $F0C5,2,2 Line 26 pixels down, 1 left every 2, to (186,0)
B $F0C7,3,3 Move to (171,0)
B $F0CA,2,2 Line 20 pixels up, 1 right every 2, to (181,20)
B $F0CC,2,2 Line 25 pixels diagonally down-left, to (156,0)
B $F0CE,3,3 Move to (111,11)
B $F0D1,2,2 Line 18 pixels up, 1 left every 7, to (109,29)
B $F0D3,2,2 Line 21 pixels up, 1 right every 2, to (119,50)
B $F0D5,2,2 Line 21 pixels down, 1 left every 10, to (117,29)
B $F0D7,2,2 Line 20 pixels down, 1 right every 5, to (121,9)
B $F0D9,3,3 Move to (196,76)
B $F0DC,2,2 Line 9 pixels down, 1 right every 2, to (200,67)
B $F0DE,2,2 Line 9 pixels right, 1 up every 5, to (209,68)
B $F0E0,2,2 Line 9 pixels right, 1 up every 2, to (218,72)
B $F0E2,2,2 Line 9 pixels up, 1 right every 3, to (221,81)
B $F0E4,2,2 Line 6 pixels diagonally up-left, to (215,87)
B $F0E6,2,2 Line 6 pixels left, 1 up every 5, to (209,88)
B $F0E8,2,2 Line 10 pixels left, 1 down every 3, to (199,85)
B $F0EA,2,2 Line 10 pixels down, 1 left every 3, to (196,75)
B $F0EC,3,3 Fill from (189,75) in black
B $F0EF,3,3 Fill from (115,26) in black
B $F0F2,3,3 Move to (166,41)
B $F0F5,2,2 Line 9 pixels down, 1 right every 4, to (168,32)
B $F0F7,3,3 Move to (148,16)
B $F0FA,2,2 Line 10 pixels up, 1 right every 6, to (149,26)
B $F0FC,2,2 Line 9 pixels left, 1 down every 7, to (140,25)
B $F0FE,2,2 Line 4 pixels left, 1 down every 3, to (136,24)
B $F100,2,2 Line 4 pixels up, to (136,28)
B $F102,2,2 Line 4 pixels up, 1 right every 3, to (137,32)
B $F104,2,2 Line 4 pixels diagonally up-right, to (141,36)
B $F106,2,2 Line 4 pixels up, 1 right every 3, to (142,40)
B $F108,2,2 Line 4 pixels diagonally up-right, to (146,44)
B $F10A,2,2 Line 4 pixels right, 1 up every 2, to (150,46)
B $F10C,2,2 Line 9 pixels right, 1 down every 5, to (159,45)
B $F10E,3,3 Move to (146,34)
B $F111,2,2 Line 3 pixels diagonally up-right, to (149,37)
B $F113,2,2 Line 3 pixels down, 1 right every 2, to (150,34)
B $F115,2,2 Line 4 pixels left, 1 down every 4, to (146,33)
B $F117,3,3 Move to (153,27)
B $F11A,2,2 Line 3 pixels diagonally up-right, to (156,30)
B $F11C,2,2 Line 3 pixels down, 1 right every 2, to (157,27)
B $F11E,2,2 Line 4 pixels left, 1 up every 3, to (153,28)
B $F120,3,3 Move to (153,35)
B $F123,2,2 Line 3 pixels diagonally up-right, to (156,38)
B $F125,2,2 Line 3 pixels down, 1 right every 2, to (157,35)
B $F127,2,2 Line 4 pixels left, 1 up every 4, to (153,36)
B $F129,3,3 Fill from (151,32) in black
B $F12C,3,3 Move to (67,127)
B $F12F,2,2 Line 28 pixels down, 1 left every 2, to (53,99)
B $F131,3,3 Move to (48,86)
B $F134,2,2 Line 40 pixels down, 1 left every 19, to (46,46)
B $F136,2,2 Line 50 pixels down, 1 right every 3, to (62,0)
B $F138,3,3 Move to (0,40)
B $F13B,2,2 Line 50 pixels right, 1 up every 8, to (50,46)
B $F13D,2,2 Line 50 pixels right, 1 up every 8, to (100,52)
B $F13F,2,2 Line 50 pixels right, 1 up every 8, to (150,58)
B $F141,3,3 Move to (220,58)
B $F144,2,2 Line 50 pixels right, 1 down every 3, to (255,42)
B $F146,3,3 Move to (0,96)
B $F149,2,2 Line 50 pixels right, 1 down every 14, to (50,93)
B $F14B,2,2 Line 50 pixels right, 1 down every 14, to (100,90)
B $F14D,3,3 Move to (228,87)
B $F150,2,2 Line 50 pixels right, 1 up every 5, to (255,97)
B $F152,3,3 Move to (207,101)
B $F155,2,2 Line 50 pixels up, 1 right every 2, to (232,127)
B $F157,3,3 Move to (171,101)
B $F15A,2,2 Line 50 pixels up, 1 right every 28, to (172,127)
B $F15C,3,3 Move to (145,92)
B $F15F,2,2 Line 51 pixels diagonally up-left, to (94,127)
B $F161,3,3 Move to (148,22)
B $F164,2,2 Line 51 pixels diagonally down-left, to (97,0)
B $F166,3,3 Move to (172,15)
B $F169,2,2 Line 51 pixels down, 1 left every 19, to (170,0)
B $F16B,3,3 Move to (213,25)
B $F16E,2,2 Line 51 pixels diagonally down-right, to (255,0)
B $F170,3,3 Move to (114,123)
B $F173,2,2 Line 34 pixels down, 1 left every 2, to (97,89)
B $F175,2,2 Line 39 pixels down, 1 left every 18, to (95,50)
B $F177,2,2 Line 63 pixels down, 1 right every 2, to (126,0)
B $F179,3,3 Move to (116,123)
B $F17C,2,2 Line 57 pixels right, 1 up every 10, to (173,127)
B $F17E,3,3 Move to (180,127)
B $F181,2,2 Line 38 pixels right, 1 down every 8, to (218,123)
B $F183,2,2 Line 33 pixels diagonally down-right, to (251,90)
B $F185,2,2 Line 44 pixels down, 1 right every 17, to (253,46)
B $F187,2,2 Line 36 pixels down, 1 left every 2, to (235,10)
B $F189,3,3 Move to (127,109)
B $F18C,2,2 Line 23 pixels down, 1 left every 3, to (120,86)
B $F18E,2,2 Line 32 pixels down, 1 left every 8, to (116,54)
B $F190,2,2 Line 44 pixels down, 1 right every 2, to (138,10)
B $F192,2,2 Line 43 pixels right, 1 down every 3, to (181,0)
B $F194,2,2 Line 50 pixels right, 1 up every 3, to (231,16)
B $F196,2,2 Line 36 pixels up, 1 right every 2, to (249,52)
B $F198,3,3 Move to (211,113)
B $F19B,2,2 Line 41 pixels left, 1 up every 10, to (170,117)
B $F19D,3,3 Move to (170,115)
B $F1A0,2,2 Line 43 pixels left, 1 down every 10, to (127,111)
B $F1A2,3,3 Move to (139,97)
B $F1A5,2,2 Line 12 pixels down, 1 left every 3, to (135,85)
B $F1A7,2,2 Line 31 pixels down, 1 left every 16, to (134,54)
B $F1A9,2,2 Line 16 pixels down, 1 right every 2, to (142,38)
B $F1AB,3,3 Move to (212,29)
B $F1AE,2,2 Line 28 pixels up, 1 right every 2, to (226,57)
B $F1B0,2,2 Line 6 pixels up, 1 left every 6, to (225,63)
B $F1B2,3,3 Move to (225,87)
B $F1B5,2,2 Line 17 pixels diagonally up-left, to (208,104)
B $F1B7,3,3 Move to (187,106)
B $F1BA,2,2 Line 19 pixels left, 1 down every 17, to (168,105)
B $F1BC,9,9 Paint green paper from cell (25,5): 2 right, 1 down, 3 left, 1 down, 3 right
B $F1C5,6,6 Paint yellow paper from cell (18,11): 1 right, 2 down
B $F1CB,3,3 Move to (22,122)
B $F1CE,2,2 Line 7 pixels left, 1 down every 5, to (15,121)
B $F1D0,2,2 Line 7 pixels right, 1 down every 5, to (22,120)
B $F1D2,2,2 Line 5 pixels diagonally down-right, to (27,115)
B $F1D4,2,2 Line 5 pixels down, 1 right every 5, to (28,110)
B $F1D6,2,2 Line 6 pixels down, 1 left every 2, to (25,104)
B $F1D8,2,2 Line 5 pixels diagonally up-right, to (30,109)
B $F1DA,2,2 Line 5 pixels up, to (30,114)
B $F1DC,2,2 Line 4 pixels up, 1 left every 3, to (29,118)
B $F1DE,2,2 Line 4 pixels diagonally up-left, to (25,122)
B $F1E0,2,2 Line 5 pixels left, 1 down every 5, to (20,121)
B $F1E2,3,3 Fill from (20,121) in yellow
B $F1E5,1,1 End of picture
b $F1E6 Picture: room 39 (?)
D $F1E6 The picture for room 39 (?). It is 373 bytes long: 114 lines, 16 moves, 13 fills and 4 painted areas. See #R$8985 for the format.
D $F1E6 #HTML[<img src="../images/pictures/room39.png" alt="room 39">]
B $F1E6,2,2 Border white, picture area black ink on white paper
B $F1E8,3,3 Move to (0,45)
B $F1EB,2,2 Line 17 pixels right, 1 down every 4, to (17,41)
B $F1ED,2,2 Line 27 pixels right, 1 down every 11, to (44,39)
B $F1EF,2,2 Line 27 pixels right, 1 down every 6, to (71,35)
B $F1F1,3,3 Move to (0,34)
B $F1F4,2,2 Line 27 pixels right, 1 down every 12, to (27,32)
B $F1F6,2,2 Line 8 pixels down, 1 right every 3, to (29,24)
B $F1F8,2,2 Line 27 pixels right, 1 down every 4, to (56,18)
B $F1FA,3,3 Move to (0,0)
B $F1FD,2,2 Line 27 pixels right, 1 up every 4, to (27,6)
B $F1FF,2,2 Line 27 pixels right, 1 up every 3, to (54,15)
B $F201,2,2 Line 5 pixels diagonally up-right, to (59,20)
B $F203,2,2 Line 24 pixels right, 1 up every 3, to (83,28)
B $F205,2,2 Line 24 pixels right, 1 up every 6, to (107,32)
B $F207,2,2 Line 24 pixels right, 1 up every 14, to (131,33)
B $F209,2,2 Line 24 pixels right, 1 up every 15, to (155,34)
B $F20B,2,2 Line 24 pixels right, 1 up every 20, to (179,35)
B $F20D,2,2 Line 18 pixels right, 1 down every 17, to (197,34)
B $F20F,2,2 Line 18 pixels right, 1 up every 2, to (215,43)
B $F211,2,2 Line 18 pixels diagonally up-right, to (233,61)
B $F213,2,2 Line 18 pixels down, 1 left every 2, to (224,43)
B $F215,2,2 Line 14 pixels diagonally down-left, to (210,29)
B $F217,2,2 Line 14 pixels left, 1 down every 4, to (196,26)
B $F219,2,2 Line 14 pixels left, 1 down every 3, to (182,22)
B $F21B,2,2 Line 14 pixels left, 1 down every 2, to (168,15)
B $F21D,2,2 Line 14 pixels diagonally down-left, to (154,1)
B $F21F,2,2 Line 14 pixels diagonally down-left, to (140,0)
B $F221,3,3 Move to (45,22)
B $F224,2,2 Line 14 pixels right, 1 up every 2, to (59,29)
B $F226,2,2 Line 14 pixels right, 1 up every 2, to (73,36)
B $F228,2,2 Line 14 pixels right, 1 up every 5, to (87,38)
B $F22A,2,2 Line 14 pixels right, 1 up every 4, to (101,41)
B $F22C,2,2 Line 14 pixels right, 1 up every 5, to (115,43)
B $F22E,2,2 Line 14 pixels right, 1 up every 10, to (129,44)
B $F230,2,2 Line 14 pixels right, 1 down every 5, to (143,42)
B $F232,2,2 Line 16 pixels right, 1 down every 2, to (159,34)
B $F234,3,3 Move to (151,39)
B $F237,2,2 Line 16 pixels right, 1 down every 14, to (167,38)
B $F239,2,2 Line 16 pixels right, 1 up every 13, to (183,39)
B $F23B,2,2 Line 16 pixels right, 1 up every 3, to (199,44)
B $F23D,2,2 Line 16 pixels right, 1 up every 2, to (215,52)
B $F23F,2,2 Line 16 pixels up, 1 right every 4, to (219,68)
B $F241,2,2 Line 16 pixels diagonally up-right, to (235,84)
B $F243,2,2 Line 22 pixels right, 1 up every 6, to (255,87)
B $F245,3,3 Move to (234,61)
B $F248,2,2 Line 22 pixels right, 1 up every 6, to (255,64)
B $F24A,3,3 Move to (202,0)
B $F24D,2,2 Line 22 pixels right, 1 up every 4, to (224,5)
B $F24F,2,2 Line 22 pixels right, 1 up every 2, to (246,16)
B $F251,2,2 Line 22 pixels diagonally up-right, to (255,38)
B $F253,3,3 Move to (163,31)
B $F256,2,2 Line 22 pixels up, 1 right every 4, to (168,53)
B $F258,2,2 Line 10 pixels up, 1 right every 6, to (169,63)
B $F25A,2,2 Line 10 pixels down, 1 right every 4, to (171,53)
B $F25C,2,2 Line 21 pixels down, 1 right every 4, to (176,32)
B $F25E,2,2 Line 4 pixels diagonally down-left, to (172,28)
B $F260,2,2 Line 4 pixels left, 1 down every 2, to (168,26)
B $F262,2,2 Line 5 pixels diagonally up-left, to (163,31)
B $F264,2,2 Line 12 pixels left, 1 down every 6, to (151,29)
B $F266,2,2 Line 12 pixels left, 1 down every 5, to (139,27)
B $F268,2,2 Line 12 pixels left, 1 down every 3, to (127,23)
B $F26A,2,2 Line 12 pixels left, 1 down every 2, to (115,17)
B $F26C,2,2 Line 12 pixels right, 1 up every 7, to (127,18)
B $F26E,2,2 Line 12 pixels right, 1 up every 4, to (139,21)
B $F270,2,2 Line 12 pixels right, 1 up every 4, to (151,24)
B $F272,2,2 Line 17 pixels right, 1 up every 6, to (168,26)
B $F274,3,3 Fill from (165,32) in black
B $F277,3,3 Fill from (167,36) in black
B $F27A,3,3 Fill from (166,40) in black
B $F27D,3,3 Fill from (161,29) in black
B $F280,3,3 Fill from (174,32) in green
B $F283,3,3 Fill from (172,30) in green
B $F286,3,3 Fill from (171,42) in green
B $F289,3,3 Fill from (170,49) in green
B $F28C,3,3 Fill from (168,57) in green
B $F28F,3,3 Move to (214,42)
B $F292,2,2 Line 10 pixels right, 1 up every 5, to (224,44)
B $F294,3,3 Fill from (222,46) in black
B $F297,3,3 Move to (29,41)
B $F29A,2,2 Line 18 pixels right, 1 up every 2, to (47,50)
B $F29C,2,2 Line 17 pixels right, 1 up every 3, to (64,55)
B $F29E,2,2 Line 11 pixels up, 1 right every 2, to (69,66)
B $F2A0,2,2 Line 10 pixels up, 1 right every 2, to (74,76)
B $F2A2,2,2 Line 7 pixels right, 1 up every 2, to (81,79)
B $F2A4,2,2 Line 9 pixels up, 1 right every 2, to (85,88)
B $F2A6,2,2 Line 9 pixels up, 1 right every 3, to (88,97)
B $F2A8,2,2 Line 7 pixels right, 1 down every 4, to (95,96)
B $F2AA,2,2 Line 4 pixels right, 1 up every 2, to (99,98)
B $F2AC,2,2 Line 3 pixels right, 1 down every 2, to (102,97)
B $F2AE,2,2 Line 7 pixels right, 1 up every 2, to (109,100)
B $F2B0,2,2 Line 6 pixels down, 1 right every 3, to (111,94)
B $F2B2,2,2 Line 7 pixels down, 1 right every 2, to (114,87)
B $F2B4,2,2 Line 7 pixels down, 1 left every 4, to (113,80)
B $F2B6,2,2 Line 6 pixels right, 1 up every 3, to (119,82)
B $F2B8,2,2 Line 10 pixels down, 1 right every 2, to (124,72)
B $F2BA,2,2 Line 4 pixels diagonally down-right, to (128,68)
B $F2BC,2,2 Line 4 pixels down, 1 right every 2, to (130,64)
B $F2BE,2,2 Line 4 pixels right, 1 down every 3, to (134,63)
B $F2C0,2,2 Line 11 pixels right, 1 down every 2, to (145,58)
B $F2C2,2,2 Line 11 pixels down, 1 right every 5, to (147,47)
B $F2C4,2,2 Line 9 pixels down, 1 right every 2, to (151,38)
B $F2C6,10,10 Paint cyan paper from cell (20,10): 2 up, 1 right, 3 down, 1 up, 1 right, 1 up
B $F2D0,3,3 Move to (73,37)
B $F2D3,2,2 Line 10 pixels up, 1 right every 3, to (76,47)
B $F2D5,2,2 Line 10 pixels up, 1 right every 2, to (81,57)
B $F2D7,2,2 Line 10 pixels diagonally up-right, to (91,67)
B $F2D9,2,2 Line 10 pixels up, 1 right every 5, to (93,77)
B $F2DB,2,2 Line 10 pixels up, 1 right every 9, to (94,87)
B $F2DD,2,2 Line 10 pixels up, 1 right every 9, to (95,97)
B $F2DF,3,3 Fill from (92,87) in black
B $F2E2,3,3 Move to (159,40)
B $F2E5,2,2 Line 24 pixels up, 1 right every 24, to (160,64)
B $F2E7,2,2 Line 16 pixels right, to (176,64)
B $F2E9,2,2 Line 16 pixels down, to (176,48)
B $F2EB,2,2 Line 8 pixels right, 1 down every 8, to (184,47)
B $F2ED,2,2 Line 8 pixels down, 1 right every 8, to (185,39)
B $F2EF,14,14 Paint cyan paper from cell (3,10): 1 right, 1 up, 2 right, 1 up, 2 right, 1 up, 1 right, 1 up, 1 right, 2 up
B $F2FD,3,3 Move to (23,41)
B $F300,2,2 Line 7 pixels up, 1 right every 7, to (24,48)
B $F302,2,2 Line 7 pixels right, to (31,48)
B $F304,2,2 Line 8 pixels up, 1 right every 8, to (32,56)
B $F306,2,2 Line 15 pixels right, to (47,56)
B $F308,2,2 Line 8 pixels up, 1 right every 8, to (48,64)
B $F30A,2,2 Line 15 pixels right, to (63,64)
B $F30C,2,2 Line 8 pixels up, 1 right every 8, to (64,72)
B $F30E,2,2 Line 7 pixels right, to (71,72)
B $F310,2,2 Line 8 pixels up, 1 right every 8, to (72,80)
B $F312,2,2 Line 7 pixels right, to (79,80)
B $F314,2,2 Line 8 pixels up, 1 right every 8, to (80,88)
B $F316,2,2 Line 7 pixels right, 1 up every 7, to (87,89)
B $F318,2,2 Line 8 pixels diagonally up-right, to (95,97)
B $F31A,21,8 Paint blue paper from cell (11,3): 3 right, 1 down, 3 left, 1 down, 4 right, 1 down, 5 left, 1 down, 7 right, 1 down, 8 left, 1 down, 9 right, 1 down, 9 left, 1 down, 3 right
B $F32F,3,3 Fill from (92,35) in green
B $F332,10,10 Paint cyan paper from cell (11,0): 2 down, 3 right, 2 up, 2 left, 1 down, 2 right
B $F33C,3,3 Move to (87,127)
B $F33F,2,2 Line 25 pixels down, to (87,102)
B $F341,3,3 Move to (87,103)
B $F344,2,2 Line 33 pixels right, 1 up every 33, to (120,104)
B $F346,2,2 Line 33 pixels up, 1 right every 24, to (121,127)
B $F348,3,3 Move to (90,110)
B $F34B,2,2 Line 3 pixels diagonally up-right, to (93,113)
B $F34D,2,2 Line 3 pixels right, 1 down every 3, to (96,112)
B $F34F,2,2 Line 2 pixels diagonally down-right, to (98,110)
B $F351,2,2 Line 2 pixels diagonally up-right, to (100,112)
B $F353,2,2 Line 3 pixels right, 1 up every 2, to (103,113)
B $F355,2,2 Line 3 pixels right, 1 down every 2, to (106,112)
B $F357,3,3 Fill from (121,122) in cyan
B $F35A,1,1 End of picture
u $F35B Unused
D $F35B Zeroes to the end of the code block at $F3FF.
i $F400
