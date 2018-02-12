
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
8010003d:	68 e0 97 10 80       	push   $0x801097e0
80100042:	68 80 e6 10 80       	push   $0x8010e680
80100047:	e8 cf 60 00 00       	call   8010611b <initlock>
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
801000c1:	e8 77 60 00 00       	call   8010613d <acquire>
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
8010010c:	e8 93 60 00 00       	call   801061a4 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 80 e6 10 80       	push   $0x8010e680
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 c7 52 00 00       	call   801053f3 <sleep>
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
80100188:	e8 17 60 00 00       	call   801061a4 <release>
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
801001aa:	68 e7 97 10 80       	push   $0x801097e7
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
80100204:	68 f8 97 10 80       	push   $0x801097f8
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
80100243:	68 ff 97 10 80       	push   $0x801097ff
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 80 e6 10 80       	push   $0x8010e680
80100255:	e8 e3 5e 00 00       	call   8010613d <acquire>
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
801002b9:	e8 fd 52 00 00       	call   801055bb <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 80 e6 10 80       	push   $0x8010e680
801002c9:	e8 d6 5e 00 00       	call   801061a4 <release>
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
801003e2:	e8 56 5d 00 00       	call   8010613d <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 06 98 10 80       	push   $0x80109806
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
801004cd:	c7 45 ec 0f 98 10 80 	movl   $0x8010980f,-0x14(%ebp)
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
8010055b:	e8 44 5c 00 00       	call   801061a4 <release>
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
8010058b:	68 16 98 10 80       	push   $0x80109816
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
801005aa:	68 25 98 10 80       	push   $0x80109825
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 2f 5c 00 00       	call   801061f6 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 27 98 10 80       	push   $0x80109827
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
801006ca:	68 2b 98 10 80       	push   $0x8010982b
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
801006f7:	e8 63 5d 00 00       	call   8010645f <memmove>
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
80100721:	e8 7a 5c 00 00       	call   801063a0 <memset>
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
801007b6:	e8 ae 76 00 00       	call   80107e69 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 a1 76 00 00       	call   80107e69 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 94 76 00 00       	call   80107e69 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 84 76 00 00       	call   80107e69 <uartputc>
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
80100815:	e8 23 59 00 00       	call   8010613d <acquire>
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
801009bf:	e8 f7 4b 00 00       	call   801055bb <wakeup>
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
801009e2:	e8 bd 57 00 00       	call   801061a4 <release>
801009e7:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009ee:	74 05                	je     801009f5 <consoleintr+0x1fc>
    procdump();  // now call procdump() wo. cons.lock held
801009f0:	e8 24 4f 00 00       	call   80105919 <procdump>
  }
#ifdef CS333_P3P4
  // run Ready list display function
  if (ctrlkey == 1) {
801009f5:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
801009f9:	75 0c                	jne    80100a07 <consoleintr+0x20e>
      //cprintf("Ready list not implemented yet..\n");
      printReadyList();
801009fb:	e8 a6 54 00 00       	call   80105ea6 <printReadyList>
      ctrlkey = 0;
80100a00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Free list display function
  if (ctrlkey == 2) {
80100a07:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
80100a0b:	75 0c                	jne    80100a19 <consoleintr+0x220>
      printFreeList();
80100a0d:	e8 21 55 00 00       	call   80105f33 <printFreeList>
      ctrlkey = 0;
80100a12:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Sleep list display function
  if (ctrlkey == 3) {
80100a19:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
80100a1d:	75 0c                	jne    80100a2b <consoleintr+0x232>
     // cprintf("Sleep list not implemented yet..\n");
      printSleepList();
80100a1f:	e8 6d 55 00 00       	call   80105f91 <printSleepList>
      ctrlkey = 0;
80100a24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Zombie list display function
  if (ctrlkey == 4) {
80100a2b:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a2f:	75 0c                	jne    80100a3d <consoleintr+0x244>
      //cprintf("Zombie list not implemented yet..\n");
      printZombieList();
80100a31:	e8 f8 55 00 00       	call   8010602e <printZombieList>
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
80100a62:	e8 d6 56 00 00       	call   8010613d <acquire>
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
80100a84:	e8 1b 57 00 00       	call   801061a4 <release>
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
80100ab1:	e8 3d 49 00 00       	call   801053f3 <sleep>
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
80100b2f:	e8 70 56 00 00       	call   801061a4 <release>
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
80100b6d:	e8 cb 55 00 00       	call   8010613d <acquire>
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
80100baf:	e8 f0 55 00 00       	call   801061a4 <release>
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
80100bd3:	68 3e 98 10 80       	push   $0x8010983e
80100bd8:	68 e0 d5 10 80       	push   $0x8010d5e0
80100bdd:	e8 39 55 00 00       	call   8010611b <initlock>
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
80100c9b:	e8 1e 83 00 00       	call   80108fbe <setupkvm>
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
80100d21:	e8 3f 86 00 00       	call   80109365 <allocuvm>
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
80100d54:	e8 35 85 00 00       	call   8010928e <loaduvm>
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
80100dc3:	e8 9d 85 00 00       	call   80109365 <allocuvm>
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
80100de7:	e8 9f 87 00 00       	call   8010958b <clearpteu>
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
80100e20:	e8 c8 57 00 00       	call   801065ed <strlen>
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
80100e4d:	e8 9b 57 00 00       	call   801065ed <strlen>
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
80100e73:	e8 ca 88 00 00       	call   80109742 <copyout>
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
80100f0f:	e8 2e 88 00 00       	call   80109742 <copyout>
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
80100f60:	e8 3e 56 00 00       	call   801065a3 <safestrcpy>
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
80100fb6:	e8 ea 80 00 00       	call   801090a5 <switchuvm>
80100fbb:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100fbe:	83 ec 0c             	sub    $0xc,%esp
80100fc1:	ff 75 d0             	pushl  -0x30(%ebp)
80100fc4:	e8 22 85 00 00       	call   801094eb <freevm>
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
80100ffe:	e8 e8 84 00 00       	call   801094eb <freevm>
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
8010102f:	68 46 98 10 80       	push   $0x80109846
80101034:	68 40 28 11 80       	push   $0x80112840
80101039:	e8 dd 50 00 00       	call   8010611b <initlock>
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
80101052:	e8 e6 50 00 00       	call   8010613d <acquire>
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
8010107f:	e8 20 51 00 00       	call   801061a4 <release>
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
801010a2:	e8 fd 50 00 00       	call   801061a4 <release>
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
801010bf:	e8 79 50 00 00       	call   8010613d <acquire>
801010c4:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801010c7:	8b 45 08             	mov    0x8(%ebp),%eax
801010ca:	8b 40 04             	mov    0x4(%eax),%eax
801010cd:	85 c0                	test   %eax,%eax
801010cf:	7f 0d                	jg     801010de <filedup+0x2d>
    panic("filedup");
801010d1:	83 ec 0c             	sub    $0xc,%esp
801010d4:	68 4d 98 10 80       	push   $0x8010984d
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
801010f5:	e8 aa 50 00 00       	call   801061a4 <release>
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
80101110:	e8 28 50 00 00       	call   8010613d <acquire>
80101115:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101118:	8b 45 08             	mov    0x8(%ebp),%eax
8010111b:	8b 40 04             	mov    0x4(%eax),%eax
8010111e:	85 c0                	test   %eax,%eax
80101120:	7f 0d                	jg     8010112f <fileclose+0x2d>
    panic("fileclose");
80101122:	83 ec 0c             	sub    $0xc,%esp
80101125:	68 55 98 10 80       	push   $0x80109855
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
80101150:	e8 4f 50 00 00       	call   801061a4 <release>
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
8010119e:	e8 01 50 00 00       	call   801061a4 <release>
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
801012ed:	68 5f 98 10 80       	push   $0x8010985f
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
801013f0:	68 68 98 10 80       	push   $0x80109868
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
80101426:	68 78 98 10 80       	push   $0x80109878
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
8010145e:	e8 fc 4f 00 00       	call   8010645f <memmove>
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
801014a4:	e8 f7 4e 00 00       	call   801063a0 <memset>
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
8010160b:	68 84 98 10 80       	push   $0x80109884
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
8010169e:	68 9a 98 10 80       	push   $0x8010989a
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
801016fb:	68 ad 98 10 80       	push   $0x801098ad
80101700:	68 60 32 11 80       	push   $0x80113260
80101705:	e8 11 4a 00 00       	call   8010611b <initlock>
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
80101754:	68 b4 98 10 80       	push   $0x801098b4
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
801017cd:	e8 ce 4b 00 00       	call   801063a0 <memset>
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
80101835:	68 07 99 10 80       	push   $0x80109907
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
801018db:	e8 7f 4b 00 00       	call   8010645f <memmove>
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
80101910:	e8 28 48 00 00       	call   8010613d <acquire>
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
8010195e:	e8 41 48 00 00       	call   801061a4 <release>
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
80101997:	68 19 99 10 80       	push   $0x80109919
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
801019d4:	e8 cb 47 00 00       	call   801061a4 <release>
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
801019ef:	e8 49 47 00 00       	call   8010613d <acquire>
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
80101a0e:	e8 91 47 00 00       	call   801061a4 <release>
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
80101a34:	68 29 99 10 80       	push   $0x80109929
80101a39:	e8 28 eb ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101a3e:	83 ec 0c             	sub    $0xc,%esp
80101a41:	68 60 32 11 80       	push   $0x80113260
80101a46:	e8 f2 46 00 00       	call   8010613d <acquire>
80101a4b:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101a4e:	eb 13                	jmp    80101a63 <ilock+0x48>
    sleep(ip, &icache.lock);
80101a50:	83 ec 08             	sub    $0x8,%esp
80101a53:	68 60 32 11 80       	push   $0x80113260
80101a58:	ff 75 08             	pushl  0x8(%ebp)
80101a5b:	e8 93 39 00 00       	call   801053f3 <sleep>
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
80101a89:	e8 16 47 00 00       	call   801061a4 <release>
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
80101b36:	e8 24 49 00 00       	call   8010645f <memmove>
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
80101b6c:	68 2f 99 10 80       	push   $0x8010992f
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
80101b9f:	68 3e 99 10 80       	push   $0x8010993e
80101ba4:	e8 bd e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101ba9:	83 ec 0c             	sub    $0xc,%esp
80101bac:	68 60 32 11 80       	push   $0x80113260
80101bb1:	e8 87 45 00 00       	call   8010613d <acquire>
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
80101bd0:	e8 e6 39 00 00       	call   801055bb <wakeup>
80101bd5:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101bd8:	83 ec 0c             	sub    $0xc,%esp
80101bdb:	68 60 32 11 80       	push   $0x80113260
80101be0:	e8 bf 45 00 00       	call   801061a4 <release>
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
80101bf9:	e8 3f 45 00 00       	call   8010613d <acquire>
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
80101c41:	68 46 99 10 80       	push   $0x80109946
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
80101c64:	e8 3b 45 00 00       	call   801061a4 <release>
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
80101c99:	e8 9f 44 00 00       	call   8010613d <acquire>
80101c9e:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101ca1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101cab:	83 ec 0c             	sub    $0xc,%esp
80101cae:	ff 75 08             	pushl  0x8(%ebp)
80101cb1:	e8 05 39 00 00       	call   801055bb <wakeup>
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
80101cd0:	e8 cf 44 00 00       	call   801061a4 <release>
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
80101e10:	68 50 99 10 80       	push   $0x80109950
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
801020a7:	e8 b3 43 00 00       	call   8010645f <memmove>
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
801021f9:	e8 61 42 00 00       	call   8010645f <memmove>
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
80102279:	e8 77 42 00 00       	call   801064f5 <strncmp>
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
80102299:	68 63 99 10 80       	push   $0x80109963
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
801022c8:	68 75 99 10 80       	push   $0x80109975
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
8010239d:	68 75 99 10 80       	push   $0x80109975
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
801023d8:	e8 6e 41 00 00       	call   8010654b <strncpy>
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
80102404:	68 82 99 10 80       	push   $0x80109982
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
8010247a:	e8 e0 3f 00 00       	call   8010645f <memmove>
8010247f:	83 c4 10             	add    $0x10,%esp
80102482:	eb 26                	jmp    801024aa <skipelem+0x95>
  else {
    memmove(name, s, len);
80102484:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102487:	83 ec 04             	sub    $0x4,%esp
8010248a:	50                   	push   %eax
8010248b:	ff 75 f4             	pushl  -0xc(%ebp)
8010248e:	ff 75 0c             	pushl  0xc(%ebp)
80102491:	e8 c9 3f 00 00       	call   8010645f <memmove>
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
801026e6:	68 8a 99 10 80       	push   $0x8010998a
801026eb:	68 20 d6 10 80       	push   $0x8010d620
801026f0:	e8 26 3a 00 00       	call   8010611b <initlock>
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
8010279a:	68 8e 99 10 80       	push   $0x8010998e
8010279f:	e8 c2 dd ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
801027a4:	8b 45 08             	mov    0x8(%ebp),%eax
801027a7:	8b 40 08             	mov    0x8(%eax),%eax
801027aa:	3d cf 07 00 00       	cmp    $0x7cf,%eax
801027af:	76 0d                	jbe    801027be <idestart+0x33>
    panic("incorrect blockno");
801027b1:	83 ec 0c             	sub    $0xc,%esp
801027b4:	68 97 99 10 80       	push   $0x80109997
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
801027dd:	68 8e 99 10 80       	push   $0x8010998e
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
801028f7:	e8 41 38 00 00       	call   8010613d <acquire>
801028fc:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
801028ff:	a1 54 d6 10 80       	mov    0x8010d654,%eax
80102904:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010290b:	75 15                	jne    80102922 <ideintr+0x39>
    release(&idelock);
8010290d:	83 ec 0c             	sub    $0xc,%esp
80102910:	68 20 d6 10 80       	push   $0x8010d620
80102915:	e8 8a 38 00 00       	call   801061a4 <release>
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
8010298a:	e8 2c 2c 00 00       	call   801055bb <wakeup>
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
801029b4:	e8 eb 37 00 00       	call   801061a4 <release>
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
801029d3:	68 a9 99 10 80       	push   $0x801099a9
801029d8:	e8 89 db ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801029dd:	8b 45 08             	mov    0x8(%ebp),%eax
801029e0:	8b 00                	mov    (%eax),%eax
801029e2:	83 e0 06             	and    $0x6,%eax
801029e5:	83 f8 02             	cmp    $0x2,%eax
801029e8:	75 0d                	jne    801029f7 <iderw+0x39>
    panic("iderw: nothing to do");
801029ea:	83 ec 0c             	sub    $0xc,%esp
801029ed:	68 bd 99 10 80       	push   $0x801099bd
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
80102a0d:	68 d2 99 10 80       	push   $0x801099d2
80102a12:	e8 4f db ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102a17:	83 ec 0c             	sub    $0xc,%esp
80102a1a:	68 20 d6 10 80       	push   $0x8010d620
80102a1f:	e8 19 37 00 00       	call   8010613d <acquire>
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
80102a7b:	e8 73 29 00 00       	call   801053f3 <sleep>
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
80102a98:	e8 07 37 00 00       	call   801061a4 <release>
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
80102b29:	68 f0 99 10 80       	push   $0x801099f0
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
80102be9:	68 22 9a 10 80       	push   $0x80109a22
80102bee:	68 40 42 11 80       	push   $0x80114240
80102bf3:	e8 23 35 00 00       	call   8010611b <initlock>
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
80102c8c:	81 7d 08 3c 77 11 80 	cmpl   $0x8011773c,0x8(%ebp)
80102c93:	72 12                	jb     80102ca7 <kfree+0x2d>
80102c95:	ff 75 08             	pushl  0x8(%ebp)
80102c98:	e8 36 ff ff ff       	call   80102bd3 <v2p>
80102c9d:	83 c4 04             	add    $0x4,%esp
80102ca0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102ca5:	76 0d                	jbe    80102cb4 <kfree+0x3a>
    panic("kfree");
80102ca7:	83 ec 0c             	sub    $0xc,%esp
80102caa:	68 27 9a 10 80       	push   $0x80109a27
80102caf:	e8 b2 d8 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102cb4:	83 ec 04             	sub    $0x4,%esp
80102cb7:	68 00 10 00 00       	push   $0x1000
80102cbc:	6a 01                	push   $0x1
80102cbe:	ff 75 08             	pushl  0x8(%ebp)
80102cc1:	e8 da 36 00 00       	call   801063a0 <memset>
80102cc6:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102cc9:	a1 74 42 11 80       	mov    0x80114274,%eax
80102cce:	85 c0                	test   %eax,%eax
80102cd0:	74 10                	je     80102ce2 <kfree+0x68>
    acquire(&kmem.lock);
80102cd2:	83 ec 0c             	sub    $0xc,%esp
80102cd5:	68 40 42 11 80       	push   $0x80114240
80102cda:	e8 5e 34 00 00       	call   8010613d <acquire>
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
80102d0c:	e8 93 34 00 00       	call   801061a4 <release>
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
80102d2e:	e8 0a 34 00 00       	call   8010613d <acquire>
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
80102d5f:	e8 40 34 00 00       	call   801061a4 <release>
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
801030aa:	68 30 9a 10 80       	push   $0x80109a30
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
801032d5:	e8 2d 31 00 00       	call   80106407 <memcmp>
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
801033e9:	68 5c 9a 10 80       	push   $0x80109a5c
801033ee:	68 80 42 11 80       	push   $0x80114280
801033f3:	e8 23 2d 00 00       	call   8010611b <initlock>
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
8010349e:	e8 bc 2f 00 00       	call   8010645f <memmove>
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
8010360c:	e8 2c 2b 00 00       	call   8010613d <acquire>
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
8010362a:	e8 c4 1d 00 00       	call   801053f3 <sleep>
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
8010365f:	e8 8f 1d 00 00       	call   801053f3 <sleep>
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
8010367e:	e8 21 2b 00 00       	call   801061a4 <release>
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
8010369f:	e8 99 2a 00 00       	call   8010613d <acquire>
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
801036c0:	68 60 9a 10 80       	push   $0x80109a60
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
801036ee:	e8 c8 1e 00 00       	call   801055bb <wakeup>
801036f3:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
801036f6:	83 ec 0c             	sub    $0xc,%esp
801036f9:	68 80 42 11 80       	push   $0x80114280
801036fe:	e8 a1 2a 00 00       	call   801061a4 <release>
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
80103719:	e8 1f 2a 00 00       	call   8010613d <acquire>
8010371e:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103721:	c7 05 c0 42 11 80 00 	movl   $0x0,0x801142c0
80103728:	00 00 00 
    wakeup(&log);
8010372b:	83 ec 0c             	sub    $0xc,%esp
8010372e:	68 80 42 11 80       	push   $0x80114280
80103733:	e8 83 1e 00 00       	call   801055bb <wakeup>
80103738:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
8010373b:	83 ec 0c             	sub    $0xc,%esp
8010373e:	68 80 42 11 80       	push   $0x80114280
80103743:	e8 5c 2a 00 00       	call   801061a4 <release>
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
801037bf:	e8 9b 2c 00 00       	call   8010645f <memmove>
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
8010385b:	68 6f 9a 10 80       	push   $0x80109a6f
80103860:	e8 01 cd ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103865:	a1 bc 42 11 80       	mov    0x801142bc,%eax
8010386a:	85 c0                	test   %eax,%eax
8010386c:	7f 0d                	jg     8010387b <log_write+0x45>
    panic("log_write outside of trans");
8010386e:	83 ec 0c             	sub    $0xc,%esp
80103871:	68 85 9a 10 80       	push   $0x80109a85
80103876:	e8 eb cc ff ff       	call   80100566 <panic>

  acquire(&log.lock);
8010387b:	83 ec 0c             	sub    $0xc,%esp
8010387e:	68 80 42 11 80       	push   $0x80114280
80103883:	e8 b5 28 00 00       	call   8010613d <acquire>
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
80103901:	e8 9e 28 00 00       	call   801061a4 <release>
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
80103959:	68 3c 77 11 80       	push   $0x8011773c
8010395e:	e8 7d f2 ff ff       	call   80102be0 <kinit1>
80103963:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103966:	e8 05 57 00 00       	call   80109070 <kvmalloc>
  mpinit();        // collect info about this machine
8010396b:	e8 43 04 00 00       	call   80103db3 <mpinit>
  lapicinit();
80103970:	e8 ea f5 ff ff       	call   80102f5f <lapicinit>
  seginit();       // set up segments
80103975:	e8 9f 50 00 00       	call   80108a19 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
8010397a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103980:	0f b6 00             	movzbl (%eax),%eax
80103983:	0f b6 c0             	movzbl %al,%eax
80103986:	83 ec 08             	sub    $0x8,%esp
80103989:	50                   	push   %eax
8010398a:	68 a0 9a 10 80       	push   $0x80109aa0
8010398f:	e8 32 ca ff ff       	call   801003c6 <cprintf>
80103994:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103997:	e8 6d 06 00 00       	call   80104009 <picinit>
  ioapicinit();    // another interrupt controller
8010399c:	e8 34 f1 ff ff       	call   80102ad5 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801039a1:	e8 24 d2 ff ff       	call   80100bca <consoleinit>
  uartinit();      // serial port
801039a6:	e8 ca 43 00 00       	call   80107d75 <uartinit>
  pinit();         // process table
801039ab:	e8 5d 0b 00 00       	call   8010450d <pinit>
  tvinit();        // trap vectors
801039b0:	e8 99 3f 00 00       	call   8010794e <tvinit>
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
801039cd:	e8 cd 3e 00 00       	call   8010789f <timerinit>
  startothers();   // start other processors
801039d2:	e8 7f 00 00 00       	call   80103a56 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801039d7:	83 ec 08             	sub    $0x8,%esp
801039da:	68 00 00 00 8e       	push   $0x8e000000
801039df:	68 00 00 40 80       	push   $0x80400000
801039e4:	e8 30 f2 ff ff       	call   80102c19 <kinit2>
801039e9:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
801039ec:	e8 04 0d 00 00       	call   801046f5 <userinit>
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
801039fc:	e8 87 56 00 00       	call   80109088 <switchkvm>
  seginit();
80103a01:	e8 13 50 00 00       	call   80108a19 <seginit>
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
80103a26:	68 b7 9a 10 80       	push   $0x80109ab7
80103a2b:	e8 96 c9 ff ff       	call   801003c6 <cprintf>
80103a30:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103a33:	e8 77 40 00 00       	call   80107aaf <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103a38:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103a3e:	05 a8 00 00 00       	add    $0xa8,%eax
80103a43:	83 ec 08             	sub    $0x8,%esp
80103a46:	6a 01                	push   $0x1
80103a48:	50                   	push   %eax
80103a49:	e8 d8 fe ff ff       	call   80103926 <xchg>
80103a4e:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103a51:	e8 9c 16 00 00       	call   801050f2 <scheduler>

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
80103a7e:	e8 dc 29 00 00       	call   8010645f <memmove>
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
80103c0c:	68 c8 9a 10 80       	push   $0x80109ac8
80103c11:	ff 75 f4             	pushl  -0xc(%ebp)
80103c14:	e8 ee 27 00 00       	call   80106407 <memcmp>
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
80103d4a:	68 cd 9a 10 80       	push   $0x80109acd
80103d4f:	ff 75 f0             	pushl  -0x10(%ebp)
80103d52:	e8 b0 26 00 00       	call   80106407 <memcmp>
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
80103e26:	8b 04 85 10 9b 10 80 	mov    -0x7fef64f0(,%eax,4),%eax
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
80103e5c:	68 d2 9a 10 80       	push   $0x80109ad2
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
80103eef:	68 f0 9a 10 80       	push   $0x80109af0
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
80104190:	68 24 9b 10 80       	push   $0x80109b24
80104195:	50                   	push   %eax
80104196:	e8 80 1f 00 00       	call   8010611b <initlock>
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
80104252:	e8 e6 1e 00 00       	call   8010613d <acquire>
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
80104279:	e8 3d 13 00 00       	call   801055bb <wakeup>
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
8010429c:	e8 1a 13 00 00       	call   801055bb <wakeup>
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
801042c5:	e8 da 1e 00 00       	call   801061a4 <release>
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
801042e4:	e8 bb 1e 00 00       	call   801061a4 <release>
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
801042fc:	e8 3c 1e 00 00       	call   8010613d <acquire>
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
80104331:	e8 6e 1e 00 00       	call   801061a4 <release>
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
8010434f:	e8 67 12 00 00       	call   801055bb <wakeup>
80104354:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104357:	8b 45 08             	mov    0x8(%ebp),%eax
8010435a:	8b 55 08             	mov    0x8(%ebp),%edx
8010435d:	81 c2 38 02 00 00    	add    $0x238,%edx
80104363:	83 ec 08             	sub    $0x8,%esp
80104366:	50                   	push   %eax
80104367:	52                   	push   %edx
80104368:	e8 86 10 00 00       	call   801053f3 <sleep>
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
801043d1:	e8 e5 11 00 00       	call   801055bb <wakeup>
801043d6:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801043d9:	8b 45 08             	mov    0x8(%ebp),%eax
801043dc:	83 ec 0c             	sub    $0xc,%esp
801043df:	50                   	push   %eax
801043e0:	e8 bf 1d 00 00       	call   801061a4 <release>
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
801043fb:	e8 3d 1d 00 00       	call   8010613d <acquire>
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
80104419:	e8 86 1d 00 00       	call   801061a4 <release>
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
8010443c:	e8 b2 0f 00 00       	call   801053f3 <sleep>
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
801044d0:	e8 e6 10 00 00       	call   801055bb <wakeup>
801044d5:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
801044d8:	8b 45 08             	mov    0x8(%ebp),%eax
801044db:	83 ec 0c             	sub    $0xc,%esp
801044de:	50                   	push   %eax
801044df:	e8 c0 1c 00 00       	call   801061a4 <release>
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
80104516:	68 56 9b 10 80       	push   $0x80109b56
8010451b:	68 80 49 11 80       	push   $0x80114980
80104520:	e8 f6 1b 00 00       	call   8010611b <initlock>
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
80104539:	e8 ff 1b 00 00       	call   8010613d <acquire>
8010453e:	83 c4 10             	add    $0x10,%esp
    p = ptable.pLists.free;
80104541:	a1 b8 6e 11 80       	mov    0x80116eb8,%eax
80104546:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p) {
80104549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010454d:	75 1a                	jne    80104569 <allocproc+0x3e>
        goto found;
    }
    release(&ptable.lock);
8010454f:	83 ec 0c             	sub    $0xc,%esp
80104552:	68 80 49 11 80       	push   $0x80114980
80104557:	e8 48 1c 00 00       	call   801061a4 <release>
8010455c:	83 c4 10             	add    $0x10,%esp
    return 0;
8010455f:	b8 00 00 00 00       	mov    $0x0,%eax
80104564:	e9 8a 01 00 00       	jmp    801046f3 <allocproc+0x1c8>
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
80104572:	e8 de 16 00 00       	call   80105c55 <assertState>
80104577:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.free, p) == -1) {
8010457a:	83 ec 08             	sub    $0x8,%esp
8010457d:	ff 75 f4             	pushl  -0xc(%ebp)
80104580:	68 b8 6e 11 80       	push   $0x80116eb8
80104585:	e8 ec 17 00 00       	call   80105d76 <removeFromStateList>
8010458a:	83 c4 10             	add    $0x10,%esp
8010458d:	83 f8 ff             	cmp    $0xffffffff,%eax
80104590:	75 10                	jne    801045a2 <allocproc+0x77>
        cprintf("Failed to remove proc from UNUSED list (allocproc).\n");
80104592:	83 ec 0c             	sub    $0xc,%esp
80104595:	68 60 9b 10 80       	push   $0x80109b60
8010459a:	e8 27 be ff ff       	call   801003c6 <cprintf>
8010459f:	83 c4 10             	add    $0x10,%esp
    }
    p->state = EMBRYO;
801045a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a5:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    if (addToStateListHead(&ptable.pLists.embryo, p) == -1) {
801045ac:	83 ec 08             	sub    $0x8,%esp
801045af:	ff 75 f4             	pushl  -0xc(%ebp)
801045b2:	68 c8 6e 11 80       	push   $0x80116ec8
801045b7:	e8 cd 16 00 00       	call   80105c89 <addToStateListHead>
801045bc:	83 c4 10             	add    $0x10,%esp
801045bf:	83 f8 ff             	cmp    $0xffffffff,%eax
801045c2:	75 10                	jne    801045d4 <allocproc+0xa9>
        cprintf("Failed to add proc to EMBRYO list (allocproc).\n");
801045c4:	83 ec 0c             	sub    $0xc,%esp
801045c7:	68 98 9b 10 80       	push   $0x80109b98
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
801045f2:	e8 ad 1b 00 00       	call   801061a4 <release>
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
80104619:	e8 37 16 00 00       	call   80105c55 <assertState>
8010461e:	83 c4 10             	add    $0x10,%esp
        removeFromStateList(&ptable.pLists.embryo, p);
80104621:	83 ec 08             	sub    $0x8,%esp
80104624:	ff 75 f4             	pushl  -0xc(%ebp)
80104627:	68 c8 6e 11 80       	push   $0x80116ec8
8010462c:	e8 45 17 00 00       	call   80105d76 <removeFromStateList>
80104631:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104637:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        if (addToStateListHead(&ptable.pLists.free, p) == -1) {
8010463e:	83 ec 08             	sub    $0x8,%esp
80104641:	ff 75 f4             	pushl  -0xc(%ebp)
80104644:	68 b8 6e 11 80       	push   $0x80116eb8
80104649:	e8 3b 16 00 00       	call   80105c89 <addToStateListHead>
8010464e:	83 c4 10             	add    $0x10,%esp
80104651:	83 f8 ff             	cmp    $0xffffffff,%eax
80104654:	75 10                	jne    80104666 <allocproc+0x13b>
            cprintf("Not enough room for process stack; Failed to add proc to UNUSED list (allocproc).\n");
80104656:	83 ec 0c             	sub    $0xc,%esp
80104659:	68 c8 9b 10 80       	push   $0x80109bc8
8010465e:	e8 63 bd ff ff       	call   801003c6 <cprintf>
80104663:	83 c4 10             	add    $0x10,%esp
        }
        return 0;
80104666:	b8 00 00 00 00       	mov    $0x0,%eax
8010466b:	e9 83 00 00 00       	jmp    801046f3 <allocproc+0x1c8>
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
8010468f:	ba fc 78 10 80       	mov    $0x801078fc,%edx
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
801046b4:	e8 e7 1c 00 00       	call   801063a0 <memset>
801046b9:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
801046bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046bf:	8b 40 1c             	mov    0x1c(%eax),%eax
801046c2:	ba ad 53 10 80       	mov    $0x801053ad,%edx
801046c7:	89 50 10             	mov    %edx,0x10(%eax)

    p->start_ticks = ticks;
801046ca:	8b 15 e0 76 11 80    	mov    0x801176e0,%edx
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

    return p;
801046f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801046f3:	c9                   	leave  
801046f4:	c3                   	ret    

801046f5 <userinit>:
}
#else
// PROJECT 3 + 4 USERINIT
void
userinit(void)
{
801046f5:	55                   	push   %ebp
801046f6:	89 e5                	mov    %esp,%ebp
801046f8:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    // Add to the END of the UNUSED list upon init, or else processes will be backwards (ctrl-p & ps)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801046fb:	c7 45 f4 b4 49 11 80 	movl   $0x801149b4,-0xc(%ebp)
80104702:	eb 3c                	jmp    80104740 <userinit+0x4b>
        assertState(p, UNUSED);
80104704:	83 ec 08             	sub    $0x8,%esp
80104707:	6a 00                	push   $0x0
80104709:	ff 75 f4             	pushl  -0xc(%ebp)
8010470c:	e8 44 15 00 00       	call   80105c55 <assertState>
80104711:	83 c4 10             	add    $0x10,%esp
        if (addToStateListEnd(&ptable.pLists.free, p) == -1) {
80104714:	83 ec 08             	sub    $0x8,%esp
80104717:	ff 75 f4             	pushl  -0xc(%ebp)
8010471a:	68 b8 6e 11 80       	push   $0x80116eb8
8010471f:	e8 d1 15 00 00       	call   80105cf5 <addToStateListEnd>
80104724:	83 c4 10             	add    $0x10,%esp
80104727:	83 f8 ff             	cmp    $0xffffffff,%eax
8010472a:	75 0d                	jne    80104739 <userinit+0x44>
            panic("Failed to add proc to UNUSED list.\n");
8010472c:	83 ec 0c             	sub    $0xc,%esp
8010472f:	68 1c 9c 10 80       	push   $0x80109c1c
80104734:	e8 2d be ff ff       	call   80100566 <panic>
{
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    // Add to the END of the UNUSED list upon init, or else processes will be backwards (ctrl-p & ps)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104739:	81 45 f4 94 00 00 00 	addl   $0x94,-0xc(%ebp)
80104740:	81 7d f4 b4 6e 11 80 	cmpl   $0x80116eb4,-0xc(%ebp)
80104747:	72 bb                	jb     80104704 <userinit+0xf>
        if (addToStateListEnd(&ptable.pLists.free, p) == -1) {
            panic("Failed to add proc to UNUSED list.\n");
        }
    }

    p = allocproc();
80104749:	e8 dd fd ff ff       	call   8010452b <allocproc>
8010474e:	89 45 f4             	mov    %eax,-0xc(%ebp)

    initproc = p;
80104751:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104754:	a3 68 d6 10 80       	mov    %eax,0x8010d668
    if((p->pgdir = setupkvm()) == 0)
80104759:	e8 60 48 00 00       	call   80108fbe <setupkvm>
8010475e:	89 c2                	mov    %eax,%edx
80104760:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104763:	89 50 04             	mov    %edx,0x4(%eax)
80104766:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104769:	8b 40 04             	mov    0x4(%eax),%eax
8010476c:	85 c0                	test   %eax,%eax
8010476e:	75 0d                	jne    8010477d <userinit+0x88>
        panic("userinit: out of memory?");
80104770:	83 ec 0c             	sub    $0xc,%esp
80104773:	68 40 9c 10 80       	push   $0x80109c40
80104778:	e8 e9 bd ff ff       	call   80100566 <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010477d:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104785:	8b 40 04             	mov    0x4(%eax),%eax
80104788:	83 ec 04             	sub    $0x4,%esp
8010478b:	52                   	push   %edx
8010478c:	68 00 d5 10 80       	push   $0x8010d500
80104791:	50                   	push   %eax
80104792:	e8 81 4a 00 00       	call   80109218 <inituvm>
80104797:	83 c4 10             	add    $0x10,%esp
    p->sz = PGSIZE;
8010479a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010479d:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
    memset(p->tf, 0, sizeof(*p->tf));
801047a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a6:	8b 40 18             	mov    0x18(%eax),%eax
801047a9:	83 ec 04             	sub    $0x4,%esp
801047ac:	6a 4c                	push   $0x4c
801047ae:	6a 00                	push   $0x0
801047b0:	50                   	push   %eax
801047b1:	e8 ea 1b 00 00       	call   801063a0 <memset>
801047b6:	83 c4 10             	add    $0x10,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801047b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047bc:	8b 40 18             	mov    0x18(%eax),%eax
801047bf:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801047c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c8:	8b 40 18             	mov    0x18(%eax),%eax
801047cb:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
    p->tf->es = p->tf->ds;
801047d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047d4:	8b 40 18             	mov    0x18(%eax),%eax
801047d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047da:	8b 52 18             	mov    0x18(%edx),%edx
801047dd:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801047e1:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
801047e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e8:	8b 40 18             	mov    0x18(%eax),%eax
801047eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047ee:	8b 52 18             	mov    0x18(%edx),%edx
801047f1:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801047f5:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
801047f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047fc:	8b 40 18             	mov    0x18(%eax),%eax
801047ff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80104806:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104809:	8b 40 18             	mov    0x18(%eax),%eax
8010480c:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80104813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104816:	8b 40 18             	mov    0x18(%eax),%eax
80104819:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

#ifdef CS333_P2
    p->uid = UID;
80104820:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104823:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010482a:	00 00 00 
    p->gid = GID;
8010482d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104830:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104837:	00 00 00 
    p->parent = p; // parent of proc one is itself
8010483a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010483d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104840:	89 50 14             	mov    %edx,0x14(%eax)
#endif

    safestrcpy(p->name, "initcode", sizeof(p->name));
80104843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104846:	83 c0 6c             	add    $0x6c,%eax
80104849:	83 ec 04             	sub    $0x4,%esp
8010484c:	6a 10                	push   $0x10
8010484e:	68 59 9c 10 80       	push   $0x80109c59
80104853:	50                   	push   %eax
80104854:	e8 4a 1d 00 00       	call   801065a3 <safestrcpy>
80104859:	83 c4 10             	add    $0x10,%esp
    p->cwd = namei("/");
8010485c:	83 ec 0c             	sub    $0xc,%esp
8010485f:	68 62 9c 10 80       	push   $0x80109c62
80104864:	e8 70 dd ff ff       	call   801025d9 <namei>
80104869:	83 c4 10             	add    $0x10,%esp
8010486c:	89 c2                	mov    %eax,%edx
8010486e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104871:	89 50 68             	mov    %edx,0x68(%eax)

    assertState(p, EMBRYO);
80104874:	83 ec 08             	sub    $0x8,%esp
80104877:	6a 01                	push   $0x1
80104879:	ff 75 f4             	pushl  -0xc(%ebp)
8010487c:	e8 d4 13 00 00       	call   80105c55 <assertState>
80104881:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.embryo, p) < 0) {
80104884:	83 ec 08             	sub    $0x8,%esp
80104887:	ff 75 f4             	pushl  -0xc(%ebp)
8010488a:	68 c8 6e 11 80       	push   $0x80116ec8
8010488f:	e8 e2 14 00 00       	call   80105d76 <removeFromStateList>
80104894:	83 c4 10             	add    $0x10,%esp
80104897:	85 c0                	test   %eax,%eax
80104899:	79 10                	jns    801048ab <userinit+0x1b6>
        cprintf("Failed to remove EMBRYO proc from list (userinit).\n");
8010489b:	83 ec 0c             	sub    $0xc,%esp
8010489e:	68 64 9c 10 80       	push   $0x80109c64
801048a3:	e8 1e bb ff ff       	call   801003c6 <cprintf>
801048a8:	83 c4 10             	add    $0x10,%esp
    }

    p->state = RUNNABLE;
801048ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ae:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

    ptable.pLists.ready = p;  // add to head of ready list
801048b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b8:	a3 b4 6e 11 80       	mov    %eax,0x80116eb4
    p->next = 0;
801048bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048c0:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801048c7:	00 00 00 
    ptable.pLists.sleep = 0;  // initialize rest of the lists to NULL
801048ca:	c7 05 bc 6e 11 80 00 	movl   $0x0,0x80116ebc
801048d1:	00 00 00 
    ptable.pLists.zombie = 0;
801048d4:	c7 05 c0 6e 11 80 00 	movl   $0x0,0x80116ec0
801048db:	00 00 00 
    ptable.pLists.running = 0;
801048de:	c7 05 c4 6e 11 80 00 	movl   $0x0,0x80116ec4
801048e5:	00 00 00 
    ptable.pLists.embryo = 0;
801048e8:	c7 05 c8 6e 11 80 00 	movl   $0x0,0x80116ec8
801048ef:	00 00 00 
}
801048f2:	90                   	nop
801048f3:	c9                   	leave  
801048f4:	c3                   	ret    

801048f5 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801048f5:	55                   	push   %ebp
801048f6:	89 e5                	mov    %esp,%ebp
801048f8:	83 ec 18             	sub    $0x18,%esp
    uint sz;

    sz = proc->sz;
801048fb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104901:	8b 00                	mov    (%eax),%eax
80104903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(n > 0){
80104906:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010490a:	7e 31                	jle    8010493d <growproc+0x48>
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
8010490c:	8b 55 08             	mov    0x8(%ebp),%edx
8010490f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104912:	01 c2                	add    %eax,%edx
80104914:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010491a:	8b 40 04             	mov    0x4(%eax),%eax
8010491d:	83 ec 04             	sub    $0x4,%esp
80104920:	52                   	push   %edx
80104921:	ff 75 f4             	pushl  -0xc(%ebp)
80104924:	50                   	push   %eax
80104925:	e8 3b 4a 00 00       	call   80109365 <allocuvm>
8010492a:	83 c4 10             	add    $0x10,%esp
8010492d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104930:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104934:	75 3e                	jne    80104974 <growproc+0x7f>
            return -1;
80104936:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010493b:	eb 59                	jmp    80104996 <growproc+0xa1>
    } else if(n < 0){
8010493d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104941:	79 31                	jns    80104974 <growproc+0x7f>
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104943:	8b 55 08             	mov    0x8(%ebp),%edx
80104946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104949:	01 c2                	add    %eax,%edx
8010494b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104951:	8b 40 04             	mov    0x4(%eax),%eax
80104954:	83 ec 04             	sub    $0x4,%esp
80104957:	52                   	push   %edx
80104958:	ff 75 f4             	pushl  -0xc(%ebp)
8010495b:	50                   	push   %eax
8010495c:	e8 cd 4a 00 00       	call   8010942e <deallocuvm>
80104961:	83 c4 10             	add    $0x10,%esp
80104964:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104967:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010496b:	75 07                	jne    80104974 <growproc+0x7f>
            return -1;
8010496d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104972:	eb 22                	jmp    80104996 <growproc+0xa1>
    }
    proc->sz = sz;
80104974:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010497a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010497d:	89 10                	mov    %edx,(%eax)
    switchuvm(proc);
8010497f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104985:	83 ec 0c             	sub    $0xc,%esp
80104988:	50                   	push   %eax
80104989:	e8 17 47 00 00       	call   801090a5 <switchuvm>
8010498e:	83 c4 10             	add    $0x10,%esp
    return 0;
80104991:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104996:	c9                   	leave  
80104997:	c3                   	ret    

80104998 <fork>:
}
#else
// PROJECT 3 + 4 FORK
int
fork(void)
{
80104998:	55                   	push   %ebp
80104999:	89 e5                	mov    %esp,%ebp
8010499b:	57                   	push   %edi
8010499c:	56                   	push   %esi
8010499d:	53                   	push   %ebx
8010499e:	83 ec 1c             	sub    $0x1c,%esp
    int i, pid;
    struct proc *np;

    // Allocate process.
    if((np = allocproc()) == 0)
801049a1:	e8 85 fb ff ff       	call   8010452b <allocproc>
801049a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801049a9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049ad:	75 0a                	jne    801049b9 <fork+0x21>
        return -1;
801049af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049b4:	e9 4c 02 00 00       	jmp    80104c05 <fork+0x26d>

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
801049b9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049bf:	8b 10                	mov    (%eax),%edx
801049c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049c7:	8b 40 04             	mov    0x4(%eax),%eax
801049ca:	83 ec 08             	sub    $0x8,%esp
801049cd:	52                   	push   %edx
801049ce:	50                   	push   %eax
801049cf:	e8 f8 4b 00 00       	call   801095cc <copyuvm>
801049d4:	83 c4 10             	add    $0x10,%esp
801049d7:	89 c2                	mov    %eax,%edx
801049d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049dc:	89 50 04             	mov    %edx,0x4(%eax)
801049df:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049e2:	8b 40 04             	mov    0x4(%eax),%eax
801049e5:	85 c0                	test   %eax,%eax
801049e7:	0f 85 88 00 00 00    	jne    80104a75 <fork+0xdd>
        kfree(np->kstack);
801049ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
801049f0:	8b 40 08             	mov    0x8(%eax),%eax
801049f3:	83 ec 0c             	sub    $0xc,%esp
801049f6:	50                   	push   %eax
801049f7:	e8 7e e2 ff ff       	call   80102c7a <kfree>
801049fc:	83 c4 10             	add    $0x10,%esp
        np->kstack = 0;
801049ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        assertState(np, EMBRYO);
80104a09:	83 ec 08             	sub    $0x8,%esp
80104a0c:	6a 01                	push   $0x1
80104a0e:	ff 75 e0             	pushl  -0x20(%ebp)
80104a11:	e8 3f 12 00 00       	call   80105c55 <assertState>
80104a16:	83 c4 10             	add    $0x10,%esp
        if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
80104a19:	83 ec 08             	sub    $0x8,%esp
80104a1c:	ff 75 e0             	pushl  -0x20(%ebp)
80104a1f:	68 c8 6e 11 80       	push   $0x80116ec8
80104a24:	e8 4d 13 00 00       	call   80105d76 <removeFromStateList>
80104a29:	83 c4 10             	add    $0x10,%esp
80104a2c:	85 c0                	test   %eax,%eax
80104a2e:	79 0d                	jns    80104a3d <fork+0xa5>
            panic("Failed to remove proc from EMBRYO list (fork).\n");
80104a30:	83 ec 0c             	sub    $0xc,%esp
80104a33:	68 98 9c 10 80       	push   $0x80109c98
80104a38:	e8 29 bb ff ff       	call   80100566 <panic>
        }
        np->state = UNUSED;
80104a3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a40:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        if (addToStateListHead(&ptable.pLists.free, np) < 0) {
80104a47:	83 ec 08             	sub    $0x8,%esp
80104a4a:	ff 75 e0             	pushl  -0x20(%ebp)
80104a4d:	68 b8 6e 11 80       	push   $0x80116eb8
80104a52:	e8 32 12 00 00       	call   80105c89 <addToStateListHead>
80104a57:	83 c4 10             	add    $0x10,%esp
80104a5a:	85 c0                	test   %eax,%eax
80104a5c:	79 0d                	jns    80104a6b <fork+0xd3>
            panic("Failed to add proc to UNUSED list (fork).\n");
80104a5e:	83 ec 0c             	sub    $0xc,%esp
80104a61:	68 c8 9c 10 80       	push   $0x80109cc8
80104a66:	e8 fb ba ff ff       	call   80100566 <panic>
        }
        return -1;
80104a6b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a70:	e9 90 01 00 00       	jmp    80104c05 <fork+0x26d>
    }
    np->sz = proc->sz;
80104a75:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a7b:	8b 10                	mov    (%eax),%edx
80104a7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a80:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
80104a82:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a8c:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
80104a8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104a92:	8b 50 18             	mov    0x18(%eax),%edx
80104a95:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a9b:	8b 40 18             	mov    0x18(%eax),%eax
80104a9e:	89 c3                	mov    %eax,%ebx
80104aa0:	b8 13 00 00 00       	mov    $0x13,%eax
80104aa5:	89 d7                	mov    %edx,%edi
80104aa7:	89 de                	mov    %ebx,%esi
80104aa9:	89 c1                	mov    %eax,%ecx
80104aab:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80104aad:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ab0:	8b 40 18             	mov    0x18(%eax),%eax
80104ab3:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    for(i = 0; i < NOFILE; i++)
80104aba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104ac1:	eb 43                	jmp    80104b06 <fork+0x16e>
        if(proc->ofile[i])
80104ac3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ac9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104acc:	83 c2 08             	add    $0x8,%edx
80104acf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ad3:	85 c0                	test   %eax,%eax
80104ad5:	74 2b                	je     80104b02 <fork+0x16a>
            np->ofile[i] = filedup(proc->ofile[i]);
80104ad7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104add:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104ae0:	83 c2 08             	add    $0x8,%edx
80104ae3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ae7:	83 ec 0c             	sub    $0xc,%esp
80104aea:	50                   	push   %eax
80104aeb:	e8 c1 c5 ff ff       	call   801010b1 <filedup>
80104af0:	83 c4 10             	add    $0x10,%esp
80104af3:	89 c1                	mov    %eax,%ecx
80104af5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104af8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104afb:	83 c2 08             	add    $0x8,%edx
80104afe:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
    *np->tf = *proc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
80104b02:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104b06:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104b0a:	7e b7                	jle    80104ac3 <fork+0x12b>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
80104b0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b12:	8b 40 68             	mov    0x68(%eax),%eax
80104b15:	83 ec 0c             	sub    $0xc,%esp
80104b18:	50                   	push   %eax
80104b19:	e8 c3 ce ff ff       	call   801019e1 <idup>
80104b1e:	83 c4 10             	add    $0x10,%esp
80104b21:	89 c2                	mov    %eax,%edx
80104b23:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b26:	89 50 68             	mov    %edx,0x68(%eax)

    safestrcpy(np->name, proc->name, sizeof(proc->name));
80104b29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b2f:	8d 50 6c             	lea    0x6c(%eax),%edx
80104b32:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b35:	83 c0 6c             	add    $0x6c,%eax
80104b38:	83 ec 04             	sub    $0x4,%esp
80104b3b:	6a 10                	push   $0x10
80104b3d:	52                   	push   %edx
80104b3e:	50                   	push   %eax
80104b3f:	e8 5f 1a 00 00       	call   801065a3 <safestrcpy>
80104b44:	83 c4 10             	add    $0x10,%esp

    np->uid = proc->uid;
80104b47:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b4d:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104b53:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b56:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    np->gid = proc->gid;
80104b5c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b62:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104b68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b6b:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

    pid = np->pid;
80104b71:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b74:	8b 40 10             	mov    0x10(%eax),%eax
80104b77:	89 45 dc             	mov    %eax,-0x24(%ebp)

    // lock to force the compiler to emit the np->state write last.
    acquire(&ptable.lock);
80104b7a:	83 ec 0c             	sub    $0xc,%esp
80104b7d:	68 80 49 11 80       	push   $0x80114980
80104b82:	e8 b6 15 00 00       	call   8010613d <acquire>
80104b87:	83 c4 10             	add    $0x10,%esp
    assertState(np, EMBRYO);
80104b8a:	83 ec 08             	sub    $0x8,%esp
80104b8d:	6a 01                	push   $0x1
80104b8f:	ff 75 e0             	pushl  -0x20(%ebp)
80104b92:	e8 be 10 00 00       	call   80105c55 <assertState>
80104b97:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
80104b9a:	83 ec 08             	sub    $0x8,%esp
80104b9d:	ff 75 e0             	pushl  -0x20(%ebp)
80104ba0:	68 c8 6e 11 80       	push   $0x80116ec8
80104ba5:	e8 cc 11 00 00       	call   80105d76 <removeFromStateList>
80104baa:	83 c4 10             	add    $0x10,%esp
80104bad:	85 c0                	test   %eax,%eax
80104baf:	79 10                	jns    80104bc1 <fork+0x229>
        cprintf("Failed to remove EMBRYO proc from list (fork).\n");
80104bb1:	83 ec 0c             	sub    $0xc,%esp
80104bb4:	68 f4 9c 10 80       	push   $0x80109cf4
80104bb9:	e8 08 b8 ff ff       	call   801003c6 <cprintf>
80104bbe:	83 c4 10             	add    $0x10,%esp
    }

    np->state = RUNNABLE;
80104bc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bc4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

    if (addToStateListEnd(&ptable.pLists.ready, np) < 0) {
80104bcb:	83 ec 08             	sub    $0x8,%esp
80104bce:	ff 75 e0             	pushl  -0x20(%ebp)
80104bd1:	68 b4 6e 11 80       	push   $0x80116eb4
80104bd6:	e8 1a 11 00 00       	call   80105cf5 <addToStateListEnd>
80104bdb:	83 c4 10             	add    $0x10,%esp
80104bde:	85 c0                	test   %eax,%eax
80104be0:	79 10                	jns    80104bf2 <fork+0x25a>
        cprintf("Failed to add RUNNABLE proc to list (fork).\n");
80104be2:	83 ec 0c             	sub    $0xc,%esp
80104be5:	68 24 9d 10 80       	push   $0x80109d24
80104bea:	e8 d7 b7 ff ff       	call   801003c6 <cprintf>
80104bef:	83 c4 10             	add    $0x10,%esp
    }
    release(&ptable.lock);
80104bf2:	83 ec 0c             	sub    $0xc,%esp
80104bf5:	68 80 49 11 80       	push   $0x80114980
80104bfa:	e8 a5 15 00 00       	call   801061a4 <release>
80104bff:	83 c4 10             	add    $0x10,%esp

    return pid;
80104c02:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104c05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c08:	5b                   	pop    %ebx
80104c09:	5e                   	pop    %esi
80104c0a:	5f                   	pop    %edi
80104c0b:	5d                   	pop    %ebp
80104c0c:	c3                   	ret    

80104c0d <exit>:
    panic("zombie exit");
}
#else
void
exit(void)
{
80104c0d:	55                   	push   %ebp
80104c0e:	89 e5                	mov    %esp,%ebp
80104c10:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    int fd;

    if(proc == initproc)
80104c13:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c1a:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104c1f:	39 c2                	cmp    %eax,%edx
80104c21:	75 0d                	jne    80104c30 <exit+0x23>
        panic("init exiting");
80104c23:	83 ec 0c             	sub    $0xc,%esp
80104c26:	68 51 9d 10 80       	push   $0x80109d51
80104c2b:	e8 36 b9 ff ff       	call   80100566 <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104c30:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104c37:	eb 48                	jmp    80104c81 <exit+0x74>
        if(proc->ofile[fd]){
80104c39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c42:	83 c2 08             	add    $0x8,%edx
80104c45:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c49:	85 c0                	test   %eax,%eax
80104c4b:	74 30                	je     80104c7d <exit+0x70>
            fileclose(proc->ofile[fd]);
80104c4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c53:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c56:	83 c2 08             	add    $0x8,%edx
80104c59:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104c5d:	83 ec 0c             	sub    $0xc,%esp
80104c60:	50                   	push   %eax
80104c61:	e8 9c c4 ff ff       	call   80101102 <fileclose>
80104c66:	83 c4 10             	add    $0x10,%esp
            proc->ofile[fd] = 0;
80104c69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c72:	83 c2 08             	add    $0x8,%edx
80104c75:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104c7c:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104c7d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104c81:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104c85:	7e b2                	jle    80104c39 <exit+0x2c>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    begin_op();
80104c87:	e8 72 e9 ff ff       	call   801035fe <begin_op>
    iput(proc->cwd);
80104c8c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c92:	8b 40 68             	mov    0x68(%eax),%eax
80104c95:	83 ec 0c             	sub    $0xc,%esp
80104c98:	50                   	push   %eax
80104c99:	e8 4d cf ff ff       	call   80101beb <iput>
80104c9e:	83 c4 10             	add    $0x10,%esp
    end_op();
80104ca1:	e8 e4 e9 ff ff       	call   8010368a <end_op>
    proc->cwd = 0;
80104ca6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cac:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104cb3:	83 ec 0c             	sub    $0xc,%esp
80104cb6:	68 80 49 11 80       	push   $0x80114980
80104cbb:	e8 7d 14 00 00       	call   8010613d <acquire>
80104cc0:	83 c4 10             	add    $0x10,%esp

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104cc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc9:	8b 40 14             	mov    0x14(%eax),%eax
80104ccc:	83 ec 0c             	sub    $0xc,%esp
80104ccf:	50                   	push   %eax
80104cd0:	e8 2d 08 00 00       	call   80105502 <wakeup1>
80104cd5:	83 c4 10             	add    $0x10,%esp
    
    // Pass abandoned children to init.
    p = ptable.pLists.zombie;
80104cd8:	a1 c0 6e 11 80       	mov    0x80116ec0,%eax
80104cdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104ce0:	eb 39                	jmp    80104d1b <exit+0x10e>
        if (p->parent == proc) {
80104ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce5:	8b 50 14             	mov    0x14(%eax),%edx
80104ce8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cee:	39 c2                	cmp    %eax,%edx
80104cf0:	75 1d                	jne    80104d0f <exit+0x102>
            p->parent = initproc;
80104cf2:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cfb:	89 50 14             	mov    %edx,0x14(%eax)
            wakeup1(initproc);
80104cfe:	a1 68 d6 10 80       	mov    0x8010d668,%eax
80104d03:	83 ec 0c             	sub    $0xc,%esp
80104d06:	50                   	push   %eax
80104d07:	e8 f6 07 00 00       	call   80105502 <wakeup1>
80104d0c:	83 c4 10             	add    $0x10,%esp
        }
        p = p->next;
80104d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d12:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
    
    // Pass abandoned children to init.
    p = ptable.pLists.zombie;
    while (p) {
80104d1b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d1f:	75 c1                	jne    80104ce2 <exit+0xd5>
            p->parent = initproc;
            wakeup1(initproc);
        }
        p = p->next;
    }
    p = ptable.pLists.running; // now running list
80104d21:	a1 c4 6e 11 80       	mov    0x80116ec4,%eax
80104d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104d29:	eb 28                	jmp    80104d53 <exit+0x146>
        if(p->parent == proc){
80104d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d2e:	8b 50 14             	mov    0x14(%eax),%edx
80104d31:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d37:	39 c2                	cmp    %eax,%edx
80104d39:	75 0c                	jne    80104d47 <exit+0x13a>
            p->parent = initproc;
80104d3b:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d44:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d4a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104d50:	89 45 f4             	mov    %eax,-0xc(%ebp)
            wakeup1(initproc);
        }
        p = p->next;
    }
    p = ptable.pLists.running; // now running list
    while (p) {
80104d53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d57:	75 d2                	jne    80104d2b <exit+0x11e>
        if(p->parent == proc){
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.ready; // now ready
80104d59:	a1 b4 6e 11 80       	mov    0x80116eb4,%eax
80104d5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104d61:	eb 28                	jmp    80104d8b <exit+0x17e>
        if (p->parent == proc) {
80104d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d66:	8b 50 14             	mov    0x14(%eax),%edx
80104d69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d6f:	39 c2                	cmp    %eax,%edx
80104d71:	75 0c                	jne    80104d7f <exit+0x172>
            p->parent = initproc;
80104d73:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d7c:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d82:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.ready; // now ready
    while (p) {
80104d8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104d8f:	75 d2                	jne    80104d63 <exit+0x156>
        if (p->parent == proc) {
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.sleep; // sleeping list
80104d91:	a1 bc 6e 11 80       	mov    0x80116ebc,%eax
80104d96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104d99:	eb 28                	jmp    80104dc3 <exit+0x1b6>
        if (p->parent == proc) {
80104d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d9e:	8b 50 14             	mov    0x14(%eax),%edx
80104da1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da7:	39 c2                	cmp    %eax,%edx
80104da9:	75 0c                	jne    80104db7 <exit+0x1aa>
            p->parent = initproc;
80104dab:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db4:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dba:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.sleep; // sleeping list
    while (p) {
80104dc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104dc7:	75 d2                	jne    80104d9b <exit+0x18e>
        if (p->parent == proc) {
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.embryo; // embryo list
80104dc9:	a1 c8 6e 11 80       	mov    0x80116ec8,%eax
80104dce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104dd1:	eb 28                	jmp    80104dfb <exit+0x1ee>
        if (p->parent == proc) {
80104dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd6:	8b 50 14             	mov    0x14(%eax),%edx
80104dd9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ddf:	39 c2                	cmp    %eax,%edx
80104de1:	75 0c                	jne    80104def <exit+0x1e2>
            p->parent = initproc;
80104de3:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dec:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.embryo; // embryo list
    while (p) {
80104dfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104dff:	75 d2                	jne    80104dd3 <exit+0x1c6>
        if (p->parent == proc) {
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.free; // free list
80104e01:	a1 b8 6e 11 80       	mov    0x80116eb8,%eax
80104e06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80104e09:	eb 28                	jmp    80104e33 <exit+0x226>
        if (p->parent == proc) {
80104e0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e0e:	8b 50 14             	mov    0x14(%eax),%edx
80104e11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e17:	39 c2                	cmp    %eax,%edx
80104e19:	75 0c                	jne    80104e27 <exit+0x21a>
            p->parent = initproc;
80104e1b:	8b 15 68 d6 10 80    	mov    0x8010d668,%edx
80104e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e24:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80104e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e2a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104e30:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.free; // free list
    while (p) {
80104e33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104e37:	75 d2                	jne    80104e0b <exit+0x1fe>
            p->parent = initproc;
        }
        p = p->next;
    }

    assertState(proc, RUNNING);
80104e39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e3f:	83 ec 08             	sub    $0x8,%esp
80104e42:	6a 04                	push   $0x4
80104e44:	50                   	push   %eax
80104e45:	e8 0b 0e 00 00       	call   80105c55 <assertState>
80104e4a:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
80104e4d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e53:	83 ec 08             	sub    $0x8,%esp
80104e56:	50                   	push   %eax
80104e57:	68 c4 6e 11 80       	push   $0x80116ec4
80104e5c:	e8 15 0f 00 00       	call   80105d76 <removeFromStateList>
80104e61:	83 c4 10             	add    $0x10,%esp
80104e64:	85 c0                	test   %eax,%eax
80104e66:	79 10                	jns    80104e78 <exit+0x26b>
        cprintf("Failed to remove RUNNING proc from list (exit).\n");
80104e68:	83 ec 0c             	sub    $0xc,%esp
80104e6b:	68 60 9d 10 80       	push   $0x80109d60
80104e70:	e8 51 b5 ff ff       	call   801003c6 <cprintf>
80104e75:	83 c4 10             	add    $0x10,%esp
    }
    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
80104e78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e7e:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    if (addToStateListHead(&ptable.pLists.zombie, proc) < 0) {
80104e85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e8b:	83 ec 08             	sub    $0x8,%esp
80104e8e:	50                   	push   %eax
80104e8f:	68 c0 6e 11 80       	push   $0x80116ec0
80104e94:	e8 f0 0d 00 00       	call   80105c89 <addToStateListHead>
80104e99:	83 c4 10             	add    $0x10,%esp
80104e9c:	85 c0                	test   %eax,%eax
80104e9e:	79 10                	jns    80104eb0 <exit+0x2a3>
        cprintf("Failed to add ZOMBIE proc to list (exit).\n");
80104ea0:	83 ec 0c             	sub    $0xc,%esp
80104ea3:	68 94 9d 10 80       	push   $0x80109d94
80104ea8:	e8 19 b5 ff ff       	call   801003c6 <cprintf>
80104ead:	83 c4 10             	add    $0x10,%esp
    }

    sched();
80104eb0:	e8 61 03 00 00       	call   80105216 <sched>
    panic("zombie exit");
80104eb5:	83 ec 0c             	sub    $0xc,%esp
80104eb8:	68 bf 9d 10 80       	push   $0x80109dbf
80104ebd:	e8 a4 b6 ff ff       	call   80100566 <panic>

80104ec2 <wait>:
    }
}
#else
int
wait(void)
{
80104ec2:	55                   	push   %ebp
80104ec3:	89 e5                	mov    %esp,%ebp
80104ec5:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
80104ec8:	83 ec 0c             	sub    $0xc,%esp
80104ecb:	68 80 49 11 80       	push   $0x80114980
80104ed0:	e8 68 12 00 00       	call   8010613d <acquire>
80104ed5:	83 c4 10             	add    $0x10,%esp
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
80104ed8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        // start at zombie list
        p = ptable.pLists.zombie;
80104edf:	a1 c0 6e 11 80       	mov    0x80116ec0,%eax
80104ee4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
80104ee7:	e9 03 01 00 00       	jmp    80104fef <wait+0x12d>
            if (p->parent == proc) {
80104eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eef:	8b 50 14             	mov    0x14(%eax),%edx
80104ef2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ef8:	39 c2                	cmp    %eax,%edx
80104efa:	0f 85 e3 00 00 00    	jne    80104fe3 <wait+0x121>
                havekids = 1;
80104f00:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
                pid = p->pid;
80104f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f0a:	8b 40 10             	mov    0x10(%eax),%eax
80104f0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
                kfree(p->kstack);
80104f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f13:	8b 40 08             	mov    0x8(%eax),%eax
80104f16:	83 ec 0c             	sub    $0xc,%esp
80104f19:	50                   	push   %eax
80104f1a:	e8 5b dd ff ff       	call   80102c7a <kfree>
80104f1f:	83 c4 10             	add    $0x10,%esp
                p->kstack = 0;
80104f22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                freevm(p->pgdir);
80104f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f2f:	8b 40 04             	mov    0x4(%eax),%eax
80104f32:	83 ec 0c             	sub    $0xc,%esp
80104f35:	50                   	push   %eax
80104f36:	e8 b0 45 00 00       	call   801094eb <freevm>
80104f3b:	83 c4 10             	add    $0x10,%esp
                assertState(p, ZOMBIE);
80104f3e:	83 ec 08             	sub    $0x8,%esp
80104f41:	6a 05                	push   $0x5
80104f43:	ff 75 f4             	pushl  -0xc(%ebp)
80104f46:	e8 0a 0d 00 00       	call   80105c55 <assertState>
80104f4b:	83 c4 10             	add    $0x10,%esp
                if (removeFromStateList(&ptable.pLists.zombie, p) < 0) {
80104f4e:	83 ec 08             	sub    $0x8,%esp
80104f51:	ff 75 f4             	pushl  -0xc(%ebp)
80104f54:	68 c0 6e 11 80       	push   $0x80116ec0
80104f59:	e8 18 0e 00 00       	call   80105d76 <removeFromStateList>
80104f5e:	83 c4 10             	add    $0x10,%esp
80104f61:	85 c0                	test   %eax,%eax
80104f63:	79 10                	jns    80104f75 <wait+0xb3>
                    cprintf("Failed to remove ZOMBIE process from list (wait).\n");
80104f65:	83 ec 0c             	sub    $0xc,%esp
80104f68:	68 cc 9d 10 80       	push   $0x80109dcc
80104f6d:	e8 54 b4 ff ff       	call   801003c6 <cprintf>
80104f72:	83 c4 10             	add    $0x10,%esp
                }
                p->state = UNUSED;
80104f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f78:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                if (addToStateListHead(&ptable.pLists.free, p) < 0) {
80104f7f:	83 ec 08             	sub    $0x8,%esp
80104f82:	ff 75 f4             	pushl  -0xc(%ebp)
80104f85:	68 b8 6e 11 80       	push   $0x80116eb8
80104f8a:	e8 fa 0c 00 00       	call   80105c89 <addToStateListHead>
80104f8f:	83 c4 10             	add    $0x10,%esp
80104f92:	85 c0                	test   %eax,%eax
80104f94:	79 10                	jns    80104fa6 <wait+0xe4>
                    cprintf("Failed to add UNUSED process to list (wait).\n");
80104f96:	83 ec 0c             	sub    $0xc,%esp
80104f99:	68 00 9e 10 80       	push   $0x80109e00
80104f9e:	e8 23 b4 ff ff       	call   801003c6 <cprintf>
80104fa3:	83 c4 10             	add    $0x10,%esp
                }
                p->pid = 0;
80104fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa9:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
80104fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fb3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
80104fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fbd:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
80104fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc4:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                release(&ptable.lock);
80104fcb:	83 ec 0c             	sub    $0xc,%esp
80104fce:	68 80 49 11 80       	push   $0x80114980
80104fd3:	e8 cc 11 00 00       	call   801061a4 <release>
80104fd8:	83 c4 10             	add    $0x10,%esp
                return pid;
80104fdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fde:	e9 0d 01 00 00       	jmp    801050f0 <wait+0x22e>
            }
            p = p->next;
80104fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fe6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
        // start at zombie list
        p = ptable.pLists.zombie;
        while (!havekids && p) {
80104fef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104ff3:	75 0a                	jne    80104fff <wait+0x13d>
80104ff5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104ff9:	0f 85 ed fe ff ff    	jne    80104eec <wait+0x2a>
                return pid;
            }
            p = p->next;
        }
        // Runnable list
        p = ptable.pLists.ready;
80104fff:	a1 b4 6e 11 80       	mov    0x80116eb4,%eax
80105004:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
80105007:	eb 23                	jmp    8010502c <wait+0x16a>
            if (p->parent == proc) {
80105009:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010500c:	8b 50 14             	mov    0x14(%eax),%edx
8010500f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105015:	39 c2                	cmp    %eax,%edx
80105017:	75 07                	jne    80105020 <wait+0x15e>
                havekids = 1;
80105019:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            }
            p = p->next;
80105020:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105023:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105029:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
        // Runnable list
        p = ptable.pLists.ready;
        while (!havekids && p) {
8010502c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105030:	75 06                	jne    80105038 <wait+0x176>
80105032:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105036:	75 d1                	jne    80105009 <wait+0x147>
                havekids = 1;
            }
            p = p->next;
        }
        // Running list
        p = ptable.pLists.running;
80105038:	a1 c4 6e 11 80       	mov    0x80116ec4,%eax
8010503d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
80105040:	eb 23                	jmp    80105065 <wait+0x1a3>
            if (p->parent == proc) {
80105042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105045:	8b 50 14             	mov    0x14(%eax),%edx
80105048:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010504e:	39 c2                	cmp    %eax,%edx
80105050:	75 07                	jne    80105059 <wait+0x197>
                havekids = 1;
80105052:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            }
            p = p->next;
80105059:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010505c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105062:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
        // Running list
        p = ptable.pLists.running;
        while (!havekids && p) {
80105065:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105069:	75 06                	jne    80105071 <wait+0x1af>
8010506b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010506f:	75 d1                	jne    80105042 <wait+0x180>
                havekids = 1;
            }
            p = p->next;
        }
        // Sleep list
        p = ptable.pLists.sleep;
80105071:	a1 bc 6e 11 80       	mov    0x80116ebc,%eax
80105076:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
80105079:	eb 23                	jmp    8010509e <wait+0x1dc>
            if (p->parent == proc) {
8010507b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010507e:	8b 50 14             	mov    0x14(%eax),%edx
80105081:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105087:	39 c2                	cmp    %eax,%edx
80105089:	75 07                	jne    80105092 <wait+0x1d0>
                havekids = 1;
8010508b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            }
            p = p->next;
80105092:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105095:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010509b:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
        // Sleep list
        p = ptable.pLists.sleep;
        while (!havekids && p) {
8010509e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801050a2:	75 06                	jne    801050aa <wait+0x1e8>
801050a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050a8:	75 d1                	jne    8010507b <wait+0x1b9>
                havekids = 1;
            }
            p = p->next;
        }
        // No point waiting if we don't have any children.
        if(!havekids || proc->killed) {
801050aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801050ae:	74 0d                	je     801050bd <wait+0x1fb>
801050b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050b6:	8b 40 24             	mov    0x24(%eax),%eax
801050b9:	85 c0                	test   %eax,%eax
801050bb:	74 17                	je     801050d4 <wait+0x212>
            release(&ptable.lock);
801050bd:	83 ec 0c             	sub    $0xc,%esp
801050c0:	68 80 49 11 80       	push   $0x80114980
801050c5:	e8 da 10 00 00       	call   801061a4 <release>
801050ca:	83 c4 10             	add    $0x10,%esp
            return -1;
801050cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050d2:	eb 1c                	jmp    801050f0 <wait+0x22e>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
801050d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050da:	83 ec 08             	sub    $0x8,%esp
801050dd:	68 80 49 11 80       	push   $0x80114980
801050e2:	50                   	push   %eax
801050e3:	e8 0b 03 00 00       	call   801053f3 <sleep>
801050e8:	83 c4 10             	add    $0x10,%esp
    }
801050eb:	e9 e8 fd ff ff       	jmp    80104ed8 <wait+0x16>
}
801050f0:	c9                   	leave  
801050f1:	c3                   	ret    

801050f2 <scheduler>:

#else
// Project 3 scheduler
void
scheduler(void)
{
801050f2:	55                   	push   %ebp
801050f3:	89 e5                	mov    %esp,%ebp
801050f5:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    int idle;  // for checking if processor is idle
    for(;;){
        // Enable interrupts on this processor.
        sti();
801050f8:	e8 09 f4 ff ff       	call   80104506 <sti>
        idle = 1;  // assume idle unless we schedule a process
801050fd:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
80105104:	83 ec 0c             	sub    $0xc,%esp
80105107:	68 80 49 11 80       	push   $0x80114980
8010510c:	e8 2c 10 00 00       	call   8010613d <acquire>
80105111:	83 c4 10             	add    $0x10,%esp
        if (ptable.pLists.ready) {
80105114:	a1 b4 6e 11 80       	mov    0x80116eb4,%eax
80105119:	85 c0                	test   %eax,%eax
8010511b:	0f 84 cc 00 00 00    	je     801051ed <scheduler+0xfb>
            p = ptable.pLists.ready;
80105121:	a1 b4 6e 11 80       	mov    0x80116eb4,%eax
80105126:	89 45 f0             	mov    %eax,-0x10(%ebp)
            assertState(p, RUNNABLE);
80105129:	83 ec 08             	sub    $0x8,%esp
8010512c:	6a 03                	push   $0x3
8010512e:	ff 75 f0             	pushl  -0x10(%ebp)
80105131:	e8 1f 0b 00 00       	call   80105c55 <assertState>
80105136:	83 c4 10             	add    $0x10,%esp
            p = removeHead(&ptable.pLists.ready); // remove first ready process
80105139:	83 ec 0c             	sub    $0xc,%esp
8010513c:	68 b4 6e 11 80       	push   $0x80116eb4
80105141:	e8 1a 0d 00 00       	call   80105e60 <removeHead>
80105146:	83 c4 10             	add    $0x10,%esp
80105149:	89 45 f0             	mov    %eax,-0x10(%ebp)
            if (!p) {
8010514c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105150:	75 0d                	jne    8010515f <scheduler+0x6d>
                panic("Scheduler: removeHead failed.");
80105152:	83 ec 0c             	sub    $0xc,%esp
80105155:	68 2e 9e 10 80       	push   $0x80109e2e
8010515a:	e8 07 b4 ff ff       	call   80100566 <panic>
            }
            idle = 0;
8010515f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            proc = p;
80105166:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105169:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
            switchuvm(p);
8010516f:	83 ec 0c             	sub    $0xc,%esp
80105172:	ff 75 f0             	pushl  -0x10(%ebp)
80105175:	e8 2b 3f 00 00       	call   801090a5 <switchuvm>
8010517a:	83 c4 10             	add    $0x10,%esp
            p->state = RUNNING;
8010517d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105180:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
            // add to end of running list
            if (addToStateListEnd(&ptable.pLists.running, p) < 0) {
80105187:	83 ec 08             	sub    $0x8,%esp
8010518a:	ff 75 f0             	pushl  -0x10(%ebp)
8010518d:	68 c4 6e 11 80       	push   $0x80116ec4
80105192:	e8 5e 0b 00 00       	call   80105cf5 <addToStateListEnd>
80105197:	83 c4 10             	add    $0x10,%esp
8010519a:	85 c0                	test   %eax,%eax
8010519c:	79 10                	jns    801051ae <scheduler+0xbc>
                cprintf("Failed to add RUNNING proc to list (scheduler).");
8010519e:	83 ec 0c             	sub    $0xc,%esp
801051a1:	68 4c 9e 10 80       	push   $0x80109e4c
801051a6:	e8 1b b2 ff ff       	call   801003c6 <cprintf>
801051ab:	83 c4 10             	add    $0x10,%esp
            }
            p->cpu_ticks_in = ticks; // ticks when scheduled
801051ae:	8b 15 e0 76 11 80    	mov    0x801176e0,%edx
801051b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051b7:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
            swtch(&cpu->scheduler, proc->context);
801051bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051c3:	8b 40 1c             	mov    0x1c(%eax),%eax
801051c6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801051cd:	83 c2 04             	add    $0x4,%edx
801051d0:	83 ec 08             	sub    $0x8,%esp
801051d3:	50                   	push   %eax
801051d4:	52                   	push   %edx
801051d5:	e8 3a 14 00 00       	call   80106614 <swtch>
801051da:	83 c4 10             	add    $0x10,%esp
            switchkvm();
801051dd:	e8 a6 3e 00 00       	call   80109088 <switchkvm>
            // Process is done running for now.
            // It should have changed its p->state before coming back.
            proc = 0;
801051e2:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801051e9:	00 00 00 00 
        }
        release(&ptable.lock);
801051ed:	83 ec 0c             	sub    $0xc,%esp
801051f0:	68 80 49 11 80       	push   $0x80114980
801051f5:	e8 aa 0f 00 00       	call   801061a4 <release>
801051fa:	83 c4 10             	add    $0x10,%esp
        if (idle) {
801051fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105201:	0f 84 f1 fe ff ff    	je     801050f8 <scheduler+0x6>
            sti();
80105207:	e8 fa f2 ff ff       	call   80104506 <sti>
            hlt();
8010520c:	e8 de f2 ff ff       	call   801044ef <hlt>
        }
    }
80105211:	e9 e2 fe ff ff       	jmp    801050f8 <scheduler+0x6>

80105216 <sched>:
    cpu->intena = intena;
}
#else
void
sched(void)
{
80105216:	55                   	push   %ebp
80105217:	89 e5                	mov    %esp,%ebp
80105219:	53                   	push   %ebx
8010521a:	83 ec 14             	sub    $0x14,%esp
    int intena;

    if(!holding(&ptable.lock))
8010521d:	83 ec 0c             	sub    $0xc,%esp
80105220:	68 80 49 11 80       	push   $0x80114980
80105225:	e8 46 10 00 00       	call   80106270 <holding>
8010522a:	83 c4 10             	add    $0x10,%esp
8010522d:	85 c0                	test   %eax,%eax
8010522f:	75 0d                	jne    8010523e <sched+0x28>
        panic("sched ptable.lock");
80105231:	83 ec 0c             	sub    $0xc,%esp
80105234:	68 7c 9e 10 80       	push   $0x80109e7c
80105239:	e8 28 b3 ff ff       	call   80100566 <panic>
    if(cpu->ncli != 1)
8010523e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105244:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010524a:	83 f8 01             	cmp    $0x1,%eax
8010524d:	74 0d                	je     8010525c <sched+0x46>
        panic("sched locks");
8010524f:	83 ec 0c             	sub    $0xc,%esp
80105252:	68 8e 9e 10 80       	push   $0x80109e8e
80105257:	e8 0a b3 ff ff       	call   80100566 <panic>
    if(proc->state == RUNNING)
8010525c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105262:	8b 40 0c             	mov    0xc(%eax),%eax
80105265:	83 f8 04             	cmp    $0x4,%eax
80105268:	75 0d                	jne    80105277 <sched+0x61>
        panic("sched running");
8010526a:	83 ec 0c             	sub    $0xc,%esp
8010526d:	68 9a 9e 10 80       	push   $0x80109e9a
80105272:	e8 ef b2 ff ff       	call   80100566 <panic>
    if(readeflags()&FL_IF)
80105277:	e8 7a f2 ff ff       	call   801044f6 <readeflags>
8010527c:	25 00 02 00 00       	and    $0x200,%eax
80105281:	85 c0                	test   %eax,%eax
80105283:	74 0d                	je     80105292 <sched+0x7c>
        panic("sched interruptible");
80105285:	83 ec 0c             	sub    $0xc,%esp
80105288:	68 a8 9e 10 80       	push   $0x80109ea8
8010528d:	e8 d4 b2 ff ff       	call   80100566 <panic>
    intena = cpu->intena;
80105292:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105298:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010529e:	89 45 f4             	mov    %eax,-0xc(%ebp)

#ifdef CS333_P2
    proc->cpu_ticks_total += (ticks - proc->cpu_ticks_in);
801052a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052a7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052ae:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801052b4:	8b 1d e0 76 11 80    	mov    0x801176e0,%ebx
801052ba:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052c1:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801052c7:	29 d3                	sub    %edx,%ebx
801052c9:	89 da                	mov    %ebx,%edx
801052cb:	01 ca                	add    %ecx,%edx
801052cd:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
#endif

    swtch(&proc->context, cpu->scheduler);
801052d3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052d9:	8b 40 04             	mov    0x4(%eax),%eax
801052dc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801052e3:	83 c2 1c             	add    $0x1c,%edx
801052e6:	83 ec 08             	sub    $0x8,%esp
801052e9:	50                   	push   %eax
801052ea:	52                   	push   %edx
801052eb:	e8 24 13 00 00       	call   80106614 <swtch>
801052f0:	83 c4 10             	add    $0x10,%esp

    cpu->intena = intena;
801052f3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801052fc:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105302:	90                   	nop
80105303:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105306:	c9                   	leave  
80105307:	c3                   	ret    

80105308 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105308:	55                   	push   %ebp
80105309:	89 e5                	mov    %esp,%ebp
8010530b:	83 ec 08             	sub    $0x8,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
8010530e:	83 ec 0c             	sub    $0xc,%esp
80105311:	68 80 49 11 80       	push   $0x80114980
80105316:	e8 22 0e 00 00       	call   8010613d <acquire>
8010531b:	83 c4 10             	add    $0x10,%esp
#ifdef CS333_P3P4
    assertState(proc, RUNNING);
8010531e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105324:	83 ec 08             	sub    $0x8,%esp
80105327:	6a 04                	push   $0x4
80105329:	50                   	push   %eax
8010532a:	e8 26 09 00 00       	call   80105c55 <assertState>
8010532f:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
80105332:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105338:	83 ec 08             	sub    $0x8,%esp
8010533b:	50                   	push   %eax
8010533c:	68 c4 6e 11 80       	push   $0x80116ec4
80105341:	e8 30 0a 00 00       	call   80105d76 <removeFromStateList>
80105346:	83 c4 10             	add    $0x10,%esp
80105349:	85 c0                	test   %eax,%eax
8010534b:	79 10                	jns    8010535d <yield+0x55>
        cprintf("Failed to remove RUNNING proc to list (yeild).");
8010534d:	83 ec 0c             	sub    $0xc,%esp
80105350:	68 bc 9e 10 80       	push   $0x80109ebc
80105355:	e8 6c b0 ff ff       	call   801003c6 <cprintf>
8010535a:	83 c4 10             	add    $0x10,%esp
    }
#endif

    proc->state = RUNNABLE;
8010535d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105363:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

#ifdef CS333_P3P4
    if (addToStateListEnd(&ptable.pLists.ready, proc) < 0) {
8010536a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105370:	83 ec 08             	sub    $0x8,%esp
80105373:	50                   	push   %eax
80105374:	68 b4 6e 11 80       	push   $0x80116eb4
80105379:	e8 77 09 00 00       	call   80105cf5 <addToStateListEnd>
8010537e:	83 c4 10             	add    $0x10,%esp
80105381:	85 c0                	test   %eax,%eax
80105383:	79 10                	jns    80105395 <yield+0x8d>
        cprintf("Failed to add RUNNABLE proc to list (yeild).");
80105385:	83 ec 0c             	sub    $0xc,%esp
80105388:	68 ec 9e 10 80       	push   $0x80109eec
8010538d:	e8 34 b0 ff ff       	call   801003c6 <cprintf>
80105392:	83 c4 10             	add    $0x10,%esp
    }
#endif
    sched();
80105395:	e8 7c fe ff ff       	call   80105216 <sched>
    release(&ptable.lock);
8010539a:	83 ec 0c             	sub    $0xc,%esp
8010539d:	68 80 49 11 80       	push   $0x80114980
801053a2:	e8 fd 0d 00 00       	call   801061a4 <release>
801053a7:	83 c4 10             	add    $0x10,%esp
}
801053aa:	90                   	nop
801053ab:	c9                   	leave  
801053ac:	c3                   	ret    

801053ad <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801053ad:	55                   	push   %ebp
801053ae:	89 e5                	mov    %esp,%ebp
801053b0:	83 ec 08             	sub    $0x8,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
801053b3:	83 ec 0c             	sub    $0xc,%esp
801053b6:	68 80 49 11 80       	push   $0x80114980
801053bb:	e8 e4 0d 00 00       	call   801061a4 <release>
801053c0:	83 c4 10             	add    $0x10,%esp

    if (first) {
801053c3:	a1 20 d0 10 80       	mov    0x8010d020,%eax
801053c8:	85 c0                	test   %eax,%eax
801053ca:	74 24                	je     801053f0 <forkret+0x43>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot 
        // be run from main().
        first = 0;
801053cc:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
801053d3:	00 00 00 
        iinit(ROOTDEV);
801053d6:	83 ec 0c             	sub    $0xc,%esp
801053d9:	6a 01                	push   $0x1
801053db:	e8 0f c3 ff ff       	call   801016ef <iinit>
801053e0:	83 c4 10             	add    $0x10,%esp
        initlog(ROOTDEV);
801053e3:	83 ec 0c             	sub    $0xc,%esp
801053e6:	6a 01                	push   $0x1
801053e8:	e8 f3 df ff ff       	call   801033e0 <initlog>
801053ed:	83 c4 10             	add    $0x10,%esp
    }

    // Return to "caller", actually trapret (see allocproc).
}
801053f0:	90                   	nop
801053f1:	c9                   	leave  
801053f2:	c3                   	ret    

801053f3 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
801053f3:	55                   	push   %ebp
801053f4:	89 e5                	mov    %esp,%ebp
801053f6:	83 ec 08             	sub    $0x8,%esp
    if(proc == 0)
801053f9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053ff:	85 c0                	test   %eax,%eax
80105401:	75 0d                	jne    80105410 <sleep+0x1d>
        panic("sleep");
80105403:	83 ec 0c             	sub    $0xc,%esp
80105406:	68 19 9f 10 80       	push   $0x80109f19
8010540b:	e8 56 b1 ff ff       	call   80100566 <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){
80105410:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
80105417:	74 24                	je     8010543d <sleep+0x4a>
        acquire(&ptable.lock);
80105419:	83 ec 0c             	sub    $0xc,%esp
8010541c:	68 80 49 11 80       	push   $0x80114980
80105421:	e8 17 0d 00 00       	call   8010613d <acquire>
80105426:	83 c4 10             	add    $0x10,%esp
        if (lk) release(lk);
80105429:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010542d:	74 0e                	je     8010543d <sleep+0x4a>
8010542f:	83 ec 0c             	sub    $0xc,%esp
80105432:	ff 75 0c             	pushl  0xc(%ebp)
80105435:	e8 6a 0d 00 00       	call   801061a4 <release>
8010543a:	83 c4 10             	add    $0x10,%esp
    }

    // Go to sleep.
    proc->chan = chan;
8010543d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105443:	8b 55 08             	mov    0x8(%ebp),%edx
80105446:	89 50 20             	mov    %edx,0x20(%eax)

#ifdef CS333_P3P4
    assertState(proc, RUNNING);
80105449:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010544f:	83 ec 08             	sub    $0x8,%esp
80105452:	6a 04                	push   $0x4
80105454:	50                   	push   %eax
80105455:	e8 fb 07 00 00       	call   80105c55 <assertState>
8010545a:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
8010545d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105463:	83 ec 08             	sub    $0x8,%esp
80105466:	50                   	push   %eax
80105467:	68 c4 6e 11 80       	push   $0x80116ec4
8010546c:	e8 05 09 00 00       	call   80105d76 <removeFromStateList>
80105471:	83 c4 10             	add    $0x10,%esp
80105474:	85 c0                	test   %eax,%eax
80105476:	79 10                	jns    80105488 <sleep+0x95>
        cprintf("Could not remove RUNNING proc from list (sleep()).\n");
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	68 20 9f 10 80       	push   $0x80109f20
80105480:	e8 41 af ff ff       	call   801003c6 <cprintf>
80105485:	83 c4 10             	add    $0x10,%esp
    }
#endif
    proc->state = SLEEPING;
80105488:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010548e:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

#ifdef CS333_P3P4
    if (addToStateListEnd(&ptable.pLists.sleep, proc) < 0) {
80105495:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010549b:	83 ec 08             	sub    $0x8,%esp
8010549e:	50                   	push   %eax
8010549f:	68 bc 6e 11 80       	push   $0x80116ebc
801054a4:	e8 4c 08 00 00       	call   80105cf5 <addToStateListEnd>
801054a9:	83 c4 10             	add    $0x10,%esp
801054ac:	85 c0                	test   %eax,%eax
801054ae:	79 10                	jns    801054c0 <sleep+0xcd>
        cprintf("Could not add SLEEPING proc to list (sleep()).\n");
801054b0:	83 ec 0c             	sub    $0xc,%esp
801054b3:	68 54 9f 10 80       	push   $0x80109f54
801054b8:	e8 09 af ff ff       	call   801003c6 <cprintf>
801054bd:	83 c4 10             	add    $0x10,%esp
    }
#endif

    sched();
801054c0:	e8 51 fd ff ff       	call   80105216 <sched>

    // Tidy up.
    proc->chan = 0;
801054c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054cb:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){ 
801054d2:	81 7d 0c 80 49 11 80 	cmpl   $0x80114980,0xc(%ebp)
801054d9:	74 24                	je     801054ff <sleep+0x10c>
        release(&ptable.lock);
801054db:	83 ec 0c             	sub    $0xc,%esp
801054de:	68 80 49 11 80       	push   $0x80114980
801054e3:	e8 bc 0c 00 00       	call   801061a4 <release>
801054e8:	83 c4 10             	add    $0x10,%esp
        if (lk) acquire(lk);
801054eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801054ef:	74 0e                	je     801054ff <sleep+0x10c>
801054f1:	83 ec 0c             	sub    $0xc,%esp
801054f4:	ff 75 0c             	pushl  0xc(%ebp)
801054f7:	e8 41 0c 00 00       	call   8010613d <acquire>
801054fc:	83 c4 10             	add    $0x10,%esp
    }
}
801054ff:	90                   	nop
80105500:	c9                   	leave  
80105501:	c3                   	ret    

80105502 <wakeup1>:
}
#else
// P3 wakeup1
static void
wakeup1(void *chan)
{
80105502:	55                   	push   %ebp
80105503:	89 e5                	mov    %esp,%ebp
80105505:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    if (ptable.pLists.sleep) {
80105508:	a1 bc 6e 11 80       	mov    0x80116ebc,%eax
8010550d:	85 c0                	test   %eax,%eax
8010550f:	0f 84 a3 00 00 00    	je     801055b8 <wakeup1+0xb6>
        struct proc * current = ptable.pLists.sleep;
80105515:	a1 bc 6e 11 80       	mov    0x80116ebc,%eax
8010551a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = 0;
8010551d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        while (current) {
80105524:	e9 85 00 00 00       	jmp    801055ae <wakeup1+0xac>
            p = current;
80105529:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010552c:	89 45 f0             	mov    %eax,-0x10(%ebp)
            current = current->next;
8010552f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105532:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105538:	89 45 f4             	mov    %eax,-0xc(%ebp)
            assertState(p, SLEEPING);
8010553b:	83 ec 08             	sub    $0x8,%esp
8010553e:	6a 02                	push   $0x2
80105540:	ff 75 f0             	pushl  -0x10(%ebp)
80105543:	e8 0d 07 00 00       	call   80105c55 <assertState>
80105548:	83 c4 10             	add    $0x10,%esp
            if (p->chan == chan) {
8010554b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010554e:	8b 40 20             	mov    0x20(%eax),%eax
80105551:	3b 45 08             	cmp    0x8(%ebp),%eax
80105554:	75 58                	jne    801055ae <wakeup1+0xac>
                if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
80105556:	83 ec 08             	sub    $0x8,%esp
80105559:	ff 75 f0             	pushl  -0x10(%ebp)
8010555c:	68 bc 6e 11 80       	push   $0x80116ebc
80105561:	e8 10 08 00 00       	call   80105d76 <removeFromStateList>
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	85 c0                	test   %eax,%eax
8010556b:	79 10                	jns    8010557d <wakeup1+0x7b>
                    cprintf("Failed to remove SLEEPING proc to list (wakeup1).\n");
8010556d:	83 ec 0c             	sub    $0xc,%esp
80105570:	68 84 9f 10 80       	push   $0x80109f84
80105575:	e8 4c ae ff ff       	call   801003c6 <cprintf>
8010557a:	83 c4 10             	add    $0x10,%esp
                }
                p->state = RUNNABLE;
8010557d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105580:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
                if (addToStateListEnd(&ptable.pLists.ready, p) < 0) {
80105587:	83 ec 08             	sub    $0x8,%esp
8010558a:	ff 75 f0             	pushl  -0x10(%ebp)
8010558d:	68 b4 6e 11 80       	push   $0x80116eb4
80105592:	e8 5e 07 00 00       	call   80105cf5 <addToStateListEnd>
80105597:	83 c4 10             	add    $0x10,%esp
8010559a:	85 c0                	test   %eax,%eax
8010559c:	79 10                	jns    801055ae <wakeup1+0xac>
                    cprintf("Failed to add RUNNABLE proc to list (wakeup1).\n");
8010559e:	83 ec 0c             	sub    $0xc,%esp
801055a1:	68 b8 9f 10 80       	push   $0x80109fb8
801055a6:	e8 1b ae ff ff       	call   801003c6 <cprintf>
801055ab:	83 c4 10             	add    $0x10,%esp
{
    struct proc *p;
    if (ptable.pLists.sleep) {
        struct proc * current = ptable.pLists.sleep;
        p = 0;
        while (current) {
801055ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055b2:	0f 85 71 ff ff ff    	jne    80105529 <wakeup1+0x27>
                    cprintf("Failed to add RUNNABLE proc to list (wakeup1).\n");
                }
            }
        }
    }
}
801055b8:	90                   	nop
801055b9:	c9                   	leave  
801055ba:	c3                   	ret    

801055bb <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801055bb:	55                   	push   %ebp
801055bc:	89 e5                	mov    %esp,%ebp
801055be:	83 ec 08             	sub    $0x8,%esp
    acquire(&ptable.lock);
801055c1:	83 ec 0c             	sub    $0xc,%esp
801055c4:	68 80 49 11 80       	push   $0x80114980
801055c9:	e8 6f 0b 00 00       	call   8010613d <acquire>
801055ce:	83 c4 10             	add    $0x10,%esp
    wakeup1(chan);
801055d1:	83 ec 0c             	sub    $0xc,%esp
801055d4:	ff 75 08             	pushl  0x8(%ebp)
801055d7:	e8 26 ff ff ff       	call   80105502 <wakeup1>
801055dc:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
801055df:	83 ec 0c             	sub    $0xc,%esp
801055e2:	68 80 49 11 80       	push   $0x80114980
801055e7:	e8 b8 0b 00 00       	call   801061a4 <release>
801055ec:	83 c4 10             	add    $0x10,%esp
}
801055ef:	90                   	nop
801055f0:	c9                   	leave  
801055f1:	c3                   	ret    

801055f2 <kill>:
    return -1;
}
#else
int
kill(int pid)
{
801055f2:	55                   	push   %ebp
801055f3:	89 e5                	mov    %esp,%ebp
801055f5:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;

    acquire(&ptable.lock);
801055f8:	83 ec 0c             	sub    $0xc,%esp
801055fb:	68 80 49 11 80       	push   $0x80114980
80105600:	e8 38 0b 00 00       	call   8010613d <acquire>
80105605:	83 c4 10             	add    $0x10,%esp
    // traverse Sleeping list, wake processes if necessary
    p = ptable.pLists.sleep;
80105608:	a1 bc 6e 11 80       	mov    0x80116ebc,%eax
8010560d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105610:	e9 a9 00 00 00       	jmp    801056be <kill+0xcc>
        if (p->pid == pid) {
80105615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105618:	8b 50 10             	mov    0x10(%eax),%edx
8010561b:	8b 45 08             	mov    0x8(%ebp),%eax
8010561e:	39 c2                	cmp    %eax,%edx
80105620:	0f 85 8c 00 00 00    	jne    801056b2 <kill+0xc0>
            p->killed = 1;
80105626:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105629:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            assertState(p, SLEEPING);
80105630:	83 ec 08             	sub    $0x8,%esp
80105633:	6a 02                	push   $0x2
80105635:	ff 75 f4             	pushl  -0xc(%ebp)
80105638:	e8 18 06 00 00       	call   80105c55 <assertState>
8010563d:	83 c4 10             	add    $0x10,%esp
            if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
80105640:	83 ec 08             	sub    $0x8,%esp
80105643:	ff 75 f4             	pushl  -0xc(%ebp)
80105646:	68 bc 6e 11 80       	push   $0x80116ebc
8010564b:	e8 26 07 00 00       	call   80105d76 <removeFromStateList>
80105650:	83 c4 10             	add    $0x10,%esp
80105653:	85 c0                	test   %eax,%eax
80105655:	79 10                	jns    80105667 <kill+0x75>
                cprintf("Could not remove SLEEPING proc from list (kill).\n");
80105657:	83 ec 0c             	sub    $0xc,%esp
8010565a:	68 e8 9f 10 80       	push   $0x80109fe8
8010565f:	e8 62 ad ff ff       	call   801003c6 <cprintf>
80105664:	83 c4 10             	add    $0x10,%esp
            }
            p->state = RUNNABLE;
80105667:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010566a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            if (addToStateListEnd(&ptable.pLists.ready, p) < 0) {
80105671:	83 ec 08             	sub    $0x8,%esp
80105674:	ff 75 f4             	pushl  -0xc(%ebp)
80105677:	68 b4 6e 11 80       	push   $0x80116eb4
8010567c:	e8 74 06 00 00       	call   80105cf5 <addToStateListEnd>
80105681:	83 c4 10             	add    $0x10,%esp
80105684:	85 c0                	test   %eax,%eax
80105686:	79 10                	jns    80105698 <kill+0xa6>
                cprintf("Could not add RUNNABLE proc to list (kill).\n");
80105688:	83 ec 0c             	sub    $0xc,%esp
8010568b:	68 1c a0 10 80       	push   $0x8010a01c
80105690:	e8 31 ad ff ff       	call   801003c6 <cprintf>
80105695:	83 c4 10             	add    $0x10,%esp
            }
            release(&ptable.lock);
80105698:	83 ec 0c             	sub    $0xc,%esp
8010569b:	68 80 49 11 80       	push   $0x80114980
801056a0:	e8 ff 0a 00 00       	call   801061a4 <release>
801056a5:	83 c4 10             	add    $0x10,%esp
            return 0;
801056a8:	b8 00 00 00 00       	mov    $0x0,%eax
801056ad:	e9 a6 01 00 00       	jmp    80105858 <kill+0x266>
        }
        p = p->next;
801056b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056b5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801056bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct proc *p;

    acquire(&ptable.lock);
    // traverse Sleeping list, wake processes if necessary
    p = ptable.pLists.sleep;
    while (p) {
801056be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801056c2:	0f 85 4d ff ff ff    	jne    80105615 <kill+0x23>
        }
        p = p->next;
    }

    // traverse Runnable list
    p = ptable.pLists.ready;
801056c8:	a1 b4 6e 11 80       	mov    0x80116eb4,%eax
801056cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801056d0:	eb 3d                	jmp    8010570f <kill+0x11d>
        if (p->pid == pid) {
801056d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056d5:	8b 50 10             	mov    0x10(%eax),%edx
801056d8:	8b 45 08             	mov    0x8(%ebp),%eax
801056db:	39 c2                	cmp    %eax,%edx
801056dd:	75 24                	jne    80105703 <kill+0x111>
            p->killed = 1;
801056df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
801056e9:	83 ec 0c             	sub    $0xc,%esp
801056ec:	68 80 49 11 80       	push   $0x80114980
801056f1:	e8 ae 0a 00 00       	call   801061a4 <release>
801056f6:	83 c4 10             	add    $0x10,%esp
            return 0;
801056f9:	b8 00 00 00 00       	mov    $0x0,%eax
801056fe:	e9 55 01 00 00       	jmp    80105858 <kill+0x266>
        }
        p = p->next;
80105703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105706:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010570c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Runnable list
    p = ptable.pLists.ready;
    while (p) {
8010570f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105713:	75 bd                	jne    801056d2 <kill+0xe0>
        }
        p = p->next;
    }

    // traverse Running list
    p = ptable.pLists.running;
80105715:	a1 c4 6e 11 80       	mov    0x80116ec4,%eax
8010571a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
8010571d:	eb 3d                	jmp    8010575c <kill+0x16a>
        if (p->pid == pid) {
8010571f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105722:	8b 50 10             	mov    0x10(%eax),%edx
80105725:	8b 45 08             	mov    0x8(%ebp),%eax
80105728:	39 c2                	cmp    %eax,%edx
8010572a:	75 24                	jne    80105750 <kill+0x15e>
            p->killed = 1;
8010572c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105736:	83 ec 0c             	sub    $0xc,%esp
80105739:	68 80 49 11 80       	push   $0x80114980
8010573e:	e8 61 0a 00 00       	call   801061a4 <release>
80105743:	83 c4 10             	add    $0x10,%esp
            return 0;
80105746:	b8 00 00 00 00       	mov    $0x0,%eax
8010574b:	e9 08 01 00 00       	jmp    80105858 <kill+0x266>
        }
        p = p->next;
80105750:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105753:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105759:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Running list
    p = ptable.pLists.running;
    while (p) {
8010575c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105760:	75 bd                	jne    8010571f <kill+0x12d>
        }
        p = p->next;
    }

    // traverse Unused List
    p = ptable.pLists.free;
80105762:	a1 b8 6e 11 80       	mov    0x80116eb8,%eax
80105767:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
8010576a:	eb 3d                	jmp    801057a9 <kill+0x1b7>
        if (p->pid == pid) {
8010576c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010576f:	8b 50 10             	mov    0x10(%eax),%edx
80105772:	8b 45 08             	mov    0x8(%ebp),%eax
80105775:	39 c2                	cmp    %eax,%edx
80105777:	75 24                	jne    8010579d <kill+0x1ab>
            p->killed = 1;
80105779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010577c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105783:	83 ec 0c             	sub    $0xc,%esp
80105786:	68 80 49 11 80       	push   $0x80114980
8010578b:	e8 14 0a 00 00       	call   801061a4 <release>
80105790:	83 c4 10             	add    $0x10,%esp
            return 0;
80105793:	b8 00 00 00 00       	mov    $0x0,%eax
80105798:	e9 bb 00 00 00       	jmp    80105858 <kill+0x266>
        }
        p = p->next;
8010579d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057a0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801057a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Unused List
    p = ptable.pLists.free;
    while (p) {
801057a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057ad:	75 bd                	jne    8010576c <kill+0x17a>
        }
        p = p->next;
    }

    // traverse Zombie list
    p = ptable.pLists.zombie;
801057af:	a1 c0 6e 11 80       	mov    0x80116ec0,%eax
801057b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801057b7:	eb 3a                	jmp    801057f3 <kill+0x201>
        if (p->pid == pid) {
801057b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057bc:	8b 50 10             	mov    0x10(%eax),%edx
801057bf:	8b 45 08             	mov    0x8(%ebp),%eax
801057c2:	39 c2                	cmp    %eax,%edx
801057c4:	75 21                	jne    801057e7 <kill+0x1f5>
            p->killed = 1;
801057c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057c9:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
801057d0:	83 ec 0c             	sub    $0xc,%esp
801057d3:	68 80 49 11 80       	push   $0x80114980
801057d8:	e8 c7 09 00 00       	call   801061a4 <release>
801057dd:	83 c4 10             	add    $0x10,%esp
            return 0;
801057e0:	b8 00 00 00 00       	mov    $0x0,%eax
801057e5:	eb 71                	jmp    80105858 <kill+0x266>
        }
        p = p->next;
801057e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ea:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801057f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Zombie list
    p = ptable.pLists.zombie;
    while (p) {
801057f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057f7:	75 c0                	jne    801057b9 <kill+0x1c7>
        }
        p = p->next;
    }

    // traverse Embryo list
    p = ptable.pLists.embryo;
801057f9:	a1 c8 6e 11 80       	mov    0x80116ec8,%eax
801057fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105801:	eb 3a                	jmp    8010583d <kill+0x24b>
        if (p->pid == pid) {
80105803:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105806:	8b 50 10             	mov    0x10(%eax),%edx
80105809:	8b 45 08             	mov    0x8(%ebp),%eax
8010580c:	39 c2                	cmp    %eax,%edx
8010580e:	75 21                	jne    80105831 <kill+0x23f>
            p->killed = 1;
80105810:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105813:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
8010581a:	83 ec 0c             	sub    $0xc,%esp
8010581d:	68 80 49 11 80       	push   $0x80114980
80105822:	e8 7d 09 00 00       	call   801061a4 <release>
80105827:	83 c4 10             	add    $0x10,%esp
            return 0;
8010582a:	b8 00 00 00 00       	mov    $0x0,%eax
8010582f:	eb 27                	jmp    80105858 <kill+0x266>
        }
        p = p->next;
80105831:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105834:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010583a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Embryo list
    p = ptable.pLists.embryo;
    while (p) {
8010583d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105841:	75 c0                	jne    80105803 <kill+0x211>
        }
        p = p->next;
    }

    // return error
    release(&ptable.lock);
80105843:	83 ec 0c             	sub    $0xc,%esp
80105846:	68 80 49 11 80       	push   $0x80114980
8010584b:	e8 54 09 00 00       	call   801061a4 <release>
80105850:	83 c4 10             	add    $0x10,%esp
    return -1;
80105853:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105858:	c9                   	leave  
80105859:	c3                   	ret    

8010585a <elapsed_time>:
// No lock to avoid wedging a stuck machine further.

#ifdef CS333_P1
void
elapsed_time(uint p_ticks)
{
8010585a:	55                   	push   %ebp
8010585b:	89 e5                	mov    %esp,%ebp
8010585d:	83 ec 28             	sub    $0x28,%esp
    uint elapsed, whole_sec, milisec_ten, milisec_hund, milisec_thou;
    //elapsed = ticks - p->start_ticks; // find original elapsed time
    elapsed = p_ticks;
80105860:	8b 45 08             	mov    0x8(%ebp),%eax
80105863:	89 45 f4             	mov    %eax,-0xc(%ebp)
    whole_sec = (elapsed / 1000); // the the left of the decimal point
80105866:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105869:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
8010586e:	f7 e2                	mul    %edx
80105870:	89 d0                	mov    %edx,%eax
80105872:	c1 e8 06             	shr    $0x6,%eax
80105875:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // % to shave off leading digit of elapsed for decimal place calcs
    milisec_ten = ((elapsed %= 1000) / 100); // divide and round up to nearest int
80105878:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010587b:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105880:	89 c8                	mov    %ecx,%eax
80105882:	f7 e2                	mul    %edx
80105884:	89 d0                	mov    %edx,%eax
80105886:	c1 e8 06             	shr    $0x6,%eax
80105889:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
8010588f:	29 c1                	sub    %eax,%ecx
80105891:	89 c8                	mov    %ecx,%eax
80105893:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105896:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105899:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
8010589e:	f7 e2                	mul    %edx
801058a0:	89 d0                	mov    %edx,%eax
801058a2:	c1 e8 05             	shr    $0x5,%eax
801058a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    milisec_hund = ((elapsed %= 100) / 10); // shave off previously counted int, repeat
801058a8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801058ab:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
801058b0:	89 c8                	mov    %ecx,%eax
801058b2:	f7 e2                	mul    %edx
801058b4:	89 d0                	mov    %edx,%eax
801058b6:	c1 e8 05             	shr    $0x5,%eax
801058b9:	6b c0 64             	imul   $0x64,%eax,%eax
801058bc:	29 c1                	sub    %eax,%ecx
801058be:	89 c8                	mov    %ecx,%eax
801058c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c6:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801058cb:	f7 e2                	mul    %edx
801058cd:	89 d0                	mov    %edx,%eax
801058cf:	c1 e8 03             	shr    $0x3,%eax
801058d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    milisec_thou = (elapsed %= 10); // determine thousandth place
801058d5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801058d8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801058dd:	89 c8                	mov    %ecx,%eax
801058df:	f7 e2                	mul    %edx
801058e1:	c1 ea 03             	shr    $0x3,%edx
801058e4:	89 d0                	mov    %edx,%eax
801058e6:	c1 e0 02             	shl    $0x2,%eax
801058e9:	01 d0                	add    %edx,%eax
801058eb:	01 c0                	add    %eax,%eax
801058ed:	29 c1                	sub    %eax,%ecx
801058ef:	89 c8                	mov    %ecx,%eax
801058f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801058f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("\t%d.%d%d%d", whole_sec, milisec_ten, milisec_hund, milisec_thou);
801058fa:	83 ec 0c             	sub    $0xc,%esp
801058fd:	ff 75 e4             	pushl  -0x1c(%ebp)
80105900:	ff 75 e8             	pushl  -0x18(%ebp)
80105903:	ff 75 ec             	pushl  -0x14(%ebp)
80105906:	ff 75 f0             	pushl  -0x10(%ebp)
80105909:	68 49 a0 10 80       	push   $0x8010a049
8010590e:	e8 b3 aa ff ff       	call   801003c6 <cprintf>
80105913:	83 c4 20             	add    $0x20,%esp
}
80105916:	90                   	nop
80105917:	c9                   	leave  
80105918:	c3                   	ret    

80105919 <procdump>:
#endif

void
procdump(void)
{
80105919:	55                   	push   %ebp
8010591a:	89 e5                	mov    %esp,%ebp
8010591c:	56                   	push   %esi
8010591d:	53                   	push   %ebx
8010591e:	83 ec 40             	sub    $0x40,%esp
#endif
#endif

    // formatting if project 2 is enabled in makefile
#ifdef CS333_P2
    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
80105921:	83 ec 04             	sub    $0x4,%esp
80105924:	68 54 a0 10 80       	push   $0x8010a054
80105929:	68 58 a0 10 80       	push   $0x8010a058
8010592e:	68 5d a0 10 80       	push   $0x8010a05d
80105933:	68 63 a0 10 80       	push   $0x8010a063
80105938:	68 67 a0 10 80       	push   $0x8010a067
8010593d:	68 6f a0 10 80       	push   $0x8010a06f
80105942:	68 74 a0 10 80       	push   $0x8010a074
80105947:	68 78 a0 10 80       	push   $0x8010a078
8010594c:	68 7c a0 10 80       	push   $0x8010a07c
80105951:	68 81 a0 10 80       	push   $0x8010a081
80105956:	68 88 a0 10 80       	push   $0x8010a088
8010595b:	e8 66 aa ff ff       	call   801003c6 <cprintf>
80105960:	83 c4 30             	add    $0x30,%esp
            "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size", "PCs");
#endif

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105963:	c7 45 f0 b4 49 11 80 	movl   $0x801149b4,-0x10(%ebp)
8010596a:	e9 42 01 00 00       	jmp    80105ab1 <procdump+0x198>
        if(p->state == UNUSED)
8010596f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105972:	8b 40 0c             	mov    0xc(%eax),%eax
80105975:	85 c0                	test   %eax,%eax
80105977:	0f 84 2c 01 00 00    	je     80105aa9 <procdump+0x190>
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010597d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105980:	8b 40 0c             	mov    0xc(%eax),%eax
80105983:	83 f8 05             	cmp    $0x5,%eax
80105986:	77 23                	ja     801059ab <procdump+0x92>
80105988:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010598b:	8b 40 0c             	mov    0xc(%eax),%eax
8010598e:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105995:	85 c0                	test   %eax,%eax
80105997:	74 12                	je     801059ab <procdump+0x92>
            state = states[p->state];
80105999:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010599c:	8b 40 0c             	mov    0xc(%eax),%eax
8010599f:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
801059a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
801059a9:	eb 07                	jmp    801059b2 <procdump+0x99>
        else
            state = "???";
801059ab:	c7 45 ec a8 a0 10 80 	movl   $0x8010a0a8,-0x14(%ebp)
#endif

        // formatting if project 2 is enabled in makefile
#ifdef CS333_P2
        cprintf("%d\t%s\t%d\t%d\t%d",
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
801059b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b5:	8b 40 14             	mov    0x14(%eax),%eax
#endif
#endif

        // formatting if project 2 is enabled in makefile
#ifdef CS333_P2
        cprintf("%d\t%s\t%d\t%d\t%d",
801059b8:	8b 58 10             	mov    0x10(%eax),%ebx
801059bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059be:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
801059c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059c7:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
801059cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d0:	8d 70 6c             	lea    0x6c(%eax),%esi
#endif
#endif

        // formatting if project 2 is enabled in makefile
#ifdef CS333_P2
        cprintf("%d\t%s\t%d\t%d\t%d",
801059d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059d6:	8b 40 10             	mov    0x10(%eax),%eax
801059d9:	83 ec 08             	sub    $0x8,%esp
801059dc:	53                   	push   %ebx
801059dd:	51                   	push   %ecx
801059de:	52                   	push   %edx
801059df:	56                   	push   %esi
801059e0:	50                   	push   %eax
801059e1:	68 ac a0 10 80       	push   $0x8010a0ac
801059e6:	e8 db a9 ff ff       	call   801003c6 <cprintf>
801059eb:	83 c4 20             	add    $0x20,%esp
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
        elapsed_time(ticks - p->start_ticks);
801059ee:	8b 15 e0 76 11 80    	mov    0x801176e0,%edx
801059f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059f7:	8b 40 7c             	mov    0x7c(%eax),%eax
801059fa:	29 c2                	sub    %eax,%edx
801059fc:	89 d0                	mov    %edx,%eax
801059fe:	83 ec 0c             	sub    $0xc,%esp
80105a01:	50                   	push   %eax
80105a02:	e8 53 fe ff ff       	call   8010585a <elapsed_time>
80105a07:	83 c4 10             	add    $0x10,%esp
        elapsed_time(p->cpu_ticks_total);
80105a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a0d:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105a13:	83 ec 0c             	sub    $0xc,%esp
80105a16:	50                   	push   %eax
80105a17:	e8 3e fe ff ff       	call   8010585a <elapsed_time>
80105a1c:	83 c4 10             	add    $0x10,%esp
        cprintf("\t%s\t%d", state, p->sz);
80105a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a22:	8b 00                	mov    (%eax),%eax
80105a24:	83 ec 04             	sub    $0x4,%esp
80105a27:	50                   	push   %eax
80105a28:	ff 75 ec             	pushl  -0x14(%ebp)
80105a2b:	68 bb a0 10 80       	push   $0x8010a0bb
80105a30:	e8 91 a9 ff ff       	call   801003c6 <cprintf>
80105a35:	83 c4 10             	add    $0x10,%esp
#endif

        if(p->state == SLEEPING){
80105a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a3b:	8b 40 0c             	mov    0xc(%eax),%eax
80105a3e:	83 f8 02             	cmp    $0x2,%eax
80105a41:	75 54                	jne    80105a97 <procdump+0x17e>
            getcallerpcs((uint*)p->context->ebp+2, pc);
80105a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a46:	8b 40 1c             	mov    0x1c(%eax),%eax
80105a49:	8b 40 0c             	mov    0xc(%eax),%eax
80105a4c:	83 c0 08             	add    $0x8,%eax
80105a4f:	89 c2                	mov    %eax,%edx
80105a51:	83 ec 08             	sub    $0x8,%esp
80105a54:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105a57:	50                   	push   %eax
80105a58:	52                   	push   %edx
80105a59:	e8 98 07 00 00       	call   801061f6 <getcallerpcs>
80105a5e:	83 c4 10             	add    $0x10,%esp
            for(i=0; i<10 && pc[i] != 0; i++)
80105a61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105a68:	eb 1c                	jmp    80105a86 <procdump+0x16d>
                cprintf("\t%p", pc[i]);
80105a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a6d:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105a71:	83 ec 08             	sub    $0x8,%esp
80105a74:	50                   	push   %eax
80105a75:	68 c2 a0 10 80       	push   $0x8010a0c2
80105a7a:	e8 47 a9 ff ff       	call   801003c6 <cprintf>
80105a7f:	83 c4 10             	add    $0x10,%esp
        cprintf("\t%s\t%d", state, p->sz);
#endif

        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
80105a82:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105a86:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105a8a:	7f 0b                	jg     80105a97 <procdump+0x17e>
80105a8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a8f:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105a93:	85 c0                	test   %eax,%eax
80105a95:	75 d3                	jne    80105a6a <procdump+0x151>
                cprintf("\t%p", pc[i]);
        }
        cprintf("\n");
80105a97:	83 ec 0c             	sub    $0xc,%esp
80105a9a:	68 c6 a0 10 80       	push   $0x8010a0c6
80105a9f:	e8 22 a9 ff ff       	call   801003c6 <cprintf>
80105aa4:	83 c4 10             	add    $0x10,%esp
80105aa7:	eb 01                	jmp    80105aaa <procdump+0x191>
            "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size", "PCs");
#endif

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
80105aa9:	90                   	nop
#ifdef CS333_P2
    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
            "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size", "PCs");
#endif

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105aaa:	81 45 f0 94 00 00 00 	addl   $0x94,-0x10(%ebp)
80105ab1:	81 7d f0 b4 6e 11 80 	cmpl   $0x80116eb4,-0x10(%ebp)
80105ab8:	0f 82 b1 fe ff ff    	jb     8010596f <procdump+0x56>
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf("\t%p", pc[i]);
        }
        cprintf("\n");
    }
}
80105abe:	90                   	nop
80105abf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ac2:	5b                   	pop    %ebx
80105ac3:	5e                   	pop    %esi
80105ac4:	5d                   	pop    %ebp
80105ac5:	c3                   	ret    

80105ac6 <getprocs>:
#ifdef CS333_P2
// loop process table and copy active processes, return number of copied procs
// populate uproc array passed in from ps.c
int
getprocs(uint max, struct uproc *table)
{
80105ac6:	55                   	push   %ebp
80105ac7:	89 e5                	mov    %esp,%ebp
80105ac9:	83 ec 18             	sub    $0x18,%esp
    int i = 0;
80105acc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct proc *p;
    acquire(&ptable.lock);
80105ad3:	83 ec 0c             	sub    $0xc,%esp
80105ad6:	68 80 49 11 80       	push   $0x80114980
80105adb:	e8 5d 06 00 00       	call   8010613d <acquire>
80105ae0:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
80105ae3:	c7 45 f0 b4 49 11 80 	movl   $0x801149b4,-0x10(%ebp)
80105aea:	e9 3c 01 00 00       	jmp    80105c2b <getprocs+0x165>
        // only copy active processes
        if (p->state == RUNNABLE || p->state == RUNNING || p->state == SLEEPING) {
80105aef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105af2:	8b 40 0c             	mov    0xc(%eax),%eax
80105af5:	83 f8 03             	cmp    $0x3,%eax
80105af8:	74 1a                	je     80105b14 <getprocs+0x4e>
80105afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105afd:	8b 40 0c             	mov    0xc(%eax),%eax
80105b00:	83 f8 04             	cmp    $0x4,%eax
80105b03:	74 0f                	je     80105b14 <getprocs+0x4e>
80105b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b08:	8b 40 0c             	mov    0xc(%eax),%eax
80105b0b:	83 f8 02             	cmp    $0x2,%eax
80105b0e:	0f 85 10 01 00 00    	jne    80105c24 <getprocs+0x15e>
            table[i].pid = p->pid;
80105b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b17:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b1d:	01 c2                	add    %eax,%edx
80105b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b22:	8b 40 10             	mov    0x10(%eax),%eax
80105b25:	89 02                	mov    %eax,(%edx)
            table[i].uid = p->uid;
80105b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2a:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105b2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b30:	01 c2                	add    %eax,%edx
80105b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b35:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105b3b:	89 42 04             	mov    %eax,0x4(%edx)
            table[i].gid = p->gid;
80105b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b41:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105b44:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b47:	01 c2                	add    %eax,%edx
80105b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b4c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105b52:	89 42 08             	mov    %eax,0x8(%edx)
            if (p->pid == 1) {
80105b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b58:	8b 40 10             	mov    0x10(%eax),%eax
80105b5b:	83 f8 01             	cmp    $0x1,%eax
80105b5e:	75 14                	jne    80105b74 <getprocs+0xae>
                table[i].ppid = 1;
80105b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b63:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105b66:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b69:	01 d0                	add    %edx,%eax
80105b6b:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
80105b72:	eb 17                	jmp    80105b8b <getprocs+0xc5>
            } else {
                table[i].ppid = p->parent->pid;
80105b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b77:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b7d:	01 c2                	add    %eax,%edx
80105b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b82:	8b 40 14             	mov    0x14(%eax),%eax
80105b85:	8b 40 10             	mov    0x10(%eax),%eax
80105b88:	89 42 0c             	mov    %eax,0xc(%edx)
            }
            table[i].elapsed_ticks = (ticks - p->start_ticks);
80105b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8e:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105b91:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b94:	01 c2                	add    %eax,%edx
80105b96:	8b 0d e0 76 11 80    	mov    0x801176e0,%ecx
80105b9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b9f:	8b 40 7c             	mov    0x7c(%eax),%eax
80105ba2:	29 c1                	sub    %eax,%ecx
80105ba4:	89 c8                	mov    %ecx,%eax
80105ba6:	89 42 10             	mov    %eax,0x10(%edx)
            table[i].CPU_total_ticks = p->cpu_ticks_total;
80105ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bac:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105baf:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bb2:	01 c2                	add    %eax,%edx
80105bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb7:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105bbd:	89 42 14             	mov    %eax,0x14(%edx)
            safestrcpy(table[i].state, states[p->state], STRMAX);
80105bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bc3:	8b 40 0c             	mov    0xc(%eax),%eax
80105bc6:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105bcd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bd0:	6b ca 5c             	imul   $0x5c,%edx,%ecx
80105bd3:	8b 55 0c             	mov    0xc(%ebp),%edx
80105bd6:	01 ca                	add    %ecx,%edx
80105bd8:	83 c2 18             	add    $0x18,%edx
80105bdb:	83 ec 04             	sub    $0x4,%esp
80105bde:	6a 20                	push   $0x20
80105be0:	50                   	push   %eax
80105be1:	52                   	push   %edx
80105be2:	e8 bc 09 00 00       	call   801065a3 <safestrcpy>
80105be7:	83 c4 10             	add    $0x10,%esp
            table[i].size = p->sz;
80105bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bed:	6b d0 5c             	imul   $0x5c,%eax,%edx
80105bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80105bf3:	01 c2                	add    %eax,%edx
80105bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bf8:	8b 00                	mov    (%eax),%eax
80105bfa:	89 42 38             	mov    %eax,0x38(%edx)
            safestrcpy(table[i].name, p->name, STRMAX);
80105bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c00:	8d 50 6c             	lea    0x6c(%eax),%edx
80105c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c06:	6b c8 5c             	imul   $0x5c,%eax,%ecx
80105c09:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c0c:	01 c8                	add    %ecx,%eax
80105c0e:	83 c0 3c             	add    $0x3c,%eax
80105c11:	83 ec 04             	sub    $0x4,%esp
80105c14:	6a 20                	push   $0x20
80105c16:	52                   	push   %edx
80105c17:	50                   	push   %eax
80105c18:	e8 86 09 00 00       	call   801065a3 <safestrcpy>
80105c1d:	83 c4 10             	add    $0x10,%esp
            ++i;
80105c20:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
getprocs(uint max, struct uproc *table)
{
    int i = 0;
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
80105c24:	81 45 f0 94 00 00 00 	addl   $0x94,-0x10(%ebp)
80105c2b:	81 7d f0 b4 6e 11 80 	cmpl   $0x80116eb4,-0x10(%ebp)
80105c32:	73 0c                	jae    80105c40 <getprocs+0x17a>
80105c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c37:	3b 45 08             	cmp    0x8(%ebp),%eax
80105c3a:	0f 82 af fe ff ff    	jb     80105aef <getprocs+0x29>
            table[i].size = p->sz;
            safestrcpy(table[i].name, p->name, STRMAX);
            ++i;
        }
    }
    release(&ptable.lock);
80105c40:	83 ec 0c             	sub    $0xc,%esp
80105c43:	68 80 49 11 80       	push   $0x80114980
80105c48:	e8 57 05 00 00       	call   801061a4 <release>
80105c4d:	83 c4 10             	add    $0x10,%esp
    return i; // return number of procs copied
80105c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105c53:	c9                   	leave  
80105c54:	c3                   	ret    

80105c55 <assertState>:

#ifdef CS333_P3P4

// assert that process is in proper state, otherwise panic
static void
assertState(struct proc* p, enum procstate state) {
80105c55:	55                   	push   %ebp
80105c56:	89 e5                	mov    %esp,%ebp
80105c58:	83 ec 08             	sub    $0x8,%esp
    if (!p) {
80105c5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80105c5f:	75 0d                	jne    80105c6e <assertState+0x19>
        panic("assertState: invalid proc argument.\n");
80105c61:	83 ec 0c             	sub    $0xc,%esp
80105c64:	68 c8 a0 10 80       	push   $0x8010a0c8
80105c69:	e8 f8 a8 ff ff       	call   80100566 <panic>
    }
    if (p->state != state) {
80105c6e:	8b 45 08             	mov    0x8(%ebp),%eax
80105c71:	8b 40 0c             	mov    0xc(%eax),%eax
80105c74:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105c77:	74 0d                	je     80105c86 <assertState+0x31>
        //cprintf("Process in state: %s.\n", p->state);
        panic("assertState: process in wrong state.\n");
80105c79:	83 ec 0c             	sub    $0xc,%esp
80105c7c:	68 f0 a0 10 80       	push   $0x8010a0f0
80105c81:	e8 e0 a8 ff ff       	call   80100566 <panic>
    }
}
80105c86:	90                   	nop
80105c87:	c9                   	leave  
80105c88:	c3                   	ret    

80105c89 <addToStateListHead>:

static int
addToStateListHead(struct proc** sList, struct proc* p) {
80105c89:	55                   	push   %ebp
80105c8a:	89 e5                	mov    %esp,%ebp
80105c8c:	83 ec 08             	sub    $0x8,%esp
    if (!p) {
80105c8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105c93:	75 0d                	jne    80105ca2 <addToStateListHead+0x19>
        panic("Invalid process.");
80105c95:	83 ec 0c             	sub    $0xc,%esp
80105c98:	68 16 a1 10 80       	push   $0x8010a116
80105c9d:	e8 c4 a8 ff ff       	call   80100566 <panic>
    }
    if (!(*sList)) { // if no list exists, make first entry
80105ca2:	8b 45 08             	mov    0x8(%ebp),%eax
80105ca5:	8b 00                	mov    (%eax),%eax
80105ca7:	85 c0                	test   %eax,%eax
80105ca9:	75 1c                	jne    80105cc7 <addToStateListHead+0x3e>
        (*sList) = p; // arg proc is now the first item in list
80105cab:	8b 45 08             	mov    0x8(%ebp),%eax
80105cae:	8b 55 0c             	mov    0xc(%ebp),%edx
80105cb1:	89 10                	mov    %edx,(%eax)
        p->next = 0; // next is null
80105cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
80105cb6:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105cbd:	00 00 00 
        return 0; // return success
80105cc0:	b8 00 00 00 00       	mov    $0x0,%eax
80105cc5:	eb 2c                	jmp    80105cf3 <addToStateListHead+0x6a>
    }
    // otherwise hold to next element and become 1st element
    p->next = (*sList); // arg proc has next element
80105cc7:	8b 45 08             	mov    0x8(%ebp),%eax
80105cca:	8b 10                	mov    (%eax),%edx
80105ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
80105ccf:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    (*sList) = p; // reassign head of list to arg proc
80105cd5:	8b 45 08             	mov    0x8(%ebp),%eax
80105cd8:	8b 55 0c             	mov    0xc(%ebp),%edx
80105cdb:	89 10                	mov    %edx,(%eax)
    if (p != (*sList)) {
80105cdd:	8b 45 08             	mov    0x8(%ebp),%eax
80105ce0:	8b 00                	mov    (%eax),%eax
80105ce2:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105ce5:	74 07                	je     80105cee <addToStateListHead+0x65>
        return -1; // if they don't match, return failure
80105ce7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cec:	eb 05                	jmp    80105cf3 <addToStateListHead+0x6a>
    }
    return 0; // return success
80105cee:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105cf3:	c9                   	leave  
80105cf4:	c3                   	ret    

80105cf5 <addToStateListEnd>:

static int
addToStateListEnd(struct proc** sList, struct proc* p) {
80105cf5:	55                   	push   %ebp
80105cf6:	89 e5                	mov    %esp,%ebp
80105cf8:	83 ec 18             	sub    $0x18,%esp
    if (!p) {
80105cfb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105cff:	75 0d                	jne    80105d0e <addToStateListEnd+0x19>
        panic("Invalid process.");
80105d01:	83 ec 0c             	sub    $0xc,%esp
80105d04:	68 16 a1 10 80       	push   $0x8010a116
80105d09:	e8 58 a8 ff ff       	call   80100566 <panic>
    }
    // if list desn't exist yet, initialize
    if (!(*sList)) {
80105d0e:	8b 45 08             	mov    0x8(%ebp),%eax
80105d11:	8b 00                	mov    (%eax),%eax
80105d13:	85 c0                	test   %eax,%eax
80105d15:	75 1c                	jne    80105d33 <addToStateListEnd+0x3e>
        (*sList) = p;
80105d17:	8b 45 08             	mov    0x8(%ebp),%eax
80105d1a:	8b 55 0c             	mov    0xc(%ebp),%edx
80105d1d:	89 10                	mov    %edx,(%eax)
        p->next = 0;
80105d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d22:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105d29:	00 00 00 
        return 0;
80105d2c:	b8 00 00 00 00       	mov    $0x0,%eax
80105d31:	eb 41                	jmp    80105d74 <addToStateListEnd+0x7f>
    }
    // otherwise traverse and add at the end
    struct proc * current = (*sList);
80105d33:	8b 45 08             	mov    0x8(%ebp),%eax
80105d36:	8b 00                	mov    (%eax),%eax
80105d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (current->next) {
80105d3b:	eb 0c                	jmp    80105d49 <addToStateListEnd+0x54>
        current = current->next;
80105d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d40:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105d46:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p->next = 0;
        return 0;
    }
    // otherwise traverse and add at the end
    struct proc * current = (*sList);
    while (current->next) {
80105d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d4c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105d52:	85 c0                	test   %eax,%eax
80105d54:	75 e7                	jne    80105d3d <addToStateListEnd+0x48>
        current = current->next;
    }
    current->next = p;
80105d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d59:	8b 55 0c             	mov    0xc(%ebp),%edx
80105d5c:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    p->next = 0;
80105d62:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d65:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105d6c:	00 00 00 
    return 0;
80105d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105d74:	c9                   	leave  
80105d75:	c3                   	ret    

80105d76 <removeFromStateList>:

// search and remove process based on pointer address
static int
removeFromStateList(struct proc** sList, struct proc* p) {
80105d76:	55                   	push   %ebp
80105d77:	89 e5                	mov    %esp,%ebp
80105d79:	83 ec 18             	sub    $0x18,%esp
    if (!(*sList) || !p) {
80105d7c:	8b 45 08             	mov    0x8(%ebp),%eax
80105d7f:	8b 00                	mov    (%eax),%eax
80105d81:	85 c0                	test   %eax,%eax
80105d83:	74 06                	je     80105d8b <removeFromStateList+0x15>
80105d85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105d89:	75 0d                	jne    80105d98 <removeFromStateList+0x22>
        panic("Invalid process structures.");
80105d8b:	83 ec 0c             	sub    $0xc,%esp
80105d8e:	68 27 a1 10 80       	push   $0x8010a127
80105d93:	e8 ce a7 ff ff       	call   80100566 <panic>
    }
    // if p is the first element in list
    if (p == (*sList)) {
80105d98:	8b 45 08             	mov    0x8(%ebp),%eax
80105d9b:	8b 00                	mov    (%eax),%eax
80105d9d:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105da0:	75 59                	jne    80105dfb <removeFromStateList+0x85>
        // if it is the only item in list
        if (!(*sList)->next) {
80105da2:	8b 45 08             	mov    0x8(%ebp),%eax
80105da5:	8b 00                	mov    (%eax),%eax
80105da7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105dad:	85 c0                	test   %eax,%eax
80105daf:	75 20                	jne    80105dd1 <removeFromStateList+0x5b>
            (*sList) = 0;
80105db1:	8b 45 08             	mov    0x8(%ebp),%eax
80105db4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            p->next = 0;
80105dba:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dbd:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105dc4:	00 00 00 
            return 0;
80105dc7:	b8 00 00 00 00       	mov    $0x0,%eax
80105dcc:	e9 8d 00 00 00       	jmp    80105e5e <removeFromStateList+0xe8>
        }
        // if p is the first item in list
        else {
            struct proc * temp = (*sList)->next;
80105dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80105dd4:	8b 00                	mov    (%eax),%eax
80105dd6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ddc:	89 45 ec             	mov    %eax,-0x14(%ebp)
            p->next = 0;
80105ddf:	8b 45 0c             	mov    0xc(%ebp),%eax
80105de2:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105de9:	00 00 00 
            (*sList) = temp;
80105dec:	8b 45 08             	mov    0x8(%ebp),%eax
80105def:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105df2:	89 10                	mov    %edx,(%eax)
            return 0;
80105df4:	b8 00 00 00 00       	mov    $0x0,%eax
80105df9:	eb 63                	jmp    80105e5e <removeFromStateList+0xe8>
        }
    }
    // from middle or end of list
    else {
        struct proc * current = (*sList)->next;
80105dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80105dfe:	8b 00                	mov    (%eax),%eax
80105e00:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e06:	89 45 f4             	mov    %eax,-0xc(%ebp)
        struct proc * prev = (*sList);
80105e09:	8b 45 08             	mov    0x8(%ebp),%eax
80105e0c:	8b 00                	mov    (%eax),%eax
80105e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while (current) {
80105e11:	eb 40                	jmp    80105e53 <removeFromStateList+0xdd>
            if (current == p) {
80105e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e16:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105e19:	75 26                	jne    80105e41 <removeFromStateList+0xcb>
                prev->next = current->next;
80105e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e1e:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e27:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
                p->next = 0;
80105e2d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e30:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105e37:	00 00 00 
                return 0;
80105e3a:	b8 00 00 00 00       	mov    $0x0,%eax
80105e3f:	eb 1d                	jmp    80105e5e <removeFromStateList+0xe8>
            }
            prev = current;
80105e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e44:	89 45 f0             	mov    %eax,-0x10(%ebp)
            current = current->next;
80105e47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e4a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e50:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    // from middle or end of list
    else {
        struct proc * current = (*sList)->next;
        struct proc * prev = (*sList);
        while (current) {
80105e53:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e57:	75 ba                	jne    80105e13 <removeFromStateList+0x9d>
            }
            prev = current;
            current = current->next;
        }
    }
    return -1; // nothing found
80105e59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e5e:	c9                   	leave  
80105e5f:	c3                   	ret    

80105e60 <removeHead>:

// remove first element of list, return its pointer
static struct proc*
removeHead(struct proc** sList) {
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	83 ec 10             	sub    $0x10,%esp
    if (!(*sList)) {
80105e66:	8b 45 08             	mov    0x8(%ebp),%eax
80105e69:	8b 00                	mov    (%eax),%eax
80105e6b:	85 c0                	test   %eax,%eax
80105e6d:	75 07                	jne    80105e76 <removeHead+0x16>
        return 0; // return null, check value in calling routine
80105e6f:	b8 00 00 00 00       	mov    $0x0,%eax
80105e74:	eb 2e                	jmp    80105ea4 <removeHead+0x44>
    }
    struct proc* p = (*sList); // assign pointer to head of sList
80105e76:	8b 45 08             	mov    0x8(%ebp),%eax
80105e79:	8b 00                	mov    (%eax),%eax
80105e7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    struct proc* temp = (*sList)->next; // hold onto next element in list
80105e7e:	8b 45 08             	mov    0x8(%ebp),%eax
80105e81:	8b 00                	mov    (%eax),%eax
80105e83:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105e89:	89 45 f8             	mov    %eax,-0x8(%ebp)
    p->next = 0; // p is no longer head of sList
80105e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105e8f:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105e96:	00 00 00 
    (*sList) = temp; // sList now starts at  2nd element, or is NULL if one-item list
80105e99:	8b 45 08             	mov    0x8(%ebp),%eax
80105e9c:	8b 55 f8             	mov    -0x8(%ebp),%edx
80105e9f:	89 10                	mov    %edx,(%eax)
    return p; // return 
80105ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105ea4:	c9                   	leave  
80105ea5:	c3                   	ret    

80105ea6 <printReadyList>:

// print PIDs of all procs in Ready list
void
printReadyList(void) {
80105ea6:	55                   	push   %ebp
80105ea7:	89 e5                	mov    %esp,%ebp
80105ea9:	83 ec 18             	sub    $0x18,%esp
    if (ptable.pLists.ready) {
80105eac:	a1 b4 6e 11 80       	mov    0x80116eb4,%eax
80105eb1:	85 c0                	test   %eax,%eax
80105eb3:	74 6b                	je     80105f20 <printReadyList+0x7a>
        struct proc* current = ptable.pLists.ready;
80105eb5:	a1 b4 6e 11 80       	mov    0x80116eb4,%eax
80105eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("\nReady List Processes:\n");
80105ebd:	83 ec 0c             	sub    $0xc,%esp
80105ec0:	68 43 a1 10 80       	push   $0x8010a143
80105ec5:	e8 fc a4 ff ff       	call   801003c6 <cprintf>
80105eca:	83 c4 10             	add    $0x10,%esp
        while (current) {
80105ecd:	eb 49                	jmp    80105f18 <printReadyList+0x72>
            if (current->next) {
80105ecf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ed2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105ed8:	85 c0                	test   %eax,%eax
80105eda:	74 19                	je     80105ef5 <printReadyList+0x4f>
                cprintf("%d -> ", current->pid);
80105edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105edf:	8b 40 10             	mov    0x10(%eax),%eax
80105ee2:	83 ec 08             	sub    $0x8,%esp
80105ee5:	50                   	push   %eax
80105ee6:	68 5b a1 10 80       	push   $0x8010a15b
80105eeb:	e8 d6 a4 ff ff       	call   801003c6 <cprintf>
80105ef0:	83 c4 10             	add    $0x10,%esp
80105ef3:	eb 17                	jmp    80105f0c <printReadyList+0x66>
            } else {
                cprintf("%d", current->pid);
80105ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef8:	8b 40 10             	mov    0x10(%eax),%eax
80105efb:	83 ec 08             	sub    $0x8,%esp
80105efe:	50                   	push   %eax
80105eff:	68 62 a1 10 80       	push   $0x8010a162
80105f04:	e8 bd a4 ff ff       	call   801003c6 <cprintf>
80105f09:	83 c4 10             	add    $0x10,%esp
            }
            current = current->next;
80105f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f0f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f15:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
printReadyList(void) {
    if (ptable.pLists.ready) {
        struct proc* current = ptable.pLists.ready;
        cprintf("\nReady List Processes:\n");
        while (current) {
80105f18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f1c:	75 b1                	jne    80105ecf <printReadyList+0x29>
        }
    }
    else {
        cprintf("\nNo processes on Ready List.\n");
    }
}
80105f1e:	eb 10                	jmp    80105f30 <printReadyList+0x8a>
            }
            current = current->next;
        }
    }
    else {
        cprintf("\nNo processes on Ready List.\n");
80105f20:	83 ec 0c             	sub    $0xc,%esp
80105f23:	68 65 a1 10 80       	push   $0x8010a165
80105f28:	e8 99 a4 ff ff       	call   801003c6 <cprintf>
80105f2d:	83 c4 10             	add    $0x10,%esp
    }
}
80105f30:	90                   	nop
80105f31:	c9                   	leave  
80105f32:	c3                   	ret    

80105f33 <printFreeList>:

// print number of procs in Free list
void
printFreeList(void) {
80105f33:	55                   	push   %ebp
80105f34:	89 e5                	mov    %esp,%ebp
80105f36:	83 ec 18             	sub    $0x18,%esp
    if (ptable.pLists.free) {
80105f39:	a1 b8 6e 11 80       	mov    0x80116eb8,%eax
80105f3e:	85 c0                	test   %eax,%eax
80105f40:	74 3c                	je     80105f7e <printFreeList+0x4b>
        int size = 0;
80105f42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        struct proc * current = ptable.pLists.free;
80105f49:	a1 b8 6e 11 80       	mov    0x80116eb8,%eax
80105f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while (current) {
80105f51:	eb 10                	jmp    80105f63 <printFreeList+0x30>
            ++size; // cycle list and keep count
80105f53:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            current = current->next;
80105f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f5a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
void
printFreeList(void) {
    if (ptable.pLists.free) {
        int size = 0;
        struct proc * current = ptable.pLists.free;
        while (current) {
80105f63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f67:	75 ea                	jne    80105f53 <printFreeList+0x20>
        /*
        for (struct proc* current = ptable.pLists.free; current; current = current->next) {
            ++size;
        }
        */
        cprintf("\nFree List Size: %d processes\n", size);
80105f69:	83 ec 08             	sub    $0x8,%esp
80105f6c:	ff 75 f4             	pushl  -0xc(%ebp)
80105f6f:	68 84 a1 10 80       	push   $0x8010a184
80105f74:	e8 4d a4 ff ff       	call   801003c6 <cprintf>
80105f79:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Free List.\n");
    }
}
80105f7c:	eb 10                	jmp    80105f8e <printFreeList+0x5b>
        }
        */
        cprintf("\nFree List Size: %d processes\n", size);
    }
    else {
        cprintf("\nNo processes on Free List.\n");
80105f7e:	83 ec 0c             	sub    $0xc,%esp
80105f81:	68 a3 a1 10 80       	push   $0x8010a1a3
80105f86:	e8 3b a4 ff ff       	call   801003c6 <cprintf>
80105f8b:	83 c4 10             	add    $0x10,%esp
    }
}
80105f8e:	90                   	nop
80105f8f:	c9                   	leave  
80105f90:	c3                   	ret    

80105f91 <printSleepList>:

// print PIDs of all procs in Sleep list
void
printSleepList(void) {
80105f91:	55                   	push   %ebp
80105f92:	89 e5                	mov    %esp,%ebp
80105f94:	83 ec 18             	sub    $0x18,%esp
    //acquire(&ptable.lock);
    if (ptable.pLists.sleep) {
80105f97:	a1 bc 6e 11 80       	mov    0x80116ebc,%eax
80105f9c:	85 c0                	test   %eax,%eax
80105f9e:	74 7b                	je     8010601b <printSleepList+0x8a>
        struct proc* current = ptable.pLists.sleep;
80105fa0:	a1 bc 6e 11 80       	mov    0x80116ebc,%eax
80105fa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("\nSleep List Processes:\n");
80105fa8:	83 ec 0c             	sub    $0xc,%esp
80105fab:	68 c0 a1 10 80       	push   $0x8010a1c0
80105fb0:	e8 11 a4 ff ff       	call   801003c6 <cprintf>
80105fb5:	83 c4 10             	add    $0x10,%esp
        while (current) {
80105fb8:	eb 49                	jmp    80106003 <printSleepList+0x72>
            if (current->next) {
80105fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fbd:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105fc3:	85 c0                	test   %eax,%eax
80105fc5:	74 19                	je     80105fe0 <printSleepList+0x4f>
                cprintf("%d -> ", current->pid);
80105fc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fca:	8b 40 10             	mov    0x10(%eax),%eax
80105fcd:	83 ec 08             	sub    $0x8,%esp
80105fd0:	50                   	push   %eax
80105fd1:	68 5b a1 10 80       	push   $0x8010a15b
80105fd6:	e8 eb a3 ff ff       	call   801003c6 <cprintf>
80105fdb:	83 c4 10             	add    $0x10,%esp
80105fde:	eb 17                	jmp    80105ff7 <printSleepList+0x66>
            } else {
                cprintf("%d", current->pid);
80105fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe3:	8b 40 10             	mov    0x10(%eax),%eax
80105fe6:	83 ec 08             	sub    $0x8,%esp
80105fe9:	50                   	push   %eax
80105fea:	68 62 a1 10 80       	push   $0x8010a162
80105fef:	e8 d2 a3 ff ff       	call   801003c6 <cprintf>
80105ff4:	83 c4 10             	add    $0x10,%esp
            }
            current = current->next;
80105ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ffa:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106000:	89 45 f4             	mov    %eax,-0xc(%ebp)
printSleepList(void) {
    //acquire(&ptable.lock);
    if (ptable.pLists.sleep) {
        struct proc* current = ptable.pLists.sleep;
        cprintf("\nSleep List Processes:\n");
        while (current) {
80106003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106007:	75 b1                	jne    80105fba <printSleepList+0x29>
            } else {
                cprintf("%d", current->pid);
            }
            current = current->next;
        }
        cprintf("\n");
80106009:	83 ec 0c             	sub    $0xc,%esp
8010600c:	68 c6 a0 10 80       	push   $0x8010a0c6
80106011:	e8 b0 a3 ff ff       	call   801003c6 <cprintf>
80106016:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Sleep List.\n");
    }
    //release(&ptable.lock);
}
80106019:	eb 10                	jmp    8010602b <printSleepList+0x9a>
            current = current->next;
        }
        cprintf("\n");
    }
    else {
        cprintf("\nNo processes on Sleep List.\n");
8010601b:	83 ec 0c             	sub    $0xc,%esp
8010601e:	68 d8 a1 10 80       	push   $0x8010a1d8
80106023:	e8 9e a3 ff ff       	call   801003c6 <cprintf>
80106028:	83 c4 10             	add    $0x10,%esp
    }
    //release(&ptable.lock);
}
8010602b:	90                   	nop
8010602c:	c9                   	leave  
8010602d:	c3                   	ret    

8010602e <printZombieList>:

// print PIDs & PPIDs of all procs in Zombie list
void
printZombieList(void) {
8010602e:	55                   	push   %ebp
8010602f:	89 e5                	mov    %esp,%ebp
80106031:	83 ec 18             	sub    $0x18,%esp
    if (ptable.pLists.zombie) {
80106034:	a1 c0 6e 11 80       	mov    0x80116ec0,%eax
80106039:	85 c0                	test   %eax,%eax
8010603b:	0f 84 8f 00 00 00    	je     801060d0 <printZombieList+0xa2>
        struct proc* current = ptable.pLists.zombie;
80106041:	a1 c0 6e 11 80       	mov    0x80116ec0,%eax
80106046:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("\nZombie List Processes:\n");
80106049:	83 ec 0c             	sub    $0xc,%esp
8010604c:	68 f6 a1 10 80       	push   $0x8010a1f6
80106051:	e8 70 a3 ff ff       	call   801003c6 <cprintf>
80106056:	83 c4 10             	add    $0x10,%esp
        while (current) {
80106059:	eb 5d                	jmp    801060b8 <printZombieList+0x8a>
            if (current->next) {
8010605b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010605e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106064:	85 c0                	test   %eax,%eax
80106066:	74 23                	je     8010608b <printZombieList+0x5d>
                cprintf("(%d, %d) -> ", current->pid, current->parent->pid);
80106068:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010606b:	8b 40 14             	mov    0x14(%eax),%eax
8010606e:	8b 50 10             	mov    0x10(%eax),%edx
80106071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106074:	8b 40 10             	mov    0x10(%eax),%eax
80106077:	83 ec 04             	sub    $0x4,%esp
8010607a:	52                   	push   %edx
8010607b:	50                   	push   %eax
8010607c:	68 0f a2 10 80       	push   $0x8010a20f
80106081:	e8 40 a3 ff ff       	call   801003c6 <cprintf>
80106086:	83 c4 10             	add    $0x10,%esp
80106089:	eb 21                	jmp    801060ac <printZombieList+0x7e>
            } else {
                cprintf("(%d, %d)", current->pid, current->parent->pid);
8010608b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010608e:	8b 40 14             	mov    0x14(%eax),%eax
80106091:	8b 50 10             	mov    0x10(%eax),%edx
80106094:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106097:	8b 40 10             	mov    0x10(%eax),%eax
8010609a:	83 ec 04             	sub    $0x4,%esp
8010609d:	52                   	push   %edx
8010609e:	50                   	push   %eax
8010609f:	68 1c a2 10 80       	push   $0x8010a21c
801060a4:	e8 1d a3 ff ff       	call   801003c6 <cprintf>
801060a9:	83 c4 10             	add    $0x10,%esp
            }
            current = current->next;
801060ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060af:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801060b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
printZombieList(void) {
    if (ptable.pLists.zombie) {
        struct proc* current = ptable.pLists.zombie;
        cprintf("\nZombie List Processes:\n");
        while (current) {
801060b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060bc:	75 9d                	jne    8010605b <printZombieList+0x2d>
            } else {
                cprintf("(%d, %d)", current->pid, current->parent->pid);
            }
            current = current->next;
        }
        cprintf("\n");
801060be:	83 ec 0c             	sub    $0xc,%esp
801060c1:	68 c6 a0 10 80       	push   $0x8010a0c6
801060c6:	e8 fb a2 ff ff       	call   801003c6 <cprintf>
801060cb:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Zombie List.\n");
    }
}
801060ce:	eb 10                	jmp    801060e0 <printZombieList+0xb2>
            current = current->next;
        }
        cprintf("\n");
    }
    else {
        cprintf("\nNo processes on Zombie List.\n");
801060d0:	83 ec 0c             	sub    $0xc,%esp
801060d3:	68 28 a2 10 80       	push   $0x8010a228
801060d8:	e8 e9 a2 ff ff       	call   801003c6 <cprintf>
801060dd:	83 c4 10             	add    $0x10,%esp
    }
}
801060e0:	90                   	nop
801060e1:	c9                   	leave  
801060e2:	c3                   	ret    

801060e3 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801060e3:	55                   	push   %ebp
801060e4:	89 e5                	mov    %esp,%ebp
801060e6:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801060e9:	9c                   	pushf  
801060ea:	58                   	pop    %eax
801060eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801060ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801060f1:	c9                   	leave  
801060f2:	c3                   	ret    

801060f3 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801060f3:	55                   	push   %ebp
801060f4:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801060f6:	fa                   	cli    
}
801060f7:	90                   	nop
801060f8:	5d                   	pop    %ebp
801060f9:	c3                   	ret    

801060fa <sti>:

static inline void
sti(void)
{
801060fa:	55                   	push   %ebp
801060fb:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801060fd:	fb                   	sti    
}
801060fe:	90                   	nop
801060ff:	5d                   	pop    %ebp
80106100:	c3                   	ret    

80106101 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80106101:	55                   	push   %ebp
80106102:	89 e5                	mov    %esp,%ebp
80106104:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80106107:	8b 55 08             	mov    0x8(%ebp),%edx
8010610a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010610d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106110:	f0 87 02             	lock xchg %eax,(%edx)
80106113:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80106116:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106119:	c9                   	leave  
8010611a:	c3                   	ret    

8010611b <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010611b:	55                   	push   %ebp
8010611c:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010611e:	8b 45 08             	mov    0x8(%ebp),%eax
80106121:	8b 55 0c             	mov    0xc(%ebp),%edx
80106124:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80106127:	8b 45 08             	mov    0x8(%ebp),%eax
8010612a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80106130:	8b 45 08             	mov    0x8(%ebp),%eax
80106133:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010613a:	90                   	nop
8010613b:	5d                   	pop    %ebp
8010613c:	c3                   	ret    

8010613d <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010613d:	55                   	push   %ebp
8010613e:	89 e5                	mov    %esp,%ebp
80106140:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106143:	e8 52 01 00 00       	call   8010629a <pushcli>
  if(holding(lk))
80106148:	8b 45 08             	mov    0x8(%ebp),%eax
8010614b:	83 ec 0c             	sub    $0xc,%esp
8010614e:	50                   	push   %eax
8010614f:	e8 1c 01 00 00       	call   80106270 <holding>
80106154:	83 c4 10             	add    $0x10,%esp
80106157:	85 c0                	test   %eax,%eax
80106159:	74 0d                	je     80106168 <acquire+0x2b>
    panic("acquire");
8010615b:	83 ec 0c             	sub    $0xc,%esp
8010615e:	68 47 a2 10 80       	push   $0x8010a247
80106163:	e8 fe a3 ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80106168:	90                   	nop
80106169:	8b 45 08             	mov    0x8(%ebp),%eax
8010616c:	83 ec 08             	sub    $0x8,%esp
8010616f:	6a 01                	push   $0x1
80106171:	50                   	push   %eax
80106172:	e8 8a ff ff ff       	call   80106101 <xchg>
80106177:	83 c4 10             	add    $0x10,%esp
8010617a:	85 c0                	test   %eax,%eax
8010617c:	75 eb                	jne    80106169 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010617e:	8b 45 08             	mov    0x8(%ebp),%eax
80106181:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106188:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010618b:	8b 45 08             	mov    0x8(%ebp),%eax
8010618e:	83 c0 0c             	add    $0xc,%eax
80106191:	83 ec 08             	sub    $0x8,%esp
80106194:	50                   	push   %eax
80106195:	8d 45 08             	lea    0x8(%ebp),%eax
80106198:	50                   	push   %eax
80106199:	e8 58 00 00 00       	call   801061f6 <getcallerpcs>
8010619e:	83 c4 10             	add    $0x10,%esp
}
801061a1:	90                   	nop
801061a2:	c9                   	leave  
801061a3:	c3                   	ret    

801061a4 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801061a4:	55                   	push   %ebp
801061a5:	89 e5                	mov    %esp,%ebp
801061a7:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801061aa:	83 ec 0c             	sub    $0xc,%esp
801061ad:	ff 75 08             	pushl  0x8(%ebp)
801061b0:	e8 bb 00 00 00       	call   80106270 <holding>
801061b5:	83 c4 10             	add    $0x10,%esp
801061b8:	85 c0                	test   %eax,%eax
801061ba:	75 0d                	jne    801061c9 <release+0x25>
    panic("release");
801061bc:	83 ec 0c             	sub    $0xc,%esp
801061bf:	68 4f a2 10 80       	push   $0x8010a24f
801061c4:	e8 9d a3 ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
801061c9:	8b 45 08             	mov    0x8(%ebp),%eax
801061cc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801061d3:	8b 45 08             	mov    0x8(%ebp),%eax
801061d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
801061dd:	8b 45 08             	mov    0x8(%ebp),%eax
801061e0:	83 ec 08             	sub    $0x8,%esp
801061e3:	6a 00                	push   $0x0
801061e5:	50                   	push   %eax
801061e6:	e8 16 ff ff ff       	call   80106101 <xchg>
801061eb:	83 c4 10             	add    $0x10,%esp

  popcli();
801061ee:	e8 ec 00 00 00       	call   801062df <popcli>
}
801061f3:	90                   	nop
801061f4:	c9                   	leave  
801061f5:	c3                   	ret    

801061f6 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801061f6:	55                   	push   %ebp
801061f7:	89 e5                	mov    %esp,%ebp
801061f9:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801061fc:	8b 45 08             	mov    0x8(%ebp),%eax
801061ff:	83 e8 08             	sub    $0x8,%eax
80106202:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80106205:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010620c:	eb 38                	jmp    80106246 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010620e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106212:	74 53                	je     80106267 <getcallerpcs+0x71>
80106214:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010621b:	76 4a                	jbe    80106267 <getcallerpcs+0x71>
8010621d:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80106221:	74 44                	je     80106267 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80106223:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106226:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010622d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106230:	01 c2                	add    %eax,%edx
80106232:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106235:	8b 40 04             	mov    0x4(%eax),%eax
80106238:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
8010623a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010623d:	8b 00                	mov    (%eax),%eax
8010623f:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106242:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106246:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010624a:	7e c2                	jle    8010620e <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010624c:	eb 19                	jmp    80106267 <getcallerpcs+0x71>
    pcs[i] = 0;
8010624e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106251:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106258:	8b 45 0c             	mov    0xc(%ebp),%eax
8010625b:	01 d0                	add    %edx,%eax
8010625d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106263:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106267:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
8010626b:	7e e1                	jle    8010624e <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010626d:	90                   	nop
8010626e:	c9                   	leave  
8010626f:	c3                   	ret    

80106270 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106270:	55                   	push   %ebp
80106271:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106273:	8b 45 08             	mov    0x8(%ebp),%eax
80106276:	8b 00                	mov    (%eax),%eax
80106278:	85 c0                	test   %eax,%eax
8010627a:	74 17                	je     80106293 <holding+0x23>
8010627c:	8b 45 08             	mov    0x8(%ebp),%eax
8010627f:	8b 50 08             	mov    0x8(%eax),%edx
80106282:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106288:	39 c2                	cmp    %eax,%edx
8010628a:	75 07                	jne    80106293 <holding+0x23>
8010628c:	b8 01 00 00 00       	mov    $0x1,%eax
80106291:	eb 05                	jmp    80106298 <holding+0x28>
80106293:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106298:	5d                   	pop    %ebp
80106299:	c3                   	ret    

8010629a <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
8010629a:	55                   	push   %ebp
8010629b:	89 e5                	mov    %esp,%ebp
8010629d:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801062a0:	e8 3e fe ff ff       	call   801060e3 <readeflags>
801062a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801062a8:	e8 46 fe ff ff       	call   801060f3 <cli>
  if(cpu->ncli++ == 0)
801062ad:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801062b4:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801062ba:	8d 48 01             	lea    0x1(%eax),%ecx
801062bd:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
801062c3:	85 c0                	test   %eax,%eax
801062c5:	75 15                	jne    801062dc <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
801062c7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801062cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
801062d0:	81 e2 00 02 00 00    	and    $0x200,%edx
801062d6:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801062dc:	90                   	nop
801062dd:	c9                   	leave  
801062de:	c3                   	ret    

801062df <popcli>:

void
popcli(void)
{
801062df:	55                   	push   %ebp
801062e0:	89 e5                	mov    %esp,%ebp
801062e2:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
801062e5:	e8 f9 fd ff ff       	call   801060e3 <readeflags>
801062ea:	25 00 02 00 00       	and    $0x200,%eax
801062ef:	85 c0                	test   %eax,%eax
801062f1:	74 0d                	je     80106300 <popcli+0x21>
    panic("popcli - interruptible");
801062f3:	83 ec 0c             	sub    $0xc,%esp
801062f6:	68 57 a2 10 80       	push   $0x8010a257
801062fb:	e8 66 a2 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106300:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106306:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
8010630c:	83 ea 01             	sub    $0x1,%edx
8010630f:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106315:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010631b:	85 c0                	test   %eax,%eax
8010631d:	79 0d                	jns    8010632c <popcli+0x4d>
    panic("popcli");
8010631f:	83 ec 0c             	sub    $0xc,%esp
80106322:	68 6e a2 10 80       	push   $0x8010a26e
80106327:	e8 3a a2 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
8010632c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106332:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106338:	85 c0                	test   %eax,%eax
8010633a:	75 15                	jne    80106351 <popcli+0x72>
8010633c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106342:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106348:	85 c0                	test   %eax,%eax
8010634a:	74 05                	je     80106351 <popcli+0x72>
    sti();
8010634c:	e8 a9 fd ff ff       	call   801060fa <sti>
}
80106351:	90                   	nop
80106352:	c9                   	leave  
80106353:	c3                   	ret    

80106354 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106354:	55                   	push   %ebp
80106355:	89 e5                	mov    %esp,%ebp
80106357:	57                   	push   %edi
80106358:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106359:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010635c:	8b 55 10             	mov    0x10(%ebp),%edx
8010635f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106362:	89 cb                	mov    %ecx,%ebx
80106364:	89 df                	mov    %ebx,%edi
80106366:	89 d1                	mov    %edx,%ecx
80106368:	fc                   	cld    
80106369:	f3 aa                	rep stos %al,%es:(%edi)
8010636b:	89 ca                	mov    %ecx,%edx
8010636d:	89 fb                	mov    %edi,%ebx
8010636f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106372:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106375:	90                   	nop
80106376:	5b                   	pop    %ebx
80106377:	5f                   	pop    %edi
80106378:	5d                   	pop    %ebp
80106379:	c3                   	ret    

8010637a <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
8010637a:	55                   	push   %ebp
8010637b:	89 e5                	mov    %esp,%ebp
8010637d:	57                   	push   %edi
8010637e:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010637f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106382:	8b 55 10             	mov    0x10(%ebp),%edx
80106385:	8b 45 0c             	mov    0xc(%ebp),%eax
80106388:	89 cb                	mov    %ecx,%ebx
8010638a:	89 df                	mov    %ebx,%edi
8010638c:	89 d1                	mov    %edx,%ecx
8010638e:	fc                   	cld    
8010638f:	f3 ab                	rep stos %eax,%es:(%edi)
80106391:	89 ca                	mov    %ecx,%edx
80106393:	89 fb                	mov    %edi,%ebx
80106395:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106398:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010639b:	90                   	nop
8010639c:	5b                   	pop    %ebx
8010639d:	5f                   	pop    %edi
8010639e:	5d                   	pop    %ebp
8010639f:	c3                   	ret    

801063a0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801063a0:	55                   	push   %ebp
801063a1:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
801063a3:	8b 45 08             	mov    0x8(%ebp),%eax
801063a6:	83 e0 03             	and    $0x3,%eax
801063a9:	85 c0                	test   %eax,%eax
801063ab:	75 43                	jne    801063f0 <memset+0x50>
801063ad:	8b 45 10             	mov    0x10(%ebp),%eax
801063b0:	83 e0 03             	and    $0x3,%eax
801063b3:	85 c0                	test   %eax,%eax
801063b5:	75 39                	jne    801063f0 <memset+0x50>
    c &= 0xFF;
801063b7:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801063be:	8b 45 10             	mov    0x10(%ebp),%eax
801063c1:	c1 e8 02             	shr    $0x2,%eax
801063c4:	89 c1                	mov    %eax,%ecx
801063c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801063c9:	c1 e0 18             	shl    $0x18,%eax
801063cc:	89 c2                	mov    %eax,%edx
801063ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801063d1:	c1 e0 10             	shl    $0x10,%eax
801063d4:	09 c2                	or     %eax,%edx
801063d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801063d9:	c1 e0 08             	shl    $0x8,%eax
801063dc:	09 d0                	or     %edx,%eax
801063de:	0b 45 0c             	or     0xc(%ebp),%eax
801063e1:	51                   	push   %ecx
801063e2:	50                   	push   %eax
801063e3:	ff 75 08             	pushl  0x8(%ebp)
801063e6:	e8 8f ff ff ff       	call   8010637a <stosl>
801063eb:	83 c4 0c             	add    $0xc,%esp
801063ee:	eb 12                	jmp    80106402 <memset+0x62>
  } else
    stosb(dst, c, n);
801063f0:	8b 45 10             	mov    0x10(%ebp),%eax
801063f3:	50                   	push   %eax
801063f4:	ff 75 0c             	pushl  0xc(%ebp)
801063f7:	ff 75 08             	pushl  0x8(%ebp)
801063fa:	e8 55 ff ff ff       	call   80106354 <stosb>
801063ff:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106402:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106405:	c9                   	leave  
80106406:	c3                   	ret    

80106407 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106407:	55                   	push   %ebp
80106408:	89 e5                	mov    %esp,%ebp
8010640a:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010640d:	8b 45 08             	mov    0x8(%ebp),%eax
80106410:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106413:	8b 45 0c             	mov    0xc(%ebp),%eax
80106416:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106419:	eb 30                	jmp    8010644b <memcmp+0x44>
    if(*s1 != *s2)
8010641b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010641e:	0f b6 10             	movzbl (%eax),%edx
80106421:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106424:	0f b6 00             	movzbl (%eax),%eax
80106427:	38 c2                	cmp    %al,%dl
80106429:	74 18                	je     80106443 <memcmp+0x3c>
      return *s1 - *s2;
8010642b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010642e:	0f b6 00             	movzbl (%eax),%eax
80106431:	0f b6 d0             	movzbl %al,%edx
80106434:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106437:	0f b6 00             	movzbl (%eax),%eax
8010643a:	0f b6 c0             	movzbl %al,%eax
8010643d:	29 c2                	sub    %eax,%edx
8010643f:	89 d0                	mov    %edx,%eax
80106441:	eb 1a                	jmp    8010645d <memcmp+0x56>
    s1++, s2++;
80106443:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106447:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010644b:	8b 45 10             	mov    0x10(%ebp),%eax
8010644e:	8d 50 ff             	lea    -0x1(%eax),%edx
80106451:	89 55 10             	mov    %edx,0x10(%ebp)
80106454:	85 c0                	test   %eax,%eax
80106456:	75 c3                	jne    8010641b <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106458:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010645d:	c9                   	leave  
8010645e:	c3                   	ret    

8010645f <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010645f:	55                   	push   %ebp
80106460:	89 e5                	mov    %esp,%ebp
80106462:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106465:	8b 45 0c             	mov    0xc(%ebp),%eax
80106468:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010646b:	8b 45 08             	mov    0x8(%ebp),%eax
8010646e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106471:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106474:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106477:	73 54                	jae    801064cd <memmove+0x6e>
80106479:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010647c:	8b 45 10             	mov    0x10(%ebp),%eax
8010647f:	01 d0                	add    %edx,%eax
80106481:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106484:	76 47                	jbe    801064cd <memmove+0x6e>
    s += n;
80106486:	8b 45 10             	mov    0x10(%ebp),%eax
80106489:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
8010648c:	8b 45 10             	mov    0x10(%ebp),%eax
8010648f:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106492:	eb 13                	jmp    801064a7 <memmove+0x48>
      *--d = *--s;
80106494:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106498:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
8010649c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010649f:	0f b6 10             	movzbl (%eax),%edx
801064a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801064a5:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801064a7:	8b 45 10             	mov    0x10(%ebp),%eax
801064aa:	8d 50 ff             	lea    -0x1(%eax),%edx
801064ad:	89 55 10             	mov    %edx,0x10(%ebp)
801064b0:	85 c0                	test   %eax,%eax
801064b2:	75 e0                	jne    80106494 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801064b4:	eb 24                	jmp    801064da <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
801064b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801064b9:	8d 50 01             	lea    0x1(%eax),%edx
801064bc:	89 55 f8             	mov    %edx,-0x8(%ebp)
801064bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
801064c2:	8d 4a 01             	lea    0x1(%edx),%ecx
801064c5:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801064c8:	0f b6 12             	movzbl (%edx),%edx
801064cb:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801064cd:	8b 45 10             	mov    0x10(%ebp),%eax
801064d0:	8d 50 ff             	lea    -0x1(%eax),%edx
801064d3:	89 55 10             	mov    %edx,0x10(%ebp)
801064d6:	85 c0                	test   %eax,%eax
801064d8:	75 dc                	jne    801064b6 <memmove+0x57>
      *d++ = *s++;

  return dst;
801064da:	8b 45 08             	mov    0x8(%ebp),%eax
}
801064dd:	c9                   	leave  
801064de:	c3                   	ret    

801064df <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801064df:	55                   	push   %ebp
801064e0:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
801064e2:	ff 75 10             	pushl  0x10(%ebp)
801064e5:	ff 75 0c             	pushl  0xc(%ebp)
801064e8:	ff 75 08             	pushl  0x8(%ebp)
801064eb:	e8 6f ff ff ff       	call   8010645f <memmove>
801064f0:	83 c4 0c             	add    $0xc,%esp
}
801064f3:	c9                   	leave  
801064f4:	c3                   	ret    

801064f5 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801064f5:	55                   	push   %ebp
801064f6:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801064f8:	eb 0c                	jmp    80106506 <strncmp+0x11>
    n--, p++, q++;
801064fa:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801064fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106502:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106506:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010650a:	74 1a                	je     80106526 <strncmp+0x31>
8010650c:	8b 45 08             	mov    0x8(%ebp),%eax
8010650f:	0f b6 00             	movzbl (%eax),%eax
80106512:	84 c0                	test   %al,%al
80106514:	74 10                	je     80106526 <strncmp+0x31>
80106516:	8b 45 08             	mov    0x8(%ebp),%eax
80106519:	0f b6 10             	movzbl (%eax),%edx
8010651c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010651f:	0f b6 00             	movzbl (%eax),%eax
80106522:	38 c2                	cmp    %al,%dl
80106524:	74 d4                	je     801064fa <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106526:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010652a:	75 07                	jne    80106533 <strncmp+0x3e>
    return 0;
8010652c:	b8 00 00 00 00       	mov    $0x0,%eax
80106531:	eb 16                	jmp    80106549 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106533:	8b 45 08             	mov    0x8(%ebp),%eax
80106536:	0f b6 00             	movzbl (%eax),%eax
80106539:	0f b6 d0             	movzbl %al,%edx
8010653c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010653f:	0f b6 00             	movzbl (%eax),%eax
80106542:	0f b6 c0             	movzbl %al,%eax
80106545:	29 c2                	sub    %eax,%edx
80106547:	89 d0                	mov    %edx,%eax
}
80106549:	5d                   	pop    %ebp
8010654a:	c3                   	ret    

8010654b <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010654b:	55                   	push   %ebp
8010654c:	89 e5                	mov    %esp,%ebp
8010654e:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106551:	8b 45 08             	mov    0x8(%ebp),%eax
80106554:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106557:	90                   	nop
80106558:	8b 45 10             	mov    0x10(%ebp),%eax
8010655b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010655e:	89 55 10             	mov    %edx,0x10(%ebp)
80106561:	85 c0                	test   %eax,%eax
80106563:	7e 2c                	jle    80106591 <strncpy+0x46>
80106565:	8b 45 08             	mov    0x8(%ebp),%eax
80106568:	8d 50 01             	lea    0x1(%eax),%edx
8010656b:	89 55 08             	mov    %edx,0x8(%ebp)
8010656e:	8b 55 0c             	mov    0xc(%ebp),%edx
80106571:	8d 4a 01             	lea    0x1(%edx),%ecx
80106574:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106577:	0f b6 12             	movzbl (%edx),%edx
8010657a:	88 10                	mov    %dl,(%eax)
8010657c:	0f b6 00             	movzbl (%eax),%eax
8010657f:	84 c0                	test   %al,%al
80106581:	75 d5                	jne    80106558 <strncpy+0xd>
    ;
  while(n-- > 0)
80106583:	eb 0c                	jmp    80106591 <strncpy+0x46>
    *s++ = 0;
80106585:	8b 45 08             	mov    0x8(%ebp),%eax
80106588:	8d 50 01             	lea    0x1(%eax),%edx
8010658b:	89 55 08             	mov    %edx,0x8(%ebp)
8010658e:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106591:	8b 45 10             	mov    0x10(%ebp),%eax
80106594:	8d 50 ff             	lea    -0x1(%eax),%edx
80106597:	89 55 10             	mov    %edx,0x10(%ebp)
8010659a:	85 c0                	test   %eax,%eax
8010659c:	7f e7                	jg     80106585 <strncpy+0x3a>
    *s++ = 0;
  return os;
8010659e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801065a1:	c9                   	leave  
801065a2:	c3                   	ret    

801065a3 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801065a3:	55                   	push   %ebp
801065a4:	89 e5                	mov    %esp,%ebp
801065a6:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801065a9:	8b 45 08             	mov    0x8(%ebp),%eax
801065ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801065af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801065b3:	7f 05                	jg     801065ba <safestrcpy+0x17>
    return os;
801065b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065b8:	eb 31                	jmp    801065eb <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801065ba:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801065be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801065c2:	7e 1e                	jle    801065e2 <safestrcpy+0x3f>
801065c4:	8b 45 08             	mov    0x8(%ebp),%eax
801065c7:	8d 50 01             	lea    0x1(%eax),%edx
801065ca:	89 55 08             	mov    %edx,0x8(%ebp)
801065cd:	8b 55 0c             	mov    0xc(%ebp),%edx
801065d0:	8d 4a 01             	lea    0x1(%edx),%ecx
801065d3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801065d6:	0f b6 12             	movzbl (%edx),%edx
801065d9:	88 10                	mov    %dl,(%eax)
801065db:	0f b6 00             	movzbl (%eax),%eax
801065de:	84 c0                	test   %al,%al
801065e0:	75 d8                	jne    801065ba <safestrcpy+0x17>
    ;
  *s = 0;
801065e2:	8b 45 08             	mov    0x8(%ebp),%eax
801065e5:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801065e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801065eb:	c9                   	leave  
801065ec:	c3                   	ret    

801065ed <strlen>:

int
strlen(const char *s)
{
801065ed:	55                   	push   %ebp
801065ee:	89 e5                	mov    %esp,%ebp
801065f0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801065f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801065fa:	eb 04                	jmp    80106600 <strlen+0x13>
801065fc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106600:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106603:	8b 45 08             	mov    0x8(%ebp),%eax
80106606:	01 d0                	add    %edx,%eax
80106608:	0f b6 00             	movzbl (%eax),%eax
8010660b:	84 c0                	test   %al,%al
8010660d:	75 ed                	jne    801065fc <strlen+0xf>
    ;
  return n;
8010660f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106612:	c9                   	leave  
80106613:	c3                   	ret    

80106614 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106614:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106618:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010661c:	55                   	push   %ebp
  pushl %ebx
8010661d:	53                   	push   %ebx
  pushl %esi
8010661e:	56                   	push   %esi
  pushl %edi
8010661f:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106620:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106622:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106624:	5f                   	pop    %edi
  popl %esi
80106625:	5e                   	pop    %esi
  popl %ebx
80106626:	5b                   	pop    %ebx
  popl %ebp
80106627:	5d                   	pop    %ebp
  ret
80106628:	c3                   	ret    

80106629 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106629:	55                   	push   %ebp
8010662a:	89 e5                	mov    %esp,%ebp
    if(addr >= proc->sz || addr+4 > proc->sz)
8010662c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106632:	8b 00                	mov    (%eax),%eax
80106634:	3b 45 08             	cmp    0x8(%ebp),%eax
80106637:	76 12                	jbe    8010664b <fetchint+0x22>
80106639:	8b 45 08             	mov    0x8(%ebp),%eax
8010663c:	8d 50 04             	lea    0x4(%eax),%edx
8010663f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106645:	8b 00                	mov    (%eax),%eax
80106647:	39 c2                	cmp    %eax,%edx
80106649:	76 07                	jbe    80106652 <fetchint+0x29>
        return -1;
8010664b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106650:	eb 0f                	jmp    80106661 <fetchint+0x38>
    *ip = *(int*)(addr);
80106652:	8b 45 08             	mov    0x8(%ebp),%eax
80106655:	8b 10                	mov    (%eax),%edx
80106657:	8b 45 0c             	mov    0xc(%ebp),%eax
8010665a:	89 10                	mov    %edx,(%eax)
    return 0;
8010665c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106661:	5d                   	pop    %ebp
80106662:	c3                   	ret    

80106663 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106663:	55                   	push   %ebp
80106664:	89 e5                	mov    %esp,%ebp
80106666:	83 ec 10             	sub    $0x10,%esp
    char *s, *ep;

    if(addr >= proc->sz)
80106669:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010666f:	8b 00                	mov    (%eax),%eax
80106671:	3b 45 08             	cmp    0x8(%ebp),%eax
80106674:	77 07                	ja     8010667d <fetchstr+0x1a>
        return -1;
80106676:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010667b:	eb 46                	jmp    801066c3 <fetchstr+0x60>
    *pp = (char*)addr;
8010667d:	8b 55 08             	mov    0x8(%ebp),%edx
80106680:	8b 45 0c             	mov    0xc(%ebp),%eax
80106683:	89 10                	mov    %edx,(%eax)
    ep = (char*)proc->sz;
80106685:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010668b:	8b 00                	mov    (%eax),%eax
8010668d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    for(s = *pp; s < ep; s++)
80106690:	8b 45 0c             	mov    0xc(%ebp),%eax
80106693:	8b 00                	mov    (%eax),%eax
80106695:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106698:	eb 1c                	jmp    801066b6 <fetchstr+0x53>
        if(*s == 0)
8010669a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010669d:	0f b6 00             	movzbl (%eax),%eax
801066a0:	84 c0                	test   %al,%al
801066a2:	75 0e                	jne    801066b2 <fetchstr+0x4f>
            return s - *pp;
801066a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801066a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801066aa:	8b 00                	mov    (%eax),%eax
801066ac:	29 c2                	sub    %eax,%edx
801066ae:	89 d0                	mov    %edx,%eax
801066b0:	eb 11                	jmp    801066c3 <fetchstr+0x60>

    if(addr >= proc->sz)
        return -1;
    *pp = (char*)addr;
    ep = (char*)proc->sz;
    for(s = *pp; s < ep; s++)
801066b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801066b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801066b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801066bc:	72 dc                	jb     8010669a <fetchstr+0x37>
        if(*s == 0)
            return s - *pp;
    return -1;
801066be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066c3:	c9                   	leave  
801066c4:	c3                   	ret    

801066c5 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801066c5:	55                   	push   %ebp
801066c6:	89 e5                	mov    %esp,%ebp
    return fetchint(proc->tf->esp + 4 + 4*n, ip);
801066c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801066ce:	8b 40 18             	mov    0x18(%eax),%eax
801066d1:	8b 40 44             	mov    0x44(%eax),%eax
801066d4:	8b 55 08             	mov    0x8(%ebp),%edx
801066d7:	c1 e2 02             	shl    $0x2,%edx
801066da:	01 d0                	add    %edx,%eax
801066dc:	83 c0 04             	add    $0x4,%eax
801066df:	ff 75 0c             	pushl  0xc(%ebp)
801066e2:	50                   	push   %eax
801066e3:	e8 41 ff ff ff       	call   80106629 <fetchint>
801066e8:	83 c4 08             	add    $0x8,%esp
}
801066eb:	c9                   	leave  
801066ec:	c3                   	ret    

801066ed <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801066ed:	55                   	push   %ebp
801066ee:	89 e5                	mov    %esp,%ebp
801066f0:	83 ec 10             	sub    $0x10,%esp
    int i;

    if(argint(n, &i) < 0)
801066f3:	8d 45 fc             	lea    -0x4(%ebp),%eax
801066f6:	50                   	push   %eax
801066f7:	ff 75 08             	pushl  0x8(%ebp)
801066fa:	e8 c6 ff ff ff       	call   801066c5 <argint>
801066ff:	83 c4 08             	add    $0x8,%esp
80106702:	85 c0                	test   %eax,%eax
80106704:	79 07                	jns    8010670d <argptr+0x20>
        return -1;
80106706:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010670b:	eb 3b                	jmp    80106748 <argptr+0x5b>
    if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010670d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106713:	8b 00                	mov    (%eax),%eax
80106715:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106718:	39 d0                	cmp    %edx,%eax
8010671a:	76 16                	jbe    80106732 <argptr+0x45>
8010671c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010671f:	89 c2                	mov    %eax,%edx
80106721:	8b 45 10             	mov    0x10(%ebp),%eax
80106724:	01 c2                	add    %eax,%edx
80106726:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010672c:	8b 00                	mov    (%eax),%eax
8010672e:	39 c2                	cmp    %eax,%edx
80106730:	76 07                	jbe    80106739 <argptr+0x4c>
        return -1;
80106732:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106737:	eb 0f                	jmp    80106748 <argptr+0x5b>
    *pp = (char*)i;
80106739:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010673c:	89 c2                	mov    %eax,%edx
8010673e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106741:	89 10                	mov    %edx,(%eax)
    return 0;
80106743:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106748:	c9                   	leave  
80106749:	c3                   	ret    

8010674a <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010674a:	55                   	push   %ebp
8010674b:	89 e5                	mov    %esp,%ebp
8010674d:	83 ec 10             	sub    $0x10,%esp
    int addr;
    if(argint(n, &addr) < 0)
80106750:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106753:	50                   	push   %eax
80106754:	ff 75 08             	pushl  0x8(%ebp)
80106757:	e8 69 ff ff ff       	call   801066c5 <argint>
8010675c:	83 c4 08             	add    $0x8,%esp
8010675f:	85 c0                	test   %eax,%eax
80106761:	79 07                	jns    8010676a <argstr+0x20>
        return -1;
80106763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106768:	eb 0f                	jmp    80106779 <argstr+0x2f>
    return fetchstr(addr, pp);
8010676a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010676d:	ff 75 0c             	pushl  0xc(%ebp)
80106770:	50                   	push   %eax
80106771:	e8 ed fe ff ff       	call   80106663 <fetchstr>
80106776:	83 c4 08             	add    $0x8,%esp
}
80106779:	c9                   	leave  
8010677a:	c3                   	ret    

8010677b <syscall>:
};
#endif

void
syscall(void)
{
8010677b:	55                   	push   %ebp
8010677c:	89 e5                	mov    %esp,%ebp
8010677e:	53                   	push   %ebx
8010677f:	83 ec 14             	sub    $0x14,%esp
    int num;

    num = proc->tf->eax;
80106782:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106788:	8b 40 18             	mov    0x18(%eax),%eax
8010678b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010678e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106795:	7e 30                	jle    801067c7 <syscall+0x4c>
80106797:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010679a:	83 f8 1d             	cmp    $0x1d,%eax
8010679d:	77 28                	ja     801067c7 <syscall+0x4c>
8010679f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a2:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
801067a9:	85 c0                	test   %eax,%eax
801067ab:	74 1a                	je     801067c7 <syscall+0x4c>
        proc->tf->eax = syscalls[num]();
801067ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067b3:	8b 58 18             	mov    0x18(%eax),%ebx
801067b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067b9:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
801067c0:	ff d0                	call   *%eax
801067c2:	89 43 1c             	mov    %eax,0x1c(%ebx)
801067c5:	eb 34                	jmp    801067fb <syscall+0x80>
#ifdef PRINT_SYSCALLS
        cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif
    } else {
        cprintf("%d %s: unknown sys call %d\n",
                proc->pid, proc->name, num);
801067c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067cd:	8d 50 6c             	lea    0x6c(%eax),%edx
801067d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
        // some code goes here
#ifdef PRINT_SYSCALLS
        cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif
    } else {
        cprintf("%d %s: unknown sys call %d\n",
801067d6:	8b 40 10             	mov    0x10(%eax),%eax
801067d9:	ff 75 f4             	pushl  -0xc(%ebp)
801067dc:	52                   	push   %edx
801067dd:	50                   	push   %eax
801067de:	68 75 a2 10 80       	push   $0x8010a275
801067e3:	e8 de 9b ff ff       	call   801003c6 <cprintf>
801067e8:	83 c4 10             	add    $0x10,%esp
                proc->pid, proc->name, num);
        proc->tf->eax = -1;
801067eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801067f1:	8b 40 18             	mov    0x18(%eax),%eax
801067f4:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
    }
}
801067fb:	90                   	nop
801067fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801067ff:	c9                   	leave  
80106800:	c3                   	ret    

80106801 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106801:	55                   	push   %ebp
80106802:	89 e5                	mov    %esp,%ebp
80106804:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106807:	83 ec 08             	sub    $0x8,%esp
8010680a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010680d:	50                   	push   %eax
8010680e:	ff 75 08             	pushl  0x8(%ebp)
80106811:	e8 af fe ff ff       	call   801066c5 <argint>
80106816:	83 c4 10             	add    $0x10,%esp
80106819:	85 c0                	test   %eax,%eax
8010681b:	79 07                	jns    80106824 <argfd+0x23>
    return -1;
8010681d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106822:	eb 50                	jmp    80106874 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106824:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106827:	85 c0                	test   %eax,%eax
80106829:	78 21                	js     8010684c <argfd+0x4b>
8010682b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010682e:	83 f8 0f             	cmp    $0xf,%eax
80106831:	7f 19                	jg     8010684c <argfd+0x4b>
80106833:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106839:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010683c:	83 c2 08             	add    $0x8,%edx
8010683f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106843:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106846:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010684a:	75 07                	jne    80106853 <argfd+0x52>
    return -1;
8010684c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106851:	eb 21                	jmp    80106874 <argfd+0x73>
  if(pfd)
80106853:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106857:	74 08                	je     80106861 <argfd+0x60>
    *pfd = fd;
80106859:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010685c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010685f:	89 10                	mov    %edx,(%eax)
  if(pf)
80106861:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106865:	74 08                	je     8010686f <argfd+0x6e>
    *pf = f;
80106867:	8b 45 10             	mov    0x10(%ebp),%eax
8010686a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010686d:	89 10                	mov    %edx,(%eax)
  return 0;
8010686f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106874:	c9                   	leave  
80106875:	c3                   	ret    

80106876 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106876:	55                   	push   %ebp
80106877:	89 e5                	mov    %esp,%ebp
80106879:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010687c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106883:	eb 30                	jmp    801068b5 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106885:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010688b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010688e:	83 c2 08             	add    $0x8,%edx
80106891:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106895:	85 c0                	test   %eax,%eax
80106897:	75 18                	jne    801068b1 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106899:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010689f:	8b 55 fc             	mov    -0x4(%ebp),%edx
801068a2:	8d 4a 08             	lea    0x8(%edx),%ecx
801068a5:	8b 55 08             	mov    0x8(%ebp),%edx
801068a8:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
801068ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
801068af:	eb 0f                	jmp    801068c0 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801068b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801068b5:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
801068b9:	7e ca                	jle    80106885 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
801068bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801068c0:	c9                   	leave  
801068c1:	c3                   	ret    

801068c2 <sys_dup>:

int
sys_dup(void)
{
801068c2:	55                   	push   %ebp
801068c3:	89 e5                	mov    %esp,%ebp
801068c5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
801068c8:	83 ec 04             	sub    $0x4,%esp
801068cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801068ce:	50                   	push   %eax
801068cf:	6a 00                	push   $0x0
801068d1:	6a 00                	push   $0x0
801068d3:	e8 29 ff ff ff       	call   80106801 <argfd>
801068d8:	83 c4 10             	add    $0x10,%esp
801068db:	85 c0                	test   %eax,%eax
801068dd:	79 07                	jns    801068e6 <sys_dup+0x24>
    return -1;
801068df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068e4:	eb 31                	jmp    80106917 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801068e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801068e9:	83 ec 0c             	sub    $0xc,%esp
801068ec:	50                   	push   %eax
801068ed:	e8 84 ff ff ff       	call   80106876 <fdalloc>
801068f2:	83 c4 10             	add    $0x10,%esp
801068f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068fc:	79 07                	jns    80106905 <sys_dup+0x43>
    return -1;
801068fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106903:	eb 12                	jmp    80106917 <sys_dup+0x55>
  filedup(f);
80106905:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106908:	83 ec 0c             	sub    $0xc,%esp
8010690b:	50                   	push   %eax
8010690c:	e8 a0 a7 ff ff       	call   801010b1 <filedup>
80106911:	83 c4 10             	add    $0x10,%esp
  return fd;
80106914:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106917:	c9                   	leave  
80106918:	c3                   	ret    

80106919 <sys_read>:

int
sys_read(void)
{
80106919:	55                   	push   %ebp
8010691a:	89 e5                	mov    %esp,%ebp
8010691c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010691f:	83 ec 04             	sub    $0x4,%esp
80106922:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106925:	50                   	push   %eax
80106926:	6a 00                	push   $0x0
80106928:	6a 00                	push   $0x0
8010692a:	e8 d2 fe ff ff       	call   80106801 <argfd>
8010692f:	83 c4 10             	add    $0x10,%esp
80106932:	85 c0                	test   %eax,%eax
80106934:	78 2e                	js     80106964 <sys_read+0x4b>
80106936:	83 ec 08             	sub    $0x8,%esp
80106939:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010693c:	50                   	push   %eax
8010693d:	6a 02                	push   $0x2
8010693f:	e8 81 fd ff ff       	call   801066c5 <argint>
80106944:	83 c4 10             	add    $0x10,%esp
80106947:	85 c0                	test   %eax,%eax
80106949:	78 19                	js     80106964 <sys_read+0x4b>
8010694b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010694e:	83 ec 04             	sub    $0x4,%esp
80106951:	50                   	push   %eax
80106952:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106955:	50                   	push   %eax
80106956:	6a 01                	push   $0x1
80106958:	e8 90 fd ff ff       	call   801066ed <argptr>
8010695d:	83 c4 10             	add    $0x10,%esp
80106960:	85 c0                	test   %eax,%eax
80106962:	79 07                	jns    8010696b <sys_read+0x52>
    return -1;
80106964:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106969:	eb 17                	jmp    80106982 <sys_read+0x69>
  return fileread(f, p, n);
8010696b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010696e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106971:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106974:	83 ec 04             	sub    $0x4,%esp
80106977:	51                   	push   %ecx
80106978:	52                   	push   %edx
80106979:	50                   	push   %eax
8010697a:	e8 c2 a8 ff ff       	call   80101241 <fileread>
8010697f:	83 c4 10             	add    $0x10,%esp
}
80106982:	c9                   	leave  
80106983:	c3                   	ret    

80106984 <sys_write>:

int
sys_write(void)
{
80106984:	55                   	push   %ebp
80106985:	89 e5                	mov    %esp,%ebp
80106987:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010698a:	83 ec 04             	sub    $0x4,%esp
8010698d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106990:	50                   	push   %eax
80106991:	6a 00                	push   $0x0
80106993:	6a 00                	push   $0x0
80106995:	e8 67 fe ff ff       	call   80106801 <argfd>
8010699a:	83 c4 10             	add    $0x10,%esp
8010699d:	85 c0                	test   %eax,%eax
8010699f:	78 2e                	js     801069cf <sys_write+0x4b>
801069a1:	83 ec 08             	sub    $0x8,%esp
801069a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069a7:	50                   	push   %eax
801069a8:	6a 02                	push   $0x2
801069aa:	e8 16 fd ff ff       	call   801066c5 <argint>
801069af:	83 c4 10             	add    $0x10,%esp
801069b2:	85 c0                	test   %eax,%eax
801069b4:	78 19                	js     801069cf <sys_write+0x4b>
801069b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801069b9:	83 ec 04             	sub    $0x4,%esp
801069bc:	50                   	push   %eax
801069bd:	8d 45 ec             	lea    -0x14(%ebp),%eax
801069c0:	50                   	push   %eax
801069c1:	6a 01                	push   $0x1
801069c3:	e8 25 fd ff ff       	call   801066ed <argptr>
801069c8:	83 c4 10             	add    $0x10,%esp
801069cb:	85 c0                	test   %eax,%eax
801069cd:	79 07                	jns    801069d6 <sys_write+0x52>
    return -1;
801069cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069d4:	eb 17                	jmp    801069ed <sys_write+0x69>
  return filewrite(f, p, n);
801069d6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801069d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801069dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069df:	83 ec 04             	sub    $0x4,%esp
801069e2:	51                   	push   %ecx
801069e3:	52                   	push   %edx
801069e4:	50                   	push   %eax
801069e5:	e8 0f a9 ff ff       	call   801012f9 <filewrite>
801069ea:	83 c4 10             	add    $0x10,%esp
}
801069ed:	c9                   	leave  
801069ee:	c3                   	ret    

801069ef <sys_close>:

int
sys_close(void)
{
801069ef:	55                   	push   %ebp
801069f0:	89 e5                	mov    %esp,%ebp
801069f2:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801069f5:	83 ec 04             	sub    $0x4,%esp
801069f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069fb:	50                   	push   %eax
801069fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069ff:	50                   	push   %eax
80106a00:	6a 00                	push   $0x0
80106a02:	e8 fa fd ff ff       	call   80106801 <argfd>
80106a07:	83 c4 10             	add    $0x10,%esp
80106a0a:	85 c0                	test   %eax,%eax
80106a0c:	79 07                	jns    80106a15 <sys_close+0x26>
    return -1;
80106a0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a13:	eb 28                	jmp    80106a3d <sys_close+0x4e>
  proc->ofile[fd] = 0;
80106a15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106a1e:	83 c2 08             	add    $0x8,%edx
80106a21:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106a28:	00 
  fileclose(f);
80106a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106a2c:	83 ec 0c             	sub    $0xc,%esp
80106a2f:	50                   	push   %eax
80106a30:	e8 cd a6 ff ff       	call   80101102 <fileclose>
80106a35:	83 c4 10             	add    $0x10,%esp
  return 0;
80106a38:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a3d:	c9                   	leave  
80106a3e:	c3                   	ret    

80106a3f <sys_fstat>:

int
sys_fstat(void)
{
80106a3f:	55                   	push   %ebp
80106a40:	89 e5                	mov    %esp,%ebp
80106a42:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80106a45:	83 ec 04             	sub    $0x4,%esp
80106a48:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a4b:	50                   	push   %eax
80106a4c:	6a 00                	push   $0x0
80106a4e:	6a 00                	push   $0x0
80106a50:	e8 ac fd ff ff       	call   80106801 <argfd>
80106a55:	83 c4 10             	add    $0x10,%esp
80106a58:	85 c0                	test   %eax,%eax
80106a5a:	78 17                	js     80106a73 <sys_fstat+0x34>
80106a5c:	83 ec 04             	sub    $0x4,%esp
80106a5f:	6a 14                	push   $0x14
80106a61:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a64:	50                   	push   %eax
80106a65:	6a 01                	push   $0x1
80106a67:	e8 81 fc ff ff       	call   801066ed <argptr>
80106a6c:	83 c4 10             	add    $0x10,%esp
80106a6f:	85 c0                	test   %eax,%eax
80106a71:	79 07                	jns    80106a7a <sys_fstat+0x3b>
    return -1;
80106a73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a78:	eb 13                	jmp    80106a8d <sys_fstat+0x4e>
  return filestat(f, st);
80106a7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a80:	83 ec 08             	sub    $0x8,%esp
80106a83:	52                   	push   %edx
80106a84:	50                   	push   %eax
80106a85:	e8 60 a7 ff ff       	call   801011ea <filestat>
80106a8a:	83 c4 10             	add    $0x10,%esp
}
80106a8d:	c9                   	leave  
80106a8e:	c3                   	ret    

80106a8f <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80106a8f:	55                   	push   %ebp
80106a90:	89 e5                	mov    %esp,%ebp
80106a92:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80106a95:	83 ec 08             	sub    $0x8,%esp
80106a98:	8d 45 d8             	lea    -0x28(%ebp),%eax
80106a9b:	50                   	push   %eax
80106a9c:	6a 00                	push   $0x0
80106a9e:	e8 a7 fc ff ff       	call   8010674a <argstr>
80106aa3:	83 c4 10             	add    $0x10,%esp
80106aa6:	85 c0                	test   %eax,%eax
80106aa8:	78 15                	js     80106abf <sys_link+0x30>
80106aaa:	83 ec 08             	sub    $0x8,%esp
80106aad:	8d 45 dc             	lea    -0x24(%ebp),%eax
80106ab0:	50                   	push   %eax
80106ab1:	6a 01                	push   $0x1
80106ab3:	e8 92 fc ff ff       	call   8010674a <argstr>
80106ab8:	83 c4 10             	add    $0x10,%esp
80106abb:	85 c0                	test   %eax,%eax
80106abd:	79 0a                	jns    80106ac9 <sys_link+0x3a>
    return -1;
80106abf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ac4:	e9 68 01 00 00       	jmp    80106c31 <sys_link+0x1a2>

  begin_op();
80106ac9:	e8 30 cb ff ff       	call   801035fe <begin_op>
  if((ip = namei(old)) == 0){
80106ace:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106ad1:	83 ec 0c             	sub    $0xc,%esp
80106ad4:	50                   	push   %eax
80106ad5:	e8 ff ba ff ff       	call   801025d9 <namei>
80106ada:	83 c4 10             	add    $0x10,%esp
80106add:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106ae0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ae4:	75 0f                	jne    80106af5 <sys_link+0x66>
    end_op();
80106ae6:	e8 9f cb ff ff       	call   8010368a <end_op>
    return -1;
80106aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106af0:	e9 3c 01 00 00       	jmp    80106c31 <sys_link+0x1a2>
  }

  ilock(ip);
80106af5:	83 ec 0c             	sub    $0xc,%esp
80106af8:	ff 75 f4             	pushl  -0xc(%ebp)
80106afb:	e8 1b af ff ff       	call   80101a1b <ilock>
80106b00:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80106b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b06:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106b0a:	66 83 f8 01          	cmp    $0x1,%ax
80106b0e:	75 1d                	jne    80106b2d <sys_link+0x9e>
    iunlockput(ip);
80106b10:	83 ec 0c             	sub    $0xc,%esp
80106b13:	ff 75 f4             	pushl  -0xc(%ebp)
80106b16:	e8 c0 b1 ff ff       	call   80101cdb <iunlockput>
80106b1b:	83 c4 10             	add    $0x10,%esp
    end_op();
80106b1e:	e8 67 cb ff ff       	call   8010368a <end_op>
    return -1;
80106b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b28:	e9 04 01 00 00       	jmp    80106c31 <sys_link+0x1a2>
  }

  ip->nlink++;
80106b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b30:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106b34:	83 c0 01             	add    $0x1,%eax
80106b37:	89 c2                	mov    %eax,%edx
80106b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b3c:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106b40:	83 ec 0c             	sub    $0xc,%esp
80106b43:	ff 75 f4             	pushl  -0xc(%ebp)
80106b46:	e8 f6 ac ff ff       	call   80101841 <iupdate>
80106b4b:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80106b4e:	83 ec 0c             	sub    $0xc,%esp
80106b51:	ff 75 f4             	pushl  -0xc(%ebp)
80106b54:	e8 20 b0 ff ff       	call   80101b79 <iunlock>
80106b59:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80106b5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106b5f:	83 ec 08             	sub    $0x8,%esp
80106b62:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80106b65:	52                   	push   %edx
80106b66:	50                   	push   %eax
80106b67:	e8 89 ba ff ff       	call   801025f5 <nameiparent>
80106b6c:	83 c4 10             	add    $0x10,%esp
80106b6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106b72:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106b76:	74 71                	je     80106be9 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80106b78:	83 ec 0c             	sub    $0xc,%esp
80106b7b:	ff 75 f0             	pushl  -0x10(%ebp)
80106b7e:	e8 98 ae ff ff       	call   80101a1b <ilock>
80106b83:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80106b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b89:	8b 10                	mov    (%eax),%edx
80106b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b8e:	8b 00                	mov    (%eax),%eax
80106b90:	39 c2                	cmp    %eax,%edx
80106b92:	75 1d                	jne    80106bb1 <sys_link+0x122>
80106b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b97:	8b 40 04             	mov    0x4(%eax),%eax
80106b9a:	83 ec 04             	sub    $0x4,%esp
80106b9d:	50                   	push   %eax
80106b9e:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106ba1:	50                   	push   %eax
80106ba2:	ff 75 f0             	pushl  -0x10(%ebp)
80106ba5:	e8 93 b7 ff ff       	call   8010233d <dirlink>
80106baa:	83 c4 10             	add    $0x10,%esp
80106bad:	85 c0                	test   %eax,%eax
80106baf:	79 10                	jns    80106bc1 <sys_link+0x132>
    iunlockput(dp);
80106bb1:	83 ec 0c             	sub    $0xc,%esp
80106bb4:	ff 75 f0             	pushl  -0x10(%ebp)
80106bb7:	e8 1f b1 ff ff       	call   80101cdb <iunlockput>
80106bbc:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106bbf:	eb 29                	jmp    80106bea <sys_link+0x15b>
  }
  iunlockput(dp);
80106bc1:	83 ec 0c             	sub    $0xc,%esp
80106bc4:	ff 75 f0             	pushl  -0x10(%ebp)
80106bc7:	e8 0f b1 ff ff       	call   80101cdb <iunlockput>
80106bcc:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80106bcf:	83 ec 0c             	sub    $0xc,%esp
80106bd2:	ff 75 f4             	pushl  -0xc(%ebp)
80106bd5:	e8 11 b0 ff ff       	call   80101beb <iput>
80106bda:	83 c4 10             	add    $0x10,%esp

  end_op();
80106bdd:	e8 a8 ca ff ff       	call   8010368a <end_op>

  return 0;
80106be2:	b8 00 00 00 00       	mov    $0x0,%eax
80106be7:	eb 48                	jmp    80106c31 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80106be9:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80106bea:	83 ec 0c             	sub    $0xc,%esp
80106bed:	ff 75 f4             	pushl  -0xc(%ebp)
80106bf0:	e8 26 ae ff ff       	call   80101a1b <ilock>
80106bf5:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80106bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bfb:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106bff:	83 e8 01             	sub    $0x1,%eax
80106c02:	89 c2                	mov    %eax,%edx
80106c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c07:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106c0b:	83 ec 0c             	sub    $0xc,%esp
80106c0e:	ff 75 f4             	pushl  -0xc(%ebp)
80106c11:	e8 2b ac ff ff       	call   80101841 <iupdate>
80106c16:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106c19:	83 ec 0c             	sub    $0xc,%esp
80106c1c:	ff 75 f4             	pushl  -0xc(%ebp)
80106c1f:	e8 b7 b0 ff ff       	call   80101cdb <iunlockput>
80106c24:	83 c4 10             	add    $0x10,%esp
  end_op();
80106c27:	e8 5e ca ff ff       	call   8010368a <end_op>
  return -1;
80106c2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106c31:	c9                   	leave  
80106c32:	c3                   	ret    

80106c33 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106c33:	55                   	push   %ebp
80106c34:	89 e5                	mov    %esp,%ebp
80106c36:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106c39:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80106c40:	eb 40                	jmp    80106c82 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c45:	6a 10                	push   $0x10
80106c47:	50                   	push   %eax
80106c48:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106c4b:	50                   	push   %eax
80106c4c:	ff 75 08             	pushl  0x8(%ebp)
80106c4f:	e8 35 b3 ff ff       	call   80101f89 <readi>
80106c54:	83 c4 10             	add    $0x10,%esp
80106c57:	83 f8 10             	cmp    $0x10,%eax
80106c5a:	74 0d                	je     80106c69 <isdirempty+0x36>
      panic("isdirempty: readi");
80106c5c:	83 ec 0c             	sub    $0xc,%esp
80106c5f:	68 91 a2 10 80       	push   $0x8010a291
80106c64:	e8 fd 98 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
80106c69:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106c6d:	66 85 c0             	test   %ax,%ax
80106c70:	74 07                	je     80106c79 <isdirempty+0x46>
      return 0;
80106c72:	b8 00 00 00 00       	mov    $0x0,%eax
80106c77:	eb 1b                	jmp    80106c94 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c7c:	83 c0 10             	add    $0x10,%eax
80106c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106c82:	8b 45 08             	mov    0x8(%ebp),%eax
80106c85:	8b 50 18             	mov    0x18(%eax),%edx
80106c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c8b:	39 c2                	cmp    %eax,%edx
80106c8d:	77 b3                	ja     80106c42 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106c8f:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106c94:	c9                   	leave  
80106c95:	c3                   	ret    

80106c96 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80106c96:	55                   	push   %ebp
80106c97:	89 e5                	mov    %esp,%ebp
80106c99:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106c9c:	83 ec 08             	sub    $0x8,%esp
80106c9f:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106ca2:	50                   	push   %eax
80106ca3:	6a 00                	push   $0x0
80106ca5:	e8 a0 fa ff ff       	call   8010674a <argstr>
80106caa:	83 c4 10             	add    $0x10,%esp
80106cad:	85 c0                	test   %eax,%eax
80106caf:	79 0a                	jns    80106cbb <sys_unlink+0x25>
    return -1;
80106cb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cb6:	e9 bc 01 00 00       	jmp    80106e77 <sys_unlink+0x1e1>

  begin_op();
80106cbb:	e8 3e c9 ff ff       	call   801035fe <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80106cc0:	8b 45 cc             	mov    -0x34(%ebp),%eax
80106cc3:	83 ec 08             	sub    $0x8,%esp
80106cc6:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80106cc9:	52                   	push   %edx
80106cca:	50                   	push   %eax
80106ccb:	e8 25 b9 ff ff       	call   801025f5 <nameiparent>
80106cd0:	83 c4 10             	add    $0x10,%esp
80106cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106cd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106cda:	75 0f                	jne    80106ceb <sys_unlink+0x55>
    end_op();
80106cdc:	e8 a9 c9 ff ff       	call   8010368a <end_op>
    return -1;
80106ce1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ce6:	e9 8c 01 00 00       	jmp    80106e77 <sys_unlink+0x1e1>
  }

  ilock(dp);
80106ceb:	83 ec 0c             	sub    $0xc,%esp
80106cee:	ff 75 f4             	pushl  -0xc(%ebp)
80106cf1:	e8 25 ad ff ff       	call   80101a1b <ilock>
80106cf6:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80106cf9:	83 ec 08             	sub    $0x8,%esp
80106cfc:	68 a3 a2 10 80       	push   $0x8010a2a3
80106d01:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106d04:	50                   	push   %eax
80106d05:	e8 5e b5 ff ff       	call   80102268 <namecmp>
80106d0a:	83 c4 10             	add    $0x10,%esp
80106d0d:	85 c0                	test   %eax,%eax
80106d0f:	0f 84 4a 01 00 00    	je     80106e5f <sys_unlink+0x1c9>
80106d15:	83 ec 08             	sub    $0x8,%esp
80106d18:	68 a5 a2 10 80       	push   $0x8010a2a5
80106d1d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106d20:	50                   	push   %eax
80106d21:	e8 42 b5 ff ff       	call   80102268 <namecmp>
80106d26:	83 c4 10             	add    $0x10,%esp
80106d29:	85 c0                	test   %eax,%eax
80106d2b:	0f 84 2e 01 00 00    	je     80106e5f <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106d31:	83 ec 04             	sub    $0x4,%esp
80106d34:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106d37:	50                   	push   %eax
80106d38:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106d3b:	50                   	push   %eax
80106d3c:	ff 75 f4             	pushl  -0xc(%ebp)
80106d3f:	e8 3f b5 ff ff       	call   80102283 <dirlookup>
80106d44:	83 c4 10             	add    $0x10,%esp
80106d47:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106d4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106d4e:	0f 84 0a 01 00 00    	je     80106e5e <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
80106d54:	83 ec 0c             	sub    $0xc,%esp
80106d57:	ff 75 f0             	pushl  -0x10(%ebp)
80106d5a:	e8 bc ac ff ff       	call   80101a1b <ilock>
80106d5f:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80106d62:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d65:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106d69:	66 85 c0             	test   %ax,%ax
80106d6c:	7f 0d                	jg     80106d7b <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80106d6e:	83 ec 0c             	sub    $0xc,%esp
80106d71:	68 a8 a2 10 80       	push   $0x8010a2a8
80106d76:	e8 eb 97 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106d7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106d7e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106d82:	66 83 f8 01          	cmp    $0x1,%ax
80106d86:	75 25                	jne    80106dad <sys_unlink+0x117>
80106d88:	83 ec 0c             	sub    $0xc,%esp
80106d8b:	ff 75 f0             	pushl  -0x10(%ebp)
80106d8e:	e8 a0 fe ff ff       	call   80106c33 <isdirempty>
80106d93:	83 c4 10             	add    $0x10,%esp
80106d96:	85 c0                	test   %eax,%eax
80106d98:	75 13                	jne    80106dad <sys_unlink+0x117>
    iunlockput(ip);
80106d9a:	83 ec 0c             	sub    $0xc,%esp
80106d9d:	ff 75 f0             	pushl  -0x10(%ebp)
80106da0:	e8 36 af ff ff       	call   80101cdb <iunlockput>
80106da5:	83 c4 10             	add    $0x10,%esp
    goto bad;
80106da8:	e9 b2 00 00 00       	jmp    80106e5f <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80106dad:	83 ec 04             	sub    $0x4,%esp
80106db0:	6a 10                	push   $0x10
80106db2:	6a 00                	push   $0x0
80106db4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106db7:	50                   	push   %eax
80106db8:	e8 e3 f5 ff ff       	call   801063a0 <memset>
80106dbd:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106dc0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80106dc3:	6a 10                	push   $0x10
80106dc5:	50                   	push   %eax
80106dc6:	8d 45 e0             	lea    -0x20(%ebp),%eax
80106dc9:	50                   	push   %eax
80106dca:	ff 75 f4             	pushl  -0xc(%ebp)
80106dcd:	e8 0e b3 ff ff       	call   801020e0 <writei>
80106dd2:	83 c4 10             	add    $0x10,%esp
80106dd5:	83 f8 10             	cmp    $0x10,%eax
80106dd8:	74 0d                	je     80106de7 <sys_unlink+0x151>
    panic("unlink: writei");
80106dda:	83 ec 0c             	sub    $0xc,%esp
80106ddd:	68 ba a2 10 80       	push   $0x8010a2ba
80106de2:	e8 7f 97 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80106de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106dea:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106dee:	66 83 f8 01          	cmp    $0x1,%ax
80106df2:	75 21                	jne    80106e15 <sys_unlink+0x17f>
    dp->nlink--;
80106df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106df7:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106dfb:	83 e8 01             	sub    $0x1,%eax
80106dfe:	89 c2                	mov    %eax,%edx
80106e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e03:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106e07:	83 ec 0c             	sub    $0xc,%esp
80106e0a:	ff 75 f4             	pushl  -0xc(%ebp)
80106e0d:	e8 2f aa ff ff       	call   80101841 <iupdate>
80106e12:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80106e15:	83 ec 0c             	sub    $0xc,%esp
80106e18:	ff 75 f4             	pushl  -0xc(%ebp)
80106e1b:	e8 bb ae ff ff       	call   80101cdb <iunlockput>
80106e20:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80106e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e26:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106e2a:	83 e8 01             	sub    $0x1,%eax
80106e2d:	89 c2                	mov    %eax,%edx
80106e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106e32:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80106e36:	83 ec 0c             	sub    $0xc,%esp
80106e39:	ff 75 f0             	pushl  -0x10(%ebp)
80106e3c:	e8 00 aa ff ff       	call   80101841 <iupdate>
80106e41:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80106e44:	83 ec 0c             	sub    $0xc,%esp
80106e47:	ff 75 f0             	pushl  -0x10(%ebp)
80106e4a:	e8 8c ae ff ff       	call   80101cdb <iunlockput>
80106e4f:	83 c4 10             	add    $0x10,%esp

  end_op();
80106e52:	e8 33 c8 ff ff       	call   8010368a <end_op>

  return 0;
80106e57:	b8 00 00 00 00       	mov    $0x0,%eax
80106e5c:	eb 19                	jmp    80106e77 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80106e5e:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80106e5f:	83 ec 0c             	sub    $0xc,%esp
80106e62:	ff 75 f4             	pushl  -0xc(%ebp)
80106e65:	e8 71 ae ff ff       	call   80101cdb <iunlockput>
80106e6a:	83 c4 10             	add    $0x10,%esp
  end_op();
80106e6d:	e8 18 c8 ff ff       	call   8010368a <end_op>
  return -1;
80106e72:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e77:	c9                   	leave  
80106e78:	c3                   	ret    

80106e79 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106e79:	55                   	push   %ebp
80106e7a:	89 e5                	mov    %esp,%ebp
80106e7c:	83 ec 38             	sub    $0x38,%esp
80106e7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e82:	8b 55 10             	mov    0x10(%ebp),%edx
80106e85:	8b 45 14             	mov    0x14(%ebp),%eax
80106e88:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80106e8c:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80106e90:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106e94:	83 ec 08             	sub    $0x8,%esp
80106e97:	8d 45 de             	lea    -0x22(%ebp),%eax
80106e9a:	50                   	push   %eax
80106e9b:	ff 75 08             	pushl  0x8(%ebp)
80106e9e:	e8 52 b7 ff ff       	call   801025f5 <nameiparent>
80106ea3:	83 c4 10             	add    $0x10,%esp
80106ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106ea9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106ead:	75 0a                	jne    80106eb9 <create+0x40>
    return 0;
80106eaf:	b8 00 00 00 00       	mov    $0x0,%eax
80106eb4:	e9 90 01 00 00       	jmp    80107049 <create+0x1d0>
  ilock(dp);
80106eb9:	83 ec 0c             	sub    $0xc,%esp
80106ebc:	ff 75 f4             	pushl  -0xc(%ebp)
80106ebf:	e8 57 ab ff ff       	call   80101a1b <ilock>
80106ec4:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80106ec7:	83 ec 04             	sub    $0x4,%esp
80106eca:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106ecd:	50                   	push   %eax
80106ece:	8d 45 de             	lea    -0x22(%ebp),%eax
80106ed1:	50                   	push   %eax
80106ed2:	ff 75 f4             	pushl  -0xc(%ebp)
80106ed5:	e8 a9 b3 ff ff       	call   80102283 <dirlookup>
80106eda:	83 c4 10             	add    $0x10,%esp
80106edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106ee0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106ee4:	74 50                	je     80106f36 <create+0xbd>
    iunlockput(dp);
80106ee6:	83 ec 0c             	sub    $0xc,%esp
80106ee9:	ff 75 f4             	pushl  -0xc(%ebp)
80106eec:	e8 ea ad ff ff       	call   80101cdb <iunlockput>
80106ef1:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80106ef4:	83 ec 0c             	sub    $0xc,%esp
80106ef7:	ff 75 f0             	pushl  -0x10(%ebp)
80106efa:	e8 1c ab ff ff       	call   80101a1b <ilock>
80106eff:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80106f02:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80106f07:	75 15                	jne    80106f1e <create+0xa5>
80106f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f0c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106f10:	66 83 f8 02          	cmp    $0x2,%ax
80106f14:	75 08                	jne    80106f1e <create+0xa5>
      return ip;
80106f16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f19:	e9 2b 01 00 00       	jmp    80107049 <create+0x1d0>
    iunlockput(ip);
80106f1e:	83 ec 0c             	sub    $0xc,%esp
80106f21:	ff 75 f0             	pushl  -0x10(%ebp)
80106f24:	e8 b2 ad ff ff       	call   80101cdb <iunlockput>
80106f29:	83 c4 10             	add    $0x10,%esp
    return 0;
80106f2c:	b8 00 00 00 00       	mov    $0x0,%eax
80106f31:	e9 13 01 00 00       	jmp    80107049 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80106f36:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80106f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f3d:	8b 00                	mov    (%eax),%eax
80106f3f:	83 ec 08             	sub    $0x8,%esp
80106f42:	52                   	push   %edx
80106f43:	50                   	push   %eax
80106f44:	e8 21 a8 ff ff       	call   8010176a <ialloc>
80106f49:	83 c4 10             	add    $0x10,%esp
80106f4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106f4f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106f53:	75 0d                	jne    80106f62 <create+0xe9>
    panic("create: ialloc");
80106f55:	83 ec 0c             	sub    $0xc,%esp
80106f58:	68 c9 a2 10 80       	push   $0x8010a2c9
80106f5d:	e8 04 96 ff ff       	call   80100566 <panic>

  ilock(ip);
80106f62:	83 ec 0c             	sub    $0xc,%esp
80106f65:	ff 75 f0             	pushl  -0x10(%ebp)
80106f68:	e8 ae aa ff ff       	call   80101a1b <ilock>
80106f6d:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80106f70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f73:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106f77:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80106f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f7e:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106f82:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f89:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80106f8f:	83 ec 0c             	sub    $0xc,%esp
80106f92:	ff 75 f0             	pushl  -0x10(%ebp)
80106f95:	e8 a7 a8 ff ff       	call   80101841 <iupdate>
80106f9a:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80106f9d:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80106fa2:	75 6a                	jne    8010700e <create+0x195>
    dp->nlink++;  // for ".."
80106fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fa7:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106fab:	83 c0 01             	add    $0x1,%eax
80106fae:	89 c2                	mov    %eax,%edx
80106fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fb3:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106fb7:	83 ec 0c             	sub    $0xc,%esp
80106fba:	ff 75 f4             	pushl  -0xc(%ebp)
80106fbd:	e8 7f a8 ff ff       	call   80101841 <iupdate>
80106fc2:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80106fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fc8:	8b 40 04             	mov    0x4(%eax),%eax
80106fcb:	83 ec 04             	sub    $0x4,%esp
80106fce:	50                   	push   %eax
80106fcf:	68 a3 a2 10 80       	push   $0x8010a2a3
80106fd4:	ff 75 f0             	pushl  -0x10(%ebp)
80106fd7:	e8 61 b3 ff ff       	call   8010233d <dirlink>
80106fdc:	83 c4 10             	add    $0x10,%esp
80106fdf:	85 c0                	test   %eax,%eax
80106fe1:	78 1e                	js     80107001 <create+0x188>
80106fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106fe6:	8b 40 04             	mov    0x4(%eax),%eax
80106fe9:	83 ec 04             	sub    $0x4,%esp
80106fec:	50                   	push   %eax
80106fed:	68 a5 a2 10 80       	push   $0x8010a2a5
80106ff2:	ff 75 f0             	pushl  -0x10(%ebp)
80106ff5:	e8 43 b3 ff ff       	call   8010233d <dirlink>
80106ffa:	83 c4 10             	add    $0x10,%esp
80106ffd:	85 c0                	test   %eax,%eax
80106fff:	79 0d                	jns    8010700e <create+0x195>
      panic("create dots");
80107001:	83 ec 0c             	sub    $0xc,%esp
80107004:	68 d8 a2 10 80       	push   $0x8010a2d8
80107009:	e8 58 95 ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010700e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107011:	8b 40 04             	mov    0x4(%eax),%eax
80107014:	83 ec 04             	sub    $0x4,%esp
80107017:	50                   	push   %eax
80107018:	8d 45 de             	lea    -0x22(%ebp),%eax
8010701b:	50                   	push   %eax
8010701c:	ff 75 f4             	pushl  -0xc(%ebp)
8010701f:	e8 19 b3 ff ff       	call   8010233d <dirlink>
80107024:	83 c4 10             	add    $0x10,%esp
80107027:	85 c0                	test   %eax,%eax
80107029:	79 0d                	jns    80107038 <create+0x1bf>
    panic("create: dirlink");
8010702b:	83 ec 0c             	sub    $0xc,%esp
8010702e:	68 e4 a2 10 80       	push   $0x8010a2e4
80107033:	e8 2e 95 ff ff       	call   80100566 <panic>

  iunlockput(dp);
80107038:	83 ec 0c             	sub    $0xc,%esp
8010703b:	ff 75 f4             	pushl  -0xc(%ebp)
8010703e:	e8 98 ac ff ff       	call   80101cdb <iunlockput>
80107043:	83 c4 10             	add    $0x10,%esp

  return ip;
80107046:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107049:	c9                   	leave  
8010704a:	c3                   	ret    

8010704b <sys_open>:

int
sys_open(void)
{
8010704b:	55                   	push   %ebp
8010704c:	89 e5                	mov    %esp,%ebp
8010704e:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107051:	83 ec 08             	sub    $0x8,%esp
80107054:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107057:	50                   	push   %eax
80107058:	6a 00                	push   $0x0
8010705a:	e8 eb f6 ff ff       	call   8010674a <argstr>
8010705f:	83 c4 10             	add    $0x10,%esp
80107062:	85 c0                	test   %eax,%eax
80107064:	78 15                	js     8010707b <sys_open+0x30>
80107066:	83 ec 08             	sub    $0x8,%esp
80107069:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010706c:	50                   	push   %eax
8010706d:	6a 01                	push   $0x1
8010706f:	e8 51 f6 ff ff       	call   801066c5 <argint>
80107074:	83 c4 10             	add    $0x10,%esp
80107077:	85 c0                	test   %eax,%eax
80107079:	79 0a                	jns    80107085 <sys_open+0x3a>
    return -1;
8010707b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107080:	e9 61 01 00 00       	jmp    801071e6 <sys_open+0x19b>

  begin_op();
80107085:	e8 74 c5 ff ff       	call   801035fe <begin_op>

  if(omode & O_CREATE){
8010708a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010708d:	25 00 02 00 00       	and    $0x200,%eax
80107092:	85 c0                	test   %eax,%eax
80107094:	74 2a                	je     801070c0 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80107096:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107099:	6a 00                	push   $0x0
8010709b:	6a 00                	push   $0x0
8010709d:	6a 02                	push   $0x2
8010709f:	50                   	push   %eax
801070a0:	e8 d4 fd ff ff       	call   80106e79 <create>
801070a5:	83 c4 10             	add    $0x10,%esp
801070a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801070ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801070af:	75 75                	jne    80107126 <sys_open+0xdb>
      end_op();
801070b1:	e8 d4 c5 ff ff       	call   8010368a <end_op>
      return -1;
801070b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070bb:	e9 26 01 00 00       	jmp    801071e6 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
801070c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801070c3:	83 ec 0c             	sub    $0xc,%esp
801070c6:	50                   	push   %eax
801070c7:	e8 0d b5 ff ff       	call   801025d9 <namei>
801070cc:	83 c4 10             	add    $0x10,%esp
801070cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801070d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801070d6:	75 0f                	jne    801070e7 <sys_open+0x9c>
      end_op();
801070d8:	e8 ad c5 ff ff       	call   8010368a <end_op>
      return -1;
801070dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070e2:	e9 ff 00 00 00       	jmp    801071e6 <sys_open+0x19b>
    }
    ilock(ip);
801070e7:	83 ec 0c             	sub    $0xc,%esp
801070ea:	ff 75 f4             	pushl  -0xc(%ebp)
801070ed:	e8 29 a9 ff ff       	call   80101a1b <ilock>
801070f2:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
801070f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070f8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801070fc:	66 83 f8 01          	cmp    $0x1,%ax
80107100:	75 24                	jne    80107126 <sys_open+0xdb>
80107102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107105:	85 c0                	test   %eax,%eax
80107107:	74 1d                	je     80107126 <sys_open+0xdb>
      iunlockput(ip);
80107109:	83 ec 0c             	sub    $0xc,%esp
8010710c:	ff 75 f4             	pushl  -0xc(%ebp)
8010710f:	e8 c7 ab ff ff       	call   80101cdb <iunlockput>
80107114:	83 c4 10             	add    $0x10,%esp
      end_op();
80107117:	e8 6e c5 ff ff       	call   8010368a <end_op>
      return -1;
8010711c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107121:	e9 c0 00 00 00       	jmp    801071e6 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80107126:	e8 19 9f ff ff       	call   80101044 <filealloc>
8010712b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010712e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107132:	74 17                	je     8010714b <sys_open+0x100>
80107134:	83 ec 0c             	sub    $0xc,%esp
80107137:	ff 75 f0             	pushl  -0x10(%ebp)
8010713a:	e8 37 f7 ff ff       	call   80106876 <fdalloc>
8010713f:	83 c4 10             	add    $0x10,%esp
80107142:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107145:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107149:	79 2e                	jns    80107179 <sys_open+0x12e>
    if(f)
8010714b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010714f:	74 0e                	je     8010715f <sys_open+0x114>
      fileclose(f);
80107151:	83 ec 0c             	sub    $0xc,%esp
80107154:	ff 75 f0             	pushl  -0x10(%ebp)
80107157:	e8 a6 9f ff ff       	call   80101102 <fileclose>
8010715c:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010715f:	83 ec 0c             	sub    $0xc,%esp
80107162:	ff 75 f4             	pushl  -0xc(%ebp)
80107165:	e8 71 ab ff ff       	call   80101cdb <iunlockput>
8010716a:	83 c4 10             	add    $0x10,%esp
    end_op();
8010716d:	e8 18 c5 ff ff       	call   8010368a <end_op>
    return -1;
80107172:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107177:	eb 6d                	jmp    801071e6 <sys_open+0x19b>
  }
  iunlock(ip);
80107179:	83 ec 0c             	sub    $0xc,%esp
8010717c:	ff 75 f4             	pushl  -0xc(%ebp)
8010717f:	e8 f5 a9 ff ff       	call   80101b79 <iunlock>
80107184:	83 c4 10             	add    $0x10,%esp
  end_op();
80107187:	e8 fe c4 ff ff       	call   8010368a <end_op>

  f->type = FD_INODE;
8010718c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010718f:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80107195:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107198:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010719b:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010719e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071a1:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801071a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071ab:	83 e0 01             	and    $0x1,%eax
801071ae:	85 c0                	test   %eax,%eax
801071b0:	0f 94 c0             	sete   %al
801071b3:	89 c2                	mov    %eax,%edx
801071b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071b8:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801071bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071be:	83 e0 01             	and    $0x1,%eax
801071c1:	85 c0                	test   %eax,%eax
801071c3:	75 0a                	jne    801071cf <sys_open+0x184>
801071c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801071c8:	83 e0 02             	and    $0x2,%eax
801071cb:	85 c0                	test   %eax,%eax
801071cd:	74 07                	je     801071d6 <sys_open+0x18b>
801071cf:	b8 01 00 00 00       	mov    $0x1,%eax
801071d4:	eb 05                	jmp    801071db <sys_open+0x190>
801071d6:	b8 00 00 00 00       	mov    $0x0,%eax
801071db:	89 c2                	mov    %eax,%edx
801071dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071e0:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801071e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801071e6:	c9                   	leave  
801071e7:	c3                   	ret    

801071e8 <sys_mkdir>:

int
sys_mkdir(void)
{
801071e8:	55                   	push   %ebp
801071e9:	89 e5                	mov    %esp,%ebp
801071eb:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801071ee:	e8 0b c4 ff ff       	call   801035fe <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801071f3:	83 ec 08             	sub    $0x8,%esp
801071f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801071f9:	50                   	push   %eax
801071fa:	6a 00                	push   $0x0
801071fc:	e8 49 f5 ff ff       	call   8010674a <argstr>
80107201:	83 c4 10             	add    $0x10,%esp
80107204:	85 c0                	test   %eax,%eax
80107206:	78 1b                	js     80107223 <sys_mkdir+0x3b>
80107208:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010720b:	6a 00                	push   $0x0
8010720d:	6a 00                	push   $0x0
8010720f:	6a 01                	push   $0x1
80107211:	50                   	push   %eax
80107212:	e8 62 fc ff ff       	call   80106e79 <create>
80107217:	83 c4 10             	add    $0x10,%esp
8010721a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010721d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107221:	75 0c                	jne    8010722f <sys_mkdir+0x47>
    end_op();
80107223:	e8 62 c4 ff ff       	call   8010368a <end_op>
    return -1;
80107228:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010722d:	eb 18                	jmp    80107247 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
8010722f:	83 ec 0c             	sub    $0xc,%esp
80107232:	ff 75 f4             	pushl  -0xc(%ebp)
80107235:	e8 a1 aa ff ff       	call   80101cdb <iunlockput>
8010723a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010723d:	e8 48 c4 ff ff       	call   8010368a <end_op>
  return 0;
80107242:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107247:	c9                   	leave  
80107248:	c3                   	ret    

80107249 <sys_mknod>:

int
sys_mknod(void)
{
80107249:	55                   	push   %ebp
8010724a:	89 e5                	mov    %esp,%ebp
8010724c:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010724f:	e8 aa c3 ff ff       	call   801035fe <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107254:	83 ec 08             	sub    $0x8,%esp
80107257:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010725a:	50                   	push   %eax
8010725b:	6a 00                	push   $0x0
8010725d:	e8 e8 f4 ff ff       	call   8010674a <argstr>
80107262:	83 c4 10             	add    $0x10,%esp
80107265:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107268:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010726c:	78 4f                	js     801072bd <sys_mknod+0x74>
     argint(1, &major) < 0 ||
8010726e:	83 ec 08             	sub    $0x8,%esp
80107271:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107274:	50                   	push   %eax
80107275:	6a 01                	push   $0x1
80107277:	e8 49 f4 ff ff       	call   801066c5 <argint>
8010727c:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010727f:	85 c0                	test   %eax,%eax
80107281:	78 3a                	js     801072bd <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107283:	83 ec 08             	sub    $0x8,%esp
80107286:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107289:	50                   	push   %eax
8010728a:	6a 02                	push   $0x2
8010728c:	e8 34 f4 ff ff       	call   801066c5 <argint>
80107291:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80107294:	85 c0                	test   %eax,%eax
80107296:	78 25                	js     801072bd <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80107298:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010729b:	0f bf c8             	movswl %ax,%ecx
8010729e:	8b 45 e8             	mov    -0x18(%ebp),%eax
801072a1:	0f bf d0             	movswl %ax,%edx
801072a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801072a7:	51                   	push   %ecx
801072a8:	52                   	push   %edx
801072a9:	6a 03                	push   $0x3
801072ab:	50                   	push   %eax
801072ac:	e8 c8 fb ff ff       	call   80106e79 <create>
801072b1:	83 c4 10             	add    $0x10,%esp
801072b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
801072b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801072bb:	75 0c                	jne    801072c9 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801072bd:	e8 c8 c3 ff ff       	call   8010368a <end_op>
    return -1;
801072c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072c7:	eb 18                	jmp    801072e1 <sys_mknod+0x98>
  }
  iunlockput(ip);
801072c9:	83 ec 0c             	sub    $0xc,%esp
801072cc:	ff 75 f0             	pushl  -0x10(%ebp)
801072cf:	e8 07 aa ff ff       	call   80101cdb <iunlockput>
801072d4:	83 c4 10             	add    $0x10,%esp
  end_op();
801072d7:	e8 ae c3 ff ff       	call   8010368a <end_op>
  return 0;
801072dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801072e1:	c9                   	leave  
801072e2:	c3                   	ret    

801072e3 <sys_chdir>:

int
sys_chdir(void)
{
801072e3:	55                   	push   %ebp
801072e4:	89 e5                	mov    %esp,%ebp
801072e6:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801072e9:	e8 10 c3 ff ff       	call   801035fe <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801072ee:	83 ec 08             	sub    $0x8,%esp
801072f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801072f4:	50                   	push   %eax
801072f5:	6a 00                	push   $0x0
801072f7:	e8 4e f4 ff ff       	call   8010674a <argstr>
801072fc:	83 c4 10             	add    $0x10,%esp
801072ff:	85 c0                	test   %eax,%eax
80107301:	78 18                	js     8010731b <sys_chdir+0x38>
80107303:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107306:	83 ec 0c             	sub    $0xc,%esp
80107309:	50                   	push   %eax
8010730a:	e8 ca b2 ff ff       	call   801025d9 <namei>
8010730f:	83 c4 10             	add    $0x10,%esp
80107312:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107319:	75 0c                	jne    80107327 <sys_chdir+0x44>
    end_op();
8010731b:	e8 6a c3 ff ff       	call   8010368a <end_op>
    return -1;
80107320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107325:	eb 6e                	jmp    80107395 <sys_chdir+0xb2>
  }
  ilock(ip);
80107327:	83 ec 0c             	sub    $0xc,%esp
8010732a:	ff 75 f4             	pushl  -0xc(%ebp)
8010732d:	e8 e9 a6 ff ff       	call   80101a1b <ilock>
80107332:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107338:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010733c:	66 83 f8 01          	cmp    $0x1,%ax
80107340:	74 1a                	je     8010735c <sys_chdir+0x79>
    iunlockput(ip);
80107342:	83 ec 0c             	sub    $0xc,%esp
80107345:	ff 75 f4             	pushl  -0xc(%ebp)
80107348:	e8 8e a9 ff ff       	call   80101cdb <iunlockput>
8010734d:	83 c4 10             	add    $0x10,%esp
    end_op();
80107350:	e8 35 c3 ff ff       	call   8010368a <end_op>
    return -1;
80107355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010735a:	eb 39                	jmp    80107395 <sys_chdir+0xb2>
  }
  iunlock(ip);
8010735c:	83 ec 0c             	sub    $0xc,%esp
8010735f:	ff 75 f4             	pushl  -0xc(%ebp)
80107362:	e8 12 a8 ff ff       	call   80101b79 <iunlock>
80107367:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
8010736a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107370:	8b 40 68             	mov    0x68(%eax),%eax
80107373:	83 ec 0c             	sub    $0xc,%esp
80107376:	50                   	push   %eax
80107377:	e8 6f a8 ff ff       	call   80101beb <iput>
8010737c:	83 c4 10             	add    $0x10,%esp
  end_op();
8010737f:	e8 06 c3 ff ff       	call   8010368a <end_op>
  proc->cwd = ip;
80107384:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010738a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010738d:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107390:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107395:	c9                   	leave  
80107396:	c3                   	ret    

80107397 <sys_exec>:

int
sys_exec(void)
{
80107397:	55                   	push   %ebp
80107398:	89 e5                	mov    %esp,%ebp
8010739a:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801073a0:	83 ec 08             	sub    $0x8,%esp
801073a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801073a6:	50                   	push   %eax
801073a7:	6a 00                	push   $0x0
801073a9:	e8 9c f3 ff ff       	call   8010674a <argstr>
801073ae:	83 c4 10             	add    $0x10,%esp
801073b1:	85 c0                	test   %eax,%eax
801073b3:	78 18                	js     801073cd <sys_exec+0x36>
801073b5:	83 ec 08             	sub    $0x8,%esp
801073b8:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801073be:	50                   	push   %eax
801073bf:	6a 01                	push   $0x1
801073c1:	e8 ff f2 ff ff       	call   801066c5 <argint>
801073c6:	83 c4 10             	add    $0x10,%esp
801073c9:	85 c0                	test   %eax,%eax
801073cb:	79 0a                	jns    801073d7 <sys_exec+0x40>
    return -1;
801073cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073d2:	e9 c6 00 00 00       	jmp    8010749d <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
801073d7:	83 ec 04             	sub    $0x4,%esp
801073da:	68 80 00 00 00       	push   $0x80
801073df:	6a 00                	push   $0x0
801073e1:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801073e7:	50                   	push   %eax
801073e8:	e8 b3 ef ff ff       	call   801063a0 <memset>
801073ed:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
801073f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801073f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073fa:	83 f8 1f             	cmp    $0x1f,%eax
801073fd:	76 0a                	jbe    80107409 <sys_exec+0x72>
      return -1;
801073ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107404:	e9 94 00 00 00       	jmp    8010749d <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107409:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010740c:	c1 e0 02             	shl    $0x2,%eax
8010740f:	89 c2                	mov    %eax,%edx
80107411:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107417:	01 c2                	add    %eax,%edx
80107419:	83 ec 08             	sub    $0x8,%esp
8010741c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107422:	50                   	push   %eax
80107423:	52                   	push   %edx
80107424:	e8 00 f2 ff ff       	call   80106629 <fetchint>
80107429:	83 c4 10             	add    $0x10,%esp
8010742c:	85 c0                	test   %eax,%eax
8010742e:	79 07                	jns    80107437 <sys_exec+0xa0>
      return -1;
80107430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107435:	eb 66                	jmp    8010749d <sys_exec+0x106>
    if(uarg == 0){
80107437:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010743d:	85 c0                	test   %eax,%eax
8010743f:	75 27                	jne    80107468 <sys_exec+0xd1>
      argv[i] = 0;
80107441:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107444:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010744b:	00 00 00 00 
      break;
8010744f:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107450:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107453:	83 ec 08             	sub    $0x8,%esp
80107456:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010745c:	52                   	push   %edx
8010745d:	50                   	push   %eax
8010745e:	e8 bf 97 ff ff       	call   80100c22 <exec>
80107463:	83 c4 10             	add    $0x10,%esp
80107466:	eb 35                	jmp    8010749d <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107468:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010746e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107471:	c1 e2 02             	shl    $0x2,%edx
80107474:	01 c2                	add    %eax,%edx
80107476:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010747c:	83 ec 08             	sub    $0x8,%esp
8010747f:	52                   	push   %edx
80107480:	50                   	push   %eax
80107481:	e8 dd f1 ff ff       	call   80106663 <fetchstr>
80107486:	83 c4 10             	add    $0x10,%esp
80107489:	85 c0                	test   %eax,%eax
8010748b:	79 07                	jns    80107494 <sys_exec+0xfd>
      return -1;
8010748d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107492:	eb 09                	jmp    8010749d <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107494:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80107498:	e9 5a ff ff ff       	jmp    801073f7 <sys_exec+0x60>
  return exec(path, argv);
}
8010749d:	c9                   	leave  
8010749e:	c3                   	ret    

8010749f <sys_pipe>:

int
sys_pipe(void)
{
8010749f:	55                   	push   %ebp
801074a0:	89 e5                	mov    %esp,%ebp
801074a2:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801074a5:	83 ec 04             	sub    $0x4,%esp
801074a8:	6a 08                	push   $0x8
801074aa:	8d 45 ec             	lea    -0x14(%ebp),%eax
801074ad:	50                   	push   %eax
801074ae:	6a 00                	push   $0x0
801074b0:	e8 38 f2 ff ff       	call   801066ed <argptr>
801074b5:	83 c4 10             	add    $0x10,%esp
801074b8:	85 c0                	test   %eax,%eax
801074ba:	79 0a                	jns    801074c6 <sys_pipe+0x27>
    return -1;
801074bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074c1:	e9 af 00 00 00       	jmp    80107575 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
801074c6:	83 ec 08             	sub    $0x8,%esp
801074c9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801074cc:	50                   	push   %eax
801074cd:	8d 45 e8             	lea    -0x18(%ebp),%eax
801074d0:	50                   	push   %eax
801074d1:	e8 1c cc ff ff       	call   801040f2 <pipealloc>
801074d6:	83 c4 10             	add    $0x10,%esp
801074d9:	85 c0                	test   %eax,%eax
801074db:	79 0a                	jns    801074e7 <sys_pipe+0x48>
    return -1;
801074dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074e2:	e9 8e 00 00 00       	jmp    80107575 <sys_pipe+0xd6>
  fd0 = -1;
801074e7:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801074ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
801074f1:	83 ec 0c             	sub    $0xc,%esp
801074f4:	50                   	push   %eax
801074f5:	e8 7c f3 ff ff       	call   80106876 <fdalloc>
801074fa:	83 c4 10             	add    $0x10,%esp
801074fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107504:	78 18                	js     8010751e <sys_pipe+0x7f>
80107506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107509:	83 ec 0c             	sub    $0xc,%esp
8010750c:	50                   	push   %eax
8010750d:	e8 64 f3 ff ff       	call   80106876 <fdalloc>
80107512:	83 c4 10             	add    $0x10,%esp
80107515:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107518:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010751c:	79 3f                	jns    8010755d <sys_pipe+0xbe>
    if(fd0 >= 0)
8010751e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107522:	78 14                	js     80107538 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107524:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010752a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010752d:	83 c2 08             	add    $0x8,%edx
80107530:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107537:	00 
    fileclose(rf);
80107538:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010753b:	83 ec 0c             	sub    $0xc,%esp
8010753e:	50                   	push   %eax
8010753f:	e8 be 9b ff ff       	call   80101102 <fileclose>
80107544:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107547:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010754a:	83 ec 0c             	sub    $0xc,%esp
8010754d:	50                   	push   %eax
8010754e:	e8 af 9b ff ff       	call   80101102 <fileclose>
80107553:	83 c4 10             	add    $0x10,%esp
    return -1;
80107556:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010755b:	eb 18                	jmp    80107575 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
8010755d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107560:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107563:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107565:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107568:	8d 50 04             	lea    0x4(%eax),%edx
8010756b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010756e:	89 02                	mov    %eax,(%edx)
  return 0;
80107570:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107575:	c9                   	leave  
80107576:	c3                   	ret    

80107577 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107577:	55                   	push   %ebp
80107578:	89 e5                	mov    %esp,%ebp
8010757a:	83 ec 08             	sub    $0x8,%esp
8010757d:	8b 55 08             	mov    0x8(%ebp),%edx
80107580:	8b 45 0c             	mov    0xc(%ebp),%eax
80107583:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107587:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010758b:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
8010758f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107593:	66 ef                	out    %ax,(%dx)
}
80107595:	90                   	nop
80107596:	c9                   	leave  
80107597:	c3                   	ret    

80107598 <sys_fork>:
#include "uproc.h"
#endif

int
sys_fork(void)
{
80107598:	55                   	push   %ebp
80107599:	89 e5                	mov    %esp,%ebp
8010759b:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010759e:	e8 f5 d3 ff ff       	call   80104998 <fork>
}
801075a3:	c9                   	leave  
801075a4:	c3                   	ret    

801075a5 <sys_exit>:

int
sys_exit(void)
{
801075a5:	55                   	push   %ebp
801075a6:	89 e5                	mov    %esp,%ebp
801075a8:	83 ec 08             	sub    $0x8,%esp
  exit();
801075ab:	e8 5d d6 ff ff       	call   80104c0d <exit>
  return 0;  // not reached
801075b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801075b5:	c9                   	leave  
801075b6:	c3                   	ret    

801075b7 <sys_wait>:

int
sys_wait(void)
{
801075b7:	55                   	push   %ebp
801075b8:	89 e5                	mov    %esp,%ebp
801075ba:	83 ec 08             	sub    $0x8,%esp
  return wait();
801075bd:	e8 00 d9 ff ff       	call   80104ec2 <wait>
}
801075c2:	c9                   	leave  
801075c3:	c3                   	ret    

801075c4 <sys_kill>:

int
sys_kill(void)
{
801075c4:	55                   	push   %ebp
801075c5:	89 e5                	mov    %esp,%ebp
801075c7:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
801075ca:	83 ec 08             	sub    $0x8,%esp
801075cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801075d0:	50                   	push   %eax
801075d1:	6a 00                	push   $0x0
801075d3:	e8 ed f0 ff ff       	call   801066c5 <argint>
801075d8:	83 c4 10             	add    $0x10,%esp
801075db:	85 c0                	test   %eax,%eax
801075dd:	79 07                	jns    801075e6 <sys_kill+0x22>
    return -1;
801075df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801075e4:	eb 0f                	jmp    801075f5 <sys_kill+0x31>
  return kill(pid);
801075e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075e9:	83 ec 0c             	sub    $0xc,%esp
801075ec:	50                   	push   %eax
801075ed:	e8 00 e0 ff ff       	call   801055f2 <kill>
801075f2:	83 c4 10             	add    $0x10,%esp
}
801075f5:	c9                   	leave  
801075f6:	c3                   	ret    

801075f7 <sys_getpid>:

int
sys_getpid(void)
{
801075f7:	55                   	push   %ebp
801075f8:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801075fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107600:	8b 40 10             	mov    0x10(%eax),%eax
}
80107603:	5d                   	pop    %ebp
80107604:	c3                   	ret    

80107605 <sys_sbrk>:

int
sys_sbrk(void)
{
80107605:	55                   	push   %ebp
80107606:	89 e5                	mov    %esp,%ebp
80107608:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010760b:	83 ec 08             	sub    $0x8,%esp
8010760e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107611:	50                   	push   %eax
80107612:	6a 00                	push   $0x0
80107614:	e8 ac f0 ff ff       	call   801066c5 <argint>
80107619:	83 c4 10             	add    $0x10,%esp
8010761c:	85 c0                	test   %eax,%eax
8010761e:	79 07                	jns    80107627 <sys_sbrk+0x22>
    return -1;
80107620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107625:	eb 28                	jmp    8010764f <sys_sbrk+0x4a>
  addr = proc->sz;
80107627:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010762d:	8b 00                	mov    (%eax),%eax
8010762f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107632:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107635:	83 ec 0c             	sub    $0xc,%esp
80107638:	50                   	push   %eax
80107639:	e8 b7 d2 ff ff       	call   801048f5 <growproc>
8010763e:	83 c4 10             	add    $0x10,%esp
80107641:	85 c0                	test   %eax,%eax
80107643:	79 07                	jns    8010764c <sys_sbrk+0x47>
    return -1;
80107645:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010764a:	eb 03                	jmp    8010764f <sys_sbrk+0x4a>
  return addr;
8010764c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010764f:	c9                   	leave  
80107650:	c3                   	ret    

80107651 <sys_sleep>:

int
sys_sleep(void)
{
80107651:	55                   	push   %ebp
80107652:	89 e5                	mov    %esp,%ebp
80107654:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107657:	83 ec 08             	sub    $0x8,%esp
8010765a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010765d:	50                   	push   %eax
8010765e:	6a 00                	push   $0x0
80107660:	e8 60 f0 ff ff       	call   801066c5 <argint>
80107665:	83 c4 10             	add    $0x10,%esp
80107668:	85 c0                	test   %eax,%eax
8010766a:	79 07                	jns    80107673 <sys_sleep+0x22>
    return -1;
8010766c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107671:	eb 44                	jmp    801076b7 <sys_sleep+0x66>
  ticks0 = ticks;
80107673:	a1 e0 76 11 80       	mov    0x801176e0,%eax
80107678:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010767b:	eb 26                	jmp    801076a3 <sys_sleep+0x52>
    if(proc->killed){
8010767d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107683:	8b 40 24             	mov    0x24(%eax),%eax
80107686:	85 c0                	test   %eax,%eax
80107688:	74 07                	je     80107691 <sys_sleep+0x40>
      return -1;
8010768a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010768f:	eb 26                	jmp    801076b7 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107691:	83 ec 08             	sub    $0x8,%esp
80107694:	6a 00                	push   $0x0
80107696:	68 e0 76 11 80       	push   $0x801176e0
8010769b:	e8 53 dd ff ff       	call   801053f3 <sleep>
801076a0:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801076a3:	a1 e0 76 11 80       	mov    0x801176e0,%eax
801076a8:	2b 45 f4             	sub    -0xc(%ebp),%eax
801076ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
801076ae:	39 d0                	cmp    %edx,%eax
801076b0:	72 cb                	jb     8010767d <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
801076b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801076b7:	c9                   	leave  
801076b8:	c3                   	ret    

801076b9 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
801076b9:	55                   	push   %ebp
801076ba:	89 e5                	mov    %esp,%ebp
801076bc:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
801076bf:	a1 e0 76 11 80       	mov    0x801176e0,%eax
801076c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
801076c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801076ca:	c9                   	leave  
801076cb:	c3                   	ret    

801076cc <sys_halt>:

//Turn of the computer
int
sys_halt(void){
801076cc:	55                   	push   %ebp
801076cd:	89 e5                	mov    %esp,%ebp
801076cf:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
801076d2:	83 ec 0c             	sub    $0xc,%esp
801076d5:	68 f4 a2 10 80       	push   $0x8010a2f4
801076da:	e8 e7 8c ff ff       	call   801003c6 <cprintf>
801076df:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
801076e2:	83 ec 08             	sub    $0x8,%esp
801076e5:	68 00 20 00 00       	push   $0x2000
801076ea:	68 04 06 00 00       	push   $0x604
801076ef:	e8 83 fe ff ff       	call   80107577 <outw>
801076f4:	83 c4 10             	add    $0x10,%esp
  return 0;
801076f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801076fc:	c9                   	leave  
801076fd:	c3                   	ret    

801076fe <sys_date>:

#ifdef CS333_P1
int
sys_date(void) {
801076fe:	55                   	push   %ebp
801076ff:	89 e5                	mov    %esp,%ebp
80107701:	83 ec 18             	sub    $0x18,%esp
    struct rtcdate *d;
    if (argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0) {
80107704:	83 ec 04             	sub    $0x4,%esp
80107707:	6a 18                	push   $0x18
80107709:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010770c:	50                   	push   %eax
8010770d:	6a 00                	push   $0x0
8010770f:	e8 d9 ef ff ff       	call   801066ed <argptr>
80107714:	83 c4 10             	add    $0x10,%esp
80107717:	85 c0                	test   %eax,%eax
80107719:	79 07                	jns    80107722 <sys_date+0x24>
        return -1;
8010771b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107720:	eb 14                	jmp    80107736 <sys_date+0x38>
    } else {
        cmostime(d);
80107722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107725:	83 ec 0c             	sub    $0xc,%esp
80107728:	50                   	push   %eax
80107729:	e8 4b bb ff ff       	call   80103279 <cmostime>
8010772e:	83 c4 10             	add    $0x10,%esp
        return 0;
80107731:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
80107736:	c9                   	leave  
80107737:	c3                   	ret    

80107738 <sys_getuid>:

#ifdef CS333_P2

// return process UID
int
sys_getuid(void) {
80107738:	55                   	push   %ebp
80107739:	89 e5                	mov    %esp,%ebp
    return proc->uid;
8010773b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107741:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80107747:	5d                   	pop    %ebp
80107748:	c3                   	ret    

80107749 <sys_getgid>:

// return process GID
int
sys_getgid(void) {
80107749:	55                   	push   %ebp
8010774a:	89 e5                	mov    %esp,%ebp
    return proc->gid;
8010774c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107752:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80107758:	5d                   	pop    %ebp
80107759:	c3                   	ret    

8010775a <sys_getppid>:

// return process parent's PID
int
sys_getppid(void) {
8010775a:	55                   	push   %ebp
8010775b:	89 e5                	mov    %esp,%ebp
    return proc->parent->pid;
8010775d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107763:	8b 40 14             	mov    0x14(%eax),%eax
80107766:	8b 40 10             	mov    0x10(%eax),%eax
}
80107769:	5d                   	pop    %ebp
8010776a:	c3                   	ret    

8010776b <sys_setuid>:

// pull argument from stack, check range, set process UID
int
sys_setuid(void) {
8010776b:	55                   	push   %ebp
8010776c:	89 e5                	mov    %esp,%ebp
8010776e:	83 ec 18             	sub    $0x18,%esp
    int n;
    if (argint(0, &n) < 0) {
80107771:	83 ec 08             	sub    $0x8,%esp
80107774:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107777:	50                   	push   %eax
80107778:	6a 00                	push   $0x0
8010777a:	e8 46 ef ff ff       	call   801066c5 <argint>
8010777f:	83 c4 10             	add    $0x10,%esp
80107782:	85 c0                	test   %eax,%eax
80107784:	79 07                	jns    8010778d <sys_setuid+0x22>
        return -1;
80107786:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010778b:	eb 3c                	jmp    801077c9 <sys_setuid+0x5e>
    }
    if (n < 0 || n > 32767) {
8010778d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107790:	85 c0                	test   %eax,%eax
80107792:	78 0a                	js     8010779e <sys_setuid+0x33>
80107794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107797:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
8010779c:	7e 17                	jle    801077b5 <sys_setuid+0x4a>
        proc->uid = 0;
8010779e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077a4:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801077ab:	00 00 00 
        return -1;
801077ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077b3:	eb 14                	jmp    801077c9 <sys_setuid+0x5e>
    }
    proc->uid = n;
801077b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801077bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801077be:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    return 0;
801077c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801077c9:	c9                   	leave  
801077ca:	c3                   	ret    

801077cb <sys_setgid>:

// pull argument from stack, check range, set process PID
int
sys_setgid(void) {
801077cb:	55                   	push   %ebp
801077cc:	89 e5                	mov    %esp,%ebp
801077ce:	83 ec 18             	sub    $0x18,%esp
    int n;
    if (argint(0, &n) < 0) {
801077d1:	83 ec 08             	sub    $0x8,%esp
801077d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801077d7:	50                   	push   %eax
801077d8:	6a 00                	push   $0x0
801077da:	e8 e6 ee ff ff       	call   801066c5 <argint>
801077df:	83 c4 10             	add    $0x10,%esp
801077e2:	85 c0                	test   %eax,%eax
801077e4:	79 07                	jns    801077ed <sys_setgid+0x22>
        return -1;
801077e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077eb:	eb 3c                	jmp    80107829 <sys_setgid+0x5e>
    }
    if (n < 0 || n > 32767) {
801077ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f0:	85 c0                	test   %eax,%eax
801077f2:	78 0a                	js     801077fe <sys_setgid+0x33>
801077f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f7:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801077fc:	7e 17                	jle    80107815 <sys_setgid+0x4a>
        proc->gid = 0;
801077fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107804:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
8010780b:	00 00 00 
        return -1;
8010780e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107813:	eb 14                	jmp    80107829 <sys_setgid+0x5e>
    }
    proc->gid = n;
80107815:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010781b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010781e:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    return 0;
80107824:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107829:	c9                   	leave  
8010782a:	c3                   	ret    

8010782b <sys_getprocs>:

// pull arguments from stack, pass to proc.c getprocs(uint, struct)
int
sys_getprocs(void) {
8010782b:	55                   	push   %ebp
8010782c:	89 e5                	mov    %esp,%ebp
8010782e:	83 ec 18             	sub    $0x18,%esp
    int m;
    struct uproc *u;
    if (argint(0, &m) < 0) {
80107831:	83 ec 08             	sub    $0x8,%esp
80107834:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107837:	50                   	push   %eax
80107838:	6a 00                	push   $0x0
8010783a:	e8 86 ee ff ff       	call   801066c5 <argint>
8010783f:	83 c4 10             	add    $0x10,%esp
80107842:	85 c0                	test   %eax,%eax
80107844:	79 07                	jns    8010784d <sys_getprocs+0x22>
        return -1;
80107846:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010784b:	eb 31                	jmp    8010787e <sys_getprocs+0x53>
    }
    if (argptr(1, (void*)&u, sizeof(struct uproc)) < 0) {
8010784d:	83 ec 04             	sub    $0x4,%esp
80107850:	6a 5c                	push   $0x5c
80107852:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107855:	50                   	push   %eax
80107856:	6a 01                	push   $0x1
80107858:	e8 90 ee ff ff       	call   801066ed <argptr>
8010785d:	83 c4 10             	add    $0x10,%esp
80107860:	85 c0                	test   %eax,%eax
80107862:	79 07                	jns    8010786b <sys_getprocs+0x40>
        return -1;
80107864:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107869:	eb 13                	jmp    8010787e <sys_getprocs+0x53>
    }
    return getprocs(m, u);
8010786b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010786e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107871:	83 ec 08             	sub    $0x8,%esp
80107874:	50                   	push   %eax
80107875:	52                   	push   %edx
80107876:	e8 4b e2 ff ff       	call   80105ac6 <getprocs>
8010787b:	83 c4 10             	add    $0x10,%esp
}
8010787e:	c9                   	leave  
8010787f:	c3                   	ret    

80107880 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	83 ec 08             	sub    $0x8,%esp
80107886:	8b 55 08             	mov    0x8(%ebp),%edx
80107889:	8b 45 0c             	mov    0xc(%ebp),%eax
8010788c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107890:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107893:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107897:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010789b:	ee                   	out    %al,(%dx)
}
8010789c:	90                   	nop
8010789d:	c9                   	leave  
8010789e:	c3                   	ret    

8010789f <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010789f:	55                   	push   %ebp
801078a0:	89 e5                	mov    %esp,%ebp
801078a2:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801078a5:	6a 34                	push   $0x34
801078a7:	6a 43                	push   $0x43
801078a9:	e8 d2 ff ff ff       	call   80107880 <outb>
801078ae:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
801078b1:	68 a9 00 00 00       	push   $0xa9
801078b6:	6a 40                	push   $0x40
801078b8:	e8 c3 ff ff ff       	call   80107880 <outb>
801078bd:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
801078c0:	6a 04                	push   $0x4
801078c2:	6a 40                	push   $0x40
801078c4:	e8 b7 ff ff ff       	call   80107880 <outb>
801078c9:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
801078cc:	83 ec 0c             	sub    $0xc,%esp
801078cf:	6a 00                	push   $0x0
801078d1:	e8 06 c7 ff ff       	call   80103fdc <picenable>
801078d6:	83 c4 10             	add    $0x10,%esp
}
801078d9:	90                   	nop
801078da:	c9                   	leave  
801078db:	c3                   	ret    

801078dc <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801078dc:	1e                   	push   %ds
  pushl %es
801078dd:	06                   	push   %es
  pushl %fs
801078de:	0f a0                	push   %fs
  pushl %gs
801078e0:	0f a8                	push   %gs
  pushal
801078e2:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801078e3:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801078e7:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801078e9:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801078eb:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801078ef:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801078f1:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801078f3:	54                   	push   %esp
  call trap
801078f4:	e8 ce 01 00 00       	call   80107ac7 <trap>
  addl $4, %esp
801078f9:	83 c4 04             	add    $0x4,%esp

801078fc <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801078fc:	61                   	popa   
  popl %gs
801078fd:	0f a9                	pop    %gs
  popl %fs
801078ff:	0f a1                	pop    %fs
  popl %es
80107901:	07                   	pop    %es
  popl %ds
80107902:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80107903:	83 c4 08             	add    $0x8,%esp
  iret
80107906:	cf                   	iret   

80107907 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80107907:	55                   	push   %ebp
80107908:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
8010790a:	8b 45 08             	mov    0x8(%ebp),%eax
8010790d:	f0 ff 00             	lock incl (%eax)
}
80107910:	90                   	nop
80107911:	5d                   	pop    %ebp
80107912:	c3                   	ret    

80107913 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80107913:	55                   	push   %ebp
80107914:	89 e5                	mov    %esp,%ebp
80107916:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107919:	8b 45 0c             	mov    0xc(%ebp),%eax
8010791c:	83 e8 01             	sub    $0x1,%eax
8010791f:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107923:	8b 45 08             	mov    0x8(%ebp),%eax
80107926:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010792a:	8b 45 08             	mov    0x8(%ebp),%eax
8010792d:	c1 e8 10             	shr    $0x10,%eax
80107930:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80107934:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107937:	0f 01 18             	lidtl  (%eax)
}
8010793a:	90                   	nop
8010793b:	c9                   	leave  
8010793c:	c3                   	ret    

8010793d <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010793d:	55                   	push   %ebp
8010793e:	89 e5                	mov    %esp,%ebp
80107940:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80107943:	0f 20 d0             	mov    %cr2,%eax
80107946:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80107949:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010794c:	c9                   	leave  
8010794d:	c3                   	ret    

8010794e <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
8010794e:	55                   	push   %ebp
8010794f:	89 e5                	mov    %esp,%ebp
80107951:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80107954:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010795b:	e9 c3 00 00 00       	jmp    80107a23 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80107960:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107963:	8b 04 85 b8 d0 10 80 	mov    -0x7fef2f48(,%eax,4),%eax
8010796a:	89 c2                	mov    %eax,%edx
8010796c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010796f:	66 89 14 c5 e0 6e 11 	mov    %dx,-0x7fee9120(,%eax,8)
80107976:	80 
80107977:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010797a:	66 c7 04 c5 e2 6e 11 	movw   $0x8,-0x7fee911e(,%eax,8)
80107981:	80 08 00 
80107984:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107987:	0f b6 14 c5 e4 6e 11 	movzbl -0x7fee911c(,%eax,8),%edx
8010798e:	80 
8010798f:	83 e2 e0             	and    $0xffffffe0,%edx
80107992:	88 14 c5 e4 6e 11 80 	mov    %dl,-0x7fee911c(,%eax,8)
80107999:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010799c:	0f b6 14 c5 e4 6e 11 	movzbl -0x7fee911c(,%eax,8),%edx
801079a3:	80 
801079a4:	83 e2 1f             	and    $0x1f,%edx
801079a7:	88 14 c5 e4 6e 11 80 	mov    %dl,-0x7fee911c(,%eax,8)
801079ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079b1:	0f b6 14 c5 e5 6e 11 	movzbl -0x7fee911b(,%eax,8),%edx
801079b8:	80 
801079b9:	83 e2 f0             	and    $0xfffffff0,%edx
801079bc:	83 ca 0e             	or     $0xe,%edx
801079bf:	88 14 c5 e5 6e 11 80 	mov    %dl,-0x7fee911b(,%eax,8)
801079c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079c9:	0f b6 14 c5 e5 6e 11 	movzbl -0x7fee911b(,%eax,8),%edx
801079d0:	80 
801079d1:	83 e2 ef             	and    $0xffffffef,%edx
801079d4:	88 14 c5 e5 6e 11 80 	mov    %dl,-0x7fee911b(,%eax,8)
801079db:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079de:	0f b6 14 c5 e5 6e 11 	movzbl -0x7fee911b(,%eax,8),%edx
801079e5:	80 
801079e6:	83 e2 9f             	and    $0xffffff9f,%edx
801079e9:	88 14 c5 e5 6e 11 80 	mov    %dl,-0x7fee911b(,%eax,8)
801079f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801079f3:	0f b6 14 c5 e5 6e 11 	movzbl -0x7fee911b(,%eax,8),%edx
801079fa:	80 
801079fb:	83 ca 80             	or     $0xffffff80,%edx
801079fe:	88 14 c5 e5 6e 11 80 	mov    %dl,-0x7fee911b(,%eax,8)
80107a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a08:	8b 04 85 b8 d0 10 80 	mov    -0x7fef2f48(,%eax,4),%eax
80107a0f:	c1 e8 10             	shr    $0x10,%eax
80107a12:	89 c2                	mov    %eax,%edx
80107a14:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107a17:	66 89 14 c5 e6 6e 11 	mov    %dx,-0x7fee911a(,%eax,8)
80107a1e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80107a1f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107a23:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80107a2a:	0f 8e 30 ff ff ff    	jle    80107960 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80107a30:	a1 b8 d1 10 80       	mov    0x8010d1b8,%eax
80107a35:	66 a3 e0 70 11 80    	mov    %ax,0x801170e0
80107a3b:	66 c7 05 e2 70 11 80 	movw   $0x8,0x801170e2
80107a42:	08 00 
80107a44:	0f b6 05 e4 70 11 80 	movzbl 0x801170e4,%eax
80107a4b:	83 e0 e0             	and    $0xffffffe0,%eax
80107a4e:	a2 e4 70 11 80       	mov    %al,0x801170e4
80107a53:	0f b6 05 e4 70 11 80 	movzbl 0x801170e4,%eax
80107a5a:	83 e0 1f             	and    $0x1f,%eax
80107a5d:	a2 e4 70 11 80       	mov    %al,0x801170e4
80107a62:	0f b6 05 e5 70 11 80 	movzbl 0x801170e5,%eax
80107a69:	83 c8 0f             	or     $0xf,%eax
80107a6c:	a2 e5 70 11 80       	mov    %al,0x801170e5
80107a71:	0f b6 05 e5 70 11 80 	movzbl 0x801170e5,%eax
80107a78:	83 e0 ef             	and    $0xffffffef,%eax
80107a7b:	a2 e5 70 11 80       	mov    %al,0x801170e5
80107a80:	0f b6 05 e5 70 11 80 	movzbl 0x801170e5,%eax
80107a87:	83 c8 60             	or     $0x60,%eax
80107a8a:	a2 e5 70 11 80       	mov    %al,0x801170e5
80107a8f:	0f b6 05 e5 70 11 80 	movzbl 0x801170e5,%eax
80107a96:	83 c8 80             	or     $0xffffff80,%eax
80107a99:	a2 e5 70 11 80       	mov    %al,0x801170e5
80107a9e:	a1 b8 d1 10 80       	mov    0x8010d1b8,%eax
80107aa3:	c1 e8 10             	shr    $0x10,%eax
80107aa6:	66 a3 e6 70 11 80    	mov    %ax,0x801170e6
  
}
80107aac:	90                   	nop
80107aad:	c9                   	leave  
80107aae:	c3                   	ret    

80107aaf <idtinit>:

void
idtinit(void)
{
80107aaf:	55                   	push   %ebp
80107ab0:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
80107ab2:	68 00 08 00 00       	push   $0x800
80107ab7:	68 e0 6e 11 80       	push   $0x80116ee0
80107abc:	e8 52 fe ff ff       	call   80107913 <lidt>
80107ac1:	83 c4 08             	add    $0x8,%esp
}
80107ac4:	90                   	nop
80107ac5:	c9                   	leave  
80107ac6:	c3                   	ret    

80107ac7 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80107ac7:	55                   	push   %ebp
80107ac8:	89 e5                	mov    %esp,%ebp
80107aca:	57                   	push   %edi
80107acb:	56                   	push   %esi
80107acc:	53                   	push   %ebx
80107acd:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
80107ad0:	8b 45 08             	mov    0x8(%ebp),%eax
80107ad3:	8b 40 30             	mov    0x30(%eax),%eax
80107ad6:	83 f8 40             	cmp    $0x40,%eax
80107ad9:	75 3e                	jne    80107b19 <trap+0x52>
    if(proc->killed)
80107adb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ae1:	8b 40 24             	mov    0x24(%eax),%eax
80107ae4:	85 c0                	test   %eax,%eax
80107ae6:	74 05                	je     80107aed <trap+0x26>
      exit();
80107ae8:	e8 20 d1 ff ff       	call   80104c0d <exit>
    proc->tf = tf;
80107aed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107af3:	8b 55 08             	mov    0x8(%ebp),%edx
80107af6:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80107af9:	e8 7d ec ff ff       	call   8010677b <syscall>
    if(proc->killed)
80107afe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b04:	8b 40 24             	mov    0x24(%eax),%eax
80107b07:	85 c0                	test   %eax,%eax
80107b09:	0f 84 21 02 00 00    	je     80107d30 <trap+0x269>
      exit();
80107b0f:	e8 f9 d0 ff ff       	call   80104c0d <exit>
    return;
80107b14:	e9 17 02 00 00       	jmp    80107d30 <trap+0x269>
  }

  switch(tf->trapno){
80107b19:	8b 45 08             	mov    0x8(%ebp),%eax
80107b1c:	8b 40 30             	mov    0x30(%eax),%eax
80107b1f:	83 e8 20             	sub    $0x20,%eax
80107b22:	83 f8 1f             	cmp    $0x1f,%eax
80107b25:	0f 87 a3 00 00 00    	ja     80107bce <trap+0x107>
80107b2b:	8b 04 85 a8 a3 10 80 	mov    -0x7fef5c58(,%eax,4),%eax
80107b32:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80107b34:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107b3a:	0f b6 00             	movzbl (%eax),%eax
80107b3d:	84 c0                	test   %al,%al
80107b3f:	75 20                	jne    80107b61 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80107b41:	83 ec 0c             	sub    $0xc,%esp
80107b44:	68 e0 76 11 80       	push   $0x801176e0
80107b49:	e8 b9 fd ff ff       	call   80107907 <atom_inc>
80107b4e:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80107b51:	83 ec 0c             	sub    $0xc,%esp
80107b54:	68 e0 76 11 80       	push   $0x801176e0
80107b59:	e8 5d da ff ff       	call   801055bb <wakeup>
80107b5e:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80107b61:	e8 70 b5 ff ff       	call   801030d6 <lapiceoi>
    break;
80107b66:	e9 1c 01 00 00       	jmp    80107c87 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107b6b:	e8 79 ad ff ff       	call   801028e9 <ideintr>
    lapiceoi();
80107b70:	e8 61 b5 ff ff       	call   801030d6 <lapiceoi>
    break;
80107b75:	e9 0d 01 00 00       	jmp    80107c87 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107b7a:	e8 59 b3 ff ff       	call   80102ed8 <kbdintr>
    lapiceoi();
80107b7f:	e8 52 b5 ff ff       	call   801030d6 <lapiceoi>
    break;
80107b84:	e9 fe 00 00 00       	jmp    80107c87 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80107b89:	e8 83 03 00 00       	call   80107f11 <uartintr>
    lapiceoi();
80107b8e:	e8 43 b5 ff ff       	call   801030d6 <lapiceoi>
    break;
80107b93:	e9 ef 00 00 00       	jmp    80107c87 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107b98:	8b 45 08             	mov    0x8(%ebp),%eax
80107b9b:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80107b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80107ba1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107ba5:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80107ba8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107bae:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80107bb1:	0f b6 c0             	movzbl %al,%eax
80107bb4:	51                   	push   %ecx
80107bb5:	52                   	push   %edx
80107bb6:	50                   	push   %eax
80107bb7:	68 08 a3 10 80       	push   $0x8010a308
80107bbc:	e8 05 88 ff ff       	call   801003c6 <cprintf>
80107bc1:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80107bc4:	e8 0d b5 ff ff       	call   801030d6 <lapiceoi>
    break;
80107bc9:	e9 b9 00 00 00       	jmp    80107c87 <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80107bce:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107bd4:	85 c0                	test   %eax,%eax
80107bd6:	74 11                	je     80107be9 <trap+0x122>
80107bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80107bdb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107bdf:	0f b7 c0             	movzwl %ax,%eax
80107be2:	83 e0 03             	and    $0x3,%eax
80107be5:	85 c0                	test   %eax,%eax
80107be7:	75 40                	jne    80107c29 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107be9:	e8 4f fd ff ff       	call   8010793d <rcr2>
80107bee:	89 c3                	mov    %eax,%ebx
80107bf0:	8b 45 08             	mov    0x8(%ebp),%eax
80107bf3:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107bf6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107bfc:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107bff:	0f b6 d0             	movzbl %al,%edx
80107c02:	8b 45 08             	mov    0x8(%ebp),%eax
80107c05:	8b 40 30             	mov    0x30(%eax),%eax
80107c08:	83 ec 0c             	sub    $0xc,%esp
80107c0b:	53                   	push   %ebx
80107c0c:	51                   	push   %ecx
80107c0d:	52                   	push   %edx
80107c0e:	50                   	push   %eax
80107c0f:	68 2c a3 10 80       	push   $0x8010a32c
80107c14:	e8 ad 87 ff ff       	call   801003c6 <cprintf>
80107c19:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107c1c:	83 ec 0c             	sub    $0xc,%esp
80107c1f:	68 5e a3 10 80       	push   $0x8010a35e
80107c24:	e8 3d 89 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107c29:	e8 0f fd ff ff       	call   8010793d <rcr2>
80107c2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107c31:	8b 45 08             	mov    0x8(%ebp),%eax
80107c34:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107c37:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107c3d:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107c40:	0f b6 d8             	movzbl %al,%ebx
80107c43:	8b 45 08             	mov    0x8(%ebp),%eax
80107c46:	8b 48 34             	mov    0x34(%eax),%ecx
80107c49:	8b 45 08             	mov    0x8(%ebp),%eax
80107c4c:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107c4f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c55:	8d 78 6c             	lea    0x6c(%eax),%edi
80107c58:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107c5e:	8b 40 10             	mov    0x10(%eax),%eax
80107c61:	ff 75 e4             	pushl  -0x1c(%ebp)
80107c64:	56                   	push   %esi
80107c65:	53                   	push   %ebx
80107c66:	51                   	push   %ecx
80107c67:	52                   	push   %edx
80107c68:	57                   	push   %edi
80107c69:	50                   	push   %eax
80107c6a:	68 64 a3 10 80       	push   $0x8010a364
80107c6f:	e8 52 87 ff ff       	call   801003c6 <cprintf>
80107c74:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80107c77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c7d:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80107c84:	eb 01                	jmp    80107c87 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80107c86:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107c87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c8d:	85 c0                	test   %eax,%eax
80107c8f:	74 24                	je     80107cb5 <trap+0x1ee>
80107c91:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c97:	8b 40 24             	mov    0x24(%eax),%eax
80107c9a:	85 c0                	test   %eax,%eax
80107c9c:	74 17                	je     80107cb5 <trap+0x1ee>
80107c9e:	8b 45 08             	mov    0x8(%ebp),%eax
80107ca1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107ca5:	0f b7 c0             	movzwl %ax,%eax
80107ca8:	83 e0 03             	and    $0x3,%eax
80107cab:	83 f8 03             	cmp    $0x3,%eax
80107cae:	75 05                	jne    80107cb5 <trap+0x1ee>
    exit();
80107cb0:	e8 58 cf ff ff       	call   80104c0d <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80107cb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cbb:	85 c0                	test   %eax,%eax
80107cbd:	74 41                	je     80107d00 <trap+0x239>
80107cbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107cc5:	8b 40 0c             	mov    0xc(%eax),%eax
80107cc8:	83 f8 04             	cmp    $0x4,%eax
80107ccb:	75 33                	jne    80107d00 <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80107ccd:	8b 45 08             	mov    0x8(%ebp),%eax
80107cd0:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80107cd3:	83 f8 20             	cmp    $0x20,%eax
80107cd6:	75 28                	jne    80107d00 <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80107cd8:	8b 0d e0 76 11 80    	mov    0x801176e0,%ecx
80107cde:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80107ce3:	89 c8                	mov    %ecx,%eax
80107ce5:	f7 e2                	mul    %edx
80107ce7:	c1 ea 03             	shr    $0x3,%edx
80107cea:	89 d0                	mov    %edx,%eax
80107cec:	c1 e0 02             	shl    $0x2,%eax
80107cef:	01 d0                	add    %edx,%eax
80107cf1:	01 c0                	add    %eax,%eax
80107cf3:	29 c1                	sub    %eax,%ecx
80107cf5:	89 ca                	mov    %ecx,%edx
80107cf7:	85 d2                	test   %edx,%edx
80107cf9:	75 05                	jne    80107d00 <trap+0x239>
    yield();
80107cfb:	e8 08 d6 ff ff       	call   80105308 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107d00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d06:	85 c0                	test   %eax,%eax
80107d08:	74 27                	je     80107d31 <trap+0x26a>
80107d0a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d10:	8b 40 24             	mov    0x24(%eax),%eax
80107d13:	85 c0                	test   %eax,%eax
80107d15:	74 1a                	je     80107d31 <trap+0x26a>
80107d17:	8b 45 08             	mov    0x8(%ebp),%eax
80107d1a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107d1e:	0f b7 c0             	movzwl %ax,%eax
80107d21:	83 e0 03             	and    $0x3,%eax
80107d24:	83 f8 03             	cmp    $0x3,%eax
80107d27:	75 08                	jne    80107d31 <trap+0x26a>
    exit();
80107d29:	e8 df ce ff ff       	call   80104c0d <exit>
80107d2e:	eb 01                	jmp    80107d31 <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80107d30:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80107d31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107d34:	5b                   	pop    %ebx
80107d35:	5e                   	pop    %esi
80107d36:	5f                   	pop    %edi
80107d37:	5d                   	pop    %ebp
80107d38:	c3                   	ret    

80107d39 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80107d39:	55                   	push   %ebp
80107d3a:	89 e5                	mov    %esp,%ebp
80107d3c:	83 ec 14             	sub    $0x14,%esp
80107d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80107d42:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107d46:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107d4a:	89 c2                	mov    %eax,%edx
80107d4c:	ec                   	in     (%dx),%al
80107d4d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80107d50:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107d54:	c9                   	leave  
80107d55:	c3                   	ret    

80107d56 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107d56:	55                   	push   %ebp
80107d57:	89 e5                	mov    %esp,%ebp
80107d59:	83 ec 08             	sub    $0x8,%esp
80107d5c:	8b 55 08             	mov    0x8(%ebp),%edx
80107d5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107d62:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107d66:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107d69:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107d6d:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107d71:	ee                   	out    %al,(%dx)
}
80107d72:	90                   	nop
80107d73:	c9                   	leave  
80107d74:	c3                   	ret    

80107d75 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107d75:	55                   	push   %ebp
80107d76:	89 e5                	mov    %esp,%ebp
80107d78:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107d7b:	6a 00                	push   $0x0
80107d7d:	68 fa 03 00 00       	push   $0x3fa
80107d82:	e8 cf ff ff ff       	call   80107d56 <outb>
80107d87:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80107d8a:	68 80 00 00 00       	push   $0x80
80107d8f:	68 fb 03 00 00       	push   $0x3fb
80107d94:	e8 bd ff ff ff       	call   80107d56 <outb>
80107d99:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80107d9c:	6a 0c                	push   $0xc
80107d9e:	68 f8 03 00 00       	push   $0x3f8
80107da3:	e8 ae ff ff ff       	call   80107d56 <outb>
80107da8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80107dab:	6a 00                	push   $0x0
80107dad:	68 f9 03 00 00       	push   $0x3f9
80107db2:	e8 9f ff ff ff       	call   80107d56 <outb>
80107db7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80107dba:	6a 03                	push   $0x3
80107dbc:	68 fb 03 00 00       	push   $0x3fb
80107dc1:	e8 90 ff ff ff       	call   80107d56 <outb>
80107dc6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80107dc9:	6a 00                	push   $0x0
80107dcb:	68 fc 03 00 00       	push   $0x3fc
80107dd0:	e8 81 ff ff ff       	call   80107d56 <outb>
80107dd5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80107dd8:	6a 01                	push   $0x1
80107dda:	68 f9 03 00 00       	push   $0x3f9
80107ddf:	e8 72 ff ff ff       	call   80107d56 <outb>
80107de4:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107de7:	68 fd 03 00 00       	push   $0x3fd
80107dec:	e8 48 ff ff ff       	call   80107d39 <inb>
80107df1:	83 c4 04             	add    $0x4,%esp
80107df4:	3c ff                	cmp    $0xff,%al
80107df6:	74 6e                	je     80107e66 <uartinit+0xf1>
    return;
  uart = 1;
80107df8:	c7 05 6c d6 10 80 01 	movl   $0x1,0x8010d66c
80107dff:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80107e02:	68 fa 03 00 00       	push   $0x3fa
80107e07:	e8 2d ff ff ff       	call   80107d39 <inb>
80107e0c:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80107e0f:	68 f8 03 00 00       	push   $0x3f8
80107e14:	e8 20 ff ff ff       	call   80107d39 <inb>
80107e19:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80107e1c:	83 ec 0c             	sub    $0xc,%esp
80107e1f:	6a 04                	push   $0x4
80107e21:	e8 b6 c1 ff ff       	call   80103fdc <picenable>
80107e26:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80107e29:	83 ec 08             	sub    $0x8,%esp
80107e2c:	6a 00                	push   $0x0
80107e2e:	6a 04                	push   $0x4
80107e30:	e8 56 ad ff ff       	call   80102b8b <ioapicenable>
80107e35:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107e38:	c7 45 f4 28 a4 10 80 	movl   $0x8010a428,-0xc(%ebp)
80107e3f:	eb 19                	jmp    80107e5a <uartinit+0xe5>
    uartputc(*p);
80107e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e44:	0f b6 00             	movzbl (%eax),%eax
80107e47:	0f be c0             	movsbl %al,%eax
80107e4a:	83 ec 0c             	sub    $0xc,%esp
80107e4d:	50                   	push   %eax
80107e4e:	e8 16 00 00 00       	call   80107e69 <uartputc>
80107e53:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107e56:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e5d:	0f b6 00             	movzbl (%eax),%eax
80107e60:	84 c0                	test   %al,%al
80107e62:	75 dd                	jne    80107e41 <uartinit+0xcc>
80107e64:	eb 01                	jmp    80107e67 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80107e66:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80107e67:	c9                   	leave  
80107e68:	c3                   	ret    

80107e69 <uartputc>:

void
uartputc(int c)
{
80107e69:	55                   	push   %ebp
80107e6a:	89 e5                	mov    %esp,%ebp
80107e6c:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80107e6f:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80107e74:	85 c0                	test   %eax,%eax
80107e76:	74 53                	je     80107ecb <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107e78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107e7f:	eb 11                	jmp    80107e92 <uartputc+0x29>
    microdelay(10);
80107e81:	83 ec 0c             	sub    $0xc,%esp
80107e84:	6a 0a                	push   $0xa
80107e86:	e8 66 b2 ff ff       	call   801030f1 <microdelay>
80107e8b:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80107e8e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107e92:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80107e96:	7f 1a                	jg     80107eb2 <uartputc+0x49>
80107e98:	83 ec 0c             	sub    $0xc,%esp
80107e9b:	68 fd 03 00 00       	push   $0x3fd
80107ea0:	e8 94 fe ff ff       	call   80107d39 <inb>
80107ea5:	83 c4 10             	add    $0x10,%esp
80107ea8:	0f b6 c0             	movzbl %al,%eax
80107eab:	83 e0 20             	and    $0x20,%eax
80107eae:	85 c0                	test   %eax,%eax
80107eb0:	74 cf                	je     80107e81 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80107eb2:	8b 45 08             	mov    0x8(%ebp),%eax
80107eb5:	0f b6 c0             	movzbl %al,%eax
80107eb8:	83 ec 08             	sub    $0x8,%esp
80107ebb:	50                   	push   %eax
80107ebc:	68 f8 03 00 00       	push   $0x3f8
80107ec1:	e8 90 fe ff ff       	call   80107d56 <outb>
80107ec6:	83 c4 10             	add    $0x10,%esp
80107ec9:	eb 01                	jmp    80107ecc <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80107ecb:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80107ecc:	c9                   	leave  
80107ecd:	c3                   	ret    

80107ece <uartgetc>:

static int
uartgetc(void)
{
80107ece:	55                   	push   %ebp
80107ecf:	89 e5                	mov    %esp,%ebp
  if(!uart)
80107ed1:	a1 6c d6 10 80       	mov    0x8010d66c,%eax
80107ed6:	85 c0                	test   %eax,%eax
80107ed8:	75 07                	jne    80107ee1 <uartgetc+0x13>
    return -1;
80107eda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107edf:	eb 2e                	jmp    80107f0f <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80107ee1:	68 fd 03 00 00       	push   $0x3fd
80107ee6:	e8 4e fe ff ff       	call   80107d39 <inb>
80107eeb:	83 c4 04             	add    $0x4,%esp
80107eee:	0f b6 c0             	movzbl %al,%eax
80107ef1:	83 e0 01             	and    $0x1,%eax
80107ef4:	85 c0                	test   %eax,%eax
80107ef6:	75 07                	jne    80107eff <uartgetc+0x31>
    return -1;
80107ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107efd:	eb 10                	jmp    80107f0f <uartgetc+0x41>
  return inb(COM1+0);
80107eff:	68 f8 03 00 00       	push   $0x3f8
80107f04:	e8 30 fe ff ff       	call   80107d39 <inb>
80107f09:	83 c4 04             	add    $0x4,%esp
80107f0c:	0f b6 c0             	movzbl %al,%eax
}
80107f0f:	c9                   	leave  
80107f10:	c3                   	ret    

80107f11 <uartintr>:

void
uartintr(void)
{
80107f11:	55                   	push   %ebp
80107f12:	89 e5                	mov    %esp,%ebp
80107f14:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80107f17:	83 ec 0c             	sub    $0xc,%esp
80107f1a:	68 ce 7e 10 80       	push   $0x80107ece
80107f1f:	e8 d5 88 ff ff       	call   801007f9 <consoleintr>
80107f24:	83 c4 10             	add    $0x10,%esp
}
80107f27:	90                   	nop
80107f28:	c9                   	leave  
80107f29:	c3                   	ret    

80107f2a <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107f2a:	6a 00                	push   $0x0
  pushl $0
80107f2c:	6a 00                	push   $0x0
  jmp alltraps
80107f2e:	e9 a9 f9 ff ff       	jmp    801078dc <alltraps>

80107f33 <vector1>:
.globl vector1
vector1:
  pushl $0
80107f33:	6a 00                	push   $0x0
  pushl $1
80107f35:	6a 01                	push   $0x1
  jmp alltraps
80107f37:	e9 a0 f9 ff ff       	jmp    801078dc <alltraps>

80107f3c <vector2>:
.globl vector2
vector2:
  pushl $0
80107f3c:	6a 00                	push   $0x0
  pushl $2
80107f3e:	6a 02                	push   $0x2
  jmp alltraps
80107f40:	e9 97 f9 ff ff       	jmp    801078dc <alltraps>

80107f45 <vector3>:
.globl vector3
vector3:
  pushl $0
80107f45:	6a 00                	push   $0x0
  pushl $3
80107f47:	6a 03                	push   $0x3
  jmp alltraps
80107f49:	e9 8e f9 ff ff       	jmp    801078dc <alltraps>

80107f4e <vector4>:
.globl vector4
vector4:
  pushl $0
80107f4e:	6a 00                	push   $0x0
  pushl $4
80107f50:	6a 04                	push   $0x4
  jmp alltraps
80107f52:	e9 85 f9 ff ff       	jmp    801078dc <alltraps>

80107f57 <vector5>:
.globl vector5
vector5:
  pushl $0
80107f57:	6a 00                	push   $0x0
  pushl $5
80107f59:	6a 05                	push   $0x5
  jmp alltraps
80107f5b:	e9 7c f9 ff ff       	jmp    801078dc <alltraps>

80107f60 <vector6>:
.globl vector6
vector6:
  pushl $0
80107f60:	6a 00                	push   $0x0
  pushl $6
80107f62:	6a 06                	push   $0x6
  jmp alltraps
80107f64:	e9 73 f9 ff ff       	jmp    801078dc <alltraps>

80107f69 <vector7>:
.globl vector7
vector7:
  pushl $0
80107f69:	6a 00                	push   $0x0
  pushl $7
80107f6b:	6a 07                	push   $0x7
  jmp alltraps
80107f6d:	e9 6a f9 ff ff       	jmp    801078dc <alltraps>

80107f72 <vector8>:
.globl vector8
vector8:
  pushl $8
80107f72:	6a 08                	push   $0x8
  jmp alltraps
80107f74:	e9 63 f9 ff ff       	jmp    801078dc <alltraps>

80107f79 <vector9>:
.globl vector9
vector9:
  pushl $0
80107f79:	6a 00                	push   $0x0
  pushl $9
80107f7b:	6a 09                	push   $0x9
  jmp alltraps
80107f7d:	e9 5a f9 ff ff       	jmp    801078dc <alltraps>

80107f82 <vector10>:
.globl vector10
vector10:
  pushl $10
80107f82:	6a 0a                	push   $0xa
  jmp alltraps
80107f84:	e9 53 f9 ff ff       	jmp    801078dc <alltraps>

80107f89 <vector11>:
.globl vector11
vector11:
  pushl $11
80107f89:	6a 0b                	push   $0xb
  jmp alltraps
80107f8b:	e9 4c f9 ff ff       	jmp    801078dc <alltraps>

80107f90 <vector12>:
.globl vector12
vector12:
  pushl $12
80107f90:	6a 0c                	push   $0xc
  jmp alltraps
80107f92:	e9 45 f9 ff ff       	jmp    801078dc <alltraps>

80107f97 <vector13>:
.globl vector13
vector13:
  pushl $13
80107f97:	6a 0d                	push   $0xd
  jmp alltraps
80107f99:	e9 3e f9 ff ff       	jmp    801078dc <alltraps>

80107f9e <vector14>:
.globl vector14
vector14:
  pushl $14
80107f9e:	6a 0e                	push   $0xe
  jmp alltraps
80107fa0:	e9 37 f9 ff ff       	jmp    801078dc <alltraps>

80107fa5 <vector15>:
.globl vector15
vector15:
  pushl $0
80107fa5:	6a 00                	push   $0x0
  pushl $15
80107fa7:	6a 0f                	push   $0xf
  jmp alltraps
80107fa9:	e9 2e f9 ff ff       	jmp    801078dc <alltraps>

80107fae <vector16>:
.globl vector16
vector16:
  pushl $0
80107fae:	6a 00                	push   $0x0
  pushl $16
80107fb0:	6a 10                	push   $0x10
  jmp alltraps
80107fb2:	e9 25 f9 ff ff       	jmp    801078dc <alltraps>

80107fb7 <vector17>:
.globl vector17
vector17:
  pushl $17
80107fb7:	6a 11                	push   $0x11
  jmp alltraps
80107fb9:	e9 1e f9 ff ff       	jmp    801078dc <alltraps>

80107fbe <vector18>:
.globl vector18
vector18:
  pushl $0
80107fbe:	6a 00                	push   $0x0
  pushl $18
80107fc0:	6a 12                	push   $0x12
  jmp alltraps
80107fc2:	e9 15 f9 ff ff       	jmp    801078dc <alltraps>

80107fc7 <vector19>:
.globl vector19
vector19:
  pushl $0
80107fc7:	6a 00                	push   $0x0
  pushl $19
80107fc9:	6a 13                	push   $0x13
  jmp alltraps
80107fcb:	e9 0c f9 ff ff       	jmp    801078dc <alltraps>

80107fd0 <vector20>:
.globl vector20
vector20:
  pushl $0
80107fd0:	6a 00                	push   $0x0
  pushl $20
80107fd2:	6a 14                	push   $0x14
  jmp alltraps
80107fd4:	e9 03 f9 ff ff       	jmp    801078dc <alltraps>

80107fd9 <vector21>:
.globl vector21
vector21:
  pushl $0
80107fd9:	6a 00                	push   $0x0
  pushl $21
80107fdb:	6a 15                	push   $0x15
  jmp alltraps
80107fdd:	e9 fa f8 ff ff       	jmp    801078dc <alltraps>

80107fe2 <vector22>:
.globl vector22
vector22:
  pushl $0
80107fe2:	6a 00                	push   $0x0
  pushl $22
80107fe4:	6a 16                	push   $0x16
  jmp alltraps
80107fe6:	e9 f1 f8 ff ff       	jmp    801078dc <alltraps>

80107feb <vector23>:
.globl vector23
vector23:
  pushl $0
80107feb:	6a 00                	push   $0x0
  pushl $23
80107fed:	6a 17                	push   $0x17
  jmp alltraps
80107fef:	e9 e8 f8 ff ff       	jmp    801078dc <alltraps>

80107ff4 <vector24>:
.globl vector24
vector24:
  pushl $0
80107ff4:	6a 00                	push   $0x0
  pushl $24
80107ff6:	6a 18                	push   $0x18
  jmp alltraps
80107ff8:	e9 df f8 ff ff       	jmp    801078dc <alltraps>

80107ffd <vector25>:
.globl vector25
vector25:
  pushl $0
80107ffd:	6a 00                	push   $0x0
  pushl $25
80107fff:	6a 19                	push   $0x19
  jmp alltraps
80108001:	e9 d6 f8 ff ff       	jmp    801078dc <alltraps>

80108006 <vector26>:
.globl vector26
vector26:
  pushl $0
80108006:	6a 00                	push   $0x0
  pushl $26
80108008:	6a 1a                	push   $0x1a
  jmp alltraps
8010800a:	e9 cd f8 ff ff       	jmp    801078dc <alltraps>

8010800f <vector27>:
.globl vector27
vector27:
  pushl $0
8010800f:	6a 00                	push   $0x0
  pushl $27
80108011:	6a 1b                	push   $0x1b
  jmp alltraps
80108013:	e9 c4 f8 ff ff       	jmp    801078dc <alltraps>

80108018 <vector28>:
.globl vector28
vector28:
  pushl $0
80108018:	6a 00                	push   $0x0
  pushl $28
8010801a:	6a 1c                	push   $0x1c
  jmp alltraps
8010801c:	e9 bb f8 ff ff       	jmp    801078dc <alltraps>

80108021 <vector29>:
.globl vector29
vector29:
  pushl $0
80108021:	6a 00                	push   $0x0
  pushl $29
80108023:	6a 1d                	push   $0x1d
  jmp alltraps
80108025:	e9 b2 f8 ff ff       	jmp    801078dc <alltraps>

8010802a <vector30>:
.globl vector30
vector30:
  pushl $0
8010802a:	6a 00                	push   $0x0
  pushl $30
8010802c:	6a 1e                	push   $0x1e
  jmp alltraps
8010802e:	e9 a9 f8 ff ff       	jmp    801078dc <alltraps>

80108033 <vector31>:
.globl vector31
vector31:
  pushl $0
80108033:	6a 00                	push   $0x0
  pushl $31
80108035:	6a 1f                	push   $0x1f
  jmp alltraps
80108037:	e9 a0 f8 ff ff       	jmp    801078dc <alltraps>

8010803c <vector32>:
.globl vector32
vector32:
  pushl $0
8010803c:	6a 00                	push   $0x0
  pushl $32
8010803e:	6a 20                	push   $0x20
  jmp alltraps
80108040:	e9 97 f8 ff ff       	jmp    801078dc <alltraps>

80108045 <vector33>:
.globl vector33
vector33:
  pushl $0
80108045:	6a 00                	push   $0x0
  pushl $33
80108047:	6a 21                	push   $0x21
  jmp alltraps
80108049:	e9 8e f8 ff ff       	jmp    801078dc <alltraps>

8010804e <vector34>:
.globl vector34
vector34:
  pushl $0
8010804e:	6a 00                	push   $0x0
  pushl $34
80108050:	6a 22                	push   $0x22
  jmp alltraps
80108052:	e9 85 f8 ff ff       	jmp    801078dc <alltraps>

80108057 <vector35>:
.globl vector35
vector35:
  pushl $0
80108057:	6a 00                	push   $0x0
  pushl $35
80108059:	6a 23                	push   $0x23
  jmp alltraps
8010805b:	e9 7c f8 ff ff       	jmp    801078dc <alltraps>

80108060 <vector36>:
.globl vector36
vector36:
  pushl $0
80108060:	6a 00                	push   $0x0
  pushl $36
80108062:	6a 24                	push   $0x24
  jmp alltraps
80108064:	e9 73 f8 ff ff       	jmp    801078dc <alltraps>

80108069 <vector37>:
.globl vector37
vector37:
  pushl $0
80108069:	6a 00                	push   $0x0
  pushl $37
8010806b:	6a 25                	push   $0x25
  jmp alltraps
8010806d:	e9 6a f8 ff ff       	jmp    801078dc <alltraps>

80108072 <vector38>:
.globl vector38
vector38:
  pushl $0
80108072:	6a 00                	push   $0x0
  pushl $38
80108074:	6a 26                	push   $0x26
  jmp alltraps
80108076:	e9 61 f8 ff ff       	jmp    801078dc <alltraps>

8010807b <vector39>:
.globl vector39
vector39:
  pushl $0
8010807b:	6a 00                	push   $0x0
  pushl $39
8010807d:	6a 27                	push   $0x27
  jmp alltraps
8010807f:	e9 58 f8 ff ff       	jmp    801078dc <alltraps>

80108084 <vector40>:
.globl vector40
vector40:
  pushl $0
80108084:	6a 00                	push   $0x0
  pushl $40
80108086:	6a 28                	push   $0x28
  jmp alltraps
80108088:	e9 4f f8 ff ff       	jmp    801078dc <alltraps>

8010808d <vector41>:
.globl vector41
vector41:
  pushl $0
8010808d:	6a 00                	push   $0x0
  pushl $41
8010808f:	6a 29                	push   $0x29
  jmp alltraps
80108091:	e9 46 f8 ff ff       	jmp    801078dc <alltraps>

80108096 <vector42>:
.globl vector42
vector42:
  pushl $0
80108096:	6a 00                	push   $0x0
  pushl $42
80108098:	6a 2a                	push   $0x2a
  jmp alltraps
8010809a:	e9 3d f8 ff ff       	jmp    801078dc <alltraps>

8010809f <vector43>:
.globl vector43
vector43:
  pushl $0
8010809f:	6a 00                	push   $0x0
  pushl $43
801080a1:	6a 2b                	push   $0x2b
  jmp alltraps
801080a3:	e9 34 f8 ff ff       	jmp    801078dc <alltraps>

801080a8 <vector44>:
.globl vector44
vector44:
  pushl $0
801080a8:	6a 00                	push   $0x0
  pushl $44
801080aa:	6a 2c                	push   $0x2c
  jmp alltraps
801080ac:	e9 2b f8 ff ff       	jmp    801078dc <alltraps>

801080b1 <vector45>:
.globl vector45
vector45:
  pushl $0
801080b1:	6a 00                	push   $0x0
  pushl $45
801080b3:	6a 2d                	push   $0x2d
  jmp alltraps
801080b5:	e9 22 f8 ff ff       	jmp    801078dc <alltraps>

801080ba <vector46>:
.globl vector46
vector46:
  pushl $0
801080ba:	6a 00                	push   $0x0
  pushl $46
801080bc:	6a 2e                	push   $0x2e
  jmp alltraps
801080be:	e9 19 f8 ff ff       	jmp    801078dc <alltraps>

801080c3 <vector47>:
.globl vector47
vector47:
  pushl $0
801080c3:	6a 00                	push   $0x0
  pushl $47
801080c5:	6a 2f                	push   $0x2f
  jmp alltraps
801080c7:	e9 10 f8 ff ff       	jmp    801078dc <alltraps>

801080cc <vector48>:
.globl vector48
vector48:
  pushl $0
801080cc:	6a 00                	push   $0x0
  pushl $48
801080ce:	6a 30                	push   $0x30
  jmp alltraps
801080d0:	e9 07 f8 ff ff       	jmp    801078dc <alltraps>

801080d5 <vector49>:
.globl vector49
vector49:
  pushl $0
801080d5:	6a 00                	push   $0x0
  pushl $49
801080d7:	6a 31                	push   $0x31
  jmp alltraps
801080d9:	e9 fe f7 ff ff       	jmp    801078dc <alltraps>

801080de <vector50>:
.globl vector50
vector50:
  pushl $0
801080de:	6a 00                	push   $0x0
  pushl $50
801080e0:	6a 32                	push   $0x32
  jmp alltraps
801080e2:	e9 f5 f7 ff ff       	jmp    801078dc <alltraps>

801080e7 <vector51>:
.globl vector51
vector51:
  pushl $0
801080e7:	6a 00                	push   $0x0
  pushl $51
801080e9:	6a 33                	push   $0x33
  jmp alltraps
801080eb:	e9 ec f7 ff ff       	jmp    801078dc <alltraps>

801080f0 <vector52>:
.globl vector52
vector52:
  pushl $0
801080f0:	6a 00                	push   $0x0
  pushl $52
801080f2:	6a 34                	push   $0x34
  jmp alltraps
801080f4:	e9 e3 f7 ff ff       	jmp    801078dc <alltraps>

801080f9 <vector53>:
.globl vector53
vector53:
  pushl $0
801080f9:	6a 00                	push   $0x0
  pushl $53
801080fb:	6a 35                	push   $0x35
  jmp alltraps
801080fd:	e9 da f7 ff ff       	jmp    801078dc <alltraps>

80108102 <vector54>:
.globl vector54
vector54:
  pushl $0
80108102:	6a 00                	push   $0x0
  pushl $54
80108104:	6a 36                	push   $0x36
  jmp alltraps
80108106:	e9 d1 f7 ff ff       	jmp    801078dc <alltraps>

8010810b <vector55>:
.globl vector55
vector55:
  pushl $0
8010810b:	6a 00                	push   $0x0
  pushl $55
8010810d:	6a 37                	push   $0x37
  jmp alltraps
8010810f:	e9 c8 f7 ff ff       	jmp    801078dc <alltraps>

80108114 <vector56>:
.globl vector56
vector56:
  pushl $0
80108114:	6a 00                	push   $0x0
  pushl $56
80108116:	6a 38                	push   $0x38
  jmp alltraps
80108118:	e9 bf f7 ff ff       	jmp    801078dc <alltraps>

8010811d <vector57>:
.globl vector57
vector57:
  pushl $0
8010811d:	6a 00                	push   $0x0
  pushl $57
8010811f:	6a 39                	push   $0x39
  jmp alltraps
80108121:	e9 b6 f7 ff ff       	jmp    801078dc <alltraps>

80108126 <vector58>:
.globl vector58
vector58:
  pushl $0
80108126:	6a 00                	push   $0x0
  pushl $58
80108128:	6a 3a                	push   $0x3a
  jmp alltraps
8010812a:	e9 ad f7 ff ff       	jmp    801078dc <alltraps>

8010812f <vector59>:
.globl vector59
vector59:
  pushl $0
8010812f:	6a 00                	push   $0x0
  pushl $59
80108131:	6a 3b                	push   $0x3b
  jmp alltraps
80108133:	e9 a4 f7 ff ff       	jmp    801078dc <alltraps>

80108138 <vector60>:
.globl vector60
vector60:
  pushl $0
80108138:	6a 00                	push   $0x0
  pushl $60
8010813a:	6a 3c                	push   $0x3c
  jmp alltraps
8010813c:	e9 9b f7 ff ff       	jmp    801078dc <alltraps>

80108141 <vector61>:
.globl vector61
vector61:
  pushl $0
80108141:	6a 00                	push   $0x0
  pushl $61
80108143:	6a 3d                	push   $0x3d
  jmp alltraps
80108145:	e9 92 f7 ff ff       	jmp    801078dc <alltraps>

8010814a <vector62>:
.globl vector62
vector62:
  pushl $0
8010814a:	6a 00                	push   $0x0
  pushl $62
8010814c:	6a 3e                	push   $0x3e
  jmp alltraps
8010814e:	e9 89 f7 ff ff       	jmp    801078dc <alltraps>

80108153 <vector63>:
.globl vector63
vector63:
  pushl $0
80108153:	6a 00                	push   $0x0
  pushl $63
80108155:	6a 3f                	push   $0x3f
  jmp alltraps
80108157:	e9 80 f7 ff ff       	jmp    801078dc <alltraps>

8010815c <vector64>:
.globl vector64
vector64:
  pushl $0
8010815c:	6a 00                	push   $0x0
  pushl $64
8010815e:	6a 40                	push   $0x40
  jmp alltraps
80108160:	e9 77 f7 ff ff       	jmp    801078dc <alltraps>

80108165 <vector65>:
.globl vector65
vector65:
  pushl $0
80108165:	6a 00                	push   $0x0
  pushl $65
80108167:	6a 41                	push   $0x41
  jmp alltraps
80108169:	e9 6e f7 ff ff       	jmp    801078dc <alltraps>

8010816e <vector66>:
.globl vector66
vector66:
  pushl $0
8010816e:	6a 00                	push   $0x0
  pushl $66
80108170:	6a 42                	push   $0x42
  jmp alltraps
80108172:	e9 65 f7 ff ff       	jmp    801078dc <alltraps>

80108177 <vector67>:
.globl vector67
vector67:
  pushl $0
80108177:	6a 00                	push   $0x0
  pushl $67
80108179:	6a 43                	push   $0x43
  jmp alltraps
8010817b:	e9 5c f7 ff ff       	jmp    801078dc <alltraps>

80108180 <vector68>:
.globl vector68
vector68:
  pushl $0
80108180:	6a 00                	push   $0x0
  pushl $68
80108182:	6a 44                	push   $0x44
  jmp alltraps
80108184:	e9 53 f7 ff ff       	jmp    801078dc <alltraps>

80108189 <vector69>:
.globl vector69
vector69:
  pushl $0
80108189:	6a 00                	push   $0x0
  pushl $69
8010818b:	6a 45                	push   $0x45
  jmp alltraps
8010818d:	e9 4a f7 ff ff       	jmp    801078dc <alltraps>

80108192 <vector70>:
.globl vector70
vector70:
  pushl $0
80108192:	6a 00                	push   $0x0
  pushl $70
80108194:	6a 46                	push   $0x46
  jmp alltraps
80108196:	e9 41 f7 ff ff       	jmp    801078dc <alltraps>

8010819b <vector71>:
.globl vector71
vector71:
  pushl $0
8010819b:	6a 00                	push   $0x0
  pushl $71
8010819d:	6a 47                	push   $0x47
  jmp alltraps
8010819f:	e9 38 f7 ff ff       	jmp    801078dc <alltraps>

801081a4 <vector72>:
.globl vector72
vector72:
  pushl $0
801081a4:	6a 00                	push   $0x0
  pushl $72
801081a6:	6a 48                	push   $0x48
  jmp alltraps
801081a8:	e9 2f f7 ff ff       	jmp    801078dc <alltraps>

801081ad <vector73>:
.globl vector73
vector73:
  pushl $0
801081ad:	6a 00                	push   $0x0
  pushl $73
801081af:	6a 49                	push   $0x49
  jmp alltraps
801081b1:	e9 26 f7 ff ff       	jmp    801078dc <alltraps>

801081b6 <vector74>:
.globl vector74
vector74:
  pushl $0
801081b6:	6a 00                	push   $0x0
  pushl $74
801081b8:	6a 4a                	push   $0x4a
  jmp alltraps
801081ba:	e9 1d f7 ff ff       	jmp    801078dc <alltraps>

801081bf <vector75>:
.globl vector75
vector75:
  pushl $0
801081bf:	6a 00                	push   $0x0
  pushl $75
801081c1:	6a 4b                	push   $0x4b
  jmp alltraps
801081c3:	e9 14 f7 ff ff       	jmp    801078dc <alltraps>

801081c8 <vector76>:
.globl vector76
vector76:
  pushl $0
801081c8:	6a 00                	push   $0x0
  pushl $76
801081ca:	6a 4c                	push   $0x4c
  jmp alltraps
801081cc:	e9 0b f7 ff ff       	jmp    801078dc <alltraps>

801081d1 <vector77>:
.globl vector77
vector77:
  pushl $0
801081d1:	6a 00                	push   $0x0
  pushl $77
801081d3:	6a 4d                	push   $0x4d
  jmp alltraps
801081d5:	e9 02 f7 ff ff       	jmp    801078dc <alltraps>

801081da <vector78>:
.globl vector78
vector78:
  pushl $0
801081da:	6a 00                	push   $0x0
  pushl $78
801081dc:	6a 4e                	push   $0x4e
  jmp alltraps
801081de:	e9 f9 f6 ff ff       	jmp    801078dc <alltraps>

801081e3 <vector79>:
.globl vector79
vector79:
  pushl $0
801081e3:	6a 00                	push   $0x0
  pushl $79
801081e5:	6a 4f                	push   $0x4f
  jmp alltraps
801081e7:	e9 f0 f6 ff ff       	jmp    801078dc <alltraps>

801081ec <vector80>:
.globl vector80
vector80:
  pushl $0
801081ec:	6a 00                	push   $0x0
  pushl $80
801081ee:	6a 50                	push   $0x50
  jmp alltraps
801081f0:	e9 e7 f6 ff ff       	jmp    801078dc <alltraps>

801081f5 <vector81>:
.globl vector81
vector81:
  pushl $0
801081f5:	6a 00                	push   $0x0
  pushl $81
801081f7:	6a 51                	push   $0x51
  jmp alltraps
801081f9:	e9 de f6 ff ff       	jmp    801078dc <alltraps>

801081fe <vector82>:
.globl vector82
vector82:
  pushl $0
801081fe:	6a 00                	push   $0x0
  pushl $82
80108200:	6a 52                	push   $0x52
  jmp alltraps
80108202:	e9 d5 f6 ff ff       	jmp    801078dc <alltraps>

80108207 <vector83>:
.globl vector83
vector83:
  pushl $0
80108207:	6a 00                	push   $0x0
  pushl $83
80108209:	6a 53                	push   $0x53
  jmp alltraps
8010820b:	e9 cc f6 ff ff       	jmp    801078dc <alltraps>

80108210 <vector84>:
.globl vector84
vector84:
  pushl $0
80108210:	6a 00                	push   $0x0
  pushl $84
80108212:	6a 54                	push   $0x54
  jmp alltraps
80108214:	e9 c3 f6 ff ff       	jmp    801078dc <alltraps>

80108219 <vector85>:
.globl vector85
vector85:
  pushl $0
80108219:	6a 00                	push   $0x0
  pushl $85
8010821b:	6a 55                	push   $0x55
  jmp alltraps
8010821d:	e9 ba f6 ff ff       	jmp    801078dc <alltraps>

80108222 <vector86>:
.globl vector86
vector86:
  pushl $0
80108222:	6a 00                	push   $0x0
  pushl $86
80108224:	6a 56                	push   $0x56
  jmp alltraps
80108226:	e9 b1 f6 ff ff       	jmp    801078dc <alltraps>

8010822b <vector87>:
.globl vector87
vector87:
  pushl $0
8010822b:	6a 00                	push   $0x0
  pushl $87
8010822d:	6a 57                	push   $0x57
  jmp alltraps
8010822f:	e9 a8 f6 ff ff       	jmp    801078dc <alltraps>

80108234 <vector88>:
.globl vector88
vector88:
  pushl $0
80108234:	6a 00                	push   $0x0
  pushl $88
80108236:	6a 58                	push   $0x58
  jmp alltraps
80108238:	e9 9f f6 ff ff       	jmp    801078dc <alltraps>

8010823d <vector89>:
.globl vector89
vector89:
  pushl $0
8010823d:	6a 00                	push   $0x0
  pushl $89
8010823f:	6a 59                	push   $0x59
  jmp alltraps
80108241:	e9 96 f6 ff ff       	jmp    801078dc <alltraps>

80108246 <vector90>:
.globl vector90
vector90:
  pushl $0
80108246:	6a 00                	push   $0x0
  pushl $90
80108248:	6a 5a                	push   $0x5a
  jmp alltraps
8010824a:	e9 8d f6 ff ff       	jmp    801078dc <alltraps>

8010824f <vector91>:
.globl vector91
vector91:
  pushl $0
8010824f:	6a 00                	push   $0x0
  pushl $91
80108251:	6a 5b                	push   $0x5b
  jmp alltraps
80108253:	e9 84 f6 ff ff       	jmp    801078dc <alltraps>

80108258 <vector92>:
.globl vector92
vector92:
  pushl $0
80108258:	6a 00                	push   $0x0
  pushl $92
8010825a:	6a 5c                	push   $0x5c
  jmp alltraps
8010825c:	e9 7b f6 ff ff       	jmp    801078dc <alltraps>

80108261 <vector93>:
.globl vector93
vector93:
  pushl $0
80108261:	6a 00                	push   $0x0
  pushl $93
80108263:	6a 5d                	push   $0x5d
  jmp alltraps
80108265:	e9 72 f6 ff ff       	jmp    801078dc <alltraps>

8010826a <vector94>:
.globl vector94
vector94:
  pushl $0
8010826a:	6a 00                	push   $0x0
  pushl $94
8010826c:	6a 5e                	push   $0x5e
  jmp alltraps
8010826e:	e9 69 f6 ff ff       	jmp    801078dc <alltraps>

80108273 <vector95>:
.globl vector95
vector95:
  pushl $0
80108273:	6a 00                	push   $0x0
  pushl $95
80108275:	6a 5f                	push   $0x5f
  jmp alltraps
80108277:	e9 60 f6 ff ff       	jmp    801078dc <alltraps>

8010827c <vector96>:
.globl vector96
vector96:
  pushl $0
8010827c:	6a 00                	push   $0x0
  pushl $96
8010827e:	6a 60                	push   $0x60
  jmp alltraps
80108280:	e9 57 f6 ff ff       	jmp    801078dc <alltraps>

80108285 <vector97>:
.globl vector97
vector97:
  pushl $0
80108285:	6a 00                	push   $0x0
  pushl $97
80108287:	6a 61                	push   $0x61
  jmp alltraps
80108289:	e9 4e f6 ff ff       	jmp    801078dc <alltraps>

8010828e <vector98>:
.globl vector98
vector98:
  pushl $0
8010828e:	6a 00                	push   $0x0
  pushl $98
80108290:	6a 62                	push   $0x62
  jmp alltraps
80108292:	e9 45 f6 ff ff       	jmp    801078dc <alltraps>

80108297 <vector99>:
.globl vector99
vector99:
  pushl $0
80108297:	6a 00                	push   $0x0
  pushl $99
80108299:	6a 63                	push   $0x63
  jmp alltraps
8010829b:	e9 3c f6 ff ff       	jmp    801078dc <alltraps>

801082a0 <vector100>:
.globl vector100
vector100:
  pushl $0
801082a0:	6a 00                	push   $0x0
  pushl $100
801082a2:	6a 64                	push   $0x64
  jmp alltraps
801082a4:	e9 33 f6 ff ff       	jmp    801078dc <alltraps>

801082a9 <vector101>:
.globl vector101
vector101:
  pushl $0
801082a9:	6a 00                	push   $0x0
  pushl $101
801082ab:	6a 65                	push   $0x65
  jmp alltraps
801082ad:	e9 2a f6 ff ff       	jmp    801078dc <alltraps>

801082b2 <vector102>:
.globl vector102
vector102:
  pushl $0
801082b2:	6a 00                	push   $0x0
  pushl $102
801082b4:	6a 66                	push   $0x66
  jmp alltraps
801082b6:	e9 21 f6 ff ff       	jmp    801078dc <alltraps>

801082bb <vector103>:
.globl vector103
vector103:
  pushl $0
801082bb:	6a 00                	push   $0x0
  pushl $103
801082bd:	6a 67                	push   $0x67
  jmp alltraps
801082bf:	e9 18 f6 ff ff       	jmp    801078dc <alltraps>

801082c4 <vector104>:
.globl vector104
vector104:
  pushl $0
801082c4:	6a 00                	push   $0x0
  pushl $104
801082c6:	6a 68                	push   $0x68
  jmp alltraps
801082c8:	e9 0f f6 ff ff       	jmp    801078dc <alltraps>

801082cd <vector105>:
.globl vector105
vector105:
  pushl $0
801082cd:	6a 00                	push   $0x0
  pushl $105
801082cf:	6a 69                	push   $0x69
  jmp alltraps
801082d1:	e9 06 f6 ff ff       	jmp    801078dc <alltraps>

801082d6 <vector106>:
.globl vector106
vector106:
  pushl $0
801082d6:	6a 00                	push   $0x0
  pushl $106
801082d8:	6a 6a                	push   $0x6a
  jmp alltraps
801082da:	e9 fd f5 ff ff       	jmp    801078dc <alltraps>

801082df <vector107>:
.globl vector107
vector107:
  pushl $0
801082df:	6a 00                	push   $0x0
  pushl $107
801082e1:	6a 6b                	push   $0x6b
  jmp alltraps
801082e3:	e9 f4 f5 ff ff       	jmp    801078dc <alltraps>

801082e8 <vector108>:
.globl vector108
vector108:
  pushl $0
801082e8:	6a 00                	push   $0x0
  pushl $108
801082ea:	6a 6c                	push   $0x6c
  jmp alltraps
801082ec:	e9 eb f5 ff ff       	jmp    801078dc <alltraps>

801082f1 <vector109>:
.globl vector109
vector109:
  pushl $0
801082f1:	6a 00                	push   $0x0
  pushl $109
801082f3:	6a 6d                	push   $0x6d
  jmp alltraps
801082f5:	e9 e2 f5 ff ff       	jmp    801078dc <alltraps>

801082fa <vector110>:
.globl vector110
vector110:
  pushl $0
801082fa:	6a 00                	push   $0x0
  pushl $110
801082fc:	6a 6e                	push   $0x6e
  jmp alltraps
801082fe:	e9 d9 f5 ff ff       	jmp    801078dc <alltraps>

80108303 <vector111>:
.globl vector111
vector111:
  pushl $0
80108303:	6a 00                	push   $0x0
  pushl $111
80108305:	6a 6f                	push   $0x6f
  jmp alltraps
80108307:	e9 d0 f5 ff ff       	jmp    801078dc <alltraps>

8010830c <vector112>:
.globl vector112
vector112:
  pushl $0
8010830c:	6a 00                	push   $0x0
  pushl $112
8010830e:	6a 70                	push   $0x70
  jmp alltraps
80108310:	e9 c7 f5 ff ff       	jmp    801078dc <alltraps>

80108315 <vector113>:
.globl vector113
vector113:
  pushl $0
80108315:	6a 00                	push   $0x0
  pushl $113
80108317:	6a 71                	push   $0x71
  jmp alltraps
80108319:	e9 be f5 ff ff       	jmp    801078dc <alltraps>

8010831e <vector114>:
.globl vector114
vector114:
  pushl $0
8010831e:	6a 00                	push   $0x0
  pushl $114
80108320:	6a 72                	push   $0x72
  jmp alltraps
80108322:	e9 b5 f5 ff ff       	jmp    801078dc <alltraps>

80108327 <vector115>:
.globl vector115
vector115:
  pushl $0
80108327:	6a 00                	push   $0x0
  pushl $115
80108329:	6a 73                	push   $0x73
  jmp alltraps
8010832b:	e9 ac f5 ff ff       	jmp    801078dc <alltraps>

80108330 <vector116>:
.globl vector116
vector116:
  pushl $0
80108330:	6a 00                	push   $0x0
  pushl $116
80108332:	6a 74                	push   $0x74
  jmp alltraps
80108334:	e9 a3 f5 ff ff       	jmp    801078dc <alltraps>

80108339 <vector117>:
.globl vector117
vector117:
  pushl $0
80108339:	6a 00                	push   $0x0
  pushl $117
8010833b:	6a 75                	push   $0x75
  jmp alltraps
8010833d:	e9 9a f5 ff ff       	jmp    801078dc <alltraps>

80108342 <vector118>:
.globl vector118
vector118:
  pushl $0
80108342:	6a 00                	push   $0x0
  pushl $118
80108344:	6a 76                	push   $0x76
  jmp alltraps
80108346:	e9 91 f5 ff ff       	jmp    801078dc <alltraps>

8010834b <vector119>:
.globl vector119
vector119:
  pushl $0
8010834b:	6a 00                	push   $0x0
  pushl $119
8010834d:	6a 77                	push   $0x77
  jmp alltraps
8010834f:	e9 88 f5 ff ff       	jmp    801078dc <alltraps>

80108354 <vector120>:
.globl vector120
vector120:
  pushl $0
80108354:	6a 00                	push   $0x0
  pushl $120
80108356:	6a 78                	push   $0x78
  jmp alltraps
80108358:	e9 7f f5 ff ff       	jmp    801078dc <alltraps>

8010835d <vector121>:
.globl vector121
vector121:
  pushl $0
8010835d:	6a 00                	push   $0x0
  pushl $121
8010835f:	6a 79                	push   $0x79
  jmp alltraps
80108361:	e9 76 f5 ff ff       	jmp    801078dc <alltraps>

80108366 <vector122>:
.globl vector122
vector122:
  pushl $0
80108366:	6a 00                	push   $0x0
  pushl $122
80108368:	6a 7a                	push   $0x7a
  jmp alltraps
8010836a:	e9 6d f5 ff ff       	jmp    801078dc <alltraps>

8010836f <vector123>:
.globl vector123
vector123:
  pushl $0
8010836f:	6a 00                	push   $0x0
  pushl $123
80108371:	6a 7b                	push   $0x7b
  jmp alltraps
80108373:	e9 64 f5 ff ff       	jmp    801078dc <alltraps>

80108378 <vector124>:
.globl vector124
vector124:
  pushl $0
80108378:	6a 00                	push   $0x0
  pushl $124
8010837a:	6a 7c                	push   $0x7c
  jmp alltraps
8010837c:	e9 5b f5 ff ff       	jmp    801078dc <alltraps>

80108381 <vector125>:
.globl vector125
vector125:
  pushl $0
80108381:	6a 00                	push   $0x0
  pushl $125
80108383:	6a 7d                	push   $0x7d
  jmp alltraps
80108385:	e9 52 f5 ff ff       	jmp    801078dc <alltraps>

8010838a <vector126>:
.globl vector126
vector126:
  pushl $0
8010838a:	6a 00                	push   $0x0
  pushl $126
8010838c:	6a 7e                	push   $0x7e
  jmp alltraps
8010838e:	e9 49 f5 ff ff       	jmp    801078dc <alltraps>

80108393 <vector127>:
.globl vector127
vector127:
  pushl $0
80108393:	6a 00                	push   $0x0
  pushl $127
80108395:	6a 7f                	push   $0x7f
  jmp alltraps
80108397:	e9 40 f5 ff ff       	jmp    801078dc <alltraps>

8010839c <vector128>:
.globl vector128
vector128:
  pushl $0
8010839c:	6a 00                	push   $0x0
  pushl $128
8010839e:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801083a3:	e9 34 f5 ff ff       	jmp    801078dc <alltraps>

801083a8 <vector129>:
.globl vector129
vector129:
  pushl $0
801083a8:	6a 00                	push   $0x0
  pushl $129
801083aa:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801083af:	e9 28 f5 ff ff       	jmp    801078dc <alltraps>

801083b4 <vector130>:
.globl vector130
vector130:
  pushl $0
801083b4:	6a 00                	push   $0x0
  pushl $130
801083b6:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801083bb:	e9 1c f5 ff ff       	jmp    801078dc <alltraps>

801083c0 <vector131>:
.globl vector131
vector131:
  pushl $0
801083c0:	6a 00                	push   $0x0
  pushl $131
801083c2:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801083c7:	e9 10 f5 ff ff       	jmp    801078dc <alltraps>

801083cc <vector132>:
.globl vector132
vector132:
  pushl $0
801083cc:	6a 00                	push   $0x0
  pushl $132
801083ce:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801083d3:	e9 04 f5 ff ff       	jmp    801078dc <alltraps>

801083d8 <vector133>:
.globl vector133
vector133:
  pushl $0
801083d8:	6a 00                	push   $0x0
  pushl $133
801083da:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801083df:	e9 f8 f4 ff ff       	jmp    801078dc <alltraps>

801083e4 <vector134>:
.globl vector134
vector134:
  pushl $0
801083e4:	6a 00                	push   $0x0
  pushl $134
801083e6:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801083eb:	e9 ec f4 ff ff       	jmp    801078dc <alltraps>

801083f0 <vector135>:
.globl vector135
vector135:
  pushl $0
801083f0:	6a 00                	push   $0x0
  pushl $135
801083f2:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801083f7:	e9 e0 f4 ff ff       	jmp    801078dc <alltraps>

801083fc <vector136>:
.globl vector136
vector136:
  pushl $0
801083fc:	6a 00                	push   $0x0
  pushl $136
801083fe:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108403:	e9 d4 f4 ff ff       	jmp    801078dc <alltraps>

80108408 <vector137>:
.globl vector137
vector137:
  pushl $0
80108408:	6a 00                	push   $0x0
  pushl $137
8010840a:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010840f:	e9 c8 f4 ff ff       	jmp    801078dc <alltraps>

80108414 <vector138>:
.globl vector138
vector138:
  pushl $0
80108414:	6a 00                	push   $0x0
  pushl $138
80108416:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
8010841b:	e9 bc f4 ff ff       	jmp    801078dc <alltraps>

80108420 <vector139>:
.globl vector139
vector139:
  pushl $0
80108420:	6a 00                	push   $0x0
  pushl $139
80108422:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108427:	e9 b0 f4 ff ff       	jmp    801078dc <alltraps>

8010842c <vector140>:
.globl vector140
vector140:
  pushl $0
8010842c:	6a 00                	push   $0x0
  pushl $140
8010842e:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108433:	e9 a4 f4 ff ff       	jmp    801078dc <alltraps>

80108438 <vector141>:
.globl vector141
vector141:
  pushl $0
80108438:	6a 00                	push   $0x0
  pushl $141
8010843a:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010843f:	e9 98 f4 ff ff       	jmp    801078dc <alltraps>

80108444 <vector142>:
.globl vector142
vector142:
  pushl $0
80108444:	6a 00                	push   $0x0
  pushl $142
80108446:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010844b:	e9 8c f4 ff ff       	jmp    801078dc <alltraps>

80108450 <vector143>:
.globl vector143
vector143:
  pushl $0
80108450:	6a 00                	push   $0x0
  pushl $143
80108452:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108457:	e9 80 f4 ff ff       	jmp    801078dc <alltraps>

8010845c <vector144>:
.globl vector144
vector144:
  pushl $0
8010845c:	6a 00                	push   $0x0
  pushl $144
8010845e:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108463:	e9 74 f4 ff ff       	jmp    801078dc <alltraps>

80108468 <vector145>:
.globl vector145
vector145:
  pushl $0
80108468:	6a 00                	push   $0x0
  pushl $145
8010846a:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010846f:	e9 68 f4 ff ff       	jmp    801078dc <alltraps>

80108474 <vector146>:
.globl vector146
vector146:
  pushl $0
80108474:	6a 00                	push   $0x0
  pushl $146
80108476:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010847b:	e9 5c f4 ff ff       	jmp    801078dc <alltraps>

80108480 <vector147>:
.globl vector147
vector147:
  pushl $0
80108480:	6a 00                	push   $0x0
  pushl $147
80108482:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108487:	e9 50 f4 ff ff       	jmp    801078dc <alltraps>

8010848c <vector148>:
.globl vector148
vector148:
  pushl $0
8010848c:	6a 00                	push   $0x0
  pushl $148
8010848e:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108493:	e9 44 f4 ff ff       	jmp    801078dc <alltraps>

80108498 <vector149>:
.globl vector149
vector149:
  pushl $0
80108498:	6a 00                	push   $0x0
  pushl $149
8010849a:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010849f:	e9 38 f4 ff ff       	jmp    801078dc <alltraps>

801084a4 <vector150>:
.globl vector150
vector150:
  pushl $0
801084a4:	6a 00                	push   $0x0
  pushl $150
801084a6:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801084ab:	e9 2c f4 ff ff       	jmp    801078dc <alltraps>

801084b0 <vector151>:
.globl vector151
vector151:
  pushl $0
801084b0:	6a 00                	push   $0x0
  pushl $151
801084b2:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801084b7:	e9 20 f4 ff ff       	jmp    801078dc <alltraps>

801084bc <vector152>:
.globl vector152
vector152:
  pushl $0
801084bc:	6a 00                	push   $0x0
  pushl $152
801084be:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801084c3:	e9 14 f4 ff ff       	jmp    801078dc <alltraps>

801084c8 <vector153>:
.globl vector153
vector153:
  pushl $0
801084c8:	6a 00                	push   $0x0
  pushl $153
801084ca:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801084cf:	e9 08 f4 ff ff       	jmp    801078dc <alltraps>

801084d4 <vector154>:
.globl vector154
vector154:
  pushl $0
801084d4:	6a 00                	push   $0x0
  pushl $154
801084d6:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801084db:	e9 fc f3 ff ff       	jmp    801078dc <alltraps>

801084e0 <vector155>:
.globl vector155
vector155:
  pushl $0
801084e0:	6a 00                	push   $0x0
  pushl $155
801084e2:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801084e7:	e9 f0 f3 ff ff       	jmp    801078dc <alltraps>

801084ec <vector156>:
.globl vector156
vector156:
  pushl $0
801084ec:	6a 00                	push   $0x0
  pushl $156
801084ee:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801084f3:	e9 e4 f3 ff ff       	jmp    801078dc <alltraps>

801084f8 <vector157>:
.globl vector157
vector157:
  pushl $0
801084f8:	6a 00                	push   $0x0
  pushl $157
801084fa:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801084ff:	e9 d8 f3 ff ff       	jmp    801078dc <alltraps>

80108504 <vector158>:
.globl vector158
vector158:
  pushl $0
80108504:	6a 00                	push   $0x0
  pushl $158
80108506:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010850b:	e9 cc f3 ff ff       	jmp    801078dc <alltraps>

80108510 <vector159>:
.globl vector159
vector159:
  pushl $0
80108510:	6a 00                	push   $0x0
  pushl $159
80108512:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108517:	e9 c0 f3 ff ff       	jmp    801078dc <alltraps>

8010851c <vector160>:
.globl vector160
vector160:
  pushl $0
8010851c:	6a 00                	push   $0x0
  pushl $160
8010851e:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108523:	e9 b4 f3 ff ff       	jmp    801078dc <alltraps>

80108528 <vector161>:
.globl vector161
vector161:
  pushl $0
80108528:	6a 00                	push   $0x0
  pushl $161
8010852a:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010852f:	e9 a8 f3 ff ff       	jmp    801078dc <alltraps>

80108534 <vector162>:
.globl vector162
vector162:
  pushl $0
80108534:	6a 00                	push   $0x0
  pushl $162
80108536:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010853b:	e9 9c f3 ff ff       	jmp    801078dc <alltraps>

80108540 <vector163>:
.globl vector163
vector163:
  pushl $0
80108540:	6a 00                	push   $0x0
  pushl $163
80108542:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108547:	e9 90 f3 ff ff       	jmp    801078dc <alltraps>

8010854c <vector164>:
.globl vector164
vector164:
  pushl $0
8010854c:	6a 00                	push   $0x0
  pushl $164
8010854e:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108553:	e9 84 f3 ff ff       	jmp    801078dc <alltraps>

80108558 <vector165>:
.globl vector165
vector165:
  pushl $0
80108558:	6a 00                	push   $0x0
  pushl $165
8010855a:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010855f:	e9 78 f3 ff ff       	jmp    801078dc <alltraps>

80108564 <vector166>:
.globl vector166
vector166:
  pushl $0
80108564:	6a 00                	push   $0x0
  pushl $166
80108566:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010856b:	e9 6c f3 ff ff       	jmp    801078dc <alltraps>

80108570 <vector167>:
.globl vector167
vector167:
  pushl $0
80108570:	6a 00                	push   $0x0
  pushl $167
80108572:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108577:	e9 60 f3 ff ff       	jmp    801078dc <alltraps>

8010857c <vector168>:
.globl vector168
vector168:
  pushl $0
8010857c:	6a 00                	push   $0x0
  pushl $168
8010857e:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108583:	e9 54 f3 ff ff       	jmp    801078dc <alltraps>

80108588 <vector169>:
.globl vector169
vector169:
  pushl $0
80108588:	6a 00                	push   $0x0
  pushl $169
8010858a:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010858f:	e9 48 f3 ff ff       	jmp    801078dc <alltraps>

80108594 <vector170>:
.globl vector170
vector170:
  pushl $0
80108594:	6a 00                	push   $0x0
  pushl $170
80108596:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010859b:	e9 3c f3 ff ff       	jmp    801078dc <alltraps>

801085a0 <vector171>:
.globl vector171
vector171:
  pushl $0
801085a0:	6a 00                	push   $0x0
  pushl $171
801085a2:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801085a7:	e9 30 f3 ff ff       	jmp    801078dc <alltraps>

801085ac <vector172>:
.globl vector172
vector172:
  pushl $0
801085ac:	6a 00                	push   $0x0
  pushl $172
801085ae:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801085b3:	e9 24 f3 ff ff       	jmp    801078dc <alltraps>

801085b8 <vector173>:
.globl vector173
vector173:
  pushl $0
801085b8:	6a 00                	push   $0x0
  pushl $173
801085ba:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801085bf:	e9 18 f3 ff ff       	jmp    801078dc <alltraps>

801085c4 <vector174>:
.globl vector174
vector174:
  pushl $0
801085c4:	6a 00                	push   $0x0
  pushl $174
801085c6:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801085cb:	e9 0c f3 ff ff       	jmp    801078dc <alltraps>

801085d0 <vector175>:
.globl vector175
vector175:
  pushl $0
801085d0:	6a 00                	push   $0x0
  pushl $175
801085d2:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801085d7:	e9 00 f3 ff ff       	jmp    801078dc <alltraps>

801085dc <vector176>:
.globl vector176
vector176:
  pushl $0
801085dc:	6a 00                	push   $0x0
  pushl $176
801085de:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801085e3:	e9 f4 f2 ff ff       	jmp    801078dc <alltraps>

801085e8 <vector177>:
.globl vector177
vector177:
  pushl $0
801085e8:	6a 00                	push   $0x0
  pushl $177
801085ea:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801085ef:	e9 e8 f2 ff ff       	jmp    801078dc <alltraps>

801085f4 <vector178>:
.globl vector178
vector178:
  pushl $0
801085f4:	6a 00                	push   $0x0
  pushl $178
801085f6:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801085fb:	e9 dc f2 ff ff       	jmp    801078dc <alltraps>

80108600 <vector179>:
.globl vector179
vector179:
  pushl $0
80108600:	6a 00                	push   $0x0
  pushl $179
80108602:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108607:	e9 d0 f2 ff ff       	jmp    801078dc <alltraps>

8010860c <vector180>:
.globl vector180
vector180:
  pushl $0
8010860c:	6a 00                	push   $0x0
  pushl $180
8010860e:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108613:	e9 c4 f2 ff ff       	jmp    801078dc <alltraps>

80108618 <vector181>:
.globl vector181
vector181:
  pushl $0
80108618:	6a 00                	push   $0x0
  pushl $181
8010861a:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010861f:	e9 b8 f2 ff ff       	jmp    801078dc <alltraps>

80108624 <vector182>:
.globl vector182
vector182:
  pushl $0
80108624:	6a 00                	push   $0x0
  pushl $182
80108626:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010862b:	e9 ac f2 ff ff       	jmp    801078dc <alltraps>

80108630 <vector183>:
.globl vector183
vector183:
  pushl $0
80108630:	6a 00                	push   $0x0
  pushl $183
80108632:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108637:	e9 a0 f2 ff ff       	jmp    801078dc <alltraps>

8010863c <vector184>:
.globl vector184
vector184:
  pushl $0
8010863c:	6a 00                	push   $0x0
  pushl $184
8010863e:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108643:	e9 94 f2 ff ff       	jmp    801078dc <alltraps>

80108648 <vector185>:
.globl vector185
vector185:
  pushl $0
80108648:	6a 00                	push   $0x0
  pushl $185
8010864a:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010864f:	e9 88 f2 ff ff       	jmp    801078dc <alltraps>

80108654 <vector186>:
.globl vector186
vector186:
  pushl $0
80108654:	6a 00                	push   $0x0
  pushl $186
80108656:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010865b:	e9 7c f2 ff ff       	jmp    801078dc <alltraps>

80108660 <vector187>:
.globl vector187
vector187:
  pushl $0
80108660:	6a 00                	push   $0x0
  pushl $187
80108662:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108667:	e9 70 f2 ff ff       	jmp    801078dc <alltraps>

8010866c <vector188>:
.globl vector188
vector188:
  pushl $0
8010866c:	6a 00                	push   $0x0
  pushl $188
8010866e:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108673:	e9 64 f2 ff ff       	jmp    801078dc <alltraps>

80108678 <vector189>:
.globl vector189
vector189:
  pushl $0
80108678:	6a 00                	push   $0x0
  pushl $189
8010867a:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010867f:	e9 58 f2 ff ff       	jmp    801078dc <alltraps>

80108684 <vector190>:
.globl vector190
vector190:
  pushl $0
80108684:	6a 00                	push   $0x0
  pushl $190
80108686:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010868b:	e9 4c f2 ff ff       	jmp    801078dc <alltraps>

80108690 <vector191>:
.globl vector191
vector191:
  pushl $0
80108690:	6a 00                	push   $0x0
  pushl $191
80108692:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108697:	e9 40 f2 ff ff       	jmp    801078dc <alltraps>

8010869c <vector192>:
.globl vector192
vector192:
  pushl $0
8010869c:	6a 00                	push   $0x0
  pushl $192
8010869e:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801086a3:	e9 34 f2 ff ff       	jmp    801078dc <alltraps>

801086a8 <vector193>:
.globl vector193
vector193:
  pushl $0
801086a8:	6a 00                	push   $0x0
  pushl $193
801086aa:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801086af:	e9 28 f2 ff ff       	jmp    801078dc <alltraps>

801086b4 <vector194>:
.globl vector194
vector194:
  pushl $0
801086b4:	6a 00                	push   $0x0
  pushl $194
801086b6:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801086bb:	e9 1c f2 ff ff       	jmp    801078dc <alltraps>

801086c0 <vector195>:
.globl vector195
vector195:
  pushl $0
801086c0:	6a 00                	push   $0x0
  pushl $195
801086c2:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801086c7:	e9 10 f2 ff ff       	jmp    801078dc <alltraps>

801086cc <vector196>:
.globl vector196
vector196:
  pushl $0
801086cc:	6a 00                	push   $0x0
  pushl $196
801086ce:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801086d3:	e9 04 f2 ff ff       	jmp    801078dc <alltraps>

801086d8 <vector197>:
.globl vector197
vector197:
  pushl $0
801086d8:	6a 00                	push   $0x0
  pushl $197
801086da:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801086df:	e9 f8 f1 ff ff       	jmp    801078dc <alltraps>

801086e4 <vector198>:
.globl vector198
vector198:
  pushl $0
801086e4:	6a 00                	push   $0x0
  pushl $198
801086e6:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801086eb:	e9 ec f1 ff ff       	jmp    801078dc <alltraps>

801086f0 <vector199>:
.globl vector199
vector199:
  pushl $0
801086f0:	6a 00                	push   $0x0
  pushl $199
801086f2:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801086f7:	e9 e0 f1 ff ff       	jmp    801078dc <alltraps>

801086fc <vector200>:
.globl vector200
vector200:
  pushl $0
801086fc:	6a 00                	push   $0x0
  pushl $200
801086fe:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108703:	e9 d4 f1 ff ff       	jmp    801078dc <alltraps>

80108708 <vector201>:
.globl vector201
vector201:
  pushl $0
80108708:	6a 00                	push   $0x0
  pushl $201
8010870a:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010870f:	e9 c8 f1 ff ff       	jmp    801078dc <alltraps>

80108714 <vector202>:
.globl vector202
vector202:
  pushl $0
80108714:	6a 00                	push   $0x0
  pushl $202
80108716:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010871b:	e9 bc f1 ff ff       	jmp    801078dc <alltraps>

80108720 <vector203>:
.globl vector203
vector203:
  pushl $0
80108720:	6a 00                	push   $0x0
  pushl $203
80108722:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108727:	e9 b0 f1 ff ff       	jmp    801078dc <alltraps>

8010872c <vector204>:
.globl vector204
vector204:
  pushl $0
8010872c:	6a 00                	push   $0x0
  pushl $204
8010872e:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108733:	e9 a4 f1 ff ff       	jmp    801078dc <alltraps>

80108738 <vector205>:
.globl vector205
vector205:
  pushl $0
80108738:	6a 00                	push   $0x0
  pushl $205
8010873a:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010873f:	e9 98 f1 ff ff       	jmp    801078dc <alltraps>

80108744 <vector206>:
.globl vector206
vector206:
  pushl $0
80108744:	6a 00                	push   $0x0
  pushl $206
80108746:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010874b:	e9 8c f1 ff ff       	jmp    801078dc <alltraps>

80108750 <vector207>:
.globl vector207
vector207:
  pushl $0
80108750:	6a 00                	push   $0x0
  pushl $207
80108752:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80108757:	e9 80 f1 ff ff       	jmp    801078dc <alltraps>

8010875c <vector208>:
.globl vector208
vector208:
  pushl $0
8010875c:	6a 00                	push   $0x0
  pushl $208
8010875e:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80108763:	e9 74 f1 ff ff       	jmp    801078dc <alltraps>

80108768 <vector209>:
.globl vector209
vector209:
  pushl $0
80108768:	6a 00                	push   $0x0
  pushl $209
8010876a:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010876f:	e9 68 f1 ff ff       	jmp    801078dc <alltraps>

80108774 <vector210>:
.globl vector210
vector210:
  pushl $0
80108774:	6a 00                	push   $0x0
  pushl $210
80108776:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010877b:	e9 5c f1 ff ff       	jmp    801078dc <alltraps>

80108780 <vector211>:
.globl vector211
vector211:
  pushl $0
80108780:	6a 00                	push   $0x0
  pushl $211
80108782:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80108787:	e9 50 f1 ff ff       	jmp    801078dc <alltraps>

8010878c <vector212>:
.globl vector212
vector212:
  pushl $0
8010878c:	6a 00                	push   $0x0
  pushl $212
8010878e:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80108793:	e9 44 f1 ff ff       	jmp    801078dc <alltraps>

80108798 <vector213>:
.globl vector213
vector213:
  pushl $0
80108798:	6a 00                	push   $0x0
  pushl $213
8010879a:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010879f:	e9 38 f1 ff ff       	jmp    801078dc <alltraps>

801087a4 <vector214>:
.globl vector214
vector214:
  pushl $0
801087a4:	6a 00                	push   $0x0
  pushl $214
801087a6:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801087ab:	e9 2c f1 ff ff       	jmp    801078dc <alltraps>

801087b0 <vector215>:
.globl vector215
vector215:
  pushl $0
801087b0:	6a 00                	push   $0x0
  pushl $215
801087b2:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801087b7:	e9 20 f1 ff ff       	jmp    801078dc <alltraps>

801087bc <vector216>:
.globl vector216
vector216:
  pushl $0
801087bc:	6a 00                	push   $0x0
  pushl $216
801087be:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801087c3:	e9 14 f1 ff ff       	jmp    801078dc <alltraps>

801087c8 <vector217>:
.globl vector217
vector217:
  pushl $0
801087c8:	6a 00                	push   $0x0
  pushl $217
801087ca:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801087cf:	e9 08 f1 ff ff       	jmp    801078dc <alltraps>

801087d4 <vector218>:
.globl vector218
vector218:
  pushl $0
801087d4:	6a 00                	push   $0x0
  pushl $218
801087d6:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801087db:	e9 fc f0 ff ff       	jmp    801078dc <alltraps>

801087e0 <vector219>:
.globl vector219
vector219:
  pushl $0
801087e0:	6a 00                	push   $0x0
  pushl $219
801087e2:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801087e7:	e9 f0 f0 ff ff       	jmp    801078dc <alltraps>

801087ec <vector220>:
.globl vector220
vector220:
  pushl $0
801087ec:	6a 00                	push   $0x0
  pushl $220
801087ee:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801087f3:	e9 e4 f0 ff ff       	jmp    801078dc <alltraps>

801087f8 <vector221>:
.globl vector221
vector221:
  pushl $0
801087f8:	6a 00                	push   $0x0
  pushl $221
801087fa:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801087ff:	e9 d8 f0 ff ff       	jmp    801078dc <alltraps>

80108804 <vector222>:
.globl vector222
vector222:
  pushl $0
80108804:	6a 00                	push   $0x0
  pushl $222
80108806:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010880b:	e9 cc f0 ff ff       	jmp    801078dc <alltraps>

80108810 <vector223>:
.globl vector223
vector223:
  pushl $0
80108810:	6a 00                	push   $0x0
  pushl $223
80108812:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80108817:	e9 c0 f0 ff ff       	jmp    801078dc <alltraps>

8010881c <vector224>:
.globl vector224
vector224:
  pushl $0
8010881c:	6a 00                	push   $0x0
  pushl $224
8010881e:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80108823:	e9 b4 f0 ff ff       	jmp    801078dc <alltraps>

80108828 <vector225>:
.globl vector225
vector225:
  pushl $0
80108828:	6a 00                	push   $0x0
  pushl $225
8010882a:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010882f:	e9 a8 f0 ff ff       	jmp    801078dc <alltraps>

80108834 <vector226>:
.globl vector226
vector226:
  pushl $0
80108834:	6a 00                	push   $0x0
  pushl $226
80108836:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010883b:	e9 9c f0 ff ff       	jmp    801078dc <alltraps>

80108840 <vector227>:
.globl vector227
vector227:
  pushl $0
80108840:	6a 00                	push   $0x0
  pushl $227
80108842:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80108847:	e9 90 f0 ff ff       	jmp    801078dc <alltraps>

8010884c <vector228>:
.globl vector228
vector228:
  pushl $0
8010884c:	6a 00                	push   $0x0
  pushl $228
8010884e:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80108853:	e9 84 f0 ff ff       	jmp    801078dc <alltraps>

80108858 <vector229>:
.globl vector229
vector229:
  pushl $0
80108858:	6a 00                	push   $0x0
  pushl $229
8010885a:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010885f:	e9 78 f0 ff ff       	jmp    801078dc <alltraps>

80108864 <vector230>:
.globl vector230
vector230:
  pushl $0
80108864:	6a 00                	push   $0x0
  pushl $230
80108866:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010886b:	e9 6c f0 ff ff       	jmp    801078dc <alltraps>

80108870 <vector231>:
.globl vector231
vector231:
  pushl $0
80108870:	6a 00                	push   $0x0
  pushl $231
80108872:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80108877:	e9 60 f0 ff ff       	jmp    801078dc <alltraps>

8010887c <vector232>:
.globl vector232
vector232:
  pushl $0
8010887c:	6a 00                	push   $0x0
  pushl $232
8010887e:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80108883:	e9 54 f0 ff ff       	jmp    801078dc <alltraps>

80108888 <vector233>:
.globl vector233
vector233:
  pushl $0
80108888:	6a 00                	push   $0x0
  pushl $233
8010888a:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010888f:	e9 48 f0 ff ff       	jmp    801078dc <alltraps>

80108894 <vector234>:
.globl vector234
vector234:
  pushl $0
80108894:	6a 00                	push   $0x0
  pushl $234
80108896:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010889b:	e9 3c f0 ff ff       	jmp    801078dc <alltraps>

801088a0 <vector235>:
.globl vector235
vector235:
  pushl $0
801088a0:	6a 00                	push   $0x0
  pushl $235
801088a2:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801088a7:	e9 30 f0 ff ff       	jmp    801078dc <alltraps>

801088ac <vector236>:
.globl vector236
vector236:
  pushl $0
801088ac:	6a 00                	push   $0x0
  pushl $236
801088ae:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801088b3:	e9 24 f0 ff ff       	jmp    801078dc <alltraps>

801088b8 <vector237>:
.globl vector237
vector237:
  pushl $0
801088b8:	6a 00                	push   $0x0
  pushl $237
801088ba:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801088bf:	e9 18 f0 ff ff       	jmp    801078dc <alltraps>

801088c4 <vector238>:
.globl vector238
vector238:
  pushl $0
801088c4:	6a 00                	push   $0x0
  pushl $238
801088c6:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801088cb:	e9 0c f0 ff ff       	jmp    801078dc <alltraps>

801088d0 <vector239>:
.globl vector239
vector239:
  pushl $0
801088d0:	6a 00                	push   $0x0
  pushl $239
801088d2:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801088d7:	e9 00 f0 ff ff       	jmp    801078dc <alltraps>

801088dc <vector240>:
.globl vector240
vector240:
  pushl $0
801088dc:	6a 00                	push   $0x0
  pushl $240
801088de:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801088e3:	e9 f4 ef ff ff       	jmp    801078dc <alltraps>

801088e8 <vector241>:
.globl vector241
vector241:
  pushl $0
801088e8:	6a 00                	push   $0x0
  pushl $241
801088ea:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801088ef:	e9 e8 ef ff ff       	jmp    801078dc <alltraps>

801088f4 <vector242>:
.globl vector242
vector242:
  pushl $0
801088f4:	6a 00                	push   $0x0
  pushl $242
801088f6:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801088fb:	e9 dc ef ff ff       	jmp    801078dc <alltraps>

80108900 <vector243>:
.globl vector243
vector243:
  pushl $0
80108900:	6a 00                	push   $0x0
  pushl $243
80108902:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80108907:	e9 d0 ef ff ff       	jmp    801078dc <alltraps>

8010890c <vector244>:
.globl vector244
vector244:
  pushl $0
8010890c:	6a 00                	push   $0x0
  pushl $244
8010890e:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80108913:	e9 c4 ef ff ff       	jmp    801078dc <alltraps>

80108918 <vector245>:
.globl vector245
vector245:
  pushl $0
80108918:	6a 00                	push   $0x0
  pushl $245
8010891a:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010891f:	e9 b8 ef ff ff       	jmp    801078dc <alltraps>

80108924 <vector246>:
.globl vector246
vector246:
  pushl $0
80108924:	6a 00                	push   $0x0
  pushl $246
80108926:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010892b:	e9 ac ef ff ff       	jmp    801078dc <alltraps>

80108930 <vector247>:
.globl vector247
vector247:
  pushl $0
80108930:	6a 00                	push   $0x0
  pushl $247
80108932:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80108937:	e9 a0 ef ff ff       	jmp    801078dc <alltraps>

8010893c <vector248>:
.globl vector248
vector248:
  pushl $0
8010893c:	6a 00                	push   $0x0
  pushl $248
8010893e:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80108943:	e9 94 ef ff ff       	jmp    801078dc <alltraps>

80108948 <vector249>:
.globl vector249
vector249:
  pushl $0
80108948:	6a 00                	push   $0x0
  pushl $249
8010894a:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010894f:	e9 88 ef ff ff       	jmp    801078dc <alltraps>

80108954 <vector250>:
.globl vector250
vector250:
  pushl $0
80108954:	6a 00                	push   $0x0
  pushl $250
80108956:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010895b:	e9 7c ef ff ff       	jmp    801078dc <alltraps>

80108960 <vector251>:
.globl vector251
vector251:
  pushl $0
80108960:	6a 00                	push   $0x0
  pushl $251
80108962:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80108967:	e9 70 ef ff ff       	jmp    801078dc <alltraps>

8010896c <vector252>:
.globl vector252
vector252:
  pushl $0
8010896c:	6a 00                	push   $0x0
  pushl $252
8010896e:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80108973:	e9 64 ef ff ff       	jmp    801078dc <alltraps>

80108978 <vector253>:
.globl vector253
vector253:
  pushl $0
80108978:	6a 00                	push   $0x0
  pushl $253
8010897a:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010897f:	e9 58 ef ff ff       	jmp    801078dc <alltraps>

80108984 <vector254>:
.globl vector254
vector254:
  pushl $0
80108984:	6a 00                	push   $0x0
  pushl $254
80108986:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010898b:	e9 4c ef ff ff       	jmp    801078dc <alltraps>

80108990 <vector255>:
.globl vector255
vector255:
  pushl $0
80108990:	6a 00                	push   $0x0
  pushl $255
80108992:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80108997:	e9 40 ef ff ff       	jmp    801078dc <alltraps>

8010899c <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
8010899c:	55                   	push   %ebp
8010899d:	89 e5                	mov    %esp,%ebp
8010899f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801089a2:	8b 45 0c             	mov    0xc(%ebp),%eax
801089a5:	83 e8 01             	sub    $0x1,%eax
801089a8:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801089ac:	8b 45 08             	mov    0x8(%ebp),%eax
801089af:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801089b3:	8b 45 08             	mov    0x8(%ebp),%eax
801089b6:	c1 e8 10             	shr    $0x10,%eax
801089b9:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801089bd:	8d 45 fa             	lea    -0x6(%ebp),%eax
801089c0:	0f 01 10             	lgdtl  (%eax)
}
801089c3:	90                   	nop
801089c4:	c9                   	leave  
801089c5:	c3                   	ret    

801089c6 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801089c6:	55                   	push   %ebp
801089c7:	89 e5                	mov    %esp,%ebp
801089c9:	83 ec 04             	sub    $0x4,%esp
801089cc:	8b 45 08             	mov    0x8(%ebp),%eax
801089cf:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801089d3:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801089d7:	0f 00 d8             	ltr    %ax
}
801089da:	90                   	nop
801089db:	c9                   	leave  
801089dc:	c3                   	ret    

801089dd <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801089dd:	55                   	push   %ebp
801089de:	89 e5                	mov    %esp,%ebp
801089e0:	83 ec 04             	sub    $0x4,%esp
801089e3:	8b 45 08             	mov    0x8(%ebp),%eax
801089e6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801089ea:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801089ee:	8e e8                	mov    %eax,%gs
}
801089f0:	90                   	nop
801089f1:	c9                   	leave  
801089f2:	c3                   	ret    

801089f3 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801089f3:	55                   	push   %ebp
801089f4:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801089f6:	8b 45 08             	mov    0x8(%ebp),%eax
801089f9:	0f 22 d8             	mov    %eax,%cr3
}
801089fc:	90                   	nop
801089fd:	5d                   	pop    %ebp
801089fe:	c3                   	ret    

801089ff <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801089ff:	55                   	push   %ebp
80108a00:	89 e5                	mov    %esp,%ebp
80108a02:	8b 45 08             	mov    0x8(%ebp),%eax
80108a05:	05 00 00 00 80       	add    $0x80000000,%eax
80108a0a:	5d                   	pop    %ebp
80108a0b:	c3                   	ret    

80108a0c <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80108a0c:	55                   	push   %ebp
80108a0d:	89 e5                	mov    %esp,%ebp
80108a0f:	8b 45 08             	mov    0x8(%ebp),%eax
80108a12:	05 00 00 00 80       	add    $0x80000000,%eax
80108a17:	5d                   	pop    %ebp
80108a18:	c3                   	ret    

80108a19 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80108a19:	55                   	push   %ebp
80108a1a:	89 e5                	mov    %esp,%ebp
80108a1c:	53                   	push   %ebx
80108a1d:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80108a20:	e8 58 a6 ff ff       	call   8010307d <cpunum>
80108a25:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80108a2b:	05 80 43 11 80       	add    $0x80114380,%eax
80108a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80108a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a36:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80108a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a3f:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80108a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a48:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80108a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a4f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108a53:	83 e2 f0             	and    $0xfffffff0,%edx
80108a56:	83 ca 0a             	or     $0xa,%edx
80108a59:	88 50 7d             	mov    %dl,0x7d(%eax)
80108a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a5f:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108a63:	83 ca 10             	or     $0x10,%edx
80108a66:	88 50 7d             	mov    %dl,0x7d(%eax)
80108a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a6c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108a70:	83 e2 9f             	and    $0xffffff9f,%edx
80108a73:	88 50 7d             	mov    %dl,0x7d(%eax)
80108a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a79:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80108a7d:	83 ca 80             	or     $0xffffff80,%edx
80108a80:	88 50 7d             	mov    %dl,0x7d(%eax)
80108a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a86:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108a8a:	83 ca 0f             	or     $0xf,%edx
80108a8d:	88 50 7e             	mov    %dl,0x7e(%eax)
80108a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a93:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108a97:	83 e2 ef             	and    $0xffffffef,%edx
80108a9a:	88 50 7e             	mov    %dl,0x7e(%eax)
80108a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aa0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108aa4:	83 e2 df             	and    $0xffffffdf,%edx
80108aa7:	88 50 7e             	mov    %dl,0x7e(%eax)
80108aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aad:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108ab1:	83 ca 40             	or     $0x40,%edx
80108ab4:	88 50 7e             	mov    %dl,0x7e(%eax)
80108ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aba:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80108abe:	83 ca 80             	or     $0xffffff80,%edx
80108ac1:	88 50 7e             	mov    %dl,0x7e(%eax)
80108ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ac7:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80108acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ace:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80108ad5:	ff ff 
80108ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ada:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108ae1:	00 00 
80108ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ae6:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108af0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108af7:	83 e2 f0             	and    $0xfffffff0,%edx
80108afa:	83 ca 02             	or     $0x2,%edx
80108afd:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b06:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108b0d:	83 ca 10             	or     $0x10,%edx
80108b10:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b19:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108b20:	83 e2 9f             	and    $0xffffff9f,%edx
80108b23:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b2c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108b33:	83 ca 80             	or     $0xffffff80,%edx
80108b36:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b3f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108b46:	83 ca 0f             	or     $0xf,%edx
80108b49:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b52:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108b59:	83 e2 ef             	and    $0xffffffef,%edx
80108b5c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b65:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108b6c:	83 e2 df             	and    $0xffffffdf,%edx
80108b6f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108b75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b78:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108b7f:	83 ca 40             	or     $0x40,%edx
80108b82:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b8b:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108b92:	83 ca 80             	or     $0xffffff80,%edx
80108b95:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b9e:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80108ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ba8:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80108baf:	ff ff 
80108bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bb4:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80108bbb:	00 00 
80108bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bc0:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80108bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bca:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108bd1:	83 e2 f0             	and    $0xfffffff0,%edx
80108bd4:	83 ca 0a             	or     $0xa,%edx
80108bd7:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108be0:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108be7:	83 ca 10             	or     $0x10,%edx
80108bea:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108bf3:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108bfa:	83 ca 60             	or     $0x60,%edx
80108bfd:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c06:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108c0d:	83 ca 80             	or     $0xffffff80,%edx
80108c10:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c19:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108c20:	83 ca 0f             	or     $0xf,%edx
80108c23:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c2c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108c33:	83 e2 ef             	and    $0xffffffef,%edx
80108c36:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c3f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108c46:	83 e2 df             	and    $0xffffffdf,%edx
80108c49:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c52:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108c59:	83 ca 40             	or     $0x40,%edx
80108c5c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c65:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108c6c:	83 ca 80             	or     $0xffffff80,%edx
80108c6f:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c78:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80108c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c82:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80108c89:	ff ff 
80108c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c8e:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80108c95:	00 00 
80108c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c9a:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80108ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ca4:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108cab:	83 e2 f0             	and    $0xfffffff0,%edx
80108cae:	83 ca 02             	or     $0x2,%edx
80108cb1:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cba:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108cc1:	83 ca 10             	or     $0x10,%edx
80108cc4:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ccd:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108cd4:	83 ca 60             	or     $0x60,%edx
80108cd7:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ce0:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80108ce7:	83 ca 80             	or     $0xffffff80,%edx
80108cea:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108cf3:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108cfa:	83 ca 0f             	or     $0xf,%edx
80108cfd:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d06:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108d0d:	83 e2 ef             	and    $0xffffffef,%edx
80108d10:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d19:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108d20:	83 e2 df             	and    $0xffffffdf,%edx
80108d23:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d2c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108d33:	83 ca 40             	or     $0x40,%edx
80108d36:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108d3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d3f:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108d46:	83 ca 80             	or     $0xffffff80,%edx
80108d49:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d52:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d5c:	05 b4 00 00 00       	add    $0xb4,%eax
80108d61:	89 c3                	mov    %eax,%ebx
80108d63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d66:	05 b4 00 00 00       	add    $0xb4,%eax
80108d6b:	c1 e8 10             	shr    $0x10,%eax
80108d6e:	89 c2                	mov    %eax,%edx
80108d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d73:	05 b4 00 00 00       	add    $0xb4,%eax
80108d78:	c1 e8 18             	shr    $0x18,%eax
80108d7b:	89 c1                	mov    %eax,%ecx
80108d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d80:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80108d87:	00 00 
80108d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d8c:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80108d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d96:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80108d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d9f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108da6:	83 e2 f0             	and    $0xfffffff0,%edx
80108da9:	83 ca 02             	or     $0x2,%edx
80108dac:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108db5:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108dbc:	83 ca 10             	or     $0x10,%edx
80108dbf:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dc8:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108dcf:	83 e2 9f             	and    $0xffffff9f,%edx
80108dd2:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ddb:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80108de2:	83 ca 80             	or     $0xffffff80,%edx
80108de5:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80108deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108dee:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108df5:	83 e2 f0             	and    $0xfffffff0,%edx
80108df8:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e01:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108e08:	83 e2 ef             	and    $0xffffffef,%edx
80108e0b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e14:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108e1b:	83 e2 df             	and    $0xffffffdf,%edx
80108e1e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e27:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108e2e:	83 ca 40             	or     $0x40,%edx
80108e31:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e3a:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80108e41:	83 ca 80             	or     $0xffffff80,%edx
80108e44:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80108e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e4d:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80108e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e56:	83 c0 70             	add    $0x70,%eax
80108e59:	83 ec 08             	sub    $0x8,%esp
80108e5c:	6a 38                	push   $0x38
80108e5e:	50                   	push   %eax
80108e5f:	e8 38 fb ff ff       	call   8010899c <lgdt>
80108e64:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80108e67:	83 ec 0c             	sub    $0xc,%esp
80108e6a:	6a 18                	push   $0x18
80108e6c:	e8 6c fb ff ff       	call   801089dd <loadgs>
80108e71:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80108e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108e77:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80108e7d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80108e84:	00 00 00 00 
}
80108e88:	90                   	nop
80108e89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108e8c:	c9                   	leave  
80108e8d:	c3                   	ret    

80108e8e <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80108e8e:	55                   	push   %ebp
80108e8f:	89 e5                	mov    %esp,%ebp
80108e91:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80108e94:	8b 45 0c             	mov    0xc(%ebp),%eax
80108e97:	c1 e8 16             	shr    $0x16,%eax
80108e9a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80108ea4:	01 d0                	add    %edx,%eax
80108ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80108ea9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108eac:	8b 00                	mov    (%eax),%eax
80108eae:	83 e0 01             	and    $0x1,%eax
80108eb1:	85 c0                	test   %eax,%eax
80108eb3:	74 18                	je     80108ecd <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80108eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108eb8:	8b 00                	mov    (%eax),%eax
80108eba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ebf:	50                   	push   %eax
80108ec0:	e8 47 fb ff ff       	call   80108a0c <p2v>
80108ec5:	83 c4 04             	add    $0x4,%esp
80108ec8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108ecb:	eb 48                	jmp    80108f15 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80108ecd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80108ed1:	74 0e                	je     80108ee1 <walkpgdir+0x53>
80108ed3:	e8 3f 9e ff ff       	call   80102d17 <kalloc>
80108ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108edb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108edf:	75 07                	jne    80108ee8 <walkpgdir+0x5a>
      return 0;
80108ee1:	b8 00 00 00 00       	mov    $0x0,%eax
80108ee6:	eb 44                	jmp    80108f2c <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108ee8:	83 ec 04             	sub    $0x4,%esp
80108eeb:	68 00 10 00 00       	push   $0x1000
80108ef0:	6a 00                	push   $0x0
80108ef2:	ff 75 f4             	pushl  -0xc(%ebp)
80108ef5:	e8 a6 d4 ff ff       	call   801063a0 <memset>
80108efa:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80108efd:	83 ec 0c             	sub    $0xc,%esp
80108f00:	ff 75 f4             	pushl  -0xc(%ebp)
80108f03:	e8 f7 fa ff ff       	call   801089ff <v2p>
80108f08:	83 c4 10             	add    $0x10,%esp
80108f0b:	83 c8 07             	or     $0x7,%eax
80108f0e:	89 c2                	mov    %eax,%edx
80108f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108f13:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108f15:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f18:	c1 e8 0c             	shr    $0xc,%eax
80108f1b:	25 ff 03 00 00       	and    $0x3ff,%eax
80108f20:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108f2a:	01 d0                	add    %edx,%eax
}
80108f2c:	c9                   	leave  
80108f2d:	c3                   	ret    

80108f2e <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108f2e:	55                   	push   %ebp
80108f2f:	89 e5                	mov    %esp,%ebp
80108f31:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80108f34:	8b 45 0c             	mov    0xc(%ebp),%eax
80108f37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108f3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80108f3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80108f42:	8b 45 10             	mov    0x10(%ebp),%eax
80108f45:	01 d0                	add    %edx,%eax
80108f47:	83 e8 01             	sub    $0x1,%eax
80108f4a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80108f52:	83 ec 04             	sub    $0x4,%esp
80108f55:	6a 01                	push   $0x1
80108f57:	ff 75 f4             	pushl  -0xc(%ebp)
80108f5a:	ff 75 08             	pushl  0x8(%ebp)
80108f5d:	e8 2c ff ff ff       	call   80108e8e <walkpgdir>
80108f62:	83 c4 10             	add    $0x10,%esp
80108f65:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108f68:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108f6c:	75 07                	jne    80108f75 <mappages+0x47>
      return -1;
80108f6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108f73:	eb 47                	jmp    80108fbc <mappages+0x8e>
    if(*pte & PTE_P)
80108f75:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f78:	8b 00                	mov    (%eax),%eax
80108f7a:	83 e0 01             	and    $0x1,%eax
80108f7d:	85 c0                	test   %eax,%eax
80108f7f:	74 0d                	je     80108f8e <mappages+0x60>
      panic("remap");
80108f81:	83 ec 0c             	sub    $0xc,%esp
80108f84:	68 30 a4 10 80       	push   $0x8010a430
80108f89:	e8 d8 75 ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80108f8e:	8b 45 18             	mov    0x18(%ebp),%eax
80108f91:	0b 45 14             	or     0x14(%ebp),%eax
80108f94:	83 c8 01             	or     $0x1,%eax
80108f97:	89 c2                	mov    %eax,%edx
80108f99:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108f9c:	89 10                	mov    %edx,(%eax)
    if(a == last)
80108f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108fa1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108fa4:	74 10                	je     80108fb6 <mappages+0x88>
      break;
    a += PGSIZE;
80108fa6:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80108fad:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80108fb4:	eb 9c                	jmp    80108f52 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80108fb6:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80108fb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108fbc:	c9                   	leave  
80108fbd:	c3                   	ret    

80108fbe <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80108fbe:	55                   	push   %ebp
80108fbf:	89 e5                	mov    %esp,%ebp
80108fc1:	53                   	push   %ebx
80108fc2:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80108fc5:	e8 4d 9d ff ff       	call   80102d17 <kalloc>
80108fca:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108fcd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108fd1:	75 0a                	jne    80108fdd <setupkvm+0x1f>
    return 0;
80108fd3:	b8 00 00 00 00       	mov    $0x0,%eax
80108fd8:	e9 8e 00 00 00       	jmp    8010906b <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80108fdd:	83 ec 04             	sub    $0x4,%esp
80108fe0:	68 00 10 00 00       	push   $0x1000
80108fe5:	6a 00                	push   $0x0
80108fe7:	ff 75 f0             	pushl  -0x10(%ebp)
80108fea:	e8 b1 d3 ff ff       	call   801063a0 <memset>
80108fef:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80108ff2:	83 ec 0c             	sub    $0xc,%esp
80108ff5:	68 00 00 00 0e       	push   $0xe000000
80108ffa:	e8 0d fa ff ff       	call   80108a0c <p2v>
80108fff:	83 c4 10             	add    $0x10,%esp
80109002:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80109007:	76 0d                	jbe    80109016 <setupkvm+0x58>
    panic("PHYSTOP too high");
80109009:	83 ec 0c             	sub    $0xc,%esp
8010900c:	68 36 a4 10 80       	push   $0x8010a436
80109011:	e8 50 75 ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109016:	c7 45 f4 c0 d4 10 80 	movl   $0x8010d4c0,-0xc(%ebp)
8010901d:	eb 40                	jmp    8010905f <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010901f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109022:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80109025:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109028:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010902b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010902e:	8b 58 08             	mov    0x8(%eax),%ebx
80109031:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109034:	8b 40 04             	mov    0x4(%eax),%eax
80109037:	29 c3                	sub    %eax,%ebx
80109039:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010903c:	8b 00                	mov    (%eax),%eax
8010903e:	83 ec 0c             	sub    $0xc,%esp
80109041:	51                   	push   %ecx
80109042:	52                   	push   %edx
80109043:	53                   	push   %ebx
80109044:	50                   	push   %eax
80109045:	ff 75 f0             	pushl  -0x10(%ebp)
80109048:	e8 e1 fe ff ff       	call   80108f2e <mappages>
8010904d:	83 c4 20             	add    $0x20,%esp
80109050:	85 c0                	test   %eax,%eax
80109052:	79 07                	jns    8010905b <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80109054:	b8 00 00 00 00       	mov    $0x0,%eax
80109059:	eb 10                	jmp    8010906b <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010905b:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010905f:	81 7d f4 00 d5 10 80 	cmpl   $0x8010d500,-0xc(%ebp)
80109066:	72 b7                	jb     8010901f <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80109068:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010906b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010906e:	c9                   	leave  
8010906f:	c3                   	ret    

80109070 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80109070:	55                   	push   %ebp
80109071:	89 e5                	mov    %esp,%ebp
80109073:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109076:	e8 43 ff ff ff       	call   80108fbe <setupkvm>
8010907b:	a3 38 77 11 80       	mov    %eax,0x80117738
  switchkvm();
80109080:	e8 03 00 00 00       	call   80109088 <switchkvm>
}
80109085:	90                   	nop
80109086:	c9                   	leave  
80109087:	c3                   	ret    

80109088 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109088:	55                   	push   %ebp
80109089:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
8010908b:	a1 38 77 11 80       	mov    0x80117738,%eax
80109090:	50                   	push   %eax
80109091:	e8 69 f9 ff ff       	call   801089ff <v2p>
80109096:	83 c4 04             	add    $0x4,%esp
80109099:	50                   	push   %eax
8010909a:	e8 54 f9 ff ff       	call   801089f3 <lcr3>
8010909f:	83 c4 04             	add    $0x4,%esp
}
801090a2:	90                   	nop
801090a3:	c9                   	leave  
801090a4:	c3                   	ret    

801090a5 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801090a5:	55                   	push   %ebp
801090a6:	89 e5                	mov    %esp,%ebp
801090a8:	56                   	push   %esi
801090a9:	53                   	push   %ebx
  pushcli();
801090aa:	e8 eb d1 ff ff       	call   8010629a <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801090af:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801090b5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801090bc:	83 c2 08             	add    $0x8,%edx
801090bf:	89 d6                	mov    %edx,%esi
801090c1:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801090c8:	83 c2 08             	add    $0x8,%edx
801090cb:	c1 ea 10             	shr    $0x10,%edx
801090ce:	89 d3                	mov    %edx,%ebx
801090d0:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801090d7:	83 c2 08             	add    $0x8,%edx
801090da:	c1 ea 18             	shr    $0x18,%edx
801090dd:	89 d1                	mov    %edx,%ecx
801090df:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801090e6:	67 00 
801090e8:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801090ef:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801090f5:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801090fc:	83 e2 f0             	and    $0xfffffff0,%edx
801090ff:	83 ca 09             	or     $0x9,%edx
80109102:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109108:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010910f:	83 ca 10             	or     $0x10,%edx
80109112:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109118:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010911f:	83 e2 9f             	and    $0xffffff9f,%edx
80109122:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109128:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010912f:	83 ca 80             	or     $0xffffff80,%edx
80109132:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109138:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010913f:	83 e2 f0             	and    $0xfffffff0,%edx
80109142:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109148:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010914f:	83 e2 ef             	and    $0xffffffef,%edx
80109152:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109158:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010915f:	83 e2 df             	and    $0xffffffdf,%edx
80109162:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109168:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010916f:	83 ca 40             	or     $0x40,%edx
80109172:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109178:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010917f:	83 e2 7f             	and    $0x7f,%edx
80109182:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109188:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
8010918e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109194:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010919b:	83 e2 ef             	and    $0xffffffef,%edx
8010919e:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801091a4:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801091aa:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801091b0:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801091b6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801091bd:	8b 52 08             	mov    0x8(%edx),%edx
801091c0:	81 c2 00 10 00 00    	add    $0x1000,%edx
801091c6:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801091c9:	83 ec 0c             	sub    $0xc,%esp
801091cc:	6a 30                	push   $0x30
801091ce:	e8 f3 f7 ff ff       	call   801089c6 <ltr>
801091d3:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
801091d6:	8b 45 08             	mov    0x8(%ebp),%eax
801091d9:	8b 40 04             	mov    0x4(%eax),%eax
801091dc:	85 c0                	test   %eax,%eax
801091de:	75 0d                	jne    801091ed <switchuvm+0x148>
    panic("switchuvm: no pgdir");
801091e0:	83 ec 0c             	sub    $0xc,%esp
801091e3:	68 47 a4 10 80       	push   $0x8010a447
801091e8:	e8 79 73 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
801091ed:	8b 45 08             	mov    0x8(%ebp),%eax
801091f0:	8b 40 04             	mov    0x4(%eax),%eax
801091f3:	83 ec 0c             	sub    $0xc,%esp
801091f6:	50                   	push   %eax
801091f7:	e8 03 f8 ff ff       	call   801089ff <v2p>
801091fc:	83 c4 10             	add    $0x10,%esp
801091ff:	83 ec 0c             	sub    $0xc,%esp
80109202:	50                   	push   %eax
80109203:	e8 eb f7 ff ff       	call   801089f3 <lcr3>
80109208:	83 c4 10             	add    $0x10,%esp
  popcli();
8010920b:	e8 cf d0 ff ff       	call   801062df <popcli>
}
80109210:	90                   	nop
80109211:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109214:	5b                   	pop    %ebx
80109215:	5e                   	pop    %esi
80109216:	5d                   	pop    %ebp
80109217:	c3                   	ret    

80109218 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109218:	55                   	push   %ebp
80109219:	89 e5                	mov    %esp,%ebp
8010921b:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010921e:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80109225:	76 0d                	jbe    80109234 <inituvm+0x1c>
    panic("inituvm: more than a page");
80109227:	83 ec 0c             	sub    $0xc,%esp
8010922a:	68 5b a4 10 80       	push   $0x8010a45b
8010922f:	e8 32 73 ff ff       	call   80100566 <panic>
  mem = kalloc();
80109234:	e8 de 9a ff ff       	call   80102d17 <kalloc>
80109239:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010923c:	83 ec 04             	sub    $0x4,%esp
8010923f:	68 00 10 00 00       	push   $0x1000
80109244:	6a 00                	push   $0x0
80109246:	ff 75 f4             	pushl  -0xc(%ebp)
80109249:	e8 52 d1 ff ff       	call   801063a0 <memset>
8010924e:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109251:	83 ec 0c             	sub    $0xc,%esp
80109254:	ff 75 f4             	pushl  -0xc(%ebp)
80109257:	e8 a3 f7 ff ff       	call   801089ff <v2p>
8010925c:	83 c4 10             	add    $0x10,%esp
8010925f:	83 ec 0c             	sub    $0xc,%esp
80109262:	6a 06                	push   $0x6
80109264:	50                   	push   %eax
80109265:	68 00 10 00 00       	push   $0x1000
8010926a:	6a 00                	push   $0x0
8010926c:	ff 75 08             	pushl  0x8(%ebp)
8010926f:	e8 ba fc ff ff       	call   80108f2e <mappages>
80109274:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109277:	83 ec 04             	sub    $0x4,%esp
8010927a:	ff 75 10             	pushl  0x10(%ebp)
8010927d:	ff 75 0c             	pushl  0xc(%ebp)
80109280:	ff 75 f4             	pushl  -0xc(%ebp)
80109283:	e8 d7 d1 ff ff       	call   8010645f <memmove>
80109288:	83 c4 10             	add    $0x10,%esp
}
8010928b:	90                   	nop
8010928c:	c9                   	leave  
8010928d:	c3                   	ret    

8010928e <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
8010928e:	55                   	push   %ebp
8010928f:	89 e5                	mov    %esp,%ebp
80109291:	53                   	push   %ebx
80109292:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109295:	8b 45 0c             	mov    0xc(%ebp),%eax
80109298:	25 ff 0f 00 00       	and    $0xfff,%eax
8010929d:	85 c0                	test   %eax,%eax
8010929f:	74 0d                	je     801092ae <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801092a1:	83 ec 0c             	sub    $0xc,%esp
801092a4:	68 78 a4 10 80       	push   $0x8010a478
801092a9:	e8 b8 72 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
801092ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801092b5:	e9 95 00 00 00       	jmp    8010934f <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801092ba:	8b 55 0c             	mov    0xc(%ebp),%edx
801092bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092c0:	01 d0                	add    %edx,%eax
801092c2:	83 ec 04             	sub    $0x4,%esp
801092c5:	6a 00                	push   $0x0
801092c7:	50                   	push   %eax
801092c8:	ff 75 08             	pushl  0x8(%ebp)
801092cb:	e8 be fb ff ff       	call   80108e8e <walkpgdir>
801092d0:	83 c4 10             	add    $0x10,%esp
801092d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801092d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801092da:	75 0d                	jne    801092e9 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
801092dc:	83 ec 0c             	sub    $0xc,%esp
801092df:	68 9b a4 10 80       	push   $0x8010a49b
801092e4:	e8 7d 72 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
801092e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801092ec:	8b 00                	mov    (%eax),%eax
801092ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801092f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
801092f6:	8b 45 18             	mov    0x18(%ebp),%eax
801092f9:	2b 45 f4             	sub    -0xc(%ebp),%eax
801092fc:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109301:	77 0b                	ja     8010930e <loaduvm+0x80>
      n = sz - i;
80109303:	8b 45 18             	mov    0x18(%ebp),%eax
80109306:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109309:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010930c:	eb 07                	jmp    80109315 <loaduvm+0x87>
    else
      n = PGSIZE;
8010930e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109315:	8b 55 14             	mov    0x14(%ebp),%edx
80109318:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010931b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010931e:	83 ec 0c             	sub    $0xc,%esp
80109321:	ff 75 e8             	pushl  -0x18(%ebp)
80109324:	e8 e3 f6 ff ff       	call   80108a0c <p2v>
80109329:	83 c4 10             	add    $0x10,%esp
8010932c:	ff 75 f0             	pushl  -0x10(%ebp)
8010932f:	53                   	push   %ebx
80109330:	50                   	push   %eax
80109331:	ff 75 10             	pushl  0x10(%ebp)
80109334:	e8 50 8c ff ff       	call   80101f89 <readi>
80109339:	83 c4 10             	add    $0x10,%esp
8010933c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010933f:	74 07                	je     80109348 <loaduvm+0xba>
      return -1;
80109341:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109346:	eb 18                	jmp    80109360 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109348:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010934f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109352:	3b 45 18             	cmp    0x18(%ebp),%eax
80109355:	0f 82 5f ff ff ff    	jb     801092ba <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
8010935b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109360:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109363:	c9                   	leave  
80109364:	c3                   	ret    

80109365 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109365:	55                   	push   %ebp
80109366:	89 e5                	mov    %esp,%ebp
80109368:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010936b:	8b 45 10             	mov    0x10(%ebp),%eax
8010936e:	85 c0                	test   %eax,%eax
80109370:	79 0a                	jns    8010937c <allocuvm+0x17>
    return 0;
80109372:	b8 00 00 00 00       	mov    $0x0,%eax
80109377:	e9 b0 00 00 00       	jmp    8010942c <allocuvm+0xc7>
  if(newsz < oldsz)
8010937c:	8b 45 10             	mov    0x10(%ebp),%eax
8010937f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109382:	73 08                	jae    8010938c <allocuvm+0x27>
    return oldsz;
80109384:	8b 45 0c             	mov    0xc(%ebp),%eax
80109387:	e9 a0 00 00 00       	jmp    8010942c <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
8010938c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010938f:	05 ff 0f 00 00       	add    $0xfff,%eax
80109394:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109399:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010939c:	eb 7f                	jmp    8010941d <allocuvm+0xb8>
    mem = kalloc();
8010939e:	e8 74 99 ff ff       	call   80102d17 <kalloc>
801093a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801093a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801093aa:	75 2b                	jne    801093d7 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
801093ac:	83 ec 0c             	sub    $0xc,%esp
801093af:	68 b9 a4 10 80       	push   $0x8010a4b9
801093b4:	e8 0d 70 ff ff       	call   801003c6 <cprintf>
801093b9:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801093bc:	83 ec 04             	sub    $0x4,%esp
801093bf:	ff 75 0c             	pushl  0xc(%ebp)
801093c2:	ff 75 10             	pushl  0x10(%ebp)
801093c5:	ff 75 08             	pushl  0x8(%ebp)
801093c8:	e8 61 00 00 00       	call   8010942e <deallocuvm>
801093cd:	83 c4 10             	add    $0x10,%esp
      return 0;
801093d0:	b8 00 00 00 00       	mov    $0x0,%eax
801093d5:	eb 55                	jmp    8010942c <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
801093d7:	83 ec 04             	sub    $0x4,%esp
801093da:	68 00 10 00 00       	push   $0x1000
801093df:	6a 00                	push   $0x0
801093e1:	ff 75 f0             	pushl  -0x10(%ebp)
801093e4:	e8 b7 cf ff ff       	call   801063a0 <memset>
801093e9:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
801093ec:	83 ec 0c             	sub    $0xc,%esp
801093ef:	ff 75 f0             	pushl  -0x10(%ebp)
801093f2:	e8 08 f6 ff ff       	call   801089ff <v2p>
801093f7:	83 c4 10             	add    $0x10,%esp
801093fa:	89 c2                	mov    %eax,%edx
801093fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093ff:	83 ec 0c             	sub    $0xc,%esp
80109402:	6a 06                	push   $0x6
80109404:	52                   	push   %edx
80109405:	68 00 10 00 00       	push   $0x1000
8010940a:	50                   	push   %eax
8010940b:	ff 75 08             	pushl  0x8(%ebp)
8010940e:	e8 1b fb ff ff       	call   80108f2e <mappages>
80109413:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109416:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010941d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109420:	3b 45 10             	cmp    0x10(%ebp),%eax
80109423:	0f 82 75 ff ff ff    	jb     8010939e <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109429:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010942c:	c9                   	leave  
8010942d:	c3                   	ret    

8010942e <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010942e:	55                   	push   %ebp
8010942f:	89 e5                	mov    %esp,%ebp
80109431:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109434:	8b 45 10             	mov    0x10(%ebp),%eax
80109437:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010943a:	72 08                	jb     80109444 <deallocuvm+0x16>
    return oldsz;
8010943c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010943f:	e9 a5 00 00 00       	jmp    801094e9 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109444:	8b 45 10             	mov    0x10(%ebp),%eax
80109447:	05 ff 0f 00 00       	add    $0xfff,%eax
8010944c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109451:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109454:	e9 81 00 00 00       	jmp    801094da <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109459:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010945c:	83 ec 04             	sub    $0x4,%esp
8010945f:	6a 00                	push   $0x0
80109461:	50                   	push   %eax
80109462:	ff 75 08             	pushl  0x8(%ebp)
80109465:	e8 24 fa ff ff       	call   80108e8e <walkpgdir>
8010946a:	83 c4 10             	add    $0x10,%esp
8010946d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109470:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109474:	75 09                	jne    8010947f <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109476:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010947d:	eb 54                	jmp    801094d3 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
8010947f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109482:	8b 00                	mov    (%eax),%eax
80109484:	83 e0 01             	and    $0x1,%eax
80109487:	85 c0                	test   %eax,%eax
80109489:	74 48                	je     801094d3 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
8010948b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010948e:	8b 00                	mov    (%eax),%eax
80109490:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109495:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109498:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010949c:	75 0d                	jne    801094ab <deallocuvm+0x7d>
        panic("kfree");
8010949e:	83 ec 0c             	sub    $0xc,%esp
801094a1:	68 d1 a4 10 80       	push   $0x8010a4d1
801094a6:	e8 bb 70 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
801094ab:	83 ec 0c             	sub    $0xc,%esp
801094ae:	ff 75 ec             	pushl  -0x14(%ebp)
801094b1:	e8 56 f5 ff ff       	call   80108a0c <p2v>
801094b6:	83 c4 10             	add    $0x10,%esp
801094b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801094bc:	83 ec 0c             	sub    $0xc,%esp
801094bf:	ff 75 e8             	pushl  -0x18(%ebp)
801094c2:	e8 b3 97 ff ff       	call   80102c7a <kfree>
801094c7:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801094ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801094cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801094d3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801094da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801094e0:	0f 82 73 ff ff ff    	jb     80109459 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
801094e6:	8b 45 10             	mov    0x10(%ebp),%eax
}
801094e9:	c9                   	leave  
801094ea:	c3                   	ret    

801094eb <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801094eb:	55                   	push   %ebp
801094ec:	89 e5                	mov    %esp,%ebp
801094ee:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
801094f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801094f5:	75 0d                	jne    80109504 <freevm+0x19>
    panic("freevm: no pgdir");
801094f7:	83 ec 0c             	sub    $0xc,%esp
801094fa:	68 d7 a4 10 80       	push   $0x8010a4d7
801094ff:	e8 62 70 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109504:	83 ec 04             	sub    $0x4,%esp
80109507:	6a 00                	push   $0x0
80109509:	68 00 00 00 80       	push   $0x80000000
8010950e:	ff 75 08             	pushl  0x8(%ebp)
80109511:	e8 18 ff ff ff       	call   8010942e <deallocuvm>
80109516:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109519:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109520:	eb 4f                	jmp    80109571 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109522:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109525:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010952c:	8b 45 08             	mov    0x8(%ebp),%eax
8010952f:	01 d0                	add    %edx,%eax
80109531:	8b 00                	mov    (%eax),%eax
80109533:	83 e0 01             	and    $0x1,%eax
80109536:	85 c0                	test   %eax,%eax
80109538:	74 33                	je     8010956d <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010953a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010953d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109544:	8b 45 08             	mov    0x8(%ebp),%eax
80109547:	01 d0                	add    %edx,%eax
80109549:	8b 00                	mov    (%eax),%eax
8010954b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109550:	83 ec 0c             	sub    $0xc,%esp
80109553:	50                   	push   %eax
80109554:	e8 b3 f4 ff ff       	call   80108a0c <p2v>
80109559:	83 c4 10             	add    $0x10,%esp
8010955c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010955f:	83 ec 0c             	sub    $0xc,%esp
80109562:	ff 75 f0             	pushl  -0x10(%ebp)
80109565:	e8 10 97 ff ff       	call   80102c7a <kfree>
8010956a:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010956d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109571:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109578:	76 a8                	jbe    80109522 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010957a:	83 ec 0c             	sub    $0xc,%esp
8010957d:	ff 75 08             	pushl  0x8(%ebp)
80109580:	e8 f5 96 ff ff       	call   80102c7a <kfree>
80109585:	83 c4 10             	add    $0x10,%esp
}
80109588:	90                   	nop
80109589:	c9                   	leave  
8010958a:	c3                   	ret    

8010958b <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010958b:	55                   	push   %ebp
8010958c:	89 e5                	mov    %esp,%ebp
8010958e:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109591:	83 ec 04             	sub    $0x4,%esp
80109594:	6a 00                	push   $0x0
80109596:	ff 75 0c             	pushl  0xc(%ebp)
80109599:	ff 75 08             	pushl  0x8(%ebp)
8010959c:	e8 ed f8 ff ff       	call   80108e8e <walkpgdir>
801095a1:	83 c4 10             	add    $0x10,%esp
801095a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801095a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801095ab:	75 0d                	jne    801095ba <clearpteu+0x2f>
    panic("clearpteu");
801095ad:	83 ec 0c             	sub    $0xc,%esp
801095b0:	68 e8 a4 10 80       	push   $0x8010a4e8
801095b5:	e8 ac 6f ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
801095ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095bd:	8b 00                	mov    (%eax),%eax
801095bf:	83 e0 fb             	and    $0xfffffffb,%eax
801095c2:	89 c2                	mov    %eax,%edx
801095c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095c7:	89 10                	mov    %edx,(%eax)
}
801095c9:	90                   	nop
801095ca:	c9                   	leave  
801095cb:	c3                   	ret    

801095cc <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801095cc:	55                   	push   %ebp
801095cd:	89 e5                	mov    %esp,%ebp
801095cf:	53                   	push   %ebx
801095d0:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801095d3:	e8 e6 f9 ff ff       	call   80108fbe <setupkvm>
801095d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801095db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801095df:	75 0a                	jne    801095eb <copyuvm+0x1f>
    return 0;
801095e1:	b8 00 00 00 00       	mov    $0x0,%eax
801095e6:	e9 f8 00 00 00       	jmp    801096e3 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
801095eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801095f2:	e9 c4 00 00 00       	jmp    801096bb <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801095f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095fa:	83 ec 04             	sub    $0x4,%esp
801095fd:	6a 00                	push   $0x0
801095ff:	50                   	push   %eax
80109600:	ff 75 08             	pushl  0x8(%ebp)
80109603:	e8 86 f8 ff ff       	call   80108e8e <walkpgdir>
80109608:	83 c4 10             	add    $0x10,%esp
8010960b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010960e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109612:	75 0d                	jne    80109621 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109614:	83 ec 0c             	sub    $0xc,%esp
80109617:	68 f2 a4 10 80       	push   $0x8010a4f2
8010961c:	e8 45 6f ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109621:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109624:	8b 00                	mov    (%eax),%eax
80109626:	83 e0 01             	and    $0x1,%eax
80109629:	85 c0                	test   %eax,%eax
8010962b:	75 0d                	jne    8010963a <copyuvm+0x6e>
      panic("copyuvm: page not present");
8010962d:	83 ec 0c             	sub    $0xc,%esp
80109630:	68 0c a5 10 80       	push   $0x8010a50c
80109635:	e8 2c 6f ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010963a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010963d:	8b 00                	mov    (%eax),%eax
8010963f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109644:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109647:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010964a:	8b 00                	mov    (%eax),%eax
8010964c:	25 ff 0f 00 00       	and    $0xfff,%eax
80109651:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109654:	e8 be 96 ff ff       	call   80102d17 <kalloc>
80109659:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010965c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109660:	74 6a                	je     801096cc <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109662:	83 ec 0c             	sub    $0xc,%esp
80109665:	ff 75 e8             	pushl  -0x18(%ebp)
80109668:	e8 9f f3 ff ff       	call   80108a0c <p2v>
8010966d:	83 c4 10             	add    $0x10,%esp
80109670:	83 ec 04             	sub    $0x4,%esp
80109673:	68 00 10 00 00       	push   $0x1000
80109678:	50                   	push   %eax
80109679:	ff 75 e0             	pushl  -0x20(%ebp)
8010967c:	e8 de cd ff ff       	call   8010645f <memmove>
80109681:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109684:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109687:	83 ec 0c             	sub    $0xc,%esp
8010968a:	ff 75 e0             	pushl  -0x20(%ebp)
8010968d:	e8 6d f3 ff ff       	call   801089ff <v2p>
80109692:	83 c4 10             	add    $0x10,%esp
80109695:	89 c2                	mov    %eax,%edx
80109697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010969a:	83 ec 0c             	sub    $0xc,%esp
8010969d:	53                   	push   %ebx
8010969e:	52                   	push   %edx
8010969f:	68 00 10 00 00       	push   $0x1000
801096a4:	50                   	push   %eax
801096a5:	ff 75 f0             	pushl  -0x10(%ebp)
801096a8:	e8 81 f8 ff ff       	call   80108f2e <mappages>
801096ad:	83 c4 20             	add    $0x20,%esp
801096b0:	85 c0                	test   %eax,%eax
801096b2:	78 1b                	js     801096cf <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801096b4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801096bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096be:	3b 45 0c             	cmp    0xc(%ebp),%eax
801096c1:	0f 82 30 ff ff ff    	jb     801095f7 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
801096c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801096ca:	eb 17                	jmp    801096e3 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
801096cc:	90                   	nop
801096cd:	eb 01                	jmp    801096d0 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
801096cf:	90                   	nop
  }
  return d;

bad:
  freevm(d);
801096d0:	83 ec 0c             	sub    $0xc,%esp
801096d3:	ff 75 f0             	pushl  -0x10(%ebp)
801096d6:	e8 10 fe ff ff       	call   801094eb <freevm>
801096db:	83 c4 10             	add    $0x10,%esp
  return 0;
801096de:	b8 00 00 00 00       	mov    $0x0,%eax
}
801096e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801096e6:	c9                   	leave  
801096e7:	c3                   	ret    

801096e8 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801096e8:	55                   	push   %ebp
801096e9:	89 e5                	mov    %esp,%ebp
801096eb:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801096ee:	83 ec 04             	sub    $0x4,%esp
801096f1:	6a 00                	push   $0x0
801096f3:	ff 75 0c             	pushl  0xc(%ebp)
801096f6:	ff 75 08             	pushl  0x8(%ebp)
801096f9:	e8 90 f7 ff ff       	call   80108e8e <walkpgdir>
801096fe:	83 c4 10             	add    $0x10,%esp
80109701:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109704:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109707:	8b 00                	mov    (%eax),%eax
80109709:	83 e0 01             	and    $0x1,%eax
8010970c:	85 c0                	test   %eax,%eax
8010970e:	75 07                	jne    80109717 <uva2ka+0x2f>
    return 0;
80109710:	b8 00 00 00 00       	mov    $0x0,%eax
80109715:	eb 29                	jmp    80109740 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010971a:	8b 00                	mov    (%eax),%eax
8010971c:	83 e0 04             	and    $0x4,%eax
8010971f:	85 c0                	test   %eax,%eax
80109721:	75 07                	jne    8010972a <uva2ka+0x42>
    return 0;
80109723:	b8 00 00 00 00       	mov    $0x0,%eax
80109728:	eb 16                	jmp    80109740 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
8010972a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010972d:	8b 00                	mov    (%eax),%eax
8010972f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109734:	83 ec 0c             	sub    $0xc,%esp
80109737:	50                   	push   %eax
80109738:	e8 cf f2 ff ff       	call   80108a0c <p2v>
8010973d:	83 c4 10             	add    $0x10,%esp
}
80109740:	c9                   	leave  
80109741:	c3                   	ret    

80109742 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109742:	55                   	push   %ebp
80109743:	89 e5                	mov    %esp,%ebp
80109745:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109748:	8b 45 10             	mov    0x10(%ebp),%eax
8010974b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010974e:	eb 7f                	jmp    801097cf <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
80109750:	8b 45 0c             	mov    0xc(%ebp),%eax
80109753:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109758:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010975b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010975e:	83 ec 08             	sub    $0x8,%esp
80109761:	50                   	push   %eax
80109762:	ff 75 08             	pushl  0x8(%ebp)
80109765:	e8 7e ff ff ff       	call   801096e8 <uva2ka>
8010976a:	83 c4 10             	add    $0x10,%esp
8010976d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80109770:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80109774:	75 07                	jne    8010977d <copyout+0x3b>
      return -1;
80109776:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010977b:	eb 61                	jmp    801097de <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010977d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109780:	2b 45 0c             	sub    0xc(%ebp),%eax
80109783:	05 00 10 00 00       	add    $0x1000,%eax
80109788:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010978b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010978e:	3b 45 14             	cmp    0x14(%ebp),%eax
80109791:	76 06                	jbe    80109799 <copyout+0x57>
      n = len;
80109793:	8b 45 14             	mov    0x14(%ebp),%eax
80109796:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80109799:	8b 45 0c             	mov    0xc(%ebp),%eax
8010979c:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010979f:	89 c2                	mov    %eax,%edx
801097a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801097a4:	01 d0                	add    %edx,%eax
801097a6:	83 ec 04             	sub    $0x4,%esp
801097a9:	ff 75 f0             	pushl  -0x10(%ebp)
801097ac:	ff 75 f4             	pushl  -0xc(%ebp)
801097af:	50                   	push   %eax
801097b0:	e8 aa cc ff ff       	call   8010645f <memmove>
801097b5:	83 c4 10             	add    $0x10,%esp
    len -= n;
801097b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097bb:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801097be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097c1:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801097c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801097c7:	05 00 10 00 00       	add    $0x1000,%eax
801097cc:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801097cf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801097d3:	0f 85 77 ff ff ff    	jne    80109750 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
801097d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801097de:	c9                   	leave  
801097df:	c3                   	ret    
