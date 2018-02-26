
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
8010003d:	68 5c 9f 10 80       	push   $0x80109f5c
80100042:	68 80 e6 10 80       	push   $0x8010e680
80100047:	e8 dd 67 00 00       	call   80106829 <initlock>
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
801000c1:	e8 85 67 00 00       	call   8010684b <acquire>
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
8010010c:	e8 a1 67 00 00       	call   801068b2 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 e6 10 80       	push   $0x8010e680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 6a 54 00 00       	call   80105596 <sleep>
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
80100188:	e8 25 67 00 00       	call   801068b2 <release>
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
801001aa:	68 63 9f 10 80       	push   $0x80109f63
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
80100204:	68 74 9f 10 80       	push   $0x80109f74
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
80100243:	68 7b 9f 10 80       	push   $0x80109f7b
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 e6 10 80       	push   $0x8010e680
80100255:	e8 f1 65 00 00       	call   8010684b <acquire>
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
801002b9:	e8 33 55 00 00       	call   801057f1 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 e6 10 80       	push   $0x8010e680
801002c9:	e8 e4 65 00 00       	call   801068b2 <release>
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
801003e2:	e8 64 64 00 00       	call   8010684b <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 82 9f 10 80       	push   $0x80109f82
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
801004cd:	c7 45 ec 8b 9f 10 80 	movl   $0x80109f8b,-0x14(%ebp)
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
8010055b:	e8 52 63 00 00       	call   801068b2 <release>
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
8010058b:	68 92 9f 10 80       	push   $0x80109f92
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
801005aa:	68 a1 9f 10 80       	push   $0x80109fa1
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 3d 63 00 00       	call   80106904 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 a3 9f 10 80       	push   $0x80109fa3
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
801006ca:	68 a7 9f 10 80       	push   $0x80109fa7
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
801006f7:	e8 71 64 00 00       	call   80106b6d <memmove>
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
80100721:	e8 88 63 00 00       	call   80106aae <memset>
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
801007b6:	e8 2a 7e 00 00       	call   801085e5 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 1d 7e 00 00       	call   801085e5 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 10 7e 00 00       	call   801085e5 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 00 7e 00 00       	call   801085e5 <uartputc>
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
80100815:	e8 31 60 00 00       	call   8010684b <acquire>
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
801009bf:	e8 2d 4e 00 00       	call   801057f1 <wakeup>
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
801009e2:	e8 cb 5e 00 00       	call   801068b2 <release>
801009e7:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009ee:	74 05                	je     801009f5 <consoleintr+0x1fc>
    procdump();  // now call procdump() wo. cons.lock held
801009f0:	e8 8c 51 00 00       	call   80105b81 <procdump>
  }
#ifdef CS333_P3P4
  // run Ready list display function
  if (ctrlkey == 1) {
801009f5:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
801009f9:	75 0c                	jne    80100a07 <consoleintr+0x20e>
      //cprintf("Ready list not implemented yet..\n");
      printReadyList();
801009fb:	e8 a3 57 00 00       	call   801061a3 <printReadyList>
      ctrlkey = 0;
80100a00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Free list display function
  if (ctrlkey == 2) {
80100a07:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
80100a0b:	75 0c                	jne    80100a19 <consoleintr+0x220>
      printFreeList();
80100a0d:	e8 8a 58 00 00       	call   8010629c <printFreeList>
      ctrlkey = 0;
80100a12:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Sleep list display function
  if (ctrlkey == 3) {
80100a19:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
80100a1d:	75 0c                	jne    80100a2b <consoleintr+0x232>
     // cprintf("Sleep list not implemented yet..\n");
      printSleepList();
80100a1f:	e8 d6 58 00 00       	call   801062fa <printSleepList>
      ctrlkey = 0;
80100a24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Zombie list display function
  if (ctrlkey == 4) {
80100a2b:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a2f:	75 0c                	jne    80100a3d <consoleintr+0x244>
      //cprintf("Zombie list not implemented yet..\n");
      printZombieList();
80100a31:	e8 61 59 00 00       	call   80106397 <printZombieList>
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
80100a62:	e8 e4 5d 00 00       	call   8010684b <acquire>
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
80100a84:	e8 29 5e 00 00       	call   801068b2 <release>
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
80100ab1:	e8 e0 4a 00 00       	call   80105596 <sleep>
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
80100b2f:	e8 7e 5d 00 00       	call   801068b2 <release>
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
80100b6d:	e8 d9 5c 00 00       	call   8010684b <acquire>
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
80100baf:	e8 fe 5c 00 00       	call   801068b2 <release>
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
80100bd3:	68 ba 9f 10 80       	push   $0x80109fba
80100bd8:	68 e0 d5 10 80       	push   $0x8010d5e0
80100bdd:	e8 47 5c 00 00       	call   80106829 <initlock>
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
80100c9b:	e8 9a 8a 00 00       	call   8010973a <setupkvm>
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
80100d21:	e8 bb 8d 00 00       	call   80109ae1 <allocuvm>
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
80100d54:	e8 b1 8c 00 00       	call   80109a0a <loaduvm>
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
80100dc3:	e8 19 8d 00 00       	call   80109ae1 <allocuvm>
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
80100de7:	e8 1b 8f 00 00       	call   80109d07 <clearpteu>
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
80100e20:	e8 d6 5e 00 00       	call   80106cfb <strlen>
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
80100e4d:	e8 a9 5e 00 00       	call   80106cfb <strlen>
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
80100e73:	e8 46 90 00 00       	call   80109ebe <copyout>
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
80100f0f:	e8 aa 8f 00 00       	call   80109ebe <copyout>
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
80100f60:	e8 4c 5d 00 00       	call   80106cb1 <safestrcpy>
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
80100fb6:	e8 66 88 00 00       	call   80109821 <switchuvm>
80100fbb:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fbe:	83 ec 0c             	sub    $0xc,%esp
80100fc1:	ff 75 d0             	pushl  -0x30(%ebp)
80100fc4:	e8 9e 8c 00 00       	call   80109c67 <freevm>
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
80100ffe:	e8 64 8c 00 00       	call   80109c67 <freevm>
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
8010102f:	68 c2 9f 10 80       	push   $0x80109fc2
80101034:	68 40 28 11 80       	push   $0x80112840
80101039:	e8 eb 57 00 00       	call   80106829 <initlock>
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
80101052:	e8 f4 57 00 00       	call   8010684b <acquire>
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
8010107f:	e8 2e 58 00 00       	call   801068b2 <release>
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
801010a2:	e8 0b 58 00 00       	call   801068b2 <release>
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
801010bf:	e8 87 57 00 00       	call   8010684b <acquire>
801010c4:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010c7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ca:	8b 40 04             	mov    0x4(%eax),%eax
801010cd:	85 c0                	test   %eax,%eax
801010cf:	7f 0d                	jg     801010de <filedup+0x2d>
    panic("filedup");
801010d1:	83 ec 0c             	sub    $0xc,%esp
801010d4:	68 c9 9f 10 80       	push   $0x80109fc9
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
801010f5:	e8 b8 57 00 00       	call   801068b2 <release>
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
80101110:	e8 36 57 00 00       	call   8010684b <acquire>
80101115:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101118:	8b 45 08             	mov    0x8(%ebp),%eax
8010111b:	8b 40 04             	mov    0x4(%eax),%eax
8010111e:	85 c0                	test   %eax,%eax
80101120:	7f 0d                	jg     8010112f <fileclose+0x2d>
    panic("fileclose");
80101122:	83 ec 0c             	sub    $0xc,%esp
80101125:	68 d1 9f 10 80       	push   $0x80109fd1
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
80101150:	e8 5d 57 00 00       	call   801068b2 <release>
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
8010119e:	e8 0f 57 00 00       	call   801068b2 <release>
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
801012ed:	68 db 9f 10 80       	push   $0x80109fdb
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
801013f0:	68 e4 9f 10 80       	push   $0x80109fe4
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
80101426:	68 f4 9f 10 80       	push   $0x80109ff4
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
8010145e:	e8 0a 57 00 00       	call   80106b6d <memmove>
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
801014a4:	e8 05 56 00 00       	call   80106aae <memset>
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
8010160b:	68 00 a0 10 80       	push   $0x8010a000
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
8010169e:	68 16 a0 10 80       	push   $0x8010a016
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
801016fb:	68 29 a0 10 80       	push   $0x8010a029
80101700:	68 60 32 11 80       	push   $0x80113260
80101705:	e8 1f 51 00 00       	call   80106829 <initlock>
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
80101754:	68 30 a0 10 80       	push   $0x8010a030
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
801017cd:	e8 dc 52 00 00       	call   80106aae <memset>
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
80101835:	68 83 a0 10 80       	push   $0x8010a083
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
801018db:	e8 8d 52 00 00       	call   80106b6d <memmove>
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
80101910:	e8 36 4f 00 00       	call   8010684b <acquire>
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
8010195e:	e8 4f 4f 00 00       	call   801068b2 <release>
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
80101997:	68 95 a0 10 80       	push   $0x8010a095
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
801019d4:	e8 d9 4e 00 00       	call   801068b2 <release>
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
801019ef:	e8 57 4e 00 00       	call   8010684b <acquire>
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
80101a0e:	e8 9f 4e 00 00       	call   801068b2 <release>
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
80101a34:	68 a5 a0 10 80       	push   $0x8010a0a5
80101a39:	e8 28 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a3e:	83 ec 0c             	sub    $0xc,%esp
80101a41:	68 60 32 11 80       	push   $0x80113260
80101a46:	e8 00 4e 00 00       	call   8010684b <acquire>
80101a4b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a4e:	eb 13                	jmp    80101a63 <ilock+0x48>
    sleep(ip, &icache.lock);
80101a50:	83 ec 08             	sub    $0x8,%esp
80101a53:	68 60 32 11 80       	push   $0x80113260
80101a58:	ff 75 08             	pushl  0x8(%ebp)
80101a5b:	e8 36 3b 00 00       	call   80105596 <sleep>
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
80101a89:	e8 24 4e 00 00       	call   801068b2 <release>
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
80101b36:	e8 32 50 00 00       	call   80106b6d <memmove>
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
80101b6c:	68 ab a0 10 80       	push   $0x8010a0ab
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
80101b9f:	68 ba a0 10 80       	push   $0x8010a0ba
80101ba4:	e8 bd e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101ba9:	83 ec 0c             	sub    $0xc,%esp
80101bac:	68 60 32 11 80       	push   $0x80113260
80101bb1:	e8 95 4c 00 00       	call   8010684b <acquire>
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
80101bd0:	e8 1c 3c 00 00       	call   801057f1 <wakeup>
80101bd5:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bd8:	83 ec 0c             	sub    $0xc,%esp
80101bdb:	68 60 32 11 80       	push   $0x80113260
80101be0:	e8 cd 4c 00 00       	call   801068b2 <release>
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
80101bf9:	e8 4d 4c 00 00       	call   8010684b <acquire>
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
80101c41:	68 c2 a0 10 80       	push   $0x8010a0c2
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
80101c64:	e8 49 4c 00 00       	call   801068b2 <release>
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
80101c99:	e8 ad 4b 00 00       	call   8010684b <acquire>
80101c9e:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101ca1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
80101cae:	ff 75 08             	pushl  0x8(%ebp)
80101cb1:	e8 3b 3b 00 00       	call   801057f1 <wakeup>
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
80101cd0:	e8 dd 4b 00 00       	call   801068b2 <release>
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
80101e10:	68 cc a0 10 80       	push   $0x8010a0cc
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
801020a7:	e8 c1 4a 00 00       	call   80106b6d <memmove>
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
801021f9:	e8 6f 49 00 00       	call   80106b6d <memmove>
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
80102279:	e8 85 49 00 00       	call   80106c03 <strncmp>
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
80102299:	68 df a0 10 80       	push   $0x8010a0df
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
801022c8:	68 f1 a0 10 80       	push   $0x8010a0f1
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
8010239d:	68 f1 a0 10 80       	push   $0x8010a0f1
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
801023d8:	e8 7c 48 00 00       	call   80106c59 <strncpy>
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
80102404:	68 fe a0 10 80       	push   $0x8010a0fe
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
8010247a:	e8 ee 46 00 00       	call   80106b6d <memmove>
8010247f:	83 c4 10             	add    $0x10,%esp
80102482:	eb 26                	jmp    801024aa <skipelem+0x95>
  else {
    memmove(name, s, len);
80102484:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102487:	83 ec 04             	sub    $0x4,%esp
8010248a:	50                   	push   %eax
8010248b:	ff 75 f4             	pushl  -0xc(%ebp)
8010248e:	ff 75 0c             	pushl  0xc(%ebp)
80102491:	e8 d7 46 00 00       	call   80106b6d <memmove>
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
801026e6:	68 06 a1 10 80       	push   $0x8010a106
801026eb:	68 20 d6 10 80       	push   $0x8010d620
801026f0:	e8 34 41 00 00       	call   80106829 <initlock>
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
8010279a:	68 0a a1 10 80       	push   $0x8010a10a
8010279f:	e8 c2 dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
801027a4:	8b 45 08             	mov    0x8(%ebp),%eax
801027a7:	8b 40 08             	mov    0x8(%eax),%eax
801027aa:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801027af:	76 0d                	jbe    801027be <idestart+0x33>
    panic("incorrect blockno");
801027b1:	83 ec 0c             	sub    $0xc,%esp
801027b4:	68 13 a1 10 80       	push   $0x8010a113
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
801027dd:	68 0a a1 10 80       	push   $0x8010a10a
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
801028f7:	e8 4f 3f 00 00       	call   8010684b <acquire>
801028fc:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028ff:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102904:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010290b:	75 15                	jne    80102922 <ideintr+0x39>
    release(&idelock);
8010290d:	83 ec 0c             	sub    $0xc,%esp
80102910:	68 20 d6 10 80       	push   $0x8010d620
80102915:	e8 98 3f 00 00       	call   801068b2 <release>
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
8010298a:	e8 62 2e 00 00       	call   801057f1 <wakeup>
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
801029b4:	e8 f9 3e 00 00       	call   801068b2 <release>
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
801029d3:	68 25 a1 10 80       	push   $0x8010a125
801029d8:	e8 89 db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029dd:	8b 45 08             	mov    0x8(%ebp),%eax
801029e0:	8b 00                	mov    (%eax),%eax
801029e2:	83 e0 06             	and    $0x6,%eax
801029e5:	83 f8 02             	cmp    $0x2,%eax
801029e8:	75 0d                	jne    801029f7 <iderw+0x39>
    panic("iderw: nothing to do");
801029ea:	83 ec 0c             	sub    $0xc,%esp
801029ed:	68 39 a1 10 80       	push   $0x8010a139
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
80102a0d:	68 4e a1 10 80       	push   $0x8010a14e
80102a12:	e8 4f db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a17:	83 ec 0c             	sub    $0xc,%esp
80102a1a:	68 20 d6 10 80       	push   $0x8010d620
80102a1f:	e8 27 3e 00 00       	call   8010684b <acquire>
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
80102a7b:	e8 16 2b 00 00       	call   80105596 <sleep>
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
80102a98:	e8 15 3e 00 00       	call   801068b2 <release>
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
80102b29:	68 6c a1 10 80       	push   $0x8010a16c
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
80102be9:	68 9e a1 10 80       	push   $0x8010a19e
80102bee:	68 40 42 11 80       	push   $0x80114240
80102bf3:	e8 31 3c 00 00       	call   80106829 <initlock>
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
80102caa:	68 a3 a1 10 80       	push   $0x8010a1a3
80102caf:	e8 b2 d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102cb4:	83 ec 04             	sub    $0x4,%esp
80102cb7:	68 00 10 00 00       	push   $0x1000
80102cbc:	6a 01                	push   $0x1
80102cbe:	ff 75 08             	pushl  0x8(%ebp)
80102cc1:	e8 e8 3d 00 00       	call   80106aae <memset>
80102cc6:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cc9:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cce:	85 c0                	test   %eax,%eax
80102cd0:	74 10                	je     80102ce2 <kfree+0x68>
    acquire(&kmem.lock);
80102cd2:	83 ec 0c             	sub    $0xc,%esp
80102cd5:	68 40 42 11 80       	push   $0x80114240
80102cda:	e8 6c 3b 00 00       	call   8010684b <acquire>
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
80102d0c:	e8 a1 3b 00 00       	call   801068b2 <release>
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
80102d2e:	e8 18 3b 00 00       	call   8010684b <acquire>
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
80102d5f:	e8 4e 3b 00 00       	call   801068b2 <release>
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
801030aa:	68 ac a1 10 80       	push   $0x8010a1ac
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
801032d5:	e8 3b 38 00 00       	call   80106b15 <memcmp>
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
801033e9:	68 d8 a1 10 80       	push   $0x8010a1d8
801033ee:	68 80 42 11 80       	push   $0x80114280
801033f3:	e8 31 34 00 00       	call   80106829 <initlock>
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
8010349e:	e8 ca 36 00 00       	call   80106b6d <memmove>
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
8010360c:	e8 3a 32 00 00       	call   8010684b <acquire>
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
8010362a:	e8 67 1f 00 00       	call   80105596 <sleep>
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
8010365f:	e8 32 1f 00 00       	call   80105596 <sleep>
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
8010367e:	e8 2f 32 00 00       	call   801068b2 <release>
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
8010369f:	e8 a7 31 00 00       	call   8010684b <acquire>
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
801036c0:	68 dc a1 10 80       	push   $0x8010a1dc
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
801036ee:	e8 fe 20 00 00       	call   801057f1 <wakeup>
801036f3:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036f6:	83 ec 0c             	sub    $0xc,%esp
801036f9:	68 80 42 11 80       	push   $0x80114280
801036fe:	e8 af 31 00 00       	call   801068b2 <release>
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
80103719:	e8 2d 31 00 00       	call   8010684b <acquire>
8010371e:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103721:	c7 05 c0 42 11 80 00 	movl   $0x0,0x801142c0
80103728:	00 00 00 
    wakeup(&log);
8010372b:	83 ec 0c             	sub    $0xc,%esp
8010372e:	68 80 42 11 80       	push   $0x80114280
80103733:	e8 b9 20 00 00       	call   801057f1 <wakeup>
80103738:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	68 80 42 11 80       	push   $0x80114280
80103743:	e8 6a 31 00 00       	call   801068b2 <release>
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
801037bf:	e8 a9 33 00 00       	call   80106b6d <memmove>
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
8010385b:	68 eb a1 10 80       	push   $0x8010a1eb
80103860:	e8 01 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103865:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010386a:	85 c0                	test   %eax,%eax
8010386c:	7f 0d                	jg     8010387b <log_write+0x45>
    panic("log_write outside of trans");
8010386e:	83 ec 0c             	sub    $0xc,%esp
80103871:	68 01 a2 10 80       	push   $0x8010a201
80103876:	e8 eb cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
8010387b:	83 ec 0c             	sub    $0xc,%esp
8010387e:	68 80 42 11 80       	push   $0x80114280
80103883:	e8 c3 2f 00 00       	call   8010684b <acquire>
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
80103901:	e8 ac 2f 00 00       	call   801068b2 <release>
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
80103966:	e8 81 5e 00 00       	call   801097ec <kvmalloc>
  mpinit();        // collect info about this machine
8010396b:	e8 43 04 00 00       	call   80103db3 <mpinit>
  lapicinit();
80103970:	e8 ea f5 ff ff       	call   80102f5f <lapicinit>
  seginit();       // set up segments
80103975:	e8 1b 58 00 00       	call   80109195 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010397a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103980:	0f b6 00             	movzbl (%eax),%eax
80103983:	0f b6 c0             	movzbl %al,%eax
80103986:	83 ec 08             	sub    $0x8,%esp
80103989:	50                   	push   %eax
8010398a:	68 1c a2 10 80       	push   $0x8010a21c
8010398f:	e8 32 ca ff ff       	call   801003c6 <cprintf>
80103994:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103997:	e8 6d 06 00 00       	call   80104009 <picinit>
  ioapicinit();    // another interrupt controller
8010399c:	e8 34 f1 ff ff       	call   80102ad5 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801039a1:	e8 24 d2 ff ff       	call   80100bca <consoleinit>
  uartinit();      // serial port
801039a6:	e8 46 4b 00 00       	call   801084f1 <uartinit>
  pinit();         // process table
801039ab:	e8 5d 0b 00 00       	call   8010450d <pinit>
  tvinit();        // trap vectors
801039b0:	e8 15 47 00 00       	call   801080ca <tvinit>
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
801039cd:	e8 49 46 00 00       	call   8010801b <timerinit>
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
801039fc:	e8 03 5e 00 00       	call   80109804 <switchkvm>
  seginit();
80103a01:	e8 8f 57 00 00       	call   80109195 <seginit>
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
80103a26:	68 33 a2 10 80       	push   $0x8010a233
80103a2b:	e8 96 c9 ff ff       	call   801003c6 <cprintf>
80103a30:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a33:	e8 f3 47 00 00       	call   8010822b <idtinit>
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
80103a7e:	e8 ea 30 00 00       	call   80106b6d <memmove>
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
80103c0c:	68 44 a2 10 80       	push   $0x8010a244
80103c11:	ff 75 f4             	pushl  -0xc(%ebp)
80103c14:	e8 fc 2e 00 00       	call   80106b15 <memcmp>
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
80103d4a:	68 49 a2 10 80       	push   $0x8010a249
80103d4f:	ff 75 f0             	pushl  -0x10(%ebp)
80103d52:	e8 be 2d 00 00       	call   80106b15 <memcmp>
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
80103e26:	8b 04 85 8c a2 10 80 	mov    -0x7fef5d74(,%eax,4),%eax
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
80103e5c:	68 4e a2 10 80       	push   $0x8010a24e
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
80103eef:	68 6c a2 10 80       	push   $0x8010a26c
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
80104190:	68 a0 a2 10 80       	push   $0x8010a2a0
80104195:	50                   	push   %eax
80104196:	e8 8e 26 00 00       	call   80106829 <initlock>
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
80104252:	e8 f4 25 00 00       	call   8010684b <acquire>
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
80104279:	e8 73 15 00 00       	call   801057f1 <wakeup>
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
8010429c:	e8 50 15 00 00       	call   801057f1 <wakeup>
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
801042c5:	e8 e8 25 00 00       	call   801068b2 <release>
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
801042e4:	e8 c9 25 00 00       	call   801068b2 <release>
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
801042fc:	e8 4a 25 00 00       	call   8010684b <acquire>
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
80104331:	e8 7c 25 00 00       	call   801068b2 <release>
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
8010434f:	e8 9d 14 00 00       	call   801057f1 <wakeup>
80104354:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104357:	8b 45 08             	mov    0x8(%ebp),%eax
8010435a:	8b 55 08             	mov    0x8(%ebp),%edx
8010435d:	81 c2 38 02 00 00    	add    $0x238,%edx
80104363:	83 ec 08             	sub    $0x8,%esp
80104366:	50                   	push   %eax
80104367:	52                   	push   %edx
80104368:	e8 29 12 00 00       	call   80105596 <sleep>
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
801043d1:	e8 1b 14 00 00       	call   801057f1 <wakeup>
801043d6:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043d9:	8b 45 08             	mov    0x8(%ebp),%eax
801043dc:	83 ec 0c             	sub    $0xc,%esp
801043df:	50                   	push   %eax
801043e0:	e8 cd 24 00 00       	call   801068b2 <release>
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
801043fb:	e8 4b 24 00 00       	call   8010684b <acquire>
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
80104419:	e8 94 24 00 00       	call   801068b2 <release>
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
8010443c:	e8 55 11 00 00       	call   80105596 <sleep>
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
801044d0:	e8 1c 13 00 00       	call   801057f1 <wakeup>
801044d5:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044d8:	8b 45 08             	mov    0x8(%ebp),%eax
801044db:	83 ec 0c             	sub    $0xc,%esp
801044de:	50                   	push   %eax
801044df:	e8 ce 23 00 00       	call   801068b2 <release>
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
80104516:	68 d2 a2 10 80       	push   $0x8010a2d2
8010451b:	68 80 49 11 80       	push   $0x80114980
80104520:	e8 04 23 00 00       	call   80106829 <initlock>
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
80104539:	e8 0d 23 00 00       	call   8010684b <acquire>
8010453e:	83 c4 10             	add    $0x10,%esp
    p = ptable.pLists.free;
80104541:	a1 c0 70 11 80       	mov    0x801170c0,%eax
80104546:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p) {
80104549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010454d:	75 1a                	jne    80104569 <allocproc+0x3e>
        goto found;
    }
    release(&ptable.lock);
8010454f:	83 ec 0c             	sub    $0xc,%esp
80104552:	68 80 49 11 80       	push   $0x80114980
80104557:	e8 56 23 00 00       	call   801068b2 <release>
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
80104572:	e8 d1 19 00 00       	call   80105f48 <assertState>
80104577:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.free, p) == -1) {
8010457a:	83 ec 08             	sub    $0x8,%esp
8010457d:	ff 75 f4             	pushl  -0xc(%ebp)
80104580:	68 c0 70 11 80       	push   $0x801170c0
80104585:	e8 df 1a 00 00       	call   80106069 <removeFromStateList>
8010458a:	83 c4 10             	add    $0x10,%esp
8010458d:	83 f8 ff             	cmp    $0xffffffff,%eax
80104590:	75 10                	jne    801045a2 <allocproc+0x77>
        cprintf("Failed to remove proc from UNUSED list (allocproc).\n");
80104592:	83 ec 0c             	sub    $0xc,%esp
80104595:	68 dc a2 10 80       	push   $0x8010a2dc
8010459a:	e8 27 be ff ff       	call   801003c6 <cprintf>
8010459f:	83 c4 10             	add    $0x10,%esp
    }
    p->state = EMBRYO;
801045a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a5:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    if (addToStateListHead(&ptable.pLists.embryo, p) == -1) {
801045ac:	83 ec 08             	sub    $0x8,%esp
801045af:	ff 75 f4             	pushl  -0xc(%ebp)
801045b2:	68 d0 70 11 80       	push   $0x801170d0
801045b7:	e8 c0 19 00 00       	call   80105f7c <addToStateListHead>
801045bc:	83 c4 10             	add    $0x10,%esp
801045bf:	83 f8 ff             	cmp    $0xffffffff,%eax
801045c2:	75 10                	jne    801045d4 <allocproc+0xa9>
        cprintf("Failed to add proc to EMBRYO list (allocproc).\n");
801045c4:	83 ec 0c             	sub    $0xc,%esp
801045c7:	68 14 a3 10 80       	push   $0x8010a314
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
801045f2:	e8 bb 22 00 00       	call   801068b2 <release>
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
80104619:	e8 2a 19 00 00       	call   80105f48 <assertState>
8010461e:	83 c4 10             	add    $0x10,%esp
        removeFromStateList(&ptable.pLists.embryo, p);
80104621:	83 ec 08             	sub    $0x8,%esp
80104624:	ff 75 f4             	pushl  -0xc(%ebp)
80104627:	68 d0 70 11 80       	push   $0x801170d0
8010462c:	e8 38 1a 00 00       	call   80106069 <removeFromStateList>
80104631:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104637:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        if (addToStateListHead(&ptable.pLists.free, p) == -1) {
8010463e:	83 ec 08             	sub    $0x8,%esp
80104641:	ff 75 f4             	pushl  -0xc(%ebp)
80104644:	68 c0 70 11 80       	push   $0x801170c0
80104649:	e8 2e 19 00 00       	call   80105f7c <addToStateListHead>
8010464e:	83 c4 10             	add    $0x10,%esp
80104651:	83 f8 ff             	cmp    $0xffffffff,%eax
80104654:	75 10                	jne    80104666 <allocproc+0x13b>
            cprintf("Not enough room for process stack; Failed to add proc to UNUSED list (allocproc).\n");
80104656:	83 ec 0c             	sub    $0xc,%esp
80104659:	68 44 a3 10 80       	push   $0x8010a344
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
8010468f:	ba 78 80 10 80       	mov    $0x80108078,%edx
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
801046b4:	e8 f5 23 00 00       	call   80106aae <memset>
801046b9:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
801046bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046bf:	8b 40 1c             	mov    0x1c(%eax),%eax
801046c2:	ba 50 55 10 80       	mov    $0x80105550,%edx
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
801046f3:	c7 80 98 00 00 00 64 	movl   $0x64,0x98(%eax)
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
    ptable.promoteAtTime = TIME_TO_PROMOTE; // Project 4, initialize promotion timer
80104715:	c7 05 d4 70 11 80 32 	movl   $0x32,0x801170d4
8010471c:	00 00 00 
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
80104730:	e8 13 18 00 00       	call   80105f48 <assertState>
80104735:	83 c4 10             	add    $0x10,%esp
        if (addToStateListEnd(&ptable.pLists.free, p) == -1) {
80104738:	83 ec 08             	sub    $0x8,%esp
8010473b:	ff 75 f4             	pushl  -0xc(%ebp)
8010473e:	68 c0 70 11 80       	push   $0x801170c0
80104743:	e8 a0 18 00 00       	call   80105fe8 <addToStateListEnd>
80104748:	83 c4 10             	add    $0x10,%esp
8010474b:	83 f8 ff             	cmp    $0xffffffff,%eax
8010474e:	75 0d                	jne    8010475d <userinit+0x4e>
            panic("Failed to add proc to UNUSED list.\n");
80104750:	83 ec 0c             	sub    $0xc,%esp
80104753:	68 98 a3 10 80       	push   $0x8010a398
80104758:	e8 09 be ff ff       	call   80100566 <panic>
    ptable.promoteAtTime = TIME_TO_PROMOTE; // Project 4, initialize promotion timer
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
8010477d:	e8 b8 4f 00 00       	call   8010973a <setupkvm>
80104782:	89 c2                	mov    %eax,%edx
80104784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104787:	89 50 04             	mov    %edx,0x4(%eax)
8010478a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478d:	8b 40 04             	mov    0x4(%eax),%eax
80104790:	85 c0                	test   %eax,%eax
80104792:	75 0d                	jne    801047a1 <userinit+0x92>
        panic("userinit: out of memory?");
80104794:	83 ec 0c             	sub    $0xc,%esp
80104797:	68 bc a3 10 80       	push   $0x8010a3bc
8010479c:	e8 c5 bd ff ff       	call   80100566 <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801047a1:	ba 2c 00 00 00       	mov    $0x2c,%edx
801047a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a9:	8b 40 04             	mov    0x4(%eax),%eax
801047ac:	83 ec 04             	sub    $0x4,%esp
801047af:	52                   	push   %edx
801047b0:	68 00 d5 10 80       	push   $0x8010d500
801047b5:	50                   	push   %eax
801047b6:	e8 d9 51 00 00       	call   80109994 <inituvm>
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
801047d5:	e8 d4 22 00 00       	call   80106aae <memset>
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
80104872:	68 d5 a3 10 80       	push   $0x8010a3d5
80104877:	50                   	push   %eax
80104878:	e8 34 24 00 00       	call   80106cb1 <safestrcpy>
8010487d:	83 c4 10             	add    $0x10,%esp
    p->cwd = namei("/");
80104880:	83 ec 0c             	sub    $0xc,%esp
80104883:	68 de a3 10 80       	push   $0x8010a3de
80104888:	e8 4c dd ff ff       	call   801025d9 <namei>
8010488d:	83 c4 10             	add    $0x10,%esp
80104890:	89 c2                	mov    %eax,%edx
80104892:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104895:	89 50 68             	mov    %edx,0x68(%eax)

    assertState(p, EMBRYO);
80104898:	83 ec 08             	sub    $0x8,%esp
8010489b:	6a 01                	push   $0x1
8010489d:	ff 75 f4             	pushl  -0xc(%ebp)
801048a0:	e8 a3 16 00 00       	call   80105f48 <assertState>
801048a5:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.embryo, p) < 0) {
801048a8:	83 ec 08             	sub    $0x8,%esp
801048ab:	ff 75 f4             	pushl  -0xc(%ebp)
801048ae:	68 d0 70 11 80       	push   $0x801170d0
801048b3:	e8 b1 17 00 00       	call   80106069 <removeFromStateList>
801048b8:	83 c4 10             	add    $0x10,%esp
801048bb:	85 c0                	test   %eax,%eax
801048bd:	79 10                	jns    801048cf <userinit+0x1c0>
        cprintf("Failed to remove EMBRYO proc from list (userinit).\n");
801048bf:	83 ec 0c             	sub    $0xc,%esp
801048c2:	68 e0 a3 10 80       	push   $0x8010a3e0
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
8010490e:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
80104912:	7e e3                	jle    801048f7 <userinit+0x1e8>
        ptable.pLists.ready[i] = 0; // initialize all of the other ready lists
    }
    ptable.pLists.sleep = 0;  // initialize rest of the lists to NULL
80104914:	c7 05 c4 70 11 80 00 	movl   $0x0,0x801170c4
8010491b:	00 00 00 
    ptable.pLists.zombie = 0;
8010491e:	c7 05 c8 70 11 80 00 	movl   $0x0,0x801170c8
80104925:	00 00 00 
    ptable.pLists.running = 0;
80104928:	c7 05 cc 70 11 80 00 	movl   $0x0,0x801170cc
8010492f:	00 00 00 
    ptable.pLists.embryo = 0;
80104932:	c7 05 d0 70 11 80 00 	movl   $0x0,0x801170d0
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
8010496f:	e8 6d 51 00 00       	call   80109ae1 <allocuvm>
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
801049a6:	e8 ff 51 00 00       	call   80109baa <deallocuvm>
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
801049d3:	e8 49 4e 00 00       	call   80109821 <switchuvm>
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
80104a19:	e8 2a 53 00 00       	call   80109d48 <copyuvm>
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
80104a5b:	e8 e8 14 00 00       	call   80105f48 <assertState>
80104a60:	83 c4 10             	add    $0x10,%esp
        if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
80104a63:	83 ec 08             	sub    $0x8,%esp
80104a66:	ff 75 e0             	pushl  -0x20(%ebp)
80104a69:	68 d0 70 11 80       	push   $0x801170d0
80104a6e:	e8 f6 15 00 00       	call   80106069 <removeFromStateList>
80104a73:	83 c4 10             	add    $0x10,%esp
80104a76:	85 c0                	test   %eax,%eax
80104a78:	79 0d                	jns    80104a87 <fork+0xa5>
            panic("Failed to remove proc from EMBRYO list (fork).\n");
80104a7a:	83 ec 0c             	sub    $0xc,%esp
80104a7d:	68 14 a4 10 80       	push   $0x8010a414
80104a82:	e8 df ba ff ff       	call   80100566 <panic>
        }
        np->state = UNUSED;
80104a87:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        if (addToStateListHead(&ptable.pLists.free, np) < 0) {
80104a91:	83 ec 08             	sub    $0x8,%esp
80104a94:	ff 75 e0             	pushl  -0x20(%ebp)
80104a97:	68 c0 70 11 80       	push   $0x801170c0
80104a9c:	e8 db 14 00 00       	call   80105f7c <addToStateListHead>
80104aa1:	83 c4 10             	add    $0x10,%esp
80104aa4:	85 c0                	test   %eax,%eax
80104aa6:	79 0d                	jns    80104ab5 <fork+0xd3>
            panic("Failed to add proc to UNUSED list (fork).\n");
80104aa8:	83 ec 0c             	sub    $0xc,%esp
80104aab:	68 44 a4 10 80       	push   $0x8010a444
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
80104b89:	e8 23 21 00 00       	call   80106cb1 <safestrcpy>
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
80104bcc:	e8 7a 1c 00 00       	call   8010684b <acquire>
80104bd1:	83 c4 10             	add    $0x10,%esp
    assertState(np, EMBRYO);
80104bd4:	83 ec 08             	sub    $0x8,%esp
80104bd7:	6a 01                	push   $0x1
80104bd9:	ff 75 e0             	pushl  -0x20(%ebp)
80104bdc:	e8 67 13 00 00       	call   80105f48 <assertState>
80104be1:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
80104be4:	83 ec 08             	sub    $0x8,%esp
80104be7:	ff 75 e0             	pushl  -0x20(%ebp)
80104bea:	68 d0 70 11 80       	push   $0x801170d0
80104bef:	e8 75 14 00 00       	call   80106069 <removeFromStateList>
80104bf4:	83 c4 10             	add    $0x10,%esp
80104bf7:	85 c0                	test   %eax,%eax
80104bf9:	79 10                	jns    80104c0b <fork+0x229>
        cprintf("Failed to remove EMBRYO proc from list (fork).\n");
80104bfb:	83 ec 0c             	sub    $0xc,%esp
80104bfe:	68 70 a4 10 80       	push   $0x8010a470
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
80104c35:	e8 ae 13 00 00       	call   80105fe8 <addToStateListEnd>
80104c3a:	83 c4 10             	add    $0x10,%esp
80104c3d:	85 c0                	test   %eax,%eax
80104c3f:	79 10                	jns    80104c51 <fork+0x26f>
        cprintf("Failed to add RUNNABLE proc to list (fork).\n");
80104c41:	83 ec 0c             	sub    $0xc,%esp
80104c44:	68 a0 a4 10 80       	push   $0x8010a4a0
80104c49:	e8 78 b7 ff ff       	call   801003c6 <cprintf>
80104c4e:	83 c4 10             	add    $0x10,%esp
    }
    release(&ptable.lock);
80104c51:	83 ec 0c             	sub    $0xc,%esp
80104c54:	68 80 49 11 80       	push   $0x80114980
80104c59:	e8 54 1c 00 00       	call   801068b2 <release>
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
80104c85:	68 cd a4 10 80       	push   $0x8010a4cd
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
80104d1a:	e8 2c 1b 00 00       	call   8010684b <acquire>
80104d1f:	83 c4 10             	add    $0x10,%esp

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104d22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d28:	8b 40 14             	mov    0x14(%eax),%eax
80104d2b:	83 ec 0c             	sub    $0xc,%esp
80104d2e:	50                   	push   %eax
80104d2f:	e8 ef 09 00 00       	call   80105723 <wakeup1>
80104d34:	83 c4 10             	add    $0x10,%esp
    
    // Pass abandoned children to init.
    current = ptable.pLists.zombie;
80104d37:	a1 c8 70 11 80       	mov    0x801170c8,%eax
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
80104d78:	e8 a6 09 00 00       	call   80105723 <wakeup1>
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
80104d86:	a1 cc 70 11 80       	mov    0x801170cc,%eax
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
80104e0d:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
80104e11:	7e b4                	jle    80104dc7 <exit+0x15b>
                p->parent = initproc;
            }
            p = p->next;
        }
    }
    p = ptable.pLists.sleep; // sleeping list
80104e13:	a1 c4 70 11 80       	mov    0x801170c4,%eax
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
80104e4b:	a1 d0 70 11 80       	mov    0x801170d0,%eax
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
80104e83:	a1 c0 70 11 80       	mov    0x801170c0,%eax
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
80104ec7:	e8 7c 10 00 00       	call   80105f48 <assertState>
80104ecc:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
80104ecf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ed5:	83 ec 08             	sub    $0x8,%esp
80104ed8:	50                   	push   %eax
80104ed9:	68 cc 70 11 80       	push   $0x801170cc
80104ede:	e8 86 11 00 00       	call   80106069 <removeFromStateList>
80104ee3:	83 c4 10             	add    $0x10,%esp
80104ee6:	85 c0                	test   %eax,%eax
80104ee8:	79 10                	jns    80104efa <exit+0x28e>
        cprintf("Failed to remove RUNNING proc from list (exit).\n");
80104eea:	83 ec 0c             	sub    $0xc,%esp
80104eed:	68 dc a4 10 80       	push   $0x8010a4dc
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
80104f11:	68 c8 70 11 80       	push   $0x801170c8
80104f16:	e8 61 10 00 00       	call   80105f7c <addToStateListHead>
80104f1b:	83 c4 10             	add    $0x10,%esp
80104f1e:	85 c0                	test   %eax,%eax
80104f20:	79 10                	jns    80104f32 <exit+0x2c6>
        cprintf("Failed to add ZOMBIE proc to list (exit).\n");
80104f22:	83 ec 0c             	sub    $0xc,%esp
80104f25:	68 10 a5 10 80       	push   $0x8010a510
80104f2a:	e8 97 b4 ff ff       	call   801003c6 <cprintf>
80104f2f:	83 c4 10             	add    $0x10,%esp
    }

    sched();
80104f32:	e8 e9 03 00 00       	call   80105320 <sched>
    panic("zombie exit");
80104f37:	83 ec 0c             	sub    $0xc,%esp
80104f3a:	68 3b a5 10 80       	push   $0x8010a53b
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
80104f52:	e8 f4 18 00 00       	call   8010684b <acquire>
80104f57:	83 c4 10             	add    $0x10,%esp
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
80104f5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        // start at zombie list
        p = ptable.pLists.zombie;
80104f61:	a1 c8 70 11 80       	mov    0x801170c8,%eax
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
80104fb8:	e8 aa 4c 00 00       	call   80109c67 <freevm>
80104fbd:	83 c4 10             	add    $0x10,%esp
                assertState(p, ZOMBIE);
80104fc0:	83 ec 08             	sub    $0x8,%esp
80104fc3:	6a 05                	push   $0x5
80104fc5:	ff 75 f4             	pushl  -0xc(%ebp)
80104fc8:	e8 7b 0f 00 00       	call   80105f48 <assertState>
80104fcd:	83 c4 10             	add    $0x10,%esp
                if (removeFromStateList(&ptable.pLists.zombie, p) < 0) {
80104fd0:	83 ec 08             	sub    $0x8,%esp
80104fd3:	ff 75 f4             	pushl  -0xc(%ebp)
80104fd6:	68 c8 70 11 80       	push   $0x801170c8
80104fdb:	e8 89 10 00 00       	call   80106069 <removeFromStateList>
80104fe0:	83 c4 10             	add    $0x10,%esp
80104fe3:	85 c0                	test   %eax,%eax
80104fe5:	79 10                	jns    80104ff7 <wait+0xb3>
                    cprintf("Failed to remove ZOMBIE process from list (wait).\n");
80104fe7:	83 ec 0c             	sub    $0xc,%esp
80104fea:	68 48 a5 10 80       	push   $0x8010a548
80104fef:	e8 d2 b3 ff ff       	call   801003c6 <cprintf>
80104ff4:	83 c4 10             	add    $0x10,%esp
                }
                p->state = UNUSED;
80104ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ffa:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                if (addToStateListHead(&ptable.pLists.free, p) < 0) {
80105001:	83 ec 08             	sub    $0x8,%esp
80105004:	ff 75 f4             	pushl  -0xc(%ebp)
80105007:	68 c0 70 11 80       	push   $0x801170c0
8010500c:	e8 6b 0f 00 00       	call   80105f7c <addToStateListHead>
80105011:	83 c4 10             	add    $0x10,%esp
80105014:	85 c0                	test   %eax,%eax
80105016:	79 10                	jns    80105028 <wait+0xe4>
                    cprintf("Failed to add UNUSED process to list (wait).\n");
80105018:	83 ec 0c             	sub    $0xc,%esp
8010501b:	68 7c a5 10 80       	push   $0x8010a57c
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
80105055:	e8 58 18 00 00       	call   801068b2 <release>
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
801050d1:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
801050d5:	7e b3                	jle    8010508a <wait+0x146>
                }
                p = p->next;
            }
        }
        // Running list
        p = ptable.pLists.running;
801050d7:	a1 cc 70 11 80       	mov    0x801170cc,%eax
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
80105110:	a1 c4 70 11 80       	mov    0x801170c4,%eax
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
80105164:	e8 49 17 00 00       	call   801068b2 <release>
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
80105182:	e8 0f 04 00 00       	call   80105596 <sleep>
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
801051b2:	e8 94 16 00 00       	call   8010684b <acquire>
801051b7:	83 c4 10             	add    $0x10,%esp

        if ((ptable.promoteAtTime) == ticks) {
801051ba:	8b 15 d4 70 11 80    	mov    0x801170d4,%edx
801051c0:	a1 e0 78 11 80       	mov    0x801178e0,%eax
801051c5:	39 c2                	cmp    %eax,%edx
801051c7:	75 12                	jne    801051db <scheduler+0x4a>
            promoteAll(); // RUNNING, RUNNABLE, SLEEPING
801051c9:	e8 7e 12 00 00       	call   8010644c <promoteAll>
            ptable.promoteAtTime = (ticks + TIME_TO_PROMOTE); // update next time we will promote everything
801051ce:	a1 e0 78 11 80       	mov    0x801178e0,%eax
801051d3:	83 c0 32             	add    $0x32,%eax
801051d6:	a3 d4 70 11 80       	mov    %eax,0x801170d4
        }
        for (int i = 0; (i <= MAX) && (ran == 0); ++i) {
801051db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
801051e2:	e9 00 01 00 00       	jmp    801052e7 <scheduler+0x156>
            // take first process on first valid list
            p = ptable.pLists.ready[i];
801051e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051ea:	05 cc 09 00 00       	add    $0x9cc,%eax
801051ef:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
801051f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (p) {
801051f9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801051fd:	0f 84 e0 00 00 00    	je     801052e3 <scheduler+0x152>
                // assign pointer, aseert correct state
                assertState(p, RUNNABLE);
80105203:	83 ec 08             	sub    $0x8,%esp
80105206:	6a 03                	push   $0x3
80105208:	ff 75 e8             	pushl  -0x18(%ebp)
8010520b:	e8 38 0d 00 00       	call   80105f48 <assertState>
80105210:	83 c4 10             	add    $0x10,%esp
                // take 1st process on ready list
                p = removeHead(&ptable.pLists.ready[p->priority]);
80105213:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105216:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010521c:	05 cc 09 00 00       	add    $0x9cc,%eax
80105221:	c1 e0 02             	shl    $0x2,%eax
80105224:	05 80 49 11 80       	add    $0x80114980,%eax
80105229:	83 c0 04             	add    $0x4,%eax
8010522c:	83 ec 0c             	sub    $0xc,%esp
8010522f:	50                   	push   %eax
80105230:	e8 28 0f 00 00       	call   8010615d <removeHead>
80105235:	83 c4 10             	add    $0x10,%esp
80105238:	89 45 e8             	mov    %eax,-0x18(%ebp)
                if (!p) {
8010523b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010523f:	75 0d                	jne    8010524e <scheduler+0xbd>
                    panic("Scheduler: removeHead failed.");
80105241:	83 ec 0c             	sub    $0xc,%esp
80105244:	68 aa a5 10 80       	push   $0x8010a5aa
80105249:	e8 18 b3 ff ff       	call   80100566 <panic>
                }
                // hand over to the CPU
                idle = 0;
8010524e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
                proc = p;
80105255:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105258:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
                switchuvm(p);
8010525e:	83 ec 0c             	sub    $0xc,%esp
80105261:	ff 75 e8             	pushl  -0x18(%ebp)
80105264:	e8 b8 45 00 00       	call   80109821 <switchuvm>
80105269:	83 c4 10             	add    $0x10,%esp
                p->state = RUNNING;
8010526c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010526f:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
                // add to end of running list
                if (addToStateListEnd(&ptable.pLists.running, p) < 0) {
80105276:	83 ec 08             	sub    $0x8,%esp
80105279:	ff 75 e8             	pushl  -0x18(%ebp)
8010527c:	68 cc 70 11 80       	push   $0x801170cc
80105281:	e8 62 0d 00 00       	call   80105fe8 <addToStateListEnd>
80105286:	83 c4 10             	add    $0x10,%esp
80105289:	85 c0                	test   %eax,%eax
8010528b:	79 10                	jns    8010529d <scheduler+0x10c>
                    cprintf("Failed to add RUNNING proc to list (scheduler).");
8010528d:	83 ec 0c             	sub    $0xc,%esp
80105290:	68 c8 a5 10 80       	push   $0x8010a5c8
80105295:	e8 2c b1 ff ff       	call   801003c6 <cprintf>
8010529a:	83 c4 10             	add    $0x10,%esp
                }
                p->cpu_ticks_in = ticks; // ticks when scheduled
8010529d:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
801052a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801052a6:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
                swtch(&cpu->scheduler, proc->context);
801052ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052b2:	8b 40 1c             	mov    0x1c(%eax),%eax
801052b5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801052bc:	83 c2 04             	add    $0x4,%edx
801052bf:	83 ec 08             	sub    $0x8,%esp
801052c2:	50                   	push   %eax
801052c3:	52                   	push   %edx
801052c4:	e8 59 1a 00 00       	call   80106d22 <swtch>
801052c9:	83 c4 10             	add    $0x10,%esp
                switchkvm();
801052cc:	e8 33 45 00 00       	call   80109804 <switchkvm>
                // Process is done running for now.
                // It should have changed its p->state before coming back.
                proc = 0;
801052d1:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801052d8:	00 00 00 00 
                ran = 1; // exit loop after this
801052dc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

        if ((ptable.promoteAtTime) == ticks) {
            promoteAll(); // RUNNING, RUNNABLE, SLEEPING
            ptable.promoteAtTime = (ticks + TIME_TO_PROMOTE); // update next time we will promote everything
        }
        for (int i = 0; (i <= MAX) && (ran == 0); ++i) {
801052e3:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801052e7:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
801052eb:	7f 0a                	jg     801052f7 <scheduler+0x166>
801052ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801052f1:	0f 84 f0 fe ff ff    	je     801051e7 <scheduler+0x56>
                // It should have changed its p->state before coming back.
                proc = 0;
                ran = 1; // exit loop after this
            }
        }
        release(&ptable.lock);
801052f7:	83 ec 0c             	sub    $0xc,%esp
801052fa:	68 80 49 11 80       	push   $0x80114980
801052ff:	e8 ae 15 00 00       	call   801068b2 <release>
80105304:	83 c4 10             	add    $0x10,%esp
        if (idle) {
80105307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010530b:	0f 84 86 fe ff ff    	je     80105197 <scheduler+0x6>
            sti();
80105311:	e8 f0 f1 ff ff       	call   80104506 <sti>
            hlt();
80105316:	e8 d4 f1 ff ff       	call   801044ef <hlt>
        }
    }
8010531b:	e9 77 fe ff ff       	jmp    80105197 <scheduler+0x6>

80105320 <sched>:
    cpu->intena = intena;
}
#else
void
sched(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	53                   	push   %ebx
80105324:	83 ec 14             	sub    $0x14,%esp
    int intena;

    if(!holding(&ptable.lock))
80105327:	83 ec 0c             	sub    $0xc,%esp
8010532a:	68 80 49 11 80       	push   $0x80114980
8010532f:	e8 4a 16 00 00       	call   8010697e <holding>
80105334:	83 c4 10             	add    $0x10,%esp
80105337:	85 c0                	test   %eax,%eax
80105339:	75 0d                	jne    80105348 <sched+0x28>
        panic("sched ptable.lock");
8010533b:	83 ec 0c             	sub    $0xc,%esp
8010533e:	68 f8 a5 10 80       	push   $0x8010a5f8
80105343:	e8 1e b2 ff ff       	call   80100566 <panic>
    if(cpu->ncli != 1)
80105348:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010534e:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105354:	83 f8 01             	cmp    $0x1,%eax
80105357:	74 0d                	je     80105366 <sched+0x46>
        panic("sched locks");
80105359:	83 ec 0c             	sub    $0xc,%esp
8010535c:	68 0a a6 10 80       	push   $0x8010a60a
80105361:	e8 00 b2 ff ff       	call   80100566 <panic>
    if(proc->state == RUNNING)
80105366:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010536c:	8b 40 0c             	mov    0xc(%eax),%eax
8010536f:	83 f8 04             	cmp    $0x4,%eax
80105372:	75 0d                	jne    80105381 <sched+0x61>
        panic("sched running");
80105374:	83 ec 0c             	sub    $0xc,%esp
80105377:	68 16 a6 10 80       	push   $0x8010a616
8010537c:	e8 e5 b1 ff ff       	call   80100566 <panic>
    if(readeflags()&FL_IF)
80105381:	e8 70 f1 ff ff       	call   801044f6 <readeflags>
80105386:	25 00 02 00 00       	and    $0x200,%eax
8010538b:	85 c0                	test   %eax,%eax
8010538d:	74 0d                	je     8010539c <sched+0x7c>
        panic("sched interruptible");
8010538f:	83 ec 0c             	sub    $0xc,%esp
80105392:	68 24 a6 10 80       	push   $0x8010a624
80105397:	e8 ca b1 ff ff       	call   80100566 <panic>
    intena = cpu->intena;
8010539c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053a2:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801053a8:	89 45 f4             	mov    %eax,-0xc(%ebp)

    proc->cpu_ticks_total += (ticks - proc->cpu_ticks_in);
801053ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053b1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053b8:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801053be:	8b 1d e0 78 11 80    	mov    0x801178e0,%ebx
801053c4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053cb:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801053d1:	29 d3                	sub    %edx,%ebx
801053d3:	89 da                	mov    %ebx,%edx
801053d5:	01 ca                	add    %ecx,%edx
801053d7:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)

    swtch(&proc->context, cpu->scheduler);
801053dd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801053e3:	8b 40 04             	mov    0x4(%eax),%eax
801053e6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801053ed:	83 c2 1c             	add    $0x1c,%edx
801053f0:	83 ec 08             	sub    $0x8,%esp
801053f3:	50                   	push   %eax
801053f4:	52                   	push   %edx
801053f5:	e8 28 19 00 00       	call   80106d22 <swtch>
801053fa:	83 c4 10             	add    $0x10,%esp

    cpu->intena = intena;
801053fd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105403:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105406:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010540c:	90                   	nop
8010540d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105410:	c9                   	leave  
80105411:	c3                   	ret    

80105412 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105412:	55                   	push   %ebp
80105413:	89 e5                	mov    %esp,%ebp
80105415:	53                   	push   %ebx
80105416:	83 ec 04             	sub    $0x4,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
80105419:	83 ec 0c             	sub    $0xc,%esp
8010541c:	68 80 49 11 80       	push   $0x80114980
80105421:	e8 25 14 00 00       	call   8010684b <acquire>
80105426:	83 c4 10             	add    $0x10,%esp

#ifdef CS333_P3P4
    assertState(proc, RUNNING);
80105429:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010542f:	83 ec 08             	sub    $0x8,%esp
80105432:	6a 04                	push   $0x4
80105434:	50                   	push   %eax
80105435:	e8 0e 0b 00 00       	call   80105f48 <assertState>
8010543a:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
8010543d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105443:	83 ec 08             	sub    $0x8,%esp
80105446:	50                   	push   %eax
80105447:	68 cc 70 11 80       	push   $0x801170cc
8010544c:	e8 18 0c 00 00       	call   80106069 <removeFromStateList>
80105451:	83 c4 10             	add    $0x10,%esp
80105454:	85 c0                	test   %eax,%eax
80105456:	79 10                	jns    80105468 <yield+0x56>
        cprintf("Failed to remove RUNNING proc to list (yeild).");
80105458:	83 ec 0c             	sub    $0xc,%esp
8010545b:	68 38 a6 10 80       	push   $0x8010a638
80105460:	e8 61 af ff ff       	call   801003c6 <cprintf>
80105465:	83 c4 10             	add    $0x10,%esp
    }
#endif

    proc->state = RUNNABLE;
80105468:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010546e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

#ifdef CS333_P3P4
    proc->budget -= (ticks - proc->cpu_ticks_in); // update budget, then check
80105475:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010547b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105482:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
80105488:	89 d3                	mov    %edx,%ebx
8010548a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105491:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
80105497:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
8010549d:	29 d1                	sub    %edx,%ecx
8010549f:	89 ca                	mov    %ecx,%edx
801054a1:	01 da                	add    %ebx,%edx
801054a3:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if ((proc->budget) <= 0) {
801054a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054af:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801054b5:	85 c0                	test   %eax,%eax
801054b7:	7f 36                	jg     801054ef <yield+0xdd>
        if ((proc->priority) < MAX) {
801054b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054bf:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801054c5:	83 f8 01             	cmp    $0x1,%eax
801054c8:	77 15                	ja     801054df <yield+0xcd>
            ++(proc->priority); // Demotion
801054ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054d0:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
801054d6:	83 c2 01             	add    $0x1,%edx
801054d9:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        }
        proc->budget = BUDGET; // Reset budget
801054df:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054e5:	c7 80 98 00 00 00 64 	movl   $0x64,0x98(%eax)
801054ec:	00 00 00 
    }

    if (addToStateListEnd(&ptable.pLists.ready[proc->priority], proc) < 0) {
801054ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054f5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054fc:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
80105502:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
80105508:	c1 e2 02             	shl    $0x2,%edx
8010550b:	81 c2 80 49 11 80    	add    $0x80114980,%edx
80105511:	83 c2 04             	add    $0x4,%edx
80105514:	83 ec 08             	sub    $0x8,%esp
80105517:	50                   	push   %eax
80105518:	52                   	push   %edx
80105519:	e8 ca 0a 00 00       	call   80105fe8 <addToStateListEnd>
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	85 c0                	test   %eax,%eax
80105523:	79 10                	jns    80105535 <yield+0x123>
        cprintf("Failed to add RUNNABLE proc to list (yeild).");
80105525:	83 ec 0c             	sub    $0xc,%esp
80105528:	68 68 a6 10 80       	push   $0x8010a668
8010552d:	e8 94 ae ff ff       	call   801003c6 <cprintf>
80105532:	83 c4 10             	add    $0x10,%esp
    }
#endif

    sched();
80105535:	e8 e6 fd ff ff       	call   80105320 <sched>
    release(&ptable.lock);
8010553a:	83 ec 0c             	sub    $0xc,%esp
8010553d:	68 80 49 11 80       	push   $0x80114980
80105542:	e8 6b 13 00 00       	call   801068b2 <release>
80105547:	83 c4 10             	add    $0x10,%esp
}
8010554a:	90                   	nop
8010554b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010554e:	c9                   	leave  
8010554f:	c3                   	ret    

80105550 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	83 ec 08             	sub    $0x8,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
80105556:	83 ec 0c             	sub    $0xc,%esp
80105559:	68 80 49 11 80       	push   $0x80114980
8010555e:	e8 4f 13 00 00       	call   801068b2 <release>
80105563:	83 c4 10             	add    $0x10,%esp

    if (first) {
80105566:	a1 20 d0 10 80       	mov    0x8010d020,%eax
8010556b:	85 c0                	test   %eax,%eax
8010556d:	74 24                	je     80105593 <forkret+0x43>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot 
        // be run from main().
        first = 0;
8010556f:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
80105576:	00 00 00 
        iinit(ROOTDEV);
80105579:	83 ec 0c             	sub    $0xc,%esp
8010557c:	6a 01                	push   $0x1
8010557e:	e8 6c c1 ff ff       	call   801016ef <iinit>
80105583:	83 c4 10             	add    $0x10,%esp
        initlog(ROOTDEV);
80105586:	83 ec 0c             	sub    $0xc,%esp
80105589:	6a 01                	push   $0x1
8010558b:	e8 50 de ff ff       	call   801033e0 <initlog>
80105590:	83 c4 10             	add    $0x10,%esp
    }

    // Return to "caller", actually trapret (see allocproc).
}
80105593:	90                   	nop
80105594:	c9                   	leave  
80105595:	c3                   	ret    

80105596 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80105596:	55                   	push   %ebp
80105597:	89 e5                	mov    %esp,%ebp
80105599:	53                   	push   %ebx
8010559a:	83 ec 04             	sub    $0x4,%esp
    if(proc == 0)
8010559d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055a3:	85 c0                	test   %eax,%eax
801055a5:	75 0d                	jne    801055b4 <sleep+0x1e>
        panic("sleep");
801055a7:	83 ec 0c             	sub    $0xc,%esp
801055aa:	68 95 a6 10 80       	push   $0x8010a695
801055af:	e8 b2 af ff ff       	call   80100566 <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){
801055b4:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801055bb:	74 24                	je     801055e1 <sleep+0x4b>
        acquire(&ptable.lock);
801055bd:	83 ec 0c             	sub    $0xc,%esp
801055c0:	68 80 49 11 80       	push   $0x80114980
801055c5:	e8 81 12 00 00       	call   8010684b <acquire>
801055ca:	83 c4 10             	add    $0x10,%esp
        if (lk) release(lk);
801055cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801055d1:	74 0e                	je     801055e1 <sleep+0x4b>
801055d3:	83 ec 0c             	sub    $0xc,%esp
801055d6:	ff 75 0c             	pushl  0xc(%ebp)
801055d9:	e8 d4 12 00 00       	call   801068b2 <release>
801055de:	83 c4 10             	add    $0x10,%esp
    }

    // Go to sleep.
    proc->chan = chan;
801055e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e7:	8b 55 08             	mov    0x8(%ebp),%edx
801055ea:	89 50 20             	mov    %edx,0x20(%eax)

#ifdef CS333_P3P4
    assertState(proc, RUNNING);
801055ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055f3:	83 ec 08             	sub    $0x8,%esp
801055f6:	6a 04                	push   $0x4
801055f8:	50                   	push   %eax
801055f9:	e8 4a 09 00 00       	call   80105f48 <assertState>
801055fe:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
80105601:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105607:	83 ec 08             	sub    $0x8,%esp
8010560a:	50                   	push   %eax
8010560b:	68 cc 70 11 80       	push   $0x801170cc
80105610:	e8 54 0a 00 00       	call   80106069 <removeFromStateList>
80105615:	83 c4 10             	add    $0x10,%esp
80105618:	85 c0                	test   %eax,%eax
8010561a:	79 10                	jns    8010562c <sleep+0x96>
        cprintf("Could not remove RUNNING proc from list (sleep()).\n");
8010561c:	83 ec 0c             	sub    $0xc,%esp
8010561f:	68 9c a6 10 80       	push   $0x8010a69c
80105624:	e8 9d ad ff ff       	call   801003c6 <cprintf>
80105629:	83 c4 10             	add    $0x10,%esp
    }
#endif

    proc->state = SLEEPING;
8010562c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105632:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

#ifdef CS333_P3P4
    proc->budget -= (ticks - proc->cpu_ticks_in); // update budget, then check
80105639:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010563f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105646:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
8010564c:	89 d3                	mov    %edx,%ebx
8010564e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105655:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
8010565b:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105661:	29 d1                	sub    %edx,%ecx
80105663:	89 ca                	mov    %ecx,%edx
80105665:	01 da                	add    %ebx,%edx
80105667:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if ((proc->budget) <= 0) {
8010566d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105673:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105679:	85 c0                	test   %eax,%eax
8010567b:	7f 36                	jg     801056b3 <sleep+0x11d>
        // priority cant be greater than MAX bc it is literal index of ready list array
        if ((proc->priority) < MAX) {
8010567d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105683:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105689:	83 f8 01             	cmp    $0x1,%eax
8010568c:	77 15                	ja     801056a3 <sleep+0x10d>
            ++(proc->priority); // Demotion
8010568e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105694:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
8010569a:	83 c2 01             	add    $0x1,%edx
8010569d:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        }
        proc->budget = BUDGET; // Reset budget
801056a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056a9:	c7 80 98 00 00 00 64 	movl   $0x64,0x98(%eax)
801056b0:	00 00 00 
    }
    if (addToStateListHead(&ptable.pLists.sleep, proc) < 0) {
801056b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056b9:	83 ec 08             	sub    $0x8,%esp
801056bc:	50                   	push   %eax
801056bd:	68 c4 70 11 80       	push   $0x801170c4
801056c2:	e8 b5 08 00 00       	call   80105f7c <addToStateListHead>
801056c7:	83 c4 10             	add    $0x10,%esp
801056ca:	85 c0                	test   %eax,%eax
801056cc:	79 10                	jns    801056de <sleep+0x148>
        cprintf("Could not add SLEEPING proc to list (sleep()).\n");
801056ce:	83 ec 0c             	sub    $0xc,%esp
801056d1:	68 d0 a6 10 80       	push   $0x8010a6d0
801056d6:	e8 eb ac ff ff       	call   801003c6 <cprintf>
801056db:	83 c4 10             	add    $0x10,%esp
    }
#endif

    sched();
801056de:	e8 3d fc ff ff       	call   80105320 <sched>

    // Tidy up.
    proc->chan = 0;
801056e3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056e9:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){ 
801056f0:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801056f7:	74 24                	je     8010571d <sleep+0x187>
        release(&ptable.lock);
801056f9:	83 ec 0c             	sub    $0xc,%esp
801056fc:	68 80 49 11 80       	push   $0x80114980
80105701:	e8 ac 11 00 00       	call   801068b2 <release>
80105706:	83 c4 10             	add    $0x10,%esp
        if (lk) acquire(lk);
80105709:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010570d:	74 0e                	je     8010571d <sleep+0x187>
8010570f:	83 ec 0c             	sub    $0xc,%esp
80105712:	ff 75 0c             	pushl  0xc(%ebp)
80105715:	e8 31 11 00 00       	call   8010684b <acquire>
8010571a:	83 c4 10             	add    $0x10,%esp
    }
}
8010571d:	90                   	nop
8010571e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105721:	c9                   	leave  
80105722:	c3                   	ret    

80105723 <wakeup1>:
}
#else
// P3 wakeup1
static void
wakeup1(void *chan)
{
80105723:	55                   	push   %ebp
80105724:	89 e5                	mov    %esp,%ebp
80105726:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    if (ptable.pLists.sleep) {
80105729:	a1 c4 70 11 80       	mov    0x801170c4,%eax
8010572e:	85 c0                	test   %eax,%eax
80105730:	0f 84 b8 00 00 00    	je     801057ee <wakeup1+0xcb>
        struct proc * current = ptable.pLists.sleep;
80105736:	a1 c4 70 11 80       	mov    0x801170c4,%eax
8010573b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = 0;
8010573e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        while (current) {
80105745:	e9 9a 00 00 00       	jmp    801057e4 <wakeup1+0xc1>
            p = current;
8010574a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010574d:	89 45 f0             	mov    %eax,-0x10(%ebp)
            current = current->next;
80105750:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105753:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105759:	89 45 f4             	mov    %eax,-0xc(%ebp)
            assertState(p, SLEEPING);
8010575c:	83 ec 08             	sub    $0x8,%esp
8010575f:	6a 02                	push   $0x2
80105761:	ff 75 f0             	pushl  -0x10(%ebp)
80105764:	e8 df 07 00 00       	call   80105f48 <assertState>
80105769:	83 c4 10             	add    $0x10,%esp
            if (p->chan == chan) {
8010576c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010576f:	8b 40 20             	mov    0x20(%eax),%eax
80105772:	3b 45 08             	cmp    0x8(%ebp),%eax
80105775:	75 6d                	jne    801057e4 <wakeup1+0xc1>
                if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
80105777:	83 ec 08             	sub    $0x8,%esp
8010577a:	ff 75 f0             	pushl  -0x10(%ebp)
8010577d:	68 c4 70 11 80       	push   $0x801170c4
80105782:	e8 e2 08 00 00       	call   80106069 <removeFromStateList>
80105787:	83 c4 10             	add    $0x10,%esp
8010578a:	85 c0                	test   %eax,%eax
8010578c:	79 10                	jns    8010579e <wakeup1+0x7b>
                    cprintf("Failed to remove SLEEPING proc to list (wakeup1).\n");
8010578e:	83 ec 0c             	sub    $0xc,%esp
80105791:	68 00 a7 10 80       	push   $0x8010a700
80105796:	e8 2b ac ff ff       	call   801003c6 <cprintf>
8010579b:	83 c4 10             	add    $0x10,%esp
                }
                p->state = RUNNABLE;
8010579e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057a1:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
801057a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ab:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801057b1:	05 cc 09 00 00       	add    $0x9cc,%eax
801057b6:	c1 e0 02             	shl    $0x2,%eax
801057b9:	05 80 49 11 80       	add    $0x80114980,%eax
801057be:	83 c0 04             	add    $0x4,%eax
801057c1:	83 ec 08             	sub    $0x8,%esp
801057c4:	ff 75 f0             	pushl  -0x10(%ebp)
801057c7:	50                   	push   %eax
801057c8:	e8 1b 08 00 00       	call   80105fe8 <addToStateListEnd>
801057cd:	83 c4 10             	add    $0x10,%esp
801057d0:	85 c0                	test   %eax,%eax
801057d2:	79 10                	jns    801057e4 <wakeup1+0xc1>
                    cprintf("Failed to add RUNNABLE proc to list (wakeup1).\n");
801057d4:	83 ec 0c             	sub    $0xc,%esp
801057d7:	68 34 a7 10 80       	push   $0x8010a734
801057dc:	e8 e5 ab ff ff       	call   801003c6 <cprintf>
801057e1:	83 c4 10             	add    $0x10,%esp
{
    struct proc *p;
    if (ptable.pLists.sleep) {
        struct proc * current = ptable.pLists.sleep;
        p = 0;
        while (current) {
801057e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057e8:	0f 85 5c ff ff ff    	jne    8010574a <wakeup1+0x27>
                    cprintf("Failed to add RUNNABLE proc to list (wakeup1).\n");
                }
            }
        }
    }
}
801057ee:	90                   	nop
801057ef:	c9                   	leave  
801057f0:	c3                   	ret    

801057f1 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801057f1:	55                   	push   %ebp
801057f2:	89 e5                	mov    %esp,%ebp
801057f4:	83 ec 08             	sub    $0x8,%esp
    acquire(&ptable.lock);
801057f7:	83 ec 0c             	sub    $0xc,%esp
801057fa:	68 80 49 11 80       	push   $0x80114980
801057ff:	e8 47 10 00 00       	call   8010684b <acquire>
80105804:	83 c4 10             	add    $0x10,%esp
    wakeup1(chan);
80105807:	83 ec 0c             	sub    $0xc,%esp
8010580a:	ff 75 08             	pushl  0x8(%ebp)
8010580d:	e8 11 ff ff ff       	call   80105723 <wakeup1>
80105812:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105815:	83 ec 0c             	sub    $0xc,%esp
80105818:	68 80 49 11 80       	push   $0x80114980
8010581d:	e8 90 10 00 00       	call   801068b2 <release>
80105822:	83 c4 10             	add    $0x10,%esp
}
80105825:	90                   	nop
80105826:	c9                   	leave  
80105827:	c3                   	ret    

80105828 <kill>:
    return -1;
}
#else
int
kill(int pid)
{
80105828:	55                   	push   %ebp
80105829:	89 e5                	mov    %esp,%ebp
8010582b:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;

    acquire(&ptable.lock);
8010582e:	83 ec 0c             	sub    $0xc,%esp
80105831:	68 80 49 11 80       	push   $0x80114980
80105836:	e8 10 10 00 00       	call   8010684b <acquire>
8010583b:	83 c4 10             	add    $0x10,%esp
    // traverse Sleeping list, wake processes if necessary
    p = ptable.pLists.sleep;
8010583e:	a1 c4 70 11 80       	mov    0x801170c4,%eax
80105843:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105846:	e9 be 00 00 00       	jmp    80105909 <kill+0xe1>
        if (p->pid == pid) {
8010584b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010584e:	8b 50 10             	mov    0x10(%eax),%edx
80105851:	8b 45 08             	mov    0x8(%ebp),%eax
80105854:	39 c2                	cmp    %eax,%edx
80105856:	0f 85 a1 00 00 00    	jne    801058fd <kill+0xd5>
            p->killed = 1;
8010585c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            assertState(p, SLEEPING);
80105866:	83 ec 08             	sub    $0x8,%esp
80105869:	6a 02                	push   $0x2
8010586b:	ff 75 f4             	pushl  -0xc(%ebp)
8010586e:	e8 d5 06 00 00       	call   80105f48 <assertState>
80105873:	83 c4 10             	add    $0x10,%esp
            if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
80105876:	83 ec 08             	sub    $0x8,%esp
80105879:	ff 75 f4             	pushl  -0xc(%ebp)
8010587c:	68 c4 70 11 80       	push   $0x801170c4
80105881:	e8 e3 07 00 00       	call   80106069 <removeFromStateList>
80105886:	83 c4 10             	add    $0x10,%esp
80105889:	85 c0                	test   %eax,%eax
8010588b:	79 10                	jns    8010589d <kill+0x75>
                cprintf("Could not remove SLEEPING proc from list (kill).\n");
8010588d:	83 ec 0c             	sub    $0xc,%esp
80105890:	68 64 a7 10 80       	push   $0x8010a764
80105895:	e8 2c ab ff ff       	call   801003c6 <cprintf>
8010589a:	83 c4 10             	add    $0x10,%esp
            }
            p->state = RUNNABLE;
8010589d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058a0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
801058a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058aa:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801058b0:	05 cc 09 00 00       	add    $0x9cc,%eax
801058b5:	c1 e0 02             	shl    $0x2,%eax
801058b8:	05 80 49 11 80       	add    $0x80114980,%eax
801058bd:	83 c0 04             	add    $0x4,%eax
801058c0:	83 ec 08             	sub    $0x8,%esp
801058c3:	ff 75 f4             	pushl  -0xc(%ebp)
801058c6:	50                   	push   %eax
801058c7:	e8 1c 07 00 00       	call   80105fe8 <addToStateListEnd>
801058cc:	83 c4 10             	add    $0x10,%esp
801058cf:	85 c0                	test   %eax,%eax
801058d1:	79 10                	jns    801058e3 <kill+0xbb>
                cprintf("Could not add RUNNABLE proc to list (kill).\n");
801058d3:	83 ec 0c             	sub    $0xc,%esp
801058d6:	68 98 a7 10 80       	push   $0x8010a798
801058db:	e8 e6 aa ff ff       	call   801003c6 <cprintf>
801058e0:	83 c4 10             	add    $0x10,%esp
            }
            release(&ptable.lock);
801058e3:	83 ec 0c             	sub    $0xc,%esp
801058e6:	68 80 49 11 80       	push   $0x80114980
801058eb:	e8 c2 0f 00 00       	call   801068b2 <release>
801058f0:	83 c4 10             	add    $0x10,%esp
            return 0;
801058f3:	b8 00 00 00 00       	mov    $0x0,%eax
801058f8:	e9 c3 01 00 00       	jmp    80105ac0 <kill+0x298>
        }
        p = p->next;
801058fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105900:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105906:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct proc *p;

    acquire(&ptable.lock);
    // traverse Sleeping list, wake processes if necessary
    p = ptable.pLists.sleep;
    while (p) {
80105909:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010590d:	0f 85 38 ff ff ff    	jne    8010584b <kill+0x23>
        }
        p = p->next;
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
80105913:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010591a:	eb 5b                	jmp    80105977 <kill+0x14f>
        p = ptable.pLists.ready[i];
8010591c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010591f:	05 cc 09 00 00       	add    $0x9cc,%eax
80105924:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
8010592b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
8010592e:	eb 3d                	jmp    8010596d <kill+0x145>
            if (p->pid == pid) {
80105930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105933:	8b 50 10             	mov    0x10(%eax),%edx
80105936:	8b 45 08             	mov    0x8(%ebp),%eax
80105939:	39 c2                	cmp    %eax,%edx
8010593b:	75 24                	jne    80105961 <kill+0x139>
                p->killed = 1;
8010593d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105940:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
                release(&ptable.lock);
80105947:	83 ec 0c             	sub    $0xc,%esp
8010594a:	68 80 49 11 80       	push   $0x80114980
8010594f:	e8 5e 0f 00 00       	call   801068b2 <release>
80105954:	83 c4 10             	add    $0x10,%esp
                return 0;
80105957:	b8 00 00 00 00       	mov    $0x0,%eax
8010595c:	e9 5f 01 00 00       	jmp    80105ac0 <kill+0x298>
            }
            p = p->next;
80105961:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105964:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010596a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i];
        while (p) {
8010596d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105971:	75 bd                	jne    80105930 <kill+0x108>
        }
        p = p->next;
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
80105973:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105977:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
8010597b:	7e 9f                	jle    8010591c <kill+0xf4>
            p = p->next;
        }
    }

    // traverse Running list
    p = ptable.pLists.running;
8010597d:	a1 cc 70 11 80       	mov    0x801170cc,%eax
80105982:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105985:	eb 3d                	jmp    801059c4 <kill+0x19c>
        if (p->pid == pid) {
80105987:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598a:	8b 50 10             	mov    0x10(%eax),%edx
8010598d:	8b 45 08             	mov    0x8(%ebp),%eax
80105990:	39 c2                	cmp    %eax,%edx
80105992:	75 24                	jne    801059b8 <kill+0x190>
            p->killed = 1;
80105994:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105997:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
8010599e:	83 ec 0c             	sub    $0xc,%esp
801059a1:	68 80 49 11 80       	push   $0x80114980
801059a6:	e8 07 0f 00 00       	call   801068b2 <release>
801059ab:	83 c4 10             	add    $0x10,%esp
            return 0;
801059ae:	b8 00 00 00 00       	mov    $0x0,%eax
801059b3:	e9 08 01 00 00       	jmp    80105ac0 <kill+0x298>
        }
        p = p->next;
801059b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059bb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
    }

    // traverse Running list
    p = ptable.pLists.running;
    while (p) {
801059c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059c8:	75 bd                	jne    80105987 <kill+0x15f>
        }
        p = p->next;
    }

    // traverse Unused List
    p = ptable.pLists.free;
801059ca:	a1 c0 70 11 80       	mov    0x801170c0,%eax
801059cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801059d2:	eb 3d                	jmp    80105a11 <kill+0x1e9>
        if (p->pid == pid) {
801059d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d7:	8b 50 10             	mov    0x10(%eax),%edx
801059da:	8b 45 08             	mov    0x8(%ebp),%eax
801059dd:	39 c2                	cmp    %eax,%edx
801059df:	75 24                	jne    80105a05 <kill+0x1dd>
            p->killed = 1;
801059e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059e4:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
801059eb:	83 ec 0c             	sub    $0xc,%esp
801059ee:	68 80 49 11 80       	push   $0x80114980
801059f3:	e8 ba 0e 00 00       	call   801068b2 <release>
801059f8:	83 c4 10             	add    $0x10,%esp
            return 0;
801059fb:	b8 00 00 00 00       	mov    $0x0,%eax
80105a00:	e9 bb 00 00 00       	jmp    80105ac0 <kill+0x298>
        }
        p = p->next;
80105a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a08:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Unused List
    p = ptable.pLists.free;
    while (p) {
80105a11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a15:	75 bd                	jne    801059d4 <kill+0x1ac>
        }
        p = p->next;
    }

    // traverse Zombie list
    p = ptable.pLists.zombie;
80105a17:	a1 c8 70 11 80       	mov    0x801170c8,%eax
80105a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105a1f:	eb 3a                	jmp    80105a5b <kill+0x233>
        if (p->pid == pid) {
80105a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a24:	8b 50 10             	mov    0x10(%eax),%edx
80105a27:	8b 45 08             	mov    0x8(%ebp),%eax
80105a2a:	39 c2                	cmp    %eax,%edx
80105a2c:	75 21                	jne    80105a4f <kill+0x227>
            p->killed = 1;
80105a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a31:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105a38:	83 ec 0c             	sub    $0xc,%esp
80105a3b:	68 80 49 11 80       	push   $0x80114980
80105a40:	e8 6d 0e 00 00       	call   801068b2 <release>
80105a45:	83 c4 10             	add    $0x10,%esp
            return 0;
80105a48:	b8 00 00 00 00       	mov    $0x0,%eax
80105a4d:	eb 71                	jmp    80105ac0 <kill+0x298>
        }
        p = p->next;
80105a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a52:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105a58:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Zombie list
    p = ptable.pLists.zombie;
    while (p) {
80105a5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a5f:	75 c0                	jne    80105a21 <kill+0x1f9>
        }
        p = p->next;
    }

    // traverse Embryo list
    p = ptable.pLists.embryo;
80105a61:	a1 d0 70 11 80       	mov    0x801170d0,%eax
80105a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105a69:	eb 3a                	jmp    80105aa5 <kill+0x27d>
        if (p->pid == pid) {
80105a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a6e:	8b 50 10             	mov    0x10(%eax),%edx
80105a71:	8b 45 08             	mov    0x8(%ebp),%eax
80105a74:	39 c2                	cmp    %eax,%edx
80105a76:	75 21                	jne    80105a99 <kill+0x271>
            p->killed = 1;
80105a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a7b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105a82:	83 ec 0c             	sub    $0xc,%esp
80105a85:	68 80 49 11 80       	push   $0x80114980
80105a8a:	e8 23 0e 00 00       	call   801068b2 <release>
80105a8f:	83 c4 10             	add    $0x10,%esp
            return 0;
80105a92:	b8 00 00 00 00       	mov    $0x0,%eax
80105a97:	eb 27                	jmp    80105ac0 <kill+0x298>
        }
        p = p->next;
80105a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a9c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105aa2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Embryo list
    p = ptable.pLists.embryo;
    while (p) {
80105aa5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aa9:	75 c0                	jne    80105a6b <kill+0x243>
        }
        p = p->next;
    }

    // return error
    release(&ptable.lock);
80105aab:	83 ec 0c             	sub    $0xc,%esp
80105aae:	68 80 49 11 80       	push   $0x80114980
80105ab3:	e8 fa 0d 00 00       	call   801068b2 <release>
80105ab8:	83 c4 10             	add    $0x10,%esp
    return -1;
80105abb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ac0:	c9                   	leave  
80105ac1:	c3                   	ret    

80105ac2 <elapsed_time>:
// No lock to avoid wedging a stuck machine further.

#ifdef CS333_P1
void
elapsed_time(uint p_ticks)
{
80105ac2:	55                   	push   %ebp
80105ac3:	89 e5                	mov    %esp,%ebp
80105ac5:	83 ec 28             	sub    $0x28,%esp
    uint elapsed, whole_sec, milisec_ten, milisec_hund, milisec_thou;
    //elapsed = ticks - p->start_ticks; // find original elapsed time
    elapsed = p_ticks;
80105ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80105acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    whole_sec = (elapsed / 1000); // the the left of the decimal point
80105ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad1:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105ad6:	f7 e2                	mul    %edx
80105ad8:	89 d0                	mov    %edx,%eax
80105ada:	c1 e8 06             	shr    $0x6,%eax
80105add:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // % to shave off leading digit of elapsed for decimal place calcs
    milisec_ten = ((elapsed %= 1000) / 100); // divide and round up to nearest int
80105ae0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105ae3:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105ae8:	89 c8                	mov    %ecx,%eax
80105aea:	f7 e2                	mul    %edx
80105aec:	89 d0                	mov    %edx,%eax
80105aee:	c1 e8 06             	shr    $0x6,%eax
80105af1:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
80105af7:	29 c1                	sub    %eax,%ecx
80105af9:	89 c8                	mov    %ecx,%eax
80105afb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b01:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105b06:	f7 e2                	mul    %edx
80105b08:	89 d0                	mov    %edx,%eax
80105b0a:	c1 e8 05             	shr    $0x5,%eax
80105b0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    milisec_hund = ((elapsed %= 100) / 10); // shave off previously counted int, repeat
80105b10:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105b13:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105b18:	89 c8                	mov    %ecx,%eax
80105b1a:	f7 e2                	mul    %edx
80105b1c:	89 d0                	mov    %edx,%eax
80105b1e:	c1 e8 05             	shr    $0x5,%eax
80105b21:	6b c0 64             	imul   $0x64,%eax,%eax
80105b24:	29 c1                	sub    %eax,%ecx
80105b26:	89 c8                	mov    %ecx,%eax
80105b28:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105b33:	f7 e2                	mul    %edx
80105b35:	89 d0                	mov    %edx,%eax
80105b37:	c1 e8 03             	shr    $0x3,%eax
80105b3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    milisec_thou = (elapsed %= 10); // determine thousandth place
80105b3d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105b40:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105b45:	89 c8                	mov    %ecx,%eax
80105b47:	f7 e2                	mul    %edx
80105b49:	c1 ea 03             	shr    $0x3,%edx
80105b4c:	89 d0                	mov    %edx,%eax
80105b4e:	c1 e0 02             	shl    $0x2,%eax
80105b51:	01 d0                	add    %edx,%eax
80105b53:	01 c0                	add    %eax,%eax
80105b55:	29 c1                	sub    %eax,%ecx
80105b57:	89 c8                	mov    %ecx,%eax
80105b59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("\t%d.%d%d%d", whole_sec, milisec_ten, milisec_hund, milisec_thou);
80105b62:	83 ec 0c             	sub    $0xc,%esp
80105b65:	ff 75 e4             	pushl  -0x1c(%ebp)
80105b68:	ff 75 e8             	pushl  -0x18(%ebp)
80105b6b:	ff 75 ec             	pushl  -0x14(%ebp)
80105b6e:	ff 75 f0             	pushl  -0x10(%ebp)
80105b71:	68 c5 a7 10 80       	push   $0x8010a7c5
80105b76:	e8 4b a8 ff ff       	call   801003c6 <cprintf>
80105b7b:	83 c4 20             	add    $0x20,%esp
}
80105b7e:	90                   	nop
80105b7f:	c9                   	leave  
80105b80:	c3                   	ret    

80105b81 <procdump>:
#else

// Project 3 & 4
void
procdump(void)
{
80105b81:	55                   	push   %ebp
80105b82:	89 e5                	mov    %esp,%ebp
80105b84:	56                   	push   %esi
80105b85:	53                   	push   %ebx
80105b86:	83 ec 40             	sub    $0x40,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
80105b89:	68 d0 a7 10 80       	push   $0x8010a7d0
80105b8e:	68 d4 a7 10 80       	push   $0x8010a7d4
80105b93:	68 d9 a7 10 80       	push   $0x8010a7d9
80105b98:	68 df a7 10 80       	push   $0x8010a7df
80105b9d:	68 e3 a7 10 80       	push   $0x8010a7e3
80105ba2:	68 eb a7 10 80       	push   $0x8010a7eb
80105ba7:	68 f0 a7 10 80       	push   $0x8010a7f0
80105bac:	68 f5 a7 10 80       	push   $0x8010a7f5
80105bb1:	68 f9 a7 10 80       	push   $0x8010a7f9
80105bb6:	68 fd a7 10 80       	push   $0x8010a7fd
80105bbb:	68 02 a8 10 80       	push   $0x8010a802
80105bc0:	68 08 a8 10 80       	push   $0x8010a808
80105bc5:	e8 fc a7 ff ff       	call   801003c6 <cprintf>
80105bca:	83 c4 30             	add    $0x30,%esp
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105bcd:	c7 45 f0 b4 49 11 80 	movl   $0x801149b4,-0x10(%ebp)
80105bd4:	e9 5c 01 00 00       	jmp    80105d35 <procdump+0x1b4>
        if(p->state == UNUSED)
80105bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bdc:	8b 40 0c             	mov    0xc(%eax),%eax
80105bdf:	85 c0                	test   %eax,%eax
80105be1:	0f 84 46 01 00 00    	je     80105d2d <procdump+0x1ac>
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bea:	8b 40 0c             	mov    0xc(%eax),%eax
80105bed:	83 f8 05             	cmp    $0x5,%eax
80105bf0:	77 23                	ja     80105c15 <procdump+0x94>
80105bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bf5:	8b 40 0c             	mov    0xc(%eax),%eax
80105bf8:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105bff:	85 c0                	test   %eax,%eax
80105c01:	74 12                	je     80105c15 <procdump+0x94>
            state = states[p->state];
80105c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c06:	8b 40 0c             	mov    0xc(%eax),%eax
80105c09:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105c10:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105c13:	eb 07                	jmp    80105c1c <procdump+0x9b>
        else
            state = "???";
80105c15:	c7 45 ec 2b a8 10 80 	movl   $0x8010a82b,-0x14(%ebp)
        cprintf("%d\t%s\t%d\t%d\t%d",
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
80105c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c1f:	8b 40 14             	mov    0x14(%eax),%eax
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d\t%s\t%d\t%d\t%d",
80105c22:	8b 58 10             	mov    0x10(%eax),%ebx
80105c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c28:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c31:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
80105c37:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c3a:	8d 70 6c             	lea    0x6c(%eax),%esi
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d\t%s\t%d\t%d\t%d",
80105c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c40:	8b 40 10             	mov    0x10(%eax),%eax
80105c43:	83 ec 08             	sub    $0x8,%esp
80105c46:	53                   	push   %ebx
80105c47:	51                   	push   %ecx
80105c48:	52                   	push   %edx
80105c49:	56                   	push   %esi
80105c4a:	50                   	push   %eax
80105c4b:	68 2f a8 10 80       	push   $0x8010a82f
80105c50:	e8 71 a7 ff ff       	call   801003c6 <cprintf>
80105c55:	83 c4 20             	add    $0x20,%esp
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
        cprintf("\t%d", p->priority);
80105c58:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c5b:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105c61:	83 ec 08             	sub    $0x8,%esp
80105c64:	50                   	push   %eax
80105c65:	68 3e a8 10 80       	push   $0x8010a83e
80105c6a:	e8 57 a7 ff ff       	call   801003c6 <cprintf>
80105c6f:	83 c4 10             	add    $0x10,%esp
        elapsed_time(ticks - p->start_ticks);
80105c72:	8b 15 e0 78 11 80    	mov    0x801178e0,%edx
80105c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c7b:	8b 40 7c             	mov    0x7c(%eax),%eax
80105c7e:	29 c2                	sub    %eax,%edx
80105c80:	89 d0                	mov    %edx,%eax
80105c82:	83 ec 0c             	sub    $0xc,%esp
80105c85:	50                   	push   %eax
80105c86:	e8 37 fe ff ff       	call   80105ac2 <elapsed_time>
80105c8b:	83 c4 10             	add    $0x10,%esp
        elapsed_time(p->cpu_ticks_total);
80105c8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c91:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105c97:	83 ec 0c             	sub    $0xc,%esp
80105c9a:	50                   	push   %eax
80105c9b:	e8 22 fe ff ff       	call   80105ac2 <elapsed_time>
80105ca0:	83 c4 10             	add    $0x10,%esp
        cprintf("\t%s\t%d", state, p->sz);
80105ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ca6:	8b 00                	mov    (%eax),%eax
80105ca8:	83 ec 04             	sub    $0x4,%esp
80105cab:	50                   	push   %eax
80105cac:	ff 75 ec             	pushl  -0x14(%ebp)
80105caf:	68 42 a8 10 80       	push   $0x8010a842
80105cb4:	e8 0d a7 ff ff       	call   801003c6 <cprintf>
80105cb9:	83 c4 10             	add    $0x10,%esp

        if(p->state == SLEEPING){
80105cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cbf:	8b 40 0c             	mov    0xc(%eax),%eax
80105cc2:	83 f8 02             	cmp    $0x2,%eax
80105cc5:	75 54                	jne    80105d1b <procdump+0x19a>
            getcallerpcs((uint*)p->context->ebp+2, pc);
80105cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cca:	8b 40 1c             	mov    0x1c(%eax),%eax
80105ccd:	8b 40 0c             	mov    0xc(%eax),%eax
80105cd0:	83 c0 08             	add    $0x8,%eax
80105cd3:	89 c2                	mov    %eax,%edx
80105cd5:	83 ec 08             	sub    $0x8,%esp
80105cd8:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105cdb:	50                   	push   %eax
80105cdc:	52                   	push   %edx
80105cdd:	e8 22 0c 00 00       	call   80106904 <getcallerpcs>
80105ce2:	83 c4 10             	add    $0x10,%esp
            for(i=0; i<10 && pc[i] != 0; i++)
80105ce5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105cec:	eb 1c                	jmp    80105d0a <procdump+0x189>
                cprintf("\t%p", pc[i]);
80105cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf1:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105cf5:	83 ec 08             	sub    $0x8,%esp
80105cf8:	50                   	push   %eax
80105cf9:	68 49 a8 10 80       	push   $0x8010a849
80105cfe:	e8 c3 a6 ff ff       	call   801003c6 <cprintf>
80105d03:	83 c4 10             	add    $0x10,%esp
        elapsed_time(p->cpu_ticks_total);
        cprintf("\t%s\t%d", state, p->sz);

        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
80105d06:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105d0a:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105d0e:	7f 0b                	jg     80105d1b <procdump+0x19a>
80105d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d13:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105d17:	85 c0                	test   %eax,%eax
80105d19:	75 d3                	jne    80105cee <procdump+0x16d>
                cprintf("\t%p", pc[i]);
        }
        cprintf("\n");
80105d1b:	83 ec 0c             	sub    $0xc,%esp
80105d1e:	68 4d a8 10 80       	push   $0x8010a84d
80105d23:	e8 9e a6 ff ff       	call   801003c6 <cprintf>
80105d28:	83 c4 10             	add    $0x10,%esp
80105d2b:	eb 01                	jmp    80105d2e <procdump+0x1ad>
    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
80105d2d:	90                   	nop
    uint pc[10];

    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105d2e:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105d35:	81 7d f0 b4 70 11 80 	cmpl   $0x801170b4,-0x10(%ebp)
80105d3c:	0f 82 97 fe ff ff    	jb     80105bd9 <procdump+0x58>
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf("\t%p", pc[i]);
        }
        cprintf("\n");
    }
}
80105d42:	90                   	nop
80105d43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d46:	5b                   	pop    %ebx
80105d47:	5e                   	pop    %esi
80105d48:	5d                   	pop    %ebp
80105d49:	c3                   	ret    

80105d4a <getprocs>:
#ifdef CS333_P2
// loop process table and copy active processes, return number of copied procs
// populate uproc array passed in from ps.c
int
getprocs(uint max, struct uproc *table)
{
80105d4a:	55                   	push   %ebp
80105d4b:	89 e5                	mov    %esp,%ebp
80105d4d:	83 ec 18             	sub    $0x18,%esp
    int i = 0;
80105d50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct proc *p;
    acquire(&ptable.lock);
80105d57:	83 ec 0c             	sub    $0xc,%esp
80105d5a:	68 80 49 11 80       	push   $0x80114980
80105d5f:	e8 e7 0a 00 00       	call   8010684b <acquire>
80105d64:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
80105d67:	c7 45 f0 b4 49 11 80 	movl   $0x801149b4,-0x10(%ebp)
80105d6e:	e9 ab 01 00 00       	jmp    80105f1e <getprocs+0x1d4>
        // only copy active processes
        if (p->state == RUNNABLE || p->state == RUNNING || p->state == SLEEPING) {
80105d73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d76:	8b 40 0c             	mov    0xc(%eax),%eax
80105d79:	83 f8 03             	cmp    $0x3,%eax
80105d7c:	74 1a                	je     80105d98 <getprocs+0x4e>
80105d7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d81:	8b 40 0c             	mov    0xc(%eax),%eax
80105d84:	83 f8 04             	cmp    $0x4,%eax
80105d87:	74 0f                	je     80105d98 <getprocs+0x4e>
80105d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d8c:	8b 40 0c             	mov    0xc(%eax),%eax
80105d8f:	83 f8 02             	cmp    $0x2,%eax
80105d92:	0f 85 7f 01 00 00    	jne    80105f17 <getprocs+0x1cd>
            table[i].pid = p->pid;
80105d98:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105d9b:	89 d0                	mov    %edx,%eax
80105d9d:	01 c0                	add    %eax,%eax
80105d9f:	01 d0                	add    %edx,%eax
80105da1:	c1 e0 05             	shl    $0x5,%eax
80105da4:	89 c2                	mov    %eax,%edx
80105da6:	8b 45 0c             	mov    0xc(%ebp),%eax
80105da9:	01 c2                	add    %eax,%edx
80105dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dae:	8b 40 10             	mov    0x10(%eax),%eax
80105db1:	89 02                	mov    %eax,(%edx)
            table[i].uid = p->uid;
80105db3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105db6:	89 d0                	mov    %edx,%eax
80105db8:	01 c0                	add    %eax,%eax
80105dba:	01 d0                	add    %edx,%eax
80105dbc:	c1 e0 05             	shl    $0x5,%eax
80105dbf:	89 c2                	mov    %eax,%edx
80105dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dc4:	01 c2                	add    %eax,%edx
80105dc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc9:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105dcf:	89 42 04             	mov    %eax,0x4(%edx)
            table[i].gid = p->gid;
80105dd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dd5:	89 d0                	mov    %edx,%eax
80105dd7:	01 c0                	add    %eax,%eax
80105dd9:	01 d0                	add    %edx,%eax
80105ddb:	c1 e0 05             	shl    $0x5,%eax
80105dde:	89 c2                	mov    %eax,%edx
80105de0:	8b 45 0c             	mov    0xc(%ebp),%eax
80105de3:	01 c2                	add    %eax,%edx
80105de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de8:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105dee:	89 42 08             	mov    %eax,0x8(%edx)
            if (p->pid == 1) {
80105df1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105df4:	8b 40 10             	mov    0x10(%eax),%eax
80105df7:	83 f8 01             	cmp    $0x1,%eax
80105dfa:	75 1c                	jne    80105e18 <getprocs+0xce>
                table[i].ppid = 1;
80105dfc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105dff:	89 d0                	mov    %edx,%eax
80105e01:	01 c0                	add    %eax,%eax
80105e03:	01 d0                	add    %edx,%eax
80105e05:	c1 e0 05             	shl    $0x5,%eax
80105e08:	89 c2                	mov    %eax,%edx
80105e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e0d:	01 d0                	add    %edx,%eax
80105e0f:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
80105e16:	eb 1f                	jmp    80105e37 <getprocs+0xed>
            } else {
                table[i].ppid = p->parent->pid;
80105e18:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e1b:	89 d0                	mov    %edx,%eax
80105e1d:	01 c0                	add    %eax,%eax
80105e1f:	01 d0                	add    %edx,%eax
80105e21:	c1 e0 05             	shl    $0x5,%eax
80105e24:	89 c2                	mov    %eax,%edx
80105e26:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e29:	01 c2                	add    %eax,%edx
80105e2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e2e:	8b 40 14             	mov    0x14(%eax),%eax
80105e31:	8b 40 10             	mov    0x10(%eax),%eax
80105e34:	89 42 0c             	mov    %eax,0xc(%edx)
            }
#ifdef CS333_P3P4
            table[i].priority = p->priority;
80105e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e3a:	89 d0                	mov    %edx,%eax
80105e3c:	01 c0                	add    %eax,%eax
80105e3e:	01 d0                	add    %edx,%eax
80105e40:	c1 e0 05             	shl    $0x5,%eax
80105e43:	89 c2                	mov    %eax,%edx
80105e45:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e48:	01 c2                	add    %eax,%edx
80105e4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e4d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105e53:	89 42 5c             	mov    %eax,0x5c(%edx)
#endif
            table[i].elapsed_ticks = (ticks - p->start_ticks);
80105e56:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e59:	89 d0                	mov    %edx,%eax
80105e5b:	01 c0                	add    %eax,%eax
80105e5d:	01 d0                	add    %edx,%eax
80105e5f:	c1 e0 05             	shl    $0x5,%eax
80105e62:	89 c2                	mov    %eax,%edx
80105e64:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e67:	01 c2                	add    %eax,%edx
80105e69:	8b 0d e0 78 11 80    	mov    0x801178e0,%ecx
80105e6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e72:	8b 40 7c             	mov    0x7c(%eax),%eax
80105e75:	29 c1                	sub    %eax,%ecx
80105e77:	89 c8                	mov    %ecx,%eax
80105e79:	89 42 10             	mov    %eax,0x10(%edx)
            table[i].CPU_total_ticks = p->cpu_ticks_total;
80105e7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e7f:	89 d0                	mov    %edx,%eax
80105e81:	01 c0                	add    %eax,%eax
80105e83:	01 d0                	add    %edx,%eax
80105e85:	c1 e0 05             	shl    $0x5,%eax
80105e88:	89 c2                	mov    %eax,%edx
80105e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e8d:	01 c2                	add    %eax,%edx
80105e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e92:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105e98:	89 42 14             	mov    %eax,0x14(%edx)
            safestrcpy(table[i].state, states[p->state], STRMAX);
80105e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e9e:	8b 40 0c             	mov    0xc(%eax),%eax
80105ea1:	8b 0c 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%ecx
80105ea8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105eab:	89 d0                	mov    %edx,%eax
80105ead:	01 c0                	add    %eax,%eax
80105eaf:	01 d0                	add    %edx,%eax
80105eb1:	c1 e0 05             	shl    $0x5,%eax
80105eb4:	89 c2                	mov    %eax,%edx
80105eb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80105eb9:	01 d0                	add    %edx,%eax
80105ebb:	83 c0 18             	add    $0x18,%eax
80105ebe:	83 ec 04             	sub    $0x4,%esp
80105ec1:	6a 20                	push   $0x20
80105ec3:	51                   	push   %ecx
80105ec4:	50                   	push   %eax
80105ec5:	e8 e7 0d 00 00       	call   80106cb1 <safestrcpy>
80105eca:	83 c4 10             	add    $0x10,%esp
            table[i].size = p->sz;
80105ecd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ed0:	89 d0                	mov    %edx,%eax
80105ed2:	01 c0                	add    %eax,%eax
80105ed4:	01 d0                	add    %edx,%eax
80105ed6:	c1 e0 05             	shl    $0x5,%eax
80105ed9:	89 c2                	mov    %eax,%edx
80105edb:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ede:	01 c2                	add    %eax,%edx
80105ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ee3:	8b 00                	mov    (%eax),%eax
80105ee5:	89 42 38             	mov    %eax,0x38(%edx)
            safestrcpy(table[i].name, p->name, STRMAX);
80105ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eeb:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105eee:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105ef1:	89 d0                	mov    %edx,%eax
80105ef3:	01 c0                	add    %eax,%eax
80105ef5:	01 d0                	add    %edx,%eax
80105ef7:	c1 e0 05             	shl    $0x5,%eax
80105efa:	89 c2                	mov    %eax,%edx
80105efc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105eff:	01 d0                	add    %edx,%eax
80105f01:	83 c0 3c             	add    $0x3c,%eax
80105f04:	83 ec 04             	sub    $0x4,%esp
80105f07:	6a 20                	push   $0x20
80105f09:	51                   	push   %ecx
80105f0a:	50                   	push   %eax
80105f0b:	e8 a1 0d 00 00       	call   80106cb1 <safestrcpy>
80105f10:	83 c4 10             	add    $0x10,%esp
            ++i;
80105f13:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
getprocs(uint max, struct uproc *table)
{
    int i = 0;
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
80105f17:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105f1e:	81 7d f0 b4 70 11 80 	cmpl   $0x801170b4,-0x10(%ebp)
80105f25:	73 0c                	jae    80105f33 <getprocs+0x1e9>
80105f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f2a:	3b 45 08             	cmp    0x8(%ebp),%eax
80105f2d:	0f 82 40 fe ff ff    	jb     80105d73 <getprocs+0x29>
            table[i].size = p->sz;
            safestrcpy(table[i].name, p->name, STRMAX);
            ++i;
        }
    }
    release(&ptable.lock);
80105f33:	83 ec 0c             	sub    $0xc,%esp
80105f36:	68 80 49 11 80       	push   $0x80114980
80105f3b:	e8 72 09 00 00       	call   801068b2 <release>
80105f40:	83 c4 10             	add    $0x10,%esp
    return i; // return number of procs copied
80105f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105f46:	c9                   	leave  
80105f47:	c3                   	ret    

80105f48 <assertState>:


//PROJECT 3
// assert that process is in proper state, otherwise panic
static void
assertState(struct proc* p, enum procstate state) {
80105f48:	55                   	push   %ebp
80105f49:	89 e5                	mov    %esp,%ebp
80105f4b:	83 ec 08             	sub    $0x8,%esp
    if (!p) {
80105f4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105f52:	75 0d                	jne    80105f61 <assertState+0x19>
        panic("assertState: invalid proc argument.\n");
80105f54:	83 ec 0c             	sub    $0xc,%esp
80105f57:	68 50 a8 10 80       	push   $0x8010a850
80105f5c:	e8 05 a6 ff ff       	call   80100566 <panic>
    }
    if (p->state != state) {
80105f61:	8b 45 08             	mov    0x8(%ebp),%eax
80105f64:	8b 40 0c             	mov    0xc(%eax),%eax
80105f67:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105f6a:	74 0d                	je     80105f79 <assertState+0x31>
        panic("assertState: process in wrong state.\n");
80105f6c:	83 ec 0c             	sub    $0xc,%esp
80105f6f:	68 78 a8 10 80       	push   $0x8010a878
80105f74:	e8 ed a5 ff ff       	call   80100566 <panic>
    }
}
80105f79:	90                   	nop
80105f7a:	c9                   	leave  
80105f7b:	c3                   	ret    

80105f7c <addToStateListHead>:

static int
addToStateListHead(struct proc** sList, struct proc* p) {
80105f7c:	55                   	push   %ebp
80105f7d:	89 e5                	mov    %esp,%ebp
80105f7f:	83 ec 08             	sub    $0x8,%esp
    if (!p) {
80105f82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105f86:	75 0d                	jne    80105f95 <addToStateListHead+0x19>
        panic("Invalid process.");
80105f88:	83 ec 0c             	sub    $0xc,%esp
80105f8b:	68 9e a8 10 80       	push   $0x8010a89e
80105f90:	e8 d1 a5 ff ff       	call   80100566 <panic>
    }
    if (!(*sList)) { // if no list exists, make first entry
80105f95:	8b 45 08             	mov    0x8(%ebp),%eax
80105f98:	8b 00                	mov    (%eax),%eax
80105f9a:	85 c0                	test   %eax,%eax
80105f9c:	75 1c                	jne    80105fba <addToStateListHead+0x3e>
        (*sList) = p; // arg proc is now the first item in list
80105f9e:	8b 45 08             	mov    0x8(%ebp),%eax
80105fa1:	8b 55 0c             	mov    0xc(%ebp),%edx
80105fa4:	89 10                	mov    %edx,(%eax)
        p->next = 0; // next is null
80105fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fa9:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105fb0:	00 00 00 
        return 0; // return success
80105fb3:	b8 00 00 00 00       	mov    $0x0,%eax
80105fb8:	eb 2c                	jmp    80105fe6 <addToStateListHead+0x6a>
    }
    // otherwise hold to next element and become 1st element
    p->next = (*sList); // arg proc has next element
80105fba:	8b 45 08             	mov    0x8(%ebp),%eax
80105fbd:	8b 10                	mov    (%eax),%edx
80105fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80105fc2:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    (*sList) = p; // reassign head of list to arg proc
80105fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80105fcb:	8b 55 0c             	mov    0xc(%ebp),%edx
80105fce:	89 10                	mov    %edx,(%eax)
    if (p != (*sList)) {
80105fd0:	8b 45 08             	mov    0x8(%ebp),%eax
80105fd3:	8b 00                	mov    (%eax),%eax
80105fd5:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105fd8:	74 07                	je     80105fe1 <addToStateListHead+0x65>
        return -1; // if they don't match, return failure
80105fda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fdf:	eb 05                	jmp    80105fe6 <addToStateListHead+0x6a>
    }
    return 0; // return success
80105fe1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105fe6:	c9                   	leave  
80105fe7:	c3                   	ret    

80105fe8 <addToStateListEnd>:

static int
addToStateListEnd(struct proc** sList, struct proc* p) {
80105fe8:	55                   	push   %ebp
80105fe9:	89 e5                	mov    %esp,%ebp
80105feb:	83 ec 18             	sub    $0x18,%esp
    if (!p) {
80105fee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105ff2:	75 0d                	jne    80106001 <addToStateListEnd+0x19>
        panic("Invalid process.");
80105ff4:	83 ec 0c             	sub    $0xc,%esp
80105ff7:	68 9e a8 10 80       	push   $0x8010a89e
80105ffc:	e8 65 a5 ff ff       	call   80100566 <panic>
    }
    // if list desn't exist yet, initialize
    if (!(*sList)) {
80106001:	8b 45 08             	mov    0x8(%ebp),%eax
80106004:	8b 00                	mov    (%eax),%eax
80106006:	85 c0                	test   %eax,%eax
80106008:	75 1c                	jne    80106026 <addToStateListEnd+0x3e>
        (*sList) = p;
8010600a:	8b 45 08             	mov    0x8(%ebp),%eax
8010600d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106010:	89 10                	mov    %edx,(%eax)
        p->next = 0;
80106012:	8b 45 0c             	mov    0xc(%ebp),%eax
80106015:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
8010601c:	00 00 00 
        return 0;
8010601f:	b8 00 00 00 00       	mov    $0x0,%eax
80106024:	eb 41                	jmp    80106067 <addToStateListEnd+0x7f>
    }
    // otherwise traverse and add at the end
    struct proc * current = (*sList);
80106026:	8b 45 08             	mov    0x8(%ebp),%eax
80106029:	8b 00                	mov    (%eax),%eax
8010602b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (current->next) {
8010602e:	eb 0c                	jmp    8010603c <addToStateListEnd+0x54>
        current = current->next;
80106030:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106033:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106039:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p->next = 0;
        return 0;
    }
    // otherwise traverse and add at the end
    struct proc * current = (*sList);
    while (current->next) {
8010603c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010603f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106045:	85 c0                	test   %eax,%eax
80106047:	75 e7                	jne    80106030 <addToStateListEnd+0x48>
        current = current->next;
    }
    current->next = p;
80106049:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010604c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010604f:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    p->next = 0;
80106055:	8b 45 0c             	mov    0xc(%ebp),%eax
80106058:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
8010605f:	00 00 00 
    return 0;
80106062:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106067:	c9                   	leave  
80106068:	c3                   	ret    

80106069 <removeFromStateList>:

// search and remove process based on pointer address
static int
removeFromStateList(struct proc** sList, struct proc* p) {
80106069:	55                   	push   %ebp
8010606a:	89 e5                	mov    %esp,%ebp
8010606c:	83 ec 18             	sub    $0x18,%esp
    if (!p) {
8010606f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106073:	75 0d                	jne    80106082 <removeFromStateList+0x19>
        panic("Invalid process structures.");
80106075:	83 ec 0c             	sub    $0xc,%esp
80106078:	68 af a8 10 80       	push   $0x8010a8af
8010607d:	e8 e4 a4 ff ff       	call   80100566 <panic>
    }
    if (!(*sList)) {
80106082:	8b 45 08             	mov    0x8(%ebp),%eax
80106085:	8b 00                	mov    (%eax),%eax
80106087:	85 c0                	test   %eax,%eax
80106089:	75 0a                	jne    80106095 <removeFromStateList+0x2c>
        return -1;
8010608b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106090:	e9 c6 00 00 00       	jmp    8010615b <removeFromStateList+0xf2>
    }
    // if p is the first element in list
    if (p == (*sList)) {
80106095:	8b 45 08             	mov    0x8(%ebp),%eax
80106098:	8b 00                	mov    (%eax),%eax
8010609a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010609d:	75 59                	jne    801060f8 <removeFromStateList+0x8f>
        // if it is the only item in list
        if (!(*sList)->next) {
8010609f:	8b 45 08             	mov    0x8(%ebp),%eax
801060a2:	8b 00                	mov    (%eax),%eax
801060a4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060aa:	85 c0                	test   %eax,%eax
801060ac:	75 20                	jne    801060ce <removeFromStateList+0x65>
            (*sList) = 0;
801060ae:	8b 45 08             	mov    0x8(%ebp),%eax
801060b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            p->next = 0;
801060b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801060ba:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801060c1:	00 00 00 
            return 0;
801060c4:	b8 00 00 00 00       	mov    $0x0,%eax
801060c9:	e9 8d 00 00 00       	jmp    8010615b <removeFromStateList+0xf2>
        }
        // if p is the first item in list
        else {
            struct proc * temp = (*sList)->next;
801060ce:	8b 45 08             	mov    0x8(%ebp),%eax
801060d1:	8b 00                	mov    (%eax),%eax
801060d3:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
            p->next = 0;
801060dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801060df:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801060e6:	00 00 00 
            (*sList) = temp;
801060e9:	8b 45 08             	mov    0x8(%ebp),%eax
801060ec:	8b 55 ec             	mov    -0x14(%ebp),%edx
801060ef:	89 10                	mov    %edx,(%eax)
            return 0;
801060f1:	b8 00 00 00 00       	mov    $0x0,%eax
801060f6:	eb 63                	jmp    8010615b <removeFromStateList+0xf2>
        }
    }
    // from middle or end of list
    else {
        struct proc * current = (*sList)->next;
801060f8:	8b 45 08             	mov    0x8(%ebp),%eax
801060fb:	8b 00                	mov    (%eax),%eax
801060fd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106103:	89 45 f4             	mov    %eax,-0xc(%ebp)
        struct proc * prev = (*sList);
80106106:	8b 45 08             	mov    0x8(%ebp),%eax
80106109:	8b 00                	mov    (%eax),%eax
8010610b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while (current) {
8010610e:	eb 40                	jmp    80106150 <removeFromStateList+0xe7>
            if (current == p) {
80106110:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106113:	3b 45 0c             	cmp    0xc(%ebp),%eax
80106116:	75 26                	jne    8010613e <removeFromStateList+0xd5>
                prev->next = current->next;
80106118:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010611b:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80106121:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106124:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
                p->next = 0;
8010612a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010612d:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106134:	00 00 00 
                return 0;
80106137:	b8 00 00 00 00       	mov    $0x0,%eax
8010613c:	eb 1d                	jmp    8010615b <removeFromStateList+0xf2>
            }
            prev = current;
8010613e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106141:	89 45 f0             	mov    %eax,-0x10(%ebp)
            current = current->next;
80106144:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106147:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010614d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    // from middle or end of list
    else {
        struct proc * current = (*sList)->next;
        struct proc * prev = (*sList);
        while (current) {
80106150:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106154:	75 ba                	jne    80106110 <removeFromStateList+0xa7>
            }
            prev = current;
            current = current->next;
        }
    }
    return -1; // nothing found
80106156:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010615b:	c9                   	leave  
8010615c:	c3                   	ret    

8010615d <removeHead>:

// remove first element of list, return its pointer
static struct proc*
removeHead(struct proc** sList) {
8010615d:	55                   	push   %ebp
8010615e:	89 e5                	mov    %esp,%ebp
80106160:	83 ec 10             	sub    $0x10,%esp
    if (!(*sList)) {
80106163:	8b 45 08             	mov    0x8(%ebp),%eax
80106166:	8b 00                	mov    (%eax),%eax
80106168:	85 c0                	test   %eax,%eax
8010616a:	75 07                	jne    80106173 <removeHead+0x16>
        return 0; // return null, check value in calling routine
8010616c:	b8 00 00 00 00       	mov    $0x0,%eax
80106171:	eb 2e                	jmp    801061a1 <removeHead+0x44>
    }
    struct proc* p = (*sList); // assign pointer to head of sList
80106173:	8b 45 08             	mov    0x8(%ebp),%eax
80106176:	8b 00                	mov    (%eax),%eax
80106178:	89 45 fc             	mov    %eax,-0x4(%ebp)
    struct proc* temp = (*sList)->next; // hold onto next element in list
8010617b:	8b 45 08             	mov    0x8(%ebp),%eax
8010617e:	8b 00                	mov    (%eax),%eax
80106180:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106186:	89 45 f8             	mov    %eax,-0x8(%ebp)
    p->next = 0; // p is no longer head of sList
80106189:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010618c:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106193:	00 00 00 
    (*sList) = temp; // sList now starts at  2nd element, or is NULL if one-item list
80106196:	8b 45 08             	mov    0x8(%ebp),%eax
80106199:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010619c:	89 10                	mov    %edx,(%eax)
    return p; // return 
8010619e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801061a1:	c9                   	leave  
801061a2:	c3                   	ret    

801061a3 <printReadyList>:

// print PIDs of all procs in Ready list
void
printReadyList(void) {
801061a3:	55                   	push   %ebp
801061a4:	89 e5                	mov    %esp,%ebp
801061a6:	83 ec 18             	sub    $0x18,%esp
    //int i = 0;
    cprintf("\nReady List Processes:\n");
801061a9:	83 ec 0c             	sub    $0xc,%esp
801061ac:	68 cb a8 10 80       	push   $0x8010a8cb
801061b1:	e8 10 a2 ff ff       	call   801003c6 <cprintf>
801061b6:	83 c4 10             	add    $0x10,%esp
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
801061b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801061c0:	e9 ca 00 00 00       	jmp    8010628f <printReadyList+0xec>
        if (ptable.pLists.ready[i]) {
801061c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061c8:	05 cc 09 00 00       	add    $0x9cc,%eax
801061cd:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
801061d4:	85 c0                	test   %eax,%eax
801061d6:	0f 84 9c 00 00 00    	je     80106278 <printReadyList+0xd5>
            cprintf("\n%d: ", i);
801061dc:	83 ec 08             	sub    $0x8,%esp
801061df:	ff 75 f4             	pushl  -0xc(%ebp)
801061e2:	68 e3 a8 10 80       	push   $0x8010a8e3
801061e7:	e8 da a1 ff ff       	call   801003c6 <cprintf>
801061ec:	83 c4 10             	add    $0x10,%esp
            struct proc* current = ptable.pLists.ready[i];
801061ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f2:	05 cc 09 00 00       	add    $0x9cc,%eax
801061f7:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
801061fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
            while (current) {
80106201:	eb 5d                	jmp    80106260 <printReadyList+0xbd>
                if (current->next) {
80106203:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106206:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010620c:	85 c0                	test   %eax,%eax
8010620e:	74 23                	je     80106233 <printReadyList+0x90>
                    cprintf("(%d, %d)-> ", current->pid, current->budget);
80106210:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106213:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80106219:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010621c:	8b 40 10             	mov    0x10(%eax),%eax
8010621f:	83 ec 04             	sub    $0x4,%esp
80106222:	52                   	push   %edx
80106223:	50                   	push   %eax
80106224:	68 e9 a8 10 80       	push   $0x8010a8e9
80106229:	e8 98 a1 ff ff       	call   801003c6 <cprintf>
8010622e:	83 c4 10             	add    $0x10,%esp
80106231:	eb 21                	jmp    80106254 <printReadyList+0xb1>
                } else {
                    cprintf("(%d, %d)", current->pid, current->budget);
80106233:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106236:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010623c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010623f:	8b 40 10             	mov    0x10(%eax),%eax
80106242:	83 ec 04             	sub    $0x4,%esp
80106245:	52                   	push   %edx
80106246:	50                   	push   %eax
80106247:	68 f5 a8 10 80       	push   $0x8010a8f5
8010624c:	e8 75 a1 ff ff       	call   801003c6 <cprintf>
80106251:	83 c4 10             	add    $0x10,%esp
                }
                current = current->next;
80106254:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106257:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010625d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
        if (ptable.pLists.ready[i]) {
            cprintf("\n%d: ", i);
            struct proc* current = ptable.pLists.ready[i];
            while (current) {
80106260:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106264:	75 9d                	jne    80106203 <printReadyList+0x60>
                } else {
                    cprintf("(%d, %d)", current->pid, current->budget);
                }
                current = current->next;
            }
            cprintf("\n");
80106266:	83 ec 0c             	sub    $0xc,%esp
80106269:	68 4d a8 10 80       	push   $0x8010a84d
8010626e:	e8 53 a1 ff ff       	call   801003c6 <cprintf>
80106273:	83 c4 10             	add    $0x10,%esp
80106276:	eb 13                	jmp    8010628b <printReadyList+0xe8>
        }
        else {
            cprintf("\n%d: Empty.\n", i);
80106278:	83 ec 08             	sub    $0x8,%esp
8010627b:	ff 75 f4             	pushl  -0xc(%ebp)
8010627e:	68 fe a8 10 80       	push   $0x8010a8fe
80106283:	e8 3e a1 ff ff       	call   801003c6 <cprintf>
80106288:	83 c4 10             	add    $0x10,%esp
void
printReadyList(void) {
    //int i = 0;
    cprintf("\nReady List Processes:\n");
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
8010628b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010628f:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
80106293:	0f 8e 2c ff ff ff    	jle    801061c5 <printReadyList+0x22>
        else {
            cprintf("\n%d: Empty.\n", i);
        }
        //++i;
    }
}
80106299:	90                   	nop
8010629a:	c9                   	leave  
8010629b:	c3                   	ret    

8010629c <printFreeList>:

// print number of procs in Free list
void
printFreeList(void) {
8010629c:	55                   	push   %ebp
8010629d:	89 e5                	mov    %esp,%ebp
8010629f:	83 ec 18             	sub    $0x18,%esp
    if (ptable.pLists.free) {
801062a2:	a1 c0 70 11 80       	mov    0x801170c0,%eax
801062a7:	85 c0                	test   %eax,%eax
801062a9:	74 3c                	je     801062e7 <printFreeList+0x4b>
        int size = 0;
801062ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        struct proc * current = ptable.pLists.free;
801062b2:	a1 c0 70 11 80       	mov    0x801170c0,%eax
801062b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while (current) {
801062ba:	eb 10                	jmp    801062cc <printFreeList+0x30>
            ++size; // cycle list and keep count
801062bc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            current = current->next;
801062c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062c3:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801062c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
void
printFreeList(void) {
    if (ptable.pLists.free) {
        int size = 0;
        struct proc * current = ptable.pLists.free;
        while (current) {
801062cc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062d0:	75 ea                	jne    801062bc <printFreeList+0x20>
        /*
        for (struct proc* current = ptable.pLists.free; current; current = current->next) {
            ++size;
        }
        */
        cprintf("\nFree List Size: %d processes\n", size);
801062d2:	83 ec 08             	sub    $0x8,%esp
801062d5:	ff 75 f4             	pushl  -0xc(%ebp)
801062d8:	68 0c a9 10 80       	push   $0x8010a90c
801062dd:	e8 e4 a0 ff ff       	call   801003c6 <cprintf>
801062e2:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Free List.\n");
    }
}
801062e5:	eb 10                	jmp    801062f7 <printFreeList+0x5b>
        }
        */
        cprintf("\nFree List Size: %d processes\n", size);
    }
    else {
        cprintf("\nNo processes on Free List.\n");
801062e7:	83 ec 0c             	sub    $0xc,%esp
801062ea:	68 2b a9 10 80       	push   $0x8010a92b
801062ef:	e8 d2 a0 ff ff       	call   801003c6 <cprintf>
801062f4:	83 c4 10             	add    $0x10,%esp
    }
}
801062f7:	90                   	nop
801062f8:	c9                   	leave  
801062f9:	c3                   	ret    

801062fa <printSleepList>:

// print PIDs of all procs in Sleep list
void
printSleepList(void) {
801062fa:	55                   	push   %ebp
801062fb:	89 e5                	mov    %esp,%ebp
801062fd:	83 ec 18             	sub    $0x18,%esp
    //acquire(&ptable.lock);
    if (ptable.pLists.sleep) {
80106300:	a1 c4 70 11 80       	mov    0x801170c4,%eax
80106305:	85 c0                	test   %eax,%eax
80106307:	74 7b                	je     80106384 <printSleepList+0x8a>
        struct proc* current = ptable.pLists.sleep;
80106309:	a1 c4 70 11 80       	mov    0x801170c4,%eax
8010630e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("\nSleep List Processes:\n");
80106311:	83 ec 0c             	sub    $0xc,%esp
80106314:	68 48 a9 10 80       	push   $0x8010a948
80106319:	e8 a8 a0 ff ff       	call   801003c6 <cprintf>
8010631e:	83 c4 10             	add    $0x10,%esp
        while (current) {
80106321:	eb 49                	jmp    8010636c <printSleepList+0x72>
            if (current->next) {
80106323:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106326:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010632c:	85 c0                	test   %eax,%eax
8010632e:	74 19                	je     80106349 <printSleepList+0x4f>
                cprintf("%d -> ", current->pid);
80106330:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106333:	8b 40 10             	mov    0x10(%eax),%eax
80106336:	83 ec 08             	sub    $0x8,%esp
80106339:	50                   	push   %eax
8010633a:	68 60 a9 10 80       	push   $0x8010a960
8010633f:	e8 82 a0 ff ff       	call   801003c6 <cprintf>
80106344:	83 c4 10             	add    $0x10,%esp
80106347:	eb 17                	jmp    80106360 <printSleepList+0x66>
            } else {
                cprintf("%d", current->pid);
80106349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010634c:	8b 40 10             	mov    0x10(%eax),%eax
8010634f:	83 ec 08             	sub    $0x8,%esp
80106352:	50                   	push   %eax
80106353:	68 67 a9 10 80       	push   $0x8010a967
80106358:	e8 69 a0 ff ff       	call   801003c6 <cprintf>
8010635d:	83 c4 10             	add    $0x10,%esp
            }
            current = current->next;
80106360:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106363:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106369:	89 45 f4             	mov    %eax,-0xc(%ebp)
printSleepList(void) {
    //acquire(&ptable.lock);
    if (ptable.pLists.sleep) {
        struct proc* current = ptable.pLists.sleep;
        cprintf("\nSleep List Processes:\n");
        while (current) {
8010636c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106370:	75 b1                	jne    80106323 <printSleepList+0x29>
            } else {
                cprintf("%d", current->pid);
            }
            current = current->next;
        }
        cprintf("\n");
80106372:	83 ec 0c             	sub    $0xc,%esp
80106375:	68 4d a8 10 80       	push   $0x8010a84d
8010637a:	e8 47 a0 ff ff       	call   801003c6 <cprintf>
8010637f:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Sleep List.\n");
    }
    //release(&ptable.lock);
}
80106382:	eb 10                	jmp    80106394 <printSleepList+0x9a>
            current = current->next;
        }
        cprintf("\n");
    }
    else {
        cprintf("\nNo processes on Sleep List.\n");
80106384:	83 ec 0c             	sub    $0xc,%esp
80106387:	68 6a a9 10 80       	push   $0x8010a96a
8010638c:	e8 35 a0 ff ff       	call   801003c6 <cprintf>
80106391:	83 c4 10             	add    $0x10,%esp
    }
    //release(&ptable.lock);
}
80106394:	90                   	nop
80106395:	c9                   	leave  
80106396:	c3                   	ret    

80106397 <printZombieList>:

// print PIDs & PPIDs of all procs in Zombie list
void
printZombieList(void) {
80106397:	55                   	push   %ebp
80106398:	89 e5                	mov    %esp,%ebp
8010639a:	83 ec 18             	sub    $0x18,%esp
    if (ptable.pLists.zombie) {
8010639d:	a1 c8 70 11 80       	mov    0x801170c8,%eax
801063a2:	85 c0                	test   %eax,%eax
801063a4:	0f 84 8f 00 00 00    	je     80106439 <printZombieList+0xa2>
        struct proc* current = ptable.pLists.zombie;
801063aa:	a1 c8 70 11 80       	mov    0x801170c8,%eax
801063af:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("\nZombie List Processes:\n");
801063b2:	83 ec 0c             	sub    $0xc,%esp
801063b5:	68 88 a9 10 80       	push   $0x8010a988
801063ba:	e8 07 a0 ff ff       	call   801003c6 <cprintf>
801063bf:	83 c4 10             	add    $0x10,%esp
        while (current) {
801063c2:	eb 5d                	jmp    80106421 <printZombieList+0x8a>
            if (current->next) {
801063c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801063cd:	85 c0                	test   %eax,%eax
801063cf:	74 23                	je     801063f4 <printZombieList+0x5d>
                cprintf("(%d, %d) -> ", current->pid, current->parent->pid);
801063d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d4:	8b 40 14             	mov    0x14(%eax),%eax
801063d7:	8b 50 10             	mov    0x10(%eax),%edx
801063da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063dd:	8b 40 10             	mov    0x10(%eax),%eax
801063e0:	83 ec 04             	sub    $0x4,%esp
801063e3:	52                   	push   %edx
801063e4:	50                   	push   %eax
801063e5:	68 a1 a9 10 80       	push   $0x8010a9a1
801063ea:	e8 d7 9f ff ff       	call   801003c6 <cprintf>
801063ef:	83 c4 10             	add    $0x10,%esp
801063f2:	eb 21                	jmp    80106415 <printZombieList+0x7e>
            } else {
                cprintf("(%d, %d)", current->pid, current->parent->pid);
801063f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063f7:	8b 40 14             	mov    0x14(%eax),%eax
801063fa:	8b 50 10             	mov    0x10(%eax),%edx
801063fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106400:	8b 40 10             	mov    0x10(%eax),%eax
80106403:	83 ec 04             	sub    $0x4,%esp
80106406:	52                   	push   %edx
80106407:	50                   	push   %eax
80106408:	68 f5 a8 10 80       	push   $0x8010a8f5
8010640d:	e8 b4 9f ff ff       	call   801003c6 <cprintf>
80106412:	83 c4 10             	add    $0x10,%esp
            }
            current = current->next;
80106415:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106418:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010641e:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
printZombieList(void) {
    if (ptable.pLists.zombie) {
        struct proc* current = ptable.pLists.zombie;
        cprintf("\nZombie List Processes:\n");
        while (current) {
80106421:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106425:	75 9d                	jne    801063c4 <printZombieList+0x2d>
            } else {
                cprintf("(%d, %d)", current->pid, current->parent->pid);
            }
            current = current->next;
        }
        cprintf("\n");
80106427:	83 ec 0c             	sub    $0xc,%esp
8010642a:	68 4d a8 10 80       	push   $0x8010a84d
8010642f:	e8 92 9f ff ff       	call   801003c6 <cprintf>
80106434:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Zombie List.\n");
    }
}
80106437:	eb 10                	jmp    80106449 <printZombieList+0xb2>
            current = current->next;
        }
        cprintf("\n");
    }
    else {
        cprintf("\nNo processes on Zombie List.\n");
80106439:	83 ec 0c             	sub    $0xc,%esp
8010643c:	68 b0 a9 10 80       	push   $0x8010a9b0
80106441:	e8 80 9f ff ff       	call   801003c6 <cprintf>
80106446:	83 c4 10             	add    $0x10,%esp
    }
}
80106449:	90                   	nop
8010644a:	c9                   	leave  
8010644b:	c3                   	ret    

8010644c <promoteAll>:
// upwards to lowest priority queue

// Promote all ACTIVE(RUNNING, RUNNABLE, SLEEPING) processes one priority level
// this is only called in scheduler(), which holds &ptable.lock
static void
promoteAll(void) {
8010644c:	55                   	push   %ebp
8010644d:	89 e5                	mov    %esp,%ebp
8010644f:	83 ec 18             	sub    $0x18,%esp
    struct proc* p; // main ptr
    struct proc* current; // 2nd ptr needed for traversal + list management
    for (int i = 1; i <= MAX; ++i) {
80106452:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
80106459:	e9 ff 00 00 00       	jmp    8010655d <promoteAll+0x111>
        // traverse ready list array
        if (ptable.pLists.ready[i]) {
8010645e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106461:	05 cc 09 00 00       	add    $0x9cc,%eax
80106466:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
8010646d:	85 c0                	test   %eax,%eax
8010646f:	0f 84 e4 00 00 00    	je     80106559 <promoteAll+0x10d>
            current = ptable.pLists.ready[i]; // initialize
80106475:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106478:	05 cc 09 00 00       	add    $0x9cc,%eax
8010647d:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80106484:	89 45 f0             	mov    %eax,-0x10(%ebp)
            p = 0;
80106487:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            while (current) {
8010648e:	e9 bc 00 00 00       	jmp    8010654f <promoteAll+0x103>
                p = current; // p is the current process to adjust
80106493:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106496:	89 45 f4             	mov    %eax,-0xc(%ebp)
                current = current->next; // current traverses one ahead
80106499:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010649c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801064a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
                assertState(p, RUNNABLE); // assert state, we need to swap ready lists
801064a5:	83 ec 08             	sub    $0x8,%esp
801064a8:	6a 03                	push   $0x3
801064aa:	ff 75 f4             	pushl  -0xc(%ebp)
801064ad:	e8 96 fa ff ff       	call   80105f48 <assertState>
801064b2:	83 c4 10             	add    $0x10,%esp
                if (removeFromStateList(&ptable.pLists.ready[p->priority], p) < 0) {
801064b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064b8:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801064be:	05 cc 09 00 00       	add    $0x9cc,%eax
801064c3:	c1 e0 02             	shl    $0x2,%eax
801064c6:	05 80 49 11 80       	add    $0x80114980,%eax
801064cb:	83 c0 04             	add    $0x4,%eax
801064ce:	83 ec 08             	sub    $0x8,%esp
801064d1:	ff 75 f4             	pushl  -0xc(%ebp)
801064d4:	50                   	push   %eax
801064d5:	e8 8f fb ff ff       	call   80106069 <removeFromStateList>
801064da:	83 c4 10             	add    $0x10,%esp
801064dd:	85 c0                	test   %eax,%eax
801064df:	79 10                	jns    801064f1 <promoteAll+0xa5>
                    cprintf("promoteAll: Could not remove from ready list.\n");
801064e1:	83 ec 0c             	sub    $0xc,%esp
801064e4:	68 d0 a9 10 80       	push   $0x8010a9d0
801064e9:	e8 d8 9e ff ff       	call   801003c6 <cprintf>
801064ee:	83 c4 10             	add    $0x10,%esp
                } // take off lower priority (whatever one it is)
                if (p->priority > 0) {
801064f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064f4:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801064fa:	85 c0                	test   %eax,%eax
801064fc:	74 15                	je     80106513 <promoteAll+0xc7>
                    --(p->priority); // adjust upward (toward zero)
801064fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106501:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106507:	8d 50 ff             	lea    -0x1(%eax),%edx
8010650a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010650d:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
                } // add to higher priority list
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
80106513:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106516:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010651c:	05 cc 09 00 00       	add    $0x9cc,%eax
80106521:	c1 e0 02             	shl    $0x2,%eax
80106524:	05 80 49 11 80       	add    $0x80114980,%eax
80106529:	83 c0 04             	add    $0x4,%eax
8010652c:	83 ec 08             	sub    $0x8,%esp
8010652f:	ff 75 f4             	pushl  -0xc(%ebp)
80106532:	50                   	push   %eax
80106533:	e8 b0 fa ff ff       	call   80105fe8 <addToStateListEnd>
80106538:	83 c4 10             	add    $0x10,%esp
8010653b:	85 c0                	test   %eax,%eax
8010653d:	79 10                	jns    8010654f <promoteAll+0x103>
                    cprintf("promoteAll: Could not add to ready list.\n");
8010653f:	83 ec 0c             	sub    $0xc,%esp
80106542:	68 00 aa 10 80       	push   $0x8010aa00
80106547:	e8 7a 9e ff ff       	call   801003c6 <cprintf>
8010654c:	83 c4 10             	add    $0x10,%esp
    for (int i = 1; i <= MAX; ++i) {
        // traverse ready list array
        if (ptable.pLists.ready[i]) {
            current = ptable.pLists.ready[i]; // initialize
            p = 0;
            while (current) {
8010654f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106553:	0f 85 3a ff ff ff    	jne    80106493 <promoteAll+0x47>
// this is only called in scheduler(), which holds &ptable.lock
static void
promoteAll(void) {
    struct proc* p; // main ptr
    struct proc* current; // 2nd ptr needed for traversal + list management
    for (int i = 1; i <= MAX; ++i) {
80106559:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
8010655d:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
80106561:	0f 8e f7 fe ff ff    	jle    8010645e <promoteAll+0x12>
                }
            }
        }
    }
    // promote all SLEEPING processes
    if (ptable.pLists.sleep) {
80106567:	a1 c4 70 11 80       	mov    0x801170c4,%eax
8010656c:	85 c0                	test   %eax,%eax
8010656e:	74 3e                	je     801065ae <promoteAll+0x162>
        p = ptable.pLists.sleep;
80106570:	a1 c4 70 11 80       	mov    0x801170c4,%eax
80106575:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
80106578:	eb 2e                	jmp    801065a8 <promoteAll+0x15c>
            if (p->priority > 0) {
8010657a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010657d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106583:	85 c0                	test   %eax,%eax
80106585:	74 15                	je     8010659c <promoteAll+0x150>
                --(p->priority); // promote process
80106587:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010658a:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106590:	8d 50 ff             	lea    -0x1(%eax),%edx
80106593:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106596:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            }
            p = p->next;
8010659c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010659f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801065a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
    }
    // promote all SLEEPING processes
    if (ptable.pLists.sleep) {
        p = ptable.pLists.sleep;
        while (p) {
801065a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065ac:	75 cc                	jne    8010657a <promoteAll+0x12e>
            }
            p = p->next;
        }
    }
    // promote all RUNNING processes
    if (ptable.pLists.running) {
801065ae:	a1 cc 70 11 80       	mov    0x801170cc,%eax
801065b3:	85 c0                	test   %eax,%eax
801065b5:	74 3e                	je     801065f5 <promoteAll+0x1a9>
        p = ptable.pLists.running;
801065b7:	a1 cc 70 11 80       	mov    0x801170cc,%eax
801065bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
801065bf:	eb 2e                	jmp    801065ef <promoteAll+0x1a3>
            if (p->priority > 0) {
801065c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065c4:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801065ca:	85 c0                	test   %eax,%eax
801065cc:	74 15                	je     801065e3 <promoteAll+0x197>
                --(p->priority); // promote process
801065ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065d1:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801065d7:	8d 50 ff             	lea    -0x1(%eax),%edx
801065da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065dd:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            }
            p = p->next;
801065e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801065ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
    }
    // promote all RUNNING processes
    if (ptable.pLists.running) {
        p = ptable.pLists.running;
        while (p) {
801065ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065f3:	75 cc                	jne    801065c1 <promoteAll+0x175>
            }
            p = p->next;
        }
    }
    // nothing to return, just promote anything if they are there
}
801065f5:	90                   	nop
801065f6:	c9                   	leave  
801065f7:	c3                   	ret    

801065f8 <setpriority>:
// set priority system call
// bounds enforced in sysproc.c (kernel-side)
// active processes: RUNNABLE, RUNNING, SLEEPING
int
setpriority(int pid, int priority) {
801065f8:	55                   	push   %ebp
801065f9:	89 e5                	mov    %esp,%ebp
801065fb:	83 ec 18             	sub    $0x18,%esp
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
801065fe:	83 ec 0c             	sub    $0xc,%esp
80106601:	68 80 49 11 80       	push   $0x80114980
80106606:	e8 40 02 00 00       	call   8010684b <acquire>
8010660b:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i <= MAX; ++i) {
8010660e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80106615:	e9 01 01 00 00       	jmp    8010671b <setpriority+0x123>
        p = ptable.pLists.ready[i]; // traverse ready list array
8010661a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010661d:	05 cc 09 00 00       	add    $0x9cc,%eax
80106622:	8b 04 85 84 49 11 80 	mov    -0x7feeb67c(,%eax,4),%eax
80106629:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
8010662c:	e9 dc 00 00 00       	jmp    8010670d <setpriority+0x115>
            // match PIDs and only if the new priority value changes anything
            if (p->pid == pid) {
80106631:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106634:	8b 50 10             	mov    0x10(%eax),%edx
80106637:	8b 45 08             	mov    0x8(%ebp),%eax
8010663a:	39 c2                	cmp    %eax,%edx
8010663c:	0f 85 bf 00 00 00    	jne    80106701 <setpriority+0x109>
                if (removeFromStateList(&ptable.pLists.ready[p->priority], p) < 0) {
80106642:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106645:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010664b:	05 cc 09 00 00       	add    $0x9cc,%eax
80106650:	c1 e0 02             	shl    $0x2,%eax
80106653:	05 80 49 11 80       	add    $0x80114980,%eax
80106658:	83 c0 04             	add    $0x4,%eax
8010665b:	83 ec 08             	sub    $0x8,%esp
8010665e:	ff 75 f4             	pushl  -0xc(%ebp)
80106661:	50                   	push   %eax
80106662:	e8 02 fa ff ff       	call   80106069 <removeFromStateList>
80106667:	83 c4 10             	add    $0x10,%esp
8010666a:	85 c0                	test   %eax,%eax
8010666c:	79 1a                	jns    80106688 <setpriority+0x90>
                    cprintf("setpriority: remove from ready list[%d] failed.\n", p->priority);
8010666e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106671:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106677:	83 ec 08             	sub    $0x8,%esp
8010667a:	50                   	push   %eax
8010667b:	68 2c aa 10 80       	push   $0x8010aa2c
80106680:	e8 41 9d ff ff       	call   801003c6 <cprintf>
80106685:	83 c4 10             	add    $0x10,%esp
                }// remove from old ready list
                p->priority = priority; // set priority
80106688:	8b 55 0c             	mov    0xc(%ebp),%edx
8010668b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010668e:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
80106694:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106697:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010669d:	05 cc 09 00 00       	add    $0x9cc,%eax
801066a2:	c1 e0 02             	shl    $0x2,%eax
801066a5:	05 80 49 11 80       	add    $0x80114980,%eax
801066aa:	83 c0 04             	add    $0x4,%eax
801066ad:	83 ec 08             	sub    $0x8,%esp
801066b0:	ff 75 f4             	pushl  -0xc(%ebp)
801066b3:	50                   	push   %eax
801066b4:	e8 2f f9 ff ff       	call   80105fe8 <addToStateListEnd>
801066b9:	83 c4 10             	add    $0x10,%esp
801066bc:	85 c0                	test   %eax,%eax
801066be:	79 1a                	jns    801066da <setpriority+0xe2>
                    cprintf("setpriority: add to ready list[%d] failed.\n", p->priority);
801066c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c3:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801066c9:	83 ec 08             	sub    $0x8,%esp
801066cc:	50                   	push   %eax
801066cd:	68 60 aa 10 80       	push   $0x8010aa60
801066d2:	e8 ef 9c ff ff       	call   801003c6 <cprintf>
801066d7:	83 c4 10             	add    $0x10,%esp
                } //  add to new ready list
                p->budget = BUDGET; // reset budget
801066da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066dd:	c7 80 98 00 00 00 64 	movl   $0x64,0x98(%eax)
801066e4:	00 00 00 
                //cprintf("setPriority: ready list priority set.\n");
                release(&ptable.lock); // release lock
801066e7:	83 ec 0c             	sub    $0xc,%esp
801066ea:	68 80 49 11 80       	push   $0x80114980
801066ef:	e8 be 01 00 00       	call   801068b2 <release>
801066f4:	83 c4 10             	add    $0x10,%esp
                return 0; // return success
801066f7:	b8 00 00 00 00       	mov    $0x0,%eax
801066fc:	e9 ee 00 00 00       	jmp    801067ef <setpriority+0x1f7>
            }
            p = p->next;
80106701:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106704:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010670a:	89 45 f4             	mov    %eax,-0xc(%ebp)
setpriority(int pid, int priority) {
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i]; // traverse ready list array
        while (p) {
8010670d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106711:	0f 85 1a ff ff ff    	jne    80106631 <setpriority+0x39>
// active processes: RUNNABLE, RUNNING, SLEEPING
int
setpriority(int pid, int priority) {
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
    for (int i = 0; i <= MAX; ++i) {
80106717:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010671b:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
8010671f:	0f 8e f5 fe ff ff    	jle    8010661a <setpriority+0x22>
                return 0; // return success
            }
            p = p->next;
        }
    }
    p = ptable.pLists.running; // repeat process if PID not found in ready lists
80106725:	a1 cc 70 11 80       	mov    0x801170cc,%eax
8010672a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
8010672d:	eb 4c                	jmp    8010677b <setpriority+0x183>
        if (p->pid == pid) {
8010672f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106732:	8b 50 10             	mov    0x10(%eax),%edx
80106735:	8b 45 08             	mov    0x8(%ebp),%eax
80106738:	39 c2                	cmp    %eax,%edx
8010673a:	75 33                	jne    8010676f <setpriority+0x177>
            p->priority = priority;
8010673c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010673f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106742:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            p->budget = BUDGET;
80106748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010674b:	c7 80 98 00 00 00 64 	movl   $0x64,0x98(%eax)
80106752:	00 00 00 
            //cprintf("setPriority: running list priority set.\n");
            release(&ptable.lock);
80106755:	83 ec 0c             	sub    $0xc,%esp
80106758:	68 80 49 11 80       	push   $0x80114980
8010675d:	e8 50 01 00 00       	call   801068b2 <release>
80106762:	83 c4 10             	add    $0x10,%esp
            return 0; // return success
80106765:	b8 00 00 00 00       	mov    $0x0,%eax
8010676a:	e9 80 00 00 00       	jmp    801067ef <setpriority+0x1f7>
        }
        p = p->next;
8010676f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106772:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106778:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
    }
    p = ptable.pLists.running; // repeat process if PID not found in ready lists
    while (p) {
8010677b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010677f:	75 ae                	jne    8010672f <setpriority+0x137>
            release(&ptable.lock);
            return 0; // return success
        }
        p = p->next;
    }
    p = ptable.pLists.sleep; // continue search in sleep list
80106781:	a1 c4 70 11 80       	mov    0x801170c4,%eax
80106786:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80106789:	eb 49                	jmp    801067d4 <setpriority+0x1dc>
        if (p->pid == pid) {
8010678b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010678e:	8b 50 10             	mov    0x10(%eax),%edx
80106791:	8b 45 08             	mov    0x8(%ebp),%eax
80106794:	39 c2                	cmp    %eax,%edx
80106796:	75 30                	jne    801067c8 <setpriority+0x1d0>
            p->priority = priority;
80106798:	8b 55 0c             	mov    0xc(%ebp),%edx
8010679b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010679e:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            p->budget = BUDGET;
801067a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a7:	c7 80 98 00 00 00 64 	movl   $0x64,0x98(%eax)
801067ae:	00 00 00 
            //cprintf("setPriority: sleep list priority set.\n");
            release(&ptable.lock);
801067b1:	83 ec 0c             	sub    $0xc,%esp
801067b4:	68 80 49 11 80       	push   $0x80114980
801067b9:	e8 f4 00 00 00       	call   801068b2 <release>
801067be:	83 c4 10             	add    $0x10,%esp
            return 0; //  return success
801067c1:	b8 00 00 00 00       	mov    $0x0,%eax
801067c6:	eb 27                	jmp    801067ef <setpriority+0x1f7>
        }
        p = p->next;
801067c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067cb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801067d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            return 0; // return success
        }
        p = p->next;
    }
    p = ptable.pLists.sleep; // continue search in sleep list
    while (p) {
801067d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801067d8:	75 b1                	jne    8010678b <setpriority+0x193>
            return 0; //  return success
        }
        p = p->next;
    }
    //cprintf("setPriority: No priority set.\n");
    release(&ptable.lock);
801067da:	83 ec 0c             	sub    $0xc,%esp
801067dd:	68 80 49 11 80       	push   $0x80114980
801067e2:	e8 cb 00 00 00       	call   801068b2 <release>
801067e7:	83 c4 10             	add    $0x10,%esp
    return -1; // return error if no PID match is found
801067ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801067ef:	c9                   	leave  
801067f0:	c3                   	ret    

801067f1 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801067f1:	55                   	push   %ebp
801067f2:	89 e5                	mov    %esp,%ebp
801067f4:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801067f7:	9c                   	pushf  
801067f8:	58                   	pop    %eax
801067f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801067fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801067ff:	c9                   	leave  
80106800:	c3                   	ret    

80106801 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80106801:	55                   	push   %ebp
80106802:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80106804:	fa                   	cli    
}
80106805:	90                   	nop
80106806:	5d                   	pop    %ebp
80106807:	c3                   	ret    

80106808 <sti>:

static inline void
sti(void)
{
80106808:	55                   	push   %ebp
80106809:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010680b:	fb                   	sti    
}
8010680c:	90                   	nop
8010680d:	5d                   	pop    %ebp
8010680e:	c3                   	ret    

8010680f <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010680f:	55                   	push   %ebp
80106810:	89 e5                	mov    %esp,%ebp
80106812:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80106815:	8b 55 08             	mov    0x8(%ebp),%edx
80106818:	8b 45 0c             	mov    0xc(%ebp),%eax
8010681b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010681e:	f0 87 02             	lock xchg %eax,(%edx)
80106821:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80106824:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106827:	c9                   	leave  
80106828:	c3                   	ret    

80106829 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106829:	55                   	push   %ebp
8010682a:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010682c:	8b 45 08             	mov    0x8(%ebp),%eax
8010682f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106832:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80106835:	8b 45 08             	mov    0x8(%ebp),%eax
80106838:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010683e:	8b 45 08             	mov    0x8(%ebp),%eax
80106841:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106848:	90                   	nop
80106849:	5d                   	pop    %ebp
8010684a:	c3                   	ret    

8010684b <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010684b:	55                   	push   %ebp
8010684c:	89 e5                	mov    %esp,%ebp
8010684e:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106851:	e8 52 01 00 00       	call   801069a8 <pushcli>
  if(holding(lk))
80106856:	8b 45 08             	mov    0x8(%ebp),%eax
80106859:	83 ec 0c             	sub    $0xc,%esp
8010685c:	50                   	push   %eax
8010685d:	e8 1c 01 00 00       	call   8010697e <holding>
80106862:	83 c4 10             	add    $0x10,%esp
80106865:	85 c0                	test   %eax,%eax
80106867:	74 0d                	je     80106876 <acquire+0x2b>
    panic("acquire");
80106869:	83 ec 0c             	sub    $0xc,%esp
8010686c:	68 8c aa 10 80       	push   $0x8010aa8c
80106871:	e8 f0 9c ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80106876:	90                   	nop
80106877:	8b 45 08             	mov    0x8(%ebp),%eax
8010687a:	83 ec 08             	sub    $0x8,%esp
8010687d:	6a 01                	push   $0x1
8010687f:	50                   	push   %eax
80106880:	e8 8a ff ff ff       	call   8010680f <xchg>
80106885:	83 c4 10             	add    $0x10,%esp
80106888:	85 c0                	test   %eax,%eax
8010688a:	75 eb                	jne    80106877 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010688c:	8b 45 08             	mov    0x8(%ebp),%eax
8010688f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106896:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80106899:	8b 45 08             	mov    0x8(%ebp),%eax
8010689c:	83 c0 0c             	add    $0xc,%eax
8010689f:	83 ec 08             	sub    $0x8,%esp
801068a2:	50                   	push   %eax
801068a3:	8d 45 08             	lea    0x8(%ebp),%eax
801068a6:	50                   	push   %eax
801068a7:	e8 58 00 00 00       	call   80106904 <getcallerpcs>
801068ac:	83 c4 10             	add    $0x10,%esp
}
801068af:	90                   	nop
801068b0:	c9                   	leave  
801068b1:	c3                   	ret    

801068b2 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801068b2:	55                   	push   %ebp
801068b3:	89 e5                	mov    %esp,%ebp
801068b5:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801068b8:	83 ec 0c             	sub    $0xc,%esp
801068bb:	ff 75 08             	pushl  0x8(%ebp)
801068be:	e8 bb 00 00 00       	call   8010697e <holding>
801068c3:	83 c4 10             	add    $0x10,%esp
801068c6:	85 c0                	test   %eax,%eax
801068c8:	75 0d                	jne    801068d7 <release+0x25>
    panic("release");
801068ca:	83 ec 0c             	sub    $0xc,%esp
801068cd:	68 94 aa 10 80       	push   $0x8010aa94
801068d2:	e8 8f 9c ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801068d7:	8b 45 08             	mov    0x8(%ebp),%eax
801068da:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801068e1:	8b 45 08             	mov    0x8(%ebp),%eax
801068e4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801068eb:	8b 45 08             	mov    0x8(%ebp),%eax
801068ee:	83 ec 08             	sub    $0x8,%esp
801068f1:	6a 00                	push   $0x0
801068f3:	50                   	push   %eax
801068f4:	e8 16 ff ff ff       	call   8010680f <xchg>
801068f9:	83 c4 10             	add    $0x10,%esp

  popcli();
801068fc:	e8 ec 00 00 00       	call   801069ed <popcli>
}
80106901:	90                   	nop
80106902:	c9                   	leave  
80106903:	c3                   	ret    

80106904 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106904:	55                   	push   %ebp
80106905:	89 e5                	mov    %esp,%ebp
80106907:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010690a:	8b 45 08             	mov    0x8(%ebp),%eax
8010690d:	83 e8 08             	sub    $0x8,%eax
80106910:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80106913:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010691a:	eb 38                	jmp    80106954 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010691c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106920:	74 53                	je     80106975 <getcallerpcs+0x71>
80106922:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80106929:	76 4a                	jbe    80106975 <getcallerpcs+0x71>
8010692b:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010692f:	74 44                	je     80106975 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80106931:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106934:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010693b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010693e:	01 c2                	add    %eax,%edx
80106940:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106943:	8b 40 04             	mov    0x4(%eax),%eax
80106946:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80106948:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010694b:	8b 00                	mov    (%eax),%eax
8010694d:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106950:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106954:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106958:	7e c2                	jle    8010691c <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010695a:	eb 19                	jmp    80106975 <getcallerpcs+0x71>
    pcs[i] = 0;
8010695c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010695f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106966:	8b 45 0c             	mov    0xc(%ebp),%eax
80106969:	01 d0                	add    %edx,%eax
8010696b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106971:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106975:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106979:	7e e1                	jle    8010695c <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010697b:	90                   	nop
8010697c:	c9                   	leave  
8010697d:	c3                   	ret    

8010697e <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010697e:	55                   	push   %ebp
8010697f:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106981:	8b 45 08             	mov    0x8(%ebp),%eax
80106984:	8b 00                	mov    (%eax),%eax
80106986:	85 c0                	test   %eax,%eax
80106988:	74 17                	je     801069a1 <holding+0x23>
8010698a:	8b 45 08             	mov    0x8(%ebp),%eax
8010698d:	8b 50 08             	mov    0x8(%eax),%edx
80106990:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106996:	39 c2                	cmp    %eax,%edx
80106998:	75 07                	jne    801069a1 <holding+0x23>
8010699a:	b8 01 00 00 00       	mov    $0x1,%eax
8010699f:	eb 05                	jmp    801069a6 <holding+0x28>
801069a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069a6:	5d                   	pop    %ebp
801069a7:	c3                   	ret    

801069a8 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801069a8:	55                   	push   %ebp
801069a9:	89 e5                	mov    %esp,%ebp
801069ab:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801069ae:	e8 3e fe ff ff       	call   801067f1 <readeflags>
801069b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801069b6:	e8 46 fe ff ff       	call   80106801 <cli>
  if(cpu->ncli++ == 0)
801069bb:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801069c2:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801069c8:	8d 48 01             	lea    0x1(%eax),%ecx
801069cb:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801069d1:	85 c0                	test   %eax,%eax
801069d3:	75 15                	jne    801069ea <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801069d5:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069db:	8b 55 fc             	mov    -0x4(%ebp),%edx
801069de:	81 e2 00 02 00 00    	and    $0x200,%edx
801069e4:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801069ea:	90                   	nop
801069eb:	c9                   	leave  
801069ec:	c3                   	ret    

801069ed <popcli>:

void
popcli(void)
{
801069ed:	55                   	push   %ebp
801069ee:	89 e5                	mov    %esp,%ebp
801069f0:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801069f3:	e8 f9 fd ff ff       	call   801067f1 <readeflags>
801069f8:	25 00 02 00 00       	and    $0x200,%eax
801069fd:	85 c0                	test   %eax,%eax
801069ff:	74 0d                	je     80106a0e <popcli+0x21>
    panic("popcli - interruptible");
80106a01:	83 ec 0c             	sub    $0xc,%esp
80106a04:	68 9c aa 10 80       	push   $0x8010aa9c
80106a09:	e8 58 9b ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106a0e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a14:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106a1a:	83 ea 01             	sub    $0x1,%edx
80106a1d:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106a23:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106a29:	85 c0                	test   %eax,%eax
80106a2b:	79 0d                	jns    80106a3a <popcli+0x4d>
    panic("popcli");
80106a2d:	83 ec 0c             	sub    $0xc,%esp
80106a30:	68 b3 aa 10 80       	push   $0x8010aab3
80106a35:	e8 2c 9b ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106a3a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a40:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106a46:	85 c0                	test   %eax,%eax
80106a48:	75 15                	jne    80106a5f <popcli+0x72>
80106a4a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a50:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106a56:	85 c0                	test   %eax,%eax
80106a58:	74 05                	je     80106a5f <popcli+0x72>
    sti();
80106a5a:	e8 a9 fd ff ff       	call   80106808 <sti>
}
80106a5f:	90                   	nop
80106a60:	c9                   	leave  
80106a61:	c3                   	ret    

80106a62 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106a62:	55                   	push   %ebp
80106a63:	89 e5                	mov    %esp,%ebp
80106a65:	57                   	push   %edi
80106a66:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106a67:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106a6a:	8b 55 10             	mov    0x10(%ebp),%edx
80106a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a70:	89 cb                	mov    %ecx,%ebx
80106a72:	89 df                	mov    %ebx,%edi
80106a74:	89 d1                	mov    %edx,%ecx
80106a76:	fc                   	cld    
80106a77:	f3 aa                	rep stos %al,%es:(%edi)
80106a79:	89 ca                	mov    %ecx,%edx
80106a7b:	89 fb                	mov    %edi,%ebx
80106a7d:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106a80:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106a83:	90                   	nop
80106a84:	5b                   	pop    %ebx
80106a85:	5f                   	pop    %edi
80106a86:	5d                   	pop    %ebp
80106a87:	c3                   	ret    

80106a88 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106a88:	55                   	push   %ebp
80106a89:	89 e5                	mov    %esp,%ebp
80106a8b:	57                   	push   %edi
80106a8c:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106a8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106a90:	8b 55 10             	mov    0x10(%ebp),%edx
80106a93:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a96:	89 cb                	mov    %ecx,%ebx
80106a98:	89 df                	mov    %ebx,%edi
80106a9a:	89 d1                	mov    %edx,%ecx
80106a9c:	fc                   	cld    
80106a9d:	f3 ab                	rep stos %eax,%es:(%edi)
80106a9f:	89 ca                	mov    %ecx,%edx
80106aa1:	89 fb                	mov    %edi,%ebx
80106aa3:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106aa6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106aa9:	90                   	nop
80106aaa:	5b                   	pop    %ebx
80106aab:	5f                   	pop    %edi
80106aac:	5d                   	pop    %ebp
80106aad:	c3                   	ret    

80106aae <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106aae:	55                   	push   %ebp
80106aaf:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab4:	83 e0 03             	and    $0x3,%eax
80106ab7:	85 c0                	test   %eax,%eax
80106ab9:	75 43                	jne    80106afe <memset+0x50>
80106abb:	8b 45 10             	mov    0x10(%ebp),%eax
80106abe:	83 e0 03             	and    $0x3,%eax
80106ac1:	85 c0                	test   %eax,%eax
80106ac3:	75 39                	jne    80106afe <memset+0x50>
    c &= 0xFF;
80106ac5:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106acc:	8b 45 10             	mov    0x10(%ebp),%eax
80106acf:	c1 e8 02             	shr    $0x2,%eax
80106ad2:	89 c1                	mov    %eax,%ecx
80106ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ad7:	c1 e0 18             	shl    $0x18,%eax
80106ada:	89 c2                	mov    %eax,%edx
80106adc:	8b 45 0c             	mov    0xc(%ebp),%eax
80106adf:	c1 e0 10             	shl    $0x10,%eax
80106ae2:	09 c2                	or     %eax,%edx
80106ae4:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ae7:	c1 e0 08             	shl    $0x8,%eax
80106aea:	09 d0                	or     %edx,%eax
80106aec:	0b 45 0c             	or     0xc(%ebp),%eax
80106aef:	51                   	push   %ecx
80106af0:	50                   	push   %eax
80106af1:	ff 75 08             	pushl  0x8(%ebp)
80106af4:	e8 8f ff ff ff       	call   80106a88 <stosl>
80106af9:	83 c4 0c             	add    $0xc,%esp
80106afc:	eb 12                	jmp    80106b10 <memset+0x62>
  } else
    stosb(dst, c, n);
80106afe:	8b 45 10             	mov    0x10(%ebp),%eax
80106b01:	50                   	push   %eax
80106b02:	ff 75 0c             	pushl  0xc(%ebp)
80106b05:	ff 75 08             	pushl  0x8(%ebp)
80106b08:	e8 55 ff ff ff       	call   80106a62 <stosb>
80106b0d:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106b10:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106b13:	c9                   	leave  
80106b14:	c3                   	ret    

80106b15 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106b15:	55                   	push   %ebp
80106b16:	89 e5                	mov    %esp,%ebp
80106b18:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106b21:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b24:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106b27:	eb 30                	jmp    80106b59 <memcmp+0x44>
    if(*s1 != *s2)
80106b29:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b2c:	0f b6 10             	movzbl (%eax),%edx
80106b2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106b32:	0f b6 00             	movzbl (%eax),%eax
80106b35:	38 c2                	cmp    %al,%dl
80106b37:	74 18                	je     80106b51 <memcmp+0x3c>
      return *s1 - *s2;
80106b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b3c:	0f b6 00             	movzbl (%eax),%eax
80106b3f:	0f b6 d0             	movzbl %al,%edx
80106b42:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106b45:	0f b6 00             	movzbl (%eax),%eax
80106b48:	0f b6 c0             	movzbl %al,%eax
80106b4b:	29 c2                	sub    %eax,%edx
80106b4d:	89 d0                	mov    %edx,%eax
80106b4f:	eb 1a                	jmp    80106b6b <memcmp+0x56>
    s1++, s2++;
80106b51:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106b55:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106b59:	8b 45 10             	mov    0x10(%ebp),%eax
80106b5c:	8d 50 ff             	lea    -0x1(%eax),%edx
80106b5f:	89 55 10             	mov    %edx,0x10(%ebp)
80106b62:	85 c0                	test   %eax,%eax
80106b64:	75 c3                	jne    80106b29 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106b66:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106b6b:	c9                   	leave  
80106b6c:	c3                   	ret    

80106b6d <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106b6d:	55                   	push   %ebp
80106b6e:	89 e5                	mov    %esp,%ebp
80106b70:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106b73:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b76:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106b79:	8b 45 08             	mov    0x8(%ebp),%eax
80106b7c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106b7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b82:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106b85:	73 54                	jae    80106bdb <memmove+0x6e>
80106b87:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106b8a:	8b 45 10             	mov    0x10(%ebp),%eax
80106b8d:	01 d0                	add    %edx,%eax
80106b8f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106b92:	76 47                	jbe    80106bdb <memmove+0x6e>
    s += n;
80106b94:	8b 45 10             	mov    0x10(%ebp),%eax
80106b97:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106b9a:	8b 45 10             	mov    0x10(%ebp),%eax
80106b9d:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106ba0:	eb 13                	jmp    80106bb5 <memmove+0x48>
      *--d = *--s;
80106ba2:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106ba6:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106baa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bad:	0f b6 10             	movzbl (%eax),%edx
80106bb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bb3:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106bb5:	8b 45 10             	mov    0x10(%ebp),%eax
80106bb8:	8d 50 ff             	lea    -0x1(%eax),%edx
80106bbb:	89 55 10             	mov    %edx,0x10(%ebp)
80106bbe:	85 c0                	test   %eax,%eax
80106bc0:	75 e0                	jne    80106ba2 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106bc2:	eb 24                	jmp    80106be8 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106bc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bc7:	8d 50 01             	lea    0x1(%eax),%edx
80106bca:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106bcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106bd0:	8d 4a 01             	lea    0x1(%edx),%ecx
80106bd3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80106bd6:	0f b6 12             	movzbl (%edx),%edx
80106bd9:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106bdb:	8b 45 10             	mov    0x10(%ebp),%eax
80106bde:	8d 50 ff             	lea    -0x1(%eax),%edx
80106be1:	89 55 10             	mov    %edx,0x10(%ebp)
80106be4:	85 c0                	test   %eax,%eax
80106be6:	75 dc                	jne    80106bc4 <memmove+0x57>
      *d++ = *s++;

  return dst;
80106be8:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106beb:	c9                   	leave  
80106bec:	c3                   	ret    

80106bed <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106bed:	55                   	push   %ebp
80106bee:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106bf0:	ff 75 10             	pushl  0x10(%ebp)
80106bf3:	ff 75 0c             	pushl  0xc(%ebp)
80106bf6:	ff 75 08             	pushl  0x8(%ebp)
80106bf9:	e8 6f ff ff ff       	call   80106b6d <memmove>
80106bfe:	83 c4 0c             	add    $0xc,%esp
}
80106c01:	c9                   	leave  
80106c02:	c3                   	ret    

80106c03 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106c03:	55                   	push   %ebp
80106c04:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80106c06:	eb 0c                	jmp    80106c14 <strncmp+0x11>
    n--, p++, q++;
80106c08:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106c0c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106c10:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106c14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c18:	74 1a                	je     80106c34 <strncmp+0x31>
80106c1a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c1d:	0f b6 00             	movzbl (%eax),%eax
80106c20:	84 c0                	test   %al,%al
80106c22:	74 10                	je     80106c34 <strncmp+0x31>
80106c24:	8b 45 08             	mov    0x8(%ebp),%eax
80106c27:	0f b6 10             	movzbl (%eax),%edx
80106c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c2d:	0f b6 00             	movzbl (%eax),%eax
80106c30:	38 c2                	cmp    %al,%dl
80106c32:	74 d4                	je     80106c08 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106c34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c38:	75 07                	jne    80106c41 <strncmp+0x3e>
    return 0;
80106c3a:	b8 00 00 00 00       	mov    $0x0,%eax
80106c3f:	eb 16                	jmp    80106c57 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106c41:	8b 45 08             	mov    0x8(%ebp),%eax
80106c44:	0f b6 00             	movzbl (%eax),%eax
80106c47:	0f b6 d0             	movzbl %al,%edx
80106c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c4d:	0f b6 00             	movzbl (%eax),%eax
80106c50:	0f b6 c0             	movzbl %al,%eax
80106c53:	29 c2                	sub    %eax,%edx
80106c55:	89 d0                	mov    %edx,%eax
}
80106c57:	5d                   	pop    %ebp
80106c58:	c3                   	ret    

80106c59 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106c59:	55                   	push   %ebp
80106c5a:	89 e5                	mov    %esp,%ebp
80106c5c:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106c5f:	8b 45 08             	mov    0x8(%ebp),%eax
80106c62:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106c65:	90                   	nop
80106c66:	8b 45 10             	mov    0x10(%ebp),%eax
80106c69:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c6c:	89 55 10             	mov    %edx,0x10(%ebp)
80106c6f:	85 c0                	test   %eax,%eax
80106c71:	7e 2c                	jle    80106c9f <strncpy+0x46>
80106c73:	8b 45 08             	mov    0x8(%ebp),%eax
80106c76:	8d 50 01             	lea    0x1(%eax),%edx
80106c79:	89 55 08             	mov    %edx,0x8(%ebp)
80106c7c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c7f:	8d 4a 01             	lea    0x1(%edx),%ecx
80106c82:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106c85:	0f b6 12             	movzbl (%edx),%edx
80106c88:	88 10                	mov    %dl,(%eax)
80106c8a:	0f b6 00             	movzbl (%eax),%eax
80106c8d:	84 c0                	test   %al,%al
80106c8f:	75 d5                	jne    80106c66 <strncpy+0xd>
    ;
  while(n-- > 0)
80106c91:	eb 0c                	jmp    80106c9f <strncpy+0x46>
    *s++ = 0;
80106c93:	8b 45 08             	mov    0x8(%ebp),%eax
80106c96:	8d 50 01             	lea    0x1(%eax),%edx
80106c99:	89 55 08             	mov    %edx,0x8(%ebp)
80106c9c:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106c9f:	8b 45 10             	mov    0x10(%ebp),%eax
80106ca2:	8d 50 ff             	lea    -0x1(%eax),%edx
80106ca5:	89 55 10             	mov    %edx,0x10(%ebp)
80106ca8:	85 c0                	test   %eax,%eax
80106caa:	7f e7                	jg     80106c93 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106caf:	c9                   	leave  
80106cb0:	c3                   	ret    

80106cb1 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106cb1:	55                   	push   %ebp
80106cb2:	89 e5                	mov    %esp,%ebp
80106cb4:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80106cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106cbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106cc1:	7f 05                	jg     80106cc8 <safestrcpy+0x17>
    return os;
80106cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106cc6:	eb 31                	jmp    80106cf9 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106cc8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106ccc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106cd0:	7e 1e                	jle    80106cf0 <safestrcpy+0x3f>
80106cd2:	8b 45 08             	mov    0x8(%ebp),%eax
80106cd5:	8d 50 01             	lea    0x1(%eax),%edx
80106cd8:	89 55 08             	mov    %edx,0x8(%ebp)
80106cdb:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cde:	8d 4a 01             	lea    0x1(%edx),%ecx
80106ce1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106ce4:	0f b6 12             	movzbl (%edx),%edx
80106ce7:	88 10                	mov    %dl,(%eax)
80106ce9:	0f b6 00             	movzbl (%eax),%eax
80106cec:	84 c0                	test   %al,%al
80106cee:	75 d8                	jne    80106cc8 <safestrcpy+0x17>
    ;
  *s = 0;
80106cf0:	8b 45 08             	mov    0x8(%ebp),%eax
80106cf3:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80106cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106cf9:	c9                   	leave  
80106cfa:	c3                   	ret    

80106cfb <strlen>:

int
strlen(const char *s)
{
80106cfb:	55                   	push   %ebp
80106cfc:	89 e5                	mov    %esp,%ebp
80106cfe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106d01:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106d08:	eb 04                	jmp    80106d0e <strlen+0x13>
80106d0a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106d0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106d11:	8b 45 08             	mov    0x8(%ebp),%eax
80106d14:	01 d0                	add    %edx,%eax
80106d16:	0f b6 00             	movzbl (%eax),%eax
80106d19:	84 c0                	test   %al,%al
80106d1b:	75 ed                	jne    80106d0a <strlen+0xf>
    ;
  return n;
80106d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d20:	c9                   	leave  
80106d21:	c3                   	ret    

80106d22 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106d22:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106d26:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106d2a:	55                   	push   %ebp
  pushl %ebx
80106d2b:	53                   	push   %ebx
  pushl %esi
80106d2c:	56                   	push   %esi
  pushl %edi
80106d2d:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106d2e:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106d30:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106d32:	5f                   	pop    %edi
  popl %esi
80106d33:	5e                   	pop    %esi
  popl %ebx
80106d34:	5b                   	pop    %ebx
  popl %ebp
80106d35:	5d                   	pop    %ebp
  ret
80106d36:	c3                   	ret    

80106d37 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106d37:	55                   	push   %ebp
80106d38:	89 e5                	mov    %esp,%ebp
    if(addr >= proc->sz || addr+4 > proc->sz)
80106d3a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d40:	8b 00                	mov    (%eax),%eax
80106d42:	3b 45 08             	cmp    0x8(%ebp),%eax
80106d45:	76 12                	jbe    80106d59 <fetchint+0x22>
80106d47:	8b 45 08             	mov    0x8(%ebp),%eax
80106d4a:	8d 50 04             	lea    0x4(%eax),%edx
80106d4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d53:	8b 00                	mov    (%eax),%eax
80106d55:	39 c2                	cmp    %eax,%edx
80106d57:	76 07                	jbe    80106d60 <fetchint+0x29>
        return -1;
80106d59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d5e:	eb 0f                	jmp    80106d6f <fetchint+0x38>
    *ip = *(int*)(addr);
80106d60:	8b 45 08             	mov    0x8(%ebp),%eax
80106d63:	8b 10                	mov    (%eax),%edx
80106d65:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d68:	89 10                	mov    %edx,(%eax)
    return 0;
80106d6a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106d6f:	5d                   	pop    %ebp
80106d70:	c3                   	ret    

80106d71 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106d71:	55                   	push   %ebp
80106d72:	89 e5                	mov    %esp,%ebp
80106d74:	83 ec 10             	sub    $0x10,%esp
    char *s, *ep;

    if(addr >= proc->sz)
80106d77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d7d:	8b 00                	mov    (%eax),%eax
80106d7f:	3b 45 08             	cmp    0x8(%ebp),%eax
80106d82:	77 07                	ja     80106d8b <fetchstr+0x1a>
        return -1;
80106d84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d89:	eb 46                	jmp    80106dd1 <fetchstr+0x60>
    *pp = (char*)addr;
80106d8b:	8b 55 08             	mov    0x8(%ebp),%edx
80106d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d91:	89 10                	mov    %edx,(%eax)
    ep = (char*)proc->sz;
80106d93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d99:	8b 00                	mov    (%eax),%eax
80106d9b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    for(s = *pp; s < ep; s++)
80106d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106da1:	8b 00                	mov    (%eax),%eax
80106da3:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106da6:	eb 1c                	jmp    80106dc4 <fetchstr+0x53>
        if(*s == 0)
80106da8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106dab:	0f b6 00             	movzbl (%eax),%eax
80106dae:	84 c0                	test   %al,%al
80106db0:	75 0e                	jne    80106dc0 <fetchstr+0x4f>
            return s - *pp;
80106db2:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106db5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106db8:	8b 00                	mov    (%eax),%eax
80106dba:	29 c2                	sub    %eax,%edx
80106dbc:	89 d0                	mov    %edx,%eax
80106dbe:	eb 11                	jmp    80106dd1 <fetchstr+0x60>

    if(addr >= proc->sz)
        return -1;
    *pp = (char*)addr;
    ep = (char*)proc->sz;
    for(s = *pp; s < ep; s++)
80106dc0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106dc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106dc7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106dca:	72 dc                	jb     80106da8 <fetchstr+0x37>
        if(*s == 0)
            return s - *pp;
    return -1;
80106dcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106dd1:	c9                   	leave  
80106dd2:	c3                   	ret    

80106dd3 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106dd3:	55                   	push   %ebp
80106dd4:	89 e5                	mov    %esp,%ebp
    return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106dd6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ddc:	8b 40 18             	mov    0x18(%eax),%eax
80106ddf:	8b 40 44             	mov    0x44(%eax),%eax
80106de2:	8b 55 08             	mov    0x8(%ebp),%edx
80106de5:	c1 e2 02             	shl    $0x2,%edx
80106de8:	01 d0                	add    %edx,%eax
80106dea:	83 c0 04             	add    $0x4,%eax
80106ded:	ff 75 0c             	pushl  0xc(%ebp)
80106df0:	50                   	push   %eax
80106df1:	e8 41 ff ff ff       	call   80106d37 <fetchint>
80106df6:	83 c4 08             	add    $0x8,%esp
}
80106df9:	c9                   	leave  
80106dfa:	c3                   	ret    

80106dfb <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106dfb:	55                   	push   %ebp
80106dfc:	89 e5                	mov    %esp,%ebp
80106dfe:	83 ec 10             	sub    $0x10,%esp
    int i;

    if(argint(n, &i) < 0)
80106e01:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106e04:	50                   	push   %eax
80106e05:	ff 75 08             	pushl  0x8(%ebp)
80106e08:	e8 c6 ff ff ff       	call   80106dd3 <argint>
80106e0d:	83 c4 08             	add    $0x8,%esp
80106e10:	85 c0                	test   %eax,%eax
80106e12:	79 07                	jns    80106e1b <argptr+0x20>
        return -1;
80106e14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e19:	eb 3b                	jmp    80106e56 <argptr+0x5b>
    if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106e1b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e21:	8b 00                	mov    (%eax),%eax
80106e23:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e26:	39 d0                	cmp    %edx,%eax
80106e28:	76 16                	jbe    80106e40 <argptr+0x45>
80106e2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e2d:	89 c2                	mov    %eax,%edx
80106e2f:	8b 45 10             	mov    0x10(%ebp),%eax
80106e32:	01 c2                	add    %eax,%edx
80106e34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e3a:	8b 00                	mov    (%eax),%eax
80106e3c:	39 c2                	cmp    %eax,%edx
80106e3e:	76 07                	jbe    80106e47 <argptr+0x4c>
        return -1;
80106e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e45:	eb 0f                	jmp    80106e56 <argptr+0x5b>
    *pp = (char*)i;
80106e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e4a:	89 c2                	mov    %eax,%edx
80106e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e4f:	89 10                	mov    %edx,(%eax)
    return 0;
80106e51:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e56:	c9                   	leave  
80106e57:	c3                   	ret    

80106e58 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106e58:	55                   	push   %ebp
80106e59:	89 e5                	mov    %esp,%ebp
80106e5b:	83 ec 10             	sub    $0x10,%esp
    int addr;
    if(argint(n, &addr) < 0)
80106e5e:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106e61:	50                   	push   %eax
80106e62:	ff 75 08             	pushl  0x8(%ebp)
80106e65:	e8 69 ff ff ff       	call   80106dd3 <argint>
80106e6a:	83 c4 08             	add    $0x8,%esp
80106e6d:	85 c0                	test   %eax,%eax
80106e6f:	79 07                	jns    80106e78 <argstr+0x20>
        return -1;
80106e71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e76:	eb 0f                	jmp    80106e87 <argstr+0x2f>
    return fetchstr(addr, pp);
80106e78:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e7b:	ff 75 0c             	pushl  0xc(%ebp)
80106e7e:	50                   	push   %eax
80106e7f:	e8 ed fe ff ff       	call   80106d71 <fetchstr>
80106e84:	83 c4 08             	add    $0x8,%esp
}
80106e87:	c9                   	leave  
80106e88:	c3                   	ret    

80106e89 <syscall>:
};
#endif

void
syscall(void)
{
80106e89:	55                   	push   %ebp
80106e8a:	89 e5                	mov    %esp,%ebp
80106e8c:	53                   	push   %ebx
80106e8d:	83 ec 14             	sub    $0x14,%esp
    int num;

    num = proc->tf->eax;
80106e90:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e96:	8b 40 18             	mov    0x18(%eax),%eax
80106e99:	8b 40 1c             	mov    0x1c(%eax),%eax
80106e9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106e9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ea3:	7e 30                	jle    80106ed5 <syscall+0x4c>
80106ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ea8:	83 f8 1e             	cmp    $0x1e,%eax
80106eab:	77 28                	ja     80106ed5 <syscall+0x4c>
80106ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eb0:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106eb7:	85 c0                	test   %eax,%eax
80106eb9:	74 1a                	je     80106ed5 <syscall+0x4c>
        proc->tf->eax = syscalls[num]();
80106ebb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ec1:	8b 58 18             	mov    0x18(%eax),%ebx
80106ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ec7:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106ece:	ff d0                	call   *%eax
80106ed0:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106ed3:	eb 34                	jmp    80106f09 <syscall+0x80>
#ifdef PRINT_SYSCALLS
        cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif
    } else {
        cprintf("%d %s: unknown sys call %d\n",
                proc->pid, proc->name, num);
80106ed5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106edb:	8d 50 6c             	lea    0x6c(%eax),%edx
80106ede:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
        // some code goes here
#ifdef PRINT_SYSCALLS
        cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif
    } else {
        cprintf("%d %s: unknown sys call %d\n",
80106ee4:	8b 40 10             	mov    0x10(%eax),%eax
80106ee7:	ff 75 f4             	pushl  -0xc(%ebp)
80106eea:	52                   	push   %edx
80106eeb:	50                   	push   %eax
80106eec:	68 ba aa 10 80       	push   $0x8010aaba
80106ef1:	e8 d0 94 ff ff       	call   801003c6 <cprintf>
80106ef6:	83 c4 10             	add    $0x10,%esp
                proc->pid, proc->name, num);
        proc->tf->eax = -1;
80106ef9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106eff:	8b 40 18             	mov    0x18(%eax),%eax
80106f02:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
    }
}
80106f09:	90                   	nop
80106f0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106f0d:	c9                   	leave  
80106f0e:	c3                   	ret    

80106f0f <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106f0f:	55                   	push   %ebp
80106f10:	89 e5                	mov    %esp,%ebp
80106f12:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106f15:	83 ec 08             	sub    $0x8,%esp
80106f18:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f1b:	50                   	push   %eax
80106f1c:	ff 75 08             	pushl  0x8(%ebp)
80106f1f:	e8 af fe ff ff       	call   80106dd3 <argint>
80106f24:	83 c4 10             	add    $0x10,%esp
80106f27:	85 c0                	test   %eax,%eax
80106f29:	79 07                	jns    80106f32 <argfd+0x23>
    return -1;
80106f2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f30:	eb 50                	jmp    80106f82 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f35:	85 c0                	test   %eax,%eax
80106f37:	78 21                	js     80106f5a <argfd+0x4b>
80106f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f3c:	83 f8 0f             	cmp    $0xf,%eax
80106f3f:	7f 19                	jg     80106f5a <argfd+0x4b>
80106f41:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f47:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106f4a:	83 c2 08             	add    $0x8,%edx
80106f4d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106f51:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106f54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106f58:	75 07                	jne    80106f61 <argfd+0x52>
    return -1;
80106f5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f5f:	eb 21                	jmp    80106f82 <argfd+0x73>
  if(pfd)
80106f61:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106f65:	74 08                	je     80106f6f <argfd+0x60>
    *pfd = fd;
80106f67:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f6d:	89 10                	mov    %edx,(%eax)
  if(pf)
80106f6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106f73:	74 08                	je     80106f7d <argfd+0x6e>
    *pf = f;
80106f75:	8b 45 10             	mov    0x10(%ebp),%eax
80106f78:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106f7b:	89 10                	mov    %edx,(%eax)
  return 0;
80106f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106f82:	c9                   	leave  
80106f83:	c3                   	ret    

80106f84 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106f84:	55                   	push   %ebp
80106f85:	89 e5                	mov    %esp,%ebp
80106f87:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106f8a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106f91:	eb 30                	jmp    80106fc3 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106f93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f99:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106f9c:	83 c2 08             	add    $0x8,%edx
80106f9f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106fa3:	85 c0                	test   %eax,%eax
80106fa5:	75 18                	jne    80106fbf <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106fa7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fad:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106fb0:	8d 4a 08             	lea    0x8(%edx),%ecx
80106fb3:	8b 55 08             	mov    0x8(%ebp),%edx
80106fb6:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106fba:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106fbd:	eb 0f                	jmp    80106fce <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106fbf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106fc3:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80106fc7:	7e ca                	jle    80106f93 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80106fc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fce:	c9                   	leave  
80106fcf:	c3                   	ret    

80106fd0 <sys_dup>:

int
sys_dup(void)
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80106fd6:	83 ec 04             	sub    $0x4,%esp
80106fd9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106fdc:	50                   	push   %eax
80106fdd:	6a 00                	push   $0x0
80106fdf:	6a 00                	push   $0x0
80106fe1:	e8 29 ff ff ff       	call   80106f0f <argfd>
80106fe6:	83 c4 10             	add    $0x10,%esp
80106fe9:	85 c0                	test   %eax,%eax
80106feb:	79 07                	jns    80106ff4 <sys_dup+0x24>
    return -1;
80106fed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ff2:	eb 31                	jmp    80107025 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80106ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106ff7:	83 ec 0c             	sub    $0xc,%esp
80106ffa:	50                   	push   %eax
80106ffb:	e8 84 ff ff ff       	call   80106f84 <fdalloc>
80107000:	83 c4 10             	add    $0x10,%esp
80107003:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107006:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010700a:	79 07                	jns    80107013 <sys_dup+0x43>
    return -1;
8010700c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107011:	eb 12                	jmp    80107025 <sys_dup+0x55>
  filedup(f);
80107013:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107016:	83 ec 0c             	sub    $0xc,%esp
80107019:	50                   	push   %eax
8010701a:	e8 92 a0 ff ff       	call   801010b1 <filedup>
8010701f:	83 c4 10             	add    $0x10,%esp
  return fd;
80107022:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107025:	c9                   	leave  
80107026:	c3                   	ret    

80107027 <sys_read>:

int
sys_read(void)
{
80107027:	55                   	push   %ebp
80107028:	89 e5                	mov    %esp,%ebp
8010702a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010702d:	83 ec 04             	sub    $0x4,%esp
80107030:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107033:	50                   	push   %eax
80107034:	6a 00                	push   $0x0
80107036:	6a 00                	push   $0x0
80107038:	e8 d2 fe ff ff       	call   80106f0f <argfd>
8010703d:	83 c4 10             	add    $0x10,%esp
80107040:	85 c0                	test   %eax,%eax
80107042:	78 2e                	js     80107072 <sys_read+0x4b>
80107044:	83 ec 08             	sub    $0x8,%esp
80107047:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010704a:	50                   	push   %eax
8010704b:	6a 02                	push   $0x2
8010704d:	e8 81 fd ff ff       	call   80106dd3 <argint>
80107052:	83 c4 10             	add    $0x10,%esp
80107055:	85 c0                	test   %eax,%eax
80107057:	78 19                	js     80107072 <sys_read+0x4b>
80107059:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010705c:	83 ec 04             	sub    $0x4,%esp
8010705f:	50                   	push   %eax
80107060:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107063:	50                   	push   %eax
80107064:	6a 01                	push   $0x1
80107066:	e8 90 fd ff ff       	call   80106dfb <argptr>
8010706b:	83 c4 10             	add    $0x10,%esp
8010706e:	85 c0                	test   %eax,%eax
80107070:	79 07                	jns    80107079 <sys_read+0x52>
    return -1;
80107072:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107077:	eb 17                	jmp    80107090 <sys_read+0x69>
  return fileread(f, p, n);
80107079:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010707c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010707f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107082:	83 ec 04             	sub    $0x4,%esp
80107085:	51                   	push   %ecx
80107086:	52                   	push   %edx
80107087:	50                   	push   %eax
80107088:	e8 b4 a1 ff ff       	call   80101241 <fileread>
8010708d:	83 c4 10             	add    $0x10,%esp
}
80107090:	c9                   	leave  
80107091:	c3                   	ret    

80107092 <sys_write>:

int
sys_write(void)
{
80107092:	55                   	push   %ebp
80107093:	89 e5                	mov    %esp,%ebp
80107095:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80107098:	83 ec 04             	sub    $0x4,%esp
8010709b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010709e:	50                   	push   %eax
8010709f:	6a 00                	push   $0x0
801070a1:	6a 00                	push   $0x0
801070a3:	e8 67 fe ff ff       	call   80106f0f <argfd>
801070a8:	83 c4 10             	add    $0x10,%esp
801070ab:	85 c0                	test   %eax,%eax
801070ad:	78 2e                	js     801070dd <sys_write+0x4b>
801070af:	83 ec 08             	sub    $0x8,%esp
801070b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070b5:	50                   	push   %eax
801070b6:	6a 02                	push   $0x2
801070b8:	e8 16 fd ff ff       	call   80106dd3 <argint>
801070bd:	83 c4 10             	add    $0x10,%esp
801070c0:	85 c0                	test   %eax,%eax
801070c2:	78 19                	js     801070dd <sys_write+0x4b>
801070c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070c7:	83 ec 04             	sub    $0x4,%esp
801070ca:	50                   	push   %eax
801070cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801070ce:	50                   	push   %eax
801070cf:	6a 01                	push   $0x1
801070d1:	e8 25 fd ff ff       	call   80106dfb <argptr>
801070d6:	83 c4 10             	add    $0x10,%esp
801070d9:	85 c0                	test   %eax,%eax
801070db:	79 07                	jns    801070e4 <sys_write+0x52>
    return -1;
801070dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070e2:	eb 17                	jmp    801070fb <sys_write+0x69>
  return filewrite(f, p, n);
801070e4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801070e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801070ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070ed:	83 ec 04             	sub    $0x4,%esp
801070f0:	51                   	push   %ecx
801070f1:	52                   	push   %edx
801070f2:	50                   	push   %eax
801070f3:	e8 01 a2 ff ff       	call   801012f9 <filewrite>
801070f8:	83 c4 10             	add    $0x10,%esp
}
801070fb:	c9                   	leave  
801070fc:	c3                   	ret    

801070fd <sys_close>:

int
sys_close(void)
{
801070fd:	55                   	push   %ebp
801070fe:	89 e5                	mov    %esp,%ebp
80107100:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80107103:	83 ec 04             	sub    $0x4,%esp
80107106:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107109:	50                   	push   %eax
8010710a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010710d:	50                   	push   %eax
8010710e:	6a 00                	push   $0x0
80107110:	e8 fa fd ff ff       	call   80106f0f <argfd>
80107115:	83 c4 10             	add    $0x10,%esp
80107118:	85 c0                	test   %eax,%eax
8010711a:	79 07                	jns    80107123 <sys_close+0x26>
    return -1;
8010711c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107121:	eb 28                	jmp    8010714b <sys_close+0x4e>
  proc->ofile[fd] = 0;
80107123:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107129:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010712c:	83 c2 08             	add    $0x8,%edx
8010712f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107136:	00 
  fileclose(f);
80107137:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010713a:	83 ec 0c             	sub    $0xc,%esp
8010713d:	50                   	push   %eax
8010713e:	e8 bf 9f ff ff       	call   80101102 <fileclose>
80107143:	83 c4 10             	add    $0x10,%esp
  return 0;
80107146:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010714b:	c9                   	leave  
8010714c:	c3                   	ret    

8010714d <sys_fstat>:

int
sys_fstat(void)
{
8010714d:	55                   	push   %ebp
8010714e:	89 e5                	mov    %esp,%ebp
80107150:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80107153:	83 ec 04             	sub    $0x4,%esp
80107156:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107159:	50                   	push   %eax
8010715a:	6a 00                	push   $0x0
8010715c:	6a 00                	push   $0x0
8010715e:	e8 ac fd ff ff       	call   80106f0f <argfd>
80107163:	83 c4 10             	add    $0x10,%esp
80107166:	85 c0                	test   %eax,%eax
80107168:	78 17                	js     80107181 <sys_fstat+0x34>
8010716a:	83 ec 04             	sub    $0x4,%esp
8010716d:	6a 14                	push   $0x14
8010716f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107172:	50                   	push   %eax
80107173:	6a 01                	push   $0x1
80107175:	e8 81 fc ff ff       	call   80106dfb <argptr>
8010717a:	83 c4 10             	add    $0x10,%esp
8010717d:	85 c0                	test   %eax,%eax
8010717f:	79 07                	jns    80107188 <sys_fstat+0x3b>
    return -1;
80107181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107186:	eb 13                	jmp    8010719b <sys_fstat+0x4e>
  return filestat(f, st);
80107188:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010718b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010718e:	83 ec 08             	sub    $0x8,%esp
80107191:	52                   	push   %edx
80107192:	50                   	push   %eax
80107193:	e8 52 a0 ff ff       	call   801011ea <filestat>
80107198:	83 c4 10             	add    $0x10,%esp
}
8010719b:	c9                   	leave  
8010719c:	c3                   	ret    

8010719d <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010719d:	55                   	push   %ebp
8010719e:	89 e5                	mov    %esp,%ebp
801071a0:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801071a3:	83 ec 08             	sub    $0x8,%esp
801071a6:	8d 45 d8             	lea    -0x28(%ebp),%eax
801071a9:	50                   	push   %eax
801071aa:	6a 00                	push   $0x0
801071ac:	e8 a7 fc ff ff       	call   80106e58 <argstr>
801071b1:	83 c4 10             	add    $0x10,%esp
801071b4:	85 c0                	test   %eax,%eax
801071b6:	78 15                	js     801071cd <sys_link+0x30>
801071b8:	83 ec 08             	sub    $0x8,%esp
801071bb:	8d 45 dc             	lea    -0x24(%ebp),%eax
801071be:	50                   	push   %eax
801071bf:	6a 01                	push   $0x1
801071c1:	e8 92 fc ff ff       	call   80106e58 <argstr>
801071c6:	83 c4 10             	add    $0x10,%esp
801071c9:	85 c0                	test   %eax,%eax
801071cb:	79 0a                	jns    801071d7 <sys_link+0x3a>
    return -1;
801071cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071d2:	e9 68 01 00 00       	jmp    8010733f <sys_link+0x1a2>

  begin_op();
801071d7:	e8 22 c4 ff ff       	call   801035fe <begin_op>
  if((ip = namei(old)) == 0){
801071dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
801071df:	83 ec 0c             	sub    $0xc,%esp
801071e2:	50                   	push   %eax
801071e3:	e8 f1 b3 ff ff       	call   801025d9 <namei>
801071e8:	83 c4 10             	add    $0x10,%esp
801071eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801071ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801071f2:	75 0f                	jne    80107203 <sys_link+0x66>
    end_op();
801071f4:	e8 91 c4 ff ff       	call   8010368a <end_op>
    return -1;
801071f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071fe:	e9 3c 01 00 00       	jmp    8010733f <sys_link+0x1a2>
  }

  ilock(ip);
80107203:	83 ec 0c             	sub    $0xc,%esp
80107206:	ff 75 f4             	pushl  -0xc(%ebp)
80107209:	e8 0d a8 ff ff       	call   80101a1b <ilock>
8010720e:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80107211:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107214:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107218:	66 83 f8 01          	cmp    $0x1,%ax
8010721c:	75 1d                	jne    8010723b <sys_link+0x9e>
    iunlockput(ip);
8010721e:	83 ec 0c             	sub    $0xc,%esp
80107221:	ff 75 f4             	pushl  -0xc(%ebp)
80107224:	e8 b2 aa ff ff       	call   80101cdb <iunlockput>
80107229:	83 c4 10             	add    $0x10,%esp
    end_op();
8010722c:	e8 59 c4 ff ff       	call   8010368a <end_op>
    return -1;
80107231:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107236:	e9 04 01 00 00       	jmp    8010733f <sys_link+0x1a2>
  }

  ip->nlink++;
8010723b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010723e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107242:	83 c0 01             	add    $0x1,%eax
80107245:	89 c2                	mov    %eax,%edx
80107247:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010724a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010724e:	83 ec 0c             	sub    $0xc,%esp
80107251:	ff 75 f4             	pushl  -0xc(%ebp)
80107254:	e8 e8 a5 ff ff       	call   80101841 <iupdate>
80107259:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
8010725c:	83 ec 0c             	sub    $0xc,%esp
8010725f:	ff 75 f4             	pushl  -0xc(%ebp)
80107262:	e8 12 a9 ff ff       	call   80101b79 <iunlock>
80107267:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
8010726a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010726d:	83 ec 08             	sub    $0x8,%esp
80107270:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80107273:	52                   	push   %edx
80107274:	50                   	push   %eax
80107275:	e8 7b b3 ff ff       	call   801025f5 <nameiparent>
8010727a:	83 c4 10             	add    $0x10,%esp
8010727d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107284:	74 71                	je     801072f7 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80107286:	83 ec 0c             	sub    $0xc,%esp
80107289:	ff 75 f0             	pushl  -0x10(%ebp)
8010728c:	e8 8a a7 ff ff       	call   80101a1b <ilock>
80107291:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80107294:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107297:	8b 10                	mov    (%eax),%edx
80107299:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010729c:	8b 00                	mov    (%eax),%eax
8010729e:	39 c2                	cmp    %eax,%edx
801072a0:	75 1d                	jne    801072bf <sys_link+0x122>
801072a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072a5:	8b 40 04             	mov    0x4(%eax),%eax
801072a8:	83 ec 04             	sub    $0x4,%esp
801072ab:	50                   	push   %eax
801072ac:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801072af:	50                   	push   %eax
801072b0:	ff 75 f0             	pushl  -0x10(%ebp)
801072b3:	e8 85 b0 ff ff       	call   8010233d <dirlink>
801072b8:	83 c4 10             	add    $0x10,%esp
801072bb:	85 c0                	test   %eax,%eax
801072bd:	79 10                	jns    801072cf <sys_link+0x132>
    iunlockput(dp);
801072bf:	83 ec 0c             	sub    $0xc,%esp
801072c2:	ff 75 f0             	pushl  -0x10(%ebp)
801072c5:	e8 11 aa ff ff       	call   80101cdb <iunlockput>
801072ca:	83 c4 10             	add    $0x10,%esp
    goto bad;
801072cd:	eb 29                	jmp    801072f8 <sys_link+0x15b>
  }
  iunlockput(dp);
801072cf:	83 ec 0c             	sub    $0xc,%esp
801072d2:	ff 75 f0             	pushl  -0x10(%ebp)
801072d5:	e8 01 aa ff ff       	call   80101cdb <iunlockput>
801072da:	83 c4 10             	add    $0x10,%esp
  iput(ip);
801072dd:	83 ec 0c             	sub    $0xc,%esp
801072e0:	ff 75 f4             	pushl  -0xc(%ebp)
801072e3:	e8 03 a9 ff ff       	call   80101beb <iput>
801072e8:	83 c4 10             	add    $0x10,%esp

  end_op();
801072eb:	e8 9a c3 ff ff       	call   8010368a <end_op>

  return 0;
801072f0:	b8 00 00 00 00       	mov    $0x0,%eax
801072f5:	eb 48                	jmp    8010733f <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
801072f7:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
801072f8:	83 ec 0c             	sub    $0xc,%esp
801072fb:	ff 75 f4             	pushl  -0xc(%ebp)
801072fe:	e8 18 a7 ff ff       	call   80101a1b <ilock>
80107303:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80107306:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107309:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010730d:	83 e8 01             	sub    $0x1,%eax
80107310:	89 c2                	mov    %eax,%edx
80107312:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107315:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107319:	83 ec 0c             	sub    $0xc,%esp
8010731c:	ff 75 f4             	pushl  -0xc(%ebp)
8010731f:	e8 1d a5 ff ff       	call   80101841 <iupdate>
80107324:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107327:	83 ec 0c             	sub    $0xc,%esp
8010732a:	ff 75 f4             	pushl  -0xc(%ebp)
8010732d:	e8 a9 a9 ff ff       	call   80101cdb <iunlockput>
80107332:	83 c4 10             	add    $0x10,%esp
  end_op();
80107335:	e8 50 c3 ff ff       	call   8010368a <end_op>
  return -1;
8010733a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010733f:	c9                   	leave  
80107340:	c3                   	ret    

80107341 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80107341:	55                   	push   %ebp
80107342:	89 e5                	mov    %esp,%ebp
80107344:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107347:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010734e:	eb 40                	jmp    80107390 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80107350:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107353:	6a 10                	push   $0x10
80107355:	50                   	push   %eax
80107356:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107359:	50                   	push   %eax
8010735a:	ff 75 08             	pushl  0x8(%ebp)
8010735d:	e8 27 ac ff ff       	call   80101f89 <readi>
80107362:	83 c4 10             	add    $0x10,%esp
80107365:	83 f8 10             	cmp    $0x10,%eax
80107368:	74 0d                	je     80107377 <isdirempty+0x36>
      panic("isdirempty: readi");
8010736a:	83 ec 0c             	sub    $0xc,%esp
8010736d:	68 d6 aa 10 80       	push   $0x8010aad6
80107372:	e8 ef 91 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80107377:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010737b:	66 85 c0             	test   %ax,%ax
8010737e:	74 07                	je     80107387 <isdirempty+0x46>
      return 0;
80107380:	b8 00 00 00 00       	mov    $0x0,%eax
80107385:	eb 1b                	jmp    801073a2 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107387:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010738a:	83 c0 10             	add    $0x10,%eax
8010738d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107390:	8b 45 08             	mov    0x8(%ebp),%eax
80107393:	8b 50 18             	mov    0x18(%eax),%edx
80107396:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107399:	39 c2                	cmp    %eax,%edx
8010739b:	77 b3                	ja     80107350 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010739d:	b8 01 00 00 00       	mov    $0x1,%eax
}
801073a2:	c9                   	leave  
801073a3:	c3                   	ret    

801073a4 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801073a4:	55                   	push   %ebp
801073a5:	89 e5                	mov    %esp,%ebp
801073a7:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801073aa:	83 ec 08             	sub    $0x8,%esp
801073ad:	8d 45 cc             	lea    -0x34(%ebp),%eax
801073b0:	50                   	push   %eax
801073b1:	6a 00                	push   $0x0
801073b3:	e8 a0 fa ff ff       	call   80106e58 <argstr>
801073b8:	83 c4 10             	add    $0x10,%esp
801073bb:	85 c0                	test   %eax,%eax
801073bd:	79 0a                	jns    801073c9 <sys_unlink+0x25>
    return -1;
801073bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073c4:	e9 bc 01 00 00       	jmp    80107585 <sys_unlink+0x1e1>

  begin_op();
801073c9:	e8 30 c2 ff ff       	call   801035fe <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801073ce:	8b 45 cc             	mov    -0x34(%ebp),%eax
801073d1:	83 ec 08             	sub    $0x8,%esp
801073d4:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801073d7:	52                   	push   %edx
801073d8:	50                   	push   %eax
801073d9:	e8 17 b2 ff ff       	call   801025f5 <nameiparent>
801073de:	83 c4 10             	add    $0x10,%esp
801073e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801073e8:	75 0f                	jne    801073f9 <sys_unlink+0x55>
    end_op();
801073ea:	e8 9b c2 ff ff       	call   8010368a <end_op>
    return -1;
801073ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073f4:	e9 8c 01 00 00       	jmp    80107585 <sys_unlink+0x1e1>
  }

  ilock(dp);
801073f9:	83 ec 0c             	sub    $0xc,%esp
801073fc:	ff 75 f4             	pushl  -0xc(%ebp)
801073ff:	e8 17 a6 ff ff       	call   80101a1b <ilock>
80107404:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80107407:	83 ec 08             	sub    $0x8,%esp
8010740a:	68 e8 aa 10 80       	push   $0x8010aae8
8010740f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107412:	50                   	push   %eax
80107413:	e8 50 ae ff ff       	call   80102268 <namecmp>
80107418:	83 c4 10             	add    $0x10,%esp
8010741b:	85 c0                	test   %eax,%eax
8010741d:	0f 84 4a 01 00 00    	je     8010756d <sys_unlink+0x1c9>
80107423:	83 ec 08             	sub    $0x8,%esp
80107426:	68 ea aa 10 80       	push   $0x8010aaea
8010742b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010742e:	50                   	push   %eax
8010742f:	e8 34 ae ff ff       	call   80102268 <namecmp>
80107434:	83 c4 10             	add    $0x10,%esp
80107437:	85 c0                	test   %eax,%eax
80107439:	0f 84 2e 01 00 00    	je     8010756d <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010743f:	83 ec 04             	sub    $0x4,%esp
80107442:	8d 45 c8             	lea    -0x38(%ebp),%eax
80107445:	50                   	push   %eax
80107446:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107449:	50                   	push   %eax
8010744a:	ff 75 f4             	pushl  -0xc(%ebp)
8010744d:	e8 31 ae ff ff       	call   80102283 <dirlookup>
80107452:	83 c4 10             	add    $0x10,%esp
80107455:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107458:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010745c:	0f 84 0a 01 00 00    	je     8010756c <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80107462:	83 ec 0c             	sub    $0xc,%esp
80107465:	ff 75 f0             	pushl  -0x10(%ebp)
80107468:	e8 ae a5 ff ff       	call   80101a1b <ilock>
8010746d:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80107470:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107473:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107477:	66 85 c0             	test   %ax,%ax
8010747a:	7f 0d                	jg     80107489 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
8010747c:	83 ec 0c             	sub    $0xc,%esp
8010747f:	68 ed aa 10 80       	push   $0x8010aaed
80107484:	e8 dd 90 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80107489:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010748c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107490:	66 83 f8 01          	cmp    $0x1,%ax
80107494:	75 25                	jne    801074bb <sys_unlink+0x117>
80107496:	83 ec 0c             	sub    $0xc,%esp
80107499:	ff 75 f0             	pushl  -0x10(%ebp)
8010749c:	e8 a0 fe ff ff       	call   80107341 <isdirempty>
801074a1:	83 c4 10             	add    $0x10,%esp
801074a4:	85 c0                	test   %eax,%eax
801074a6:	75 13                	jne    801074bb <sys_unlink+0x117>
    iunlockput(ip);
801074a8:	83 ec 0c             	sub    $0xc,%esp
801074ab:	ff 75 f0             	pushl  -0x10(%ebp)
801074ae:	e8 28 a8 ff ff       	call   80101cdb <iunlockput>
801074b3:	83 c4 10             	add    $0x10,%esp
    goto bad;
801074b6:	e9 b2 00 00 00       	jmp    8010756d <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801074bb:	83 ec 04             	sub    $0x4,%esp
801074be:	6a 10                	push   $0x10
801074c0:	6a 00                	push   $0x0
801074c2:	8d 45 e0             	lea    -0x20(%ebp),%eax
801074c5:	50                   	push   %eax
801074c6:	e8 e3 f5 ff ff       	call   80106aae <memset>
801074cb:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801074ce:	8b 45 c8             	mov    -0x38(%ebp),%eax
801074d1:	6a 10                	push   $0x10
801074d3:	50                   	push   %eax
801074d4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801074d7:	50                   	push   %eax
801074d8:	ff 75 f4             	pushl  -0xc(%ebp)
801074db:	e8 00 ac ff ff       	call   801020e0 <writei>
801074e0:	83 c4 10             	add    $0x10,%esp
801074e3:	83 f8 10             	cmp    $0x10,%eax
801074e6:	74 0d                	je     801074f5 <sys_unlink+0x151>
    panic("unlink: writei");
801074e8:	83 ec 0c             	sub    $0xc,%esp
801074eb:	68 ff aa 10 80       	push   $0x8010aaff
801074f0:	e8 71 90 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
801074f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074f8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801074fc:	66 83 f8 01          	cmp    $0x1,%ax
80107500:	75 21                	jne    80107523 <sys_unlink+0x17f>
    dp->nlink--;
80107502:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107505:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107509:	83 e8 01             	sub    $0x1,%eax
8010750c:	89 c2                	mov    %eax,%edx
8010750e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107511:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80107515:	83 ec 0c             	sub    $0xc,%esp
80107518:	ff 75 f4             	pushl  -0xc(%ebp)
8010751b:	e8 21 a3 ff ff       	call   80101841 <iupdate>
80107520:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80107523:	83 ec 0c             	sub    $0xc,%esp
80107526:	ff 75 f4             	pushl  -0xc(%ebp)
80107529:	e8 ad a7 ff ff       	call   80101cdb <iunlockput>
8010752e:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80107531:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107534:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107538:	83 e8 01             	sub    $0x1,%eax
8010753b:	89 c2                	mov    %eax,%edx
8010753d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107540:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107544:	83 ec 0c             	sub    $0xc,%esp
80107547:	ff 75 f0             	pushl  -0x10(%ebp)
8010754a:	e8 f2 a2 ff ff       	call   80101841 <iupdate>
8010754f:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107552:	83 ec 0c             	sub    $0xc,%esp
80107555:	ff 75 f0             	pushl  -0x10(%ebp)
80107558:	e8 7e a7 ff ff       	call   80101cdb <iunlockput>
8010755d:	83 c4 10             	add    $0x10,%esp

  end_op();
80107560:	e8 25 c1 ff ff       	call   8010368a <end_op>

  return 0;
80107565:	b8 00 00 00 00       	mov    $0x0,%eax
8010756a:	eb 19                	jmp    80107585 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
8010756c:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
8010756d:	83 ec 0c             	sub    $0xc,%esp
80107570:	ff 75 f4             	pushl  -0xc(%ebp)
80107573:	e8 63 a7 ff ff       	call   80101cdb <iunlockput>
80107578:	83 c4 10             	add    $0x10,%esp
  end_op();
8010757b:	e8 0a c1 ff ff       	call   8010368a <end_op>
  return -1;
80107580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107585:	c9                   	leave  
80107586:	c3                   	ret    

80107587 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80107587:	55                   	push   %ebp
80107588:	89 e5                	mov    %esp,%ebp
8010758a:	83 ec 38             	sub    $0x38,%esp
8010758d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107590:	8b 55 10             	mov    0x10(%ebp),%edx
80107593:	8b 45 14             	mov    0x14(%ebp),%eax
80107596:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010759a:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010759e:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801075a2:	83 ec 08             	sub    $0x8,%esp
801075a5:	8d 45 de             	lea    -0x22(%ebp),%eax
801075a8:	50                   	push   %eax
801075a9:	ff 75 08             	pushl  0x8(%ebp)
801075ac:	e8 44 b0 ff ff       	call   801025f5 <nameiparent>
801075b1:	83 c4 10             	add    $0x10,%esp
801075b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801075b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801075bb:	75 0a                	jne    801075c7 <create+0x40>
    return 0;
801075bd:	b8 00 00 00 00       	mov    $0x0,%eax
801075c2:	e9 90 01 00 00       	jmp    80107757 <create+0x1d0>
  ilock(dp);
801075c7:	83 ec 0c             	sub    $0xc,%esp
801075ca:	ff 75 f4             	pushl  -0xc(%ebp)
801075cd:	e8 49 a4 ff ff       	call   80101a1b <ilock>
801075d2:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
801075d5:	83 ec 04             	sub    $0x4,%esp
801075d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801075db:	50                   	push   %eax
801075dc:	8d 45 de             	lea    -0x22(%ebp),%eax
801075df:	50                   	push   %eax
801075e0:	ff 75 f4             	pushl  -0xc(%ebp)
801075e3:	e8 9b ac ff ff       	call   80102283 <dirlookup>
801075e8:	83 c4 10             	add    $0x10,%esp
801075eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801075ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801075f2:	74 50                	je     80107644 <create+0xbd>
    iunlockput(dp);
801075f4:	83 ec 0c             	sub    $0xc,%esp
801075f7:	ff 75 f4             	pushl  -0xc(%ebp)
801075fa:	e8 dc a6 ff ff       	call   80101cdb <iunlockput>
801075ff:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80107602:	83 ec 0c             	sub    $0xc,%esp
80107605:	ff 75 f0             	pushl  -0x10(%ebp)
80107608:	e8 0e a4 ff ff       	call   80101a1b <ilock>
8010760d:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80107610:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80107615:	75 15                	jne    8010762c <create+0xa5>
80107617:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010761a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010761e:	66 83 f8 02          	cmp    $0x2,%ax
80107622:	75 08                	jne    8010762c <create+0xa5>
      return ip;
80107624:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107627:	e9 2b 01 00 00       	jmp    80107757 <create+0x1d0>
    iunlockput(ip);
8010762c:	83 ec 0c             	sub    $0xc,%esp
8010762f:	ff 75 f0             	pushl  -0x10(%ebp)
80107632:	e8 a4 a6 ff ff       	call   80101cdb <iunlockput>
80107637:	83 c4 10             	add    $0x10,%esp
    return 0;
8010763a:	b8 00 00 00 00       	mov    $0x0,%eax
8010763f:	e9 13 01 00 00       	jmp    80107757 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80107644:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80107648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010764b:	8b 00                	mov    (%eax),%eax
8010764d:	83 ec 08             	sub    $0x8,%esp
80107650:	52                   	push   %edx
80107651:	50                   	push   %eax
80107652:	e8 13 a1 ff ff       	call   8010176a <ialloc>
80107657:	83 c4 10             	add    $0x10,%esp
8010765a:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010765d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107661:	75 0d                	jne    80107670 <create+0xe9>
    panic("create: ialloc");
80107663:	83 ec 0c             	sub    $0xc,%esp
80107666:	68 0e ab 10 80       	push   $0x8010ab0e
8010766b:	e8 f6 8e ff ff       	call   80100566 <panic>

  ilock(ip);
80107670:	83 ec 0c             	sub    $0xc,%esp
80107673:	ff 75 f0             	pushl  -0x10(%ebp)
80107676:	e8 a0 a3 ff ff       	call   80101a1b <ilock>
8010767b:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
8010767e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107681:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80107685:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80107689:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010768c:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80107690:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80107694:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107697:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010769d:	83 ec 0c             	sub    $0xc,%esp
801076a0:	ff 75 f0             	pushl  -0x10(%ebp)
801076a3:	e8 99 a1 ff ff       	call   80101841 <iupdate>
801076a8:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801076ab:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801076b0:	75 6a                	jne    8010771c <create+0x195>
    dp->nlink++;  // for ".."
801076b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076b5:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801076b9:	83 c0 01             	add    $0x1,%eax
801076bc:	89 c2                	mov    %eax,%edx
801076be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076c1:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801076c5:	83 ec 0c             	sub    $0xc,%esp
801076c8:	ff 75 f4             	pushl  -0xc(%ebp)
801076cb:	e8 71 a1 ff ff       	call   80101841 <iupdate>
801076d0:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801076d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076d6:	8b 40 04             	mov    0x4(%eax),%eax
801076d9:	83 ec 04             	sub    $0x4,%esp
801076dc:	50                   	push   %eax
801076dd:	68 e8 aa 10 80       	push   $0x8010aae8
801076e2:	ff 75 f0             	pushl  -0x10(%ebp)
801076e5:	e8 53 ac ff ff       	call   8010233d <dirlink>
801076ea:	83 c4 10             	add    $0x10,%esp
801076ed:	85 c0                	test   %eax,%eax
801076ef:	78 1e                	js     8010770f <create+0x188>
801076f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076f4:	8b 40 04             	mov    0x4(%eax),%eax
801076f7:	83 ec 04             	sub    $0x4,%esp
801076fa:	50                   	push   %eax
801076fb:	68 ea aa 10 80       	push   $0x8010aaea
80107700:	ff 75 f0             	pushl  -0x10(%ebp)
80107703:	e8 35 ac ff ff       	call   8010233d <dirlink>
80107708:	83 c4 10             	add    $0x10,%esp
8010770b:	85 c0                	test   %eax,%eax
8010770d:	79 0d                	jns    8010771c <create+0x195>
      panic("create dots");
8010770f:	83 ec 0c             	sub    $0xc,%esp
80107712:	68 1d ab 10 80       	push   $0x8010ab1d
80107717:	e8 4a 8e ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010771c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010771f:	8b 40 04             	mov    0x4(%eax),%eax
80107722:	83 ec 04             	sub    $0x4,%esp
80107725:	50                   	push   %eax
80107726:	8d 45 de             	lea    -0x22(%ebp),%eax
80107729:	50                   	push   %eax
8010772a:	ff 75 f4             	pushl  -0xc(%ebp)
8010772d:	e8 0b ac ff ff       	call   8010233d <dirlink>
80107732:	83 c4 10             	add    $0x10,%esp
80107735:	85 c0                	test   %eax,%eax
80107737:	79 0d                	jns    80107746 <create+0x1bf>
    panic("create: dirlink");
80107739:	83 ec 0c             	sub    $0xc,%esp
8010773c:	68 29 ab 10 80       	push   $0x8010ab29
80107741:	e8 20 8e ff ff       	call   80100566 <panic>

  iunlockput(dp);
80107746:	83 ec 0c             	sub    $0xc,%esp
80107749:	ff 75 f4             	pushl  -0xc(%ebp)
8010774c:	e8 8a a5 ff ff       	call   80101cdb <iunlockput>
80107751:	83 c4 10             	add    $0x10,%esp

  return ip;
80107754:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107757:	c9                   	leave  
80107758:	c3                   	ret    

80107759 <sys_open>:

int
sys_open(void)
{
80107759:	55                   	push   %ebp
8010775a:	89 e5                	mov    %esp,%ebp
8010775c:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010775f:	83 ec 08             	sub    $0x8,%esp
80107762:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107765:	50                   	push   %eax
80107766:	6a 00                	push   $0x0
80107768:	e8 eb f6 ff ff       	call   80106e58 <argstr>
8010776d:	83 c4 10             	add    $0x10,%esp
80107770:	85 c0                	test   %eax,%eax
80107772:	78 15                	js     80107789 <sys_open+0x30>
80107774:	83 ec 08             	sub    $0x8,%esp
80107777:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010777a:	50                   	push   %eax
8010777b:	6a 01                	push   $0x1
8010777d:	e8 51 f6 ff ff       	call   80106dd3 <argint>
80107782:	83 c4 10             	add    $0x10,%esp
80107785:	85 c0                	test   %eax,%eax
80107787:	79 0a                	jns    80107793 <sys_open+0x3a>
    return -1;
80107789:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010778e:	e9 61 01 00 00       	jmp    801078f4 <sys_open+0x19b>

  begin_op();
80107793:	e8 66 be ff ff       	call   801035fe <begin_op>

  if(omode & O_CREATE){
80107798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010779b:	25 00 02 00 00       	and    $0x200,%eax
801077a0:	85 c0                	test   %eax,%eax
801077a2:	74 2a                	je     801077ce <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801077a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801077a7:	6a 00                	push   $0x0
801077a9:	6a 00                	push   $0x0
801077ab:	6a 02                	push   $0x2
801077ad:	50                   	push   %eax
801077ae:	e8 d4 fd ff ff       	call   80107587 <create>
801077b3:	83 c4 10             	add    $0x10,%esp
801077b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801077b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801077bd:	75 75                	jne    80107834 <sys_open+0xdb>
      end_op();
801077bf:	e8 c6 be ff ff       	call   8010368a <end_op>
      return -1;
801077c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077c9:	e9 26 01 00 00       	jmp    801078f4 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801077ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
801077d1:	83 ec 0c             	sub    $0xc,%esp
801077d4:	50                   	push   %eax
801077d5:	e8 ff ad ff ff       	call   801025d9 <namei>
801077da:	83 c4 10             	add    $0x10,%esp
801077dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801077e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801077e4:	75 0f                	jne    801077f5 <sys_open+0x9c>
      end_op();
801077e6:	e8 9f be ff ff       	call   8010368a <end_op>
      return -1;
801077eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077f0:	e9 ff 00 00 00       	jmp    801078f4 <sys_open+0x19b>
    }
    ilock(ip);
801077f5:	83 ec 0c             	sub    $0xc,%esp
801077f8:	ff 75 f4             	pushl  -0xc(%ebp)
801077fb:	e8 1b a2 ff ff       	call   80101a1b <ilock>
80107800:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80107803:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107806:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010780a:	66 83 f8 01          	cmp    $0x1,%ax
8010780e:	75 24                	jne    80107834 <sys_open+0xdb>
80107810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107813:	85 c0                	test   %eax,%eax
80107815:	74 1d                	je     80107834 <sys_open+0xdb>
      iunlockput(ip);
80107817:	83 ec 0c             	sub    $0xc,%esp
8010781a:	ff 75 f4             	pushl  -0xc(%ebp)
8010781d:	e8 b9 a4 ff ff       	call   80101cdb <iunlockput>
80107822:	83 c4 10             	add    $0x10,%esp
      end_op();
80107825:	e8 60 be ff ff       	call   8010368a <end_op>
      return -1;
8010782a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010782f:	e9 c0 00 00 00       	jmp    801078f4 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80107834:	e8 0b 98 ff ff       	call   80101044 <filealloc>
80107839:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010783c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107840:	74 17                	je     80107859 <sys_open+0x100>
80107842:	83 ec 0c             	sub    $0xc,%esp
80107845:	ff 75 f0             	pushl  -0x10(%ebp)
80107848:	e8 37 f7 ff ff       	call   80106f84 <fdalloc>
8010784d:	83 c4 10             	add    $0x10,%esp
80107850:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107853:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107857:	79 2e                	jns    80107887 <sys_open+0x12e>
    if(f)
80107859:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010785d:	74 0e                	je     8010786d <sys_open+0x114>
      fileclose(f);
8010785f:	83 ec 0c             	sub    $0xc,%esp
80107862:	ff 75 f0             	pushl  -0x10(%ebp)
80107865:	e8 98 98 ff ff       	call   80101102 <fileclose>
8010786a:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010786d:	83 ec 0c             	sub    $0xc,%esp
80107870:	ff 75 f4             	pushl  -0xc(%ebp)
80107873:	e8 63 a4 ff ff       	call   80101cdb <iunlockput>
80107878:	83 c4 10             	add    $0x10,%esp
    end_op();
8010787b:	e8 0a be ff ff       	call   8010368a <end_op>
    return -1;
80107880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107885:	eb 6d                	jmp    801078f4 <sys_open+0x19b>
  }
  iunlock(ip);
80107887:	83 ec 0c             	sub    $0xc,%esp
8010788a:	ff 75 f4             	pushl  -0xc(%ebp)
8010788d:	e8 e7 a2 ff ff       	call   80101b79 <iunlock>
80107892:	83 c4 10             	add    $0x10,%esp
  end_op();
80107895:	e8 f0 bd ff ff       	call   8010368a <end_op>

  f->type = FD_INODE;
8010789a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010789d:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801078a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801078a9:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801078ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078af:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801078b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078b9:	83 e0 01             	and    $0x1,%eax
801078bc:	85 c0                	test   %eax,%eax
801078be:	0f 94 c0             	sete   %al
801078c1:	89 c2                	mov    %eax,%edx
801078c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078c6:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801078c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078cc:	83 e0 01             	and    $0x1,%eax
801078cf:	85 c0                	test   %eax,%eax
801078d1:	75 0a                	jne    801078dd <sys_open+0x184>
801078d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078d6:	83 e0 02             	and    $0x2,%eax
801078d9:	85 c0                	test   %eax,%eax
801078db:	74 07                	je     801078e4 <sys_open+0x18b>
801078dd:	b8 01 00 00 00       	mov    $0x1,%eax
801078e2:	eb 05                	jmp    801078e9 <sys_open+0x190>
801078e4:	b8 00 00 00 00       	mov    $0x0,%eax
801078e9:	89 c2                	mov    %eax,%edx
801078eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078ee:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801078f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801078f4:	c9                   	leave  
801078f5:	c3                   	ret    

801078f6 <sys_mkdir>:

int
sys_mkdir(void)
{
801078f6:	55                   	push   %ebp
801078f7:	89 e5                	mov    %esp,%ebp
801078f9:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801078fc:	e8 fd bc ff ff       	call   801035fe <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80107901:	83 ec 08             	sub    $0x8,%esp
80107904:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107907:	50                   	push   %eax
80107908:	6a 00                	push   $0x0
8010790a:	e8 49 f5 ff ff       	call   80106e58 <argstr>
8010790f:	83 c4 10             	add    $0x10,%esp
80107912:	85 c0                	test   %eax,%eax
80107914:	78 1b                	js     80107931 <sys_mkdir+0x3b>
80107916:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107919:	6a 00                	push   $0x0
8010791b:	6a 00                	push   $0x0
8010791d:	6a 01                	push   $0x1
8010791f:	50                   	push   %eax
80107920:	e8 62 fc ff ff       	call   80107587 <create>
80107925:	83 c4 10             	add    $0x10,%esp
80107928:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010792b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010792f:	75 0c                	jne    8010793d <sys_mkdir+0x47>
    end_op();
80107931:	e8 54 bd ff ff       	call   8010368a <end_op>
    return -1;
80107936:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010793b:	eb 18                	jmp    80107955 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010793d:	83 ec 0c             	sub    $0xc,%esp
80107940:	ff 75 f4             	pushl  -0xc(%ebp)
80107943:	e8 93 a3 ff ff       	call   80101cdb <iunlockput>
80107948:	83 c4 10             	add    $0x10,%esp
  end_op();
8010794b:	e8 3a bd ff ff       	call   8010368a <end_op>
  return 0;
80107950:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107955:	c9                   	leave  
80107956:	c3                   	ret    

80107957 <sys_mknod>:

int
sys_mknod(void)
{
80107957:	55                   	push   %ebp
80107958:	89 e5                	mov    %esp,%ebp
8010795a:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010795d:	e8 9c bc ff ff       	call   801035fe <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107962:	83 ec 08             	sub    $0x8,%esp
80107965:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107968:	50                   	push   %eax
80107969:	6a 00                	push   $0x0
8010796b:	e8 e8 f4 ff ff       	call   80106e58 <argstr>
80107970:	83 c4 10             	add    $0x10,%esp
80107973:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107976:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010797a:	78 4f                	js     801079cb <sys_mknod+0x74>
     argint(1, &major) < 0 ||
8010797c:	83 ec 08             	sub    $0x8,%esp
8010797f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107982:	50                   	push   %eax
80107983:	6a 01                	push   $0x1
80107985:	e8 49 f4 ff ff       	call   80106dd3 <argint>
8010798a:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010798d:	85 c0                	test   %eax,%eax
8010798f:	78 3a                	js     801079cb <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107991:	83 ec 08             	sub    $0x8,%esp
80107994:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107997:	50                   	push   %eax
80107998:	6a 02                	push   $0x2
8010799a:	e8 34 f4 ff ff       	call   80106dd3 <argint>
8010799f:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801079a2:	85 c0                	test   %eax,%eax
801079a4:	78 25                	js     801079cb <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801079a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079a9:	0f bf c8             	movswl %ax,%ecx
801079ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
801079af:	0f bf d0             	movswl %ax,%edx
801079b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801079b5:	51                   	push   %ecx
801079b6:	52                   	push   %edx
801079b7:	6a 03                	push   $0x3
801079b9:	50                   	push   %eax
801079ba:	e8 c8 fb ff ff       	call   80107587 <create>
801079bf:	83 c4 10             	add    $0x10,%esp
801079c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801079c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801079c9:	75 0c                	jne    801079d7 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801079cb:	e8 ba bc ff ff       	call   8010368a <end_op>
    return -1;
801079d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079d5:	eb 18                	jmp    801079ef <sys_mknod+0x98>
  }
  iunlockput(ip);
801079d7:	83 ec 0c             	sub    $0xc,%esp
801079da:	ff 75 f0             	pushl  -0x10(%ebp)
801079dd:	e8 f9 a2 ff ff       	call   80101cdb <iunlockput>
801079e2:	83 c4 10             	add    $0x10,%esp
  end_op();
801079e5:	e8 a0 bc ff ff       	call   8010368a <end_op>
  return 0;
801079ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079ef:	c9                   	leave  
801079f0:	c3                   	ret    

801079f1 <sys_chdir>:

int
sys_chdir(void)
{
801079f1:	55                   	push   %ebp
801079f2:	89 e5                	mov    %esp,%ebp
801079f4:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801079f7:	e8 02 bc ff ff       	call   801035fe <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801079fc:	83 ec 08             	sub    $0x8,%esp
801079ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a02:	50                   	push   %eax
80107a03:	6a 00                	push   $0x0
80107a05:	e8 4e f4 ff ff       	call   80106e58 <argstr>
80107a0a:	83 c4 10             	add    $0x10,%esp
80107a0d:	85 c0                	test   %eax,%eax
80107a0f:	78 18                	js     80107a29 <sys_chdir+0x38>
80107a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a14:	83 ec 0c             	sub    $0xc,%esp
80107a17:	50                   	push   %eax
80107a18:	e8 bc ab ff ff       	call   801025d9 <namei>
80107a1d:	83 c4 10             	add    $0x10,%esp
80107a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a27:	75 0c                	jne    80107a35 <sys_chdir+0x44>
    end_op();
80107a29:	e8 5c bc ff ff       	call   8010368a <end_op>
    return -1;
80107a2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a33:	eb 6e                	jmp    80107aa3 <sys_chdir+0xb2>
  }
  ilock(ip);
80107a35:	83 ec 0c             	sub    $0xc,%esp
80107a38:	ff 75 f4             	pushl  -0xc(%ebp)
80107a3b:	e8 db 9f ff ff       	call   80101a1b <ilock>
80107a40:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a46:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107a4a:	66 83 f8 01          	cmp    $0x1,%ax
80107a4e:	74 1a                	je     80107a6a <sys_chdir+0x79>
    iunlockput(ip);
80107a50:	83 ec 0c             	sub    $0xc,%esp
80107a53:	ff 75 f4             	pushl  -0xc(%ebp)
80107a56:	e8 80 a2 ff ff       	call   80101cdb <iunlockput>
80107a5b:	83 c4 10             	add    $0x10,%esp
    end_op();
80107a5e:	e8 27 bc ff ff       	call   8010368a <end_op>
    return -1;
80107a63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a68:	eb 39                	jmp    80107aa3 <sys_chdir+0xb2>
  }
  iunlock(ip);
80107a6a:	83 ec 0c             	sub    $0xc,%esp
80107a6d:	ff 75 f4             	pushl  -0xc(%ebp)
80107a70:	e8 04 a1 ff ff       	call   80101b79 <iunlock>
80107a75:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107a78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a7e:	8b 40 68             	mov    0x68(%eax),%eax
80107a81:	83 ec 0c             	sub    $0xc,%esp
80107a84:	50                   	push   %eax
80107a85:	e8 61 a1 ff ff       	call   80101beb <iput>
80107a8a:	83 c4 10             	add    $0x10,%esp
  end_op();
80107a8d:	e8 f8 bb ff ff       	call   8010368a <end_op>
  proc->cwd = ip;
80107a92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107a98:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107a9b:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107a9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107aa3:	c9                   	leave  
80107aa4:	c3                   	ret    

80107aa5 <sys_exec>:

int
sys_exec(void)
{
80107aa5:	55                   	push   %ebp
80107aa6:	89 e5                	mov    %esp,%ebp
80107aa8:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107aae:	83 ec 08             	sub    $0x8,%esp
80107ab1:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107ab4:	50                   	push   %eax
80107ab5:	6a 00                	push   $0x0
80107ab7:	e8 9c f3 ff ff       	call   80106e58 <argstr>
80107abc:	83 c4 10             	add    $0x10,%esp
80107abf:	85 c0                	test   %eax,%eax
80107ac1:	78 18                	js     80107adb <sys_exec+0x36>
80107ac3:	83 ec 08             	sub    $0x8,%esp
80107ac6:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107acc:	50                   	push   %eax
80107acd:	6a 01                	push   $0x1
80107acf:	e8 ff f2 ff ff       	call   80106dd3 <argint>
80107ad4:	83 c4 10             	add    $0x10,%esp
80107ad7:	85 c0                	test   %eax,%eax
80107ad9:	79 0a                	jns    80107ae5 <sys_exec+0x40>
    return -1;
80107adb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ae0:	e9 c6 00 00 00       	jmp    80107bab <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80107ae5:	83 ec 04             	sub    $0x4,%esp
80107ae8:	68 80 00 00 00       	push   $0x80
80107aed:	6a 00                	push   $0x0
80107aef:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107af5:	50                   	push   %eax
80107af6:	e8 b3 ef ff ff       	call   80106aae <memset>
80107afb:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80107afe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b08:	83 f8 1f             	cmp    $0x1f,%eax
80107b0b:	76 0a                	jbe    80107b17 <sys_exec+0x72>
      return -1;
80107b0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b12:	e9 94 00 00 00       	jmp    80107bab <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1a:	c1 e0 02             	shl    $0x2,%eax
80107b1d:	89 c2                	mov    %eax,%edx
80107b1f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107b25:	01 c2                	add    %eax,%edx
80107b27:	83 ec 08             	sub    $0x8,%esp
80107b2a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107b30:	50                   	push   %eax
80107b31:	52                   	push   %edx
80107b32:	e8 00 f2 ff ff       	call   80106d37 <fetchint>
80107b37:	83 c4 10             	add    $0x10,%esp
80107b3a:	85 c0                	test   %eax,%eax
80107b3c:	79 07                	jns    80107b45 <sys_exec+0xa0>
      return -1;
80107b3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b43:	eb 66                	jmp    80107bab <sys_exec+0x106>
    if(uarg == 0){
80107b45:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107b4b:	85 c0                	test   %eax,%eax
80107b4d:	75 27                	jne    80107b76 <sys_exec+0xd1>
      argv[i] = 0;
80107b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b52:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107b59:	00 00 00 00 
      break;
80107b5d:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107b5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b61:	83 ec 08             	sub    $0x8,%esp
80107b64:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107b6a:	52                   	push   %edx
80107b6b:	50                   	push   %eax
80107b6c:	e8 b1 90 ff ff       	call   80100c22 <exec>
80107b71:	83 c4 10             	add    $0x10,%esp
80107b74:	eb 35                	jmp    80107bab <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107b76:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107b7c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107b7f:	c1 e2 02             	shl    $0x2,%edx
80107b82:	01 c2                	add    %eax,%edx
80107b84:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107b8a:	83 ec 08             	sub    $0x8,%esp
80107b8d:	52                   	push   %edx
80107b8e:	50                   	push   %eax
80107b8f:	e8 dd f1 ff ff       	call   80106d71 <fetchstr>
80107b94:	83 c4 10             	add    $0x10,%esp
80107b97:	85 c0                	test   %eax,%eax
80107b99:	79 07                	jns    80107ba2 <sys_exec+0xfd>
      return -1;
80107b9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ba0:	eb 09                	jmp    80107bab <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107ba2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80107ba6:	e9 5a ff ff ff       	jmp    80107b05 <sys_exec+0x60>
  return exec(path, argv);
}
80107bab:	c9                   	leave  
80107bac:	c3                   	ret    

80107bad <sys_pipe>:

int
sys_pipe(void)
{
80107bad:	55                   	push   %ebp
80107bae:	89 e5                	mov    %esp,%ebp
80107bb0:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107bb3:	83 ec 04             	sub    $0x4,%esp
80107bb6:	6a 08                	push   $0x8
80107bb8:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107bbb:	50                   	push   %eax
80107bbc:	6a 00                	push   $0x0
80107bbe:	e8 38 f2 ff ff       	call   80106dfb <argptr>
80107bc3:	83 c4 10             	add    $0x10,%esp
80107bc6:	85 c0                	test   %eax,%eax
80107bc8:	79 0a                	jns    80107bd4 <sys_pipe+0x27>
    return -1;
80107bca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bcf:	e9 af 00 00 00       	jmp    80107c83 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107bd4:	83 ec 08             	sub    $0x8,%esp
80107bd7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107bda:	50                   	push   %eax
80107bdb:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107bde:	50                   	push   %eax
80107bdf:	e8 0e c5 ff ff       	call   801040f2 <pipealloc>
80107be4:	83 c4 10             	add    $0x10,%esp
80107be7:	85 c0                	test   %eax,%eax
80107be9:	79 0a                	jns    80107bf5 <sys_pipe+0x48>
    return -1;
80107beb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bf0:	e9 8e 00 00 00       	jmp    80107c83 <sys_pipe+0xd6>
  fd0 = -1;
80107bf5:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107bfc:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107bff:	83 ec 0c             	sub    $0xc,%esp
80107c02:	50                   	push   %eax
80107c03:	e8 7c f3 ff ff       	call   80106f84 <fdalloc>
80107c08:	83 c4 10             	add    $0x10,%esp
80107c0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c12:	78 18                	js     80107c2c <sys_pipe+0x7f>
80107c14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c17:	83 ec 0c             	sub    $0xc,%esp
80107c1a:	50                   	push   %eax
80107c1b:	e8 64 f3 ff ff       	call   80106f84 <fdalloc>
80107c20:	83 c4 10             	add    $0x10,%esp
80107c23:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c26:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c2a:	79 3f                	jns    80107c6b <sys_pipe+0xbe>
    if(fd0 >= 0)
80107c2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c30:	78 14                	js     80107c46 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107c32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c38:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c3b:	83 c2 08             	add    $0x8,%edx
80107c3e:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107c45:	00 
    fileclose(rf);
80107c46:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c49:	83 ec 0c             	sub    $0xc,%esp
80107c4c:	50                   	push   %eax
80107c4d:	e8 b0 94 ff ff       	call   80101102 <fileclose>
80107c52:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107c55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c58:	83 ec 0c             	sub    $0xc,%esp
80107c5b:	50                   	push   %eax
80107c5c:	e8 a1 94 ff ff       	call   80101102 <fileclose>
80107c61:	83 c4 10             	add    $0x10,%esp
    return -1;
80107c64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c69:	eb 18                	jmp    80107c83 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c71:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107c73:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c76:	8d 50 04             	lea    0x4(%eax),%edx
80107c79:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c7c:	89 02                	mov    %eax,(%edx)
  return 0;
80107c7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c83:	c9                   	leave  
80107c84:	c3                   	ret    

80107c85 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107c85:	55                   	push   %ebp
80107c86:	89 e5                	mov    %esp,%ebp
80107c88:	83 ec 08             	sub    $0x8,%esp
80107c8b:	8b 55 08             	mov    0x8(%ebp),%edx
80107c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c91:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107c95:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107c99:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107c9d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107ca1:	66 ef                	out    %ax,(%dx)
}
80107ca3:	90                   	nop
80107ca4:	c9                   	leave  
80107ca5:	c3                   	ret    

80107ca6 <sys_fork>:
#include "uproc.h"
#endif

int
sys_fork(void)
{
80107ca6:	55                   	push   %ebp
80107ca7:	89 e5                	mov    %esp,%ebp
80107ca9:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107cac:	e8 31 cd ff ff       	call   801049e2 <fork>
}
80107cb1:	c9                   	leave  
80107cb2:	c3                   	ret    

80107cb3 <sys_exit>:

int
sys_exit(void)
{
80107cb3:	55                   	push   %ebp
80107cb4:	89 e5                	mov    %esp,%ebp
80107cb6:	83 ec 08             	sub    $0x8,%esp
  exit();
80107cb9:	e8 ae cf ff ff       	call   80104c6c <exit>
  return 0;  // not reached
80107cbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107cc3:	c9                   	leave  
80107cc4:	c3                   	ret    

80107cc5 <sys_wait>:

int
sys_wait(void)
{
80107cc5:	55                   	push   %ebp
80107cc6:	89 e5                	mov    %esp,%ebp
80107cc8:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107ccb:	e8 74 d2 ff ff       	call   80104f44 <wait>
}
80107cd0:	c9                   	leave  
80107cd1:	c3                   	ret    

80107cd2 <sys_kill>:

int
sys_kill(void)
{
80107cd2:	55                   	push   %ebp
80107cd3:	89 e5                	mov    %esp,%ebp
80107cd5:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107cd8:	83 ec 08             	sub    $0x8,%esp
80107cdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107cde:	50                   	push   %eax
80107cdf:	6a 00                	push   $0x0
80107ce1:	e8 ed f0 ff ff       	call   80106dd3 <argint>
80107ce6:	83 c4 10             	add    $0x10,%esp
80107ce9:	85 c0                	test   %eax,%eax
80107ceb:	79 07                	jns    80107cf4 <sys_kill+0x22>
    return -1;
80107ced:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cf2:	eb 0f                	jmp    80107d03 <sys_kill+0x31>
  return kill(pid);
80107cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cf7:	83 ec 0c             	sub    $0xc,%esp
80107cfa:	50                   	push   %eax
80107cfb:	e8 28 db ff ff       	call   80105828 <kill>
80107d00:	83 c4 10             	add    $0x10,%esp
}
80107d03:	c9                   	leave  
80107d04:	c3                   	ret    

80107d05 <sys_getpid>:

int
sys_getpid(void)
{
80107d05:	55                   	push   %ebp
80107d06:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107d08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d0e:	8b 40 10             	mov    0x10(%eax),%eax
}
80107d11:	5d                   	pop    %ebp
80107d12:	c3                   	ret    

80107d13 <sys_sbrk>:

int
sys_sbrk(void)
{
80107d13:	55                   	push   %ebp
80107d14:	89 e5                	mov    %esp,%ebp
80107d16:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107d19:	83 ec 08             	sub    $0x8,%esp
80107d1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d1f:	50                   	push   %eax
80107d20:	6a 00                	push   $0x0
80107d22:	e8 ac f0 ff ff       	call   80106dd3 <argint>
80107d27:	83 c4 10             	add    $0x10,%esp
80107d2a:	85 c0                	test   %eax,%eax
80107d2c:	79 07                	jns    80107d35 <sys_sbrk+0x22>
    return -1;
80107d2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d33:	eb 28                	jmp    80107d5d <sys_sbrk+0x4a>
  addr = proc->sz;
80107d35:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d3b:	8b 00                	mov    (%eax),%eax
80107d3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d43:	83 ec 0c             	sub    $0xc,%esp
80107d46:	50                   	push   %eax
80107d47:	e8 f3 cb ff ff       	call   8010493f <growproc>
80107d4c:	83 c4 10             	add    $0x10,%esp
80107d4f:	85 c0                	test   %eax,%eax
80107d51:	79 07                	jns    80107d5a <sys_sbrk+0x47>
    return -1;
80107d53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d58:	eb 03                	jmp    80107d5d <sys_sbrk+0x4a>
  return addr;
80107d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107d5d:	c9                   	leave  
80107d5e:	c3                   	ret    

80107d5f <sys_sleep>:

int
sys_sleep(void)
{
80107d5f:	55                   	push   %ebp
80107d60:	89 e5                	mov    %esp,%ebp
80107d62:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107d65:	83 ec 08             	sub    $0x8,%esp
80107d68:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d6b:	50                   	push   %eax
80107d6c:	6a 00                	push   $0x0
80107d6e:	e8 60 f0 ff ff       	call   80106dd3 <argint>
80107d73:	83 c4 10             	add    $0x10,%esp
80107d76:	85 c0                	test   %eax,%eax
80107d78:	79 07                	jns    80107d81 <sys_sleep+0x22>
    return -1;
80107d7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d7f:	eb 44                	jmp    80107dc5 <sys_sleep+0x66>
  ticks0 = ticks;
80107d81:	a1 e0 78 11 80       	mov    0x801178e0,%eax
80107d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80107d89:	eb 26                	jmp    80107db1 <sys_sleep+0x52>
    if(proc->killed){
80107d8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d91:	8b 40 24             	mov    0x24(%eax),%eax
80107d94:	85 c0                	test   %eax,%eax
80107d96:	74 07                	je     80107d9f <sys_sleep+0x40>
      return -1;
80107d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d9d:	eb 26                	jmp    80107dc5 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107d9f:	83 ec 08             	sub    $0x8,%esp
80107da2:	6a 00                	push   $0x0
80107da4:	68 e0 78 11 80       	push   $0x801178e0
80107da9:	e8 e8 d7 ff ff       	call   80105596 <sleep>
80107dae:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107db1:	a1 e0 78 11 80       	mov    0x801178e0,%eax
80107db6:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107db9:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107dbc:	39 d0                	cmp    %edx,%eax
80107dbe:	72 cb                	jb     80107d8b <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107dc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107dc5:	c9                   	leave  
80107dc6:	c3                   	ret    

80107dc7 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80107dc7:	55                   	push   %ebp
80107dc8:	89 e5                	mov    %esp,%ebp
80107dca:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107dcd:	a1 e0 78 11 80       	mov    0x801178e0,%eax
80107dd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80107dd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107dd8:	c9                   	leave  
80107dd9:	c3                   	ret    

80107dda <sys_halt>:

//Turn of the computer
int
sys_halt(void){
80107dda:	55                   	push   %ebp
80107ddb:	89 e5                	mov    %esp,%ebp
80107ddd:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107de0:	83 ec 0c             	sub    $0xc,%esp
80107de3:	68 39 ab 10 80       	push   $0x8010ab39
80107de8:	e8 d9 85 ff ff       	call   801003c6 <cprintf>
80107ded:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
80107df0:	83 ec 08             	sub    $0x8,%esp
80107df3:	68 00 20 00 00       	push   $0x2000
80107df8:	68 04 06 00 00       	push   $0x604
80107dfd:	e8 83 fe ff ff       	call   80107c85 <outw>
80107e02:	83 c4 10             	add    $0x10,%esp
  return 0;
80107e05:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e0a:	c9                   	leave  
80107e0b:	c3                   	ret    

80107e0c <sys_date>:

#ifdef CS333_P1
int
sys_date(void) {
80107e0c:	55                   	push   %ebp
80107e0d:	89 e5                	mov    %esp,%ebp
80107e0f:	83 ec 18             	sub    $0x18,%esp
    struct rtcdate *d;
    if (argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0) {
80107e12:	83 ec 04             	sub    $0x4,%esp
80107e15:	6a 18                	push   $0x18
80107e17:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107e1a:	50                   	push   %eax
80107e1b:	6a 00                	push   $0x0
80107e1d:	e8 d9 ef ff ff       	call   80106dfb <argptr>
80107e22:	83 c4 10             	add    $0x10,%esp
80107e25:	85 c0                	test   %eax,%eax
80107e27:	79 07                	jns    80107e30 <sys_date+0x24>
        return -1;
80107e29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e2e:	eb 14                	jmp    80107e44 <sys_date+0x38>
    } else {
        cmostime(d);
80107e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e33:	83 ec 0c             	sub    $0xc,%esp
80107e36:	50                   	push   %eax
80107e37:	e8 3d b4 ff ff       	call   80103279 <cmostime>
80107e3c:	83 c4 10             	add    $0x10,%esp
        return 0;
80107e3f:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
80107e44:	c9                   	leave  
80107e45:	c3                   	ret    

80107e46 <sys_getuid>:

#ifdef CS333_P2

// return process UID
int
sys_getuid(void) {
80107e46:	55                   	push   %ebp
80107e47:	89 e5                	mov    %esp,%ebp
    return proc->uid;
80107e49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e4f:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80107e55:	5d                   	pop    %ebp
80107e56:	c3                   	ret    

80107e57 <sys_getgid>:

// return process GID
int
sys_getgid(void) {
80107e57:	55                   	push   %ebp
80107e58:	89 e5                	mov    %esp,%ebp
    return proc->gid;
80107e5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e60:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80107e66:	5d                   	pop    %ebp
80107e67:	c3                   	ret    

80107e68 <sys_getppid>:

// return process parent's PID
int
sys_getppid(void) {
80107e68:	55                   	push   %ebp
80107e69:	89 e5                	mov    %esp,%ebp
    return proc->parent->pid;
80107e6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e71:	8b 40 14             	mov    0x14(%eax),%eax
80107e74:	8b 40 10             	mov    0x10(%eax),%eax
}
80107e77:	5d                   	pop    %ebp
80107e78:	c3                   	ret    

80107e79 <sys_setuid>:

// pull argument from stack, check range, set process UID
int
sys_setuid(void) {
80107e79:	55                   	push   %ebp
80107e7a:	89 e5                	mov    %esp,%ebp
80107e7c:	83 ec 18             	sub    $0x18,%esp
    int n;
    if (argint(0, &n) < 0) {
80107e7f:	83 ec 08             	sub    $0x8,%esp
80107e82:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107e85:	50                   	push   %eax
80107e86:	6a 00                	push   $0x0
80107e88:	e8 46 ef ff ff       	call   80106dd3 <argint>
80107e8d:	83 c4 10             	add    $0x10,%esp
80107e90:	85 c0                	test   %eax,%eax
80107e92:	79 07                	jns    80107e9b <sys_setuid+0x22>
        return -1;
80107e94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e99:	eb 2c                	jmp    80107ec7 <sys_setuid+0x4e>
    }
    if (n < 0 || n > 32767) {
80107e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e9e:	85 c0                	test   %eax,%eax
80107ea0:	78 0a                	js     80107eac <sys_setuid+0x33>
80107ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea5:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107eaa:	7e 07                	jle    80107eb3 <sys_setuid+0x3a>
        return -1;
80107eac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107eb1:	eb 14                	jmp    80107ec7 <sys_setuid+0x4e>
    }
    proc->uid = n;
80107eb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107eb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107ebc:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    return 0;
80107ec2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ec7:	c9                   	leave  
80107ec8:	c3                   	ret    

80107ec9 <sys_setgid>:

// pull argument from stack, check range, set process PID
int
sys_setgid(void) {
80107ec9:	55                   	push   %ebp
80107eca:	89 e5                	mov    %esp,%ebp
80107ecc:	83 ec 18             	sub    $0x18,%esp
    int n;
    if (argint(0, &n) < 0) {
80107ecf:	83 ec 08             	sub    $0x8,%esp
80107ed2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107ed5:	50                   	push   %eax
80107ed6:	6a 00                	push   $0x0
80107ed8:	e8 f6 ee ff ff       	call   80106dd3 <argint>
80107edd:	83 c4 10             	add    $0x10,%esp
80107ee0:	85 c0                	test   %eax,%eax
80107ee2:	79 07                	jns    80107eeb <sys_setgid+0x22>
        return -1;
80107ee4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ee9:	eb 2c                	jmp    80107f17 <sys_setgid+0x4e>
    }
    if (n < 0 || n > 32767) {
80107eeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107eee:	85 c0                	test   %eax,%eax
80107ef0:	78 0a                	js     80107efc <sys_setgid+0x33>
80107ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef5:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107efa:	7e 07                	jle    80107f03 <sys_setgid+0x3a>
        return -1;
80107efc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f01:	eb 14                	jmp    80107f17 <sys_setgid+0x4e>
    }
    proc->gid = n;
80107f03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107f0c:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    return 0;
80107f12:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f17:	c9                   	leave  
80107f18:	c3                   	ret    

80107f19 <sys_getprocs>:

// pull arguments from stack, pass to proc.c getprocs(uint, struct)
int
sys_getprocs(void) {
80107f19:	55                   	push   %ebp
80107f1a:	89 e5                	mov    %esp,%ebp
80107f1c:	83 ec 18             	sub    $0x18,%esp
    int n;
    struct uproc *u;
    if (argint(0, &n) < 0) {
80107f1f:	83 ec 08             	sub    $0x8,%esp
80107f22:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f25:	50                   	push   %eax
80107f26:	6a 00                	push   $0x0
80107f28:	e8 a6 ee ff ff       	call   80106dd3 <argint>
80107f2d:	83 c4 10             	add    $0x10,%esp
80107f30:	85 c0                	test   %eax,%eax
80107f32:	79 07                	jns    80107f3b <sys_getprocs+0x22>
        return -1;
80107f34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f39:	eb 3e                	jmp    80107f79 <sys_getprocs+0x60>
    }
    // sizeof * MAX
    if (argptr(1, (void*)&u, (sizeof(struct uproc) * n)) < 0) {
80107f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3e:	89 c2                	mov    %eax,%edx
80107f40:	89 d0                	mov    %edx,%eax
80107f42:	01 c0                	add    %eax,%eax
80107f44:	01 d0                	add    %edx,%eax
80107f46:	c1 e0 05             	shl    $0x5,%eax
80107f49:	83 ec 04             	sub    $0x4,%esp
80107f4c:	50                   	push   %eax
80107f4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107f50:	50                   	push   %eax
80107f51:	6a 01                	push   $0x1
80107f53:	e8 a3 ee ff ff       	call   80106dfb <argptr>
80107f58:	83 c4 10             	add    $0x10,%esp
80107f5b:	85 c0                	test   %eax,%eax
80107f5d:	79 07                	jns    80107f66 <sys_getprocs+0x4d>
        return -1;
80107f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f64:	eb 13                	jmp    80107f79 <sys_getprocs+0x60>
    }
    return getprocs(n, u);
80107f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f69:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107f6c:	83 ec 08             	sub    $0x8,%esp
80107f6f:	50                   	push   %eax
80107f70:	52                   	push   %edx
80107f71:	e8 d4 dd ff ff       	call   80105d4a <getprocs>
80107f76:	83 c4 10             	add    $0x10,%esp
}
80107f79:	c9                   	leave  
80107f7a:	c3                   	ret    

80107f7b <sys_setpriority>:
#endif

#ifdef CS333_P3P4
int
sys_setpriority(void) {
80107f7b:	55                   	push   %ebp
80107f7c:	89 e5                	mov    %esp,%ebp
80107f7e:	83 ec 18             	sub    $0x18,%esp
    int n, i;
    // PID argument from stack
    if (argint(0, &n) < 0) {
80107f81:	83 ec 08             	sub    $0x8,%esp
80107f84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f87:	50                   	push   %eax
80107f88:	6a 00                	push   $0x0
80107f8a:	e8 44 ee ff ff       	call   80106dd3 <argint>
80107f8f:	83 c4 10             	add    $0x10,%esp
80107f92:	85 c0                	test   %eax,%eax
80107f94:	79 07                	jns    80107f9d <sys_setpriority+0x22>
        return -1;
80107f96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f9b:	eb 5d                	jmp    80107ffa <sys_setpriority+0x7f>
    }
    // priority argument
    if (argint(1, &i) < 0) {
80107f9d:	83 ec 08             	sub    $0x8,%esp
80107fa0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107fa3:	50                   	push   %eax
80107fa4:	6a 01                	push   $0x1
80107fa6:	e8 28 ee ff ff       	call   80106dd3 <argint>
80107fab:	83 c4 10             	add    $0x10,%esp
80107fae:	85 c0                	test   %eax,%eax
80107fb0:	79 07                	jns    80107fb9 <sys_setpriority+0x3e>
        return -1;
80107fb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fb7:	eb 41                	jmp    80107ffa <sys_setpriority+0x7f>
    }
    // check bounds of PID argument
    if (n < 0 || n > 32767) {
80107fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbc:	85 c0                	test   %eax,%eax
80107fbe:	78 0a                	js     80107fca <sys_setpriority+0x4f>
80107fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc3:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107fc8:	7e 07                	jle    80107fd1 <sys_setpriority+0x56>
        return -1;
80107fca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fcf:	eb 29                	jmp    80107ffa <sys_setpriority+0x7f>
    }
    // check bounds of priority argument
    if (i < 0 || i > MAX) {
80107fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fd4:	85 c0                	test   %eax,%eax
80107fd6:	78 08                	js     80107fe0 <sys_setpriority+0x65>
80107fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fdb:	83 f8 02             	cmp    $0x2,%eax
80107fde:	7e 07                	jle    80107fe7 <sys_setpriority+0x6c>
        return -1;
80107fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fe5:	eb 13                	jmp    80107ffa <sys_setpriority+0x7f>
    }
    return setpriority(n, i); // pass to user-side
80107fe7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fed:	83 ec 08             	sub    $0x8,%esp
80107ff0:	52                   	push   %edx
80107ff1:	50                   	push   %eax
80107ff2:	e8 01 e6 ff ff       	call   801065f8 <setpriority>
80107ff7:	83 c4 10             	add    $0x10,%esp
}
80107ffa:	c9                   	leave  
80107ffb:	c3                   	ret    

80107ffc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107ffc:	55                   	push   %ebp
80107ffd:	89 e5                	mov    %esp,%ebp
80107fff:	83 ec 08             	sub    $0x8,%esp
80108002:	8b 55 08             	mov    0x8(%ebp),%edx
80108005:	8b 45 0c             	mov    0xc(%ebp),%eax
80108008:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010800c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010800f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108013:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108017:	ee                   	out    %al,(%dx)
}
80108018:	90                   	nop
80108019:	c9                   	leave  
8010801a:	c3                   	ret    

8010801b <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010801b:	55                   	push   %ebp
8010801c:	89 e5                	mov    %esp,%ebp
8010801e:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80108021:	6a 34                	push   $0x34
80108023:	6a 43                	push   $0x43
80108025:	e8 d2 ff ff ff       	call   80107ffc <outb>
8010802a:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
8010802d:	68 a9 00 00 00       	push   $0xa9
80108032:	6a 40                	push   $0x40
80108034:	e8 c3 ff ff ff       	call   80107ffc <outb>
80108039:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
8010803c:	6a 04                	push   $0x4
8010803e:	6a 40                	push   $0x40
80108040:	e8 b7 ff ff ff       	call   80107ffc <outb>
80108045:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
80108048:	83 ec 0c             	sub    $0xc,%esp
8010804b:	6a 00                	push   $0x0
8010804d:	e8 8a bf ff ff       	call   80103fdc <picenable>
80108052:	83 c4 10             	add    $0x10,%esp
}
80108055:	90                   	nop
80108056:	c9                   	leave  
80108057:	c3                   	ret    

80108058 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80108058:	1e                   	push   %ds
  pushl %es
80108059:	06                   	push   %es
  pushl %fs
8010805a:	0f a0                	push   %fs
  pushl %gs
8010805c:	0f a8                	push   %gs
  pushal
8010805e:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
8010805f:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80108063:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80108065:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80108067:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010806b:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
8010806d:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
8010806f:	54                   	push   %esp
  call trap
80108070:	e8 ce 01 00 00       	call   80108243 <trap>
  addl $4, %esp
80108075:	83 c4 04             	add    $0x4,%esp

80108078 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80108078:	61                   	popa   
  popl %gs
80108079:	0f a9                	pop    %gs
  popl %fs
8010807b:	0f a1                	pop    %fs
  popl %es
8010807d:	07                   	pop    %es
  popl %ds
8010807e:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010807f:	83 c4 08             	add    $0x8,%esp
  iret
80108082:	cf                   	iret   

80108083 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80108083:	55                   	push   %ebp
80108084:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80108086:	8b 45 08             	mov    0x8(%ebp),%eax
80108089:	f0 ff 00             	lock incl (%eax)
}
8010808c:	90                   	nop
8010808d:	5d                   	pop    %ebp
8010808e:	c3                   	ret    

8010808f <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010808f:	55                   	push   %ebp
80108090:	89 e5                	mov    %esp,%ebp
80108092:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108095:	8b 45 0c             	mov    0xc(%ebp),%eax
80108098:	83 e8 01             	sub    $0x1,%eax
8010809b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010809f:	8b 45 08             	mov    0x8(%ebp),%eax
801080a2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801080a6:	8b 45 08             	mov    0x8(%ebp),%eax
801080a9:	c1 e8 10             	shr    $0x10,%eax
801080ac:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801080b0:	8d 45 fa             	lea    -0x6(%ebp),%eax
801080b3:	0f 01 18             	lidtl  (%eax)
}
801080b6:	90                   	nop
801080b7:	c9                   	leave  
801080b8:	c3                   	ret    

801080b9 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
801080b9:	55                   	push   %ebp
801080ba:	89 e5                	mov    %esp,%ebp
801080bc:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801080bf:	0f 20 d0             	mov    %cr2,%eax
801080c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
801080c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801080c8:	c9                   	leave  
801080c9:	c3                   	ret    

801080ca <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
801080ca:	55                   	push   %ebp
801080cb:	89 e5                	mov    %esp,%ebp
801080cd:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
801080d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801080d7:	e9 c3 00 00 00       	jmp    8010819f <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801080dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080df:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
801080e6:	89 c2                	mov    %eax,%edx
801080e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080eb:	66 89 14 c5 e0 70 11 	mov    %dx,-0x7fee8f20(,%eax,8)
801080f2:	80 
801080f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801080f6:	66 c7 04 c5 e2 70 11 	movw   $0x8,-0x7fee8f1e(,%eax,8)
801080fd:	80 08 00 
80108100:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108103:	0f b6 14 c5 e4 70 11 	movzbl -0x7fee8f1c(,%eax,8),%edx
8010810a:	80 
8010810b:	83 e2 e0             	and    $0xffffffe0,%edx
8010810e:	88 14 c5 e4 70 11 80 	mov    %dl,-0x7fee8f1c(,%eax,8)
80108115:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108118:	0f b6 14 c5 e4 70 11 	movzbl -0x7fee8f1c(,%eax,8),%edx
8010811f:	80 
80108120:	83 e2 1f             	and    $0x1f,%edx
80108123:	88 14 c5 e4 70 11 80 	mov    %dl,-0x7fee8f1c(,%eax,8)
8010812a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010812d:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80108134:	80 
80108135:	83 e2 f0             	and    $0xfffffff0,%edx
80108138:	83 ca 0e             	or     $0xe,%edx
8010813b:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80108142:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108145:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
8010814c:	80 
8010814d:	83 e2 ef             	and    $0xffffffef,%edx
80108150:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80108157:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010815a:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80108161:	80 
80108162:	83 e2 9f             	and    $0xffffff9f,%edx
80108165:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
8010816c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010816f:	0f b6 14 c5 e5 70 11 	movzbl -0x7fee8f1b(,%eax,8),%edx
80108176:	80 
80108177:	83 ca 80             	or     $0xffffff80,%edx
8010817a:	88 14 c5 e5 70 11 80 	mov    %dl,-0x7fee8f1b(,%eax,8)
80108181:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108184:	8b 04 85 bc d0 10 80 	mov    -0x7fef2f44(,%eax,4),%eax
8010818b:	c1 e8 10             	shr    $0x10,%eax
8010818e:	89 c2                	mov    %eax,%edx
80108190:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108193:	66 89 14 c5 e6 70 11 	mov    %dx,-0x7fee8f1a(,%eax,8)
8010819a:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010819b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010819f:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
801081a6:	0f 8e 30 ff ff ff    	jle    801080dc <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801081ac:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
801081b1:	66 a3 e0 72 11 80    	mov    %ax,0x801172e0
801081b7:	66 c7 05 e2 72 11 80 	movw   $0x8,0x801172e2
801081be:	08 00 
801081c0:	0f b6 05 e4 72 11 80 	movzbl 0x801172e4,%eax
801081c7:	83 e0 e0             	and    $0xffffffe0,%eax
801081ca:	a2 e4 72 11 80       	mov    %al,0x801172e4
801081cf:	0f b6 05 e4 72 11 80 	movzbl 0x801172e4,%eax
801081d6:	83 e0 1f             	and    $0x1f,%eax
801081d9:	a2 e4 72 11 80       	mov    %al,0x801172e4
801081de:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
801081e5:	83 c8 0f             	or     $0xf,%eax
801081e8:	a2 e5 72 11 80       	mov    %al,0x801172e5
801081ed:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
801081f4:	83 e0 ef             	and    $0xffffffef,%eax
801081f7:	a2 e5 72 11 80       	mov    %al,0x801172e5
801081fc:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80108203:	83 c8 60             	or     $0x60,%eax
80108206:	a2 e5 72 11 80       	mov    %al,0x801172e5
8010820b:	0f b6 05 e5 72 11 80 	movzbl 0x801172e5,%eax
80108212:	83 c8 80             	or     $0xffffff80,%eax
80108215:	a2 e5 72 11 80       	mov    %al,0x801172e5
8010821a:	a1 bc d1 10 80       	mov    0x8010d1bc,%eax
8010821f:	c1 e8 10             	shr    $0x10,%eax
80108222:	66 a3 e6 72 11 80    	mov    %ax,0x801172e6
  
}
80108228:	90                   	nop
80108229:	c9                   	leave  
8010822a:	c3                   	ret    

8010822b <idtinit>:

void
idtinit(void)
{
8010822b:	55                   	push   %ebp
8010822c:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010822e:	68 00 08 00 00       	push   $0x800
80108233:	68 e0 70 11 80       	push   $0x801170e0
80108238:	e8 52 fe ff ff       	call   8010808f <lidt>
8010823d:	83 c4 08             	add    $0x8,%esp
}
80108240:	90                   	nop
80108241:	c9                   	leave  
80108242:	c3                   	ret    

80108243 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80108243:	55                   	push   %ebp
80108244:	89 e5                	mov    %esp,%ebp
80108246:	57                   	push   %edi
80108247:	56                   	push   %esi
80108248:	53                   	push   %ebx
80108249:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010824c:	8b 45 08             	mov    0x8(%ebp),%eax
8010824f:	8b 40 30             	mov    0x30(%eax),%eax
80108252:	83 f8 40             	cmp    $0x40,%eax
80108255:	75 3e                	jne    80108295 <trap+0x52>
    if(proc->killed)
80108257:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010825d:	8b 40 24             	mov    0x24(%eax),%eax
80108260:	85 c0                	test   %eax,%eax
80108262:	74 05                	je     80108269 <trap+0x26>
      exit();
80108264:	e8 03 ca ff ff       	call   80104c6c <exit>
    proc->tf = tf;
80108269:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010826f:	8b 55 08             	mov    0x8(%ebp),%edx
80108272:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80108275:	e8 0f ec ff ff       	call   80106e89 <syscall>
    if(proc->killed)
8010827a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108280:	8b 40 24             	mov    0x24(%eax),%eax
80108283:	85 c0                	test   %eax,%eax
80108285:	0f 84 21 02 00 00    	je     801084ac <trap+0x269>
      exit();
8010828b:	e8 dc c9 ff ff       	call   80104c6c <exit>
    return;
80108290:	e9 17 02 00 00       	jmp    801084ac <trap+0x269>
  }

  switch(tf->trapno){
80108295:	8b 45 08             	mov    0x8(%ebp),%eax
80108298:	8b 40 30             	mov    0x30(%eax),%eax
8010829b:	83 e8 20             	sub    $0x20,%eax
8010829e:	83 f8 1f             	cmp    $0x1f,%eax
801082a1:	0f 87 a3 00 00 00    	ja     8010834a <trap+0x107>
801082a7:	8b 04 85 ec ab 10 80 	mov    -0x7fef5414(,%eax,4),%eax
801082ae:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
801082b0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801082b6:	0f b6 00             	movzbl (%eax),%eax
801082b9:	84 c0                	test   %al,%al
801082bb:	75 20                	jne    801082dd <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
801082bd:	83 ec 0c             	sub    $0xc,%esp
801082c0:	68 e0 78 11 80       	push   $0x801178e0
801082c5:	e8 b9 fd ff ff       	call   80108083 <atom_inc>
801082ca:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
801082cd:	83 ec 0c             	sub    $0xc,%esp
801082d0:	68 e0 78 11 80       	push   $0x801178e0
801082d5:	e8 17 d5 ff ff       	call   801057f1 <wakeup>
801082da:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801082dd:	e8 f4 ad ff ff       	call   801030d6 <lapiceoi>
    break;
801082e2:	e9 1c 01 00 00       	jmp    80108403 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801082e7:	e8 fd a5 ff ff       	call   801028e9 <ideintr>
    lapiceoi();
801082ec:	e8 e5 ad ff ff       	call   801030d6 <lapiceoi>
    break;
801082f1:	e9 0d 01 00 00       	jmp    80108403 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801082f6:	e8 dd ab ff ff       	call   80102ed8 <kbdintr>
    lapiceoi();
801082fb:	e8 d6 ad ff ff       	call   801030d6 <lapiceoi>
    break;
80108300:	e9 fe 00 00 00       	jmp    80108403 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80108305:	e8 83 03 00 00       	call   8010868d <uartintr>
    lapiceoi();
8010830a:	e8 c7 ad ff ff       	call   801030d6 <lapiceoi>
    break;
8010830f:	e9 ef 00 00 00       	jmp    80108403 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108314:	8b 45 08             	mov    0x8(%ebp),%eax
80108317:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
8010831a:	8b 45 08             	mov    0x8(%ebp),%eax
8010831d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108321:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80108324:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010832a:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010832d:	0f b6 c0             	movzbl %al,%eax
80108330:	51                   	push   %ecx
80108331:	52                   	push   %edx
80108332:	50                   	push   %eax
80108333:	68 4c ab 10 80       	push   $0x8010ab4c
80108338:	e8 89 80 ff ff       	call   801003c6 <cprintf>
8010833d:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80108340:	e8 91 ad ff ff       	call   801030d6 <lapiceoi>
    break;
80108345:	e9 b9 00 00 00       	jmp    80108403 <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010834a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108350:	85 c0                	test   %eax,%eax
80108352:	74 11                	je     80108365 <trap+0x122>
80108354:	8b 45 08             	mov    0x8(%ebp),%eax
80108357:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010835b:	0f b7 c0             	movzwl %ax,%eax
8010835e:	83 e0 03             	and    $0x3,%eax
80108361:	85 c0                	test   %eax,%eax
80108363:	75 40                	jne    801083a5 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80108365:	e8 4f fd ff ff       	call   801080b9 <rcr2>
8010836a:	89 c3                	mov    %eax,%ebx
8010836c:	8b 45 08             	mov    0x8(%ebp),%eax
8010836f:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80108372:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108378:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010837b:	0f b6 d0             	movzbl %al,%edx
8010837e:	8b 45 08             	mov    0x8(%ebp),%eax
80108381:	8b 40 30             	mov    0x30(%eax),%eax
80108384:	83 ec 0c             	sub    $0xc,%esp
80108387:	53                   	push   %ebx
80108388:	51                   	push   %ecx
80108389:	52                   	push   %edx
8010838a:	50                   	push   %eax
8010838b:	68 70 ab 10 80       	push   $0x8010ab70
80108390:	e8 31 80 ff ff       	call   801003c6 <cprintf>
80108395:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80108398:	83 ec 0c             	sub    $0xc,%esp
8010839b:	68 a2 ab 10 80       	push   $0x8010aba2
801083a0:	e8 c1 81 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801083a5:	e8 0f fd ff ff       	call   801080b9 <rcr2>
801083aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801083ad:	8b 45 08             	mov    0x8(%ebp),%eax
801083b0:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801083b3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801083b9:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801083bc:	0f b6 d8             	movzbl %al,%ebx
801083bf:	8b 45 08             	mov    0x8(%ebp),%eax
801083c2:	8b 48 34             	mov    0x34(%eax),%ecx
801083c5:	8b 45 08             	mov    0x8(%ebp),%eax
801083c8:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801083cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083d1:	8d 78 6c             	lea    0x6c(%eax),%edi
801083d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801083da:	8b 40 10             	mov    0x10(%eax),%eax
801083dd:	ff 75 e4             	pushl  -0x1c(%ebp)
801083e0:	56                   	push   %esi
801083e1:	53                   	push   %ebx
801083e2:	51                   	push   %ecx
801083e3:	52                   	push   %edx
801083e4:	57                   	push   %edi
801083e5:	50                   	push   %eax
801083e6:	68 a8 ab 10 80       	push   $0x8010aba8
801083eb:	e8 d6 7f ff ff       	call   801003c6 <cprintf>
801083f0:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801083f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083f9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80108400:	eb 01                	jmp    80108403 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80108402:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80108403:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108409:	85 c0                	test   %eax,%eax
8010840b:	74 24                	je     80108431 <trap+0x1ee>
8010840d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108413:	8b 40 24             	mov    0x24(%eax),%eax
80108416:	85 c0                	test   %eax,%eax
80108418:	74 17                	je     80108431 <trap+0x1ee>
8010841a:	8b 45 08             	mov    0x8(%ebp),%eax
8010841d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108421:	0f b7 c0             	movzwl %ax,%eax
80108424:	83 e0 03             	and    $0x3,%eax
80108427:	83 f8 03             	cmp    $0x3,%eax
8010842a:	75 05                	jne    80108431 <trap+0x1ee>
    exit();
8010842c:	e8 3b c8 ff ff       	call   80104c6c <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80108431:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108437:	85 c0                	test   %eax,%eax
80108439:	74 41                	je     8010847c <trap+0x239>
8010843b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108441:	8b 40 0c             	mov    0xc(%eax),%eax
80108444:	83 f8 04             	cmp    $0x4,%eax
80108447:	75 33                	jne    8010847c <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80108449:	8b 45 08             	mov    0x8(%ebp),%eax
8010844c:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
8010844f:	83 f8 20             	cmp    $0x20,%eax
80108452:	75 28                	jne    8010847c <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80108454:	8b 0d e0 78 11 80    	mov    0x801178e0,%ecx
8010845a:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
8010845f:	89 c8                	mov    %ecx,%eax
80108461:	f7 e2                	mul    %edx
80108463:	c1 ea 03             	shr    $0x3,%edx
80108466:	89 d0                	mov    %edx,%eax
80108468:	c1 e0 02             	shl    $0x2,%eax
8010846b:	01 d0                	add    %edx,%eax
8010846d:	01 c0                	add    %eax,%eax
8010846f:	29 c1                	sub    %eax,%ecx
80108471:	89 ca                	mov    %ecx,%edx
80108473:	85 d2                	test   %edx,%edx
80108475:	75 05                	jne    8010847c <trap+0x239>
    yield();
80108477:	e8 96 cf ff ff       	call   80105412 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010847c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108482:	85 c0                	test   %eax,%eax
80108484:	74 27                	je     801084ad <trap+0x26a>
80108486:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010848c:	8b 40 24             	mov    0x24(%eax),%eax
8010848f:	85 c0                	test   %eax,%eax
80108491:	74 1a                	je     801084ad <trap+0x26a>
80108493:	8b 45 08             	mov    0x8(%ebp),%eax
80108496:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010849a:	0f b7 c0             	movzwl %ax,%eax
8010849d:	83 e0 03             	and    $0x3,%eax
801084a0:	83 f8 03             	cmp    $0x3,%eax
801084a3:	75 08                	jne    801084ad <trap+0x26a>
    exit();
801084a5:	e8 c2 c7 ff ff       	call   80104c6c <exit>
801084aa:	eb 01                	jmp    801084ad <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801084ac:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801084ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801084b0:	5b                   	pop    %ebx
801084b1:	5e                   	pop    %esi
801084b2:	5f                   	pop    %edi
801084b3:	5d                   	pop    %ebp
801084b4:	c3                   	ret    

801084b5 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801084b5:	55                   	push   %ebp
801084b6:	89 e5                	mov    %esp,%ebp
801084b8:	83 ec 14             	sub    $0x14,%esp
801084bb:	8b 45 08             	mov    0x8(%ebp),%eax
801084be:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801084c2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801084c6:	89 c2                	mov    %eax,%edx
801084c8:	ec                   	in     (%dx),%al
801084c9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801084cc:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801084d0:	c9                   	leave  
801084d1:	c3                   	ret    

801084d2 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801084d2:	55                   	push   %ebp
801084d3:	89 e5                	mov    %esp,%ebp
801084d5:	83 ec 08             	sub    $0x8,%esp
801084d8:	8b 55 08             	mov    0x8(%ebp),%edx
801084db:	8b 45 0c             	mov    0xc(%ebp),%eax
801084de:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801084e2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801084e5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801084e9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801084ed:	ee                   	out    %al,(%dx)
}
801084ee:	90                   	nop
801084ef:	c9                   	leave  
801084f0:	c3                   	ret    

801084f1 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801084f1:	55                   	push   %ebp
801084f2:	89 e5                	mov    %esp,%ebp
801084f4:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801084f7:	6a 00                	push   $0x0
801084f9:	68 fa 03 00 00       	push   $0x3fa
801084fe:	e8 cf ff ff ff       	call   801084d2 <outb>
80108503:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80108506:	68 80 00 00 00       	push   $0x80
8010850b:	68 fb 03 00 00       	push   $0x3fb
80108510:	e8 bd ff ff ff       	call   801084d2 <outb>
80108515:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80108518:	6a 0c                	push   $0xc
8010851a:	68 f8 03 00 00       	push   $0x3f8
8010851f:	e8 ae ff ff ff       	call   801084d2 <outb>
80108524:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80108527:	6a 00                	push   $0x0
80108529:	68 f9 03 00 00       	push   $0x3f9
8010852e:	e8 9f ff ff ff       	call   801084d2 <outb>
80108533:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80108536:	6a 03                	push   $0x3
80108538:	68 fb 03 00 00       	push   $0x3fb
8010853d:	e8 90 ff ff ff       	call   801084d2 <outb>
80108542:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80108545:	6a 00                	push   $0x0
80108547:	68 fc 03 00 00       	push   $0x3fc
8010854c:	e8 81 ff ff ff       	call   801084d2 <outb>
80108551:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80108554:	6a 01                	push   $0x1
80108556:	68 f9 03 00 00       	push   $0x3f9
8010855b:	e8 72 ff ff ff       	call   801084d2 <outb>
80108560:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80108563:	68 fd 03 00 00       	push   $0x3fd
80108568:	e8 48 ff ff ff       	call   801084b5 <inb>
8010856d:	83 c4 04             	add    $0x4,%esp
80108570:	3c ff                	cmp    $0xff,%al
80108572:	74 6e                	je     801085e2 <uartinit+0xf1>
    return;
  uart = 1;
80108574:	c7 05 6c d6 10 80 01 	movl   $0x1,0x8010d66c
8010857b:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010857e:	68 fa 03 00 00       	push   $0x3fa
80108583:	e8 2d ff ff ff       	call   801084b5 <inb>
80108588:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010858b:	68 f8 03 00 00       	push   $0x3f8
80108590:	e8 20 ff ff ff       	call   801084b5 <inb>
80108595:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80108598:	83 ec 0c             	sub    $0xc,%esp
8010859b:	6a 04                	push   $0x4
8010859d:	e8 3a ba ff ff       	call   80103fdc <picenable>
801085a2:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801085a5:	83 ec 08             	sub    $0x8,%esp
801085a8:	6a 00                	push   $0x0
801085aa:	6a 04                	push   $0x4
801085ac:	e8 da a5 ff ff       	call   80102b8b <ioapicenable>
801085b1:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801085b4:	c7 45 f4 6c ac 10 80 	movl   $0x8010ac6c,-0xc(%ebp)
801085bb:	eb 19                	jmp    801085d6 <uartinit+0xe5>
    uartputc(*p);
801085bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085c0:	0f b6 00             	movzbl (%eax),%eax
801085c3:	0f be c0             	movsbl %al,%eax
801085c6:	83 ec 0c             	sub    $0xc,%esp
801085c9:	50                   	push   %eax
801085ca:	e8 16 00 00 00       	call   801085e5 <uartputc>
801085cf:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801085d2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801085d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085d9:	0f b6 00             	movzbl (%eax),%eax
801085dc:	84 c0                	test   %al,%al
801085de:	75 dd                	jne    801085bd <uartinit+0xcc>
801085e0:	eb 01                	jmp    801085e3 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801085e2:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
801085e3:	c9                   	leave  
801085e4:	c3                   	ret    

801085e5 <uartputc>:

void
uartputc(int c)
{
801085e5:	55                   	push   %ebp
801085e6:	89 e5                	mov    %esp,%ebp
801085e8:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801085eb:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
801085f0:	85 c0                	test   %eax,%eax
801085f2:	74 53                	je     80108647 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801085f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801085fb:	eb 11                	jmp    8010860e <uartputc+0x29>
    microdelay(10);
801085fd:	83 ec 0c             	sub    $0xc,%esp
80108600:	6a 0a                	push   $0xa
80108602:	e8 ea aa ff ff       	call   801030f1 <microdelay>
80108607:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010860a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010860e:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108612:	7f 1a                	jg     8010862e <uartputc+0x49>
80108614:	83 ec 0c             	sub    $0xc,%esp
80108617:	68 fd 03 00 00       	push   $0x3fd
8010861c:	e8 94 fe ff ff       	call   801084b5 <inb>
80108621:	83 c4 10             	add    $0x10,%esp
80108624:	0f b6 c0             	movzbl %al,%eax
80108627:	83 e0 20             	and    $0x20,%eax
8010862a:	85 c0                	test   %eax,%eax
8010862c:	74 cf                	je     801085fd <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
8010862e:	8b 45 08             	mov    0x8(%ebp),%eax
80108631:	0f b6 c0             	movzbl %al,%eax
80108634:	83 ec 08             	sub    $0x8,%esp
80108637:	50                   	push   %eax
80108638:	68 f8 03 00 00       	push   $0x3f8
8010863d:	e8 90 fe ff ff       	call   801084d2 <outb>
80108642:	83 c4 10             	add    $0x10,%esp
80108645:	eb 01                	jmp    80108648 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80108647:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80108648:	c9                   	leave  
80108649:	c3                   	ret    

8010864a <uartgetc>:

static int
uartgetc(void)
{
8010864a:	55                   	push   %ebp
8010864b:	89 e5                	mov    %esp,%ebp
  if(!uart)
8010864d:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80108652:	85 c0                	test   %eax,%eax
80108654:	75 07                	jne    8010865d <uartgetc+0x13>
    return -1;
80108656:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010865b:	eb 2e                	jmp    8010868b <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
8010865d:	68 fd 03 00 00       	push   $0x3fd
80108662:	e8 4e fe ff ff       	call   801084b5 <inb>
80108667:	83 c4 04             	add    $0x4,%esp
8010866a:	0f b6 c0             	movzbl %al,%eax
8010866d:	83 e0 01             	and    $0x1,%eax
80108670:	85 c0                	test   %eax,%eax
80108672:	75 07                	jne    8010867b <uartgetc+0x31>
    return -1;
80108674:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108679:	eb 10                	jmp    8010868b <uartgetc+0x41>
  return inb(COM1+0);
8010867b:	68 f8 03 00 00       	push   $0x3f8
80108680:	e8 30 fe ff ff       	call   801084b5 <inb>
80108685:	83 c4 04             	add    $0x4,%esp
80108688:	0f b6 c0             	movzbl %al,%eax
}
8010868b:	c9                   	leave  
8010868c:	c3                   	ret    

8010868d <uartintr>:

void
uartintr(void)
{
8010868d:	55                   	push   %ebp
8010868e:	89 e5                	mov    %esp,%ebp
80108690:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80108693:	83 ec 0c             	sub    $0xc,%esp
80108696:	68 4a 86 10 80       	push   $0x8010864a
8010869b:	e8 59 81 ff ff       	call   801007f9 <consoleintr>
801086a0:	83 c4 10             	add    $0x10,%esp
}
801086a3:	90                   	nop
801086a4:	c9                   	leave  
801086a5:	c3                   	ret    

801086a6 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801086a6:	6a 00                	push   $0x0
  pushl $0
801086a8:	6a 00                	push   $0x0
  jmp alltraps
801086aa:	e9 a9 f9 ff ff       	jmp    80108058 <alltraps>

801086af <vector1>:
.globl vector1
vector1:
  pushl $0
801086af:	6a 00                	push   $0x0
  pushl $1
801086b1:	6a 01                	push   $0x1
  jmp alltraps
801086b3:	e9 a0 f9 ff ff       	jmp    80108058 <alltraps>

801086b8 <vector2>:
.globl vector2
vector2:
  pushl $0
801086b8:	6a 00                	push   $0x0
  pushl $2
801086ba:	6a 02                	push   $0x2
  jmp alltraps
801086bc:	e9 97 f9 ff ff       	jmp    80108058 <alltraps>

801086c1 <vector3>:
.globl vector3
vector3:
  pushl $0
801086c1:	6a 00                	push   $0x0
  pushl $3
801086c3:	6a 03                	push   $0x3
  jmp alltraps
801086c5:	e9 8e f9 ff ff       	jmp    80108058 <alltraps>

801086ca <vector4>:
.globl vector4
vector4:
  pushl $0
801086ca:	6a 00                	push   $0x0
  pushl $4
801086cc:	6a 04                	push   $0x4
  jmp alltraps
801086ce:	e9 85 f9 ff ff       	jmp    80108058 <alltraps>

801086d3 <vector5>:
.globl vector5
vector5:
  pushl $0
801086d3:	6a 00                	push   $0x0
  pushl $5
801086d5:	6a 05                	push   $0x5
  jmp alltraps
801086d7:	e9 7c f9 ff ff       	jmp    80108058 <alltraps>

801086dc <vector6>:
.globl vector6
vector6:
  pushl $0
801086dc:	6a 00                	push   $0x0
  pushl $6
801086de:	6a 06                	push   $0x6
  jmp alltraps
801086e0:	e9 73 f9 ff ff       	jmp    80108058 <alltraps>

801086e5 <vector7>:
.globl vector7
vector7:
  pushl $0
801086e5:	6a 00                	push   $0x0
  pushl $7
801086e7:	6a 07                	push   $0x7
  jmp alltraps
801086e9:	e9 6a f9 ff ff       	jmp    80108058 <alltraps>

801086ee <vector8>:
.globl vector8
vector8:
  pushl $8
801086ee:	6a 08                	push   $0x8
  jmp alltraps
801086f0:	e9 63 f9 ff ff       	jmp    80108058 <alltraps>

801086f5 <vector9>:
.globl vector9
vector9:
  pushl $0
801086f5:	6a 00                	push   $0x0
  pushl $9
801086f7:	6a 09                	push   $0x9
  jmp alltraps
801086f9:	e9 5a f9 ff ff       	jmp    80108058 <alltraps>

801086fe <vector10>:
.globl vector10
vector10:
  pushl $10
801086fe:	6a 0a                	push   $0xa
  jmp alltraps
80108700:	e9 53 f9 ff ff       	jmp    80108058 <alltraps>

80108705 <vector11>:
.globl vector11
vector11:
  pushl $11
80108705:	6a 0b                	push   $0xb
  jmp alltraps
80108707:	e9 4c f9 ff ff       	jmp    80108058 <alltraps>

8010870c <vector12>:
.globl vector12
vector12:
  pushl $12
8010870c:	6a 0c                	push   $0xc
  jmp alltraps
8010870e:	e9 45 f9 ff ff       	jmp    80108058 <alltraps>

80108713 <vector13>:
.globl vector13
vector13:
  pushl $13
80108713:	6a 0d                	push   $0xd
  jmp alltraps
80108715:	e9 3e f9 ff ff       	jmp    80108058 <alltraps>

8010871a <vector14>:
.globl vector14
vector14:
  pushl $14
8010871a:	6a 0e                	push   $0xe
  jmp alltraps
8010871c:	e9 37 f9 ff ff       	jmp    80108058 <alltraps>

80108721 <vector15>:
.globl vector15
vector15:
  pushl $0
80108721:	6a 00                	push   $0x0
  pushl $15
80108723:	6a 0f                	push   $0xf
  jmp alltraps
80108725:	e9 2e f9 ff ff       	jmp    80108058 <alltraps>

8010872a <vector16>:
.globl vector16
vector16:
  pushl $0
8010872a:	6a 00                	push   $0x0
  pushl $16
8010872c:	6a 10                	push   $0x10
  jmp alltraps
8010872e:	e9 25 f9 ff ff       	jmp    80108058 <alltraps>

80108733 <vector17>:
.globl vector17
vector17:
  pushl $17
80108733:	6a 11                	push   $0x11
  jmp alltraps
80108735:	e9 1e f9 ff ff       	jmp    80108058 <alltraps>

8010873a <vector18>:
.globl vector18
vector18:
  pushl $0
8010873a:	6a 00                	push   $0x0
  pushl $18
8010873c:	6a 12                	push   $0x12
  jmp alltraps
8010873e:	e9 15 f9 ff ff       	jmp    80108058 <alltraps>

80108743 <vector19>:
.globl vector19
vector19:
  pushl $0
80108743:	6a 00                	push   $0x0
  pushl $19
80108745:	6a 13                	push   $0x13
  jmp alltraps
80108747:	e9 0c f9 ff ff       	jmp    80108058 <alltraps>

8010874c <vector20>:
.globl vector20
vector20:
  pushl $0
8010874c:	6a 00                	push   $0x0
  pushl $20
8010874e:	6a 14                	push   $0x14
  jmp alltraps
80108750:	e9 03 f9 ff ff       	jmp    80108058 <alltraps>

80108755 <vector21>:
.globl vector21
vector21:
  pushl $0
80108755:	6a 00                	push   $0x0
  pushl $21
80108757:	6a 15                	push   $0x15
  jmp alltraps
80108759:	e9 fa f8 ff ff       	jmp    80108058 <alltraps>

8010875e <vector22>:
.globl vector22
vector22:
  pushl $0
8010875e:	6a 00                	push   $0x0
  pushl $22
80108760:	6a 16                	push   $0x16
  jmp alltraps
80108762:	e9 f1 f8 ff ff       	jmp    80108058 <alltraps>

80108767 <vector23>:
.globl vector23
vector23:
  pushl $0
80108767:	6a 00                	push   $0x0
  pushl $23
80108769:	6a 17                	push   $0x17
  jmp alltraps
8010876b:	e9 e8 f8 ff ff       	jmp    80108058 <alltraps>

80108770 <vector24>:
.globl vector24
vector24:
  pushl $0
80108770:	6a 00                	push   $0x0
  pushl $24
80108772:	6a 18                	push   $0x18
  jmp alltraps
80108774:	e9 df f8 ff ff       	jmp    80108058 <alltraps>

80108779 <vector25>:
.globl vector25
vector25:
  pushl $0
80108779:	6a 00                	push   $0x0
  pushl $25
8010877b:	6a 19                	push   $0x19
  jmp alltraps
8010877d:	e9 d6 f8 ff ff       	jmp    80108058 <alltraps>

80108782 <vector26>:
.globl vector26
vector26:
  pushl $0
80108782:	6a 00                	push   $0x0
  pushl $26
80108784:	6a 1a                	push   $0x1a
  jmp alltraps
80108786:	e9 cd f8 ff ff       	jmp    80108058 <alltraps>

8010878b <vector27>:
.globl vector27
vector27:
  pushl $0
8010878b:	6a 00                	push   $0x0
  pushl $27
8010878d:	6a 1b                	push   $0x1b
  jmp alltraps
8010878f:	e9 c4 f8 ff ff       	jmp    80108058 <alltraps>

80108794 <vector28>:
.globl vector28
vector28:
  pushl $0
80108794:	6a 00                	push   $0x0
  pushl $28
80108796:	6a 1c                	push   $0x1c
  jmp alltraps
80108798:	e9 bb f8 ff ff       	jmp    80108058 <alltraps>

8010879d <vector29>:
.globl vector29
vector29:
  pushl $0
8010879d:	6a 00                	push   $0x0
  pushl $29
8010879f:	6a 1d                	push   $0x1d
  jmp alltraps
801087a1:	e9 b2 f8 ff ff       	jmp    80108058 <alltraps>

801087a6 <vector30>:
.globl vector30
vector30:
  pushl $0
801087a6:	6a 00                	push   $0x0
  pushl $30
801087a8:	6a 1e                	push   $0x1e
  jmp alltraps
801087aa:	e9 a9 f8 ff ff       	jmp    80108058 <alltraps>

801087af <vector31>:
.globl vector31
vector31:
  pushl $0
801087af:	6a 00                	push   $0x0
  pushl $31
801087b1:	6a 1f                	push   $0x1f
  jmp alltraps
801087b3:	e9 a0 f8 ff ff       	jmp    80108058 <alltraps>

801087b8 <vector32>:
.globl vector32
vector32:
  pushl $0
801087b8:	6a 00                	push   $0x0
  pushl $32
801087ba:	6a 20                	push   $0x20
  jmp alltraps
801087bc:	e9 97 f8 ff ff       	jmp    80108058 <alltraps>

801087c1 <vector33>:
.globl vector33
vector33:
  pushl $0
801087c1:	6a 00                	push   $0x0
  pushl $33
801087c3:	6a 21                	push   $0x21
  jmp alltraps
801087c5:	e9 8e f8 ff ff       	jmp    80108058 <alltraps>

801087ca <vector34>:
.globl vector34
vector34:
  pushl $0
801087ca:	6a 00                	push   $0x0
  pushl $34
801087cc:	6a 22                	push   $0x22
  jmp alltraps
801087ce:	e9 85 f8 ff ff       	jmp    80108058 <alltraps>

801087d3 <vector35>:
.globl vector35
vector35:
  pushl $0
801087d3:	6a 00                	push   $0x0
  pushl $35
801087d5:	6a 23                	push   $0x23
  jmp alltraps
801087d7:	e9 7c f8 ff ff       	jmp    80108058 <alltraps>

801087dc <vector36>:
.globl vector36
vector36:
  pushl $0
801087dc:	6a 00                	push   $0x0
  pushl $36
801087de:	6a 24                	push   $0x24
  jmp alltraps
801087e0:	e9 73 f8 ff ff       	jmp    80108058 <alltraps>

801087e5 <vector37>:
.globl vector37
vector37:
  pushl $0
801087e5:	6a 00                	push   $0x0
  pushl $37
801087e7:	6a 25                	push   $0x25
  jmp alltraps
801087e9:	e9 6a f8 ff ff       	jmp    80108058 <alltraps>

801087ee <vector38>:
.globl vector38
vector38:
  pushl $0
801087ee:	6a 00                	push   $0x0
  pushl $38
801087f0:	6a 26                	push   $0x26
  jmp alltraps
801087f2:	e9 61 f8 ff ff       	jmp    80108058 <alltraps>

801087f7 <vector39>:
.globl vector39
vector39:
  pushl $0
801087f7:	6a 00                	push   $0x0
  pushl $39
801087f9:	6a 27                	push   $0x27
  jmp alltraps
801087fb:	e9 58 f8 ff ff       	jmp    80108058 <alltraps>

80108800 <vector40>:
.globl vector40
vector40:
  pushl $0
80108800:	6a 00                	push   $0x0
  pushl $40
80108802:	6a 28                	push   $0x28
  jmp alltraps
80108804:	e9 4f f8 ff ff       	jmp    80108058 <alltraps>

80108809 <vector41>:
.globl vector41
vector41:
  pushl $0
80108809:	6a 00                	push   $0x0
  pushl $41
8010880b:	6a 29                	push   $0x29
  jmp alltraps
8010880d:	e9 46 f8 ff ff       	jmp    80108058 <alltraps>

80108812 <vector42>:
.globl vector42
vector42:
  pushl $0
80108812:	6a 00                	push   $0x0
  pushl $42
80108814:	6a 2a                	push   $0x2a
  jmp alltraps
80108816:	e9 3d f8 ff ff       	jmp    80108058 <alltraps>

8010881b <vector43>:
.globl vector43
vector43:
  pushl $0
8010881b:	6a 00                	push   $0x0
  pushl $43
8010881d:	6a 2b                	push   $0x2b
  jmp alltraps
8010881f:	e9 34 f8 ff ff       	jmp    80108058 <alltraps>

80108824 <vector44>:
.globl vector44
vector44:
  pushl $0
80108824:	6a 00                	push   $0x0
  pushl $44
80108826:	6a 2c                	push   $0x2c
  jmp alltraps
80108828:	e9 2b f8 ff ff       	jmp    80108058 <alltraps>

8010882d <vector45>:
.globl vector45
vector45:
  pushl $0
8010882d:	6a 00                	push   $0x0
  pushl $45
8010882f:	6a 2d                	push   $0x2d
  jmp alltraps
80108831:	e9 22 f8 ff ff       	jmp    80108058 <alltraps>

80108836 <vector46>:
.globl vector46
vector46:
  pushl $0
80108836:	6a 00                	push   $0x0
  pushl $46
80108838:	6a 2e                	push   $0x2e
  jmp alltraps
8010883a:	e9 19 f8 ff ff       	jmp    80108058 <alltraps>

8010883f <vector47>:
.globl vector47
vector47:
  pushl $0
8010883f:	6a 00                	push   $0x0
  pushl $47
80108841:	6a 2f                	push   $0x2f
  jmp alltraps
80108843:	e9 10 f8 ff ff       	jmp    80108058 <alltraps>

80108848 <vector48>:
.globl vector48
vector48:
  pushl $0
80108848:	6a 00                	push   $0x0
  pushl $48
8010884a:	6a 30                	push   $0x30
  jmp alltraps
8010884c:	e9 07 f8 ff ff       	jmp    80108058 <alltraps>

80108851 <vector49>:
.globl vector49
vector49:
  pushl $0
80108851:	6a 00                	push   $0x0
  pushl $49
80108853:	6a 31                	push   $0x31
  jmp alltraps
80108855:	e9 fe f7 ff ff       	jmp    80108058 <alltraps>

8010885a <vector50>:
.globl vector50
vector50:
  pushl $0
8010885a:	6a 00                	push   $0x0
  pushl $50
8010885c:	6a 32                	push   $0x32
  jmp alltraps
8010885e:	e9 f5 f7 ff ff       	jmp    80108058 <alltraps>

80108863 <vector51>:
.globl vector51
vector51:
  pushl $0
80108863:	6a 00                	push   $0x0
  pushl $51
80108865:	6a 33                	push   $0x33
  jmp alltraps
80108867:	e9 ec f7 ff ff       	jmp    80108058 <alltraps>

8010886c <vector52>:
.globl vector52
vector52:
  pushl $0
8010886c:	6a 00                	push   $0x0
  pushl $52
8010886e:	6a 34                	push   $0x34
  jmp alltraps
80108870:	e9 e3 f7 ff ff       	jmp    80108058 <alltraps>

80108875 <vector53>:
.globl vector53
vector53:
  pushl $0
80108875:	6a 00                	push   $0x0
  pushl $53
80108877:	6a 35                	push   $0x35
  jmp alltraps
80108879:	e9 da f7 ff ff       	jmp    80108058 <alltraps>

8010887e <vector54>:
.globl vector54
vector54:
  pushl $0
8010887e:	6a 00                	push   $0x0
  pushl $54
80108880:	6a 36                	push   $0x36
  jmp alltraps
80108882:	e9 d1 f7 ff ff       	jmp    80108058 <alltraps>

80108887 <vector55>:
.globl vector55
vector55:
  pushl $0
80108887:	6a 00                	push   $0x0
  pushl $55
80108889:	6a 37                	push   $0x37
  jmp alltraps
8010888b:	e9 c8 f7 ff ff       	jmp    80108058 <alltraps>

80108890 <vector56>:
.globl vector56
vector56:
  pushl $0
80108890:	6a 00                	push   $0x0
  pushl $56
80108892:	6a 38                	push   $0x38
  jmp alltraps
80108894:	e9 bf f7 ff ff       	jmp    80108058 <alltraps>

80108899 <vector57>:
.globl vector57
vector57:
  pushl $0
80108899:	6a 00                	push   $0x0
  pushl $57
8010889b:	6a 39                	push   $0x39
  jmp alltraps
8010889d:	e9 b6 f7 ff ff       	jmp    80108058 <alltraps>

801088a2 <vector58>:
.globl vector58
vector58:
  pushl $0
801088a2:	6a 00                	push   $0x0
  pushl $58
801088a4:	6a 3a                	push   $0x3a
  jmp alltraps
801088a6:	e9 ad f7 ff ff       	jmp    80108058 <alltraps>

801088ab <vector59>:
.globl vector59
vector59:
  pushl $0
801088ab:	6a 00                	push   $0x0
  pushl $59
801088ad:	6a 3b                	push   $0x3b
  jmp alltraps
801088af:	e9 a4 f7 ff ff       	jmp    80108058 <alltraps>

801088b4 <vector60>:
.globl vector60
vector60:
  pushl $0
801088b4:	6a 00                	push   $0x0
  pushl $60
801088b6:	6a 3c                	push   $0x3c
  jmp alltraps
801088b8:	e9 9b f7 ff ff       	jmp    80108058 <alltraps>

801088bd <vector61>:
.globl vector61
vector61:
  pushl $0
801088bd:	6a 00                	push   $0x0
  pushl $61
801088bf:	6a 3d                	push   $0x3d
  jmp alltraps
801088c1:	e9 92 f7 ff ff       	jmp    80108058 <alltraps>

801088c6 <vector62>:
.globl vector62
vector62:
  pushl $0
801088c6:	6a 00                	push   $0x0
  pushl $62
801088c8:	6a 3e                	push   $0x3e
  jmp alltraps
801088ca:	e9 89 f7 ff ff       	jmp    80108058 <alltraps>

801088cf <vector63>:
.globl vector63
vector63:
  pushl $0
801088cf:	6a 00                	push   $0x0
  pushl $63
801088d1:	6a 3f                	push   $0x3f
  jmp alltraps
801088d3:	e9 80 f7 ff ff       	jmp    80108058 <alltraps>

801088d8 <vector64>:
.globl vector64
vector64:
  pushl $0
801088d8:	6a 00                	push   $0x0
  pushl $64
801088da:	6a 40                	push   $0x40
  jmp alltraps
801088dc:	e9 77 f7 ff ff       	jmp    80108058 <alltraps>

801088e1 <vector65>:
.globl vector65
vector65:
  pushl $0
801088e1:	6a 00                	push   $0x0
  pushl $65
801088e3:	6a 41                	push   $0x41
  jmp alltraps
801088e5:	e9 6e f7 ff ff       	jmp    80108058 <alltraps>

801088ea <vector66>:
.globl vector66
vector66:
  pushl $0
801088ea:	6a 00                	push   $0x0
  pushl $66
801088ec:	6a 42                	push   $0x42
  jmp alltraps
801088ee:	e9 65 f7 ff ff       	jmp    80108058 <alltraps>

801088f3 <vector67>:
.globl vector67
vector67:
  pushl $0
801088f3:	6a 00                	push   $0x0
  pushl $67
801088f5:	6a 43                	push   $0x43
  jmp alltraps
801088f7:	e9 5c f7 ff ff       	jmp    80108058 <alltraps>

801088fc <vector68>:
.globl vector68
vector68:
  pushl $0
801088fc:	6a 00                	push   $0x0
  pushl $68
801088fe:	6a 44                	push   $0x44
  jmp alltraps
80108900:	e9 53 f7 ff ff       	jmp    80108058 <alltraps>

80108905 <vector69>:
.globl vector69
vector69:
  pushl $0
80108905:	6a 00                	push   $0x0
  pushl $69
80108907:	6a 45                	push   $0x45
  jmp alltraps
80108909:	e9 4a f7 ff ff       	jmp    80108058 <alltraps>

8010890e <vector70>:
.globl vector70
vector70:
  pushl $0
8010890e:	6a 00                	push   $0x0
  pushl $70
80108910:	6a 46                	push   $0x46
  jmp alltraps
80108912:	e9 41 f7 ff ff       	jmp    80108058 <alltraps>

80108917 <vector71>:
.globl vector71
vector71:
  pushl $0
80108917:	6a 00                	push   $0x0
  pushl $71
80108919:	6a 47                	push   $0x47
  jmp alltraps
8010891b:	e9 38 f7 ff ff       	jmp    80108058 <alltraps>

80108920 <vector72>:
.globl vector72
vector72:
  pushl $0
80108920:	6a 00                	push   $0x0
  pushl $72
80108922:	6a 48                	push   $0x48
  jmp alltraps
80108924:	e9 2f f7 ff ff       	jmp    80108058 <alltraps>

80108929 <vector73>:
.globl vector73
vector73:
  pushl $0
80108929:	6a 00                	push   $0x0
  pushl $73
8010892b:	6a 49                	push   $0x49
  jmp alltraps
8010892d:	e9 26 f7 ff ff       	jmp    80108058 <alltraps>

80108932 <vector74>:
.globl vector74
vector74:
  pushl $0
80108932:	6a 00                	push   $0x0
  pushl $74
80108934:	6a 4a                	push   $0x4a
  jmp alltraps
80108936:	e9 1d f7 ff ff       	jmp    80108058 <alltraps>

8010893b <vector75>:
.globl vector75
vector75:
  pushl $0
8010893b:	6a 00                	push   $0x0
  pushl $75
8010893d:	6a 4b                	push   $0x4b
  jmp alltraps
8010893f:	e9 14 f7 ff ff       	jmp    80108058 <alltraps>

80108944 <vector76>:
.globl vector76
vector76:
  pushl $0
80108944:	6a 00                	push   $0x0
  pushl $76
80108946:	6a 4c                	push   $0x4c
  jmp alltraps
80108948:	e9 0b f7 ff ff       	jmp    80108058 <alltraps>

8010894d <vector77>:
.globl vector77
vector77:
  pushl $0
8010894d:	6a 00                	push   $0x0
  pushl $77
8010894f:	6a 4d                	push   $0x4d
  jmp alltraps
80108951:	e9 02 f7 ff ff       	jmp    80108058 <alltraps>

80108956 <vector78>:
.globl vector78
vector78:
  pushl $0
80108956:	6a 00                	push   $0x0
  pushl $78
80108958:	6a 4e                	push   $0x4e
  jmp alltraps
8010895a:	e9 f9 f6 ff ff       	jmp    80108058 <alltraps>

8010895f <vector79>:
.globl vector79
vector79:
  pushl $0
8010895f:	6a 00                	push   $0x0
  pushl $79
80108961:	6a 4f                	push   $0x4f
  jmp alltraps
80108963:	e9 f0 f6 ff ff       	jmp    80108058 <alltraps>

80108968 <vector80>:
.globl vector80
vector80:
  pushl $0
80108968:	6a 00                	push   $0x0
  pushl $80
8010896a:	6a 50                	push   $0x50
  jmp alltraps
8010896c:	e9 e7 f6 ff ff       	jmp    80108058 <alltraps>

80108971 <vector81>:
.globl vector81
vector81:
  pushl $0
80108971:	6a 00                	push   $0x0
  pushl $81
80108973:	6a 51                	push   $0x51
  jmp alltraps
80108975:	e9 de f6 ff ff       	jmp    80108058 <alltraps>

8010897a <vector82>:
.globl vector82
vector82:
  pushl $0
8010897a:	6a 00                	push   $0x0
  pushl $82
8010897c:	6a 52                	push   $0x52
  jmp alltraps
8010897e:	e9 d5 f6 ff ff       	jmp    80108058 <alltraps>

80108983 <vector83>:
.globl vector83
vector83:
  pushl $0
80108983:	6a 00                	push   $0x0
  pushl $83
80108985:	6a 53                	push   $0x53
  jmp alltraps
80108987:	e9 cc f6 ff ff       	jmp    80108058 <alltraps>

8010898c <vector84>:
.globl vector84
vector84:
  pushl $0
8010898c:	6a 00                	push   $0x0
  pushl $84
8010898e:	6a 54                	push   $0x54
  jmp alltraps
80108990:	e9 c3 f6 ff ff       	jmp    80108058 <alltraps>

80108995 <vector85>:
.globl vector85
vector85:
  pushl $0
80108995:	6a 00                	push   $0x0
  pushl $85
80108997:	6a 55                	push   $0x55
  jmp alltraps
80108999:	e9 ba f6 ff ff       	jmp    80108058 <alltraps>

8010899e <vector86>:
.globl vector86
vector86:
  pushl $0
8010899e:	6a 00                	push   $0x0
  pushl $86
801089a0:	6a 56                	push   $0x56
  jmp alltraps
801089a2:	e9 b1 f6 ff ff       	jmp    80108058 <alltraps>

801089a7 <vector87>:
.globl vector87
vector87:
  pushl $0
801089a7:	6a 00                	push   $0x0
  pushl $87
801089a9:	6a 57                	push   $0x57
  jmp alltraps
801089ab:	e9 a8 f6 ff ff       	jmp    80108058 <alltraps>

801089b0 <vector88>:
.globl vector88
vector88:
  pushl $0
801089b0:	6a 00                	push   $0x0
  pushl $88
801089b2:	6a 58                	push   $0x58
  jmp alltraps
801089b4:	e9 9f f6 ff ff       	jmp    80108058 <alltraps>

801089b9 <vector89>:
.globl vector89
vector89:
  pushl $0
801089b9:	6a 00                	push   $0x0
  pushl $89
801089bb:	6a 59                	push   $0x59
  jmp alltraps
801089bd:	e9 96 f6 ff ff       	jmp    80108058 <alltraps>

801089c2 <vector90>:
.globl vector90
vector90:
  pushl $0
801089c2:	6a 00                	push   $0x0
  pushl $90
801089c4:	6a 5a                	push   $0x5a
  jmp alltraps
801089c6:	e9 8d f6 ff ff       	jmp    80108058 <alltraps>

801089cb <vector91>:
.globl vector91
vector91:
  pushl $0
801089cb:	6a 00                	push   $0x0
  pushl $91
801089cd:	6a 5b                	push   $0x5b
  jmp alltraps
801089cf:	e9 84 f6 ff ff       	jmp    80108058 <alltraps>

801089d4 <vector92>:
.globl vector92
vector92:
  pushl $0
801089d4:	6a 00                	push   $0x0
  pushl $92
801089d6:	6a 5c                	push   $0x5c
  jmp alltraps
801089d8:	e9 7b f6 ff ff       	jmp    80108058 <alltraps>

801089dd <vector93>:
.globl vector93
vector93:
  pushl $0
801089dd:	6a 00                	push   $0x0
  pushl $93
801089df:	6a 5d                	push   $0x5d
  jmp alltraps
801089e1:	e9 72 f6 ff ff       	jmp    80108058 <alltraps>

801089e6 <vector94>:
.globl vector94
vector94:
  pushl $0
801089e6:	6a 00                	push   $0x0
  pushl $94
801089e8:	6a 5e                	push   $0x5e
  jmp alltraps
801089ea:	e9 69 f6 ff ff       	jmp    80108058 <alltraps>

801089ef <vector95>:
.globl vector95
vector95:
  pushl $0
801089ef:	6a 00                	push   $0x0
  pushl $95
801089f1:	6a 5f                	push   $0x5f
  jmp alltraps
801089f3:	e9 60 f6 ff ff       	jmp    80108058 <alltraps>

801089f8 <vector96>:
.globl vector96
vector96:
  pushl $0
801089f8:	6a 00                	push   $0x0
  pushl $96
801089fa:	6a 60                	push   $0x60
  jmp alltraps
801089fc:	e9 57 f6 ff ff       	jmp    80108058 <alltraps>

80108a01 <vector97>:
.globl vector97
vector97:
  pushl $0
80108a01:	6a 00                	push   $0x0
  pushl $97
80108a03:	6a 61                	push   $0x61
  jmp alltraps
80108a05:	e9 4e f6 ff ff       	jmp    80108058 <alltraps>

80108a0a <vector98>:
.globl vector98
vector98:
  pushl $0
80108a0a:	6a 00                	push   $0x0
  pushl $98
80108a0c:	6a 62                	push   $0x62
  jmp alltraps
80108a0e:	e9 45 f6 ff ff       	jmp    80108058 <alltraps>

80108a13 <vector99>:
.globl vector99
vector99:
  pushl $0
80108a13:	6a 00                	push   $0x0
  pushl $99
80108a15:	6a 63                	push   $0x63
  jmp alltraps
80108a17:	e9 3c f6 ff ff       	jmp    80108058 <alltraps>

80108a1c <vector100>:
.globl vector100
vector100:
  pushl $0
80108a1c:	6a 00                	push   $0x0
  pushl $100
80108a1e:	6a 64                	push   $0x64
  jmp alltraps
80108a20:	e9 33 f6 ff ff       	jmp    80108058 <alltraps>

80108a25 <vector101>:
.globl vector101
vector101:
  pushl $0
80108a25:	6a 00                	push   $0x0
  pushl $101
80108a27:	6a 65                	push   $0x65
  jmp alltraps
80108a29:	e9 2a f6 ff ff       	jmp    80108058 <alltraps>

80108a2e <vector102>:
.globl vector102
vector102:
  pushl $0
80108a2e:	6a 00                	push   $0x0
  pushl $102
80108a30:	6a 66                	push   $0x66
  jmp alltraps
80108a32:	e9 21 f6 ff ff       	jmp    80108058 <alltraps>

80108a37 <vector103>:
.globl vector103
vector103:
  pushl $0
80108a37:	6a 00                	push   $0x0
  pushl $103
80108a39:	6a 67                	push   $0x67
  jmp alltraps
80108a3b:	e9 18 f6 ff ff       	jmp    80108058 <alltraps>

80108a40 <vector104>:
.globl vector104
vector104:
  pushl $0
80108a40:	6a 00                	push   $0x0
  pushl $104
80108a42:	6a 68                	push   $0x68
  jmp alltraps
80108a44:	e9 0f f6 ff ff       	jmp    80108058 <alltraps>

80108a49 <vector105>:
.globl vector105
vector105:
  pushl $0
80108a49:	6a 00                	push   $0x0
  pushl $105
80108a4b:	6a 69                	push   $0x69
  jmp alltraps
80108a4d:	e9 06 f6 ff ff       	jmp    80108058 <alltraps>

80108a52 <vector106>:
.globl vector106
vector106:
  pushl $0
80108a52:	6a 00                	push   $0x0
  pushl $106
80108a54:	6a 6a                	push   $0x6a
  jmp alltraps
80108a56:	e9 fd f5 ff ff       	jmp    80108058 <alltraps>

80108a5b <vector107>:
.globl vector107
vector107:
  pushl $0
80108a5b:	6a 00                	push   $0x0
  pushl $107
80108a5d:	6a 6b                	push   $0x6b
  jmp alltraps
80108a5f:	e9 f4 f5 ff ff       	jmp    80108058 <alltraps>

80108a64 <vector108>:
.globl vector108
vector108:
  pushl $0
80108a64:	6a 00                	push   $0x0
  pushl $108
80108a66:	6a 6c                	push   $0x6c
  jmp alltraps
80108a68:	e9 eb f5 ff ff       	jmp    80108058 <alltraps>

80108a6d <vector109>:
.globl vector109
vector109:
  pushl $0
80108a6d:	6a 00                	push   $0x0
  pushl $109
80108a6f:	6a 6d                	push   $0x6d
  jmp alltraps
80108a71:	e9 e2 f5 ff ff       	jmp    80108058 <alltraps>

80108a76 <vector110>:
.globl vector110
vector110:
  pushl $0
80108a76:	6a 00                	push   $0x0
  pushl $110
80108a78:	6a 6e                	push   $0x6e
  jmp alltraps
80108a7a:	e9 d9 f5 ff ff       	jmp    80108058 <alltraps>

80108a7f <vector111>:
.globl vector111
vector111:
  pushl $0
80108a7f:	6a 00                	push   $0x0
  pushl $111
80108a81:	6a 6f                	push   $0x6f
  jmp alltraps
80108a83:	e9 d0 f5 ff ff       	jmp    80108058 <alltraps>

80108a88 <vector112>:
.globl vector112
vector112:
  pushl $0
80108a88:	6a 00                	push   $0x0
  pushl $112
80108a8a:	6a 70                	push   $0x70
  jmp alltraps
80108a8c:	e9 c7 f5 ff ff       	jmp    80108058 <alltraps>

80108a91 <vector113>:
.globl vector113
vector113:
  pushl $0
80108a91:	6a 00                	push   $0x0
  pushl $113
80108a93:	6a 71                	push   $0x71
  jmp alltraps
80108a95:	e9 be f5 ff ff       	jmp    80108058 <alltraps>

80108a9a <vector114>:
.globl vector114
vector114:
  pushl $0
80108a9a:	6a 00                	push   $0x0
  pushl $114
80108a9c:	6a 72                	push   $0x72
  jmp alltraps
80108a9e:	e9 b5 f5 ff ff       	jmp    80108058 <alltraps>

80108aa3 <vector115>:
.globl vector115
vector115:
  pushl $0
80108aa3:	6a 00                	push   $0x0
  pushl $115
80108aa5:	6a 73                	push   $0x73
  jmp alltraps
80108aa7:	e9 ac f5 ff ff       	jmp    80108058 <alltraps>

80108aac <vector116>:
.globl vector116
vector116:
  pushl $0
80108aac:	6a 00                	push   $0x0
  pushl $116
80108aae:	6a 74                	push   $0x74
  jmp alltraps
80108ab0:	e9 a3 f5 ff ff       	jmp    80108058 <alltraps>

80108ab5 <vector117>:
.globl vector117
vector117:
  pushl $0
80108ab5:	6a 00                	push   $0x0
  pushl $117
80108ab7:	6a 75                	push   $0x75
  jmp alltraps
80108ab9:	e9 9a f5 ff ff       	jmp    80108058 <alltraps>

80108abe <vector118>:
.globl vector118
vector118:
  pushl $0
80108abe:	6a 00                	push   $0x0
  pushl $118
80108ac0:	6a 76                	push   $0x76
  jmp alltraps
80108ac2:	e9 91 f5 ff ff       	jmp    80108058 <alltraps>

80108ac7 <vector119>:
.globl vector119
vector119:
  pushl $0
80108ac7:	6a 00                	push   $0x0
  pushl $119
80108ac9:	6a 77                	push   $0x77
  jmp alltraps
80108acb:	e9 88 f5 ff ff       	jmp    80108058 <alltraps>

80108ad0 <vector120>:
.globl vector120
vector120:
  pushl $0
80108ad0:	6a 00                	push   $0x0
  pushl $120
80108ad2:	6a 78                	push   $0x78
  jmp alltraps
80108ad4:	e9 7f f5 ff ff       	jmp    80108058 <alltraps>

80108ad9 <vector121>:
.globl vector121
vector121:
  pushl $0
80108ad9:	6a 00                	push   $0x0
  pushl $121
80108adb:	6a 79                	push   $0x79
  jmp alltraps
80108add:	e9 76 f5 ff ff       	jmp    80108058 <alltraps>

80108ae2 <vector122>:
.globl vector122
vector122:
  pushl $0
80108ae2:	6a 00                	push   $0x0
  pushl $122
80108ae4:	6a 7a                	push   $0x7a
  jmp alltraps
80108ae6:	e9 6d f5 ff ff       	jmp    80108058 <alltraps>

80108aeb <vector123>:
.globl vector123
vector123:
  pushl $0
80108aeb:	6a 00                	push   $0x0
  pushl $123
80108aed:	6a 7b                	push   $0x7b
  jmp alltraps
80108aef:	e9 64 f5 ff ff       	jmp    80108058 <alltraps>

80108af4 <vector124>:
.globl vector124
vector124:
  pushl $0
80108af4:	6a 00                	push   $0x0
  pushl $124
80108af6:	6a 7c                	push   $0x7c
  jmp alltraps
80108af8:	e9 5b f5 ff ff       	jmp    80108058 <alltraps>

80108afd <vector125>:
.globl vector125
vector125:
  pushl $0
80108afd:	6a 00                	push   $0x0
  pushl $125
80108aff:	6a 7d                	push   $0x7d
  jmp alltraps
80108b01:	e9 52 f5 ff ff       	jmp    80108058 <alltraps>

80108b06 <vector126>:
.globl vector126
vector126:
  pushl $0
80108b06:	6a 00                	push   $0x0
  pushl $126
80108b08:	6a 7e                	push   $0x7e
  jmp alltraps
80108b0a:	e9 49 f5 ff ff       	jmp    80108058 <alltraps>

80108b0f <vector127>:
.globl vector127
vector127:
  pushl $0
80108b0f:	6a 00                	push   $0x0
  pushl $127
80108b11:	6a 7f                	push   $0x7f
  jmp alltraps
80108b13:	e9 40 f5 ff ff       	jmp    80108058 <alltraps>

80108b18 <vector128>:
.globl vector128
vector128:
  pushl $0
80108b18:	6a 00                	push   $0x0
  pushl $128
80108b1a:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108b1f:	e9 34 f5 ff ff       	jmp    80108058 <alltraps>

80108b24 <vector129>:
.globl vector129
vector129:
  pushl $0
80108b24:	6a 00                	push   $0x0
  pushl $129
80108b26:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108b2b:	e9 28 f5 ff ff       	jmp    80108058 <alltraps>

80108b30 <vector130>:
.globl vector130
vector130:
  pushl $0
80108b30:	6a 00                	push   $0x0
  pushl $130
80108b32:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108b37:	e9 1c f5 ff ff       	jmp    80108058 <alltraps>

80108b3c <vector131>:
.globl vector131
vector131:
  pushl $0
80108b3c:	6a 00                	push   $0x0
  pushl $131
80108b3e:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108b43:	e9 10 f5 ff ff       	jmp    80108058 <alltraps>

80108b48 <vector132>:
.globl vector132
vector132:
  pushl $0
80108b48:	6a 00                	push   $0x0
  pushl $132
80108b4a:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108b4f:	e9 04 f5 ff ff       	jmp    80108058 <alltraps>

80108b54 <vector133>:
.globl vector133
vector133:
  pushl $0
80108b54:	6a 00                	push   $0x0
  pushl $133
80108b56:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108b5b:	e9 f8 f4 ff ff       	jmp    80108058 <alltraps>

80108b60 <vector134>:
.globl vector134
vector134:
  pushl $0
80108b60:	6a 00                	push   $0x0
  pushl $134
80108b62:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108b67:	e9 ec f4 ff ff       	jmp    80108058 <alltraps>

80108b6c <vector135>:
.globl vector135
vector135:
  pushl $0
80108b6c:	6a 00                	push   $0x0
  pushl $135
80108b6e:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108b73:	e9 e0 f4 ff ff       	jmp    80108058 <alltraps>

80108b78 <vector136>:
.globl vector136
vector136:
  pushl $0
80108b78:	6a 00                	push   $0x0
  pushl $136
80108b7a:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108b7f:	e9 d4 f4 ff ff       	jmp    80108058 <alltraps>

80108b84 <vector137>:
.globl vector137
vector137:
  pushl $0
80108b84:	6a 00                	push   $0x0
  pushl $137
80108b86:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108b8b:	e9 c8 f4 ff ff       	jmp    80108058 <alltraps>

80108b90 <vector138>:
.globl vector138
vector138:
  pushl $0
80108b90:	6a 00                	push   $0x0
  pushl $138
80108b92:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108b97:	e9 bc f4 ff ff       	jmp    80108058 <alltraps>

80108b9c <vector139>:
.globl vector139
vector139:
  pushl $0
80108b9c:	6a 00                	push   $0x0
  pushl $139
80108b9e:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108ba3:	e9 b0 f4 ff ff       	jmp    80108058 <alltraps>

80108ba8 <vector140>:
.globl vector140
vector140:
  pushl $0
80108ba8:	6a 00                	push   $0x0
  pushl $140
80108baa:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108baf:	e9 a4 f4 ff ff       	jmp    80108058 <alltraps>

80108bb4 <vector141>:
.globl vector141
vector141:
  pushl $0
80108bb4:	6a 00                	push   $0x0
  pushl $141
80108bb6:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108bbb:	e9 98 f4 ff ff       	jmp    80108058 <alltraps>

80108bc0 <vector142>:
.globl vector142
vector142:
  pushl $0
80108bc0:	6a 00                	push   $0x0
  pushl $142
80108bc2:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108bc7:	e9 8c f4 ff ff       	jmp    80108058 <alltraps>

80108bcc <vector143>:
.globl vector143
vector143:
  pushl $0
80108bcc:	6a 00                	push   $0x0
  pushl $143
80108bce:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108bd3:	e9 80 f4 ff ff       	jmp    80108058 <alltraps>

80108bd8 <vector144>:
.globl vector144
vector144:
  pushl $0
80108bd8:	6a 00                	push   $0x0
  pushl $144
80108bda:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108bdf:	e9 74 f4 ff ff       	jmp    80108058 <alltraps>

80108be4 <vector145>:
.globl vector145
vector145:
  pushl $0
80108be4:	6a 00                	push   $0x0
  pushl $145
80108be6:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108beb:	e9 68 f4 ff ff       	jmp    80108058 <alltraps>

80108bf0 <vector146>:
.globl vector146
vector146:
  pushl $0
80108bf0:	6a 00                	push   $0x0
  pushl $146
80108bf2:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108bf7:	e9 5c f4 ff ff       	jmp    80108058 <alltraps>

80108bfc <vector147>:
.globl vector147
vector147:
  pushl $0
80108bfc:	6a 00                	push   $0x0
  pushl $147
80108bfe:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108c03:	e9 50 f4 ff ff       	jmp    80108058 <alltraps>

80108c08 <vector148>:
.globl vector148
vector148:
  pushl $0
80108c08:	6a 00                	push   $0x0
  pushl $148
80108c0a:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108c0f:	e9 44 f4 ff ff       	jmp    80108058 <alltraps>

80108c14 <vector149>:
.globl vector149
vector149:
  pushl $0
80108c14:	6a 00                	push   $0x0
  pushl $149
80108c16:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108c1b:	e9 38 f4 ff ff       	jmp    80108058 <alltraps>

80108c20 <vector150>:
.globl vector150
vector150:
  pushl $0
80108c20:	6a 00                	push   $0x0
  pushl $150
80108c22:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108c27:	e9 2c f4 ff ff       	jmp    80108058 <alltraps>

80108c2c <vector151>:
.globl vector151
vector151:
  pushl $0
80108c2c:	6a 00                	push   $0x0
  pushl $151
80108c2e:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108c33:	e9 20 f4 ff ff       	jmp    80108058 <alltraps>

80108c38 <vector152>:
.globl vector152
vector152:
  pushl $0
80108c38:	6a 00                	push   $0x0
  pushl $152
80108c3a:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108c3f:	e9 14 f4 ff ff       	jmp    80108058 <alltraps>

80108c44 <vector153>:
.globl vector153
vector153:
  pushl $0
80108c44:	6a 00                	push   $0x0
  pushl $153
80108c46:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108c4b:	e9 08 f4 ff ff       	jmp    80108058 <alltraps>

80108c50 <vector154>:
.globl vector154
vector154:
  pushl $0
80108c50:	6a 00                	push   $0x0
  pushl $154
80108c52:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108c57:	e9 fc f3 ff ff       	jmp    80108058 <alltraps>

80108c5c <vector155>:
.globl vector155
vector155:
  pushl $0
80108c5c:	6a 00                	push   $0x0
  pushl $155
80108c5e:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108c63:	e9 f0 f3 ff ff       	jmp    80108058 <alltraps>

80108c68 <vector156>:
.globl vector156
vector156:
  pushl $0
80108c68:	6a 00                	push   $0x0
  pushl $156
80108c6a:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108c6f:	e9 e4 f3 ff ff       	jmp    80108058 <alltraps>

80108c74 <vector157>:
.globl vector157
vector157:
  pushl $0
80108c74:	6a 00                	push   $0x0
  pushl $157
80108c76:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108c7b:	e9 d8 f3 ff ff       	jmp    80108058 <alltraps>

80108c80 <vector158>:
.globl vector158
vector158:
  pushl $0
80108c80:	6a 00                	push   $0x0
  pushl $158
80108c82:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108c87:	e9 cc f3 ff ff       	jmp    80108058 <alltraps>

80108c8c <vector159>:
.globl vector159
vector159:
  pushl $0
80108c8c:	6a 00                	push   $0x0
  pushl $159
80108c8e:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108c93:	e9 c0 f3 ff ff       	jmp    80108058 <alltraps>

80108c98 <vector160>:
.globl vector160
vector160:
  pushl $0
80108c98:	6a 00                	push   $0x0
  pushl $160
80108c9a:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108c9f:	e9 b4 f3 ff ff       	jmp    80108058 <alltraps>

80108ca4 <vector161>:
.globl vector161
vector161:
  pushl $0
80108ca4:	6a 00                	push   $0x0
  pushl $161
80108ca6:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108cab:	e9 a8 f3 ff ff       	jmp    80108058 <alltraps>

80108cb0 <vector162>:
.globl vector162
vector162:
  pushl $0
80108cb0:	6a 00                	push   $0x0
  pushl $162
80108cb2:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108cb7:	e9 9c f3 ff ff       	jmp    80108058 <alltraps>

80108cbc <vector163>:
.globl vector163
vector163:
  pushl $0
80108cbc:	6a 00                	push   $0x0
  pushl $163
80108cbe:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108cc3:	e9 90 f3 ff ff       	jmp    80108058 <alltraps>

80108cc8 <vector164>:
.globl vector164
vector164:
  pushl $0
80108cc8:	6a 00                	push   $0x0
  pushl $164
80108cca:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108ccf:	e9 84 f3 ff ff       	jmp    80108058 <alltraps>

80108cd4 <vector165>:
.globl vector165
vector165:
  pushl $0
80108cd4:	6a 00                	push   $0x0
  pushl $165
80108cd6:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108cdb:	e9 78 f3 ff ff       	jmp    80108058 <alltraps>

80108ce0 <vector166>:
.globl vector166
vector166:
  pushl $0
80108ce0:	6a 00                	push   $0x0
  pushl $166
80108ce2:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108ce7:	e9 6c f3 ff ff       	jmp    80108058 <alltraps>

80108cec <vector167>:
.globl vector167
vector167:
  pushl $0
80108cec:	6a 00                	push   $0x0
  pushl $167
80108cee:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108cf3:	e9 60 f3 ff ff       	jmp    80108058 <alltraps>

80108cf8 <vector168>:
.globl vector168
vector168:
  pushl $0
80108cf8:	6a 00                	push   $0x0
  pushl $168
80108cfa:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108cff:	e9 54 f3 ff ff       	jmp    80108058 <alltraps>

80108d04 <vector169>:
.globl vector169
vector169:
  pushl $0
80108d04:	6a 00                	push   $0x0
  pushl $169
80108d06:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108d0b:	e9 48 f3 ff ff       	jmp    80108058 <alltraps>

80108d10 <vector170>:
.globl vector170
vector170:
  pushl $0
80108d10:	6a 00                	push   $0x0
  pushl $170
80108d12:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108d17:	e9 3c f3 ff ff       	jmp    80108058 <alltraps>

80108d1c <vector171>:
.globl vector171
vector171:
  pushl $0
80108d1c:	6a 00                	push   $0x0
  pushl $171
80108d1e:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108d23:	e9 30 f3 ff ff       	jmp    80108058 <alltraps>

80108d28 <vector172>:
.globl vector172
vector172:
  pushl $0
80108d28:	6a 00                	push   $0x0
  pushl $172
80108d2a:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108d2f:	e9 24 f3 ff ff       	jmp    80108058 <alltraps>

80108d34 <vector173>:
.globl vector173
vector173:
  pushl $0
80108d34:	6a 00                	push   $0x0
  pushl $173
80108d36:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108d3b:	e9 18 f3 ff ff       	jmp    80108058 <alltraps>

80108d40 <vector174>:
.globl vector174
vector174:
  pushl $0
80108d40:	6a 00                	push   $0x0
  pushl $174
80108d42:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108d47:	e9 0c f3 ff ff       	jmp    80108058 <alltraps>

80108d4c <vector175>:
.globl vector175
vector175:
  pushl $0
80108d4c:	6a 00                	push   $0x0
  pushl $175
80108d4e:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108d53:	e9 00 f3 ff ff       	jmp    80108058 <alltraps>

80108d58 <vector176>:
.globl vector176
vector176:
  pushl $0
80108d58:	6a 00                	push   $0x0
  pushl $176
80108d5a:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108d5f:	e9 f4 f2 ff ff       	jmp    80108058 <alltraps>

80108d64 <vector177>:
.globl vector177
vector177:
  pushl $0
80108d64:	6a 00                	push   $0x0
  pushl $177
80108d66:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108d6b:	e9 e8 f2 ff ff       	jmp    80108058 <alltraps>

80108d70 <vector178>:
.globl vector178
vector178:
  pushl $0
80108d70:	6a 00                	push   $0x0
  pushl $178
80108d72:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108d77:	e9 dc f2 ff ff       	jmp    80108058 <alltraps>

80108d7c <vector179>:
.globl vector179
vector179:
  pushl $0
80108d7c:	6a 00                	push   $0x0
  pushl $179
80108d7e:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108d83:	e9 d0 f2 ff ff       	jmp    80108058 <alltraps>

80108d88 <vector180>:
.globl vector180
vector180:
  pushl $0
80108d88:	6a 00                	push   $0x0
  pushl $180
80108d8a:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108d8f:	e9 c4 f2 ff ff       	jmp    80108058 <alltraps>

80108d94 <vector181>:
.globl vector181
vector181:
  pushl $0
80108d94:	6a 00                	push   $0x0
  pushl $181
80108d96:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108d9b:	e9 b8 f2 ff ff       	jmp    80108058 <alltraps>

80108da0 <vector182>:
.globl vector182
vector182:
  pushl $0
80108da0:	6a 00                	push   $0x0
  pushl $182
80108da2:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108da7:	e9 ac f2 ff ff       	jmp    80108058 <alltraps>

80108dac <vector183>:
.globl vector183
vector183:
  pushl $0
80108dac:	6a 00                	push   $0x0
  pushl $183
80108dae:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108db3:	e9 a0 f2 ff ff       	jmp    80108058 <alltraps>

80108db8 <vector184>:
.globl vector184
vector184:
  pushl $0
80108db8:	6a 00                	push   $0x0
  pushl $184
80108dba:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108dbf:	e9 94 f2 ff ff       	jmp    80108058 <alltraps>

80108dc4 <vector185>:
.globl vector185
vector185:
  pushl $0
80108dc4:	6a 00                	push   $0x0
  pushl $185
80108dc6:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108dcb:	e9 88 f2 ff ff       	jmp    80108058 <alltraps>

80108dd0 <vector186>:
.globl vector186
vector186:
  pushl $0
80108dd0:	6a 00                	push   $0x0
  pushl $186
80108dd2:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108dd7:	e9 7c f2 ff ff       	jmp    80108058 <alltraps>

80108ddc <vector187>:
.globl vector187
vector187:
  pushl $0
80108ddc:	6a 00                	push   $0x0
  pushl $187
80108dde:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108de3:	e9 70 f2 ff ff       	jmp    80108058 <alltraps>

80108de8 <vector188>:
.globl vector188
vector188:
  pushl $0
80108de8:	6a 00                	push   $0x0
  pushl $188
80108dea:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108def:	e9 64 f2 ff ff       	jmp    80108058 <alltraps>

80108df4 <vector189>:
.globl vector189
vector189:
  pushl $0
80108df4:	6a 00                	push   $0x0
  pushl $189
80108df6:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108dfb:	e9 58 f2 ff ff       	jmp    80108058 <alltraps>

80108e00 <vector190>:
.globl vector190
vector190:
  pushl $0
80108e00:	6a 00                	push   $0x0
  pushl $190
80108e02:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108e07:	e9 4c f2 ff ff       	jmp    80108058 <alltraps>

80108e0c <vector191>:
.globl vector191
vector191:
  pushl $0
80108e0c:	6a 00                	push   $0x0
  pushl $191
80108e0e:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108e13:	e9 40 f2 ff ff       	jmp    80108058 <alltraps>

80108e18 <vector192>:
.globl vector192
vector192:
  pushl $0
80108e18:	6a 00                	push   $0x0
  pushl $192
80108e1a:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108e1f:	e9 34 f2 ff ff       	jmp    80108058 <alltraps>

80108e24 <vector193>:
.globl vector193
vector193:
  pushl $0
80108e24:	6a 00                	push   $0x0
  pushl $193
80108e26:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108e2b:	e9 28 f2 ff ff       	jmp    80108058 <alltraps>

80108e30 <vector194>:
.globl vector194
vector194:
  pushl $0
80108e30:	6a 00                	push   $0x0
  pushl $194
80108e32:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108e37:	e9 1c f2 ff ff       	jmp    80108058 <alltraps>

80108e3c <vector195>:
.globl vector195
vector195:
  pushl $0
80108e3c:	6a 00                	push   $0x0
  pushl $195
80108e3e:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108e43:	e9 10 f2 ff ff       	jmp    80108058 <alltraps>

80108e48 <vector196>:
.globl vector196
vector196:
  pushl $0
80108e48:	6a 00                	push   $0x0
  pushl $196
80108e4a:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108e4f:	e9 04 f2 ff ff       	jmp    80108058 <alltraps>

80108e54 <vector197>:
.globl vector197
vector197:
  pushl $0
80108e54:	6a 00                	push   $0x0
  pushl $197
80108e56:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108e5b:	e9 f8 f1 ff ff       	jmp    80108058 <alltraps>

80108e60 <vector198>:
.globl vector198
vector198:
  pushl $0
80108e60:	6a 00                	push   $0x0
  pushl $198
80108e62:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108e67:	e9 ec f1 ff ff       	jmp    80108058 <alltraps>

80108e6c <vector199>:
.globl vector199
vector199:
  pushl $0
80108e6c:	6a 00                	push   $0x0
  pushl $199
80108e6e:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108e73:	e9 e0 f1 ff ff       	jmp    80108058 <alltraps>

80108e78 <vector200>:
.globl vector200
vector200:
  pushl $0
80108e78:	6a 00                	push   $0x0
  pushl $200
80108e7a:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108e7f:	e9 d4 f1 ff ff       	jmp    80108058 <alltraps>

80108e84 <vector201>:
.globl vector201
vector201:
  pushl $0
80108e84:	6a 00                	push   $0x0
  pushl $201
80108e86:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108e8b:	e9 c8 f1 ff ff       	jmp    80108058 <alltraps>

80108e90 <vector202>:
.globl vector202
vector202:
  pushl $0
80108e90:	6a 00                	push   $0x0
  pushl $202
80108e92:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108e97:	e9 bc f1 ff ff       	jmp    80108058 <alltraps>

80108e9c <vector203>:
.globl vector203
vector203:
  pushl $0
80108e9c:	6a 00                	push   $0x0
  pushl $203
80108e9e:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108ea3:	e9 b0 f1 ff ff       	jmp    80108058 <alltraps>

80108ea8 <vector204>:
.globl vector204
vector204:
  pushl $0
80108ea8:	6a 00                	push   $0x0
  pushl $204
80108eaa:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108eaf:	e9 a4 f1 ff ff       	jmp    80108058 <alltraps>

80108eb4 <vector205>:
.globl vector205
vector205:
  pushl $0
80108eb4:	6a 00                	push   $0x0
  pushl $205
80108eb6:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108ebb:	e9 98 f1 ff ff       	jmp    80108058 <alltraps>

80108ec0 <vector206>:
.globl vector206
vector206:
  pushl $0
80108ec0:	6a 00                	push   $0x0
  pushl $206
80108ec2:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80108ec7:	e9 8c f1 ff ff       	jmp    80108058 <alltraps>

80108ecc <vector207>:
.globl vector207
vector207:
  pushl $0
80108ecc:	6a 00                	push   $0x0
  pushl $207
80108ece:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108ed3:	e9 80 f1 ff ff       	jmp    80108058 <alltraps>

80108ed8 <vector208>:
.globl vector208
vector208:
  pushl $0
80108ed8:	6a 00                	push   $0x0
  pushl $208
80108eda:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108edf:	e9 74 f1 ff ff       	jmp    80108058 <alltraps>

80108ee4 <vector209>:
.globl vector209
vector209:
  pushl $0
80108ee4:	6a 00                	push   $0x0
  pushl $209
80108ee6:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80108eeb:	e9 68 f1 ff ff       	jmp    80108058 <alltraps>

80108ef0 <vector210>:
.globl vector210
vector210:
  pushl $0
80108ef0:	6a 00                	push   $0x0
  pushl $210
80108ef2:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80108ef7:	e9 5c f1 ff ff       	jmp    80108058 <alltraps>

80108efc <vector211>:
.globl vector211
vector211:
  pushl $0
80108efc:	6a 00                	push   $0x0
  pushl $211
80108efe:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108f03:	e9 50 f1 ff ff       	jmp    80108058 <alltraps>

80108f08 <vector212>:
.globl vector212
vector212:
  pushl $0
80108f08:	6a 00                	push   $0x0
  pushl $212
80108f0a:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108f0f:	e9 44 f1 ff ff       	jmp    80108058 <alltraps>

80108f14 <vector213>:
.globl vector213
vector213:
  pushl $0
80108f14:	6a 00                	push   $0x0
  pushl $213
80108f16:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80108f1b:	e9 38 f1 ff ff       	jmp    80108058 <alltraps>

80108f20 <vector214>:
.globl vector214
vector214:
  pushl $0
80108f20:	6a 00                	push   $0x0
  pushl $214
80108f22:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80108f27:	e9 2c f1 ff ff       	jmp    80108058 <alltraps>

80108f2c <vector215>:
.globl vector215
vector215:
  pushl $0
80108f2c:	6a 00                	push   $0x0
  pushl $215
80108f2e:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80108f33:	e9 20 f1 ff ff       	jmp    80108058 <alltraps>

80108f38 <vector216>:
.globl vector216
vector216:
  pushl $0
80108f38:	6a 00                	push   $0x0
  pushl $216
80108f3a:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80108f3f:	e9 14 f1 ff ff       	jmp    80108058 <alltraps>

80108f44 <vector217>:
.globl vector217
vector217:
  pushl $0
80108f44:	6a 00                	push   $0x0
  pushl $217
80108f46:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80108f4b:	e9 08 f1 ff ff       	jmp    80108058 <alltraps>

80108f50 <vector218>:
.globl vector218
vector218:
  pushl $0
80108f50:	6a 00                	push   $0x0
  pushl $218
80108f52:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80108f57:	e9 fc f0 ff ff       	jmp    80108058 <alltraps>

80108f5c <vector219>:
.globl vector219
vector219:
  pushl $0
80108f5c:	6a 00                	push   $0x0
  pushl $219
80108f5e:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80108f63:	e9 f0 f0 ff ff       	jmp    80108058 <alltraps>

80108f68 <vector220>:
.globl vector220
vector220:
  pushl $0
80108f68:	6a 00                	push   $0x0
  pushl $220
80108f6a:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80108f6f:	e9 e4 f0 ff ff       	jmp    80108058 <alltraps>

80108f74 <vector221>:
.globl vector221
vector221:
  pushl $0
80108f74:	6a 00                	push   $0x0
  pushl $221
80108f76:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80108f7b:	e9 d8 f0 ff ff       	jmp    80108058 <alltraps>

80108f80 <vector222>:
.globl vector222
vector222:
  pushl $0
80108f80:	6a 00                	push   $0x0
  pushl $222
80108f82:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80108f87:	e9 cc f0 ff ff       	jmp    80108058 <alltraps>

80108f8c <vector223>:
.globl vector223
vector223:
  pushl $0
80108f8c:	6a 00                	push   $0x0
  pushl $223
80108f8e:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108f93:	e9 c0 f0 ff ff       	jmp    80108058 <alltraps>

80108f98 <vector224>:
.globl vector224
vector224:
  pushl $0
80108f98:	6a 00                	push   $0x0
  pushl $224
80108f9a:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108f9f:	e9 b4 f0 ff ff       	jmp    80108058 <alltraps>

80108fa4 <vector225>:
.globl vector225
vector225:
  pushl $0
80108fa4:	6a 00                	push   $0x0
  pushl $225
80108fa6:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80108fab:	e9 a8 f0 ff ff       	jmp    80108058 <alltraps>

80108fb0 <vector226>:
.globl vector226
vector226:
  pushl $0
80108fb0:	6a 00                	push   $0x0
  pushl $226
80108fb2:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80108fb7:	e9 9c f0 ff ff       	jmp    80108058 <alltraps>

80108fbc <vector227>:
.globl vector227
vector227:
  pushl $0
80108fbc:	6a 00                	push   $0x0
  pushl $227
80108fbe:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108fc3:	e9 90 f0 ff ff       	jmp    80108058 <alltraps>

80108fc8 <vector228>:
.globl vector228
vector228:
  pushl $0
80108fc8:	6a 00                	push   $0x0
  pushl $228
80108fca:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108fcf:	e9 84 f0 ff ff       	jmp    80108058 <alltraps>

80108fd4 <vector229>:
.globl vector229
vector229:
  pushl $0
80108fd4:	6a 00                	push   $0x0
  pushl $229
80108fd6:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80108fdb:	e9 78 f0 ff ff       	jmp    80108058 <alltraps>

80108fe0 <vector230>:
.globl vector230
vector230:
  pushl $0
80108fe0:	6a 00                	push   $0x0
  pushl $230
80108fe2:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80108fe7:	e9 6c f0 ff ff       	jmp    80108058 <alltraps>

80108fec <vector231>:
.globl vector231
vector231:
  pushl $0
80108fec:	6a 00                	push   $0x0
  pushl $231
80108fee:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108ff3:	e9 60 f0 ff ff       	jmp    80108058 <alltraps>

80108ff8 <vector232>:
.globl vector232
vector232:
  pushl $0
80108ff8:	6a 00                	push   $0x0
  pushl $232
80108ffa:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108fff:	e9 54 f0 ff ff       	jmp    80108058 <alltraps>

80109004 <vector233>:
.globl vector233
vector233:
  pushl $0
80109004:	6a 00                	push   $0x0
  pushl $233
80109006:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010900b:	e9 48 f0 ff ff       	jmp    80108058 <alltraps>

80109010 <vector234>:
.globl vector234
vector234:
  pushl $0
80109010:	6a 00                	push   $0x0
  pushl $234
80109012:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80109017:	e9 3c f0 ff ff       	jmp    80108058 <alltraps>

8010901c <vector235>:
.globl vector235
vector235:
  pushl $0
8010901c:	6a 00                	push   $0x0
  pushl $235
8010901e:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80109023:	e9 30 f0 ff ff       	jmp    80108058 <alltraps>

80109028 <vector236>:
.globl vector236
vector236:
  pushl $0
80109028:	6a 00                	push   $0x0
  pushl $236
8010902a:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010902f:	e9 24 f0 ff ff       	jmp    80108058 <alltraps>

80109034 <vector237>:
.globl vector237
vector237:
  pushl $0
80109034:	6a 00                	push   $0x0
  pushl $237
80109036:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010903b:	e9 18 f0 ff ff       	jmp    80108058 <alltraps>

80109040 <vector238>:
.globl vector238
vector238:
  pushl $0
80109040:	6a 00                	push   $0x0
  pushl $238
80109042:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80109047:	e9 0c f0 ff ff       	jmp    80108058 <alltraps>

8010904c <vector239>:
.globl vector239
vector239:
  pushl $0
8010904c:	6a 00                	push   $0x0
  pushl $239
8010904e:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80109053:	e9 00 f0 ff ff       	jmp    80108058 <alltraps>

80109058 <vector240>:
.globl vector240
vector240:
  pushl $0
80109058:	6a 00                	push   $0x0
  pushl $240
8010905a:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010905f:	e9 f4 ef ff ff       	jmp    80108058 <alltraps>

80109064 <vector241>:
.globl vector241
vector241:
  pushl $0
80109064:	6a 00                	push   $0x0
  pushl $241
80109066:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010906b:	e9 e8 ef ff ff       	jmp    80108058 <alltraps>

80109070 <vector242>:
.globl vector242
vector242:
  pushl $0
80109070:	6a 00                	push   $0x0
  pushl $242
80109072:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80109077:	e9 dc ef ff ff       	jmp    80108058 <alltraps>

8010907c <vector243>:
.globl vector243
vector243:
  pushl $0
8010907c:	6a 00                	push   $0x0
  pushl $243
8010907e:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80109083:	e9 d0 ef ff ff       	jmp    80108058 <alltraps>

80109088 <vector244>:
.globl vector244
vector244:
  pushl $0
80109088:	6a 00                	push   $0x0
  pushl $244
8010908a:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010908f:	e9 c4 ef ff ff       	jmp    80108058 <alltraps>

80109094 <vector245>:
.globl vector245
vector245:
  pushl $0
80109094:	6a 00                	push   $0x0
  pushl $245
80109096:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010909b:	e9 b8 ef ff ff       	jmp    80108058 <alltraps>

801090a0 <vector246>:
.globl vector246
vector246:
  pushl $0
801090a0:	6a 00                	push   $0x0
  pushl $246
801090a2:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801090a7:	e9 ac ef ff ff       	jmp    80108058 <alltraps>

801090ac <vector247>:
.globl vector247
vector247:
  pushl $0
801090ac:	6a 00                	push   $0x0
  pushl $247
801090ae:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801090b3:	e9 a0 ef ff ff       	jmp    80108058 <alltraps>

801090b8 <vector248>:
.globl vector248
vector248:
  pushl $0
801090b8:	6a 00                	push   $0x0
  pushl $248
801090ba:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801090bf:	e9 94 ef ff ff       	jmp    80108058 <alltraps>

801090c4 <vector249>:
.globl vector249
vector249:
  pushl $0
801090c4:	6a 00                	push   $0x0
  pushl $249
801090c6:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801090cb:	e9 88 ef ff ff       	jmp    80108058 <alltraps>

801090d0 <vector250>:
.globl vector250
vector250:
  pushl $0
801090d0:	6a 00                	push   $0x0
  pushl $250
801090d2:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801090d7:	e9 7c ef ff ff       	jmp    80108058 <alltraps>

801090dc <vector251>:
.globl vector251
vector251:
  pushl $0
801090dc:	6a 00                	push   $0x0
  pushl $251
801090de:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801090e3:	e9 70 ef ff ff       	jmp    80108058 <alltraps>

801090e8 <vector252>:
.globl vector252
vector252:
  pushl $0
801090e8:	6a 00                	push   $0x0
  pushl $252
801090ea:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801090ef:	e9 64 ef ff ff       	jmp    80108058 <alltraps>

801090f4 <vector253>:
.globl vector253
vector253:
  pushl $0
801090f4:	6a 00                	push   $0x0
  pushl $253
801090f6:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801090fb:	e9 58 ef ff ff       	jmp    80108058 <alltraps>

80109100 <vector254>:
.globl vector254
vector254:
  pushl $0
80109100:	6a 00                	push   $0x0
  pushl $254
80109102:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80109107:	e9 4c ef ff ff       	jmp    80108058 <alltraps>

8010910c <vector255>:
.globl vector255
vector255:
  pushl $0
8010910c:	6a 00                	push   $0x0
  pushl $255
8010910e:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80109113:	e9 40 ef ff ff       	jmp    80108058 <alltraps>

80109118 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80109118:	55                   	push   %ebp
80109119:	89 e5                	mov    %esp,%ebp
8010911b:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010911e:	8b 45 0c             	mov    0xc(%ebp),%eax
80109121:	83 e8 01             	sub    $0x1,%eax
80109124:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80109128:	8b 45 08             	mov    0x8(%ebp),%eax
8010912b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010912f:	8b 45 08             	mov    0x8(%ebp),%eax
80109132:	c1 e8 10             	shr    $0x10,%eax
80109135:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80109139:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010913c:	0f 01 10             	lgdtl  (%eax)
}
8010913f:	90                   	nop
80109140:	c9                   	leave  
80109141:	c3                   	ret    

80109142 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80109142:	55                   	push   %ebp
80109143:	89 e5                	mov    %esp,%ebp
80109145:	83 ec 04             	sub    $0x4,%esp
80109148:	8b 45 08             	mov    0x8(%ebp),%eax
8010914b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010914f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109153:	0f 00 d8             	ltr    %ax
}
80109156:	90                   	nop
80109157:	c9                   	leave  
80109158:	c3                   	ret    

80109159 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80109159:	55                   	push   %ebp
8010915a:	89 e5                	mov    %esp,%ebp
8010915c:	83 ec 04             	sub    $0x4,%esp
8010915f:	8b 45 08             	mov    0x8(%ebp),%eax
80109162:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80109166:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010916a:	8e e8                	mov    %eax,%gs
}
8010916c:	90                   	nop
8010916d:	c9                   	leave  
8010916e:	c3                   	ret    

8010916f <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
8010916f:	55                   	push   %ebp
80109170:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80109172:	8b 45 08             	mov    0x8(%ebp),%eax
80109175:	0f 22 d8             	mov    %eax,%cr3
}
80109178:	90                   	nop
80109179:	5d                   	pop    %ebp
8010917a:	c3                   	ret    

8010917b <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010917b:	55                   	push   %ebp
8010917c:	89 e5                	mov    %esp,%ebp
8010917e:	8b 45 08             	mov    0x8(%ebp),%eax
80109181:	05 00 00 00 80       	add    $0x80000000,%eax
80109186:	5d                   	pop    %ebp
80109187:	c3                   	ret    

80109188 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80109188:	55                   	push   %ebp
80109189:	89 e5                	mov    %esp,%ebp
8010918b:	8b 45 08             	mov    0x8(%ebp),%eax
8010918e:	05 00 00 00 80       	add    $0x80000000,%eax
80109193:	5d                   	pop    %ebp
80109194:	c3                   	ret    

80109195 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80109195:	55                   	push   %ebp
80109196:	89 e5                	mov    %esp,%ebp
80109198:	53                   	push   %ebx
80109199:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010919c:	e8 dc 9e ff ff       	call   8010307d <cpunum>
801091a1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801091a7:	05 80 43 11 80       	add    $0x80114380,%eax
801091ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801091af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091b2:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801091b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091bb:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801091c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091c4:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801091c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091cb:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801091cf:	83 e2 f0             	and    $0xfffffff0,%edx
801091d2:	83 ca 0a             	or     $0xa,%edx
801091d5:	88 50 7d             	mov    %dl,0x7d(%eax)
801091d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091db:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801091df:	83 ca 10             	or     $0x10,%edx
801091e2:	88 50 7d             	mov    %dl,0x7d(%eax)
801091e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091e8:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801091ec:	83 e2 9f             	and    $0xffffff9f,%edx
801091ef:	88 50 7d             	mov    %dl,0x7d(%eax)
801091f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801091f5:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801091f9:	83 ca 80             	or     $0xffffff80,%edx
801091fc:	88 50 7d             	mov    %dl,0x7d(%eax)
801091ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109202:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109206:	83 ca 0f             	or     $0xf,%edx
80109209:	88 50 7e             	mov    %dl,0x7e(%eax)
8010920c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010920f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109213:	83 e2 ef             	and    $0xffffffef,%edx
80109216:	88 50 7e             	mov    %dl,0x7e(%eax)
80109219:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010921c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109220:	83 e2 df             	and    $0xffffffdf,%edx
80109223:	88 50 7e             	mov    %dl,0x7e(%eax)
80109226:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109229:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010922d:	83 ca 40             	or     $0x40,%edx
80109230:	88 50 7e             	mov    %dl,0x7e(%eax)
80109233:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109236:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010923a:	83 ca 80             	or     $0xffffff80,%edx
8010923d:	88 50 7e             	mov    %dl,0x7e(%eax)
80109240:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109243:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80109247:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010924a:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80109251:	ff ff 
80109253:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109256:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010925d:	00 00 
8010925f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109262:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80109269:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010926c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109273:	83 e2 f0             	and    $0xfffffff0,%edx
80109276:	83 ca 02             	or     $0x2,%edx
80109279:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010927f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109282:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109289:	83 ca 10             	or     $0x10,%edx
8010928c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109292:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109295:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010929c:	83 e2 9f             	and    $0xffffff9f,%edx
8010929f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801092a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092a8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801092af:	83 ca 80             	or     $0xffffff80,%edx
801092b2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801092b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092bb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801092c2:	83 ca 0f             	or     $0xf,%edx
801092c5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801092cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092ce:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801092d5:	83 e2 ef             	and    $0xffffffef,%edx
801092d8:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801092de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092e1:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801092e8:	83 e2 df             	and    $0xffffffdf,%edx
801092eb:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801092f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092f4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801092fb:	83 ca 40             	or     $0x40,%edx
801092fe:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109307:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010930e:	83 ca 80             	or     $0xffffff80,%edx
80109311:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109317:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010931a:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80109321:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109324:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010932b:	ff ff 
8010932d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109330:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80109337:	00 00 
80109339:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010933c:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80109343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109346:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010934d:	83 e2 f0             	and    $0xfffffff0,%edx
80109350:	83 ca 0a             	or     $0xa,%edx
80109353:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109359:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010935c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109363:	83 ca 10             	or     $0x10,%edx
80109366:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010936c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010936f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109376:	83 ca 60             	or     $0x60,%edx
80109379:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010937f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109382:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109389:	83 ca 80             	or     $0xffffff80,%edx
8010938c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109395:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010939c:	83 ca 0f             	or     $0xf,%edx
8010939f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093a8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093af:	83 e2 ef             	and    $0xffffffef,%edx
801093b2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093bb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093c2:	83 e2 df             	and    $0xffffffdf,%edx
801093c5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093ce:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093d5:	83 ca 40             	or     $0x40,%edx
801093d8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093e1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801093e8:	83 ca 80             	or     $0xffffff80,%edx
801093eb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801093f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093f4:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801093fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093fe:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80109405:	ff ff 
80109407:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010940a:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80109411:	00 00 
80109413:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109416:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010941d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109420:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109427:	83 e2 f0             	and    $0xfffffff0,%edx
8010942a:	83 ca 02             	or     $0x2,%edx
8010942d:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109433:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109436:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010943d:	83 ca 10             	or     $0x10,%edx
80109440:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109446:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109449:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109450:	83 ca 60             	or     $0x60,%edx
80109453:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010945c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109463:	83 ca 80             	or     $0xffffff80,%edx
80109466:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010946c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010946f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109476:	83 ca 0f             	or     $0xf,%edx
80109479:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010947f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109482:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109489:	83 e2 ef             	and    $0xffffffef,%edx
8010948c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109495:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010949c:	83 e2 df             	and    $0xffffffdf,%edx
8010949f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094a8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094af:	83 ca 40             	or     $0x40,%edx
801094b2:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094bb:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801094c2:	83 ca 80             	or     $0xffffff80,%edx
801094c5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801094cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ce:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801094d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094d8:	05 b4 00 00 00       	add    $0xb4,%eax
801094dd:	89 c3                	mov    %eax,%ebx
801094df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094e2:	05 b4 00 00 00       	add    $0xb4,%eax
801094e7:	c1 e8 10             	shr    $0x10,%eax
801094ea:	89 c2                	mov    %eax,%edx
801094ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ef:	05 b4 00 00 00       	add    $0xb4,%eax
801094f4:	c1 e8 18             	shr    $0x18,%eax
801094f7:	89 c1                	mov    %eax,%ecx
801094f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094fc:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80109503:	00 00 
80109505:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109508:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
8010950f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109512:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80109518:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010951b:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109522:	83 e2 f0             	and    $0xfffffff0,%edx
80109525:	83 ca 02             	or     $0x2,%edx
80109528:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010952e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109531:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109538:	83 ca 10             	or     $0x10,%edx
8010953b:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109541:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109544:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010954b:	83 e2 9f             	and    $0xffffff9f,%edx
8010954e:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109554:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109557:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010955e:	83 ca 80             	or     $0xffffff80,%edx
80109561:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109567:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010956a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109571:	83 e2 f0             	and    $0xfffffff0,%edx
80109574:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010957a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010957d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109584:	83 e2 ef             	and    $0xffffffef,%edx
80109587:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010958d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109590:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109597:	83 e2 df             	and    $0xffffffdf,%edx
8010959a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095a3:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801095aa:	83 ca 40             	or     $0x40,%edx
801095ad:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095b6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801095bd:	83 ca 80             	or     $0xffffff80,%edx
801095c0:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801095c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095c9:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801095cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095d2:	83 c0 70             	add    $0x70,%eax
801095d5:	83 ec 08             	sub    $0x8,%esp
801095d8:	6a 38                	push   $0x38
801095da:	50                   	push   %eax
801095db:	e8 38 fb ff ff       	call   80109118 <lgdt>
801095e0:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
801095e3:	83 ec 0c             	sub    $0xc,%esp
801095e6:	6a 18                	push   $0x18
801095e8:	e8 6c fb ff ff       	call   80109159 <loadgs>
801095ed:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
801095f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f3:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801095f9:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80109600:	00 00 00 00 
}
80109604:	90                   	nop
80109605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109608:	c9                   	leave  
80109609:	c3                   	ret    

8010960a <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010960a:	55                   	push   %ebp
8010960b:	89 e5                	mov    %esp,%ebp
8010960d:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80109610:	8b 45 0c             	mov    0xc(%ebp),%eax
80109613:	c1 e8 16             	shr    $0x16,%eax
80109616:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010961d:	8b 45 08             	mov    0x8(%ebp),%eax
80109620:	01 d0                	add    %edx,%eax
80109622:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80109625:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109628:	8b 00                	mov    (%eax),%eax
8010962a:	83 e0 01             	and    $0x1,%eax
8010962d:	85 c0                	test   %eax,%eax
8010962f:	74 18                	je     80109649 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80109631:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109634:	8b 00                	mov    (%eax),%eax
80109636:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010963b:	50                   	push   %eax
8010963c:	e8 47 fb ff ff       	call   80109188 <p2v>
80109641:	83 c4 04             	add    $0x4,%esp
80109644:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109647:	eb 48                	jmp    80109691 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80109649:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010964d:	74 0e                	je     8010965d <walkpgdir+0x53>
8010964f:	e8 c3 96 ff ff       	call   80102d17 <kalloc>
80109654:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010965b:	75 07                	jne    80109664 <walkpgdir+0x5a>
      return 0;
8010965d:	b8 00 00 00 00       	mov    $0x0,%eax
80109662:	eb 44                	jmp    801096a8 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80109664:	83 ec 04             	sub    $0x4,%esp
80109667:	68 00 10 00 00       	push   $0x1000
8010966c:	6a 00                	push   $0x0
8010966e:	ff 75 f4             	pushl  -0xc(%ebp)
80109671:	e8 38 d4 ff ff       	call   80106aae <memset>
80109676:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80109679:	83 ec 0c             	sub    $0xc,%esp
8010967c:	ff 75 f4             	pushl  -0xc(%ebp)
8010967f:	e8 f7 fa ff ff       	call   8010917b <v2p>
80109684:	83 c4 10             	add    $0x10,%esp
80109687:	83 c8 07             	or     $0x7,%eax
8010968a:	89 c2                	mov    %eax,%edx
8010968c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010968f:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80109691:	8b 45 0c             	mov    0xc(%ebp),%eax
80109694:	c1 e8 0c             	shr    $0xc,%eax
80109697:	25 ff 03 00 00       	and    $0x3ff,%eax
8010969c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801096a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096a6:	01 d0                	add    %edx,%eax
}
801096a8:	c9                   	leave  
801096a9:	c3                   	ret    

801096aa <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801096aa:	55                   	push   %ebp
801096ab:	89 e5                	mov    %esp,%ebp
801096ad:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801096b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801096b3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801096bb:	8b 55 0c             	mov    0xc(%ebp),%edx
801096be:	8b 45 10             	mov    0x10(%ebp),%eax
801096c1:	01 d0                	add    %edx,%eax
801096c3:	83 e8 01             	sub    $0x1,%eax
801096c6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801096cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801096ce:	83 ec 04             	sub    $0x4,%esp
801096d1:	6a 01                	push   $0x1
801096d3:	ff 75 f4             	pushl  -0xc(%ebp)
801096d6:	ff 75 08             	pushl  0x8(%ebp)
801096d9:	e8 2c ff ff ff       	call   8010960a <walkpgdir>
801096de:	83 c4 10             	add    $0x10,%esp
801096e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
801096e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801096e8:	75 07                	jne    801096f1 <mappages+0x47>
      return -1;
801096ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801096ef:	eb 47                	jmp    80109738 <mappages+0x8e>
    if(*pte & PTE_P)
801096f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801096f4:	8b 00                	mov    (%eax),%eax
801096f6:	83 e0 01             	and    $0x1,%eax
801096f9:	85 c0                	test   %eax,%eax
801096fb:	74 0d                	je     8010970a <mappages+0x60>
      panic("remap");
801096fd:	83 ec 0c             	sub    $0xc,%esp
80109700:	68 74 ac 10 80       	push   $0x8010ac74
80109705:	e8 5c 6e ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
8010970a:	8b 45 18             	mov    0x18(%ebp),%eax
8010970d:	0b 45 14             	or     0x14(%ebp),%eax
80109710:	83 c8 01             	or     $0x1,%eax
80109713:	89 c2                	mov    %eax,%edx
80109715:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109718:	89 10                	mov    %edx,(%eax)
    if(a == last)
8010971a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010971d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109720:	74 10                	je     80109732 <mappages+0x88>
      break;
    a += PGSIZE;
80109722:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80109729:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80109730:	eb 9c                	jmp    801096ce <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80109732:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80109733:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109738:	c9                   	leave  
80109739:	c3                   	ret    

8010973a <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
8010973a:	55                   	push   %ebp
8010973b:	89 e5                	mov    %esp,%ebp
8010973d:	53                   	push   %ebx
8010973e:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80109741:	e8 d1 95 ff ff       	call   80102d17 <kalloc>
80109746:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010974d:	75 0a                	jne    80109759 <setupkvm+0x1f>
    return 0;
8010974f:	b8 00 00 00 00       	mov    $0x0,%eax
80109754:	e9 8e 00 00 00       	jmp    801097e7 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80109759:	83 ec 04             	sub    $0x4,%esp
8010975c:	68 00 10 00 00       	push   $0x1000
80109761:	6a 00                	push   $0x0
80109763:	ff 75 f0             	pushl  -0x10(%ebp)
80109766:	e8 43 d3 ff ff       	call   80106aae <memset>
8010976b:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010976e:	83 ec 0c             	sub    $0xc,%esp
80109771:	68 00 00 00 0e       	push   $0xe000000
80109776:	e8 0d fa ff ff       	call   80109188 <p2v>
8010977b:	83 c4 10             	add    $0x10,%esp
8010977e:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80109783:	76 0d                	jbe    80109792 <setupkvm+0x58>
    panic("PHYSTOP too high");
80109785:	83 ec 0c             	sub    $0xc,%esp
80109788:	68 7a ac 10 80       	push   $0x8010ac7a
8010978d:	e8 d4 6d ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109792:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
80109799:	eb 40                	jmp    801097db <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010979b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010979e:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801097a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097a4:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801097a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097aa:	8b 58 08             	mov    0x8(%eax),%ebx
801097ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097b0:	8b 40 04             	mov    0x4(%eax),%eax
801097b3:	29 c3                	sub    %eax,%ebx
801097b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097b8:	8b 00                	mov    (%eax),%eax
801097ba:	83 ec 0c             	sub    $0xc,%esp
801097bd:	51                   	push   %ecx
801097be:	52                   	push   %edx
801097bf:	53                   	push   %ebx
801097c0:	50                   	push   %eax
801097c1:	ff 75 f0             	pushl  -0x10(%ebp)
801097c4:	e8 e1 fe ff ff       	call   801096aa <mappages>
801097c9:	83 c4 20             	add    $0x20,%esp
801097cc:	85 c0                	test   %eax,%eax
801097ce:	79 07                	jns    801097d7 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
801097d0:	b8 00 00 00 00       	mov    $0x0,%eax
801097d5:	eb 10                	jmp    801097e7 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801097d7:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801097db:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
801097e2:	72 b7                	jb     8010979b <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801097e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801097e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801097ea:	c9                   	leave  
801097eb:	c3                   	ret    

801097ec <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801097ec:	55                   	push   %ebp
801097ed:	89 e5                	mov    %esp,%ebp
801097ef:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801097f2:	e8 43 ff ff ff       	call   8010973a <setupkvm>
801097f7:	a3 38 79 11 80       	mov    %eax,0x80117938
  switchkvm();
801097fc:	e8 03 00 00 00       	call   80109804 <switchkvm>
}
80109801:	90                   	nop
80109802:	c9                   	leave  
80109803:	c3                   	ret    

80109804 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109804:	55                   	push   %ebp
80109805:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109807:	a1 38 79 11 80       	mov    0x80117938,%eax
8010980c:	50                   	push   %eax
8010980d:	e8 69 f9 ff ff       	call   8010917b <v2p>
80109812:	83 c4 04             	add    $0x4,%esp
80109815:	50                   	push   %eax
80109816:	e8 54 f9 ff ff       	call   8010916f <lcr3>
8010981b:	83 c4 04             	add    $0x4,%esp
}
8010981e:	90                   	nop
8010981f:	c9                   	leave  
80109820:	c3                   	ret    

80109821 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80109821:	55                   	push   %ebp
80109822:	89 e5                	mov    %esp,%ebp
80109824:	56                   	push   %esi
80109825:	53                   	push   %ebx
  pushcli();
80109826:	e8 7d d1 ff ff       	call   801069a8 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010982b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109831:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109838:	83 c2 08             	add    $0x8,%edx
8010983b:	89 d6                	mov    %edx,%esi
8010983d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109844:	83 c2 08             	add    $0x8,%edx
80109847:	c1 ea 10             	shr    $0x10,%edx
8010984a:	89 d3                	mov    %edx,%ebx
8010984c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109853:	83 c2 08             	add    $0x8,%edx
80109856:	c1 ea 18             	shr    $0x18,%edx
80109859:	89 d1                	mov    %edx,%ecx
8010985b:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80109862:	67 00 
80109864:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
8010986b:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80109871:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109878:	83 e2 f0             	and    $0xfffffff0,%edx
8010987b:	83 ca 09             	or     $0x9,%edx
8010987e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109884:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010988b:	83 ca 10             	or     $0x10,%edx
8010988e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109894:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010989b:	83 e2 9f             	and    $0xffffff9f,%edx
8010989e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801098a4:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801098ab:	83 ca 80             	or     $0xffffff80,%edx
801098ae:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801098b4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098bb:	83 e2 f0             	and    $0xfffffff0,%edx
801098be:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801098c4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098cb:	83 e2 ef             	and    $0xffffffef,%edx
801098ce:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801098d4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098db:	83 e2 df             	and    $0xffffffdf,%edx
801098de:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801098e4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098eb:	83 ca 40             	or     $0x40,%edx
801098ee:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801098f4:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801098fb:	83 e2 7f             	and    $0x7f,%edx
801098fe:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109904:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010990a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109910:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109917:	83 e2 ef             	and    $0xffffffef,%edx
8010991a:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109920:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109926:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
8010992c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109932:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80109939:	8b 52 08             	mov    0x8(%edx),%edx
8010993c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109942:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109945:	83 ec 0c             	sub    $0xc,%esp
80109948:	6a 30                	push   $0x30
8010994a:	e8 f3 f7 ff ff       	call   80109142 <ltr>
8010994f:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109952:	8b 45 08             	mov    0x8(%ebp),%eax
80109955:	8b 40 04             	mov    0x4(%eax),%eax
80109958:	85 c0                	test   %eax,%eax
8010995a:	75 0d                	jne    80109969 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
8010995c:	83 ec 0c             	sub    $0xc,%esp
8010995f:	68 8b ac 10 80       	push   $0x8010ac8b
80109964:	e8 fd 6b ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80109969:	8b 45 08             	mov    0x8(%ebp),%eax
8010996c:	8b 40 04             	mov    0x4(%eax),%eax
8010996f:	83 ec 0c             	sub    $0xc,%esp
80109972:	50                   	push   %eax
80109973:	e8 03 f8 ff ff       	call   8010917b <v2p>
80109978:	83 c4 10             	add    $0x10,%esp
8010997b:	83 ec 0c             	sub    $0xc,%esp
8010997e:	50                   	push   %eax
8010997f:	e8 eb f7 ff ff       	call   8010916f <lcr3>
80109984:	83 c4 10             	add    $0x10,%esp
  popcli();
80109987:	e8 61 d0 ff ff       	call   801069ed <popcli>
}
8010998c:	90                   	nop
8010998d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109990:	5b                   	pop    %ebx
80109991:	5e                   	pop    %esi
80109992:	5d                   	pop    %ebp
80109993:	c3                   	ret    

80109994 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109994:	55                   	push   %ebp
80109995:	89 e5                	mov    %esp,%ebp
80109997:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010999a:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
801099a1:	76 0d                	jbe    801099b0 <inituvm+0x1c>
    panic("inituvm: more than a page");
801099a3:	83 ec 0c             	sub    $0xc,%esp
801099a6:	68 9f ac 10 80       	push   $0x8010ac9f
801099ab:	e8 b6 6b ff ff       	call   80100566 <panic>
  mem = kalloc();
801099b0:	e8 62 93 ff ff       	call   80102d17 <kalloc>
801099b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
801099b8:	83 ec 04             	sub    $0x4,%esp
801099bb:	68 00 10 00 00       	push   $0x1000
801099c0:	6a 00                	push   $0x0
801099c2:	ff 75 f4             	pushl  -0xc(%ebp)
801099c5:	e8 e4 d0 ff ff       	call   80106aae <memset>
801099ca:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
801099cd:	83 ec 0c             	sub    $0xc,%esp
801099d0:	ff 75 f4             	pushl  -0xc(%ebp)
801099d3:	e8 a3 f7 ff ff       	call   8010917b <v2p>
801099d8:	83 c4 10             	add    $0x10,%esp
801099db:	83 ec 0c             	sub    $0xc,%esp
801099de:	6a 06                	push   $0x6
801099e0:	50                   	push   %eax
801099e1:	68 00 10 00 00       	push   $0x1000
801099e6:	6a 00                	push   $0x0
801099e8:	ff 75 08             	pushl  0x8(%ebp)
801099eb:	e8 ba fc ff ff       	call   801096aa <mappages>
801099f0:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801099f3:	83 ec 04             	sub    $0x4,%esp
801099f6:	ff 75 10             	pushl  0x10(%ebp)
801099f9:	ff 75 0c             	pushl  0xc(%ebp)
801099fc:	ff 75 f4             	pushl  -0xc(%ebp)
801099ff:	e8 69 d1 ff ff       	call   80106b6d <memmove>
80109a04:	83 c4 10             	add    $0x10,%esp
}
80109a07:	90                   	nop
80109a08:	c9                   	leave  
80109a09:	c3                   	ret    

80109a0a <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80109a0a:	55                   	push   %ebp
80109a0b:	89 e5                	mov    %esp,%ebp
80109a0d:	53                   	push   %ebx
80109a0e:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109a11:	8b 45 0c             	mov    0xc(%ebp),%eax
80109a14:	25 ff 0f 00 00       	and    $0xfff,%eax
80109a19:	85 c0                	test   %eax,%eax
80109a1b:	74 0d                	je     80109a2a <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80109a1d:	83 ec 0c             	sub    $0xc,%esp
80109a20:	68 bc ac 10 80       	push   $0x8010acbc
80109a25:	e8 3c 6b ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109a2a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109a31:	e9 95 00 00 00       	jmp    80109acb <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109a36:	8b 55 0c             	mov    0xc(%ebp),%edx
80109a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a3c:	01 d0                	add    %edx,%eax
80109a3e:	83 ec 04             	sub    $0x4,%esp
80109a41:	6a 00                	push   $0x0
80109a43:	50                   	push   %eax
80109a44:	ff 75 08             	pushl  0x8(%ebp)
80109a47:	e8 be fb ff ff       	call   8010960a <walkpgdir>
80109a4c:	83 c4 10             	add    $0x10,%esp
80109a4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109a52:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109a56:	75 0d                	jne    80109a65 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109a58:	83 ec 0c             	sub    $0xc,%esp
80109a5b:	68 df ac 10 80       	push   $0x8010acdf
80109a60:	e8 01 6b ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109a65:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109a68:	8b 00                	mov    (%eax),%eax
80109a6a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109a6f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109a72:	8b 45 18             	mov    0x18(%ebp),%eax
80109a75:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109a78:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109a7d:	77 0b                	ja     80109a8a <loaduvm+0x80>
      n = sz - i;
80109a7f:	8b 45 18             	mov    0x18(%ebp),%eax
80109a82:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109a85:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109a88:	eb 07                	jmp    80109a91 <loaduvm+0x87>
    else
      n = PGSIZE;
80109a8a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109a91:	8b 55 14             	mov    0x14(%ebp),%edx
80109a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a97:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109a9a:	83 ec 0c             	sub    $0xc,%esp
80109a9d:	ff 75 e8             	pushl  -0x18(%ebp)
80109aa0:	e8 e3 f6 ff ff       	call   80109188 <p2v>
80109aa5:	83 c4 10             	add    $0x10,%esp
80109aa8:	ff 75 f0             	pushl  -0x10(%ebp)
80109aab:	53                   	push   %ebx
80109aac:	50                   	push   %eax
80109aad:	ff 75 10             	pushl  0x10(%ebp)
80109ab0:	e8 d4 84 ff ff       	call   80101f89 <readi>
80109ab5:	83 c4 10             	add    $0x10,%esp
80109ab8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109abb:	74 07                	je     80109ac4 <loaduvm+0xba>
      return -1;
80109abd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109ac2:	eb 18                	jmp    80109adc <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109ac4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ace:	3b 45 18             	cmp    0x18(%ebp),%eax
80109ad1:	0f 82 5f ff ff ff    	jb     80109a36 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109ad7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109adc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109adf:	c9                   	leave  
80109ae0:	c3                   	ret    

80109ae1 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109ae1:	55                   	push   %ebp
80109ae2:	89 e5                	mov    %esp,%ebp
80109ae4:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109ae7:	8b 45 10             	mov    0x10(%ebp),%eax
80109aea:	85 c0                	test   %eax,%eax
80109aec:	79 0a                	jns    80109af8 <allocuvm+0x17>
    return 0;
80109aee:	b8 00 00 00 00       	mov    $0x0,%eax
80109af3:	e9 b0 00 00 00       	jmp    80109ba8 <allocuvm+0xc7>
  if(newsz < oldsz)
80109af8:	8b 45 10             	mov    0x10(%ebp),%eax
80109afb:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109afe:	73 08                	jae    80109b08 <allocuvm+0x27>
    return oldsz;
80109b00:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b03:	e9 a0 00 00 00       	jmp    80109ba8 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109b08:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b0b:	05 ff 0f 00 00       	add    $0xfff,%eax
80109b10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109b18:	eb 7f                	jmp    80109b99 <allocuvm+0xb8>
    mem = kalloc();
80109b1a:	e8 f8 91 ff ff       	call   80102d17 <kalloc>
80109b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109b22:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109b26:	75 2b                	jne    80109b53 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109b28:	83 ec 0c             	sub    $0xc,%esp
80109b2b:	68 fd ac 10 80       	push   $0x8010acfd
80109b30:	e8 91 68 ff ff       	call   801003c6 <cprintf>
80109b35:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109b38:	83 ec 04             	sub    $0x4,%esp
80109b3b:	ff 75 0c             	pushl  0xc(%ebp)
80109b3e:	ff 75 10             	pushl  0x10(%ebp)
80109b41:	ff 75 08             	pushl  0x8(%ebp)
80109b44:	e8 61 00 00 00       	call   80109baa <deallocuvm>
80109b49:	83 c4 10             	add    $0x10,%esp
      return 0;
80109b4c:	b8 00 00 00 00       	mov    $0x0,%eax
80109b51:	eb 55                	jmp    80109ba8 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109b53:	83 ec 04             	sub    $0x4,%esp
80109b56:	68 00 10 00 00       	push   $0x1000
80109b5b:	6a 00                	push   $0x0
80109b5d:	ff 75 f0             	pushl  -0x10(%ebp)
80109b60:	e8 49 cf ff ff       	call   80106aae <memset>
80109b65:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109b68:	83 ec 0c             	sub    $0xc,%esp
80109b6b:	ff 75 f0             	pushl  -0x10(%ebp)
80109b6e:	e8 08 f6 ff ff       	call   8010917b <v2p>
80109b73:	83 c4 10             	add    $0x10,%esp
80109b76:	89 c2                	mov    %eax,%edx
80109b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b7b:	83 ec 0c             	sub    $0xc,%esp
80109b7e:	6a 06                	push   $0x6
80109b80:	52                   	push   %edx
80109b81:	68 00 10 00 00       	push   $0x1000
80109b86:	50                   	push   %eax
80109b87:	ff 75 08             	pushl  0x8(%ebp)
80109b8a:	e8 1b fb ff ff       	call   801096aa <mappages>
80109b8f:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109b92:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b9c:	3b 45 10             	cmp    0x10(%ebp),%eax
80109b9f:	0f 82 75 ff ff ff    	jb     80109b1a <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109ba5:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109ba8:	c9                   	leave  
80109ba9:	c3                   	ret    

80109baa <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109baa:	55                   	push   %ebp
80109bab:	89 e5                	mov    %esp,%ebp
80109bad:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109bb0:	8b 45 10             	mov    0x10(%ebp),%eax
80109bb3:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109bb6:	72 08                	jb     80109bc0 <deallocuvm+0x16>
    return oldsz;
80109bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
80109bbb:	e9 a5 00 00 00       	jmp    80109c65 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109bc0:	8b 45 10             	mov    0x10(%ebp),%eax
80109bc3:	05 ff 0f 00 00       	add    $0xfff,%eax
80109bc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109bd0:	e9 81 00 00 00       	jmp    80109c56 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bd8:	83 ec 04             	sub    $0x4,%esp
80109bdb:	6a 00                	push   $0x0
80109bdd:	50                   	push   %eax
80109bde:	ff 75 08             	pushl  0x8(%ebp)
80109be1:	e8 24 fa ff ff       	call   8010960a <walkpgdir>
80109be6:	83 c4 10             	add    $0x10,%esp
80109be9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109bec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109bf0:	75 09                	jne    80109bfb <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109bf2:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109bf9:	eb 54                	jmp    80109c4f <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109bfb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109bfe:	8b 00                	mov    (%eax),%eax
80109c00:	83 e0 01             	and    $0x1,%eax
80109c03:	85 c0                	test   %eax,%eax
80109c05:	74 48                	je     80109c4f <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c0a:	8b 00                	mov    (%eax),%eax
80109c0c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109c11:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109c14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109c18:	75 0d                	jne    80109c27 <deallocuvm+0x7d>
        panic("kfree");
80109c1a:	83 ec 0c             	sub    $0xc,%esp
80109c1d:	68 15 ad 10 80       	push   $0x8010ad15
80109c22:	e8 3f 69 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109c27:	83 ec 0c             	sub    $0xc,%esp
80109c2a:	ff 75 ec             	pushl  -0x14(%ebp)
80109c2d:	e8 56 f5 ff ff       	call   80109188 <p2v>
80109c32:	83 c4 10             	add    $0x10,%esp
80109c35:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109c38:	83 ec 0c             	sub    $0xc,%esp
80109c3b:	ff 75 e8             	pushl  -0x18(%ebp)
80109c3e:	e8 37 90 ff ff       	call   80102c7a <kfree>
80109c43:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109c49:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109c4f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c59:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109c5c:	0f 82 73 ff ff ff    	jb     80109bd5 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109c62:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109c65:	c9                   	leave  
80109c66:	c3                   	ret    

80109c67 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109c67:	55                   	push   %ebp
80109c68:	89 e5                	mov    %esp,%ebp
80109c6a:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109c6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109c71:	75 0d                	jne    80109c80 <freevm+0x19>
    panic("freevm: no pgdir");
80109c73:	83 ec 0c             	sub    $0xc,%esp
80109c76:	68 1b ad 10 80       	push   $0x8010ad1b
80109c7b:	e8 e6 68 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109c80:	83 ec 04             	sub    $0x4,%esp
80109c83:	6a 00                	push   $0x0
80109c85:	68 00 00 00 80       	push   $0x80000000
80109c8a:	ff 75 08             	pushl  0x8(%ebp)
80109c8d:	e8 18 ff ff ff       	call   80109baa <deallocuvm>
80109c92:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109c95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109c9c:	eb 4f                	jmp    80109ced <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ca1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109ca8:	8b 45 08             	mov    0x8(%ebp),%eax
80109cab:	01 d0                	add    %edx,%eax
80109cad:	8b 00                	mov    (%eax),%eax
80109caf:	83 e0 01             	and    $0x1,%eax
80109cb2:	85 c0                	test   %eax,%eax
80109cb4:	74 33                	je     80109ce9 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cb9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109cc0:	8b 45 08             	mov    0x8(%ebp),%eax
80109cc3:	01 d0                	add    %edx,%eax
80109cc5:	8b 00                	mov    (%eax),%eax
80109cc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109ccc:	83 ec 0c             	sub    $0xc,%esp
80109ccf:	50                   	push   %eax
80109cd0:	e8 b3 f4 ff ff       	call   80109188 <p2v>
80109cd5:	83 c4 10             	add    $0x10,%esp
80109cd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109cdb:	83 ec 0c             	sub    $0xc,%esp
80109cde:	ff 75 f0             	pushl  -0x10(%ebp)
80109ce1:	e8 94 8f ff ff       	call   80102c7a <kfree>
80109ce6:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109ce9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109ced:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109cf4:	76 a8                	jbe    80109c9e <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109cf6:	83 ec 0c             	sub    $0xc,%esp
80109cf9:	ff 75 08             	pushl  0x8(%ebp)
80109cfc:	e8 79 8f ff ff       	call   80102c7a <kfree>
80109d01:	83 c4 10             	add    $0x10,%esp
}
80109d04:	90                   	nop
80109d05:	c9                   	leave  
80109d06:	c3                   	ret    

80109d07 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109d07:	55                   	push   %ebp
80109d08:	89 e5                	mov    %esp,%ebp
80109d0a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109d0d:	83 ec 04             	sub    $0x4,%esp
80109d10:	6a 00                	push   $0x0
80109d12:	ff 75 0c             	pushl  0xc(%ebp)
80109d15:	ff 75 08             	pushl  0x8(%ebp)
80109d18:	e8 ed f8 ff ff       	call   8010960a <walkpgdir>
80109d1d:	83 c4 10             	add    $0x10,%esp
80109d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109d23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109d27:	75 0d                	jne    80109d36 <clearpteu+0x2f>
    panic("clearpteu");
80109d29:	83 ec 0c             	sub    $0xc,%esp
80109d2c:	68 2c ad 10 80       	push   $0x8010ad2c
80109d31:	e8 30 68 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d39:	8b 00                	mov    (%eax),%eax
80109d3b:	83 e0 fb             	and    $0xfffffffb,%eax
80109d3e:	89 c2                	mov    %eax,%edx
80109d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d43:	89 10                	mov    %edx,(%eax)
}
80109d45:	90                   	nop
80109d46:	c9                   	leave  
80109d47:	c3                   	ret    

80109d48 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109d48:	55                   	push   %ebp
80109d49:	89 e5                	mov    %esp,%ebp
80109d4b:	53                   	push   %ebx
80109d4c:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109d4f:	e8 e6 f9 ff ff       	call   8010973a <setupkvm>
80109d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109d57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109d5b:	75 0a                	jne    80109d67 <copyuvm+0x1f>
    return 0;
80109d5d:	b8 00 00 00 00       	mov    $0x0,%eax
80109d62:	e9 f8 00 00 00       	jmp    80109e5f <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109d67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109d6e:	e9 c4 00 00 00       	jmp    80109e37 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d76:	83 ec 04             	sub    $0x4,%esp
80109d79:	6a 00                	push   $0x0
80109d7b:	50                   	push   %eax
80109d7c:	ff 75 08             	pushl  0x8(%ebp)
80109d7f:	e8 86 f8 ff ff       	call   8010960a <walkpgdir>
80109d84:	83 c4 10             	add    $0x10,%esp
80109d87:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109d8a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109d8e:	75 0d                	jne    80109d9d <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109d90:	83 ec 0c             	sub    $0xc,%esp
80109d93:	68 36 ad 10 80       	push   $0x8010ad36
80109d98:	e8 c9 67 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109d9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109da0:	8b 00                	mov    (%eax),%eax
80109da2:	83 e0 01             	and    $0x1,%eax
80109da5:	85 c0                	test   %eax,%eax
80109da7:	75 0d                	jne    80109db6 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109da9:	83 ec 0c             	sub    $0xc,%esp
80109dac:	68 50 ad 10 80       	push   $0x8010ad50
80109db1:	e8 b0 67 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109db6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109db9:	8b 00                	mov    (%eax),%eax
80109dbb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109dc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109dc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109dc6:	8b 00                	mov    (%eax),%eax
80109dc8:	25 ff 0f 00 00       	and    $0xfff,%eax
80109dcd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109dd0:	e8 42 8f ff ff       	call   80102d17 <kalloc>
80109dd5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109dd8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109ddc:	74 6a                	je     80109e48 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109dde:	83 ec 0c             	sub    $0xc,%esp
80109de1:	ff 75 e8             	pushl  -0x18(%ebp)
80109de4:	e8 9f f3 ff ff       	call   80109188 <p2v>
80109de9:	83 c4 10             	add    $0x10,%esp
80109dec:	83 ec 04             	sub    $0x4,%esp
80109def:	68 00 10 00 00       	push   $0x1000
80109df4:	50                   	push   %eax
80109df5:	ff 75 e0             	pushl  -0x20(%ebp)
80109df8:	e8 70 cd ff ff       	call   80106b6d <memmove>
80109dfd:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109e00:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109e03:	83 ec 0c             	sub    $0xc,%esp
80109e06:	ff 75 e0             	pushl  -0x20(%ebp)
80109e09:	e8 6d f3 ff ff       	call   8010917b <v2p>
80109e0e:	83 c4 10             	add    $0x10,%esp
80109e11:	89 c2                	mov    %eax,%edx
80109e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e16:	83 ec 0c             	sub    $0xc,%esp
80109e19:	53                   	push   %ebx
80109e1a:	52                   	push   %edx
80109e1b:	68 00 10 00 00       	push   $0x1000
80109e20:	50                   	push   %eax
80109e21:	ff 75 f0             	pushl  -0x10(%ebp)
80109e24:	e8 81 f8 ff ff       	call   801096aa <mappages>
80109e29:	83 c4 20             	add    $0x20,%esp
80109e2c:	85 c0                	test   %eax,%eax
80109e2e:	78 1b                	js     80109e4b <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109e30:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e3a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109e3d:	0f 82 30 ff ff ff    	jb     80109d73 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109e46:	eb 17                	jmp    80109e5f <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109e48:	90                   	nop
80109e49:	eb 01                	jmp    80109e4c <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80109e4b:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80109e4c:	83 ec 0c             	sub    $0xc,%esp
80109e4f:	ff 75 f0             	pushl  -0x10(%ebp)
80109e52:	e8 10 fe ff ff       	call   80109c67 <freevm>
80109e57:	83 c4 10             	add    $0x10,%esp
  return 0;
80109e5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109e62:	c9                   	leave  
80109e63:	c3                   	ret    

80109e64 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109e64:	55                   	push   %ebp
80109e65:	89 e5                	mov    %esp,%ebp
80109e67:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109e6a:	83 ec 04             	sub    $0x4,%esp
80109e6d:	6a 00                	push   $0x0
80109e6f:	ff 75 0c             	pushl  0xc(%ebp)
80109e72:	ff 75 08             	pushl  0x8(%ebp)
80109e75:	e8 90 f7 ff ff       	call   8010960a <walkpgdir>
80109e7a:	83 c4 10             	add    $0x10,%esp
80109e7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e83:	8b 00                	mov    (%eax),%eax
80109e85:	83 e0 01             	and    $0x1,%eax
80109e88:	85 c0                	test   %eax,%eax
80109e8a:	75 07                	jne    80109e93 <uva2ka+0x2f>
    return 0;
80109e8c:	b8 00 00 00 00       	mov    $0x0,%eax
80109e91:	eb 29                	jmp    80109ebc <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e96:	8b 00                	mov    (%eax),%eax
80109e98:	83 e0 04             	and    $0x4,%eax
80109e9b:	85 c0                	test   %eax,%eax
80109e9d:	75 07                	jne    80109ea6 <uva2ka+0x42>
    return 0;
80109e9f:	b8 00 00 00 00       	mov    $0x0,%eax
80109ea4:	eb 16                	jmp    80109ebc <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80109ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ea9:	8b 00                	mov    (%eax),%eax
80109eab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109eb0:	83 ec 0c             	sub    $0xc,%esp
80109eb3:	50                   	push   %eax
80109eb4:	e8 cf f2 ff ff       	call   80109188 <p2v>
80109eb9:	83 c4 10             	add    $0x10,%esp
}
80109ebc:	c9                   	leave  
80109ebd:	c3                   	ret    

80109ebe <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109ebe:	55                   	push   %ebp
80109ebf:	89 e5                	mov    %esp,%ebp
80109ec1:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109ec4:	8b 45 10             	mov    0x10(%ebp),%eax
80109ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80109eca:	eb 7f                	jmp    80109f4b <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80109ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
80109ecf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109ed4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80109ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109eda:	83 ec 08             	sub    $0x8,%esp
80109edd:	50                   	push   %eax
80109ede:	ff 75 08             	pushl  0x8(%ebp)
80109ee1:	e8 7e ff ff ff       	call   80109e64 <uva2ka>
80109ee6:	83 c4 10             	add    $0x10,%esp
80109ee9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80109eec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109ef0:	75 07                	jne    80109ef9 <copyout+0x3b>
      return -1;
80109ef2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109ef7:	eb 61                	jmp    80109f5a <copyout+0x9c>
    n = PGSIZE - (va - va0);
80109ef9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109efc:	2b 45 0c             	sub    0xc(%ebp),%eax
80109eff:	05 00 10 00 00       	add    $0x1000,%eax
80109f04:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80109f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f0a:	3b 45 14             	cmp    0x14(%ebp),%eax
80109f0d:	76 06                	jbe    80109f15 <copyout+0x57>
      n = len;
80109f0f:	8b 45 14             	mov    0x14(%ebp),%eax
80109f12:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109f15:	8b 45 0c             	mov    0xc(%ebp),%eax
80109f18:	2b 45 ec             	sub    -0x14(%ebp),%eax
80109f1b:	89 c2                	mov    %eax,%edx
80109f1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80109f20:	01 d0                	add    %edx,%eax
80109f22:	83 ec 04             	sub    $0x4,%esp
80109f25:	ff 75 f0             	pushl  -0x10(%ebp)
80109f28:	ff 75 f4             	pushl  -0xc(%ebp)
80109f2b:	50                   	push   %eax
80109f2c:	e8 3c cc ff ff       	call   80106b6d <memmove>
80109f31:	83 c4 10             	add    $0x10,%esp
    len -= n;
80109f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f37:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80109f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f3d:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80109f40:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f43:	05 00 10 00 00       	add    $0x1000,%eax
80109f48:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80109f4b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80109f4f:	0f 85 77 ff ff ff    	jne    80109ecc <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80109f55:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109f5a:	c9                   	leave  
80109f5b:	c3                   	ret    
