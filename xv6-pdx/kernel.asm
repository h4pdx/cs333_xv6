
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
80100015:	b8 00 d0 10 00       	mov    $0x10d000,%eax
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
80100028:	bc 90 f6 10 80       	mov    $0x8010f690,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 3b 10 80       	mov    $0x80103bc0,%eax
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
8010003d:	68 20 a3 10 80       	push   $0x8010a320
80100042:	68 a0 f6 10 80       	push   $0x8010f6a0
80100047:	e8 5f 6a 00 00       	call   80106aab <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 b0 35 11 80 a4 	movl   $0x801135a4,0x801135b0
80100056:	35 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 b4 35 11 80 a4 	movl   $0x801135a4,0x801135b4
80100060:	35 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 d4 f6 10 80 	movl   $0x8010f6d4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 b4 35 11 80    	mov    0x801135b4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c a4 35 11 80 	movl   $0x801135a4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 b4 35 11 80       	mov    0x801135b4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 b4 35 11 80       	mov    %eax,0x801135b4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 a4 35 11 80       	mov    $0x801135a4,%eax
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
801000bc:	68 a0 f6 10 80       	push   $0x8010f6a0
801000c1:	e8 07 6a 00 00       	call   80106acd <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 b4 35 11 80       	mov    0x801135b4,%eax
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
80100107:	68 a0 f6 10 80       	push   $0x8010f6a0
8010010c:	e8 23 6a 00 00       	call   80106b34 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 a0 f6 10 80       	push   $0x8010f6a0
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 ec 56 00 00       	call   80105818 <sleep>
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
8010013a:	81 7d f4 a4 35 11 80 	cmpl   $0x801135a4,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 b0 35 11 80       	mov    0x801135b0,%eax
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
80100183:	68 a0 f6 10 80       	push   $0x8010f6a0
80100188:	e8 a7 69 00 00       	call   80106b34 <release>
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
8010019e:	81 7d f4 a4 35 11 80 	cmpl   $0x801135a4,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 27 a3 10 80       	push   $0x8010a327
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
801001e2:	e8 57 2a 00 00       	call   80102c3e <iderw>
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
80100204:	68 38 a3 10 80       	push   $0x8010a338
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
80100223:	e8 16 2a 00 00       	call   80102c3e <iderw>
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
80100243:	68 3f a3 10 80       	push   $0x8010a33f
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 a0 f6 10 80       	push   $0x8010f6a0
80100255:	e8 73 68 00 00       	call   80106acd <acquire>
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
8010027b:	8b 15 b4 35 11 80    	mov    0x801135b4,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c a4 35 11 80 	movl   $0x801135a4,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 b4 35 11 80       	mov    0x801135b4,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 b4 35 11 80       	mov    %eax,0x801135b4

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
801002b9:	e8 b5 57 00 00       	call   80105a73 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 a0 f6 10 80       	push   $0x8010f6a0
801002c9:	e8 66 68 00 00       	call   80106b34 <release>
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
80100365:	0f b6 80 04 c0 10 80 	movzbl -0x7fef3ffc(%eax),%eax
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
801003cc:	a1 34 e6 10 80       	mov    0x8010e634,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 00 e6 10 80       	push   $0x8010e600
801003e2:	e8 e6 66 00 00       	call   80106acd <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 46 a3 10 80       	push   $0x8010a346
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
801004cd:	c7 45 ec 4f a3 10 80 	movl   $0x8010a34f,-0x14(%ebp)
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
80100556:	68 00 e6 10 80       	push   $0x8010e600
8010055b:	e8 d4 65 00 00       	call   80106b34 <release>
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
80100571:	c7 05 34 e6 10 80 00 	movl   $0x0,0x8010e634
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 56 a3 10 80       	push   $0x8010a356
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
801005aa:	68 65 a3 10 80       	push   $0x8010a365
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 bf 65 00 00       	call   80106b86 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 67 a3 10 80       	push   $0x8010a367
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
801005f5:	c7 05 e0 e5 10 80 01 	movl   $0x1,0x8010e5e0
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
80100699:	8b 0d 00 c0 10 80    	mov    0x8010c000,%ecx
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
801006ca:	68 6b a3 10 80       	push   $0x8010a36b
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 c0 10 80       	mov    0x8010c000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 f3 66 00 00       	call   80106def <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 c0 10 80       	mov    0x8010c000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 0a 66 00 00       	call   80106d30 <memset>
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
8010077e:	a1 00 c0 10 80       	mov    0x8010c000,%eax
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
80100798:	a1 e0 e5 10 80       	mov    0x8010e5e0,%eax
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
801007b6:	e8 ed 81 00 00       	call   801089a8 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 e0 81 00 00       	call   801089a8 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 d3 81 00 00       	call   801089a8 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 c3 81 00 00       	call   801089a8 <uartputc>
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
80100810:	68 00 e6 10 80       	push   $0x8010e600
80100815:	e8 b3 62 00 00       	call   80106acd <acquire>
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
80100886:	a1 48 38 11 80       	mov    0x80113848,%eax
8010088b:	83 e8 01             	sub    $0x1,%eax
8010088e:	a3 48 38 11 80       	mov    %eax,0x80113848
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
801008a3:	8b 15 48 38 11 80    	mov    0x80113848,%edx
801008a9:	a1 44 38 11 80       	mov    0x80113844,%eax
801008ae:	39 c2                	cmp    %eax,%edx
801008b0:	0f 84 12 01 00 00    	je     801009c8 <consoleintr+0x1cf>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008b6:	a1 48 38 11 80       	mov    0x80113848,%eax
801008bb:	83 e8 01             	sub    $0x1,%eax
801008be:	83 e0 7f             	and    $0x7f,%eax
801008c1:	0f b6 80 c0 37 11 80 	movzbl -0x7feec840(%eax),%eax
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
801008d1:	8b 15 48 38 11 80    	mov    0x80113848,%edx
801008d7:	a1 44 38 11 80       	mov    0x80113844,%eax
801008dc:	39 c2                	cmp    %eax,%edx
801008de:	0f 84 e4 00 00 00    	je     801009c8 <consoleintr+0x1cf>
        input.e--;
801008e4:	a1 48 38 11 80       	mov    0x80113848,%eax
801008e9:	83 e8 01             	sub    $0x1,%eax
801008ec:	a3 48 38 11 80       	mov    %eax,0x80113848
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
80100940:	8b 15 48 38 11 80    	mov    0x80113848,%edx
80100946:	a1 40 38 11 80       	mov    0x80113840,%eax
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
80100967:	a1 48 38 11 80       	mov    0x80113848,%eax
8010096c:	8d 50 01             	lea    0x1(%eax),%edx
8010096f:	89 15 48 38 11 80    	mov    %edx,0x80113848
80100975:	83 e0 7f             	and    $0x7f,%eax
80100978:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010097b:	88 90 c0 37 11 80    	mov    %dl,-0x7feec840(%eax)
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
8010099b:	a1 48 38 11 80       	mov    0x80113848,%eax
801009a0:	8b 15 40 38 11 80    	mov    0x80113840,%edx
801009a6:	83 ea 80             	sub    $0xffffff80,%edx
801009a9:	39 d0                	cmp    %edx,%eax
801009ab:	75 1a                	jne    801009c7 <consoleintr+0x1ce>
          input.w = input.e;
801009ad:	a1 48 38 11 80       	mov    0x80113848,%eax
801009b2:	a3 44 38 11 80       	mov    %eax,0x80113844
          wakeup(&input.r);
801009b7:	83 ec 0c             	sub    $0xc,%esp
801009ba:	68 40 38 11 80       	push   $0x80113840
801009bf:	e8 af 50 00 00       	call   80105a73 <wakeup>
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
801009dd:	68 00 e6 10 80       	push   $0x8010e600
801009e2:	e8 4d 61 00 00       	call   80106b34 <release>
801009e7:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009ee:	74 05                	je     801009f5 <consoleintr+0x1fc>
    procdump();  // now call procdump() wo. cons.lock held
801009f0:	e8 0e 54 00 00       	call   80105e03 <procdump>
  }
#ifdef CS333_P3P4
  // run Ready list display function
  if (ctrlkey == 1) {
801009f5:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
801009f9:	75 0c                	jne    80100a07 <consoleintr+0x20e>
      //cprintf("Ready list not implemented yet..\n");
      printReadyList();
801009fb:	e8 25 5a 00 00       	call   80106425 <printReadyList>
      ctrlkey = 0;
80100a00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Free list display function
  if (ctrlkey == 2) {
80100a07:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
80100a0b:	75 0c                	jne    80100a19 <consoleintr+0x220>
      printFreeList();
80100a0d:	e8 0c 5b 00 00       	call   8010651e <printFreeList>
      ctrlkey = 0;
80100a12:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Sleep list display function
  if (ctrlkey == 3) {
80100a19:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
80100a1d:	75 0c                	jne    80100a2b <consoleintr+0x232>
     // cprintf("Sleep list not implemented yet..\n");
      printSleepList();
80100a1f:	e8 58 5b 00 00       	call   8010657c <printSleepList>
      ctrlkey = 0;
80100a24:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }
  // run Zombie list display function
  if (ctrlkey == 4) {
80100a2b:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a2f:	75 0c                	jne    80100a3d <consoleintr+0x244>
      //cprintf("Zombie list not implemented yet..\n");
      printZombieList();
80100a31:	e8 e3 5b 00 00       	call   80106619 <printZombieList>
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
80100a4c:	e8 33 12 00 00       	call   80101c84 <iunlock>
80100a51:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a54:	8b 45 10             	mov    0x10(%ebp),%eax
80100a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a5a:	83 ec 0c             	sub    $0xc,%esp
80100a5d:	68 00 e6 10 80       	push   $0x8010e600
80100a62:	e8 66 60 00 00       	call   80106acd <acquire>
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
80100a7f:	68 00 e6 10 80       	push   $0x8010e600
80100a84:	e8 ab 60 00 00       	call   80106b34 <release>
80100a89:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a8c:	83 ec 0c             	sub    $0xc,%esp
80100a8f:	ff 75 08             	pushl  0x8(%ebp)
80100a92:	e8 67 10 00 00       	call   80101afe <ilock>
80100a97:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a9a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a9f:	e9 ab 00 00 00       	jmp    80100b4f <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100aa4:	83 ec 08             	sub    $0x8,%esp
80100aa7:	68 00 e6 10 80       	push   $0x8010e600
80100aac:	68 40 38 11 80       	push   $0x80113840
80100ab1:	e8 62 4d 00 00       	call   80105818 <sleep>
80100ab6:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100ab9:	8b 15 40 38 11 80    	mov    0x80113840,%edx
80100abf:	a1 44 38 11 80       	mov    0x80113844,%eax
80100ac4:	39 c2                	cmp    %eax,%edx
80100ac6:	74 a7                	je     80100a6f <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100ac8:	a1 40 38 11 80       	mov    0x80113840,%eax
80100acd:	8d 50 01             	lea    0x1(%eax),%edx
80100ad0:	89 15 40 38 11 80    	mov    %edx,0x80113840
80100ad6:	83 e0 7f             	and    $0x7f,%eax
80100ad9:	0f b6 80 c0 37 11 80 	movzbl -0x7feec840(%eax),%eax
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
80100af4:	a1 40 38 11 80       	mov    0x80113840,%eax
80100af9:	83 e8 01             	sub    $0x1,%eax
80100afc:	a3 40 38 11 80       	mov    %eax,0x80113840
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
80100b2a:	68 00 e6 10 80       	push   $0x8010e600
80100b2f:	e8 00 60 00 00       	call   80106b34 <release>
80100b34:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b37:	83 ec 0c             	sub    $0xc,%esp
80100b3a:	ff 75 08             	pushl  0x8(%ebp)
80100b3d:	e8 bc 0f 00 00       	call   80101afe <ilock>
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
80100b5d:	e8 22 11 00 00       	call   80101c84 <iunlock>
80100b62:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b65:	83 ec 0c             	sub    $0xc,%esp
80100b68:	68 00 e6 10 80       	push   $0x8010e600
80100b6d:	e8 5b 5f 00 00       	call   80106acd <acquire>
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
80100baa:	68 00 e6 10 80       	push   $0x8010e600
80100baf:	e8 80 5f 00 00       	call   80106b34 <release>
80100bb4:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bb7:	83 ec 0c             	sub    $0xc,%esp
80100bba:	ff 75 08             	pushl  0x8(%ebp)
80100bbd:	e8 3c 0f 00 00       	call   80101afe <ilock>
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
80100bd3:	68 7e a3 10 80       	push   $0x8010a37e
80100bd8:	68 00 e6 10 80       	push   $0x8010e600
80100bdd:	e8 c9 5e 00 00       	call   80106aab <initlock>
80100be2:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100be5:	c7 05 0c 42 11 80 51 	movl   $0x80100b51,0x8011420c
80100bec:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100bef:	c7 05 08 42 11 80 40 	movl   $0x80100a40,0x80114208
80100bf6:	0a 10 80 
  cons.locking = 1;
80100bf9:	c7 05 34 e6 10 80 01 	movl   $0x1,0x8010e634
80100c00:	00 00 00 

  picenable(IRQ_KBD);
80100c03:	83 ec 0c             	sub    $0xc,%esp
80100c06:	6a 01                	push   $0x1
80100c08:	e8 4f 36 00 00       	call   8010425c <picenable>
80100c0d:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100c10:	83 ec 08             	sub    $0x8,%esp
80100c13:	6a 00                	push   $0x0
80100c15:	6a 01                	push   $0x1
80100c17:	e8 ef 21 00 00       	call   80102e0b <ioapicenable>
80100c1c:	83 c4 10             	add    $0x10,%esp
}
80100c1f:	90                   	nop
80100c20:	c9                   	leave  
80100c21:	c3                   	ret    

80100c22 <exec>:
#include "stat.h"
#endif

int
exec(char *path, char **argv)
{
80100c22:	55                   	push   %ebp
80100c23:	89 e5                	mov    %esp,%ebp
80100c25:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;


  begin_op();
80100c2b:	e8 4e 2c 00 00       	call   8010387e <begin_op>
  if((ip = namei(path)) == 0){
80100c30:	83 ec 0c             	sub    $0xc,%esp
80100c33:	ff 75 08             	pushl  0x8(%ebp)
80100c36:	e8 d1 1a 00 00       	call   8010270c <namei>
80100c3b:	83 c4 10             	add    $0x10,%esp
80100c3e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c41:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c45:	75 0f                	jne    80100c56 <exec+0x34>
    end_op();
80100c47:	e8 be 2c 00 00       	call   8010390a <end_op>
    return -1;
80100c4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c51:	e9 6d 04 00 00       	jmp    801010c3 <exec+0x4a1>
  }
  ilock(ip);
80100c56:	83 ec 0c             	sub    $0xc,%esp
80100c59:	ff 75 d8             	pushl  -0x28(%ebp)
80100c5c:	e8 9d 0e 00 00       	call   80101afe <ilock>
80100c61:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c64:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

#ifdef CS333_P5
  // Check permissions before executing program
  struct stat st;
  stati(ip, &st); // Copy relevant information
80100c6b:	83 ec 08             	sub    $0x8,%esp
80100c6e:	8d 85 d0 fe ff ff    	lea    -0x130(%ebp),%eax
80100c74:	50                   	push   %eax
80100c75:	ff 75 d8             	pushl  -0x28(%ebp)
80100c78:	e8 d1 13 00 00       	call   8010204e <stati>
80100c7d:	83 c4 10             	add    $0x10,%esp
  if ((st.uid == proc->uid) && (st.mode.flags.u_x)) {
80100c80:	0f b7 85 de fe ff ff 	movzwl -0x122(%ebp),%eax
80100c87:	0f b7 d0             	movzwl %ax,%edx
80100c8a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c90:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80100c96:	39 c2                	cmp    %eax,%edx
80100c98:	75 0e                	jne    80100ca8 <exec+0x86>
80100c9a:	0f b6 85 e4 fe ff ff 	movzbl -0x11c(%ebp),%eax
80100ca1:	83 e0 40             	and    $0x40,%eax
80100ca4:	84 c0                	test   %al,%al
80100ca6:	75 3b                	jne    80100ce3 <exec+0xc1>
      goto good; // User permisson is good, execute
  }
  else if ((st.gid == proc->gid) && (st.mode.flags.g_x)) {
80100ca8:	0f b7 85 e0 fe ff ff 	movzwl -0x120(%ebp),%eax
80100caf:	0f b7 d0             	movzwl %ax,%edx
80100cb2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cb8:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80100cbe:	39 c2                	cmp    %eax,%edx
80100cc0:	75 0e                	jne    80100cd0 <exec+0xae>
80100cc2:	0f b6 85 e4 fe ff ff 	movzbl -0x11c(%ebp),%eax
80100cc9:	83 e0 08             	and    $0x8,%eax
80100ccc:	84 c0                	test   %al,%al
80100cce:	75 13                	jne    80100ce3 <exec+0xc1>
      goto good; // Group permission is good, execute
  }
  else if (st.mode.flags.o_x) {
80100cd0:	0f b6 85 e4 fe ff ff 	movzbl -0x11c(%ebp),%eax
80100cd7:	83 e0 01             	and    $0x1,%eax
80100cda:	84 c0                	test   %al,%al
80100cdc:	0f 84 8d 03 00 00    	je     8010106f <exec+0x44d>
      goto good; // Other permission is good, execute
80100ce2:	90                   	nop
// If we have permissions, continue with exec
good:
#endif

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100ce3:	6a 34                	push   $0x34
80100ce5:	6a 00                	push   $0x0
80100ce7:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100ced:	50                   	push   %eax
80100cee:	ff 75 d8             	pushl  -0x28(%ebp)
80100cf1:	e8 c6 13 00 00       	call   801020bc <readi>
80100cf6:	83 c4 10             	add    $0x10,%esp
80100cf9:	83 f8 33             	cmp    $0x33,%eax
80100cfc:	0f 86 70 03 00 00    	jbe    80101072 <exec+0x450>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100d02:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100d08:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100d0d:	0f 85 62 03 00 00    	jne    80101075 <exec+0x453>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100d13:	e8 e5 8d 00 00       	call   80109afd <setupkvm>
80100d18:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100d1b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100d1f:	0f 84 53 03 00 00    	je     80101078 <exec+0x456>
    goto bad;

  // Load program into memory.
  sz = 0;
80100d25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d2c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100d33:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100d39:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d3c:	e9 ab 00 00 00       	jmp    80100dec <exec+0x1ca>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d41:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100d44:	6a 20                	push   $0x20
80100d46:	50                   	push   %eax
80100d47:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100d4d:	50                   	push   %eax
80100d4e:	ff 75 d8             	pushl  -0x28(%ebp)
80100d51:	e8 66 13 00 00       	call   801020bc <readi>
80100d56:	83 c4 10             	add    $0x10,%esp
80100d59:	83 f8 20             	cmp    $0x20,%eax
80100d5c:	0f 85 19 03 00 00    	jne    8010107b <exec+0x459>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100d62:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100d68:	83 f8 01             	cmp    $0x1,%eax
80100d6b:	75 71                	jne    80100dde <exec+0x1bc>
      continue;
    if(ph.memsz < ph.filesz)
80100d6d:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100d73:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100d79:	39 c2                	cmp    %eax,%edx
80100d7b:	0f 82 fd 02 00 00    	jb     8010107e <exec+0x45c>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100d81:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100d87:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100d8d:	01 d0                	add    %edx,%eax
80100d8f:	83 ec 04             	sub    $0x4,%esp
80100d92:	50                   	push   %eax
80100d93:	ff 75 e0             	pushl  -0x20(%ebp)
80100d96:	ff 75 d4             	pushl  -0x2c(%ebp)
80100d99:	e8 06 91 00 00       	call   80109ea4 <allocuvm>
80100d9e:	83 c4 10             	add    $0x10,%esp
80100da1:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100da4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100da8:	0f 84 d3 02 00 00    	je     80101081 <exec+0x45f>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100dae:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100db4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100dba:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	52                   	push   %edx
80100dc4:	50                   	push   %eax
80100dc5:	ff 75 d8             	pushl  -0x28(%ebp)
80100dc8:	51                   	push   %ecx
80100dc9:	ff 75 d4             	pushl  -0x2c(%ebp)
80100dcc:	e8 fc 8f 00 00       	call   80109dcd <loaduvm>
80100dd1:	83 c4 20             	add    $0x20,%esp
80100dd4:	85 c0                	test   %eax,%eax
80100dd6:	0f 88 a8 02 00 00    	js     80101084 <exec+0x462>
80100ddc:	eb 01                	jmp    80100ddf <exec+0x1bd>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100dde:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ddf:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100de3:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100de6:	83 c0 20             	add    $0x20,%eax
80100de9:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100dec:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100df3:	0f b7 c0             	movzwl %ax,%eax
80100df6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100df9:	0f 8f 42 ff ff ff    	jg     80100d41 <exec+0x11f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100dff:	83 ec 0c             	sub    $0xc,%esp
80100e02:	ff 75 d8             	pushl  -0x28(%ebp)
80100e05:	e8 dc 0f 00 00       	call   80101de6 <iunlockput>
80100e0a:	83 c4 10             	add    $0x10,%esp
  end_op();
80100e0d:	e8 f8 2a 00 00       	call   8010390a <end_op>
  ip = 0;
80100e12:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100e19:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e1c:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100e26:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e29:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e2c:	05 00 20 00 00       	add    $0x2000,%eax
80100e31:	83 ec 04             	sub    $0x4,%esp
80100e34:	50                   	push   %eax
80100e35:	ff 75 e0             	pushl  -0x20(%ebp)
80100e38:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e3b:	e8 64 90 00 00       	call   80109ea4 <allocuvm>
80100e40:	83 c4 10             	add    $0x10,%esp
80100e43:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e46:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e4a:	0f 84 37 02 00 00    	je     80101087 <exec+0x465>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100e50:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e53:	2d 00 20 00 00       	sub    $0x2000,%eax
80100e58:	83 ec 08             	sub    $0x8,%esp
80100e5b:	50                   	push   %eax
80100e5c:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e5f:	e8 66 92 00 00       	call   8010a0ca <clearpteu>
80100e64:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100e67:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e6a:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100e6d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100e74:	e9 96 00 00 00       	jmp    80100f0f <exec+0x2ed>
    if(argc >= MAXARG)
80100e79:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100e7d:	0f 87 07 02 00 00    	ja     8010108a <exec+0x468>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e90:	01 d0                	add    %edx,%eax
80100e92:	8b 00                	mov    (%eax),%eax
80100e94:	83 ec 0c             	sub    $0xc,%esp
80100e97:	50                   	push   %eax
80100e98:	e8 e0 60 00 00       	call   80106f7d <strlen>
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	89 c2                	mov    %eax,%edx
80100ea2:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ea5:	29 d0                	sub    %edx,%eax
80100ea7:	83 e8 01             	sub    $0x1,%eax
80100eaa:	83 e0 fc             	and    $0xfffffffc,%eax
80100ead:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100eb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100eb3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100eba:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ebd:	01 d0                	add    %edx,%eax
80100ebf:	8b 00                	mov    (%eax),%eax
80100ec1:	83 ec 0c             	sub    $0xc,%esp
80100ec4:	50                   	push   %eax
80100ec5:	e8 b3 60 00 00       	call   80106f7d <strlen>
80100eca:	83 c4 10             	add    $0x10,%esp
80100ecd:	83 c0 01             	add    $0x1,%eax
80100ed0:	89 c1                	mov    %eax,%ecx
80100ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ed5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100edc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100edf:	01 d0                	add    %edx,%eax
80100ee1:	8b 00                	mov    (%eax),%eax
80100ee3:	51                   	push   %ecx
80100ee4:	50                   	push   %eax
80100ee5:	ff 75 dc             	pushl  -0x24(%ebp)
80100ee8:	ff 75 d4             	pushl  -0x2c(%ebp)
80100eeb:	e8 91 93 00 00       	call   8010a281 <copyout>
80100ef0:	83 c4 10             	add    $0x10,%esp
80100ef3:	85 c0                	test   %eax,%eax
80100ef5:	0f 88 92 01 00 00    	js     8010108d <exec+0x46b>
      goto bad;
    ustack[3+argc] = sp;
80100efb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100efe:	8d 50 03             	lea    0x3(%eax),%edx
80100f01:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f04:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f0b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100f0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f12:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f19:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f1c:	01 d0                	add    %edx,%eax
80100f1e:	8b 00                	mov    (%eax),%eax
80100f20:	85 c0                	test   %eax,%eax
80100f22:	0f 85 51 ff ff ff    	jne    80100e79 <exec+0x257>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f2b:	83 c0 03             	add    $0x3,%eax
80100f2e:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100f35:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100f39:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100f40:	ff ff ff 
  ustack[1] = argc;
80100f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f46:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100f4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f4f:	83 c0 01             	add    $0x1,%eax
80100f52:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f59:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f5c:	29 d0                	sub    %edx,%eax
80100f5e:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f67:	83 c0 04             	add    $0x4,%eax
80100f6a:	c1 e0 02             	shl    $0x2,%eax
80100f6d:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100f70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f73:	83 c0 04             	add    $0x4,%eax
80100f76:	c1 e0 02             	shl    $0x2,%eax
80100f79:	50                   	push   %eax
80100f7a:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100f80:	50                   	push   %eax
80100f81:	ff 75 dc             	pushl  -0x24(%ebp)
80100f84:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f87:	e8 f5 92 00 00       	call   8010a281 <copyout>
80100f8c:	83 c4 10             	add    $0x10,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	0f 88 f9 00 00 00    	js     80101090 <exec+0x46e>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100f97:	8b 45 08             	mov    0x8(%ebp),%eax
80100f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100f9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa0:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100fa3:	eb 17                	jmp    80100fbc <exec+0x39a>
    if(*s == '/')
80100fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa8:	0f b6 00             	movzbl (%eax),%eax
80100fab:	3c 2f                	cmp    $0x2f,%al
80100fad:	75 09                	jne    80100fb8 <exec+0x396>
      last = s+1;
80100faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fb2:	83 c0 01             	add    $0x1,%eax
80100fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100fb8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fbf:	0f b6 00             	movzbl (%eax),%eax
80100fc2:	84 c0                	test   %al,%al
80100fc4:	75 df                	jne    80100fa5 <exec+0x383>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100fc6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fcc:	83 c0 6c             	add    $0x6c,%eax
80100fcf:	83 ec 04             	sub    $0x4,%esp
80100fd2:	6a 10                	push   $0x10
80100fd4:	ff 75 f0             	pushl  -0x10(%ebp)
80100fd7:	50                   	push   %eax
80100fd8:	e8 56 5f 00 00       	call   80106f33 <safestrcpy>
80100fdd:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100fe0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100fe6:	8b 40 04             	mov    0x4(%eax),%eax
80100fe9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100fec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ff2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ff5:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100ff8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ffe:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101001:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80101003:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101009:	8b 40 18             	mov    0x18(%eax),%eax
8010100c:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80101012:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80101015:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010101b:	8b 40 18             	mov    0x18(%eax),%eax
8010101e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101021:	89 50 44             	mov    %edx,0x44(%eax)
#ifdef CS333_P5
  // change process's UID if flag is on
  if (st.mode.flags.setuid) {
80101024:	0f b6 85 e5 fe ff ff 	movzbl -0x11b(%ebp),%eax
8010102b:	83 e0 02             	and    $0x2,%eax
8010102e:	84 c0                	test   %al,%al
80101030:	74 16                	je     80101048 <exec+0x426>
      proc->uid = st.uid;
80101032:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101038:	0f b7 95 de fe ff ff 	movzwl -0x122(%ebp),%edx
8010103f:	0f b7 d2             	movzwl %dx,%edx
80101042:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  }
#endif
  switchuvm(proc);
80101048:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010104e:	83 ec 0c             	sub    $0xc,%esp
80101051:	50                   	push   %eax
80101052:	e8 8d 8b 00 00       	call   80109be4 <switchuvm>
80101057:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
8010105a:	83 ec 0c             	sub    $0xc,%esp
8010105d:	ff 75 d0             	pushl  -0x30(%ebp)
80101060:	e8 c5 8f 00 00       	call   8010a02a <freevm>
80101065:	83 c4 10             	add    $0x10,%esp
  return 0;
80101068:	b8 00 00 00 00       	mov    $0x0,%eax
8010106d:	eb 54                	jmp    801010c3 <exec+0x4a1>
  }
  else if (st.mode.flags.o_x) {
      goto good; // Other permission is good, execute
  }
  else {
      goto bad; // No permissions, exec fails
8010106f:	90                   	nop
80101070:	eb 1f                	jmp    80101091 <exec+0x46f>
good:
#endif

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80101072:	90                   	nop
80101073:	eb 1c                	jmp    80101091 <exec+0x46f>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80101075:	90                   	nop
80101076:	eb 19                	jmp    80101091 <exec+0x46f>

  if((pgdir = setupkvm()) == 0)
    goto bad;
80101078:	90                   	nop
80101079:	eb 16                	jmp    80101091 <exec+0x46f>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
8010107b:	90                   	nop
8010107c:	eb 13                	jmp    80101091 <exec+0x46f>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
8010107e:	90                   	nop
8010107f:	eb 10                	jmp    80101091 <exec+0x46f>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80101081:	90                   	nop
80101082:	eb 0d                	jmp    80101091 <exec+0x46f>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80101084:	90                   	nop
80101085:	eb 0a                	jmp    80101091 <exec+0x46f>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80101087:	90                   	nop
80101088:	eb 07                	jmp    80101091 <exec+0x46f>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
8010108a:	90                   	nop
8010108b:	eb 04                	jmp    80101091 <exec+0x46f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
8010108d:	90                   	nop
8010108e:	eb 01                	jmp    80101091 <exec+0x46f>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80101090:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80101091:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80101095:	74 0e                	je     801010a5 <exec+0x483>
    freevm(pgdir);
80101097:	83 ec 0c             	sub    $0xc,%esp
8010109a:	ff 75 d4             	pushl  -0x2c(%ebp)
8010109d:	e8 88 8f 00 00       	call   8010a02a <freevm>
801010a2:	83 c4 10             	add    $0x10,%esp
  if(ip){
801010a5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801010a9:	74 13                	je     801010be <exec+0x49c>
    iunlockput(ip);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	ff 75 d8             	pushl  -0x28(%ebp)
801010b1:	e8 30 0d 00 00       	call   80101de6 <iunlockput>
801010b6:	83 c4 10             	add    $0x10,%esp
    end_op();
801010b9:	e8 4c 28 00 00       	call   8010390a <end_op>
  }
  return -1;
801010be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010c3:	c9                   	leave  
801010c4:	c3                   	ret    

801010c5 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
801010c5:	55                   	push   %ebp
801010c6:	89 e5                	mov    %esp,%ebp
801010c8:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
801010cb:	83 ec 08             	sub    $0x8,%esp
801010ce:	68 86 a3 10 80       	push   $0x8010a386
801010d3:	68 60 38 11 80       	push   $0x80113860
801010d8:	e8 ce 59 00 00       	call   80106aab <initlock>
801010dd:	83 c4 10             	add    $0x10,%esp
}
801010e0:	90                   	nop
801010e1:	c9                   	leave  
801010e2:	c3                   	ret    

801010e3 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
801010e3:	55                   	push   %ebp
801010e4:	89 e5                	mov    %esp,%ebp
801010e6:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
801010e9:	83 ec 0c             	sub    $0xc,%esp
801010ec:	68 60 38 11 80       	push   $0x80113860
801010f1:	e8 d7 59 00 00       	call   80106acd <acquire>
801010f6:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
801010f9:	c7 45 f4 94 38 11 80 	movl   $0x80113894,-0xc(%ebp)
80101100:	eb 2d                	jmp    8010112f <filealloc+0x4c>
    if(f->ref == 0){
80101102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101105:	8b 40 04             	mov    0x4(%eax),%eax
80101108:	85 c0                	test   %eax,%eax
8010110a:	75 1f                	jne    8010112b <filealloc+0x48>
      f->ref = 1;
8010110c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010110f:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101116:	83 ec 0c             	sub    $0xc,%esp
80101119:	68 60 38 11 80       	push   $0x80113860
8010111e:	e8 11 5a 00 00       	call   80106b34 <release>
80101123:	83 c4 10             	add    $0x10,%esp
      return f;
80101126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101129:	eb 23                	jmp    8010114e <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010112b:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010112f:	b8 f4 41 11 80       	mov    $0x801141f4,%eax
80101134:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101137:	72 c9                	jb     80101102 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80101139:	83 ec 0c             	sub    $0xc,%esp
8010113c:	68 60 38 11 80       	push   $0x80113860
80101141:	e8 ee 59 00 00       	call   80106b34 <release>
80101146:	83 c4 10             	add    $0x10,%esp
  return 0;
80101149:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010114e:	c9                   	leave  
8010114f:	c3                   	ret    

80101150 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101156:	83 ec 0c             	sub    $0xc,%esp
80101159:	68 60 38 11 80       	push   $0x80113860
8010115e:	e8 6a 59 00 00       	call   80106acd <acquire>
80101163:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101166:	8b 45 08             	mov    0x8(%ebp),%eax
80101169:	8b 40 04             	mov    0x4(%eax),%eax
8010116c:	85 c0                	test   %eax,%eax
8010116e:	7f 0d                	jg     8010117d <filedup+0x2d>
    panic("filedup");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 8d a3 10 80       	push   $0x8010a38d
80101178:	e8 e9 f3 ff ff       	call   80100566 <panic>
  f->ref++;
8010117d:	8b 45 08             	mov    0x8(%ebp),%eax
80101180:	8b 40 04             	mov    0x4(%eax),%eax
80101183:	8d 50 01             	lea    0x1(%eax),%edx
80101186:	8b 45 08             	mov    0x8(%ebp),%eax
80101189:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010118c:	83 ec 0c             	sub    $0xc,%esp
8010118f:	68 60 38 11 80       	push   $0x80113860
80101194:	e8 9b 59 00 00       	call   80106b34 <release>
80101199:	83 c4 10             	add    $0x10,%esp
  return f;
8010119c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010119f:	c9                   	leave  
801011a0:	c3                   	ret    

801011a1 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011a1:	55                   	push   %ebp
801011a2:	89 e5                	mov    %esp,%ebp
801011a4:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801011a7:	83 ec 0c             	sub    $0xc,%esp
801011aa:	68 60 38 11 80       	push   $0x80113860
801011af:	e8 19 59 00 00       	call   80106acd <acquire>
801011b4:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801011b7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ba:	8b 40 04             	mov    0x4(%eax),%eax
801011bd:	85 c0                	test   %eax,%eax
801011bf:	7f 0d                	jg     801011ce <fileclose+0x2d>
    panic("fileclose");
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	68 95 a3 10 80       	push   $0x8010a395
801011c9:	e8 98 f3 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
801011ce:	8b 45 08             	mov    0x8(%ebp),%eax
801011d1:	8b 40 04             	mov    0x4(%eax),%eax
801011d4:	8d 50 ff             	lea    -0x1(%eax),%edx
801011d7:	8b 45 08             	mov    0x8(%ebp),%eax
801011da:	89 50 04             	mov    %edx,0x4(%eax)
801011dd:	8b 45 08             	mov    0x8(%ebp),%eax
801011e0:	8b 40 04             	mov    0x4(%eax),%eax
801011e3:	85 c0                	test   %eax,%eax
801011e5:	7e 15                	jle    801011fc <fileclose+0x5b>
    release(&ftable.lock);
801011e7:	83 ec 0c             	sub    $0xc,%esp
801011ea:	68 60 38 11 80       	push   $0x80113860
801011ef:	e8 40 59 00 00       	call   80106b34 <release>
801011f4:	83 c4 10             	add    $0x10,%esp
801011f7:	e9 8b 00 00 00       	jmp    80101287 <fileclose+0xe6>
    return;
  }
  ff = *f;
801011fc:	8b 45 08             	mov    0x8(%ebp),%eax
801011ff:	8b 10                	mov    (%eax),%edx
80101201:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101204:	8b 50 04             	mov    0x4(%eax),%edx
80101207:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010120a:	8b 50 08             	mov    0x8(%eax),%edx
8010120d:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101210:	8b 50 0c             	mov    0xc(%eax),%edx
80101213:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101216:	8b 50 10             	mov    0x10(%eax),%edx
80101219:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010121c:	8b 40 14             	mov    0x14(%eax),%eax
8010121f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101222:	8b 45 08             	mov    0x8(%ebp),%eax
80101225:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010122c:	8b 45 08             	mov    0x8(%ebp),%eax
8010122f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101235:	83 ec 0c             	sub    $0xc,%esp
80101238:	68 60 38 11 80       	push   $0x80113860
8010123d:	e8 f2 58 00 00       	call   80106b34 <release>
80101242:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101245:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101248:	83 f8 01             	cmp    $0x1,%eax
8010124b:	75 19                	jne    80101266 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010124d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101251:	0f be d0             	movsbl %al,%edx
80101254:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101257:	83 ec 08             	sub    $0x8,%esp
8010125a:	52                   	push   %edx
8010125b:	50                   	push   %eax
8010125c:	e8 64 32 00 00       	call   801044c5 <pipeclose>
80101261:	83 c4 10             	add    $0x10,%esp
80101264:	eb 21                	jmp    80101287 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101266:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101269:	83 f8 02             	cmp    $0x2,%eax
8010126c:	75 19                	jne    80101287 <fileclose+0xe6>
    begin_op();
8010126e:	e8 0b 26 00 00       	call   8010387e <begin_op>
    iput(ff.ip);
80101273:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101276:	83 ec 0c             	sub    $0xc,%esp
80101279:	50                   	push   %eax
8010127a:	e8 77 0a 00 00       	call   80101cf6 <iput>
8010127f:	83 c4 10             	add    $0x10,%esp
    end_op();
80101282:	e8 83 26 00 00       	call   8010390a <end_op>
  }
}
80101287:	c9                   	leave  
80101288:	c3                   	ret    

80101289 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101289:	55                   	push   %ebp
8010128a:	89 e5                	mov    %esp,%ebp
8010128c:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010128f:	8b 45 08             	mov    0x8(%ebp),%eax
80101292:	8b 00                	mov    (%eax),%eax
80101294:	83 f8 02             	cmp    $0x2,%eax
80101297:	75 40                	jne    801012d9 <filestat+0x50>
    ilock(f->ip);
80101299:	8b 45 08             	mov    0x8(%ebp),%eax
8010129c:	8b 40 10             	mov    0x10(%eax),%eax
8010129f:	83 ec 0c             	sub    $0xc,%esp
801012a2:	50                   	push   %eax
801012a3:	e8 56 08 00 00       	call   80101afe <ilock>
801012a8:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801012ab:	8b 45 08             	mov    0x8(%ebp),%eax
801012ae:	8b 40 10             	mov    0x10(%eax),%eax
801012b1:	83 ec 08             	sub    $0x8,%esp
801012b4:	ff 75 0c             	pushl  0xc(%ebp)
801012b7:	50                   	push   %eax
801012b8:	e8 91 0d 00 00       	call   8010204e <stati>
801012bd:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
801012c0:	8b 45 08             	mov    0x8(%ebp),%eax
801012c3:	8b 40 10             	mov    0x10(%eax),%eax
801012c6:	83 ec 0c             	sub    $0xc,%esp
801012c9:	50                   	push   %eax
801012ca:	e8 b5 09 00 00       	call   80101c84 <iunlock>
801012cf:	83 c4 10             	add    $0x10,%esp
    return 0;
801012d2:	b8 00 00 00 00       	mov    $0x0,%eax
801012d7:	eb 05                	jmp    801012de <filestat+0x55>
  }
  return -1;
801012d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801012de:	c9                   	leave  
801012df:	c3                   	ret    

801012e0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801012e6:	8b 45 08             	mov    0x8(%ebp),%eax
801012e9:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801012ed:	84 c0                	test   %al,%al
801012ef:	75 0a                	jne    801012fb <fileread+0x1b>
    return -1;
801012f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012f6:	e9 9b 00 00 00       	jmp    80101396 <fileread+0xb6>
  if(f->type == FD_PIPE)
801012fb:	8b 45 08             	mov    0x8(%ebp),%eax
801012fe:	8b 00                	mov    (%eax),%eax
80101300:	83 f8 01             	cmp    $0x1,%eax
80101303:	75 1a                	jne    8010131f <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101305:	8b 45 08             	mov    0x8(%ebp),%eax
80101308:	8b 40 0c             	mov    0xc(%eax),%eax
8010130b:	83 ec 04             	sub    $0x4,%esp
8010130e:	ff 75 10             	pushl  0x10(%ebp)
80101311:	ff 75 0c             	pushl  0xc(%ebp)
80101314:	50                   	push   %eax
80101315:	e8 53 33 00 00       	call   8010466d <piperead>
8010131a:	83 c4 10             	add    $0x10,%esp
8010131d:	eb 77                	jmp    80101396 <fileread+0xb6>
  if(f->type == FD_INODE){
8010131f:	8b 45 08             	mov    0x8(%ebp),%eax
80101322:	8b 00                	mov    (%eax),%eax
80101324:	83 f8 02             	cmp    $0x2,%eax
80101327:	75 60                	jne    80101389 <fileread+0xa9>
    ilock(f->ip);
80101329:	8b 45 08             	mov    0x8(%ebp),%eax
8010132c:	8b 40 10             	mov    0x10(%eax),%eax
8010132f:	83 ec 0c             	sub    $0xc,%esp
80101332:	50                   	push   %eax
80101333:	e8 c6 07 00 00       	call   80101afe <ilock>
80101338:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010133b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010133e:	8b 45 08             	mov    0x8(%ebp),%eax
80101341:	8b 50 14             	mov    0x14(%eax),%edx
80101344:	8b 45 08             	mov    0x8(%ebp),%eax
80101347:	8b 40 10             	mov    0x10(%eax),%eax
8010134a:	51                   	push   %ecx
8010134b:	52                   	push   %edx
8010134c:	ff 75 0c             	pushl  0xc(%ebp)
8010134f:	50                   	push   %eax
80101350:	e8 67 0d 00 00       	call   801020bc <readi>
80101355:	83 c4 10             	add    $0x10,%esp
80101358:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010135b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010135f:	7e 11                	jle    80101372 <fileread+0x92>
      f->off += r;
80101361:	8b 45 08             	mov    0x8(%ebp),%eax
80101364:	8b 50 14             	mov    0x14(%eax),%edx
80101367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136a:	01 c2                	add    %eax,%edx
8010136c:	8b 45 08             	mov    0x8(%ebp),%eax
8010136f:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101372:	8b 45 08             	mov    0x8(%ebp),%eax
80101375:	8b 40 10             	mov    0x10(%eax),%eax
80101378:	83 ec 0c             	sub    $0xc,%esp
8010137b:	50                   	push   %eax
8010137c:	e8 03 09 00 00       	call   80101c84 <iunlock>
80101381:	83 c4 10             	add    $0x10,%esp
    return r;
80101384:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101387:	eb 0d                	jmp    80101396 <fileread+0xb6>
  }
  panic("fileread");
80101389:	83 ec 0c             	sub    $0xc,%esp
8010138c:	68 9f a3 10 80       	push   $0x8010a39f
80101391:	e8 d0 f1 ff ff       	call   80100566 <panic>
}
80101396:	c9                   	leave  
80101397:	c3                   	ret    

80101398 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101398:	55                   	push   %ebp
80101399:	89 e5                	mov    %esp,%ebp
8010139b:	53                   	push   %ebx
8010139c:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010139f:	8b 45 08             	mov    0x8(%ebp),%eax
801013a2:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801013a6:	84 c0                	test   %al,%al
801013a8:	75 0a                	jne    801013b4 <filewrite+0x1c>
    return -1;
801013aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801013af:	e9 1b 01 00 00       	jmp    801014cf <filewrite+0x137>
  if(f->type == FD_PIPE)
801013b4:	8b 45 08             	mov    0x8(%ebp),%eax
801013b7:	8b 00                	mov    (%eax),%eax
801013b9:	83 f8 01             	cmp    $0x1,%eax
801013bc:	75 1d                	jne    801013db <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
801013be:	8b 45 08             	mov    0x8(%ebp),%eax
801013c1:	8b 40 0c             	mov    0xc(%eax),%eax
801013c4:	83 ec 04             	sub    $0x4,%esp
801013c7:	ff 75 10             	pushl  0x10(%ebp)
801013ca:	ff 75 0c             	pushl  0xc(%ebp)
801013cd:	50                   	push   %eax
801013ce:	e8 9c 31 00 00       	call   8010456f <pipewrite>
801013d3:	83 c4 10             	add    $0x10,%esp
801013d6:	e9 f4 00 00 00       	jmp    801014cf <filewrite+0x137>
  if(f->type == FD_INODE){
801013db:	8b 45 08             	mov    0x8(%ebp),%eax
801013de:	8b 00                	mov    (%eax),%eax
801013e0:	83 f8 02             	cmp    $0x2,%eax
801013e3:	0f 85 d9 00 00 00    	jne    801014c2 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801013e9:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801013f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801013f7:	e9 a3 00 00 00       	jmp    8010149f <filewrite+0x107>
      int n1 = n - i;
801013fc:	8b 45 10             	mov    0x10(%ebp),%eax
801013ff:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101402:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101405:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101408:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010140b:	7e 06                	jle    80101413 <filewrite+0x7b>
        n1 = max;
8010140d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101410:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101413:	e8 66 24 00 00       	call   8010387e <begin_op>
      ilock(f->ip);
80101418:	8b 45 08             	mov    0x8(%ebp),%eax
8010141b:	8b 40 10             	mov    0x10(%eax),%eax
8010141e:	83 ec 0c             	sub    $0xc,%esp
80101421:	50                   	push   %eax
80101422:	e8 d7 06 00 00       	call   80101afe <ilock>
80101427:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010142a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010142d:	8b 45 08             	mov    0x8(%ebp),%eax
80101430:	8b 50 14             	mov    0x14(%eax),%edx
80101433:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101436:	8b 45 0c             	mov    0xc(%ebp),%eax
80101439:	01 c3                	add    %eax,%ebx
8010143b:	8b 45 08             	mov    0x8(%ebp),%eax
8010143e:	8b 40 10             	mov    0x10(%eax),%eax
80101441:	51                   	push   %ecx
80101442:	52                   	push   %edx
80101443:	53                   	push   %ebx
80101444:	50                   	push   %eax
80101445:	e8 c9 0d 00 00       	call   80102213 <writei>
8010144a:	83 c4 10             	add    $0x10,%esp
8010144d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80101450:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101454:	7e 11                	jle    80101467 <filewrite+0xcf>
        f->off += r;
80101456:	8b 45 08             	mov    0x8(%ebp),%eax
80101459:	8b 50 14             	mov    0x14(%eax),%edx
8010145c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010145f:	01 c2                	add    %eax,%edx
80101461:	8b 45 08             	mov    0x8(%ebp),%eax
80101464:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101467:	8b 45 08             	mov    0x8(%ebp),%eax
8010146a:	8b 40 10             	mov    0x10(%eax),%eax
8010146d:	83 ec 0c             	sub    $0xc,%esp
80101470:	50                   	push   %eax
80101471:	e8 0e 08 00 00       	call   80101c84 <iunlock>
80101476:	83 c4 10             	add    $0x10,%esp
      end_op();
80101479:	e8 8c 24 00 00       	call   8010390a <end_op>

      if(r < 0)
8010147e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101482:	78 29                	js     801014ad <filewrite+0x115>
        break;
      if(r != n1)
80101484:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101487:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010148a:	74 0d                	je     80101499 <filewrite+0x101>
        panic("short filewrite");
8010148c:	83 ec 0c             	sub    $0xc,%esp
8010148f:	68 a8 a3 10 80       	push   $0x8010a3a8
80101494:	e8 cd f0 ff ff       	call   80100566 <panic>
      i += r;
80101499:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010149c:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010149f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014a2:	3b 45 10             	cmp    0x10(%ebp),%eax
801014a5:	0f 8c 51 ff ff ff    	jl     801013fc <filewrite+0x64>
801014ab:	eb 01                	jmp    801014ae <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801014ad:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801014ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014b1:	3b 45 10             	cmp    0x10(%ebp),%eax
801014b4:	75 05                	jne    801014bb <filewrite+0x123>
801014b6:	8b 45 10             	mov    0x10(%ebp),%eax
801014b9:	eb 14                	jmp    801014cf <filewrite+0x137>
801014bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801014c0:	eb 0d                	jmp    801014cf <filewrite+0x137>
  }
  panic("filewrite");
801014c2:	83 ec 0c             	sub    $0xc,%esp
801014c5:	68 b8 a3 10 80       	push   $0x8010a3b8
801014ca:	e8 97 f0 ff ff       	call   80100566 <panic>
}
801014cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014d2:	c9                   	leave  
801014d3:	c3                   	ret    

801014d4 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801014d4:	55                   	push   %ebp
801014d5:	89 e5                	mov    %esp,%ebp
801014d7:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801014da:	8b 45 08             	mov    0x8(%ebp),%eax
801014dd:	83 ec 08             	sub    $0x8,%esp
801014e0:	6a 01                	push   $0x1
801014e2:	50                   	push   %eax
801014e3:	e8 ce ec ff ff       	call   801001b6 <bread>
801014e8:	83 c4 10             	add    $0x10,%esp
801014eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801014ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014f1:	83 c0 18             	add    $0x18,%eax
801014f4:	83 ec 04             	sub    $0x4,%esp
801014f7:	6a 1c                	push   $0x1c
801014f9:	50                   	push   %eax
801014fa:	ff 75 0c             	pushl  0xc(%ebp)
801014fd:	e8 ed 58 00 00       	call   80106def <memmove>
80101502:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101505:	83 ec 0c             	sub    $0xc,%esp
80101508:	ff 75 f4             	pushl  -0xc(%ebp)
8010150b:	e8 1e ed ff ff       	call   8010022e <brelse>
80101510:	83 c4 10             	add    $0x10,%esp
}
80101513:	90                   	nop
80101514:	c9                   	leave  
80101515:	c3                   	ret    

80101516 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101516:	55                   	push   %ebp
80101517:	89 e5                	mov    %esp,%ebp
80101519:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010151c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010151f:	8b 45 08             	mov    0x8(%ebp),%eax
80101522:	83 ec 08             	sub    $0x8,%esp
80101525:	52                   	push   %edx
80101526:	50                   	push   %eax
80101527:	e8 8a ec ff ff       	call   801001b6 <bread>
8010152c:	83 c4 10             	add    $0x10,%esp
8010152f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101532:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101535:	83 c0 18             	add    $0x18,%eax
80101538:	83 ec 04             	sub    $0x4,%esp
8010153b:	68 00 02 00 00       	push   $0x200
80101540:	6a 00                	push   $0x0
80101542:	50                   	push   %eax
80101543:	e8 e8 57 00 00       	call   80106d30 <memset>
80101548:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010154b:	83 ec 0c             	sub    $0xc,%esp
8010154e:	ff 75 f4             	pushl  -0xc(%ebp)
80101551:	e8 60 25 00 00       	call   80103ab6 <log_write>
80101556:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101559:	83 ec 0c             	sub    $0xc,%esp
8010155c:	ff 75 f4             	pushl  -0xc(%ebp)
8010155f:	e8 ca ec ff ff       	call   8010022e <brelse>
80101564:	83 c4 10             	add    $0x10,%esp
}
80101567:	90                   	nop
80101568:	c9                   	leave  
80101569:	c3                   	ret    

8010156a <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010156a:	55                   	push   %ebp
8010156b:	89 e5                	mov    %esp,%ebp
8010156d:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
80101570:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101577:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010157e:	e9 13 01 00 00       	jmp    80101696 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
80101583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101586:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
8010158c:	85 c0                	test   %eax,%eax
8010158e:	0f 48 c2             	cmovs  %edx,%eax
80101591:	c1 f8 0c             	sar    $0xc,%eax
80101594:	89 c2                	mov    %eax,%edx
80101596:	a1 78 42 11 80       	mov    0x80114278,%eax
8010159b:	01 d0                	add    %edx,%eax
8010159d:	83 ec 08             	sub    $0x8,%esp
801015a0:	50                   	push   %eax
801015a1:	ff 75 08             	pushl  0x8(%ebp)
801015a4:	e8 0d ec ff ff       	call   801001b6 <bread>
801015a9:	83 c4 10             	add    $0x10,%esp
801015ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801015af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801015b6:	e9 a6 00 00 00       	jmp    80101661 <balloc+0xf7>
      m = 1 << (bi % 8);
801015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015be:	99                   	cltd   
801015bf:	c1 ea 1d             	shr    $0x1d,%edx
801015c2:	01 d0                	add    %edx,%eax
801015c4:	83 e0 07             	and    $0x7,%eax
801015c7:	29 d0                	sub    %edx,%eax
801015c9:	ba 01 00 00 00       	mov    $0x1,%edx
801015ce:	89 c1                	mov    %eax,%ecx
801015d0:	d3 e2                	shl    %cl,%edx
801015d2:	89 d0                	mov    %edx,%eax
801015d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015da:	8d 50 07             	lea    0x7(%eax),%edx
801015dd:	85 c0                	test   %eax,%eax
801015df:	0f 48 c2             	cmovs  %edx,%eax
801015e2:	c1 f8 03             	sar    $0x3,%eax
801015e5:	89 c2                	mov    %eax,%edx
801015e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801015ea:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015ef:	0f b6 c0             	movzbl %al,%eax
801015f2:	23 45 e8             	and    -0x18(%ebp),%eax
801015f5:	85 c0                	test   %eax,%eax
801015f7:	75 64                	jne    8010165d <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
801015f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015fc:	8d 50 07             	lea    0x7(%eax),%edx
801015ff:	85 c0                	test   %eax,%eax
80101601:	0f 48 c2             	cmovs  %edx,%eax
80101604:	c1 f8 03             	sar    $0x3,%eax
80101607:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010160a:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010160f:	89 d1                	mov    %edx,%ecx
80101611:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101614:	09 ca                	or     %ecx,%edx
80101616:	89 d1                	mov    %edx,%ecx
80101618:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010161b:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
8010161f:	83 ec 0c             	sub    $0xc,%esp
80101622:	ff 75 ec             	pushl  -0x14(%ebp)
80101625:	e8 8c 24 00 00       	call   80103ab6 <log_write>
8010162a:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010162d:	83 ec 0c             	sub    $0xc,%esp
80101630:	ff 75 ec             	pushl  -0x14(%ebp)
80101633:	e8 f6 eb ff ff       	call   8010022e <brelse>
80101638:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010163b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010163e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101641:	01 c2                	add    %eax,%edx
80101643:	8b 45 08             	mov    0x8(%ebp),%eax
80101646:	83 ec 08             	sub    $0x8,%esp
80101649:	52                   	push   %edx
8010164a:	50                   	push   %eax
8010164b:	e8 c6 fe ff ff       	call   80101516 <bzero>
80101650:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101653:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101656:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101659:	01 d0                	add    %edx,%eax
8010165b:	eb 57                	jmp    801016b4 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010165d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101661:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101668:	7f 17                	jg     80101681 <balloc+0x117>
8010166a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101670:	01 d0                	add    %edx,%eax
80101672:	89 c2                	mov    %eax,%edx
80101674:	a1 60 42 11 80       	mov    0x80114260,%eax
80101679:	39 c2                	cmp    %eax,%edx
8010167b:	0f 82 3a ff ff ff    	jb     801015bb <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101681:	83 ec 0c             	sub    $0xc,%esp
80101684:	ff 75 ec             	pushl  -0x14(%ebp)
80101687:	e8 a2 eb ff ff       	call   8010022e <brelse>
8010168c:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010168f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101696:	8b 15 60 42 11 80    	mov    0x80114260,%edx
8010169c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010169f:	39 c2                	cmp    %eax,%edx
801016a1:	0f 87 dc fe ff ff    	ja     80101583 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801016a7:	83 ec 0c             	sub    $0xc,%esp
801016aa:	68 c4 a3 10 80       	push   $0x8010a3c4
801016af:	e8 b2 ee ff ff       	call   80100566 <panic>
}
801016b4:	c9                   	leave  
801016b5:	c3                   	ret    

801016b6 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
801016b6:	55                   	push   %ebp
801016b7:	89 e5                	mov    %esp,%ebp
801016b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801016bc:	83 ec 08             	sub    $0x8,%esp
801016bf:	68 60 42 11 80       	push   $0x80114260
801016c4:	ff 75 08             	pushl  0x8(%ebp)
801016c7:	e8 08 fe ff ff       	call   801014d4 <readsb>
801016cc:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801016cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801016d2:	c1 e8 0c             	shr    $0xc,%eax
801016d5:	89 c2                	mov    %eax,%edx
801016d7:	a1 78 42 11 80       	mov    0x80114278,%eax
801016dc:	01 c2                	add    %eax,%edx
801016de:	8b 45 08             	mov    0x8(%ebp),%eax
801016e1:	83 ec 08             	sub    $0x8,%esp
801016e4:	52                   	push   %edx
801016e5:	50                   	push   %eax
801016e6:	e8 cb ea ff ff       	call   801001b6 <bread>
801016eb:	83 c4 10             	add    $0x10,%esp
801016ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801016f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801016f4:	25 ff 0f 00 00       	and    $0xfff,%eax
801016f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801016fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016ff:	99                   	cltd   
80101700:	c1 ea 1d             	shr    $0x1d,%edx
80101703:	01 d0                	add    %edx,%eax
80101705:	83 e0 07             	and    $0x7,%eax
80101708:	29 d0                	sub    %edx,%eax
8010170a:	ba 01 00 00 00       	mov    $0x1,%edx
8010170f:	89 c1                	mov    %eax,%ecx
80101711:	d3 e2                	shl    %cl,%edx
80101713:	89 d0                	mov    %edx,%eax
80101715:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101718:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010171b:	8d 50 07             	lea    0x7(%eax),%edx
8010171e:	85 c0                	test   %eax,%eax
80101720:	0f 48 c2             	cmovs  %edx,%eax
80101723:	c1 f8 03             	sar    $0x3,%eax
80101726:	89 c2                	mov    %eax,%edx
80101728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010172b:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101730:	0f b6 c0             	movzbl %al,%eax
80101733:	23 45 ec             	and    -0x14(%ebp),%eax
80101736:	85 c0                	test   %eax,%eax
80101738:	75 0d                	jne    80101747 <bfree+0x91>
    panic("freeing free block");
8010173a:	83 ec 0c             	sub    $0xc,%esp
8010173d:	68 da a3 10 80       	push   $0x8010a3da
80101742:	e8 1f ee ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
80101747:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010174a:	8d 50 07             	lea    0x7(%eax),%edx
8010174d:	85 c0                	test   %eax,%eax
8010174f:	0f 48 c2             	cmovs  %edx,%eax
80101752:	c1 f8 03             	sar    $0x3,%eax
80101755:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101758:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010175d:	89 d1                	mov    %edx,%ecx
8010175f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101762:	f7 d2                	not    %edx
80101764:	21 ca                	and    %ecx,%edx
80101766:	89 d1                	mov    %edx,%ecx
80101768:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010176b:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010176f:	83 ec 0c             	sub    $0xc,%esp
80101772:	ff 75 f4             	pushl  -0xc(%ebp)
80101775:	e8 3c 23 00 00       	call   80103ab6 <log_write>
8010177a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010177d:	83 ec 0c             	sub    $0xc,%esp
80101780:	ff 75 f4             	pushl  -0xc(%ebp)
80101783:	e8 a6 ea ff ff       	call   8010022e <brelse>
80101788:	83 c4 10             	add    $0x10,%esp
}
8010178b:	90                   	nop
8010178c:	c9                   	leave  
8010178d:	c3                   	ret    

8010178e <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010178e:	55                   	push   %ebp
8010178f:	89 e5                	mov    %esp,%ebp
80101791:	57                   	push   %edi
80101792:	56                   	push   %esi
80101793:	53                   	push   %ebx
80101794:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
80101797:	83 ec 08             	sub    $0x8,%esp
8010179a:	68 ed a3 10 80       	push   $0x8010a3ed
8010179f:	68 80 42 11 80       	push   $0x80114280
801017a4:	e8 02 53 00 00       	call   80106aab <initlock>
801017a9:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801017ac:	83 ec 08             	sub    $0x8,%esp
801017af:	68 60 42 11 80       	push   $0x80114260
801017b4:	ff 75 08             	pushl  0x8(%ebp)
801017b7:	e8 18 fd ff ff       	call   801014d4 <readsb>
801017bc:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
801017bf:	a1 78 42 11 80       	mov    0x80114278,%eax
801017c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801017c7:	8b 3d 74 42 11 80    	mov    0x80114274,%edi
801017cd:	8b 35 70 42 11 80    	mov    0x80114270,%esi
801017d3:	8b 1d 6c 42 11 80    	mov    0x8011426c,%ebx
801017d9:	8b 0d 68 42 11 80    	mov    0x80114268,%ecx
801017df:	8b 15 64 42 11 80    	mov    0x80114264,%edx
801017e5:	a1 60 42 11 80       	mov    0x80114260,%eax
801017ea:	ff 75 e4             	pushl  -0x1c(%ebp)
801017ed:	57                   	push   %edi
801017ee:	56                   	push   %esi
801017ef:	53                   	push   %ebx
801017f0:	51                   	push   %ecx
801017f1:	52                   	push   %edx
801017f2:	50                   	push   %eax
801017f3:	68 f4 a3 10 80       	push   $0x8010a3f4
801017f8:	e8 c9 eb ff ff       	call   801003c6 <cprintf>
801017fd:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101800:	90                   	nop
80101801:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101804:	5b                   	pop    %ebx
80101805:	5e                   	pop    %esi
80101806:	5f                   	pop    %edi
80101807:	5d                   	pop    %ebp
80101808:	c3                   	ret    

80101809 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101809:	55                   	push   %ebp
8010180a:	89 e5                	mov    %esp,%ebp
8010180c:	83 ec 28             	sub    $0x28,%esp
8010180f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101812:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101816:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010181d:	e9 ba 00 00 00       	jmp    801018dc <ialloc+0xd3>
    bp = bread(dev, IBLOCK(inum, sb));
80101822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101825:	c1 e8 03             	shr    $0x3,%eax
80101828:	89 c2                	mov    %eax,%edx
8010182a:	a1 74 42 11 80       	mov    0x80114274,%eax
8010182f:	01 d0                	add    %edx,%eax
80101831:	83 ec 08             	sub    $0x8,%esp
80101834:	50                   	push   %eax
80101835:	ff 75 08             	pushl  0x8(%ebp)
80101838:	e8 79 e9 ff ff       	call   801001b6 <bread>
8010183d:	83 c4 10             	add    $0x10,%esp
80101840:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101843:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101846:	8d 50 18             	lea    0x18(%eax),%edx
80101849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184c:	83 e0 07             	and    $0x7,%eax
8010184f:	c1 e0 06             	shl    $0x6,%eax
80101852:	01 d0                	add    %edx,%eax
80101854:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101857:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010185a:	0f b7 00             	movzwl (%eax),%eax
8010185d:	66 85 c0             	test   %ax,%ax
80101860:	75 68                	jne    801018ca <ialloc+0xc1>
      memset(dip, 0, sizeof(*dip));
80101862:	83 ec 04             	sub    $0x4,%esp
80101865:	6a 40                	push   $0x40
80101867:	6a 00                	push   $0x0
80101869:	ff 75 ec             	pushl  -0x14(%ebp)
8010186c:	e8 bf 54 00 00       	call   80106d30 <memset>
80101871:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101874:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101877:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010187b:	66 89 10             	mov    %dx,(%eax)
#ifdef CS333_P5
      dip->uid = DEFAULT_UID;
8010187e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101881:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
      dip->gid = DEFAULT_GID;
80101887:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010188a:	66 c7 40 0a 00 00    	movw   $0x0,0xa(%eax)
      dip->mode.asInt = DEFAULT_MODE;
80101890:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101893:	c7 40 0c ed 01 00 00 	movl   $0x1ed,0xc(%eax)
#endif
      log_write(bp);   // mark it allocated on the disk
8010189a:	83 ec 0c             	sub    $0xc,%esp
8010189d:	ff 75 f0             	pushl  -0x10(%ebp)
801018a0:	e8 11 22 00 00       	call   80103ab6 <log_write>
801018a5:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801018a8:	83 ec 0c             	sub    $0xc,%esp
801018ab:	ff 75 f0             	pushl  -0x10(%ebp)
801018ae:	e8 7b e9 ff ff       	call   8010022e <brelse>
801018b3:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
801018b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b9:	83 ec 08             	sub    $0x8,%esp
801018bc:	50                   	push   %eax
801018bd:	ff 75 08             	pushl  0x8(%ebp)
801018c0:	e8 20 01 00 00       	call   801019e5 <iget>
801018c5:	83 c4 10             	add    $0x10,%esp
801018c8:	eb 30                	jmp    801018fa <ialloc+0xf1>
    }
    brelse(bp);
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	ff 75 f0             	pushl  -0x10(%ebp)
801018d0:	e8 59 e9 ff ff       	call   8010022e <brelse>
801018d5:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801018d8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801018dc:	8b 15 68 42 11 80    	mov    0x80114268,%edx
801018e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e5:	39 c2                	cmp    %eax,%edx
801018e7:	0f 87 35 ff ff ff    	ja     80101822 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801018ed:	83 ec 0c             	sub    $0xc,%esp
801018f0:	68 47 a4 10 80       	push   $0x8010a447
801018f5:	e8 6c ec ff ff       	call   80100566 <panic>
}
801018fa:	c9                   	leave  
801018fb:	c3                   	ret    

801018fc <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801018fc:	55                   	push   %ebp
801018fd:	89 e5                	mov    %esp,%ebp
801018ff:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101902:	8b 45 08             	mov    0x8(%ebp),%eax
80101905:	8b 40 04             	mov    0x4(%eax),%eax
80101908:	c1 e8 03             	shr    $0x3,%eax
8010190b:	89 c2                	mov    %eax,%edx
8010190d:	a1 74 42 11 80       	mov    0x80114274,%eax
80101912:	01 c2                	add    %eax,%edx
80101914:	8b 45 08             	mov    0x8(%ebp),%eax
80101917:	8b 00                	mov    (%eax),%eax
80101919:	83 ec 08             	sub    $0x8,%esp
8010191c:	52                   	push   %edx
8010191d:	50                   	push   %eax
8010191e:	e8 93 e8 ff ff       	call   801001b6 <bread>
80101923:	83 c4 10             	add    $0x10,%esp
80101926:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101929:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010192c:	8d 50 18             	lea    0x18(%eax),%edx
8010192f:	8b 45 08             	mov    0x8(%ebp),%eax
80101932:	8b 40 04             	mov    0x4(%eax),%eax
80101935:	83 e0 07             	and    $0x7,%eax
80101938:	c1 e0 06             	shl    $0x6,%eax
8010193b:	01 d0                	add    %edx,%eax
8010193d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101940:	8b 45 08             	mov    0x8(%ebp),%eax
80101943:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101947:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194a:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010194d:	8b 45 08             	mov    0x8(%ebp),%eax
80101950:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101954:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101957:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010195b:	8b 45 08             	mov    0x8(%ebp),%eax
8010195e:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101962:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101965:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101970:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101973:	66 89 50 06          	mov    %dx,0x6(%eax)
#ifdef CS333_P5
  dip->uid = ip->uid;
80101977:	8b 45 08             	mov    0x8(%ebp),%eax
8010197a:	0f b7 50 18          	movzwl 0x18(%eax),%edx
8010197e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101981:	66 89 50 08          	mov    %dx,0x8(%eax)
  dip->gid = ip->gid;
80101985:	8b 45 08             	mov    0x8(%ebp),%eax
80101988:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
8010198c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010198f:	66 89 50 0a          	mov    %dx,0xa(%eax)
  dip->mode.asInt = ip->mode.asInt;
80101993:	8b 45 08             	mov    0x8(%ebp),%eax
80101996:	8b 50 1c             	mov    0x1c(%eax),%edx
80101999:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010199c:	89 50 0c             	mov    %edx,0xc(%eax)
#endif
  dip->size = ip->size;
8010199f:	8b 45 08             	mov    0x8(%ebp),%eax
801019a2:	8b 50 20             	mov    0x20(%eax),%edx
801019a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a8:	89 50 10             	mov    %edx,0x10(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019ab:	8b 45 08             	mov    0x8(%ebp),%eax
801019ae:	8d 50 24             	lea    0x24(%eax),%edx
801019b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b4:	83 c0 14             	add    $0x14,%eax
801019b7:	83 ec 04             	sub    $0x4,%esp
801019ba:	6a 2c                	push   $0x2c
801019bc:	52                   	push   %edx
801019bd:	50                   	push   %eax
801019be:	e8 2c 54 00 00       	call   80106def <memmove>
801019c3:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801019c6:	83 ec 0c             	sub    $0xc,%esp
801019c9:	ff 75 f4             	pushl  -0xc(%ebp)
801019cc:	e8 e5 20 00 00       	call   80103ab6 <log_write>
801019d1:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801019d4:	83 ec 0c             	sub    $0xc,%esp
801019d7:	ff 75 f4             	pushl  -0xc(%ebp)
801019da:	e8 4f e8 ff ff       	call   8010022e <brelse>
801019df:	83 c4 10             	add    $0x10,%esp
}
801019e2:	90                   	nop
801019e3:	c9                   	leave  
801019e4:	c3                   	ret    

801019e5 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801019e5:	55                   	push   %ebp
801019e6:	89 e5                	mov    %esp,%ebp
801019e8:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
801019eb:	83 ec 0c             	sub    $0xc,%esp
801019ee:	68 80 42 11 80       	push   $0x80114280
801019f3:	e8 d5 50 00 00       	call   80106acd <acquire>
801019f8:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
801019fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a02:	c7 45 f4 b4 42 11 80 	movl   $0x801142b4,-0xc(%ebp)
80101a09:	eb 5d                	jmp    80101a68 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a0e:	8b 40 08             	mov    0x8(%eax),%eax
80101a11:	85 c0                	test   %eax,%eax
80101a13:	7e 39                	jle    80101a4e <iget+0x69>
80101a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a18:	8b 00                	mov    (%eax),%eax
80101a1a:	3b 45 08             	cmp    0x8(%ebp),%eax
80101a1d:	75 2f                	jne    80101a4e <iget+0x69>
80101a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a22:	8b 40 04             	mov    0x4(%eax),%eax
80101a25:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101a28:	75 24                	jne    80101a4e <iget+0x69>
      ip->ref++;
80101a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a2d:	8b 40 08             	mov    0x8(%eax),%eax
80101a30:	8d 50 01             	lea    0x1(%eax),%edx
80101a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a36:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101a39:	83 ec 0c             	sub    $0xc,%esp
80101a3c:	68 80 42 11 80       	push   $0x80114280
80101a41:	e8 ee 50 00 00       	call   80106b34 <release>
80101a46:	83 c4 10             	add    $0x10,%esp
      return ip;
80101a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a4c:	eb 74                	jmp    80101ac2 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a52:	75 10                	jne    80101a64 <iget+0x7f>
80101a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a57:	8b 40 08             	mov    0x8(%eax),%eax
80101a5a:	85 c0                	test   %eax,%eax
80101a5c:	75 06                	jne    80101a64 <iget+0x7f>
      empty = ip;
80101a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a61:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a64:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101a68:	81 7d f4 54 52 11 80 	cmpl   $0x80115254,-0xc(%ebp)
80101a6f:	72 9a                	jb     80101a0b <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101a71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101a75:	75 0d                	jne    80101a84 <iget+0x9f>
    panic("iget: no inodes");
80101a77:	83 ec 0c             	sub    $0xc,%esp
80101a7a:	68 59 a4 10 80       	push   $0x8010a459
80101a7f:	e8 e2 ea ff ff       	call   80100566 <panic>

  ip = empty;
80101a84:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a8d:	8b 55 08             	mov    0x8(%ebp),%edx
80101a90:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a95:	8b 55 0c             	mov    0xc(%ebp),%edx
80101a98:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101a9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a9e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aa8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101aaf:	83 ec 0c             	sub    $0xc,%esp
80101ab2:	68 80 42 11 80       	push   $0x80114280
80101ab7:	e8 78 50 00 00       	call   80106b34 <release>
80101abc:	83 c4 10             	add    $0x10,%esp

  return ip;
80101abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101ac2:	c9                   	leave  
80101ac3:	c3                   	ret    

80101ac4 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101ac4:	55                   	push   %ebp
80101ac5:	89 e5                	mov    %esp,%ebp
80101ac7:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101aca:	83 ec 0c             	sub    $0xc,%esp
80101acd:	68 80 42 11 80       	push   $0x80114280
80101ad2:	e8 f6 4f 00 00       	call   80106acd <acquire>
80101ad7:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101ada:	8b 45 08             	mov    0x8(%ebp),%eax
80101add:	8b 40 08             	mov    0x8(%eax),%eax
80101ae0:	8d 50 01             	lea    0x1(%eax),%edx
80101ae3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae6:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ae9:	83 ec 0c             	sub    $0xc,%esp
80101aec:	68 80 42 11 80       	push   $0x80114280
80101af1:	e8 3e 50 00 00       	call   80106b34 <release>
80101af6:	83 c4 10             	add    $0x10,%esp
  return ip;
80101af9:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101afc:	c9                   	leave  
80101afd:	c3                   	ret    

80101afe <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101afe:	55                   	push   %ebp
80101aff:	89 e5                	mov    %esp,%ebp
80101b01:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101b04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b08:	74 0a                	je     80101b14 <ilock+0x16>
80101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0d:	8b 40 08             	mov    0x8(%eax),%eax
80101b10:	85 c0                	test   %eax,%eax
80101b12:	7f 0d                	jg     80101b21 <ilock+0x23>
    panic("ilock");
80101b14:	83 ec 0c             	sub    $0xc,%esp
80101b17:	68 69 a4 10 80       	push   $0x8010a469
80101b1c:	e8 45 ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b21:	83 ec 0c             	sub    $0xc,%esp
80101b24:	68 80 42 11 80       	push   $0x80114280
80101b29:	e8 9f 4f 00 00       	call   80106acd <acquire>
80101b2e:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101b31:	eb 13                	jmp    80101b46 <ilock+0x48>
    sleep(ip, &icache.lock);
80101b33:	83 ec 08             	sub    $0x8,%esp
80101b36:	68 80 42 11 80       	push   $0x80114280
80101b3b:	ff 75 08             	pushl  0x8(%ebp)
80101b3e:	e8 d5 3c 00 00       	call   80105818 <sleep>
80101b43:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101b46:	8b 45 08             	mov    0x8(%ebp),%eax
80101b49:	8b 40 0c             	mov    0xc(%eax),%eax
80101b4c:	83 e0 01             	and    $0x1,%eax
80101b4f:	85 c0                	test   %eax,%eax
80101b51:	75 e0                	jne    80101b33 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101b53:	8b 45 08             	mov    0x8(%ebp),%eax
80101b56:	8b 40 0c             	mov    0xc(%eax),%eax
80101b59:	83 c8 01             	or     $0x1,%eax
80101b5c:	89 c2                	mov    %eax,%edx
80101b5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b61:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101b64:	83 ec 0c             	sub    $0xc,%esp
80101b67:	68 80 42 11 80       	push   $0x80114280
80101b6c:	e8 c3 4f 00 00       	call   80106b34 <release>
80101b71:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101b74:	8b 45 08             	mov    0x8(%ebp),%eax
80101b77:	8b 40 0c             	mov    0xc(%eax),%eax
80101b7a:	83 e0 02             	and    $0x2,%eax
80101b7d:	85 c0                	test   %eax,%eax
80101b7f:	0f 85 fc 00 00 00    	jne    80101c81 <ilock+0x183>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101b85:	8b 45 08             	mov    0x8(%ebp),%eax
80101b88:	8b 40 04             	mov    0x4(%eax),%eax
80101b8b:	c1 e8 03             	shr    $0x3,%eax
80101b8e:	89 c2                	mov    %eax,%edx
80101b90:	a1 74 42 11 80       	mov    0x80114274,%eax
80101b95:	01 c2                	add    %eax,%edx
80101b97:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9a:	8b 00                	mov    (%eax),%eax
80101b9c:	83 ec 08             	sub    $0x8,%esp
80101b9f:	52                   	push   %edx
80101ba0:	50                   	push   %eax
80101ba1:	e8 10 e6 ff ff       	call   801001b6 <bread>
80101ba6:	83 c4 10             	add    $0x10,%esp
80101ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101baf:	8d 50 18             	lea    0x18(%eax),%edx
80101bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb5:	8b 40 04             	mov    0x4(%eax),%eax
80101bb8:	83 e0 07             	and    $0x7,%eax
80101bbb:	c1 e0 06             	shl    $0x6,%eax
80101bbe:	01 d0                	add    %edx,%eax
80101bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bc6:	0f b7 10             	movzwl (%eax),%edx
80101bc9:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcc:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101bd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd3:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bda:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101bde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101be1:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101be5:	8b 45 08             	mov    0x8(%ebp),%eax
80101be8:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101bec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bef:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
80101bf6:	66 89 50 16          	mov    %dx,0x16(%eax)
#ifdef CS333_P5
    ip->uid = dip->uid;
80101bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bfd:	0f b7 50 08          	movzwl 0x8(%eax),%edx
80101c01:	8b 45 08             	mov    0x8(%ebp),%eax
80101c04:	66 89 50 18          	mov    %dx,0x18(%eax)
    ip->gid = dip->gid;
80101c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c0b:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
80101c0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101c12:	66 89 50 1a          	mov    %dx,0x1a(%eax)
    (ip->mode.asInt) = (dip->mode.asInt);
80101c16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c19:	8b 50 0c             	mov    0xc(%eax),%edx
80101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1f:	89 50 1c             	mov    %edx,0x1c(%eax)
#endif
    ip->size = dip->size;
80101c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c25:	8b 50 10             	mov    0x10(%eax),%edx
80101c28:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2b:	89 50 20             	mov    %edx,0x20(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c31:	8d 50 14             	lea    0x14(%eax),%edx
80101c34:	8b 45 08             	mov    0x8(%ebp),%eax
80101c37:	83 c0 24             	add    $0x24,%eax
80101c3a:	83 ec 04             	sub    $0x4,%esp
80101c3d:	6a 2c                	push   $0x2c
80101c3f:	52                   	push   %edx
80101c40:	50                   	push   %eax
80101c41:	e8 a9 51 00 00       	call   80106def <memmove>
80101c46:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101c49:	83 ec 0c             	sub    $0xc,%esp
80101c4c:	ff 75 f4             	pushl  -0xc(%ebp)
80101c4f:	e8 da e5 ff ff       	call   8010022e <brelse>
80101c54:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101c57:	8b 45 08             	mov    0x8(%ebp),%eax
80101c5a:	8b 40 0c             	mov    0xc(%eax),%eax
80101c5d:	83 c8 02             	or     $0x2,%eax
80101c60:	89 c2                	mov    %eax,%edx
80101c62:	8b 45 08             	mov    0x8(%ebp),%eax
80101c65:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101c68:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101c6f:	66 85 c0             	test   %ax,%ax
80101c72:	75 0d                	jne    80101c81 <ilock+0x183>
      panic("ilock: no type");
80101c74:	83 ec 0c             	sub    $0xc,%esp
80101c77:	68 6f a4 10 80       	push   $0x8010a46f
80101c7c:	e8 e5 e8 ff ff       	call   80100566 <panic>
  }
}
80101c81:	90                   	nop
80101c82:	c9                   	leave  
80101c83:	c3                   	ret    

80101c84 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101c84:	55                   	push   %ebp
80101c85:	89 e5                	mov    %esp,%ebp
80101c87:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101c8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101c8e:	74 17                	je     80101ca7 <iunlock+0x23>
80101c90:	8b 45 08             	mov    0x8(%ebp),%eax
80101c93:	8b 40 0c             	mov    0xc(%eax),%eax
80101c96:	83 e0 01             	and    $0x1,%eax
80101c99:	85 c0                	test   %eax,%eax
80101c9b:	74 0a                	je     80101ca7 <iunlock+0x23>
80101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca0:	8b 40 08             	mov    0x8(%eax),%eax
80101ca3:	85 c0                	test   %eax,%eax
80101ca5:	7f 0d                	jg     80101cb4 <iunlock+0x30>
    panic("iunlock");
80101ca7:	83 ec 0c             	sub    $0xc,%esp
80101caa:	68 7e a4 10 80       	push   $0x8010a47e
80101caf:	e8 b2 e8 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101cb4:	83 ec 0c             	sub    $0xc,%esp
80101cb7:	68 80 42 11 80       	push   $0x80114280
80101cbc:	e8 0c 4e 00 00       	call   80106acd <acquire>
80101cc1:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101cc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc7:	8b 40 0c             	mov    0xc(%eax),%eax
80101cca:	83 e0 fe             	and    $0xfffffffe,%eax
80101ccd:	89 c2                	mov    %eax,%edx
80101ccf:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd2:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101cd5:	83 ec 0c             	sub    $0xc,%esp
80101cd8:	ff 75 08             	pushl  0x8(%ebp)
80101cdb:	e8 93 3d 00 00       	call   80105a73 <wakeup>
80101ce0:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ce3:	83 ec 0c             	sub    $0xc,%esp
80101ce6:	68 80 42 11 80       	push   $0x80114280
80101ceb:	e8 44 4e 00 00       	call   80106b34 <release>
80101cf0:	83 c4 10             	add    $0x10,%esp
}
80101cf3:	90                   	nop
80101cf4:	c9                   	leave  
80101cf5:	c3                   	ret    

80101cf6 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101cf6:	55                   	push   %ebp
80101cf7:	89 e5                	mov    %esp,%ebp
80101cf9:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101cfc:	83 ec 0c             	sub    $0xc,%esp
80101cff:	68 80 42 11 80       	push   $0x80114280
80101d04:	e8 c4 4d 00 00       	call   80106acd <acquire>
80101d09:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0f:	8b 40 08             	mov    0x8(%eax),%eax
80101d12:	83 f8 01             	cmp    $0x1,%eax
80101d15:	0f 85 a9 00 00 00    	jne    80101dc4 <iput+0xce>
80101d1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1e:	8b 40 0c             	mov    0xc(%eax),%eax
80101d21:	83 e0 02             	and    $0x2,%eax
80101d24:	85 c0                	test   %eax,%eax
80101d26:	0f 84 98 00 00 00    	je     80101dc4 <iput+0xce>
80101d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2f:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101d33:	66 85 c0             	test   %ax,%ax
80101d36:	0f 85 88 00 00 00    	jne    80101dc4 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101d3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3f:	8b 40 0c             	mov    0xc(%eax),%eax
80101d42:	83 e0 01             	and    $0x1,%eax
80101d45:	85 c0                	test   %eax,%eax
80101d47:	74 0d                	je     80101d56 <iput+0x60>
      panic("iput busy");
80101d49:	83 ec 0c             	sub    $0xc,%esp
80101d4c:	68 86 a4 10 80       	push   $0x8010a486
80101d51:	e8 10 e8 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101d56:	8b 45 08             	mov    0x8(%ebp),%eax
80101d59:	8b 40 0c             	mov    0xc(%eax),%eax
80101d5c:	83 c8 01             	or     $0x1,%eax
80101d5f:	89 c2                	mov    %eax,%edx
80101d61:	8b 45 08             	mov    0x8(%ebp),%eax
80101d64:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101d67:	83 ec 0c             	sub    $0xc,%esp
80101d6a:	68 80 42 11 80       	push   $0x80114280
80101d6f:	e8 c0 4d 00 00       	call   80106b34 <release>
80101d74:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101d77:	83 ec 0c             	sub    $0xc,%esp
80101d7a:	ff 75 08             	pushl  0x8(%ebp)
80101d7d:	e8 a8 01 00 00       	call   80101f2a <itrunc>
80101d82:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101d85:	8b 45 08             	mov    0x8(%ebp),%eax
80101d88:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101d8e:	83 ec 0c             	sub    $0xc,%esp
80101d91:	ff 75 08             	pushl  0x8(%ebp)
80101d94:	e8 63 fb ff ff       	call   801018fc <iupdate>
80101d99:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101d9c:	83 ec 0c             	sub    $0xc,%esp
80101d9f:	68 80 42 11 80       	push   $0x80114280
80101da4:	e8 24 4d 00 00       	call   80106acd <acquire>
80101da9:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101dac:	8b 45 08             	mov    0x8(%ebp),%eax
80101daf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101db6:	83 ec 0c             	sub    $0xc,%esp
80101db9:	ff 75 08             	pushl  0x8(%ebp)
80101dbc:	e8 b2 3c 00 00       	call   80105a73 <wakeup>
80101dc1:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101dc4:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc7:	8b 40 08             	mov    0x8(%eax),%eax
80101dca:	8d 50 ff             	lea    -0x1(%eax),%edx
80101dcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd0:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101dd3:	83 ec 0c             	sub    $0xc,%esp
80101dd6:	68 80 42 11 80       	push   $0x80114280
80101ddb:	e8 54 4d 00 00       	call   80106b34 <release>
80101de0:	83 c4 10             	add    $0x10,%esp
}
80101de3:	90                   	nop
80101de4:	c9                   	leave  
80101de5:	c3                   	ret    

80101de6 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101de6:	55                   	push   %ebp
80101de7:	89 e5                	mov    %esp,%ebp
80101de9:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101dec:	83 ec 0c             	sub    $0xc,%esp
80101def:	ff 75 08             	pushl  0x8(%ebp)
80101df2:	e8 8d fe ff ff       	call   80101c84 <iunlock>
80101df7:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101dfa:	83 ec 0c             	sub    $0xc,%esp
80101dfd:	ff 75 08             	pushl  0x8(%ebp)
80101e00:	e8 f1 fe ff ff       	call   80101cf6 <iput>
80101e05:	83 c4 10             	add    $0x10,%esp
}
80101e08:	90                   	nop
80101e09:	c9                   	leave  
80101e0a:	c3                   	ret    

80101e0b <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101e0b:	55                   	push   %ebp
80101e0c:	89 e5                	mov    %esp,%ebp
80101e0e:	53                   	push   %ebx
80101e0f:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101e12:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
80101e16:	77 42                	ja     80101e5a <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101e18:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e1e:	83 c2 08             	add    $0x8,%edx
80101e21:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101e25:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e2c:	75 24                	jne    80101e52 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e31:	8b 00                	mov    (%eax),%eax
80101e33:	83 ec 0c             	sub    $0xc,%esp
80101e36:	50                   	push   %eax
80101e37:	e8 2e f7 ff ff       	call   8010156a <balloc>
80101e3c:	83 c4 10             	add    $0x10,%esp
80101e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e42:	8b 45 08             	mov    0x8(%ebp),%eax
80101e45:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e48:	8d 4a 08             	lea    0x8(%edx),%ecx
80101e4b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e4e:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    return addr;
80101e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e55:	e9 cb 00 00 00       	jmp    80101f25 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101e5a:	83 6d 0c 0a          	subl   $0xa,0xc(%ebp)

  if(bn < NINDIRECT){
80101e5e:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101e62:	0f 87 b0 00 00 00    	ja     80101f18 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101e68:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6b:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e75:	75 1d                	jne    80101e94 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101e77:	8b 45 08             	mov    0x8(%ebp),%eax
80101e7a:	8b 00                	mov    (%eax),%eax
80101e7c:	83 ec 0c             	sub    $0xc,%esp
80101e7f:	50                   	push   %eax
80101e80:	e8 e5 f6 ff ff       	call   8010156a <balloc>
80101e85:	83 c4 10             	add    $0x10,%esp
80101e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e91:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101e94:	8b 45 08             	mov    0x8(%ebp),%eax
80101e97:	8b 00                	mov    (%eax),%eax
80101e99:	83 ec 08             	sub    $0x8,%esp
80101e9c:	ff 75 f4             	pushl  -0xc(%ebp)
80101e9f:	50                   	push   %eax
80101ea0:	e8 11 e3 ff ff       	call   801001b6 <bread>
80101ea5:	83 c4 10             	add    $0x10,%esp
80101ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eae:	83 c0 18             	add    $0x18,%eax
80101eb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ec1:	01 d0                	add    %edx,%eax
80101ec3:	8b 00                	mov    (%eax),%eax
80101ec5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ec8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ecc:	75 37                	jne    80101f05 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101ece:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ed8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101edb:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101ede:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee1:	8b 00                	mov    (%eax),%eax
80101ee3:	83 ec 0c             	sub    $0xc,%esp
80101ee6:	50                   	push   %eax
80101ee7:	e8 7e f6 ff ff       	call   8010156a <balloc>
80101eec:	83 c4 10             	add    $0x10,%esp
80101eef:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ef5:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101ef7:	83 ec 0c             	sub    $0xc,%esp
80101efa:	ff 75 f0             	pushl  -0x10(%ebp)
80101efd:	e8 b4 1b 00 00       	call   80103ab6 <log_write>
80101f02:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101f05:	83 ec 0c             	sub    $0xc,%esp
80101f08:	ff 75 f0             	pushl  -0x10(%ebp)
80101f0b:	e8 1e e3 ff ff       	call   8010022e <brelse>
80101f10:	83 c4 10             	add    $0x10,%esp
    return addr;
80101f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f16:	eb 0d                	jmp    80101f25 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101f18:	83 ec 0c             	sub    $0xc,%esp
80101f1b:	68 90 a4 10 80       	push   $0x8010a490
80101f20:	e8 41 e6 ff ff       	call   80100566 <panic>
}
80101f25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f28:	c9                   	leave  
80101f29:	c3                   	ret    

80101f2a <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101f2a:	55                   	push   %ebp
80101f2b:	89 e5                	mov    %esp,%ebp
80101f2d:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f37:	eb 45                	jmp    80101f7e <itrunc+0x54>
    if(ip->addrs[i]){
80101f39:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f3f:	83 c2 08             	add    $0x8,%edx
80101f42:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101f46:	85 c0                	test   %eax,%eax
80101f48:	74 30                	je     80101f7a <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101f4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f50:	83 c2 08             	add    $0x8,%edx
80101f53:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101f57:	8b 55 08             	mov    0x8(%ebp),%edx
80101f5a:	8b 12                	mov    (%edx),%edx
80101f5c:	83 ec 08             	sub    $0x8,%esp
80101f5f:	50                   	push   %eax
80101f60:	52                   	push   %edx
80101f61:	e8 50 f7 ff ff       	call   801016b6 <bfree>
80101f66:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101f69:	8b 45 08             	mov    0x8(%ebp),%eax
80101f6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f6f:	83 c2 08             	add    $0x8,%edx
80101f72:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
80101f79:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f7a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101f7e:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80101f82:	7e b5                	jle    80101f39 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101f84:	8b 45 08             	mov    0x8(%ebp),%eax
80101f87:	8b 40 4c             	mov    0x4c(%eax),%eax
80101f8a:	85 c0                	test   %eax,%eax
80101f8c:	0f 84 a1 00 00 00    	je     80102033 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101f92:	8b 45 08             	mov    0x8(%ebp),%eax
80101f95:	8b 50 4c             	mov    0x4c(%eax),%edx
80101f98:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9b:	8b 00                	mov    (%eax),%eax
80101f9d:	83 ec 08             	sub    $0x8,%esp
80101fa0:	52                   	push   %edx
80101fa1:	50                   	push   %eax
80101fa2:	e8 0f e2 ff ff       	call   801001b6 <bread>
80101fa7:	83 c4 10             	add    $0x10,%esp
80101faa:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101fad:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fb0:	83 c0 18             	add    $0x18,%eax
80101fb3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101fb6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101fbd:	eb 3c                	jmp    80101ffb <itrunc+0xd1>
      if(a[j])
80101fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fc2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101fc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fcc:	01 d0                	add    %edx,%eax
80101fce:	8b 00                	mov    (%eax),%eax
80101fd0:	85 c0                	test   %eax,%eax
80101fd2:	74 23                	je     80101ff7 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fd7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101fde:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101fe1:	01 d0                	add    %edx,%eax
80101fe3:	8b 00                	mov    (%eax),%eax
80101fe5:	8b 55 08             	mov    0x8(%ebp),%edx
80101fe8:	8b 12                	mov    (%edx),%edx
80101fea:	83 ec 08             	sub    $0x8,%esp
80101fed:	50                   	push   %eax
80101fee:	52                   	push   %edx
80101fef:	e8 c2 f6 ff ff       	call   801016b6 <bfree>
80101ff4:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101ff7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ffe:	83 f8 7f             	cmp    $0x7f,%eax
80102001:	76 bc                	jbe    80101fbf <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80102003:	83 ec 0c             	sub    $0xc,%esp
80102006:	ff 75 ec             	pushl  -0x14(%ebp)
80102009:	e8 20 e2 ff ff       	call   8010022e <brelse>
8010200e:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102011:	8b 45 08             	mov    0x8(%ebp),%eax
80102014:	8b 40 4c             	mov    0x4c(%eax),%eax
80102017:	8b 55 08             	mov    0x8(%ebp),%edx
8010201a:	8b 12                	mov    (%edx),%edx
8010201c:	83 ec 08             	sub    $0x8,%esp
8010201f:	50                   	push   %eax
80102020:	52                   	push   %edx
80102021:	e8 90 f6 ff ff       	call   801016b6 <bfree>
80102026:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80102029:	8b 45 08             	mov    0x8(%ebp),%eax
8010202c:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80102033:	8b 45 08             	mov    0x8(%ebp),%eax
80102036:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  iupdate(ip);
8010203d:	83 ec 0c             	sub    $0xc,%esp
80102040:	ff 75 08             	pushl  0x8(%ebp)
80102043:	e8 b4 f8 ff ff       	call   801018fc <iupdate>
80102048:	83 c4 10             	add    $0x10,%esp
}
8010204b:	90                   	nop
8010204c:	c9                   	leave  
8010204d:	c3                   	ret    

8010204e <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
8010204e:	55                   	push   %ebp
8010204f:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80102051:	8b 45 08             	mov    0x8(%ebp),%eax
80102054:	8b 00                	mov    (%eax),%eax
80102056:	89 c2                	mov    %eax,%edx
80102058:	8b 45 0c             	mov    0xc(%ebp),%eax
8010205b:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
8010205e:	8b 45 08             	mov    0x8(%ebp),%eax
80102061:	8b 50 04             	mov    0x4(%eax),%edx
80102064:	8b 45 0c             	mov    0xc(%ebp),%eax
80102067:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
8010206a:	8b 45 08             	mov    0x8(%ebp),%eax
8010206d:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80102071:	8b 45 0c             	mov    0xc(%ebp),%eax
80102074:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80102077:	8b 45 08             	mov    0x8(%ebp),%eax
8010207a:	0f b7 50 16          	movzwl 0x16(%eax),%edx
8010207e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102081:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80102085:	8b 45 08             	mov    0x8(%ebp),%eax
80102088:	8b 50 20             	mov    0x20(%eax),%edx
8010208b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010208e:	89 50 18             	mov    %edx,0x18(%eax)
#ifdef CS333_P5
  st->uid = ip->uid;
80102091:	8b 45 08             	mov    0x8(%ebp),%eax
80102094:	0f b7 50 18          	movzwl 0x18(%eax),%edx
80102098:	8b 45 0c             	mov    0xc(%ebp),%eax
8010209b:	66 89 50 0e          	mov    %dx,0xe(%eax)
  st->gid = ip->gid;
8010209f:	8b 45 08             	mov    0x8(%ebp),%eax
801020a2:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
801020a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801020a9:	66 89 50 10          	mov    %dx,0x10(%eax)
  (st->mode.asInt) = (ip->mode.asInt);
801020ad:	8b 45 08             	mov    0x8(%ebp),%eax
801020b0:	8b 50 1c             	mov    0x1c(%eax),%edx
801020b3:	8b 45 0c             	mov    0xc(%ebp),%eax
801020b6:	89 50 14             	mov    %edx,0x14(%eax)
#endif
}
801020b9:	90                   	nop
801020ba:	5d                   	pop    %ebp
801020bb:	c3                   	ret    

801020bc <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801020bc:	55                   	push   %ebp
801020bd:	89 e5                	mov    %esp,%ebp
801020bf:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801020c2:	8b 45 08             	mov    0x8(%ebp),%eax
801020c5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020c9:	66 83 f8 03          	cmp    $0x3,%ax
801020cd:	75 5c                	jne    8010212b <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801020cf:	8b 45 08             	mov    0x8(%ebp),%eax
801020d2:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020d6:	66 85 c0             	test   %ax,%ax
801020d9:	78 20                	js     801020fb <readi+0x3f>
801020db:	8b 45 08             	mov    0x8(%ebp),%eax
801020de:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020e2:	66 83 f8 09          	cmp    $0x9,%ax
801020e6:	7f 13                	jg     801020fb <readi+0x3f>
801020e8:	8b 45 08             	mov    0x8(%ebp),%eax
801020eb:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801020ef:	98                   	cwtl   
801020f0:	8b 04 c5 00 42 11 80 	mov    -0x7feebe00(,%eax,8),%eax
801020f7:	85 c0                	test   %eax,%eax
801020f9:	75 0a                	jne    80102105 <readi+0x49>
      return -1;
801020fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102100:	e9 0c 01 00 00       	jmp    80102211 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80102105:	8b 45 08             	mov    0x8(%ebp),%eax
80102108:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010210c:	98                   	cwtl   
8010210d:	8b 04 c5 00 42 11 80 	mov    -0x7feebe00(,%eax,8),%eax
80102114:	8b 55 14             	mov    0x14(%ebp),%edx
80102117:	83 ec 04             	sub    $0x4,%esp
8010211a:	52                   	push   %edx
8010211b:	ff 75 0c             	pushl  0xc(%ebp)
8010211e:	ff 75 08             	pushl  0x8(%ebp)
80102121:	ff d0                	call   *%eax
80102123:	83 c4 10             	add    $0x10,%esp
80102126:	e9 e6 00 00 00       	jmp    80102211 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
8010212e:	8b 40 20             	mov    0x20(%eax),%eax
80102131:	3b 45 10             	cmp    0x10(%ebp),%eax
80102134:	72 0d                	jb     80102143 <readi+0x87>
80102136:	8b 55 10             	mov    0x10(%ebp),%edx
80102139:	8b 45 14             	mov    0x14(%ebp),%eax
8010213c:	01 d0                	add    %edx,%eax
8010213e:	3b 45 10             	cmp    0x10(%ebp),%eax
80102141:	73 0a                	jae    8010214d <readi+0x91>
    return -1;
80102143:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102148:	e9 c4 00 00 00       	jmp    80102211 <readi+0x155>
  if(off + n > ip->size)
8010214d:	8b 55 10             	mov    0x10(%ebp),%edx
80102150:	8b 45 14             	mov    0x14(%ebp),%eax
80102153:	01 c2                	add    %eax,%edx
80102155:	8b 45 08             	mov    0x8(%ebp),%eax
80102158:	8b 40 20             	mov    0x20(%eax),%eax
8010215b:	39 c2                	cmp    %eax,%edx
8010215d:	76 0c                	jbe    8010216b <readi+0xaf>
    n = ip->size - off;
8010215f:	8b 45 08             	mov    0x8(%ebp),%eax
80102162:	8b 40 20             	mov    0x20(%eax),%eax
80102165:	2b 45 10             	sub    0x10(%ebp),%eax
80102168:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010216b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102172:	e9 8b 00 00 00       	jmp    80102202 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102177:	8b 45 10             	mov    0x10(%ebp),%eax
8010217a:	c1 e8 09             	shr    $0x9,%eax
8010217d:	83 ec 08             	sub    $0x8,%esp
80102180:	50                   	push   %eax
80102181:	ff 75 08             	pushl  0x8(%ebp)
80102184:	e8 82 fc ff ff       	call   80101e0b <bmap>
80102189:	83 c4 10             	add    $0x10,%esp
8010218c:	89 c2                	mov    %eax,%edx
8010218e:	8b 45 08             	mov    0x8(%ebp),%eax
80102191:	8b 00                	mov    (%eax),%eax
80102193:	83 ec 08             	sub    $0x8,%esp
80102196:	52                   	push   %edx
80102197:	50                   	push   %eax
80102198:	e8 19 e0 ff ff       	call   801001b6 <bread>
8010219d:	83 c4 10             	add    $0x10,%esp
801021a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021a3:	8b 45 10             	mov    0x10(%ebp),%eax
801021a6:	25 ff 01 00 00       	and    $0x1ff,%eax
801021ab:	ba 00 02 00 00       	mov    $0x200,%edx
801021b0:	29 c2                	sub    %eax,%edx
801021b2:	8b 45 14             	mov    0x14(%ebp),%eax
801021b5:	2b 45 f4             	sub    -0xc(%ebp),%eax
801021b8:	39 c2                	cmp    %eax,%edx
801021ba:	0f 46 c2             	cmovbe %edx,%eax
801021bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
801021c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021c3:	8d 50 18             	lea    0x18(%eax),%edx
801021c6:	8b 45 10             	mov    0x10(%ebp),%eax
801021c9:	25 ff 01 00 00       	and    $0x1ff,%eax
801021ce:	01 d0                	add    %edx,%eax
801021d0:	83 ec 04             	sub    $0x4,%esp
801021d3:	ff 75 ec             	pushl  -0x14(%ebp)
801021d6:	50                   	push   %eax
801021d7:	ff 75 0c             	pushl  0xc(%ebp)
801021da:	e8 10 4c 00 00       	call   80106def <memmove>
801021df:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
801021e2:	83 ec 0c             	sub    $0xc,%esp
801021e5:	ff 75 f0             	pushl  -0x10(%ebp)
801021e8:	e8 41 e0 ff ff       	call   8010022e <brelse>
801021ed:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021f3:	01 45 f4             	add    %eax,-0xc(%ebp)
801021f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021f9:	01 45 10             	add    %eax,0x10(%ebp)
801021fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801021ff:	01 45 0c             	add    %eax,0xc(%ebp)
80102202:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102205:	3b 45 14             	cmp    0x14(%ebp),%eax
80102208:	0f 82 69 ff ff ff    	jb     80102177 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
8010220e:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102211:	c9                   	leave  
80102212:	c3                   	ret    

80102213 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102213:	55                   	push   %ebp
80102214:	89 e5                	mov    %esp,%ebp
80102216:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102219:	8b 45 08             	mov    0x8(%ebp),%eax
8010221c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102220:	66 83 f8 03          	cmp    $0x3,%ax
80102224:	75 5c                	jne    80102282 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102226:	8b 45 08             	mov    0x8(%ebp),%eax
80102229:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010222d:	66 85 c0             	test   %ax,%ax
80102230:	78 20                	js     80102252 <writei+0x3f>
80102232:	8b 45 08             	mov    0x8(%ebp),%eax
80102235:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102239:	66 83 f8 09          	cmp    $0x9,%ax
8010223d:	7f 13                	jg     80102252 <writei+0x3f>
8010223f:	8b 45 08             	mov    0x8(%ebp),%eax
80102242:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102246:	98                   	cwtl   
80102247:	8b 04 c5 04 42 11 80 	mov    -0x7feebdfc(,%eax,8),%eax
8010224e:	85 c0                	test   %eax,%eax
80102250:	75 0a                	jne    8010225c <writei+0x49>
      return -1;
80102252:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102257:	e9 3d 01 00 00       	jmp    80102399 <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
8010225c:	8b 45 08             	mov    0x8(%ebp),%eax
8010225f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102263:	98                   	cwtl   
80102264:	8b 04 c5 04 42 11 80 	mov    -0x7feebdfc(,%eax,8),%eax
8010226b:	8b 55 14             	mov    0x14(%ebp),%edx
8010226e:	83 ec 04             	sub    $0x4,%esp
80102271:	52                   	push   %edx
80102272:	ff 75 0c             	pushl  0xc(%ebp)
80102275:	ff 75 08             	pushl  0x8(%ebp)
80102278:	ff d0                	call   *%eax
8010227a:	83 c4 10             	add    $0x10,%esp
8010227d:	e9 17 01 00 00       	jmp    80102399 <writei+0x186>
  }

  if(off > ip->size || off + n < off)
80102282:	8b 45 08             	mov    0x8(%ebp),%eax
80102285:	8b 40 20             	mov    0x20(%eax),%eax
80102288:	3b 45 10             	cmp    0x10(%ebp),%eax
8010228b:	72 0d                	jb     8010229a <writei+0x87>
8010228d:	8b 55 10             	mov    0x10(%ebp),%edx
80102290:	8b 45 14             	mov    0x14(%ebp),%eax
80102293:	01 d0                	add    %edx,%eax
80102295:	3b 45 10             	cmp    0x10(%ebp),%eax
80102298:	73 0a                	jae    801022a4 <writei+0x91>
    return -1;
8010229a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010229f:	e9 f5 00 00 00       	jmp    80102399 <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
801022a4:	8b 55 10             	mov    0x10(%ebp),%edx
801022a7:	8b 45 14             	mov    0x14(%ebp),%eax
801022aa:	01 d0                	add    %edx,%eax
801022ac:	3d 00 14 01 00       	cmp    $0x11400,%eax
801022b1:	76 0a                	jbe    801022bd <writei+0xaa>
    return -1;
801022b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022b8:	e9 dc 00 00 00       	jmp    80102399 <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801022bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022c4:	e9 99 00 00 00       	jmp    80102362 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801022c9:	8b 45 10             	mov    0x10(%ebp),%eax
801022cc:	c1 e8 09             	shr    $0x9,%eax
801022cf:	83 ec 08             	sub    $0x8,%esp
801022d2:	50                   	push   %eax
801022d3:	ff 75 08             	pushl  0x8(%ebp)
801022d6:	e8 30 fb ff ff       	call   80101e0b <bmap>
801022db:	83 c4 10             	add    $0x10,%esp
801022de:	89 c2                	mov    %eax,%edx
801022e0:	8b 45 08             	mov    0x8(%ebp),%eax
801022e3:	8b 00                	mov    (%eax),%eax
801022e5:	83 ec 08             	sub    $0x8,%esp
801022e8:	52                   	push   %edx
801022e9:	50                   	push   %eax
801022ea:	e8 c7 de ff ff       	call   801001b6 <bread>
801022ef:	83 c4 10             	add    $0x10,%esp
801022f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801022f5:	8b 45 10             	mov    0x10(%ebp),%eax
801022f8:	25 ff 01 00 00       	and    $0x1ff,%eax
801022fd:	ba 00 02 00 00       	mov    $0x200,%edx
80102302:	29 c2                	sub    %eax,%edx
80102304:	8b 45 14             	mov    0x14(%ebp),%eax
80102307:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010230a:	39 c2                	cmp    %eax,%edx
8010230c:	0f 46 c2             	cmovbe %edx,%eax
8010230f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102312:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102315:	8d 50 18             	lea    0x18(%eax),%edx
80102318:	8b 45 10             	mov    0x10(%ebp),%eax
8010231b:	25 ff 01 00 00       	and    $0x1ff,%eax
80102320:	01 d0                	add    %edx,%eax
80102322:	83 ec 04             	sub    $0x4,%esp
80102325:	ff 75 ec             	pushl  -0x14(%ebp)
80102328:	ff 75 0c             	pushl  0xc(%ebp)
8010232b:	50                   	push   %eax
8010232c:	e8 be 4a 00 00       	call   80106def <memmove>
80102331:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102334:	83 ec 0c             	sub    $0xc,%esp
80102337:	ff 75 f0             	pushl  -0x10(%ebp)
8010233a:	e8 77 17 00 00       	call   80103ab6 <log_write>
8010233f:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102342:	83 ec 0c             	sub    $0xc,%esp
80102345:	ff 75 f0             	pushl  -0x10(%ebp)
80102348:	e8 e1 de ff ff       	call   8010022e <brelse>
8010234d:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102350:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102353:	01 45 f4             	add    %eax,-0xc(%ebp)
80102356:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102359:	01 45 10             	add    %eax,0x10(%ebp)
8010235c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010235f:	01 45 0c             	add    %eax,0xc(%ebp)
80102362:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102365:	3b 45 14             	cmp    0x14(%ebp),%eax
80102368:	0f 82 5b ff ff ff    	jb     801022c9 <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010236e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102372:	74 22                	je     80102396 <writei+0x183>
80102374:	8b 45 08             	mov    0x8(%ebp),%eax
80102377:	8b 40 20             	mov    0x20(%eax),%eax
8010237a:	3b 45 10             	cmp    0x10(%ebp),%eax
8010237d:	73 17                	jae    80102396 <writei+0x183>
    ip->size = off;
8010237f:	8b 45 08             	mov    0x8(%ebp),%eax
80102382:	8b 55 10             	mov    0x10(%ebp),%edx
80102385:	89 50 20             	mov    %edx,0x20(%eax)
    iupdate(ip);
80102388:	83 ec 0c             	sub    $0xc,%esp
8010238b:	ff 75 08             	pushl  0x8(%ebp)
8010238e:	e8 69 f5 ff ff       	call   801018fc <iupdate>
80102393:	83 c4 10             	add    $0x10,%esp
  }
  return n;
80102396:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102399:	c9                   	leave  
8010239a:	c3                   	ret    

8010239b <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010239b:	55                   	push   %ebp
8010239c:	89 e5                	mov    %esp,%ebp
8010239e:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801023a1:	83 ec 04             	sub    $0x4,%esp
801023a4:	6a 0e                	push   $0xe
801023a6:	ff 75 0c             	pushl  0xc(%ebp)
801023a9:	ff 75 08             	pushl  0x8(%ebp)
801023ac:	e8 d4 4a 00 00       	call   80106e85 <strncmp>
801023b1:	83 c4 10             	add    $0x10,%esp
}
801023b4:	c9                   	leave  
801023b5:	c3                   	ret    

801023b6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801023b6:	55                   	push   %ebp
801023b7:	89 e5                	mov    %esp,%ebp
801023b9:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801023bc:	8b 45 08             	mov    0x8(%ebp),%eax
801023bf:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801023c3:	66 83 f8 01          	cmp    $0x1,%ax
801023c7:	74 0d                	je     801023d6 <dirlookup+0x20>
    panic("dirlookup not DIR");
801023c9:	83 ec 0c             	sub    $0xc,%esp
801023cc:	68 a3 a4 10 80       	push   $0x8010a4a3
801023d1:	e8 90 e1 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801023d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801023dd:	eb 7b                	jmp    8010245a <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801023df:	6a 10                	push   $0x10
801023e1:	ff 75 f4             	pushl  -0xc(%ebp)
801023e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801023e7:	50                   	push   %eax
801023e8:	ff 75 08             	pushl  0x8(%ebp)
801023eb:	e8 cc fc ff ff       	call   801020bc <readi>
801023f0:	83 c4 10             	add    $0x10,%esp
801023f3:	83 f8 10             	cmp    $0x10,%eax
801023f6:	74 0d                	je     80102405 <dirlookup+0x4f>
      panic("dirlink read");
801023f8:	83 ec 0c             	sub    $0xc,%esp
801023fb:	68 b5 a4 10 80       	push   $0x8010a4b5
80102400:	e8 61 e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102405:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102409:	66 85 c0             	test   %ax,%ax
8010240c:	74 47                	je     80102455 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
8010240e:	83 ec 08             	sub    $0x8,%esp
80102411:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102414:	83 c0 02             	add    $0x2,%eax
80102417:	50                   	push   %eax
80102418:	ff 75 0c             	pushl  0xc(%ebp)
8010241b:	e8 7b ff ff ff       	call   8010239b <namecmp>
80102420:	83 c4 10             	add    $0x10,%esp
80102423:	85 c0                	test   %eax,%eax
80102425:	75 2f                	jne    80102456 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102427:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010242b:	74 08                	je     80102435 <dirlookup+0x7f>
        *poff = off;
8010242d:	8b 45 10             	mov    0x10(%ebp),%eax
80102430:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102433:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102435:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102439:	0f b7 c0             	movzwl %ax,%eax
8010243c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010243f:	8b 45 08             	mov    0x8(%ebp),%eax
80102442:	8b 00                	mov    (%eax),%eax
80102444:	83 ec 08             	sub    $0x8,%esp
80102447:	ff 75 f0             	pushl  -0x10(%ebp)
8010244a:	50                   	push   %eax
8010244b:	e8 95 f5 ff ff       	call   801019e5 <iget>
80102450:	83 c4 10             	add    $0x10,%esp
80102453:	eb 19                	jmp    8010246e <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
80102455:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102456:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010245a:	8b 45 08             	mov    0x8(%ebp),%eax
8010245d:	8b 40 20             	mov    0x20(%eax),%eax
80102460:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102463:	0f 87 76 ff ff ff    	ja     801023df <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102469:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010246e:	c9                   	leave  
8010246f:	c3                   	ret    

80102470 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102476:	83 ec 04             	sub    $0x4,%esp
80102479:	6a 00                	push   $0x0
8010247b:	ff 75 0c             	pushl  0xc(%ebp)
8010247e:	ff 75 08             	pushl  0x8(%ebp)
80102481:	e8 30 ff ff ff       	call   801023b6 <dirlookup>
80102486:	83 c4 10             	add    $0x10,%esp
80102489:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010248c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102490:	74 18                	je     801024aa <dirlink+0x3a>
    iput(ip);
80102492:	83 ec 0c             	sub    $0xc,%esp
80102495:	ff 75 f0             	pushl  -0x10(%ebp)
80102498:	e8 59 f8 ff ff       	call   80101cf6 <iput>
8010249d:	83 c4 10             	add    $0x10,%esp
    return -1;
801024a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024a5:	e9 9c 00 00 00       	jmp    80102546 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801024aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801024b1:	eb 39                	jmp    801024ec <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801024b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024b6:	6a 10                	push   $0x10
801024b8:	50                   	push   %eax
801024b9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801024bc:	50                   	push   %eax
801024bd:	ff 75 08             	pushl  0x8(%ebp)
801024c0:	e8 f7 fb ff ff       	call   801020bc <readi>
801024c5:	83 c4 10             	add    $0x10,%esp
801024c8:	83 f8 10             	cmp    $0x10,%eax
801024cb:	74 0d                	je     801024da <dirlink+0x6a>
      panic("dirlink read");
801024cd:	83 ec 0c             	sub    $0xc,%esp
801024d0:	68 b5 a4 10 80       	push   $0x8010a4b5
801024d5:	e8 8c e0 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
801024da:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801024de:	66 85 c0             	test   %ax,%ax
801024e1:	74 18                	je     801024fb <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801024e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024e6:	83 c0 10             	add    $0x10,%eax
801024e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801024ec:	8b 45 08             	mov    0x8(%ebp),%eax
801024ef:	8b 50 20             	mov    0x20(%eax),%edx
801024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024f5:	39 c2                	cmp    %eax,%edx
801024f7:	77 ba                	ja     801024b3 <dirlink+0x43>
801024f9:	eb 01                	jmp    801024fc <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801024fb:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801024fc:	83 ec 04             	sub    $0x4,%esp
801024ff:	6a 0e                	push   $0xe
80102501:	ff 75 0c             	pushl  0xc(%ebp)
80102504:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102507:	83 c0 02             	add    $0x2,%eax
8010250a:	50                   	push   %eax
8010250b:	e8 cb 49 00 00       	call   80106edb <strncpy>
80102510:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102513:	8b 45 10             	mov    0x10(%ebp),%eax
80102516:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010251d:	6a 10                	push   $0x10
8010251f:	50                   	push   %eax
80102520:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102523:	50                   	push   %eax
80102524:	ff 75 08             	pushl  0x8(%ebp)
80102527:	e8 e7 fc ff ff       	call   80102213 <writei>
8010252c:	83 c4 10             	add    $0x10,%esp
8010252f:	83 f8 10             	cmp    $0x10,%eax
80102532:	74 0d                	je     80102541 <dirlink+0xd1>
    panic("dirlink");
80102534:	83 ec 0c             	sub    $0xc,%esp
80102537:	68 c2 a4 10 80       	push   $0x8010a4c2
8010253c:	e8 25 e0 ff ff       	call   80100566 <panic>
  
  return 0;
80102541:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102546:	c9                   	leave  
80102547:	c3                   	ret    

80102548 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102548:	55                   	push   %ebp
80102549:	89 e5                	mov    %esp,%ebp
8010254b:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010254e:	eb 04                	jmp    80102554 <skipelem+0xc>
    path++;
80102550:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102554:	8b 45 08             	mov    0x8(%ebp),%eax
80102557:	0f b6 00             	movzbl (%eax),%eax
8010255a:	3c 2f                	cmp    $0x2f,%al
8010255c:	74 f2                	je     80102550 <skipelem+0x8>
    path++;
  if(*path == 0)
8010255e:	8b 45 08             	mov    0x8(%ebp),%eax
80102561:	0f b6 00             	movzbl (%eax),%eax
80102564:	84 c0                	test   %al,%al
80102566:	75 07                	jne    8010256f <skipelem+0x27>
    return 0;
80102568:	b8 00 00 00 00       	mov    $0x0,%eax
8010256d:	eb 7b                	jmp    801025ea <skipelem+0xa2>
  s = path;
8010256f:	8b 45 08             	mov    0x8(%ebp),%eax
80102572:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102575:	eb 04                	jmp    8010257b <skipelem+0x33>
    path++;
80102577:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
8010257b:	8b 45 08             	mov    0x8(%ebp),%eax
8010257e:	0f b6 00             	movzbl (%eax),%eax
80102581:	3c 2f                	cmp    $0x2f,%al
80102583:	74 0a                	je     8010258f <skipelem+0x47>
80102585:	8b 45 08             	mov    0x8(%ebp),%eax
80102588:	0f b6 00             	movzbl (%eax),%eax
8010258b:	84 c0                	test   %al,%al
8010258d:	75 e8                	jne    80102577 <skipelem+0x2f>
    path++;
  len = path - s;
8010258f:	8b 55 08             	mov    0x8(%ebp),%edx
80102592:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102595:	29 c2                	sub    %eax,%edx
80102597:	89 d0                	mov    %edx,%eax
80102599:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010259c:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801025a0:	7e 15                	jle    801025b7 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801025a2:	83 ec 04             	sub    $0x4,%esp
801025a5:	6a 0e                	push   $0xe
801025a7:	ff 75 f4             	pushl  -0xc(%ebp)
801025aa:	ff 75 0c             	pushl  0xc(%ebp)
801025ad:	e8 3d 48 00 00       	call   80106def <memmove>
801025b2:	83 c4 10             	add    $0x10,%esp
801025b5:	eb 26                	jmp    801025dd <skipelem+0x95>
  else {
    memmove(name, s, len);
801025b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801025ba:	83 ec 04             	sub    $0x4,%esp
801025bd:	50                   	push   %eax
801025be:	ff 75 f4             	pushl  -0xc(%ebp)
801025c1:	ff 75 0c             	pushl  0xc(%ebp)
801025c4:	e8 26 48 00 00       	call   80106def <memmove>
801025c9:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801025cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801025cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801025d2:	01 d0                	add    %edx,%eax
801025d4:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801025d7:	eb 04                	jmp    801025dd <skipelem+0x95>
    path++;
801025d9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801025dd:	8b 45 08             	mov    0x8(%ebp),%eax
801025e0:	0f b6 00             	movzbl (%eax),%eax
801025e3:	3c 2f                	cmp    $0x2f,%al
801025e5:	74 f2                	je     801025d9 <skipelem+0x91>
    path++;
  return path;
801025e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
801025ea:	c9                   	leave  
801025eb:	c3                   	ret    

801025ec <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801025ec:	55                   	push   %ebp
801025ed:	89 e5                	mov    %esp,%ebp
801025ef:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
801025f2:	8b 45 08             	mov    0x8(%ebp),%eax
801025f5:	0f b6 00             	movzbl (%eax),%eax
801025f8:	3c 2f                	cmp    $0x2f,%al
801025fa:	75 17                	jne    80102613 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
801025fc:	83 ec 08             	sub    $0x8,%esp
801025ff:	6a 01                	push   $0x1
80102601:	6a 01                	push   $0x1
80102603:	e8 dd f3 ff ff       	call   801019e5 <iget>
80102608:	83 c4 10             	add    $0x10,%esp
8010260b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010260e:	e9 bb 00 00 00       	jmp    801026ce <namex+0xe2>
  else
    ip = idup(proc->cwd);
80102613:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102619:	8b 40 68             	mov    0x68(%eax),%eax
8010261c:	83 ec 0c             	sub    $0xc,%esp
8010261f:	50                   	push   %eax
80102620:	e8 9f f4 ff ff       	call   80101ac4 <idup>
80102625:	83 c4 10             	add    $0x10,%esp
80102628:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010262b:	e9 9e 00 00 00       	jmp    801026ce <namex+0xe2>
    ilock(ip);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	ff 75 f4             	pushl  -0xc(%ebp)
80102636:	e8 c3 f4 ff ff       	call   80101afe <ilock>
8010263b:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102641:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102645:	66 83 f8 01          	cmp    $0x1,%ax
80102649:	74 18                	je     80102663 <namex+0x77>
      iunlockput(ip);
8010264b:	83 ec 0c             	sub    $0xc,%esp
8010264e:	ff 75 f4             	pushl  -0xc(%ebp)
80102651:	e8 90 f7 ff ff       	call   80101de6 <iunlockput>
80102656:	83 c4 10             	add    $0x10,%esp
      return 0;
80102659:	b8 00 00 00 00       	mov    $0x0,%eax
8010265e:	e9 a7 00 00 00       	jmp    8010270a <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
80102663:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102667:	74 20                	je     80102689 <namex+0x9d>
80102669:	8b 45 08             	mov    0x8(%ebp),%eax
8010266c:	0f b6 00             	movzbl (%eax),%eax
8010266f:	84 c0                	test   %al,%al
80102671:	75 16                	jne    80102689 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
80102673:	83 ec 0c             	sub    $0xc,%esp
80102676:	ff 75 f4             	pushl  -0xc(%ebp)
80102679:	e8 06 f6 ff ff       	call   80101c84 <iunlock>
8010267e:	83 c4 10             	add    $0x10,%esp
      return ip;
80102681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102684:	e9 81 00 00 00       	jmp    8010270a <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102689:	83 ec 04             	sub    $0x4,%esp
8010268c:	6a 00                	push   $0x0
8010268e:	ff 75 10             	pushl  0x10(%ebp)
80102691:	ff 75 f4             	pushl  -0xc(%ebp)
80102694:	e8 1d fd ff ff       	call   801023b6 <dirlookup>
80102699:	83 c4 10             	add    $0x10,%esp
8010269c:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010269f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801026a3:	75 15                	jne    801026ba <namex+0xce>
      iunlockput(ip);
801026a5:	83 ec 0c             	sub    $0xc,%esp
801026a8:	ff 75 f4             	pushl  -0xc(%ebp)
801026ab:	e8 36 f7 ff ff       	call   80101de6 <iunlockput>
801026b0:	83 c4 10             	add    $0x10,%esp
      return 0;
801026b3:	b8 00 00 00 00       	mov    $0x0,%eax
801026b8:	eb 50                	jmp    8010270a <namex+0x11e>
    }
    iunlockput(ip);
801026ba:	83 ec 0c             	sub    $0xc,%esp
801026bd:	ff 75 f4             	pushl  -0xc(%ebp)
801026c0:	e8 21 f7 ff ff       	call   80101de6 <iunlockput>
801026c5:	83 c4 10             	add    $0x10,%esp
    ip = next;
801026c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801026ce:	83 ec 08             	sub    $0x8,%esp
801026d1:	ff 75 10             	pushl  0x10(%ebp)
801026d4:	ff 75 08             	pushl  0x8(%ebp)
801026d7:	e8 6c fe ff ff       	call   80102548 <skipelem>
801026dc:	83 c4 10             	add    $0x10,%esp
801026df:	89 45 08             	mov    %eax,0x8(%ebp)
801026e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026e6:	0f 85 44 ff ff ff    	jne    80102630 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801026ec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801026f0:	74 15                	je     80102707 <namex+0x11b>
    iput(ip);
801026f2:	83 ec 0c             	sub    $0xc,%esp
801026f5:	ff 75 f4             	pushl  -0xc(%ebp)
801026f8:	e8 f9 f5 ff ff       	call   80101cf6 <iput>
801026fd:	83 c4 10             	add    $0x10,%esp
    return 0;
80102700:	b8 00 00 00 00       	mov    $0x0,%eax
80102705:	eb 03                	jmp    8010270a <namex+0x11e>
  }
  return ip;
80102707:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010270a:	c9                   	leave  
8010270b:	c3                   	ret    

8010270c <namei>:

struct inode*
namei(char *path)
{
8010270c:	55                   	push   %ebp
8010270d:	89 e5                	mov    %esp,%ebp
8010270f:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102712:	83 ec 04             	sub    $0x4,%esp
80102715:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102718:	50                   	push   %eax
80102719:	6a 00                	push   $0x0
8010271b:	ff 75 08             	pushl  0x8(%ebp)
8010271e:	e8 c9 fe ff ff       	call   801025ec <namex>
80102723:	83 c4 10             	add    $0x10,%esp
}
80102726:	c9                   	leave  
80102727:	c3                   	ret    

80102728 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102728:	55                   	push   %ebp
80102729:	89 e5                	mov    %esp,%ebp
8010272b:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010272e:	83 ec 04             	sub    $0x4,%esp
80102731:	ff 75 0c             	pushl  0xc(%ebp)
80102734:	6a 01                	push   $0x1
80102736:	ff 75 08             	pushl  0x8(%ebp)
80102739:	e8 ae fe ff ff       	call   801025ec <namex>
8010273e:	83 c4 10             	add    $0x10,%esp
}
80102741:	c9                   	leave  
80102742:	c3                   	ret    

80102743 <chmod>:
#ifdef CS333_P5
// user-side implementations for sysfile.c system calls

// Change mode (Permissions)
int
chmod(char *pathname, int mode) {
80102743:	55                   	push   %ebp
80102744:	89 e5                	mov    %esp,%ebp
80102746:	83 ec 18             	sub    $0x18,%esp
    struct inode *ip; // Get this pointed at the right inode
    begin_op(); // Wrap in a transaction
80102749:	e8 30 11 00 00       	call   8010387e <begin_op>
    if ((ip = namei(pathname)) == 0) {
8010274e:	83 ec 0c             	sub    $0xc,%esp
80102751:	ff 75 08             	pushl  0x8(%ebp)
80102754:	e8 b3 ff ff ff       	call   8010270c <namei>
80102759:	83 c4 10             	add    $0x10,%esp
8010275c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010275f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102763:	75 0c                	jne    80102771 <chmod+0x2e>
        end_op();
80102765:	e8 a0 11 00 00       	call   8010390a <end_op>
        return -1;
8010276a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010276f:	eb 3d                	jmp    801027ae <chmod+0x6b>
    } // Valid inode ptr
    ilock(ip); // Lock the inode
80102771:	83 ec 0c             	sub    $0xc,%esp
80102774:	ff 75 f4             	pushl  -0xc(%ebp)
80102777:	e8 82 f3 ff ff       	call   80101afe <ilock>
8010277c:	83 c4 10             	add    $0x10,%esp
    (ip->mode.asInt) = mode; // Update mode (bounds checked in sys_chmod)
8010277f:	8b 55 0c             	mov    0xc(%ebp),%edx
80102782:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102785:	89 50 1c             	mov    %edx,0x1c(%eax)
    iupdate(ip); // Update inode
80102788:	83 ec 0c             	sub    $0xc,%esp
8010278b:	ff 75 f4             	pushl  -0xc(%ebp)
8010278e:	e8 69 f1 ff ff       	call   801018fc <iupdate>
80102793:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip); // Make sure changes persist
80102796:	83 ec 0c             	sub    $0xc,%esp
80102799:	ff 75 f4             	pushl  -0xc(%ebp)
8010279c:	e8 45 f6 ff ff       	call   80101de6 <iunlockput>
801027a1:	83 c4 10             	add    $0x10,%esp
    end_op(); // end transaction
801027a4:	e8 61 11 00 00       	call   8010390a <end_op>
    return 0;
801027a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801027ae:	c9                   	leave  
801027af:	c3                   	ret    

801027b0 <chown>:

// Change owner (UID)
// Same workings as chmod()
int
chown(char *pathname, int owner) {
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
801027b3:	83 ec 18             	sub    $0x18,%esp
    struct inode *ip;
    begin_op();
801027b6:	e8 c3 10 00 00       	call   8010387e <begin_op>
    if ((ip = namei(pathname)) == 0) {
801027bb:	83 ec 0c             	sub    $0xc,%esp
801027be:	ff 75 08             	pushl  0x8(%ebp)
801027c1:	e8 46 ff ff ff       	call   8010270c <namei>
801027c6:	83 c4 10             	add    $0x10,%esp
801027c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027d0:	75 0c                	jne    801027de <chown+0x2e>
        end_op();
801027d2:	e8 33 11 00 00       	call   8010390a <end_op>
        return -1;
801027d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801027dc:	eb 40                	jmp    8010281e <chown+0x6e>
    }
    ilock(ip);
801027de:	83 ec 0c             	sub    $0xc,%esp
801027e1:	ff 75 f4             	pushl  -0xc(%ebp)
801027e4:	e8 15 f3 ff ff       	call   80101afe <ilock>
801027e9:	83 c4 10             	add    $0x10,%esp
    ip->uid = owner;
801027ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801027ef:	89 c2                	mov    %eax,%edx
801027f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027f4:	66 89 50 18          	mov    %dx,0x18(%eax)
    iupdate(ip);
801027f8:	83 ec 0c             	sub    $0xc,%esp
801027fb:	ff 75 f4             	pushl  -0xc(%ebp)
801027fe:	e8 f9 f0 ff ff       	call   801018fc <iupdate>
80102803:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80102806:	83 ec 0c             	sub    $0xc,%esp
80102809:	ff 75 f4             	pushl  -0xc(%ebp)
8010280c:	e8 d5 f5 ff ff       	call   80101de6 <iunlockput>
80102811:	83 c4 10             	add    $0x10,%esp
    end_op();
80102814:	e8 f1 10 00 00       	call   8010390a <end_op>
    return 0;
80102819:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010281e:	c9                   	leave  
8010281f:	c3                   	ret    

80102820 <chgrp>:

// Change group (GID)
// Same workings as chmod()
int
chgrp(char *pathname, int group) {
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
80102823:	83 ec 18             	sub    $0x18,%esp
    struct inode *ip;
    begin_op();
80102826:	e8 53 10 00 00       	call   8010387e <begin_op>
    if ((ip = namei(pathname)) == 0) {
8010282b:	83 ec 0c             	sub    $0xc,%esp
8010282e:	ff 75 08             	pushl  0x8(%ebp)
80102831:	e8 d6 fe ff ff       	call   8010270c <namei>
80102836:	83 c4 10             	add    $0x10,%esp
80102839:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010283c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102840:	75 0c                	jne    8010284e <chgrp+0x2e>
        end_op();
80102842:	e8 c3 10 00 00       	call   8010390a <end_op>
        return -1;
80102847:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010284c:	eb 40                	jmp    8010288e <chgrp+0x6e>
    }
    ilock(ip);
8010284e:	83 ec 0c             	sub    $0xc,%esp
80102851:	ff 75 f4             	pushl  -0xc(%ebp)
80102854:	e8 a5 f2 ff ff       	call   80101afe <ilock>
80102859:	83 c4 10             	add    $0x10,%esp
    ip->gid = group;
8010285c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010285f:	89 c2                	mov    %eax,%edx
80102861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102864:	66 89 50 1a          	mov    %dx,0x1a(%eax)
    iupdate(ip);
80102868:	83 ec 0c             	sub    $0xc,%esp
8010286b:	ff 75 f4             	pushl  -0xc(%ebp)
8010286e:	e8 89 f0 ff ff       	call   801018fc <iupdate>
80102873:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80102876:	83 ec 0c             	sub    $0xc,%esp
80102879:	ff 75 f4             	pushl  -0xc(%ebp)
8010287c:	e8 65 f5 ff ff       	call   80101de6 <iunlockput>
80102881:	83 c4 10             	add    $0x10,%esp
    end_op();
80102884:	e8 81 10 00 00       	call   8010390a <end_op>
    return 0;
80102889:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010288e:	c9                   	leave  
8010288f:	c3                   	ret    

80102890 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
80102893:	83 ec 14             	sub    $0x14,%esp
80102896:	8b 45 08             	mov    0x8(%ebp),%eax
80102899:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801028a1:	89 c2                	mov    %eax,%edx
801028a3:	ec                   	in     (%dx),%al
801028a4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801028a7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801028ab:	c9                   	leave  
801028ac:	c3                   	ret    

801028ad <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801028ad:	55                   	push   %ebp
801028ae:	89 e5                	mov    %esp,%ebp
801028b0:	57                   	push   %edi
801028b1:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801028b2:	8b 55 08             	mov    0x8(%ebp),%edx
801028b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028b8:	8b 45 10             	mov    0x10(%ebp),%eax
801028bb:	89 cb                	mov    %ecx,%ebx
801028bd:	89 df                	mov    %ebx,%edi
801028bf:	89 c1                	mov    %eax,%ecx
801028c1:	fc                   	cld    
801028c2:	f3 6d                	rep insl (%dx),%es:(%edi)
801028c4:	89 c8                	mov    %ecx,%eax
801028c6:	89 fb                	mov    %edi,%ebx
801028c8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801028cb:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801028ce:	90                   	nop
801028cf:	5b                   	pop    %ebx
801028d0:	5f                   	pop    %edi
801028d1:	5d                   	pop    %ebp
801028d2:	c3                   	ret    

801028d3 <outb>:

static inline void
outb(ushort port, uchar data)
{
801028d3:	55                   	push   %ebp
801028d4:	89 e5                	mov    %esp,%ebp
801028d6:	83 ec 08             	sub    $0x8,%esp
801028d9:	8b 55 08             	mov    0x8(%ebp),%edx
801028dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801028df:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801028e3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801028ea:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801028ee:	ee                   	out    %al,(%dx)
}
801028ef:	90                   	nop
801028f0:	c9                   	leave  
801028f1:	c3                   	ret    

801028f2 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801028f2:	55                   	push   %ebp
801028f3:	89 e5                	mov    %esp,%ebp
801028f5:	56                   	push   %esi
801028f6:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801028f7:	8b 55 08             	mov    0x8(%ebp),%edx
801028fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028fd:	8b 45 10             	mov    0x10(%ebp),%eax
80102900:	89 cb                	mov    %ecx,%ebx
80102902:	89 de                	mov    %ebx,%esi
80102904:	89 c1                	mov    %eax,%ecx
80102906:	fc                   	cld    
80102907:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102909:	89 c8                	mov    %ecx,%eax
8010290b:	89 f3                	mov    %esi,%ebx
8010290d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102910:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102913:	90                   	nop
80102914:	5b                   	pop    %ebx
80102915:	5e                   	pop    %esi
80102916:	5d                   	pop    %ebp
80102917:	c3                   	ret    

80102918 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102918:	55                   	push   %ebp
80102919:	89 e5                	mov    %esp,%ebp
8010291b:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010291e:	90                   	nop
8010291f:	68 f7 01 00 00       	push   $0x1f7
80102924:	e8 67 ff ff ff       	call   80102890 <inb>
80102929:	83 c4 04             	add    $0x4,%esp
8010292c:	0f b6 c0             	movzbl %al,%eax
8010292f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102932:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102935:	25 c0 00 00 00       	and    $0xc0,%eax
8010293a:	83 f8 40             	cmp    $0x40,%eax
8010293d:	75 e0                	jne    8010291f <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010293f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102943:	74 11                	je     80102956 <idewait+0x3e>
80102945:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102948:	83 e0 21             	and    $0x21,%eax
8010294b:	85 c0                	test   %eax,%eax
8010294d:	74 07                	je     80102956 <idewait+0x3e>
    return -1;
8010294f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102954:	eb 05                	jmp    8010295b <idewait+0x43>
  return 0;
80102956:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010295b:	c9                   	leave  
8010295c:	c3                   	ret    

8010295d <ideinit>:

void
ideinit(void)
{
8010295d:	55                   	push   %ebp
8010295e:	89 e5                	mov    %esp,%ebp
80102960:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102963:	83 ec 08             	sub    $0x8,%esp
80102966:	68 ca a4 10 80       	push   $0x8010a4ca
8010296b:	68 40 e6 10 80       	push   $0x8010e640
80102970:	e8 36 41 00 00       	call   80106aab <initlock>
80102975:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102978:	83 ec 0c             	sub    $0xc,%esp
8010297b:	6a 0e                	push   $0xe
8010297d:	e8 da 18 00 00       	call   8010425c <picenable>
80102982:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102985:	a1 80 59 11 80       	mov    0x80115980,%eax
8010298a:	83 e8 01             	sub    $0x1,%eax
8010298d:	83 ec 08             	sub    $0x8,%esp
80102990:	50                   	push   %eax
80102991:	6a 0e                	push   $0xe
80102993:	e8 73 04 00 00       	call   80102e0b <ioapicenable>
80102998:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010299b:	83 ec 0c             	sub    $0xc,%esp
8010299e:	6a 00                	push   $0x0
801029a0:	e8 73 ff ff ff       	call   80102918 <idewait>
801029a5:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801029a8:	83 ec 08             	sub    $0x8,%esp
801029ab:	68 f0 00 00 00       	push   $0xf0
801029b0:	68 f6 01 00 00       	push   $0x1f6
801029b5:	e8 19 ff ff ff       	call   801028d3 <outb>
801029ba:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801029bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029c4:	eb 24                	jmp    801029ea <ideinit+0x8d>
    if(inb(0x1f7) != 0){
801029c6:	83 ec 0c             	sub    $0xc,%esp
801029c9:	68 f7 01 00 00       	push   $0x1f7
801029ce:	e8 bd fe ff ff       	call   80102890 <inb>
801029d3:	83 c4 10             	add    $0x10,%esp
801029d6:	84 c0                	test   %al,%al
801029d8:	74 0c                	je     801029e6 <ideinit+0x89>
      havedisk1 = 1;
801029da:	c7 05 78 e6 10 80 01 	movl   $0x1,0x8010e678
801029e1:	00 00 00 
      break;
801029e4:	eb 0d                	jmp    801029f3 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801029e6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801029ea:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801029f1:	7e d3                	jle    801029c6 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801029f3:	83 ec 08             	sub    $0x8,%esp
801029f6:	68 e0 00 00 00       	push   $0xe0
801029fb:	68 f6 01 00 00       	push   $0x1f6
80102a00:	e8 ce fe ff ff       	call   801028d3 <outb>
80102a05:	83 c4 10             	add    $0x10,%esp
}
80102a08:	90                   	nop
80102a09:	c9                   	leave  
80102a0a:	c3                   	ret    

80102a0b <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102a0b:	55                   	push   %ebp
80102a0c:	89 e5                	mov    %esp,%ebp
80102a0e:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102a11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102a15:	75 0d                	jne    80102a24 <idestart+0x19>
    panic("idestart");
80102a17:	83 ec 0c             	sub    $0xc,%esp
80102a1a:	68 ce a4 10 80       	push   $0x8010a4ce
80102a1f:	e8 42 db ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102a24:	8b 45 08             	mov    0x8(%ebp),%eax
80102a27:	8b 40 08             	mov    0x8(%eax),%eax
80102a2a:	3d cf 07 00 00       	cmp    $0x7cf,%eax
80102a2f:	76 0d                	jbe    80102a3e <idestart+0x33>
    panic("incorrect blockno");
80102a31:	83 ec 0c             	sub    $0xc,%esp
80102a34:	68 d7 a4 10 80       	push   $0x8010a4d7
80102a39:	e8 28 db ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102a3e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102a45:	8b 45 08             	mov    0x8(%ebp),%eax
80102a48:	8b 50 08             	mov    0x8(%eax),%edx
80102a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a4e:	0f af c2             	imul   %edx,%eax
80102a51:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102a54:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102a58:	7e 0d                	jle    80102a67 <idestart+0x5c>
80102a5a:	83 ec 0c             	sub    $0xc,%esp
80102a5d:	68 ce a4 10 80       	push   $0x8010a4ce
80102a62:	e8 ff da ff ff       	call   80100566 <panic>
  
  idewait(0);
80102a67:	83 ec 0c             	sub    $0xc,%esp
80102a6a:	6a 00                	push   $0x0
80102a6c:	e8 a7 fe ff ff       	call   80102918 <idewait>
80102a71:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102a74:	83 ec 08             	sub    $0x8,%esp
80102a77:	6a 00                	push   $0x0
80102a79:	68 f6 03 00 00       	push   $0x3f6
80102a7e:	e8 50 fe ff ff       	call   801028d3 <outb>
80102a83:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a89:	0f b6 c0             	movzbl %al,%eax
80102a8c:	83 ec 08             	sub    $0x8,%esp
80102a8f:	50                   	push   %eax
80102a90:	68 f2 01 00 00       	push   $0x1f2
80102a95:	e8 39 fe ff ff       	call   801028d3 <outb>
80102a9a:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102a9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102aa0:	0f b6 c0             	movzbl %al,%eax
80102aa3:	83 ec 08             	sub    $0x8,%esp
80102aa6:	50                   	push   %eax
80102aa7:	68 f3 01 00 00       	push   $0x1f3
80102aac:	e8 22 fe ff ff       	call   801028d3 <outb>
80102ab1:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102ab4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ab7:	c1 f8 08             	sar    $0x8,%eax
80102aba:	0f b6 c0             	movzbl %al,%eax
80102abd:	83 ec 08             	sub    $0x8,%esp
80102ac0:	50                   	push   %eax
80102ac1:	68 f4 01 00 00       	push   $0x1f4
80102ac6:	e8 08 fe ff ff       	call   801028d3 <outb>
80102acb:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ad1:	c1 f8 10             	sar    $0x10,%eax
80102ad4:	0f b6 c0             	movzbl %al,%eax
80102ad7:	83 ec 08             	sub    $0x8,%esp
80102ada:	50                   	push   %eax
80102adb:	68 f5 01 00 00       	push   $0x1f5
80102ae0:	e8 ee fd ff ff       	call   801028d3 <outb>
80102ae5:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80102aeb:	8b 40 04             	mov    0x4(%eax),%eax
80102aee:	83 e0 01             	and    $0x1,%eax
80102af1:	c1 e0 04             	shl    $0x4,%eax
80102af4:	89 c2                	mov    %eax,%edx
80102af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102af9:	c1 f8 18             	sar    $0x18,%eax
80102afc:	83 e0 0f             	and    $0xf,%eax
80102aff:	09 d0                	or     %edx,%eax
80102b01:	83 c8 e0             	or     $0xffffffe0,%eax
80102b04:	0f b6 c0             	movzbl %al,%eax
80102b07:	83 ec 08             	sub    $0x8,%esp
80102b0a:	50                   	push   %eax
80102b0b:	68 f6 01 00 00       	push   $0x1f6
80102b10:	e8 be fd ff ff       	call   801028d3 <outb>
80102b15:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102b18:	8b 45 08             	mov    0x8(%ebp),%eax
80102b1b:	8b 00                	mov    (%eax),%eax
80102b1d:	83 e0 04             	and    $0x4,%eax
80102b20:	85 c0                	test   %eax,%eax
80102b22:	74 30                	je     80102b54 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102b24:	83 ec 08             	sub    $0x8,%esp
80102b27:	6a 30                	push   $0x30
80102b29:	68 f7 01 00 00       	push   $0x1f7
80102b2e:	e8 a0 fd ff ff       	call   801028d3 <outb>
80102b33:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102b36:	8b 45 08             	mov    0x8(%ebp),%eax
80102b39:	83 c0 18             	add    $0x18,%eax
80102b3c:	83 ec 04             	sub    $0x4,%esp
80102b3f:	68 80 00 00 00       	push   $0x80
80102b44:	50                   	push   %eax
80102b45:	68 f0 01 00 00       	push   $0x1f0
80102b4a:	e8 a3 fd ff ff       	call   801028f2 <outsl>
80102b4f:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102b52:	eb 12                	jmp    80102b66 <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102b54:	83 ec 08             	sub    $0x8,%esp
80102b57:	6a 20                	push   $0x20
80102b59:	68 f7 01 00 00       	push   $0x1f7
80102b5e:	e8 70 fd ff ff       	call   801028d3 <outb>
80102b63:	83 c4 10             	add    $0x10,%esp
  }
}
80102b66:	90                   	nop
80102b67:	c9                   	leave  
80102b68:	c3                   	ret    

80102b69 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102b69:	55                   	push   %ebp
80102b6a:	89 e5                	mov    %esp,%ebp
80102b6c:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102b6f:	83 ec 0c             	sub    $0xc,%esp
80102b72:	68 40 e6 10 80       	push   $0x8010e640
80102b77:	e8 51 3f 00 00       	call   80106acd <acquire>
80102b7c:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102b7f:	a1 74 e6 10 80       	mov    0x8010e674,%eax
80102b84:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b8b:	75 15                	jne    80102ba2 <ideintr+0x39>
    release(&idelock);
80102b8d:	83 ec 0c             	sub    $0xc,%esp
80102b90:	68 40 e6 10 80       	push   $0x8010e640
80102b95:	e8 9a 3f 00 00       	call   80106b34 <release>
80102b9a:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102b9d:	e9 9a 00 00 00       	jmp    80102c3c <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba5:	8b 40 14             	mov    0x14(%eax),%eax
80102ba8:	a3 74 e6 10 80       	mov    %eax,0x8010e674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bb0:	8b 00                	mov    (%eax),%eax
80102bb2:	83 e0 04             	and    $0x4,%eax
80102bb5:	85 c0                	test   %eax,%eax
80102bb7:	75 2d                	jne    80102be6 <ideintr+0x7d>
80102bb9:	83 ec 0c             	sub    $0xc,%esp
80102bbc:	6a 01                	push   $0x1
80102bbe:	e8 55 fd ff ff       	call   80102918 <idewait>
80102bc3:	83 c4 10             	add    $0x10,%esp
80102bc6:	85 c0                	test   %eax,%eax
80102bc8:	78 1c                	js     80102be6 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bcd:	83 c0 18             	add    $0x18,%eax
80102bd0:	83 ec 04             	sub    $0x4,%esp
80102bd3:	68 80 00 00 00       	push   $0x80
80102bd8:	50                   	push   %eax
80102bd9:	68 f0 01 00 00       	push   $0x1f0
80102bde:	e8 ca fc ff ff       	call   801028ad <insl>
80102be3:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102be9:	8b 00                	mov    (%eax),%eax
80102beb:	83 c8 02             	or     $0x2,%eax
80102bee:	89 c2                	mov    %eax,%edx
80102bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf3:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf8:	8b 00                	mov    (%eax),%eax
80102bfa:	83 e0 fb             	and    $0xfffffffb,%eax
80102bfd:	89 c2                	mov    %eax,%edx
80102bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c02:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102c04:	83 ec 0c             	sub    $0xc,%esp
80102c07:	ff 75 f4             	pushl  -0xc(%ebp)
80102c0a:	e8 64 2e 00 00       	call   80105a73 <wakeup>
80102c0f:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102c12:	a1 74 e6 10 80       	mov    0x8010e674,%eax
80102c17:	85 c0                	test   %eax,%eax
80102c19:	74 11                	je     80102c2c <ideintr+0xc3>
    idestart(idequeue);
80102c1b:	a1 74 e6 10 80       	mov    0x8010e674,%eax
80102c20:	83 ec 0c             	sub    $0xc,%esp
80102c23:	50                   	push   %eax
80102c24:	e8 e2 fd ff ff       	call   80102a0b <idestart>
80102c29:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102c2c:	83 ec 0c             	sub    $0xc,%esp
80102c2f:	68 40 e6 10 80       	push   $0x8010e640
80102c34:	e8 fb 3e 00 00       	call   80106b34 <release>
80102c39:	83 c4 10             	add    $0x10,%esp
}
80102c3c:	c9                   	leave  
80102c3d:	c3                   	ret    

80102c3e <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102c3e:	55                   	push   %ebp
80102c3f:	89 e5                	mov    %esp,%ebp
80102c41:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102c44:	8b 45 08             	mov    0x8(%ebp),%eax
80102c47:	8b 00                	mov    (%eax),%eax
80102c49:	83 e0 01             	and    $0x1,%eax
80102c4c:	85 c0                	test   %eax,%eax
80102c4e:	75 0d                	jne    80102c5d <iderw+0x1f>
    panic("iderw: buf not busy");
80102c50:	83 ec 0c             	sub    $0xc,%esp
80102c53:	68 e9 a4 10 80       	push   $0x8010a4e9
80102c58:	e8 09 d9 ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102c5d:	8b 45 08             	mov    0x8(%ebp),%eax
80102c60:	8b 00                	mov    (%eax),%eax
80102c62:	83 e0 06             	and    $0x6,%eax
80102c65:	83 f8 02             	cmp    $0x2,%eax
80102c68:	75 0d                	jne    80102c77 <iderw+0x39>
    panic("iderw: nothing to do");
80102c6a:	83 ec 0c             	sub    $0xc,%esp
80102c6d:	68 fd a4 10 80       	push   $0x8010a4fd
80102c72:	e8 ef d8 ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102c77:	8b 45 08             	mov    0x8(%ebp),%eax
80102c7a:	8b 40 04             	mov    0x4(%eax),%eax
80102c7d:	85 c0                	test   %eax,%eax
80102c7f:	74 16                	je     80102c97 <iderw+0x59>
80102c81:	a1 78 e6 10 80       	mov    0x8010e678,%eax
80102c86:	85 c0                	test   %eax,%eax
80102c88:	75 0d                	jne    80102c97 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102c8a:	83 ec 0c             	sub    $0xc,%esp
80102c8d:	68 12 a5 10 80       	push   $0x8010a512
80102c92:	e8 cf d8 ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102c97:	83 ec 0c             	sub    $0xc,%esp
80102c9a:	68 40 e6 10 80       	push   $0x8010e640
80102c9f:	e8 29 3e 00 00       	call   80106acd <acquire>
80102ca4:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102ca7:	8b 45 08             	mov    0x8(%ebp),%eax
80102caa:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102cb1:	c7 45 f4 74 e6 10 80 	movl   $0x8010e674,-0xc(%ebp)
80102cb8:	eb 0b                	jmp    80102cc5 <iderw+0x87>
80102cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cbd:	8b 00                	mov    (%eax),%eax
80102cbf:	83 c0 14             	add    $0x14,%eax
80102cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cc8:	8b 00                	mov    (%eax),%eax
80102cca:	85 c0                	test   %eax,%eax
80102ccc:	75 ec                	jne    80102cba <iderw+0x7c>
    ;
  *pp = b;
80102cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cd1:	8b 55 08             	mov    0x8(%ebp),%edx
80102cd4:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102cd6:	a1 74 e6 10 80       	mov    0x8010e674,%eax
80102cdb:	3b 45 08             	cmp    0x8(%ebp),%eax
80102cde:	75 23                	jne    80102d03 <iderw+0xc5>
    idestart(b);
80102ce0:	83 ec 0c             	sub    $0xc,%esp
80102ce3:	ff 75 08             	pushl  0x8(%ebp)
80102ce6:	e8 20 fd ff ff       	call   80102a0b <idestart>
80102ceb:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102cee:	eb 13                	jmp    80102d03 <iderw+0xc5>
    sleep(b, &idelock);
80102cf0:	83 ec 08             	sub    $0x8,%esp
80102cf3:	68 40 e6 10 80       	push   $0x8010e640
80102cf8:	ff 75 08             	pushl  0x8(%ebp)
80102cfb:	e8 18 2b 00 00       	call   80105818 <sleep>
80102d00:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102d03:	8b 45 08             	mov    0x8(%ebp),%eax
80102d06:	8b 00                	mov    (%eax),%eax
80102d08:	83 e0 06             	and    $0x6,%eax
80102d0b:	83 f8 02             	cmp    $0x2,%eax
80102d0e:	75 e0                	jne    80102cf0 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102d10:	83 ec 0c             	sub    $0xc,%esp
80102d13:	68 40 e6 10 80       	push   $0x8010e640
80102d18:	e8 17 3e 00 00       	call   80106b34 <release>
80102d1d:	83 c4 10             	add    $0x10,%esp
}
80102d20:	90                   	nop
80102d21:	c9                   	leave  
80102d22:	c3                   	ret    

80102d23 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102d23:	55                   	push   %ebp
80102d24:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102d26:	a1 54 52 11 80       	mov    0x80115254,%eax
80102d2b:	8b 55 08             	mov    0x8(%ebp),%edx
80102d2e:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102d30:	a1 54 52 11 80       	mov    0x80115254,%eax
80102d35:	8b 40 10             	mov    0x10(%eax),%eax
}
80102d38:	5d                   	pop    %ebp
80102d39:	c3                   	ret    

80102d3a <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102d3a:	55                   	push   %ebp
80102d3b:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102d3d:	a1 54 52 11 80       	mov    0x80115254,%eax
80102d42:	8b 55 08             	mov    0x8(%ebp),%edx
80102d45:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102d47:	a1 54 52 11 80       	mov    0x80115254,%eax
80102d4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80102d4f:	89 50 10             	mov    %edx,0x10(%eax)
}
80102d52:	90                   	nop
80102d53:	5d                   	pop    %ebp
80102d54:	c3                   	ret    

80102d55 <ioapicinit>:

void
ioapicinit(void)
{
80102d55:	55                   	push   %ebp
80102d56:	89 e5                	mov    %esp,%ebp
80102d58:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102d5b:	a1 84 53 11 80       	mov    0x80115384,%eax
80102d60:	85 c0                	test   %eax,%eax
80102d62:	0f 84 a0 00 00 00    	je     80102e08 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102d68:	c7 05 54 52 11 80 00 	movl   $0xfec00000,0x80115254
80102d6f:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102d72:	6a 01                	push   $0x1
80102d74:	e8 aa ff ff ff       	call   80102d23 <ioapicread>
80102d79:	83 c4 04             	add    $0x4,%esp
80102d7c:	c1 e8 10             	shr    $0x10,%eax
80102d7f:	25 ff 00 00 00       	and    $0xff,%eax
80102d84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102d87:	6a 00                	push   $0x0
80102d89:	e8 95 ff ff ff       	call   80102d23 <ioapicread>
80102d8e:	83 c4 04             	add    $0x4,%esp
80102d91:	c1 e8 18             	shr    $0x18,%eax
80102d94:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102d97:	0f b6 05 80 53 11 80 	movzbl 0x80115380,%eax
80102d9e:	0f b6 c0             	movzbl %al,%eax
80102da1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102da4:	74 10                	je     80102db6 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102da6:	83 ec 0c             	sub    $0xc,%esp
80102da9:	68 30 a5 10 80       	push   $0x8010a530
80102dae:	e8 13 d6 ff ff       	call   801003c6 <cprintf>
80102db3:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102db6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102dbd:	eb 3f                	jmp    80102dfe <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dc2:	83 c0 20             	add    $0x20,%eax
80102dc5:	0d 00 00 01 00       	or     $0x10000,%eax
80102dca:	89 c2                	mov    %eax,%edx
80102dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dcf:	83 c0 08             	add    $0x8,%eax
80102dd2:	01 c0                	add    %eax,%eax
80102dd4:	83 ec 08             	sub    $0x8,%esp
80102dd7:	52                   	push   %edx
80102dd8:	50                   	push   %eax
80102dd9:	e8 5c ff ff ff       	call   80102d3a <ioapicwrite>
80102dde:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102de4:	83 c0 08             	add    $0x8,%eax
80102de7:	01 c0                	add    %eax,%eax
80102de9:	83 c0 01             	add    $0x1,%eax
80102dec:	83 ec 08             	sub    $0x8,%esp
80102def:	6a 00                	push   $0x0
80102df1:	50                   	push   %eax
80102df2:	e8 43 ff ff ff       	call   80102d3a <ioapicwrite>
80102df7:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102dfa:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e01:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102e04:	7e b9                	jle    80102dbf <ioapicinit+0x6a>
80102e06:	eb 01                	jmp    80102e09 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102e08:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102e09:	c9                   	leave  
80102e0a:	c3                   	ret    

80102e0b <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102e0b:	55                   	push   %ebp
80102e0c:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102e0e:	a1 84 53 11 80       	mov    0x80115384,%eax
80102e13:	85 c0                	test   %eax,%eax
80102e15:	74 39                	je     80102e50 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102e17:	8b 45 08             	mov    0x8(%ebp),%eax
80102e1a:	83 c0 20             	add    $0x20,%eax
80102e1d:	89 c2                	mov    %eax,%edx
80102e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80102e22:	83 c0 08             	add    $0x8,%eax
80102e25:	01 c0                	add    %eax,%eax
80102e27:	52                   	push   %edx
80102e28:	50                   	push   %eax
80102e29:	e8 0c ff ff ff       	call   80102d3a <ioapicwrite>
80102e2e:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102e31:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e34:	c1 e0 18             	shl    $0x18,%eax
80102e37:	89 c2                	mov    %eax,%edx
80102e39:	8b 45 08             	mov    0x8(%ebp),%eax
80102e3c:	83 c0 08             	add    $0x8,%eax
80102e3f:	01 c0                	add    %eax,%eax
80102e41:	83 c0 01             	add    $0x1,%eax
80102e44:	52                   	push   %edx
80102e45:	50                   	push   %eax
80102e46:	e8 ef fe ff ff       	call   80102d3a <ioapicwrite>
80102e4b:	83 c4 08             	add    $0x8,%esp
80102e4e:	eb 01                	jmp    80102e51 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102e50:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102e51:	c9                   	leave  
80102e52:	c3                   	ret    

80102e53 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102e53:	55                   	push   %ebp
80102e54:	89 e5                	mov    %esp,%ebp
80102e56:	8b 45 08             	mov    0x8(%ebp),%eax
80102e59:	05 00 00 00 80       	add    $0x80000000,%eax
80102e5e:	5d                   	pop    %ebp
80102e5f:	c3                   	ret    

80102e60 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102e66:	83 ec 08             	sub    $0x8,%esp
80102e69:	68 62 a5 10 80       	push   $0x8010a562
80102e6e:	68 60 52 11 80       	push   $0x80115260
80102e73:	e8 33 3c 00 00       	call   80106aab <initlock>
80102e78:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102e7b:	c7 05 94 52 11 80 00 	movl   $0x0,0x80115294
80102e82:	00 00 00 
  freerange(vstart, vend);
80102e85:	83 ec 08             	sub    $0x8,%esp
80102e88:	ff 75 0c             	pushl  0xc(%ebp)
80102e8b:	ff 75 08             	pushl  0x8(%ebp)
80102e8e:	e8 2a 00 00 00       	call   80102ebd <freerange>
80102e93:	83 c4 10             	add    $0x10,%esp
}
80102e96:	90                   	nop
80102e97:	c9                   	leave  
80102e98:	c3                   	ret    

80102e99 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102e99:	55                   	push   %ebp
80102e9a:	89 e5                	mov    %esp,%ebp
80102e9c:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102e9f:	83 ec 08             	sub    $0x8,%esp
80102ea2:	ff 75 0c             	pushl  0xc(%ebp)
80102ea5:	ff 75 08             	pushl  0x8(%ebp)
80102ea8:	e8 10 00 00 00       	call   80102ebd <freerange>
80102ead:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102eb0:	c7 05 94 52 11 80 01 	movl   $0x1,0x80115294
80102eb7:	00 00 00 
}
80102eba:	90                   	nop
80102ebb:	c9                   	leave  
80102ebc:	c3                   	ret    

80102ebd <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ebd:	55                   	push   %ebp
80102ebe:	89 e5                	mov    %esp,%ebp
80102ec0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ec6:	05 ff 0f 00 00       	add    $0xfff,%eax
80102ecb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ed3:	eb 15                	jmp    80102eea <freerange+0x2d>
    kfree(p);
80102ed5:	83 ec 0c             	sub    $0xc,%esp
80102ed8:	ff 75 f4             	pushl  -0xc(%ebp)
80102edb:	e8 1a 00 00 00       	call   80102efa <kfree>
80102ee0:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ee3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102eed:	05 00 10 00 00       	add    $0x1000,%eax
80102ef2:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102ef5:	76 de                	jbe    80102ed5 <freerange+0x18>
    kfree(p);
}
80102ef7:	90                   	nop
80102ef8:	c9                   	leave  
80102ef9:	c3                   	ret    

80102efa <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102efa:	55                   	push   %ebp
80102efb:	89 e5                	mov    %esp,%ebp
80102efd:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102f00:	8b 45 08             	mov    0x8(%ebp),%eax
80102f03:	25 ff 0f 00 00       	and    $0xfff,%eax
80102f08:	85 c0                	test   %eax,%eax
80102f0a:	75 1b                	jne    80102f27 <kfree+0x2d>
80102f0c:	81 7d 08 5c 89 11 80 	cmpl   $0x8011895c,0x8(%ebp)
80102f13:	72 12                	jb     80102f27 <kfree+0x2d>
80102f15:	ff 75 08             	pushl  0x8(%ebp)
80102f18:	e8 36 ff ff ff       	call   80102e53 <v2p>
80102f1d:	83 c4 04             	add    $0x4,%esp
80102f20:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102f25:	76 0d                	jbe    80102f34 <kfree+0x3a>
    panic("kfree");
80102f27:	83 ec 0c             	sub    $0xc,%esp
80102f2a:	68 67 a5 10 80       	push   $0x8010a567
80102f2f:	e8 32 d6 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102f34:	83 ec 04             	sub    $0x4,%esp
80102f37:	68 00 10 00 00       	push   $0x1000
80102f3c:	6a 01                	push   $0x1
80102f3e:	ff 75 08             	pushl  0x8(%ebp)
80102f41:	e8 ea 3d 00 00       	call   80106d30 <memset>
80102f46:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102f49:	a1 94 52 11 80       	mov    0x80115294,%eax
80102f4e:	85 c0                	test   %eax,%eax
80102f50:	74 10                	je     80102f62 <kfree+0x68>
    acquire(&kmem.lock);
80102f52:	83 ec 0c             	sub    $0xc,%esp
80102f55:	68 60 52 11 80       	push   $0x80115260
80102f5a:	e8 6e 3b 00 00       	call   80106acd <acquire>
80102f5f:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102f62:	8b 45 08             	mov    0x8(%ebp),%eax
80102f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102f68:	8b 15 98 52 11 80    	mov    0x80115298,%edx
80102f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f71:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f76:	a3 98 52 11 80       	mov    %eax,0x80115298
  if(kmem.use_lock)
80102f7b:	a1 94 52 11 80       	mov    0x80115294,%eax
80102f80:	85 c0                	test   %eax,%eax
80102f82:	74 10                	je     80102f94 <kfree+0x9a>
    release(&kmem.lock);
80102f84:	83 ec 0c             	sub    $0xc,%esp
80102f87:	68 60 52 11 80       	push   $0x80115260
80102f8c:	e8 a3 3b 00 00       	call   80106b34 <release>
80102f91:	83 c4 10             	add    $0x10,%esp
}
80102f94:	90                   	nop
80102f95:	c9                   	leave  
80102f96:	c3                   	ret    

80102f97 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102f97:	55                   	push   %ebp
80102f98:	89 e5                	mov    %esp,%ebp
80102f9a:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102f9d:	a1 94 52 11 80       	mov    0x80115294,%eax
80102fa2:	85 c0                	test   %eax,%eax
80102fa4:	74 10                	je     80102fb6 <kalloc+0x1f>
    acquire(&kmem.lock);
80102fa6:	83 ec 0c             	sub    $0xc,%esp
80102fa9:	68 60 52 11 80       	push   $0x80115260
80102fae:	e8 1a 3b 00 00       	call   80106acd <acquire>
80102fb3:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102fb6:	a1 98 52 11 80       	mov    0x80115298,%eax
80102fbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102fbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102fc2:	74 0a                	je     80102fce <kalloc+0x37>
    kmem.freelist = r->next;
80102fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fc7:	8b 00                	mov    (%eax),%eax
80102fc9:	a3 98 52 11 80       	mov    %eax,0x80115298
  if(kmem.use_lock)
80102fce:	a1 94 52 11 80       	mov    0x80115294,%eax
80102fd3:	85 c0                	test   %eax,%eax
80102fd5:	74 10                	je     80102fe7 <kalloc+0x50>
    release(&kmem.lock);
80102fd7:	83 ec 0c             	sub    $0xc,%esp
80102fda:	68 60 52 11 80       	push   $0x80115260
80102fdf:	e8 50 3b 00 00       	call   80106b34 <release>
80102fe4:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102fea:	c9                   	leave  
80102feb:	c3                   	ret    

80102fec <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102fec:	55                   	push   %ebp
80102fed:	89 e5                	mov    %esp,%ebp
80102fef:	83 ec 14             	sub    $0x14,%esp
80102ff2:	8b 45 08             	mov    0x8(%ebp),%eax
80102ff5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ff9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102ffd:	89 c2                	mov    %eax,%edx
80102fff:	ec                   	in     (%dx),%al
80103000:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103003:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103007:	c9                   	leave  
80103008:	c3                   	ret    

80103009 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80103009:	55                   	push   %ebp
8010300a:	89 e5                	mov    %esp,%ebp
8010300c:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
8010300f:	6a 64                	push   $0x64
80103011:	e8 d6 ff ff ff       	call   80102fec <inb>
80103016:	83 c4 04             	add    $0x4,%esp
80103019:	0f b6 c0             	movzbl %al,%eax
8010301c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
8010301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103022:	83 e0 01             	and    $0x1,%eax
80103025:	85 c0                	test   %eax,%eax
80103027:	75 0a                	jne    80103033 <kbdgetc+0x2a>
    return -1;
80103029:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010302e:	e9 23 01 00 00       	jmp    80103156 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80103033:	6a 60                	push   $0x60
80103035:	e8 b2 ff ff ff       	call   80102fec <inb>
8010303a:	83 c4 04             	add    $0x4,%esp
8010303d:	0f b6 c0             	movzbl %al,%eax
80103040:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80103043:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
8010304a:	75 17                	jne    80103063 <kbdgetc+0x5a>
    shift |= E0ESC;
8010304c:	a1 7c e6 10 80       	mov    0x8010e67c,%eax
80103051:	83 c8 40             	or     $0x40,%eax
80103054:	a3 7c e6 10 80       	mov    %eax,0x8010e67c
    return 0;
80103059:	b8 00 00 00 00       	mov    $0x0,%eax
8010305e:	e9 f3 00 00 00       	jmp    80103156 <kbdgetc+0x14d>
  } else if(data & 0x80){
80103063:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103066:	25 80 00 00 00       	and    $0x80,%eax
8010306b:	85 c0                	test   %eax,%eax
8010306d:	74 45                	je     801030b4 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010306f:	a1 7c e6 10 80       	mov    0x8010e67c,%eax
80103074:	83 e0 40             	and    $0x40,%eax
80103077:	85 c0                	test   %eax,%eax
80103079:	75 08                	jne    80103083 <kbdgetc+0x7a>
8010307b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010307e:	83 e0 7f             	and    $0x7f,%eax
80103081:	eb 03                	jmp    80103086 <kbdgetc+0x7d>
80103083:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103086:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80103089:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010308c:	05 20 c0 10 80       	add    $0x8010c020,%eax
80103091:	0f b6 00             	movzbl (%eax),%eax
80103094:	83 c8 40             	or     $0x40,%eax
80103097:	0f b6 c0             	movzbl %al,%eax
8010309a:	f7 d0                	not    %eax
8010309c:	89 c2                	mov    %eax,%edx
8010309e:	a1 7c e6 10 80       	mov    0x8010e67c,%eax
801030a3:	21 d0                	and    %edx,%eax
801030a5:	a3 7c e6 10 80       	mov    %eax,0x8010e67c
    return 0;
801030aa:	b8 00 00 00 00       	mov    $0x0,%eax
801030af:	e9 a2 00 00 00       	jmp    80103156 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
801030b4:	a1 7c e6 10 80       	mov    0x8010e67c,%eax
801030b9:	83 e0 40             	and    $0x40,%eax
801030bc:	85 c0                	test   %eax,%eax
801030be:	74 14                	je     801030d4 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801030c0:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
801030c7:	a1 7c e6 10 80       	mov    0x8010e67c,%eax
801030cc:	83 e0 bf             	and    $0xffffffbf,%eax
801030cf:	a3 7c e6 10 80       	mov    %eax,0x8010e67c
  }

  shift |= shiftcode[data];
801030d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030d7:	05 20 c0 10 80       	add    $0x8010c020,%eax
801030dc:	0f b6 00             	movzbl (%eax),%eax
801030df:	0f b6 d0             	movzbl %al,%edx
801030e2:	a1 7c e6 10 80       	mov    0x8010e67c,%eax
801030e7:	09 d0                	or     %edx,%eax
801030e9:	a3 7c e6 10 80       	mov    %eax,0x8010e67c
  shift ^= togglecode[data];
801030ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030f1:	05 20 c1 10 80       	add    $0x8010c120,%eax
801030f6:	0f b6 00             	movzbl (%eax),%eax
801030f9:	0f b6 d0             	movzbl %al,%edx
801030fc:	a1 7c e6 10 80       	mov    0x8010e67c,%eax
80103101:	31 d0                	xor    %edx,%eax
80103103:	a3 7c e6 10 80       	mov    %eax,0x8010e67c
  c = charcode[shift & (CTL | SHIFT)][data];
80103108:	a1 7c e6 10 80       	mov    0x8010e67c,%eax
8010310d:	83 e0 03             	and    $0x3,%eax
80103110:	8b 14 85 20 c5 10 80 	mov    -0x7fef3ae0(,%eax,4),%edx
80103117:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010311a:	01 d0                	add    %edx,%eax
8010311c:	0f b6 00             	movzbl (%eax),%eax
8010311f:	0f b6 c0             	movzbl %al,%eax
80103122:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80103125:	a1 7c e6 10 80       	mov    0x8010e67c,%eax
8010312a:	83 e0 08             	and    $0x8,%eax
8010312d:	85 c0                	test   %eax,%eax
8010312f:	74 22                	je     80103153 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80103131:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80103135:	76 0c                	jbe    80103143 <kbdgetc+0x13a>
80103137:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
8010313b:	77 06                	ja     80103143 <kbdgetc+0x13a>
      c += 'A' - 'a';
8010313d:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80103141:	eb 10                	jmp    80103153 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80103143:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80103147:	76 0a                	jbe    80103153 <kbdgetc+0x14a>
80103149:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
8010314d:	77 04                	ja     80103153 <kbdgetc+0x14a>
      c += 'a' - 'A';
8010314f:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80103153:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103156:	c9                   	leave  
80103157:	c3                   	ret    

80103158 <kbdintr>:

void
kbdintr(void)
{
80103158:	55                   	push   %ebp
80103159:	89 e5                	mov    %esp,%ebp
8010315b:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
8010315e:	83 ec 0c             	sub    $0xc,%esp
80103161:	68 09 30 10 80       	push   $0x80103009
80103166:	e8 8e d6 ff ff       	call   801007f9 <consoleintr>
8010316b:	83 c4 10             	add    $0x10,%esp
}
8010316e:	90                   	nop
8010316f:	c9                   	leave  
80103170:	c3                   	ret    

80103171 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103171:	55                   	push   %ebp
80103172:	89 e5                	mov    %esp,%ebp
80103174:	83 ec 14             	sub    $0x14,%esp
80103177:	8b 45 08             	mov    0x8(%ebp),%eax
8010317a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010317e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103182:	89 c2                	mov    %eax,%edx
80103184:	ec                   	in     (%dx),%al
80103185:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103188:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010318c:	c9                   	leave  
8010318d:	c3                   	ret    

8010318e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010318e:	55                   	push   %ebp
8010318f:	89 e5                	mov    %esp,%ebp
80103191:	83 ec 08             	sub    $0x8,%esp
80103194:	8b 55 08             	mov    0x8(%ebp),%edx
80103197:	8b 45 0c             	mov    0xc(%ebp),%eax
8010319a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010319e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031a1:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801031a5:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801031a9:	ee                   	out    %al,(%dx)
}
801031aa:	90                   	nop
801031ab:	c9                   	leave  
801031ac:	c3                   	ret    

801031ad <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801031ad:	55                   	push   %ebp
801031ae:	89 e5                	mov    %esp,%ebp
801031b0:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801031b3:	9c                   	pushf  
801031b4:	58                   	pop    %eax
801031b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801031b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801031bb:	c9                   	leave  
801031bc:	c3                   	ret    

801031bd <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
801031bd:	55                   	push   %ebp
801031be:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801031c0:	a1 9c 52 11 80       	mov    0x8011529c,%eax
801031c5:	8b 55 08             	mov    0x8(%ebp),%edx
801031c8:	c1 e2 02             	shl    $0x2,%edx
801031cb:	01 c2                	add    %eax,%edx
801031cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801031d0:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801031d2:	a1 9c 52 11 80       	mov    0x8011529c,%eax
801031d7:	83 c0 20             	add    $0x20,%eax
801031da:	8b 00                	mov    (%eax),%eax
}
801031dc:	90                   	nop
801031dd:	5d                   	pop    %ebp
801031de:	c3                   	ret    

801031df <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
801031df:	55                   	push   %ebp
801031e0:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
801031e2:	a1 9c 52 11 80       	mov    0x8011529c,%eax
801031e7:	85 c0                	test   %eax,%eax
801031e9:	0f 84 0b 01 00 00    	je     801032fa <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801031ef:	68 3f 01 00 00       	push   $0x13f
801031f4:	6a 3c                	push   $0x3c
801031f6:	e8 c2 ff ff ff       	call   801031bd <lapicw>
801031fb:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
801031fe:	6a 0b                	push   $0xb
80103200:	68 f8 00 00 00       	push   $0xf8
80103205:	e8 b3 ff ff ff       	call   801031bd <lapicw>
8010320a:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010320d:	68 20 00 02 00       	push   $0x20020
80103212:	68 c8 00 00 00       	push   $0xc8
80103217:	e8 a1 ff ff ff       	call   801031bd <lapicw>
8010321c:	83 c4 08             	add    $0x8,%esp
  // lapicw(TICR, 10000000); 
  lapicw(TICR, 1000000000/TPS); // PSU CS333. Makes ticks per second programmable
8010321f:	68 40 42 0f 00       	push   $0xf4240
80103224:	68 e0 00 00 00       	push   $0xe0
80103229:	e8 8f ff ff ff       	call   801031bd <lapicw>
8010322e:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80103231:	68 00 00 01 00       	push   $0x10000
80103236:	68 d4 00 00 00       	push   $0xd4
8010323b:	e8 7d ff ff ff       	call   801031bd <lapicw>
80103240:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80103243:	68 00 00 01 00       	push   $0x10000
80103248:	68 d8 00 00 00       	push   $0xd8
8010324d:	e8 6b ff ff ff       	call   801031bd <lapicw>
80103252:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103255:	a1 9c 52 11 80       	mov    0x8011529c,%eax
8010325a:	83 c0 30             	add    $0x30,%eax
8010325d:	8b 00                	mov    (%eax),%eax
8010325f:	c1 e8 10             	shr    $0x10,%eax
80103262:	0f b6 c0             	movzbl %al,%eax
80103265:	83 f8 03             	cmp    $0x3,%eax
80103268:	76 12                	jbe    8010327c <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
8010326a:	68 00 00 01 00       	push   $0x10000
8010326f:	68 d0 00 00 00       	push   $0xd0
80103274:	e8 44 ff ff ff       	call   801031bd <lapicw>
80103279:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
8010327c:	6a 33                	push   $0x33
8010327e:	68 dc 00 00 00       	push   $0xdc
80103283:	e8 35 ff ff ff       	call   801031bd <lapicw>
80103288:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
8010328b:	6a 00                	push   $0x0
8010328d:	68 a0 00 00 00       	push   $0xa0
80103292:	e8 26 ff ff ff       	call   801031bd <lapicw>
80103297:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
8010329a:	6a 00                	push   $0x0
8010329c:	68 a0 00 00 00       	push   $0xa0
801032a1:	e8 17 ff ff ff       	call   801031bd <lapicw>
801032a6:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
801032a9:	6a 00                	push   $0x0
801032ab:	6a 2c                	push   $0x2c
801032ad:	e8 0b ff ff ff       	call   801031bd <lapicw>
801032b2:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
801032b5:	6a 00                	push   $0x0
801032b7:	68 c4 00 00 00       	push   $0xc4
801032bc:	e8 fc fe ff ff       	call   801031bd <lapicw>
801032c1:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801032c4:	68 00 85 08 00       	push   $0x88500
801032c9:	68 c0 00 00 00       	push   $0xc0
801032ce:	e8 ea fe ff ff       	call   801031bd <lapicw>
801032d3:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
801032d6:	90                   	nop
801032d7:	a1 9c 52 11 80       	mov    0x8011529c,%eax
801032dc:	05 00 03 00 00       	add    $0x300,%eax
801032e1:	8b 00                	mov    (%eax),%eax
801032e3:	25 00 10 00 00       	and    $0x1000,%eax
801032e8:	85 c0                	test   %eax,%eax
801032ea:	75 eb                	jne    801032d7 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801032ec:	6a 00                	push   $0x0
801032ee:	6a 20                	push   $0x20
801032f0:	e8 c8 fe ff ff       	call   801031bd <lapicw>
801032f5:	83 c4 08             	add    $0x8,%esp
801032f8:	eb 01                	jmp    801032fb <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
801032fa:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801032fb:	c9                   	leave  
801032fc:	c3                   	ret    

801032fd <cpunum>:

int
cpunum(void)
{
801032fd:	55                   	push   %ebp
801032fe:	89 e5                	mov    %esp,%ebp
80103300:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80103303:	e8 a5 fe ff ff       	call   801031ad <readeflags>
80103308:	25 00 02 00 00       	and    $0x200,%eax
8010330d:	85 c0                	test   %eax,%eax
8010330f:	74 26                	je     80103337 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80103311:	a1 80 e6 10 80       	mov    0x8010e680,%eax
80103316:	8d 50 01             	lea    0x1(%eax),%edx
80103319:	89 15 80 e6 10 80    	mov    %edx,0x8010e680
8010331f:	85 c0                	test   %eax,%eax
80103321:	75 14                	jne    80103337 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103323:	8b 45 04             	mov    0x4(%ebp),%eax
80103326:	83 ec 08             	sub    $0x8,%esp
80103329:	50                   	push   %eax
8010332a:	68 70 a5 10 80       	push   $0x8010a570
8010332f:	e8 92 d0 ff ff       	call   801003c6 <cprintf>
80103334:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103337:	a1 9c 52 11 80       	mov    0x8011529c,%eax
8010333c:	85 c0                	test   %eax,%eax
8010333e:	74 0f                	je     8010334f <cpunum+0x52>
    return lapic[ID]>>24;
80103340:	a1 9c 52 11 80       	mov    0x8011529c,%eax
80103345:	83 c0 20             	add    $0x20,%eax
80103348:	8b 00                	mov    (%eax),%eax
8010334a:	c1 e8 18             	shr    $0x18,%eax
8010334d:	eb 05                	jmp    80103354 <cpunum+0x57>
  return 0;
8010334f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103354:	c9                   	leave  
80103355:	c3                   	ret    

80103356 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103356:	55                   	push   %ebp
80103357:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103359:	a1 9c 52 11 80       	mov    0x8011529c,%eax
8010335e:	85 c0                	test   %eax,%eax
80103360:	74 0c                	je     8010336e <lapiceoi+0x18>
    lapicw(EOI, 0);
80103362:	6a 00                	push   $0x0
80103364:	6a 2c                	push   $0x2c
80103366:	e8 52 fe ff ff       	call   801031bd <lapicw>
8010336b:	83 c4 08             	add    $0x8,%esp
}
8010336e:	90                   	nop
8010336f:	c9                   	leave  
80103370:	c3                   	ret    

80103371 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103371:	55                   	push   %ebp
80103372:	89 e5                	mov    %esp,%ebp
}
80103374:	90                   	nop
80103375:	5d                   	pop    %ebp
80103376:	c3                   	ret    

80103377 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103377:	55                   	push   %ebp
80103378:	89 e5                	mov    %esp,%ebp
8010337a:	83 ec 14             	sub    $0x14,%esp
8010337d:	8b 45 08             	mov    0x8(%ebp),%eax
80103380:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103383:	6a 0f                	push   $0xf
80103385:	6a 70                	push   $0x70
80103387:	e8 02 fe ff ff       	call   8010318e <outb>
8010338c:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
8010338f:	6a 0a                	push   $0xa
80103391:	6a 71                	push   $0x71
80103393:	e8 f6 fd ff ff       	call   8010318e <outb>
80103398:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010339b:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801033a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801033a5:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801033aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
801033ad:	83 c0 02             	add    $0x2,%eax
801033b0:	8b 55 0c             	mov    0xc(%ebp),%edx
801033b3:	c1 ea 04             	shr    $0x4,%edx
801033b6:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801033b9:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801033bd:	c1 e0 18             	shl    $0x18,%eax
801033c0:	50                   	push   %eax
801033c1:	68 c4 00 00 00       	push   $0xc4
801033c6:	e8 f2 fd ff ff       	call   801031bd <lapicw>
801033cb:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801033ce:	68 00 c5 00 00       	push   $0xc500
801033d3:	68 c0 00 00 00       	push   $0xc0
801033d8:	e8 e0 fd ff ff       	call   801031bd <lapicw>
801033dd:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801033e0:	68 c8 00 00 00       	push   $0xc8
801033e5:	e8 87 ff ff ff       	call   80103371 <microdelay>
801033ea:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801033ed:	68 00 85 00 00       	push   $0x8500
801033f2:	68 c0 00 00 00       	push   $0xc0
801033f7:	e8 c1 fd ff ff       	call   801031bd <lapicw>
801033fc:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
801033ff:	6a 64                	push   $0x64
80103401:	e8 6b ff ff ff       	call   80103371 <microdelay>
80103406:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103409:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103410:	eb 3d                	jmp    8010344f <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103412:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103416:	c1 e0 18             	shl    $0x18,%eax
80103419:	50                   	push   %eax
8010341a:	68 c4 00 00 00       	push   $0xc4
8010341f:	e8 99 fd ff ff       	call   801031bd <lapicw>
80103424:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103427:	8b 45 0c             	mov    0xc(%ebp),%eax
8010342a:	c1 e8 0c             	shr    $0xc,%eax
8010342d:	80 cc 06             	or     $0x6,%ah
80103430:	50                   	push   %eax
80103431:	68 c0 00 00 00       	push   $0xc0
80103436:	e8 82 fd ff ff       	call   801031bd <lapicw>
8010343b:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
8010343e:	68 c8 00 00 00       	push   $0xc8
80103443:	e8 29 ff ff ff       	call   80103371 <microdelay>
80103448:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010344b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010344f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103453:	7e bd                	jle    80103412 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103455:	90                   	nop
80103456:	c9                   	leave  
80103457:	c3                   	ret    

80103458 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103458:	55                   	push   %ebp
80103459:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
8010345b:	8b 45 08             	mov    0x8(%ebp),%eax
8010345e:	0f b6 c0             	movzbl %al,%eax
80103461:	50                   	push   %eax
80103462:	6a 70                	push   $0x70
80103464:	e8 25 fd ff ff       	call   8010318e <outb>
80103469:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010346c:	68 c8 00 00 00       	push   $0xc8
80103471:	e8 fb fe ff ff       	call   80103371 <microdelay>
80103476:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103479:	6a 71                	push   $0x71
8010347b:	e8 f1 fc ff ff       	call   80103171 <inb>
80103480:	83 c4 04             	add    $0x4,%esp
80103483:	0f b6 c0             	movzbl %al,%eax
}
80103486:	c9                   	leave  
80103487:	c3                   	ret    

80103488 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103488:	55                   	push   %ebp
80103489:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010348b:	6a 00                	push   $0x0
8010348d:	e8 c6 ff ff ff       	call   80103458 <cmos_read>
80103492:	83 c4 04             	add    $0x4,%esp
80103495:	89 c2                	mov    %eax,%edx
80103497:	8b 45 08             	mov    0x8(%ebp),%eax
8010349a:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
8010349c:	6a 02                	push   $0x2
8010349e:	e8 b5 ff ff ff       	call   80103458 <cmos_read>
801034a3:	83 c4 04             	add    $0x4,%esp
801034a6:	89 c2                	mov    %eax,%edx
801034a8:	8b 45 08             	mov    0x8(%ebp),%eax
801034ab:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801034ae:	6a 04                	push   $0x4
801034b0:	e8 a3 ff ff ff       	call   80103458 <cmos_read>
801034b5:	83 c4 04             	add    $0x4,%esp
801034b8:	89 c2                	mov    %eax,%edx
801034ba:	8b 45 08             	mov    0x8(%ebp),%eax
801034bd:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801034c0:	6a 07                	push   $0x7
801034c2:	e8 91 ff ff ff       	call   80103458 <cmos_read>
801034c7:	83 c4 04             	add    $0x4,%esp
801034ca:	89 c2                	mov    %eax,%edx
801034cc:	8b 45 08             	mov    0x8(%ebp),%eax
801034cf:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801034d2:	6a 08                	push   $0x8
801034d4:	e8 7f ff ff ff       	call   80103458 <cmos_read>
801034d9:	83 c4 04             	add    $0x4,%esp
801034dc:	89 c2                	mov    %eax,%edx
801034de:	8b 45 08             	mov    0x8(%ebp),%eax
801034e1:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801034e4:	6a 09                	push   $0x9
801034e6:	e8 6d ff ff ff       	call   80103458 <cmos_read>
801034eb:	83 c4 04             	add    $0x4,%esp
801034ee:	89 c2                	mov    %eax,%edx
801034f0:	8b 45 08             	mov    0x8(%ebp),%eax
801034f3:	89 50 14             	mov    %edx,0x14(%eax)
}
801034f6:	90                   	nop
801034f7:	c9                   	leave  
801034f8:	c3                   	ret    

801034f9 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801034f9:	55                   	push   %ebp
801034fa:	89 e5                	mov    %esp,%ebp
801034fc:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801034ff:	6a 0b                	push   $0xb
80103501:	e8 52 ff ff ff       	call   80103458 <cmos_read>
80103506:	83 c4 04             	add    $0x4,%esp
80103509:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010350c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010350f:	83 e0 04             	and    $0x4,%eax
80103512:	85 c0                	test   %eax,%eax
80103514:	0f 94 c0             	sete   %al
80103517:	0f b6 c0             	movzbl %al,%eax
8010351a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
8010351d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103520:	50                   	push   %eax
80103521:	e8 62 ff ff ff       	call   80103488 <fill_rtcdate>
80103526:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103529:	6a 0a                	push   $0xa
8010352b:	e8 28 ff ff ff       	call   80103458 <cmos_read>
80103530:	83 c4 04             	add    $0x4,%esp
80103533:	25 80 00 00 00       	and    $0x80,%eax
80103538:	85 c0                	test   %eax,%eax
8010353a:	75 27                	jne    80103563 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
8010353c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010353f:	50                   	push   %eax
80103540:	e8 43 ff ff ff       	call   80103488 <fill_rtcdate>
80103545:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103548:	83 ec 04             	sub    $0x4,%esp
8010354b:	6a 18                	push   $0x18
8010354d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103550:	50                   	push   %eax
80103551:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103554:	50                   	push   %eax
80103555:	e8 3d 38 00 00       	call   80106d97 <memcmp>
8010355a:	83 c4 10             	add    $0x10,%esp
8010355d:	85 c0                	test   %eax,%eax
8010355f:	74 05                	je     80103566 <cmostime+0x6d>
80103561:	eb ba                	jmp    8010351d <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
80103563:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103564:	eb b7                	jmp    8010351d <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
80103566:	90                   	nop
  }

  // convert
  if (bcd) {
80103567:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010356b:	0f 84 b4 00 00 00    	je     80103625 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103571:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103574:	c1 e8 04             	shr    $0x4,%eax
80103577:	89 c2                	mov    %eax,%edx
80103579:	89 d0                	mov    %edx,%eax
8010357b:	c1 e0 02             	shl    $0x2,%eax
8010357e:	01 d0                	add    %edx,%eax
80103580:	01 c0                	add    %eax,%eax
80103582:	89 c2                	mov    %eax,%edx
80103584:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103587:	83 e0 0f             	and    $0xf,%eax
8010358a:	01 d0                	add    %edx,%eax
8010358c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
8010358f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103592:	c1 e8 04             	shr    $0x4,%eax
80103595:	89 c2                	mov    %eax,%edx
80103597:	89 d0                	mov    %edx,%eax
80103599:	c1 e0 02             	shl    $0x2,%eax
8010359c:	01 d0                	add    %edx,%eax
8010359e:	01 c0                	add    %eax,%eax
801035a0:	89 c2                	mov    %eax,%edx
801035a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801035a5:	83 e0 0f             	and    $0xf,%eax
801035a8:	01 d0                	add    %edx,%eax
801035aa:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801035ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
801035b0:	c1 e8 04             	shr    $0x4,%eax
801035b3:	89 c2                	mov    %eax,%edx
801035b5:	89 d0                	mov    %edx,%eax
801035b7:	c1 e0 02             	shl    $0x2,%eax
801035ba:	01 d0                	add    %edx,%eax
801035bc:	01 c0                	add    %eax,%eax
801035be:	89 c2                	mov    %eax,%edx
801035c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801035c3:	83 e0 0f             	and    $0xf,%eax
801035c6:	01 d0                	add    %edx,%eax
801035c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801035cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035ce:	c1 e8 04             	shr    $0x4,%eax
801035d1:	89 c2                	mov    %eax,%edx
801035d3:	89 d0                	mov    %edx,%eax
801035d5:	c1 e0 02             	shl    $0x2,%eax
801035d8:	01 d0                	add    %edx,%eax
801035da:	01 c0                	add    %eax,%eax
801035dc:	89 c2                	mov    %eax,%edx
801035de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035e1:	83 e0 0f             	and    $0xf,%eax
801035e4:	01 d0                	add    %edx,%eax
801035e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801035e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801035ec:	c1 e8 04             	shr    $0x4,%eax
801035ef:	89 c2                	mov    %eax,%edx
801035f1:	89 d0                	mov    %edx,%eax
801035f3:	c1 e0 02             	shl    $0x2,%eax
801035f6:	01 d0                	add    %edx,%eax
801035f8:	01 c0                	add    %eax,%eax
801035fa:	89 c2                	mov    %eax,%edx
801035fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801035ff:	83 e0 0f             	and    $0xf,%eax
80103602:	01 d0                	add    %edx,%eax
80103604:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103607:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010360a:	c1 e8 04             	shr    $0x4,%eax
8010360d:	89 c2                	mov    %eax,%edx
8010360f:	89 d0                	mov    %edx,%eax
80103611:	c1 e0 02             	shl    $0x2,%eax
80103614:	01 d0                	add    %edx,%eax
80103616:	01 c0                	add    %eax,%eax
80103618:	89 c2                	mov    %eax,%edx
8010361a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010361d:	83 e0 0f             	and    $0xf,%eax
80103620:	01 d0                	add    %edx,%eax
80103622:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103625:	8b 45 08             	mov    0x8(%ebp),%eax
80103628:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010362b:	89 10                	mov    %edx,(%eax)
8010362d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103630:	89 50 04             	mov    %edx,0x4(%eax)
80103633:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103636:	89 50 08             	mov    %edx,0x8(%eax)
80103639:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010363c:	89 50 0c             	mov    %edx,0xc(%eax)
8010363f:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103642:	89 50 10             	mov    %edx,0x10(%eax)
80103645:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103648:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010364b:	8b 45 08             	mov    0x8(%ebp),%eax
8010364e:	8b 40 14             	mov    0x14(%eax),%eax
80103651:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103657:	8b 45 08             	mov    0x8(%ebp),%eax
8010365a:	89 50 14             	mov    %edx,0x14(%eax)
}
8010365d:	90                   	nop
8010365e:	c9                   	leave  
8010365f:	c3                   	ret    

80103660 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103666:	83 ec 08             	sub    $0x8,%esp
80103669:	68 9c a5 10 80       	push   $0x8010a59c
8010366e:	68 a0 52 11 80       	push   $0x801152a0
80103673:	e8 33 34 00 00       	call   80106aab <initlock>
80103678:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010367b:	83 ec 08             	sub    $0x8,%esp
8010367e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103681:	50                   	push   %eax
80103682:	ff 75 08             	pushl  0x8(%ebp)
80103685:	e8 4a de ff ff       	call   801014d4 <readsb>
8010368a:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
8010368d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103690:	a3 d4 52 11 80       	mov    %eax,0x801152d4
  log.size = sb.nlog;
80103695:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103698:	a3 d8 52 11 80       	mov    %eax,0x801152d8
  log.dev = dev;
8010369d:	8b 45 08             	mov    0x8(%ebp),%eax
801036a0:	a3 e4 52 11 80       	mov    %eax,0x801152e4
  recover_from_log();
801036a5:	e8 b2 01 00 00       	call   8010385c <recover_from_log>
}
801036aa:	90                   	nop
801036ab:	c9                   	leave  
801036ac:	c3                   	ret    

801036ad <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801036ad:	55                   	push   %ebp
801036ae:	89 e5                	mov    %esp,%ebp
801036b0:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036b3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036ba:	e9 95 00 00 00       	jmp    80103754 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801036bf:	8b 15 d4 52 11 80    	mov    0x801152d4,%edx
801036c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036c8:	01 d0                	add    %edx,%eax
801036ca:	83 c0 01             	add    $0x1,%eax
801036cd:	89 c2                	mov    %eax,%edx
801036cf:	a1 e4 52 11 80       	mov    0x801152e4,%eax
801036d4:	83 ec 08             	sub    $0x8,%esp
801036d7:	52                   	push   %edx
801036d8:	50                   	push   %eax
801036d9:	e8 d8 ca ff ff       	call   801001b6 <bread>
801036de:	83 c4 10             	add    $0x10,%esp
801036e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801036e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036e7:	83 c0 10             	add    $0x10,%eax
801036ea:	8b 04 85 ac 52 11 80 	mov    -0x7feead54(,%eax,4),%eax
801036f1:	89 c2                	mov    %eax,%edx
801036f3:	a1 e4 52 11 80       	mov    0x801152e4,%eax
801036f8:	83 ec 08             	sub    $0x8,%esp
801036fb:	52                   	push   %edx
801036fc:	50                   	push   %eax
801036fd:	e8 b4 ca ff ff       	call   801001b6 <bread>
80103702:	83 c4 10             	add    $0x10,%esp
80103705:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103708:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010370b:	8d 50 18             	lea    0x18(%eax),%edx
8010370e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103711:	83 c0 18             	add    $0x18,%eax
80103714:	83 ec 04             	sub    $0x4,%esp
80103717:	68 00 02 00 00       	push   $0x200
8010371c:	52                   	push   %edx
8010371d:	50                   	push   %eax
8010371e:	e8 cc 36 00 00       	call   80106def <memmove>
80103723:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103726:	83 ec 0c             	sub    $0xc,%esp
80103729:	ff 75 ec             	pushl  -0x14(%ebp)
8010372c:	e8 be ca ff ff       	call   801001ef <bwrite>
80103731:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
80103734:	83 ec 0c             	sub    $0xc,%esp
80103737:	ff 75 f0             	pushl  -0x10(%ebp)
8010373a:	e8 ef ca ff ff       	call   8010022e <brelse>
8010373f:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103742:	83 ec 0c             	sub    $0xc,%esp
80103745:	ff 75 ec             	pushl  -0x14(%ebp)
80103748:	e8 e1 ca ff ff       	call   8010022e <brelse>
8010374d:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103750:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103754:	a1 e8 52 11 80       	mov    0x801152e8,%eax
80103759:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010375c:	0f 8f 5d ff ff ff    	jg     801036bf <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103762:	90                   	nop
80103763:	c9                   	leave  
80103764:	c3                   	ret    

80103765 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103765:	55                   	push   %ebp
80103766:	89 e5                	mov    %esp,%ebp
80103768:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010376b:	a1 d4 52 11 80       	mov    0x801152d4,%eax
80103770:	89 c2                	mov    %eax,%edx
80103772:	a1 e4 52 11 80       	mov    0x801152e4,%eax
80103777:	83 ec 08             	sub    $0x8,%esp
8010377a:	52                   	push   %edx
8010377b:	50                   	push   %eax
8010377c:	e8 35 ca ff ff       	call   801001b6 <bread>
80103781:	83 c4 10             	add    $0x10,%esp
80103784:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103787:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010378a:	83 c0 18             	add    $0x18,%eax
8010378d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103790:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103793:	8b 00                	mov    (%eax),%eax
80103795:	a3 e8 52 11 80       	mov    %eax,0x801152e8
  for (i = 0; i < log.lh.n; i++) {
8010379a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037a1:	eb 1b                	jmp    801037be <read_head+0x59>
    log.lh.block[i] = lh->block[i];
801037a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037a9:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801037ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037b0:	83 c2 10             	add    $0x10,%edx
801037b3:	89 04 95 ac 52 11 80 	mov    %eax,-0x7feead54(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801037ba:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037be:	a1 e8 52 11 80       	mov    0x801152e8,%eax
801037c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037c6:	7f db                	jg     801037a3 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801037c8:	83 ec 0c             	sub    $0xc,%esp
801037cb:	ff 75 f0             	pushl  -0x10(%ebp)
801037ce:	e8 5b ca ff ff       	call   8010022e <brelse>
801037d3:	83 c4 10             	add    $0x10,%esp
}
801037d6:	90                   	nop
801037d7:	c9                   	leave  
801037d8:	c3                   	ret    

801037d9 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801037d9:	55                   	push   %ebp
801037da:	89 e5                	mov    %esp,%ebp
801037dc:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801037df:	a1 d4 52 11 80       	mov    0x801152d4,%eax
801037e4:	89 c2                	mov    %eax,%edx
801037e6:	a1 e4 52 11 80       	mov    0x801152e4,%eax
801037eb:	83 ec 08             	sub    $0x8,%esp
801037ee:	52                   	push   %edx
801037ef:	50                   	push   %eax
801037f0:	e8 c1 c9 ff ff       	call   801001b6 <bread>
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801037fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037fe:	83 c0 18             	add    $0x18,%eax
80103801:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103804:	8b 15 e8 52 11 80    	mov    0x801152e8,%edx
8010380a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010380d:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010380f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103816:	eb 1b                	jmp    80103833 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103818:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010381b:	83 c0 10             	add    $0x10,%eax
8010381e:	8b 0c 85 ac 52 11 80 	mov    -0x7feead54(,%eax,4),%ecx
80103825:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103828:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010382b:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010382f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103833:	a1 e8 52 11 80       	mov    0x801152e8,%eax
80103838:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010383b:	7f db                	jg     80103818 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
8010383d:	83 ec 0c             	sub    $0xc,%esp
80103840:	ff 75 f0             	pushl  -0x10(%ebp)
80103843:	e8 a7 c9 ff ff       	call   801001ef <bwrite>
80103848:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010384b:	83 ec 0c             	sub    $0xc,%esp
8010384e:	ff 75 f0             	pushl  -0x10(%ebp)
80103851:	e8 d8 c9 ff ff       	call   8010022e <brelse>
80103856:	83 c4 10             	add    $0x10,%esp
}
80103859:	90                   	nop
8010385a:	c9                   	leave  
8010385b:	c3                   	ret    

8010385c <recover_from_log>:

static void
recover_from_log(void)
{
8010385c:	55                   	push   %ebp
8010385d:	89 e5                	mov    %esp,%ebp
8010385f:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103862:	e8 fe fe ff ff       	call   80103765 <read_head>
  install_trans(); // if committed, copy from log to disk
80103867:	e8 41 fe ff ff       	call   801036ad <install_trans>
  log.lh.n = 0;
8010386c:	c7 05 e8 52 11 80 00 	movl   $0x0,0x801152e8
80103873:	00 00 00 
  write_head(); // clear the log
80103876:	e8 5e ff ff ff       	call   801037d9 <write_head>
}
8010387b:	90                   	nop
8010387c:	c9                   	leave  
8010387d:	c3                   	ret    

8010387e <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010387e:	55                   	push   %ebp
8010387f:	89 e5                	mov    %esp,%ebp
80103881:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103884:	83 ec 0c             	sub    $0xc,%esp
80103887:	68 a0 52 11 80       	push   $0x801152a0
8010388c:	e8 3c 32 00 00       	call   80106acd <acquire>
80103891:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103894:	a1 e0 52 11 80       	mov    0x801152e0,%eax
80103899:	85 c0                	test   %eax,%eax
8010389b:	74 17                	je     801038b4 <begin_op+0x36>
      sleep(&log, &log.lock);
8010389d:	83 ec 08             	sub    $0x8,%esp
801038a0:	68 a0 52 11 80       	push   $0x801152a0
801038a5:	68 a0 52 11 80       	push   $0x801152a0
801038aa:	e8 69 1f 00 00       	call   80105818 <sleep>
801038af:	83 c4 10             	add    $0x10,%esp
801038b2:	eb e0                	jmp    80103894 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801038b4:	8b 0d e8 52 11 80    	mov    0x801152e8,%ecx
801038ba:	a1 dc 52 11 80       	mov    0x801152dc,%eax
801038bf:	8d 50 01             	lea    0x1(%eax),%edx
801038c2:	89 d0                	mov    %edx,%eax
801038c4:	c1 e0 02             	shl    $0x2,%eax
801038c7:	01 d0                	add    %edx,%eax
801038c9:	01 c0                	add    %eax,%eax
801038cb:	01 c8                	add    %ecx,%eax
801038cd:	83 f8 1e             	cmp    $0x1e,%eax
801038d0:	7e 17                	jle    801038e9 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801038d2:	83 ec 08             	sub    $0x8,%esp
801038d5:	68 a0 52 11 80       	push   $0x801152a0
801038da:	68 a0 52 11 80       	push   $0x801152a0
801038df:	e8 34 1f 00 00       	call   80105818 <sleep>
801038e4:	83 c4 10             	add    $0x10,%esp
801038e7:	eb ab                	jmp    80103894 <begin_op+0x16>
    } else {
      log.outstanding += 1;
801038e9:	a1 dc 52 11 80       	mov    0x801152dc,%eax
801038ee:	83 c0 01             	add    $0x1,%eax
801038f1:	a3 dc 52 11 80       	mov    %eax,0x801152dc
      release(&log.lock);
801038f6:	83 ec 0c             	sub    $0xc,%esp
801038f9:	68 a0 52 11 80       	push   $0x801152a0
801038fe:	e8 31 32 00 00       	call   80106b34 <release>
80103903:	83 c4 10             	add    $0x10,%esp
      break;
80103906:	90                   	nop
    }
  }
}
80103907:	90                   	nop
80103908:	c9                   	leave  
80103909:	c3                   	ret    

8010390a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010390a:	55                   	push   %ebp
8010390b:	89 e5                	mov    %esp,%ebp
8010390d:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103917:	83 ec 0c             	sub    $0xc,%esp
8010391a:	68 a0 52 11 80       	push   $0x801152a0
8010391f:	e8 a9 31 00 00       	call   80106acd <acquire>
80103924:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103927:	a1 dc 52 11 80       	mov    0x801152dc,%eax
8010392c:	83 e8 01             	sub    $0x1,%eax
8010392f:	a3 dc 52 11 80       	mov    %eax,0x801152dc
  if(log.committing)
80103934:	a1 e0 52 11 80       	mov    0x801152e0,%eax
80103939:	85 c0                	test   %eax,%eax
8010393b:	74 0d                	je     8010394a <end_op+0x40>
    panic("log.committing");
8010393d:	83 ec 0c             	sub    $0xc,%esp
80103940:	68 a0 a5 10 80       	push   $0x8010a5a0
80103945:	e8 1c cc ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
8010394a:	a1 dc 52 11 80       	mov    0x801152dc,%eax
8010394f:	85 c0                	test   %eax,%eax
80103951:	75 13                	jne    80103966 <end_op+0x5c>
    do_commit = 1;
80103953:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010395a:	c7 05 e0 52 11 80 01 	movl   $0x1,0x801152e0
80103961:	00 00 00 
80103964:	eb 10                	jmp    80103976 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103966:	83 ec 0c             	sub    $0xc,%esp
80103969:	68 a0 52 11 80       	push   $0x801152a0
8010396e:	e8 00 21 00 00       	call   80105a73 <wakeup>
80103973:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103976:	83 ec 0c             	sub    $0xc,%esp
80103979:	68 a0 52 11 80       	push   $0x801152a0
8010397e:	e8 b1 31 00 00       	call   80106b34 <release>
80103983:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010398a:	74 3f                	je     801039cb <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010398c:	e8 f5 00 00 00       	call   80103a86 <commit>
    acquire(&log.lock);
80103991:	83 ec 0c             	sub    $0xc,%esp
80103994:	68 a0 52 11 80       	push   $0x801152a0
80103999:	e8 2f 31 00 00       	call   80106acd <acquire>
8010399e:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801039a1:	c7 05 e0 52 11 80 00 	movl   $0x0,0x801152e0
801039a8:	00 00 00 
    wakeup(&log);
801039ab:	83 ec 0c             	sub    $0xc,%esp
801039ae:	68 a0 52 11 80       	push   $0x801152a0
801039b3:	e8 bb 20 00 00       	call   80105a73 <wakeup>
801039b8:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801039bb:	83 ec 0c             	sub    $0xc,%esp
801039be:	68 a0 52 11 80       	push   $0x801152a0
801039c3:	e8 6c 31 00 00       	call   80106b34 <release>
801039c8:	83 c4 10             	add    $0x10,%esp
  }
}
801039cb:	90                   	nop
801039cc:	c9                   	leave  
801039cd:	c3                   	ret    

801039ce <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801039ce:	55                   	push   %ebp
801039cf:	89 e5                	mov    %esp,%ebp
801039d1:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801039d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039db:	e9 95 00 00 00       	jmp    80103a75 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801039e0:	8b 15 d4 52 11 80    	mov    0x801152d4,%edx
801039e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e9:	01 d0                	add    %edx,%eax
801039eb:	83 c0 01             	add    $0x1,%eax
801039ee:	89 c2                	mov    %eax,%edx
801039f0:	a1 e4 52 11 80       	mov    0x801152e4,%eax
801039f5:	83 ec 08             	sub    $0x8,%esp
801039f8:	52                   	push   %edx
801039f9:	50                   	push   %eax
801039fa:	e8 b7 c7 ff ff       	call   801001b6 <bread>
801039ff:	83 c4 10             	add    $0x10,%esp
80103a02:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a08:	83 c0 10             	add    $0x10,%eax
80103a0b:	8b 04 85 ac 52 11 80 	mov    -0x7feead54(,%eax,4),%eax
80103a12:	89 c2                	mov    %eax,%edx
80103a14:	a1 e4 52 11 80       	mov    0x801152e4,%eax
80103a19:	83 ec 08             	sub    $0x8,%esp
80103a1c:	52                   	push   %edx
80103a1d:	50                   	push   %eax
80103a1e:	e8 93 c7 ff ff       	call   801001b6 <bread>
80103a23:	83 c4 10             	add    $0x10,%esp
80103a26:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a2c:	8d 50 18             	lea    0x18(%eax),%edx
80103a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a32:	83 c0 18             	add    $0x18,%eax
80103a35:	83 ec 04             	sub    $0x4,%esp
80103a38:	68 00 02 00 00       	push   $0x200
80103a3d:	52                   	push   %edx
80103a3e:	50                   	push   %eax
80103a3f:	e8 ab 33 00 00       	call   80106def <memmove>
80103a44:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103a47:	83 ec 0c             	sub    $0xc,%esp
80103a4a:	ff 75 f0             	pushl  -0x10(%ebp)
80103a4d:	e8 9d c7 ff ff       	call   801001ef <bwrite>
80103a52:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103a55:	83 ec 0c             	sub    $0xc,%esp
80103a58:	ff 75 ec             	pushl  -0x14(%ebp)
80103a5b:	e8 ce c7 ff ff       	call   8010022e <brelse>
80103a60:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103a63:	83 ec 0c             	sub    $0xc,%esp
80103a66:	ff 75 f0             	pushl  -0x10(%ebp)
80103a69:	e8 c0 c7 ff ff       	call   8010022e <brelse>
80103a6e:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103a71:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a75:	a1 e8 52 11 80       	mov    0x801152e8,%eax
80103a7a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a7d:	0f 8f 5d ff ff ff    	jg     801039e0 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103a83:	90                   	nop
80103a84:	c9                   	leave  
80103a85:	c3                   	ret    

80103a86 <commit>:

static void
commit()
{
80103a86:	55                   	push   %ebp
80103a87:	89 e5                	mov    %esp,%ebp
80103a89:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103a8c:	a1 e8 52 11 80       	mov    0x801152e8,%eax
80103a91:	85 c0                	test   %eax,%eax
80103a93:	7e 1e                	jle    80103ab3 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103a95:	e8 34 ff ff ff       	call   801039ce <write_log>
    write_head();    // Write header to disk -- the real commit
80103a9a:	e8 3a fd ff ff       	call   801037d9 <write_head>
    install_trans(); // Now install writes to home locations
80103a9f:	e8 09 fc ff ff       	call   801036ad <install_trans>
    log.lh.n = 0; 
80103aa4:	c7 05 e8 52 11 80 00 	movl   $0x0,0x801152e8
80103aab:	00 00 00 
    write_head();    // Erase the transaction from the log
80103aae:	e8 26 fd ff ff       	call   801037d9 <write_head>
  }
}
80103ab3:	90                   	nop
80103ab4:	c9                   	leave  
80103ab5:	c3                   	ret    

80103ab6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103ab6:	55                   	push   %ebp
80103ab7:	89 e5                	mov    %esp,%ebp
80103ab9:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103abc:	a1 e8 52 11 80       	mov    0x801152e8,%eax
80103ac1:	83 f8 1d             	cmp    $0x1d,%eax
80103ac4:	7f 12                	jg     80103ad8 <log_write+0x22>
80103ac6:	a1 e8 52 11 80       	mov    0x801152e8,%eax
80103acb:	8b 15 d8 52 11 80    	mov    0x801152d8,%edx
80103ad1:	83 ea 01             	sub    $0x1,%edx
80103ad4:	39 d0                	cmp    %edx,%eax
80103ad6:	7c 0d                	jl     80103ae5 <log_write+0x2f>
    panic("too big a transaction");
80103ad8:	83 ec 0c             	sub    $0xc,%esp
80103adb:	68 af a5 10 80       	push   $0x8010a5af
80103ae0:	e8 81 ca ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103ae5:	a1 dc 52 11 80       	mov    0x801152dc,%eax
80103aea:	85 c0                	test   %eax,%eax
80103aec:	7f 0d                	jg     80103afb <log_write+0x45>
    panic("log_write outside of trans");
80103aee:	83 ec 0c             	sub    $0xc,%esp
80103af1:	68 c5 a5 10 80       	push   $0x8010a5c5
80103af6:	e8 6b ca ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103afb:	83 ec 0c             	sub    $0xc,%esp
80103afe:	68 a0 52 11 80       	push   $0x801152a0
80103b03:	e8 c5 2f 00 00       	call   80106acd <acquire>
80103b08:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103b0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103b12:	eb 1d                	jmp    80103b31 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b17:	83 c0 10             	add    $0x10,%eax
80103b1a:	8b 04 85 ac 52 11 80 	mov    -0x7feead54(,%eax,4),%eax
80103b21:	89 c2                	mov    %eax,%edx
80103b23:	8b 45 08             	mov    0x8(%ebp),%eax
80103b26:	8b 40 08             	mov    0x8(%eax),%eax
80103b29:	39 c2                	cmp    %eax,%edx
80103b2b:	74 10                	je     80103b3d <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103b2d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103b31:	a1 e8 52 11 80       	mov    0x801152e8,%eax
80103b36:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b39:	7f d9                	jg     80103b14 <log_write+0x5e>
80103b3b:	eb 01                	jmp    80103b3e <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103b3d:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103b3e:	8b 45 08             	mov    0x8(%ebp),%eax
80103b41:	8b 40 08             	mov    0x8(%eax),%eax
80103b44:	89 c2                	mov    %eax,%edx
80103b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b49:	83 c0 10             	add    $0x10,%eax
80103b4c:	89 14 85 ac 52 11 80 	mov    %edx,-0x7feead54(,%eax,4)
  if (i == log.lh.n)
80103b53:	a1 e8 52 11 80       	mov    0x801152e8,%eax
80103b58:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b5b:	75 0d                	jne    80103b6a <log_write+0xb4>
    log.lh.n++;
80103b5d:	a1 e8 52 11 80       	mov    0x801152e8,%eax
80103b62:	83 c0 01             	add    $0x1,%eax
80103b65:	a3 e8 52 11 80       	mov    %eax,0x801152e8
  b->flags |= B_DIRTY; // prevent eviction
80103b6a:	8b 45 08             	mov    0x8(%ebp),%eax
80103b6d:	8b 00                	mov    (%eax),%eax
80103b6f:	83 c8 04             	or     $0x4,%eax
80103b72:	89 c2                	mov    %eax,%edx
80103b74:	8b 45 08             	mov    0x8(%ebp),%eax
80103b77:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103b79:	83 ec 0c             	sub    $0xc,%esp
80103b7c:	68 a0 52 11 80       	push   $0x801152a0
80103b81:	e8 ae 2f 00 00       	call   80106b34 <release>
80103b86:	83 c4 10             	add    $0x10,%esp
}
80103b89:	90                   	nop
80103b8a:	c9                   	leave  
80103b8b:	c3                   	ret    

80103b8c <v2p>:
80103b8c:	55                   	push   %ebp
80103b8d:	89 e5                	mov    %esp,%ebp
80103b8f:	8b 45 08             	mov    0x8(%ebp),%eax
80103b92:	05 00 00 00 80       	add    $0x80000000,%eax
80103b97:	5d                   	pop    %ebp
80103b98:	c3                   	ret    

80103b99 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103b99:	55                   	push   %ebp
80103b9a:	89 e5                	mov    %esp,%ebp
80103b9c:	8b 45 08             	mov    0x8(%ebp),%eax
80103b9f:	05 00 00 00 80       	add    $0x80000000,%eax
80103ba4:	5d                   	pop    %ebp
80103ba5:	c3                   	ret    

80103ba6 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103ba6:	55                   	push   %ebp
80103ba7:	89 e5                	mov    %esp,%ebp
80103ba9:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103bac:	8b 55 08             	mov    0x8(%ebp),%edx
80103baf:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103bb5:	f0 87 02             	lock xchg %eax,(%edx)
80103bb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103bbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103bbe:	c9                   	leave  
80103bbf:	c3                   	ret    

80103bc0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103bc0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103bc4:	83 e4 f0             	and    $0xfffffff0,%esp
80103bc7:	ff 71 fc             	pushl  -0x4(%ecx)
80103bca:	55                   	push   %ebp
80103bcb:	89 e5                	mov    %esp,%ebp
80103bcd:	51                   	push   %ecx
80103bce:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103bd1:	83 ec 08             	sub    $0x8,%esp
80103bd4:	68 00 00 40 80       	push   $0x80400000
80103bd9:	68 5c 89 11 80       	push   $0x8011895c
80103bde:	e8 7d f2 ff ff       	call   80102e60 <kinit1>
80103be3:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103be6:	e8 c4 5f 00 00       	call   80109baf <kvmalloc>
  mpinit();        // collect info about this machine
80103beb:	e8 43 04 00 00       	call   80104033 <mpinit>
  lapicinit();
80103bf0:	e8 ea f5 ff ff       	call   801031df <lapicinit>
  seginit();       // set up segments
80103bf5:	e8 5e 59 00 00       	call   80109558 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103bfa:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c00:	0f b6 00             	movzbl (%eax),%eax
80103c03:	0f b6 c0             	movzbl %al,%eax
80103c06:	83 ec 08             	sub    $0x8,%esp
80103c09:	50                   	push   %eax
80103c0a:	68 e0 a5 10 80       	push   $0x8010a5e0
80103c0f:	e8 b2 c7 ff ff       	call   801003c6 <cprintf>
80103c14:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103c17:	e8 6d 06 00 00       	call   80104289 <picinit>
  ioapicinit();    // another interrupt controller
80103c1c:	e8 34 f1 ff ff       	call   80102d55 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103c21:	e8 a4 cf ff ff       	call   80100bca <consoleinit>
  uartinit();      // serial port
80103c26:	e8 89 4c 00 00       	call   801088b4 <uartinit>
  pinit();         // process table
80103c2b:	e8 5d 0b 00 00       	call   8010478d <pinit>
  tvinit();        // trap vectors
80103c30:	e8 58 48 00 00       	call   8010848d <tvinit>
  binit();         // buffer cache
80103c35:	e8 fa c3 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103c3a:	e8 86 d4 ff ff       	call   801010c5 <fileinit>
  ideinit();       // disk
80103c3f:	e8 19 ed ff ff       	call   8010295d <ideinit>
  if(!ismp)
80103c44:	a1 84 53 11 80       	mov    0x80115384,%eax
80103c49:	85 c0                	test   %eax,%eax
80103c4b:	75 05                	jne    80103c52 <main+0x92>
    timerinit();   // uniprocessor timer
80103c4d:	e8 8c 47 00 00       	call   801083de <timerinit>
  startothers();   // start other processors
80103c52:	e8 7f 00 00 00       	call   80103cd6 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103c57:	83 ec 08             	sub    $0x8,%esp
80103c5a:	68 00 00 00 8e       	push   $0x8e000000
80103c5f:	68 00 00 40 80       	push   $0x80400000
80103c64:	e8 30 f2 ff ff       	call   80102e99 <kinit2>
80103c69:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103c6c:	e8 1e 0d 00 00       	call   8010498f <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103c71:	e8 1a 00 00 00       	call   80103c90 <mpmain>

80103c76 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103c76:	55                   	push   %ebp
80103c77:	89 e5                	mov    %esp,%ebp
80103c79:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103c7c:	e8 46 5f 00 00       	call   80109bc7 <switchkvm>
  seginit();
80103c81:	e8 d2 58 00 00       	call   80109558 <seginit>
  lapicinit();
80103c86:	e8 54 f5 ff ff       	call   801031df <lapicinit>
  mpmain();
80103c8b:	e8 00 00 00 00       	call   80103c90 <mpmain>

80103c90 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103c96:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c9c:	0f b6 00             	movzbl (%eax),%eax
80103c9f:	0f b6 c0             	movzbl %al,%eax
80103ca2:	83 ec 08             	sub    $0x8,%esp
80103ca5:	50                   	push   %eax
80103ca6:	68 f7 a5 10 80       	push   $0x8010a5f7
80103cab:	e8 16 c7 ff ff       	call   801003c6 <cprintf>
80103cb0:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103cb3:	e8 36 49 00 00       	call   801085ee <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103cb8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103cbe:	05 a8 00 00 00       	add    $0xa8,%eax
80103cc3:	83 ec 08             	sub    $0x8,%esp
80103cc6:	6a 01                	push   $0x1
80103cc8:	50                   	push   %eax
80103cc9:	e8 d8 fe ff ff       	call   80103ba6 <xchg>
80103cce:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103cd1:	e8 3b 17 00 00       	call   80105411 <scheduler>

80103cd6 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103cd6:	55                   	push   %ebp
80103cd7:	89 e5                	mov    %esp,%ebp
80103cd9:	53                   	push   %ebx
80103cda:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103cdd:	68 00 70 00 00       	push   $0x7000
80103ce2:	e8 b2 fe ff ff       	call   80103b99 <p2v>
80103ce7:	83 c4 04             	add    $0x4,%esp
80103cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103ced:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103cf2:	83 ec 04             	sub    $0x4,%esp
80103cf5:	50                   	push   %eax
80103cf6:	68 4c e5 10 80       	push   $0x8010e54c
80103cfb:	ff 75 f0             	pushl  -0x10(%ebp)
80103cfe:	e8 ec 30 00 00       	call   80106def <memmove>
80103d03:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103d06:	c7 45 f4 a0 53 11 80 	movl   $0x801153a0,-0xc(%ebp)
80103d0d:	e9 90 00 00 00       	jmp    80103da2 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103d12:	e8 e6 f5 ff ff       	call   801032fd <cpunum>
80103d17:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d1d:	05 a0 53 11 80       	add    $0x801153a0,%eax
80103d22:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d25:	74 73                	je     80103d9a <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103d27:	e8 6b f2 ff ff       	call   80102f97 <kalloc>
80103d2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103d2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d32:	83 e8 04             	sub    $0x4,%eax
80103d35:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103d38:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103d3e:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d43:	83 e8 08             	sub    $0x8,%eax
80103d46:	c7 00 76 3c 10 80    	movl   $0x80103c76,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d4f:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103d52:	83 ec 0c             	sub    $0xc,%esp
80103d55:	68 00 d0 10 80       	push   $0x8010d000
80103d5a:	e8 2d fe ff ff       	call   80103b8c <v2p>
80103d5f:	83 c4 10             	add    $0x10,%esp
80103d62:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103d64:	83 ec 0c             	sub    $0xc,%esp
80103d67:	ff 75 f0             	pushl  -0x10(%ebp)
80103d6a:	e8 1d fe ff ff       	call   80103b8c <v2p>
80103d6f:	83 c4 10             	add    $0x10,%esp
80103d72:	89 c2                	mov    %eax,%edx
80103d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d77:	0f b6 00             	movzbl (%eax),%eax
80103d7a:	0f b6 c0             	movzbl %al,%eax
80103d7d:	83 ec 08             	sub    $0x8,%esp
80103d80:	52                   	push   %edx
80103d81:	50                   	push   %eax
80103d82:	e8 f0 f5 ff ff       	call   80103377 <lapicstartap>
80103d87:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103d8a:	90                   	nop
80103d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d8e:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103d94:	85 c0                	test   %eax,%eax
80103d96:	74 f3                	je     80103d8b <startothers+0xb5>
80103d98:	eb 01                	jmp    80103d9b <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103d9a:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103d9b:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103da2:	a1 80 59 11 80       	mov    0x80115980,%eax
80103da7:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103dad:	05 a0 53 11 80       	add    $0x801153a0,%eax
80103db2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103db5:	0f 87 57 ff ff ff    	ja     80103d12 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103dbb:	90                   	nop
80103dbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dbf:	c9                   	leave  
80103dc0:	c3                   	ret    

80103dc1 <p2v>:
80103dc1:	55                   	push   %ebp
80103dc2:	89 e5                	mov    %esp,%ebp
80103dc4:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc7:	05 00 00 00 80       	add    $0x80000000,%eax
80103dcc:	5d                   	pop    %ebp
80103dcd:	c3                   	ret    

80103dce <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103dce:	55                   	push   %ebp
80103dcf:	89 e5                	mov    %esp,%ebp
80103dd1:	83 ec 14             	sub    $0x14,%esp
80103dd4:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103ddb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103ddf:	89 c2                	mov    %eax,%edx
80103de1:	ec                   	in     (%dx),%al
80103de2:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103de5:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103de9:	c9                   	leave  
80103dea:	c3                   	ret    

80103deb <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103deb:	55                   	push   %ebp
80103dec:	89 e5                	mov    %esp,%ebp
80103dee:	83 ec 08             	sub    $0x8,%esp
80103df1:	8b 55 08             	mov    0x8(%ebp),%edx
80103df4:	8b 45 0c             	mov    0xc(%ebp),%eax
80103df7:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103dfb:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dfe:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e02:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e06:	ee                   	out    %al,(%dx)
}
80103e07:	90                   	nop
80103e08:	c9                   	leave  
80103e09:	c3                   	ret    

80103e0a <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103e0a:	55                   	push   %ebp
80103e0b:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103e0d:	a1 84 e6 10 80       	mov    0x8010e684,%eax
80103e12:	89 c2                	mov    %eax,%edx
80103e14:	b8 a0 53 11 80       	mov    $0x801153a0,%eax
80103e19:	29 c2                	sub    %eax,%edx
80103e1b:	89 d0                	mov    %edx,%eax
80103e1d:	c1 f8 02             	sar    $0x2,%eax
80103e20:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103e26:	5d                   	pop    %ebp
80103e27:	c3                   	ret    

80103e28 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103e28:	55                   	push   %ebp
80103e29:	89 e5                	mov    %esp,%ebp
80103e2b:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103e2e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103e35:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103e3c:	eb 15                	jmp    80103e53 <sum+0x2b>
    sum += addr[i];
80103e3e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103e41:	8b 45 08             	mov    0x8(%ebp),%eax
80103e44:	01 d0                	add    %edx,%eax
80103e46:	0f b6 00             	movzbl (%eax),%eax
80103e49:	0f b6 c0             	movzbl %al,%eax
80103e4c:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103e4f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103e53:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103e56:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103e59:	7c e3                	jl     80103e3e <sum+0x16>
    sum += addr[i];
  return sum;
80103e5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103e5e:	c9                   	leave  
80103e5f:	c3                   	ret    

80103e60 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103e66:	ff 75 08             	pushl  0x8(%ebp)
80103e69:	e8 53 ff ff ff       	call   80103dc1 <p2v>
80103e6e:	83 c4 04             	add    $0x4,%esp
80103e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103e74:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e7a:	01 d0                	add    %edx,%eax
80103e7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e82:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e85:	eb 36                	jmp    80103ebd <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103e87:	83 ec 04             	sub    $0x4,%esp
80103e8a:	6a 04                	push   $0x4
80103e8c:	68 08 a6 10 80       	push   $0x8010a608
80103e91:	ff 75 f4             	pushl  -0xc(%ebp)
80103e94:	e8 fe 2e 00 00       	call   80106d97 <memcmp>
80103e99:	83 c4 10             	add    $0x10,%esp
80103e9c:	85 c0                	test   %eax,%eax
80103e9e:	75 19                	jne    80103eb9 <mpsearch1+0x59>
80103ea0:	83 ec 08             	sub    $0x8,%esp
80103ea3:	6a 10                	push   $0x10
80103ea5:	ff 75 f4             	pushl  -0xc(%ebp)
80103ea8:	e8 7b ff ff ff       	call   80103e28 <sum>
80103ead:	83 c4 10             	add    $0x10,%esp
80103eb0:	84 c0                	test   %al,%al
80103eb2:	75 05                	jne    80103eb9 <mpsearch1+0x59>
      return (struct mp*)p;
80103eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eb7:	eb 11                	jmp    80103eca <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103eb9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ec0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ec3:	72 c2                	jb     80103e87 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103ec5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103eca:	c9                   	leave  
80103ecb:	c3                   	ret    

80103ecc <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103ecc:	55                   	push   %ebp
80103ecd:	89 e5                	mov    %esp,%ebp
80103ecf:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103ed2:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103edc:	83 c0 0f             	add    $0xf,%eax
80103edf:	0f b6 00             	movzbl (%eax),%eax
80103ee2:	0f b6 c0             	movzbl %al,%eax
80103ee5:	c1 e0 08             	shl    $0x8,%eax
80103ee8:	89 c2                	mov    %eax,%edx
80103eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eed:	83 c0 0e             	add    $0xe,%eax
80103ef0:	0f b6 00             	movzbl (%eax),%eax
80103ef3:	0f b6 c0             	movzbl %al,%eax
80103ef6:	09 d0                	or     %edx,%eax
80103ef8:	c1 e0 04             	shl    $0x4,%eax
80103efb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103efe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103f02:	74 21                	je     80103f25 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103f04:	83 ec 08             	sub    $0x8,%esp
80103f07:	68 00 04 00 00       	push   $0x400
80103f0c:	ff 75 f0             	pushl  -0x10(%ebp)
80103f0f:	e8 4c ff ff ff       	call   80103e60 <mpsearch1>
80103f14:	83 c4 10             	add    $0x10,%esp
80103f17:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f1a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f1e:	74 51                	je     80103f71 <mpsearch+0xa5>
      return mp;
80103f20:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f23:	eb 61                	jmp    80103f86 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f28:	83 c0 14             	add    $0x14,%eax
80103f2b:	0f b6 00             	movzbl (%eax),%eax
80103f2e:	0f b6 c0             	movzbl %al,%eax
80103f31:	c1 e0 08             	shl    $0x8,%eax
80103f34:	89 c2                	mov    %eax,%edx
80103f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f39:	83 c0 13             	add    $0x13,%eax
80103f3c:	0f b6 00             	movzbl (%eax),%eax
80103f3f:	0f b6 c0             	movzbl %al,%eax
80103f42:	09 d0                	or     %edx,%eax
80103f44:	c1 e0 0a             	shl    $0xa,%eax
80103f47:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f4d:	2d 00 04 00 00       	sub    $0x400,%eax
80103f52:	83 ec 08             	sub    $0x8,%esp
80103f55:	68 00 04 00 00       	push   $0x400
80103f5a:	50                   	push   %eax
80103f5b:	e8 00 ff ff ff       	call   80103e60 <mpsearch1>
80103f60:	83 c4 10             	add    $0x10,%esp
80103f63:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f66:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f6a:	74 05                	je     80103f71 <mpsearch+0xa5>
      return mp;
80103f6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f6f:	eb 15                	jmp    80103f86 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103f71:	83 ec 08             	sub    $0x8,%esp
80103f74:	68 00 00 01 00       	push   $0x10000
80103f79:	68 00 00 0f 00       	push   $0xf0000
80103f7e:	e8 dd fe ff ff       	call   80103e60 <mpsearch1>
80103f83:	83 c4 10             	add    $0x10,%esp
}
80103f86:	c9                   	leave  
80103f87:	c3                   	ret    

80103f88 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103f88:	55                   	push   %ebp
80103f89:	89 e5                	mov    %esp,%ebp
80103f8b:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103f8e:	e8 39 ff ff ff       	call   80103ecc <mpsearch>
80103f93:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103f96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103f9a:	74 0a                	je     80103fa6 <mpconfig+0x1e>
80103f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f9f:	8b 40 04             	mov    0x4(%eax),%eax
80103fa2:	85 c0                	test   %eax,%eax
80103fa4:	75 0a                	jne    80103fb0 <mpconfig+0x28>
    return 0;
80103fa6:	b8 00 00 00 00       	mov    $0x0,%eax
80103fab:	e9 81 00 00 00       	jmp    80104031 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fb3:	8b 40 04             	mov    0x4(%eax),%eax
80103fb6:	83 ec 0c             	sub    $0xc,%esp
80103fb9:	50                   	push   %eax
80103fba:	e8 02 fe ff ff       	call   80103dc1 <p2v>
80103fbf:	83 c4 10             	add    $0x10,%esp
80103fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103fc5:	83 ec 04             	sub    $0x4,%esp
80103fc8:	6a 04                	push   $0x4
80103fca:	68 0d a6 10 80       	push   $0x8010a60d
80103fcf:	ff 75 f0             	pushl  -0x10(%ebp)
80103fd2:	e8 c0 2d 00 00       	call   80106d97 <memcmp>
80103fd7:	83 c4 10             	add    $0x10,%esp
80103fda:	85 c0                	test   %eax,%eax
80103fdc:	74 07                	je     80103fe5 <mpconfig+0x5d>
    return 0;
80103fde:	b8 00 00 00 00       	mov    $0x0,%eax
80103fe3:	eb 4c                	jmp    80104031 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103fe8:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103fec:	3c 01                	cmp    $0x1,%al
80103fee:	74 12                	je     80104002 <mpconfig+0x7a>
80103ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ff3:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103ff7:	3c 04                	cmp    $0x4,%al
80103ff9:	74 07                	je     80104002 <mpconfig+0x7a>
    return 0;
80103ffb:	b8 00 00 00 00       	mov    $0x0,%eax
80104000:	eb 2f                	jmp    80104031 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80104002:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104005:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80104009:	0f b7 c0             	movzwl %ax,%eax
8010400c:	83 ec 08             	sub    $0x8,%esp
8010400f:	50                   	push   %eax
80104010:	ff 75 f0             	pushl  -0x10(%ebp)
80104013:	e8 10 fe ff ff       	call   80103e28 <sum>
80104018:	83 c4 10             	add    $0x10,%esp
8010401b:	84 c0                	test   %al,%al
8010401d:	74 07                	je     80104026 <mpconfig+0x9e>
    return 0;
8010401f:	b8 00 00 00 00       	mov    $0x0,%eax
80104024:	eb 0b                	jmp    80104031 <mpconfig+0xa9>
  *pmp = mp;
80104026:	8b 45 08             	mov    0x8(%ebp),%eax
80104029:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010402c:	89 10                	mov    %edx,(%eax)
  return conf;
8010402e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80104031:	c9                   	leave  
80104032:	c3                   	ret    

80104033 <mpinit>:

void
mpinit(void)
{
80104033:	55                   	push   %ebp
80104034:	89 e5                	mov    %esp,%ebp
80104036:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80104039:	c7 05 84 e6 10 80 a0 	movl   $0x801153a0,0x8010e684
80104040:	53 11 80 
  if((conf = mpconfig(&mp)) == 0)
80104043:	83 ec 0c             	sub    $0xc,%esp
80104046:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104049:	50                   	push   %eax
8010404a:	e8 39 ff ff ff       	call   80103f88 <mpconfig>
8010404f:	83 c4 10             	add    $0x10,%esp
80104052:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104055:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104059:	0f 84 96 01 00 00    	je     801041f5 <mpinit+0x1c2>
    return;
  ismp = 1;
8010405f:	c7 05 84 53 11 80 01 	movl   $0x1,0x80115384
80104066:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80104069:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010406c:	8b 40 24             	mov    0x24(%eax),%eax
8010406f:	a3 9c 52 11 80       	mov    %eax,0x8011529c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104074:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104077:	83 c0 2c             	add    $0x2c,%eax
8010407a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010407d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104080:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80104084:	0f b7 d0             	movzwl %ax,%edx
80104087:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010408a:	01 d0                	add    %edx,%eax
8010408c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010408f:	e9 f2 00 00 00       	jmp    80104186 <mpinit+0x153>
    switch(*p){
80104094:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104097:	0f b6 00             	movzbl (%eax),%eax
8010409a:	0f b6 c0             	movzbl %al,%eax
8010409d:	83 f8 04             	cmp    $0x4,%eax
801040a0:	0f 87 bc 00 00 00    	ja     80104162 <mpinit+0x12f>
801040a6:	8b 04 85 50 a6 10 80 	mov    -0x7fef59b0(,%eax,4),%eax
801040ad:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801040af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801040b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801040b8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801040bc:	0f b6 d0             	movzbl %al,%edx
801040bf:	a1 80 59 11 80       	mov    0x80115980,%eax
801040c4:	39 c2                	cmp    %eax,%edx
801040c6:	74 2b                	je     801040f3 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801040c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801040cb:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801040cf:	0f b6 d0             	movzbl %al,%edx
801040d2:	a1 80 59 11 80       	mov    0x80115980,%eax
801040d7:	83 ec 04             	sub    $0x4,%esp
801040da:	52                   	push   %edx
801040db:	50                   	push   %eax
801040dc:	68 12 a6 10 80       	push   $0x8010a612
801040e1:	e8 e0 c2 ff ff       	call   801003c6 <cprintf>
801040e6:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
801040e9:	c7 05 84 53 11 80 00 	movl   $0x0,0x80115384
801040f0:	00 00 00 
      }
      if(proc->flags & MPBOOT)
801040f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801040f6:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801040fa:	0f b6 c0             	movzbl %al,%eax
801040fd:	83 e0 02             	and    $0x2,%eax
80104100:	85 c0                	test   %eax,%eax
80104102:	74 15                	je     80104119 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80104104:	a1 80 59 11 80       	mov    0x80115980,%eax
80104109:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010410f:	05 a0 53 11 80       	add    $0x801153a0,%eax
80104114:	a3 84 e6 10 80       	mov    %eax,0x8010e684
      cpus[ncpu].id = ncpu;
80104119:	a1 80 59 11 80       	mov    0x80115980,%eax
8010411e:	8b 15 80 59 11 80    	mov    0x80115980,%edx
80104124:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010412a:	05 a0 53 11 80       	add    $0x801153a0,%eax
8010412f:	88 10                	mov    %dl,(%eax)
      ncpu++;
80104131:	a1 80 59 11 80       	mov    0x80115980,%eax
80104136:	83 c0 01             	add    $0x1,%eax
80104139:	a3 80 59 11 80       	mov    %eax,0x80115980
      p += sizeof(struct mpproc);
8010413e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80104142:	eb 42                	jmp    80104186 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80104144:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104147:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
8010414a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010414d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104151:	a2 80 53 11 80       	mov    %al,0x80115380
      p += sizeof(struct mpioapic);
80104156:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010415a:	eb 2a                	jmp    80104186 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010415c:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104160:	eb 24                	jmp    80104186 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80104162:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104165:	0f b6 00             	movzbl (%eax),%eax
80104168:	0f b6 c0             	movzbl %al,%eax
8010416b:	83 ec 08             	sub    $0x8,%esp
8010416e:	50                   	push   %eax
8010416f:	68 30 a6 10 80       	push   $0x8010a630
80104174:	e8 4d c2 ff ff       	call   801003c6 <cprintf>
80104179:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
8010417c:	c7 05 84 53 11 80 00 	movl   $0x0,0x80115384
80104183:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104189:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010418c:	0f 82 02 ff ff ff    	jb     80104094 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80104192:	a1 84 53 11 80       	mov    0x80115384,%eax
80104197:	85 c0                	test   %eax,%eax
80104199:	75 1d                	jne    801041b8 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
8010419b:	c7 05 80 59 11 80 01 	movl   $0x1,0x80115980
801041a2:	00 00 00 
    lapic = 0;
801041a5:	c7 05 9c 52 11 80 00 	movl   $0x0,0x8011529c
801041ac:	00 00 00 
    ioapicid = 0;
801041af:	c6 05 80 53 11 80 00 	movb   $0x0,0x80115380
    return;
801041b6:	eb 3e                	jmp    801041f6 <mpinit+0x1c3>
  }

  if(mp->imcrp){
801041b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801041bb:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801041bf:	84 c0                	test   %al,%al
801041c1:	74 33                	je     801041f6 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801041c3:	83 ec 08             	sub    $0x8,%esp
801041c6:	6a 70                	push   $0x70
801041c8:	6a 22                	push   $0x22
801041ca:	e8 1c fc ff ff       	call   80103deb <outb>
801041cf:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801041d2:	83 ec 0c             	sub    $0xc,%esp
801041d5:	6a 23                	push   $0x23
801041d7:	e8 f2 fb ff ff       	call   80103dce <inb>
801041dc:	83 c4 10             	add    $0x10,%esp
801041df:	83 c8 01             	or     $0x1,%eax
801041e2:	0f b6 c0             	movzbl %al,%eax
801041e5:	83 ec 08             	sub    $0x8,%esp
801041e8:	50                   	push   %eax
801041e9:	6a 23                	push   $0x23
801041eb:	e8 fb fb ff ff       	call   80103deb <outb>
801041f0:	83 c4 10             	add    $0x10,%esp
801041f3:	eb 01                	jmp    801041f6 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
801041f5:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801041f6:	c9                   	leave  
801041f7:	c3                   	ret    

801041f8 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801041f8:	55                   	push   %ebp
801041f9:	89 e5                	mov    %esp,%ebp
801041fb:	83 ec 08             	sub    $0x8,%esp
801041fe:	8b 55 08             	mov    0x8(%ebp),%edx
80104201:	8b 45 0c             	mov    0xc(%ebp),%eax
80104204:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80104208:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010420b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010420f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80104213:	ee                   	out    %al,(%dx)
}
80104214:	90                   	nop
80104215:	c9                   	leave  
80104216:	c3                   	ret    

80104217 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80104217:	55                   	push   %ebp
80104218:	89 e5                	mov    %esp,%ebp
8010421a:	83 ec 04             	sub    $0x4,%esp
8010421d:	8b 45 08             	mov    0x8(%ebp),%eax
80104220:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80104224:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104228:	66 a3 00 e0 10 80    	mov    %ax,0x8010e000
  outb(IO_PIC1+1, mask);
8010422e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104232:	0f b6 c0             	movzbl %al,%eax
80104235:	50                   	push   %eax
80104236:	6a 21                	push   $0x21
80104238:	e8 bb ff ff ff       	call   801041f8 <outb>
8010423d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80104240:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104244:	66 c1 e8 08          	shr    $0x8,%ax
80104248:	0f b6 c0             	movzbl %al,%eax
8010424b:	50                   	push   %eax
8010424c:	68 a1 00 00 00       	push   $0xa1
80104251:	e8 a2 ff ff ff       	call   801041f8 <outb>
80104256:	83 c4 08             	add    $0x8,%esp
}
80104259:	90                   	nop
8010425a:	c9                   	leave  
8010425b:	c3                   	ret    

8010425c <picenable>:

void
picenable(int irq)
{
8010425c:	55                   	push   %ebp
8010425d:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010425f:	8b 45 08             	mov    0x8(%ebp),%eax
80104262:	ba 01 00 00 00       	mov    $0x1,%edx
80104267:	89 c1                	mov    %eax,%ecx
80104269:	d3 e2                	shl    %cl,%edx
8010426b:	89 d0                	mov    %edx,%eax
8010426d:	f7 d0                	not    %eax
8010426f:	89 c2                	mov    %eax,%edx
80104271:	0f b7 05 00 e0 10 80 	movzwl 0x8010e000,%eax
80104278:	21 d0                	and    %edx,%eax
8010427a:	0f b7 c0             	movzwl %ax,%eax
8010427d:	50                   	push   %eax
8010427e:	e8 94 ff ff ff       	call   80104217 <picsetmask>
80104283:	83 c4 04             	add    $0x4,%esp
}
80104286:	90                   	nop
80104287:	c9                   	leave  
80104288:	c3                   	ret    

80104289 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80104289:	55                   	push   %ebp
8010428a:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
8010428c:	68 ff 00 00 00       	push   $0xff
80104291:	6a 21                	push   $0x21
80104293:	e8 60 ff ff ff       	call   801041f8 <outb>
80104298:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
8010429b:	68 ff 00 00 00       	push   $0xff
801042a0:	68 a1 00 00 00       	push   $0xa1
801042a5:	e8 4e ff ff ff       	call   801041f8 <outb>
801042aa:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
801042ad:	6a 11                	push   $0x11
801042af:	6a 20                	push   $0x20
801042b1:	e8 42 ff ff ff       	call   801041f8 <outb>
801042b6:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
801042b9:	6a 20                	push   $0x20
801042bb:	6a 21                	push   $0x21
801042bd:	e8 36 ff ff ff       	call   801041f8 <outb>
801042c2:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
801042c5:	6a 04                	push   $0x4
801042c7:	6a 21                	push   $0x21
801042c9:	e8 2a ff ff ff       	call   801041f8 <outb>
801042ce:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
801042d1:	6a 03                	push   $0x3
801042d3:	6a 21                	push   $0x21
801042d5:	e8 1e ff ff ff       	call   801041f8 <outb>
801042da:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
801042dd:	6a 11                	push   $0x11
801042df:	68 a0 00 00 00       	push   $0xa0
801042e4:	e8 0f ff ff ff       	call   801041f8 <outb>
801042e9:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
801042ec:	6a 28                	push   $0x28
801042ee:	68 a1 00 00 00       	push   $0xa1
801042f3:	e8 00 ff ff ff       	call   801041f8 <outb>
801042f8:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
801042fb:	6a 02                	push   $0x2
801042fd:	68 a1 00 00 00       	push   $0xa1
80104302:	e8 f1 fe ff ff       	call   801041f8 <outb>
80104307:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
8010430a:	6a 03                	push   $0x3
8010430c:	68 a1 00 00 00       	push   $0xa1
80104311:	e8 e2 fe ff ff       	call   801041f8 <outb>
80104316:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104319:	6a 68                	push   $0x68
8010431b:	6a 20                	push   $0x20
8010431d:	e8 d6 fe ff ff       	call   801041f8 <outb>
80104322:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104325:	6a 0a                	push   $0xa
80104327:	6a 20                	push   $0x20
80104329:	e8 ca fe ff ff       	call   801041f8 <outb>
8010432e:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80104331:	6a 68                	push   $0x68
80104333:	68 a0 00 00 00       	push   $0xa0
80104338:	e8 bb fe ff ff       	call   801041f8 <outb>
8010433d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80104340:	6a 0a                	push   $0xa
80104342:	68 a0 00 00 00       	push   $0xa0
80104347:	e8 ac fe ff ff       	call   801041f8 <outb>
8010434c:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
8010434f:	0f b7 05 00 e0 10 80 	movzwl 0x8010e000,%eax
80104356:	66 83 f8 ff          	cmp    $0xffff,%ax
8010435a:	74 13                	je     8010436f <picinit+0xe6>
    picsetmask(irqmask);
8010435c:	0f b7 05 00 e0 10 80 	movzwl 0x8010e000,%eax
80104363:	0f b7 c0             	movzwl %ax,%eax
80104366:	50                   	push   %eax
80104367:	e8 ab fe ff ff       	call   80104217 <picsetmask>
8010436c:	83 c4 04             	add    $0x4,%esp
}
8010436f:	90                   	nop
80104370:	c9                   	leave  
80104371:	c3                   	ret    

80104372 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104372:	55                   	push   %ebp
80104373:	89 e5                	mov    %esp,%ebp
80104375:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80104378:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
8010437f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104382:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104388:	8b 45 0c             	mov    0xc(%ebp),%eax
8010438b:	8b 10                	mov    (%eax),%edx
8010438d:	8b 45 08             	mov    0x8(%ebp),%eax
80104390:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104392:	e8 4c cd ff ff       	call   801010e3 <filealloc>
80104397:	89 c2                	mov    %eax,%edx
80104399:	8b 45 08             	mov    0x8(%ebp),%eax
8010439c:	89 10                	mov    %edx,(%eax)
8010439e:	8b 45 08             	mov    0x8(%ebp),%eax
801043a1:	8b 00                	mov    (%eax),%eax
801043a3:	85 c0                	test   %eax,%eax
801043a5:	0f 84 cb 00 00 00    	je     80104476 <pipealloc+0x104>
801043ab:	e8 33 cd ff ff       	call   801010e3 <filealloc>
801043b0:	89 c2                	mov    %eax,%edx
801043b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801043b5:	89 10                	mov    %edx,(%eax)
801043b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ba:	8b 00                	mov    (%eax),%eax
801043bc:	85 c0                	test   %eax,%eax
801043be:	0f 84 b2 00 00 00    	je     80104476 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801043c4:	e8 ce eb ff ff       	call   80102f97 <kalloc>
801043c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043d0:	0f 84 9f 00 00 00    	je     80104475 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
801043d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043d9:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801043e0:	00 00 00 
  p->writeopen = 1;
801043e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e6:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801043ed:	00 00 00 
  p->nwrite = 0;
801043f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801043fa:	00 00 00 
  p->nread = 0;
801043fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104400:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104407:	00 00 00 
  initlock(&p->lock, "pipe");
8010440a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010440d:	83 ec 08             	sub    $0x8,%esp
80104410:	68 64 a6 10 80       	push   $0x8010a664
80104415:	50                   	push   %eax
80104416:	e8 90 26 00 00       	call   80106aab <initlock>
8010441b:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010441e:	8b 45 08             	mov    0x8(%ebp),%eax
80104421:	8b 00                	mov    (%eax),%eax
80104423:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104429:	8b 45 08             	mov    0x8(%ebp),%eax
8010442c:	8b 00                	mov    (%eax),%eax
8010442e:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104432:	8b 45 08             	mov    0x8(%ebp),%eax
80104435:	8b 00                	mov    (%eax),%eax
80104437:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010443b:	8b 45 08             	mov    0x8(%ebp),%eax
8010443e:	8b 00                	mov    (%eax),%eax
80104440:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104443:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104446:	8b 45 0c             	mov    0xc(%ebp),%eax
80104449:	8b 00                	mov    (%eax),%eax
8010444b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104451:	8b 45 0c             	mov    0xc(%ebp),%eax
80104454:	8b 00                	mov    (%eax),%eax
80104456:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010445a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010445d:	8b 00                	mov    (%eax),%eax
8010445f:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104463:	8b 45 0c             	mov    0xc(%ebp),%eax
80104466:	8b 00                	mov    (%eax),%eax
80104468:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010446b:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010446e:	b8 00 00 00 00       	mov    $0x0,%eax
80104473:	eb 4e                	jmp    801044c3 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104475:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80104476:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010447a:	74 0e                	je     8010448a <pipealloc+0x118>
    kfree((char*)p);
8010447c:	83 ec 0c             	sub    $0xc,%esp
8010447f:	ff 75 f4             	pushl  -0xc(%ebp)
80104482:	e8 73 ea ff ff       	call   80102efa <kfree>
80104487:	83 c4 10             	add    $0x10,%esp
  if(*f0)
8010448a:	8b 45 08             	mov    0x8(%ebp),%eax
8010448d:	8b 00                	mov    (%eax),%eax
8010448f:	85 c0                	test   %eax,%eax
80104491:	74 11                	je     801044a4 <pipealloc+0x132>
    fileclose(*f0);
80104493:	8b 45 08             	mov    0x8(%ebp),%eax
80104496:	8b 00                	mov    (%eax),%eax
80104498:	83 ec 0c             	sub    $0xc,%esp
8010449b:	50                   	push   %eax
8010449c:	e8 00 cd ff ff       	call   801011a1 <fileclose>
801044a1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801044a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801044a7:	8b 00                	mov    (%eax),%eax
801044a9:	85 c0                	test   %eax,%eax
801044ab:	74 11                	je     801044be <pipealloc+0x14c>
    fileclose(*f1);
801044ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801044b0:	8b 00                	mov    (%eax),%eax
801044b2:	83 ec 0c             	sub    $0xc,%esp
801044b5:	50                   	push   %eax
801044b6:	e8 e6 cc ff ff       	call   801011a1 <fileclose>
801044bb:	83 c4 10             	add    $0x10,%esp
  return -1;
801044be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044c3:	c9                   	leave  
801044c4:	c3                   	ret    

801044c5 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801044c5:	55                   	push   %ebp
801044c6:	89 e5                	mov    %esp,%ebp
801044c8:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801044cb:	8b 45 08             	mov    0x8(%ebp),%eax
801044ce:	83 ec 0c             	sub    $0xc,%esp
801044d1:	50                   	push   %eax
801044d2:	e8 f6 25 00 00       	call   80106acd <acquire>
801044d7:	83 c4 10             	add    $0x10,%esp
  if(writable){
801044da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801044de:	74 23                	je     80104503 <pipeclose+0x3e>
    p->writeopen = 0;
801044e0:	8b 45 08             	mov    0x8(%ebp),%eax
801044e3:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801044ea:	00 00 00 
    wakeup(&p->nread);
801044ed:	8b 45 08             	mov    0x8(%ebp),%eax
801044f0:	05 34 02 00 00       	add    $0x234,%eax
801044f5:	83 ec 0c             	sub    $0xc,%esp
801044f8:	50                   	push   %eax
801044f9:	e8 75 15 00 00       	call   80105a73 <wakeup>
801044fe:	83 c4 10             	add    $0x10,%esp
80104501:	eb 21                	jmp    80104524 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104503:	8b 45 08             	mov    0x8(%ebp),%eax
80104506:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010450d:	00 00 00 
    wakeup(&p->nwrite);
80104510:	8b 45 08             	mov    0x8(%ebp),%eax
80104513:	05 38 02 00 00       	add    $0x238,%eax
80104518:	83 ec 0c             	sub    $0xc,%esp
8010451b:	50                   	push   %eax
8010451c:	e8 52 15 00 00       	call   80105a73 <wakeup>
80104521:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104524:	8b 45 08             	mov    0x8(%ebp),%eax
80104527:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010452d:	85 c0                	test   %eax,%eax
8010452f:	75 2c                	jne    8010455d <pipeclose+0x98>
80104531:	8b 45 08             	mov    0x8(%ebp),%eax
80104534:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010453a:	85 c0                	test   %eax,%eax
8010453c:	75 1f                	jne    8010455d <pipeclose+0x98>
    release(&p->lock);
8010453e:	8b 45 08             	mov    0x8(%ebp),%eax
80104541:	83 ec 0c             	sub    $0xc,%esp
80104544:	50                   	push   %eax
80104545:	e8 ea 25 00 00       	call   80106b34 <release>
8010454a:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
8010454d:	83 ec 0c             	sub    $0xc,%esp
80104550:	ff 75 08             	pushl  0x8(%ebp)
80104553:	e8 a2 e9 ff ff       	call   80102efa <kfree>
80104558:	83 c4 10             	add    $0x10,%esp
8010455b:	eb 0f                	jmp    8010456c <pipeclose+0xa7>
  } else
    release(&p->lock);
8010455d:	8b 45 08             	mov    0x8(%ebp),%eax
80104560:	83 ec 0c             	sub    $0xc,%esp
80104563:	50                   	push   %eax
80104564:	e8 cb 25 00 00       	call   80106b34 <release>
80104569:	83 c4 10             	add    $0x10,%esp
}
8010456c:	90                   	nop
8010456d:	c9                   	leave  
8010456e:	c3                   	ret    

8010456f <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010456f:	55                   	push   %ebp
80104570:	89 e5                	mov    %esp,%ebp
80104572:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104575:	8b 45 08             	mov    0x8(%ebp),%eax
80104578:	83 ec 0c             	sub    $0xc,%esp
8010457b:	50                   	push   %eax
8010457c:	e8 4c 25 00 00       	call   80106acd <acquire>
80104581:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010458b:	e9 ad 00 00 00       	jmp    8010463d <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104590:	8b 45 08             	mov    0x8(%ebp),%eax
80104593:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104599:	85 c0                	test   %eax,%eax
8010459b:	74 0d                	je     801045aa <pipewrite+0x3b>
8010459d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045a3:	8b 40 24             	mov    0x24(%eax),%eax
801045a6:	85 c0                	test   %eax,%eax
801045a8:	74 19                	je     801045c3 <pipewrite+0x54>
        release(&p->lock);
801045aa:	8b 45 08             	mov    0x8(%ebp),%eax
801045ad:	83 ec 0c             	sub    $0xc,%esp
801045b0:	50                   	push   %eax
801045b1:	e8 7e 25 00 00       	call   80106b34 <release>
801045b6:	83 c4 10             	add    $0x10,%esp
        return -1;
801045b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045be:	e9 a8 00 00 00       	jmp    8010466b <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801045c3:	8b 45 08             	mov    0x8(%ebp),%eax
801045c6:	05 34 02 00 00       	add    $0x234,%eax
801045cb:	83 ec 0c             	sub    $0xc,%esp
801045ce:	50                   	push   %eax
801045cf:	e8 9f 14 00 00       	call   80105a73 <wakeup>
801045d4:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801045d7:	8b 45 08             	mov    0x8(%ebp),%eax
801045da:	8b 55 08             	mov    0x8(%ebp),%edx
801045dd:	81 c2 38 02 00 00    	add    $0x238,%edx
801045e3:	83 ec 08             	sub    $0x8,%esp
801045e6:	50                   	push   %eax
801045e7:	52                   	push   %edx
801045e8:	e8 2b 12 00 00       	call   80105818 <sleep>
801045ed:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801045f0:	8b 45 08             	mov    0x8(%ebp),%eax
801045f3:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801045f9:	8b 45 08             	mov    0x8(%ebp),%eax
801045fc:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104602:	05 00 02 00 00       	add    $0x200,%eax
80104607:	39 c2                	cmp    %eax,%edx
80104609:	74 85                	je     80104590 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010460b:	8b 45 08             	mov    0x8(%ebp),%eax
8010460e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104614:	8d 48 01             	lea    0x1(%eax),%ecx
80104617:	8b 55 08             	mov    0x8(%ebp),%edx
8010461a:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104620:	25 ff 01 00 00       	and    $0x1ff,%eax
80104625:	89 c1                	mov    %eax,%ecx
80104627:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010462a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010462d:	01 d0                	add    %edx,%eax
8010462f:	0f b6 10             	movzbl (%eax),%edx
80104632:	8b 45 08             	mov    0x8(%ebp),%eax
80104635:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104639:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010463d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104640:	3b 45 10             	cmp    0x10(%ebp),%eax
80104643:	7c ab                	jl     801045f0 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104645:	8b 45 08             	mov    0x8(%ebp),%eax
80104648:	05 34 02 00 00       	add    $0x234,%eax
8010464d:	83 ec 0c             	sub    $0xc,%esp
80104650:	50                   	push   %eax
80104651:	e8 1d 14 00 00       	call   80105a73 <wakeup>
80104656:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104659:	8b 45 08             	mov    0x8(%ebp),%eax
8010465c:	83 ec 0c             	sub    $0xc,%esp
8010465f:	50                   	push   %eax
80104660:	e8 cf 24 00 00       	call   80106b34 <release>
80104665:	83 c4 10             	add    $0x10,%esp
  return n;
80104668:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010466b:	c9                   	leave  
8010466c:	c3                   	ret    

8010466d <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010466d:	55                   	push   %ebp
8010466e:	89 e5                	mov    %esp,%ebp
80104670:	53                   	push   %ebx
80104671:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104674:	8b 45 08             	mov    0x8(%ebp),%eax
80104677:	83 ec 0c             	sub    $0xc,%esp
8010467a:	50                   	push   %eax
8010467b:	e8 4d 24 00 00       	call   80106acd <acquire>
80104680:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104683:	eb 3f                	jmp    801046c4 <piperead+0x57>
    if(proc->killed){
80104685:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010468b:	8b 40 24             	mov    0x24(%eax),%eax
8010468e:	85 c0                	test   %eax,%eax
80104690:	74 19                	je     801046ab <piperead+0x3e>
      release(&p->lock);
80104692:	8b 45 08             	mov    0x8(%ebp),%eax
80104695:	83 ec 0c             	sub    $0xc,%esp
80104698:	50                   	push   %eax
80104699:	e8 96 24 00 00       	call   80106b34 <release>
8010469e:	83 c4 10             	add    $0x10,%esp
      return -1;
801046a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046a6:	e9 bf 00 00 00       	jmp    8010476a <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801046ab:	8b 45 08             	mov    0x8(%ebp),%eax
801046ae:	8b 55 08             	mov    0x8(%ebp),%edx
801046b1:	81 c2 34 02 00 00    	add    $0x234,%edx
801046b7:	83 ec 08             	sub    $0x8,%esp
801046ba:	50                   	push   %eax
801046bb:	52                   	push   %edx
801046bc:	e8 57 11 00 00       	call   80105818 <sleep>
801046c1:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801046c4:	8b 45 08             	mov    0x8(%ebp),%eax
801046c7:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801046cd:	8b 45 08             	mov    0x8(%ebp),%eax
801046d0:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801046d6:	39 c2                	cmp    %eax,%edx
801046d8:	75 0d                	jne    801046e7 <piperead+0x7a>
801046da:	8b 45 08             	mov    0x8(%ebp),%eax
801046dd:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801046e3:	85 c0                	test   %eax,%eax
801046e5:	75 9e                	jne    80104685 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801046e7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801046ee:	eb 49                	jmp    80104739 <piperead+0xcc>
    if(p->nread == p->nwrite)
801046f0:	8b 45 08             	mov    0x8(%ebp),%eax
801046f3:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801046f9:	8b 45 08             	mov    0x8(%ebp),%eax
801046fc:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104702:	39 c2                	cmp    %eax,%edx
80104704:	74 3d                	je     80104743 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104706:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104709:	8b 45 0c             	mov    0xc(%ebp),%eax
8010470c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010470f:	8b 45 08             	mov    0x8(%ebp),%eax
80104712:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104718:	8d 48 01             	lea    0x1(%eax),%ecx
8010471b:	8b 55 08             	mov    0x8(%ebp),%edx
8010471e:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104724:	25 ff 01 00 00       	and    $0x1ff,%eax
80104729:	89 c2                	mov    %eax,%edx
8010472b:	8b 45 08             	mov    0x8(%ebp),%eax
8010472e:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104733:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104735:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104739:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010473f:	7c af                	jl     801046f0 <piperead+0x83>
80104741:	eb 01                	jmp    80104744 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
80104743:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104744:	8b 45 08             	mov    0x8(%ebp),%eax
80104747:	05 38 02 00 00       	add    $0x238,%eax
8010474c:	83 ec 0c             	sub    $0xc,%esp
8010474f:	50                   	push   %eax
80104750:	e8 1e 13 00 00       	call   80105a73 <wakeup>
80104755:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104758:	8b 45 08             	mov    0x8(%ebp),%eax
8010475b:	83 ec 0c             	sub    $0xc,%esp
8010475e:	50                   	push   %eax
8010475f:	e8 d0 23 00 00       	call   80106b34 <release>
80104764:	83 c4 10             	add    $0x10,%esp
  return i;
80104767:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010476a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010476d:	c9                   	leave  
8010476e:	c3                   	ret    

8010476f <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
8010476f:	55                   	push   %ebp
80104770:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
80104772:	f4                   	hlt    
}
80104773:	90                   	nop
80104774:	5d                   	pop    %ebp
80104775:	c3                   	ret    

80104776 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104776:	55                   	push   %ebp
80104777:	89 e5                	mov    %esp,%ebp
80104779:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010477c:	9c                   	pushf  
8010477d:	58                   	pop    %eax
8010477e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104781:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104784:	c9                   	leave  
80104785:	c3                   	ret    

80104786 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104786:	55                   	push   %ebp
80104787:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104789:	fb                   	sti    
}
8010478a:	90                   	nop
8010478b:	5d                   	pop    %ebp
8010478c:	c3                   	ret    

8010478d <pinit>:
    [ZOMBIE]    "zombie"
};

void
pinit(void)
{
8010478d:	55                   	push   %ebp
8010478e:	89 e5                	mov    %esp,%ebp
80104790:	83 ec 08             	sub    $0x8,%esp
    initlock(&ptable.lock, "ptable");
80104793:	83 ec 08             	sub    $0x8,%esp
80104796:	68 96 a6 10 80       	push   $0x8010a696
8010479b:	68 a0 59 11 80       	push   $0x801159a0
801047a0:	e8 06 23 00 00       	call   80106aab <initlock>
801047a5:	83 c4 10             	add    $0x10,%esp
}
801047a8:	90                   	nop
801047a9:	c9                   	leave  
801047aa:	c3                   	ret    

801047ab <allocproc>:
#else

// PROJECT 3 + 4 ALLOCPROC
static struct proc*
allocproc(void)
{
801047ab:	55                   	push   %ebp
801047ac:	89 e5                	mov    %esp,%ebp
801047ae:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    char *sp;

    acquire(&ptable.lock);
801047b1:	83 ec 0c             	sub    $0xc,%esp
801047b4:	68 a0 59 11 80       	push   $0x801159a0
801047b9:	e8 0f 23 00 00       	call   80106acd <acquire>
801047be:	83 c4 10             	add    $0x10,%esp
    p = ptable.pLists.free;
801047c1:	a1 e0 80 11 80       	mov    0x801180e0,%eax
801047c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p) {
801047c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047cd:	75 1a                	jne    801047e9 <allocproc+0x3e>
        goto found;
    }
    release(&ptable.lock);
801047cf:	83 ec 0c             	sub    $0xc,%esp
801047d2:	68 a0 59 11 80       	push   $0x801159a0
801047d7:	e8 58 23 00 00       	call   80106b34 <release>
801047dc:	83 c4 10             	add    $0x10,%esp
    return 0;
801047df:	b8 00 00 00 00       	mov    $0x0,%eax
801047e4:	e9 a4 01 00 00       	jmp    8010498d <allocproc+0x1e2>
    char *sp;

    acquire(&ptable.lock);
    p = ptable.pLists.free;
    if (p) {
        goto found;
801047e9:	90                   	nop
    release(&ptable.lock);
    return 0;

found:

    assertState(p, UNUSED);
801047ea:	83 ec 08             	sub    $0x8,%esp
801047ed:	6a 00                	push   $0x0
801047ef:	ff 75 f4             	pushl  -0xc(%ebp)
801047f2:	e8 d3 19 00 00       	call   801061ca <assertState>
801047f7:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.free, p) == -1) {
801047fa:	83 ec 08             	sub    $0x8,%esp
801047fd:	ff 75 f4             	pushl  -0xc(%ebp)
80104800:	68 e0 80 11 80       	push   $0x801180e0
80104805:	e8 e1 1a 00 00       	call   801062eb <removeFromStateList>
8010480a:	83 c4 10             	add    $0x10,%esp
8010480d:	83 f8 ff             	cmp    $0xffffffff,%eax
80104810:	75 10                	jne    80104822 <allocproc+0x77>
        cprintf("Failed to remove proc from UNUSED list (allocproc).\n");
80104812:	83 ec 0c             	sub    $0xc,%esp
80104815:	68 a0 a6 10 80       	push   $0x8010a6a0
8010481a:	e8 a7 bb ff ff       	call   801003c6 <cprintf>
8010481f:	83 c4 10             	add    $0x10,%esp
    }
    p->state = EMBRYO;
80104822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104825:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
    if (addToStateListHead(&ptable.pLists.embryo, p) == -1) {
8010482c:	83 ec 08             	sub    $0x8,%esp
8010482f:	ff 75 f4             	pushl  -0xc(%ebp)
80104832:	68 f0 80 11 80       	push   $0x801180f0
80104837:	e8 c2 19 00 00       	call   801061fe <addToStateListHead>
8010483c:	83 c4 10             	add    $0x10,%esp
8010483f:	83 f8 ff             	cmp    $0xffffffff,%eax
80104842:	75 10                	jne    80104854 <allocproc+0xa9>
        cprintf("Failed to add proc to EMBRYO list (allocproc).\n");
80104844:	83 ec 0c             	sub    $0xc,%esp
80104847:	68 d8 a6 10 80       	push   $0x8010a6d8
8010484c:	e8 75 bb ff ff       	call   801003c6 <cprintf>
80104851:	83 c4 10             	add    $0x10,%esp
    }

    p->pid = nextpid++;
80104854:	a1 04 e0 10 80       	mov    0x8010e004,%eax
80104859:	8d 50 01             	lea    0x1(%eax),%edx
8010485c:	89 15 04 e0 10 80    	mov    %edx,0x8010e004
80104862:	89 c2                	mov    %eax,%edx
80104864:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104867:	89 50 10             	mov    %edx,0x10(%eax)
    release(&ptable.lock);
8010486a:	83 ec 0c             	sub    $0xc,%esp
8010486d:	68 a0 59 11 80       	push   $0x801159a0
80104872:	e8 bd 22 00 00       	call   80106b34 <release>
80104877:	83 c4 10             	add    $0x10,%esp

    // Allocate kernel stack.
    if((p->kstack = kalloc()) == 0){
8010487a:	e8 18 e7 ff ff       	call   80102f97 <kalloc>
8010487f:	89 c2                	mov    %eax,%edx
80104881:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104884:	89 50 08             	mov    %edx,0x8(%eax)
80104887:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010488a:	8b 40 08             	mov    0x8(%eax),%eax
8010488d:	85 c0                	test   %eax,%eax
8010488f:	75 5f                	jne    801048f0 <allocproc+0x145>
        assertState(p, EMBRYO);
80104891:	83 ec 08             	sub    $0x8,%esp
80104894:	6a 01                	push   $0x1
80104896:	ff 75 f4             	pushl  -0xc(%ebp)
80104899:	e8 2c 19 00 00       	call   801061ca <assertState>
8010489e:	83 c4 10             	add    $0x10,%esp
        removeFromStateList(&ptable.pLists.embryo, p);
801048a1:	83 ec 08             	sub    $0x8,%esp
801048a4:	ff 75 f4             	pushl  -0xc(%ebp)
801048a7:	68 f0 80 11 80       	push   $0x801180f0
801048ac:	e8 3a 1a 00 00       	call   801062eb <removeFromStateList>
801048b1:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
801048b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        if (addToStateListHead(&ptable.pLists.free, p) == -1) {
801048be:	83 ec 08             	sub    $0x8,%esp
801048c1:	ff 75 f4             	pushl  -0xc(%ebp)
801048c4:	68 e0 80 11 80       	push   $0x801180e0
801048c9:	e8 30 19 00 00       	call   801061fe <addToStateListHead>
801048ce:	83 c4 10             	add    $0x10,%esp
801048d1:	83 f8 ff             	cmp    $0xffffffff,%eax
801048d4:	75 10                	jne    801048e6 <allocproc+0x13b>
            cprintf("Not enough room for process stack; Failed to add proc to UNUSED list (allocproc).\n");
801048d6:	83 ec 0c             	sub    $0xc,%esp
801048d9:	68 08 a7 10 80       	push   $0x8010a708
801048de:	e8 e3 ba ff ff       	call   801003c6 <cprintf>
801048e3:	83 c4 10             	add    $0x10,%esp
        }
        return 0;
801048e6:	b8 00 00 00 00       	mov    $0x0,%eax
801048eb:	e9 9d 00 00 00       	jmp    8010498d <allocproc+0x1e2>
    }
    sp = p->kstack + KSTACKSIZE;
801048f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f3:	8b 40 08             	mov    0x8(%eax),%eax
801048f6:	05 00 10 00 00       	add    $0x1000,%eax
801048fb:	89 45 f0             	mov    %eax,-0x10(%ebp)

    // Leave room for trap frame.
    sp -= sizeof *p->tf;
801048fe:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
    p->tf = (struct trapframe*)sp;
80104902:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104905:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104908:	89 50 18             	mov    %edx,0x18(%eax)

    // Set up new context to start executing at forkret,
    // which returns to trapret.
    sp -= 4;
8010490b:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
    *(uint*)sp = (uint)trapret;
8010490f:	ba 3b 84 10 80       	mov    $0x8010843b,%edx
80104914:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104917:	89 10                	mov    %edx,(%eax)

    sp -= sizeof *p->context;
80104919:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
    p->context = (struct context*)sp;
8010491d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104920:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104923:	89 50 1c             	mov    %edx,0x1c(%eax)
    memset(p->context, 0, sizeof *p->context);
80104926:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104929:	8b 40 1c             	mov    0x1c(%eax),%eax
8010492c:	83 ec 04             	sub    $0x4,%esp
8010492f:	6a 14                	push   $0x14
80104931:	6a 00                	push   $0x0
80104933:	50                   	push   %eax
80104934:	e8 f7 23 00 00       	call   80106d30 <memset>
80104939:	83 c4 10             	add    $0x10,%esp
    p->context->eip = (uint)forkret;
8010493c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010493f:	8b 40 1c             	mov    0x1c(%eax),%eax
80104942:	ba d2 57 10 80       	mov    $0x801057d2,%edx
80104947:	89 50 10             	mov    %edx,0x10(%eax)

    p->start_ticks = ticks;
8010494a:	8b 15 00 89 11 80    	mov    0x80118900,%edx
80104950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104953:	89 50 7c             	mov    %edx,0x7c(%eax)
    p->cpu_ticks_total = 0;
80104956:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104959:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104960:	00 00 00 
    p->cpu_ticks_in = 0;
80104963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104966:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010496d:	00 00 00 

    // Project 4
    p->budget = BUDGET;
80104970:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104973:	c7 80 98 00 00 00 78 	movl   $0x78,0x98(%eax)
8010497a:	00 00 00 
    p->priority = 0;
8010497d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104980:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104987:	00 00 00 

    return p;
8010498a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010498d:	c9                   	leave  
8010498e:	c3                   	ret    

8010498f <userinit>:
}
#else
// PROJECT 3 + 4 USERINIT
void
userinit(void)
{
8010498f:	55                   	push   %ebp
80104990:	89 e5                	mov    %esp,%ebp
80104992:	83 ec 18             	sub    $0x18,%esp
    ptable.promoteAtTime = TIME_TO_PROMOTE; // Project 4, initialize promotion timer
80104995:	c7 05 f4 80 11 80 0e 	movl   $0x10e,0x801180f4
8010499c:	01 00 00 
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    // Add to the END of the UNUSED list upon init, or else processes will be backwards (ctrl-p & ps)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010499f:	c7 45 f4 d4 59 11 80 	movl   $0x801159d4,-0xc(%ebp)
801049a6:	eb 3c                	jmp    801049e4 <userinit+0x55>
        assertState(p, UNUSED);
801049a8:	83 ec 08             	sub    $0x8,%esp
801049ab:	6a 00                	push   $0x0
801049ad:	ff 75 f4             	pushl  -0xc(%ebp)
801049b0:	e8 15 18 00 00       	call   801061ca <assertState>
801049b5:	83 c4 10             	add    $0x10,%esp
        if (addToStateListEnd(&ptable.pLists.free, p) == -1) {
801049b8:	83 ec 08             	sub    $0x8,%esp
801049bb:	ff 75 f4             	pushl  -0xc(%ebp)
801049be:	68 e0 80 11 80       	push   $0x801180e0
801049c3:	e8 a2 18 00 00       	call   8010626a <addToStateListEnd>
801049c8:	83 c4 10             	add    $0x10,%esp
801049cb:	83 f8 ff             	cmp    $0xffffffff,%eax
801049ce:	75 0d                	jne    801049dd <userinit+0x4e>
            panic("Failed to add proc to UNUSED list.\n");
801049d0:	83 ec 0c             	sub    $0xc,%esp
801049d3:	68 5c a7 10 80       	push   $0x8010a75c
801049d8:	e8 89 bb ff ff       	call   80100566 <panic>
    ptable.promoteAtTime = TIME_TO_PROMOTE; // Project 4, initialize promotion timer
    struct proc *p;
    extern char _binary_initcode_start[], _binary_initcode_size[];

    // Add to the END of the UNUSED list upon init, or else processes will be backwards (ctrl-p & ps)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801049dd:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
801049e4:	81 7d f4 d4 80 11 80 	cmpl   $0x801180d4,-0xc(%ebp)
801049eb:	72 bb                	jb     801049a8 <userinit+0x19>
        if (addToStateListEnd(&ptable.pLists.free, p) == -1) {
            panic("Failed to add proc to UNUSED list.\n");
        }
    }

    p = allocproc();
801049ed:	e8 b9 fd ff ff       	call   801047ab <allocproc>
801049f2:	89 45 f4             	mov    %eax,-0xc(%ebp)

    initproc = p;
801049f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f8:	a3 88 e6 10 80       	mov    %eax,0x8010e688
    if((p->pgdir = setupkvm()) == 0)
801049fd:	e8 fb 50 00 00       	call   80109afd <setupkvm>
80104a02:	89 c2                	mov    %eax,%edx
80104a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a07:	89 50 04             	mov    %edx,0x4(%eax)
80104a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0d:	8b 40 04             	mov    0x4(%eax),%eax
80104a10:	85 c0                	test   %eax,%eax
80104a12:	75 0d                	jne    80104a21 <userinit+0x92>
        panic("userinit: out of memory?");
80104a14:	83 ec 0c             	sub    $0xc,%esp
80104a17:	68 80 a7 10 80       	push   $0x8010a780
80104a1c:	e8 45 bb ff ff       	call   80100566 <panic>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104a21:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a29:	8b 40 04             	mov    0x4(%eax),%eax
80104a2c:	83 ec 04             	sub    $0x4,%esp
80104a2f:	52                   	push   %edx
80104a30:	68 20 e5 10 80       	push   $0x8010e520
80104a35:	50                   	push   %eax
80104a36:	e8 1c 53 00 00       	call   80109d57 <inituvm>
80104a3b:	83 c4 10             	add    $0x10,%esp
    p->sz = PGSIZE;
80104a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a41:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
    memset(p->tf, 0, sizeof(*p->tf));
80104a47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4a:	8b 40 18             	mov    0x18(%eax),%eax
80104a4d:	83 ec 04             	sub    $0x4,%esp
80104a50:	6a 4c                	push   $0x4c
80104a52:	6a 00                	push   $0x0
80104a54:	50                   	push   %eax
80104a55:	e8 d6 22 00 00       	call   80106d30 <memset>
80104a5a:	83 c4 10             	add    $0x10,%esp
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a60:	8b 40 18             	mov    0x18(%eax),%eax
80104a63:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a6c:	8b 40 18             	mov    0x18(%eax),%eax
80104a6f:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
    p->tf->es = p->tf->ds;
80104a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a78:	8b 40 18             	mov    0x18(%eax),%eax
80104a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a7e:	8b 52 18             	mov    0x18(%edx),%edx
80104a81:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104a85:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
80104a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a8c:	8b 40 18             	mov    0x18(%eax),%eax
80104a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a92:	8b 52 18             	mov    0x18(%edx),%edx
80104a95:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104a99:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
80104a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa0:	8b 40 18             	mov    0x18(%eax),%eax
80104aa3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80104aaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aad:	8b 40 18             	mov    0x18(%eax),%eax
80104ab0:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0;  // beginning of initcode.S
80104ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aba:	8b 40 18             	mov    0x18(%eax),%eax
80104abd:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

#ifdef CS333_P2
    p->uid = UID;
80104ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac7:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104ace:	00 00 00 
    p->gid = GID;
80104ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad4:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104adb:	00 00 00 
    p->parent = p; // parent of proc one is itself
80104ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ae4:	89 50 14             	mov    %edx,0x14(%eax)
#endif

    safestrcpy(p->name, "initcode", sizeof(p->name));
80104ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aea:	83 c0 6c             	add    $0x6c,%eax
80104aed:	83 ec 04             	sub    $0x4,%esp
80104af0:	6a 10                	push   $0x10
80104af2:	68 99 a7 10 80       	push   $0x8010a799
80104af7:	50                   	push   %eax
80104af8:	e8 36 24 00 00       	call   80106f33 <safestrcpy>
80104afd:	83 c4 10             	add    $0x10,%esp
    p->cwd = namei("/");
80104b00:	83 ec 0c             	sub    $0xc,%esp
80104b03:	68 a2 a7 10 80       	push   $0x8010a7a2
80104b08:	e8 ff db ff ff       	call   8010270c <namei>
80104b0d:	83 c4 10             	add    $0x10,%esp
80104b10:	89 c2                	mov    %eax,%edx
80104b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b15:	89 50 68             	mov    %edx,0x68(%eax)

    assertState(p, EMBRYO);
80104b18:	83 ec 08             	sub    $0x8,%esp
80104b1b:	6a 01                	push   $0x1
80104b1d:	ff 75 f4             	pushl  -0xc(%ebp)
80104b20:	e8 a5 16 00 00       	call   801061ca <assertState>
80104b25:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.embryo, p) < 0) {
80104b28:	83 ec 08             	sub    $0x8,%esp
80104b2b:	ff 75 f4             	pushl  -0xc(%ebp)
80104b2e:	68 f0 80 11 80       	push   $0x801180f0
80104b33:	e8 b3 17 00 00       	call   801062eb <removeFromStateList>
80104b38:	83 c4 10             	add    $0x10,%esp
80104b3b:	85 c0                	test   %eax,%eax
80104b3d:	79 10                	jns    80104b4f <userinit+0x1c0>
        cprintf("Failed to remove EMBRYO proc from list (userinit).\n");
80104b3f:	83 ec 0c             	sub    $0xc,%esp
80104b42:	68 a4 a7 10 80       	push   $0x8010a7a4
80104b47:	e8 7a b8 ff ff       	call   801003c6 <cprintf>
80104b4c:	83 c4 10             	add    $0x10,%esp
    }

    p->state = RUNNABLE;
80104b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b52:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

    //ptable.pLists.ready = p;  // add to head of ready list

    ptable.pLists.ready[0] = p;  // add to head of highest priority ready list
80104b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b5c:	a3 d4 80 11 80       	mov    %eax,0x801180d4
    p->next = 0;
80104b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b64:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104b6b:	00 00 00 
    for (int i = 1; i <= MAX; ++i) {
80104b6e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
80104b75:	eb 17                	jmp    80104b8e <userinit+0x1ff>
        ptable.pLists.ready[i] = 0; // initialize all of the other ready lists
80104b77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b7a:	05 cc 09 00 00       	add    $0x9cc,%eax
80104b7f:	c7 04 85 a4 59 11 80 	movl   $0x0,-0x7feea65c(,%eax,4)
80104b86:	00 00 00 00 

    //ptable.pLists.ready = p;  // add to head of ready list

    ptable.pLists.ready[0] = p;  // add to head of highest priority ready list
    p->next = 0;
    for (int i = 1; i <= MAX; ++i) {
80104b8a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104b8e:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
80104b92:	7e e3                	jle    80104b77 <userinit+0x1e8>
        ptable.pLists.ready[i] = 0; // initialize all of the other ready lists
    }
    ptable.pLists.sleep = 0;  // initialize rest of the lists to NULL
80104b94:	c7 05 e4 80 11 80 00 	movl   $0x0,0x801180e4
80104b9b:	00 00 00 
    ptable.pLists.zombie = 0;
80104b9e:	c7 05 e8 80 11 80 00 	movl   $0x0,0x801180e8
80104ba5:	00 00 00 
    ptable.pLists.running = 0;
80104ba8:	c7 05 ec 80 11 80 00 	movl   $0x0,0x801180ec
80104baf:	00 00 00 
    ptable.pLists.embryo = 0;
80104bb2:	c7 05 f0 80 11 80 00 	movl   $0x0,0x801180f0
80104bb9:	00 00 00 
}
80104bbc:	90                   	nop
80104bbd:	c9                   	leave  
80104bbe:	c3                   	ret    

80104bbf <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104bbf:	55                   	push   %ebp
80104bc0:	89 e5                	mov    %esp,%ebp
80104bc2:	83 ec 18             	sub    $0x18,%esp
    uint sz;

    sz = proc->sz;
80104bc5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bcb:	8b 00                	mov    (%eax),%eax
80104bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(n > 0){
80104bd0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104bd4:	7e 31                	jle    80104c07 <growproc+0x48>
        if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104bd6:	8b 55 08             	mov    0x8(%ebp),%edx
80104bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bdc:	01 c2                	add    %eax,%edx
80104bde:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104be4:	8b 40 04             	mov    0x4(%eax),%eax
80104be7:	83 ec 04             	sub    $0x4,%esp
80104bea:	52                   	push   %edx
80104beb:	ff 75 f4             	pushl  -0xc(%ebp)
80104bee:	50                   	push   %eax
80104bef:	e8 b0 52 00 00       	call   80109ea4 <allocuvm>
80104bf4:	83 c4 10             	add    $0x10,%esp
80104bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104bfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104bfe:	75 3e                	jne    80104c3e <growproc+0x7f>
            return -1;
80104c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c05:	eb 59                	jmp    80104c60 <growproc+0xa1>
    } else if(n < 0){
80104c07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104c0b:	79 31                	jns    80104c3e <growproc+0x7f>
        if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104c0d:	8b 55 08             	mov    0x8(%ebp),%edx
80104c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c13:	01 c2                	add    %eax,%edx
80104c15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c1b:	8b 40 04             	mov    0x4(%eax),%eax
80104c1e:	83 ec 04             	sub    $0x4,%esp
80104c21:	52                   	push   %edx
80104c22:	ff 75 f4             	pushl  -0xc(%ebp)
80104c25:	50                   	push   %eax
80104c26:	e8 42 53 00 00       	call   80109f6d <deallocuvm>
80104c2b:	83 c4 10             	add    $0x10,%esp
80104c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104c31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104c35:	75 07                	jne    80104c3e <growproc+0x7f>
            return -1;
80104c37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c3c:	eb 22                	jmp    80104c60 <growproc+0xa1>
    }
    proc->sz = sz;
80104c3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c44:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c47:	89 10                	mov    %edx,(%eax)
    switchuvm(proc);
80104c49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c4f:	83 ec 0c             	sub    $0xc,%esp
80104c52:	50                   	push   %eax
80104c53:	e8 8c 4f 00 00       	call   80109be4 <switchuvm>
80104c58:	83 c4 10             	add    $0x10,%esp
    return 0;
80104c5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c60:	c9                   	leave  
80104c61:	c3                   	ret    

80104c62 <fork>:
}
#else
// PROJECT 3 + 4 FORK
int
fork(void)
{
80104c62:	55                   	push   %ebp
80104c63:	89 e5                	mov    %esp,%ebp
80104c65:	57                   	push   %edi
80104c66:	56                   	push   %esi
80104c67:	53                   	push   %ebx
80104c68:	83 ec 1c             	sub    $0x1c,%esp
    int i, pid;
    struct proc *np;

    // Allocate process.
    if((np = allocproc()) == 0)
80104c6b:	e8 3b fb ff ff       	call   801047ab <allocproc>
80104c70:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104c73:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104c77:	75 0a                	jne    80104c83 <fork+0x21>
        return -1;
80104c79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c7e:	e9 61 02 00 00       	jmp    80104ee4 <fork+0x282>

    // Copy process state from p.
    if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104c83:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c89:	8b 10                	mov    (%eax),%edx
80104c8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c91:	8b 40 04             	mov    0x4(%eax),%eax
80104c94:	83 ec 08             	sub    $0x8,%esp
80104c97:	52                   	push   %edx
80104c98:	50                   	push   %eax
80104c99:	e8 6d 54 00 00       	call   8010a10b <copyuvm>
80104c9e:	83 c4 10             	add    $0x10,%esp
80104ca1:	89 c2                	mov    %eax,%edx
80104ca3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ca6:	89 50 04             	mov    %edx,0x4(%eax)
80104ca9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cac:	8b 40 04             	mov    0x4(%eax),%eax
80104caf:	85 c0                	test   %eax,%eax
80104cb1:	0f 85 88 00 00 00    	jne    80104d3f <fork+0xdd>
        kfree(np->kstack);
80104cb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cba:	8b 40 08             	mov    0x8(%eax),%eax
80104cbd:	83 ec 0c             	sub    $0xc,%esp
80104cc0:	50                   	push   %eax
80104cc1:	e8 34 e2 ff ff       	call   80102efa <kfree>
80104cc6:	83 c4 10             	add    $0x10,%esp
        np->kstack = 0;
80104cc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ccc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        assertState(np, EMBRYO);
80104cd3:	83 ec 08             	sub    $0x8,%esp
80104cd6:	6a 01                	push   $0x1
80104cd8:	ff 75 e0             	pushl  -0x20(%ebp)
80104cdb:	e8 ea 14 00 00       	call   801061ca <assertState>
80104ce0:	83 c4 10             	add    $0x10,%esp
        if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
80104ce3:	83 ec 08             	sub    $0x8,%esp
80104ce6:	ff 75 e0             	pushl  -0x20(%ebp)
80104ce9:	68 f0 80 11 80       	push   $0x801180f0
80104cee:	e8 f8 15 00 00       	call   801062eb <removeFromStateList>
80104cf3:	83 c4 10             	add    $0x10,%esp
80104cf6:	85 c0                	test   %eax,%eax
80104cf8:	79 0d                	jns    80104d07 <fork+0xa5>
            panic("Failed to remove proc from EMBRYO list (fork).\n");
80104cfa:	83 ec 0c             	sub    $0xc,%esp
80104cfd:	68 d8 a7 10 80       	push   $0x8010a7d8
80104d02:	e8 5f b8 ff ff       	call   80100566 <panic>
        }
        np->state = UNUSED;
80104d07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d0a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        if (addToStateListHead(&ptable.pLists.free, np) < 0) {
80104d11:	83 ec 08             	sub    $0x8,%esp
80104d14:	ff 75 e0             	pushl  -0x20(%ebp)
80104d17:	68 e0 80 11 80       	push   $0x801180e0
80104d1c:	e8 dd 14 00 00       	call   801061fe <addToStateListHead>
80104d21:	83 c4 10             	add    $0x10,%esp
80104d24:	85 c0                	test   %eax,%eax
80104d26:	79 0d                	jns    80104d35 <fork+0xd3>
            panic("Failed to add proc to UNUSED list (fork).\n");
80104d28:	83 ec 0c             	sub    $0xc,%esp
80104d2b:	68 08 a8 10 80       	push   $0x8010a808
80104d30:	e8 31 b8 ff ff       	call   80100566 <panic>
        }
        return -1;
80104d35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d3a:	e9 a5 01 00 00       	jmp    80104ee4 <fork+0x282>
    }
    np->sz = proc->sz;
80104d3f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d45:	8b 10                	mov    (%eax),%edx
80104d47:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d4a:	89 10                	mov    %edx,(%eax)
    np->parent = proc;
80104d4c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d53:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d56:	89 50 14             	mov    %edx,0x14(%eax)
    *np->tf = *proc->tf;
80104d59:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d5c:	8b 50 18             	mov    0x18(%eax),%edx
80104d5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d65:	8b 40 18             	mov    0x18(%eax),%eax
80104d68:	89 c3                	mov    %eax,%ebx
80104d6a:	b8 13 00 00 00       	mov    $0x13,%eax
80104d6f:	89 d7                	mov    %edx,%edi
80104d71:	89 de                	mov    %ebx,%esi
80104d73:	89 c1                	mov    %eax,%ecx
80104d75:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;
80104d77:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d7a:	8b 40 18             	mov    0x18(%eax),%eax
80104d7d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

    for(i = 0; i < NOFILE; i++)
80104d84:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104d8b:	eb 43                	jmp    80104dd0 <fork+0x16e>
        if(proc->ofile[i])
80104d8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d93:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104d96:	83 c2 08             	add    $0x8,%edx
80104d99:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104d9d:	85 c0                	test   %eax,%eax
80104d9f:	74 2b                	je     80104dcc <fork+0x16a>
            np->ofile[i] = filedup(proc->ofile[i]);
80104da1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104da7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104daa:	83 c2 08             	add    $0x8,%edx
80104dad:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104db1:	83 ec 0c             	sub    $0xc,%esp
80104db4:	50                   	push   %eax
80104db5:	e8 96 c3 ff ff       	call   80101150 <filedup>
80104dba:	83 c4 10             	add    $0x10,%esp
80104dbd:	89 c1                	mov    %eax,%ecx
80104dbf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104dc2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104dc5:	83 c2 08             	add    $0x8,%edx
80104dc8:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
    *np->tf = *proc->tf;

    // Clear %eax so that fork returns 0 in the child.
    np->tf->eax = 0;

    for(i = 0; i < NOFILE; i++)
80104dcc:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104dd0:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104dd4:	7e b7                	jle    80104d8d <fork+0x12b>
        if(proc->ofile[i])
            np->ofile[i] = filedup(proc->ofile[i]);
    np->cwd = idup(proc->cwd);
80104dd6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ddc:	8b 40 68             	mov    0x68(%eax),%eax
80104ddf:	83 ec 0c             	sub    $0xc,%esp
80104de2:	50                   	push   %eax
80104de3:	e8 dc cc ff ff       	call   80101ac4 <idup>
80104de8:	83 c4 10             	add    $0x10,%esp
80104deb:	89 c2                	mov    %eax,%edx
80104ded:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104df0:	89 50 68             	mov    %edx,0x68(%eax)

    safestrcpy(np->name, proc->name, sizeof(proc->name));
80104df3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104df9:	8d 50 6c             	lea    0x6c(%eax),%edx
80104dfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104dff:	83 c0 6c             	add    $0x6c,%eax
80104e02:	83 ec 04             	sub    $0x4,%esp
80104e05:	6a 10                	push   $0x10
80104e07:	52                   	push   %edx
80104e08:	50                   	push   %eax
80104e09:	e8 25 21 00 00       	call   80106f33 <safestrcpy>
80104e0e:	83 c4 10             	add    $0x10,%esp

    np->uid = proc->uid;
80104e11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e17:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104e1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e20:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    np->gid = proc->gid;
80104e26:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e2c:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104e32:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e35:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

    pid = np->pid;
80104e3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e3e:	8b 40 10             	mov    0x10(%eax),%eax
80104e41:	89 45 dc             	mov    %eax,-0x24(%ebp)

    // lock to force the compiler to emit the np->state write last.
    acquire(&ptable.lock);
80104e44:	83 ec 0c             	sub    $0xc,%esp
80104e47:	68 a0 59 11 80       	push   $0x801159a0
80104e4c:	e8 7c 1c 00 00       	call   80106acd <acquire>
80104e51:	83 c4 10             	add    $0x10,%esp
    assertState(np, EMBRYO);
80104e54:	83 ec 08             	sub    $0x8,%esp
80104e57:	6a 01                	push   $0x1
80104e59:	ff 75 e0             	pushl  -0x20(%ebp)
80104e5c:	e8 69 13 00 00       	call   801061ca <assertState>
80104e61:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.embryo, np) < 0) {
80104e64:	83 ec 08             	sub    $0x8,%esp
80104e67:	ff 75 e0             	pushl  -0x20(%ebp)
80104e6a:	68 f0 80 11 80       	push   $0x801180f0
80104e6f:	e8 77 14 00 00       	call   801062eb <removeFromStateList>
80104e74:	83 c4 10             	add    $0x10,%esp
80104e77:	85 c0                	test   %eax,%eax
80104e79:	79 10                	jns    80104e8b <fork+0x229>
        cprintf("Failed to remove EMBRYO proc from list (fork).\n");
80104e7b:	83 ec 0c             	sub    $0xc,%esp
80104e7e:	68 34 a8 10 80       	push   $0x8010a834
80104e83:	e8 3e b5 ff ff       	call   801003c6 <cprintf>
80104e88:	83 c4 10             	add    $0x10,%esp
    }

    np->state = RUNNABLE;
80104e8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e8e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

    // add to end of highest priority queue
    if (addToStateListEnd(&ptable.pLists.ready[np->priority], np) < 0) {
80104e95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e98:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104e9e:	05 cc 09 00 00       	add    $0x9cc,%eax
80104ea3:	c1 e0 02             	shl    $0x2,%eax
80104ea6:	05 a0 59 11 80       	add    $0x801159a0,%eax
80104eab:	83 c0 04             	add    $0x4,%eax
80104eae:	83 ec 08             	sub    $0x8,%esp
80104eb1:	ff 75 e0             	pushl  -0x20(%ebp)
80104eb4:	50                   	push   %eax
80104eb5:	e8 b0 13 00 00       	call   8010626a <addToStateListEnd>
80104eba:	83 c4 10             	add    $0x10,%esp
80104ebd:	85 c0                	test   %eax,%eax
80104ebf:	79 10                	jns    80104ed1 <fork+0x26f>
        cprintf("Failed to add RUNNABLE proc to list (fork).\n");
80104ec1:	83 ec 0c             	sub    $0xc,%esp
80104ec4:	68 64 a8 10 80       	push   $0x8010a864
80104ec9:	e8 f8 b4 ff ff       	call   801003c6 <cprintf>
80104ece:	83 c4 10             	add    $0x10,%esp
    }
    release(&ptable.lock);
80104ed1:	83 ec 0c             	sub    $0xc,%esp
80104ed4:	68 a0 59 11 80       	push   $0x801159a0
80104ed9:	e8 56 1c 00 00       	call   80106b34 <release>
80104ede:	83 c4 10             	add    $0x10,%esp

    return pid;
80104ee1:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104ee4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ee7:	5b                   	pop    %ebx
80104ee8:	5e                   	pop    %esi
80104ee9:	5f                   	pop    %edi
80104eea:	5d                   	pop    %ebp
80104eeb:	c3                   	ret    

80104eec <exit>:
    panic("zombie exit");
}
#else
void
exit(void)
{
80104eec:	55                   	push   %ebp
80104eed:	89 e5                	mov    %esp,%ebp
80104eef:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    struct proc *current;
    int fd;

    if(proc == initproc)
80104ef2:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ef9:	a1 88 e6 10 80       	mov    0x8010e688,%eax
80104efe:	39 c2                	cmp    %eax,%edx
80104f00:	75 0d                	jne    80104f0f <exit+0x23>
        panic("init exiting");
80104f02:	83 ec 0c             	sub    $0xc,%esp
80104f05:	68 91 a8 10 80       	push   $0x8010a891
80104f0a:	e8 57 b6 ff ff       	call   80100566 <panic>

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104f0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104f16:	eb 48                	jmp    80104f60 <exit+0x74>
        if(proc->ofile[fd]){
80104f18:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f1e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104f21:	83 c2 08             	add    $0x8,%edx
80104f24:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104f28:	85 c0                	test   %eax,%eax
80104f2a:	74 30                	je     80104f5c <exit+0x70>
            fileclose(proc->ofile[fd]);
80104f2c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f32:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104f35:	83 c2 08             	add    $0x8,%edx
80104f38:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104f3c:	83 ec 0c             	sub    $0xc,%esp
80104f3f:	50                   	push   %eax
80104f40:	e8 5c c2 ff ff       	call   801011a1 <fileclose>
80104f45:	83 c4 10             	add    $0x10,%esp
            proc->ofile[fd] = 0;
80104f48:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f4e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104f51:	83 c2 08             	add    $0x8,%edx
80104f54:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104f5b:	00 

    if(proc == initproc)
        panic("init exiting");

    // Close all open files.
    for(fd = 0; fd < NOFILE; fd++){
80104f5c:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104f60:	83 7d ec 0f          	cmpl   $0xf,-0x14(%ebp)
80104f64:	7e b2                	jle    80104f18 <exit+0x2c>
            fileclose(proc->ofile[fd]);
            proc->ofile[fd] = 0;
        }
    }

    begin_op();
80104f66:	e8 13 e9 ff ff       	call   8010387e <begin_op>
    iput(proc->cwd);
80104f6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f71:	8b 40 68             	mov    0x68(%eax),%eax
80104f74:	83 ec 0c             	sub    $0xc,%esp
80104f77:	50                   	push   %eax
80104f78:	e8 79 cd ff ff       	call   80101cf6 <iput>
80104f7d:	83 c4 10             	add    $0x10,%esp
    end_op();
80104f80:	e8 85 e9 ff ff       	call   8010390a <end_op>
    proc->cwd = 0;
80104f85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f8b:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

    acquire(&ptable.lock);
80104f92:	83 ec 0c             	sub    $0xc,%esp
80104f95:	68 a0 59 11 80       	push   $0x801159a0
80104f9a:	e8 2e 1b 00 00       	call   80106acd <acquire>
80104f9f:	83 c4 10             	add    $0x10,%esp

    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
80104fa2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fa8:	8b 40 14             	mov    0x14(%eax),%eax
80104fab:	83 ec 0c             	sub    $0xc,%esp
80104fae:	50                   	push   %eax
80104faf:	e8 f1 09 00 00       	call   801059a5 <wakeup1>
80104fb4:	83 c4 10             	add    $0x10,%esp
    
    // Pass abandoned children to init.
    current = ptable.pLists.zombie;
80104fb7:	a1 e8 80 11 80       	mov    0x801180e8,%eax
80104fbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (current) {
80104fbf:	eb 3f                	jmp    80105000 <exit+0x114>
        p = current;
80104fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        current = current->next;
80104fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fca:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104fd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p->parent == proc) {
80104fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fd6:	8b 50 14             	mov    0x14(%eax),%edx
80104fd9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fdf:	39 c2                	cmp    %eax,%edx
80104fe1:	75 1d                	jne    80105000 <exit+0x114>
            p->parent = initproc;
80104fe3:	8b 15 88 e6 10 80    	mov    0x8010e688,%edx
80104fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fec:	89 50 14             	mov    %edx,0x14(%eax)
            wakeup1(initproc);
80104fef:	a1 88 e6 10 80       	mov    0x8010e688,%eax
80104ff4:	83 ec 0c             	sub    $0xc,%esp
80104ff7:	50                   	push   %eax
80104ff8:	e8 a8 09 00 00       	call   801059a5 <wakeup1>
80104ffd:	83 c4 10             	add    $0x10,%esp
    // Parent might be sleeping in wait().
    wakeup1(proc->parent);
    
    // Pass abandoned children to init.
    current = ptable.pLists.zombie;
    while (current) {
80105000:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105004:	75 bb                	jne    80104fc1 <exit+0xd5>
        if (p->parent == proc) {
            p->parent = initproc;
            wakeup1(initproc);
        }
    }
    p = ptable.pLists.running; // now running list
80105006:	a1 ec 80 11 80       	mov    0x801180ec,%eax
8010500b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
8010500e:	eb 28                	jmp    80105038 <exit+0x14c>
        if(p->parent == proc){
80105010:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105013:	8b 50 14             	mov    0x14(%eax),%edx
80105016:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010501c:	39 c2                	cmp    %eax,%edx
8010501e:	75 0c                	jne    8010502c <exit+0x140>
            p->parent = initproc;
80105020:	8b 15 88 e6 10 80    	mov    0x8010e688,%edx
80105026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105029:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
8010502c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010502f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105035:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->parent = initproc;
            wakeup1(initproc);
        }
    }
    p = ptable.pLists.running; // now running list
    while (p) {
80105038:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010503c:	75 d2                	jne    80105010 <exit+0x124>
            p->parent = initproc;
        }
        p = p->next;
    }
    // traverse array of ready lists
    for (int i = 0; i <= MAX; ++i) {
8010503e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
80105045:	eb 46                	jmp    8010508d <exit+0x1a1>
        p = ptable.pLists.ready[i]; // now ready
80105047:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010504a:	05 cc 09 00 00       	add    $0x9cc,%eax
8010504f:	8b 04 85 a4 59 11 80 	mov    -0x7feea65c(,%eax,4),%eax
80105056:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
80105059:	eb 28                	jmp    80105083 <exit+0x197>
            if (p->parent == proc) {
8010505b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010505e:	8b 50 14             	mov    0x14(%eax),%edx
80105061:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105067:	39 c2                	cmp    %eax,%edx
80105069:	75 0c                	jne    80105077 <exit+0x18b>
                p->parent = initproc;
8010506b:	8b 15 88 e6 10 80    	mov    0x8010e688,%edx
80105071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105074:	89 50 14             	mov    %edx,0x14(%eax)
            }
            p = p->next;
80105077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010507a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105080:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }
    // traverse array of ready lists
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i]; // now ready
        while (p) {
80105083:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105087:	75 d2                	jne    8010505b <exit+0x16f>
            p->parent = initproc;
        }
        p = p->next;
    }
    // traverse array of ready lists
    for (int i = 0; i <= MAX; ++i) {
80105089:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
8010508d:	83 7d e8 02          	cmpl   $0x2,-0x18(%ebp)
80105091:	7e b4                	jle    80105047 <exit+0x15b>
                p->parent = initproc;
            }
            p = p->next;
        }
    }
    p = ptable.pLists.sleep; // sleeping list
80105093:	a1 e4 80 11 80       	mov    0x801180e4,%eax
80105098:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
8010509b:	eb 28                	jmp    801050c5 <exit+0x1d9>
        if (p->parent == proc) {
8010509d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a0:	8b 50 14             	mov    0x14(%eax),%edx
801050a3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050a9:	39 c2                	cmp    %eax,%edx
801050ab:	75 0c                	jne    801050b9 <exit+0x1cd>
            p->parent = initproc;
801050ad:	8b 15 88 e6 10 80    	mov    0x8010e688,%edx
801050b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050b6:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
801050b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050bc:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801050c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
    }
    p = ptable.pLists.sleep; // sleeping list
    while (p) {
801050c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801050c9:	75 d2                	jne    8010509d <exit+0x1b1>
        if (p->parent == proc) {
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.embryo; // embryo list
801050cb:	a1 f0 80 11 80       	mov    0x801180f0,%eax
801050d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801050d3:	eb 28                	jmp    801050fd <exit+0x211>
        if (p->parent == proc) {
801050d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050d8:	8b 50 14             	mov    0x14(%eax),%edx
801050db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050e1:	39 c2                	cmp    %eax,%edx
801050e3:	75 0c                	jne    801050f1 <exit+0x205>
            p->parent = initproc;
801050e5:	8b 15 88 e6 10 80    	mov    0x8010e688,%edx
801050eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ee:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
801050f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801050fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.embryo; // embryo list
    while (p) {
801050fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105101:	75 d2                	jne    801050d5 <exit+0x1e9>
        if (p->parent == proc) {
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.free; // free list
80105103:	a1 e0 80 11 80       	mov    0x801180e0,%eax
80105108:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
8010510b:	eb 28                	jmp    80105135 <exit+0x249>
        if (p->parent == proc) {
8010510d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105110:	8b 50 14             	mov    0x14(%eax),%edx
80105113:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105119:	39 c2                	cmp    %eax,%edx
8010511b:	75 0c                	jne    80105129 <exit+0x23d>
            p->parent = initproc;
8010511d:	8b 15 88 e6 10 80    	mov    0x8010e688,%edx
80105123:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105126:	89 50 14             	mov    %edx,0x14(%eax)
        }
        p = p->next;
80105129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010512c:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105132:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p->parent = initproc;
        }
        p = p->next;
    }
    p = ptable.pLists.free; // free list
    while (p) {
80105135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105139:	75 d2                	jne    8010510d <exit+0x221>
            p->parent = initproc;
        }
        p = p->next;
    }

    assertState(proc, RUNNING);
8010513b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105141:	83 ec 08             	sub    $0x8,%esp
80105144:	6a 04                	push   $0x4
80105146:	50                   	push   %eax
80105147:	e8 7e 10 00 00       	call   801061ca <assertState>
8010514c:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
8010514f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105155:	83 ec 08             	sub    $0x8,%esp
80105158:	50                   	push   %eax
80105159:	68 ec 80 11 80       	push   $0x801180ec
8010515e:	e8 88 11 00 00       	call   801062eb <removeFromStateList>
80105163:	83 c4 10             	add    $0x10,%esp
80105166:	85 c0                	test   %eax,%eax
80105168:	79 10                	jns    8010517a <exit+0x28e>
        cprintf("Failed to remove RUNNING proc from list (exit).\n");
8010516a:	83 ec 0c             	sub    $0xc,%esp
8010516d:	68 a0 a8 10 80       	push   $0x8010a8a0
80105172:	e8 4f b2 ff ff       	call   801003c6 <cprintf>
80105177:	83 c4 10             	add    $0x10,%esp
    }
    // Jump into the scheduler, never to return.
    proc->state = ZOMBIE;
8010517a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105180:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
    if (addToStateListHead(&ptable.pLists.zombie, proc) < 0) {
80105187:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010518d:	83 ec 08             	sub    $0x8,%esp
80105190:	50                   	push   %eax
80105191:	68 e8 80 11 80       	push   $0x801180e8
80105196:	e8 63 10 00 00       	call   801061fe <addToStateListHead>
8010519b:	83 c4 10             	add    $0x10,%esp
8010519e:	85 c0                	test   %eax,%eax
801051a0:	79 10                	jns    801051b2 <exit+0x2c6>
        cprintf("Failed to add ZOMBIE proc to list (exit).\n");
801051a2:	83 ec 0c             	sub    $0xc,%esp
801051a5:	68 d4 a8 10 80       	push   $0x8010a8d4
801051aa:	e8 17 b2 ff ff       	call   801003c6 <cprintf>
801051af:	83 c4 10             	add    $0x10,%esp
    }

    sched();
801051b2:	e8 eb 03 00 00       	call   801055a2 <sched>
    panic("zombie exit");
801051b7:	83 ec 0c             	sub    $0xc,%esp
801051ba:	68 ff a8 10 80       	push   $0x8010a8ff
801051bf:	e8 a2 b3 ff ff       	call   80100566 <panic>

801051c4 <wait>:
    }
}
#else
int
wait(void)
{
801051c4:	55                   	push   %ebp
801051c5:	89 e5                	mov    %esp,%ebp
801051c7:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    int havekids, pid;

    acquire(&ptable.lock);
801051ca:	83 ec 0c             	sub    $0xc,%esp
801051cd:	68 a0 59 11 80       	push   $0x801159a0
801051d2:	e8 f6 18 00 00       	call   80106acd <acquire>
801051d7:	83 c4 10             	add    $0x10,%esp
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
801051da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        // start at zombie list
        p = ptable.pLists.zombie;
801051e1:	a1 e8 80 11 80       	mov    0x801180e8,%eax
801051e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
801051e9:	e9 03 01 00 00       	jmp    801052f1 <wait+0x12d>
            if (p->parent == proc) {
801051ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051f1:	8b 50 14             	mov    0x14(%eax),%edx
801051f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801051fa:	39 c2                	cmp    %eax,%edx
801051fc:	0f 85 e3 00 00 00    	jne    801052e5 <wait+0x121>
                havekids = 1;
80105202:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
                pid = p->pid;
80105209:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010520c:	8b 40 10             	mov    0x10(%eax),%eax
8010520f:	89 45 e8             	mov    %eax,-0x18(%ebp)
                kfree(p->kstack);
80105212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105215:	8b 40 08             	mov    0x8(%eax),%eax
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	50                   	push   %eax
8010521c:	e8 d9 dc ff ff       	call   80102efa <kfree>
80105221:	83 c4 10             	add    $0x10,%esp
                p->kstack = 0;
80105224:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105227:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
                freevm(p->pgdir);
8010522e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105231:	8b 40 04             	mov    0x4(%eax),%eax
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	50                   	push   %eax
80105238:	e8 ed 4d 00 00       	call   8010a02a <freevm>
8010523d:	83 c4 10             	add    $0x10,%esp
                assertState(p, ZOMBIE);
80105240:	83 ec 08             	sub    $0x8,%esp
80105243:	6a 05                	push   $0x5
80105245:	ff 75 f4             	pushl  -0xc(%ebp)
80105248:	e8 7d 0f 00 00       	call   801061ca <assertState>
8010524d:	83 c4 10             	add    $0x10,%esp
                if (removeFromStateList(&ptable.pLists.zombie, p) < 0) {
80105250:	83 ec 08             	sub    $0x8,%esp
80105253:	ff 75 f4             	pushl  -0xc(%ebp)
80105256:	68 e8 80 11 80       	push   $0x801180e8
8010525b:	e8 8b 10 00 00       	call   801062eb <removeFromStateList>
80105260:	83 c4 10             	add    $0x10,%esp
80105263:	85 c0                	test   %eax,%eax
80105265:	79 10                	jns    80105277 <wait+0xb3>
                    cprintf("Failed to remove ZOMBIE process from list (wait).\n");
80105267:	83 ec 0c             	sub    $0xc,%esp
8010526a:	68 0c a9 10 80       	push   $0x8010a90c
8010526f:	e8 52 b1 ff ff       	call   801003c6 <cprintf>
80105274:	83 c4 10             	add    $0x10,%esp
                }
                p->state = UNUSED;
80105277:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010527a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                if (addToStateListHead(&ptable.pLists.free, p) < 0) {
80105281:	83 ec 08             	sub    $0x8,%esp
80105284:	ff 75 f4             	pushl  -0xc(%ebp)
80105287:	68 e0 80 11 80       	push   $0x801180e0
8010528c:	e8 6d 0f 00 00       	call   801061fe <addToStateListHead>
80105291:	83 c4 10             	add    $0x10,%esp
80105294:	85 c0                	test   %eax,%eax
80105296:	79 10                	jns    801052a8 <wait+0xe4>
                    cprintf("Failed to add UNUSED process to list (wait).\n");
80105298:	83 ec 0c             	sub    $0xc,%esp
8010529b:	68 40 a9 10 80       	push   $0x8010a940
801052a0:	e8 21 b1 ff ff       	call   801003c6 <cprintf>
801052a5:	83 c4 10             	add    $0x10,%esp
                }
                p->pid = 0;
801052a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052ab:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
                p->parent = 0;
801052b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b5:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
                p->name[0] = 0;
801052bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052bf:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
                p->killed = 0;
801052c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c6:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
                release(&ptable.lock);
801052cd:	83 ec 0c             	sub    $0xc,%esp
801052d0:	68 a0 59 11 80       	push   $0x801159a0
801052d5:	e8 5a 18 00 00       	call   80106b34 <release>
801052da:	83 c4 10             	add    $0x10,%esp
                return pid;
801052dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801052e0:	e9 2a 01 00 00       	jmp    8010540f <wait+0x24b>
            }
            p = p->next;
801052e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052e8:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801052ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(;;){
        // Scan through table looking for zombie children.
        havekids = 0;
        // start at zombie list
        p = ptable.pLists.zombie;
        while (!havekids && p) {
801052f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801052f5:	75 0a                	jne    80105301 <wait+0x13d>
801052f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801052fb:	0f 85 ed fe ff ff    	jne    801051ee <wait+0x2a>
                return pid;
            }
            p = p->next;
        }
        // Runnable list
        for (int i = 0; i <= MAX; i++) {
80105301:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80105308:	eb 47                	jmp    80105351 <wait+0x18d>
            p = ptable.pLists.ready[i];
8010530a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010530d:	05 cc 09 00 00       	add    $0x9cc,%eax
80105312:	8b 04 85 a4 59 11 80 	mov    -0x7feea65c(,%eax,4),%eax
80105319:	89 45 f4             	mov    %eax,-0xc(%ebp)
            while (!havekids && p) {
8010531c:	eb 23                	jmp    80105341 <wait+0x17d>
                if (p->parent == proc) {
8010531e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105321:	8b 50 14             	mov    0x14(%eax),%edx
80105324:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010532a:	39 c2                	cmp    %eax,%edx
8010532c:	75 07                	jne    80105335 <wait+0x171>
                    havekids = 1;
8010532e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
                }
                p = p->next;
80105335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105338:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010533e:	89 45 f4             	mov    %eax,-0xc(%ebp)
            p = p->next;
        }
        // Runnable list
        for (int i = 0; i <= MAX; i++) {
            p = ptable.pLists.ready[i];
            while (!havekids && p) {
80105341:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105345:	75 06                	jne    8010534d <wait+0x189>
80105347:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010534b:	75 d1                	jne    8010531e <wait+0x15a>
                return pid;
            }
            p = p->next;
        }
        // Runnable list
        for (int i = 0; i <= MAX; i++) {
8010534d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80105351:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
80105355:	7e b3                	jle    8010530a <wait+0x146>
                }
                p = p->next;
            }
        }
        // Running list
        p = ptable.pLists.running;
80105357:	a1 ec 80 11 80       	mov    0x801180ec,%eax
8010535c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
8010535f:	eb 23                	jmp    80105384 <wait+0x1c0>
            if (p->parent == proc) {
80105361:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105364:	8b 50 14             	mov    0x14(%eax),%edx
80105367:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010536d:	39 c2                	cmp    %eax,%edx
8010536f:	75 07                	jne    80105378 <wait+0x1b4>
                havekids = 1;
80105371:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            }
            p = p->next;
80105378:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010537b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105381:	89 45 f4             	mov    %eax,-0xc(%ebp)
                p = p->next;
            }
        }
        // Running list
        p = ptable.pLists.running;
        while (!havekids && p) {
80105384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105388:	75 06                	jne    80105390 <wait+0x1cc>
8010538a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010538e:	75 d1                	jne    80105361 <wait+0x19d>
                havekids = 1;
            }
            p = p->next;
        }
        // Sleep list
        p = ptable.pLists.sleep;
80105390:	a1 e4 80 11 80       	mov    0x801180e4,%eax
80105395:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (!havekids && p) {
80105398:	eb 23                	jmp    801053bd <wait+0x1f9>
            if (p->parent == proc) {
8010539a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010539d:	8b 50 14             	mov    0x14(%eax),%edx
801053a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053a6:	39 c2                	cmp    %eax,%edx
801053a8:	75 07                	jne    801053b1 <wait+0x1ed>
                havekids = 1;
801053aa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            }
            p = p->next;
801053b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053b4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801053ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
        // Sleep list
        p = ptable.pLists.sleep;
        while (!havekids && p) {
801053bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801053c1:	75 06                	jne    801053c9 <wait+0x205>
801053c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801053c7:	75 d1                	jne    8010539a <wait+0x1d6>
                havekids = 1;
            }
            p = p->next;
        }
        // No point waiting if we don't have any children.
        if(!havekids || proc->killed) {
801053c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801053cd:	74 0d                	je     801053dc <wait+0x218>
801053cf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053d5:	8b 40 24             	mov    0x24(%eax),%eax
801053d8:	85 c0                	test   %eax,%eax
801053da:	74 17                	je     801053f3 <wait+0x22f>
            release(&ptable.lock);
801053dc:	83 ec 0c             	sub    $0xc,%esp
801053df:	68 a0 59 11 80       	push   $0x801159a0
801053e4:	e8 4b 17 00 00       	call   80106b34 <release>
801053e9:	83 c4 10             	add    $0x10,%esp
            return -1;
801053ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053f1:	eb 1c                	jmp    8010540f <wait+0x24b>
        }

        // Wait for children to exit.  (See wakeup1 call in proc_exit.)
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
801053f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053f9:	83 ec 08             	sub    $0x8,%esp
801053fc:	68 a0 59 11 80       	push   $0x801159a0
80105401:	50                   	push   %eax
80105402:	e8 11 04 00 00       	call   80105818 <sleep>
80105407:	83 c4 10             	add    $0x10,%esp
    }
8010540a:	e9 cb fd ff ff       	jmp    801051da <wait+0x16>
}
8010540f:	c9                   	leave  
80105410:	c3                   	ret    

80105411 <scheduler>:

#else
// Project 3 scheduler
void
scheduler(void)
{
80105411:	55                   	push   %ebp
80105412:	89 e5                	mov    %esp,%ebp
80105414:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    int idle;  // for checking if processor is idle
    int ran; // ready list loop condition 
    for(;;) {
        // Enable interrupts on this processor.
        sti();
80105417:	e8 6a f3 ff ff       	call   80104786 <sti>
        idle = 1;  // assume idle unless we schedule a process
8010541c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        ran = 0; // reset ran, look for another process
80105423:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        // Loop over process table looking for process to run.
        acquire(&ptable.lock);
8010542a:	83 ec 0c             	sub    $0xc,%esp
8010542d:	68 a0 59 11 80       	push   $0x801159a0
80105432:	e8 96 16 00 00       	call   80106acd <acquire>
80105437:	83 c4 10             	add    $0x10,%esp

        if ((ptable.promoteAtTime) == ticks) {
8010543a:	8b 15 f4 80 11 80    	mov    0x801180f4,%edx
80105440:	a1 00 89 11 80       	mov    0x80118900,%eax
80105445:	39 c2                	cmp    %eax,%edx
80105447:	75 14                	jne    8010545d <scheduler+0x4c>
            promoteAll(); // RUNNING, RUNNABLE, SLEEPING
80105449:	e8 80 12 00 00       	call   801066ce <promoteAll>
            ptable.promoteAtTime = (ticks + TIME_TO_PROMOTE); // update next time we will promote everything
8010544e:	a1 00 89 11 80       	mov    0x80118900,%eax
80105453:	05 0e 01 00 00       	add    $0x10e,%eax
80105458:	a3 f4 80 11 80       	mov    %eax,0x801180f4
        }
        for (int i = 0; (i <= MAX) && (ran == 0); ++i) {
8010545d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80105464:	e9 00 01 00 00       	jmp    80105569 <scheduler+0x158>
            // take first process on first valid list
            p = ptable.pLists.ready[i];
80105469:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010546c:	05 cc 09 00 00       	add    $0x9cc,%eax
80105471:	8b 04 85 a4 59 11 80 	mov    -0x7feea65c(,%eax,4),%eax
80105478:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (p) {
8010547b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010547f:	0f 84 e0 00 00 00    	je     80105565 <scheduler+0x154>
                // assign pointer, aseert correct state
                assertState(p, RUNNABLE);
80105485:	83 ec 08             	sub    $0x8,%esp
80105488:	6a 03                	push   $0x3
8010548a:	ff 75 e8             	pushl  -0x18(%ebp)
8010548d:	e8 38 0d 00 00       	call   801061ca <assertState>
80105492:	83 c4 10             	add    $0x10,%esp
                // take 1st process on ready list
                p = removeHead(&ptable.pLists.ready[p->priority]);
80105495:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105498:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010549e:	05 cc 09 00 00       	add    $0x9cc,%eax
801054a3:	c1 e0 02             	shl    $0x2,%eax
801054a6:	05 a0 59 11 80       	add    $0x801159a0,%eax
801054ab:	83 c0 04             	add    $0x4,%eax
801054ae:	83 ec 0c             	sub    $0xc,%esp
801054b1:	50                   	push   %eax
801054b2:	e8 28 0f 00 00       	call   801063df <removeHead>
801054b7:	83 c4 10             	add    $0x10,%esp
801054ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
                if (!p) {
801054bd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801054c1:	75 0d                	jne    801054d0 <scheduler+0xbf>
                    panic("Scheduler: removeHead failed.");
801054c3:	83 ec 0c             	sub    $0xc,%esp
801054c6:	68 6e a9 10 80       	push   $0x8010a96e
801054cb:	e8 96 b0 ff ff       	call   80100566 <panic>
                }
                // hand over to the CPU
                idle = 0;
801054d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
                proc = p;
801054d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801054da:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
                switchuvm(p);
801054e0:	83 ec 0c             	sub    $0xc,%esp
801054e3:	ff 75 e8             	pushl  -0x18(%ebp)
801054e6:	e8 f9 46 00 00       	call   80109be4 <switchuvm>
801054eb:	83 c4 10             	add    $0x10,%esp
                p->state = RUNNING;
801054ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
801054f1:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
                // add to end of running list
                if (addToStateListEnd(&ptable.pLists.running, p) < 0) {
801054f8:	83 ec 08             	sub    $0x8,%esp
801054fb:	ff 75 e8             	pushl  -0x18(%ebp)
801054fe:	68 ec 80 11 80       	push   $0x801180ec
80105503:	e8 62 0d 00 00       	call   8010626a <addToStateListEnd>
80105508:	83 c4 10             	add    $0x10,%esp
8010550b:	85 c0                	test   %eax,%eax
8010550d:	79 10                	jns    8010551f <scheduler+0x10e>
                    cprintf("Failed to add RUNNING proc to list (scheduler).");
8010550f:	83 ec 0c             	sub    $0xc,%esp
80105512:	68 8c a9 10 80       	push   $0x8010a98c
80105517:	e8 aa ae ff ff       	call   801003c6 <cprintf>
8010551c:	83 c4 10             	add    $0x10,%esp
                }
                p->cpu_ticks_in = ticks; // ticks when scheduled
8010551f:	8b 15 00 89 11 80    	mov    0x80118900,%edx
80105525:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105528:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
                swtch(&cpu->scheduler, proc->context);
8010552e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105534:	8b 40 1c             	mov    0x1c(%eax),%eax
80105537:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010553e:	83 c2 04             	add    $0x4,%edx
80105541:	83 ec 08             	sub    $0x8,%esp
80105544:	50                   	push   %eax
80105545:	52                   	push   %edx
80105546:	e8 59 1a 00 00       	call   80106fa4 <swtch>
8010554b:	83 c4 10             	add    $0x10,%esp
                switchkvm();
8010554e:	e8 74 46 00 00       	call   80109bc7 <switchkvm>
                // Process is done running for now.
                // It should have changed its p->state before coming back.
                proc = 0;
80105553:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010555a:	00 00 00 00 
                ran = 1; // exit loop after this
8010555e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

        if ((ptable.promoteAtTime) == ticks) {
            promoteAll(); // RUNNING, RUNNABLE, SLEEPING
            ptable.promoteAtTime = (ticks + TIME_TO_PROMOTE); // update next time we will promote everything
        }
        for (int i = 0; (i <= MAX) && (ran == 0); ++i) {
80105565:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80105569:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
8010556d:	7f 0a                	jg     80105579 <scheduler+0x168>
8010556f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105573:	0f 84 f0 fe ff ff    	je     80105469 <scheduler+0x58>
                // It should have changed its p->state before coming back.
                proc = 0;
                ran = 1; // exit loop after this
            }
        }
        release(&ptable.lock);
80105579:	83 ec 0c             	sub    $0xc,%esp
8010557c:	68 a0 59 11 80       	push   $0x801159a0
80105581:	e8 ae 15 00 00       	call   80106b34 <release>
80105586:	83 c4 10             	add    $0x10,%esp
        if (idle) {
80105589:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010558d:	0f 84 84 fe ff ff    	je     80105417 <scheduler+0x6>
            sti();
80105593:	e8 ee f1 ff ff       	call   80104786 <sti>
            hlt();
80105598:	e8 d2 f1 ff ff       	call   8010476f <hlt>
        }
    }
8010559d:	e9 75 fe ff ff       	jmp    80105417 <scheduler+0x6>

801055a2 <sched>:
    cpu->intena = intena;
}
#else
void
sched(void)
{
801055a2:	55                   	push   %ebp
801055a3:	89 e5                	mov    %esp,%ebp
801055a5:	53                   	push   %ebx
801055a6:	83 ec 14             	sub    $0x14,%esp
    int intena;

    if(!holding(&ptable.lock))
801055a9:	83 ec 0c             	sub    $0xc,%esp
801055ac:	68 a0 59 11 80       	push   $0x801159a0
801055b1:	e8 4a 16 00 00       	call   80106c00 <holding>
801055b6:	83 c4 10             	add    $0x10,%esp
801055b9:	85 c0                	test   %eax,%eax
801055bb:	75 0d                	jne    801055ca <sched+0x28>
        panic("sched ptable.lock");
801055bd:	83 ec 0c             	sub    $0xc,%esp
801055c0:	68 bc a9 10 80       	push   $0x8010a9bc
801055c5:	e8 9c af ff ff       	call   80100566 <panic>
    if(cpu->ncli != 1)
801055ca:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801055d0:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801055d6:	83 f8 01             	cmp    $0x1,%eax
801055d9:	74 0d                	je     801055e8 <sched+0x46>
        panic("sched locks");
801055db:	83 ec 0c             	sub    $0xc,%esp
801055de:	68 ce a9 10 80       	push   $0x8010a9ce
801055e3:	e8 7e af ff ff       	call   80100566 <panic>
    if(proc->state == RUNNING)
801055e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055ee:	8b 40 0c             	mov    0xc(%eax),%eax
801055f1:	83 f8 04             	cmp    $0x4,%eax
801055f4:	75 0d                	jne    80105603 <sched+0x61>
        panic("sched running");
801055f6:	83 ec 0c             	sub    $0xc,%esp
801055f9:	68 da a9 10 80       	push   $0x8010a9da
801055fe:	e8 63 af ff ff       	call   80100566 <panic>
    if(readeflags()&FL_IF)
80105603:	e8 6e f1 ff ff       	call   80104776 <readeflags>
80105608:	25 00 02 00 00       	and    $0x200,%eax
8010560d:	85 c0                	test   %eax,%eax
8010560f:	74 0d                	je     8010561e <sched+0x7c>
        panic("sched interruptible");
80105611:	83 ec 0c             	sub    $0xc,%esp
80105614:	68 e8 a9 10 80       	push   $0x8010a9e8
80105619:	e8 48 af ff ff       	call   80100566 <panic>
    intena = cpu->intena;
8010561e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105624:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010562a:	89 45 f4             	mov    %eax,-0xc(%ebp)

    proc->cpu_ticks_total += (ticks - proc->cpu_ticks_in);
8010562d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105633:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010563a:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80105640:	8b 1d 00 89 11 80    	mov    0x80118900,%ebx
80105646:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010564d:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
80105653:	29 d3                	sub    %edx,%ebx
80105655:	89 da                	mov    %ebx,%edx
80105657:	01 ca                	add    %ecx,%edx
80105659:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)

    swtch(&proc->context, cpu->scheduler);
8010565f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105665:	8b 40 04             	mov    0x4(%eax),%eax
80105668:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010566f:	83 c2 1c             	add    $0x1c,%edx
80105672:	83 ec 08             	sub    $0x8,%esp
80105675:	50                   	push   %eax
80105676:	52                   	push   %edx
80105677:	e8 28 19 00 00       	call   80106fa4 <swtch>
8010567c:	83 c4 10             	add    $0x10,%esp

    cpu->intena = intena;
8010567f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105685:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105688:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
8010568e:	90                   	nop
8010568f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105692:	c9                   	leave  
80105693:	c3                   	ret    

80105694 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
80105694:	55                   	push   %ebp
80105695:	89 e5                	mov    %esp,%ebp
80105697:	53                   	push   %ebx
80105698:	83 ec 04             	sub    $0x4,%esp
    acquire(&ptable.lock);  //DOC: yieldlock
8010569b:	83 ec 0c             	sub    $0xc,%esp
8010569e:	68 a0 59 11 80       	push   $0x801159a0
801056a3:	e8 25 14 00 00       	call   80106acd <acquire>
801056a8:	83 c4 10             	add    $0x10,%esp

#ifdef CS333_P3P4
    assertState(proc, RUNNING);
801056ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056b1:	83 ec 08             	sub    $0x8,%esp
801056b4:	6a 04                	push   $0x4
801056b6:	50                   	push   %eax
801056b7:	e8 0e 0b 00 00       	call   801061ca <assertState>
801056bc:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
801056bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056c5:	83 ec 08             	sub    $0x8,%esp
801056c8:	50                   	push   %eax
801056c9:	68 ec 80 11 80       	push   $0x801180ec
801056ce:	e8 18 0c 00 00       	call   801062eb <removeFromStateList>
801056d3:	83 c4 10             	add    $0x10,%esp
801056d6:	85 c0                	test   %eax,%eax
801056d8:	79 10                	jns    801056ea <yield+0x56>
        cprintf("Failed to remove RUNNING proc to list (yeild).");
801056da:	83 ec 0c             	sub    $0xc,%esp
801056dd:	68 fc a9 10 80       	push   $0x8010a9fc
801056e2:	e8 df ac ff ff       	call   801003c6 <cprintf>
801056e7:	83 c4 10             	add    $0x10,%esp
    }
#endif

    proc->state = RUNNABLE;
801056ea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056f0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

#ifdef CS333_P3P4
    proc->budget -= (ticks - proc->cpu_ticks_in); // update budget, then check
801056f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056fd:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105704:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
8010570a:	89 d3                	mov    %edx,%ebx
8010570c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105713:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
80105719:	8b 15 00 89 11 80    	mov    0x80118900,%edx
8010571f:	29 d1                	sub    %edx,%ecx
80105721:	89 ca                	mov    %ecx,%edx
80105723:	01 da                	add    %ebx,%edx
80105725:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if ((proc->budget) <= 0) {
8010572b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105731:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105737:	85 c0                	test   %eax,%eax
80105739:	7f 36                	jg     80105771 <yield+0xdd>
        if ((proc->priority) < MAX) {
8010573b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105741:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105747:	83 f8 01             	cmp    $0x1,%eax
8010574a:	77 15                	ja     80105761 <yield+0xcd>
            ++(proc->priority); // Demotion
8010574c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105752:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105758:	83 c2 01             	add    $0x1,%edx
8010575b:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        }
        proc->budget = BUDGET; // Reset budget
80105761:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105767:	c7 80 98 00 00 00 78 	movl   $0x78,0x98(%eax)
8010576e:	00 00 00 
    }

    if (addToStateListEnd(&ptable.pLists.ready[proc->priority], proc) < 0) {
80105771:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105777:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010577e:	8b 92 94 00 00 00    	mov    0x94(%edx),%edx
80105784:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
8010578a:	c1 e2 02             	shl    $0x2,%edx
8010578d:	81 c2 a0 59 11 80    	add    $0x801159a0,%edx
80105793:	83 c2 04             	add    $0x4,%edx
80105796:	83 ec 08             	sub    $0x8,%esp
80105799:	50                   	push   %eax
8010579a:	52                   	push   %edx
8010579b:	e8 ca 0a 00 00       	call   8010626a <addToStateListEnd>
801057a0:	83 c4 10             	add    $0x10,%esp
801057a3:	85 c0                	test   %eax,%eax
801057a5:	79 10                	jns    801057b7 <yield+0x123>
        cprintf("Failed to add RUNNABLE proc to list (yeild).");
801057a7:	83 ec 0c             	sub    $0xc,%esp
801057aa:	68 2c aa 10 80       	push   $0x8010aa2c
801057af:	e8 12 ac ff ff       	call   801003c6 <cprintf>
801057b4:	83 c4 10             	add    $0x10,%esp
    }
#endif

    sched();
801057b7:	e8 e6 fd ff ff       	call   801055a2 <sched>
    release(&ptable.lock);
801057bc:	83 ec 0c             	sub    $0xc,%esp
801057bf:	68 a0 59 11 80       	push   $0x801159a0
801057c4:	e8 6b 13 00 00       	call   80106b34 <release>
801057c9:	83 c4 10             	add    $0x10,%esp
}
801057cc:	90                   	nop
801057cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057d0:	c9                   	leave  
801057d1:	c3                   	ret    

801057d2 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801057d2:	55                   	push   %ebp
801057d3:	89 e5                	mov    %esp,%ebp
801057d5:	83 ec 08             	sub    $0x8,%esp
    static int first = 1;
    // Still holding ptable.lock from scheduler.
    release(&ptable.lock);
801057d8:	83 ec 0c             	sub    $0xc,%esp
801057db:	68 a0 59 11 80       	push   $0x801159a0
801057e0:	e8 4f 13 00 00       	call   80106b34 <release>
801057e5:	83 c4 10             	add    $0x10,%esp

    if (first) {
801057e8:	a1 20 e0 10 80       	mov    0x8010e020,%eax
801057ed:	85 c0                	test   %eax,%eax
801057ef:	74 24                	je     80105815 <forkret+0x43>
        // Some initialization functions must be run in the context
        // of a regular process (e.g., they call sleep), and thus cannot 
        // be run from main().
        first = 0;
801057f1:	c7 05 20 e0 10 80 00 	movl   $0x0,0x8010e020
801057f8:	00 00 00 
        iinit(ROOTDEV);
801057fb:	83 ec 0c             	sub    $0xc,%esp
801057fe:	6a 01                	push   $0x1
80105800:	e8 89 bf ff ff       	call   8010178e <iinit>
80105805:	83 c4 10             	add    $0x10,%esp
        initlog(ROOTDEV);
80105808:	83 ec 0c             	sub    $0xc,%esp
8010580b:	6a 01                	push   $0x1
8010580d:	e8 4e de ff ff       	call   80103660 <initlog>
80105812:	83 c4 10             	add    $0x10,%esp
    }

    // Return to "caller", actually trapret (see allocproc).
}
80105815:	90                   	nop
80105816:	c9                   	leave  
80105817:	c3                   	ret    

80105818 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80105818:	55                   	push   %ebp
80105819:	89 e5                	mov    %esp,%ebp
8010581b:	53                   	push   %ebx
8010581c:	83 ec 04             	sub    $0x4,%esp
    if(proc == 0)
8010581f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105825:	85 c0                	test   %eax,%eax
80105827:	75 0d                	jne    80105836 <sleep+0x1e>
        panic("sleep");
80105829:	83 ec 0c             	sub    $0xc,%esp
8010582c:	68 59 aa 10 80       	push   $0x8010aa59
80105831:	e8 30 ad ff ff       	call   80100566 <panic>
    // change p->state and then call sched.
    // Once we hold ptable.lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup runs with ptable.lock locked),
    // so it's okay to release lk.
    if(lk != &ptable.lock){
80105836:	81 7d 0c a0 59 11 80 	cmpl   $0x801159a0,0xc(%ebp)
8010583d:	74 24                	je     80105863 <sleep+0x4b>
        acquire(&ptable.lock);
8010583f:	83 ec 0c             	sub    $0xc,%esp
80105842:	68 a0 59 11 80       	push   $0x801159a0
80105847:	e8 81 12 00 00       	call   80106acd <acquire>
8010584c:	83 c4 10             	add    $0x10,%esp
        if (lk) release(lk);
8010584f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105853:	74 0e                	je     80105863 <sleep+0x4b>
80105855:	83 ec 0c             	sub    $0xc,%esp
80105858:	ff 75 0c             	pushl  0xc(%ebp)
8010585b:	e8 d4 12 00 00       	call   80106b34 <release>
80105860:	83 c4 10             	add    $0x10,%esp
    }

    // Go to sleep.
    proc->chan = chan;
80105863:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105869:	8b 55 08             	mov    0x8(%ebp),%edx
8010586c:	89 50 20             	mov    %edx,0x20(%eax)

#ifdef CS333_P3P4
    assertState(proc, RUNNING);
8010586f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105875:	83 ec 08             	sub    $0x8,%esp
80105878:	6a 04                	push   $0x4
8010587a:	50                   	push   %eax
8010587b:	e8 4a 09 00 00       	call   801061ca <assertState>
80105880:	83 c4 10             	add    $0x10,%esp
    if (removeFromStateList(&ptable.pLists.running, proc) < 0) {
80105883:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105889:	83 ec 08             	sub    $0x8,%esp
8010588c:	50                   	push   %eax
8010588d:	68 ec 80 11 80       	push   $0x801180ec
80105892:	e8 54 0a 00 00       	call   801062eb <removeFromStateList>
80105897:	83 c4 10             	add    $0x10,%esp
8010589a:	85 c0                	test   %eax,%eax
8010589c:	79 10                	jns    801058ae <sleep+0x96>
        cprintf("Could not remove RUNNING proc from list (sleep()).\n");
8010589e:	83 ec 0c             	sub    $0xc,%esp
801058a1:	68 60 aa 10 80       	push   $0x8010aa60
801058a6:	e8 1b ab ff ff       	call   801003c6 <cprintf>
801058ab:	83 c4 10             	add    $0x10,%esp
    }
#endif

    proc->state = SLEEPING;
801058ae:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058b4:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

#ifdef CS333_P3P4
    proc->budget -= (ticks - proc->cpu_ticks_in); // update budget, then check
801058bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058c1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801058c8:	8b 92 98 00 00 00    	mov    0x98(%edx),%edx
801058ce:	89 d3                	mov    %edx,%ebx
801058d0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801058d7:	8b 8a 8c 00 00 00    	mov    0x8c(%edx),%ecx
801058dd:	8b 15 00 89 11 80    	mov    0x80118900,%edx
801058e3:	29 d1                	sub    %edx,%ecx
801058e5:	89 ca                	mov    %ecx,%edx
801058e7:	01 da                	add    %ebx,%edx
801058e9:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    if ((proc->budget) <= 0) {
801058ef:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058f5:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801058fb:	85 c0                	test   %eax,%eax
801058fd:	7f 36                	jg     80105935 <sleep+0x11d>
        // priority cant be greater than MAX bc it is literal index of ready list array
        if ((proc->priority) < MAX) {
801058ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105905:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010590b:	83 f8 01             	cmp    $0x1,%eax
8010590e:	77 15                	ja     80105925 <sleep+0x10d>
            ++(proc->priority); // Demotion
80105910:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105916:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
8010591c:	83 c2 01             	add    $0x1,%edx
8010591f:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
        }
        proc->budget = BUDGET; // Reset budget
80105925:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010592b:	c7 80 98 00 00 00 78 	movl   $0x78,0x98(%eax)
80105932:	00 00 00 
    }
    if (addToStateListEnd(&ptable.pLists.sleep, proc) < 0) {
80105935:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010593b:	83 ec 08             	sub    $0x8,%esp
8010593e:	50                   	push   %eax
8010593f:	68 e4 80 11 80       	push   $0x801180e4
80105944:	e8 21 09 00 00       	call   8010626a <addToStateListEnd>
80105949:	83 c4 10             	add    $0x10,%esp
8010594c:	85 c0                	test   %eax,%eax
8010594e:	79 10                	jns    80105960 <sleep+0x148>
        cprintf("Could not add SLEEPING proc to list (sleep()).\n");
80105950:	83 ec 0c             	sub    $0xc,%esp
80105953:	68 94 aa 10 80       	push   $0x8010aa94
80105958:	e8 69 aa ff ff       	call   801003c6 <cprintf>
8010595d:	83 c4 10             	add    $0x10,%esp
    }
#endif

    sched();
80105960:	e8 3d fc ff ff       	call   801055a2 <sched>

    // Tidy up.
    proc->chan = 0;
80105965:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010596b:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

    // Reacquire original lock.
    if(lk != &ptable.lock){ 
80105972:	81 7d 0c a0 59 11 80 	cmpl   $0x801159a0,0xc(%ebp)
80105979:	74 24                	je     8010599f <sleep+0x187>
        release(&ptable.lock);
8010597b:	83 ec 0c             	sub    $0xc,%esp
8010597e:	68 a0 59 11 80       	push   $0x801159a0
80105983:	e8 ac 11 00 00       	call   80106b34 <release>
80105988:	83 c4 10             	add    $0x10,%esp
        if (lk) acquire(lk);
8010598b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010598f:	74 0e                	je     8010599f <sleep+0x187>
80105991:	83 ec 0c             	sub    $0xc,%esp
80105994:	ff 75 0c             	pushl  0xc(%ebp)
80105997:	e8 31 11 00 00       	call   80106acd <acquire>
8010599c:	83 c4 10             	add    $0x10,%esp
    }
}
8010599f:	90                   	nop
801059a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801059a3:	c9                   	leave  
801059a4:	c3                   	ret    

801059a5 <wakeup1>:
}
#else
// P3 wakeup1
static void
wakeup1(void *chan)
{
801059a5:	55                   	push   %ebp
801059a6:	89 e5                	mov    %esp,%ebp
801059a8:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;
    if (ptable.pLists.sleep) {
801059ab:	a1 e4 80 11 80       	mov    0x801180e4,%eax
801059b0:	85 c0                	test   %eax,%eax
801059b2:	0f 84 b8 00 00 00    	je     80105a70 <wakeup1+0xcb>
        struct proc * current = ptable.pLists.sleep;
801059b8:	a1 e4 80 11 80       	mov    0x801180e4,%eax
801059bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = 0;
801059c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        while (current) {
801059c7:	e9 9a 00 00 00       	jmp    80105a66 <wakeup1+0xc1>
            p = current;
801059cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
            current = current->next;
801059d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059d5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801059db:	89 45 f4             	mov    %eax,-0xc(%ebp)
            assertState(p, SLEEPING);
801059de:	83 ec 08             	sub    $0x8,%esp
801059e1:	6a 02                	push   $0x2
801059e3:	ff 75 f0             	pushl  -0x10(%ebp)
801059e6:	e8 df 07 00 00       	call   801061ca <assertState>
801059eb:	83 c4 10             	add    $0x10,%esp
            if (p->chan == chan) {
801059ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059f1:	8b 40 20             	mov    0x20(%eax),%eax
801059f4:	3b 45 08             	cmp    0x8(%ebp),%eax
801059f7:	75 6d                	jne    80105a66 <wakeup1+0xc1>
                if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
801059f9:	83 ec 08             	sub    $0x8,%esp
801059fc:	ff 75 f0             	pushl  -0x10(%ebp)
801059ff:	68 e4 80 11 80       	push   $0x801180e4
80105a04:	e8 e2 08 00 00       	call   801062eb <removeFromStateList>
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	85 c0                	test   %eax,%eax
80105a0e:	79 10                	jns    80105a20 <wakeup1+0x7b>
                    cprintf("Failed to remove SLEEPING proc to list (wakeup1).\n");
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	68 c4 aa 10 80       	push   $0x8010aac4
80105a18:	e8 a9 a9 ff ff       	call   801003c6 <cprintf>
80105a1d:	83 c4 10             	add    $0x10,%esp
                }
                p->state = RUNNABLE;
80105a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a23:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
80105a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a2d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105a33:	05 cc 09 00 00       	add    $0x9cc,%eax
80105a38:	c1 e0 02             	shl    $0x2,%eax
80105a3b:	05 a0 59 11 80       	add    $0x801159a0,%eax
80105a40:	83 c0 04             	add    $0x4,%eax
80105a43:	83 ec 08             	sub    $0x8,%esp
80105a46:	ff 75 f0             	pushl  -0x10(%ebp)
80105a49:	50                   	push   %eax
80105a4a:	e8 1b 08 00 00       	call   8010626a <addToStateListEnd>
80105a4f:	83 c4 10             	add    $0x10,%esp
80105a52:	85 c0                	test   %eax,%eax
80105a54:	79 10                	jns    80105a66 <wakeup1+0xc1>
                    cprintf("Failed to add RUNNABLE proc to list (wakeup1).\n");
80105a56:	83 ec 0c             	sub    $0xc,%esp
80105a59:	68 f8 aa 10 80       	push   $0x8010aaf8
80105a5e:	e8 63 a9 ff ff       	call   801003c6 <cprintf>
80105a63:	83 c4 10             	add    $0x10,%esp
{
    struct proc *p;
    if (ptable.pLists.sleep) {
        struct proc * current = ptable.pLists.sleep;
        p = 0;
        while (current) {
80105a66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a6a:	0f 85 5c ff ff ff    	jne    801059cc <wakeup1+0x27>
                    cprintf("Failed to add RUNNABLE proc to list (wakeup1).\n");
                }
            }
        }
    }
}
80105a70:	90                   	nop
80105a71:	c9                   	leave  
80105a72:	c3                   	ret    

80105a73 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105a73:	55                   	push   %ebp
80105a74:	89 e5                	mov    %esp,%ebp
80105a76:	83 ec 08             	sub    $0x8,%esp
    acquire(&ptable.lock);
80105a79:	83 ec 0c             	sub    $0xc,%esp
80105a7c:	68 a0 59 11 80       	push   $0x801159a0
80105a81:	e8 47 10 00 00       	call   80106acd <acquire>
80105a86:	83 c4 10             	add    $0x10,%esp
    wakeup1(chan);
80105a89:	83 ec 0c             	sub    $0xc,%esp
80105a8c:	ff 75 08             	pushl  0x8(%ebp)
80105a8f:	e8 11 ff ff ff       	call   801059a5 <wakeup1>
80105a94:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105a97:	83 ec 0c             	sub    $0xc,%esp
80105a9a:	68 a0 59 11 80       	push   $0x801159a0
80105a9f:	e8 90 10 00 00       	call   80106b34 <release>
80105aa4:	83 c4 10             	add    $0x10,%esp
}
80105aa7:	90                   	nop
80105aa8:	c9                   	leave  
80105aa9:	c3                   	ret    

80105aaa <kill>:
    return -1;
}
#else
int
kill(int pid)
{
80105aaa:	55                   	push   %ebp
80105aab:	89 e5                	mov    %esp,%ebp
80105aad:	83 ec 18             	sub    $0x18,%esp
    struct proc *p;

    acquire(&ptable.lock);
80105ab0:	83 ec 0c             	sub    $0xc,%esp
80105ab3:	68 a0 59 11 80       	push   $0x801159a0
80105ab8:	e8 10 10 00 00       	call   80106acd <acquire>
80105abd:	83 c4 10             	add    $0x10,%esp
    // traverse Sleeping list, wake processes if necessary
    p = ptable.pLists.sleep;
80105ac0:	a1 e4 80 11 80       	mov    0x801180e4,%eax
80105ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105ac8:	e9 be 00 00 00       	jmp    80105b8b <kill+0xe1>
        if (p->pid == pid) {
80105acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad0:	8b 50 10             	mov    0x10(%eax),%edx
80105ad3:	8b 45 08             	mov    0x8(%ebp),%eax
80105ad6:	39 c2                	cmp    %eax,%edx
80105ad8:	0f 85 a1 00 00 00    	jne    80105b7f <kill+0xd5>
            p->killed = 1;
80105ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae1:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            assertState(p, SLEEPING);
80105ae8:	83 ec 08             	sub    $0x8,%esp
80105aeb:	6a 02                	push   $0x2
80105aed:	ff 75 f4             	pushl  -0xc(%ebp)
80105af0:	e8 d5 06 00 00       	call   801061ca <assertState>
80105af5:	83 c4 10             	add    $0x10,%esp
            if (removeFromStateList(&ptable.pLists.sleep, p) < 0) {
80105af8:	83 ec 08             	sub    $0x8,%esp
80105afb:	ff 75 f4             	pushl  -0xc(%ebp)
80105afe:	68 e4 80 11 80       	push   $0x801180e4
80105b03:	e8 e3 07 00 00       	call   801062eb <removeFromStateList>
80105b08:	83 c4 10             	add    $0x10,%esp
80105b0b:	85 c0                	test   %eax,%eax
80105b0d:	79 10                	jns    80105b1f <kill+0x75>
                cprintf("Could not remove SLEEPING proc from list (kill).\n");
80105b0f:	83 ec 0c             	sub    $0xc,%esp
80105b12:	68 28 ab 10 80       	push   $0x8010ab28
80105b17:	e8 aa a8 ff ff       	call   801003c6 <cprintf>
80105b1c:	83 c4 10             	add    $0x10,%esp
            }
            p->state = RUNNABLE;
80105b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b22:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
            if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
80105b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b2c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105b32:	05 cc 09 00 00       	add    $0x9cc,%eax
80105b37:	c1 e0 02             	shl    $0x2,%eax
80105b3a:	05 a0 59 11 80       	add    $0x801159a0,%eax
80105b3f:	83 c0 04             	add    $0x4,%eax
80105b42:	83 ec 08             	sub    $0x8,%esp
80105b45:	ff 75 f4             	pushl  -0xc(%ebp)
80105b48:	50                   	push   %eax
80105b49:	e8 1c 07 00 00       	call   8010626a <addToStateListEnd>
80105b4e:	83 c4 10             	add    $0x10,%esp
80105b51:	85 c0                	test   %eax,%eax
80105b53:	79 10                	jns    80105b65 <kill+0xbb>
                cprintf("Could not add RUNNABLE proc to list (kill).\n");
80105b55:	83 ec 0c             	sub    $0xc,%esp
80105b58:	68 5c ab 10 80       	push   $0x8010ab5c
80105b5d:	e8 64 a8 ff ff       	call   801003c6 <cprintf>
80105b62:	83 c4 10             	add    $0x10,%esp
            }
            release(&ptable.lock);
80105b65:	83 ec 0c             	sub    $0xc,%esp
80105b68:	68 a0 59 11 80       	push   $0x801159a0
80105b6d:	e8 c2 0f 00 00       	call   80106b34 <release>
80105b72:	83 c4 10             	add    $0x10,%esp
            return 0;
80105b75:	b8 00 00 00 00       	mov    $0x0,%eax
80105b7a:	e9 c3 01 00 00       	jmp    80105d42 <kill+0x298>
        }
        p = p->next;
80105b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b82:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b88:	89 45 f4             	mov    %eax,-0xc(%ebp)
    struct proc *p;

    acquire(&ptable.lock);
    // traverse Sleeping list, wake processes if necessary
    p = ptable.pLists.sleep;
    while (p) {
80105b8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b8f:	0f 85 38 ff ff ff    	jne    80105acd <kill+0x23>
        }
        p = p->next;
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
80105b95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105b9c:	eb 5b                	jmp    80105bf9 <kill+0x14f>
        p = ptable.pLists.ready[i];
80105b9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ba1:	05 cc 09 00 00       	add    $0x9cc,%eax
80105ba6:	8b 04 85 a4 59 11 80 	mov    -0x7feea65c(,%eax,4),%eax
80105bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
80105bb0:	eb 3d                	jmp    80105bef <kill+0x145>
            if (p->pid == pid) {
80105bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb5:	8b 50 10             	mov    0x10(%eax),%edx
80105bb8:	8b 45 08             	mov    0x8(%ebp),%eax
80105bbb:	39 c2                	cmp    %eax,%edx
80105bbd:	75 24                	jne    80105be3 <kill+0x139>
                p->killed = 1;
80105bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
                release(&ptable.lock);
80105bc9:	83 ec 0c             	sub    $0xc,%esp
80105bcc:	68 a0 59 11 80       	push   $0x801159a0
80105bd1:	e8 5e 0f 00 00       	call   80106b34 <release>
80105bd6:	83 c4 10             	add    $0x10,%esp
                return 0;
80105bd9:	b8 00 00 00 00       	mov    $0x0,%eax
80105bde:	e9 5f 01 00 00       	jmp    80105d42 <kill+0x298>
            }
            p = p->next;
80105be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105bec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i];
        while (p) {
80105bef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bf3:	75 bd                	jne    80105bb2 <kill+0x108>
        }
        p = p->next;
    }

    // traverse Runnable list
    for (int i = 0; i <= MAX; ++i) {
80105bf5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105bf9:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
80105bfd:	7e 9f                	jle    80105b9e <kill+0xf4>
            p = p->next;
        }
    }

    // traverse Running list
    p = ptable.pLists.running;
80105bff:	a1 ec 80 11 80       	mov    0x801180ec,%eax
80105c04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105c07:	eb 3d                	jmp    80105c46 <kill+0x19c>
        if (p->pid == pid) {
80105c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c0c:	8b 50 10             	mov    0x10(%eax),%edx
80105c0f:	8b 45 08             	mov    0x8(%ebp),%eax
80105c12:	39 c2                	cmp    %eax,%edx
80105c14:	75 24                	jne    80105c3a <kill+0x190>
            p->killed = 1;
80105c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c19:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105c20:	83 ec 0c             	sub    $0xc,%esp
80105c23:	68 a0 59 11 80       	push   $0x801159a0
80105c28:	e8 07 0f 00 00       	call   80106b34 <release>
80105c2d:	83 c4 10             	add    $0x10,%esp
            return 0;
80105c30:	b8 00 00 00 00       	mov    $0x0,%eax
80105c35:	e9 08 01 00 00       	jmp    80105d42 <kill+0x298>
        }
        p = p->next;
80105c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c3d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105c43:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
    }

    // traverse Running list
    p = ptable.pLists.running;
    while (p) {
80105c46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c4a:	75 bd                	jne    80105c09 <kill+0x15f>
        }
        p = p->next;
    }

    // traverse Unused List
    p = ptable.pLists.free;
80105c4c:	a1 e0 80 11 80       	mov    0x801180e0,%eax
80105c51:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105c54:	eb 3d                	jmp    80105c93 <kill+0x1e9>
        if (p->pid == pid) {
80105c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c59:	8b 50 10             	mov    0x10(%eax),%edx
80105c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80105c5f:	39 c2                	cmp    %eax,%edx
80105c61:	75 24                	jne    80105c87 <kill+0x1dd>
            p->killed = 1;
80105c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c66:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105c6d:	83 ec 0c             	sub    $0xc,%esp
80105c70:	68 a0 59 11 80       	push   $0x801159a0
80105c75:	e8 ba 0e 00 00       	call   80106b34 <release>
80105c7a:	83 c4 10             	add    $0x10,%esp
            return 0;
80105c7d:	b8 00 00 00 00       	mov    $0x0,%eax
80105c82:	e9 bb 00 00 00       	jmp    80105d42 <kill+0x298>
        }
        p = p->next;
80105c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c8a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105c90:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Unused List
    p = ptable.pLists.free;
    while (p) {
80105c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c97:	75 bd                	jne    80105c56 <kill+0x1ac>
        }
        p = p->next;
    }

    // traverse Zombie list
    p = ptable.pLists.zombie;
80105c99:	a1 e8 80 11 80       	mov    0x801180e8,%eax
80105c9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105ca1:	eb 3a                	jmp    80105cdd <kill+0x233>
        if (p->pid == pid) {
80105ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ca6:	8b 50 10             	mov    0x10(%eax),%edx
80105ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80105cac:	39 c2                	cmp    %eax,%edx
80105cae:	75 21                	jne    80105cd1 <kill+0x227>
            p->killed = 1;
80105cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105cba:	83 ec 0c             	sub    $0xc,%esp
80105cbd:	68 a0 59 11 80       	push   $0x801159a0
80105cc2:	e8 6d 0e 00 00       	call   80106b34 <release>
80105cc7:	83 c4 10             	add    $0x10,%esp
            return 0;
80105cca:	b8 00 00 00 00       	mov    $0x0,%eax
80105ccf:	eb 71                	jmp    80105d42 <kill+0x298>
        }
        p = p->next;
80105cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cd4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105cda:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Zombie list
    p = ptable.pLists.zombie;
    while (p) {
80105cdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ce1:	75 c0                	jne    80105ca3 <kill+0x1f9>
        }
        p = p->next;
    }

    // traverse Embryo list
    p = ptable.pLists.embryo;
80105ce3:	a1 f0 80 11 80       	mov    0x801180f0,%eax
80105ce8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80105ceb:	eb 3a                	jmp    80105d27 <kill+0x27d>
        if (p->pid == pid) {
80105ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf0:	8b 50 10             	mov    0x10(%eax),%edx
80105cf3:	8b 45 08             	mov    0x8(%ebp),%eax
80105cf6:	39 c2                	cmp    %eax,%edx
80105cf8:	75 21                	jne    80105d1b <kill+0x271>
            p->killed = 1;
80105cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cfd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            release(&ptable.lock);
80105d04:	83 ec 0c             	sub    $0xc,%esp
80105d07:	68 a0 59 11 80       	push   $0x801159a0
80105d0c:	e8 23 0e 00 00       	call   80106b34 <release>
80105d11:	83 c4 10             	add    $0x10,%esp
            return 0;
80105d14:	b8 00 00 00 00       	mov    $0x0,%eax
80105d19:	eb 27                	jmp    80105d42 <kill+0x298>
        }
        p = p->next;
80105d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d1e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105d24:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = p->next;
    }

    // traverse Embryo list
    p = ptable.pLists.embryo;
    while (p) {
80105d27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d2b:	75 c0                	jne    80105ced <kill+0x243>
        }
        p = p->next;
    }

    // return error
    release(&ptable.lock);
80105d2d:	83 ec 0c             	sub    $0xc,%esp
80105d30:	68 a0 59 11 80       	push   $0x801159a0
80105d35:	e8 fa 0d 00 00       	call   80106b34 <release>
80105d3a:	83 c4 10             	add    $0x10,%esp
    return -1;
80105d3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d42:	c9                   	leave  
80105d43:	c3                   	ret    

80105d44 <elapsed_time>:
// No lock to avoid wedging a stuck machine further.

#ifdef CS333_P1
void
elapsed_time(uint p_ticks)
{
80105d44:	55                   	push   %ebp
80105d45:	89 e5                	mov    %esp,%ebp
80105d47:	83 ec 28             	sub    $0x28,%esp
    uint elapsed, whole_sec, milisec_ten, milisec_hund, milisec_thou;
    //elapsed = ticks - p->start_ticks; // find original elapsed time
    elapsed = p_ticks;
80105d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80105d4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    whole_sec = (elapsed / 1000); // the the left of the decimal point
80105d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d53:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105d58:	f7 e2                	mul    %edx
80105d5a:	89 d0                	mov    %edx,%eax
80105d5c:	c1 e8 06             	shr    $0x6,%eax
80105d5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // % to shave off leading digit of elapsed for decimal place calcs
    milisec_ten = ((elapsed %= 1000) / 100); // divide and round up to nearest int
80105d62:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105d65:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80105d6a:	89 c8                	mov    %ecx,%eax
80105d6c:	f7 e2                	mul    %edx
80105d6e:	89 d0                	mov    %edx,%eax
80105d70:	c1 e8 06             	shr    $0x6,%eax
80105d73:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
80105d79:	29 c1                	sub    %eax,%ecx
80105d7b:	89 c8                	mov    %ecx,%eax
80105d7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d83:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105d88:	f7 e2                	mul    %edx
80105d8a:	89 d0                	mov    %edx,%eax
80105d8c:	c1 e8 05             	shr    $0x5,%eax
80105d8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    milisec_hund = ((elapsed %= 100) / 10); // shave off previously counted int, repeat
80105d92:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105d95:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105d9a:	89 c8                	mov    %ecx,%eax
80105d9c:	f7 e2                	mul    %edx
80105d9e:	89 d0                	mov    %edx,%eax
80105da0:	c1 e8 05             	shr    $0x5,%eax
80105da3:	6b c0 64             	imul   $0x64,%eax,%eax
80105da6:	29 c1                	sub    %eax,%ecx
80105da8:	89 c8                	mov    %ecx,%eax
80105daa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db0:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105db5:	f7 e2                	mul    %edx
80105db7:	89 d0                	mov    %edx,%eax
80105db9:	c1 e8 03             	shr    $0x3,%eax
80105dbc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    milisec_thou = (elapsed %= 10); // determine thousandth place
80105dbf:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80105dc2:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105dc7:	89 c8                	mov    %ecx,%eax
80105dc9:	f7 e2                	mul    %edx
80105dcb:	c1 ea 03             	shr    $0x3,%edx
80105dce:	89 d0                	mov    %edx,%eax
80105dd0:	c1 e0 02             	shl    $0x2,%eax
80105dd3:	01 d0                	add    %edx,%eax
80105dd5:	01 c0                	add    %eax,%eax
80105dd7:	29 c1                	sub    %eax,%ecx
80105dd9:	89 c8                	mov    %ecx,%eax
80105ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105de1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("\t%d.%d%d%d", whole_sec, milisec_ten, milisec_hund, milisec_thou);
80105de4:	83 ec 0c             	sub    $0xc,%esp
80105de7:	ff 75 e4             	pushl  -0x1c(%ebp)
80105dea:	ff 75 e8             	pushl  -0x18(%ebp)
80105ded:	ff 75 ec             	pushl  -0x14(%ebp)
80105df0:	ff 75 f0             	pushl  -0x10(%ebp)
80105df3:	68 89 ab 10 80       	push   $0x8010ab89
80105df8:	e8 c9 a5 ff ff       	call   801003c6 <cprintf>
80105dfd:	83 c4 20             	add    $0x20,%esp
}
80105e00:	90                   	nop
80105e01:	c9                   	leave  
80105e02:	c3                   	ret    

80105e03 <procdump>:
#else

// Project 3 & 4
void
procdump(void)
{
80105e03:	55                   	push   %ebp
80105e04:	89 e5                	mov    %esp,%ebp
80105e06:	56                   	push   %esi
80105e07:	53                   	push   %ebx
80105e08:	83 ec 40             	sub    $0x40,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
80105e0b:	68 94 ab 10 80       	push   $0x8010ab94
80105e10:	68 98 ab 10 80       	push   $0x8010ab98
80105e15:	68 9d ab 10 80       	push   $0x8010ab9d
80105e1a:	68 a3 ab 10 80       	push   $0x8010aba3
80105e1f:	68 a7 ab 10 80       	push   $0x8010aba7
80105e24:	68 af ab 10 80       	push   $0x8010abaf
80105e29:	68 b4 ab 10 80       	push   $0x8010abb4
80105e2e:	68 b9 ab 10 80       	push   $0x8010abb9
80105e33:	68 bd ab 10 80       	push   $0x8010abbd
80105e38:	68 c1 ab 10 80       	push   $0x8010abc1
80105e3d:	68 c6 ab 10 80       	push   $0x8010abc6
80105e42:	68 cc ab 10 80       	push   $0x8010abcc
80105e47:	e8 7a a5 ff ff       	call   801003c6 <cprintf>
80105e4c:	83 c4 30             	add    $0x30,%esp
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105e4f:	c7 45 f0 d4 59 11 80 	movl   $0x801159d4,-0x10(%ebp)
80105e56:	e9 5c 01 00 00       	jmp    80105fb7 <procdump+0x1b4>
        if(p->state == UNUSED)
80105e5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e5e:	8b 40 0c             	mov    0xc(%eax),%eax
80105e61:	85 c0                	test   %eax,%eax
80105e63:	0f 84 46 01 00 00    	je     80105faf <procdump+0x1ac>
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e6c:	8b 40 0c             	mov    0xc(%eax),%eax
80105e6f:	83 f8 05             	cmp    $0x5,%eax
80105e72:	77 23                	ja     80105e97 <procdump+0x94>
80105e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e77:	8b 40 0c             	mov    0xc(%eax),%eax
80105e7a:	8b 04 85 08 e0 10 80 	mov    -0x7fef1ff8(,%eax,4),%eax
80105e81:	85 c0                	test   %eax,%eax
80105e83:	74 12                	je     80105e97 <procdump+0x94>
            state = states[p->state];
80105e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e88:	8b 40 0c             	mov    0xc(%eax),%eax
80105e8b:	8b 04 85 08 e0 10 80 	mov    -0x7fef1ff8(,%eax,4),%eax
80105e92:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105e95:	eb 07                	jmp    80105e9e <procdump+0x9b>
        else
            state = "???";
80105e97:	c7 45 ec ef ab 10 80 	movl   $0x8010abef,-0x14(%ebp)
        cprintf("%d\t%s\t%d\t%d\t%d",
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
80105e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea1:	8b 40 14             	mov    0x14(%eax),%eax
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d\t%s\t%d\t%d\t%d",
80105ea4:	8b 58 10             	mov    0x10(%eax),%ebx
80105ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eaa:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb3:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
80105eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ebc:	8d 70 6c             	lea    0x6c(%eax),%esi
            continue;
        if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
        cprintf("%d\t%s\t%d\t%d\t%d",
80105ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec2:	8b 40 10             	mov    0x10(%eax),%eax
80105ec5:	83 ec 08             	sub    $0x8,%esp
80105ec8:	53                   	push   %ebx
80105ec9:	51                   	push   %ecx
80105eca:	52                   	push   %edx
80105ecb:	56                   	push   %esi
80105ecc:	50                   	push   %eax
80105ecd:	68 f3 ab 10 80       	push   $0x8010abf3
80105ed2:	e8 ef a4 ff ff       	call   801003c6 <cprintf>
80105ed7:	83 c4 20             	add    $0x20,%esp
                p->pid, p->name, p->uid, p->gid, p->parent->pid);
        cprintf("\t%d", p->priority);
80105eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105edd:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105ee3:	83 ec 08             	sub    $0x8,%esp
80105ee6:	50                   	push   %eax
80105ee7:	68 02 ac 10 80       	push   $0x8010ac02
80105eec:	e8 d5 a4 ff ff       	call   801003c6 <cprintf>
80105ef1:	83 c4 10             	add    $0x10,%esp
        elapsed_time(ticks - p->start_ticks);
80105ef4:	8b 15 00 89 11 80    	mov    0x80118900,%edx
80105efa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105efd:	8b 40 7c             	mov    0x7c(%eax),%eax
80105f00:	29 c2                	sub    %eax,%edx
80105f02:	89 d0                	mov    %edx,%eax
80105f04:	83 ec 0c             	sub    $0xc,%esp
80105f07:	50                   	push   %eax
80105f08:	e8 37 fe ff ff       	call   80105d44 <elapsed_time>
80105f0d:	83 c4 10             	add    $0x10,%esp
        elapsed_time(p->cpu_ticks_total);
80105f10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f13:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105f19:	83 ec 0c             	sub    $0xc,%esp
80105f1c:	50                   	push   %eax
80105f1d:	e8 22 fe ff ff       	call   80105d44 <elapsed_time>
80105f22:	83 c4 10             	add    $0x10,%esp
        cprintf("\t%s\t%d", state, p->sz);
80105f25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f28:	8b 00                	mov    (%eax),%eax
80105f2a:	83 ec 04             	sub    $0x4,%esp
80105f2d:	50                   	push   %eax
80105f2e:	ff 75 ec             	pushl  -0x14(%ebp)
80105f31:	68 06 ac 10 80       	push   $0x8010ac06
80105f36:	e8 8b a4 ff ff       	call   801003c6 <cprintf>
80105f3b:	83 c4 10             	add    $0x10,%esp

        if(p->state == SLEEPING){
80105f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f41:	8b 40 0c             	mov    0xc(%eax),%eax
80105f44:	83 f8 02             	cmp    $0x2,%eax
80105f47:	75 54                	jne    80105f9d <procdump+0x19a>
            getcallerpcs((uint*)p->context->ebp+2, pc);
80105f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f4c:	8b 40 1c             	mov    0x1c(%eax),%eax
80105f4f:	8b 40 0c             	mov    0xc(%eax),%eax
80105f52:	83 c0 08             	add    $0x8,%eax
80105f55:	89 c2                	mov    %eax,%edx
80105f57:	83 ec 08             	sub    $0x8,%esp
80105f5a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105f5d:	50                   	push   %eax
80105f5e:	52                   	push   %edx
80105f5f:	e8 22 0c 00 00       	call   80106b86 <getcallerpcs>
80105f64:	83 c4 10             	add    $0x10,%esp
            for(i=0; i<10 && pc[i] != 0; i++)
80105f67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105f6e:	eb 1c                	jmp    80105f8c <procdump+0x189>
                cprintf("\t%p", pc[i]);
80105f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f73:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105f77:	83 ec 08             	sub    $0x8,%esp
80105f7a:	50                   	push   %eax
80105f7b:	68 0d ac 10 80       	push   $0x8010ac0d
80105f80:	e8 41 a4 ff ff       	call   801003c6 <cprintf>
80105f85:	83 c4 10             	add    $0x10,%esp
        elapsed_time(p->cpu_ticks_total);
        cprintf("\t%s\t%d", state, p->sz);

        if(p->state == SLEEPING){
            getcallerpcs((uint*)p->context->ebp+2, pc);
            for(i=0; i<10 && pc[i] != 0; i++)
80105f88:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105f8c:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105f90:	7f 0b                	jg     80105f9d <procdump+0x19a>
80105f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f95:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105f99:	85 c0                	test   %eax,%eax
80105f9b:	75 d3                	jne    80105f70 <procdump+0x16d>
                cprintf("\t%p", pc[i]);
        }
        cprintf("\n");
80105f9d:	83 ec 0c             	sub    $0xc,%esp
80105fa0:	68 11 ac 10 80       	push   $0x8010ac11
80105fa5:	e8 1c a4 ff ff       	call   801003c6 <cprintf>
80105faa:	83 c4 10             	add    $0x10,%esp
80105fad:	eb 01                	jmp    80105fb0 <procdump+0x1ad>
    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->state == UNUSED)
            continue;
80105faf:	90                   	nop
    uint pc[10];

    cprintf("\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n",
            "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size", "PCs");

    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105fb0:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105fb7:	81 7d f0 d4 80 11 80 	cmpl   $0x801180d4,-0x10(%ebp)
80105fbe:	0f 82 97 fe ff ff    	jb     80105e5b <procdump+0x58>
            for(i=0; i<10 && pc[i] != 0; i++)
                cprintf("\t%p", pc[i]);
        }
        cprintf("\n");
    }
}
80105fc4:	90                   	nop
80105fc5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105fc8:	5b                   	pop    %ebx
80105fc9:	5e                   	pop    %esi
80105fca:	5d                   	pop    %ebp
80105fcb:	c3                   	ret    

80105fcc <getprocs>:
#ifdef CS333_P2
// loop process table and copy active processes, return number of copied procs
// populate uproc array passed in from ps.c
int
getprocs(uint max, struct uproc *table)
{
80105fcc:	55                   	push   %ebp
80105fcd:	89 e5                	mov    %esp,%ebp
80105fcf:	83 ec 18             	sub    $0x18,%esp
    int i = 0;
80105fd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct proc *p;
    acquire(&ptable.lock);
80105fd9:	83 ec 0c             	sub    $0xc,%esp
80105fdc:	68 a0 59 11 80       	push   $0x801159a0
80105fe1:	e8 e7 0a 00 00       	call   80106acd <acquire>
80105fe6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
80105fe9:	c7 45 f0 d4 59 11 80 	movl   $0x801159d4,-0x10(%ebp)
80105ff0:	e9 ab 01 00 00       	jmp    801061a0 <getprocs+0x1d4>
        // only copy active processes
        if (p->state == RUNNABLE || p->state == RUNNING || p->state == SLEEPING) {
80105ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff8:	8b 40 0c             	mov    0xc(%eax),%eax
80105ffb:	83 f8 03             	cmp    $0x3,%eax
80105ffe:	74 1a                	je     8010601a <getprocs+0x4e>
80106000:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106003:	8b 40 0c             	mov    0xc(%eax),%eax
80106006:	83 f8 04             	cmp    $0x4,%eax
80106009:	74 0f                	je     8010601a <getprocs+0x4e>
8010600b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010600e:	8b 40 0c             	mov    0xc(%eax),%eax
80106011:	83 f8 02             	cmp    $0x2,%eax
80106014:	0f 85 7f 01 00 00    	jne    80106199 <getprocs+0x1cd>
            table[i].pid = p->pid;
8010601a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010601d:	89 d0                	mov    %edx,%eax
8010601f:	01 c0                	add    %eax,%eax
80106021:	01 d0                	add    %edx,%eax
80106023:	c1 e0 05             	shl    $0x5,%eax
80106026:	89 c2                	mov    %eax,%edx
80106028:	8b 45 0c             	mov    0xc(%ebp),%eax
8010602b:	01 c2                	add    %eax,%edx
8010602d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106030:	8b 40 10             	mov    0x10(%eax),%eax
80106033:	89 02                	mov    %eax,(%edx)
            table[i].uid = p->uid;
80106035:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106038:	89 d0                	mov    %edx,%eax
8010603a:	01 c0                	add    %eax,%eax
8010603c:	01 d0                	add    %edx,%eax
8010603e:	c1 e0 05             	shl    $0x5,%eax
80106041:	89 c2                	mov    %eax,%edx
80106043:	8b 45 0c             	mov    0xc(%ebp),%eax
80106046:	01 c2                	add    %eax,%edx
80106048:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010604b:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80106051:	89 42 04             	mov    %eax,0x4(%edx)
            table[i].gid = p->gid;
80106054:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106057:	89 d0                	mov    %edx,%eax
80106059:	01 c0                	add    %eax,%eax
8010605b:	01 d0                	add    %edx,%eax
8010605d:	c1 e0 05             	shl    $0x5,%eax
80106060:	89 c2                	mov    %eax,%edx
80106062:	8b 45 0c             	mov    0xc(%ebp),%eax
80106065:	01 c2                	add    %eax,%edx
80106067:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010606a:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80106070:	89 42 08             	mov    %eax,0x8(%edx)
            if (p->pid == 1) {
80106073:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106076:	8b 40 10             	mov    0x10(%eax),%eax
80106079:	83 f8 01             	cmp    $0x1,%eax
8010607c:	75 1c                	jne    8010609a <getprocs+0xce>
                table[i].ppid = 1;
8010607e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106081:	89 d0                	mov    %edx,%eax
80106083:	01 c0                	add    %eax,%eax
80106085:	01 d0                	add    %edx,%eax
80106087:	c1 e0 05             	shl    $0x5,%eax
8010608a:	89 c2                	mov    %eax,%edx
8010608c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010608f:	01 d0                	add    %edx,%eax
80106091:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
80106098:	eb 1f                	jmp    801060b9 <getprocs+0xed>
            } else {
                table[i].ppid = p->parent->pid;
8010609a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010609d:	89 d0                	mov    %edx,%eax
8010609f:	01 c0                	add    %eax,%eax
801060a1:	01 d0                	add    %edx,%eax
801060a3:	c1 e0 05             	shl    $0x5,%eax
801060a6:	89 c2                	mov    %eax,%edx
801060a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801060ab:	01 c2                	add    %eax,%edx
801060ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060b0:	8b 40 14             	mov    0x14(%eax),%eax
801060b3:	8b 40 10             	mov    0x10(%eax),%eax
801060b6:	89 42 0c             	mov    %eax,0xc(%edx)
            }
#ifdef CS333_P3P4
            table[i].priority = p->priority;
801060b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060bc:	89 d0                	mov    %edx,%eax
801060be:	01 c0                	add    %eax,%eax
801060c0:	01 d0                	add    %edx,%eax
801060c2:	c1 e0 05             	shl    $0x5,%eax
801060c5:	89 c2                	mov    %eax,%edx
801060c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801060ca:	01 c2                	add    %eax,%edx
801060cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060cf:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801060d5:	89 42 5c             	mov    %eax,0x5c(%edx)
#endif
            table[i].elapsed_ticks = (ticks - p->start_ticks);
801060d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060db:	89 d0                	mov    %edx,%eax
801060dd:	01 c0                	add    %eax,%eax
801060df:	01 d0                	add    %edx,%eax
801060e1:	c1 e0 05             	shl    $0x5,%eax
801060e4:	89 c2                	mov    %eax,%edx
801060e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801060e9:	01 c2                	add    %eax,%edx
801060eb:	8b 0d 00 89 11 80    	mov    0x80118900,%ecx
801060f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060f4:	8b 40 7c             	mov    0x7c(%eax),%eax
801060f7:	29 c1                	sub    %eax,%ecx
801060f9:	89 c8                	mov    %ecx,%eax
801060fb:	89 42 10             	mov    %eax,0x10(%edx)
            table[i].CPU_total_ticks = p->cpu_ticks_total;
801060fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106101:	89 d0                	mov    %edx,%eax
80106103:	01 c0                	add    %eax,%eax
80106105:	01 d0                	add    %edx,%eax
80106107:	c1 e0 05             	shl    $0x5,%eax
8010610a:	89 c2                	mov    %eax,%edx
8010610c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010610f:	01 c2                	add    %eax,%edx
80106111:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106114:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010611a:	89 42 14             	mov    %eax,0x14(%edx)
            safestrcpy(table[i].state, states[p->state], STRMAX);
8010611d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106120:	8b 40 0c             	mov    0xc(%eax),%eax
80106123:	8b 0c 85 08 e0 10 80 	mov    -0x7fef1ff8(,%eax,4),%ecx
8010612a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010612d:	89 d0                	mov    %edx,%eax
8010612f:	01 c0                	add    %eax,%eax
80106131:	01 d0                	add    %edx,%eax
80106133:	c1 e0 05             	shl    $0x5,%eax
80106136:	89 c2                	mov    %eax,%edx
80106138:	8b 45 0c             	mov    0xc(%ebp),%eax
8010613b:	01 d0                	add    %edx,%eax
8010613d:	83 c0 18             	add    $0x18,%eax
80106140:	83 ec 04             	sub    $0x4,%esp
80106143:	6a 20                	push   $0x20
80106145:	51                   	push   %ecx
80106146:	50                   	push   %eax
80106147:	e8 e7 0d 00 00       	call   80106f33 <safestrcpy>
8010614c:	83 c4 10             	add    $0x10,%esp
            table[i].size = p->sz;
8010614f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106152:	89 d0                	mov    %edx,%eax
80106154:	01 c0                	add    %eax,%eax
80106156:	01 d0                	add    %edx,%eax
80106158:	c1 e0 05             	shl    $0x5,%eax
8010615b:	89 c2                	mov    %eax,%edx
8010615d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106160:	01 c2                	add    %eax,%edx
80106162:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106165:	8b 00                	mov    (%eax),%eax
80106167:	89 42 38             	mov    %eax,0x38(%edx)
            safestrcpy(table[i].name, p->name, STRMAX);
8010616a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010616d:	8d 48 6c             	lea    0x6c(%eax),%ecx
80106170:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106173:	89 d0                	mov    %edx,%eax
80106175:	01 c0                	add    %eax,%eax
80106177:	01 d0                	add    %edx,%eax
80106179:	c1 e0 05             	shl    $0x5,%eax
8010617c:	89 c2                	mov    %eax,%edx
8010617e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106181:	01 d0                	add    %edx,%eax
80106183:	83 c0 3c             	add    $0x3c,%eax
80106186:	83 ec 04             	sub    $0x4,%esp
80106189:	6a 20                	push   $0x20
8010618b:	51                   	push   %ecx
8010618c:	50                   	push   %eax
8010618d:	e8 a1 0d 00 00       	call   80106f33 <safestrcpy>
80106192:	83 c4 10             	add    $0x10,%esp
            ++i;
80106195:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
getprocs(uint max, struct uproc *table)
{
    int i = 0;
    struct proc *p;
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC] && i < max; p++) {
80106199:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
801061a0:	81 7d f0 d4 80 11 80 	cmpl   $0x801180d4,-0x10(%ebp)
801061a7:	73 0c                	jae    801061b5 <getprocs+0x1e9>
801061a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ac:	3b 45 08             	cmp    0x8(%ebp),%eax
801061af:	0f 82 40 fe ff ff    	jb     80105ff5 <getprocs+0x29>
            table[i].size = p->sz;
            safestrcpy(table[i].name, p->name, STRMAX);
            ++i;
        }
    }
    release(&ptable.lock);
801061b5:	83 ec 0c             	sub    $0xc,%esp
801061b8:	68 a0 59 11 80       	push   $0x801159a0
801061bd:	e8 72 09 00 00       	call   80106b34 <release>
801061c2:	83 c4 10             	add    $0x10,%esp
    return i; // return number of procs copied
801061c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801061c8:	c9                   	leave  
801061c9:	c3                   	ret    

801061ca <assertState>:


//PROJECT 3
// assert that process is in proper state, otherwise panic
static void
assertState(struct proc* p, enum procstate state) {
801061ca:	55                   	push   %ebp
801061cb:	89 e5                	mov    %esp,%ebp
801061cd:	83 ec 08             	sub    $0x8,%esp
    if (!p) {
801061d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801061d4:	75 0d                	jne    801061e3 <assertState+0x19>
        panic("assertState: invalid proc argument.\n");
801061d6:	83 ec 0c             	sub    $0xc,%esp
801061d9:	68 14 ac 10 80       	push   $0x8010ac14
801061de:	e8 83 a3 ff ff       	call   80100566 <panic>
    }
    if (p->state != state) {
801061e3:	8b 45 08             	mov    0x8(%ebp),%eax
801061e6:	8b 40 0c             	mov    0xc(%eax),%eax
801061e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801061ec:	74 0d                	je     801061fb <assertState+0x31>
        panic("assertState: process in wrong state.\n");
801061ee:	83 ec 0c             	sub    $0xc,%esp
801061f1:	68 3c ac 10 80       	push   $0x8010ac3c
801061f6:	e8 6b a3 ff ff       	call   80100566 <panic>
    }
}
801061fb:	90                   	nop
801061fc:	c9                   	leave  
801061fd:	c3                   	ret    

801061fe <addToStateListHead>:

static int
addToStateListHead(struct proc** sList, struct proc* p) {
801061fe:	55                   	push   %ebp
801061ff:	89 e5                	mov    %esp,%ebp
80106201:	83 ec 08             	sub    $0x8,%esp
    if (!p) {
80106204:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106208:	75 0d                	jne    80106217 <addToStateListHead+0x19>
        panic("Invalid process.");
8010620a:	83 ec 0c             	sub    $0xc,%esp
8010620d:	68 62 ac 10 80       	push   $0x8010ac62
80106212:	e8 4f a3 ff ff       	call   80100566 <panic>
    }
    if (!(*sList)) { // if no list exists, make first entry
80106217:	8b 45 08             	mov    0x8(%ebp),%eax
8010621a:	8b 00                	mov    (%eax),%eax
8010621c:	85 c0                	test   %eax,%eax
8010621e:	75 1c                	jne    8010623c <addToStateListHead+0x3e>
        (*sList) = p; // arg proc is now the first item in list
80106220:	8b 45 08             	mov    0x8(%ebp),%eax
80106223:	8b 55 0c             	mov    0xc(%ebp),%edx
80106226:	89 10                	mov    %edx,(%eax)
        p->next = 0; // next is null
80106228:	8b 45 0c             	mov    0xc(%ebp),%eax
8010622b:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106232:	00 00 00 
        return 0; // return success
80106235:	b8 00 00 00 00       	mov    $0x0,%eax
8010623a:	eb 2c                	jmp    80106268 <addToStateListHead+0x6a>
    }
    // otherwise hold to next element and become 1st element
    p->next = (*sList); // arg proc has next element
8010623c:	8b 45 08             	mov    0x8(%ebp),%eax
8010623f:	8b 10                	mov    (%eax),%edx
80106241:	8b 45 0c             	mov    0xc(%ebp),%eax
80106244:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    (*sList) = p; // reassign head of list to arg proc
8010624a:	8b 45 08             	mov    0x8(%ebp),%eax
8010624d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106250:	89 10                	mov    %edx,(%eax)
    if (p != (*sList)) {
80106252:	8b 45 08             	mov    0x8(%ebp),%eax
80106255:	8b 00                	mov    (%eax),%eax
80106257:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010625a:	74 07                	je     80106263 <addToStateListHead+0x65>
        return -1; // if they don't match, return failure
8010625c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106261:	eb 05                	jmp    80106268 <addToStateListHead+0x6a>
    }
    return 0; // return success
80106263:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106268:	c9                   	leave  
80106269:	c3                   	ret    

8010626a <addToStateListEnd>:

static int
addToStateListEnd(struct proc** sList, struct proc* p) {
8010626a:	55                   	push   %ebp
8010626b:	89 e5                	mov    %esp,%ebp
8010626d:	83 ec 18             	sub    $0x18,%esp
    if (!p) {
80106270:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106274:	75 0d                	jne    80106283 <addToStateListEnd+0x19>
        panic("Invalid process.");
80106276:	83 ec 0c             	sub    $0xc,%esp
80106279:	68 62 ac 10 80       	push   $0x8010ac62
8010627e:	e8 e3 a2 ff ff       	call   80100566 <panic>
    }
    // if list desn't exist yet, initialize
    if (!(*sList)) {
80106283:	8b 45 08             	mov    0x8(%ebp),%eax
80106286:	8b 00                	mov    (%eax),%eax
80106288:	85 c0                	test   %eax,%eax
8010628a:	75 1c                	jne    801062a8 <addToStateListEnd+0x3e>
        (*sList) = p;
8010628c:	8b 45 08             	mov    0x8(%ebp),%eax
8010628f:	8b 55 0c             	mov    0xc(%ebp),%edx
80106292:	89 10                	mov    %edx,(%eax)
        p->next = 0;
80106294:	8b 45 0c             	mov    0xc(%ebp),%eax
80106297:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
8010629e:	00 00 00 
        return 0;
801062a1:	b8 00 00 00 00       	mov    $0x0,%eax
801062a6:	eb 41                	jmp    801062e9 <addToStateListEnd+0x7f>
    }
    // otherwise traverse and add at the end
    struct proc * current = (*sList);
801062a8:	8b 45 08             	mov    0x8(%ebp),%eax
801062ab:	8b 00                	mov    (%eax),%eax
801062ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (current->next) {
801062b0:	eb 0c                	jmp    801062be <addToStateListEnd+0x54>
        current = current->next;
801062b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801062bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p->next = 0;
        return 0;
    }
    // otherwise traverse and add at the end
    struct proc * current = (*sList);
    while (current->next) {
801062be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c1:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801062c7:	85 c0                	test   %eax,%eax
801062c9:	75 e7                	jne    801062b2 <addToStateListEnd+0x48>
        current = current->next;
    }
    current->next = p;
801062cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062ce:	8b 55 0c             	mov    0xc(%ebp),%edx
801062d1:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    p->next = 0;
801062d7:	8b 45 0c             	mov    0xc(%ebp),%eax
801062da:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801062e1:	00 00 00 
    return 0;
801062e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062e9:	c9                   	leave  
801062ea:	c3                   	ret    

801062eb <removeFromStateList>:

// search and remove process based on pointer address
static int
removeFromStateList(struct proc** sList, struct proc* p) {
801062eb:	55                   	push   %ebp
801062ec:	89 e5                	mov    %esp,%ebp
801062ee:	83 ec 18             	sub    $0x18,%esp
    if (!p) {
801062f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801062f5:	75 0d                	jne    80106304 <removeFromStateList+0x19>
        panic("Invalid process structures.");
801062f7:	83 ec 0c             	sub    $0xc,%esp
801062fa:	68 73 ac 10 80       	push   $0x8010ac73
801062ff:	e8 62 a2 ff ff       	call   80100566 <panic>
    }
    if (!(*sList)) {
80106304:	8b 45 08             	mov    0x8(%ebp),%eax
80106307:	8b 00                	mov    (%eax),%eax
80106309:	85 c0                	test   %eax,%eax
8010630b:	75 0a                	jne    80106317 <removeFromStateList+0x2c>
        return -1;
8010630d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106312:	e9 c6 00 00 00       	jmp    801063dd <removeFromStateList+0xf2>
    }
    // if p is the first element in list
    if (p == (*sList)) {
80106317:	8b 45 08             	mov    0x8(%ebp),%eax
8010631a:	8b 00                	mov    (%eax),%eax
8010631c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010631f:	75 59                	jne    8010637a <removeFromStateList+0x8f>
        // if it is the only item in list
        if (!(*sList)->next) {
80106321:	8b 45 08             	mov    0x8(%ebp),%eax
80106324:	8b 00                	mov    (%eax),%eax
80106326:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010632c:	85 c0                	test   %eax,%eax
8010632e:	75 20                	jne    80106350 <removeFromStateList+0x65>
            (*sList) = 0;
80106330:	8b 45 08             	mov    0x8(%ebp),%eax
80106333:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            p->next = 0;
80106339:	8b 45 0c             	mov    0xc(%ebp),%eax
8010633c:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106343:	00 00 00 
            return 0;
80106346:	b8 00 00 00 00       	mov    $0x0,%eax
8010634b:	e9 8d 00 00 00       	jmp    801063dd <removeFromStateList+0xf2>
        }
        // if p is the first item in list
        else {
            struct proc * temp = (*sList)->next;
80106350:	8b 45 08             	mov    0x8(%ebp),%eax
80106353:	8b 00                	mov    (%eax),%eax
80106355:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010635b:	89 45 ec             	mov    %eax,-0x14(%ebp)
            p->next = 0;
8010635e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106361:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106368:	00 00 00 
            (*sList) = temp;
8010636b:	8b 45 08             	mov    0x8(%ebp),%eax
8010636e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80106371:	89 10                	mov    %edx,(%eax)
            return 0;
80106373:	b8 00 00 00 00       	mov    $0x0,%eax
80106378:	eb 63                	jmp    801063dd <removeFromStateList+0xf2>
        }
    }
    // from middle or end of list
    else {
        struct proc * current = (*sList)->next;
8010637a:	8b 45 08             	mov    0x8(%ebp),%eax
8010637d:	8b 00                	mov    (%eax),%eax
8010637f:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106385:	89 45 f4             	mov    %eax,-0xc(%ebp)
        struct proc * prev = (*sList);
80106388:	8b 45 08             	mov    0x8(%ebp),%eax
8010638b:	8b 00                	mov    (%eax),%eax
8010638d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while (current) {
80106390:	eb 40                	jmp    801063d2 <removeFromStateList+0xe7>
            if (current == p) {
80106392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106395:	3b 45 0c             	cmp    0xc(%ebp),%eax
80106398:	75 26                	jne    801063c0 <removeFromStateList+0xd5>
                prev->next = current->next;
8010639a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010639d:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801063a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a6:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
                p->next = 0;
801063ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801063af:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
801063b6:	00 00 00 
                return 0;
801063b9:	b8 00 00 00 00       	mov    $0x0,%eax
801063be:	eb 1d                	jmp    801063dd <removeFromStateList+0xf2>
            }
            prev = current;
801063c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
            current = current->next;
801063c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801063cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    // from middle or end of list
    else {
        struct proc * current = (*sList)->next;
        struct proc * prev = (*sList);
        while (current) {
801063d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063d6:	75 ba                	jne    80106392 <removeFromStateList+0xa7>
            }
            prev = current;
            current = current->next;
        }
    }
    return -1; // nothing found
801063d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801063dd:	c9                   	leave  
801063de:	c3                   	ret    

801063df <removeHead>:

// remove first element of list, return its pointer
static struct proc*
removeHead(struct proc** sList) {
801063df:	55                   	push   %ebp
801063e0:	89 e5                	mov    %esp,%ebp
801063e2:	83 ec 10             	sub    $0x10,%esp
    if (!(*sList)) {
801063e5:	8b 45 08             	mov    0x8(%ebp),%eax
801063e8:	8b 00                	mov    (%eax),%eax
801063ea:	85 c0                	test   %eax,%eax
801063ec:	75 07                	jne    801063f5 <removeHead+0x16>
        return 0; // return null, check value in calling routine
801063ee:	b8 00 00 00 00       	mov    $0x0,%eax
801063f3:	eb 2e                	jmp    80106423 <removeHead+0x44>
    }
    struct proc* p = (*sList); // assign pointer to head of sList
801063f5:	8b 45 08             	mov    0x8(%ebp),%eax
801063f8:	8b 00                	mov    (%eax),%eax
801063fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    struct proc* temp = (*sList)->next; // hold onto next element in list
801063fd:	8b 45 08             	mov    0x8(%ebp),%eax
80106400:	8b 00                	mov    (%eax),%eax
80106402:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106408:	89 45 f8             	mov    %eax,-0x8(%ebp)
    p->next = 0; // p is no longer head of sList
8010640b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010640e:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80106415:	00 00 00 
    (*sList) = temp; // sList now starts at  2nd element, or is NULL if one-item list
80106418:	8b 45 08             	mov    0x8(%ebp),%eax
8010641b:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010641e:	89 10                	mov    %edx,(%eax)
    return p; // return 
80106420:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106423:	c9                   	leave  
80106424:	c3                   	ret    

80106425 <printReadyList>:

// print PIDs of all procs in Ready list
void
printReadyList(void) {
80106425:	55                   	push   %ebp
80106426:	89 e5                	mov    %esp,%ebp
80106428:	83 ec 18             	sub    $0x18,%esp
    //int i = 0;
    cprintf("\nReady List Processes:\n");
8010642b:	83 ec 0c             	sub    $0xc,%esp
8010642e:	68 8f ac 10 80       	push   $0x8010ac8f
80106433:	e8 8e 9f ff ff       	call   801003c6 <cprintf>
80106438:	83 c4 10             	add    $0x10,%esp
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
8010643b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106442:	e9 ca 00 00 00       	jmp    80106511 <printReadyList+0xec>
        if (ptable.pLists.ready[i]) {
80106447:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010644a:	05 cc 09 00 00       	add    $0x9cc,%eax
8010644f:	8b 04 85 a4 59 11 80 	mov    -0x7feea65c(,%eax,4),%eax
80106456:	85 c0                	test   %eax,%eax
80106458:	0f 84 9c 00 00 00    	je     801064fa <printReadyList+0xd5>
            cprintf("\n%d: ", i);
8010645e:	83 ec 08             	sub    $0x8,%esp
80106461:	ff 75 f4             	pushl  -0xc(%ebp)
80106464:	68 a7 ac 10 80       	push   $0x8010aca7
80106469:	e8 58 9f ff ff       	call   801003c6 <cprintf>
8010646e:	83 c4 10             	add    $0x10,%esp
            struct proc* current = ptable.pLists.ready[i];
80106471:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106474:	05 cc 09 00 00       	add    $0x9cc,%eax
80106479:	8b 04 85 a4 59 11 80 	mov    -0x7feea65c(,%eax,4),%eax
80106480:	89 45 f0             	mov    %eax,-0x10(%ebp)
            while (current) {
80106483:	eb 5d                	jmp    801064e2 <printReadyList+0xbd>
                if (current->next) {
80106485:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106488:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010648e:	85 c0                	test   %eax,%eax
80106490:	74 23                	je     801064b5 <printReadyList+0x90>
                    cprintf("(%d, %d) -> ", current->pid, current->budget);
80106492:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106495:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010649b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010649e:	8b 40 10             	mov    0x10(%eax),%eax
801064a1:	83 ec 04             	sub    $0x4,%esp
801064a4:	52                   	push   %edx
801064a5:	50                   	push   %eax
801064a6:	68 ad ac 10 80       	push   $0x8010acad
801064ab:	e8 16 9f ff ff       	call   801003c6 <cprintf>
801064b0:	83 c4 10             	add    $0x10,%esp
801064b3:	eb 21                	jmp    801064d6 <printReadyList+0xb1>
                } else {
                    cprintf("(%d, %d)", current->pid, current->budget);
801064b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064b8:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
801064be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064c1:	8b 40 10             	mov    0x10(%eax),%eax
801064c4:	83 ec 04             	sub    $0x4,%esp
801064c7:	52                   	push   %edx
801064c8:	50                   	push   %eax
801064c9:	68 ba ac 10 80       	push   $0x8010acba
801064ce:	e8 f3 9e ff ff       	call   801003c6 <cprintf>
801064d3:	83 c4 10             	add    $0x10,%esp
                }
                current = current->next;
801064d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064d9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801064df:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
        if (ptable.pLists.ready[i]) {
            cprintf("\n%d: ", i);
            struct proc* current = ptable.pLists.ready[i];
            while (current) {
801064e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064e6:	75 9d                	jne    80106485 <printReadyList+0x60>
                } else {
                    cprintf("(%d, %d)", current->pid, current->budget);
                }
                current = current->next;
            }
            cprintf("\n");
801064e8:	83 ec 0c             	sub    $0xc,%esp
801064eb:	68 11 ac 10 80       	push   $0x8010ac11
801064f0:	e8 d1 9e ff ff       	call   801003c6 <cprintf>
801064f5:	83 c4 10             	add    $0x10,%esp
801064f8:	eb 13                	jmp    8010650d <printReadyList+0xe8>
        }
        else {
            cprintf("\n%d: Empty.\n", i);
801064fa:	83 ec 08             	sub    $0x8,%esp
801064fd:	ff 75 f4             	pushl  -0xc(%ebp)
80106500:	68 c3 ac 10 80       	push   $0x8010acc3
80106505:	e8 bc 9e ff ff       	call   801003c6 <cprintf>
8010650a:	83 c4 10             	add    $0x10,%esp
void
printReadyList(void) {
    //int i = 0;
    cprintf("\nReady List Processes:\n");
    //while (i <= MAX) {
    for (int i = 0; i <= MAX; ++i) {
8010650d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106511:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
80106515:	0f 8e 2c ff ff ff    	jle    80106447 <printReadyList+0x22>
        }
        else {
            cprintf("\n%d: Empty.\n", i);
        }
    }
}
8010651b:	90                   	nop
8010651c:	c9                   	leave  
8010651d:	c3                   	ret    

8010651e <printFreeList>:

// print number of procs in Free list
void
printFreeList(void) {
8010651e:	55                   	push   %ebp
8010651f:	89 e5                	mov    %esp,%ebp
80106521:	83 ec 18             	sub    $0x18,%esp
    if (ptable.pLists.free) {
80106524:	a1 e0 80 11 80       	mov    0x801180e0,%eax
80106529:	85 c0                	test   %eax,%eax
8010652b:	74 3c                	je     80106569 <printFreeList+0x4b>
        int size = 0;
8010652d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        struct proc * current = ptable.pLists.free;
80106534:	a1 e0 80 11 80       	mov    0x801180e0,%eax
80106539:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while (current) {
8010653c:	eb 10                	jmp    8010654e <printFreeList+0x30>
            ++size; // cycle list and keep count
8010653e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
            current = current->next;
80106542:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106545:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010654b:	89 45 f0             	mov    %eax,-0x10(%ebp)
void
printFreeList(void) {
    if (ptable.pLists.free) {
        int size = 0;
        struct proc * current = ptable.pLists.free;
        while (current) {
8010654e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106552:	75 ea                	jne    8010653e <printFreeList+0x20>
            ++size; // cycle list and keep count
            current = current->next;
        }
        //for (struct proc* current = ptable.pLists.free; current; current = current->next) {++size;}
        cprintf("\nFree List Size: %d processes\n", size);
80106554:	83 ec 08             	sub    $0x8,%esp
80106557:	ff 75 f4             	pushl  -0xc(%ebp)
8010655a:	68 d0 ac 10 80       	push   $0x8010acd0
8010655f:	e8 62 9e ff ff       	call   801003c6 <cprintf>
80106564:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Free List.\n");
    }
}
80106567:	eb 10                	jmp    80106579 <printFreeList+0x5b>
        }
        //for (struct proc* current = ptable.pLists.free; current; current = current->next) {++size;}
        cprintf("\nFree List Size: %d processes\n", size);
    }
    else {
        cprintf("\nNo processes on Free List.\n");
80106569:	83 ec 0c             	sub    $0xc,%esp
8010656c:	68 ef ac 10 80       	push   $0x8010acef
80106571:	e8 50 9e ff ff       	call   801003c6 <cprintf>
80106576:	83 c4 10             	add    $0x10,%esp
    }
}
80106579:	90                   	nop
8010657a:	c9                   	leave  
8010657b:	c3                   	ret    

8010657c <printSleepList>:

// print PIDs of all procs in Sleep list
void
printSleepList(void) {
8010657c:	55                   	push   %ebp
8010657d:	89 e5                	mov    %esp,%ebp
8010657f:	83 ec 18             	sub    $0x18,%esp
    //acquire(&ptable.lock);
    if (ptable.pLists.sleep) {
80106582:	a1 e4 80 11 80       	mov    0x801180e4,%eax
80106587:	85 c0                	test   %eax,%eax
80106589:	74 7b                	je     80106606 <printSleepList+0x8a>
        struct proc* current = ptable.pLists.sleep;
8010658b:	a1 e4 80 11 80       	mov    0x801180e4,%eax
80106590:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("\nSleep List Processes:\n");
80106593:	83 ec 0c             	sub    $0xc,%esp
80106596:	68 0c ad 10 80       	push   $0x8010ad0c
8010659b:	e8 26 9e ff ff       	call   801003c6 <cprintf>
801065a0:	83 c4 10             	add    $0x10,%esp
        while (current) {
801065a3:	eb 49                	jmp    801065ee <printSleepList+0x72>
            if (current->next) {
801065a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065a8:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801065ae:	85 c0                	test   %eax,%eax
801065b0:	74 19                	je     801065cb <printSleepList+0x4f>
                cprintf("%d -> ", current->pid);
801065b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065b5:	8b 40 10             	mov    0x10(%eax),%eax
801065b8:	83 ec 08             	sub    $0x8,%esp
801065bb:	50                   	push   %eax
801065bc:	68 24 ad 10 80       	push   $0x8010ad24
801065c1:	e8 00 9e ff ff       	call   801003c6 <cprintf>
801065c6:	83 c4 10             	add    $0x10,%esp
801065c9:	eb 17                	jmp    801065e2 <printSleepList+0x66>
            } else {
                cprintf("%d", current->pid);
801065cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065ce:	8b 40 10             	mov    0x10(%eax),%eax
801065d1:	83 ec 08             	sub    $0x8,%esp
801065d4:	50                   	push   %eax
801065d5:	68 2b ad 10 80       	push   $0x8010ad2b
801065da:	e8 e7 9d ff ff       	call   801003c6 <cprintf>
801065df:	83 c4 10             	add    $0x10,%esp
            }
            current = current->next;
801065e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065e5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801065eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
printSleepList(void) {
    //acquire(&ptable.lock);
    if (ptable.pLists.sleep) {
        struct proc* current = ptable.pLists.sleep;
        cprintf("\nSleep List Processes:\n");
        while (current) {
801065ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801065f2:	75 b1                	jne    801065a5 <printSleepList+0x29>
            } else {
                cprintf("%d", current->pid);
            }
            current = current->next;
        }
        cprintf("\n");
801065f4:	83 ec 0c             	sub    $0xc,%esp
801065f7:	68 11 ac 10 80       	push   $0x8010ac11
801065fc:	e8 c5 9d ff ff       	call   801003c6 <cprintf>
80106601:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Sleep List.\n");
    }
    //release(&ptable.lock);
}
80106604:	eb 10                	jmp    80106616 <printSleepList+0x9a>
            current = current->next;
        }
        cprintf("\n");
    }
    else {
        cprintf("\nNo processes on Sleep List.\n");
80106606:	83 ec 0c             	sub    $0xc,%esp
80106609:	68 2e ad 10 80       	push   $0x8010ad2e
8010660e:	e8 b3 9d ff ff       	call   801003c6 <cprintf>
80106613:	83 c4 10             	add    $0x10,%esp
    }
    //release(&ptable.lock);
}
80106616:	90                   	nop
80106617:	c9                   	leave  
80106618:	c3                   	ret    

80106619 <printZombieList>:

// print PIDs & PPIDs of all procs in Zombie list
void
printZombieList(void) {
80106619:	55                   	push   %ebp
8010661a:	89 e5                	mov    %esp,%ebp
8010661c:	83 ec 18             	sub    $0x18,%esp
    if (ptable.pLists.zombie) {
8010661f:	a1 e8 80 11 80       	mov    0x801180e8,%eax
80106624:	85 c0                	test   %eax,%eax
80106626:	0f 84 8f 00 00 00    	je     801066bb <printZombieList+0xa2>
        struct proc* current = ptable.pLists.zombie;
8010662c:	a1 e8 80 11 80       	mov    0x801180e8,%eax
80106631:	89 45 f4             	mov    %eax,-0xc(%ebp)
        cprintf("\nZombie List Processes:\n");
80106634:	83 ec 0c             	sub    $0xc,%esp
80106637:	68 4c ad 10 80       	push   $0x8010ad4c
8010663c:	e8 85 9d ff ff       	call   801003c6 <cprintf>
80106641:	83 c4 10             	add    $0x10,%esp
        while (current) {
80106644:	eb 5d                	jmp    801066a3 <printZombieList+0x8a>
            if (current->next) {
80106646:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106649:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010664f:	85 c0                	test   %eax,%eax
80106651:	74 23                	je     80106676 <printZombieList+0x5d>
                cprintf("(%d, %d) -> ", current->pid, current->parent->pid);
80106653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106656:	8b 40 14             	mov    0x14(%eax),%eax
80106659:	8b 50 10             	mov    0x10(%eax),%edx
8010665c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010665f:	8b 40 10             	mov    0x10(%eax),%eax
80106662:	83 ec 04             	sub    $0x4,%esp
80106665:	52                   	push   %edx
80106666:	50                   	push   %eax
80106667:	68 ad ac 10 80       	push   $0x8010acad
8010666c:	e8 55 9d ff ff       	call   801003c6 <cprintf>
80106671:	83 c4 10             	add    $0x10,%esp
80106674:	eb 21                	jmp    80106697 <printZombieList+0x7e>
            } else {
                cprintf("(%d, %d)", current->pid, current->parent->pid);
80106676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106679:	8b 40 14             	mov    0x14(%eax),%eax
8010667c:	8b 50 10             	mov    0x10(%eax),%edx
8010667f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106682:	8b 40 10             	mov    0x10(%eax),%eax
80106685:	83 ec 04             	sub    $0x4,%esp
80106688:	52                   	push   %edx
80106689:	50                   	push   %eax
8010668a:	68 ba ac 10 80       	push   $0x8010acba
8010668f:	e8 32 9d ff ff       	call   801003c6 <cprintf>
80106694:	83 c4 10             	add    $0x10,%esp
            }
            current = current->next;
80106697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010669a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801066a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
printZombieList(void) {
    if (ptable.pLists.zombie) {
        struct proc* current = ptable.pLists.zombie;
        cprintf("\nZombie List Processes:\n");
        while (current) {
801066a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801066a7:	75 9d                	jne    80106646 <printZombieList+0x2d>
            } else {
                cprintf("(%d, %d)", current->pid, current->parent->pid);
            }
            current = current->next;
        }
        cprintf("\n");
801066a9:	83 ec 0c             	sub    $0xc,%esp
801066ac:	68 11 ac 10 80       	push   $0x8010ac11
801066b1:	e8 10 9d ff ff       	call   801003c6 <cprintf>
801066b6:	83 c4 10             	add    $0x10,%esp
    }
    else {
        cprintf("\nNo processes on Zombie List.\n");
    }
}
801066b9:	eb 10                	jmp    801066cb <printZombieList+0xb2>
            current = current->next;
        }
        cprintf("\n");
    }
    else {
        cprintf("\nNo processes on Zombie List.\n");
801066bb:	83 ec 0c             	sub    $0xc,%esp
801066be:	68 68 ad 10 80       	push   $0x8010ad68
801066c3:	e8 fe 9c ff ff       	call   801003c6 <cprintf>
801066c8:	83 c4 10             	add    $0x10,%esp
    }
}
801066cb:	90                   	nop
801066cc:	c9                   	leave  
801066cd:	c3                   	ret    

801066ce <promoteAll>:
// upwards to lowest priority queue

// Promote all ACTIVE(RUNNING, RUNNABLE, SLEEPING) processes one priority level
// this is only called in scheduler(), which holds &ptable.lock
static void
promoteAll(void) {
801066ce:	55                   	push   %ebp
801066cf:	89 e5                	mov    %esp,%ebp
801066d1:	83 ec 18             	sub    $0x18,%esp
    struct proc* p; // main ptr
    struct proc* current; // 2nd ptr needed for traversal + list management
    for (int i = 1; i <= MAX; ++i) {
801066d4:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
801066db:	e9 ff 00 00 00       	jmp    801067df <promoteAll+0x111>
        // traverse ready list array
        if (ptable.pLists.ready[i]) {
801066e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801066e3:	05 cc 09 00 00       	add    $0x9cc,%eax
801066e8:	8b 04 85 a4 59 11 80 	mov    -0x7feea65c(,%eax,4),%eax
801066ef:	85 c0                	test   %eax,%eax
801066f1:	0f 84 e4 00 00 00    	je     801067db <promoteAll+0x10d>
            current = ptable.pLists.ready[i]; // initialize
801066f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801066fa:	05 cc 09 00 00       	add    $0x9cc,%eax
801066ff:	8b 04 85 a4 59 11 80 	mov    -0x7feea65c(,%eax,4),%eax
80106706:	89 45 f0             	mov    %eax,-0x10(%ebp)
            p = 0;
80106709:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            while (current) {
80106710:	e9 bc 00 00 00       	jmp    801067d1 <promoteAll+0x103>
                p = current; // p is the current process to adjust
80106715:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106718:	89 45 f4             	mov    %eax,-0xc(%ebp)
                current = current->next; // current traverses one ahead
8010671b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010671e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106724:	89 45 f0             	mov    %eax,-0x10(%ebp)
                assertState(p, RUNNABLE); // assert state, we need to swap ready lists
80106727:	83 ec 08             	sub    $0x8,%esp
8010672a:	6a 03                	push   $0x3
8010672c:	ff 75 f4             	pushl  -0xc(%ebp)
8010672f:	e8 96 fa ff ff       	call   801061ca <assertState>
80106734:	83 c4 10             	add    $0x10,%esp
                if (removeFromStateList(&ptable.pLists.ready[p->priority], p) < 0) {
80106737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010673a:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106740:	05 cc 09 00 00       	add    $0x9cc,%eax
80106745:	c1 e0 02             	shl    $0x2,%eax
80106748:	05 a0 59 11 80       	add    $0x801159a0,%eax
8010674d:	83 c0 04             	add    $0x4,%eax
80106750:	83 ec 08             	sub    $0x8,%esp
80106753:	ff 75 f4             	pushl  -0xc(%ebp)
80106756:	50                   	push   %eax
80106757:	e8 8f fb ff ff       	call   801062eb <removeFromStateList>
8010675c:	83 c4 10             	add    $0x10,%esp
8010675f:	85 c0                	test   %eax,%eax
80106761:	79 10                	jns    80106773 <promoteAll+0xa5>
                    cprintf("promoteAll: Could not remove from ready list.\n");
80106763:	83 ec 0c             	sub    $0xc,%esp
80106766:	68 88 ad 10 80       	push   $0x8010ad88
8010676b:	e8 56 9c ff ff       	call   801003c6 <cprintf>
80106770:	83 c4 10             	add    $0x10,%esp
                } // take off lower priority (whatever one it is)
                if (p->priority > 0) {
80106773:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106776:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010677c:	85 c0                	test   %eax,%eax
8010677e:	74 15                	je     80106795 <promoteAll+0xc7>
                    --(p->priority); // adjust upward (toward zero)
80106780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106783:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106789:	8d 50 ff             	lea    -0x1(%eax),%edx
8010678c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010678f:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
                } // add to higher priority list
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
80106795:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106798:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010679e:	05 cc 09 00 00       	add    $0x9cc,%eax
801067a3:	c1 e0 02             	shl    $0x2,%eax
801067a6:	05 a0 59 11 80       	add    $0x801159a0,%eax
801067ab:	83 c0 04             	add    $0x4,%eax
801067ae:	83 ec 08             	sub    $0x8,%esp
801067b1:	ff 75 f4             	pushl  -0xc(%ebp)
801067b4:	50                   	push   %eax
801067b5:	e8 b0 fa ff ff       	call   8010626a <addToStateListEnd>
801067ba:	83 c4 10             	add    $0x10,%esp
801067bd:	85 c0                	test   %eax,%eax
801067bf:	79 10                	jns    801067d1 <promoteAll+0x103>
                    cprintf("promoteAll: Could not add to ready list.\n");
801067c1:	83 ec 0c             	sub    $0xc,%esp
801067c4:	68 b8 ad 10 80       	push   $0x8010adb8
801067c9:	e8 f8 9b ff ff       	call   801003c6 <cprintf>
801067ce:	83 c4 10             	add    $0x10,%esp
    for (int i = 1; i <= MAX; ++i) {
        // traverse ready list array
        if (ptable.pLists.ready[i]) {
            current = ptable.pLists.ready[i]; // initialize
            p = 0;
            while (current) {
801067d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801067d5:	0f 85 3a ff ff ff    	jne    80106715 <promoteAll+0x47>
// this is only called in scheduler(), which holds &ptable.lock
static void
promoteAll(void) {
    struct proc* p; // main ptr
    struct proc* current; // 2nd ptr needed for traversal + list management
    for (int i = 1; i <= MAX; ++i) {
801067db:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801067df:	83 7d ec 02          	cmpl   $0x2,-0x14(%ebp)
801067e3:	0f 8e f7 fe ff ff    	jle    801066e0 <promoteAll+0x12>
                }
            }
        }
    }
    // promote all SLEEPING processes
    if (ptable.pLists.sleep) {
801067e9:	a1 e4 80 11 80       	mov    0x801180e4,%eax
801067ee:	85 c0                	test   %eax,%eax
801067f0:	74 3e                	je     80106830 <promoteAll+0x162>
        p = ptable.pLists.sleep;
801067f2:	a1 e4 80 11 80       	mov    0x801180e4,%eax
801067f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
801067fa:	eb 2e                	jmp    8010682a <promoteAll+0x15c>
            if (p->priority > 0) {
801067fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ff:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106805:	85 c0                	test   %eax,%eax
80106807:	74 15                	je     8010681e <promoteAll+0x150>
                --(p->priority); // promote process
80106809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010680c:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106812:	8d 50 ff             	lea    -0x1(%eax),%edx
80106815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106818:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            }
            p = p->next;
8010681e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106821:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106827:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
    }
    // promote all SLEEPING processes
    if (ptable.pLists.sleep) {
        p = ptable.pLists.sleep;
        while (p) {
8010682a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010682e:	75 cc                	jne    801067fc <promoteAll+0x12e>
            }
            p = p->next;
        }
    }
    // promote all RUNNING processes
    if (ptable.pLists.running) {
80106830:	a1 ec 80 11 80       	mov    0x801180ec,%eax
80106835:	85 c0                	test   %eax,%eax
80106837:	74 3e                	je     80106877 <promoteAll+0x1a9>
        p = ptable.pLists.running;
80106839:	a1 ec 80 11 80       	mov    0x801180ec,%eax
8010683e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
80106841:	eb 2e                	jmp    80106871 <promoteAll+0x1a3>
            if (p->priority > 0) {
80106843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106846:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010684c:	85 c0                	test   %eax,%eax
8010684e:	74 15                	je     80106865 <promoteAll+0x197>
                --(p->priority); // promote process
80106850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106853:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80106859:	8d 50 ff             	lea    -0x1(%eax),%edx
8010685c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010685f:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            }
            p = p->next;
80106865:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106868:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010686e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
    }
    // promote all RUNNING processes
    if (ptable.pLists.running) {
        p = ptable.pLists.running;
        while (p) {
80106871:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106875:	75 cc                	jne    80106843 <promoteAll+0x175>
            }
            p = p->next;
        }
    }
    // nothing to return, just promote anything if they are there
}
80106877:	90                   	nop
80106878:	c9                   	leave  
80106879:	c3                   	ret    

8010687a <setpriority>:
// set priority system call
// bounds enforced in sysproc.c (kernel-side)
// active processes: RUNNABLE, RUNNING, SLEEPING
int
setpriority(int pid, int priority) {
8010687a:	55                   	push   %ebp
8010687b:	89 e5                	mov    %esp,%ebp
8010687d:	83 ec 18             	sub    $0x18,%esp
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
80106880:	83 ec 0c             	sub    $0xc,%esp
80106883:	68 a0 59 11 80       	push   $0x801159a0
80106888:	e8 40 02 00 00       	call   80106acd <acquire>
8010688d:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i <= MAX; ++i) {
80106890:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80106897:	e9 01 01 00 00       	jmp    8010699d <setpriority+0x123>
        p = ptable.pLists.ready[i]; // traverse ready list array
8010689c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010689f:	05 cc 09 00 00       	add    $0x9cc,%eax
801068a4:	8b 04 85 a4 59 11 80 	mov    -0x7feea65c(,%eax,4),%eax
801068ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while (p) {
801068ae:	e9 dc 00 00 00       	jmp    8010698f <setpriority+0x115>
            // match PIDs and only if the new priority value changes anything
            if (p->pid == pid) {
801068b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068b6:	8b 50 10             	mov    0x10(%eax),%edx
801068b9:	8b 45 08             	mov    0x8(%ebp),%eax
801068bc:	39 c2                	cmp    %eax,%edx
801068be:	0f 85 bf 00 00 00    	jne    80106983 <setpriority+0x109>
                if (removeFromStateList(&ptable.pLists.ready[p->priority], p) < 0) {
801068c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068c7:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801068cd:	05 cc 09 00 00       	add    $0x9cc,%eax
801068d2:	c1 e0 02             	shl    $0x2,%eax
801068d5:	05 a0 59 11 80       	add    $0x801159a0,%eax
801068da:	83 c0 04             	add    $0x4,%eax
801068dd:	83 ec 08             	sub    $0x8,%esp
801068e0:	ff 75 f4             	pushl  -0xc(%ebp)
801068e3:	50                   	push   %eax
801068e4:	e8 02 fa ff ff       	call   801062eb <removeFromStateList>
801068e9:	83 c4 10             	add    $0x10,%esp
801068ec:	85 c0                	test   %eax,%eax
801068ee:	79 1a                	jns    8010690a <setpriority+0x90>
                    cprintf("setpriority: remove from ready list[%d] failed.\n", p->priority);
801068f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068f3:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801068f9:	83 ec 08             	sub    $0x8,%esp
801068fc:	50                   	push   %eax
801068fd:	68 e4 ad 10 80       	push   $0x8010ade4
80106902:	e8 bf 9a ff ff       	call   801003c6 <cprintf>
80106907:	83 c4 10             	add    $0x10,%esp
                }// remove from old ready list
                p->priority = priority; // set priority
8010690a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010690d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106910:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
                if (addToStateListEnd(&ptable.pLists.ready[p->priority], p) < 0) {
80106916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106919:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010691f:	05 cc 09 00 00       	add    $0x9cc,%eax
80106924:	c1 e0 02             	shl    $0x2,%eax
80106927:	05 a0 59 11 80       	add    $0x801159a0,%eax
8010692c:	83 c0 04             	add    $0x4,%eax
8010692f:	83 ec 08             	sub    $0x8,%esp
80106932:	ff 75 f4             	pushl  -0xc(%ebp)
80106935:	50                   	push   %eax
80106936:	e8 2f f9 ff ff       	call   8010626a <addToStateListEnd>
8010693b:	83 c4 10             	add    $0x10,%esp
8010693e:	85 c0                	test   %eax,%eax
80106940:	79 1a                	jns    8010695c <setpriority+0xe2>
                    cprintf("setpriority: add to ready list[%d] failed.\n", p->priority);
80106942:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106945:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010694b:	83 ec 08             	sub    $0x8,%esp
8010694e:	50                   	push   %eax
8010694f:	68 18 ae 10 80       	push   $0x8010ae18
80106954:	e8 6d 9a ff ff       	call   801003c6 <cprintf>
80106959:	83 c4 10             	add    $0x10,%esp
                } //  add to new ready list
                p->budget = BUDGET; // reset budget
8010695c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010695f:	c7 80 98 00 00 00 78 	movl   $0x78,0x98(%eax)
80106966:	00 00 00 
                //cprintf("setPriority: ready list priority set.\n");
                release(&ptable.lock); // release lock
80106969:	83 ec 0c             	sub    $0xc,%esp
8010696c:	68 a0 59 11 80       	push   $0x801159a0
80106971:	e8 be 01 00 00       	call   80106b34 <release>
80106976:	83 c4 10             	add    $0x10,%esp
                return 0; // return success
80106979:	b8 00 00 00 00       	mov    $0x0,%eax
8010697e:	e9 ee 00 00 00       	jmp    80106a71 <setpriority+0x1f7>
            }
            p = p->next;
80106983:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106986:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010698c:	89 45 f4             	mov    %eax,-0xc(%ebp)
setpriority(int pid, int priority) {
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
    for (int i = 0; i <= MAX; ++i) {
        p = ptable.pLists.ready[i]; // traverse ready list array
        while (p) {
8010698f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106993:	0f 85 1a ff ff ff    	jne    801068b3 <setpriority+0x39>
// active processes: RUNNABLE, RUNNING, SLEEPING
int
setpriority(int pid, int priority) {
    struct proc* p;
    acquire(&ptable.lock); // maintain atomicity
    for (int i = 0; i <= MAX; ++i) {
80106999:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010699d:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
801069a1:	0f 8e f5 fe ff ff    	jle    8010689c <setpriority+0x22>
                return 0; // return success
            }
            p = p->next;
        }
    }
    p = ptable.pLists.running; // repeat process if PID not found in ready lists
801069a7:	a1 ec 80 11 80       	mov    0x801180ec,%eax
801069ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801069af:	eb 4c                	jmp    801069fd <setpriority+0x183>
        if (p->pid == pid) {
801069b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069b4:	8b 50 10             	mov    0x10(%eax),%edx
801069b7:	8b 45 08             	mov    0x8(%ebp),%eax
801069ba:	39 c2                	cmp    %eax,%edx
801069bc:	75 33                	jne    801069f1 <setpriority+0x177>
            p->priority = priority;
801069be:	8b 55 0c             	mov    0xc(%ebp),%edx
801069c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069c4:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            p->budget = BUDGET;
801069ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069cd:	c7 80 98 00 00 00 78 	movl   $0x78,0x98(%eax)
801069d4:	00 00 00 
            //cprintf("setPriority: running list priority set.\n");
            release(&ptable.lock);
801069d7:	83 ec 0c             	sub    $0xc,%esp
801069da:	68 a0 59 11 80       	push   $0x801159a0
801069df:	e8 50 01 00 00       	call   80106b34 <release>
801069e4:	83 c4 10             	add    $0x10,%esp
            return 0; // return success
801069e7:	b8 00 00 00 00       	mov    $0x0,%eax
801069ec:	e9 80 00 00 00       	jmp    80106a71 <setpriority+0x1f7>
        }
        p = p->next;
801069f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069f4:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801069fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
            }
            p = p->next;
        }
    }
    p = ptable.pLists.running; // repeat process if PID not found in ready lists
    while (p) {
801069fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a01:	75 ae                	jne    801069b1 <setpriority+0x137>
            release(&ptable.lock);
            return 0; // return success
        }
        p = p->next;
    }
    p = ptable.pLists.sleep; // continue search in sleep list
80106a03:	a1 e4 80 11 80       	mov    0x801180e4,%eax
80106a08:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
80106a0b:	eb 49                	jmp    80106a56 <setpriority+0x1dc>
        if (p->pid == pid) {
80106a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a10:	8b 50 10             	mov    0x10(%eax),%edx
80106a13:	8b 45 08             	mov    0x8(%ebp),%eax
80106a16:	39 c2                	cmp    %eax,%edx
80106a18:	75 30                	jne    80106a4a <setpriority+0x1d0>
            p->priority = priority;
80106a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a20:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
            p->budget = BUDGET;
80106a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a29:	c7 80 98 00 00 00 78 	movl   $0x78,0x98(%eax)
80106a30:	00 00 00 
            //cprintf("setPriority: sleep list priority set.\n");
            release(&ptable.lock);
80106a33:	83 ec 0c             	sub    $0xc,%esp
80106a36:	68 a0 59 11 80       	push   $0x801159a0
80106a3b:	e8 f4 00 00 00       	call   80106b34 <release>
80106a40:	83 c4 10             	add    $0x10,%esp
            return 0; //  return success
80106a43:	b8 00 00 00 00       	mov    $0x0,%eax
80106a48:	eb 27                	jmp    80106a71 <setpriority+0x1f7>
        }
        p = p->next;
80106a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a4d:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
            return 0; // return success
        }
        p = p->next;
    }
    p = ptable.pLists.sleep; // continue search in sleep list
    while (p) {
80106a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106a5a:	75 b1                	jne    80106a0d <setpriority+0x193>
            return 0; //  return success
        }
        p = p->next;
    }
    //cprintf("setPriority: No priority set.\n");
    release(&ptable.lock);
80106a5c:	83 ec 0c             	sub    $0xc,%esp
80106a5f:	68 a0 59 11 80       	push   $0x801159a0
80106a64:	e8 cb 00 00 00       	call   80106b34 <release>
80106a69:	83 c4 10             	add    $0x10,%esp
    return -1; // return error if no PID match is found
80106a6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a71:	c9                   	leave  
80106a72:	c3                   	ret    

80106a73 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80106a73:	55                   	push   %ebp
80106a74:	89 e5                	mov    %esp,%ebp
80106a76:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106a79:	9c                   	pushf  
80106a7a:	58                   	pop    %eax
80106a7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80106a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106a81:	c9                   	leave  
80106a82:	c3                   	ret    

80106a83 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80106a83:	55                   	push   %ebp
80106a84:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80106a86:	fa                   	cli    
}
80106a87:	90                   	nop
80106a88:	5d                   	pop    %ebp
80106a89:	c3                   	ret    

80106a8a <sti>:

static inline void
sti(void)
{
80106a8a:	55                   	push   %ebp
80106a8b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80106a8d:	fb                   	sti    
}
80106a8e:	90                   	nop
80106a8f:	5d                   	pop    %ebp
80106a90:	c3                   	ret    

80106a91 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80106a91:	55                   	push   %ebp
80106a92:	89 e5                	mov    %esp,%ebp
80106a94:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80106a97:	8b 55 08             	mov    0x8(%ebp),%edx
80106a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106a9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106aa0:	f0 87 02             	lock xchg %eax,(%edx)
80106aa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80106aa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106aa9:	c9                   	leave  
80106aaa:	c3                   	ret    

80106aab <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106aab:	55                   	push   %ebp
80106aac:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80106aae:	8b 45 08             	mov    0x8(%ebp),%eax
80106ab1:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ab4:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80106ab7:	8b 45 08             	mov    0x8(%ebp),%eax
80106aba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80106ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ac3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106aca:	90                   	nop
80106acb:	5d                   	pop    %ebp
80106acc:	c3                   	ret    

80106acd <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80106acd:	55                   	push   %ebp
80106ace:	89 e5                	mov    %esp,%ebp
80106ad0:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80106ad3:	e8 52 01 00 00       	call   80106c2a <pushcli>
  if(holding(lk))
80106ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80106adb:	83 ec 0c             	sub    $0xc,%esp
80106ade:	50                   	push   %eax
80106adf:	e8 1c 01 00 00       	call   80106c00 <holding>
80106ae4:	83 c4 10             	add    $0x10,%esp
80106ae7:	85 c0                	test   %eax,%eax
80106ae9:	74 0d                	je     80106af8 <acquire+0x2b>
    panic("acquire");
80106aeb:	83 ec 0c             	sub    $0xc,%esp
80106aee:	68 44 ae 10 80       	push   $0x8010ae44
80106af3:	e8 6e 9a ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80106af8:	90                   	nop
80106af9:	8b 45 08             	mov    0x8(%ebp),%eax
80106afc:	83 ec 08             	sub    $0x8,%esp
80106aff:	6a 01                	push   $0x1
80106b01:	50                   	push   %eax
80106b02:	e8 8a ff ff ff       	call   80106a91 <xchg>
80106b07:	83 c4 10             	add    $0x10,%esp
80106b0a:	85 c0                	test   %eax,%eax
80106b0c:	75 eb                	jne    80106af9 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80106b0e:	8b 45 08             	mov    0x8(%ebp),%eax
80106b11:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106b18:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80106b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b1e:	83 c0 0c             	add    $0xc,%eax
80106b21:	83 ec 08             	sub    $0x8,%esp
80106b24:	50                   	push   %eax
80106b25:	8d 45 08             	lea    0x8(%ebp),%eax
80106b28:	50                   	push   %eax
80106b29:	e8 58 00 00 00       	call   80106b86 <getcallerpcs>
80106b2e:	83 c4 10             	add    $0x10,%esp
}
80106b31:	90                   	nop
80106b32:	c9                   	leave  
80106b33:	c3                   	ret    

80106b34 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80106b34:	55                   	push   %ebp
80106b35:	89 e5                	mov    %esp,%ebp
80106b37:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80106b3a:	83 ec 0c             	sub    $0xc,%esp
80106b3d:	ff 75 08             	pushl  0x8(%ebp)
80106b40:	e8 bb 00 00 00       	call   80106c00 <holding>
80106b45:	83 c4 10             	add    $0x10,%esp
80106b48:	85 c0                	test   %eax,%eax
80106b4a:	75 0d                	jne    80106b59 <release+0x25>
    panic("release");
80106b4c:	83 ec 0c             	sub    $0xc,%esp
80106b4f:	68 4c ae 10 80       	push   $0x8010ae4c
80106b54:	e8 0d 9a ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80106b59:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80106b63:	8b 45 08             	mov    0x8(%ebp),%eax
80106b66:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80106b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80106b70:	83 ec 08             	sub    $0x8,%esp
80106b73:	6a 00                	push   $0x0
80106b75:	50                   	push   %eax
80106b76:	e8 16 ff ff ff       	call   80106a91 <xchg>
80106b7b:	83 c4 10             	add    $0x10,%esp

  popcli();
80106b7e:	e8 ec 00 00 00       	call   80106c6f <popcli>
}
80106b83:	90                   	nop
80106b84:	c9                   	leave  
80106b85:	c3                   	ret    

80106b86 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106b86:	55                   	push   %ebp
80106b87:	89 e5                	mov    %esp,%ebp
80106b89:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80106b8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b8f:	83 e8 08             	sub    $0x8,%eax
80106b92:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80106b95:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80106b9c:	eb 38                	jmp    80106bd6 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106b9e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106ba2:	74 53                	je     80106bf7 <getcallerpcs+0x71>
80106ba4:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80106bab:	76 4a                	jbe    80106bf7 <getcallerpcs+0x71>
80106bad:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80106bb1:	74 44                	je     80106bf7 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
80106bb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bb6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bc0:	01 c2                	add    %eax,%edx
80106bc2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bc5:	8b 40 04             	mov    0x4(%eax),%eax
80106bc8:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80106bca:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bcd:	8b 00                	mov    (%eax),%eax
80106bcf:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106bd2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106bd6:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106bda:	7e c2                	jle    80106b9e <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106bdc:	eb 19                	jmp    80106bf7 <getcallerpcs+0x71>
    pcs[i] = 0;
80106bde:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106be1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106be8:	8b 45 0c             	mov    0xc(%ebp),%eax
80106beb:	01 d0                	add    %edx,%eax
80106bed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106bf3:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106bf7:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106bfb:	7e e1                	jle    80106bde <getcallerpcs+0x58>
    pcs[i] = 0;
}
80106bfd:	90                   	nop
80106bfe:	c9                   	leave  
80106bff:	c3                   	ret    

80106c00 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106c03:	8b 45 08             	mov    0x8(%ebp),%eax
80106c06:	8b 00                	mov    (%eax),%eax
80106c08:	85 c0                	test   %eax,%eax
80106c0a:	74 17                	je     80106c23 <holding+0x23>
80106c0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c0f:	8b 50 08             	mov    0x8(%eax),%edx
80106c12:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106c18:	39 c2                	cmp    %eax,%edx
80106c1a:	75 07                	jne    80106c23 <holding+0x23>
80106c1c:	b8 01 00 00 00       	mov    $0x1,%eax
80106c21:	eb 05                	jmp    80106c28 <holding+0x28>
80106c23:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c28:	5d                   	pop    %ebp
80106c29:	c3                   	ret    

80106c2a <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80106c2a:	55                   	push   %ebp
80106c2b:	89 e5                	mov    %esp,%ebp
80106c2d:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80106c30:	e8 3e fe ff ff       	call   80106a73 <readeflags>
80106c35:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80106c38:	e8 46 fe ff ff       	call   80106a83 <cli>
  if(cpu->ncli++ == 0)
80106c3d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106c44:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80106c4a:	8d 48 01             	lea    0x1(%eax),%ecx
80106c4d:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80106c53:	85 c0                	test   %eax,%eax
80106c55:	75 15                	jne    80106c6c <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80106c57:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106c5d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c60:	81 e2 00 02 00 00    	and    $0x200,%edx
80106c66:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80106c6c:	90                   	nop
80106c6d:	c9                   	leave  
80106c6e:	c3                   	ret    

80106c6f <popcli>:

void
popcli(void)
{
80106c6f:	55                   	push   %ebp
80106c70:	89 e5                	mov    %esp,%ebp
80106c72:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80106c75:	e8 f9 fd ff ff       	call   80106a73 <readeflags>
80106c7a:	25 00 02 00 00       	and    $0x200,%eax
80106c7f:	85 c0                	test   %eax,%eax
80106c81:	74 0d                	je     80106c90 <popcli+0x21>
    panic("popcli - interruptible");
80106c83:	83 ec 0c             	sub    $0xc,%esp
80106c86:	68 54 ae 10 80       	push   $0x8010ae54
80106c8b:	e8 d6 98 ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106c90:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106c96:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106c9c:	83 ea 01             	sub    $0x1,%edx
80106c9f:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106ca5:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106cab:	85 c0                	test   %eax,%eax
80106cad:	79 0d                	jns    80106cbc <popcli+0x4d>
    panic("popcli");
80106caf:	83 ec 0c             	sub    $0xc,%esp
80106cb2:	68 6b ae 10 80       	push   $0x8010ae6b
80106cb7:	e8 aa 98 ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106cbc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106cc2:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106cc8:	85 c0                	test   %eax,%eax
80106cca:	75 15                	jne    80106ce1 <popcli+0x72>
80106ccc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106cd2:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106cd8:	85 c0                	test   %eax,%eax
80106cda:	74 05                	je     80106ce1 <popcli+0x72>
    sti();
80106cdc:	e8 a9 fd ff ff       	call   80106a8a <sti>
}
80106ce1:	90                   	nop
80106ce2:	c9                   	leave  
80106ce3:	c3                   	ret    

80106ce4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106ce4:	55                   	push   %ebp
80106ce5:	89 e5                	mov    %esp,%ebp
80106ce7:	57                   	push   %edi
80106ce8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106ce9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106cec:	8b 55 10             	mov    0x10(%ebp),%edx
80106cef:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cf2:	89 cb                	mov    %ecx,%ebx
80106cf4:	89 df                	mov    %ebx,%edi
80106cf6:	89 d1                	mov    %edx,%ecx
80106cf8:	fc                   	cld    
80106cf9:	f3 aa                	rep stos %al,%es:(%edi)
80106cfb:	89 ca                	mov    %ecx,%edx
80106cfd:	89 fb                	mov    %edi,%ebx
80106cff:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106d02:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106d05:	90                   	nop
80106d06:	5b                   	pop    %ebx
80106d07:	5f                   	pop    %edi
80106d08:	5d                   	pop    %ebp
80106d09:	c3                   	ret    

80106d0a <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106d0a:	55                   	push   %ebp
80106d0b:	89 e5                	mov    %esp,%ebp
80106d0d:	57                   	push   %edi
80106d0e:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106d0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106d12:	8b 55 10             	mov    0x10(%ebp),%edx
80106d15:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d18:	89 cb                	mov    %ecx,%ebx
80106d1a:	89 df                	mov    %ebx,%edi
80106d1c:	89 d1                	mov    %edx,%ecx
80106d1e:	fc                   	cld    
80106d1f:	f3 ab                	rep stos %eax,%es:(%edi)
80106d21:	89 ca                	mov    %ecx,%edx
80106d23:	89 fb                	mov    %edi,%ebx
80106d25:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106d28:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106d2b:	90                   	nop
80106d2c:	5b                   	pop    %ebx
80106d2d:	5f                   	pop    %edi
80106d2e:	5d                   	pop    %ebp
80106d2f:	c3                   	ret    

80106d30 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106d33:	8b 45 08             	mov    0x8(%ebp),%eax
80106d36:	83 e0 03             	and    $0x3,%eax
80106d39:	85 c0                	test   %eax,%eax
80106d3b:	75 43                	jne    80106d80 <memset+0x50>
80106d3d:	8b 45 10             	mov    0x10(%ebp),%eax
80106d40:	83 e0 03             	and    $0x3,%eax
80106d43:	85 c0                	test   %eax,%eax
80106d45:	75 39                	jne    80106d80 <memset+0x50>
    c &= 0xFF;
80106d47:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106d4e:	8b 45 10             	mov    0x10(%ebp),%eax
80106d51:	c1 e8 02             	shr    $0x2,%eax
80106d54:	89 c1                	mov    %eax,%ecx
80106d56:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d59:	c1 e0 18             	shl    $0x18,%eax
80106d5c:	89 c2                	mov    %eax,%edx
80106d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d61:	c1 e0 10             	shl    $0x10,%eax
80106d64:	09 c2                	or     %eax,%edx
80106d66:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d69:	c1 e0 08             	shl    $0x8,%eax
80106d6c:	09 d0                	or     %edx,%eax
80106d6e:	0b 45 0c             	or     0xc(%ebp),%eax
80106d71:	51                   	push   %ecx
80106d72:	50                   	push   %eax
80106d73:	ff 75 08             	pushl  0x8(%ebp)
80106d76:	e8 8f ff ff ff       	call   80106d0a <stosl>
80106d7b:	83 c4 0c             	add    $0xc,%esp
80106d7e:	eb 12                	jmp    80106d92 <memset+0x62>
  } else
    stosb(dst, c, n);
80106d80:	8b 45 10             	mov    0x10(%ebp),%eax
80106d83:	50                   	push   %eax
80106d84:	ff 75 0c             	pushl  0xc(%ebp)
80106d87:	ff 75 08             	pushl  0x8(%ebp)
80106d8a:	e8 55 ff ff ff       	call   80106ce4 <stosb>
80106d8f:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106d92:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106d95:	c9                   	leave  
80106d96:	c3                   	ret    

80106d97 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106d97:	55                   	push   %ebp
80106d98:	89 e5                	mov    %esp,%ebp
80106d9a:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106d9d:	8b 45 08             	mov    0x8(%ebp),%eax
80106da0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106da3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106da6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106da9:	eb 30                	jmp    80106ddb <memcmp+0x44>
    if(*s1 != *s2)
80106dab:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106dae:	0f b6 10             	movzbl (%eax),%edx
80106db1:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106db4:	0f b6 00             	movzbl (%eax),%eax
80106db7:	38 c2                	cmp    %al,%dl
80106db9:	74 18                	je     80106dd3 <memcmp+0x3c>
      return *s1 - *s2;
80106dbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106dbe:	0f b6 00             	movzbl (%eax),%eax
80106dc1:	0f b6 d0             	movzbl %al,%edx
80106dc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106dc7:	0f b6 00             	movzbl (%eax),%eax
80106dca:	0f b6 c0             	movzbl %al,%eax
80106dcd:	29 c2                	sub    %eax,%edx
80106dcf:	89 d0                	mov    %edx,%eax
80106dd1:	eb 1a                	jmp    80106ded <memcmp+0x56>
    s1++, s2++;
80106dd3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106dd7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106ddb:	8b 45 10             	mov    0x10(%ebp),%eax
80106dde:	8d 50 ff             	lea    -0x1(%eax),%edx
80106de1:	89 55 10             	mov    %edx,0x10(%ebp)
80106de4:	85 c0                	test   %eax,%eax
80106de6:	75 c3                	jne    80106dab <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ded:	c9                   	leave  
80106dee:	c3                   	ret    

80106def <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106def:	55                   	push   %ebp
80106df0:	89 e5                	mov    %esp,%ebp
80106df2:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106df5:	8b 45 0c             	mov    0xc(%ebp),%eax
80106df8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106dfb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dfe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e04:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106e07:	73 54                	jae    80106e5d <memmove+0x6e>
80106e09:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e0c:	8b 45 10             	mov    0x10(%ebp),%eax
80106e0f:	01 d0                	add    %edx,%eax
80106e11:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106e14:	76 47                	jbe    80106e5d <memmove+0x6e>
    s += n;
80106e16:	8b 45 10             	mov    0x10(%ebp),%eax
80106e19:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106e1c:	8b 45 10             	mov    0x10(%ebp),%eax
80106e1f:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106e22:	eb 13                	jmp    80106e37 <memmove+0x48>
      *--d = *--s;
80106e24:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106e28:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e2f:	0f b6 10             	movzbl (%eax),%edx
80106e32:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106e35:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106e37:	8b 45 10             	mov    0x10(%ebp),%eax
80106e3a:	8d 50 ff             	lea    -0x1(%eax),%edx
80106e3d:	89 55 10             	mov    %edx,0x10(%ebp)
80106e40:	85 c0                	test   %eax,%eax
80106e42:	75 e0                	jne    80106e24 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106e44:	eb 24                	jmp    80106e6a <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106e46:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106e49:	8d 50 01             	lea    0x1(%eax),%edx
80106e4c:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106e4f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e52:	8d 4a 01             	lea    0x1(%edx),%ecx
80106e55:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80106e58:	0f b6 12             	movzbl (%edx),%edx
80106e5b:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106e5d:	8b 45 10             	mov    0x10(%ebp),%eax
80106e60:	8d 50 ff             	lea    -0x1(%eax),%edx
80106e63:	89 55 10             	mov    %edx,0x10(%ebp)
80106e66:	85 c0                	test   %eax,%eax
80106e68:	75 dc                	jne    80106e46 <memmove+0x57>
      *d++ = *s++;

  return dst;
80106e6a:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106e6d:	c9                   	leave  
80106e6e:	c3                   	ret    

80106e6f <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106e6f:	55                   	push   %ebp
80106e70:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106e72:	ff 75 10             	pushl  0x10(%ebp)
80106e75:	ff 75 0c             	pushl  0xc(%ebp)
80106e78:	ff 75 08             	pushl  0x8(%ebp)
80106e7b:	e8 6f ff ff ff       	call   80106def <memmove>
80106e80:	83 c4 0c             	add    $0xc,%esp
}
80106e83:	c9                   	leave  
80106e84:	c3                   	ret    

80106e85 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106e85:	55                   	push   %ebp
80106e86:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80106e88:	eb 0c                	jmp    80106e96 <strncmp+0x11>
    n--, p++, q++;
80106e8a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106e8e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106e92:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106e96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106e9a:	74 1a                	je     80106eb6 <strncmp+0x31>
80106e9c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e9f:	0f b6 00             	movzbl (%eax),%eax
80106ea2:	84 c0                	test   %al,%al
80106ea4:	74 10                	je     80106eb6 <strncmp+0x31>
80106ea6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ea9:	0f b6 10             	movzbl (%eax),%edx
80106eac:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eaf:	0f b6 00             	movzbl (%eax),%eax
80106eb2:	38 c2                	cmp    %al,%dl
80106eb4:	74 d4                	je     80106e8a <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106eb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106eba:	75 07                	jne    80106ec3 <strncmp+0x3e>
    return 0;
80106ebc:	b8 00 00 00 00       	mov    $0x0,%eax
80106ec1:	eb 16                	jmp    80106ed9 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80106ec6:	0f b6 00             	movzbl (%eax),%eax
80106ec9:	0f b6 d0             	movzbl %al,%edx
80106ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ecf:	0f b6 00             	movzbl (%eax),%eax
80106ed2:	0f b6 c0             	movzbl %al,%eax
80106ed5:	29 c2                	sub    %eax,%edx
80106ed7:	89 d0                	mov    %edx,%eax
}
80106ed9:	5d                   	pop    %ebp
80106eda:	c3                   	ret    

80106edb <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106edb:	55                   	push   %ebp
80106edc:	89 e5                	mov    %esp,%ebp
80106ede:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106ee1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106ee7:	90                   	nop
80106ee8:	8b 45 10             	mov    0x10(%ebp),%eax
80106eeb:	8d 50 ff             	lea    -0x1(%eax),%edx
80106eee:	89 55 10             	mov    %edx,0x10(%ebp)
80106ef1:	85 c0                	test   %eax,%eax
80106ef3:	7e 2c                	jle    80106f21 <strncpy+0x46>
80106ef5:	8b 45 08             	mov    0x8(%ebp),%eax
80106ef8:	8d 50 01             	lea    0x1(%eax),%edx
80106efb:	89 55 08             	mov    %edx,0x8(%ebp)
80106efe:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f01:	8d 4a 01             	lea    0x1(%edx),%ecx
80106f04:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106f07:	0f b6 12             	movzbl (%edx),%edx
80106f0a:	88 10                	mov    %dl,(%eax)
80106f0c:	0f b6 00             	movzbl (%eax),%eax
80106f0f:	84 c0                	test   %al,%al
80106f11:	75 d5                	jne    80106ee8 <strncpy+0xd>
    ;
  while(n-- > 0)
80106f13:	eb 0c                	jmp    80106f21 <strncpy+0x46>
    *s++ = 0;
80106f15:	8b 45 08             	mov    0x8(%ebp),%eax
80106f18:	8d 50 01             	lea    0x1(%eax),%edx
80106f1b:	89 55 08             	mov    %edx,0x8(%ebp)
80106f1e:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106f21:	8b 45 10             	mov    0x10(%ebp),%eax
80106f24:	8d 50 ff             	lea    -0x1(%eax),%edx
80106f27:	89 55 10             	mov    %edx,0x10(%ebp)
80106f2a:	85 c0                	test   %eax,%eax
80106f2c:	7f e7                	jg     80106f15 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106f31:	c9                   	leave  
80106f32:	c3                   	ret    

80106f33 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106f33:	55                   	push   %ebp
80106f34:	89 e5                	mov    %esp,%ebp
80106f36:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106f39:	8b 45 08             	mov    0x8(%ebp),%eax
80106f3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106f3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106f43:	7f 05                	jg     80106f4a <safestrcpy+0x17>
    return os;
80106f45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106f48:	eb 31                	jmp    80106f7b <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106f4a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106f4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106f52:	7e 1e                	jle    80106f72 <safestrcpy+0x3f>
80106f54:	8b 45 08             	mov    0x8(%ebp),%eax
80106f57:	8d 50 01             	lea    0x1(%eax),%edx
80106f5a:	89 55 08             	mov    %edx,0x8(%ebp)
80106f5d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f60:	8d 4a 01             	lea    0x1(%edx),%ecx
80106f63:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106f66:	0f b6 12             	movzbl (%edx),%edx
80106f69:	88 10                	mov    %dl,(%eax)
80106f6b:	0f b6 00             	movzbl (%eax),%eax
80106f6e:	84 c0                	test   %al,%al
80106f70:	75 d8                	jne    80106f4a <safestrcpy+0x17>
    ;
  *s = 0;
80106f72:	8b 45 08             	mov    0x8(%ebp),%eax
80106f75:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80106f78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106f7b:	c9                   	leave  
80106f7c:	c3                   	ret    

80106f7d <strlen>:

int
strlen(const char *s)
{
80106f7d:	55                   	push   %ebp
80106f7e:	89 e5                	mov    %esp,%ebp
80106f80:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106f83:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106f8a:	eb 04                	jmp    80106f90 <strlen+0x13>
80106f8c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106f90:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106f93:	8b 45 08             	mov    0x8(%ebp),%eax
80106f96:	01 d0                	add    %edx,%eax
80106f98:	0f b6 00             	movzbl (%eax),%eax
80106f9b:	84 c0                	test   %al,%al
80106f9d:	75 ed                	jne    80106f8c <strlen+0xf>
    ;
  return n;
80106f9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106fa2:	c9                   	leave  
80106fa3:	c3                   	ret    

80106fa4 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106fa4:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106fa8:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106fac:	55                   	push   %ebp
  pushl %ebx
80106fad:	53                   	push   %ebx
  pushl %esi
80106fae:	56                   	push   %esi
  pushl %edi
80106faf:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106fb0:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106fb2:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106fb4:	5f                   	pop    %edi
  popl %esi
80106fb5:	5e                   	pop    %esi
  popl %ebx
80106fb6:	5b                   	pop    %ebx
  popl %ebp
80106fb7:	5d                   	pop    %ebp
  ret
80106fb8:	c3                   	ret    

80106fb9 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106fb9:	55                   	push   %ebp
80106fba:	89 e5                	mov    %esp,%ebp
    if(addr >= proc->sz || addr+4 > proc->sz)
80106fbc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fc2:	8b 00                	mov    (%eax),%eax
80106fc4:	3b 45 08             	cmp    0x8(%ebp),%eax
80106fc7:	76 12                	jbe    80106fdb <fetchint+0x22>
80106fc9:	8b 45 08             	mov    0x8(%ebp),%eax
80106fcc:	8d 50 04             	lea    0x4(%eax),%edx
80106fcf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fd5:	8b 00                	mov    (%eax),%eax
80106fd7:	39 c2                	cmp    %eax,%edx
80106fd9:	76 07                	jbe    80106fe2 <fetchint+0x29>
        return -1;
80106fdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fe0:	eb 0f                	jmp    80106ff1 <fetchint+0x38>
    *ip = *(int*)(addr);
80106fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe5:	8b 10                	mov    (%eax),%edx
80106fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fea:	89 10                	mov    %edx,(%eax)
    return 0;
80106fec:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ff1:	5d                   	pop    %ebp
80106ff2:	c3                   	ret    

80106ff3 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106ff3:	55                   	push   %ebp
80106ff4:	89 e5                	mov    %esp,%ebp
80106ff6:	83 ec 10             	sub    $0x10,%esp
    char *s, *ep;

    if(addr >= proc->sz)
80106ff9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fff:	8b 00                	mov    (%eax),%eax
80107001:	3b 45 08             	cmp    0x8(%ebp),%eax
80107004:	77 07                	ja     8010700d <fetchstr+0x1a>
        return -1;
80107006:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010700b:	eb 46                	jmp    80107053 <fetchstr+0x60>
    *pp = (char*)addr;
8010700d:	8b 55 08             	mov    0x8(%ebp),%edx
80107010:	8b 45 0c             	mov    0xc(%ebp),%eax
80107013:	89 10                	mov    %edx,(%eax)
    ep = (char*)proc->sz;
80107015:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010701b:	8b 00                	mov    (%eax),%eax
8010701d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    for(s = *pp; s < ep; s++)
80107020:	8b 45 0c             	mov    0xc(%ebp),%eax
80107023:	8b 00                	mov    (%eax),%eax
80107025:	89 45 fc             	mov    %eax,-0x4(%ebp)
80107028:	eb 1c                	jmp    80107046 <fetchstr+0x53>
        if(*s == 0)
8010702a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010702d:	0f b6 00             	movzbl (%eax),%eax
80107030:	84 c0                	test   %al,%al
80107032:	75 0e                	jne    80107042 <fetchstr+0x4f>
            return s - *pp;
80107034:	8b 55 fc             	mov    -0x4(%ebp),%edx
80107037:	8b 45 0c             	mov    0xc(%ebp),%eax
8010703a:	8b 00                	mov    (%eax),%eax
8010703c:	29 c2                	sub    %eax,%edx
8010703e:	89 d0                	mov    %edx,%eax
80107040:	eb 11                	jmp    80107053 <fetchstr+0x60>

    if(addr >= proc->sz)
        return -1;
    *pp = (char*)addr;
    ep = (char*)proc->sz;
    for(s = *pp; s < ep; s++)
80107042:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107046:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107049:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010704c:	72 dc                	jb     8010702a <fetchstr+0x37>
        if(*s == 0)
            return s - *pp;
    return -1;
8010704e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107053:	c9                   	leave  
80107054:	c3                   	ret    

80107055 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80107055:	55                   	push   %ebp
80107056:	89 e5                	mov    %esp,%ebp
    return fetchint(proc->tf->esp + 4 + 4*n, ip);
80107058:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010705e:	8b 40 18             	mov    0x18(%eax),%eax
80107061:	8b 40 44             	mov    0x44(%eax),%eax
80107064:	8b 55 08             	mov    0x8(%ebp),%edx
80107067:	c1 e2 02             	shl    $0x2,%edx
8010706a:	01 d0                	add    %edx,%eax
8010706c:	83 c0 04             	add    $0x4,%eax
8010706f:	ff 75 0c             	pushl  0xc(%ebp)
80107072:	50                   	push   %eax
80107073:	e8 41 ff ff ff       	call   80106fb9 <fetchint>
80107078:	83 c4 08             	add    $0x8,%esp
}
8010707b:	c9                   	leave  
8010707c:	c3                   	ret    

8010707d <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010707d:	55                   	push   %ebp
8010707e:	89 e5                	mov    %esp,%ebp
80107080:	83 ec 10             	sub    $0x10,%esp
    int i;

    if(argint(n, &i) < 0)
80107083:	8d 45 fc             	lea    -0x4(%ebp),%eax
80107086:	50                   	push   %eax
80107087:	ff 75 08             	pushl  0x8(%ebp)
8010708a:	e8 c6 ff ff ff       	call   80107055 <argint>
8010708f:	83 c4 08             	add    $0x8,%esp
80107092:	85 c0                	test   %eax,%eax
80107094:	79 07                	jns    8010709d <argptr+0x20>
        return -1;
80107096:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010709b:	eb 3b                	jmp    801070d8 <argptr+0x5b>
    if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010709d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070a3:	8b 00                	mov    (%eax),%eax
801070a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
801070a8:	39 d0                	cmp    %edx,%eax
801070aa:	76 16                	jbe    801070c2 <argptr+0x45>
801070ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
801070af:	89 c2                	mov    %eax,%edx
801070b1:	8b 45 10             	mov    0x10(%ebp),%eax
801070b4:	01 c2                	add    %eax,%edx
801070b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070bc:	8b 00                	mov    (%eax),%eax
801070be:	39 c2                	cmp    %eax,%edx
801070c0:	76 07                	jbe    801070c9 <argptr+0x4c>
        return -1;
801070c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070c7:	eb 0f                	jmp    801070d8 <argptr+0x5b>
    *pp = (char*)i;
801070c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801070cc:	89 c2                	mov    %eax,%edx
801070ce:	8b 45 0c             	mov    0xc(%ebp),%eax
801070d1:	89 10                	mov    %edx,(%eax)
    return 0;
801070d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801070d8:	c9                   	leave  
801070d9:	c3                   	ret    

801070da <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801070da:	55                   	push   %ebp
801070db:	89 e5                	mov    %esp,%ebp
801070dd:	83 ec 10             	sub    $0x10,%esp
    int addr;
    if(argint(n, &addr) < 0)
801070e0:	8d 45 fc             	lea    -0x4(%ebp),%eax
801070e3:	50                   	push   %eax
801070e4:	ff 75 08             	pushl  0x8(%ebp)
801070e7:	e8 69 ff ff ff       	call   80107055 <argint>
801070ec:	83 c4 08             	add    $0x8,%esp
801070ef:	85 c0                	test   %eax,%eax
801070f1:	79 07                	jns    801070fa <argstr+0x20>
        return -1;
801070f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070f8:	eb 0f                	jmp    80107109 <argstr+0x2f>
    return fetchstr(addr, pp);
801070fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801070fd:	ff 75 0c             	pushl  0xc(%ebp)
80107100:	50                   	push   %eax
80107101:	e8 ed fe ff ff       	call   80106ff3 <fetchstr>
80107106:	83 c4 08             	add    $0x8,%esp
}
80107109:	c9                   	leave  
8010710a:	c3                   	ret    

8010710b <syscall>:
};
#endif

void
syscall(void)
{
8010710b:	55                   	push   %ebp
8010710c:	89 e5                	mov    %esp,%ebp
8010710e:	53                   	push   %ebx
8010710f:	83 ec 14             	sub    $0x14,%esp
    int num;

    num = proc->tf->eax;
80107112:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107118:	8b 40 18             	mov    0x18(%eax),%eax
8010711b:	8b 40 1c             	mov    0x1c(%eax),%eax
8010711e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80107121:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107125:	7e 30                	jle    80107157 <syscall+0x4c>
80107127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010712a:	83 f8 21             	cmp    $0x21,%eax
8010712d:	77 28                	ja     80107157 <syscall+0x4c>
8010712f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107132:	8b 04 85 40 e0 10 80 	mov    -0x7fef1fc0(,%eax,4),%eax
80107139:	85 c0                	test   %eax,%eax
8010713b:	74 1a                	je     80107157 <syscall+0x4c>
        proc->tf->eax = syscalls[num]();
8010713d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107143:	8b 58 18             	mov    0x18(%eax),%ebx
80107146:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107149:	8b 04 85 40 e0 10 80 	mov    -0x7fef1fc0(,%eax,4),%eax
80107150:	ff d0                	call   *%eax
80107152:	89 43 1c             	mov    %eax,0x1c(%ebx)
80107155:	eb 34                	jmp    8010718b <syscall+0x80>
#ifdef PRINT_SYSCALLS
        cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif
    } else {
        cprintf("%d %s: unknown sys call %d\n",
                proc->pid, proc->name, num);
80107157:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010715d:	8d 50 6c             	lea    0x6c(%eax),%edx
80107160:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
        // some code goes here
#ifdef PRINT_SYSCALLS
        cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
#endif
    } else {
        cprintf("%d %s: unknown sys call %d\n",
80107166:	8b 40 10             	mov    0x10(%eax),%eax
80107169:	ff 75 f4             	pushl  -0xc(%ebp)
8010716c:	52                   	push   %edx
8010716d:	50                   	push   %eax
8010716e:	68 72 ae 10 80       	push   $0x8010ae72
80107173:	e8 4e 92 ff ff       	call   801003c6 <cprintf>
80107178:	83 c4 10             	add    $0x10,%esp
                proc->pid, proc->name, num);
        proc->tf->eax = -1;
8010717b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107181:	8b 40 18             	mov    0x18(%eax),%eax
80107184:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
    }
}
8010718b:	90                   	nop
8010718c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010718f:	c9                   	leave  
80107190:	c3                   	ret    

80107191 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80107191:	55                   	push   %ebp
80107192:	89 e5                	mov    %esp,%ebp
80107194:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80107197:	83 ec 08             	sub    $0x8,%esp
8010719a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010719d:	50                   	push   %eax
8010719e:	ff 75 08             	pushl  0x8(%ebp)
801071a1:	e8 af fe ff ff       	call   80107055 <argint>
801071a6:	83 c4 10             	add    $0x10,%esp
801071a9:	85 c0                	test   %eax,%eax
801071ab:	79 07                	jns    801071b4 <argfd+0x23>
    return -1;
801071ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071b2:	eb 50                	jmp    80107204 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801071b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071b7:	85 c0                	test   %eax,%eax
801071b9:	78 21                	js     801071dc <argfd+0x4b>
801071bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071be:	83 f8 0f             	cmp    $0xf,%eax
801071c1:	7f 19                	jg     801071dc <argfd+0x4b>
801071c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801071cc:	83 c2 08             	add    $0x8,%edx
801071cf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801071d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801071d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801071da:	75 07                	jne    801071e3 <argfd+0x52>
    return -1;
801071dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071e1:	eb 21                	jmp    80107204 <argfd+0x73>
  if(pfd)
801071e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801071e7:	74 08                	je     801071f1 <argfd+0x60>
    *pfd = fd;
801071e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
801071ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801071ef:	89 10                	mov    %edx,(%eax)
  if(pf)
801071f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801071f5:	74 08                	je     801071ff <argfd+0x6e>
    *pf = f;
801071f7:	8b 45 10             	mov    0x10(%ebp),%eax
801071fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801071fd:	89 10                	mov    %edx,(%eax)
  return 0;
801071ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107204:	c9                   	leave  
80107205:	c3                   	ret    

80107206 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80107206:	55                   	push   %ebp
80107207:	89 e5                	mov    %esp,%ebp
80107209:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010720c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107213:	eb 30                	jmp    80107245 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80107215:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010721b:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010721e:	83 c2 08             	add    $0x8,%edx
80107221:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80107225:	85 c0                	test   %eax,%eax
80107227:	75 18                	jne    80107241 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80107229:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010722f:	8b 55 fc             	mov    -0x4(%ebp),%edx
80107232:	8d 4a 08             	lea    0x8(%edx),%ecx
80107235:	8b 55 08             	mov    0x8(%ebp),%edx
80107238:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010723c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010723f:	eb 0f                	jmp    80107250 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80107241:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107245:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80107249:	7e ca                	jle    80107215 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010724b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107250:	c9                   	leave  
80107251:	c3                   	ret    

80107252 <sys_dup>:

int
sys_dup(void)
{
80107252:	55                   	push   %ebp
80107253:	89 e5                	mov    %esp,%ebp
80107255:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80107258:	83 ec 04             	sub    $0x4,%esp
8010725b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010725e:	50                   	push   %eax
8010725f:	6a 00                	push   $0x0
80107261:	6a 00                	push   $0x0
80107263:	e8 29 ff ff ff       	call   80107191 <argfd>
80107268:	83 c4 10             	add    $0x10,%esp
8010726b:	85 c0                	test   %eax,%eax
8010726d:	79 07                	jns    80107276 <sys_dup+0x24>
    return -1;
8010726f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107274:	eb 31                	jmp    801072a7 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80107276:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107279:	83 ec 0c             	sub    $0xc,%esp
8010727c:	50                   	push   %eax
8010727d:	e8 84 ff ff ff       	call   80107206 <fdalloc>
80107282:	83 c4 10             	add    $0x10,%esp
80107285:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107288:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010728c:	79 07                	jns    80107295 <sys_dup+0x43>
    return -1;
8010728e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107293:	eb 12                	jmp    801072a7 <sys_dup+0x55>
  filedup(f);
80107295:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107298:	83 ec 0c             	sub    $0xc,%esp
8010729b:	50                   	push   %eax
8010729c:	e8 af 9e ff ff       	call   80101150 <filedup>
801072a1:	83 c4 10             	add    $0x10,%esp
  return fd;
801072a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801072a7:	c9                   	leave  
801072a8:	c3                   	ret    

801072a9 <sys_read>:

int
sys_read(void)
{
801072a9:	55                   	push   %ebp
801072aa:	89 e5                	mov    %esp,%ebp
801072ac:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801072af:	83 ec 04             	sub    $0x4,%esp
801072b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801072b5:	50                   	push   %eax
801072b6:	6a 00                	push   $0x0
801072b8:	6a 00                	push   $0x0
801072ba:	e8 d2 fe ff ff       	call   80107191 <argfd>
801072bf:	83 c4 10             	add    $0x10,%esp
801072c2:	85 c0                	test   %eax,%eax
801072c4:	78 2e                	js     801072f4 <sys_read+0x4b>
801072c6:	83 ec 08             	sub    $0x8,%esp
801072c9:	8d 45 f0             	lea    -0x10(%ebp),%eax
801072cc:	50                   	push   %eax
801072cd:	6a 02                	push   $0x2
801072cf:	e8 81 fd ff ff       	call   80107055 <argint>
801072d4:	83 c4 10             	add    $0x10,%esp
801072d7:	85 c0                	test   %eax,%eax
801072d9:	78 19                	js     801072f4 <sys_read+0x4b>
801072db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072de:	83 ec 04             	sub    $0x4,%esp
801072e1:	50                   	push   %eax
801072e2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801072e5:	50                   	push   %eax
801072e6:	6a 01                	push   $0x1
801072e8:	e8 90 fd ff ff       	call   8010707d <argptr>
801072ed:	83 c4 10             	add    $0x10,%esp
801072f0:	85 c0                	test   %eax,%eax
801072f2:	79 07                	jns    801072fb <sys_read+0x52>
    return -1;
801072f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072f9:	eb 17                	jmp    80107312 <sys_read+0x69>
  return fileread(f, p, n);
801072fb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801072fe:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107304:	83 ec 04             	sub    $0x4,%esp
80107307:	51                   	push   %ecx
80107308:	52                   	push   %edx
80107309:	50                   	push   %eax
8010730a:	e8 d1 9f ff ff       	call   801012e0 <fileread>
8010730f:	83 c4 10             	add    $0x10,%esp
}
80107312:	c9                   	leave  
80107313:	c3                   	ret    

80107314 <sys_write>:

int
sys_write(void)
{
80107314:	55                   	push   %ebp
80107315:	89 e5                	mov    %esp,%ebp
80107317:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010731a:	83 ec 04             	sub    $0x4,%esp
8010731d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107320:	50                   	push   %eax
80107321:	6a 00                	push   $0x0
80107323:	6a 00                	push   $0x0
80107325:	e8 67 fe ff ff       	call   80107191 <argfd>
8010732a:	83 c4 10             	add    $0x10,%esp
8010732d:	85 c0                	test   %eax,%eax
8010732f:	78 2e                	js     8010735f <sys_write+0x4b>
80107331:	83 ec 08             	sub    $0x8,%esp
80107334:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107337:	50                   	push   %eax
80107338:	6a 02                	push   $0x2
8010733a:	e8 16 fd ff ff       	call   80107055 <argint>
8010733f:	83 c4 10             	add    $0x10,%esp
80107342:	85 c0                	test   %eax,%eax
80107344:	78 19                	js     8010735f <sys_write+0x4b>
80107346:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107349:	83 ec 04             	sub    $0x4,%esp
8010734c:	50                   	push   %eax
8010734d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107350:	50                   	push   %eax
80107351:	6a 01                	push   $0x1
80107353:	e8 25 fd ff ff       	call   8010707d <argptr>
80107358:	83 c4 10             	add    $0x10,%esp
8010735b:	85 c0                	test   %eax,%eax
8010735d:	79 07                	jns    80107366 <sys_write+0x52>
    return -1;
8010735f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107364:	eb 17                	jmp    8010737d <sys_write+0x69>
  return filewrite(f, p, n);
80107366:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107369:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010736c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010736f:	83 ec 04             	sub    $0x4,%esp
80107372:	51                   	push   %ecx
80107373:	52                   	push   %edx
80107374:	50                   	push   %eax
80107375:	e8 1e a0 ff ff       	call   80101398 <filewrite>
8010737a:	83 c4 10             	add    $0x10,%esp
}
8010737d:	c9                   	leave  
8010737e:	c3                   	ret    

8010737f <sys_close>:

int
sys_close(void)
{
8010737f:	55                   	push   %ebp
80107380:	89 e5                	mov    %esp,%ebp
80107382:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80107385:	83 ec 04             	sub    $0x4,%esp
80107388:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010738b:	50                   	push   %eax
8010738c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010738f:	50                   	push   %eax
80107390:	6a 00                	push   $0x0
80107392:	e8 fa fd ff ff       	call   80107191 <argfd>
80107397:	83 c4 10             	add    $0x10,%esp
8010739a:	85 c0                	test   %eax,%eax
8010739c:	79 07                	jns    801073a5 <sys_close+0x26>
    return -1;
8010739e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073a3:	eb 28                	jmp    801073cd <sys_close+0x4e>
  proc->ofile[fd] = 0;
801073a5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801073ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
801073ae:	83 c2 08             	add    $0x8,%edx
801073b1:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801073b8:	00 
  fileclose(f);
801073b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801073bc:	83 ec 0c             	sub    $0xc,%esp
801073bf:	50                   	push   %eax
801073c0:	e8 dc 9d ff ff       	call   801011a1 <fileclose>
801073c5:	83 c4 10             	add    $0x10,%esp
  return 0;
801073c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801073cd:	c9                   	leave  
801073ce:	c3                   	ret    

801073cf <sys_fstat>:

int
sys_fstat(void)
{
801073cf:	55                   	push   %ebp
801073d0:	89 e5                	mov    %esp,%ebp
801073d2:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801073d5:	83 ec 04             	sub    $0x4,%esp
801073d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801073db:	50                   	push   %eax
801073dc:	6a 00                	push   $0x0
801073de:	6a 00                	push   $0x0
801073e0:	e8 ac fd ff ff       	call   80107191 <argfd>
801073e5:	83 c4 10             	add    $0x10,%esp
801073e8:	85 c0                	test   %eax,%eax
801073ea:	78 17                	js     80107403 <sys_fstat+0x34>
801073ec:	83 ec 04             	sub    $0x4,%esp
801073ef:	6a 1c                	push   $0x1c
801073f1:	8d 45 f0             	lea    -0x10(%ebp),%eax
801073f4:	50                   	push   %eax
801073f5:	6a 01                	push   $0x1
801073f7:	e8 81 fc ff ff       	call   8010707d <argptr>
801073fc:	83 c4 10             	add    $0x10,%esp
801073ff:	85 c0                	test   %eax,%eax
80107401:	79 07                	jns    8010740a <sys_fstat+0x3b>
    return -1;
80107403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107408:	eb 13                	jmp    8010741d <sys_fstat+0x4e>
  return filestat(f, st);
8010740a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010740d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107410:	83 ec 08             	sub    $0x8,%esp
80107413:	52                   	push   %edx
80107414:	50                   	push   %eax
80107415:	e8 6f 9e ff ff       	call   80101289 <filestat>
8010741a:	83 c4 10             	add    $0x10,%esp
}
8010741d:	c9                   	leave  
8010741e:	c3                   	ret    

8010741f <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
8010741f:	55                   	push   %ebp
80107420:	89 e5                	mov    %esp,%ebp
80107422:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80107425:	83 ec 08             	sub    $0x8,%esp
80107428:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010742b:	50                   	push   %eax
8010742c:	6a 00                	push   $0x0
8010742e:	e8 a7 fc ff ff       	call   801070da <argstr>
80107433:	83 c4 10             	add    $0x10,%esp
80107436:	85 c0                	test   %eax,%eax
80107438:	78 15                	js     8010744f <sys_link+0x30>
8010743a:	83 ec 08             	sub    $0x8,%esp
8010743d:	8d 45 dc             	lea    -0x24(%ebp),%eax
80107440:	50                   	push   %eax
80107441:	6a 01                	push   $0x1
80107443:	e8 92 fc ff ff       	call   801070da <argstr>
80107448:	83 c4 10             	add    $0x10,%esp
8010744b:	85 c0                	test   %eax,%eax
8010744d:	79 0a                	jns    80107459 <sys_link+0x3a>
    return -1;
8010744f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107454:	e9 68 01 00 00       	jmp    801075c1 <sys_link+0x1a2>

  begin_op();
80107459:	e8 20 c4 ff ff       	call   8010387e <begin_op>
  if((ip = namei(old)) == 0){
8010745e:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107461:	83 ec 0c             	sub    $0xc,%esp
80107464:	50                   	push   %eax
80107465:	e8 a2 b2 ff ff       	call   8010270c <namei>
8010746a:	83 c4 10             	add    $0x10,%esp
8010746d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107470:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107474:	75 0f                	jne    80107485 <sys_link+0x66>
    end_op();
80107476:	e8 8f c4 ff ff       	call   8010390a <end_op>
    return -1;
8010747b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107480:	e9 3c 01 00 00       	jmp    801075c1 <sys_link+0x1a2>
  }

  ilock(ip);
80107485:	83 ec 0c             	sub    $0xc,%esp
80107488:	ff 75 f4             	pushl  -0xc(%ebp)
8010748b:	e8 6e a6 ff ff       	call   80101afe <ilock>
80107490:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80107493:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107496:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010749a:	66 83 f8 01          	cmp    $0x1,%ax
8010749e:	75 1d                	jne    801074bd <sys_link+0x9e>
    iunlockput(ip);
801074a0:	83 ec 0c             	sub    $0xc,%esp
801074a3:	ff 75 f4             	pushl  -0xc(%ebp)
801074a6:	e8 3b a9 ff ff       	call   80101de6 <iunlockput>
801074ab:	83 c4 10             	add    $0x10,%esp
    end_op();
801074ae:	e8 57 c4 ff ff       	call   8010390a <end_op>
    return -1;
801074b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801074b8:	e9 04 01 00 00       	jmp    801075c1 <sys_link+0x1a2>
  }

  ip->nlink++;
801074bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074c0:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801074c4:	83 c0 01             	add    $0x1,%eax
801074c7:	89 c2                	mov    %eax,%edx
801074c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801074cc:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801074d0:	83 ec 0c             	sub    $0xc,%esp
801074d3:	ff 75 f4             	pushl  -0xc(%ebp)
801074d6:	e8 21 a4 ff ff       	call   801018fc <iupdate>
801074db:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801074de:	83 ec 0c             	sub    $0xc,%esp
801074e1:	ff 75 f4             	pushl  -0xc(%ebp)
801074e4:	e8 9b a7 ff ff       	call   80101c84 <iunlock>
801074e9:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801074ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801074ef:	83 ec 08             	sub    $0x8,%esp
801074f2:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801074f5:	52                   	push   %edx
801074f6:	50                   	push   %eax
801074f7:	e8 2c b2 ff ff       	call   80102728 <nameiparent>
801074fc:	83 c4 10             	add    $0x10,%esp
801074ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107502:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107506:	74 71                	je     80107579 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80107508:	83 ec 0c             	sub    $0xc,%esp
8010750b:	ff 75 f0             	pushl  -0x10(%ebp)
8010750e:	e8 eb a5 ff ff       	call   80101afe <ilock>
80107513:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80107516:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107519:	8b 10                	mov    (%eax),%edx
8010751b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010751e:	8b 00                	mov    (%eax),%eax
80107520:	39 c2                	cmp    %eax,%edx
80107522:	75 1d                	jne    80107541 <sys_link+0x122>
80107524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107527:	8b 40 04             	mov    0x4(%eax),%eax
8010752a:	83 ec 04             	sub    $0x4,%esp
8010752d:	50                   	push   %eax
8010752e:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80107531:	50                   	push   %eax
80107532:	ff 75 f0             	pushl  -0x10(%ebp)
80107535:	e8 36 af ff ff       	call   80102470 <dirlink>
8010753a:	83 c4 10             	add    $0x10,%esp
8010753d:	85 c0                	test   %eax,%eax
8010753f:	79 10                	jns    80107551 <sys_link+0x132>
    iunlockput(dp);
80107541:	83 ec 0c             	sub    $0xc,%esp
80107544:	ff 75 f0             	pushl  -0x10(%ebp)
80107547:	e8 9a a8 ff ff       	call   80101de6 <iunlockput>
8010754c:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010754f:	eb 29                	jmp    8010757a <sys_link+0x15b>
  }
  iunlockput(dp);
80107551:	83 ec 0c             	sub    $0xc,%esp
80107554:	ff 75 f0             	pushl  -0x10(%ebp)
80107557:	e8 8a a8 ff ff       	call   80101de6 <iunlockput>
8010755c:	83 c4 10             	add    $0x10,%esp
  iput(ip);
8010755f:	83 ec 0c             	sub    $0xc,%esp
80107562:	ff 75 f4             	pushl  -0xc(%ebp)
80107565:	e8 8c a7 ff ff       	call   80101cf6 <iput>
8010756a:	83 c4 10             	add    $0x10,%esp

  end_op();
8010756d:	e8 98 c3 ff ff       	call   8010390a <end_op>

  return 0;
80107572:	b8 00 00 00 00       	mov    $0x0,%eax
80107577:	eb 48                	jmp    801075c1 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80107579:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
8010757a:	83 ec 0c             	sub    $0xc,%esp
8010757d:	ff 75 f4             	pushl  -0xc(%ebp)
80107580:	e8 79 a5 ff ff       	call   80101afe <ilock>
80107585:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80107588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010758b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010758f:	83 e8 01             	sub    $0x1,%eax
80107592:	89 c2                	mov    %eax,%edx
80107594:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107597:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010759b:	83 ec 0c             	sub    $0xc,%esp
8010759e:	ff 75 f4             	pushl  -0xc(%ebp)
801075a1:	e8 56 a3 ff ff       	call   801018fc <iupdate>
801075a6:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801075a9:	83 ec 0c             	sub    $0xc,%esp
801075ac:	ff 75 f4             	pushl  -0xc(%ebp)
801075af:	e8 32 a8 ff ff       	call   80101de6 <iunlockput>
801075b4:	83 c4 10             	add    $0x10,%esp
  end_op();
801075b7:	e8 4e c3 ff ff       	call   8010390a <end_op>
  return -1;
801075bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075c1:	c9                   	leave  
801075c2:	c3                   	ret    

801075c3 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801075c3:	55                   	push   %ebp
801075c4:	89 e5                	mov    %esp,%ebp
801075c6:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801075c9:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801075d0:	eb 40                	jmp    80107612 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801075d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075d5:	6a 10                	push   $0x10
801075d7:	50                   	push   %eax
801075d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801075db:	50                   	push   %eax
801075dc:	ff 75 08             	pushl  0x8(%ebp)
801075df:	e8 d8 aa ff ff       	call   801020bc <readi>
801075e4:	83 c4 10             	add    $0x10,%esp
801075e7:	83 f8 10             	cmp    $0x10,%eax
801075ea:	74 0d                	je     801075f9 <isdirempty+0x36>
      panic("isdirempty: readi");
801075ec:	83 ec 0c             	sub    $0xc,%esp
801075ef:	68 8e ae 10 80       	push   $0x8010ae8e
801075f4:	e8 6d 8f ff ff       	call   80100566 <panic>
    if(de.inum != 0)
801075f9:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801075fd:	66 85 c0             	test   %ax,%ax
80107600:	74 07                	je     80107609 <isdirempty+0x46>
      return 0;
80107602:	b8 00 00 00 00       	mov    $0x0,%eax
80107607:	eb 1b                	jmp    80107624 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107609:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010760c:	83 c0 10             	add    $0x10,%eax
8010760f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107612:	8b 45 08             	mov    0x8(%ebp),%eax
80107615:	8b 50 20             	mov    0x20(%eax),%edx
80107618:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010761b:	39 c2                	cmp    %eax,%edx
8010761d:	77 b3                	ja     801075d2 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
8010761f:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107624:	c9                   	leave  
80107625:	c3                   	ret    

80107626 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80107626:	55                   	push   %ebp
80107627:	89 e5                	mov    %esp,%ebp
80107629:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010762c:	83 ec 08             	sub    $0x8,%esp
8010762f:	8d 45 cc             	lea    -0x34(%ebp),%eax
80107632:	50                   	push   %eax
80107633:	6a 00                	push   $0x0
80107635:	e8 a0 fa ff ff       	call   801070da <argstr>
8010763a:	83 c4 10             	add    $0x10,%esp
8010763d:	85 c0                	test   %eax,%eax
8010763f:	79 0a                	jns    8010764b <sys_unlink+0x25>
    return -1;
80107641:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107646:	e9 bc 01 00 00       	jmp    80107807 <sys_unlink+0x1e1>

  begin_op();
8010764b:	e8 2e c2 ff ff       	call   8010387e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80107650:	8b 45 cc             	mov    -0x34(%ebp),%eax
80107653:	83 ec 08             	sub    $0x8,%esp
80107656:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80107659:	52                   	push   %edx
8010765a:	50                   	push   %eax
8010765b:	e8 c8 b0 ff ff       	call   80102728 <nameiparent>
80107660:	83 c4 10             	add    $0x10,%esp
80107663:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107666:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010766a:	75 0f                	jne    8010767b <sys_unlink+0x55>
    end_op();
8010766c:	e8 99 c2 ff ff       	call   8010390a <end_op>
    return -1;
80107671:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107676:	e9 8c 01 00 00       	jmp    80107807 <sys_unlink+0x1e1>
  }

  ilock(dp);
8010767b:	83 ec 0c             	sub    $0xc,%esp
8010767e:	ff 75 f4             	pushl  -0xc(%ebp)
80107681:	e8 78 a4 ff ff       	call   80101afe <ilock>
80107686:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80107689:	83 ec 08             	sub    $0x8,%esp
8010768c:	68 a0 ae 10 80       	push   $0x8010aea0
80107691:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107694:	50                   	push   %eax
80107695:	e8 01 ad ff ff       	call   8010239b <namecmp>
8010769a:	83 c4 10             	add    $0x10,%esp
8010769d:	85 c0                	test   %eax,%eax
8010769f:	0f 84 4a 01 00 00    	je     801077ef <sys_unlink+0x1c9>
801076a5:	83 ec 08             	sub    $0x8,%esp
801076a8:	68 a2 ae 10 80       	push   $0x8010aea2
801076ad:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801076b0:	50                   	push   %eax
801076b1:	e8 e5 ac ff ff       	call   8010239b <namecmp>
801076b6:	83 c4 10             	add    $0x10,%esp
801076b9:	85 c0                	test   %eax,%eax
801076bb:	0f 84 2e 01 00 00    	je     801077ef <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801076c1:	83 ec 04             	sub    $0x4,%esp
801076c4:	8d 45 c8             	lea    -0x38(%ebp),%eax
801076c7:	50                   	push   %eax
801076c8:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801076cb:	50                   	push   %eax
801076cc:	ff 75 f4             	pushl  -0xc(%ebp)
801076cf:	e8 e2 ac ff ff       	call   801023b6 <dirlookup>
801076d4:	83 c4 10             	add    $0x10,%esp
801076d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
801076da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801076de:	0f 84 0a 01 00 00    	je     801077ee <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
801076e4:	83 ec 0c             	sub    $0xc,%esp
801076e7:	ff 75 f0             	pushl  -0x10(%ebp)
801076ea:	e8 0f a4 ff ff       	call   80101afe <ilock>
801076ef:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
801076f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076f5:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801076f9:	66 85 c0             	test   %ax,%ax
801076fc:	7f 0d                	jg     8010770b <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801076fe:	83 ec 0c             	sub    $0xc,%esp
80107701:	68 a5 ae 10 80       	push   $0x8010aea5
80107706:	e8 5b 8e ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010770b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010770e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107712:	66 83 f8 01          	cmp    $0x1,%ax
80107716:	75 25                	jne    8010773d <sys_unlink+0x117>
80107718:	83 ec 0c             	sub    $0xc,%esp
8010771b:	ff 75 f0             	pushl  -0x10(%ebp)
8010771e:	e8 a0 fe ff ff       	call   801075c3 <isdirempty>
80107723:	83 c4 10             	add    $0x10,%esp
80107726:	85 c0                	test   %eax,%eax
80107728:	75 13                	jne    8010773d <sys_unlink+0x117>
    iunlockput(ip);
8010772a:	83 ec 0c             	sub    $0xc,%esp
8010772d:	ff 75 f0             	pushl  -0x10(%ebp)
80107730:	e8 b1 a6 ff ff       	call   80101de6 <iunlockput>
80107735:	83 c4 10             	add    $0x10,%esp
    goto bad;
80107738:	e9 b2 00 00 00       	jmp    801077ef <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
8010773d:	83 ec 04             	sub    $0x4,%esp
80107740:	6a 10                	push   $0x10
80107742:	6a 00                	push   $0x0
80107744:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107747:	50                   	push   %eax
80107748:	e8 e3 f5 ff ff       	call   80106d30 <memset>
8010774d:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80107750:	8b 45 c8             	mov    -0x38(%ebp),%eax
80107753:	6a 10                	push   $0x10
80107755:	50                   	push   %eax
80107756:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107759:	50                   	push   %eax
8010775a:	ff 75 f4             	pushl  -0xc(%ebp)
8010775d:	e8 b1 aa ff ff       	call   80102213 <writei>
80107762:	83 c4 10             	add    $0x10,%esp
80107765:	83 f8 10             	cmp    $0x10,%eax
80107768:	74 0d                	je     80107777 <sys_unlink+0x151>
    panic("unlink: writei");
8010776a:	83 ec 0c             	sub    $0xc,%esp
8010776d:	68 b7 ae 10 80       	push   $0x8010aeb7
80107772:	e8 ef 8d ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
80107777:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010777a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010777e:	66 83 f8 01          	cmp    $0x1,%ax
80107782:	75 21                	jne    801077a5 <sys_unlink+0x17f>
    dp->nlink--;
80107784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107787:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010778b:	83 e8 01             	sub    $0x1,%eax
8010778e:	89 c2                	mov    %eax,%edx
80107790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107793:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80107797:	83 ec 0c             	sub    $0xc,%esp
8010779a:	ff 75 f4             	pushl  -0xc(%ebp)
8010779d:	e8 5a a1 ff ff       	call   801018fc <iupdate>
801077a2:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801077a5:	83 ec 0c             	sub    $0xc,%esp
801077a8:	ff 75 f4             	pushl  -0xc(%ebp)
801077ab:	e8 36 a6 ff ff       	call   80101de6 <iunlockput>
801077b0:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801077b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077b6:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801077ba:	83 e8 01             	sub    $0x1,%eax
801077bd:	89 c2                	mov    %eax,%edx
801077bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077c2:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801077c6:	83 ec 0c             	sub    $0xc,%esp
801077c9:	ff 75 f0             	pushl  -0x10(%ebp)
801077cc:	e8 2b a1 ff ff       	call   801018fc <iupdate>
801077d1:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801077d4:	83 ec 0c             	sub    $0xc,%esp
801077d7:	ff 75 f0             	pushl  -0x10(%ebp)
801077da:	e8 07 a6 ff ff       	call   80101de6 <iunlockput>
801077df:	83 c4 10             	add    $0x10,%esp

  end_op();
801077e2:	e8 23 c1 ff ff       	call   8010390a <end_op>

  return 0;
801077e7:	b8 00 00 00 00       	mov    $0x0,%eax
801077ec:	eb 19                	jmp    80107807 <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
801077ee:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
801077ef:	83 ec 0c             	sub    $0xc,%esp
801077f2:	ff 75 f4             	pushl  -0xc(%ebp)
801077f5:	e8 ec a5 ff ff       	call   80101de6 <iunlockput>
801077fa:	83 c4 10             	add    $0x10,%esp
  end_op();
801077fd:	e8 08 c1 ff ff       	call   8010390a <end_op>
  return -1;
80107802:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107807:	c9                   	leave  
80107808:	c3                   	ret    

80107809 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80107809:	55                   	push   %ebp
8010780a:	89 e5                	mov    %esp,%ebp
8010780c:	83 ec 38             	sub    $0x38,%esp
8010780f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107812:	8b 55 10             	mov    0x10(%ebp),%edx
80107815:	8b 45 14             	mov    0x14(%ebp),%eax
80107818:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010781c:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80107820:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80107824:	83 ec 08             	sub    $0x8,%esp
80107827:	8d 45 de             	lea    -0x22(%ebp),%eax
8010782a:	50                   	push   %eax
8010782b:	ff 75 08             	pushl  0x8(%ebp)
8010782e:	e8 f5 ae ff ff       	call   80102728 <nameiparent>
80107833:	83 c4 10             	add    $0x10,%esp
80107836:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010783d:	75 0a                	jne    80107849 <create+0x40>
    return 0;
8010783f:	b8 00 00 00 00       	mov    $0x0,%eax
80107844:	e9 90 01 00 00       	jmp    801079d9 <create+0x1d0>
  ilock(dp);
80107849:	83 ec 0c             	sub    $0xc,%esp
8010784c:	ff 75 f4             	pushl  -0xc(%ebp)
8010784f:	e8 aa a2 ff ff       	call   80101afe <ilock>
80107854:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80107857:	83 ec 04             	sub    $0x4,%esp
8010785a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010785d:	50                   	push   %eax
8010785e:	8d 45 de             	lea    -0x22(%ebp),%eax
80107861:	50                   	push   %eax
80107862:	ff 75 f4             	pushl  -0xc(%ebp)
80107865:	e8 4c ab ff ff       	call   801023b6 <dirlookup>
8010786a:	83 c4 10             	add    $0x10,%esp
8010786d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107870:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107874:	74 50                	je     801078c6 <create+0xbd>
    iunlockput(dp);
80107876:	83 ec 0c             	sub    $0xc,%esp
80107879:	ff 75 f4             	pushl  -0xc(%ebp)
8010787c:	e8 65 a5 ff ff       	call   80101de6 <iunlockput>
80107881:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80107884:	83 ec 0c             	sub    $0xc,%esp
80107887:	ff 75 f0             	pushl  -0x10(%ebp)
8010788a:	e8 6f a2 ff ff       	call   80101afe <ilock>
8010788f:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80107892:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80107897:	75 15                	jne    801078ae <create+0xa5>
80107899:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010789c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801078a0:	66 83 f8 02          	cmp    $0x2,%ax
801078a4:	75 08                	jne    801078ae <create+0xa5>
      return ip;
801078a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078a9:	e9 2b 01 00 00       	jmp    801079d9 <create+0x1d0>
    iunlockput(ip);
801078ae:	83 ec 0c             	sub    $0xc,%esp
801078b1:	ff 75 f0             	pushl  -0x10(%ebp)
801078b4:	e8 2d a5 ff ff       	call   80101de6 <iunlockput>
801078b9:	83 c4 10             	add    $0x10,%esp
    return 0;
801078bc:	b8 00 00 00 00       	mov    $0x0,%eax
801078c1:	e9 13 01 00 00       	jmp    801079d9 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801078c6:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801078ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078cd:	8b 00                	mov    (%eax),%eax
801078cf:	83 ec 08             	sub    $0x8,%esp
801078d2:	52                   	push   %edx
801078d3:	50                   	push   %eax
801078d4:	e8 30 9f ff ff       	call   80101809 <ialloc>
801078d9:	83 c4 10             	add    $0x10,%esp
801078dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
801078df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078e3:	75 0d                	jne    801078f2 <create+0xe9>
    panic("create: ialloc");
801078e5:	83 ec 0c             	sub    $0xc,%esp
801078e8:	68 c6 ae 10 80       	push   $0x8010aec6
801078ed:	e8 74 8c ff ff       	call   80100566 <panic>

  ilock(ip);
801078f2:	83 ec 0c             	sub    $0xc,%esp
801078f5:	ff 75 f0             	pushl  -0x10(%ebp)
801078f8:	e8 01 a2 ff ff       	call   80101afe <ilock>
801078fd:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80107900:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107903:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80107907:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010790b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010790e:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80107912:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80107916:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107919:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010791f:	83 ec 0c             	sub    $0xc,%esp
80107922:	ff 75 f0             	pushl  -0x10(%ebp)
80107925:	e8 d2 9f ff ff       	call   801018fc <iupdate>
8010792a:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
8010792d:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80107932:	75 6a                	jne    8010799e <create+0x195>
    dp->nlink++;  // for ".."
80107934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107937:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010793b:	83 c0 01             	add    $0x1,%eax
8010793e:	89 c2                	mov    %eax,%edx
80107940:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107943:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80107947:	83 ec 0c             	sub    $0xc,%esp
8010794a:	ff 75 f4             	pushl  -0xc(%ebp)
8010794d:	e8 aa 9f ff ff       	call   801018fc <iupdate>
80107952:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80107955:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107958:	8b 40 04             	mov    0x4(%eax),%eax
8010795b:	83 ec 04             	sub    $0x4,%esp
8010795e:	50                   	push   %eax
8010795f:	68 a0 ae 10 80       	push   $0x8010aea0
80107964:	ff 75 f0             	pushl  -0x10(%ebp)
80107967:	e8 04 ab ff ff       	call   80102470 <dirlink>
8010796c:	83 c4 10             	add    $0x10,%esp
8010796f:	85 c0                	test   %eax,%eax
80107971:	78 1e                	js     80107991 <create+0x188>
80107973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107976:	8b 40 04             	mov    0x4(%eax),%eax
80107979:	83 ec 04             	sub    $0x4,%esp
8010797c:	50                   	push   %eax
8010797d:	68 a2 ae 10 80       	push   $0x8010aea2
80107982:	ff 75 f0             	pushl  -0x10(%ebp)
80107985:	e8 e6 aa ff ff       	call   80102470 <dirlink>
8010798a:	83 c4 10             	add    $0x10,%esp
8010798d:	85 c0                	test   %eax,%eax
8010798f:	79 0d                	jns    8010799e <create+0x195>
      panic("create dots");
80107991:	83 ec 0c             	sub    $0xc,%esp
80107994:	68 d5 ae 10 80       	push   $0x8010aed5
80107999:	e8 c8 8b ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010799e:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079a1:	8b 40 04             	mov    0x4(%eax),%eax
801079a4:	83 ec 04             	sub    $0x4,%esp
801079a7:	50                   	push   %eax
801079a8:	8d 45 de             	lea    -0x22(%ebp),%eax
801079ab:	50                   	push   %eax
801079ac:	ff 75 f4             	pushl  -0xc(%ebp)
801079af:	e8 bc aa ff ff       	call   80102470 <dirlink>
801079b4:	83 c4 10             	add    $0x10,%esp
801079b7:	85 c0                	test   %eax,%eax
801079b9:	79 0d                	jns    801079c8 <create+0x1bf>
    panic("create: dirlink");
801079bb:	83 ec 0c             	sub    $0xc,%esp
801079be:	68 e1 ae 10 80       	push   $0x8010aee1
801079c3:	e8 9e 8b ff ff       	call   80100566 <panic>

  iunlockput(dp);
801079c8:	83 ec 0c             	sub    $0xc,%esp
801079cb:	ff 75 f4             	pushl  -0xc(%ebp)
801079ce:	e8 13 a4 ff ff       	call   80101de6 <iunlockput>
801079d3:	83 c4 10             	add    $0x10,%esp

  return ip;
801079d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801079d9:	c9                   	leave  
801079da:	c3                   	ret    

801079db <sys_open>:

int
sys_open(void)
{
801079db:	55                   	push   %ebp
801079dc:	89 e5                	mov    %esp,%ebp
801079de:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801079e1:	83 ec 08             	sub    $0x8,%esp
801079e4:	8d 45 e8             	lea    -0x18(%ebp),%eax
801079e7:	50                   	push   %eax
801079e8:	6a 00                	push   $0x0
801079ea:	e8 eb f6 ff ff       	call   801070da <argstr>
801079ef:	83 c4 10             	add    $0x10,%esp
801079f2:	85 c0                	test   %eax,%eax
801079f4:	78 15                	js     80107a0b <sys_open+0x30>
801079f6:	83 ec 08             	sub    $0x8,%esp
801079f9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801079fc:	50                   	push   %eax
801079fd:	6a 01                	push   $0x1
801079ff:	e8 51 f6 ff ff       	call   80107055 <argint>
80107a04:	83 c4 10             	add    $0x10,%esp
80107a07:	85 c0                	test   %eax,%eax
80107a09:	79 0a                	jns    80107a15 <sys_open+0x3a>
    return -1;
80107a0b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a10:	e9 61 01 00 00       	jmp    80107b76 <sys_open+0x19b>

  begin_op();
80107a15:	e8 64 be ff ff       	call   8010387e <begin_op>

  if(omode & O_CREATE){
80107a1a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a1d:	25 00 02 00 00       	and    $0x200,%eax
80107a22:	85 c0                	test   %eax,%eax
80107a24:	74 2a                	je     80107a50 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80107a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107a29:	6a 00                	push   $0x0
80107a2b:	6a 00                	push   $0x0
80107a2d:	6a 02                	push   $0x2
80107a2f:	50                   	push   %eax
80107a30:	e8 d4 fd ff ff       	call   80107809 <create>
80107a35:	83 c4 10             	add    $0x10,%esp
80107a38:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80107a3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a3f:	75 75                	jne    80107ab6 <sys_open+0xdb>
      end_op();
80107a41:	e8 c4 be ff ff       	call   8010390a <end_op>
      return -1;
80107a46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a4b:	e9 26 01 00 00       	jmp    80107b76 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80107a50:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107a53:	83 ec 0c             	sub    $0xc,%esp
80107a56:	50                   	push   %eax
80107a57:	e8 b0 ac ff ff       	call   8010270c <namei>
80107a5c:	83 c4 10             	add    $0x10,%esp
80107a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a66:	75 0f                	jne    80107a77 <sys_open+0x9c>
      end_op();
80107a68:	e8 9d be ff ff       	call   8010390a <end_op>
      return -1;
80107a6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a72:	e9 ff 00 00 00       	jmp    80107b76 <sys_open+0x19b>
    }
    ilock(ip);
80107a77:	83 ec 0c             	sub    $0xc,%esp
80107a7a:	ff 75 f4             	pushl  -0xc(%ebp)
80107a7d:	e8 7c a0 ff ff       	call   80101afe <ilock>
80107a82:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80107a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a88:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107a8c:	66 83 f8 01          	cmp    $0x1,%ax
80107a90:	75 24                	jne    80107ab6 <sys_open+0xdb>
80107a92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a95:	85 c0                	test   %eax,%eax
80107a97:	74 1d                	je     80107ab6 <sys_open+0xdb>
      iunlockput(ip);
80107a99:	83 ec 0c             	sub    $0xc,%esp
80107a9c:	ff 75 f4             	pushl  -0xc(%ebp)
80107a9f:	e8 42 a3 ff ff       	call   80101de6 <iunlockput>
80107aa4:	83 c4 10             	add    $0x10,%esp
      end_op();
80107aa7:	e8 5e be ff ff       	call   8010390a <end_op>
      return -1;
80107aac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ab1:	e9 c0 00 00 00       	jmp    80107b76 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80107ab6:	e8 28 96 ff ff       	call   801010e3 <filealloc>
80107abb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107abe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107ac2:	74 17                	je     80107adb <sys_open+0x100>
80107ac4:	83 ec 0c             	sub    $0xc,%esp
80107ac7:	ff 75 f0             	pushl  -0x10(%ebp)
80107aca:	e8 37 f7 ff ff       	call   80107206 <fdalloc>
80107acf:	83 c4 10             	add    $0x10,%esp
80107ad2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107ad5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107ad9:	79 2e                	jns    80107b09 <sys_open+0x12e>
    if(f)
80107adb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107adf:	74 0e                	je     80107aef <sys_open+0x114>
      fileclose(f);
80107ae1:	83 ec 0c             	sub    $0xc,%esp
80107ae4:	ff 75 f0             	pushl  -0x10(%ebp)
80107ae7:	e8 b5 96 ff ff       	call   801011a1 <fileclose>
80107aec:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107aef:	83 ec 0c             	sub    $0xc,%esp
80107af2:	ff 75 f4             	pushl  -0xc(%ebp)
80107af5:	e8 ec a2 ff ff       	call   80101de6 <iunlockput>
80107afa:	83 c4 10             	add    $0x10,%esp
    end_op();
80107afd:	e8 08 be ff ff       	call   8010390a <end_op>
    return -1;
80107b02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b07:	eb 6d                	jmp    80107b76 <sys_open+0x19b>
  }
  iunlock(ip);
80107b09:	83 ec 0c             	sub    $0xc,%esp
80107b0c:	ff 75 f4             	pushl  -0xc(%ebp)
80107b0f:	e8 70 a1 ff ff       	call   80101c84 <iunlock>
80107b14:	83 c4 10             	add    $0x10,%esp
  end_op();
80107b17:	e8 ee bd ff ff       	call   8010390a <end_op>

  f->type = FD_INODE;
80107b1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b1f:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80107b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107b2b:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80107b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b31:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80107b38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b3b:	83 e0 01             	and    $0x1,%eax
80107b3e:	85 c0                	test   %eax,%eax
80107b40:	0f 94 c0             	sete   %al
80107b43:	89 c2                	mov    %eax,%edx
80107b45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b48:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80107b4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b4e:	83 e0 01             	and    $0x1,%eax
80107b51:	85 c0                	test   %eax,%eax
80107b53:	75 0a                	jne    80107b5f <sys_open+0x184>
80107b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107b58:	83 e0 02             	and    $0x2,%eax
80107b5b:	85 c0                	test   %eax,%eax
80107b5d:	74 07                	je     80107b66 <sys_open+0x18b>
80107b5f:	b8 01 00 00 00       	mov    $0x1,%eax
80107b64:	eb 05                	jmp    80107b6b <sys_open+0x190>
80107b66:	b8 00 00 00 00       	mov    $0x0,%eax
80107b6b:	89 c2                	mov    %eax,%edx
80107b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b70:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80107b73:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80107b76:	c9                   	leave  
80107b77:	c3                   	ret    

80107b78 <sys_mkdir>:

int
sys_mkdir(void)
{
80107b78:	55                   	push   %ebp
80107b79:	89 e5                	mov    %esp,%ebp
80107b7b:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107b7e:	e8 fb bc ff ff       	call   8010387e <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80107b83:	83 ec 08             	sub    $0x8,%esp
80107b86:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107b89:	50                   	push   %eax
80107b8a:	6a 00                	push   $0x0
80107b8c:	e8 49 f5 ff ff       	call   801070da <argstr>
80107b91:	83 c4 10             	add    $0x10,%esp
80107b94:	85 c0                	test   %eax,%eax
80107b96:	78 1b                	js     80107bb3 <sys_mkdir+0x3b>
80107b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b9b:	6a 00                	push   $0x0
80107b9d:	6a 00                	push   $0x0
80107b9f:	6a 01                	push   $0x1
80107ba1:	50                   	push   %eax
80107ba2:	e8 62 fc ff ff       	call   80107809 <create>
80107ba7:	83 c4 10             	add    $0x10,%esp
80107baa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107bad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107bb1:	75 0c                	jne    80107bbf <sys_mkdir+0x47>
    end_op();
80107bb3:	e8 52 bd ff ff       	call   8010390a <end_op>
    return -1;
80107bb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bbd:	eb 18                	jmp    80107bd7 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80107bbf:	83 ec 0c             	sub    $0xc,%esp
80107bc2:	ff 75 f4             	pushl  -0xc(%ebp)
80107bc5:	e8 1c a2 ff ff       	call   80101de6 <iunlockput>
80107bca:	83 c4 10             	add    $0x10,%esp
  end_op();
80107bcd:	e8 38 bd ff ff       	call   8010390a <end_op>
  return 0;
80107bd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107bd7:	c9                   	leave  
80107bd8:	c3                   	ret    

80107bd9 <sys_mknod>:

int
sys_mknod(void)
{
80107bd9:	55                   	push   %ebp
80107bda:	89 e5                	mov    %esp,%ebp
80107bdc:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107bdf:	e8 9a bc ff ff       	call   8010387e <begin_op>
  if((len=argstr(0, &path)) < 0 ||
80107be4:	83 ec 08             	sub    $0x8,%esp
80107be7:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107bea:	50                   	push   %eax
80107beb:	6a 00                	push   $0x0
80107bed:	e8 e8 f4 ff ff       	call   801070da <argstr>
80107bf2:	83 c4 10             	add    $0x10,%esp
80107bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107bf8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107bfc:	78 4f                	js     80107c4d <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107bfe:	83 ec 08             	sub    $0x8,%esp
80107c01:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107c04:	50                   	push   %eax
80107c05:	6a 01                	push   $0x1
80107c07:	e8 49 f4 ff ff       	call   80107055 <argint>
80107c0c:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107c0f:	85 c0                	test   %eax,%eax
80107c11:	78 3a                	js     80107c4d <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107c13:	83 ec 08             	sub    $0x8,%esp
80107c16:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107c19:	50                   	push   %eax
80107c1a:	6a 02                	push   $0x2
80107c1c:	e8 34 f4 ff ff       	call   80107055 <argint>
80107c21:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80107c24:	85 c0                	test   %eax,%eax
80107c26:	78 25                	js     80107c4d <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80107c28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c2b:	0f bf c8             	movswl %ax,%ecx
80107c2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c31:	0f bf d0             	movswl %ax,%edx
80107c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107c37:	51                   	push   %ecx
80107c38:	52                   	push   %edx
80107c39:	6a 03                	push   $0x3
80107c3b:	50                   	push   %eax
80107c3c:	e8 c8 fb ff ff       	call   80107809 <create>
80107c41:	83 c4 10             	add    $0x10,%esp
80107c44:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c47:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c4b:	75 0c                	jne    80107c59 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80107c4d:	e8 b8 bc ff ff       	call   8010390a <end_op>
    return -1;
80107c52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c57:	eb 18                	jmp    80107c71 <sys_mknod+0x98>
  }
  iunlockput(ip);
80107c59:	83 ec 0c             	sub    $0xc,%esp
80107c5c:	ff 75 f0             	pushl  -0x10(%ebp)
80107c5f:	e8 82 a1 ff ff       	call   80101de6 <iunlockput>
80107c64:	83 c4 10             	add    $0x10,%esp
  end_op();
80107c67:	e8 9e bc ff ff       	call   8010390a <end_op>
  return 0;
80107c6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107c71:	c9                   	leave  
80107c72:	c3                   	ret    

80107c73 <sys_chdir>:

int
sys_chdir(void)
{
80107c73:	55                   	push   %ebp
80107c74:	89 e5                	mov    %esp,%ebp
80107c76:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107c79:	e8 00 bc ff ff       	call   8010387e <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107c7e:	83 ec 08             	sub    $0x8,%esp
80107c81:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107c84:	50                   	push   %eax
80107c85:	6a 00                	push   $0x0
80107c87:	e8 4e f4 ff ff       	call   801070da <argstr>
80107c8c:	83 c4 10             	add    $0x10,%esp
80107c8f:	85 c0                	test   %eax,%eax
80107c91:	78 18                	js     80107cab <sys_chdir+0x38>
80107c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c96:	83 ec 0c             	sub    $0xc,%esp
80107c99:	50                   	push   %eax
80107c9a:	e8 6d aa ff ff       	call   8010270c <namei>
80107c9f:	83 c4 10             	add    $0x10,%esp
80107ca2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ca5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ca9:	75 0c                	jne    80107cb7 <sys_chdir+0x44>
    end_op();
80107cab:	e8 5a bc ff ff       	call   8010390a <end_op>
    return -1;
80107cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cb5:	eb 6e                	jmp    80107d25 <sys_chdir+0xb2>
  }
  ilock(ip);
80107cb7:	83 ec 0c             	sub    $0xc,%esp
80107cba:	ff 75 f4             	pushl  -0xc(%ebp)
80107cbd:	e8 3c 9e ff ff       	call   80101afe <ilock>
80107cc2:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc8:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107ccc:	66 83 f8 01          	cmp    $0x1,%ax
80107cd0:	74 1a                	je     80107cec <sys_chdir+0x79>
    iunlockput(ip);
80107cd2:	83 ec 0c             	sub    $0xc,%esp
80107cd5:	ff 75 f4             	pushl  -0xc(%ebp)
80107cd8:	e8 09 a1 ff ff       	call   80101de6 <iunlockput>
80107cdd:	83 c4 10             	add    $0x10,%esp
    end_op();
80107ce0:	e8 25 bc ff ff       	call   8010390a <end_op>
    return -1;
80107ce5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cea:	eb 39                	jmp    80107d25 <sys_chdir+0xb2>
  }
  iunlock(ip);
80107cec:	83 ec 0c             	sub    $0xc,%esp
80107cef:	ff 75 f4             	pushl  -0xc(%ebp)
80107cf2:	e8 8d 9f ff ff       	call   80101c84 <iunlock>
80107cf7:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107cfa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d00:	8b 40 68             	mov    0x68(%eax),%eax
80107d03:	83 ec 0c             	sub    $0xc,%esp
80107d06:	50                   	push   %eax
80107d07:	e8 ea 9f ff ff       	call   80101cf6 <iput>
80107d0c:	83 c4 10             	add    $0x10,%esp
  end_op();
80107d0f:	e8 f6 bb ff ff       	call   8010390a <end_op>
  proc->cwd = ip;
80107d14:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107d1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107d1d:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107d20:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d25:	c9                   	leave  
80107d26:	c3                   	ret    

80107d27 <sys_exec>:

int
sys_exec(void)
{
80107d27:	55                   	push   %ebp
80107d28:	89 e5                	mov    %esp,%ebp
80107d2a:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107d30:	83 ec 08             	sub    $0x8,%esp
80107d33:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d36:	50                   	push   %eax
80107d37:	6a 00                	push   $0x0
80107d39:	e8 9c f3 ff ff       	call   801070da <argstr>
80107d3e:	83 c4 10             	add    $0x10,%esp
80107d41:	85 c0                	test   %eax,%eax
80107d43:	78 18                	js     80107d5d <sys_exec+0x36>
80107d45:	83 ec 08             	sub    $0x8,%esp
80107d48:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107d4e:	50                   	push   %eax
80107d4f:	6a 01                	push   $0x1
80107d51:	e8 ff f2 ff ff       	call   80107055 <argint>
80107d56:	83 c4 10             	add    $0x10,%esp
80107d59:	85 c0                	test   %eax,%eax
80107d5b:	79 0a                	jns    80107d67 <sys_exec+0x40>
    return -1;
80107d5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d62:	e9 c6 00 00 00       	jmp    80107e2d <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80107d67:	83 ec 04             	sub    $0x4,%esp
80107d6a:	68 80 00 00 00       	push   $0x80
80107d6f:	6a 00                	push   $0x0
80107d71:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107d77:	50                   	push   %eax
80107d78:	e8 b3 ef ff ff       	call   80106d30 <memset>
80107d7d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80107d80:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d8a:	83 f8 1f             	cmp    $0x1f,%eax
80107d8d:	76 0a                	jbe    80107d99 <sys_exec+0x72>
      return -1;
80107d8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d94:	e9 94 00 00 00       	jmp    80107e2d <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9c:	c1 e0 02             	shl    $0x2,%eax
80107d9f:	89 c2                	mov    %eax,%edx
80107da1:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107da7:	01 c2                	add    %eax,%edx
80107da9:	83 ec 08             	sub    $0x8,%esp
80107dac:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107db2:	50                   	push   %eax
80107db3:	52                   	push   %edx
80107db4:	e8 00 f2 ff ff       	call   80106fb9 <fetchint>
80107db9:	83 c4 10             	add    $0x10,%esp
80107dbc:	85 c0                	test   %eax,%eax
80107dbe:	79 07                	jns    80107dc7 <sys_exec+0xa0>
      return -1;
80107dc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107dc5:	eb 66                	jmp    80107e2d <sys_exec+0x106>
    if(uarg == 0){
80107dc7:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107dcd:	85 c0                	test   %eax,%eax
80107dcf:	75 27                	jne    80107df8 <sys_exec+0xd1>
      argv[i] = 0;
80107dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dd4:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107ddb:	00 00 00 00 
      break;
80107ddf:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107de3:	83 ec 08             	sub    $0x8,%esp
80107de6:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107dec:	52                   	push   %edx
80107ded:	50                   	push   %eax
80107dee:	e8 2f 8e ff ff       	call   80100c22 <exec>
80107df3:	83 c4 10             	add    $0x10,%esp
80107df6:	eb 35                	jmp    80107e2d <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107df8:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107dfe:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107e01:	c1 e2 02             	shl    $0x2,%edx
80107e04:	01 c2                	add    %eax,%edx
80107e06:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107e0c:	83 ec 08             	sub    $0x8,%esp
80107e0f:	52                   	push   %edx
80107e10:	50                   	push   %eax
80107e11:	e8 dd f1 ff ff       	call   80106ff3 <fetchstr>
80107e16:	83 c4 10             	add    $0x10,%esp
80107e19:	85 c0                	test   %eax,%eax
80107e1b:	79 07                	jns    80107e24 <sys_exec+0xfd>
      return -1;
80107e1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e22:	eb 09                	jmp    80107e2d <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107e24:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80107e28:	e9 5a ff ff ff       	jmp    80107d87 <sys_exec+0x60>
  return exec(path, argv);
}
80107e2d:	c9                   	leave  
80107e2e:	c3                   	ret    

80107e2f <sys_pipe>:

int
sys_pipe(void)
{
80107e2f:	55                   	push   %ebp
80107e30:	89 e5                	mov    %esp,%ebp
80107e32:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107e35:	83 ec 04             	sub    $0x4,%esp
80107e38:	6a 08                	push   $0x8
80107e3a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107e3d:	50                   	push   %eax
80107e3e:	6a 00                	push   $0x0
80107e40:	e8 38 f2 ff ff       	call   8010707d <argptr>
80107e45:	83 c4 10             	add    $0x10,%esp
80107e48:	85 c0                	test   %eax,%eax
80107e4a:	79 0a                	jns    80107e56 <sys_pipe+0x27>
    return -1;
80107e4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e51:	e9 af 00 00 00       	jmp    80107f05 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107e56:	83 ec 08             	sub    $0x8,%esp
80107e59:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107e5c:	50                   	push   %eax
80107e5d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107e60:	50                   	push   %eax
80107e61:	e8 0c c5 ff ff       	call   80104372 <pipealloc>
80107e66:	83 c4 10             	add    $0x10,%esp
80107e69:	85 c0                	test   %eax,%eax
80107e6b:	79 0a                	jns    80107e77 <sys_pipe+0x48>
    return -1;
80107e6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e72:	e9 8e 00 00 00       	jmp    80107f05 <sys_pipe+0xd6>
  fd0 = -1;
80107e77:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107e7e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107e81:	83 ec 0c             	sub    $0xc,%esp
80107e84:	50                   	push   %eax
80107e85:	e8 7c f3 ff ff       	call   80107206 <fdalloc>
80107e8a:	83 c4 10             	add    $0x10,%esp
80107e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107e90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107e94:	78 18                	js     80107eae <sys_pipe+0x7f>
80107e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107e99:	83 ec 0c             	sub    $0xc,%esp
80107e9c:	50                   	push   %eax
80107e9d:	e8 64 f3 ff ff       	call   80107206 <fdalloc>
80107ea2:	83 c4 10             	add    $0x10,%esp
80107ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107ea8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107eac:	79 3f                	jns    80107eed <sys_pipe+0xbe>
    if(fd0 >= 0)
80107eae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107eb2:	78 14                	js     80107ec8 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107eb4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107eba:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107ebd:	83 c2 08             	add    $0x8,%edx
80107ec0:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107ec7:	00 
    fileclose(rf);
80107ec8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107ecb:	83 ec 0c             	sub    $0xc,%esp
80107ece:	50                   	push   %eax
80107ecf:	e8 cd 92 ff ff       	call   801011a1 <fileclose>
80107ed4:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107ed7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107eda:	83 ec 0c             	sub    $0xc,%esp
80107edd:	50                   	push   %eax
80107ede:	e8 be 92 ff ff       	call   801011a1 <fileclose>
80107ee3:	83 c4 10             	add    $0x10,%esp
    return -1;
80107ee6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107eeb:	eb 18                	jmp    80107f05 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107eed:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ef0:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107ef3:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107ef5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ef8:	8d 50 04             	lea    0x4(%eax),%edx
80107efb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107efe:	89 02                	mov    %eax,(%edx)
  return 0;
80107f00:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f05:	c9                   	leave  
80107f06:	c3                   	ret    

80107f07 <sys_chmod>:

#ifdef CS333_P5

// Kernel-side implementation of chmod()
int
sys_chmod(void) {
80107f07:	55                   	push   %ebp
80107f08:	89 e5                	mov    %esp,%ebp
80107f0a:	83 ec 18             	sub    $0x18,%esp
    char *path; // Pathname of file/dir
    int mode; // Updated mode argument
    // Grab path & mode from the stack
    if(argstr(0, &path) < 0) {
80107f0d:	83 ec 08             	sub    $0x8,%esp
80107f10:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f13:	50                   	push   %eax
80107f14:	6a 00                	push   $0x0
80107f16:	e8 bf f1 ff ff       	call   801070da <argstr>
80107f1b:	83 c4 10             	add    $0x10,%esp
80107f1e:	85 c0                	test   %eax,%eax
80107f20:	79 07                	jns    80107f29 <sys_chmod+0x22>
        return -1; // Bad path
80107f22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f27:	eb 47                	jmp    80107f70 <sys_chmod+0x69>
    }
    if (argint(1, &mode) < 0) {
80107f29:	83 ec 08             	sub    $0x8,%esp
80107f2c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107f2f:	50                   	push   %eax
80107f30:	6a 01                	push   $0x1
80107f32:	e8 1e f1 ff ff       	call   80107055 <argint>
80107f37:	83 c4 10             	add    $0x10,%esp
80107f3a:	85 c0                	test   %eax,%eax
80107f3c:	79 07                	jns    80107f45 <sys_chmod+0x3e>
        return -2; // Bad Mode
80107f3e:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80107f43:	eb 2b                	jmp    80107f70 <sys_chmod+0x69>
    }
    // Bounds checking for mode
    if (mode < 0 || mode > 1023) {
80107f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f48:	85 c0                	test   %eax,%eax
80107f4a:	78 0a                	js     80107f56 <sys_chmod+0x4f>
80107f4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f4f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
80107f54:	7e 07                	jle    80107f5d <sys_chmod+0x56>
        return -2;
80107f56:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80107f5b:	eb 13                	jmp    80107f70 <sys_chmod+0x69>
    }
    return chmod(path, mode);
80107f5d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107f60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f63:	83 ec 08             	sub    $0x8,%esp
80107f66:	52                   	push   %edx
80107f67:	50                   	push   %eax
80107f68:	e8 d6 a7 ff ff       	call   80102743 <chmod>
80107f6d:	83 c4 10             	add    $0x10,%esp
}
80107f70:	c9                   	leave  
80107f71:	c3                   	ret    

80107f72 <sys_chown>:

int
sys_chown(void) {
80107f72:	55                   	push   %ebp
80107f73:	89 e5                	mov    %esp,%ebp
80107f75:	83 ec 18             	sub    $0x18,%esp
    char *path;
    int owner;
    // Pull args off the stack
    if (argstr(0, &path) < 0) {
80107f78:	83 ec 08             	sub    $0x8,%esp
80107f7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f7e:	50                   	push   %eax
80107f7f:	6a 00                	push   $0x0
80107f81:	e8 54 f1 ff ff       	call   801070da <argstr>
80107f86:	83 c4 10             	add    $0x10,%esp
80107f89:	85 c0                	test   %eax,%eax
80107f8b:	79 07                	jns    80107f94 <sys_chown+0x22>
        return -1; // Bad path
80107f8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f92:	eb 47                	jmp    80107fdb <sys_chown+0x69>
    }
    if (argint(1, &owner) < 0) {
80107f94:	83 ec 08             	sub    $0x8,%esp
80107f97:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107f9a:	50                   	push   %eax
80107f9b:	6a 01                	push   $0x1
80107f9d:	e8 b3 f0 ff ff       	call   80107055 <argint>
80107fa2:	83 c4 10             	add    $0x10,%esp
80107fa5:	85 c0                	test   %eax,%eax
80107fa7:	79 07                	jns    80107fb0 <sys_chown+0x3e>
        return -2; // Bad UID
80107fa9:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80107fae:	eb 2b                	jmp    80107fdb <sys_chown+0x69>
    }
    // Bounds checking for UID
    if (owner < 0 || owner > 32767) {
80107fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fb3:	85 c0                	test   %eax,%eax
80107fb5:	78 0a                	js     80107fc1 <sys_chown+0x4f>
80107fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107fba:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107fbf:	7e 07                	jle    80107fc8 <sys_chown+0x56>
        return -2; // Bad UID
80107fc1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80107fc6:	eb 13                	jmp    80107fdb <sys_chown+0x69>
    }
    return chown(path, owner);
80107fc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fce:	83 ec 08             	sub    $0x8,%esp
80107fd1:	52                   	push   %edx
80107fd2:	50                   	push   %eax
80107fd3:	e8 d8 a7 ff ff       	call   801027b0 <chown>
80107fd8:	83 c4 10             	add    $0x10,%esp
}
80107fdb:	c9                   	leave  
80107fdc:	c3                   	ret    

80107fdd <sys_chgrp>:

int
sys_chgrp(void) {
80107fdd:	55                   	push   %ebp
80107fde:	89 e5                	mov    %esp,%ebp
80107fe0:	83 ec 18             	sub    $0x18,%esp
    char *path;
    int group;
    // Pull args off the stack
    if (argstr(0, &path) < 0) {
80107fe3:	83 ec 08             	sub    $0x8,%esp
80107fe6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107fe9:	50                   	push   %eax
80107fea:	6a 00                	push   $0x0
80107fec:	e8 e9 f0 ff ff       	call   801070da <argstr>
80107ff1:	83 c4 10             	add    $0x10,%esp
80107ff4:	85 c0                	test   %eax,%eax
80107ff6:	79 07                	jns    80107fff <sys_chgrp+0x22>
        return -1; // Bad Path
80107ff8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ffd:	eb 47                	jmp    80108046 <sys_chgrp+0x69>
    }
    if (argint(1, &group) < 0) {
80107fff:	83 ec 08             	sub    $0x8,%esp
80108002:	8d 45 f0             	lea    -0x10(%ebp),%eax
80108005:	50                   	push   %eax
80108006:	6a 01                	push   $0x1
80108008:	e8 48 f0 ff ff       	call   80107055 <argint>
8010800d:	83 c4 10             	add    $0x10,%esp
80108010:	85 c0                	test   %eax,%eax
80108012:	79 07                	jns    8010801b <sys_chgrp+0x3e>
        return -2; // Bad GID
80108014:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80108019:	eb 2b                	jmp    80108046 <sys_chgrp+0x69>
    }
    // Bounds checking for GID
    if (group < 0 || group > 32767) {
8010801b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010801e:	85 c0                	test   %eax,%eax
80108020:	78 0a                	js     8010802c <sys_chgrp+0x4f>
80108022:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108025:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
8010802a:	7e 07                	jle    80108033 <sys_chgrp+0x56>
        return -2;
8010802c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80108031:	eb 13                	jmp    80108046 <sys_chgrp+0x69>
    }
    return chgrp(path, group);
80108033:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108036:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108039:	83 ec 08             	sub    $0x8,%esp
8010803c:	52                   	push   %edx
8010803d:	50                   	push   %eax
8010803e:	e8 dd a7 ff ff       	call   80102820 <chgrp>
80108043:	83 c4 10             	add    $0x10,%esp
}
80108046:	c9                   	leave  
80108047:	c3                   	ret    

80108048 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80108048:	55                   	push   %ebp
80108049:	89 e5                	mov    %esp,%ebp
8010804b:	83 ec 08             	sub    $0x8,%esp
8010804e:	8b 55 08             	mov    0x8(%ebp),%edx
80108051:	8b 45 0c             	mov    0xc(%ebp),%eax
80108054:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80108058:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010805c:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80108060:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108064:	66 ef                	out    %ax,(%dx)
}
80108066:	90                   	nop
80108067:	c9                   	leave  
80108068:	c3                   	ret    

80108069 <sys_fork>:
#include "uproc.h"
#endif

int
sys_fork(void)
{
80108069:	55                   	push   %ebp
8010806a:	89 e5                	mov    %esp,%ebp
8010806c:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010806f:	e8 ee cb ff ff       	call   80104c62 <fork>
}
80108074:	c9                   	leave  
80108075:	c3                   	ret    

80108076 <sys_exit>:

int
sys_exit(void)
{
80108076:	55                   	push   %ebp
80108077:	89 e5                	mov    %esp,%ebp
80108079:	83 ec 08             	sub    $0x8,%esp
  exit();
8010807c:	e8 6b ce ff ff       	call   80104eec <exit>
  return 0;  // not reached
80108081:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108086:	c9                   	leave  
80108087:	c3                   	ret    

80108088 <sys_wait>:

int
sys_wait(void)
{
80108088:	55                   	push   %ebp
80108089:	89 e5                	mov    %esp,%ebp
8010808b:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010808e:	e8 31 d1 ff ff       	call   801051c4 <wait>
}
80108093:	c9                   	leave  
80108094:	c3                   	ret    

80108095 <sys_kill>:

int
sys_kill(void)
{
80108095:	55                   	push   %ebp
80108096:	89 e5                	mov    %esp,%ebp
80108098:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010809b:	83 ec 08             	sub    $0x8,%esp
8010809e:	8d 45 f4             	lea    -0xc(%ebp),%eax
801080a1:	50                   	push   %eax
801080a2:	6a 00                	push   $0x0
801080a4:	e8 ac ef ff ff       	call   80107055 <argint>
801080a9:	83 c4 10             	add    $0x10,%esp
801080ac:	85 c0                	test   %eax,%eax
801080ae:	79 07                	jns    801080b7 <sys_kill+0x22>
    return -1;
801080b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080b5:	eb 0f                	jmp    801080c6 <sys_kill+0x31>
  return kill(pid);
801080b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080ba:	83 ec 0c             	sub    $0xc,%esp
801080bd:	50                   	push   %eax
801080be:	e8 e7 d9 ff ff       	call   80105aaa <kill>
801080c3:	83 c4 10             	add    $0x10,%esp
}
801080c6:	c9                   	leave  
801080c7:	c3                   	ret    

801080c8 <sys_getpid>:

int
sys_getpid(void)
{
801080c8:	55                   	push   %ebp
801080c9:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801080cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801080d1:	8b 40 10             	mov    0x10(%eax),%eax
}
801080d4:	5d                   	pop    %ebp
801080d5:	c3                   	ret    

801080d6 <sys_sbrk>:

int
sys_sbrk(void)
{
801080d6:	55                   	push   %ebp
801080d7:	89 e5                	mov    %esp,%ebp
801080d9:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801080dc:	83 ec 08             	sub    $0x8,%esp
801080df:	8d 45 f0             	lea    -0x10(%ebp),%eax
801080e2:	50                   	push   %eax
801080e3:	6a 00                	push   $0x0
801080e5:	e8 6b ef ff ff       	call   80107055 <argint>
801080ea:	83 c4 10             	add    $0x10,%esp
801080ed:	85 c0                	test   %eax,%eax
801080ef:	79 07                	jns    801080f8 <sys_sbrk+0x22>
    return -1;
801080f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080f6:	eb 28                	jmp    80108120 <sys_sbrk+0x4a>
  addr = proc->sz;
801080f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801080fe:	8b 00                	mov    (%eax),%eax
80108100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80108103:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108106:	83 ec 0c             	sub    $0xc,%esp
80108109:	50                   	push   %eax
8010810a:	e8 b0 ca ff ff       	call   80104bbf <growproc>
8010810f:	83 c4 10             	add    $0x10,%esp
80108112:	85 c0                	test   %eax,%eax
80108114:	79 07                	jns    8010811d <sys_sbrk+0x47>
    return -1;
80108116:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010811b:	eb 03                	jmp    80108120 <sys_sbrk+0x4a>
  return addr;
8010811d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80108120:	c9                   	leave  
80108121:	c3                   	ret    

80108122 <sys_sleep>:

int
sys_sleep(void)
{
80108122:	55                   	push   %ebp
80108123:	89 e5                	mov    %esp,%ebp
80108125:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80108128:	83 ec 08             	sub    $0x8,%esp
8010812b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010812e:	50                   	push   %eax
8010812f:	6a 00                	push   $0x0
80108131:	e8 1f ef ff ff       	call   80107055 <argint>
80108136:	83 c4 10             	add    $0x10,%esp
80108139:	85 c0                	test   %eax,%eax
8010813b:	79 07                	jns    80108144 <sys_sleep+0x22>
    return -1;
8010813d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108142:	eb 44                	jmp    80108188 <sys_sleep+0x66>
  ticks0 = ticks;
80108144:	a1 00 89 11 80       	mov    0x80118900,%eax
80108149:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
8010814c:	eb 26                	jmp    80108174 <sys_sleep+0x52>
    if(proc->killed){
8010814e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108154:	8b 40 24             	mov    0x24(%eax),%eax
80108157:	85 c0                	test   %eax,%eax
80108159:	74 07                	je     80108162 <sys_sleep+0x40>
      return -1;
8010815b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108160:	eb 26                	jmp    80108188 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80108162:	83 ec 08             	sub    $0x8,%esp
80108165:	6a 00                	push   $0x0
80108167:	68 00 89 11 80       	push   $0x80118900
8010816c:	e8 a7 d6 ff ff       	call   80105818 <sleep>
80108171:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80108174:	a1 00 89 11 80       	mov    0x80118900,%eax
80108179:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010817c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010817f:	39 d0                	cmp    %edx,%eax
80108181:	72 cb                	jb     8010814e <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80108183:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108188:	c9                   	leave  
80108189:	c3                   	ret    

8010818a <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
8010818a:	55                   	push   %ebp
8010818b:	89 e5                	mov    %esp,%ebp
8010818d:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80108190:	a1 00 89 11 80       	mov    0x80118900,%eax
80108195:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80108198:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010819b:	c9                   	leave  
8010819c:	c3                   	ret    

8010819d <sys_halt>:

//Turn of the computer
int
sys_halt(void){
8010819d:	55                   	push   %ebp
8010819e:	89 e5                	mov    %esp,%ebp
801081a0:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
801081a3:	83 ec 0c             	sub    $0xc,%esp
801081a6:	68 f1 ae 10 80       	push   $0x8010aef1
801081ab:	e8 16 82 ff ff       	call   801003c6 <cprintf>
801081b0:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
801081b3:	83 ec 08             	sub    $0x8,%esp
801081b6:	68 00 20 00 00       	push   $0x2000
801081bb:	68 04 06 00 00       	push   $0x604
801081c0:	e8 83 fe ff ff       	call   80108048 <outw>
801081c5:	83 c4 10             	add    $0x10,%esp
  return 0;
801081c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801081cd:	c9                   	leave  
801081ce:	c3                   	ret    

801081cf <sys_date>:

#ifdef CS333_P1
int
sys_date(void) {
801081cf:	55                   	push   %ebp
801081d0:	89 e5                	mov    %esp,%ebp
801081d2:	83 ec 18             	sub    $0x18,%esp
    struct rtcdate *d;
    if (argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0) {
801081d5:	83 ec 04             	sub    $0x4,%esp
801081d8:	6a 18                	push   $0x18
801081da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801081dd:	50                   	push   %eax
801081de:	6a 00                	push   $0x0
801081e0:	e8 98 ee ff ff       	call   8010707d <argptr>
801081e5:	83 c4 10             	add    $0x10,%esp
801081e8:	85 c0                	test   %eax,%eax
801081ea:	79 07                	jns    801081f3 <sys_date+0x24>
        return -1;
801081ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801081f1:	eb 14                	jmp    80108207 <sys_date+0x38>
    } else {
        cmostime(d);
801081f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f6:	83 ec 0c             	sub    $0xc,%esp
801081f9:	50                   	push   %eax
801081fa:	e8 fa b2 ff ff       	call   801034f9 <cmostime>
801081ff:	83 c4 10             	add    $0x10,%esp
        return 0;
80108202:	b8 00 00 00 00       	mov    $0x0,%eax
    }
}
80108207:	c9                   	leave  
80108208:	c3                   	ret    

80108209 <sys_getuid>:

#ifdef CS333_P2

// return process UID
int
sys_getuid(void) {
80108209:	55                   	push   %ebp
8010820a:	89 e5                	mov    %esp,%ebp
    return proc->uid;
8010820c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108212:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80108218:	5d                   	pop    %ebp
80108219:	c3                   	ret    

8010821a <sys_getgid>:

// return process GID
int
sys_getgid(void) {
8010821a:	55                   	push   %ebp
8010821b:	89 e5                	mov    %esp,%ebp
    return proc->gid;
8010821d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108223:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80108229:	5d                   	pop    %ebp
8010822a:	c3                   	ret    

8010822b <sys_getppid>:

// return process parent's PID
int
sys_getppid(void) {
8010822b:	55                   	push   %ebp
8010822c:	89 e5                	mov    %esp,%ebp
    return proc->parent->pid;
8010822e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108234:	8b 40 14             	mov    0x14(%eax),%eax
80108237:	8b 40 10             	mov    0x10(%eax),%eax
}
8010823a:	5d                   	pop    %ebp
8010823b:	c3                   	ret    

8010823c <sys_setuid>:

// pull argument from stack, check range, set process UID
int
sys_setuid(void) {
8010823c:	55                   	push   %ebp
8010823d:	89 e5                	mov    %esp,%ebp
8010823f:	83 ec 18             	sub    $0x18,%esp
    int n;
    if (argint(0, &n) < 0) {
80108242:	83 ec 08             	sub    $0x8,%esp
80108245:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108248:	50                   	push   %eax
80108249:	6a 00                	push   $0x0
8010824b:	e8 05 ee ff ff       	call   80107055 <argint>
80108250:	83 c4 10             	add    $0x10,%esp
80108253:	85 c0                	test   %eax,%eax
80108255:	79 07                	jns    8010825e <sys_setuid+0x22>
        return -1;
80108257:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010825c:	eb 2c                	jmp    8010828a <sys_setuid+0x4e>
    }
    if (n < 0 || n > 32767) {
8010825e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108261:	85 c0                	test   %eax,%eax
80108263:	78 0a                	js     8010826f <sys_setuid+0x33>
80108265:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108268:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
8010826d:	7e 07                	jle    80108276 <sys_setuid+0x3a>
        return -1;
8010826f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108274:	eb 14                	jmp    8010828a <sys_setuid+0x4e>
    }
    proc->uid = n;
80108276:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010827c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010827f:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    return 0;
80108285:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010828a:	c9                   	leave  
8010828b:	c3                   	ret    

8010828c <sys_setgid>:

// pull argument from stack, check range, set process PID
int
sys_setgid(void) {
8010828c:	55                   	push   %ebp
8010828d:	89 e5                	mov    %esp,%ebp
8010828f:	83 ec 18             	sub    $0x18,%esp
    int n;
    if (argint(0, &n) < 0) {
80108292:	83 ec 08             	sub    $0x8,%esp
80108295:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108298:	50                   	push   %eax
80108299:	6a 00                	push   $0x0
8010829b:	e8 b5 ed ff ff       	call   80107055 <argint>
801082a0:	83 c4 10             	add    $0x10,%esp
801082a3:	85 c0                	test   %eax,%eax
801082a5:	79 07                	jns    801082ae <sys_setgid+0x22>
        return -1;
801082a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801082ac:	eb 2c                	jmp    801082da <sys_setgid+0x4e>
    }
    if (n < 0 || n > 32767) {
801082ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b1:	85 c0                	test   %eax,%eax
801082b3:	78 0a                	js     801082bf <sys_setgid+0x33>
801082b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b8:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801082bd:	7e 07                	jle    801082c6 <sys_setgid+0x3a>
        return -1;
801082bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801082c4:	eb 14                	jmp    801082da <sys_setgid+0x4e>
    }
    proc->gid = n;
801082c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801082cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801082cf:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
    return 0;
801082d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801082da:	c9                   	leave  
801082db:	c3                   	ret    

801082dc <sys_getprocs>:

// pull arguments from stack, pass to proc.c getprocs(uint, struct)
int
sys_getprocs(void) {
801082dc:	55                   	push   %ebp
801082dd:	89 e5                	mov    %esp,%ebp
801082df:	83 ec 18             	sub    $0x18,%esp
    int n;
    struct uproc *u;
    if (argint(0, &n) < 0) {
801082e2:	83 ec 08             	sub    $0x8,%esp
801082e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801082e8:	50                   	push   %eax
801082e9:	6a 00                	push   $0x0
801082eb:	e8 65 ed ff ff       	call   80107055 <argint>
801082f0:	83 c4 10             	add    $0x10,%esp
801082f3:	85 c0                	test   %eax,%eax
801082f5:	79 07                	jns    801082fe <sys_getprocs+0x22>
        return -1;
801082f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801082fc:	eb 3e                	jmp    8010833c <sys_getprocs+0x60>
    }
    // sizeof * MAX
    if (argptr(1, (void*)&u, (sizeof(struct uproc) * n)) < 0) {
801082fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108301:	89 c2                	mov    %eax,%edx
80108303:	89 d0                	mov    %edx,%eax
80108305:	01 c0                	add    %eax,%eax
80108307:	01 d0                	add    %edx,%eax
80108309:	c1 e0 05             	shl    $0x5,%eax
8010830c:	83 ec 04             	sub    $0x4,%esp
8010830f:	50                   	push   %eax
80108310:	8d 45 f0             	lea    -0x10(%ebp),%eax
80108313:	50                   	push   %eax
80108314:	6a 01                	push   $0x1
80108316:	e8 62 ed ff ff       	call   8010707d <argptr>
8010831b:	83 c4 10             	add    $0x10,%esp
8010831e:	85 c0                	test   %eax,%eax
80108320:	79 07                	jns    80108329 <sys_getprocs+0x4d>
        return -1;
80108322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108327:	eb 13                	jmp    8010833c <sys_getprocs+0x60>
    }
    return getprocs(n, u);
80108329:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010832c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010832f:	83 ec 08             	sub    $0x8,%esp
80108332:	50                   	push   %eax
80108333:	52                   	push   %edx
80108334:	e8 93 dc ff ff       	call   80105fcc <getprocs>
80108339:	83 c4 10             	add    $0x10,%esp
}
8010833c:	c9                   	leave  
8010833d:	c3                   	ret    

8010833e <sys_setpriority>:
#endif

#ifdef CS333_P3P4
int
sys_setpriority(void) {
8010833e:	55                   	push   %ebp
8010833f:	89 e5                	mov    %esp,%ebp
80108341:	83 ec 18             	sub    $0x18,%esp
    int n, i;
    // PID argument from stack
    if (argint(0, &n) < 0) {
80108344:	83 ec 08             	sub    $0x8,%esp
80108347:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010834a:	50                   	push   %eax
8010834b:	6a 00                	push   $0x0
8010834d:	e8 03 ed ff ff       	call   80107055 <argint>
80108352:	83 c4 10             	add    $0x10,%esp
80108355:	85 c0                	test   %eax,%eax
80108357:	79 07                	jns    80108360 <sys_setpriority+0x22>
        return -1;
80108359:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010835e:	eb 5d                	jmp    801083bd <sys_setpriority+0x7f>
    }
    // priority argument
    if (argint(1, &i) < 0) {
80108360:	83 ec 08             	sub    $0x8,%esp
80108363:	8d 45 f0             	lea    -0x10(%ebp),%eax
80108366:	50                   	push   %eax
80108367:	6a 01                	push   $0x1
80108369:	e8 e7 ec ff ff       	call   80107055 <argint>
8010836e:	83 c4 10             	add    $0x10,%esp
80108371:	85 c0                	test   %eax,%eax
80108373:	79 07                	jns    8010837c <sys_setpriority+0x3e>
        return -1;
80108375:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010837a:	eb 41                	jmp    801083bd <sys_setpriority+0x7f>
    }
    // check bounds of PID argument
    if (n < 0 || n > 32767) {
8010837c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837f:	85 c0                	test   %eax,%eax
80108381:	78 0a                	js     8010838d <sys_setpriority+0x4f>
80108383:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108386:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
8010838b:	7e 07                	jle    80108394 <sys_setpriority+0x56>
        return -1;
8010838d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108392:	eb 29                	jmp    801083bd <sys_setpriority+0x7f>
    }
    // check bounds of priority argument
    if (i < 0 || i > MAX) {
80108394:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108397:	85 c0                	test   %eax,%eax
80108399:	78 08                	js     801083a3 <sys_setpriority+0x65>
8010839b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010839e:	83 f8 02             	cmp    $0x2,%eax
801083a1:	7e 07                	jle    801083aa <sys_setpriority+0x6c>
        return -1;
801083a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801083a8:	eb 13                	jmp    801083bd <sys_setpriority+0x7f>
    }
    return setpriority(n, i); // pass to user-side
801083aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
801083ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083b0:	83 ec 08             	sub    $0x8,%esp
801083b3:	52                   	push   %edx
801083b4:	50                   	push   %eax
801083b5:	e8 c0 e4 ff ff       	call   8010687a <setpriority>
801083ba:	83 c4 10             	add    $0x10,%esp
}
801083bd:	c9                   	leave  
801083be:	c3                   	ret    

801083bf <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801083bf:	55                   	push   %ebp
801083c0:	89 e5                	mov    %esp,%ebp
801083c2:	83 ec 08             	sub    $0x8,%esp
801083c5:	8b 55 08             	mov    0x8(%ebp),%edx
801083c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801083cb:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801083cf:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801083d2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801083d6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801083da:	ee                   	out    %al,(%dx)
}
801083db:	90                   	nop
801083dc:	c9                   	leave  
801083dd:	c3                   	ret    

801083de <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801083de:	55                   	push   %ebp
801083df:	89 e5                	mov    %esp,%ebp
801083e1:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801083e4:	6a 34                	push   $0x34
801083e6:	6a 43                	push   $0x43
801083e8:	e8 d2 ff ff ff       	call   801083bf <outb>
801083ed:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
801083f0:	68 a9 00 00 00       	push   $0xa9
801083f5:	6a 40                	push   $0x40
801083f7:	e8 c3 ff ff ff       	call   801083bf <outb>
801083fc:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
801083ff:	6a 04                	push   $0x4
80108401:	6a 40                	push   $0x40
80108403:	e8 b7 ff ff ff       	call   801083bf <outb>
80108408:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
8010840b:	83 ec 0c             	sub    $0xc,%esp
8010840e:	6a 00                	push   $0x0
80108410:	e8 47 be ff ff       	call   8010425c <picenable>
80108415:	83 c4 10             	add    $0x10,%esp
}
80108418:	90                   	nop
80108419:	c9                   	leave  
8010841a:	c3                   	ret    

8010841b <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010841b:	1e                   	push   %ds
  pushl %es
8010841c:	06                   	push   %es
  pushl %fs
8010841d:	0f a0                	push   %fs
  pushl %gs
8010841f:	0f a8                	push   %gs
  pushal
80108421:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80108422:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80108426:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80108428:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010842a:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
8010842e:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80108430:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80108432:	54                   	push   %esp
  call trap
80108433:	e8 ce 01 00 00       	call   80108606 <trap>
  addl $4, %esp
80108438:	83 c4 04             	add    $0x4,%esp

8010843b <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010843b:	61                   	popa   
  popl %gs
8010843c:	0f a9                	pop    %gs
  popl %fs
8010843e:	0f a1                	pop    %fs
  popl %es
80108440:	07                   	pop    %es
  popl %ds
80108441:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80108442:	83 c4 08             	add    $0x8,%esp
  iret
80108445:	cf                   	iret   

80108446 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
80108446:	55                   	push   %ebp
80108447:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
80108449:	8b 45 08             	mov    0x8(%ebp),%eax
8010844c:	f0 ff 00             	lock incl (%eax)
}
8010844f:	90                   	nop
80108450:	5d                   	pop    %ebp
80108451:	c3                   	ret    

80108452 <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80108452:	55                   	push   %ebp
80108453:	89 e5                	mov    %esp,%ebp
80108455:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80108458:	8b 45 0c             	mov    0xc(%ebp),%eax
8010845b:	83 e8 01             	sub    $0x1,%eax
8010845e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80108462:	8b 45 08             	mov    0x8(%ebp),%eax
80108465:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108469:	8b 45 08             	mov    0x8(%ebp),%eax
8010846c:	c1 e8 10             	shr    $0x10,%eax
8010846f:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80108473:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108476:	0f 01 18             	lidtl  (%eax)
}
80108479:	90                   	nop
8010847a:	c9                   	leave  
8010847b:	c3                   	ret    

8010847c <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
8010847c:	55                   	push   %ebp
8010847d:	89 e5                	mov    %esp,%ebp
8010847f:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80108482:	0f 20 d0             	mov    %cr2,%eax
80108485:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80108488:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010848b:	c9                   	leave  
8010848c:	c3                   	ret    

8010848d <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
8010848d:	55                   	push   %ebp
8010848e:	89 e5                	mov    %esp,%ebp
80108490:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
80108493:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010849a:	e9 c3 00 00 00       	jmp    80108562 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010849f:	8b 45 fc             	mov    -0x4(%ebp),%eax
801084a2:	8b 04 85 c8 e0 10 80 	mov    -0x7fef1f38(,%eax,4),%eax
801084a9:	89 c2                	mov    %eax,%edx
801084ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
801084ae:	66 89 14 c5 00 81 11 	mov    %dx,-0x7fee7f00(,%eax,8)
801084b5:	80 
801084b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801084b9:	66 c7 04 c5 02 81 11 	movw   $0x8,-0x7fee7efe(,%eax,8)
801084c0:	80 08 00 
801084c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801084c6:	0f b6 14 c5 04 81 11 	movzbl -0x7fee7efc(,%eax,8),%edx
801084cd:	80 
801084ce:	83 e2 e0             	and    $0xffffffe0,%edx
801084d1:	88 14 c5 04 81 11 80 	mov    %dl,-0x7fee7efc(,%eax,8)
801084d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801084db:	0f b6 14 c5 04 81 11 	movzbl -0x7fee7efc(,%eax,8),%edx
801084e2:	80 
801084e3:	83 e2 1f             	and    $0x1f,%edx
801084e6:	88 14 c5 04 81 11 80 	mov    %dl,-0x7fee7efc(,%eax,8)
801084ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
801084f0:	0f b6 14 c5 05 81 11 	movzbl -0x7fee7efb(,%eax,8),%edx
801084f7:	80 
801084f8:	83 e2 f0             	and    $0xfffffff0,%edx
801084fb:	83 ca 0e             	or     $0xe,%edx
801084fe:	88 14 c5 05 81 11 80 	mov    %dl,-0x7fee7efb(,%eax,8)
80108505:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108508:	0f b6 14 c5 05 81 11 	movzbl -0x7fee7efb(,%eax,8),%edx
8010850f:	80 
80108510:	83 e2 ef             	and    $0xffffffef,%edx
80108513:	88 14 c5 05 81 11 80 	mov    %dl,-0x7fee7efb(,%eax,8)
8010851a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010851d:	0f b6 14 c5 05 81 11 	movzbl -0x7fee7efb(,%eax,8),%edx
80108524:	80 
80108525:	83 e2 9f             	and    $0xffffff9f,%edx
80108528:	88 14 c5 05 81 11 80 	mov    %dl,-0x7fee7efb(,%eax,8)
8010852f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108532:	0f b6 14 c5 05 81 11 	movzbl -0x7fee7efb(,%eax,8),%edx
80108539:	80 
8010853a:	83 ca 80             	or     $0xffffff80,%edx
8010853d:	88 14 c5 05 81 11 80 	mov    %dl,-0x7fee7efb(,%eax,8)
80108544:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108547:	8b 04 85 c8 e0 10 80 	mov    -0x7fef1f38(,%eax,4),%eax
8010854e:	c1 e8 10             	shr    $0x10,%eax
80108551:	89 c2                	mov    %eax,%edx
80108553:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108556:	66 89 14 c5 06 81 11 	mov    %dx,-0x7fee7efa(,%eax,8)
8010855d:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010855e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80108562:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80108569:	0f 8e 30 ff ff ff    	jle    8010849f <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010856f:	a1 c8 e1 10 80       	mov    0x8010e1c8,%eax
80108574:	66 a3 00 83 11 80    	mov    %ax,0x80118300
8010857a:	66 c7 05 02 83 11 80 	movw   $0x8,0x80118302
80108581:	08 00 
80108583:	0f b6 05 04 83 11 80 	movzbl 0x80118304,%eax
8010858a:	83 e0 e0             	and    $0xffffffe0,%eax
8010858d:	a2 04 83 11 80       	mov    %al,0x80118304
80108592:	0f b6 05 04 83 11 80 	movzbl 0x80118304,%eax
80108599:	83 e0 1f             	and    $0x1f,%eax
8010859c:	a2 04 83 11 80       	mov    %al,0x80118304
801085a1:	0f b6 05 05 83 11 80 	movzbl 0x80118305,%eax
801085a8:	83 c8 0f             	or     $0xf,%eax
801085ab:	a2 05 83 11 80       	mov    %al,0x80118305
801085b0:	0f b6 05 05 83 11 80 	movzbl 0x80118305,%eax
801085b7:	83 e0 ef             	and    $0xffffffef,%eax
801085ba:	a2 05 83 11 80       	mov    %al,0x80118305
801085bf:	0f b6 05 05 83 11 80 	movzbl 0x80118305,%eax
801085c6:	83 c8 60             	or     $0x60,%eax
801085c9:	a2 05 83 11 80       	mov    %al,0x80118305
801085ce:	0f b6 05 05 83 11 80 	movzbl 0x80118305,%eax
801085d5:	83 c8 80             	or     $0xffffff80,%eax
801085d8:	a2 05 83 11 80       	mov    %al,0x80118305
801085dd:	a1 c8 e1 10 80       	mov    0x8010e1c8,%eax
801085e2:	c1 e8 10             	shr    $0x10,%eax
801085e5:	66 a3 06 83 11 80    	mov    %ax,0x80118306
  
}
801085eb:	90                   	nop
801085ec:	c9                   	leave  
801085ed:	c3                   	ret    

801085ee <idtinit>:

void
idtinit(void)
{
801085ee:	55                   	push   %ebp
801085ef:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
801085f1:	68 00 08 00 00       	push   $0x800
801085f6:	68 00 81 11 80       	push   $0x80118100
801085fb:	e8 52 fe ff ff       	call   80108452 <lidt>
80108600:	83 c4 08             	add    $0x8,%esp
}
80108603:	90                   	nop
80108604:	c9                   	leave  
80108605:	c3                   	ret    

80108606 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80108606:	55                   	push   %ebp
80108607:	89 e5                	mov    %esp,%ebp
80108609:	57                   	push   %edi
8010860a:	56                   	push   %esi
8010860b:	53                   	push   %ebx
8010860c:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
8010860f:	8b 45 08             	mov    0x8(%ebp),%eax
80108612:	8b 40 30             	mov    0x30(%eax),%eax
80108615:	83 f8 40             	cmp    $0x40,%eax
80108618:	75 3e                	jne    80108658 <trap+0x52>
    if(proc->killed)
8010861a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108620:	8b 40 24             	mov    0x24(%eax),%eax
80108623:	85 c0                	test   %eax,%eax
80108625:	74 05                	je     8010862c <trap+0x26>
      exit();
80108627:	e8 c0 c8 ff ff       	call   80104eec <exit>
    proc->tf = tf;
8010862c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108632:	8b 55 08             	mov    0x8(%ebp),%edx
80108635:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80108638:	e8 ce ea ff ff       	call   8010710b <syscall>
    if(proc->killed)
8010863d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108643:	8b 40 24             	mov    0x24(%eax),%eax
80108646:	85 c0                	test   %eax,%eax
80108648:	0f 84 21 02 00 00    	je     8010886f <trap+0x269>
      exit();
8010864e:	e8 99 c8 ff ff       	call   80104eec <exit>
    return;
80108653:	e9 17 02 00 00       	jmp    8010886f <trap+0x269>
  }

  switch(tf->trapno){
80108658:	8b 45 08             	mov    0x8(%ebp),%eax
8010865b:	8b 40 30             	mov    0x30(%eax),%eax
8010865e:	83 e8 20             	sub    $0x20,%eax
80108661:	83 f8 1f             	cmp    $0x1f,%eax
80108664:	0f 87 a3 00 00 00    	ja     8010870d <trap+0x107>
8010866a:	8b 04 85 a4 af 10 80 	mov    -0x7fef505c(,%eax,4),%eax
80108671:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
80108673:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108679:	0f b6 00             	movzbl (%eax),%eax
8010867c:	84 c0                	test   %al,%al
8010867e:	75 20                	jne    801086a0 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80108680:	83 ec 0c             	sub    $0xc,%esp
80108683:	68 00 89 11 80       	push   $0x80118900
80108688:	e8 b9 fd ff ff       	call   80108446 <atom_inc>
8010868d:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80108690:	83 ec 0c             	sub    $0xc,%esp
80108693:	68 00 89 11 80       	push   $0x80118900
80108698:	e8 d6 d3 ff ff       	call   80105a73 <wakeup>
8010869d:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
801086a0:	e8 b1 ac ff ff       	call   80103356 <lapiceoi>
    break;
801086a5:	e9 1c 01 00 00       	jmp    801087c6 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801086aa:	e8 ba a4 ff ff       	call   80102b69 <ideintr>
    lapiceoi();
801086af:	e8 a2 ac ff ff       	call   80103356 <lapiceoi>
    break;
801086b4:	e9 0d 01 00 00       	jmp    801087c6 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801086b9:	e8 9a aa ff ff       	call   80103158 <kbdintr>
    lapiceoi();
801086be:	e8 93 ac ff ff       	call   80103356 <lapiceoi>
    break;
801086c3:	e9 fe 00 00 00       	jmp    801087c6 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801086c8:	e8 83 03 00 00       	call   80108a50 <uartintr>
    lapiceoi();
801086cd:	e8 84 ac ff ff       	call   80103356 <lapiceoi>
    break;
801086d2:	e9 ef 00 00 00       	jmp    801087c6 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801086d7:	8b 45 08             	mov    0x8(%ebp),%eax
801086da:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801086dd:	8b 45 08             	mov    0x8(%ebp),%eax
801086e0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801086e4:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801086e7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086ed:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801086f0:	0f b6 c0             	movzbl %al,%eax
801086f3:	51                   	push   %ecx
801086f4:	52                   	push   %edx
801086f5:	50                   	push   %eax
801086f6:	68 04 af 10 80       	push   $0x8010af04
801086fb:	e8 c6 7c ff ff       	call   801003c6 <cprintf>
80108700:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80108703:	e8 4e ac ff ff       	call   80103356 <lapiceoi>
    break;
80108708:	e9 b9 00 00 00       	jmp    801087c6 <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010870d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108713:	85 c0                	test   %eax,%eax
80108715:	74 11                	je     80108728 <trap+0x122>
80108717:	8b 45 08             	mov    0x8(%ebp),%eax
8010871a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010871e:	0f b7 c0             	movzwl %ax,%eax
80108721:	83 e0 03             	and    $0x3,%eax
80108724:	85 c0                	test   %eax,%eax
80108726:	75 40                	jne    80108768 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80108728:	e8 4f fd ff ff       	call   8010847c <rcr2>
8010872d:	89 c3                	mov    %eax,%ebx
8010872f:	8b 45 08             	mov    0x8(%ebp),%eax
80108732:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
80108735:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010873b:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010873e:	0f b6 d0             	movzbl %al,%edx
80108741:	8b 45 08             	mov    0x8(%ebp),%eax
80108744:	8b 40 30             	mov    0x30(%eax),%eax
80108747:	83 ec 0c             	sub    $0xc,%esp
8010874a:	53                   	push   %ebx
8010874b:	51                   	push   %ecx
8010874c:	52                   	push   %edx
8010874d:	50                   	push   %eax
8010874e:	68 28 af 10 80       	push   $0x8010af28
80108753:	e8 6e 7c ff ff       	call   801003c6 <cprintf>
80108758:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
8010875b:	83 ec 0c             	sub    $0xc,%esp
8010875e:	68 5a af 10 80       	push   $0x8010af5a
80108763:	e8 fe 7d ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108768:	e8 0f fd ff ff       	call   8010847c <rcr2>
8010876d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108770:	8b 45 08             	mov    0x8(%ebp),%eax
80108773:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80108776:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010877c:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010877f:	0f b6 d8             	movzbl %al,%ebx
80108782:	8b 45 08             	mov    0x8(%ebp),%eax
80108785:	8b 48 34             	mov    0x34(%eax),%ecx
80108788:	8b 45 08             	mov    0x8(%ebp),%eax
8010878b:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010878e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108794:	8d 78 6c             	lea    0x6c(%eax),%edi
80108797:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010879d:	8b 40 10             	mov    0x10(%eax),%eax
801087a0:	ff 75 e4             	pushl  -0x1c(%ebp)
801087a3:	56                   	push   %esi
801087a4:	53                   	push   %ebx
801087a5:	51                   	push   %ecx
801087a6:	52                   	push   %edx
801087a7:	57                   	push   %edi
801087a8:	50                   	push   %eax
801087a9:	68 60 af 10 80       	push   $0x8010af60
801087ae:	e8 13 7c ff ff       	call   801003c6 <cprintf>
801087b3:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801087b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801087bc:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801087c3:	eb 01                	jmp    801087c6 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801087c5:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801087c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801087cc:	85 c0                	test   %eax,%eax
801087ce:	74 24                	je     801087f4 <trap+0x1ee>
801087d0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801087d6:	8b 40 24             	mov    0x24(%eax),%eax
801087d9:	85 c0                	test   %eax,%eax
801087db:	74 17                	je     801087f4 <trap+0x1ee>
801087dd:	8b 45 08             	mov    0x8(%ebp),%eax
801087e0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801087e4:	0f b7 c0             	movzwl %ax,%eax
801087e7:	83 e0 03             	and    $0x3,%eax
801087ea:	83 f8 03             	cmp    $0x3,%eax
801087ed:	75 05                	jne    801087f4 <trap+0x1ee>
    exit();
801087ef:	e8 f8 c6 ff ff       	call   80104eec <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
801087f4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801087fa:	85 c0                	test   %eax,%eax
801087fc:	74 41                	je     8010883f <trap+0x239>
801087fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108804:	8b 40 0c             	mov    0xc(%eax),%eax
80108807:	83 f8 04             	cmp    $0x4,%eax
8010880a:	75 33                	jne    8010883f <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
8010880c:	8b 45 08             	mov    0x8(%ebp),%eax
8010880f:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80108812:	83 f8 20             	cmp    $0x20,%eax
80108815:	75 28                	jne    8010883f <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
80108817:	8b 0d 00 89 11 80    	mov    0x80118900,%ecx
8010881d:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80108822:	89 c8                	mov    %ecx,%eax
80108824:	f7 e2                	mul    %edx
80108826:	c1 ea 03             	shr    $0x3,%edx
80108829:	89 d0                	mov    %edx,%eax
8010882b:	c1 e0 02             	shl    $0x2,%eax
8010882e:	01 d0                	add    %edx,%eax
80108830:	01 c0                	add    %eax,%eax
80108832:	29 c1                	sub    %eax,%ecx
80108834:	89 ca                	mov    %ecx,%edx
80108836:	85 d2                	test   %edx,%edx
80108838:	75 05                	jne    8010883f <trap+0x239>
    yield();
8010883a:	e8 55 ce ff ff       	call   80105694 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010883f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108845:	85 c0                	test   %eax,%eax
80108847:	74 27                	je     80108870 <trap+0x26a>
80108849:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010884f:	8b 40 24             	mov    0x24(%eax),%eax
80108852:	85 c0                	test   %eax,%eax
80108854:	74 1a                	je     80108870 <trap+0x26a>
80108856:	8b 45 08             	mov    0x8(%ebp),%eax
80108859:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010885d:	0f b7 c0             	movzwl %ax,%eax
80108860:	83 e0 03             	and    $0x3,%eax
80108863:	83 f8 03             	cmp    $0x3,%eax
80108866:	75 08                	jne    80108870 <trap+0x26a>
    exit();
80108868:	e8 7f c6 ff ff       	call   80104eec <exit>
8010886d:	eb 01                	jmp    80108870 <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
8010886f:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80108870:	8d 65 f4             	lea    -0xc(%ebp),%esp
80108873:	5b                   	pop    %ebx
80108874:	5e                   	pop    %esi
80108875:	5f                   	pop    %edi
80108876:	5d                   	pop    %ebp
80108877:	c3                   	ret    

80108878 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80108878:	55                   	push   %ebp
80108879:	89 e5                	mov    %esp,%ebp
8010887b:	83 ec 14             	sub    $0x14,%esp
8010887e:	8b 45 08             	mov    0x8(%ebp),%eax
80108881:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80108885:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80108889:	89 c2                	mov    %eax,%edx
8010888b:	ec                   	in     (%dx),%al
8010888c:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010888f:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80108893:	c9                   	leave  
80108894:	c3                   	ret    

80108895 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80108895:	55                   	push   %ebp
80108896:	89 e5                	mov    %esp,%ebp
80108898:	83 ec 08             	sub    $0x8,%esp
8010889b:	8b 55 08             	mov    0x8(%ebp),%edx
8010889e:	8b 45 0c             	mov    0xc(%ebp),%eax
801088a1:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801088a5:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801088a8:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801088ac:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801088b0:	ee                   	out    %al,(%dx)
}
801088b1:	90                   	nop
801088b2:	c9                   	leave  
801088b3:	c3                   	ret    

801088b4 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801088b4:	55                   	push   %ebp
801088b5:	89 e5                	mov    %esp,%ebp
801088b7:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
801088ba:	6a 00                	push   $0x0
801088bc:	68 fa 03 00 00       	push   $0x3fa
801088c1:	e8 cf ff ff ff       	call   80108895 <outb>
801088c6:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801088c9:	68 80 00 00 00       	push   $0x80
801088ce:	68 fb 03 00 00       	push   $0x3fb
801088d3:	e8 bd ff ff ff       	call   80108895 <outb>
801088d8:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
801088db:	6a 0c                	push   $0xc
801088dd:	68 f8 03 00 00       	push   $0x3f8
801088e2:	e8 ae ff ff ff       	call   80108895 <outb>
801088e7:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
801088ea:	6a 00                	push   $0x0
801088ec:	68 f9 03 00 00       	push   $0x3f9
801088f1:	e8 9f ff ff ff       	call   80108895 <outb>
801088f6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801088f9:	6a 03                	push   $0x3
801088fb:	68 fb 03 00 00       	push   $0x3fb
80108900:	e8 90 ff ff ff       	call   80108895 <outb>
80108905:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80108908:	6a 00                	push   $0x0
8010890a:	68 fc 03 00 00       	push   $0x3fc
8010890f:	e8 81 ff ff ff       	call   80108895 <outb>
80108914:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80108917:	6a 01                	push   $0x1
80108919:	68 f9 03 00 00       	push   $0x3f9
8010891e:	e8 72 ff ff ff       	call   80108895 <outb>
80108923:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80108926:	68 fd 03 00 00       	push   $0x3fd
8010892b:	e8 48 ff ff ff       	call   80108878 <inb>
80108930:	83 c4 04             	add    $0x4,%esp
80108933:	3c ff                	cmp    $0xff,%al
80108935:	74 6e                	je     801089a5 <uartinit+0xf1>
    return;
  uart = 1;
80108937:	c7 05 8c e6 10 80 01 	movl   $0x1,0x8010e68c
8010893e:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80108941:	68 fa 03 00 00       	push   $0x3fa
80108946:	e8 2d ff ff ff       	call   80108878 <inb>
8010894b:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
8010894e:	68 f8 03 00 00       	push   $0x3f8
80108953:	e8 20 ff ff ff       	call   80108878 <inb>
80108958:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
8010895b:	83 ec 0c             	sub    $0xc,%esp
8010895e:	6a 04                	push   $0x4
80108960:	e8 f7 b8 ff ff       	call   8010425c <picenable>
80108965:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80108968:	83 ec 08             	sub    $0x8,%esp
8010896b:	6a 00                	push   $0x0
8010896d:	6a 04                	push   $0x4
8010896f:	e8 97 a4 ff ff       	call   80102e0b <ioapicenable>
80108974:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80108977:	c7 45 f4 24 b0 10 80 	movl   $0x8010b024,-0xc(%ebp)
8010897e:	eb 19                	jmp    80108999 <uartinit+0xe5>
    uartputc(*p);
80108980:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108983:	0f b6 00             	movzbl (%eax),%eax
80108986:	0f be c0             	movsbl %al,%eax
80108989:	83 ec 0c             	sub    $0xc,%esp
8010898c:	50                   	push   %eax
8010898d:	e8 16 00 00 00       	call   801089a8 <uartputc>
80108992:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80108995:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108999:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010899c:	0f b6 00             	movzbl (%eax),%eax
8010899f:	84 c0                	test   %al,%al
801089a1:	75 dd                	jne    80108980 <uartinit+0xcc>
801089a3:	eb 01                	jmp    801089a6 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
801089a5:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
801089a6:	c9                   	leave  
801089a7:	c3                   	ret    

801089a8 <uartputc>:

void
uartputc(int c)
{
801089a8:	55                   	push   %ebp
801089a9:	89 e5                	mov    %esp,%ebp
801089ab:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
801089ae:	a1 8c e6 10 80       	mov    0x8010e68c,%eax
801089b3:	85 c0                	test   %eax,%eax
801089b5:	74 53                	je     80108a0a <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801089b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801089be:	eb 11                	jmp    801089d1 <uartputc+0x29>
    microdelay(10);
801089c0:	83 ec 0c             	sub    $0xc,%esp
801089c3:	6a 0a                	push   $0xa
801089c5:	e8 a7 a9 ff ff       	call   80103371 <microdelay>
801089ca:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801089cd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801089d1:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801089d5:	7f 1a                	jg     801089f1 <uartputc+0x49>
801089d7:	83 ec 0c             	sub    $0xc,%esp
801089da:	68 fd 03 00 00       	push   $0x3fd
801089df:	e8 94 fe ff ff       	call   80108878 <inb>
801089e4:	83 c4 10             	add    $0x10,%esp
801089e7:	0f b6 c0             	movzbl %al,%eax
801089ea:	83 e0 20             	and    $0x20,%eax
801089ed:	85 c0                	test   %eax,%eax
801089ef:	74 cf                	je     801089c0 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
801089f1:	8b 45 08             	mov    0x8(%ebp),%eax
801089f4:	0f b6 c0             	movzbl %al,%eax
801089f7:	83 ec 08             	sub    $0x8,%esp
801089fa:	50                   	push   %eax
801089fb:	68 f8 03 00 00       	push   $0x3f8
80108a00:	e8 90 fe ff ff       	call   80108895 <outb>
80108a05:	83 c4 10             	add    $0x10,%esp
80108a08:	eb 01                	jmp    80108a0b <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80108a0a:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80108a0b:	c9                   	leave  
80108a0c:	c3                   	ret    

80108a0d <uartgetc>:

static int
uartgetc(void)
{
80108a0d:	55                   	push   %ebp
80108a0e:	89 e5                	mov    %esp,%ebp
  if(!uart)
80108a10:	a1 8c e6 10 80       	mov    0x8010e68c,%eax
80108a15:	85 c0                	test   %eax,%eax
80108a17:	75 07                	jne    80108a20 <uartgetc+0x13>
    return -1;
80108a19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108a1e:	eb 2e                	jmp    80108a4e <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80108a20:	68 fd 03 00 00       	push   $0x3fd
80108a25:	e8 4e fe ff ff       	call   80108878 <inb>
80108a2a:	83 c4 04             	add    $0x4,%esp
80108a2d:	0f b6 c0             	movzbl %al,%eax
80108a30:	83 e0 01             	and    $0x1,%eax
80108a33:	85 c0                	test   %eax,%eax
80108a35:	75 07                	jne    80108a3e <uartgetc+0x31>
    return -1;
80108a37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108a3c:	eb 10                	jmp    80108a4e <uartgetc+0x41>
  return inb(COM1+0);
80108a3e:	68 f8 03 00 00       	push   $0x3f8
80108a43:	e8 30 fe ff ff       	call   80108878 <inb>
80108a48:	83 c4 04             	add    $0x4,%esp
80108a4b:	0f b6 c0             	movzbl %al,%eax
}
80108a4e:	c9                   	leave  
80108a4f:	c3                   	ret    

80108a50 <uartintr>:

void
uartintr(void)
{
80108a50:	55                   	push   %ebp
80108a51:	89 e5                	mov    %esp,%ebp
80108a53:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80108a56:	83 ec 0c             	sub    $0xc,%esp
80108a59:	68 0d 8a 10 80       	push   $0x80108a0d
80108a5e:	e8 96 7d ff ff       	call   801007f9 <consoleintr>
80108a63:	83 c4 10             	add    $0x10,%esp
}
80108a66:	90                   	nop
80108a67:	c9                   	leave  
80108a68:	c3                   	ret    

80108a69 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80108a69:	6a 00                	push   $0x0
  pushl $0
80108a6b:	6a 00                	push   $0x0
  jmp alltraps
80108a6d:	e9 a9 f9 ff ff       	jmp    8010841b <alltraps>

80108a72 <vector1>:
.globl vector1
vector1:
  pushl $0
80108a72:	6a 00                	push   $0x0
  pushl $1
80108a74:	6a 01                	push   $0x1
  jmp alltraps
80108a76:	e9 a0 f9 ff ff       	jmp    8010841b <alltraps>

80108a7b <vector2>:
.globl vector2
vector2:
  pushl $0
80108a7b:	6a 00                	push   $0x0
  pushl $2
80108a7d:	6a 02                	push   $0x2
  jmp alltraps
80108a7f:	e9 97 f9 ff ff       	jmp    8010841b <alltraps>

80108a84 <vector3>:
.globl vector3
vector3:
  pushl $0
80108a84:	6a 00                	push   $0x0
  pushl $3
80108a86:	6a 03                	push   $0x3
  jmp alltraps
80108a88:	e9 8e f9 ff ff       	jmp    8010841b <alltraps>

80108a8d <vector4>:
.globl vector4
vector4:
  pushl $0
80108a8d:	6a 00                	push   $0x0
  pushl $4
80108a8f:	6a 04                	push   $0x4
  jmp alltraps
80108a91:	e9 85 f9 ff ff       	jmp    8010841b <alltraps>

80108a96 <vector5>:
.globl vector5
vector5:
  pushl $0
80108a96:	6a 00                	push   $0x0
  pushl $5
80108a98:	6a 05                	push   $0x5
  jmp alltraps
80108a9a:	e9 7c f9 ff ff       	jmp    8010841b <alltraps>

80108a9f <vector6>:
.globl vector6
vector6:
  pushl $0
80108a9f:	6a 00                	push   $0x0
  pushl $6
80108aa1:	6a 06                	push   $0x6
  jmp alltraps
80108aa3:	e9 73 f9 ff ff       	jmp    8010841b <alltraps>

80108aa8 <vector7>:
.globl vector7
vector7:
  pushl $0
80108aa8:	6a 00                	push   $0x0
  pushl $7
80108aaa:	6a 07                	push   $0x7
  jmp alltraps
80108aac:	e9 6a f9 ff ff       	jmp    8010841b <alltraps>

80108ab1 <vector8>:
.globl vector8
vector8:
  pushl $8
80108ab1:	6a 08                	push   $0x8
  jmp alltraps
80108ab3:	e9 63 f9 ff ff       	jmp    8010841b <alltraps>

80108ab8 <vector9>:
.globl vector9
vector9:
  pushl $0
80108ab8:	6a 00                	push   $0x0
  pushl $9
80108aba:	6a 09                	push   $0x9
  jmp alltraps
80108abc:	e9 5a f9 ff ff       	jmp    8010841b <alltraps>

80108ac1 <vector10>:
.globl vector10
vector10:
  pushl $10
80108ac1:	6a 0a                	push   $0xa
  jmp alltraps
80108ac3:	e9 53 f9 ff ff       	jmp    8010841b <alltraps>

80108ac8 <vector11>:
.globl vector11
vector11:
  pushl $11
80108ac8:	6a 0b                	push   $0xb
  jmp alltraps
80108aca:	e9 4c f9 ff ff       	jmp    8010841b <alltraps>

80108acf <vector12>:
.globl vector12
vector12:
  pushl $12
80108acf:	6a 0c                	push   $0xc
  jmp alltraps
80108ad1:	e9 45 f9 ff ff       	jmp    8010841b <alltraps>

80108ad6 <vector13>:
.globl vector13
vector13:
  pushl $13
80108ad6:	6a 0d                	push   $0xd
  jmp alltraps
80108ad8:	e9 3e f9 ff ff       	jmp    8010841b <alltraps>

80108add <vector14>:
.globl vector14
vector14:
  pushl $14
80108add:	6a 0e                	push   $0xe
  jmp alltraps
80108adf:	e9 37 f9 ff ff       	jmp    8010841b <alltraps>

80108ae4 <vector15>:
.globl vector15
vector15:
  pushl $0
80108ae4:	6a 00                	push   $0x0
  pushl $15
80108ae6:	6a 0f                	push   $0xf
  jmp alltraps
80108ae8:	e9 2e f9 ff ff       	jmp    8010841b <alltraps>

80108aed <vector16>:
.globl vector16
vector16:
  pushl $0
80108aed:	6a 00                	push   $0x0
  pushl $16
80108aef:	6a 10                	push   $0x10
  jmp alltraps
80108af1:	e9 25 f9 ff ff       	jmp    8010841b <alltraps>

80108af6 <vector17>:
.globl vector17
vector17:
  pushl $17
80108af6:	6a 11                	push   $0x11
  jmp alltraps
80108af8:	e9 1e f9 ff ff       	jmp    8010841b <alltraps>

80108afd <vector18>:
.globl vector18
vector18:
  pushl $0
80108afd:	6a 00                	push   $0x0
  pushl $18
80108aff:	6a 12                	push   $0x12
  jmp alltraps
80108b01:	e9 15 f9 ff ff       	jmp    8010841b <alltraps>

80108b06 <vector19>:
.globl vector19
vector19:
  pushl $0
80108b06:	6a 00                	push   $0x0
  pushl $19
80108b08:	6a 13                	push   $0x13
  jmp alltraps
80108b0a:	e9 0c f9 ff ff       	jmp    8010841b <alltraps>

80108b0f <vector20>:
.globl vector20
vector20:
  pushl $0
80108b0f:	6a 00                	push   $0x0
  pushl $20
80108b11:	6a 14                	push   $0x14
  jmp alltraps
80108b13:	e9 03 f9 ff ff       	jmp    8010841b <alltraps>

80108b18 <vector21>:
.globl vector21
vector21:
  pushl $0
80108b18:	6a 00                	push   $0x0
  pushl $21
80108b1a:	6a 15                	push   $0x15
  jmp alltraps
80108b1c:	e9 fa f8 ff ff       	jmp    8010841b <alltraps>

80108b21 <vector22>:
.globl vector22
vector22:
  pushl $0
80108b21:	6a 00                	push   $0x0
  pushl $22
80108b23:	6a 16                	push   $0x16
  jmp alltraps
80108b25:	e9 f1 f8 ff ff       	jmp    8010841b <alltraps>

80108b2a <vector23>:
.globl vector23
vector23:
  pushl $0
80108b2a:	6a 00                	push   $0x0
  pushl $23
80108b2c:	6a 17                	push   $0x17
  jmp alltraps
80108b2e:	e9 e8 f8 ff ff       	jmp    8010841b <alltraps>

80108b33 <vector24>:
.globl vector24
vector24:
  pushl $0
80108b33:	6a 00                	push   $0x0
  pushl $24
80108b35:	6a 18                	push   $0x18
  jmp alltraps
80108b37:	e9 df f8 ff ff       	jmp    8010841b <alltraps>

80108b3c <vector25>:
.globl vector25
vector25:
  pushl $0
80108b3c:	6a 00                	push   $0x0
  pushl $25
80108b3e:	6a 19                	push   $0x19
  jmp alltraps
80108b40:	e9 d6 f8 ff ff       	jmp    8010841b <alltraps>

80108b45 <vector26>:
.globl vector26
vector26:
  pushl $0
80108b45:	6a 00                	push   $0x0
  pushl $26
80108b47:	6a 1a                	push   $0x1a
  jmp alltraps
80108b49:	e9 cd f8 ff ff       	jmp    8010841b <alltraps>

80108b4e <vector27>:
.globl vector27
vector27:
  pushl $0
80108b4e:	6a 00                	push   $0x0
  pushl $27
80108b50:	6a 1b                	push   $0x1b
  jmp alltraps
80108b52:	e9 c4 f8 ff ff       	jmp    8010841b <alltraps>

80108b57 <vector28>:
.globl vector28
vector28:
  pushl $0
80108b57:	6a 00                	push   $0x0
  pushl $28
80108b59:	6a 1c                	push   $0x1c
  jmp alltraps
80108b5b:	e9 bb f8 ff ff       	jmp    8010841b <alltraps>

80108b60 <vector29>:
.globl vector29
vector29:
  pushl $0
80108b60:	6a 00                	push   $0x0
  pushl $29
80108b62:	6a 1d                	push   $0x1d
  jmp alltraps
80108b64:	e9 b2 f8 ff ff       	jmp    8010841b <alltraps>

80108b69 <vector30>:
.globl vector30
vector30:
  pushl $0
80108b69:	6a 00                	push   $0x0
  pushl $30
80108b6b:	6a 1e                	push   $0x1e
  jmp alltraps
80108b6d:	e9 a9 f8 ff ff       	jmp    8010841b <alltraps>

80108b72 <vector31>:
.globl vector31
vector31:
  pushl $0
80108b72:	6a 00                	push   $0x0
  pushl $31
80108b74:	6a 1f                	push   $0x1f
  jmp alltraps
80108b76:	e9 a0 f8 ff ff       	jmp    8010841b <alltraps>

80108b7b <vector32>:
.globl vector32
vector32:
  pushl $0
80108b7b:	6a 00                	push   $0x0
  pushl $32
80108b7d:	6a 20                	push   $0x20
  jmp alltraps
80108b7f:	e9 97 f8 ff ff       	jmp    8010841b <alltraps>

80108b84 <vector33>:
.globl vector33
vector33:
  pushl $0
80108b84:	6a 00                	push   $0x0
  pushl $33
80108b86:	6a 21                	push   $0x21
  jmp alltraps
80108b88:	e9 8e f8 ff ff       	jmp    8010841b <alltraps>

80108b8d <vector34>:
.globl vector34
vector34:
  pushl $0
80108b8d:	6a 00                	push   $0x0
  pushl $34
80108b8f:	6a 22                	push   $0x22
  jmp alltraps
80108b91:	e9 85 f8 ff ff       	jmp    8010841b <alltraps>

80108b96 <vector35>:
.globl vector35
vector35:
  pushl $0
80108b96:	6a 00                	push   $0x0
  pushl $35
80108b98:	6a 23                	push   $0x23
  jmp alltraps
80108b9a:	e9 7c f8 ff ff       	jmp    8010841b <alltraps>

80108b9f <vector36>:
.globl vector36
vector36:
  pushl $0
80108b9f:	6a 00                	push   $0x0
  pushl $36
80108ba1:	6a 24                	push   $0x24
  jmp alltraps
80108ba3:	e9 73 f8 ff ff       	jmp    8010841b <alltraps>

80108ba8 <vector37>:
.globl vector37
vector37:
  pushl $0
80108ba8:	6a 00                	push   $0x0
  pushl $37
80108baa:	6a 25                	push   $0x25
  jmp alltraps
80108bac:	e9 6a f8 ff ff       	jmp    8010841b <alltraps>

80108bb1 <vector38>:
.globl vector38
vector38:
  pushl $0
80108bb1:	6a 00                	push   $0x0
  pushl $38
80108bb3:	6a 26                	push   $0x26
  jmp alltraps
80108bb5:	e9 61 f8 ff ff       	jmp    8010841b <alltraps>

80108bba <vector39>:
.globl vector39
vector39:
  pushl $0
80108bba:	6a 00                	push   $0x0
  pushl $39
80108bbc:	6a 27                	push   $0x27
  jmp alltraps
80108bbe:	e9 58 f8 ff ff       	jmp    8010841b <alltraps>

80108bc3 <vector40>:
.globl vector40
vector40:
  pushl $0
80108bc3:	6a 00                	push   $0x0
  pushl $40
80108bc5:	6a 28                	push   $0x28
  jmp alltraps
80108bc7:	e9 4f f8 ff ff       	jmp    8010841b <alltraps>

80108bcc <vector41>:
.globl vector41
vector41:
  pushl $0
80108bcc:	6a 00                	push   $0x0
  pushl $41
80108bce:	6a 29                	push   $0x29
  jmp alltraps
80108bd0:	e9 46 f8 ff ff       	jmp    8010841b <alltraps>

80108bd5 <vector42>:
.globl vector42
vector42:
  pushl $0
80108bd5:	6a 00                	push   $0x0
  pushl $42
80108bd7:	6a 2a                	push   $0x2a
  jmp alltraps
80108bd9:	e9 3d f8 ff ff       	jmp    8010841b <alltraps>

80108bde <vector43>:
.globl vector43
vector43:
  pushl $0
80108bde:	6a 00                	push   $0x0
  pushl $43
80108be0:	6a 2b                	push   $0x2b
  jmp alltraps
80108be2:	e9 34 f8 ff ff       	jmp    8010841b <alltraps>

80108be7 <vector44>:
.globl vector44
vector44:
  pushl $0
80108be7:	6a 00                	push   $0x0
  pushl $44
80108be9:	6a 2c                	push   $0x2c
  jmp alltraps
80108beb:	e9 2b f8 ff ff       	jmp    8010841b <alltraps>

80108bf0 <vector45>:
.globl vector45
vector45:
  pushl $0
80108bf0:	6a 00                	push   $0x0
  pushl $45
80108bf2:	6a 2d                	push   $0x2d
  jmp alltraps
80108bf4:	e9 22 f8 ff ff       	jmp    8010841b <alltraps>

80108bf9 <vector46>:
.globl vector46
vector46:
  pushl $0
80108bf9:	6a 00                	push   $0x0
  pushl $46
80108bfb:	6a 2e                	push   $0x2e
  jmp alltraps
80108bfd:	e9 19 f8 ff ff       	jmp    8010841b <alltraps>

80108c02 <vector47>:
.globl vector47
vector47:
  pushl $0
80108c02:	6a 00                	push   $0x0
  pushl $47
80108c04:	6a 2f                	push   $0x2f
  jmp alltraps
80108c06:	e9 10 f8 ff ff       	jmp    8010841b <alltraps>

80108c0b <vector48>:
.globl vector48
vector48:
  pushl $0
80108c0b:	6a 00                	push   $0x0
  pushl $48
80108c0d:	6a 30                	push   $0x30
  jmp alltraps
80108c0f:	e9 07 f8 ff ff       	jmp    8010841b <alltraps>

80108c14 <vector49>:
.globl vector49
vector49:
  pushl $0
80108c14:	6a 00                	push   $0x0
  pushl $49
80108c16:	6a 31                	push   $0x31
  jmp alltraps
80108c18:	e9 fe f7 ff ff       	jmp    8010841b <alltraps>

80108c1d <vector50>:
.globl vector50
vector50:
  pushl $0
80108c1d:	6a 00                	push   $0x0
  pushl $50
80108c1f:	6a 32                	push   $0x32
  jmp alltraps
80108c21:	e9 f5 f7 ff ff       	jmp    8010841b <alltraps>

80108c26 <vector51>:
.globl vector51
vector51:
  pushl $0
80108c26:	6a 00                	push   $0x0
  pushl $51
80108c28:	6a 33                	push   $0x33
  jmp alltraps
80108c2a:	e9 ec f7 ff ff       	jmp    8010841b <alltraps>

80108c2f <vector52>:
.globl vector52
vector52:
  pushl $0
80108c2f:	6a 00                	push   $0x0
  pushl $52
80108c31:	6a 34                	push   $0x34
  jmp alltraps
80108c33:	e9 e3 f7 ff ff       	jmp    8010841b <alltraps>

80108c38 <vector53>:
.globl vector53
vector53:
  pushl $0
80108c38:	6a 00                	push   $0x0
  pushl $53
80108c3a:	6a 35                	push   $0x35
  jmp alltraps
80108c3c:	e9 da f7 ff ff       	jmp    8010841b <alltraps>

80108c41 <vector54>:
.globl vector54
vector54:
  pushl $0
80108c41:	6a 00                	push   $0x0
  pushl $54
80108c43:	6a 36                	push   $0x36
  jmp alltraps
80108c45:	e9 d1 f7 ff ff       	jmp    8010841b <alltraps>

80108c4a <vector55>:
.globl vector55
vector55:
  pushl $0
80108c4a:	6a 00                	push   $0x0
  pushl $55
80108c4c:	6a 37                	push   $0x37
  jmp alltraps
80108c4e:	e9 c8 f7 ff ff       	jmp    8010841b <alltraps>

80108c53 <vector56>:
.globl vector56
vector56:
  pushl $0
80108c53:	6a 00                	push   $0x0
  pushl $56
80108c55:	6a 38                	push   $0x38
  jmp alltraps
80108c57:	e9 bf f7 ff ff       	jmp    8010841b <alltraps>

80108c5c <vector57>:
.globl vector57
vector57:
  pushl $0
80108c5c:	6a 00                	push   $0x0
  pushl $57
80108c5e:	6a 39                	push   $0x39
  jmp alltraps
80108c60:	e9 b6 f7 ff ff       	jmp    8010841b <alltraps>

80108c65 <vector58>:
.globl vector58
vector58:
  pushl $0
80108c65:	6a 00                	push   $0x0
  pushl $58
80108c67:	6a 3a                	push   $0x3a
  jmp alltraps
80108c69:	e9 ad f7 ff ff       	jmp    8010841b <alltraps>

80108c6e <vector59>:
.globl vector59
vector59:
  pushl $0
80108c6e:	6a 00                	push   $0x0
  pushl $59
80108c70:	6a 3b                	push   $0x3b
  jmp alltraps
80108c72:	e9 a4 f7 ff ff       	jmp    8010841b <alltraps>

80108c77 <vector60>:
.globl vector60
vector60:
  pushl $0
80108c77:	6a 00                	push   $0x0
  pushl $60
80108c79:	6a 3c                	push   $0x3c
  jmp alltraps
80108c7b:	e9 9b f7 ff ff       	jmp    8010841b <alltraps>

80108c80 <vector61>:
.globl vector61
vector61:
  pushl $0
80108c80:	6a 00                	push   $0x0
  pushl $61
80108c82:	6a 3d                	push   $0x3d
  jmp alltraps
80108c84:	e9 92 f7 ff ff       	jmp    8010841b <alltraps>

80108c89 <vector62>:
.globl vector62
vector62:
  pushl $0
80108c89:	6a 00                	push   $0x0
  pushl $62
80108c8b:	6a 3e                	push   $0x3e
  jmp alltraps
80108c8d:	e9 89 f7 ff ff       	jmp    8010841b <alltraps>

80108c92 <vector63>:
.globl vector63
vector63:
  pushl $0
80108c92:	6a 00                	push   $0x0
  pushl $63
80108c94:	6a 3f                	push   $0x3f
  jmp alltraps
80108c96:	e9 80 f7 ff ff       	jmp    8010841b <alltraps>

80108c9b <vector64>:
.globl vector64
vector64:
  pushl $0
80108c9b:	6a 00                	push   $0x0
  pushl $64
80108c9d:	6a 40                	push   $0x40
  jmp alltraps
80108c9f:	e9 77 f7 ff ff       	jmp    8010841b <alltraps>

80108ca4 <vector65>:
.globl vector65
vector65:
  pushl $0
80108ca4:	6a 00                	push   $0x0
  pushl $65
80108ca6:	6a 41                	push   $0x41
  jmp alltraps
80108ca8:	e9 6e f7 ff ff       	jmp    8010841b <alltraps>

80108cad <vector66>:
.globl vector66
vector66:
  pushl $0
80108cad:	6a 00                	push   $0x0
  pushl $66
80108caf:	6a 42                	push   $0x42
  jmp alltraps
80108cb1:	e9 65 f7 ff ff       	jmp    8010841b <alltraps>

80108cb6 <vector67>:
.globl vector67
vector67:
  pushl $0
80108cb6:	6a 00                	push   $0x0
  pushl $67
80108cb8:	6a 43                	push   $0x43
  jmp alltraps
80108cba:	e9 5c f7 ff ff       	jmp    8010841b <alltraps>

80108cbf <vector68>:
.globl vector68
vector68:
  pushl $0
80108cbf:	6a 00                	push   $0x0
  pushl $68
80108cc1:	6a 44                	push   $0x44
  jmp alltraps
80108cc3:	e9 53 f7 ff ff       	jmp    8010841b <alltraps>

80108cc8 <vector69>:
.globl vector69
vector69:
  pushl $0
80108cc8:	6a 00                	push   $0x0
  pushl $69
80108cca:	6a 45                	push   $0x45
  jmp alltraps
80108ccc:	e9 4a f7 ff ff       	jmp    8010841b <alltraps>

80108cd1 <vector70>:
.globl vector70
vector70:
  pushl $0
80108cd1:	6a 00                	push   $0x0
  pushl $70
80108cd3:	6a 46                	push   $0x46
  jmp alltraps
80108cd5:	e9 41 f7 ff ff       	jmp    8010841b <alltraps>

80108cda <vector71>:
.globl vector71
vector71:
  pushl $0
80108cda:	6a 00                	push   $0x0
  pushl $71
80108cdc:	6a 47                	push   $0x47
  jmp alltraps
80108cde:	e9 38 f7 ff ff       	jmp    8010841b <alltraps>

80108ce3 <vector72>:
.globl vector72
vector72:
  pushl $0
80108ce3:	6a 00                	push   $0x0
  pushl $72
80108ce5:	6a 48                	push   $0x48
  jmp alltraps
80108ce7:	e9 2f f7 ff ff       	jmp    8010841b <alltraps>

80108cec <vector73>:
.globl vector73
vector73:
  pushl $0
80108cec:	6a 00                	push   $0x0
  pushl $73
80108cee:	6a 49                	push   $0x49
  jmp alltraps
80108cf0:	e9 26 f7 ff ff       	jmp    8010841b <alltraps>

80108cf5 <vector74>:
.globl vector74
vector74:
  pushl $0
80108cf5:	6a 00                	push   $0x0
  pushl $74
80108cf7:	6a 4a                	push   $0x4a
  jmp alltraps
80108cf9:	e9 1d f7 ff ff       	jmp    8010841b <alltraps>

80108cfe <vector75>:
.globl vector75
vector75:
  pushl $0
80108cfe:	6a 00                	push   $0x0
  pushl $75
80108d00:	6a 4b                	push   $0x4b
  jmp alltraps
80108d02:	e9 14 f7 ff ff       	jmp    8010841b <alltraps>

80108d07 <vector76>:
.globl vector76
vector76:
  pushl $0
80108d07:	6a 00                	push   $0x0
  pushl $76
80108d09:	6a 4c                	push   $0x4c
  jmp alltraps
80108d0b:	e9 0b f7 ff ff       	jmp    8010841b <alltraps>

80108d10 <vector77>:
.globl vector77
vector77:
  pushl $0
80108d10:	6a 00                	push   $0x0
  pushl $77
80108d12:	6a 4d                	push   $0x4d
  jmp alltraps
80108d14:	e9 02 f7 ff ff       	jmp    8010841b <alltraps>

80108d19 <vector78>:
.globl vector78
vector78:
  pushl $0
80108d19:	6a 00                	push   $0x0
  pushl $78
80108d1b:	6a 4e                	push   $0x4e
  jmp alltraps
80108d1d:	e9 f9 f6 ff ff       	jmp    8010841b <alltraps>

80108d22 <vector79>:
.globl vector79
vector79:
  pushl $0
80108d22:	6a 00                	push   $0x0
  pushl $79
80108d24:	6a 4f                	push   $0x4f
  jmp alltraps
80108d26:	e9 f0 f6 ff ff       	jmp    8010841b <alltraps>

80108d2b <vector80>:
.globl vector80
vector80:
  pushl $0
80108d2b:	6a 00                	push   $0x0
  pushl $80
80108d2d:	6a 50                	push   $0x50
  jmp alltraps
80108d2f:	e9 e7 f6 ff ff       	jmp    8010841b <alltraps>

80108d34 <vector81>:
.globl vector81
vector81:
  pushl $0
80108d34:	6a 00                	push   $0x0
  pushl $81
80108d36:	6a 51                	push   $0x51
  jmp alltraps
80108d38:	e9 de f6 ff ff       	jmp    8010841b <alltraps>

80108d3d <vector82>:
.globl vector82
vector82:
  pushl $0
80108d3d:	6a 00                	push   $0x0
  pushl $82
80108d3f:	6a 52                	push   $0x52
  jmp alltraps
80108d41:	e9 d5 f6 ff ff       	jmp    8010841b <alltraps>

80108d46 <vector83>:
.globl vector83
vector83:
  pushl $0
80108d46:	6a 00                	push   $0x0
  pushl $83
80108d48:	6a 53                	push   $0x53
  jmp alltraps
80108d4a:	e9 cc f6 ff ff       	jmp    8010841b <alltraps>

80108d4f <vector84>:
.globl vector84
vector84:
  pushl $0
80108d4f:	6a 00                	push   $0x0
  pushl $84
80108d51:	6a 54                	push   $0x54
  jmp alltraps
80108d53:	e9 c3 f6 ff ff       	jmp    8010841b <alltraps>

80108d58 <vector85>:
.globl vector85
vector85:
  pushl $0
80108d58:	6a 00                	push   $0x0
  pushl $85
80108d5a:	6a 55                	push   $0x55
  jmp alltraps
80108d5c:	e9 ba f6 ff ff       	jmp    8010841b <alltraps>

80108d61 <vector86>:
.globl vector86
vector86:
  pushl $0
80108d61:	6a 00                	push   $0x0
  pushl $86
80108d63:	6a 56                	push   $0x56
  jmp alltraps
80108d65:	e9 b1 f6 ff ff       	jmp    8010841b <alltraps>

80108d6a <vector87>:
.globl vector87
vector87:
  pushl $0
80108d6a:	6a 00                	push   $0x0
  pushl $87
80108d6c:	6a 57                	push   $0x57
  jmp alltraps
80108d6e:	e9 a8 f6 ff ff       	jmp    8010841b <alltraps>

80108d73 <vector88>:
.globl vector88
vector88:
  pushl $0
80108d73:	6a 00                	push   $0x0
  pushl $88
80108d75:	6a 58                	push   $0x58
  jmp alltraps
80108d77:	e9 9f f6 ff ff       	jmp    8010841b <alltraps>

80108d7c <vector89>:
.globl vector89
vector89:
  pushl $0
80108d7c:	6a 00                	push   $0x0
  pushl $89
80108d7e:	6a 59                	push   $0x59
  jmp alltraps
80108d80:	e9 96 f6 ff ff       	jmp    8010841b <alltraps>

80108d85 <vector90>:
.globl vector90
vector90:
  pushl $0
80108d85:	6a 00                	push   $0x0
  pushl $90
80108d87:	6a 5a                	push   $0x5a
  jmp alltraps
80108d89:	e9 8d f6 ff ff       	jmp    8010841b <alltraps>

80108d8e <vector91>:
.globl vector91
vector91:
  pushl $0
80108d8e:	6a 00                	push   $0x0
  pushl $91
80108d90:	6a 5b                	push   $0x5b
  jmp alltraps
80108d92:	e9 84 f6 ff ff       	jmp    8010841b <alltraps>

80108d97 <vector92>:
.globl vector92
vector92:
  pushl $0
80108d97:	6a 00                	push   $0x0
  pushl $92
80108d99:	6a 5c                	push   $0x5c
  jmp alltraps
80108d9b:	e9 7b f6 ff ff       	jmp    8010841b <alltraps>

80108da0 <vector93>:
.globl vector93
vector93:
  pushl $0
80108da0:	6a 00                	push   $0x0
  pushl $93
80108da2:	6a 5d                	push   $0x5d
  jmp alltraps
80108da4:	e9 72 f6 ff ff       	jmp    8010841b <alltraps>

80108da9 <vector94>:
.globl vector94
vector94:
  pushl $0
80108da9:	6a 00                	push   $0x0
  pushl $94
80108dab:	6a 5e                	push   $0x5e
  jmp alltraps
80108dad:	e9 69 f6 ff ff       	jmp    8010841b <alltraps>

80108db2 <vector95>:
.globl vector95
vector95:
  pushl $0
80108db2:	6a 00                	push   $0x0
  pushl $95
80108db4:	6a 5f                	push   $0x5f
  jmp alltraps
80108db6:	e9 60 f6 ff ff       	jmp    8010841b <alltraps>

80108dbb <vector96>:
.globl vector96
vector96:
  pushl $0
80108dbb:	6a 00                	push   $0x0
  pushl $96
80108dbd:	6a 60                	push   $0x60
  jmp alltraps
80108dbf:	e9 57 f6 ff ff       	jmp    8010841b <alltraps>

80108dc4 <vector97>:
.globl vector97
vector97:
  pushl $0
80108dc4:	6a 00                	push   $0x0
  pushl $97
80108dc6:	6a 61                	push   $0x61
  jmp alltraps
80108dc8:	e9 4e f6 ff ff       	jmp    8010841b <alltraps>

80108dcd <vector98>:
.globl vector98
vector98:
  pushl $0
80108dcd:	6a 00                	push   $0x0
  pushl $98
80108dcf:	6a 62                	push   $0x62
  jmp alltraps
80108dd1:	e9 45 f6 ff ff       	jmp    8010841b <alltraps>

80108dd6 <vector99>:
.globl vector99
vector99:
  pushl $0
80108dd6:	6a 00                	push   $0x0
  pushl $99
80108dd8:	6a 63                	push   $0x63
  jmp alltraps
80108dda:	e9 3c f6 ff ff       	jmp    8010841b <alltraps>

80108ddf <vector100>:
.globl vector100
vector100:
  pushl $0
80108ddf:	6a 00                	push   $0x0
  pushl $100
80108de1:	6a 64                	push   $0x64
  jmp alltraps
80108de3:	e9 33 f6 ff ff       	jmp    8010841b <alltraps>

80108de8 <vector101>:
.globl vector101
vector101:
  pushl $0
80108de8:	6a 00                	push   $0x0
  pushl $101
80108dea:	6a 65                	push   $0x65
  jmp alltraps
80108dec:	e9 2a f6 ff ff       	jmp    8010841b <alltraps>

80108df1 <vector102>:
.globl vector102
vector102:
  pushl $0
80108df1:	6a 00                	push   $0x0
  pushl $102
80108df3:	6a 66                	push   $0x66
  jmp alltraps
80108df5:	e9 21 f6 ff ff       	jmp    8010841b <alltraps>

80108dfa <vector103>:
.globl vector103
vector103:
  pushl $0
80108dfa:	6a 00                	push   $0x0
  pushl $103
80108dfc:	6a 67                	push   $0x67
  jmp alltraps
80108dfe:	e9 18 f6 ff ff       	jmp    8010841b <alltraps>

80108e03 <vector104>:
.globl vector104
vector104:
  pushl $0
80108e03:	6a 00                	push   $0x0
  pushl $104
80108e05:	6a 68                	push   $0x68
  jmp alltraps
80108e07:	e9 0f f6 ff ff       	jmp    8010841b <alltraps>

80108e0c <vector105>:
.globl vector105
vector105:
  pushl $0
80108e0c:	6a 00                	push   $0x0
  pushl $105
80108e0e:	6a 69                	push   $0x69
  jmp alltraps
80108e10:	e9 06 f6 ff ff       	jmp    8010841b <alltraps>

80108e15 <vector106>:
.globl vector106
vector106:
  pushl $0
80108e15:	6a 00                	push   $0x0
  pushl $106
80108e17:	6a 6a                	push   $0x6a
  jmp alltraps
80108e19:	e9 fd f5 ff ff       	jmp    8010841b <alltraps>

80108e1e <vector107>:
.globl vector107
vector107:
  pushl $0
80108e1e:	6a 00                	push   $0x0
  pushl $107
80108e20:	6a 6b                	push   $0x6b
  jmp alltraps
80108e22:	e9 f4 f5 ff ff       	jmp    8010841b <alltraps>

80108e27 <vector108>:
.globl vector108
vector108:
  pushl $0
80108e27:	6a 00                	push   $0x0
  pushl $108
80108e29:	6a 6c                	push   $0x6c
  jmp alltraps
80108e2b:	e9 eb f5 ff ff       	jmp    8010841b <alltraps>

80108e30 <vector109>:
.globl vector109
vector109:
  pushl $0
80108e30:	6a 00                	push   $0x0
  pushl $109
80108e32:	6a 6d                	push   $0x6d
  jmp alltraps
80108e34:	e9 e2 f5 ff ff       	jmp    8010841b <alltraps>

80108e39 <vector110>:
.globl vector110
vector110:
  pushl $0
80108e39:	6a 00                	push   $0x0
  pushl $110
80108e3b:	6a 6e                	push   $0x6e
  jmp alltraps
80108e3d:	e9 d9 f5 ff ff       	jmp    8010841b <alltraps>

80108e42 <vector111>:
.globl vector111
vector111:
  pushl $0
80108e42:	6a 00                	push   $0x0
  pushl $111
80108e44:	6a 6f                	push   $0x6f
  jmp alltraps
80108e46:	e9 d0 f5 ff ff       	jmp    8010841b <alltraps>

80108e4b <vector112>:
.globl vector112
vector112:
  pushl $0
80108e4b:	6a 00                	push   $0x0
  pushl $112
80108e4d:	6a 70                	push   $0x70
  jmp alltraps
80108e4f:	e9 c7 f5 ff ff       	jmp    8010841b <alltraps>

80108e54 <vector113>:
.globl vector113
vector113:
  pushl $0
80108e54:	6a 00                	push   $0x0
  pushl $113
80108e56:	6a 71                	push   $0x71
  jmp alltraps
80108e58:	e9 be f5 ff ff       	jmp    8010841b <alltraps>

80108e5d <vector114>:
.globl vector114
vector114:
  pushl $0
80108e5d:	6a 00                	push   $0x0
  pushl $114
80108e5f:	6a 72                	push   $0x72
  jmp alltraps
80108e61:	e9 b5 f5 ff ff       	jmp    8010841b <alltraps>

80108e66 <vector115>:
.globl vector115
vector115:
  pushl $0
80108e66:	6a 00                	push   $0x0
  pushl $115
80108e68:	6a 73                	push   $0x73
  jmp alltraps
80108e6a:	e9 ac f5 ff ff       	jmp    8010841b <alltraps>

80108e6f <vector116>:
.globl vector116
vector116:
  pushl $0
80108e6f:	6a 00                	push   $0x0
  pushl $116
80108e71:	6a 74                	push   $0x74
  jmp alltraps
80108e73:	e9 a3 f5 ff ff       	jmp    8010841b <alltraps>

80108e78 <vector117>:
.globl vector117
vector117:
  pushl $0
80108e78:	6a 00                	push   $0x0
  pushl $117
80108e7a:	6a 75                	push   $0x75
  jmp alltraps
80108e7c:	e9 9a f5 ff ff       	jmp    8010841b <alltraps>

80108e81 <vector118>:
.globl vector118
vector118:
  pushl $0
80108e81:	6a 00                	push   $0x0
  pushl $118
80108e83:	6a 76                	push   $0x76
  jmp alltraps
80108e85:	e9 91 f5 ff ff       	jmp    8010841b <alltraps>

80108e8a <vector119>:
.globl vector119
vector119:
  pushl $0
80108e8a:	6a 00                	push   $0x0
  pushl $119
80108e8c:	6a 77                	push   $0x77
  jmp alltraps
80108e8e:	e9 88 f5 ff ff       	jmp    8010841b <alltraps>

80108e93 <vector120>:
.globl vector120
vector120:
  pushl $0
80108e93:	6a 00                	push   $0x0
  pushl $120
80108e95:	6a 78                	push   $0x78
  jmp alltraps
80108e97:	e9 7f f5 ff ff       	jmp    8010841b <alltraps>

80108e9c <vector121>:
.globl vector121
vector121:
  pushl $0
80108e9c:	6a 00                	push   $0x0
  pushl $121
80108e9e:	6a 79                	push   $0x79
  jmp alltraps
80108ea0:	e9 76 f5 ff ff       	jmp    8010841b <alltraps>

80108ea5 <vector122>:
.globl vector122
vector122:
  pushl $0
80108ea5:	6a 00                	push   $0x0
  pushl $122
80108ea7:	6a 7a                	push   $0x7a
  jmp alltraps
80108ea9:	e9 6d f5 ff ff       	jmp    8010841b <alltraps>

80108eae <vector123>:
.globl vector123
vector123:
  pushl $0
80108eae:	6a 00                	push   $0x0
  pushl $123
80108eb0:	6a 7b                	push   $0x7b
  jmp alltraps
80108eb2:	e9 64 f5 ff ff       	jmp    8010841b <alltraps>

80108eb7 <vector124>:
.globl vector124
vector124:
  pushl $0
80108eb7:	6a 00                	push   $0x0
  pushl $124
80108eb9:	6a 7c                	push   $0x7c
  jmp alltraps
80108ebb:	e9 5b f5 ff ff       	jmp    8010841b <alltraps>

80108ec0 <vector125>:
.globl vector125
vector125:
  pushl $0
80108ec0:	6a 00                	push   $0x0
  pushl $125
80108ec2:	6a 7d                	push   $0x7d
  jmp alltraps
80108ec4:	e9 52 f5 ff ff       	jmp    8010841b <alltraps>

80108ec9 <vector126>:
.globl vector126
vector126:
  pushl $0
80108ec9:	6a 00                	push   $0x0
  pushl $126
80108ecb:	6a 7e                	push   $0x7e
  jmp alltraps
80108ecd:	e9 49 f5 ff ff       	jmp    8010841b <alltraps>

80108ed2 <vector127>:
.globl vector127
vector127:
  pushl $0
80108ed2:	6a 00                	push   $0x0
  pushl $127
80108ed4:	6a 7f                	push   $0x7f
  jmp alltraps
80108ed6:	e9 40 f5 ff ff       	jmp    8010841b <alltraps>

80108edb <vector128>:
.globl vector128
vector128:
  pushl $0
80108edb:	6a 00                	push   $0x0
  pushl $128
80108edd:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108ee2:	e9 34 f5 ff ff       	jmp    8010841b <alltraps>

80108ee7 <vector129>:
.globl vector129
vector129:
  pushl $0
80108ee7:	6a 00                	push   $0x0
  pushl $129
80108ee9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108eee:	e9 28 f5 ff ff       	jmp    8010841b <alltraps>

80108ef3 <vector130>:
.globl vector130
vector130:
  pushl $0
80108ef3:	6a 00                	push   $0x0
  pushl $130
80108ef5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108efa:	e9 1c f5 ff ff       	jmp    8010841b <alltraps>

80108eff <vector131>:
.globl vector131
vector131:
  pushl $0
80108eff:	6a 00                	push   $0x0
  pushl $131
80108f01:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108f06:	e9 10 f5 ff ff       	jmp    8010841b <alltraps>

80108f0b <vector132>:
.globl vector132
vector132:
  pushl $0
80108f0b:	6a 00                	push   $0x0
  pushl $132
80108f0d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108f12:	e9 04 f5 ff ff       	jmp    8010841b <alltraps>

80108f17 <vector133>:
.globl vector133
vector133:
  pushl $0
80108f17:	6a 00                	push   $0x0
  pushl $133
80108f19:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108f1e:	e9 f8 f4 ff ff       	jmp    8010841b <alltraps>

80108f23 <vector134>:
.globl vector134
vector134:
  pushl $0
80108f23:	6a 00                	push   $0x0
  pushl $134
80108f25:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108f2a:	e9 ec f4 ff ff       	jmp    8010841b <alltraps>

80108f2f <vector135>:
.globl vector135
vector135:
  pushl $0
80108f2f:	6a 00                	push   $0x0
  pushl $135
80108f31:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108f36:	e9 e0 f4 ff ff       	jmp    8010841b <alltraps>

80108f3b <vector136>:
.globl vector136
vector136:
  pushl $0
80108f3b:	6a 00                	push   $0x0
  pushl $136
80108f3d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108f42:	e9 d4 f4 ff ff       	jmp    8010841b <alltraps>

80108f47 <vector137>:
.globl vector137
vector137:
  pushl $0
80108f47:	6a 00                	push   $0x0
  pushl $137
80108f49:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108f4e:	e9 c8 f4 ff ff       	jmp    8010841b <alltraps>

80108f53 <vector138>:
.globl vector138
vector138:
  pushl $0
80108f53:	6a 00                	push   $0x0
  pushl $138
80108f55:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108f5a:	e9 bc f4 ff ff       	jmp    8010841b <alltraps>

80108f5f <vector139>:
.globl vector139
vector139:
  pushl $0
80108f5f:	6a 00                	push   $0x0
  pushl $139
80108f61:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108f66:	e9 b0 f4 ff ff       	jmp    8010841b <alltraps>

80108f6b <vector140>:
.globl vector140
vector140:
  pushl $0
80108f6b:	6a 00                	push   $0x0
  pushl $140
80108f6d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108f72:	e9 a4 f4 ff ff       	jmp    8010841b <alltraps>

80108f77 <vector141>:
.globl vector141
vector141:
  pushl $0
80108f77:	6a 00                	push   $0x0
  pushl $141
80108f79:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108f7e:	e9 98 f4 ff ff       	jmp    8010841b <alltraps>

80108f83 <vector142>:
.globl vector142
vector142:
  pushl $0
80108f83:	6a 00                	push   $0x0
  pushl $142
80108f85:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108f8a:	e9 8c f4 ff ff       	jmp    8010841b <alltraps>

80108f8f <vector143>:
.globl vector143
vector143:
  pushl $0
80108f8f:	6a 00                	push   $0x0
  pushl $143
80108f91:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108f96:	e9 80 f4 ff ff       	jmp    8010841b <alltraps>

80108f9b <vector144>:
.globl vector144
vector144:
  pushl $0
80108f9b:	6a 00                	push   $0x0
  pushl $144
80108f9d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108fa2:	e9 74 f4 ff ff       	jmp    8010841b <alltraps>

80108fa7 <vector145>:
.globl vector145
vector145:
  pushl $0
80108fa7:	6a 00                	push   $0x0
  pushl $145
80108fa9:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108fae:	e9 68 f4 ff ff       	jmp    8010841b <alltraps>

80108fb3 <vector146>:
.globl vector146
vector146:
  pushl $0
80108fb3:	6a 00                	push   $0x0
  pushl $146
80108fb5:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108fba:	e9 5c f4 ff ff       	jmp    8010841b <alltraps>

80108fbf <vector147>:
.globl vector147
vector147:
  pushl $0
80108fbf:	6a 00                	push   $0x0
  pushl $147
80108fc1:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108fc6:	e9 50 f4 ff ff       	jmp    8010841b <alltraps>

80108fcb <vector148>:
.globl vector148
vector148:
  pushl $0
80108fcb:	6a 00                	push   $0x0
  pushl $148
80108fcd:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108fd2:	e9 44 f4 ff ff       	jmp    8010841b <alltraps>

80108fd7 <vector149>:
.globl vector149
vector149:
  pushl $0
80108fd7:	6a 00                	push   $0x0
  pushl $149
80108fd9:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108fde:	e9 38 f4 ff ff       	jmp    8010841b <alltraps>

80108fe3 <vector150>:
.globl vector150
vector150:
  pushl $0
80108fe3:	6a 00                	push   $0x0
  pushl $150
80108fe5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108fea:	e9 2c f4 ff ff       	jmp    8010841b <alltraps>

80108fef <vector151>:
.globl vector151
vector151:
  pushl $0
80108fef:	6a 00                	push   $0x0
  pushl $151
80108ff1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108ff6:	e9 20 f4 ff ff       	jmp    8010841b <alltraps>

80108ffb <vector152>:
.globl vector152
vector152:
  pushl $0
80108ffb:	6a 00                	push   $0x0
  pushl $152
80108ffd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80109002:	e9 14 f4 ff ff       	jmp    8010841b <alltraps>

80109007 <vector153>:
.globl vector153
vector153:
  pushl $0
80109007:	6a 00                	push   $0x0
  pushl $153
80109009:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010900e:	e9 08 f4 ff ff       	jmp    8010841b <alltraps>

80109013 <vector154>:
.globl vector154
vector154:
  pushl $0
80109013:	6a 00                	push   $0x0
  pushl $154
80109015:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
8010901a:	e9 fc f3 ff ff       	jmp    8010841b <alltraps>

8010901f <vector155>:
.globl vector155
vector155:
  pushl $0
8010901f:	6a 00                	push   $0x0
  pushl $155
80109021:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80109026:	e9 f0 f3 ff ff       	jmp    8010841b <alltraps>

8010902b <vector156>:
.globl vector156
vector156:
  pushl $0
8010902b:	6a 00                	push   $0x0
  pushl $156
8010902d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80109032:	e9 e4 f3 ff ff       	jmp    8010841b <alltraps>

80109037 <vector157>:
.globl vector157
vector157:
  pushl $0
80109037:	6a 00                	push   $0x0
  pushl $157
80109039:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010903e:	e9 d8 f3 ff ff       	jmp    8010841b <alltraps>

80109043 <vector158>:
.globl vector158
vector158:
  pushl $0
80109043:	6a 00                	push   $0x0
  pushl $158
80109045:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
8010904a:	e9 cc f3 ff ff       	jmp    8010841b <alltraps>

8010904f <vector159>:
.globl vector159
vector159:
  pushl $0
8010904f:	6a 00                	push   $0x0
  pushl $159
80109051:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80109056:	e9 c0 f3 ff ff       	jmp    8010841b <alltraps>

8010905b <vector160>:
.globl vector160
vector160:
  pushl $0
8010905b:	6a 00                	push   $0x0
  pushl $160
8010905d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80109062:	e9 b4 f3 ff ff       	jmp    8010841b <alltraps>

80109067 <vector161>:
.globl vector161
vector161:
  pushl $0
80109067:	6a 00                	push   $0x0
  pushl $161
80109069:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010906e:	e9 a8 f3 ff ff       	jmp    8010841b <alltraps>

80109073 <vector162>:
.globl vector162
vector162:
  pushl $0
80109073:	6a 00                	push   $0x0
  pushl $162
80109075:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010907a:	e9 9c f3 ff ff       	jmp    8010841b <alltraps>

8010907f <vector163>:
.globl vector163
vector163:
  pushl $0
8010907f:	6a 00                	push   $0x0
  pushl $163
80109081:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80109086:	e9 90 f3 ff ff       	jmp    8010841b <alltraps>

8010908b <vector164>:
.globl vector164
vector164:
  pushl $0
8010908b:	6a 00                	push   $0x0
  pushl $164
8010908d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80109092:	e9 84 f3 ff ff       	jmp    8010841b <alltraps>

80109097 <vector165>:
.globl vector165
vector165:
  pushl $0
80109097:	6a 00                	push   $0x0
  pushl $165
80109099:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010909e:	e9 78 f3 ff ff       	jmp    8010841b <alltraps>

801090a3 <vector166>:
.globl vector166
vector166:
  pushl $0
801090a3:	6a 00                	push   $0x0
  pushl $166
801090a5:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801090aa:	e9 6c f3 ff ff       	jmp    8010841b <alltraps>

801090af <vector167>:
.globl vector167
vector167:
  pushl $0
801090af:	6a 00                	push   $0x0
  pushl $167
801090b1:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801090b6:	e9 60 f3 ff ff       	jmp    8010841b <alltraps>

801090bb <vector168>:
.globl vector168
vector168:
  pushl $0
801090bb:	6a 00                	push   $0x0
  pushl $168
801090bd:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801090c2:	e9 54 f3 ff ff       	jmp    8010841b <alltraps>

801090c7 <vector169>:
.globl vector169
vector169:
  pushl $0
801090c7:	6a 00                	push   $0x0
  pushl $169
801090c9:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801090ce:	e9 48 f3 ff ff       	jmp    8010841b <alltraps>

801090d3 <vector170>:
.globl vector170
vector170:
  pushl $0
801090d3:	6a 00                	push   $0x0
  pushl $170
801090d5:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801090da:	e9 3c f3 ff ff       	jmp    8010841b <alltraps>

801090df <vector171>:
.globl vector171
vector171:
  pushl $0
801090df:	6a 00                	push   $0x0
  pushl $171
801090e1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801090e6:	e9 30 f3 ff ff       	jmp    8010841b <alltraps>

801090eb <vector172>:
.globl vector172
vector172:
  pushl $0
801090eb:	6a 00                	push   $0x0
  pushl $172
801090ed:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801090f2:	e9 24 f3 ff ff       	jmp    8010841b <alltraps>

801090f7 <vector173>:
.globl vector173
vector173:
  pushl $0
801090f7:	6a 00                	push   $0x0
  pushl $173
801090f9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801090fe:	e9 18 f3 ff ff       	jmp    8010841b <alltraps>

80109103 <vector174>:
.globl vector174
vector174:
  pushl $0
80109103:	6a 00                	push   $0x0
  pushl $174
80109105:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
8010910a:	e9 0c f3 ff ff       	jmp    8010841b <alltraps>

8010910f <vector175>:
.globl vector175
vector175:
  pushl $0
8010910f:	6a 00                	push   $0x0
  pushl $175
80109111:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80109116:	e9 00 f3 ff ff       	jmp    8010841b <alltraps>

8010911b <vector176>:
.globl vector176
vector176:
  pushl $0
8010911b:	6a 00                	push   $0x0
  pushl $176
8010911d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80109122:	e9 f4 f2 ff ff       	jmp    8010841b <alltraps>

80109127 <vector177>:
.globl vector177
vector177:
  pushl $0
80109127:	6a 00                	push   $0x0
  pushl $177
80109129:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010912e:	e9 e8 f2 ff ff       	jmp    8010841b <alltraps>

80109133 <vector178>:
.globl vector178
vector178:
  pushl $0
80109133:	6a 00                	push   $0x0
  pushl $178
80109135:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
8010913a:	e9 dc f2 ff ff       	jmp    8010841b <alltraps>

8010913f <vector179>:
.globl vector179
vector179:
  pushl $0
8010913f:	6a 00                	push   $0x0
  pushl $179
80109141:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80109146:	e9 d0 f2 ff ff       	jmp    8010841b <alltraps>

8010914b <vector180>:
.globl vector180
vector180:
  pushl $0
8010914b:	6a 00                	push   $0x0
  pushl $180
8010914d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80109152:	e9 c4 f2 ff ff       	jmp    8010841b <alltraps>

80109157 <vector181>:
.globl vector181
vector181:
  pushl $0
80109157:	6a 00                	push   $0x0
  pushl $181
80109159:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010915e:	e9 b8 f2 ff ff       	jmp    8010841b <alltraps>

80109163 <vector182>:
.globl vector182
vector182:
  pushl $0
80109163:	6a 00                	push   $0x0
  pushl $182
80109165:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010916a:	e9 ac f2 ff ff       	jmp    8010841b <alltraps>

8010916f <vector183>:
.globl vector183
vector183:
  pushl $0
8010916f:	6a 00                	push   $0x0
  pushl $183
80109171:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80109176:	e9 a0 f2 ff ff       	jmp    8010841b <alltraps>

8010917b <vector184>:
.globl vector184
vector184:
  pushl $0
8010917b:	6a 00                	push   $0x0
  pushl $184
8010917d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80109182:	e9 94 f2 ff ff       	jmp    8010841b <alltraps>

80109187 <vector185>:
.globl vector185
vector185:
  pushl $0
80109187:	6a 00                	push   $0x0
  pushl $185
80109189:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010918e:	e9 88 f2 ff ff       	jmp    8010841b <alltraps>

80109193 <vector186>:
.globl vector186
vector186:
  pushl $0
80109193:	6a 00                	push   $0x0
  pushl $186
80109195:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010919a:	e9 7c f2 ff ff       	jmp    8010841b <alltraps>

8010919f <vector187>:
.globl vector187
vector187:
  pushl $0
8010919f:	6a 00                	push   $0x0
  pushl $187
801091a1:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801091a6:	e9 70 f2 ff ff       	jmp    8010841b <alltraps>

801091ab <vector188>:
.globl vector188
vector188:
  pushl $0
801091ab:	6a 00                	push   $0x0
  pushl $188
801091ad:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801091b2:	e9 64 f2 ff ff       	jmp    8010841b <alltraps>

801091b7 <vector189>:
.globl vector189
vector189:
  pushl $0
801091b7:	6a 00                	push   $0x0
  pushl $189
801091b9:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801091be:	e9 58 f2 ff ff       	jmp    8010841b <alltraps>

801091c3 <vector190>:
.globl vector190
vector190:
  pushl $0
801091c3:	6a 00                	push   $0x0
  pushl $190
801091c5:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801091ca:	e9 4c f2 ff ff       	jmp    8010841b <alltraps>

801091cf <vector191>:
.globl vector191
vector191:
  pushl $0
801091cf:	6a 00                	push   $0x0
  pushl $191
801091d1:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801091d6:	e9 40 f2 ff ff       	jmp    8010841b <alltraps>

801091db <vector192>:
.globl vector192
vector192:
  pushl $0
801091db:	6a 00                	push   $0x0
  pushl $192
801091dd:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801091e2:	e9 34 f2 ff ff       	jmp    8010841b <alltraps>

801091e7 <vector193>:
.globl vector193
vector193:
  pushl $0
801091e7:	6a 00                	push   $0x0
  pushl $193
801091e9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801091ee:	e9 28 f2 ff ff       	jmp    8010841b <alltraps>

801091f3 <vector194>:
.globl vector194
vector194:
  pushl $0
801091f3:	6a 00                	push   $0x0
  pushl $194
801091f5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801091fa:	e9 1c f2 ff ff       	jmp    8010841b <alltraps>

801091ff <vector195>:
.globl vector195
vector195:
  pushl $0
801091ff:	6a 00                	push   $0x0
  pushl $195
80109201:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80109206:	e9 10 f2 ff ff       	jmp    8010841b <alltraps>

8010920b <vector196>:
.globl vector196
vector196:
  pushl $0
8010920b:	6a 00                	push   $0x0
  pushl $196
8010920d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80109212:	e9 04 f2 ff ff       	jmp    8010841b <alltraps>

80109217 <vector197>:
.globl vector197
vector197:
  pushl $0
80109217:	6a 00                	push   $0x0
  pushl $197
80109219:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010921e:	e9 f8 f1 ff ff       	jmp    8010841b <alltraps>

80109223 <vector198>:
.globl vector198
vector198:
  pushl $0
80109223:	6a 00                	push   $0x0
  pushl $198
80109225:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
8010922a:	e9 ec f1 ff ff       	jmp    8010841b <alltraps>

8010922f <vector199>:
.globl vector199
vector199:
  pushl $0
8010922f:	6a 00                	push   $0x0
  pushl $199
80109231:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80109236:	e9 e0 f1 ff ff       	jmp    8010841b <alltraps>

8010923b <vector200>:
.globl vector200
vector200:
  pushl $0
8010923b:	6a 00                	push   $0x0
  pushl $200
8010923d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80109242:	e9 d4 f1 ff ff       	jmp    8010841b <alltraps>

80109247 <vector201>:
.globl vector201
vector201:
  pushl $0
80109247:	6a 00                	push   $0x0
  pushl $201
80109249:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010924e:	e9 c8 f1 ff ff       	jmp    8010841b <alltraps>

80109253 <vector202>:
.globl vector202
vector202:
  pushl $0
80109253:	6a 00                	push   $0x0
  pushl $202
80109255:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010925a:	e9 bc f1 ff ff       	jmp    8010841b <alltraps>

8010925f <vector203>:
.globl vector203
vector203:
  pushl $0
8010925f:	6a 00                	push   $0x0
  pushl $203
80109261:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80109266:	e9 b0 f1 ff ff       	jmp    8010841b <alltraps>

8010926b <vector204>:
.globl vector204
vector204:
  pushl $0
8010926b:	6a 00                	push   $0x0
  pushl $204
8010926d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80109272:	e9 a4 f1 ff ff       	jmp    8010841b <alltraps>

80109277 <vector205>:
.globl vector205
vector205:
  pushl $0
80109277:	6a 00                	push   $0x0
  pushl $205
80109279:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010927e:	e9 98 f1 ff ff       	jmp    8010841b <alltraps>

80109283 <vector206>:
.globl vector206
vector206:
  pushl $0
80109283:	6a 00                	push   $0x0
  pushl $206
80109285:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010928a:	e9 8c f1 ff ff       	jmp    8010841b <alltraps>

8010928f <vector207>:
.globl vector207
vector207:
  pushl $0
8010928f:	6a 00                	push   $0x0
  pushl $207
80109291:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80109296:	e9 80 f1 ff ff       	jmp    8010841b <alltraps>

8010929b <vector208>:
.globl vector208
vector208:
  pushl $0
8010929b:	6a 00                	push   $0x0
  pushl $208
8010929d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801092a2:	e9 74 f1 ff ff       	jmp    8010841b <alltraps>

801092a7 <vector209>:
.globl vector209
vector209:
  pushl $0
801092a7:	6a 00                	push   $0x0
  pushl $209
801092a9:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801092ae:	e9 68 f1 ff ff       	jmp    8010841b <alltraps>

801092b3 <vector210>:
.globl vector210
vector210:
  pushl $0
801092b3:	6a 00                	push   $0x0
  pushl $210
801092b5:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801092ba:	e9 5c f1 ff ff       	jmp    8010841b <alltraps>

801092bf <vector211>:
.globl vector211
vector211:
  pushl $0
801092bf:	6a 00                	push   $0x0
  pushl $211
801092c1:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801092c6:	e9 50 f1 ff ff       	jmp    8010841b <alltraps>

801092cb <vector212>:
.globl vector212
vector212:
  pushl $0
801092cb:	6a 00                	push   $0x0
  pushl $212
801092cd:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801092d2:	e9 44 f1 ff ff       	jmp    8010841b <alltraps>

801092d7 <vector213>:
.globl vector213
vector213:
  pushl $0
801092d7:	6a 00                	push   $0x0
  pushl $213
801092d9:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801092de:	e9 38 f1 ff ff       	jmp    8010841b <alltraps>

801092e3 <vector214>:
.globl vector214
vector214:
  pushl $0
801092e3:	6a 00                	push   $0x0
  pushl $214
801092e5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801092ea:	e9 2c f1 ff ff       	jmp    8010841b <alltraps>

801092ef <vector215>:
.globl vector215
vector215:
  pushl $0
801092ef:	6a 00                	push   $0x0
  pushl $215
801092f1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801092f6:	e9 20 f1 ff ff       	jmp    8010841b <alltraps>

801092fb <vector216>:
.globl vector216
vector216:
  pushl $0
801092fb:	6a 00                	push   $0x0
  pushl $216
801092fd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80109302:	e9 14 f1 ff ff       	jmp    8010841b <alltraps>

80109307 <vector217>:
.globl vector217
vector217:
  pushl $0
80109307:	6a 00                	push   $0x0
  pushl $217
80109309:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010930e:	e9 08 f1 ff ff       	jmp    8010841b <alltraps>

80109313 <vector218>:
.globl vector218
vector218:
  pushl $0
80109313:	6a 00                	push   $0x0
  pushl $218
80109315:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010931a:	e9 fc f0 ff ff       	jmp    8010841b <alltraps>

8010931f <vector219>:
.globl vector219
vector219:
  pushl $0
8010931f:	6a 00                	push   $0x0
  pushl $219
80109321:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80109326:	e9 f0 f0 ff ff       	jmp    8010841b <alltraps>

8010932b <vector220>:
.globl vector220
vector220:
  pushl $0
8010932b:	6a 00                	push   $0x0
  pushl $220
8010932d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80109332:	e9 e4 f0 ff ff       	jmp    8010841b <alltraps>

80109337 <vector221>:
.globl vector221
vector221:
  pushl $0
80109337:	6a 00                	push   $0x0
  pushl $221
80109339:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010933e:	e9 d8 f0 ff ff       	jmp    8010841b <alltraps>

80109343 <vector222>:
.globl vector222
vector222:
  pushl $0
80109343:	6a 00                	push   $0x0
  pushl $222
80109345:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010934a:	e9 cc f0 ff ff       	jmp    8010841b <alltraps>

8010934f <vector223>:
.globl vector223
vector223:
  pushl $0
8010934f:	6a 00                	push   $0x0
  pushl $223
80109351:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80109356:	e9 c0 f0 ff ff       	jmp    8010841b <alltraps>

8010935b <vector224>:
.globl vector224
vector224:
  pushl $0
8010935b:	6a 00                	push   $0x0
  pushl $224
8010935d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80109362:	e9 b4 f0 ff ff       	jmp    8010841b <alltraps>

80109367 <vector225>:
.globl vector225
vector225:
  pushl $0
80109367:	6a 00                	push   $0x0
  pushl $225
80109369:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010936e:	e9 a8 f0 ff ff       	jmp    8010841b <alltraps>

80109373 <vector226>:
.globl vector226
vector226:
  pushl $0
80109373:	6a 00                	push   $0x0
  pushl $226
80109375:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010937a:	e9 9c f0 ff ff       	jmp    8010841b <alltraps>

8010937f <vector227>:
.globl vector227
vector227:
  pushl $0
8010937f:	6a 00                	push   $0x0
  pushl $227
80109381:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80109386:	e9 90 f0 ff ff       	jmp    8010841b <alltraps>

8010938b <vector228>:
.globl vector228
vector228:
  pushl $0
8010938b:	6a 00                	push   $0x0
  pushl $228
8010938d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80109392:	e9 84 f0 ff ff       	jmp    8010841b <alltraps>

80109397 <vector229>:
.globl vector229
vector229:
  pushl $0
80109397:	6a 00                	push   $0x0
  pushl $229
80109399:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010939e:	e9 78 f0 ff ff       	jmp    8010841b <alltraps>

801093a3 <vector230>:
.globl vector230
vector230:
  pushl $0
801093a3:	6a 00                	push   $0x0
  pushl $230
801093a5:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801093aa:	e9 6c f0 ff ff       	jmp    8010841b <alltraps>

801093af <vector231>:
.globl vector231
vector231:
  pushl $0
801093af:	6a 00                	push   $0x0
  pushl $231
801093b1:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801093b6:	e9 60 f0 ff ff       	jmp    8010841b <alltraps>

801093bb <vector232>:
.globl vector232
vector232:
  pushl $0
801093bb:	6a 00                	push   $0x0
  pushl $232
801093bd:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801093c2:	e9 54 f0 ff ff       	jmp    8010841b <alltraps>

801093c7 <vector233>:
.globl vector233
vector233:
  pushl $0
801093c7:	6a 00                	push   $0x0
  pushl $233
801093c9:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801093ce:	e9 48 f0 ff ff       	jmp    8010841b <alltraps>

801093d3 <vector234>:
.globl vector234
vector234:
  pushl $0
801093d3:	6a 00                	push   $0x0
  pushl $234
801093d5:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801093da:	e9 3c f0 ff ff       	jmp    8010841b <alltraps>

801093df <vector235>:
.globl vector235
vector235:
  pushl $0
801093df:	6a 00                	push   $0x0
  pushl $235
801093e1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801093e6:	e9 30 f0 ff ff       	jmp    8010841b <alltraps>

801093eb <vector236>:
.globl vector236
vector236:
  pushl $0
801093eb:	6a 00                	push   $0x0
  pushl $236
801093ed:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801093f2:	e9 24 f0 ff ff       	jmp    8010841b <alltraps>

801093f7 <vector237>:
.globl vector237
vector237:
  pushl $0
801093f7:	6a 00                	push   $0x0
  pushl $237
801093f9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801093fe:	e9 18 f0 ff ff       	jmp    8010841b <alltraps>

80109403 <vector238>:
.globl vector238
vector238:
  pushl $0
80109403:	6a 00                	push   $0x0
  pushl $238
80109405:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010940a:	e9 0c f0 ff ff       	jmp    8010841b <alltraps>

8010940f <vector239>:
.globl vector239
vector239:
  pushl $0
8010940f:	6a 00                	push   $0x0
  pushl $239
80109411:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80109416:	e9 00 f0 ff ff       	jmp    8010841b <alltraps>

8010941b <vector240>:
.globl vector240
vector240:
  pushl $0
8010941b:	6a 00                	push   $0x0
  pushl $240
8010941d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80109422:	e9 f4 ef ff ff       	jmp    8010841b <alltraps>

80109427 <vector241>:
.globl vector241
vector241:
  pushl $0
80109427:	6a 00                	push   $0x0
  pushl $241
80109429:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010942e:	e9 e8 ef ff ff       	jmp    8010841b <alltraps>

80109433 <vector242>:
.globl vector242
vector242:
  pushl $0
80109433:	6a 00                	push   $0x0
  pushl $242
80109435:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010943a:	e9 dc ef ff ff       	jmp    8010841b <alltraps>

8010943f <vector243>:
.globl vector243
vector243:
  pushl $0
8010943f:	6a 00                	push   $0x0
  pushl $243
80109441:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80109446:	e9 d0 ef ff ff       	jmp    8010841b <alltraps>

8010944b <vector244>:
.globl vector244
vector244:
  pushl $0
8010944b:	6a 00                	push   $0x0
  pushl $244
8010944d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80109452:	e9 c4 ef ff ff       	jmp    8010841b <alltraps>

80109457 <vector245>:
.globl vector245
vector245:
  pushl $0
80109457:	6a 00                	push   $0x0
  pushl $245
80109459:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010945e:	e9 b8 ef ff ff       	jmp    8010841b <alltraps>

80109463 <vector246>:
.globl vector246
vector246:
  pushl $0
80109463:	6a 00                	push   $0x0
  pushl $246
80109465:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010946a:	e9 ac ef ff ff       	jmp    8010841b <alltraps>

8010946f <vector247>:
.globl vector247
vector247:
  pushl $0
8010946f:	6a 00                	push   $0x0
  pushl $247
80109471:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80109476:	e9 a0 ef ff ff       	jmp    8010841b <alltraps>

8010947b <vector248>:
.globl vector248
vector248:
  pushl $0
8010947b:	6a 00                	push   $0x0
  pushl $248
8010947d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80109482:	e9 94 ef ff ff       	jmp    8010841b <alltraps>

80109487 <vector249>:
.globl vector249
vector249:
  pushl $0
80109487:	6a 00                	push   $0x0
  pushl $249
80109489:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010948e:	e9 88 ef ff ff       	jmp    8010841b <alltraps>

80109493 <vector250>:
.globl vector250
vector250:
  pushl $0
80109493:	6a 00                	push   $0x0
  pushl $250
80109495:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010949a:	e9 7c ef ff ff       	jmp    8010841b <alltraps>

8010949f <vector251>:
.globl vector251
vector251:
  pushl $0
8010949f:	6a 00                	push   $0x0
  pushl $251
801094a1:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801094a6:	e9 70 ef ff ff       	jmp    8010841b <alltraps>

801094ab <vector252>:
.globl vector252
vector252:
  pushl $0
801094ab:	6a 00                	push   $0x0
  pushl $252
801094ad:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801094b2:	e9 64 ef ff ff       	jmp    8010841b <alltraps>

801094b7 <vector253>:
.globl vector253
vector253:
  pushl $0
801094b7:	6a 00                	push   $0x0
  pushl $253
801094b9:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801094be:	e9 58 ef ff ff       	jmp    8010841b <alltraps>

801094c3 <vector254>:
.globl vector254
vector254:
  pushl $0
801094c3:	6a 00                	push   $0x0
  pushl $254
801094c5:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801094ca:	e9 4c ef ff ff       	jmp    8010841b <alltraps>

801094cf <vector255>:
.globl vector255
vector255:
  pushl $0
801094cf:	6a 00                	push   $0x0
  pushl $255
801094d1:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801094d6:	e9 40 ef ff ff       	jmp    8010841b <alltraps>

801094db <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
801094db:	55                   	push   %ebp
801094dc:	89 e5                	mov    %esp,%ebp
801094de:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801094e1:	8b 45 0c             	mov    0xc(%ebp),%eax
801094e4:	83 e8 01             	sub    $0x1,%eax
801094e7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801094eb:	8b 45 08             	mov    0x8(%ebp),%eax
801094ee:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801094f2:	8b 45 08             	mov    0x8(%ebp),%eax
801094f5:	c1 e8 10             	shr    $0x10,%eax
801094f8:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801094fc:	8d 45 fa             	lea    -0x6(%ebp),%eax
801094ff:	0f 01 10             	lgdtl  (%eax)
}
80109502:	90                   	nop
80109503:	c9                   	leave  
80109504:	c3                   	ret    

80109505 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80109505:	55                   	push   %ebp
80109506:	89 e5                	mov    %esp,%ebp
80109508:	83 ec 04             	sub    $0x4,%esp
8010950b:	8b 45 08             	mov    0x8(%ebp),%eax
8010950e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80109512:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80109516:	0f 00 d8             	ltr    %ax
}
80109519:	90                   	nop
8010951a:	c9                   	leave  
8010951b:	c3                   	ret    

8010951c <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
8010951c:	55                   	push   %ebp
8010951d:	89 e5                	mov    %esp,%ebp
8010951f:	83 ec 04             	sub    $0x4,%esp
80109522:	8b 45 08             	mov    0x8(%ebp),%eax
80109525:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80109529:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010952d:	8e e8                	mov    %eax,%gs
}
8010952f:	90                   	nop
80109530:	c9                   	leave  
80109531:	c3                   	ret    

80109532 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80109532:	55                   	push   %ebp
80109533:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80109535:	8b 45 08             	mov    0x8(%ebp),%eax
80109538:	0f 22 d8             	mov    %eax,%cr3
}
8010953b:	90                   	nop
8010953c:	5d                   	pop    %ebp
8010953d:	c3                   	ret    

8010953e <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
8010953e:	55                   	push   %ebp
8010953f:	89 e5                	mov    %esp,%ebp
80109541:	8b 45 08             	mov    0x8(%ebp),%eax
80109544:	05 00 00 00 80       	add    $0x80000000,%eax
80109549:	5d                   	pop    %ebp
8010954a:	c3                   	ret    

8010954b <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010954b:	55                   	push   %ebp
8010954c:	89 e5                	mov    %esp,%ebp
8010954e:	8b 45 08             	mov    0x8(%ebp),%eax
80109551:	05 00 00 00 80       	add    $0x80000000,%eax
80109556:	5d                   	pop    %ebp
80109557:	c3                   	ret    

80109558 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80109558:	55                   	push   %ebp
80109559:	89 e5                	mov    %esp,%ebp
8010955b:	53                   	push   %ebx
8010955c:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
8010955f:	e8 99 9d ff ff       	call   801032fd <cpunum>
80109564:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010956a:	05 a0 53 11 80       	add    $0x801153a0,%eax
8010956f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80109572:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109575:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
8010957b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010957e:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80109584:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109587:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
8010958b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010958e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109592:	83 e2 f0             	and    $0xfffffff0,%edx
80109595:	83 ca 0a             	or     $0xa,%edx
80109598:	88 50 7d             	mov    %dl,0x7d(%eax)
8010959b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010959e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801095a2:	83 ca 10             	or     $0x10,%edx
801095a5:	88 50 7d             	mov    %dl,0x7d(%eax)
801095a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ab:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801095af:	83 e2 9f             	and    $0xffffff9f,%edx
801095b2:	88 50 7d             	mov    %dl,0x7d(%eax)
801095b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095b8:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801095bc:	83 ca 80             	or     $0xffffff80,%edx
801095bf:	88 50 7d             	mov    %dl,0x7d(%eax)
801095c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095c5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801095c9:	83 ca 0f             	or     $0xf,%edx
801095cc:	88 50 7e             	mov    %dl,0x7e(%eax)
801095cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095d2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801095d6:	83 e2 ef             	and    $0xffffffef,%edx
801095d9:	88 50 7e             	mov    %dl,0x7e(%eax)
801095dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095df:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801095e3:	83 e2 df             	and    $0xffffffdf,%edx
801095e6:	88 50 7e             	mov    %dl,0x7e(%eax)
801095e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ec:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801095f0:	83 ca 40             	or     $0x40,%edx
801095f3:	88 50 7e             	mov    %dl,0x7e(%eax)
801095f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f9:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801095fd:	83 ca 80             	or     $0xffffff80,%edx
80109600:	88 50 7e             	mov    %dl,0x7e(%eax)
80109603:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109606:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010960a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010960d:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80109614:	ff ff 
80109616:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109619:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80109620:	00 00 
80109622:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109625:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
8010962c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010962f:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109636:	83 e2 f0             	and    $0xfffffff0,%edx
80109639:	83 ca 02             	or     $0x2,%edx
8010963c:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109642:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109645:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010964c:	83 ca 10             	or     $0x10,%edx
8010964f:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109655:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109658:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010965f:	83 e2 9f             	and    $0xffffff9f,%edx
80109662:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109668:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010966b:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80109672:	83 ca 80             	or     $0xffffff80,%edx
80109675:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010967b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010967e:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109685:	83 ca 0f             	or     $0xf,%edx
80109688:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010968e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109691:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109698:	83 e2 ef             	and    $0xffffffef,%edx
8010969b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801096a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096a4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801096ab:	83 e2 df             	and    $0xffffffdf,%edx
801096ae:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801096b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096b7:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801096be:	83 ca 40             	or     $0x40,%edx
801096c1:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801096c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096ca:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801096d1:	83 ca 80             	or     $0xffffff80,%edx
801096d4:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801096da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096dd:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801096e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096e7:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801096ee:	ff ff 
801096f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096f3:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801096fa:	00 00 
801096fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096ff:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80109706:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109709:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109710:	83 e2 f0             	and    $0xfffffff0,%edx
80109713:	83 ca 0a             	or     $0xa,%edx
80109716:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010971c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010971f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109726:	83 ca 10             	or     $0x10,%edx
80109729:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010972f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109732:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109739:	83 ca 60             	or     $0x60,%edx
8010973c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109745:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010974c:	83 ca 80             	or     $0xffffff80,%edx
8010974f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109755:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109758:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010975f:	83 ca 0f             	or     $0xf,%edx
80109762:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109768:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010976b:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109772:	83 e2 ef             	and    $0xffffffef,%edx
80109775:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010977b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010977e:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109785:	83 e2 df             	and    $0xffffffdf,%edx
80109788:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010978e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109791:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109798:	83 ca 40             	or     $0x40,%edx
8010979b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801097a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097a4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801097ab:	83 ca 80             	or     $0xffffff80,%edx
801097ae:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801097b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097b7:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801097be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097c1:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801097c8:	ff ff 
801097ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097cd:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801097d4:	00 00 
801097d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097d9:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801097e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097e3:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801097ea:	83 e2 f0             	and    $0xfffffff0,%edx
801097ed:	83 ca 02             	or     $0x2,%edx
801097f0:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801097f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097f9:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109800:	83 ca 10             	or     $0x10,%edx
80109803:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109809:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010980c:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109813:	83 ca 60             	or     $0x60,%edx
80109816:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010981c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010981f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109826:	83 ca 80             	or     $0xffffff80,%edx
80109829:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010982f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109832:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109839:	83 ca 0f             	or     $0xf,%edx
8010983c:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109842:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109845:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010984c:	83 e2 ef             	and    $0xffffffef,%edx
8010984f:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109858:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010985f:	83 e2 df             	and    $0xffffffdf,%edx
80109862:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109868:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010986b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109872:	83 ca 40             	or     $0x40,%edx
80109875:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010987b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010987e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109885:	83 ca 80             	or     $0xffffff80,%edx
80109888:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010988e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109891:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80109898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010989b:	05 b4 00 00 00       	add    $0xb4,%eax
801098a0:	89 c3                	mov    %eax,%ebx
801098a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098a5:	05 b4 00 00 00       	add    $0xb4,%eax
801098aa:	c1 e8 10             	shr    $0x10,%eax
801098ad:	89 c2                	mov    %eax,%edx
801098af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098b2:	05 b4 00 00 00       	add    $0xb4,%eax
801098b7:	c1 e8 18             	shr    $0x18,%eax
801098ba:	89 c1                	mov    %eax,%ecx
801098bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098bf:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801098c6:	00 00 
801098c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098cb:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801098d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098d5:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
801098db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098de:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801098e5:	83 e2 f0             	and    $0xfffffff0,%edx
801098e8:	83 ca 02             	or     $0x2,%edx
801098eb:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801098f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098f4:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801098fb:	83 ca 10             	or     $0x10,%edx
801098fe:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109904:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109907:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010990e:	83 e2 9f             	and    $0xffffff9f,%edx
80109911:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109917:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010991a:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109921:	83 ca 80             	or     $0xffffff80,%edx
80109924:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010992a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010992d:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109934:	83 e2 f0             	and    $0xfffffff0,%edx
80109937:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
8010993d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109940:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109947:	83 e2 ef             	and    $0xffffffef,%edx
8010994a:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109950:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109953:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010995a:	83 e2 df             	and    $0xffffffdf,%edx
8010995d:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109963:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109966:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010996d:	83 ca 40             	or     $0x40,%edx
80109970:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109976:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109979:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109980:	83 ca 80             	or     $0xffffff80,%edx
80109983:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109989:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010998c:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80109992:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109995:	83 c0 70             	add    $0x70,%eax
80109998:	83 ec 08             	sub    $0x8,%esp
8010999b:	6a 38                	push   $0x38
8010999d:	50                   	push   %eax
8010999e:	e8 38 fb ff ff       	call   801094db <lgdt>
801099a3:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
801099a6:	83 ec 0c             	sub    $0xc,%esp
801099a9:	6a 18                	push   $0x18
801099ab:	e8 6c fb ff ff       	call   8010951c <loadgs>
801099b0:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
801099b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801099b6:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801099bc:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801099c3:	00 00 00 00 
}
801099c7:	90                   	nop
801099c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801099cb:	c9                   	leave  
801099cc:	c3                   	ret    

801099cd <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801099cd:	55                   	push   %ebp
801099ce:	89 e5                	mov    %esp,%ebp
801099d0:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801099d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801099d6:	c1 e8 16             	shr    $0x16,%eax
801099d9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801099e0:	8b 45 08             	mov    0x8(%ebp),%eax
801099e3:	01 d0                	add    %edx,%eax
801099e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801099e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099eb:	8b 00                	mov    (%eax),%eax
801099ed:	83 e0 01             	and    $0x1,%eax
801099f0:	85 c0                	test   %eax,%eax
801099f2:	74 18                	je     80109a0c <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801099f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801099f7:	8b 00                	mov    (%eax),%eax
801099f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801099fe:	50                   	push   %eax
801099ff:	e8 47 fb ff ff       	call   8010954b <p2v>
80109a04:	83 c4 04             	add    $0x4,%esp
80109a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109a0a:	eb 48                	jmp    80109a54 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80109a0c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80109a10:	74 0e                	je     80109a20 <walkpgdir+0x53>
80109a12:	e8 80 95 ff ff       	call   80102f97 <kalloc>
80109a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109a1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109a1e:	75 07                	jne    80109a27 <walkpgdir+0x5a>
      return 0;
80109a20:	b8 00 00 00 00       	mov    $0x0,%eax
80109a25:	eb 44                	jmp    80109a6b <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80109a27:	83 ec 04             	sub    $0x4,%esp
80109a2a:	68 00 10 00 00       	push   $0x1000
80109a2f:	6a 00                	push   $0x0
80109a31:	ff 75 f4             	pushl  -0xc(%ebp)
80109a34:	e8 f7 d2 ff ff       	call   80106d30 <memset>
80109a39:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80109a3c:	83 ec 0c             	sub    $0xc,%esp
80109a3f:	ff 75 f4             	pushl  -0xc(%ebp)
80109a42:	e8 f7 fa ff ff       	call   8010953e <v2p>
80109a47:	83 c4 10             	add    $0x10,%esp
80109a4a:	83 c8 07             	or     $0x7,%eax
80109a4d:	89 c2                	mov    %eax,%edx
80109a4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109a52:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80109a54:	8b 45 0c             	mov    0xc(%ebp),%eax
80109a57:	c1 e8 0c             	shr    $0xc,%eax
80109a5a:	25 ff 03 00 00       	and    $0x3ff,%eax
80109a5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109a69:	01 d0                	add    %edx,%eax
}
80109a6b:	c9                   	leave  
80109a6c:	c3                   	ret    

80109a6d <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80109a6d:	55                   	push   %ebp
80109a6e:	89 e5                	mov    %esp,%ebp
80109a70:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80109a73:	8b 45 0c             	mov    0xc(%ebp),%eax
80109a76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80109a7e:	8b 55 0c             	mov    0xc(%ebp),%edx
80109a81:	8b 45 10             	mov    0x10(%ebp),%eax
80109a84:	01 d0                	add    %edx,%eax
80109a86:	83 e8 01             	sub    $0x1,%eax
80109a89:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109a8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80109a91:	83 ec 04             	sub    $0x4,%esp
80109a94:	6a 01                	push   $0x1
80109a96:	ff 75 f4             	pushl  -0xc(%ebp)
80109a99:	ff 75 08             	pushl  0x8(%ebp)
80109a9c:	e8 2c ff ff ff       	call   801099cd <walkpgdir>
80109aa1:	83 c4 10             	add    $0x10,%esp
80109aa4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109aa7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109aab:	75 07                	jne    80109ab4 <mappages+0x47>
      return -1;
80109aad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109ab2:	eb 47                	jmp    80109afb <mappages+0x8e>
    if(*pte & PTE_P)
80109ab4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ab7:	8b 00                	mov    (%eax),%eax
80109ab9:	83 e0 01             	and    $0x1,%eax
80109abc:	85 c0                	test   %eax,%eax
80109abe:	74 0d                	je     80109acd <mappages+0x60>
      panic("remap");
80109ac0:	83 ec 0c             	sub    $0xc,%esp
80109ac3:	68 2c b0 10 80       	push   $0x8010b02c
80109ac8:	e8 99 6a ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80109acd:	8b 45 18             	mov    0x18(%ebp),%eax
80109ad0:	0b 45 14             	or     0x14(%ebp),%eax
80109ad3:	83 c8 01             	or     $0x1,%eax
80109ad6:	89 c2                	mov    %eax,%edx
80109ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109adb:	89 10                	mov    %edx,(%eax)
    if(a == last)
80109add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ae0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109ae3:	74 10                	je     80109af5 <mappages+0x88>
      break;
    a += PGSIZE;
80109ae5:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80109aec:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80109af3:	eb 9c                	jmp    80109a91 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80109af5:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80109af6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109afb:	c9                   	leave  
80109afc:	c3                   	ret    

80109afd <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80109afd:	55                   	push   %ebp
80109afe:	89 e5                	mov    %esp,%ebp
80109b00:	53                   	push   %ebx
80109b01:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80109b04:	e8 8e 94 ff ff       	call   80102f97 <kalloc>
80109b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109b0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109b10:	75 0a                	jne    80109b1c <setupkvm+0x1f>
    return 0;
80109b12:	b8 00 00 00 00       	mov    $0x0,%eax
80109b17:	e9 8e 00 00 00       	jmp    80109baa <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80109b1c:	83 ec 04             	sub    $0x4,%esp
80109b1f:	68 00 10 00 00       	push   $0x1000
80109b24:	6a 00                	push   $0x0
80109b26:	ff 75 f0             	pushl  -0x10(%ebp)
80109b29:	e8 02 d2 ff ff       	call   80106d30 <memset>
80109b2e:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80109b31:	83 ec 0c             	sub    $0xc,%esp
80109b34:	68 00 00 00 0e       	push   $0xe000000
80109b39:	e8 0d fa ff ff       	call   8010954b <p2v>
80109b3e:	83 c4 10             	add    $0x10,%esp
80109b41:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80109b46:	76 0d                	jbe    80109b55 <setupkvm+0x58>
    panic("PHYSTOP too high");
80109b48:	83 ec 0c             	sub    $0xc,%esp
80109b4b:	68 32 b0 10 80       	push   $0x8010b032
80109b50:	e8 11 6a ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109b55:	c7 45 f4 e0 e4 10 80 	movl   $0x8010e4e0,-0xc(%ebp)
80109b5c:	eb 40                	jmp    80109b9e <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80109b5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b61:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80109b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b67:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80109b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b6d:	8b 58 08             	mov    0x8(%eax),%ebx
80109b70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b73:	8b 40 04             	mov    0x4(%eax),%eax
80109b76:	29 c3                	sub    %eax,%ebx
80109b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b7b:	8b 00                	mov    (%eax),%eax
80109b7d:	83 ec 0c             	sub    $0xc,%esp
80109b80:	51                   	push   %ecx
80109b81:	52                   	push   %edx
80109b82:	53                   	push   %ebx
80109b83:	50                   	push   %eax
80109b84:	ff 75 f0             	pushl  -0x10(%ebp)
80109b87:	e8 e1 fe ff ff       	call   80109a6d <mappages>
80109b8c:	83 c4 20             	add    $0x20,%esp
80109b8f:	85 c0                	test   %eax,%eax
80109b91:	79 07                	jns    80109b9a <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80109b93:	b8 00 00 00 00       	mov    $0x0,%eax
80109b98:	eb 10                	jmp    80109baa <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109b9a:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80109b9e:	81 7d f4 20 e5 10 80 	cmpl   $0x8010e520,-0xc(%ebp)
80109ba5:	72 b7                	jb     80109b5e <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80109ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109baa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109bad:	c9                   	leave  
80109bae:	c3                   	ret    

80109baf <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80109baf:	55                   	push   %ebp
80109bb0:	89 e5                	mov    %esp,%ebp
80109bb2:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109bb5:	e8 43 ff ff ff       	call   80109afd <setupkvm>
80109bba:	a3 58 89 11 80       	mov    %eax,0x80118958
  switchkvm();
80109bbf:	e8 03 00 00 00       	call   80109bc7 <switchkvm>
}
80109bc4:	90                   	nop
80109bc5:	c9                   	leave  
80109bc6:	c3                   	ret    

80109bc7 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109bc7:	55                   	push   %ebp
80109bc8:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109bca:	a1 58 89 11 80       	mov    0x80118958,%eax
80109bcf:	50                   	push   %eax
80109bd0:	e8 69 f9 ff ff       	call   8010953e <v2p>
80109bd5:	83 c4 04             	add    $0x4,%esp
80109bd8:	50                   	push   %eax
80109bd9:	e8 54 f9 ff ff       	call   80109532 <lcr3>
80109bde:	83 c4 04             	add    $0x4,%esp
}
80109be1:	90                   	nop
80109be2:	c9                   	leave  
80109be3:	c3                   	ret    

80109be4 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80109be4:	55                   	push   %ebp
80109be5:	89 e5                	mov    %esp,%ebp
80109be7:	56                   	push   %esi
80109be8:	53                   	push   %ebx
  pushcli();
80109be9:	e8 3c d0 ff ff       	call   80106c2a <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80109bee:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109bf4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109bfb:	83 c2 08             	add    $0x8,%edx
80109bfe:	89 d6                	mov    %edx,%esi
80109c00:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109c07:	83 c2 08             	add    $0x8,%edx
80109c0a:	c1 ea 10             	shr    $0x10,%edx
80109c0d:	89 d3                	mov    %edx,%ebx
80109c0f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109c16:	83 c2 08             	add    $0x8,%edx
80109c19:	c1 ea 18             	shr    $0x18,%edx
80109c1c:	89 d1                	mov    %edx,%ecx
80109c1e:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80109c25:	67 00 
80109c27:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
80109c2e:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80109c34:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109c3b:	83 e2 f0             	and    $0xfffffff0,%edx
80109c3e:	83 ca 09             	or     $0x9,%edx
80109c41:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109c47:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109c4e:	83 ca 10             	or     $0x10,%edx
80109c51:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109c57:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109c5e:	83 e2 9f             	and    $0xffffff9f,%edx
80109c61:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109c67:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109c6e:	83 ca 80             	or     $0xffffff80,%edx
80109c71:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109c77:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109c7e:	83 e2 f0             	and    $0xfffffff0,%edx
80109c81:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109c87:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109c8e:	83 e2 ef             	and    $0xffffffef,%edx
80109c91:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109c97:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109c9e:	83 e2 df             	and    $0xffffffdf,%edx
80109ca1:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109ca7:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109cae:	83 ca 40             	or     $0x40,%edx
80109cb1:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109cb7:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109cbe:	83 e2 7f             	and    $0x7f,%edx
80109cc1:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109cc7:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80109ccd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109cd3:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109cda:	83 e2 ef             	and    $0xffffffef,%edx
80109cdd:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109ce3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109ce9:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80109cef:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109cf5:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80109cfc:	8b 52 08             	mov    0x8(%edx),%edx
80109cff:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109d05:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109d08:	83 ec 0c             	sub    $0xc,%esp
80109d0b:	6a 30                	push   $0x30
80109d0d:	e8 f3 f7 ff ff       	call   80109505 <ltr>
80109d12:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109d15:	8b 45 08             	mov    0x8(%ebp),%eax
80109d18:	8b 40 04             	mov    0x4(%eax),%eax
80109d1b:	85 c0                	test   %eax,%eax
80109d1d:	75 0d                	jne    80109d2c <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80109d1f:	83 ec 0c             	sub    $0xc,%esp
80109d22:	68 43 b0 10 80       	push   $0x8010b043
80109d27:	e8 3a 68 ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80109d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80109d2f:	8b 40 04             	mov    0x4(%eax),%eax
80109d32:	83 ec 0c             	sub    $0xc,%esp
80109d35:	50                   	push   %eax
80109d36:	e8 03 f8 ff ff       	call   8010953e <v2p>
80109d3b:	83 c4 10             	add    $0x10,%esp
80109d3e:	83 ec 0c             	sub    $0xc,%esp
80109d41:	50                   	push   %eax
80109d42:	e8 eb f7 ff ff       	call   80109532 <lcr3>
80109d47:	83 c4 10             	add    $0x10,%esp
  popcli();
80109d4a:	e8 20 cf ff ff       	call   80106c6f <popcli>
}
80109d4f:	90                   	nop
80109d50:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109d53:	5b                   	pop    %ebx
80109d54:	5e                   	pop    %esi
80109d55:	5d                   	pop    %ebp
80109d56:	c3                   	ret    

80109d57 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109d57:	55                   	push   %ebp
80109d58:	89 e5                	mov    %esp,%ebp
80109d5a:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80109d5d:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80109d64:	76 0d                	jbe    80109d73 <inituvm+0x1c>
    panic("inituvm: more than a page");
80109d66:	83 ec 0c             	sub    $0xc,%esp
80109d69:	68 57 b0 10 80       	push   $0x8010b057
80109d6e:	e8 f3 67 ff ff       	call   80100566 <panic>
  mem = kalloc();
80109d73:	e8 1f 92 ff ff       	call   80102f97 <kalloc>
80109d78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80109d7b:	83 ec 04             	sub    $0x4,%esp
80109d7e:	68 00 10 00 00       	push   $0x1000
80109d83:	6a 00                	push   $0x0
80109d85:	ff 75 f4             	pushl  -0xc(%ebp)
80109d88:	e8 a3 cf ff ff       	call   80106d30 <memset>
80109d8d:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109d90:	83 ec 0c             	sub    $0xc,%esp
80109d93:	ff 75 f4             	pushl  -0xc(%ebp)
80109d96:	e8 a3 f7 ff ff       	call   8010953e <v2p>
80109d9b:	83 c4 10             	add    $0x10,%esp
80109d9e:	83 ec 0c             	sub    $0xc,%esp
80109da1:	6a 06                	push   $0x6
80109da3:	50                   	push   %eax
80109da4:	68 00 10 00 00       	push   $0x1000
80109da9:	6a 00                	push   $0x0
80109dab:	ff 75 08             	pushl  0x8(%ebp)
80109dae:	e8 ba fc ff ff       	call   80109a6d <mappages>
80109db3:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109db6:	83 ec 04             	sub    $0x4,%esp
80109db9:	ff 75 10             	pushl  0x10(%ebp)
80109dbc:	ff 75 0c             	pushl  0xc(%ebp)
80109dbf:	ff 75 f4             	pushl  -0xc(%ebp)
80109dc2:	e8 28 d0 ff ff       	call   80106def <memmove>
80109dc7:	83 c4 10             	add    $0x10,%esp
}
80109dca:	90                   	nop
80109dcb:	c9                   	leave  
80109dcc:	c3                   	ret    

80109dcd <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80109dcd:	55                   	push   %ebp
80109dce:	89 e5                	mov    %esp,%ebp
80109dd0:	53                   	push   %ebx
80109dd1:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
80109dd7:	25 ff 0f 00 00       	and    $0xfff,%eax
80109ddc:	85 c0                	test   %eax,%eax
80109dde:	74 0d                	je     80109ded <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80109de0:	83 ec 0c             	sub    $0xc,%esp
80109de3:	68 74 b0 10 80       	push   $0x8010b074
80109de8:	e8 79 67 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109ded:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109df4:	e9 95 00 00 00       	jmp    80109e8e <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109df9:	8b 55 0c             	mov    0xc(%ebp),%edx
80109dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109dff:	01 d0                	add    %edx,%eax
80109e01:	83 ec 04             	sub    $0x4,%esp
80109e04:	6a 00                	push   $0x0
80109e06:	50                   	push   %eax
80109e07:	ff 75 08             	pushl  0x8(%ebp)
80109e0a:	e8 be fb ff ff       	call   801099cd <walkpgdir>
80109e0f:	83 c4 10             	add    $0x10,%esp
80109e12:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109e15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109e19:	75 0d                	jne    80109e28 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109e1b:	83 ec 0c             	sub    $0xc,%esp
80109e1e:	68 97 b0 10 80       	push   $0x8010b097
80109e23:	e8 3e 67 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109e28:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109e2b:	8b 00                	mov    (%eax),%eax
80109e2d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109e32:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109e35:	8b 45 18             	mov    0x18(%ebp),%eax
80109e38:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109e3b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109e40:	77 0b                	ja     80109e4d <loaduvm+0x80>
      n = sz - i;
80109e42:	8b 45 18             	mov    0x18(%ebp),%eax
80109e45:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109e4b:	eb 07                	jmp    80109e54 <loaduvm+0x87>
    else
      n = PGSIZE;
80109e4d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109e54:	8b 55 14             	mov    0x14(%ebp),%edx
80109e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e5a:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109e5d:	83 ec 0c             	sub    $0xc,%esp
80109e60:	ff 75 e8             	pushl  -0x18(%ebp)
80109e63:	e8 e3 f6 ff ff       	call   8010954b <p2v>
80109e68:	83 c4 10             	add    $0x10,%esp
80109e6b:	ff 75 f0             	pushl  -0x10(%ebp)
80109e6e:	53                   	push   %ebx
80109e6f:	50                   	push   %eax
80109e70:	ff 75 10             	pushl  0x10(%ebp)
80109e73:	e8 44 82 ff ff       	call   801020bc <readi>
80109e78:	83 c4 10             	add    $0x10,%esp
80109e7b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109e7e:	74 07                	je     80109e87 <loaduvm+0xba>
      return -1;
80109e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109e85:	eb 18                	jmp    80109e9f <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109e87:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e91:	3b 45 18             	cmp    0x18(%ebp),%eax
80109e94:	0f 82 5f ff ff ff    	jb     80109df9 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109e9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109e9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109ea2:	c9                   	leave  
80109ea3:	c3                   	ret    

80109ea4 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109ea4:	55                   	push   %ebp
80109ea5:	89 e5                	mov    %esp,%ebp
80109ea7:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109eaa:	8b 45 10             	mov    0x10(%ebp),%eax
80109ead:	85 c0                	test   %eax,%eax
80109eaf:	79 0a                	jns    80109ebb <allocuvm+0x17>
    return 0;
80109eb1:	b8 00 00 00 00       	mov    $0x0,%eax
80109eb6:	e9 b0 00 00 00       	jmp    80109f6b <allocuvm+0xc7>
  if(newsz < oldsz)
80109ebb:	8b 45 10             	mov    0x10(%ebp),%eax
80109ebe:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109ec1:	73 08                	jae    80109ecb <allocuvm+0x27>
    return oldsz;
80109ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
80109ec6:	e9 a0 00 00 00       	jmp    80109f6b <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
80109ece:	05 ff 0f 00 00       	add    $0xfff,%eax
80109ed3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109ed8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109edb:	eb 7f                	jmp    80109f5c <allocuvm+0xb8>
    mem = kalloc();
80109edd:	e8 b5 90 ff ff       	call   80102f97 <kalloc>
80109ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109ee5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109ee9:	75 2b                	jne    80109f16 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109eeb:	83 ec 0c             	sub    $0xc,%esp
80109eee:	68 b5 b0 10 80       	push   $0x8010b0b5
80109ef3:	e8 ce 64 ff ff       	call   801003c6 <cprintf>
80109ef8:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109efb:	83 ec 04             	sub    $0x4,%esp
80109efe:	ff 75 0c             	pushl  0xc(%ebp)
80109f01:	ff 75 10             	pushl  0x10(%ebp)
80109f04:	ff 75 08             	pushl  0x8(%ebp)
80109f07:	e8 61 00 00 00       	call   80109f6d <deallocuvm>
80109f0c:	83 c4 10             	add    $0x10,%esp
      return 0;
80109f0f:	b8 00 00 00 00       	mov    $0x0,%eax
80109f14:	eb 55                	jmp    80109f6b <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109f16:	83 ec 04             	sub    $0x4,%esp
80109f19:	68 00 10 00 00       	push   $0x1000
80109f1e:	6a 00                	push   $0x0
80109f20:	ff 75 f0             	pushl  -0x10(%ebp)
80109f23:	e8 08 ce ff ff       	call   80106d30 <memset>
80109f28:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109f2b:	83 ec 0c             	sub    $0xc,%esp
80109f2e:	ff 75 f0             	pushl  -0x10(%ebp)
80109f31:	e8 08 f6 ff ff       	call   8010953e <v2p>
80109f36:	83 c4 10             	add    $0x10,%esp
80109f39:	89 c2                	mov    %eax,%edx
80109f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f3e:	83 ec 0c             	sub    $0xc,%esp
80109f41:	6a 06                	push   $0x6
80109f43:	52                   	push   %edx
80109f44:	68 00 10 00 00       	push   $0x1000
80109f49:	50                   	push   %eax
80109f4a:	ff 75 08             	pushl  0x8(%ebp)
80109f4d:	e8 1b fb ff ff       	call   80109a6d <mappages>
80109f52:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109f55:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f5f:	3b 45 10             	cmp    0x10(%ebp),%eax
80109f62:	0f 82 75 ff ff ff    	jb     80109edd <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109f68:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109f6b:	c9                   	leave  
80109f6c:	c3                   	ret    

80109f6d <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109f6d:	55                   	push   %ebp
80109f6e:	89 e5                	mov    %esp,%ebp
80109f70:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109f73:	8b 45 10             	mov    0x10(%ebp),%eax
80109f76:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109f79:	72 08                	jb     80109f83 <deallocuvm+0x16>
    return oldsz;
80109f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
80109f7e:	e9 a5 00 00 00       	jmp    8010a028 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109f83:	8b 45 10             	mov    0x10(%ebp),%eax
80109f86:	05 ff 0f 00 00       	add    $0xfff,%eax
80109f8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109f90:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109f93:	e9 81 00 00 00       	jmp    8010a019 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f9b:	83 ec 04             	sub    $0x4,%esp
80109f9e:	6a 00                	push   $0x0
80109fa0:	50                   	push   %eax
80109fa1:	ff 75 08             	pushl  0x8(%ebp)
80109fa4:	e8 24 fa ff ff       	call   801099cd <walkpgdir>
80109fa9:	83 c4 10             	add    $0x10,%esp
80109fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109faf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109fb3:	75 09                	jne    80109fbe <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109fb5:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109fbc:	eb 54                	jmp    8010a012 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109fbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109fc1:	8b 00                	mov    (%eax),%eax
80109fc3:	83 e0 01             	and    $0x1,%eax
80109fc6:	85 c0                	test   %eax,%eax
80109fc8:	74 48                	je     8010a012 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109fcd:	8b 00                	mov    (%eax),%eax
80109fcf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109fd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109fd7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109fdb:	75 0d                	jne    80109fea <deallocuvm+0x7d>
        panic("kfree");
80109fdd:	83 ec 0c             	sub    $0xc,%esp
80109fe0:	68 cd b0 10 80       	push   $0x8010b0cd
80109fe5:	e8 7c 65 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109fea:	83 ec 0c             	sub    $0xc,%esp
80109fed:	ff 75 ec             	pushl  -0x14(%ebp)
80109ff0:	e8 56 f5 ff ff       	call   8010954b <p2v>
80109ff5:	83 c4 10             	add    $0x10,%esp
80109ff8:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109ffb:	83 ec 0c             	sub    $0xc,%esp
80109ffe:	ff 75 e8             	pushl  -0x18(%ebp)
8010a001:	e8 f4 8e ff ff       	call   80102efa <kfree>
8010a006:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
8010a009:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a00c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010a012:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010a019:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a01c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010a01f:	0f 82 73 ff ff ff    	jb     80109f98 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
8010a025:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010a028:	c9                   	leave  
8010a029:	c3                   	ret    

8010a02a <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010a02a:	55                   	push   %ebp
8010a02b:	89 e5                	mov    %esp,%ebp
8010a02d:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010a030:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010a034:	75 0d                	jne    8010a043 <freevm+0x19>
    panic("freevm: no pgdir");
8010a036:	83 ec 0c             	sub    $0xc,%esp
8010a039:	68 d3 b0 10 80       	push   $0x8010b0d3
8010a03e:	e8 23 65 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010a043:	83 ec 04             	sub    $0x4,%esp
8010a046:	6a 00                	push   $0x0
8010a048:	68 00 00 00 80       	push   $0x80000000
8010a04d:	ff 75 08             	pushl  0x8(%ebp)
8010a050:	e8 18 ff ff ff       	call   80109f6d <deallocuvm>
8010a055:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
8010a058:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010a05f:	eb 4f                	jmp    8010a0b0 <freevm+0x86>
    if(pgdir[i] & PTE_P){
8010a061:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a064:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010a06b:	8b 45 08             	mov    0x8(%ebp),%eax
8010a06e:	01 d0                	add    %edx,%eax
8010a070:	8b 00                	mov    (%eax),%eax
8010a072:	83 e0 01             	and    $0x1,%eax
8010a075:	85 c0                	test   %eax,%eax
8010a077:	74 33                	je     8010a0ac <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
8010a079:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a07c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010a083:	8b 45 08             	mov    0x8(%ebp),%eax
8010a086:	01 d0                	add    %edx,%eax
8010a088:	8b 00                	mov    (%eax),%eax
8010a08a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a08f:	83 ec 0c             	sub    $0xc,%esp
8010a092:	50                   	push   %eax
8010a093:	e8 b3 f4 ff ff       	call   8010954b <p2v>
8010a098:	83 c4 10             	add    $0x10,%esp
8010a09b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010a09e:	83 ec 0c             	sub    $0xc,%esp
8010a0a1:	ff 75 f0             	pushl  -0x10(%ebp)
8010a0a4:	e8 51 8e ff ff       	call   80102efa <kfree>
8010a0a9:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
8010a0ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010a0b0:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010a0b7:	76 a8                	jbe    8010a061 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
8010a0b9:	83 ec 0c             	sub    $0xc,%esp
8010a0bc:	ff 75 08             	pushl  0x8(%ebp)
8010a0bf:	e8 36 8e ff ff       	call   80102efa <kfree>
8010a0c4:	83 c4 10             	add    $0x10,%esp
}
8010a0c7:	90                   	nop
8010a0c8:	c9                   	leave  
8010a0c9:	c3                   	ret    

8010a0ca <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010a0ca:	55                   	push   %ebp
8010a0cb:	89 e5                	mov    %esp,%ebp
8010a0cd:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010a0d0:	83 ec 04             	sub    $0x4,%esp
8010a0d3:	6a 00                	push   $0x0
8010a0d5:	ff 75 0c             	pushl  0xc(%ebp)
8010a0d8:	ff 75 08             	pushl  0x8(%ebp)
8010a0db:	e8 ed f8 ff ff       	call   801099cd <walkpgdir>
8010a0e0:	83 c4 10             	add    $0x10,%esp
8010a0e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
8010a0e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010a0ea:	75 0d                	jne    8010a0f9 <clearpteu+0x2f>
    panic("clearpteu");
8010a0ec:	83 ec 0c             	sub    $0xc,%esp
8010a0ef:	68 e4 b0 10 80       	push   $0x8010b0e4
8010a0f4:	e8 6d 64 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
8010a0f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a0fc:	8b 00                	mov    (%eax),%eax
8010a0fe:	83 e0 fb             	and    $0xfffffffb,%eax
8010a101:	89 c2                	mov    %eax,%edx
8010a103:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a106:	89 10                	mov    %edx,(%eax)
}
8010a108:	90                   	nop
8010a109:	c9                   	leave  
8010a10a:	c3                   	ret    

8010a10b <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010a10b:	55                   	push   %ebp
8010a10c:	89 e5                	mov    %esp,%ebp
8010a10e:	53                   	push   %ebx
8010a10f:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010a112:	e8 e6 f9 ff ff       	call   80109afd <setupkvm>
8010a117:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010a11a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010a11e:	75 0a                	jne    8010a12a <copyuvm+0x1f>
    return 0;
8010a120:	b8 00 00 00 00       	mov    $0x0,%eax
8010a125:	e9 f8 00 00 00       	jmp    8010a222 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
8010a12a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010a131:	e9 c4 00 00 00       	jmp    8010a1fa <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010a136:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a139:	83 ec 04             	sub    $0x4,%esp
8010a13c:	6a 00                	push   $0x0
8010a13e:	50                   	push   %eax
8010a13f:	ff 75 08             	pushl  0x8(%ebp)
8010a142:	e8 86 f8 ff ff       	call   801099cd <walkpgdir>
8010a147:	83 c4 10             	add    $0x10,%esp
8010a14a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010a14d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010a151:	75 0d                	jne    8010a160 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
8010a153:	83 ec 0c             	sub    $0xc,%esp
8010a156:	68 ee b0 10 80       	push   $0x8010b0ee
8010a15b:	e8 06 64 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
8010a160:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a163:	8b 00                	mov    (%eax),%eax
8010a165:	83 e0 01             	and    $0x1,%eax
8010a168:	85 c0                	test   %eax,%eax
8010a16a:	75 0d                	jne    8010a179 <copyuvm+0x6e>
      panic("copyuvm: page not present");
8010a16c:	83 ec 0c             	sub    $0xc,%esp
8010a16f:	68 08 b1 10 80       	push   $0x8010b108
8010a174:	e8 ed 63 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
8010a179:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a17c:	8b 00                	mov    (%eax),%eax
8010a17e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a183:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010a186:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a189:	8b 00                	mov    (%eax),%eax
8010a18b:	25 ff 0f 00 00       	and    $0xfff,%eax
8010a190:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010a193:	e8 ff 8d ff ff       	call   80102f97 <kalloc>
8010a198:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010a19b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010a19f:	74 6a                	je     8010a20b <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010a1a1:	83 ec 0c             	sub    $0xc,%esp
8010a1a4:	ff 75 e8             	pushl  -0x18(%ebp)
8010a1a7:	e8 9f f3 ff ff       	call   8010954b <p2v>
8010a1ac:	83 c4 10             	add    $0x10,%esp
8010a1af:	83 ec 04             	sub    $0x4,%esp
8010a1b2:	68 00 10 00 00       	push   $0x1000
8010a1b7:	50                   	push   %eax
8010a1b8:	ff 75 e0             	pushl  -0x20(%ebp)
8010a1bb:	e8 2f cc ff ff       	call   80106def <memmove>
8010a1c0:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
8010a1c3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010a1c6:	83 ec 0c             	sub    $0xc,%esp
8010a1c9:	ff 75 e0             	pushl  -0x20(%ebp)
8010a1cc:	e8 6d f3 ff ff       	call   8010953e <v2p>
8010a1d1:	83 c4 10             	add    $0x10,%esp
8010a1d4:	89 c2                	mov    %eax,%edx
8010a1d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a1d9:	83 ec 0c             	sub    $0xc,%esp
8010a1dc:	53                   	push   %ebx
8010a1dd:	52                   	push   %edx
8010a1de:	68 00 10 00 00       	push   $0x1000
8010a1e3:	50                   	push   %eax
8010a1e4:	ff 75 f0             	pushl  -0x10(%ebp)
8010a1e7:	e8 81 f8 ff ff       	call   80109a6d <mappages>
8010a1ec:	83 c4 20             	add    $0x20,%esp
8010a1ef:	85 c0                	test   %eax,%eax
8010a1f1:	78 1b                	js     8010a20e <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010a1f3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010a1fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a1fd:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010a200:	0f 82 30 ff ff ff    	jb     8010a136 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
8010a206:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a209:	eb 17                	jmp    8010a222 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
8010a20b:	90                   	nop
8010a20c:	eb 01                	jmp    8010a20f <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
8010a20e:	90                   	nop
  }
  return d;

bad:
  freevm(d);
8010a20f:	83 ec 0c             	sub    $0xc,%esp
8010a212:	ff 75 f0             	pushl  -0x10(%ebp)
8010a215:	e8 10 fe ff ff       	call   8010a02a <freevm>
8010a21a:	83 c4 10             	add    $0x10,%esp
  return 0;
8010a21d:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010a222:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010a225:	c9                   	leave  
8010a226:	c3                   	ret    

8010a227 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010a227:	55                   	push   %ebp
8010a228:	89 e5                	mov    %esp,%ebp
8010a22a:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010a22d:	83 ec 04             	sub    $0x4,%esp
8010a230:	6a 00                	push   $0x0
8010a232:	ff 75 0c             	pushl  0xc(%ebp)
8010a235:	ff 75 08             	pushl  0x8(%ebp)
8010a238:	e8 90 f7 ff ff       	call   801099cd <walkpgdir>
8010a23d:	83 c4 10             	add    $0x10,%esp
8010a240:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010a243:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a246:	8b 00                	mov    (%eax),%eax
8010a248:	83 e0 01             	and    $0x1,%eax
8010a24b:	85 c0                	test   %eax,%eax
8010a24d:	75 07                	jne    8010a256 <uva2ka+0x2f>
    return 0;
8010a24f:	b8 00 00 00 00       	mov    $0x0,%eax
8010a254:	eb 29                	jmp    8010a27f <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
8010a256:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a259:	8b 00                	mov    (%eax),%eax
8010a25b:	83 e0 04             	and    $0x4,%eax
8010a25e:	85 c0                	test   %eax,%eax
8010a260:	75 07                	jne    8010a269 <uva2ka+0x42>
    return 0;
8010a262:	b8 00 00 00 00       	mov    $0x0,%eax
8010a267:	eb 16                	jmp    8010a27f <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
8010a269:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a26c:	8b 00                	mov    (%eax),%eax
8010a26e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a273:	83 ec 0c             	sub    $0xc,%esp
8010a276:	50                   	push   %eax
8010a277:	e8 cf f2 ff ff       	call   8010954b <p2v>
8010a27c:	83 c4 10             	add    $0x10,%esp
}
8010a27f:	c9                   	leave  
8010a280:	c3                   	ret    

8010a281 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010a281:	55                   	push   %ebp
8010a282:	89 e5                	mov    %esp,%ebp
8010a284:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010a287:	8b 45 10             	mov    0x10(%ebp),%eax
8010a28a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010a28d:	eb 7f                	jmp    8010a30e <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
8010a28f:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a292:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a297:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010a29a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a29d:	83 ec 08             	sub    $0x8,%esp
8010a2a0:	50                   	push   %eax
8010a2a1:	ff 75 08             	pushl  0x8(%ebp)
8010a2a4:	e8 7e ff ff ff       	call   8010a227 <uva2ka>
8010a2a9:	83 c4 10             	add    $0x10,%esp
8010a2ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010a2af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010a2b3:	75 07                	jne    8010a2bc <copyout+0x3b>
      return -1;
8010a2b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010a2ba:	eb 61                	jmp    8010a31d <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010a2bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a2bf:	2b 45 0c             	sub    0xc(%ebp),%eax
8010a2c2:	05 00 10 00 00       	add    $0x1000,%eax
8010a2c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010a2ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a2cd:	3b 45 14             	cmp    0x14(%ebp),%eax
8010a2d0:	76 06                	jbe    8010a2d8 <copyout+0x57>
      n = len;
8010a2d2:	8b 45 14             	mov    0x14(%ebp),%eax
8010a2d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010a2d8:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a2db:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010a2de:	89 c2                	mov    %eax,%edx
8010a2e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a2e3:	01 d0                	add    %edx,%eax
8010a2e5:	83 ec 04             	sub    $0x4,%esp
8010a2e8:	ff 75 f0             	pushl  -0x10(%ebp)
8010a2eb:	ff 75 f4             	pushl  -0xc(%ebp)
8010a2ee:	50                   	push   %eax
8010a2ef:	e8 fb ca ff ff       	call   80106def <memmove>
8010a2f4:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010a2f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a2fa:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010a2fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a300:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010a303:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a306:	05 00 10 00 00       	add    $0x1000,%eax
8010a30b:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010a30e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010a312:	0f 85 77 ff ff ff    	jne    8010a28f <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010a318:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010a31d:	c9                   	leave  
8010a31e:	c3                   	ret    
