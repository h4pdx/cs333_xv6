
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 70 e6 10 80       	mov    $0x8010e670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 39 10 80       	mov    $0x80103940,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 88 9f 10 80       	push   $0x80109f88
80100042:	68 80 e6 10 80       	push   $0x8010e680
80100047:	e8 07 68 00 00       	call   80106853 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 90 25 11 80 84 	movl   $0x80112584,0x80112590
80100056:	25 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 94 25 11 80 84 	movl   $0x80112584,0x80112594
80100060:	25 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 b4 e6 10 80 	movl   $0x8010e6b4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 94 25 11 80    	mov    0x80112594,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c 84 25 11 80 	movl   $0x80112584,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 94 25 11 80       	mov    0x80112594,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 94 25 11 80       	mov    %eax,0x80112594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 84 25 11 80       	mov    $0x80112584,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 80 e6 10 80       	push   $0x8010e680
801000c1:	e8 af 67 00 00       	call   80106875 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 94 25 11 80       	mov    0x80112594,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 80 e6 10 80       	push   $0x8010e680
8010010c:	e8 cb 67 00 00       	call   801068dc <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 e6 10 80       	push   $0x8010e680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 60 54 00 00       	call   8010558c <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 84 25 11 80 	cmpl   $0x80112584,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 90 25 11 80       	mov    0x80112590,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 80 e6 10 80       	push   $0x8010e680
80100188:	e8 4f 67 00 00       	call   801068dc <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 84 25 11 80 	cmpl   $0x80112584,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 8f 9f 10 80       	push   $0x80109f8f
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 d7 27 00 00       	call   801029be <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 a0 9f 10 80       	push   $0x80109fa0
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 96 27 00 00       	call   801029be <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 a7 9f 10 80       	push   $0x80109fa7
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 e6 10 80       	push   $0x8010e680
80100255:	e8 1b 66 00 00       	call   80106875 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 94 25 11 80    	mov    0x80112594,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c 84 25 11 80 	movl   $0x80112584,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 94 25 11 80       	mov    0x80112594,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 94 25 11 80       	mov    %eax,0x80112594

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 29 55 00 00       	call   801057e7 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 e6 10 80       	push   $0x8010e680
801002c9:	e8 0e 66 00 00       	call   801068dc <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 b0 10 80 	movzbl -0x7fef4ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 14 d6 10 80       	mov    0x8010d614,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 e0 d5 10 80       	push   $0x8010d5e0
801003e2:	e8 8e 64 00 00       	call   80106875 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 ae 9f 10 80       	push   $0x80109fae
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec b7 9f 10 80 	movl   $0x80109fb7,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 e0 d5 10 80       	push   $0x8010d5e0
8010055b:	e8 7c 63 00 00       	call   801068dc <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 14 d6 10 80 00 	movl   $0x0,0x8010d614
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 be 9f 10 80       	push   $0x80109fbe
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 cd 9f 10 80       	push   $0x80109fcd
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 67 63 00 00       	call   8010692e <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 cf 9f 10 80       	push   $0x80109fcf
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 c0 d5 10 80 01 	movl   $0x1,0x8010d5c0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 d3 9f 10 80       	push   $0x80109fd3
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 9b 64 00 00       	call   80106b97 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 b2 63 00 00       	call   80106ad8 <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 c0 d5 10 80       	mov    0x8010d5c0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 54 7e 00 00       	call   8010860f <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 47 7e 00 00       	call   8010860f <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 3a 7e 00 00       	call   8010860f <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 2a 7e 00 00       	call   8010860f <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
#ifdef CS333_P3P4
  int ctrlkey = 0; // 1-4, depending on what list to show
80100806:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
#endif

  acquire(&cons.lock);
8010080d:	83 ec 0c             	sub    $0xc,%esp
80100810:	68 e0 d5 10 80       	push   $0x8010d5e0
80100815:	e8 5b 60 00 00       	call   80106875 <acquire>
8010081a:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
8010081d:	e9 a6 01 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    switch(c){
80100822:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100825:	83 f8 12             	cmp    $0x12,%eax
80100828:	0f 84 d8 00 00 00    	je     80100906 <consoleintr+0x10d>
8010082e:	83 f8 12             	cmp    $0x12,%eax
80100831:	7f 1c                	jg     8010084f <consoleintr+0x56>
80100833:	83 f8 08             	cmp    $0x8,%eax
80100836:	0f 84 95 00 00 00    	je     801008d1 <consoleintr+0xd8>
8010083c:	83 f8 10             	cmp    $0x10,%eax
8010083f:	74 39                	je     8010087a <consoleintr+0x81>
80100841:	83 f8 06             	cmp    $0x6,%eax
80100844:	0f 84 c8 00 00 00    	je     80100912 <consoleintr+0x119>
8010084a:	e9 e7 00 00 00       	jmp    80100936 <consoleintr+0x13d>
8010084f:	83 f8 15             	cmp    $0x15,%eax
80100852:	74 4f                	je     801008a3 <consoleintr+0xaa>
80100854:	83 f8 15             	cmp    $0x15,%eax
80100857:	7f 0e                	jg     80100867 <consoleintr+0x6e>
80100859:	83 f8 13             	cmp    $0x13,%eax
8010085c:	0f 84 bc 00 00 00    	je     8010091e <consoleintr+0x125>
80100862:	e9 cf 00 00 00       	jmp    80100936 <consoleintr+0x13d>
80100867:	83 f8 1a             	cmp    $0x1a,%eax
8010086a:	0f 84 ba 00 00 00    	je     8010092a <consoleintr+0x131>
80100870:	83 f8 7f             	cmp    $0x7f,%eax
80100873:	74 5c                	je     801008d1 <consoleintr+0xd8>
80100875:	e9 bc 00 00 00       	jmp    80100936 <consoleintr+0x13d>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
8010087a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100881:	e9 42 01 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100886:	a1 28 28 11 80       	mov    0x80112828,%eax
8010088b:	83 e8 01             	sub    $0x1,%eax
8010088e:	a3 28 28 11 80       	mov    %eax,0x80112828
        consputc(BACKSPACE);
80100893:	83 ec 0c             	sub    $0xc,%esp
80100896:	68 00 01 00 00       	push   $0x100
8010089b:	e8 f2 fe ff ff       	call   80100792 <consputc>
801008a0:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008a3:	8b 15 28 28 11 80    	mov    0x80112828,%edx
801008a9:	a1 24 28 11 80       	mov    0x80112824,%eax
801008ae:	39 c2                	cmp    %eax,%edx
801008b0:	0f 84 12 01 00 00    	je     801009c8 <consoleintr+0x1cf>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008b6:	a1 28 28 11 80       	mov    0x80112828,%eax
801008bb:	83 e8 01             	sub    $0x1,%eax
801008be:	83 e0 7f             	and    $0x7f,%eax
801008c1:	0f b6 80 a0 27 11 80 	movzbl -0x7feed860(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c8:	3c 0a                	cmp    $0xa,%al
801008ca:	75 ba                	jne    80100886 <consoleintr+0x8d>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008cc:	e9 f7 00 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008d1:	8b 15 28 28 11 80    	mov    0x80112828,%edx
801008d7:	a1 24 28 11 80       	mov    0x80112824,%eax
801008dc:	39 c2                	cmp    %eax,%edx
801008de:	0f 84 e4 00 00 00    	je     801009c8 <consoleintr+0x1cf>
        input.e--;
801008e4:	a1 28 28 11 80       	mov    0x80112828,%eax
801008e9:	83 e8 01             	sub    $0x1,%eax
801008ec:	a3 28 28 11 80       	mov    %eax,0x80112828
        consputc(BACKSPACE);
801008f1:	83 ec 0c             	sub    $0xc,%esp
801008f4:	68 00 01 00 00       	push   $0x100
801008f9:	e8 94 fe ff ff       	call   80100792 <consputc>
801008fe:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100901:	e9 c2 00 00 00       	jmp    801009c8 <consoleintr+0x1cf>
#ifdef CS333_P3P4
    case C('R'):
      ctrlkey = 1;
80100906:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
8010090d:	e9 b6 00 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    case C('F'):
      ctrlkey = 2;
80100912:	c7 45 f0 02 00 00 00 	movl   $0x2,-0x10(%ebp)
      break;
80100919:	e9 aa 00 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    case C('S'):
      ctrlkey = 3;
8010091e:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
      break;
80100925:	e9 9e 00 00 00       	jmp    801009c8 <consoleintr+0x1cf>
    case C('Z'):
      ctrlkey = 4;
8010092a:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
      break;
80100931:	e9 92 00 00 00       	jmp    801009c8 <consoleintr+0x1cf>
#endif
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100936:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010093a:	0f 84 87 00 00 00    	je     801009c7 <consoleintr+0x1ce>
80100940:	8b 15 28 28 11 80    	mov    0x80112828,%edx
80100946:	a1 20 28 11 80       	mov    0x80112820,%eax
8010094b:	29 c2                	sub    %eax,%edx
8010094d:	89 d0                	mov    %edx,%eax
8010094f:	83 f8 7f             	cmp    $0x7f,%eax
80100952:	77 73                	ja     801009c7 <consoleintr+0x1ce>
        c = (c == '\r') ? '\n' : c;
80100954:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
80100958:	74 05                	je     8010095f <consoleintr+0x166>
8010095a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010095d:	eb 05                	jmp    80100964 <consoleintr+0x16b>
8010095f:	b8 0a 00 00 00       	mov    $0xa,%eax
80100964:	89 45 ec             	mov    %eax,-0x14(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
80100967:	a1 28 28 11 80       	mov    0x80112828,%eax
8010096c:	8d 50 01             	lea    0x1(%eax),%edx
8010096f:	89 15 28 28 11 80    	mov    %edx,0x80112828
80100975:	83 e0 7f             	and    $0x7f,%eax
80100978:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010097b:	88 90 a0 27 11 80    	mov    %dl,-0x7feed860(%eax)
        consputc(c);
80100981:	83 ec 0c             	sub    $0xc,%esp
80100984:	ff 75 ec             	pushl  -0x14(%ebp)
80100987:	e8 06 fe ff ff       	call   80100792 <consputc>
8010098c:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010098f:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
80100993:	74 18                	je     801009ad <consoleintr+0x1b4>
80100995:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
80100999:	74 12                	je     801009ad <consoleintr+0x1b4>
8010099b:	a1 28 28 11 80       	mov    0x80112828,%eax
801009a0:	8b 15 20 28 11 80    	mov    0x80112820,%edx
801009a6:	83 ea 80             	sub    $0xffffff80,%edx
801009a9:	39 d0                	cmp    %edx,%eax
801009ab:	75 1a                	jne    801009c7 <consoleintr+0x1ce>
          input.w = input.e;
801009ad:	a1 28 28 11 80       	mov    0x80112828,%eax
801009b2:	a3 24 28 11 80       	mov    %eax,0x80112824
          wakeup(&input.r);
801009b7:	83 ec 0c             	sub    $0xc,%esp
801009ba:	68 20 28 11 80       	push   $0x80112820
801009bf:	e8 23 4e 00 00       	call   801057e7 <wakeup>
801009c4:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009c7:	90                   	nop
#ifdef CS333_P3P4
  int ctrlkey = 0; // 1-4, depending on what list to show
#endif

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801009c8:	8b 45 08             	mov    0x8(%ebp),%eax
801009cb:	ff d0                	call   *%eax
801009cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
801009d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801009d4:	0f 89 48 fe ff ff    	jns    80100822 <consoleintr+0x29>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009da:	83 ec 0c             	sub    $0xc,%esp
801009dd:	68 e0 d5 10 80       	push   $0x8010d5e0
801009e2:	e8 f5 5e 00 00       	call   801068dc <release>
801009e7:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009ee:	74 05                	je     801009f5 <consoleintr+0x1fc>
    procdump();  // now call procdump() wo. cons.lock held
801009f0:	e8 82 51 00 00       	call   80105b77 <procdump>
  }
#ifdef CS333_P3P4
  // run Ready list display function
  if (ctrlkey == 1) {
801009f5:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
801009f9:	75 0c                	jne    80100a07 <consoleintr+0x20e>
      //cprintf("Ready list not implemented yet..\n");
      printReadyList();
801009fb:	e8 99 57 00 00       	call   80106199 <printReadyList>
      ctrlkey = 0;
80100a00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Free list display function
  if (ctrlkey == 2) {
80100a07:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
80100a0b:	75 0c                	jne    80100a19 <consoleintr+0x220>
      printFreeList();
80100a0d:	e8 80 58 00 00       	call   80106292 <printFreeList>
      ctrlkey = 0;
80100a12:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Sleep list display function
  if (ctrlkey == 3) {
80100a19:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
80100a1d:	75 0c                	jne    80100a2b <consoleintr+0x232>
     // cprintf("Sleep list not implemented yet..\n");
      printSleepList();
80100a1f:	e8 cc 58 00 00       	call   801062f0 <printSleepList>
      ctrlkey = 0;
80100a24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Zombie list display function
  if (ctrlkey == 4) {
80100a2b:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a2f:	75 0c                	jne    80100a3d <consoleintr+0x244>
      //cprintf("Zombie list not implemented yet..\n");
      printZombieList();
80100a31:	e8 57 59 00 00       	call   8010638d <printZombieList>
      ctrlkey = 0;
80100a36:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
#endif
}
80100a3d:	90                   	nop
80100a3e:	c9                   	leave  
80100a3f:	c3                   	ret    

80100a40 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a40:	55                   	push   %ebp
80100a41:	89 e5                	mov    %esp,%ebp
80100a43:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	ff 75 08             	pushl  0x8(%ebp)
80100a4c:	e8 28 11 00 00       	call   80101b79 <iunlock>
80100a51:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a54:	8b 45 10             	mov    0x10(%ebp),%eax
80100a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a5a:	83 ec 0c             	sub    $0xc,%esp
80100a5d:	68 e0 d5 10 80       	push   $0x8010d5e0
80100a62:	e8 0e 5e 00 00       	call   80106875 <acquire>
80100a67:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a6a:	e9 ac 00 00 00       	jmp    80100b1b <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
80100a6f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a75:	8b 40 24             	mov    0x24(%eax),%eax
80100a78:	85 c0                	test   %eax,%eax
80100a7a:	74 28                	je     80100aa4 <consoleread+0x64>
        release(&cons.lock);
80100a7c:	83 ec 0c             	sub    $0xc,%esp
80100a7f:	68 e0 d5 10 80       	push   $0x8010d5e0
80100a84:	e8 53 5e 00 00       	call   801068dc <release>
80100a89:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a8c:	83 ec 0c             	sub    $0xc,%esp
80100a8f:	ff 75 08             	pushl  0x8(%ebp)
80100a92:	e8 84 0f 00 00       	call   80101a1b <ilock>
80100a97:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a9f:	e9 ab 00 00 00       	jmp    80100b4f <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100aa4:	83 ec 08             	sub    $0x8,%esp
80100aa7:	68 e0 d5 10 80       	push   $0x8010d5e0
80100aac:	68 20 28 11 80       	push   $0x80112820
80100ab1:	e8 d6 4a 00 00       	call   8010558c <sleep>
80100ab6:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100ab9:	8b 15 20 28 11 80    	mov    0x80112820,%edx
80100abf:	a1 24 28 11 80       	mov    0x80112824,%eax
80100ac4:	39 c2                	cmp    %eax,%edx
80100ac6:	74 a7                	je     80100a6f <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100ac8:	a1 20 28 11 80       	mov    0x80112820,%eax
80100acd:	8d 50 01             	lea    0x1(%eax),%edx
80100ad0:	89 15 20 28 11 80    	mov    %edx,0x80112820
80100ad6:	83 e0 7f             	and    $0x7f,%eax
80100ad9:	0f b6 80 a0 27 11 80 	movzbl -0x7feed860(%eax),%eax
80100ae0:	0f be c0             	movsbl %al,%eax
80100ae3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100ae6:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100aea:	75 17                	jne    80100b03 <consoleread+0xc3>
      if(n < target){
80100aec:	8b 45 10             	mov    0x10(%ebp),%eax
80100aef:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100af2:	73 2f                	jae    80100b23 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100af4:	a1 20 28 11 80       	mov    0x80112820,%eax
80100af9:	83 e8 01             	sub    $0x1,%eax
80100afc:	a3 20 28 11 80       	mov    %eax,0x80112820
      }
      break;
80100b01:	eb 20                	jmp    80100b23 <consoleread+0xe3>
    }
    *dst++ = c;
80100b03:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b06:	8d 50 01             	lea    0x1(%eax),%edx
80100b09:	89 55 0c             	mov    %edx,0xc(%ebp)
80100b0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100b0f:	88 10                	mov    %dl,(%eax)
    --n;
80100b11:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100b15:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b19:	74 0b                	je     80100b26 <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100b1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b1f:	7f 98                	jg     80100ab9 <consoleread+0x79>
80100b21:	eb 04                	jmp    80100b27 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100b23:	90                   	nop
80100b24:	eb 01                	jmp    80100b27 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100b26:	90                   	nop
  }
  release(&cons.lock);
80100b27:	83 ec 0c             	sub    $0xc,%esp
80100b2a:	68 e0 d5 10 80       	push   $0x8010d5e0
80100b2f:	e8 a8 5d 00 00       	call   801068dc <release>
80100b34:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b37:	83 ec 0c             	sub    $0xc,%esp
80100b3a:	ff 75 08             	pushl  0x8(%ebp)
80100b3d:	e8 d9 0e 00 00       	call   80101a1b <ilock>
80100b42:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b45:	8b 45 10             	mov    0x10(%ebp),%eax
80100b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b4b:	29 c2                	sub    %eax,%edx
80100b4d:	89 d0                	mov    %edx,%eax
}
80100b4f:	c9                   	leave  
80100b50:	c3                   	ret    

80100b51 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b51:	55                   	push   %ebp
80100b52:	89 e5                	mov    %esp,%ebp
80100b54:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b57:	83 ec 0c             	sub    $0xc,%esp
80100b5a:	ff 75 08             	pushl  0x8(%ebp)
80100b5d:	e8 17 10 00 00       	call   80101b79 <iunlock>
80100b62:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b65:	83 ec 0c             	sub    $0xc,%esp
80100b68:	68 e0 d5 10 80       	push   $0x8010d5e0
80100b6d:	e8 03 5d 00 00       	call   80106875 <acquire>
80100b72:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b7c:	eb 21                	jmp    80100b9f <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b81:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b84:	01 d0                	add    %edx,%eax
80100b86:	0f b6 00             	movzbl (%eax),%eax
80100b89:	0f be c0             	movsbl %al,%eax
80100b8c:	0f b6 c0             	movzbl %al,%eax
80100b8f:	83 ec 0c             	sub    $0xc,%esp
80100b92:	50                   	push   %eax
80100b93:	e8 fa fb ff ff       	call   80100792 <consputc>
80100b98:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b9b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ba2:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ba5:	7c d7                	jl     80100b7e <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ba7:	83 ec 0c             	sub    $0xc,%esp
80100baa:	68 e0 d5 10 80       	push   $0x8010d5e0
80100baf:	e8 28 5d 00 00       	call   801068dc <release>
80100bb4:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bb7:	83 ec 0c             	sub    $0xc,%esp
80100bba:	ff 75 08             	pushl  0x8(%ebp)
80100bbd:	e8 59 0e 00 00       	call   80101a1b <ilock>
80100bc2:	83 c4 10             	add    $0x10,%esp

  return n;
80100bc5:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bc8:	c9                   	leave  
80100bc9:	c3                   	ret    

80100bca <consoleinit>:

void
consoleinit(void)
{
80100bca:	55                   	push   %ebp
80100bcb:	89 e5                	mov    %esp,%ebp
80100bcd:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100bd0:	83 ec 08             	sub    $0x8,%esp
80100bd3:	68 e6 9f 10 80       	push   $0x80109fe6
80100bd8:	68 e0 d5 10 80       	push   $0x8010d5e0
80100bdd:	e8 71 5c 00 00       	call   80106853 <initlock>
80100be2:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100be5:	c7 05 ec 31 11 80 51 	movl   $0x80100b51,0x801131ec
80100bec:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100bef:	c7 05 e8 31 11 80 40 	movl   $0x80100a40,0x801131e8
80100bf6:	0a 10 80 
  cons.locking = 1;
80100bf9:	c7 05 14 d6 10 80 01 	movl   $0x1,0x8010d614
80100c00:	00 00 00 

  picenable(IRQ_KBD);
80100c03:	83 ec 0c             	sub    $0xc,%esp
80100c06:	6a 01                	push   $0x1
80100c08:	e8 cf 33 00 00       	call   80103fdc <picenable>
80100c0d:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100c10:	83 ec 08             	sub    $0x8,%esp
80100c13:	6a 00                	push   $0x0
80100c15:	6a 01                	push   $0x1
80100c17:	e8 6f 1f 00 00       	call   80102b8b <ioapicenable>
80100c1c:	83 c4 10             	add    $0x10,%esp
}
80100c1f:	90                   	nop
80100c20:	c9                   	leave  
80100c21:	c3                   	ret    

80100c22 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100c22:	55                   	push   %ebp
80100c23:	89 e5                	mov    %esp,%ebp
80100c25:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100c2b:	e8 ce 29 00 00       	call   801035fe <begin_op>
  if((ip = namei(path)) == 0){
80100c30:	83 ec 0c             	sub    $0xc,%esp
80100c33:	ff 75 08             	pushl  0x8(%ebp)
80100c36:	e8 9e 19 00 00       	call   801025d9 <namei>
80100c3b:	83 c4 10             	add    $0x10,%esp
80100c3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c41:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c45:	75 0f                	jne    80100c56 <exec+0x34>
    end_op();
80100c47:	e8 3e 2a 00 00       	call   8010368a <end_op>
    return -1;
80100c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c51:	e9 ce 03 00 00       	jmp    80101024 <exec+0x402>
  }
  ilock(ip);
80100c56:	83 ec 0c             	sub    $0xc,%esp
80100c59:	ff 75 d8             	pushl  -0x28(%ebp)
80100c5c:	e8 ba 0d 00 00       	call   80101a1b <ilock>
80100c61:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c64:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100c6b:	6a 34                	push   $0x34
80100c6d:	6a 00                	push   $0x0
80100c6f:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100c75:	50                   	push   %eax
80100c76:	ff 75 d8             	pushl  -0x28(%ebp)
80100c79:	e8 0b 13 00 00       	call   80101f89 <readi>
80100c7e:	83 c4 10             	add    $0x10,%esp
80100c81:	83 f8 33             	cmp    $0x33,%eax
80100c84:	0f 86 49 03 00 00    	jbe    80100fd3 <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c8a:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c90:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c95:	0f 85 3b 03 00 00    	jne    80100fd6 <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c9b:	e8 c4 8a 00 00       	call   80109764 <setupkvm>
80100ca0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100ca3:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ca7:	0f 84 2c 03 00 00    	je     80100fd9 <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100cad:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cb4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100cbb:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100cc1:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cc4:	e9 ab 00 00 00       	jmp    80100d74 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100cc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100ccc:	6a 20                	push   $0x20
80100cce:	50                   	push   %eax
80100ccf:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100cd5:	50                   	push   %eax
80100cd6:	ff 75 d8             	pushl  -0x28(%ebp)
80100cd9:	e8 ab 12 00 00       	call   80101f89 <readi>
80100cde:	83 c4 10             	add    $0x10,%esp
80100ce1:	83 f8 20             	cmp    $0x20,%eax
80100ce4:	0f 85 f2 02 00 00    	jne    80100fdc <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100cea:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100cf0:	83 f8 01             	cmp    $0x1,%eax
80100cf3:	75 71                	jne    80100d66 <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100cf5:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100cfb:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d01:	39 c2                	cmp    %eax,%edx
80100d03:	0f 82 d6 02 00 00    	jb     80100fdf <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d09:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100d0f:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100d15:	01 d0                	add    %edx,%eax
80100d17:	83 ec 04             	sub    $0x4,%esp
80100d1a:	50                   	push   %eax
80100d1b:	ff 75 e0             	pushl  -0x20(%ebp)
80100d1e:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d21:	e8 e5 8d 00 00       	call   80109b0b <allocuvm>
80100d26:	83 c4 10             	add    $0x10,%esp
80100d29:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d2c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d30:	0f 84 ac 02 00 00    	je     80100fe2 <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100d36:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100d3c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100d42:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d48:	83 ec 0c             	sub    $0xc,%esp
80100d4b:	52                   	push   %edx
80100d4c:	50                   	push   %eax
80100d4d:	ff 75 d8             	pushl  -0x28(%ebp)
80100d50:	51                   	push   %ecx
80100d51:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d54:	e8 db 8c 00 00       	call   80109a34 <loaduvm>
80100d59:	83 c4 20             	add    $0x20,%esp
80100d5c:	85 c0                	test   %eax,%eax
80100d5e:	0f 88 81 02 00 00    	js     80100fe5 <exec+0x3c3>
80100d64:	eb 01                	jmp    80100d67 <exec+0x145>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100d66:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d67:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100d6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d6e:	83 c0 20             	add    $0x20,%eax
80100d71:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d74:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100d7b:	0f b7 c0             	movzwl %ax,%eax
80100d7e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100d81:	0f 8f 42 ff ff ff    	jg     80100cc9 <exec+0xa7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100d87:	83 ec 0c             	sub    $0xc,%esp
80100d8a:	ff 75 d8             	pushl  -0x28(%ebp)
80100d8d:	e8 49 0f 00 00       	call   80101cdb <iunlockput>
80100d92:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d95:	e8 f0 28 00 00       	call   8010368a <end_op>
  ip = 0;
80100d9a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100da1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100da4:	05 ff 0f 00 00       	add    $0xfff,%eax
80100da9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100dae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100db1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100db4:	05 00 20 00 00       	add    $0x2000,%eax
80100db9:	83 ec 04             	sub    $0x4,%esp
80100dbc:	50                   	push   %eax
80100dbd:	ff 75 e0             	pushl  -0x20(%ebp)
80100dc0:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dc3:	e8 43 8d 00 00       	call   80109b0b <allocuvm>
80100dc8:	83 c4 10             	add    $0x10,%esp
80100dcb:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100dce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100dd2:	0f 84 10 02 00 00    	je     80100fe8 <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100dd8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ddb:	2d 00 20 00 00       	sub    $0x2000,%eax
80100de0:	83 ec 08             	sub    $0x8,%esp
80100de3:	50                   	push   %eax
80100de4:	ff 75 d4             	pushl  -0x2c(%ebp)
80100de7:	e8 45 8f 00 00       	call   80109d31 <clearpteu>
80100dec:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100def:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100df2:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100df5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100dfc:	e9 96 00 00 00       	jmp    80100e97 <exec+0x275>
    if(argc >= MAXARG)
80100e01:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e05:	0f 87 e0 01 00 00    	ja     80100feb <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e0b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e15:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e18:	01 d0                	add    %edx,%eax
80100e1a:	8b 00                	mov    (%eax),%eax
80100e1c:	83 ec 0c             	sub    $0xc,%esp
80100e1f:	50                   	push   %eax
80100e20:	e8 00 5f 00 00       	call   80106d25 <strlen>
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	89 c2                	mov    %eax,%edx
80100e2a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e2d:	29 d0                	sub    %edx,%eax
80100e2f:	83 e8 01             	sub    $0x1,%eax
80100e32:	83 e0 fc             	and    $0xfffffffc,%eax
80100e35:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e3b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e45:	01 d0                	add    %edx,%eax
80100e47:	8b 00                	mov    (%eax),%eax
80100e49:	83 ec 0c             	sub    $0xc,%esp
80100e4c:	50                   	push   %eax
80100e4d:	e8 d3 5e 00 00       	call   80106d25 <strlen>
80100e52:	83 c4 10             	add    $0x10,%esp
80100e55:	83 c0 01             	add    $0x1,%eax
80100e58:	89 c1                	mov    %eax,%ecx
80100e5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e64:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e67:	01 d0                	add    %edx,%eax
80100e69:	8b 00                	mov    (%eax),%eax
80100e6b:	51                   	push   %ecx
80100e6c:	50                   	push   %eax
80100e6d:	ff 75 dc             	pushl  -0x24(%ebp)
80100e70:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e73:	e8 70 90 00 00       	call   80109ee8 <copyout>
80100e78:	83 c4 10             	add    $0x10,%esp
80100e7b:	85 c0                	test   %eax,%eax
80100e7d:	0f 88 6b 01 00 00    	js     80100fee <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100e83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e86:	8d 50 03             	lea    0x3(%eax),%edx
80100e89:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e8c:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e93:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e9a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ea4:	01 d0                	add    %edx,%eax
80100ea6:	8b 00                	mov    (%eax),%eax
80100ea8:	85 c0                	test   %eax,%eax
80100eaa:	0f 85 51 ff ff ff    	jne    80100e01 <exec+0x1df>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100eb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb3:	83 c0 03             	add    $0x3,%eax
80100eb6:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100ebd:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100ec1:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100ec8:	ff ff ff 
  ustack[1] = argc;
80100ecb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ece:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ed4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ed7:	83 c0 01             	add    $0x1,%eax
80100eda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100ee1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ee4:	29 d0                	sub    %edx,%eax
80100ee6:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100eec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eef:	83 c0 04             	add    $0x4,%eax
80100ef2:	c1 e0 02             	shl    $0x2,%eax
80100ef5:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100efb:	83 c0 04             	add    $0x4,%eax
80100efe:	c1 e0 02             	shl    $0x2,%eax
80100f01:	50                   	push   %eax
80100f02:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100f08:	50                   	push   %eax
80100f09:	ff 75 dc             	pushl  -0x24(%ebp)
80100f0c:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f0f:	e8 d4 8f 00 00       	call   80109ee8 <copyout>
80100f14:	83 c4 10             	add    $0x10,%esp
80100f17:	85 c0                	test   %eax,%eax
80100f19:	0f 88 d2 00 00 00    	js     80100ff1 <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80100f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f28:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100f2b:	eb 17                	jmp    80100f44 <exec+0x322>
    if(*s == '/')
80100f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f30:	0f b6 00             	movzbl (%eax),%eax
80100f33:	3c 2f                	cmp    $0x2f,%al
80100f35:	75 09                	jne    80100f40 <exec+0x31e>
      last = s+1;
80100f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f3a:	83 c0 01             	add    $0x1,%eax
80100f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f40:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f47:	0f b6 00             	movzbl (%eax),%eax
80100f4a:	84 c0                	test   %al,%al
80100f4c:	75 df                	jne    80100f2d <exec+0x30b>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100f4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f54:	83 c0 6c             	add    $0x6c,%eax
80100f57:	83 ec 04             	sub    $0x4,%esp
80100f5a:	6a 10                	push   $0x10
80100f5c:	ff 75 f0             	pushl  -0x10(%ebp)
80100f5f:	50                   	push   %eax
80100f60:	e8 76 5d 00 00       	call   80106cdb <safestrcpy>
80100f65:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100f68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f6e:	8b 40 04             	mov    0x4(%eax),%eax
80100f71:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100f74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f7a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100f7d:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100f80:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f86:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f89:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f91:	8b 40 18             	mov    0x18(%eax),%eax
80100f94:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f9a:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fa3:	8b 40 18             	mov    0x18(%eax),%eax
80100fa6:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100fa9:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100fac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fb2:	83 ec 0c             	sub    $0xc,%esp
80100fb5:	50                   	push   %eax
80100fb6:	e8 90 88 00 00       	call   8010984b <switchuvm>
80100fbb:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fbe:	83 ec 0c             	sub    $0xc,%esp
80100fc1:	ff 75 d0             	pushl  -0x30(%ebp)
80100fc4:	e8 c8 8c 00 00       	call   80109c91 <freevm>
80100fc9:	83 c4 10             	add    $0x10,%esp
  return 0;
80100fcc:	b8 00 00 00 00       	mov    $0x0,%eax
80100fd1:	eb 51                	jmp    80101024 <exec+0x402>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100fd3:	90                   	nop
80100fd4:	eb 1c                	jmp    80100ff2 <exec+0x3d0>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100fd6:	90                   	nop
80100fd7:	eb 19                	jmp    80100ff2 <exec+0x3d0>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80100fd9:	90                   	nop
80100fda:	eb 16                	jmp    80100ff2 <exec+0x3d0>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100fdc:	90                   	nop
80100fdd:	eb 13                	jmp    80100ff2 <exec+0x3d0>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100fdf:	90                   	nop
80100fe0:	eb 10                	jmp    80100ff2 <exec+0x3d0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100fe2:	90                   	nop
80100fe3:	eb 0d                	jmp    80100ff2 <exec+0x3d0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100fe5:	90                   	nop
80100fe6:	eb 0a                	jmp    80100ff2 <exec+0x3d0>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100fe8:	90                   	nop
80100fe9:	eb 07                	jmp    80100ff2 <exec+0x3d0>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100feb:	90                   	nop
80100fec:	eb 04                	jmp    80100ff2 <exec+0x3d0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100fee:	90                   	nop
80100fef:	eb 01                	jmp    80100ff2 <exec+0x3d0>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100ff1:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100ff2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100ff6:	74 0e                	je     80101006 <exec+0x3e4>
    freevm(pgdir);
80100ff8:	83 ec 0c             	sub    $0xc,%esp
80100ffb:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ffe:	e8 8e 8c 00 00       	call   80109c91 <freevm>
80101003:	83 c4 10             	add    $0x10,%esp
  if(ip){
80101006:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
8010100a:	74 13                	je     8010101f <exec+0x3fd>
    iunlockput(ip);
8010100c:	83 ec 0c             	sub    $0xc,%esp
8010100f:	ff 75 d8             	pushl  -0x28(%ebp)
80101012:	e8 c4 0c 00 00       	call   80101cdb <iunlockput>
80101017:	83 c4 10             	add    $0x10,%esp
    end_op();
8010101a:	e8 6b 26 00 00       	call   8010368a <end_op>
  }
  return -1;
8010101f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101024:	c9                   	leave  
80101025:	c3                   	ret    

80101026 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101026:	55                   	push   %ebp
80101027:	89 e5                	mov    %esp,%ebp
80101029:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
8010102c:	83 ec 08             	sub    $0x8,%esp
8010102f:	68 ee 9f 10 80       	push   $0x80109fee
80101034:	68 40 28 11 80       	push   $0x80112840
80101039:	e8 15 58 00 00       	call   80106853 <initlock>
8010103e:	83 c4 10             	add    $0x10,%esp
}
80101041:	90                   	nop
80101042:	c9                   	leave  
80101043:	c3                   	ret    

80101044 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101044:	55                   	push   %ebp
80101045:	89 e5                	mov    %esp,%ebp
80101047:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
8010104a:	83 ec 0c             	sub    $0xc,%esp
8010104d:	68 40 28 11 80       	push   $0x80112840
80101052:	e8 1e 58 00 00       	call   80106875 <acquire>
80101057:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010105a:	c7 45 f4 74 28 11 80 	movl   $0x80112874,-0xc(%ebp)
80101061:	eb 2d                	jmp    80101090 <filealloc+0x4c>
    if(f->ref == 0){
80101063:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101066:	8b 40 04             	mov    0x4(%eax),%eax
80101069:	85 c0                	test   %eax,%eax
8010106b:	75 1f                	jne    8010108c <filealloc+0x48>
      f->ref = 1;
8010106d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101070:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 40 28 11 80       	push   $0x80112840
8010107f:	e8 58 58 00 00       	call   801068dc <release>
80101084:	83 c4 10             	add    $0x10,%esp
      return f;
80101087:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010108a:	eb 23                	jmp    801010af <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010108c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101090:	b8 d4 31 11 80       	mov    $0x801131d4,%eax
80101095:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101098:	72 c9                	jb     80101063 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010109a:	83 ec 0c             	sub    $0xc,%esp
8010109d:	68 40 28 11 80       	push   $0x80112840
801010a2:	e8 35 58 00 00       	call   801068dc <release>
801010a7:	83 c4 10             	add    $0x10,%esp
  return 0;
801010aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801010af:	c9                   	leave  
801010b0:	c3                   	ret    

801010b1 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801010b1:	55                   	push   %ebp
801010b2:	89 e5                	mov    %esp,%ebp
801010b4:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
801010b7:	83 ec 0c             	sub    $0xc,%esp
801010ba:	68 40 28 11 80       	push   $0x80112840
801010bf:	e8 b1 57 00 00       	call   80106875 <acquire>
801010c4:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010c7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ca:	8b 40 04             	mov    0x4(%eax),%eax
801010cd:	85 c0                	test   %eax,%eax
801010cf:	7f 0d                	jg     801010de <filedup+0x2d>
    panic("filedup");
801010d1:	83 ec 0c             	sub    $0xc,%esp
801010d4:	68 f5 9f 10 80       	push   $0x80109ff5
801010d9:	e8 88 f4 ff ff       	call   80100566 <panic>
  f->ref++;
801010de:	8b 45 08             	mov    0x8(%ebp),%eax
801010e1:	8b 40 04             	mov    0x4(%eax),%eax
801010e4:	8d 50 01             	lea    0x1(%eax),%edx
801010e7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ea:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801010ed:	83 ec 0c             	sub    $0xc,%esp
801010f0:	68 40 28 11 80       	push   $0x80112840
801010f5:	e8 e2 57 00 00       	call   801068dc <release>
801010fa:	83 c4 10             	add    $0x10,%esp
  return f;
801010fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101100:	c9                   	leave  
80101101:	c3                   	ret    

80101102 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101102:	55                   	push   %ebp
80101103:	89 e5                	mov    %esp,%ebp
80101105:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101108:	83 ec 0c             	sub    $0xc,%esp
8010110b:	68 40 28 11 80       	push   $0x80112840
80101110:	e8 60 57 00 00       	call   80106875 <acquire>
80101115:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101118:	8b 45 08             	mov    0x8(%ebp),%eax
8010111b:	8b 40 04             	mov    0x4(%eax),%eax
8010111e:	85 c0                	test   %eax,%eax
80101120:	7f 0d                	jg     8010112f <fileclose+0x2d>
    panic("fileclose");
80101122:	83 ec 0c             	sub    $0xc,%esp
80101125:	68 fd 9f 10 80       	push   $0x80109ffd
8010112a:	e8 37 f4 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
8010112f:	8b 45 08             	mov    0x8(%ebp),%eax
80101132:	8b 40 04             	mov    0x4(%eax),%eax
80101135:	8d 50 ff             	lea    -0x1(%eax),%edx
80101138:	8b 45 08             	mov    0x8(%ebp),%eax
8010113b:	89 50 04             	mov    %edx,0x4(%eax)
8010113e:	8b 45 08             	mov    0x8(%ebp),%eax
80101141:	8b 40 04             	mov    0x4(%eax),%eax
80101144:	85 c0                	test   %eax,%eax
80101146:	7e 15                	jle    8010115d <fileclose+0x5b>
    release(&ftable.lock);
80101148:	83 ec 0c             	sub    $0xc,%esp
8010114b:	68 40 28 11 80       	push   $0x80112840
80101150:	e8 87 57 00 00       	call   801068dc <release>
80101155:	83 c4 10             	add    $0x10,%esp
80101158:	e9 8b 00 00 00       	jmp    801011e8 <fileclose+0xe6>
    return;
  }
  ff = *f;
8010115d:	8b 45 08             	mov    0x8(%ebp),%eax
80101160:	8b 10                	mov    (%eax),%edx
80101162:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101165:	8b 50 04             	mov    0x4(%eax),%edx
80101168:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010116b:	8b 50 08             	mov    0x8(%eax),%edx
8010116e:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101171:	8b 50 0c             	mov    0xc(%eax),%edx
80101174:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101177:	8b 50 10             	mov    0x10(%eax),%edx
8010117a:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010117d:	8b 40 14             	mov    0x14(%eax),%eax
80101180:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101183:	8b 45 08             	mov    0x8(%ebp),%eax
80101186:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010118d:	8b 45 08             	mov    0x8(%ebp),%eax
80101190:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 40 28 11 80       	push   $0x80112840
8010119e:	e8 39 57 00 00       	call   801068dc <release>
801011a3:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
801011a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011a9:	83 f8 01             	cmp    $0x1,%eax
801011ac:	75 19                	jne    801011c7 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
801011ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801011b2:	0f be d0             	movsbl %al,%edx
801011b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801011b8:	83 ec 08             	sub    $0x8,%esp
801011bb:	52                   	push   %edx
801011bc:	50                   	push   %eax
801011bd:	e8 83 30 00 00       	call   80104245 <pipeclose>
801011c2:	83 c4 10             	add    $0x10,%esp
801011c5:	eb 21                	jmp    801011e8 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801011c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011ca:	83 f8 02             	cmp    $0x2,%eax
801011cd:	75 19                	jne    801011e8 <fileclose+0xe6>
    begin_op();
801011cf:	e8 2a 24 00 00       	call   801035fe <begin_op>
    iput(ff.ip);
801011d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801011d7:	83 ec 0c             	sub    $0xc,%esp
801011da:	50                   	push   %eax
801011db:	e8 0b 0a 00 00       	call   80101beb <iput>
801011e0:	83 c4 10             	add    $0x10,%esp
    end_op();
801011e3:	e8 a2 24 00 00       	call   8010368a <end_op>
  }
}
801011e8:	c9                   	leave  
801011e9:	c3                   	ret    

801011ea <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801011ea:	55                   	push   %ebp
801011eb:	89 e5                	mov    %esp,%ebp
801011ed:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801011f0:	8b 45 08             	mov    0x8(%ebp),%eax
801011f3:	8b 00                	mov    (%eax),%eax
801011f5:	83 f8 02             	cmp    $0x2,%eax
801011f8:	75 40                	jne    8010123a <filestat+0x50>
    ilock(f->ip);
801011fa:	8b 45 08             	mov    0x8(%ebp),%eax
801011fd:	8b 40 10             	mov    0x10(%eax),%eax
80101200:	83 ec 0c             	sub    $0xc,%esp
80101203:	50                   	push   %eax
80101204:	e8 12 08 00 00       	call   80101a1b <ilock>
80101209:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
8010120c:	8b 45 08             	mov    0x8(%ebp),%eax
8010120f:	8b 40 10             	mov    0x10(%eax),%eax
80101212:	83 ec 08             	sub    $0x8,%esp
80101215:	ff 75 0c             	pushl  0xc(%ebp)
80101218:	50                   	push   %eax
80101219:	e8 25 0d 00 00       	call   80101f43 <stati>
8010121e:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101221:	8b 45 08             	mov    0x8(%ebp),%eax
80101224:	8b 40 10             	mov    0x10(%eax),%eax
80101227:	83 ec 0c             	sub    $0xc,%esp
8010122a:	50                   	push   %eax
8010122b:	e8 49 09 00 00       	call   80101b79 <iunlock>
80101230:	83 c4 10             	add    $0x10,%esp
    return 0;
80101233:	b8 00 00 00 00       	mov    $0x0,%eax
80101238:	eb 05                	jmp    8010123f <filestat+0x55>
  }
  return -1;
8010123a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010123f:	c9                   	leave  
80101240:	c3                   	ret    

80101241 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101241:	55                   	push   %ebp
80101242:	89 e5                	mov    %esp,%ebp
80101244:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101247:	8b 45 08             	mov    0x8(%ebp),%eax
8010124a:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010124e:	84 c0                	test   %al,%al
80101250:	75 0a                	jne    8010125c <fileread+0x1b>
    return -1;
80101252:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101257:	e9 9b 00 00 00       	jmp    801012f7 <fileread+0xb6>
  if(f->type == FD_PIPE)
8010125c:	8b 45 08             	mov    0x8(%ebp),%eax
8010125f:	8b 00                	mov    (%eax),%eax
80101261:	83 f8 01             	cmp    $0x1,%eax
80101264:	75 1a                	jne    80101280 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101266:	8b 45 08             	mov    0x8(%ebp),%eax
80101269:	8b 40 0c             	mov    0xc(%eax),%eax
8010126c:	83 ec 04             	sub    $0x4,%esp
8010126f:	ff 75 10             	pushl  0x10(%ebp)
80101272:	ff 75 0c             	pushl  0xc(%ebp)
80101275:	50                   	push   %eax
80101276:	e8 72 31 00 00       	call   801043ed <piperead>
8010127b:	83 c4 10             	add    $0x10,%esp
8010127e:	eb 77                	jmp    801012f7 <fileread+0xb6>
  if(f->type == FD_INODE){
80101280:	8b 45 08             	mov    0x8(%ebp),%eax
80101283:	8b 00                	mov    (%eax),%eax
80101285:	83 f8 02             	cmp    $0x2,%eax
80101288:	75 60                	jne    801012ea <fileread+0xa9>
    ilock(f->ip);
8010128a:	8b 45 08             	mov    0x8(%ebp),%eax
8010128d:	8b 40 10             	mov    0x10(%eax),%eax
80101290:	83 ec 0c             	sub    $0xc,%esp
80101293:	50                   	push   %eax
80101294:	e8 82 07 00 00       	call   80101a1b <ilock>
80101299:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010129c:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010129f:	8b 45 08             	mov    0x8(%ebp),%eax
801012a2:	8b 50 14             	mov    0x14(%eax),%edx
801012a5:	8b 45 08             	mov    0x8(%ebp),%eax
801012a8:	8b 40 10             	mov    0x10(%eax),%eax
801012ab:	51                   	push   %ecx
801012ac:	52                   	push   %edx
801012ad:	ff 75 0c             	pushl  0xc(%ebp)
801012b0:	50                   	push   %eax
801012b1:	e8 d3 0c 00 00       	call   80101f89 <readi>
801012b6:	83 c4 10             	add    $0x10,%esp
801012b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801012bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801012c0:	7e 11                	jle    801012d3 <fileread+0x92>
      f->off += r;
801012c2:	8b 45 08             	mov    0x8(%ebp),%eax
801012c5:	8b 50 14             	mov    0x14(%eax),%edx
801012c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012cb:	01 c2                	add    %eax,%edx
801012cd:	8b 45 08             	mov    0x8(%ebp),%eax
801012d0:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801012d3:	8b 45 08             	mov    0x8(%ebp),%eax
801012d6:	8b 40 10             	mov    0x10(%eax),%eax
801012d9:	83 ec 0c             	sub    $0xc,%esp
801012dc:	50                   	push   %eax
801012dd:	e8 97 08 00 00       	call   80101b79 <iunlock>
801012e2:	83 c4 10             	add    $0x10,%esp
    return r;
801012e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012e8:	eb 0d                	jmp    801012f7 <fileread+0xb6>
  }
  panic("fileread");
801012ea:	83 ec 0c             	sub    $0xc,%esp
801012ed:	68 07 a0 10 80       	push   $0x8010a007
801012f2:	e8 6f f2 ff ff       	call   80100566 <panic>
}
801012f7:	c9                   	leave  
801012f8:	c3                   	ret    

801012f9 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801012f9:	55                   	push   %ebp
801012fa:	89 e5                	mov    %esp,%ebp
801012fc:	53                   	push   %ebx
801012fd:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
80101300:	8b 45 08             	mov    0x8(%ebp),%eax
80101303:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101307:	84 c0                	test   %al,%al
80101309:	75 0a                	jne    80101315 <filewrite+0x1c>
    return -1;
8010130b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101310:	e9 1b 01 00 00       	jmp    80101430 <filewrite+0x137>
  if(f->type == FD_PIPE)
80101315:	8b 45 08             	mov    0x8(%ebp),%eax
80101318:	8b 00                	mov    (%eax),%eax
8010131a:	83 f8 01             	cmp    $0x1,%eax
8010131d:	75 1d                	jne    8010133c <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010131f:	8b 45 08             	mov    0x8(%ebp),%eax
80101322:	8b 40 0c             	mov    0xc(%eax),%eax
80101325:	83 ec 04             	sub    $0x4,%esp
80101328:	ff 75 10             	pushl  0x10(%ebp)
8010132b:	ff 75 0c             	pushl  0xc(%ebp)
8010132e:	50                   	push   %eax
8010132f:	e8 bb 2f 00 00       	call   801042ef <pipewrite>
80101334:	83 c4 10             	add    $0x10,%esp
80101337:	e9 f4 00 00 00       	jmp    80101430 <filewrite+0x137>
  if(f->type == FD_INODE){
8010133c:	8b 45 08             	mov    0x8(%ebp),%eax
8010133f:	8b 00                	mov    (%eax),%eax
80101341:	83 f8 02             	cmp    $0x2,%eax
80101344:	0f 85 d9 00 00 00    	jne    80101423 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010134a:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101358:	e9 a3 00 00 00       	jmp    80101400 <filewrite+0x107>
      int n1 = n - i;
8010135d:	8b 45 10             	mov    0x10(%ebp),%eax
80101360:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101363:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101366:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101369:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010136c:	7e 06                	jle    80101374 <filewrite+0x7b>
        n1 = max;
8010136e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101371:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101374:	e8 85 22 00 00       	call   801035fe <begin_op>
      ilock(f->ip);
80101379:	8b 45 08             	mov    0x8(%ebp),%eax
8010137c:	8b 40 10             	mov    0x10(%eax),%eax
8010137f:	83 ec 0c             	sub    $0xc,%esp
80101382:	50                   	push   %eax
80101383:	e8 93 06 00 00       	call   80101a1b <ilock>
80101388:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010138b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010138e:	8b 45 08             	mov    0x8(%ebp),%eax
80101391:	8b 50 14             	mov    0x14(%eax),%edx
80101394:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101397:	8b 45 0c             	mov    0xc(%ebp),%eax
8010139a:	01 c3                	add    %eax,%ebx
8010139c:	8b 45 08             	mov    0x8(%ebp),%eax
8010139f:	8b 40 10             	mov    0x10(%eax),%eax
801013a2:	51                   	push   %ecx
801013a3:	52                   	push   %edx
801013a4:	53                   	push   %ebx
801013a5:	50                   	push   %eax
801013a6:	e8 35 0d 00 00       	call   801020e0 <writei>
801013ab:	83 c4 10             	add    $0x10,%esp
801013ae:	89 45 e8             	mov    %eax,-0x18(%ebp)
801013b1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013b5:	7e 11                	jle    801013c8 <filewrite+0xcf>
        f->off += r;
801013b7:	8b 45 08             	mov    0x8(%ebp),%eax
801013ba:	8b 50 14             	mov    0x14(%eax),%edx
801013bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013c0:	01 c2                	add    %eax,%edx
801013c2:	8b 45 08             	mov    0x8(%ebp),%eax
801013c5:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801013c8:	8b 45 08             	mov    0x8(%ebp),%eax
801013cb:	8b 40 10             	mov    0x10(%eax),%eax
801013ce:	83 ec 0c             	sub    $0xc,%esp
801013d1:	50                   	push   %eax
801013d2:	e8 a2 07 00 00       	call   80101b79 <iunlock>
801013d7:	83 c4 10             	add    $0x10,%esp
      end_op();
801013da:	e8 ab 22 00 00       	call   8010368a <end_op>

      if(r < 0)
801013df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801013e3:	78 29                	js     8010140e <filewrite+0x115>
        break;
      if(r != n1)
801013e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801013eb:	74 0d                	je     801013fa <filewrite+0x101>
        panic("short filewrite");
801013ed:	83 ec 0c             	sub    $0xc,%esp
801013f0:	68 10 a0 10 80       	push   $0x8010a010
801013f5:	e8 6c f1 ff ff       	call   80100566 <panic>
      i += r;
801013fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801013fd:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101400:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101403:	3b 45 10             	cmp    0x10(%ebp),%eax
80101406:	0f 8c 51 ff ff ff    	jl     8010135d <filewrite+0x64>
8010140c:	eb 01                	jmp    8010140f <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
8010140e:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010140f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101412:	3b 45 10             	cmp    0x10(%ebp),%eax
80101415:	75 05                	jne    8010141c <filewrite+0x123>
80101417:	8b 45 10             	mov    0x10(%ebp),%eax
8010141a:	eb 14                	jmp    80101430 <filewrite+0x137>
8010141c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101421:	eb 0d                	jmp    80101430 <filewrite+0x137>
  }
  panic("filewrite");
80101423:	83 ec 0c             	sub    $0xc,%esp
80101426:	68 20 a0 10 80       	push   $0x8010a020
8010142b:	e8 36 f1 ff ff       	call   80100566 <panic>
}
80101430:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101433:	c9                   	leave  
80101434:	c3                   	ret    

80101435 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101435:	55                   	push   %ebp
80101436:	89 e5                	mov    %esp,%ebp
80101438:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010143b:	8b 45 08             	mov    0x8(%ebp),%eax
8010143e:	83 ec 08             	sub    $0x8,%esp
80101441:	6a 01                	push   $0x1
80101443:	50                   	push   %eax
80101444:	e8 6d ed ff ff       	call   801001b6 <bread>
80101449:	83 c4 10             	add    $0x10,%esp
8010144c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010144f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101452:	83 c0 18             	add    $0x18,%eax
80101455:	83 ec 04             	sub    $0x4,%esp
80101458:	6a 1c                	push   $0x1c
8010145a:	50                   	push   %eax
8010145b:	ff 75 0c             	pushl  0xc(%ebp)
8010145e:	e8 34 57 00 00       	call   80106b97 <memmove>
80101463:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101466:	83 ec 0c             	sub    $0xc,%esp
80101469:	ff 75 f4             	pushl  -0xc(%ebp)
8010146c:	e8 bd ed ff ff       	call   8010022e <brelse>
80101471:	83 c4 10             	add    $0x10,%esp
}
80101474:	90                   	nop
80101475:	c9                   	leave  
80101476:	c3                   	ret    

80101477 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101477:	55                   	push   %ebp
80101478:	89 e5                	mov    %esp,%ebp
8010147a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010147d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101480:	8b 45 08             	mov    0x8(%ebp),%eax
80101483:	83 ec 08             	sub    $0x8,%esp
80101486:	52                   	push   %edx
80101487:	50                   	push   %eax
80101488:	e8 29 ed ff ff       	call   801001b6 <bread>
8010148d:	83 c4 10             	add    $0x10,%esp
80101490:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101496:	83 c0 18             	add    $0x18,%eax
80101499:	83 ec 04             	sub    $0x4,%esp
8010149c:	68 00 02 00 00       	push   $0x200
801014a1:	6a 00                	push   $0x0
801014a3:	50                   	push   %eax
801014a4:	e8 2f 56 00 00       	call   80106ad8 <memset>
801014a9:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801014ac:	83 ec 0c             	sub    $0xc,%esp
801014af:	ff 75 f4             	pushl  -0xc(%ebp)
801014b2:	e8 7f 23 00 00       	call   80103836 <log_write>
801014b7:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801014ba:	83 ec 0c             	sub    $0xc,%esp
801014bd:	ff 75 f4             	pushl  -0xc(%ebp)
801014c0:	e8 69 ed ff ff       	call   8010022e <brelse>
801014c5:	83 c4 10             	add    $0x10,%esp
}
801014c8:	90                   	nop
801014c9:	c9                   	leave  
801014ca:	c3                   	ret    

801014cb <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801014cb:	55                   	push   %ebp
801014cc:	89 e5                	mov    %esp,%ebp
801014ce:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801014d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801014d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801014df:	e9 13 01 00 00       	jmp    801015f7 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801014e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014e7:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801014ed:	85 c0                	test   %eax,%eax
801014ef:	0f 48 c2             	cmovs  %edx,%eax
801014f2:	c1 f8 0c             	sar    $0xc,%eax
801014f5:	89 c2                	mov    %eax,%edx
801014f7:	a1 58 32 11 80       	mov    0x80113258,%eax
801014fc:	01 d0                	add    %edx,%eax
801014fe:	83 ec 08             	sub    $0x8,%esp
80101501:	50                   	push   %eax
80101502:	ff 75 08             	pushl  0x8(%ebp)
80101505:	e8 ac ec ff ff       	call   801001b6 <bread>
8010150a:	83 c4 10             	add    $0x10,%esp
8010150d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101510:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101517:	e9 a6 00 00 00       	jmp    801015c2 <balloc+0xf7>
      m = 1 << (bi % 8);
8010151c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010151f:	99                   	cltd   
80101520:	c1 ea 1d             	shr    $0x1d,%edx
80101523:	01 d0                	add    %edx,%eax
80101525:	83 e0 07             	and    $0x7,%eax
80101528:	29 d0                	sub    %edx,%eax
8010152a:	ba 01 00 00 00       	mov    $0x1,%edx
8010152f:	89 c1                	mov    %eax,%ecx
80101531:	d3 e2                	shl    %cl,%edx
80101533:	89 d0                	mov    %edx,%eax
80101535:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101538:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010153b:	8d 50 07             	lea    0x7(%eax),%edx
8010153e:	85 c0                	test   %eax,%eax
80101540:	0f 48 c2             	cmovs  %edx,%eax
80101543:	c1 f8 03             	sar    $0x3,%eax
80101546:	89 c2                	mov    %eax,%edx
80101548:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010154b:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101550:	0f b6 c0             	movzbl %al,%eax
80101553:	23 45 e8             	and    -0x18(%ebp),%eax
80101556:	85 c0                	test   %eax,%eax
80101558:	75 64                	jne    801015be <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
8010155a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010155d:	8d 50 07             	lea    0x7(%eax),%edx
80101560:	85 c0                	test   %eax,%eax
80101562:	0f 48 c2             	cmovs  %edx,%eax
80101565:	c1 f8 03             	sar    $0x3,%eax
80101568:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010156b:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101570:	89 d1                	mov    %edx,%ecx
80101572:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101575:	09 ca                	or     %ecx,%edx
80101577:	89 d1                	mov    %edx,%ecx
80101579:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010157c:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101580:	83 ec 0c             	sub    $0xc,%esp
80101583:	ff 75 ec             	pushl  -0x14(%ebp)
80101586:	e8 ab 22 00 00       	call   80103836 <log_write>
8010158b:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010158e:	83 ec 0c             	sub    $0xc,%esp
80101591:	ff 75 ec             	pushl  -0x14(%ebp)
80101594:	e8 95 ec ff ff       	call   8010022e <brelse>
80101599:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010159c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010159f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a2:	01 c2                	add    %eax,%edx
801015a4:	8b 45 08             	mov    0x8(%ebp),%eax
801015a7:	83 ec 08             	sub    $0x8,%esp
801015aa:	52                   	push   %edx
801015ab:	50                   	push   %eax
801015ac:	e8 c6 fe ff ff       	call   80101477 <bzero>
801015b1:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801015b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015ba:	01 d0                	add    %edx,%eax
801015bc:	eb 57                	jmp    80101615 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015be:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801015c2:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801015c9:	7f 17                	jg     801015e2 <balloc+0x117>
801015cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015d1:	01 d0                	add    %edx,%eax
801015d3:	89 c2                	mov    %eax,%edx
801015d5:	a1 40 32 11 80       	mov    0x80113240,%eax
801015da:	39 c2                	cmp    %eax,%edx
801015dc:	0f 82 3a ff ff ff    	jb     8010151c <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801015e2:	83 ec 0c             	sub    $0xc,%esp
801015e5:	ff 75 ec             	pushl  -0x14(%ebp)
801015e8:	e8 41 ec ff ff       	call   8010022e <brelse>
801015ed:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801015f0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801015f7:	8b 15 40 32 11 80    	mov    0x80113240,%edx
801015fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101600:	39 c2                	cmp    %eax,%edx
80101602:	0f 87 dc fe ff ff    	ja     801014e4 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101608:	83 ec 0c             	sub    $0xc,%esp
8010160b:	68 2c a0 10 80       	push   $0x8010a02c
80101610:	e8 51 ef ff ff       	call   80100566 <panic>
}
80101615:	c9                   	leave  
80101616:	c3                   	ret    

80101617 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101617:	55                   	push   %ebp
80101618:	89 e5                	mov    %esp,%ebp
8010161a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010161d:	83 ec 08             	sub    $0x8,%esp
80101620:	68 40 32 11 80       	push   $0x80113240
80101625:	ff 75 08             	pushl  0x8(%ebp)
80101628:	e8 08 fe ff ff       	call   80101435 <readsb>
8010162d:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101630:	8b 45 0c             	mov    0xc(%ebp),%eax
80101633:	c1 e8 0c             	shr    $0xc,%eax
80101636:	89 c2                	mov    %eax,%edx
80101638:	a1 58 32 11 80       	mov    0x80113258,%eax
8010163d:	01 c2                	add    %eax,%edx
8010163f:	8b 45 08             	mov    0x8(%ebp),%eax
80101642:	83 ec 08             	sub    $0x8,%esp
80101645:	52                   	push   %edx
80101646:	50                   	push   %eax
80101647:	e8 6a eb ff ff       	call   801001b6 <bread>
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101652:	8b 45 0c             	mov    0xc(%ebp),%eax
80101655:	25 ff 0f 00 00       	and    $0xfff,%eax
8010165a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010165d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101660:	99                   	cltd   
80101661:	c1 ea 1d             	shr    $0x1d,%edx
80101664:	01 d0                	add    %edx,%eax
80101666:	83 e0 07             	and    $0x7,%eax
80101669:	29 d0                	sub    %edx,%eax
8010166b:	ba 01 00 00 00       	mov    $0x1,%edx
80101670:	89 c1                	mov    %eax,%ecx
80101672:	d3 e2                	shl    %cl,%edx
80101674:	89 d0                	mov    %edx,%eax
80101676:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101679:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010167c:	8d 50 07             	lea    0x7(%eax),%edx
8010167f:	85 c0                	test   %eax,%eax
80101681:	0f 48 c2             	cmovs  %edx,%eax
80101684:	c1 f8 03             	sar    $0x3,%eax
80101687:	89 c2                	mov    %eax,%edx
80101689:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010168c:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101691:	0f b6 c0             	movzbl %al,%eax
80101694:	23 45 ec             	and    -0x14(%ebp),%eax
80101697:	85 c0                	test   %eax,%eax
80101699:	75 0d                	jne    801016a8 <bfree+0x91>
    panic("freeing free block");
8010169b:	83 ec 0c             	sub    $0xc,%esp
8010169e:	68 42 a0 10 80       	push   $0x8010a042
801016a3:	e8 be ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
801016a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016ab:	8d 50 07             	lea    0x7(%eax),%edx
801016ae:	85 c0                	test   %eax,%eax
801016b0:	0f 48 c2             	cmovs  %edx,%eax
801016b3:	c1 f8 03             	sar    $0x3,%eax
801016b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016b9:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801016be:	89 d1                	mov    %edx,%ecx
801016c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801016c3:	f7 d2                	not    %edx
801016c5:	21 ca                	and    %ecx,%edx
801016c7:	89 d1                	mov    %edx,%ecx
801016c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016cc:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801016d0:	83 ec 0c             	sub    $0xc,%esp
801016d3:	ff 75 f4             	pushl  -0xc(%ebp)
801016d6:	e8 5b 21 00 00       	call   80103836 <log_write>
801016db:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801016de:	83 ec 0c             	sub    $0xc,%esp
801016e1:	ff 75 f4             	pushl  -0xc(%ebp)
801016e4:	e8 45 eb ff ff       	call   8010022e <brelse>
801016e9:	83 c4 10             	add    $0x10,%esp
}
801016ec:	90                   	nop
801016ed:	c9                   	leave  
801016ee:	c3                   	ret    

801016ef <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801016ef:	55                   	push   %ebp
801016f0:	89 e5                	mov    %esp,%ebp
801016f2:	57                   	push   %edi
801016f3:	56                   	push   %esi
801016f4:	53                   	push   %ebx
801016f5:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
801016f8:	83 ec 08             	sub    $0x8,%esp
801016fb:	68 55 a0 10 80       	push   $0x8010a055
80101700:	68 60 32 11 80       	push   $0x80113260
80101705:	e8 49 51 00 00       	call   80106853 <initlock>
8010170a:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010170d:	83 ec 08             	sub    $0x8,%esp
80101710:	68 40 32 11 80       	push   $0x80113240
80101715:	ff 75 08             	pushl  0x8(%ebp)
80101718:	e8 18 fd ff ff       	call   80101435 <readsb>
8010171d:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101720:	a1 58 32 11 80       	mov    0x80113258,%eax
80101725:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101728:	8b 3d 54 32 11 80    	mov    0x80113254,%edi
8010172e:	8b 35 50 32 11 80    	mov    0x80113250,%esi
80101734:	8b 1d 4c 32 11 80    	mov    0x8011324c,%ebx
8010173a:	8b 0d 48 32 11 80    	mov    0x80113248,%ecx
80101740:	8b 15 44 32 11 80    	mov    0x80113244,%edx
80101746:	a1 40 32 11 80       	mov    0x80113240,%eax
8010174b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010174e:	57                   	push   %edi
8010174f:	56                   	push   %esi
80101750:	53                   	push   %ebx
80101751:	51                   	push   %ecx
80101752:	52                   	push   %edx
80101753:	50                   	push   %eax
80101754:	68 5c a0 10 80       	push   $0x8010a05c
80101759:	e8 68 ec ff ff       	call   801003c6 <cprintf>
8010175e:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101761:	90                   	nop
80101762:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101765:	5b                   	pop    %ebx
80101766:	5e                   	pop    %esi
80101767:	5f                   	pop    %edi
80101768:	5d                   	pop    %ebp
80101769:	c3                   	ret    

8010176a <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010176a:	55                   	push   %ebp
8010176b:	89 e5                	mov    %esp,%ebp
8010176d:	83 ec 28             	sub    $0x28,%esp
80101770:	8b 45 0c             	mov    0xc(%ebp),%eax
80101773:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101777:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010177e:	e9 9e 00 00 00       	jmp    80101821 <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101786:	c1 e8 03             	shr    $0x3,%eax
80101789:	89 c2                	mov    %eax,%edx
8010178b:	a1 54 32 11 80       	mov    0x80113254,%eax
80101790:	01 d0                	add    %edx,%eax
80101792:	83 ec 08             	sub    $0x8,%esp
80101795:	50                   	push   %eax
80101796:	ff 75 08             	pushl  0x8(%ebp)
80101799:	e8 18 ea ff ff       	call   801001b6 <bread>
8010179e:	83 c4 10             	add    $0x10,%esp
801017a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801017a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017a7:	8d 50 18             	lea    0x18(%eax),%edx
801017aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ad:	83 e0 07             	and    $0x7,%eax
801017b0:	c1 e0 06             	shl    $0x6,%eax
801017b3:	01 d0                	add    %edx,%eax
801017b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801017b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017bb:	0f b7 00             	movzwl (%eax),%eax
801017be:	66 85 c0             	test   %ax,%ax
801017c1:	75 4c                	jne    8010180f <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
801017c3:	83 ec 04             	sub    $0x4,%esp
801017c6:	6a 40                	push   $0x40
801017c8:	6a 00                	push   $0x0
801017ca:	ff 75 ec             	pushl  -0x14(%ebp)
801017cd:	e8 06 53 00 00       	call   80106ad8 <memset>
801017d2:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801017d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801017d8:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801017dc:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
801017df:	83 ec 0c             	sub    $0xc,%esp
801017e2:	ff 75 f0             	pushl  -0x10(%ebp)
801017e5:	e8 4c 20 00 00       	call   80103836 <log_write>
801017ea:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801017ed:	83 ec 0c             	sub    $0xc,%esp
801017f0:	ff 75 f0             	pushl  -0x10(%ebp)
801017f3:	e8 36 ea ff ff       	call   8010022e <brelse>
801017f8:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801017fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fe:	83 ec 08             	sub    $0x8,%esp
80101801:	50                   	push   %eax
80101802:	ff 75 08             	pushl  0x8(%ebp)
80101805:	e8 f8 00 00 00       	call   80101902 <iget>
8010180a:	83 c4 10             	add    $0x10,%esp
8010180d:	eb 30                	jmp    8010183f <ialloc+0xd5>
    }
    brelse(bp);
8010180f:	83 ec 0c             	sub    $0xc,%esp
80101812:	ff 75 f0             	pushl  -0x10(%ebp)
80101815:	e8 14 ea ff ff       	call   8010022e <brelse>
8010181a:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010181d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101821:	8b 15 48 32 11 80    	mov    0x80113248,%edx
80101827:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010182a:	39 c2                	cmp    %eax,%edx
8010182c:	0f 87 51 ff ff ff    	ja     80101783 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101832:	83 ec 0c             	sub    $0xc,%esp
80101835:	68 af a0 10 80       	push   $0x8010a0af
8010183a:	e8 27 ed ff ff       	call   80100566 <panic>
}
8010183f:	c9                   	leave  
80101840:	c3                   	ret    

80101841 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101841:	55                   	push   %ebp
80101842:	89 e5                	mov    %esp,%ebp
80101844:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101847:	8b 45 08             	mov    0x8(%ebp),%eax
8010184a:	8b 40 04             	mov    0x4(%eax),%eax
8010184d:	c1 e8 03             	shr    $0x3,%eax
80101850:	89 c2                	mov    %eax,%edx
80101852:	a1 54 32 11 80       	mov    0x80113254,%eax
80101857:	01 c2                	add    %eax,%edx
80101859:	8b 45 08             	mov    0x8(%ebp),%eax
8010185c:	8b 00                	mov    (%eax),%eax
8010185e:	83 ec 08             	sub    $0x8,%esp
80101861:	52                   	push   %edx
80101862:	50                   	push   %eax
80101863:	e8 4e e9 ff ff       	call   801001b6 <bread>
80101868:	83 c4 10             	add    $0x10,%esp
8010186b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101871:	8d 50 18             	lea    0x18(%eax),%edx
80101874:	8b 45 08             	mov    0x8(%ebp),%eax
80101877:	8b 40 04             	mov    0x4(%eax),%eax
8010187a:	83 e0 07             	and    $0x7,%eax
8010187d:	c1 e0 06             	shl    $0x6,%eax
80101880:	01 d0                	add    %edx,%eax
80101882:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101885:	8b 45 08             	mov    0x8(%ebp),%eax
80101888:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010188c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010188f:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101892:	8b 45 08             	mov    0x8(%ebp),%eax
80101895:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010189c:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801018a0:	8b 45 08             	mov    0x8(%ebp),%eax
801018a3:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801018a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018aa:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801018ae:	8b 45 08             	mov    0x8(%ebp),%eax
801018b1:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801018b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018b8:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801018bc:	8b 45 08             	mov    0x8(%ebp),%eax
801018bf:	8b 50 18             	mov    0x18(%eax),%edx
801018c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018c5:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801018c8:	8b 45 08             	mov    0x8(%ebp),%eax
801018cb:	8d 50 1c             	lea    0x1c(%eax),%edx
801018ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018d1:	83 c0 0c             	add    $0xc,%eax
801018d4:	83 ec 04             	sub    $0x4,%esp
801018d7:	6a 34                	push   $0x34
801018d9:	52                   	push   %edx
801018da:	50                   	push   %eax
801018db:	e8 b7 52 00 00       	call   80106b97 <memmove>
801018e0:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801018e3:	83 ec 0c             	sub    $0xc,%esp
801018e6:	ff 75 f4             	pushl  -0xc(%ebp)
801018e9:	e8 48 1f 00 00       	call   80103836 <log_write>
801018ee:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801018f1:	83 ec 0c             	sub    $0xc,%esp
801018f4:	ff 75 f4             	pushl  -0xc(%ebp)
801018f7:	e8 32 e9 ff ff       	call   8010022e <brelse>
801018fc:	83 c4 10             	add    $0x10,%esp
}
801018ff:	90                   	nop
80101900:	c9                   	leave  
80101901:	c3                   	ret    

80101902 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101902:	55                   	push   %ebp
80101903:	89 e5                	mov    %esp,%ebp
80101905:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101908:	83 ec 0c             	sub    $0xc,%esp
8010190b:	68 60 32 11 80       	push   $0x80113260
80101910:	e8 60 4f 00 00       	call   80106875 <acquire>
80101915:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101918:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010191f:	c7 45 f4 94 32 11 80 	movl   $0x80113294,-0xc(%ebp)
80101926:	eb 5d                	jmp    80101985 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101928:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192b:	8b 40 08             	mov    0x8(%eax),%eax
8010192e:	85 c0                	test   %eax,%eax
80101930:	7e 39                	jle    8010196b <iget+0x69>
80101932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101935:	8b 00                	mov    (%eax),%eax
80101937:	3b 45 08             	cmp    0x8(%ebp),%eax
8010193a:	75 2f                	jne    8010196b <iget+0x69>
8010193c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010193f:	8b 40 04             	mov    0x4(%eax),%eax
80101942:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101945:	75 24                	jne    8010196b <iget+0x69>
      ip->ref++;
80101947:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010194a:	8b 40 08             	mov    0x8(%eax),%eax
8010194d:	8d 50 01             	lea    0x1(%eax),%edx
80101950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101953:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101956:	83 ec 0c             	sub    $0xc,%esp
80101959:	68 60 32 11 80       	push   $0x80113260
8010195e:	e8 79 4f 00 00       	call   801068dc <release>
80101963:	83 c4 10             	add    $0x10,%esp
      return ip;
80101966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101969:	eb 74                	jmp    801019df <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010196b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010196f:	75 10                	jne    80101981 <iget+0x7f>
80101971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101974:	8b 40 08             	mov    0x8(%eax),%eax
80101977:	85 c0                	test   %eax,%eax
80101979:	75 06                	jne    80101981 <iget+0x7f>
      empty = ip;
8010197b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010197e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101981:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101985:	81 7d f4 34 42 11 80 	cmpl   $0x80114234,-0xc(%ebp)
8010198c:	72 9a                	jb     80101928 <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
8010198e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101992:	75 0d                	jne    801019a1 <iget+0x9f>
    panic("iget: no inodes");
80101994:	83 ec 0c             	sub    $0xc,%esp
80101997:	68 c1 a0 10 80       	push   $0x8010a0c1
8010199c:	e8 c5 eb ff ff       	call   80100566 <panic>

  ip = empty;
801019a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801019a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019aa:	8b 55 08             	mov    0x8(%ebp),%edx
801019ad:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801019af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b2:	8b 55 0c             	mov    0xc(%ebp),%edx
801019b5:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
801019b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019bb:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
801019c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
801019cc:	83 ec 0c             	sub    $0xc,%esp
801019cf:	68 60 32 11 80       	push   $0x80113260
801019d4:	e8 03 4f 00 00       	call   801068dc <release>
801019d9:	83 c4 10             	add    $0x10,%esp

  return ip;
801019dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801019df:	c9                   	leave  
801019e0:	c3                   	ret    

801019e1 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801019e1:	55                   	push   %ebp
801019e2:	89 e5                	mov    %esp,%ebp
801019e4:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
801019e7:	83 ec 0c             	sub    $0xc,%esp
801019ea:	68 60 32 11 80       	push   $0x80113260
801019ef:	e8 81 4e 00 00       	call   80106875 <acquire>
801019f4:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
801019f7:	8b 45 08             	mov    0x8(%ebp),%eax
801019fa:	8b 40 08             	mov    0x8(%eax),%eax
801019fd:	8d 50 01             	lea    0x1(%eax),%edx
80101a00:	8b 45 08             	mov    0x8(%ebp),%eax
80101a03:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101a06:	83 ec 0c             	sub    $0xc,%esp
80101a09:	68 60 32 11 80       	push   $0x80113260
80101a0e:	e8 c9 4e 00 00       	call   801068dc <release>
80101a13:	83 c4 10             	add    $0x10,%esp
  return ip;
80101a16:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101a19:	c9                   	leave  
80101a1a:	c3                   	ret    

80101a1b <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101a1b:	55                   	push   %ebp
80101a1c:	89 e5                	mov    %esp,%ebp
80101a1e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101a21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a25:	74 0a                	je     80101a31 <ilock+0x16>
80101a27:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2a:	8b 40 08             	mov    0x8(%eax),%eax
80101a2d:	85 c0                	test   %eax,%eax
80101a2f:	7f 0d                	jg     80101a3e <ilock+0x23>
    panic("ilock");
80101a31:	83 ec 0c             	sub    $0xc,%esp
80101a34:	68 d1 a0 10 80       	push   $0x8010a0d1
80101a39:	e8 28 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a3e:	83 ec 0c             	sub    $0xc,%esp
80101a41:	68 60 32 11 80       	push   $0x80113260
80101a46:	e8 2a 4e 00 00       	call   80106875 <acquire>
80101a4b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a4e:	eb 13                	jmp    80101a63 <ilock+0x48>
    sleep(ip, &icache.lock);
80101a50:	83 ec 08             	sub    $0x8,%esp
80101a53:	68 60 32 11 80       	push   $0x80113260
80101a58:	ff 75 08             	pushl  0x8(%ebp)
80101a5b:	e8 2c 3b 00 00       	call   8010558c <sleep>
80101a60:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101a63:	8b 45 08             	mov    0x8(%ebp),%eax
80101a66:	8b 40 0c             	mov    0xc(%eax),%eax
80101a69:	83 e0 01             	and    $0x1,%eax
80101a6c:	85 c0                	test   %eax,%eax
80101a6e:	75 e0                	jne    80101a50 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 40 0c             	mov    0xc(%eax),%eax
80101a76:	83 c8 01             	or     $0x1,%eax
80101a79:	89 c2                	mov    %eax,%edx
80101a7b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7e:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101a81:	83 ec 0c             	sub    $0xc,%esp
80101a84:	68 60 32 11 80       	push   $0x80113260
80101a89:	e8 4e 4e 00 00       	call   801068dc <release>
80101a8e:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101a91:	8b 45 08             	mov    0x8(%ebp),%eax
80101a94:	8b 40 0c             	mov    0xc(%eax),%eax
80101a97:	83 e0 02             	and    $0x2,%eax
80101a9a:	85 c0                	test   %eax,%eax
80101a9c:	0f 85 d4 00 00 00    	jne    80101b76 <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101aa2:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa5:	8b 40 04             	mov    0x4(%eax),%eax
80101aa8:	c1 e8 03             	shr    $0x3,%eax
80101aab:	89 c2                	mov    %eax,%edx
80101aad:	a1 54 32 11 80       	mov    0x80113254,%eax
80101ab2:	01 c2                	add    %eax,%edx
80101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab7:	8b 00                	mov    (%eax),%eax
80101ab9:	83 ec 08             	sub    $0x8,%esp
80101abc:	52                   	push   %edx
80101abd:	50                   	push   %eax
80101abe:	e8 f3 e6 ff ff       	call   801001b6 <bread>
80101ac3:	83 c4 10             	add    $0x10,%esp
80101ac6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101acc:	8d 50 18             	lea    0x18(%eax),%edx
80101acf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad2:	8b 40 04             	mov    0x4(%eax),%eax
80101ad5:	83 e0 07             	and    $0x7,%eax
80101ad8:	c1 e0 06             	shl    $0x6,%eax
80101adb:	01 d0                	add    %edx,%eax
80101add:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ae3:	0f b7 10             	movzwl (%eax),%edx
80101ae6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae9:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101aed:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101af0:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101af4:	8b 45 08             	mov    0x8(%ebp),%eax
80101af7:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101afe:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101b02:	8b 45 08             	mov    0x8(%ebp),%eax
80101b05:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101b09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b0c:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101b10:	8b 45 08             	mov    0x8(%ebp),%eax
80101b13:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b1a:	8b 50 08             	mov    0x8(%eax),%edx
80101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b20:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101b26:	8d 50 0c             	lea    0xc(%eax),%edx
80101b29:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2c:	83 c0 1c             	add    $0x1c,%eax
80101b2f:	83 ec 04             	sub    $0x4,%esp
80101b32:	6a 34                	push   $0x34
80101b34:	52                   	push   %edx
80101b35:	50                   	push   %eax
80101b36:	e8 5c 50 00 00       	call   80106b97 <memmove>
80101b3b:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101b3e:	83 ec 0c             	sub    $0xc,%esp
80101b41:	ff 75 f4             	pushl  -0xc(%ebp)
80101b44:	e8 e5 e6 ff ff       	call   8010022e <brelse>
80101b49:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4f:	8b 40 0c             	mov    0xc(%eax),%eax
80101b52:	83 c8 02             	or     $0x2,%eax
80101b55:	89 c2                	mov    %eax,%edx
80101b57:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5a:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b60:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101b64:	66 85 c0             	test   %ax,%ax
80101b67:	75 0d                	jne    80101b76 <ilock+0x15b>
      panic("ilock: no type");
80101b69:	83 ec 0c             	sub    $0xc,%esp
80101b6c:	68 d7 a0 10 80       	push   $0x8010a0d7
80101b71:	e8 f0 e9 ff ff       	call   80100566 <panic>
  }
}
80101b76:	90                   	nop
80101b77:	c9                   	leave  
80101b78:	c3                   	ret    

80101b79 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101b79:	55                   	push   %ebp
80101b7a:	89 e5                	mov    %esp,%ebp
80101b7c:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101b7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b83:	74 17                	je     80101b9c <iunlock+0x23>
80101b85:	8b 45 08             	mov    0x8(%ebp),%eax
80101b88:	8b 40 0c             	mov    0xc(%eax),%eax
80101b8b:	83 e0 01             	and    $0x1,%eax
80101b8e:	85 c0                	test   %eax,%eax
80101b90:	74 0a                	je     80101b9c <iunlock+0x23>
80101b92:	8b 45 08             	mov    0x8(%ebp),%eax
80101b95:	8b 40 08             	mov    0x8(%eax),%eax
80101b98:	85 c0                	test   %eax,%eax
80101b9a:	7f 0d                	jg     80101ba9 <iunlock+0x30>
    panic("iunlock");
80101b9c:	83 ec 0c             	sub    $0xc,%esp
80101b9f:	68 e6 a0 10 80       	push   $0x8010a0e6
80101ba4:	e8 bd e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101ba9:	83 ec 0c             	sub    $0xc,%esp
80101bac:	68 60 32 11 80       	push   $0x80113260
80101bb1:	e8 bf 4c 00 00       	call   80106875 <acquire>
80101bb6:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbc:	8b 40 0c             	mov    0xc(%eax),%eax
80101bbf:	83 e0 fe             	and    $0xfffffffe,%eax
80101bc2:	89 c2                	mov    %eax,%edx
80101bc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc7:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101bca:	83 ec 0c             	sub    $0xc,%esp
80101bcd:	ff 75 08             	pushl  0x8(%ebp)
80101bd0:	e8 12 3c 00 00       	call   801057e7 <wakeup>
80101bd5:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bd8:	83 ec 0c             	sub    $0xc,%esp
80101bdb:	68 60 32 11 80       	push   $0x80113260
80101be0:	e8 f7 4c 00 00       	call   801068dc <release>
80101be5:	83 c4 10             	add    $0x10,%esp
}
80101be8:	90                   	nop
80101be9:	c9                   	leave  
80101bea:	c3                   	ret    

80101beb <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101beb:	55                   	push   %ebp
80101bec:	89 e5                	mov    %esp,%ebp
80101bee:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101bf1:	83 ec 0c             	sub    $0xc,%esp
80101bf4:	68 60 32 11 80       	push   $0x80113260
80101bf9:	e8 77 4c 00 00       	call   80106875 <acquire>
80101bfe:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101c01:	8b 45 08             	mov    0x8(%ebp),%eax
80101c04:	8b 40 08             	mov    0x8(%eax),%eax
80101c07:	83 f8 01             	cmp    $0x1,%eax
80101c0a:	0f 85 a9 00 00 00    	jne    80101cb9 <iput+0xce>
80101c10:	8b 45 08             	mov    0x8(%ebp),%eax
80101c13:	8b 40 0c             	mov    0xc(%eax),%eax
80101c16:	83 e0 02             	and    $0x2,%eax
80101c19:	85 c0                	test   %eax,%eax
80101c1b:	0f 84 98 00 00 00    	je     80101cb9 <iput+0xce>
80101c21:	8b 45 08             	mov    0x8(%ebp),%eax
80101c24:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101c28:	66 85 c0             	test   %ax,%ax
80101c2b:	0f 85 88 00 00 00    	jne    80101cb9 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101c31:	8b 45 08             	mov    0x8(%ebp),%eax
80101c34:	8b 40 0c             	mov    0xc(%eax),%eax
80101c37:	83 e0 01             	and    $0x1,%eax
80101c3a:	85 c0                	test   %eax,%eax
80101c3c:	74 0d                	je     80101c4b <iput+0x60>
      panic("iput busy");
80101c3e:	83 ec 0c             	sub    $0xc,%esp
80101c41:	68 ee a0 10 80       	push   $0x8010a0ee
80101c46:	e8 1b e9 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4e:	8b 40 0c             	mov    0xc(%eax),%eax
80101c51:	83 c8 01             	or     $0x1,%eax
80101c54:	89 c2                	mov    %eax,%edx
80101c56:	8b 45 08             	mov    0x8(%ebp),%eax
80101c59:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 60 32 11 80       	push   $0x80113260
80101c64:	e8 73 4c 00 00       	call   801068dc <release>
80101c69:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101c6c:	83 ec 0c             	sub    $0xc,%esp
80101c6f:	ff 75 08             	pushl  0x8(%ebp)
80101c72:	e8 a8 01 00 00       	call   80101e1f <itrunc>
80101c77:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101c7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7d:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101c83:	83 ec 0c             	sub    $0xc,%esp
80101c86:	ff 75 08             	pushl  0x8(%ebp)
80101c89:	e8 b3 fb ff ff       	call   80101841 <iupdate>
80101c8e:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101c91:	83 ec 0c             	sub    $0xc,%esp
80101c94:	68 60 32 11 80       	push   $0x80113260
80101c99:	e8 d7 4b 00 00       	call   80106875 <acquire>
80101c9e:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101ca1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
80101cae:	ff 75 08             	pushl  0x8(%ebp)
80101cb1:	e8 31 3b 00 00       	call   801057e7 <wakeup>
80101cb6:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbc:	8b 40 08             	mov    0x8(%eax),%eax
80101cbf:	8d 50 ff             	lea    -0x1(%eax),%edx
80101cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc5:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101cc8:	83 ec 0c             	sub    $0xc,%esp
80101ccb:	68 60 32 11 80       	push   $0x80113260
80101cd0:	e8 07 4c 00 00       	call   801068dc <release>
80101cd5:	83 c4 10             	add    $0x10,%esp
}
80101cd8:	90                   	nop
80101cd9:	c9                   	leave  
80101cda:	c3                   	ret    

80101cdb <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101cdb:	55                   	push   %ebp
80101cdc:	89 e5                	mov    %esp,%ebp
80101cde:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101ce1:	83 ec 0c             	sub    $0xc,%esp
80101ce4:	ff 75 08             	pushl  0x8(%ebp)
80101ce7:	e8 8d fe ff ff       	call   80101b79 <iunlock>
80101cec:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101cef:	83 ec 0c             	sub    $0xc,%esp
80101cf2:	ff 75 08             	pushl  0x8(%ebp)
80101cf5:	e8 f1 fe ff ff       	call   80101beb <iput>
80101cfa:	83 c4 10             	add    $0x10,%esp
}
80101cfd:	90                   	nop
80101cfe:	c9                   	leave  
80101cff:	c3                   	ret    

80101d00 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101d00:	55                   	push   %ebp
80101d01:	89 e5                	mov    %esp,%ebp
80101d03:	53                   	push   %ebx
80101d04:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101d07:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101d0b:	77 42                	ja     80101d4f <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101d0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d10:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d13:	83 c2 04             	add    $0x4,%edx
80101d16:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d21:	75 24                	jne    80101d47 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101d23:	8b 45 08             	mov    0x8(%ebp),%eax
80101d26:	8b 00                	mov    (%eax),%eax
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	50                   	push   %eax
80101d2c:	e8 9a f7 ff ff       	call   801014cb <balloc>
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d37:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
80101d3d:	8d 4a 04             	lea    0x4(%edx),%ecx
80101d40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d43:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d4a:	e9 cb 00 00 00       	jmp    80101e1a <bmap+0x11a>
  }
  bn -= NDIRECT;
80101d4f:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101d53:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101d57:	0f 87 b0 00 00 00    	ja     80101e0d <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101d5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d60:	8b 40 4c             	mov    0x4c(%eax),%eax
80101d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d6a:	75 1d                	jne    80101d89 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101d6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6f:	8b 00                	mov    (%eax),%eax
80101d71:	83 ec 0c             	sub    $0xc,%esp
80101d74:	50                   	push   %eax
80101d75:	e8 51 f7 ff ff       	call   801014cb <balloc>
80101d7a:	83 c4 10             	add    $0x10,%esp
80101d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d80:	8b 45 08             	mov    0x8(%ebp),%eax
80101d83:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d86:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101d89:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8c:	8b 00                	mov    (%eax),%eax
80101d8e:	83 ec 08             	sub    $0x8,%esp
80101d91:	ff 75 f4             	pushl  -0xc(%ebp)
80101d94:	50                   	push   %eax
80101d95:	e8 1c e4 ff ff       	call   801001b6 <bread>
80101d9a:	83 c4 10             	add    $0x10,%esp
80101d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101da3:	83 c0 18             	add    $0x18,%eax
80101da6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101da9:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101db3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101db6:	01 d0                	add    %edx,%eax
80101db8:	8b 00                	mov    (%eax),%eax
80101dba:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101dbd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101dc1:	75 37                	jne    80101dfa <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dc6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101dcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101dd0:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101dd3:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd6:	8b 00                	mov    (%eax),%eax
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	50                   	push   %eax
80101ddc:	e8 ea f6 ff ff       	call   801014cb <balloc>
80101de1:	83 c4 10             	add    $0x10,%esp
80101de4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101de7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101dea:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101dec:	83 ec 0c             	sub    $0xc,%esp
80101def:	ff 75 f0             	pushl  -0x10(%ebp)
80101df2:	e8 3f 1a 00 00       	call   80103836 <log_write>
80101df7:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101dfa:	83 ec 0c             	sub    $0xc,%esp
80101dfd:	ff 75 f0             	pushl  -0x10(%ebp)
80101e00:	e8 29 e4 ff ff       	call   8010022e <brelse>
80101e05:	83 c4 10             	add    $0x10,%esp
    return addr;
80101e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e0b:	eb 0d                	jmp    80101e1a <bmap+0x11a>
  }

  panic("bmap: out of range");
80101e0d:	83 ec 0c             	sub    $0xc,%esp
80101e10:	68 f8 a0 10 80       	push   $0x8010a0f8
80101e15:	e8 4c e7 ff ff       	call   80100566 <panic>
}
80101e1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e1d:	c9                   	leave  
80101e1e:	c3                   	ret    

80101e1f <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101e1f:	55                   	push   %ebp
80101e20:	89 e5                	mov    %esp,%ebp
80101e22:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e2c:	eb 45                	jmp    80101e73 <itrunc+0x54>
    if(ip->addrs[i]){
80101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e34:	83 c2 04             	add    $0x4,%edx
80101e37:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e3b:	85 c0                	test   %eax,%eax
80101e3d:	74 30                	je     80101e6f <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e42:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e45:	83 c2 04             	add    $0x4,%edx
80101e48:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101e4c:	8b 55 08             	mov    0x8(%ebp),%edx
80101e4f:	8b 12                	mov    (%edx),%edx
80101e51:	83 ec 08             	sub    $0x8,%esp
80101e54:	50                   	push   %eax
80101e55:	52                   	push   %edx
80101e56:	e8 bc f7 ff ff       	call   80101617 <bfree>
80101e5b:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101e5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e61:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e64:	83 c2 04             	add    $0x4,%edx
80101e67:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101e6e:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101e6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101e73:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101e77:	7e b5                	jle    80101e2e <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101e79:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7c:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e7f:	85 c0                	test   %eax,%eax
80101e81:	0f 84 a1 00 00 00    	je     80101f28 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101e87:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8a:	8b 50 4c             	mov    0x4c(%eax),%edx
80101e8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e90:	8b 00                	mov    (%eax),%eax
80101e92:	83 ec 08             	sub    $0x8,%esp
80101e95:	52                   	push   %edx
80101e96:	50                   	push   %eax
80101e97:	e8 1a e3 ff ff       	call   801001b6 <bread>
80101e9c:	83 c4 10             	add    $0x10,%esp
80101e9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ea5:	83 c0 18             	add    $0x18,%eax
80101ea8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101eab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101eb2:	eb 3c                	jmp    80101ef0 <itrunc+0xd1>
      if(a[j])
80101eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eb7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ebe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ec1:	01 d0                	add    %edx,%eax
80101ec3:	8b 00                	mov    (%eax),%eax
80101ec5:	85 c0                	test   %eax,%eax
80101ec7:	74 23                	je     80101eec <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ecc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ed3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ed6:	01 d0                	add    %edx,%eax
80101ed8:	8b 00                	mov    (%eax),%eax
80101eda:	8b 55 08             	mov    0x8(%ebp),%edx
80101edd:	8b 12                	mov    (%edx),%edx
80101edf:	83 ec 08             	sub    $0x8,%esp
80101ee2:	50                   	push   %eax
80101ee3:	52                   	push   %edx
80101ee4:	e8 2e f7 ff ff       	call   80101617 <bfree>
80101ee9:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101eec:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ef0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ef3:	83 f8 7f             	cmp    $0x7f,%eax
80101ef6:	76 bc                	jbe    80101eb4 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	ff 75 ec             	pushl  -0x14(%ebp)
80101efe:	e8 2b e3 ff ff       	call   8010022e <brelse>
80101f03:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101f06:	8b 45 08             	mov    0x8(%ebp),%eax
80101f09:	8b 40 4c             	mov    0x4c(%eax),%eax
80101f0c:	8b 55 08             	mov    0x8(%ebp),%edx
80101f0f:	8b 12                	mov    (%edx),%edx
80101f11:	83 ec 08             	sub    $0x8,%esp
80101f14:	50                   	push   %eax
80101f15:	52                   	push   %edx
80101f16:	e8 fc f6 ff ff       	call   80101617 <bfree>
80101f1b:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101f1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f21:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101f28:	8b 45 08             	mov    0x8(%ebp),%eax
80101f2b:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101f32:	83 ec 0c             	sub    $0xc,%esp
80101f35:	ff 75 08             	pushl  0x8(%ebp)
80101f38:	e8 04 f9 ff ff       	call   80101841 <iupdate>
80101f3d:	83 c4 10             	add    $0x10,%esp
}
80101f40:	90                   	nop
80101f41:	c9                   	leave  
80101f42:	c3                   	ret    

80101f43 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101f43:	55                   	push   %ebp
80101f44:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101f46:	8b 45 08             	mov    0x8(%ebp),%eax
80101f49:	8b 00                	mov    (%eax),%eax
80101f4b:	89 c2                	mov    %eax,%edx
80101f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f50:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101f53:	8b 45 08             	mov    0x8(%ebp),%eax
80101f56:	8b 50 04             	mov    0x4(%eax),%edx
80101f59:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f5c:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101f5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f62:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101f66:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f69:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101f6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6f:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101f73:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f76:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101f7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7d:	8b 50 18             	mov    0x18(%eax),%edx
80101f80:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f83:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f86:	90                   	nop
80101f87:	5d                   	pop    %ebp
80101f88:	c3                   	ret    

80101f89 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101f89:	55                   	push   %ebp
80101f8a:	89 e5                	mov    %esp,%ebp
80101f8c:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f92:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f96:	66 83 f8 03          	cmp    $0x3,%ax
80101f9a:	75 5c                	jne    80101ff8 <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f9c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fa3:	66 85 c0             	test   %ax,%ax
80101fa6:	78 20                	js     80101fc8 <readi+0x3f>
80101fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fab:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101faf:	66 83 f8 09          	cmp    $0x9,%ax
80101fb3:	7f 13                	jg     80101fc8 <readi+0x3f>
80101fb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101fb8:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fbc:	98                   	cwtl   
80101fbd:	8b 04 c5 e0 31 11 80 	mov    -0x7feece20(,%eax,8),%eax
80101fc4:	85 c0                	test   %eax,%eax
80101fc6:	75 0a                	jne    80101fd2 <readi+0x49>
      return -1;
80101fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fcd:	e9 0c 01 00 00       	jmp    801020de <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80101fd2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd5:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101fd9:	98                   	cwtl   
80101fda:	8b 04 c5 e0 31 11 80 	mov    -0x7feece20(,%eax,8),%eax
80101fe1:	8b 55 14             	mov    0x14(%ebp),%edx
80101fe4:	83 ec 04             	sub    $0x4,%esp
80101fe7:	52                   	push   %edx
80101fe8:	ff 75 0c             	pushl  0xc(%ebp)
80101feb:	ff 75 08             	pushl  0x8(%ebp)
80101fee:	ff d0                	call   *%eax
80101ff0:	83 c4 10             	add    $0x10,%esp
80101ff3:	e9 e6 00 00 00       	jmp    801020de <readi+0x155>
  }

  if(off > ip->size || off + n < off)
80101ff8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ffb:	8b 40 18             	mov    0x18(%eax),%eax
80101ffe:	3b 45 10             	cmp    0x10(%ebp),%eax
80102001:	72 0d                	jb     80102010 <readi+0x87>
80102003:	8b 55 10             	mov    0x10(%ebp),%edx
80102006:	8b 45 14             	mov    0x14(%ebp),%eax
80102009:	01 d0                	add    %edx,%eax
8010200b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010200e:	73 0a                	jae    8010201a <readi+0x91>
    return -1;
80102010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102015:	e9 c4 00 00 00       	jmp    801020de <readi+0x155>
  if(off + n > ip->size)
8010201a:	8b 55 10             	mov    0x10(%ebp),%edx
8010201d:	8b 45 14             	mov    0x14(%ebp),%eax
80102020:	01 c2                	add    %eax,%edx
80102022:	8b 45 08             	mov    0x8(%ebp),%eax
80102025:	8b 40 18             	mov    0x18(%eax),%eax
80102028:	39 c2                	cmp    %eax,%edx
8010202a:	76 0c                	jbe    80102038 <readi+0xaf>
    n = ip->size - off;
8010202c:	8b 45 08             	mov    0x8(%ebp),%eax
8010202f:	8b 40 18             	mov    0x18(%eax),%eax
80102032:	2b 45 10             	sub    0x10(%ebp),%eax
80102035:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102038:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010203f:	e9 8b 00 00 00       	jmp    801020cf <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102044:	8b 45 10             	mov    0x10(%ebp),%eax
80102047:	c1 e8 09             	shr    $0x9,%eax
8010204a:	83 ec 08             	sub    $0x8,%esp
8010204d:	50                   	push   %eax
8010204e:	ff 75 08             	pushl  0x8(%ebp)
80102051:	e8 aa fc ff ff       	call   80101d00 <bmap>
80102056:	83 c4 10             	add    $0x10,%esp
80102059:	89 c2                	mov    %eax,%edx
8010205b:	8b 45 08             	mov    0x8(%ebp),%eax
8010205e:	8b 00                	mov    (%eax),%eax
80102060:	83 ec 08             	sub    $0x8,%esp
80102063:	52                   	push   %edx
80102064:	50                   	push   %eax
80102065:	e8 4c e1 ff ff       	call   801001b6 <bread>
8010206a:	83 c4 10             	add    $0x10,%esp
8010206d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102070:	8b 45 10             	mov    0x10(%ebp),%eax
80102073:	25 ff 01 00 00       	and    $0x1ff,%eax
80102078:	ba 00 02 00 00       	mov    $0x200,%edx
8010207d:	29 c2                	sub    %eax,%edx
8010207f:	8b 45 14             	mov    0x14(%ebp),%eax
80102082:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102085:	39 c2                	cmp    %eax,%edx
80102087:	0f 46 c2             	cmovbe %edx,%eax
8010208a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
8010208d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102090:	8d 50 18             	lea    0x18(%eax),%edx
80102093:	8b 45 10             	mov    0x10(%ebp),%eax
80102096:	25 ff 01 00 00       	and    $0x1ff,%eax
8010209b:	01 d0                	add    %edx,%eax
8010209d:	83 ec 04             	sub    $0x4,%esp
801020a0:	ff 75 ec             	pushl  -0x14(%ebp)
801020a3:	50                   	push   %eax
801020a4:	ff 75 0c             	pushl  0xc(%ebp)
801020a7:	e8 eb 4a 00 00       	call   80106b97 <memmove>
801020ac:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801020af:	83 ec 0c             	sub    $0xc,%esp
801020b2:	ff 75 f0             	pushl  -0x10(%ebp)
801020b5:	e8 74 e1 ff ff       	call   8010022e <brelse>
801020ba:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801020bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020c0:	01 45 f4             	add    %eax,-0xc(%ebp)
801020c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020c6:	01 45 10             	add    %eax,0x10(%ebp)
801020c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020cc:	01 45 0c             	add    %eax,0xc(%ebp)
801020cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020d2:	3b 45 14             	cmp    0x14(%ebp),%eax
801020d5:	0f 82 69 ff ff ff    	jb     80102044 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801020db:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020de:	c9                   	leave  
801020df:	c3                   	ret    

801020e0 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801020e0:	55                   	push   %ebp
801020e1:	89 e5                	mov    %esp,%ebp
801020e3:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020e6:	8b 45 08             	mov    0x8(%ebp),%eax
801020e9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020ed:	66 83 f8 03          	cmp    $0x3,%ax
801020f1:	75 5c                	jne    8010214f <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801020f3:	8b 45 08             	mov    0x8(%ebp),%eax
801020f6:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020fa:	66 85 c0             	test   %ax,%ax
801020fd:	78 20                	js     8010211f <writei+0x3f>
801020ff:	8b 45 08             	mov    0x8(%ebp),%eax
80102102:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102106:	66 83 f8 09          	cmp    $0x9,%ax
8010210a:	7f 13                	jg     8010211f <writei+0x3f>
8010210c:	8b 45 08             	mov    0x8(%ebp),%eax
8010210f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102113:	98                   	cwtl   
80102114:	8b 04 c5 e4 31 11 80 	mov    -0x7feece1c(,%eax,8),%eax
8010211b:	85 c0                	test   %eax,%eax
8010211d:	75 0a                	jne    80102129 <writei+0x49>
      return -1;
8010211f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102124:	e9 3d 01 00 00       	jmp    80102266 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
80102129:	8b 45 08             	mov    0x8(%ebp),%eax
8010212c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102130:	98                   	cwtl   
80102131:	8b 04 c5 e4 31 11 80 	mov    -0x7feece1c(,%eax,8),%eax
80102138:	8b 55 14             	mov    0x14(%ebp),%edx
8010213b:	83 ec 04             	sub    $0x4,%esp
8010213e:	52                   	push   %edx
8010213f:	ff 75 0c             	pushl  0xc(%ebp)
80102142:	ff 75 08             	pushl  0x8(%ebp)
80102145:	ff d0                	call   *%eax
80102147:	83 c4 10             	add    $0x10,%esp
8010214a:	e9 17 01 00 00       	jmp    80102266 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
8010214f:	8b 45 08             	mov    0x8(%ebp),%eax
80102152:	8b 40 18             	mov    0x18(%eax),%eax
80102155:	3b 45 10             	cmp    0x10(%ebp),%eax
80102158:	72 0d                	jb     80102167 <writei+0x87>
8010215a:	8b 55 10             	mov    0x10(%ebp),%edx
8010215d:	8b 45 14             	mov    0x14(%ebp),%eax
80102160:	01 d0                	add    %edx,%eax
80102162:	3b 45 10             	cmp    0x10(%ebp),%eax
80102165:	73 0a                	jae    80102171 <writei+0x91>
    return -1;
80102167:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010216c:	e9 f5 00 00 00       	jmp    80102266 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
80102171:	8b 55 10             	mov    0x10(%ebp),%edx
80102174:	8b 45 14             	mov    0x14(%ebp),%eax
80102177:	01 d0                	add    %edx,%eax
80102179:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010217e:	76 0a                	jbe    8010218a <writei+0xaa>
    return -1;
80102180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102185:	e9 dc 00 00 00       	jmp    80102266 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010218a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102191:	e9 99 00 00 00       	jmp    8010222f <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102196:	8b 45 10             	mov    0x10(%ebp),%eax
80102199:	c1 e8 09             	shr    $0x9,%eax
8010219c:	83 ec 08             	sub    $0x8,%esp
8010219f:	50                   	push   %eax
801021a0:	ff 75 08             	pushl  0x8(%ebp)
801021a3:	e8 58 fb ff ff       	call   80101d00 <bmap>
801021a8:	83 c4 10             	add    $0x10,%esp
801021ab:	89 c2                	mov    %eax,%edx
801021ad:	8b 45 08             	mov    0x8(%ebp),%eax
801021b0:	8b 00                	mov    (%eax),%eax
801021b2:	83 ec 08             	sub    $0x8,%esp
801021b5:	52                   	push   %edx
801021b6:	50                   	push   %eax
801021b7:	e8 fa df ff ff       	call   801001b6 <bread>
801021bc:	83 c4 10             	add    $0x10,%esp
801021bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021c2:	8b 45 10             	mov    0x10(%ebp),%eax
801021c5:	25 ff 01 00 00       	and    $0x1ff,%eax
801021ca:	ba 00 02 00 00       	mov    $0x200,%edx
801021cf:	29 c2                	sub    %eax,%edx
801021d1:	8b 45 14             	mov    0x14(%ebp),%eax
801021d4:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021d7:	39 c2                	cmp    %eax,%edx
801021d9:	0f 46 c2             	cmovbe %edx,%eax
801021dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
801021df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021e2:	8d 50 18             	lea    0x18(%eax),%edx
801021e5:	8b 45 10             	mov    0x10(%ebp),%eax
801021e8:	25 ff 01 00 00       	and    $0x1ff,%eax
801021ed:	01 d0                	add    %edx,%eax
801021ef:	83 ec 04             	sub    $0x4,%esp
801021f2:	ff 75 ec             	pushl  -0x14(%ebp)
801021f5:	ff 75 0c             	pushl  0xc(%ebp)
801021f8:	50                   	push   %eax
801021f9:	e8 99 49 00 00       	call   80106b97 <memmove>
801021fe:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102201:	83 ec 0c             	sub    $0xc,%esp
80102204:	ff 75 f0             	pushl  -0x10(%ebp)
80102207:	e8 2a 16 00 00       	call   80103836 <log_write>
8010220c:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
8010220f:	83 ec 0c             	sub    $0xc,%esp
80102212:	ff 75 f0             	pushl  -0x10(%ebp)
80102215:	e8 14 e0 ff ff       	call   8010022e <brelse>
8010221a:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010221d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102220:	01 45 f4             	add    %eax,-0xc(%ebp)
80102223:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102226:	01 45 10             	add    %eax,0x10(%ebp)
80102229:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010222c:	01 45 0c             	add    %eax,0xc(%ebp)
8010222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102232:	3b 45 14             	cmp    0x14(%ebp),%eax
80102235:	0f 82 5b ff ff ff    	jb     80102196 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010223b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010223f:	74 22                	je     80102263 <writei+0x183>
80102241:	8b 45 08             	mov    0x8(%ebp),%eax
80102244:	8b 40 18             	mov    0x18(%eax),%eax
80102247:	3b 45 10             	cmp    0x10(%ebp),%eax
8010224a:	73 17                	jae    80102263 <writei+0x183>
    ip->size = off;
8010224c:	8b 45 08             	mov    0x8(%ebp),%eax
8010224f:	8b 55 10             	mov    0x10(%ebp),%edx
80102252:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102255:	83 ec 0c             	sub    $0xc,%esp
80102258:	ff 75 08             	pushl  0x8(%ebp)
8010225b:	e8 e1 f5 ff ff       	call   80101841 <iupdate>
80102260:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102263:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102266:	c9                   	leave  
80102267:	c3                   	ret    

80102268 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102268:	55                   	push   %ebp
80102269:	89 e5                	mov    %esp,%ebp
8010226b:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
8010226e:	83 ec 04             	sub    $0x4,%esp
80102271:	6a 0e                	push   $0xe
80102273:	ff 75 0c             	pushl  0xc(%ebp)
80102276:	ff 75 08             	pushl  0x8(%ebp)
80102279:	e8 af 49 00 00       	call   80106c2d <strncmp>
8010227e:	83 c4 10             	add    $0x10,%esp
}
80102281:	c9                   	leave  
80102282:	c3                   	ret    

80102283 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102283:	55                   	push   %ebp
80102284:	89 e5                	mov    %esp,%ebp
80102286:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102289:	8b 45 08             	mov    0x8(%ebp),%eax
8010228c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102290:	66 83 f8 01          	cmp    $0x1,%ax
80102294:	74 0d                	je     801022a3 <dirlookup+0x20>
    panic("dirlookup not DIR");
80102296:	83 ec 0c             	sub    $0xc,%esp
80102299:	68 0b a1 10 80       	push   $0x8010a10b
8010229e:	e8 c3 e2 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801022a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022aa:	eb 7b                	jmp    80102327 <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022ac:	6a 10                	push   $0x10
801022ae:	ff 75 f4             	pushl  -0xc(%ebp)
801022b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022b4:	50                   	push   %eax
801022b5:	ff 75 08             	pushl  0x8(%ebp)
801022b8:	e8 cc fc ff ff       	call   80101f89 <readi>
801022bd:	83 c4 10             	add    $0x10,%esp
801022c0:	83 f8 10             	cmp    $0x10,%eax
801022c3:	74 0d                	je     801022d2 <dirlookup+0x4f>
      panic("dirlink read");
801022c5:	83 ec 0c             	sub    $0xc,%esp
801022c8:	68 1d a1 10 80       	push   $0x8010a11d
801022cd:	e8 94 e2 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801022d2:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801022d6:	66 85 c0             	test   %ax,%ax
801022d9:	74 47                	je     80102322 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
801022db:	83 ec 08             	sub    $0x8,%esp
801022de:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022e1:	83 c0 02             	add    $0x2,%eax
801022e4:	50                   	push   %eax
801022e5:	ff 75 0c             	pushl  0xc(%ebp)
801022e8:	e8 7b ff ff ff       	call   80102268 <namecmp>
801022ed:	83 c4 10             	add    $0x10,%esp
801022f0:	85 c0                	test   %eax,%eax
801022f2:	75 2f                	jne    80102323 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
801022f4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801022f8:	74 08                	je     80102302 <dirlookup+0x7f>
        *poff = off;
801022fa:	8b 45 10             	mov    0x10(%ebp),%eax
801022fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102300:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102302:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102306:	0f b7 c0             	movzwl %ax,%eax
80102309:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010230c:	8b 45 08             	mov    0x8(%ebp),%eax
8010230f:	8b 00                	mov    (%eax),%eax
80102311:	83 ec 08             	sub    $0x8,%esp
80102314:	ff 75 f0             	pushl  -0x10(%ebp)
80102317:	50                   	push   %eax
80102318:	e8 e5 f5 ff ff       	call   80101902 <iget>
8010231d:	83 c4 10             	add    $0x10,%esp
80102320:	eb 19                	jmp    8010233b <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102322:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102323:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102327:	8b 45 08             	mov    0x8(%ebp),%eax
8010232a:	8b 40 18             	mov    0x18(%eax),%eax
8010232d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102330:	0f 87 76 ff ff ff    	ja     801022ac <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102336:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010233b:	c9                   	leave  
8010233c:	c3                   	ret    

8010233d <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
8010233d:	55                   	push   %ebp
8010233e:	89 e5                	mov    %esp,%ebp
80102340:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102343:	83 ec 04             	sub    $0x4,%esp
80102346:	6a 00                	push   $0x0
80102348:	ff 75 0c             	pushl  0xc(%ebp)
8010234b:	ff 75 08             	pushl  0x8(%ebp)
8010234e:	e8 30 ff ff ff       	call   80102283 <dirlookup>
80102353:	83 c4 10             	add    $0x10,%esp
80102356:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102359:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010235d:	74 18                	je     80102377 <dirlink+0x3a>
    iput(ip);
8010235f:	83 ec 0c             	sub    $0xc,%esp
80102362:	ff 75 f0             	pushl  -0x10(%ebp)
80102365:	e8 81 f8 ff ff       	call   80101beb <iput>
8010236a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010236d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102372:	e9 9c 00 00 00       	jmp    80102413 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102377:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010237e:	eb 39                	jmp    801023b9 <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102383:	6a 10                	push   $0x10
80102385:	50                   	push   %eax
80102386:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102389:	50                   	push   %eax
8010238a:	ff 75 08             	pushl  0x8(%ebp)
8010238d:	e8 f7 fb ff ff       	call   80101f89 <readi>
80102392:	83 c4 10             	add    $0x10,%esp
80102395:	83 f8 10             	cmp    $0x10,%eax
80102398:	74 0d                	je     801023a7 <dirlink+0x6a>
      panic("dirlink read");
8010239a:	83 ec 0c             	sub    $0xc,%esp
8010239d:	68 1d a1 10 80       	push   $0x8010a11d
801023a2:	e8 bf e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801023a7:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801023ab:	66 85 c0             	test   %ax,%ax
801023ae:	74 18                	je     801023c8 <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b3:	83 c0 10             	add    $0x10,%eax
801023b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801023b9:	8b 45 08             	mov    0x8(%ebp),%eax
801023bc:	8b 50 18             	mov    0x18(%eax),%edx
801023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c2:	39 c2                	cmp    %eax,%edx
801023c4:	77 ba                	ja     80102380 <dirlink+0x43>
801023c6:	eb 01                	jmp    801023c9 <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801023c8:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801023c9:	83 ec 04             	sub    $0x4,%esp
801023cc:	6a 0e                	push   $0xe
801023ce:	ff 75 0c             	pushl  0xc(%ebp)
801023d1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023d4:	83 c0 02             	add    $0x2,%eax
801023d7:	50                   	push   %eax
801023d8:	e8 a6 48 00 00       	call   80106c83 <strncpy>
801023dd:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
801023e0:	8b 45 10             	mov    0x10(%ebp),%eax
801023e3:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ea:	6a 10                	push   $0x10
801023ec:	50                   	push   %eax
801023ed:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023f0:	50                   	push   %eax
801023f1:	ff 75 08             	pushl  0x8(%ebp)
801023f4:	e8 e7 fc ff ff       	call   801020e0 <writei>
801023f9:	83 c4 10             	add    $0x10,%esp
801023fc:	83 f8 10             	cmp    $0x10,%eax
801023ff:	74 0d                	je     8010240e <dirlink+0xd1>
    panic("dirlink");
80102401:	83 ec 0c             	sub    $0xc,%esp
80102404:	68 2a a1 10 80       	push   $0x8010a12a
80102409:	e8 58 e1 ff ff       	call   80100566 <panic>
  
  return 0;
8010240e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102413:	c9                   	leave  
80102414:	c3                   	ret    

80102415 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102415:	55                   	push   %ebp
80102416:	89 e5                	mov    %esp,%ebp
80102418:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010241b:	eb 04                	jmp    80102421 <skipelem+0xc>
    path++;
8010241d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102421:	8b 45 08             	mov    0x8(%ebp),%eax
80102424:	0f b6 00             	movzbl (%eax),%eax
80102427:	3c 2f                	cmp    $0x2f,%al
80102429:	74 f2                	je     8010241d <skipelem+0x8>
    path++;
  if(*path == 0)
8010242b:	8b 45 08             	mov    0x8(%ebp),%eax
8010242e:	0f b6 00             	movzbl (%eax),%eax
80102431:	84 c0                	test   %al,%al
80102433:	75 07                	jne    8010243c <skipelem+0x27>
    return 0;
80102435:	b8 00 00 00 00       	mov    $0x0,%eax
8010243a:	eb 7b                	jmp    801024b7 <skipelem+0xa2>
  s = path;
8010243c:	8b 45 08             	mov    0x8(%ebp),%eax
8010243f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102442:	eb 04                	jmp    80102448 <skipelem+0x33>
    path++;
80102444:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102448:	8b 45 08             	mov    0x8(%ebp),%eax
8010244b:	0f b6 00             	movzbl (%eax),%eax
8010244e:	3c 2f                	cmp    $0x2f,%al
80102450:	74 0a                	je     8010245c <skipelem+0x47>
80102452:	8b 45 08             	mov    0x8(%ebp),%eax
80102455:	0f b6 00             	movzbl (%eax),%eax
80102458:	84 c0                	test   %al,%al
8010245a:	75 e8                	jne    80102444 <skipelem+0x2f>
    path++;
  len = path - s;
8010245c:	8b 55 08             	mov    0x8(%ebp),%edx
8010245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102462:	29 c2                	sub    %eax,%edx
80102464:	89 d0                	mov    %edx,%eax
80102466:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102469:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010246d:	7e 15                	jle    80102484 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
8010246f:	83 ec 04             	sub    $0x4,%esp
80102472:	6a 0e                	push   $0xe
80102474:	ff 75 f4             	pushl  -0xc(%ebp)
80102477:	ff 75 0c             	pushl  0xc(%ebp)
8010247a:	e8 18 47 00 00       	call   80106b97 <memmove>
8010247f:	83 c4 10             	add    $0x10,%esp
80102482:	eb 26                	jmp    801024aa <skipelem+0x95>
  else {
    memmove(name, s, len);
80102484:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102487:	83 ec 04             	sub    $0x4,%esp
8010248a:	50                   	push   %eax
8010248b:	ff 75 f4             	pushl  -0xc(%ebp)
8010248e:	ff 75 0c             	pushl  0xc(%ebp)
80102491:	e8 01 47 00 00       	call   80106b97 <memmove>
80102496:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
80102499:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010249c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010249f:	01 d0                	add    %edx,%eax
801024a1:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801024a4:	eb 04                	jmp    801024aa <skipelem+0x95>
    path++;
801024a6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801024aa:	8b 45 08             	mov    0x8(%ebp),%eax
801024ad:	0f b6 00             	movzbl (%eax),%eax
801024b0:	3c 2f                	cmp    $0x2f,%al
801024b2:	74 f2                	je     801024a6 <skipelem+0x91>
    path++;
  return path;
801024b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
801024b7:	c9                   	leave  
801024b8:	c3                   	ret    

801024b9 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801024b9:	55                   	push   %ebp
801024ba:	89 e5                	mov    %esp,%ebp
801024bc:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801024bf:	8b 45 08             	mov    0x8(%ebp),%eax
801024c2:	0f b6 00             	movzbl (%eax),%eax
801024c5:	3c 2f                	cmp    $0x2f,%al
801024c7:	75 17                	jne    801024e0 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801024c9:	83 ec 08             	sub    $0x8,%esp
801024cc:	6a 01                	push   $0x1
801024ce:	6a 01                	push   $0x1
801024d0:	e8 2d f4 ff ff       	call   80101902 <iget>
801024d5:	83 c4 10             	add    $0x10,%esp
801024d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024db:	e9 bb 00 00 00       	jmp    8010259b <namex+0xe2>
  else
    ip = idup(proc->cwd);
801024e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801024e6:	8b 40 68             	mov    0x68(%eax),%eax
801024e9:	83 ec 0c             	sub    $0xc,%esp
801024ec:	50                   	push   %eax
801024ed:	e8 ef f4 ff ff       	call   801019e1 <idup>
801024f2:	83 c4 10             	add    $0x10,%esp
801024f5:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
801024f8:	e9 9e 00 00 00       	jmp    8010259b <namex+0xe2>
    ilock(ip);
801024fd:	83 ec 0c             	sub    $0xc,%esp
80102500:	ff 75 f4             	pushl  -0xc(%ebp)
80102503:	e8 13 f5 ff ff       	call   80101a1b <ilock>
80102508:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010250b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010250e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102512:	66 83 f8 01          	cmp    $0x1,%ax
80102516:	74 18                	je     80102530 <namex+0x77>
      iunlockput(ip);
80102518:	83 ec 0c             	sub    $0xc,%esp
8010251b:	ff 75 f4             	pushl  -0xc(%ebp)
8010251e:	e8 b8 f7 ff ff       	call   80101cdb <iunlockput>
80102523:	83 c4 10             	add    $0x10,%esp
      return 0;
80102526:	b8 00 00 00 00       	mov    $0x0,%eax
8010252b:	e9 a7 00 00 00       	jmp    801025d7 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102530:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102534:	74 20                	je     80102556 <namex+0x9d>
80102536:	8b 45 08             	mov    0x8(%ebp),%eax
80102539:	0f b6 00             	movzbl (%eax),%eax
8010253c:	84 c0                	test   %al,%al
8010253e:	75 16                	jne    80102556 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102540:	83 ec 0c             	sub    $0xc,%esp
80102543:	ff 75 f4             	pushl  -0xc(%ebp)
80102546:	e8 2e f6 ff ff       	call   80101b79 <iunlock>
8010254b:	83 c4 10             	add    $0x10,%esp
      return ip;
8010254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102551:	e9 81 00 00 00       	jmp    801025d7 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102556:	83 ec 04             	sub    $0x4,%esp
80102559:	6a 00                	push   $0x0
8010255b:	ff 75 10             	pushl  0x10(%ebp)
8010255e:	ff 75 f4             	pushl  -0xc(%ebp)
80102561:	e8 1d fd ff ff       	call   80102283 <dirlookup>
80102566:	83 c4 10             	add    $0x10,%esp
80102569:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010256c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102570:	75 15                	jne    80102587 <namex+0xce>
      iunlockput(ip);
80102572:	83 ec 0c             	sub    $0xc,%esp
80102575:	ff 75 f4             	pushl  -0xc(%ebp)
80102578:	e8 5e f7 ff ff       	call   80101cdb <iunlockput>
8010257d:	83 c4 10             	add    $0x10,%esp
      return 0;
80102580:	b8 00 00 00 00       	mov    $0x0,%eax
80102585:	eb 50                	jmp    801025d7 <namex+0x11e>
    }
    iunlockput(ip);
80102587:	83 ec 0c             	sub    $0xc,%esp
8010258a:	ff 75 f4             	pushl  -0xc(%ebp)
8010258d:	e8 49 f7 ff ff       	call   80101cdb <iunlockput>
80102592:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102595:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102598:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010259b:	83 ec 08             	sub    $0x8,%esp
8010259e:	ff 75 10             	pushl  0x10(%ebp)
801025a1:	ff 75 08             	pushl  0x8(%ebp)
801025a4:	e8 6c fe ff ff       	call   80102415 <skipelem>
801025a9:	83 c4 10             	add    $0x10,%esp
801025ac:	89 45 08             	mov    %eax,0x8(%ebp)
801025af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025b3:	0f 85 44 ff ff ff    	jne    801024fd <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801025b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801025bd:	74 15                	je     801025d4 <namex+0x11b>
    iput(ip);
801025bf:	83 ec 0c             	sub    $0xc,%esp
801025c2:	ff 75 f4             	pushl  -0xc(%ebp)
801025c5:	e8 21 f6 ff ff       	call   80101beb <iput>
801025ca:	83 c4 10             	add    $0x10,%esp
    return 0;
801025cd:	b8 00 00 00 00       	mov    $0x0,%eax
801025d2:	eb 03                	jmp    801025d7 <namex+0x11e>
  }
  return ip;
801025d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801025d7:	c9                   	leave  
801025d8:	c3                   	ret    

801025d9 <namei>:

struct inode*
namei(char *path)
{
801025d9:	55                   	push   %ebp
801025da:	89 e5                	mov    %esp,%ebp
801025dc:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
801025df:	83 ec 04             	sub    $0x4,%esp
801025e2:	8d 45 ea             	lea    -0x16(%ebp),%eax
801025e5:	50                   	push   %eax
801025e6:	6a 00                	push   $0x0
801025e8:	ff 75 08             	pushl  0x8(%ebp)
801025eb:	e8 c9 fe ff ff       	call   801024b9 <namex>
801025f0:	83 c4 10             	add    $0x10,%esp
}
801025f3:	c9                   	leave  
801025f4:	c3                   	ret    

801025f5 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801025f5:	55                   	push   %ebp
801025f6:	89 e5                	mov    %esp,%ebp
801025f8:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
801025fb:	83 ec 04             	sub    $0x4,%esp
801025fe:	ff 75 0c             	pushl  0xc(%ebp)
80102601:	6a 01                	push   $0x1
80102603:	ff 75 08             	pushl  0x8(%ebp)
80102606:	e8 ae fe ff ff       	call   801024b9 <namex>
8010260b:	83 c4 10             	add    $0x10,%esp
}
8010260e:	c9                   	leave  
8010260f:	c3                   	ret    

80102610 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	83 ec 14             	sub    $0x14,%esp
80102616:	8b 45 08             	mov    0x8(%ebp),%eax
80102619:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010261d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102621:	89 c2                	mov    %eax,%edx
80102623:	ec                   	in     (%dx),%al
80102624:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102627:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010262b:	c9                   	leave  
8010262c:	c3                   	ret    

8010262d <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010262d:	55                   	push   %ebp
8010262e:	89 e5                	mov    %esp,%ebp
80102630:	57                   	push   %edi
80102631:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102632:	8b 55 08             	mov    0x8(%ebp),%edx
80102635:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102638:	8b 45 10             	mov    0x10(%ebp),%eax
8010263b:	89 cb                	mov    %ecx,%ebx
8010263d:	89 df                	mov    %ebx,%edi
8010263f:	89 c1                	mov    %eax,%ecx
80102641:	fc                   	cld    
80102642:	f3 6d                	rep insl (%dx),%es:(%edi)
80102644:	89 c8                	mov    %ecx,%eax
80102646:	89 fb                	mov    %edi,%ebx
80102648:	89 5d 0c             	mov    %ebx,0xc(%ebp)
8010264b:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010264e:	90                   	nop
8010264f:	5b                   	pop    %ebx
80102650:	5f                   	pop    %edi
80102651:	5d                   	pop    %ebp
80102652:	c3                   	ret    

80102653 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102653:	55                   	push   %ebp
80102654:	89 e5                	mov    %esp,%ebp
80102656:	83 ec 08             	sub    $0x8,%esp
80102659:	8b 55 08             	mov    0x8(%ebp),%edx
8010265c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010265f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102663:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102666:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010266a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010266e:	ee                   	out    %al,(%dx)
}
8010266f:	90                   	nop
80102670:	c9                   	leave  
80102671:	c3                   	ret    

80102672 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102672:	55                   	push   %ebp
80102673:	89 e5                	mov    %esp,%ebp
80102675:	56                   	push   %esi
80102676:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102677:	8b 55 08             	mov    0x8(%ebp),%edx
8010267a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010267d:	8b 45 10             	mov    0x10(%ebp),%eax
80102680:	89 cb                	mov    %ecx,%ebx
80102682:	89 de                	mov    %ebx,%esi
80102684:	89 c1                	mov    %eax,%ecx
80102686:	fc                   	cld    
80102687:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102689:	89 c8                	mov    %ecx,%eax
8010268b:	89 f3                	mov    %esi,%ebx
8010268d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102690:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102693:	90                   	nop
80102694:	5b                   	pop    %ebx
80102695:	5e                   	pop    %esi
80102696:	5d                   	pop    %ebp
80102697:	c3                   	ret    

80102698 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102698:	55                   	push   %ebp
80102699:	89 e5                	mov    %esp,%ebp
8010269b:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010269e:	90                   	nop
8010269f:	68 f7 01 00 00       	push   $0x1f7
801026a4:	e8 67 ff ff ff       	call   80102610 <inb>
801026a9:	83 c4 04             	add    $0x4,%esp
801026ac:	0f b6 c0             	movzbl %al,%eax
801026af:	89 45 fc             	mov    %eax,-0x4(%ebp)
801026b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026b5:	25 c0 00 00 00       	and    $0xc0,%eax
801026ba:	83 f8 40             	cmp    $0x40,%eax
801026bd:	75 e0                	jne    8010269f <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801026bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026c3:	74 11                	je     801026d6 <idewait+0x3e>
801026c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801026c8:	83 e0 21             	and    $0x21,%eax
801026cb:	85 c0                	test   %eax,%eax
801026cd:	74 07                	je     801026d6 <idewait+0x3e>
    return -1;
801026cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801026d4:	eb 05                	jmp    801026db <idewait+0x43>
  return 0;
801026d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801026db:	c9                   	leave  
801026dc:	c3                   	ret    

801026dd <ideinit>:

void
ideinit(void)
{
801026dd:	55                   	push   %ebp
801026de:	89 e5                	mov    %esp,%ebp
801026e0:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
801026e3:	83 ec 08             	sub    $0x8,%esp
801026e6:	68 32 a1 10 80       	push   $0x8010a132
801026eb:	68 20 d6 10 80       	push   $0x8010d620
801026f0:	e8 5e 41 00 00       	call   80106853 <initlock>
801026f5:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
801026f8:	83 ec 0c             	sub    $0xc,%esp
801026fb:	6a 0e                	push   $0xe
801026fd:	e8 da 18 00 00       	call   80103fdc <picenable>
80102702:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102705:	a1 60 49 11 80       	mov    0x80114960,%eax
8010270a:	83 e8 01             	sub    $0x1,%eax
8010270d:	83 ec 08             	sub    $0x8,%esp
80102710:	50                   	push   %eax
80102711:	6a 0e                	push   $0xe
80102713:	e8 73 04 00 00       	call   80102b8b <ioapicenable>
80102718:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010271b:	83 ec 0c             	sub    $0xc,%esp
8010271e:	6a 00                	push   $0x0
80102720:	e8 73 ff ff ff       	call   80102698 <idewait>
80102725:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102728:	83 ec 08             	sub    $0x8,%esp
8010272b:	68 f0 00 00 00       	push   $0xf0
80102730:	68 f6 01 00 00       	push   $0x1f6
80102735:	e8 19 ff ff ff       	call   80102653 <outb>
8010273a:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
8010273d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102744:	eb 24                	jmp    8010276a <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102746:	83 ec 0c             	sub    $0xc,%esp
80102749:	68 f7 01 00 00       	push   $0x1f7
8010274e:	e8 bd fe ff ff       	call   80102610 <inb>
80102753:	83 c4 10             	add    $0x10,%esp
80102756:	84 c0                	test   %al,%al
80102758:	74 0c                	je     80102766 <ideinit+0x89>
      havedisk1 = 1;
8010275a:	c7 05 58 d6 10 80 01 	movl   $0x1,0x8010d658
80102761:	00 00 00 
      break;
80102764:	eb 0d                	jmp    80102773 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102766:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010276a:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102771:	7e d3                	jle    80102746 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102773:	83 ec 08             	sub    $0x8,%esp
80102776:	68 e0 00 00 00       	push   $0xe0
8010277b:	68 f6 01 00 00       	push   $0x1f6
80102780:	e8 ce fe ff ff       	call   80102653 <outb>
80102785:	83 c4 10             	add    $0x10,%esp
}
80102788:	90                   	nop
80102789:	c9                   	leave  
8010278a:	c3                   	ret    

8010278b <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010278b:	55                   	push   %ebp
8010278c:	89 e5                	mov    %esp,%ebp
8010278e:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102791:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102795:	75 0d                	jne    801027a4 <idestart+0x19>
    panic("idestart");
80102797:	83 ec 0c             	sub    $0xc,%esp
8010279a:	68 36 a1 10 80       	push   $0x8010a136
8010279f:	e8 c2 dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
801027a4:	8b 45 08             	mov    0x8(%ebp),%eax
801027a7:	8b 40 08             	mov    0x8(%eax),%eax
801027aa:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801027af:	76 0d                	jbe    801027be <idestart+0x33>
    panic("incorrect blockno");
801027b1:	83 ec 0c             	sub    $0xc,%esp
801027b4:	68 3f a1 10 80       	push   $0x8010a13f
801027b9:	e8 a8 dd ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
801027be:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
801027c5:	8b 45 08             	mov    0x8(%ebp),%eax
801027c8:	8b 50 08             	mov    0x8(%eax),%edx
801027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027ce:	0f af c2             	imul   %edx,%eax
801027d1:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
801027d4:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801027d8:	7e 0d                	jle    801027e7 <idestart+0x5c>
801027da:	83 ec 0c             	sub    $0xc,%esp
801027dd:	68 36 a1 10 80       	push   $0x8010a136
801027e2:	e8 7f dd ff ff       	call   80100566 <panic>
  
  idewait(0);
801027e7:	83 ec 0c             	sub    $0xc,%esp
801027ea:	6a 00                	push   $0x0
801027ec:	e8 a7 fe ff ff       	call   80102698 <idewait>
801027f1:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
801027f4:	83 ec 08             	sub    $0x8,%esp
801027f7:	6a 00                	push   $0x0
801027f9:	68 f6 03 00 00       	push   $0x3f6
801027fe:	e8 50 fe ff ff       	call   80102653 <outb>
80102803:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102806:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102809:	0f b6 c0             	movzbl %al,%eax
8010280c:	83 ec 08             	sub    $0x8,%esp
8010280f:	50                   	push   %eax
80102810:	68 f2 01 00 00       	push   $0x1f2
80102815:	e8 39 fe ff ff       	call   80102653 <outb>
8010281a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
8010281d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102820:	0f b6 c0             	movzbl %al,%eax
80102823:	83 ec 08             	sub    $0x8,%esp
80102826:	50                   	push   %eax
80102827:	68 f3 01 00 00       	push   $0x1f3
8010282c:	e8 22 fe ff ff       	call   80102653 <outb>
80102831:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102834:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102837:	c1 f8 08             	sar    $0x8,%eax
8010283a:	0f b6 c0             	movzbl %al,%eax
8010283d:	83 ec 08             	sub    $0x8,%esp
80102840:	50                   	push   %eax
80102841:	68 f4 01 00 00       	push   $0x1f4
80102846:	e8 08 fe ff ff       	call   80102653 <outb>
8010284b:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
8010284e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102851:	c1 f8 10             	sar    $0x10,%eax
80102854:	0f b6 c0             	movzbl %al,%eax
80102857:	83 ec 08             	sub    $0x8,%esp
8010285a:	50                   	push   %eax
8010285b:	68 f5 01 00 00       	push   $0x1f5
80102860:	e8 ee fd ff ff       	call   80102653 <outb>
80102865:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102868:	8b 45 08             	mov    0x8(%ebp),%eax
8010286b:	8b 40 04             	mov    0x4(%eax),%eax
8010286e:	83 e0 01             	and    $0x1,%eax
80102871:	c1 e0 04             	shl    $0x4,%eax
80102874:	89 c2                	mov    %eax,%edx
80102876:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102879:	c1 f8 18             	sar    $0x18,%eax
8010287c:	83 e0 0f             	and    $0xf,%eax
8010287f:	09 d0                	or     %edx,%eax
80102881:	83 c8 e0             	or     $0xffffffe0,%eax
80102884:	0f b6 c0             	movzbl %al,%eax
80102887:	83 ec 08             	sub    $0x8,%esp
8010288a:	50                   	push   %eax
8010288b:	68 f6 01 00 00       	push   $0x1f6
80102890:	e8 be fd ff ff       	call   80102653 <outb>
80102895:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102898:	8b 45 08             	mov    0x8(%ebp),%eax
8010289b:	8b 00                	mov    (%eax),%eax
8010289d:	83 e0 04             	and    $0x4,%eax
801028a0:	85 c0                	test   %eax,%eax
801028a2:	74 30                	je     801028d4 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
801028a4:	83 ec 08             	sub    $0x8,%esp
801028a7:	6a 30                	push   $0x30
801028a9:	68 f7 01 00 00       	push   $0x1f7
801028ae:	e8 a0 fd ff ff       	call   80102653 <outb>
801028b3:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
801028b6:	8b 45 08             	mov    0x8(%ebp),%eax
801028b9:	83 c0 18             	add    $0x18,%eax
801028bc:	83 ec 04             	sub    $0x4,%esp
801028bf:	68 80 00 00 00       	push   $0x80
801028c4:	50                   	push   %eax
801028c5:	68 f0 01 00 00       	push   $0x1f0
801028ca:	e8 a3 fd ff ff       	call   80102672 <outsl>
801028cf:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
801028d2:	eb 12                	jmp    801028e6 <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
801028d4:	83 ec 08             	sub    $0x8,%esp
801028d7:	6a 20                	push   $0x20
801028d9:	68 f7 01 00 00       	push   $0x1f7
801028de:	e8 70 fd ff ff       	call   80102653 <outb>
801028e3:	83 c4 10             	add    $0x10,%esp
  }
}
801028e6:	90                   	nop
801028e7:	c9                   	leave  
801028e8:	c3                   	ret    

801028e9 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801028e9:	55                   	push   %ebp
801028ea:	89 e5                	mov    %esp,%ebp
801028ec:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801028ef:	83 ec 0c             	sub    $0xc,%esp
801028f2:	68 20 d6 10 80       	push   $0x8010d620
801028f7:	e8 79 3f 00 00       	call   80106875 <acquire>
801028fc:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028ff:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102904:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010290b:	75 15                	jne    80102922 <ideintr+0x39>
    release(&idelock);
8010290d:	83 ec 0c             	sub    $0xc,%esp
80102910:	68 20 d6 10 80       	push   $0x8010d620
80102915:	e8 c2 3f 00 00       	call   801068dc <release>
8010291a:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
8010291d:	e9 9a 00 00 00       	jmp    801029bc <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102922:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102925:	8b 40 14             	mov    0x14(%eax),%eax
80102928:	a3 54 d6 10 80       	mov    %eax,0x8010d654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102930:	8b 00                	mov    (%eax),%eax
80102932:	83 e0 04             	and    $0x4,%eax
80102935:	85 c0                	test   %eax,%eax
80102937:	75 2d                	jne    80102966 <ideintr+0x7d>
80102939:	83 ec 0c             	sub    $0xc,%esp
8010293c:	6a 01                	push   $0x1
8010293e:	e8 55 fd ff ff       	call   80102698 <idewait>
80102943:	83 c4 10             	add    $0x10,%esp
80102946:	85 c0                	test   %eax,%eax
80102948:	78 1c                	js     80102966 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
8010294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010294d:	83 c0 18             	add    $0x18,%eax
80102950:	83 ec 04             	sub    $0x4,%esp
80102953:	68 80 00 00 00       	push   $0x80
80102958:	50                   	push   %eax
80102959:	68 f0 01 00 00       	push   $0x1f0
8010295e:	e8 ca fc ff ff       	call   8010262d <insl>
80102963:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102966:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102969:	8b 00                	mov    (%eax),%eax
8010296b:	83 c8 02             	or     $0x2,%eax
8010296e:	89 c2                	mov    %eax,%edx
80102970:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102973:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102975:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102978:	8b 00                	mov    (%eax),%eax
8010297a:	83 e0 fb             	and    $0xfffffffb,%eax
8010297d:	89 c2                	mov    %eax,%edx
8010297f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102982:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102984:	83 ec 0c             	sub    $0xc,%esp
80102987:	ff 75 f4             	pushl  -0xc(%ebp)
8010298a:	e8 58 2e 00 00       	call   801057e7 <wakeup>
8010298f:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102992:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102997:	85 c0                	test   %eax,%eax
80102999:	74 11                	je     801029ac <ideintr+0xc3>
    idestart(idequeue);
8010299b:	a1 54 d6 10 80       	mov    0x8010d654,%eax
801029a0:	83 ec 0c             	sub    $0xc,%esp
801029a3:	50                   	push   %eax
801029a4:	e8 e2 fd ff ff       	call   8010278b <idestart>
801029a9:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
801029ac:	83 ec 0c             	sub    $0xc,%esp
801029af:	68 20 d6 10 80       	push   $0x8010d620
801029b4:	e8 23 3f 00 00       	call   801068dc <release>
801029b9:	83 c4 10             	add    $0x10,%esp
}
801029bc:	c9                   	leave  
801029bd:	c3                   	ret    

801029be <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801029be:	55                   	push   %ebp
801029bf:	89 e5                	mov    %esp,%ebp
801029c1:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801029c4:	8b 45 08             	mov    0x8(%ebp),%eax
801029c7:	8b 00                	mov    (%eax),%eax
801029c9:	83 e0 01             	and    $0x1,%eax
801029cc:	85 c0                	test   %eax,%eax
801029ce:	75 0d                	jne    801029dd <iderw+0x1f>
    panic("iderw: buf not busy");
801029d0:	83 ec 0c             	sub    $0xc,%esp
801029d3:	68 51 a1 10 80       	push   $0x8010a151
801029d8:	e8 89 db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029dd:	8b 45 08             	mov    0x8(%ebp),%eax
801029e0:	8b 00                	mov    (%eax),%eax
801029e2:	83 e0 06             	and    $0x6,%eax
801029e5:	83 f8 02             	cmp    $0x2,%eax
801029e8:	75 0d                	jne    801029f7 <iderw+0x39>
    panic("iderw: nothing to do");
801029ea:	83 ec 0c             	sub    $0xc,%esp
801029ed:	68 65 a1 10 80       	push   $0x8010a165
801029f2:	e8 6f db ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
801029f7:	8b 45 08             	mov    0x8(%ebp),%eax
801029fa:	8b 40 04             	mov    0x4(%eax),%eax
801029fd:	85 c0                	test   %eax,%eax
801029ff:	74 16                	je     80102a17 <iderw+0x59>
80102a01:	a1 58 d6 10 80       	mov    0x8010d658,%eax
80102a06:	85 c0                	test   %eax,%eax
80102a08:	75 0d                	jne    80102a17 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102a0a:	83 ec 0c             	sub    $0xc,%esp
80102a0d:	68 7a a1 10 80       	push   $0x8010a17a
80102a12:	e8 4f db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a17:	83 ec 0c             	sub    $0xc,%esp
80102a1a:	68 20 d6 10 80       	push   $0x8010d620
80102a1f:	e8 51 3e 00 00       	call   80106875 <acquire>
80102a24:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102a27:	8b 45 08             	mov    0x8(%ebp),%eax
80102a2a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102a31:	c7 45 f4 54 d6 10 80 	movl   $0x8010d654,-0xc(%ebp)
80102a38:	eb 0b                	jmp    80102a45 <iderw+0x87>
80102a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a3d:	8b 00                	mov    (%eax),%eax
80102a3f:	83 c0 14             	add    $0x14,%eax
80102a42:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a48:	8b 00                	mov    (%eax),%eax
80102a4a:	85 c0                	test   %eax,%eax
80102a4c:	75 ec                	jne    80102a3a <iderw+0x7c>
    ;
  *pp = b;
80102a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a51:	8b 55 08             	mov    0x8(%ebp),%edx
80102a54:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102a56:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102a5b:	3b 45 08             	cmp    0x8(%ebp),%eax
80102a5e:	75 23                	jne    80102a83 <iderw+0xc5>
    idestart(b);
80102a60:	83 ec 0c             	sub    $0xc,%esp
80102a63:	ff 75 08             	pushl  0x8(%ebp)
80102a66:	e8 20 fd ff ff       	call   8010278b <idestart>
80102a6b:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a6e:	eb 13                	jmp    80102a83 <iderw+0xc5>
    sleep(b, &idelock);
80102a70:	83 ec 08             	sub    $0x8,%esp
80102a73:	68 20 d6 10 80       	push   $0x8010d620
80102a78:	ff 75 08             	pushl  0x8(%ebp)
80102a7b:	e8 0c 2b 00 00       	call   8010558c <sleep>
80102a80:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102a83:	8b 45 08             	mov    0x8(%ebp),%eax
80102a86:	8b 00                	mov    (%eax),%eax
80102a88:	83 e0 06             	and    $0x6,%eax
80102a8b:	83 f8 02             	cmp    $0x2,%eax
80102a8e:	75 e0                	jne    80102a70 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102a90:	83 ec 0c             	sub    $0xc,%esp
80102a93:	68 20 d6 10 80       	push   $0x8010d620
80102a98:	e8 3f 3e 00 00       	call   801068dc <release>
80102a9d:	83 c4 10             	add    $0x10,%esp
}
80102aa0:	90                   	nop
80102aa1:	c9                   	leave  
80102aa2:	c3                   	ret    

80102aa3 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102aa3:	55                   	push   %ebp
80102aa4:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102aa6:	a1 34 42 11 80       	mov    0x80114234,%eax
80102aab:	8b 55 08             	mov    0x8(%ebp),%edx
80102aae:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102ab0:	a1 34 42 11 80       	mov    0x80114234,%eax
80102ab5:	8b 40 10             	mov    0x10(%eax),%eax
}
80102ab8:	5d                   	pop    %ebp
80102ab9:	c3                   	ret    

80102aba <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102aba:	55                   	push   %ebp
80102abb:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102abd:	a1 34 42 11 80       	mov    0x80114234,%eax
80102ac2:	8b 55 08             	mov    0x8(%ebp),%edx
80102ac5:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102ac7:	a1 34 42 11 80       	mov    0x80114234,%eax
80102acc:	8b 55 0c             	mov    0xc(%ebp),%edx
80102acf:	89 50 10             	mov    %edx,0x10(%eax)
}
80102ad2:	90                   	nop
80102ad3:	5d                   	pop    %ebp
80102ad4:	c3                   	ret    

80102ad5 <ioapicinit>:

void
ioapicinit(void)
{
80102ad5:	55                   	push   %ebp
80102ad6:	89 e5                	mov    %esp,%ebp
80102ad8:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102adb:	a1 64 43 11 80       	mov    0x80114364,%eax
80102ae0:	85 c0                	test   %eax,%eax
80102ae2:	0f 84 a0 00 00 00    	je     80102b88 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102ae8:	c7 05 34 42 11 80 00 	movl   $0xfec00000,0x80114234
80102aef:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102af2:	6a 01                	push   $0x1
80102af4:	e8 aa ff ff ff       	call   80102aa3 <ioapicread>
80102af9:	83 c4 04             	add    $0x4,%esp
80102afc:	c1 e8 10             	shr    $0x10,%eax
80102aff:	25 ff 00 00 00       	and    $0xff,%eax
80102b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102b07:	6a 00                	push   $0x0
80102b09:	e8 95 ff ff ff       	call   80102aa3 <ioapicread>
80102b0e:	83 c4 04             	add    $0x4,%esp
80102b11:	c1 e8 18             	shr    $0x18,%eax
80102b14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102b17:	0f b6 05 60 43 11 80 	movzbl 0x80114360,%eax
80102b1e:	0f b6 c0             	movzbl %al,%eax
80102b21:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102b24:	74 10                	je     80102b36 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102b26:	83 ec 0c             	sub    $0xc,%esp
80102b29:	68 98 a1 10 80       	push   $0x8010a198
80102b2e:	e8 93 d8 ff ff       	call   801003c6 <cprintf>
80102b33:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102b3d:	eb 3f                	jmp    80102b7e <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b42:	83 c0 20             	add    $0x20,%eax
80102b45:	0d 00 00 01 00       	or     $0x10000,%eax
80102b4a:	89 c2                	mov    %eax,%edx
80102b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b4f:	83 c0 08             	add    $0x8,%eax
80102b52:	01 c0                	add    %eax,%eax
80102b54:	83 ec 08             	sub    $0x8,%esp
80102b57:	52                   	push   %edx
80102b58:	50                   	push   %eax
80102b59:	e8 5c ff ff ff       	call   80102aba <ioapicwrite>
80102b5e:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b64:	83 c0 08             	add    $0x8,%eax
80102b67:	01 c0                	add    %eax,%eax
80102b69:	83 c0 01             	add    $0x1,%eax
80102b6c:	83 ec 08             	sub    $0x8,%esp
80102b6f:	6a 00                	push   $0x0
80102b71:	50                   	push   %eax
80102b72:	e8 43 ff ff ff       	call   80102aba <ioapicwrite>
80102b77:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102b7a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b81:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102b84:	7e b9                	jle    80102b3f <ioapicinit+0x6a>
80102b86:	eb 01                	jmp    80102b89 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102b88:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102b89:	c9                   	leave  
80102b8a:	c3                   	ret    

80102b8b <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102b8b:	55                   	push   %ebp
80102b8c:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102b8e:	a1 64 43 11 80       	mov    0x80114364,%eax
80102b93:	85 c0                	test   %eax,%eax
80102b95:	74 39                	je     80102bd0 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102b97:	8b 45 08             	mov    0x8(%ebp),%eax
80102b9a:	83 c0 20             	add    $0x20,%eax
80102b9d:	89 c2                	mov    %eax,%edx
80102b9f:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba2:	83 c0 08             	add    $0x8,%eax
80102ba5:	01 c0                	add    %eax,%eax
80102ba7:	52                   	push   %edx
80102ba8:	50                   	push   %eax
80102ba9:	e8 0c ff ff ff       	call   80102aba <ioapicwrite>
80102bae:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
80102bb4:	c1 e0 18             	shl    $0x18,%eax
80102bb7:	89 c2                	mov    %eax,%edx
80102bb9:	8b 45 08             	mov    0x8(%ebp),%eax
80102bbc:	83 c0 08             	add    $0x8,%eax
80102bbf:	01 c0                	add    %eax,%eax
80102bc1:	83 c0 01             	add    $0x1,%eax
80102bc4:	52                   	push   %edx
80102bc5:	50                   	push   %eax
80102bc6:	e8 ef fe ff ff       	call   80102aba <ioapicwrite>
80102bcb:	83 c4 08             	add    $0x8,%esp
80102bce:	eb 01                	jmp    80102bd1 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102bd0:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102bd1:	c9                   	leave  
80102bd2:	c3                   	ret    

80102bd3 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102bd3:	55                   	push   %ebp
80102bd4:	89 e5                	mov    %esp,%ebp
80102bd6:	8b 45 08             	mov    0x8(%ebp),%eax
80102bd9:	05 00 00 00 80       	add    $0x80000000,%eax
80102bde:	5d                   	pop    %ebp
80102bdf:	c3                   	ret    

80102be0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102be0:	55                   	push   %ebp
80102be1:	89 e5                	mov    %esp,%ebp
80102be3:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102be6:	83 ec 08             	sub    $0x8,%esp
80102be9:	68 ca a1 10 80       	push   $0x8010a1ca
80102bee:	68 40 42 11 80       	push   $0x80114240
80102bf3:	e8 5b 3c 00 00       	call   80106853 <initlock>
80102bf8:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102bfb:	c7 05 74 42 11 80 00 	movl   $0x0,0x80114274
80102c02:	00 00 00 
  freerange(vstart, vend);
80102c05:	83 ec 08             	sub    $0x8,%esp
80102c08:	ff 75 0c             	pushl  0xc(%ebp)
80102c0b:	ff 75 08             	pushl  0x8(%ebp)
80102c0e:	e8 2a 00 00 00       	call   80102c3d <freerange>
80102c13:	83 c4 10             	add    $0x10,%esp
}
80102c16:	90                   	nop
80102c17:	c9                   	leave  
80102c18:	c3                   	ret    

80102c19 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102c19:	55                   	push   %ebp
80102c1a:	89 e5                	mov    %esp,%ebp
80102c1c:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102c1f:	83 ec 08             	sub    $0x8,%esp
80102c22:	ff 75 0c             	pushl  0xc(%ebp)
80102c25:	ff 75 08             	pushl  0x8(%ebp)
80102c28:	e8 10 00 00 00       	call   80102c3d <freerange>
80102c2d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102c30:	c7 05 74 42 11 80 01 	movl   $0x1,0x80114274
80102c37:	00 00 00 
}
80102c3a:	90                   	nop
80102c3b:	c9                   	leave  
80102c3c:	c3                   	ret    

80102c3d <freerange>:

void
freerange(void *vstart, void *vend)
{
80102c3d:	55                   	push   %ebp
80102c3e:	89 e5                	mov    %esp,%ebp
80102c40:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102c43:	8b 45 08             	mov    0x8(%ebp),%eax
80102c46:	05 ff 0f 00 00       	add    $0xfff,%eax
80102c4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102c50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c53:	eb 15                	jmp    80102c6a <freerange+0x2d>
    kfree(p);
80102c55:	83 ec 0c             	sub    $0xc,%esp
80102c58:	ff 75 f4             	pushl  -0xc(%ebp)
80102c5b:	e8 1a 00 00 00       	call   80102c7a <kfree>
80102c60:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102c63:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c6d:	05 00 10 00 00       	add    $0x1000,%eax
80102c72:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102c75:	76 de                	jbe    80102c55 <freerange+0x18>
    kfree(p);
}
80102c77:	90                   	nop
80102c78:	c9                   	leave  
80102c79:	c3                   	ret    

80102c7a <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102c7a:	55                   	push   %ebp
80102c7b:	89 e5                	mov    %esp,%ebp
80102c7d:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102c80:	8b 45 08             	mov    0x8(%ebp),%eax
80102c83:	25 ff 0f 00 00       	and    $0xfff,%eax
80102c88:	85 c0                	test   %eax,%eax
80102c8a:	75 1b                	jne    80102ca7 <kfree+0x2d>
80102c8c:	81 7d 08 3c 79 11 80 	cmpl   $0x8011793c,0x8(%ebp)
80102c93:	72 12                	jb     80102ca7 <kfree+0x2d>
80102c95:	ff 75 08             	pushl  0x8(%ebp)
80102c98:	e8 36 ff ff ff       	call   80102bd3 <v2p>
80102c9d:	83 c4 04             	add    $0x4,%esp
80102ca0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102ca5:	76 0d                	jbe    80102cb4 <kfree+0x3a>
    panic("kfree");
80102ca7:	83 ec 0c             	sub    $0xc,%esp
80102caa:	68 cf a1 10 80       	push   $0x8010a1cf
80102caf:	e8 b2 d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102cb4:	83 ec 04             	sub    $0x4,%esp
80102cb7:	68 00 10 00 00       	push   $0x1000
80102cbc:	6a 01                	push   $0x1
80102cbe:	ff 75 08             	pushl  0x8(%ebp)
80102cc1:	e8 12 3e 00 00       	call   80106ad8 <memset>
80102cc6:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cc9:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cce:	85 c0                	test   %eax,%eax
80102cd0:	74 10                	je     80102ce2 <kfree+0x68>
    acquire(&kmem.lock);
80102cd2:	83 ec 0c             	sub    $0xc,%esp
80102cd5:	68 40 42 11 80       	push   $0x80114240
80102cda:	e8 96 3b 00 00       	call   80106875 <acquire>
80102cdf:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102ce2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ce8:	8b 15 78 42 11 80    	mov    0x80114278,%edx
80102cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cf1:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cf6:	a3 78 42 11 80       	mov    %eax,0x80114278
  if(kmem.use_lock)
80102cfb:	a1 74 42 11 80       	mov    0x80114274,%eax
80102d00:	85 c0                	test   %eax,%eax
80102d02:	74 10                	je     80102d14 <kfree+0x9a>
    release(&kmem.lock);
80102d04:	83 ec 0c             	sub    $0xc,%esp
80102d07:	68 40 42 11 80       	push   $0x80114240
80102d0c:	e8 cb 3b 00 00       	call   801068dc <release>
80102d11:	83 c4 10             	add    $0x10,%esp
}
80102d14:	90                   	nop
80102d15:	c9                   	leave  
80102d16:	c3                   	ret    

80102d17 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102d17:	55                   	push   %ebp
80102d18:	89 e5                	mov    %esp,%ebp
80102d1a:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102d1d:	a1 74 42 11 80       	mov    0x80114274,%eax
80102d22:	85 c0                	test   %eax,%eax
80102d24:	74 10                	je     80102d36 <kalloc+0x1f>
    acquire(&kmem.lock);
80102d26:	83 ec 0c             	sub    $0xc,%esp
80102d29:	68 40 42 11 80       	push   $0x80114240
80102d2e:	e8 42 3b 00 00       	call   80106875 <acquire>
80102d33:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102d36:	a1 78 42 11 80       	mov    0x80114278,%eax
80102d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102d3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d42:	74 0a                	je     80102d4e <kalloc+0x37>
    kmem.freelist = r->next;
80102d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d47:	8b 00                	mov    (%eax),%eax
80102d49:	a3 78 42 11 80       	mov    %eax,0x80114278
  if(kmem.use_lock)
80102d4e:	a1 74 42 11 80       	mov    0x80114274,%eax
80102d53:	85 c0                	test   %eax,%eax
80102d55:	74 10                	je     80102d67 <kalloc+0x50>
    release(&kmem.lock);
80102d57:	83 ec 0c             	sub    $0xc,%esp
80102d5a:	68 40 42 11 80       	push   $0x80114240
80102d5f:	e8 78 3b 00 00       	call   801068dc <release>
80102d64:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102d6a:	c9                   	leave  
80102d6b:	c3                   	ret    

80102d6c <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102d6c:	55                   	push   %ebp
80102d6d:	89 e5                	mov    %esp,%ebp
80102d6f:	83 ec 14             	sub    $0x14,%esp
80102d72:	8b 45 08             	mov    0x8(%ebp),%eax
80102d75:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d79:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d7d:	89 c2                	mov    %eax,%edx
80102d7f:	ec                   	in     (%dx),%al
80102d80:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d83:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d87:	c9                   	leave  
80102d88:	c3                   	ret    

80102d89 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d89:	55                   	push   %ebp
80102d8a:	89 e5                	mov    %esp,%ebp
80102d8c:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d8f:	6a 64                	push   $0x64
80102d91:	e8 d6 ff ff ff       	call   80102d6c <inb>
80102d96:	83 c4 04             	add    $0x4,%esp
80102d99:	0f b6 c0             	movzbl %al,%eax
80102d9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102da2:	83 e0 01             	and    $0x1,%eax
80102da5:	85 c0                	test   %eax,%eax
80102da7:	75 0a                	jne    80102db3 <kbdgetc+0x2a>
    return -1;
80102da9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102dae:	e9 23 01 00 00       	jmp    80102ed6 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102db3:	6a 60                	push   $0x60
80102db5:	e8 b2 ff ff ff       	call   80102d6c <inb>
80102dba:	83 c4 04             	add    $0x4,%esp
80102dbd:	0f b6 c0             	movzbl %al,%eax
80102dc0:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102dc3:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102dca:	75 17                	jne    80102de3 <kbdgetc+0x5a>
    shift |= E0ESC;
80102dcc:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102dd1:	83 c8 40             	or     $0x40,%eax
80102dd4:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102dd9:	b8 00 00 00 00       	mov    $0x0,%eax
80102dde:	e9 f3 00 00 00       	jmp    80102ed6 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102de3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102de6:	25 80 00 00 00       	and    $0x80,%eax
80102deb:	85 c0                	test   %eax,%eax
80102ded:	74 45                	je     80102e34 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102def:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102df4:	83 e0 40             	and    $0x40,%eax
80102df7:	85 c0                	test   %eax,%eax
80102df9:	75 08                	jne    80102e03 <kbdgetc+0x7a>
80102dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dfe:	83 e0 7f             	and    $0x7f,%eax
80102e01:	eb 03                	jmp    80102e06 <kbdgetc+0x7d>
80102e03:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e06:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e0c:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102e11:	0f b6 00             	movzbl (%eax),%eax
80102e14:	83 c8 40             	or     $0x40,%eax
80102e17:	0f b6 c0             	movzbl %al,%eax
80102e1a:	f7 d0                	not    %eax
80102e1c:	89 c2                	mov    %eax,%edx
80102e1e:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e23:	21 d0                	and    %edx,%eax
80102e25:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
    return 0;
80102e2a:	b8 00 00 00 00       	mov    $0x0,%eax
80102e2f:	e9 a2 00 00 00       	jmp    80102ed6 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102e34:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e39:	83 e0 40             	and    $0x40,%eax
80102e3c:	85 c0                	test   %eax,%eax
80102e3e:	74 14                	je     80102e54 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102e40:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102e47:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e4c:	83 e0 bf             	and    $0xffffffbf,%eax
80102e4f:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  }

  shift |= shiftcode[data];
80102e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e57:	05 20 b0 10 80       	add    $0x8010b020,%eax
80102e5c:	0f b6 00             	movzbl (%eax),%eax
80102e5f:	0f b6 d0             	movzbl %al,%edx
80102e62:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e67:	09 d0                	or     %edx,%eax
80102e69:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  shift ^= togglecode[data];
80102e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e71:	05 20 b1 10 80       	add    $0x8010b120,%eax
80102e76:	0f b6 00             	movzbl (%eax),%eax
80102e79:	0f b6 d0             	movzbl %al,%edx
80102e7c:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e81:	31 d0                	xor    %edx,%eax
80102e83:	a3 5c d6 10 80       	mov    %eax,0x8010d65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e88:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102e8d:	83 e0 03             	and    $0x3,%eax
80102e90:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80102e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e9a:	01 d0                	add    %edx,%eax
80102e9c:	0f b6 00             	movzbl (%eax),%eax
80102e9f:	0f b6 c0             	movzbl %al,%eax
80102ea2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102ea5:	a1 5c d6 10 80       	mov    0x8010d65c,%eax
80102eaa:	83 e0 08             	and    $0x8,%eax
80102ead:	85 c0                	test   %eax,%eax
80102eaf:	74 22                	je     80102ed3 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102eb1:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102eb5:	76 0c                	jbe    80102ec3 <kbdgetc+0x13a>
80102eb7:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102ebb:	77 06                	ja     80102ec3 <kbdgetc+0x13a>
      c += 'A' - 'a';
80102ebd:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102ec1:	eb 10                	jmp    80102ed3 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102ec3:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102ec7:	76 0a                	jbe    80102ed3 <kbdgetc+0x14a>
80102ec9:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102ecd:	77 04                	ja     80102ed3 <kbdgetc+0x14a>
      c += 'a' - 'A';
80102ecf:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102ed3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102ed6:	c9                   	leave  
80102ed7:	c3                   	ret    

80102ed8 <kbdintr>:

void
kbdintr(void)
{
80102ed8:	55                   	push   %ebp
80102ed9:	89 e5                	mov    %esp,%ebp
80102edb:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102ede:	83 ec 0c             	sub    $0xc,%esp
80102ee1:	68 89 2d 10 80       	push   $0x80102d89
80102ee6:	e8 0e d9 ff ff       	call   801007f9 <consoleintr>
80102eeb:	83 c4 10             	add    $0x10,%esp
}
80102eee:	90                   	nop
80102eef:	c9                   	leave  
80102ef0:	c3                   	ret    

80102ef1 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102ef1:	55                   	push   %ebp
80102ef2:	89 e5                	mov    %esp,%ebp
80102ef4:	83 ec 14             	sub    $0x14,%esp
80102ef7:	8b 45 08             	mov    0x8(%ebp),%eax
80102efa:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102efe:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102f02:	89 c2                	mov    %eax,%edx
80102f04:	ec                   	in     (%dx),%al
80102f05:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102f08:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102f0c:	c9                   	leave  
80102f0d:	c3                   	ret    

80102f0e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102f0e:	55                   	push   %ebp
80102f0f:	89 e5                	mov    %esp,%ebp
80102f11:	83 ec 08             	sub    $0x8,%esp
80102f14:	8b 55 08             	mov    0x8(%ebp),%edx
80102f17:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f1a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102f1e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102f21:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102f25:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102f29:	ee                   	out    %al,(%dx)
}
80102f2a:	90                   	nop
80102f2b:	c9                   	leave  
80102f2c:	c3                   	ret    

80102f2d <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102f2d:	55                   	push   %ebp
80102f2e:	89 e5                	mov    %esp,%ebp
80102f30:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102f33:	9c                   	pushf  
80102f34:	58                   	pop    %eax
80102f35:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102f38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102f3b:	c9                   	leave  
80102f3c:	c3                   	ret    

80102f3d <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102f3d:	55                   	push   %ebp
80102f3e:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102f40:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f45:	8b 55 08             	mov    0x8(%ebp),%edx
80102f48:	c1 e2 02             	shl    $0x2,%edx
80102f4b:	01 c2                	add    %eax,%edx
80102f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f50:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102f52:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f57:	83 c0 20             	add    $0x20,%eax
80102f5a:	8b 00                	mov    (%eax),%eax
}
80102f5c:	90                   	nop
80102f5d:	5d                   	pop    %ebp
80102f5e:	c3                   	ret    

80102f5f <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102f5f:	55                   	push   %ebp
80102f60:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102f62:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102f67:	85 c0                	test   %eax,%eax
80102f69:	0f 84 0b 01 00 00    	je     8010307a <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102f6f:	68 3f 01 00 00       	push   $0x13f
80102f74:	6a 3c                	push   $0x3c
80102f76:	e8 c2 ff ff ff       	call   80102f3d <lapicw>
80102f7b:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102f7e:	6a 0b                	push   $0xb
80102f80:	68 f8 00 00 00       	push   $0xf8
80102f85:	e8 b3 ff ff ff       	call   80102f3d <lapicw>
80102f8a:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f8d:	68 20 00 02 00       	push   $0x20020
80102f92:	68 c8 00 00 00       	push   $0xc8
80102f97:	e8 a1 ff ff ff       	call   80102f3d <lapicw>
80102f9c:	83 c4 08             	add    $0x8,%esp
  // lapicw(TICR, 10000000); 
  lapicw(TICR, 1000000000/TPS); // PSU CS333. Makes ticks per second programmable
80102f9f:	68 40 42 0f 00       	push   $0xf4240
80102fa4:	68 e0 00 00 00       	push   $0xe0
80102fa9:	e8 8f ff ff ff       	call   80102f3d <lapicw>
80102fae:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102fb1:	68 00 00 01 00       	push   $0x10000
80102fb6:	68 d4 00 00 00       	push   $0xd4
80102fbb:	e8 7d ff ff ff       	call   80102f3d <lapicw>
80102fc0:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102fc3:	68 00 00 01 00       	push   $0x10000
80102fc8:	68 d8 00 00 00       	push   $0xd8
80102fcd:	e8 6b ff ff ff       	call   80102f3d <lapicw>
80102fd2:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102fd5:	a1 7c 42 11 80       	mov    0x8011427c,%eax
80102fda:	83 c0 30             	add    $0x30,%eax
80102fdd:	8b 00                	mov    (%eax),%eax
80102fdf:	c1 e8 10             	shr    $0x10,%eax
80102fe2:	0f b6 c0             	movzbl %al,%eax
80102fe5:	83 f8 03             	cmp    $0x3,%eax
80102fe8:	76 12                	jbe    80102ffc <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
80102fea:	68 00 00 01 00       	push   $0x10000
80102fef:	68 d0 00 00 00       	push   $0xd0
80102ff4:	e8 44 ff ff ff       	call   80102f3d <lapicw>
80102ff9:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102ffc:	6a 33                	push   $0x33
80102ffe:	68 dc 00 00 00       	push   $0xdc
80103003:	e8 35 ff ff ff       	call   80102f3d <lapicw>
80103008:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
8010300b:	6a 00                	push   $0x0
8010300d:	68 a0 00 00 00       	push   $0xa0
80103012:	e8 26 ff ff ff       	call   80102f3d <lapicw>
80103017:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
8010301a:	6a 00                	push   $0x0
8010301c:	68 a0 00 00 00       	push   $0xa0
80103021:	e8 17 ff ff ff       	call   80102f3d <lapicw>
80103026:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80103029:	6a 00                	push   $0x0
8010302b:	6a 2c                	push   $0x2c
8010302d:	e8 0b ff ff ff       	call   80102f3d <lapicw>
80103032:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80103035:	6a 00                	push   $0x0
80103037:	68 c4 00 00 00       	push   $0xc4
8010303c:	e8 fc fe ff ff       	call   80102f3d <lapicw>
80103041:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80103044:	68 00 85 08 00       	push   $0x88500
80103049:	68 c0 00 00 00       	push   $0xc0
8010304e:	e8 ea fe ff ff       	call   80102f3d <lapicw>
80103053:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80103056:	90                   	nop
80103057:	a1 7c 42 11 80       	mov    0x8011427c,%eax
8010305c:	05 00 03 00 00       	add    $0x300,%eax
80103061:	8b 00                	mov    (%eax),%eax
80103063:	25 00 10 00 00       	and    $0x1000,%eax
80103068:	85 c0                	test   %eax,%eax
8010306a:	75 eb                	jne    80103057 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
8010306c:	6a 00                	push   $0x0
8010306e:	6a 20                	push   $0x20
80103070:	e8 c8 fe ff ff       	call   80102f3d <lapicw>
80103075:	83 c4 08             	add    $0x8,%esp
80103078:	eb 01                	jmp    8010307b <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
8010307a:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
8010307b:	c9                   	leave  
8010307c:	c3                   	ret    

8010307d <cpunum>:

int
cpunum(void)
{
8010307d:	55                   	push   %ebp
8010307e:	89 e5                	mov    %esp,%ebp
80103080:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80103083:	e8 a5 fe ff ff       	call   80102f2d <readeflags>
80103088:	25 00 02 00 00       	and    $0x200,%eax
8010308d:	85 c0                	test   %eax,%eax
8010308f:	74 26                	je     801030b7 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80103091:	a1 60 d6 10 80       	mov    0x8010d660,%eax
80103096:	8d 50 01             	lea    0x1(%eax),%edx
80103099:	89 15 60 d6 10 80    	mov    %edx,0x8010d660
8010309f:	85 c0                	test   %eax,%eax
801030a1:	75 14                	jne    801030b7 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
801030a3:	8b 45 04             	mov    0x4(%ebp),%eax
801030a6:	83 ec 08             	sub    $0x8,%esp
801030a9:	50                   	push   %eax
801030aa:	68 d8 a1 10 80       	push   $0x8010a1d8
801030af:	e8 12 d3 ff ff       	call   801003c6 <cprintf>
801030b4:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
801030b7:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030bc:	85 c0                	test   %eax,%eax
801030be:	74 0f                	je     801030cf <cpunum+0x52>
    return lapic[ID]>>24;
801030c0:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030c5:	83 c0 20             	add    $0x20,%eax
801030c8:	8b 00                	mov    (%eax),%eax
801030ca:	c1 e8 18             	shr    $0x18,%eax
801030cd:	eb 05                	jmp    801030d4 <cpunum+0x57>
  return 0;
801030cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801030d4:	c9                   	leave  
801030d5:	c3                   	ret    

801030d6 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
801030d6:	55                   	push   %ebp
801030d7:	89 e5                	mov    %esp,%ebp
  if(lapic)
801030d9:	a1 7c 42 11 80       	mov    0x8011427c,%eax
801030de:	85 c0                	test   %eax,%eax
801030e0:	74 0c                	je     801030ee <lapiceoi+0x18>
    lapicw(EOI, 0);
801030e2:	6a 00                	push   $0x0
801030e4:	6a 2c                	push   $0x2c
801030e6:	e8 52 fe ff ff       	call   80102f3d <lapicw>
801030eb:	83 c4 08             	add    $0x8,%esp
}
801030ee:	90                   	nop
801030ef:	c9                   	leave  
801030f0:	c3                   	ret    

801030f1 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801030f1:	55                   	push   %ebp
801030f2:	89 e5                	mov    %esp,%ebp
}
801030f4:	90                   	nop
801030f5:	5d                   	pop    %ebp
801030f6:	c3                   	ret    

801030f7 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801030f7:	55                   	push   %ebp
801030f8:	89 e5                	mov    %esp,%ebp
801030fa:	83 ec 14             	sub    $0x14,%esp
801030fd:	8b 45 08             	mov    0x8(%ebp),%eax
80103100:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103103:	6a 0f                	push   $0xf
80103105:	6a 70                	push   $0x70
80103107:	e8 02 fe ff ff       	call   80102f0e <outb>
8010310c:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
8010310f:	6a 0a                	push   $0xa
80103111:	6a 71                	push   $0x71
80103113:	e8 f6 fd ff ff       	call   80102f0e <outb>
80103118:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010311b:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80103122:	8b 45 f8             	mov    -0x8(%ebp),%eax
80103125:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
8010312a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010312d:	83 c0 02             	add    $0x2,%eax
80103130:	8b 55 0c             	mov    0xc(%ebp),%edx
80103133:	c1 ea 04             	shr    $0x4,%edx
80103136:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80103139:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010313d:	c1 e0 18             	shl    $0x18,%eax
80103140:	50                   	push   %eax
80103141:	68 c4 00 00 00       	push   $0xc4
80103146:	e8 f2 fd ff ff       	call   80102f3d <lapicw>
8010314b:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
8010314e:	68 00 c5 00 00       	push   $0xc500
80103153:	68 c0 00 00 00       	push   $0xc0
80103158:	e8 e0 fd ff ff       	call   80102f3d <lapicw>
8010315d:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103160:	68 c8 00 00 00       	push   $0xc8
80103165:	e8 87 ff ff ff       	call   801030f1 <microdelay>
8010316a:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
8010316d:	68 00 85 00 00       	push   $0x8500
80103172:	68 c0 00 00 00       	push   $0xc0
80103177:	e8 c1 fd ff ff       	call   80102f3d <lapicw>
8010317c:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010317f:	6a 64                	push   $0x64
80103181:	e8 6b ff ff ff       	call   801030f1 <microdelay>
80103186:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103189:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103190:	eb 3d                	jmp    801031cf <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103192:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103196:	c1 e0 18             	shl    $0x18,%eax
80103199:	50                   	push   %eax
8010319a:	68 c4 00 00 00       	push   $0xc4
8010319f:	e8 99 fd ff ff       	call   80102f3d <lapicw>
801031a4:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
801031a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801031aa:	c1 e8 0c             	shr    $0xc,%eax
801031ad:	80 cc 06             	or     $0x6,%ah
801031b0:	50                   	push   %eax
801031b1:	68 c0 00 00 00       	push   $0xc0
801031b6:	e8 82 fd ff ff       	call   80102f3d <lapicw>
801031bb:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
801031be:	68 c8 00 00 00       	push   $0xc8
801031c3:	e8 29 ff ff ff       	call   801030f1 <microdelay>
801031c8:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
801031cb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801031cf:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
801031d3:	7e bd                	jle    80103192 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801031d5:	90                   	nop
801031d6:	c9                   	leave  
801031d7:	c3                   	ret    

801031d8 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
801031d8:	55                   	push   %ebp
801031d9:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
801031db:	8b 45 08             	mov    0x8(%ebp),%eax
801031de:	0f b6 c0             	movzbl %al,%eax
801031e1:	50                   	push   %eax
801031e2:	6a 70                	push   $0x70
801031e4:	e8 25 fd ff ff       	call   80102f0e <outb>
801031e9:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801031ec:	68 c8 00 00 00       	push   $0xc8
801031f1:	e8 fb fe ff ff       	call   801030f1 <microdelay>
801031f6:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
801031f9:	6a 71                	push   $0x71
801031fb:	e8 f1 fc ff ff       	call   80102ef1 <inb>
80103200:	83 c4 04             	add    $0x4,%esp
80103203:	0f b6 c0             	movzbl %al,%eax
}
80103206:	c9                   	leave  
80103207:	c3                   	ret    

80103208 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103208:	55                   	push   %ebp
80103209:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010320b:	6a 00                	push   $0x0
8010320d:	e8 c6 ff ff ff       	call   801031d8 <cmos_read>
80103212:	83 c4 04             	add    $0x4,%esp
80103215:	89 c2                	mov    %eax,%edx
80103217:	8b 45 08             	mov    0x8(%ebp),%eax
8010321a:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
8010321c:	6a 02                	push   $0x2
8010321e:	e8 b5 ff ff ff       	call   801031d8 <cmos_read>
80103223:	83 c4 04             	add    $0x4,%esp
80103226:	89 c2                	mov    %eax,%edx
80103228:	8b 45 08             	mov    0x8(%ebp),%eax
8010322b:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
8010322e:	6a 04                	push   $0x4
80103230:	e8 a3 ff ff ff       	call   801031d8 <cmos_read>
80103235:	83 c4 04             	add    $0x4,%esp
80103238:	89 c2                	mov    %eax,%edx
8010323a:	8b 45 08             	mov    0x8(%ebp),%eax
8010323d:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
80103240:	6a 07                	push   $0x7
80103242:	e8 91 ff ff ff       	call   801031d8 <cmos_read>
80103247:	83 c4 04             	add    $0x4,%esp
8010324a:	89 c2                	mov    %eax,%edx
8010324c:	8b 45 08             	mov    0x8(%ebp),%eax
8010324f:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
80103252:	6a 08                	push   $0x8
80103254:	e8 7f ff ff ff       	call   801031d8 <cmos_read>
80103259:	83 c4 04             	add    $0x4,%esp
8010325c:	89 c2                	mov    %eax,%edx
8010325e:	8b 45 08             	mov    0x8(%ebp),%eax
80103261:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
80103264:	6a 09                	push   $0x9
80103266:	e8 6d ff ff ff       	call   801031d8 <cmos_read>
8010326b:	83 c4 04             	add    $0x4,%esp
8010326e:	89 c2                	mov    %eax,%edx
80103270:	8b 45 08             	mov    0x8(%ebp),%eax
80103273:	89 50 14             	mov    %edx,0x14(%eax)
}
80103276:	90                   	nop
80103277:	c9                   	leave  
80103278:	c3                   	ret    

80103279 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103279:	55                   	push   %ebp
8010327a:	89 e5                	mov    %esp,%ebp
8010327c:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010327f:	6a 0b                	push   $0xb
80103281:	e8 52 ff ff ff       	call   801031d8 <cmos_read>
80103286:	83 c4 04             	add    $0x4,%esp
80103289:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010328c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010328f:	83 e0 04             	and    $0x4,%eax
80103292:	85 c0                	test   %eax,%eax
80103294:	0f 94 c0             	sete   %al
80103297:	0f b6 c0             	movzbl %al,%eax
8010329a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
8010329d:	8d 45 d8             	lea    -0x28(%ebp),%eax
801032a0:	50                   	push   %eax
801032a1:	e8 62 ff ff ff       	call   80103208 <fill_rtcdate>
801032a6:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
801032a9:	6a 0a                	push   $0xa
801032ab:	e8 28 ff ff ff       	call   801031d8 <cmos_read>
801032b0:	83 c4 04             	add    $0x4,%esp
801032b3:	25 80 00 00 00       	and    $0x80,%eax
801032b8:	85 c0                	test   %eax,%eax
801032ba:	75 27                	jne    801032e3 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
801032bc:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032bf:	50                   	push   %eax
801032c0:	e8 43 ff ff ff       	call   80103208 <fill_rtcdate>
801032c5:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
801032c8:	83 ec 04             	sub    $0x4,%esp
801032cb:	6a 18                	push   $0x18
801032cd:	8d 45 c0             	lea    -0x40(%ebp),%eax
801032d0:	50                   	push   %eax
801032d1:	8d 45 d8             	lea    -0x28(%ebp),%eax
801032d4:	50                   	push   %eax
801032d5:	e8 65 38 00 00       	call   80106b3f <memcmp>
801032da:	83 c4 10             	add    $0x10,%esp
801032dd:	85 c0                	test   %eax,%eax
801032df:	74 05                	je     801032e6 <cmostime+0x6d>
801032e1:	eb ba                	jmp    8010329d <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
801032e3:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
801032e4:	eb b7                	jmp    8010329d <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
801032e6:	90                   	nop
  }

  // convert
  if (bcd) {
801032e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801032eb:	0f 84 b4 00 00 00    	je     801033a5 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801032f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801032f4:	c1 e8 04             	shr    $0x4,%eax
801032f7:	89 c2                	mov    %eax,%edx
801032f9:	89 d0                	mov    %edx,%eax
801032fb:	c1 e0 02             	shl    $0x2,%eax
801032fe:	01 d0                	add    %edx,%eax
80103300:	01 c0                	add    %eax,%eax
80103302:	89 c2                	mov    %eax,%edx
80103304:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103307:	83 e0 0f             	and    $0xf,%eax
8010330a:	01 d0                	add    %edx,%eax
8010330c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
8010330f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103312:	c1 e8 04             	shr    $0x4,%eax
80103315:	89 c2                	mov    %eax,%edx
80103317:	89 d0                	mov    %edx,%eax
80103319:	c1 e0 02             	shl    $0x2,%eax
8010331c:	01 d0                	add    %edx,%eax
8010331e:	01 c0                	add    %eax,%eax
80103320:	89 c2                	mov    %eax,%edx
80103322:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103325:	83 e0 0f             	and    $0xf,%eax
80103328:	01 d0                	add    %edx,%eax
8010332a:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
8010332d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103330:	c1 e8 04             	shr    $0x4,%eax
80103333:	89 c2                	mov    %eax,%edx
80103335:	89 d0                	mov    %edx,%eax
80103337:	c1 e0 02             	shl    $0x2,%eax
8010333a:	01 d0                	add    %edx,%eax
8010333c:	01 c0                	add    %eax,%eax
8010333e:	89 c2                	mov    %eax,%edx
80103340:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103343:	83 e0 0f             	and    $0xf,%eax
80103346:	01 d0                	add    %edx,%eax
80103348:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
8010334b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010334e:	c1 e8 04             	shr    $0x4,%eax
80103351:	89 c2                	mov    %eax,%edx
80103353:	89 d0                	mov    %edx,%eax
80103355:	c1 e0 02             	shl    $0x2,%eax
80103358:	01 d0                	add    %edx,%eax
8010335a:	01 c0                	add    %eax,%eax
8010335c:	89 c2                	mov    %eax,%edx
8010335e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103361:	83 e0 0f             	and    $0xf,%eax
80103364:	01 d0                	add    %edx,%eax
80103366:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103369:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010336c:	c1 e8 04             	shr    $0x4,%eax
8010336f:	89 c2                	mov    %eax,%edx
80103371:	89 d0                	mov    %edx,%eax
80103373:	c1 e0 02             	shl    $0x2,%eax
80103376:	01 d0                	add    %edx,%eax
80103378:	01 c0                	add    %eax,%eax
8010337a:	89 c2                	mov    %eax,%edx
8010337c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010337f:	83 e0 0f             	and    $0xf,%eax
80103382:	01 d0                	add    %edx,%eax
80103384:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103387:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010338a:	c1 e8 04             	shr    $0x4,%eax
8010338d:	89 c2                	mov    %eax,%edx
8010338f:	89 d0                	mov    %edx,%eax
80103391:	c1 e0 02             	shl    $0x2,%eax
80103394:	01 d0                	add    %edx,%eax
80103396:	01 c0                	add    %eax,%eax
80103398:	89 c2                	mov    %eax,%edx
8010339a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010339d:	83 e0 0f             	and    $0xf,%eax
801033a0:	01 d0                	add    %edx,%eax
801033a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
801033a5:	8b 45 08             	mov    0x8(%ebp),%eax
801033a8:	8b 55 d8             	mov    -0x28(%ebp),%edx
801033ab:	89 10                	mov    %edx,(%eax)
801033ad:	8b 55 dc             	mov    -0x24(%ebp),%edx
801033b0:	89 50 04             	mov    %edx,0x4(%eax)
801033b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
801033b6:	89 50 08             	mov    %edx,0x8(%eax)
801033b9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801033bc:	89 50 0c             	mov    %edx,0xc(%eax)
801033bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
801033c2:	89 50 10             	mov    %edx,0x10(%eax)
801033c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
801033c8:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
801033cb:	8b 45 08             	mov    0x8(%ebp),%eax
801033ce:	8b 40 14             	mov    0x14(%eax),%eax
801033d1:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
801033d7:	8b 45 08             	mov    0x8(%ebp),%eax
801033da:	89 50 14             	mov    %edx,0x14(%eax)
}
801033dd:	90                   	nop
801033de:	c9                   	leave  
801033df:	c3                   	ret    

801033e0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
801033e6:	83 ec 08             	sub    $0x8,%esp
801033e9:	68 04 a2 10 80       	push   $0x8010a204
801033ee:	68 80 42 11 80       	push   $0x80114280
801033f3:	e8 5b 34 00 00       	call   80106853 <initlock>
801033f8:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801033fb:	83 ec 08             	sub    $0x8,%esp
801033fe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103401:	50                   	push   %eax
80103402:	ff 75 08             	pushl  0x8(%ebp)
80103405:	e8 2b e0 ff ff       	call   80101435 <readsb>
8010340a:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
8010340d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103410:	a3 b4 42 11 80       	mov    %eax,0x801142b4
  log.size = sb.nlog;
80103415:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103418:	a3 b8 42 11 80       	mov    %eax,0x801142b8
  log.dev = dev;
8010341d:	8b 45 08             	mov    0x8(%ebp),%eax
80103420:	a3 c4 42 11 80       	mov    %eax,0x801142c4
  recover_from_log();
80103425:	e8 b2 01 00 00       	call   801035dc <recover_from_log>
}
8010342a:	90                   	nop
8010342b:	c9                   	leave  
8010342c:	c3                   	ret    

8010342d <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
8010342d:	55                   	push   %ebp
8010342e:	89 e5                	mov    %esp,%ebp
80103430:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103433:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010343a:	e9 95 00 00 00       	jmp    801034d4 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010343f:	8b 15 b4 42 11 80    	mov    0x801142b4,%edx
80103445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103448:	01 d0                	add    %edx,%eax
8010344a:	83 c0 01             	add    $0x1,%eax
8010344d:	89 c2                	mov    %eax,%edx
8010344f:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103454:	83 ec 08             	sub    $0x8,%esp
80103457:	52                   	push   %edx
80103458:	50                   	push   %eax
80103459:	e8 58 cd ff ff       	call   801001b6 <bread>
8010345e:	83 c4 10             	add    $0x10,%esp
80103461:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103464:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103467:	83 c0 10             	add    $0x10,%eax
8010346a:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
80103471:	89 c2                	mov    %eax,%edx
80103473:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103478:	83 ec 08             	sub    $0x8,%esp
8010347b:	52                   	push   %edx
8010347c:	50                   	push   %eax
8010347d:	e8 34 cd ff ff       	call   801001b6 <bread>
80103482:	83 c4 10             	add    $0x10,%esp
80103485:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103488:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010348b:	8d 50 18             	lea    0x18(%eax),%edx
8010348e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103491:	83 c0 18             	add    $0x18,%eax
80103494:	83 ec 04             	sub    $0x4,%esp
80103497:	68 00 02 00 00       	push   $0x200
8010349c:	52                   	push   %edx
8010349d:	50                   	push   %eax
8010349e:	e8 f4 36 00 00       	call   80106b97 <memmove>
801034a3:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
801034a6:	83 ec 0c             	sub    $0xc,%esp
801034a9:	ff 75 ec             	pushl  -0x14(%ebp)
801034ac:	e8 3e cd ff ff       	call   801001ef <bwrite>
801034b1:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
801034b4:	83 ec 0c             	sub    $0xc,%esp
801034b7:	ff 75 f0             	pushl  -0x10(%ebp)
801034ba:	e8 6f cd ff ff       	call   8010022e <brelse>
801034bf:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
801034c2:	83 ec 0c             	sub    $0xc,%esp
801034c5:	ff 75 ec             	pushl  -0x14(%ebp)
801034c8:	e8 61 cd ff ff       	call   8010022e <brelse>
801034cd:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801034d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034d4:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801034d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801034dc:	0f 8f 5d ff ff ff    	jg     8010343f <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
801034e2:	90                   	nop
801034e3:	c9                   	leave  
801034e4:	c3                   	ret    

801034e5 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801034e5:	55                   	push   %ebp
801034e6:	89 e5                	mov    %esp,%ebp
801034e8:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034eb:	a1 b4 42 11 80       	mov    0x801142b4,%eax
801034f0:	89 c2                	mov    %eax,%edx
801034f2:	a1 c4 42 11 80       	mov    0x801142c4,%eax
801034f7:	83 ec 08             	sub    $0x8,%esp
801034fa:	52                   	push   %edx
801034fb:	50                   	push   %eax
801034fc:	e8 b5 cc ff ff       	call   801001b6 <bread>
80103501:	83 c4 10             	add    $0x10,%esp
80103504:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103507:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010350a:	83 c0 18             	add    $0x18,%eax
8010350d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103510:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103513:	8b 00                	mov    (%eax),%eax
80103515:	a3 c8 42 11 80       	mov    %eax,0x801142c8
  for (i = 0; i < log.lh.n; i++) {
8010351a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103521:	eb 1b                	jmp    8010353e <read_head+0x59>
    log.lh.block[i] = lh->block[i];
80103523:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103526:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103529:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
8010352d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103530:	83 c2 10             	add    $0x10,%edx
80103533:	89 04 95 8c 42 11 80 	mov    %eax,-0x7feebd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
8010353a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010353e:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103543:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103546:	7f db                	jg     80103523 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80103548:	83 ec 0c             	sub    $0xc,%esp
8010354b:	ff 75 f0             	pushl  -0x10(%ebp)
8010354e:	e8 db cc ff ff       	call   8010022e <brelse>
80103553:	83 c4 10             	add    $0x10,%esp
}
80103556:	90                   	nop
80103557:	c9                   	leave  
80103558:	c3                   	ret    

80103559 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103559:	55                   	push   %ebp
8010355a:	89 e5                	mov    %esp,%ebp
8010355c:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010355f:	a1 b4 42 11 80       	mov    0x801142b4,%eax
80103564:	89 c2                	mov    %eax,%edx
80103566:	a1 c4 42 11 80       	mov    0x801142c4,%eax
8010356b:	83 ec 08             	sub    $0x8,%esp
8010356e:	52                   	push   %edx
8010356f:	50                   	push   %eax
80103570:	e8 41 cc ff ff       	call   801001b6 <bread>
80103575:	83 c4 10             	add    $0x10,%esp
80103578:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010357b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010357e:	83 c0 18             	add    $0x18,%eax
80103581:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103584:	8b 15 c8 42 11 80    	mov    0x801142c8,%edx
8010358a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010358d:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010358f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103596:	eb 1b                	jmp    801035b3 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103598:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010359b:	83 c0 10             	add    $0x10,%eax
8010359e:	8b 0c 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%ecx
801035a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035ab:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801035af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801035b3:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801035b8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035bb:	7f db                	jg     80103598 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
801035bd:	83 ec 0c             	sub    $0xc,%esp
801035c0:	ff 75 f0             	pushl  -0x10(%ebp)
801035c3:	e8 27 cc ff ff       	call   801001ef <bwrite>
801035c8:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
801035cb:	83 ec 0c             	sub    $0xc,%esp
801035ce:	ff 75 f0             	pushl  -0x10(%ebp)
801035d1:	e8 58 cc ff ff       	call   8010022e <brelse>
801035d6:	83 c4 10             	add    $0x10,%esp
}
801035d9:	90                   	nop
801035da:	c9                   	leave  
801035db:	c3                   	ret    

801035dc <recover_from_log>:

static void
recover_from_log(void)
{
801035dc:	55                   	push   %ebp
801035dd:	89 e5                	mov    %esp,%ebp
801035df:	83 ec 08             	sub    $0x8,%esp
  read_head();      
801035e2:	e8 fe fe ff ff       	call   801034e5 <read_head>
  install_trans(); // if committed, copy from log to disk
801035e7:	e8 41 fe ff ff       	call   8010342d <install_trans>
  log.lh.n = 0;
801035ec:	c7 05 c8 42 11 80 00 	movl   $0x0,0x801142c8
801035f3:	00 00 00 
  write_head(); // clear the log
801035f6:	e8 5e ff ff ff       	call   80103559 <write_head>
}
801035fb:	90                   	nop
801035fc:	c9                   	leave  
801035fd:	c3                   	ret    

801035fe <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
801035fe:	55                   	push   %ebp
801035ff:	89 e5                	mov    %esp,%ebp
80103601:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103604:	83 ec 0c             	sub    $0xc,%esp
80103607:	68 80 42 11 80       	push   $0x80114280
8010360c:	e8 64 32 00 00       	call   80106875 <acquire>
80103611:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103614:	a1 c0 42 11 80       	mov    0x801142c0,%eax
80103619:	85 c0                	test   %eax,%eax
8010361b:	74 17                	je     80103634 <begin_op+0x36>
      sleep(&log, &log.lock);
8010361d:	83 ec 08             	sub    $0x8,%esp
80103620:	68 80 42 11 80       	push   $0x80114280
80103625:	68 80 42 11 80       	push   $0x80114280
8010362a:	e8 5d 1f 00 00       	call   8010558c <sleep>
8010362f:	83 c4 10             	add    $0x10,%esp
80103632:	eb e0                	jmp    80103614 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103634:	8b 0d c8 42 11 80    	mov    0x801142c8,%ecx
8010363a:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010363f:	8d 50 01             	lea    0x1(%eax),%edx
80103642:	89 d0                	mov    %edx,%eax
80103644:	c1 e0 02             	shl    $0x2,%eax
80103647:	01 d0                	add    %edx,%eax
80103649:	01 c0                	add    %eax,%eax
8010364b:	01 c8                	add    %ecx,%eax
8010364d:	83 f8 1e             	cmp    $0x1e,%eax
80103650:	7e 17                	jle    80103669 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103652:	83 ec 08             	sub    $0x8,%esp
80103655:	68 80 42 11 80       	push   $0x80114280
8010365a:	68 80 42 11 80       	push   $0x80114280
8010365f:	e8 28 1f 00 00       	call   8010558c <sleep>
80103664:	83 c4 10             	add    $0x10,%esp
80103667:	eb ab                	jmp    80103614 <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103669:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010366e:	83 c0 01             	add    $0x1,%eax
80103671:	a3 bc 42 11 80       	mov    %eax,0x801142bc
      release(&log.lock);
80103676:	83 ec 0c             	sub    $0xc,%esp
80103679:	68 80 42 11 80       	push   $0x80114280
8010367e:	e8 59 32 00 00       	call   801068dc <release>
80103683:	83 c4 10             	add    $0x10,%esp
      break;
80103686:	90                   	nop
    }
  }
}
80103687:	90                   	nop
80103688:	c9                   	leave  
80103689:	c3                   	ret    

8010368a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010368a:	55                   	push   %ebp
8010368b:	89 e5                	mov    %esp,%ebp
8010368d:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103690:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103697:	83 ec 0c             	sub    $0xc,%esp
8010369a:	68 80 42 11 80       	push   $0x80114280
8010369f:	e8 d1 31 00 00       	call   80106875 <acquire>
801036a4:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
801036a7:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801036ac:	83 e8 01             	sub    $0x1,%eax
801036af:	a3 bc 42 11 80       	mov    %eax,0x801142bc
  if(log.committing)
801036b4:	a1 c0 42 11 80       	mov    0x801142c0,%eax
801036b9:	85 c0                	test   %eax,%eax
801036bb:	74 0d                	je     801036ca <end_op+0x40>
    panic("log.committing");
801036bd:	83 ec 0c             	sub    $0xc,%esp
801036c0:	68 08 a2 10 80       	push   $0x8010a208
801036c5:	e8 9c ce ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
801036ca:	a1 bc 42 11 80       	mov    0x801142bc,%eax
801036cf:	85 c0                	test   %eax,%eax
801036d1:	75 13                	jne    801036e6 <end_op+0x5c>
    do_commit = 1;
801036d3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
801036da:	c7 05 c0 42 11 80 01 	movl   $0x1,0x801142c0
801036e1:	00 00 00 
801036e4:	eb 10                	jmp    801036f6 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
801036e6:	83 ec 0c             	sub    $0xc,%esp
801036e9:	68 80 42 11 80       	push   $0x80114280
801036ee:	e8 f4 20 00 00       	call   801057e7 <wakeup>
801036f3:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036f6:	83 ec 0c             	sub    $0xc,%esp
801036f9:	68 80 42 11 80       	push   $0x80114280
801036fe:	e8 d9 31 00 00       	call   801068dc <release>
80103703:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103706:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010370a:	74 3f                	je     8010374b <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010370c:	e8 f5 00 00 00       	call   80103806 <commit>
    acquire(&log.lock);
80103711:	83 ec 0c             	sub    $0xc,%esp
80103714:	68 80 42 11 80       	push   $0x80114280
80103719:	e8 57 31 00 00       	call   80106875 <acquire>
8010371e:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103721:	c7 05 c0 42 11 80 00 	movl   $0x0,0x801142c0
80103728:	00 00 00 
    wakeup(&log);
8010372b:	83 ec 0c             	sub    $0xc,%esp
8010372e:	68 80 42 11 80       	push   $0x80114280
80103733:	e8 af 20 00 00       	call   801057e7 <wakeup>
80103738:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	68 80 42 11 80       	push   $0x80114280
80103743:	e8 94 31 00 00       	call   801068dc <release>
80103748:	83 c4 10             	add    $0x10,%esp
  }
}
8010374b:	90                   	nop
8010374c:	c9                   	leave  
8010374d:	c3                   	ret    

8010374e <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
8010374e:	55                   	push   %ebp
8010374f:	89 e5                	mov    %esp,%ebp
80103751:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103754:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010375b:	e9 95 00 00 00       	jmp    801037f5 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103760:	8b 15 b4 42 11 80    	mov    0x801142b4,%edx
80103766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103769:	01 d0                	add    %edx,%eax
8010376b:	83 c0 01             	add    $0x1,%eax
8010376e:	89 c2                	mov    %eax,%edx
80103770:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103775:	83 ec 08             	sub    $0x8,%esp
80103778:	52                   	push   %edx
80103779:	50                   	push   %eax
8010377a:	e8 37 ca ff ff       	call   801001b6 <bread>
8010377f:	83 c4 10             	add    $0x10,%esp
80103782:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103788:	83 c0 10             	add    $0x10,%eax
8010378b:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
80103792:	89 c2                	mov    %eax,%edx
80103794:	a1 c4 42 11 80       	mov    0x801142c4,%eax
80103799:	83 ec 08             	sub    $0x8,%esp
8010379c:	52                   	push   %edx
8010379d:	50                   	push   %eax
8010379e:	e8 13 ca ff ff       	call   801001b6 <bread>
801037a3:	83 c4 10             	add    $0x10,%esp
801037a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801037a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037ac:	8d 50 18             	lea    0x18(%eax),%edx
801037af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037b2:	83 c0 18             	add    $0x18,%eax
801037b5:	83 ec 04             	sub    $0x4,%esp
801037b8:	68 00 02 00 00       	push   $0x200
801037bd:	52                   	push   %edx
801037be:	50                   	push   %eax
801037bf:	e8 d3 33 00 00       	call   80106b97 <memmove>
801037c4:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
801037c7:	83 ec 0c             	sub    $0xc,%esp
801037ca:	ff 75 f0             	pushl  -0x10(%ebp)
801037cd:	e8 1d ca ff ff       	call   801001ef <bwrite>
801037d2:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
801037d5:	83 ec 0c             	sub    $0xc,%esp
801037d8:	ff 75 ec             	pushl  -0x14(%ebp)
801037db:	e8 4e ca ff ff       	call   8010022e <brelse>
801037e0:	83 c4 10             	add    $0x10,%esp
    brelse(to);
801037e3:	83 ec 0c             	sub    $0xc,%esp
801037e6:	ff 75 f0             	pushl  -0x10(%ebp)
801037e9:	e8 40 ca ff ff       	call   8010022e <brelse>
801037ee:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801037f1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037f5:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801037fa:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037fd:	0f 8f 5d ff ff ff    	jg     80103760 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103803:	90                   	nop
80103804:	c9                   	leave  
80103805:	c3                   	ret    

80103806 <commit>:

static void
commit()
{
80103806:	55                   	push   %ebp
80103807:	89 e5                	mov    %esp,%ebp
80103809:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010380c:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103811:	85 c0                	test   %eax,%eax
80103813:	7e 1e                	jle    80103833 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103815:	e8 34 ff ff ff       	call   8010374e <write_log>
    write_head();    // Write header to disk -- the real commit
8010381a:	e8 3a fd ff ff       	call   80103559 <write_head>
    install_trans(); // Now install writes to home locations
8010381f:	e8 09 fc ff ff       	call   8010342d <install_trans>
    log.lh.n = 0; 
80103824:	c7 05 c8 42 11 80 00 	movl   $0x0,0x801142c8
8010382b:	00 00 00 
    write_head();    // Erase the transaction from the log
8010382e:	e8 26 fd ff ff       	call   80103559 <write_head>
  }
}
80103833:	90                   	nop
80103834:	c9                   	leave  
80103835:	c3                   	ret    

80103836 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103836:	55                   	push   %ebp
80103837:	89 e5                	mov    %esp,%ebp
80103839:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010383c:	a1 c8 42 11 80       	mov    0x801142c8,%eax
80103841:	83 f8 1d             	cmp    $0x1d,%eax
80103844:	7f 12                	jg     80103858 <log_write+0x22>
80103846:	a1 c8 42 11 80       	mov    0x801142c8,%eax
8010384b:	8b 15 b8 42 11 80    	mov    0x801142b8,%edx
80103851:	83 ea 01             	sub    $0x1,%edx
80103854:	39 d0                	cmp    %edx,%eax
80103856:	7c 0d                	jl     80103865 <log_write+0x2f>
    panic("too big a transaction");
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	68 17 a2 10 80       	push   $0x8010a217
80103860:	e8 01 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103865:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010386a:	85 c0                	test   %eax,%eax
8010386c:	7f 0d                	jg     8010387b <log_write+0x45>
    panic("log_write outside of trans");
8010386e:	83 ec 0c             	sub    $0xc,%esp
80103871:	68 2d a2 10 80       	push   $0x8010a22d
80103876:	e8 eb cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
8010387b:	83 ec 0c             	sub    $0xc,%esp
8010387e:	68 80 42 11 80       	push   $0x80114280
80103883:	e8 ed 2f 00 00       	call   80106875 <acquire>
80103888:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
8010388b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103892:	eb 1d                	jmp    801038b1 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103897:	83 c0 10             	add    $0x10,%eax
8010389a:	8b 04 85 8c 42 11 80 	mov    -0x7feebd74(,%eax,4),%eax
801038a1:	89 c2                	mov    %eax,%edx
801038a3:	8b 45 08             	mov    0x8(%ebp),%eax
801038a6:	8b 40 08             	mov    0x8(%eax),%eax
801038a9:	39 c2                	cmp    %eax,%edx
801038ab:	74 10                	je     801038bd <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801038ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801038b1:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038b6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038b9:	7f d9                	jg     80103894 <log_write+0x5e>
801038bb:	eb 01                	jmp    801038be <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
801038bd:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
801038be:	8b 45 08             	mov    0x8(%ebp),%eax
801038c1:	8b 40 08             	mov    0x8(%eax),%eax
801038c4:	89 c2                	mov    %eax,%edx
801038c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038c9:	83 c0 10             	add    $0x10,%eax
801038cc:	89 14 85 8c 42 11 80 	mov    %edx,-0x7feebd74(,%eax,4)
  if (i == log.lh.n)
801038d3:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038d8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038db:	75 0d                	jne    801038ea <log_write+0xb4>
    log.lh.n++;
801038dd:	a1 c8 42 11 80       	mov    0x801142c8,%eax
801038e2:	83 c0 01             	add    $0x1,%eax
801038e5:	a3 c8 42 11 80       	mov    %eax,0x801142c8
  b->flags |= B_DIRTY; // prevent eviction
801038ea:	8b 45 08             	mov    0x8(%ebp),%eax
801038ed:	8b 00                	mov    (%eax),%eax
801038ef:	83 c8 04             	or     $0x4,%eax
801038f2:	89 c2                	mov    %eax,%edx
801038f4:	8b 45 08             	mov    0x8(%ebp),%eax
801038f7:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
801038f9:	83 ec 0c             	sub    $0xc,%esp
801038fc:	68 80 42 11 80       	push   $0x80114280
80103901:	e8 d6 2f 00 00       	call   801068dc <release>
80103906:	83 c4 10             	add    $0x10,%esp
}
80103909:	90                   	nop
8010390a:	c9                   	leave  
8010390b:	c3                   	ret    

8010390c <v2p>:
8010390c:	55                   	push   %ebp
8010390d:	89 e5                	mov    %esp,%ebp
8010390f:	8b 45 08             	mov    0x8(%ebp),%eax
80103912:	05 00 00 00 80       	add    $0x80000000,%eax
80103917:	5d                   	pop    %ebp
80103918:	c3                   	ret    

80103919 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103919:	55                   	push   %ebp
8010391a:	89 e5                	mov    %esp,%ebp
8010391c:	8b 45 08             	mov    0x8(%ebp),%eax
8010391f:	05 00 00 00 80       	add    $0x80000000,%eax
80103924:	5d                   	pop    %ebp
80103925:	c3                   	ret    

80103926 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103926:	55                   	push   %ebp
80103927:	89 e5                	mov    %esp,%ebp
80103929:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010392c:	8b 55 08             	mov    0x8(%ebp),%edx
8010392f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103932:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103935:	f0 87 02             	lock xchg %eax,(%edx)
80103938:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010393b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010393e:	c9                   	leave  
8010393f:	c3                   	ret    

80103940 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103940:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103944:	83 e4 f0             	and    $0xfffffff0,%esp
80103947:	ff 71 fc             	pushl  -0x4(%ecx)
8010394a:	55                   	push   %ebp
8010394b:	89 e5                	mov    %esp,%ebp
8010394d:	51                   	push   %ecx
8010394e:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103951:	83 ec 08             	sub    $0x8,%esp
80103954:	68 00 00 40 80       	push   $0x80400000
80103959:	68 3c 79 11 80       	push   $0x8011793c
8010395e:	e8 7d f2 ff ff       	call   80102be0 <kinit1>
80103963:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103966:	e8 ab 5e 00 00       	call   80109816 <kvmalloc>
  mpinit();        // collect info about this machine
8010396b:	e8 43 04 00 00       	call   80103db3 <mpinit>
  lapicinit();
80103970:	e8 ea f5 ff ff       	call   80102f5f <lapicinit>
  seginit();       // set up segments
80103975:	e8 45 58 00 00       	call   801091bf <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010397a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103980:	0f b6 00             	movzbl (%eax),%eax
80103983:	0f b6 c0             	movzbl %al,%eax
80103986:	83 ec 08             	sub    $0x8,%esp
80103989:	50                   	push   %eax
8010398a:	68 48 a2 10 80       	push   $0x8010a248
8010398f:	e8 32 ca ff ff       	call   801003c6 <cprintf>
80103994:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103997:	e8 6d 06 00 00       	call   80104009 <picinit>
  ioapicinit();    // another interrupt controller
8010399c:	e8 34 f1 ff ff       	call   80102ad5 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801039a1:	e8 24 d2 ff ff       	call   80100bca <consoleinit>
  uartinit();      // serial port
801039a6:	e8 70 4b 00 00       	call   8010851b <uartinit>
  pinit();         // process table
801039ab:	e8 5d 0b 00 00       	call   8010450d <pinit>
  tvinit();        // trap vectors
801039b0:	e8 3f 47 00 00       	call   801080f4 <tvinit>
  binit();         // buffer cache
801039b5:	e8 7a c6 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801039ba:	e8 67 d6 ff ff       	call   80101026 <fileinit>
  ideinit();       // disk
801039bf:	e8 19 ed ff ff       	call   801026dd <ideinit>
  if(!ismp)
801039c4:	a1 64 43 11 80       	mov    0x80114364,%eax
801039c9:	85 c0                	test   %eax,%eax
801039cb:	75 05                	jne    801039d2 <main+0x92>
    timerinit();   // uniprocessor timer
801039cd:	e8 73 46 00 00       	call   80108045 <timerinit>
  startothers();   // start other processors
801039d2:	e8 7f 00 00 00       	call   80103a56 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039d7:	83 ec 08             	sub    $0x8,%esp
801039da:	68 00 00 00 8e       	push   $0x8e000000
801039df:	68 00 00 40 80       	push   $0x80400000
801039e4:	e8 30 f2 ff ff       	call   80102c19 <kinit2>
801039e9:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801039ec:	e8 1e 0d 00 00       	call   8010470f <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801039f1:	e8 1a 00 00 00       	call   80103a10 <mpmain>

801039f6 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801039f6:	55                   	push   %ebp
801039f7:	89 e5                	mov    %esp,%ebp
801039f9:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
801039fc:	e8 2d 5e 00 00       	call   8010982e <switchkvm>
  seginit();
80103a01:	e8 b9 57 00 00       	call   801091bf <seginit>
  lapicinit();
80103a06:	e8 54 f5 ff ff       	call   80102f5f <lapicinit>
  mpmain();
80103a0b:	e8 00 00 00 00       	call   80103a10 <mpmain>

80103a10 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103a16:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a1c:	0f b6 00             	movzbl (%eax),%eax
80103a1f:	0f b6 c0             	movzbl %al,%eax
80103a22:	83 ec 08             	sub    $0x8,%esp
80103a25:	50                   	push   %eax
80103a26:	68 5f a2 10 80       	push   $0x8010a25f
80103a2b:	e8 96 c9 ff ff       	call   801003c6 <cprintf>
80103a30:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a33:	e8 1d 48 00 00       	call   80108255 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a38:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a3e:	05 a8 00 00 00       	add    $0xa8,%eax
80103a43:	83 ec 08             	sub    $0x8,%esp
80103a46:	6a 01                	push   $0x1
80103a48:	50                   	push   %eax
80103a49:	e8 d8 fe ff ff       	call   80103926 <xchg>
80103a4e:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a51:	e8 35 17 00 00       	call   8010518b <scheduler>

80103a56 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103a56:	55                   	push   %ebp
80103a57:	89 e5                	mov    %esp,%ebp
80103a59:	53                   	push   %ebx
80103a5a:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103a5d:	68 00 70 00 00       	push   $0x7000
80103a62:	e8 b2 fe ff ff       	call   80103919 <p2v>
80103a67:	83 c4 04             	add    $0x4,%esp
80103a6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103a6d:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103a72:	83 ec 04             	sub    $0x4,%esp
80103a75:	50                   	push   %eax
80103a76:	68 2c d5 10 80       	push   $0x8010d52c
80103a7b:	ff 75 f0             	pushl  -0x10(%ebp)
80103a7e:	e8 14 31 00 00       	call   80106b97 <memmove>
80103a83:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103a86:	c7 45 f4 80 43 11 80 	movl   $0x80114380,-0xc(%ebp)
80103a8d:	e9 90 00 00 00       	jmp    80103b22 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103a92:	e8 e6 f5 ff ff       	call   8010307d <cpunum>
80103a97:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a9d:	05 80 43 11 80       	add    $0x80114380,%eax
80103aa2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103aa5:	74 73                	je     80103b1a <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103aa7:	e8 6b f2 ff ff       	call   80102d17 <kalloc>
80103aac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ab2:	83 e8 04             	sub    $0x4,%eax
80103ab5:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103ab8:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103abe:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ac3:	83 e8 08             	sub    $0x8,%eax
80103ac6:	c7 00 f6 39 10 80    	movl   $0x801039f6,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103acc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103acf:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103ad2:	83 ec 0c             	sub    $0xc,%esp
80103ad5:	68 00 c0 10 80       	push   $0x8010c000
80103ada:	e8 2d fe ff ff       	call   8010390c <v2p>
80103adf:	83 c4 10             	add    $0x10,%esp
80103ae2:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103ae4:	83 ec 0c             	sub    $0xc,%esp
80103ae7:	ff 75 f0             	pushl  -0x10(%ebp)
80103aea:	e8 1d fe ff ff       	call   8010390c <v2p>
80103aef:	83 c4 10             	add    $0x10,%esp
80103af2:	89 c2                	mov    %eax,%edx
80103af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103af7:	0f b6 00             	movzbl (%eax),%eax
80103afa:	0f b6 c0             	movzbl %al,%eax
80103afd:	83 ec 08             	sub    $0x8,%esp
80103b00:	52                   	push   %edx
80103b01:	50                   	push   %eax
80103b02:	e8 f0 f5 ff ff       	call   801030f7 <lapicstartap>
80103b07:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103b0a:	90                   	nop
80103b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b0e:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103b14:	85 c0                	test   %eax,%eax
80103b16:	74 f3                	je     80103b0b <startothers+0xb5>
80103b18:	eb 01                	jmp    80103b1b <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103b1a:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103b1b:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103b22:	a1 60 49 11 80       	mov    0x80114960,%eax
80103b27:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103b2d:	05 80 43 11 80       	add    $0x80114380,%eax
80103b32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b35:	0f 87 57 ff ff ff    	ja     80103a92 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103b3b:	90                   	nop
80103b3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b3f:	c9                   	leave  
80103b40:	c3                   	ret    

80103b41 <p2v>:
80103b41:	55                   	push   %ebp
80103b42:	89 e5                	mov    %esp,%ebp
80103b44:	8b 45 08             	mov    0x8(%ebp),%eax
80103b47:	05 00 00 00 80       	add    $0x80000000,%eax
80103b4c:	5d                   	pop    %ebp
80103b4d:	c3                   	ret    

80103b4e <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103b4e:	55                   	push   %ebp
80103b4f:	89 e5                	mov    %esp,%ebp
80103b51:	83 ec 14             	sub    $0x14,%esp
80103b54:	8b 45 08             	mov    0x8(%ebp),%eax
80103b57:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103b5b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103b5f:	89 c2                	mov    %eax,%edx
80103b61:	ec                   	in     (%dx),%al
80103b62:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103b65:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103b69:	c9                   	leave  
80103b6a:	c3                   	ret    

80103b6b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103b6b:	55                   	push   %ebp
80103b6c:	89 e5                	mov    %esp,%ebp
80103b6e:	83 ec 08             	sub    $0x8,%esp
80103b71:	8b 55 08             	mov    0x8(%ebp),%edx
80103b74:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b77:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103b7b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103b7e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103b82:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103b86:	ee                   	out    %al,(%dx)
}
80103b87:	90                   	nop
80103b88:	c9                   	leave  
80103b89:	c3                   	ret    

80103b8a <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103b8a:	55                   	push   %ebp
80103b8b:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103b8d:	a1 64 d6 10 80       	mov    0x8010d664,%eax
80103b92:	89 c2                	mov    %eax,%edx
80103b94:	b8 80 43 11 80       	mov    $0x80114380,%eax
80103b99:	29 c2                	sub    %eax,%edx
80103b9b:	89 d0                	mov    %edx,%eax
80103b9d:	c1 f8 02             	sar    $0x2,%eax
80103ba0:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103ba6:	5d                   	pop    %ebp
80103ba7:	c3                   	ret    

80103ba8 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103ba8:	55                   	push   %ebp
80103ba9:	89 e5                	mov    %esp,%ebp
80103bab:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103bae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103bb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103bbc:	eb 15                	jmp    80103bd3 <sum+0x2b>
    sum += addr[i];
80103bbe:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103bc1:	8b 45 08             	mov    0x8(%ebp),%eax
80103bc4:	01 d0                	add    %edx,%eax
80103bc6:	0f b6 00             	movzbl (%eax),%eax
80103bc9:	0f b6 c0             	movzbl %al,%eax
80103bcc:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103bcf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103bd6:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103bd9:	7c e3                	jl     80103bbe <sum+0x16>
    sum += addr[i];
  return sum;
80103bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103bde:	c9                   	leave  
80103bdf:	c3                   	ret    

80103be0 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103be6:	ff 75 08             	pushl  0x8(%ebp)
80103be9:	e8 53 ff ff ff       	call   80103b41 <p2v>
80103bee:	83 c4 04             	add    $0x4,%esp
80103bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103bf4:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bfa:	01 d0                	add    %edx,%eax
80103bfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c05:	eb 36                	jmp    80103c3d <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c07:	83 ec 04             	sub    $0x4,%esp
80103c0a:	6a 04                	push   $0x4
80103c0c:	68 70 a2 10 80       	push   $0x8010a270
80103c11:	ff 75 f4             	pushl  -0xc(%ebp)
80103c14:	e8 26 2f 00 00       	call   80106b3f <memcmp>
80103c19:	83 c4 10             	add    $0x10,%esp
80103c1c:	85 c0                	test   %eax,%eax
80103c1e:	75 19                	jne    80103c39 <mpsearch1+0x59>
80103c20:	83 ec 08             	sub    $0x8,%esp
80103c23:	6a 10                	push   $0x10
80103c25:	ff 75 f4             	pushl  -0xc(%ebp)
80103c28:	e8 7b ff ff ff       	call   80103ba8 <sum>
80103c2d:	83 c4 10             	add    $0x10,%esp
80103c30:	84 c0                	test   %al,%al
80103c32:	75 05                	jne    80103c39 <mpsearch1+0x59>
      return (struct mp*)p;
80103c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c37:	eb 11                	jmp    80103c4a <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103c39:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c40:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103c43:	72 c2                	jb     80103c07 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103c45:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103c4a:	c9                   	leave  
80103c4b:	c3                   	ret    

80103c4c <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103c4c:	55                   	push   %ebp
80103c4d:	89 e5                	mov    %esp,%ebp
80103c4f:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103c52:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c5c:	83 c0 0f             	add    $0xf,%eax
80103c5f:	0f b6 00             	movzbl (%eax),%eax
80103c62:	0f b6 c0             	movzbl %al,%eax
80103c65:	c1 e0 08             	shl    $0x8,%eax
80103c68:	89 c2                	mov    %eax,%edx
80103c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c6d:	83 c0 0e             	add    $0xe,%eax
80103c70:	0f b6 00             	movzbl (%eax),%eax
80103c73:	0f b6 c0             	movzbl %al,%eax
80103c76:	09 d0                	or     %edx,%eax
80103c78:	c1 e0 04             	shl    $0x4,%eax
80103c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103c7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c82:	74 21                	je     80103ca5 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103c84:	83 ec 08             	sub    $0x8,%esp
80103c87:	68 00 04 00 00       	push   $0x400
80103c8c:	ff 75 f0             	pushl  -0x10(%ebp)
80103c8f:	e8 4c ff ff ff       	call   80103be0 <mpsearch1>
80103c94:	83 c4 10             	add    $0x10,%esp
80103c97:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c9e:	74 51                	je     80103cf1 <mpsearch+0xa5>
      return mp;
80103ca0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ca3:	eb 61                	jmp    80103d06 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca8:	83 c0 14             	add    $0x14,%eax
80103cab:	0f b6 00             	movzbl (%eax),%eax
80103cae:	0f b6 c0             	movzbl %al,%eax
80103cb1:	c1 e0 08             	shl    $0x8,%eax
80103cb4:	89 c2                	mov    %eax,%edx
80103cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb9:	83 c0 13             	add    $0x13,%eax
80103cbc:	0f b6 00             	movzbl (%eax),%eax
80103cbf:	0f b6 c0             	movzbl %al,%eax
80103cc2:	09 d0                	or     %edx,%eax
80103cc4:	c1 e0 0a             	shl    $0xa,%eax
80103cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103cca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ccd:	2d 00 04 00 00       	sub    $0x400,%eax
80103cd2:	83 ec 08             	sub    $0x8,%esp
80103cd5:	68 00 04 00 00       	push   $0x400
80103cda:	50                   	push   %eax
80103cdb:	e8 00 ff ff ff       	call   80103be0 <mpsearch1>
80103ce0:	83 c4 10             	add    $0x10,%esp
80103ce3:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103ce6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103cea:	74 05                	je     80103cf1 <mpsearch+0xa5>
      return mp;
80103cec:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103cef:	eb 15                	jmp    80103d06 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103cf1:	83 ec 08             	sub    $0x8,%esp
80103cf4:	68 00 00 01 00       	push   $0x10000
80103cf9:	68 00 00 0f 00       	push   $0xf0000
80103cfe:	e8 dd fe ff ff       	call   80103be0 <mpsearch1>
80103d03:	83 c4 10             	add    $0x10,%esp
}
80103d06:	c9                   	leave  
80103d07:	c3                   	ret    

80103d08 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103d08:	55                   	push   %ebp
80103d09:	89 e5                	mov    %esp,%ebp
80103d0b:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103d0e:	e8 39 ff ff ff       	call   80103c4c <mpsearch>
80103d13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d1a:	74 0a                	je     80103d26 <mpconfig+0x1e>
80103d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d1f:	8b 40 04             	mov    0x4(%eax),%eax
80103d22:	85 c0                	test   %eax,%eax
80103d24:	75 0a                	jne    80103d30 <mpconfig+0x28>
    return 0;
80103d26:	b8 00 00 00 00       	mov    $0x0,%eax
80103d2b:	e9 81 00 00 00       	jmp    80103db1 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d33:	8b 40 04             	mov    0x4(%eax),%eax
80103d36:	83 ec 0c             	sub    $0xc,%esp
80103d39:	50                   	push   %eax
80103d3a:	e8 02 fe ff ff       	call   80103b41 <p2v>
80103d3f:	83 c4 10             	add    $0x10,%esp
80103d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d45:	83 ec 04             	sub    $0x4,%esp
80103d48:	6a 04                	push   $0x4
80103d4a:	68 75 a2 10 80       	push   $0x8010a275
80103d4f:	ff 75 f0             	pushl  -0x10(%ebp)
80103d52:	e8 e8 2d 00 00       	call   80106b3f <memcmp>
80103d57:	83 c4 10             	add    $0x10,%esp
80103d5a:	85 c0                	test   %eax,%eax
80103d5c:	74 07                	je     80103d65 <mpconfig+0x5d>
    return 0;
80103d5e:	b8 00 00 00 00       	mov    $0x0,%eax
80103d63:	eb 4c                	jmp    80103db1 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d68:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d6c:	3c 01                	cmp    $0x1,%al
80103d6e:	74 12                	je     80103d82 <mpconfig+0x7a>
80103d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d73:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103d77:	3c 04                	cmp    $0x4,%al
80103d79:	74 07                	je     80103d82 <mpconfig+0x7a>
    return 0;
80103d7b:	b8 00 00 00 00       	mov    $0x0,%eax
80103d80:	eb 2f                	jmp    80103db1 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103d82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d85:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d89:	0f b7 c0             	movzwl %ax,%eax
80103d8c:	83 ec 08             	sub    $0x8,%esp
80103d8f:	50                   	push   %eax
80103d90:	ff 75 f0             	pushl  -0x10(%ebp)
80103d93:	e8 10 fe ff ff       	call   80103ba8 <sum>
80103d98:	83 c4 10             	add    $0x10,%esp
80103d9b:	84 c0                	test   %al,%al
80103d9d:	74 07                	je     80103da6 <mpconfig+0x9e>
    return 0;
80103d9f:	b8 00 00 00 00       	mov    $0x0,%eax
80103da4:	eb 0b                	jmp    80103db1 <mpconfig+0xa9>
  *pmp = mp;
80103da6:	8b 45 08             	mov    0x8(%ebp),%eax
80103da9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103dac:	89 10                	mov    %edx,(%eax)
  return conf;
80103dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103db1:	c9                   	leave  
80103db2:	c3                   	ret    

80103db3 <mpinit>:

void
mpinit(void)
{
80103db3:	55                   	push   %ebp
80103db4:	89 e5                	mov    %esp,%ebp
80103db6:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103db9:	c7 05 64 d6 10 80 80 	movl   $0x80114380,0x8010d664
80103dc0:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103dc3:	83 ec 0c             	sub    $0xc,%esp
80103dc6:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103dc9:	50                   	push   %eax
80103dca:	e8 39 ff ff ff       	call   80103d08 <mpconfig>
80103dcf:	83 c4 10             	add    $0x10,%esp
80103dd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103dd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103dd9:	0f 84 96 01 00 00    	je     80103f75 <mpinit+0x1c2>
    return;
  ismp = 1;
80103ddf:	c7 05 64 43 11 80 01 	movl   $0x1,0x80114364
80103de6:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103de9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103dec:	8b 40 24             	mov    0x24(%eax),%eax
80103def:	a3 7c 42 11 80       	mov    %eax,0x8011427c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103df7:	83 c0 2c             	add    $0x2c,%eax
80103dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e00:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103e04:	0f b7 d0             	movzwl %ax,%edx
80103e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e0a:	01 d0                	add    %edx,%eax
80103e0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103e0f:	e9 f2 00 00 00       	jmp    80103f06 <mpinit+0x153>
    switch(*p){
80103e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e17:	0f b6 00             	movzbl (%eax),%eax
80103e1a:	0f b6 c0             	movzbl %al,%eax
80103e1d:	83 f8 04             	cmp    $0x4,%eax
80103e20:	0f 87 bc 00 00 00    	ja     80103ee2 <mpinit+0x12f>
80103e26:	8b 04 85 b8 a2 10 80 	mov    -0x7fef5d48(,%eax,4),%eax
80103e2d:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103e2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e32:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103e35:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e38:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e3c:	0f b6 d0             	movzbl %al,%edx
80103e3f:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e44:	39 c2                	cmp    %eax,%edx
80103e46:	74 2b                	je     80103e73 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103e48:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e4b:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e4f:	0f b6 d0             	movzbl %al,%edx
80103e52:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e57:	83 ec 04             	sub    $0x4,%esp
80103e5a:	52                   	push   %edx
80103e5b:	50                   	push   %eax
80103e5c:	68 7a a2 10 80       	push   $0x8010a27a
80103e61:	e8 60 c5 ff ff       	call   801003c6 <cprintf>
80103e66:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103e69:	c7 05 64 43 11 80 00 	movl   $0x0,0x80114364
80103e70:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103e73:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e76:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103e7a:	0f b6 c0             	movzbl %al,%eax
80103e7d:	83 e0 02             	and    $0x2,%eax
80103e80:	85 c0                	test   %eax,%eax
80103e82:	74 15                	je     80103e99 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80103e84:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e89:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e8f:	05 80 43 11 80       	add    $0x80114380,%eax
80103e94:	a3 64 d6 10 80       	mov    %eax,0x8010d664
      cpus[ncpu].id = ncpu;
80103e99:	a1 60 49 11 80       	mov    0x80114960,%eax
80103e9e:	8b 15 60 49 11 80    	mov    0x80114960,%edx
80103ea4:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103eaa:	05 80 43 11 80       	add    $0x80114380,%eax
80103eaf:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103eb1:	a1 60 49 11 80       	mov    0x80114960,%eax
80103eb6:	83 c0 01             	add    $0x1,%eax
80103eb9:	a3 60 49 11 80       	mov    %eax,0x80114960
      p += sizeof(struct mpproc);
80103ebe:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103ec2:	eb 42                	jmp    80103f06 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ec7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103eca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ecd:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103ed1:	a2 60 43 11 80       	mov    %al,0x80114360
      p += sizeof(struct mpioapic);
80103ed6:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103eda:	eb 2a                	jmp    80103f06 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103edc:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ee0:	eb 24                	jmp    80103f06 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ee5:	0f b6 00             	movzbl (%eax),%eax
80103ee8:	0f b6 c0             	movzbl %al,%eax
80103eeb:	83 ec 08             	sub    $0x8,%esp
80103eee:	50                   	push   %eax
80103eef:	68 98 a2 10 80       	push   $0x8010a298
80103ef4:	e8 cd c4 ff ff       	call   801003c6 <cprintf>
80103ef9:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103efc:	c7 05 64 43 11 80 00 	movl   $0x0,0x80114364
80103f03:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f09:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103f0c:	0f 82 02 ff ff ff    	jb     80103e14 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103f12:	a1 64 43 11 80       	mov    0x80114364,%eax
80103f17:	85 c0                	test   %eax,%eax
80103f19:	75 1d                	jne    80103f38 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103f1b:	c7 05 60 49 11 80 01 	movl   $0x1,0x80114960
80103f22:	00 00 00 
    lapic = 0;
80103f25:	c7 05 7c 42 11 80 00 	movl   $0x0,0x8011427c
80103f2c:	00 00 00 
    ioapicid = 0;
80103f2f:	c6 05 60 43 11 80 00 	movb   $0x0,0x80114360
    return;
80103f36:	eb 3e                	jmp    80103f76 <mpinit+0x1c3>
  }

  if(mp->imcrp){
80103f38:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103f3b:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103f3f:	84 c0                	test   %al,%al
80103f41:	74 33                	je     80103f76 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103f43:	83 ec 08             	sub    $0x8,%esp
80103f46:	6a 70                	push   $0x70
80103f48:	6a 22                	push   $0x22
80103f4a:	e8 1c fc ff ff       	call   80103b6b <outb>
80103f4f:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103f52:	83 ec 0c             	sub    $0xc,%esp
80103f55:	6a 23                	push   $0x23
80103f57:	e8 f2 fb ff ff       	call   80103b4e <inb>
80103f5c:	83 c4 10             	add    $0x10,%esp
80103f5f:	83 c8 01             	or     $0x1,%eax
80103f62:	0f b6 c0             	movzbl %al,%eax
80103f65:	83 ec 08             	sub    $0x8,%esp
80103f68:	50                   	push   %eax
80103f69:	6a 23                	push   $0x23
80103f6b:	e8 fb fb ff ff       	call   80103b6b <outb>
80103f70:	83 c4 10             	add    $0x10,%esp
80103f73:	eb 01                	jmp    80103f76 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103f75:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103f76:	c9                   	leave  
80103f77:	c3                   	ret    

80103f78 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103f78:	55                   	push   %ebp
80103f79:	89 e5                	mov    %esp,%ebp
80103f7b:	83 ec 08             	sub    $0x8,%esp
80103f7e:	8b 55 08             	mov    0x8(%ebp),%edx
80103f81:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f84:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103f88:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f8b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f8f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f93:	ee                   	out    %al,(%dx)
}
80103f94:	90                   	nop
80103f95:	c9                   	leave  
80103f96:	c3                   	ret    

80103f97 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103f97:	55                   	push   %ebp
80103f98:	89 e5                	mov    %esp,%ebp
80103f9a:	83 ec 04             	sub    $0x4,%esp
80103f9d:	8b 45 08             	mov    0x8(%ebp),%eax
80103fa0:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103fa4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fa8:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80103fae:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fb2:	0f b6 c0             	movzbl %al,%eax
80103fb5:	50                   	push   %eax
80103fb6:	6a 21                	push   $0x21
80103fb8:	e8 bb ff ff ff       	call   80103f78 <outb>
80103fbd:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103fc0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103fc4:	66 c1 e8 08          	shr    $0x8,%ax
80103fc8:	0f b6 c0             	movzbl %al,%eax
80103fcb:	50                   	push   %eax
80103fcc:	68 a1 00 00 00       	push   $0xa1
80103fd1:	e8 a2 ff ff ff       	call   80103f78 <outb>
80103fd6:	83 c4 08             	add    $0x8,%esp
}
80103fd9:	90                   	nop
80103fda:	c9                   	leave  
80103fdb:	c3                   	ret    

80103fdc <picenable>:

void
picenable(int irq)
{
80103fdc:	55                   	push   %ebp
80103fdd:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe2:	ba 01 00 00 00       	mov    $0x1,%edx
80103fe7:	89 c1                	mov    %eax,%ecx
80103fe9:	d3 e2                	shl    %cl,%edx
80103feb:	89 d0                	mov    %edx,%eax
80103fed:	f7 d0                	not    %eax
80103fef:	89 c2                	mov    %eax,%edx
80103ff1:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80103ff8:	21 d0                	and    %edx,%eax
80103ffa:	0f b7 c0             	movzwl %ax,%eax
80103ffd:	50                   	push   %eax
80103ffe:	e8 94 ff ff ff       	call   80103f97 <picsetmask>
80104003:	83 c4 04             	add    $0x4,%esp
}
80104006:	90                   	nop
80104007:	c9                   	leave  
80104008:	c3                   	ret    

80104009 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80104009:	55                   	push   %ebp
8010400a:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
8010400c:	68 ff 00 00 00       	push   $0xff
80104011:	6a 21                	push   $0x21
80104013:	e8 60 ff ff ff       	call   80103f78 <outb>
80104018:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
8010401b:	68 ff 00 00 00       	push   $0xff
80104020:	68 a1 00 00 00       	push   $0xa1
80104025:	e8 4e ff ff ff       	call   80103f78 <outb>
8010402a:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
8010402d:	6a 11                	push   $0x11
8010402f:	6a 20                	push   $0x20
80104031:	e8 42 ff ff ff       	call   80103f78 <outb>
80104036:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80104039:	6a 20                	push   $0x20
8010403b:	6a 21                	push   $0x21
8010403d:	e8 36 ff ff ff       	call   80103f78 <outb>
80104042:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80104045:	6a 04                	push   $0x4
80104047:	6a 21                	push   $0x21
80104049:	e8 2a ff ff ff       	call   80103f78 <outb>
8010404e:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80104051:	6a 03                	push   $0x3
80104053:	6a 21                	push   $0x21
80104055:	e8 1e ff ff ff       	call   80103f78 <outb>
8010405a:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
8010405d:	6a 11                	push   $0x11
8010405f:	68 a0 00 00 00       	push   $0xa0
80104064:	e8 0f ff ff ff       	call   80103f78 <outb>
80104069:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
8010406c:	6a 28                	push   $0x28
8010406e:	68 a1 00 00 00       	push   $0xa1
80104073:	e8 00 ff ff ff       	call   80103f78 <outb>
80104078:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
8010407b:	6a 02                	push   $0x2
8010407d:	68 a1 00 00 00       	push   $0xa1
80104082:	e8 f1 fe ff ff       	call   80103f78 <outb>
80104087:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
8010408a:	6a 03                	push   $0x3
8010408c:	68 a1 00 00 00       	push   $0xa1
80104091:	e8 e2 fe ff ff       	call   80103f78 <outb>
80104096:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104099:	6a 68                	push   $0x68
8010409b:	6a 20                	push   $0x20
8010409d:	e8 d6 fe ff ff       	call   80103f78 <outb>
801040a2:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
801040a5:	6a 0a                	push   $0xa
801040a7:	6a 20                	push   $0x20
801040a9:	e8 ca fe ff ff       	call   80103f78 <outb>
801040ae:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
801040b1:	6a 68                	push   $0x68
801040b3:	68 a0 00 00 00       	push   $0xa0
801040b8:	e8 bb fe ff ff       	call   80103f78 <outb>
801040bd:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
801040c0:	6a 0a                	push   $0xa
801040c2:	68 a0 00 00 00       	push   $0xa0
801040c7:	e8 ac fe ff ff       	call   80103f78 <outb>
801040cc:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
801040cf:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801040d6:	66 83 f8 ff          	cmp    $0xffff,%ax
801040da:	74 13                	je     801040ef <picinit+0xe6>
    picsetmask(irqmask);
801040dc:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
801040e3:	0f b7 c0             	movzwl %ax,%eax
801040e6:	50                   	push   %eax
801040e7:	e8 ab fe ff ff       	call   80103f97 <picsetmask>
801040ec:	83 c4 04             	add    $0x4,%esp
}
801040ef:	90                   	nop
801040f0:	c9                   	leave  
801040f1:	c3                   	ret    

801040f2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801040f2:	55                   	push   %ebp
801040f3:	89 e5                	mov    %esp,%ebp
801040f5:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
801040f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
801040ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80104102:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104108:	8b 45 0c             	mov    0xc(%ebp),%eax
8010410b:	8b 10                	mov    (%eax),%edx
8010410d:	8b 45 08             	mov    0x8(%ebp),%eax
80104110:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104112:	e8 2d cf ff ff       	call   80101044 <filealloc>
80104117:	89 c2                	mov    %eax,%edx
80104119:	8b 45 08             	mov    0x8(%ebp),%eax
8010411c:	89 10                	mov    %edx,(%eax)
8010411e:	8b 45 08             	mov    0x8(%ebp),%eax
80104121:	8b 00                	mov    (%eax),%eax
80104123:	85 c0                	test   %eax,%eax
80104125:	0f 84 cb 00 00 00    	je     801041f6 <pipealloc+0x104>
8010412b:	e8 14 cf ff ff       	call   80101044 <filealloc>
80104130:	89 c2                	mov    %eax,%edx
80104132:	8b 45 0c             	mov    0xc(%ebp),%eax
80104135:	89 10                	mov    %edx,(%eax)
80104137:	8b 45 0c             	mov    0xc(%ebp),%eax
8010413a:	8b 00                	mov    (%eax),%eax
8010413c:	85 c0                	test   %eax,%eax
8010413e:	0f 84 b2 00 00 00    	je     801041f6 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80104144:	e8 ce eb ff ff       	call   80102d17 <kalloc>
80104149:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010414c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104150:	0f 84 9f 00 00 00    	je     801041f5 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
80104156:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104159:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80104160:	00 00 00 
  p->writeopen = 1;
80104163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104166:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010416d:	00 00 00 
  p->nwrite = 0;
80104170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104173:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010417a:	00 00 00 
  p->nread = 0;
8010417d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104180:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104187:	00 00 00 
  initlock(&p->lock, "pipe");
8010418a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010418d:	83 ec 08             	sub    $0x8,%esp
80104190:	68 cc a2 10 80       	push   $0x8010a2cc
80104195:	50                   	push   %eax
80104196:	e8 b8 26 00 00       	call   80106853 <initlock>
8010419b:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010419e:	8b 45 08             	mov    0x8(%ebp),%eax
801041a1:	8b 00                	mov    (%eax),%eax
801041a3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801041a9:	8b 45 08             	mov    0x8(%ebp),%eax
801041ac:	8b 00                	mov    (%eax),%eax
801041ae:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801041b2:	8b 45 08             	mov    0x8(%ebp),%eax
801041b5:	8b 00                	mov    (%eax),%eax
801041b7:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801041bb:	8b 45 08             	mov    0x8(%ebp),%eax
801041be:	8b 00                	mov    (%eax),%eax
801041c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041c3:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
801041c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801041c9:	8b 00                	mov    (%eax),%eax
801041cb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801041d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801041d4:	8b 00                	mov    (%eax),%eax
801041d6:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801041da:	8b 45 0c             	mov    0xc(%ebp),%eax
801041dd:	8b 00                	mov    (%eax),%eax
801041df:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801041e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801041e6:	8b 00                	mov    (%eax),%eax
801041e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041eb:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
801041ee:	b8 00 00 00 00       	mov    $0x0,%eax
801041f3:	eb 4e                	jmp    80104243 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
801041f5:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
801041f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801041fa:	74 0e                	je     8010420a <pipealloc+0x118>
    kfree((char*)p);
801041fc:	83 ec 0c             	sub    $0xc,%esp
801041ff:	ff 75 f4             	pushl  -0xc(%ebp)
80104202:	e8 73 ea ff ff       	call   80102c7a <kfree>
80104207:	83 c4 10             	add    $0x10,%esp
  if(*f0)
8010420a:	8b 45 08             	mov    0x8(%ebp),%eax
8010420d:	8b 00                	mov    (%eax),%eax
8010420f:	85 c0                	test   %eax,%eax
80104211:	74 11                	je     80104224 <pipealloc+0x132>
    fileclose(*f0);
80104213:	8b 45 08             	mov    0x8(%ebp),%eax
80104216:	8b 00                	mov    (%eax),%eax
80104218:	83 ec 0c             	sub    $0xc,%esp
8010421b:	50                   	push   %eax
8010421c:	e8 e1 ce ff ff       	call   80101102 <fileclose>
80104221:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80104224:	8b 45 0c             	mov    0xc(%ebp),%eax
80104227:	8b 00                	mov    (%eax),%eax
80104229:	85 c0                	test   %eax,%eax
8010422b:	74 11                	je     8010423e <pipealloc+0x14c>
    fileclose(*f1);
8010422d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104230:	8b 00                	mov    (%eax),%eax
80104232:	83 ec 0c             	sub    $0xc,%esp
80104235:	50                   	push   %eax
80104236:	e8 c7 ce ff ff       	call   80101102 <fileclose>
8010423b:	83 c4 10             	add    $0x10,%esp
  return -1;
8010423e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104243:	c9                   	leave  
80104244:	c3                   	ret    

80104245 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80104245:	55                   	push   %ebp
80104246:	89 e5                	mov    %esp,%ebp
80104248:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
8010424b:	8b 45 08             	mov    0x8(%ebp),%eax
8010424e:	83 ec 0c             	sub    $0xc,%esp
80104251:	50                   	push   %eax
80104252:	e8 1e 26 00 00       	call   80106875 <acquire>
80104257:	83 c4 10             	add    $0x10,%esp
  if(writable){
8010425a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010425e:	74 23                	je     80104283 <pipeclose+0x3e>
    p->writeopen = 0;
80104260:	8b 45 08             	mov    0x8(%ebp),%eax
80104263:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
8010426a:	00 00 00 
    wakeup(&p->nread);
8010426d:	8b 45 08             	mov    0x8(%ebp),%eax
80104270:	05 34 02 00 00       	add    $0x234,%eax
80104275:	83 ec 0c             	sub    $0xc,%esp
80104278:	50                   	push   %eax
80104279:	e8 69 15 00 00       	call   801057e7 <wakeup>
8010427e:	83 c4 10             	add    $0x10,%esp
80104281:	eb 21                	jmp    801042a4 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104283:	8b 45 08             	mov    0x8(%ebp),%eax
80104286:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010428d:	00 00 00 
    wakeup(&p->nwrite);
80104290:	8b 45 08             	mov    0x8(%ebp),%eax
80104293:	05 38 02 00 00       	add    $0x238,%eax
80104298:	83 ec 0c             	sub    $0xc,%esp
8010429b:	50                   	push   %eax
8010429c:	e8 46 15 00 00       	call   801057e7 <wakeup>
801042a1:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
801042a4:	8b 45 08             	mov    0x8(%ebp),%eax
801042a7:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801042ad:	85 c0                	test   %eax,%eax
801042af:	75 2c                	jne    801042dd <pipeclose+0x98>
801042b1:	8b 45 08             	mov    0x8(%ebp),%eax
801042b4:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801042ba:	85 c0                	test   %eax,%eax
801042bc:	75 1f                	jne    801042dd <pipeclose+0x98>
    release(&p->lock);
801042be:	8b 45 08             	mov    0x8(%ebp),%eax
801042c1:	83 ec 0c             	sub    $0xc,%esp
801042c4:	50                   	push   %eax
801042c5:	e8 12 26 00 00       	call   801068dc <release>
801042ca:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
801042cd:	83 ec 0c             	sub    $0xc,%esp
801042d0:	ff 75 08             	pushl  0x8(%ebp)
801042d3:	e8 a2 e9 ff ff       	call   80102c7a <kfree>
801042d8:	83 c4 10             	add    $0x10,%esp
801042db:	eb 0f                	jmp    801042ec <pipeclose+0xa7>
  } else
    release(&p->lock);
801042dd:	8b 45 08             	mov    0x8(%ebp),%eax
801042e0:	83 ec 0c             	sub    $0xc,%esp
801042e3:	50                   	push   %eax
801042e4:	e8 f3 25 00 00       	call   801068dc <release>
801042e9:	83 c4 10             	add    $0x10,%esp
}
801042ec:	90                   	nop
801042ed:	c9                   	leave  
801042ee:	c3                   	ret    

801042ef <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801042ef:	55                   	push   %ebp
801042f0:	89 e5                	mov    %esp,%ebp
801042f2:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
801042f5:	8b 45 08             	mov    0x8(%ebp),%eax
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	50                   	push   %eax
801042fc:	e8 74 25 00 00       	call   80106875 <acquire>
80104301:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104304:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010430b:	e9 ad 00 00 00       	jmp    801043bd <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104310:	8b 45 08             	mov    0x8(%ebp),%eax
80104313:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104319:	85 c0                	test   %eax,%eax
8010431b:	74 0d                	je     8010432a <pipewrite+0x3b>
8010431d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104323:	8b 40 24             	mov    0x24(%eax),%eax
80104326:	85 c0                	test   %eax,%eax
80104328:	74 19                	je     80104343 <pipewrite+0x54>
        release(&p->lock);
8010432a:	8b 45 08             	mov    0x8(%ebp),%eax
8010432d:	83 ec 0c             	sub    $0xc,%esp
80104330:	50                   	push   %eax
80104331:	e8 a6 25 00 00       	call   801068dc <release>
80104336:	83 c4 10             	add    $0x10,%esp
        return -1;
80104339:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010433e:	e9 a8 00 00 00       	jmp    801043eb <pipewrite+0xfc>
      }
      wakeup(&p->nread);
80104343:	8b 45 08             	mov    0x8(%ebp),%eax
80104346:	05 34 02 00 00       	add    $0x234,%eax
8010434b:	83 ec 0c             	sub    $0xc,%esp
8010434e:	50                   	push   %eax
8010434f:	e8 93 14 00 00       	call   801057e7 <wakeup>
80104354:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104357:	8b 45 08             	mov    0x8(%ebp),%eax
8010435a:	8b 55 08             	mov    0x8(%ebp),%edx
8010435d:	81 c2 38 02 00 00    	add    $0x238,%edx
80104363:	83 ec 08             	sub    $0x8,%esp
80104366:	50                   	push   %eax
80104367:	52                   	push   %edx
80104368:	e8 1f 12 00 00       	call   8010558c <sleep>
8010436d:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104370:	8b 45 08             	mov    0x8(%ebp),%eax
80104373:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104379:	8b 45 08             	mov    0x8(%ebp),%eax
8010437c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104382:	05 00 02 00 00       	add    $0x200,%eax
80104387:	39 c2                	cmp    %eax,%edx
80104389:	74 85                	je     80104310 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010438b:	8b 45 08             	mov    0x8(%ebp),%eax
8010438e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104394:	8d 48 01             	lea    0x1(%eax),%ecx
80104397:	8b 55 08             	mov    0x8(%ebp),%edx
8010439a:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801043a0:	25 ff 01 00 00       	and    $0x1ff,%eax
801043a5:	89 c1                	mov    %eax,%ecx
801043a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ad:	01 d0                	add    %edx,%eax
801043af:	0f b6 10             	movzbl (%eax),%edx
801043b2:	8b 45 08             	mov    0x8(%ebp),%eax
801043b5:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801043b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801043bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c0:	3b 45 10             	cmp    0x10(%ebp),%eax
801043c3:	7c ab                	jl     80104370 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801043c5:	8b 45 08             	mov    0x8(%ebp),%eax
801043c8:	05 34 02 00 00       	add    $0x234,%eax
801043cd:	83 ec 0c             	sub    $0xc,%esp
801043d0:	50                   	push   %eax
801043d1:	e8 11 14 00 00       	call   801057e7 <wakeup>
801043d6:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043d9:	8b 45 08             	mov    0x8(%ebp),%eax
801043dc:	83 ec 0c             	sub    $0xc,%esp
801043df:	50                   	push   %eax
801043e0:	e8 f7 24 00 00       	call   801068dc <release>
801043e5:	83 c4 10             	add    $0x10,%esp
  return n;
801043e8:	8b 45 10             	mov    0x10(%ebp),%eax
}
801043eb:	c9                   	leave  
801043ec:	c3                   	ret    

801043ed <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801043ed:	55                   	push   %ebp
801043ee:	89 e5                	mov    %esp,%ebp
801043f0:	53                   	push   %ebx
801043f1:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
801043f4:	8b 45 08             	mov    0x8(%ebp),%eax
801043f7:	83 ec 0c             	sub    $0xc,%esp
801043fa:	50                   	push   %eax
801043fb:	e8 75 24 00 00       	call   80106875 <acquire>
80104400:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104403:	eb 3f                	jmp    80104444 <piperead+0x57>
    if(proc->killed){
80104405:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010440b:	8b 40 24             	mov    0x24(%eax),%eax
8010440e:	85 c0                	test   %eax,%eax
80104410:	74 19                	je     8010442b <piperead+0x3e>
      release(&p->lock);
80104412:	8b 45 08             	mov    0x8(%ebp),%eax
80104415:	83 ec 0c             	sub    $0xc,%esp
80104418:	50                   	push   %eax
80104419:	e8 be 24 00 00       	call   801068dc <release>
8010441e:	83 c4 10             	add    $0x10,%esp
      return -1;
80104421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104426:	e9 bf 00 00 00       	jmp    801044ea <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010442b:	8b 45 08             	mov    0x8(%ebp),%eax
8010442e:	8b 55 08             	mov    0x8(%ebp),%edx
80104431:	81 c2 34 02 00 00    	add    $0x234,%edx
80104437:	83 ec 08             	sub    $0x8,%esp
8010443a:	50                   	push   %eax
8010443b:	52                   	push   %edx
8010443c:	e8 4b 11 00 00       	call   8010558c <sleep>
80104441:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104444:	8b 45 08             	mov    0x8(%ebp),%eax
80104447:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010444d:	8b 45 08             	mov    0x8(%ebp),%eax
80104450:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104456:	39 c2                	cmp    %eax,%edx
80104458:	75 0d                	jne    80104467 <piperead+0x7a>
8010445a:	8b 45 08             	mov    0x8(%ebp),%eax
8010445d:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104463:	85 c0                	test   %eax,%eax
80104465:	75 9e                	jne    80104405 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104467:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010446e:	eb 49                	jmp    801044b9 <piperead+0xcc>
    if(p->nread == p->nwrite)
80104470:	8b 45 08             	mov    0x8(%ebp),%eax
80104473:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104479:	8b 45 08             	mov    0x8(%ebp),%eax
8010447c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104482:	39 c2                	cmp    %eax,%edx
80104484:	74 3d                	je     801044c3 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104486:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104489:	8b 45 0c             	mov    0xc(%ebp),%eax
8010448c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010448f:	8b 45 08             	mov    0x8(%ebp),%eax
80104492:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104498:	8d 48 01             	lea    0x1(%eax),%ecx
8010449b:	8b 55 08             	mov    0x8(%ebp),%edx
8010449e:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801044a4:	25 ff 01 00 00       	and    $0x1ff,%eax
801044a9:	89 c2                	mov    %eax,%edx
801044ab:	8b 45 08             	mov    0x8(%ebp),%eax
801044ae:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801044b3:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801044b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801044b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044bc:	3b 45 10             	cmp    0x10(%ebp),%eax
801044bf:	7c af                	jl     80104470 <piperead+0x83>
801044c1:	eb 01                	jmp    801044c4 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
801044c3:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801044c4:	8b 45 08             	mov    0x8(%ebp),%eax
801044c7:	05 38 02 00 00       	add    $0x238,%eax
801044cc:	83 ec 0c             	sub    $0xc,%esp
801044cf:	50                   	push   %eax
801044d0:	e8 12 13 00 00       	call   801057e7 <wakeup>
801044d5:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044d8:	8b 45 08             	mov    0x8(%ebp),%eax
801044db:	83 ec 0c             	sub    $0xc,%esp
801044de:	50                   	push   %eax
801044df:	e8 f8 23 00 00       	call   801068dc <release>
801044e4:	83 c4 10             	add    $0x10,%esp
  return i;
801044e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801044ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044ed:	c9                   	leave  
801044ee:	c3                   	ret    

801044ef <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
801044ef:	55                   	push   %ebp
801044f0:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
801044f2:	f4                   	hlt    
}
801044f3:	90                   	nop
801044f4:	5d                   	pop    %ebp
801044f5:	c3                   	ret    

801044f6 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801044f6:	55                   	push   %ebp
801044f7:	89 e5                	mov    %esp,%ebp
801044f9:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801044fc:	9c                   	pushf  
801044fd:	58                   	pop    %eax
801044fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104501:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104504:	c9                   	leave  
80104505:	c3                   	ret    

80104506 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104506:	55                   	push   %ebp
80104507:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104509:	fb                   	sti    
}
8010450a:	90                   	nop
8010450b:	5d                   	pop    %ebp
8010450c:	c3                   	ret    

8010450d <pinit>:
    [ZOMBIE]    "zombie"
};

void
pinit(void)
{
8010450d:	55                   	push   %ebp
8010450e:	89 e5                	mov    %esp,%ebp
80104510:	83 ec 08             	sub    $0x8,%esp
    initlock(&ptable.lock, "ptable");
80104513:	83 ec 08             	sub    $0x8,%esp
80104516:	68 fe a2 10 80       	push   $0x8010a2fe
8010451b:	68 80 49 11 80       	push   $0x80114980
80104520:	e8 2e 23 00 00       	call   80106853 <initlock>
80104525:	83 c4 10             	add    $0x10,%esp
}
80104528:	90                   	nop
80104529:	c9                   	leave  
8010452a:	c3                   	ret    

8010452b <allocproc>:
#else

// PROJECT 3 + 4 ALLOCPROC
static struct proc*
allocproc(void)
{
8010452b:	55                   	push   %ebp
8010452c:	89 e5                	mov    %esp,%ebp
8010452e:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
80104531:	83 ec 0c             	sub    $0xc,%esp
80104534:	68 80 49 11 80       	push   $0x80114980
80104539:	e8 37 23 00 00       	call   80106875 <acquire>
8010453e:	83 c4 10             	add    $0x10,%esp
    p = ptable.pLists.free;
80104541:	a1 c4 70 11 80       	mov    0x801170c4,%eax
80104546:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p) {
80104549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010454d:	75 1a                	jne    80104569 <allocproc+0x3e>
        goto found;
    }
    release(&ptable.lock);
8010454f:	83 ec 0c             	sub    $0xc,%esp
80104552:	68 80 49 11 80       	push   $0x80114980
80104557:	e8 80 23 00 00       	call   801068dc <release>
8010455c:	83 c4 10             	add    $0x10,%esp
    return 0;
8010455f:	b8 00 00 00 00       	mov    $0x0,%eax
80104564:	e9 a4 01 00 00       	jmp    8010470d <allocproc+0x1e2>
    char *sp;

    acquire(&ptable.lock);
    p = ptable.pLists.free;
    if (p) {
        goto found;
80104569:	90                   	nop
    release(&ptable.lock);
    return 0;

found:

    assertState(p, UNUSED);
8010456a:	83 ec 08             	sub    $0x8,%esp
8010456d:	6a 00                	push   $0x0
8010456f:	ff 75 f4             	pushl  -0xc(%ebp)
80104572:	e8 c7 19 00 00       	call   80105f3e <assertState>
80104577:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.free, p) == -1) {
8010457a:	83 ec 08             	sub    $0x8,%esp
8010457d:	ff 75 f4             	pushl  -0xc(%ebp)
80104580:	68 c4 70 11 80       	push   $0x801170c4
80104585:	e8 d5 1a 00 00       	call   8010605f <removeFromStateList>
8010458a:	83 c4 10             	add    $0x10,%esp
8010458d:	83 f8 ff             	cmp    $0xffffffff,%eax
80104590:	75 10                	jne    801045a2 <allocproc+0x77>
        cprintf("Failed to remove proc from UNUSED list (allocproc).\n");
80104592:	83 ec 0c             	sub    $0xc,%esp
80104595:	68 08 a3 10 80       	push   $0x8010a308
8010459a:	e8 27 be ff ff       	call   801003c6 <cprintf>
8010459f:	83 c4 10             	add    $0x10,%esp
    }
    p->state = EMBRYO;
801045a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a5:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    if (addToStateListHead(&ptable.pLists.embryo, p) == -1) {
801045ac:	83 ec 08             	sub    $0x8,%esp
801045af:	ff 75 f4             	pushl  -0xc(%ebp)
801045b2:	68 d4 70 11 80       	push   $0x801170d4
801045b7:	e8 b6 19 00 00       	call   80105f72 <addToStateListHead>
801045bc:	83 c4 10             	add    $0x10,%esp
801045bf:	83 f8 ff             	cmp    $0xffffffff,%eax
801045c2:	75 10                	jne    801045d4 <allocproc+0xa9>
        cprintf("Failed to add proc to EMBRYO list (allocproc).\n");
801045c4:	83 ec 0c             	sub    $0xc,%esp
801045c7:	68 40 a3 10 80       	push   $0x8010a340
801045cc:	e8 f5 bd ff ff       	call   801003c6 <cprintf>
801045d1:	83 c4 10             	add    $0x10,%esp
    }

    p->pid = nextpid++;
801045d4:	a1 04 d0 10 80       	mov    0x8010d004,%eax
801045d9:	8d 50 01             	lea    0x1(%eax),%edx
801045dc:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
801045e2:	89 c2                	mov    %eax,%edx
801045e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e7:	89 50 10             	mov    %edx,0x10(%eax)
    release(&ptable.lock);
801045ea:	83 ec 0c             	sub    $0xc,%esp
801045ed:	68 80 49 11 80       	push   $0x80114980
801045f2:	e8 e5 22 00 00       	call   801068dc <release>
801045f7:	83 c4 10             	add    $0x10,%esp

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
801045fa:	e8 18 e7 ff ff       	call   80102d17 <kalloc>
801045ff:	89 c2                	mov    %eax,%edx
80104601:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104604:	89 50 08             	mov    %edx,0x8(%eax)
80104607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460a:	8b 40 08             	mov    0x8(%eax),%eax
8010460d:	85 c0                	test   %eax,%eax
8010460f:	75 5f                	jne    80104670 <allocproc+0x145>
        assertState(p, EMBRYO);
80104611:	83 ec 08             	sub    $0x8,%esp
80104614:	6a 01                	push   $0x1
80104616:	ff 75 f4             	pushl  -0xc(%ebp)
80104619:	e8 20 19 00 00       	call   80105f3e <assertState>
8010461e:	83 c4 10             	add    $0x10,%esp
        removeFromStateList(&ptable.pLists.embryo, p);
80104621:	83 ec 08             	sub    $0x8,%esp
80104624:	ff 75 f4             	pushl  -0xc(%ebp)
80104627:	68 d4 70 11 80       	push   $0x801170d4
8010462c:	e8 2e 1a 00 00       	call   8010605f <removeFromStateList>
80104631:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104637:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        if (addToStateListHead(&ptable.pLists.free, p) == -1) {
8010463e:	83 ec 08             	sub    $0x8,%esp
80104641:	ff 75 f4             	pushl  -0xc(%ebp)
80104644:	68 c4 70 11 80       	push   $0x801170c4
80104649:	e8 24 19 00 00       	call   80105f72 <addToStateListHead>
8010464e:	83 c4 10             	add    $0x10,%esp
80104651:	83 f8 ff             	cmp    $0xffffffff,%eax
80104654:	75 10                	jne    80104666 <allocproc+0x13b>
            cprintf("Not enough room for process stack; Failed to add proc to UNUSED list (allocproc).\n");
80104656:	83 ec 0c             	sub    $0xc,%esp
80104659:	68 70 a3 10 80       	push   $0x8010a370
8010465e:	e8 63 bd ff ff       	call   801003c6 <cprintf>
80104663:	83 c4 10             	add    $0x10,%esp
        }
        return 0;
80104666:	b8 00 00 00 00       	mov    $0x0,%eax
8010466b:	e9 9d 00 00 00       	jmp    8010470d <allocproc+0x1e2>
    }
    sp = p->kstack + KSTACKSIZE;
80104670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104673:	8b 40 08             	mov    0x8(%eax),%eax
80104676:	05 00 10 00 00       	add    $0x1000,%eax
8010467b:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
8010467e:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
    p->tf = (struct trapframe*)sp;
80104682:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104685:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104688:	89 50 18             	mov    %edx,0x18(%eax)

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
8010468b:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
    *(uint*)sp = (uint)trapret;
8010468f:	ba a2 80 10 80       	mov    $0x801080a2,%edx
80104694:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104697:	89 10                	mov    %edx,(%eax)

    sp -= sizeof *p->context;
80104699:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
    p->context = (struct context*)sp;
8010469d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801046a3:	89 50 1c             	mov    %edx,0x1c(%eax)
    memset(p->context, 0, sizeof *p->context);
801046a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a9:	8b 40 1c             	mov    0x1c(%eax),%eax
801046ac:	83 ec 04             	sub    $0x4,%esp
801046af:	6a 14                	push   $0x14
801046b1:	6a 00                	push   $0x0
801046b3:	50                   	push   %eax
801046b4:	e8 1f 24 00 00       	call   80106ad8 <memset>
801046b9:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
801046bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046bf:	8b 40 1c             	mov    0x1c(%eax),%eax
801046c2:	ba 46 55 10 80       	mov    $0x80105546,%edx
801046c7:	89 50 10             	mov    %edx,0x10(%eax)

    p->start_ticks = ticks;
801046ca:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
801046d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d3:	89 50 7c             	mov    %edx,0x7c(%eax)
    p->cpu_ticks_total = 0;
801046d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d9:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
801046e0:	00 00 00 
    p->cpu_ticks_in = 0;
801046e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e6:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
801046ed:	00 00 00 

    // Project 4
    p->budget = BUDGET;
801046f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046f3:	c7 80 98 00 00 00 fa 	movl   $0xfa,0x98(%eax)
801046fa:	00 00 00 
    p->priority = 0;
801046fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104700:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104707:	00 00 00 

    return p;
8010470a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010470d:	c9                   	leave  
8010470e:	c3                   	ret    

8010470f <userinit>:
}
#else
// PROJECT 3 + 4 USERINIT
void
userinit(void)
{
8010470f:	55                   	push   %ebp
80104710:	89 e5                	mov    %esp,%ebp
80104712:	83 ec 18             	sub    $0x18,%esp
    ptable.promoteAtTime = TIME_TO_PROMOTE;
80104715:	c7 05 d8 70 11 80 e8 	movl   $0x3e8,0x801170d8
8010471c:	03 00 00 
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    // Add to the END of the UNUSED list upon init, or else processes will be backwards (ctrl-p & ps)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010471f:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80104726:	eb 3c                	jmp    80104764 <userinit+0x55>
        assertState(p, UNUSED);
80104728:	83 ec 08             	sub    $0x8,%esp
8010472b:	6a 00                	push   $0x0
8010472d:	ff 75 f4             	pushl  -0xc(%ebp)
80104730:	e8 09 18 00 00       	call   80105f3e <assertState>
80104735:	83 c4 10             	add    $0x10,%esp
        if (addToStateListEnd(&ptable.pLists.free, p) == -1) {
80104738:	83 ec 08             	sub    $0x8,%esp
8010473b:	ff 75 f4             	pushl  -0xc(%ebp)
8010473e:	68 c4 70 11 80       	push   $0x801170c4
80104743:	e8 96 18 00 00       	call   80105fde <addToStateListEnd>
80104748:	83 c4 10             	add    $0x10,%esp
8010474b:	83 f8 ff             	cmp    $0xffffffff,%eax
8010474e:	75 0d                	jne    8010475d <userinit+0x4e>
            panic("Failed to add proc to UNUSED list.\n");
80104750:	83 ec 0c             	sub    $0xc,%esp
80104753:	68 c4 a3 10 80       	push   $0x8010a3c4
80104758:	e8 09 be ff ff       	call   80100566 <panic>
    ptable.promoteAtTime = TIME_TO_PROMOTE;
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    // Add to the END of the UNUSED list upon init, or else processes will be backwards (ctrl-p & ps)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010475d:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104764:	81 7d f4 b4 70 11 80 	cmpl   $0x801170b4,-0xc(%ebp)
8010476b:	72 bb                	jb     80104728 <userinit+0x19>
        if (addToStateListEnd(&ptable.pLists.free, p) == -1) {
            panic("Failed to add proc to UNUSED list.\n");
        }
    }

    p = allocproc();
8010476d:	e8 b9 fd ff ff       	call   8010452b <allocproc>
80104772:	89 45 f4             	mov    %eax,-0xc(%ebp)

    initproc = p;
80104775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104778:	a3 68 d6 10 80       	mov    %eax,0x8010d668
    if((p->pgdir = setupkvm()) == 0)
8010477d:	e8 e2 4f 00 00       	call   80109764 <setupkvm>
80104782:	89 c2                	mov    %eax,%edx
80104784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104787:	89 50 04             	mov    %edx,0x4(%eax)
8010478a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478d:	8b 40 04             	mov    0x4(%eax),%eax
80104790:	85 c0                	test   %eax,%eax
80104792:	75 0d                	jne    801047a1 <userinit+0x92>
        panic("userinit: out of memory?");
80104794:	83 ec 0c             	sub    $0xc,%esp
80104797:	68 e8 a3 10 80       	push   $0x8010a3e8
8010479c:	e8 c5 bd ff ff       	call   80100566 <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047a1:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a9:	8b 40 04             	mov    0x4(%eax),%eax
801047ac:	83 ec 04             	sub    $0x4,%esp
801047af:	52                   	push   %edx
801047b0:	68 00 d5 10 80       	push   $0x8010d500
801047b5:	50                   	push   %eax
801047b6:	e8 03 52 00 00       	call   801099be <inituvm>
801047bb:	83 c4 10             	add    $0x10,%esp
    p->sz = PGSIZE;
801047be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c1:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
    memset(p->tf, 0, sizeof(*p->tf));
801047c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ca:	8b 40 18             	mov    0x18(%eax),%eax
801047cd:	83 ec 04             	sub    $0x4,%esp
801047d0:	6a 4c                	push   $0x4c
801047d2:	6a 00                	push   $0x0
801047d4:	50                   	push   %eax
801047d5:	e8 fe 22 00 00       	call   80106ad8 <memset>
801047da:	83 c4 10             	add    $0x10,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801047dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e0:	8b 40 18             	mov    0x18(%eax),%eax
801047e3:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801047e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047ec:	8b 40 18             	mov    0x18(%eax),%eax
801047ef:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
    p->tf->es = p->tf->ds;
801047f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047f8:	8b 40 18             	mov    0x18(%eax),%eax
801047fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047fe:	8b 52 18             	mov    0x18(%edx),%edx
80104801:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104805:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80104809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480c:	8b 40 18             	mov    0x18(%eax),%eax
8010480f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104812:	8b 52 18             	mov    0x18(%edx),%edx
80104815:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104819:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
8010481d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104820:	8b 40 18             	mov    0x18(%eax),%eax
80104823:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
8010482a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010482d:	8b 40 18             	mov    0x18(%eax),%eax
80104830:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80104837:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483a:	8b 40 18             	mov    0x18(%eax),%eax
8010483d:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

#ifdef CS333_P2
    p->uid = UID;
80104844:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104847:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010484e:	00 00 00 
    p->gid = GID;
80104851:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104854:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
8010485b:	00 00 00 
    p->parent = p; // parent of proc one is itself
8010485e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104861:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104864:	89 50 14             	mov    %edx,0x14(%eax)
#endif

    safestrcpy(p->name, "initcode", sizeof(p->name));
80104867:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010486a:	83 c0 6c             	add    $0x6c,%eax
8010486d:	83 ec 04             	sub    $0x4,%esp
80104870:	6a 10                	push   $0x10
80104872:	68 01 a4 10 80       	push   $0x8010a401
80104877:	50                   	push   %eax
80104878:	e8 5e 24 00 00       	call   80106cdb <safestrcpy>
8010487d:	83 c4 10             	add    $0x10,%esp
    p->cwd = namei("/");
80104880:	83 ec 0c             	sub    $0xc,%esp
80104883:	68 0a a4 10 80       	push   $0x8010a40a
80104888:	e8 4c dd ff ff       	call   801025d9 <namei>
8010488d:	83 c4 10             	add    $0x10,%esp
80104890:	89 c2                	mov    %eax,%edx
80104892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104895:	89 50 68             	mov    %edx,0x68(%eax)

    assertState(p, EMBRYO);
80104898:	83 ec 08             	sub    $0x8,%esp
8010489b:	6a 01                	push   $0x1
8010489d:	ff 75 f4             	pushl  -0xc(%ebp)
801048a0:	e8 99 16 00 00       	call   80105f3e <assertState>
801048a5:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.embryo, p) < 0) {
801048a8:	83 ec 08             	sub    $0x8,%esp
801048ab:	ff 75 f4             	pushl  -0xc(%ebp)
801048ae:	68 d4 70 11 80       	push   $0x801170d4
801048b3:	e8 a7 17 00 00       	call   8010605f <removeFromStateList>
801048b8:	83 c4 10             	add    $0x10,%esp
801048bb:	85 c0                	test   %eax,%eax
801048bd:	79 10                	jns    801048cf <userinit+0x1c0>
        cprintf("Failed to remove EMBRYO proc from list (userinit).\n");
801048bf:	83 ec 0c             	sub    $0xc,%esp
801048c2:	68 0c a4 10 80       	push   $0x8010a40c
801048c7:	e8 fa ba ff ff       	call   801003c6 <cprintf>
801048cc:	83 c4 10             	add    $0x10,%esp
    }

    p->state = RUNNABLE;
801048cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048d2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

    //ptable.pLists.ready = p;  // add to head of ready list

    ptable.pLists.ready[0] = p;  // add to head of highest priority ready list
801048d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048dc:	a3 b4 70 11 80       	mov    %eax,0x801170b4
    p->next = 0;
801048e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048e4:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801048eb:	00 00 00 
    for (int i = 1; i <= MAX; ++i) {
801048ee:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
801048f5:	eb 17                	jmp    8010490e <userinit+0x1ff>
        ptable.pLists.ready[i] = 0; // initialize all of the other ready lists
801048f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801048fa:	05 cc 09 00 00       	add    $0x9cc,%eax
801048ff:	c7 04 85 84 49 11 80 	movl   $0x0,-0x7feeb67c(,%eax,4)
80104906:	00 00 00 00 

    //ptable.pLists.ready = p;  // add to head of ready list

    ptable.pLists.ready[0] = p;  // add to head of highest priority ready list
    p->next = 0;
    for (int i = 1; i <= MAX; ++i) {
8010490a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010490e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
80104912:	7e e3                	jle    801048f7 <userinit+0x1e8>
        ptable.pLists.ready[i] = 0; // initialize all of the other ready lists
    }
    ptable.pLists.sleep = 0;  // initialize rest of the lists to NULL
80104914:	c7 05 c8 70 11 80 00 	movl   $0x0,0x801170c8
8010491b:	00 00 00 
    ptable.pLists.zombie = 0;
8010491e:	c7 05 cc 70 11 80 00 	movl   $0x0,0x801170cc
80104925:	00 00 00 
    ptable.pLists.running = 0;
80104928:	c7 05 d0 70 11 80 00 	movl   $0x0,0x801170d0
8010492f:	00 00 00 
    ptable.pLists.embryo = 0;
80104932:	c7 05 d4 70 11 80 00 	movl   $0x0,0x801170d4
80104939:	00 00 00 
}
8010493c:	90                   	nop
8010493d:	c9                   	leave  
8010493e:	c3                   	ret    

8010493f <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010493f:	55                   	push   %ebp
80104940:	89 e5                	mov    %esp,%ebp
80104942:	83 ec 18             	sub    $0x18,%esp
    uint sz;

    sz = proc->sz;
80104945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010494b:	8b 00                	mov    (%eax),%eax
8010494d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(n > 0){
80104950:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104954:	7e 31                	jle    80104987 <growproc+0x48>
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104956:	8b 55 08             	mov    0x8(%ebp),%edx
80104959:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010495c:	01 c2                	add    %eax,%edx
8010495e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104964:	8b 40 04             	mov    0x4(%eax),%eax
80104967:	83 ec 04             	sub    $0x4,%esp
8010496a:	52                   	push   %edx
8010496b:	ff 75 f4             	pushl  -0xc(%ebp)
8010496e:	50                   	push   %eax
8010496f:	e8 97 51 00 00       	call   80109b0b <allocuvm>
80104974:	83 c4 10             	add    $0x10,%esp
80104977:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010497a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010497e:	75 3e                	jne    801049be <growproc+0x7f>
            return -1;
80104980:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104985:	eb 59                	jmp    801049e0 <growproc+0xa1>
    } else if(n < 0){
80104987:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010498b:	79 31                	jns    801049be <growproc+0x7f>
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010498d:	8b 55 08             	mov    0x8(%ebp),%edx
80104990:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104993:	01 c2                	add    %eax,%edx
80104995:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010499b:	8b 40 04             	mov    0x4(%eax),%eax
8010499e:	83 ec 04             	sub    $0x4,%esp
801049a1:	52                   	push   %edx
801049a2:	ff 75 f4             	pushl  -0xc(%ebp)
801049a5:	50                   	push   %eax
801049a6:	e8 29 52 00 00       	call   80109bd4 <deallocuvm>
801049ab:	83 c4 10             	add    $0x10,%esp
801049ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
801049b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801049b5:	75 07                	jne    801049be <growproc+0x7f>
            return -1;
801049b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049bc:	eb 22                	jmp    801049e0 <growproc+0xa1>
    }
    proc->sz = sz;
801049be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049c7:	89 10                	mov    %edx,(%eax)
    switchuvm(proc);
801049c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049cf:	83 ec 0c             	sub    $0xc,%esp
801049d2:	50                   	push   %eax
801049d3:	e8 73 4e 00 00       	call   8010984b <switchuvm>
801049d8:	83 c4 10             	add    $0x10,%esp
    return 0;
801049db:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049e0:	c9                   	leave  
801049e1:	c3                   	ret    

801049e2 <fork>:
}
#else
// PROJECT 3 + 4 FORK
int
fork(void)
{
801049e2:	55                   	push   %ebp
801049e3:	89 e5                	mov    %esp,%ebp
801049e5:	57                   	push   %edi
801049e6:	56                   	push   %esi
801049e7:	53                   	push   %ebx
801049e8:	83 ec 1c             	sub    $0x1c,%esp
    int i, pid;
    struct proc *np;

    // Allocate process.
    if((np = allocproc()) == 0)
801049eb:	e8 3b fb ff ff       	call   8010452b <allocproc>
801049f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801049f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049f7:	75 0a                	jne    80104a03 <fork+0x21>
        return -1;
801049f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049fe:	e9 61 02 00 00       	jmp    80104c64 <fork+0x282>

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104a03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a09:	8b 10                	mov    (%eax),%edx
80104a0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a11:	8b 40 04             	mov    0x4(%eax),%eax
80104a14:	83 ec 08             	sub    $0x8,%esp
80104a17:	52                   	push   %edx
80104a18:	50                   	push   %eax
80104a19:	e8 54 53 00 00       	call   80109d72 <copyuvm>
80104a1e:	83 c4 10             	add    $0x10,%esp
80104a21:	89 c2                	mov    %eax,%edx
80104a23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a26:	89 50 04             	mov    %edx,0x4(%eax)
80104a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a2c:	8b 40 04             	mov    0x4(%eax),%eax
80104a2f:	85 c0                	test   %eax,%eax
80104a31:	0f 85 88 00 00 00    	jne    80104abf <fork+0xdd>
        kfree(np->kstack);
80104a37:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a3a:	8b 40 08             	mov    0x8(%eax),%eax
80104a3d:	83 ec 0c             	sub    $0xc,%esp
80104a40:	50                   	push   %eax
80104a41:	e8 34 e2 ff ff       	call   80102c7a <kfree>
80104a46:	83 c4 10             	add    $0x10,%esp
        np->kstack = 0;
80104a49:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        assertState(np, EMBRYO);
80104a53:	83 ec 08             	sub    $0x8,%esp
80104a56:	6a 01                	push   $0x1
80104a58:	ff 75 e0             	pushl  -0x20(%ebp)
80104a5b:	e8 de 14 00 00       	call   80105f3e <assertState>
80104a60:	83 c4 10             	add    $0x10,%esp
        if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
80104a63:	83 ec 08             	sub    $0x8,%esp
80104a66:	ff 75 e0             	pushl  -0x20(%ebp)
80104a69:	68 d4 70 11 80       	push   $0x801170d4
80104a6e:	e8 ec 15 00 00       	call   8010605f <removeFromStateList>
80104a73:	83 c4 10             	add    $0x10,%esp
80104a76:	85 c0                	test   %eax,%eax
80104a78:	79 0d                	jns    80104a87 <fork+0xa5>
            panic("Failed to remove proc from EMBRYO list (fork).\n");
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	68 40 a4 10 80       	push   $0x8010a440
80104a82:	e8 df ba ff ff       	call   80100566 <panic>
        }
        np->state = UNUSED;
80104a87:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        if (addToStateListHead(&ptable.pLists.free, np) < 0) {
80104a91:	83 ec 08             	sub    $0x8,%esp
80104a94:	ff 75 e0             	pushl  -0x20(%ebp)
80104a97:	68 c4 70 11 80       	push   $0x801170c4
80104a9c:	e8 d1 14 00 00       	call   80105f72 <addToStateListHead>
80104aa1:	83 c4 10             	add    $0x10,%esp
80104aa4:	85 c0                	test   %eax,%eax
80104aa6:	79 0d                	jns    80104ab5 <fork+0xd3>
            panic("Failed to add proc to UNUSED list (fork).\n");
80104aa8:	83 ec 0c             	sub    $0xc,%esp
80104aab:	68 70 a4 10 80       	push   $0x8010a470
80104ab0:	e8 b1 ba ff ff       	call   80100566 <panic>
        }
        return -1;
80104ab5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aba:	e9 a5 01 00 00       	jmp    80104c64 <fork+0x282>
    }
    np->sz = proc->sz;
80104abf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac5:	8b 10                	mov    (%eax),%edx
80104ac7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104aca:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
80104acc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ad3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ad6:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
80104ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104adc:	8b 50 18             	mov    0x18(%eax),%edx
80104adf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ae5:	8b 40 18             	mov    0x18(%eax),%eax
80104ae8:	89 c3                	mov    %eax,%ebx
80104aea:	b8 13 00 00 00       	mov    $0x13,%eax
80104aef:	89 d7                	mov    %edx,%edi
80104af1:	89 de                	mov    %ebx,%esi
80104af3:	89 c1                	mov    %eax,%ecx
80104af5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80104af7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104afa:	8b 40 18             	mov    0x18(%eax),%eax
80104afd:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    for(i = 0; i < NOFILE; i++)
80104b04:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104b0b:	eb 43                	jmp    80104b50 <fork+0x16e>
        if(proc->ofile[i])
80104b0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b13:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b16:	83 c2 08             	add    $0x8,%edx
80104b19:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b1d:	85 c0                	test   %eax,%eax
80104b1f:	74 2b                	je     80104b4c <fork+0x16a>
            np->ofile[i] = filedup(proc->ofile[i]);
80104b21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b2a:	83 c2 08             	add    $0x8,%edx
80104b2d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104b31:	83 ec 0c             	sub    $0xc,%esp
80104b34:	50                   	push   %eax
80104b35:	e8 77 c5 ff ff       	call   801010b1 <filedup>
80104b3a:	83 c4 10             	add    $0x10,%esp
80104b3d:	89 c1                	mov    %eax,%ecx
80104b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104b45:	83 c2 08             	add    $0x8,%edx
80104b48:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
    *np->tf = *proc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
80104b4c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104b50:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104b54:	7e b7                	jle    80104b0d <fork+0x12b>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
80104b56:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b5c:	8b 40 68             	mov    0x68(%eax),%eax
80104b5f:	83 ec 0c             	sub    $0xc,%esp
80104b62:	50                   	push   %eax
80104b63:	e8 79 ce ff ff       	call   801019e1 <idup>
80104b68:	83 c4 10             	add    $0x10,%esp
80104b6b:	89 c2                	mov    %eax,%edx
80104b6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b70:	89 50 68             	mov    %edx,0x68(%eax)

    safestrcpy(np->name, proc->name, sizeof(proc->name));
80104b73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b79:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b7f:	83 c0 6c             	add    $0x6c,%eax
80104b82:	83 ec 04             	sub    $0x4,%esp
80104b85:	6a 10                	push   $0x10
80104b87:	52                   	push   %edx
80104b88:	50                   	push   %eax
80104b89:	e8 4d 21 00 00       	call   80106cdb <safestrcpy>
80104b8e:	83 c4 10             	add    $0x10,%esp

    np->uid = proc->uid;
80104b91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b97:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104b9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ba0:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    np->gid = proc->gid;
80104ba6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bac:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104bb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bb5:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

    pid = np->pid;
80104bbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bbe:	8b 40 10             	mov    0x10(%eax),%eax
80104bc1:	89 45 dc             	mov    %eax,-0x24(%ebp)

    // lock to force the compiler to emit the np->state write last.
    acquire(&ptable.lock);
80104bc4:	83 ec 0c             	sub    $0xc,%esp
80104bc7:	68 80 49 11 80       	push   $0x80114980
80104bcc:	e8 a4 1c 00 00       	call   80106875 <acquire>
80104bd1:	83 c4 10             	add    $0x10,%esp
    assertState(np, EMBRYO);
80104bd4:	83 ec 08             	sub    $0x8,%esp
80104bd7:	6a 01                	push   $0x1
80104bd9:	ff 75 e0             	pushl  -0x20(%ebp)
80104bdc:	e8 5d 13 00 00       	call   80105f3e <assertState>
80104be1:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
80104be4:	83 ec 08             	sub    $0x8,%esp
80104be7:	ff 75 e0             	pushl  -0x20(%ebp)
80104bea:	68 d4 70 11 80       	push   $0x801170d4
80104bef:	e8 6b 14 00 00       	call   8010605f <removeFromStateList>
80104bf4:	83 c4 10             	add    $0x10,%esp
80104bf7:	85 c0                	test   %eax,%eax
80104bf9:	79 10                	jns    80104c0b <fork+0x229>
        cprintf("Failed to remove EMBRYO proc from list (fork).\n");
80104bfb:	83 ec 0c             	sub    $0xc,%esp
80104bfe:	68 9c a4 10 80       	push   $0x8010a49c
80104c03:	e8 be b7 ff ff       	call   801003c6 <cprintf>
80104c08:	83 c4 10             	add    $0x10,%esp
    }

    np->state = RUNNABLE;
80104c0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c0e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

    // add to end of highest priority queue
    if (addToStateListEnd(&ptable.pLists.ready[np->priority], np) < 0) {
80104c15:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c18:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104c1e:	05 cc 09 00 00       	add    $0x9cc,%eax
80104c23:	c1 e0 02             	shl    $0x2,%eax
80104c26:	05 80 49 11 80       	add    $0x80114980,%eax
80104c2b:	83 c0 04             	add    $0x4,%eax
80104c2e:	83 ec 08             	sub    $0x8,%esp
80104c31:	ff 75 e0             	pushl  -0x20(%ebp)
80104c34:	50                   	push   %eax
80104c35:	e8 a4 13 00 00       	call   80105fde <addToStateListEnd>
80104c3a:	83 c4 10             	add    $0x10,%esp
80104c3d:	85 c0                	test   %eax,%eax
80104c3f:	79 10                	jns    80104c51 <fork+0x26f>
        cprintf("Failed to add RUNNABLE proc to list (fork).\n");
80104c41:	83 ec 0c             	sub    $0xc,%esp
80104c44:	68 cc a4 10 80       	push   $0x8010a4cc
80104c49:	e8 78 b7 ff ff       	call   801003c6 <cprintf>
80104c4e:	83 c4 10             	add    $0x10,%esp
    }
    release(&ptable.lock);
80104c51:	83 ec 0c             	sub    $0xc,%esp
80104c54:	68 80 49 11 80       	push   $0x80114980
80104c59:	e8 7e 1c 00 00       	call   801068dc <release>
80104c5e:	83 c4 10             	add    $0x10,%esp

    return pid;
80104c61:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c67:	5b                   	pop    %ebx
80104c68:	5e                   	pop    %esi
80104c69:	5f                   	pop    %edi
80104c6a:	5d                   	pop    %ebp
80104c6b:	c3                   	ret    

80104c6c <exit>:
    panic("zombie exit");
}
#else
void
exit(void)
{
80104c6c:	55                   	push   %ebp
80104c6d:	89 e5                	mov    %esp,%ebp
80104c6f:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    int fd;

    if(proc == initproc)
80104c72:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c79:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104c7e:	39 c2                	cmp    %eax,%edx
80104c80:	75 0d                	jne    80104c8f <exit+0x23>
        panic("init exiting");
80104c82:	83 ec 0c             	sub    $0xc,%esp
80104c85:	68 f9 a4 10 80       	push   $0x8010a4f9
80104c8a:	e8 d7 b8 ff ff       	call   80100566 <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104c8f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c96:	eb 48                	jmp    80104ce0 <exit+0x74>
        if(proc->ofile[fd]){
80104c98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ca1:	83 c2 08             	add    $0x8,%edx
80104ca4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ca8:	85 c0                	test   %eax,%eax
80104caa:	74 30                	je     80104cdc <exit+0x70>
            fileclose(proc->ofile[fd]);
80104cac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cb2:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104cb5:	83 c2 08             	add    $0x8,%edx
80104cb8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104cbc:	83 ec 0c             	sub    $0xc,%esp
80104cbf:	50                   	push   %eax
80104cc0:	e8 3d c4 ff ff       	call   80101102 <fileclose>
80104cc5:	83 c4 10             	add    $0x10,%esp
            proc->ofile[fd] = 0;
80104cc8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cce:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104cd1:	83 c2 08             	add    $0x8,%edx
80104cd4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104cdb:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104cdc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104ce0:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104ce4:	7e b2                	jle    80104c98 <exit+0x2c>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    begin_op();
80104ce6:	e8 13 e9 ff ff       	call   801035fe <begin_op>
    iput(proc->cwd);
80104ceb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cf1:	8b 40 68             	mov    0x68(%eax),%eax
80104cf4:	83 ec 0c             	sub    $0xc,%esp
80104cf7:	50                   	push   %eax
80104cf8:	e8 ee ce ff ff       	call   80101beb <iput>
80104cfd:	83 c4 10             	add    $0x10,%esp
    end_op();
80104d00:	e8 85 e9 ff ff       	call   8010368a <end_op>
    proc->cwd = 0;
80104d05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d0b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104d12:	83 ec 0c             	sub    $0xc,%esp
80104d15:	68 80 49 11 80       	push   $0x80114980
80104d1a:	e8 56 1b 00 00       	call   80106875 <acquire>
80104d1f:	83 c4 10             	add    $0x10,%esp

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104d22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d28:	8b 40 14             	mov    0x14(%eax),%eax
80104d2b:	83 ec 0c             	sub    $0xc,%esp
80104d2e:	50                   	push   %eax
80104d2f:	e8 e5 09 00 00       	call   80105719 <wakeup1>
80104d34:	83 c4 10             	add    $0x10,%esp
    
    // Pass abandoned children to init.
    p = ptable.pLists.zombie;
80104d37:	a1 cc 70 11 80       	mov    0x801170cc,%eax
80104d3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104d3f:	eb 39                	jmp    80104d7a <exit+0x10e>
        if (p->parent == proc) {
80104d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d44:	8b 50 14             	mov    0x14(%eax),%edx
80104d47:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d4d:	39 c2                	cmp    %eax,%edx
80104d4f:	75 1d                	jne    80104d6e <exit+0x102>
            p->parent = initproc;
80104d51:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d5a:	89 50 14             	mov    %edx,0x14(%eax)
            wakeup1(initproc);
80104d5d:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104d62:	83 ec 0c             	sub    $0xc,%esp
80104d65:	50                   	push   %eax
80104d66:	e8 ae 09 00 00       	call   80105719 <wakeup1>
80104d6b:	83 c4 10             	add    $0x10,%esp
        }
        p = p->next;
80104d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d71:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
    
    // Pass abandoned children to init.
    p = ptable.pLists.zombie;
    while (p) {
80104d7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d7e:	75 c1                	jne    80104d41 <exit+0xd5>
            p->parent = initproc;
            wakeup1(initproc);
        }
        p = p->next;
    }
    p = ptable.pLists.running; // now running list
80104d80:	a1 d0 70 11 80       	mov    0x801170d0,%eax
80104d85:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104d88:	eb 28                	jmp    80104db2 <exit+0x146>
        if(p->parent == proc){
80104d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d8d:	8b 50 14             	mov    0x14(%eax),%edx
80104d90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d96:	39 c2                	cmp    %eax,%edx
80104d98:	75 0c                	jne    80104da6 <exit+0x13a>
            p->parent = initproc;
80104d9a:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da3:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104daf:	89 45 f4             	mov    %eax,-0xc(%ebp)
            wakeup1(initproc);
        }
        p = p->next;
    }
    p = ptable.pLists.running; // now running list
    while (p) {
80104db2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104db6:	75 d2                	jne    80104d8a <exit+0x11e>
            p->parent = initproc;
        }
        p = p->next;
    }
    // traverse array of ready lists
    for (int i = 0; i <= MAX; ++i) {
80104db8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104dbf:	eb 46                	jmp    80104e07 <exit+0x19b>
        p = ptable.pLists.ready[i]; // now ready
80104dc1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104dc4:	05 cc 09 00 00       	add    $0x9cc,%eax
80104dc9:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80104dd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
80104dd3:	eb 28                	jmp    80104dfd <exit+0x191>
            if (p->parent == proc) {
80104dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd8:	8b 50 14             	mov    0x14(%eax),%edx
80104ddb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de1:	39 c2                	cmp    %eax,%edx
80104de3:	75 0c                	jne    80104df1 <exit+0x185>
                p->parent = initproc;
80104de5:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dee:	89 50 14             	mov    %edx,0x14(%eax)
            }
            p = p->next;
80104df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104dfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }
    // traverse array of ready lists
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i]; // now ready
        while (p) {
80104dfd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e01:	75 d2                	jne    80104dd5 <exit+0x169>
            p->parent = initproc;
        }
        p = p->next;
    }
    // traverse array of ready lists
    for (int i = 0; i <= MAX; ++i) {
80104e03:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104e07:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
80104e0b:	7e b4                	jle    80104dc1 <exit+0x155>
                p->parent = initproc;
            }
            p = p->next;
        }
    }
    p = ptable.pLists.sleep; // sleeping list
80104e0d:	a1 c8 70 11 80       	mov    0x801170c8,%eax
80104e12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104e15:	eb 28                	jmp    80104e3f <exit+0x1d3>
        if (p->parent == proc) {
80104e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e1a:	8b 50 14             	mov    0x14(%eax),%edx
80104e1d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e23:	39 c2                	cmp    %eax,%edx
80104e25:	75 0c                	jne    80104e33 <exit+0x1c7>
            p->parent = initproc;
80104e27:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e30:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e36:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
    }
    p = ptable.pLists.sleep; // sleeping list
    while (p) {
80104e3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e43:	75 d2                	jne    80104e17 <exit+0x1ab>
        if (p->parent == proc) {
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.embryo; // embryo list
80104e45:	a1 d4 70 11 80       	mov    0x801170d4,%eax
80104e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104e4d:	eb 28                	jmp    80104e77 <exit+0x20b>
        if (p->parent == proc) {
80104e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e52:	8b 50 14             	mov    0x14(%eax),%edx
80104e55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e5b:	39 c2                	cmp    %eax,%edx
80104e5d:	75 0c                	jne    80104e6b <exit+0x1ff>
            p->parent = initproc;
80104e5f:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e68:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e6e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104e74:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.embryo; // embryo list
    while (p) {
80104e77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e7b:	75 d2                	jne    80104e4f <exit+0x1e3>
        if (p->parent == proc) {
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.free; // free list
80104e7d:	a1 c4 70 11 80       	mov    0x801170c4,%eax
80104e82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104e85:	eb 28                	jmp    80104eaf <exit+0x243>
        if (p->parent == proc) {
80104e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8a:	8b 50 14             	mov    0x14(%eax),%edx
80104e8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e93:	39 c2                	cmp    %eax,%edx
80104e95:	75 0c                	jne    80104ea3 <exit+0x237>
            p->parent = initproc;
80104e97:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea0:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.free; // free list
    while (p) {
80104eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104eb3:	75 d2                	jne    80104e87 <exit+0x21b>
            p->parent = initproc;
        }
        p = p->next;
    }

    assertState(proc, RUNNING);
80104eb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ebb:	83 ec 08             	sub    $0x8,%esp
80104ebe:	6a 04                	push   $0x4
80104ec0:	50                   	push   %eax
80104ec1:	e8 78 10 00 00       	call   80105f3e <assertState>
80104ec6:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
80104ec9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ecf:	83 ec 08             	sub    $0x8,%esp
80104ed2:	50                   	push   %eax
80104ed3:	68 d0 70 11 80       	push   $0x801170d0
80104ed8:	e8 82 11 00 00       	call   8010605f <removeFromStateList>
80104edd:	83 c4 10             	add    $0x10,%esp
80104ee0:	85 c0                	test   %eax,%eax
80104ee2:	79 10                	jns    80104ef4 <exit+0x288>
        cprintf("Failed to remove RUNNING proc from list (exit).\n");
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	68 08 a5 10 80       	push   $0x8010a508
80104eec:	e8 d5 b4 ff ff       	call   801003c6 <cprintf>
80104ef1:	83 c4 10             	add    $0x10,%esp
    }
    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
80104ef4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104efa:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    if (addToStateListHead(&ptable.pLists.zombie, proc) < 0) {
80104f01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f07:	83 ec 08             	sub    $0x8,%esp
80104f0a:	50                   	push   %eax
80104f0b:	68 cc 70 11 80       	push   $0x801170cc
80104f10:	e8 5d 10 00 00       	call   80105f72 <addToStateListHead>
80104f15:	83 c4 10             	add    $0x10,%esp
80104f18:	85 c0                	test   %eax,%eax
80104f1a:	79 10                	jns    80104f2c <exit+0x2c0>
        cprintf("Failed to add ZOMBIE proc to list (exit).\n");
80104f1c:	83 ec 0c             	sub    $0xc,%esp
80104f1f:	68 3c a5 10 80       	push   $0x8010a53c
80104f24:	e8 9d b4 ff ff       	call   801003c6 <cprintf>
80104f29:	83 c4 10             	add    $0x10,%esp
    }

    sched();
80104f2c:	e8 e5 03 00 00       	call   80105316 <sched>
    panic("zombie exit");
80104f31:	83 ec 0c             	sub    $0xc,%esp
80104f34:	68 67 a5 10 80       	push   $0x8010a567
80104f39:	e8 28 b6 ff ff       	call   80100566 <panic>

80104f3e <wait>:
    }
}
#else
int
wait(void)
{
80104f3e:	55                   	push   %ebp
80104f3f:	89 e5                	mov    %esp,%ebp
80104f41:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
80104f44:	83 ec 0c             	sub    $0xc,%esp
80104f47:	68 80 49 11 80       	push   $0x80114980
80104f4c:	e8 24 19 00 00       	call   80106875 <acquire>
80104f51:	83 c4 10             	add    $0x10,%esp
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
80104f54:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        // start at zombie list
        p = ptable.pLists.zombie;
80104f5b:	a1 cc 70 11 80       	mov    0x801170cc,%eax
80104f60:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
80104f63:	e9 03 01 00 00       	jmp    8010506b <wait+0x12d>
            if (p->parent == proc) {
80104f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f6b:	8b 50 14             	mov    0x14(%eax),%edx
80104f6e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f74:	39 c2                	cmp    %eax,%edx
80104f76:	0f 85 e3 00 00 00    	jne    8010505f <wait+0x121>
                havekids = 1;
80104f7c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
                pid = p->pid;
80104f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f86:	8b 40 10             	mov    0x10(%eax),%eax
80104f89:	89 45 e8             	mov    %eax,-0x18(%ebp)
                kfree(p->kstack);
80104f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f8f:	8b 40 08             	mov    0x8(%eax),%eax
80104f92:	83 ec 0c             	sub    $0xc,%esp
80104f95:	50                   	push   %eax
80104f96:	e8 df dc ff ff       	call   80102c7a <kfree>
80104f9b:	83 c4 10             	add    $0x10,%esp
                p->kstack = 0;
80104f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                freevm(p->pgdir);
80104fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fab:	8b 40 04             	mov    0x4(%eax),%eax
80104fae:	83 ec 0c             	sub    $0xc,%esp
80104fb1:	50                   	push   %eax
80104fb2:	e8 da 4c 00 00       	call   80109c91 <freevm>
80104fb7:	83 c4 10             	add    $0x10,%esp
                assertState(p, ZOMBIE);
80104fba:	83 ec 08             	sub    $0x8,%esp
80104fbd:	6a 05                	push   $0x5
80104fbf:	ff 75 f4             	pushl  -0xc(%ebp)
80104fc2:	e8 77 0f 00 00       	call   80105f3e <assertState>
80104fc7:	83 c4 10             	add    $0x10,%esp
                if (removeFromStateList(&ptable.pLists.zombie, p) < 0) {
80104fca:	83 ec 08             	sub    $0x8,%esp
80104fcd:	ff 75 f4             	pushl  -0xc(%ebp)
80104fd0:	68 cc 70 11 80       	push   $0x801170cc
80104fd5:	e8 85 10 00 00       	call   8010605f <removeFromStateList>
80104fda:	83 c4 10             	add    $0x10,%esp
80104fdd:	85 c0                	test   %eax,%eax
80104fdf:	79 10                	jns    80104ff1 <wait+0xb3>
                    cprintf("Failed to remove ZOMBIE process from list (wait).\n");
80104fe1:	83 ec 0c             	sub    $0xc,%esp
80104fe4:	68 74 a5 10 80       	push   $0x8010a574
80104fe9:	e8 d8 b3 ff ff       	call   801003c6 <cprintf>
80104fee:	83 c4 10             	add    $0x10,%esp
                }
                p->state = UNUSED;
80104ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ff4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                if (addToStateListHead(&ptable.pLists.free, p) < 0) {
80104ffb:	83 ec 08             	sub    $0x8,%esp
80104ffe:	ff 75 f4             	pushl  -0xc(%ebp)
80105001:	68 c4 70 11 80       	push   $0x801170c4
80105006:	e8 67 0f 00 00       	call   80105f72 <addToStateListHead>
8010500b:	83 c4 10             	add    $0x10,%esp
8010500e:	85 c0                	test   %eax,%eax
80105010:	79 10                	jns    80105022 <wait+0xe4>
                    cprintf("Failed to add UNUSED process to list (wait).\n");
80105012:	83 ec 0c             	sub    $0xc,%esp
80105015:	68 a8 a5 10 80       	push   $0x8010a5a8
8010501a:	e8 a7 b3 ff ff       	call   801003c6 <cprintf>
8010501f:	83 c4 10             	add    $0x10,%esp
                }
                p->pid = 0;
80105022:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105025:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
8010502c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010502f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
80105036:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105039:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
8010503d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105040:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                release(&ptable.lock);
80105047:	83 ec 0c             	sub    $0xc,%esp
8010504a:	68 80 49 11 80       	push   $0x80114980
8010504f:	e8 88 18 00 00       	call   801068dc <release>
80105054:	83 c4 10             	add    $0x10,%esp
                return pid;
80105057:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010505a:	e9 2a 01 00 00       	jmp    80105189 <wait+0x24b>
            }
            p = p->next;
8010505f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105062:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105068:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
        // start at zombie list
        p = ptable.pLists.zombie;
        while (!havekids && p) {
8010506b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010506f:	75 0a                	jne    8010507b <wait+0x13d>
80105071:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105075:	0f 85 ed fe ff ff    	jne    80104f68 <wait+0x2a>
                return pid;
            }
            p = p->next;
        }
        // Runnable list
        for (int i = 0; i <= MAX; i++) {
8010507b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80105082:	eb 47                	jmp    801050cb <wait+0x18d>
            p = ptable.pLists.ready[i];
80105084:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105087:	05 cc 09 00 00       	add    $0x9cc,%eax
8010508c:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80105093:	89 45 f4             	mov    %eax,-0xc(%ebp)
            while (!havekids && p) {
80105096:	eb 23                	jmp    801050bb <wait+0x17d>
                if (p->parent == proc) {
80105098:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010509b:	8b 50 14             	mov    0x14(%eax),%edx
8010509e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050a4:	39 c2                	cmp    %eax,%edx
801050a6:	75 07                	jne    801050af <wait+0x171>
                    havekids = 1;
801050a8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
                }
                p = p->next;
801050af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050b2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801050b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p = p->next;
        }
        // Runnable list
        for (int i = 0; i <= MAX; i++) {
            p = ptable.pLists.ready[i];
            while (!havekids && p) {
801050bb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801050bf:	75 06                	jne    801050c7 <wait+0x189>
801050c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050c5:	75 d1                	jne    80105098 <wait+0x15a>
                return pid;
            }
            p = p->next;
        }
        // Runnable list
        for (int i = 0; i <= MAX; i++) {
801050c7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801050cb:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
801050cf:	7e b3                	jle    80105084 <wait+0x146>
                }
                p = p->next;
            }
        }
        // Running list
        p = ptable.pLists.running;
801050d1:	a1 d0 70 11 80       	mov    0x801170d0,%eax
801050d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
801050d9:	eb 23                	jmp    801050fe <wait+0x1c0>
            if (p->parent == proc) {
801050db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050de:	8b 50 14             	mov    0x14(%eax),%edx
801050e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050e7:	39 c2                	cmp    %eax,%edx
801050e9:	75 07                	jne    801050f2 <wait+0x1b4>
                havekids = 1;
801050eb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            }
            p = p->next;
801050f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801050fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
                p = p->next;
            }
        }
        // Running list
        p = ptable.pLists.running;
        while (!havekids && p) {
801050fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105102:	75 06                	jne    8010510a <wait+0x1cc>
80105104:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105108:	75 d1                	jne    801050db <wait+0x19d>
                havekids = 1;
            }
            p = p->next;
        }
        // Sleep list
        p = ptable.pLists.sleep;
8010510a:	a1 c8 70 11 80       	mov    0x801170c8,%eax
8010510f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
80105112:	eb 23                	jmp    80105137 <wait+0x1f9>
            if (p->parent == proc) {
80105114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105117:	8b 50 14             	mov    0x14(%eax),%edx
8010511a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105120:	39 c2                	cmp    %eax,%edx
80105122:	75 07                	jne    8010512b <wait+0x1ed>
                havekids = 1;
80105124:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            }
            p = p->next;
8010512b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010512e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105134:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
        // Sleep list
        p = ptable.pLists.sleep;
        while (!havekids && p) {
80105137:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010513b:	75 06                	jne    80105143 <wait+0x205>
8010513d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105141:	75 d1                	jne    80105114 <wait+0x1d6>
                havekids = 1;
            }
            p = p->next;
        }
        // No point waiting if we don't have any children.
        if(!havekids || proc->killed) {
80105143:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105147:	74 0d                	je     80105156 <wait+0x218>
80105149:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010514f:	8b 40 24             	mov    0x24(%eax),%eax
80105152:	85 c0                	test   %eax,%eax
80105154:	74 17                	je     8010516d <wait+0x22f>
            release(&ptable.lock);
80105156:	83 ec 0c             	sub    $0xc,%esp
80105159:	68 80 49 11 80       	push   $0x80114980
8010515e:	e8 79 17 00 00       	call   801068dc <release>
80105163:	83 c4 10             	add    $0x10,%esp
            return -1;
80105166:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010516b:	eb 1c                	jmp    80105189 <wait+0x24b>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
8010516d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105173:	83 ec 08             	sub    $0x8,%esp
80105176:	68 80 49 11 80       	push   $0x80114980
8010517b:	50                   	push   %eax
8010517c:	e8 0b 04 00 00       	call   8010558c <sleep>
80105181:	83 c4 10             	add    $0x10,%esp
    }
80105184:	e9 cb fd ff ff       	jmp    80104f54 <wait+0x16>
}
80105189:	c9                   	leave  
8010518a:	c3                   	ret    

8010518b <scheduler>:

#else
// Project 3 scheduler
void
scheduler(void)
{
8010518b:	55                   	push   %ebp
8010518c:	89 e5                	mov    %esp,%ebp
8010518e:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    int idle;  // for checking if processor is idle
    int ran; // ready list loop condition 
    for(;;) {
        // Enable interrupts on this processor.
        sti();
80105191:	e8 70 f3 ff ff       	call   80104506 <sti>
        idle = 1;  // assume idle unless we schedule a process
80105196:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        ran = 0; // reset ran, look for another process
8010519d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	68 80 49 11 80       	push   $0x80114980
801051ac:	e8 c4 16 00 00       	call   80106875 <acquire>
801051b1:	83 c4 10             	add    $0x10,%esp

        if ((ptable.promoteAtTime) == ticks) {
801051b4:	8b 15 d8 70 11 80    	mov    0x801170d8,%edx
801051ba:	a1 e0 78 11 80       	mov    0x801178e0,%eax
801051bf:	39 c2                	cmp    %eax,%edx
801051c1:	75 14                	jne    801051d7 <scheduler+0x4c>
            promoteAll(); // RUNNING, RUNNABLE, SLEEPING
801051c3:	e8 7a 12 00 00       	call   80106442 <promoteAll>
            ptable.promoteAtTime = (ticks + TIME_TO_PROMOTE); // update next time we will promote everything
801051c8:	a1 e0 78 11 80       	mov    0x801178e0,%eax
801051cd:	05 e8 03 00 00       	add    $0x3e8,%eax
801051d2:	a3 d8 70 11 80       	mov    %eax,0x801170d8
        }
        for (int i = 0; (i <= MAX) && (ran == 0); ++i) {
801051d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801051de:	e9 fa 00 00 00       	jmp    801052dd <scheduler+0x152>
            // take first process on first valid list
            p = ptable.pLists.ready[i];
801051e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051e6:	05 cc 09 00 00       	add    $0x9cc,%eax
801051eb:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
801051f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (p) {
801051f5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801051f9:	0f 84 da 00 00 00    	je     801052d9 <scheduler+0x14e>
                // assign pointer, aseert correct state
                assertState(p, RUNNABLE);
801051ff:	83 ec 08             	sub    $0x8,%esp
80105202:	6a 03                	push   $0x3
80105204:	ff 75 e8             	pushl  -0x18(%ebp)
80105207:	e8 32 0d 00 00       	call   80105f3e <assertState>
8010520c:	83 c4 10             	add    $0x10,%esp
                // take 1st process on ready list
                p = removeHead(&ptable.pLists.ready[i]);
8010520f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105212:	05 cc 09 00 00       	add    $0x9cc,%eax
80105217:	c1 e0 02             	shl    $0x2,%eax
8010521a:	05 80 49 11 80       	add    $0x80114980,%eax
8010521f:	83 c0 04             	add    $0x4,%eax
80105222:	83 ec 0c             	sub    $0xc,%esp
80105225:	50                   	push   %eax
80105226:	e8 28 0f 00 00       	call   80106153 <removeHead>
8010522b:	83 c4 10             	add    $0x10,%esp
8010522e:	89 45 e8             	mov    %eax,-0x18(%ebp)
                if (!p) {
80105231:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80105235:	75 0d                	jne    80105244 <scheduler+0xb9>
                    panic("Scheduler: removeHead failed.");
80105237:	83 ec 0c             	sub    $0xc,%esp
8010523a:	68 d6 a5 10 80       	push   $0x8010a5d6
8010523f:	e8 22 b3 ff ff       	call   80100566 <panic>
                }
                // hand over to the CPU
                idle = 0;
80105244:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
                proc = p;
8010524b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010524e:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
                switchuvm(p);
80105254:	83 ec 0c             	sub    $0xc,%esp
80105257:	ff 75 e8             	pushl  -0x18(%ebp)
8010525a:	e8 ec 45 00 00       	call   8010984b <switchuvm>
8010525f:	83 c4 10             	add    $0x10,%esp
                p->state = RUNNING;
80105262:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105265:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
                // add to end of running list
                if (addToStateListEnd(&ptable.pLists.running, p) < 0) {
8010526c:	83 ec 08             	sub    $0x8,%esp
8010526f:	ff 75 e8             	pushl  -0x18(%ebp)
80105272:	68 d0 70 11 80       	push   $0x801170d0
80105277:	e8 62 0d 00 00       	call   80105fde <addToStateListEnd>
8010527c:	83 c4 10             	add    $0x10,%esp
8010527f:	85 c0                	test   %eax,%eax
80105281:	79 10                	jns    80105293 <scheduler+0x108>
                    cprintf("Failed to add RUNNING proc to list (scheduler).");
80105283:	83 ec 0c             	sub    $0xc,%esp
80105286:	68 f4 a5 10 80       	push   $0x8010a5f4
8010528b:	e8 36 b1 ff ff       	call   801003c6 <cprintf>
80105290:	83 c4 10             	add    $0x10,%esp
                }
                p->cpu_ticks_in = ticks; // ticks when scheduled
80105293:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105299:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010529c:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
                swtch(&cpu->scheduler, proc->context);
801052a2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052a8:	8b 40 1c             	mov    0x1c(%eax),%eax
801052ab:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801052b2:	83 c2 04             	add    $0x4,%edx
801052b5:	83 ec 08             	sub    $0x8,%esp
801052b8:	50                   	push   %eax
801052b9:	52                   	push   %edx
801052ba:	e8 8d 1a 00 00       	call   80106d4c <swtch>
801052bf:	83 c4 10             	add    $0x10,%esp
                switchkvm();
801052c2:	e8 67 45 00 00       	call   8010982e <switchkvm>
                // Process is done running for now.
                // It should have changed its p->state before coming back.
                proc = 0;
801052c7:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801052ce:	00 00 00 00 
                ran = 1; // exit loop after this
801052d2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

        if ((ptable.promoteAtTime) == ticks) {
            promoteAll(); // RUNNING, RUNNABLE, SLEEPING
            ptable.promoteAtTime = (ticks + TIME_TO_PROMOTE); // update next time we will promote everything
        }
        for (int i = 0; (i <= MAX) && (ran == 0); ++i) {
801052d9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801052dd:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
801052e1:	7f 0a                	jg     801052ed <scheduler+0x162>
801052e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801052e7:	0f 84 f6 fe ff ff    	je     801051e3 <scheduler+0x58>
                // It should have changed its p->state before coming back.
                proc = 0;
                ran = 1; // exit loop after this
            }
        }
        release(&ptable.lock);
801052ed:	83 ec 0c             	sub    $0xc,%esp
801052f0:	68 80 49 11 80       	push   $0x80114980
801052f5:	e8 e2 15 00 00       	call   801068dc <release>
801052fa:	83 c4 10             	add    $0x10,%esp
        if (idle) {
801052fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105301:	0f 84 8a fe ff ff    	je     80105191 <scheduler+0x6>
            sti();
80105307:	e8 fa f1 ff ff       	call   80104506 <sti>
            hlt();
8010530c:	e8 de f1 ff ff       	call   801044ef <hlt>
        }
    }
80105311:	e9 7b fe ff ff       	jmp    80105191 <scheduler+0x6>

80105316 <sched>:
    cpu->intena = intena;
}
#else
void
sched(void)
{
80105316:	55                   	push   %ebp
80105317:	89 e5                	mov    %esp,%ebp
80105319:	53                   	push   %ebx
8010531a:	83 ec 14             	sub    $0x14,%esp
    int intena;

    if(!holding(&ptable.lock))
8010531d:	83 ec 0c             	sub    $0xc,%esp
80105320:	68 80 49 11 80       	push   $0x80114980
80105325:	e8 7e 16 00 00       	call   801069a8 <holding>
8010532a:	83 c4 10             	add    $0x10,%esp
8010532d:	85 c0                	test   %eax,%eax
8010532f:	75 0d                	jne    8010533e <sched+0x28>
        panic("sched ptable.lock");
80105331:	83 ec 0c             	sub    $0xc,%esp
80105334:	68 24 a6 10 80       	push   $0x8010a624
80105339:	e8 28 b2 ff ff       	call   80100566 <panic>
    if(cpu->ncli != 1)
8010533e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105344:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010534a:	83 f8 01             	cmp    $0x1,%eax
8010534d:	74 0d                	je     8010535c <sched+0x46>
        panic("sched locks");
8010534f:	83 ec 0c             	sub    $0xc,%esp
80105352:	68 36 a6 10 80       	push   $0x8010a636
80105357:	e8 0a b2 ff ff       	call   80100566 <panic>
    if(proc->state == RUNNING)
8010535c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105362:	8b 40 0c             	mov    0xc(%eax),%eax
80105365:	83 f8 04             	cmp    $0x4,%eax
80105368:	75 0d                	jne    80105377 <sched+0x61>
        panic("sched running");
8010536a:	83 ec 0c             	sub    $0xc,%esp
8010536d:	68 42 a6 10 80       	push   $0x8010a642
80105372:	e8 ef b1 ff ff       	call   80100566 <panic>
    if(readeflags()&FL_IF)
80105377:	e8 7a f1 ff ff       	call   801044f6 <readeflags>
8010537c:	25 00 02 00 00       	and    $0x200,%eax
80105381:	85 c0                	test   %eax,%eax
80105383:	74 0d                	je     80105392 <sched+0x7c>
        panic("sched interruptible");
80105385:	83 ec 0c             	sub    $0xc,%esp
80105388:	68 50 a6 10 80       	push   $0x8010a650
8010538d:	e8 d4 b1 ff ff       	call   80100566 <panic>
    intena = cpu->intena;
80105392:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105398:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010539e:	89 45 f4             	mov    %eax,-0xc(%ebp)

    proc->cpu_ticks_total += (ticks - proc->cpu_ticks_in);
801053a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053a7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053ae:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801053b4:	8b 1d e0 78 11 80    	mov    0x801178e0,%ebx
801053ba:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053c1:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801053c7:	29 d3                	sub    %edx,%ebx
801053c9:	89 da                	mov    %ebx,%edx
801053cb:	01 ca                	add    %ecx,%edx
801053cd:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)

    swtch(&proc->context, cpu->scheduler);
801053d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053d9:	8b 40 04             	mov    0x4(%eax),%eax
801053dc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053e3:	83 c2 1c             	add    $0x1c,%edx
801053e6:	83 ec 08             	sub    $0x8,%esp
801053e9:	50                   	push   %eax
801053ea:	52                   	push   %edx
801053eb:	e8 5c 19 00 00       	call   80106d4c <swtch>
801053f0:	83 c4 10             	add    $0x10,%esp

    cpu->intena = intena;
801053f3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801053fc:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105402:	90                   	nop
80105403:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105406:	c9                   	leave  
80105407:	c3                   	ret    

80105408 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105408:	55                   	push   %ebp
80105409:	89 e5                	mov    %esp,%ebp
8010540b:	53                   	push   %ebx
8010540c:	83 ec 04             	sub    $0x4,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
8010540f:	83 ec 0c             	sub    $0xc,%esp
80105412:	68 80 49 11 80       	push   $0x80114980
80105417:	e8 59 14 00 00       	call   80106875 <acquire>
8010541c:	83 c4 10             	add    $0x10,%esp

#ifdef CS333_P3P4
    assertState(proc, RUNNING);
8010541f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105425:	83 ec 08             	sub    $0x8,%esp
80105428:	6a 04                	push   $0x4
8010542a:	50                   	push   %eax
8010542b:	e8 0e 0b 00 00       	call   80105f3e <assertState>
80105430:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
80105433:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105439:	83 ec 08             	sub    $0x8,%esp
8010543c:	50                   	push   %eax
8010543d:	68 d0 70 11 80       	push   $0x801170d0
80105442:	e8 18 0c 00 00       	call   8010605f <removeFromStateList>
80105447:	83 c4 10             	add    $0x10,%esp
8010544a:	85 c0                	test   %eax,%eax
8010544c:	79 10                	jns    8010545e <yield+0x56>
        cprintf("Failed to remove RUNNING proc to list (yeild).");
8010544e:	83 ec 0c             	sub    $0xc,%esp
80105451:	68 64 a6 10 80       	push   $0x8010a664
80105456:	e8 6b af ff ff       	call   801003c6 <cprintf>
8010545b:	83 c4 10             	add    $0x10,%esp
    }
#endif

    proc->state = RUNNABLE;
8010545e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105464:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

#ifdef CS333_P3P4
    proc->budget -= (ticks - proc->cpu_ticks_in); // update budget, then check
8010546b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105471:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105478:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
8010547e:	89 d3                	mov    %edx,%ebx
80105480:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105487:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
8010548d:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105493:	29 d1                	sub    %edx,%ecx
80105495:	89 ca                	mov    %ecx,%edx
80105497:	01 da                	add    %ebx,%edx
80105499:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if ((proc->budget) <= 0) {
8010549f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054a5:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801054ab:	85 c0                	test   %eax,%eax
801054ad:	7f 36                	jg     801054e5 <yield+0xdd>
        if ((proc->priority) < MAX) {
801054af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054b5:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801054bb:	83 f8 02             	cmp    $0x2,%eax
801054be:	77 15                	ja     801054d5 <yield+0xcd>
            ++(proc->priority); // Demotion
801054c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054c6:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
801054cc:	83 c2 01             	add    $0x1,%edx
801054cf:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        }
        proc->budget = BUDGET; // Reset budget
801054d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054db:	c7 80 98 00 00 00 fa 	movl   $0xfa,0x98(%eax)
801054e2:	00 00 00 
    }

    if (addToStateListEnd(&ptable.pLists.ready[proc->priority], proc) < 0) {
801054e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054eb:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054f2:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
801054f8:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
801054fe:	c1 e2 02             	shl    $0x2,%edx
80105501:	81 c2 80 49 11 80    	add    $0x80114980,%edx
80105507:	83 c2 04             	add    $0x4,%edx
8010550a:	83 ec 08             	sub    $0x8,%esp
8010550d:	50                   	push   %eax
8010550e:	52                   	push   %edx
8010550f:	e8 ca 0a 00 00       	call   80105fde <addToStateListEnd>
80105514:	83 c4 10             	add    $0x10,%esp
80105517:	85 c0                	test   %eax,%eax
80105519:	79 10                	jns    8010552b <yield+0x123>
        cprintf("Failed to add RUNNABLE proc to list (yeild).");
8010551b:	83 ec 0c             	sub    $0xc,%esp
8010551e:	68 94 a6 10 80       	push   $0x8010a694
80105523:	e8 9e ae ff ff       	call   801003c6 <cprintf>
80105528:	83 c4 10             	add    $0x10,%esp
    }
#endif

    sched();
8010552b:	e8 e6 fd ff ff       	call   80105316 <sched>
    release(&ptable.lock);
80105530:	83 ec 0c             	sub    $0xc,%esp
80105533:	68 80 49 11 80       	push   $0x80114980
80105538:	e8 9f 13 00 00       	call   801068dc <release>
8010553d:	83 c4 10             	add    $0x10,%esp
}
80105540:	90                   	nop
80105541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105544:	c9                   	leave  
80105545:	c3                   	ret    

80105546 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105546:	55                   	push   %ebp
80105547:	89 e5                	mov    %esp,%ebp
80105549:	83 ec 08             	sub    $0x8,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
8010554c:	83 ec 0c             	sub    $0xc,%esp
8010554f:	68 80 49 11 80       	push   $0x80114980
80105554:	e8 83 13 00 00       	call   801068dc <release>
80105559:	83 c4 10             	add    $0x10,%esp

    if (first) {
8010555c:	a1 20 d0 10 80       	mov    0x8010d020,%eax
80105561:	85 c0                	test   %eax,%eax
80105563:	74 24                	je     80105589 <forkret+0x43>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot 
        // be run from main().
        first = 0;
80105565:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
8010556c:	00 00 00 
        iinit(ROOTDEV);
8010556f:	83 ec 0c             	sub    $0xc,%esp
80105572:	6a 01                	push   $0x1
80105574:	e8 76 c1 ff ff       	call   801016ef <iinit>
80105579:	83 c4 10             	add    $0x10,%esp
        initlog(ROOTDEV);
8010557c:	83 ec 0c             	sub    $0xc,%esp
8010557f:	6a 01                	push   $0x1
80105581:	e8 5a de ff ff       	call   801033e0 <initlog>
80105586:	83 c4 10             	add    $0x10,%esp
    }

    // Return to "caller", actually trapret (see allocproc).
}
80105589:	90                   	nop
8010558a:	c9                   	leave  
8010558b:	c3                   	ret    

8010558c <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
8010558c:	55                   	push   %ebp
8010558d:	89 e5                	mov    %esp,%ebp
8010558f:	53                   	push   %ebx
80105590:	83 ec 04             	sub    $0x4,%esp
    if(proc == 0)
80105593:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105599:	85 c0                	test   %eax,%eax
8010559b:	75 0d                	jne    801055aa <sleep+0x1e>
        panic("sleep");
8010559d:	83 ec 0c             	sub    $0xc,%esp
801055a0:	68 c1 a6 10 80       	push   $0x8010a6c1
801055a5:	e8 bc af ff ff       	call   80100566 <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){
801055aa:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801055b1:	74 24                	je     801055d7 <sleep+0x4b>
        acquire(&ptable.lock);
801055b3:	83 ec 0c             	sub    $0xc,%esp
801055b6:	68 80 49 11 80       	push   $0x80114980
801055bb:	e8 b5 12 00 00       	call   80106875 <acquire>
801055c0:	83 c4 10             	add    $0x10,%esp
        if (lk) release(lk);
801055c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801055c7:	74 0e                	je     801055d7 <sleep+0x4b>
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	ff 75 0c             	pushl  0xc(%ebp)
801055cf:	e8 08 13 00 00       	call   801068dc <release>
801055d4:	83 c4 10             	add    $0x10,%esp
    }

    // Go to sleep.
    proc->chan = chan;
801055d7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055dd:	8b 55 08             	mov    0x8(%ebp),%edx
801055e0:	89 50 20             	mov    %edx,0x20(%eax)

#ifdef CS333_P3P4
    assertState(proc, RUNNING);
801055e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e9:	83 ec 08             	sub    $0x8,%esp
801055ec:	6a 04                	push   $0x4
801055ee:	50                   	push   %eax
801055ef:	e8 4a 09 00 00       	call   80105f3e <assertState>
801055f4:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
801055f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055fd:	83 ec 08             	sub    $0x8,%esp
80105600:	50                   	push   %eax
80105601:	68 d0 70 11 80       	push   $0x801170d0
80105606:	e8 54 0a 00 00       	call   8010605f <removeFromStateList>
8010560b:	83 c4 10             	add    $0x10,%esp
8010560e:	85 c0                	test   %eax,%eax
80105610:	79 10                	jns    80105622 <sleep+0x96>
        cprintf("Could not remove RUNNING proc from list (sleep()).\n");
80105612:	83 ec 0c             	sub    $0xc,%esp
80105615:	68 c8 a6 10 80       	push   $0x8010a6c8
8010561a:	e8 a7 ad ff ff       	call   801003c6 <cprintf>
8010561f:	83 c4 10             	add    $0x10,%esp
    }
#endif

    proc->state = SLEEPING;
80105622:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105628:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

#ifdef CS333_P3P4
    proc->budget -= (ticks - proc->cpu_ticks_in); // update budegt, then check
8010562f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105635:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010563c:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
80105642:	89 d3                	mov    %edx,%ebx
80105644:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010564b:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
80105651:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105657:	29 d1                	sub    %edx,%ecx
80105659:	89 ca                	mov    %ecx,%edx
8010565b:	01 da                	add    %ebx,%edx
8010565d:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if ((proc->budget) <= 0) {
80105663:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105669:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010566f:	85 c0                	test   %eax,%eax
80105671:	7f 36                	jg     801056a9 <sleep+0x11d>
        // priority cant be greater than MAX bc it is literal index of ready list array
        if ((proc->priority) < MAX) {
80105673:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105679:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010567f:	83 f8 02             	cmp    $0x2,%eax
80105682:	77 15                	ja     80105699 <sleep+0x10d>
            ++(proc->priority); // Demotion
80105684:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010568a:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105690:	83 c2 01             	add    $0x1,%edx
80105693:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        }
        proc->budget = BUDGET; // Reset budget
80105699:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010569f:	c7 80 98 00 00 00 fa 	movl   $0xfa,0x98(%eax)
801056a6:	00 00 00 
    }
    if (addToStateListEnd(&ptable.pLists.sleep, proc) < 0) {
801056a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056af:	83 ec 08             	sub    $0x8,%esp
801056b2:	50                   	push   %eax
801056b3:	68 c8 70 11 80       	push   $0x801170c8
801056b8:	e8 21 09 00 00       	call   80105fde <addToStateListEnd>
801056bd:	83 c4 10             	add    $0x10,%esp
801056c0:	85 c0                	test   %eax,%eax
801056c2:	79 10                	jns    801056d4 <sleep+0x148>
        cprintf("Could not add SLEEPING proc to list (sleep()).\n");
801056c4:	83 ec 0c             	sub    $0xc,%esp
801056c7:	68 fc a6 10 80       	push   $0x8010a6fc
801056cc:	e8 f5 ac ff ff       	call   801003c6 <cprintf>
801056d1:	83 c4 10             	add    $0x10,%esp
    }
#endif

    sched();
801056d4:	e8 3d fc ff ff       	call   80105316 <sched>

    // Tidy up.
    proc->chan = 0;
801056d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056df:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){ 
801056e6:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801056ed:	74 24                	je     80105713 <sleep+0x187>
        release(&ptable.lock);
801056ef:	83 ec 0c             	sub    $0xc,%esp
801056f2:	68 80 49 11 80       	push   $0x80114980
801056f7:	e8 e0 11 00 00       	call   801068dc <release>
801056fc:	83 c4 10             	add    $0x10,%esp
        if (lk) acquire(lk);
801056ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105703:	74 0e                	je     80105713 <sleep+0x187>
80105705:	83 ec 0c             	sub    $0xc,%esp
80105708:	ff 75 0c             	pushl  0xc(%ebp)
8010570b:	e8 65 11 00 00       	call   80106875 <acquire>
80105710:	83 c4 10             	add    $0x10,%esp
    }
}
80105713:	90                   	nop
80105714:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105717:	c9                   	leave  
80105718:	c3                   	ret    

80105719 <wakeup1>:
}
#else
// P3 wakeup1
static void
wakeup1(void *chan)
{
80105719:	55                   	push   %ebp
8010571a:	89 e5                	mov    %esp,%ebp
8010571c:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    if (ptable.pLists.sleep) {
8010571f:	a1 c8 70 11 80       	mov    0x801170c8,%eax
80105724:	85 c0                	test   %eax,%eax
80105726:	0f 84 b8 00 00 00    	je     801057e4 <wakeup1+0xcb>
        struct proc * current = ptable.pLists.sleep;
8010572c:	a1 c8 70 11 80       	mov    0x801170c8,%eax
80105731:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = 0;
80105734:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        while (current) {
8010573b:	e9 9a 00 00 00       	jmp    801057da <wakeup1+0xc1>
            p = current;
80105740:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105743:	89 45 f0             	mov    %eax,-0x10(%ebp)
            current = current->next;
80105746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105749:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010574f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            assertState(p, SLEEPING);
80105752:	83 ec 08             	sub    $0x8,%esp
80105755:	6a 02                	push   $0x2
80105757:	ff 75 f0             	pushl  -0x10(%ebp)
8010575a:	e8 df 07 00 00       	call   80105f3e <assertState>
8010575f:	83 c4 10             	add    $0x10,%esp
            if (p->chan == chan) {
80105762:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105765:	8b 40 20             	mov    0x20(%eax),%eax
80105768:	3b 45 08             	cmp    0x8(%ebp),%eax
8010576b:	75 6d                	jne    801057da <wakeup1+0xc1>
                if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
8010576d:	83 ec 08             	sub    $0x8,%esp
80105770:	ff 75 f0             	pushl  -0x10(%ebp)
80105773:	68 c8 70 11 80       	push   $0x801170c8
80105778:	e8 e2 08 00 00       	call   8010605f <removeFromStateList>
8010577d:	83 c4 10             	add    $0x10,%esp
80105780:	85 c0                	test   %eax,%eax
80105782:	79 10                	jns    80105794 <wakeup1+0x7b>
                    cprintf("Failed to remove SLEEPING proc to list (wakeup1).\n");
80105784:	83 ec 0c             	sub    $0xc,%esp
80105787:	68 2c a7 10 80       	push   $0x8010a72c
8010578c:	e8 35 ac ff ff       	call   801003c6 <cprintf>
80105791:	83 c4 10             	add    $0x10,%esp
                }
                p->state = RUNNABLE;
80105794:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105797:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
8010579e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057a1:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801057a7:	05 cc 09 00 00       	add    $0x9cc,%eax
801057ac:	c1 e0 02             	shl    $0x2,%eax
801057af:	05 80 49 11 80       	add    $0x80114980,%eax
801057b4:	83 c0 04             	add    $0x4,%eax
801057b7:	83 ec 08             	sub    $0x8,%esp
801057ba:	ff 75 f0             	pushl  -0x10(%ebp)
801057bd:	50                   	push   %eax
801057be:	e8 1b 08 00 00       	call   80105fde <addToStateListEnd>
801057c3:	83 c4 10             	add    $0x10,%esp
801057c6:	85 c0                	test   %eax,%eax
801057c8:	79 10                	jns    801057da <wakeup1+0xc1>
                    cprintf("Failed to add RUNNABLE proc to list (wakeup1).\n");
801057ca:	83 ec 0c             	sub    $0xc,%esp
801057cd:	68 60 a7 10 80       	push   $0x8010a760
801057d2:	e8 ef ab ff ff       	call   801003c6 <cprintf>
801057d7:	83 c4 10             	add    $0x10,%esp
{
    struct proc *p;
    if (ptable.pLists.sleep) {
        struct proc * current = ptable.pLists.sleep;
        p = 0;
        while (current) {
801057da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057de:	0f 85 5c ff ff ff    	jne    80105740 <wakeup1+0x27>
                    cprintf("Failed to add RUNNABLE proc to list (wakeup1).\n");
                }
            }
        }
    }
}
801057e4:	90                   	nop
801057e5:	c9                   	leave  
801057e6:	c3                   	ret    

801057e7 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801057e7:	55                   	push   %ebp
801057e8:	89 e5                	mov    %esp,%ebp
801057ea:	83 ec 08             	sub    $0x8,%esp
    acquire(&ptable.lock);
801057ed:	83 ec 0c             	sub    $0xc,%esp
801057f0:	68 80 49 11 80       	push   $0x80114980
801057f5:	e8 7b 10 00 00       	call   80106875 <acquire>
801057fa:	83 c4 10             	add    $0x10,%esp
    wakeup1(chan);
801057fd:	83 ec 0c             	sub    $0xc,%esp
80105800:	ff 75 08             	pushl  0x8(%ebp)
80105803:	e8 11 ff ff ff       	call   80105719 <wakeup1>
80105808:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
8010580b:	83 ec 0c             	sub    $0xc,%esp
8010580e:	68 80 49 11 80       	push   $0x80114980
80105813:	e8 c4 10 00 00       	call   801068dc <release>
80105818:	83 c4 10             	add    $0x10,%esp
}
8010581b:	90                   	nop
8010581c:	c9                   	leave  
8010581d:	c3                   	ret    

8010581e <kill>:
    return -1;
}
#else
int
kill(int pid)
{
8010581e:	55                   	push   %ebp
8010581f:	89 e5                	mov    %esp,%ebp
80105821:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;

    acquire(&ptable.lock);
80105824:	83 ec 0c             	sub    $0xc,%esp
80105827:	68 80 49 11 80       	push   $0x80114980
8010582c:	e8 44 10 00 00       	call   80106875 <acquire>
80105831:	83 c4 10             	add    $0x10,%esp
    // traverse Sleeping list, wake processes if necessary
    p = ptable.pLists.sleep;
80105834:	a1 c8 70 11 80       	mov    0x801170c8,%eax
80105839:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
8010583c:	e9 be 00 00 00       	jmp    801058ff <kill+0xe1>
        if (p->pid == pid) {
80105841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105844:	8b 50 10             	mov    0x10(%eax),%edx
80105847:	8b 45 08             	mov    0x8(%ebp),%eax
8010584a:	39 c2                	cmp    %eax,%edx
8010584c:	0f 85 a1 00 00 00    	jne    801058f3 <kill+0xd5>
            p->killed = 1;
80105852:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105855:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            assertState(p, SLEEPING);
8010585c:	83 ec 08             	sub    $0x8,%esp
8010585f:	6a 02                	push   $0x2
80105861:	ff 75 f4             	pushl  -0xc(%ebp)
80105864:	e8 d5 06 00 00       	call   80105f3e <assertState>
80105869:	83 c4 10             	add    $0x10,%esp
            if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
8010586c:	83 ec 08             	sub    $0x8,%esp
8010586f:	ff 75 f4             	pushl  -0xc(%ebp)
80105872:	68 c8 70 11 80       	push   $0x801170c8
80105877:	e8 e3 07 00 00       	call   8010605f <removeFromStateList>
8010587c:	83 c4 10             	add    $0x10,%esp
8010587f:	85 c0                	test   %eax,%eax
80105881:	79 10                	jns    80105893 <kill+0x75>
                cprintf("Could not remove SLEEPING proc from list (kill).\n");
80105883:	83 ec 0c             	sub    $0xc,%esp
80105886:	68 90 a7 10 80       	push   $0x8010a790
8010588b:	e8 36 ab ff ff       	call   801003c6 <cprintf>
80105890:	83 c4 10             	add    $0x10,%esp
            }
            p->state = RUNNABLE;
80105893:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105896:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
8010589d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058a0:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801058a6:	05 cc 09 00 00       	add    $0x9cc,%eax
801058ab:	c1 e0 02             	shl    $0x2,%eax
801058ae:	05 80 49 11 80       	add    $0x80114980,%eax
801058b3:	83 c0 04             	add    $0x4,%eax
801058b6:	83 ec 08             	sub    $0x8,%esp
801058b9:	ff 75 f4             	pushl  -0xc(%ebp)
801058bc:	50                   	push   %eax
801058bd:	e8 1c 07 00 00       	call   80105fde <addToStateListEnd>
801058c2:	83 c4 10             	add    $0x10,%esp
801058c5:	85 c0                	test   %eax,%eax
801058c7:	79 10                	jns    801058d9 <kill+0xbb>
                cprintf("Could not add RUNNABLE proc to list (kill).\n");
801058c9:	83 ec 0c             	sub    $0xc,%esp
801058cc:	68 c4 a7 10 80       	push   $0x8010a7c4
801058d1:	e8 f0 aa ff ff       	call   801003c6 <cprintf>
801058d6:	83 c4 10             	add    $0x10,%esp
            }
            release(&ptable.lock);
801058d9:	83 ec 0c             	sub    $0xc,%esp
801058dc:	68 80 49 11 80       	push   $0x80114980
801058e1:	e8 f6 0f 00 00       	call   801068dc <release>
801058e6:	83 c4 10             	add    $0x10,%esp
            return 0;
801058e9:	b8 00 00 00 00       	mov    $0x0,%eax
801058ee:	e9 c3 01 00 00       	jmp    80105ab6 <kill+0x298>
        }
        p = p->next;
801058f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801058fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct proc *p;

    acquire(&ptable.lock);
    // traverse Sleeping list, wake processes if necessary
    p = ptable.pLists.sleep;
    while (p) {
801058ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105903:	0f 85 38 ff ff ff    	jne    80105841 <kill+0x23>
        }
        p = p->next;
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
80105909:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105910:	eb 5b                	jmp    8010596d <kill+0x14f>
        p = ptable.pLists.ready[i];
80105912:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105915:	05 cc 09 00 00       	add    $0x9cc,%eax
8010591a:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80105921:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
80105924:	eb 3d                	jmp    80105963 <kill+0x145>
            if (p->pid == pid) {
80105926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105929:	8b 50 10             	mov    0x10(%eax),%edx
8010592c:	8b 45 08             	mov    0x8(%ebp),%eax
8010592f:	39 c2                	cmp    %eax,%edx
80105931:	75 24                	jne    80105957 <kill+0x139>
                p->killed = 1;
80105933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105936:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
                release(&ptable.lock);
8010593d:	83 ec 0c             	sub    $0xc,%esp
80105940:	68 80 49 11 80       	push   $0x80114980
80105945:	e8 92 0f 00 00       	call   801068dc <release>
8010594a:	83 c4 10             	add    $0x10,%esp
                return 0;
8010594d:	b8 00 00 00 00       	mov    $0x0,%eax
80105952:	e9 5f 01 00 00       	jmp    80105ab6 <kill+0x298>
            }
            p = p->next;
80105957:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010595a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105960:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i];
        while (p) {
80105963:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105967:	75 bd                	jne    80105926 <kill+0x108>
        }
        p = p->next;
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
80105969:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010596d:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
80105971:	7e 9f                	jle    80105912 <kill+0xf4>
            p = p->next;
        }
    }

    // traverse Running list
    p = ptable.pLists.running;
80105973:	a1 d0 70 11 80       	mov    0x801170d0,%eax
80105978:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
8010597b:	eb 3d                	jmp    801059ba <kill+0x19c>
        if (p->pid == pid) {
8010597d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105980:	8b 50 10             	mov    0x10(%eax),%edx
80105983:	8b 45 08             	mov    0x8(%ebp),%eax
80105986:	39 c2                	cmp    %eax,%edx
80105988:	75 24                	jne    801059ae <kill+0x190>
            p->killed = 1;
8010598a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105994:	83 ec 0c             	sub    $0xc,%esp
80105997:	68 80 49 11 80       	push   $0x80114980
8010599c:	e8 3b 0f 00 00       	call   801068dc <release>
801059a1:	83 c4 10             	add    $0x10,%esp
            return 0;
801059a4:	b8 00 00 00 00       	mov    $0x0,%eax
801059a9:	e9 08 01 00 00       	jmp    80105ab6 <kill+0x298>
        }
        p = p->next;
801059ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059b1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
    }

    // traverse Running list
    p = ptable.pLists.running;
    while (p) {
801059ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059be:	75 bd                	jne    8010597d <kill+0x15f>
        }
        p = p->next;
    }

    // traverse Unused List
    p = ptable.pLists.free;
801059c0:	a1 c4 70 11 80       	mov    0x801170c4,%eax
801059c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801059c8:	eb 3d                	jmp    80105a07 <kill+0x1e9>
        if (p->pid == pid) {
801059ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059cd:	8b 50 10             	mov    0x10(%eax),%edx
801059d0:	8b 45 08             	mov    0x8(%ebp),%eax
801059d3:	39 c2                	cmp    %eax,%edx
801059d5:	75 24                	jne    801059fb <kill+0x1dd>
            p->killed = 1;
801059d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059da:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
801059e1:	83 ec 0c             	sub    $0xc,%esp
801059e4:	68 80 49 11 80       	push   $0x80114980
801059e9:	e8 ee 0e 00 00       	call   801068dc <release>
801059ee:	83 c4 10             	add    $0x10,%esp
            return 0;
801059f1:	b8 00 00 00 00       	mov    $0x0,%eax
801059f6:	e9 bb 00 00 00       	jmp    80105ab6 <kill+0x298>
        }
        p = p->next;
801059fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059fe:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Unused List
    p = ptable.pLists.free;
    while (p) {
80105a07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a0b:	75 bd                	jne    801059ca <kill+0x1ac>
        }
        p = p->next;
    }

    // traverse Zombie list
    p = ptable.pLists.zombie;
80105a0d:	a1 cc 70 11 80       	mov    0x801170cc,%eax
80105a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105a15:	eb 3a                	jmp    80105a51 <kill+0x233>
        if (p->pid == pid) {
80105a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a1a:	8b 50 10             	mov    0x10(%eax),%edx
80105a1d:	8b 45 08             	mov    0x8(%ebp),%eax
80105a20:	39 c2                	cmp    %eax,%edx
80105a22:	75 21                	jne    80105a45 <kill+0x227>
            p->killed = 1;
80105a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a27:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105a2e:	83 ec 0c             	sub    $0xc,%esp
80105a31:	68 80 49 11 80       	push   $0x80114980
80105a36:	e8 a1 0e 00 00       	call   801068dc <release>
80105a3b:	83 c4 10             	add    $0x10,%esp
            return 0;
80105a3e:	b8 00 00 00 00       	mov    $0x0,%eax
80105a43:	eb 71                	jmp    80105ab6 <kill+0x298>
        }
        p = p->next;
80105a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a48:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Zombie list
    p = ptable.pLists.zombie;
    while (p) {
80105a51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a55:	75 c0                	jne    80105a17 <kill+0x1f9>
        }
        p = p->next;
    }

    // traverse Embryo list
    p = ptable.pLists.embryo;
80105a57:	a1 d4 70 11 80       	mov    0x801170d4,%eax
80105a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105a5f:	eb 3a                	jmp    80105a9b <kill+0x27d>
        if (p->pid == pid) {
80105a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a64:	8b 50 10             	mov    0x10(%eax),%edx
80105a67:	8b 45 08             	mov    0x8(%ebp),%eax
80105a6a:	39 c2                	cmp    %eax,%edx
80105a6c:	75 21                	jne    80105a8f <kill+0x271>
            p->killed = 1;
80105a6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a71:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	68 80 49 11 80       	push   $0x80114980
80105a80:	e8 57 0e 00 00       	call   801068dc <release>
80105a85:	83 c4 10             	add    $0x10,%esp
            return 0;
80105a88:	b8 00 00 00 00       	mov    $0x0,%eax
80105a8d:	eb 27                	jmp    80105ab6 <kill+0x298>
        }
        p = p->next;
80105a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a92:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a98:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Embryo list
    p = ptable.pLists.embryo;
    while (p) {
80105a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a9f:	75 c0                	jne    80105a61 <kill+0x243>
        }
        p = p->next;
    }

    // return error
    release(&ptable.lock);
80105aa1:	83 ec 0c             	sub    $0xc,%esp
80105aa4:	68 80 49 11 80       	push   $0x80114980
80105aa9:	e8 2e 0e 00 00       	call   801068dc <release>
80105aae:	83 c4 10             	add    $0x10,%esp
    return -1;
80105ab1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ab6:	c9                   	leave  
80105ab7:	c3                   	ret    

80105ab8 <elapsed_time>:
// No lock to avoid wedging a stuck machine further.

#ifdef CS333_P1
void
elapsed_time(uint p_ticks)
{
80105ab8:	55                   	push   %ebp
80105ab9:	89 e5                	mov    %esp,%ebp
80105abb:	83 ec 28             	sub    $0x28,%esp
    uint elapsed, whole_sec, milisec_ten, milisec_hund, milisec_thou;
    //elapsed = ticks - p->start_ticks; // find original elapsed time
    elapsed = p_ticks;
80105abe:	8b 45 08             	mov    0x8(%ebp),%eax
80105ac1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    whole_sec = (elapsed / 1000); // the the left of the decimal point
80105ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac7:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105acc:	f7 e2                	mul    %edx
80105ace:	89 d0                	mov    %edx,%eax
80105ad0:	c1 e8 06             	shr    $0x6,%eax
80105ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // % to shave off leading digit of elapsed for decimal place calcs
    milisec_ten = ((elapsed %= 1000) / 100); // divide and round up to nearest int
80105ad6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105ad9:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105ade:	89 c8                	mov    %ecx,%eax
80105ae0:	f7 e2                	mul    %edx
80105ae2:	89 d0                	mov    %edx,%eax
80105ae4:	c1 e8 06             	shr    $0x6,%eax
80105ae7:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
80105aed:	29 c1                	sub    %eax,%ecx
80105aef:	89 c8                	mov    %ecx,%eax
80105af1:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af7:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105afc:	f7 e2                	mul    %edx
80105afe:	89 d0                	mov    %edx,%eax
80105b00:	c1 e8 05             	shr    $0x5,%eax
80105b03:	89 45 ec             	mov    %eax,-0x14(%ebp)
    milisec_hund = ((elapsed %= 100) / 10); // shave off previously counted int, repeat
80105b06:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105b09:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105b0e:	89 c8                	mov    %ecx,%eax
80105b10:	f7 e2                	mul    %edx
80105b12:	89 d0                	mov    %edx,%eax
80105b14:	c1 e8 05             	shr    $0x5,%eax
80105b17:	6b c0 64             	imul   $0x64,%eax,%eax
80105b1a:	29 c1                	sub    %eax,%ecx
80105b1c:	89 c8                	mov    %ecx,%eax
80105b1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b24:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105b29:	f7 e2                	mul    %edx
80105b2b:	89 d0                	mov    %edx,%eax
80105b2d:	c1 e8 03             	shr    $0x3,%eax
80105b30:	89 45 e8             	mov    %eax,-0x18(%ebp)
    milisec_thou = (elapsed %= 10); // determine thousandth place
80105b33:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105b36:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105b3b:	89 c8                	mov    %ecx,%eax
80105b3d:	f7 e2                	mul    %edx
80105b3f:	c1 ea 03             	shr    $0x3,%edx
80105b42:	89 d0                	mov    %edx,%eax
80105b44:	c1 e0 02             	shl    $0x2,%eax
80105b47:	01 d0                	add    %edx,%eax
80105b49:	01 c0                	add    %eax,%eax
80105b4b:	29 c1                	sub    %eax,%ecx
80105b4d:	89 c8                	mov    %ecx,%eax
80105b4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("\t%d.%d%d%d", whole_sec, milisec_ten, milisec_hund, milisec_thou);
80105b58:	83 ec 0c             	sub    $0xc,%esp
80105b5b:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b5e:	ff 75 e8             	pushl  -0x18(%ebp)
80105b61:	ff 75 ec             	pushl  -0x14(%ebp)
80105b64:	ff 75 f0             	pushl  -0x10(%ebp)
80105b67:	68 f1 a7 10 80       	push   $0x8010a7f1
80105b6c:	e8 55 a8 ff ff       	call   801003c6 <cprintf>
80105b71:	83 c4 20             	add    $0x20,%esp
}
80105b74:	90                   	nop
80105b75:	c9                   	leave  
80105b76:	c3                   	ret    

80105b77 <procdump>:
#else

// Project 3 & 4
void
procdump(void)
{
80105b77:	55                   	push   %ebp
80105b78:	89 e5                	mov    %esp,%ebp
80105b7a:	56                   	push   %esi
80105b7b:	53                   	push   %ebx
80105b7c:	83 ec 40             	sub    $0x40,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
80105b7f:	68 fc a7 10 80       	push   $0x8010a7fc
80105b84:	68 00 a8 10 80       	push   $0x8010a800
80105b89:	68 05 a8 10 80       	push   $0x8010a805
80105b8e:	68 0b a8 10 80       	push   $0x8010a80b
80105b93:	68 0f a8 10 80       	push   $0x8010a80f
80105b98:	68 17 a8 10 80       	push   $0x8010a817
80105b9d:	68 1c a8 10 80       	push   $0x8010a81c
80105ba2:	68 21 a8 10 80       	push   $0x8010a821
80105ba7:	68 25 a8 10 80       	push   $0x8010a825
80105bac:	68 29 a8 10 80       	push   $0x8010a829
80105bb1:	68 2e a8 10 80       	push   $0x8010a82e
80105bb6:	68 34 a8 10 80       	push   $0x8010a834
80105bbb:	e8 06 a8 ff ff       	call   801003c6 <cprintf>
80105bc0:	83 c4 30             	add    $0x30,%esp
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105bc3:	c7 45 f0 b4 49 11 80 	movl   $0x801149b4,-0x10(%ebp)
80105bca:	e9 5c 01 00 00       	jmp    80105d2b <procdump+0x1b4>
        if(p->state == UNUSED)
80105bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bd2:	8b 40 0c             	mov    0xc(%eax),%eax
80105bd5:	85 c0                	test   %eax,%eax
80105bd7:	0f 84 46 01 00 00    	je     80105d23 <procdump+0x1ac>
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105be0:	8b 40 0c             	mov    0xc(%eax),%eax
80105be3:	83 f8 05             	cmp    $0x5,%eax
80105be6:	77 23                	ja     80105c0b <procdump+0x94>
80105be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105beb:	8b 40 0c             	mov    0xc(%eax),%eax
80105bee:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105bf5:	85 c0                	test   %eax,%eax
80105bf7:	74 12                	je     80105c0b <procdump+0x94>
            state = states[p->state];
80105bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bfc:	8b 40 0c             	mov    0xc(%eax),%eax
80105bff:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105c06:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105c09:	eb 07                	jmp    80105c12 <procdump+0x9b>
        else
            state = "???";
80105c0b:	c7 45 ec 57 a8 10 80 	movl   $0x8010a857,-0x14(%ebp)
        cprintf("%d\t%s\t%d\t%d\t%d",
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
80105c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c15:	8b 40 14             	mov    0x14(%eax),%eax
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d\t%s\t%d\t%d\t%d",
80105c18:	8b 58 10             	mov    0x10(%eax),%ebx
80105c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1e:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c27:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
80105c2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c30:	8d 70 6c             	lea    0x6c(%eax),%esi
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d\t%s\t%d\t%d\t%d",
80105c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c36:	8b 40 10             	mov    0x10(%eax),%eax
80105c39:	83 ec 08             	sub    $0x8,%esp
80105c3c:	53                   	push   %ebx
80105c3d:	51                   	push   %ecx
80105c3e:	52                   	push   %edx
80105c3f:	56                   	push   %esi
80105c40:	50                   	push   %eax
80105c41:	68 5b a8 10 80       	push   $0x8010a85b
80105c46:	e8 7b a7 ff ff       	call   801003c6 <cprintf>
80105c4b:	83 c4 20             	add    $0x20,%esp
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
        cprintf("\t%d", p->priority);
80105c4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c51:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105c57:	83 ec 08             	sub    $0x8,%esp
80105c5a:	50                   	push   %eax
80105c5b:	68 6a a8 10 80       	push   $0x8010a86a
80105c60:	e8 61 a7 ff ff       	call   801003c6 <cprintf>
80105c65:	83 c4 10             	add    $0x10,%esp
        elapsed_time(ticks - p->start_ticks);
80105c68:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c71:	8b 40 7c             	mov    0x7c(%eax),%eax
80105c74:	29 c2                	sub    %eax,%edx
80105c76:	89 d0                	mov    %edx,%eax
80105c78:	83 ec 0c             	sub    $0xc,%esp
80105c7b:	50                   	push   %eax
80105c7c:	e8 37 fe ff ff       	call   80105ab8 <elapsed_time>
80105c81:	83 c4 10             	add    $0x10,%esp
        elapsed_time(p->cpu_ticks_total);
80105c84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c87:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105c8d:	83 ec 0c             	sub    $0xc,%esp
80105c90:	50                   	push   %eax
80105c91:	e8 22 fe ff ff       	call   80105ab8 <elapsed_time>
80105c96:	83 c4 10             	add    $0x10,%esp
        cprintf("\t%s\t%d", state, p->sz);
80105c99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c9c:	8b 00                	mov    (%eax),%eax
80105c9e:	83 ec 04             	sub    $0x4,%esp
80105ca1:	50                   	push   %eax
80105ca2:	ff 75 ec             	pushl  -0x14(%ebp)
80105ca5:	68 6e a8 10 80       	push   $0x8010a86e
80105caa:	e8 17 a7 ff ff       	call   801003c6 <cprintf>
80105caf:	83 c4 10             	add    $0x10,%esp

        if(p->state == SLEEPING){
80105cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cb5:	8b 40 0c             	mov    0xc(%eax),%eax
80105cb8:	83 f8 02             	cmp    $0x2,%eax
80105cbb:	75 54                	jne    80105d11 <procdump+0x19a>
            getcallerpcs((uint*)p->context->ebp+2, pc);
80105cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cc0:	8b 40 1c             	mov    0x1c(%eax),%eax
80105cc3:	8b 40 0c             	mov    0xc(%eax),%eax
80105cc6:	83 c0 08             	add    $0x8,%eax
80105cc9:	89 c2                	mov    %eax,%edx
80105ccb:	83 ec 08             	sub    $0x8,%esp
80105cce:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105cd1:	50                   	push   %eax
80105cd2:	52                   	push   %edx
80105cd3:	e8 56 0c 00 00       	call   8010692e <getcallerpcs>
80105cd8:	83 c4 10             	add    $0x10,%esp
            for(i=0; i<10 && pc[i] != 0; i++)
80105cdb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105ce2:	eb 1c                	jmp    80105d00 <procdump+0x189>
                cprintf("\t%p", pc[i]);
80105ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce7:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105ceb:	83 ec 08             	sub    $0x8,%esp
80105cee:	50                   	push   %eax
80105cef:	68 75 a8 10 80       	push   $0x8010a875
80105cf4:	e8 cd a6 ff ff       	call   801003c6 <cprintf>
80105cf9:	83 c4 10             	add    $0x10,%esp
        elapsed_time(p->cpu_ticks_total);
        cprintf("\t%s\t%d", state, p->sz);

        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
80105cfc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105d00:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105d04:	7f 0b                	jg     80105d11 <procdump+0x19a>
80105d06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d09:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105d0d:	85 c0                	test   %eax,%eax
80105d0f:	75 d3                	jne    80105ce4 <procdump+0x16d>
                cprintf("\t%p", pc[i]);
        }
        cprintf("\n");
80105d11:	83 ec 0c             	sub    $0xc,%esp
80105d14:	68 79 a8 10 80       	push   $0x8010a879
80105d19:	e8 a8 a6 ff ff       	call   801003c6 <cprintf>
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	eb 01                	jmp    80105d24 <procdump+0x1ad>
    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
80105d23:	90                   	nop
    uint pc[10];

    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d24:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105d2b:	81 7d f0 b4 70 11 80 	cmpl   $0x801170b4,-0x10(%ebp)
80105d32:	0f 82 97 fe ff ff    	jb     80105bcf <procdump+0x58>
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf("\t%p", pc[i]);
        }
        cprintf("\n");
    }
}
80105d38:	90                   	nop
80105d39:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d3c:	5b                   	pop    %ebx
80105d3d:	5e                   	pop    %esi
80105d3e:	5d                   	pop    %ebp
80105d3f:	c3                   	ret    

80105d40 <getprocs>:
#ifdef CS333_P2
// loop process table and copy active processes, return number of copied procs
// populate uproc array passed in from ps.c
int
getprocs(uint max, struct uproc *table)
{
80105d40:	55                   	push   %ebp
80105d41:	89 e5                	mov    %esp,%ebp
80105d43:	83 ec 18             	sub    $0x18,%esp
    int i = 0;
80105d46:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct proc *p;
    acquire(&ptable.lock);
80105d4d:	83 ec 0c             	sub    $0xc,%esp
80105d50:	68 80 49 11 80       	push   $0x80114980
80105d55:	e8 1b 0b 00 00       	call   80106875 <acquire>
80105d5a:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
80105d5d:	c7 45 f0 b4 49 11 80 	movl   $0x801149b4,-0x10(%ebp)
80105d64:	e9 ab 01 00 00       	jmp    80105f14 <getprocs+0x1d4>
        // only copy active processes
        if (p->state == RUNNABLE || p->state == RUNNING || p->state == SLEEPING) {
80105d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d6c:	8b 40 0c             	mov    0xc(%eax),%eax
80105d6f:	83 f8 03             	cmp    $0x3,%eax
80105d72:	74 1a                	je     80105d8e <getprocs+0x4e>
80105d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d77:	8b 40 0c             	mov    0xc(%eax),%eax
80105d7a:	83 f8 04             	cmp    $0x4,%eax
80105d7d:	74 0f                	je     80105d8e <getprocs+0x4e>
80105d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d82:	8b 40 0c             	mov    0xc(%eax),%eax
80105d85:	83 f8 02             	cmp    $0x2,%eax
80105d88:	0f 85 7f 01 00 00    	jne    80105f0d <getprocs+0x1cd>
            table[i].pid = p->pid;
80105d8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d91:	89 d0                	mov    %edx,%eax
80105d93:	01 c0                	add    %eax,%eax
80105d95:	01 d0                	add    %edx,%eax
80105d97:	c1 e0 05             	shl    $0x5,%eax
80105d9a:	89 c2                	mov    %eax,%edx
80105d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d9f:	01 c2                	add    %eax,%edx
80105da1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da4:	8b 40 10             	mov    0x10(%eax),%eax
80105da7:	89 02                	mov    %eax,(%edx)
            table[i].uid = p->uid;
80105da9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dac:	89 d0                	mov    %edx,%eax
80105dae:	01 c0                	add    %eax,%eax
80105db0:	01 d0                	add    %edx,%eax
80105db2:	c1 e0 05             	shl    $0x5,%eax
80105db5:	89 c2                	mov    %eax,%edx
80105db7:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dba:	01 c2                	add    %eax,%edx
80105dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dbf:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105dc5:	89 42 04             	mov    %eax,0x4(%edx)
            table[i].gid = p->gid;
80105dc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dcb:	89 d0                	mov    %edx,%eax
80105dcd:	01 c0                	add    %eax,%eax
80105dcf:	01 d0                	add    %edx,%eax
80105dd1:	c1 e0 05             	shl    $0x5,%eax
80105dd4:	89 c2                	mov    %eax,%edx
80105dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dd9:	01 c2                	add    %eax,%edx
80105ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dde:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105de4:	89 42 08             	mov    %eax,0x8(%edx)
            if (p->pid == 1) {
80105de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dea:	8b 40 10             	mov    0x10(%eax),%eax
80105ded:	83 f8 01             	cmp    $0x1,%eax
80105df0:	75 1c                	jne    80105e0e <getprocs+0xce>
                table[i].ppid = 1;
80105df2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105df5:	89 d0                	mov    %edx,%eax
80105df7:	01 c0                	add    %eax,%eax
80105df9:	01 d0                	add    %edx,%eax
80105dfb:	c1 e0 05             	shl    $0x5,%eax
80105dfe:	89 c2                	mov    %eax,%edx
80105e00:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e03:	01 d0                	add    %edx,%eax
80105e05:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
80105e0c:	eb 1f                	jmp    80105e2d <getprocs+0xed>
            } else {
                table[i].ppid = p->parent->pid;
80105e0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e11:	89 d0                	mov    %edx,%eax
80105e13:	01 c0                	add    %eax,%eax
80105e15:	01 d0                	add    %edx,%eax
80105e17:	c1 e0 05             	shl    $0x5,%eax
80105e1a:	89 c2                	mov    %eax,%edx
80105e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e1f:	01 c2                	add    %eax,%edx
80105e21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e24:	8b 40 14             	mov    0x14(%eax),%eax
80105e27:	8b 40 10             	mov    0x10(%eax),%eax
80105e2a:	89 42 0c             	mov    %eax,0xc(%edx)
            }
#ifdef CS333_P3P4
            table[i].priority = p->priority;
80105e2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e30:	89 d0                	mov    %edx,%eax
80105e32:	01 c0                	add    %eax,%eax
80105e34:	01 d0                	add    %edx,%eax
80105e36:	c1 e0 05             	shl    $0x5,%eax
80105e39:	89 c2                	mov    %eax,%edx
80105e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e3e:	01 c2                	add    %eax,%edx
80105e40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e43:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105e49:	89 42 5c             	mov    %eax,0x5c(%edx)
#endif
            table[i].elapsed_ticks = (ticks - p->start_ticks);
80105e4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e4f:	89 d0                	mov    %edx,%eax
80105e51:	01 c0                	add    %eax,%eax
80105e53:	01 d0                	add    %edx,%eax
80105e55:	c1 e0 05             	shl    $0x5,%eax
80105e58:	89 c2                	mov    %eax,%edx
80105e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e5d:	01 c2                	add    %eax,%edx
80105e5f:	8b 0d e0 78 11 80    	mov    0x801178e0,%ecx
80105e65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e68:	8b 40 7c             	mov    0x7c(%eax),%eax
80105e6b:	29 c1                	sub    %eax,%ecx
80105e6d:	89 c8                	mov    %ecx,%eax
80105e6f:	89 42 10             	mov    %eax,0x10(%edx)
            table[i].CPU_total_ticks = p->cpu_ticks_total;
80105e72:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e75:	89 d0                	mov    %edx,%eax
80105e77:	01 c0                	add    %eax,%eax
80105e79:	01 d0                	add    %edx,%eax
80105e7b:	c1 e0 05             	shl    $0x5,%eax
80105e7e:	89 c2                	mov    %eax,%edx
80105e80:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e83:	01 c2                	add    %eax,%edx
80105e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e88:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105e8e:	89 42 14             	mov    %eax,0x14(%edx)
            safestrcpy(table[i].state, states[p->state], STRMAX);
80105e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e94:	8b 40 0c             	mov    0xc(%eax),%eax
80105e97:	8b 0c 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%ecx
80105e9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ea1:	89 d0                	mov    %edx,%eax
80105ea3:	01 c0                	add    %eax,%eax
80105ea5:	01 d0                	add    %edx,%eax
80105ea7:	c1 e0 05             	shl    $0x5,%eax
80105eaa:	89 c2                	mov    %eax,%edx
80105eac:	8b 45 0c             	mov    0xc(%ebp),%eax
80105eaf:	01 d0                	add    %edx,%eax
80105eb1:	83 c0 18             	add    $0x18,%eax
80105eb4:	83 ec 04             	sub    $0x4,%esp
80105eb7:	6a 20                	push   $0x20
80105eb9:	51                   	push   %ecx
80105eba:	50                   	push   %eax
80105ebb:	e8 1b 0e 00 00       	call   80106cdb <safestrcpy>
80105ec0:	83 c4 10             	add    $0x10,%esp
            table[i].size = p->sz;
80105ec3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ec6:	89 d0                	mov    %edx,%eax
80105ec8:	01 c0                	add    %eax,%eax
80105eca:	01 d0                	add    %edx,%eax
80105ecc:	c1 e0 05             	shl    $0x5,%eax
80105ecf:	89 c2                	mov    %eax,%edx
80105ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ed4:	01 c2                	add    %eax,%edx
80105ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed9:	8b 00                	mov    (%eax),%eax
80105edb:	89 42 38             	mov    %eax,0x38(%edx)
            safestrcpy(table[i].name, p->name, STRMAX);
80105ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ee1:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105ee4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ee7:	89 d0                	mov    %edx,%eax
80105ee9:	01 c0                	add    %eax,%eax
80105eeb:	01 d0                	add    %edx,%eax
80105eed:	c1 e0 05             	shl    $0x5,%eax
80105ef0:	89 c2                	mov    %eax,%edx
80105ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ef5:	01 d0                	add    %edx,%eax
80105ef7:	83 c0 3c             	add    $0x3c,%eax
80105efa:	83 ec 04             	sub    $0x4,%esp
80105efd:	6a 20                	push   $0x20
80105eff:	51                   	push   %ecx
80105f00:	50                   	push   %eax
80105f01:	e8 d5 0d 00 00       	call   80106cdb <safestrcpy>
80105f06:	83 c4 10             	add    $0x10,%esp
            ++i;
80105f09:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
getprocs(uint max, struct uproc *table)
{
    int i = 0;
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
80105f0d:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105f14:	81 7d f0 b4 70 11 80 	cmpl   $0x801170b4,-0x10(%ebp)
80105f1b:	73 0c                	jae    80105f29 <getprocs+0x1e9>
80105f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f20:	3b 45 08             	cmp    0x8(%ebp),%eax
80105f23:	0f 82 40 fe ff ff    	jb     80105d69 <getprocs+0x29>
            table[i].size = p->sz;
            safestrcpy(table[i].name, p->name, STRMAX);
            ++i;
        }
    }
    release(&ptable.lock);
80105f29:	83 ec 0c             	sub    $0xc,%esp
80105f2c:	68 80 49 11 80       	push   $0x80114980
80105f31:	e8 a6 09 00 00       	call   801068dc <release>
80105f36:	83 c4 10             	add    $0x10,%esp
    return i; // return number of procs copied
80105f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f3c:	c9                   	leave  
80105f3d:	c3                   	ret    

80105f3e <assertState>:


//PROJECT 3
// assert that process is in proper state, otherwise panic
static void
assertState(struct proc* p, enum procstate state) {
80105f3e:	55                   	push   %ebp
80105f3f:	89 e5                	mov    %esp,%ebp
80105f41:	83 ec 08             	sub    $0x8,%esp
    if (!p) {
80105f44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105f48:	75 0d                	jne    80105f57 <assertState+0x19>
        panic("assertState: invalid proc argument.\n");
80105f4a:	83 ec 0c             	sub    $0xc,%esp
80105f4d:	68 7c a8 10 80       	push   $0x8010a87c
80105f52:	e8 0f a6 ff ff       	call   80100566 <panic>
    }
    if (p->state != state) {
80105f57:	8b 45 08             	mov    0x8(%ebp),%eax
80105f5a:	8b 40 0c             	mov    0xc(%eax),%eax
80105f5d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105f60:	74 0d                	je     80105f6f <assertState+0x31>
        //cprintf("Process in state: %s.\n", p->state);
        panic("assertState: process in wrong state.\n");
80105f62:	83 ec 0c             	sub    $0xc,%esp
80105f65:	68 a4 a8 10 80       	push   $0x8010a8a4
80105f6a:	e8 f7 a5 ff ff       	call   80100566 <panic>
    }
}
80105f6f:	90                   	nop
80105f70:	c9                   	leave  
80105f71:	c3                   	ret    

80105f72 <addToStateListHead>:

static int
addToStateListHead(struct proc** sList, struct proc* p) {
80105f72:	55                   	push   %ebp
80105f73:	89 e5                	mov    %esp,%ebp
80105f75:	83 ec 08             	sub    $0x8,%esp
    if (!p) {
80105f78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105f7c:	75 0d                	jne    80105f8b <addToStateListHead+0x19>
        panic("Invalid process.");
80105f7e:	83 ec 0c             	sub    $0xc,%esp
80105f81:	68 ca a8 10 80       	push   $0x8010a8ca
80105f86:	e8 db a5 ff ff       	call   80100566 <panic>
    }
    if (!(*sList)) { // if no list exists, make first entry
80105f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80105f8e:	8b 00                	mov    (%eax),%eax
80105f90:	85 c0                	test   %eax,%eax
80105f92:	75 1c                	jne    80105fb0 <addToStateListHead+0x3e>
        (*sList) = p; // arg proc is now the first item in list
80105f94:	8b 45 08             	mov    0x8(%ebp),%eax
80105f97:	8b 55 0c             	mov    0xc(%ebp),%edx
80105f9a:	89 10                	mov    %edx,(%eax)
        p->next = 0; // next is null
80105f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f9f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105fa6:	00 00 00 
        return 0; // return success
80105fa9:	b8 00 00 00 00       	mov    $0x0,%eax
80105fae:	eb 2c                	jmp    80105fdc <addToStateListHead+0x6a>
    }
    // otherwise hold to next element and become 1st element
    p->next = (*sList); // arg proc has next element
80105fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80105fb3:	8b 10                	mov    (%eax),%edx
80105fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fb8:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    (*sList) = p; // reassign head of list to arg proc
80105fbe:	8b 45 08             	mov    0x8(%ebp),%eax
80105fc1:	8b 55 0c             	mov    0xc(%ebp),%edx
80105fc4:	89 10                	mov    %edx,(%eax)
    if (p != (*sList)) {
80105fc6:	8b 45 08             	mov    0x8(%ebp),%eax
80105fc9:	8b 00                	mov    (%eax),%eax
80105fcb:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105fce:	74 07                	je     80105fd7 <addToStateListHead+0x65>
        return -1; // if they don't match, return failure
80105fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fd5:	eb 05                	jmp    80105fdc <addToStateListHead+0x6a>
    }
    return 0; // return success
80105fd7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fdc:	c9                   	leave  
80105fdd:	c3                   	ret    

80105fde <addToStateListEnd>:

static int
addToStateListEnd(struct proc** sList, struct proc* p) {
80105fde:	55                   	push   %ebp
80105fdf:	89 e5                	mov    %esp,%ebp
80105fe1:	83 ec 18             	sub    $0x18,%esp
    if (!p) {
80105fe4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105fe8:	75 0d                	jne    80105ff7 <addToStateListEnd+0x19>
        panic("Invalid process.");
80105fea:	83 ec 0c             	sub    $0xc,%esp
80105fed:	68 ca a8 10 80       	push   $0x8010a8ca
80105ff2:	e8 6f a5 ff ff       	call   80100566 <panic>
    }
    // if list desn't exist yet, initialize
    if (!(*sList)) {
80105ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80105ffa:	8b 00                	mov    (%eax),%eax
80105ffc:	85 c0                	test   %eax,%eax
80105ffe:	75 1c                	jne    8010601c <addToStateListEnd+0x3e>
        (*sList) = p;
80106000:	8b 45 08             	mov    0x8(%ebp),%eax
80106003:	8b 55 0c             	mov    0xc(%ebp),%edx
80106006:	89 10                	mov    %edx,(%eax)
        p->next = 0;
80106008:	8b 45 0c             	mov    0xc(%ebp),%eax
8010600b:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106012:	00 00 00 
        return 0;
80106015:	b8 00 00 00 00       	mov    $0x0,%eax
8010601a:	eb 41                	jmp    8010605d <addToStateListEnd+0x7f>
    }
    // otherwise traverse and add at the end
    struct proc * current = (*sList);
8010601c:	8b 45 08             	mov    0x8(%ebp),%eax
8010601f:	8b 00                	mov    (%eax),%eax
80106021:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (current->next) {
80106024:	eb 0c                	jmp    80106032 <addToStateListEnd+0x54>
        current = current->next;
80106026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106029:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010602f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p->next = 0;
        return 0;
    }
    // otherwise traverse and add at the end
    struct proc * current = (*sList);
    while (current->next) {
80106032:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106035:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010603b:	85 c0                	test   %eax,%eax
8010603d:	75 e7                	jne    80106026 <addToStateListEnd+0x48>
        current = current->next;
    }
    current->next = p;
8010603f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106042:	8b 55 0c             	mov    0xc(%ebp),%edx
80106045:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    p->next = 0;
8010604b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010604e:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106055:	00 00 00 
    return 0;
80106058:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010605d:	c9                   	leave  
8010605e:	c3                   	ret    

8010605f <removeFromStateList>:

// search and remove process based on pointer address
static int
removeFromStateList(struct proc** sList, struct proc* p) {
8010605f:	55                   	push   %ebp
80106060:	89 e5                	mov    %esp,%ebp
80106062:	83 ec 18             	sub    $0x18,%esp
    if (!p) {
80106065:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106069:	75 0d                	jne    80106078 <removeFromStateList+0x19>
        panic("Invalid process structures.");
8010606b:	83 ec 0c             	sub    $0xc,%esp
8010606e:	68 db a8 10 80       	push   $0x8010a8db
80106073:	e8 ee a4 ff ff       	call   80100566 <panic>
    }
    if (!(*sList)) {
80106078:	8b 45 08             	mov    0x8(%ebp),%eax
8010607b:	8b 00                	mov    (%eax),%eax
8010607d:	85 c0                	test   %eax,%eax
8010607f:	75 0a                	jne    8010608b <removeFromStateList+0x2c>
        return -1;
80106081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106086:	e9 c6 00 00 00       	jmp    80106151 <removeFromStateList+0xf2>
    }
    // if p is the first element in list
    if (p == (*sList)) {
8010608b:	8b 45 08             	mov    0x8(%ebp),%eax
8010608e:	8b 00                	mov    (%eax),%eax
80106090:	3b 45 0c             	cmp    0xc(%ebp),%eax
80106093:	75 59                	jne    801060ee <removeFromStateList+0x8f>
        // if it is the only item in list
        if (!(*sList)->next) {
80106095:	8b 45 08             	mov    0x8(%ebp),%eax
80106098:	8b 00                	mov    (%eax),%eax
8010609a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060a0:	85 c0                	test   %eax,%eax
801060a2:	75 20                	jne    801060c4 <removeFromStateList+0x65>
            (*sList) = 0;
801060a4:	8b 45 08             	mov    0x8(%ebp),%eax
801060a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            p->next = 0;
801060ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801060b0:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801060b7:	00 00 00 
            return 0;
801060ba:	b8 00 00 00 00       	mov    $0x0,%eax
801060bf:	e9 8d 00 00 00       	jmp    80106151 <removeFromStateList+0xf2>
        }
        // if p is the first item in list
        else {
            struct proc * temp = (*sList)->next;
801060c4:	8b 45 08             	mov    0x8(%ebp),%eax
801060c7:	8b 00                	mov    (%eax),%eax
801060c9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
            p->next = 0;
801060d2:	8b 45 0c             	mov    0xc(%ebp),%eax
801060d5:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801060dc:	00 00 00 
            (*sList) = temp;
801060df:	8b 45 08             	mov    0x8(%ebp),%eax
801060e2:	8b 55 ec             	mov    -0x14(%ebp),%edx
801060e5:	89 10                	mov    %edx,(%eax)
            return 0;
801060e7:	b8 00 00 00 00       	mov    $0x0,%eax
801060ec:	eb 63                	jmp    80106151 <removeFromStateList+0xf2>
        }
    }
    // from middle or end of list
    else {
        struct proc * current = (*sList)->next;
801060ee:	8b 45 08             	mov    0x8(%ebp),%eax
801060f1:	8b 00                	mov    (%eax),%eax
801060f3:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        struct proc * prev = (*sList);
801060fc:	8b 45 08             	mov    0x8(%ebp),%eax
801060ff:	8b 00                	mov    (%eax),%eax
80106101:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while (current) {
80106104:	eb 40                	jmp    80106146 <removeFromStateList+0xe7>
            if (current == p) {
80106106:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106109:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010610c:	75 26                	jne    80106134 <removeFromStateList+0xd5>
                prev->next = current->next;
8010610e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106111:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80106117:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010611a:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
                p->next = 0;
80106120:	8b 45 0c             	mov    0xc(%ebp),%eax
80106123:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
8010612a:	00 00 00 
                return 0;
8010612d:	b8 00 00 00 00       	mov    $0x0,%eax
80106132:	eb 1d                	jmp    80106151 <removeFromStateList+0xf2>
            }
            prev = current;
80106134:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106137:	89 45 f0             	mov    %eax,-0x10(%ebp)
            current = current->next;
8010613a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010613d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106143:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    // from middle or end of list
    else {
        struct proc * current = (*sList)->next;
        struct proc * prev = (*sList);
        while (current) {
80106146:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010614a:	75 ba                	jne    80106106 <removeFromStateList+0xa7>
            }
            prev = current;
            current = current->next;
        }
    }
    return -1; // nothing found
8010614c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106151:	c9                   	leave  
80106152:	c3                   	ret    

80106153 <removeHead>:

// remove first element of list, return its pointer
static struct proc*
removeHead(struct proc** sList) {
80106153:	55                   	push   %ebp
80106154:	89 e5                	mov    %esp,%ebp
80106156:	83 ec 10             	sub    $0x10,%esp
    if (!(*sList)) {
80106159:	8b 45 08             	mov    0x8(%ebp),%eax
8010615c:	8b 00                	mov    (%eax),%eax
8010615e:	85 c0                	test   %eax,%eax
80106160:	75 07                	jne    80106169 <removeHead+0x16>
        return 0; // return null, check value in calling routine
80106162:	b8 00 00 00 00       	mov    $0x0,%eax
80106167:	eb 2e                	jmp    80106197 <removeHead+0x44>
    }
    struct proc* p = (*sList); // assign pointer to head of sList
80106169:	8b 45 08             	mov    0x8(%ebp),%eax
8010616c:	8b 00                	mov    (%eax),%eax
8010616e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    struct proc* temp = (*sList)->next; // hold onto next element in list
80106171:	8b 45 08             	mov    0x8(%ebp),%eax
80106174:	8b 00                	mov    (%eax),%eax
80106176:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010617c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    p->next = 0; // p is no longer head of sList
8010617f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106182:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106189:	00 00 00 
    (*sList) = temp; // sList now starts at  2nd element, or is NULL if one-item list
8010618c:	8b 45 08             	mov    0x8(%ebp),%eax
8010618f:	8b 55 f8             	mov    -0x8(%ebp),%edx
80106192:	89 10                	mov    %edx,(%eax)
    return p; // return 
80106194:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106197:	c9                   	leave  
80106198:	c3                   	ret    

80106199 <printReadyList>:

// print PIDs of all procs in Ready list
void
printReadyList(void) {
80106199:	55                   	push   %ebp
8010619a:	89 e5                	mov    %esp,%ebp
8010619c:	83 ec 18             	sub    $0x18,%esp
    //int i = 0;
    cprintf("\nReady List Processes:\n");
8010619f:	83 ec 0c             	sub    $0xc,%esp
801061a2:	68 f7 a8 10 80       	push   $0x8010a8f7
801061a7:	e8 1a a2 ff ff       	call   801003c6 <cprintf>
801061ac:	83 c4 10             	add    $0x10,%esp
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
801061af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801061b6:	e9 ca 00 00 00       	jmp    80106285 <printReadyList+0xec>
        if (ptable.pLists.ready[i]) {
801061bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061be:	05 cc 09 00 00       	add    $0x9cc,%eax
801061c3:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
801061ca:	85 c0                	test   %eax,%eax
801061cc:	0f 84 9c 00 00 00    	je     8010626e <printReadyList+0xd5>
            cprintf("\n%d: ", i);
801061d2:	83 ec 08             	sub    $0x8,%esp
801061d5:	ff 75 f4             	pushl  -0xc(%ebp)
801061d8:	68 0f a9 10 80       	push   $0x8010a90f
801061dd:	e8 e4 a1 ff ff       	call   801003c6 <cprintf>
801061e2:	83 c4 10             	add    $0x10,%esp
            struct proc* current = ptable.pLists.ready[i];
801061e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e8:	05 cc 09 00 00       	add    $0x9cc,%eax
801061ed:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
801061f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
            while (current) {
801061f7:	eb 5d                	jmp    80106256 <printReadyList+0xbd>
                if (current->next) {
801061f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061fc:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106202:	85 c0                	test   %eax,%eax
80106204:	74 23                	je     80106229 <printReadyList+0x90>
                    cprintf("(%d, %d)-> ", current->pid, current->budget);
80106206:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106209:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010620f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106212:	8b 40 10             	mov    0x10(%eax),%eax
80106215:	83 ec 04             	sub    $0x4,%esp
80106218:	52                   	push   %edx
80106219:	50                   	push   %eax
8010621a:	68 15 a9 10 80       	push   $0x8010a915
8010621f:	e8 a2 a1 ff ff       	call   801003c6 <cprintf>
80106224:	83 c4 10             	add    $0x10,%esp
80106227:	eb 21                	jmp    8010624a <printReadyList+0xb1>
                } else {
                    cprintf("(%d, %d)", current->pid, current->budget);
80106229:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010622c:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80106232:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106235:	8b 40 10             	mov    0x10(%eax),%eax
80106238:	83 ec 04             	sub    $0x4,%esp
8010623b:	52                   	push   %edx
8010623c:	50                   	push   %eax
8010623d:	68 21 a9 10 80       	push   $0x8010a921
80106242:	e8 7f a1 ff ff       	call   801003c6 <cprintf>
80106247:	83 c4 10             	add    $0x10,%esp
                }
                current = current->next;
8010624a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010624d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106253:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
        if (ptable.pLists.ready[i]) {
            cprintf("\n%d: ", i);
            struct proc* current = ptable.pLists.ready[i];
            while (current) {
80106256:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010625a:	75 9d                	jne    801061f9 <printReadyList+0x60>
                } else {
                    cprintf("(%d, %d)", current->pid, current->budget);
                }
                current = current->next;
            }
            cprintf("\n");
8010625c:	83 ec 0c             	sub    $0xc,%esp
8010625f:	68 79 a8 10 80       	push   $0x8010a879
80106264:	e8 5d a1 ff ff       	call   801003c6 <cprintf>
80106269:	83 c4 10             	add    $0x10,%esp
8010626c:	eb 13                	jmp    80106281 <printReadyList+0xe8>
        }
        else {
            cprintf("\n%d: Empty.\n", i);
8010626e:	83 ec 08             	sub    $0x8,%esp
80106271:	ff 75 f4             	pushl  -0xc(%ebp)
80106274:	68 2a a9 10 80       	push   $0x8010a92a
80106279:	e8 48 a1 ff ff       	call   801003c6 <cprintf>
8010627e:	83 c4 10             	add    $0x10,%esp
void
printReadyList(void) {
    //int i = 0;
    cprintf("\nReady List Processes:\n");
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
80106281:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106285:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
80106289:	0f 8e 2c ff ff ff    	jle    801061bb <printReadyList+0x22>
        else {
            cprintf("\n%d: Empty.\n", i);
        }
        //++i;
    }
}
8010628f:	90                   	nop
80106290:	c9                   	leave  
80106291:	c3                   	ret    

80106292 <printFreeList>:

// print number of procs in Free list
void
printFreeList(void) {
80106292:	55                   	push   %ebp
80106293:	89 e5                	mov    %esp,%ebp
80106295:	83 ec 18             	sub    $0x18,%esp
    if (ptable.pLists.free) {
80106298:	a1 c4 70 11 80       	mov    0x801170c4,%eax
8010629d:	85 c0                	test   %eax,%eax
8010629f:	74 3c                	je     801062dd <printFreeList+0x4b>
        int size = 0;
801062a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        struct proc * current = ptable.pLists.free;
801062a8:	a1 c4 70 11 80       	mov    0x801170c4,%eax
801062ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while (current) {
801062b0:	eb 10                	jmp    801062c2 <printFreeList+0x30>
            ++size; // cycle list and keep count
801062b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            current = current->next;
801062b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062b9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801062bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
void
printFreeList(void) {
    if (ptable.pLists.free) {
        int size = 0;
        struct proc * current = ptable.pLists.free;
        while (current) {
801062c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062c6:	75 ea                	jne    801062b2 <printFreeList+0x20>
        /*
        for (struct proc* current = ptable.pLists.free; current; current = current->next) {
            ++size;
        }
        */
        cprintf("\nFree List Size: %d processes\n", size);
801062c8:	83 ec 08             	sub    $0x8,%esp
801062cb:	ff 75 f4             	pushl  -0xc(%ebp)
801062ce:	68 38 a9 10 80       	push   $0x8010a938
801062d3:	e8 ee a0 ff ff       	call   801003c6 <cprintf>
801062d8:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Free List.\n");
    }
}
801062db:	eb 10                	jmp    801062ed <printFreeList+0x5b>
        }
        */
        cprintf("\nFree List Size: %d processes\n", size);
    }
    else {
        cprintf("\nNo processes on Free List.\n");
801062dd:	83 ec 0c             	sub    $0xc,%esp
801062e0:	68 57 a9 10 80       	push   $0x8010a957
801062e5:	e8 dc a0 ff ff       	call   801003c6 <cprintf>
801062ea:	83 c4 10             	add    $0x10,%esp
    }
}
801062ed:	90                   	nop
801062ee:	c9                   	leave  
801062ef:	c3                   	ret    

801062f0 <printSleepList>:

// print PIDs of all procs in Sleep list
void
printSleepList(void) {
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	83 ec 18             	sub    $0x18,%esp
    //acquire(&ptable.lock);
    if (ptable.pLists.sleep) {
801062f6:	a1 c8 70 11 80       	mov    0x801170c8,%eax
801062fb:	85 c0                	test   %eax,%eax
801062fd:	74 7b                	je     8010637a <printSleepList+0x8a>
        struct proc* current = ptable.pLists.sleep;
801062ff:	a1 c8 70 11 80       	mov    0x801170c8,%eax
80106304:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("\nSleep List Processes:\n");
80106307:	83 ec 0c             	sub    $0xc,%esp
8010630a:	68 74 a9 10 80       	push   $0x8010a974
8010630f:	e8 b2 a0 ff ff       	call   801003c6 <cprintf>
80106314:	83 c4 10             	add    $0x10,%esp
        while (current) {
80106317:	eb 49                	jmp    80106362 <printSleepList+0x72>
            if (current->next) {
80106319:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010631c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106322:	85 c0                	test   %eax,%eax
80106324:	74 19                	je     8010633f <printSleepList+0x4f>
                cprintf("%d -> ", current->pid);
80106326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106329:	8b 40 10             	mov    0x10(%eax),%eax
8010632c:	83 ec 08             	sub    $0x8,%esp
8010632f:	50                   	push   %eax
80106330:	68 8c a9 10 80       	push   $0x8010a98c
80106335:	e8 8c a0 ff ff       	call   801003c6 <cprintf>
8010633a:	83 c4 10             	add    $0x10,%esp
8010633d:	eb 17                	jmp    80106356 <printSleepList+0x66>
            } else {
                cprintf("%d", current->pid);
8010633f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106342:	8b 40 10             	mov    0x10(%eax),%eax
80106345:	83 ec 08             	sub    $0x8,%esp
80106348:	50                   	push   %eax
80106349:	68 93 a9 10 80       	push   $0x8010a993
8010634e:	e8 73 a0 ff ff       	call   801003c6 <cprintf>
80106353:	83 c4 10             	add    $0x10,%esp
            }
            current = current->next;
80106356:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106359:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010635f:	89 45 f4             	mov    %eax,-0xc(%ebp)
printSleepList(void) {
    //acquire(&ptable.lock);
    if (ptable.pLists.sleep) {
        struct proc* current = ptable.pLists.sleep;
        cprintf("\nSleep List Processes:\n");
        while (current) {
80106362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106366:	75 b1                	jne    80106319 <printSleepList+0x29>
            } else {
                cprintf("%d", current->pid);
            }
            current = current->next;
        }
        cprintf("\n");
80106368:	83 ec 0c             	sub    $0xc,%esp
8010636b:	68 79 a8 10 80       	push   $0x8010a879
80106370:	e8 51 a0 ff ff       	call   801003c6 <cprintf>
80106375:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Sleep List.\n");
    }
    //release(&ptable.lock);
}
80106378:	eb 10                	jmp    8010638a <printSleepList+0x9a>
            current = current->next;
        }
        cprintf("\n");
    }
    else {
        cprintf("\nNo processes on Sleep List.\n");
8010637a:	83 ec 0c             	sub    $0xc,%esp
8010637d:	68 96 a9 10 80       	push   $0x8010a996
80106382:	e8 3f a0 ff ff       	call   801003c6 <cprintf>
80106387:	83 c4 10             	add    $0x10,%esp
    }
    //release(&ptable.lock);
}
8010638a:	90                   	nop
8010638b:	c9                   	leave  
8010638c:	c3                   	ret    

8010638d <printZombieList>:

// print PIDs & PPIDs of all procs in Zombie list
void
printZombieList(void) {
8010638d:	55                   	push   %ebp
8010638e:	89 e5                	mov    %esp,%ebp
80106390:	83 ec 18             	sub    $0x18,%esp
    if (ptable.pLists.zombie) {
80106393:	a1 cc 70 11 80       	mov    0x801170cc,%eax
80106398:	85 c0                	test   %eax,%eax
8010639a:	0f 84 8f 00 00 00    	je     8010642f <printZombieList+0xa2>
        struct proc* current = ptable.pLists.zombie;
801063a0:	a1 cc 70 11 80       	mov    0x801170cc,%eax
801063a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("\nZombie List Processes:\n");
801063a8:	83 ec 0c             	sub    $0xc,%esp
801063ab:	68 b4 a9 10 80       	push   $0x8010a9b4
801063b0:	e8 11 a0 ff ff       	call   801003c6 <cprintf>
801063b5:	83 c4 10             	add    $0x10,%esp
        while (current) {
801063b8:	eb 5d                	jmp    80106417 <printZombieList+0x8a>
            if (current->next) {
801063ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063bd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801063c3:	85 c0                	test   %eax,%eax
801063c5:	74 23                	je     801063ea <printZombieList+0x5d>
                cprintf("(%d, %d) -> ", current->pid, current->parent->pid);
801063c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ca:	8b 40 14             	mov    0x14(%eax),%eax
801063cd:	8b 50 10             	mov    0x10(%eax),%edx
801063d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d3:	8b 40 10             	mov    0x10(%eax),%eax
801063d6:	83 ec 04             	sub    $0x4,%esp
801063d9:	52                   	push   %edx
801063da:	50                   	push   %eax
801063db:	68 cd a9 10 80       	push   $0x8010a9cd
801063e0:	e8 e1 9f ff ff       	call   801003c6 <cprintf>
801063e5:	83 c4 10             	add    $0x10,%esp
801063e8:	eb 21                	jmp    8010640b <printZombieList+0x7e>
            } else {
                cprintf("(%d, %d)", current->pid, current->parent->pid);
801063ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ed:	8b 40 14             	mov    0x14(%eax),%eax
801063f0:	8b 50 10             	mov    0x10(%eax),%edx
801063f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f6:	8b 40 10             	mov    0x10(%eax),%eax
801063f9:	83 ec 04             	sub    $0x4,%esp
801063fc:	52                   	push   %edx
801063fd:	50                   	push   %eax
801063fe:	68 21 a9 10 80       	push   $0x8010a921
80106403:	e8 be 9f ff ff       	call   801003c6 <cprintf>
80106408:	83 c4 10             	add    $0x10,%esp
            }
            current = current->next;
8010640b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010640e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106414:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
printZombieList(void) {
    if (ptable.pLists.zombie) {
        struct proc* current = ptable.pLists.zombie;
        cprintf("\nZombie List Processes:\n");
        while (current) {
80106417:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010641b:	75 9d                	jne    801063ba <printZombieList+0x2d>
            } else {
                cprintf("(%d, %d)", current->pid, current->parent->pid);
            }
            current = current->next;
        }
        cprintf("\n");
8010641d:	83 ec 0c             	sub    $0xc,%esp
80106420:	68 79 a8 10 80       	push   $0x8010a879
80106425:	e8 9c 9f ff ff       	call   801003c6 <cprintf>
8010642a:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Zombie List.\n");
    }
}
8010642d:	eb 10                	jmp    8010643f <printZombieList+0xb2>
            current = current->next;
        }
        cprintf("\n");
    }
    else {
        cprintf("\nNo processes on Zombie List.\n");
8010642f:	83 ec 0c             	sub    $0xc,%esp
80106432:	68 dc a9 10 80       	push   $0x8010a9dc
80106437:	e8 8a 9f ff ff       	call   801003c6 <cprintf>
8010643c:	83 c4 10             	add    $0x10,%esp
    }
}
8010643f:	90                   	nop
80106440:	c9                   	leave  
80106441:	c3                   	ret    

80106442 <promoteAll>:
// upwards to lowest priority queue

// Promote all ACTIVE(RUNNING, RUNNABLE, SLEEPING) processes one priority level
// this is only called in scheduler(), which holds &ptable.lock
static void
promoteAll(void) {
80106442:	55                   	push   %ebp
80106443:	89 e5                	mov    %esp,%ebp
80106445:	83 ec 18             	sub    $0x18,%esp
    struct proc* p; // main ptr
    struct proc* current; // 2nd ptr needed for traversal + list management
    for (int i = 1; i <= MAX; ++i) {
80106448:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
8010644f:	e9 ff 00 00 00       	jmp    80106553 <promoteAll+0x111>
        // traverse ready list array
        if (ptable.pLists.ready[i]) {
80106454:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106457:	05 cc 09 00 00       	add    $0x9cc,%eax
8010645c:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80106463:	85 c0                	test   %eax,%eax
80106465:	0f 84 e4 00 00 00    	je     8010654f <promoteAll+0x10d>
            current = ptable.pLists.ready[i]; // initialize
8010646b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010646e:	05 cc 09 00 00       	add    $0x9cc,%eax
80106473:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
8010647a:	89 45 f0             	mov    %eax,-0x10(%ebp)
            p = 0;
8010647d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            while (current) {
80106484:	e9 bc 00 00 00       	jmp    80106545 <promoteAll+0x103>
                p = current; // p is the current process to adjust
80106489:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010648c:	89 45 f4             	mov    %eax,-0xc(%ebp)
                current = current->next; // current traverses one ahead
8010648f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106492:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106498:	89 45 f0             	mov    %eax,-0x10(%ebp)
                assertState(p, RUNNABLE); // assert state, we need to swap ready lists
8010649b:	83 ec 08             	sub    $0x8,%esp
8010649e:	6a 03                	push   $0x3
801064a0:	ff 75 f4             	pushl  -0xc(%ebp)
801064a3:	e8 96 fa ff ff       	call   80105f3e <assertState>
801064a8:	83 c4 10             	add    $0x10,%esp
                if (removeFromStateList(&ptable.pLists.ready[p->priority], p) < 0) {
801064ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ae:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801064b4:	05 cc 09 00 00       	add    $0x9cc,%eax
801064b9:	c1 e0 02             	shl    $0x2,%eax
801064bc:	05 80 49 11 80       	add    $0x80114980,%eax
801064c1:	83 c0 04             	add    $0x4,%eax
801064c4:	83 ec 08             	sub    $0x8,%esp
801064c7:	ff 75 f4             	pushl  -0xc(%ebp)
801064ca:	50                   	push   %eax
801064cb:	e8 8f fb ff ff       	call   8010605f <removeFromStateList>
801064d0:	83 c4 10             	add    $0x10,%esp
801064d3:	85 c0                	test   %eax,%eax
801064d5:	79 10                	jns    801064e7 <promoteAll+0xa5>
                    cprintf("promoteAll: Could not remove from ready list.\n");
801064d7:	83 ec 0c             	sub    $0xc,%esp
801064da:	68 fc a9 10 80       	push   $0x8010a9fc
801064df:	e8 e2 9e ff ff       	call   801003c6 <cprintf>
801064e4:	83 c4 10             	add    $0x10,%esp
                } // take off lower priority (whatever one it is)
                if (p->priority > 0) {
801064e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ea:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801064f0:	85 c0                	test   %eax,%eax
801064f2:	74 15                	je     80106509 <promoteAll+0xc7>
                    --(p->priority); // adjust upward (toward zero)
801064f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064f7:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801064fd:	8d 50 ff             	lea    -0x1(%eax),%edx
80106500:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106503:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
                } // add to higher priority list
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
80106509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010650c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106512:	05 cc 09 00 00       	add    $0x9cc,%eax
80106517:	c1 e0 02             	shl    $0x2,%eax
8010651a:	05 80 49 11 80       	add    $0x80114980,%eax
8010651f:	83 c0 04             	add    $0x4,%eax
80106522:	83 ec 08             	sub    $0x8,%esp
80106525:	ff 75 f4             	pushl  -0xc(%ebp)
80106528:	50                   	push   %eax
80106529:	e8 b0 fa ff ff       	call   80105fde <addToStateListEnd>
8010652e:	83 c4 10             	add    $0x10,%esp
80106531:	85 c0                	test   %eax,%eax
80106533:	79 10                	jns    80106545 <promoteAll+0x103>
                    cprintf("promoteAll: Could not add to ready list.\n");
80106535:	83 ec 0c             	sub    $0xc,%esp
80106538:	68 2c aa 10 80       	push   $0x8010aa2c
8010653d:	e8 84 9e ff ff       	call   801003c6 <cprintf>
80106542:	83 c4 10             	add    $0x10,%esp
    for (int i = 1; i <= MAX; ++i) {
        // traverse ready list array
        if (ptable.pLists.ready[i]) {
            current = ptable.pLists.ready[i]; // initialize
            p = 0;
            while (current) {
80106545:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106549:	0f 85 3a ff ff ff    	jne    80106489 <promoteAll+0x47>
// this is only called in scheduler(), which holds &ptable.lock
static void
promoteAll(void) {
    struct proc* p; // main ptr
    struct proc* current; // 2nd ptr needed for traversal + list management
    for (int i = 1; i <= MAX; ++i) {
8010654f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80106553:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
80106557:	0f 8e f7 fe ff ff    	jle    80106454 <promoteAll+0x12>
                }
            }
        }
    }
    // promote all SLEEPING processes
    if (ptable.pLists.sleep) {
8010655d:	a1 c8 70 11 80       	mov    0x801170c8,%eax
80106562:	85 c0                	test   %eax,%eax
80106564:	74 3e                	je     801065a4 <promoteAll+0x162>
        p = ptable.pLists.sleep;
80106566:	a1 c8 70 11 80       	mov    0x801170c8,%eax
8010656b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
8010656e:	eb 2e                	jmp    8010659e <promoteAll+0x15c>
            if (p->priority > 0) {
80106570:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106573:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106579:	85 c0                	test   %eax,%eax
8010657b:	74 15                	je     80106592 <promoteAll+0x150>
                --(p->priority); // promote process
8010657d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106580:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106586:	8d 50 ff             	lea    -0x1(%eax),%edx
80106589:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010658c:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            }
            p = p->next;
80106592:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106595:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010659b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
    }
    // promote all SLEEPING processes
    if (ptable.pLists.sleep) {
        p = ptable.pLists.sleep;
        while (p) {
8010659e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065a2:	75 cc                	jne    80106570 <promoteAll+0x12e>
            }
            p = p->next;
        }
    }
    // promote all RUNNING processes
    if (ptable.pLists.running) {
801065a4:	a1 d0 70 11 80       	mov    0x801170d0,%eax
801065a9:	85 c0                	test   %eax,%eax
801065ab:	74 3e                	je     801065eb <promoteAll+0x1a9>
        p = ptable.pLists.running;
801065ad:	a1 d0 70 11 80       	mov    0x801170d0,%eax
801065b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
801065b5:	eb 2e                	jmp    801065e5 <promoteAll+0x1a3>
            if (p->priority > 0) {
801065b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ba:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801065c0:	85 c0                	test   %eax,%eax
801065c2:	74 15                	je     801065d9 <promoteAll+0x197>
                --(p->priority); // promote process
801065c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c7:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801065cd:	8d 50 ff             	lea    -0x1(%eax),%edx
801065d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d3:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            }
            p = p->next;
801065d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065dc:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801065e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
    }
    // promote all RUNNING processes
    if (ptable.pLists.running) {
        p = ptable.pLists.running;
        while (p) {
801065e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065e9:	75 cc                	jne    801065b7 <promoteAll+0x175>
            }
            p = p->next;
        }
    }
    // nothing to return, just promote anything if they are there
}
801065eb:	90                   	nop
801065ec:	c9                   	leave  
801065ed:	c3                   	ret    

801065ee <setpriority>:
// set priority system call
// bounds enforced in sysproc.c (kernel-side)
// active processes: RUNNABLE, RUNNING, SLEEPING
int
setpriority(int pid, int priority) {
801065ee:	55                   	push   %ebp
801065ef:	89 e5                	mov    %esp,%ebp
801065f1:	83 ec 18             	sub    $0x18,%esp
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
801065f4:	83 ec 0c             	sub    $0xc,%esp
801065f7:	68 80 49 11 80       	push   $0x80114980
801065fc:	e8 74 02 00 00       	call   80106875 <acquire>
80106601:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i <= MAX; ++i) {
80106604:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010660b:	e9 15 01 00 00       	jmp    80106725 <setpriority+0x137>
        p = ptable.pLists.ready[i]; // traverse ready list array
80106610:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106613:	05 cc 09 00 00       	add    $0x9cc,%eax
80106618:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
8010661f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
80106622:	e9 f0 00 00 00       	jmp    80106717 <setpriority+0x129>
            // match PIDs and only if the new priority value changes anything
            if (((p->pid) == pid) && ((p->priority) != priority)) {
80106627:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010662a:	8b 50 10             	mov    0x10(%eax),%edx
8010662d:	8b 45 08             	mov    0x8(%ebp),%eax
80106630:	39 c2                	cmp    %eax,%edx
80106632:	0f 85 d3 00 00 00    	jne    8010670b <setpriority+0x11d>
80106638:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010663b:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80106641:	8b 45 0c             	mov    0xc(%ebp),%eax
80106644:	39 c2                	cmp    %eax,%edx
80106646:	0f 84 bf 00 00 00    	je     8010670b <setpriority+0x11d>
                if (removeFromStateList(&ptable.pLists.ready[p->priority], p) < 0) {
8010664c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010664f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106655:	05 cc 09 00 00       	add    $0x9cc,%eax
8010665a:	c1 e0 02             	shl    $0x2,%eax
8010665d:	05 80 49 11 80       	add    $0x80114980,%eax
80106662:	83 c0 04             	add    $0x4,%eax
80106665:	83 ec 08             	sub    $0x8,%esp
80106668:	ff 75 f4             	pushl  -0xc(%ebp)
8010666b:	50                   	push   %eax
8010666c:	e8 ee f9 ff ff       	call   8010605f <removeFromStateList>
80106671:	83 c4 10             	add    $0x10,%esp
80106674:	85 c0                	test   %eax,%eax
80106676:	79 1a                	jns    80106692 <setpriority+0xa4>
                    cprintf("setpriority: remove from ready list[%d] failed.\n", p->priority);
80106678:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010667b:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106681:	83 ec 08             	sub    $0x8,%esp
80106684:	50                   	push   %eax
80106685:	68 58 aa 10 80       	push   $0x8010aa58
8010668a:	e8 37 9d ff ff       	call   801003c6 <cprintf>
8010668f:	83 c4 10             	add    $0x10,%esp
                }// remove from old ready list
                p->priority = priority; // set priority
80106692:	8b 55 0c             	mov    0xc(%ebp),%edx
80106695:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106698:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
8010669e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066a1:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801066a7:	05 cc 09 00 00       	add    $0x9cc,%eax
801066ac:	c1 e0 02             	shl    $0x2,%eax
801066af:	05 80 49 11 80       	add    $0x80114980,%eax
801066b4:	83 c0 04             	add    $0x4,%eax
801066b7:	83 ec 08             	sub    $0x8,%esp
801066ba:	ff 75 f4             	pushl  -0xc(%ebp)
801066bd:	50                   	push   %eax
801066be:	e8 1b f9 ff ff       	call   80105fde <addToStateListEnd>
801066c3:	83 c4 10             	add    $0x10,%esp
801066c6:	85 c0                	test   %eax,%eax
801066c8:	79 1a                	jns    801066e4 <setpriority+0xf6>
                    cprintf("setpriority: add to ready list[%d] failed.\n", p->priority);
801066ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066cd:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801066d3:	83 ec 08             	sub    $0x8,%esp
801066d6:	50                   	push   %eax
801066d7:	68 8c aa 10 80       	push   $0x8010aa8c
801066dc:	e8 e5 9c ff ff       	call   801003c6 <cprintf>
801066e1:	83 c4 10             	add    $0x10,%esp
                } //  add to new ready list
                p->budget = BUDGET; // reset budget
801066e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066e7:	c7 80 98 00 00 00 fa 	movl   $0xfa,0x98(%eax)
801066ee:	00 00 00 
                release(&ptable.lock); // release lock
801066f1:	83 ec 0c             	sub    $0xc,%esp
801066f4:	68 80 49 11 80       	push   $0x80114980
801066f9:	e8 de 01 00 00       	call   801068dc <release>
801066fe:	83 c4 10             	add    $0x10,%esp
                return 0; // return success
80106701:	b8 00 00 00 00       	mov    $0x0,%eax
80106706:	e9 0e 01 00 00       	jmp    80106819 <setpriority+0x22b>
            }
            p = p->next;
8010670b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010670e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106714:	89 45 f4             	mov    %eax,-0xc(%ebp)
setpriority(int pid, int priority) {
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i]; // traverse ready list array
        while (p) {
80106717:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010671b:	0f 85 06 ff ff ff    	jne    80106627 <setpriority+0x39>
// active processes: RUNNABLE, RUNNING, SLEEPING
int
setpriority(int pid, int priority) {
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
    for (int i = 0; i <= MAX; ++i) {
80106721:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80106725:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
80106729:	0f 8e e1 fe ff ff    	jle    80106610 <setpriority+0x22>
                return 0; // return success
            }
            p = p->next;
        }
    }
    p = ptable.pLists.running; // repeat process if PID not found in ready lists
8010672f:	a1 d0 70 11 80       	mov    0x801170d0,%eax
80106734:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80106737:	eb 5c                	jmp    80106795 <setpriority+0x1a7>
        if (((p->pid) == pid) && ((p->priority) != priority)) {
80106739:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010673c:	8b 50 10             	mov    0x10(%eax),%edx
8010673f:	8b 45 08             	mov    0x8(%ebp),%eax
80106742:	39 c2                	cmp    %eax,%edx
80106744:	75 43                	jne    80106789 <setpriority+0x19b>
80106746:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106749:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
8010674f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106752:	39 c2                	cmp    %eax,%edx
80106754:	74 33                	je     80106789 <setpriority+0x19b>
            p->priority = priority;
80106756:	8b 55 0c             	mov    0xc(%ebp),%edx
80106759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010675c:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            p->budget = BUDGET;
80106762:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106765:	c7 80 98 00 00 00 fa 	movl   $0xfa,0x98(%eax)
8010676c:	00 00 00 
            release(&ptable.lock);
8010676f:	83 ec 0c             	sub    $0xc,%esp
80106772:	68 80 49 11 80       	push   $0x80114980
80106777:	e8 60 01 00 00       	call   801068dc <release>
8010677c:	83 c4 10             	add    $0x10,%esp
            return 0; // return success
8010677f:	b8 00 00 00 00       	mov    $0x0,%eax
80106784:	e9 90 00 00 00       	jmp    80106819 <setpriority+0x22b>
        }
        p = p->next;
80106789:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010678c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106792:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
    }
    p = ptable.pLists.running; // repeat process if PID not found in ready lists
    while (p) {
80106795:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106799:	75 9e                	jne    80106739 <setpriority+0x14b>
            release(&ptable.lock);
            return 0; // return success
        }
        p = p->next;
    }
    p = ptable.pLists.sleep; // continue search in sleep list
8010679b:	a1 c8 70 11 80       	mov    0x801170c8,%eax
801067a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801067a3:	eb 59                	jmp    801067fe <setpriority+0x210>
        if (((p->pid) == pid) && ((p->priority) != priority)) {
801067a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a8:	8b 50 10             	mov    0x10(%eax),%edx
801067ab:	8b 45 08             	mov    0x8(%ebp),%eax
801067ae:	39 c2                	cmp    %eax,%edx
801067b0:	75 40                	jne    801067f2 <setpriority+0x204>
801067b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067b5:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
801067bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801067be:	39 c2                	cmp    %eax,%edx
801067c0:	74 30                	je     801067f2 <setpriority+0x204>
            p->priority = priority;
801067c2:	8b 55 0c             	mov    0xc(%ebp),%edx
801067c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067c8:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            p->budget = BUDGET;
801067ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067d1:	c7 80 98 00 00 00 fa 	movl   $0xfa,0x98(%eax)
801067d8:	00 00 00 
            release(&ptable.lock);
801067db:	83 ec 0c             	sub    $0xc,%esp
801067de:	68 80 49 11 80       	push   $0x80114980
801067e3:	e8 f4 00 00 00       	call   801068dc <release>
801067e8:	83 c4 10             	add    $0x10,%esp
            return 0; //  return success
801067eb:	b8 00 00 00 00       	mov    $0x0,%eax
801067f0:	eb 27                	jmp    80106819 <setpriority+0x22b>
        }
        p = p->next;
801067f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067f5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801067fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
            return 0; // return success
        }
        p = p->next;
    }
    p = ptable.pLists.sleep; // continue search in sleep list
    while (p) {
801067fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106802:	75 a1                	jne    801067a5 <setpriority+0x1b7>
            release(&ptable.lock);
            return 0; //  return success
        }
        p = p->next;
    }
    release(&ptable.lock);
80106804:	83 ec 0c             	sub    $0xc,%esp
80106807:	68 80 49 11 80       	push   $0x80114980
8010680c:	e8 cb 00 00 00       	call   801068dc <release>
80106811:	83 c4 10             	add    $0x10,%esp
    return -1; // return error if no PID match is found
80106814:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106819:	c9                   	leave  
8010681a:	c3                   	ret    

8010681b <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010681b:	55                   	push   %ebp
8010681c:	89 e5                	mov    %esp,%ebp
8010681e:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106821:	9c                   	pushf  
80106822:	58                   	pop    %eax
80106823:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80106826:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106829:	c9                   	leave  
8010682a:	c3                   	ret    

8010682b <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010682b:	55                   	push   %ebp
8010682c:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010682e:	fa                   	cli    
}
8010682f:	90                   	nop
80106830:	5d                   	pop    %ebp
80106831:	c3                   	ret    

80106832 <sti>:

static inline void
sti(void)
{
80106832:	55                   	push   %ebp
80106833:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80106835:	fb                   	sti    
}
80106836:	90                   	nop
80106837:	5d                   	pop    %ebp
80106838:	c3                   	ret    

80106839 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80106839:	55                   	push   %ebp
8010683a:	89 e5                	mov    %esp,%ebp
8010683c:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010683f:	8b 55 08             	mov    0x8(%ebp),%edx
80106842:	8b 45 0c             	mov    0xc(%ebp),%eax
80106845:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106848:	f0 87 02             	lock xchg %eax,(%edx)
8010684b:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010684e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106851:	c9                   	leave  
80106852:	c3                   	ret    

80106853 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106853:	55                   	push   %ebp
80106854:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80106856:	8b 45 08             	mov    0x8(%ebp),%eax
80106859:	8b 55 0c             	mov    0xc(%ebp),%edx
8010685c:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010685f:	8b 45 08             	mov    0x8(%ebp),%eax
80106862:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80106868:	8b 45 08             	mov    0x8(%ebp),%eax
8010686b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106872:	90                   	nop
80106873:	5d                   	pop    %ebp
80106874:	c3                   	ret    

80106875 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80106875:	55                   	push   %ebp
80106876:	89 e5                	mov    %esp,%ebp
80106878:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010687b:	e8 52 01 00 00       	call   801069d2 <pushcli>
  if(holding(lk))
80106880:	8b 45 08             	mov    0x8(%ebp),%eax
80106883:	83 ec 0c             	sub    $0xc,%esp
80106886:	50                   	push   %eax
80106887:	e8 1c 01 00 00       	call   801069a8 <holding>
8010688c:	83 c4 10             	add    $0x10,%esp
8010688f:	85 c0                	test   %eax,%eax
80106891:	74 0d                	je     801068a0 <acquire+0x2b>
    panic("acquire");
80106893:	83 ec 0c             	sub    $0xc,%esp
80106896:	68 b8 aa 10 80       	push   $0x8010aab8
8010689b:	e8 c6 9c ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801068a0:	90                   	nop
801068a1:	8b 45 08             	mov    0x8(%ebp),%eax
801068a4:	83 ec 08             	sub    $0x8,%esp
801068a7:	6a 01                	push   $0x1
801068a9:	50                   	push   %eax
801068aa:	e8 8a ff ff ff       	call   80106839 <xchg>
801068af:	83 c4 10             	add    $0x10,%esp
801068b2:	85 c0                	test   %eax,%eax
801068b4:	75 eb                	jne    801068a1 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801068b6:	8b 45 08             	mov    0x8(%ebp),%eax
801068b9:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801068c0:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801068c3:	8b 45 08             	mov    0x8(%ebp),%eax
801068c6:	83 c0 0c             	add    $0xc,%eax
801068c9:	83 ec 08             	sub    $0x8,%esp
801068cc:	50                   	push   %eax
801068cd:	8d 45 08             	lea    0x8(%ebp),%eax
801068d0:	50                   	push   %eax
801068d1:	e8 58 00 00 00       	call   8010692e <getcallerpcs>
801068d6:	83 c4 10             	add    $0x10,%esp
}
801068d9:	90                   	nop
801068da:	c9                   	leave  
801068db:	c3                   	ret    

801068dc <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801068dc:	55                   	push   %ebp
801068dd:	89 e5                	mov    %esp,%ebp
801068df:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801068e2:	83 ec 0c             	sub    $0xc,%esp
801068e5:	ff 75 08             	pushl  0x8(%ebp)
801068e8:	e8 bb 00 00 00       	call   801069a8 <holding>
801068ed:	83 c4 10             	add    $0x10,%esp
801068f0:	85 c0                	test   %eax,%eax
801068f2:	75 0d                	jne    80106901 <release+0x25>
    panic("release");
801068f4:	83 ec 0c             	sub    $0xc,%esp
801068f7:	68 c0 aa 10 80       	push   $0x8010aac0
801068fc:	e8 65 9c ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80106901:	8b 45 08             	mov    0x8(%ebp),%eax
80106904:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010690b:	8b 45 08             	mov    0x8(%ebp),%eax
8010690e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80106915:	8b 45 08             	mov    0x8(%ebp),%eax
80106918:	83 ec 08             	sub    $0x8,%esp
8010691b:	6a 00                	push   $0x0
8010691d:	50                   	push   %eax
8010691e:	e8 16 ff ff ff       	call   80106839 <xchg>
80106923:	83 c4 10             	add    $0x10,%esp

  popcli();
80106926:	e8 ec 00 00 00       	call   80106a17 <popcli>
}
8010692b:	90                   	nop
8010692c:	c9                   	leave  
8010692d:	c3                   	ret    

8010692e <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010692e:	55                   	push   %ebp
8010692f:	89 e5                	mov    %esp,%ebp
80106931:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80106934:	8b 45 08             	mov    0x8(%ebp),%eax
80106937:	83 e8 08             	sub    $0x8,%eax
8010693a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010693d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80106944:	eb 38                	jmp    8010697e <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106946:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010694a:	74 53                	je     8010699f <getcallerpcs+0x71>
8010694c:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80106953:	76 4a                	jbe    8010699f <getcallerpcs+0x71>
80106955:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80106959:	74 44                	je     8010699f <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010695b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010695e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106965:	8b 45 0c             	mov    0xc(%ebp),%eax
80106968:	01 c2                	add    %eax,%edx
8010696a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010696d:	8b 40 04             	mov    0x4(%eax),%eax
80106970:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80106972:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106975:	8b 00                	mov    (%eax),%eax
80106977:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010697a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010697e:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106982:	7e c2                	jle    80106946 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106984:	eb 19                	jmp    8010699f <getcallerpcs+0x71>
    pcs[i] = 0;
80106986:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106989:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106990:	8b 45 0c             	mov    0xc(%ebp),%eax
80106993:	01 d0                	add    %edx,%eax
80106995:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010699b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010699f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801069a3:	7e e1                	jle    80106986 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801069a5:	90                   	nop
801069a6:	c9                   	leave  
801069a7:	c3                   	ret    

801069a8 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801069a8:	55                   	push   %ebp
801069a9:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801069ab:	8b 45 08             	mov    0x8(%ebp),%eax
801069ae:	8b 00                	mov    (%eax),%eax
801069b0:	85 c0                	test   %eax,%eax
801069b2:	74 17                	je     801069cb <holding+0x23>
801069b4:	8b 45 08             	mov    0x8(%ebp),%eax
801069b7:	8b 50 08             	mov    0x8(%eax),%edx
801069ba:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069c0:	39 c2                	cmp    %eax,%edx
801069c2:	75 07                	jne    801069cb <holding+0x23>
801069c4:	b8 01 00 00 00       	mov    $0x1,%eax
801069c9:	eb 05                	jmp    801069d0 <holding+0x28>
801069cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069d0:	5d                   	pop    %ebp
801069d1:	c3                   	ret    

801069d2 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801069d2:	55                   	push   %ebp
801069d3:	89 e5                	mov    %esp,%ebp
801069d5:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801069d8:	e8 3e fe ff ff       	call   8010681b <readeflags>
801069dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801069e0:	e8 46 fe ff ff       	call   8010682b <cli>
  if(cpu->ncli++ == 0)
801069e5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801069ec:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801069f2:	8d 48 01             	lea    0x1(%eax),%ecx
801069f5:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801069fb:	85 c0                	test   %eax,%eax
801069fd:	75 15                	jne    80106a14 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801069ff:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a05:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a08:	81 e2 00 02 00 00    	and    $0x200,%edx
80106a0e:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80106a14:	90                   	nop
80106a15:	c9                   	leave  
80106a16:	c3                   	ret    

80106a17 <popcli>:

void
popcli(void)
{
80106a17:	55                   	push   %ebp
80106a18:	89 e5                	mov    %esp,%ebp
80106a1a:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80106a1d:	e8 f9 fd ff ff       	call   8010681b <readeflags>
80106a22:	25 00 02 00 00       	and    $0x200,%eax
80106a27:	85 c0                	test   %eax,%eax
80106a29:	74 0d                	je     80106a38 <popcli+0x21>
    panic("popcli - interruptible");
80106a2b:	83 ec 0c             	sub    $0xc,%esp
80106a2e:	68 c8 aa 10 80       	push   $0x8010aac8
80106a33:	e8 2e 9b ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106a38:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a3e:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106a44:	83 ea 01             	sub    $0x1,%edx
80106a47:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106a4d:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106a53:	85 c0                	test   %eax,%eax
80106a55:	79 0d                	jns    80106a64 <popcli+0x4d>
    panic("popcli");
80106a57:	83 ec 0c             	sub    $0xc,%esp
80106a5a:	68 df aa 10 80       	push   $0x8010aadf
80106a5f:	e8 02 9b ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106a64:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a6a:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106a70:	85 c0                	test   %eax,%eax
80106a72:	75 15                	jne    80106a89 <popcli+0x72>
80106a74:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a7a:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106a80:	85 c0                	test   %eax,%eax
80106a82:	74 05                	je     80106a89 <popcli+0x72>
    sti();
80106a84:	e8 a9 fd ff ff       	call   80106832 <sti>
}
80106a89:	90                   	nop
80106a8a:	c9                   	leave  
80106a8b:	c3                   	ret    

80106a8c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106a8c:	55                   	push   %ebp
80106a8d:	89 e5                	mov    %esp,%ebp
80106a8f:	57                   	push   %edi
80106a90:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106a91:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106a94:	8b 55 10             	mov    0x10(%ebp),%edx
80106a97:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a9a:	89 cb                	mov    %ecx,%ebx
80106a9c:	89 df                	mov    %ebx,%edi
80106a9e:	89 d1                	mov    %edx,%ecx
80106aa0:	fc                   	cld    
80106aa1:	f3 aa                	rep stos %al,%es:(%edi)
80106aa3:	89 ca                	mov    %ecx,%edx
80106aa5:	89 fb                	mov    %edi,%ebx
80106aa7:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106aaa:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106aad:	90                   	nop
80106aae:	5b                   	pop    %ebx
80106aaf:	5f                   	pop    %edi
80106ab0:	5d                   	pop    %ebp
80106ab1:	c3                   	ret    

80106ab2 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106ab2:	55                   	push   %ebp
80106ab3:	89 e5                	mov    %esp,%ebp
80106ab5:	57                   	push   %edi
80106ab6:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106ab7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106aba:	8b 55 10             	mov    0x10(%ebp),%edx
80106abd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ac0:	89 cb                	mov    %ecx,%ebx
80106ac2:	89 df                	mov    %ebx,%edi
80106ac4:	89 d1                	mov    %edx,%ecx
80106ac6:	fc                   	cld    
80106ac7:	f3 ab                	rep stos %eax,%es:(%edi)
80106ac9:	89 ca                	mov    %ecx,%edx
80106acb:	89 fb                	mov    %edi,%ebx
80106acd:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106ad0:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106ad3:	90                   	nop
80106ad4:	5b                   	pop    %ebx
80106ad5:	5f                   	pop    %edi
80106ad6:	5d                   	pop    %ebp
80106ad7:	c3                   	ret    

80106ad8 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106ad8:	55                   	push   %ebp
80106ad9:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106adb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ade:	83 e0 03             	and    $0x3,%eax
80106ae1:	85 c0                	test   %eax,%eax
80106ae3:	75 43                	jne    80106b28 <memset+0x50>
80106ae5:	8b 45 10             	mov    0x10(%ebp),%eax
80106ae8:	83 e0 03             	and    $0x3,%eax
80106aeb:	85 c0                	test   %eax,%eax
80106aed:	75 39                	jne    80106b28 <memset+0x50>
    c &= 0xFF;
80106aef:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106af6:	8b 45 10             	mov    0x10(%ebp),%eax
80106af9:	c1 e8 02             	shr    $0x2,%eax
80106afc:	89 c1                	mov    %eax,%ecx
80106afe:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b01:	c1 e0 18             	shl    $0x18,%eax
80106b04:	89 c2                	mov    %eax,%edx
80106b06:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b09:	c1 e0 10             	shl    $0x10,%eax
80106b0c:	09 c2                	or     %eax,%edx
80106b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b11:	c1 e0 08             	shl    $0x8,%eax
80106b14:	09 d0                	or     %edx,%eax
80106b16:	0b 45 0c             	or     0xc(%ebp),%eax
80106b19:	51                   	push   %ecx
80106b1a:	50                   	push   %eax
80106b1b:	ff 75 08             	pushl  0x8(%ebp)
80106b1e:	e8 8f ff ff ff       	call   80106ab2 <stosl>
80106b23:	83 c4 0c             	add    $0xc,%esp
80106b26:	eb 12                	jmp    80106b3a <memset+0x62>
  } else
    stosb(dst, c, n);
80106b28:	8b 45 10             	mov    0x10(%ebp),%eax
80106b2b:	50                   	push   %eax
80106b2c:	ff 75 0c             	pushl  0xc(%ebp)
80106b2f:	ff 75 08             	pushl  0x8(%ebp)
80106b32:	e8 55 ff ff ff       	call   80106a8c <stosb>
80106b37:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106b3a:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106b3d:	c9                   	leave  
80106b3e:	c3                   	ret    

80106b3f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106b3f:	55                   	push   %ebp
80106b40:	89 e5                	mov    %esp,%ebp
80106b42:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106b45:	8b 45 08             	mov    0x8(%ebp),%eax
80106b48:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106b51:	eb 30                	jmp    80106b83 <memcmp+0x44>
    if(*s1 != *s2)
80106b53:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b56:	0f b6 10             	movzbl (%eax),%edx
80106b59:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106b5c:	0f b6 00             	movzbl (%eax),%eax
80106b5f:	38 c2                	cmp    %al,%dl
80106b61:	74 18                	je     80106b7b <memcmp+0x3c>
      return *s1 - *s2;
80106b63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b66:	0f b6 00             	movzbl (%eax),%eax
80106b69:	0f b6 d0             	movzbl %al,%edx
80106b6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106b6f:	0f b6 00             	movzbl (%eax),%eax
80106b72:	0f b6 c0             	movzbl %al,%eax
80106b75:	29 c2                	sub    %eax,%edx
80106b77:	89 d0                	mov    %edx,%eax
80106b79:	eb 1a                	jmp    80106b95 <memcmp+0x56>
    s1++, s2++;
80106b7b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106b7f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106b83:	8b 45 10             	mov    0x10(%ebp),%eax
80106b86:	8d 50 ff             	lea    -0x1(%eax),%edx
80106b89:	89 55 10             	mov    %edx,0x10(%ebp)
80106b8c:	85 c0                	test   %eax,%eax
80106b8e:	75 c3                	jne    80106b53 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106b90:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b95:	c9                   	leave  
80106b96:	c3                   	ret    

80106b97 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106b97:	55                   	push   %ebp
80106b98:	89 e5                	mov    %esp,%ebp
80106b9a:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ba0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106ba3:	8b 45 08             	mov    0x8(%ebp),%eax
80106ba6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106ba9:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106baf:	73 54                	jae    80106c05 <memmove+0x6e>
80106bb1:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106bb4:	8b 45 10             	mov    0x10(%ebp),%eax
80106bb7:	01 d0                	add    %edx,%eax
80106bb9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106bbc:	76 47                	jbe    80106c05 <memmove+0x6e>
    s += n;
80106bbe:	8b 45 10             	mov    0x10(%ebp),%eax
80106bc1:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106bc4:	8b 45 10             	mov    0x10(%ebp),%eax
80106bc7:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106bca:	eb 13                	jmp    80106bdf <memmove+0x48>
      *--d = *--s;
80106bcc:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106bd0:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106bd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bd7:	0f b6 10             	movzbl (%eax),%edx
80106bda:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bdd:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106bdf:	8b 45 10             	mov    0x10(%ebp),%eax
80106be2:	8d 50 ff             	lea    -0x1(%eax),%edx
80106be5:	89 55 10             	mov    %edx,0x10(%ebp)
80106be8:	85 c0                	test   %eax,%eax
80106bea:	75 e0                	jne    80106bcc <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106bec:	eb 24                	jmp    80106c12 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106bee:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bf1:	8d 50 01             	lea    0x1(%eax),%edx
80106bf4:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106bf7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106bfa:	8d 4a 01             	lea    0x1(%edx),%ecx
80106bfd:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80106c00:	0f b6 12             	movzbl (%edx),%edx
80106c03:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106c05:	8b 45 10             	mov    0x10(%ebp),%eax
80106c08:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c0b:	89 55 10             	mov    %edx,0x10(%ebp)
80106c0e:	85 c0                	test   %eax,%eax
80106c10:	75 dc                	jne    80106bee <memmove+0x57>
      *d++ = *s++;

  return dst;
80106c12:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106c15:	c9                   	leave  
80106c16:	c3                   	ret    

80106c17 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106c17:	55                   	push   %ebp
80106c18:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106c1a:	ff 75 10             	pushl  0x10(%ebp)
80106c1d:	ff 75 0c             	pushl  0xc(%ebp)
80106c20:	ff 75 08             	pushl  0x8(%ebp)
80106c23:	e8 6f ff ff ff       	call   80106b97 <memmove>
80106c28:	83 c4 0c             	add    $0xc,%esp
}
80106c2b:	c9                   	leave  
80106c2c:	c3                   	ret    

80106c2d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106c2d:	55                   	push   %ebp
80106c2e:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80106c30:	eb 0c                	jmp    80106c3e <strncmp+0x11>
    n--, p++, q++;
80106c32:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106c36:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106c3a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106c3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c42:	74 1a                	je     80106c5e <strncmp+0x31>
80106c44:	8b 45 08             	mov    0x8(%ebp),%eax
80106c47:	0f b6 00             	movzbl (%eax),%eax
80106c4a:	84 c0                	test   %al,%al
80106c4c:	74 10                	je     80106c5e <strncmp+0x31>
80106c4e:	8b 45 08             	mov    0x8(%ebp),%eax
80106c51:	0f b6 10             	movzbl (%eax),%edx
80106c54:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c57:	0f b6 00             	movzbl (%eax),%eax
80106c5a:	38 c2                	cmp    %al,%dl
80106c5c:	74 d4                	je     80106c32 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106c5e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c62:	75 07                	jne    80106c6b <strncmp+0x3e>
    return 0;
80106c64:	b8 00 00 00 00       	mov    $0x0,%eax
80106c69:	eb 16                	jmp    80106c81 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106c6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c6e:	0f b6 00             	movzbl (%eax),%eax
80106c71:	0f b6 d0             	movzbl %al,%edx
80106c74:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c77:	0f b6 00             	movzbl (%eax),%eax
80106c7a:	0f b6 c0             	movzbl %al,%eax
80106c7d:	29 c2                	sub    %eax,%edx
80106c7f:	89 d0                	mov    %edx,%eax
}
80106c81:	5d                   	pop    %ebp
80106c82:	c3                   	ret    

80106c83 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106c83:	55                   	push   %ebp
80106c84:	89 e5                	mov    %esp,%ebp
80106c86:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106c89:	8b 45 08             	mov    0x8(%ebp),%eax
80106c8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106c8f:	90                   	nop
80106c90:	8b 45 10             	mov    0x10(%ebp),%eax
80106c93:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c96:	89 55 10             	mov    %edx,0x10(%ebp)
80106c99:	85 c0                	test   %eax,%eax
80106c9b:	7e 2c                	jle    80106cc9 <strncpy+0x46>
80106c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca0:	8d 50 01             	lea    0x1(%eax),%edx
80106ca3:	89 55 08             	mov    %edx,0x8(%ebp)
80106ca6:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ca9:	8d 4a 01             	lea    0x1(%edx),%ecx
80106cac:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106caf:	0f b6 12             	movzbl (%edx),%edx
80106cb2:	88 10                	mov    %dl,(%eax)
80106cb4:	0f b6 00             	movzbl (%eax),%eax
80106cb7:	84 c0                	test   %al,%al
80106cb9:	75 d5                	jne    80106c90 <strncpy+0xd>
    ;
  while(n-- > 0)
80106cbb:	eb 0c                	jmp    80106cc9 <strncpy+0x46>
    *s++ = 0;
80106cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80106cc0:	8d 50 01             	lea    0x1(%eax),%edx
80106cc3:	89 55 08             	mov    %edx,0x8(%ebp)
80106cc6:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106cc9:	8b 45 10             	mov    0x10(%ebp),%eax
80106ccc:	8d 50 ff             	lea    -0x1(%eax),%edx
80106ccf:	89 55 10             	mov    %edx,0x10(%ebp)
80106cd2:	85 c0                	test   %eax,%eax
80106cd4:	7f e7                	jg     80106cbd <strncpy+0x3a>
    *s++ = 0;
  return os;
80106cd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106cd9:	c9                   	leave  
80106cda:	c3                   	ret    

80106cdb <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106cdb:	55                   	push   %ebp
80106cdc:	89 e5                	mov    %esp,%ebp
80106cde:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106ce1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106ce7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106ceb:	7f 05                	jg     80106cf2 <safestrcpy+0x17>
    return os;
80106ced:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106cf0:	eb 31                	jmp    80106d23 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106cf2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106cf6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106cfa:	7e 1e                	jle    80106d1a <safestrcpy+0x3f>
80106cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80106cff:	8d 50 01             	lea    0x1(%eax),%edx
80106d02:	89 55 08             	mov    %edx,0x8(%ebp)
80106d05:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d08:	8d 4a 01             	lea    0x1(%edx),%ecx
80106d0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106d0e:	0f b6 12             	movzbl (%edx),%edx
80106d11:	88 10                	mov    %dl,(%eax)
80106d13:	0f b6 00             	movzbl (%eax),%eax
80106d16:	84 c0                	test   %al,%al
80106d18:	75 d8                	jne    80106cf2 <safestrcpy+0x17>
    ;
  *s = 0;
80106d1a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d1d:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80106d20:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d23:	c9                   	leave  
80106d24:	c3                   	ret    

80106d25 <strlen>:

int
strlen(const char *s)
{
80106d25:	55                   	push   %ebp
80106d26:	89 e5                	mov    %esp,%ebp
80106d28:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106d2b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106d32:	eb 04                	jmp    80106d38 <strlen+0x13>
80106d34:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106d38:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106d3b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d3e:	01 d0                	add    %edx,%eax
80106d40:	0f b6 00             	movzbl (%eax),%eax
80106d43:	84 c0                	test   %al,%al
80106d45:	75 ed                	jne    80106d34 <strlen+0xf>
    ;
  return n;
80106d47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d4a:	c9                   	leave  
80106d4b:	c3                   	ret    

80106d4c <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106d4c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106d50:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106d54:	55                   	push   %ebp
  pushl %ebx
80106d55:	53                   	push   %ebx
  pushl %esi
80106d56:	56                   	push   %esi
  pushl %edi
80106d57:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106d58:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106d5a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106d5c:	5f                   	pop    %edi
  popl %esi
80106d5d:	5e                   	pop    %esi
  popl %ebx
80106d5e:	5b                   	pop    %ebx
  popl %ebp
80106d5f:	5d                   	pop    %ebp
  ret
80106d60:	c3                   	ret    

80106d61 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106d61:	55                   	push   %ebp
80106d62:	89 e5                	mov    %esp,%ebp
    if(addr >= proc->sz || addr+4 > proc->sz)
80106d64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d6a:	8b 00                	mov    (%eax),%eax
80106d6c:	3b 45 08             	cmp    0x8(%ebp),%eax
80106d6f:	76 12                	jbe    80106d83 <fetchint+0x22>
80106d71:	8b 45 08             	mov    0x8(%ebp),%eax
80106d74:	8d 50 04             	lea    0x4(%eax),%edx
80106d77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d7d:	8b 00                	mov    (%eax),%eax
80106d7f:	39 c2                	cmp    %eax,%edx
80106d81:	76 07                	jbe    80106d8a <fetchint+0x29>
        return -1;
80106d83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d88:	eb 0f                	jmp    80106d99 <fetchint+0x38>
    *ip = *(int*)(addr);
80106d8a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d8d:	8b 10                	mov    (%eax),%edx
80106d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d92:	89 10                	mov    %edx,(%eax)
    return 0;
80106d94:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d99:	5d                   	pop    %ebp
80106d9a:	c3                   	ret    

80106d9b <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106d9b:	55                   	push   %ebp
80106d9c:	89 e5                	mov    %esp,%ebp
80106d9e:	83 ec 10             	sub    $0x10,%esp
    char *s, *ep;

    if(addr >= proc->sz)
80106da1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106da7:	8b 00                	mov    (%eax),%eax
80106da9:	3b 45 08             	cmp    0x8(%ebp),%eax
80106dac:	77 07                	ja     80106db5 <fetchstr+0x1a>
        return -1;
80106dae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106db3:	eb 46                	jmp    80106dfb <fetchstr+0x60>
    *pp = (char*)addr;
80106db5:	8b 55 08             	mov    0x8(%ebp),%edx
80106db8:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dbb:	89 10                	mov    %edx,(%eax)
    ep = (char*)proc->sz;
80106dbd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dc3:	8b 00                	mov    (%eax),%eax
80106dc5:	89 45 f8             	mov    %eax,-0x8(%ebp)
    for(s = *pp; s < ep; s++)
80106dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dcb:	8b 00                	mov    (%eax),%eax
80106dcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106dd0:	eb 1c                	jmp    80106dee <fetchstr+0x53>
        if(*s == 0)
80106dd2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106dd5:	0f b6 00             	movzbl (%eax),%eax
80106dd8:	84 c0                	test   %al,%al
80106dda:	75 0e                	jne    80106dea <fetchstr+0x4f>
            return s - *pp;
80106ddc:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
80106de2:	8b 00                	mov    (%eax),%eax
80106de4:	29 c2                	sub    %eax,%edx
80106de6:	89 d0                	mov    %edx,%eax
80106de8:	eb 11                	jmp    80106dfb <fetchstr+0x60>

    if(addr >= proc->sz)
        return -1;
    *pp = (char*)addr;
    ep = (char*)proc->sz;
    for(s = *pp; s < ep; s++)
80106dea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106df1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106df4:	72 dc                	jb     80106dd2 <fetchstr+0x37>
        if(*s == 0)
            return s - *pp;
    return -1;
80106df6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106dfb:	c9                   	leave  
80106dfc:	c3                   	ret    

80106dfd <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106dfd:	55                   	push   %ebp
80106dfe:	89 e5                	mov    %esp,%ebp
    return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106e00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e06:	8b 40 18             	mov    0x18(%eax),%eax
80106e09:	8b 40 44             	mov    0x44(%eax),%eax
80106e0c:	8b 55 08             	mov    0x8(%ebp),%edx
80106e0f:	c1 e2 02             	shl    $0x2,%edx
80106e12:	01 d0                	add    %edx,%eax
80106e14:	83 c0 04             	add    $0x4,%eax
80106e17:	ff 75 0c             	pushl  0xc(%ebp)
80106e1a:	50                   	push   %eax
80106e1b:	e8 41 ff ff ff       	call   80106d61 <fetchint>
80106e20:	83 c4 08             	add    $0x8,%esp
}
80106e23:	c9                   	leave  
80106e24:	c3                   	ret    

80106e25 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106e25:	55                   	push   %ebp
80106e26:	89 e5                	mov    %esp,%ebp
80106e28:	83 ec 10             	sub    $0x10,%esp
    int i;

    if(argint(n, &i) < 0)
80106e2b:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106e2e:	50                   	push   %eax
80106e2f:	ff 75 08             	pushl  0x8(%ebp)
80106e32:	e8 c6 ff ff ff       	call   80106dfd <argint>
80106e37:	83 c4 08             	add    $0x8,%esp
80106e3a:	85 c0                	test   %eax,%eax
80106e3c:	79 07                	jns    80106e45 <argptr+0x20>
        return -1;
80106e3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e43:	eb 3b                	jmp    80106e80 <argptr+0x5b>
    if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106e45:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e4b:	8b 00                	mov    (%eax),%eax
80106e4d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e50:	39 d0                	cmp    %edx,%eax
80106e52:	76 16                	jbe    80106e6a <argptr+0x45>
80106e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e57:	89 c2                	mov    %eax,%edx
80106e59:	8b 45 10             	mov    0x10(%ebp),%eax
80106e5c:	01 c2                	add    %eax,%edx
80106e5e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e64:	8b 00                	mov    (%eax),%eax
80106e66:	39 c2                	cmp    %eax,%edx
80106e68:	76 07                	jbe    80106e71 <argptr+0x4c>
        return -1;
80106e6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e6f:	eb 0f                	jmp    80106e80 <argptr+0x5b>
    *pp = (char*)i;
80106e71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e74:	89 c2                	mov    %eax,%edx
80106e76:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e79:	89 10                	mov    %edx,(%eax)
    return 0;
80106e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e80:	c9                   	leave  
80106e81:	c3                   	ret    

80106e82 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106e82:	55                   	push   %ebp
80106e83:	89 e5                	mov    %esp,%ebp
80106e85:	83 ec 10             	sub    $0x10,%esp
    int addr;
    if(argint(n, &addr) < 0)
80106e88:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106e8b:	50                   	push   %eax
80106e8c:	ff 75 08             	pushl  0x8(%ebp)
80106e8f:	e8 69 ff ff ff       	call   80106dfd <argint>
80106e94:	83 c4 08             	add    $0x8,%esp
80106e97:	85 c0                	test   %eax,%eax
80106e99:	79 07                	jns    80106ea2 <argstr+0x20>
        return -1;
80106e9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ea0:	eb 0f                	jmp    80106eb1 <argstr+0x2f>
    return fetchstr(addr, pp);
80106ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106ea5:	ff 75 0c             	pushl  0xc(%ebp)
80106ea8:	50                   	push   %eax
80106ea9:	e8 ed fe ff ff       	call   80106d9b <fetchstr>
80106eae:	83 c4 08             	add    $0x8,%esp
}
80106eb1:	c9                   	leave  
80106eb2:	c3                   	ret    

80106eb3 <syscall>:
};
#endif

void
syscall(void)
{
80106eb3:	55                   	push   %ebp
80106eb4:	89 e5                	mov    %esp,%ebp
80106eb6:	53                   	push   %ebx
80106eb7:	83 ec 14             	sub    $0x14,%esp
    int num;

    num = proc->tf->eax;
80106eba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ec0:	8b 40 18             	mov    0x18(%eax),%eax
80106ec3:	8b 40 1c             	mov    0x1c(%eax),%eax
80106ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106ec9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ecd:	7e 30                	jle    80106eff <syscall+0x4c>
80106ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ed2:	83 f8 1e             	cmp    $0x1e,%eax
80106ed5:	77 28                	ja     80106eff <syscall+0x4c>
80106ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eda:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106ee1:	85 c0                	test   %eax,%eax
80106ee3:	74 1a                	je     80106eff <syscall+0x4c>
        proc->tf->eax = syscalls[num]();
80106ee5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106eeb:	8b 58 18             	mov    0x18(%eax),%ebx
80106eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ef1:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106ef8:	ff d0                	call   *%eax
80106efa:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106efd:	eb 34                	jmp    80106f33 <syscall+0x80>
#ifdef PRINT_SYSCALLS
        cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif
    } else {
        cprintf("%d %s: unknown sys call %d\n",
                proc->pid, proc->name, num);
80106eff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f05:	8d 50 6c             	lea    0x6c(%eax),%edx
80106f08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
        // some code goes here
#ifdef PRINT_SYSCALLS
        cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif
    } else {
        cprintf("%d %s: unknown sys call %d\n",
80106f0e:	8b 40 10             	mov    0x10(%eax),%eax
80106f11:	ff 75 f4             	pushl  -0xc(%ebp)
80106f14:	52                   	push   %edx
80106f15:	50                   	push   %eax
80106f16:	68 e6 aa 10 80       	push   $0x8010aae6
80106f1b:	e8 a6 94 ff ff       	call   801003c6 <cprintf>
80106f20:	83 c4 10             	add    $0x10,%esp
                proc->pid, proc->name, num);
        proc->tf->eax = -1;
80106f23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f29:	8b 40 18             	mov    0x18(%eax),%eax
80106f2c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
    }
}
80106f33:	90                   	nop
80106f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106f37:	c9                   	leave  
80106f38:	c3                   	ret    

80106f39 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106f39:	55                   	push   %ebp
80106f3a:	89 e5                	mov    %esp,%ebp
80106f3c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106f3f:	83 ec 08             	sub    $0x8,%esp
80106f42:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f45:	50                   	push   %eax
80106f46:	ff 75 08             	pushl  0x8(%ebp)
80106f49:	e8 af fe ff ff       	call   80106dfd <argint>
80106f4e:	83 c4 10             	add    $0x10,%esp
80106f51:	85 c0                	test   %eax,%eax
80106f53:	79 07                	jns    80106f5c <argfd+0x23>
    return -1;
80106f55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f5a:	eb 50                	jmp    80106fac <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f5f:	85 c0                	test   %eax,%eax
80106f61:	78 21                	js     80106f84 <argfd+0x4b>
80106f63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f66:	83 f8 0f             	cmp    $0xf,%eax
80106f69:	7f 19                	jg     80106f84 <argfd+0x4b>
80106f6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f71:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106f74:	83 c2 08             	add    $0x8,%edx
80106f77:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106f7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106f7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106f82:	75 07                	jne    80106f8b <argfd+0x52>
    return -1;
80106f84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f89:	eb 21                	jmp    80106fac <argfd+0x73>
  if(pfd)
80106f8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106f8f:	74 08                	je     80106f99 <argfd+0x60>
    *pfd = fd;
80106f91:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106f94:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f97:	89 10                	mov    %edx,(%eax)
  if(pf)
80106f99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106f9d:	74 08                	je     80106fa7 <argfd+0x6e>
    *pf = f;
80106f9f:	8b 45 10             	mov    0x10(%ebp),%eax
80106fa2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106fa5:	89 10                	mov    %edx,(%eax)
  return 0;
80106fa7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106fac:	c9                   	leave  
80106fad:	c3                   	ret    

80106fae <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106fae:	55                   	push   %ebp
80106faf:	89 e5                	mov    %esp,%ebp
80106fb1:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106fb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106fbb:	eb 30                	jmp    80106fed <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106fbd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fc3:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106fc6:	83 c2 08             	add    $0x8,%edx
80106fc9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106fcd:	85 c0                	test   %eax,%eax
80106fcf:	75 18                	jne    80106fe9 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106fd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fd7:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106fda:	8d 4a 08             	lea    0x8(%edx),%ecx
80106fdd:	8b 55 08             	mov    0x8(%ebp),%edx
80106fe0:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106fe7:	eb 0f                	jmp    80106ff8 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106fe9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106fed:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106ff1:	7e ca                	jle    80106fbd <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80106ff3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ff8:	c9                   	leave  
80106ff9:	c3                   	ret    

80106ffa <sys_dup>:

int
sys_dup(void)
{
80106ffa:	55                   	push   %ebp
80106ffb:	89 e5                	mov    %esp,%ebp
80106ffd:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80107000:	83 ec 04             	sub    $0x4,%esp
80107003:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107006:	50                   	push   %eax
80107007:	6a 00                	push   $0x0
80107009:	6a 00                	push   $0x0
8010700b:	e8 29 ff ff ff       	call   80106f39 <argfd>
80107010:	83 c4 10             	add    $0x10,%esp
80107013:	85 c0                	test   %eax,%eax
80107015:	79 07                	jns    8010701e <sys_dup+0x24>
    return -1;
80107017:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010701c:	eb 31                	jmp    8010704f <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010701e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107021:	83 ec 0c             	sub    $0xc,%esp
80107024:	50                   	push   %eax
80107025:	e8 84 ff ff ff       	call   80106fae <fdalloc>
8010702a:	83 c4 10             	add    $0x10,%esp
8010702d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107030:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107034:	79 07                	jns    8010703d <sys_dup+0x43>
    return -1;
80107036:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010703b:	eb 12                	jmp    8010704f <sys_dup+0x55>
  filedup(f);
8010703d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107040:	83 ec 0c             	sub    $0xc,%esp
80107043:	50                   	push   %eax
80107044:	e8 68 a0 ff ff       	call   801010b1 <filedup>
80107049:	83 c4 10             	add    $0x10,%esp
  return fd;
8010704c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010704f:	c9                   	leave  
80107050:	c3                   	ret    

80107051 <sys_read>:

int
sys_read(void)
{
80107051:	55                   	push   %ebp
80107052:	89 e5                	mov    %esp,%ebp
80107054:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80107057:	83 ec 04             	sub    $0x4,%esp
8010705a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010705d:	50                   	push   %eax
8010705e:	6a 00                	push   $0x0
80107060:	6a 00                	push   $0x0
80107062:	e8 d2 fe ff ff       	call   80106f39 <argfd>
80107067:	83 c4 10             	add    $0x10,%esp
8010706a:	85 c0                	test   %eax,%eax
8010706c:	78 2e                	js     8010709c <sys_read+0x4b>
8010706e:	83 ec 08             	sub    $0x8,%esp
80107071:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107074:	50                   	push   %eax
80107075:	6a 02                	push   $0x2
80107077:	e8 81 fd ff ff       	call   80106dfd <argint>
8010707c:	83 c4 10             	add    $0x10,%esp
8010707f:	85 c0                	test   %eax,%eax
80107081:	78 19                	js     8010709c <sys_read+0x4b>
80107083:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107086:	83 ec 04             	sub    $0x4,%esp
80107089:	50                   	push   %eax
8010708a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010708d:	50                   	push   %eax
8010708e:	6a 01                	push   $0x1
80107090:	e8 90 fd ff ff       	call   80106e25 <argptr>
80107095:	83 c4 10             	add    $0x10,%esp
80107098:	85 c0                	test   %eax,%eax
8010709a:	79 07                	jns    801070a3 <sys_read+0x52>
    return -1;
8010709c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070a1:	eb 17                	jmp    801070ba <sys_read+0x69>
  return fileread(f, p, n);
801070a3:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801070a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801070a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070ac:	83 ec 04             	sub    $0x4,%esp
801070af:	51                   	push   %ecx
801070b0:	52                   	push   %edx
801070b1:	50                   	push   %eax
801070b2:	e8 8a a1 ff ff       	call   80101241 <fileread>
801070b7:	83 c4 10             	add    $0x10,%esp
}
801070ba:	c9                   	leave  
801070bb:	c3                   	ret    

801070bc <sys_write>:

int
sys_write(void)
{
801070bc:	55                   	push   %ebp
801070bd:	89 e5                	mov    %esp,%ebp
801070bf:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801070c2:	83 ec 04             	sub    $0x4,%esp
801070c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070c8:	50                   	push   %eax
801070c9:	6a 00                	push   $0x0
801070cb:	6a 00                	push   $0x0
801070cd:	e8 67 fe ff ff       	call   80106f39 <argfd>
801070d2:	83 c4 10             	add    $0x10,%esp
801070d5:	85 c0                	test   %eax,%eax
801070d7:	78 2e                	js     80107107 <sys_write+0x4b>
801070d9:	83 ec 08             	sub    $0x8,%esp
801070dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070df:	50                   	push   %eax
801070e0:	6a 02                	push   $0x2
801070e2:	e8 16 fd ff ff       	call   80106dfd <argint>
801070e7:	83 c4 10             	add    $0x10,%esp
801070ea:	85 c0                	test   %eax,%eax
801070ec:	78 19                	js     80107107 <sys_write+0x4b>
801070ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070f1:	83 ec 04             	sub    $0x4,%esp
801070f4:	50                   	push   %eax
801070f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801070f8:	50                   	push   %eax
801070f9:	6a 01                	push   $0x1
801070fb:	e8 25 fd ff ff       	call   80106e25 <argptr>
80107100:	83 c4 10             	add    $0x10,%esp
80107103:	85 c0                	test   %eax,%eax
80107105:	79 07                	jns    8010710e <sys_write+0x52>
    return -1;
80107107:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010710c:	eb 17                	jmp    80107125 <sys_write+0x69>
  return filewrite(f, p, n);
8010710e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107111:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107117:	83 ec 04             	sub    $0x4,%esp
8010711a:	51                   	push   %ecx
8010711b:	52                   	push   %edx
8010711c:	50                   	push   %eax
8010711d:	e8 d7 a1 ff ff       	call   801012f9 <filewrite>
80107122:	83 c4 10             	add    $0x10,%esp
}
80107125:	c9                   	leave  
80107126:	c3                   	ret    

80107127 <sys_close>:

int
sys_close(void)
{
80107127:	55                   	push   %ebp
80107128:	89 e5                	mov    %esp,%ebp
8010712a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010712d:	83 ec 04             	sub    $0x4,%esp
80107130:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107133:	50                   	push   %eax
80107134:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107137:	50                   	push   %eax
80107138:	6a 00                	push   $0x0
8010713a:	e8 fa fd ff ff       	call   80106f39 <argfd>
8010713f:	83 c4 10             	add    $0x10,%esp
80107142:	85 c0                	test   %eax,%eax
80107144:	79 07                	jns    8010714d <sys_close+0x26>
    return -1;
80107146:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010714b:	eb 28                	jmp    80107175 <sys_close+0x4e>
  proc->ofile[fd] = 0;
8010714d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107153:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107156:	83 c2 08             	add    $0x8,%edx
80107159:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107160:	00 
  fileclose(f);
80107161:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107164:	83 ec 0c             	sub    $0xc,%esp
80107167:	50                   	push   %eax
80107168:	e8 95 9f ff ff       	call   80101102 <fileclose>
8010716d:	83 c4 10             	add    $0x10,%esp
  return 0;
80107170:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107175:	c9                   	leave  
80107176:	c3                   	ret    

80107177 <sys_fstat>:

int
sys_fstat(void)
{
80107177:	55                   	push   %ebp
80107178:	89 e5                	mov    %esp,%ebp
8010717a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010717d:	83 ec 04             	sub    $0x4,%esp
80107180:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107183:	50                   	push   %eax
80107184:	6a 00                	push   $0x0
80107186:	6a 00                	push   $0x0
80107188:	e8 ac fd ff ff       	call   80106f39 <argfd>
8010718d:	83 c4 10             	add    $0x10,%esp
80107190:	85 c0                	test   %eax,%eax
80107192:	78 17                	js     801071ab <sys_fstat+0x34>
80107194:	83 ec 04             	sub    $0x4,%esp
80107197:	6a 14                	push   $0x14
80107199:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010719c:	50                   	push   %eax
8010719d:	6a 01                	push   $0x1
8010719f:	e8 81 fc ff ff       	call   80106e25 <argptr>
801071a4:	83 c4 10             	add    $0x10,%esp
801071a7:	85 c0                	test   %eax,%eax
801071a9:	79 07                	jns    801071b2 <sys_fstat+0x3b>
    return -1;
801071ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071b0:	eb 13                	jmp    801071c5 <sys_fstat+0x4e>
  return filestat(f, st);
801071b2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801071b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071b8:	83 ec 08             	sub    $0x8,%esp
801071bb:	52                   	push   %edx
801071bc:	50                   	push   %eax
801071bd:	e8 28 a0 ff ff       	call   801011ea <filestat>
801071c2:	83 c4 10             	add    $0x10,%esp
}
801071c5:	c9                   	leave  
801071c6:	c3                   	ret    

801071c7 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801071c7:	55                   	push   %ebp
801071c8:	89 e5                	mov    %esp,%ebp
801071ca:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801071cd:	83 ec 08             	sub    $0x8,%esp
801071d0:	8d 45 d8             	lea    -0x28(%ebp),%eax
801071d3:	50                   	push   %eax
801071d4:	6a 00                	push   $0x0
801071d6:	e8 a7 fc ff ff       	call   80106e82 <argstr>
801071db:	83 c4 10             	add    $0x10,%esp
801071de:	85 c0                	test   %eax,%eax
801071e0:	78 15                	js     801071f7 <sys_link+0x30>
801071e2:	83 ec 08             	sub    $0x8,%esp
801071e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
801071e8:	50                   	push   %eax
801071e9:	6a 01                	push   $0x1
801071eb:	e8 92 fc ff ff       	call   80106e82 <argstr>
801071f0:	83 c4 10             	add    $0x10,%esp
801071f3:	85 c0                	test   %eax,%eax
801071f5:	79 0a                	jns    80107201 <sys_link+0x3a>
    return -1;
801071f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071fc:	e9 68 01 00 00       	jmp    80107369 <sys_link+0x1a2>

  begin_op();
80107201:	e8 f8 c3 ff ff       	call   801035fe <begin_op>
  if((ip = namei(old)) == 0){
80107206:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107209:	83 ec 0c             	sub    $0xc,%esp
8010720c:	50                   	push   %eax
8010720d:	e8 c7 b3 ff ff       	call   801025d9 <namei>
80107212:	83 c4 10             	add    $0x10,%esp
80107215:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107218:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010721c:	75 0f                	jne    8010722d <sys_link+0x66>
    end_op();
8010721e:	e8 67 c4 ff ff       	call   8010368a <end_op>
    return -1;
80107223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107228:	e9 3c 01 00 00       	jmp    80107369 <sys_link+0x1a2>
  }

  ilock(ip);
8010722d:	83 ec 0c             	sub    $0xc,%esp
80107230:	ff 75 f4             	pushl  -0xc(%ebp)
80107233:	e8 e3 a7 ff ff       	call   80101a1b <ilock>
80107238:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010723b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010723e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107242:	66 83 f8 01          	cmp    $0x1,%ax
80107246:	75 1d                	jne    80107265 <sys_link+0x9e>
    iunlockput(ip);
80107248:	83 ec 0c             	sub    $0xc,%esp
8010724b:	ff 75 f4             	pushl  -0xc(%ebp)
8010724e:	e8 88 aa ff ff       	call   80101cdb <iunlockput>
80107253:	83 c4 10             	add    $0x10,%esp
    end_op();
80107256:	e8 2f c4 ff ff       	call   8010368a <end_op>
    return -1;
8010725b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107260:	e9 04 01 00 00       	jmp    80107369 <sys_link+0x1a2>
  }

  ip->nlink++;
80107265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107268:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010726c:	83 c0 01             	add    $0x1,%eax
8010726f:	89 c2                	mov    %eax,%edx
80107271:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107274:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107278:	83 ec 0c             	sub    $0xc,%esp
8010727b:	ff 75 f4             	pushl  -0xc(%ebp)
8010727e:	e8 be a5 ff ff       	call   80101841 <iupdate>
80107283:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80107286:	83 ec 0c             	sub    $0xc,%esp
80107289:	ff 75 f4             	pushl  -0xc(%ebp)
8010728c:	e8 e8 a8 ff ff       	call   80101b79 <iunlock>
80107291:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80107294:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107297:	83 ec 08             	sub    $0x8,%esp
8010729a:	8d 55 e2             	lea    -0x1e(%ebp),%edx
8010729d:	52                   	push   %edx
8010729e:	50                   	push   %eax
8010729f:	e8 51 b3 ff ff       	call   801025f5 <nameiparent>
801072a4:	83 c4 10             	add    $0x10,%esp
801072a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801072aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801072ae:	74 71                	je     80107321 <sys_link+0x15a>
    goto bad;
  ilock(dp);
801072b0:	83 ec 0c             	sub    $0xc,%esp
801072b3:	ff 75 f0             	pushl  -0x10(%ebp)
801072b6:	e8 60 a7 ff ff       	call   80101a1b <ilock>
801072bb:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801072be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072c1:	8b 10                	mov    (%eax),%edx
801072c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072c6:	8b 00                	mov    (%eax),%eax
801072c8:	39 c2                	cmp    %eax,%edx
801072ca:	75 1d                	jne    801072e9 <sys_link+0x122>
801072cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072cf:	8b 40 04             	mov    0x4(%eax),%eax
801072d2:	83 ec 04             	sub    $0x4,%esp
801072d5:	50                   	push   %eax
801072d6:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801072d9:	50                   	push   %eax
801072da:	ff 75 f0             	pushl  -0x10(%ebp)
801072dd:	e8 5b b0 ff ff       	call   8010233d <dirlink>
801072e2:	83 c4 10             	add    $0x10,%esp
801072e5:	85 c0                	test   %eax,%eax
801072e7:	79 10                	jns    801072f9 <sys_link+0x132>
    iunlockput(dp);
801072e9:	83 ec 0c             	sub    $0xc,%esp
801072ec:	ff 75 f0             	pushl  -0x10(%ebp)
801072ef:	e8 e7 a9 ff ff       	call   80101cdb <iunlockput>
801072f4:	83 c4 10             	add    $0x10,%esp
    goto bad;
801072f7:	eb 29                	jmp    80107322 <sys_link+0x15b>
  }
  iunlockput(dp);
801072f9:	83 ec 0c             	sub    $0xc,%esp
801072fc:	ff 75 f0             	pushl  -0x10(%ebp)
801072ff:	e8 d7 a9 ff ff       	call   80101cdb <iunlockput>
80107304:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80107307:	83 ec 0c             	sub    $0xc,%esp
8010730a:	ff 75 f4             	pushl  -0xc(%ebp)
8010730d:	e8 d9 a8 ff ff       	call   80101beb <iput>
80107312:	83 c4 10             	add    $0x10,%esp

  end_op();
80107315:	e8 70 c3 ff ff       	call   8010368a <end_op>

  return 0;
8010731a:	b8 00 00 00 00       	mov    $0x0,%eax
8010731f:	eb 48                	jmp    80107369 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80107321:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80107322:	83 ec 0c             	sub    $0xc,%esp
80107325:	ff 75 f4             	pushl  -0xc(%ebp)
80107328:	e8 ee a6 ff ff       	call   80101a1b <ilock>
8010732d:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80107330:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107333:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107337:	83 e8 01             	sub    $0x1,%eax
8010733a:	89 c2                	mov    %eax,%edx
8010733c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010733f:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107343:	83 ec 0c             	sub    $0xc,%esp
80107346:	ff 75 f4             	pushl  -0xc(%ebp)
80107349:	e8 f3 a4 ff ff       	call   80101841 <iupdate>
8010734e:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107351:	83 ec 0c             	sub    $0xc,%esp
80107354:	ff 75 f4             	pushl  -0xc(%ebp)
80107357:	e8 7f a9 ff ff       	call   80101cdb <iunlockput>
8010735c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010735f:	e8 26 c3 ff ff       	call   8010368a <end_op>
  return -1;
80107364:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107369:	c9                   	leave  
8010736a:	c3                   	ret    

8010736b <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010736b:	55                   	push   %ebp
8010736c:	89 e5                	mov    %esp,%ebp
8010736e:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107371:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80107378:	eb 40                	jmp    801073ba <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010737a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010737d:	6a 10                	push   $0x10
8010737f:	50                   	push   %eax
80107380:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107383:	50                   	push   %eax
80107384:	ff 75 08             	pushl  0x8(%ebp)
80107387:	e8 fd ab ff ff       	call   80101f89 <readi>
8010738c:	83 c4 10             	add    $0x10,%esp
8010738f:	83 f8 10             	cmp    $0x10,%eax
80107392:	74 0d                	je     801073a1 <isdirempty+0x36>
      panic("isdirempty: readi");
80107394:	83 ec 0c             	sub    $0xc,%esp
80107397:	68 02 ab 10 80       	push   $0x8010ab02
8010739c:	e8 c5 91 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
801073a1:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801073a5:	66 85 c0             	test   %ax,%ax
801073a8:	74 07                	je     801073b1 <isdirempty+0x46>
      return 0;
801073aa:	b8 00 00 00 00       	mov    $0x0,%eax
801073af:	eb 1b                	jmp    801073cc <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801073b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073b4:	83 c0 10             	add    $0x10,%eax
801073b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073ba:	8b 45 08             	mov    0x8(%ebp),%eax
801073bd:	8b 50 18             	mov    0x18(%eax),%edx
801073c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c3:	39 c2                	cmp    %eax,%edx
801073c5:	77 b3                	ja     8010737a <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801073c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
801073cc:	c9                   	leave  
801073cd:	c3                   	ret    

801073ce <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801073ce:	55                   	push   %ebp
801073cf:	89 e5                	mov    %esp,%ebp
801073d1:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801073d4:	83 ec 08             	sub    $0x8,%esp
801073d7:	8d 45 cc             	lea    -0x34(%ebp),%eax
801073da:	50                   	push   %eax
801073db:	6a 00                	push   $0x0
801073dd:	e8 a0 fa ff ff       	call   80106e82 <argstr>
801073e2:	83 c4 10             	add    $0x10,%esp
801073e5:	85 c0                	test   %eax,%eax
801073e7:	79 0a                	jns    801073f3 <sys_unlink+0x25>
    return -1;
801073e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073ee:	e9 bc 01 00 00       	jmp    801075af <sys_unlink+0x1e1>

  begin_op();
801073f3:	e8 06 c2 ff ff       	call   801035fe <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801073f8:	8b 45 cc             	mov    -0x34(%ebp),%eax
801073fb:	83 ec 08             	sub    $0x8,%esp
801073fe:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80107401:	52                   	push   %edx
80107402:	50                   	push   %eax
80107403:	e8 ed b1 ff ff       	call   801025f5 <nameiparent>
80107408:	83 c4 10             	add    $0x10,%esp
8010740b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010740e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107412:	75 0f                	jne    80107423 <sys_unlink+0x55>
    end_op();
80107414:	e8 71 c2 ff ff       	call   8010368a <end_op>
    return -1;
80107419:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010741e:	e9 8c 01 00 00       	jmp    801075af <sys_unlink+0x1e1>
  }

  ilock(dp);
80107423:	83 ec 0c             	sub    $0xc,%esp
80107426:	ff 75 f4             	pushl  -0xc(%ebp)
80107429:	e8 ed a5 ff ff       	call   80101a1b <ilock>
8010742e:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80107431:	83 ec 08             	sub    $0x8,%esp
80107434:	68 14 ab 10 80       	push   $0x8010ab14
80107439:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010743c:	50                   	push   %eax
8010743d:	e8 26 ae ff ff       	call   80102268 <namecmp>
80107442:	83 c4 10             	add    $0x10,%esp
80107445:	85 c0                	test   %eax,%eax
80107447:	0f 84 4a 01 00 00    	je     80107597 <sys_unlink+0x1c9>
8010744d:	83 ec 08             	sub    $0x8,%esp
80107450:	68 16 ab 10 80       	push   $0x8010ab16
80107455:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107458:	50                   	push   %eax
80107459:	e8 0a ae ff ff       	call   80102268 <namecmp>
8010745e:	83 c4 10             	add    $0x10,%esp
80107461:	85 c0                	test   %eax,%eax
80107463:	0f 84 2e 01 00 00    	je     80107597 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80107469:	83 ec 04             	sub    $0x4,%esp
8010746c:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010746f:	50                   	push   %eax
80107470:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107473:	50                   	push   %eax
80107474:	ff 75 f4             	pushl  -0xc(%ebp)
80107477:	e8 07 ae ff ff       	call   80102283 <dirlookup>
8010747c:	83 c4 10             	add    $0x10,%esp
8010747f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107482:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107486:	0f 84 0a 01 00 00    	je     80107596 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
8010748c:	83 ec 0c             	sub    $0xc,%esp
8010748f:	ff 75 f0             	pushl  -0x10(%ebp)
80107492:	e8 84 a5 ff ff       	call   80101a1b <ilock>
80107497:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
8010749a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010749d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801074a1:	66 85 c0             	test   %ax,%ax
801074a4:	7f 0d                	jg     801074b3 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801074a6:	83 ec 0c             	sub    $0xc,%esp
801074a9:	68 19 ab 10 80       	push   $0x8010ab19
801074ae:	e8 b3 90 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801074b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074b6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801074ba:	66 83 f8 01          	cmp    $0x1,%ax
801074be:	75 25                	jne    801074e5 <sys_unlink+0x117>
801074c0:	83 ec 0c             	sub    $0xc,%esp
801074c3:	ff 75 f0             	pushl  -0x10(%ebp)
801074c6:	e8 a0 fe ff ff       	call   8010736b <isdirempty>
801074cb:	83 c4 10             	add    $0x10,%esp
801074ce:	85 c0                	test   %eax,%eax
801074d0:	75 13                	jne    801074e5 <sys_unlink+0x117>
    iunlockput(ip);
801074d2:	83 ec 0c             	sub    $0xc,%esp
801074d5:	ff 75 f0             	pushl  -0x10(%ebp)
801074d8:	e8 fe a7 ff ff       	call   80101cdb <iunlockput>
801074dd:	83 c4 10             	add    $0x10,%esp
    goto bad;
801074e0:	e9 b2 00 00 00       	jmp    80107597 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801074e5:	83 ec 04             	sub    $0x4,%esp
801074e8:	6a 10                	push   $0x10
801074ea:	6a 00                	push   $0x0
801074ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
801074ef:	50                   	push   %eax
801074f0:	e8 e3 f5 ff ff       	call   80106ad8 <memset>
801074f5:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801074f8:	8b 45 c8             	mov    -0x38(%ebp),%eax
801074fb:	6a 10                	push   $0x10
801074fd:	50                   	push   %eax
801074fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107501:	50                   	push   %eax
80107502:	ff 75 f4             	pushl  -0xc(%ebp)
80107505:	e8 d6 ab ff ff       	call   801020e0 <writei>
8010750a:	83 c4 10             	add    $0x10,%esp
8010750d:	83 f8 10             	cmp    $0x10,%eax
80107510:	74 0d                	je     8010751f <sys_unlink+0x151>
    panic("unlink: writei");
80107512:	83 ec 0c             	sub    $0xc,%esp
80107515:	68 2b ab 10 80       	push   $0x8010ab2b
8010751a:	e8 47 90 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
8010751f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107522:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107526:	66 83 f8 01          	cmp    $0x1,%ax
8010752a:	75 21                	jne    8010754d <sys_unlink+0x17f>
    dp->nlink--;
8010752c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010752f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107533:	83 e8 01             	sub    $0x1,%eax
80107536:	89 c2                	mov    %eax,%edx
80107538:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010753b:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010753f:	83 ec 0c             	sub    $0xc,%esp
80107542:	ff 75 f4             	pushl  -0xc(%ebp)
80107545:	e8 f7 a2 ff ff       	call   80101841 <iupdate>
8010754a:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010754d:	83 ec 0c             	sub    $0xc,%esp
80107550:	ff 75 f4             	pushl  -0xc(%ebp)
80107553:	e8 83 a7 ff ff       	call   80101cdb <iunlockput>
80107558:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010755b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010755e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107562:	83 e8 01             	sub    $0x1,%eax
80107565:	89 c2                	mov    %eax,%edx
80107567:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010756a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010756e:	83 ec 0c             	sub    $0xc,%esp
80107571:	ff 75 f0             	pushl  -0x10(%ebp)
80107574:	e8 c8 a2 ff ff       	call   80101841 <iupdate>
80107579:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010757c:	83 ec 0c             	sub    $0xc,%esp
8010757f:	ff 75 f0             	pushl  -0x10(%ebp)
80107582:	e8 54 a7 ff ff       	call   80101cdb <iunlockput>
80107587:	83 c4 10             	add    $0x10,%esp

  end_op();
8010758a:	e8 fb c0 ff ff       	call   8010368a <end_op>

  return 0;
8010758f:	b8 00 00 00 00       	mov    $0x0,%eax
80107594:	eb 19                	jmp    801075af <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80107596:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80107597:	83 ec 0c             	sub    $0xc,%esp
8010759a:	ff 75 f4             	pushl  -0xc(%ebp)
8010759d:	e8 39 a7 ff ff       	call   80101cdb <iunlockput>
801075a2:	83 c4 10             	add    $0x10,%esp
  end_op();
801075a5:	e8 e0 c0 ff ff       	call   8010368a <end_op>
  return -1;
801075aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075af:	c9                   	leave  
801075b0:	c3                   	ret    

801075b1 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801075b1:	55                   	push   %ebp
801075b2:	89 e5                	mov    %esp,%ebp
801075b4:	83 ec 38             	sub    $0x38,%esp
801075b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075ba:	8b 55 10             	mov    0x10(%ebp),%edx
801075bd:	8b 45 14             	mov    0x14(%ebp),%eax
801075c0:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801075c4:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801075c8:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801075cc:	83 ec 08             	sub    $0x8,%esp
801075cf:	8d 45 de             	lea    -0x22(%ebp),%eax
801075d2:	50                   	push   %eax
801075d3:	ff 75 08             	pushl  0x8(%ebp)
801075d6:	e8 1a b0 ff ff       	call   801025f5 <nameiparent>
801075db:	83 c4 10             	add    $0x10,%esp
801075de:	89 45 f4             	mov    %eax,-0xc(%ebp)
801075e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801075e5:	75 0a                	jne    801075f1 <create+0x40>
    return 0;
801075e7:	b8 00 00 00 00       	mov    $0x0,%eax
801075ec:	e9 90 01 00 00       	jmp    80107781 <create+0x1d0>
  ilock(dp);
801075f1:	83 ec 0c             	sub    $0xc,%esp
801075f4:	ff 75 f4             	pushl  -0xc(%ebp)
801075f7:	e8 1f a4 ff ff       	call   80101a1b <ilock>
801075fc:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801075ff:	83 ec 04             	sub    $0x4,%esp
80107602:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107605:	50                   	push   %eax
80107606:	8d 45 de             	lea    -0x22(%ebp),%eax
80107609:	50                   	push   %eax
8010760a:	ff 75 f4             	pushl  -0xc(%ebp)
8010760d:	e8 71 ac ff ff       	call   80102283 <dirlookup>
80107612:	83 c4 10             	add    $0x10,%esp
80107615:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107618:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010761c:	74 50                	je     8010766e <create+0xbd>
    iunlockput(dp);
8010761e:	83 ec 0c             	sub    $0xc,%esp
80107621:	ff 75 f4             	pushl  -0xc(%ebp)
80107624:	e8 b2 a6 ff ff       	call   80101cdb <iunlockput>
80107629:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010762c:	83 ec 0c             	sub    $0xc,%esp
8010762f:	ff 75 f0             	pushl  -0x10(%ebp)
80107632:	e8 e4 a3 ff ff       	call   80101a1b <ilock>
80107637:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
8010763a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010763f:	75 15                	jne    80107656 <create+0xa5>
80107641:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107644:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107648:	66 83 f8 02          	cmp    $0x2,%ax
8010764c:	75 08                	jne    80107656 <create+0xa5>
      return ip;
8010764e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107651:	e9 2b 01 00 00       	jmp    80107781 <create+0x1d0>
    iunlockput(ip);
80107656:	83 ec 0c             	sub    $0xc,%esp
80107659:	ff 75 f0             	pushl  -0x10(%ebp)
8010765c:	e8 7a a6 ff ff       	call   80101cdb <iunlockput>
80107661:	83 c4 10             	add    $0x10,%esp
    return 0;
80107664:	b8 00 00 00 00       	mov    $0x0,%eax
80107669:	e9 13 01 00 00       	jmp    80107781 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010766e:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80107672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107675:	8b 00                	mov    (%eax),%eax
80107677:	83 ec 08             	sub    $0x8,%esp
8010767a:	52                   	push   %edx
8010767b:	50                   	push   %eax
8010767c:	e8 e9 a0 ff ff       	call   8010176a <ialloc>
80107681:	83 c4 10             	add    $0x10,%esp
80107684:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107687:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010768b:	75 0d                	jne    8010769a <create+0xe9>
    panic("create: ialloc");
8010768d:	83 ec 0c             	sub    $0xc,%esp
80107690:	68 3a ab 10 80       	push   $0x8010ab3a
80107695:	e8 cc 8e ff ff       	call   80100566 <panic>

  ilock(ip);
8010769a:	83 ec 0c             	sub    $0xc,%esp
8010769d:	ff 75 f0             	pushl  -0x10(%ebp)
801076a0:	e8 76 a3 ff ff       	call   80101a1b <ilock>
801076a5:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801076a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076ab:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801076af:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801076b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076b6:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801076ba:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801076be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076c1:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801076c7:	83 ec 0c             	sub    $0xc,%esp
801076ca:	ff 75 f0             	pushl  -0x10(%ebp)
801076cd:	e8 6f a1 ff ff       	call   80101841 <iupdate>
801076d2:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801076d5:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801076da:	75 6a                	jne    80107746 <create+0x195>
    dp->nlink++;  // for ".."
801076dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076df:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801076e3:	83 c0 01             	add    $0x1,%eax
801076e6:	89 c2                	mov    %eax,%edx
801076e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076eb:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801076ef:	83 ec 0c             	sub    $0xc,%esp
801076f2:	ff 75 f4             	pushl  -0xc(%ebp)
801076f5:	e8 47 a1 ff ff       	call   80101841 <iupdate>
801076fa:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801076fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107700:	8b 40 04             	mov    0x4(%eax),%eax
80107703:	83 ec 04             	sub    $0x4,%esp
80107706:	50                   	push   %eax
80107707:	68 14 ab 10 80       	push   $0x8010ab14
8010770c:	ff 75 f0             	pushl  -0x10(%ebp)
8010770f:	e8 29 ac ff ff       	call   8010233d <dirlink>
80107714:	83 c4 10             	add    $0x10,%esp
80107717:	85 c0                	test   %eax,%eax
80107719:	78 1e                	js     80107739 <create+0x188>
8010771b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010771e:	8b 40 04             	mov    0x4(%eax),%eax
80107721:	83 ec 04             	sub    $0x4,%esp
80107724:	50                   	push   %eax
80107725:	68 16 ab 10 80       	push   $0x8010ab16
8010772a:	ff 75 f0             	pushl  -0x10(%ebp)
8010772d:	e8 0b ac ff ff       	call   8010233d <dirlink>
80107732:	83 c4 10             	add    $0x10,%esp
80107735:	85 c0                	test   %eax,%eax
80107737:	79 0d                	jns    80107746 <create+0x195>
      panic("create dots");
80107739:	83 ec 0c             	sub    $0xc,%esp
8010773c:	68 49 ab 10 80       	push   $0x8010ab49
80107741:	e8 20 8e ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80107746:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107749:	8b 40 04             	mov    0x4(%eax),%eax
8010774c:	83 ec 04             	sub    $0x4,%esp
8010774f:	50                   	push   %eax
80107750:	8d 45 de             	lea    -0x22(%ebp),%eax
80107753:	50                   	push   %eax
80107754:	ff 75 f4             	pushl  -0xc(%ebp)
80107757:	e8 e1 ab ff ff       	call   8010233d <dirlink>
8010775c:	83 c4 10             	add    $0x10,%esp
8010775f:	85 c0                	test   %eax,%eax
80107761:	79 0d                	jns    80107770 <create+0x1bf>
    panic("create: dirlink");
80107763:	83 ec 0c             	sub    $0xc,%esp
80107766:	68 55 ab 10 80       	push   $0x8010ab55
8010776b:	e8 f6 8d ff ff       	call   80100566 <panic>

  iunlockput(dp);
80107770:	83 ec 0c             	sub    $0xc,%esp
80107773:	ff 75 f4             	pushl  -0xc(%ebp)
80107776:	e8 60 a5 ff ff       	call   80101cdb <iunlockput>
8010777b:	83 c4 10             	add    $0x10,%esp

  return ip;
8010777e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107781:	c9                   	leave  
80107782:	c3                   	ret    

80107783 <sys_open>:

int
sys_open(void)
{
80107783:	55                   	push   %ebp
80107784:	89 e5                	mov    %esp,%ebp
80107786:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107789:	83 ec 08             	sub    $0x8,%esp
8010778c:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010778f:	50                   	push   %eax
80107790:	6a 00                	push   $0x0
80107792:	e8 eb f6 ff ff       	call   80106e82 <argstr>
80107797:	83 c4 10             	add    $0x10,%esp
8010779a:	85 c0                	test   %eax,%eax
8010779c:	78 15                	js     801077b3 <sys_open+0x30>
8010779e:	83 ec 08             	sub    $0x8,%esp
801077a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801077a4:	50                   	push   %eax
801077a5:	6a 01                	push   $0x1
801077a7:	e8 51 f6 ff ff       	call   80106dfd <argint>
801077ac:	83 c4 10             	add    $0x10,%esp
801077af:	85 c0                	test   %eax,%eax
801077b1:	79 0a                	jns    801077bd <sys_open+0x3a>
    return -1;
801077b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077b8:	e9 61 01 00 00       	jmp    8010791e <sys_open+0x19b>

  begin_op();
801077bd:	e8 3c be ff ff       	call   801035fe <begin_op>

  if(omode & O_CREATE){
801077c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077c5:	25 00 02 00 00       	and    $0x200,%eax
801077ca:	85 c0                	test   %eax,%eax
801077cc:	74 2a                	je     801077f8 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801077ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801077d1:	6a 00                	push   $0x0
801077d3:	6a 00                	push   $0x0
801077d5:	6a 02                	push   $0x2
801077d7:	50                   	push   %eax
801077d8:	e8 d4 fd ff ff       	call   801075b1 <create>
801077dd:	83 c4 10             	add    $0x10,%esp
801077e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801077e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801077e7:	75 75                	jne    8010785e <sys_open+0xdb>
      end_op();
801077e9:	e8 9c be ff ff       	call   8010368a <end_op>
      return -1;
801077ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077f3:	e9 26 01 00 00       	jmp    8010791e <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801077f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801077fb:	83 ec 0c             	sub    $0xc,%esp
801077fe:	50                   	push   %eax
801077ff:	e8 d5 ad ff ff       	call   801025d9 <namei>
80107804:	83 c4 10             	add    $0x10,%esp
80107807:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010780a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010780e:	75 0f                	jne    8010781f <sys_open+0x9c>
      end_op();
80107810:	e8 75 be ff ff       	call   8010368a <end_op>
      return -1;
80107815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010781a:	e9 ff 00 00 00       	jmp    8010791e <sys_open+0x19b>
    }
    ilock(ip);
8010781f:	83 ec 0c             	sub    $0xc,%esp
80107822:	ff 75 f4             	pushl  -0xc(%ebp)
80107825:	e8 f1 a1 ff ff       	call   80101a1b <ilock>
8010782a:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010782d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107830:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107834:	66 83 f8 01          	cmp    $0x1,%ax
80107838:	75 24                	jne    8010785e <sys_open+0xdb>
8010783a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010783d:	85 c0                	test   %eax,%eax
8010783f:	74 1d                	je     8010785e <sys_open+0xdb>
      iunlockput(ip);
80107841:	83 ec 0c             	sub    $0xc,%esp
80107844:	ff 75 f4             	pushl  -0xc(%ebp)
80107847:	e8 8f a4 ff ff       	call   80101cdb <iunlockput>
8010784c:	83 c4 10             	add    $0x10,%esp
      end_op();
8010784f:	e8 36 be ff ff       	call   8010368a <end_op>
      return -1;
80107854:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107859:	e9 c0 00 00 00       	jmp    8010791e <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010785e:	e8 e1 97 ff ff       	call   80101044 <filealloc>
80107863:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107866:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010786a:	74 17                	je     80107883 <sys_open+0x100>
8010786c:	83 ec 0c             	sub    $0xc,%esp
8010786f:	ff 75 f0             	pushl  -0x10(%ebp)
80107872:	e8 37 f7 ff ff       	call   80106fae <fdalloc>
80107877:	83 c4 10             	add    $0x10,%esp
8010787a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010787d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107881:	79 2e                	jns    801078b1 <sys_open+0x12e>
    if(f)
80107883:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107887:	74 0e                	je     80107897 <sys_open+0x114>
      fileclose(f);
80107889:	83 ec 0c             	sub    $0xc,%esp
8010788c:	ff 75 f0             	pushl  -0x10(%ebp)
8010788f:	e8 6e 98 ff ff       	call   80101102 <fileclose>
80107894:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107897:	83 ec 0c             	sub    $0xc,%esp
8010789a:	ff 75 f4             	pushl  -0xc(%ebp)
8010789d:	e8 39 a4 ff ff       	call   80101cdb <iunlockput>
801078a2:	83 c4 10             	add    $0x10,%esp
    end_op();
801078a5:	e8 e0 bd ff ff       	call   8010368a <end_op>
    return -1;
801078aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078af:	eb 6d                	jmp    8010791e <sys_open+0x19b>
  }
  iunlock(ip);
801078b1:	83 ec 0c             	sub    $0xc,%esp
801078b4:	ff 75 f4             	pushl  -0xc(%ebp)
801078b7:	e8 bd a2 ff ff       	call   80101b79 <iunlock>
801078bc:	83 c4 10             	add    $0x10,%esp
  end_op();
801078bf:	e8 c6 bd ff ff       	call   8010368a <end_op>

  f->type = FD_INODE;
801078c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078c7:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801078cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801078d3:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801078d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078d9:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801078e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078e3:	83 e0 01             	and    $0x1,%eax
801078e6:	85 c0                	test   %eax,%eax
801078e8:	0f 94 c0             	sete   %al
801078eb:	89 c2                	mov    %eax,%edx
801078ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078f0:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801078f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078f6:	83 e0 01             	and    $0x1,%eax
801078f9:	85 c0                	test   %eax,%eax
801078fb:	75 0a                	jne    80107907 <sys_open+0x184>
801078fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107900:	83 e0 02             	and    $0x2,%eax
80107903:	85 c0                	test   %eax,%eax
80107905:	74 07                	je     8010790e <sys_open+0x18b>
80107907:	b8 01 00 00 00       	mov    $0x1,%eax
8010790c:	eb 05                	jmp    80107913 <sys_open+0x190>
8010790e:	b8 00 00 00 00       	mov    $0x0,%eax
80107913:	89 c2                	mov    %eax,%edx
80107915:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107918:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010791b:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010791e:	c9                   	leave  
8010791f:	c3                   	ret    

80107920 <sys_mkdir>:

int
sys_mkdir(void)
{
80107920:	55                   	push   %ebp
80107921:	89 e5                	mov    %esp,%ebp
80107923:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107926:	e8 d3 bc ff ff       	call   801035fe <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010792b:	83 ec 08             	sub    $0x8,%esp
8010792e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107931:	50                   	push   %eax
80107932:	6a 00                	push   $0x0
80107934:	e8 49 f5 ff ff       	call   80106e82 <argstr>
80107939:	83 c4 10             	add    $0x10,%esp
8010793c:	85 c0                	test   %eax,%eax
8010793e:	78 1b                	js     8010795b <sys_mkdir+0x3b>
80107940:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107943:	6a 00                	push   $0x0
80107945:	6a 00                	push   $0x0
80107947:	6a 01                	push   $0x1
80107949:	50                   	push   %eax
8010794a:	e8 62 fc ff ff       	call   801075b1 <create>
8010794f:	83 c4 10             	add    $0x10,%esp
80107952:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107955:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107959:	75 0c                	jne    80107967 <sys_mkdir+0x47>
    end_op();
8010795b:	e8 2a bd ff ff       	call   8010368a <end_op>
    return -1;
80107960:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107965:	eb 18                	jmp    8010797f <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80107967:	83 ec 0c             	sub    $0xc,%esp
8010796a:	ff 75 f4             	pushl  -0xc(%ebp)
8010796d:	e8 69 a3 ff ff       	call   80101cdb <iunlockput>
80107972:	83 c4 10             	add    $0x10,%esp
  end_op();
80107975:	e8 10 bd ff ff       	call   8010368a <end_op>
  return 0;
8010797a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010797f:	c9                   	leave  
80107980:	c3                   	ret    

80107981 <sys_mknod>:

int
sys_mknod(void)
{
80107981:	55                   	push   %ebp
80107982:	89 e5                	mov    %esp,%ebp
80107984:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107987:	e8 72 bc ff ff       	call   801035fe <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010798c:	83 ec 08             	sub    $0x8,%esp
8010798f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107992:	50                   	push   %eax
80107993:	6a 00                	push   $0x0
80107995:	e8 e8 f4 ff ff       	call   80106e82 <argstr>
8010799a:	83 c4 10             	add    $0x10,%esp
8010799d:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801079a4:	78 4f                	js     801079f5 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801079a6:	83 ec 08             	sub    $0x8,%esp
801079a9:	8d 45 e8             	lea    -0x18(%ebp),%eax
801079ac:	50                   	push   %eax
801079ad:	6a 01                	push   $0x1
801079af:	e8 49 f4 ff ff       	call   80106dfd <argint>
801079b4:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801079b7:	85 c0                	test   %eax,%eax
801079b9:	78 3a                	js     801079f5 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801079bb:	83 ec 08             	sub    $0x8,%esp
801079be:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801079c1:	50                   	push   %eax
801079c2:	6a 02                	push   $0x2
801079c4:	e8 34 f4 ff ff       	call   80106dfd <argint>
801079c9:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801079cc:	85 c0                	test   %eax,%eax
801079ce:	78 25                	js     801079f5 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801079d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079d3:	0f bf c8             	movswl %ax,%ecx
801079d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801079d9:	0f bf d0             	movswl %ax,%edx
801079dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801079df:	51                   	push   %ecx
801079e0:	52                   	push   %edx
801079e1:	6a 03                	push   $0x3
801079e3:	50                   	push   %eax
801079e4:	e8 c8 fb ff ff       	call   801075b1 <create>
801079e9:	83 c4 10             	add    $0x10,%esp
801079ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
801079ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801079f3:	75 0c                	jne    80107a01 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801079f5:	e8 90 bc ff ff       	call   8010368a <end_op>
    return -1;
801079fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079ff:	eb 18                	jmp    80107a19 <sys_mknod+0x98>
  }
  iunlockput(ip);
80107a01:	83 ec 0c             	sub    $0xc,%esp
80107a04:	ff 75 f0             	pushl  -0x10(%ebp)
80107a07:	e8 cf a2 ff ff       	call   80101cdb <iunlockput>
80107a0c:	83 c4 10             	add    $0x10,%esp
  end_op();
80107a0f:	e8 76 bc ff ff       	call   8010368a <end_op>
  return 0;
80107a14:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107a19:	c9                   	leave  
80107a1a:	c3                   	ret    

80107a1b <sys_chdir>:

int
sys_chdir(void)
{
80107a1b:	55                   	push   %ebp
80107a1c:	89 e5                	mov    %esp,%ebp
80107a1e:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107a21:	e8 d8 bb ff ff       	call   801035fe <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107a26:	83 ec 08             	sub    $0x8,%esp
80107a29:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a2c:	50                   	push   %eax
80107a2d:	6a 00                	push   $0x0
80107a2f:	e8 4e f4 ff ff       	call   80106e82 <argstr>
80107a34:	83 c4 10             	add    $0x10,%esp
80107a37:	85 c0                	test   %eax,%eax
80107a39:	78 18                	js     80107a53 <sys_chdir+0x38>
80107a3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a3e:	83 ec 0c             	sub    $0xc,%esp
80107a41:	50                   	push   %eax
80107a42:	e8 92 ab ff ff       	call   801025d9 <namei>
80107a47:	83 c4 10             	add    $0x10,%esp
80107a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a51:	75 0c                	jne    80107a5f <sys_chdir+0x44>
    end_op();
80107a53:	e8 32 bc ff ff       	call   8010368a <end_op>
    return -1;
80107a58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a5d:	eb 6e                	jmp    80107acd <sys_chdir+0xb2>
  }
  ilock(ip);
80107a5f:	83 ec 0c             	sub    $0xc,%esp
80107a62:	ff 75 f4             	pushl  -0xc(%ebp)
80107a65:	e8 b1 9f ff ff       	call   80101a1b <ilock>
80107a6a:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a70:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107a74:	66 83 f8 01          	cmp    $0x1,%ax
80107a78:	74 1a                	je     80107a94 <sys_chdir+0x79>
    iunlockput(ip);
80107a7a:	83 ec 0c             	sub    $0xc,%esp
80107a7d:	ff 75 f4             	pushl  -0xc(%ebp)
80107a80:	e8 56 a2 ff ff       	call   80101cdb <iunlockput>
80107a85:	83 c4 10             	add    $0x10,%esp
    end_op();
80107a88:	e8 fd bb ff ff       	call   8010368a <end_op>
    return -1;
80107a8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a92:	eb 39                	jmp    80107acd <sys_chdir+0xb2>
  }
  iunlock(ip);
80107a94:	83 ec 0c             	sub    $0xc,%esp
80107a97:	ff 75 f4             	pushl  -0xc(%ebp)
80107a9a:	e8 da a0 ff ff       	call   80101b79 <iunlock>
80107a9f:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107aa2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107aa8:	8b 40 68             	mov    0x68(%eax),%eax
80107aab:	83 ec 0c             	sub    $0xc,%esp
80107aae:	50                   	push   %eax
80107aaf:	e8 37 a1 ff ff       	call   80101beb <iput>
80107ab4:	83 c4 10             	add    $0x10,%esp
  end_op();
80107ab7:	e8 ce bb ff ff       	call   8010368a <end_op>
  proc->cwd = ip;
80107abc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ac2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107ac5:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107ac8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107acd:	c9                   	leave  
80107ace:	c3                   	ret    

80107acf <sys_exec>:

int
sys_exec(void)
{
80107acf:	55                   	push   %ebp
80107ad0:	89 e5                	mov    %esp,%ebp
80107ad2:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107ad8:	83 ec 08             	sub    $0x8,%esp
80107adb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107ade:	50                   	push   %eax
80107adf:	6a 00                	push   $0x0
80107ae1:	e8 9c f3 ff ff       	call   80106e82 <argstr>
80107ae6:	83 c4 10             	add    $0x10,%esp
80107ae9:	85 c0                	test   %eax,%eax
80107aeb:	78 18                	js     80107b05 <sys_exec+0x36>
80107aed:	83 ec 08             	sub    $0x8,%esp
80107af0:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107af6:	50                   	push   %eax
80107af7:	6a 01                	push   $0x1
80107af9:	e8 ff f2 ff ff       	call   80106dfd <argint>
80107afe:	83 c4 10             	add    $0x10,%esp
80107b01:	85 c0                	test   %eax,%eax
80107b03:	79 0a                	jns    80107b0f <sys_exec+0x40>
    return -1;
80107b05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b0a:	e9 c6 00 00 00       	jmp    80107bd5 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80107b0f:	83 ec 04             	sub    $0x4,%esp
80107b12:	68 80 00 00 00       	push   $0x80
80107b17:	6a 00                	push   $0x0
80107b19:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107b1f:	50                   	push   %eax
80107b20:	e8 b3 ef ff ff       	call   80106ad8 <memset>
80107b25:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80107b28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b32:	83 f8 1f             	cmp    $0x1f,%eax
80107b35:	76 0a                	jbe    80107b41 <sys_exec+0x72>
      return -1;
80107b37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b3c:	e9 94 00 00 00       	jmp    80107bd5 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b44:	c1 e0 02             	shl    $0x2,%eax
80107b47:	89 c2                	mov    %eax,%edx
80107b49:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107b4f:	01 c2                	add    %eax,%edx
80107b51:	83 ec 08             	sub    $0x8,%esp
80107b54:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107b5a:	50                   	push   %eax
80107b5b:	52                   	push   %edx
80107b5c:	e8 00 f2 ff ff       	call   80106d61 <fetchint>
80107b61:	83 c4 10             	add    $0x10,%esp
80107b64:	85 c0                	test   %eax,%eax
80107b66:	79 07                	jns    80107b6f <sys_exec+0xa0>
      return -1;
80107b68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b6d:	eb 66                	jmp    80107bd5 <sys_exec+0x106>
    if(uarg == 0){
80107b6f:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107b75:	85 c0                	test   %eax,%eax
80107b77:	75 27                	jne    80107ba0 <sys_exec+0xd1>
      argv[i] = 0;
80107b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b7c:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107b83:	00 00 00 00 
      break;
80107b87:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b8b:	83 ec 08             	sub    $0x8,%esp
80107b8e:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107b94:	52                   	push   %edx
80107b95:	50                   	push   %eax
80107b96:	e8 87 90 ff ff       	call   80100c22 <exec>
80107b9b:	83 c4 10             	add    $0x10,%esp
80107b9e:	eb 35                	jmp    80107bd5 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107ba0:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107ba6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107ba9:	c1 e2 02             	shl    $0x2,%edx
80107bac:	01 c2                	add    %eax,%edx
80107bae:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107bb4:	83 ec 08             	sub    $0x8,%esp
80107bb7:	52                   	push   %edx
80107bb8:	50                   	push   %eax
80107bb9:	e8 dd f1 ff ff       	call   80106d9b <fetchstr>
80107bbe:	83 c4 10             	add    $0x10,%esp
80107bc1:	85 c0                	test   %eax,%eax
80107bc3:	79 07                	jns    80107bcc <sys_exec+0xfd>
      return -1;
80107bc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bca:	eb 09                	jmp    80107bd5 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107bcc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80107bd0:	e9 5a ff ff ff       	jmp    80107b2f <sys_exec+0x60>
  return exec(path, argv);
}
80107bd5:	c9                   	leave  
80107bd6:	c3                   	ret    

80107bd7 <sys_pipe>:

int
sys_pipe(void)
{
80107bd7:	55                   	push   %ebp
80107bd8:	89 e5                	mov    %esp,%ebp
80107bda:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107bdd:	83 ec 04             	sub    $0x4,%esp
80107be0:	6a 08                	push   $0x8
80107be2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107be5:	50                   	push   %eax
80107be6:	6a 00                	push   $0x0
80107be8:	e8 38 f2 ff ff       	call   80106e25 <argptr>
80107bed:	83 c4 10             	add    $0x10,%esp
80107bf0:	85 c0                	test   %eax,%eax
80107bf2:	79 0a                	jns    80107bfe <sys_pipe+0x27>
    return -1;
80107bf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bf9:	e9 af 00 00 00       	jmp    80107cad <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107bfe:	83 ec 08             	sub    $0x8,%esp
80107c01:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107c04:	50                   	push   %eax
80107c05:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107c08:	50                   	push   %eax
80107c09:	e8 e4 c4 ff ff       	call   801040f2 <pipealloc>
80107c0e:	83 c4 10             	add    $0x10,%esp
80107c11:	85 c0                	test   %eax,%eax
80107c13:	79 0a                	jns    80107c1f <sys_pipe+0x48>
    return -1;
80107c15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c1a:	e9 8e 00 00 00       	jmp    80107cad <sys_pipe+0xd6>
  fd0 = -1;
80107c1f:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107c26:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c29:	83 ec 0c             	sub    $0xc,%esp
80107c2c:	50                   	push   %eax
80107c2d:	e8 7c f3 ff ff       	call   80106fae <fdalloc>
80107c32:	83 c4 10             	add    $0x10,%esp
80107c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c3c:	78 18                	js     80107c56 <sys_pipe+0x7f>
80107c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c41:	83 ec 0c             	sub    $0xc,%esp
80107c44:	50                   	push   %eax
80107c45:	e8 64 f3 ff ff       	call   80106fae <fdalloc>
80107c4a:	83 c4 10             	add    $0x10,%esp
80107c4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c54:	79 3f                	jns    80107c95 <sys_pipe+0xbe>
    if(fd0 >= 0)
80107c56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c5a:	78 14                	js     80107c70 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107c5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c65:	83 c2 08             	add    $0x8,%edx
80107c68:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107c6f:	00 
    fileclose(rf);
80107c70:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c73:	83 ec 0c             	sub    $0xc,%esp
80107c76:	50                   	push   %eax
80107c77:	e8 86 94 ff ff       	call   80101102 <fileclose>
80107c7c:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107c7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c82:	83 ec 0c             	sub    $0xc,%esp
80107c85:	50                   	push   %eax
80107c86:	e8 77 94 ff ff       	call   80101102 <fileclose>
80107c8b:	83 c4 10             	add    $0x10,%esp
    return -1;
80107c8e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c93:	eb 18                	jmp    80107cad <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107c95:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c98:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c9b:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107c9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ca0:	8d 50 04             	lea    0x4(%eax),%edx
80107ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ca6:	89 02                	mov    %eax,(%edx)
  return 0;
80107ca8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107cad:	c9                   	leave  
80107cae:	c3                   	ret    

80107caf <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107caf:	55                   	push   %ebp
80107cb0:	89 e5                	mov    %esp,%ebp
80107cb2:	83 ec 08             	sub    $0x8,%esp
80107cb5:	8b 55 08             	mov    0x8(%ebp),%edx
80107cb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cbb:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107cbf:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107cc3:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107cc7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107ccb:	66 ef                	out    %ax,(%dx)
}
80107ccd:	90                   	nop
80107cce:	c9                   	leave  
80107ccf:	c3                   	ret    

80107cd0 <sys_fork>:
#include "uproc.h"
#endif

int
sys_fork(void)
{
80107cd0:	55                   	push   %ebp
80107cd1:	89 e5                	mov    %esp,%ebp
80107cd3:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107cd6:	e8 07 cd ff ff       	call   801049e2 <fork>
}
80107cdb:	c9                   	leave  
80107cdc:	c3                   	ret    

80107cdd <sys_exit>:

int
sys_exit(void)
{
80107cdd:	55                   	push   %ebp
80107cde:	89 e5                	mov    %esp,%ebp
80107ce0:	83 ec 08             	sub    $0x8,%esp
  exit();
80107ce3:	e8 84 cf ff ff       	call   80104c6c <exit>
  return 0;  // not reached
80107ce8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ced:	c9                   	leave  
80107cee:	c3                   	ret    

80107cef <sys_wait>:

int
sys_wait(void)
{
80107cef:	55                   	push   %ebp
80107cf0:	89 e5                	mov    %esp,%ebp
80107cf2:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107cf5:	e8 44 d2 ff ff       	call   80104f3e <wait>
}
80107cfa:	c9                   	leave  
80107cfb:	c3                   	ret    

80107cfc <sys_kill>:

int
sys_kill(void)
{
80107cfc:	55                   	push   %ebp
80107cfd:	89 e5                	mov    %esp,%ebp
80107cff:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107d02:	83 ec 08             	sub    $0x8,%esp
80107d05:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107d08:	50                   	push   %eax
80107d09:	6a 00                	push   $0x0
80107d0b:	e8 ed f0 ff ff       	call   80106dfd <argint>
80107d10:	83 c4 10             	add    $0x10,%esp
80107d13:	85 c0                	test   %eax,%eax
80107d15:	79 07                	jns    80107d1e <sys_kill+0x22>
    return -1;
80107d17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d1c:	eb 0f                	jmp    80107d2d <sys_kill+0x31>
  return kill(pid);
80107d1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d21:	83 ec 0c             	sub    $0xc,%esp
80107d24:	50                   	push   %eax
80107d25:	e8 f4 da ff ff       	call   8010581e <kill>
80107d2a:	83 c4 10             	add    $0x10,%esp
}
80107d2d:	c9                   	leave  
80107d2e:	c3                   	ret    

80107d2f <sys_getpid>:

int
sys_getpid(void)
{
80107d2f:	55                   	push   %ebp
80107d30:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107d32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d38:	8b 40 10             	mov    0x10(%eax),%eax
}
80107d3b:	5d                   	pop    %ebp
80107d3c:	c3                   	ret    

80107d3d <sys_sbrk>:

int
sys_sbrk(void)
{
80107d3d:	55                   	push   %ebp
80107d3e:	89 e5                	mov    %esp,%ebp
80107d40:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107d43:	83 ec 08             	sub    $0x8,%esp
80107d46:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d49:	50                   	push   %eax
80107d4a:	6a 00                	push   $0x0
80107d4c:	e8 ac f0 ff ff       	call   80106dfd <argint>
80107d51:	83 c4 10             	add    $0x10,%esp
80107d54:	85 c0                	test   %eax,%eax
80107d56:	79 07                	jns    80107d5f <sys_sbrk+0x22>
    return -1;
80107d58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d5d:	eb 28                	jmp    80107d87 <sys_sbrk+0x4a>
  addr = proc->sz;
80107d5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d65:	8b 00                	mov    (%eax),%eax
80107d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107d6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d6d:	83 ec 0c             	sub    $0xc,%esp
80107d70:	50                   	push   %eax
80107d71:	e8 c9 cb ff ff       	call   8010493f <growproc>
80107d76:	83 c4 10             	add    $0x10,%esp
80107d79:	85 c0                	test   %eax,%eax
80107d7b:	79 07                	jns    80107d84 <sys_sbrk+0x47>
    return -1;
80107d7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d82:	eb 03                	jmp    80107d87 <sys_sbrk+0x4a>
  return addr;
80107d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107d87:	c9                   	leave  
80107d88:	c3                   	ret    

80107d89 <sys_sleep>:

int
sys_sleep(void)
{
80107d89:	55                   	push   %ebp
80107d8a:	89 e5                	mov    %esp,%ebp
80107d8c:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107d8f:	83 ec 08             	sub    $0x8,%esp
80107d92:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d95:	50                   	push   %eax
80107d96:	6a 00                	push   $0x0
80107d98:	e8 60 f0 ff ff       	call   80106dfd <argint>
80107d9d:	83 c4 10             	add    $0x10,%esp
80107da0:	85 c0                	test   %eax,%eax
80107da2:	79 07                	jns    80107dab <sys_sleep+0x22>
    return -1;
80107da4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107da9:	eb 44                	jmp    80107def <sys_sleep+0x66>
  ticks0 = ticks;
80107dab:	a1 e0 78 11 80       	mov    0x801178e0,%eax
80107db0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80107db3:	eb 26                	jmp    80107ddb <sys_sleep+0x52>
    if(proc->killed){
80107db5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107dbb:	8b 40 24             	mov    0x24(%eax),%eax
80107dbe:	85 c0                	test   %eax,%eax
80107dc0:	74 07                	je     80107dc9 <sys_sleep+0x40>
      return -1;
80107dc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107dc7:	eb 26                	jmp    80107def <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107dc9:	83 ec 08             	sub    $0x8,%esp
80107dcc:	6a 00                	push   $0x0
80107dce:	68 e0 78 11 80       	push   $0x801178e0
80107dd3:	e8 b4 d7 ff ff       	call   8010558c <sleep>
80107dd8:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107ddb:	a1 e0 78 11 80       	mov    0x801178e0,%eax
80107de0:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107de3:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107de6:	39 d0                	cmp    %edx,%eax
80107de8:	72 cb                	jb     80107db5 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107def:	c9                   	leave  
80107df0:	c3                   	ret    

80107df1 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80107df1:	55                   	push   %ebp
80107df2:	89 e5                	mov    %esp,%ebp
80107df4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107df7:	a1 e0 78 11 80       	mov    0x801178e0,%eax
80107dfc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80107dff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107e02:	c9                   	leave  
80107e03:	c3                   	ret    

80107e04 <sys_halt>:

//Turn of the computer
int
sys_halt(void){
80107e04:	55                   	push   %ebp
80107e05:	89 e5                	mov    %esp,%ebp
80107e07:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107e0a:	83 ec 0c             	sub    $0xc,%esp
80107e0d:	68 65 ab 10 80       	push   $0x8010ab65
80107e12:	e8 af 85 ff ff       	call   801003c6 <cprintf>
80107e17:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
80107e1a:	83 ec 08             	sub    $0x8,%esp
80107e1d:	68 00 20 00 00       	push   $0x2000
80107e22:	68 04 06 00 00       	push   $0x604
80107e27:	e8 83 fe ff ff       	call   80107caf <outw>
80107e2c:	83 c4 10             	add    $0x10,%esp
  return 0;
80107e2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e34:	c9                   	leave  
80107e35:	c3                   	ret    

80107e36 <sys_date>:

#ifdef CS333_P1
int
sys_date(void) {
80107e36:	55                   	push   %ebp
80107e37:	89 e5                	mov    %esp,%ebp
80107e39:	83 ec 18             	sub    $0x18,%esp
    struct rtcdate *d;
    if (argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0) {
80107e3c:	83 ec 04             	sub    $0x4,%esp
80107e3f:	6a 18                	push   $0x18
80107e41:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107e44:	50                   	push   %eax
80107e45:	6a 00                	push   $0x0
80107e47:	e8 d9 ef ff ff       	call   80106e25 <argptr>
80107e4c:	83 c4 10             	add    $0x10,%esp
80107e4f:	85 c0                	test   %eax,%eax
80107e51:	79 07                	jns    80107e5a <sys_date+0x24>
        return -1;
80107e53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e58:	eb 14                	jmp    80107e6e <sys_date+0x38>
    } else {
        cmostime(d);
80107e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5d:	83 ec 0c             	sub    $0xc,%esp
80107e60:	50                   	push   %eax
80107e61:	e8 13 b4 ff ff       	call   80103279 <cmostime>
80107e66:	83 c4 10             	add    $0x10,%esp
        return 0;
80107e69:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
80107e6e:	c9                   	leave  
80107e6f:	c3                   	ret    

80107e70 <sys_getuid>:

#ifdef CS333_P2

// return process UID
int
sys_getuid(void) {
80107e70:	55                   	push   %ebp
80107e71:	89 e5                	mov    %esp,%ebp
    return proc->uid;
80107e73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e79:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80107e7f:	5d                   	pop    %ebp
80107e80:	c3                   	ret    

80107e81 <sys_getgid>:

// return process GID
int
sys_getgid(void) {
80107e81:	55                   	push   %ebp
80107e82:	89 e5                	mov    %esp,%ebp
    return proc->gid;
80107e84:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e8a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80107e90:	5d                   	pop    %ebp
80107e91:	c3                   	ret    

80107e92 <sys_getppid>:

// return process parent's PID
int
sys_getppid(void) {
80107e92:	55                   	push   %ebp
80107e93:	89 e5                	mov    %esp,%ebp
    return proc->parent->pid;
80107e95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e9b:	8b 40 14             	mov    0x14(%eax),%eax
80107e9e:	8b 40 10             	mov    0x10(%eax),%eax
}
80107ea1:	5d                   	pop    %ebp
80107ea2:	c3                   	ret    

80107ea3 <sys_setuid>:

// pull argument from stack, check range, set process UID
int
sys_setuid(void) {
80107ea3:	55                   	push   %ebp
80107ea4:	89 e5                	mov    %esp,%ebp
80107ea6:	83 ec 18             	sub    $0x18,%esp
    int n;
    if (argint(0, &n) < 0) {
80107ea9:	83 ec 08             	sub    $0x8,%esp
80107eac:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107eaf:	50                   	push   %eax
80107eb0:	6a 00                	push   $0x0
80107eb2:	e8 46 ef ff ff       	call   80106dfd <argint>
80107eb7:	83 c4 10             	add    $0x10,%esp
80107eba:	85 c0                	test   %eax,%eax
80107ebc:	79 07                	jns    80107ec5 <sys_setuid+0x22>
        return -1;
80107ebe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ec3:	eb 2c                	jmp    80107ef1 <sys_setuid+0x4e>
    }
    if (n < 0 || n > 32767) {
80107ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ec8:	85 c0                	test   %eax,%eax
80107eca:	78 0a                	js     80107ed6 <sys_setuid+0x33>
80107ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ecf:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107ed4:	7e 07                	jle    80107edd <sys_setuid+0x3a>
        return -1;
80107ed6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107edb:	eb 14                	jmp    80107ef1 <sys_setuid+0x4e>
    }
    proc->uid = n;
80107edd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ee3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107ee6:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    return 0;
80107eec:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ef1:	c9                   	leave  
80107ef2:	c3                   	ret    

80107ef3 <sys_setgid>:

// pull argument from stack, check range, set process PID
int
sys_setgid(void) {
80107ef3:	55                   	push   %ebp
80107ef4:	89 e5                	mov    %esp,%ebp
80107ef6:	83 ec 18             	sub    $0x18,%esp
    int n;
    if (argint(0, &n) < 0) {
80107ef9:	83 ec 08             	sub    $0x8,%esp
80107efc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107eff:	50                   	push   %eax
80107f00:	6a 00                	push   $0x0
80107f02:	e8 f6 ee ff ff       	call   80106dfd <argint>
80107f07:	83 c4 10             	add    $0x10,%esp
80107f0a:	85 c0                	test   %eax,%eax
80107f0c:	79 07                	jns    80107f15 <sys_setgid+0x22>
        return -1;
80107f0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f13:	eb 2c                	jmp    80107f41 <sys_setgid+0x4e>
    }
    if (n < 0 || n > 32767) {
80107f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f18:	85 c0                	test   %eax,%eax
80107f1a:	78 0a                	js     80107f26 <sys_setgid+0x33>
80107f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f1f:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107f24:	7e 07                	jle    80107f2d <sys_setgid+0x3a>
        return -1;
80107f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f2b:	eb 14                	jmp    80107f41 <sys_setgid+0x4e>
    }
    proc->gid = n;
80107f2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f33:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107f36:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    return 0;
80107f3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f41:	c9                   	leave  
80107f42:	c3                   	ret    

80107f43 <sys_getprocs>:

// pull arguments from stack, pass to proc.c getprocs(uint, struct)
int
sys_getprocs(void) {
80107f43:	55                   	push   %ebp
80107f44:	89 e5                	mov    %esp,%ebp
80107f46:	83 ec 18             	sub    $0x18,%esp
    int m;
    struct uproc *u;
    if (argint(0, &m) < 0) {
80107f49:	83 ec 08             	sub    $0x8,%esp
80107f4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f4f:	50                   	push   %eax
80107f50:	6a 00                	push   $0x0
80107f52:	e8 a6 ee ff ff       	call   80106dfd <argint>
80107f57:	83 c4 10             	add    $0x10,%esp
80107f5a:	85 c0                	test   %eax,%eax
80107f5c:	79 07                	jns    80107f65 <sys_getprocs+0x22>
        return -1;
80107f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f63:	eb 3e                	jmp    80107fa3 <sys_getprocs+0x60>
    }
    // sizeof * MAX
    if (argptr(1, (void*)&u, (sizeof(struct uproc) * m)) < 0) {
80107f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f68:	89 c2                	mov    %eax,%edx
80107f6a:	89 d0                	mov    %edx,%eax
80107f6c:	01 c0                	add    %eax,%eax
80107f6e:	01 d0                	add    %edx,%eax
80107f70:	c1 e0 05             	shl    $0x5,%eax
80107f73:	83 ec 04             	sub    $0x4,%esp
80107f76:	50                   	push   %eax
80107f77:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107f7a:	50                   	push   %eax
80107f7b:	6a 01                	push   $0x1
80107f7d:	e8 a3 ee ff ff       	call   80106e25 <argptr>
80107f82:	83 c4 10             	add    $0x10,%esp
80107f85:	85 c0                	test   %eax,%eax
80107f87:	79 07                	jns    80107f90 <sys_getprocs+0x4d>
        return -1;
80107f89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f8e:	eb 13                	jmp    80107fa3 <sys_getprocs+0x60>
    }
    return getprocs(m, u);
80107f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f93:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107f96:	83 ec 08             	sub    $0x8,%esp
80107f99:	50                   	push   %eax
80107f9a:	52                   	push   %edx
80107f9b:	e8 a0 dd ff ff       	call   80105d40 <getprocs>
80107fa0:	83 c4 10             	add    $0x10,%esp
}
80107fa3:	c9                   	leave  
80107fa4:	c3                   	ret    

80107fa5 <sys_setpriority>:
#endif

#ifdef CS333_P3P4
int
sys_setpriority(void) {
80107fa5:	55                   	push   %ebp
80107fa6:	89 e5                	mov    %esp,%ebp
80107fa8:	83 ec 18             	sub    $0x18,%esp
    int n, m;
    // PID argument from stack
    if (argint(0, &n) < 0) {
80107fab:	83 ec 08             	sub    $0x8,%esp
80107fae:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107fb1:	50                   	push   %eax
80107fb2:	6a 00                	push   $0x0
80107fb4:	e8 44 ee ff ff       	call   80106dfd <argint>
80107fb9:	83 c4 10             	add    $0x10,%esp
80107fbc:	85 c0                	test   %eax,%eax
80107fbe:	79 07                	jns    80107fc7 <sys_setpriority+0x22>
        return -1;
80107fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fc5:	eb 5d                	jmp    80108024 <sys_setpriority+0x7f>
    }
    // priority argument
    if (argint(0, &m) < 0) {
80107fc7:	83 ec 08             	sub    $0x8,%esp
80107fca:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107fcd:	50                   	push   %eax
80107fce:	6a 00                	push   $0x0
80107fd0:	e8 28 ee ff ff       	call   80106dfd <argint>
80107fd5:	83 c4 10             	add    $0x10,%esp
80107fd8:	85 c0                	test   %eax,%eax
80107fda:	79 07                	jns    80107fe3 <sys_setpriority+0x3e>
        return -1;
80107fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fe1:	eb 41                	jmp    80108024 <sys_setpriority+0x7f>
    }
    // check bounds of PID argument
    if (n < 0 || n > 32767) {
80107fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe6:	85 c0                	test   %eax,%eax
80107fe8:	78 0a                	js     80107ff4 <sys_setpriority+0x4f>
80107fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fed:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107ff2:	7e 07                	jle    80107ffb <sys_setpriority+0x56>
        return -1;
80107ff4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ff9:	eb 29                	jmp    80108024 <sys_setpriority+0x7f>
    }
    // check bounds of priority argument
    if (m < 0 || m > MAX) {
80107ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ffe:	85 c0                	test   %eax,%eax
80108000:	78 08                	js     8010800a <sys_setpriority+0x65>
80108002:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108005:	83 f8 03             	cmp    $0x3,%eax
80108008:	7e 07                	jle    80108011 <sys_setpriority+0x6c>
        return -1;
8010800a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010800f:	eb 13                	jmp    80108024 <sys_setpriority+0x7f>
    }
    return setpriority(n, m); // pass to user-side
80108011:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108017:	83 ec 08             	sub    $0x8,%esp
8010801a:	52                   	push   %edx
8010801b:	50                   	push   %eax
8010801c:	e8 cd e5 ff ff       	call   801065ee <setpriority>
80108021:	83 c4 10             	add    $0x10,%esp
}
80108024:	c9                   	leave  
80108025:	c3                   	ret    

80108026 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80108026:	55                   	push   %ebp
80108027:	89 e5                	mov    %esp,%ebp
80108029:	83 ec 08             	sub    $0x8,%esp
8010802c:	8b 55 08             	mov    0x8(%ebp),%edx
8010802f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108032:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80108036:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108039:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010803d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108041:	ee                   	out    %al,(%dx)
}
80108042:	90                   	nop
80108043:	c9                   	leave  
80108044:	c3                   	ret    

80108045 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80108045:	55                   	push   %ebp
80108046:	89 e5                	mov    %esp,%ebp
80108048:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
8010804b:	6a 34                	push   $0x34
8010804d:	6a 43                	push   $0x43
8010804f:	e8 d2 ff ff ff       	call   80108026 <outb>
80108054:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
80108057:	68 a9 00 00 00       	push   $0xa9
8010805c:	6a 40                	push   $0x40
8010805e:	e8 c3 ff ff ff       	call   80108026 <outb>
80108063:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
80108066:	6a 04                	push   $0x4
80108068:	6a 40                	push   $0x40
8010806a:	e8 b7 ff ff ff       	call   80108026 <outb>
8010806f:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80108072:	83 ec 0c             	sub    $0xc,%esp
80108075:	6a 00                	push   $0x0
80108077:	e8 60 bf ff ff       	call   80103fdc <picenable>
8010807c:	83 c4 10             	add    $0x10,%esp
}
8010807f:	90                   	nop
80108080:	c9                   	leave  
80108081:	c3                   	ret    

80108082 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80108082:	1e                   	push   %ds
  pushl %es
80108083:	06                   	push   %es
  pushl %fs
80108084:	0f a0                	push   %fs
  pushl %gs
80108086:	0f a8                	push   %gs
  pushal
80108088:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80108089:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010808d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010808f:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80108091:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80108095:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80108097:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80108099:	54                   	push   %esp
  call trap
8010809a:	e8 ce 01 00 00       	call   8010826d <trap>
  addl $4, %esp
8010809f:	83 c4 04             	add    $0x4,%esp

801080a2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801080a2:	61                   	popa   
  popl %gs
801080a3:	0f a9                	pop    %gs
  popl %fs
801080a5:	0f a1                	pop    %fs
  popl %es
801080a7:	07                   	pop    %es
  popl %ds
801080a8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801080a9:	83 c4 08             	add    $0x8,%esp
  iret
801080ac:	cf                   	iret   

801080ad <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
801080ad:	55                   	push   %ebp
801080ae:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
801080b0:	8b 45 08             	mov    0x8(%ebp),%eax
801080b3:	f0 ff 00             	lock incl (%eax)
}
801080b6:	90                   	nop
801080b7:	5d                   	pop    %ebp
801080b8:	c3                   	ret    

801080b9 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801080b9:	55                   	push   %ebp
801080ba:	89 e5                	mov    %esp,%ebp
801080bc:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801080bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801080c2:	83 e8 01             	sub    $0x1,%eax
801080c5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801080c9:	8b 45 08             	mov    0x8(%ebp),%eax
801080cc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801080d0:	8b 45 08             	mov    0x8(%ebp),%eax
801080d3:	c1 e8 10             	shr    $0x10,%eax
801080d6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801080da:	8d 45 fa             	lea    -0x6(%ebp),%eax
801080dd:	0f 01 18             	lidtl  (%eax)
}
801080e0:	90                   	nop
801080e1:	c9                   	leave  
801080e2:	c3                   	ret    

801080e3 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801080e3:	55                   	push   %ebp
801080e4:	89 e5                	mov    %esp,%ebp
801080e6:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801080e9:	0f 20 d0             	mov    %cr2,%eax
801080ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801080ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801080f2:	c9                   	leave  
801080f3:	c3                   	ret    

801080f4 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
801080f4:	55                   	push   %ebp
801080f5:	89 e5                	mov    %esp,%ebp
801080f7:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
801080fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80108101:	e9 c3 00 00 00       	jmp    801081c9 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80108106:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108109:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
80108110:	89 c2                	mov    %eax,%edx
80108112:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108115:	66 89 14 c5 e0 70 11 	mov    %dx,-0x7fee8f20(,%eax,8)
8010811c:	80 
8010811d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108120:	66 c7 04 c5 e2 70 11 	movw   $0x8,-0x7fee8f1e(,%eax,8)
80108127:	80 08 00 
8010812a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010812d:	0f b6 14 c5 e4 70 11 	movzbl -0x7fee8f1c(,%eax,8),%edx
80108134:	80 
80108135:	83 e2 e0             	and    $0xffffffe0,%edx
80108138:	88 14 c5 e4 70 11 80 	mov    %dl,-0x7fee8f1c(,%eax,8)
8010813f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108142:	0f b6 14 c5 e4 70 11 	movzbl -0x7fee8f1c(,%eax,8),%edx
80108149:	80 
8010814a:	83 e2 1f             	and    $0x1f,%edx
8010814d:	88 14 c5 e4 70 11 80 	mov    %dl,-0x7fee8f1c(,%eax,8)
80108154:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108157:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
8010815e:	80 
8010815f:	83 e2 f0             	and    $0xfffffff0,%edx
80108162:	83 ca 0e             	or     $0xe,%edx
80108165:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
8010816c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010816f:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80108176:	80 
80108177:	83 e2 ef             	and    $0xffffffef,%edx
8010817a:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80108181:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108184:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
8010818b:	80 
8010818c:	83 e2 9f             	and    $0xffffff9f,%edx
8010818f:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80108196:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108199:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
801081a0:	80 
801081a1:	83 ca 80             	or     $0xffffff80,%edx
801081a4:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
801081ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
801081ae:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
801081b5:	c1 e8 10             	shr    $0x10,%eax
801081b8:	89 c2                	mov    %eax,%edx
801081ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
801081bd:	66 89 14 c5 e6 70 11 	mov    %dx,-0x7fee8f1a(,%eax,8)
801081c4:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801081c5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801081c9:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
801081d0:	0f 8e 30 ff ff ff    	jle    80108106 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801081d6:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
801081db:	66 a3 e0 72 11 80    	mov    %ax,0x801172e0
801081e1:	66 c7 05 e2 72 11 80 	movw   $0x8,0x801172e2
801081e8:	08 00 
801081ea:	0f b6 05 e4 72 11 80 	movzbl 0x801172e4,%eax
801081f1:	83 e0 e0             	and    $0xffffffe0,%eax
801081f4:	a2 e4 72 11 80       	mov    %al,0x801172e4
801081f9:	0f b6 05 e4 72 11 80 	movzbl 0x801172e4,%eax
80108200:	83 e0 1f             	and    $0x1f,%eax
80108203:	a2 e4 72 11 80       	mov    %al,0x801172e4
80108208:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
8010820f:	83 c8 0f             	or     $0xf,%eax
80108212:	a2 e5 72 11 80       	mov    %al,0x801172e5
80108217:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
8010821e:	83 e0 ef             	and    $0xffffffef,%eax
80108221:	a2 e5 72 11 80       	mov    %al,0x801172e5
80108226:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
8010822d:	83 c8 60             	or     $0x60,%eax
80108230:	a2 e5 72 11 80       	mov    %al,0x801172e5
80108235:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
8010823c:	83 c8 80             	or     $0xffffff80,%eax
8010823f:	a2 e5 72 11 80       	mov    %al,0x801172e5
80108244:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80108249:	c1 e8 10             	shr    $0x10,%eax
8010824c:	66 a3 e6 72 11 80    	mov    %ax,0x801172e6
  
}
80108252:	90                   	nop
80108253:	c9                   	leave  
80108254:	c3                   	ret    

80108255 <idtinit>:

void
idtinit(void)
{
80108255:	55                   	push   %ebp
80108256:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80108258:	68 00 08 00 00       	push   $0x800
8010825d:	68 e0 70 11 80       	push   $0x801170e0
80108262:	e8 52 fe ff ff       	call   801080b9 <lidt>
80108267:	83 c4 08             	add    $0x8,%esp
}
8010826a:	90                   	nop
8010826b:	c9                   	leave  
8010826c:	c3                   	ret    

8010826d <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010826d:	55                   	push   %ebp
8010826e:	89 e5                	mov    %esp,%ebp
80108270:	57                   	push   %edi
80108271:	56                   	push   %esi
80108272:	53                   	push   %ebx
80108273:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80108276:	8b 45 08             	mov    0x8(%ebp),%eax
80108279:	8b 40 30             	mov    0x30(%eax),%eax
8010827c:	83 f8 40             	cmp    $0x40,%eax
8010827f:	75 3e                	jne    801082bf <trap+0x52>
    if(proc->killed)
80108281:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108287:	8b 40 24             	mov    0x24(%eax),%eax
8010828a:	85 c0                	test   %eax,%eax
8010828c:	74 05                	je     80108293 <trap+0x26>
      exit();
8010828e:	e8 d9 c9 ff ff       	call   80104c6c <exit>
    proc->tf = tf;
80108293:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108299:	8b 55 08             	mov    0x8(%ebp),%edx
8010829c:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010829f:	e8 0f ec ff ff       	call   80106eb3 <syscall>
    if(proc->killed)
801082a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801082aa:	8b 40 24             	mov    0x24(%eax),%eax
801082ad:	85 c0                	test   %eax,%eax
801082af:	0f 84 21 02 00 00    	je     801084d6 <trap+0x269>
      exit();
801082b5:	e8 b2 c9 ff ff       	call   80104c6c <exit>
    return;
801082ba:	e9 17 02 00 00       	jmp    801084d6 <trap+0x269>
  }

  switch(tf->trapno){
801082bf:	8b 45 08             	mov    0x8(%ebp),%eax
801082c2:	8b 40 30             	mov    0x30(%eax),%eax
801082c5:	83 e8 20             	sub    $0x20,%eax
801082c8:	83 f8 1f             	cmp    $0x1f,%eax
801082cb:	0f 87 a3 00 00 00    	ja     80108374 <trap+0x107>
801082d1:	8b 04 85 18 ac 10 80 	mov    -0x7fef53e8(,%eax,4),%eax
801082d8:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
801082da:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801082e0:	0f b6 00             	movzbl (%eax),%eax
801082e3:	84 c0                	test   %al,%al
801082e5:	75 20                	jne    80108307 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
801082e7:	83 ec 0c             	sub    $0xc,%esp
801082ea:	68 e0 78 11 80       	push   $0x801178e0
801082ef:	e8 b9 fd ff ff       	call   801080ad <atom_inc>
801082f4:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
801082f7:	83 ec 0c             	sub    $0xc,%esp
801082fa:	68 e0 78 11 80       	push   $0x801178e0
801082ff:	e8 e3 d4 ff ff       	call   801057e7 <wakeup>
80108304:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80108307:	e8 ca ad ff ff       	call   801030d6 <lapiceoi>
    break;
8010830c:	e9 1c 01 00 00       	jmp    8010842d <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80108311:	e8 d3 a5 ff ff       	call   801028e9 <ideintr>
    lapiceoi();
80108316:	e8 bb ad ff ff       	call   801030d6 <lapiceoi>
    break;
8010831b:	e9 0d 01 00 00       	jmp    8010842d <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80108320:	e8 b3 ab ff ff       	call   80102ed8 <kbdintr>
    lapiceoi();
80108325:	e8 ac ad ff ff       	call   801030d6 <lapiceoi>
    break;
8010832a:	e9 fe 00 00 00       	jmp    8010842d <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010832f:	e8 83 03 00 00       	call   801086b7 <uartintr>
    lapiceoi();
80108334:	e8 9d ad ff ff       	call   801030d6 <lapiceoi>
    break;
80108339:	e9 ef 00 00 00       	jmp    8010842d <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010833e:	8b 45 08             	mov    0x8(%ebp),%eax
80108341:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80108344:	8b 45 08             	mov    0x8(%ebp),%eax
80108347:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010834b:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
8010834e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108354:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108357:	0f b6 c0             	movzbl %al,%eax
8010835a:	51                   	push   %ecx
8010835b:	52                   	push   %edx
8010835c:	50                   	push   %eax
8010835d:	68 78 ab 10 80       	push   $0x8010ab78
80108362:	e8 5f 80 ff ff       	call   801003c6 <cprintf>
80108367:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010836a:	e8 67 ad ff ff       	call   801030d6 <lapiceoi>
    break;
8010836f:	e9 b9 00 00 00       	jmp    8010842d <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80108374:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010837a:	85 c0                	test   %eax,%eax
8010837c:	74 11                	je     8010838f <trap+0x122>
8010837e:	8b 45 08             	mov    0x8(%ebp),%eax
80108381:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108385:	0f b7 c0             	movzwl %ax,%eax
80108388:	83 e0 03             	and    $0x3,%eax
8010838b:	85 c0                	test   %eax,%eax
8010838d:	75 40                	jne    801083cf <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010838f:	e8 4f fd ff ff       	call   801080e3 <rcr2>
80108394:	89 c3                	mov    %eax,%ebx
80108396:	8b 45 08             	mov    0x8(%ebp),%eax
80108399:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010839c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083a2:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801083a5:	0f b6 d0             	movzbl %al,%edx
801083a8:	8b 45 08             	mov    0x8(%ebp),%eax
801083ab:	8b 40 30             	mov    0x30(%eax),%eax
801083ae:	83 ec 0c             	sub    $0xc,%esp
801083b1:	53                   	push   %ebx
801083b2:	51                   	push   %ecx
801083b3:	52                   	push   %edx
801083b4:	50                   	push   %eax
801083b5:	68 9c ab 10 80       	push   $0x8010ab9c
801083ba:	e8 07 80 ff ff       	call   801003c6 <cprintf>
801083bf:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801083c2:	83 ec 0c             	sub    $0xc,%esp
801083c5:	68 ce ab 10 80       	push   $0x8010abce
801083ca:	e8 97 81 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801083cf:	e8 0f fd ff ff       	call   801080e3 <rcr2>
801083d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801083d7:	8b 45 08             	mov    0x8(%ebp),%eax
801083da:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801083dd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083e3:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801083e6:	0f b6 d8             	movzbl %al,%ebx
801083e9:	8b 45 08             	mov    0x8(%ebp),%eax
801083ec:	8b 48 34             	mov    0x34(%eax),%ecx
801083ef:	8b 45 08             	mov    0x8(%ebp),%eax
801083f2:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801083f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083fb:	8d 78 6c             	lea    0x6c(%eax),%edi
801083fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108404:	8b 40 10             	mov    0x10(%eax),%eax
80108407:	ff 75 e4             	pushl  -0x1c(%ebp)
8010840a:	56                   	push   %esi
8010840b:	53                   	push   %ebx
8010840c:	51                   	push   %ecx
8010840d:	52                   	push   %edx
8010840e:	57                   	push   %edi
8010840f:	50                   	push   %eax
80108410:	68 d4 ab 10 80       	push   $0x8010abd4
80108415:	e8 ac 7f ff ff       	call   801003c6 <cprintf>
8010841a:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
8010841d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108423:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010842a:	eb 01                	jmp    8010842d <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010842c:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010842d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108433:	85 c0                	test   %eax,%eax
80108435:	74 24                	je     8010845b <trap+0x1ee>
80108437:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010843d:	8b 40 24             	mov    0x24(%eax),%eax
80108440:	85 c0                	test   %eax,%eax
80108442:	74 17                	je     8010845b <trap+0x1ee>
80108444:	8b 45 08             	mov    0x8(%ebp),%eax
80108447:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010844b:	0f b7 c0             	movzwl %ax,%eax
8010844e:	83 e0 03             	and    $0x3,%eax
80108451:	83 f8 03             	cmp    $0x3,%eax
80108454:	75 05                	jne    8010845b <trap+0x1ee>
    exit();
80108456:	e8 11 c8 ff ff       	call   80104c6c <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
8010845b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108461:	85 c0                	test   %eax,%eax
80108463:	74 41                	je     801084a6 <trap+0x239>
80108465:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010846b:	8b 40 0c             	mov    0xc(%eax),%eax
8010846e:	83 f8 04             	cmp    $0x4,%eax
80108471:	75 33                	jne    801084a6 <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80108473:	8b 45 08             	mov    0x8(%ebp),%eax
80108476:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80108479:	83 f8 20             	cmp    $0x20,%eax
8010847c:	75 28                	jne    801084a6 <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
8010847e:	8b 0d e0 78 11 80    	mov    0x801178e0,%ecx
80108484:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80108489:	89 c8                	mov    %ecx,%eax
8010848b:	f7 e2                	mul    %edx
8010848d:	c1 ea 03             	shr    $0x3,%edx
80108490:	89 d0                	mov    %edx,%eax
80108492:	c1 e0 02             	shl    $0x2,%eax
80108495:	01 d0                	add    %edx,%eax
80108497:	01 c0                	add    %eax,%eax
80108499:	29 c1                	sub    %eax,%ecx
8010849b:	89 ca                	mov    %ecx,%edx
8010849d:	85 d2                	test   %edx,%edx
8010849f:	75 05                	jne    801084a6 <trap+0x239>
    yield();
801084a1:	e8 62 cf ff ff       	call   80105408 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801084a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801084ac:	85 c0                	test   %eax,%eax
801084ae:	74 27                	je     801084d7 <trap+0x26a>
801084b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801084b6:	8b 40 24             	mov    0x24(%eax),%eax
801084b9:	85 c0                	test   %eax,%eax
801084bb:	74 1a                	je     801084d7 <trap+0x26a>
801084bd:	8b 45 08             	mov    0x8(%ebp),%eax
801084c0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801084c4:	0f b7 c0             	movzwl %ax,%eax
801084c7:	83 e0 03             	and    $0x3,%eax
801084ca:	83 f8 03             	cmp    $0x3,%eax
801084cd:	75 08                	jne    801084d7 <trap+0x26a>
    exit();
801084cf:	e8 98 c7 ff ff       	call   80104c6c <exit>
801084d4:	eb 01                	jmp    801084d7 <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801084d6:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801084d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084da:	5b                   	pop    %ebx
801084db:	5e                   	pop    %esi
801084dc:	5f                   	pop    %edi
801084dd:	5d                   	pop    %ebp
801084de:	c3                   	ret    

801084df <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801084df:	55                   	push   %ebp
801084e0:	89 e5                	mov    %esp,%ebp
801084e2:	83 ec 14             	sub    $0x14,%esp
801084e5:	8b 45 08             	mov    0x8(%ebp),%eax
801084e8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801084ec:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801084f0:	89 c2                	mov    %eax,%edx
801084f2:	ec                   	in     (%dx),%al
801084f3:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801084f6:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801084fa:	c9                   	leave  
801084fb:	c3                   	ret    

801084fc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801084fc:	55                   	push   %ebp
801084fd:	89 e5                	mov    %esp,%ebp
801084ff:	83 ec 08             	sub    $0x8,%esp
80108502:	8b 55 08             	mov    0x8(%ebp),%edx
80108505:	8b 45 0c             	mov    0xc(%ebp),%eax
80108508:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010850c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010850f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108513:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108517:	ee                   	out    %al,(%dx)
}
80108518:	90                   	nop
80108519:	c9                   	leave  
8010851a:	c3                   	ret    

8010851b <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010851b:	55                   	push   %ebp
8010851c:	89 e5                	mov    %esp,%ebp
8010851e:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80108521:	6a 00                	push   $0x0
80108523:	68 fa 03 00 00       	push   $0x3fa
80108528:	e8 cf ff ff ff       	call   801084fc <outb>
8010852d:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80108530:	68 80 00 00 00       	push   $0x80
80108535:	68 fb 03 00 00       	push   $0x3fb
8010853a:	e8 bd ff ff ff       	call   801084fc <outb>
8010853f:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80108542:	6a 0c                	push   $0xc
80108544:	68 f8 03 00 00       	push   $0x3f8
80108549:	e8 ae ff ff ff       	call   801084fc <outb>
8010854e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80108551:	6a 00                	push   $0x0
80108553:	68 f9 03 00 00       	push   $0x3f9
80108558:	e8 9f ff ff ff       	call   801084fc <outb>
8010855d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80108560:	6a 03                	push   $0x3
80108562:	68 fb 03 00 00       	push   $0x3fb
80108567:	e8 90 ff ff ff       	call   801084fc <outb>
8010856c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010856f:	6a 00                	push   $0x0
80108571:	68 fc 03 00 00       	push   $0x3fc
80108576:	e8 81 ff ff ff       	call   801084fc <outb>
8010857b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010857e:	6a 01                	push   $0x1
80108580:	68 f9 03 00 00       	push   $0x3f9
80108585:	e8 72 ff ff ff       	call   801084fc <outb>
8010858a:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010858d:	68 fd 03 00 00       	push   $0x3fd
80108592:	e8 48 ff ff ff       	call   801084df <inb>
80108597:	83 c4 04             	add    $0x4,%esp
8010859a:	3c ff                	cmp    $0xff,%al
8010859c:	74 6e                	je     8010860c <uartinit+0xf1>
    return;
  uart = 1;
8010859e:	c7 05 6c d6 10 80 01 	movl   $0x1,0x8010d66c
801085a5:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801085a8:	68 fa 03 00 00       	push   $0x3fa
801085ad:	e8 2d ff ff ff       	call   801084df <inb>
801085b2:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801085b5:	68 f8 03 00 00       	push   $0x3f8
801085ba:	e8 20 ff ff ff       	call   801084df <inb>
801085bf:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801085c2:	83 ec 0c             	sub    $0xc,%esp
801085c5:	6a 04                	push   $0x4
801085c7:	e8 10 ba ff ff       	call   80103fdc <picenable>
801085cc:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801085cf:	83 ec 08             	sub    $0x8,%esp
801085d2:	6a 00                	push   $0x0
801085d4:	6a 04                	push   $0x4
801085d6:	e8 b0 a5 ff ff       	call   80102b8b <ioapicenable>
801085db:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801085de:	c7 45 f4 98 ac 10 80 	movl   $0x8010ac98,-0xc(%ebp)
801085e5:	eb 19                	jmp    80108600 <uartinit+0xe5>
    uartputc(*p);
801085e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085ea:	0f b6 00             	movzbl (%eax),%eax
801085ed:	0f be c0             	movsbl %al,%eax
801085f0:	83 ec 0c             	sub    $0xc,%esp
801085f3:	50                   	push   %eax
801085f4:	e8 16 00 00 00       	call   8010860f <uartputc>
801085f9:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801085fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108600:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108603:	0f b6 00             	movzbl (%eax),%eax
80108606:	84 c0                	test   %al,%al
80108608:	75 dd                	jne    801085e7 <uartinit+0xcc>
8010860a:	eb 01                	jmp    8010860d <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010860c:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010860d:	c9                   	leave  
8010860e:	c3                   	ret    

8010860f <uartputc>:

void
uartputc(int c)
{
8010860f:	55                   	push   %ebp
80108610:	89 e5                	mov    %esp,%ebp
80108612:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80108615:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
8010861a:	85 c0                	test   %eax,%eax
8010861c:	74 53                	je     80108671 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010861e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108625:	eb 11                	jmp    80108638 <uartputc+0x29>
    microdelay(10);
80108627:	83 ec 0c             	sub    $0xc,%esp
8010862a:	6a 0a                	push   $0xa
8010862c:	e8 c0 aa ff ff       	call   801030f1 <microdelay>
80108631:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108634:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108638:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010863c:	7f 1a                	jg     80108658 <uartputc+0x49>
8010863e:	83 ec 0c             	sub    $0xc,%esp
80108641:	68 fd 03 00 00       	push   $0x3fd
80108646:	e8 94 fe ff ff       	call   801084df <inb>
8010864b:	83 c4 10             	add    $0x10,%esp
8010864e:	0f b6 c0             	movzbl %al,%eax
80108651:	83 e0 20             	and    $0x20,%eax
80108654:	85 c0                	test   %eax,%eax
80108656:	74 cf                	je     80108627 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80108658:	8b 45 08             	mov    0x8(%ebp),%eax
8010865b:	0f b6 c0             	movzbl %al,%eax
8010865e:	83 ec 08             	sub    $0x8,%esp
80108661:	50                   	push   %eax
80108662:	68 f8 03 00 00       	push   $0x3f8
80108667:	e8 90 fe ff ff       	call   801084fc <outb>
8010866c:	83 c4 10             	add    $0x10,%esp
8010866f:	eb 01                	jmp    80108672 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80108671:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80108672:	c9                   	leave  
80108673:	c3                   	ret    

80108674 <uartgetc>:

static int
uartgetc(void)
{
80108674:	55                   	push   %ebp
80108675:	89 e5                	mov    %esp,%ebp
  if(!uart)
80108677:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
8010867c:	85 c0                	test   %eax,%eax
8010867e:	75 07                	jne    80108687 <uartgetc+0x13>
    return -1;
80108680:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108685:	eb 2e                	jmp    801086b5 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80108687:	68 fd 03 00 00       	push   $0x3fd
8010868c:	e8 4e fe ff ff       	call   801084df <inb>
80108691:	83 c4 04             	add    $0x4,%esp
80108694:	0f b6 c0             	movzbl %al,%eax
80108697:	83 e0 01             	and    $0x1,%eax
8010869a:	85 c0                	test   %eax,%eax
8010869c:	75 07                	jne    801086a5 <uartgetc+0x31>
    return -1;
8010869e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801086a3:	eb 10                	jmp    801086b5 <uartgetc+0x41>
  return inb(COM1+0);
801086a5:	68 f8 03 00 00       	push   $0x3f8
801086aa:	e8 30 fe ff ff       	call   801084df <inb>
801086af:	83 c4 04             	add    $0x4,%esp
801086b2:	0f b6 c0             	movzbl %al,%eax
}
801086b5:	c9                   	leave  
801086b6:	c3                   	ret    

801086b7 <uartintr>:

void
uartintr(void)
{
801086b7:	55                   	push   %ebp
801086b8:	89 e5                	mov    %esp,%ebp
801086ba:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801086bd:	83 ec 0c             	sub    $0xc,%esp
801086c0:	68 74 86 10 80       	push   $0x80108674
801086c5:	e8 2f 81 ff ff       	call   801007f9 <consoleintr>
801086ca:	83 c4 10             	add    $0x10,%esp
}
801086cd:	90                   	nop
801086ce:	c9                   	leave  
801086cf:	c3                   	ret    

801086d0 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801086d0:	6a 00                	push   $0x0
  pushl $0
801086d2:	6a 00                	push   $0x0
  jmp alltraps
801086d4:	e9 a9 f9 ff ff       	jmp    80108082 <alltraps>

801086d9 <vector1>:
.globl vector1
vector1:
  pushl $0
801086d9:	6a 00                	push   $0x0
  pushl $1
801086db:	6a 01                	push   $0x1
  jmp alltraps
801086dd:	e9 a0 f9 ff ff       	jmp    80108082 <alltraps>

801086e2 <vector2>:
.globl vector2
vector2:
  pushl $0
801086e2:	6a 00                	push   $0x0
  pushl $2
801086e4:	6a 02                	push   $0x2
  jmp alltraps
801086e6:	e9 97 f9 ff ff       	jmp    80108082 <alltraps>

801086eb <vector3>:
.globl vector3
vector3:
  pushl $0
801086eb:	6a 00                	push   $0x0
  pushl $3
801086ed:	6a 03                	push   $0x3
  jmp alltraps
801086ef:	e9 8e f9 ff ff       	jmp    80108082 <alltraps>

801086f4 <vector4>:
.globl vector4
vector4:
  pushl $0
801086f4:	6a 00                	push   $0x0
  pushl $4
801086f6:	6a 04                	push   $0x4
  jmp alltraps
801086f8:	e9 85 f9 ff ff       	jmp    80108082 <alltraps>

801086fd <vector5>:
.globl vector5
vector5:
  pushl $0
801086fd:	6a 00                	push   $0x0
  pushl $5
801086ff:	6a 05                	push   $0x5
  jmp alltraps
80108701:	e9 7c f9 ff ff       	jmp    80108082 <alltraps>

80108706 <vector6>:
.globl vector6
vector6:
  pushl $0
80108706:	6a 00                	push   $0x0
  pushl $6
80108708:	6a 06                	push   $0x6
  jmp alltraps
8010870a:	e9 73 f9 ff ff       	jmp    80108082 <alltraps>

8010870f <vector7>:
.globl vector7
vector7:
  pushl $0
8010870f:	6a 00                	push   $0x0
  pushl $7
80108711:	6a 07                	push   $0x7
  jmp alltraps
80108713:	e9 6a f9 ff ff       	jmp    80108082 <alltraps>

80108718 <vector8>:
.globl vector8
vector8:
  pushl $8
80108718:	6a 08                	push   $0x8
  jmp alltraps
8010871a:	e9 63 f9 ff ff       	jmp    80108082 <alltraps>

8010871f <vector9>:
.globl vector9
vector9:
  pushl $0
8010871f:	6a 00                	push   $0x0
  pushl $9
80108721:	6a 09                	push   $0x9
  jmp alltraps
80108723:	e9 5a f9 ff ff       	jmp    80108082 <alltraps>

80108728 <vector10>:
.globl vector10
vector10:
  pushl $10
80108728:	6a 0a                	push   $0xa
  jmp alltraps
8010872a:	e9 53 f9 ff ff       	jmp    80108082 <alltraps>

8010872f <vector11>:
.globl vector11
vector11:
  pushl $11
8010872f:	6a 0b                	push   $0xb
  jmp alltraps
80108731:	e9 4c f9 ff ff       	jmp    80108082 <alltraps>

80108736 <vector12>:
.globl vector12
vector12:
  pushl $12
80108736:	6a 0c                	push   $0xc
  jmp alltraps
80108738:	e9 45 f9 ff ff       	jmp    80108082 <alltraps>

8010873d <vector13>:
.globl vector13
vector13:
  pushl $13
8010873d:	6a 0d                	push   $0xd
  jmp alltraps
8010873f:	e9 3e f9 ff ff       	jmp    80108082 <alltraps>

80108744 <vector14>:
.globl vector14
vector14:
  pushl $14
80108744:	6a 0e                	push   $0xe
  jmp alltraps
80108746:	e9 37 f9 ff ff       	jmp    80108082 <alltraps>

8010874b <vector15>:
.globl vector15
vector15:
  pushl $0
8010874b:	6a 00                	push   $0x0
  pushl $15
8010874d:	6a 0f                	push   $0xf
  jmp alltraps
8010874f:	e9 2e f9 ff ff       	jmp    80108082 <alltraps>

80108754 <vector16>:
.globl vector16
vector16:
  pushl $0
80108754:	6a 00                	push   $0x0
  pushl $16
80108756:	6a 10                	push   $0x10
  jmp alltraps
80108758:	e9 25 f9 ff ff       	jmp    80108082 <alltraps>

8010875d <vector17>:
.globl vector17
vector17:
  pushl $17
8010875d:	6a 11                	push   $0x11
  jmp alltraps
8010875f:	e9 1e f9 ff ff       	jmp    80108082 <alltraps>

80108764 <vector18>:
.globl vector18
vector18:
  pushl $0
80108764:	6a 00                	push   $0x0
  pushl $18
80108766:	6a 12                	push   $0x12
  jmp alltraps
80108768:	e9 15 f9 ff ff       	jmp    80108082 <alltraps>

8010876d <vector19>:
.globl vector19
vector19:
  pushl $0
8010876d:	6a 00                	push   $0x0
  pushl $19
8010876f:	6a 13                	push   $0x13
  jmp alltraps
80108771:	e9 0c f9 ff ff       	jmp    80108082 <alltraps>

80108776 <vector20>:
.globl vector20
vector20:
  pushl $0
80108776:	6a 00                	push   $0x0
  pushl $20
80108778:	6a 14                	push   $0x14
  jmp alltraps
8010877a:	e9 03 f9 ff ff       	jmp    80108082 <alltraps>

8010877f <vector21>:
.globl vector21
vector21:
  pushl $0
8010877f:	6a 00                	push   $0x0
  pushl $21
80108781:	6a 15                	push   $0x15
  jmp alltraps
80108783:	e9 fa f8 ff ff       	jmp    80108082 <alltraps>

80108788 <vector22>:
.globl vector22
vector22:
  pushl $0
80108788:	6a 00                	push   $0x0
  pushl $22
8010878a:	6a 16                	push   $0x16
  jmp alltraps
8010878c:	e9 f1 f8 ff ff       	jmp    80108082 <alltraps>

80108791 <vector23>:
.globl vector23
vector23:
  pushl $0
80108791:	6a 00                	push   $0x0
  pushl $23
80108793:	6a 17                	push   $0x17
  jmp alltraps
80108795:	e9 e8 f8 ff ff       	jmp    80108082 <alltraps>

8010879a <vector24>:
.globl vector24
vector24:
  pushl $0
8010879a:	6a 00                	push   $0x0
  pushl $24
8010879c:	6a 18                	push   $0x18
  jmp alltraps
8010879e:	e9 df f8 ff ff       	jmp    80108082 <alltraps>

801087a3 <vector25>:
.globl vector25
vector25:
  pushl $0
801087a3:	6a 00                	push   $0x0
  pushl $25
801087a5:	6a 19                	push   $0x19
  jmp alltraps
801087a7:	e9 d6 f8 ff ff       	jmp    80108082 <alltraps>

801087ac <vector26>:
.globl vector26
vector26:
  pushl $0
801087ac:	6a 00                	push   $0x0
  pushl $26
801087ae:	6a 1a                	push   $0x1a
  jmp alltraps
801087b0:	e9 cd f8 ff ff       	jmp    80108082 <alltraps>

801087b5 <vector27>:
.globl vector27
vector27:
  pushl $0
801087b5:	6a 00                	push   $0x0
  pushl $27
801087b7:	6a 1b                	push   $0x1b
  jmp alltraps
801087b9:	e9 c4 f8 ff ff       	jmp    80108082 <alltraps>

801087be <vector28>:
.globl vector28
vector28:
  pushl $0
801087be:	6a 00                	push   $0x0
  pushl $28
801087c0:	6a 1c                	push   $0x1c
  jmp alltraps
801087c2:	e9 bb f8 ff ff       	jmp    80108082 <alltraps>

801087c7 <vector29>:
.globl vector29
vector29:
  pushl $0
801087c7:	6a 00                	push   $0x0
  pushl $29
801087c9:	6a 1d                	push   $0x1d
  jmp alltraps
801087cb:	e9 b2 f8 ff ff       	jmp    80108082 <alltraps>

801087d0 <vector30>:
.globl vector30
vector30:
  pushl $0
801087d0:	6a 00                	push   $0x0
  pushl $30
801087d2:	6a 1e                	push   $0x1e
  jmp alltraps
801087d4:	e9 a9 f8 ff ff       	jmp    80108082 <alltraps>

801087d9 <vector31>:
.globl vector31
vector31:
  pushl $0
801087d9:	6a 00                	push   $0x0
  pushl $31
801087db:	6a 1f                	push   $0x1f
  jmp alltraps
801087dd:	e9 a0 f8 ff ff       	jmp    80108082 <alltraps>

801087e2 <vector32>:
.globl vector32
vector32:
  pushl $0
801087e2:	6a 00                	push   $0x0
  pushl $32
801087e4:	6a 20                	push   $0x20
  jmp alltraps
801087e6:	e9 97 f8 ff ff       	jmp    80108082 <alltraps>

801087eb <vector33>:
.globl vector33
vector33:
  pushl $0
801087eb:	6a 00                	push   $0x0
  pushl $33
801087ed:	6a 21                	push   $0x21
  jmp alltraps
801087ef:	e9 8e f8 ff ff       	jmp    80108082 <alltraps>

801087f4 <vector34>:
.globl vector34
vector34:
  pushl $0
801087f4:	6a 00                	push   $0x0
  pushl $34
801087f6:	6a 22                	push   $0x22
  jmp alltraps
801087f8:	e9 85 f8 ff ff       	jmp    80108082 <alltraps>

801087fd <vector35>:
.globl vector35
vector35:
  pushl $0
801087fd:	6a 00                	push   $0x0
  pushl $35
801087ff:	6a 23                	push   $0x23
  jmp alltraps
80108801:	e9 7c f8 ff ff       	jmp    80108082 <alltraps>

80108806 <vector36>:
.globl vector36
vector36:
  pushl $0
80108806:	6a 00                	push   $0x0
  pushl $36
80108808:	6a 24                	push   $0x24
  jmp alltraps
8010880a:	e9 73 f8 ff ff       	jmp    80108082 <alltraps>

8010880f <vector37>:
.globl vector37
vector37:
  pushl $0
8010880f:	6a 00                	push   $0x0
  pushl $37
80108811:	6a 25                	push   $0x25
  jmp alltraps
80108813:	e9 6a f8 ff ff       	jmp    80108082 <alltraps>

80108818 <vector38>:
.globl vector38
vector38:
  pushl $0
80108818:	6a 00                	push   $0x0
  pushl $38
8010881a:	6a 26                	push   $0x26
  jmp alltraps
8010881c:	e9 61 f8 ff ff       	jmp    80108082 <alltraps>

80108821 <vector39>:
.globl vector39
vector39:
  pushl $0
80108821:	6a 00                	push   $0x0
  pushl $39
80108823:	6a 27                	push   $0x27
  jmp alltraps
80108825:	e9 58 f8 ff ff       	jmp    80108082 <alltraps>

8010882a <vector40>:
.globl vector40
vector40:
  pushl $0
8010882a:	6a 00                	push   $0x0
  pushl $40
8010882c:	6a 28                	push   $0x28
  jmp alltraps
8010882e:	e9 4f f8 ff ff       	jmp    80108082 <alltraps>

80108833 <vector41>:
.globl vector41
vector41:
  pushl $0
80108833:	6a 00                	push   $0x0
  pushl $41
80108835:	6a 29                	push   $0x29
  jmp alltraps
80108837:	e9 46 f8 ff ff       	jmp    80108082 <alltraps>

8010883c <vector42>:
.globl vector42
vector42:
  pushl $0
8010883c:	6a 00                	push   $0x0
  pushl $42
8010883e:	6a 2a                	push   $0x2a
  jmp alltraps
80108840:	e9 3d f8 ff ff       	jmp    80108082 <alltraps>

80108845 <vector43>:
.globl vector43
vector43:
  pushl $0
80108845:	6a 00                	push   $0x0
  pushl $43
80108847:	6a 2b                	push   $0x2b
  jmp alltraps
80108849:	e9 34 f8 ff ff       	jmp    80108082 <alltraps>

8010884e <vector44>:
.globl vector44
vector44:
  pushl $0
8010884e:	6a 00                	push   $0x0
  pushl $44
80108850:	6a 2c                	push   $0x2c
  jmp alltraps
80108852:	e9 2b f8 ff ff       	jmp    80108082 <alltraps>

80108857 <vector45>:
.globl vector45
vector45:
  pushl $0
80108857:	6a 00                	push   $0x0
  pushl $45
80108859:	6a 2d                	push   $0x2d
  jmp alltraps
8010885b:	e9 22 f8 ff ff       	jmp    80108082 <alltraps>

80108860 <vector46>:
.globl vector46
vector46:
  pushl $0
80108860:	6a 00                	push   $0x0
  pushl $46
80108862:	6a 2e                	push   $0x2e
  jmp alltraps
80108864:	e9 19 f8 ff ff       	jmp    80108082 <alltraps>

80108869 <vector47>:
.globl vector47
vector47:
  pushl $0
80108869:	6a 00                	push   $0x0
  pushl $47
8010886b:	6a 2f                	push   $0x2f
  jmp alltraps
8010886d:	e9 10 f8 ff ff       	jmp    80108082 <alltraps>

80108872 <vector48>:
.globl vector48
vector48:
  pushl $0
80108872:	6a 00                	push   $0x0
  pushl $48
80108874:	6a 30                	push   $0x30
  jmp alltraps
80108876:	e9 07 f8 ff ff       	jmp    80108082 <alltraps>

8010887b <vector49>:
.globl vector49
vector49:
  pushl $0
8010887b:	6a 00                	push   $0x0
  pushl $49
8010887d:	6a 31                	push   $0x31
  jmp alltraps
8010887f:	e9 fe f7 ff ff       	jmp    80108082 <alltraps>

80108884 <vector50>:
.globl vector50
vector50:
  pushl $0
80108884:	6a 00                	push   $0x0
  pushl $50
80108886:	6a 32                	push   $0x32
  jmp alltraps
80108888:	e9 f5 f7 ff ff       	jmp    80108082 <alltraps>

8010888d <vector51>:
.globl vector51
vector51:
  pushl $0
8010888d:	6a 00                	push   $0x0
  pushl $51
8010888f:	6a 33                	push   $0x33
  jmp alltraps
80108891:	e9 ec f7 ff ff       	jmp    80108082 <alltraps>

80108896 <vector52>:
.globl vector52
vector52:
  pushl $0
80108896:	6a 00                	push   $0x0
  pushl $52
80108898:	6a 34                	push   $0x34
  jmp alltraps
8010889a:	e9 e3 f7 ff ff       	jmp    80108082 <alltraps>

8010889f <vector53>:
.globl vector53
vector53:
  pushl $0
8010889f:	6a 00                	push   $0x0
  pushl $53
801088a1:	6a 35                	push   $0x35
  jmp alltraps
801088a3:	e9 da f7 ff ff       	jmp    80108082 <alltraps>

801088a8 <vector54>:
.globl vector54
vector54:
  pushl $0
801088a8:	6a 00                	push   $0x0
  pushl $54
801088aa:	6a 36                	push   $0x36
  jmp alltraps
801088ac:	e9 d1 f7 ff ff       	jmp    80108082 <alltraps>

801088b1 <vector55>:
.globl vector55
vector55:
  pushl $0
801088b1:	6a 00                	push   $0x0
  pushl $55
801088b3:	6a 37                	push   $0x37
  jmp alltraps
801088b5:	e9 c8 f7 ff ff       	jmp    80108082 <alltraps>

801088ba <vector56>:
.globl vector56
vector56:
  pushl $0
801088ba:	6a 00                	push   $0x0
  pushl $56
801088bc:	6a 38                	push   $0x38
  jmp alltraps
801088be:	e9 bf f7 ff ff       	jmp    80108082 <alltraps>

801088c3 <vector57>:
.globl vector57
vector57:
  pushl $0
801088c3:	6a 00                	push   $0x0
  pushl $57
801088c5:	6a 39                	push   $0x39
  jmp alltraps
801088c7:	e9 b6 f7 ff ff       	jmp    80108082 <alltraps>

801088cc <vector58>:
.globl vector58
vector58:
  pushl $0
801088cc:	6a 00                	push   $0x0
  pushl $58
801088ce:	6a 3a                	push   $0x3a
  jmp alltraps
801088d0:	e9 ad f7 ff ff       	jmp    80108082 <alltraps>

801088d5 <vector59>:
.globl vector59
vector59:
  pushl $0
801088d5:	6a 00                	push   $0x0
  pushl $59
801088d7:	6a 3b                	push   $0x3b
  jmp alltraps
801088d9:	e9 a4 f7 ff ff       	jmp    80108082 <alltraps>

801088de <vector60>:
.globl vector60
vector60:
  pushl $0
801088de:	6a 00                	push   $0x0
  pushl $60
801088e0:	6a 3c                	push   $0x3c
  jmp alltraps
801088e2:	e9 9b f7 ff ff       	jmp    80108082 <alltraps>

801088e7 <vector61>:
.globl vector61
vector61:
  pushl $0
801088e7:	6a 00                	push   $0x0
  pushl $61
801088e9:	6a 3d                	push   $0x3d
  jmp alltraps
801088eb:	e9 92 f7 ff ff       	jmp    80108082 <alltraps>

801088f0 <vector62>:
.globl vector62
vector62:
  pushl $0
801088f0:	6a 00                	push   $0x0
  pushl $62
801088f2:	6a 3e                	push   $0x3e
  jmp alltraps
801088f4:	e9 89 f7 ff ff       	jmp    80108082 <alltraps>

801088f9 <vector63>:
.globl vector63
vector63:
  pushl $0
801088f9:	6a 00                	push   $0x0
  pushl $63
801088fb:	6a 3f                	push   $0x3f
  jmp alltraps
801088fd:	e9 80 f7 ff ff       	jmp    80108082 <alltraps>

80108902 <vector64>:
.globl vector64
vector64:
  pushl $0
80108902:	6a 00                	push   $0x0
  pushl $64
80108904:	6a 40                	push   $0x40
  jmp alltraps
80108906:	e9 77 f7 ff ff       	jmp    80108082 <alltraps>

8010890b <vector65>:
.globl vector65
vector65:
  pushl $0
8010890b:	6a 00                	push   $0x0
  pushl $65
8010890d:	6a 41                	push   $0x41
  jmp alltraps
8010890f:	e9 6e f7 ff ff       	jmp    80108082 <alltraps>

80108914 <vector66>:
.globl vector66
vector66:
  pushl $0
80108914:	6a 00                	push   $0x0
  pushl $66
80108916:	6a 42                	push   $0x42
  jmp alltraps
80108918:	e9 65 f7 ff ff       	jmp    80108082 <alltraps>

8010891d <vector67>:
.globl vector67
vector67:
  pushl $0
8010891d:	6a 00                	push   $0x0
  pushl $67
8010891f:	6a 43                	push   $0x43
  jmp alltraps
80108921:	e9 5c f7 ff ff       	jmp    80108082 <alltraps>

80108926 <vector68>:
.globl vector68
vector68:
  pushl $0
80108926:	6a 00                	push   $0x0
  pushl $68
80108928:	6a 44                	push   $0x44
  jmp alltraps
8010892a:	e9 53 f7 ff ff       	jmp    80108082 <alltraps>

8010892f <vector69>:
.globl vector69
vector69:
  pushl $0
8010892f:	6a 00                	push   $0x0
  pushl $69
80108931:	6a 45                	push   $0x45
  jmp alltraps
80108933:	e9 4a f7 ff ff       	jmp    80108082 <alltraps>

80108938 <vector70>:
.globl vector70
vector70:
  pushl $0
80108938:	6a 00                	push   $0x0
  pushl $70
8010893a:	6a 46                	push   $0x46
  jmp alltraps
8010893c:	e9 41 f7 ff ff       	jmp    80108082 <alltraps>

80108941 <vector71>:
.globl vector71
vector71:
  pushl $0
80108941:	6a 00                	push   $0x0
  pushl $71
80108943:	6a 47                	push   $0x47
  jmp alltraps
80108945:	e9 38 f7 ff ff       	jmp    80108082 <alltraps>

8010894a <vector72>:
.globl vector72
vector72:
  pushl $0
8010894a:	6a 00                	push   $0x0
  pushl $72
8010894c:	6a 48                	push   $0x48
  jmp alltraps
8010894e:	e9 2f f7 ff ff       	jmp    80108082 <alltraps>

80108953 <vector73>:
.globl vector73
vector73:
  pushl $0
80108953:	6a 00                	push   $0x0
  pushl $73
80108955:	6a 49                	push   $0x49
  jmp alltraps
80108957:	e9 26 f7 ff ff       	jmp    80108082 <alltraps>

8010895c <vector74>:
.globl vector74
vector74:
  pushl $0
8010895c:	6a 00                	push   $0x0
  pushl $74
8010895e:	6a 4a                	push   $0x4a
  jmp alltraps
80108960:	e9 1d f7 ff ff       	jmp    80108082 <alltraps>

80108965 <vector75>:
.globl vector75
vector75:
  pushl $0
80108965:	6a 00                	push   $0x0
  pushl $75
80108967:	6a 4b                	push   $0x4b
  jmp alltraps
80108969:	e9 14 f7 ff ff       	jmp    80108082 <alltraps>

8010896e <vector76>:
.globl vector76
vector76:
  pushl $0
8010896e:	6a 00                	push   $0x0
  pushl $76
80108970:	6a 4c                	push   $0x4c
  jmp alltraps
80108972:	e9 0b f7 ff ff       	jmp    80108082 <alltraps>

80108977 <vector77>:
.globl vector77
vector77:
  pushl $0
80108977:	6a 00                	push   $0x0
  pushl $77
80108979:	6a 4d                	push   $0x4d
  jmp alltraps
8010897b:	e9 02 f7 ff ff       	jmp    80108082 <alltraps>

80108980 <vector78>:
.globl vector78
vector78:
  pushl $0
80108980:	6a 00                	push   $0x0
  pushl $78
80108982:	6a 4e                	push   $0x4e
  jmp alltraps
80108984:	e9 f9 f6 ff ff       	jmp    80108082 <alltraps>

80108989 <vector79>:
.globl vector79
vector79:
  pushl $0
80108989:	6a 00                	push   $0x0
  pushl $79
8010898b:	6a 4f                	push   $0x4f
  jmp alltraps
8010898d:	e9 f0 f6 ff ff       	jmp    80108082 <alltraps>

80108992 <vector80>:
.globl vector80
vector80:
  pushl $0
80108992:	6a 00                	push   $0x0
  pushl $80
80108994:	6a 50                	push   $0x50
  jmp alltraps
80108996:	e9 e7 f6 ff ff       	jmp    80108082 <alltraps>

8010899b <vector81>:
.globl vector81
vector81:
  pushl $0
8010899b:	6a 00                	push   $0x0
  pushl $81
8010899d:	6a 51                	push   $0x51
  jmp alltraps
8010899f:	e9 de f6 ff ff       	jmp    80108082 <alltraps>

801089a4 <vector82>:
.globl vector82
vector82:
  pushl $0
801089a4:	6a 00                	push   $0x0
  pushl $82
801089a6:	6a 52                	push   $0x52
  jmp alltraps
801089a8:	e9 d5 f6 ff ff       	jmp    80108082 <alltraps>

801089ad <vector83>:
.globl vector83
vector83:
  pushl $0
801089ad:	6a 00                	push   $0x0
  pushl $83
801089af:	6a 53                	push   $0x53
  jmp alltraps
801089b1:	e9 cc f6 ff ff       	jmp    80108082 <alltraps>

801089b6 <vector84>:
.globl vector84
vector84:
  pushl $0
801089b6:	6a 00                	push   $0x0
  pushl $84
801089b8:	6a 54                	push   $0x54
  jmp alltraps
801089ba:	e9 c3 f6 ff ff       	jmp    80108082 <alltraps>

801089bf <vector85>:
.globl vector85
vector85:
  pushl $0
801089bf:	6a 00                	push   $0x0
  pushl $85
801089c1:	6a 55                	push   $0x55
  jmp alltraps
801089c3:	e9 ba f6 ff ff       	jmp    80108082 <alltraps>

801089c8 <vector86>:
.globl vector86
vector86:
  pushl $0
801089c8:	6a 00                	push   $0x0
  pushl $86
801089ca:	6a 56                	push   $0x56
  jmp alltraps
801089cc:	e9 b1 f6 ff ff       	jmp    80108082 <alltraps>

801089d1 <vector87>:
.globl vector87
vector87:
  pushl $0
801089d1:	6a 00                	push   $0x0
  pushl $87
801089d3:	6a 57                	push   $0x57
  jmp alltraps
801089d5:	e9 a8 f6 ff ff       	jmp    80108082 <alltraps>

801089da <vector88>:
.globl vector88
vector88:
  pushl $0
801089da:	6a 00                	push   $0x0
  pushl $88
801089dc:	6a 58                	push   $0x58
  jmp alltraps
801089de:	e9 9f f6 ff ff       	jmp    80108082 <alltraps>

801089e3 <vector89>:
.globl vector89
vector89:
  pushl $0
801089e3:	6a 00                	push   $0x0
  pushl $89
801089e5:	6a 59                	push   $0x59
  jmp alltraps
801089e7:	e9 96 f6 ff ff       	jmp    80108082 <alltraps>

801089ec <vector90>:
.globl vector90
vector90:
  pushl $0
801089ec:	6a 00                	push   $0x0
  pushl $90
801089ee:	6a 5a                	push   $0x5a
  jmp alltraps
801089f0:	e9 8d f6 ff ff       	jmp    80108082 <alltraps>

801089f5 <vector91>:
.globl vector91
vector91:
  pushl $0
801089f5:	6a 00                	push   $0x0
  pushl $91
801089f7:	6a 5b                	push   $0x5b
  jmp alltraps
801089f9:	e9 84 f6 ff ff       	jmp    80108082 <alltraps>

801089fe <vector92>:
.globl vector92
vector92:
  pushl $0
801089fe:	6a 00                	push   $0x0
  pushl $92
80108a00:	6a 5c                	push   $0x5c
  jmp alltraps
80108a02:	e9 7b f6 ff ff       	jmp    80108082 <alltraps>

80108a07 <vector93>:
.globl vector93
vector93:
  pushl $0
80108a07:	6a 00                	push   $0x0
  pushl $93
80108a09:	6a 5d                	push   $0x5d
  jmp alltraps
80108a0b:	e9 72 f6 ff ff       	jmp    80108082 <alltraps>

80108a10 <vector94>:
.globl vector94
vector94:
  pushl $0
80108a10:	6a 00                	push   $0x0
  pushl $94
80108a12:	6a 5e                	push   $0x5e
  jmp alltraps
80108a14:	e9 69 f6 ff ff       	jmp    80108082 <alltraps>

80108a19 <vector95>:
.globl vector95
vector95:
  pushl $0
80108a19:	6a 00                	push   $0x0
  pushl $95
80108a1b:	6a 5f                	push   $0x5f
  jmp alltraps
80108a1d:	e9 60 f6 ff ff       	jmp    80108082 <alltraps>

80108a22 <vector96>:
.globl vector96
vector96:
  pushl $0
80108a22:	6a 00                	push   $0x0
  pushl $96
80108a24:	6a 60                	push   $0x60
  jmp alltraps
80108a26:	e9 57 f6 ff ff       	jmp    80108082 <alltraps>

80108a2b <vector97>:
.globl vector97
vector97:
  pushl $0
80108a2b:	6a 00                	push   $0x0
  pushl $97
80108a2d:	6a 61                	push   $0x61
  jmp alltraps
80108a2f:	e9 4e f6 ff ff       	jmp    80108082 <alltraps>

80108a34 <vector98>:
.globl vector98
vector98:
  pushl $0
80108a34:	6a 00                	push   $0x0
  pushl $98
80108a36:	6a 62                	push   $0x62
  jmp alltraps
80108a38:	e9 45 f6 ff ff       	jmp    80108082 <alltraps>

80108a3d <vector99>:
.globl vector99
vector99:
  pushl $0
80108a3d:	6a 00                	push   $0x0
  pushl $99
80108a3f:	6a 63                	push   $0x63
  jmp alltraps
80108a41:	e9 3c f6 ff ff       	jmp    80108082 <alltraps>

80108a46 <vector100>:
.globl vector100
vector100:
  pushl $0
80108a46:	6a 00                	push   $0x0
  pushl $100
80108a48:	6a 64                	push   $0x64
  jmp alltraps
80108a4a:	e9 33 f6 ff ff       	jmp    80108082 <alltraps>

80108a4f <vector101>:
.globl vector101
vector101:
  pushl $0
80108a4f:	6a 00                	push   $0x0
  pushl $101
80108a51:	6a 65                	push   $0x65
  jmp alltraps
80108a53:	e9 2a f6 ff ff       	jmp    80108082 <alltraps>

80108a58 <vector102>:
.globl vector102
vector102:
  pushl $0
80108a58:	6a 00                	push   $0x0
  pushl $102
80108a5a:	6a 66                	push   $0x66
  jmp alltraps
80108a5c:	e9 21 f6 ff ff       	jmp    80108082 <alltraps>

80108a61 <vector103>:
.globl vector103
vector103:
  pushl $0
80108a61:	6a 00                	push   $0x0
  pushl $103
80108a63:	6a 67                	push   $0x67
  jmp alltraps
80108a65:	e9 18 f6 ff ff       	jmp    80108082 <alltraps>

80108a6a <vector104>:
.globl vector104
vector104:
  pushl $0
80108a6a:	6a 00                	push   $0x0
  pushl $104
80108a6c:	6a 68                	push   $0x68
  jmp alltraps
80108a6e:	e9 0f f6 ff ff       	jmp    80108082 <alltraps>

80108a73 <vector105>:
.globl vector105
vector105:
  pushl $0
80108a73:	6a 00                	push   $0x0
  pushl $105
80108a75:	6a 69                	push   $0x69
  jmp alltraps
80108a77:	e9 06 f6 ff ff       	jmp    80108082 <alltraps>

80108a7c <vector106>:
.globl vector106
vector106:
  pushl $0
80108a7c:	6a 00                	push   $0x0
  pushl $106
80108a7e:	6a 6a                	push   $0x6a
  jmp alltraps
80108a80:	e9 fd f5 ff ff       	jmp    80108082 <alltraps>

80108a85 <vector107>:
.globl vector107
vector107:
  pushl $0
80108a85:	6a 00                	push   $0x0
  pushl $107
80108a87:	6a 6b                	push   $0x6b
  jmp alltraps
80108a89:	e9 f4 f5 ff ff       	jmp    80108082 <alltraps>

80108a8e <vector108>:
.globl vector108
vector108:
  pushl $0
80108a8e:	6a 00                	push   $0x0
  pushl $108
80108a90:	6a 6c                	push   $0x6c
  jmp alltraps
80108a92:	e9 eb f5 ff ff       	jmp    80108082 <alltraps>

80108a97 <vector109>:
.globl vector109
vector109:
  pushl $0
80108a97:	6a 00                	push   $0x0
  pushl $109
80108a99:	6a 6d                	push   $0x6d
  jmp alltraps
80108a9b:	e9 e2 f5 ff ff       	jmp    80108082 <alltraps>

80108aa0 <vector110>:
.globl vector110
vector110:
  pushl $0
80108aa0:	6a 00                	push   $0x0
  pushl $110
80108aa2:	6a 6e                	push   $0x6e
  jmp alltraps
80108aa4:	e9 d9 f5 ff ff       	jmp    80108082 <alltraps>

80108aa9 <vector111>:
.globl vector111
vector111:
  pushl $0
80108aa9:	6a 00                	push   $0x0
  pushl $111
80108aab:	6a 6f                	push   $0x6f
  jmp alltraps
80108aad:	e9 d0 f5 ff ff       	jmp    80108082 <alltraps>

80108ab2 <vector112>:
.globl vector112
vector112:
  pushl $0
80108ab2:	6a 00                	push   $0x0
  pushl $112
80108ab4:	6a 70                	push   $0x70
  jmp alltraps
80108ab6:	e9 c7 f5 ff ff       	jmp    80108082 <alltraps>

80108abb <vector113>:
.globl vector113
vector113:
  pushl $0
80108abb:	6a 00                	push   $0x0
  pushl $113
80108abd:	6a 71                	push   $0x71
  jmp alltraps
80108abf:	e9 be f5 ff ff       	jmp    80108082 <alltraps>

80108ac4 <vector114>:
.globl vector114
vector114:
  pushl $0
80108ac4:	6a 00                	push   $0x0
  pushl $114
80108ac6:	6a 72                	push   $0x72
  jmp alltraps
80108ac8:	e9 b5 f5 ff ff       	jmp    80108082 <alltraps>

80108acd <vector115>:
.globl vector115
vector115:
  pushl $0
80108acd:	6a 00                	push   $0x0
  pushl $115
80108acf:	6a 73                	push   $0x73
  jmp alltraps
80108ad1:	e9 ac f5 ff ff       	jmp    80108082 <alltraps>

80108ad6 <vector116>:
.globl vector116
vector116:
  pushl $0
80108ad6:	6a 00                	push   $0x0
  pushl $116
80108ad8:	6a 74                	push   $0x74
  jmp alltraps
80108ada:	e9 a3 f5 ff ff       	jmp    80108082 <alltraps>

80108adf <vector117>:
.globl vector117
vector117:
  pushl $0
80108adf:	6a 00                	push   $0x0
  pushl $117
80108ae1:	6a 75                	push   $0x75
  jmp alltraps
80108ae3:	e9 9a f5 ff ff       	jmp    80108082 <alltraps>

80108ae8 <vector118>:
.globl vector118
vector118:
  pushl $0
80108ae8:	6a 00                	push   $0x0
  pushl $118
80108aea:	6a 76                	push   $0x76
  jmp alltraps
80108aec:	e9 91 f5 ff ff       	jmp    80108082 <alltraps>

80108af1 <vector119>:
.globl vector119
vector119:
  pushl $0
80108af1:	6a 00                	push   $0x0
  pushl $119
80108af3:	6a 77                	push   $0x77
  jmp alltraps
80108af5:	e9 88 f5 ff ff       	jmp    80108082 <alltraps>

80108afa <vector120>:
.globl vector120
vector120:
  pushl $0
80108afa:	6a 00                	push   $0x0
  pushl $120
80108afc:	6a 78                	push   $0x78
  jmp alltraps
80108afe:	e9 7f f5 ff ff       	jmp    80108082 <alltraps>

80108b03 <vector121>:
.globl vector121
vector121:
  pushl $0
80108b03:	6a 00                	push   $0x0
  pushl $121
80108b05:	6a 79                	push   $0x79
  jmp alltraps
80108b07:	e9 76 f5 ff ff       	jmp    80108082 <alltraps>

80108b0c <vector122>:
.globl vector122
vector122:
  pushl $0
80108b0c:	6a 00                	push   $0x0
  pushl $122
80108b0e:	6a 7a                	push   $0x7a
  jmp alltraps
80108b10:	e9 6d f5 ff ff       	jmp    80108082 <alltraps>

80108b15 <vector123>:
.globl vector123
vector123:
  pushl $0
80108b15:	6a 00                	push   $0x0
  pushl $123
80108b17:	6a 7b                	push   $0x7b
  jmp alltraps
80108b19:	e9 64 f5 ff ff       	jmp    80108082 <alltraps>

80108b1e <vector124>:
.globl vector124
vector124:
  pushl $0
80108b1e:	6a 00                	push   $0x0
  pushl $124
80108b20:	6a 7c                	push   $0x7c
  jmp alltraps
80108b22:	e9 5b f5 ff ff       	jmp    80108082 <alltraps>

80108b27 <vector125>:
.globl vector125
vector125:
  pushl $0
80108b27:	6a 00                	push   $0x0
  pushl $125
80108b29:	6a 7d                	push   $0x7d
  jmp alltraps
80108b2b:	e9 52 f5 ff ff       	jmp    80108082 <alltraps>

80108b30 <vector126>:
.globl vector126
vector126:
  pushl $0
80108b30:	6a 00                	push   $0x0
  pushl $126
80108b32:	6a 7e                	push   $0x7e
  jmp alltraps
80108b34:	e9 49 f5 ff ff       	jmp    80108082 <alltraps>

80108b39 <vector127>:
.globl vector127
vector127:
  pushl $0
80108b39:	6a 00                	push   $0x0
  pushl $127
80108b3b:	6a 7f                	push   $0x7f
  jmp alltraps
80108b3d:	e9 40 f5 ff ff       	jmp    80108082 <alltraps>

80108b42 <vector128>:
.globl vector128
vector128:
  pushl $0
80108b42:	6a 00                	push   $0x0
  pushl $128
80108b44:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108b49:	e9 34 f5 ff ff       	jmp    80108082 <alltraps>

80108b4e <vector129>:
.globl vector129
vector129:
  pushl $0
80108b4e:	6a 00                	push   $0x0
  pushl $129
80108b50:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108b55:	e9 28 f5 ff ff       	jmp    80108082 <alltraps>

80108b5a <vector130>:
.globl vector130
vector130:
  pushl $0
80108b5a:	6a 00                	push   $0x0
  pushl $130
80108b5c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108b61:	e9 1c f5 ff ff       	jmp    80108082 <alltraps>

80108b66 <vector131>:
.globl vector131
vector131:
  pushl $0
80108b66:	6a 00                	push   $0x0
  pushl $131
80108b68:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108b6d:	e9 10 f5 ff ff       	jmp    80108082 <alltraps>

80108b72 <vector132>:
.globl vector132
vector132:
  pushl $0
80108b72:	6a 00                	push   $0x0
  pushl $132
80108b74:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108b79:	e9 04 f5 ff ff       	jmp    80108082 <alltraps>

80108b7e <vector133>:
.globl vector133
vector133:
  pushl $0
80108b7e:	6a 00                	push   $0x0
  pushl $133
80108b80:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108b85:	e9 f8 f4 ff ff       	jmp    80108082 <alltraps>

80108b8a <vector134>:
.globl vector134
vector134:
  pushl $0
80108b8a:	6a 00                	push   $0x0
  pushl $134
80108b8c:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108b91:	e9 ec f4 ff ff       	jmp    80108082 <alltraps>

80108b96 <vector135>:
.globl vector135
vector135:
  pushl $0
80108b96:	6a 00                	push   $0x0
  pushl $135
80108b98:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108b9d:	e9 e0 f4 ff ff       	jmp    80108082 <alltraps>

80108ba2 <vector136>:
.globl vector136
vector136:
  pushl $0
80108ba2:	6a 00                	push   $0x0
  pushl $136
80108ba4:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108ba9:	e9 d4 f4 ff ff       	jmp    80108082 <alltraps>

80108bae <vector137>:
.globl vector137
vector137:
  pushl $0
80108bae:	6a 00                	push   $0x0
  pushl $137
80108bb0:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108bb5:	e9 c8 f4 ff ff       	jmp    80108082 <alltraps>

80108bba <vector138>:
.globl vector138
vector138:
  pushl $0
80108bba:	6a 00                	push   $0x0
  pushl $138
80108bbc:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108bc1:	e9 bc f4 ff ff       	jmp    80108082 <alltraps>

80108bc6 <vector139>:
.globl vector139
vector139:
  pushl $0
80108bc6:	6a 00                	push   $0x0
  pushl $139
80108bc8:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108bcd:	e9 b0 f4 ff ff       	jmp    80108082 <alltraps>

80108bd2 <vector140>:
.globl vector140
vector140:
  pushl $0
80108bd2:	6a 00                	push   $0x0
  pushl $140
80108bd4:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108bd9:	e9 a4 f4 ff ff       	jmp    80108082 <alltraps>

80108bde <vector141>:
.globl vector141
vector141:
  pushl $0
80108bde:	6a 00                	push   $0x0
  pushl $141
80108be0:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108be5:	e9 98 f4 ff ff       	jmp    80108082 <alltraps>

80108bea <vector142>:
.globl vector142
vector142:
  pushl $0
80108bea:	6a 00                	push   $0x0
  pushl $142
80108bec:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108bf1:	e9 8c f4 ff ff       	jmp    80108082 <alltraps>

80108bf6 <vector143>:
.globl vector143
vector143:
  pushl $0
80108bf6:	6a 00                	push   $0x0
  pushl $143
80108bf8:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108bfd:	e9 80 f4 ff ff       	jmp    80108082 <alltraps>

80108c02 <vector144>:
.globl vector144
vector144:
  pushl $0
80108c02:	6a 00                	push   $0x0
  pushl $144
80108c04:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108c09:	e9 74 f4 ff ff       	jmp    80108082 <alltraps>

80108c0e <vector145>:
.globl vector145
vector145:
  pushl $0
80108c0e:	6a 00                	push   $0x0
  pushl $145
80108c10:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108c15:	e9 68 f4 ff ff       	jmp    80108082 <alltraps>

80108c1a <vector146>:
.globl vector146
vector146:
  pushl $0
80108c1a:	6a 00                	push   $0x0
  pushl $146
80108c1c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108c21:	e9 5c f4 ff ff       	jmp    80108082 <alltraps>

80108c26 <vector147>:
.globl vector147
vector147:
  pushl $0
80108c26:	6a 00                	push   $0x0
  pushl $147
80108c28:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108c2d:	e9 50 f4 ff ff       	jmp    80108082 <alltraps>

80108c32 <vector148>:
.globl vector148
vector148:
  pushl $0
80108c32:	6a 00                	push   $0x0
  pushl $148
80108c34:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108c39:	e9 44 f4 ff ff       	jmp    80108082 <alltraps>

80108c3e <vector149>:
.globl vector149
vector149:
  pushl $0
80108c3e:	6a 00                	push   $0x0
  pushl $149
80108c40:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108c45:	e9 38 f4 ff ff       	jmp    80108082 <alltraps>

80108c4a <vector150>:
.globl vector150
vector150:
  pushl $0
80108c4a:	6a 00                	push   $0x0
  pushl $150
80108c4c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108c51:	e9 2c f4 ff ff       	jmp    80108082 <alltraps>

80108c56 <vector151>:
.globl vector151
vector151:
  pushl $0
80108c56:	6a 00                	push   $0x0
  pushl $151
80108c58:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108c5d:	e9 20 f4 ff ff       	jmp    80108082 <alltraps>

80108c62 <vector152>:
.globl vector152
vector152:
  pushl $0
80108c62:	6a 00                	push   $0x0
  pushl $152
80108c64:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108c69:	e9 14 f4 ff ff       	jmp    80108082 <alltraps>

80108c6e <vector153>:
.globl vector153
vector153:
  pushl $0
80108c6e:	6a 00                	push   $0x0
  pushl $153
80108c70:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108c75:	e9 08 f4 ff ff       	jmp    80108082 <alltraps>

80108c7a <vector154>:
.globl vector154
vector154:
  pushl $0
80108c7a:	6a 00                	push   $0x0
  pushl $154
80108c7c:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108c81:	e9 fc f3 ff ff       	jmp    80108082 <alltraps>

80108c86 <vector155>:
.globl vector155
vector155:
  pushl $0
80108c86:	6a 00                	push   $0x0
  pushl $155
80108c88:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108c8d:	e9 f0 f3 ff ff       	jmp    80108082 <alltraps>

80108c92 <vector156>:
.globl vector156
vector156:
  pushl $0
80108c92:	6a 00                	push   $0x0
  pushl $156
80108c94:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108c99:	e9 e4 f3 ff ff       	jmp    80108082 <alltraps>

80108c9e <vector157>:
.globl vector157
vector157:
  pushl $0
80108c9e:	6a 00                	push   $0x0
  pushl $157
80108ca0:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108ca5:	e9 d8 f3 ff ff       	jmp    80108082 <alltraps>

80108caa <vector158>:
.globl vector158
vector158:
  pushl $0
80108caa:	6a 00                	push   $0x0
  pushl $158
80108cac:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108cb1:	e9 cc f3 ff ff       	jmp    80108082 <alltraps>

80108cb6 <vector159>:
.globl vector159
vector159:
  pushl $0
80108cb6:	6a 00                	push   $0x0
  pushl $159
80108cb8:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108cbd:	e9 c0 f3 ff ff       	jmp    80108082 <alltraps>

80108cc2 <vector160>:
.globl vector160
vector160:
  pushl $0
80108cc2:	6a 00                	push   $0x0
  pushl $160
80108cc4:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108cc9:	e9 b4 f3 ff ff       	jmp    80108082 <alltraps>

80108cce <vector161>:
.globl vector161
vector161:
  pushl $0
80108cce:	6a 00                	push   $0x0
  pushl $161
80108cd0:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108cd5:	e9 a8 f3 ff ff       	jmp    80108082 <alltraps>

80108cda <vector162>:
.globl vector162
vector162:
  pushl $0
80108cda:	6a 00                	push   $0x0
  pushl $162
80108cdc:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108ce1:	e9 9c f3 ff ff       	jmp    80108082 <alltraps>

80108ce6 <vector163>:
.globl vector163
vector163:
  pushl $0
80108ce6:	6a 00                	push   $0x0
  pushl $163
80108ce8:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108ced:	e9 90 f3 ff ff       	jmp    80108082 <alltraps>

80108cf2 <vector164>:
.globl vector164
vector164:
  pushl $0
80108cf2:	6a 00                	push   $0x0
  pushl $164
80108cf4:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108cf9:	e9 84 f3 ff ff       	jmp    80108082 <alltraps>

80108cfe <vector165>:
.globl vector165
vector165:
  pushl $0
80108cfe:	6a 00                	push   $0x0
  pushl $165
80108d00:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108d05:	e9 78 f3 ff ff       	jmp    80108082 <alltraps>

80108d0a <vector166>:
.globl vector166
vector166:
  pushl $0
80108d0a:	6a 00                	push   $0x0
  pushl $166
80108d0c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108d11:	e9 6c f3 ff ff       	jmp    80108082 <alltraps>

80108d16 <vector167>:
.globl vector167
vector167:
  pushl $0
80108d16:	6a 00                	push   $0x0
  pushl $167
80108d18:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108d1d:	e9 60 f3 ff ff       	jmp    80108082 <alltraps>

80108d22 <vector168>:
.globl vector168
vector168:
  pushl $0
80108d22:	6a 00                	push   $0x0
  pushl $168
80108d24:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108d29:	e9 54 f3 ff ff       	jmp    80108082 <alltraps>

80108d2e <vector169>:
.globl vector169
vector169:
  pushl $0
80108d2e:	6a 00                	push   $0x0
  pushl $169
80108d30:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108d35:	e9 48 f3 ff ff       	jmp    80108082 <alltraps>

80108d3a <vector170>:
.globl vector170
vector170:
  pushl $0
80108d3a:	6a 00                	push   $0x0
  pushl $170
80108d3c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108d41:	e9 3c f3 ff ff       	jmp    80108082 <alltraps>

80108d46 <vector171>:
.globl vector171
vector171:
  pushl $0
80108d46:	6a 00                	push   $0x0
  pushl $171
80108d48:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108d4d:	e9 30 f3 ff ff       	jmp    80108082 <alltraps>

80108d52 <vector172>:
.globl vector172
vector172:
  pushl $0
80108d52:	6a 00                	push   $0x0
  pushl $172
80108d54:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108d59:	e9 24 f3 ff ff       	jmp    80108082 <alltraps>

80108d5e <vector173>:
.globl vector173
vector173:
  pushl $0
80108d5e:	6a 00                	push   $0x0
  pushl $173
80108d60:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108d65:	e9 18 f3 ff ff       	jmp    80108082 <alltraps>

80108d6a <vector174>:
.globl vector174
vector174:
  pushl $0
80108d6a:	6a 00                	push   $0x0
  pushl $174
80108d6c:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108d71:	e9 0c f3 ff ff       	jmp    80108082 <alltraps>

80108d76 <vector175>:
.globl vector175
vector175:
  pushl $0
80108d76:	6a 00                	push   $0x0
  pushl $175
80108d78:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108d7d:	e9 00 f3 ff ff       	jmp    80108082 <alltraps>

80108d82 <vector176>:
.globl vector176
vector176:
  pushl $0
80108d82:	6a 00                	push   $0x0
  pushl $176
80108d84:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108d89:	e9 f4 f2 ff ff       	jmp    80108082 <alltraps>

80108d8e <vector177>:
.globl vector177
vector177:
  pushl $0
80108d8e:	6a 00                	push   $0x0
  pushl $177
80108d90:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108d95:	e9 e8 f2 ff ff       	jmp    80108082 <alltraps>

80108d9a <vector178>:
.globl vector178
vector178:
  pushl $0
80108d9a:	6a 00                	push   $0x0
  pushl $178
80108d9c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108da1:	e9 dc f2 ff ff       	jmp    80108082 <alltraps>

80108da6 <vector179>:
.globl vector179
vector179:
  pushl $0
80108da6:	6a 00                	push   $0x0
  pushl $179
80108da8:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108dad:	e9 d0 f2 ff ff       	jmp    80108082 <alltraps>

80108db2 <vector180>:
.globl vector180
vector180:
  pushl $0
80108db2:	6a 00                	push   $0x0
  pushl $180
80108db4:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108db9:	e9 c4 f2 ff ff       	jmp    80108082 <alltraps>

80108dbe <vector181>:
.globl vector181
vector181:
  pushl $0
80108dbe:	6a 00                	push   $0x0
  pushl $181
80108dc0:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108dc5:	e9 b8 f2 ff ff       	jmp    80108082 <alltraps>

80108dca <vector182>:
.globl vector182
vector182:
  pushl $0
80108dca:	6a 00                	push   $0x0
  pushl $182
80108dcc:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108dd1:	e9 ac f2 ff ff       	jmp    80108082 <alltraps>

80108dd6 <vector183>:
.globl vector183
vector183:
  pushl $0
80108dd6:	6a 00                	push   $0x0
  pushl $183
80108dd8:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108ddd:	e9 a0 f2 ff ff       	jmp    80108082 <alltraps>

80108de2 <vector184>:
.globl vector184
vector184:
  pushl $0
80108de2:	6a 00                	push   $0x0
  pushl $184
80108de4:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108de9:	e9 94 f2 ff ff       	jmp    80108082 <alltraps>

80108dee <vector185>:
.globl vector185
vector185:
  pushl $0
80108dee:	6a 00                	push   $0x0
  pushl $185
80108df0:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108df5:	e9 88 f2 ff ff       	jmp    80108082 <alltraps>

80108dfa <vector186>:
.globl vector186
vector186:
  pushl $0
80108dfa:	6a 00                	push   $0x0
  pushl $186
80108dfc:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108e01:	e9 7c f2 ff ff       	jmp    80108082 <alltraps>

80108e06 <vector187>:
.globl vector187
vector187:
  pushl $0
80108e06:	6a 00                	push   $0x0
  pushl $187
80108e08:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108e0d:	e9 70 f2 ff ff       	jmp    80108082 <alltraps>

80108e12 <vector188>:
.globl vector188
vector188:
  pushl $0
80108e12:	6a 00                	push   $0x0
  pushl $188
80108e14:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108e19:	e9 64 f2 ff ff       	jmp    80108082 <alltraps>

80108e1e <vector189>:
.globl vector189
vector189:
  pushl $0
80108e1e:	6a 00                	push   $0x0
  pushl $189
80108e20:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108e25:	e9 58 f2 ff ff       	jmp    80108082 <alltraps>

80108e2a <vector190>:
.globl vector190
vector190:
  pushl $0
80108e2a:	6a 00                	push   $0x0
  pushl $190
80108e2c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108e31:	e9 4c f2 ff ff       	jmp    80108082 <alltraps>

80108e36 <vector191>:
.globl vector191
vector191:
  pushl $0
80108e36:	6a 00                	push   $0x0
  pushl $191
80108e38:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108e3d:	e9 40 f2 ff ff       	jmp    80108082 <alltraps>

80108e42 <vector192>:
.globl vector192
vector192:
  pushl $0
80108e42:	6a 00                	push   $0x0
  pushl $192
80108e44:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108e49:	e9 34 f2 ff ff       	jmp    80108082 <alltraps>

80108e4e <vector193>:
.globl vector193
vector193:
  pushl $0
80108e4e:	6a 00                	push   $0x0
  pushl $193
80108e50:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108e55:	e9 28 f2 ff ff       	jmp    80108082 <alltraps>

80108e5a <vector194>:
.globl vector194
vector194:
  pushl $0
80108e5a:	6a 00                	push   $0x0
  pushl $194
80108e5c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108e61:	e9 1c f2 ff ff       	jmp    80108082 <alltraps>

80108e66 <vector195>:
.globl vector195
vector195:
  pushl $0
80108e66:	6a 00                	push   $0x0
  pushl $195
80108e68:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108e6d:	e9 10 f2 ff ff       	jmp    80108082 <alltraps>

80108e72 <vector196>:
.globl vector196
vector196:
  pushl $0
80108e72:	6a 00                	push   $0x0
  pushl $196
80108e74:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108e79:	e9 04 f2 ff ff       	jmp    80108082 <alltraps>

80108e7e <vector197>:
.globl vector197
vector197:
  pushl $0
80108e7e:	6a 00                	push   $0x0
  pushl $197
80108e80:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108e85:	e9 f8 f1 ff ff       	jmp    80108082 <alltraps>

80108e8a <vector198>:
.globl vector198
vector198:
  pushl $0
80108e8a:	6a 00                	push   $0x0
  pushl $198
80108e8c:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108e91:	e9 ec f1 ff ff       	jmp    80108082 <alltraps>

80108e96 <vector199>:
.globl vector199
vector199:
  pushl $0
80108e96:	6a 00                	push   $0x0
  pushl $199
80108e98:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108e9d:	e9 e0 f1 ff ff       	jmp    80108082 <alltraps>

80108ea2 <vector200>:
.globl vector200
vector200:
  pushl $0
80108ea2:	6a 00                	push   $0x0
  pushl $200
80108ea4:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108ea9:	e9 d4 f1 ff ff       	jmp    80108082 <alltraps>

80108eae <vector201>:
.globl vector201
vector201:
  pushl $0
80108eae:	6a 00                	push   $0x0
  pushl $201
80108eb0:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108eb5:	e9 c8 f1 ff ff       	jmp    80108082 <alltraps>

80108eba <vector202>:
.globl vector202
vector202:
  pushl $0
80108eba:	6a 00                	push   $0x0
  pushl $202
80108ebc:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108ec1:	e9 bc f1 ff ff       	jmp    80108082 <alltraps>

80108ec6 <vector203>:
.globl vector203
vector203:
  pushl $0
80108ec6:	6a 00                	push   $0x0
  pushl $203
80108ec8:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108ecd:	e9 b0 f1 ff ff       	jmp    80108082 <alltraps>

80108ed2 <vector204>:
.globl vector204
vector204:
  pushl $0
80108ed2:	6a 00                	push   $0x0
  pushl $204
80108ed4:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108ed9:	e9 a4 f1 ff ff       	jmp    80108082 <alltraps>

80108ede <vector205>:
.globl vector205
vector205:
  pushl $0
80108ede:	6a 00                	push   $0x0
  pushl $205
80108ee0:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108ee5:	e9 98 f1 ff ff       	jmp    80108082 <alltraps>

80108eea <vector206>:
.globl vector206
vector206:
  pushl $0
80108eea:	6a 00                	push   $0x0
  pushl $206
80108eec:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108ef1:	e9 8c f1 ff ff       	jmp    80108082 <alltraps>

80108ef6 <vector207>:
.globl vector207
vector207:
  pushl $0
80108ef6:	6a 00                	push   $0x0
  pushl $207
80108ef8:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108efd:	e9 80 f1 ff ff       	jmp    80108082 <alltraps>

80108f02 <vector208>:
.globl vector208
vector208:
  pushl $0
80108f02:	6a 00                	push   $0x0
  pushl $208
80108f04:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108f09:	e9 74 f1 ff ff       	jmp    80108082 <alltraps>

80108f0e <vector209>:
.globl vector209
vector209:
  pushl $0
80108f0e:	6a 00                	push   $0x0
  pushl $209
80108f10:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108f15:	e9 68 f1 ff ff       	jmp    80108082 <alltraps>

80108f1a <vector210>:
.globl vector210
vector210:
  pushl $0
80108f1a:	6a 00                	push   $0x0
  pushl $210
80108f1c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108f21:	e9 5c f1 ff ff       	jmp    80108082 <alltraps>

80108f26 <vector211>:
.globl vector211
vector211:
  pushl $0
80108f26:	6a 00                	push   $0x0
  pushl $211
80108f28:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108f2d:	e9 50 f1 ff ff       	jmp    80108082 <alltraps>

80108f32 <vector212>:
.globl vector212
vector212:
  pushl $0
80108f32:	6a 00                	push   $0x0
  pushl $212
80108f34:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108f39:	e9 44 f1 ff ff       	jmp    80108082 <alltraps>

80108f3e <vector213>:
.globl vector213
vector213:
  pushl $0
80108f3e:	6a 00                	push   $0x0
  pushl $213
80108f40:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108f45:	e9 38 f1 ff ff       	jmp    80108082 <alltraps>

80108f4a <vector214>:
.globl vector214
vector214:
  pushl $0
80108f4a:	6a 00                	push   $0x0
  pushl $214
80108f4c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108f51:	e9 2c f1 ff ff       	jmp    80108082 <alltraps>

80108f56 <vector215>:
.globl vector215
vector215:
  pushl $0
80108f56:	6a 00                	push   $0x0
  pushl $215
80108f58:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108f5d:	e9 20 f1 ff ff       	jmp    80108082 <alltraps>

80108f62 <vector216>:
.globl vector216
vector216:
  pushl $0
80108f62:	6a 00                	push   $0x0
  pushl $216
80108f64:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108f69:	e9 14 f1 ff ff       	jmp    80108082 <alltraps>

80108f6e <vector217>:
.globl vector217
vector217:
  pushl $0
80108f6e:	6a 00                	push   $0x0
  pushl $217
80108f70:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108f75:	e9 08 f1 ff ff       	jmp    80108082 <alltraps>

80108f7a <vector218>:
.globl vector218
vector218:
  pushl $0
80108f7a:	6a 00                	push   $0x0
  pushl $218
80108f7c:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108f81:	e9 fc f0 ff ff       	jmp    80108082 <alltraps>

80108f86 <vector219>:
.globl vector219
vector219:
  pushl $0
80108f86:	6a 00                	push   $0x0
  pushl $219
80108f88:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108f8d:	e9 f0 f0 ff ff       	jmp    80108082 <alltraps>

80108f92 <vector220>:
.globl vector220
vector220:
  pushl $0
80108f92:	6a 00                	push   $0x0
  pushl $220
80108f94:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108f99:	e9 e4 f0 ff ff       	jmp    80108082 <alltraps>

80108f9e <vector221>:
.globl vector221
vector221:
  pushl $0
80108f9e:	6a 00                	push   $0x0
  pushl $221
80108fa0:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108fa5:	e9 d8 f0 ff ff       	jmp    80108082 <alltraps>

80108faa <vector222>:
.globl vector222
vector222:
  pushl $0
80108faa:	6a 00                	push   $0x0
  pushl $222
80108fac:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108fb1:	e9 cc f0 ff ff       	jmp    80108082 <alltraps>

80108fb6 <vector223>:
.globl vector223
vector223:
  pushl $0
80108fb6:	6a 00                	push   $0x0
  pushl $223
80108fb8:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108fbd:	e9 c0 f0 ff ff       	jmp    80108082 <alltraps>

80108fc2 <vector224>:
.globl vector224
vector224:
  pushl $0
80108fc2:	6a 00                	push   $0x0
  pushl $224
80108fc4:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108fc9:	e9 b4 f0 ff ff       	jmp    80108082 <alltraps>

80108fce <vector225>:
.globl vector225
vector225:
  pushl $0
80108fce:	6a 00                	push   $0x0
  pushl $225
80108fd0:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108fd5:	e9 a8 f0 ff ff       	jmp    80108082 <alltraps>

80108fda <vector226>:
.globl vector226
vector226:
  pushl $0
80108fda:	6a 00                	push   $0x0
  pushl $226
80108fdc:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108fe1:	e9 9c f0 ff ff       	jmp    80108082 <alltraps>

80108fe6 <vector227>:
.globl vector227
vector227:
  pushl $0
80108fe6:	6a 00                	push   $0x0
  pushl $227
80108fe8:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108fed:	e9 90 f0 ff ff       	jmp    80108082 <alltraps>

80108ff2 <vector228>:
.globl vector228
vector228:
  pushl $0
80108ff2:	6a 00                	push   $0x0
  pushl $228
80108ff4:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108ff9:	e9 84 f0 ff ff       	jmp    80108082 <alltraps>

80108ffe <vector229>:
.globl vector229
vector229:
  pushl $0
80108ffe:	6a 00                	push   $0x0
  pushl $229
80109000:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80109005:	e9 78 f0 ff ff       	jmp    80108082 <alltraps>

8010900a <vector230>:
.globl vector230
vector230:
  pushl $0
8010900a:	6a 00                	push   $0x0
  pushl $230
8010900c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80109011:	e9 6c f0 ff ff       	jmp    80108082 <alltraps>

80109016 <vector231>:
.globl vector231
vector231:
  pushl $0
80109016:	6a 00                	push   $0x0
  pushl $231
80109018:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010901d:	e9 60 f0 ff ff       	jmp    80108082 <alltraps>

80109022 <vector232>:
.globl vector232
vector232:
  pushl $0
80109022:	6a 00                	push   $0x0
  pushl $232
80109024:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80109029:	e9 54 f0 ff ff       	jmp    80108082 <alltraps>

8010902e <vector233>:
.globl vector233
vector233:
  pushl $0
8010902e:	6a 00                	push   $0x0
  pushl $233
80109030:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80109035:	e9 48 f0 ff ff       	jmp    80108082 <alltraps>

8010903a <vector234>:
.globl vector234
vector234:
  pushl $0
8010903a:	6a 00                	push   $0x0
  pushl $234
8010903c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80109041:	e9 3c f0 ff ff       	jmp    80108082 <alltraps>

80109046 <vector235>:
.globl vector235
vector235:
  pushl $0
80109046:	6a 00                	push   $0x0
  pushl $235
80109048:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010904d:	e9 30 f0 ff ff       	jmp    80108082 <alltraps>

80109052 <vector236>:
.globl vector236
vector236:
  pushl $0
80109052:	6a 00                	push   $0x0
  pushl $236
80109054:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80109059:	e9 24 f0 ff ff       	jmp    80108082 <alltraps>

8010905e <vector237>:
.globl vector237
vector237:
  pushl $0
8010905e:	6a 00                	push   $0x0
  pushl $237
80109060:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80109065:	e9 18 f0 ff ff       	jmp    80108082 <alltraps>

8010906a <vector238>:
.globl vector238
vector238:
  pushl $0
8010906a:	6a 00                	push   $0x0
  pushl $238
8010906c:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80109071:	e9 0c f0 ff ff       	jmp    80108082 <alltraps>

80109076 <vector239>:
.globl vector239
vector239:
  pushl $0
80109076:	6a 00                	push   $0x0
  pushl $239
80109078:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010907d:	e9 00 f0 ff ff       	jmp    80108082 <alltraps>

80109082 <vector240>:
.globl vector240
vector240:
  pushl $0
80109082:	6a 00                	push   $0x0
  pushl $240
80109084:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80109089:	e9 f4 ef ff ff       	jmp    80108082 <alltraps>

8010908e <vector241>:
.globl vector241
vector241:
  pushl $0
8010908e:	6a 00                	push   $0x0
  pushl $241
80109090:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80109095:	e9 e8 ef ff ff       	jmp    80108082 <alltraps>

8010909a <vector242>:
.globl vector242
vector242:
  pushl $0
8010909a:	6a 00                	push   $0x0
  pushl $242
8010909c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801090a1:	e9 dc ef ff ff       	jmp    80108082 <alltraps>

801090a6 <vector243>:
.globl vector243
vector243:
  pushl $0
801090a6:	6a 00                	push   $0x0
  pushl $243
801090a8:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801090ad:	e9 d0 ef ff ff       	jmp    80108082 <alltraps>

801090b2 <vector244>:
.globl vector244
vector244:
  pushl $0
801090b2:	6a 00                	push   $0x0
  pushl $244
801090b4:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801090b9:	e9 c4 ef ff ff       	jmp    80108082 <alltraps>

801090be <vector245>:
.globl vector245
vector245:
  pushl $0
801090be:	6a 00                	push   $0x0
  pushl $245
801090c0:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801090c5:	e9 b8 ef ff ff       	jmp    80108082 <alltraps>

801090ca <vector246>:
.globl vector246
vector246:
  pushl $0
801090ca:	6a 00                	push   $0x0
  pushl $246
801090cc:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801090d1:	e9 ac ef ff ff       	jmp    80108082 <alltraps>

801090d6 <vector247>:
.globl vector247
vector247:
  pushl $0
801090d6:	6a 00                	push   $0x0
  pushl $247
801090d8:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801090dd:	e9 a0 ef ff ff       	jmp    80108082 <alltraps>

801090e2 <vector248>:
.globl vector248
vector248:
  pushl $0
801090e2:	6a 00                	push   $0x0
  pushl $248
801090e4:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801090e9:	e9 94 ef ff ff       	jmp    80108082 <alltraps>

801090ee <vector249>:
.globl vector249
vector249:
  pushl $0
801090ee:	6a 00                	push   $0x0
  pushl $249
801090f0:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801090f5:	e9 88 ef ff ff       	jmp    80108082 <alltraps>

801090fa <vector250>:
.globl vector250
vector250:
  pushl $0
801090fa:	6a 00                	push   $0x0
  pushl $250
801090fc:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80109101:	e9 7c ef ff ff       	jmp    80108082 <alltraps>

80109106 <vector251>:
.globl vector251
vector251:
  pushl $0
80109106:	6a 00                	push   $0x0
  pushl $251
80109108:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010910d:	e9 70 ef ff ff       	jmp    80108082 <alltraps>

80109112 <vector252>:
.globl vector252
vector252:
  pushl $0
80109112:	6a 00                	push   $0x0
  pushl $252
80109114:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80109119:	e9 64 ef ff ff       	jmp    80108082 <alltraps>

8010911e <vector253>:
.globl vector253
vector253:
  pushl $0
8010911e:	6a 00                	push   $0x0
  pushl $253
80109120:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80109125:	e9 58 ef ff ff       	jmp    80108082 <alltraps>

8010912a <vector254>:
.globl vector254
vector254:
  pushl $0
8010912a:	6a 00                	push   $0x0
  pushl $254
8010912c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80109131:	e9 4c ef ff ff       	jmp    80108082 <alltraps>

80109136 <vector255>:
.globl vector255
vector255:
  pushl $0
80109136:	6a 00                	push   $0x0
  pushl $255
80109138:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010913d:	e9 40 ef ff ff       	jmp    80108082 <alltraps>

80109142 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80109142:	55                   	push   %ebp
80109143:	89 e5                	mov    %esp,%ebp
80109145:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80109148:	8b 45 0c             	mov    0xc(%ebp),%eax
8010914b:	83 e8 01             	sub    $0x1,%eax
8010914e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80109152:	8b 45 08             	mov    0x8(%ebp),%eax
80109155:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80109159:	8b 45 08             	mov    0x8(%ebp),%eax
8010915c:	c1 e8 10             	shr    $0x10,%eax
8010915f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80109163:	8d 45 fa             	lea    -0x6(%ebp),%eax
80109166:	0f 01 10             	lgdtl  (%eax)
}
80109169:	90                   	nop
8010916a:	c9                   	leave  
8010916b:	c3                   	ret    

8010916c <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
8010916c:	55                   	push   %ebp
8010916d:	89 e5                	mov    %esp,%ebp
8010916f:	83 ec 04             	sub    $0x4,%esp
80109172:	8b 45 08             	mov    0x8(%ebp),%eax
80109175:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80109179:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010917d:	0f 00 d8             	ltr    %ax
}
80109180:	90                   	nop
80109181:	c9                   	leave  
80109182:	c3                   	ret    

80109183 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80109183:	55                   	push   %ebp
80109184:	89 e5                	mov    %esp,%ebp
80109186:	83 ec 04             	sub    $0x4,%esp
80109189:	8b 45 08             	mov    0x8(%ebp),%eax
8010918c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80109190:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109194:	8e e8                	mov    %eax,%gs
}
80109196:	90                   	nop
80109197:	c9                   	leave  
80109198:	c3                   	ret    

80109199 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80109199:	55                   	push   %ebp
8010919a:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010919c:	8b 45 08             	mov    0x8(%ebp),%eax
8010919f:	0f 22 d8             	mov    %eax,%cr3
}
801091a2:	90                   	nop
801091a3:	5d                   	pop    %ebp
801091a4:	c3                   	ret    

801091a5 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801091a5:	55                   	push   %ebp
801091a6:	89 e5                	mov    %esp,%ebp
801091a8:	8b 45 08             	mov    0x8(%ebp),%eax
801091ab:	05 00 00 00 80       	add    $0x80000000,%eax
801091b0:	5d                   	pop    %ebp
801091b1:	c3                   	ret    

801091b2 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801091b2:	55                   	push   %ebp
801091b3:	89 e5                	mov    %esp,%ebp
801091b5:	8b 45 08             	mov    0x8(%ebp),%eax
801091b8:	05 00 00 00 80       	add    $0x80000000,%eax
801091bd:	5d                   	pop    %ebp
801091be:	c3                   	ret    

801091bf <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801091bf:	55                   	push   %ebp
801091c0:	89 e5                	mov    %esp,%ebp
801091c2:	53                   	push   %ebx
801091c3:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801091c6:	e8 b2 9e ff ff       	call   8010307d <cpunum>
801091cb:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801091d1:	05 80 43 11 80       	add    $0x80114380,%eax
801091d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801091d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091dc:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801091e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091e5:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801091eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091ee:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801091f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091f5:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801091f9:	83 e2 f0             	and    $0xfffffff0,%edx
801091fc:	83 ca 0a             	or     $0xa,%edx
801091ff:	88 50 7d             	mov    %dl,0x7d(%eax)
80109202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109205:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109209:	83 ca 10             	or     $0x10,%edx
8010920c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010920f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109212:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109216:	83 e2 9f             	and    $0xffffff9f,%edx
80109219:	88 50 7d             	mov    %dl,0x7d(%eax)
8010921c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010921f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109223:	83 ca 80             	or     $0xffffff80,%edx
80109226:	88 50 7d             	mov    %dl,0x7d(%eax)
80109229:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010922c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109230:	83 ca 0f             	or     $0xf,%edx
80109233:	88 50 7e             	mov    %dl,0x7e(%eax)
80109236:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109239:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010923d:	83 e2 ef             	and    $0xffffffef,%edx
80109240:	88 50 7e             	mov    %dl,0x7e(%eax)
80109243:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109246:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010924a:	83 e2 df             	and    $0xffffffdf,%edx
8010924d:	88 50 7e             	mov    %dl,0x7e(%eax)
80109250:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109253:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109257:	83 ca 40             	or     $0x40,%edx
8010925a:	88 50 7e             	mov    %dl,0x7e(%eax)
8010925d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109260:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109264:	83 ca 80             	or     $0xffffff80,%edx
80109267:	88 50 7e             	mov    %dl,0x7e(%eax)
8010926a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010926d:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80109271:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109274:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010927b:	ff ff 
8010927d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109280:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80109287:	00 00 
80109289:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010928c:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80109293:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109296:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010929d:	83 e2 f0             	and    $0xfffffff0,%edx
801092a0:	83 ca 02             	or     $0x2,%edx
801092a3:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801092a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092ac:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801092b3:	83 ca 10             	or     $0x10,%edx
801092b6:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801092bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092bf:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801092c6:	83 e2 9f             	and    $0xffffff9f,%edx
801092c9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801092cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092d2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801092d9:	83 ca 80             	or     $0xffffff80,%edx
801092dc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801092e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092e5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801092ec:	83 ca 0f             	or     $0xf,%edx
801092ef:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801092f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092f8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801092ff:	83 e2 ef             	and    $0xffffffef,%edx
80109302:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010930b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109312:	83 e2 df             	and    $0xffffffdf,%edx
80109315:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010931b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010931e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109325:	83 ca 40             	or     $0x40,%edx
80109328:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010932e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109331:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109338:	83 ca 80             	or     $0xffffff80,%edx
8010933b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109341:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109344:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010934b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010934e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80109355:	ff ff 
80109357:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010935a:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80109361:	00 00 
80109363:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109366:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010936d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109370:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109377:	83 e2 f0             	and    $0xfffffff0,%edx
8010937a:	83 ca 0a             	or     $0xa,%edx
8010937d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109386:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010938d:	83 ca 10             	or     $0x10,%edx
80109390:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109399:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801093a0:	83 ca 60             	or     $0x60,%edx
801093a3:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801093a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093ac:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801093b3:	83 ca 80             	or     $0xffffff80,%edx
801093b6:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801093bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093bf:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093c6:	83 ca 0f             	or     $0xf,%edx
801093c9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093d2:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093d9:	83 e2 ef             	and    $0xffffffef,%edx
801093dc:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093e5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093ec:	83 e2 df             	and    $0xffffffdf,%edx
801093ef:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093f8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093ff:	83 ca 40             	or     $0x40,%edx
80109402:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109408:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010940b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109412:	83 ca 80             	or     $0xffffff80,%edx
80109415:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010941b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010941e:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80109425:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109428:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010942f:	ff ff 
80109431:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109434:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010943b:	00 00 
8010943d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109440:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80109447:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010944a:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109451:	83 e2 f0             	and    $0xfffffff0,%edx
80109454:	83 ca 02             	or     $0x2,%edx
80109457:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010945d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109460:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109467:	83 ca 10             	or     $0x10,%edx
8010946a:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109470:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109473:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010947a:	83 ca 60             	or     $0x60,%edx
8010947d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109483:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109486:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010948d:	83 ca 80             	or     $0xffffff80,%edx
80109490:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109496:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109499:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094a0:	83 ca 0f             	or     $0xf,%edx
801094a3:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ac:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094b3:	83 e2 ef             	and    $0xffffffef,%edx
801094b6:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094bf:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094c6:	83 e2 df             	and    $0xffffffdf,%edx
801094c9:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094d2:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094d9:	83 ca 40             	or     $0x40,%edx
801094dc:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094e5:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094ec:	83 ca 80             	or     $0xffffff80,%edx
801094ef:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094f8:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801094ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109502:	05 b4 00 00 00       	add    $0xb4,%eax
80109507:	89 c3                	mov    %eax,%ebx
80109509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010950c:	05 b4 00 00 00       	add    $0xb4,%eax
80109511:	c1 e8 10             	shr    $0x10,%eax
80109514:	89 c2                	mov    %eax,%edx
80109516:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109519:	05 b4 00 00 00       	add    $0xb4,%eax
8010951e:	c1 e8 18             	shr    $0x18,%eax
80109521:	89 c1                	mov    %eax,%ecx
80109523:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109526:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010952d:	00 00 
8010952f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109532:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80109539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010953c:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80109542:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109545:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010954c:	83 e2 f0             	and    $0xfffffff0,%edx
8010954f:	83 ca 02             	or     $0x2,%edx
80109552:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109558:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010955b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109562:	83 ca 10             	or     $0x10,%edx
80109565:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010956b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010956e:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109575:	83 e2 9f             	and    $0xffffff9f,%edx
80109578:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010957e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109581:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109588:	83 ca 80             	or     $0xffffff80,%edx
8010958b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109591:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109594:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010959b:	83 e2 f0             	and    $0xfffffff0,%edx
8010959e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095a7:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801095ae:	83 e2 ef             	and    $0xffffffef,%edx
801095b1:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ba:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801095c1:	83 e2 df             	and    $0xffffffdf,%edx
801095c4:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095cd:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801095d4:	83 ca 40             	or     $0x40,%edx
801095d7:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e0:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801095e7:	83 ca 80             	or     $0xffffff80,%edx
801095ea:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f3:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801095f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095fc:	83 c0 70             	add    $0x70,%eax
801095ff:	83 ec 08             	sub    $0x8,%esp
80109602:	6a 38                	push   $0x38
80109604:	50                   	push   %eax
80109605:	e8 38 fb ff ff       	call   80109142 <lgdt>
8010960a:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010960d:	83 ec 0c             	sub    $0xc,%esp
80109610:	6a 18                	push   $0x18
80109612:	e8 6c fb ff ff       	call   80109183 <loadgs>
80109617:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
8010961a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010961d:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80109623:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010962a:	00 00 00 00 
}
8010962e:	90                   	nop
8010962f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109632:	c9                   	leave  
80109633:	c3                   	ret    

80109634 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80109634:	55                   	push   %ebp
80109635:	89 e5                	mov    %esp,%ebp
80109637:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010963a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010963d:	c1 e8 16             	shr    $0x16,%eax
80109640:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109647:	8b 45 08             	mov    0x8(%ebp),%eax
8010964a:	01 d0                	add    %edx,%eax
8010964c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010964f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109652:	8b 00                	mov    (%eax),%eax
80109654:	83 e0 01             	and    $0x1,%eax
80109657:	85 c0                	test   %eax,%eax
80109659:	74 18                	je     80109673 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
8010965b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010965e:	8b 00                	mov    (%eax),%eax
80109660:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109665:	50                   	push   %eax
80109666:	e8 47 fb ff ff       	call   801091b2 <p2v>
8010966b:	83 c4 04             	add    $0x4,%esp
8010966e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109671:	eb 48                	jmp    801096bb <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80109673:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80109677:	74 0e                	je     80109687 <walkpgdir+0x53>
80109679:	e8 99 96 ff ff       	call   80102d17 <kalloc>
8010967e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109681:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109685:	75 07                	jne    8010968e <walkpgdir+0x5a>
      return 0;
80109687:	b8 00 00 00 00       	mov    $0x0,%eax
8010968c:	eb 44                	jmp    801096d2 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010968e:	83 ec 04             	sub    $0x4,%esp
80109691:	68 00 10 00 00       	push   $0x1000
80109696:	6a 00                	push   $0x0
80109698:	ff 75 f4             	pushl  -0xc(%ebp)
8010969b:	e8 38 d4 ff ff       	call   80106ad8 <memset>
801096a0:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801096a3:	83 ec 0c             	sub    $0xc,%esp
801096a6:	ff 75 f4             	pushl  -0xc(%ebp)
801096a9:	e8 f7 fa ff ff       	call   801091a5 <v2p>
801096ae:	83 c4 10             	add    $0x10,%esp
801096b1:	83 c8 07             	or     $0x7,%eax
801096b4:	89 c2                	mov    %eax,%edx
801096b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096b9:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801096bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801096be:	c1 e8 0c             	shr    $0xc,%eax
801096c1:	25 ff 03 00 00       	and    $0x3ff,%eax
801096c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801096cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096d0:	01 d0                	add    %edx,%eax
}
801096d2:	c9                   	leave  
801096d3:	c3                   	ret    

801096d4 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801096d4:	55                   	push   %ebp
801096d5:	89 e5                	mov    %esp,%ebp
801096d7:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801096da:	8b 45 0c             	mov    0xc(%ebp),%eax
801096dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801096e5:	8b 55 0c             	mov    0xc(%ebp),%edx
801096e8:	8b 45 10             	mov    0x10(%ebp),%eax
801096eb:	01 d0                	add    %edx,%eax
801096ed:	83 e8 01             	sub    $0x1,%eax
801096f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801096f8:	83 ec 04             	sub    $0x4,%esp
801096fb:	6a 01                	push   $0x1
801096fd:	ff 75 f4             	pushl  -0xc(%ebp)
80109700:	ff 75 08             	pushl  0x8(%ebp)
80109703:	e8 2c ff ff ff       	call   80109634 <walkpgdir>
80109708:	83 c4 10             	add    $0x10,%esp
8010970b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010970e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109712:	75 07                	jne    8010971b <mappages+0x47>
      return -1;
80109714:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109719:	eb 47                	jmp    80109762 <mappages+0x8e>
    if(*pte & PTE_P)
8010971b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010971e:	8b 00                	mov    (%eax),%eax
80109720:	83 e0 01             	and    $0x1,%eax
80109723:	85 c0                	test   %eax,%eax
80109725:	74 0d                	je     80109734 <mappages+0x60>
      panic("remap");
80109727:	83 ec 0c             	sub    $0xc,%esp
8010972a:	68 a0 ac 10 80       	push   $0x8010aca0
8010972f:	e8 32 6e ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80109734:	8b 45 18             	mov    0x18(%ebp),%eax
80109737:	0b 45 14             	or     0x14(%ebp),%eax
8010973a:	83 c8 01             	or     $0x1,%eax
8010973d:	89 c2                	mov    %eax,%edx
8010973f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109742:	89 10                	mov    %edx,(%eax)
    if(a == last)
80109744:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109747:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010974a:	74 10                	je     8010975c <mappages+0x88>
      break;
    a += PGSIZE;
8010974c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80109753:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010975a:	eb 9c                	jmp    801096f8 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
8010975c:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010975d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109762:	c9                   	leave  
80109763:	c3                   	ret    

80109764 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80109764:	55                   	push   %ebp
80109765:	89 e5                	mov    %esp,%ebp
80109767:	53                   	push   %ebx
80109768:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010976b:	e8 a7 95 ff ff       	call   80102d17 <kalloc>
80109770:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109773:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109777:	75 0a                	jne    80109783 <setupkvm+0x1f>
    return 0;
80109779:	b8 00 00 00 00       	mov    $0x0,%eax
8010977e:	e9 8e 00 00 00       	jmp    80109811 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80109783:	83 ec 04             	sub    $0x4,%esp
80109786:	68 00 10 00 00       	push   $0x1000
8010978b:	6a 00                	push   $0x0
8010978d:	ff 75 f0             	pushl  -0x10(%ebp)
80109790:	e8 43 d3 ff ff       	call   80106ad8 <memset>
80109795:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80109798:	83 ec 0c             	sub    $0xc,%esp
8010979b:	68 00 00 00 0e       	push   $0xe000000
801097a0:	e8 0d fa ff ff       	call   801091b2 <p2v>
801097a5:	83 c4 10             	add    $0x10,%esp
801097a8:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801097ad:	76 0d                	jbe    801097bc <setupkvm+0x58>
    panic("PHYSTOP too high");
801097af:	83 ec 0c             	sub    $0xc,%esp
801097b2:	68 a6 ac 10 80       	push   $0x8010aca6
801097b7:	e8 aa 6d ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801097bc:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
801097c3:	eb 40                	jmp    80109805 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801097c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097c8:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801097cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097ce:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801097d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097d4:	8b 58 08             	mov    0x8(%eax),%ebx
801097d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097da:	8b 40 04             	mov    0x4(%eax),%eax
801097dd:	29 c3                	sub    %eax,%ebx
801097df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097e2:	8b 00                	mov    (%eax),%eax
801097e4:	83 ec 0c             	sub    $0xc,%esp
801097e7:	51                   	push   %ecx
801097e8:	52                   	push   %edx
801097e9:	53                   	push   %ebx
801097ea:	50                   	push   %eax
801097eb:	ff 75 f0             	pushl  -0x10(%ebp)
801097ee:	e8 e1 fe ff ff       	call   801096d4 <mappages>
801097f3:	83 c4 20             	add    $0x20,%esp
801097f6:	85 c0                	test   %eax,%eax
801097f8:	79 07                	jns    80109801 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801097fa:	b8 00 00 00 00       	mov    $0x0,%eax
801097ff:	eb 10                	jmp    80109811 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109801:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80109805:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
8010980c:	72 b7                	jb     801097c5 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010980e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109811:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109814:	c9                   	leave  
80109815:	c3                   	ret    

80109816 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80109816:	55                   	push   %ebp
80109817:	89 e5                	mov    %esp,%ebp
80109819:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010981c:	e8 43 ff ff ff       	call   80109764 <setupkvm>
80109821:	a3 38 79 11 80       	mov    %eax,0x80117938
  switchkvm();
80109826:	e8 03 00 00 00       	call   8010982e <switchkvm>
}
8010982b:	90                   	nop
8010982c:	c9                   	leave  
8010982d:	c3                   	ret    

8010982e <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010982e:	55                   	push   %ebp
8010982f:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109831:	a1 38 79 11 80       	mov    0x80117938,%eax
80109836:	50                   	push   %eax
80109837:	e8 69 f9 ff ff       	call   801091a5 <v2p>
8010983c:	83 c4 04             	add    $0x4,%esp
8010983f:	50                   	push   %eax
80109840:	e8 54 f9 ff ff       	call   80109199 <lcr3>
80109845:	83 c4 04             	add    $0x4,%esp
}
80109848:	90                   	nop
80109849:	c9                   	leave  
8010984a:	c3                   	ret    

8010984b <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010984b:	55                   	push   %ebp
8010984c:	89 e5                	mov    %esp,%ebp
8010984e:	56                   	push   %esi
8010984f:	53                   	push   %ebx
  pushcli();
80109850:	e8 7d d1 ff ff       	call   801069d2 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80109855:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010985b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109862:	83 c2 08             	add    $0x8,%edx
80109865:	89 d6                	mov    %edx,%esi
80109867:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010986e:	83 c2 08             	add    $0x8,%edx
80109871:	c1 ea 10             	shr    $0x10,%edx
80109874:	89 d3                	mov    %edx,%ebx
80109876:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010987d:	83 c2 08             	add    $0x8,%edx
80109880:	c1 ea 18             	shr    $0x18,%edx
80109883:	89 d1                	mov    %edx,%ecx
80109885:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010988c:	67 00 
8010988e:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80109895:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
8010989b:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801098a2:	83 e2 f0             	and    $0xfffffff0,%edx
801098a5:	83 ca 09             	or     $0x9,%edx
801098a8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801098ae:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801098b5:	83 ca 10             	or     $0x10,%edx
801098b8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801098be:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801098c5:	83 e2 9f             	and    $0xffffff9f,%edx
801098c8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801098ce:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801098d5:	83 ca 80             	or     $0xffffff80,%edx
801098d8:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801098de:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098e5:	83 e2 f0             	and    $0xfffffff0,%edx
801098e8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801098ee:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098f5:	83 e2 ef             	and    $0xffffffef,%edx
801098f8:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801098fe:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109905:	83 e2 df             	and    $0xffffffdf,%edx
80109908:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010990e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109915:	83 ca 40             	or     $0x40,%edx
80109918:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010991e:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109925:	83 e2 7f             	and    $0x7f,%edx
80109928:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
8010992e:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80109934:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010993a:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109941:	83 e2 ef             	and    $0xffffffef,%edx
80109944:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
8010994a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109950:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80109956:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010995c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80109963:	8b 52 08             	mov    0x8(%edx),%edx
80109966:	81 c2 00 10 00 00    	add    $0x1000,%edx
8010996c:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
8010996f:	83 ec 0c             	sub    $0xc,%esp
80109972:	6a 30                	push   $0x30
80109974:	e8 f3 f7 ff ff       	call   8010916c <ltr>
80109979:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
8010997c:	8b 45 08             	mov    0x8(%ebp),%eax
8010997f:	8b 40 04             	mov    0x4(%eax),%eax
80109982:	85 c0                	test   %eax,%eax
80109984:	75 0d                	jne    80109993 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80109986:	83 ec 0c             	sub    $0xc,%esp
80109989:	68 b7 ac 10 80       	push   $0x8010acb7
8010998e:	e8 d3 6b ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80109993:	8b 45 08             	mov    0x8(%ebp),%eax
80109996:	8b 40 04             	mov    0x4(%eax),%eax
80109999:	83 ec 0c             	sub    $0xc,%esp
8010999c:	50                   	push   %eax
8010999d:	e8 03 f8 ff ff       	call   801091a5 <v2p>
801099a2:	83 c4 10             	add    $0x10,%esp
801099a5:	83 ec 0c             	sub    $0xc,%esp
801099a8:	50                   	push   %eax
801099a9:	e8 eb f7 ff ff       	call   80109199 <lcr3>
801099ae:	83 c4 10             	add    $0x10,%esp
  popcli();
801099b1:	e8 61 d0 ff ff       	call   80106a17 <popcli>
}
801099b6:	90                   	nop
801099b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801099ba:	5b                   	pop    %ebx
801099bb:	5e                   	pop    %esi
801099bc:	5d                   	pop    %ebp
801099bd:	c3                   	ret    

801099be <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801099be:	55                   	push   %ebp
801099bf:	89 e5                	mov    %esp,%ebp
801099c1:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
801099c4:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801099cb:	76 0d                	jbe    801099da <inituvm+0x1c>
    panic("inituvm: more than a page");
801099cd:	83 ec 0c             	sub    $0xc,%esp
801099d0:	68 cb ac 10 80       	push   $0x8010accb
801099d5:	e8 8c 6b ff ff       	call   80100566 <panic>
  mem = kalloc();
801099da:	e8 38 93 ff ff       	call   80102d17 <kalloc>
801099df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801099e2:	83 ec 04             	sub    $0x4,%esp
801099e5:	68 00 10 00 00       	push   $0x1000
801099ea:	6a 00                	push   $0x0
801099ec:	ff 75 f4             	pushl  -0xc(%ebp)
801099ef:	e8 e4 d0 ff ff       	call   80106ad8 <memset>
801099f4:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801099f7:	83 ec 0c             	sub    $0xc,%esp
801099fa:	ff 75 f4             	pushl  -0xc(%ebp)
801099fd:	e8 a3 f7 ff ff       	call   801091a5 <v2p>
80109a02:	83 c4 10             	add    $0x10,%esp
80109a05:	83 ec 0c             	sub    $0xc,%esp
80109a08:	6a 06                	push   $0x6
80109a0a:	50                   	push   %eax
80109a0b:	68 00 10 00 00       	push   $0x1000
80109a10:	6a 00                	push   $0x0
80109a12:	ff 75 08             	pushl  0x8(%ebp)
80109a15:	e8 ba fc ff ff       	call   801096d4 <mappages>
80109a1a:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109a1d:	83 ec 04             	sub    $0x4,%esp
80109a20:	ff 75 10             	pushl  0x10(%ebp)
80109a23:	ff 75 0c             	pushl  0xc(%ebp)
80109a26:	ff 75 f4             	pushl  -0xc(%ebp)
80109a29:	e8 69 d1 ff ff       	call   80106b97 <memmove>
80109a2e:	83 c4 10             	add    $0x10,%esp
}
80109a31:	90                   	nop
80109a32:	c9                   	leave  
80109a33:	c3                   	ret    

80109a34 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80109a34:	55                   	push   %ebp
80109a35:	89 e5                	mov    %esp,%ebp
80109a37:	53                   	push   %ebx
80109a38:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80109a3e:	25 ff 0f 00 00       	and    $0xfff,%eax
80109a43:	85 c0                	test   %eax,%eax
80109a45:	74 0d                	je     80109a54 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80109a47:	83 ec 0c             	sub    $0xc,%esp
80109a4a:	68 e8 ac 10 80       	push   $0x8010ace8
80109a4f:	e8 12 6b ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109a54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109a5b:	e9 95 00 00 00       	jmp    80109af5 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109a60:	8b 55 0c             	mov    0xc(%ebp),%edx
80109a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a66:	01 d0                	add    %edx,%eax
80109a68:	83 ec 04             	sub    $0x4,%esp
80109a6b:	6a 00                	push   $0x0
80109a6d:	50                   	push   %eax
80109a6e:	ff 75 08             	pushl  0x8(%ebp)
80109a71:	e8 be fb ff ff       	call   80109634 <walkpgdir>
80109a76:	83 c4 10             	add    $0x10,%esp
80109a79:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109a7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109a80:	75 0d                	jne    80109a8f <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109a82:	83 ec 0c             	sub    $0xc,%esp
80109a85:	68 0b ad 10 80       	push   $0x8010ad0b
80109a8a:	e8 d7 6a ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a92:	8b 00                	mov    (%eax),%eax
80109a94:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109a99:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109a9c:	8b 45 18             	mov    0x18(%ebp),%eax
80109a9f:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109aa2:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109aa7:	77 0b                	ja     80109ab4 <loaduvm+0x80>
      n = sz - i;
80109aa9:	8b 45 18             	mov    0x18(%ebp),%eax
80109aac:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109aaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109ab2:	eb 07                	jmp    80109abb <loaduvm+0x87>
    else
      n = PGSIZE;
80109ab4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109abb:	8b 55 14             	mov    0x14(%ebp),%edx
80109abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ac1:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109ac4:	83 ec 0c             	sub    $0xc,%esp
80109ac7:	ff 75 e8             	pushl  -0x18(%ebp)
80109aca:	e8 e3 f6 ff ff       	call   801091b2 <p2v>
80109acf:	83 c4 10             	add    $0x10,%esp
80109ad2:	ff 75 f0             	pushl  -0x10(%ebp)
80109ad5:	53                   	push   %ebx
80109ad6:	50                   	push   %eax
80109ad7:	ff 75 10             	pushl  0x10(%ebp)
80109ada:	e8 aa 84 ff ff       	call   80101f89 <readi>
80109adf:	83 c4 10             	add    $0x10,%esp
80109ae2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109ae5:	74 07                	je     80109aee <loaduvm+0xba>
      return -1;
80109ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109aec:	eb 18                	jmp    80109b06 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109aee:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109af8:	3b 45 18             	cmp    0x18(%ebp),%eax
80109afb:	0f 82 5f ff ff ff    	jb     80109a60 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109b01:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109b06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109b09:	c9                   	leave  
80109b0a:	c3                   	ret    

80109b0b <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109b0b:	55                   	push   %ebp
80109b0c:	89 e5                	mov    %esp,%ebp
80109b0e:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109b11:	8b 45 10             	mov    0x10(%ebp),%eax
80109b14:	85 c0                	test   %eax,%eax
80109b16:	79 0a                	jns    80109b22 <allocuvm+0x17>
    return 0;
80109b18:	b8 00 00 00 00       	mov    $0x0,%eax
80109b1d:	e9 b0 00 00 00       	jmp    80109bd2 <allocuvm+0xc7>
  if(newsz < oldsz)
80109b22:	8b 45 10             	mov    0x10(%ebp),%eax
80109b25:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109b28:	73 08                	jae    80109b32 <allocuvm+0x27>
    return oldsz;
80109b2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b2d:	e9 a0 00 00 00       	jmp    80109bd2 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109b32:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b35:	05 ff 0f 00 00       	add    $0xfff,%eax
80109b3a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109b42:	eb 7f                	jmp    80109bc3 <allocuvm+0xb8>
    mem = kalloc();
80109b44:	e8 ce 91 ff ff       	call   80102d17 <kalloc>
80109b49:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109b4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109b50:	75 2b                	jne    80109b7d <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109b52:	83 ec 0c             	sub    $0xc,%esp
80109b55:	68 29 ad 10 80       	push   $0x8010ad29
80109b5a:	e8 67 68 ff ff       	call   801003c6 <cprintf>
80109b5f:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109b62:	83 ec 04             	sub    $0x4,%esp
80109b65:	ff 75 0c             	pushl  0xc(%ebp)
80109b68:	ff 75 10             	pushl  0x10(%ebp)
80109b6b:	ff 75 08             	pushl  0x8(%ebp)
80109b6e:	e8 61 00 00 00       	call   80109bd4 <deallocuvm>
80109b73:	83 c4 10             	add    $0x10,%esp
      return 0;
80109b76:	b8 00 00 00 00       	mov    $0x0,%eax
80109b7b:	eb 55                	jmp    80109bd2 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109b7d:	83 ec 04             	sub    $0x4,%esp
80109b80:	68 00 10 00 00       	push   $0x1000
80109b85:	6a 00                	push   $0x0
80109b87:	ff 75 f0             	pushl  -0x10(%ebp)
80109b8a:	e8 49 cf ff ff       	call   80106ad8 <memset>
80109b8f:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109b92:	83 ec 0c             	sub    $0xc,%esp
80109b95:	ff 75 f0             	pushl  -0x10(%ebp)
80109b98:	e8 08 f6 ff ff       	call   801091a5 <v2p>
80109b9d:	83 c4 10             	add    $0x10,%esp
80109ba0:	89 c2                	mov    %eax,%edx
80109ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ba5:	83 ec 0c             	sub    $0xc,%esp
80109ba8:	6a 06                	push   $0x6
80109baa:	52                   	push   %edx
80109bab:	68 00 10 00 00       	push   $0x1000
80109bb0:	50                   	push   %eax
80109bb1:	ff 75 08             	pushl  0x8(%ebp)
80109bb4:	e8 1b fb ff ff       	call   801096d4 <mappages>
80109bb9:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109bbc:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bc6:	3b 45 10             	cmp    0x10(%ebp),%eax
80109bc9:	0f 82 75 ff ff ff    	jb     80109b44 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109bcf:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109bd2:	c9                   	leave  
80109bd3:	c3                   	ret    

80109bd4 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109bd4:	55                   	push   %ebp
80109bd5:	89 e5                	mov    %esp,%ebp
80109bd7:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109bda:	8b 45 10             	mov    0x10(%ebp),%eax
80109bdd:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109be0:	72 08                	jb     80109bea <deallocuvm+0x16>
    return oldsz;
80109be2:	8b 45 0c             	mov    0xc(%ebp),%eax
80109be5:	e9 a5 00 00 00       	jmp    80109c8f <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109bea:	8b 45 10             	mov    0x10(%ebp),%eax
80109bed:	05 ff 0f 00 00       	add    $0xfff,%eax
80109bf2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109bfa:	e9 81 00 00 00       	jmp    80109c80 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c02:	83 ec 04             	sub    $0x4,%esp
80109c05:	6a 00                	push   $0x0
80109c07:	50                   	push   %eax
80109c08:	ff 75 08             	pushl  0x8(%ebp)
80109c0b:	e8 24 fa ff ff       	call   80109634 <walkpgdir>
80109c10:	83 c4 10             	add    $0x10,%esp
80109c13:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109c16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109c1a:	75 09                	jne    80109c25 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109c1c:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109c23:	eb 54                	jmp    80109c79 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c28:	8b 00                	mov    (%eax),%eax
80109c2a:	83 e0 01             	and    $0x1,%eax
80109c2d:	85 c0                	test   %eax,%eax
80109c2f:	74 48                	je     80109c79 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109c31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c34:	8b 00                	mov    (%eax),%eax
80109c36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109c3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109c3e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109c42:	75 0d                	jne    80109c51 <deallocuvm+0x7d>
        panic("kfree");
80109c44:	83 ec 0c             	sub    $0xc,%esp
80109c47:	68 41 ad 10 80       	push   $0x8010ad41
80109c4c:	e8 15 69 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109c51:	83 ec 0c             	sub    $0xc,%esp
80109c54:	ff 75 ec             	pushl  -0x14(%ebp)
80109c57:	e8 56 f5 ff ff       	call   801091b2 <p2v>
80109c5c:	83 c4 10             	add    $0x10,%esp
80109c5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109c62:	83 ec 0c             	sub    $0xc,%esp
80109c65:	ff 75 e8             	pushl  -0x18(%ebp)
80109c68:	e8 0d 90 ff ff       	call   80102c7a <kfree>
80109c6d:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c73:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109c79:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c83:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109c86:	0f 82 73 ff ff ff    	jb     80109bff <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109c8c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109c8f:	c9                   	leave  
80109c90:	c3                   	ret    

80109c91 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109c91:	55                   	push   %ebp
80109c92:	89 e5                	mov    %esp,%ebp
80109c94:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109c97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109c9b:	75 0d                	jne    80109caa <freevm+0x19>
    panic("freevm: no pgdir");
80109c9d:	83 ec 0c             	sub    $0xc,%esp
80109ca0:	68 47 ad 10 80       	push   $0x8010ad47
80109ca5:	e8 bc 68 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109caa:	83 ec 04             	sub    $0x4,%esp
80109cad:	6a 00                	push   $0x0
80109caf:	68 00 00 00 80       	push   $0x80000000
80109cb4:	ff 75 08             	pushl  0x8(%ebp)
80109cb7:	e8 18 ff ff ff       	call   80109bd4 <deallocuvm>
80109cbc:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109cbf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109cc6:	eb 4f                	jmp    80109d17 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ccb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109cd2:	8b 45 08             	mov    0x8(%ebp),%eax
80109cd5:	01 d0                	add    %edx,%eax
80109cd7:	8b 00                	mov    (%eax),%eax
80109cd9:	83 e0 01             	and    $0x1,%eax
80109cdc:	85 c0                	test   %eax,%eax
80109cde:	74 33                	je     80109d13 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ce3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109cea:	8b 45 08             	mov    0x8(%ebp),%eax
80109ced:	01 d0                	add    %edx,%eax
80109cef:	8b 00                	mov    (%eax),%eax
80109cf1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109cf6:	83 ec 0c             	sub    $0xc,%esp
80109cf9:	50                   	push   %eax
80109cfa:	e8 b3 f4 ff ff       	call   801091b2 <p2v>
80109cff:	83 c4 10             	add    $0x10,%esp
80109d02:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109d05:	83 ec 0c             	sub    $0xc,%esp
80109d08:	ff 75 f0             	pushl  -0x10(%ebp)
80109d0b:	e8 6a 8f ff ff       	call   80102c7a <kfree>
80109d10:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109d13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109d17:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109d1e:	76 a8                	jbe    80109cc8 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109d20:	83 ec 0c             	sub    $0xc,%esp
80109d23:	ff 75 08             	pushl  0x8(%ebp)
80109d26:	e8 4f 8f ff ff       	call   80102c7a <kfree>
80109d2b:	83 c4 10             	add    $0x10,%esp
}
80109d2e:	90                   	nop
80109d2f:	c9                   	leave  
80109d30:	c3                   	ret    

80109d31 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109d31:	55                   	push   %ebp
80109d32:	89 e5                	mov    %esp,%ebp
80109d34:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109d37:	83 ec 04             	sub    $0x4,%esp
80109d3a:	6a 00                	push   $0x0
80109d3c:	ff 75 0c             	pushl  0xc(%ebp)
80109d3f:	ff 75 08             	pushl  0x8(%ebp)
80109d42:	e8 ed f8 ff ff       	call   80109634 <walkpgdir>
80109d47:	83 c4 10             	add    $0x10,%esp
80109d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109d4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109d51:	75 0d                	jne    80109d60 <clearpteu+0x2f>
    panic("clearpteu");
80109d53:	83 ec 0c             	sub    $0xc,%esp
80109d56:	68 58 ad 10 80       	push   $0x8010ad58
80109d5b:	e8 06 68 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d63:	8b 00                	mov    (%eax),%eax
80109d65:	83 e0 fb             	and    $0xfffffffb,%eax
80109d68:	89 c2                	mov    %eax,%edx
80109d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d6d:	89 10                	mov    %edx,(%eax)
}
80109d6f:	90                   	nop
80109d70:	c9                   	leave  
80109d71:	c3                   	ret    

80109d72 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109d72:	55                   	push   %ebp
80109d73:	89 e5                	mov    %esp,%ebp
80109d75:	53                   	push   %ebx
80109d76:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109d79:	e8 e6 f9 ff ff       	call   80109764 <setupkvm>
80109d7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109d81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109d85:	75 0a                	jne    80109d91 <copyuvm+0x1f>
    return 0;
80109d87:	b8 00 00 00 00       	mov    $0x0,%eax
80109d8c:	e9 f8 00 00 00       	jmp    80109e89 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109d91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109d98:	e9 c4 00 00 00       	jmp    80109e61 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109da0:	83 ec 04             	sub    $0x4,%esp
80109da3:	6a 00                	push   $0x0
80109da5:	50                   	push   %eax
80109da6:	ff 75 08             	pushl  0x8(%ebp)
80109da9:	e8 86 f8 ff ff       	call   80109634 <walkpgdir>
80109dae:	83 c4 10             	add    $0x10,%esp
80109db1:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109db4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109db8:	75 0d                	jne    80109dc7 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109dba:	83 ec 0c             	sub    $0xc,%esp
80109dbd:	68 62 ad 10 80       	push   $0x8010ad62
80109dc2:	e8 9f 67 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109dca:	8b 00                	mov    (%eax),%eax
80109dcc:	83 e0 01             	and    $0x1,%eax
80109dcf:	85 c0                	test   %eax,%eax
80109dd1:	75 0d                	jne    80109de0 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109dd3:	83 ec 0c             	sub    $0xc,%esp
80109dd6:	68 7c ad 10 80       	push   $0x8010ad7c
80109ddb:	e8 86 67 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109de0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109de3:	8b 00                	mov    (%eax),%eax
80109de5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109dea:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109ded:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109df0:	8b 00                	mov    (%eax),%eax
80109df2:	25 ff 0f 00 00       	and    $0xfff,%eax
80109df7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109dfa:	e8 18 8f ff ff       	call   80102d17 <kalloc>
80109dff:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109e02:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109e06:	74 6a                	je     80109e72 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109e08:	83 ec 0c             	sub    $0xc,%esp
80109e0b:	ff 75 e8             	pushl  -0x18(%ebp)
80109e0e:	e8 9f f3 ff ff       	call   801091b2 <p2v>
80109e13:	83 c4 10             	add    $0x10,%esp
80109e16:	83 ec 04             	sub    $0x4,%esp
80109e19:	68 00 10 00 00       	push   $0x1000
80109e1e:	50                   	push   %eax
80109e1f:	ff 75 e0             	pushl  -0x20(%ebp)
80109e22:	e8 70 cd ff ff       	call   80106b97 <memmove>
80109e27:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109e2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109e2d:	83 ec 0c             	sub    $0xc,%esp
80109e30:	ff 75 e0             	pushl  -0x20(%ebp)
80109e33:	e8 6d f3 ff ff       	call   801091a5 <v2p>
80109e38:	83 c4 10             	add    $0x10,%esp
80109e3b:	89 c2                	mov    %eax,%edx
80109e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e40:	83 ec 0c             	sub    $0xc,%esp
80109e43:	53                   	push   %ebx
80109e44:	52                   	push   %edx
80109e45:	68 00 10 00 00       	push   $0x1000
80109e4a:	50                   	push   %eax
80109e4b:	ff 75 f0             	pushl  -0x10(%ebp)
80109e4e:	e8 81 f8 ff ff       	call   801096d4 <mappages>
80109e53:	83 c4 20             	add    $0x20,%esp
80109e56:	85 c0                	test   %eax,%eax
80109e58:	78 1b                	js     80109e75 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109e5a:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e64:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109e67:	0f 82 30 ff ff ff    	jb     80109d9d <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e70:	eb 17                	jmp    80109e89 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109e72:	90                   	nop
80109e73:	eb 01                	jmp    80109e76 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80109e75:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80109e76:	83 ec 0c             	sub    $0xc,%esp
80109e79:	ff 75 f0             	pushl  -0x10(%ebp)
80109e7c:	e8 10 fe ff ff       	call   80109c91 <freevm>
80109e81:	83 c4 10             	add    $0x10,%esp
  return 0;
80109e84:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109e89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109e8c:	c9                   	leave  
80109e8d:	c3                   	ret    

80109e8e <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109e8e:	55                   	push   %ebp
80109e8f:	89 e5                	mov    %esp,%ebp
80109e91:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109e94:	83 ec 04             	sub    $0x4,%esp
80109e97:	6a 00                	push   $0x0
80109e99:	ff 75 0c             	pushl  0xc(%ebp)
80109e9c:	ff 75 08             	pushl  0x8(%ebp)
80109e9f:	e8 90 f7 ff ff       	call   80109634 <walkpgdir>
80109ea4:	83 c4 10             	add    $0x10,%esp
80109ea7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ead:	8b 00                	mov    (%eax),%eax
80109eaf:	83 e0 01             	and    $0x1,%eax
80109eb2:	85 c0                	test   %eax,%eax
80109eb4:	75 07                	jne    80109ebd <uva2ka+0x2f>
    return 0;
80109eb6:	b8 00 00 00 00       	mov    $0x0,%eax
80109ebb:	eb 29                	jmp    80109ee6 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ec0:	8b 00                	mov    (%eax),%eax
80109ec2:	83 e0 04             	and    $0x4,%eax
80109ec5:	85 c0                	test   %eax,%eax
80109ec7:	75 07                	jne    80109ed0 <uva2ka+0x42>
    return 0;
80109ec9:	b8 00 00 00 00       	mov    $0x0,%eax
80109ece:	eb 16                	jmp    80109ee6 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80109ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ed3:	8b 00                	mov    (%eax),%eax
80109ed5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109eda:	83 ec 0c             	sub    $0xc,%esp
80109edd:	50                   	push   %eax
80109ede:	e8 cf f2 ff ff       	call   801091b2 <p2v>
80109ee3:	83 c4 10             	add    $0x10,%esp
}
80109ee6:	c9                   	leave  
80109ee7:	c3                   	ret    

80109ee8 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109ee8:	55                   	push   %ebp
80109ee9:	89 e5                	mov    %esp,%ebp
80109eeb:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109eee:	8b 45 10             	mov    0x10(%ebp),%eax
80109ef1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109ef4:	eb 7f                	jmp    80109f75 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80109ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
80109ef9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109efe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109f01:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f04:	83 ec 08             	sub    $0x8,%esp
80109f07:	50                   	push   %eax
80109f08:	ff 75 08             	pushl  0x8(%ebp)
80109f0b:	e8 7e ff ff ff       	call   80109e8e <uva2ka>
80109f10:	83 c4 10             	add    $0x10,%esp
80109f13:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80109f16:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109f1a:	75 07                	jne    80109f23 <copyout+0x3b>
      return -1;
80109f1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109f21:	eb 61                	jmp    80109f84 <copyout+0x9c>
    n = PGSIZE - (va - va0);
80109f23:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f26:	2b 45 0c             	sub    0xc(%ebp),%eax
80109f29:	05 00 10 00 00       	add    $0x1000,%eax
80109f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f34:	3b 45 14             	cmp    0x14(%ebp),%eax
80109f37:	76 06                	jbe    80109f3f <copyout+0x57>
      n = len;
80109f39:	8b 45 14             	mov    0x14(%ebp),%eax
80109f3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109f3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109f42:	2b 45 ec             	sub    -0x14(%ebp),%eax
80109f45:	89 c2                	mov    %eax,%edx
80109f47:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f4a:	01 d0                	add    %edx,%eax
80109f4c:	83 ec 04             	sub    $0x4,%esp
80109f4f:	ff 75 f0             	pushl  -0x10(%ebp)
80109f52:	ff 75 f4             	pushl  -0xc(%ebp)
80109f55:	50                   	push   %eax
80109f56:	e8 3c cc ff ff       	call   80106b97 <memmove>
80109f5b:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f61:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80109f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f67:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109f6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f6d:	05 00 10 00 00       	add    $0x1000,%eax
80109f72:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109f75:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109f79:	0f 85 77 ff ff ff    	jne    80109ef6 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109f84:	c9                   	leave  
80109f85:	c3                   	ret    
