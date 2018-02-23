
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
8010003d:	68 60 9f 10 80       	push   $0x80109f60
80100042:	68 80 e6 10 80       	push   $0x8010e680
80100047:	e8 df 67 00 00       	call   8010682b <initlock>
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
801000c1:	e8 87 67 00 00       	call   8010684d <acquire>
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
8010010c:	e8 a3 67 00 00       	call   801068b4 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 e6 10 80       	push   $0x8010e680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 6c 54 00 00       	call   80105598 <sleep>
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
80100188:	e8 27 67 00 00       	call   801068b4 <release>
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
801001aa:	68 67 9f 10 80       	push   $0x80109f67
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
80100204:	68 78 9f 10 80       	push   $0x80109f78
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
80100243:	68 7f 9f 10 80       	push   $0x80109f7f
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 e6 10 80       	push   $0x8010e680
80100255:	e8 f3 65 00 00       	call   8010684d <acquire>
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
801002b9:	e8 35 55 00 00       	call   801057f3 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 e6 10 80       	push   $0x8010e680
801002c9:	e8 e6 65 00 00       	call   801068b4 <release>
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
801003e2:	e8 66 64 00 00       	call   8010684d <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 86 9f 10 80       	push   $0x80109f86
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
801004cd:	c7 45 ec 8f 9f 10 80 	movl   $0x80109f8f,-0x14(%ebp)
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
8010055b:	e8 54 63 00 00       	call   801068b4 <release>
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
8010058b:	68 96 9f 10 80       	push   $0x80109f96
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
801005aa:	68 a5 9f 10 80       	push   $0x80109fa5
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 3f 63 00 00       	call   80106906 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 a7 9f 10 80       	push   $0x80109fa7
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
801006ca:	68 ab 9f 10 80       	push   $0x80109fab
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
801006f7:	e8 73 64 00 00       	call   80106b6f <memmove>
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
80100721:	e8 8a 63 00 00       	call   80106ab0 <memset>
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
801007b6:	e8 2c 7e 00 00       	call   801085e7 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 1f 7e 00 00       	call   801085e7 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 12 7e 00 00       	call   801085e7 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 02 7e 00 00       	call   801085e7 <uartputc>
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
80100815:	e8 33 60 00 00       	call   8010684d <acquire>
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
801009bf:	e8 2f 4e 00 00       	call   801057f3 <wakeup>
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
801009e2:	e8 cd 5e 00 00       	call   801068b4 <release>
801009e7:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009ee:	74 05                	je     801009f5 <consoleintr+0x1fc>
    procdump();  // now call procdump() wo. cons.lock held
801009f0:	e8 8e 51 00 00       	call   80105b83 <procdump>
  }
#ifdef CS333_P3P4
  // run Ready list display function
  if (ctrlkey == 1) {
801009f5:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
801009f9:	75 0c                	jne    80100a07 <consoleintr+0x20e>
      //cprintf("Ready list not implemented yet..\n");
      printReadyList();
801009fb:	e8 a5 57 00 00       	call   801061a5 <printReadyList>
      ctrlkey = 0;
80100a00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Free list display function
  if (ctrlkey == 2) {
80100a07:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
80100a0b:	75 0c                	jne    80100a19 <consoleintr+0x220>
      printFreeList();
80100a0d:	e8 8c 58 00 00       	call   8010629e <printFreeList>
      ctrlkey = 0;
80100a12:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Sleep list display function
  if (ctrlkey == 3) {
80100a19:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
80100a1d:	75 0c                	jne    80100a2b <consoleintr+0x232>
     // cprintf("Sleep list not implemented yet..\n");
      printSleepList();
80100a1f:	e8 d8 58 00 00       	call   801062fc <printSleepList>
      ctrlkey = 0;
80100a24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Zombie list display function
  if (ctrlkey == 4) {
80100a2b:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a2f:	75 0c                	jne    80100a3d <consoleintr+0x244>
      //cprintf("Zombie list not implemented yet..\n");
      printZombieList();
80100a31:	e8 63 59 00 00       	call   80106399 <printZombieList>
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
80100a62:	e8 e6 5d 00 00       	call   8010684d <acquire>
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
80100a84:	e8 2b 5e 00 00       	call   801068b4 <release>
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
80100ab1:	e8 e2 4a 00 00       	call   80105598 <sleep>
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
80100b2f:	e8 80 5d 00 00       	call   801068b4 <release>
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
80100b6d:	e8 db 5c 00 00       	call   8010684d <acquire>
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
80100baf:	e8 00 5d 00 00       	call   801068b4 <release>
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
80100bd3:	68 be 9f 10 80       	push   $0x80109fbe
80100bd8:	68 e0 d5 10 80       	push   $0x8010d5e0
80100bdd:	e8 49 5c 00 00       	call   8010682b <initlock>
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
80100c9b:	e8 9c 8a 00 00       	call   8010973c <setupkvm>
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
80100d21:	e8 bd 8d 00 00       	call   80109ae3 <allocuvm>
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
80100d54:	e8 b3 8c 00 00       	call   80109a0c <loaduvm>
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
80100dc3:	e8 1b 8d 00 00       	call   80109ae3 <allocuvm>
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
80100de7:	e8 1d 8f 00 00       	call   80109d09 <clearpteu>
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
80100e20:	e8 d8 5e 00 00       	call   80106cfd <strlen>
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
80100e4d:	e8 ab 5e 00 00       	call   80106cfd <strlen>
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
80100e73:	e8 48 90 00 00       	call   80109ec0 <copyout>
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
80100f0f:	e8 ac 8f 00 00       	call   80109ec0 <copyout>
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
80100f60:	e8 4e 5d 00 00       	call   80106cb3 <safestrcpy>
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
80100fb6:	e8 68 88 00 00       	call   80109823 <switchuvm>
80100fbb:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fbe:	83 ec 0c             	sub    $0xc,%esp
80100fc1:	ff 75 d0             	pushl  -0x30(%ebp)
80100fc4:	e8 a0 8c 00 00       	call   80109c69 <freevm>
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
80100ffe:	e8 66 8c 00 00       	call   80109c69 <freevm>
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
8010102f:	68 c6 9f 10 80       	push   $0x80109fc6
80101034:	68 40 28 11 80       	push   $0x80112840
80101039:	e8 ed 57 00 00       	call   8010682b <initlock>
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
80101052:	e8 f6 57 00 00       	call   8010684d <acquire>
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
8010107f:	e8 30 58 00 00       	call   801068b4 <release>
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
801010a2:	e8 0d 58 00 00       	call   801068b4 <release>
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
801010bf:	e8 89 57 00 00       	call   8010684d <acquire>
801010c4:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010c7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ca:	8b 40 04             	mov    0x4(%eax),%eax
801010cd:	85 c0                	test   %eax,%eax
801010cf:	7f 0d                	jg     801010de <filedup+0x2d>
    panic("filedup");
801010d1:	83 ec 0c             	sub    $0xc,%esp
801010d4:	68 cd 9f 10 80       	push   $0x80109fcd
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
801010f5:	e8 ba 57 00 00       	call   801068b4 <release>
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
80101110:	e8 38 57 00 00       	call   8010684d <acquire>
80101115:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101118:	8b 45 08             	mov    0x8(%ebp),%eax
8010111b:	8b 40 04             	mov    0x4(%eax),%eax
8010111e:	85 c0                	test   %eax,%eax
80101120:	7f 0d                	jg     8010112f <fileclose+0x2d>
    panic("fileclose");
80101122:	83 ec 0c             	sub    $0xc,%esp
80101125:	68 d5 9f 10 80       	push   $0x80109fd5
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
80101150:	e8 5f 57 00 00       	call   801068b4 <release>
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
8010119e:	e8 11 57 00 00       	call   801068b4 <release>
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
801012ed:	68 df 9f 10 80       	push   $0x80109fdf
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
801013f0:	68 e8 9f 10 80       	push   $0x80109fe8
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
80101426:	68 f8 9f 10 80       	push   $0x80109ff8
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
8010145e:	e8 0c 57 00 00       	call   80106b6f <memmove>
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
801014a4:	e8 07 56 00 00       	call   80106ab0 <memset>
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
8010160b:	68 04 a0 10 80       	push   $0x8010a004
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
8010169e:	68 1a a0 10 80       	push   $0x8010a01a
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
801016fb:	68 2d a0 10 80       	push   $0x8010a02d
80101700:	68 60 32 11 80       	push   $0x80113260
80101705:	e8 21 51 00 00       	call   8010682b <initlock>
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
80101754:	68 34 a0 10 80       	push   $0x8010a034
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
801017cd:	e8 de 52 00 00       	call   80106ab0 <memset>
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
80101835:	68 87 a0 10 80       	push   $0x8010a087
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
801018db:	e8 8f 52 00 00       	call   80106b6f <memmove>
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
80101910:	e8 38 4f 00 00       	call   8010684d <acquire>
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
8010195e:	e8 51 4f 00 00       	call   801068b4 <release>
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
80101997:	68 99 a0 10 80       	push   $0x8010a099
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
801019d4:	e8 db 4e 00 00       	call   801068b4 <release>
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
801019ef:	e8 59 4e 00 00       	call   8010684d <acquire>
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
80101a0e:	e8 a1 4e 00 00       	call   801068b4 <release>
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
80101a34:	68 a9 a0 10 80       	push   $0x8010a0a9
80101a39:	e8 28 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a3e:	83 ec 0c             	sub    $0xc,%esp
80101a41:	68 60 32 11 80       	push   $0x80113260
80101a46:	e8 02 4e 00 00       	call   8010684d <acquire>
80101a4b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a4e:	eb 13                	jmp    80101a63 <ilock+0x48>
    sleep(ip, &icache.lock);
80101a50:	83 ec 08             	sub    $0x8,%esp
80101a53:	68 60 32 11 80       	push   $0x80113260
80101a58:	ff 75 08             	pushl  0x8(%ebp)
80101a5b:	e8 38 3b 00 00       	call   80105598 <sleep>
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
80101a89:	e8 26 4e 00 00       	call   801068b4 <release>
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
80101b36:	e8 34 50 00 00       	call   80106b6f <memmove>
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
80101b6c:	68 af a0 10 80       	push   $0x8010a0af
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
80101b9f:	68 be a0 10 80       	push   $0x8010a0be
80101ba4:	e8 bd e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101ba9:	83 ec 0c             	sub    $0xc,%esp
80101bac:	68 60 32 11 80       	push   $0x80113260
80101bb1:	e8 97 4c 00 00       	call   8010684d <acquire>
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
80101bd0:	e8 1e 3c 00 00       	call   801057f3 <wakeup>
80101bd5:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bd8:	83 ec 0c             	sub    $0xc,%esp
80101bdb:	68 60 32 11 80       	push   $0x80113260
80101be0:	e8 cf 4c 00 00       	call   801068b4 <release>
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
80101bf9:	e8 4f 4c 00 00       	call   8010684d <acquire>
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
80101c41:	68 c6 a0 10 80       	push   $0x8010a0c6
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
80101c64:	e8 4b 4c 00 00       	call   801068b4 <release>
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
80101c99:	e8 af 4b 00 00       	call   8010684d <acquire>
80101c9e:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101ca1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
80101cae:	ff 75 08             	pushl  0x8(%ebp)
80101cb1:	e8 3d 3b 00 00       	call   801057f3 <wakeup>
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
80101cd0:	e8 df 4b 00 00       	call   801068b4 <release>
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
80101e10:	68 d0 a0 10 80       	push   $0x8010a0d0
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
801020a7:	e8 c3 4a 00 00       	call   80106b6f <memmove>
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
801021f9:	e8 71 49 00 00       	call   80106b6f <memmove>
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
80102279:	e8 87 49 00 00       	call   80106c05 <strncmp>
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
80102299:	68 e3 a0 10 80       	push   $0x8010a0e3
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
801022c8:	68 f5 a0 10 80       	push   $0x8010a0f5
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
8010239d:	68 f5 a0 10 80       	push   $0x8010a0f5
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
801023d8:	e8 7e 48 00 00       	call   80106c5b <strncpy>
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
80102404:	68 02 a1 10 80       	push   $0x8010a102
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
8010247a:	e8 f0 46 00 00       	call   80106b6f <memmove>
8010247f:	83 c4 10             	add    $0x10,%esp
80102482:	eb 26                	jmp    801024aa <skipelem+0x95>
  else {
    memmove(name, s, len);
80102484:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102487:	83 ec 04             	sub    $0x4,%esp
8010248a:	50                   	push   %eax
8010248b:	ff 75 f4             	pushl  -0xc(%ebp)
8010248e:	ff 75 0c             	pushl  0xc(%ebp)
80102491:	e8 d9 46 00 00       	call   80106b6f <memmove>
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
801026e6:	68 0a a1 10 80       	push   $0x8010a10a
801026eb:	68 20 d6 10 80       	push   $0x8010d620
801026f0:	e8 36 41 00 00       	call   8010682b <initlock>
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
8010279a:	68 0e a1 10 80       	push   $0x8010a10e
8010279f:	e8 c2 dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
801027a4:	8b 45 08             	mov    0x8(%ebp),%eax
801027a7:	8b 40 08             	mov    0x8(%eax),%eax
801027aa:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801027af:	76 0d                	jbe    801027be <idestart+0x33>
    panic("incorrect blockno");
801027b1:	83 ec 0c             	sub    $0xc,%esp
801027b4:	68 17 a1 10 80       	push   $0x8010a117
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
801027dd:	68 0e a1 10 80       	push   $0x8010a10e
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
801028f7:	e8 51 3f 00 00       	call   8010684d <acquire>
801028fc:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028ff:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102904:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010290b:	75 15                	jne    80102922 <ideintr+0x39>
    release(&idelock);
8010290d:	83 ec 0c             	sub    $0xc,%esp
80102910:	68 20 d6 10 80       	push   $0x8010d620
80102915:	e8 9a 3f 00 00       	call   801068b4 <release>
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
8010298a:	e8 64 2e 00 00       	call   801057f3 <wakeup>
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
801029b4:	e8 fb 3e 00 00       	call   801068b4 <release>
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
801029d3:	68 29 a1 10 80       	push   $0x8010a129
801029d8:	e8 89 db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029dd:	8b 45 08             	mov    0x8(%ebp),%eax
801029e0:	8b 00                	mov    (%eax),%eax
801029e2:	83 e0 06             	and    $0x6,%eax
801029e5:	83 f8 02             	cmp    $0x2,%eax
801029e8:	75 0d                	jne    801029f7 <iderw+0x39>
    panic("iderw: nothing to do");
801029ea:	83 ec 0c             	sub    $0xc,%esp
801029ed:	68 3d a1 10 80       	push   $0x8010a13d
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
80102a0d:	68 52 a1 10 80       	push   $0x8010a152
80102a12:	e8 4f db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a17:	83 ec 0c             	sub    $0xc,%esp
80102a1a:	68 20 d6 10 80       	push   $0x8010d620
80102a1f:	e8 29 3e 00 00       	call   8010684d <acquire>
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
80102a7b:	e8 18 2b 00 00       	call   80105598 <sleep>
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
80102a98:	e8 17 3e 00 00       	call   801068b4 <release>
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
80102b29:	68 70 a1 10 80       	push   $0x8010a170
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
80102be9:	68 a2 a1 10 80       	push   $0x8010a1a2
80102bee:	68 40 42 11 80       	push   $0x80114240
80102bf3:	e8 33 3c 00 00       	call   8010682b <initlock>
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
80102c8c:	81 7d 08 5c 79 11 80 	cmpl   $0x8011795c,0x8(%ebp)
80102c93:	72 12                	jb     80102ca7 <kfree+0x2d>
80102c95:	ff 75 08             	pushl  0x8(%ebp)
80102c98:	e8 36 ff ff ff       	call   80102bd3 <v2p>
80102c9d:	83 c4 04             	add    $0x4,%esp
80102ca0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102ca5:	76 0d                	jbe    80102cb4 <kfree+0x3a>
    panic("kfree");
80102ca7:	83 ec 0c             	sub    $0xc,%esp
80102caa:	68 a7 a1 10 80       	push   $0x8010a1a7
80102caf:	e8 b2 d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102cb4:	83 ec 04             	sub    $0x4,%esp
80102cb7:	68 00 10 00 00       	push   $0x1000
80102cbc:	6a 01                	push   $0x1
80102cbe:	ff 75 08             	pushl  0x8(%ebp)
80102cc1:	e8 ea 3d 00 00       	call   80106ab0 <memset>
80102cc6:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cc9:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cce:	85 c0                	test   %eax,%eax
80102cd0:	74 10                	je     80102ce2 <kfree+0x68>
    acquire(&kmem.lock);
80102cd2:	83 ec 0c             	sub    $0xc,%esp
80102cd5:	68 40 42 11 80       	push   $0x80114240
80102cda:	e8 6e 3b 00 00       	call   8010684d <acquire>
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
80102d0c:	e8 a3 3b 00 00       	call   801068b4 <release>
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
80102d2e:	e8 1a 3b 00 00       	call   8010684d <acquire>
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
80102d5f:	e8 50 3b 00 00       	call   801068b4 <release>
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
801030aa:	68 b0 a1 10 80       	push   $0x8010a1b0
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
801032d5:	e8 3d 38 00 00       	call   80106b17 <memcmp>
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
801033e9:	68 dc a1 10 80       	push   $0x8010a1dc
801033ee:	68 80 42 11 80       	push   $0x80114280
801033f3:	e8 33 34 00 00       	call   8010682b <initlock>
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
8010349e:	e8 cc 36 00 00       	call   80106b6f <memmove>
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
8010360c:	e8 3c 32 00 00       	call   8010684d <acquire>
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
8010362a:	e8 69 1f 00 00       	call   80105598 <sleep>
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
8010365f:	e8 34 1f 00 00       	call   80105598 <sleep>
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
8010367e:	e8 31 32 00 00       	call   801068b4 <release>
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
8010369f:	e8 a9 31 00 00       	call   8010684d <acquire>
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
801036c0:	68 e0 a1 10 80       	push   $0x8010a1e0
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
801036ee:	e8 00 21 00 00       	call   801057f3 <wakeup>
801036f3:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036f6:	83 ec 0c             	sub    $0xc,%esp
801036f9:	68 80 42 11 80       	push   $0x80114280
801036fe:	e8 b1 31 00 00       	call   801068b4 <release>
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
80103719:	e8 2f 31 00 00       	call   8010684d <acquire>
8010371e:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103721:	c7 05 c0 42 11 80 00 	movl   $0x0,0x801142c0
80103728:	00 00 00 
    wakeup(&log);
8010372b:	83 ec 0c             	sub    $0xc,%esp
8010372e:	68 80 42 11 80       	push   $0x80114280
80103733:	e8 bb 20 00 00       	call   801057f3 <wakeup>
80103738:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	68 80 42 11 80       	push   $0x80114280
80103743:	e8 6c 31 00 00       	call   801068b4 <release>
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
801037bf:	e8 ab 33 00 00       	call   80106b6f <memmove>
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
8010385b:	68 ef a1 10 80       	push   $0x8010a1ef
80103860:	e8 01 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103865:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010386a:	85 c0                	test   %eax,%eax
8010386c:	7f 0d                	jg     8010387b <log_write+0x45>
    panic("log_write outside of trans");
8010386e:	83 ec 0c             	sub    $0xc,%esp
80103871:	68 05 a2 10 80       	push   $0x8010a205
80103876:	e8 eb cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
8010387b:	83 ec 0c             	sub    $0xc,%esp
8010387e:	68 80 42 11 80       	push   $0x80114280
80103883:	e8 c5 2f 00 00       	call   8010684d <acquire>
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
80103901:	e8 ae 2f 00 00       	call   801068b4 <release>
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
80103959:	68 5c 79 11 80       	push   $0x8011795c
8010395e:	e8 7d f2 ff ff       	call   80102be0 <kinit1>
80103963:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103966:	e8 83 5e 00 00       	call   801097ee <kvmalloc>
  mpinit();        // collect info about this machine
8010396b:	e8 43 04 00 00       	call   80103db3 <mpinit>
  lapicinit();
80103970:	e8 ea f5 ff ff       	call   80102f5f <lapicinit>
  seginit();       // set up segments
80103975:	e8 1d 58 00 00       	call   80109197 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010397a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103980:	0f b6 00             	movzbl (%eax),%eax
80103983:	0f b6 c0             	movzbl %al,%eax
80103986:	83 ec 08             	sub    $0x8,%esp
80103989:	50                   	push   %eax
8010398a:	68 20 a2 10 80       	push   $0x8010a220
8010398f:	e8 32 ca ff ff       	call   801003c6 <cprintf>
80103994:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103997:	e8 6d 06 00 00       	call   80104009 <picinit>
  ioapicinit();    // another interrupt controller
8010399c:	e8 34 f1 ff ff       	call   80102ad5 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801039a1:	e8 24 d2 ff ff       	call   80100bca <consoleinit>
  uartinit();      // serial port
801039a6:	e8 48 4b 00 00       	call   801084f3 <uartinit>
  pinit();         // process table
801039ab:	e8 5d 0b 00 00       	call   8010450d <pinit>
  tvinit();        // trap vectors
801039b0:	e8 17 47 00 00       	call   801080cc <tvinit>
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
801039cd:	e8 4b 46 00 00       	call   8010801d <timerinit>
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
801039fc:	e8 05 5e 00 00       	call   80109806 <switchkvm>
  seginit();
80103a01:	e8 91 57 00 00       	call   80109197 <seginit>
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
80103a26:	68 37 a2 10 80       	push   $0x8010a237
80103a2b:	e8 96 c9 ff ff       	call   801003c6 <cprintf>
80103a30:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a33:	e8 f5 47 00 00       	call   8010822d <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a38:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a3e:	05 a8 00 00 00       	add    $0xa8,%eax
80103a43:	83 ec 08             	sub    $0x8,%esp
80103a46:	6a 01                	push   $0x1
80103a48:	50                   	push   %eax
80103a49:	e8 d8 fe ff ff       	call   80103926 <xchg>
80103a4e:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a51:	e8 3b 17 00 00       	call   80105191 <scheduler>

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
80103a7e:	e8 ec 30 00 00       	call   80106b6f <memmove>
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
80103c0c:	68 48 a2 10 80       	push   $0x8010a248
80103c11:	ff 75 f4             	pushl  -0xc(%ebp)
80103c14:	e8 fe 2e 00 00       	call   80106b17 <memcmp>
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
80103d4a:	68 4d a2 10 80       	push   $0x8010a24d
80103d4f:	ff 75 f0             	pushl  -0x10(%ebp)
80103d52:	e8 c0 2d 00 00       	call   80106b17 <memcmp>
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
80103e26:	8b 04 85 90 a2 10 80 	mov    -0x7fef5d70(,%eax,4),%eax
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
80103e5c:	68 52 a2 10 80       	push   $0x8010a252
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
80103eef:	68 70 a2 10 80       	push   $0x8010a270
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
80104190:	68 a4 a2 10 80       	push   $0x8010a2a4
80104195:	50                   	push   %eax
80104196:	e8 90 26 00 00       	call   8010682b <initlock>
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
80104252:	e8 f6 25 00 00       	call   8010684d <acquire>
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
80104279:	e8 75 15 00 00       	call   801057f3 <wakeup>
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
8010429c:	e8 52 15 00 00       	call   801057f3 <wakeup>
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
801042c5:	e8 ea 25 00 00       	call   801068b4 <release>
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
801042e4:	e8 cb 25 00 00       	call   801068b4 <release>
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
801042fc:	e8 4c 25 00 00       	call   8010684d <acquire>
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
80104331:	e8 7e 25 00 00       	call   801068b4 <release>
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
8010434f:	e8 9f 14 00 00       	call   801057f3 <wakeup>
80104354:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104357:	8b 45 08             	mov    0x8(%ebp),%eax
8010435a:	8b 55 08             	mov    0x8(%ebp),%edx
8010435d:	81 c2 38 02 00 00    	add    $0x238,%edx
80104363:	83 ec 08             	sub    $0x8,%esp
80104366:	50                   	push   %eax
80104367:	52                   	push   %edx
80104368:	e8 2b 12 00 00       	call   80105598 <sleep>
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
801043d1:	e8 1d 14 00 00       	call   801057f3 <wakeup>
801043d6:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043d9:	8b 45 08             	mov    0x8(%ebp),%eax
801043dc:	83 ec 0c             	sub    $0xc,%esp
801043df:	50                   	push   %eax
801043e0:	e8 cf 24 00 00       	call   801068b4 <release>
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
801043fb:	e8 4d 24 00 00       	call   8010684d <acquire>
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
80104419:	e8 96 24 00 00       	call   801068b4 <release>
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
8010443c:	e8 57 11 00 00       	call   80105598 <sleep>
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
801044d0:	e8 1e 13 00 00       	call   801057f3 <wakeup>
801044d5:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044d8:	8b 45 08             	mov    0x8(%ebp),%eax
801044db:	83 ec 0c             	sub    $0xc,%esp
801044de:	50                   	push   %eax
801044df:	e8 d0 23 00 00       	call   801068b4 <release>
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
80104516:	68 d6 a2 10 80       	push   $0x8010a2d6
8010451b:	68 80 49 11 80       	push   $0x80114980
80104520:	e8 06 23 00 00       	call   8010682b <initlock>
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
80104539:	e8 0f 23 00 00       	call   8010684d <acquire>
8010453e:	83 c4 10             	add    $0x10,%esp
    p = ptable.pLists.free;
80104541:	a1 d4 70 11 80       	mov    0x801170d4,%eax
80104546:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p) {
80104549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010454d:	75 1a                	jne    80104569 <allocproc+0x3e>
        goto found;
    }
    release(&ptable.lock);
8010454f:	83 ec 0c             	sub    $0xc,%esp
80104552:	68 80 49 11 80       	push   $0x80114980
80104557:	e8 58 23 00 00       	call   801068b4 <release>
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
80104572:	e8 d3 19 00 00       	call   80105f4a <assertState>
80104577:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.free, p) == -1) {
8010457a:	83 ec 08             	sub    $0x8,%esp
8010457d:	ff 75 f4             	pushl  -0xc(%ebp)
80104580:	68 d4 70 11 80       	push   $0x801170d4
80104585:	e8 e1 1a 00 00       	call   8010606b <removeFromStateList>
8010458a:	83 c4 10             	add    $0x10,%esp
8010458d:	83 f8 ff             	cmp    $0xffffffff,%eax
80104590:	75 10                	jne    801045a2 <allocproc+0x77>
        cprintf("Failed to remove proc from UNUSED list (allocproc).\n");
80104592:	83 ec 0c             	sub    $0xc,%esp
80104595:	68 e0 a2 10 80       	push   $0x8010a2e0
8010459a:	e8 27 be ff ff       	call   801003c6 <cprintf>
8010459f:	83 c4 10             	add    $0x10,%esp
    }
    p->state = EMBRYO;
801045a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a5:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    if (addToStateListHead(&ptable.pLists.embryo, p) == -1) {
801045ac:	83 ec 08             	sub    $0x8,%esp
801045af:	ff 75 f4             	pushl  -0xc(%ebp)
801045b2:	68 e4 70 11 80       	push   $0x801170e4
801045b7:	e8 c2 19 00 00       	call   80105f7e <addToStateListHead>
801045bc:	83 c4 10             	add    $0x10,%esp
801045bf:	83 f8 ff             	cmp    $0xffffffff,%eax
801045c2:	75 10                	jne    801045d4 <allocproc+0xa9>
        cprintf("Failed to add proc to EMBRYO list (allocproc).\n");
801045c4:	83 ec 0c             	sub    $0xc,%esp
801045c7:	68 18 a3 10 80       	push   $0x8010a318
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
801045f2:	e8 bd 22 00 00       	call   801068b4 <release>
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
80104619:	e8 2c 19 00 00       	call   80105f4a <assertState>
8010461e:	83 c4 10             	add    $0x10,%esp
        removeFromStateList(&ptable.pLists.embryo, p);
80104621:	83 ec 08             	sub    $0x8,%esp
80104624:	ff 75 f4             	pushl  -0xc(%ebp)
80104627:	68 e4 70 11 80       	push   $0x801170e4
8010462c:	e8 3a 1a 00 00       	call   8010606b <removeFromStateList>
80104631:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104637:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        if (addToStateListHead(&ptable.pLists.free, p) == -1) {
8010463e:	83 ec 08             	sub    $0x8,%esp
80104641:	ff 75 f4             	pushl  -0xc(%ebp)
80104644:	68 d4 70 11 80       	push   $0x801170d4
80104649:	e8 30 19 00 00       	call   80105f7e <addToStateListHead>
8010464e:	83 c4 10             	add    $0x10,%esp
80104651:	83 f8 ff             	cmp    $0xffffffff,%eax
80104654:	75 10                	jne    80104666 <allocproc+0x13b>
            cprintf("Not enough room for process stack; Failed to add proc to UNUSED list (allocproc).\n");
80104656:	83 ec 0c             	sub    $0xc,%esp
80104659:	68 48 a3 10 80       	push   $0x8010a348
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
8010468f:	ba 7a 80 10 80       	mov    $0x8010807a,%edx
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
801046b4:	e8 f7 23 00 00       	call   80106ab0 <memset>
801046b9:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
801046bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046bf:	8b 40 1c             	mov    0x1c(%eax),%eax
801046c2:	ba 52 55 10 80       	mov    $0x80105552,%edx
801046c7:	89 50 10             	mov    %edx,0x10(%eax)

    p->start_ticks = ticks;
801046ca:	8b 15 00 79 11 80    	mov    0x80117900,%edx
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
801046f3:	c7 80 98 00 00 00 a0 	movl   $0x186a0,0x98(%eax)
801046fa:	86 01 00 
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
80104715:	c7 05 e8 70 11 80 20 	movl   $0x7a120,0x801170e8
8010471c:	a1 07 00 
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
80104730:	e8 15 18 00 00       	call   80105f4a <assertState>
80104735:	83 c4 10             	add    $0x10,%esp
        if (addToStateListEnd(&ptable.pLists.free, p) == -1) {
80104738:	83 ec 08             	sub    $0x8,%esp
8010473b:	ff 75 f4             	pushl  -0xc(%ebp)
8010473e:	68 d4 70 11 80       	push   $0x801170d4
80104743:	e8 a2 18 00 00       	call   80105fea <addToStateListEnd>
80104748:	83 c4 10             	add    $0x10,%esp
8010474b:	83 f8 ff             	cmp    $0xffffffff,%eax
8010474e:	75 0d                	jne    8010475d <userinit+0x4e>
            panic("Failed to add proc to UNUSED list.\n");
80104750:	83 ec 0c             	sub    $0xc,%esp
80104753:	68 9c a3 10 80       	push   $0x8010a39c
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
8010477d:	e8 ba 4f 00 00       	call   8010973c <setupkvm>
80104782:	89 c2                	mov    %eax,%edx
80104784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104787:	89 50 04             	mov    %edx,0x4(%eax)
8010478a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478d:	8b 40 04             	mov    0x4(%eax),%eax
80104790:	85 c0                	test   %eax,%eax
80104792:	75 0d                	jne    801047a1 <userinit+0x92>
        panic("userinit: out of memory?");
80104794:	83 ec 0c             	sub    $0xc,%esp
80104797:	68 c0 a3 10 80       	push   $0x8010a3c0
8010479c:	e8 c5 bd ff ff       	call   80100566 <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047a1:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a9:	8b 40 04             	mov    0x4(%eax),%eax
801047ac:	83 ec 04             	sub    $0x4,%esp
801047af:	52                   	push   %edx
801047b0:	68 00 d5 10 80       	push   $0x8010d500
801047b5:	50                   	push   %eax
801047b6:	e8 db 51 00 00       	call   80109996 <inituvm>
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
801047d5:	e8 d6 22 00 00       	call   80106ab0 <memset>
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
80104872:	68 d9 a3 10 80       	push   $0x8010a3d9
80104877:	50                   	push   %eax
80104878:	e8 36 24 00 00       	call   80106cb3 <safestrcpy>
8010487d:	83 c4 10             	add    $0x10,%esp
    p->cwd = namei("/");
80104880:	83 ec 0c             	sub    $0xc,%esp
80104883:	68 e2 a3 10 80       	push   $0x8010a3e2
80104888:	e8 4c dd ff ff       	call   801025d9 <namei>
8010488d:	83 c4 10             	add    $0x10,%esp
80104890:	89 c2                	mov    %eax,%edx
80104892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104895:	89 50 68             	mov    %edx,0x68(%eax)

    assertState(p, EMBRYO);
80104898:	83 ec 08             	sub    $0x8,%esp
8010489b:	6a 01                	push   $0x1
8010489d:	ff 75 f4             	pushl  -0xc(%ebp)
801048a0:	e8 a5 16 00 00       	call   80105f4a <assertState>
801048a5:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.embryo, p) < 0) {
801048a8:	83 ec 08             	sub    $0x8,%esp
801048ab:	ff 75 f4             	pushl  -0xc(%ebp)
801048ae:	68 e4 70 11 80       	push   $0x801170e4
801048b3:	e8 b3 17 00 00       	call   8010606b <removeFromStateList>
801048b8:	83 c4 10             	add    $0x10,%esp
801048bb:	85 c0                	test   %eax,%eax
801048bd:	79 10                	jns    801048cf <userinit+0x1c0>
        cprintf("Failed to remove EMBRYO proc from list (userinit).\n");
801048bf:	83 ec 0c             	sub    $0xc,%esp
801048c2:	68 e4 a3 10 80       	push   $0x8010a3e4
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
8010490e:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
80104912:	7e e3                	jle    801048f7 <userinit+0x1e8>
        ptable.pLists.ready[i] = 0; // initialize all of the other ready lists
    }
    ptable.pLists.sleep = 0;  // initialize rest of the lists to NULL
80104914:	c7 05 d8 70 11 80 00 	movl   $0x0,0x801170d8
8010491b:	00 00 00 
    ptable.pLists.zombie = 0;
8010491e:	c7 05 dc 70 11 80 00 	movl   $0x0,0x801170dc
80104925:	00 00 00 
    ptable.pLists.running = 0;
80104928:	c7 05 e0 70 11 80 00 	movl   $0x0,0x801170e0
8010492f:	00 00 00 
    ptable.pLists.embryo = 0;
80104932:	c7 05 e4 70 11 80 00 	movl   $0x0,0x801170e4
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
8010496f:	e8 6f 51 00 00       	call   80109ae3 <allocuvm>
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
801049a6:	e8 01 52 00 00       	call   80109bac <deallocuvm>
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
801049d3:	e8 4b 4e 00 00       	call   80109823 <switchuvm>
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
80104a19:	e8 2c 53 00 00       	call   80109d4a <copyuvm>
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
80104a5b:	e8 ea 14 00 00       	call   80105f4a <assertState>
80104a60:	83 c4 10             	add    $0x10,%esp
        if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
80104a63:	83 ec 08             	sub    $0x8,%esp
80104a66:	ff 75 e0             	pushl  -0x20(%ebp)
80104a69:	68 e4 70 11 80       	push   $0x801170e4
80104a6e:	e8 f8 15 00 00       	call   8010606b <removeFromStateList>
80104a73:	83 c4 10             	add    $0x10,%esp
80104a76:	85 c0                	test   %eax,%eax
80104a78:	79 0d                	jns    80104a87 <fork+0xa5>
            panic("Failed to remove proc from EMBRYO list (fork).\n");
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	68 18 a4 10 80       	push   $0x8010a418
80104a82:	e8 df ba ff ff       	call   80100566 <panic>
        }
        np->state = UNUSED;
80104a87:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        if (addToStateListHead(&ptable.pLists.free, np) < 0) {
80104a91:	83 ec 08             	sub    $0x8,%esp
80104a94:	ff 75 e0             	pushl  -0x20(%ebp)
80104a97:	68 d4 70 11 80       	push   $0x801170d4
80104a9c:	e8 dd 14 00 00       	call   80105f7e <addToStateListHead>
80104aa1:	83 c4 10             	add    $0x10,%esp
80104aa4:	85 c0                	test   %eax,%eax
80104aa6:	79 0d                	jns    80104ab5 <fork+0xd3>
            panic("Failed to add proc to UNUSED list (fork).\n");
80104aa8:	83 ec 0c             	sub    $0xc,%esp
80104aab:	68 48 a4 10 80       	push   $0x8010a448
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
80104b89:	e8 25 21 00 00       	call   80106cb3 <safestrcpy>
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
80104bcc:	e8 7c 1c 00 00       	call   8010684d <acquire>
80104bd1:	83 c4 10             	add    $0x10,%esp
    assertState(np, EMBRYO);
80104bd4:	83 ec 08             	sub    $0x8,%esp
80104bd7:	6a 01                	push   $0x1
80104bd9:	ff 75 e0             	pushl  -0x20(%ebp)
80104bdc:	e8 69 13 00 00       	call   80105f4a <assertState>
80104be1:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
80104be4:	83 ec 08             	sub    $0x8,%esp
80104be7:	ff 75 e0             	pushl  -0x20(%ebp)
80104bea:	68 e4 70 11 80       	push   $0x801170e4
80104bef:	e8 77 14 00 00       	call   8010606b <removeFromStateList>
80104bf4:	83 c4 10             	add    $0x10,%esp
80104bf7:	85 c0                	test   %eax,%eax
80104bf9:	79 10                	jns    80104c0b <fork+0x229>
        cprintf("Failed to remove EMBRYO proc from list (fork).\n");
80104bfb:	83 ec 0c             	sub    $0xc,%esp
80104bfe:	68 74 a4 10 80       	push   $0x8010a474
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
80104c35:	e8 b0 13 00 00       	call   80105fea <addToStateListEnd>
80104c3a:	83 c4 10             	add    $0x10,%esp
80104c3d:	85 c0                	test   %eax,%eax
80104c3f:	79 10                	jns    80104c51 <fork+0x26f>
        cprintf("Failed to add RUNNABLE proc to list (fork).\n");
80104c41:	83 ec 0c             	sub    $0xc,%esp
80104c44:	68 a4 a4 10 80       	push   $0x8010a4a4
80104c49:	e8 78 b7 ff ff       	call   801003c6 <cprintf>
80104c4e:	83 c4 10             	add    $0x10,%esp
    }
    release(&ptable.lock);
80104c51:	83 ec 0c             	sub    $0xc,%esp
80104c54:	68 80 49 11 80       	push   $0x80114980
80104c59:	e8 56 1c 00 00       	call   801068b4 <release>
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
    struct proc *current;
    int fd;

    if(proc == initproc)
80104c72:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c79:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104c7e:	39 c2                	cmp    %eax,%edx
80104c80:	75 0d                	jne    80104c8f <exit+0x23>
        panic("init exiting");
80104c82:	83 ec 0c             	sub    $0xc,%esp
80104c85:	68 d1 a4 10 80       	push   $0x8010a4d1
80104c8a:	e8 d7 b8 ff ff       	call   80100566 <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104c8f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104c96:	eb 48                	jmp    80104ce0 <exit+0x74>
        if(proc->ofile[fd]){
80104c98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c9e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104ca1:	83 c2 08             	add    $0x8,%edx
80104ca4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ca8:	85 c0                	test   %eax,%eax
80104caa:	74 30                	je     80104cdc <exit+0x70>
            fileclose(proc->ofile[fd]);
80104cac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cb2:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104cb5:	83 c2 08             	add    $0x8,%edx
80104cb8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104cbc:	83 ec 0c             	sub    $0xc,%esp
80104cbf:	50                   	push   %eax
80104cc0:	e8 3d c4 ff ff       	call   80101102 <fileclose>
80104cc5:	83 c4 10             	add    $0x10,%esp
            proc->ofile[fd] = 0;
80104cc8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cce:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104cd1:	83 c2 08             	add    $0x8,%edx
80104cd4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104cdb:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104cdc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104ce0:	83 7d ec 0f          	cmpl   $0xf,-0x14(%ebp)
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
80104d1a:	e8 2e 1b 00 00       	call   8010684d <acquire>
80104d1f:	83 c4 10             	add    $0x10,%esp

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104d22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d28:	8b 40 14             	mov    0x14(%eax),%eax
80104d2b:	83 ec 0c             	sub    $0xc,%esp
80104d2e:	50                   	push   %eax
80104d2f:	e8 f1 09 00 00       	call   80105725 <wakeup1>
80104d34:	83 c4 10             	add    $0x10,%esp
    
    // Pass abandoned children to init.
    current = ptable.pLists.zombie;
80104d37:	a1 dc 70 11 80       	mov    0x801170dc,%eax
80104d3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (current) {
80104d3f:	eb 3f                	jmp    80104d80 <exit+0x114>
        p = current;
80104d41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d44:	89 45 f4             	mov    %eax,-0xc(%ebp)
        current = current->next;
80104d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d4a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p->parent == proc) {
80104d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d56:	8b 50 14             	mov    0x14(%eax),%edx
80104d59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d5f:	39 c2                	cmp    %eax,%edx
80104d61:	75 1d                	jne    80104d80 <exit+0x114>
            p->parent = initproc;
80104d63:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d6c:	89 50 14             	mov    %edx,0x14(%eax)
            wakeup1(initproc);
80104d6f:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104d74:	83 ec 0c             	sub    $0xc,%esp
80104d77:	50                   	push   %eax
80104d78:	e8 a8 09 00 00       	call   80105725 <wakeup1>
80104d7d:	83 c4 10             	add    $0x10,%esp
    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
    
    // Pass abandoned children to init.
    current = ptable.pLists.zombie;
    while (current) {
80104d80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104d84:	75 bb                	jne    80104d41 <exit+0xd5>
        if (p->parent == proc) {
            p->parent = initproc;
            wakeup1(initproc);
        }
    }
    p = ptable.pLists.running; // now running list
80104d86:	a1 e0 70 11 80       	mov    0x801170e0,%eax
80104d8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104d8e:	eb 28                	jmp    80104db8 <exit+0x14c>
        if(p->parent == proc){
80104d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d93:	8b 50 14             	mov    0x14(%eax),%edx
80104d96:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d9c:	39 c2                	cmp    %eax,%edx
80104d9e:	75 0c                	jne    80104dac <exit+0x140>
            p->parent = initproc;
80104da0:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da9:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104daf:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104db5:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->parent = initproc;
            wakeup1(initproc);
        }
    }
    p = ptable.pLists.running; // now running list
    while (p) {
80104db8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104dbc:	75 d2                	jne    80104d90 <exit+0x124>
            p->parent = initproc;
        }
        p = p->next;
    }
    // traverse array of ready lists
    for (int i = 0; i <= MAX; ++i) {
80104dbe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80104dc5:	eb 46                	jmp    80104e0d <exit+0x1a1>
        p = ptable.pLists.ready[i]; // now ready
80104dc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104dca:	05 cc 09 00 00       	add    $0x9cc,%eax
80104dcf:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80104dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
80104dd9:	eb 28                	jmp    80104e03 <exit+0x197>
            if (p->parent == proc) {
80104ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dde:	8b 50 14             	mov    0x14(%eax),%edx
80104de1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104de7:	39 c2                	cmp    %eax,%edx
80104de9:	75 0c                	jne    80104df7 <exit+0x18b>
                p->parent = initproc;
80104deb:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df4:	89 50 14             	mov    %edx,0x14(%eax)
            }
            p = p->next;
80104df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dfa:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104e00:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }
    // traverse array of ready lists
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i]; // now ready
        while (p) {
80104e03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e07:	75 d2                	jne    80104ddb <exit+0x16f>
            p->parent = initproc;
        }
        p = p->next;
    }
    // traverse array of ready lists
    for (int i = 0; i <= MAX; ++i) {
80104e09:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
80104e0d:	83 7d e8 07          	cmpl   $0x7,-0x18(%ebp)
80104e11:	7e b4                	jle    80104dc7 <exit+0x15b>
                p->parent = initproc;
            }
            p = p->next;
        }
    }
    p = ptable.pLists.sleep; // sleeping list
80104e13:	a1 d8 70 11 80       	mov    0x801170d8,%eax
80104e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104e1b:	eb 28                	jmp    80104e45 <exit+0x1d9>
        if (p->parent == proc) {
80104e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e20:	8b 50 14             	mov    0x14(%eax),%edx
80104e23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e29:	39 c2                	cmp    %eax,%edx
80104e2b:	75 0c                	jne    80104e39 <exit+0x1cd>
            p->parent = initproc;
80104e2d:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e36:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e3c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104e42:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
    }
    p = ptable.pLists.sleep; // sleeping list
    while (p) {
80104e45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e49:	75 d2                	jne    80104e1d <exit+0x1b1>
        if (p->parent == proc) {
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.embryo; // embryo list
80104e4b:	a1 e4 70 11 80       	mov    0x801170e4,%eax
80104e50:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104e53:	eb 28                	jmp    80104e7d <exit+0x211>
        if (p->parent == proc) {
80104e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e58:	8b 50 14             	mov    0x14(%eax),%edx
80104e5b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e61:	39 c2                	cmp    %eax,%edx
80104e63:	75 0c                	jne    80104e71 <exit+0x205>
            p->parent = initproc;
80104e65:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e6e:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e74:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104e7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.embryo; // embryo list
    while (p) {
80104e7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e81:	75 d2                	jne    80104e55 <exit+0x1e9>
        if (p->parent == proc) {
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.free; // free list
80104e83:	a1 d4 70 11 80       	mov    0x801170d4,%eax
80104e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104e8b:	eb 28                	jmp    80104eb5 <exit+0x249>
        if (p->parent == proc) {
80104e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e90:	8b 50 14             	mov    0x14(%eax),%edx
80104e93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e99:	39 c2                	cmp    %eax,%edx
80104e9b:	75 0c                	jne    80104ea9 <exit+0x23d>
            p->parent = initproc;
80104e9d:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea6:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eac:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104eb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.free; // free list
    while (p) {
80104eb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104eb9:	75 d2                	jne    80104e8d <exit+0x221>
            p->parent = initproc;
        }
        p = p->next;
    }

    assertState(proc, RUNNING);
80104ebb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ec1:	83 ec 08             	sub    $0x8,%esp
80104ec4:	6a 04                	push   $0x4
80104ec6:	50                   	push   %eax
80104ec7:	e8 7e 10 00 00       	call   80105f4a <assertState>
80104ecc:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
80104ecf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ed5:	83 ec 08             	sub    $0x8,%esp
80104ed8:	50                   	push   %eax
80104ed9:	68 e0 70 11 80       	push   $0x801170e0
80104ede:	e8 88 11 00 00       	call   8010606b <removeFromStateList>
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	79 10                	jns    80104efa <exit+0x28e>
        cprintf("Failed to remove RUNNING proc from list (exit).\n");
80104eea:	83 ec 0c             	sub    $0xc,%esp
80104eed:	68 e0 a4 10 80       	push   $0x8010a4e0
80104ef2:	e8 cf b4 ff ff       	call   801003c6 <cprintf>
80104ef7:	83 c4 10             	add    $0x10,%esp
    }
    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
80104efa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f00:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    if (addToStateListHead(&ptable.pLists.zombie, proc) < 0) {
80104f07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f0d:	83 ec 08             	sub    $0x8,%esp
80104f10:	50                   	push   %eax
80104f11:	68 dc 70 11 80       	push   $0x801170dc
80104f16:	e8 63 10 00 00       	call   80105f7e <addToStateListHead>
80104f1b:	83 c4 10             	add    $0x10,%esp
80104f1e:	85 c0                	test   %eax,%eax
80104f20:	79 10                	jns    80104f32 <exit+0x2c6>
        cprintf("Failed to add ZOMBIE proc to list (exit).\n");
80104f22:	83 ec 0c             	sub    $0xc,%esp
80104f25:	68 14 a5 10 80       	push   $0x8010a514
80104f2a:	e8 97 b4 ff ff       	call   801003c6 <cprintf>
80104f2f:	83 c4 10             	add    $0x10,%esp
    }

    sched();
80104f32:	e8 eb 03 00 00       	call   80105322 <sched>
    panic("zombie exit");
80104f37:	83 ec 0c             	sub    $0xc,%esp
80104f3a:	68 3f a5 10 80       	push   $0x8010a53f
80104f3f:	e8 22 b6 ff ff       	call   80100566 <panic>

80104f44 <wait>:
    }
}
#else
int
wait(void)
{
80104f44:	55                   	push   %ebp
80104f45:	89 e5                	mov    %esp,%ebp
80104f47:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
80104f4a:	83 ec 0c             	sub    $0xc,%esp
80104f4d:	68 80 49 11 80       	push   $0x80114980
80104f52:	e8 f6 18 00 00       	call   8010684d <acquire>
80104f57:	83 c4 10             	add    $0x10,%esp
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
80104f5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        // start at zombie list
        p = ptable.pLists.zombie;
80104f61:	a1 dc 70 11 80       	mov    0x801170dc,%eax
80104f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
80104f69:	e9 03 01 00 00       	jmp    80105071 <wait+0x12d>
            if (p->parent == proc) {
80104f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f71:	8b 50 14             	mov    0x14(%eax),%edx
80104f74:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f7a:	39 c2                	cmp    %eax,%edx
80104f7c:	0f 85 e3 00 00 00    	jne    80105065 <wait+0x121>
                havekids = 1;
80104f82:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
                pid = p->pid;
80104f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f8c:	8b 40 10             	mov    0x10(%eax),%eax
80104f8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
                kfree(p->kstack);
80104f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f95:	8b 40 08             	mov    0x8(%eax),%eax
80104f98:	83 ec 0c             	sub    $0xc,%esp
80104f9b:	50                   	push   %eax
80104f9c:	e8 d9 dc ff ff       	call   80102c7a <kfree>
80104fa1:	83 c4 10             	add    $0x10,%esp
                p->kstack = 0;
80104fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                freevm(p->pgdir);
80104fae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fb1:	8b 40 04             	mov    0x4(%eax),%eax
80104fb4:	83 ec 0c             	sub    $0xc,%esp
80104fb7:	50                   	push   %eax
80104fb8:	e8 ac 4c 00 00       	call   80109c69 <freevm>
80104fbd:	83 c4 10             	add    $0x10,%esp
                assertState(p, ZOMBIE);
80104fc0:	83 ec 08             	sub    $0x8,%esp
80104fc3:	6a 05                	push   $0x5
80104fc5:	ff 75 f4             	pushl  -0xc(%ebp)
80104fc8:	e8 7d 0f 00 00       	call   80105f4a <assertState>
80104fcd:	83 c4 10             	add    $0x10,%esp
                if (removeFromStateList(&ptable.pLists.zombie, p) < 0) {
80104fd0:	83 ec 08             	sub    $0x8,%esp
80104fd3:	ff 75 f4             	pushl  -0xc(%ebp)
80104fd6:	68 dc 70 11 80       	push   $0x801170dc
80104fdb:	e8 8b 10 00 00       	call   8010606b <removeFromStateList>
80104fe0:	83 c4 10             	add    $0x10,%esp
80104fe3:	85 c0                	test   %eax,%eax
80104fe5:	79 10                	jns    80104ff7 <wait+0xb3>
                    cprintf("Failed to remove ZOMBIE process from list (wait).\n");
80104fe7:	83 ec 0c             	sub    $0xc,%esp
80104fea:	68 4c a5 10 80       	push   $0x8010a54c
80104fef:	e8 d2 b3 ff ff       	call   801003c6 <cprintf>
80104ff4:	83 c4 10             	add    $0x10,%esp
                }
                p->state = UNUSED;
80104ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ffa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                if (addToStateListHead(&ptable.pLists.free, p) < 0) {
80105001:	83 ec 08             	sub    $0x8,%esp
80105004:	ff 75 f4             	pushl  -0xc(%ebp)
80105007:	68 d4 70 11 80       	push   $0x801170d4
8010500c:	e8 6d 0f 00 00       	call   80105f7e <addToStateListHead>
80105011:	83 c4 10             	add    $0x10,%esp
80105014:	85 c0                	test   %eax,%eax
80105016:	79 10                	jns    80105028 <wait+0xe4>
                    cprintf("Failed to add UNUSED process to list (wait).\n");
80105018:	83 ec 0c             	sub    $0xc,%esp
8010501b:	68 80 a5 10 80       	push   $0x8010a580
80105020:	e8 a1 b3 ff ff       	call   801003c6 <cprintf>
80105025:	83 c4 10             	add    $0x10,%esp
                }
                p->pid = 0;
80105028:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010502b:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
80105032:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105035:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
8010503c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010503f:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
80105043:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105046:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                release(&ptable.lock);
8010504d:	83 ec 0c             	sub    $0xc,%esp
80105050:	68 80 49 11 80       	push   $0x80114980
80105055:	e8 5a 18 00 00       	call   801068b4 <release>
8010505a:	83 c4 10             	add    $0x10,%esp
                return pid;
8010505d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105060:	e9 2a 01 00 00       	jmp    8010518f <wait+0x24b>
            }
            p = p->next;
80105065:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105068:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010506e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
        // start at zombie list
        p = ptable.pLists.zombie;
        while (!havekids && p) {
80105071:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105075:	75 0a                	jne    80105081 <wait+0x13d>
80105077:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010507b:	0f 85 ed fe ff ff    	jne    80104f6e <wait+0x2a>
                return pid;
            }
            p = p->next;
        }
        // Runnable list
        for (int i = 0; i <= MAX; i++) {
80105081:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80105088:	eb 47                	jmp    801050d1 <wait+0x18d>
            p = ptable.pLists.ready[i];
8010508a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010508d:	05 cc 09 00 00       	add    $0x9cc,%eax
80105092:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80105099:	89 45 f4             	mov    %eax,-0xc(%ebp)
            while (!havekids && p) {
8010509c:	eb 23                	jmp    801050c1 <wait+0x17d>
                if (p->parent == proc) {
8010509e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a1:	8b 50 14             	mov    0x14(%eax),%edx
801050a4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050aa:	39 c2                	cmp    %eax,%edx
801050ac:	75 07                	jne    801050b5 <wait+0x171>
                    havekids = 1;
801050ae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
                }
                p = p->next;
801050b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050b8:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801050be:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p = p->next;
        }
        // Runnable list
        for (int i = 0; i <= MAX; i++) {
            p = ptable.pLists.ready[i];
            while (!havekids && p) {
801050c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801050c5:	75 06                	jne    801050cd <wait+0x189>
801050c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050cb:	75 d1                	jne    8010509e <wait+0x15a>
                return pid;
            }
            p = p->next;
        }
        // Runnable list
        for (int i = 0; i <= MAX; i++) {
801050cd:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801050d1:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
801050d5:	7e b3                	jle    8010508a <wait+0x146>
                }
                p = p->next;
            }
        }
        // Running list
        p = ptable.pLists.running;
801050d7:	a1 e0 70 11 80       	mov    0x801170e0,%eax
801050dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
801050df:	eb 23                	jmp    80105104 <wait+0x1c0>
            if (p->parent == proc) {
801050e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050e4:	8b 50 14             	mov    0x14(%eax),%edx
801050e7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050ed:	39 c2                	cmp    %eax,%edx
801050ef:	75 07                	jne    801050f8 <wait+0x1b4>
                havekids = 1;
801050f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            }
            p = p->next;
801050f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050fb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105101:	89 45 f4             	mov    %eax,-0xc(%ebp)
                p = p->next;
            }
        }
        // Running list
        p = ptable.pLists.running;
        while (!havekids && p) {
80105104:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105108:	75 06                	jne    80105110 <wait+0x1cc>
8010510a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010510e:	75 d1                	jne    801050e1 <wait+0x19d>
                havekids = 1;
            }
            p = p->next;
        }
        // Sleep list
        p = ptable.pLists.sleep;
80105110:	a1 d8 70 11 80       	mov    0x801170d8,%eax
80105115:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
80105118:	eb 23                	jmp    8010513d <wait+0x1f9>
            if (p->parent == proc) {
8010511a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010511d:	8b 50 14             	mov    0x14(%eax),%edx
80105120:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105126:	39 c2                	cmp    %eax,%edx
80105128:	75 07                	jne    80105131 <wait+0x1ed>
                havekids = 1;
8010512a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            }
            p = p->next;
80105131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105134:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010513a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
        // Sleep list
        p = ptable.pLists.sleep;
        while (!havekids && p) {
8010513d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105141:	75 06                	jne    80105149 <wait+0x205>
80105143:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105147:	75 d1                	jne    8010511a <wait+0x1d6>
                havekids = 1;
            }
            p = p->next;
        }
        // No point waiting if we don't have any children.
        if(!havekids || proc->killed) {
80105149:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010514d:	74 0d                	je     8010515c <wait+0x218>
8010514f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105155:	8b 40 24             	mov    0x24(%eax),%eax
80105158:	85 c0                	test   %eax,%eax
8010515a:	74 17                	je     80105173 <wait+0x22f>
            release(&ptable.lock);
8010515c:	83 ec 0c             	sub    $0xc,%esp
8010515f:	68 80 49 11 80       	push   $0x80114980
80105164:	e8 4b 17 00 00       	call   801068b4 <release>
80105169:	83 c4 10             	add    $0x10,%esp
            return -1;
8010516c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105171:	eb 1c                	jmp    8010518f <wait+0x24b>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
80105173:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105179:	83 ec 08             	sub    $0x8,%esp
8010517c:	68 80 49 11 80       	push   $0x80114980
80105181:	50                   	push   %eax
80105182:	e8 11 04 00 00       	call   80105598 <sleep>
80105187:	83 c4 10             	add    $0x10,%esp
    }
8010518a:	e9 cb fd ff ff       	jmp    80104f5a <wait+0x16>
}
8010518f:	c9                   	leave  
80105190:	c3                   	ret    

80105191 <scheduler>:

#else
// Project 3 scheduler
void
scheduler(void)
{
80105191:	55                   	push   %ebp
80105192:	89 e5                	mov    %esp,%ebp
80105194:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    int idle;  // for checking if processor is idle
    int ran; // ready list loop condition 
    for(;;) {
        // Enable interrupts on this processor.
        sti();
80105197:	e8 6a f3 ff ff       	call   80104506 <sti>
        idle = 1;  // assume idle unless we schedule a process
8010519c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        ran = 0; // reset ran, look for another process
801051a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
801051aa:	83 ec 0c             	sub    $0xc,%esp
801051ad:	68 80 49 11 80       	push   $0x80114980
801051b2:	e8 96 16 00 00       	call   8010684d <acquire>
801051b7:	83 c4 10             	add    $0x10,%esp

        if ((ptable.promoteAtTime) == ticks) {
801051ba:	8b 15 e8 70 11 80    	mov    0x801170e8,%edx
801051c0:	a1 00 79 11 80       	mov    0x80117900,%eax
801051c5:	39 c2                	cmp    %eax,%edx
801051c7:	75 14                	jne    801051dd <scheduler+0x4c>
            //cprintf("Promotion occurred.\n");
            promoteAll(); // RUNNING, RUNNABLE, SLEEPING
801051c9:	e8 80 12 00 00       	call   8010644e <promoteAll>
            ptable.promoteAtTime = (ticks + TIME_TO_PROMOTE); // update next time we will promote everything
801051ce:	a1 00 79 11 80       	mov    0x80117900,%eax
801051d3:	05 20 a1 07 00       	add    $0x7a120,%eax
801051d8:	a3 e8 70 11 80       	mov    %eax,0x801170e8
        }
        for (int i = 0; (i <= MAX) && (ran == 0); ++i) {
801051dd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801051e4:	e9 00 01 00 00       	jmp    801052e9 <scheduler+0x158>
            // take first process on first valid list
            p = ptable.pLists.ready[i];
801051e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051ec:	05 cc 09 00 00       	add    $0x9cc,%eax
801051f1:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
801051f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (p) {
801051fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801051ff:	0f 84 e0 00 00 00    	je     801052e5 <scheduler+0x154>
                // assign pointer, aseert correct state
                assertState(p, RUNNABLE);
80105205:	83 ec 08             	sub    $0x8,%esp
80105208:	6a 03                	push   $0x3
8010520a:	ff 75 e8             	pushl  -0x18(%ebp)
8010520d:	e8 38 0d 00 00       	call   80105f4a <assertState>
80105212:	83 c4 10             	add    $0x10,%esp
                // take 1st process on ready list
                p = removeHead(&ptable.pLists.ready[p->priority]);
80105215:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105218:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010521e:	05 cc 09 00 00       	add    $0x9cc,%eax
80105223:	c1 e0 02             	shl    $0x2,%eax
80105226:	05 80 49 11 80       	add    $0x80114980,%eax
8010522b:	83 c0 04             	add    $0x4,%eax
8010522e:	83 ec 0c             	sub    $0xc,%esp
80105231:	50                   	push   %eax
80105232:	e8 28 0f 00 00       	call   8010615f <removeHead>
80105237:	83 c4 10             	add    $0x10,%esp
8010523a:	89 45 e8             	mov    %eax,-0x18(%ebp)
                if (!p) {
8010523d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80105241:	75 0d                	jne    80105250 <scheduler+0xbf>
                    panic("Scheduler: removeHead failed.");
80105243:	83 ec 0c             	sub    $0xc,%esp
80105246:	68 ae a5 10 80       	push   $0x8010a5ae
8010524b:	e8 16 b3 ff ff       	call   80100566 <panic>
                }
                // hand over to the CPU
                idle = 0;
80105250:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
                proc = p;
80105257:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010525a:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
                switchuvm(p);
80105260:	83 ec 0c             	sub    $0xc,%esp
80105263:	ff 75 e8             	pushl  -0x18(%ebp)
80105266:	e8 b8 45 00 00       	call   80109823 <switchuvm>
8010526b:	83 c4 10             	add    $0x10,%esp
                p->state = RUNNING;
8010526e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105271:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
                // add to end of running list
                if (addToStateListEnd(&ptable.pLists.running, p) < 0) {
80105278:	83 ec 08             	sub    $0x8,%esp
8010527b:	ff 75 e8             	pushl  -0x18(%ebp)
8010527e:	68 e0 70 11 80       	push   $0x801170e0
80105283:	e8 62 0d 00 00       	call   80105fea <addToStateListEnd>
80105288:	83 c4 10             	add    $0x10,%esp
8010528b:	85 c0                	test   %eax,%eax
8010528d:	79 10                	jns    8010529f <scheduler+0x10e>
                    cprintf("Failed to add RUNNING proc to list (scheduler).");
8010528f:	83 ec 0c             	sub    $0xc,%esp
80105292:	68 cc a5 10 80       	push   $0x8010a5cc
80105297:	e8 2a b1 ff ff       	call   801003c6 <cprintf>
8010529c:	83 c4 10             	add    $0x10,%esp
                }
                p->cpu_ticks_in = ticks; // ticks when scheduled
8010529f:	8b 15 00 79 11 80    	mov    0x80117900,%edx
801052a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801052a8:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
                swtch(&cpu->scheduler, proc->context);
801052ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052b4:	8b 40 1c             	mov    0x1c(%eax),%eax
801052b7:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801052be:	83 c2 04             	add    $0x4,%edx
801052c1:	83 ec 08             	sub    $0x8,%esp
801052c4:	50                   	push   %eax
801052c5:	52                   	push   %edx
801052c6:	e8 59 1a 00 00       	call   80106d24 <swtch>
801052cb:	83 c4 10             	add    $0x10,%esp
                switchkvm();
801052ce:	e8 33 45 00 00       	call   80109806 <switchkvm>
                // Process is done running for now.
                // It should have changed its p->state before coming back.
                proc = 0;
801052d3:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801052da:	00 00 00 00 
                ran = 1; // exit loop after this
801052de:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
        if ((ptable.promoteAtTime) == ticks) {
            //cprintf("Promotion occurred.\n");
            promoteAll(); // RUNNING, RUNNABLE, SLEEPING
            ptable.promoteAtTime = (ticks + TIME_TO_PROMOTE); // update next time we will promote everything
        }
        for (int i = 0; (i <= MAX) && (ran == 0); ++i) {
801052e5:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801052e9:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
801052ed:	7f 0a                	jg     801052f9 <scheduler+0x168>
801052ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801052f3:	0f 84 f0 fe ff ff    	je     801051e9 <scheduler+0x58>
                // It should have changed its p->state before coming back.
                proc = 0;
                ran = 1; // exit loop after this
            }
        }
        release(&ptable.lock);
801052f9:	83 ec 0c             	sub    $0xc,%esp
801052fc:	68 80 49 11 80       	push   $0x80114980
80105301:	e8 ae 15 00 00       	call   801068b4 <release>
80105306:	83 c4 10             	add    $0x10,%esp
        if (idle) {
80105309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010530d:	0f 84 84 fe ff ff    	je     80105197 <scheduler+0x6>
            sti();
80105313:	e8 ee f1 ff ff       	call   80104506 <sti>
            hlt();
80105318:	e8 d2 f1 ff ff       	call   801044ef <hlt>
        }
    }
8010531d:	e9 75 fe ff ff       	jmp    80105197 <scheduler+0x6>

80105322 <sched>:
    cpu->intena = intena;
}
#else
void
sched(void)
{
80105322:	55                   	push   %ebp
80105323:	89 e5                	mov    %esp,%ebp
80105325:	53                   	push   %ebx
80105326:	83 ec 14             	sub    $0x14,%esp
    int intena;

    if(!holding(&ptable.lock))
80105329:	83 ec 0c             	sub    $0xc,%esp
8010532c:	68 80 49 11 80       	push   $0x80114980
80105331:	e8 4a 16 00 00       	call   80106980 <holding>
80105336:	83 c4 10             	add    $0x10,%esp
80105339:	85 c0                	test   %eax,%eax
8010533b:	75 0d                	jne    8010534a <sched+0x28>
        panic("sched ptable.lock");
8010533d:	83 ec 0c             	sub    $0xc,%esp
80105340:	68 fc a5 10 80       	push   $0x8010a5fc
80105345:	e8 1c b2 ff ff       	call   80100566 <panic>
    if(cpu->ncli != 1)
8010534a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105350:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105356:	83 f8 01             	cmp    $0x1,%eax
80105359:	74 0d                	je     80105368 <sched+0x46>
        panic("sched locks");
8010535b:	83 ec 0c             	sub    $0xc,%esp
8010535e:	68 0e a6 10 80       	push   $0x8010a60e
80105363:	e8 fe b1 ff ff       	call   80100566 <panic>
    if(proc->state == RUNNING)
80105368:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010536e:	8b 40 0c             	mov    0xc(%eax),%eax
80105371:	83 f8 04             	cmp    $0x4,%eax
80105374:	75 0d                	jne    80105383 <sched+0x61>
        panic("sched running");
80105376:	83 ec 0c             	sub    $0xc,%esp
80105379:	68 1a a6 10 80       	push   $0x8010a61a
8010537e:	e8 e3 b1 ff ff       	call   80100566 <panic>
    if(readeflags()&FL_IF)
80105383:	e8 6e f1 ff ff       	call   801044f6 <readeflags>
80105388:	25 00 02 00 00       	and    $0x200,%eax
8010538d:	85 c0                	test   %eax,%eax
8010538f:	74 0d                	je     8010539e <sched+0x7c>
        panic("sched interruptible");
80105391:	83 ec 0c             	sub    $0xc,%esp
80105394:	68 28 a6 10 80       	push   $0x8010a628
80105399:	e8 c8 b1 ff ff       	call   80100566 <panic>
    intena = cpu->intena;
8010539e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053a4:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801053aa:	89 45 f4             	mov    %eax,-0xc(%ebp)

    proc->cpu_ticks_total += (ticks - proc->cpu_ticks_in);
801053ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053b3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053ba:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801053c0:	8b 1d 00 79 11 80    	mov    0x80117900,%ebx
801053c6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053cd:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801053d3:	29 d3                	sub    %edx,%ebx
801053d5:	89 da                	mov    %ebx,%edx
801053d7:	01 ca                	add    %ecx,%edx
801053d9:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)

    swtch(&proc->context, cpu->scheduler);
801053df:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053e5:	8b 40 04             	mov    0x4(%eax),%eax
801053e8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053ef:	83 c2 1c             	add    $0x1c,%edx
801053f2:	83 ec 08             	sub    $0x8,%esp
801053f5:	50                   	push   %eax
801053f6:	52                   	push   %edx
801053f7:	e8 28 19 00 00       	call   80106d24 <swtch>
801053fc:	83 c4 10             	add    $0x10,%esp

    cpu->intena = intena;
801053ff:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105405:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105408:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010540e:	90                   	nop
8010540f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105412:	c9                   	leave  
80105413:	c3                   	ret    

80105414 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105414:	55                   	push   %ebp
80105415:	89 e5                	mov    %esp,%ebp
80105417:	53                   	push   %ebx
80105418:	83 ec 04             	sub    $0x4,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
8010541b:	83 ec 0c             	sub    $0xc,%esp
8010541e:	68 80 49 11 80       	push   $0x80114980
80105423:	e8 25 14 00 00       	call   8010684d <acquire>
80105428:	83 c4 10             	add    $0x10,%esp

#ifdef CS333_P3P4
    assertState(proc, RUNNING);
8010542b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105431:	83 ec 08             	sub    $0x8,%esp
80105434:	6a 04                	push   $0x4
80105436:	50                   	push   %eax
80105437:	e8 0e 0b 00 00       	call   80105f4a <assertState>
8010543c:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
8010543f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105445:	83 ec 08             	sub    $0x8,%esp
80105448:	50                   	push   %eax
80105449:	68 e0 70 11 80       	push   $0x801170e0
8010544e:	e8 18 0c 00 00       	call   8010606b <removeFromStateList>
80105453:	83 c4 10             	add    $0x10,%esp
80105456:	85 c0                	test   %eax,%eax
80105458:	79 10                	jns    8010546a <yield+0x56>
        cprintf("Failed to remove RUNNING proc to list (yeild).");
8010545a:	83 ec 0c             	sub    $0xc,%esp
8010545d:	68 3c a6 10 80       	push   $0x8010a63c
80105462:	e8 5f af ff ff       	call   801003c6 <cprintf>
80105467:	83 c4 10             	add    $0x10,%esp
    }
#endif

    proc->state = RUNNABLE;
8010546a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105470:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

#ifdef CS333_P3P4
    proc->budget -= (ticks - proc->cpu_ticks_in); // update budget, then check
80105477:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010547d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105484:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
8010548a:	89 d3                	mov    %edx,%ebx
8010548c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105493:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
80105499:	8b 15 00 79 11 80    	mov    0x80117900,%edx
8010549f:	29 d1                	sub    %edx,%ecx
801054a1:	89 ca                	mov    %ecx,%edx
801054a3:	01 da                	add    %ebx,%edx
801054a5:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if ((proc->budget) <= 0) {
801054ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054b1:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801054b7:	85 c0                	test   %eax,%eax
801054b9:	7f 36                	jg     801054f1 <yield+0xdd>
        if ((proc->priority) < MAX) {
801054bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054c1:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801054c7:	83 f8 06             	cmp    $0x6,%eax
801054ca:	77 15                	ja     801054e1 <yield+0xcd>
            ++(proc->priority); // Demotion
801054cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054d2:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
801054d8:	83 c2 01             	add    $0x1,%edx
801054db:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        }
        proc->budget = BUDGET; // Reset budget
801054e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054e7:	c7 80 98 00 00 00 a0 	movl   $0x186a0,0x98(%eax)
801054ee:	86 01 00 
    }

    if (addToStateListEnd(&ptable.pLists.ready[proc->priority], proc) < 0) {
801054f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054f7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054fe:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
80105504:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
8010550a:	c1 e2 02             	shl    $0x2,%edx
8010550d:	81 c2 80 49 11 80    	add    $0x80114980,%edx
80105513:	83 c2 04             	add    $0x4,%edx
80105516:	83 ec 08             	sub    $0x8,%esp
80105519:	50                   	push   %eax
8010551a:	52                   	push   %edx
8010551b:	e8 ca 0a 00 00       	call   80105fea <addToStateListEnd>
80105520:	83 c4 10             	add    $0x10,%esp
80105523:	85 c0                	test   %eax,%eax
80105525:	79 10                	jns    80105537 <yield+0x123>
        cprintf("Failed to add RUNNABLE proc to list (yeild).");
80105527:	83 ec 0c             	sub    $0xc,%esp
8010552a:	68 6c a6 10 80       	push   $0x8010a66c
8010552f:	e8 92 ae ff ff       	call   801003c6 <cprintf>
80105534:	83 c4 10             	add    $0x10,%esp
    }
#endif

    sched();
80105537:	e8 e6 fd ff ff       	call   80105322 <sched>
    release(&ptable.lock);
8010553c:	83 ec 0c             	sub    $0xc,%esp
8010553f:	68 80 49 11 80       	push   $0x80114980
80105544:	e8 6b 13 00 00       	call   801068b4 <release>
80105549:	83 c4 10             	add    $0x10,%esp
}
8010554c:	90                   	nop
8010554d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105550:	c9                   	leave  
80105551:	c3                   	ret    

80105552 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105552:	55                   	push   %ebp
80105553:	89 e5                	mov    %esp,%ebp
80105555:	83 ec 08             	sub    $0x8,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80105558:	83 ec 0c             	sub    $0xc,%esp
8010555b:	68 80 49 11 80       	push   $0x80114980
80105560:	e8 4f 13 00 00       	call   801068b4 <release>
80105565:	83 c4 10             	add    $0x10,%esp

    if (first) {
80105568:	a1 20 d0 10 80       	mov    0x8010d020,%eax
8010556d:	85 c0                	test   %eax,%eax
8010556f:	74 24                	je     80105595 <forkret+0x43>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot 
        // be run from main().
        first = 0;
80105571:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
80105578:	00 00 00 
        iinit(ROOTDEV);
8010557b:	83 ec 0c             	sub    $0xc,%esp
8010557e:	6a 01                	push   $0x1
80105580:	e8 6a c1 ff ff       	call   801016ef <iinit>
80105585:	83 c4 10             	add    $0x10,%esp
        initlog(ROOTDEV);
80105588:	83 ec 0c             	sub    $0xc,%esp
8010558b:	6a 01                	push   $0x1
8010558d:	e8 4e de ff ff       	call   801033e0 <initlog>
80105592:	83 c4 10             	add    $0x10,%esp
    }

    // Return to "caller", actually trapret (see allocproc).
}
80105595:	90                   	nop
80105596:	c9                   	leave  
80105597:	c3                   	ret    

80105598 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80105598:	55                   	push   %ebp
80105599:	89 e5                	mov    %esp,%ebp
8010559b:	53                   	push   %ebx
8010559c:	83 ec 04             	sub    $0x4,%esp
    if(proc == 0)
8010559f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055a5:	85 c0                	test   %eax,%eax
801055a7:	75 0d                	jne    801055b6 <sleep+0x1e>
        panic("sleep");
801055a9:	83 ec 0c             	sub    $0xc,%esp
801055ac:	68 99 a6 10 80       	push   $0x8010a699
801055b1:	e8 b0 af ff ff       	call   80100566 <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){
801055b6:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801055bd:	74 24                	je     801055e3 <sleep+0x4b>
        acquire(&ptable.lock);
801055bf:	83 ec 0c             	sub    $0xc,%esp
801055c2:	68 80 49 11 80       	push   $0x80114980
801055c7:	e8 81 12 00 00       	call   8010684d <acquire>
801055cc:	83 c4 10             	add    $0x10,%esp
        if (lk) release(lk);
801055cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801055d3:	74 0e                	je     801055e3 <sleep+0x4b>
801055d5:	83 ec 0c             	sub    $0xc,%esp
801055d8:	ff 75 0c             	pushl  0xc(%ebp)
801055db:	e8 d4 12 00 00       	call   801068b4 <release>
801055e0:	83 c4 10             	add    $0x10,%esp
    }

    // Go to sleep.
    proc->chan = chan;
801055e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e9:	8b 55 08             	mov    0x8(%ebp),%edx
801055ec:	89 50 20             	mov    %edx,0x20(%eax)

#ifdef CS333_P3P4
    assertState(proc, RUNNING);
801055ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055f5:	83 ec 08             	sub    $0x8,%esp
801055f8:	6a 04                	push   $0x4
801055fa:	50                   	push   %eax
801055fb:	e8 4a 09 00 00       	call   80105f4a <assertState>
80105600:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
80105603:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105609:	83 ec 08             	sub    $0x8,%esp
8010560c:	50                   	push   %eax
8010560d:	68 e0 70 11 80       	push   $0x801170e0
80105612:	e8 54 0a 00 00       	call   8010606b <removeFromStateList>
80105617:	83 c4 10             	add    $0x10,%esp
8010561a:	85 c0                	test   %eax,%eax
8010561c:	79 10                	jns    8010562e <sleep+0x96>
        cprintf("Could not remove RUNNING proc from list (sleep()).\n");
8010561e:	83 ec 0c             	sub    $0xc,%esp
80105621:	68 a0 a6 10 80       	push   $0x8010a6a0
80105626:	e8 9b ad ff ff       	call   801003c6 <cprintf>
8010562b:	83 c4 10             	add    $0x10,%esp
    }
#endif

    proc->state = SLEEPING;
8010562e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105634:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

#ifdef CS333_P3P4
    proc->budget -= (ticks - proc->cpu_ticks_in); // update budegt, then check
8010563b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105641:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105648:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
8010564e:	89 d3                	mov    %edx,%ebx
80105650:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105657:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
8010565d:	8b 15 00 79 11 80    	mov    0x80117900,%edx
80105663:	29 d1                	sub    %edx,%ecx
80105665:	89 ca                	mov    %ecx,%edx
80105667:	01 da                	add    %ebx,%edx
80105669:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if ((proc->budget) <= 0) {
8010566f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105675:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010567b:	85 c0                	test   %eax,%eax
8010567d:	7f 36                	jg     801056b5 <sleep+0x11d>
        // priority cant be greater than MAX bc it is literal index of ready list array
        if ((proc->priority) < MAX) {
8010567f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105685:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010568b:	83 f8 06             	cmp    $0x6,%eax
8010568e:	77 15                	ja     801056a5 <sleep+0x10d>
            ++(proc->priority); // Demotion
80105690:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105696:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
8010569c:	83 c2 01             	add    $0x1,%edx
8010569f:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        }
        proc->budget = BUDGET; // Reset budget
801056a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056ab:	c7 80 98 00 00 00 a0 	movl   $0x186a0,0x98(%eax)
801056b2:	86 01 00 
    }
    if (addToStateListEnd(&ptable.pLists.sleep, proc) < 0) {
801056b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056bb:	83 ec 08             	sub    $0x8,%esp
801056be:	50                   	push   %eax
801056bf:	68 d8 70 11 80       	push   $0x801170d8
801056c4:	e8 21 09 00 00       	call   80105fea <addToStateListEnd>
801056c9:	83 c4 10             	add    $0x10,%esp
801056cc:	85 c0                	test   %eax,%eax
801056ce:	79 10                	jns    801056e0 <sleep+0x148>
        cprintf("Could not add SLEEPING proc to list (sleep()).\n");
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	68 d4 a6 10 80       	push   $0x8010a6d4
801056d8:	e8 e9 ac ff ff       	call   801003c6 <cprintf>
801056dd:	83 c4 10             	add    $0x10,%esp
    }
#endif

    sched();
801056e0:	e8 3d fc ff ff       	call   80105322 <sched>

    // Tidy up.
    proc->chan = 0;
801056e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056eb:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){ 
801056f2:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801056f9:	74 24                	je     8010571f <sleep+0x187>
        release(&ptable.lock);
801056fb:	83 ec 0c             	sub    $0xc,%esp
801056fe:	68 80 49 11 80       	push   $0x80114980
80105703:	e8 ac 11 00 00       	call   801068b4 <release>
80105708:	83 c4 10             	add    $0x10,%esp
        if (lk) acquire(lk);
8010570b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010570f:	74 0e                	je     8010571f <sleep+0x187>
80105711:	83 ec 0c             	sub    $0xc,%esp
80105714:	ff 75 0c             	pushl  0xc(%ebp)
80105717:	e8 31 11 00 00       	call   8010684d <acquire>
8010571c:	83 c4 10             	add    $0x10,%esp
    }
}
8010571f:	90                   	nop
80105720:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105723:	c9                   	leave  
80105724:	c3                   	ret    

80105725 <wakeup1>:
}
#else
// P3 wakeup1
static void
wakeup1(void *chan)
{
80105725:	55                   	push   %ebp
80105726:	89 e5                	mov    %esp,%ebp
80105728:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    if (ptable.pLists.sleep) {
8010572b:	a1 d8 70 11 80       	mov    0x801170d8,%eax
80105730:	85 c0                	test   %eax,%eax
80105732:	0f 84 b8 00 00 00    	je     801057f0 <wakeup1+0xcb>
        struct proc * current = ptable.pLists.sleep;
80105738:	a1 d8 70 11 80       	mov    0x801170d8,%eax
8010573d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = 0;
80105740:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        while (current) {
80105747:	e9 9a 00 00 00       	jmp    801057e6 <wakeup1+0xc1>
            p = current;
8010574c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010574f:	89 45 f0             	mov    %eax,-0x10(%ebp)
            current = current->next;
80105752:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105755:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010575b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            assertState(p, SLEEPING);
8010575e:	83 ec 08             	sub    $0x8,%esp
80105761:	6a 02                	push   $0x2
80105763:	ff 75 f0             	pushl  -0x10(%ebp)
80105766:	e8 df 07 00 00       	call   80105f4a <assertState>
8010576b:	83 c4 10             	add    $0x10,%esp
            if (p->chan == chan) {
8010576e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105771:	8b 40 20             	mov    0x20(%eax),%eax
80105774:	3b 45 08             	cmp    0x8(%ebp),%eax
80105777:	75 6d                	jne    801057e6 <wakeup1+0xc1>
                if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
80105779:	83 ec 08             	sub    $0x8,%esp
8010577c:	ff 75 f0             	pushl  -0x10(%ebp)
8010577f:	68 d8 70 11 80       	push   $0x801170d8
80105784:	e8 e2 08 00 00       	call   8010606b <removeFromStateList>
80105789:	83 c4 10             	add    $0x10,%esp
8010578c:	85 c0                	test   %eax,%eax
8010578e:	79 10                	jns    801057a0 <wakeup1+0x7b>
                    cprintf("Failed to remove SLEEPING proc to list (wakeup1).\n");
80105790:	83 ec 0c             	sub    $0xc,%esp
80105793:	68 04 a7 10 80       	push   $0x8010a704
80105798:	e8 29 ac ff ff       	call   801003c6 <cprintf>
8010579d:	83 c4 10             	add    $0x10,%esp
                }
                p->state = RUNNABLE;
801057a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057a3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
801057aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ad:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801057b3:	05 cc 09 00 00       	add    $0x9cc,%eax
801057b8:	c1 e0 02             	shl    $0x2,%eax
801057bb:	05 80 49 11 80       	add    $0x80114980,%eax
801057c0:	83 c0 04             	add    $0x4,%eax
801057c3:	83 ec 08             	sub    $0x8,%esp
801057c6:	ff 75 f0             	pushl  -0x10(%ebp)
801057c9:	50                   	push   %eax
801057ca:	e8 1b 08 00 00       	call   80105fea <addToStateListEnd>
801057cf:	83 c4 10             	add    $0x10,%esp
801057d2:	85 c0                	test   %eax,%eax
801057d4:	79 10                	jns    801057e6 <wakeup1+0xc1>
                    cprintf("Failed to add RUNNABLE proc to list (wakeup1).\n");
801057d6:	83 ec 0c             	sub    $0xc,%esp
801057d9:	68 38 a7 10 80       	push   $0x8010a738
801057de:	e8 e3 ab ff ff       	call   801003c6 <cprintf>
801057e3:	83 c4 10             	add    $0x10,%esp
{
    struct proc *p;
    if (ptable.pLists.sleep) {
        struct proc * current = ptable.pLists.sleep;
        p = 0;
        while (current) {
801057e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057ea:	0f 85 5c ff ff ff    	jne    8010574c <wakeup1+0x27>
                    cprintf("Failed to add RUNNABLE proc to list (wakeup1).\n");
                }
            }
        }
    }
}
801057f0:	90                   	nop
801057f1:	c9                   	leave  
801057f2:	c3                   	ret    

801057f3 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801057f3:	55                   	push   %ebp
801057f4:	89 e5                	mov    %esp,%ebp
801057f6:	83 ec 08             	sub    $0x8,%esp
    acquire(&ptable.lock);
801057f9:	83 ec 0c             	sub    $0xc,%esp
801057fc:	68 80 49 11 80       	push   $0x80114980
80105801:	e8 47 10 00 00       	call   8010684d <acquire>
80105806:	83 c4 10             	add    $0x10,%esp
    wakeup1(chan);
80105809:	83 ec 0c             	sub    $0xc,%esp
8010580c:	ff 75 08             	pushl  0x8(%ebp)
8010580f:	e8 11 ff ff ff       	call   80105725 <wakeup1>
80105814:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105817:	83 ec 0c             	sub    $0xc,%esp
8010581a:	68 80 49 11 80       	push   $0x80114980
8010581f:	e8 90 10 00 00       	call   801068b4 <release>
80105824:	83 c4 10             	add    $0x10,%esp
}
80105827:	90                   	nop
80105828:	c9                   	leave  
80105829:	c3                   	ret    

8010582a <kill>:
    return -1;
}
#else
int
kill(int pid)
{
8010582a:	55                   	push   %ebp
8010582b:	89 e5                	mov    %esp,%ebp
8010582d:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;

    acquire(&ptable.lock);
80105830:	83 ec 0c             	sub    $0xc,%esp
80105833:	68 80 49 11 80       	push   $0x80114980
80105838:	e8 10 10 00 00       	call   8010684d <acquire>
8010583d:	83 c4 10             	add    $0x10,%esp
    // traverse Sleeping list, wake processes if necessary
    p = ptable.pLists.sleep;
80105840:	a1 d8 70 11 80       	mov    0x801170d8,%eax
80105845:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105848:	e9 be 00 00 00       	jmp    8010590b <kill+0xe1>
        if (p->pid == pid) {
8010584d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105850:	8b 50 10             	mov    0x10(%eax),%edx
80105853:	8b 45 08             	mov    0x8(%ebp),%eax
80105856:	39 c2                	cmp    %eax,%edx
80105858:	0f 85 a1 00 00 00    	jne    801058ff <kill+0xd5>
            p->killed = 1;
8010585e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105861:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            assertState(p, SLEEPING);
80105868:	83 ec 08             	sub    $0x8,%esp
8010586b:	6a 02                	push   $0x2
8010586d:	ff 75 f4             	pushl  -0xc(%ebp)
80105870:	e8 d5 06 00 00       	call   80105f4a <assertState>
80105875:	83 c4 10             	add    $0x10,%esp
            if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
80105878:	83 ec 08             	sub    $0x8,%esp
8010587b:	ff 75 f4             	pushl  -0xc(%ebp)
8010587e:	68 d8 70 11 80       	push   $0x801170d8
80105883:	e8 e3 07 00 00       	call   8010606b <removeFromStateList>
80105888:	83 c4 10             	add    $0x10,%esp
8010588b:	85 c0                	test   %eax,%eax
8010588d:	79 10                	jns    8010589f <kill+0x75>
                cprintf("Could not remove SLEEPING proc from list (kill).\n");
8010588f:	83 ec 0c             	sub    $0xc,%esp
80105892:	68 68 a7 10 80       	push   $0x8010a768
80105897:	e8 2a ab ff ff       	call   801003c6 <cprintf>
8010589c:	83 c4 10             	add    $0x10,%esp
            }
            p->state = RUNNABLE;
8010589f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058a2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
801058a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ac:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801058b2:	05 cc 09 00 00       	add    $0x9cc,%eax
801058b7:	c1 e0 02             	shl    $0x2,%eax
801058ba:	05 80 49 11 80       	add    $0x80114980,%eax
801058bf:	83 c0 04             	add    $0x4,%eax
801058c2:	83 ec 08             	sub    $0x8,%esp
801058c5:	ff 75 f4             	pushl  -0xc(%ebp)
801058c8:	50                   	push   %eax
801058c9:	e8 1c 07 00 00       	call   80105fea <addToStateListEnd>
801058ce:	83 c4 10             	add    $0x10,%esp
801058d1:	85 c0                	test   %eax,%eax
801058d3:	79 10                	jns    801058e5 <kill+0xbb>
                cprintf("Could not add RUNNABLE proc to list (kill).\n");
801058d5:	83 ec 0c             	sub    $0xc,%esp
801058d8:	68 9c a7 10 80       	push   $0x8010a79c
801058dd:	e8 e4 aa ff ff       	call   801003c6 <cprintf>
801058e2:	83 c4 10             	add    $0x10,%esp
            }
            release(&ptable.lock);
801058e5:	83 ec 0c             	sub    $0xc,%esp
801058e8:	68 80 49 11 80       	push   $0x80114980
801058ed:	e8 c2 0f 00 00       	call   801068b4 <release>
801058f2:	83 c4 10             	add    $0x10,%esp
            return 0;
801058f5:	b8 00 00 00 00       	mov    $0x0,%eax
801058fa:	e9 c3 01 00 00       	jmp    80105ac2 <kill+0x298>
        }
        p = p->next;
801058ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105902:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105908:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct proc *p;

    acquire(&ptable.lock);
    // traverse Sleeping list, wake processes if necessary
    p = ptable.pLists.sleep;
    while (p) {
8010590b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010590f:	0f 85 38 ff ff ff    	jne    8010584d <kill+0x23>
        }
        p = p->next;
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
80105915:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010591c:	eb 5b                	jmp    80105979 <kill+0x14f>
        p = ptable.pLists.ready[i];
8010591e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105921:	05 cc 09 00 00       	add    $0x9cc,%eax
80105926:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
8010592d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
80105930:	eb 3d                	jmp    8010596f <kill+0x145>
            if (p->pid == pid) {
80105932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105935:	8b 50 10             	mov    0x10(%eax),%edx
80105938:	8b 45 08             	mov    0x8(%ebp),%eax
8010593b:	39 c2                	cmp    %eax,%edx
8010593d:	75 24                	jne    80105963 <kill+0x139>
                p->killed = 1;
8010593f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105942:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
                release(&ptable.lock);
80105949:	83 ec 0c             	sub    $0xc,%esp
8010594c:	68 80 49 11 80       	push   $0x80114980
80105951:	e8 5e 0f 00 00       	call   801068b4 <release>
80105956:	83 c4 10             	add    $0x10,%esp
                return 0;
80105959:	b8 00 00 00 00       	mov    $0x0,%eax
8010595e:	e9 5f 01 00 00       	jmp    80105ac2 <kill+0x298>
            }
            p = p->next;
80105963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105966:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010596c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i];
        while (p) {
8010596f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105973:	75 bd                	jne    80105932 <kill+0x108>
        }
        p = p->next;
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
80105975:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105979:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
8010597d:	7e 9f                	jle    8010591e <kill+0xf4>
            p = p->next;
        }
    }

    // traverse Running list
    p = ptable.pLists.running;
8010597f:	a1 e0 70 11 80       	mov    0x801170e0,%eax
80105984:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105987:	eb 3d                	jmp    801059c6 <kill+0x19c>
        if (p->pid == pid) {
80105989:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598c:	8b 50 10             	mov    0x10(%eax),%edx
8010598f:	8b 45 08             	mov    0x8(%ebp),%eax
80105992:	39 c2                	cmp    %eax,%edx
80105994:	75 24                	jne    801059ba <kill+0x190>
            p->killed = 1;
80105996:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105999:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	68 80 49 11 80       	push   $0x80114980
801059a8:	e8 07 0f 00 00       	call   801068b4 <release>
801059ad:	83 c4 10             	add    $0x10,%esp
            return 0;
801059b0:	b8 00 00 00 00       	mov    $0x0,%eax
801059b5:	e9 08 01 00 00       	jmp    80105ac2 <kill+0x298>
        }
        p = p->next;
801059ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059bd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
    }

    // traverse Running list
    p = ptable.pLists.running;
    while (p) {
801059c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059ca:	75 bd                	jne    80105989 <kill+0x15f>
        }
        p = p->next;
    }

    // traverse Unused List
    p = ptable.pLists.free;
801059cc:	a1 d4 70 11 80       	mov    0x801170d4,%eax
801059d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801059d4:	eb 3d                	jmp    80105a13 <kill+0x1e9>
        if (p->pid == pid) {
801059d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d9:	8b 50 10             	mov    0x10(%eax),%edx
801059dc:	8b 45 08             	mov    0x8(%ebp),%eax
801059df:	39 c2                	cmp    %eax,%edx
801059e1:	75 24                	jne    80105a07 <kill+0x1dd>
            p->killed = 1;
801059e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e6:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
801059ed:	83 ec 0c             	sub    $0xc,%esp
801059f0:	68 80 49 11 80       	push   $0x80114980
801059f5:	e8 ba 0e 00 00       	call   801068b4 <release>
801059fa:	83 c4 10             	add    $0x10,%esp
            return 0;
801059fd:	b8 00 00 00 00       	mov    $0x0,%eax
80105a02:	e9 bb 00 00 00       	jmp    80105ac2 <kill+0x298>
        }
        p = p->next;
80105a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a10:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Unused List
    p = ptable.pLists.free;
    while (p) {
80105a13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a17:	75 bd                	jne    801059d6 <kill+0x1ac>
        }
        p = p->next;
    }

    // traverse Zombie list
    p = ptable.pLists.zombie;
80105a19:	a1 dc 70 11 80       	mov    0x801170dc,%eax
80105a1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105a21:	eb 3a                	jmp    80105a5d <kill+0x233>
        if (p->pid == pid) {
80105a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a26:	8b 50 10             	mov    0x10(%eax),%edx
80105a29:	8b 45 08             	mov    0x8(%ebp),%eax
80105a2c:	39 c2                	cmp    %eax,%edx
80105a2e:	75 21                	jne    80105a51 <kill+0x227>
            p->killed = 1;
80105a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a33:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105a3a:	83 ec 0c             	sub    $0xc,%esp
80105a3d:	68 80 49 11 80       	push   $0x80114980
80105a42:	e8 6d 0e 00 00       	call   801068b4 <release>
80105a47:	83 c4 10             	add    $0x10,%esp
            return 0;
80105a4a:	b8 00 00 00 00       	mov    $0x0,%eax
80105a4f:	eb 71                	jmp    80105ac2 <kill+0x298>
        }
        p = p->next;
80105a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a54:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Zombie list
    p = ptable.pLists.zombie;
    while (p) {
80105a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a61:	75 c0                	jne    80105a23 <kill+0x1f9>
        }
        p = p->next;
    }

    // traverse Embryo list
    p = ptable.pLists.embryo;
80105a63:	a1 e4 70 11 80       	mov    0x801170e4,%eax
80105a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105a6b:	eb 3a                	jmp    80105aa7 <kill+0x27d>
        if (p->pid == pid) {
80105a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a70:	8b 50 10             	mov    0x10(%eax),%edx
80105a73:	8b 45 08             	mov    0x8(%ebp),%eax
80105a76:	39 c2                	cmp    %eax,%edx
80105a78:	75 21                	jne    80105a9b <kill+0x271>
            p->killed = 1;
80105a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a7d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105a84:	83 ec 0c             	sub    $0xc,%esp
80105a87:	68 80 49 11 80       	push   $0x80114980
80105a8c:	e8 23 0e 00 00       	call   801068b4 <release>
80105a91:	83 c4 10             	add    $0x10,%esp
            return 0;
80105a94:	b8 00 00 00 00       	mov    $0x0,%eax
80105a99:	eb 27                	jmp    80105ac2 <kill+0x298>
        }
        p = p->next;
80105a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a9e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Embryo list
    p = ptable.pLists.embryo;
    while (p) {
80105aa7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aab:	75 c0                	jne    80105a6d <kill+0x243>
        }
        p = p->next;
    }

    // return error
    release(&ptable.lock);
80105aad:	83 ec 0c             	sub    $0xc,%esp
80105ab0:	68 80 49 11 80       	push   $0x80114980
80105ab5:	e8 fa 0d 00 00       	call   801068b4 <release>
80105aba:	83 c4 10             	add    $0x10,%esp
    return -1;
80105abd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ac2:	c9                   	leave  
80105ac3:	c3                   	ret    

80105ac4 <elapsed_time>:
// No lock to avoid wedging a stuck machine further.

#ifdef CS333_P1
void
elapsed_time(uint p_ticks)
{
80105ac4:	55                   	push   %ebp
80105ac5:	89 e5                	mov    %esp,%ebp
80105ac7:	83 ec 28             	sub    $0x28,%esp
    uint elapsed, whole_sec, milisec_ten, milisec_hund, milisec_thou;
    //elapsed = ticks - p->start_ticks; // find original elapsed time
    elapsed = p_ticks;
80105aca:	8b 45 08             	mov    0x8(%ebp),%eax
80105acd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    whole_sec = (elapsed / 1000); // the the left of the decimal point
80105ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad3:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105ad8:	f7 e2                	mul    %edx
80105ada:	89 d0                	mov    %edx,%eax
80105adc:	c1 e8 06             	shr    $0x6,%eax
80105adf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // % to shave off leading digit of elapsed for decimal place calcs
    milisec_ten = ((elapsed %= 1000) / 100); // divide and round up to nearest int
80105ae2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105ae5:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105aea:	89 c8                	mov    %ecx,%eax
80105aec:	f7 e2                	mul    %edx
80105aee:	89 d0                	mov    %edx,%eax
80105af0:	c1 e8 06             	shr    $0x6,%eax
80105af3:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
80105af9:	29 c1                	sub    %eax,%ecx
80105afb:	89 c8                	mov    %ecx,%eax
80105afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b03:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105b08:	f7 e2                	mul    %edx
80105b0a:	89 d0                	mov    %edx,%eax
80105b0c:	c1 e8 05             	shr    $0x5,%eax
80105b0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    milisec_hund = ((elapsed %= 100) / 10); // shave off previously counted int, repeat
80105b12:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105b15:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105b1a:	89 c8                	mov    %ecx,%eax
80105b1c:	f7 e2                	mul    %edx
80105b1e:	89 d0                	mov    %edx,%eax
80105b20:	c1 e8 05             	shr    $0x5,%eax
80105b23:	6b c0 64             	imul   $0x64,%eax,%eax
80105b26:	29 c1                	sub    %eax,%ecx
80105b28:	89 c8                	mov    %ecx,%eax
80105b2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b30:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105b35:	f7 e2                	mul    %edx
80105b37:	89 d0                	mov    %edx,%eax
80105b39:	c1 e8 03             	shr    $0x3,%eax
80105b3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    milisec_thou = (elapsed %= 10); // determine thousandth place
80105b3f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105b42:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105b47:	89 c8                	mov    %ecx,%eax
80105b49:	f7 e2                	mul    %edx
80105b4b:	c1 ea 03             	shr    $0x3,%edx
80105b4e:	89 d0                	mov    %edx,%eax
80105b50:	c1 e0 02             	shl    $0x2,%eax
80105b53:	01 d0                	add    %edx,%eax
80105b55:	01 c0                	add    %eax,%eax
80105b57:	29 c1                	sub    %eax,%ecx
80105b59:	89 c8                	mov    %ecx,%eax
80105b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("\t%d.%d%d%d", whole_sec, milisec_ten, milisec_hund, milisec_thou);
80105b64:	83 ec 0c             	sub    $0xc,%esp
80105b67:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b6a:	ff 75 e8             	pushl  -0x18(%ebp)
80105b6d:	ff 75 ec             	pushl  -0x14(%ebp)
80105b70:	ff 75 f0             	pushl  -0x10(%ebp)
80105b73:	68 c9 a7 10 80       	push   $0x8010a7c9
80105b78:	e8 49 a8 ff ff       	call   801003c6 <cprintf>
80105b7d:	83 c4 20             	add    $0x20,%esp
}
80105b80:	90                   	nop
80105b81:	c9                   	leave  
80105b82:	c3                   	ret    

80105b83 <procdump>:
#else

// Project 3 & 4
void
procdump(void)
{
80105b83:	55                   	push   %ebp
80105b84:	89 e5                	mov    %esp,%ebp
80105b86:	56                   	push   %esi
80105b87:	53                   	push   %ebx
80105b88:	83 ec 40             	sub    $0x40,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
80105b8b:	68 d4 a7 10 80       	push   $0x8010a7d4
80105b90:	68 d8 a7 10 80       	push   $0x8010a7d8
80105b95:	68 dd a7 10 80       	push   $0x8010a7dd
80105b9a:	68 e3 a7 10 80       	push   $0x8010a7e3
80105b9f:	68 e7 a7 10 80       	push   $0x8010a7e7
80105ba4:	68 ef a7 10 80       	push   $0x8010a7ef
80105ba9:	68 f4 a7 10 80       	push   $0x8010a7f4
80105bae:	68 f9 a7 10 80       	push   $0x8010a7f9
80105bb3:	68 fd a7 10 80       	push   $0x8010a7fd
80105bb8:	68 01 a8 10 80       	push   $0x8010a801
80105bbd:	68 06 a8 10 80       	push   $0x8010a806
80105bc2:	68 0c a8 10 80       	push   $0x8010a80c
80105bc7:	e8 fa a7 ff ff       	call   801003c6 <cprintf>
80105bcc:	83 c4 30             	add    $0x30,%esp
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105bcf:	c7 45 f0 b4 49 11 80 	movl   $0x801149b4,-0x10(%ebp)
80105bd6:	e9 5c 01 00 00       	jmp    80105d37 <procdump+0x1b4>
        if(p->state == UNUSED)
80105bdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bde:	8b 40 0c             	mov    0xc(%eax),%eax
80105be1:	85 c0                	test   %eax,%eax
80105be3:	0f 84 46 01 00 00    	je     80105d2f <procdump+0x1ac>
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bec:	8b 40 0c             	mov    0xc(%eax),%eax
80105bef:	83 f8 05             	cmp    $0x5,%eax
80105bf2:	77 23                	ja     80105c17 <procdump+0x94>
80105bf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bf7:	8b 40 0c             	mov    0xc(%eax),%eax
80105bfa:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105c01:	85 c0                	test   %eax,%eax
80105c03:	74 12                	je     80105c17 <procdump+0x94>
            state = states[p->state];
80105c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c08:	8b 40 0c             	mov    0xc(%eax),%eax
80105c0b:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105c12:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105c15:	eb 07                	jmp    80105c1e <procdump+0x9b>
        else
            state = "???";
80105c17:	c7 45 ec 2f a8 10 80 	movl   $0x8010a82f,-0x14(%ebp)
        cprintf("%d\t%s\t%d\t%d\t%d",
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
80105c1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c21:	8b 40 14             	mov    0x14(%eax),%eax
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d\t%s\t%d\t%d\t%d",
80105c24:	8b 58 10             	mov    0x10(%eax),%ebx
80105c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c2a:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c33:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
80105c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c3c:	8d 70 6c             	lea    0x6c(%eax),%esi
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d\t%s\t%d\t%d\t%d",
80105c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c42:	8b 40 10             	mov    0x10(%eax),%eax
80105c45:	83 ec 08             	sub    $0x8,%esp
80105c48:	53                   	push   %ebx
80105c49:	51                   	push   %ecx
80105c4a:	52                   	push   %edx
80105c4b:	56                   	push   %esi
80105c4c:	50                   	push   %eax
80105c4d:	68 33 a8 10 80       	push   $0x8010a833
80105c52:	e8 6f a7 ff ff       	call   801003c6 <cprintf>
80105c57:	83 c4 20             	add    $0x20,%esp
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
        cprintf("\t%d", p->priority);
80105c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c5d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105c63:	83 ec 08             	sub    $0x8,%esp
80105c66:	50                   	push   %eax
80105c67:	68 42 a8 10 80       	push   $0x8010a842
80105c6c:	e8 55 a7 ff ff       	call   801003c6 <cprintf>
80105c71:	83 c4 10             	add    $0x10,%esp
        elapsed_time(ticks - p->start_ticks);
80105c74:	8b 15 00 79 11 80    	mov    0x80117900,%edx
80105c7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c7d:	8b 40 7c             	mov    0x7c(%eax),%eax
80105c80:	29 c2                	sub    %eax,%edx
80105c82:	89 d0                	mov    %edx,%eax
80105c84:	83 ec 0c             	sub    $0xc,%esp
80105c87:	50                   	push   %eax
80105c88:	e8 37 fe ff ff       	call   80105ac4 <elapsed_time>
80105c8d:	83 c4 10             	add    $0x10,%esp
        elapsed_time(p->cpu_ticks_total);
80105c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c93:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105c99:	83 ec 0c             	sub    $0xc,%esp
80105c9c:	50                   	push   %eax
80105c9d:	e8 22 fe ff ff       	call   80105ac4 <elapsed_time>
80105ca2:	83 c4 10             	add    $0x10,%esp
        cprintf("\t%s\t%d", state, p->sz);
80105ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca8:	8b 00                	mov    (%eax),%eax
80105caa:	83 ec 04             	sub    $0x4,%esp
80105cad:	50                   	push   %eax
80105cae:	ff 75 ec             	pushl  -0x14(%ebp)
80105cb1:	68 46 a8 10 80       	push   $0x8010a846
80105cb6:	e8 0b a7 ff ff       	call   801003c6 <cprintf>
80105cbb:	83 c4 10             	add    $0x10,%esp

        if(p->state == SLEEPING){
80105cbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cc1:	8b 40 0c             	mov    0xc(%eax),%eax
80105cc4:	83 f8 02             	cmp    $0x2,%eax
80105cc7:	75 54                	jne    80105d1d <procdump+0x19a>
            getcallerpcs((uint*)p->context->ebp+2, pc);
80105cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ccc:	8b 40 1c             	mov    0x1c(%eax),%eax
80105ccf:	8b 40 0c             	mov    0xc(%eax),%eax
80105cd2:	83 c0 08             	add    $0x8,%eax
80105cd5:	89 c2                	mov    %eax,%edx
80105cd7:	83 ec 08             	sub    $0x8,%esp
80105cda:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105cdd:	50                   	push   %eax
80105cde:	52                   	push   %edx
80105cdf:	e8 22 0c 00 00       	call   80106906 <getcallerpcs>
80105ce4:	83 c4 10             	add    $0x10,%esp
            for(i=0; i<10 && pc[i] != 0; i++)
80105ce7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105cee:	eb 1c                	jmp    80105d0c <procdump+0x189>
                cprintf("\t%p", pc[i]);
80105cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf3:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105cf7:	83 ec 08             	sub    $0x8,%esp
80105cfa:	50                   	push   %eax
80105cfb:	68 4d a8 10 80       	push   $0x8010a84d
80105d00:	e8 c1 a6 ff ff       	call   801003c6 <cprintf>
80105d05:	83 c4 10             	add    $0x10,%esp
        elapsed_time(p->cpu_ticks_total);
        cprintf("\t%s\t%d", state, p->sz);

        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
80105d08:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105d0c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105d10:	7f 0b                	jg     80105d1d <procdump+0x19a>
80105d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d15:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105d19:	85 c0                	test   %eax,%eax
80105d1b:	75 d3                	jne    80105cf0 <procdump+0x16d>
                cprintf("\t%p", pc[i]);
        }
        cprintf("\n");
80105d1d:	83 ec 0c             	sub    $0xc,%esp
80105d20:	68 51 a8 10 80       	push   $0x8010a851
80105d25:	e8 9c a6 ff ff       	call   801003c6 <cprintf>
80105d2a:	83 c4 10             	add    $0x10,%esp
80105d2d:	eb 01                	jmp    80105d30 <procdump+0x1ad>
    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
80105d2f:	90                   	nop
    uint pc[10];

    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d30:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105d37:	81 7d f0 b4 70 11 80 	cmpl   $0x801170b4,-0x10(%ebp)
80105d3e:	0f 82 97 fe ff ff    	jb     80105bdb <procdump+0x58>
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf("\t%p", pc[i]);
        }
        cprintf("\n");
    }
}
80105d44:	90                   	nop
80105d45:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d48:	5b                   	pop    %ebx
80105d49:	5e                   	pop    %esi
80105d4a:	5d                   	pop    %ebp
80105d4b:	c3                   	ret    

80105d4c <getprocs>:
#ifdef CS333_P2
// loop process table and copy active processes, return number of copied procs
// populate uproc array passed in from ps.c
int
getprocs(uint max, struct uproc *table)
{
80105d4c:	55                   	push   %ebp
80105d4d:	89 e5                	mov    %esp,%ebp
80105d4f:	83 ec 18             	sub    $0x18,%esp
    int i = 0;
80105d52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct proc *p;
    acquire(&ptable.lock);
80105d59:	83 ec 0c             	sub    $0xc,%esp
80105d5c:	68 80 49 11 80       	push   $0x80114980
80105d61:	e8 e7 0a 00 00       	call   8010684d <acquire>
80105d66:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
80105d69:	c7 45 f0 b4 49 11 80 	movl   $0x801149b4,-0x10(%ebp)
80105d70:	e9 ab 01 00 00       	jmp    80105f20 <getprocs+0x1d4>
        // only copy active processes
        if (p->state == RUNNABLE || p->state == RUNNING || p->state == SLEEPING) {
80105d75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d78:	8b 40 0c             	mov    0xc(%eax),%eax
80105d7b:	83 f8 03             	cmp    $0x3,%eax
80105d7e:	74 1a                	je     80105d9a <getprocs+0x4e>
80105d80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d83:	8b 40 0c             	mov    0xc(%eax),%eax
80105d86:	83 f8 04             	cmp    $0x4,%eax
80105d89:	74 0f                	je     80105d9a <getprocs+0x4e>
80105d8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d8e:	8b 40 0c             	mov    0xc(%eax),%eax
80105d91:	83 f8 02             	cmp    $0x2,%eax
80105d94:	0f 85 7f 01 00 00    	jne    80105f19 <getprocs+0x1cd>
            table[i].pid = p->pid;
80105d9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d9d:	89 d0                	mov    %edx,%eax
80105d9f:	01 c0                	add    %eax,%eax
80105da1:	01 d0                	add    %edx,%eax
80105da3:	c1 e0 05             	shl    $0x5,%eax
80105da6:	89 c2                	mov    %eax,%edx
80105da8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dab:	01 c2                	add    %eax,%edx
80105dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db0:	8b 40 10             	mov    0x10(%eax),%eax
80105db3:	89 02                	mov    %eax,(%edx)
            table[i].uid = p->uid;
80105db5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105db8:	89 d0                	mov    %edx,%eax
80105dba:	01 c0                	add    %eax,%eax
80105dbc:	01 d0                	add    %edx,%eax
80105dbe:	c1 e0 05             	shl    $0x5,%eax
80105dc1:	89 c2                	mov    %eax,%edx
80105dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dc6:	01 c2                	add    %eax,%edx
80105dc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dcb:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105dd1:	89 42 04             	mov    %eax,0x4(%edx)
            table[i].gid = p->gid;
80105dd4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dd7:	89 d0                	mov    %edx,%eax
80105dd9:	01 c0                	add    %eax,%eax
80105ddb:	01 d0                	add    %edx,%eax
80105ddd:	c1 e0 05             	shl    $0x5,%eax
80105de0:	89 c2                	mov    %eax,%edx
80105de2:	8b 45 0c             	mov    0xc(%ebp),%eax
80105de5:	01 c2                	add    %eax,%edx
80105de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dea:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105df0:	89 42 08             	mov    %eax,0x8(%edx)
            if (p->pid == 1) {
80105df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105df6:	8b 40 10             	mov    0x10(%eax),%eax
80105df9:	83 f8 01             	cmp    $0x1,%eax
80105dfc:	75 1c                	jne    80105e1a <getprocs+0xce>
                table[i].ppid = 1;
80105dfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e01:	89 d0                	mov    %edx,%eax
80105e03:	01 c0                	add    %eax,%eax
80105e05:	01 d0                	add    %edx,%eax
80105e07:	c1 e0 05             	shl    $0x5,%eax
80105e0a:	89 c2                	mov    %eax,%edx
80105e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e0f:	01 d0                	add    %edx,%eax
80105e11:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
80105e18:	eb 1f                	jmp    80105e39 <getprocs+0xed>
            } else {
                table[i].ppid = p->parent->pid;
80105e1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e1d:	89 d0                	mov    %edx,%eax
80105e1f:	01 c0                	add    %eax,%eax
80105e21:	01 d0                	add    %edx,%eax
80105e23:	c1 e0 05             	shl    $0x5,%eax
80105e26:	89 c2                	mov    %eax,%edx
80105e28:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e2b:	01 c2                	add    %eax,%edx
80105e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e30:	8b 40 14             	mov    0x14(%eax),%eax
80105e33:	8b 40 10             	mov    0x10(%eax),%eax
80105e36:	89 42 0c             	mov    %eax,0xc(%edx)
            }
#ifdef CS333_P3P4
            table[i].priority = p->priority;
80105e39:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e3c:	89 d0                	mov    %edx,%eax
80105e3e:	01 c0                	add    %eax,%eax
80105e40:	01 d0                	add    %edx,%eax
80105e42:	c1 e0 05             	shl    $0x5,%eax
80105e45:	89 c2                	mov    %eax,%edx
80105e47:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e4a:	01 c2                	add    %eax,%edx
80105e4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e4f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105e55:	89 42 5c             	mov    %eax,0x5c(%edx)
#endif
            table[i].elapsed_ticks = (ticks - p->start_ticks);
80105e58:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e5b:	89 d0                	mov    %edx,%eax
80105e5d:	01 c0                	add    %eax,%eax
80105e5f:	01 d0                	add    %edx,%eax
80105e61:	c1 e0 05             	shl    $0x5,%eax
80105e64:	89 c2                	mov    %eax,%edx
80105e66:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e69:	01 c2                	add    %eax,%edx
80105e6b:	8b 0d 00 79 11 80    	mov    0x80117900,%ecx
80105e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e74:	8b 40 7c             	mov    0x7c(%eax),%eax
80105e77:	29 c1                	sub    %eax,%ecx
80105e79:	89 c8                	mov    %ecx,%eax
80105e7b:	89 42 10             	mov    %eax,0x10(%edx)
            table[i].CPU_total_ticks = p->cpu_ticks_total;
80105e7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e81:	89 d0                	mov    %edx,%eax
80105e83:	01 c0                	add    %eax,%eax
80105e85:	01 d0                	add    %edx,%eax
80105e87:	c1 e0 05             	shl    $0x5,%eax
80105e8a:	89 c2                	mov    %eax,%edx
80105e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e8f:	01 c2                	add    %eax,%edx
80105e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e94:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105e9a:	89 42 14             	mov    %eax,0x14(%edx)
            safestrcpy(table[i].state, states[p->state], STRMAX);
80105e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea0:	8b 40 0c             	mov    0xc(%eax),%eax
80105ea3:	8b 0c 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%ecx
80105eaa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ead:	89 d0                	mov    %edx,%eax
80105eaf:	01 c0                	add    %eax,%eax
80105eb1:	01 d0                	add    %edx,%eax
80105eb3:	c1 e0 05             	shl    $0x5,%eax
80105eb6:	89 c2                	mov    %eax,%edx
80105eb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ebb:	01 d0                	add    %edx,%eax
80105ebd:	83 c0 18             	add    $0x18,%eax
80105ec0:	83 ec 04             	sub    $0x4,%esp
80105ec3:	6a 20                	push   $0x20
80105ec5:	51                   	push   %ecx
80105ec6:	50                   	push   %eax
80105ec7:	e8 e7 0d 00 00       	call   80106cb3 <safestrcpy>
80105ecc:	83 c4 10             	add    $0x10,%esp
            table[i].size = p->sz;
80105ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ed2:	89 d0                	mov    %edx,%eax
80105ed4:	01 c0                	add    %eax,%eax
80105ed6:	01 d0                	add    %edx,%eax
80105ed8:	c1 e0 05             	shl    $0x5,%eax
80105edb:	89 c2                	mov    %eax,%edx
80105edd:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ee0:	01 c2                	add    %eax,%edx
80105ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ee5:	8b 00                	mov    (%eax),%eax
80105ee7:	89 42 38             	mov    %eax,0x38(%edx)
            safestrcpy(table[i].name, p->name, STRMAX);
80105eea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eed:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105ef0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ef3:	89 d0                	mov    %edx,%eax
80105ef5:	01 c0                	add    %eax,%eax
80105ef7:	01 d0                	add    %edx,%eax
80105ef9:	c1 e0 05             	shl    $0x5,%eax
80105efc:	89 c2                	mov    %eax,%edx
80105efe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105f01:	01 d0                	add    %edx,%eax
80105f03:	83 c0 3c             	add    $0x3c,%eax
80105f06:	83 ec 04             	sub    $0x4,%esp
80105f09:	6a 20                	push   $0x20
80105f0b:	51                   	push   %ecx
80105f0c:	50                   	push   %eax
80105f0d:	e8 a1 0d 00 00       	call   80106cb3 <safestrcpy>
80105f12:	83 c4 10             	add    $0x10,%esp
            ++i;
80105f15:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
getprocs(uint max, struct uproc *table)
{
    int i = 0;
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
80105f19:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105f20:	81 7d f0 b4 70 11 80 	cmpl   $0x801170b4,-0x10(%ebp)
80105f27:	73 0c                	jae    80105f35 <getprocs+0x1e9>
80105f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f2c:	3b 45 08             	cmp    0x8(%ebp),%eax
80105f2f:	0f 82 40 fe ff ff    	jb     80105d75 <getprocs+0x29>
            table[i].size = p->sz;
            safestrcpy(table[i].name, p->name, STRMAX);
            ++i;
        }
    }
    release(&ptable.lock);
80105f35:	83 ec 0c             	sub    $0xc,%esp
80105f38:	68 80 49 11 80       	push   $0x80114980
80105f3d:	e8 72 09 00 00       	call   801068b4 <release>
80105f42:	83 c4 10             	add    $0x10,%esp
    return i; // return number of procs copied
80105f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f48:	c9                   	leave  
80105f49:	c3                   	ret    

80105f4a <assertState>:


//PROJECT 3
// assert that process is in proper state, otherwise panic
static void
assertState(struct proc* p, enum procstate state) {
80105f4a:	55                   	push   %ebp
80105f4b:	89 e5                	mov    %esp,%ebp
80105f4d:	83 ec 08             	sub    $0x8,%esp
    if (!p) {
80105f50:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105f54:	75 0d                	jne    80105f63 <assertState+0x19>
        panic("assertState: invalid proc argument.\n");
80105f56:	83 ec 0c             	sub    $0xc,%esp
80105f59:	68 54 a8 10 80       	push   $0x8010a854
80105f5e:	e8 03 a6 ff ff       	call   80100566 <panic>
    }
    if (p->state != state) {
80105f63:	8b 45 08             	mov    0x8(%ebp),%eax
80105f66:	8b 40 0c             	mov    0xc(%eax),%eax
80105f69:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105f6c:	74 0d                	je     80105f7b <assertState+0x31>
        panic("assertState: process in wrong state.\n");
80105f6e:	83 ec 0c             	sub    $0xc,%esp
80105f71:	68 7c a8 10 80       	push   $0x8010a87c
80105f76:	e8 eb a5 ff ff       	call   80100566 <panic>
    }
}
80105f7b:	90                   	nop
80105f7c:	c9                   	leave  
80105f7d:	c3                   	ret    

80105f7e <addToStateListHead>:

static int
addToStateListHead(struct proc** sList, struct proc* p) {
80105f7e:	55                   	push   %ebp
80105f7f:	89 e5                	mov    %esp,%ebp
80105f81:	83 ec 08             	sub    $0x8,%esp
    if (!p) {
80105f84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105f88:	75 0d                	jne    80105f97 <addToStateListHead+0x19>
        panic("Invalid process.");
80105f8a:	83 ec 0c             	sub    $0xc,%esp
80105f8d:	68 a2 a8 10 80       	push   $0x8010a8a2
80105f92:	e8 cf a5 ff ff       	call   80100566 <panic>
    }
    if (!(*sList)) { // if no list exists, make first entry
80105f97:	8b 45 08             	mov    0x8(%ebp),%eax
80105f9a:	8b 00                	mov    (%eax),%eax
80105f9c:	85 c0                	test   %eax,%eax
80105f9e:	75 1c                	jne    80105fbc <addToStateListHead+0x3e>
        (*sList) = p; // arg proc is now the first item in list
80105fa0:	8b 45 08             	mov    0x8(%ebp),%eax
80105fa3:	8b 55 0c             	mov    0xc(%ebp),%edx
80105fa6:	89 10                	mov    %edx,(%eax)
        p->next = 0; // next is null
80105fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fab:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105fb2:	00 00 00 
        return 0; // return success
80105fb5:	b8 00 00 00 00       	mov    $0x0,%eax
80105fba:	eb 2c                	jmp    80105fe8 <addToStateListHead+0x6a>
    }
    // otherwise hold to next element and become 1st element
    p->next = (*sList); // arg proc has next element
80105fbc:	8b 45 08             	mov    0x8(%ebp),%eax
80105fbf:	8b 10                	mov    (%eax),%edx
80105fc1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fc4:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    (*sList) = p; // reassign head of list to arg proc
80105fca:	8b 45 08             	mov    0x8(%ebp),%eax
80105fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
80105fd0:	89 10                	mov    %edx,(%eax)
    if (p != (*sList)) {
80105fd2:	8b 45 08             	mov    0x8(%ebp),%eax
80105fd5:	8b 00                	mov    (%eax),%eax
80105fd7:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105fda:	74 07                	je     80105fe3 <addToStateListHead+0x65>
        return -1; // if they don't match, return failure
80105fdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fe1:	eb 05                	jmp    80105fe8 <addToStateListHead+0x6a>
    }
    return 0; // return success
80105fe3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fe8:	c9                   	leave  
80105fe9:	c3                   	ret    

80105fea <addToStateListEnd>:

static int
addToStateListEnd(struct proc** sList, struct proc* p) {
80105fea:	55                   	push   %ebp
80105feb:	89 e5                	mov    %esp,%ebp
80105fed:	83 ec 18             	sub    $0x18,%esp
    if (!p) {
80105ff0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105ff4:	75 0d                	jne    80106003 <addToStateListEnd+0x19>
        panic("Invalid process.");
80105ff6:	83 ec 0c             	sub    $0xc,%esp
80105ff9:	68 a2 a8 10 80       	push   $0x8010a8a2
80105ffe:	e8 63 a5 ff ff       	call   80100566 <panic>
    }
    // if list desn't exist yet, initialize
    if (!(*sList)) {
80106003:	8b 45 08             	mov    0x8(%ebp),%eax
80106006:	8b 00                	mov    (%eax),%eax
80106008:	85 c0                	test   %eax,%eax
8010600a:	75 1c                	jne    80106028 <addToStateListEnd+0x3e>
        (*sList) = p;
8010600c:	8b 45 08             	mov    0x8(%ebp),%eax
8010600f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106012:	89 10                	mov    %edx,(%eax)
        p->next = 0;
80106014:	8b 45 0c             	mov    0xc(%ebp),%eax
80106017:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
8010601e:	00 00 00 
        return 0;
80106021:	b8 00 00 00 00       	mov    $0x0,%eax
80106026:	eb 41                	jmp    80106069 <addToStateListEnd+0x7f>
    }
    // otherwise traverse and add at the end
    struct proc * current = (*sList);
80106028:	8b 45 08             	mov    0x8(%ebp),%eax
8010602b:	8b 00                	mov    (%eax),%eax
8010602d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (current->next) {
80106030:	eb 0c                	jmp    8010603e <addToStateListEnd+0x54>
        current = current->next;
80106032:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106035:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010603b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p->next = 0;
        return 0;
    }
    // otherwise traverse and add at the end
    struct proc * current = (*sList);
    while (current->next) {
8010603e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106041:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106047:	85 c0                	test   %eax,%eax
80106049:	75 e7                	jne    80106032 <addToStateListEnd+0x48>
        current = current->next;
    }
    current->next = p;
8010604b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010604e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106051:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    p->next = 0;
80106057:	8b 45 0c             	mov    0xc(%ebp),%eax
8010605a:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106061:	00 00 00 
    return 0;
80106064:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106069:	c9                   	leave  
8010606a:	c3                   	ret    

8010606b <removeFromStateList>:

// search and remove process based on pointer address
static int
removeFromStateList(struct proc** sList, struct proc* p) {
8010606b:	55                   	push   %ebp
8010606c:	89 e5                	mov    %esp,%ebp
8010606e:	83 ec 18             	sub    $0x18,%esp
    if (!p) {
80106071:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106075:	75 0d                	jne    80106084 <removeFromStateList+0x19>
        panic("Invalid process structures.");
80106077:	83 ec 0c             	sub    $0xc,%esp
8010607a:	68 b3 a8 10 80       	push   $0x8010a8b3
8010607f:	e8 e2 a4 ff ff       	call   80100566 <panic>
    }
    if (!(*sList)) {
80106084:	8b 45 08             	mov    0x8(%ebp),%eax
80106087:	8b 00                	mov    (%eax),%eax
80106089:	85 c0                	test   %eax,%eax
8010608b:	75 0a                	jne    80106097 <removeFromStateList+0x2c>
        return -1;
8010608d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106092:	e9 c6 00 00 00       	jmp    8010615d <removeFromStateList+0xf2>
    }
    // if p is the first element in list
    if (p == (*sList)) {
80106097:	8b 45 08             	mov    0x8(%ebp),%eax
8010609a:	8b 00                	mov    (%eax),%eax
8010609c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010609f:	75 59                	jne    801060fa <removeFromStateList+0x8f>
        // if it is the only item in list
        if (!(*sList)->next) {
801060a1:	8b 45 08             	mov    0x8(%ebp),%eax
801060a4:	8b 00                	mov    (%eax),%eax
801060a6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060ac:	85 c0                	test   %eax,%eax
801060ae:	75 20                	jne    801060d0 <removeFromStateList+0x65>
            (*sList) = 0;
801060b0:	8b 45 08             	mov    0x8(%ebp),%eax
801060b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            p->next = 0;
801060b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801060bc:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801060c3:	00 00 00 
            return 0;
801060c6:	b8 00 00 00 00       	mov    $0x0,%eax
801060cb:	e9 8d 00 00 00       	jmp    8010615d <removeFromStateList+0xf2>
        }
        // if p is the first item in list
        else {
            struct proc * temp = (*sList)->next;
801060d0:	8b 45 08             	mov    0x8(%ebp),%eax
801060d3:	8b 00                	mov    (%eax),%eax
801060d5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060db:	89 45 ec             	mov    %eax,-0x14(%ebp)
            p->next = 0;
801060de:	8b 45 0c             	mov    0xc(%ebp),%eax
801060e1:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801060e8:	00 00 00 
            (*sList) = temp;
801060eb:	8b 45 08             	mov    0x8(%ebp),%eax
801060ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
801060f1:	89 10                	mov    %edx,(%eax)
            return 0;
801060f3:	b8 00 00 00 00       	mov    $0x0,%eax
801060f8:	eb 63                	jmp    8010615d <removeFromStateList+0xf2>
        }
    }
    // from middle or end of list
    else {
        struct proc * current = (*sList)->next;
801060fa:	8b 45 08             	mov    0x8(%ebp),%eax
801060fd:	8b 00                	mov    (%eax),%eax
801060ff:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106105:	89 45 f4             	mov    %eax,-0xc(%ebp)
        struct proc * prev = (*sList);
80106108:	8b 45 08             	mov    0x8(%ebp),%eax
8010610b:	8b 00                	mov    (%eax),%eax
8010610d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while (current) {
80106110:	eb 40                	jmp    80106152 <removeFromStateList+0xe7>
            if (current == p) {
80106112:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106115:	3b 45 0c             	cmp    0xc(%ebp),%eax
80106118:	75 26                	jne    80106140 <removeFromStateList+0xd5>
                prev->next = current->next;
8010611a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010611d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80106123:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106126:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
                p->next = 0;
8010612c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010612f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106136:	00 00 00 
                return 0;
80106139:	b8 00 00 00 00       	mov    $0x0,%eax
8010613e:	eb 1d                	jmp    8010615d <removeFromStateList+0xf2>
            }
            prev = current;
80106140:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106143:	89 45 f0             	mov    %eax,-0x10(%ebp)
            current = current->next;
80106146:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106149:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010614f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    // from middle or end of list
    else {
        struct proc * current = (*sList)->next;
        struct proc * prev = (*sList);
        while (current) {
80106152:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106156:	75 ba                	jne    80106112 <removeFromStateList+0xa7>
            }
            prev = current;
            current = current->next;
        }
    }
    return -1; // nothing found
80106158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010615d:	c9                   	leave  
8010615e:	c3                   	ret    

8010615f <removeHead>:

// remove first element of list, return its pointer
static struct proc*
removeHead(struct proc** sList) {
8010615f:	55                   	push   %ebp
80106160:	89 e5                	mov    %esp,%ebp
80106162:	83 ec 10             	sub    $0x10,%esp
    if (!(*sList)) {
80106165:	8b 45 08             	mov    0x8(%ebp),%eax
80106168:	8b 00                	mov    (%eax),%eax
8010616a:	85 c0                	test   %eax,%eax
8010616c:	75 07                	jne    80106175 <removeHead+0x16>
        return 0; // return null, check value in calling routine
8010616e:	b8 00 00 00 00       	mov    $0x0,%eax
80106173:	eb 2e                	jmp    801061a3 <removeHead+0x44>
    }
    struct proc* p = (*sList); // assign pointer to head of sList
80106175:	8b 45 08             	mov    0x8(%ebp),%eax
80106178:	8b 00                	mov    (%eax),%eax
8010617a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    struct proc* temp = (*sList)->next; // hold onto next element in list
8010617d:	8b 45 08             	mov    0x8(%ebp),%eax
80106180:	8b 00                	mov    (%eax),%eax
80106182:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106188:	89 45 f8             	mov    %eax,-0x8(%ebp)
    p->next = 0; // p is no longer head of sList
8010618b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010618e:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106195:	00 00 00 
    (*sList) = temp; // sList now starts at  2nd element, or is NULL if one-item list
80106198:	8b 45 08             	mov    0x8(%ebp),%eax
8010619b:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010619e:	89 10                	mov    %edx,(%eax)
    return p; // return 
801061a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801061a3:	c9                   	leave  
801061a4:	c3                   	ret    

801061a5 <printReadyList>:

// print PIDs of all procs in Ready list
void
printReadyList(void) {
801061a5:	55                   	push   %ebp
801061a6:	89 e5                	mov    %esp,%ebp
801061a8:	83 ec 18             	sub    $0x18,%esp
    //int i = 0;
    cprintf("\nReady List Processes:\n");
801061ab:	83 ec 0c             	sub    $0xc,%esp
801061ae:	68 cf a8 10 80       	push   $0x8010a8cf
801061b3:	e8 0e a2 ff ff       	call   801003c6 <cprintf>
801061b8:	83 c4 10             	add    $0x10,%esp
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
801061bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801061c2:	e9 ca 00 00 00       	jmp    80106291 <printReadyList+0xec>
        if (ptable.pLists.ready[i]) {
801061c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ca:	05 cc 09 00 00       	add    $0x9cc,%eax
801061cf:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
801061d6:	85 c0                	test   %eax,%eax
801061d8:	0f 84 9c 00 00 00    	je     8010627a <printReadyList+0xd5>
            cprintf("\n%d: ", i);
801061de:	83 ec 08             	sub    $0x8,%esp
801061e1:	ff 75 f4             	pushl  -0xc(%ebp)
801061e4:	68 e7 a8 10 80       	push   $0x8010a8e7
801061e9:	e8 d8 a1 ff ff       	call   801003c6 <cprintf>
801061ee:	83 c4 10             	add    $0x10,%esp
            struct proc* current = ptable.pLists.ready[i];
801061f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f4:	05 cc 09 00 00       	add    $0x9cc,%eax
801061f9:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80106200:	89 45 f0             	mov    %eax,-0x10(%ebp)
            while (current) {
80106203:	eb 5d                	jmp    80106262 <printReadyList+0xbd>
                if (current->next) {
80106205:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106208:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010620e:	85 c0                	test   %eax,%eax
80106210:	74 23                	je     80106235 <printReadyList+0x90>
                    cprintf("(%d, %d)-> ", current->pid, current->budget);
80106212:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106215:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010621b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010621e:	8b 40 10             	mov    0x10(%eax),%eax
80106221:	83 ec 04             	sub    $0x4,%esp
80106224:	52                   	push   %edx
80106225:	50                   	push   %eax
80106226:	68 ed a8 10 80       	push   $0x8010a8ed
8010622b:	e8 96 a1 ff ff       	call   801003c6 <cprintf>
80106230:	83 c4 10             	add    $0x10,%esp
80106233:	eb 21                	jmp    80106256 <printReadyList+0xb1>
                } else {
                    cprintf("(%d, %d)", current->pid, current->budget);
80106235:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106238:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010623e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106241:	8b 40 10             	mov    0x10(%eax),%eax
80106244:	83 ec 04             	sub    $0x4,%esp
80106247:	52                   	push   %edx
80106248:	50                   	push   %eax
80106249:	68 f9 a8 10 80       	push   $0x8010a8f9
8010624e:	e8 73 a1 ff ff       	call   801003c6 <cprintf>
80106253:	83 c4 10             	add    $0x10,%esp
                }
                current = current->next;
80106256:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106259:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010625f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
        if (ptable.pLists.ready[i]) {
            cprintf("\n%d: ", i);
            struct proc* current = ptable.pLists.ready[i];
            while (current) {
80106262:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106266:	75 9d                	jne    80106205 <printReadyList+0x60>
                } else {
                    cprintf("(%d, %d)", current->pid, current->budget);
                }
                current = current->next;
            }
            cprintf("\n");
80106268:	83 ec 0c             	sub    $0xc,%esp
8010626b:	68 51 a8 10 80       	push   $0x8010a851
80106270:	e8 51 a1 ff ff       	call   801003c6 <cprintf>
80106275:	83 c4 10             	add    $0x10,%esp
80106278:	eb 13                	jmp    8010628d <printReadyList+0xe8>
        }
        else {
            cprintf("\n%d: Empty.\n", i);
8010627a:	83 ec 08             	sub    $0x8,%esp
8010627d:	ff 75 f4             	pushl  -0xc(%ebp)
80106280:	68 02 a9 10 80       	push   $0x8010a902
80106285:	e8 3c a1 ff ff       	call   801003c6 <cprintf>
8010628a:	83 c4 10             	add    $0x10,%esp
void
printReadyList(void) {
    //int i = 0;
    cprintf("\nReady List Processes:\n");
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
8010628d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106291:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80106295:	0f 8e 2c ff ff ff    	jle    801061c7 <printReadyList+0x22>
        else {
            cprintf("\n%d: Empty.\n", i);
        }
        //++i;
    }
}
8010629b:	90                   	nop
8010629c:	c9                   	leave  
8010629d:	c3                   	ret    

8010629e <printFreeList>:

// print number of procs in Free list
void
printFreeList(void) {
8010629e:	55                   	push   %ebp
8010629f:	89 e5                	mov    %esp,%ebp
801062a1:	83 ec 18             	sub    $0x18,%esp
    if (ptable.pLists.free) {
801062a4:	a1 d4 70 11 80       	mov    0x801170d4,%eax
801062a9:	85 c0                	test   %eax,%eax
801062ab:	74 3c                	je     801062e9 <printFreeList+0x4b>
        int size = 0;
801062ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        struct proc * current = ptable.pLists.free;
801062b4:	a1 d4 70 11 80       	mov    0x801170d4,%eax
801062b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while (current) {
801062bc:	eb 10                	jmp    801062ce <printFreeList+0x30>
            ++size; // cycle list and keep count
801062be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            current = current->next;
801062c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062c5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801062cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
void
printFreeList(void) {
    if (ptable.pLists.free) {
        int size = 0;
        struct proc * current = ptable.pLists.free;
        while (current) {
801062ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062d2:	75 ea                	jne    801062be <printFreeList+0x20>
        /*
        for (struct proc* current = ptable.pLists.free; current; current = current->next) {
            ++size;
        }
        */
        cprintf("\nFree List Size: %d processes\n", size);
801062d4:	83 ec 08             	sub    $0x8,%esp
801062d7:	ff 75 f4             	pushl  -0xc(%ebp)
801062da:	68 10 a9 10 80       	push   $0x8010a910
801062df:	e8 e2 a0 ff ff       	call   801003c6 <cprintf>
801062e4:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Free List.\n");
    }
}
801062e7:	eb 10                	jmp    801062f9 <printFreeList+0x5b>
        }
        */
        cprintf("\nFree List Size: %d processes\n", size);
    }
    else {
        cprintf("\nNo processes on Free List.\n");
801062e9:	83 ec 0c             	sub    $0xc,%esp
801062ec:	68 2f a9 10 80       	push   $0x8010a92f
801062f1:	e8 d0 a0 ff ff       	call   801003c6 <cprintf>
801062f6:	83 c4 10             	add    $0x10,%esp
    }
}
801062f9:	90                   	nop
801062fa:	c9                   	leave  
801062fb:	c3                   	ret    

801062fc <printSleepList>:

// print PIDs of all procs in Sleep list
void
printSleepList(void) {
801062fc:	55                   	push   %ebp
801062fd:	89 e5                	mov    %esp,%ebp
801062ff:	83 ec 18             	sub    $0x18,%esp
    //acquire(&ptable.lock);
    if (ptable.pLists.sleep) {
80106302:	a1 d8 70 11 80       	mov    0x801170d8,%eax
80106307:	85 c0                	test   %eax,%eax
80106309:	74 7b                	je     80106386 <printSleepList+0x8a>
        struct proc* current = ptable.pLists.sleep;
8010630b:	a1 d8 70 11 80       	mov    0x801170d8,%eax
80106310:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("\nSleep List Processes:\n");
80106313:	83 ec 0c             	sub    $0xc,%esp
80106316:	68 4c a9 10 80       	push   $0x8010a94c
8010631b:	e8 a6 a0 ff ff       	call   801003c6 <cprintf>
80106320:	83 c4 10             	add    $0x10,%esp
        while (current) {
80106323:	eb 49                	jmp    8010636e <printSleepList+0x72>
            if (current->next) {
80106325:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106328:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010632e:	85 c0                	test   %eax,%eax
80106330:	74 19                	je     8010634b <printSleepList+0x4f>
                cprintf("%d -> ", current->pid);
80106332:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106335:	8b 40 10             	mov    0x10(%eax),%eax
80106338:	83 ec 08             	sub    $0x8,%esp
8010633b:	50                   	push   %eax
8010633c:	68 64 a9 10 80       	push   $0x8010a964
80106341:	e8 80 a0 ff ff       	call   801003c6 <cprintf>
80106346:	83 c4 10             	add    $0x10,%esp
80106349:	eb 17                	jmp    80106362 <printSleepList+0x66>
            } else {
                cprintf("%d", current->pid);
8010634b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010634e:	8b 40 10             	mov    0x10(%eax),%eax
80106351:	83 ec 08             	sub    $0x8,%esp
80106354:	50                   	push   %eax
80106355:	68 6b a9 10 80       	push   $0x8010a96b
8010635a:	e8 67 a0 ff ff       	call   801003c6 <cprintf>
8010635f:	83 c4 10             	add    $0x10,%esp
            }
            current = current->next;
80106362:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106365:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010636b:	89 45 f4             	mov    %eax,-0xc(%ebp)
printSleepList(void) {
    //acquire(&ptable.lock);
    if (ptable.pLists.sleep) {
        struct proc* current = ptable.pLists.sleep;
        cprintf("\nSleep List Processes:\n");
        while (current) {
8010636e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106372:	75 b1                	jne    80106325 <printSleepList+0x29>
            } else {
                cprintf("%d", current->pid);
            }
            current = current->next;
        }
        cprintf("\n");
80106374:	83 ec 0c             	sub    $0xc,%esp
80106377:	68 51 a8 10 80       	push   $0x8010a851
8010637c:	e8 45 a0 ff ff       	call   801003c6 <cprintf>
80106381:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Sleep List.\n");
    }
    //release(&ptable.lock);
}
80106384:	eb 10                	jmp    80106396 <printSleepList+0x9a>
            current = current->next;
        }
        cprintf("\n");
    }
    else {
        cprintf("\nNo processes on Sleep List.\n");
80106386:	83 ec 0c             	sub    $0xc,%esp
80106389:	68 6e a9 10 80       	push   $0x8010a96e
8010638e:	e8 33 a0 ff ff       	call   801003c6 <cprintf>
80106393:	83 c4 10             	add    $0x10,%esp
    }
    //release(&ptable.lock);
}
80106396:	90                   	nop
80106397:	c9                   	leave  
80106398:	c3                   	ret    

80106399 <printZombieList>:

// print PIDs & PPIDs of all procs in Zombie list
void
printZombieList(void) {
80106399:	55                   	push   %ebp
8010639a:	89 e5                	mov    %esp,%ebp
8010639c:	83 ec 18             	sub    $0x18,%esp
    if (ptable.pLists.zombie) {
8010639f:	a1 dc 70 11 80       	mov    0x801170dc,%eax
801063a4:	85 c0                	test   %eax,%eax
801063a6:	0f 84 8f 00 00 00    	je     8010643b <printZombieList+0xa2>
        struct proc* current = ptable.pLists.zombie;
801063ac:	a1 dc 70 11 80       	mov    0x801170dc,%eax
801063b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("\nZombie List Processes:\n");
801063b4:	83 ec 0c             	sub    $0xc,%esp
801063b7:	68 8c a9 10 80       	push   $0x8010a98c
801063bc:	e8 05 a0 ff ff       	call   801003c6 <cprintf>
801063c1:	83 c4 10             	add    $0x10,%esp
        while (current) {
801063c4:	eb 5d                	jmp    80106423 <printZombieList+0x8a>
            if (current->next) {
801063c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801063cf:	85 c0                	test   %eax,%eax
801063d1:	74 23                	je     801063f6 <printZombieList+0x5d>
                cprintf("(%d, %d) -> ", current->pid, current->parent->pid);
801063d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d6:	8b 40 14             	mov    0x14(%eax),%eax
801063d9:	8b 50 10             	mov    0x10(%eax),%edx
801063dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063df:	8b 40 10             	mov    0x10(%eax),%eax
801063e2:	83 ec 04             	sub    $0x4,%esp
801063e5:	52                   	push   %edx
801063e6:	50                   	push   %eax
801063e7:	68 a5 a9 10 80       	push   $0x8010a9a5
801063ec:	e8 d5 9f ff ff       	call   801003c6 <cprintf>
801063f1:	83 c4 10             	add    $0x10,%esp
801063f4:	eb 21                	jmp    80106417 <printZombieList+0x7e>
            } else {
                cprintf("(%d, %d)", current->pid, current->parent->pid);
801063f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f9:	8b 40 14             	mov    0x14(%eax),%eax
801063fc:	8b 50 10             	mov    0x10(%eax),%edx
801063ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106402:	8b 40 10             	mov    0x10(%eax),%eax
80106405:	83 ec 04             	sub    $0x4,%esp
80106408:	52                   	push   %edx
80106409:	50                   	push   %eax
8010640a:	68 f9 a8 10 80       	push   $0x8010a8f9
8010640f:	e8 b2 9f ff ff       	call   801003c6 <cprintf>
80106414:	83 c4 10             	add    $0x10,%esp
            }
            current = current->next;
80106417:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010641a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106420:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
printZombieList(void) {
    if (ptable.pLists.zombie) {
        struct proc* current = ptable.pLists.zombie;
        cprintf("\nZombie List Processes:\n");
        while (current) {
80106423:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106427:	75 9d                	jne    801063c6 <printZombieList+0x2d>
            } else {
                cprintf("(%d, %d)", current->pid, current->parent->pid);
            }
            current = current->next;
        }
        cprintf("\n");
80106429:	83 ec 0c             	sub    $0xc,%esp
8010642c:	68 51 a8 10 80       	push   $0x8010a851
80106431:	e8 90 9f ff ff       	call   801003c6 <cprintf>
80106436:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Zombie List.\n");
    }
}
80106439:	eb 10                	jmp    8010644b <printZombieList+0xb2>
            current = current->next;
        }
        cprintf("\n");
    }
    else {
        cprintf("\nNo processes on Zombie List.\n");
8010643b:	83 ec 0c             	sub    $0xc,%esp
8010643e:	68 b4 a9 10 80       	push   $0x8010a9b4
80106443:	e8 7e 9f ff ff       	call   801003c6 <cprintf>
80106448:	83 c4 10             	add    $0x10,%esp
    }
}
8010644b:	90                   	nop
8010644c:	c9                   	leave  
8010644d:	c3                   	ret    

8010644e <promoteAll>:
// upwards to lowest priority queue

// Promote all ACTIVE(RUNNING, RUNNABLE, SLEEPING) processes one priority level
// this is only called in scheduler(), which holds &ptable.lock
static void
promoteAll(void) {
8010644e:	55                   	push   %ebp
8010644f:	89 e5                	mov    %esp,%ebp
80106451:	83 ec 18             	sub    $0x18,%esp
    struct proc* p; // main ptr
    struct proc* current; // 2nd ptr needed for traversal + list management
    for (int i = 1; i <= MAX; ++i) {
80106454:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
8010645b:	e9 ff 00 00 00       	jmp    8010655f <promoteAll+0x111>
        // traverse ready list array
        if (ptable.pLists.ready[i]) {
80106460:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106463:	05 cc 09 00 00       	add    $0x9cc,%eax
80106468:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
8010646f:	85 c0                	test   %eax,%eax
80106471:	0f 84 e4 00 00 00    	je     8010655b <promoteAll+0x10d>
            current = ptable.pLists.ready[i]; // initialize
80106477:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010647a:	05 cc 09 00 00       	add    $0x9cc,%eax
8010647f:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80106486:	89 45 f0             	mov    %eax,-0x10(%ebp)
            p = 0;
80106489:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            while (current) {
80106490:	e9 bc 00 00 00       	jmp    80106551 <promoteAll+0x103>
                p = current; // p is the current process to adjust
80106495:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106498:	89 45 f4             	mov    %eax,-0xc(%ebp)
                current = current->next; // current traverses one ahead
8010649b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010649e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801064a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
                assertState(p, RUNNABLE); // assert state, we need to swap ready lists
801064a7:	83 ec 08             	sub    $0x8,%esp
801064aa:	6a 03                	push   $0x3
801064ac:	ff 75 f4             	pushl  -0xc(%ebp)
801064af:	e8 96 fa ff ff       	call   80105f4a <assertState>
801064b4:	83 c4 10             	add    $0x10,%esp
                if (removeFromStateList(&ptable.pLists.ready[p->priority], p) < 0) {
801064b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064ba:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801064c0:	05 cc 09 00 00       	add    $0x9cc,%eax
801064c5:	c1 e0 02             	shl    $0x2,%eax
801064c8:	05 80 49 11 80       	add    $0x80114980,%eax
801064cd:	83 c0 04             	add    $0x4,%eax
801064d0:	83 ec 08             	sub    $0x8,%esp
801064d3:	ff 75 f4             	pushl  -0xc(%ebp)
801064d6:	50                   	push   %eax
801064d7:	e8 8f fb ff ff       	call   8010606b <removeFromStateList>
801064dc:	83 c4 10             	add    $0x10,%esp
801064df:	85 c0                	test   %eax,%eax
801064e1:	79 10                	jns    801064f3 <promoteAll+0xa5>
                    cprintf("promoteAll: Could not remove from ready list.\n");
801064e3:	83 ec 0c             	sub    $0xc,%esp
801064e6:	68 d4 a9 10 80       	push   $0x8010a9d4
801064eb:	e8 d6 9e ff ff       	call   801003c6 <cprintf>
801064f0:	83 c4 10             	add    $0x10,%esp
                } // take off lower priority (whatever one it is)
                if (p->priority > 0) {
801064f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064f6:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801064fc:	85 c0                	test   %eax,%eax
801064fe:	74 15                	je     80106515 <promoteAll+0xc7>
                    --(p->priority); // adjust upward (toward zero)
80106500:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106503:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106509:	8d 50 ff             	lea    -0x1(%eax),%edx
8010650c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010650f:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
                } // add to higher priority list
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
80106515:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106518:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010651e:	05 cc 09 00 00       	add    $0x9cc,%eax
80106523:	c1 e0 02             	shl    $0x2,%eax
80106526:	05 80 49 11 80       	add    $0x80114980,%eax
8010652b:	83 c0 04             	add    $0x4,%eax
8010652e:	83 ec 08             	sub    $0x8,%esp
80106531:	ff 75 f4             	pushl  -0xc(%ebp)
80106534:	50                   	push   %eax
80106535:	e8 b0 fa ff ff       	call   80105fea <addToStateListEnd>
8010653a:	83 c4 10             	add    $0x10,%esp
8010653d:	85 c0                	test   %eax,%eax
8010653f:	79 10                	jns    80106551 <promoteAll+0x103>
                    cprintf("promoteAll: Could not add to ready list.\n");
80106541:	83 ec 0c             	sub    $0xc,%esp
80106544:	68 04 aa 10 80       	push   $0x8010aa04
80106549:	e8 78 9e ff ff       	call   801003c6 <cprintf>
8010654e:	83 c4 10             	add    $0x10,%esp
    for (int i = 1; i <= MAX; ++i) {
        // traverse ready list array
        if (ptable.pLists.ready[i]) {
            current = ptable.pLists.ready[i]; // initialize
            p = 0;
            while (current) {
80106551:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106555:	0f 85 3a ff ff ff    	jne    80106495 <promoteAll+0x47>
// this is only called in scheduler(), which holds &ptable.lock
static void
promoteAll(void) {
    struct proc* p; // main ptr
    struct proc* current; // 2nd ptr needed for traversal + list management
    for (int i = 1; i <= MAX; ++i) {
8010655b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010655f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
80106563:	0f 8e f7 fe ff ff    	jle    80106460 <promoteAll+0x12>
                }
            }
        }
    }
    // promote all SLEEPING processes
    if (ptable.pLists.sleep) {
80106569:	a1 d8 70 11 80       	mov    0x801170d8,%eax
8010656e:	85 c0                	test   %eax,%eax
80106570:	74 3e                	je     801065b0 <promoteAll+0x162>
        p = ptable.pLists.sleep;
80106572:	a1 d8 70 11 80       	mov    0x801170d8,%eax
80106577:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
8010657a:	eb 2e                	jmp    801065aa <promoteAll+0x15c>
            if (p->priority > 0) {
8010657c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010657f:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106585:	85 c0                	test   %eax,%eax
80106587:	74 15                	je     8010659e <promoteAll+0x150>
                --(p->priority); // promote process
80106589:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010658c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106592:	8d 50 ff             	lea    -0x1(%eax),%edx
80106595:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106598:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            }
            p = p->next;
8010659e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801065a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
    }
    // promote all SLEEPING processes
    if (ptable.pLists.sleep) {
        p = ptable.pLists.sleep;
        while (p) {
801065aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065ae:	75 cc                	jne    8010657c <promoteAll+0x12e>
            }
            p = p->next;
        }
    }
    // promote all RUNNING processes
    if (ptable.pLists.running) {
801065b0:	a1 e0 70 11 80       	mov    0x801170e0,%eax
801065b5:	85 c0                	test   %eax,%eax
801065b7:	74 3e                	je     801065f7 <promoteAll+0x1a9>
        p = ptable.pLists.running;
801065b9:	a1 e0 70 11 80       	mov    0x801170e0,%eax
801065be:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
801065c1:	eb 2e                	jmp    801065f1 <promoteAll+0x1a3>
            if (p->priority > 0) {
801065c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c6:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801065cc:	85 c0                	test   %eax,%eax
801065ce:	74 15                	je     801065e5 <promoteAll+0x197>
                --(p->priority); // promote process
801065d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d3:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801065d9:	8d 50 ff             	lea    -0x1(%eax),%edx
801065dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065df:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            }
            p = p->next;
801065e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e8:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801065ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
    }
    // promote all RUNNING processes
    if (ptable.pLists.running) {
        p = ptable.pLists.running;
        while (p) {
801065f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065f5:	75 cc                	jne    801065c3 <promoteAll+0x175>
            }
            p = p->next;
        }
    }
    // nothing to return, just promote anything if they are there
}
801065f7:	90                   	nop
801065f8:	c9                   	leave  
801065f9:	c3                   	ret    

801065fa <setpriority>:
// set priority system call
// bounds enforced in sysproc.c (kernel-side)
// active processes: RUNNABLE, RUNNING, SLEEPING
int
setpriority(int pid, int priority) {
801065fa:	55                   	push   %ebp
801065fb:	89 e5                	mov    %esp,%ebp
801065fd:	83 ec 18             	sub    $0x18,%esp
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
80106600:	83 ec 0c             	sub    $0xc,%esp
80106603:	68 80 49 11 80       	push   $0x80114980
80106608:	e8 40 02 00 00       	call   8010684d <acquire>
8010660d:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i <= MAX; ++i) {
80106610:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80106617:	e9 01 01 00 00       	jmp    8010671d <setpriority+0x123>
        p = ptable.pLists.ready[i]; // traverse ready list array
8010661c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010661f:	05 cc 09 00 00       	add    $0x9cc,%eax
80106624:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
8010662b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
8010662e:	e9 dc 00 00 00       	jmp    8010670f <setpriority+0x115>
            // match PIDs and only if the new priority value changes anything
            if (p->pid == pid) {
80106633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106636:	8b 50 10             	mov    0x10(%eax),%edx
80106639:	8b 45 08             	mov    0x8(%ebp),%eax
8010663c:	39 c2                	cmp    %eax,%edx
8010663e:	0f 85 bf 00 00 00    	jne    80106703 <setpriority+0x109>
                if (removeFromStateList(&ptable.pLists.ready[p->priority], p) < 0) {
80106644:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106647:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010664d:	05 cc 09 00 00       	add    $0x9cc,%eax
80106652:	c1 e0 02             	shl    $0x2,%eax
80106655:	05 80 49 11 80       	add    $0x80114980,%eax
8010665a:	83 c0 04             	add    $0x4,%eax
8010665d:	83 ec 08             	sub    $0x8,%esp
80106660:	ff 75 f4             	pushl  -0xc(%ebp)
80106663:	50                   	push   %eax
80106664:	e8 02 fa ff ff       	call   8010606b <removeFromStateList>
80106669:	83 c4 10             	add    $0x10,%esp
8010666c:	85 c0                	test   %eax,%eax
8010666e:	79 1a                	jns    8010668a <setpriority+0x90>
                    cprintf("setpriority: remove from ready list[%d] failed.\n", p->priority);
80106670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106673:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106679:	83 ec 08             	sub    $0x8,%esp
8010667c:	50                   	push   %eax
8010667d:	68 30 aa 10 80       	push   $0x8010aa30
80106682:	e8 3f 9d ff ff       	call   801003c6 <cprintf>
80106687:	83 c4 10             	add    $0x10,%esp
                }// remove from old ready list
                p->priority = priority; // set priority
8010668a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010668d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106690:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
80106696:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106699:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010669f:	05 cc 09 00 00       	add    $0x9cc,%eax
801066a4:	c1 e0 02             	shl    $0x2,%eax
801066a7:	05 80 49 11 80       	add    $0x80114980,%eax
801066ac:	83 c0 04             	add    $0x4,%eax
801066af:	83 ec 08             	sub    $0x8,%esp
801066b2:	ff 75 f4             	pushl  -0xc(%ebp)
801066b5:	50                   	push   %eax
801066b6:	e8 2f f9 ff ff       	call   80105fea <addToStateListEnd>
801066bb:	83 c4 10             	add    $0x10,%esp
801066be:	85 c0                	test   %eax,%eax
801066c0:	79 1a                	jns    801066dc <setpriority+0xe2>
                    cprintf("setpriority: add to ready list[%d] failed.\n", p->priority);
801066c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c5:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801066cb:	83 ec 08             	sub    $0x8,%esp
801066ce:	50                   	push   %eax
801066cf:	68 64 aa 10 80       	push   $0x8010aa64
801066d4:	e8 ed 9c ff ff       	call   801003c6 <cprintf>
801066d9:	83 c4 10             	add    $0x10,%esp
                } //  add to new ready list
                p->budget = BUDGET; // reset budget
801066dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066df:	c7 80 98 00 00 00 a0 	movl   $0x186a0,0x98(%eax)
801066e6:	86 01 00 
                //cprintf("setPriority: ready list priority set.\n");
                release(&ptable.lock); // release lock
801066e9:	83 ec 0c             	sub    $0xc,%esp
801066ec:	68 80 49 11 80       	push   $0x80114980
801066f1:	e8 be 01 00 00       	call   801068b4 <release>
801066f6:	83 c4 10             	add    $0x10,%esp
                return 0; // return success
801066f9:	b8 00 00 00 00       	mov    $0x0,%eax
801066fe:	e9 ee 00 00 00       	jmp    801067f1 <setpriority+0x1f7>
            }
            p = p->next;
80106703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106706:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010670c:	89 45 f4             	mov    %eax,-0xc(%ebp)
setpriority(int pid, int priority) {
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i]; // traverse ready list array
        while (p) {
8010670f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106713:	0f 85 1a ff ff ff    	jne    80106633 <setpriority+0x39>
// active processes: RUNNABLE, RUNNING, SLEEPING
int
setpriority(int pid, int priority) {
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
    for (int i = 0; i <= MAX; ++i) {
80106719:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010671d:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
80106721:	0f 8e f5 fe ff ff    	jle    8010661c <setpriority+0x22>
                return 0; // return success
            }
            p = p->next;
        }
    }
    p = ptable.pLists.running; // repeat process if PID not found in ready lists
80106727:	a1 e0 70 11 80       	mov    0x801170e0,%eax
8010672c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
8010672f:	eb 4c                	jmp    8010677d <setpriority+0x183>
        if (p->pid == pid) {
80106731:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106734:	8b 50 10             	mov    0x10(%eax),%edx
80106737:	8b 45 08             	mov    0x8(%ebp),%eax
8010673a:	39 c2                	cmp    %eax,%edx
8010673c:	75 33                	jne    80106771 <setpriority+0x177>
            p->priority = priority;
8010673e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106744:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            p->budget = BUDGET;
8010674a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010674d:	c7 80 98 00 00 00 a0 	movl   $0x186a0,0x98(%eax)
80106754:	86 01 00 
            //cprintf("setPriority: running list priority set.\n");
            release(&ptable.lock);
80106757:	83 ec 0c             	sub    $0xc,%esp
8010675a:	68 80 49 11 80       	push   $0x80114980
8010675f:	e8 50 01 00 00       	call   801068b4 <release>
80106764:	83 c4 10             	add    $0x10,%esp
            return 0; // return success
80106767:	b8 00 00 00 00       	mov    $0x0,%eax
8010676c:	e9 80 00 00 00       	jmp    801067f1 <setpriority+0x1f7>
        }
        p = p->next;
80106771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106774:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010677a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
    }
    p = ptable.pLists.running; // repeat process if PID not found in ready lists
    while (p) {
8010677d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106781:	75 ae                	jne    80106731 <setpriority+0x137>
            release(&ptable.lock);
            return 0; // return success
        }
        p = p->next;
    }
    p = ptable.pLists.sleep; // continue search in sleep list
80106783:	a1 d8 70 11 80       	mov    0x801170d8,%eax
80106788:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
8010678b:	eb 49                	jmp    801067d6 <setpriority+0x1dc>
        if (p->pid == pid) {
8010678d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106790:	8b 50 10             	mov    0x10(%eax),%edx
80106793:	8b 45 08             	mov    0x8(%ebp),%eax
80106796:	39 c2                	cmp    %eax,%edx
80106798:	75 30                	jne    801067ca <setpriority+0x1d0>
            p->priority = priority;
8010679a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010679d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a0:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            p->budget = BUDGET;
801067a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a9:	c7 80 98 00 00 00 a0 	movl   $0x186a0,0x98(%eax)
801067b0:	86 01 00 
            //cprintf("setPriority: sleep list priority set.\n");
            release(&ptable.lock);
801067b3:	83 ec 0c             	sub    $0xc,%esp
801067b6:	68 80 49 11 80       	push   $0x80114980
801067bb:	e8 f4 00 00 00       	call   801068b4 <release>
801067c0:	83 c4 10             	add    $0x10,%esp
            return 0; //  return success
801067c3:	b8 00 00 00 00       	mov    $0x0,%eax
801067c8:	eb 27                	jmp    801067f1 <setpriority+0x1f7>
        }
        p = p->next;
801067ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067cd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801067d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
            return 0; // return success
        }
        p = p->next;
    }
    p = ptable.pLists.sleep; // continue search in sleep list
    while (p) {
801067d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067da:	75 b1                	jne    8010678d <setpriority+0x193>
            return 0; //  return success
        }
        p = p->next;
    }
    //cprintf("setPriority: No priority set.\n");
    release(&ptable.lock);
801067dc:	83 ec 0c             	sub    $0xc,%esp
801067df:	68 80 49 11 80       	push   $0x80114980
801067e4:	e8 cb 00 00 00       	call   801068b4 <release>
801067e9:	83 c4 10             	add    $0x10,%esp
    return -1; // return error if no PID match is found
801067ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067f1:	c9                   	leave  
801067f2:	c3                   	ret    

801067f3 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801067f3:	55                   	push   %ebp
801067f4:	89 e5                	mov    %esp,%ebp
801067f6:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801067f9:	9c                   	pushf  
801067fa:	58                   	pop    %eax
801067fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801067fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106801:	c9                   	leave  
80106802:	c3                   	ret    

80106803 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80106803:	55                   	push   %ebp
80106804:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80106806:	fa                   	cli    
}
80106807:	90                   	nop
80106808:	5d                   	pop    %ebp
80106809:	c3                   	ret    

8010680a <sti>:

static inline void
sti(void)
{
8010680a:	55                   	push   %ebp
8010680b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010680d:	fb                   	sti    
}
8010680e:	90                   	nop
8010680f:	5d                   	pop    %ebp
80106810:	c3                   	ret    

80106811 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80106811:	55                   	push   %ebp
80106812:	89 e5                	mov    %esp,%ebp
80106814:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80106817:	8b 55 08             	mov    0x8(%ebp),%edx
8010681a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010681d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106820:	f0 87 02             	lock xchg %eax,(%edx)
80106823:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80106826:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106829:	c9                   	leave  
8010682a:	c3                   	ret    

8010682b <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010682b:	55                   	push   %ebp
8010682c:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010682e:	8b 45 08             	mov    0x8(%ebp),%eax
80106831:	8b 55 0c             	mov    0xc(%ebp),%edx
80106834:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80106837:	8b 45 08             	mov    0x8(%ebp),%eax
8010683a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80106840:	8b 45 08             	mov    0x8(%ebp),%eax
80106843:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010684a:	90                   	nop
8010684b:	5d                   	pop    %ebp
8010684c:	c3                   	ret    

8010684d <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010684d:	55                   	push   %ebp
8010684e:	89 e5                	mov    %esp,%ebp
80106850:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106853:	e8 52 01 00 00       	call   801069aa <pushcli>
  if(holding(lk))
80106858:	8b 45 08             	mov    0x8(%ebp),%eax
8010685b:	83 ec 0c             	sub    $0xc,%esp
8010685e:	50                   	push   %eax
8010685f:	e8 1c 01 00 00       	call   80106980 <holding>
80106864:	83 c4 10             	add    $0x10,%esp
80106867:	85 c0                	test   %eax,%eax
80106869:	74 0d                	je     80106878 <acquire+0x2b>
    panic("acquire");
8010686b:	83 ec 0c             	sub    $0xc,%esp
8010686e:	68 90 aa 10 80       	push   $0x8010aa90
80106873:	e8 ee 9c ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80106878:	90                   	nop
80106879:	8b 45 08             	mov    0x8(%ebp),%eax
8010687c:	83 ec 08             	sub    $0x8,%esp
8010687f:	6a 01                	push   $0x1
80106881:	50                   	push   %eax
80106882:	e8 8a ff ff ff       	call   80106811 <xchg>
80106887:	83 c4 10             	add    $0x10,%esp
8010688a:	85 c0                	test   %eax,%eax
8010688c:	75 eb                	jne    80106879 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010688e:	8b 45 08             	mov    0x8(%ebp),%eax
80106891:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106898:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010689b:	8b 45 08             	mov    0x8(%ebp),%eax
8010689e:	83 c0 0c             	add    $0xc,%eax
801068a1:	83 ec 08             	sub    $0x8,%esp
801068a4:	50                   	push   %eax
801068a5:	8d 45 08             	lea    0x8(%ebp),%eax
801068a8:	50                   	push   %eax
801068a9:	e8 58 00 00 00       	call   80106906 <getcallerpcs>
801068ae:	83 c4 10             	add    $0x10,%esp
}
801068b1:	90                   	nop
801068b2:	c9                   	leave  
801068b3:	c3                   	ret    

801068b4 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801068b4:	55                   	push   %ebp
801068b5:	89 e5                	mov    %esp,%ebp
801068b7:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801068ba:	83 ec 0c             	sub    $0xc,%esp
801068bd:	ff 75 08             	pushl  0x8(%ebp)
801068c0:	e8 bb 00 00 00       	call   80106980 <holding>
801068c5:	83 c4 10             	add    $0x10,%esp
801068c8:	85 c0                	test   %eax,%eax
801068ca:	75 0d                	jne    801068d9 <release+0x25>
    panic("release");
801068cc:	83 ec 0c             	sub    $0xc,%esp
801068cf:	68 98 aa 10 80       	push   $0x8010aa98
801068d4:	e8 8d 9c ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801068d9:	8b 45 08             	mov    0x8(%ebp),%eax
801068dc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801068e3:	8b 45 08             	mov    0x8(%ebp),%eax
801068e6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801068ed:	8b 45 08             	mov    0x8(%ebp),%eax
801068f0:	83 ec 08             	sub    $0x8,%esp
801068f3:	6a 00                	push   $0x0
801068f5:	50                   	push   %eax
801068f6:	e8 16 ff ff ff       	call   80106811 <xchg>
801068fb:	83 c4 10             	add    $0x10,%esp

  popcli();
801068fe:	e8 ec 00 00 00       	call   801069ef <popcli>
}
80106903:	90                   	nop
80106904:	c9                   	leave  
80106905:	c3                   	ret    

80106906 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106906:	55                   	push   %ebp
80106907:	89 e5                	mov    %esp,%ebp
80106909:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010690c:	8b 45 08             	mov    0x8(%ebp),%eax
8010690f:	83 e8 08             	sub    $0x8,%eax
80106912:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80106915:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010691c:	eb 38                	jmp    80106956 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010691e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106922:	74 53                	je     80106977 <getcallerpcs+0x71>
80106924:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010692b:	76 4a                	jbe    80106977 <getcallerpcs+0x71>
8010692d:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80106931:	74 44                	je     80106977 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80106933:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106936:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010693d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106940:	01 c2                	add    %eax,%edx
80106942:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106945:	8b 40 04             	mov    0x4(%eax),%eax
80106948:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010694a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010694d:	8b 00                	mov    (%eax),%eax
8010694f:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106952:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106956:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010695a:	7e c2                	jle    8010691e <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010695c:	eb 19                	jmp    80106977 <getcallerpcs+0x71>
    pcs[i] = 0;
8010695e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106961:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106968:	8b 45 0c             	mov    0xc(%ebp),%eax
8010696b:	01 d0                	add    %edx,%eax
8010696d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106973:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106977:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010697b:	7e e1                	jle    8010695e <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010697d:	90                   	nop
8010697e:	c9                   	leave  
8010697f:	c3                   	ret    

80106980 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106983:	8b 45 08             	mov    0x8(%ebp),%eax
80106986:	8b 00                	mov    (%eax),%eax
80106988:	85 c0                	test   %eax,%eax
8010698a:	74 17                	je     801069a3 <holding+0x23>
8010698c:	8b 45 08             	mov    0x8(%ebp),%eax
8010698f:	8b 50 08             	mov    0x8(%eax),%edx
80106992:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106998:	39 c2                	cmp    %eax,%edx
8010699a:	75 07                	jne    801069a3 <holding+0x23>
8010699c:	b8 01 00 00 00       	mov    $0x1,%eax
801069a1:	eb 05                	jmp    801069a8 <holding+0x28>
801069a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069a8:	5d                   	pop    %ebp
801069a9:	c3                   	ret    

801069aa <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801069aa:	55                   	push   %ebp
801069ab:	89 e5                	mov    %esp,%ebp
801069ad:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801069b0:	e8 3e fe ff ff       	call   801067f3 <readeflags>
801069b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801069b8:	e8 46 fe ff ff       	call   80106803 <cli>
  if(cpu->ncli++ == 0)
801069bd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801069c4:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801069ca:	8d 48 01             	lea    0x1(%eax),%ecx
801069cd:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801069d3:	85 c0                	test   %eax,%eax
801069d5:	75 15                	jne    801069ec <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801069d7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069e0:	81 e2 00 02 00 00    	and    $0x200,%edx
801069e6:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801069ec:	90                   	nop
801069ed:	c9                   	leave  
801069ee:	c3                   	ret    

801069ef <popcli>:

void
popcli(void)
{
801069ef:	55                   	push   %ebp
801069f0:	89 e5                	mov    %esp,%ebp
801069f2:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801069f5:	e8 f9 fd ff ff       	call   801067f3 <readeflags>
801069fa:	25 00 02 00 00       	and    $0x200,%eax
801069ff:	85 c0                	test   %eax,%eax
80106a01:	74 0d                	je     80106a10 <popcli+0x21>
    panic("popcli - interruptible");
80106a03:	83 ec 0c             	sub    $0xc,%esp
80106a06:	68 a0 aa 10 80       	push   $0x8010aaa0
80106a0b:	e8 56 9b ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106a10:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a16:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106a1c:	83 ea 01             	sub    $0x1,%edx
80106a1f:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106a25:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106a2b:	85 c0                	test   %eax,%eax
80106a2d:	79 0d                	jns    80106a3c <popcli+0x4d>
    panic("popcli");
80106a2f:	83 ec 0c             	sub    $0xc,%esp
80106a32:	68 b7 aa 10 80       	push   $0x8010aab7
80106a37:	e8 2a 9b ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106a3c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a42:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106a48:	85 c0                	test   %eax,%eax
80106a4a:	75 15                	jne    80106a61 <popcli+0x72>
80106a4c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a52:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106a58:	85 c0                	test   %eax,%eax
80106a5a:	74 05                	je     80106a61 <popcli+0x72>
    sti();
80106a5c:	e8 a9 fd ff ff       	call   8010680a <sti>
}
80106a61:	90                   	nop
80106a62:	c9                   	leave  
80106a63:	c3                   	ret    

80106a64 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106a64:	55                   	push   %ebp
80106a65:	89 e5                	mov    %esp,%ebp
80106a67:	57                   	push   %edi
80106a68:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106a69:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106a6c:	8b 55 10             	mov    0x10(%ebp),%edx
80106a6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a72:	89 cb                	mov    %ecx,%ebx
80106a74:	89 df                	mov    %ebx,%edi
80106a76:	89 d1                	mov    %edx,%ecx
80106a78:	fc                   	cld    
80106a79:	f3 aa                	rep stos %al,%es:(%edi)
80106a7b:	89 ca                	mov    %ecx,%edx
80106a7d:	89 fb                	mov    %edi,%ebx
80106a7f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106a82:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106a85:	90                   	nop
80106a86:	5b                   	pop    %ebx
80106a87:	5f                   	pop    %edi
80106a88:	5d                   	pop    %ebp
80106a89:	c3                   	ret    

80106a8a <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106a8a:	55                   	push   %ebp
80106a8b:	89 e5                	mov    %esp,%ebp
80106a8d:	57                   	push   %edi
80106a8e:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106a8f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106a92:	8b 55 10             	mov    0x10(%ebp),%edx
80106a95:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a98:	89 cb                	mov    %ecx,%ebx
80106a9a:	89 df                	mov    %ebx,%edi
80106a9c:	89 d1                	mov    %edx,%ecx
80106a9e:	fc                   	cld    
80106a9f:	f3 ab                	rep stos %eax,%es:(%edi)
80106aa1:	89 ca                	mov    %ecx,%edx
80106aa3:	89 fb                	mov    %edi,%ebx
80106aa5:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106aa8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106aab:	90                   	nop
80106aac:	5b                   	pop    %ebx
80106aad:	5f                   	pop    %edi
80106aae:	5d                   	pop    %ebp
80106aaf:	c3                   	ret    

80106ab0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106ab3:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab6:	83 e0 03             	and    $0x3,%eax
80106ab9:	85 c0                	test   %eax,%eax
80106abb:	75 43                	jne    80106b00 <memset+0x50>
80106abd:	8b 45 10             	mov    0x10(%ebp),%eax
80106ac0:	83 e0 03             	and    $0x3,%eax
80106ac3:	85 c0                	test   %eax,%eax
80106ac5:	75 39                	jne    80106b00 <memset+0x50>
    c &= 0xFF;
80106ac7:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106ace:	8b 45 10             	mov    0x10(%ebp),%eax
80106ad1:	c1 e8 02             	shr    $0x2,%eax
80106ad4:	89 c1                	mov    %eax,%ecx
80106ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ad9:	c1 e0 18             	shl    $0x18,%eax
80106adc:	89 c2                	mov    %eax,%edx
80106ade:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ae1:	c1 e0 10             	shl    $0x10,%eax
80106ae4:	09 c2                	or     %eax,%edx
80106ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ae9:	c1 e0 08             	shl    $0x8,%eax
80106aec:	09 d0                	or     %edx,%eax
80106aee:	0b 45 0c             	or     0xc(%ebp),%eax
80106af1:	51                   	push   %ecx
80106af2:	50                   	push   %eax
80106af3:	ff 75 08             	pushl  0x8(%ebp)
80106af6:	e8 8f ff ff ff       	call   80106a8a <stosl>
80106afb:	83 c4 0c             	add    $0xc,%esp
80106afe:	eb 12                	jmp    80106b12 <memset+0x62>
  } else
    stosb(dst, c, n);
80106b00:	8b 45 10             	mov    0x10(%ebp),%eax
80106b03:	50                   	push   %eax
80106b04:	ff 75 0c             	pushl  0xc(%ebp)
80106b07:	ff 75 08             	pushl  0x8(%ebp)
80106b0a:	e8 55 ff ff ff       	call   80106a64 <stosb>
80106b0f:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106b12:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106b15:	c9                   	leave  
80106b16:	c3                   	ret    

80106b17 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106b17:	55                   	push   %ebp
80106b18:	89 e5                	mov    %esp,%ebp
80106b1a:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106b1d:	8b 45 08             	mov    0x8(%ebp),%eax
80106b20:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106b23:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b26:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106b29:	eb 30                	jmp    80106b5b <memcmp+0x44>
    if(*s1 != *s2)
80106b2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b2e:	0f b6 10             	movzbl (%eax),%edx
80106b31:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106b34:	0f b6 00             	movzbl (%eax),%eax
80106b37:	38 c2                	cmp    %al,%dl
80106b39:	74 18                	je     80106b53 <memcmp+0x3c>
      return *s1 - *s2;
80106b3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b3e:	0f b6 00             	movzbl (%eax),%eax
80106b41:	0f b6 d0             	movzbl %al,%edx
80106b44:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106b47:	0f b6 00             	movzbl (%eax),%eax
80106b4a:	0f b6 c0             	movzbl %al,%eax
80106b4d:	29 c2                	sub    %eax,%edx
80106b4f:	89 d0                	mov    %edx,%eax
80106b51:	eb 1a                	jmp    80106b6d <memcmp+0x56>
    s1++, s2++;
80106b53:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106b57:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106b5b:	8b 45 10             	mov    0x10(%ebp),%eax
80106b5e:	8d 50 ff             	lea    -0x1(%eax),%edx
80106b61:	89 55 10             	mov    %edx,0x10(%ebp)
80106b64:	85 c0                	test   %eax,%eax
80106b66:	75 c3                	jne    80106b2b <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106b68:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b6d:	c9                   	leave  
80106b6e:	c3                   	ret    

80106b6f <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106b6f:	55                   	push   %ebp
80106b70:	89 e5                	mov    %esp,%ebp
80106b72:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106b75:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b78:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106b7b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b7e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106b81:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b84:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106b87:	73 54                	jae    80106bdd <memmove+0x6e>
80106b89:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106b8c:	8b 45 10             	mov    0x10(%ebp),%eax
80106b8f:	01 d0                	add    %edx,%eax
80106b91:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106b94:	76 47                	jbe    80106bdd <memmove+0x6e>
    s += n;
80106b96:	8b 45 10             	mov    0x10(%ebp),%eax
80106b99:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106b9c:	8b 45 10             	mov    0x10(%ebp),%eax
80106b9f:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106ba2:	eb 13                	jmp    80106bb7 <memmove+0x48>
      *--d = *--s;
80106ba4:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106ba8:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106bac:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106baf:	0f b6 10             	movzbl (%eax),%edx
80106bb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bb5:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106bb7:	8b 45 10             	mov    0x10(%ebp),%eax
80106bba:	8d 50 ff             	lea    -0x1(%eax),%edx
80106bbd:	89 55 10             	mov    %edx,0x10(%ebp)
80106bc0:	85 c0                	test   %eax,%eax
80106bc2:	75 e0                	jne    80106ba4 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106bc4:	eb 24                	jmp    80106bea <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106bc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bc9:	8d 50 01             	lea    0x1(%eax),%edx
80106bcc:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106bcf:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106bd2:	8d 4a 01             	lea    0x1(%edx),%ecx
80106bd5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80106bd8:	0f b6 12             	movzbl (%edx),%edx
80106bdb:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106bdd:	8b 45 10             	mov    0x10(%ebp),%eax
80106be0:	8d 50 ff             	lea    -0x1(%eax),%edx
80106be3:	89 55 10             	mov    %edx,0x10(%ebp)
80106be6:	85 c0                	test   %eax,%eax
80106be8:	75 dc                	jne    80106bc6 <memmove+0x57>
      *d++ = *s++;

  return dst;
80106bea:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106bed:	c9                   	leave  
80106bee:	c3                   	ret    

80106bef <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106bef:	55                   	push   %ebp
80106bf0:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106bf2:	ff 75 10             	pushl  0x10(%ebp)
80106bf5:	ff 75 0c             	pushl  0xc(%ebp)
80106bf8:	ff 75 08             	pushl  0x8(%ebp)
80106bfb:	e8 6f ff ff ff       	call   80106b6f <memmove>
80106c00:	83 c4 0c             	add    $0xc,%esp
}
80106c03:	c9                   	leave  
80106c04:	c3                   	ret    

80106c05 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106c05:	55                   	push   %ebp
80106c06:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80106c08:	eb 0c                	jmp    80106c16 <strncmp+0x11>
    n--, p++, q++;
80106c0a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106c0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106c12:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106c16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c1a:	74 1a                	je     80106c36 <strncmp+0x31>
80106c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c1f:	0f b6 00             	movzbl (%eax),%eax
80106c22:	84 c0                	test   %al,%al
80106c24:	74 10                	je     80106c36 <strncmp+0x31>
80106c26:	8b 45 08             	mov    0x8(%ebp),%eax
80106c29:	0f b6 10             	movzbl (%eax),%edx
80106c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c2f:	0f b6 00             	movzbl (%eax),%eax
80106c32:	38 c2                	cmp    %al,%dl
80106c34:	74 d4                	je     80106c0a <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106c36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c3a:	75 07                	jne    80106c43 <strncmp+0x3e>
    return 0;
80106c3c:	b8 00 00 00 00       	mov    $0x0,%eax
80106c41:	eb 16                	jmp    80106c59 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106c43:	8b 45 08             	mov    0x8(%ebp),%eax
80106c46:	0f b6 00             	movzbl (%eax),%eax
80106c49:	0f b6 d0             	movzbl %al,%edx
80106c4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c4f:	0f b6 00             	movzbl (%eax),%eax
80106c52:	0f b6 c0             	movzbl %al,%eax
80106c55:	29 c2                	sub    %eax,%edx
80106c57:	89 d0                	mov    %edx,%eax
}
80106c59:	5d                   	pop    %ebp
80106c5a:	c3                   	ret    

80106c5b <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106c5b:	55                   	push   %ebp
80106c5c:	89 e5                	mov    %esp,%ebp
80106c5e:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106c61:	8b 45 08             	mov    0x8(%ebp),%eax
80106c64:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106c67:	90                   	nop
80106c68:	8b 45 10             	mov    0x10(%ebp),%eax
80106c6b:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c6e:	89 55 10             	mov    %edx,0x10(%ebp)
80106c71:	85 c0                	test   %eax,%eax
80106c73:	7e 2c                	jle    80106ca1 <strncpy+0x46>
80106c75:	8b 45 08             	mov    0x8(%ebp),%eax
80106c78:	8d 50 01             	lea    0x1(%eax),%edx
80106c7b:	89 55 08             	mov    %edx,0x8(%ebp)
80106c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c81:	8d 4a 01             	lea    0x1(%edx),%ecx
80106c84:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106c87:	0f b6 12             	movzbl (%edx),%edx
80106c8a:	88 10                	mov    %dl,(%eax)
80106c8c:	0f b6 00             	movzbl (%eax),%eax
80106c8f:	84 c0                	test   %al,%al
80106c91:	75 d5                	jne    80106c68 <strncpy+0xd>
    ;
  while(n-- > 0)
80106c93:	eb 0c                	jmp    80106ca1 <strncpy+0x46>
    *s++ = 0;
80106c95:	8b 45 08             	mov    0x8(%ebp),%eax
80106c98:	8d 50 01             	lea    0x1(%eax),%edx
80106c9b:	89 55 08             	mov    %edx,0x8(%ebp)
80106c9e:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106ca1:	8b 45 10             	mov    0x10(%ebp),%eax
80106ca4:	8d 50 ff             	lea    -0x1(%eax),%edx
80106ca7:	89 55 10             	mov    %edx,0x10(%ebp)
80106caa:	85 c0                	test   %eax,%eax
80106cac:	7f e7                	jg     80106c95 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106cae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106cb1:	c9                   	leave  
80106cb2:	c3                   	ret    

80106cb3 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106cb3:	55                   	push   %ebp
80106cb4:	89 e5                	mov    %esp,%ebp
80106cb6:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80106cbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106cbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106cc3:	7f 05                	jg     80106cca <safestrcpy+0x17>
    return os;
80106cc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106cc8:	eb 31                	jmp    80106cfb <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106cca:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106cd2:	7e 1e                	jle    80106cf2 <safestrcpy+0x3f>
80106cd4:	8b 45 08             	mov    0x8(%ebp),%eax
80106cd7:	8d 50 01             	lea    0x1(%eax),%edx
80106cda:	89 55 08             	mov    %edx,0x8(%ebp)
80106cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ce0:	8d 4a 01             	lea    0x1(%edx),%ecx
80106ce3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106ce6:	0f b6 12             	movzbl (%edx),%edx
80106ce9:	88 10                	mov    %dl,(%eax)
80106ceb:	0f b6 00             	movzbl (%eax),%eax
80106cee:	84 c0                	test   %al,%al
80106cf0:	75 d8                	jne    80106cca <safestrcpy+0x17>
    ;
  *s = 0;
80106cf2:	8b 45 08             	mov    0x8(%ebp),%eax
80106cf5:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80106cf8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106cfb:	c9                   	leave  
80106cfc:	c3                   	ret    

80106cfd <strlen>:

int
strlen(const char *s)
{
80106cfd:	55                   	push   %ebp
80106cfe:	89 e5                	mov    %esp,%ebp
80106d00:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106d03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106d0a:	eb 04                	jmp    80106d10 <strlen+0x13>
80106d0c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106d10:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106d13:	8b 45 08             	mov    0x8(%ebp),%eax
80106d16:	01 d0                	add    %edx,%eax
80106d18:	0f b6 00             	movzbl (%eax),%eax
80106d1b:	84 c0                	test   %al,%al
80106d1d:	75 ed                	jne    80106d0c <strlen+0xf>
    ;
  return n;
80106d1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d22:	c9                   	leave  
80106d23:	c3                   	ret    

80106d24 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106d24:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106d28:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106d2c:	55                   	push   %ebp
  pushl %ebx
80106d2d:	53                   	push   %ebx
  pushl %esi
80106d2e:	56                   	push   %esi
  pushl %edi
80106d2f:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106d30:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106d32:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106d34:	5f                   	pop    %edi
  popl %esi
80106d35:	5e                   	pop    %esi
  popl %ebx
80106d36:	5b                   	pop    %ebx
  popl %ebp
80106d37:	5d                   	pop    %ebp
  ret
80106d38:	c3                   	ret    

80106d39 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106d39:	55                   	push   %ebp
80106d3a:	89 e5                	mov    %esp,%ebp
    if(addr >= proc->sz || addr+4 > proc->sz)
80106d3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d42:	8b 00                	mov    (%eax),%eax
80106d44:	3b 45 08             	cmp    0x8(%ebp),%eax
80106d47:	76 12                	jbe    80106d5b <fetchint+0x22>
80106d49:	8b 45 08             	mov    0x8(%ebp),%eax
80106d4c:	8d 50 04             	lea    0x4(%eax),%edx
80106d4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d55:	8b 00                	mov    (%eax),%eax
80106d57:	39 c2                	cmp    %eax,%edx
80106d59:	76 07                	jbe    80106d62 <fetchint+0x29>
        return -1;
80106d5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d60:	eb 0f                	jmp    80106d71 <fetchint+0x38>
    *ip = *(int*)(addr);
80106d62:	8b 45 08             	mov    0x8(%ebp),%eax
80106d65:	8b 10                	mov    (%eax),%edx
80106d67:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d6a:	89 10                	mov    %edx,(%eax)
    return 0;
80106d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d71:	5d                   	pop    %ebp
80106d72:	c3                   	ret    

80106d73 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106d73:	55                   	push   %ebp
80106d74:	89 e5                	mov    %esp,%ebp
80106d76:	83 ec 10             	sub    $0x10,%esp
    char *s, *ep;

    if(addr >= proc->sz)
80106d79:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d7f:	8b 00                	mov    (%eax),%eax
80106d81:	3b 45 08             	cmp    0x8(%ebp),%eax
80106d84:	77 07                	ja     80106d8d <fetchstr+0x1a>
        return -1;
80106d86:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d8b:	eb 46                	jmp    80106dd3 <fetchstr+0x60>
    *pp = (char*)addr;
80106d8d:	8b 55 08             	mov    0x8(%ebp),%edx
80106d90:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d93:	89 10                	mov    %edx,(%eax)
    ep = (char*)proc->sz;
80106d95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d9b:	8b 00                	mov    (%eax),%eax
80106d9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    for(s = *pp; s < ep; s++)
80106da0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106da3:	8b 00                	mov    (%eax),%eax
80106da5:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106da8:	eb 1c                	jmp    80106dc6 <fetchstr+0x53>
        if(*s == 0)
80106daa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106dad:	0f b6 00             	movzbl (%eax),%eax
80106db0:	84 c0                	test   %al,%al
80106db2:	75 0e                	jne    80106dc2 <fetchstr+0x4f>
            return s - *pp;
80106db4:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106db7:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dba:	8b 00                	mov    (%eax),%eax
80106dbc:	29 c2                	sub    %eax,%edx
80106dbe:	89 d0                	mov    %edx,%eax
80106dc0:	eb 11                	jmp    80106dd3 <fetchstr+0x60>

    if(addr >= proc->sz)
        return -1;
    *pp = (char*)addr;
    ep = (char*)proc->sz;
    for(s = *pp; s < ep; s++)
80106dc2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106dc9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106dcc:	72 dc                	jb     80106daa <fetchstr+0x37>
        if(*s == 0)
            return s - *pp;
    return -1;
80106dce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106dd3:	c9                   	leave  
80106dd4:	c3                   	ret    

80106dd5 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106dd5:	55                   	push   %ebp
80106dd6:	89 e5                	mov    %esp,%ebp
    return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106dd8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dde:	8b 40 18             	mov    0x18(%eax),%eax
80106de1:	8b 40 44             	mov    0x44(%eax),%eax
80106de4:	8b 55 08             	mov    0x8(%ebp),%edx
80106de7:	c1 e2 02             	shl    $0x2,%edx
80106dea:	01 d0                	add    %edx,%eax
80106dec:	83 c0 04             	add    $0x4,%eax
80106def:	ff 75 0c             	pushl  0xc(%ebp)
80106df2:	50                   	push   %eax
80106df3:	e8 41 ff ff ff       	call   80106d39 <fetchint>
80106df8:	83 c4 08             	add    $0x8,%esp
}
80106dfb:	c9                   	leave  
80106dfc:	c3                   	ret    

80106dfd <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106dfd:	55                   	push   %ebp
80106dfe:	89 e5                	mov    %esp,%ebp
80106e00:	83 ec 10             	sub    $0x10,%esp
    int i;

    if(argint(n, &i) < 0)
80106e03:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106e06:	50                   	push   %eax
80106e07:	ff 75 08             	pushl  0x8(%ebp)
80106e0a:	e8 c6 ff ff ff       	call   80106dd5 <argint>
80106e0f:	83 c4 08             	add    $0x8,%esp
80106e12:	85 c0                	test   %eax,%eax
80106e14:	79 07                	jns    80106e1d <argptr+0x20>
        return -1;
80106e16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e1b:	eb 3b                	jmp    80106e58 <argptr+0x5b>
    if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106e1d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e23:	8b 00                	mov    (%eax),%eax
80106e25:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e28:	39 d0                	cmp    %edx,%eax
80106e2a:	76 16                	jbe    80106e42 <argptr+0x45>
80106e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e2f:	89 c2                	mov    %eax,%edx
80106e31:	8b 45 10             	mov    0x10(%ebp),%eax
80106e34:	01 c2                	add    %eax,%edx
80106e36:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e3c:	8b 00                	mov    (%eax),%eax
80106e3e:	39 c2                	cmp    %eax,%edx
80106e40:	76 07                	jbe    80106e49 <argptr+0x4c>
        return -1;
80106e42:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e47:	eb 0f                	jmp    80106e58 <argptr+0x5b>
    *pp = (char*)i;
80106e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e4c:	89 c2                	mov    %eax,%edx
80106e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e51:	89 10                	mov    %edx,(%eax)
    return 0;
80106e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e58:	c9                   	leave  
80106e59:	c3                   	ret    

80106e5a <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106e5a:	55                   	push   %ebp
80106e5b:	89 e5                	mov    %esp,%ebp
80106e5d:	83 ec 10             	sub    $0x10,%esp
    int addr;
    if(argint(n, &addr) < 0)
80106e60:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106e63:	50                   	push   %eax
80106e64:	ff 75 08             	pushl  0x8(%ebp)
80106e67:	e8 69 ff ff ff       	call   80106dd5 <argint>
80106e6c:	83 c4 08             	add    $0x8,%esp
80106e6f:	85 c0                	test   %eax,%eax
80106e71:	79 07                	jns    80106e7a <argstr+0x20>
        return -1;
80106e73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e78:	eb 0f                	jmp    80106e89 <argstr+0x2f>
    return fetchstr(addr, pp);
80106e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e7d:	ff 75 0c             	pushl  0xc(%ebp)
80106e80:	50                   	push   %eax
80106e81:	e8 ed fe ff ff       	call   80106d73 <fetchstr>
80106e86:	83 c4 08             	add    $0x8,%esp
}
80106e89:	c9                   	leave  
80106e8a:	c3                   	ret    

80106e8b <syscall>:
};
#endif

void
syscall(void)
{
80106e8b:	55                   	push   %ebp
80106e8c:	89 e5                	mov    %esp,%ebp
80106e8e:	53                   	push   %ebx
80106e8f:	83 ec 14             	sub    $0x14,%esp
    int num;

    num = proc->tf->eax;
80106e92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e98:	8b 40 18             	mov    0x18(%eax),%eax
80106e9b:	8b 40 1c             	mov    0x1c(%eax),%eax
80106e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106ea1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ea5:	7e 30                	jle    80106ed7 <syscall+0x4c>
80106ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eaa:	83 f8 1e             	cmp    $0x1e,%eax
80106ead:	77 28                	ja     80106ed7 <syscall+0x4c>
80106eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eb2:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106eb9:	85 c0                	test   %eax,%eax
80106ebb:	74 1a                	je     80106ed7 <syscall+0x4c>
        proc->tf->eax = syscalls[num]();
80106ebd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ec3:	8b 58 18             	mov    0x18(%eax),%ebx
80106ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ec9:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106ed0:	ff d0                	call   *%eax
80106ed2:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106ed5:	eb 34                	jmp    80106f0b <syscall+0x80>
#ifdef PRINT_SYSCALLS
        cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif
    } else {
        cprintf("%d %s: unknown sys call %d\n",
                proc->pid, proc->name, num);
80106ed7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106edd:	8d 50 6c             	lea    0x6c(%eax),%edx
80106ee0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
        // some code goes here
#ifdef PRINT_SYSCALLS
        cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif
    } else {
        cprintf("%d %s: unknown sys call %d\n",
80106ee6:	8b 40 10             	mov    0x10(%eax),%eax
80106ee9:	ff 75 f4             	pushl  -0xc(%ebp)
80106eec:	52                   	push   %edx
80106eed:	50                   	push   %eax
80106eee:	68 be aa 10 80       	push   $0x8010aabe
80106ef3:	e8 ce 94 ff ff       	call   801003c6 <cprintf>
80106ef8:	83 c4 10             	add    $0x10,%esp
                proc->pid, proc->name, num);
        proc->tf->eax = -1;
80106efb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f01:	8b 40 18             	mov    0x18(%eax),%eax
80106f04:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
    }
}
80106f0b:	90                   	nop
80106f0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106f0f:	c9                   	leave  
80106f10:	c3                   	ret    

80106f11 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106f11:	55                   	push   %ebp
80106f12:	89 e5                	mov    %esp,%ebp
80106f14:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106f17:	83 ec 08             	sub    $0x8,%esp
80106f1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f1d:	50                   	push   %eax
80106f1e:	ff 75 08             	pushl  0x8(%ebp)
80106f21:	e8 af fe ff ff       	call   80106dd5 <argint>
80106f26:	83 c4 10             	add    $0x10,%esp
80106f29:	85 c0                	test   %eax,%eax
80106f2b:	79 07                	jns    80106f34 <argfd+0x23>
    return -1;
80106f2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f32:	eb 50                	jmp    80106f84 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f37:	85 c0                	test   %eax,%eax
80106f39:	78 21                	js     80106f5c <argfd+0x4b>
80106f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f3e:	83 f8 0f             	cmp    $0xf,%eax
80106f41:	7f 19                	jg     80106f5c <argfd+0x4b>
80106f43:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f49:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106f4c:	83 c2 08             	add    $0x8,%edx
80106f4f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106f53:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106f56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106f5a:	75 07                	jne    80106f63 <argfd+0x52>
    return -1;
80106f5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f61:	eb 21                	jmp    80106f84 <argfd+0x73>
  if(pfd)
80106f63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106f67:	74 08                	je     80106f71 <argfd+0x60>
    *pfd = fd;
80106f69:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106f6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f6f:	89 10                	mov    %edx,(%eax)
  if(pf)
80106f71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106f75:	74 08                	je     80106f7f <argfd+0x6e>
    *pf = f;
80106f77:	8b 45 10             	mov    0x10(%ebp),%eax
80106f7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f7d:	89 10                	mov    %edx,(%eax)
  return 0;
80106f7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106f84:	c9                   	leave  
80106f85:	c3                   	ret    

80106f86 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106f86:	55                   	push   %ebp
80106f87:	89 e5                	mov    %esp,%ebp
80106f89:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106f8c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106f93:	eb 30                	jmp    80106fc5 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106f95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f9b:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106f9e:	83 c2 08             	add    $0x8,%edx
80106fa1:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106fa5:	85 c0                	test   %eax,%eax
80106fa7:	75 18                	jne    80106fc1 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106fa9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106faf:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106fb2:	8d 4a 08             	lea    0x8(%edx),%ecx
80106fb5:	8b 55 08             	mov    0x8(%ebp),%edx
80106fb8:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106fbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106fbf:	eb 0f                	jmp    80106fd0 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106fc1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106fc5:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106fc9:	7e ca                	jle    80106f95 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80106fcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fd0:	c9                   	leave  
80106fd1:	c3                   	ret    

80106fd2 <sys_dup>:

int
sys_dup(void)
{
80106fd2:	55                   	push   %ebp
80106fd3:	89 e5                	mov    %esp,%ebp
80106fd5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106fd8:	83 ec 04             	sub    $0x4,%esp
80106fdb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106fde:	50                   	push   %eax
80106fdf:	6a 00                	push   $0x0
80106fe1:	6a 00                	push   $0x0
80106fe3:	e8 29 ff ff ff       	call   80106f11 <argfd>
80106fe8:	83 c4 10             	add    $0x10,%esp
80106feb:	85 c0                	test   %eax,%eax
80106fed:	79 07                	jns    80106ff6 <sys_dup+0x24>
    return -1;
80106fef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ff4:	eb 31                	jmp    80107027 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106ff6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ff9:	83 ec 0c             	sub    $0xc,%esp
80106ffc:	50                   	push   %eax
80106ffd:	e8 84 ff ff ff       	call   80106f86 <fdalloc>
80107002:	83 c4 10             	add    $0x10,%esp
80107005:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107008:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010700c:	79 07                	jns    80107015 <sys_dup+0x43>
    return -1;
8010700e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107013:	eb 12                	jmp    80107027 <sys_dup+0x55>
  filedup(f);
80107015:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107018:	83 ec 0c             	sub    $0xc,%esp
8010701b:	50                   	push   %eax
8010701c:	e8 90 a0 ff ff       	call   801010b1 <filedup>
80107021:	83 c4 10             	add    $0x10,%esp
  return fd;
80107024:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107027:	c9                   	leave  
80107028:	c3                   	ret    

80107029 <sys_read>:

int
sys_read(void)
{
80107029:	55                   	push   %ebp
8010702a:	89 e5                	mov    %esp,%ebp
8010702c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010702f:	83 ec 04             	sub    $0x4,%esp
80107032:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107035:	50                   	push   %eax
80107036:	6a 00                	push   $0x0
80107038:	6a 00                	push   $0x0
8010703a:	e8 d2 fe ff ff       	call   80106f11 <argfd>
8010703f:	83 c4 10             	add    $0x10,%esp
80107042:	85 c0                	test   %eax,%eax
80107044:	78 2e                	js     80107074 <sys_read+0x4b>
80107046:	83 ec 08             	sub    $0x8,%esp
80107049:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010704c:	50                   	push   %eax
8010704d:	6a 02                	push   $0x2
8010704f:	e8 81 fd ff ff       	call   80106dd5 <argint>
80107054:	83 c4 10             	add    $0x10,%esp
80107057:	85 c0                	test   %eax,%eax
80107059:	78 19                	js     80107074 <sys_read+0x4b>
8010705b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010705e:	83 ec 04             	sub    $0x4,%esp
80107061:	50                   	push   %eax
80107062:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107065:	50                   	push   %eax
80107066:	6a 01                	push   $0x1
80107068:	e8 90 fd ff ff       	call   80106dfd <argptr>
8010706d:	83 c4 10             	add    $0x10,%esp
80107070:	85 c0                	test   %eax,%eax
80107072:	79 07                	jns    8010707b <sys_read+0x52>
    return -1;
80107074:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107079:	eb 17                	jmp    80107092 <sys_read+0x69>
  return fileread(f, p, n);
8010707b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010707e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107084:	83 ec 04             	sub    $0x4,%esp
80107087:	51                   	push   %ecx
80107088:	52                   	push   %edx
80107089:	50                   	push   %eax
8010708a:	e8 b2 a1 ff ff       	call   80101241 <fileread>
8010708f:	83 c4 10             	add    $0x10,%esp
}
80107092:	c9                   	leave  
80107093:	c3                   	ret    

80107094 <sys_write>:

int
sys_write(void)
{
80107094:	55                   	push   %ebp
80107095:	89 e5                	mov    %esp,%ebp
80107097:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010709a:	83 ec 04             	sub    $0x4,%esp
8010709d:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070a0:	50                   	push   %eax
801070a1:	6a 00                	push   $0x0
801070a3:	6a 00                	push   $0x0
801070a5:	e8 67 fe ff ff       	call   80106f11 <argfd>
801070aa:	83 c4 10             	add    $0x10,%esp
801070ad:	85 c0                	test   %eax,%eax
801070af:	78 2e                	js     801070df <sys_write+0x4b>
801070b1:	83 ec 08             	sub    $0x8,%esp
801070b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070b7:	50                   	push   %eax
801070b8:	6a 02                	push   $0x2
801070ba:	e8 16 fd ff ff       	call   80106dd5 <argint>
801070bf:	83 c4 10             	add    $0x10,%esp
801070c2:	85 c0                	test   %eax,%eax
801070c4:	78 19                	js     801070df <sys_write+0x4b>
801070c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070c9:	83 ec 04             	sub    $0x4,%esp
801070cc:	50                   	push   %eax
801070cd:	8d 45 ec             	lea    -0x14(%ebp),%eax
801070d0:	50                   	push   %eax
801070d1:	6a 01                	push   $0x1
801070d3:	e8 25 fd ff ff       	call   80106dfd <argptr>
801070d8:	83 c4 10             	add    $0x10,%esp
801070db:	85 c0                	test   %eax,%eax
801070dd:	79 07                	jns    801070e6 <sys_write+0x52>
    return -1;
801070df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070e4:	eb 17                	jmp    801070fd <sys_write+0x69>
  return filewrite(f, p, n);
801070e6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801070e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801070ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070ef:	83 ec 04             	sub    $0x4,%esp
801070f2:	51                   	push   %ecx
801070f3:	52                   	push   %edx
801070f4:	50                   	push   %eax
801070f5:	e8 ff a1 ff ff       	call   801012f9 <filewrite>
801070fa:	83 c4 10             	add    $0x10,%esp
}
801070fd:	c9                   	leave  
801070fe:	c3                   	ret    

801070ff <sys_close>:

int
sys_close(void)
{
801070ff:	55                   	push   %ebp
80107100:	89 e5                	mov    %esp,%ebp
80107102:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80107105:	83 ec 04             	sub    $0x4,%esp
80107108:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010710b:	50                   	push   %eax
8010710c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010710f:	50                   	push   %eax
80107110:	6a 00                	push   $0x0
80107112:	e8 fa fd ff ff       	call   80106f11 <argfd>
80107117:	83 c4 10             	add    $0x10,%esp
8010711a:	85 c0                	test   %eax,%eax
8010711c:	79 07                	jns    80107125 <sys_close+0x26>
    return -1;
8010711e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107123:	eb 28                	jmp    8010714d <sys_close+0x4e>
  proc->ofile[fd] = 0;
80107125:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010712b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010712e:	83 c2 08             	add    $0x8,%edx
80107131:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107138:	00 
  fileclose(f);
80107139:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010713c:	83 ec 0c             	sub    $0xc,%esp
8010713f:	50                   	push   %eax
80107140:	e8 bd 9f ff ff       	call   80101102 <fileclose>
80107145:	83 c4 10             	add    $0x10,%esp
  return 0;
80107148:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010714d:	c9                   	leave  
8010714e:	c3                   	ret    

8010714f <sys_fstat>:

int
sys_fstat(void)
{
8010714f:	55                   	push   %ebp
80107150:	89 e5                	mov    %esp,%ebp
80107152:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80107155:	83 ec 04             	sub    $0x4,%esp
80107158:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010715b:	50                   	push   %eax
8010715c:	6a 00                	push   $0x0
8010715e:	6a 00                	push   $0x0
80107160:	e8 ac fd ff ff       	call   80106f11 <argfd>
80107165:	83 c4 10             	add    $0x10,%esp
80107168:	85 c0                	test   %eax,%eax
8010716a:	78 17                	js     80107183 <sys_fstat+0x34>
8010716c:	83 ec 04             	sub    $0x4,%esp
8010716f:	6a 14                	push   $0x14
80107171:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107174:	50                   	push   %eax
80107175:	6a 01                	push   $0x1
80107177:	e8 81 fc ff ff       	call   80106dfd <argptr>
8010717c:	83 c4 10             	add    $0x10,%esp
8010717f:	85 c0                	test   %eax,%eax
80107181:	79 07                	jns    8010718a <sys_fstat+0x3b>
    return -1;
80107183:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107188:	eb 13                	jmp    8010719d <sys_fstat+0x4e>
  return filestat(f, st);
8010718a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010718d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107190:	83 ec 08             	sub    $0x8,%esp
80107193:	52                   	push   %edx
80107194:	50                   	push   %eax
80107195:	e8 50 a0 ff ff       	call   801011ea <filestat>
8010719a:	83 c4 10             	add    $0x10,%esp
}
8010719d:	c9                   	leave  
8010719e:	c3                   	ret    

8010719f <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010719f:	55                   	push   %ebp
801071a0:	89 e5                	mov    %esp,%ebp
801071a2:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801071a5:	83 ec 08             	sub    $0x8,%esp
801071a8:	8d 45 d8             	lea    -0x28(%ebp),%eax
801071ab:	50                   	push   %eax
801071ac:	6a 00                	push   $0x0
801071ae:	e8 a7 fc ff ff       	call   80106e5a <argstr>
801071b3:	83 c4 10             	add    $0x10,%esp
801071b6:	85 c0                	test   %eax,%eax
801071b8:	78 15                	js     801071cf <sys_link+0x30>
801071ba:	83 ec 08             	sub    $0x8,%esp
801071bd:	8d 45 dc             	lea    -0x24(%ebp),%eax
801071c0:	50                   	push   %eax
801071c1:	6a 01                	push   $0x1
801071c3:	e8 92 fc ff ff       	call   80106e5a <argstr>
801071c8:	83 c4 10             	add    $0x10,%esp
801071cb:	85 c0                	test   %eax,%eax
801071cd:	79 0a                	jns    801071d9 <sys_link+0x3a>
    return -1;
801071cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071d4:	e9 68 01 00 00       	jmp    80107341 <sys_link+0x1a2>

  begin_op();
801071d9:	e8 20 c4 ff ff       	call   801035fe <begin_op>
  if((ip = namei(old)) == 0){
801071de:	8b 45 d8             	mov    -0x28(%ebp),%eax
801071e1:	83 ec 0c             	sub    $0xc,%esp
801071e4:	50                   	push   %eax
801071e5:	e8 ef b3 ff ff       	call   801025d9 <namei>
801071ea:	83 c4 10             	add    $0x10,%esp
801071ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
801071f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801071f4:	75 0f                	jne    80107205 <sys_link+0x66>
    end_op();
801071f6:	e8 8f c4 ff ff       	call   8010368a <end_op>
    return -1;
801071fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107200:	e9 3c 01 00 00       	jmp    80107341 <sys_link+0x1a2>
  }

  ilock(ip);
80107205:	83 ec 0c             	sub    $0xc,%esp
80107208:	ff 75 f4             	pushl  -0xc(%ebp)
8010720b:	e8 0b a8 ff ff       	call   80101a1b <ilock>
80107210:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80107213:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107216:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010721a:	66 83 f8 01          	cmp    $0x1,%ax
8010721e:	75 1d                	jne    8010723d <sys_link+0x9e>
    iunlockput(ip);
80107220:	83 ec 0c             	sub    $0xc,%esp
80107223:	ff 75 f4             	pushl  -0xc(%ebp)
80107226:	e8 b0 aa ff ff       	call   80101cdb <iunlockput>
8010722b:	83 c4 10             	add    $0x10,%esp
    end_op();
8010722e:	e8 57 c4 ff ff       	call   8010368a <end_op>
    return -1;
80107233:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107238:	e9 04 01 00 00       	jmp    80107341 <sys_link+0x1a2>
  }

  ip->nlink++;
8010723d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107240:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107244:	83 c0 01             	add    $0x1,%eax
80107247:	89 c2                	mov    %eax,%edx
80107249:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010724c:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107250:	83 ec 0c             	sub    $0xc,%esp
80107253:	ff 75 f4             	pushl  -0xc(%ebp)
80107256:	e8 e6 a5 ff ff       	call   80101841 <iupdate>
8010725b:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
8010725e:	83 ec 0c             	sub    $0xc,%esp
80107261:	ff 75 f4             	pushl  -0xc(%ebp)
80107264:	e8 10 a9 ff ff       	call   80101b79 <iunlock>
80107269:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
8010726c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010726f:	83 ec 08             	sub    $0x8,%esp
80107272:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80107275:	52                   	push   %edx
80107276:	50                   	push   %eax
80107277:	e8 79 b3 ff ff       	call   801025f5 <nameiparent>
8010727c:	83 c4 10             	add    $0x10,%esp
8010727f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107282:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107286:	74 71                	je     801072f9 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80107288:	83 ec 0c             	sub    $0xc,%esp
8010728b:	ff 75 f0             	pushl  -0x10(%ebp)
8010728e:	e8 88 a7 ff ff       	call   80101a1b <ilock>
80107293:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80107296:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107299:	8b 10                	mov    (%eax),%edx
8010729b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010729e:	8b 00                	mov    (%eax),%eax
801072a0:	39 c2                	cmp    %eax,%edx
801072a2:	75 1d                	jne    801072c1 <sys_link+0x122>
801072a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072a7:	8b 40 04             	mov    0x4(%eax),%eax
801072aa:	83 ec 04             	sub    $0x4,%esp
801072ad:	50                   	push   %eax
801072ae:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801072b1:	50                   	push   %eax
801072b2:	ff 75 f0             	pushl  -0x10(%ebp)
801072b5:	e8 83 b0 ff ff       	call   8010233d <dirlink>
801072ba:	83 c4 10             	add    $0x10,%esp
801072bd:	85 c0                	test   %eax,%eax
801072bf:	79 10                	jns    801072d1 <sys_link+0x132>
    iunlockput(dp);
801072c1:	83 ec 0c             	sub    $0xc,%esp
801072c4:	ff 75 f0             	pushl  -0x10(%ebp)
801072c7:	e8 0f aa ff ff       	call   80101cdb <iunlockput>
801072cc:	83 c4 10             	add    $0x10,%esp
    goto bad;
801072cf:	eb 29                	jmp    801072fa <sys_link+0x15b>
  }
  iunlockput(dp);
801072d1:	83 ec 0c             	sub    $0xc,%esp
801072d4:	ff 75 f0             	pushl  -0x10(%ebp)
801072d7:	e8 ff a9 ff ff       	call   80101cdb <iunlockput>
801072dc:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801072df:	83 ec 0c             	sub    $0xc,%esp
801072e2:	ff 75 f4             	pushl  -0xc(%ebp)
801072e5:	e8 01 a9 ff ff       	call   80101beb <iput>
801072ea:	83 c4 10             	add    $0x10,%esp

  end_op();
801072ed:	e8 98 c3 ff ff       	call   8010368a <end_op>

  return 0;
801072f2:	b8 00 00 00 00       	mov    $0x0,%eax
801072f7:	eb 48                	jmp    80107341 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801072f9:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
801072fa:	83 ec 0c             	sub    $0xc,%esp
801072fd:	ff 75 f4             	pushl  -0xc(%ebp)
80107300:	e8 16 a7 ff ff       	call   80101a1b <ilock>
80107305:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80107308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010730b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010730f:	83 e8 01             	sub    $0x1,%eax
80107312:	89 c2                	mov    %eax,%edx
80107314:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107317:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010731b:	83 ec 0c             	sub    $0xc,%esp
8010731e:	ff 75 f4             	pushl  -0xc(%ebp)
80107321:	e8 1b a5 ff ff       	call   80101841 <iupdate>
80107326:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107329:	83 ec 0c             	sub    $0xc,%esp
8010732c:	ff 75 f4             	pushl  -0xc(%ebp)
8010732f:	e8 a7 a9 ff ff       	call   80101cdb <iunlockput>
80107334:	83 c4 10             	add    $0x10,%esp
  end_op();
80107337:	e8 4e c3 ff ff       	call   8010368a <end_op>
  return -1;
8010733c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107341:	c9                   	leave  
80107342:	c3                   	ret    

80107343 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80107343:	55                   	push   %ebp
80107344:	89 e5                	mov    %esp,%ebp
80107346:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107349:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80107350:	eb 40                	jmp    80107392 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80107352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107355:	6a 10                	push   $0x10
80107357:	50                   	push   %eax
80107358:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010735b:	50                   	push   %eax
8010735c:	ff 75 08             	pushl  0x8(%ebp)
8010735f:	e8 25 ac ff ff       	call   80101f89 <readi>
80107364:	83 c4 10             	add    $0x10,%esp
80107367:	83 f8 10             	cmp    $0x10,%eax
8010736a:	74 0d                	je     80107379 <isdirempty+0x36>
      panic("isdirempty: readi");
8010736c:	83 ec 0c             	sub    $0xc,%esp
8010736f:	68 da aa 10 80       	push   $0x8010aada
80107374:	e8 ed 91 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80107379:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010737d:	66 85 c0             	test   %ax,%ax
80107380:	74 07                	je     80107389 <isdirempty+0x46>
      return 0;
80107382:	b8 00 00 00 00       	mov    $0x0,%eax
80107387:	eb 1b                	jmp    801073a4 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010738c:	83 c0 10             	add    $0x10,%eax
8010738f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107392:	8b 45 08             	mov    0x8(%ebp),%eax
80107395:	8b 50 18             	mov    0x18(%eax),%edx
80107398:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739b:	39 c2                	cmp    %eax,%edx
8010739d:	77 b3                	ja     80107352 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010739f:	b8 01 00 00 00       	mov    $0x1,%eax
}
801073a4:	c9                   	leave  
801073a5:	c3                   	ret    

801073a6 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801073a6:	55                   	push   %ebp
801073a7:	89 e5                	mov    %esp,%ebp
801073a9:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801073ac:	83 ec 08             	sub    $0x8,%esp
801073af:	8d 45 cc             	lea    -0x34(%ebp),%eax
801073b2:	50                   	push   %eax
801073b3:	6a 00                	push   $0x0
801073b5:	e8 a0 fa ff ff       	call   80106e5a <argstr>
801073ba:	83 c4 10             	add    $0x10,%esp
801073bd:	85 c0                	test   %eax,%eax
801073bf:	79 0a                	jns    801073cb <sys_unlink+0x25>
    return -1;
801073c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073c6:	e9 bc 01 00 00       	jmp    80107587 <sys_unlink+0x1e1>

  begin_op();
801073cb:	e8 2e c2 ff ff       	call   801035fe <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801073d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
801073d3:	83 ec 08             	sub    $0x8,%esp
801073d6:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801073d9:	52                   	push   %edx
801073da:	50                   	push   %eax
801073db:	e8 15 b2 ff ff       	call   801025f5 <nameiparent>
801073e0:	83 c4 10             	add    $0x10,%esp
801073e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801073ea:	75 0f                	jne    801073fb <sys_unlink+0x55>
    end_op();
801073ec:	e8 99 c2 ff ff       	call   8010368a <end_op>
    return -1;
801073f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073f6:	e9 8c 01 00 00       	jmp    80107587 <sys_unlink+0x1e1>
  }

  ilock(dp);
801073fb:	83 ec 0c             	sub    $0xc,%esp
801073fe:	ff 75 f4             	pushl  -0xc(%ebp)
80107401:	e8 15 a6 ff ff       	call   80101a1b <ilock>
80107406:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80107409:	83 ec 08             	sub    $0x8,%esp
8010740c:	68 ec aa 10 80       	push   $0x8010aaec
80107411:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107414:	50                   	push   %eax
80107415:	e8 4e ae ff ff       	call   80102268 <namecmp>
8010741a:	83 c4 10             	add    $0x10,%esp
8010741d:	85 c0                	test   %eax,%eax
8010741f:	0f 84 4a 01 00 00    	je     8010756f <sys_unlink+0x1c9>
80107425:	83 ec 08             	sub    $0x8,%esp
80107428:	68 ee aa 10 80       	push   $0x8010aaee
8010742d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107430:	50                   	push   %eax
80107431:	e8 32 ae ff ff       	call   80102268 <namecmp>
80107436:	83 c4 10             	add    $0x10,%esp
80107439:	85 c0                	test   %eax,%eax
8010743b:	0f 84 2e 01 00 00    	je     8010756f <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80107441:	83 ec 04             	sub    $0x4,%esp
80107444:	8d 45 c8             	lea    -0x38(%ebp),%eax
80107447:	50                   	push   %eax
80107448:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010744b:	50                   	push   %eax
8010744c:	ff 75 f4             	pushl  -0xc(%ebp)
8010744f:	e8 2f ae ff ff       	call   80102283 <dirlookup>
80107454:	83 c4 10             	add    $0x10,%esp
80107457:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010745a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010745e:	0f 84 0a 01 00 00    	je     8010756e <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80107464:	83 ec 0c             	sub    $0xc,%esp
80107467:	ff 75 f0             	pushl  -0x10(%ebp)
8010746a:	e8 ac a5 ff ff       	call   80101a1b <ilock>
8010746f:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80107472:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107475:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107479:	66 85 c0             	test   %ax,%ax
8010747c:	7f 0d                	jg     8010748b <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
8010747e:	83 ec 0c             	sub    $0xc,%esp
80107481:	68 f1 aa 10 80       	push   $0x8010aaf1
80107486:	e8 db 90 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010748b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010748e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107492:	66 83 f8 01          	cmp    $0x1,%ax
80107496:	75 25                	jne    801074bd <sys_unlink+0x117>
80107498:	83 ec 0c             	sub    $0xc,%esp
8010749b:	ff 75 f0             	pushl  -0x10(%ebp)
8010749e:	e8 a0 fe ff ff       	call   80107343 <isdirempty>
801074a3:	83 c4 10             	add    $0x10,%esp
801074a6:	85 c0                	test   %eax,%eax
801074a8:	75 13                	jne    801074bd <sys_unlink+0x117>
    iunlockput(ip);
801074aa:	83 ec 0c             	sub    $0xc,%esp
801074ad:	ff 75 f0             	pushl  -0x10(%ebp)
801074b0:	e8 26 a8 ff ff       	call   80101cdb <iunlockput>
801074b5:	83 c4 10             	add    $0x10,%esp
    goto bad;
801074b8:	e9 b2 00 00 00       	jmp    8010756f <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801074bd:	83 ec 04             	sub    $0x4,%esp
801074c0:	6a 10                	push   $0x10
801074c2:	6a 00                	push   $0x0
801074c4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801074c7:	50                   	push   %eax
801074c8:	e8 e3 f5 ff ff       	call   80106ab0 <memset>
801074cd:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801074d0:	8b 45 c8             	mov    -0x38(%ebp),%eax
801074d3:	6a 10                	push   $0x10
801074d5:	50                   	push   %eax
801074d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801074d9:	50                   	push   %eax
801074da:	ff 75 f4             	pushl  -0xc(%ebp)
801074dd:	e8 fe ab ff ff       	call   801020e0 <writei>
801074e2:	83 c4 10             	add    $0x10,%esp
801074e5:	83 f8 10             	cmp    $0x10,%eax
801074e8:	74 0d                	je     801074f7 <sys_unlink+0x151>
    panic("unlink: writei");
801074ea:	83 ec 0c             	sub    $0xc,%esp
801074ed:	68 03 ab 10 80       	push   $0x8010ab03
801074f2:	e8 6f 90 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801074f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074fa:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801074fe:	66 83 f8 01          	cmp    $0x1,%ax
80107502:	75 21                	jne    80107525 <sys_unlink+0x17f>
    dp->nlink--;
80107504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107507:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010750b:	83 e8 01             	sub    $0x1,%eax
8010750e:	89 c2                	mov    %eax,%edx
80107510:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107513:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80107517:	83 ec 0c             	sub    $0xc,%esp
8010751a:	ff 75 f4             	pushl  -0xc(%ebp)
8010751d:	e8 1f a3 ff ff       	call   80101841 <iupdate>
80107522:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80107525:	83 ec 0c             	sub    $0xc,%esp
80107528:	ff 75 f4             	pushl  -0xc(%ebp)
8010752b:	e8 ab a7 ff ff       	call   80101cdb <iunlockput>
80107530:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80107533:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107536:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010753a:	83 e8 01             	sub    $0x1,%eax
8010753d:	89 c2                	mov    %eax,%edx
8010753f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107542:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107546:	83 ec 0c             	sub    $0xc,%esp
80107549:	ff 75 f0             	pushl  -0x10(%ebp)
8010754c:	e8 f0 a2 ff ff       	call   80101841 <iupdate>
80107551:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107554:	83 ec 0c             	sub    $0xc,%esp
80107557:	ff 75 f0             	pushl  -0x10(%ebp)
8010755a:	e8 7c a7 ff ff       	call   80101cdb <iunlockput>
8010755f:	83 c4 10             	add    $0x10,%esp

  end_op();
80107562:	e8 23 c1 ff ff       	call   8010368a <end_op>

  return 0;
80107567:	b8 00 00 00 00       	mov    $0x0,%eax
8010756c:	eb 19                	jmp    80107587 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
8010756e:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
8010756f:	83 ec 0c             	sub    $0xc,%esp
80107572:	ff 75 f4             	pushl  -0xc(%ebp)
80107575:	e8 61 a7 ff ff       	call   80101cdb <iunlockput>
8010757a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010757d:	e8 08 c1 ff ff       	call   8010368a <end_op>
  return -1;
80107582:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107587:	c9                   	leave  
80107588:	c3                   	ret    

80107589 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80107589:	55                   	push   %ebp
8010758a:	89 e5                	mov    %esp,%ebp
8010758c:	83 ec 38             	sub    $0x38,%esp
8010758f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107592:	8b 55 10             	mov    0x10(%ebp),%edx
80107595:	8b 45 14             	mov    0x14(%ebp),%eax
80107598:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010759c:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801075a0:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801075a4:	83 ec 08             	sub    $0x8,%esp
801075a7:	8d 45 de             	lea    -0x22(%ebp),%eax
801075aa:	50                   	push   %eax
801075ab:	ff 75 08             	pushl  0x8(%ebp)
801075ae:	e8 42 b0 ff ff       	call   801025f5 <nameiparent>
801075b3:	83 c4 10             	add    $0x10,%esp
801075b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801075b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801075bd:	75 0a                	jne    801075c9 <create+0x40>
    return 0;
801075bf:	b8 00 00 00 00       	mov    $0x0,%eax
801075c4:	e9 90 01 00 00       	jmp    80107759 <create+0x1d0>
  ilock(dp);
801075c9:	83 ec 0c             	sub    $0xc,%esp
801075cc:	ff 75 f4             	pushl  -0xc(%ebp)
801075cf:	e8 47 a4 ff ff       	call   80101a1b <ilock>
801075d4:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801075d7:	83 ec 04             	sub    $0x4,%esp
801075da:	8d 45 ec             	lea    -0x14(%ebp),%eax
801075dd:	50                   	push   %eax
801075de:	8d 45 de             	lea    -0x22(%ebp),%eax
801075e1:	50                   	push   %eax
801075e2:	ff 75 f4             	pushl  -0xc(%ebp)
801075e5:	e8 99 ac ff ff       	call   80102283 <dirlookup>
801075ea:	83 c4 10             	add    $0x10,%esp
801075ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
801075f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801075f4:	74 50                	je     80107646 <create+0xbd>
    iunlockput(dp);
801075f6:	83 ec 0c             	sub    $0xc,%esp
801075f9:	ff 75 f4             	pushl  -0xc(%ebp)
801075fc:	e8 da a6 ff ff       	call   80101cdb <iunlockput>
80107601:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80107604:	83 ec 0c             	sub    $0xc,%esp
80107607:	ff 75 f0             	pushl  -0x10(%ebp)
8010760a:	e8 0c a4 ff ff       	call   80101a1b <ilock>
8010760f:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80107612:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80107617:	75 15                	jne    8010762e <create+0xa5>
80107619:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010761c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107620:	66 83 f8 02          	cmp    $0x2,%ax
80107624:	75 08                	jne    8010762e <create+0xa5>
      return ip;
80107626:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107629:	e9 2b 01 00 00       	jmp    80107759 <create+0x1d0>
    iunlockput(ip);
8010762e:	83 ec 0c             	sub    $0xc,%esp
80107631:	ff 75 f0             	pushl  -0x10(%ebp)
80107634:	e8 a2 a6 ff ff       	call   80101cdb <iunlockput>
80107639:	83 c4 10             	add    $0x10,%esp
    return 0;
8010763c:	b8 00 00 00 00       	mov    $0x0,%eax
80107641:	e9 13 01 00 00       	jmp    80107759 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80107646:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010764a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764d:	8b 00                	mov    (%eax),%eax
8010764f:	83 ec 08             	sub    $0x8,%esp
80107652:	52                   	push   %edx
80107653:	50                   	push   %eax
80107654:	e8 11 a1 ff ff       	call   8010176a <ialloc>
80107659:	83 c4 10             	add    $0x10,%esp
8010765c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010765f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107663:	75 0d                	jne    80107672 <create+0xe9>
    panic("create: ialloc");
80107665:	83 ec 0c             	sub    $0xc,%esp
80107668:	68 12 ab 10 80       	push   $0x8010ab12
8010766d:	e8 f4 8e ff ff       	call   80100566 <panic>

  ilock(ip);
80107672:	83 ec 0c             	sub    $0xc,%esp
80107675:	ff 75 f0             	pushl  -0x10(%ebp)
80107678:	e8 9e a3 ff ff       	call   80101a1b <ilock>
8010767d:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80107680:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107683:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80107687:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010768b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010768e:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80107692:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80107696:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107699:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010769f:	83 ec 0c             	sub    $0xc,%esp
801076a2:	ff 75 f0             	pushl  -0x10(%ebp)
801076a5:	e8 97 a1 ff ff       	call   80101841 <iupdate>
801076aa:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801076ad:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801076b2:	75 6a                	jne    8010771e <create+0x195>
    dp->nlink++;  // for ".."
801076b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b7:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801076bb:	83 c0 01             	add    $0x1,%eax
801076be:	89 c2                	mov    %eax,%edx
801076c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c3:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801076c7:	83 ec 0c             	sub    $0xc,%esp
801076ca:	ff 75 f4             	pushl  -0xc(%ebp)
801076cd:	e8 6f a1 ff ff       	call   80101841 <iupdate>
801076d2:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801076d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076d8:	8b 40 04             	mov    0x4(%eax),%eax
801076db:	83 ec 04             	sub    $0x4,%esp
801076de:	50                   	push   %eax
801076df:	68 ec aa 10 80       	push   $0x8010aaec
801076e4:	ff 75 f0             	pushl  -0x10(%ebp)
801076e7:	e8 51 ac ff ff       	call   8010233d <dirlink>
801076ec:	83 c4 10             	add    $0x10,%esp
801076ef:	85 c0                	test   %eax,%eax
801076f1:	78 1e                	js     80107711 <create+0x188>
801076f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f6:	8b 40 04             	mov    0x4(%eax),%eax
801076f9:	83 ec 04             	sub    $0x4,%esp
801076fc:	50                   	push   %eax
801076fd:	68 ee aa 10 80       	push   $0x8010aaee
80107702:	ff 75 f0             	pushl  -0x10(%ebp)
80107705:	e8 33 ac ff ff       	call   8010233d <dirlink>
8010770a:	83 c4 10             	add    $0x10,%esp
8010770d:	85 c0                	test   %eax,%eax
8010770f:	79 0d                	jns    8010771e <create+0x195>
      panic("create dots");
80107711:	83 ec 0c             	sub    $0xc,%esp
80107714:	68 21 ab 10 80       	push   $0x8010ab21
80107719:	e8 48 8e ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010771e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107721:	8b 40 04             	mov    0x4(%eax),%eax
80107724:	83 ec 04             	sub    $0x4,%esp
80107727:	50                   	push   %eax
80107728:	8d 45 de             	lea    -0x22(%ebp),%eax
8010772b:	50                   	push   %eax
8010772c:	ff 75 f4             	pushl  -0xc(%ebp)
8010772f:	e8 09 ac ff ff       	call   8010233d <dirlink>
80107734:	83 c4 10             	add    $0x10,%esp
80107737:	85 c0                	test   %eax,%eax
80107739:	79 0d                	jns    80107748 <create+0x1bf>
    panic("create: dirlink");
8010773b:	83 ec 0c             	sub    $0xc,%esp
8010773e:	68 2d ab 10 80       	push   $0x8010ab2d
80107743:	e8 1e 8e ff ff       	call   80100566 <panic>

  iunlockput(dp);
80107748:	83 ec 0c             	sub    $0xc,%esp
8010774b:	ff 75 f4             	pushl  -0xc(%ebp)
8010774e:	e8 88 a5 ff ff       	call   80101cdb <iunlockput>
80107753:	83 c4 10             	add    $0x10,%esp

  return ip;
80107756:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107759:	c9                   	leave  
8010775a:	c3                   	ret    

8010775b <sys_open>:

int
sys_open(void)
{
8010775b:	55                   	push   %ebp
8010775c:	89 e5                	mov    %esp,%ebp
8010775e:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107761:	83 ec 08             	sub    $0x8,%esp
80107764:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107767:	50                   	push   %eax
80107768:	6a 00                	push   $0x0
8010776a:	e8 eb f6 ff ff       	call   80106e5a <argstr>
8010776f:	83 c4 10             	add    $0x10,%esp
80107772:	85 c0                	test   %eax,%eax
80107774:	78 15                	js     8010778b <sys_open+0x30>
80107776:	83 ec 08             	sub    $0x8,%esp
80107779:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010777c:	50                   	push   %eax
8010777d:	6a 01                	push   $0x1
8010777f:	e8 51 f6 ff ff       	call   80106dd5 <argint>
80107784:	83 c4 10             	add    $0x10,%esp
80107787:	85 c0                	test   %eax,%eax
80107789:	79 0a                	jns    80107795 <sys_open+0x3a>
    return -1;
8010778b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107790:	e9 61 01 00 00       	jmp    801078f6 <sys_open+0x19b>

  begin_op();
80107795:	e8 64 be ff ff       	call   801035fe <begin_op>

  if(omode & O_CREATE){
8010779a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010779d:	25 00 02 00 00       	and    $0x200,%eax
801077a2:	85 c0                	test   %eax,%eax
801077a4:	74 2a                	je     801077d0 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801077a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801077a9:	6a 00                	push   $0x0
801077ab:	6a 00                	push   $0x0
801077ad:	6a 02                	push   $0x2
801077af:	50                   	push   %eax
801077b0:	e8 d4 fd ff ff       	call   80107589 <create>
801077b5:	83 c4 10             	add    $0x10,%esp
801077b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801077bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801077bf:	75 75                	jne    80107836 <sys_open+0xdb>
      end_op();
801077c1:	e8 c4 be ff ff       	call   8010368a <end_op>
      return -1;
801077c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077cb:	e9 26 01 00 00       	jmp    801078f6 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801077d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801077d3:	83 ec 0c             	sub    $0xc,%esp
801077d6:	50                   	push   %eax
801077d7:	e8 fd ad ff ff       	call   801025d9 <namei>
801077dc:	83 c4 10             	add    $0x10,%esp
801077df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801077e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801077e6:	75 0f                	jne    801077f7 <sys_open+0x9c>
      end_op();
801077e8:	e8 9d be ff ff       	call   8010368a <end_op>
      return -1;
801077ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077f2:	e9 ff 00 00 00       	jmp    801078f6 <sys_open+0x19b>
    }
    ilock(ip);
801077f7:	83 ec 0c             	sub    $0xc,%esp
801077fa:	ff 75 f4             	pushl  -0xc(%ebp)
801077fd:	e8 19 a2 ff ff       	call   80101a1b <ilock>
80107802:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80107805:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107808:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010780c:	66 83 f8 01          	cmp    $0x1,%ax
80107810:	75 24                	jne    80107836 <sys_open+0xdb>
80107812:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107815:	85 c0                	test   %eax,%eax
80107817:	74 1d                	je     80107836 <sys_open+0xdb>
      iunlockput(ip);
80107819:	83 ec 0c             	sub    $0xc,%esp
8010781c:	ff 75 f4             	pushl  -0xc(%ebp)
8010781f:	e8 b7 a4 ff ff       	call   80101cdb <iunlockput>
80107824:	83 c4 10             	add    $0x10,%esp
      end_op();
80107827:	e8 5e be ff ff       	call   8010368a <end_op>
      return -1;
8010782c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107831:	e9 c0 00 00 00       	jmp    801078f6 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80107836:	e8 09 98 ff ff       	call   80101044 <filealloc>
8010783b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010783e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107842:	74 17                	je     8010785b <sys_open+0x100>
80107844:	83 ec 0c             	sub    $0xc,%esp
80107847:	ff 75 f0             	pushl  -0x10(%ebp)
8010784a:	e8 37 f7 ff ff       	call   80106f86 <fdalloc>
8010784f:	83 c4 10             	add    $0x10,%esp
80107852:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107855:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107859:	79 2e                	jns    80107889 <sys_open+0x12e>
    if(f)
8010785b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010785f:	74 0e                	je     8010786f <sys_open+0x114>
      fileclose(f);
80107861:	83 ec 0c             	sub    $0xc,%esp
80107864:	ff 75 f0             	pushl  -0x10(%ebp)
80107867:	e8 96 98 ff ff       	call   80101102 <fileclose>
8010786c:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010786f:	83 ec 0c             	sub    $0xc,%esp
80107872:	ff 75 f4             	pushl  -0xc(%ebp)
80107875:	e8 61 a4 ff ff       	call   80101cdb <iunlockput>
8010787a:	83 c4 10             	add    $0x10,%esp
    end_op();
8010787d:	e8 08 be ff ff       	call   8010368a <end_op>
    return -1;
80107882:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107887:	eb 6d                	jmp    801078f6 <sys_open+0x19b>
  }
  iunlock(ip);
80107889:	83 ec 0c             	sub    $0xc,%esp
8010788c:	ff 75 f4             	pushl  -0xc(%ebp)
8010788f:	e8 e5 a2 ff ff       	call   80101b79 <iunlock>
80107894:	83 c4 10             	add    $0x10,%esp
  end_op();
80107897:	e8 ee bd ff ff       	call   8010368a <end_op>

  f->type = FD_INODE;
8010789c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010789f:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801078a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801078ab:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801078ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078b1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801078b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078bb:	83 e0 01             	and    $0x1,%eax
801078be:	85 c0                	test   %eax,%eax
801078c0:	0f 94 c0             	sete   %al
801078c3:	89 c2                	mov    %eax,%edx
801078c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078c8:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801078cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078ce:	83 e0 01             	and    $0x1,%eax
801078d1:	85 c0                	test   %eax,%eax
801078d3:	75 0a                	jne    801078df <sys_open+0x184>
801078d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078d8:	83 e0 02             	and    $0x2,%eax
801078db:	85 c0                	test   %eax,%eax
801078dd:	74 07                	je     801078e6 <sys_open+0x18b>
801078df:	b8 01 00 00 00       	mov    $0x1,%eax
801078e4:	eb 05                	jmp    801078eb <sys_open+0x190>
801078e6:	b8 00 00 00 00       	mov    $0x0,%eax
801078eb:	89 c2                	mov    %eax,%edx
801078ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078f0:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801078f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801078f6:	c9                   	leave  
801078f7:	c3                   	ret    

801078f8 <sys_mkdir>:

int
sys_mkdir(void)
{
801078f8:	55                   	push   %ebp
801078f9:	89 e5                	mov    %esp,%ebp
801078fb:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801078fe:	e8 fb bc ff ff       	call   801035fe <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80107903:	83 ec 08             	sub    $0x8,%esp
80107906:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107909:	50                   	push   %eax
8010790a:	6a 00                	push   $0x0
8010790c:	e8 49 f5 ff ff       	call   80106e5a <argstr>
80107911:	83 c4 10             	add    $0x10,%esp
80107914:	85 c0                	test   %eax,%eax
80107916:	78 1b                	js     80107933 <sys_mkdir+0x3b>
80107918:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010791b:	6a 00                	push   $0x0
8010791d:	6a 00                	push   $0x0
8010791f:	6a 01                	push   $0x1
80107921:	50                   	push   %eax
80107922:	e8 62 fc ff ff       	call   80107589 <create>
80107927:	83 c4 10             	add    $0x10,%esp
8010792a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010792d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107931:	75 0c                	jne    8010793f <sys_mkdir+0x47>
    end_op();
80107933:	e8 52 bd ff ff       	call   8010368a <end_op>
    return -1;
80107938:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010793d:	eb 18                	jmp    80107957 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010793f:	83 ec 0c             	sub    $0xc,%esp
80107942:	ff 75 f4             	pushl  -0xc(%ebp)
80107945:	e8 91 a3 ff ff       	call   80101cdb <iunlockput>
8010794a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010794d:	e8 38 bd ff ff       	call   8010368a <end_op>
  return 0;
80107952:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107957:	c9                   	leave  
80107958:	c3                   	ret    

80107959 <sys_mknod>:

int
sys_mknod(void)
{
80107959:	55                   	push   %ebp
8010795a:	89 e5                	mov    %esp,%ebp
8010795c:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010795f:	e8 9a bc ff ff       	call   801035fe <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107964:	83 ec 08             	sub    $0x8,%esp
80107967:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010796a:	50                   	push   %eax
8010796b:	6a 00                	push   $0x0
8010796d:	e8 e8 f4 ff ff       	call   80106e5a <argstr>
80107972:	83 c4 10             	add    $0x10,%esp
80107975:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107978:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010797c:	78 4f                	js     801079cd <sys_mknod+0x74>
     argint(1, &major) < 0 ||
8010797e:	83 ec 08             	sub    $0x8,%esp
80107981:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107984:	50                   	push   %eax
80107985:	6a 01                	push   $0x1
80107987:	e8 49 f4 ff ff       	call   80106dd5 <argint>
8010798c:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010798f:	85 c0                	test   %eax,%eax
80107991:	78 3a                	js     801079cd <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107993:	83 ec 08             	sub    $0x8,%esp
80107996:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107999:	50                   	push   %eax
8010799a:	6a 02                	push   $0x2
8010799c:	e8 34 f4 ff ff       	call   80106dd5 <argint>
801079a1:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801079a4:	85 c0                	test   %eax,%eax
801079a6:	78 25                	js     801079cd <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801079a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079ab:	0f bf c8             	movswl %ax,%ecx
801079ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
801079b1:	0f bf d0             	movswl %ax,%edx
801079b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801079b7:	51                   	push   %ecx
801079b8:	52                   	push   %edx
801079b9:	6a 03                	push   $0x3
801079bb:	50                   	push   %eax
801079bc:	e8 c8 fb ff ff       	call   80107589 <create>
801079c1:	83 c4 10             	add    $0x10,%esp
801079c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801079c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801079cb:	75 0c                	jne    801079d9 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801079cd:	e8 b8 bc ff ff       	call   8010368a <end_op>
    return -1;
801079d2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079d7:	eb 18                	jmp    801079f1 <sys_mknod+0x98>
  }
  iunlockput(ip);
801079d9:	83 ec 0c             	sub    $0xc,%esp
801079dc:	ff 75 f0             	pushl  -0x10(%ebp)
801079df:	e8 f7 a2 ff ff       	call   80101cdb <iunlockput>
801079e4:	83 c4 10             	add    $0x10,%esp
  end_op();
801079e7:	e8 9e bc ff ff       	call   8010368a <end_op>
  return 0;
801079ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079f1:	c9                   	leave  
801079f2:	c3                   	ret    

801079f3 <sys_chdir>:

int
sys_chdir(void)
{
801079f3:	55                   	push   %ebp
801079f4:	89 e5                	mov    %esp,%ebp
801079f6:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801079f9:	e8 00 bc ff ff       	call   801035fe <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801079fe:	83 ec 08             	sub    $0x8,%esp
80107a01:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a04:	50                   	push   %eax
80107a05:	6a 00                	push   $0x0
80107a07:	e8 4e f4 ff ff       	call   80106e5a <argstr>
80107a0c:	83 c4 10             	add    $0x10,%esp
80107a0f:	85 c0                	test   %eax,%eax
80107a11:	78 18                	js     80107a2b <sys_chdir+0x38>
80107a13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a16:	83 ec 0c             	sub    $0xc,%esp
80107a19:	50                   	push   %eax
80107a1a:	e8 ba ab ff ff       	call   801025d9 <namei>
80107a1f:	83 c4 10             	add    $0x10,%esp
80107a22:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a29:	75 0c                	jne    80107a37 <sys_chdir+0x44>
    end_op();
80107a2b:	e8 5a bc ff ff       	call   8010368a <end_op>
    return -1;
80107a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a35:	eb 6e                	jmp    80107aa5 <sys_chdir+0xb2>
  }
  ilock(ip);
80107a37:	83 ec 0c             	sub    $0xc,%esp
80107a3a:	ff 75 f4             	pushl  -0xc(%ebp)
80107a3d:	e8 d9 9f ff ff       	call   80101a1b <ilock>
80107a42:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a48:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107a4c:	66 83 f8 01          	cmp    $0x1,%ax
80107a50:	74 1a                	je     80107a6c <sys_chdir+0x79>
    iunlockput(ip);
80107a52:	83 ec 0c             	sub    $0xc,%esp
80107a55:	ff 75 f4             	pushl  -0xc(%ebp)
80107a58:	e8 7e a2 ff ff       	call   80101cdb <iunlockput>
80107a5d:	83 c4 10             	add    $0x10,%esp
    end_op();
80107a60:	e8 25 bc ff ff       	call   8010368a <end_op>
    return -1;
80107a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a6a:	eb 39                	jmp    80107aa5 <sys_chdir+0xb2>
  }
  iunlock(ip);
80107a6c:	83 ec 0c             	sub    $0xc,%esp
80107a6f:	ff 75 f4             	pushl  -0xc(%ebp)
80107a72:	e8 02 a1 ff ff       	call   80101b79 <iunlock>
80107a77:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107a7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a80:	8b 40 68             	mov    0x68(%eax),%eax
80107a83:	83 ec 0c             	sub    $0xc,%esp
80107a86:	50                   	push   %eax
80107a87:	e8 5f a1 ff ff       	call   80101beb <iput>
80107a8c:	83 c4 10             	add    $0x10,%esp
  end_op();
80107a8f:	e8 f6 bb ff ff       	call   8010368a <end_op>
  proc->cwd = ip;
80107a94:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107a9d:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107aa0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107aa5:	c9                   	leave  
80107aa6:	c3                   	ret    

80107aa7 <sys_exec>:

int
sys_exec(void)
{
80107aa7:	55                   	push   %ebp
80107aa8:	89 e5                	mov    %esp,%ebp
80107aaa:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107ab0:	83 ec 08             	sub    $0x8,%esp
80107ab3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107ab6:	50                   	push   %eax
80107ab7:	6a 00                	push   $0x0
80107ab9:	e8 9c f3 ff ff       	call   80106e5a <argstr>
80107abe:	83 c4 10             	add    $0x10,%esp
80107ac1:	85 c0                	test   %eax,%eax
80107ac3:	78 18                	js     80107add <sys_exec+0x36>
80107ac5:	83 ec 08             	sub    $0x8,%esp
80107ac8:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107ace:	50                   	push   %eax
80107acf:	6a 01                	push   $0x1
80107ad1:	e8 ff f2 ff ff       	call   80106dd5 <argint>
80107ad6:	83 c4 10             	add    $0x10,%esp
80107ad9:	85 c0                	test   %eax,%eax
80107adb:	79 0a                	jns    80107ae7 <sys_exec+0x40>
    return -1;
80107add:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ae2:	e9 c6 00 00 00       	jmp    80107bad <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80107ae7:	83 ec 04             	sub    $0x4,%esp
80107aea:	68 80 00 00 00       	push   $0x80
80107aef:	6a 00                	push   $0x0
80107af1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107af7:	50                   	push   %eax
80107af8:	e8 b3 ef ff ff       	call   80106ab0 <memset>
80107afd:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80107b00:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0a:	83 f8 1f             	cmp    $0x1f,%eax
80107b0d:	76 0a                	jbe    80107b19 <sys_exec+0x72>
      return -1;
80107b0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b14:	e9 94 00 00 00       	jmp    80107bad <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1c:	c1 e0 02             	shl    $0x2,%eax
80107b1f:	89 c2                	mov    %eax,%edx
80107b21:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107b27:	01 c2                	add    %eax,%edx
80107b29:	83 ec 08             	sub    $0x8,%esp
80107b2c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107b32:	50                   	push   %eax
80107b33:	52                   	push   %edx
80107b34:	e8 00 f2 ff ff       	call   80106d39 <fetchint>
80107b39:	83 c4 10             	add    $0x10,%esp
80107b3c:	85 c0                	test   %eax,%eax
80107b3e:	79 07                	jns    80107b47 <sys_exec+0xa0>
      return -1;
80107b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b45:	eb 66                	jmp    80107bad <sys_exec+0x106>
    if(uarg == 0){
80107b47:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107b4d:	85 c0                	test   %eax,%eax
80107b4f:	75 27                	jne    80107b78 <sys_exec+0xd1>
      argv[i] = 0;
80107b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b54:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107b5b:	00 00 00 00 
      break;
80107b5f:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b63:	83 ec 08             	sub    $0x8,%esp
80107b66:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107b6c:	52                   	push   %edx
80107b6d:	50                   	push   %eax
80107b6e:	e8 af 90 ff ff       	call   80100c22 <exec>
80107b73:	83 c4 10             	add    $0x10,%esp
80107b76:	eb 35                	jmp    80107bad <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107b78:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107b7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107b81:	c1 e2 02             	shl    $0x2,%edx
80107b84:	01 c2                	add    %eax,%edx
80107b86:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107b8c:	83 ec 08             	sub    $0x8,%esp
80107b8f:	52                   	push   %edx
80107b90:	50                   	push   %eax
80107b91:	e8 dd f1 ff ff       	call   80106d73 <fetchstr>
80107b96:	83 c4 10             	add    $0x10,%esp
80107b99:	85 c0                	test   %eax,%eax
80107b9b:	79 07                	jns    80107ba4 <sys_exec+0xfd>
      return -1;
80107b9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ba2:	eb 09                	jmp    80107bad <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107ba4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80107ba8:	e9 5a ff ff ff       	jmp    80107b07 <sys_exec+0x60>
  return exec(path, argv);
}
80107bad:	c9                   	leave  
80107bae:	c3                   	ret    

80107baf <sys_pipe>:

int
sys_pipe(void)
{
80107baf:	55                   	push   %ebp
80107bb0:	89 e5                	mov    %esp,%ebp
80107bb2:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107bb5:	83 ec 04             	sub    $0x4,%esp
80107bb8:	6a 08                	push   $0x8
80107bba:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107bbd:	50                   	push   %eax
80107bbe:	6a 00                	push   $0x0
80107bc0:	e8 38 f2 ff ff       	call   80106dfd <argptr>
80107bc5:	83 c4 10             	add    $0x10,%esp
80107bc8:	85 c0                	test   %eax,%eax
80107bca:	79 0a                	jns    80107bd6 <sys_pipe+0x27>
    return -1;
80107bcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bd1:	e9 af 00 00 00       	jmp    80107c85 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107bd6:	83 ec 08             	sub    $0x8,%esp
80107bd9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107bdc:	50                   	push   %eax
80107bdd:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107be0:	50                   	push   %eax
80107be1:	e8 0c c5 ff ff       	call   801040f2 <pipealloc>
80107be6:	83 c4 10             	add    $0x10,%esp
80107be9:	85 c0                	test   %eax,%eax
80107beb:	79 0a                	jns    80107bf7 <sys_pipe+0x48>
    return -1;
80107bed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bf2:	e9 8e 00 00 00       	jmp    80107c85 <sys_pipe+0xd6>
  fd0 = -1;
80107bf7:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107bfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c01:	83 ec 0c             	sub    $0xc,%esp
80107c04:	50                   	push   %eax
80107c05:	e8 7c f3 ff ff       	call   80106f86 <fdalloc>
80107c0a:	83 c4 10             	add    $0x10,%esp
80107c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c14:	78 18                	js     80107c2e <sys_pipe+0x7f>
80107c16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c19:	83 ec 0c             	sub    $0xc,%esp
80107c1c:	50                   	push   %eax
80107c1d:	e8 64 f3 ff ff       	call   80106f86 <fdalloc>
80107c22:	83 c4 10             	add    $0x10,%esp
80107c25:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c28:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c2c:	79 3f                	jns    80107c6d <sys_pipe+0xbe>
    if(fd0 >= 0)
80107c2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c32:	78 14                	js     80107c48 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107c34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c3d:	83 c2 08             	add    $0x8,%edx
80107c40:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107c47:	00 
    fileclose(rf);
80107c48:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c4b:	83 ec 0c             	sub    $0xc,%esp
80107c4e:	50                   	push   %eax
80107c4f:	e8 ae 94 ff ff       	call   80101102 <fileclose>
80107c54:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c5a:	83 ec 0c             	sub    $0xc,%esp
80107c5d:	50                   	push   %eax
80107c5e:	e8 9f 94 ff ff       	call   80101102 <fileclose>
80107c63:	83 c4 10             	add    $0x10,%esp
    return -1;
80107c66:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c6b:	eb 18                	jmp    80107c85 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107c6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c70:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c73:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107c75:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c78:	8d 50 04             	lea    0x4(%eax),%edx
80107c7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c7e:	89 02                	mov    %eax,(%edx)
  return 0;
80107c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c85:	c9                   	leave  
80107c86:	c3                   	ret    

80107c87 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107c87:	55                   	push   %ebp
80107c88:	89 e5                	mov    %esp,%ebp
80107c8a:	83 ec 08             	sub    $0x8,%esp
80107c8d:	8b 55 08             	mov    0x8(%ebp),%edx
80107c90:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c93:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107c97:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107c9b:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107c9f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107ca3:	66 ef                	out    %ax,(%dx)
}
80107ca5:	90                   	nop
80107ca6:	c9                   	leave  
80107ca7:	c3                   	ret    

80107ca8 <sys_fork>:
#include "uproc.h"
#endif

int
sys_fork(void)
{
80107ca8:	55                   	push   %ebp
80107ca9:	89 e5                	mov    %esp,%ebp
80107cab:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107cae:	e8 2f cd ff ff       	call   801049e2 <fork>
}
80107cb3:	c9                   	leave  
80107cb4:	c3                   	ret    

80107cb5 <sys_exit>:

int
sys_exit(void)
{
80107cb5:	55                   	push   %ebp
80107cb6:	89 e5                	mov    %esp,%ebp
80107cb8:	83 ec 08             	sub    $0x8,%esp
  exit();
80107cbb:	e8 ac cf ff ff       	call   80104c6c <exit>
  return 0;  // not reached
80107cc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107cc5:	c9                   	leave  
80107cc6:	c3                   	ret    

80107cc7 <sys_wait>:

int
sys_wait(void)
{
80107cc7:	55                   	push   %ebp
80107cc8:	89 e5                	mov    %esp,%ebp
80107cca:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107ccd:	e8 72 d2 ff ff       	call   80104f44 <wait>
}
80107cd2:	c9                   	leave  
80107cd3:	c3                   	ret    

80107cd4 <sys_kill>:

int
sys_kill(void)
{
80107cd4:	55                   	push   %ebp
80107cd5:	89 e5                	mov    %esp,%ebp
80107cd7:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107cda:	83 ec 08             	sub    $0x8,%esp
80107cdd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107ce0:	50                   	push   %eax
80107ce1:	6a 00                	push   $0x0
80107ce3:	e8 ed f0 ff ff       	call   80106dd5 <argint>
80107ce8:	83 c4 10             	add    $0x10,%esp
80107ceb:	85 c0                	test   %eax,%eax
80107ced:	79 07                	jns    80107cf6 <sys_kill+0x22>
    return -1;
80107cef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cf4:	eb 0f                	jmp    80107d05 <sys_kill+0x31>
  return kill(pid);
80107cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf9:	83 ec 0c             	sub    $0xc,%esp
80107cfc:	50                   	push   %eax
80107cfd:	e8 28 db ff ff       	call   8010582a <kill>
80107d02:	83 c4 10             	add    $0x10,%esp
}
80107d05:	c9                   	leave  
80107d06:	c3                   	ret    

80107d07 <sys_getpid>:

int
sys_getpid(void)
{
80107d07:	55                   	push   %ebp
80107d08:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107d0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d10:	8b 40 10             	mov    0x10(%eax),%eax
}
80107d13:	5d                   	pop    %ebp
80107d14:	c3                   	ret    

80107d15 <sys_sbrk>:

int
sys_sbrk(void)
{
80107d15:	55                   	push   %ebp
80107d16:	89 e5                	mov    %esp,%ebp
80107d18:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107d1b:	83 ec 08             	sub    $0x8,%esp
80107d1e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d21:	50                   	push   %eax
80107d22:	6a 00                	push   $0x0
80107d24:	e8 ac f0 ff ff       	call   80106dd5 <argint>
80107d29:	83 c4 10             	add    $0x10,%esp
80107d2c:	85 c0                	test   %eax,%eax
80107d2e:	79 07                	jns    80107d37 <sys_sbrk+0x22>
    return -1;
80107d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d35:	eb 28                	jmp    80107d5f <sys_sbrk+0x4a>
  addr = proc->sz;
80107d37:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d3d:	8b 00                	mov    (%eax),%eax
80107d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d45:	83 ec 0c             	sub    $0xc,%esp
80107d48:	50                   	push   %eax
80107d49:	e8 f1 cb ff ff       	call   8010493f <growproc>
80107d4e:	83 c4 10             	add    $0x10,%esp
80107d51:	85 c0                	test   %eax,%eax
80107d53:	79 07                	jns    80107d5c <sys_sbrk+0x47>
    return -1;
80107d55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d5a:	eb 03                	jmp    80107d5f <sys_sbrk+0x4a>
  return addr;
80107d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107d5f:	c9                   	leave  
80107d60:	c3                   	ret    

80107d61 <sys_sleep>:

int
sys_sleep(void)
{
80107d61:	55                   	push   %ebp
80107d62:	89 e5                	mov    %esp,%ebp
80107d64:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107d67:	83 ec 08             	sub    $0x8,%esp
80107d6a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d6d:	50                   	push   %eax
80107d6e:	6a 00                	push   $0x0
80107d70:	e8 60 f0 ff ff       	call   80106dd5 <argint>
80107d75:	83 c4 10             	add    $0x10,%esp
80107d78:	85 c0                	test   %eax,%eax
80107d7a:	79 07                	jns    80107d83 <sys_sleep+0x22>
    return -1;
80107d7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d81:	eb 44                	jmp    80107dc7 <sys_sleep+0x66>
  ticks0 = ticks;
80107d83:	a1 00 79 11 80       	mov    0x80117900,%eax
80107d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80107d8b:	eb 26                	jmp    80107db3 <sys_sleep+0x52>
    if(proc->killed){
80107d8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d93:	8b 40 24             	mov    0x24(%eax),%eax
80107d96:	85 c0                	test   %eax,%eax
80107d98:	74 07                	je     80107da1 <sys_sleep+0x40>
      return -1;
80107d9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d9f:	eb 26                	jmp    80107dc7 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107da1:	83 ec 08             	sub    $0x8,%esp
80107da4:	6a 00                	push   $0x0
80107da6:	68 00 79 11 80       	push   $0x80117900
80107dab:	e8 e8 d7 ff ff       	call   80105598 <sleep>
80107db0:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107db3:	a1 00 79 11 80       	mov    0x80117900,%eax
80107db8:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107dbb:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107dbe:	39 d0                	cmp    %edx,%eax
80107dc0:	72 cb                	jb     80107d8d <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107dc7:	c9                   	leave  
80107dc8:	c3                   	ret    

80107dc9 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80107dc9:	55                   	push   %ebp
80107dca:	89 e5                	mov    %esp,%ebp
80107dcc:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107dcf:	a1 00 79 11 80       	mov    0x80117900,%eax
80107dd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80107dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107dda:	c9                   	leave  
80107ddb:	c3                   	ret    

80107ddc <sys_halt>:

//Turn of the computer
int
sys_halt(void){
80107ddc:	55                   	push   %ebp
80107ddd:	89 e5                	mov    %esp,%ebp
80107ddf:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107de2:	83 ec 0c             	sub    $0xc,%esp
80107de5:	68 3d ab 10 80       	push   $0x8010ab3d
80107dea:	e8 d7 85 ff ff       	call   801003c6 <cprintf>
80107def:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
80107df2:	83 ec 08             	sub    $0x8,%esp
80107df5:	68 00 20 00 00       	push   $0x2000
80107dfa:	68 04 06 00 00       	push   $0x604
80107dff:	e8 83 fe ff ff       	call   80107c87 <outw>
80107e04:	83 c4 10             	add    $0x10,%esp
  return 0;
80107e07:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e0c:	c9                   	leave  
80107e0d:	c3                   	ret    

80107e0e <sys_date>:

#ifdef CS333_P1
int
sys_date(void) {
80107e0e:	55                   	push   %ebp
80107e0f:	89 e5                	mov    %esp,%ebp
80107e11:	83 ec 18             	sub    $0x18,%esp
    struct rtcdate *d;
    if (argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0) {
80107e14:	83 ec 04             	sub    $0x4,%esp
80107e17:	6a 18                	push   $0x18
80107e19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107e1c:	50                   	push   %eax
80107e1d:	6a 00                	push   $0x0
80107e1f:	e8 d9 ef ff ff       	call   80106dfd <argptr>
80107e24:	83 c4 10             	add    $0x10,%esp
80107e27:	85 c0                	test   %eax,%eax
80107e29:	79 07                	jns    80107e32 <sys_date+0x24>
        return -1;
80107e2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e30:	eb 14                	jmp    80107e46 <sys_date+0x38>
    } else {
        cmostime(d);
80107e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e35:	83 ec 0c             	sub    $0xc,%esp
80107e38:	50                   	push   %eax
80107e39:	e8 3b b4 ff ff       	call   80103279 <cmostime>
80107e3e:	83 c4 10             	add    $0x10,%esp
        return 0;
80107e41:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
80107e46:	c9                   	leave  
80107e47:	c3                   	ret    

80107e48 <sys_getuid>:

#ifdef CS333_P2

// return process UID
int
sys_getuid(void) {
80107e48:	55                   	push   %ebp
80107e49:	89 e5                	mov    %esp,%ebp
    return proc->uid;
80107e4b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e51:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80107e57:	5d                   	pop    %ebp
80107e58:	c3                   	ret    

80107e59 <sys_getgid>:

// return process GID
int
sys_getgid(void) {
80107e59:	55                   	push   %ebp
80107e5a:	89 e5                	mov    %esp,%ebp
    return proc->gid;
80107e5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e62:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80107e68:	5d                   	pop    %ebp
80107e69:	c3                   	ret    

80107e6a <sys_getppid>:

// return process parent's PID
int
sys_getppid(void) {
80107e6a:	55                   	push   %ebp
80107e6b:	89 e5                	mov    %esp,%ebp
    return proc->parent->pid;
80107e6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e73:	8b 40 14             	mov    0x14(%eax),%eax
80107e76:	8b 40 10             	mov    0x10(%eax),%eax
}
80107e79:	5d                   	pop    %ebp
80107e7a:	c3                   	ret    

80107e7b <sys_setuid>:

// pull argument from stack, check range, set process UID
int
sys_setuid(void) {
80107e7b:	55                   	push   %ebp
80107e7c:	89 e5                	mov    %esp,%ebp
80107e7e:	83 ec 18             	sub    $0x18,%esp
    int n;
    if (argint(0, &n) < 0) {
80107e81:	83 ec 08             	sub    $0x8,%esp
80107e84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107e87:	50                   	push   %eax
80107e88:	6a 00                	push   $0x0
80107e8a:	e8 46 ef ff ff       	call   80106dd5 <argint>
80107e8f:	83 c4 10             	add    $0x10,%esp
80107e92:	85 c0                	test   %eax,%eax
80107e94:	79 07                	jns    80107e9d <sys_setuid+0x22>
        return -1;
80107e96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e9b:	eb 2c                	jmp    80107ec9 <sys_setuid+0x4e>
    }
    if (n < 0 || n > 32767) {
80107e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea0:	85 c0                	test   %eax,%eax
80107ea2:	78 0a                	js     80107eae <sys_setuid+0x33>
80107ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea7:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107eac:	7e 07                	jle    80107eb5 <sys_setuid+0x3a>
        return -1;
80107eae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107eb3:	eb 14                	jmp    80107ec9 <sys_setuid+0x4e>
    }
    proc->uid = n;
80107eb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ebb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107ebe:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    return 0;
80107ec4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ec9:	c9                   	leave  
80107eca:	c3                   	ret    

80107ecb <sys_setgid>:

// pull argument from stack, check range, set process PID
int
sys_setgid(void) {
80107ecb:	55                   	push   %ebp
80107ecc:	89 e5                	mov    %esp,%ebp
80107ece:	83 ec 18             	sub    $0x18,%esp
    int n;
    if (argint(0, &n) < 0) {
80107ed1:	83 ec 08             	sub    $0x8,%esp
80107ed4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107ed7:	50                   	push   %eax
80107ed8:	6a 00                	push   $0x0
80107eda:	e8 f6 ee ff ff       	call   80106dd5 <argint>
80107edf:	83 c4 10             	add    $0x10,%esp
80107ee2:	85 c0                	test   %eax,%eax
80107ee4:	79 07                	jns    80107eed <sys_setgid+0x22>
        return -1;
80107ee6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107eeb:	eb 2c                	jmp    80107f19 <sys_setgid+0x4e>
    }
    if (n < 0 || n > 32767) {
80107eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef0:	85 c0                	test   %eax,%eax
80107ef2:	78 0a                	js     80107efe <sys_setgid+0x33>
80107ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef7:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107efc:	7e 07                	jle    80107f05 <sys_setgid+0x3a>
        return -1;
80107efe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f03:	eb 14                	jmp    80107f19 <sys_setgid+0x4e>
    }
    proc->gid = n;
80107f05:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107f0e:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    return 0;
80107f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f19:	c9                   	leave  
80107f1a:	c3                   	ret    

80107f1b <sys_getprocs>:

// pull arguments from stack, pass to proc.c getprocs(uint, struct)
int
sys_getprocs(void) {
80107f1b:	55                   	push   %ebp
80107f1c:	89 e5                	mov    %esp,%ebp
80107f1e:	83 ec 18             	sub    $0x18,%esp
    int m;
    struct uproc *u;
    if (argint(0, &m) < 0) {
80107f21:	83 ec 08             	sub    $0x8,%esp
80107f24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f27:	50                   	push   %eax
80107f28:	6a 00                	push   $0x0
80107f2a:	e8 a6 ee ff ff       	call   80106dd5 <argint>
80107f2f:	83 c4 10             	add    $0x10,%esp
80107f32:	85 c0                	test   %eax,%eax
80107f34:	79 07                	jns    80107f3d <sys_getprocs+0x22>
        return -1;
80107f36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f3b:	eb 3e                	jmp    80107f7b <sys_getprocs+0x60>
    }
    // sizeof * MAX
    if (argptr(1, (void*)&u, (sizeof(struct uproc) * m)) < 0) {
80107f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f40:	89 c2                	mov    %eax,%edx
80107f42:	89 d0                	mov    %edx,%eax
80107f44:	01 c0                	add    %eax,%eax
80107f46:	01 d0                	add    %edx,%eax
80107f48:	c1 e0 05             	shl    $0x5,%eax
80107f4b:	83 ec 04             	sub    $0x4,%esp
80107f4e:	50                   	push   %eax
80107f4f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107f52:	50                   	push   %eax
80107f53:	6a 01                	push   $0x1
80107f55:	e8 a3 ee ff ff       	call   80106dfd <argptr>
80107f5a:	83 c4 10             	add    $0x10,%esp
80107f5d:	85 c0                	test   %eax,%eax
80107f5f:	79 07                	jns    80107f68 <sys_getprocs+0x4d>
        return -1;
80107f61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f66:	eb 13                	jmp    80107f7b <sys_getprocs+0x60>
    }
    return getprocs(m, u);
80107f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107f6e:	83 ec 08             	sub    $0x8,%esp
80107f71:	50                   	push   %eax
80107f72:	52                   	push   %edx
80107f73:	e8 d4 dd ff ff       	call   80105d4c <getprocs>
80107f78:	83 c4 10             	add    $0x10,%esp
}
80107f7b:	c9                   	leave  
80107f7c:	c3                   	ret    

80107f7d <sys_setpriority>:
#endif

#ifdef CS333_P3P4
int
sys_setpriority(void) {
80107f7d:	55                   	push   %ebp
80107f7e:	89 e5                	mov    %esp,%ebp
80107f80:	83 ec 18             	sub    $0x18,%esp
    int n, m;
    // PID argument from stack
    if (argint(0, &n) < 0) {
80107f83:	83 ec 08             	sub    $0x8,%esp
80107f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f89:	50                   	push   %eax
80107f8a:	6a 00                	push   $0x0
80107f8c:	e8 44 ee ff ff       	call   80106dd5 <argint>
80107f91:	83 c4 10             	add    $0x10,%esp
80107f94:	85 c0                	test   %eax,%eax
80107f96:	79 07                	jns    80107f9f <sys_setpriority+0x22>
        return -1;
80107f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f9d:	eb 5d                	jmp    80107ffc <sys_setpriority+0x7f>
    }
    // priority argument
    if (argint(1, &m) < 0) {
80107f9f:	83 ec 08             	sub    $0x8,%esp
80107fa2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107fa5:	50                   	push   %eax
80107fa6:	6a 01                	push   $0x1
80107fa8:	e8 28 ee ff ff       	call   80106dd5 <argint>
80107fad:	83 c4 10             	add    $0x10,%esp
80107fb0:	85 c0                	test   %eax,%eax
80107fb2:	79 07                	jns    80107fbb <sys_setpriority+0x3e>
        return -1;
80107fb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fb9:	eb 41                	jmp    80107ffc <sys_setpriority+0x7f>
    }
    // check bounds of PID argument
    if (n < 0 || n > 32767) {
80107fbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbe:	85 c0                	test   %eax,%eax
80107fc0:	78 0a                	js     80107fcc <sys_setpriority+0x4f>
80107fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc5:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107fca:	7e 07                	jle    80107fd3 <sys_setpriority+0x56>
        return -1;
80107fcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fd1:	eb 29                	jmp    80107ffc <sys_setpriority+0x7f>
    }
    // check bounds of priority argument
    if (m < 0 || m > MAX) {
80107fd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fd6:	85 c0                	test   %eax,%eax
80107fd8:	78 08                	js     80107fe2 <sys_setpriority+0x65>
80107fda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fdd:	83 f8 07             	cmp    $0x7,%eax
80107fe0:	7e 07                	jle    80107fe9 <sys_setpriority+0x6c>
        return -1;
80107fe2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fe7:	eb 13                	jmp    80107ffc <sys_setpriority+0x7f>
    }
    return setpriority(n, m); // pass to user-side
80107fe9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fef:	83 ec 08             	sub    $0x8,%esp
80107ff2:	52                   	push   %edx
80107ff3:	50                   	push   %eax
80107ff4:	e8 01 e6 ff ff       	call   801065fa <setpriority>
80107ff9:	83 c4 10             	add    $0x10,%esp
}
80107ffc:	c9                   	leave  
80107ffd:	c3                   	ret    

80107ffe <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107ffe:	55                   	push   %ebp
80107fff:	89 e5                	mov    %esp,%ebp
80108001:	83 ec 08             	sub    $0x8,%esp
80108004:	8b 55 08             	mov    0x8(%ebp),%edx
80108007:	8b 45 0c             	mov    0xc(%ebp),%eax
8010800a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010800e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108011:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108015:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108019:	ee                   	out    %al,(%dx)
}
8010801a:	90                   	nop
8010801b:	c9                   	leave  
8010801c:	c3                   	ret    

8010801d <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010801d:	55                   	push   %ebp
8010801e:	89 e5                	mov    %esp,%ebp
80108020:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80108023:	6a 34                	push   $0x34
80108025:	6a 43                	push   $0x43
80108027:	e8 d2 ff ff ff       	call   80107ffe <outb>
8010802c:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
8010802f:	68 a9 00 00 00       	push   $0xa9
80108034:	6a 40                	push   $0x40
80108036:	e8 c3 ff ff ff       	call   80107ffe <outb>
8010803b:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
8010803e:	6a 04                	push   $0x4
80108040:	6a 40                	push   $0x40
80108042:	e8 b7 ff ff ff       	call   80107ffe <outb>
80108047:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
8010804a:	83 ec 0c             	sub    $0xc,%esp
8010804d:	6a 00                	push   $0x0
8010804f:	e8 88 bf ff ff       	call   80103fdc <picenable>
80108054:	83 c4 10             	add    $0x10,%esp
}
80108057:	90                   	nop
80108058:	c9                   	leave  
80108059:	c3                   	ret    

8010805a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010805a:	1e                   	push   %ds
  pushl %es
8010805b:	06                   	push   %es
  pushl %fs
8010805c:	0f a0                	push   %fs
  pushl %gs
8010805e:	0f a8                	push   %gs
  pushal
80108060:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80108061:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80108065:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80108067:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80108069:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010806d:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
8010806f:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80108071:	54                   	push   %esp
  call trap
80108072:	e8 ce 01 00 00       	call   80108245 <trap>
  addl $4, %esp
80108077:	83 c4 04             	add    $0x4,%esp

8010807a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010807a:	61                   	popa   
  popl %gs
8010807b:	0f a9                	pop    %gs
  popl %fs
8010807d:	0f a1                	pop    %fs
  popl %es
8010807f:	07                   	pop    %es
  popl %ds
80108080:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80108081:	83 c4 08             	add    $0x8,%esp
  iret
80108084:	cf                   	iret   

80108085 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80108085:	55                   	push   %ebp
80108086:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80108088:	8b 45 08             	mov    0x8(%ebp),%eax
8010808b:	f0 ff 00             	lock incl (%eax)
}
8010808e:	90                   	nop
8010808f:	5d                   	pop    %ebp
80108090:	c3                   	ret    

80108091 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80108091:	55                   	push   %ebp
80108092:	89 e5                	mov    %esp,%ebp
80108094:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108097:	8b 45 0c             	mov    0xc(%ebp),%eax
8010809a:	83 e8 01             	sub    $0x1,%eax
8010809d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801080a1:	8b 45 08             	mov    0x8(%ebp),%eax
801080a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801080a8:	8b 45 08             	mov    0x8(%ebp),%eax
801080ab:	c1 e8 10             	shr    $0x10,%eax
801080ae:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801080b2:	8d 45 fa             	lea    -0x6(%ebp),%eax
801080b5:	0f 01 18             	lidtl  (%eax)
}
801080b8:	90                   	nop
801080b9:	c9                   	leave  
801080ba:	c3                   	ret    

801080bb <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801080bb:	55                   	push   %ebp
801080bc:	89 e5                	mov    %esp,%ebp
801080be:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801080c1:	0f 20 d0             	mov    %cr2,%eax
801080c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801080c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801080ca:	c9                   	leave  
801080cb:	c3                   	ret    

801080cc <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
801080cc:	55                   	push   %ebp
801080cd:	89 e5                	mov    %esp,%ebp
801080cf:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
801080d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801080d9:	e9 c3 00 00 00       	jmp    801081a1 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801080de:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080e1:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
801080e8:	89 c2                	mov    %eax,%edx
801080ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080ed:	66 89 14 c5 00 71 11 	mov    %dx,-0x7fee8f00(,%eax,8)
801080f4:	80 
801080f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080f8:	66 c7 04 c5 02 71 11 	movw   $0x8,-0x7fee8efe(,%eax,8)
801080ff:	80 08 00 
80108102:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108105:	0f b6 14 c5 04 71 11 	movzbl -0x7fee8efc(,%eax,8),%edx
8010810c:	80 
8010810d:	83 e2 e0             	and    $0xffffffe0,%edx
80108110:	88 14 c5 04 71 11 80 	mov    %dl,-0x7fee8efc(,%eax,8)
80108117:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010811a:	0f b6 14 c5 04 71 11 	movzbl -0x7fee8efc(,%eax,8),%edx
80108121:	80 
80108122:	83 e2 1f             	and    $0x1f,%edx
80108125:	88 14 c5 04 71 11 80 	mov    %dl,-0x7fee8efc(,%eax,8)
8010812c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010812f:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80108136:	80 
80108137:	83 e2 f0             	and    $0xfffffff0,%edx
8010813a:	83 ca 0e             	or     $0xe,%edx
8010813d:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80108144:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108147:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
8010814e:	80 
8010814f:	83 e2 ef             	and    $0xffffffef,%edx
80108152:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80108159:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010815c:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80108163:	80 
80108164:	83 e2 9f             	and    $0xffffff9f,%edx
80108167:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
8010816e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108171:	0f b6 14 c5 05 71 11 	movzbl -0x7fee8efb(,%eax,8),%edx
80108178:	80 
80108179:	83 ca 80             	or     $0xffffff80,%edx
8010817c:	88 14 c5 05 71 11 80 	mov    %dl,-0x7fee8efb(,%eax,8)
80108183:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108186:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
8010818d:	c1 e8 10             	shr    $0x10,%eax
80108190:	89 c2                	mov    %eax,%edx
80108192:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108195:	66 89 14 c5 06 71 11 	mov    %dx,-0x7fee8efa(,%eax,8)
8010819c:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010819d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801081a1:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
801081a8:	0f 8e 30 ff ff ff    	jle    801080de <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801081ae:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
801081b3:	66 a3 00 73 11 80    	mov    %ax,0x80117300
801081b9:	66 c7 05 02 73 11 80 	movw   $0x8,0x80117302
801081c0:	08 00 
801081c2:	0f b6 05 04 73 11 80 	movzbl 0x80117304,%eax
801081c9:	83 e0 e0             	and    $0xffffffe0,%eax
801081cc:	a2 04 73 11 80       	mov    %al,0x80117304
801081d1:	0f b6 05 04 73 11 80 	movzbl 0x80117304,%eax
801081d8:	83 e0 1f             	and    $0x1f,%eax
801081db:	a2 04 73 11 80       	mov    %al,0x80117304
801081e0:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
801081e7:	83 c8 0f             	or     $0xf,%eax
801081ea:	a2 05 73 11 80       	mov    %al,0x80117305
801081ef:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
801081f6:	83 e0 ef             	and    $0xffffffef,%eax
801081f9:	a2 05 73 11 80       	mov    %al,0x80117305
801081fe:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80108205:	83 c8 60             	or     $0x60,%eax
80108208:	a2 05 73 11 80       	mov    %al,0x80117305
8010820d:	0f b6 05 05 73 11 80 	movzbl 0x80117305,%eax
80108214:	83 c8 80             	or     $0xffffff80,%eax
80108217:	a2 05 73 11 80       	mov    %al,0x80117305
8010821c:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
80108221:	c1 e8 10             	shr    $0x10,%eax
80108224:	66 a3 06 73 11 80    	mov    %ax,0x80117306
  
}
8010822a:	90                   	nop
8010822b:	c9                   	leave  
8010822c:	c3                   	ret    

8010822d <idtinit>:

void
idtinit(void)
{
8010822d:	55                   	push   %ebp
8010822e:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80108230:	68 00 08 00 00       	push   $0x800
80108235:	68 00 71 11 80       	push   $0x80117100
8010823a:	e8 52 fe ff ff       	call   80108091 <lidt>
8010823f:	83 c4 08             	add    $0x8,%esp
}
80108242:	90                   	nop
80108243:	c9                   	leave  
80108244:	c3                   	ret    

80108245 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80108245:	55                   	push   %ebp
80108246:	89 e5                	mov    %esp,%ebp
80108248:	57                   	push   %edi
80108249:	56                   	push   %esi
8010824a:	53                   	push   %ebx
8010824b:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010824e:	8b 45 08             	mov    0x8(%ebp),%eax
80108251:	8b 40 30             	mov    0x30(%eax),%eax
80108254:	83 f8 40             	cmp    $0x40,%eax
80108257:	75 3e                	jne    80108297 <trap+0x52>
    if(proc->killed)
80108259:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010825f:	8b 40 24             	mov    0x24(%eax),%eax
80108262:	85 c0                	test   %eax,%eax
80108264:	74 05                	je     8010826b <trap+0x26>
      exit();
80108266:	e8 01 ca ff ff       	call   80104c6c <exit>
    proc->tf = tf;
8010826b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108271:	8b 55 08             	mov    0x8(%ebp),%edx
80108274:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80108277:	e8 0f ec ff ff       	call   80106e8b <syscall>
    if(proc->killed)
8010827c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108282:	8b 40 24             	mov    0x24(%eax),%eax
80108285:	85 c0                	test   %eax,%eax
80108287:	0f 84 21 02 00 00    	je     801084ae <trap+0x269>
      exit();
8010828d:	e8 da c9 ff ff       	call   80104c6c <exit>
    return;
80108292:	e9 17 02 00 00       	jmp    801084ae <trap+0x269>
  }

  switch(tf->trapno){
80108297:	8b 45 08             	mov    0x8(%ebp),%eax
8010829a:	8b 40 30             	mov    0x30(%eax),%eax
8010829d:	83 e8 20             	sub    $0x20,%eax
801082a0:	83 f8 1f             	cmp    $0x1f,%eax
801082a3:	0f 87 a3 00 00 00    	ja     8010834c <trap+0x107>
801082a9:	8b 04 85 f0 ab 10 80 	mov    -0x7fef5410(,%eax,4),%eax
801082b0:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
801082b2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801082b8:	0f b6 00             	movzbl (%eax),%eax
801082bb:	84 c0                	test   %al,%al
801082bd:	75 20                	jne    801082df <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
801082bf:	83 ec 0c             	sub    $0xc,%esp
801082c2:	68 00 79 11 80       	push   $0x80117900
801082c7:	e8 b9 fd ff ff       	call   80108085 <atom_inc>
801082cc:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
801082cf:	83 ec 0c             	sub    $0xc,%esp
801082d2:	68 00 79 11 80       	push   $0x80117900
801082d7:	e8 17 d5 ff ff       	call   801057f3 <wakeup>
801082dc:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801082df:	e8 f2 ad ff ff       	call   801030d6 <lapiceoi>
    break;
801082e4:	e9 1c 01 00 00       	jmp    80108405 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801082e9:	e8 fb a5 ff ff       	call   801028e9 <ideintr>
    lapiceoi();
801082ee:	e8 e3 ad ff ff       	call   801030d6 <lapiceoi>
    break;
801082f3:	e9 0d 01 00 00       	jmp    80108405 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801082f8:	e8 db ab ff ff       	call   80102ed8 <kbdintr>
    lapiceoi();
801082fd:	e8 d4 ad ff ff       	call   801030d6 <lapiceoi>
    break;
80108302:	e9 fe 00 00 00       	jmp    80108405 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80108307:	e8 83 03 00 00       	call   8010868f <uartintr>
    lapiceoi();
8010830c:	e8 c5 ad ff ff       	call   801030d6 <lapiceoi>
    break;
80108311:	e9 ef 00 00 00       	jmp    80108405 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108316:	8b 45 08             	mov    0x8(%ebp),%eax
80108319:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010831c:	8b 45 08             	mov    0x8(%ebp),%eax
8010831f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108323:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80108326:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010832c:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010832f:	0f b6 c0             	movzbl %al,%eax
80108332:	51                   	push   %ecx
80108333:	52                   	push   %edx
80108334:	50                   	push   %eax
80108335:	68 50 ab 10 80       	push   $0x8010ab50
8010833a:	e8 87 80 ff ff       	call   801003c6 <cprintf>
8010833f:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80108342:	e8 8f ad ff ff       	call   801030d6 <lapiceoi>
    break;
80108347:	e9 b9 00 00 00       	jmp    80108405 <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010834c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108352:	85 c0                	test   %eax,%eax
80108354:	74 11                	je     80108367 <trap+0x122>
80108356:	8b 45 08             	mov    0x8(%ebp),%eax
80108359:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010835d:	0f b7 c0             	movzwl %ax,%eax
80108360:	83 e0 03             	and    $0x3,%eax
80108363:	85 c0                	test   %eax,%eax
80108365:	75 40                	jne    801083a7 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80108367:	e8 4f fd ff ff       	call   801080bb <rcr2>
8010836c:	89 c3                	mov    %eax,%ebx
8010836e:	8b 45 08             	mov    0x8(%ebp),%eax
80108371:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80108374:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010837a:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010837d:	0f b6 d0             	movzbl %al,%edx
80108380:	8b 45 08             	mov    0x8(%ebp),%eax
80108383:	8b 40 30             	mov    0x30(%eax),%eax
80108386:	83 ec 0c             	sub    $0xc,%esp
80108389:	53                   	push   %ebx
8010838a:	51                   	push   %ecx
8010838b:	52                   	push   %edx
8010838c:	50                   	push   %eax
8010838d:	68 74 ab 10 80       	push   $0x8010ab74
80108392:	e8 2f 80 ff ff       	call   801003c6 <cprintf>
80108397:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010839a:	83 ec 0c             	sub    $0xc,%esp
8010839d:	68 a6 ab 10 80       	push   $0x8010aba6
801083a2:	e8 bf 81 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801083a7:	e8 0f fd ff ff       	call   801080bb <rcr2>
801083ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801083af:	8b 45 08             	mov    0x8(%ebp),%eax
801083b2:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801083b5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083bb:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801083be:	0f b6 d8             	movzbl %al,%ebx
801083c1:	8b 45 08             	mov    0x8(%ebp),%eax
801083c4:	8b 48 34             	mov    0x34(%eax),%ecx
801083c7:	8b 45 08             	mov    0x8(%ebp),%eax
801083ca:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801083cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083d3:	8d 78 6c             	lea    0x6c(%eax),%edi
801083d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801083dc:	8b 40 10             	mov    0x10(%eax),%eax
801083df:	ff 75 e4             	pushl  -0x1c(%ebp)
801083e2:	56                   	push   %esi
801083e3:	53                   	push   %ebx
801083e4:	51                   	push   %ecx
801083e5:	52                   	push   %edx
801083e6:	57                   	push   %edi
801083e7:	50                   	push   %eax
801083e8:	68 ac ab 10 80       	push   $0x8010abac
801083ed:	e8 d4 7f ff ff       	call   801003c6 <cprintf>
801083f2:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801083f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083fb:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80108402:	eb 01                	jmp    80108405 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80108404:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80108405:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010840b:	85 c0                	test   %eax,%eax
8010840d:	74 24                	je     80108433 <trap+0x1ee>
8010840f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108415:	8b 40 24             	mov    0x24(%eax),%eax
80108418:	85 c0                	test   %eax,%eax
8010841a:	74 17                	je     80108433 <trap+0x1ee>
8010841c:	8b 45 08             	mov    0x8(%ebp),%eax
8010841f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108423:	0f b7 c0             	movzwl %ax,%eax
80108426:	83 e0 03             	and    $0x3,%eax
80108429:	83 f8 03             	cmp    $0x3,%eax
8010842c:	75 05                	jne    80108433 <trap+0x1ee>
    exit();
8010842e:	e8 39 c8 ff ff       	call   80104c6c <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80108433:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108439:	85 c0                	test   %eax,%eax
8010843b:	74 41                	je     8010847e <trap+0x239>
8010843d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108443:	8b 40 0c             	mov    0xc(%eax),%eax
80108446:	83 f8 04             	cmp    $0x4,%eax
80108449:	75 33                	jne    8010847e <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
8010844b:	8b 45 08             	mov    0x8(%ebp),%eax
8010844e:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80108451:	83 f8 20             	cmp    $0x20,%eax
80108454:	75 28                	jne    8010847e <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80108456:	8b 0d 00 79 11 80    	mov    0x80117900,%ecx
8010845c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80108461:	89 c8                	mov    %ecx,%eax
80108463:	f7 e2                	mul    %edx
80108465:	c1 ea 03             	shr    $0x3,%edx
80108468:	89 d0                	mov    %edx,%eax
8010846a:	c1 e0 02             	shl    $0x2,%eax
8010846d:	01 d0                	add    %edx,%eax
8010846f:	01 c0                	add    %eax,%eax
80108471:	29 c1                	sub    %eax,%ecx
80108473:	89 ca                	mov    %ecx,%edx
80108475:	85 d2                	test   %edx,%edx
80108477:	75 05                	jne    8010847e <trap+0x239>
    yield();
80108479:	e8 96 cf ff ff       	call   80105414 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010847e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108484:	85 c0                	test   %eax,%eax
80108486:	74 27                	je     801084af <trap+0x26a>
80108488:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010848e:	8b 40 24             	mov    0x24(%eax),%eax
80108491:	85 c0                	test   %eax,%eax
80108493:	74 1a                	je     801084af <trap+0x26a>
80108495:	8b 45 08             	mov    0x8(%ebp),%eax
80108498:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010849c:	0f b7 c0             	movzwl %ax,%eax
8010849f:	83 e0 03             	and    $0x3,%eax
801084a2:	83 f8 03             	cmp    $0x3,%eax
801084a5:	75 08                	jne    801084af <trap+0x26a>
    exit();
801084a7:	e8 c0 c7 ff ff       	call   80104c6c <exit>
801084ac:	eb 01                	jmp    801084af <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801084ae:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801084af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084b2:	5b                   	pop    %ebx
801084b3:	5e                   	pop    %esi
801084b4:	5f                   	pop    %edi
801084b5:	5d                   	pop    %ebp
801084b6:	c3                   	ret    

801084b7 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801084b7:	55                   	push   %ebp
801084b8:	89 e5                	mov    %esp,%ebp
801084ba:	83 ec 14             	sub    $0x14,%esp
801084bd:	8b 45 08             	mov    0x8(%ebp),%eax
801084c0:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801084c4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801084c8:	89 c2                	mov    %eax,%edx
801084ca:	ec                   	in     (%dx),%al
801084cb:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801084ce:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801084d2:	c9                   	leave  
801084d3:	c3                   	ret    

801084d4 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801084d4:	55                   	push   %ebp
801084d5:	89 e5                	mov    %esp,%ebp
801084d7:	83 ec 08             	sub    $0x8,%esp
801084da:	8b 55 08             	mov    0x8(%ebp),%edx
801084dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801084e0:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801084e4:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801084e7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801084eb:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801084ef:	ee                   	out    %al,(%dx)
}
801084f0:	90                   	nop
801084f1:	c9                   	leave  
801084f2:	c3                   	ret    

801084f3 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801084f3:	55                   	push   %ebp
801084f4:	89 e5                	mov    %esp,%ebp
801084f6:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801084f9:	6a 00                	push   $0x0
801084fb:	68 fa 03 00 00       	push   $0x3fa
80108500:	e8 cf ff ff ff       	call   801084d4 <outb>
80108505:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80108508:	68 80 00 00 00       	push   $0x80
8010850d:	68 fb 03 00 00       	push   $0x3fb
80108512:	e8 bd ff ff ff       	call   801084d4 <outb>
80108517:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
8010851a:	6a 0c                	push   $0xc
8010851c:	68 f8 03 00 00       	push   $0x3f8
80108521:	e8 ae ff ff ff       	call   801084d4 <outb>
80108526:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80108529:	6a 00                	push   $0x0
8010852b:	68 f9 03 00 00       	push   $0x3f9
80108530:	e8 9f ff ff ff       	call   801084d4 <outb>
80108535:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80108538:	6a 03                	push   $0x3
8010853a:	68 fb 03 00 00       	push   $0x3fb
8010853f:	e8 90 ff ff ff       	call   801084d4 <outb>
80108544:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80108547:	6a 00                	push   $0x0
80108549:	68 fc 03 00 00       	push   $0x3fc
8010854e:	e8 81 ff ff ff       	call   801084d4 <outb>
80108553:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80108556:	6a 01                	push   $0x1
80108558:	68 f9 03 00 00       	push   $0x3f9
8010855d:	e8 72 ff ff ff       	call   801084d4 <outb>
80108562:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80108565:	68 fd 03 00 00       	push   $0x3fd
8010856a:	e8 48 ff ff ff       	call   801084b7 <inb>
8010856f:	83 c4 04             	add    $0x4,%esp
80108572:	3c ff                	cmp    $0xff,%al
80108574:	74 6e                	je     801085e4 <uartinit+0xf1>
    return;
  uart = 1;
80108576:	c7 05 6c d6 10 80 01 	movl   $0x1,0x8010d66c
8010857d:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80108580:	68 fa 03 00 00       	push   $0x3fa
80108585:	e8 2d ff ff ff       	call   801084b7 <inb>
8010858a:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010858d:	68 f8 03 00 00       	push   $0x3f8
80108592:	e8 20 ff ff ff       	call   801084b7 <inb>
80108597:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
8010859a:	83 ec 0c             	sub    $0xc,%esp
8010859d:	6a 04                	push   $0x4
8010859f:	e8 38 ba ff ff       	call   80103fdc <picenable>
801085a4:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801085a7:	83 ec 08             	sub    $0x8,%esp
801085aa:	6a 00                	push   $0x0
801085ac:	6a 04                	push   $0x4
801085ae:	e8 d8 a5 ff ff       	call   80102b8b <ioapicenable>
801085b3:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801085b6:	c7 45 f4 70 ac 10 80 	movl   $0x8010ac70,-0xc(%ebp)
801085bd:	eb 19                	jmp    801085d8 <uartinit+0xe5>
    uartputc(*p);
801085bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c2:	0f b6 00             	movzbl (%eax),%eax
801085c5:	0f be c0             	movsbl %al,%eax
801085c8:	83 ec 0c             	sub    $0xc,%esp
801085cb:	50                   	push   %eax
801085cc:	e8 16 00 00 00       	call   801085e7 <uartputc>
801085d1:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801085d4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801085d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085db:	0f b6 00             	movzbl (%eax),%eax
801085de:	84 c0                	test   %al,%al
801085e0:	75 dd                	jne    801085bf <uartinit+0xcc>
801085e2:	eb 01                	jmp    801085e5 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801085e4:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
801085e5:	c9                   	leave  
801085e6:	c3                   	ret    

801085e7 <uartputc>:

void
uartputc(int c)
{
801085e7:	55                   	push   %ebp
801085e8:	89 e5                	mov    %esp,%ebp
801085ea:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801085ed:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
801085f2:	85 c0                	test   %eax,%eax
801085f4:	74 53                	je     80108649 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801085f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801085fd:	eb 11                	jmp    80108610 <uartputc+0x29>
    microdelay(10);
801085ff:	83 ec 0c             	sub    $0xc,%esp
80108602:	6a 0a                	push   $0xa
80108604:	e8 e8 aa ff ff       	call   801030f1 <microdelay>
80108609:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010860c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108610:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108614:	7f 1a                	jg     80108630 <uartputc+0x49>
80108616:	83 ec 0c             	sub    $0xc,%esp
80108619:	68 fd 03 00 00       	push   $0x3fd
8010861e:	e8 94 fe ff ff       	call   801084b7 <inb>
80108623:	83 c4 10             	add    $0x10,%esp
80108626:	0f b6 c0             	movzbl %al,%eax
80108629:	83 e0 20             	and    $0x20,%eax
8010862c:	85 c0                	test   %eax,%eax
8010862e:	74 cf                	je     801085ff <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80108630:	8b 45 08             	mov    0x8(%ebp),%eax
80108633:	0f b6 c0             	movzbl %al,%eax
80108636:	83 ec 08             	sub    $0x8,%esp
80108639:	50                   	push   %eax
8010863a:	68 f8 03 00 00       	push   $0x3f8
8010863f:	e8 90 fe ff ff       	call   801084d4 <outb>
80108644:	83 c4 10             	add    $0x10,%esp
80108647:	eb 01                	jmp    8010864a <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80108649:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
8010864a:	c9                   	leave  
8010864b:	c3                   	ret    

8010864c <uartgetc>:

static int
uartgetc(void)
{
8010864c:	55                   	push   %ebp
8010864d:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010864f:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80108654:	85 c0                	test   %eax,%eax
80108656:	75 07                	jne    8010865f <uartgetc+0x13>
    return -1;
80108658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010865d:	eb 2e                	jmp    8010868d <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010865f:	68 fd 03 00 00       	push   $0x3fd
80108664:	e8 4e fe ff ff       	call   801084b7 <inb>
80108669:	83 c4 04             	add    $0x4,%esp
8010866c:	0f b6 c0             	movzbl %al,%eax
8010866f:	83 e0 01             	and    $0x1,%eax
80108672:	85 c0                	test   %eax,%eax
80108674:	75 07                	jne    8010867d <uartgetc+0x31>
    return -1;
80108676:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010867b:	eb 10                	jmp    8010868d <uartgetc+0x41>
  return inb(COM1+0);
8010867d:	68 f8 03 00 00       	push   $0x3f8
80108682:	e8 30 fe ff ff       	call   801084b7 <inb>
80108687:	83 c4 04             	add    $0x4,%esp
8010868a:	0f b6 c0             	movzbl %al,%eax
}
8010868d:	c9                   	leave  
8010868e:	c3                   	ret    

8010868f <uartintr>:

void
uartintr(void)
{
8010868f:	55                   	push   %ebp
80108690:	89 e5                	mov    %esp,%ebp
80108692:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80108695:	83 ec 0c             	sub    $0xc,%esp
80108698:	68 4c 86 10 80       	push   $0x8010864c
8010869d:	e8 57 81 ff ff       	call   801007f9 <consoleintr>
801086a2:	83 c4 10             	add    $0x10,%esp
}
801086a5:	90                   	nop
801086a6:	c9                   	leave  
801086a7:	c3                   	ret    

801086a8 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801086a8:	6a 00                	push   $0x0
  pushl $0
801086aa:	6a 00                	push   $0x0
  jmp alltraps
801086ac:	e9 a9 f9 ff ff       	jmp    8010805a <alltraps>

801086b1 <vector1>:
.globl vector1
vector1:
  pushl $0
801086b1:	6a 00                	push   $0x0
  pushl $1
801086b3:	6a 01                	push   $0x1
  jmp alltraps
801086b5:	e9 a0 f9 ff ff       	jmp    8010805a <alltraps>

801086ba <vector2>:
.globl vector2
vector2:
  pushl $0
801086ba:	6a 00                	push   $0x0
  pushl $2
801086bc:	6a 02                	push   $0x2
  jmp alltraps
801086be:	e9 97 f9 ff ff       	jmp    8010805a <alltraps>

801086c3 <vector3>:
.globl vector3
vector3:
  pushl $0
801086c3:	6a 00                	push   $0x0
  pushl $3
801086c5:	6a 03                	push   $0x3
  jmp alltraps
801086c7:	e9 8e f9 ff ff       	jmp    8010805a <alltraps>

801086cc <vector4>:
.globl vector4
vector4:
  pushl $0
801086cc:	6a 00                	push   $0x0
  pushl $4
801086ce:	6a 04                	push   $0x4
  jmp alltraps
801086d0:	e9 85 f9 ff ff       	jmp    8010805a <alltraps>

801086d5 <vector5>:
.globl vector5
vector5:
  pushl $0
801086d5:	6a 00                	push   $0x0
  pushl $5
801086d7:	6a 05                	push   $0x5
  jmp alltraps
801086d9:	e9 7c f9 ff ff       	jmp    8010805a <alltraps>

801086de <vector6>:
.globl vector6
vector6:
  pushl $0
801086de:	6a 00                	push   $0x0
  pushl $6
801086e0:	6a 06                	push   $0x6
  jmp alltraps
801086e2:	e9 73 f9 ff ff       	jmp    8010805a <alltraps>

801086e7 <vector7>:
.globl vector7
vector7:
  pushl $0
801086e7:	6a 00                	push   $0x0
  pushl $7
801086e9:	6a 07                	push   $0x7
  jmp alltraps
801086eb:	e9 6a f9 ff ff       	jmp    8010805a <alltraps>

801086f0 <vector8>:
.globl vector8
vector8:
  pushl $8
801086f0:	6a 08                	push   $0x8
  jmp alltraps
801086f2:	e9 63 f9 ff ff       	jmp    8010805a <alltraps>

801086f7 <vector9>:
.globl vector9
vector9:
  pushl $0
801086f7:	6a 00                	push   $0x0
  pushl $9
801086f9:	6a 09                	push   $0x9
  jmp alltraps
801086fb:	e9 5a f9 ff ff       	jmp    8010805a <alltraps>

80108700 <vector10>:
.globl vector10
vector10:
  pushl $10
80108700:	6a 0a                	push   $0xa
  jmp alltraps
80108702:	e9 53 f9 ff ff       	jmp    8010805a <alltraps>

80108707 <vector11>:
.globl vector11
vector11:
  pushl $11
80108707:	6a 0b                	push   $0xb
  jmp alltraps
80108709:	e9 4c f9 ff ff       	jmp    8010805a <alltraps>

8010870e <vector12>:
.globl vector12
vector12:
  pushl $12
8010870e:	6a 0c                	push   $0xc
  jmp alltraps
80108710:	e9 45 f9 ff ff       	jmp    8010805a <alltraps>

80108715 <vector13>:
.globl vector13
vector13:
  pushl $13
80108715:	6a 0d                	push   $0xd
  jmp alltraps
80108717:	e9 3e f9 ff ff       	jmp    8010805a <alltraps>

8010871c <vector14>:
.globl vector14
vector14:
  pushl $14
8010871c:	6a 0e                	push   $0xe
  jmp alltraps
8010871e:	e9 37 f9 ff ff       	jmp    8010805a <alltraps>

80108723 <vector15>:
.globl vector15
vector15:
  pushl $0
80108723:	6a 00                	push   $0x0
  pushl $15
80108725:	6a 0f                	push   $0xf
  jmp alltraps
80108727:	e9 2e f9 ff ff       	jmp    8010805a <alltraps>

8010872c <vector16>:
.globl vector16
vector16:
  pushl $0
8010872c:	6a 00                	push   $0x0
  pushl $16
8010872e:	6a 10                	push   $0x10
  jmp alltraps
80108730:	e9 25 f9 ff ff       	jmp    8010805a <alltraps>

80108735 <vector17>:
.globl vector17
vector17:
  pushl $17
80108735:	6a 11                	push   $0x11
  jmp alltraps
80108737:	e9 1e f9 ff ff       	jmp    8010805a <alltraps>

8010873c <vector18>:
.globl vector18
vector18:
  pushl $0
8010873c:	6a 00                	push   $0x0
  pushl $18
8010873e:	6a 12                	push   $0x12
  jmp alltraps
80108740:	e9 15 f9 ff ff       	jmp    8010805a <alltraps>

80108745 <vector19>:
.globl vector19
vector19:
  pushl $0
80108745:	6a 00                	push   $0x0
  pushl $19
80108747:	6a 13                	push   $0x13
  jmp alltraps
80108749:	e9 0c f9 ff ff       	jmp    8010805a <alltraps>

8010874e <vector20>:
.globl vector20
vector20:
  pushl $0
8010874e:	6a 00                	push   $0x0
  pushl $20
80108750:	6a 14                	push   $0x14
  jmp alltraps
80108752:	e9 03 f9 ff ff       	jmp    8010805a <alltraps>

80108757 <vector21>:
.globl vector21
vector21:
  pushl $0
80108757:	6a 00                	push   $0x0
  pushl $21
80108759:	6a 15                	push   $0x15
  jmp alltraps
8010875b:	e9 fa f8 ff ff       	jmp    8010805a <alltraps>

80108760 <vector22>:
.globl vector22
vector22:
  pushl $0
80108760:	6a 00                	push   $0x0
  pushl $22
80108762:	6a 16                	push   $0x16
  jmp alltraps
80108764:	e9 f1 f8 ff ff       	jmp    8010805a <alltraps>

80108769 <vector23>:
.globl vector23
vector23:
  pushl $0
80108769:	6a 00                	push   $0x0
  pushl $23
8010876b:	6a 17                	push   $0x17
  jmp alltraps
8010876d:	e9 e8 f8 ff ff       	jmp    8010805a <alltraps>

80108772 <vector24>:
.globl vector24
vector24:
  pushl $0
80108772:	6a 00                	push   $0x0
  pushl $24
80108774:	6a 18                	push   $0x18
  jmp alltraps
80108776:	e9 df f8 ff ff       	jmp    8010805a <alltraps>

8010877b <vector25>:
.globl vector25
vector25:
  pushl $0
8010877b:	6a 00                	push   $0x0
  pushl $25
8010877d:	6a 19                	push   $0x19
  jmp alltraps
8010877f:	e9 d6 f8 ff ff       	jmp    8010805a <alltraps>

80108784 <vector26>:
.globl vector26
vector26:
  pushl $0
80108784:	6a 00                	push   $0x0
  pushl $26
80108786:	6a 1a                	push   $0x1a
  jmp alltraps
80108788:	e9 cd f8 ff ff       	jmp    8010805a <alltraps>

8010878d <vector27>:
.globl vector27
vector27:
  pushl $0
8010878d:	6a 00                	push   $0x0
  pushl $27
8010878f:	6a 1b                	push   $0x1b
  jmp alltraps
80108791:	e9 c4 f8 ff ff       	jmp    8010805a <alltraps>

80108796 <vector28>:
.globl vector28
vector28:
  pushl $0
80108796:	6a 00                	push   $0x0
  pushl $28
80108798:	6a 1c                	push   $0x1c
  jmp alltraps
8010879a:	e9 bb f8 ff ff       	jmp    8010805a <alltraps>

8010879f <vector29>:
.globl vector29
vector29:
  pushl $0
8010879f:	6a 00                	push   $0x0
  pushl $29
801087a1:	6a 1d                	push   $0x1d
  jmp alltraps
801087a3:	e9 b2 f8 ff ff       	jmp    8010805a <alltraps>

801087a8 <vector30>:
.globl vector30
vector30:
  pushl $0
801087a8:	6a 00                	push   $0x0
  pushl $30
801087aa:	6a 1e                	push   $0x1e
  jmp alltraps
801087ac:	e9 a9 f8 ff ff       	jmp    8010805a <alltraps>

801087b1 <vector31>:
.globl vector31
vector31:
  pushl $0
801087b1:	6a 00                	push   $0x0
  pushl $31
801087b3:	6a 1f                	push   $0x1f
  jmp alltraps
801087b5:	e9 a0 f8 ff ff       	jmp    8010805a <alltraps>

801087ba <vector32>:
.globl vector32
vector32:
  pushl $0
801087ba:	6a 00                	push   $0x0
  pushl $32
801087bc:	6a 20                	push   $0x20
  jmp alltraps
801087be:	e9 97 f8 ff ff       	jmp    8010805a <alltraps>

801087c3 <vector33>:
.globl vector33
vector33:
  pushl $0
801087c3:	6a 00                	push   $0x0
  pushl $33
801087c5:	6a 21                	push   $0x21
  jmp alltraps
801087c7:	e9 8e f8 ff ff       	jmp    8010805a <alltraps>

801087cc <vector34>:
.globl vector34
vector34:
  pushl $0
801087cc:	6a 00                	push   $0x0
  pushl $34
801087ce:	6a 22                	push   $0x22
  jmp alltraps
801087d0:	e9 85 f8 ff ff       	jmp    8010805a <alltraps>

801087d5 <vector35>:
.globl vector35
vector35:
  pushl $0
801087d5:	6a 00                	push   $0x0
  pushl $35
801087d7:	6a 23                	push   $0x23
  jmp alltraps
801087d9:	e9 7c f8 ff ff       	jmp    8010805a <alltraps>

801087de <vector36>:
.globl vector36
vector36:
  pushl $0
801087de:	6a 00                	push   $0x0
  pushl $36
801087e0:	6a 24                	push   $0x24
  jmp alltraps
801087e2:	e9 73 f8 ff ff       	jmp    8010805a <alltraps>

801087e7 <vector37>:
.globl vector37
vector37:
  pushl $0
801087e7:	6a 00                	push   $0x0
  pushl $37
801087e9:	6a 25                	push   $0x25
  jmp alltraps
801087eb:	e9 6a f8 ff ff       	jmp    8010805a <alltraps>

801087f0 <vector38>:
.globl vector38
vector38:
  pushl $0
801087f0:	6a 00                	push   $0x0
  pushl $38
801087f2:	6a 26                	push   $0x26
  jmp alltraps
801087f4:	e9 61 f8 ff ff       	jmp    8010805a <alltraps>

801087f9 <vector39>:
.globl vector39
vector39:
  pushl $0
801087f9:	6a 00                	push   $0x0
  pushl $39
801087fb:	6a 27                	push   $0x27
  jmp alltraps
801087fd:	e9 58 f8 ff ff       	jmp    8010805a <alltraps>

80108802 <vector40>:
.globl vector40
vector40:
  pushl $0
80108802:	6a 00                	push   $0x0
  pushl $40
80108804:	6a 28                	push   $0x28
  jmp alltraps
80108806:	e9 4f f8 ff ff       	jmp    8010805a <alltraps>

8010880b <vector41>:
.globl vector41
vector41:
  pushl $0
8010880b:	6a 00                	push   $0x0
  pushl $41
8010880d:	6a 29                	push   $0x29
  jmp alltraps
8010880f:	e9 46 f8 ff ff       	jmp    8010805a <alltraps>

80108814 <vector42>:
.globl vector42
vector42:
  pushl $0
80108814:	6a 00                	push   $0x0
  pushl $42
80108816:	6a 2a                	push   $0x2a
  jmp alltraps
80108818:	e9 3d f8 ff ff       	jmp    8010805a <alltraps>

8010881d <vector43>:
.globl vector43
vector43:
  pushl $0
8010881d:	6a 00                	push   $0x0
  pushl $43
8010881f:	6a 2b                	push   $0x2b
  jmp alltraps
80108821:	e9 34 f8 ff ff       	jmp    8010805a <alltraps>

80108826 <vector44>:
.globl vector44
vector44:
  pushl $0
80108826:	6a 00                	push   $0x0
  pushl $44
80108828:	6a 2c                	push   $0x2c
  jmp alltraps
8010882a:	e9 2b f8 ff ff       	jmp    8010805a <alltraps>

8010882f <vector45>:
.globl vector45
vector45:
  pushl $0
8010882f:	6a 00                	push   $0x0
  pushl $45
80108831:	6a 2d                	push   $0x2d
  jmp alltraps
80108833:	e9 22 f8 ff ff       	jmp    8010805a <alltraps>

80108838 <vector46>:
.globl vector46
vector46:
  pushl $0
80108838:	6a 00                	push   $0x0
  pushl $46
8010883a:	6a 2e                	push   $0x2e
  jmp alltraps
8010883c:	e9 19 f8 ff ff       	jmp    8010805a <alltraps>

80108841 <vector47>:
.globl vector47
vector47:
  pushl $0
80108841:	6a 00                	push   $0x0
  pushl $47
80108843:	6a 2f                	push   $0x2f
  jmp alltraps
80108845:	e9 10 f8 ff ff       	jmp    8010805a <alltraps>

8010884a <vector48>:
.globl vector48
vector48:
  pushl $0
8010884a:	6a 00                	push   $0x0
  pushl $48
8010884c:	6a 30                	push   $0x30
  jmp alltraps
8010884e:	e9 07 f8 ff ff       	jmp    8010805a <alltraps>

80108853 <vector49>:
.globl vector49
vector49:
  pushl $0
80108853:	6a 00                	push   $0x0
  pushl $49
80108855:	6a 31                	push   $0x31
  jmp alltraps
80108857:	e9 fe f7 ff ff       	jmp    8010805a <alltraps>

8010885c <vector50>:
.globl vector50
vector50:
  pushl $0
8010885c:	6a 00                	push   $0x0
  pushl $50
8010885e:	6a 32                	push   $0x32
  jmp alltraps
80108860:	e9 f5 f7 ff ff       	jmp    8010805a <alltraps>

80108865 <vector51>:
.globl vector51
vector51:
  pushl $0
80108865:	6a 00                	push   $0x0
  pushl $51
80108867:	6a 33                	push   $0x33
  jmp alltraps
80108869:	e9 ec f7 ff ff       	jmp    8010805a <alltraps>

8010886e <vector52>:
.globl vector52
vector52:
  pushl $0
8010886e:	6a 00                	push   $0x0
  pushl $52
80108870:	6a 34                	push   $0x34
  jmp alltraps
80108872:	e9 e3 f7 ff ff       	jmp    8010805a <alltraps>

80108877 <vector53>:
.globl vector53
vector53:
  pushl $0
80108877:	6a 00                	push   $0x0
  pushl $53
80108879:	6a 35                	push   $0x35
  jmp alltraps
8010887b:	e9 da f7 ff ff       	jmp    8010805a <alltraps>

80108880 <vector54>:
.globl vector54
vector54:
  pushl $0
80108880:	6a 00                	push   $0x0
  pushl $54
80108882:	6a 36                	push   $0x36
  jmp alltraps
80108884:	e9 d1 f7 ff ff       	jmp    8010805a <alltraps>

80108889 <vector55>:
.globl vector55
vector55:
  pushl $0
80108889:	6a 00                	push   $0x0
  pushl $55
8010888b:	6a 37                	push   $0x37
  jmp alltraps
8010888d:	e9 c8 f7 ff ff       	jmp    8010805a <alltraps>

80108892 <vector56>:
.globl vector56
vector56:
  pushl $0
80108892:	6a 00                	push   $0x0
  pushl $56
80108894:	6a 38                	push   $0x38
  jmp alltraps
80108896:	e9 bf f7 ff ff       	jmp    8010805a <alltraps>

8010889b <vector57>:
.globl vector57
vector57:
  pushl $0
8010889b:	6a 00                	push   $0x0
  pushl $57
8010889d:	6a 39                	push   $0x39
  jmp alltraps
8010889f:	e9 b6 f7 ff ff       	jmp    8010805a <alltraps>

801088a4 <vector58>:
.globl vector58
vector58:
  pushl $0
801088a4:	6a 00                	push   $0x0
  pushl $58
801088a6:	6a 3a                	push   $0x3a
  jmp alltraps
801088a8:	e9 ad f7 ff ff       	jmp    8010805a <alltraps>

801088ad <vector59>:
.globl vector59
vector59:
  pushl $0
801088ad:	6a 00                	push   $0x0
  pushl $59
801088af:	6a 3b                	push   $0x3b
  jmp alltraps
801088b1:	e9 a4 f7 ff ff       	jmp    8010805a <alltraps>

801088b6 <vector60>:
.globl vector60
vector60:
  pushl $0
801088b6:	6a 00                	push   $0x0
  pushl $60
801088b8:	6a 3c                	push   $0x3c
  jmp alltraps
801088ba:	e9 9b f7 ff ff       	jmp    8010805a <alltraps>

801088bf <vector61>:
.globl vector61
vector61:
  pushl $0
801088bf:	6a 00                	push   $0x0
  pushl $61
801088c1:	6a 3d                	push   $0x3d
  jmp alltraps
801088c3:	e9 92 f7 ff ff       	jmp    8010805a <alltraps>

801088c8 <vector62>:
.globl vector62
vector62:
  pushl $0
801088c8:	6a 00                	push   $0x0
  pushl $62
801088ca:	6a 3e                	push   $0x3e
  jmp alltraps
801088cc:	e9 89 f7 ff ff       	jmp    8010805a <alltraps>

801088d1 <vector63>:
.globl vector63
vector63:
  pushl $0
801088d1:	6a 00                	push   $0x0
  pushl $63
801088d3:	6a 3f                	push   $0x3f
  jmp alltraps
801088d5:	e9 80 f7 ff ff       	jmp    8010805a <alltraps>

801088da <vector64>:
.globl vector64
vector64:
  pushl $0
801088da:	6a 00                	push   $0x0
  pushl $64
801088dc:	6a 40                	push   $0x40
  jmp alltraps
801088de:	e9 77 f7 ff ff       	jmp    8010805a <alltraps>

801088e3 <vector65>:
.globl vector65
vector65:
  pushl $0
801088e3:	6a 00                	push   $0x0
  pushl $65
801088e5:	6a 41                	push   $0x41
  jmp alltraps
801088e7:	e9 6e f7 ff ff       	jmp    8010805a <alltraps>

801088ec <vector66>:
.globl vector66
vector66:
  pushl $0
801088ec:	6a 00                	push   $0x0
  pushl $66
801088ee:	6a 42                	push   $0x42
  jmp alltraps
801088f0:	e9 65 f7 ff ff       	jmp    8010805a <alltraps>

801088f5 <vector67>:
.globl vector67
vector67:
  pushl $0
801088f5:	6a 00                	push   $0x0
  pushl $67
801088f7:	6a 43                	push   $0x43
  jmp alltraps
801088f9:	e9 5c f7 ff ff       	jmp    8010805a <alltraps>

801088fe <vector68>:
.globl vector68
vector68:
  pushl $0
801088fe:	6a 00                	push   $0x0
  pushl $68
80108900:	6a 44                	push   $0x44
  jmp alltraps
80108902:	e9 53 f7 ff ff       	jmp    8010805a <alltraps>

80108907 <vector69>:
.globl vector69
vector69:
  pushl $0
80108907:	6a 00                	push   $0x0
  pushl $69
80108909:	6a 45                	push   $0x45
  jmp alltraps
8010890b:	e9 4a f7 ff ff       	jmp    8010805a <alltraps>

80108910 <vector70>:
.globl vector70
vector70:
  pushl $0
80108910:	6a 00                	push   $0x0
  pushl $70
80108912:	6a 46                	push   $0x46
  jmp alltraps
80108914:	e9 41 f7 ff ff       	jmp    8010805a <alltraps>

80108919 <vector71>:
.globl vector71
vector71:
  pushl $0
80108919:	6a 00                	push   $0x0
  pushl $71
8010891b:	6a 47                	push   $0x47
  jmp alltraps
8010891d:	e9 38 f7 ff ff       	jmp    8010805a <alltraps>

80108922 <vector72>:
.globl vector72
vector72:
  pushl $0
80108922:	6a 00                	push   $0x0
  pushl $72
80108924:	6a 48                	push   $0x48
  jmp alltraps
80108926:	e9 2f f7 ff ff       	jmp    8010805a <alltraps>

8010892b <vector73>:
.globl vector73
vector73:
  pushl $0
8010892b:	6a 00                	push   $0x0
  pushl $73
8010892d:	6a 49                	push   $0x49
  jmp alltraps
8010892f:	e9 26 f7 ff ff       	jmp    8010805a <alltraps>

80108934 <vector74>:
.globl vector74
vector74:
  pushl $0
80108934:	6a 00                	push   $0x0
  pushl $74
80108936:	6a 4a                	push   $0x4a
  jmp alltraps
80108938:	e9 1d f7 ff ff       	jmp    8010805a <alltraps>

8010893d <vector75>:
.globl vector75
vector75:
  pushl $0
8010893d:	6a 00                	push   $0x0
  pushl $75
8010893f:	6a 4b                	push   $0x4b
  jmp alltraps
80108941:	e9 14 f7 ff ff       	jmp    8010805a <alltraps>

80108946 <vector76>:
.globl vector76
vector76:
  pushl $0
80108946:	6a 00                	push   $0x0
  pushl $76
80108948:	6a 4c                	push   $0x4c
  jmp alltraps
8010894a:	e9 0b f7 ff ff       	jmp    8010805a <alltraps>

8010894f <vector77>:
.globl vector77
vector77:
  pushl $0
8010894f:	6a 00                	push   $0x0
  pushl $77
80108951:	6a 4d                	push   $0x4d
  jmp alltraps
80108953:	e9 02 f7 ff ff       	jmp    8010805a <alltraps>

80108958 <vector78>:
.globl vector78
vector78:
  pushl $0
80108958:	6a 00                	push   $0x0
  pushl $78
8010895a:	6a 4e                	push   $0x4e
  jmp alltraps
8010895c:	e9 f9 f6 ff ff       	jmp    8010805a <alltraps>

80108961 <vector79>:
.globl vector79
vector79:
  pushl $0
80108961:	6a 00                	push   $0x0
  pushl $79
80108963:	6a 4f                	push   $0x4f
  jmp alltraps
80108965:	e9 f0 f6 ff ff       	jmp    8010805a <alltraps>

8010896a <vector80>:
.globl vector80
vector80:
  pushl $0
8010896a:	6a 00                	push   $0x0
  pushl $80
8010896c:	6a 50                	push   $0x50
  jmp alltraps
8010896e:	e9 e7 f6 ff ff       	jmp    8010805a <alltraps>

80108973 <vector81>:
.globl vector81
vector81:
  pushl $0
80108973:	6a 00                	push   $0x0
  pushl $81
80108975:	6a 51                	push   $0x51
  jmp alltraps
80108977:	e9 de f6 ff ff       	jmp    8010805a <alltraps>

8010897c <vector82>:
.globl vector82
vector82:
  pushl $0
8010897c:	6a 00                	push   $0x0
  pushl $82
8010897e:	6a 52                	push   $0x52
  jmp alltraps
80108980:	e9 d5 f6 ff ff       	jmp    8010805a <alltraps>

80108985 <vector83>:
.globl vector83
vector83:
  pushl $0
80108985:	6a 00                	push   $0x0
  pushl $83
80108987:	6a 53                	push   $0x53
  jmp alltraps
80108989:	e9 cc f6 ff ff       	jmp    8010805a <alltraps>

8010898e <vector84>:
.globl vector84
vector84:
  pushl $0
8010898e:	6a 00                	push   $0x0
  pushl $84
80108990:	6a 54                	push   $0x54
  jmp alltraps
80108992:	e9 c3 f6 ff ff       	jmp    8010805a <alltraps>

80108997 <vector85>:
.globl vector85
vector85:
  pushl $0
80108997:	6a 00                	push   $0x0
  pushl $85
80108999:	6a 55                	push   $0x55
  jmp alltraps
8010899b:	e9 ba f6 ff ff       	jmp    8010805a <alltraps>

801089a0 <vector86>:
.globl vector86
vector86:
  pushl $0
801089a0:	6a 00                	push   $0x0
  pushl $86
801089a2:	6a 56                	push   $0x56
  jmp alltraps
801089a4:	e9 b1 f6 ff ff       	jmp    8010805a <alltraps>

801089a9 <vector87>:
.globl vector87
vector87:
  pushl $0
801089a9:	6a 00                	push   $0x0
  pushl $87
801089ab:	6a 57                	push   $0x57
  jmp alltraps
801089ad:	e9 a8 f6 ff ff       	jmp    8010805a <alltraps>

801089b2 <vector88>:
.globl vector88
vector88:
  pushl $0
801089b2:	6a 00                	push   $0x0
  pushl $88
801089b4:	6a 58                	push   $0x58
  jmp alltraps
801089b6:	e9 9f f6 ff ff       	jmp    8010805a <alltraps>

801089bb <vector89>:
.globl vector89
vector89:
  pushl $0
801089bb:	6a 00                	push   $0x0
  pushl $89
801089bd:	6a 59                	push   $0x59
  jmp alltraps
801089bf:	e9 96 f6 ff ff       	jmp    8010805a <alltraps>

801089c4 <vector90>:
.globl vector90
vector90:
  pushl $0
801089c4:	6a 00                	push   $0x0
  pushl $90
801089c6:	6a 5a                	push   $0x5a
  jmp alltraps
801089c8:	e9 8d f6 ff ff       	jmp    8010805a <alltraps>

801089cd <vector91>:
.globl vector91
vector91:
  pushl $0
801089cd:	6a 00                	push   $0x0
  pushl $91
801089cf:	6a 5b                	push   $0x5b
  jmp alltraps
801089d1:	e9 84 f6 ff ff       	jmp    8010805a <alltraps>

801089d6 <vector92>:
.globl vector92
vector92:
  pushl $0
801089d6:	6a 00                	push   $0x0
  pushl $92
801089d8:	6a 5c                	push   $0x5c
  jmp alltraps
801089da:	e9 7b f6 ff ff       	jmp    8010805a <alltraps>

801089df <vector93>:
.globl vector93
vector93:
  pushl $0
801089df:	6a 00                	push   $0x0
  pushl $93
801089e1:	6a 5d                	push   $0x5d
  jmp alltraps
801089e3:	e9 72 f6 ff ff       	jmp    8010805a <alltraps>

801089e8 <vector94>:
.globl vector94
vector94:
  pushl $0
801089e8:	6a 00                	push   $0x0
  pushl $94
801089ea:	6a 5e                	push   $0x5e
  jmp alltraps
801089ec:	e9 69 f6 ff ff       	jmp    8010805a <alltraps>

801089f1 <vector95>:
.globl vector95
vector95:
  pushl $0
801089f1:	6a 00                	push   $0x0
  pushl $95
801089f3:	6a 5f                	push   $0x5f
  jmp alltraps
801089f5:	e9 60 f6 ff ff       	jmp    8010805a <alltraps>

801089fa <vector96>:
.globl vector96
vector96:
  pushl $0
801089fa:	6a 00                	push   $0x0
  pushl $96
801089fc:	6a 60                	push   $0x60
  jmp alltraps
801089fe:	e9 57 f6 ff ff       	jmp    8010805a <alltraps>

80108a03 <vector97>:
.globl vector97
vector97:
  pushl $0
80108a03:	6a 00                	push   $0x0
  pushl $97
80108a05:	6a 61                	push   $0x61
  jmp alltraps
80108a07:	e9 4e f6 ff ff       	jmp    8010805a <alltraps>

80108a0c <vector98>:
.globl vector98
vector98:
  pushl $0
80108a0c:	6a 00                	push   $0x0
  pushl $98
80108a0e:	6a 62                	push   $0x62
  jmp alltraps
80108a10:	e9 45 f6 ff ff       	jmp    8010805a <alltraps>

80108a15 <vector99>:
.globl vector99
vector99:
  pushl $0
80108a15:	6a 00                	push   $0x0
  pushl $99
80108a17:	6a 63                	push   $0x63
  jmp alltraps
80108a19:	e9 3c f6 ff ff       	jmp    8010805a <alltraps>

80108a1e <vector100>:
.globl vector100
vector100:
  pushl $0
80108a1e:	6a 00                	push   $0x0
  pushl $100
80108a20:	6a 64                	push   $0x64
  jmp alltraps
80108a22:	e9 33 f6 ff ff       	jmp    8010805a <alltraps>

80108a27 <vector101>:
.globl vector101
vector101:
  pushl $0
80108a27:	6a 00                	push   $0x0
  pushl $101
80108a29:	6a 65                	push   $0x65
  jmp alltraps
80108a2b:	e9 2a f6 ff ff       	jmp    8010805a <alltraps>

80108a30 <vector102>:
.globl vector102
vector102:
  pushl $0
80108a30:	6a 00                	push   $0x0
  pushl $102
80108a32:	6a 66                	push   $0x66
  jmp alltraps
80108a34:	e9 21 f6 ff ff       	jmp    8010805a <alltraps>

80108a39 <vector103>:
.globl vector103
vector103:
  pushl $0
80108a39:	6a 00                	push   $0x0
  pushl $103
80108a3b:	6a 67                	push   $0x67
  jmp alltraps
80108a3d:	e9 18 f6 ff ff       	jmp    8010805a <alltraps>

80108a42 <vector104>:
.globl vector104
vector104:
  pushl $0
80108a42:	6a 00                	push   $0x0
  pushl $104
80108a44:	6a 68                	push   $0x68
  jmp alltraps
80108a46:	e9 0f f6 ff ff       	jmp    8010805a <alltraps>

80108a4b <vector105>:
.globl vector105
vector105:
  pushl $0
80108a4b:	6a 00                	push   $0x0
  pushl $105
80108a4d:	6a 69                	push   $0x69
  jmp alltraps
80108a4f:	e9 06 f6 ff ff       	jmp    8010805a <alltraps>

80108a54 <vector106>:
.globl vector106
vector106:
  pushl $0
80108a54:	6a 00                	push   $0x0
  pushl $106
80108a56:	6a 6a                	push   $0x6a
  jmp alltraps
80108a58:	e9 fd f5 ff ff       	jmp    8010805a <alltraps>

80108a5d <vector107>:
.globl vector107
vector107:
  pushl $0
80108a5d:	6a 00                	push   $0x0
  pushl $107
80108a5f:	6a 6b                	push   $0x6b
  jmp alltraps
80108a61:	e9 f4 f5 ff ff       	jmp    8010805a <alltraps>

80108a66 <vector108>:
.globl vector108
vector108:
  pushl $0
80108a66:	6a 00                	push   $0x0
  pushl $108
80108a68:	6a 6c                	push   $0x6c
  jmp alltraps
80108a6a:	e9 eb f5 ff ff       	jmp    8010805a <alltraps>

80108a6f <vector109>:
.globl vector109
vector109:
  pushl $0
80108a6f:	6a 00                	push   $0x0
  pushl $109
80108a71:	6a 6d                	push   $0x6d
  jmp alltraps
80108a73:	e9 e2 f5 ff ff       	jmp    8010805a <alltraps>

80108a78 <vector110>:
.globl vector110
vector110:
  pushl $0
80108a78:	6a 00                	push   $0x0
  pushl $110
80108a7a:	6a 6e                	push   $0x6e
  jmp alltraps
80108a7c:	e9 d9 f5 ff ff       	jmp    8010805a <alltraps>

80108a81 <vector111>:
.globl vector111
vector111:
  pushl $0
80108a81:	6a 00                	push   $0x0
  pushl $111
80108a83:	6a 6f                	push   $0x6f
  jmp alltraps
80108a85:	e9 d0 f5 ff ff       	jmp    8010805a <alltraps>

80108a8a <vector112>:
.globl vector112
vector112:
  pushl $0
80108a8a:	6a 00                	push   $0x0
  pushl $112
80108a8c:	6a 70                	push   $0x70
  jmp alltraps
80108a8e:	e9 c7 f5 ff ff       	jmp    8010805a <alltraps>

80108a93 <vector113>:
.globl vector113
vector113:
  pushl $0
80108a93:	6a 00                	push   $0x0
  pushl $113
80108a95:	6a 71                	push   $0x71
  jmp alltraps
80108a97:	e9 be f5 ff ff       	jmp    8010805a <alltraps>

80108a9c <vector114>:
.globl vector114
vector114:
  pushl $0
80108a9c:	6a 00                	push   $0x0
  pushl $114
80108a9e:	6a 72                	push   $0x72
  jmp alltraps
80108aa0:	e9 b5 f5 ff ff       	jmp    8010805a <alltraps>

80108aa5 <vector115>:
.globl vector115
vector115:
  pushl $0
80108aa5:	6a 00                	push   $0x0
  pushl $115
80108aa7:	6a 73                	push   $0x73
  jmp alltraps
80108aa9:	e9 ac f5 ff ff       	jmp    8010805a <alltraps>

80108aae <vector116>:
.globl vector116
vector116:
  pushl $0
80108aae:	6a 00                	push   $0x0
  pushl $116
80108ab0:	6a 74                	push   $0x74
  jmp alltraps
80108ab2:	e9 a3 f5 ff ff       	jmp    8010805a <alltraps>

80108ab7 <vector117>:
.globl vector117
vector117:
  pushl $0
80108ab7:	6a 00                	push   $0x0
  pushl $117
80108ab9:	6a 75                	push   $0x75
  jmp alltraps
80108abb:	e9 9a f5 ff ff       	jmp    8010805a <alltraps>

80108ac0 <vector118>:
.globl vector118
vector118:
  pushl $0
80108ac0:	6a 00                	push   $0x0
  pushl $118
80108ac2:	6a 76                	push   $0x76
  jmp alltraps
80108ac4:	e9 91 f5 ff ff       	jmp    8010805a <alltraps>

80108ac9 <vector119>:
.globl vector119
vector119:
  pushl $0
80108ac9:	6a 00                	push   $0x0
  pushl $119
80108acb:	6a 77                	push   $0x77
  jmp alltraps
80108acd:	e9 88 f5 ff ff       	jmp    8010805a <alltraps>

80108ad2 <vector120>:
.globl vector120
vector120:
  pushl $0
80108ad2:	6a 00                	push   $0x0
  pushl $120
80108ad4:	6a 78                	push   $0x78
  jmp alltraps
80108ad6:	e9 7f f5 ff ff       	jmp    8010805a <alltraps>

80108adb <vector121>:
.globl vector121
vector121:
  pushl $0
80108adb:	6a 00                	push   $0x0
  pushl $121
80108add:	6a 79                	push   $0x79
  jmp alltraps
80108adf:	e9 76 f5 ff ff       	jmp    8010805a <alltraps>

80108ae4 <vector122>:
.globl vector122
vector122:
  pushl $0
80108ae4:	6a 00                	push   $0x0
  pushl $122
80108ae6:	6a 7a                	push   $0x7a
  jmp alltraps
80108ae8:	e9 6d f5 ff ff       	jmp    8010805a <alltraps>

80108aed <vector123>:
.globl vector123
vector123:
  pushl $0
80108aed:	6a 00                	push   $0x0
  pushl $123
80108aef:	6a 7b                	push   $0x7b
  jmp alltraps
80108af1:	e9 64 f5 ff ff       	jmp    8010805a <alltraps>

80108af6 <vector124>:
.globl vector124
vector124:
  pushl $0
80108af6:	6a 00                	push   $0x0
  pushl $124
80108af8:	6a 7c                	push   $0x7c
  jmp alltraps
80108afa:	e9 5b f5 ff ff       	jmp    8010805a <alltraps>

80108aff <vector125>:
.globl vector125
vector125:
  pushl $0
80108aff:	6a 00                	push   $0x0
  pushl $125
80108b01:	6a 7d                	push   $0x7d
  jmp alltraps
80108b03:	e9 52 f5 ff ff       	jmp    8010805a <alltraps>

80108b08 <vector126>:
.globl vector126
vector126:
  pushl $0
80108b08:	6a 00                	push   $0x0
  pushl $126
80108b0a:	6a 7e                	push   $0x7e
  jmp alltraps
80108b0c:	e9 49 f5 ff ff       	jmp    8010805a <alltraps>

80108b11 <vector127>:
.globl vector127
vector127:
  pushl $0
80108b11:	6a 00                	push   $0x0
  pushl $127
80108b13:	6a 7f                	push   $0x7f
  jmp alltraps
80108b15:	e9 40 f5 ff ff       	jmp    8010805a <alltraps>

80108b1a <vector128>:
.globl vector128
vector128:
  pushl $0
80108b1a:	6a 00                	push   $0x0
  pushl $128
80108b1c:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108b21:	e9 34 f5 ff ff       	jmp    8010805a <alltraps>

80108b26 <vector129>:
.globl vector129
vector129:
  pushl $0
80108b26:	6a 00                	push   $0x0
  pushl $129
80108b28:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108b2d:	e9 28 f5 ff ff       	jmp    8010805a <alltraps>

80108b32 <vector130>:
.globl vector130
vector130:
  pushl $0
80108b32:	6a 00                	push   $0x0
  pushl $130
80108b34:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108b39:	e9 1c f5 ff ff       	jmp    8010805a <alltraps>

80108b3e <vector131>:
.globl vector131
vector131:
  pushl $0
80108b3e:	6a 00                	push   $0x0
  pushl $131
80108b40:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108b45:	e9 10 f5 ff ff       	jmp    8010805a <alltraps>

80108b4a <vector132>:
.globl vector132
vector132:
  pushl $0
80108b4a:	6a 00                	push   $0x0
  pushl $132
80108b4c:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108b51:	e9 04 f5 ff ff       	jmp    8010805a <alltraps>

80108b56 <vector133>:
.globl vector133
vector133:
  pushl $0
80108b56:	6a 00                	push   $0x0
  pushl $133
80108b58:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108b5d:	e9 f8 f4 ff ff       	jmp    8010805a <alltraps>

80108b62 <vector134>:
.globl vector134
vector134:
  pushl $0
80108b62:	6a 00                	push   $0x0
  pushl $134
80108b64:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108b69:	e9 ec f4 ff ff       	jmp    8010805a <alltraps>

80108b6e <vector135>:
.globl vector135
vector135:
  pushl $0
80108b6e:	6a 00                	push   $0x0
  pushl $135
80108b70:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108b75:	e9 e0 f4 ff ff       	jmp    8010805a <alltraps>

80108b7a <vector136>:
.globl vector136
vector136:
  pushl $0
80108b7a:	6a 00                	push   $0x0
  pushl $136
80108b7c:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108b81:	e9 d4 f4 ff ff       	jmp    8010805a <alltraps>

80108b86 <vector137>:
.globl vector137
vector137:
  pushl $0
80108b86:	6a 00                	push   $0x0
  pushl $137
80108b88:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108b8d:	e9 c8 f4 ff ff       	jmp    8010805a <alltraps>

80108b92 <vector138>:
.globl vector138
vector138:
  pushl $0
80108b92:	6a 00                	push   $0x0
  pushl $138
80108b94:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108b99:	e9 bc f4 ff ff       	jmp    8010805a <alltraps>

80108b9e <vector139>:
.globl vector139
vector139:
  pushl $0
80108b9e:	6a 00                	push   $0x0
  pushl $139
80108ba0:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108ba5:	e9 b0 f4 ff ff       	jmp    8010805a <alltraps>

80108baa <vector140>:
.globl vector140
vector140:
  pushl $0
80108baa:	6a 00                	push   $0x0
  pushl $140
80108bac:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108bb1:	e9 a4 f4 ff ff       	jmp    8010805a <alltraps>

80108bb6 <vector141>:
.globl vector141
vector141:
  pushl $0
80108bb6:	6a 00                	push   $0x0
  pushl $141
80108bb8:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108bbd:	e9 98 f4 ff ff       	jmp    8010805a <alltraps>

80108bc2 <vector142>:
.globl vector142
vector142:
  pushl $0
80108bc2:	6a 00                	push   $0x0
  pushl $142
80108bc4:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108bc9:	e9 8c f4 ff ff       	jmp    8010805a <alltraps>

80108bce <vector143>:
.globl vector143
vector143:
  pushl $0
80108bce:	6a 00                	push   $0x0
  pushl $143
80108bd0:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108bd5:	e9 80 f4 ff ff       	jmp    8010805a <alltraps>

80108bda <vector144>:
.globl vector144
vector144:
  pushl $0
80108bda:	6a 00                	push   $0x0
  pushl $144
80108bdc:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108be1:	e9 74 f4 ff ff       	jmp    8010805a <alltraps>

80108be6 <vector145>:
.globl vector145
vector145:
  pushl $0
80108be6:	6a 00                	push   $0x0
  pushl $145
80108be8:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108bed:	e9 68 f4 ff ff       	jmp    8010805a <alltraps>

80108bf2 <vector146>:
.globl vector146
vector146:
  pushl $0
80108bf2:	6a 00                	push   $0x0
  pushl $146
80108bf4:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108bf9:	e9 5c f4 ff ff       	jmp    8010805a <alltraps>

80108bfe <vector147>:
.globl vector147
vector147:
  pushl $0
80108bfe:	6a 00                	push   $0x0
  pushl $147
80108c00:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108c05:	e9 50 f4 ff ff       	jmp    8010805a <alltraps>

80108c0a <vector148>:
.globl vector148
vector148:
  pushl $0
80108c0a:	6a 00                	push   $0x0
  pushl $148
80108c0c:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108c11:	e9 44 f4 ff ff       	jmp    8010805a <alltraps>

80108c16 <vector149>:
.globl vector149
vector149:
  pushl $0
80108c16:	6a 00                	push   $0x0
  pushl $149
80108c18:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108c1d:	e9 38 f4 ff ff       	jmp    8010805a <alltraps>

80108c22 <vector150>:
.globl vector150
vector150:
  pushl $0
80108c22:	6a 00                	push   $0x0
  pushl $150
80108c24:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108c29:	e9 2c f4 ff ff       	jmp    8010805a <alltraps>

80108c2e <vector151>:
.globl vector151
vector151:
  pushl $0
80108c2e:	6a 00                	push   $0x0
  pushl $151
80108c30:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108c35:	e9 20 f4 ff ff       	jmp    8010805a <alltraps>

80108c3a <vector152>:
.globl vector152
vector152:
  pushl $0
80108c3a:	6a 00                	push   $0x0
  pushl $152
80108c3c:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108c41:	e9 14 f4 ff ff       	jmp    8010805a <alltraps>

80108c46 <vector153>:
.globl vector153
vector153:
  pushl $0
80108c46:	6a 00                	push   $0x0
  pushl $153
80108c48:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108c4d:	e9 08 f4 ff ff       	jmp    8010805a <alltraps>

80108c52 <vector154>:
.globl vector154
vector154:
  pushl $0
80108c52:	6a 00                	push   $0x0
  pushl $154
80108c54:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108c59:	e9 fc f3 ff ff       	jmp    8010805a <alltraps>

80108c5e <vector155>:
.globl vector155
vector155:
  pushl $0
80108c5e:	6a 00                	push   $0x0
  pushl $155
80108c60:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108c65:	e9 f0 f3 ff ff       	jmp    8010805a <alltraps>

80108c6a <vector156>:
.globl vector156
vector156:
  pushl $0
80108c6a:	6a 00                	push   $0x0
  pushl $156
80108c6c:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108c71:	e9 e4 f3 ff ff       	jmp    8010805a <alltraps>

80108c76 <vector157>:
.globl vector157
vector157:
  pushl $0
80108c76:	6a 00                	push   $0x0
  pushl $157
80108c78:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108c7d:	e9 d8 f3 ff ff       	jmp    8010805a <alltraps>

80108c82 <vector158>:
.globl vector158
vector158:
  pushl $0
80108c82:	6a 00                	push   $0x0
  pushl $158
80108c84:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108c89:	e9 cc f3 ff ff       	jmp    8010805a <alltraps>

80108c8e <vector159>:
.globl vector159
vector159:
  pushl $0
80108c8e:	6a 00                	push   $0x0
  pushl $159
80108c90:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108c95:	e9 c0 f3 ff ff       	jmp    8010805a <alltraps>

80108c9a <vector160>:
.globl vector160
vector160:
  pushl $0
80108c9a:	6a 00                	push   $0x0
  pushl $160
80108c9c:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108ca1:	e9 b4 f3 ff ff       	jmp    8010805a <alltraps>

80108ca6 <vector161>:
.globl vector161
vector161:
  pushl $0
80108ca6:	6a 00                	push   $0x0
  pushl $161
80108ca8:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108cad:	e9 a8 f3 ff ff       	jmp    8010805a <alltraps>

80108cb2 <vector162>:
.globl vector162
vector162:
  pushl $0
80108cb2:	6a 00                	push   $0x0
  pushl $162
80108cb4:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108cb9:	e9 9c f3 ff ff       	jmp    8010805a <alltraps>

80108cbe <vector163>:
.globl vector163
vector163:
  pushl $0
80108cbe:	6a 00                	push   $0x0
  pushl $163
80108cc0:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108cc5:	e9 90 f3 ff ff       	jmp    8010805a <alltraps>

80108cca <vector164>:
.globl vector164
vector164:
  pushl $0
80108cca:	6a 00                	push   $0x0
  pushl $164
80108ccc:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108cd1:	e9 84 f3 ff ff       	jmp    8010805a <alltraps>

80108cd6 <vector165>:
.globl vector165
vector165:
  pushl $0
80108cd6:	6a 00                	push   $0x0
  pushl $165
80108cd8:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108cdd:	e9 78 f3 ff ff       	jmp    8010805a <alltraps>

80108ce2 <vector166>:
.globl vector166
vector166:
  pushl $0
80108ce2:	6a 00                	push   $0x0
  pushl $166
80108ce4:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108ce9:	e9 6c f3 ff ff       	jmp    8010805a <alltraps>

80108cee <vector167>:
.globl vector167
vector167:
  pushl $0
80108cee:	6a 00                	push   $0x0
  pushl $167
80108cf0:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108cf5:	e9 60 f3 ff ff       	jmp    8010805a <alltraps>

80108cfa <vector168>:
.globl vector168
vector168:
  pushl $0
80108cfa:	6a 00                	push   $0x0
  pushl $168
80108cfc:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108d01:	e9 54 f3 ff ff       	jmp    8010805a <alltraps>

80108d06 <vector169>:
.globl vector169
vector169:
  pushl $0
80108d06:	6a 00                	push   $0x0
  pushl $169
80108d08:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108d0d:	e9 48 f3 ff ff       	jmp    8010805a <alltraps>

80108d12 <vector170>:
.globl vector170
vector170:
  pushl $0
80108d12:	6a 00                	push   $0x0
  pushl $170
80108d14:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108d19:	e9 3c f3 ff ff       	jmp    8010805a <alltraps>

80108d1e <vector171>:
.globl vector171
vector171:
  pushl $0
80108d1e:	6a 00                	push   $0x0
  pushl $171
80108d20:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108d25:	e9 30 f3 ff ff       	jmp    8010805a <alltraps>

80108d2a <vector172>:
.globl vector172
vector172:
  pushl $0
80108d2a:	6a 00                	push   $0x0
  pushl $172
80108d2c:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108d31:	e9 24 f3 ff ff       	jmp    8010805a <alltraps>

80108d36 <vector173>:
.globl vector173
vector173:
  pushl $0
80108d36:	6a 00                	push   $0x0
  pushl $173
80108d38:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108d3d:	e9 18 f3 ff ff       	jmp    8010805a <alltraps>

80108d42 <vector174>:
.globl vector174
vector174:
  pushl $0
80108d42:	6a 00                	push   $0x0
  pushl $174
80108d44:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108d49:	e9 0c f3 ff ff       	jmp    8010805a <alltraps>

80108d4e <vector175>:
.globl vector175
vector175:
  pushl $0
80108d4e:	6a 00                	push   $0x0
  pushl $175
80108d50:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108d55:	e9 00 f3 ff ff       	jmp    8010805a <alltraps>

80108d5a <vector176>:
.globl vector176
vector176:
  pushl $0
80108d5a:	6a 00                	push   $0x0
  pushl $176
80108d5c:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108d61:	e9 f4 f2 ff ff       	jmp    8010805a <alltraps>

80108d66 <vector177>:
.globl vector177
vector177:
  pushl $0
80108d66:	6a 00                	push   $0x0
  pushl $177
80108d68:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108d6d:	e9 e8 f2 ff ff       	jmp    8010805a <alltraps>

80108d72 <vector178>:
.globl vector178
vector178:
  pushl $0
80108d72:	6a 00                	push   $0x0
  pushl $178
80108d74:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108d79:	e9 dc f2 ff ff       	jmp    8010805a <alltraps>

80108d7e <vector179>:
.globl vector179
vector179:
  pushl $0
80108d7e:	6a 00                	push   $0x0
  pushl $179
80108d80:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108d85:	e9 d0 f2 ff ff       	jmp    8010805a <alltraps>

80108d8a <vector180>:
.globl vector180
vector180:
  pushl $0
80108d8a:	6a 00                	push   $0x0
  pushl $180
80108d8c:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108d91:	e9 c4 f2 ff ff       	jmp    8010805a <alltraps>

80108d96 <vector181>:
.globl vector181
vector181:
  pushl $0
80108d96:	6a 00                	push   $0x0
  pushl $181
80108d98:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108d9d:	e9 b8 f2 ff ff       	jmp    8010805a <alltraps>

80108da2 <vector182>:
.globl vector182
vector182:
  pushl $0
80108da2:	6a 00                	push   $0x0
  pushl $182
80108da4:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108da9:	e9 ac f2 ff ff       	jmp    8010805a <alltraps>

80108dae <vector183>:
.globl vector183
vector183:
  pushl $0
80108dae:	6a 00                	push   $0x0
  pushl $183
80108db0:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108db5:	e9 a0 f2 ff ff       	jmp    8010805a <alltraps>

80108dba <vector184>:
.globl vector184
vector184:
  pushl $0
80108dba:	6a 00                	push   $0x0
  pushl $184
80108dbc:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108dc1:	e9 94 f2 ff ff       	jmp    8010805a <alltraps>

80108dc6 <vector185>:
.globl vector185
vector185:
  pushl $0
80108dc6:	6a 00                	push   $0x0
  pushl $185
80108dc8:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108dcd:	e9 88 f2 ff ff       	jmp    8010805a <alltraps>

80108dd2 <vector186>:
.globl vector186
vector186:
  pushl $0
80108dd2:	6a 00                	push   $0x0
  pushl $186
80108dd4:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108dd9:	e9 7c f2 ff ff       	jmp    8010805a <alltraps>

80108dde <vector187>:
.globl vector187
vector187:
  pushl $0
80108dde:	6a 00                	push   $0x0
  pushl $187
80108de0:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108de5:	e9 70 f2 ff ff       	jmp    8010805a <alltraps>

80108dea <vector188>:
.globl vector188
vector188:
  pushl $0
80108dea:	6a 00                	push   $0x0
  pushl $188
80108dec:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108df1:	e9 64 f2 ff ff       	jmp    8010805a <alltraps>

80108df6 <vector189>:
.globl vector189
vector189:
  pushl $0
80108df6:	6a 00                	push   $0x0
  pushl $189
80108df8:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108dfd:	e9 58 f2 ff ff       	jmp    8010805a <alltraps>

80108e02 <vector190>:
.globl vector190
vector190:
  pushl $0
80108e02:	6a 00                	push   $0x0
  pushl $190
80108e04:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108e09:	e9 4c f2 ff ff       	jmp    8010805a <alltraps>

80108e0e <vector191>:
.globl vector191
vector191:
  pushl $0
80108e0e:	6a 00                	push   $0x0
  pushl $191
80108e10:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108e15:	e9 40 f2 ff ff       	jmp    8010805a <alltraps>

80108e1a <vector192>:
.globl vector192
vector192:
  pushl $0
80108e1a:	6a 00                	push   $0x0
  pushl $192
80108e1c:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108e21:	e9 34 f2 ff ff       	jmp    8010805a <alltraps>

80108e26 <vector193>:
.globl vector193
vector193:
  pushl $0
80108e26:	6a 00                	push   $0x0
  pushl $193
80108e28:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108e2d:	e9 28 f2 ff ff       	jmp    8010805a <alltraps>

80108e32 <vector194>:
.globl vector194
vector194:
  pushl $0
80108e32:	6a 00                	push   $0x0
  pushl $194
80108e34:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108e39:	e9 1c f2 ff ff       	jmp    8010805a <alltraps>

80108e3e <vector195>:
.globl vector195
vector195:
  pushl $0
80108e3e:	6a 00                	push   $0x0
  pushl $195
80108e40:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108e45:	e9 10 f2 ff ff       	jmp    8010805a <alltraps>

80108e4a <vector196>:
.globl vector196
vector196:
  pushl $0
80108e4a:	6a 00                	push   $0x0
  pushl $196
80108e4c:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108e51:	e9 04 f2 ff ff       	jmp    8010805a <alltraps>

80108e56 <vector197>:
.globl vector197
vector197:
  pushl $0
80108e56:	6a 00                	push   $0x0
  pushl $197
80108e58:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108e5d:	e9 f8 f1 ff ff       	jmp    8010805a <alltraps>

80108e62 <vector198>:
.globl vector198
vector198:
  pushl $0
80108e62:	6a 00                	push   $0x0
  pushl $198
80108e64:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108e69:	e9 ec f1 ff ff       	jmp    8010805a <alltraps>

80108e6e <vector199>:
.globl vector199
vector199:
  pushl $0
80108e6e:	6a 00                	push   $0x0
  pushl $199
80108e70:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108e75:	e9 e0 f1 ff ff       	jmp    8010805a <alltraps>

80108e7a <vector200>:
.globl vector200
vector200:
  pushl $0
80108e7a:	6a 00                	push   $0x0
  pushl $200
80108e7c:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108e81:	e9 d4 f1 ff ff       	jmp    8010805a <alltraps>

80108e86 <vector201>:
.globl vector201
vector201:
  pushl $0
80108e86:	6a 00                	push   $0x0
  pushl $201
80108e88:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108e8d:	e9 c8 f1 ff ff       	jmp    8010805a <alltraps>

80108e92 <vector202>:
.globl vector202
vector202:
  pushl $0
80108e92:	6a 00                	push   $0x0
  pushl $202
80108e94:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108e99:	e9 bc f1 ff ff       	jmp    8010805a <alltraps>

80108e9e <vector203>:
.globl vector203
vector203:
  pushl $0
80108e9e:	6a 00                	push   $0x0
  pushl $203
80108ea0:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108ea5:	e9 b0 f1 ff ff       	jmp    8010805a <alltraps>

80108eaa <vector204>:
.globl vector204
vector204:
  pushl $0
80108eaa:	6a 00                	push   $0x0
  pushl $204
80108eac:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108eb1:	e9 a4 f1 ff ff       	jmp    8010805a <alltraps>

80108eb6 <vector205>:
.globl vector205
vector205:
  pushl $0
80108eb6:	6a 00                	push   $0x0
  pushl $205
80108eb8:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108ebd:	e9 98 f1 ff ff       	jmp    8010805a <alltraps>

80108ec2 <vector206>:
.globl vector206
vector206:
  pushl $0
80108ec2:	6a 00                	push   $0x0
  pushl $206
80108ec4:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108ec9:	e9 8c f1 ff ff       	jmp    8010805a <alltraps>

80108ece <vector207>:
.globl vector207
vector207:
  pushl $0
80108ece:	6a 00                	push   $0x0
  pushl $207
80108ed0:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108ed5:	e9 80 f1 ff ff       	jmp    8010805a <alltraps>

80108eda <vector208>:
.globl vector208
vector208:
  pushl $0
80108eda:	6a 00                	push   $0x0
  pushl $208
80108edc:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108ee1:	e9 74 f1 ff ff       	jmp    8010805a <alltraps>

80108ee6 <vector209>:
.globl vector209
vector209:
  pushl $0
80108ee6:	6a 00                	push   $0x0
  pushl $209
80108ee8:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108eed:	e9 68 f1 ff ff       	jmp    8010805a <alltraps>

80108ef2 <vector210>:
.globl vector210
vector210:
  pushl $0
80108ef2:	6a 00                	push   $0x0
  pushl $210
80108ef4:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108ef9:	e9 5c f1 ff ff       	jmp    8010805a <alltraps>

80108efe <vector211>:
.globl vector211
vector211:
  pushl $0
80108efe:	6a 00                	push   $0x0
  pushl $211
80108f00:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108f05:	e9 50 f1 ff ff       	jmp    8010805a <alltraps>

80108f0a <vector212>:
.globl vector212
vector212:
  pushl $0
80108f0a:	6a 00                	push   $0x0
  pushl $212
80108f0c:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108f11:	e9 44 f1 ff ff       	jmp    8010805a <alltraps>

80108f16 <vector213>:
.globl vector213
vector213:
  pushl $0
80108f16:	6a 00                	push   $0x0
  pushl $213
80108f18:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108f1d:	e9 38 f1 ff ff       	jmp    8010805a <alltraps>

80108f22 <vector214>:
.globl vector214
vector214:
  pushl $0
80108f22:	6a 00                	push   $0x0
  pushl $214
80108f24:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108f29:	e9 2c f1 ff ff       	jmp    8010805a <alltraps>

80108f2e <vector215>:
.globl vector215
vector215:
  pushl $0
80108f2e:	6a 00                	push   $0x0
  pushl $215
80108f30:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108f35:	e9 20 f1 ff ff       	jmp    8010805a <alltraps>

80108f3a <vector216>:
.globl vector216
vector216:
  pushl $0
80108f3a:	6a 00                	push   $0x0
  pushl $216
80108f3c:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108f41:	e9 14 f1 ff ff       	jmp    8010805a <alltraps>

80108f46 <vector217>:
.globl vector217
vector217:
  pushl $0
80108f46:	6a 00                	push   $0x0
  pushl $217
80108f48:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108f4d:	e9 08 f1 ff ff       	jmp    8010805a <alltraps>

80108f52 <vector218>:
.globl vector218
vector218:
  pushl $0
80108f52:	6a 00                	push   $0x0
  pushl $218
80108f54:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108f59:	e9 fc f0 ff ff       	jmp    8010805a <alltraps>

80108f5e <vector219>:
.globl vector219
vector219:
  pushl $0
80108f5e:	6a 00                	push   $0x0
  pushl $219
80108f60:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108f65:	e9 f0 f0 ff ff       	jmp    8010805a <alltraps>

80108f6a <vector220>:
.globl vector220
vector220:
  pushl $0
80108f6a:	6a 00                	push   $0x0
  pushl $220
80108f6c:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108f71:	e9 e4 f0 ff ff       	jmp    8010805a <alltraps>

80108f76 <vector221>:
.globl vector221
vector221:
  pushl $0
80108f76:	6a 00                	push   $0x0
  pushl $221
80108f78:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108f7d:	e9 d8 f0 ff ff       	jmp    8010805a <alltraps>

80108f82 <vector222>:
.globl vector222
vector222:
  pushl $0
80108f82:	6a 00                	push   $0x0
  pushl $222
80108f84:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108f89:	e9 cc f0 ff ff       	jmp    8010805a <alltraps>

80108f8e <vector223>:
.globl vector223
vector223:
  pushl $0
80108f8e:	6a 00                	push   $0x0
  pushl $223
80108f90:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108f95:	e9 c0 f0 ff ff       	jmp    8010805a <alltraps>

80108f9a <vector224>:
.globl vector224
vector224:
  pushl $0
80108f9a:	6a 00                	push   $0x0
  pushl $224
80108f9c:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108fa1:	e9 b4 f0 ff ff       	jmp    8010805a <alltraps>

80108fa6 <vector225>:
.globl vector225
vector225:
  pushl $0
80108fa6:	6a 00                	push   $0x0
  pushl $225
80108fa8:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108fad:	e9 a8 f0 ff ff       	jmp    8010805a <alltraps>

80108fb2 <vector226>:
.globl vector226
vector226:
  pushl $0
80108fb2:	6a 00                	push   $0x0
  pushl $226
80108fb4:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108fb9:	e9 9c f0 ff ff       	jmp    8010805a <alltraps>

80108fbe <vector227>:
.globl vector227
vector227:
  pushl $0
80108fbe:	6a 00                	push   $0x0
  pushl $227
80108fc0:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108fc5:	e9 90 f0 ff ff       	jmp    8010805a <alltraps>

80108fca <vector228>:
.globl vector228
vector228:
  pushl $0
80108fca:	6a 00                	push   $0x0
  pushl $228
80108fcc:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108fd1:	e9 84 f0 ff ff       	jmp    8010805a <alltraps>

80108fd6 <vector229>:
.globl vector229
vector229:
  pushl $0
80108fd6:	6a 00                	push   $0x0
  pushl $229
80108fd8:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108fdd:	e9 78 f0 ff ff       	jmp    8010805a <alltraps>

80108fe2 <vector230>:
.globl vector230
vector230:
  pushl $0
80108fe2:	6a 00                	push   $0x0
  pushl $230
80108fe4:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108fe9:	e9 6c f0 ff ff       	jmp    8010805a <alltraps>

80108fee <vector231>:
.globl vector231
vector231:
  pushl $0
80108fee:	6a 00                	push   $0x0
  pushl $231
80108ff0:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108ff5:	e9 60 f0 ff ff       	jmp    8010805a <alltraps>

80108ffa <vector232>:
.globl vector232
vector232:
  pushl $0
80108ffa:	6a 00                	push   $0x0
  pushl $232
80108ffc:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80109001:	e9 54 f0 ff ff       	jmp    8010805a <alltraps>

80109006 <vector233>:
.globl vector233
vector233:
  pushl $0
80109006:	6a 00                	push   $0x0
  pushl $233
80109008:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010900d:	e9 48 f0 ff ff       	jmp    8010805a <alltraps>

80109012 <vector234>:
.globl vector234
vector234:
  pushl $0
80109012:	6a 00                	push   $0x0
  pushl $234
80109014:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80109019:	e9 3c f0 ff ff       	jmp    8010805a <alltraps>

8010901e <vector235>:
.globl vector235
vector235:
  pushl $0
8010901e:	6a 00                	push   $0x0
  pushl $235
80109020:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80109025:	e9 30 f0 ff ff       	jmp    8010805a <alltraps>

8010902a <vector236>:
.globl vector236
vector236:
  pushl $0
8010902a:	6a 00                	push   $0x0
  pushl $236
8010902c:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80109031:	e9 24 f0 ff ff       	jmp    8010805a <alltraps>

80109036 <vector237>:
.globl vector237
vector237:
  pushl $0
80109036:	6a 00                	push   $0x0
  pushl $237
80109038:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010903d:	e9 18 f0 ff ff       	jmp    8010805a <alltraps>

80109042 <vector238>:
.globl vector238
vector238:
  pushl $0
80109042:	6a 00                	push   $0x0
  pushl $238
80109044:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80109049:	e9 0c f0 ff ff       	jmp    8010805a <alltraps>

8010904e <vector239>:
.globl vector239
vector239:
  pushl $0
8010904e:	6a 00                	push   $0x0
  pushl $239
80109050:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80109055:	e9 00 f0 ff ff       	jmp    8010805a <alltraps>

8010905a <vector240>:
.globl vector240
vector240:
  pushl $0
8010905a:	6a 00                	push   $0x0
  pushl $240
8010905c:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80109061:	e9 f4 ef ff ff       	jmp    8010805a <alltraps>

80109066 <vector241>:
.globl vector241
vector241:
  pushl $0
80109066:	6a 00                	push   $0x0
  pushl $241
80109068:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010906d:	e9 e8 ef ff ff       	jmp    8010805a <alltraps>

80109072 <vector242>:
.globl vector242
vector242:
  pushl $0
80109072:	6a 00                	push   $0x0
  pushl $242
80109074:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80109079:	e9 dc ef ff ff       	jmp    8010805a <alltraps>

8010907e <vector243>:
.globl vector243
vector243:
  pushl $0
8010907e:	6a 00                	push   $0x0
  pushl $243
80109080:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80109085:	e9 d0 ef ff ff       	jmp    8010805a <alltraps>

8010908a <vector244>:
.globl vector244
vector244:
  pushl $0
8010908a:	6a 00                	push   $0x0
  pushl $244
8010908c:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80109091:	e9 c4 ef ff ff       	jmp    8010805a <alltraps>

80109096 <vector245>:
.globl vector245
vector245:
  pushl $0
80109096:	6a 00                	push   $0x0
  pushl $245
80109098:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010909d:	e9 b8 ef ff ff       	jmp    8010805a <alltraps>

801090a2 <vector246>:
.globl vector246
vector246:
  pushl $0
801090a2:	6a 00                	push   $0x0
  pushl $246
801090a4:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801090a9:	e9 ac ef ff ff       	jmp    8010805a <alltraps>

801090ae <vector247>:
.globl vector247
vector247:
  pushl $0
801090ae:	6a 00                	push   $0x0
  pushl $247
801090b0:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801090b5:	e9 a0 ef ff ff       	jmp    8010805a <alltraps>

801090ba <vector248>:
.globl vector248
vector248:
  pushl $0
801090ba:	6a 00                	push   $0x0
  pushl $248
801090bc:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801090c1:	e9 94 ef ff ff       	jmp    8010805a <alltraps>

801090c6 <vector249>:
.globl vector249
vector249:
  pushl $0
801090c6:	6a 00                	push   $0x0
  pushl $249
801090c8:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801090cd:	e9 88 ef ff ff       	jmp    8010805a <alltraps>

801090d2 <vector250>:
.globl vector250
vector250:
  pushl $0
801090d2:	6a 00                	push   $0x0
  pushl $250
801090d4:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801090d9:	e9 7c ef ff ff       	jmp    8010805a <alltraps>

801090de <vector251>:
.globl vector251
vector251:
  pushl $0
801090de:	6a 00                	push   $0x0
  pushl $251
801090e0:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801090e5:	e9 70 ef ff ff       	jmp    8010805a <alltraps>

801090ea <vector252>:
.globl vector252
vector252:
  pushl $0
801090ea:	6a 00                	push   $0x0
  pushl $252
801090ec:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801090f1:	e9 64 ef ff ff       	jmp    8010805a <alltraps>

801090f6 <vector253>:
.globl vector253
vector253:
  pushl $0
801090f6:	6a 00                	push   $0x0
  pushl $253
801090f8:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801090fd:	e9 58 ef ff ff       	jmp    8010805a <alltraps>

80109102 <vector254>:
.globl vector254
vector254:
  pushl $0
80109102:	6a 00                	push   $0x0
  pushl $254
80109104:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80109109:	e9 4c ef ff ff       	jmp    8010805a <alltraps>

8010910e <vector255>:
.globl vector255
vector255:
  pushl $0
8010910e:	6a 00                	push   $0x0
  pushl $255
80109110:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80109115:	e9 40 ef ff ff       	jmp    8010805a <alltraps>

8010911a <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
8010911a:	55                   	push   %ebp
8010911b:	89 e5                	mov    %esp,%ebp
8010911d:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80109120:	8b 45 0c             	mov    0xc(%ebp),%eax
80109123:	83 e8 01             	sub    $0x1,%eax
80109126:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010912a:	8b 45 08             	mov    0x8(%ebp),%eax
8010912d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80109131:	8b 45 08             	mov    0x8(%ebp),%eax
80109134:	c1 e8 10             	shr    $0x10,%eax
80109137:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010913b:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010913e:	0f 01 10             	lgdtl  (%eax)
}
80109141:	90                   	nop
80109142:	c9                   	leave  
80109143:	c3                   	ret    

80109144 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80109144:	55                   	push   %ebp
80109145:	89 e5                	mov    %esp,%ebp
80109147:	83 ec 04             	sub    $0x4,%esp
8010914a:	8b 45 08             	mov    0x8(%ebp),%eax
8010914d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80109151:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109155:	0f 00 d8             	ltr    %ax
}
80109158:	90                   	nop
80109159:	c9                   	leave  
8010915a:	c3                   	ret    

8010915b <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010915b:	55                   	push   %ebp
8010915c:	89 e5                	mov    %esp,%ebp
8010915e:	83 ec 04             	sub    $0x4,%esp
80109161:	8b 45 08             	mov    0x8(%ebp),%eax
80109164:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80109168:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010916c:	8e e8                	mov    %eax,%gs
}
8010916e:	90                   	nop
8010916f:	c9                   	leave  
80109170:	c3                   	ret    

80109171 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80109171:	55                   	push   %ebp
80109172:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80109174:	8b 45 08             	mov    0x8(%ebp),%eax
80109177:	0f 22 d8             	mov    %eax,%cr3
}
8010917a:	90                   	nop
8010917b:	5d                   	pop    %ebp
8010917c:	c3                   	ret    

8010917d <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010917d:	55                   	push   %ebp
8010917e:	89 e5                	mov    %esp,%ebp
80109180:	8b 45 08             	mov    0x8(%ebp),%eax
80109183:	05 00 00 00 80       	add    $0x80000000,%eax
80109188:	5d                   	pop    %ebp
80109189:	c3                   	ret    

8010918a <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010918a:	55                   	push   %ebp
8010918b:	89 e5                	mov    %esp,%ebp
8010918d:	8b 45 08             	mov    0x8(%ebp),%eax
80109190:	05 00 00 00 80       	add    $0x80000000,%eax
80109195:	5d                   	pop    %ebp
80109196:	c3                   	ret    

80109197 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80109197:	55                   	push   %ebp
80109198:	89 e5                	mov    %esp,%ebp
8010919a:	53                   	push   %ebx
8010919b:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010919e:	e8 da 9e ff ff       	call   8010307d <cpunum>
801091a3:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801091a9:	05 80 43 11 80       	add    $0x80114380,%eax
801091ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801091b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091b4:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801091ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091bd:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801091c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091c6:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801091ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091cd:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801091d1:	83 e2 f0             	and    $0xfffffff0,%edx
801091d4:	83 ca 0a             	or     $0xa,%edx
801091d7:	88 50 7d             	mov    %dl,0x7d(%eax)
801091da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091dd:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801091e1:	83 ca 10             	or     $0x10,%edx
801091e4:	88 50 7d             	mov    %dl,0x7d(%eax)
801091e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091ea:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801091ee:	83 e2 9f             	and    $0xffffff9f,%edx
801091f1:	88 50 7d             	mov    %dl,0x7d(%eax)
801091f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091f7:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801091fb:	83 ca 80             	or     $0xffffff80,%edx
801091fe:	88 50 7d             	mov    %dl,0x7d(%eax)
80109201:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109204:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109208:	83 ca 0f             	or     $0xf,%edx
8010920b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010920e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109211:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109215:	83 e2 ef             	and    $0xffffffef,%edx
80109218:	88 50 7e             	mov    %dl,0x7e(%eax)
8010921b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010921e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109222:	83 e2 df             	and    $0xffffffdf,%edx
80109225:	88 50 7e             	mov    %dl,0x7e(%eax)
80109228:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010922b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010922f:	83 ca 40             	or     $0x40,%edx
80109232:	88 50 7e             	mov    %dl,0x7e(%eax)
80109235:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109238:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010923c:	83 ca 80             	or     $0xffffff80,%edx
8010923f:	88 50 7e             	mov    %dl,0x7e(%eax)
80109242:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109245:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80109249:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010924c:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80109253:	ff ff 
80109255:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109258:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010925f:	00 00 
80109261:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109264:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010926b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010926e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109275:	83 e2 f0             	and    $0xfffffff0,%edx
80109278:	83 ca 02             	or     $0x2,%edx
8010927b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109284:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010928b:	83 ca 10             	or     $0x10,%edx
8010928e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109294:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109297:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010929e:	83 e2 9f             	and    $0xffffff9f,%edx
801092a1:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801092a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092aa:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801092b1:	83 ca 80             	or     $0xffffff80,%edx
801092b4:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801092ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092bd:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801092c4:	83 ca 0f             	or     $0xf,%edx
801092c7:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801092cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092d0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801092d7:	83 e2 ef             	and    $0xffffffef,%edx
801092da:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801092e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092e3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801092ea:	83 e2 df             	and    $0xffffffdf,%edx
801092ed:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801092f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092f6:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801092fd:	83 ca 40             	or     $0x40,%edx
80109300:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109309:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109310:	83 ca 80             	or     $0xffffff80,%edx
80109313:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109319:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010931c:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80109323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109326:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010932d:	ff ff 
8010932f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109332:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80109339:	00 00 
8010933b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010933e:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80109345:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109348:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010934f:	83 e2 f0             	and    $0xfffffff0,%edx
80109352:	83 ca 0a             	or     $0xa,%edx
80109355:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010935b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010935e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109365:	83 ca 10             	or     $0x10,%edx
80109368:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010936e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109371:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109378:	83 ca 60             	or     $0x60,%edx
8010937b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109384:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010938b:	83 ca 80             	or     $0xffffff80,%edx
8010938e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109397:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010939e:	83 ca 0f             	or     $0xf,%edx
801093a1:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093aa:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093b1:	83 e2 ef             	and    $0xffffffef,%edx
801093b4:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093bd:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093c4:	83 e2 df             	and    $0xffffffdf,%edx
801093c7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093d0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093d7:	83 ca 40             	or     $0x40,%edx
801093da:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093e3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093ea:	83 ca 80             	or     $0xffffff80,%edx
801093ed:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093f6:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801093fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109400:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80109407:	ff ff 
80109409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010940c:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80109413:	00 00 
80109415:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109418:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010941f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109422:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109429:	83 e2 f0             	and    $0xfffffff0,%edx
8010942c:	83 ca 02             	or     $0x2,%edx
8010942f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109435:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109438:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010943f:	83 ca 10             	or     $0x10,%edx
80109442:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109448:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010944b:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109452:	83 ca 60             	or     $0x60,%edx
80109455:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010945b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010945e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109465:	83 ca 80             	or     $0xffffff80,%edx
80109468:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010946e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109471:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109478:	83 ca 0f             	or     $0xf,%edx
8010947b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109481:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109484:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010948b:	83 e2 ef             	and    $0xffffffef,%edx
8010948e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109494:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109497:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010949e:	83 e2 df             	and    $0xffffffdf,%edx
801094a1:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094aa:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094b1:	83 ca 40             	or     $0x40,%edx
801094b4:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094bd:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094c4:	83 ca 80             	or     $0xffffff80,%edx
801094c7:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094d0:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801094d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094da:	05 b4 00 00 00       	add    $0xb4,%eax
801094df:	89 c3                	mov    %eax,%ebx
801094e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094e4:	05 b4 00 00 00       	add    $0xb4,%eax
801094e9:	c1 e8 10             	shr    $0x10,%eax
801094ec:	89 c2                	mov    %eax,%edx
801094ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094f1:	05 b4 00 00 00       	add    $0xb4,%eax
801094f6:	c1 e8 18             	shr    $0x18,%eax
801094f9:	89 c1                	mov    %eax,%ecx
801094fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094fe:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80109505:	00 00 
80109507:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010950a:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80109511:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109514:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
8010951a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010951d:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109524:	83 e2 f0             	and    $0xfffffff0,%edx
80109527:	83 ca 02             	or     $0x2,%edx
8010952a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109530:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109533:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010953a:	83 ca 10             	or     $0x10,%edx
8010953d:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109546:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010954d:	83 e2 9f             	and    $0xffffff9f,%edx
80109550:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109556:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109559:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109560:	83 ca 80             	or     $0xffffff80,%edx
80109563:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109569:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010956c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109573:	83 e2 f0             	and    $0xfffffff0,%edx
80109576:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010957c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010957f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109586:	83 e2 ef             	and    $0xffffffef,%edx
80109589:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010958f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109592:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109599:	83 e2 df             	and    $0xffffffdf,%edx
8010959c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095a5:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801095ac:	83 ca 40             	or     $0x40,%edx
801095af:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095b8:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801095bf:	83 ca 80             	or     $0xffffff80,%edx
801095c2:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095cb:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801095d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095d4:	83 c0 70             	add    $0x70,%eax
801095d7:	83 ec 08             	sub    $0x8,%esp
801095da:	6a 38                	push   $0x38
801095dc:	50                   	push   %eax
801095dd:	e8 38 fb ff ff       	call   8010911a <lgdt>
801095e2:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
801095e5:	83 ec 0c             	sub    $0xc,%esp
801095e8:	6a 18                	push   $0x18
801095ea:	e8 6c fb ff ff       	call   8010915b <loadgs>
801095ef:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
801095f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f5:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801095fb:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80109602:	00 00 00 00 
}
80109606:	90                   	nop
80109607:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010960a:	c9                   	leave  
8010960b:	c3                   	ret    

8010960c <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010960c:	55                   	push   %ebp
8010960d:	89 e5                	mov    %esp,%ebp
8010960f:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80109612:	8b 45 0c             	mov    0xc(%ebp),%eax
80109615:	c1 e8 16             	shr    $0x16,%eax
80109618:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010961f:	8b 45 08             	mov    0x8(%ebp),%eax
80109622:	01 d0                	add    %edx,%eax
80109624:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80109627:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010962a:	8b 00                	mov    (%eax),%eax
8010962c:	83 e0 01             	and    $0x1,%eax
8010962f:	85 c0                	test   %eax,%eax
80109631:	74 18                	je     8010964b <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80109633:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109636:	8b 00                	mov    (%eax),%eax
80109638:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010963d:	50                   	push   %eax
8010963e:	e8 47 fb ff ff       	call   8010918a <p2v>
80109643:	83 c4 04             	add    $0x4,%esp
80109646:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109649:	eb 48                	jmp    80109693 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010964b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010964f:	74 0e                	je     8010965f <walkpgdir+0x53>
80109651:	e8 c1 96 ff ff       	call   80102d17 <kalloc>
80109656:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109659:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010965d:	75 07                	jne    80109666 <walkpgdir+0x5a>
      return 0;
8010965f:	b8 00 00 00 00       	mov    $0x0,%eax
80109664:	eb 44                	jmp    801096aa <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80109666:	83 ec 04             	sub    $0x4,%esp
80109669:	68 00 10 00 00       	push   $0x1000
8010966e:	6a 00                	push   $0x0
80109670:	ff 75 f4             	pushl  -0xc(%ebp)
80109673:	e8 38 d4 ff ff       	call   80106ab0 <memset>
80109678:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
8010967b:	83 ec 0c             	sub    $0xc,%esp
8010967e:	ff 75 f4             	pushl  -0xc(%ebp)
80109681:	e8 f7 fa ff ff       	call   8010917d <v2p>
80109686:	83 c4 10             	add    $0x10,%esp
80109689:	83 c8 07             	or     $0x7,%eax
8010968c:	89 c2                	mov    %eax,%edx
8010968e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109691:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80109693:	8b 45 0c             	mov    0xc(%ebp),%eax
80109696:	c1 e8 0c             	shr    $0xc,%eax
80109699:	25 ff 03 00 00       	and    $0x3ff,%eax
8010969e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801096a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096a8:	01 d0                	add    %edx,%eax
}
801096aa:	c9                   	leave  
801096ab:	c3                   	ret    

801096ac <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801096ac:	55                   	push   %ebp
801096ad:	89 e5                	mov    %esp,%ebp
801096af:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801096b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801096b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801096bd:	8b 55 0c             	mov    0xc(%ebp),%edx
801096c0:	8b 45 10             	mov    0x10(%ebp),%eax
801096c3:	01 d0                	add    %edx,%eax
801096c5:	83 e8 01             	sub    $0x1,%eax
801096c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801096d0:	83 ec 04             	sub    $0x4,%esp
801096d3:	6a 01                	push   $0x1
801096d5:	ff 75 f4             	pushl  -0xc(%ebp)
801096d8:	ff 75 08             	pushl  0x8(%ebp)
801096db:	e8 2c ff ff ff       	call   8010960c <walkpgdir>
801096e0:	83 c4 10             	add    $0x10,%esp
801096e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801096e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801096ea:	75 07                	jne    801096f3 <mappages+0x47>
      return -1;
801096ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801096f1:	eb 47                	jmp    8010973a <mappages+0x8e>
    if(*pte & PTE_P)
801096f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801096f6:	8b 00                	mov    (%eax),%eax
801096f8:	83 e0 01             	and    $0x1,%eax
801096fb:	85 c0                	test   %eax,%eax
801096fd:	74 0d                	je     8010970c <mappages+0x60>
      panic("remap");
801096ff:	83 ec 0c             	sub    $0xc,%esp
80109702:	68 78 ac 10 80       	push   $0x8010ac78
80109707:	e8 5a 6e ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
8010970c:	8b 45 18             	mov    0x18(%ebp),%eax
8010970f:	0b 45 14             	or     0x14(%ebp),%eax
80109712:	83 c8 01             	or     $0x1,%eax
80109715:	89 c2                	mov    %eax,%edx
80109717:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010971a:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010971c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010971f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109722:	74 10                	je     80109734 <mappages+0x88>
      break;
    a += PGSIZE;
80109724:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
8010972b:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80109732:	eb 9c                	jmp    801096d0 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80109734:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80109735:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010973a:	c9                   	leave  
8010973b:	c3                   	ret    

8010973c <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010973c:	55                   	push   %ebp
8010973d:	89 e5                	mov    %esp,%ebp
8010973f:	53                   	push   %ebx
80109740:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80109743:	e8 cf 95 ff ff       	call   80102d17 <kalloc>
80109748:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010974b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010974f:	75 0a                	jne    8010975b <setupkvm+0x1f>
    return 0;
80109751:	b8 00 00 00 00       	mov    $0x0,%eax
80109756:	e9 8e 00 00 00       	jmp    801097e9 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
8010975b:	83 ec 04             	sub    $0x4,%esp
8010975e:	68 00 10 00 00       	push   $0x1000
80109763:	6a 00                	push   $0x0
80109765:	ff 75 f0             	pushl  -0x10(%ebp)
80109768:	e8 43 d3 ff ff       	call   80106ab0 <memset>
8010976d:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80109770:	83 ec 0c             	sub    $0xc,%esp
80109773:	68 00 00 00 0e       	push   $0xe000000
80109778:	e8 0d fa ff ff       	call   8010918a <p2v>
8010977d:	83 c4 10             	add    $0x10,%esp
80109780:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80109785:	76 0d                	jbe    80109794 <setupkvm+0x58>
    panic("PHYSTOP too high");
80109787:	83 ec 0c             	sub    $0xc,%esp
8010978a:	68 7e ac 10 80       	push   $0x8010ac7e
8010978f:	e8 d2 6d ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109794:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
8010979b:	eb 40                	jmp    801097dd <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010979d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097a0:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801097a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097a6:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801097a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097ac:	8b 58 08             	mov    0x8(%eax),%ebx
801097af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097b2:	8b 40 04             	mov    0x4(%eax),%eax
801097b5:	29 c3                	sub    %eax,%ebx
801097b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097ba:	8b 00                	mov    (%eax),%eax
801097bc:	83 ec 0c             	sub    $0xc,%esp
801097bf:	51                   	push   %ecx
801097c0:	52                   	push   %edx
801097c1:	53                   	push   %ebx
801097c2:	50                   	push   %eax
801097c3:	ff 75 f0             	pushl  -0x10(%ebp)
801097c6:	e8 e1 fe ff ff       	call   801096ac <mappages>
801097cb:	83 c4 20             	add    $0x20,%esp
801097ce:	85 c0                	test   %eax,%eax
801097d0:	79 07                	jns    801097d9 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801097d2:	b8 00 00 00 00       	mov    $0x0,%eax
801097d7:	eb 10                	jmp    801097e9 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801097d9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801097dd:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
801097e4:	72 b7                	jb     8010979d <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801097e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801097e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801097ec:	c9                   	leave  
801097ed:	c3                   	ret    

801097ee <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801097ee:	55                   	push   %ebp
801097ef:	89 e5                	mov    %esp,%ebp
801097f1:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801097f4:	e8 43 ff ff ff       	call   8010973c <setupkvm>
801097f9:	a3 58 79 11 80       	mov    %eax,0x80117958
  switchkvm();
801097fe:	e8 03 00 00 00       	call   80109806 <switchkvm>
}
80109803:	90                   	nop
80109804:	c9                   	leave  
80109805:	c3                   	ret    

80109806 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109806:	55                   	push   %ebp
80109807:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109809:	a1 58 79 11 80       	mov    0x80117958,%eax
8010980e:	50                   	push   %eax
8010980f:	e8 69 f9 ff ff       	call   8010917d <v2p>
80109814:	83 c4 04             	add    $0x4,%esp
80109817:	50                   	push   %eax
80109818:	e8 54 f9 ff ff       	call   80109171 <lcr3>
8010981d:	83 c4 04             	add    $0x4,%esp
}
80109820:	90                   	nop
80109821:	c9                   	leave  
80109822:	c3                   	ret    

80109823 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80109823:	55                   	push   %ebp
80109824:	89 e5                	mov    %esp,%ebp
80109826:	56                   	push   %esi
80109827:	53                   	push   %ebx
  pushcli();
80109828:	e8 7d d1 ff ff       	call   801069aa <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010982d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109833:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010983a:	83 c2 08             	add    $0x8,%edx
8010983d:	89 d6                	mov    %edx,%esi
8010983f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109846:	83 c2 08             	add    $0x8,%edx
80109849:	c1 ea 10             	shr    $0x10,%edx
8010984c:	89 d3                	mov    %edx,%ebx
8010984e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109855:	83 c2 08             	add    $0x8,%edx
80109858:	c1 ea 18             	shr    $0x18,%edx
8010985b:	89 d1                	mov    %edx,%ecx
8010985d:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80109864:	67 00 
80109866:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
8010986d:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80109873:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010987a:	83 e2 f0             	and    $0xfffffff0,%edx
8010987d:	83 ca 09             	or     $0x9,%edx
80109880:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109886:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010988d:	83 ca 10             	or     $0x10,%edx
80109890:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109896:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010989d:	83 e2 9f             	and    $0xffffff9f,%edx
801098a0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801098a6:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801098ad:	83 ca 80             	or     $0xffffff80,%edx
801098b0:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801098b6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098bd:	83 e2 f0             	and    $0xfffffff0,%edx
801098c0:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801098c6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098cd:	83 e2 ef             	and    $0xffffffef,%edx
801098d0:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801098d6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098dd:	83 e2 df             	and    $0xffffffdf,%edx
801098e0:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801098e6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098ed:	83 ca 40             	or     $0x40,%edx
801098f0:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801098f6:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098fd:	83 e2 7f             	and    $0x7f,%edx
80109900:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109906:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010990c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109912:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109919:	83 e2 ef             	and    $0xffffffef,%edx
8010991c:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109922:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109928:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010992e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109934:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010993b:	8b 52 08             	mov    0x8(%edx),%edx
8010993e:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109944:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109947:	83 ec 0c             	sub    $0xc,%esp
8010994a:	6a 30                	push   $0x30
8010994c:	e8 f3 f7 ff ff       	call   80109144 <ltr>
80109951:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109954:	8b 45 08             	mov    0x8(%ebp),%eax
80109957:	8b 40 04             	mov    0x4(%eax),%eax
8010995a:	85 c0                	test   %eax,%eax
8010995c:	75 0d                	jne    8010996b <switchuvm+0x148>
    panic("switchuvm: no pgdir");
8010995e:	83 ec 0c             	sub    $0xc,%esp
80109961:	68 8f ac 10 80       	push   $0x8010ac8f
80109966:	e8 fb 6b ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010996b:	8b 45 08             	mov    0x8(%ebp),%eax
8010996e:	8b 40 04             	mov    0x4(%eax),%eax
80109971:	83 ec 0c             	sub    $0xc,%esp
80109974:	50                   	push   %eax
80109975:	e8 03 f8 ff ff       	call   8010917d <v2p>
8010997a:	83 c4 10             	add    $0x10,%esp
8010997d:	83 ec 0c             	sub    $0xc,%esp
80109980:	50                   	push   %eax
80109981:	e8 eb f7 ff ff       	call   80109171 <lcr3>
80109986:	83 c4 10             	add    $0x10,%esp
  popcli();
80109989:	e8 61 d0 ff ff       	call   801069ef <popcli>
}
8010998e:	90                   	nop
8010998f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109992:	5b                   	pop    %ebx
80109993:	5e                   	pop    %esi
80109994:	5d                   	pop    %ebp
80109995:	c3                   	ret    

80109996 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109996:	55                   	push   %ebp
80109997:	89 e5                	mov    %esp,%ebp
80109999:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010999c:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801099a3:	76 0d                	jbe    801099b2 <inituvm+0x1c>
    panic("inituvm: more than a page");
801099a5:	83 ec 0c             	sub    $0xc,%esp
801099a8:	68 a3 ac 10 80       	push   $0x8010aca3
801099ad:	e8 b4 6b ff ff       	call   80100566 <panic>
  mem = kalloc();
801099b2:	e8 60 93 ff ff       	call   80102d17 <kalloc>
801099b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801099ba:	83 ec 04             	sub    $0x4,%esp
801099bd:	68 00 10 00 00       	push   $0x1000
801099c2:	6a 00                	push   $0x0
801099c4:	ff 75 f4             	pushl  -0xc(%ebp)
801099c7:	e8 e4 d0 ff ff       	call   80106ab0 <memset>
801099cc:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801099cf:	83 ec 0c             	sub    $0xc,%esp
801099d2:	ff 75 f4             	pushl  -0xc(%ebp)
801099d5:	e8 a3 f7 ff ff       	call   8010917d <v2p>
801099da:	83 c4 10             	add    $0x10,%esp
801099dd:	83 ec 0c             	sub    $0xc,%esp
801099e0:	6a 06                	push   $0x6
801099e2:	50                   	push   %eax
801099e3:	68 00 10 00 00       	push   $0x1000
801099e8:	6a 00                	push   $0x0
801099ea:	ff 75 08             	pushl  0x8(%ebp)
801099ed:	e8 ba fc ff ff       	call   801096ac <mappages>
801099f2:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801099f5:	83 ec 04             	sub    $0x4,%esp
801099f8:	ff 75 10             	pushl  0x10(%ebp)
801099fb:	ff 75 0c             	pushl  0xc(%ebp)
801099fe:	ff 75 f4             	pushl  -0xc(%ebp)
80109a01:	e8 69 d1 ff ff       	call   80106b6f <memmove>
80109a06:	83 c4 10             	add    $0x10,%esp
}
80109a09:	90                   	nop
80109a0a:	c9                   	leave  
80109a0b:	c3                   	ret    

80109a0c <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80109a0c:	55                   	push   %ebp
80109a0d:	89 e5                	mov    %esp,%ebp
80109a0f:	53                   	push   %ebx
80109a10:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109a13:	8b 45 0c             	mov    0xc(%ebp),%eax
80109a16:	25 ff 0f 00 00       	and    $0xfff,%eax
80109a1b:	85 c0                	test   %eax,%eax
80109a1d:	74 0d                	je     80109a2c <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80109a1f:	83 ec 0c             	sub    $0xc,%esp
80109a22:	68 c0 ac 10 80       	push   $0x8010acc0
80109a27:	e8 3a 6b ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109a2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109a33:	e9 95 00 00 00       	jmp    80109acd <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109a38:	8b 55 0c             	mov    0xc(%ebp),%edx
80109a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a3e:	01 d0                	add    %edx,%eax
80109a40:	83 ec 04             	sub    $0x4,%esp
80109a43:	6a 00                	push   $0x0
80109a45:	50                   	push   %eax
80109a46:	ff 75 08             	pushl  0x8(%ebp)
80109a49:	e8 be fb ff ff       	call   8010960c <walkpgdir>
80109a4e:	83 c4 10             	add    $0x10,%esp
80109a51:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109a54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109a58:	75 0d                	jne    80109a67 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109a5a:	83 ec 0c             	sub    $0xc,%esp
80109a5d:	68 e3 ac 10 80       	push   $0x8010ace3
80109a62:	e8 ff 6a ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109a67:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a6a:	8b 00                	mov    (%eax),%eax
80109a6c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109a71:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109a74:	8b 45 18             	mov    0x18(%ebp),%eax
80109a77:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109a7a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109a7f:	77 0b                	ja     80109a8c <loaduvm+0x80>
      n = sz - i;
80109a81:	8b 45 18             	mov    0x18(%ebp),%eax
80109a84:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109a87:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109a8a:	eb 07                	jmp    80109a93 <loaduvm+0x87>
    else
      n = PGSIZE;
80109a8c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109a93:	8b 55 14             	mov    0x14(%ebp),%edx
80109a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a99:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109a9c:	83 ec 0c             	sub    $0xc,%esp
80109a9f:	ff 75 e8             	pushl  -0x18(%ebp)
80109aa2:	e8 e3 f6 ff ff       	call   8010918a <p2v>
80109aa7:	83 c4 10             	add    $0x10,%esp
80109aaa:	ff 75 f0             	pushl  -0x10(%ebp)
80109aad:	53                   	push   %ebx
80109aae:	50                   	push   %eax
80109aaf:	ff 75 10             	pushl  0x10(%ebp)
80109ab2:	e8 d2 84 ff ff       	call   80101f89 <readi>
80109ab7:	83 c4 10             	add    $0x10,%esp
80109aba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109abd:	74 07                	je     80109ac6 <loaduvm+0xba>
      return -1;
80109abf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109ac4:	eb 18                	jmp    80109ade <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109ac6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ad0:	3b 45 18             	cmp    0x18(%ebp),%eax
80109ad3:	0f 82 5f ff ff ff    	jb     80109a38 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109ae1:	c9                   	leave  
80109ae2:	c3                   	ret    

80109ae3 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109ae3:	55                   	push   %ebp
80109ae4:	89 e5                	mov    %esp,%ebp
80109ae6:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109ae9:	8b 45 10             	mov    0x10(%ebp),%eax
80109aec:	85 c0                	test   %eax,%eax
80109aee:	79 0a                	jns    80109afa <allocuvm+0x17>
    return 0;
80109af0:	b8 00 00 00 00       	mov    $0x0,%eax
80109af5:	e9 b0 00 00 00       	jmp    80109baa <allocuvm+0xc7>
  if(newsz < oldsz)
80109afa:	8b 45 10             	mov    0x10(%ebp),%eax
80109afd:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109b00:	73 08                	jae    80109b0a <allocuvm+0x27>
    return oldsz;
80109b02:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b05:	e9 a0 00 00 00       	jmp    80109baa <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b0d:	05 ff 0f 00 00       	add    $0xfff,%eax
80109b12:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109b1a:	eb 7f                	jmp    80109b9b <allocuvm+0xb8>
    mem = kalloc();
80109b1c:	e8 f6 91 ff ff       	call   80102d17 <kalloc>
80109b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109b24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109b28:	75 2b                	jne    80109b55 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109b2a:	83 ec 0c             	sub    $0xc,%esp
80109b2d:	68 01 ad 10 80       	push   $0x8010ad01
80109b32:	e8 8f 68 ff ff       	call   801003c6 <cprintf>
80109b37:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109b3a:	83 ec 04             	sub    $0x4,%esp
80109b3d:	ff 75 0c             	pushl  0xc(%ebp)
80109b40:	ff 75 10             	pushl  0x10(%ebp)
80109b43:	ff 75 08             	pushl  0x8(%ebp)
80109b46:	e8 61 00 00 00       	call   80109bac <deallocuvm>
80109b4b:	83 c4 10             	add    $0x10,%esp
      return 0;
80109b4e:	b8 00 00 00 00       	mov    $0x0,%eax
80109b53:	eb 55                	jmp    80109baa <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109b55:	83 ec 04             	sub    $0x4,%esp
80109b58:	68 00 10 00 00       	push   $0x1000
80109b5d:	6a 00                	push   $0x0
80109b5f:	ff 75 f0             	pushl  -0x10(%ebp)
80109b62:	e8 49 cf ff ff       	call   80106ab0 <memset>
80109b67:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109b6a:	83 ec 0c             	sub    $0xc,%esp
80109b6d:	ff 75 f0             	pushl  -0x10(%ebp)
80109b70:	e8 08 f6 ff ff       	call   8010917d <v2p>
80109b75:	83 c4 10             	add    $0x10,%esp
80109b78:	89 c2                	mov    %eax,%edx
80109b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b7d:	83 ec 0c             	sub    $0xc,%esp
80109b80:	6a 06                	push   $0x6
80109b82:	52                   	push   %edx
80109b83:	68 00 10 00 00       	push   $0x1000
80109b88:	50                   	push   %eax
80109b89:	ff 75 08             	pushl  0x8(%ebp)
80109b8c:	e8 1b fb ff ff       	call   801096ac <mappages>
80109b91:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109b94:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b9e:	3b 45 10             	cmp    0x10(%ebp),%eax
80109ba1:	0f 82 75 ff ff ff    	jb     80109b1c <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109ba7:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109baa:	c9                   	leave  
80109bab:	c3                   	ret    

80109bac <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109bac:	55                   	push   %ebp
80109bad:	89 e5                	mov    %esp,%ebp
80109baf:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109bb2:	8b 45 10             	mov    0x10(%ebp),%eax
80109bb5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109bb8:	72 08                	jb     80109bc2 <deallocuvm+0x16>
    return oldsz;
80109bba:	8b 45 0c             	mov    0xc(%ebp),%eax
80109bbd:	e9 a5 00 00 00       	jmp    80109c67 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109bc2:	8b 45 10             	mov    0x10(%ebp),%eax
80109bc5:	05 ff 0f 00 00       	add    $0xfff,%eax
80109bca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109bd2:	e9 81 00 00 00       	jmp    80109c58 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bda:	83 ec 04             	sub    $0x4,%esp
80109bdd:	6a 00                	push   $0x0
80109bdf:	50                   	push   %eax
80109be0:	ff 75 08             	pushl  0x8(%ebp)
80109be3:	e8 24 fa ff ff       	call   8010960c <walkpgdir>
80109be8:	83 c4 10             	add    $0x10,%esp
80109beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109bee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109bf2:	75 09                	jne    80109bfd <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109bf4:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109bfb:	eb 54                	jmp    80109c51 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c00:	8b 00                	mov    (%eax),%eax
80109c02:	83 e0 01             	and    $0x1,%eax
80109c05:	85 c0                	test   %eax,%eax
80109c07:	74 48                	je     80109c51 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c0c:	8b 00                	mov    (%eax),%eax
80109c0e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109c13:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109c16:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109c1a:	75 0d                	jne    80109c29 <deallocuvm+0x7d>
        panic("kfree");
80109c1c:	83 ec 0c             	sub    $0xc,%esp
80109c1f:	68 19 ad 10 80       	push   $0x8010ad19
80109c24:	e8 3d 69 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109c29:	83 ec 0c             	sub    $0xc,%esp
80109c2c:	ff 75 ec             	pushl  -0x14(%ebp)
80109c2f:	e8 56 f5 ff ff       	call   8010918a <p2v>
80109c34:	83 c4 10             	add    $0x10,%esp
80109c37:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109c3a:	83 ec 0c             	sub    $0xc,%esp
80109c3d:	ff 75 e8             	pushl  -0x18(%ebp)
80109c40:	e8 35 90 ff ff       	call   80102c7a <kfree>
80109c45:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109c48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c4b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109c51:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c5b:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109c5e:	0f 82 73 ff ff ff    	jb     80109bd7 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109c64:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109c67:	c9                   	leave  
80109c68:	c3                   	ret    

80109c69 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109c69:	55                   	push   %ebp
80109c6a:	89 e5                	mov    %esp,%ebp
80109c6c:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109c6f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109c73:	75 0d                	jne    80109c82 <freevm+0x19>
    panic("freevm: no pgdir");
80109c75:	83 ec 0c             	sub    $0xc,%esp
80109c78:	68 1f ad 10 80       	push   $0x8010ad1f
80109c7d:	e8 e4 68 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109c82:	83 ec 04             	sub    $0x4,%esp
80109c85:	6a 00                	push   $0x0
80109c87:	68 00 00 00 80       	push   $0x80000000
80109c8c:	ff 75 08             	pushl  0x8(%ebp)
80109c8f:	e8 18 ff ff ff       	call   80109bac <deallocuvm>
80109c94:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109c97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109c9e:	eb 4f                	jmp    80109cef <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ca3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109caa:	8b 45 08             	mov    0x8(%ebp),%eax
80109cad:	01 d0                	add    %edx,%eax
80109caf:	8b 00                	mov    (%eax),%eax
80109cb1:	83 e0 01             	and    $0x1,%eax
80109cb4:	85 c0                	test   %eax,%eax
80109cb6:	74 33                	je     80109ceb <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cbb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109cc2:	8b 45 08             	mov    0x8(%ebp),%eax
80109cc5:	01 d0                	add    %edx,%eax
80109cc7:	8b 00                	mov    (%eax),%eax
80109cc9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109cce:	83 ec 0c             	sub    $0xc,%esp
80109cd1:	50                   	push   %eax
80109cd2:	e8 b3 f4 ff ff       	call   8010918a <p2v>
80109cd7:	83 c4 10             	add    $0x10,%esp
80109cda:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109cdd:	83 ec 0c             	sub    $0xc,%esp
80109ce0:	ff 75 f0             	pushl  -0x10(%ebp)
80109ce3:	e8 92 8f ff ff       	call   80102c7a <kfree>
80109ce8:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109ceb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109cef:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109cf6:	76 a8                	jbe    80109ca0 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109cf8:	83 ec 0c             	sub    $0xc,%esp
80109cfb:	ff 75 08             	pushl  0x8(%ebp)
80109cfe:	e8 77 8f ff ff       	call   80102c7a <kfree>
80109d03:	83 c4 10             	add    $0x10,%esp
}
80109d06:	90                   	nop
80109d07:	c9                   	leave  
80109d08:	c3                   	ret    

80109d09 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109d09:	55                   	push   %ebp
80109d0a:	89 e5                	mov    %esp,%ebp
80109d0c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109d0f:	83 ec 04             	sub    $0x4,%esp
80109d12:	6a 00                	push   $0x0
80109d14:	ff 75 0c             	pushl  0xc(%ebp)
80109d17:	ff 75 08             	pushl  0x8(%ebp)
80109d1a:	e8 ed f8 ff ff       	call   8010960c <walkpgdir>
80109d1f:	83 c4 10             	add    $0x10,%esp
80109d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109d25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109d29:	75 0d                	jne    80109d38 <clearpteu+0x2f>
    panic("clearpteu");
80109d2b:	83 ec 0c             	sub    $0xc,%esp
80109d2e:	68 30 ad 10 80       	push   $0x8010ad30
80109d33:	e8 2e 68 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d3b:	8b 00                	mov    (%eax),%eax
80109d3d:	83 e0 fb             	and    $0xfffffffb,%eax
80109d40:	89 c2                	mov    %eax,%edx
80109d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d45:	89 10                	mov    %edx,(%eax)
}
80109d47:	90                   	nop
80109d48:	c9                   	leave  
80109d49:	c3                   	ret    

80109d4a <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109d4a:	55                   	push   %ebp
80109d4b:	89 e5                	mov    %esp,%ebp
80109d4d:	53                   	push   %ebx
80109d4e:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109d51:	e8 e6 f9 ff ff       	call   8010973c <setupkvm>
80109d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109d59:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109d5d:	75 0a                	jne    80109d69 <copyuvm+0x1f>
    return 0;
80109d5f:	b8 00 00 00 00       	mov    $0x0,%eax
80109d64:	e9 f8 00 00 00       	jmp    80109e61 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109d69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109d70:	e9 c4 00 00 00       	jmp    80109e39 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d78:	83 ec 04             	sub    $0x4,%esp
80109d7b:	6a 00                	push   $0x0
80109d7d:	50                   	push   %eax
80109d7e:	ff 75 08             	pushl  0x8(%ebp)
80109d81:	e8 86 f8 ff ff       	call   8010960c <walkpgdir>
80109d86:	83 c4 10             	add    $0x10,%esp
80109d89:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109d8c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109d90:	75 0d                	jne    80109d9f <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109d92:	83 ec 0c             	sub    $0xc,%esp
80109d95:	68 3a ad 10 80       	push   $0x8010ad3a
80109d9a:	e8 c7 67 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109d9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109da2:	8b 00                	mov    (%eax),%eax
80109da4:	83 e0 01             	and    $0x1,%eax
80109da7:	85 c0                	test   %eax,%eax
80109da9:	75 0d                	jne    80109db8 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109dab:	83 ec 0c             	sub    $0xc,%esp
80109dae:	68 54 ad 10 80       	push   $0x8010ad54
80109db3:	e8 ae 67 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109db8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109dbb:	8b 00                	mov    (%eax),%eax
80109dbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109dc2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109dc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109dc8:	8b 00                	mov    (%eax),%eax
80109dca:	25 ff 0f 00 00       	and    $0xfff,%eax
80109dcf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109dd2:	e8 40 8f ff ff       	call   80102d17 <kalloc>
80109dd7:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109dda:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109dde:	74 6a                	je     80109e4a <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109de0:	83 ec 0c             	sub    $0xc,%esp
80109de3:	ff 75 e8             	pushl  -0x18(%ebp)
80109de6:	e8 9f f3 ff ff       	call   8010918a <p2v>
80109deb:	83 c4 10             	add    $0x10,%esp
80109dee:	83 ec 04             	sub    $0x4,%esp
80109df1:	68 00 10 00 00       	push   $0x1000
80109df6:	50                   	push   %eax
80109df7:	ff 75 e0             	pushl  -0x20(%ebp)
80109dfa:	e8 70 cd ff ff       	call   80106b6f <memmove>
80109dff:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109e02:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109e05:	83 ec 0c             	sub    $0xc,%esp
80109e08:	ff 75 e0             	pushl  -0x20(%ebp)
80109e0b:	e8 6d f3 ff ff       	call   8010917d <v2p>
80109e10:	83 c4 10             	add    $0x10,%esp
80109e13:	89 c2                	mov    %eax,%edx
80109e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e18:	83 ec 0c             	sub    $0xc,%esp
80109e1b:	53                   	push   %ebx
80109e1c:	52                   	push   %edx
80109e1d:	68 00 10 00 00       	push   $0x1000
80109e22:	50                   	push   %eax
80109e23:	ff 75 f0             	pushl  -0x10(%ebp)
80109e26:	e8 81 f8 ff ff       	call   801096ac <mappages>
80109e2b:	83 c4 20             	add    $0x20,%esp
80109e2e:	85 c0                	test   %eax,%eax
80109e30:	78 1b                	js     80109e4d <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109e32:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e3c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109e3f:	0f 82 30 ff ff ff    	jb     80109d75 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109e45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e48:	eb 17                	jmp    80109e61 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109e4a:	90                   	nop
80109e4b:	eb 01                	jmp    80109e4e <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80109e4d:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80109e4e:	83 ec 0c             	sub    $0xc,%esp
80109e51:	ff 75 f0             	pushl  -0x10(%ebp)
80109e54:	e8 10 fe ff ff       	call   80109c69 <freevm>
80109e59:	83 c4 10             	add    $0x10,%esp
  return 0;
80109e5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109e61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109e64:	c9                   	leave  
80109e65:	c3                   	ret    

80109e66 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109e66:	55                   	push   %ebp
80109e67:	89 e5                	mov    %esp,%ebp
80109e69:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109e6c:	83 ec 04             	sub    $0x4,%esp
80109e6f:	6a 00                	push   $0x0
80109e71:	ff 75 0c             	pushl  0xc(%ebp)
80109e74:	ff 75 08             	pushl  0x8(%ebp)
80109e77:	e8 90 f7 ff ff       	call   8010960c <walkpgdir>
80109e7c:	83 c4 10             	add    $0x10,%esp
80109e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e85:	8b 00                	mov    (%eax),%eax
80109e87:	83 e0 01             	and    $0x1,%eax
80109e8a:	85 c0                	test   %eax,%eax
80109e8c:	75 07                	jne    80109e95 <uva2ka+0x2f>
    return 0;
80109e8e:	b8 00 00 00 00       	mov    $0x0,%eax
80109e93:	eb 29                	jmp    80109ebe <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e98:	8b 00                	mov    (%eax),%eax
80109e9a:	83 e0 04             	and    $0x4,%eax
80109e9d:	85 c0                	test   %eax,%eax
80109e9f:	75 07                	jne    80109ea8 <uva2ka+0x42>
    return 0;
80109ea1:	b8 00 00 00 00       	mov    $0x0,%eax
80109ea6:	eb 16                	jmp    80109ebe <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80109ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109eab:	8b 00                	mov    (%eax),%eax
80109ead:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109eb2:	83 ec 0c             	sub    $0xc,%esp
80109eb5:	50                   	push   %eax
80109eb6:	e8 cf f2 ff ff       	call   8010918a <p2v>
80109ebb:	83 c4 10             	add    $0x10,%esp
}
80109ebe:	c9                   	leave  
80109ebf:	c3                   	ret    

80109ec0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109ec0:	55                   	push   %ebp
80109ec1:	89 e5                	mov    %esp,%ebp
80109ec3:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109ec6:	8b 45 10             	mov    0x10(%ebp),%eax
80109ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109ecc:	eb 7f                	jmp    80109f4d <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80109ece:	8b 45 0c             	mov    0xc(%ebp),%eax
80109ed1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109ed6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109edc:	83 ec 08             	sub    $0x8,%esp
80109edf:	50                   	push   %eax
80109ee0:	ff 75 08             	pushl  0x8(%ebp)
80109ee3:	e8 7e ff ff ff       	call   80109e66 <uva2ka>
80109ee8:	83 c4 10             	add    $0x10,%esp
80109eeb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80109eee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109ef2:	75 07                	jne    80109efb <copyout+0x3b>
      return -1;
80109ef4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109ef9:	eb 61                	jmp    80109f5c <copyout+0x9c>
    n = PGSIZE - (va - va0);
80109efb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109efe:	2b 45 0c             	sub    0xc(%ebp),%eax
80109f01:	05 00 10 00 00       	add    $0x1000,%eax
80109f06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f0c:	3b 45 14             	cmp    0x14(%ebp),%eax
80109f0f:	76 06                	jbe    80109f17 <copyout+0x57>
      n = len;
80109f11:	8b 45 14             	mov    0x14(%ebp),%eax
80109f14:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109f17:	8b 45 0c             	mov    0xc(%ebp),%eax
80109f1a:	2b 45 ec             	sub    -0x14(%ebp),%eax
80109f1d:	89 c2                	mov    %eax,%edx
80109f1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f22:	01 d0                	add    %edx,%eax
80109f24:	83 ec 04             	sub    $0x4,%esp
80109f27:	ff 75 f0             	pushl  -0x10(%ebp)
80109f2a:	ff 75 f4             	pushl  -0xc(%ebp)
80109f2d:	50                   	push   %eax
80109f2e:	e8 3c cc ff ff       	call   80106b6f <memmove>
80109f33:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f39:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80109f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f3f:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109f42:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f45:	05 00 10 00 00       	add    $0x1000,%eax
80109f4a:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109f4d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109f51:	0f 85 77 ff ff ff    	jne    80109ece <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109f57:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109f5c:	c9                   	leave  
80109f5d:	c3                   	ret    
