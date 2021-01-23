
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
80100015:	b8 00 80 10 00       	mov    $0x108000,%eax
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
80100028:	bc 20 c6 10 80       	mov    $0x8010c620,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 8d 2a 10 80       	mov    $0x80102a8d,%eax
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
80100037:	53                   	push   %ebx
80100038:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003b:	68 a0 65 10 80       	push   $0x801065a0
80100040:	68 20 c6 10 80       	push   $0x8010c620
80100045:	e8 20 3c 00 00       	call   80103c6a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004a:	c7 05 6c 0d 11 80 1c 	movl   $0x80110d1c,0x80110d6c
80100051:	0d 11 80 
  bcache.head.next = &bcache.head;
80100054:	c7 05 70 0d 11 80 1c 	movl   $0x80110d1c,0x80110d70
8010005b:	0d 11 80 
8010005e:	83 c4 10             	add    $0x10,%esp
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100061:	bb 54 c6 10 80       	mov    $0x8010c654,%ebx
    b->next = bcache.head.next;
80100066:	a1 70 0d 11 80       	mov    0x80110d70,%eax
8010006b:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010006e:	c7 43 50 1c 0d 11 80 	movl   $0x80110d1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100075:	83 ec 08             	sub    $0x8,%esp
80100078:	68 a7 65 10 80       	push   $0x801065a7
8010007d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100080:	50                   	push   %eax
80100081:	e8 fd 3a 00 00       	call   80103b83 <initsleeplock>
    bcache.head.next->prev = b;
80100086:	a1 70 0d 11 80       	mov    0x80110d70,%eax
8010008b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010008e:	89 1d 70 0d 11 80    	mov    %ebx,0x80110d70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100094:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010009a:	83 c4 10             	add    $0x10,%esp
8010009d:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
801000a3:	72 c1                	jb     80100066 <binit+0x32>
  }
}
801000a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000a8:	c9                   	leave  
801000a9:	c3                   	ret    

801000aa <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000aa:	55                   	push   %ebp
801000ab:	89 e5                	mov    %esp,%ebp
801000ad:	57                   	push   %edi
801000ae:	56                   	push   %esi
801000af:	53                   	push   %ebx
801000b0:	83 ec 18             	sub    $0x18,%esp
801000b3:	8b 75 08             	mov    0x8(%ebp),%esi
801000b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000b9:	68 20 c6 10 80       	push   $0x8010c620
801000be:	e8 ef 3c 00 00       	call   80103db2 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c3:	8b 1d 70 0d 11 80    	mov    0x80110d70,%ebx
801000c9:	83 c4 10             	add    $0x10,%esp
801000cc:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
801000d2:	75 26                	jne    801000fa <bread+0x50>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801000d4:	8b 1d 6c 0d 11 80    	mov    0x80110d6c,%ebx
801000da:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
801000e0:	75 4e                	jne    80100130 <bread+0x86>
  panic("bget: no buffers");
801000e2:	83 ec 0c             	sub    $0xc,%esp
801000e5:	68 ae 65 10 80       	push   $0x801065ae
801000ea:	e8 55 02 00 00       	call   80100344 <panic>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ef:	8b 5b 54             	mov    0x54(%ebx),%ebx
801000f2:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
801000f8:	74 da                	je     801000d4 <bread+0x2a>
    if(b->dev == dev && b->blockno == blockno){
801000fa:	3b 73 04             	cmp    0x4(%ebx),%esi
801000fd:	75 f0                	jne    801000ef <bread+0x45>
801000ff:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100102:	75 eb                	jne    801000ef <bread+0x45>
      b->refcnt++;
80100104:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100108:	83 ec 0c             	sub    $0xc,%esp
8010010b:	68 20 c6 10 80       	push   $0x8010c620
80100110:	e8 04 3d 00 00       	call   80103e19 <release>
      acquiresleep(&b->lock);
80100115:	8d 43 0c             	lea    0xc(%ebx),%eax
80100118:	89 04 24             	mov    %eax,(%esp)
8010011b:	e8 96 3a 00 00       	call   80103bb6 <acquiresleep>
80100120:	83 c4 10             	add    $0x10,%esp
80100123:	eb 44                	jmp    80100169 <bread+0xbf>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100125:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100128:	81 fb 1c 0d 11 80    	cmp    $0x80110d1c,%ebx
8010012e:	74 b2                	je     801000e2 <bread+0x38>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100130:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80100134:	75 ef                	jne    80100125 <bread+0x7b>
80100136:	f6 03 04             	testb  $0x4,(%ebx)
80100139:	75 ea                	jne    80100125 <bread+0x7b>
      b->dev = dev;
8010013b:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010013e:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
80100141:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100147:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010014e:	83 ec 0c             	sub    $0xc,%esp
80100151:	68 20 c6 10 80       	push   $0x8010c620
80100156:	e8 be 3c 00 00       	call   80103e19 <release>
      acquiresleep(&b->lock);
8010015b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010015e:	89 04 24             	mov    %eax,(%esp)
80100161:	e8 50 3a 00 00       	call   80103bb6 <acquiresleep>
80100166:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100169:	f6 03 02             	testb  $0x2,(%ebx)
8010016c:	74 0a                	je     80100178 <bread+0xce>
    iderw(b);
  }
  return b;
}
8010016e:	89 d8                	mov    %ebx,%eax
80100170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100173:	5b                   	pop    %ebx
80100174:	5e                   	pop    %esi
80100175:	5f                   	pop    %edi
80100176:	5d                   	pop    %ebp
80100177:	c3                   	ret    
    iderw(b);
80100178:	83 ec 0c             	sub    $0xc,%esp
8010017b:	53                   	push   %ebx
8010017c:	e8 10 1d 00 00       	call   80101e91 <iderw>
80100181:	83 c4 10             	add    $0x10,%esp
  return b;
80100184:	eb e8                	jmp    8010016e <bread+0xc4>

80100186 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100186:	55                   	push   %ebp
80100187:	89 e5                	mov    %esp,%ebp
80100189:	53                   	push   %ebx
8010018a:	83 ec 10             	sub    $0x10,%esp
8010018d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80100190:	8d 43 0c             	lea    0xc(%ebx),%eax
80100193:	50                   	push   %eax
80100194:	e8 aa 3a 00 00       	call   80103c43 <holdingsleep>
80100199:	83 c4 10             	add    $0x10,%esp
8010019c:	85 c0                	test   %eax,%eax
8010019e:	74 14                	je     801001b4 <bwrite+0x2e>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001a0:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001a3:	83 ec 0c             	sub    $0xc,%esp
801001a6:	53                   	push   %ebx
801001a7:	e8 e5 1c 00 00       	call   80101e91 <iderw>
}
801001ac:	83 c4 10             	add    $0x10,%esp
801001af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001b2:	c9                   	leave  
801001b3:	c3                   	ret    
    panic("bwrite");
801001b4:	83 ec 0c             	sub    $0xc,%esp
801001b7:	68 bf 65 10 80       	push   $0x801065bf
801001bc:	e8 83 01 00 00       	call   80100344 <panic>

801001c1 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001c1:	55                   	push   %ebp
801001c2:	89 e5                	mov    %esp,%ebp
801001c4:	56                   	push   %esi
801001c5:	53                   	push   %ebx
801001c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001c9:	8d 73 0c             	lea    0xc(%ebx),%esi
801001cc:	83 ec 0c             	sub    $0xc,%esp
801001cf:	56                   	push   %esi
801001d0:	e8 6e 3a 00 00       	call   80103c43 <holdingsleep>
801001d5:	83 c4 10             	add    $0x10,%esp
801001d8:	85 c0                	test   %eax,%eax
801001da:	74 6b                	je     80100247 <brelse+0x86>
    panic("brelse");

  releasesleep(&b->lock);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	56                   	push   %esi
801001e0:	e8 23 3a 00 00       	call   80103c08 <releasesleep>

  acquire(&bcache.lock);
801001e5:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801001ec:	e8 c1 3b 00 00       	call   80103db2 <acquire>
  b->refcnt--;
801001f1:	8b 43 4c             	mov    0x4c(%ebx),%eax
801001f4:	83 e8 01             	sub    $0x1,%eax
801001f7:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
801001fa:	83 c4 10             	add    $0x10,%esp
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 2f                	jne    80100230 <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100201:	8b 43 54             	mov    0x54(%ebx),%eax
80100204:	8b 53 50             	mov    0x50(%ebx),%edx
80100207:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010020a:	8b 43 50             	mov    0x50(%ebx),%eax
8010020d:	8b 53 54             	mov    0x54(%ebx),%edx
80100210:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100213:	a1 70 0d 11 80       	mov    0x80110d70,%eax
80100218:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010021b:	c7 43 50 1c 0d 11 80 	movl   $0x80110d1c,0x50(%ebx)
    bcache.head.next->prev = b;
80100222:	a1 70 0d 11 80       	mov    0x80110d70,%eax
80100227:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010022a:	89 1d 70 0d 11 80    	mov    %ebx,0x80110d70
  }
  
  release(&bcache.lock);
80100230:	83 ec 0c             	sub    $0xc,%esp
80100233:	68 20 c6 10 80       	push   $0x8010c620
80100238:	e8 dc 3b 00 00       	call   80103e19 <release>
}
8010023d:	83 c4 10             	add    $0x10,%esp
80100240:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100243:	5b                   	pop    %ebx
80100244:	5e                   	pop    %esi
80100245:	5d                   	pop    %ebp
80100246:	c3                   	ret    
    panic("brelse");
80100247:	83 ec 0c             	sub    $0xc,%esp
8010024a:	68 c6 65 10 80       	push   $0x801065c6
8010024f:	e8 f0 00 00 00       	call   80100344 <panic>

80100254 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100254:	55                   	push   %ebp
80100255:	89 e5                	mov    %esp,%ebp
80100257:	57                   	push   %edi
80100258:	56                   	push   %esi
80100259:	53                   	push   %ebx
8010025a:	83 ec 28             	sub    $0x28,%esp
8010025d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100260:	8b 75 10             	mov    0x10(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
80100263:	ff 75 08             	pushl  0x8(%ebp)
80100266:	e8 3f 13 00 00       	call   801015aa <iunlock>
  target = n;
8010026b:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  acquire(&cons.lock);
8010026e:	c7 04 24 20 95 10 80 	movl   $0x80109520,(%esp)
80100275:	e8 38 3b 00 00       	call   80103db2 <acquire>
  while(n > 0){
8010027a:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
8010027d:	bb 80 0f 11 80       	mov    $0x80110f80,%ebx
  while(n > 0){
80100282:	85 f6                	test   %esi,%esi
80100284:	7e 68                	jle    801002ee <consoleread+0x9a>
    while(input.r == input.w){
80100286:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
8010028c:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100292:	75 2e                	jne    801002c2 <consoleread+0x6e>
      if(myproc()->killed){
80100294:	e8 a2 30 00 00       	call   8010333b <myproc>
80100299:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010029d:	75 71                	jne    80100310 <consoleread+0xbc>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
8010029f:	83 ec 08             	sub    $0x8,%esp
801002a2:	68 20 95 10 80       	push   $0x80109520
801002a7:	68 00 10 11 80       	push   $0x80111000
801002ac:	e8 4f 35 00 00       	call   80103800 <sleep>
    while(input.r == input.w){
801002b1:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801002b7:	83 c4 10             	add    $0x10,%esp
801002ba:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
801002c0:	74 d2                	je     80100294 <consoleread+0x40>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002c2:	8d 50 01             	lea    0x1(%eax),%edx
801002c5:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
801002cb:	89 c2                	mov    %eax,%edx
801002cd:	83 e2 7f             	and    $0x7f,%edx
801002d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801002d4:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002d7:	83 fa 04             	cmp    $0x4,%edx
801002da:	74 5c                	je     80100338 <consoleread+0xe4>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002dc:	83 c7 01             	add    $0x1,%edi
801002df:	88 4f ff             	mov    %cl,-0x1(%edi)
    --n;
801002e2:	83 ee 01             	sub    $0x1,%esi
    if(c == '\n')
801002e5:	83 fa 0a             	cmp    $0xa,%edx
801002e8:	74 04                	je     801002ee <consoleread+0x9a>
  while(n > 0){
801002ea:	85 f6                	test   %esi,%esi
801002ec:	75 98                	jne    80100286 <consoleread+0x32>
      break;
  }
  release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 95 10 80       	push   $0x80109520
801002f6:	e8 1e 3b 00 00       	call   80103e19 <release>
  ilock(ip);
801002fb:	83 c4 04             	add    $0x4,%esp
801002fe:	ff 75 08             	pushl  0x8(%ebp)
80100301:	e8 e2 11 00 00       	call   801014e8 <ilock>

  return target - n;
80100306:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100309:	29 f0                	sub    %esi,%eax
8010030b:	83 c4 10             	add    $0x10,%esp
8010030e:	eb 20                	jmp    80100330 <consoleread+0xdc>
        release(&cons.lock);
80100310:	83 ec 0c             	sub    $0xc,%esp
80100313:	68 20 95 10 80       	push   $0x80109520
80100318:	e8 fc 3a 00 00       	call   80103e19 <release>
        ilock(ip);
8010031d:	83 c4 04             	add    $0x4,%esp
80100320:	ff 75 08             	pushl  0x8(%ebp)
80100323:	e8 c0 11 00 00       	call   801014e8 <ilock>
        return -1;
80100328:	83 c4 10             	add    $0x10,%esp
8010032b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100330:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100333:	5b                   	pop    %ebx
80100334:	5e                   	pop    %esi
80100335:	5f                   	pop    %edi
80100336:	5d                   	pop    %ebp
80100337:	c3                   	ret    
      if(n < target){
80100338:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010033b:	73 b1                	jae    801002ee <consoleread+0x9a>
        input.r--;
8010033d:	a3 00 10 11 80       	mov    %eax,0x80111000
80100342:	eb aa                	jmp    801002ee <consoleread+0x9a>

80100344 <panic>:
{
80100344:	55                   	push   %ebp
80100345:	89 e5                	mov    %esp,%ebp
80100347:	56                   	push   %esi
80100348:	53                   	push   %ebx
80100349:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010034c:	fa                   	cli    
  cons.locking = 0;
8010034d:	c7 05 54 95 10 80 00 	movl   $0x0,0x80109554
80100354:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100357:	e8 e6 20 00 00       	call   80102442 <lapicid>
8010035c:	83 ec 08             	sub    $0x8,%esp
8010035f:	50                   	push   %eax
80100360:	68 cd 65 10 80       	push   $0x801065cd
80100365:	e8 77 02 00 00       	call   801005e1 <cprintf>
  cprintf(s);
8010036a:	83 c4 04             	add    $0x4,%esp
8010036d:	ff 75 08             	pushl  0x8(%ebp)
80100370:	e8 6c 02 00 00       	call   801005e1 <cprintf>
  cprintf("\n");
80100375:	c7 04 24 4b 6f 10 80 	movl   $0x80106f4b,(%esp)
8010037c:	e8 60 02 00 00       	call   801005e1 <cprintf>
  getcallerpcs(&s, pcs);
80100381:	83 c4 08             	add    $0x8,%esp
80100384:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100387:	53                   	push   %ebx
80100388:	8d 45 08             	lea    0x8(%ebp),%eax
8010038b:	50                   	push   %eax
8010038c:	e8 f4 38 00 00       	call   80103c85 <getcallerpcs>
80100391:	8d 75 f8             	lea    -0x8(%ebp),%esi
80100394:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
80100397:	83 ec 08             	sub    $0x8,%esp
8010039a:	ff 33                	pushl  (%ebx)
8010039c:	68 e1 65 10 80       	push   $0x801065e1
801003a1:	e8 3b 02 00 00       	call   801005e1 <cprintf>
801003a6:	83 c3 04             	add    $0x4,%ebx
  for(i=0; i<10; i++)
801003a9:	83 c4 10             	add    $0x10,%esp
801003ac:	39 f3                	cmp    %esi,%ebx
801003ae:	75 e7                	jne    80100397 <panic+0x53>
  panicked = 1; // freeze other CPU
801003b0:	c7 05 58 95 10 80 01 	movl   $0x1,0x80109558
801003b7:	00 00 00 
801003ba:	eb fe                	jmp    801003ba <panic+0x76>

801003bc <consputc>:
  if(panicked){
801003bc:	83 3d 58 95 10 80 00 	cmpl   $0x0,0x80109558
801003c3:	74 03                	je     801003c8 <consputc+0xc>
801003c5:	fa                   	cli    
801003c6:	eb fe                	jmp    801003c6 <consputc+0xa>
{
801003c8:	55                   	push   %ebp
801003c9:	89 e5                	mov    %esp,%ebp
801003cb:	57                   	push   %edi
801003cc:	56                   	push   %esi
801003cd:	53                   	push   %ebx
801003ce:	83 ec 0c             	sub    $0xc,%esp
801003d1:	89 c6                	mov    %eax,%esi
  if(c == BACKSPACE){
801003d3:	3d 00 01 00 00       	cmp    $0x100,%eax
801003d8:	74 5f                	je     80100439 <consputc+0x7d>
    uartputc(c);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	50                   	push   %eax
801003de:	e8 0a 4e 00 00       	call   801051ed <uartputc>
801003e3:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e6:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801003eb:	b8 0e 00 00 00       	mov    $0xe,%eax
801003f0:	89 da                	mov    %ebx,%edx
801003f2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003f8:	89 ca                	mov    %ecx,%edx
801003fa:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003fb:	0f b6 c0             	movzbl %al,%eax
801003fe:	c1 e0 08             	shl    $0x8,%eax
80100401:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100403:	b8 0f 00 00 00       	mov    $0xf,%eax
80100408:	89 da                	mov    %ebx,%edx
8010040a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010040b:	89 ca                	mov    %ecx,%edx
8010040d:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010040e:	0f b6 d8             	movzbl %al,%ebx
80100411:	09 fb                	or     %edi,%ebx
  if(c == '\n')
80100413:	83 fe 0a             	cmp    $0xa,%esi
80100416:	74 48                	je     80100460 <consputc+0xa4>
  else if(c == BACKSPACE){
80100418:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010041e:	0f 84 93 00 00 00    	je     801004b7 <consputc+0xfb>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100424:	89 f0                	mov    %esi,%eax
80100426:	0f b6 c0             	movzbl %al,%eax
80100429:	80 cc 07             	or     $0x7,%ah
8010042c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100433:	80 
80100434:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100437:	eb 35                	jmp    8010046e <consputc+0xb2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100439:	83 ec 0c             	sub    $0xc,%esp
8010043c:	6a 08                	push   $0x8
8010043e:	e8 aa 4d 00 00       	call   801051ed <uartputc>
80100443:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010044a:	e8 9e 4d 00 00       	call   801051ed <uartputc>
8010044f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100456:	e8 92 4d 00 00       	call   801051ed <uartputc>
8010045b:	83 c4 10             	add    $0x10,%esp
8010045e:	eb 86                	jmp    801003e6 <consputc+0x2a>
    pos += 80 - pos%80;
80100460:	b9 50 00 00 00       	mov    $0x50,%ecx
80100465:	89 d8                	mov    %ebx,%eax
80100467:	99                   	cltd   
80100468:	f7 f9                	idiv   %ecx
8010046a:	29 d1                	sub    %edx,%ecx
8010046c:	01 cb                	add    %ecx,%ebx
  if(pos < 0 || pos > 25*80)
8010046e:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100474:	77 4a                	ja     801004c0 <consputc+0x104>
  if((pos/80) >= 24){  // Scroll up.
80100476:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010047c:	7f 4f                	jg     801004cd <consputc+0x111>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010047e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100483:	b8 0e 00 00 00       	mov    $0xe,%eax
80100488:	89 f2                	mov    %esi,%edx
8010048a:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
8010048b:	89 d8                	mov    %ebx,%eax
8010048d:	c1 f8 08             	sar    $0x8,%eax
80100490:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100495:	89 ca                	mov    %ecx,%edx
80100497:	ee                   	out    %al,(%dx)
80100498:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049d:	89 f2                	mov    %esi,%edx
8010049f:	ee                   	out    %al,(%dx)
801004a0:	89 d8                	mov    %ebx,%eax
801004a2:	89 ca                	mov    %ecx,%edx
801004a4:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a5:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
801004ac:	80 20 07 
}
801004af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004b2:	5b                   	pop    %ebx
801004b3:	5e                   	pop    %esi
801004b4:	5f                   	pop    %edi
801004b5:	5d                   	pop    %ebp
801004b6:	c3                   	ret    
    if(pos > 0) --pos;
801004b7:	85 db                	test   %ebx,%ebx
801004b9:	7e b3                	jle    8010046e <consputc+0xb2>
801004bb:	83 eb 01             	sub    $0x1,%ebx
801004be:	eb ae                	jmp    8010046e <consputc+0xb2>
    panic("pos under/overflow");
801004c0:	83 ec 0c             	sub    $0xc,%esp
801004c3:	68 e5 65 10 80       	push   $0x801065e5
801004c8:	e8 77 fe ff ff       	call   80100344 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004cd:	83 ec 04             	sub    $0x4,%esp
801004d0:	68 60 0e 00 00       	push   $0xe60
801004d5:	68 a0 80 0b 80       	push   $0x800b80a0
801004da:	68 00 80 0b 80       	push   $0x800b8000
801004df:	e8 11 3a 00 00       	call   80103ef5 <memmove>
    pos -= 80;
801004e4:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004e7:	83 c4 0c             	add    $0xc,%esp
801004ea:	b8 80 07 00 00       	mov    $0x780,%eax
801004ef:	29 d8                	sub    %ebx,%eax
801004f1:	01 c0                	add    %eax,%eax
801004f3:	50                   	push   %eax
801004f4:	6a 00                	push   $0x0
801004f6:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
801004f9:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
801004fe:	50                   	push   %eax
801004ff:	e8 5c 39 00 00       	call   80103e60 <memset>
80100504:	83 c4 10             	add    $0x10,%esp
80100507:	e9 72 ff ff ff       	jmp    8010047e <consputc+0xc2>

8010050c <printint>:
{
8010050c:	55                   	push   %ebp
8010050d:	89 e5                	mov    %esp,%ebp
8010050f:	57                   	push   %edi
80100510:	56                   	push   %esi
80100511:	53                   	push   %ebx
80100512:	83 ec 1c             	sub    $0x1c,%esp
80100515:	89 d6                	mov    %edx,%esi
  if(sign && (sign = xx < 0))
80100517:	85 c9                	test   %ecx,%ecx
80100519:	74 04                	je     8010051f <printint+0x13>
8010051b:	85 c0                	test   %eax,%eax
8010051d:	78 0e                	js     8010052d <printint+0x21>
    x = xx;
8010051f:	89 c2                	mov    %eax,%edx
80100521:	bf 00 00 00 00       	mov    $0x0,%edi
  i = 0;
80100526:	b9 00 00 00 00       	mov    $0x0,%ecx
8010052b:	eb 0d                	jmp    8010053a <printint+0x2e>
    x = -xx;
8010052d:	f7 d8                	neg    %eax
8010052f:	89 c2                	mov    %eax,%edx
  if(sign && (sign = xx < 0))
80100531:	bf 01 00 00 00       	mov    $0x1,%edi
    x = -xx;
80100536:	eb ee                	jmp    80100526 <printint+0x1a>
    buf[i++] = digits[x % base];
80100538:	89 d9                	mov    %ebx,%ecx
8010053a:	8d 59 01             	lea    0x1(%ecx),%ebx
8010053d:	89 d0                	mov    %edx,%eax
8010053f:	ba 00 00 00 00       	mov    $0x0,%edx
80100544:	f7 f6                	div    %esi
80100546:	0f b6 92 10 66 10 80 	movzbl -0x7fef99f0(%edx),%edx
8010054d:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100551:	89 c2                	mov    %eax,%edx
80100553:	85 c0                	test   %eax,%eax
80100555:	75 e1                	jne    80100538 <printint+0x2c>
  if(sign)
80100557:	85 ff                	test   %edi,%edi
80100559:	74 08                	je     80100563 <printint+0x57>
    buf[i++] = '-';
8010055b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100560:	8d 59 02             	lea    0x2(%ecx),%ebx
  while(--i >= 0)
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	78 12                	js     8010057a <printint+0x6e>
    consputc(buf[i]);
80100568:	0f be 44 2b d8       	movsbl -0x28(%ebx,%ebp,1),%eax
8010056d:	e8 4a fe ff ff       	call   801003bc <consputc>
  while(--i >= 0)
80100572:	83 eb 01             	sub    $0x1,%ebx
80100575:	83 fb ff             	cmp    $0xffffffff,%ebx
80100578:	75 ee                	jne    80100568 <printint+0x5c>
}
8010057a:	83 c4 1c             	add    $0x1c,%esp
8010057d:	5b                   	pop    %ebx
8010057e:	5e                   	pop    %esi
8010057f:	5f                   	pop    %edi
80100580:	5d                   	pop    %ebp
80100581:	c3                   	ret    

80100582 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100582:	55                   	push   %ebp
80100583:	89 e5                	mov    %esp,%ebp
80100585:	57                   	push   %edi
80100586:	56                   	push   %esi
80100587:	53                   	push   %ebx
80100588:	83 ec 18             	sub    $0x18,%esp
8010058b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010058e:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  iunlock(ip);
80100591:	ff 75 08             	pushl  0x8(%ebp)
80100594:	e8 11 10 00 00       	call   801015aa <iunlock>
  acquire(&cons.lock);
80100599:	c7 04 24 20 95 10 80 	movl   $0x80109520,(%esp)
801005a0:	e8 0d 38 00 00       	call   80103db2 <acquire>
  for(i = 0; i < n; i++)
801005a5:	83 c4 10             	add    $0x10,%esp
801005a8:	85 ff                	test   %edi,%edi
801005aa:	7e 13                	jle    801005bf <consolewrite+0x3d>
801005ac:	89 f3                	mov    %esi,%ebx
801005ae:	01 fe                	add    %edi,%esi
    consputc(buf[i] & 0xff);
801005b0:	0f b6 03             	movzbl (%ebx),%eax
801005b3:	e8 04 fe ff ff       	call   801003bc <consputc>
801005b8:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; i < n; i++)
801005bb:	39 f3                	cmp    %esi,%ebx
801005bd:	75 f1                	jne    801005b0 <consolewrite+0x2e>
  release(&cons.lock);
801005bf:	83 ec 0c             	sub    $0xc,%esp
801005c2:	68 20 95 10 80       	push   $0x80109520
801005c7:	e8 4d 38 00 00       	call   80103e19 <release>
  ilock(ip);
801005cc:	83 c4 04             	add    $0x4,%esp
801005cf:	ff 75 08             	pushl  0x8(%ebp)
801005d2:	e8 11 0f 00 00       	call   801014e8 <ilock>

  return n;
}
801005d7:	89 f8                	mov    %edi,%eax
801005d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005dc:	5b                   	pop    %ebx
801005dd:	5e                   	pop    %esi
801005de:	5f                   	pop    %edi
801005df:	5d                   	pop    %ebp
801005e0:	c3                   	ret    

801005e1 <cprintf>:
{
801005e1:	55                   	push   %ebp
801005e2:	89 e5                	mov    %esp,%ebp
801005e4:	57                   	push   %edi
801005e5:	56                   	push   %esi
801005e6:	53                   	push   %ebx
801005e7:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801005ea:	a1 54 95 10 80       	mov    0x80109554,%eax
801005ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801005f2:	85 c0                	test   %eax,%eax
801005f4:	75 2b                	jne    80100621 <cprintf+0x40>
  if (fmt == 0)
801005f6:	8b 7d 08             	mov    0x8(%ebp),%edi
801005f9:	85 ff                	test   %edi,%edi
801005fb:	74 36                	je     80100633 <cprintf+0x52>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005fd:	0f b6 07             	movzbl (%edi),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100600:	8d 4d 0c             	lea    0xc(%ebp),%ecx
80100603:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100606:	bb 00 00 00 00       	mov    $0x0,%ebx
8010060b:	85 c0                	test   %eax,%eax
8010060d:	75 41                	jne    80100650 <cprintf+0x6f>
  if(locking)
8010060f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100613:	0f 85 0d 01 00 00    	jne    80100726 <cprintf+0x145>
}
80100619:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010061c:	5b                   	pop    %ebx
8010061d:	5e                   	pop    %esi
8010061e:	5f                   	pop    %edi
8010061f:	5d                   	pop    %ebp
80100620:	c3                   	ret    
    acquire(&cons.lock);
80100621:	83 ec 0c             	sub    $0xc,%esp
80100624:	68 20 95 10 80       	push   $0x80109520
80100629:	e8 84 37 00 00       	call   80103db2 <acquire>
8010062e:	83 c4 10             	add    $0x10,%esp
80100631:	eb c3                	jmp    801005f6 <cprintf+0x15>
    panic("null fmt");
80100633:	83 ec 0c             	sub    $0xc,%esp
80100636:	68 ff 65 10 80       	push   $0x801065ff
8010063b:	e8 04 fd ff ff       	call   80100344 <panic>
      consputc(c);
80100640:	e8 77 fd ff ff       	call   801003bc <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100645:	83 c3 01             	add    $0x1,%ebx
80100648:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
8010064c:	85 c0                	test   %eax,%eax
8010064e:	74 bf                	je     8010060f <cprintf+0x2e>
    if(c != '%'){
80100650:	83 f8 25             	cmp    $0x25,%eax
80100653:	75 eb                	jne    80100640 <cprintf+0x5f>
    c = fmt[++i] & 0xff;
80100655:	83 c3 01             	add    $0x1,%ebx
80100658:	0f b6 34 1f          	movzbl (%edi,%ebx,1),%esi
    if(c == 0)
8010065c:	85 f6                	test   %esi,%esi
8010065e:	74 af                	je     8010060f <cprintf+0x2e>
    switch(c){
80100660:	83 fe 70             	cmp    $0x70,%esi
80100663:	74 4c                	je     801006b1 <cprintf+0xd0>
80100665:	83 fe 70             	cmp    $0x70,%esi
80100668:	7f 2a                	jg     80100694 <cprintf+0xb3>
8010066a:	83 fe 25             	cmp    $0x25,%esi
8010066d:	0f 84 a4 00 00 00    	je     80100717 <cprintf+0x136>
80100673:	83 fe 64             	cmp    $0x64,%esi
80100676:	75 26                	jne    8010069e <cprintf+0xbd>
      printint(*argp++, 10, 1);
80100678:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010067b:	8d 70 04             	lea    0x4(%eax),%esi
8010067e:	b9 01 00 00 00       	mov    $0x1,%ecx
80100683:	ba 0a 00 00 00       	mov    $0xa,%edx
80100688:	8b 00                	mov    (%eax),%eax
8010068a:	e8 7d fe ff ff       	call   8010050c <printint>
8010068f:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      break;
80100692:	eb b1                	jmp    80100645 <cprintf+0x64>
    switch(c){
80100694:	83 fe 73             	cmp    $0x73,%esi
80100697:	74 37                	je     801006d0 <cprintf+0xef>
80100699:	83 fe 78             	cmp    $0x78,%esi
8010069c:	74 13                	je     801006b1 <cprintf+0xd0>
      consputc('%');
8010069e:	b8 25 00 00 00       	mov    $0x25,%eax
801006a3:	e8 14 fd ff ff       	call   801003bc <consputc>
      consputc(c);
801006a8:	89 f0                	mov    %esi,%eax
801006aa:	e8 0d fd ff ff       	call   801003bc <consputc>
      break;
801006af:	eb 94                	jmp    80100645 <cprintf+0x64>
      printint(*argp++, 16, 0);
801006b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006b4:	8d 70 04             	lea    0x4(%eax),%esi
801006b7:	b9 00 00 00 00       	mov    $0x0,%ecx
801006bc:	ba 10 00 00 00       	mov    $0x10,%edx
801006c1:	8b 00                	mov    (%eax),%eax
801006c3:	e8 44 fe ff ff       	call   8010050c <printint>
801006c8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
      break;
801006cb:	e9 75 ff ff ff       	jmp    80100645 <cprintf+0x64>
      if((s = (char*)*argp++) == 0)
801006d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006d3:	8d 50 04             	lea    0x4(%eax),%edx
801006d6:	89 55 dc             	mov    %edx,-0x24(%ebp)
801006d9:	8b 00                	mov    (%eax),%eax
801006db:	85 c0                	test   %eax,%eax
801006dd:	74 11                	je     801006f0 <cprintf+0x10f>
801006df:	89 c6                	mov    %eax,%esi
      for(; *s; s++)
801006e1:	0f b6 00             	movzbl (%eax),%eax
      if((s = (char*)*argp++) == 0)
801006e4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      for(; *s; s++)
801006e7:	84 c0                	test   %al,%al
801006e9:	75 0f                	jne    801006fa <cprintf+0x119>
801006eb:	e9 55 ff ff ff       	jmp    80100645 <cprintf+0x64>
        s = "(null)";
801006f0:	be f8 65 10 80       	mov    $0x801065f8,%esi
      for(; *s; s++)
801006f5:	b8 28 00 00 00       	mov    $0x28,%eax
        consputc(*s);
801006fa:	0f be c0             	movsbl %al,%eax
801006fd:	e8 ba fc ff ff       	call   801003bc <consputc>
      for(; *s; s++)
80100702:	83 c6 01             	add    $0x1,%esi
80100705:	0f b6 06             	movzbl (%esi),%eax
80100708:	84 c0                	test   %al,%al
8010070a:	75 ee                	jne    801006fa <cprintf+0x119>
      if((s = (char*)*argp++) == 0)
8010070c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	e9 2e ff ff ff       	jmp    80100645 <cprintf+0x64>
      consputc('%');
80100717:	b8 25 00 00 00       	mov    $0x25,%eax
8010071c:	e8 9b fc ff ff       	call   801003bc <consputc>
      break;
80100721:	e9 1f ff ff ff       	jmp    80100645 <cprintf+0x64>
    release(&cons.lock);
80100726:	83 ec 0c             	sub    $0xc,%esp
80100729:	68 20 95 10 80       	push   $0x80109520
8010072e:	e8 e6 36 00 00       	call   80103e19 <release>
80100733:	83 c4 10             	add    $0x10,%esp
}
80100736:	e9 de fe ff ff       	jmp    80100619 <cprintf+0x38>

8010073b <consoleintr>:
{
8010073b:	55                   	push   %ebp
8010073c:	89 e5                	mov    %esp,%ebp
8010073e:	57                   	push   %edi
8010073f:	56                   	push   %esi
80100740:	53                   	push   %ebx
80100741:	83 ec 28             	sub    $0x28,%esp
80100744:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100747:	68 20 95 10 80       	push   $0x80109520
8010074c:	e8 61 36 00 00       	call   80103db2 <acquire>
  while((c = getc()) >= 0){
80100751:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100754:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010075b:	bb 80 0f 11 80       	mov    $0x80110f80,%ebx
  while((c = getc()) >= 0){
80100760:	e9 c2 00 00 00       	jmp    80100827 <consoleintr+0xec>
    switch(c){
80100765:	83 fe 08             	cmp    $0x8,%esi
80100768:	0f 84 dd 00 00 00    	je     8010084b <consoleintr+0x110>
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010076e:	85 f6                	test   %esi,%esi
80100770:	0f 84 b1 00 00 00    	je     80100827 <consoleintr+0xec>
80100776:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
8010077c:	89 c2                	mov    %eax,%edx
8010077e:	2b 93 80 00 00 00    	sub    0x80(%ebx),%edx
80100784:	83 fa 7f             	cmp    $0x7f,%edx
80100787:	0f 87 9a 00 00 00    	ja     80100827 <consoleintr+0xec>
        c = (c == '\r') ? '\n' : c;
8010078d:	83 fe 0d             	cmp    $0xd,%esi
80100790:	0f 84 fd 00 00 00    	je     80100893 <consoleintr+0x158>
        input.buf[input.e++ % INPUT_BUF] = c;
80100796:	8d 50 01             	lea    0x1(%eax),%edx
80100799:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
8010079f:	83 e0 7f             	and    $0x7f,%eax
801007a2:	89 f1                	mov    %esi,%ecx
801007a4:	88 0c 03             	mov    %cl,(%ebx,%eax,1)
        consputc(c);
801007a7:	89 f0                	mov    %esi,%eax
801007a9:	e8 0e fc ff ff       	call   801003bc <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007ae:	83 fe 0a             	cmp    $0xa,%esi
801007b1:	0f 84 f6 00 00 00    	je     801008ad <consoleintr+0x172>
801007b7:	83 fe 04             	cmp    $0x4,%esi
801007ba:	0f 84 ed 00 00 00    	je     801008ad <consoleintr+0x172>
801007c0:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801007c6:	83 e8 80             	sub    $0xffffff80,%eax
801007c9:	39 83 88 00 00 00    	cmp    %eax,0x88(%ebx)
801007cf:	75 56                	jne    80100827 <consoleintr+0xec>
801007d1:	e9 d7 00 00 00       	jmp    801008ad <consoleintr+0x172>
      while(input.e != input.w &&
801007d6:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801007dc:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
801007e2:	74 43                	je     80100827 <consoleintr+0xec>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801007e4:	83 e8 01             	sub    $0x1,%eax
801007e7:	89 c2                	mov    %eax,%edx
801007e9:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801007ec:	80 3c 13 0a          	cmpb   $0xa,(%ebx,%edx,1)
801007f0:	74 35                	je     80100827 <consoleintr+0xec>
        input.e--;
801007f2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
        consputc(BACKSPACE);
801007f8:	b8 00 01 00 00       	mov    $0x100,%eax
801007fd:	e8 ba fb ff ff       	call   801003bc <consputc>
      while(input.e != input.w &&
80100802:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80100808:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
8010080e:	74 17                	je     80100827 <consoleintr+0xec>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100810:	83 e8 01             	sub    $0x1,%eax
80100813:	89 c2                	mov    %eax,%edx
80100815:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100818:	80 3c 13 0a          	cmpb   $0xa,(%ebx,%edx,1)
8010081c:	75 d4                	jne    801007f2 <consoleintr+0xb7>
8010081e:	eb 07                	jmp    80100827 <consoleintr+0xec>
      doprocdump = 1;
80100820:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  while((c = getc()) >= 0){
80100827:	ff d7                	call   *%edi
80100829:	89 c6                	mov    %eax,%esi
8010082b:	85 c0                	test   %eax,%eax
8010082d:	78 3f                	js     8010086e <consoleintr+0x133>
    switch(c){
8010082f:	83 fe 10             	cmp    $0x10,%esi
80100832:	74 ec                	je     80100820 <consoleintr+0xe5>
80100834:	83 fe 10             	cmp    $0x10,%esi
80100837:	0f 8e 28 ff ff ff    	jle    80100765 <consoleintr+0x2a>
8010083d:	83 fe 15             	cmp    $0x15,%esi
80100840:	74 94                	je     801007d6 <consoleintr+0x9b>
80100842:	83 fe 7f             	cmp    $0x7f,%esi
80100845:	0f 85 23 ff ff ff    	jne    8010076e <consoleintr+0x33>
      if(input.e != input.w){
8010084b:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80100851:	3b 83 84 00 00 00    	cmp    0x84(%ebx),%eax
80100857:	74 ce                	je     80100827 <consoleintr+0xec>
        input.e--;
80100859:	83 e8 01             	sub    $0x1,%eax
8010085c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
        consputc(BACKSPACE);
80100862:	b8 00 01 00 00       	mov    $0x100,%eax
80100867:	e8 50 fb ff ff       	call   801003bc <consputc>
8010086c:	eb b9                	jmp    80100827 <consoleintr+0xec>
  release(&cons.lock);
8010086e:	83 ec 0c             	sub    $0xc,%esp
80100871:	68 20 95 10 80       	push   $0x80109520
80100876:	e8 9e 35 00 00       	call   80103e19 <release>
  if(doprocdump) {
8010087b:	83 c4 10             	add    $0x10,%esp
8010087e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100882:	75 08                	jne    8010088c <consoleintr+0x151>
}
80100884:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100887:	5b                   	pop    %ebx
80100888:	5e                   	pop    %esi
80100889:	5f                   	pop    %edi
8010088a:	5d                   	pop    %ebp
8010088b:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
8010088c:	e8 f3 31 00 00       	call   80103a84 <procdump>
}
80100891:	eb f1                	jmp    80100884 <consoleintr+0x149>
        input.buf[input.e++ % INPUT_BUF] = c;
80100893:	8d 50 01             	lea    0x1(%eax),%edx
80100896:	89 93 88 00 00 00    	mov    %edx,0x88(%ebx)
8010089c:	83 e0 7f             	and    $0x7f,%eax
8010089f:	c6 04 03 0a          	movb   $0xa,(%ebx,%eax,1)
        consputc(c);
801008a3:	b8 0a 00 00 00       	mov    $0xa,%eax
801008a8:	e8 0f fb ff ff       	call   801003bc <consputc>
          input.w = input.e;
801008ad:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
801008b3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
          wakeup(&input.r);
801008b9:	83 ec 0c             	sub    $0xc,%esp
801008bc:	68 00 10 11 80       	push   $0x80111000
801008c1:	e8 d6 30 00 00       	call   8010399c <wakeup>
801008c6:	83 c4 10             	add    $0x10,%esp
801008c9:	e9 59 ff ff ff       	jmp    80100827 <consoleintr+0xec>

801008ce <consoleinit>:

void
consoleinit(void)
{
801008ce:	55                   	push   %ebp
801008cf:	89 e5                	mov    %esp,%ebp
801008d1:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801008d4:	68 08 66 10 80       	push   $0x80106608
801008d9:	68 20 95 10 80       	push   $0x80109520
801008de:	e8 87 33 00 00       	call   80103c6a <initlock>

  devsw[CONSOLE].write = consolewrite;
801008e3:	c7 05 cc 19 11 80 82 	movl   $0x80100582,0x801119cc
801008ea:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801008ed:	c7 05 c8 19 11 80 54 	movl   $0x80100254,0x801119c8
801008f4:	02 10 80 
  cons.locking = 1;
801008f7:	c7 05 54 95 10 80 01 	movl   $0x1,0x80109554
801008fe:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100901:	83 c4 08             	add    $0x8,%esp
80100904:	6a 00                	push   $0x0
80100906:	6a 01                	push   $0x1
80100908:	e8 fb 16 00 00       	call   80102008 <ioapicenable>
}
8010090d:	83 c4 10             	add    $0x10,%esp
80100910:	c9                   	leave  
80100911:	c3                   	ret    

80100912 <exec>:
#include "elf.h"


int
exec(char *path, char **argv)
{
80100912:	55                   	push   %ebp
80100913:	89 e5                	mov    %esp,%ebp
80100915:	57                   	push   %edi
80100916:	56                   	push   %esi
80100917:	53                   	push   %ebx
80100918:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010091e:	e8 18 2a 00 00       	call   8010333b <myproc>
80100923:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100929:	e8 81 1e 00 00       	call   801027af <begin_op>

  if((ip = namei(path)) == 0){
8010092e:	83 ec 0c             	sub    $0xc,%esp
80100931:	ff 75 08             	pushl  0x8(%ebp)
80100934:	e8 4c 13 00 00       	call   80101c85 <namei>
80100939:	83 c4 10             	add    $0x10,%esp
8010093c:	85 c0                	test   %eax,%eax
8010093e:	74 42                	je     80100982 <exec+0x70>
80100940:	89 c3                	mov    %eax,%ebx
#ifndef PDX_XV6
    cprintf("exec: fail\n");
#endif
    return -1;
  }
  ilock(ip);
80100942:	83 ec 0c             	sub    $0xc,%esp
80100945:	50                   	push   %eax
80100946:	e8 9d 0b 00 00       	call   801014e8 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
8010094b:	6a 34                	push   $0x34
8010094d:	6a 00                	push   $0x0
8010094f:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100955:	50                   	push   %eax
80100956:	53                   	push   %ebx
80100957:	e8 20 0e 00 00       	call   8010177c <readi>
8010095c:	83 c4 20             	add    $0x20,%esp
8010095f:	83 f8 34             	cmp    $0x34,%eax
80100962:	74 2a                	je     8010098e <exec+0x7c>

bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100964:	83 ec 0c             	sub    $0xc,%esp
80100967:	53                   	push   %ebx
80100968:	e8 c4 0d 00 00       	call   80101731 <iunlockput>
    end_op();
8010096d:	e8 b8 1e 00 00       	call   8010282a <end_op>
80100972:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100975:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010097a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010097d:	5b                   	pop    %ebx
8010097e:	5e                   	pop    %esi
8010097f:	5f                   	pop    %edi
80100980:	5d                   	pop    %ebp
80100981:	c3                   	ret    
    end_op();
80100982:	e8 a3 1e 00 00       	call   8010282a <end_op>
    return -1;
80100987:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010098c:	eb ec                	jmp    8010097a <exec+0x68>
  if(elf.magic != ELF_MAGIC)
8010098e:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100995:	45 4c 46 
80100998:	75 ca                	jne    80100964 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
8010099a:	e8 bf 59 00 00       	call   8010635e <setupkvm>
8010099f:	89 c7                	mov    %eax,%edi
801009a1:	85 c0                	test   %eax,%eax
801009a3:	74 bf                	je     80100964 <exec+0x52>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009a5:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
801009ab:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009b1:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
801009b8:	00 
801009b9:	0f 84 bf 00 00 00    	je     80100a7e <exec+0x16c>
  sz = 0;
801009bf:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
801009c6:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009c9:	be 00 00 00 00       	mov    $0x0,%esi
801009ce:	eb 12                	jmp    801009e2 <exec+0xd0>
801009d0:	83 c6 01             	add    $0x1,%esi
801009d3:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801009da:	39 f0                	cmp    %esi,%eax
801009dc:	0f 8e a6 00 00 00    	jle    80100a88 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009e2:	6a 20                	push   $0x20
801009e4:	89 f0                	mov    %esi,%eax
801009e6:	c1 e0 05             	shl    $0x5,%eax
801009e9:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
801009ef:	50                   	push   %eax
801009f0:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009f6:	50                   	push   %eax
801009f7:	53                   	push   %ebx
801009f8:	e8 7f 0d 00 00       	call   8010177c <readi>
801009fd:	83 c4 10             	add    $0x10,%esp
80100a00:	83 f8 20             	cmp    $0x20,%eax
80100a03:	0f 85 c2 00 00 00    	jne    80100acb <exec+0x1b9>
    if(ph.type != ELF_PROG_LOAD)
80100a09:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a10:	75 be                	jne    801009d0 <exec+0xbe>
    if(ph.memsz < ph.filesz)
80100a12:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a18:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a1e:	0f 82 a7 00 00 00    	jb     80100acb <exec+0x1b9>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a24:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a2a:	0f 82 9b 00 00 00    	jb     80100acb <exec+0x1b9>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a30:	83 ec 04             	sub    $0x4,%esp
80100a33:	50                   	push   %eax
80100a34:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100a3a:	57                   	push   %edi
80100a3b:	e8 bd 57 00 00       	call   801061fd <allocuvm>
80100a40:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100a46:	83 c4 10             	add    $0x10,%esp
80100a49:	85 c0                	test   %eax,%eax
80100a4b:	74 7e                	je     80100acb <exec+0x1b9>
    if(ph.vaddr % PGSIZE != 0)
80100a4d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a53:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a58:	75 71                	jne    80100acb <exec+0x1b9>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a5a:	83 ec 0c             	sub    $0xc,%esp
80100a5d:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a63:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a69:	53                   	push   %ebx
80100a6a:	50                   	push   %eax
80100a6b:	57                   	push   %edi
80100a6c:	e8 4f 56 00 00       	call   801060c0 <loaduvm>
80100a71:	83 c4 20             	add    $0x20,%esp
80100a74:	85 c0                	test   %eax,%eax
80100a76:	0f 89 54 ff ff ff    	jns    801009d0 <exec+0xbe>
bad:
80100a7c:	eb 4d                	jmp    80100acb <exec+0x1b9>
  sz = 0;
80100a7e:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a85:	00 00 00 
  iunlockput(ip);
80100a88:	83 ec 0c             	sub    $0xc,%esp
80100a8b:	53                   	push   %ebx
80100a8c:	e8 a0 0c 00 00       	call   80101731 <iunlockput>
  end_op();
80100a91:	e8 94 1d 00 00       	call   8010282a <end_op>
  sz = PGROUNDUP(sz);
80100a96:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100a9c:	05 ff 0f 00 00       	add    $0xfff,%eax
80100aa1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100aa6:	89 c2                	mov    %eax,%edx
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100aa8:	83 c4 0c             	add    $0xc,%esp
80100aab:	8d 80 00 20 00 00    	lea    0x2000(%eax),%eax
80100ab1:	50                   	push   %eax
80100ab2:	52                   	push   %edx
80100ab3:	57                   	push   %edi
80100ab4:	e8 44 57 00 00       	call   801061fd <allocuvm>
80100ab9:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100abf:	83 c4 10             	add    $0x10,%esp
  ip = 0;
80100ac2:	bb 00 00 00 00       	mov    $0x0,%ebx
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ac7:	85 c0                	test   %eax,%eax
80100ac9:	75 1e                	jne    80100ae9 <exec+0x1d7>
    freevm(pgdir);
80100acb:	83 ec 0c             	sub    $0xc,%esp
80100ace:	57                   	push   %edi
80100acf:	e8 17 58 00 00       	call   801062eb <freevm>
  if(ip){
80100ad4:	83 c4 10             	add    $0x10,%esp
80100ad7:	85 db                	test   %ebx,%ebx
80100ad9:	0f 85 85 fe ff ff    	jne    80100964 <exec+0x52>
  return -1;
80100adf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ae4:	e9 91 fe ff ff       	jmp    8010097a <exec+0x68>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ae9:	83 ec 08             	sub    $0x8,%esp
80100aec:	89 c3                	mov    %eax,%ebx
80100aee:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100af4:	50                   	push   %eax
80100af5:	57                   	push   %edi
80100af6:	e8 e8 58 00 00       	call   801063e3 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100afb:	8b 45 0c             	mov    0xc(%ebp),%eax
80100afe:	8b 00                	mov    (%eax),%eax
80100b00:	83 c4 10             	add    $0x10,%esp
80100b03:	be 00 00 00 00       	mov    $0x0,%esi
80100b08:	85 c0                	test   %eax,%eax
80100b0a:	74 5f                	je     80100b6b <exec+0x259>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b0c:	83 ec 0c             	sub    $0xc,%esp
80100b0f:	50                   	push   %eax
80100b10:	e8 0e 35 00 00       	call   80104023 <strlen>
80100b15:	f7 d0                	not    %eax
80100b17:	01 d8                	add    %ebx,%eax
80100b19:	83 e0 fc             	and    $0xfffffffc,%eax
80100b1c:	89 c3                	mov    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b1e:	83 c4 04             	add    $0x4,%esp
80100b21:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b24:	ff 34 b0             	pushl  (%eax,%esi,4)
80100b27:	e8 f7 34 00 00       	call   80104023 <strlen>
80100b2c:	83 c0 01             	add    $0x1,%eax
80100b2f:	50                   	push   %eax
80100b30:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b33:	ff 34 b0             	pushl  (%eax,%esi,4)
80100b36:	53                   	push   %ebx
80100b37:	57                   	push   %edi
80100b38:	e8 e5 59 00 00       	call   80106522 <copyout>
80100b3d:	83 c4 20             	add    $0x20,%esp
80100b40:	85 c0                	test   %eax,%eax
80100b42:	0f 88 f4 00 00 00    	js     80100c3c <exec+0x32a>
    ustack[3+argc] = sp;
80100b48:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b4f:	83 c6 01             	add    $0x1,%esi
80100b52:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b55:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100b58:	85 c0                	test   %eax,%eax
80100b5a:	74 15                	je     80100b71 <exec+0x25f>
    if(argc >= MAXARG)
80100b5c:	83 fe 20             	cmp    $0x20,%esi
80100b5f:	75 ab                	jne    80100b0c <exec+0x1fa>
  ip = 0;
80100b61:	bb 00 00 00 00       	mov    $0x0,%ebx
80100b66:	e9 60 ff ff ff       	jmp    80100acb <exec+0x1b9>
  sp = sz;
80100b6b:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
  ustack[3+argc] = 0;
80100b71:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100b78:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b7c:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b83:	ff ff ff 
  ustack[1] = argc;
80100b86:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b8c:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100b93:	89 da                	mov    %ebx,%edx
80100b95:	29 c2                	sub    %eax,%edx
80100b97:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b9d:	83 c0 0c             	add    $0xc,%eax
80100ba0:	89 de                	mov    %ebx,%esi
80100ba2:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ba4:	50                   	push   %eax
80100ba5:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100bab:	50                   	push   %eax
80100bac:	56                   	push   %esi
80100bad:	57                   	push   %edi
80100bae:	e8 6f 59 00 00       	call   80106522 <copyout>
80100bb3:	83 c4 10             	add    $0x10,%esp
80100bb6:	85 c0                	test   %eax,%eax
80100bb8:	0f 88 88 00 00 00    	js     80100c46 <exec+0x334>
  for(last=s=path; *s; s++)
80100bbe:	8b 45 08             	mov    0x8(%ebp),%eax
80100bc1:	0f b6 10             	movzbl (%eax),%edx
80100bc4:	84 d2                	test   %dl,%dl
80100bc6:	74 1a                	je     80100be2 <exec+0x2d0>
80100bc8:	83 c0 01             	add    $0x1,%eax
80100bcb:	8b 4d 08             	mov    0x8(%ebp),%ecx
      last = s+1;
80100bce:	80 fa 2f             	cmp    $0x2f,%dl
80100bd1:	0f 44 c8             	cmove  %eax,%ecx
80100bd4:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100bd7:	0f b6 50 ff          	movzbl -0x1(%eax),%edx
80100bdb:	84 d2                	test   %dl,%dl
80100bdd:	75 ef                	jne    80100bce <exec+0x2bc>
80100bdf:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100be2:	83 ec 04             	sub    $0x4,%esp
80100be5:	6a 10                	push   $0x10
80100be7:	ff 75 08             	pushl  0x8(%ebp)
80100bea:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100bf0:	89 d8                	mov    %ebx,%eax
80100bf2:	83 c0 6c             	add    $0x6c,%eax
80100bf5:	50                   	push   %eax
80100bf6:	e8 f4 33 00 00       	call   80103fef <safestrcpy>
  oldpgdir = curproc->pgdir;
80100bfb:	89 d8                	mov    %ebx,%eax
80100bfd:	8b 5b 04             	mov    0x4(%ebx),%ebx
  curproc->pgdir = pgdir;
80100c00:	89 78 04             	mov    %edi,0x4(%eax)
  curproc->sz = sz;
80100c03:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c09:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100c0b:	89 c7                	mov    %eax,%edi
80100c0d:	8b 40 18             	mov    0x18(%eax),%eax
80100c10:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100c16:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100c19:	8b 47 18             	mov    0x18(%edi),%eax
80100c1c:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100c1f:	89 3c 24             	mov    %edi,(%esp)
80100c22:	e8 32 53 00 00       	call   80105f59 <switchuvm>
  freevm(oldpgdir);
80100c27:	89 1c 24             	mov    %ebx,(%esp)
80100c2a:	e8 bc 56 00 00       	call   801062eb <freevm>
  return 0;
80100c2f:	83 c4 10             	add    $0x10,%esp
80100c32:	b8 00 00 00 00       	mov    $0x0,%eax
80100c37:	e9 3e fd ff ff       	jmp    8010097a <exec+0x68>
  ip = 0;
80100c3c:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c41:	e9 85 fe ff ff       	jmp    80100acb <exec+0x1b9>
80100c46:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c4b:	e9 7b fe ff ff       	jmp    80100acb <exec+0x1b9>

80100c50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c50:	55                   	push   %ebp
80100c51:	89 e5                	mov    %esp,%ebp
80100c53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c56:	68 21 66 10 80       	push   $0x80106621
80100c5b:	68 20 10 11 80       	push   $0x80111020
80100c60:	e8 05 30 00 00       	call   80103c6a <initlock>
}
80100c65:	83 c4 10             	add    $0x10,%esp
80100c68:	c9                   	leave  
80100c69:	c3                   	ret    

80100c6a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c6a:	55                   	push   %ebp
80100c6b:	89 e5                	mov    %esp,%ebp
80100c6d:	53                   	push   %ebx
80100c6e:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c71:	68 20 10 11 80       	push   $0x80111020
80100c76:	e8 37 31 00 00       	call   80103db2 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
80100c7b:	83 c4 10             	add    $0x10,%esp
80100c7e:	83 3d 58 10 11 80 00 	cmpl   $0x0,0x80111058
80100c85:	74 2d                	je     80100cb4 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c87:	bb 6c 10 11 80       	mov    $0x8011106c,%ebx
    if(f->ref == 0){
80100c8c:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c90:	74 27                	je     80100cb9 <filealloc+0x4f>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c92:	83 c3 18             	add    $0x18,%ebx
80100c95:	81 fb b4 19 11 80    	cmp    $0x801119b4,%ebx
80100c9b:	72 ef                	jb     80100c8c <filealloc+0x22>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100c9d:	83 ec 0c             	sub    $0xc,%esp
80100ca0:	68 20 10 11 80       	push   $0x80111020
80100ca5:	e8 6f 31 00 00       	call   80103e19 <release>
  return 0;
80100caa:	83 c4 10             	add    $0x10,%esp
80100cad:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cb2:	eb 1c                	jmp    80100cd0 <filealloc+0x66>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100cb4:	bb 54 10 11 80       	mov    $0x80111054,%ebx
      f->ref = 1;
80100cb9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100cc0:	83 ec 0c             	sub    $0xc,%esp
80100cc3:	68 20 10 11 80       	push   $0x80111020
80100cc8:	e8 4c 31 00 00       	call   80103e19 <release>
      return f;
80100ccd:	83 c4 10             	add    $0x10,%esp
}
80100cd0:	89 d8                	mov    %ebx,%eax
80100cd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cd5:	c9                   	leave  
80100cd6:	c3                   	ret    

80100cd7 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100cd7:	55                   	push   %ebp
80100cd8:	89 e5                	mov    %esp,%ebp
80100cda:	53                   	push   %ebx
80100cdb:	83 ec 10             	sub    $0x10,%esp
80100cde:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ce1:	68 20 10 11 80       	push   $0x80111020
80100ce6:	e8 c7 30 00 00       	call   80103db2 <acquire>
  if(f->ref < 1)
80100ceb:	8b 43 04             	mov    0x4(%ebx),%eax
80100cee:	83 c4 10             	add    $0x10,%esp
80100cf1:	85 c0                	test   %eax,%eax
80100cf3:	7e 1a                	jle    80100d0f <filedup+0x38>
    panic("filedup");
  f->ref++;
80100cf5:	83 c0 01             	add    $0x1,%eax
80100cf8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100cfb:	83 ec 0c             	sub    $0xc,%esp
80100cfe:	68 20 10 11 80       	push   $0x80111020
80100d03:	e8 11 31 00 00       	call   80103e19 <release>
  return f;
}
80100d08:	89 d8                	mov    %ebx,%eax
80100d0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d0d:	c9                   	leave  
80100d0e:	c3                   	ret    
    panic("filedup");
80100d0f:	83 ec 0c             	sub    $0xc,%esp
80100d12:	68 28 66 10 80       	push   $0x80106628
80100d17:	e8 28 f6 ff ff       	call   80100344 <panic>

80100d1c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d1c:	55                   	push   %ebp
80100d1d:	89 e5                	mov    %esp,%ebp
80100d1f:	57                   	push   %edi
80100d20:	56                   	push   %esi
80100d21:	53                   	push   %ebx
80100d22:	83 ec 28             	sub    $0x28,%esp
80100d25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d28:	68 20 10 11 80       	push   $0x80111020
80100d2d:	e8 80 30 00 00       	call   80103db2 <acquire>
  if(f->ref < 1)
80100d32:	8b 43 04             	mov    0x4(%ebx),%eax
80100d35:	83 c4 10             	add    $0x10,%esp
80100d38:	85 c0                	test   %eax,%eax
80100d3a:	7e 22                	jle    80100d5e <fileclose+0x42>
    panic("fileclose");
  if(--f->ref > 0){
80100d3c:	83 e8 01             	sub    $0x1,%eax
80100d3f:	89 43 04             	mov    %eax,0x4(%ebx)
80100d42:	85 c0                	test   %eax,%eax
80100d44:	7e 25                	jle    80100d6b <fileclose+0x4f>
    release(&ftable.lock);
80100d46:	83 ec 0c             	sub    $0xc,%esp
80100d49:	68 20 10 11 80       	push   $0x80111020
80100d4e:	e8 c6 30 00 00       	call   80103e19 <release>
80100d53:	83 c4 10             	add    $0x10,%esp
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100d56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d59:	5b                   	pop    %ebx
80100d5a:	5e                   	pop    %esi
80100d5b:	5f                   	pop    %edi
80100d5c:	5d                   	pop    %ebp
80100d5d:	c3                   	ret    
    panic("fileclose");
80100d5e:	83 ec 0c             	sub    $0xc,%esp
80100d61:	68 30 66 10 80       	push   $0x80106630
80100d66:	e8 d9 f5 ff ff       	call   80100344 <panic>
  ff = *f;
80100d6b:	8b 33                	mov    (%ebx),%esi
80100d6d:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100d71:	88 45 e7             	mov    %al,-0x19(%ebp)
80100d74:	8b 7b 0c             	mov    0xc(%ebx),%edi
80100d77:	8b 43 10             	mov    0x10(%ebx),%eax
80100d7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
80100d7d:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d84:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d8a:	83 ec 0c             	sub    $0xc,%esp
80100d8d:	68 20 10 11 80       	push   $0x80111020
80100d92:	e8 82 30 00 00       	call   80103e19 <release>
  if(ff.type == FD_PIPE)
80100d97:	83 c4 10             	add    $0x10,%esp
80100d9a:	83 fe 01             	cmp    $0x1,%esi
80100d9d:	74 1f                	je     80100dbe <fileclose+0xa2>
  else if(ff.type == FD_INODE){
80100d9f:	83 fe 02             	cmp    $0x2,%esi
80100da2:	75 b2                	jne    80100d56 <fileclose+0x3a>
    begin_op();
80100da4:	e8 06 1a 00 00       	call   801027af <begin_op>
    iput(ff.ip);
80100da9:	83 ec 0c             	sub    $0xc,%esp
80100dac:	ff 75 e0             	pushl  -0x20(%ebp)
80100daf:	e8 3b 08 00 00       	call   801015ef <iput>
    end_op();
80100db4:	e8 71 1a 00 00       	call   8010282a <end_op>
80100db9:	83 c4 10             	add    $0x10,%esp
80100dbc:	eb 98                	jmp    80100d56 <fileclose+0x3a>
    pipeclose(ff.pipe, ff.writable);
80100dbe:	83 ec 08             	sub    $0x8,%esp
80100dc1:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100dc5:	50                   	push   %eax
80100dc6:	57                   	push   %edi
80100dc7:	e8 10 21 00 00       	call   80102edc <pipeclose>
80100dcc:	83 c4 10             	add    $0x10,%esp
80100dcf:	eb 85                	jmp    80100d56 <fileclose+0x3a>

80100dd1 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100dd1:	55                   	push   %ebp
80100dd2:	89 e5                	mov    %esp,%ebp
80100dd4:	53                   	push   %ebx
80100dd5:	83 ec 04             	sub    $0x4,%esp
80100dd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ddb:	83 3b 02             	cmpl   $0x2,(%ebx)
80100dde:	75 31                	jne    80100e11 <filestat+0x40>
    ilock(f->ip);
80100de0:	83 ec 0c             	sub    $0xc,%esp
80100de3:	ff 73 10             	pushl  0x10(%ebx)
80100de6:	e8 fd 06 00 00       	call   801014e8 <ilock>
    stati(f->ip, st);
80100deb:	83 c4 08             	add    $0x8,%esp
80100dee:	ff 75 0c             	pushl  0xc(%ebp)
80100df1:	ff 73 10             	pushl  0x10(%ebx)
80100df4:	e8 58 09 00 00       	call   80101751 <stati>
    iunlock(f->ip);
80100df9:	83 c4 04             	add    $0x4,%esp
80100dfc:	ff 73 10             	pushl  0x10(%ebx)
80100dff:	e8 a6 07 00 00       	call   801015aa <iunlock>
    return 0;
80100e04:	83 c4 10             	add    $0x10,%esp
80100e07:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100e0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e0f:	c9                   	leave  
80100e10:	c3                   	ret    
  return -1;
80100e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e16:	eb f4                	jmp    80100e0c <filestat+0x3b>

80100e18 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e18:	55                   	push   %ebp
80100e19:	89 e5                	mov    %esp,%ebp
80100e1b:	56                   	push   %esi
80100e1c:	53                   	push   %ebx
80100e1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e20:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e24:	74 70                	je     80100e96 <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100e26:	8b 03                	mov    (%ebx),%eax
80100e28:	83 f8 01             	cmp    $0x1,%eax
80100e2b:	74 44                	je     80100e71 <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e2d:	83 f8 02             	cmp    $0x2,%eax
80100e30:	75 57                	jne    80100e89 <fileread+0x71>
    ilock(f->ip);
80100e32:	83 ec 0c             	sub    $0xc,%esp
80100e35:	ff 73 10             	pushl  0x10(%ebx)
80100e38:	e8 ab 06 00 00       	call   801014e8 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e3d:	ff 75 10             	pushl  0x10(%ebp)
80100e40:	ff 73 14             	pushl  0x14(%ebx)
80100e43:	ff 75 0c             	pushl  0xc(%ebp)
80100e46:	ff 73 10             	pushl  0x10(%ebx)
80100e49:	e8 2e 09 00 00       	call   8010177c <readi>
80100e4e:	89 c6                	mov    %eax,%esi
80100e50:	83 c4 20             	add    $0x20,%esp
80100e53:	85 c0                	test   %eax,%eax
80100e55:	7e 03                	jle    80100e5a <fileread+0x42>
      f->off += r;
80100e57:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e5a:	83 ec 0c             	sub    $0xc,%esp
80100e5d:	ff 73 10             	pushl  0x10(%ebx)
80100e60:	e8 45 07 00 00       	call   801015aa <iunlock>
    return r;
80100e65:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e68:	89 f0                	mov    %esi,%eax
80100e6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e6d:	5b                   	pop    %ebx
80100e6e:	5e                   	pop    %esi
80100e6f:	5d                   	pop    %ebp
80100e70:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e71:	83 ec 04             	sub    $0x4,%esp
80100e74:	ff 75 10             	pushl  0x10(%ebp)
80100e77:	ff 75 0c             	pushl  0xc(%ebp)
80100e7a:	ff 73 0c             	pushl  0xc(%ebx)
80100e7d:	e8 df 21 00 00       	call   80103061 <piperead>
80100e82:	89 c6                	mov    %eax,%esi
80100e84:	83 c4 10             	add    $0x10,%esp
80100e87:	eb df                	jmp    80100e68 <fileread+0x50>
  panic("fileread");
80100e89:	83 ec 0c             	sub    $0xc,%esp
80100e8c:	68 3a 66 10 80       	push   $0x8010663a
80100e91:	e8 ae f4 ff ff       	call   80100344 <panic>
    return -1;
80100e96:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e9b:	eb cb                	jmp    80100e68 <fileread+0x50>

80100e9d <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e9d:	55                   	push   %ebp
80100e9e:	89 e5                	mov    %esp,%ebp
80100ea0:	57                   	push   %edi
80100ea1:	56                   	push   %esi
80100ea2:	53                   	push   %ebx
80100ea3:	83 ec 1c             	sub    $0x1c,%esp
80100ea6:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100ea9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100ead:	0f 84 e8 00 00 00    	je     80100f9b <filewrite+0xfe>
    return -1;
  if(f->type == FD_PIPE)
80100eb3:	8b 06                	mov    (%esi),%eax
80100eb5:	83 f8 01             	cmp    $0x1,%eax
80100eb8:	74 1a                	je     80100ed4 <filewrite+0x37>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100eba:	83 f8 02             	cmp    $0x2,%eax
80100ebd:	0f 85 cb 00 00 00    	jne    80100f8e <filewrite+0xf1>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100ec3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100ec7:	0f 8e 9e 00 00 00    	jle    80100f6b <filewrite+0xce>
    int i = 0;
80100ecd:	bf 00 00 00 00       	mov    $0x0,%edi
80100ed2:	eb 3f                	jmp    80100f13 <filewrite+0x76>
    return pipewrite(f->pipe, addr, n);
80100ed4:	83 ec 04             	sub    $0x4,%esp
80100ed7:	ff 75 10             	pushl  0x10(%ebp)
80100eda:	ff 75 0c             	pushl  0xc(%ebp)
80100edd:	ff 76 0c             	pushl  0xc(%esi)
80100ee0:	e8 83 20 00 00       	call   80102f68 <pipewrite>
80100ee5:	89 45 10             	mov    %eax,0x10(%ebp)
80100ee8:	83 c4 10             	add    $0x10,%esp
80100eeb:	e9 93 00 00 00       	jmp    80100f83 <filewrite+0xe6>

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
80100ef3:	ff 76 10             	pushl  0x10(%esi)
80100ef6:	e8 af 06 00 00       	call   801015aa <iunlock>
      end_op();
80100efb:	e8 2a 19 00 00       	call   8010282a <end_op>

      if(r < 0)
80100f00:	83 c4 10             	add    $0x10,%esp
80100f03:	85 db                	test   %ebx,%ebx
80100f05:	78 6b                	js     80100f72 <filewrite+0xd5>
        break;
      if(r != n1)
80100f07:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100f0a:	75 4e                	jne    80100f5a <filewrite+0xbd>
        panic("short filewrite");
      i += r;
80100f0c:	01 df                	add    %ebx,%edi
    while(i < n){
80100f0e:	39 7d 10             	cmp    %edi,0x10(%ebp)
80100f11:	7e 54                	jle    80100f67 <filewrite+0xca>
      int n1 = n - i;
80100f13:	8b 45 10             	mov    0x10(%ebp),%eax
80100f16:	29 f8                	sub    %edi,%eax
80100f18:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f1d:	ba 00 06 00 00       	mov    $0x600,%edx
80100f22:	0f 4f c2             	cmovg  %edx,%eax
80100f25:	89 c3                	mov    %eax,%ebx
80100f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      begin_op();
80100f2a:	e8 80 18 00 00       	call   801027af <begin_op>
      ilock(f->ip);
80100f2f:	83 ec 0c             	sub    $0xc,%esp
80100f32:	ff 76 10             	pushl  0x10(%esi)
80100f35:	e8 ae 05 00 00       	call   801014e8 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100f3a:	53                   	push   %ebx
80100f3b:	ff 76 14             	pushl  0x14(%esi)
80100f3e:	89 f8                	mov    %edi,%eax
80100f40:	03 45 0c             	add    0xc(%ebp),%eax
80100f43:	50                   	push   %eax
80100f44:	ff 76 10             	pushl  0x10(%esi)
80100f47:	e8 2c 09 00 00       	call   80101878 <writei>
80100f4c:	89 c3                	mov    %eax,%ebx
80100f4e:	83 c4 20             	add    $0x20,%esp
80100f51:	85 c0                	test   %eax,%eax
80100f53:	7e 9b                	jle    80100ef0 <filewrite+0x53>
        f->off += r;
80100f55:	01 46 14             	add    %eax,0x14(%esi)
80100f58:	eb 96                	jmp    80100ef0 <filewrite+0x53>
        panic("short filewrite");
80100f5a:	83 ec 0c             	sub    $0xc,%esp
80100f5d:	68 43 66 10 80       	push   $0x80106643
80100f62:	e8 dd f3 ff ff       	call   80100344 <panic>
80100f67:	89 f8                	mov    %edi,%eax
80100f69:	eb 09                	jmp    80100f74 <filewrite+0xd7>
    int i = 0;
80100f6b:	b8 00 00 00 00       	mov    $0x0,%eax
80100f70:	eb 02                	jmp    80100f74 <filewrite+0xd7>
80100f72:	89 f8                	mov    %edi,%eax
    }
    return i == n ? n : -1;
80100f74:	39 45 10             	cmp    %eax,0x10(%ebp)
80100f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f7c:	0f 44 45 10          	cmove  0x10(%ebp),%eax
80100f80:	89 45 10             	mov    %eax,0x10(%ebp)
  }
  panic("filewrite");
}
80100f83:	8b 45 10             	mov    0x10(%ebp),%eax
80100f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f89:	5b                   	pop    %ebx
80100f8a:	5e                   	pop    %esi
80100f8b:	5f                   	pop    %edi
80100f8c:	5d                   	pop    %ebp
80100f8d:	c3                   	ret    
  panic("filewrite");
80100f8e:	83 ec 0c             	sub    $0xc,%esp
80100f91:	68 49 66 10 80       	push   $0x80106649
80100f96:	e8 a9 f3 ff ff       	call   80100344 <panic>
    return -1;
80100f9b:	c7 45 10 ff ff ff ff 	movl   $0xffffffff,0x10(%ebp)
80100fa2:	eb df                	jmp    80100f83 <filewrite+0xe6>

80100fa4 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	57                   	push   %edi
80100fa8:	56                   	push   %esi
80100fa9:	53                   	push   %ebx
80100faa:	83 ec 2c             	sub    $0x2c,%esp
80100fad:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80100fb0:	83 3d 20 1a 11 80 00 	cmpl   $0x0,0x80111a20
80100fb7:	0f 84 32 01 00 00    	je     801010ef <balloc+0x14b>
80100fbd:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
80100fc4:	e9 8f 00 00 00       	jmp    80101058 <balloc+0xb4>
80100fc9:	89 c3                	mov    %eax,%ebx
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80100fcb:	09 ca                	or     %ecx,%edx
80100fcd:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100fd0:	88 54 03 5c          	mov    %dl,0x5c(%ebx,%eax,1)
        log_write(bp);
80100fd4:	83 ec 0c             	sub    $0xc,%esp
80100fd7:	53                   	push   %ebx
80100fd8:	e8 92 19 00 00       	call   8010296f <log_write>
        brelse(bp);
80100fdd:	89 1c 24             	mov    %ebx,(%esp)
80100fe0:	e8 dc f1 ff ff       	call   801001c1 <brelse>
  bp = bread(dev, bno);
80100fe5:	83 c4 08             	add    $0x8,%esp
80100fe8:	ff 75 e4             	pushl  -0x1c(%ebp)
80100feb:	ff 75 d4             	pushl  -0x2c(%ebp)
80100fee:	e8 b7 f0 ff ff       	call   801000aa <bread>
80100ff3:	89 c6                	mov    %eax,%esi
  memset(bp->data, 0, BSIZE);
80100ff5:	83 c4 0c             	add    $0xc,%esp
80100ff8:	68 00 02 00 00       	push   $0x200
80100ffd:	6a 00                	push   $0x0
80100fff:	8d 40 5c             	lea    0x5c(%eax),%eax
80101002:	50                   	push   %eax
80101003:	e8 58 2e 00 00       	call   80103e60 <memset>
  log_write(bp);
80101008:	89 34 24             	mov    %esi,(%esp)
8010100b:	e8 5f 19 00 00       	call   8010296f <log_write>
  brelse(bp);
80101010:	89 34 24             	mov    %esi,(%esp)
80101013:	e8 a9 f1 ff ff       	call   801001c1 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
80101018:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010101b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010101e:	5b                   	pop    %ebx
8010101f:	5e                   	pop    %esi
80101020:	5f                   	pop    %edi
80101021:	5d                   	pop    %ebp
80101022:	c3                   	ret    
80101023:	89 c3                	mov    %eax,%ebx
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101025:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      m = 1 << (bi % 8);
80101028:	b9 01 00 00 00       	mov    $0x1,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010102d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
80101034:	eb 95                	jmp    80100fcb <balloc+0x27>
    brelse(bp);
80101036:	83 ec 0c             	sub    $0xc,%esp
80101039:	50                   	push   %eax
8010103a:	e8 82 f1 ff ff       	call   801001c1 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010103f:	81 45 d8 00 10 00 00 	addl   $0x1000,-0x28(%ebp)
80101046:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101049:	83 c4 10             	add    $0x10,%esp
8010104c:	39 05 20 1a 11 80    	cmp    %eax,0x80111a20
80101052:	0f 86 97 00 00 00    	jbe    801010ef <balloc+0x14b>
    bp = bread(dev, BBLOCK(b, sb));
80101058:	83 ec 08             	sub    $0x8,%esp
8010105b:	8b 7d d8             	mov    -0x28(%ebp),%edi
8010105e:	89 fb                	mov    %edi,%ebx
80101060:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80101066:	85 ff                	test   %edi,%edi
80101068:	0f 49 c7             	cmovns %edi,%eax
8010106b:	c1 f8 0c             	sar    $0xc,%eax
8010106e:	03 05 38 1a 11 80    	add    0x80111a38,%eax
80101074:	50                   	push   %eax
80101075:	ff 75 d4             	pushl  -0x2c(%ebp)
80101078:	e8 2d f0 ff ff       	call   801000aa <bread>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010107d:	8b 0d 20 1a 11 80    	mov    0x80111a20,%ecx
80101083:	83 c4 10             	add    $0x10,%esp
80101086:	39 cf                	cmp    %ecx,%edi
80101088:	73 ac                	jae    80101036 <balloc+0x92>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010108a:	0f b6 50 5c          	movzbl 0x5c(%eax),%edx
8010108e:	f6 c2 01             	test   $0x1,%dl
80101091:	74 90                	je     80101023 <balloc+0x7f>
80101093:	29 f9                	sub    %edi,%ecx
80101095:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101098:	be 01 00 00 00       	mov    $0x1,%esi
8010109d:	8d 3c 1e             	lea    (%esi,%ebx,1),%edi
801010a0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801010a3:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801010a6:	74 8e                	je     80101036 <balloc+0x92>
      m = 1 << (bi % 8);
801010a8:	89 f2                	mov    %esi,%edx
801010aa:	c1 fa 1f             	sar    $0x1f,%edx
801010ad:	c1 ea 1d             	shr    $0x1d,%edx
801010b0:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
801010b3:	83 e1 07             	and    $0x7,%ecx
801010b6:	29 d1                	sub    %edx,%ecx
801010b8:	bf 01 00 00 00       	mov    $0x1,%edi
801010bd:	d3 e7                	shl    %cl,%edi
801010bf:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801010c1:	8d 56 07             	lea    0x7(%esi),%edx
801010c4:	85 f6                	test   %esi,%esi
801010c6:	0f 49 d6             	cmovns %esi,%edx
801010c9:	c1 fa 03             	sar    $0x3,%edx
801010cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
801010cf:	0f b6 54 10 5c       	movzbl 0x5c(%eax,%edx,1),%edx
801010d4:	0f b6 fa             	movzbl %dl,%edi
801010d7:	85 cf                	test   %ecx,%edi
801010d9:	0f 84 ea fe ff ff    	je     80100fc9 <balloc+0x25>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010df:	83 c6 01             	add    $0x1,%esi
801010e2:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
801010e8:	75 b3                	jne    8010109d <balloc+0xf9>
801010ea:	e9 47 ff ff ff       	jmp    80101036 <balloc+0x92>
  panic("balloc: out of blocks");
801010ef:	83 ec 0c             	sub    $0xc,%esp
801010f2:	68 53 66 10 80       	push   $0x80106653
801010f7:	e8 48 f2 ff ff       	call   80100344 <panic>

801010fc <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801010fc:	55                   	push   %ebp
801010fd:	89 e5                	mov    %esp,%ebp
801010ff:	57                   	push   %edi
80101100:	56                   	push   %esi
80101101:	53                   	push   %ebx
80101102:	83 ec 1c             	sub    $0x1c,%esp
80101105:	89 c6                	mov    %eax,%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101107:	83 fa 0b             	cmp    $0xb,%edx
8010110a:	77 18                	ja     80101124 <bmap+0x28>
8010110c:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
8010110f:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101112:	85 db                	test   %ebx,%ebx
80101114:	75 49                	jne    8010115f <bmap+0x63>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101116:	8b 00                	mov    (%eax),%eax
80101118:	e8 87 fe ff ff       	call   80100fa4 <balloc>
8010111d:	89 c3                	mov    %eax,%ebx
8010111f:	89 47 5c             	mov    %eax,0x5c(%edi)
80101122:	eb 3b                	jmp    8010115f <bmap+0x63>
    return addr;
  }
  bn -= NDIRECT;
80101124:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101127:	83 fb 7f             	cmp    $0x7f,%ebx
8010112a:	77 68                	ja     80101194 <bmap+0x98>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
8010112c:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101132:	85 c0                	test   %eax,%eax
80101134:	74 33                	je     80101169 <bmap+0x6d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101136:	83 ec 08             	sub    $0x8,%esp
80101139:	50                   	push   %eax
8010113a:	ff 36                	pushl  (%esi)
8010113c:	e8 69 ef ff ff       	call   801000aa <bread>
80101141:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101143:	8d 44 98 5c          	lea    0x5c(%eax,%ebx,4),%eax
80101147:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114a:	8b 18                	mov    (%eax),%ebx
8010114c:	83 c4 10             	add    $0x10,%esp
8010114f:	85 db                	test   %ebx,%ebx
80101151:	74 25                	je     80101178 <bmap+0x7c>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	57                   	push   %edi
80101157:	e8 65 f0 ff ff       	call   801001c1 <brelse>
    return addr;
8010115c:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
8010115f:	89 d8                	mov    %ebx,%eax
80101161:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101164:	5b                   	pop    %ebx
80101165:	5e                   	pop    %esi
80101166:	5f                   	pop    %edi
80101167:	5d                   	pop    %ebp
80101168:	c3                   	ret    
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101169:	8b 06                	mov    (%esi),%eax
8010116b:	e8 34 fe ff ff       	call   80100fa4 <balloc>
80101170:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101176:	eb be                	jmp    80101136 <bmap+0x3a>
      a[bn] = addr = balloc(ip->dev);
80101178:	8b 06                	mov    (%esi),%eax
8010117a:	e8 25 fe ff ff       	call   80100fa4 <balloc>
8010117f:	89 c3                	mov    %eax,%ebx
80101181:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101184:	89 18                	mov    %ebx,(%eax)
      log_write(bp);
80101186:	83 ec 0c             	sub    $0xc,%esp
80101189:	57                   	push   %edi
8010118a:	e8 e0 17 00 00       	call   8010296f <log_write>
8010118f:	83 c4 10             	add    $0x10,%esp
80101192:	eb bf                	jmp    80101153 <bmap+0x57>
  panic("bmap: out of range");
80101194:	83 ec 0c             	sub    $0xc,%esp
80101197:	68 69 66 10 80       	push   $0x80106669
8010119c:	e8 a3 f1 ff ff       	call   80100344 <panic>

801011a1 <iget>:
{
801011a1:	55                   	push   %ebp
801011a2:	89 e5                	mov    %esp,%ebp
801011a4:	57                   	push   %edi
801011a5:	56                   	push   %esi
801011a6:	53                   	push   %ebx
801011a7:	83 ec 28             	sub    $0x28,%esp
801011aa:	89 c7                	mov    %eax,%edi
801011ac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801011af:	68 40 1a 11 80       	push   $0x80111a40
801011b4:	e8 f9 2b 00 00       	call   80103db2 <acquire>
801011b9:	83 c4 10             	add    $0x10,%esp
  empty = 0;
801011bc:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011c1:	bb 74 1a 11 80       	mov    $0x80111a74,%ebx
801011c6:	eb 1c                	jmp    801011e4 <iget+0x43>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011c8:	85 c0                	test   %eax,%eax
801011ca:	75 0a                	jne    801011d6 <iget+0x35>
801011cc:	85 f6                	test   %esi,%esi
801011ce:	0f 94 c0             	sete   %al
801011d1:	84 c0                	test   %al,%al
801011d3:	0f 45 f3             	cmovne %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011d6:	81 c3 90 00 00 00    	add    $0x90,%ebx
801011dc:	81 fb 94 36 11 80    	cmp    $0x80113694,%ebx
801011e2:	73 2d                	jae    80101211 <iget+0x70>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801011e4:	8b 43 08             	mov    0x8(%ebx),%eax
801011e7:	85 c0                	test   %eax,%eax
801011e9:	7e dd                	jle    801011c8 <iget+0x27>
801011eb:	39 3b                	cmp    %edi,(%ebx)
801011ed:	75 e7                	jne    801011d6 <iget+0x35>
801011ef:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801011f2:	39 4b 04             	cmp    %ecx,0x4(%ebx)
801011f5:	75 df                	jne    801011d6 <iget+0x35>
      ip->ref++;
801011f7:	83 c0 01             	add    $0x1,%eax
801011fa:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
801011fd:	83 ec 0c             	sub    $0xc,%esp
80101200:	68 40 1a 11 80       	push   $0x80111a40
80101205:	e8 0f 2c 00 00       	call   80103e19 <release>
      return ip;
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	89 de                	mov    %ebx,%esi
8010120f:	eb 2a                	jmp    8010123b <iget+0x9a>
  if(empty == 0)
80101211:	85 f6                	test   %esi,%esi
80101213:	74 30                	je     80101245 <iget+0xa4>
  ip->dev = dev;
80101215:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101217:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010121a:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
8010121d:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101224:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010122b:	83 ec 0c             	sub    $0xc,%esp
8010122e:	68 40 1a 11 80       	push   $0x80111a40
80101233:	e8 e1 2b 00 00       	call   80103e19 <release>
  return ip;
80101238:	83 c4 10             	add    $0x10,%esp
}
8010123b:	89 f0                	mov    %esi,%eax
8010123d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101240:	5b                   	pop    %ebx
80101241:	5e                   	pop    %esi
80101242:	5f                   	pop    %edi
80101243:	5d                   	pop    %ebp
80101244:	c3                   	ret    
    panic("iget: no inodes");
80101245:	83 ec 0c             	sub    $0xc,%esp
80101248:	68 7c 66 10 80       	push   $0x8010667c
8010124d:	e8 f2 f0 ff ff       	call   80100344 <panic>

80101252 <readsb>:
{
80101252:	55                   	push   %ebp
80101253:	89 e5                	mov    %esp,%ebp
80101255:	53                   	push   %ebx
80101256:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
80101259:	6a 01                	push   $0x1
8010125b:	ff 75 08             	pushl  0x8(%ebp)
8010125e:	e8 47 ee ff ff       	call   801000aa <bread>
80101263:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101265:	83 c4 0c             	add    $0xc,%esp
80101268:	6a 1c                	push   $0x1c
8010126a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010126d:	50                   	push   %eax
8010126e:	ff 75 0c             	pushl  0xc(%ebp)
80101271:	e8 7f 2c 00 00       	call   80103ef5 <memmove>
  brelse(bp);
80101276:	89 1c 24             	mov    %ebx,(%esp)
80101279:	e8 43 ef ff ff       	call   801001c1 <brelse>
}
8010127e:	83 c4 10             	add    $0x10,%esp
80101281:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101284:	c9                   	leave  
80101285:	c3                   	ret    

80101286 <bfree>:
{
80101286:	55                   	push   %ebp
80101287:	89 e5                	mov    %esp,%ebp
80101289:	56                   	push   %esi
8010128a:	53                   	push   %ebx
8010128b:	89 c6                	mov    %eax,%esi
8010128d:	89 d3                	mov    %edx,%ebx
  readsb(dev, &sb);
8010128f:	83 ec 08             	sub    $0x8,%esp
80101292:	68 20 1a 11 80       	push   $0x80111a20
80101297:	50                   	push   %eax
80101298:	e8 b5 ff ff ff       	call   80101252 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010129d:	83 c4 08             	add    $0x8,%esp
801012a0:	89 d8                	mov    %ebx,%eax
801012a2:	c1 e8 0c             	shr    $0xc,%eax
801012a5:	03 05 38 1a 11 80    	add    0x80111a38,%eax
801012ab:	50                   	push   %eax
801012ac:	56                   	push   %esi
801012ad:	e8 f8 ed ff ff       	call   801000aa <bread>
801012b2:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801012b4:	89 d9                	mov    %ebx,%ecx
801012b6:	83 e1 07             	and    $0x7,%ecx
801012b9:	b8 01 00 00 00       	mov    $0x1,%eax
801012be:	d3 e0                	shl    %cl,%eax
  bi = b % BPB;
801012c0:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  if((bp->data[bi/8] & m) == 0)
801012c6:	83 c4 10             	add    $0x10,%esp
801012c9:	c1 fb 03             	sar    $0x3,%ebx
801012cc:	0f b6 54 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%edx
801012d1:	0f b6 ca             	movzbl %dl,%ecx
801012d4:	85 c1                	test   %eax,%ecx
801012d6:	74 23                	je     801012fb <bfree+0x75>
  bp->data[bi/8] &= ~m;
801012d8:	f7 d0                	not    %eax
801012da:	21 d0                	and    %edx,%eax
801012dc:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801012e0:	83 ec 0c             	sub    $0xc,%esp
801012e3:	56                   	push   %esi
801012e4:	e8 86 16 00 00       	call   8010296f <log_write>
  brelse(bp);
801012e9:	89 34 24             	mov    %esi,(%esp)
801012ec:	e8 d0 ee ff ff       	call   801001c1 <brelse>
}
801012f1:	83 c4 10             	add    $0x10,%esp
801012f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801012f7:	5b                   	pop    %ebx
801012f8:	5e                   	pop    %esi
801012f9:	5d                   	pop    %ebp
801012fa:	c3                   	ret    
    panic("freeing free block");
801012fb:	83 ec 0c             	sub    $0xc,%esp
801012fe:	68 8c 66 10 80       	push   $0x8010668c
80101303:	e8 3c f0 ff ff       	call   80100344 <panic>

80101308 <iinit>:
{
80101308:	55                   	push   %ebp
80101309:	89 e5                	mov    %esp,%ebp
8010130b:	56                   	push   %esi
8010130c:	53                   	push   %ebx
  initlock(&icache.lock, "icache");
8010130d:	83 ec 08             	sub    $0x8,%esp
80101310:	68 9f 66 10 80       	push   $0x8010669f
80101315:	68 40 1a 11 80       	push   $0x80111a40
8010131a:	e8 4b 29 00 00       	call   80103c6a <initlock>
8010131f:	bb 80 1a 11 80       	mov    $0x80111a80,%ebx
80101324:	be a0 36 11 80       	mov    $0x801136a0,%esi
80101329:	83 c4 10             	add    $0x10,%esp
    initsleeplock(&icache.inode[i].lock, "inode");
8010132c:	83 ec 08             	sub    $0x8,%esp
8010132f:	68 a6 66 10 80       	push   $0x801066a6
80101334:	53                   	push   %ebx
80101335:	e8 49 28 00 00       	call   80103b83 <initsleeplock>
8010133a:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(i = 0; i < NINODE; i++) {
80101340:	83 c4 10             	add    $0x10,%esp
80101343:	39 f3                	cmp    %esi,%ebx
80101345:	75 e5                	jne    8010132c <iinit+0x24>
  readsb(dev, &sb);
80101347:	83 ec 08             	sub    $0x8,%esp
8010134a:	68 20 1a 11 80       	push   $0x80111a20
8010134f:	ff 75 08             	pushl  0x8(%ebp)
80101352:	e8 fb fe ff ff       	call   80101252 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101357:	ff 35 38 1a 11 80    	pushl  0x80111a38
8010135d:	ff 35 34 1a 11 80    	pushl  0x80111a34
80101363:	ff 35 30 1a 11 80    	pushl  0x80111a30
80101369:	ff 35 2c 1a 11 80    	pushl  0x80111a2c
8010136f:	ff 35 28 1a 11 80    	pushl  0x80111a28
80101375:	ff 35 24 1a 11 80    	pushl  0x80111a24
8010137b:	ff 35 20 1a 11 80    	pushl  0x80111a20
80101381:	68 0c 67 10 80       	push   $0x8010670c
80101386:	e8 56 f2 ff ff       	call   801005e1 <cprintf>
}
8010138b:	83 c4 30             	add    $0x30,%esp
8010138e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5d                   	pop    %ebp
80101394:	c3                   	ret    

80101395 <ialloc>:
{
80101395:	55                   	push   %ebp
80101396:	89 e5                	mov    %esp,%ebp
80101398:	57                   	push   %edi
80101399:	56                   	push   %esi
8010139a:	53                   	push   %ebx
8010139b:	83 ec 1c             	sub    $0x1c,%esp
8010139e:	8b 45 0c             	mov    0xc(%ebp),%eax
801013a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013a4:	83 3d 28 1a 11 80 01 	cmpl   $0x1,0x80111a28
801013ab:	76 4d                	jbe    801013fa <ialloc+0x65>
801013ad:	bb 01 00 00 00       	mov    $0x1,%ebx
801013b2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    bp = bread(dev, IBLOCK(inum, sb));
801013b5:	83 ec 08             	sub    $0x8,%esp
801013b8:	89 d8                	mov    %ebx,%eax
801013ba:	c1 e8 03             	shr    $0x3,%eax
801013bd:	03 05 34 1a 11 80    	add    0x80111a34,%eax
801013c3:	50                   	push   %eax
801013c4:	ff 75 08             	pushl  0x8(%ebp)
801013c7:	e8 de ec ff ff       	call   801000aa <bread>
801013cc:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013ce:	89 d8                	mov    %ebx,%eax
801013d0:	83 e0 07             	and    $0x7,%eax
801013d3:	c1 e0 06             	shl    $0x6,%eax
801013d6:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
801013da:	83 c4 10             	add    $0x10,%esp
801013dd:	66 83 3f 00          	cmpw   $0x0,(%edi)
801013e1:	74 24                	je     80101407 <ialloc+0x72>
    brelse(bp);
801013e3:	83 ec 0c             	sub    $0xc,%esp
801013e6:	56                   	push   %esi
801013e7:	e8 d5 ed ff ff       	call   801001c1 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801013ec:	83 c3 01             	add    $0x1,%ebx
801013ef:	83 c4 10             	add    $0x10,%esp
801013f2:	39 1d 28 1a 11 80    	cmp    %ebx,0x80111a28
801013f8:	77 b8                	ja     801013b2 <ialloc+0x1d>
  panic("ialloc: no inodes");
801013fa:	83 ec 0c             	sub    $0xc,%esp
801013fd:	68 ac 66 10 80       	push   $0x801066ac
80101402:	e8 3d ef ff ff       	call   80100344 <panic>
      memset(dip, 0, sizeof(*dip));
80101407:	83 ec 04             	sub    $0x4,%esp
8010140a:	6a 40                	push   $0x40
8010140c:	6a 00                	push   $0x0
8010140e:	57                   	push   %edi
8010140f:	e8 4c 2a 00 00       	call   80103e60 <memset>
      dip->type = type;
80101414:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80101418:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
8010141b:	89 34 24             	mov    %esi,(%esp)
8010141e:	e8 4c 15 00 00       	call   8010296f <log_write>
      brelse(bp);
80101423:	89 34 24             	mov    %esi,(%esp)
80101426:	e8 96 ed ff ff       	call   801001c1 <brelse>
      return iget(dev, inum);
8010142b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010142e:	8b 45 08             	mov    0x8(%ebp),%eax
80101431:	e8 6b fd ff ff       	call   801011a1 <iget>
}
80101436:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101439:	5b                   	pop    %ebx
8010143a:	5e                   	pop    %esi
8010143b:	5f                   	pop    %edi
8010143c:	5d                   	pop    %ebp
8010143d:	c3                   	ret    

8010143e <iupdate>:
{
8010143e:	55                   	push   %ebp
8010143f:	89 e5                	mov    %esp,%ebp
80101441:	56                   	push   %esi
80101442:	53                   	push   %ebx
80101443:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101446:	83 ec 08             	sub    $0x8,%esp
80101449:	8b 43 04             	mov    0x4(%ebx),%eax
8010144c:	c1 e8 03             	shr    $0x3,%eax
8010144f:	03 05 34 1a 11 80    	add    0x80111a34,%eax
80101455:	50                   	push   %eax
80101456:	ff 33                	pushl  (%ebx)
80101458:	e8 4d ec ff ff       	call   801000aa <bread>
8010145d:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010145f:	8b 43 04             	mov    0x4(%ebx),%eax
80101462:	83 e0 07             	and    $0x7,%eax
80101465:	c1 e0 06             	shl    $0x6,%eax
80101468:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010146c:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
80101470:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101473:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
80101477:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010147b:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
8010147f:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101483:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
80101487:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010148b:	8b 53 58             	mov    0x58(%ebx),%edx
8010148e:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101491:	83 c4 0c             	add    $0xc,%esp
80101494:	6a 34                	push   $0x34
80101496:	83 c3 5c             	add    $0x5c,%ebx
80101499:	53                   	push   %ebx
8010149a:	83 c0 0c             	add    $0xc,%eax
8010149d:	50                   	push   %eax
8010149e:	e8 52 2a 00 00       	call   80103ef5 <memmove>
  log_write(bp);
801014a3:	89 34 24             	mov    %esi,(%esp)
801014a6:	e8 c4 14 00 00       	call   8010296f <log_write>
  brelse(bp);
801014ab:	89 34 24             	mov    %esi,(%esp)
801014ae:	e8 0e ed ff ff       	call   801001c1 <brelse>
}
801014b3:	83 c4 10             	add    $0x10,%esp
801014b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014b9:	5b                   	pop    %ebx
801014ba:	5e                   	pop    %esi
801014bb:	5d                   	pop    %ebp
801014bc:	c3                   	ret    

801014bd <idup>:
{
801014bd:	55                   	push   %ebp
801014be:	89 e5                	mov    %esp,%ebp
801014c0:	53                   	push   %ebx
801014c1:	83 ec 10             	sub    $0x10,%esp
801014c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801014c7:	68 40 1a 11 80       	push   $0x80111a40
801014cc:	e8 e1 28 00 00       	call   80103db2 <acquire>
  ip->ref++;
801014d1:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801014d5:	c7 04 24 40 1a 11 80 	movl   $0x80111a40,(%esp)
801014dc:	e8 38 29 00 00       	call   80103e19 <release>
}
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014e6:	c9                   	leave  
801014e7:	c3                   	ret    

801014e8 <ilock>:
{
801014e8:	55                   	push   %ebp
801014e9:	89 e5                	mov    %esp,%ebp
801014eb:	56                   	push   %esi
801014ec:	53                   	push   %ebx
801014ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801014f0:	85 db                	test   %ebx,%ebx
801014f2:	74 22                	je     80101516 <ilock+0x2e>
801014f4:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801014f8:	7e 1c                	jle    80101516 <ilock+0x2e>
  acquiresleep(&ip->lock);
801014fa:	83 ec 0c             	sub    $0xc,%esp
801014fd:	8d 43 0c             	lea    0xc(%ebx),%eax
80101500:	50                   	push   %eax
80101501:	e8 b0 26 00 00       	call   80103bb6 <acquiresleep>
  if(ip->valid == 0){
80101506:	83 c4 10             	add    $0x10,%esp
80101509:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010150d:	74 14                	je     80101523 <ilock+0x3b>
}
8010150f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101512:	5b                   	pop    %ebx
80101513:	5e                   	pop    %esi
80101514:	5d                   	pop    %ebp
80101515:	c3                   	ret    
    panic("ilock");
80101516:	83 ec 0c             	sub    $0xc,%esp
80101519:	68 be 66 10 80       	push   $0x801066be
8010151e:	e8 21 ee ff ff       	call   80100344 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101523:	83 ec 08             	sub    $0x8,%esp
80101526:	8b 43 04             	mov    0x4(%ebx),%eax
80101529:	c1 e8 03             	shr    $0x3,%eax
8010152c:	03 05 34 1a 11 80    	add    0x80111a34,%eax
80101532:	50                   	push   %eax
80101533:	ff 33                	pushl  (%ebx)
80101535:	e8 70 eb ff ff       	call   801000aa <bread>
8010153a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010153c:	8b 43 04             	mov    0x4(%ebx),%eax
8010153f:	83 e0 07             	and    $0x7,%eax
80101542:	c1 e0 06             	shl    $0x6,%eax
80101545:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101549:	0f b7 10             	movzwl (%eax),%edx
8010154c:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101550:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101554:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
80101558:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010155c:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101560:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101564:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
80101568:	8b 50 08             	mov    0x8(%eax),%edx
8010156b:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010156e:	83 c4 0c             	add    $0xc,%esp
80101571:	6a 34                	push   $0x34
80101573:	83 c0 0c             	add    $0xc,%eax
80101576:	50                   	push   %eax
80101577:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010157a:	50                   	push   %eax
8010157b:	e8 75 29 00 00       	call   80103ef5 <memmove>
    brelse(bp);
80101580:	89 34 24             	mov    %esi,(%esp)
80101583:	e8 39 ec ff ff       	call   801001c1 <brelse>
    ip->valid = 1;
80101588:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
8010158f:	83 c4 10             	add    $0x10,%esp
80101592:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101597:	0f 85 72 ff ff ff    	jne    8010150f <ilock+0x27>
      panic("ilock: no type");
8010159d:	83 ec 0c             	sub    $0xc,%esp
801015a0:	68 c4 66 10 80       	push   $0x801066c4
801015a5:	e8 9a ed ff ff       	call   80100344 <panic>

801015aa <iunlock>:
{
801015aa:	55                   	push   %ebp
801015ab:	89 e5                	mov    %esp,%ebp
801015ad:	56                   	push   %esi
801015ae:	53                   	push   %ebx
801015af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801015b2:	85 db                	test   %ebx,%ebx
801015b4:	74 2c                	je     801015e2 <iunlock+0x38>
801015b6:	8d 73 0c             	lea    0xc(%ebx),%esi
801015b9:	83 ec 0c             	sub    $0xc,%esp
801015bc:	56                   	push   %esi
801015bd:	e8 81 26 00 00       	call   80103c43 <holdingsleep>
801015c2:	83 c4 10             	add    $0x10,%esp
801015c5:	85 c0                	test   %eax,%eax
801015c7:	74 19                	je     801015e2 <iunlock+0x38>
801015c9:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015cd:	7e 13                	jle    801015e2 <iunlock+0x38>
  releasesleep(&ip->lock);
801015cf:	83 ec 0c             	sub    $0xc,%esp
801015d2:	56                   	push   %esi
801015d3:	e8 30 26 00 00       	call   80103c08 <releasesleep>
}
801015d8:	83 c4 10             	add    $0x10,%esp
801015db:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015de:	5b                   	pop    %ebx
801015df:	5e                   	pop    %esi
801015e0:	5d                   	pop    %ebp
801015e1:	c3                   	ret    
    panic("iunlock");
801015e2:	83 ec 0c             	sub    $0xc,%esp
801015e5:	68 d3 66 10 80       	push   $0x801066d3
801015ea:	e8 55 ed ff ff       	call   80100344 <panic>

801015ef <iput>:
{
801015ef:	55                   	push   %ebp
801015f0:	89 e5                	mov    %esp,%ebp
801015f2:	57                   	push   %edi
801015f3:	56                   	push   %esi
801015f4:	53                   	push   %ebx
801015f5:	83 ec 28             	sub    $0x28,%esp
801015f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801015fb:	8d 73 0c             	lea    0xc(%ebx),%esi
801015fe:	56                   	push   %esi
801015ff:	e8 b2 25 00 00       	call   80103bb6 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101604:	83 c4 10             	add    $0x10,%esp
80101607:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
8010160b:	74 07                	je     80101614 <iput+0x25>
8010160d:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101612:	74 30                	je     80101644 <iput+0x55>
  releasesleep(&ip->lock);
80101614:	83 ec 0c             	sub    $0xc,%esp
80101617:	56                   	push   %esi
80101618:	e8 eb 25 00 00       	call   80103c08 <releasesleep>
  acquire(&icache.lock);
8010161d:	c7 04 24 40 1a 11 80 	movl   $0x80111a40,(%esp)
80101624:	e8 89 27 00 00       	call   80103db2 <acquire>
  ip->ref--;
80101629:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010162d:	c7 04 24 40 1a 11 80 	movl   $0x80111a40,(%esp)
80101634:	e8 e0 27 00 00       	call   80103e19 <release>
}
80101639:	83 c4 10             	add    $0x10,%esp
8010163c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010163f:	5b                   	pop    %ebx
80101640:	5e                   	pop    %esi
80101641:	5f                   	pop    %edi
80101642:	5d                   	pop    %ebp
80101643:	c3                   	ret    
    acquire(&icache.lock);
80101644:	83 ec 0c             	sub    $0xc,%esp
80101647:	68 40 1a 11 80       	push   $0x80111a40
8010164c:	e8 61 27 00 00       	call   80103db2 <acquire>
    int r = ip->ref;
80101651:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101654:	c7 04 24 40 1a 11 80 	movl   $0x80111a40,(%esp)
8010165b:	e8 b9 27 00 00       	call   80103e19 <release>
    if(r == 1){
80101660:	83 c4 10             	add    $0x10,%esp
80101663:	83 ff 01             	cmp    $0x1,%edi
80101666:	75 ac                	jne    80101614 <iput+0x25>
80101668:	8d 7b 5c             	lea    0x5c(%ebx),%edi
8010166b:	8d 83 8c 00 00 00    	lea    0x8c(%ebx),%eax
80101671:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80101674:	89 c6                	mov    %eax,%esi
80101676:	eb 07                	jmp    8010167f <iput+0x90>
80101678:	83 c7 04             	add    $0x4,%edi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
8010167b:	39 f7                	cmp    %esi,%edi
8010167d:	74 15                	je     80101694 <iput+0xa5>
    if(ip->addrs[i]){
8010167f:	8b 17                	mov    (%edi),%edx
80101681:	85 d2                	test   %edx,%edx
80101683:	74 f3                	je     80101678 <iput+0x89>
      bfree(ip->dev, ip->addrs[i]);
80101685:	8b 03                	mov    (%ebx),%eax
80101687:	e8 fa fb ff ff       	call   80101286 <bfree>
      ip->addrs[i] = 0;
8010168c:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80101692:	eb e4                	jmp    80101678 <iput+0x89>
80101694:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101697:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010169d:	85 c0                	test   %eax,%eax
8010169f:	75 2d                	jne    801016ce <iput+0xdf>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801016a1:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801016a8:	83 ec 0c             	sub    $0xc,%esp
801016ab:	53                   	push   %ebx
801016ac:	e8 8d fd ff ff       	call   8010143e <iupdate>
      ip->type = 0;
801016b1:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
801016b7:	89 1c 24             	mov    %ebx,(%esp)
801016ba:	e8 7f fd ff ff       	call   8010143e <iupdate>
      ip->valid = 0;
801016bf:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801016c6:	83 c4 10             	add    $0x10,%esp
801016c9:	e9 46 ff ff ff       	jmp    80101614 <iput+0x25>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801016ce:	83 ec 08             	sub    $0x8,%esp
801016d1:	50                   	push   %eax
801016d2:	ff 33                	pushl  (%ebx)
801016d4:	e8 d1 e9 ff ff       	call   801000aa <bread>
801016d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801016dc:	8d 78 5c             	lea    0x5c(%eax),%edi
801016df:	05 5c 02 00 00       	add    $0x25c,%eax
801016e4:	83 c4 10             	add    $0x10,%esp
801016e7:	89 75 e0             	mov    %esi,-0x20(%ebp)
801016ea:	89 c6                	mov    %eax,%esi
801016ec:	eb 07                	jmp    801016f5 <iput+0x106>
801016ee:	83 c7 04             	add    $0x4,%edi
    for(j = 0; j < NINDIRECT; j++){
801016f1:	39 fe                	cmp    %edi,%esi
801016f3:	74 0f                	je     80101704 <iput+0x115>
      if(a[j])
801016f5:	8b 17                	mov    (%edi),%edx
801016f7:	85 d2                	test   %edx,%edx
801016f9:	74 f3                	je     801016ee <iput+0xff>
        bfree(ip->dev, a[j]);
801016fb:	8b 03                	mov    (%ebx),%eax
801016fd:	e8 84 fb ff ff       	call   80101286 <bfree>
80101702:	eb ea                	jmp    801016ee <iput+0xff>
80101704:	8b 75 e0             	mov    -0x20(%ebp),%esi
    brelse(bp);
80101707:	83 ec 0c             	sub    $0xc,%esp
8010170a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010170d:	e8 af ea ff ff       	call   801001c1 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101712:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101718:	8b 03                	mov    (%ebx),%eax
8010171a:	e8 67 fb ff ff       	call   80101286 <bfree>
    ip->addrs[NDIRECT] = 0;
8010171f:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101726:	00 00 00 
80101729:	83 c4 10             	add    $0x10,%esp
8010172c:	e9 70 ff ff ff       	jmp    801016a1 <iput+0xb2>

80101731 <iunlockput>:
{
80101731:	55                   	push   %ebp
80101732:	89 e5                	mov    %esp,%ebp
80101734:	53                   	push   %ebx
80101735:	83 ec 10             	sub    $0x10,%esp
80101738:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010173b:	53                   	push   %ebx
8010173c:	e8 69 fe ff ff       	call   801015aa <iunlock>
  iput(ip);
80101741:	89 1c 24             	mov    %ebx,(%esp)
80101744:	e8 a6 fe ff ff       	call   801015ef <iput>
}
80101749:	83 c4 10             	add    $0x10,%esp
8010174c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010174f:	c9                   	leave  
80101750:	c3                   	ret    

80101751 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101751:	55                   	push   %ebp
80101752:	89 e5                	mov    %esp,%ebp
80101754:	8b 55 08             	mov    0x8(%ebp),%edx
80101757:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
8010175a:	8b 0a                	mov    (%edx),%ecx
8010175c:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010175f:	8b 4a 04             	mov    0x4(%edx),%ecx
80101762:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101765:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101769:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010176c:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101770:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101774:	8b 52 58             	mov    0x58(%edx),%edx
80101777:	89 50 10             	mov    %edx,0x10(%eax)
}
8010177a:	5d                   	pop    %ebp
8010177b:	c3                   	ret    

8010177c <readi>:

// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010177c:	55                   	push   %ebp
8010177d:	89 e5                	mov    %esp,%ebp
8010177f:	57                   	push   %edi
80101780:	56                   	push   %esi
80101781:	53                   	push   %ebx
80101782:	83 ec 1c             	sub    $0x1c,%esp
80101785:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101788:	8b 45 08             	mov    0x8(%ebp),%eax
8010178b:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101790:	0f 84 9d 00 00 00    	je     80101833 <readi+0xb7>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101796:	8b 45 08             	mov    0x8(%ebp),%eax
80101799:	8b 40 58             	mov    0x58(%eax),%eax
8010179c:	39 f8                	cmp    %edi,%eax
8010179e:	0f 82 c6 00 00 00    	jb     8010186a <readi+0xee>
801017a4:	89 fa                	mov    %edi,%edx
801017a6:	03 55 14             	add    0x14(%ebp),%edx
801017a9:	0f 82 c2 00 00 00    	jb     80101871 <readi+0xf5>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801017af:	89 c1                	mov    %eax,%ecx
801017b1:	29 f9                	sub    %edi,%ecx
801017b3:	39 d0                	cmp    %edx,%eax
801017b5:	0f 43 4d 14          	cmovae 0x14(%ebp),%ecx
801017b9:	89 4d 14             	mov    %ecx,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017bc:	85 c9                	test   %ecx,%ecx
801017be:	74 68                	je     80101828 <readi+0xac>
801017c0:	be 00 00 00 00       	mov    $0x0,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801017c5:	89 fa                	mov    %edi,%edx
801017c7:	c1 ea 09             	shr    $0x9,%edx
801017ca:	8b 45 08             	mov    0x8(%ebp),%eax
801017cd:	e8 2a f9 ff ff       	call   801010fc <bmap>
801017d2:	83 ec 08             	sub    $0x8,%esp
801017d5:	50                   	push   %eax
801017d6:	8b 45 08             	mov    0x8(%ebp),%eax
801017d9:	ff 30                	pushl  (%eax)
801017db:	e8 ca e8 ff ff       	call   801000aa <bread>
801017e0:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
801017e2:	89 f8                	mov    %edi,%eax
801017e4:	25 ff 01 00 00       	and    $0x1ff,%eax
801017e9:	bb 00 02 00 00       	mov    $0x200,%ebx
801017ee:	29 c3                	sub    %eax,%ebx
801017f0:	8b 55 14             	mov    0x14(%ebp),%edx
801017f3:	29 f2                	sub    %esi,%edx
801017f5:	83 c4 0c             	add    $0xc,%esp
801017f8:	39 d3                	cmp    %edx,%ebx
801017fa:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801017fd:	53                   	push   %ebx
801017fe:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101801:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101805:	50                   	push   %eax
80101806:	ff 75 0c             	pushl  0xc(%ebp)
80101809:	e8 e7 26 00 00       	call   80103ef5 <memmove>
    brelse(bp);
8010180e:	83 c4 04             	add    $0x4,%esp
80101811:	ff 75 e4             	pushl  -0x1c(%ebp)
80101814:	e8 a8 e9 ff ff       	call   801001c1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101819:	01 de                	add    %ebx,%esi
8010181b:	01 df                	add    %ebx,%edi
8010181d:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101820:	83 c4 10             	add    $0x10,%esp
80101823:	39 75 14             	cmp    %esi,0x14(%ebp)
80101826:	77 9d                	ja     801017c5 <readi+0x49>
  }
  return n;
80101828:	8b 45 14             	mov    0x14(%ebp),%eax
}
8010182b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010182e:	5b                   	pop    %ebx
8010182f:	5e                   	pop    %esi
80101830:	5f                   	pop    %edi
80101831:	5d                   	pop    %ebp
80101832:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101833:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101837:	66 83 f8 09          	cmp    $0x9,%ax
8010183b:	77 1f                	ja     8010185c <readi+0xe0>
8010183d:	98                   	cwtl   
8010183e:	8b 04 c5 c0 19 11 80 	mov    -0x7feee640(,%eax,8),%eax
80101845:	85 c0                	test   %eax,%eax
80101847:	74 1a                	je     80101863 <readi+0xe7>
    return devsw[ip->major].read(ip, dst, n);
80101849:	83 ec 04             	sub    $0x4,%esp
8010184c:	ff 75 14             	pushl  0x14(%ebp)
8010184f:	ff 75 0c             	pushl  0xc(%ebp)
80101852:	ff 75 08             	pushl  0x8(%ebp)
80101855:	ff d0                	call   *%eax
80101857:	83 c4 10             	add    $0x10,%esp
8010185a:	eb cf                	jmp    8010182b <readi+0xaf>
      return -1;
8010185c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101861:	eb c8                	jmp    8010182b <readi+0xaf>
80101863:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101868:	eb c1                	jmp    8010182b <readi+0xaf>
    return -1;
8010186a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010186f:	eb ba                	jmp    8010182b <readi+0xaf>
80101871:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101876:	eb b3                	jmp    8010182b <readi+0xaf>

80101878 <writei>:

// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101878:	55                   	push   %ebp
80101879:	89 e5                	mov    %esp,%ebp
8010187b:	57                   	push   %edi
8010187c:	56                   	push   %esi
8010187d:	53                   	push   %ebx
8010187e:	83 ec 1c             	sub    $0x1c,%esp
80101881:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101884:	8b 45 08             	mov    0x8(%ebp),%eax
80101887:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
8010188c:	0f 84 ae 00 00 00    	je     80101940 <writei+0xc8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101892:	8b 45 08             	mov    0x8(%ebp),%eax
80101895:	39 70 58             	cmp    %esi,0x58(%eax)
80101898:	0f 82 ed 00 00 00    	jb     8010198b <writei+0x113>
8010189e:	89 f0                	mov    %esi,%eax
801018a0:	03 45 14             	add    0x14(%ebp),%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
801018a3:	3d 00 18 01 00       	cmp    $0x11800,%eax
801018a8:	0f 87 e4 00 00 00    	ja     80101992 <writei+0x11a>
801018ae:	39 f0                	cmp    %esi,%eax
801018b0:	0f 82 dc 00 00 00    	jb     80101992 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018b6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801018ba:	74 79                	je     80101935 <writei+0xbd>
801018bc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801018c3:	89 f2                	mov    %esi,%edx
801018c5:	c1 ea 09             	shr    $0x9,%edx
801018c8:	8b 45 08             	mov    0x8(%ebp),%eax
801018cb:	e8 2c f8 ff ff       	call   801010fc <bmap>
801018d0:	83 ec 08             	sub    $0x8,%esp
801018d3:	50                   	push   %eax
801018d4:	8b 45 08             	mov    0x8(%ebp),%eax
801018d7:	ff 30                	pushl  (%eax)
801018d9:	e8 cc e7 ff ff       	call   801000aa <bread>
801018de:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801018e0:	89 f0                	mov    %esi,%eax
801018e2:	25 ff 01 00 00       	and    $0x1ff,%eax
801018e7:	bb 00 02 00 00       	mov    $0x200,%ebx
801018ec:	29 c3                	sub    %eax,%ebx
801018ee:	8b 55 14             	mov    0x14(%ebp),%edx
801018f1:	2b 55 e4             	sub    -0x1c(%ebp),%edx
801018f4:	83 c4 0c             	add    $0xc,%esp
801018f7:	39 d3                	cmp    %edx,%ebx
801018f9:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
801018fc:	53                   	push   %ebx
801018fd:	ff 75 0c             	pushl  0xc(%ebp)
80101900:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
80101904:	50                   	push   %eax
80101905:	e8 eb 25 00 00       	call   80103ef5 <memmove>
    log_write(bp);
8010190a:	89 3c 24             	mov    %edi,(%esp)
8010190d:	e8 5d 10 00 00       	call   8010296f <log_write>
    brelse(bp);
80101912:	89 3c 24             	mov    %edi,(%esp)
80101915:	e8 a7 e8 ff ff       	call   801001c1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010191a:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010191d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101920:	01 de                	add    %ebx,%esi
80101922:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101925:	83 c4 10             	add    $0x10,%esp
80101928:	39 4d 14             	cmp    %ecx,0x14(%ebp)
8010192b:	77 96                	ja     801018c3 <writei+0x4b>
  }

  if(n > 0 && off > ip->size){
8010192d:	8b 45 08             	mov    0x8(%ebp),%eax
80101930:	39 70 58             	cmp    %esi,0x58(%eax)
80101933:	72 34                	jb     80101969 <writei+0xf1>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101935:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101938:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010193b:	5b                   	pop    %ebx
8010193c:	5e                   	pop    %esi
8010193d:	5f                   	pop    %edi
8010193e:	5d                   	pop    %ebp
8010193f:	c3                   	ret    
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101940:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101944:	66 83 f8 09          	cmp    $0x9,%ax
80101948:	77 33                	ja     8010197d <writei+0x105>
8010194a:	98                   	cwtl   
8010194b:	8b 04 c5 c4 19 11 80 	mov    -0x7feee63c(,%eax,8),%eax
80101952:	85 c0                	test   %eax,%eax
80101954:	74 2e                	je     80101984 <writei+0x10c>
    return devsw[ip->major].write(ip, src, n);
80101956:	83 ec 04             	sub    $0x4,%esp
80101959:	ff 75 14             	pushl  0x14(%ebp)
8010195c:	ff 75 0c             	pushl  0xc(%ebp)
8010195f:	ff 75 08             	pushl  0x8(%ebp)
80101962:	ff d0                	call   *%eax
80101964:	83 c4 10             	add    $0x10,%esp
80101967:	eb cf                	jmp    80101938 <writei+0xc0>
    ip->size = off;
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
8010196f:	83 ec 0c             	sub    $0xc,%esp
80101972:	50                   	push   %eax
80101973:	e8 c6 fa ff ff       	call   8010143e <iupdate>
80101978:	83 c4 10             	add    $0x10,%esp
8010197b:	eb b8                	jmp    80101935 <writei+0xbd>
      return -1;
8010197d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101982:	eb b4                	jmp    80101938 <writei+0xc0>
80101984:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101989:	eb ad                	jmp    80101938 <writei+0xc0>
    return -1;
8010198b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101990:	eb a6                	jmp    80101938 <writei+0xc0>
    return -1;
80101992:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101997:	eb 9f                	jmp    80101938 <writei+0xc0>

80101999 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
80101999:	55                   	push   %ebp
8010199a:	89 e5                	mov    %esp,%ebp
8010199c:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
8010199f:	6a 0e                	push   $0xe
801019a1:	ff 75 0c             	pushl  0xc(%ebp)
801019a4:	ff 75 08             	pushl  0x8(%ebp)
801019a7:	e8 a8 25 00 00       	call   80103f54 <strncmp>
}
801019ac:	c9                   	leave  
801019ad:	c3                   	ret    

801019ae <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801019ae:	55                   	push   %ebp
801019af:	89 e5                	mov    %esp,%ebp
801019b1:	57                   	push   %edi
801019b2:	56                   	push   %esi
801019b3:	53                   	push   %ebx
801019b4:	83 ec 1c             	sub    $0x1c,%esp
801019b7:	8b 75 08             	mov    0x8(%ebp),%esi
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801019ba:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801019bf:	75 15                	jne    801019d6 <dirlookup+0x28>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801019c1:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801019c6:	8d 7d d8             	lea    -0x28(%ebp),%edi
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801019c9:	b8 00 00 00 00       	mov    $0x0,%eax
  for(off = 0; off < dp->size; off += sizeof(de)){
801019ce:	83 7e 58 00          	cmpl   $0x0,0x58(%esi)
801019d2:	75 24                	jne    801019f8 <dirlookup+0x4a>
801019d4:	eb 6e                	jmp    80101a44 <dirlookup+0x96>
    panic("dirlookup not DIR");
801019d6:	83 ec 0c             	sub    $0xc,%esp
801019d9:	68 db 66 10 80       	push   $0x801066db
801019de:	e8 61 e9 ff ff       	call   80100344 <panic>
      panic("dirlookup read");
801019e3:	83 ec 0c             	sub    $0xc,%esp
801019e6:	68 ed 66 10 80       	push   $0x801066ed
801019eb:	e8 54 e9 ff ff       	call   80100344 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019f0:	83 c3 10             	add    $0x10,%ebx
801019f3:	39 5e 58             	cmp    %ebx,0x58(%esi)
801019f6:	76 47                	jbe    80101a3f <dirlookup+0x91>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801019f8:	6a 10                	push   $0x10
801019fa:	53                   	push   %ebx
801019fb:	57                   	push   %edi
801019fc:	56                   	push   %esi
801019fd:	e8 7a fd ff ff       	call   8010177c <readi>
80101a02:	83 c4 10             	add    $0x10,%esp
80101a05:	83 f8 10             	cmp    $0x10,%eax
80101a08:	75 d9                	jne    801019e3 <dirlookup+0x35>
    if(de.inum == 0)
80101a0a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a0f:	74 df                	je     801019f0 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
80101a11:	83 ec 08             	sub    $0x8,%esp
80101a14:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a17:	50                   	push   %eax
80101a18:	ff 75 0c             	pushl  0xc(%ebp)
80101a1b:	e8 79 ff ff ff       	call   80101999 <namecmp>
80101a20:	83 c4 10             	add    $0x10,%esp
80101a23:	85 c0                	test   %eax,%eax
80101a25:	75 c9                	jne    801019f0 <dirlookup+0x42>
      if(poff)
80101a27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a2b:	74 05                	je     80101a32 <dirlookup+0x84>
        *poff = off;
80101a2d:	8b 45 10             	mov    0x10(%ebp),%eax
80101a30:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a32:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a36:	8b 06                	mov    (%esi),%eax
80101a38:	e8 64 f7 ff ff       	call   801011a1 <iget>
80101a3d:	eb 05                	jmp    80101a44 <dirlookup+0x96>
  return 0;
80101a3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101a44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a47:	5b                   	pop    %ebx
80101a48:	5e                   	pop    %esi
80101a49:	5f                   	pop    %edi
80101a4a:	5d                   	pop    %ebp
80101a4b:	c3                   	ret    

80101a4c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a4c:	55                   	push   %ebp
80101a4d:	89 e5                	mov    %esp,%ebp
80101a4f:	57                   	push   %edi
80101a50:	56                   	push   %esi
80101a51:	53                   	push   %ebx
80101a52:	83 ec 1c             	sub    $0x1c,%esp
80101a55:	89 c6                	mov    %eax,%esi
80101a57:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a5a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a5d:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a60:	74 1a                	je     80101a7c <namex+0x30>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a62:	e8 d4 18 00 00       	call   8010333b <myproc>
80101a67:	83 ec 0c             	sub    $0xc,%esp
80101a6a:	ff 70 68             	pushl  0x68(%eax)
80101a6d:	e8 4b fa ff ff       	call   801014bd <idup>
80101a72:	89 c7                	mov    %eax,%edi
80101a74:	83 c4 10             	add    $0x10,%esp
80101a77:	e9 d4 00 00 00       	jmp    80101b50 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
80101a7c:	ba 01 00 00 00       	mov    $0x1,%edx
80101a81:	b8 01 00 00 00       	mov    $0x1,%eax
80101a86:	e8 16 f7 ff ff       	call   801011a1 <iget>
80101a8b:	89 c7                	mov    %eax,%edi
80101a8d:	e9 be 00 00 00       	jmp    80101b50 <namex+0x104>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101a92:	83 ec 0c             	sub    $0xc,%esp
80101a95:	57                   	push   %edi
80101a96:	e8 96 fc ff ff       	call   80101731 <iunlockput>
      return 0;
80101a9b:	83 c4 10             	add    $0x10,%esp
80101a9e:	bf 00 00 00 00       	mov    $0x0,%edi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101aa3:	89 f8                	mov    %edi,%eax
80101aa5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aa8:	5b                   	pop    %ebx
80101aa9:	5e                   	pop    %esi
80101aaa:	5f                   	pop    %edi
80101aab:	5d                   	pop    %ebp
80101aac:	c3                   	ret    
      iunlock(ip);
80101aad:	83 ec 0c             	sub    $0xc,%esp
80101ab0:	57                   	push   %edi
80101ab1:	e8 f4 fa ff ff       	call   801015aa <iunlock>
      return ip;
80101ab6:	83 c4 10             	add    $0x10,%esp
80101ab9:	eb e8                	jmp    80101aa3 <namex+0x57>
      iunlockput(ip);
80101abb:	83 ec 0c             	sub    $0xc,%esp
80101abe:	57                   	push   %edi
80101abf:	e8 6d fc ff ff       	call   80101731 <iunlockput>
      return 0;
80101ac4:	83 c4 10             	add    $0x10,%esp
80101ac7:	89 f7                	mov    %esi,%edi
80101ac9:	eb d8                	jmp    80101aa3 <namex+0x57>
  while(*path != '/' && *path != 0)
80101acb:	89 f3                	mov    %esi,%ebx
  len = path - s;
80101acd:	89 d8                	mov    %ebx,%eax
80101acf:	29 f0                	sub    %esi,%eax
80101ad1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(len >= DIRSIZ)
80101ad4:	83 f8 0d             	cmp    $0xd,%eax
80101ad7:	0f 8e b4 00 00 00    	jle    80101b91 <namex+0x145>
    memmove(name, s, DIRSIZ);
80101add:	83 ec 04             	sub    $0x4,%esp
80101ae0:	6a 0e                	push   $0xe
80101ae2:	56                   	push   %esi
80101ae3:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ae6:	e8 0a 24 00 00       	call   80103ef5 <memmove>
80101aeb:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101aee:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101af1:	75 08                	jne    80101afb <namex+0xaf>
    path++;
80101af3:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101af6:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101af9:	74 f8                	je     80101af3 <namex+0xa7>
  while((path = skipelem(path, name)) != 0){
80101afb:	85 db                	test   %ebx,%ebx
80101afd:	0f 84 ad 00 00 00    	je     80101bb0 <namex+0x164>
    ilock(ip);
80101b03:	83 ec 0c             	sub    $0xc,%esp
80101b06:	57                   	push   %edi
80101b07:	e8 dc f9 ff ff       	call   801014e8 <ilock>
    if(ip->type != T_DIR){
80101b0c:	83 c4 10             	add    $0x10,%esp
80101b0f:	66 83 7f 50 01       	cmpw   $0x1,0x50(%edi)
80101b14:	0f 85 78 ff ff ff    	jne    80101a92 <namex+0x46>
    if(nameiparent && *path == '\0'){
80101b1a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101b1e:	74 05                	je     80101b25 <namex+0xd9>
80101b20:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b23:	74 88                	je     80101aad <namex+0x61>
    if((next = dirlookup(ip, name, 0)) == 0){
80101b25:	83 ec 04             	sub    $0x4,%esp
80101b28:	6a 00                	push   $0x0
80101b2a:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b2d:	57                   	push   %edi
80101b2e:	e8 7b fe ff ff       	call   801019ae <dirlookup>
80101b33:	89 c6                	mov    %eax,%esi
80101b35:	83 c4 10             	add    $0x10,%esp
80101b38:	85 c0                	test   %eax,%eax
80101b3a:	0f 84 7b ff ff ff    	je     80101abb <namex+0x6f>
    iunlockput(ip);
80101b40:	83 ec 0c             	sub    $0xc,%esp
80101b43:	57                   	push   %edi
80101b44:	e8 e8 fb ff ff       	call   80101731 <iunlockput>
    ip = next;
80101b49:	83 c4 10             	add    $0x10,%esp
80101b4c:	89 f7                	mov    %esi,%edi
80101b4e:	89 de                	mov    %ebx,%esi
  while(*path == '/')
80101b50:	0f b6 06             	movzbl (%esi),%eax
80101b53:	3c 2f                	cmp    $0x2f,%al
80101b55:	75 0a                	jne    80101b61 <namex+0x115>
    path++;
80101b57:	83 c6 01             	add    $0x1,%esi
  while(*path == '/')
80101b5a:	0f b6 06             	movzbl (%esi),%eax
80101b5d:	3c 2f                	cmp    $0x2f,%al
80101b5f:	74 f6                	je     80101b57 <namex+0x10b>
  if(*path == 0)
80101b61:	84 c0                	test   %al,%al
80101b63:	74 4b                	je     80101bb0 <namex+0x164>
  while(*path != '/' && *path != 0)
80101b65:	0f b6 06             	movzbl (%esi),%eax
80101b68:	3c 2f                	cmp    $0x2f,%al
80101b6a:	0f 84 5b ff ff ff    	je     80101acb <namex+0x7f>
80101b70:	84 c0                	test   %al,%al
80101b72:	0f 84 53 ff ff ff    	je     80101acb <namex+0x7f>
80101b78:	89 f3                	mov    %esi,%ebx
    path++;
80101b7a:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101b7d:	0f b6 03             	movzbl (%ebx),%eax
80101b80:	3c 2f                	cmp    $0x2f,%al
80101b82:	0f 84 45 ff ff ff    	je     80101acd <namex+0x81>
80101b88:	84 c0                	test   %al,%al
80101b8a:	75 ee                	jne    80101b7a <namex+0x12e>
80101b8c:	e9 3c ff ff ff       	jmp    80101acd <namex+0x81>
    memmove(name, s, len);
80101b91:	83 ec 04             	sub    $0x4,%esp
80101b94:	ff 75 e0             	pushl  -0x20(%ebp)
80101b97:	56                   	push   %esi
80101b98:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b9b:	56                   	push   %esi
80101b9c:	e8 54 23 00 00       	call   80103ef5 <memmove>
    name[len] = 0;
80101ba1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ba4:	c6 04 0e 00          	movb   $0x0,(%esi,%ecx,1)
80101ba8:	83 c4 10             	add    $0x10,%esp
80101bab:	e9 3e ff ff ff       	jmp    80101aee <namex+0xa2>
  if(nameiparent){
80101bb0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80101bb4:	0f 84 e9 fe ff ff    	je     80101aa3 <namex+0x57>
    iput(ip);
80101bba:	83 ec 0c             	sub    $0xc,%esp
80101bbd:	57                   	push   %edi
80101bbe:	e8 2c fa ff ff       	call   801015ef <iput>
    return 0;
80101bc3:	83 c4 10             	add    $0x10,%esp
80101bc6:	bf 00 00 00 00       	mov    $0x0,%edi
80101bcb:	e9 d3 fe ff ff       	jmp    80101aa3 <namex+0x57>

80101bd0 <dirlink>:
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 20             	sub    $0x20,%esp
80101bd9:	8b 75 08             	mov    0x8(%ebp),%esi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101bdc:	6a 00                	push   $0x0
80101bde:	ff 75 0c             	pushl  0xc(%ebp)
80101be1:	56                   	push   %esi
80101be2:	e8 c7 fd ff ff       	call   801019ae <dirlookup>
80101be7:	83 c4 10             	add    $0x10,%esp
80101bea:	85 c0                	test   %eax,%eax
80101bec:	75 6a                	jne    80101c58 <dirlink+0x88>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101bee:	8b 5e 58             	mov    0x58(%esi),%ebx
80101bf1:	85 db                	test   %ebx,%ebx
80101bf3:	74 29                	je     80101c1e <dirlink+0x4e>
80101bf5:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bfa:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101bfd:	6a 10                	push   $0x10
80101bff:	53                   	push   %ebx
80101c00:	57                   	push   %edi
80101c01:	56                   	push   %esi
80101c02:	e8 75 fb ff ff       	call   8010177c <readi>
80101c07:	83 c4 10             	add    $0x10,%esp
80101c0a:	83 f8 10             	cmp    $0x10,%eax
80101c0d:	75 5c                	jne    80101c6b <dirlink+0x9b>
    if(de.inum == 0)
80101c0f:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c14:	74 08                	je     80101c1e <dirlink+0x4e>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c16:	83 c3 10             	add    $0x10,%ebx
80101c19:	3b 5e 58             	cmp    0x58(%esi),%ebx
80101c1c:	72 df                	jb     80101bfd <dirlink+0x2d>
  strncpy(de.name, name, DIRSIZ);
80101c1e:	83 ec 04             	sub    $0x4,%esp
80101c21:	6a 0e                	push   $0xe
80101c23:	ff 75 0c             	pushl  0xc(%ebp)
80101c26:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c29:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c2c:	50                   	push   %eax
80101c2d:	e8 6e 23 00 00       	call   80103fa0 <strncpy>
  de.inum = inum;
80101c32:	8b 45 10             	mov    0x10(%ebp),%eax
80101c35:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c39:	6a 10                	push   $0x10
80101c3b:	53                   	push   %ebx
80101c3c:	57                   	push   %edi
80101c3d:	56                   	push   %esi
80101c3e:	e8 35 fc ff ff       	call   80101878 <writei>
80101c43:	83 c4 20             	add    $0x20,%esp
80101c46:	83 f8 10             	cmp    $0x10,%eax
80101c49:	75 2d                	jne    80101c78 <dirlink+0xa8>
  return 0;
80101c4b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c53:	5b                   	pop    %ebx
80101c54:	5e                   	pop    %esi
80101c55:	5f                   	pop    %edi
80101c56:	5d                   	pop    %ebp
80101c57:	c3                   	ret    
    iput(ip);
80101c58:	83 ec 0c             	sub    $0xc,%esp
80101c5b:	50                   	push   %eax
80101c5c:	e8 8e f9 ff ff       	call   801015ef <iput>
    return -1;
80101c61:	83 c4 10             	add    $0x10,%esp
80101c64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c69:	eb e5                	jmp    80101c50 <dirlink+0x80>
      panic("dirlink read");
80101c6b:	83 ec 0c             	sub    $0xc,%esp
80101c6e:	68 fc 66 10 80       	push   $0x801066fc
80101c73:	e8 cc e6 ff ff       	call   80100344 <panic>
    panic("dirlink");
80101c78:	83 ec 0c             	sub    $0xc,%esp
80101c7b:	68 26 6d 10 80       	push   $0x80106d26
80101c80:	e8 bf e6 ff ff       	call   80100344 <panic>

80101c85 <namei>:

struct inode*
namei(char *path)
{
80101c85:	55                   	push   %ebp
80101c86:	89 e5                	mov    %esp,%ebp
80101c88:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c8b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c8e:	ba 00 00 00 00       	mov    $0x0,%edx
80101c93:	8b 45 08             	mov    0x8(%ebp),%eax
80101c96:	e8 b1 fd ff ff       	call   80101a4c <namex>
}
80101c9b:	c9                   	leave  
80101c9c:	c3                   	ret    

80101c9d <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101c9d:	55                   	push   %ebp
80101c9e:	89 e5                	mov    %esp,%ebp
80101ca0:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101ca3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101ca6:	ba 01 00 00 00       	mov    $0x1,%edx
80101cab:	8b 45 08             	mov    0x8(%ebp),%eax
80101cae:	e8 99 fd ff ff       	call   80101a4c <namex>
}
80101cb3:	c9                   	leave  
80101cb4:	c3                   	ret    

80101cb5 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101cb5:	55                   	push   %ebp
80101cb6:	89 e5                	mov    %esp,%ebp
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
  if(b == 0)
80101cba:	85 c0                	test   %eax,%eax
80101cbc:	0f 84 84 00 00 00    	je     80101d46 <idestart+0x91>
80101cc2:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101cc4:	8b 58 08             	mov    0x8(%eax),%ebx
80101cc7:	81 fb cf 07 00 00    	cmp    $0x7cf,%ebx
80101ccd:	0f 87 80 00 00 00    	ja     80101d53 <idestart+0x9e>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101cd3:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cd8:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101cd9:	83 e0 c0             	and    $0xffffffc0,%eax
80101cdc:	3c 40                	cmp    $0x40,%al
80101cde:	75 f8                	jne    80101cd8 <idestart+0x23>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ce0:	b8 00 00 00 00       	mov    $0x0,%eax
80101ce5:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101cea:	ee                   	out    %al,(%dx)
80101ceb:	b8 01 00 00 00       	mov    $0x1,%eax
80101cf0:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101cf5:	ee                   	out    %al,(%dx)
80101cf6:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101cfb:	89 d8                	mov    %ebx,%eax
80101cfd:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101cfe:	89 d8                	mov    %ebx,%eax
80101d00:	c1 f8 08             	sar    $0x8,%eax
80101d03:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d08:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101d09:	89 d8                	mov    %ebx,%eax
80101d0b:	c1 f8 10             	sar    $0x10,%eax
80101d0e:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101d13:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101d14:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101d18:	c1 e0 04             	shl    $0x4,%eax
80101d1b:	83 e0 10             	and    $0x10,%eax
80101d1e:	83 c8 e0             	or     $0xffffffe0,%eax
80101d21:	c1 fb 18             	sar    $0x18,%ebx
80101d24:	83 e3 0f             	and    $0xf,%ebx
80101d27:	09 d8                	or     %ebx,%eax
80101d29:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d2e:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101d2f:	f6 06 04             	testb  $0x4,(%esi)
80101d32:	75 2c                	jne    80101d60 <idestart+0xab>
80101d34:	b8 20 00 00 00       	mov    $0x20,%eax
80101d39:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d3e:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5d                   	pop    %ebp
80101d45:	c3                   	ret    
    panic("idestart");
80101d46:	83 ec 0c             	sub    $0xc,%esp
80101d49:	68 5f 67 10 80       	push   $0x8010675f
80101d4e:	e8 f1 e5 ff ff       	call   80100344 <panic>
    panic("incorrect blockno");
80101d53:	83 ec 0c             	sub    $0xc,%esp
80101d56:	68 68 67 10 80       	push   $0x80106768
80101d5b:	e8 e4 e5 ff ff       	call   80100344 <panic>
80101d60:	b8 30 00 00 00       	mov    $0x30,%eax
80101d65:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d6a:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
80101d6b:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101d6e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d73:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d78:	fc                   	cld    
80101d79:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80101d7b:	eb c2                	jmp    80101d3f <idestart+0x8a>

80101d7d <ideinit>:
{
80101d7d:	55                   	push   %ebp
80101d7e:	89 e5                	mov    %esp,%ebp
80101d80:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101d83:	68 7a 67 10 80       	push   $0x8010677a
80101d88:	68 80 95 10 80       	push   $0x80109580
80101d8d:	e8 d8 1e 00 00       	call   80103c6a <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d92:	83 c4 08             	add    $0x8,%esp
80101d95:	a1 60 3d 11 80       	mov    0x80113d60,%eax
80101d9a:	83 e8 01             	sub    $0x1,%eax
80101d9d:	50                   	push   %eax
80101d9e:	6a 0e                	push   $0xe
80101da0:	e8 63 02 00 00       	call   80102008 <ioapicenable>
80101da5:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101da8:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101dad:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101dae:	83 e0 c0             	and    $0xffffffc0,%eax
80101db1:	3c 40                	cmp    $0x40,%al
80101db3:	75 f8                	jne    80101dad <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101db5:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101dba:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101dbf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101dc0:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101dc5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101dc6:	84 c0                	test   %al,%al
80101dc8:	75 11                	jne    80101ddb <ideinit+0x5e>
80101dca:	b9 e7 03 00 00       	mov    $0x3e7,%ecx
80101dcf:	ec                   	in     (%dx),%al
80101dd0:	84 c0                	test   %al,%al
80101dd2:	75 07                	jne    80101ddb <ideinit+0x5e>
  for(i=0; i<1000; i++){
80101dd4:	83 e9 01             	sub    $0x1,%ecx
80101dd7:	75 f6                	jne    80101dcf <ideinit+0x52>
80101dd9:	eb 0a                	jmp    80101de5 <ideinit+0x68>
      havedisk1 = 1;
80101ddb:	c7 05 60 95 10 80 01 	movl   $0x1,0x80109560
80101de2:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101de5:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101dea:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101def:	ee                   	out    %al,(%dx)
}
80101df0:	c9                   	leave  
80101df1:	c3                   	ret    

80101df2 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101df2:	55                   	push   %ebp
80101df3:	89 e5                	mov    %esp,%ebp
80101df5:	57                   	push   %edi
80101df6:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101df7:	83 ec 0c             	sub    $0xc,%esp
80101dfa:	68 80 95 10 80       	push   $0x80109580
80101dff:	e8 ae 1f 00 00       	call   80103db2 <acquire>

  if((b = idequeue) == 0){
80101e04:	8b 1d 64 95 10 80    	mov    0x80109564,%ebx
80101e0a:	83 c4 10             	add    $0x10,%esp
80101e0d:	85 db                	test   %ebx,%ebx
80101e0f:	74 48                	je     80101e59 <ideintr+0x67>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101e11:	8b 43 58             	mov    0x58(%ebx),%eax
80101e14:	a3 64 95 10 80       	mov    %eax,0x80109564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e19:	f6 03 04             	testb  $0x4,(%ebx)
80101e1c:	74 4d                	je     80101e6b <ideintr+0x79>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80101e1e:	8b 03                	mov    (%ebx),%eax
80101e20:	83 e0 fb             	and    $0xfffffffb,%eax
80101e23:	83 c8 02             	or     $0x2,%eax
80101e26:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101e28:	83 ec 0c             	sub    $0xc,%esp
80101e2b:	53                   	push   %ebx
80101e2c:	e8 6b 1b 00 00       	call   8010399c <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101e31:	a1 64 95 10 80       	mov    0x80109564,%eax
80101e36:	83 c4 10             	add    $0x10,%esp
80101e39:	85 c0                	test   %eax,%eax
80101e3b:	74 05                	je     80101e42 <ideintr+0x50>
    idestart(idequeue);
80101e3d:	e8 73 fe ff ff       	call   80101cb5 <idestart>

  release(&idelock);
80101e42:	83 ec 0c             	sub    $0xc,%esp
80101e45:	68 80 95 10 80       	push   $0x80109580
80101e4a:	e8 ca 1f 00 00       	call   80103e19 <release>
80101e4f:	83 c4 10             	add    $0x10,%esp
}
80101e52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e55:	5b                   	pop    %ebx
80101e56:	5f                   	pop    %edi
80101e57:	5d                   	pop    %ebp
80101e58:	c3                   	ret    
    release(&idelock);
80101e59:	83 ec 0c             	sub    $0xc,%esp
80101e5c:	68 80 95 10 80       	push   $0x80109580
80101e61:	e8 b3 1f 00 00       	call   80103e19 <release>
    return;
80101e66:	83 c4 10             	add    $0x10,%esp
80101e69:	eb e7                	jmp    80101e52 <ideintr+0x60>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e6b:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e70:	ec                   	in     (%dx),%al
80101e71:	89 c1                	mov    %eax,%ecx
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101e73:	83 e0 c0             	and    $0xffffffc0,%eax
80101e76:	3c 40                	cmp    $0x40,%al
80101e78:	75 f6                	jne    80101e70 <ideintr+0x7e>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e7a:	f6 c1 21             	test   $0x21,%cl
80101e7d:	75 9f                	jne    80101e1e <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101e7f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101e82:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e87:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e8c:	fc                   	cld    
80101e8d:	f3 6d                	rep insl (%dx),%es:(%edi)
80101e8f:	eb 8d                	jmp    80101e1e <ideintr+0x2c>

80101e91 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e91:	55                   	push   %ebp
80101e92:	89 e5                	mov    %esp,%ebp
80101e94:	53                   	push   %ebx
80101e95:	83 ec 10             	sub    $0x10,%esp
80101e98:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e9b:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e9e:	50                   	push   %eax
80101e9f:	e8 9f 1d 00 00       	call   80103c43 <holdingsleep>
80101ea4:	83 c4 10             	add    $0x10,%esp
80101ea7:	85 c0                	test   %eax,%eax
80101ea9:	74 41                	je     80101eec <iderw+0x5b>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101eab:	8b 03                	mov    (%ebx),%eax
80101ead:	83 e0 06             	and    $0x6,%eax
80101eb0:	83 f8 02             	cmp    $0x2,%eax
80101eb3:	74 44                	je     80101ef9 <iderw+0x68>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101eb5:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101eb9:	74 09                	je     80101ec4 <iderw+0x33>
80101ebb:	83 3d 60 95 10 80 00 	cmpl   $0x0,0x80109560
80101ec2:	74 42                	je     80101f06 <iderw+0x75>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101ec4:	83 ec 0c             	sub    $0xc,%esp
80101ec7:	68 80 95 10 80       	push   $0x80109580
80101ecc:	e8 e1 1e 00 00       	call   80103db2 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101ed1:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101ed8:	8b 15 64 95 10 80    	mov    0x80109564,%edx
80101ede:	83 c4 10             	add    $0x10,%esp
80101ee1:	85 d2                	test   %edx,%edx
80101ee3:	75 30                	jne    80101f15 <iderw+0x84>
80101ee5:	ba 64 95 10 80       	mov    $0x80109564,%edx
80101eea:	eb 33                	jmp    80101f1f <iderw+0x8e>
    panic("iderw: buf not locked");
80101eec:	83 ec 0c             	sub    $0xc,%esp
80101eef:	68 7e 67 10 80       	push   $0x8010677e
80101ef4:	e8 4b e4 ff ff       	call   80100344 <panic>
    panic("iderw: nothing to do");
80101ef9:	83 ec 0c             	sub    $0xc,%esp
80101efc:	68 94 67 10 80       	push   $0x80106794
80101f01:	e8 3e e4 ff ff       	call   80100344 <panic>
    panic("iderw: ide disk 1 not present");
80101f06:	83 ec 0c             	sub    $0xc,%esp
80101f09:	68 a9 67 10 80       	push   $0x801067a9
80101f0e:	e8 31 e4 ff ff       	call   80100344 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f13:	89 c2                	mov    %eax,%edx
80101f15:	8b 42 58             	mov    0x58(%edx),%eax
80101f18:	85 c0                	test   %eax,%eax
80101f1a:	75 f7                	jne    80101f13 <iderw+0x82>
80101f1c:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80101f1f:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101f21:	39 1d 64 95 10 80    	cmp    %ebx,0x80109564
80101f27:	74 3a                	je     80101f63 <iderw+0xd2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f29:	8b 03                	mov    (%ebx),%eax
80101f2b:	83 e0 06             	and    $0x6,%eax
80101f2e:	83 f8 02             	cmp    $0x2,%eax
80101f31:	74 1b                	je     80101f4e <iderw+0xbd>
    sleep(b, &idelock);
80101f33:	83 ec 08             	sub    $0x8,%esp
80101f36:	68 80 95 10 80       	push   $0x80109580
80101f3b:	53                   	push   %ebx
80101f3c:	e8 bf 18 00 00       	call   80103800 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f41:	8b 03                	mov    (%ebx),%eax
80101f43:	83 e0 06             	and    $0x6,%eax
80101f46:	83 c4 10             	add    $0x10,%esp
80101f49:	83 f8 02             	cmp    $0x2,%eax
80101f4c:	75 e5                	jne    80101f33 <iderw+0xa2>
  }


  release(&idelock);
80101f4e:	83 ec 0c             	sub    $0xc,%esp
80101f51:	68 80 95 10 80       	push   $0x80109580
80101f56:	e8 be 1e 00 00       	call   80103e19 <release>
}
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f61:	c9                   	leave  
80101f62:	c3                   	ret    
    idestart(b);
80101f63:	89 d8                	mov    %ebx,%eax
80101f65:	e8 4b fd ff ff       	call   80101cb5 <idestart>
80101f6a:	eb bd                	jmp    80101f29 <iderw+0x98>

80101f6c <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80101f6c:	55                   	push   %ebp
80101f6d:	89 e5                	mov    %esp,%ebp
80101f6f:	56                   	push   %esi
80101f70:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f71:	c7 05 94 36 11 80 00 	movl   $0xfec00000,0x80113694
80101f78:	00 c0 fe 
  ioapic->reg = reg;
80101f7b:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80101f82:	00 00 00 
  return ioapic->data;
80101f85:	a1 94 36 11 80       	mov    0x80113694,%eax
80101f8a:	8b 58 10             	mov    0x10(%eax),%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f8d:	c1 eb 10             	shr    $0x10,%ebx
80101f90:	0f b6 db             	movzbl %bl,%ebx
  ioapic->reg = reg;
80101f93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
80101f99:	a1 94 36 11 80       	mov    0x80113694,%eax
80101f9e:	8b 40 10             	mov    0x10(%eax),%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80101fa1:	0f b6 15 c0 37 11 80 	movzbl 0x801137c0,%edx
  id = ioapicread(REG_ID) >> 24;
80101fa8:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101fab:	39 c2                	cmp    %eax,%edx
80101fad:	75 47                	jne    80101ff6 <ioapicinit+0x8a>
{
80101faf:	ba 10 00 00 00       	mov    $0x10,%edx
80101fb4:	b8 00 00 00 00       	mov    $0x0,%eax
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101fb9:	8d 48 20             	lea    0x20(%eax),%ecx
80101fbc:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->reg = reg;
80101fc2:	8b 35 94 36 11 80    	mov    0x80113694,%esi
80101fc8:	89 16                	mov    %edx,(%esi)
  ioapic->data = data;
80101fca:	8b 35 94 36 11 80    	mov    0x80113694,%esi
80101fd0:	89 4e 10             	mov    %ecx,0x10(%esi)
80101fd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  ioapic->reg = reg;
80101fd6:	89 0e                	mov    %ecx,(%esi)
  ioapic->data = data;
80101fd8:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx
80101fde:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80101fe5:	83 c0 01             	add    $0x1,%eax
80101fe8:	83 c2 02             	add    $0x2,%edx
80101feb:	39 c3                	cmp    %eax,%ebx
80101fed:	7d ca                	jge    80101fb9 <ioapicinit+0x4d>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80101fef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ff2:	5b                   	pop    %ebx
80101ff3:	5e                   	pop    %esi
80101ff4:	5d                   	pop    %ebp
80101ff5:	c3                   	ret    
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101ff6:	83 ec 0c             	sub    $0xc,%esp
80101ff9:	68 c8 67 10 80       	push   $0x801067c8
80101ffe:	e8 de e5 ff ff       	call   801005e1 <cprintf>
80102003:	83 c4 10             	add    $0x10,%esp
80102006:	eb a7                	jmp    80101faf <ioapicinit+0x43>

80102008 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102008:	55                   	push   %ebp
80102009:	89 e5                	mov    %esp,%ebp
8010200b:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010200e:	8d 50 20             	lea    0x20(%eax),%edx
80102011:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102015:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx
8010201b:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010201d:	8b 0d 94 36 11 80    	mov    0x80113694,%ecx
80102023:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102026:	8b 55 0c             	mov    0xc(%ebp),%edx
80102029:	c1 e2 18             	shl    $0x18,%edx
8010202c:	83 c0 01             	add    $0x1,%eax
  ioapic->reg = reg;
8010202f:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102031:	a1 94 36 11 80       	mov    0x80113694,%eax
80102036:	89 50 10             	mov    %edx,0x10(%eax)
}
80102039:	5d                   	pop    %ebp
8010203a:	c3                   	ret    

8010203b <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
8010203b:	55                   	push   %ebp
8010203c:	89 e5                	mov    %esp,%ebp
8010203e:	53                   	push   %ebx
8010203f:	83 ec 04             	sub    $0x4,%esp
80102042:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102045:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
8010204b:	75 4c                	jne    80102099 <kfree+0x5e>
8010204d:	81 fb 88 45 11 80    	cmp    $0x80114588,%ebx
80102053:	72 44                	jb     80102099 <kfree+0x5e>
80102055:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010205b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102060:	77 37                	ja     80102099 <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102062:	83 ec 04             	sub    $0x4,%esp
80102065:	68 00 10 00 00       	push   $0x1000
8010206a:	6a 01                	push   $0x1
8010206c:	53                   	push   %ebx
8010206d:	e8 ee 1d 00 00       	call   80103e60 <memset>

  if(kmem.use_lock)
80102072:	83 c4 10             	add    $0x10,%esp
80102075:	83 3d d4 36 11 80 00 	cmpl   $0x0,0x801136d4
8010207c:	75 28                	jne    801020a6 <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
8010207e:	a1 d8 36 11 80       	mov    0x801136d8,%eax
80102083:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102085:	89 1d d8 36 11 80    	mov    %ebx,0x801136d8
  if(kmem.use_lock)
8010208b:	83 3d d4 36 11 80 00 	cmpl   $0x0,0x801136d4
80102092:	75 24                	jne    801020b8 <kfree+0x7d>
    release(&kmem.lock);
}
80102094:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102097:	c9                   	leave  
80102098:	c3                   	ret    
    panic("kfree");
80102099:	83 ec 0c             	sub    $0xc,%esp
8010209c:	68 fa 67 10 80       	push   $0x801067fa
801020a1:	e8 9e e2 ff ff       	call   80100344 <panic>
    acquire(&kmem.lock);
801020a6:	83 ec 0c             	sub    $0xc,%esp
801020a9:	68 a0 36 11 80       	push   $0x801136a0
801020ae:	e8 ff 1c 00 00       	call   80103db2 <acquire>
801020b3:	83 c4 10             	add    $0x10,%esp
801020b6:	eb c6                	jmp    8010207e <kfree+0x43>
    release(&kmem.lock);
801020b8:	83 ec 0c             	sub    $0xc,%esp
801020bb:	68 a0 36 11 80       	push   $0x801136a0
801020c0:	e8 54 1d 00 00       	call   80103e19 <release>
801020c5:	83 c4 10             	add    $0x10,%esp
}
801020c8:	eb ca                	jmp    80102094 <kfree+0x59>

801020ca <freerange>:
{
801020ca:	55                   	push   %ebp
801020cb:	89 e5                	mov    %esp,%ebp
801020cd:	56                   	push   %esi
801020ce:	53                   	push   %ebx
801020cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801020d2:	8b 45 08             	mov    0x8(%ebp),%eax
801020d5:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801020db:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801020e7:	39 de                	cmp    %ebx,%esi
801020e9:	72 1c                	jb     80102107 <freerange+0x3d>
    kfree(p);
801020eb:	83 ec 0c             	sub    $0xc,%esp
801020ee:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801020f4:	50                   	push   %eax
801020f5:	e8 41 ff ff ff       	call   8010203b <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102100:	83 c4 10             	add    $0x10,%esp
80102103:	39 f3                	cmp    %esi,%ebx
80102105:	76 e4                	jbe    801020eb <freerange+0x21>
}
80102107:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010210a:	5b                   	pop    %ebx
8010210b:	5e                   	pop    %esi
8010210c:	5d                   	pop    %ebp
8010210d:	c3                   	ret    

8010210e <kinit1>:
{
8010210e:	55                   	push   %ebp
8010210f:	89 e5                	mov    %esp,%ebp
80102111:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80102114:	68 00 68 10 80       	push   $0x80106800
80102119:	68 a0 36 11 80       	push   $0x801136a0
8010211e:	e8 47 1b 00 00       	call   80103c6a <initlock>
  kmem.use_lock = 0;
80102123:	c7 05 d4 36 11 80 00 	movl   $0x0,0x801136d4
8010212a:	00 00 00 
  freerange(vstart, vend);
8010212d:	83 c4 08             	add    $0x8,%esp
80102130:	ff 75 0c             	pushl  0xc(%ebp)
80102133:	ff 75 08             	pushl  0x8(%ebp)
80102136:	e8 8f ff ff ff       	call   801020ca <freerange>
}
8010213b:	83 c4 10             	add    $0x10,%esp
8010213e:	c9                   	leave  
8010213f:	c3                   	ret    

80102140 <kinit2>:
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
80102146:	ff 75 0c             	pushl  0xc(%ebp)
80102149:	ff 75 08             	pushl  0x8(%ebp)
8010214c:	e8 79 ff ff ff       	call   801020ca <freerange>
  kmem.use_lock = 1;
80102151:	c7 05 d4 36 11 80 01 	movl   $0x1,0x801136d4
80102158:	00 00 00 
}
8010215b:	83 c4 10             	add    $0x10,%esp
8010215e:	c9                   	leave  
8010215f:	c3                   	ret    

80102160 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102160:	55                   	push   %ebp
80102161:	89 e5                	mov    %esp,%ebp
80102163:	53                   	push   %ebx
80102164:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102167:	83 3d d4 36 11 80 00 	cmpl   $0x0,0x801136d4
8010216e:	75 21                	jne    80102191 <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102170:	8b 1d d8 36 11 80    	mov    0x801136d8,%ebx
  if(r)
80102176:	85 db                	test   %ebx,%ebx
80102178:	74 10                	je     8010218a <kalloc+0x2a>
    kmem.freelist = r->next;
8010217a:	8b 03                	mov    (%ebx),%eax
8010217c:	a3 d8 36 11 80       	mov    %eax,0x801136d8
  if(kmem.use_lock)
80102181:	83 3d d4 36 11 80 00 	cmpl   $0x0,0x801136d4
80102188:	75 23                	jne    801021ad <kalloc+0x4d>
    release(&kmem.lock);
  return (char*)r;
}
8010218a:	89 d8                	mov    %ebx,%eax
8010218c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010218f:	c9                   	leave  
80102190:	c3                   	ret    
    acquire(&kmem.lock);
80102191:	83 ec 0c             	sub    $0xc,%esp
80102194:	68 a0 36 11 80       	push   $0x801136a0
80102199:	e8 14 1c 00 00       	call   80103db2 <acquire>
  r = kmem.freelist;
8010219e:	8b 1d d8 36 11 80    	mov    0x801136d8,%ebx
  if(r)
801021a4:	83 c4 10             	add    $0x10,%esp
801021a7:	85 db                	test   %ebx,%ebx
801021a9:	75 cf                	jne    8010217a <kalloc+0x1a>
801021ab:	eb d4                	jmp    80102181 <kalloc+0x21>
    release(&kmem.lock);
801021ad:	83 ec 0c             	sub    $0xc,%esp
801021b0:	68 a0 36 11 80       	push   $0x801136a0
801021b5:	e8 5f 1c 00 00       	call   80103e19 <release>
801021ba:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801021bd:	eb cb                	jmp    8010218a <kalloc+0x2a>

801021bf <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021bf:	ba 64 00 00 00       	mov    $0x64,%edx
801021c4:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801021c5:	a8 01                	test   $0x1,%al
801021c7:	0f 84 bb 00 00 00    	je     80102288 <kbdgetc+0xc9>
801021cd:	ba 60 00 00 00       	mov    $0x60,%edx
801021d2:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801021d3:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801021d6:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801021dc:	74 5b                	je     80102239 <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801021de:	84 c0                	test   %al,%al
801021e0:	78 64                	js     80102246 <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801021e2:	8b 0d b4 95 10 80    	mov    0x801095b4,%ecx
801021e8:	f6 c1 40             	test   $0x40,%cl
801021eb:	74 0f                	je     801021fc <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801021ed:	83 c8 80             	or     $0xffffff80,%eax
801021f0:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
801021f3:	83 e1 bf             	and    $0xffffffbf,%ecx
801021f6:	89 0d b4 95 10 80    	mov    %ecx,0x801095b4
  }

  shift |= shiftcode[data];
801021fc:	0f b6 8a 40 69 10 80 	movzbl -0x7fef96c0(%edx),%ecx
80102203:	0b 0d b4 95 10 80    	or     0x801095b4,%ecx
  shift ^= togglecode[data];
80102209:	0f b6 82 40 68 10 80 	movzbl -0x7fef97c0(%edx),%eax
80102210:	31 c1                	xor    %eax,%ecx
80102212:	89 0d b4 95 10 80    	mov    %ecx,0x801095b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102218:	89 c8                	mov    %ecx,%eax
8010221a:	83 e0 03             	and    $0x3,%eax
8010221d:	8b 04 85 20 68 10 80 	mov    -0x7fef97e0(,%eax,4),%eax
80102224:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102228:	f6 c1 08             	test   $0x8,%cl
8010222b:	74 61                	je     8010228e <kbdgetc+0xcf>
    if('a' <= c && c <= 'z')
8010222d:	8d 50 9f             	lea    -0x61(%eax),%edx
80102230:	83 fa 19             	cmp    $0x19,%edx
80102233:	77 46                	ja     8010227b <kbdgetc+0xbc>
      c += 'A' - 'a';
80102235:	83 e8 20             	sub    $0x20,%eax
80102238:	c3                   	ret    
    shift |= E0ESC;
80102239:	83 0d b4 95 10 80 40 	orl    $0x40,0x801095b4
    return 0;
80102240:	b8 00 00 00 00       	mov    $0x0,%eax
80102245:	c3                   	ret    
{
80102246:	55                   	push   %ebp
80102247:	89 e5                	mov    %esp,%ebp
80102249:	53                   	push   %ebx
    data = (shift & E0ESC ? data : data & 0x7F);
8010224a:	8b 0d b4 95 10 80    	mov    0x801095b4,%ecx
80102250:	89 cb                	mov    %ecx,%ebx
80102252:	83 e3 40             	and    $0x40,%ebx
80102255:	83 e0 7f             	and    $0x7f,%eax
80102258:	85 db                	test   %ebx,%ebx
8010225a:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
8010225d:	0f b6 82 40 69 10 80 	movzbl -0x7fef96c0(%edx),%eax
80102264:	83 c8 40             	or     $0x40,%eax
80102267:	0f b6 c0             	movzbl %al,%eax
8010226a:	f7 d0                	not    %eax
8010226c:	21 c8                	and    %ecx,%eax
8010226e:	a3 b4 95 10 80       	mov    %eax,0x801095b4
    return 0;
80102273:	b8 00 00 00 00       	mov    $0x0,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102278:	5b                   	pop    %ebx
80102279:	5d                   	pop    %ebp
8010227a:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
8010227b:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010227e:	8d 50 20             	lea    0x20(%eax),%edx
80102281:	83 f9 1a             	cmp    $0x1a,%ecx
80102284:	0f 42 c2             	cmovb  %edx,%eax
  return c;
80102287:	c3                   	ret    
    return -1;
80102288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010228d:	c3                   	ret    
}
8010228e:	f3 c3                	repz ret 

80102290 <kbdintr>:

void
kbdintr(void)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102296:	68 bf 21 10 80       	push   $0x801021bf
8010229b:	e8 9b e4 ff ff       	call   8010073b <consoleintr>
}
801022a0:	83 c4 10             	add    $0x10,%esp
801022a3:	c9                   	leave  
801022a4:	c3                   	ret    

801022a5 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
801022a5:	55                   	push   %ebp
801022a6:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801022a8:	8b 0d dc 36 11 80    	mov    0x801136dc,%ecx
801022ae:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801022b1:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
801022b3:	a1 dc 36 11 80       	mov    0x801136dc,%eax
801022b8:	8b 40 20             	mov    0x20(%eax),%eax
}
801022bb:	5d                   	pop    %ebp
801022bc:	c3                   	ret    

801022bd <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
801022bd:	55                   	push   %ebp
801022be:	89 e5                	mov    %esp,%ebp
801022c0:	56                   	push   %esi
801022c1:	53                   	push   %ebx
801022c2:	89 c3                	mov    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022c4:	be 70 00 00 00       	mov    $0x70,%esi
801022c9:	b8 00 00 00 00       	mov    $0x0,%eax
801022ce:	89 f2                	mov    %esi,%edx
801022d0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d1:	b9 71 00 00 00       	mov    $0x71,%ecx
801022d6:	89 ca                	mov    %ecx,%edx
801022d8:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
801022d9:	0f b6 c0             	movzbl %al,%eax
801022dc:	89 03                	mov    %eax,(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022de:	b8 02 00 00 00       	mov    $0x2,%eax
801022e3:	89 f2                	mov    %esi,%edx
801022e5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e6:	89 ca                	mov    %ecx,%edx
801022e8:	ec                   	in     (%dx),%al
801022e9:	0f b6 c0             	movzbl %al,%eax
801022ec:	89 43 04             	mov    %eax,0x4(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022ef:	b8 04 00 00 00       	mov    $0x4,%eax
801022f4:	89 f2                	mov    %esi,%edx
801022f6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022f7:	89 ca                	mov    %ecx,%edx
801022f9:	ec                   	in     (%dx),%al
801022fa:	0f b6 c0             	movzbl %al,%eax
801022fd:	89 43 08             	mov    %eax,0x8(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102300:	b8 07 00 00 00       	mov    $0x7,%eax
80102305:	89 f2                	mov    %esi,%edx
80102307:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102308:	89 ca                	mov    %ecx,%edx
8010230a:	ec                   	in     (%dx),%al
8010230b:	0f b6 c0             	movzbl %al,%eax
8010230e:	89 43 0c             	mov    %eax,0xc(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102311:	b8 08 00 00 00       	mov    $0x8,%eax
80102316:	89 f2                	mov    %esi,%edx
80102318:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102319:	89 ca                	mov    %ecx,%edx
8010231b:	ec                   	in     (%dx),%al
8010231c:	0f b6 c0             	movzbl %al,%eax
8010231f:	89 43 10             	mov    %eax,0x10(%ebx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102322:	b8 09 00 00 00       	mov    $0x9,%eax
80102327:	89 f2                	mov    %esi,%edx
80102329:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010232a:	89 ca                	mov    %ecx,%edx
8010232c:	ec                   	in     (%dx),%al
8010232d:	0f b6 c0             	movzbl %al,%eax
80102330:	89 43 14             	mov    %eax,0x14(%ebx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102333:	5b                   	pop    %ebx
80102334:	5e                   	pop    %esi
80102335:	5d                   	pop    %ebp
80102336:	c3                   	ret    

80102337 <lapicinit>:
  if(!lapic)
80102337:	83 3d dc 36 11 80 00 	cmpl   $0x0,0x801136dc
8010233e:	0f 84 fc 00 00 00    	je     80102440 <lapicinit+0x109>
{
80102344:	55                   	push   %ebp
80102345:	89 e5                	mov    %esp,%ebp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102347:	ba 3f 01 00 00       	mov    $0x13f,%edx
8010234c:	b8 3c 00 00 00       	mov    $0x3c,%eax
80102351:	e8 4f ff ff ff       	call   801022a5 <lapicw>
  lapicw(TDCR, X1);
80102356:	ba 0b 00 00 00       	mov    $0xb,%edx
8010235b:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102360:	e8 40 ff ff ff       	call   801022a5 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102365:	ba 20 00 02 00       	mov    $0x20020,%edx
8010236a:	b8 c8 00 00 00       	mov    $0xc8,%eax
8010236f:	e8 31 ff ff ff       	call   801022a5 <lapicw>
  lapicw(TICR, 1000000);
80102374:	ba 40 42 0f 00       	mov    $0xf4240,%edx
80102379:	b8 e0 00 00 00       	mov    $0xe0,%eax
8010237e:	e8 22 ff ff ff       	call   801022a5 <lapicw>
  lapicw(LINT0, MASKED);
80102383:	ba 00 00 01 00       	mov    $0x10000,%edx
80102388:	b8 d4 00 00 00       	mov    $0xd4,%eax
8010238d:	e8 13 ff ff ff       	call   801022a5 <lapicw>
  lapicw(LINT1, MASKED);
80102392:	ba 00 00 01 00       	mov    $0x10000,%edx
80102397:	b8 d8 00 00 00       	mov    $0xd8,%eax
8010239c:	e8 04 ff ff ff       	call   801022a5 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801023a1:	a1 dc 36 11 80       	mov    0x801136dc,%eax
801023a6:	8b 40 30             	mov    0x30(%eax),%eax
801023a9:	c1 e8 10             	shr    $0x10,%eax
801023ac:	3c 03                	cmp    $0x3,%al
801023ae:	77 7c                	ja     8010242c <lapicinit+0xf5>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
801023b0:	ba 33 00 00 00       	mov    $0x33,%edx
801023b5:	b8 dc 00 00 00       	mov    $0xdc,%eax
801023ba:	e8 e6 fe ff ff       	call   801022a5 <lapicw>
  lapicw(ESR, 0);
801023bf:	ba 00 00 00 00       	mov    $0x0,%edx
801023c4:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023c9:	e8 d7 fe ff ff       	call   801022a5 <lapicw>
  lapicw(ESR, 0);
801023ce:	ba 00 00 00 00       	mov    $0x0,%edx
801023d3:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023d8:	e8 c8 fe ff ff       	call   801022a5 <lapicw>
  lapicw(EOI, 0);
801023dd:	ba 00 00 00 00       	mov    $0x0,%edx
801023e2:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023e7:	e8 b9 fe ff ff       	call   801022a5 <lapicw>
  lapicw(ICRHI, 0);
801023ec:	ba 00 00 00 00       	mov    $0x0,%edx
801023f1:	b8 c4 00 00 00       	mov    $0xc4,%eax
801023f6:	e8 aa fe ff ff       	call   801022a5 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801023fb:	ba 00 85 08 00       	mov    $0x88500,%edx
80102400:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102405:	e8 9b fe ff ff       	call   801022a5 <lapicw>
  while(lapic[ICRLO] & DELIVS)
8010240a:	8b 15 dc 36 11 80    	mov    0x801136dc,%edx
80102410:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
80102416:	f6 c4 10             	test   $0x10,%ah
80102419:	75 f5                	jne    80102410 <lapicinit+0xd9>
  lapicw(TPR, 0);
8010241b:	ba 00 00 00 00       	mov    $0x0,%edx
80102420:	b8 20 00 00 00       	mov    $0x20,%eax
80102425:	e8 7b fe ff ff       	call   801022a5 <lapicw>
}
8010242a:	5d                   	pop    %ebp
8010242b:	c3                   	ret    
    lapicw(PCINT, MASKED);
8010242c:	ba 00 00 01 00       	mov    $0x10000,%edx
80102431:	b8 d0 00 00 00       	mov    $0xd0,%eax
80102436:	e8 6a fe ff ff       	call   801022a5 <lapicw>
8010243b:	e9 70 ff ff ff       	jmp    801023b0 <lapicinit+0x79>
80102440:	f3 c3                	repz ret 

80102442 <lapicid>:
{
80102442:	55                   	push   %ebp
80102443:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102445:	8b 15 dc 36 11 80    	mov    0x801136dc,%edx
    return 0;
8010244b:	b8 00 00 00 00       	mov    $0x0,%eax
  if (!lapic)
80102450:	85 d2                	test   %edx,%edx
80102452:	74 06                	je     8010245a <lapicid+0x18>
  return lapic[ID] >> 24;
80102454:	8b 42 20             	mov    0x20(%edx),%eax
80102457:	c1 e8 18             	shr    $0x18,%eax
}
8010245a:	5d                   	pop    %ebp
8010245b:	c3                   	ret    

8010245c <lapiceoi>:
  if(lapic)
8010245c:	83 3d dc 36 11 80 00 	cmpl   $0x0,0x801136dc
80102463:	74 14                	je     80102479 <lapiceoi+0x1d>
{
80102465:	55                   	push   %ebp
80102466:	89 e5                	mov    %esp,%ebp
    lapicw(EOI, 0);
80102468:	ba 00 00 00 00       	mov    $0x0,%edx
8010246d:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102472:	e8 2e fe ff ff       	call   801022a5 <lapicw>
}
80102477:	5d                   	pop    %ebp
80102478:	c3                   	ret    
80102479:	f3 c3                	repz ret 

8010247b <microdelay>:
{
8010247b:	55                   	push   %ebp
8010247c:	89 e5                	mov    %esp,%ebp
}
8010247e:	5d                   	pop    %ebp
8010247f:	c3                   	ret    

80102480 <lapicstartap>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
80102485:	8b 75 08             	mov    0x8(%ebp),%esi
80102488:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010248b:	b8 0f 00 00 00       	mov    $0xf,%eax
80102490:	ba 70 00 00 00       	mov    $0x70,%edx
80102495:	ee                   	out    %al,(%dx)
80102496:	b8 0a 00 00 00       	mov    $0xa,%eax
8010249b:	ba 71 00 00 00       	mov    $0x71,%edx
801024a0:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801024a1:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801024a8:	00 00 
  wrv[1] = addr >> 4;
801024aa:	89 d8                	mov    %ebx,%eax
801024ac:	c1 e8 04             	shr    $0x4,%eax
801024af:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
801024b5:	c1 e6 18             	shl    $0x18,%esi
801024b8:	89 f2                	mov    %esi,%edx
801024ba:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024bf:	e8 e1 fd ff ff       	call   801022a5 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801024c4:	ba 00 c5 00 00       	mov    $0xc500,%edx
801024c9:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024ce:	e8 d2 fd ff ff       	call   801022a5 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
801024d3:	ba 00 85 00 00       	mov    $0x8500,%edx
801024d8:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024dd:	e8 c3 fd ff ff       	call   801022a5 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801024e2:	c1 eb 0c             	shr    $0xc,%ebx
801024e5:	80 cf 06             	or     $0x6,%bh
    lapicw(ICRHI, apicid<<24);
801024e8:	89 f2                	mov    %esi,%edx
801024ea:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024ef:	e8 b1 fd ff ff       	call   801022a5 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801024f4:	89 da                	mov    %ebx,%edx
801024f6:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024fb:	e8 a5 fd ff ff       	call   801022a5 <lapicw>
    lapicw(ICRHI, apicid<<24);
80102500:	89 f2                	mov    %esi,%edx
80102502:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102507:	e8 99 fd ff ff       	call   801022a5 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
8010250c:	89 da                	mov    %ebx,%edx
8010250e:	b8 c0 00 00 00       	mov    $0xc0,%eax
80102513:	e8 8d fd ff ff       	call   801022a5 <lapicw>
}
80102518:	5b                   	pop    %ebx
80102519:	5e                   	pop    %esi
8010251a:	5d                   	pop    %ebp
8010251b:	c3                   	ret    

8010251c <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
8010251c:	55                   	push   %ebp
8010251d:	89 e5                	mov    %esp,%ebp
8010251f:	57                   	push   %edi
80102520:	56                   	push   %esi
80102521:	53                   	push   %ebx
80102522:	83 ec 4c             	sub    $0x4c,%esp
80102525:	8b 7d 08             	mov    0x8(%ebp),%edi
80102528:	b8 0b 00 00 00       	mov    $0xb,%eax
8010252d:	ba 70 00 00 00       	mov    $0x70,%edx
80102532:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102533:	ba 71 00 00 00       	mov    $0x71,%edx
80102538:	ec                   	in     (%dx),%al
80102539:	83 e0 04             	and    $0x4,%eax
8010253c:	88 45 b7             	mov    %al,-0x49(%ebp)

  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010253f:	8d 75 d0             	lea    -0x30(%ebp),%esi
80102542:	89 f0                	mov    %esi,%eax
80102544:	e8 74 fd ff ff       	call   801022bd <fill_rtcdate>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102549:	ba 70 00 00 00       	mov    $0x70,%edx
8010254e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102553:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102554:	ba 71 00 00 00       	mov    $0x71,%edx
80102559:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010255a:	84 c0                	test   %al,%al
8010255c:	78 e4                	js     80102542 <cmostime+0x26>
        continue;
    fill_rtcdate(&t2);
8010255e:	8d 5d b8             	lea    -0x48(%ebp),%ebx
80102561:	89 d8                	mov    %ebx,%eax
80102563:	e8 55 fd ff ff       	call   801022bd <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102568:	83 ec 04             	sub    $0x4,%esp
8010256b:	6a 18                	push   $0x18
8010256d:	53                   	push   %ebx
8010256e:	56                   	push   %esi
8010256f:	e8 30 19 00 00       	call   80103ea4 <memcmp>
80102574:	83 c4 10             	add    $0x10,%esp
80102577:	85 c0                	test   %eax,%eax
80102579:	75 c7                	jne    80102542 <cmostime+0x26>
      break;
  }

  // convert
  if(bcd) {
8010257b:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
8010257f:	75 78                	jne    801025f9 <cmostime+0xdd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102581:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102584:	89 c2                	mov    %eax,%edx
80102586:	c1 ea 04             	shr    $0x4,%edx
80102589:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010258c:	83 e0 0f             	and    $0xf,%eax
8010258f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102592:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
80102595:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102598:	89 c2                	mov    %eax,%edx
8010259a:	c1 ea 04             	shr    $0x4,%edx
8010259d:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025a0:	83 e0 0f             	and    $0xf,%eax
801025a3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025a6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
801025a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
801025ac:	89 c2                	mov    %eax,%edx
801025ae:	c1 ea 04             	shr    $0x4,%edx
801025b1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025b4:	83 e0 0f             	and    $0xf,%eax
801025b7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
801025bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025c0:	89 c2                	mov    %eax,%edx
801025c2:	c1 ea 04             	shr    $0x4,%edx
801025c5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025c8:	83 e0 0f             	and    $0xf,%eax
801025cb:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025ce:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801025d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025d4:	89 c2                	mov    %eax,%edx
801025d6:	c1 ea 04             	shr    $0x4,%edx
801025d9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025dc:	83 e0 0f             	and    $0xf,%eax
801025df:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801025e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025e8:	89 c2                	mov    %eax,%edx
801025ea:	c1 ea 04             	shr    $0x4,%edx
801025ed:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025f0:	83 e0 0f             	and    $0xf,%eax
801025f3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
801025f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
801025fc:	89 07                	mov    %eax,(%edi)
801025fe:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80102601:	89 47 04             	mov    %eax,0x4(%edi)
80102604:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102607:	89 47 08             	mov    %eax,0x8(%edi)
8010260a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010260d:	89 47 0c             	mov    %eax,0xc(%edi)
80102610:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102613:	89 47 10             	mov    %eax,0x10(%edi)
80102616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102619:	89 47 14             	mov    %eax,0x14(%edi)
  r->year += 2000;
8010261c:	81 47 14 d0 07 00 00 	addl   $0x7d0,0x14(%edi)
}
80102623:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102626:	5b                   	pop    %ebx
80102627:	5e                   	pop    %esi
80102628:	5f                   	pop    %edi
80102629:	5d                   	pop    %ebp
8010262a:	c3                   	ret    

8010262b <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010262b:	83 3d 28 37 11 80 00 	cmpl   $0x0,0x80113728
80102632:	0f 8e 84 00 00 00    	jle    801026bc <install_trans+0x91>
{
80102638:	55                   	push   %ebp
80102639:	89 e5                	mov    %esp,%ebp
8010263b:	57                   	push   %edi
8010263c:	56                   	push   %esi
8010263d:	53                   	push   %ebx
8010263e:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102641:	bb 00 00 00 00       	mov    $0x0,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102646:	be e0 36 11 80       	mov    $0x801136e0,%esi
8010264b:	83 ec 08             	sub    $0x8,%esp
8010264e:	89 d8                	mov    %ebx,%eax
80102650:	03 46 34             	add    0x34(%esi),%eax
80102653:	83 c0 01             	add    $0x1,%eax
80102656:	50                   	push   %eax
80102657:	ff 76 44             	pushl  0x44(%esi)
8010265a:	e8 4b da ff ff       	call   801000aa <bread>
8010265f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102662:	83 c4 08             	add    $0x8,%esp
80102665:	ff 34 9d 2c 37 11 80 	pushl  -0x7feec8d4(,%ebx,4)
8010266c:	ff 76 44             	pushl  0x44(%esi)
8010266f:	e8 36 da ff ff       	call   801000aa <bread>
80102674:	89 c7                	mov    %eax,%edi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102676:	83 c4 0c             	add    $0xc,%esp
80102679:	68 00 02 00 00       	push   $0x200
8010267e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102681:	83 c0 5c             	add    $0x5c,%eax
80102684:	50                   	push   %eax
80102685:	8d 47 5c             	lea    0x5c(%edi),%eax
80102688:	50                   	push   %eax
80102689:	e8 67 18 00 00       	call   80103ef5 <memmove>
    bwrite(dbuf);  // write dst to disk
8010268e:	89 3c 24             	mov    %edi,(%esp)
80102691:	e8 f0 da ff ff       	call   80100186 <bwrite>
    brelse(lbuf);
80102696:	83 c4 04             	add    $0x4,%esp
80102699:	ff 75 e4             	pushl  -0x1c(%ebp)
8010269c:	e8 20 db ff ff       	call   801001c1 <brelse>
    brelse(dbuf);
801026a1:	89 3c 24             	mov    %edi,(%esp)
801026a4:	e8 18 db ff ff       	call   801001c1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801026a9:	83 c3 01             	add    $0x1,%ebx
801026ac:	83 c4 10             	add    $0x10,%esp
801026af:	39 5e 48             	cmp    %ebx,0x48(%esi)
801026b2:	7f 97                	jg     8010264b <install_trans+0x20>
  }
}
801026b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026b7:	5b                   	pop    %ebx
801026b8:	5e                   	pop    %esi
801026b9:	5f                   	pop    %edi
801026ba:	5d                   	pop    %ebp
801026bb:	c3                   	ret    
801026bc:	f3 c3                	repz ret 

801026be <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801026be:	55                   	push   %ebp
801026bf:	89 e5                	mov    %esp,%ebp
801026c1:	53                   	push   %ebx
801026c2:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801026c5:	ff 35 14 37 11 80    	pushl  0x80113714
801026cb:	ff 35 24 37 11 80    	pushl  0x80113724
801026d1:	e8 d4 d9 ff ff       	call   801000aa <bread>
801026d6:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801026d8:	8b 0d 28 37 11 80    	mov    0x80113728,%ecx
801026de:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801026e1:	83 c4 10             	add    $0x10,%esp
801026e4:	85 c9                	test   %ecx,%ecx
801026e6:	7e 19                	jle    80102701 <write_head+0x43>
801026e8:	c1 e1 02             	shl    $0x2,%ecx
801026eb:	b8 00 00 00 00       	mov    $0x0,%eax
    hb->block[i] = log.lh.block[i];
801026f0:	8b 90 2c 37 11 80    	mov    -0x7feec8d4(%eax),%edx
801026f6:	89 54 03 60          	mov    %edx,0x60(%ebx,%eax,1)
801026fa:	83 c0 04             	add    $0x4,%eax
  for (i = 0; i < log.lh.n; i++) {
801026fd:	39 c8                	cmp    %ecx,%eax
801026ff:	75 ef                	jne    801026f0 <write_head+0x32>
  }
  bwrite(buf);
80102701:	83 ec 0c             	sub    $0xc,%esp
80102704:	53                   	push   %ebx
80102705:	e8 7c da ff ff       	call   80100186 <bwrite>
  brelse(buf);
8010270a:	89 1c 24             	mov    %ebx,(%esp)
8010270d:	e8 af da ff ff       	call   801001c1 <brelse>
}
80102712:	83 c4 10             	add    $0x10,%esp
80102715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102718:	c9                   	leave  
80102719:	c3                   	ret    

8010271a <initlog>:
{
8010271a:	55                   	push   %ebp
8010271b:	89 e5                	mov    %esp,%ebp
8010271d:	53                   	push   %ebx
8010271e:	83 ec 2c             	sub    $0x2c,%esp
80102721:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102724:	68 40 6a 10 80       	push   $0x80106a40
80102729:	68 e0 36 11 80       	push   $0x801136e0
8010272e:	e8 37 15 00 00       	call   80103c6a <initlock>
  readsb(dev, &sb);
80102733:	83 c4 08             	add    $0x8,%esp
80102736:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102739:	50                   	push   %eax
8010273a:	53                   	push   %ebx
8010273b:	e8 12 eb ff ff       	call   80101252 <readsb>
  log.start = sb.logstart;
80102740:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102743:	a3 14 37 11 80       	mov    %eax,0x80113714
  log.size = sb.nlog;
80102748:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010274b:	89 15 18 37 11 80    	mov    %edx,0x80113718
  log.dev = dev;
80102751:	89 1d 24 37 11 80    	mov    %ebx,0x80113724
  struct buf *buf = bread(log.dev, log.start);
80102757:	83 c4 08             	add    $0x8,%esp
8010275a:	50                   	push   %eax
8010275b:	53                   	push   %ebx
8010275c:	e8 49 d9 ff ff       	call   801000aa <bread>
  log.lh.n = lh->n;
80102761:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102764:	89 1d 28 37 11 80    	mov    %ebx,0x80113728
  for (i = 0; i < log.lh.n; i++) {
8010276a:	83 c4 10             	add    $0x10,%esp
8010276d:	85 db                	test   %ebx,%ebx
8010276f:	7e 19                	jle    8010278a <initlog+0x70>
80102771:	c1 e3 02             	shl    $0x2,%ebx
80102774:	ba 00 00 00 00       	mov    $0x0,%edx
    log.lh.block[i] = lh->block[i];
80102779:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
8010277d:	89 8a 2c 37 11 80    	mov    %ecx,-0x7feec8d4(%edx)
80102783:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102786:	39 d3                	cmp    %edx,%ebx
80102788:	75 ef                	jne    80102779 <initlog+0x5f>
  brelse(buf);
8010278a:	83 ec 0c             	sub    $0xc,%esp
8010278d:	50                   	push   %eax
8010278e:	e8 2e da ff ff       	call   801001c1 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102793:	e8 93 fe ff ff       	call   8010262b <install_trans>
  log.lh.n = 0;
80102798:	c7 05 28 37 11 80 00 	movl   $0x0,0x80113728
8010279f:	00 00 00 
  write_head(); // clear the log
801027a2:	e8 17 ff ff ff       	call   801026be <write_head>
}
801027a7:	83 c4 10             	add    $0x10,%esp
801027aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ad:	c9                   	leave  
801027ae:	c3                   	ret    

801027af <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801027af:	55                   	push   %ebp
801027b0:	89 e5                	mov    %esp,%ebp
801027b2:	53                   	push   %ebx
801027b3:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
801027b6:	68 e0 36 11 80       	push   $0x801136e0
801027bb:	e8 f2 15 00 00       	call   80103db2 <acquire>
801027c0:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801027c3:	bb e0 36 11 80       	mov    $0x801136e0,%ebx
801027c8:	eb 15                	jmp    801027df <begin_op+0x30>
      sleep(&log, &log.lock);
801027ca:	83 ec 08             	sub    $0x8,%esp
801027cd:	68 e0 36 11 80       	push   $0x801136e0
801027d2:	68 e0 36 11 80       	push   $0x801136e0
801027d7:	e8 24 10 00 00       	call   80103800 <sleep>
801027dc:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
801027df:	83 7b 40 00          	cmpl   $0x0,0x40(%ebx)
801027e3:	75 e5                	jne    801027ca <begin_op+0x1b>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801027e5:	8b 43 3c             	mov    0x3c(%ebx),%eax
801027e8:	83 c0 01             	add    $0x1,%eax
801027eb:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801027ee:	8b 53 48             	mov    0x48(%ebx),%edx
801027f1:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801027f4:	83 fa 1e             	cmp    $0x1e,%edx
801027f7:	7e 17                	jle    80102810 <begin_op+0x61>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801027f9:	83 ec 08             	sub    $0x8,%esp
801027fc:	68 e0 36 11 80       	push   $0x801136e0
80102801:	68 e0 36 11 80       	push   $0x801136e0
80102806:	e8 f5 0f 00 00       	call   80103800 <sleep>
8010280b:	83 c4 10             	add    $0x10,%esp
8010280e:	eb cf                	jmp    801027df <begin_op+0x30>
    } else {
      log.outstanding += 1;
80102810:	a3 1c 37 11 80       	mov    %eax,0x8011371c
      release(&log.lock);
80102815:	83 ec 0c             	sub    $0xc,%esp
80102818:	68 e0 36 11 80       	push   $0x801136e0
8010281d:	e8 f7 15 00 00       	call   80103e19 <release>
      break;
    }
  }
}
80102822:	83 c4 10             	add    $0x10,%esp
80102825:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102828:	c9                   	leave  
80102829:	c3                   	ret    

8010282a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010282a:	55                   	push   %ebp
8010282b:	89 e5                	mov    %esp,%ebp
8010282d:	57                   	push   %edi
8010282e:	56                   	push   %esi
8010282f:	53                   	push   %ebx
80102830:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102833:	68 e0 36 11 80       	push   $0x801136e0
80102838:	e8 75 15 00 00       	call   80103db2 <acquire>
  log.outstanding -= 1;
8010283d:	a1 1c 37 11 80       	mov    0x8011371c,%eax
80102842:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102845:	89 1d 1c 37 11 80    	mov    %ebx,0x8011371c
  if(log.committing)
8010284b:	83 c4 10             	add    $0x10,%esp
8010284e:	83 3d 20 37 11 80 00 	cmpl   $0x0,0x80113720
80102855:	0f 85 e9 00 00 00    	jne    80102944 <end_op+0x11a>
    panic("log.committing");
  if(log.outstanding == 0){
8010285b:	85 db                	test   %ebx,%ebx
8010285d:	0f 85 ee 00 00 00    	jne    80102951 <end_op+0x127>
    do_commit = 1;
    log.committing = 1;
80102863:	c7 05 20 37 11 80 01 	movl   $0x1,0x80113720
8010286a:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
8010286d:	83 ec 0c             	sub    $0xc,%esp
80102870:	68 e0 36 11 80       	push   $0x801136e0
80102875:	e8 9f 15 00 00       	call   80103e19 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
8010287a:	83 c4 10             	add    $0x10,%esp
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010287d:	be e0 36 11 80       	mov    $0x801136e0,%esi
  if (log.lh.n > 0) {
80102882:	83 3d 28 37 11 80 00 	cmpl   $0x0,0x80113728
80102889:	7e 7f                	jle    8010290a <end_op+0xe0>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010288b:	83 ec 08             	sub    $0x8,%esp
8010288e:	89 d8                	mov    %ebx,%eax
80102890:	03 46 34             	add    0x34(%esi),%eax
80102893:	83 c0 01             	add    $0x1,%eax
80102896:	50                   	push   %eax
80102897:	ff 76 44             	pushl  0x44(%esi)
8010289a:	e8 0b d8 ff ff       	call   801000aa <bread>
8010289f:	89 c7                	mov    %eax,%edi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801028a1:	83 c4 08             	add    $0x8,%esp
801028a4:	ff 34 9d 2c 37 11 80 	pushl  -0x7feec8d4(,%ebx,4)
801028ab:	ff 76 44             	pushl  0x44(%esi)
801028ae:	e8 f7 d7 ff ff       	call   801000aa <bread>
    memmove(to->data, from->data, BSIZE);
801028b3:	83 c4 0c             	add    $0xc,%esp
801028b6:	68 00 02 00 00       	push   $0x200
801028bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801028be:	83 c0 5c             	add    $0x5c,%eax
801028c1:	50                   	push   %eax
801028c2:	8d 47 5c             	lea    0x5c(%edi),%eax
801028c5:	50                   	push   %eax
801028c6:	e8 2a 16 00 00       	call   80103ef5 <memmove>
    bwrite(to);  // write the log
801028cb:	89 3c 24             	mov    %edi,(%esp)
801028ce:	e8 b3 d8 ff ff       	call   80100186 <bwrite>
    brelse(from);
801028d3:	83 c4 04             	add    $0x4,%esp
801028d6:	ff 75 e4             	pushl  -0x1c(%ebp)
801028d9:	e8 e3 d8 ff ff       	call   801001c1 <brelse>
    brelse(to);
801028de:	89 3c 24             	mov    %edi,(%esp)
801028e1:	e8 db d8 ff ff       	call   801001c1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801028e6:	83 c3 01             	add    $0x1,%ebx
801028e9:	83 c4 10             	add    $0x10,%esp
801028ec:	3b 5e 48             	cmp    0x48(%esi),%ebx
801028ef:	7c 9a                	jl     8010288b <end_op+0x61>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801028f1:	e8 c8 fd ff ff       	call   801026be <write_head>
    install_trans(); // Now install writes to home locations
801028f6:	e8 30 fd ff ff       	call   8010262b <install_trans>
    log.lh.n = 0;
801028fb:	c7 05 28 37 11 80 00 	movl   $0x0,0x80113728
80102902:	00 00 00 
    write_head();    // Erase the transaction from the log
80102905:	e8 b4 fd ff ff       	call   801026be <write_head>
    acquire(&log.lock);
8010290a:	83 ec 0c             	sub    $0xc,%esp
8010290d:	68 e0 36 11 80       	push   $0x801136e0
80102912:	e8 9b 14 00 00       	call   80103db2 <acquire>
    log.committing = 0;
80102917:	c7 05 20 37 11 80 00 	movl   $0x0,0x80113720
8010291e:	00 00 00 
    wakeup(&log);
80102921:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80102928:	e8 6f 10 00 00       	call   8010399c <wakeup>
    release(&log.lock);
8010292d:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80102934:	e8 e0 14 00 00       	call   80103e19 <release>
80102939:	83 c4 10             	add    $0x10,%esp
}
8010293c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010293f:	5b                   	pop    %ebx
80102940:	5e                   	pop    %esi
80102941:	5f                   	pop    %edi
80102942:	5d                   	pop    %ebp
80102943:	c3                   	ret    
    panic("log.committing");
80102944:	83 ec 0c             	sub    $0xc,%esp
80102947:	68 44 6a 10 80       	push   $0x80106a44
8010294c:	e8 f3 d9 ff ff       	call   80100344 <panic>
    wakeup(&log);
80102951:	83 ec 0c             	sub    $0xc,%esp
80102954:	68 e0 36 11 80       	push   $0x801136e0
80102959:	e8 3e 10 00 00       	call   8010399c <wakeup>
  release(&log.lock);
8010295e:	c7 04 24 e0 36 11 80 	movl   $0x801136e0,(%esp)
80102965:	e8 af 14 00 00       	call   80103e19 <release>
8010296a:	83 c4 10             	add    $0x10,%esp
8010296d:	eb cd                	jmp    8010293c <end_op+0x112>

8010296f <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010296f:	55                   	push   %ebp
80102970:	89 e5                	mov    %esp,%ebp
80102972:	53                   	push   %ebx
80102973:	83 ec 04             	sub    $0x4,%esp
80102976:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102979:	8b 15 28 37 11 80    	mov    0x80113728,%edx
8010297f:	83 fa 1d             	cmp    $0x1d,%edx
80102982:	7f 6b                	jg     801029ef <log_write+0x80>
80102984:	a1 18 37 11 80       	mov    0x80113718,%eax
80102989:	83 e8 01             	sub    $0x1,%eax
8010298c:	39 c2                	cmp    %eax,%edx
8010298e:	7d 5f                	jge    801029ef <log_write+0x80>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102990:	83 3d 1c 37 11 80 00 	cmpl   $0x0,0x8011371c
80102997:	7e 63                	jle    801029fc <log_write+0x8d>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102999:	83 ec 0c             	sub    $0xc,%esp
8010299c:	68 e0 36 11 80       	push   $0x801136e0
801029a1:	e8 0c 14 00 00       	call   80103db2 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801029a6:	8b 15 28 37 11 80    	mov    0x80113728,%edx
801029ac:	83 c4 10             	add    $0x10,%esp
801029af:	85 d2                	test   %edx,%edx
801029b1:	7e 56                	jle    80102a09 <log_write+0x9a>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801029b3:	8b 4b 08             	mov    0x8(%ebx),%ecx
801029b6:	39 0d 2c 37 11 80    	cmp    %ecx,0x8011372c
801029bc:	74 5b                	je     80102a19 <log_write+0xaa>
  for (i = 0; i < log.lh.n; i++) {
801029be:	b8 00 00 00 00       	mov    $0x0,%eax
801029c3:	83 c0 01             	add    $0x1,%eax
801029c6:	39 d0                	cmp    %edx,%eax
801029c8:	74 56                	je     80102a20 <log_write+0xb1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801029ca:	39 0c 85 2c 37 11 80 	cmp    %ecx,-0x7feec8d4(,%eax,4)
801029d1:	75 f0                	jne    801029c3 <log_write+0x54>
      break;
  }
  log.lh.block[i] = b->blockno;
801029d3:	89 0c 85 2c 37 11 80 	mov    %ecx,-0x7feec8d4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801029da:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
801029dd:	83 ec 0c             	sub    $0xc,%esp
801029e0:	68 e0 36 11 80       	push   $0x801136e0
801029e5:	e8 2f 14 00 00       	call   80103e19 <release>
}
801029ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029ed:	c9                   	leave  
801029ee:	c3                   	ret    
    panic("too big a transaction");
801029ef:	83 ec 0c             	sub    $0xc,%esp
801029f2:	68 53 6a 10 80       	push   $0x80106a53
801029f7:	e8 48 d9 ff ff       	call   80100344 <panic>
    panic("log_write outside of trans");
801029fc:	83 ec 0c             	sub    $0xc,%esp
801029ff:	68 69 6a 10 80       	push   $0x80106a69
80102a04:	e8 3b d9 ff ff       	call   80100344 <panic>
  log.lh.block[i] = b->blockno;
80102a09:	8b 43 08             	mov    0x8(%ebx),%eax
80102a0c:	a3 2c 37 11 80       	mov    %eax,0x8011372c
  if (i == log.lh.n)
80102a11:	85 d2                	test   %edx,%edx
80102a13:	75 c5                	jne    801029da <log_write+0x6b>
  for (i = 0; i < log.lh.n; i++) {
80102a15:	89 d0                	mov    %edx,%eax
80102a17:	eb 11                	jmp    80102a2a <log_write+0xbb>
80102a19:	b8 00 00 00 00       	mov    $0x0,%eax
80102a1e:	eb b3                	jmp    801029d3 <log_write+0x64>
  log.lh.block[i] = b->blockno;
80102a20:	8b 53 08             	mov    0x8(%ebx),%edx
80102a23:	89 14 85 2c 37 11 80 	mov    %edx,-0x7feec8d4(,%eax,4)
    log.lh.n++;
80102a2a:	83 c0 01             	add    $0x1,%eax
80102a2d:	a3 28 37 11 80       	mov    %eax,0x80113728
80102a32:	eb a6                	jmp    801029da <log_write+0x6b>

80102a34 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102a34:	55                   	push   %ebp
80102a35:	89 e5                	mov    %esp,%ebp
80102a37:	53                   	push   %ebx
80102a38:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102a3b:	e8 e0 08 00 00       	call   80103320 <cpuid>
80102a40:	89 c3                	mov    %eax,%ebx
80102a42:	e8 d9 08 00 00       	call   80103320 <cpuid>
80102a47:	83 ec 04             	sub    $0x4,%esp
80102a4a:	53                   	push   %ebx
80102a4b:	50                   	push   %eax
80102a4c:	68 84 6a 10 80       	push   $0x80106a84
80102a51:	e8 8b db ff ff       	call   801005e1 <cprintf>
  idtinit();       // load idt register
80102a56:	e8 25 25 00 00       	call   80104f80 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102a5b:	e8 49 08 00 00       	call   801032a9 <mycpu>
80102a60:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a62:	b8 01 00 00 00       	mov    $0x1,%eax
80102a67:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a6e:	e8 47 0b 00 00       	call   801035ba <scheduler>

80102a73 <mpenter>:
{
80102a73:	55                   	push   %ebp
80102a74:	89 e5                	mov    %esp,%ebp
80102a76:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a79:	e8 c9 34 00 00       	call   80105f47 <switchkvm>
  seginit();
80102a7e:	e8 dd 33 00 00       	call   80105e60 <seginit>
  lapicinit();
80102a83:	e8 af f8 ff ff       	call   80102337 <lapicinit>
  mpmain();
80102a88:	e8 a7 ff ff ff       	call   80102a34 <mpmain>

80102a8d <main>:
{
80102a8d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102a91:	83 e4 f0             	and    $0xfffffff0,%esp
80102a94:	ff 71 fc             	pushl  -0x4(%ecx)
80102a97:	55                   	push   %ebp
80102a98:	89 e5                	mov    %esp,%ebp
80102a9a:	53                   	push   %ebx
80102a9b:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102a9c:	83 ec 08             	sub    $0x8,%esp
80102a9f:	68 00 00 40 80       	push   $0x80400000
80102aa4:	68 88 45 11 80       	push   $0x80114588
80102aa9:	e8 60 f6 ff ff       	call   8010210e <kinit1>
  kvmalloc();      // kernel page table
80102aae:	e8 19 39 00 00       	call   801063cc <kvmalloc>
  mpinit();        // detect other processors
80102ab3:	e8 50 01 00 00       	call   80102c08 <mpinit>
  lapicinit();     // interrupt controller
80102ab8:	e8 7a f8 ff ff       	call   80102337 <lapicinit>
  seginit();       // segment descriptors
80102abd:	e8 9e 33 00 00       	call   80105e60 <seginit>
  picinit();       // disable pic
80102ac2:	e8 01 03 00 00       	call   80102dc8 <picinit>
  ioapicinit();    // another interrupt controller
80102ac7:	e8 a0 f4 ff ff       	call   80101f6c <ioapicinit>
  consoleinit();   // console hardware
80102acc:	e8 fd dd ff ff       	call   801008ce <consoleinit>
  uartinit();      // serial port
80102ad1:	e8 71 27 00 00       	call   80105247 <uartinit>
  pinit();         // process table
80102ad6:	e8 b4 07 00 00       	call   8010328f <pinit>
  tvinit();        // trap vectors
80102adb:	e8 2d 24 00 00       	call   80104f0d <tvinit>
  binit();         // buffer cache
80102ae0:	e8 4f d5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102ae5:	e8 66 e1 ff ff       	call   80100c50 <fileinit>
  ideinit();       // disk 
80102aea:	e8 8e f2 ff ff       	call   80101d7d <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102aef:	83 c4 0c             	add    $0xc,%esp
80102af2:	68 8a 00 00 00       	push   $0x8a
80102af7:	68 8c 94 10 80       	push   $0x8010948c
80102afc:	68 00 70 00 80       	push   $0x80007000
80102b01:	e8 ef 13 00 00       	call   80103ef5 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102b06:	69 05 60 3d 11 80 b0 	imul   $0xb0,0x80113d60,%eax
80102b0d:	00 00 00 
80102b10:	05 e0 37 11 80       	add    $0x801137e0,%eax
80102b15:	83 c4 10             	add    $0x10,%esp
80102b18:	3d e0 37 11 80       	cmp    $0x801137e0,%eax
80102b1d:	76 6c                	jbe    80102b8b <main+0xfe>
80102b1f:	bb e0 37 11 80       	mov    $0x801137e0,%ebx
80102b24:	eb 19                	jmp    80102b3f <main+0xb2>
80102b26:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102b2c:	69 05 60 3d 11 80 b0 	imul   $0xb0,0x80113d60,%eax
80102b33:	00 00 00 
80102b36:	05 e0 37 11 80       	add    $0x801137e0,%eax
80102b3b:	39 c3                	cmp    %eax,%ebx
80102b3d:	73 4c                	jae    80102b8b <main+0xfe>
    if(c == mycpu())  // We've started already.
80102b3f:	e8 65 07 00 00       	call   801032a9 <mycpu>
80102b44:	39 d8                	cmp    %ebx,%eax
80102b46:	74 de                	je     80102b26 <main+0x99>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102b48:	e8 13 f6 ff ff       	call   80102160 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102b4d:	05 00 10 00 00       	add    $0x1000,%eax
80102b52:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
80102b57:	c7 05 f8 6f 00 80 73 	movl   $0x80102a73,0x80006ff8
80102b5e:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102b61:	c7 05 f4 6f 00 80 00 	movl   $0x108000,0x80006ff4
80102b68:	80 10 00 

    lapicstartap(c->apicid, V2P(code));
80102b6b:	83 ec 08             	sub    $0x8,%esp
80102b6e:	68 00 70 00 00       	push   $0x7000
80102b73:	0f b6 03             	movzbl (%ebx),%eax
80102b76:	50                   	push   %eax
80102b77:	e8 04 f9 ff ff       	call   80102480 <lapicstartap>
80102b7c:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102b7f:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102b85:	85 c0                	test   %eax,%eax
80102b87:	74 f6                	je     80102b7f <main+0xf2>
80102b89:	eb 9b                	jmp    80102b26 <main+0x99>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102b8b:	83 ec 08             	sub    $0x8,%esp
80102b8e:	68 00 00 00 8e       	push   $0x8e000000
80102b93:	68 00 00 40 80       	push   $0x80400000
80102b98:	e8 a3 f5 ff ff       	call   80102140 <kinit2>
  userinit();      // first user process
80102b9d:	e8 bd 07 00 00       	call   8010335f <userinit>
  mpmain();        // finish this processor's setup
80102ba2:	e8 8d fe ff ff       	call   80102a34 <mpmain>

80102ba7 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102ba7:	55                   	push   %ebp
80102ba8:	89 e5                	mov    %esp,%ebp
80102baa:	57                   	push   %edi
80102bab:	56                   	push   %esi
80102bac:	53                   	push   %ebx
80102bad:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102bb0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
  e = addr+len;
80102bb6:	8d 34 13             	lea    (%ebx,%edx,1),%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102bb9:	39 f3                	cmp    %esi,%ebx
80102bbb:	72 12                	jb     80102bcf <mpsearch1+0x28>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102bbd:	bb 00 00 00 00       	mov    $0x0,%ebx
80102bc2:	eb 3a                	jmp    80102bfe <mpsearch1+0x57>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102bc4:	84 c0                	test   %al,%al
80102bc6:	74 36                	je     80102bfe <mpsearch1+0x57>
  for(p = addr; p < e; p += sizeof(struct mp))
80102bc8:	83 c3 10             	add    $0x10,%ebx
80102bcb:	39 de                	cmp    %ebx,%esi
80102bcd:	76 2a                	jbe    80102bf9 <mpsearch1+0x52>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102bcf:	83 ec 04             	sub    $0x4,%esp
80102bd2:	6a 04                	push   $0x4
80102bd4:	68 98 6a 10 80       	push   $0x80106a98
80102bd9:	53                   	push   %ebx
80102bda:	e8 c5 12 00 00       	call   80103ea4 <memcmp>
80102bdf:	83 c4 10             	add    $0x10,%esp
80102be2:	85 c0                	test   %eax,%eax
80102be4:	75 e2                	jne    80102bc8 <mpsearch1+0x21>
80102be6:	89 d9                	mov    %ebx,%ecx
80102be8:	8d 7b 10             	lea    0x10(%ebx),%edi
    sum += addr[i];
80102beb:	0f b6 11             	movzbl (%ecx),%edx
80102bee:	01 d0                	add    %edx,%eax
80102bf0:	83 c1 01             	add    $0x1,%ecx
  for(i=0; i<len; i++)
80102bf3:	39 f9                	cmp    %edi,%ecx
80102bf5:	75 f4                	jne    80102beb <mpsearch1+0x44>
80102bf7:	eb cb                	jmp    80102bc4 <mpsearch1+0x1d>
  return 0;
80102bf9:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102bfe:	89 d8                	mov    %ebx,%eax
80102c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c03:	5b                   	pop    %ebx
80102c04:	5e                   	pop    %esi
80102c05:	5f                   	pop    %edi
80102c06:	5d                   	pop    %ebp
80102c07:	c3                   	ret    

80102c08 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102c08:	55                   	push   %ebp
80102c09:	89 e5                	mov    %esp,%ebp
80102c0b:	57                   	push   %edi
80102c0c:	56                   	push   %esi
80102c0d:	53                   	push   %ebx
80102c0e:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102c11:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102c18:	c1 e0 08             	shl    $0x8,%eax
80102c1b:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102c22:	09 d0                	or     %edx,%eax
80102c24:	c1 e0 04             	shl    $0x4,%eax
80102c27:	85 c0                	test   %eax,%eax
80102c29:	0f 84 b0 00 00 00    	je     80102cdf <mpinit+0xd7>
    if((mp = mpsearch1(p, 1024)))
80102c2f:	ba 00 04 00 00       	mov    $0x400,%edx
80102c34:	e8 6e ff ff ff       	call   80102ba7 <mpsearch1>
80102c39:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102c3c:	85 c0                	test   %eax,%eax
80102c3e:	0f 84 cb 00 00 00    	je     80102d0f <mpinit+0x107>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102c44:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102c47:	8b 58 04             	mov    0x4(%eax),%ebx
80102c4a:	85 db                	test   %ebx,%ebx
80102c4c:	0f 84 d7 00 00 00    	je     80102d29 <mpinit+0x121>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c52:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80102c58:	83 ec 04             	sub    $0x4,%esp
80102c5b:	6a 04                	push   $0x4
80102c5d:	68 9d 6a 10 80       	push   $0x80106a9d
80102c62:	56                   	push   %esi
80102c63:	e8 3c 12 00 00       	call   80103ea4 <memcmp>
80102c68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80102c6b:	83 c4 10             	add    $0x10,%esp
80102c6e:	85 c0                	test   %eax,%eax
80102c70:	0f 85 b3 00 00 00    	jne    80102d29 <mpinit+0x121>
  if(conf->version != 1 && conf->version != 4)
80102c76:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80102c7d:	3c 01                	cmp    $0x1,%al
80102c7f:	74 08                	je     80102c89 <mpinit+0x81>
80102c81:	3c 04                	cmp    $0x4,%al
80102c83:	0f 85 a0 00 00 00    	jne    80102d29 <mpinit+0x121>
  if(sum((uchar*)conf, conf->length) != 0)
80102c89:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80102c90:	66 85 d2             	test   %dx,%dx
80102c93:	74 1f                	je     80102cb4 <mpinit+0xac>
80102c95:	89 f0                	mov    %esi,%eax
80102c97:	0f b7 d2             	movzwl %dx,%edx
80102c9a:	8d bc 13 00 00 00 80 	lea    -0x80000000(%ebx,%edx,1),%edi
  sum = 0;
80102ca1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    sum += addr[i];
80102ca4:	0f b6 08             	movzbl (%eax),%ecx
80102ca7:	01 ca                	add    %ecx,%edx
80102ca9:	83 c0 01             	add    $0x1,%eax
  for(i=0; i<len; i++)
80102cac:	39 c7                	cmp    %eax,%edi
80102cae:	75 f4                	jne    80102ca4 <mpinit+0x9c>
  if(sum((uchar*)conf, conf->length) != 0)
80102cb0:	84 d2                	test   %dl,%dl
80102cb2:	75 75                	jne    80102d29 <mpinit+0x121>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102cb4:	85 f6                	test   %esi,%esi
80102cb6:	74 71                	je     80102d29 <mpinit+0x121>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102cb8:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80102cbe:	a3 dc 36 11 80       	mov    %eax,0x801136dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cc3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80102cc9:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80102cd0:	01 d6                	add    %edx,%esi
  ismp = 1;
80102cd2:	b9 01 00 00 00       	mov    $0x1,%ecx
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80102cd7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cda:	e9 88 00 00 00       	jmp    80102d67 <mpinit+0x15f>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102cdf:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102ce6:	c1 e0 08             	shl    $0x8,%eax
80102ce9:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102cf0:	09 d0                	or     %edx,%eax
80102cf2:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102cf5:	2d 00 04 00 00       	sub    $0x400,%eax
80102cfa:	ba 00 04 00 00       	mov    $0x400,%edx
80102cff:	e8 a3 fe ff ff       	call   80102ba7 <mpsearch1>
80102d04:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d07:	85 c0                	test   %eax,%eax
80102d09:	0f 85 35 ff ff ff    	jne    80102c44 <mpinit+0x3c>
  return mpsearch1(0xF0000, 0x10000);
80102d0f:	ba 00 00 01 00       	mov    $0x10000,%edx
80102d14:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102d19:	e8 89 fe ff ff       	call   80102ba7 <mpsearch1>
80102d1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102d21:	85 c0                	test   %eax,%eax
80102d23:	0f 85 1b ff ff ff    	jne    80102c44 <mpinit+0x3c>
    panic("Expect to run on an SMP");
80102d29:	83 ec 0c             	sub    $0xc,%esp
80102d2c:	68 a2 6a 10 80       	push   $0x80106aa2
80102d31:	e8 0e d6 ff ff       	call   80100344 <panic>
      ismp = 0;
80102d36:	89 f9                	mov    %edi,%ecx
80102d38:	eb 34                	jmp    80102d6e <mpinit+0x166>
      if(ncpu < NCPU) {
80102d3a:	8b 15 60 3d 11 80    	mov    0x80113d60,%edx
80102d40:	83 fa 07             	cmp    $0x7,%edx
80102d43:	7f 1f                	jg     80102d64 <mpinit+0x15c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102d45:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80102d48:	69 da b0 00 00 00    	imul   $0xb0,%edx,%ebx
80102d4e:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80102d52:	88 93 e0 37 11 80    	mov    %dl,-0x7feec820(%ebx)
        ncpu++;
80102d58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102d5b:	83 c2 01             	add    $0x1,%edx
80102d5e:	89 15 60 3d 11 80    	mov    %edx,0x80113d60
      p += sizeof(struct mpproc);
80102d64:	83 c0 14             	add    $0x14,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d67:	39 f0                	cmp    %esi,%eax
80102d69:	73 26                	jae    80102d91 <mpinit+0x189>
    switch(*p){
80102d6b:	0f b6 10             	movzbl (%eax),%edx
80102d6e:	80 fa 04             	cmp    $0x4,%dl
80102d71:	77 c3                	ja     80102d36 <mpinit+0x12e>
80102d73:	0f b6 d2             	movzbl %dl,%edx
80102d76:	ff 24 95 dc 6a 10 80 	jmp    *-0x7fef9524(,%edx,4)
      ioapicid = ioapic->apicno;
80102d7d:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80102d81:	88 15 c0 37 11 80    	mov    %dl,0x801137c0
      p += sizeof(struct mpioapic);
80102d87:	83 c0 08             	add    $0x8,%eax
      continue;
80102d8a:	eb db                	jmp    80102d67 <mpinit+0x15f>
      p += 8;
80102d8c:	83 c0 08             	add    $0x8,%eax
      continue;
80102d8f:	eb d6                	jmp    80102d67 <mpinit+0x15f>
      break;
    }
  }
  if(!ismp)
80102d91:	85 c9                	test   %ecx,%ecx
80102d93:	74 26                	je     80102dbb <mpinit+0x1b3>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102d95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80102d98:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102d9c:	74 15                	je     80102db3 <mpinit+0x1ab>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d9e:	b8 70 00 00 00       	mov    $0x70,%eax
80102da3:	ba 22 00 00 00       	mov    $0x22,%edx
80102da8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102da9:	ba 23 00 00 00       	mov    $0x23,%edx
80102dae:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102daf:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db2:	ee                   	out    %al,(%dx)
  }
}
80102db3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102db6:	5b                   	pop    %ebx
80102db7:	5e                   	pop    %esi
80102db8:	5f                   	pop    %edi
80102db9:	5d                   	pop    %ebp
80102dba:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102dbb:	83 ec 0c             	sub    $0xc,%esp
80102dbe:	68 bc 6a 10 80       	push   $0x80106abc
80102dc3:	e8 7c d5 ff ff       	call   80100344 <panic>

80102dc8 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102dc8:	55                   	push   %ebp
80102dc9:	89 e5                	mov    %esp,%ebp
80102dcb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102dd0:	ba 21 00 00 00       	mov    $0x21,%edx
80102dd5:	ee                   	out    %al,(%dx)
80102dd6:	ba a1 00 00 00       	mov    $0xa1,%edx
80102ddb:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102ddc:	5d                   	pop    %ebp
80102ddd:	c3                   	ret    

80102dde <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102dde:	55                   	push   %ebp
80102ddf:	89 e5                	mov    %esp,%ebp
80102de1:	57                   	push   %edi
80102de2:	56                   	push   %esi
80102de3:	53                   	push   %ebx
80102de4:	83 ec 0c             	sub    $0xc,%esp
80102de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102dea:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102ded:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102df3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102df9:	e8 6c de ff ff       	call   80100c6a <filealloc>
80102dfe:	89 03                	mov    %eax,(%ebx)
80102e00:	85 c0                	test   %eax,%eax
80102e02:	0f 84 a9 00 00 00    	je     80102eb1 <pipealloc+0xd3>
80102e08:	e8 5d de ff ff       	call   80100c6a <filealloc>
80102e0d:	89 06                	mov    %eax,(%esi)
80102e0f:	85 c0                	test   %eax,%eax
80102e11:	0f 84 88 00 00 00    	je     80102e9f <pipealloc+0xc1>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102e17:	e8 44 f3 ff ff       	call   80102160 <kalloc>
80102e1c:	89 c7                	mov    %eax,%edi
80102e1e:	85 c0                	test   %eax,%eax
80102e20:	75 0b                	jne    80102e2d <pipealloc+0x4f>
  return 0;

 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102e22:	8b 03                	mov    (%ebx),%eax
80102e24:	85 c0                	test   %eax,%eax
80102e26:	75 7d                	jne    80102ea5 <pipealloc+0xc7>
80102e28:	e9 84 00 00 00       	jmp    80102eb1 <pipealloc+0xd3>
  p->readopen = 1;
80102e2d:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102e34:	00 00 00 
  p->writeopen = 1;
80102e37:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102e3e:	00 00 00 
  p->nwrite = 0;
80102e41:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102e48:	00 00 00 
  p->nread = 0;
80102e4b:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102e52:	00 00 00 
  initlock(&p->lock, "pipe");
80102e55:	83 ec 08             	sub    $0x8,%esp
80102e58:	68 f0 6a 10 80       	push   $0x80106af0
80102e5d:	50                   	push   %eax
80102e5e:	e8 07 0e 00 00       	call   80103c6a <initlock>
  (*f0)->type = FD_PIPE;
80102e63:	8b 03                	mov    (%ebx),%eax
80102e65:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102e6b:	8b 03                	mov    (%ebx),%eax
80102e6d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102e71:	8b 03                	mov    (%ebx),%eax
80102e73:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102e77:	8b 03                	mov    (%ebx),%eax
80102e79:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102e7c:	8b 06                	mov    (%esi),%eax
80102e7e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102e84:	8b 06                	mov    (%esi),%eax
80102e86:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102e8a:	8b 06                	mov    (%esi),%eax
80102e8c:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102e90:	8b 06                	mov    (%esi),%eax
80102e92:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102e95:	83 c4 10             	add    $0x10,%esp
80102e98:	b8 00 00 00 00       	mov    $0x0,%eax
80102e9d:	eb 2e                	jmp    80102ecd <pipealloc+0xef>
  if(*f0)
80102e9f:	8b 03                	mov    (%ebx),%eax
80102ea1:	85 c0                	test   %eax,%eax
80102ea3:	74 30                	je     80102ed5 <pipealloc+0xf7>
    fileclose(*f0);
80102ea5:	83 ec 0c             	sub    $0xc,%esp
80102ea8:	50                   	push   %eax
80102ea9:	e8 6e de ff ff       	call   80100d1c <fileclose>
80102eae:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102eb1:	8b 16                	mov    (%esi),%edx
    fileclose(*f1);
  return -1;
80102eb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(*f1)
80102eb8:	85 d2                	test   %edx,%edx
80102eba:	74 11                	je     80102ecd <pipealloc+0xef>
    fileclose(*f1);
80102ebc:	83 ec 0c             	sub    $0xc,%esp
80102ebf:	52                   	push   %edx
80102ec0:	e8 57 de ff ff       	call   80100d1c <fileclose>
80102ec5:	83 c4 10             	add    $0x10,%esp
  return -1;
80102ec8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ecd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ed0:	5b                   	pop    %ebx
80102ed1:	5e                   	pop    %esi
80102ed2:	5f                   	pop    %edi
80102ed3:	5d                   	pop    %ebp
80102ed4:	c3                   	ret    
  return -1;
80102ed5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102eda:	eb f1                	jmp    80102ecd <pipealloc+0xef>

80102edc <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102edc:	55                   	push   %ebp
80102edd:	89 e5                	mov    %esp,%ebp
80102edf:	53                   	push   %ebx
80102ee0:	83 ec 10             	sub    $0x10,%esp
80102ee3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102ee6:	53                   	push   %ebx
80102ee7:	e8 c6 0e 00 00       	call   80103db2 <acquire>
  if(writable){
80102eec:	83 c4 10             	add    $0x10,%esp
80102eef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102ef3:	74 3f                	je     80102f34 <pipeclose+0x58>
    p->writeopen = 0;
80102ef5:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102efc:	00 00 00 
    wakeup(&p->nread);
80102eff:	83 ec 0c             	sub    $0xc,%esp
80102f02:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f08:	50                   	push   %eax
80102f09:	e8 8e 0a 00 00       	call   8010399c <wakeup>
80102f0e:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102f11:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f18:	75 09                	jne    80102f23 <pipeclose+0x47>
80102f1a:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102f21:	74 2f                	je     80102f52 <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102f23:	83 ec 0c             	sub    $0xc,%esp
80102f26:	53                   	push   %ebx
80102f27:	e8 ed 0e 00 00       	call   80103e19 <release>
80102f2c:	83 c4 10             	add    $0x10,%esp
}
80102f2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f32:	c9                   	leave  
80102f33:	c3                   	ret    
    p->readopen = 0;
80102f34:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102f3b:	00 00 00 
    wakeup(&p->nwrite);
80102f3e:	83 ec 0c             	sub    $0xc,%esp
80102f41:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f47:	50                   	push   %eax
80102f48:	e8 4f 0a 00 00       	call   8010399c <wakeup>
80102f4d:	83 c4 10             	add    $0x10,%esp
80102f50:	eb bf                	jmp    80102f11 <pipeclose+0x35>
    release(&p->lock);
80102f52:	83 ec 0c             	sub    $0xc,%esp
80102f55:	53                   	push   %ebx
80102f56:	e8 be 0e 00 00       	call   80103e19 <release>
    kfree((char*)p);
80102f5b:	89 1c 24             	mov    %ebx,(%esp)
80102f5e:	e8 d8 f0 ff ff       	call   8010203b <kfree>
80102f63:	83 c4 10             	add    $0x10,%esp
80102f66:	eb c7                	jmp    80102f2f <pipeclose+0x53>

80102f68 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
80102f68:	55                   	push   %ebp
80102f69:	89 e5                	mov    %esp,%ebp
80102f6b:	57                   	push   %edi
80102f6c:	56                   	push   %esi
80102f6d:	53                   	push   %ebx
80102f6e:	83 ec 28             	sub    $0x28,%esp
80102f71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102f74:	8b 75 0c             	mov    0xc(%ebp),%esi
  int i;

  acquire(&p->lock);
80102f77:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102f7a:	53                   	push   %ebx
80102f7b:	e8 32 0e 00 00       	call   80103db2 <acquire>
  for(i = 0; i < n; i++){
80102f80:	83 c4 10             	add    $0x10,%esp
80102f83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102f87:	0f 8e b5 00 00 00    	jle    80103042 <pipewrite+0xda>
80102f8d:	89 75 e0             	mov    %esi,-0x20(%ebp)
80102f90:	03 75 10             	add    0x10(%ebp),%esi
80102f93:	89 75 dc             	mov    %esi,-0x24(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80102f96:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102f9c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102fa2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102fa8:	05 00 02 00 00       	add    $0x200,%eax
80102fad:	39 c2                	cmp    %eax,%edx
80102faf:	75 69                	jne    8010301a <pipewrite+0xb2>
      if(p->readopen == 0 || myproc()->killed){
80102fb1:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102fb8:	74 47                	je     80103001 <pipewrite+0x99>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102fba:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
      if(p->readopen == 0 || myproc()->killed){
80102fc0:	e8 76 03 00 00       	call   8010333b <myproc>
80102fc5:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102fc9:	75 36                	jne    80103001 <pipewrite+0x99>
      wakeup(&p->nread);
80102fcb:	83 ec 0c             	sub    $0xc,%esp
80102fce:	57                   	push   %edi
80102fcf:	e8 c8 09 00 00       	call   8010399c <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102fd4:	83 c4 08             	add    $0x8,%esp
80102fd7:	ff 75 e4             	pushl  -0x1c(%ebp)
80102fda:	56                   	push   %esi
80102fdb:	e8 20 08 00 00       	call   80103800 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102fe0:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102fe6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102fec:	05 00 02 00 00       	add    $0x200,%eax
80102ff1:	83 c4 10             	add    $0x10,%esp
80102ff4:	39 c2                	cmp    %eax,%edx
80102ff6:	75 22                	jne    8010301a <pipewrite+0xb2>
      if(p->readopen == 0 || myproc()->killed){
80102ff8:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102fff:	75 bf                	jne    80102fc0 <pipewrite+0x58>
        release(&p->lock);
80103001:	83 ec 0c             	sub    $0xc,%esp
80103004:	53                   	push   %ebx
80103005:	e8 0f 0e 00 00       	call   80103e19 <release>
        return -1;
8010300a:	83 c4 10             	add    $0x10,%esp
8010300d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103012:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103015:	5b                   	pop    %ebx
80103016:	5e                   	pop    %esi
80103017:	5f                   	pop    %edi
80103018:	5d                   	pop    %ebp
80103019:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010301a:	8d 42 01             	lea    0x1(%edx),%eax
8010301d:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103023:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80103026:	0f b6 01             	movzbl (%ecx),%eax
80103029:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010302f:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
80103033:	83 c1 01             	add    $0x1,%ecx
80103036:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(i = 0; i < n; i++){
80103039:	3b 4d dc             	cmp    -0x24(%ebp),%ecx
8010303c:	0f 85 5a ff ff ff    	jne    80102f9c <pipewrite+0x34>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103042:	83 ec 0c             	sub    $0xc,%esp
80103045:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010304b:	50                   	push   %eax
8010304c:	e8 4b 09 00 00       	call   8010399c <wakeup>
  release(&p->lock);
80103051:	89 1c 24             	mov    %ebx,(%esp)
80103054:	e8 c0 0d 00 00       	call   80103e19 <release>
  return n;
80103059:	83 c4 10             	add    $0x10,%esp
8010305c:	8b 45 10             	mov    0x10(%ebp),%eax
8010305f:	eb b1                	jmp    80103012 <pipewrite+0xaa>

80103061 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103061:	55                   	push   %ebp
80103062:	89 e5                	mov    %esp,%ebp
80103064:	57                   	push   %edi
80103065:	56                   	push   %esi
80103066:	53                   	push   %ebx
80103067:	83 ec 18             	sub    $0x18,%esp
8010306a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010306d:	53                   	push   %ebx
8010306e:	e8 3f 0d 00 00       	call   80103db2 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103073:	83 c4 10             	add    $0x10,%esp
80103076:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
8010307c:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103082:	75 7c                	jne    80103100 <piperead+0x9f>
80103084:	89 de                	mov    %ebx,%esi
80103086:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
8010308d:	74 35                	je     801030c4 <piperead+0x63>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010308f:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
    if(myproc()->killed){
80103095:	e8 a1 02 00 00       	call   8010333b <myproc>
8010309a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010309e:	75 4d                	jne    801030ed <piperead+0x8c>
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801030a0:	83 ec 08             	sub    $0x8,%esp
801030a3:	56                   	push   %esi
801030a4:	57                   	push   %edi
801030a5:	e8 56 07 00 00       	call   80103800 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801030aa:	83 c4 10             	add    $0x10,%esp
801030ad:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801030b3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801030b9:	75 45                	jne    80103100 <piperead+0x9f>
801030bb:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
801030c2:	75 d1                	jne    80103095 <piperead+0x34>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801030c4:	be 00 00 00 00       	mov    $0x0,%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801030c9:	83 ec 0c             	sub    $0xc,%esp
801030cc:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801030d2:	50                   	push   %eax
801030d3:	e8 c4 08 00 00       	call   8010399c <wakeup>
  release(&p->lock);
801030d8:	89 1c 24             	mov    %ebx,(%esp)
801030db:	e8 39 0d 00 00       	call   80103e19 <release>
  return i;
801030e0:	83 c4 10             	add    $0x10,%esp
}
801030e3:	89 f0                	mov    %esi,%eax
801030e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030e8:	5b                   	pop    %ebx
801030e9:	5e                   	pop    %esi
801030ea:	5f                   	pop    %edi
801030eb:	5d                   	pop    %ebp
801030ec:	c3                   	ret    
      release(&p->lock);
801030ed:	83 ec 0c             	sub    $0xc,%esp
801030f0:	53                   	push   %ebx
801030f1:	e8 23 0d 00 00       	call   80103e19 <release>
      return -1;
801030f6:	83 c4 10             	add    $0x10,%esp
801030f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
801030fe:	eb e3                	jmp    801030e3 <piperead+0x82>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103100:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80103104:	7e 3c                	jle    80103142 <piperead+0xe1>
    if(p->nread == p->nwrite)
80103106:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010310c:	be 00 00 00 00       	mov    $0x0,%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103111:	8d 50 01             	lea    0x1(%eax),%edx
80103114:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
8010311a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010311f:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103124:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103127:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010312a:	83 c6 01             	add    $0x1,%esi
8010312d:	39 75 10             	cmp    %esi,0x10(%ebp)
80103130:	74 97                	je     801030c9 <piperead+0x68>
    if(p->nread == p->nwrite)
80103132:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103138:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
8010313e:	75 d1                	jne    80103111 <piperead+0xb0>
80103140:	eb 87                	jmp    801030c9 <piperead+0x68>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103142:	be 00 00 00 00       	mov    $0x0,%esi
80103147:	eb 80                	jmp    801030c9 <piperead+0x68>

80103149 <wakeup1>:

// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80103149:	55                   	push   %ebp
8010314a:	89 e5                	mov    %esp,%ebp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010314c:	ba 14 96 10 80       	mov    $0x80109614,%edx
80103151:	eb 0b                	jmp    8010315e <wakeup1+0x15>
80103153:	83 ea 80             	sub    $0xffffff80,%edx
80103156:	81 fa 14 b6 10 80    	cmp    $0x8010b614,%edx
8010315c:	73 14                	jae    80103172 <wakeup1+0x29>
    if(p->state == SLEEPING && p->chan == chan)
8010315e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103162:	75 ef                	jne    80103153 <wakeup1+0xa>
80103164:	39 42 20             	cmp    %eax,0x20(%edx)
80103167:	75 ea                	jne    80103153 <wakeup1+0xa>
      p->state = RUNNABLE;
80103169:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103170:	eb e1                	jmp    80103153 <wakeup1+0xa>
}
80103172:	5d                   	pop    %ebp
80103173:	c3                   	ret    

80103174 <allocproc>:
{
80103174:	55                   	push   %ebp
80103175:	89 e5                	mov    %esp,%ebp
80103177:	53                   	push   %ebx
80103178:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010317b:	68 e0 95 10 80       	push   $0x801095e0
80103180:	e8 2d 0c 00 00       	call   80103db2 <acquire>
    if(p->state == UNUSED) {
80103185:	83 c4 10             	add    $0x10,%esp
80103188:	83 3d 20 96 10 80 00 	cmpl   $0x0,0x80109620
8010318f:	74 3e                	je     801031cf <allocproc+0x5b>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103191:	bb 94 96 10 80       	mov    $0x80109694,%ebx
    if(p->state == UNUSED) {
80103196:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
8010319a:	74 38                	je     801031d4 <allocproc+0x60>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010319c:	83 eb 80             	sub    $0xffffff80,%ebx
8010319f:	81 fb 14 b6 10 80    	cmp    $0x8010b614,%ebx
801031a5:	72 ef                	jb     80103196 <allocproc+0x22>
    release(&ptable.lock);
801031a7:	83 ec 0c             	sub    $0xc,%esp
801031aa:	68 e0 95 10 80       	push   $0x801095e0
801031af:	e8 65 0c 00 00       	call   80103e19 <release>
    return 0;
801031b4:	83 c4 10             	add    $0x10,%esp
801031b7:	bb 00 00 00 00       	mov    $0x0,%ebx
801031bc:	e9 84 00 00 00       	jmp    80103245 <allocproc+0xd1>
    p->state = UNUSED;
801031c1:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801031c8:	bb 00 00 00 00       	mov    $0x0,%ebx
801031cd:	eb 76                	jmp    80103245 <allocproc+0xd1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801031cf:	bb 14 96 10 80       	mov    $0x80109614,%ebx
  p->state = EMBRYO;
801031d4:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801031db:	a1 04 90 10 80       	mov    0x80109004,%eax
801031e0:	8d 50 01             	lea    0x1(%eax),%edx
801031e3:	89 15 04 90 10 80    	mov    %edx,0x80109004
801031e9:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801031ec:	83 ec 0c             	sub    $0xc,%esp
801031ef:	68 e0 95 10 80       	push   $0x801095e0
801031f4:	e8 20 0c 00 00       	call   80103e19 <release>
  if((p->kstack = kalloc()) == 0){
801031f9:	e8 62 ef ff ff       	call   80102160 <kalloc>
801031fe:	89 43 08             	mov    %eax,0x8(%ebx)
80103201:	83 c4 10             	add    $0x10,%esp
80103204:	85 c0                	test   %eax,%eax
80103206:	74 b9                	je     801031c1 <allocproc+0x4d>
  sp -= sizeof *p->tf;
80103208:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
8010320e:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103211:	c7 80 b0 0f 00 00 02 	movl   $0x80104f02,0xfb0(%eax)
80103218:	4f 10 80 
  sp -= sizeof *p->context;
8010321b:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
80103220:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103223:	83 ec 04             	sub    $0x4,%esp
80103226:	6a 14                	push   $0x14
80103228:	6a 00                	push   $0x0
8010322a:	50                   	push   %eax
8010322b:	e8 30 0c 00 00       	call   80103e60 <memset>
  p->context->eip = (uint)forkret;
80103230:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103233:	c7 40 10 4c 32 10 80 	movl   $0x8010324c,0x10(%eax)
  p->start_ticks = ticks;
8010323a:	a1 80 45 11 80       	mov    0x80114580,%eax
8010323f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  return p;
80103242:	83 c4 10             	add    $0x10,%esp
}
80103245:	89 d8                	mov    %ebx,%eax
80103247:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010324a:	c9                   	leave  
8010324b:	c3                   	ret    

8010324c <forkret>:
{
8010324c:	55                   	push   %ebp
8010324d:	89 e5                	mov    %esp,%ebp
8010324f:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
80103252:	68 e0 95 10 80       	push   $0x801095e0
80103257:	e8 bd 0b 00 00       	call   80103e19 <release>
  if (first) {
8010325c:	83 c4 10             	add    $0x10,%esp
8010325f:	83 3d 00 90 10 80 00 	cmpl   $0x0,0x80109000
80103266:	75 02                	jne    8010326a <forkret+0x1e>
}
80103268:	c9                   	leave  
80103269:	c3                   	ret    
    first = 0;
8010326a:	c7 05 00 90 10 80 00 	movl   $0x0,0x80109000
80103271:	00 00 00 
    iinit(ROOTDEV);
80103274:	83 ec 0c             	sub    $0xc,%esp
80103277:	6a 01                	push   $0x1
80103279:	e8 8a e0 ff ff       	call   80101308 <iinit>
    initlog(ROOTDEV);
8010327e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103285:	e8 90 f4 ff ff       	call   8010271a <initlog>
8010328a:	83 c4 10             	add    $0x10,%esp
}
8010328d:	eb d9                	jmp    80103268 <forkret+0x1c>

8010328f <pinit>:
{
8010328f:	55                   	push   %ebp
80103290:	89 e5                	mov    %esp,%ebp
80103292:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103295:	68 f5 6a 10 80       	push   $0x80106af5
8010329a:	68 e0 95 10 80       	push   $0x801095e0
8010329f:	e8 c6 09 00 00       	call   80103c6a <initlock>
}
801032a4:	83 c4 10             	add    $0x10,%esp
801032a7:	c9                   	leave  
801032a8:	c3                   	ret    

801032a9 <mycpu>:
{
801032a9:	55                   	push   %ebp
801032aa:	89 e5                	mov    %esp,%ebp
801032ac:	56                   	push   %esi
801032ad:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801032ae:	9c                   	pushf  
801032af:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801032b0:	f6 c4 02             	test   $0x2,%ah
801032b3:	75 4a                	jne    801032ff <mycpu+0x56>
  apicid = lapicid();
801032b5:	e8 88 f1 ff ff       	call   80102442 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801032ba:	8b 35 60 3d 11 80    	mov    0x80113d60,%esi
801032c0:	85 f6                	test   %esi,%esi
801032c2:	7e 4f                	jle    80103313 <mycpu+0x6a>
    if (cpus[i].apicid == apicid) {
801032c4:	0f b6 15 e0 37 11 80 	movzbl 0x801137e0,%edx
801032cb:	39 d0                	cmp    %edx,%eax
801032cd:	74 3d                	je     8010330c <mycpu+0x63>
801032cf:	b9 90 38 11 80       	mov    $0x80113890,%ecx
  for (i = 0; i < ncpu; ++i) {
801032d4:	ba 00 00 00 00       	mov    $0x0,%edx
801032d9:	83 c2 01             	add    $0x1,%edx
801032dc:	39 f2                	cmp    %esi,%edx
801032de:	74 33                	je     80103313 <mycpu+0x6a>
    if (cpus[i].apicid == apicid) {
801032e0:	0f b6 19             	movzbl (%ecx),%ebx
801032e3:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801032e9:	39 c3                	cmp    %eax,%ebx
801032eb:	75 ec                	jne    801032d9 <mycpu+0x30>
      return &cpus[i];
801032ed:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
801032f3:	05 e0 37 11 80       	add    $0x801137e0,%eax
}
801032f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801032fb:	5b                   	pop    %ebx
801032fc:	5e                   	pop    %esi
801032fd:	5d                   	pop    %ebp
801032fe:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
801032ff:	83 ec 0c             	sub    $0xc,%esp
80103302:	68 08 6c 10 80       	push   $0x80106c08
80103307:	e8 38 d0 ff ff       	call   80100344 <panic>
  for (i = 0; i < ncpu; ++i) {
8010330c:	ba 00 00 00 00       	mov    $0x0,%edx
80103311:	eb da                	jmp    801032ed <mycpu+0x44>
  panic("unknown apicid\n");
80103313:	83 ec 0c             	sub    $0xc,%esp
80103316:	68 fc 6a 10 80       	push   $0x80106afc
8010331b:	e8 24 d0 ff ff       	call   80100344 <panic>

80103320 <cpuid>:
cpuid() {
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103326:	e8 7e ff ff ff       	call   801032a9 <mycpu>
8010332b:	2d e0 37 11 80       	sub    $0x801137e0,%eax
80103330:	c1 f8 04             	sar    $0x4,%eax
80103333:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103339:	c9                   	leave  
8010333a:	c3                   	ret    

8010333b <myproc>:
myproc(void) {
8010333b:	55                   	push   %ebp
8010333c:	89 e5                	mov    %esp,%ebp
8010333e:	53                   	push   %ebx
8010333f:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103342:	e8 9a 09 00 00       	call   80103ce1 <pushcli>
  c = mycpu();
80103347:	e8 5d ff ff ff       	call   801032a9 <mycpu>
  p = c->proc;
8010334c:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103352:	e8 c7 09 00 00       	call   80103d1e <popcli>
}
80103357:	89 d8                	mov    %ebx,%eax
80103359:	83 c4 04             	add    $0x4,%esp
8010335c:	5b                   	pop    %ebx
8010335d:	5d                   	pop    %ebp
8010335e:	c3                   	ret    

8010335f <userinit>:
{
8010335f:	55                   	push   %ebp
80103360:	89 e5                	mov    %esp,%ebp
80103362:	53                   	push   %ebx
80103363:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103366:	e8 09 fe ff ff       	call   80103174 <allocproc>
8010336b:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010336d:	a3 c0 95 10 80       	mov    %eax,0x801095c0
  if((p->pgdir = setupkvm()) == 0)
80103372:	e8 e7 2f 00 00       	call   8010635e <setupkvm>
80103377:	89 43 04             	mov    %eax,0x4(%ebx)
8010337a:	85 c0                	test   %eax,%eax
8010337c:	0f 84 b7 00 00 00    	je     80103439 <userinit+0xda>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103382:	83 ec 04             	sub    $0x4,%esp
80103385:	68 2c 00 00 00       	push   $0x2c
8010338a:	68 60 94 10 80       	push   $0x80109460
8010338f:	50                   	push   %eax
80103390:	e8 c2 2c 00 00       	call   80106057 <inituvm>
  p->sz = PGSIZE;
80103395:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010339b:	83 c4 0c             	add    $0xc,%esp
8010339e:	6a 4c                	push   $0x4c
801033a0:	6a 00                	push   $0x0
801033a2:	ff 73 18             	pushl  0x18(%ebx)
801033a5:	e8 b6 0a 00 00       	call   80103e60 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801033aa:	8b 43 18             	mov    0x18(%ebx),%eax
801033ad:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801033b3:	8b 43 18             	mov    0x18(%ebx),%eax
801033b6:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
801033bc:	8b 43 18             	mov    0x18(%ebx),%eax
801033bf:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801033c3:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801033c7:	8b 43 18             	mov    0x18(%ebx),%eax
801033ca:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801033ce:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801033d2:	8b 43 18             	mov    0x18(%ebx),%eax
801033d5:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801033dc:	8b 43 18             	mov    0x18(%ebx),%eax
801033df:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801033e6:	8b 43 18             	mov    0x18(%ebx),%eax
801033e9:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801033f0:	83 c4 0c             	add    $0xc,%esp
801033f3:	6a 10                	push   $0x10
801033f5:	68 25 6b 10 80       	push   $0x80106b25
801033fa:	8d 43 6c             	lea    0x6c(%ebx),%eax
801033fd:	50                   	push   %eax
801033fe:	e8 ec 0b 00 00       	call   80103fef <safestrcpy>
  p->cwd = namei("/");
80103403:	c7 04 24 2e 6b 10 80 	movl   $0x80106b2e,(%esp)
8010340a:	e8 76 e8 ff ff       	call   80101c85 <namei>
8010340f:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103412:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
80103419:	e8 94 09 00 00       	call   80103db2 <acquire>
  p->state = RUNNABLE;
8010341e:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103425:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
8010342c:	e8 e8 09 00 00       	call   80103e19 <release>
}
80103431:	83 c4 10             	add    $0x10,%esp
80103434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103437:	c9                   	leave  
80103438:	c3                   	ret    
    panic("userinit: out of memory?");
80103439:	83 ec 0c             	sub    $0xc,%esp
8010343c:	68 0c 6b 10 80       	push   $0x80106b0c
80103441:	e8 fe ce ff ff       	call   80100344 <panic>

80103446 <growproc>:
{
80103446:	55                   	push   %ebp
80103447:	89 e5                	mov    %esp,%ebp
80103449:	56                   	push   %esi
8010344a:	53                   	push   %ebx
8010344b:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010344e:	e8 e8 fe ff ff       	call   8010333b <myproc>
80103453:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103455:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103457:	85 f6                	test   %esi,%esi
80103459:	7f 21                	jg     8010347c <growproc+0x36>
  } else if(n < 0){
8010345b:	85 f6                	test   %esi,%esi
8010345d:	79 33                	jns    80103492 <growproc+0x4c>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010345f:	83 ec 04             	sub    $0x4,%esp
80103462:	01 c6                	add    %eax,%esi
80103464:	56                   	push   %esi
80103465:	50                   	push   %eax
80103466:	ff 73 04             	pushl  0x4(%ebx)
80103469:	e8 00 2d 00 00       	call   8010616e <deallocuvm>
8010346e:	83 c4 10             	add    $0x10,%esp
80103471:	85 c0                	test   %eax,%eax
80103473:	75 1d                	jne    80103492 <growproc+0x4c>
      return -1;
80103475:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010347a:	eb 29                	jmp    801034a5 <growproc+0x5f>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010347c:	83 ec 04             	sub    $0x4,%esp
8010347f:	01 c6                	add    %eax,%esi
80103481:	56                   	push   %esi
80103482:	50                   	push   %eax
80103483:	ff 73 04             	pushl  0x4(%ebx)
80103486:	e8 72 2d 00 00       	call   801061fd <allocuvm>
8010348b:	83 c4 10             	add    $0x10,%esp
8010348e:	85 c0                	test   %eax,%eax
80103490:	74 1a                	je     801034ac <growproc+0x66>
  curproc->sz = sz;
80103492:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103494:	83 ec 0c             	sub    $0xc,%esp
80103497:	53                   	push   %ebx
80103498:	e8 bc 2a 00 00       	call   80105f59 <switchuvm>
  return 0;
8010349d:	83 c4 10             	add    $0x10,%esp
801034a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801034a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034a8:	5b                   	pop    %ebx
801034a9:	5e                   	pop    %esi
801034aa:	5d                   	pop    %ebp
801034ab:	c3                   	ret    
      return -1;
801034ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034b1:	eb f2                	jmp    801034a5 <growproc+0x5f>

801034b3 <fork>:
{
801034b3:	55                   	push   %ebp
801034b4:	89 e5                	mov    %esp,%ebp
801034b6:	57                   	push   %edi
801034b7:	56                   	push   %esi
801034b8:	53                   	push   %ebx
801034b9:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
801034bc:	e8 7a fe ff ff       	call   8010333b <myproc>
801034c1:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801034c3:	e8 ac fc ff ff       	call   80103174 <allocproc>
801034c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034cb:	85 c0                	test   %eax,%eax
801034cd:	0f 84 e0 00 00 00    	je     801035b3 <fork+0x100>
801034d3:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801034d5:	83 ec 08             	sub    $0x8,%esp
801034d8:	ff 33                	pushl  (%ebx)
801034da:	ff 73 04             	pushl  0x4(%ebx)
801034dd:	e8 2d 2f 00 00       	call   8010640f <copyuvm>
801034e2:	89 47 04             	mov    %eax,0x4(%edi)
801034e5:	83 c4 10             	add    $0x10,%esp
801034e8:	85 c0                	test   %eax,%eax
801034ea:	74 2a                	je     80103516 <fork+0x63>
  np->sz = curproc->sz;
801034ec:	8b 03                	mov    (%ebx),%eax
801034ee:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801034f1:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
801034f3:	89 c8                	mov    %ecx,%eax
801034f5:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
801034f8:	8b 73 18             	mov    0x18(%ebx),%esi
801034fb:	8b 79 18             	mov    0x18(%ecx),%edi
801034fe:	b9 13 00 00 00       	mov    $0x13,%ecx
80103503:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103505:	8b 40 18             	mov    0x18(%eax),%eax
80103508:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010350f:	be 00 00 00 00       	mov    $0x0,%esi
80103514:	eb 2e                	jmp    80103544 <fork+0x91>
    kfree(np->kstack);
80103516:	83 ec 0c             	sub    $0xc,%esp
80103519:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010351c:	ff 73 08             	pushl  0x8(%ebx)
8010351f:	e8 17 eb ff ff       	call   8010203b <kfree>
    np->kstack = 0;
80103524:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010352b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103532:	83 c4 10             	add    $0x10,%esp
80103535:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010353a:	eb 6f                	jmp    801035ab <fork+0xf8>
  for(i = 0; i < NOFILE; i++)
8010353c:	83 c6 01             	add    $0x1,%esi
8010353f:	83 fe 10             	cmp    $0x10,%esi
80103542:	74 1d                	je     80103561 <fork+0xae>
    if(curproc->ofile[i])
80103544:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103548:	85 c0                	test   %eax,%eax
8010354a:	74 f0                	je     8010353c <fork+0x89>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010354c:	83 ec 0c             	sub    $0xc,%esp
8010354f:	50                   	push   %eax
80103550:	e8 82 d7 ff ff       	call   80100cd7 <filedup>
80103555:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103558:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
8010355c:	83 c4 10             	add    $0x10,%esp
8010355f:	eb db                	jmp    8010353c <fork+0x89>
  np->cwd = idup(curproc->cwd);
80103561:	83 ec 0c             	sub    $0xc,%esp
80103564:	ff 73 68             	pushl  0x68(%ebx)
80103567:	e8 51 df ff ff       	call   801014bd <idup>
8010356c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010356f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103572:	83 c4 0c             	add    $0xc,%esp
80103575:	6a 10                	push   $0x10
80103577:	83 c3 6c             	add    $0x6c,%ebx
8010357a:	53                   	push   %ebx
8010357b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010357e:	50                   	push   %eax
8010357f:	e8 6b 0a 00 00       	call   80103fef <safestrcpy>
  pid = np->pid;
80103584:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103587:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
8010358e:	e8 1f 08 00 00       	call   80103db2 <acquire>
  np->state = RUNNABLE;
80103593:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
8010359a:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
801035a1:	e8 73 08 00 00       	call   80103e19 <release>
  return pid;
801035a6:	89 d8                	mov    %ebx,%eax
801035a8:	83 c4 10             	add    $0x10,%esp
}
801035ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035ae:	5b                   	pop    %ebx
801035af:	5e                   	pop    %esi
801035b0:	5f                   	pop    %edi
801035b1:	5d                   	pop    %ebp
801035b2:	c3                   	ret    
    return -1;
801035b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035b8:	eb f1                	jmp    801035ab <fork+0xf8>

801035ba <scheduler>:
{
801035ba:	55                   	push   %ebp
801035bb:	89 e5                	mov    %esp,%ebp
801035bd:	57                   	push   %edi
801035be:	56                   	push   %esi
801035bf:	53                   	push   %ebx
801035c0:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801035c3:	e8 e1 fc ff ff       	call   801032a9 <mycpu>
801035c8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801035ca:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801035d1:	00 00 00 
801035d4:	eb 66                	jmp    8010363c <scheduler+0x82>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801035d6:	83 eb 80             	sub    $0xffffff80,%ebx
801035d9:	81 fb 14 b6 10 80    	cmp    $0x8010b614,%ebx
801035df:	73 43                	jae    80103624 <scheduler+0x6a>
      if(p->state != RUNNABLE)
801035e1:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801035e5:	75 ef                	jne    801035d6 <scheduler+0x1c>
      c->proc = p;
801035e7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801035ed:	83 ec 0c             	sub    $0xc,%esp
801035f0:	53                   	push   %ebx
801035f1:	e8 63 29 00 00       	call   80105f59 <switchuvm>
      p->state = RUNNING;
801035f6:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801035fd:	83 c4 08             	add    $0x8,%esp
80103600:	ff 73 1c             	pushl  0x1c(%ebx)
80103603:	57                   	push   %edi
80103604:	e8 3c 0a 00 00       	call   80104045 <swtch>
      switchkvm();
80103609:	e8 39 29 00 00       	call   80105f47 <switchkvm>
      c->proc = 0;
8010360e:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103615:	00 00 00 
80103618:	83 c4 10             	add    $0x10,%esp
      idle = 0;  // not idle this timeslice
8010361b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103622:	eb b2                	jmp    801035d6 <scheduler+0x1c>
    release(&ptable.lock);
80103624:	83 ec 0c             	sub    $0xc,%esp
80103627:	68 e0 95 10 80       	push   $0x801095e0
8010362c:	e8 e8 07 00 00       	call   80103e19 <release>
    if (idle) {
80103631:	83 c4 10             	add    $0x10,%esp
80103634:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80103638:	74 02                	je     8010363c <scheduler+0x82>
  asm volatile("sti");
8010363a:	fb                   	sti    

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
  asm volatile("hlt");
8010363b:	f4                   	hlt    
8010363c:	fb                   	sti    
    acquire(&ptable.lock);
8010363d:	83 ec 0c             	sub    $0xc,%esp
80103640:	68 e0 95 10 80       	push   $0x801095e0
80103645:	e8 68 07 00 00       	call   80103db2 <acquire>
8010364a:	83 c4 10             	add    $0x10,%esp
    idle = 1;  // assume idle unless we schedule a process
8010364d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103654:	bb 14 96 10 80       	mov    $0x80109614,%ebx
      swtch(&(c->scheduler), p->context);
80103659:	8d 7e 04             	lea    0x4(%esi),%edi
8010365c:	eb 83                	jmp    801035e1 <scheduler+0x27>

8010365e <sched>:
{
8010365e:	55                   	push   %ebp
8010365f:	89 e5                	mov    %esp,%ebp
80103661:	56                   	push   %esi
80103662:	53                   	push   %ebx
  struct proc *p = myproc();
80103663:	e8 d3 fc ff ff       	call   8010333b <myproc>
80103668:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
8010366a:	83 ec 0c             	sub    $0xc,%esp
8010366d:	68 e0 95 10 80       	push   $0x801095e0
80103672:	e8 07 07 00 00       	call   80103d7e <holding>
80103677:	83 c4 10             	add    $0x10,%esp
8010367a:	85 c0                	test   %eax,%eax
8010367c:	74 4f                	je     801036cd <sched+0x6f>
  if(mycpu()->ncli != 1)
8010367e:	e8 26 fc ff ff       	call   801032a9 <mycpu>
80103683:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010368a:	75 4e                	jne    801036da <sched+0x7c>
  if(p->state == RUNNING)
8010368c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103690:	74 55                	je     801036e7 <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103692:	9c                   	pushf  
80103693:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103694:	f6 c4 02             	test   $0x2,%ah
80103697:	75 5b                	jne    801036f4 <sched+0x96>
  intena = mycpu()->intena;
80103699:	e8 0b fc ff ff       	call   801032a9 <mycpu>
8010369e:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801036a4:	e8 00 fc ff ff       	call   801032a9 <mycpu>
801036a9:	83 ec 08             	sub    $0x8,%esp
801036ac:	ff 70 04             	pushl  0x4(%eax)
801036af:	83 c3 1c             	add    $0x1c,%ebx
801036b2:	53                   	push   %ebx
801036b3:	e8 8d 09 00 00       	call   80104045 <swtch>
  mycpu()->intena = intena;
801036b8:	e8 ec fb ff ff       	call   801032a9 <mycpu>
801036bd:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801036c3:	83 c4 10             	add    $0x10,%esp
801036c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036c9:	5b                   	pop    %ebx
801036ca:	5e                   	pop    %esi
801036cb:	5d                   	pop    %ebp
801036cc:	c3                   	ret    
    panic("sched ptable.lock");
801036cd:	83 ec 0c             	sub    $0xc,%esp
801036d0:	68 30 6b 10 80       	push   $0x80106b30
801036d5:	e8 6a cc ff ff       	call   80100344 <panic>
    panic("sched locks");
801036da:	83 ec 0c             	sub    $0xc,%esp
801036dd:	68 42 6b 10 80       	push   $0x80106b42
801036e2:	e8 5d cc ff ff       	call   80100344 <panic>
    panic("sched running");
801036e7:	83 ec 0c             	sub    $0xc,%esp
801036ea:	68 4e 6b 10 80       	push   $0x80106b4e
801036ef:	e8 50 cc ff ff       	call   80100344 <panic>
    panic("sched interruptible");
801036f4:	83 ec 0c             	sub    $0xc,%esp
801036f7:	68 5c 6b 10 80       	push   $0x80106b5c
801036fc:	e8 43 cc ff ff       	call   80100344 <panic>

80103701 <exit>:
{
80103701:	55                   	push   %ebp
80103702:	89 e5                	mov    %esp,%ebp
80103704:	57                   	push   %edi
80103705:	56                   	push   %esi
80103706:	53                   	push   %ebx
80103707:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
8010370a:	e8 2c fc ff ff       	call   8010333b <myproc>
8010370f:	89 c6                	mov    %eax,%esi
80103711:	8d 58 28             	lea    0x28(%eax),%ebx
80103714:	8d 78 68             	lea    0x68(%eax),%edi
  if(curproc == initproc)
80103717:	39 05 c0 95 10 80    	cmp    %eax,0x801095c0
8010371d:	75 14                	jne    80103733 <exit+0x32>
    panic("init exiting");
8010371f:	83 ec 0c             	sub    $0xc,%esp
80103722:	68 70 6b 10 80       	push   $0x80106b70
80103727:	e8 18 cc ff ff       	call   80100344 <panic>
8010372c:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
8010372f:	39 df                	cmp    %ebx,%edi
80103731:	74 1a                	je     8010374d <exit+0x4c>
    if(curproc->ofile[fd]){
80103733:	8b 03                	mov    (%ebx),%eax
80103735:	85 c0                	test   %eax,%eax
80103737:	74 f3                	je     8010372c <exit+0x2b>
      fileclose(curproc->ofile[fd]);
80103739:	83 ec 0c             	sub    $0xc,%esp
8010373c:	50                   	push   %eax
8010373d:	e8 da d5 ff ff       	call   80100d1c <fileclose>
      curproc->ofile[fd] = 0;
80103742:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103748:	83 c4 10             	add    $0x10,%esp
8010374b:	eb df                	jmp    8010372c <exit+0x2b>
  begin_op();
8010374d:	e8 5d f0 ff ff       	call   801027af <begin_op>
  iput(curproc->cwd);
80103752:	83 ec 0c             	sub    $0xc,%esp
80103755:	ff 76 68             	pushl  0x68(%esi)
80103758:	e8 92 de ff ff       	call   801015ef <iput>
  end_op();
8010375d:	e8 c8 f0 ff ff       	call   8010282a <end_op>
  curproc->cwd = 0;
80103762:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103769:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
80103770:	e8 3d 06 00 00       	call   80103db2 <acquire>
  wakeup1(curproc->parent);
80103775:	8b 46 14             	mov    0x14(%esi),%eax
80103778:	e8 cc f9 ff ff       	call   80103149 <wakeup1>
8010377d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103780:	bb 14 96 10 80       	mov    $0x80109614,%ebx
80103785:	eb 0b                	jmp    80103792 <exit+0x91>
80103787:	83 eb 80             	sub    $0xffffff80,%ebx
8010378a:	81 fb 14 b6 10 80    	cmp    $0x8010b614,%ebx
80103790:	73 1a                	jae    801037ac <exit+0xab>
    if(p->parent == curproc){
80103792:	39 73 14             	cmp    %esi,0x14(%ebx)
80103795:	75 f0                	jne    80103787 <exit+0x86>
      p->parent = initproc;
80103797:	a1 c0 95 10 80       	mov    0x801095c0,%eax
8010379c:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
8010379f:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801037a3:	75 e2                	jne    80103787 <exit+0x86>
        wakeup1(initproc);
801037a5:	e8 9f f9 ff ff       	call   80103149 <wakeup1>
801037aa:	eb db                	jmp    80103787 <exit+0x86>
  curproc->state = ZOMBIE;
801037ac:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801037b3:	e8 a6 fe ff ff       	call   8010365e <sched>
  panic("zombie exit");
801037b8:	83 ec 0c             	sub    $0xc,%esp
801037bb:	68 7d 6b 10 80       	push   $0x80106b7d
801037c0:	e8 7f cb ff ff       	call   80100344 <panic>

801037c5 <yield>:
{
801037c5:	55                   	push   %ebp
801037c6:	89 e5                	mov    %esp,%ebp
801037c8:	53                   	push   %ebx
801037c9:	83 ec 04             	sub    $0x4,%esp
  struct proc *curproc = myproc();
801037cc:	e8 6a fb ff ff       	call   8010333b <myproc>
801037d1:	89 c3                	mov    %eax,%ebx
  acquire(&ptable.lock);  //DOC: yieldlock
801037d3:	83 ec 0c             	sub    $0xc,%esp
801037d6:	68 e0 95 10 80       	push   $0x801095e0
801037db:	e8 d2 05 00 00       	call   80103db2 <acquire>
  curproc->state = RUNNABLE;
801037e0:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801037e7:	e8 72 fe ff ff       	call   8010365e <sched>
  release(&ptable.lock);
801037ec:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
801037f3:	e8 21 06 00 00       	call   80103e19 <release>
}
801037f8:	83 c4 10             	add    $0x10,%esp
801037fb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037fe:	c9                   	leave  
801037ff:	c3                   	ret    

80103800 <sleep>:
{
80103800:	55                   	push   %ebp
80103801:	89 e5                	mov    %esp,%ebp
80103803:	57                   	push   %edi
80103804:	56                   	push   %esi
80103805:	53                   	push   %ebx
80103806:	83 ec 0c             	sub    $0xc,%esp
80103809:	8b 7d 08             	mov    0x8(%ebp),%edi
8010380c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
8010380f:	e8 27 fb ff ff       	call   8010333b <myproc>
  if(p == 0)
80103814:	85 c0                	test   %eax,%eax
80103816:	74 56                	je     8010386e <sleep+0x6e>
80103818:	89 c3                	mov    %eax,%ebx
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010381a:	81 fe e0 95 10 80    	cmp    $0x801095e0,%esi
80103820:	74 59                	je     8010387b <sleep+0x7b>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103822:	83 ec 0c             	sub    $0xc,%esp
80103825:	68 e0 95 10 80       	push   $0x801095e0
8010382a:	e8 83 05 00 00       	call   80103db2 <acquire>
    if (lk) release(lk);
8010382f:	83 c4 10             	add    $0x10,%esp
80103832:	85 f6                	test   %esi,%esi
80103834:	74 63                	je     80103899 <sleep+0x99>
80103836:	83 ec 0c             	sub    $0xc,%esp
80103839:	56                   	push   %esi
8010383a:	e8 da 05 00 00       	call   80103e19 <release>
  p->chan = chan;
8010383f:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103842:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103849:	e8 10 fe ff ff       	call   8010365e <sched>
  p->chan = 0;
8010384e:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103855:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
8010385c:	e8 b8 05 00 00       	call   80103e19 <release>
    if (lk) acquire(lk);
80103861:	89 34 24             	mov    %esi,(%esp)
80103864:	e8 49 05 00 00       	call   80103db2 <acquire>
80103869:	83 c4 10             	add    $0x10,%esp
}
8010386c:	eb 23                	jmp    80103891 <sleep+0x91>
    panic("sleep");
8010386e:	83 ec 0c             	sub    $0xc,%esp
80103871:	68 89 6b 10 80       	push   $0x80106b89
80103876:	e8 c9 ca ff ff       	call   80100344 <panic>
  p->chan = chan;
8010387b:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
8010387e:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103885:	e8 d4 fd ff ff       	call   8010365e <sched>
  p->chan = 0;
8010388a:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103891:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103894:	5b                   	pop    %ebx
80103895:	5e                   	pop    %esi
80103896:	5f                   	pop    %edi
80103897:	5d                   	pop    %ebp
80103898:	c3                   	ret    
  p->chan = chan;
80103899:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010389c:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801038a3:	e8 b6 fd ff ff       	call   8010365e <sched>
  p->chan = 0;
801038a8:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801038af:	83 ec 0c             	sub    $0xc,%esp
801038b2:	68 e0 95 10 80       	push   $0x801095e0
801038b7:	e8 5d 05 00 00       	call   80103e19 <release>
801038bc:	83 c4 10             	add    $0x10,%esp
801038bf:	eb d0                	jmp    80103891 <sleep+0x91>

801038c1 <wait>:
{
801038c1:	55                   	push   %ebp
801038c2:	89 e5                	mov    %esp,%ebp
801038c4:	57                   	push   %edi
801038c5:	56                   	push   %esi
801038c6:	53                   	push   %ebx
801038c7:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801038ca:	e8 6c fa ff ff       	call   8010333b <myproc>
801038cf:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801038d1:	83 ec 0c             	sub    $0xc,%esp
801038d4:	68 e0 95 10 80       	push   $0x801095e0
801038d9:	e8 d4 04 00 00       	call   80103db2 <acquire>
801038de:	83 c4 10             	add    $0x10,%esp
      havekids = 1;
801038e1:	bf 01 00 00 00       	mov    $0x1,%edi
    havekids = 0;
801038e6:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038eb:	bb 14 96 10 80       	mov    $0x80109614,%ebx
801038f0:	eb 64                	jmp    80103956 <wait+0x95>
        pid = p->pid;
801038f2:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801038f5:	83 ec 0c             	sub    $0xc,%esp
801038f8:	ff 73 08             	pushl  0x8(%ebx)
801038fb:	e8 3b e7 ff ff       	call   8010203b <kfree>
        p->kstack = 0;
80103900:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103907:	83 c4 04             	add    $0x4,%esp
8010390a:	ff 73 04             	pushl  0x4(%ebx)
8010390d:	e8 d9 29 00 00       	call   801062eb <freevm>
        p->pid = 0;
80103912:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103919:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103920:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103924:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010392b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103932:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
80103939:	e8 db 04 00 00       	call   80103e19 <release>
        return pid;
8010393e:	89 f0                	mov    %esi,%eax
80103940:	83 c4 10             	add    $0x10,%esp
}
80103943:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103946:	5b                   	pop    %ebx
80103947:	5e                   	pop    %esi
80103948:	5f                   	pop    %edi
80103949:	5d                   	pop    %ebp
8010394a:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010394b:	83 eb 80             	sub    $0xffffff80,%ebx
8010394e:	81 fb 14 b6 10 80    	cmp    $0x8010b614,%ebx
80103954:	73 0f                	jae    80103965 <wait+0xa4>
      if(p->parent != curproc)
80103956:	39 73 14             	cmp    %esi,0x14(%ebx)
80103959:	75 f0                	jne    8010394b <wait+0x8a>
      if(p->state == ZOMBIE){
8010395b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010395f:	74 91                	je     801038f2 <wait+0x31>
      havekids = 1;
80103961:	89 f8                	mov    %edi,%eax
80103963:	eb e6                	jmp    8010394b <wait+0x8a>
    if(!havekids || curproc->killed){
80103965:	85 c0                	test   %eax,%eax
80103967:	74 06                	je     8010396f <wait+0xae>
80103969:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
8010396d:	74 17                	je     80103986 <wait+0xc5>
      release(&ptable.lock);
8010396f:	83 ec 0c             	sub    $0xc,%esp
80103972:	68 e0 95 10 80       	push   $0x801095e0
80103977:	e8 9d 04 00 00       	call   80103e19 <release>
      return -1;
8010397c:	83 c4 10             	add    $0x10,%esp
8010397f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103984:	eb bd                	jmp    80103943 <wait+0x82>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103986:	83 ec 08             	sub    $0x8,%esp
80103989:	68 e0 95 10 80       	push   $0x801095e0
8010398e:	56                   	push   %esi
8010398f:	e8 6c fe ff ff       	call   80103800 <sleep>
    havekids = 0;
80103994:	83 c4 10             	add    $0x10,%esp
80103997:	e9 4a ff ff ff       	jmp    801038e6 <wait+0x25>

8010399c <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010399c:	55                   	push   %ebp
8010399d:	89 e5                	mov    %esp,%ebp
8010399f:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801039a2:	68 e0 95 10 80       	push   $0x801095e0
801039a7:	e8 06 04 00 00       	call   80103db2 <acquire>
  wakeup1(chan);
801039ac:	8b 45 08             	mov    0x8(%ebp),%eax
801039af:	e8 95 f7 ff ff       	call   80103149 <wakeup1>
  release(&ptable.lock);
801039b4:	c7 04 24 e0 95 10 80 	movl   $0x801095e0,(%esp)
801039bb:	e8 59 04 00 00       	call   80103e19 <release>
}
801039c0:	83 c4 10             	add    $0x10,%esp
801039c3:	c9                   	leave  
801039c4:	c3                   	ret    

801039c5 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801039c5:	55                   	push   %ebp
801039c6:	89 e5                	mov    %esp,%ebp
801039c8:	53                   	push   %ebx
801039c9:	83 ec 10             	sub    $0x10,%esp
801039cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801039cf:	68 e0 95 10 80       	push   $0x801095e0
801039d4:	e8 d9 03 00 00       	call   80103db2 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
801039d9:	83 c4 10             	add    $0x10,%esp
801039dc:	39 1d 24 96 10 80    	cmp    %ebx,0x80109624
801039e2:	74 2d                	je     80103a11 <kill+0x4c>
801039e4:	89 da                	mov    %ebx,%edx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039e6:	b8 94 96 10 80       	mov    $0x80109694,%eax
    if(p->pid == pid){
801039eb:	39 50 10             	cmp    %edx,0x10(%eax)
801039ee:	74 26                	je     80103a16 <kill+0x51>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039f0:	83 e8 80             	sub    $0xffffff80,%eax
801039f3:	3d 14 b6 10 80       	cmp    $0x8010b614,%eax
801039f8:	72 f1                	jb     801039eb <kill+0x26>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801039fa:	83 ec 0c             	sub    $0xc,%esp
801039fd:	68 e0 95 10 80       	push   $0x801095e0
80103a02:	e8 12 04 00 00       	call   80103e19 <release>
  return -1;
80103a07:	83 c4 10             	add    $0x10,%esp
80103a0a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a0f:	eb 27                	jmp    80103a38 <kill+0x73>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a11:	b8 14 96 10 80       	mov    $0x80109614,%eax
      p->killed = 1;
80103a16:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103a1d:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103a21:	74 1a                	je     80103a3d <kill+0x78>
      release(&ptable.lock);
80103a23:	83 ec 0c             	sub    $0xc,%esp
80103a26:	68 e0 95 10 80       	push   $0x801095e0
80103a2b:	e8 e9 03 00 00       	call   80103e19 <release>
      return 0;
80103a30:	83 c4 10             	add    $0x10,%esp
80103a33:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a3b:	c9                   	leave  
80103a3c:	c3                   	ret    
        p->state = RUNNABLE;
80103a3d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103a44:	eb dd                	jmp    80103a23 <kill+0x5e>

80103a46 <procdump_P1_Helper>:
}

#ifdef CS333_P1
void
procdump_P1_Helper(struct proc *p)
{
80103a46:	55                   	push   %ebp
80103a47:	89 e5                	mov    %esp,%ebp
80103a49:	83 ec 14             	sub    $0x14,%esp
80103a4c:	8b 45 08             	mov    0x8(%ebp),%eax
    int seconds =(ticks-p->start_ticks)/1000;
80103a4f:	8b 0d 80 45 11 80    	mov    0x80114580,%ecx
80103a55:	2b 48 7c             	sub    0x7c(%eax),%ecx
    int miliseconds =(ticks-p->start_ticks)%1000;
    cprintf("%d%s%d\t%d\t",seconds,".",miliseconds,p->sz);
80103a58:	ff 30                	pushl  (%eax)
    int miliseconds =(ticks-p->start_ticks)%1000;
80103a5a:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80103a5f:	89 c8                	mov    %ecx,%eax
80103a61:	f7 e2                	mul    %edx
80103a63:	c1 ea 06             	shr    $0x6,%edx
80103a66:	69 c2 e8 03 00 00    	imul   $0x3e8,%edx,%eax
80103a6c:	29 c1                	sub    %eax,%ecx
    cprintf("%d%s%d\t%d\t",seconds,".",miliseconds,p->sz);
80103a6e:	51                   	push   %ecx
80103a6f:	68 10 6d 10 80       	push   $0x80106d10
80103a74:	52                   	push   %edx
80103a75:	68 8f 6b 10 80       	push   $0x80106b8f
80103a7a:	e8 62 cb ff ff       	call   801005e1 <cprintf>
}
80103a7f:	83 c4 20             	add    $0x20,%esp
80103a82:	c9                   	leave  
80103a83:	c3                   	ret    

80103a84 <procdump>:
{
80103a84:	55                   	push   %ebp
80103a85:	89 e5                	mov    %esp,%ebp
80103a87:	57                   	push   %edi
80103a88:	56                   	push   %esi
80103a89:	53                   	push   %ebx
80103a8a:	83 ec 40             	sub    $0x40,%esp
  cprintf("%s\t%s\t%s\t%s\t%s\t%s\n","PID","NAME","STATE","ELAPSED","SIZE","PC's");
80103a8d:	68 9e 6b 10 80       	push   $0x80106b9e
80103a92:	68 a3 6b 10 80       	push   $0x80106ba3
80103a97:	68 a8 6b 10 80       	push   $0x80106ba8
80103a9c:	68 b0 6b 10 80       	push   $0x80106bb0
80103aa1:	68 b6 6b 10 80       	push   $0x80106bb6
80103aa6:	68 bb 6b 10 80       	push   $0x80106bbb
80103aab:	68 bf 6b 10 80       	push   $0x80106bbf
80103ab0:	e8 2c cb ff ff       	call   801005e1 <cprintf>
80103ab5:	83 c4 20             	add    $0x20,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ab8:	bb 14 96 10 80       	mov    $0x80109614,%ebx
80103abd:	8d 7d e8             	lea    -0x18(%ebp),%edi
80103ac0:	eb 3e                	jmp    80103b00 <procdump+0x7c>
    cprintf("%d\t%s\t%s\t", p->pid, p->name, state);
80103ac2:	50                   	push   %eax
80103ac3:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ac6:	50                   	push   %eax
80103ac7:	ff 73 10             	pushl  0x10(%ebx)
80103aca:	68 d2 6b 10 80       	push   $0x80106bd2
80103acf:	e8 0d cb ff ff       	call   801005e1 <cprintf>
    procdump_P1_Helper(p);
80103ad4:	89 1c 24             	mov    %ebx,(%esp)
80103ad7:	e8 6a ff ff ff       	call   80103a46 <procdump_P1_Helper>
    if(p->state == SLEEPING){
80103adc:	83 c4 10             	add    $0x10,%esp
80103adf:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103ae3:	74 3f                	je     80103b24 <procdump+0xa0>
    cprintf("\n");
80103ae5:	83 ec 0c             	sub    $0xc,%esp
80103ae8:	68 4b 6f 10 80       	push   $0x80106f4b
80103aed:	e8 ef ca ff ff       	call   801005e1 <cprintf>
80103af2:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103af5:	83 eb 80             	sub    $0xffffff80,%ebx
80103af8:	81 fb 14 b6 10 80    	cmp    $0x8010b614,%ebx
80103afe:	73 7b                	jae    80103b7b <procdump+0xf7>
    if(p->state == UNUSED)
80103b00:	8b 53 0c             	mov    0xc(%ebx),%edx
80103b03:	85 d2                	test   %edx,%edx
80103b05:	74 ee                	je     80103af5 <procdump+0x71>
      state = "???";
80103b07:	b8 9a 6b 10 80       	mov    $0x80106b9a,%eax
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103b0c:	83 fa 05             	cmp    $0x5,%edx
80103b0f:	77 b1                	ja     80103ac2 <procdump+0x3e>
80103b11:	8b 04 95 30 6c 10 80 	mov    -0x7fef93d0(,%edx,4),%eax
80103b18:	85 c0                	test   %eax,%eax
      state = "???";
80103b1a:	ba 9a 6b 10 80       	mov    $0x80106b9a,%edx
80103b1f:	0f 44 c2             	cmove  %edx,%eax
80103b22:	eb 9e                	jmp    80103ac2 <procdump+0x3e>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103b24:	83 ec 08             	sub    $0x8,%esp
80103b27:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103b2a:	50                   	push   %eax
80103b2b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103b2e:	8b 40 0c             	mov    0xc(%eax),%eax
80103b31:	83 c0 08             	add    $0x8,%eax
80103b34:	50                   	push   %eax
80103b35:	e8 4b 01 00 00       	call   80103c85 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103b3a:	8b 45 c0             	mov    -0x40(%ebp),%eax
80103b3d:	83 c4 10             	add    $0x10,%esp
80103b40:	85 c0                	test   %eax,%eax
80103b42:	74 a1                	je     80103ae5 <procdump+0x61>
        cprintf(" %p", pc[i]);
80103b44:	83 ec 08             	sub    $0x8,%esp
80103b47:	50                   	push   %eax
80103b48:	68 e1 65 10 80       	push   $0x801065e1
80103b4d:	e8 8f ca ff ff       	call   801005e1 <cprintf>
80103b52:	8d 75 c4             	lea    -0x3c(%ebp),%esi
80103b55:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80103b58:	8b 06                	mov    (%esi),%eax
80103b5a:	85 c0                	test   %eax,%eax
80103b5c:	74 87                	je     80103ae5 <procdump+0x61>
        cprintf(" %p", pc[i]);
80103b5e:	83 ec 08             	sub    $0x8,%esp
80103b61:	50                   	push   %eax
80103b62:	68 e1 65 10 80       	push   $0x801065e1
80103b67:	e8 75 ca ff ff       	call   801005e1 <cprintf>
80103b6c:	83 c6 04             	add    $0x4,%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103b6f:	83 c4 10             	add    $0x10,%esp
80103b72:	39 f7                	cmp    %esi,%edi
80103b74:	75 e2                	jne    80103b58 <procdump+0xd4>
80103b76:	e9 6a ff ff ff       	jmp    80103ae5 <procdump+0x61>
}
80103b7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b7e:	5b                   	pop    %ebx
80103b7f:	5e                   	pop    %esi
80103b80:	5f                   	pop    %edi
80103b81:	5d                   	pop    %ebp
80103b82:	c3                   	ret    

80103b83 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103b83:	55                   	push   %ebp
80103b84:	89 e5                	mov    %esp,%ebp
80103b86:	53                   	push   %ebx
80103b87:	83 ec 0c             	sub    $0xc,%esp
80103b8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103b8d:	68 48 6c 10 80       	push   $0x80106c48
80103b92:	8d 43 04             	lea    0x4(%ebx),%eax
80103b95:	50                   	push   %eax
80103b96:	e8 cf 00 00 00       	call   80103c6a <initlock>
  lk->name = name;
80103b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103b9e:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103ba1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103ba7:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103bae:	83 c4 10             	add    $0x10,%esp
80103bb1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bb4:	c9                   	leave  
80103bb5:	c3                   	ret    

80103bb6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103bb6:	55                   	push   %ebp
80103bb7:	89 e5                	mov    %esp,%ebp
80103bb9:	56                   	push   %esi
80103bba:	53                   	push   %ebx
80103bbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103bbe:	8d 73 04             	lea    0x4(%ebx),%esi
80103bc1:	83 ec 0c             	sub    $0xc,%esp
80103bc4:	56                   	push   %esi
80103bc5:	e8 e8 01 00 00       	call   80103db2 <acquire>
  while (lk->locked) {
80103bca:	83 c4 10             	add    $0x10,%esp
80103bcd:	83 3b 00             	cmpl   $0x0,(%ebx)
80103bd0:	74 12                	je     80103be4 <acquiresleep+0x2e>
    sleep(lk, &lk->lk);
80103bd2:	83 ec 08             	sub    $0x8,%esp
80103bd5:	56                   	push   %esi
80103bd6:	53                   	push   %ebx
80103bd7:	e8 24 fc ff ff       	call   80103800 <sleep>
  while (lk->locked) {
80103bdc:	83 c4 10             	add    $0x10,%esp
80103bdf:	83 3b 00             	cmpl   $0x0,(%ebx)
80103be2:	75 ee                	jne    80103bd2 <acquiresleep+0x1c>
  }
  lk->locked = 1;
80103be4:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103bea:	e8 4c f7 ff ff       	call   8010333b <myproc>
80103bef:	8b 40 10             	mov    0x10(%eax),%eax
80103bf2:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103bf5:	83 ec 0c             	sub    $0xc,%esp
80103bf8:	56                   	push   %esi
80103bf9:	e8 1b 02 00 00       	call   80103e19 <release>
}
80103bfe:	83 c4 10             	add    $0x10,%esp
80103c01:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c04:	5b                   	pop    %ebx
80103c05:	5e                   	pop    %esi
80103c06:	5d                   	pop    %ebp
80103c07:	c3                   	ret    

80103c08 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103c08:	55                   	push   %ebp
80103c09:	89 e5                	mov    %esp,%ebp
80103c0b:	56                   	push   %esi
80103c0c:	53                   	push   %ebx
80103c0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103c10:	8d 73 04             	lea    0x4(%ebx),%esi
80103c13:	83 ec 0c             	sub    $0xc,%esp
80103c16:	56                   	push   %esi
80103c17:	e8 96 01 00 00       	call   80103db2 <acquire>
  lk->locked = 0;
80103c1c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103c22:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103c29:	89 1c 24             	mov    %ebx,(%esp)
80103c2c:	e8 6b fd ff ff       	call   8010399c <wakeup>
  release(&lk->lk);
80103c31:	89 34 24             	mov    %esi,(%esp)
80103c34:	e8 e0 01 00 00       	call   80103e19 <release>
}
80103c39:	83 c4 10             	add    $0x10,%esp
80103c3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c3f:	5b                   	pop    %ebx
80103c40:	5e                   	pop    %esi
80103c41:	5d                   	pop    %ebp
80103c42:	c3                   	ret    

80103c43 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103c43:	55                   	push   %ebp
80103c44:	89 e5                	mov    %esp,%ebp
80103c46:	56                   	push   %esi
80103c47:	53                   	push   %ebx
80103c48:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80103c4b:	8d 5e 04             	lea    0x4(%esi),%ebx
80103c4e:	83 ec 0c             	sub    $0xc,%esp
80103c51:	53                   	push   %ebx
80103c52:	e8 5b 01 00 00       	call   80103db2 <acquire>
  r = lk->locked;
80103c57:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80103c59:	89 1c 24             	mov    %ebx,(%esp)
80103c5c:	e8 b8 01 00 00       	call   80103e19 <release>
  return r;
}
80103c61:	89 f0                	mov    %esi,%eax
80103c63:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c66:	5b                   	pop    %ebx
80103c67:	5e                   	pop    %esi
80103c68:	5d                   	pop    %ebp
80103c69:	c3                   	ret    

80103c6a <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103c6a:	55                   	push   %ebp
80103c6b:	89 e5                	mov    %esp,%ebp
80103c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103c70:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c73:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103c76:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103c7c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103c83:	5d                   	pop    %ebp
80103c84:	c3                   	ret    

80103c85 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103c85:	55                   	push   %ebp
80103c86:	89 e5                	mov    %esp,%ebp
80103c88:	53                   	push   %ebx
80103c89:	8b 45 08             	mov    0x8(%ebp),%eax
80103c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103c8f:	8d 90 f8 ff ff 7f    	lea    0x7ffffff8(%eax),%edx
80103c95:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80103c9b:	77 2d                	ja     80103cca <getcallerpcs+0x45>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103c9d:	8b 50 fc             	mov    -0x4(%eax),%edx
80103ca0:	89 11                	mov    %edx,(%ecx)
    ebp = (uint*)ebp[0]; // saved %ebp
80103ca2:	8b 50 f8             	mov    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103ca5:	b8 01 00 00 00       	mov    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103caa:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103cb0:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103cb6:	77 17                	ja     80103ccf <getcallerpcs+0x4a>
    pcs[i] = ebp[1];     // saved %eip
80103cb8:	8b 5a 04             	mov    0x4(%edx),%ebx
80103cbb:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103cbe:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103cc0:	83 c0 01             	add    $0x1,%eax
80103cc3:	83 f8 0a             	cmp    $0xa,%eax
80103cc6:	75 e2                	jne    80103caa <getcallerpcs+0x25>
80103cc8:	eb 14                	jmp    80103cde <getcallerpcs+0x59>
80103cca:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103ccf:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103cd6:	83 c0 01             	add    $0x1,%eax
80103cd9:	83 f8 09             	cmp    $0x9,%eax
80103cdc:	7e f1                	jle    80103ccf <getcallerpcs+0x4a>
}
80103cde:	5b                   	pop    %ebx
80103cdf:	5d                   	pop    %ebp
80103ce0:	c3                   	ret    

80103ce1 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103ce1:	55                   	push   %ebp
80103ce2:	89 e5                	mov    %esp,%ebp
80103ce4:	53                   	push   %ebx
80103ce5:	83 ec 04             	sub    $0x4,%esp
80103ce8:	9c                   	pushf  
80103ce9:	5b                   	pop    %ebx
  asm volatile("cli");
80103cea:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103ceb:	e8 b9 f5 ff ff       	call   801032a9 <mycpu>
80103cf0:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103cf7:	74 12                	je     80103d0b <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103cf9:	e8 ab f5 ff ff       	call   801032a9 <mycpu>
80103cfe:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103d05:	83 c4 04             	add    $0x4,%esp
80103d08:	5b                   	pop    %ebx
80103d09:	5d                   	pop    %ebp
80103d0a:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103d0b:	e8 99 f5 ff ff       	call   801032a9 <mycpu>
80103d10:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103d16:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103d1c:	eb db                	jmp    80103cf9 <pushcli+0x18>

80103d1e <popcli>:

void
popcli(void)
{
80103d1e:	55                   	push   %ebp
80103d1f:	89 e5                	mov    %esp,%ebp
80103d21:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d24:	9c                   	pushf  
80103d25:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103d26:	f6 c4 02             	test   $0x2,%ah
80103d29:	75 28                	jne    80103d53 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103d2b:	e8 79 f5 ff ff       	call   801032a9 <mycpu>
80103d30:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103d36:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103d39:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103d3f:	85 d2                	test   %edx,%edx
80103d41:	78 1d                	js     80103d60 <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d43:	e8 61 f5 ff ff       	call   801032a9 <mycpu>
80103d48:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103d4f:	74 1c                	je     80103d6d <popcli+0x4f>
    sti();
}
80103d51:	c9                   	leave  
80103d52:	c3                   	ret    
    panic("popcli - interruptible");
80103d53:	83 ec 0c             	sub    $0xc,%esp
80103d56:	68 53 6c 10 80       	push   $0x80106c53
80103d5b:	e8 e4 c5 ff ff       	call   80100344 <panic>
    panic("popcli");
80103d60:	83 ec 0c             	sub    $0xc,%esp
80103d63:	68 6a 6c 10 80       	push   $0x80106c6a
80103d68:	e8 d7 c5 ff ff       	call   80100344 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d6d:	e8 37 f5 ff ff       	call   801032a9 <mycpu>
80103d72:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103d79:	74 d6                	je     80103d51 <popcli+0x33>
  asm volatile("sti");
80103d7b:	fb                   	sti    
}
80103d7c:	eb d3                	jmp    80103d51 <popcli+0x33>

80103d7e <holding>:
{
80103d7e:	55                   	push   %ebp
80103d7f:	89 e5                	mov    %esp,%ebp
80103d81:	56                   	push   %esi
80103d82:	53                   	push   %ebx
80103d83:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d86:	e8 56 ff ff ff       	call   80103ce1 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103d8b:	bb 00 00 00 00       	mov    $0x0,%ebx
80103d90:	83 3e 00             	cmpl   $0x0,(%esi)
80103d93:	75 0b                	jne    80103da0 <holding+0x22>
  popcli();
80103d95:	e8 84 ff ff ff       	call   80103d1e <popcli>
}
80103d9a:	89 d8                	mov    %ebx,%eax
80103d9c:	5b                   	pop    %ebx
80103d9d:	5e                   	pop    %esi
80103d9e:	5d                   	pop    %ebp
80103d9f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103da0:	8b 5e 08             	mov    0x8(%esi),%ebx
80103da3:	e8 01 f5 ff ff       	call   801032a9 <mycpu>
80103da8:	39 c3                	cmp    %eax,%ebx
80103daa:	0f 94 c3             	sete   %bl
80103dad:	0f b6 db             	movzbl %bl,%ebx
80103db0:	eb e3                	jmp    80103d95 <holding+0x17>

80103db2 <acquire>:
{
80103db2:	55                   	push   %ebp
80103db3:	89 e5                	mov    %esp,%ebp
80103db5:	53                   	push   %ebx
80103db6:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103db9:	e8 23 ff ff ff       	call   80103ce1 <pushcli>
  if(holding(lk))
80103dbe:	83 ec 0c             	sub    $0xc,%esp
80103dc1:	ff 75 08             	pushl  0x8(%ebp)
80103dc4:	e8 b5 ff ff ff       	call   80103d7e <holding>
80103dc9:	83 c4 10             	add    $0x10,%esp
80103dcc:	85 c0                	test   %eax,%eax
80103dce:	75 3c                	jne    80103e0c <acquire+0x5a>
  asm volatile("lock; xchgl %0, %1" :
80103dd0:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80103dd5:	8b 55 08             	mov    0x8(%ebp),%edx
80103dd8:	89 c8                	mov    %ecx,%eax
80103dda:	f0 87 02             	lock xchg %eax,(%edx)
80103ddd:	85 c0                	test   %eax,%eax
80103ddf:	75 f4                	jne    80103dd5 <acquire+0x23>
  __sync_synchronize();
80103de1:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103de6:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103de9:	e8 bb f4 ff ff       	call   801032a9 <mycpu>
80103dee:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103df1:	83 ec 08             	sub    $0x8,%esp
80103df4:	8b 45 08             	mov    0x8(%ebp),%eax
80103df7:	83 c0 0c             	add    $0xc,%eax
80103dfa:	50                   	push   %eax
80103dfb:	8d 45 08             	lea    0x8(%ebp),%eax
80103dfe:	50                   	push   %eax
80103dff:	e8 81 fe ff ff       	call   80103c85 <getcallerpcs>
}
80103e04:	83 c4 10             	add    $0x10,%esp
80103e07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e0a:	c9                   	leave  
80103e0b:	c3                   	ret    
    panic("acquire");
80103e0c:	83 ec 0c             	sub    $0xc,%esp
80103e0f:	68 71 6c 10 80       	push   $0x80106c71
80103e14:	e8 2b c5 ff ff       	call   80100344 <panic>

80103e19 <release>:
{
80103e19:	55                   	push   %ebp
80103e1a:	89 e5                	mov    %esp,%ebp
80103e1c:	53                   	push   %ebx
80103e1d:	83 ec 10             	sub    $0x10,%esp
80103e20:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103e23:	53                   	push   %ebx
80103e24:	e8 55 ff ff ff       	call   80103d7e <holding>
80103e29:	83 c4 10             	add    $0x10,%esp
80103e2c:	85 c0                	test   %eax,%eax
80103e2e:	74 23                	je     80103e53 <release+0x3a>
  lk->pcs[0] = 0;
80103e30:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103e37:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103e3e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103e43:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103e49:	e8 d0 fe ff ff       	call   80103d1e <popcli>
}
80103e4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e51:	c9                   	leave  
80103e52:	c3                   	ret    
    panic("release");
80103e53:	83 ec 0c             	sub    $0xc,%esp
80103e56:	68 79 6c 10 80       	push   $0x80106c79
80103e5b:	e8 e4 c4 ff ff       	call   80100344 <panic>

80103e60 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103e60:	55                   	push   %ebp
80103e61:	89 e5                	mov    %esp,%ebp
80103e63:	57                   	push   %edi
80103e64:	53                   	push   %ebx
80103e65:	8b 55 08             	mov    0x8(%ebp),%edx
80103e68:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80103e6b:	f6 c2 03             	test   $0x3,%dl
80103e6e:	75 05                	jne    80103e75 <memset+0x15>
80103e70:	f6 c1 03             	test   $0x3,%cl
80103e73:	74 0e                	je     80103e83 <memset+0x23>
  asm volatile("cld; rep stosb" :
80103e75:	89 d7                	mov    %edx,%edi
80103e77:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e7a:	fc                   	cld    
80103e7b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80103e7d:	89 d0                	mov    %edx,%eax
80103e7f:	5b                   	pop    %ebx
80103e80:	5f                   	pop    %edi
80103e81:	5d                   	pop    %ebp
80103e82:	c3                   	ret    
    c &= 0xFF;
80103e83:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103e87:	c1 e9 02             	shr    $0x2,%ecx
80103e8a:	89 f8                	mov    %edi,%eax
80103e8c:	c1 e0 18             	shl    $0x18,%eax
80103e8f:	89 fb                	mov    %edi,%ebx
80103e91:	c1 e3 10             	shl    $0x10,%ebx
80103e94:	09 d8                	or     %ebx,%eax
80103e96:	09 f8                	or     %edi,%eax
80103e98:	c1 e7 08             	shl    $0x8,%edi
80103e9b:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103e9d:	89 d7                	mov    %edx,%edi
80103e9f:	fc                   	cld    
80103ea0:	f3 ab                	rep stos %eax,%es:(%edi)
80103ea2:	eb d9                	jmp    80103e7d <memset+0x1d>

80103ea4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103ea4:	55                   	push   %ebp
80103ea5:	89 e5                	mov    %esp,%ebp
80103ea7:	57                   	push   %edi
80103ea8:	56                   	push   %esi
80103ea9:	53                   	push   %ebx
80103eaa:	8b 75 08             	mov    0x8(%ebp),%esi
80103ead:	8b 7d 0c             	mov    0xc(%ebp),%edi
80103eb0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103eb3:	85 db                	test   %ebx,%ebx
80103eb5:	74 37                	je     80103eee <memcmp+0x4a>
    if(*s1 != *s2)
80103eb7:	0f b6 16             	movzbl (%esi),%edx
80103eba:	0f b6 0f             	movzbl (%edi),%ecx
80103ebd:	38 ca                	cmp    %cl,%dl
80103ebf:	75 19                	jne    80103eda <memcmp+0x36>
80103ec1:	b8 01 00 00 00       	mov    $0x1,%eax
  while(n-- > 0){
80103ec6:	39 d8                	cmp    %ebx,%eax
80103ec8:	74 1d                	je     80103ee7 <memcmp+0x43>
    if(*s1 != *s2)
80103eca:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80103ece:	83 c0 01             	add    $0x1,%eax
80103ed1:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80103ed6:	38 ca                	cmp    %cl,%dl
80103ed8:	74 ec                	je     80103ec6 <memcmp+0x22>
      return *s1 - *s2;
80103eda:	0f b6 c2             	movzbl %dl,%eax
80103edd:	0f b6 c9             	movzbl %cl,%ecx
80103ee0:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
80103ee2:	5b                   	pop    %ebx
80103ee3:	5e                   	pop    %esi
80103ee4:	5f                   	pop    %edi
80103ee5:	5d                   	pop    %ebp
80103ee6:	c3                   	ret    
  return 0;
80103ee7:	b8 00 00 00 00       	mov    $0x0,%eax
80103eec:	eb f4                	jmp    80103ee2 <memcmp+0x3e>
80103eee:	b8 00 00 00 00       	mov    $0x0,%eax
80103ef3:	eb ed                	jmp    80103ee2 <memcmp+0x3e>

80103ef5 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103ef5:	55                   	push   %ebp
80103ef6:	89 e5                	mov    %esp,%ebp
80103ef8:	56                   	push   %esi
80103ef9:	53                   	push   %ebx
80103efa:	8b 45 08             	mov    0x8(%ebp),%eax
80103efd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103f00:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103f03:	39 c3                	cmp    %eax,%ebx
80103f05:	72 1b                	jb     80103f22 <memmove+0x2d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80103f07:	ba 00 00 00 00       	mov    $0x0,%edx
80103f0c:	85 f6                	test   %esi,%esi
80103f0e:	74 0e                	je     80103f1e <memmove+0x29>
      *d++ = *s++;
80103f10:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80103f14:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80103f17:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80103f1a:	39 d6                	cmp    %edx,%esi
80103f1c:	75 f2                	jne    80103f10 <memmove+0x1b>

  return dst;
}
80103f1e:	5b                   	pop    %ebx
80103f1f:	5e                   	pop    %esi
80103f20:	5d                   	pop    %ebp
80103f21:	c3                   	ret    
  if(s < d && s + n > d){
80103f22:	8d 14 33             	lea    (%ebx,%esi,1),%edx
80103f25:	39 d0                	cmp    %edx,%eax
80103f27:	73 de                	jae    80103f07 <memmove+0x12>
    while(n-- > 0)
80103f29:	8d 56 ff             	lea    -0x1(%esi),%edx
80103f2c:	85 f6                	test   %esi,%esi
80103f2e:	74 ee                	je     80103f1e <memmove+0x29>
      *--d = *--s;
80103f30:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80103f34:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80103f37:	83 ea 01             	sub    $0x1,%edx
80103f3a:	83 fa ff             	cmp    $0xffffffff,%edx
80103f3d:	75 f1                	jne    80103f30 <memmove+0x3b>
80103f3f:	eb dd                	jmp    80103f1e <memmove+0x29>

80103f41 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103f41:	55                   	push   %ebp
80103f42:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80103f44:	ff 75 10             	pushl  0x10(%ebp)
80103f47:	ff 75 0c             	pushl  0xc(%ebp)
80103f4a:	ff 75 08             	pushl  0x8(%ebp)
80103f4d:	e8 a3 ff ff ff       	call   80103ef5 <memmove>
}
80103f52:	c9                   	leave  
80103f53:	c3                   	ret    

80103f54 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103f54:	55                   	push   %ebp
80103f55:	89 e5                	mov    %esp,%ebp
80103f57:	53                   	push   %ebx
80103f58:	8b 45 08             	mov    0x8(%ebp),%eax
80103f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f5e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
80103f61:	85 db                	test   %ebx,%ebx
80103f63:	74 2d                	je     80103f92 <strncmp+0x3e>
80103f65:	0f b6 08             	movzbl (%eax),%ecx
80103f68:	84 c9                	test   %cl,%cl
80103f6a:	74 1b                	je     80103f87 <strncmp+0x33>
80103f6c:	3a 0a                	cmp    (%edx),%cl
80103f6e:	75 17                	jne    80103f87 <strncmp+0x33>
80103f70:	01 c3                	add    %eax,%ebx
    n--, p++, q++;
80103f72:	83 c0 01             	add    $0x1,%eax
80103f75:	83 c2 01             	add    $0x1,%edx
  while(n > 0 && *p && *p == *q)
80103f78:	39 d8                	cmp    %ebx,%eax
80103f7a:	74 1d                	je     80103f99 <strncmp+0x45>
80103f7c:	0f b6 08             	movzbl (%eax),%ecx
80103f7f:	84 c9                	test   %cl,%cl
80103f81:	74 04                	je     80103f87 <strncmp+0x33>
80103f83:	3a 0a                	cmp    (%edx),%cl
80103f85:	74 eb                	je     80103f72 <strncmp+0x1e>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80103f87:	0f b6 00             	movzbl (%eax),%eax
80103f8a:	0f b6 12             	movzbl (%edx),%edx
80103f8d:	29 d0                	sub    %edx,%eax
}
80103f8f:	5b                   	pop    %ebx
80103f90:	5d                   	pop    %ebp
80103f91:	c3                   	ret    
    return 0;
80103f92:	b8 00 00 00 00       	mov    $0x0,%eax
80103f97:	eb f6                	jmp    80103f8f <strncmp+0x3b>
80103f99:	b8 00 00 00 00       	mov    $0x0,%eax
80103f9e:	eb ef                	jmp    80103f8f <strncmp+0x3b>

80103fa0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
80103fa5:	53                   	push   %ebx
80103fa6:	8b 7d 08             	mov    0x8(%ebp),%edi
80103fa9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103fac:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103faf:	89 f9                	mov    %edi,%ecx
80103fb1:	eb 02                	jmp    80103fb5 <strncpy+0x15>
80103fb3:	89 f2                	mov    %esi,%edx
80103fb5:	8d 72 ff             	lea    -0x1(%edx),%esi
80103fb8:	85 d2                	test   %edx,%edx
80103fba:	7e 11                	jle    80103fcd <strncpy+0x2d>
80103fbc:	83 c3 01             	add    $0x1,%ebx
80103fbf:	83 c1 01             	add    $0x1,%ecx
80103fc2:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
80103fc6:	88 41 ff             	mov    %al,-0x1(%ecx)
80103fc9:	84 c0                	test   %al,%al
80103fcb:	75 e6                	jne    80103fb3 <strncpy+0x13>
    ;
  while(n-- > 0)
80103fcd:	bb 00 00 00 00       	mov    $0x0,%ebx
80103fd2:	83 ea 01             	sub    $0x1,%edx
80103fd5:	85 f6                	test   %esi,%esi
80103fd7:	7e 0f                	jle    80103fe8 <strncpy+0x48>
    *s++ = 0;
80103fd9:	c6 04 19 00          	movb   $0x0,(%ecx,%ebx,1)
80103fdd:	83 c3 01             	add    $0x1,%ebx
80103fe0:	89 d6                	mov    %edx,%esi
80103fe2:	29 de                	sub    %ebx,%esi
  while(n-- > 0)
80103fe4:	85 f6                	test   %esi,%esi
80103fe6:	7f f1                	jg     80103fd9 <strncpy+0x39>
  return os;
}
80103fe8:	89 f8                	mov    %edi,%eax
80103fea:	5b                   	pop    %ebx
80103feb:	5e                   	pop    %esi
80103fec:	5f                   	pop    %edi
80103fed:	5d                   	pop    %ebp
80103fee:	c3                   	ret    

80103fef <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103fef:	55                   	push   %ebp
80103ff0:	89 e5                	mov    %esp,%ebp
80103ff2:	56                   	push   %esi
80103ff3:	53                   	push   %ebx
80103ff4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff7:	8b 55 0c             	mov    0xc(%ebp),%edx
80103ffa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  if(n <= 0)
80103ffd:	85 c9                	test   %ecx,%ecx
80103fff:	7e 1e                	jle    8010401f <safestrcpy+0x30>
80104001:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104005:	89 c1                	mov    %eax,%ecx
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104007:	39 f2                	cmp    %esi,%edx
80104009:	74 11                	je     8010401c <safestrcpy+0x2d>
8010400b:	83 c2 01             	add    $0x1,%edx
8010400e:	83 c1 01             	add    $0x1,%ecx
80104011:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104015:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104018:	84 db                	test   %bl,%bl
8010401a:	75 eb                	jne    80104007 <safestrcpy+0x18>
    ;
  *s = 0;
8010401c:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
8010401f:	5b                   	pop    %ebx
80104020:	5e                   	pop    %esi
80104021:	5d                   	pop    %ebp
80104022:	c3                   	ret    

80104023 <strlen>:

int
strlen(const char *s)
{
80104023:	55                   	push   %ebp
80104024:	89 e5                	mov    %esp,%ebp
80104026:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104029:	80 3a 00             	cmpb   $0x0,(%edx)
8010402c:	74 10                	je     8010403e <strlen+0x1b>
8010402e:	b8 00 00 00 00       	mov    $0x0,%eax
80104033:	83 c0 01             	add    $0x1,%eax
80104036:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010403a:	75 f7                	jne    80104033 <strlen+0x10>
    ;
  return n;
}
8010403c:	5d                   	pop    %ebp
8010403d:	c3                   	ret    
  for(n = 0; s[n]; n++)
8010403e:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
80104043:	eb f7                	jmp    8010403c <strlen+0x19>

80104045 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104045:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104049:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
8010404d:	55                   	push   %ebp
  pushl %ebx
8010404e:	53                   	push   %ebx
  pushl %esi
8010404f:	56                   	push   %esi
  pushl %edi
80104050:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104051:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104053:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104055:	5f                   	pop    %edi
  popl %esi
80104056:	5e                   	pop    %esi
  popl %ebx
80104057:	5b                   	pop    %ebx
  popl %ebp
80104058:	5d                   	pop    %ebp
  ret
80104059:	c3                   	ret    

8010405a <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
8010405a:	55                   	push   %ebp
8010405b:	89 e5                	mov    %esp,%ebp
8010405d:	53                   	push   %ebx
8010405e:	83 ec 04             	sub    $0x4,%esp
80104061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104064:	e8 d2 f2 ff ff       	call   8010333b <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104069:	8b 00                	mov    (%eax),%eax
8010406b:	39 d8                	cmp    %ebx,%eax
8010406d:	76 19                	jbe    80104088 <fetchint+0x2e>
8010406f:	8d 53 04             	lea    0x4(%ebx),%edx
80104072:	39 d0                	cmp    %edx,%eax
80104074:	72 19                	jb     8010408f <fetchint+0x35>
    return -1;
  *ip = *(int*)(addr);
80104076:	8b 13                	mov    (%ebx),%edx
80104078:	8b 45 0c             	mov    0xc(%ebp),%eax
8010407b:	89 10                	mov    %edx,(%eax)
  return 0;
8010407d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104082:	83 c4 04             	add    $0x4,%esp
80104085:	5b                   	pop    %ebx
80104086:	5d                   	pop    %ebp
80104087:	c3                   	ret    
    return -1;
80104088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010408d:	eb f3                	jmp    80104082 <fetchint+0x28>
8010408f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104094:	eb ec                	jmp    80104082 <fetchint+0x28>

80104096 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104096:	55                   	push   %ebp
80104097:	89 e5                	mov    %esp,%ebp
80104099:	53                   	push   %ebx
8010409a:	83 ec 04             	sub    $0x4,%esp
8010409d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801040a0:	e8 96 f2 ff ff       	call   8010333b <myproc>

  if(addr >= curproc->sz)
801040a5:	39 18                	cmp    %ebx,(%eax)
801040a7:	76 2f                	jbe    801040d8 <fetchstr+0x42>
    return -1;
  *pp = (char*)addr;
801040a9:	89 da                	mov    %ebx,%edx
801040ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801040ae:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801040b0:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801040b2:	39 c3                	cmp    %eax,%ebx
801040b4:	73 29                	jae    801040df <fetchstr+0x49>
    if(*s == 0)
801040b6:	80 3b 00             	cmpb   $0x0,(%ebx)
801040b9:	74 0c                	je     801040c7 <fetchstr+0x31>
  for(s = *pp; s < ep; s++){
801040bb:	83 c2 01             	add    $0x1,%edx
801040be:	39 d0                	cmp    %edx,%eax
801040c0:	76 0f                	jbe    801040d1 <fetchstr+0x3b>
    if(*s == 0)
801040c2:	80 3a 00             	cmpb   $0x0,(%edx)
801040c5:	75 f4                	jne    801040bb <fetchstr+0x25>
      return s - *pp;
801040c7:	89 d0                	mov    %edx,%eax
801040c9:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801040cb:	83 c4 04             	add    $0x4,%esp
801040ce:	5b                   	pop    %ebx
801040cf:	5d                   	pop    %ebp
801040d0:	c3                   	ret    
  return -1;
801040d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040d6:	eb f3                	jmp    801040cb <fetchstr+0x35>
    return -1;
801040d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040dd:	eb ec                	jmp    801040cb <fetchstr+0x35>
  return -1;
801040df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040e4:	eb e5                	jmp    801040cb <fetchstr+0x35>

801040e6 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801040e6:	55                   	push   %ebp
801040e7:	89 e5                	mov    %esp,%ebp
801040e9:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801040ec:	e8 4a f2 ff ff       	call   8010333b <myproc>
801040f1:	83 ec 08             	sub    $0x8,%esp
801040f4:	ff 75 0c             	pushl  0xc(%ebp)
801040f7:	8b 40 18             	mov    0x18(%eax),%eax
801040fa:	8b 40 44             	mov    0x44(%eax),%eax
801040fd:	8b 55 08             	mov    0x8(%ebp),%edx
80104100:	8d 44 90 04          	lea    0x4(%eax,%edx,4),%eax
80104104:	50                   	push   %eax
80104105:	e8 50 ff ff ff       	call   8010405a <fetchint>
}
8010410a:	c9                   	leave  
8010410b:	c3                   	ret    

8010410c <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010410c:	55                   	push   %ebp
8010410d:	89 e5                	mov    %esp,%ebp
8010410f:	56                   	push   %esi
80104110:	53                   	push   %ebx
80104111:	83 ec 10             	sub    $0x10,%esp
80104114:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104117:	e8 1f f2 ff ff       	call   8010333b <myproc>
8010411c:	89 c6                	mov    %eax,%esi

  if(argint(n, &i) < 0)
8010411e:	83 ec 08             	sub    $0x8,%esp
80104121:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104124:	50                   	push   %eax
80104125:	ff 75 08             	pushl  0x8(%ebp)
80104128:	e8 b9 ff ff ff       	call   801040e6 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010412d:	83 c4 10             	add    $0x10,%esp
80104130:	85 db                	test   %ebx,%ebx
80104132:	78 24                	js     80104158 <argptr+0x4c>
80104134:	85 c0                	test   %eax,%eax
80104136:	78 20                	js     80104158 <argptr+0x4c>
80104138:	8b 16                	mov    (%esi),%edx
8010413a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413d:	39 c2                	cmp    %eax,%edx
8010413f:	76 1e                	jbe    8010415f <argptr+0x53>
80104141:	01 c3                	add    %eax,%ebx
80104143:	39 da                	cmp    %ebx,%edx
80104145:	72 1f                	jb     80104166 <argptr+0x5a>
    return -1;
  *pp = (char*)i;
80104147:	8b 55 0c             	mov    0xc(%ebp),%edx
8010414a:	89 02                	mov    %eax,(%edx)
  return 0;
8010414c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104151:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104154:	5b                   	pop    %ebx
80104155:	5e                   	pop    %esi
80104156:	5d                   	pop    %ebp
80104157:	c3                   	ret    
    return -1;
80104158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010415d:	eb f2                	jmp    80104151 <argptr+0x45>
8010415f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104164:	eb eb                	jmp    80104151 <argptr+0x45>
80104166:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010416b:	eb e4                	jmp    80104151 <argptr+0x45>

8010416d <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010416d:	55                   	push   %ebp
8010416e:	89 e5                	mov    %esp,%ebp
80104170:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104173:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104176:	50                   	push   %eax
80104177:	ff 75 08             	pushl  0x8(%ebp)
8010417a:	e8 67 ff ff ff       	call   801040e6 <argint>
8010417f:	83 c4 10             	add    $0x10,%esp
80104182:	85 c0                	test   %eax,%eax
80104184:	78 13                	js     80104199 <argstr+0x2c>
    return -1;
  return fetchstr(addr, pp);
80104186:	83 ec 08             	sub    $0x8,%esp
80104189:	ff 75 0c             	pushl  0xc(%ebp)
8010418c:	ff 75 f4             	pushl  -0xc(%ebp)
8010418f:	e8 02 ff ff ff       	call   80104096 <fetchstr>
80104194:	83 c4 10             	add    $0x10,%esp
}
80104197:	c9                   	leave  
80104198:	c3                   	ret    
    return -1;
80104199:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010419e:	eb f7                	jmp    80104197 <argstr+0x2a>

801041a0 <syscall>:
};
#endif // PRINT_SYSCALLS

void
syscall(void)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	53                   	push   %ebx
801041a4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801041a7:	e8 8f f1 ff ff       	call   8010333b <myproc>
801041ac:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801041ae:	8b 40 18             	mov    0x18(%eax),%eax
801041b1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801041b4:	8d 50 ff             	lea    -0x1(%eax),%edx
801041b7:	83 fa 16             	cmp    $0x16,%edx
801041ba:	77 18                	ja     801041d4 <syscall+0x34>
801041bc:	8b 14 85 a0 6c 10 80 	mov    -0x7fef9360(,%eax,4),%edx
801041c3:	85 d2                	test   %edx,%edx
801041c5:	74 0d                	je     801041d4 <syscall+0x34>
    curproc->tf->eax = syscalls[num]();
801041c7:	ff d2                	call   *%edx
801041c9:	8b 53 18             	mov    0x18(%ebx),%edx
801041cc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801041cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d2:	c9                   	leave  
801041d3:	c3                   	ret    
    cprintf("%d %s: unknown sys call %d\n",
801041d4:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801041d5:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801041d8:	50                   	push   %eax
801041d9:	ff 73 10             	pushl  0x10(%ebx)
801041dc:	68 81 6c 10 80       	push   $0x80106c81
801041e1:	e8 fb c3 ff ff       	call   801005e1 <cprintf>
    curproc->tf->eax = -1;
801041e6:	8b 43 18             	mov    0x18(%ebx),%eax
801041e9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
801041f0:	83 c4 10             	add    $0x10,%esp
}
801041f3:	eb da                	jmp    801041cf <syscall+0x2f>

801041f5 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801041f5:	55                   	push   %ebp
801041f6:	89 e5                	mov    %esp,%ebp
801041f8:	56                   	push   %esi
801041f9:	53                   	push   %ebx
801041fa:	83 ec 18             	sub    $0x18,%esp
801041fd:	89 d6                	mov    %edx,%esi
801041ff:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104201:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104204:	52                   	push   %edx
80104205:	50                   	push   %eax
80104206:	e8 db fe ff ff       	call   801040e6 <argint>
8010420b:	83 c4 10             	add    $0x10,%esp
8010420e:	85 c0                	test   %eax,%eax
80104210:	78 2e                	js     80104240 <argfd+0x4b>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104212:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104216:	77 2f                	ja     80104247 <argfd+0x52>
80104218:	e8 1e f1 ff ff       	call   8010333b <myproc>
8010421d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104220:	8b 54 88 28          	mov    0x28(%eax,%ecx,4),%edx
80104224:	85 d2                	test   %edx,%edx
80104226:	74 26                	je     8010424e <argfd+0x59>
    return -1;
  if(pfd)
80104228:	85 f6                	test   %esi,%esi
8010422a:	74 02                	je     8010422e <argfd+0x39>
    *pfd = fd;
8010422c:	89 0e                	mov    %ecx,(%esi)
  if(pf)
    *pf = f;
  return 0;
8010422e:	b8 00 00 00 00       	mov    $0x0,%eax
  if(pf)
80104233:	85 db                	test   %ebx,%ebx
80104235:	74 02                	je     80104239 <argfd+0x44>
    *pf = f;
80104237:	89 13                	mov    %edx,(%ebx)
}
80104239:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010423c:	5b                   	pop    %ebx
8010423d:	5e                   	pop    %esi
8010423e:	5d                   	pop    %ebp
8010423f:	c3                   	ret    
    return -1;
80104240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104245:	eb f2                	jmp    80104239 <argfd+0x44>
    return -1;
80104247:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010424c:	eb eb                	jmp    80104239 <argfd+0x44>
8010424e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104253:	eb e4                	jmp    80104239 <argfd+0x44>

80104255 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104255:	55                   	push   %ebp
80104256:	89 e5                	mov    %esp,%ebp
80104258:	53                   	push   %ebx
80104259:	83 ec 04             	sub    $0x4,%esp
8010425c:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
8010425e:	e8 d8 f0 ff ff       	call   8010333b <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104263:	83 78 28 00          	cmpl   $0x0,0x28(%eax)
80104267:	74 1b                	je     80104284 <fdalloc+0x2f>
  for(fd = 0; fd < NOFILE; fd++){
80104269:	ba 01 00 00 00       	mov    $0x1,%edx
    if(curproc->ofile[fd] == 0){
8010426e:	83 7c 90 28 00       	cmpl   $0x0,0x28(%eax,%edx,4)
80104273:	74 14                	je     80104289 <fdalloc+0x34>
  for(fd = 0; fd < NOFILE; fd++){
80104275:	83 c2 01             	add    $0x1,%edx
80104278:	83 fa 10             	cmp    $0x10,%edx
8010427b:	75 f1                	jne    8010426e <fdalloc+0x19>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010427d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80104282:	eb 09                	jmp    8010428d <fdalloc+0x38>
  for(fd = 0; fd < NOFILE; fd++){
80104284:	ba 00 00 00 00       	mov    $0x0,%edx
      curproc->ofile[fd] = f;
80104289:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
8010428d:	89 d0                	mov    %edx,%eax
8010428f:	83 c4 04             	add    $0x4,%esp
80104292:	5b                   	pop    %ebx
80104293:	5d                   	pop    %ebp
80104294:	c3                   	ret    

80104295 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104295:	55                   	push   %ebp
80104296:	89 e5                	mov    %esp,%ebp
80104298:	57                   	push   %edi
80104299:	56                   	push   %esi
8010429a:	53                   	push   %ebx
8010429b:	83 ec 44             	sub    $0x44,%esp
8010429e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801042a1:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801042a4:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801042a7:	8d 55 d6             	lea    -0x2a(%ebp),%edx
801042aa:	52                   	push   %edx
801042ab:	50                   	push   %eax
801042ac:	e8 ec d9 ff ff       	call   80101c9d <nameiparent>
801042b1:	89 c6                	mov    %eax,%esi
801042b3:	83 c4 10             	add    $0x10,%esp
801042b6:	85 c0                	test   %eax,%eax
801042b8:	0f 84 34 01 00 00    	je     801043f2 <create+0x15d>
    return 0;
  ilock(dp);
801042be:	83 ec 0c             	sub    $0xc,%esp
801042c1:	50                   	push   %eax
801042c2:	e8 21 d2 ff ff       	call   801014e8 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801042c7:	83 c4 0c             	add    $0xc,%esp
801042ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801042cd:	50                   	push   %eax
801042ce:	8d 45 d6             	lea    -0x2a(%ebp),%eax
801042d1:	50                   	push   %eax
801042d2:	56                   	push   %esi
801042d3:	e8 d6 d6 ff ff       	call   801019ae <dirlookup>
801042d8:	89 c3                	mov    %eax,%ebx
801042da:	83 c4 10             	add    $0x10,%esp
801042dd:	85 c0                	test   %eax,%eax
801042df:	74 3f                	je     80104320 <create+0x8b>
    iunlockput(dp);
801042e1:	83 ec 0c             	sub    $0xc,%esp
801042e4:	56                   	push   %esi
801042e5:	e8 47 d4 ff ff       	call   80101731 <iunlockput>
    ilock(ip);
801042ea:	89 1c 24             	mov    %ebx,(%esp)
801042ed:	e8 f6 d1 ff ff       	call   801014e8 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801042f2:	83 c4 10             	add    $0x10,%esp
801042f5:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801042fa:	75 11                	jne    8010430d <create+0x78>
801042fc:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104301:	75 0a                	jne    8010430d <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104303:	89 d8                	mov    %ebx,%eax
80104305:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104308:	5b                   	pop    %ebx
80104309:	5e                   	pop    %esi
8010430a:	5f                   	pop    %edi
8010430b:	5d                   	pop    %ebp
8010430c:	c3                   	ret    
    iunlockput(ip);
8010430d:	83 ec 0c             	sub    $0xc,%esp
80104310:	53                   	push   %ebx
80104311:	e8 1b d4 ff ff       	call   80101731 <iunlockput>
    return 0;
80104316:	83 c4 10             	add    $0x10,%esp
80104319:	bb 00 00 00 00       	mov    $0x0,%ebx
8010431e:	eb e3                	jmp    80104303 <create+0x6e>
  if((ip = ialloc(dp->dev, type)) == 0)
80104320:	83 ec 08             	sub    $0x8,%esp
80104323:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104327:	50                   	push   %eax
80104328:	ff 36                	pushl  (%esi)
8010432a:	e8 66 d0 ff ff       	call   80101395 <ialloc>
8010432f:	89 c3                	mov    %eax,%ebx
80104331:	83 c4 10             	add    $0x10,%esp
80104334:	85 c0                	test   %eax,%eax
80104336:	74 55                	je     8010438d <create+0xf8>
  ilock(ip);
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	50                   	push   %eax
8010433c:	e8 a7 d1 ff ff       	call   801014e8 <ilock>
  ip->major = major;
80104341:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104345:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
80104349:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
8010434d:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
80104353:	89 1c 24             	mov    %ebx,(%esp)
80104356:	e8 e3 d0 ff ff       	call   8010143e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
8010435b:	83 c4 10             	add    $0x10,%esp
8010435e:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104363:	74 35                	je     8010439a <create+0x105>
  if(dirlink(dp, name, ip->inum) < 0)
80104365:	83 ec 04             	sub    $0x4,%esp
80104368:	ff 73 04             	pushl  0x4(%ebx)
8010436b:	8d 45 d6             	lea    -0x2a(%ebp),%eax
8010436e:	50                   	push   %eax
8010436f:	56                   	push   %esi
80104370:	e8 5b d8 ff ff       	call   80101bd0 <dirlink>
80104375:	83 c4 10             	add    $0x10,%esp
80104378:	85 c0                	test   %eax,%eax
8010437a:	78 69                	js     801043e5 <create+0x150>
  iunlockput(dp);
8010437c:	83 ec 0c             	sub    $0xc,%esp
8010437f:	56                   	push   %esi
80104380:	e8 ac d3 ff ff       	call   80101731 <iunlockput>
  return ip;
80104385:	83 c4 10             	add    $0x10,%esp
80104388:	e9 76 ff ff ff       	jmp    80104303 <create+0x6e>
    panic("create: ialloc");
8010438d:	83 ec 0c             	sub    $0xc,%esp
80104390:	68 00 6d 10 80       	push   $0x80106d00
80104395:	e8 aa bf ff ff       	call   80100344 <panic>
    dp->nlink++;  // for ".."
8010439a:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
8010439f:	83 ec 0c             	sub    $0xc,%esp
801043a2:	56                   	push   %esi
801043a3:	e8 96 d0 ff ff       	call   8010143e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801043a8:	83 c4 0c             	add    $0xc,%esp
801043ab:	ff 73 04             	pushl  0x4(%ebx)
801043ae:	68 10 6d 10 80       	push   $0x80106d10
801043b3:	53                   	push   %ebx
801043b4:	e8 17 d8 ff ff       	call   80101bd0 <dirlink>
801043b9:	83 c4 10             	add    $0x10,%esp
801043bc:	85 c0                	test   %eax,%eax
801043be:	78 18                	js     801043d8 <create+0x143>
801043c0:	83 ec 04             	sub    $0x4,%esp
801043c3:	ff 76 04             	pushl  0x4(%esi)
801043c6:	68 0f 6d 10 80       	push   $0x80106d0f
801043cb:	53                   	push   %ebx
801043cc:	e8 ff d7 ff ff       	call   80101bd0 <dirlink>
801043d1:	83 c4 10             	add    $0x10,%esp
801043d4:	85 c0                	test   %eax,%eax
801043d6:	79 8d                	jns    80104365 <create+0xd0>
      panic("create dots");
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 12 6d 10 80       	push   $0x80106d12
801043e0:	e8 5f bf ff ff       	call   80100344 <panic>
    panic("create: dirlink");
801043e5:	83 ec 0c             	sub    $0xc,%esp
801043e8:	68 1e 6d 10 80       	push   $0x80106d1e
801043ed:	e8 52 bf ff ff       	call   80100344 <panic>
    return 0;
801043f2:	89 c3                	mov    %eax,%ebx
801043f4:	e9 0a ff ff ff       	jmp    80104303 <create+0x6e>

801043f9 <sys_dup>:
{
801043f9:	55                   	push   %ebp
801043fa:	89 e5                	mov    %esp,%ebp
801043fc:	53                   	push   %ebx
801043fd:	83 ec 14             	sub    $0x14,%esp
  if(argfd(0, 0, &f) < 0)
80104400:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104403:	ba 00 00 00 00       	mov    $0x0,%edx
80104408:	b8 00 00 00 00       	mov    $0x0,%eax
8010440d:	e8 e3 fd ff ff       	call   801041f5 <argfd>
80104412:	85 c0                	test   %eax,%eax
80104414:	78 23                	js     80104439 <sys_dup+0x40>
  if((fd=fdalloc(f)) < 0)
80104416:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104419:	e8 37 fe ff ff       	call   80104255 <fdalloc>
8010441e:	89 c3                	mov    %eax,%ebx
80104420:	85 c0                	test   %eax,%eax
80104422:	78 1c                	js     80104440 <sys_dup+0x47>
  filedup(f);
80104424:	83 ec 0c             	sub    $0xc,%esp
80104427:	ff 75 f4             	pushl  -0xc(%ebp)
8010442a:	e8 a8 c8 ff ff       	call   80100cd7 <filedup>
  return fd;
8010442f:	83 c4 10             	add    $0x10,%esp
}
80104432:	89 d8                	mov    %ebx,%eax
80104434:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104437:	c9                   	leave  
80104438:	c3                   	ret    
    return -1;
80104439:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010443e:	eb f2                	jmp    80104432 <sys_dup+0x39>
    return -1;
80104440:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104445:	eb eb                	jmp    80104432 <sys_dup+0x39>

80104447 <sys_read>:
{
80104447:	55                   	push   %ebp
80104448:	89 e5                	mov    %esp,%ebp
8010444a:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010444d:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104450:	ba 00 00 00 00       	mov    $0x0,%edx
80104455:	b8 00 00 00 00       	mov    $0x0,%eax
8010445a:	e8 96 fd ff ff       	call   801041f5 <argfd>
8010445f:	85 c0                	test   %eax,%eax
80104461:	78 43                	js     801044a6 <sys_read+0x5f>
80104463:	83 ec 08             	sub    $0x8,%esp
80104466:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104469:	50                   	push   %eax
8010446a:	6a 02                	push   $0x2
8010446c:	e8 75 fc ff ff       	call   801040e6 <argint>
80104471:	83 c4 10             	add    $0x10,%esp
80104474:	85 c0                	test   %eax,%eax
80104476:	78 35                	js     801044ad <sys_read+0x66>
80104478:	83 ec 04             	sub    $0x4,%esp
8010447b:	ff 75 f0             	pushl  -0x10(%ebp)
8010447e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104481:	50                   	push   %eax
80104482:	6a 01                	push   $0x1
80104484:	e8 83 fc ff ff       	call   8010410c <argptr>
80104489:	83 c4 10             	add    $0x10,%esp
8010448c:	85 c0                	test   %eax,%eax
8010448e:	78 24                	js     801044b4 <sys_read+0x6d>
  return fileread(f, p, n);
80104490:	83 ec 04             	sub    $0x4,%esp
80104493:	ff 75 f0             	pushl  -0x10(%ebp)
80104496:	ff 75 ec             	pushl  -0x14(%ebp)
80104499:	ff 75 f4             	pushl  -0xc(%ebp)
8010449c:	e8 77 c9 ff ff       	call   80100e18 <fileread>
801044a1:	83 c4 10             	add    $0x10,%esp
}
801044a4:	c9                   	leave  
801044a5:	c3                   	ret    
    return -1;
801044a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044ab:	eb f7                	jmp    801044a4 <sys_read+0x5d>
801044ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044b2:	eb f0                	jmp    801044a4 <sys_read+0x5d>
801044b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044b9:	eb e9                	jmp    801044a4 <sys_read+0x5d>

801044bb <sys_write>:
{
801044bb:	55                   	push   %ebp
801044bc:	89 e5                	mov    %esp,%ebp
801044be:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801044c1:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801044c4:	ba 00 00 00 00       	mov    $0x0,%edx
801044c9:	b8 00 00 00 00       	mov    $0x0,%eax
801044ce:	e8 22 fd ff ff       	call   801041f5 <argfd>
801044d3:	85 c0                	test   %eax,%eax
801044d5:	78 43                	js     8010451a <sys_write+0x5f>
801044d7:	83 ec 08             	sub    $0x8,%esp
801044da:	8d 45 f0             	lea    -0x10(%ebp),%eax
801044dd:	50                   	push   %eax
801044de:	6a 02                	push   $0x2
801044e0:	e8 01 fc ff ff       	call   801040e6 <argint>
801044e5:	83 c4 10             	add    $0x10,%esp
801044e8:	85 c0                	test   %eax,%eax
801044ea:	78 35                	js     80104521 <sys_write+0x66>
801044ec:	83 ec 04             	sub    $0x4,%esp
801044ef:	ff 75 f0             	pushl  -0x10(%ebp)
801044f2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801044f5:	50                   	push   %eax
801044f6:	6a 01                	push   $0x1
801044f8:	e8 0f fc ff ff       	call   8010410c <argptr>
801044fd:	83 c4 10             	add    $0x10,%esp
80104500:	85 c0                	test   %eax,%eax
80104502:	78 24                	js     80104528 <sys_write+0x6d>
  return filewrite(f, p, n);
80104504:	83 ec 04             	sub    $0x4,%esp
80104507:	ff 75 f0             	pushl  -0x10(%ebp)
8010450a:	ff 75 ec             	pushl  -0x14(%ebp)
8010450d:	ff 75 f4             	pushl  -0xc(%ebp)
80104510:	e8 88 c9 ff ff       	call   80100e9d <filewrite>
80104515:	83 c4 10             	add    $0x10,%esp
}
80104518:	c9                   	leave  
80104519:	c3                   	ret    
    return -1;
8010451a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010451f:	eb f7                	jmp    80104518 <sys_write+0x5d>
80104521:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104526:	eb f0                	jmp    80104518 <sys_write+0x5d>
80104528:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010452d:	eb e9                	jmp    80104518 <sys_write+0x5d>

8010452f <sys_close>:
{
8010452f:	55                   	push   %ebp
80104530:	89 e5                	mov    %esp,%ebp
80104532:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104535:	8d 4d f0             	lea    -0x10(%ebp),%ecx
80104538:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010453b:	b8 00 00 00 00       	mov    $0x0,%eax
80104540:	e8 b0 fc ff ff       	call   801041f5 <argfd>
80104545:	85 c0                	test   %eax,%eax
80104547:	78 25                	js     8010456e <sys_close+0x3f>
  myproc()->ofile[fd] = 0;
80104549:	e8 ed ed ff ff       	call   8010333b <myproc>
8010454e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104551:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104558:	00 
  fileclose(f);
80104559:	83 ec 0c             	sub    $0xc,%esp
8010455c:	ff 75 f0             	pushl  -0x10(%ebp)
8010455f:	e8 b8 c7 ff ff       	call   80100d1c <fileclose>
  return 0;
80104564:	83 c4 10             	add    $0x10,%esp
80104567:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010456c:	c9                   	leave  
8010456d:	c3                   	ret    
    return -1;
8010456e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104573:	eb f7                	jmp    8010456c <sys_close+0x3d>

80104575 <sys_fstat>:
{
80104575:	55                   	push   %ebp
80104576:	89 e5                	mov    %esp,%ebp
80104578:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010457b:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010457e:	ba 00 00 00 00       	mov    $0x0,%edx
80104583:	b8 00 00 00 00       	mov    $0x0,%eax
80104588:	e8 68 fc ff ff       	call   801041f5 <argfd>
8010458d:	85 c0                	test   %eax,%eax
8010458f:	78 2a                	js     801045bb <sys_fstat+0x46>
80104591:	83 ec 04             	sub    $0x4,%esp
80104594:	6a 14                	push   $0x14
80104596:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104599:	50                   	push   %eax
8010459a:	6a 01                	push   $0x1
8010459c:	e8 6b fb ff ff       	call   8010410c <argptr>
801045a1:	83 c4 10             	add    $0x10,%esp
801045a4:	85 c0                	test   %eax,%eax
801045a6:	78 1a                	js     801045c2 <sys_fstat+0x4d>
  return filestat(f, st);
801045a8:	83 ec 08             	sub    $0x8,%esp
801045ab:	ff 75 f0             	pushl  -0x10(%ebp)
801045ae:	ff 75 f4             	pushl  -0xc(%ebp)
801045b1:	e8 1b c8 ff ff       	call   80100dd1 <filestat>
801045b6:	83 c4 10             	add    $0x10,%esp
}
801045b9:	c9                   	leave  
801045ba:	c3                   	ret    
    return -1;
801045bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045c0:	eb f7                	jmp    801045b9 <sys_fstat+0x44>
801045c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045c7:	eb f0                	jmp    801045b9 <sys_fstat+0x44>

801045c9 <sys_link>:
{
801045c9:	55                   	push   %ebp
801045ca:	89 e5                	mov    %esp,%ebp
801045cc:	56                   	push   %esi
801045cd:	53                   	push   %ebx
801045ce:	83 ec 28             	sub    $0x28,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801045d1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801045d4:	50                   	push   %eax
801045d5:	6a 00                	push   $0x0
801045d7:	e8 91 fb ff ff       	call   8010416d <argstr>
801045dc:	83 c4 10             	add    $0x10,%esp
801045df:	85 c0                	test   %eax,%eax
801045e1:	0f 88 26 01 00 00    	js     8010470d <sys_link+0x144>
801045e7:	83 ec 08             	sub    $0x8,%esp
801045ea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801045ed:	50                   	push   %eax
801045ee:	6a 01                	push   $0x1
801045f0:	e8 78 fb ff ff       	call   8010416d <argstr>
801045f5:	83 c4 10             	add    $0x10,%esp
801045f8:	85 c0                	test   %eax,%eax
801045fa:	0f 88 14 01 00 00    	js     80104714 <sys_link+0x14b>
  begin_op();
80104600:	e8 aa e1 ff ff       	call   801027af <begin_op>
  if((ip = namei(old)) == 0){
80104605:	83 ec 0c             	sub    $0xc,%esp
80104608:	ff 75 e0             	pushl  -0x20(%ebp)
8010460b:	e8 75 d6 ff ff       	call   80101c85 <namei>
80104610:	89 c3                	mov    %eax,%ebx
80104612:	83 c4 10             	add    $0x10,%esp
80104615:	85 c0                	test   %eax,%eax
80104617:	0f 84 93 00 00 00    	je     801046b0 <sys_link+0xe7>
  ilock(ip);
8010461d:	83 ec 0c             	sub    $0xc,%esp
80104620:	50                   	push   %eax
80104621:	e8 c2 ce ff ff       	call   801014e8 <ilock>
  if(ip->type == T_DIR){
80104626:	83 c4 10             	add    $0x10,%esp
80104629:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010462e:	0f 84 88 00 00 00    	je     801046bc <sys_link+0xf3>
  ip->nlink++;
80104634:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104639:	83 ec 0c             	sub    $0xc,%esp
8010463c:	53                   	push   %ebx
8010463d:	e8 fc cd ff ff       	call   8010143e <iupdate>
  iunlock(ip);
80104642:	89 1c 24             	mov    %ebx,(%esp)
80104645:	e8 60 cf ff ff       	call   801015aa <iunlock>
  if((dp = nameiparent(new, name)) == 0)
8010464a:	83 c4 08             	add    $0x8,%esp
8010464d:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104650:	50                   	push   %eax
80104651:	ff 75 e4             	pushl  -0x1c(%ebp)
80104654:	e8 44 d6 ff ff       	call   80101c9d <nameiparent>
80104659:	89 c6                	mov    %eax,%esi
8010465b:	83 c4 10             	add    $0x10,%esp
8010465e:	85 c0                	test   %eax,%eax
80104660:	74 7e                	je     801046e0 <sys_link+0x117>
  ilock(dp);
80104662:	83 ec 0c             	sub    $0xc,%esp
80104665:	50                   	push   %eax
80104666:	e8 7d ce ff ff       	call   801014e8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010466b:	83 c4 10             	add    $0x10,%esp
8010466e:	8b 03                	mov    (%ebx),%eax
80104670:	39 06                	cmp    %eax,(%esi)
80104672:	75 60                	jne    801046d4 <sys_link+0x10b>
80104674:	83 ec 04             	sub    $0x4,%esp
80104677:	ff 73 04             	pushl  0x4(%ebx)
8010467a:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010467d:	50                   	push   %eax
8010467e:	56                   	push   %esi
8010467f:	e8 4c d5 ff ff       	call   80101bd0 <dirlink>
80104684:	83 c4 10             	add    $0x10,%esp
80104687:	85 c0                	test   %eax,%eax
80104689:	78 49                	js     801046d4 <sys_link+0x10b>
  iunlockput(dp);
8010468b:	83 ec 0c             	sub    $0xc,%esp
8010468e:	56                   	push   %esi
8010468f:	e8 9d d0 ff ff       	call   80101731 <iunlockput>
  iput(ip);
80104694:	89 1c 24             	mov    %ebx,(%esp)
80104697:	e8 53 cf ff ff       	call   801015ef <iput>
  end_op();
8010469c:	e8 89 e1 ff ff       	call   8010282a <end_op>
  return 0;
801046a1:	83 c4 10             	add    $0x10,%esp
801046a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801046a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046ac:	5b                   	pop    %ebx
801046ad:	5e                   	pop    %esi
801046ae:	5d                   	pop    %ebp
801046af:	c3                   	ret    
    end_op();
801046b0:	e8 75 e1 ff ff       	call   8010282a <end_op>
    return -1;
801046b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046ba:	eb ed                	jmp    801046a9 <sys_link+0xe0>
    iunlockput(ip);
801046bc:	83 ec 0c             	sub    $0xc,%esp
801046bf:	53                   	push   %ebx
801046c0:	e8 6c d0 ff ff       	call   80101731 <iunlockput>
    end_op();
801046c5:	e8 60 e1 ff ff       	call   8010282a <end_op>
    return -1;
801046ca:	83 c4 10             	add    $0x10,%esp
801046cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046d2:	eb d5                	jmp    801046a9 <sys_link+0xe0>
    iunlockput(dp);
801046d4:	83 ec 0c             	sub    $0xc,%esp
801046d7:	56                   	push   %esi
801046d8:	e8 54 d0 ff ff       	call   80101731 <iunlockput>
    goto bad;
801046dd:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801046e0:	83 ec 0c             	sub    $0xc,%esp
801046e3:	53                   	push   %ebx
801046e4:	e8 ff cd ff ff       	call   801014e8 <ilock>
  ip->nlink--;
801046e9:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801046ee:	89 1c 24             	mov    %ebx,(%esp)
801046f1:	e8 48 cd ff ff       	call   8010143e <iupdate>
  iunlockput(ip);
801046f6:	89 1c 24             	mov    %ebx,(%esp)
801046f9:	e8 33 d0 ff ff       	call   80101731 <iunlockput>
  end_op();
801046fe:	e8 27 e1 ff ff       	call   8010282a <end_op>
  return -1;
80104703:	83 c4 10             	add    $0x10,%esp
80104706:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010470b:	eb 9c                	jmp    801046a9 <sys_link+0xe0>
    return -1;
8010470d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104712:	eb 95                	jmp    801046a9 <sys_link+0xe0>
80104714:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104719:	eb 8e                	jmp    801046a9 <sys_link+0xe0>

8010471b <sys_unlink>:
{
8010471b:	55                   	push   %ebp
8010471c:	89 e5                	mov    %esp,%ebp
8010471e:	57                   	push   %edi
8010471f:	56                   	push   %esi
80104720:	53                   	push   %ebx
80104721:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104724:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104727:	50                   	push   %eax
80104728:	6a 00                	push   $0x0
8010472a:	e8 3e fa ff ff       	call   8010416d <argstr>
8010472f:	83 c4 10             	add    $0x10,%esp
80104732:	85 c0                	test   %eax,%eax
80104734:	0f 88 81 01 00 00    	js     801048bb <sys_unlink+0x1a0>
  begin_op();
8010473a:	e8 70 e0 ff ff       	call   801027af <begin_op>
  if((dp = nameiparent(path, name)) == 0){
8010473f:	83 ec 08             	sub    $0x8,%esp
80104742:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104745:	50                   	push   %eax
80104746:	ff 75 c4             	pushl  -0x3c(%ebp)
80104749:	e8 4f d5 ff ff       	call   80101c9d <nameiparent>
8010474e:	89 c7                	mov    %eax,%edi
80104750:	83 c4 10             	add    $0x10,%esp
80104753:	85 c0                	test   %eax,%eax
80104755:	0f 84 df 00 00 00    	je     8010483a <sys_unlink+0x11f>
  ilock(dp);
8010475b:	83 ec 0c             	sub    $0xc,%esp
8010475e:	50                   	push   %eax
8010475f:	e8 84 cd ff ff       	call   801014e8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104764:	83 c4 08             	add    $0x8,%esp
80104767:	68 10 6d 10 80       	push   $0x80106d10
8010476c:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010476f:	50                   	push   %eax
80104770:	e8 24 d2 ff ff       	call   80101999 <namecmp>
80104775:	83 c4 10             	add    $0x10,%esp
80104778:	85 c0                	test   %eax,%eax
8010477a:	0f 84 51 01 00 00    	je     801048d1 <sys_unlink+0x1b6>
80104780:	83 ec 08             	sub    $0x8,%esp
80104783:	68 0f 6d 10 80       	push   $0x80106d0f
80104788:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010478b:	50                   	push   %eax
8010478c:	e8 08 d2 ff ff       	call   80101999 <namecmp>
80104791:	83 c4 10             	add    $0x10,%esp
80104794:	85 c0                	test   %eax,%eax
80104796:	0f 84 35 01 00 00    	je     801048d1 <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010479c:	83 ec 04             	sub    $0x4,%esp
8010479f:	8d 45 c0             	lea    -0x40(%ebp),%eax
801047a2:	50                   	push   %eax
801047a3:	8d 45 ca             	lea    -0x36(%ebp),%eax
801047a6:	50                   	push   %eax
801047a7:	57                   	push   %edi
801047a8:	e8 01 d2 ff ff       	call   801019ae <dirlookup>
801047ad:	89 c3                	mov    %eax,%ebx
801047af:	83 c4 10             	add    $0x10,%esp
801047b2:	85 c0                	test   %eax,%eax
801047b4:	0f 84 17 01 00 00    	je     801048d1 <sys_unlink+0x1b6>
  ilock(ip);
801047ba:	83 ec 0c             	sub    $0xc,%esp
801047bd:	50                   	push   %eax
801047be:	e8 25 cd ff ff       	call   801014e8 <ilock>
  if(ip->nlink < 1)
801047c3:	83 c4 10             	add    $0x10,%esp
801047c6:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801047cb:	7e 79                	jle    80104846 <sys_unlink+0x12b>
  if(ip->type == T_DIR && !isdirempty(ip)){
801047cd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047d2:	74 7f                	je     80104853 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
801047d4:	83 ec 04             	sub    $0x4,%esp
801047d7:	6a 10                	push   $0x10
801047d9:	6a 00                	push   $0x0
801047db:	8d 75 d8             	lea    -0x28(%ebp),%esi
801047de:	56                   	push   %esi
801047df:	e8 7c f6 ff ff       	call   80103e60 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801047e4:	6a 10                	push   $0x10
801047e6:	ff 75 c0             	pushl  -0x40(%ebp)
801047e9:	56                   	push   %esi
801047ea:	57                   	push   %edi
801047eb:	e8 88 d0 ff ff       	call   80101878 <writei>
801047f0:	83 c4 20             	add    $0x20,%esp
801047f3:	83 f8 10             	cmp    $0x10,%eax
801047f6:	0f 85 9c 00 00 00    	jne    80104898 <sys_unlink+0x17d>
  if(ip->type == T_DIR){
801047fc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104801:	0f 84 9e 00 00 00    	je     801048a5 <sys_unlink+0x18a>
  iunlockput(dp);
80104807:	83 ec 0c             	sub    $0xc,%esp
8010480a:	57                   	push   %edi
8010480b:	e8 21 cf ff ff       	call   80101731 <iunlockput>
  ip->nlink--;
80104810:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104815:	89 1c 24             	mov    %ebx,(%esp)
80104818:	e8 21 cc ff ff       	call   8010143e <iupdate>
  iunlockput(ip);
8010481d:	89 1c 24             	mov    %ebx,(%esp)
80104820:	e8 0c cf ff ff       	call   80101731 <iunlockput>
  end_op();
80104825:	e8 00 e0 ff ff       	call   8010282a <end_op>
  return 0;
8010482a:	83 c4 10             	add    $0x10,%esp
8010482d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104832:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104835:	5b                   	pop    %ebx
80104836:	5e                   	pop    %esi
80104837:	5f                   	pop    %edi
80104838:	5d                   	pop    %ebp
80104839:	c3                   	ret    
    end_op();
8010483a:	e8 eb df ff ff       	call   8010282a <end_op>
    return -1;
8010483f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104844:	eb ec                	jmp    80104832 <sys_unlink+0x117>
    panic("unlink: nlink < 1");
80104846:	83 ec 0c             	sub    $0xc,%esp
80104849:	68 2e 6d 10 80       	push   $0x80106d2e
8010484e:	e8 f1 ba ff ff       	call   80100344 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104853:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104857:	0f 86 77 ff ff ff    	jbe    801047d4 <sys_unlink+0xb9>
8010485d:	be 20 00 00 00       	mov    $0x20,%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104862:	6a 10                	push   $0x10
80104864:	56                   	push   %esi
80104865:	8d 45 b0             	lea    -0x50(%ebp),%eax
80104868:	50                   	push   %eax
80104869:	53                   	push   %ebx
8010486a:	e8 0d cf ff ff       	call   8010177c <readi>
8010486f:	83 c4 10             	add    $0x10,%esp
80104872:	83 f8 10             	cmp    $0x10,%eax
80104875:	75 14                	jne    8010488b <sys_unlink+0x170>
    if(de.inum != 0)
80104877:	66 83 7d b0 00       	cmpw   $0x0,-0x50(%ebp)
8010487c:	75 47                	jne    801048c5 <sys_unlink+0x1aa>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010487e:	83 c6 10             	add    $0x10,%esi
80104881:	3b 73 58             	cmp    0x58(%ebx),%esi
80104884:	72 dc                	jb     80104862 <sys_unlink+0x147>
80104886:	e9 49 ff ff ff       	jmp    801047d4 <sys_unlink+0xb9>
      panic("isdirempty: readi");
8010488b:	83 ec 0c             	sub    $0xc,%esp
8010488e:	68 40 6d 10 80       	push   $0x80106d40
80104893:	e8 ac ba ff ff       	call   80100344 <panic>
    panic("unlink: writei");
80104898:	83 ec 0c             	sub    $0xc,%esp
8010489b:	68 52 6d 10 80       	push   $0x80106d52
801048a0:	e8 9f ba ff ff       	call   80100344 <panic>
    dp->nlink--;
801048a5:	66 83 6f 56 01       	subw   $0x1,0x56(%edi)
    iupdate(dp);
801048aa:	83 ec 0c             	sub    $0xc,%esp
801048ad:	57                   	push   %edi
801048ae:	e8 8b cb ff ff       	call   8010143e <iupdate>
801048b3:	83 c4 10             	add    $0x10,%esp
801048b6:	e9 4c ff ff ff       	jmp    80104807 <sys_unlink+0xec>
    return -1;
801048bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048c0:	e9 6d ff ff ff       	jmp    80104832 <sys_unlink+0x117>
    iunlockput(ip);
801048c5:	83 ec 0c             	sub    $0xc,%esp
801048c8:	53                   	push   %ebx
801048c9:	e8 63 ce ff ff       	call   80101731 <iunlockput>
    goto bad;
801048ce:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
801048d1:	83 ec 0c             	sub    $0xc,%esp
801048d4:	57                   	push   %edi
801048d5:	e8 57 ce ff ff       	call   80101731 <iunlockput>
  end_op();
801048da:	e8 4b df ff ff       	call   8010282a <end_op>
  return -1;
801048df:	83 c4 10             	add    $0x10,%esp
801048e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048e7:	e9 46 ff ff ff       	jmp    80104832 <sys_unlink+0x117>

801048ec <sys_open>:

int
sys_open(void)
{
801048ec:	55                   	push   %ebp
801048ed:	89 e5                	mov    %esp,%ebp
801048ef:	57                   	push   %edi
801048f0:	56                   	push   %esi
801048f1:	53                   	push   %ebx
801048f2:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801048f5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801048f8:	50                   	push   %eax
801048f9:	6a 00                	push   $0x0
801048fb:	e8 6d f8 ff ff       	call   8010416d <argstr>
80104900:	83 c4 10             	add    $0x10,%esp
80104903:	85 c0                	test   %eax,%eax
80104905:	0f 88 0b 01 00 00    	js     80104a16 <sys_open+0x12a>
8010490b:	83 ec 08             	sub    $0x8,%esp
8010490e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104911:	50                   	push   %eax
80104912:	6a 01                	push   $0x1
80104914:	e8 cd f7 ff ff       	call   801040e6 <argint>
80104919:	83 c4 10             	add    $0x10,%esp
8010491c:	85 c0                	test   %eax,%eax
8010491e:	0f 88 f9 00 00 00    	js     80104a1d <sys_open+0x131>
    return -1;

  begin_op();
80104924:	e8 86 de ff ff       	call   801027af <begin_op>

  if(omode & O_CREATE){
80104929:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
8010492d:	0f 84 8a 00 00 00    	je     801049bd <sys_open+0xd1>
    ip = create(path, T_FILE, 0, 0);
80104933:	83 ec 0c             	sub    $0xc,%esp
80104936:	6a 00                	push   $0x0
80104938:	b9 00 00 00 00       	mov    $0x0,%ecx
8010493d:	ba 02 00 00 00       	mov    $0x2,%edx
80104942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104945:	e8 4b f9 ff ff       	call   80104295 <create>
8010494a:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010494c:	83 c4 10             	add    $0x10,%esp
8010494f:	85 c0                	test   %eax,%eax
80104951:	74 5e                	je     801049b1 <sys_open+0xc5>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104953:	e8 12 c3 ff ff       	call   80100c6a <filealloc>
80104958:	89 c3                	mov    %eax,%ebx
8010495a:	85 c0                	test   %eax,%eax
8010495c:	0f 84 ce 00 00 00    	je     80104a30 <sys_open+0x144>
80104962:	e8 ee f8 ff ff       	call   80104255 <fdalloc>
80104967:	89 c7                	mov    %eax,%edi
80104969:	85 c0                	test   %eax,%eax
8010496b:	0f 88 b3 00 00 00    	js     80104a24 <sys_open+0x138>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104971:	83 ec 0c             	sub    $0xc,%esp
80104974:	56                   	push   %esi
80104975:	e8 30 cc ff ff       	call   801015aa <iunlock>
  end_op();
8010497a:	e8 ab de ff ff       	call   8010282a <end_op>

  f->type = FD_INODE;
8010497f:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104985:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104988:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
8010498f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104992:	89 d0                	mov    %edx,%eax
80104994:	83 f0 01             	xor    $0x1,%eax
80104997:	83 e0 01             	and    $0x1,%eax
8010499a:	88 43 08             	mov    %al,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010499d:	83 c4 10             	add    $0x10,%esp
801049a0:	f6 c2 03             	test   $0x3,%dl
801049a3:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
801049a7:	89 f8                	mov    %edi,%eax
801049a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049ac:	5b                   	pop    %ebx
801049ad:	5e                   	pop    %esi
801049ae:	5f                   	pop    %edi
801049af:	5d                   	pop    %ebp
801049b0:	c3                   	ret    
      end_op();
801049b1:	e8 74 de ff ff       	call   8010282a <end_op>
      return -1;
801049b6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049bb:	eb ea                	jmp    801049a7 <sys_open+0xbb>
    if((ip = namei(path)) == 0){
801049bd:	83 ec 0c             	sub    $0xc,%esp
801049c0:	ff 75 e4             	pushl  -0x1c(%ebp)
801049c3:	e8 bd d2 ff ff       	call   80101c85 <namei>
801049c8:	89 c6                	mov    %eax,%esi
801049ca:	83 c4 10             	add    $0x10,%esp
801049cd:	85 c0                	test   %eax,%eax
801049cf:	74 39                	je     80104a0a <sys_open+0x11e>
    ilock(ip);
801049d1:	83 ec 0c             	sub    $0xc,%esp
801049d4:	50                   	push   %eax
801049d5:	e8 0e cb ff ff       	call   801014e8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801049da:	83 c4 10             	add    $0x10,%esp
801049dd:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801049e2:	0f 85 6b ff ff ff    	jne    80104953 <sys_open+0x67>
801049e8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801049ec:	0f 84 61 ff ff ff    	je     80104953 <sys_open+0x67>
      iunlockput(ip);
801049f2:	83 ec 0c             	sub    $0xc,%esp
801049f5:	56                   	push   %esi
801049f6:	e8 36 cd ff ff       	call   80101731 <iunlockput>
      end_op();
801049fb:	e8 2a de ff ff       	call   8010282a <end_op>
      return -1;
80104a00:	83 c4 10             	add    $0x10,%esp
80104a03:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a08:	eb 9d                	jmp    801049a7 <sys_open+0xbb>
      end_op();
80104a0a:	e8 1b de ff ff       	call   8010282a <end_op>
      return -1;
80104a0f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a14:	eb 91                	jmp    801049a7 <sys_open+0xbb>
    return -1;
80104a16:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a1b:	eb 8a                	jmp    801049a7 <sys_open+0xbb>
80104a1d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a22:	eb 83                	jmp    801049a7 <sys_open+0xbb>
      fileclose(f);
80104a24:	83 ec 0c             	sub    $0xc,%esp
80104a27:	53                   	push   %ebx
80104a28:	e8 ef c2 ff ff       	call   80100d1c <fileclose>
80104a2d:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104a30:	83 ec 0c             	sub    $0xc,%esp
80104a33:	56                   	push   %esi
80104a34:	e8 f8 cc ff ff       	call   80101731 <iunlockput>
    end_op();
80104a39:	e8 ec dd ff ff       	call   8010282a <end_op>
    return -1;
80104a3e:	83 c4 10             	add    $0x10,%esp
80104a41:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104a46:	e9 5c ff ff ff       	jmp    801049a7 <sys_open+0xbb>

80104a4b <sys_mkdir>:

int
sys_mkdir(void)
{
80104a4b:	55                   	push   %ebp
80104a4c:	89 e5                	mov    %esp,%ebp
80104a4e:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104a51:	e8 59 dd ff ff       	call   801027af <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104a56:	83 ec 08             	sub    $0x8,%esp
80104a59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a5c:	50                   	push   %eax
80104a5d:	6a 00                	push   $0x0
80104a5f:	e8 09 f7 ff ff       	call   8010416d <argstr>
80104a64:	83 c4 10             	add    $0x10,%esp
80104a67:	85 c0                	test   %eax,%eax
80104a69:	78 36                	js     80104aa1 <sys_mkdir+0x56>
80104a6b:	83 ec 0c             	sub    $0xc,%esp
80104a6e:	6a 00                	push   $0x0
80104a70:	b9 00 00 00 00       	mov    $0x0,%ecx
80104a75:	ba 01 00 00 00       	mov    $0x1,%edx
80104a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a7d:	e8 13 f8 ff ff       	call   80104295 <create>
80104a82:	83 c4 10             	add    $0x10,%esp
80104a85:	85 c0                	test   %eax,%eax
80104a87:	74 18                	je     80104aa1 <sys_mkdir+0x56>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a89:	83 ec 0c             	sub    $0xc,%esp
80104a8c:	50                   	push   %eax
80104a8d:	e8 9f cc ff ff       	call   80101731 <iunlockput>
  end_op();
80104a92:	e8 93 dd ff ff       	call   8010282a <end_op>
  return 0;
80104a97:	83 c4 10             	add    $0x10,%esp
80104a9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a9f:	c9                   	leave  
80104aa0:	c3                   	ret    
    end_op();
80104aa1:	e8 84 dd ff ff       	call   8010282a <end_op>
    return -1;
80104aa6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104aab:	eb f2                	jmp    80104a9f <sys_mkdir+0x54>

80104aad <sys_mknod>:

int
sys_mknod(void)
{
80104aad:	55                   	push   %ebp
80104aae:	89 e5                	mov    %esp,%ebp
80104ab0:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104ab3:	e8 f7 dc ff ff       	call   801027af <begin_op>
  if((argstr(0, &path)) < 0 ||
80104ab8:	83 ec 08             	sub    $0x8,%esp
80104abb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104abe:	50                   	push   %eax
80104abf:	6a 00                	push   $0x0
80104ac1:	e8 a7 f6 ff ff       	call   8010416d <argstr>
80104ac6:	83 c4 10             	add    $0x10,%esp
80104ac9:	85 c0                	test   %eax,%eax
80104acb:	78 62                	js     80104b2f <sys_mknod+0x82>
     argint(1, &major) < 0 ||
80104acd:	83 ec 08             	sub    $0x8,%esp
80104ad0:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ad3:	50                   	push   %eax
80104ad4:	6a 01                	push   $0x1
80104ad6:	e8 0b f6 ff ff       	call   801040e6 <argint>
  if((argstr(0, &path)) < 0 ||
80104adb:	83 c4 10             	add    $0x10,%esp
80104ade:	85 c0                	test   %eax,%eax
80104ae0:	78 4d                	js     80104b2f <sys_mknod+0x82>
     argint(2, &minor) < 0 ||
80104ae2:	83 ec 08             	sub    $0x8,%esp
80104ae5:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104ae8:	50                   	push   %eax
80104ae9:	6a 02                	push   $0x2
80104aeb:	e8 f6 f5 ff ff       	call   801040e6 <argint>
     argint(1, &major) < 0 ||
80104af0:	83 c4 10             	add    $0x10,%esp
80104af3:	85 c0                	test   %eax,%eax
80104af5:	78 38                	js     80104b2f <sys_mknod+0x82>
     (ip = create(path, T_DEV, major, minor)) == 0){
80104af7:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
80104afb:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
80104afe:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
     argint(2, &minor) < 0 ||
80104b02:	50                   	push   %eax
80104b03:	ba 03 00 00 00       	mov    $0x3,%edx
80104b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b0b:	e8 85 f7 ff ff       	call   80104295 <create>
80104b10:	83 c4 10             	add    $0x10,%esp
80104b13:	85 c0                	test   %eax,%eax
80104b15:	74 18                	je     80104b2f <sys_mknod+0x82>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104b17:	83 ec 0c             	sub    $0xc,%esp
80104b1a:	50                   	push   %eax
80104b1b:	e8 11 cc ff ff       	call   80101731 <iunlockput>
  end_op();
80104b20:	e8 05 dd ff ff       	call   8010282a <end_op>
  return 0;
80104b25:	83 c4 10             	add    $0x10,%esp
80104b28:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b2d:	c9                   	leave  
80104b2e:	c3                   	ret    
    end_op();
80104b2f:	e8 f6 dc ff ff       	call   8010282a <end_op>
    return -1;
80104b34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b39:	eb f2                	jmp    80104b2d <sys_mknod+0x80>

80104b3b <sys_chdir>:

int
sys_chdir(void)
{
80104b3b:	55                   	push   %ebp
80104b3c:	89 e5                	mov    %esp,%ebp
80104b3e:	56                   	push   %esi
80104b3f:	53                   	push   %ebx
80104b40:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104b43:	e8 f3 e7 ff ff       	call   8010333b <myproc>
80104b48:	89 c6                	mov    %eax,%esi

  begin_op();
80104b4a:	e8 60 dc ff ff       	call   801027af <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80104b4f:	83 ec 08             	sub    $0x8,%esp
80104b52:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b55:	50                   	push   %eax
80104b56:	6a 00                	push   $0x0
80104b58:	e8 10 f6 ff ff       	call   8010416d <argstr>
80104b5d:	83 c4 10             	add    $0x10,%esp
80104b60:	85 c0                	test   %eax,%eax
80104b62:	78 52                	js     80104bb6 <sys_chdir+0x7b>
80104b64:	83 ec 0c             	sub    $0xc,%esp
80104b67:	ff 75 f4             	pushl  -0xc(%ebp)
80104b6a:	e8 16 d1 ff ff       	call   80101c85 <namei>
80104b6f:	89 c3                	mov    %eax,%ebx
80104b71:	83 c4 10             	add    $0x10,%esp
80104b74:	85 c0                	test   %eax,%eax
80104b76:	74 3e                	je     80104bb6 <sys_chdir+0x7b>
    end_op();
    return -1;
  }
  ilock(ip);
80104b78:	83 ec 0c             	sub    $0xc,%esp
80104b7b:	50                   	push   %eax
80104b7c:	e8 67 c9 ff ff       	call   801014e8 <ilock>
  if(ip->type != T_DIR){
80104b81:	83 c4 10             	add    $0x10,%esp
80104b84:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b89:	75 37                	jne    80104bc2 <sys_chdir+0x87>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104b8b:	83 ec 0c             	sub    $0xc,%esp
80104b8e:	53                   	push   %ebx
80104b8f:	e8 16 ca ff ff       	call   801015aa <iunlock>
  iput(curproc->cwd);
80104b94:	83 c4 04             	add    $0x4,%esp
80104b97:	ff 76 68             	pushl  0x68(%esi)
80104b9a:	e8 50 ca ff ff       	call   801015ef <iput>
  end_op();
80104b9f:	e8 86 dc ff ff       	call   8010282a <end_op>
  curproc->cwd = ip;
80104ba4:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104ba7:	83 c4 10             	add    $0x10,%esp
80104baa:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104baf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bb2:	5b                   	pop    %ebx
80104bb3:	5e                   	pop    %esi
80104bb4:	5d                   	pop    %ebp
80104bb5:	c3                   	ret    
    end_op();
80104bb6:	e8 6f dc ff ff       	call   8010282a <end_op>
    return -1;
80104bbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc0:	eb ed                	jmp    80104baf <sys_chdir+0x74>
    iunlockput(ip);
80104bc2:	83 ec 0c             	sub    $0xc,%esp
80104bc5:	53                   	push   %ebx
80104bc6:	e8 66 cb ff ff       	call   80101731 <iunlockput>
    end_op();
80104bcb:	e8 5a dc ff ff       	call   8010282a <end_op>
    return -1;
80104bd0:	83 c4 10             	add    $0x10,%esp
80104bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bd8:	eb d5                	jmp    80104baf <sys_chdir+0x74>

80104bda <sys_exec>:

int
sys_exec(void)
{
80104bda:	55                   	push   %ebp
80104bdb:	89 e5                	mov    %esp,%ebp
80104bdd:	57                   	push   %edi
80104bde:	56                   	push   %esi
80104bdf:	53                   	push   %ebx
80104be0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104be6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104be9:	50                   	push   %eax
80104bea:	6a 00                	push   $0x0
80104bec:	e8 7c f5 ff ff       	call   8010416d <argstr>
80104bf1:	83 c4 10             	add    $0x10,%esp
80104bf4:	85 c0                	test   %eax,%eax
80104bf6:	0f 88 b4 00 00 00    	js     80104cb0 <sys_exec+0xd6>
80104bfc:	83 ec 08             	sub    $0x8,%esp
80104bff:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80104c05:	50                   	push   %eax
80104c06:	6a 01                	push   $0x1
80104c08:	e8 d9 f4 ff ff       	call   801040e6 <argint>
80104c0d:	83 c4 10             	add    $0x10,%esp
80104c10:	85 c0                	test   %eax,%eax
80104c12:	0f 88 9f 00 00 00    	js     80104cb7 <sys_exec+0xdd>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104c18:	83 ec 04             	sub    $0x4,%esp
80104c1b:	68 80 00 00 00       	push   $0x80
80104c20:	6a 00                	push   $0x0
80104c22:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104c28:	50                   	push   %eax
80104c29:	e8 32 f2 ff ff       	call   80103e60 <memset>
80104c2e:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80104c31:	be 00 00 00 00       	mov    $0x0,%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104c36:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
80104c3c:	8d 1c b5 00 00 00 00 	lea    0x0(,%esi,4),%ebx
80104c43:	83 ec 08             	sub    $0x8,%esp
80104c46:	57                   	push   %edi
80104c47:	89 d8                	mov    %ebx,%eax
80104c49:	03 85 60 ff ff ff    	add    -0xa0(%ebp),%eax
80104c4f:	50                   	push   %eax
80104c50:	e8 05 f4 ff ff       	call   8010405a <fetchint>
80104c55:	83 c4 10             	add    $0x10,%esp
80104c58:	85 c0                	test   %eax,%eax
80104c5a:	78 62                	js     80104cbe <sys_exec+0xe4>
      return -1;
    if(uarg == 0){
80104c5c:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80104c62:	85 c0                	test   %eax,%eax
80104c64:	74 28                	je     80104c8e <sys_exec+0xb4>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104c66:	83 ec 08             	sub    $0x8,%esp
80104c69:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
80104c6f:	01 d3                	add    %edx,%ebx
80104c71:	53                   	push   %ebx
80104c72:	50                   	push   %eax
80104c73:	e8 1e f4 ff ff       	call   80104096 <fetchstr>
80104c78:	83 c4 10             	add    $0x10,%esp
80104c7b:	85 c0                	test   %eax,%eax
80104c7d:	78 4c                	js     80104ccb <sys_exec+0xf1>
  for(i=0;; i++){
80104c7f:	83 c6 01             	add    $0x1,%esi
    if(i >= NELEM(argv))
80104c82:	83 fe 20             	cmp    $0x20,%esi
80104c85:	75 b5                	jne    80104c3c <sys_exec+0x62>
      return -1;
80104c87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c8c:	eb 35                	jmp    80104cc3 <sys_exec+0xe9>
      argv[i] = 0;
80104c8e:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80104c95:	00 00 00 00 
      return -1;
  }
  return exec(path, argv);
80104c99:	83 ec 08             	sub    $0x8,%esp
80104c9c:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80104ca2:	50                   	push   %eax
80104ca3:	ff 75 e4             	pushl  -0x1c(%ebp)
80104ca6:	e8 67 bc ff ff       	call   80100912 <exec>
80104cab:	83 c4 10             	add    $0x10,%esp
80104cae:	eb 13                	jmp    80104cc3 <sys_exec+0xe9>
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cb5:	eb 0c                	jmp    80104cc3 <sys_exec+0xe9>
80104cb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cbc:	eb 05                	jmp    80104cc3 <sys_exec+0xe9>
      return -1;
80104cbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cc6:	5b                   	pop    %ebx
80104cc7:	5e                   	pop    %esi
80104cc8:	5f                   	pop    %edi
80104cc9:	5d                   	pop    %ebp
80104cca:	c3                   	ret    
      return -1;
80104ccb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cd0:	eb f1                	jmp    80104cc3 <sys_exec+0xe9>

80104cd2 <sys_pipe>:

int
sys_pipe(void)
{
80104cd2:	55                   	push   %ebp
80104cd3:	89 e5                	mov    %esp,%ebp
80104cd5:	53                   	push   %ebx
80104cd6:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104cd9:	6a 08                	push   $0x8
80104cdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cde:	50                   	push   %eax
80104cdf:	6a 00                	push   $0x0
80104ce1:	e8 26 f4 ff ff       	call   8010410c <argptr>
80104ce6:	83 c4 10             	add    $0x10,%esp
80104ce9:	85 c0                	test   %eax,%eax
80104ceb:	78 46                	js     80104d33 <sys_pipe+0x61>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104ced:	83 ec 08             	sub    $0x8,%esp
80104cf0:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104cf3:	50                   	push   %eax
80104cf4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cf7:	50                   	push   %eax
80104cf8:	e8 e1 e0 ff ff       	call   80102dde <pipealloc>
80104cfd:	83 c4 10             	add    $0x10,%esp
80104d00:	85 c0                	test   %eax,%eax
80104d02:	78 36                	js     80104d3a <sys_pipe+0x68>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d07:	e8 49 f5 ff ff       	call   80104255 <fdalloc>
80104d0c:	89 c3                	mov    %eax,%ebx
80104d0e:	85 c0                	test   %eax,%eax
80104d10:	78 3c                	js     80104d4e <sys_pipe+0x7c>
80104d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104d15:	e8 3b f5 ff ff       	call   80104255 <fdalloc>
80104d1a:	85 c0                	test   %eax,%eax
80104d1c:	78 23                	js     80104d41 <sys_pipe+0x6f>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104d1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d21:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d26:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104d2e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d31:	c9                   	leave  
80104d32:	c3                   	ret    
    return -1;
80104d33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d38:	eb f4                	jmp    80104d2e <sys_pipe+0x5c>
    return -1;
80104d3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d3f:	eb ed                	jmp    80104d2e <sys_pipe+0x5c>
      myproc()->ofile[fd0] = 0;
80104d41:	e8 f5 e5 ff ff       	call   8010333b <myproc>
80104d46:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104d4d:	00 
    fileclose(rf);
80104d4e:	83 ec 0c             	sub    $0xc,%esp
80104d51:	ff 75 f0             	pushl  -0x10(%ebp)
80104d54:	e8 c3 bf ff ff       	call   80100d1c <fileclose>
    fileclose(wf);
80104d59:	83 c4 04             	add    $0x4,%esp
80104d5c:	ff 75 ec             	pushl  -0x14(%ebp)
80104d5f:	e8 b8 bf ff ff       	call   80100d1c <fileclose>
    return -1;
80104d64:	83 c4 10             	add    $0x10,%esp
80104d67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d6c:	eb c0                	jmp    80104d2e <sys_pipe+0x5c>

80104d6e <sys_fork>:
#include "pdx-kernel.h"
#endif // PDX_XV6

int
sys_fork(void)
{
80104d6e:	55                   	push   %ebp
80104d6f:	89 e5                	mov    %esp,%ebp
80104d71:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104d74:	e8 3a e7 ff ff       	call   801034b3 <fork>
}
80104d79:	c9                   	leave  
80104d7a:	c3                   	ret    

80104d7b <sys_exit>:

int
sys_exit(void)
{
80104d7b:	55                   	push   %ebp
80104d7c:	89 e5                	mov    %esp,%ebp
80104d7e:	83 ec 08             	sub    $0x8,%esp
  exit();
80104d81:	e8 7b e9 ff ff       	call   80103701 <exit>
  return 0;  // not reached
}
80104d86:	b8 00 00 00 00       	mov    $0x0,%eax
80104d8b:	c9                   	leave  
80104d8c:	c3                   	ret    

80104d8d <sys_wait>:

int
sys_wait(void)
{
80104d8d:	55                   	push   %ebp
80104d8e:	89 e5                	mov    %esp,%ebp
80104d90:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104d93:	e8 29 eb ff ff       	call   801038c1 <wait>
}
80104d98:	c9                   	leave  
80104d99:	c3                   	ret    

80104d9a <sys_kill>:

int
sys_kill(void)
{
80104d9a:	55                   	push   %ebp
80104d9b:	89 e5                	mov    %esp,%ebp
80104d9d:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104da0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104da3:	50                   	push   %eax
80104da4:	6a 00                	push   $0x0
80104da6:	e8 3b f3 ff ff       	call   801040e6 <argint>
80104dab:	83 c4 10             	add    $0x10,%esp
80104dae:	85 c0                	test   %eax,%eax
80104db0:	78 10                	js     80104dc2 <sys_kill+0x28>
    return -1;
  return kill(pid);
80104db2:	83 ec 0c             	sub    $0xc,%esp
80104db5:	ff 75 f4             	pushl  -0xc(%ebp)
80104db8:	e8 08 ec ff ff       	call   801039c5 <kill>
80104dbd:	83 c4 10             	add    $0x10,%esp
}
80104dc0:	c9                   	leave  
80104dc1:	c3                   	ret    
    return -1;
80104dc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dc7:	eb f7                	jmp    80104dc0 <sys_kill+0x26>

80104dc9 <sys_getpid>:

int
sys_getpid(void)
{
80104dc9:	55                   	push   %ebp
80104dca:	89 e5                	mov    %esp,%ebp
80104dcc:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104dcf:	e8 67 e5 ff ff       	call   8010333b <myproc>
80104dd4:	8b 40 10             	mov    0x10(%eax),%eax
}
80104dd7:	c9                   	leave  
80104dd8:	c3                   	ret    

80104dd9 <sys_sbrk>:

int
sys_sbrk(void)
{
80104dd9:	55                   	push   %ebp
80104dda:	89 e5                	mov    %esp,%ebp
80104ddc:	53                   	push   %ebx
80104ddd:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104de0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104de3:	50                   	push   %eax
80104de4:	6a 00                	push   $0x0
80104de6:	e8 fb f2 ff ff       	call   801040e6 <argint>
80104deb:	83 c4 10             	add    $0x10,%esp
80104dee:	85 c0                	test   %eax,%eax
80104df0:	78 26                	js     80104e18 <sys_sbrk+0x3f>
    return -1;
  addr = myproc()->sz;
80104df2:	e8 44 e5 ff ff       	call   8010333b <myproc>
80104df7:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104df9:	83 ec 0c             	sub    $0xc,%esp
80104dfc:	ff 75 f4             	pushl  -0xc(%ebp)
80104dff:	e8 42 e6 ff ff       	call   80103446 <growproc>
80104e04:	83 c4 10             	add    $0x10,%esp
80104e07:	85 c0                	test   %eax,%eax
    return -1;
80104e09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e0e:	0f 48 d8             	cmovs  %eax,%ebx
  return addr;
}
80104e11:	89 d8                	mov    %ebx,%eax
80104e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e16:	c9                   	leave  
80104e17:	c3                   	ret    
    return -1;
80104e18:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104e1d:	eb f2                	jmp    80104e11 <sys_sbrk+0x38>

80104e1f <sys_sleep>:

int
sys_sleep(void)
{
80104e1f:	55                   	push   %ebp
80104e20:	89 e5                	mov    %esp,%ebp
80104e22:	56                   	push   %esi
80104e23:	53                   	push   %ebx
80104e24:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104e27:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e2a:	50                   	push   %eax
80104e2b:	6a 00                	push   $0x0
80104e2d:	e8 b4 f2 ff ff       	call   801040e6 <argint>
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	85 c0                	test   %eax,%eax
80104e37:	78 39                	js     80104e72 <sys_sleep+0x53>
    return -1;
  ticks0 = ticks;
80104e39:	8b 35 80 45 11 80    	mov    0x80114580,%esi
  while(ticks - ticks0 < n){
80104e3f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80104e42:	85 db                	test   %ebx,%ebx
80104e44:	74 38                	je     80104e7e <sys_sleep+0x5f>
    if(myproc()->killed){
80104e46:	e8 f0 e4 ff ff       	call   8010333b <myproc>
80104e4b:	8b 58 24             	mov    0x24(%eax),%ebx
80104e4e:	85 db                	test   %ebx,%ebx
80104e50:	75 27                	jne    80104e79 <sys_sleep+0x5a>
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
80104e52:	83 ec 08             	sub    $0x8,%esp
80104e55:	6a 00                	push   $0x0
80104e57:	68 80 45 11 80       	push   $0x80114580
80104e5c:	e8 9f e9 ff ff       	call   80103800 <sleep>
  while(ticks - ticks0 < n){
80104e61:	a1 80 45 11 80       	mov    0x80114580,%eax
80104e66:	29 f0                	sub    %esi,%eax
80104e68:	83 c4 10             	add    $0x10,%esp
80104e6b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104e6e:	72 d6                	jb     80104e46 <sys_sleep+0x27>
80104e70:	eb 0c                	jmp    80104e7e <sys_sleep+0x5f>
    return -1;
80104e72:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104e77:	eb 05                	jmp    80104e7e <sys_sleep+0x5f>
      return -1;
80104e79:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  }
  return 0;
}
80104e7e:	89 d8                	mov    %ebx,%eax
80104e80:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e83:	5b                   	pop    %ebx
80104e84:	5e                   	pop    %esi
80104e85:	5d                   	pop    %ebp
80104e86:	c3                   	ret    

80104e87 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104e87:	55                   	push   %ebp
80104e88:	89 e5                	mov    %esp,%ebp
  uint xticks;

  xticks = ticks;
  return xticks;
}
80104e8a:	a1 80 45 11 80       	mov    0x80114580,%eax
80104e8f:	5d                   	pop    %ebp
80104e90:	c3                   	ret    

80104e91 <sys_halt>:

#ifdef PDX_XV6
// Turn off the computer
int
sys_halt(void)
{
80104e91:	55                   	push   %ebp
80104e92:	89 e5                	mov    %esp,%ebp
80104e94:	83 ec 14             	sub    $0x14,%esp
  cprintf("Shutting down ...\n");
80104e97:	68 61 6d 10 80       	push   $0x80106d61
80104e9c:	e8 40 b7 ff ff       	call   801005e1 <cprintf>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104ea1:	b8 00 20 00 00       	mov    $0x2000,%eax
80104ea6:	ba 04 06 00 00       	mov    $0x604,%edx
80104eab:	66 ef                	out    %ax,(%dx)
  outw( 0x604, 0x0 | 0x2000);
  return 0;
}
80104ead:	b8 00 00 00 00       	mov    $0x0,%eax
80104eb2:	c9                   	leave  
80104eb3:	c3                   	ret    

80104eb4 <sys_date>:
#endif // PDX_XV6

#ifdef CS333_P1
int
sys_date(void)
{
80104eb4:	55                   	push   %ebp
80104eb5:	89 e5                	mov    %esp,%ebp
80104eb7:	83 ec 1c             	sub    $0x1c,%esp
  struct rtcdate *d;

 if(argptr(0, (void*)&d, sizeof(struct rtcdate)) < 0)
80104eba:	6a 18                	push   $0x18
80104ebc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ebf:	50                   	push   %eax
80104ec0:	6a 00                	push   $0x0
80104ec2:	e8 45 f2 ff ff       	call   8010410c <argptr>
80104ec7:	83 c4 10             	add    $0x10,%esp
80104eca:	85 c0                	test   %eax,%eax
80104ecc:	78 15                	js     80104ee3 <sys_date+0x2f>
   return -1;
 cmostime(d);
80104ece:	83 ec 0c             	sub    $0xc,%esp
80104ed1:	ff 75 f4             	pushl  -0xc(%ebp)
80104ed4:	e8 43 d6 ff ff       	call   8010251c <cmostime>
 return 0;
80104ed9:	83 c4 10             	add    $0x10,%esp
80104edc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ee1:	c9                   	leave  
80104ee2:	c3                   	ret    
   return -1;
80104ee3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee8:	eb f7                	jmp    80104ee1 <sys_date+0x2d>

80104eea <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104eea:	1e                   	push   %ds
  pushl %es
80104eeb:	06                   	push   %es
  pushl %fs
80104eec:	0f a0                	push   %fs
  pushl %gs
80104eee:	0f a8                	push   %gs
  pushal
80104ef0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104ef1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104ef5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104ef7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104ef9:	54                   	push   %esp
  call trap
80104efa:	e8 a5 00 00 00       	call   80104fa4 <trap>
  addl $4, %esp
80104eff:	83 c4 04             	add    $0x4,%esp

80104f02 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104f02:	61                   	popa   
  popl %gs
80104f03:	0f a9                	pop    %gs
  popl %fs
80104f05:	0f a1                	pop    %fs
  popl %es
80104f07:	07                   	pop    %es
  popl %ds
80104f08:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104f09:	83 c4 08             	add    $0x8,%esp
  iret
80104f0c:	cf                   	iret   

80104f0d <tvinit>:
uint ticks;
#endif // PDX_XV6

void
tvinit(void)
{
80104f0d:	55                   	push   %ebp
80104f0e:	89 e5                	mov    %esp,%ebp
  int i;

  for(i = 0; i < 256; i++)
80104f10:	b8 00 00 00 00       	mov    $0x0,%eax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104f15:	8b 14 85 08 90 10 80 	mov    -0x7fef6ff8(,%eax,4),%edx
80104f1c:	66 89 14 c5 80 3d 11 	mov    %dx,-0x7feec280(,%eax,8)
80104f23:	80 
80104f24:	66 c7 04 c5 82 3d 11 	movw   $0x8,-0x7feec27e(,%eax,8)
80104f2b:	80 08 00 
80104f2e:	c6 04 c5 84 3d 11 80 	movb   $0x0,-0x7feec27c(,%eax,8)
80104f35:	00 
80104f36:	c6 04 c5 85 3d 11 80 	movb   $0x8e,-0x7feec27b(,%eax,8)
80104f3d:	8e 
80104f3e:	c1 ea 10             	shr    $0x10,%edx
80104f41:	66 89 14 c5 86 3d 11 	mov    %dx,-0x7feec27a(,%eax,8)
80104f48:	80 
  for(i = 0; i < 256; i++)
80104f49:	83 c0 01             	add    $0x1,%eax
80104f4c:	3d 00 01 00 00       	cmp    $0x100,%eax
80104f51:	75 c2                	jne    80104f15 <tvinit+0x8>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104f53:	a1 08 91 10 80       	mov    0x80109108,%eax
80104f58:	66 a3 80 3f 11 80    	mov    %ax,0x80113f80
80104f5e:	66 c7 05 82 3f 11 80 	movw   $0x8,0x80113f82
80104f65:	08 00 
80104f67:	c6 05 84 3f 11 80 00 	movb   $0x0,0x80113f84
80104f6e:	c6 05 85 3f 11 80 ef 	movb   $0xef,0x80113f85
80104f75:	c1 e8 10             	shr    $0x10,%eax
80104f78:	66 a3 86 3f 11 80    	mov    %ax,0x80113f86

#ifndef PDX_XV6
  initlock(&tickslock, "time");
#endif // PDX_XV6
}
80104f7e:	5d                   	pop    %ebp
80104f7f:	c3                   	ret    

80104f80 <idtinit>:

void
idtinit(void)
{
80104f80:	55                   	push   %ebp
80104f81:	89 e5                	mov    %esp,%ebp
80104f83:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104f86:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104f8c:	b8 80 3d 11 80       	mov    $0x80113d80,%eax
80104f91:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104f95:	c1 e8 10             	shr    $0x10,%eax
80104f98:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104f9c:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104f9f:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104fa2:	c9                   	leave  
80104fa3:	c3                   	ret    

80104fa4 <trap>:

void
trap(struct trapframe *tf)
{
80104fa4:	55                   	push   %ebp
80104fa5:	89 e5                	mov    %esp,%ebp
80104fa7:	57                   	push   %edi
80104fa8:	56                   	push   %esi
80104fa9:	53                   	push   %ebx
80104faa:	83 ec 1c             	sub    $0x1c,%esp
80104fad:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80104fb0:	8b 47 30             	mov    0x30(%edi),%eax
80104fb3:	83 f8 40             	cmp    $0x40,%eax
80104fb6:	74 13                	je     80104fcb <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80104fb8:	83 e8 20             	sub    $0x20,%eax
80104fbb:	83 f8 1f             	cmp    $0x1f,%eax
80104fbe:	0f 87 1f 01 00 00    	ja     801050e3 <trap+0x13f>
80104fc4:	ff 24 85 14 6e 10 80 	jmp    *-0x7fef91ec(,%eax,4)
    if(myproc()->killed)
80104fcb:	e8 6b e3 ff ff       	call   8010333b <myproc>
80104fd0:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fd4:	75 1f                	jne    80104ff5 <trap+0x51>
    myproc()->tf = tf;
80104fd6:	e8 60 e3 ff ff       	call   8010333b <myproc>
80104fdb:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80104fde:	e8 bd f1 ff ff       	call   801041a0 <syscall>
    if(myproc()->killed)
80104fe3:	e8 53 e3 ff ff       	call   8010333b <myproc>
80104fe8:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104fec:	74 7e                	je     8010506c <trap+0xc8>
      exit();
80104fee:	e8 0e e7 ff ff       	call   80103701 <exit>
80104ff3:	eb 77                	jmp    8010506c <trap+0xc8>
      exit();
80104ff5:	e8 07 e7 ff ff       	call   80103701 <exit>
80104ffa:	eb da                	jmp    80104fd6 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80104ffc:	e8 1f e3 ff ff       	call   80103320 <cpuid>
80105001:	85 c0                	test   %eax,%eax
80105003:	74 6f                	je     80105074 <trap+0xd0>
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
#endif // PDX_XV6
    }
    lapiceoi();
80105005:	e8 52 d4 ff ff       	call   8010245c <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010500a:	e8 2c e3 ff ff       	call   8010333b <myproc>
8010500f:	85 c0                	test   %eax,%eax
80105011:	74 1c                	je     8010502f <trap+0x8b>
80105013:	e8 23 e3 ff ff       	call   8010333b <myproc>
80105018:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010501c:	74 11                	je     8010502f <trap+0x8b>
8010501e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105022:	83 e0 03             	and    $0x3,%eax
80105025:	66 83 f8 03          	cmp    $0x3,%ax
80105029:	0f 84 48 01 00 00    	je     80105177 <trap+0x1d3>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
8010502f:	e8 07 e3 ff ff       	call   8010333b <myproc>
80105034:	85 c0                	test   %eax,%eax
80105036:	74 0f                	je     80105047 <trap+0xa3>
80105038:	e8 fe e2 ff ff       	call   8010333b <myproc>
8010503d:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105041:	0f 84 3a 01 00 00    	je     80105181 <trap+0x1dd>
    tf->trapno == T_IRQ0+IRQ_TIMER)
#endif // PDX_XV6
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105047:	e8 ef e2 ff ff       	call   8010333b <myproc>
8010504c:	85 c0                	test   %eax,%eax
8010504e:	74 1c                	je     8010506c <trap+0xc8>
80105050:	e8 e6 e2 ff ff       	call   8010333b <myproc>
80105055:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105059:	74 11                	je     8010506c <trap+0xc8>
8010505b:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
8010505f:	83 e0 03             	and    $0x3,%eax
80105062:	66 83 f8 03          	cmp    $0x3,%ax
80105066:	0f 84 48 01 00 00    	je     801051b4 <trap+0x210>
    exit();
}
8010506c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010506f:	5b                   	pop    %ebx
80105070:	5e                   	pop    %esi
80105071:	5f                   	pop    %edi
80105072:	5d                   	pop    %ebp
80105073:	c3                   	ret    
// atom_inc() necessary for removal of tickslock
// other atomic ops added for completeness
static inline void
atom_inc(volatile int *num)
{
  asm volatile ( "lock incl %0" : "=m" (*num));
80105074:	f0 ff 05 80 45 11 80 	lock incl 0x80114580
      wakeup(&ticks);
8010507b:	83 ec 0c             	sub    $0xc,%esp
8010507e:	68 80 45 11 80       	push   $0x80114580
80105083:	e8 14 e9 ff ff       	call   8010399c <wakeup>
80105088:	83 c4 10             	add    $0x10,%esp
8010508b:	e9 75 ff ff ff       	jmp    80105005 <trap+0x61>
    ideintr();
80105090:	e8 5d cd ff ff       	call   80101df2 <ideintr>
    lapiceoi();
80105095:	e8 c2 d3 ff ff       	call   8010245c <lapiceoi>
    break;
8010509a:	e9 6b ff ff ff       	jmp    8010500a <trap+0x66>
    kbdintr();
8010509f:	e8 ec d1 ff ff       	call   80102290 <kbdintr>
    lapiceoi();
801050a4:	e8 b3 d3 ff ff       	call   8010245c <lapiceoi>
    break;
801050a9:	e9 5c ff ff ff       	jmp    8010500a <trap+0x66>
    uartintr();
801050ae:	e8 39 02 00 00       	call   801052ec <uartintr>
    lapiceoi();
801050b3:	e8 a4 d3 ff ff       	call   8010245c <lapiceoi>
    break;
801050b8:	e9 4d ff ff ff       	jmp    8010500a <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801050bd:	8b 77 38             	mov    0x38(%edi),%esi
801050c0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801050c4:	e8 57 e2 ff ff       	call   80103320 <cpuid>
801050c9:	56                   	push   %esi
801050ca:	53                   	push   %ebx
801050cb:	50                   	push   %eax
801050cc:	68 74 6d 10 80       	push   $0x80106d74
801050d1:	e8 0b b5 ff ff       	call   801005e1 <cprintf>
    lapiceoi();
801050d6:	e8 81 d3 ff ff       	call   8010245c <lapiceoi>
    break;
801050db:	83 c4 10             	add    $0x10,%esp
801050de:	e9 27 ff ff ff       	jmp    8010500a <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
801050e3:	e8 53 e2 ff ff       	call   8010333b <myproc>
801050e8:	85 c0                	test   %eax,%eax
801050ea:	74 60                	je     8010514c <trap+0x1a8>
801050ec:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801050f0:	74 5a                	je     8010514c <trap+0x1a8>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801050f2:	0f 20 d0             	mov    %cr2,%eax
801050f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801050f8:	8b 77 38             	mov    0x38(%edi),%esi
801050fb:	e8 20 e2 ff ff       	call   80103320 <cpuid>
80105100:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105103:	8b 5f 34             	mov    0x34(%edi),%ebx
80105106:	8b 4f 30             	mov    0x30(%edi),%ecx
80105109:	89 4d e0             	mov    %ecx,-0x20(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
8010510c:	e8 2a e2 ff ff       	call   8010333b <myproc>
80105111:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105114:	e8 22 e2 ff ff       	call   8010333b <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105119:	ff 75 d8             	pushl  -0x28(%ebp)
8010511c:	56                   	push   %esi
8010511d:	ff 75 e4             	pushl  -0x1c(%ebp)
80105120:	53                   	push   %ebx
80105121:	ff 75 e0             	pushl  -0x20(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105124:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105127:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010512a:	52                   	push   %edx
8010512b:	ff 70 10             	pushl  0x10(%eax)
8010512e:	68 cc 6d 10 80       	push   $0x80106dcc
80105133:	e8 a9 b4 ff ff       	call   801005e1 <cprintf>
    myproc()->killed = 1;
80105138:	83 c4 20             	add    $0x20,%esp
8010513b:	e8 fb e1 ff ff       	call   8010333b <myproc>
80105140:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105147:	e9 be fe ff ff       	jmp    8010500a <trap+0x66>
8010514c:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010514f:	8b 5f 38             	mov    0x38(%edi),%ebx
80105152:	e8 c9 e1 ff ff       	call   80103320 <cpuid>
80105157:	83 ec 0c             	sub    $0xc,%esp
8010515a:	56                   	push   %esi
8010515b:	53                   	push   %ebx
8010515c:	50                   	push   %eax
8010515d:	ff 77 30             	pushl  0x30(%edi)
80105160:	68 98 6d 10 80       	push   $0x80106d98
80105165:	e8 77 b4 ff ff       	call   801005e1 <cprintf>
      panic("trap");
8010516a:	83 c4 14             	add    $0x14,%esp
8010516d:	68 0f 6e 10 80       	push   $0x80106e0f
80105172:	e8 cd b1 ff ff       	call   80100344 <panic>
    exit();
80105177:	e8 85 e5 ff ff       	call   80103701 <exit>
8010517c:	e9 ae fe ff ff       	jmp    8010502f <trap+0x8b>
  if(myproc() && myproc()->state == RUNNING &&
80105181:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105185:	0f 85 bc fe ff ff    	jne    80105047 <trap+0xa3>
    tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
8010518b:	8b 0d 80 45 11 80    	mov    0x80114580,%ecx
80105191:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80105196:	89 c8                	mov    %ecx,%eax
80105198:	f7 e2                	mul    %edx
8010519a:	c1 ea 03             	shr    $0x3,%edx
8010519d:	8d 04 92             	lea    (%edx,%edx,4),%eax
801051a0:	01 c0                	add    %eax,%eax
801051a2:	39 c1                	cmp    %eax,%ecx
801051a4:	0f 85 9d fe ff ff    	jne    80105047 <trap+0xa3>
    yield();
801051aa:	e8 16 e6 ff ff       	call   801037c5 <yield>
801051af:	e9 93 fe ff ff       	jmp    80105047 <trap+0xa3>
    exit();
801051b4:	e8 48 e5 ff ff       	call   80103701 <exit>
801051b9:	e9 ae fe ff ff       	jmp    8010506c <trap+0xc8>

801051be <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801051be:	55                   	push   %ebp
801051bf:	89 e5                	mov    %esp,%ebp
  if(!uart)
801051c1:	83 3d 14 b6 10 80 00 	cmpl   $0x0,0x8010b614
801051c8:	74 15                	je     801051df <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801051ca:	ba fd 03 00 00       	mov    $0x3fd,%edx
801051cf:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801051d0:	a8 01                	test   $0x1,%al
801051d2:	74 12                	je     801051e6 <uartgetc+0x28>
801051d4:	ba f8 03 00 00       	mov    $0x3f8,%edx
801051d9:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801051da:	0f b6 c0             	movzbl %al,%eax
}
801051dd:	5d                   	pop    %ebp
801051de:	c3                   	ret    
    return -1;
801051df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051e4:	eb f7                	jmp    801051dd <uartgetc+0x1f>
    return -1;
801051e6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051eb:	eb f0                	jmp    801051dd <uartgetc+0x1f>

801051ed <uartputc>:
  if(!uart)
801051ed:	83 3d 14 b6 10 80 00 	cmpl   $0x0,0x8010b614
801051f4:	74 4f                	je     80105245 <uartputc+0x58>
{
801051f6:	55                   	push   %ebp
801051f7:	89 e5                	mov    %esp,%ebp
801051f9:	56                   	push   %esi
801051fa:	53                   	push   %ebx
801051fb:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105200:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105201:	a8 20                	test   $0x20,%al
80105203:	75 30                	jne    80105235 <uartputc+0x48>
    microdelay(10);
80105205:	83 ec 0c             	sub    $0xc,%esp
80105208:	6a 0a                	push   $0xa
8010520a:	e8 6c d2 ff ff       	call   8010247b <microdelay>
8010520f:	83 c4 10             	add    $0x10,%esp
80105212:	bb 7f 00 00 00       	mov    $0x7f,%ebx
80105217:	be fd 03 00 00       	mov    $0x3fd,%esi
8010521c:	89 f2                	mov    %esi,%edx
8010521e:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010521f:	a8 20                	test   $0x20,%al
80105221:	75 12                	jne    80105235 <uartputc+0x48>
    microdelay(10);
80105223:	83 ec 0c             	sub    $0xc,%esp
80105226:	6a 0a                	push   $0xa
80105228:	e8 4e d2 ff ff       	call   8010247b <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010522d:	83 c4 10             	add    $0x10,%esp
80105230:	83 eb 01             	sub    $0x1,%ebx
80105233:	75 e7                	jne    8010521c <uartputc+0x2f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105235:	8b 45 08             	mov    0x8(%ebp),%eax
80105238:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010523d:	ee                   	out    %al,(%dx)
}
8010523e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105241:	5b                   	pop    %ebx
80105242:	5e                   	pop    %esi
80105243:	5d                   	pop    %ebp
80105244:	c3                   	ret    
80105245:	f3 c3                	repz ret 

80105247 <uartinit>:
{
80105247:	55                   	push   %ebp
80105248:	89 e5                	mov    %esp,%ebp
8010524a:	56                   	push   %esi
8010524b:	53                   	push   %ebx
8010524c:	b9 00 00 00 00       	mov    $0x0,%ecx
80105251:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105256:	89 c8                	mov    %ecx,%eax
80105258:	ee                   	out    %al,(%dx)
80105259:	be fb 03 00 00       	mov    $0x3fb,%esi
8010525e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105263:	89 f2                	mov    %esi,%edx
80105265:	ee                   	out    %al,(%dx)
80105266:	b8 0c 00 00 00       	mov    $0xc,%eax
8010526b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105270:	ee                   	out    %al,(%dx)
80105271:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105276:	89 c8                	mov    %ecx,%eax
80105278:	89 da                	mov    %ebx,%edx
8010527a:	ee                   	out    %al,(%dx)
8010527b:	b8 03 00 00 00       	mov    $0x3,%eax
80105280:	89 f2                	mov    %esi,%edx
80105282:	ee                   	out    %al,(%dx)
80105283:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105288:	89 c8                	mov    %ecx,%eax
8010528a:	ee                   	out    %al,(%dx)
8010528b:	b8 01 00 00 00       	mov    $0x1,%eax
80105290:	89 da                	mov    %ebx,%edx
80105292:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105293:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105298:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105299:	3c ff                	cmp    $0xff,%al
8010529b:	74 48                	je     801052e5 <uartinit+0x9e>
  uart = 1;
8010529d:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
801052a4:	00 00 00 
801052a7:	ba fa 03 00 00       	mov    $0x3fa,%edx
801052ac:	ec                   	in     (%dx),%al
801052ad:	ba f8 03 00 00       	mov    $0x3f8,%edx
801052b2:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801052b3:	83 ec 08             	sub    $0x8,%esp
801052b6:	6a 00                	push   $0x0
801052b8:	6a 04                	push   $0x4
801052ba:	e8 49 cd ff ff       	call   80102008 <ioapicenable>
801052bf:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801052c2:	bb 94 6e 10 80       	mov    $0x80106e94,%ebx
801052c7:	b8 78 00 00 00       	mov    $0x78,%eax
    uartputc(*p);
801052cc:	83 ec 0c             	sub    $0xc,%esp
801052cf:	0f be c0             	movsbl %al,%eax
801052d2:	50                   	push   %eax
801052d3:	e8 15 ff ff ff       	call   801051ed <uartputc>
  for(p="xv6...\n"; *p; p++)
801052d8:	83 c3 01             	add    $0x1,%ebx
801052db:	0f b6 03             	movzbl (%ebx),%eax
801052de:	83 c4 10             	add    $0x10,%esp
801052e1:	84 c0                	test   %al,%al
801052e3:	75 e7                	jne    801052cc <uartinit+0x85>
}
801052e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052e8:	5b                   	pop    %ebx
801052e9:	5e                   	pop    %esi
801052ea:	5d                   	pop    %ebp
801052eb:	c3                   	ret    

801052ec <uartintr>:

void
uartintr(void)
{
801052ec:	55                   	push   %ebp
801052ed:	89 e5                	mov    %esp,%ebp
801052ef:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801052f2:	68 be 51 10 80       	push   $0x801051be
801052f7:	e8 3f b4 ff ff       	call   8010073b <consoleintr>
}
801052fc:	83 c4 10             	add    $0x10,%esp
801052ff:	c9                   	leave  
80105300:	c3                   	ret    

80105301 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105301:	6a 00                	push   $0x0
  pushl $0
80105303:	6a 00                	push   $0x0
  jmp alltraps
80105305:	e9 e0 fb ff ff       	jmp    80104eea <alltraps>

8010530a <vector1>:
.globl vector1
vector1:
  pushl $0
8010530a:	6a 00                	push   $0x0
  pushl $1
8010530c:	6a 01                	push   $0x1
  jmp alltraps
8010530e:	e9 d7 fb ff ff       	jmp    80104eea <alltraps>

80105313 <vector2>:
.globl vector2
vector2:
  pushl $0
80105313:	6a 00                	push   $0x0
  pushl $2
80105315:	6a 02                	push   $0x2
  jmp alltraps
80105317:	e9 ce fb ff ff       	jmp    80104eea <alltraps>

8010531c <vector3>:
.globl vector3
vector3:
  pushl $0
8010531c:	6a 00                	push   $0x0
  pushl $3
8010531e:	6a 03                	push   $0x3
  jmp alltraps
80105320:	e9 c5 fb ff ff       	jmp    80104eea <alltraps>

80105325 <vector4>:
.globl vector4
vector4:
  pushl $0
80105325:	6a 00                	push   $0x0
  pushl $4
80105327:	6a 04                	push   $0x4
  jmp alltraps
80105329:	e9 bc fb ff ff       	jmp    80104eea <alltraps>

8010532e <vector5>:
.globl vector5
vector5:
  pushl $0
8010532e:	6a 00                	push   $0x0
  pushl $5
80105330:	6a 05                	push   $0x5
  jmp alltraps
80105332:	e9 b3 fb ff ff       	jmp    80104eea <alltraps>

80105337 <vector6>:
.globl vector6
vector6:
  pushl $0
80105337:	6a 00                	push   $0x0
  pushl $6
80105339:	6a 06                	push   $0x6
  jmp alltraps
8010533b:	e9 aa fb ff ff       	jmp    80104eea <alltraps>

80105340 <vector7>:
.globl vector7
vector7:
  pushl $0
80105340:	6a 00                	push   $0x0
  pushl $7
80105342:	6a 07                	push   $0x7
  jmp alltraps
80105344:	e9 a1 fb ff ff       	jmp    80104eea <alltraps>

80105349 <vector8>:
.globl vector8
vector8:
  pushl $8
80105349:	6a 08                	push   $0x8
  jmp alltraps
8010534b:	e9 9a fb ff ff       	jmp    80104eea <alltraps>

80105350 <vector9>:
.globl vector9
vector9:
  pushl $0
80105350:	6a 00                	push   $0x0
  pushl $9
80105352:	6a 09                	push   $0x9
  jmp alltraps
80105354:	e9 91 fb ff ff       	jmp    80104eea <alltraps>

80105359 <vector10>:
.globl vector10
vector10:
  pushl $10
80105359:	6a 0a                	push   $0xa
  jmp alltraps
8010535b:	e9 8a fb ff ff       	jmp    80104eea <alltraps>

80105360 <vector11>:
.globl vector11
vector11:
  pushl $11
80105360:	6a 0b                	push   $0xb
  jmp alltraps
80105362:	e9 83 fb ff ff       	jmp    80104eea <alltraps>

80105367 <vector12>:
.globl vector12
vector12:
  pushl $12
80105367:	6a 0c                	push   $0xc
  jmp alltraps
80105369:	e9 7c fb ff ff       	jmp    80104eea <alltraps>

8010536e <vector13>:
.globl vector13
vector13:
  pushl $13
8010536e:	6a 0d                	push   $0xd
  jmp alltraps
80105370:	e9 75 fb ff ff       	jmp    80104eea <alltraps>

80105375 <vector14>:
.globl vector14
vector14:
  pushl $14
80105375:	6a 0e                	push   $0xe
  jmp alltraps
80105377:	e9 6e fb ff ff       	jmp    80104eea <alltraps>

8010537c <vector15>:
.globl vector15
vector15:
  pushl $0
8010537c:	6a 00                	push   $0x0
  pushl $15
8010537e:	6a 0f                	push   $0xf
  jmp alltraps
80105380:	e9 65 fb ff ff       	jmp    80104eea <alltraps>

80105385 <vector16>:
.globl vector16
vector16:
  pushl $0
80105385:	6a 00                	push   $0x0
  pushl $16
80105387:	6a 10                	push   $0x10
  jmp alltraps
80105389:	e9 5c fb ff ff       	jmp    80104eea <alltraps>

8010538e <vector17>:
.globl vector17
vector17:
  pushl $17
8010538e:	6a 11                	push   $0x11
  jmp alltraps
80105390:	e9 55 fb ff ff       	jmp    80104eea <alltraps>

80105395 <vector18>:
.globl vector18
vector18:
  pushl $0
80105395:	6a 00                	push   $0x0
  pushl $18
80105397:	6a 12                	push   $0x12
  jmp alltraps
80105399:	e9 4c fb ff ff       	jmp    80104eea <alltraps>

8010539e <vector19>:
.globl vector19
vector19:
  pushl $0
8010539e:	6a 00                	push   $0x0
  pushl $19
801053a0:	6a 13                	push   $0x13
  jmp alltraps
801053a2:	e9 43 fb ff ff       	jmp    80104eea <alltraps>

801053a7 <vector20>:
.globl vector20
vector20:
  pushl $0
801053a7:	6a 00                	push   $0x0
  pushl $20
801053a9:	6a 14                	push   $0x14
  jmp alltraps
801053ab:	e9 3a fb ff ff       	jmp    80104eea <alltraps>

801053b0 <vector21>:
.globl vector21
vector21:
  pushl $0
801053b0:	6a 00                	push   $0x0
  pushl $21
801053b2:	6a 15                	push   $0x15
  jmp alltraps
801053b4:	e9 31 fb ff ff       	jmp    80104eea <alltraps>

801053b9 <vector22>:
.globl vector22
vector22:
  pushl $0
801053b9:	6a 00                	push   $0x0
  pushl $22
801053bb:	6a 16                	push   $0x16
  jmp alltraps
801053bd:	e9 28 fb ff ff       	jmp    80104eea <alltraps>

801053c2 <vector23>:
.globl vector23
vector23:
  pushl $0
801053c2:	6a 00                	push   $0x0
  pushl $23
801053c4:	6a 17                	push   $0x17
  jmp alltraps
801053c6:	e9 1f fb ff ff       	jmp    80104eea <alltraps>

801053cb <vector24>:
.globl vector24
vector24:
  pushl $0
801053cb:	6a 00                	push   $0x0
  pushl $24
801053cd:	6a 18                	push   $0x18
  jmp alltraps
801053cf:	e9 16 fb ff ff       	jmp    80104eea <alltraps>

801053d4 <vector25>:
.globl vector25
vector25:
  pushl $0
801053d4:	6a 00                	push   $0x0
  pushl $25
801053d6:	6a 19                	push   $0x19
  jmp alltraps
801053d8:	e9 0d fb ff ff       	jmp    80104eea <alltraps>

801053dd <vector26>:
.globl vector26
vector26:
  pushl $0
801053dd:	6a 00                	push   $0x0
  pushl $26
801053df:	6a 1a                	push   $0x1a
  jmp alltraps
801053e1:	e9 04 fb ff ff       	jmp    80104eea <alltraps>

801053e6 <vector27>:
.globl vector27
vector27:
  pushl $0
801053e6:	6a 00                	push   $0x0
  pushl $27
801053e8:	6a 1b                	push   $0x1b
  jmp alltraps
801053ea:	e9 fb fa ff ff       	jmp    80104eea <alltraps>

801053ef <vector28>:
.globl vector28
vector28:
  pushl $0
801053ef:	6a 00                	push   $0x0
  pushl $28
801053f1:	6a 1c                	push   $0x1c
  jmp alltraps
801053f3:	e9 f2 fa ff ff       	jmp    80104eea <alltraps>

801053f8 <vector29>:
.globl vector29
vector29:
  pushl $0
801053f8:	6a 00                	push   $0x0
  pushl $29
801053fa:	6a 1d                	push   $0x1d
  jmp alltraps
801053fc:	e9 e9 fa ff ff       	jmp    80104eea <alltraps>

80105401 <vector30>:
.globl vector30
vector30:
  pushl $0
80105401:	6a 00                	push   $0x0
  pushl $30
80105403:	6a 1e                	push   $0x1e
  jmp alltraps
80105405:	e9 e0 fa ff ff       	jmp    80104eea <alltraps>

8010540a <vector31>:
.globl vector31
vector31:
  pushl $0
8010540a:	6a 00                	push   $0x0
  pushl $31
8010540c:	6a 1f                	push   $0x1f
  jmp alltraps
8010540e:	e9 d7 fa ff ff       	jmp    80104eea <alltraps>

80105413 <vector32>:
.globl vector32
vector32:
  pushl $0
80105413:	6a 00                	push   $0x0
  pushl $32
80105415:	6a 20                	push   $0x20
  jmp alltraps
80105417:	e9 ce fa ff ff       	jmp    80104eea <alltraps>

8010541c <vector33>:
.globl vector33
vector33:
  pushl $0
8010541c:	6a 00                	push   $0x0
  pushl $33
8010541e:	6a 21                	push   $0x21
  jmp alltraps
80105420:	e9 c5 fa ff ff       	jmp    80104eea <alltraps>

80105425 <vector34>:
.globl vector34
vector34:
  pushl $0
80105425:	6a 00                	push   $0x0
  pushl $34
80105427:	6a 22                	push   $0x22
  jmp alltraps
80105429:	e9 bc fa ff ff       	jmp    80104eea <alltraps>

8010542e <vector35>:
.globl vector35
vector35:
  pushl $0
8010542e:	6a 00                	push   $0x0
  pushl $35
80105430:	6a 23                	push   $0x23
  jmp alltraps
80105432:	e9 b3 fa ff ff       	jmp    80104eea <alltraps>

80105437 <vector36>:
.globl vector36
vector36:
  pushl $0
80105437:	6a 00                	push   $0x0
  pushl $36
80105439:	6a 24                	push   $0x24
  jmp alltraps
8010543b:	e9 aa fa ff ff       	jmp    80104eea <alltraps>

80105440 <vector37>:
.globl vector37
vector37:
  pushl $0
80105440:	6a 00                	push   $0x0
  pushl $37
80105442:	6a 25                	push   $0x25
  jmp alltraps
80105444:	e9 a1 fa ff ff       	jmp    80104eea <alltraps>

80105449 <vector38>:
.globl vector38
vector38:
  pushl $0
80105449:	6a 00                	push   $0x0
  pushl $38
8010544b:	6a 26                	push   $0x26
  jmp alltraps
8010544d:	e9 98 fa ff ff       	jmp    80104eea <alltraps>

80105452 <vector39>:
.globl vector39
vector39:
  pushl $0
80105452:	6a 00                	push   $0x0
  pushl $39
80105454:	6a 27                	push   $0x27
  jmp alltraps
80105456:	e9 8f fa ff ff       	jmp    80104eea <alltraps>

8010545b <vector40>:
.globl vector40
vector40:
  pushl $0
8010545b:	6a 00                	push   $0x0
  pushl $40
8010545d:	6a 28                	push   $0x28
  jmp alltraps
8010545f:	e9 86 fa ff ff       	jmp    80104eea <alltraps>

80105464 <vector41>:
.globl vector41
vector41:
  pushl $0
80105464:	6a 00                	push   $0x0
  pushl $41
80105466:	6a 29                	push   $0x29
  jmp alltraps
80105468:	e9 7d fa ff ff       	jmp    80104eea <alltraps>

8010546d <vector42>:
.globl vector42
vector42:
  pushl $0
8010546d:	6a 00                	push   $0x0
  pushl $42
8010546f:	6a 2a                	push   $0x2a
  jmp alltraps
80105471:	e9 74 fa ff ff       	jmp    80104eea <alltraps>

80105476 <vector43>:
.globl vector43
vector43:
  pushl $0
80105476:	6a 00                	push   $0x0
  pushl $43
80105478:	6a 2b                	push   $0x2b
  jmp alltraps
8010547a:	e9 6b fa ff ff       	jmp    80104eea <alltraps>

8010547f <vector44>:
.globl vector44
vector44:
  pushl $0
8010547f:	6a 00                	push   $0x0
  pushl $44
80105481:	6a 2c                	push   $0x2c
  jmp alltraps
80105483:	e9 62 fa ff ff       	jmp    80104eea <alltraps>

80105488 <vector45>:
.globl vector45
vector45:
  pushl $0
80105488:	6a 00                	push   $0x0
  pushl $45
8010548a:	6a 2d                	push   $0x2d
  jmp alltraps
8010548c:	e9 59 fa ff ff       	jmp    80104eea <alltraps>

80105491 <vector46>:
.globl vector46
vector46:
  pushl $0
80105491:	6a 00                	push   $0x0
  pushl $46
80105493:	6a 2e                	push   $0x2e
  jmp alltraps
80105495:	e9 50 fa ff ff       	jmp    80104eea <alltraps>

8010549a <vector47>:
.globl vector47
vector47:
  pushl $0
8010549a:	6a 00                	push   $0x0
  pushl $47
8010549c:	6a 2f                	push   $0x2f
  jmp alltraps
8010549e:	e9 47 fa ff ff       	jmp    80104eea <alltraps>

801054a3 <vector48>:
.globl vector48
vector48:
  pushl $0
801054a3:	6a 00                	push   $0x0
  pushl $48
801054a5:	6a 30                	push   $0x30
  jmp alltraps
801054a7:	e9 3e fa ff ff       	jmp    80104eea <alltraps>

801054ac <vector49>:
.globl vector49
vector49:
  pushl $0
801054ac:	6a 00                	push   $0x0
  pushl $49
801054ae:	6a 31                	push   $0x31
  jmp alltraps
801054b0:	e9 35 fa ff ff       	jmp    80104eea <alltraps>

801054b5 <vector50>:
.globl vector50
vector50:
  pushl $0
801054b5:	6a 00                	push   $0x0
  pushl $50
801054b7:	6a 32                	push   $0x32
  jmp alltraps
801054b9:	e9 2c fa ff ff       	jmp    80104eea <alltraps>

801054be <vector51>:
.globl vector51
vector51:
  pushl $0
801054be:	6a 00                	push   $0x0
  pushl $51
801054c0:	6a 33                	push   $0x33
  jmp alltraps
801054c2:	e9 23 fa ff ff       	jmp    80104eea <alltraps>

801054c7 <vector52>:
.globl vector52
vector52:
  pushl $0
801054c7:	6a 00                	push   $0x0
  pushl $52
801054c9:	6a 34                	push   $0x34
  jmp alltraps
801054cb:	e9 1a fa ff ff       	jmp    80104eea <alltraps>

801054d0 <vector53>:
.globl vector53
vector53:
  pushl $0
801054d0:	6a 00                	push   $0x0
  pushl $53
801054d2:	6a 35                	push   $0x35
  jmp alltraps
801054d4:	e9 11 fa ff ff       	jmp    80104eea <alltraps>

801054d9 <vector54>:
.globl vector54
vector54:
  pushl $0
801054d9:	6a 00                	push   $0x0
  pushl $54
801054db:	6a 36                	push   $0x36
  jmp alltraps
801054dd:	e9 08 fa ff ff       	jmp    80104eea <alltraps>

801054e2 <vector55>:
.globl vector55
vector55:
  pushl $0
801054e2:	6a 00                	push   $0x0
  pushl $55
801054e4:	6a 37                	push   $0x37
  jmp alltraps
801054e6:	e9 ff f9 ff ff       	jmp    80104eea <alltraps>

801054eb <vector56>:
.globl vector56
vector56:
  pushl $0
801054eb:	6a 00                	push   $0x0
  pushl $56
801054ed:	6a 38                	push   $0x38
  jmp alltraps
801054ef:	e9 f6 f9 ff ff       	jmp    80104eea <alltraps>

801054f4 <vector57>:
.globl vector57
vector57:
  pushl $0
801054f4:	6a 00                	push   $0x0
  pushl $57
801054f6:	6a 39                	push   $0x39
  jmp alltraps
801054f8:	e9 ed f9 ff ff       	jmp    80104eea <alltraps>

801054fd <vector58>:
.globl vector58
vector58:
  pushl $0
801054fd:	6a 00                	push   $0x0
  pushl $58
801054ff:	6a 3a                	push   $0x3a
  jmp alltraps
80105501:	e9 e4 f9 ff ff       	jmp    80104eea <alltraps>

80105506 <vector59>:
.globl vector59
vector59:
  pushl $0
80105506:	6a 00                	push   $0x0
  pushl $59
80105508:	6a 3b                	push   $0x3b
  jmp alltraps
8010550a:	e9 db f9 ff ff       	jmp    80104eea <alltraps>

8010550f <vector60>:
.globl vector60
vector60:
  pushl $0
8010550f:	6a 00                	push   $0x0
  pushl $60
80105511:	6a 3c                	push   $0x3c
  jmp alltraps
80105513:	e9 d2 f9 ff ff       	jmp    80104eea <alltraps>

80105518 <vector61>:
.globl vector61
vector61:
  pushl $0
80105518:	6a 00                	push   $0x0
  pushl $61
8010551a:	6a 3d                	push   $0x3d
  jmp alltraps
8010551c:	e9 c9 f9 ff ff       	jmp    80104eea <alltraps>

80105521 <vector62>:
.globl vector62
vector62:
  pushl $0
80105521:	6a 00                	push   $0x0
  pushl $62
80105523:	6a 3e                	push   $0x3e
  jmp alltraps
80105525:	e9 c0 f9 ff ff       	jmp    80104eea <alltraps>

8010552a <vector63>:
.globl vector63
vector63:
  pushl $0
8010552a:	6a 00                	push   $0x0
  pushl $63
8010552c:	6a 3f                	push   $0x3f
  jmp alltraps
8010552e:	e9 b7 f9 ff ff       	jmp    80104eea <alltraps>

80105533 <vector64>:
.globl vector64
vector64:
  pushl $0
80105533:	6a 00                	push   $0x0
  pushl $64
80105535:	6a 40                	push   $0x40
  jmp alltraps
80105537:	e9 ae f9 ff ff       	jmp    80104eea <alltraps>

8010553c <vector65>:
.globl vector65
vector65:
  pushl $0
8010553c:	6a 00                	push   $0x0
  pushl $65
8010553e:	6a 41                	push   $0x41
  jmp alltraps
80105540:	e9 a5 f9 ff ff       	jmp    80104eea <alltraps>

80105545 <vector66>:
.globl vector66
vector66:
  pushl $0
80105545:	6a 00                	push   $0x0
  pushl $66
80105547:	6a 42                	push   $0x42
  jmp alltraps
80105549:	e9 9c f9 ff ff       	jmp    80104eea <alltraps>

8010554e <vector67>:
.globl vector67
vector67:
  pushl $0
8010554e:	6a 00                	push   $0x0
  pushl $67
80105550:	6a 43                	push   $0x43
  jmp alltraps
80105552:	e9 93 f9 ff ff       	jmp    80104eea <alltraps>

80105557 <vector68>:
.globl vector68
vector68:
  pushl $0
80105557:	6a 00                	push   $0x0
  pushl $68
80105559:	6a 44                	push   $0x44
  jmp alltraps
8010555b:	e9 8a f9 ff ff       	jmp    80104eea <alltraps>

80105560 <vector69>:
.globl vector69
vector69:
  pushl $0
80105560:	6a 00                	push   $0x0
  pushl $69
80105562:	6a 45                	push   $0x45
  jmp alltraps
80105564:	e9 81 f9 ff ff       	jmp    80104eea <alltraps>

80105569 <vector70>:
.globl vector70
vector70:
  pushl $0
80105569:	6a 00                	push   $0x0
  pushl $70
8010556b:	6a 46                	push   $0x46
  jmp alltraps
8010556d:	e9 78 f9 ff ff       	jmp    80104eea <alltraps>

80105572 <vector71>:
.globl vector71
vector71:
  pushl $0
80105572:	6a 00                	push   $0x0
  pushl $71
80105574:	6a 47                	push   $0x47
  jmp alltraps
80105576:	e9 6f f9 ff ff       	jmp    80104eea <alltraps>

8010557b <vector72>:
.globl vector72
vector72:
  pushl $0
8010557b:	6a 00                	push   $0x0
  pushl $72
8010557d:	6a 48                	push   $0x48
  jmp alltraps
8010557f:	e9 66 f9 ff ff       	jmp    80104eea <alltraps>

80105584 <vector73>:
.globl vector73
vector73:
  pushl $0
80105584:	6a 00                	push   $0x0
  pushl $73
80105586:	6a 49                	push   $0x49
  jmp alltraps
80105588:	e9 5d f9 ff ff       	jmp    80104eea <alltraps>

8010558d <vector74>:
.globl vector74
vector74:
  pushl $0
8010558d:	6a 00                	push   $0x0
  pushl $74
8010558f:	6a 4a                	push   $0x4a
  jmp alltraps
80105591:	e9 54 f9 ff ff       	jmp    80104eea <alltraps>

80105596 <vector75>:
.globl vector75
vector75:
  pushl $0
80105596:	6a 00                	push   $0x0
  pushl $75
80105598:	6a 4b                	push   $0x4b
  jmp alltraps
8010559a:	e9 4b f9 ff ff       	jmp    80104eea <alltraps>

8010559f <vector76>:
.globl vector76
vector76:
  pushl $0
8010559f:	6a 00                	push   $0x0
  pushl $76
801055a1:	6a 4c                	push   $0x4c
  jmp alltraps
801055a3:	e9 42 f9 ff ff       	jmp    80104eea <alltraps>

801055a8 <vector77>:
.globl vector77
vector77:
  pushl $0
801055a8:	6a 00                	push   $0x0
  pushl $77
801055aa:	6a 4d                	push   $0x4d
  jmp alltraps
801055ac:	e9 39 f9 ff ff       	jmp    80104eea <alltraps>

801055b1 <vector78>:
.globl vector78
vector78:
  pushl $0
801055b1:	6a 00                	push   $0x0
  pushl $78
801055b3:	6a 4e                	push   $0x4e
  jmp alltraps
801055b5:	e9 30 f9 ff ff       	jmp    80104eea <alltraps>

801055ba <vector79>:
.globl vector79
vector79:
  pushl $0
801055ba:	6a 00                	push   $0x0
  pushl $79
801055bc:	6a 4f                	push   $0x4f
  jmp alltraps
801055be:	e9 27 f9 ff ff       	jmp    80104eea <alltraps>

801055c3 <vector80>:
.globl vector80
vector80:
  pushl $0
801055c3:	6a 00                	push   $0x0
  pushl $80
801055c5:	6a 50                	push   $0x50
  jmp alltraps
801055c7:	e9 1e f9 ff ff       	jmp    80104eea <alltraps>

801055cc <vector81>:
.globl vector81
vector81:
  pushl $0
801055cc:	6a 00                	push   $0x0
  pushl $81
801055ce:	6a 51                	push   $0x51
  jmp alltraps
801055d0:	e9 15 f9 ff ff       	jmp    80104eea <alltraps>

801055d5 <vector82>:
.globl vector82
vector82:
  pushl $0
801055d5:	6a 00                	push   $0x0
  pushl $82
801055d7:	6a 52                	push   $0x52
  jmp alltraps
801055d9:	e9 0c f9 ff ff       	jmp    80104eea <alltraps>

801055de <vector83>:
.globl vector83
vector83:
  pushl $0
801055de:	6a 00                	push   $0x0
  pushl $83
801055e0:	6a 53                	push   $0x53
  jmp alltraps
801055e2:	e9 03 f9 ff ff       	jmp    80104eea <alltraps>

801055e7 <vector84>:
.globl vector84
vector84:
  pushl $0
801055e7:	6a 00                	push   $0x0
  pushl $84
801055e9:	6a 54                	push   $0x54
  jmp alltraps
801055eb:	e9 fa f8 ff ff       	jmp    80104eea <alltraps>

801055f0 <vector85>:
.globl vector85
vector85:
  pushl $0
801055f0:	6a 00                	push   $0x0
  pushl $85
801055f2:	6a 55                	push   $0x55
  jmp alltraps
801055f4:	e9 f1 f8 ff ff       	jmp    80104eea <alltraps>

801055f9 <vector86>:
.globl vector86
vector86:
  pushl $0
801055f9:	6a 00                	push   $0x0
  pushl $86
801055fb:	6a 56                	push   $0x56
  jmp alltraps
801055fd:	e9 e8 f8 ff ff       	jmp    80104eea <alltraps>

80105602 <vector87>:
.globl vector87
vector87:
  pushl $0
80105602:	6a 00                	push   $0x0
  pushl $87
80105604:	6a 57                	push   $0x57
  jmp alltraps
80105606:	e9 df f8 ff ff       	jmp    80104eea <alltraps>

8010560b <vector88>:
.globl vector88
vector88:
  pushl $0
8010560b:	6a 00                	push   $0x0
  pushl $88
8010560d:	6a 58                	push   $0x58
  jmp alltraps
8010560f:	e9 d6 f8 ff ff       	jmp    80104eea <alltraps>

80105614 <vector89>:
.globl vector89
vector89:
  pushl $0
80105614:	6a 00                	push   $0x0
  pushl $89
80105616:	6a 59                	push   $0x59
  jmp alltraps
80105618:	e9 cd f8 ff ff       	jmp    80104eea <alltraps>

8010561d <vector90>:
.globl vector90
vector90:
  pushl $0
8010561d:	6a 00                	push   $0x0
  pushl $90
8010561f:	6a 5a                	push   $0x5a
  jmp alltraps
80105621:	e9 c4 f8 ff ff       	jmp    80104eea <alltraps>

80105626 <vector91>:
.globl vector91
vector91:
  pushl $0
80105626:	6a 00                	push   $0x0
  pushl $91
80105628:	6a 5b                	push   $0x5b
  jmp alltraps
8010562a:	e9 bb f8 ff ff       	jmp    80104eea <alltraps>

8010562f <vector92>:
.globl vector92
vector92:
  pushl $0
8010562f:	6a 00                	push   $0x0
  pushl $92
80105631:	6a 5c                	push   $0x5c
  jmp alltraps
80105633:	e9 b2 f8 ff ff       	jmp    80104eea <alltraps>

80105638 <vector93>:
.globl vector93
vector93:
  pushl $0
80105638:	6a 00                	push   $0x0
  pushl $93
8010563a:	6a 5d                	push   $0x5d
  jmp alltraps
8010563c:	e9 a9 f8 ff ff       	jmp    80104eea <alltraps>

80105641 <vector94>:
.globl vector94
vector94:
  pushl $0
80105641:	6a 00                	push   $0x0
  pushl $94
80105643:	6a 5e                	push   $0x5e
  jmp alltraps
80105645:	e9 a0 f8 ff ff       	jmp    80104eea <alltraps>

8010564a <vector95>:
.globl vector95
vector95:
  pushl $0
8010564a:	6a 00                	push   $0x0
  pushl $95
8010564c:	6a 5f                	push   $0x5f
  jmp alltraps
8010564e:	e9 97 f8 ff ff       	jmp    80104eea <alltraps>

80105653 <vector96>:
.globl vector96
vector96:
  pushl $0
80105653:	6a 00                	push   $0x0
  pushl $96
80105655:	6a 60                	push   $0x60
  jmp alltraps
80105657:	e9 8e f8 ff ff       	jmp    80104eea <alltraps>

8010565c <vector97>:
.globl vector97
vector97:
  pushl $0
8010565c:	6a 00                	push   $0x0
  pushl $97
8010565e:	6a 61                	push   $0x61
  jmp alltraps
80105660:	e9 85 f8 ff ff       	jmp    80104eea <alltraps>

80105665 <vector98>:
.globl vector98
vector98:
  pushl $0
80105665:	6a 00                	push   $0x0
  pushl $98
80105667:	6a 62                	push   $0x62
  jmp alltraps
80105669:	e9 7c f8 ff ff       	jmp    80104eea <alltraps>

8010566e <vector99>:
.globl vector99
vector99:
  pushl $0
8010566e:	6a 00                	push   $0x0
  pushl $99
80105670:	6a 63                	push   $0x63
  jmp alltraps
80105672:	e9 73 f8 ff ff       	jmp    80104eea <alltraps>

80105677 <vector100>:
.globl vector100
vector100:
  pushl $0
80105677:	6a 00                	push   $0x0
  pushl $100
80105679:	6a 64                	push   $0x64
  jmp alltraps
8010567b:	e9 6a f8 ff ff       	jmp    80104eea <alltraps>

80105680 <vector101>:
.globl vector101
vector101:
  pushl $0
80105680:	6a 00                	push   $0x0
  pushl $101
80105682:	6a 65                	push   $0x65
  jmp alltraps
80105684:	e9 61 f8 ff ff       	jmp    80104eea <alltraps>

80105689 <vector102>:
.globl vector102
vector102:
  pushl $0
80105689:	6a 00                	push   $0x0
  pushl $102
8010568b:	6a 66                	push   $0x66
  jmp alltraps
8010568d:	e9 58 f8 ff ff       	jmp    80104eea <alltraps>

80105692 <vector103>:
.globl vector103
vector103:
  pushl $0
80105692:	6a 00                	push   $0x0
  pushl $103
80105694:	6a 67                	push   $0x67
  jmp alltraps
80105696:	e9 4f f8 ff ff       	jmp    80104eea <alltraps>

8010569b <vector104>:
.globl vector104
vector104:
  pushl $0
8010569b:	6a 00                	push   $0x0
  pushl $104
8010569d:	6a 68                	push   $0x68
  jmp alltraps
8010569f:	e9 46 f8 ff ff       	jmp    80104eea <alltraps>

801056a4 <vector105>:
.globl vector105
vector105:
  pushl $0
801056a4:	6a 00                	push   $0x0
  pushl $105
801056a6:	6a 69                	push   $0x69
  jmp alltraps
801056a8:	e9 3d f8 ff ff       	jmp    80104eea <alltraps>

801056ad <vector106>:
.globl vector106
vector106:
  pushl $0
801056ad:	6a 00                	push   $0x0
  pushl $106
801056af:	6a 6a                	push   $0x6a
  jmp alltraps
801056b1:	e9 34 f8 ff ff       	jmp    80104eea <alltraps>

801056b6 <vector107>:
.globl vector107
vector107:
  pushl $0
801056b6:	6a 00                	push   $0x0
  pushl $107
801056b8:	6a 6b                	push   $0x6b
  jmp alltraps
801056ba:	e9 2b f8 ff ff       	jmp    80104eea <alltraps>

801056bf <vector108>:
.globl vector108
vector108:
  pushl $0
801056bf:	6a 00                	push   $0x0
  pushl $108
801056c1:	6a 6c                	push   $0x6c
  jmp alltraps
801056c3:	e9 22 f8 ff ff       	jmp    80104eea <alltraps>

801056c8 <vector109>:
.globl vector109
vector109:
  pushl $0
801056c8:	6a 00                	push   $0x0
  pushl $109
801056ca:	6a 6d                	push   $0x6d
  jmp alltraps
801056cc:	e9 19 f8 ff ff       	jmp    80104eea <alltraps>

801056d1 <vector110>:
.globl vector110
vector110:
  pushl $0
801056d1:	6a 00                	push   $0x0
  pushl $110
801056d3:	6a 6e                	push   $0x6e
  jmp alltraps
801056d5:	e9 10 f8 ff ff       	jmp    80104eea <alltraps>

801056da <vector111>:
.globl vector111
vector111:
  pushl $0
801056da:	6a 00                	push   $0x0
  pushl $111
801056dc:	6a 6f                	push   $0x6f
  jmp alltraps
801056de:	e9 07 f8 ff ff       	jmp    80104eea <alltraps>

801056e3 <vector112>:
.globl vector112
vector112:
  pushl $0
801056e3:	6a 00                	push   $0x0
  pushl $112
801056e5:	6a 70                	push   $0x70
  jmp alltraps
801056e7:	e9 fe f7 ff ff       	jmp    80104eea <alltraps>

801056ec <vector113>:
.globl vector113
vector113:
  pushl $0
801056ec:	6a 00                	push   $0x0
  pushl $113
801056ee:	6a 71                	push   $0x71
  jmp alltraps
801056f0:	e9 f5 f7 ff ff       	jmp    80104eea <alltraps>

801056f5 <vector114>:
.globl vector114
vector114:
  pushl $0
801056f5:	6a 00                	push   $0x0
  pushl $114
801056f7:	6a 72                	push   $0x72
  jmp alltraps
801056f9:	e9 ec f7 ff ff       	jmp    80104eea <alltraps>

801056fe <vector115>:
.globl vector115
vector115:
  pushl $0
801056fe:	6a 00                	push   $0x0
  pushl $115
80105700:	6a 73                	push   $0x73
  jmp alltraps
80105702:	e9 e3 f7 ff ff       	jmp    80104eea <alltraps>

80105707 <vector116>:
.globl vector116
vector116:
  pushl $0
80105707:	6a 00                	push   $0x0
  pushl $116
80105709:	6a 74                	push   $0x74
  jmp alltraps
8010570b:	e9 da f7 ff ff       	jmp    80104eea <alltraps>

80105710 <vector117>:
.globl vector117
vector117:
  pushl $0
80105710:	6a 00                	push   $0x0
  pushl $117
80105712:	6a 75                	push   $0x75
  jmp alltraps
80105714:	e9 d1 f7 ff ff       	jmp    80104eea <alltraps>

80105719 <vector118>:
.globl vector118
vector118:
  pushl $0
80105719:	6a 00                	push   $0x0
  pushl $118
8010571b:	6a 76                	push   $0x76
  jmp alltraps
8010571d:	e9 c8 f7 ff ff       	jmp    80104eea <alltraps>

80105722 <vector119>:
.globl vector119
vector119:
  pushl $0
80105722:	6a 00                	push   $0x0
  pushl $119
80105724:	6a 77                	push   $0x77
  jmp alltraps
80105726:	e9 bf f7 ff ff       	jmp    80104eea <alltraps>

8010572b <vector120>:
.globl vector120
vector120:
  pushl $0
8010572b:	6a 00                	push   $0x0
  pushl $120
8010572d:	6a 78                	push   $0x78
  jmp alltraps
8010572f:	e9 b6 f7 ff ff       	jmp    80104eea <alltraps>

80105734 <vector121>:
.globl vector121
vector121:
  pushl $0
80105734:	6a 00                	push   $0x0
  pushl $121
80105736:	6a 79                	push   $0x79
  jmp alltraps
80105738:	e9 ad f7 ff ff       	jmp    80104eea <alltraps>

8010573d <vector122>:
.globl vector122
vector122:
  pushl $0
8010573d:	6a 00                	push   $0x0
  pushl $122
8010573f:	6a 7a                	push   $0x7a
  jmp alltraps
80105741:	e9 a4 f7 ff ff       	jmp    80104eea <alltraps>

80105746 <vector123>:
.globl vector123
vector123:
  pushl $0
80105746:	6a 00                	push   $0x0
  pushl $123
80105748:	6a 7b                	push   $0x7b
  jmp alltraps
8010574a:	e9 9b f7 ff ff       	jmp    80104eea <alltraps>

8010574f <vector124>:
.globl vector124
vector124:
  pushl $0
8010574f:	6a 00                	push   $0x0
  pushl $124
80105751:	6a 7c                	push   $0x7c
  jmp alltraps
80105753:	e9 92 f7 ff ff       	jmp    80104eea <alltraps>

80105758 <vector125>:
.globl vector125
vector125:
  pushl $0
80105758:	6a 00                	push   $0x0
  pushl $125
8010575a:	6a 7d                	push   $0x7d
  jmp alltraps
8010575c:	e9 89 f7 ff ff       	jmp    80104eea <alltraps>

80105761 <vector126>:
.globl vector126
vector126:
  pushl $0
80105761:	6a 00                	push   $0x0
  pushl $126
80105763:	6a 7e                	push   $0x7e
  jmp alltraps
80105765:	e9 80 f7 ff ff       	jmp    80104eea <alltraps>

8010576a <vector127>:
.globl vector127
vector127:
  pushl $0
8010576a:	6a 00                	push   $0x0
  pushl $127
8010576c:	6a 7f                	push   $0x7f
  jmp alltraps
8010576e:	e9 77 f7 ff ff       	jmp    80104eea <alltraps>

80105773 <vector128>:
.globl vector128
vector128:
  pushl $0
80105773:	6a 00                	push   $0x0
  pushl $128
80105775:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010577a:	e9 6b f7 ff ff       	jmp    80104eea <alltraps>

8010577f <vector129>:
.globl vector129
vector129:
  pushl $0
8010577f:	6a 00                	push   $0x0
  pushl $129
80105781:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105786:	e9 5f f7 ff ff       	jmp    80104eea <alltraps>

8010578b <vector130>:
.globl vector130
vector130:
  pushl $0
8010578b:	6a 00                	push   $0x0
  pushl $130
8010578d:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105792:	e9 53 f7 ff ff       	jmp    80104eea <alltraps>

80105797 <vector131>:
.globl vector131
vector131:
  pushl $0
80105797:	6a 00                	push   $0x0
  pushl $131
80105799:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010579e:	e9 47 f7 ff ff       	jmp    80104eea <alltraps>

801057a3 <vector132>:
.globl vector132
vector132:
  pushl $0
801057a3:	6a 00                	push   $0x0
  pushl $132
801057a5:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801057aa:	e9 3b f7 ff ff       	jmp    80104eea <alltraps>

801057af <vector133>:
.globl vector133
vector133:
  pushl $0
801057af:	6a 00                	push   $0x0
  pushl $133
801057b1:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801057b6:	e9 2f f7 ff ff       	jmp    80104eea <alltraps>

801057bb <vector134>:
.globl vector134
vector134:
  pushl $0
801057bb:	6a 00                	push   $0x0
  pushl $134
801057bd:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801057c2:	e9 23 f7 ff ff       	jmp    80104eea <alltraps>

801057c7 <vector135>:
.globl vector135
vector135:
  pushl $0
801057c7:	6a 00                	push   $0x0
  pushl $135
801057c9:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801057ce:	e9 17 f7 ff ff       	jmp    80104eea <alltraps>

801057d3 <vector136>:
.globl vector136
vector136:
  pushl $0
801057d3:	6a 00                	push   $0x0
  pushl $136
801057d5:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801057da:	e9 0b f7 ff ff       	jmp    80104eea <alltraps>

801057df <vector137>:
.globl vector137
vector137:
  pushl $0
801057df:	6a 00                	push   $0x0
  pushl $137
801057e1:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801057e6:	e9 ff f6 ff ff       	jmp    80104eea <alltraps>

801057eb <vector138>:
.globl vector138
vector138:
  pushl $0
801057eb:	6a 00                	push   $0x0
  pushl $138
801057ed:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801057f2:	e9 f3 f6 ff ff       	jmp    80104eea <alltraps>

801057f7 <vector139>:
.globl vector139
vector139:
  pushl $0
801057f7:	6a 00                	push   $0x0
  pushl $139
801057f9:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801057fe:	e9 e7 f6 ff ff       	jmp    80104eea <alltraps>

80105803 <vector140>:
.globl vector140
vector140:
  pushl $0
80105803:	6a 00                	push   $0x0
  pushl $140
80105805:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010580a:	e9 db f6 ff ff       	jmp    80104eea <alltraps>

8010580f <vector141>:
.globl vector141
vector141:
  pushl $0
8010580f:	6a 00                	push   $0x0
  pushl $141
80105811:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105816:	e9 cf f6 ff ff       	jmp    80104eea <alltraps>

8010581b <vector142>:
.globl vector142
vector142:
  pushl $0
8010581b:	6a 00                	push   $0x0
  pushl $142
8010581d:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105822:	e9 c3 f6 ff ff       	jmp    80104eea <alltraps>

80105827 <vector143>:
.globl vector143
vector143:
  pushl $0
80105827:	6a 00                	push   $0x0
  pushl $143
80105829:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010582e:	e9 b7 f6 ff ff       	jmp    80104eea <alltraps>

80105833 <vector144>:
.globl vector144
vector144:
  pushl $0
80105833:	6a 00                	push   $0x0
  pushl $144
80105835:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010583a:	e9 ab f6 ff ff       	jmp    80104eea <alltraps>

8010583f <vector145>:
.globl vector145
vector145:
  pushl $0
8010583f:	6a 00                	push   $0x0
  pushl $145
80105841:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105846:	e9 9f f6 ff ff       	jmp    80104eea <alltraps>

8010584b <vector146>:
.globl vector146
vector146:
  pushl $0
8010584b:	6a 00                	push   $0x0
  pushl $146
8010584d:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105852:	e9 93 f6 ff ff       	jmp    80104eea <alltraps>

80105857 <vector147>:
.globl vector147
vector147:
  pushl $0
80105857:	6a 00                	push   $0x0
  pushl $147
80105859:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010585e:	e9 87 f6 ff ff       	jmp    80104eea <alltraps>

80105863 <vector148>:
.globl vector148
vector148:
  pushl $0
80105863:	6a 00                	push   $0x0
  pushl $148
80105865:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010586a:	e9 7b f6 ff ff       	jmp    80104eea <alltraps>

8010586f <vector149>:
.globl vector149
vector149:
  pushl $0
8010586f:	6a 00                	push   $0x0
  pushl $149
80105871:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105876:	e9 6f f6 ff ff       	jmp    80104eea <alltraps>

8010587b <vector150>:
.globl vector150
vector150:
  pushl $0
8010587b:	6a 00                	push   $0x0
  pushl $150
8010587d:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105882:	e9 63 f6 ff ff       	jmp    80104eea <alltraps>

80105887 <vector151>:
.globl vector151
vector151:
  pushl $0
80105887:	6a 00                	push   $0x0
  pushl $151
80105889:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010588e:	e9 57 f6 ff ff       	jmp    80104eea <alltraps>

80105893 <vector152>:
.globl vector152
vector152:
  pushl $0
80105893:	6a 00                	push   $0x0
  pushl $152
80105895:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010589a:	e9 4b f6 ff ff       	jmp    80104eea <alltraps>

8010589f <vector153>:
.globl vector153
vector153:
  pushl $0
8010589f:	6a 00                	push   $0x0
  pushl $153
801058a1:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801058a6:	e9 3f f6 ff ff       	jmp    80104eea <alltraps>

801058ab <vector154>:
.globl vector154
vector154:
  pushl $0
801058ab:	6a 00                	push   $0x0
  pushl $154
801058ad:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801058b2:	e9 33 f6 ff ff       	jmp    80104eea <alltraps>

801058b7 <vector155>:
.globl vector155
vector155:
  pushl $0
801058b7:	6a 00                	push   $0x0
  pushl $155
801058b9:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801058be:	e9 27 f6 ff ff       	jmp    80104eea <alltraps>

801058c3 <vector156>:
.globl vector156
vector156:
  pushl $0
801058c3:	6a 00                	push   $0x0
  pushl $156
801058c5:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801058ca:	e9 1b f6 ff ff       	jmp    80104eea <alltraps>

801058cf <vector157>:
.globl vector157
vector157:
  pushl $0
801058cf:	6a 00                	push   $0x0
  pushl $157
801058d1:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801058d6:	e9 0f f6 ff ff       	jmp    80104eea <alltraps>

801058db <vector158>:
.globl vector158
vector158:
  pushl $0
801058db:	6a 00                	push   $0x0
  pushl $158
801058dd:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801058e2:	e9 03 f6 ff ff       	jmp    80104eea <alltraps>

801058e7 <vector159>:
.globl vector159
vector159:
  pushl $0
801058e7:	6a 00                	push   $0x0
  pushl $159
801058e9:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801058ee:	e9 f7 f5 ff ff       	jmp    80104eea <alltraps>

801058f3 <vector160>:
.globl vector160
vector160:
  pushl $0
801058f3:	6a 00                	push   $0x0
  pushl $160
801058f5:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801058fa:	e9 eb f5 ff ff       	jmp    80104eea <alltraps>

801058ff <vector161>:
.globl vector161
vector161:
  pushl $0
801058ff:	6a 00                	push   $0x0
  pushl $161
80105901:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105906:	e9 df f5 ff ff       	jmp    80104eea <alltraps>

8010590b <vector162>:
.globl vector162
vector162:
  pushl $0
8010590b:	6a 00                	push   $0x0
  pushl $162
8010590d:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105912:	e9 d3 f5 ff ff       	jmp    80104eea <alltraps>

80105917 <vector163>:
.globl vector163
vector163:
  pushl $0
80105917:	6a 00                	push   $0x0
  pushl $163
80105919:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010591e:	e9 c7 f5 ff ff       	jmp    80104eea <alltraps>

80105923 <vector164>:
.globl vector164
vector164:
  pushl $0
80105923:	6a 00                	push   $0x0
  pushl $164
80105925:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010592a:	e9 bb f5 ff ff       	jmp    80104eea <alltraps>

8010592f <vector165>:
.globl vector165
vector165:
  pushl $0
8010592f:	6a 00                	push   $0x0
  pushl $165
80105931:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105936:	e9 af f5 ff ff       	jmp    80104eea <alltraps>

8010593b <vector166>:
.globl vector166
vector166:
  pushl $0
8010593b:	6a 00                	push   $0x0
  pushl $166
8010593d:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105942:	e9 a3 f5 ff ff       	jmp    80104eea <alltraps>

80105947 <vector167>:
.globl vector167
vector167:
  pushl $0
80105947:	6a 00                	push   $0x0
  pushl $167
80105949:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010594e:	e9 97 f5 ff ff       	jmp    80104eea <alltraps>

80105953 <vector168>:
.globl vector168
vector168:
  pushl $0
80105953:	6a 00                	push   $0x0
  pushl $168
80105955:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010595a:	e9 8b f5 ff ff       	jmp    80104eea <alltraps>

8010595f <vector169>:
.globl vector169
vector169:
  pushl $0
8010595f:	6a 00                	push   $0x0
  pushl $169
80105961:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105966:	e9 7f f5 ff ff       	jmp    80104eea <alltraps>

8010596b <vector170>:
.globl vector170
vector170:
  pushl $0
8010596b:	6a 00                	push   $0x0
  pushl $170
8010596d:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105972:	e9 73 f5 ff ff       	jmp    80104eea <alltraps>

80105977 <vector171>:
.globl vector171
vector171:
  pushl $0
80105977:	6a 00                	push   $0x0
  pushl $171
80105979:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010597e:	e9 67 f5 ff ff       	jmp    80104eea <alltraps>

80105983 <vector172>:
.globl vector172
vector172:
  pushl $0
80105983:	6a 00                	push   $0x0
  pushl $172
80105985:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010598a:	e9 5b f5 ff ff       	jmp    80104eea <alltraps>

8010598f <vector173>:
.globl vector173
vector173:
  pushl $0
8010598f:	6a 00                	push   $0x0
  pushl $173
80105991:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105996:	e9 4f f5 ff ff       	jmp    80104eea <alltraps>

8010599b <vector174>:
.globl vector174
vector174:
  pushl $0
8010599b:	6a 00                	push   $0x0
  pushl $174
8010599d:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801059a2:	e9 43 f5 ff ff       	jmp    80104eea <alltraps>

801059a7 <vector175>:
.globl vector175
vector175:
  pushl $0
801059a7:	6a 00                	push   $0x0
  pushl $175
801059a9:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801059ae:	e9 37 f5 ff ff       	jmp    80104eea <alltraps>

801059b3 <vector176>:
.globl vector176
vector176:
  pushl $0
801059b3:	6a 00                	push   $0x0
  pushl $176
801059b5:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801059ba:	e9 2b f5 ff ff       	jmp    80104eea <alltraps>

801059bf <vector177>:
.globl vector177
vector177:
  pushl $0
801059bf:	6a 00                	push   $0x0
  pushl $177
801059c1:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801059c6:	e9 1f f5 ff ff       	jmp    80104eea <alltraps>

801059cb <vector178>:
.globl vector178
vector178:
  pushl $0
801059cb:	6a 00                	push   $0x0
  pushl $178
801059cd:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801059d2:	e9 13 f5 ff ff       	jmp    80104eea <alltraps>

801059d7 <vector179>:
.globl vector179
vector179:
  pushl $0
801059d7:	6a 00                	push   $0x0
  pushl $179
801059d9:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801059de:	e9 07 f5 ff ff       	jmp    80104eea <alltraps>

801059e3 <vector180>:
.globl vector180
vector180:
  pushl $0
801059e3:	6a 00                	push   $0x0
  pushl $180
801059e5:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801059ea:	e9 fb f4 ff ff       	jmp    80104eea <alltraps>

801059ef <vector181>:
.globl vector181
vector181:
  pushl $0
801059ef:	6a 00                	push   $0x0
  pushl $181
801059f1:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801059f6:	e9 ef f4 ff ff       	jmp    80104eea <alltraps>

801059fb <vector182>:
.globl vector182
vector182:
  pushl $0
801059fb:	6a 00                	push   $0x0
  pushl $182
801059fd:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105a02:	e9 e3 f4 ff ff       	jmp    80104eea <alltraps>

80105a07 <vector183>:
.globl vector183
vector183:
  pushl $0
80105a07:	6a 00                	push   $0x0
  pushl $183
80105a09:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105a0e:	e9 d7 f4 ff ff       	jmp    80104eea <alltraps>

80105a13 <vector184>:
.globl vector184
vector184:
  pushl $0
80105a13:	6a 00                	push   $0x0
  pushl $184
80105a15:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105a1a:	e9 cb f4 ff ff       	jmp    80104eea <alltraps>

80105a1f <vector185>:
.globl vector185
vector185:
  pushl $0
80105a1f:	6a 00                	push   $0x0
  pushl $185
80105a21:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105a26:	e9 bf f4 ff ff       	jmp    80104eea <alltraps>

80105a2b <vector186>:
.globl vector186
vector186:
  pushl $0
80105a2b:	6a 00                	push   $0x0
  pushl $186
80105a2d:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105a32:	e9 b3 f4 ff ff       	jmp    80104eea <alltraps>

80105a37 <vector187>:
.globl vector187
vector187:
  pushl $0
80105a37:	6a 00                	push   $0x0
  pushl $187
80105a39:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105a3e:	e9 a7 f4 ff ff       	jmp    80104eea <alltraps>

80105a43 <vector188>:
.globl vector188
vector188:
  pushl $0
80105a43:	6a 00                	push   $0x0
  pushl $188
80105a45:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105a4a:	e9 9b f4 ff ff       	jmp    80104eea <alltraps>

80105a4f <vector189>:
.globl vector189
vector189:
  pushl $0
80105a4f:	6a 00                	push   $0x0
  pushl $189
80105a51:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105a56:	e9 8f f4 ff ff       	jmp    80104eea <alltraps>

80105a5b <vector190>:
.globl vector190
vector190:
  pushl $0
80105a5b:	6a 00                	push   $0x0
  pushl $190
80105a5d:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105a62:	e9 83 f4 ff ff       	jmp    80104eea <alltraps>

80105a67 <vector191>:
.globl vector191
vector191:
  pushl $0
80105a67:	6a 00                	push   $0x0
  pushl $191
80105a69:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105a6e:	e9 77 f4 ff ff       	jmp    80104eea <alltraps>

80105a73 <vector192>:
.globl vector192
vector192:
  pushl $0
80105a73:	6a 00                	push   $0x0
  pushl $192
80105a75:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105a7a:	e9 6b f4 ff ff       	jmp    80104eea <alltraps>

80105a7f <vector193>:
.globl vector193
vector193:
  pushl $0
80105a7f:	6a 00                	push   $0x0
  pushl $193
80105a81:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105a86:	e9 5f f4 ff ff       	jmp    80104eea <alltraps>

80105a8b <vector194>:
.globl vector194
vector194:
  pushl $0
80105a8b:	6a 00                	push   $0x0
  pushl $194
80105a8d:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105a92:	e9 53 f4 ff ff       	jmp    80104eea <alltraps>

80105a97 <vector195>:
.globl vector195
vector195:
  pushl $0
80105a97:	6a 00                	push   $0x0
  pushl $195
80105a99:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105a9e:	e9 47 f4 ff ff       	jmp    80104eea <alltraps>

80105aa3 <vector196>:
.globl vector196
vector196:
  pushl $0
80105aa3:	6a 00                	push   $0x0
  pushl $196
80105aa5:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105aaa:	e9 3b f4 ff ff       	jmp    80104eea <alltraps>

80105aaf <vector197>:
.globl vector197
vector197:
  pushl $0
80105aaf:	6a 00                	push   $0x0
  pushl $197
80105ab1:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105ab6:	e9 2f f4 ff ff       	jmp    80104eea <alltraps>

80105abb <vector198>:
.globl vector198
vector198:
  pushl $0
80105abb:	6a 00                	push   $0x0
  pushl $198
80105abd:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105ac2:	e9 23 f4 ff ff       	jmp    80104eea <alltraps>

80105ac7 <vector199>:
.globl vector199
vector199:
  pushl $0
80105ac7:	6a 00                	push   $0x0
  pushl $199
80105ac9:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105ace:	e9 17 f4 ff ff       	jmp    80104eea <alltraps>

80105ad3 <vector200>:
.globl vector200
vector200:
  pushl $0
80105ad3:	6a 00                	push   $0x0
  pushl $200
80105ad5:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105ada:	e9 0b f4 ff ff       	jmp    80104eea <alltraps>

80105adf <vector201>:
.globl vector201
vector201:
  pushl $0
80105adf:	6a 00                	push   $0x0
  pushl $201
80105ae1:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105ae6:	e9 ff f3 ff ff       	jmp    80104eea <alltraps>

80105aeb <vector202>:
.globl vector202
vector202:
  pushl $0
80105aeb:	6a 00                	push   $0x0
  pushl $202
80105aed:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105af2:	e9 f3 f3 ff ff       	jmp    80104eea <alltraps>

80105af7 <vector203>:
.globl vector203
vector203:
  pushl $0
80105af7:	6a 00                	push   $0x0
  pushl $203
80105af9:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105afe:	e9 e7 f3 ff ff       	jmp    80104eea <alltraps>

80105b03 <vector204>:
.globl vector204
vector204:
  pushl $0
80105b03:	6a 00                	push   $0x0
  pushl $204
80105b05:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105b0a:	e9 db f3 ff ff       	jmp    80104eea <alltraps>

80105b0f <vector205>:
.globl vector205
vector205:
  pushl $0
80105b0f:	6a 00                	push   $0x0
  pushl $205
80105b11:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105b16:	e9 cf f3 ff ff       	jmp    80104eea <alltraps>

80105b1b <vector206>:
.globl vector206
vector206:
  pushl $0
80105b1b:	6a 00                	push   $0x0
  pushl $206
80105b1d:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105b22:	e9 c3 f3 ff ff       	jmp    80104eea <alltraps>

80105b27 <vector207>:
.globl vector207
vector207:
  pushl $0
80105b27:	6a 00                	push   $0x0
  pushl $207
80105b29:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105b2e:	e9 b7 f3 ff ff       	jmp    80104eea <alltraps>

80105b33 <vector208>:
.globl vector208
vector208:
  pushl $0
80105b33:	6a 00                	push   $0x0
  pushl $208
80105b35:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105b3a:	e9 ab f3 ff ff       	jmp    80104eea <alltraps>

80105b3f <vector209>:
.globl vector209
vector209:
  pushl $0
80105b3f:	6a 00                	push   $0x0
  pushl $209
80105b41:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105b46:	e9 9f f3 ff ff       	jmp    80104eea <alltraps>

80105b4b <vector210>:
.globl vector210
vector210:
  pushl $0
80105b4b:	6a 00                	push   $0x0
  pushl $210
80105b4d:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105b52:	e9 93 f3 ff ff       	jmp    80104eea <alltraps>

80105b57 <vector211>:
.globl vector211
vector211:
  pushl $0
80105b57:	6a 00                	push   $0x0
  pushl $211
80105b59:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105b5e:	e9 87 f3 ff ff       	jmp    80104eea <alltraps>

80105b63 <vector212>:
.globl vector212
vector212:
  pushl $0
80105b63:	6a 00                	push   $0x0
  pushl $212
80105b65:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105b6a:	e9 7b f3 ff ff       	jmp    80104eea <alltraps>

80105b6f <vector213>:
.globl vector213
vector213:
  pushl $0
80105b6f:	6a 00                	push   $0x0
  pushl $213
80105b71:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105b76:	e9 6f f3 ff ff       	jmp    80104eea <alltraps>

80105b7b <vector214>:
.globl vector214
vector214:
  pushl $0
80105b7b:	6a 00                	push   $0x0
  pushl $214
80105b7d:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105b82:	e9 63 f3 ff ff       	jmp    80104eea <alltraps>

80105b87 <vector215>:
.globl vector215
vector215:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $215
80105b89:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105b8e:	e9 57 f3 ff ff       	jmp    80104eea <alltraps>

80105b93 <vector216>:
.globl vector216
vector216:
  pushl $0
80105b93:	6a 00                	push   $0x0
  pushl $216
80105b95:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105b9a:	e9 4b f3 ff ff       	jmp    80104eea <alltraps>

80105b9f <vector217>:
.globl vector217
vector217:
  pushl $0
80105b9f:	6a 00                	push   $0x0
  pushl $217
80105ba1:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105ba6:	e9 3f f3 ff ff       	jmp    80104eea <alltraps>

80105bab <vector218>:
.globl vector218
vector218:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $218
80105bad:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105bb2:	e9 33 f3 ff ff       	jmp    80104eea <alltraps>

80105bb7 <vector219>:
.globl vector219
vector219:
  pushl $0
80105bb7:	6a 00                	push   $0x0
  pushl $219
80105bb9:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105bbe:	e9 27 f3 ff ff       	jmp    80104eea <alltraps>

80105bc3 <vector220>:
.globl vector220
vector220:
  pushl $0
80105bc3:	6a 00                	push   $0x0
  pushl $220
80105bc5:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105bca:	e9 1b f3 ff ff       	jmp    80104eea <alltraps>

80105bcf <vector221>:
.globl vector221
vector221:
  pushl $0
80105bcf:	6a 00                	push   $0x0
  pushl $221
80105bd1:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105bd6:	e9 0f f3 ff ff       	jmp    80104eea <alltraps>

80105bdb <vector222>:
.globl vector222
vector222:
  pushl $0
80105bdb:	6a 00                	push   $0x0
  pushl $222
80105bdd:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105be2:	e9 03 f3 ff ff       	jmp    80104eea <alltraps>

80105be7 <vector223>:
.globl vector223
vector223:
  pushl $0
80105be7:	6a 00                	push   $0x0
  pushl $223
80105be9:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105bee:	e9 f7 f2 ff ff       	jmp    80104eea <alltraps>

80105bf3 <vector224>:
.globl vector224
vector224:
  pushl $0
80105bf3:	6a 00                	push   $0x0
  pushl $224
80105bf5:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105bfa:	e9 eb f2 ff ff       	jmp    80104eea <alltraps>

80105bff <vector225>:
.globl vector225
vector225:
  pushl $0
80105bff:	6a 00                	push   $0x0
  pushl $225
80105c01:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105c06:	e9 df f2 ff ff       	jmp    80104eea <alltraps>

80105c0b <vector226>:
.globl vector226
vector226:
  pushl $0
80105c0b:	6a 00                	push   $0x0
  pushl $226
80105c0d:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105c12:	e9 d3 f2 ff ff       	jmp    80104eea <alltraps>

80105c17 <vector227>:
.globl vector227
vector227:
  pushl $0
80105c17:	6a 00                	push   $0x0
  pushl $227
80105c19:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105c1e:	e9 c7 f2 ff ff       	jmp    80104eea <alltraps>

80105c23 <vector228>:
.globl vector228
vector228:
  pushl $0
80105c23:	6a 00                	push   $0x0
  pushl $228
80105c25:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105c2a:	e9 bb f2 ff ff       	jmp    80104eea <alltraps>

80105c2f <vector229>:
.globl vector229
vector229:
  pushl $0
80105c2f:	6a 00                	push   $0x0
  pushl $229
80105c31:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105c36:	e9 af f2 ff ff       	jmp    80104eea <alltraps>

80105c3b <vector230>:
.globl vector230
vector230:
  pushl $0
80105c3b:	6a 00                	push   $0x0
  pushl $230
80105c3d:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105c42:	e9 a3 f2 ff ff       	jmp    80104eea <alltraps>

80105c47 <vector231>:
.globl vector231
vector231:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $231
80105c49:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105c4e:	e9 97 f2 ff ff       	jmp    80104eea <alltraps>

80105c53 <vector232>:
.globl vector232
vector232:
  pushl $0
80105c53:	6a 00                	push   $0x0
  pushl $232
80105c55:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105c5a:	e9 8b f2 ff ff       	jmp    80104eea <alltraps>

80105c5f <vector233>:
.globl vector233
vector233:
  pushl $0
80105c5f:	6a 00                	push   $0x0
  pushl $233
80105c61:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105c66:	e9 7f f2 ff ff       	jmp    80104eea <alltraps>

80105c6b <vector234>:
.globl vector234
vector234:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $234
80105c6d:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105c72:	e9 73 f2 ff ff       	jmp    80104eea <alltraps>

80105c77 <vector235>:
.globl vector235
vector235:
  pushl $0
80105c77:	6a 00                	push   $0x0
  pushl $235
80105c79:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105c7e:	e9 67 f2 ff ff       	jmp    80104eea <alltraps>

80105c83 <vector236>:
.globl vector236
vector236:
  pushl $0
80105c83:	6a 00                	push   $0x0
  pushl $236
80105c85:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105c8a:	e9 5b f2 ff ff       	jmp    80104eea <alltraps>

80105c8f <vector237>:
.globl vector237
vector237:
  pushl $0
80105c8f:	6a 00                	push   $0x0
  pushl $237
80105c91:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105c96:	e9 4f f2 ff ff       	jmp    80104eea <alltraps>

80105c9b <vector238>:
.globl vector238
vector238:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $238
80105c9d:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105ca2:	e9 43 f2 ff ff       	jmp    80104eea <alltraps>

80105ca7 <vector239>:
.globl vector239
vector239:
  pushl $0
80105ca7:	6a 00                	push   $0x0
  pushl $239
80105ca9:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105cae:	e9 37 f2 ff ff       	jmp    80104eea <alltraps>

80105cb3 <vector240>:
.globl vector240
vector240:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $240
80105cb5:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105cba:	e9 2b f2 ff ff       	jmp    80104eea <alltraps>

80105cbf <vector241>:
.globl vector241
vector241:
  pushl $0
80105cbf:	6a 00                	push   $0x0
  pushl $241
80105cc1:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105cc6:	e9 1f f2 ff ff       	jmp    80104eea <alltraps>

80105ccb <vector242>:
.globl vector242
vector242:
  pushl $0
80105ccb:	6a 00                	push   $0x0
  pushl $242
80105ccd:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105cd2:	e9 13 f2 ff ff       	jmp    80104eea <alltraps>

80105cd7 <vector243>:
.globl vector243
vector243:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $243
80105cd9:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105cde:	e9 07 f2 ff ff       	jmp    80104eea <alltraps>

80105ce3 <vector244>:
.globl vector244
vector244:
  pushl $0
80105ce3:	6a 00                	push   $0x0
  pushl $244
80105ce5:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105cea:	e9 fb f1 ff ff       	jmp    80104eea <alltraps>

80105cef <vector245>:
.globl vector245
vector245:
  pushl $0
80105cef:	6a 00                	push   $0x0
  pushl $245
80105cf1:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105cf6:	e9 ef f1 ff ff       	jmp    80104eea <alltraps>

80105cfb <vector246>:
.globl vector246
vector246:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $246
80105cfd:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105d02:	e9 e3 f1 ff ff       	jmp    80104eea <alltraps>

80105d07 <vector247>:
.globl vector247
vector247:
  pushl $0
80105d07:	6a 00                	push   $0x0
  pushl $247
80105d09:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105d0e:	e9 d7 f1 ff ff       	jmp    80104eea <alltraps>

80105d13 <vector248>:
.globl vector248
vector248:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $248
80105d15:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105d1a:	e9 cb f1 ff ff       	jmp    80104eea <alltraps>

80105d1f <vector249>:
.globl vector249
vector249:
  pushl $0
80105d1f:	6a 00                	push   $0x0
  pushl $249
80105d21:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105d26:	e9 bf f1 ff ff       	jmp    80104eea <alltraps>

80105d2b <vector250>:
.globl vector250
vector250:
  pushl $0
80105d2b:	6a 00                	push   $0x0
  pushl $250
80105d2d:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105d32:	e9 b3 f1 ff ff       	jmp    80104eea <alltraps>

80105d37 <vector251>:
.globl vector251
vector251:
  pushl $0
80105d37:	6a 00                	push   $0x0
  pushl $251
80105d39:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105d3e:	e9 a7 f1 ff ff       	jmp    80104eea <alltraps>

80105d43 <vector252>:
.globl vector252
vector252:
  pushl $0
80105d43:	6a 00                	push   $0x0
  pushl $252
80105d45:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105d4a:	e9 9b f1 ff ff       	jmp    80104eea <alltraps>

80105d4f <vector253>:
.globl vector253
vector253:
  pushl $0
80105d4f:	6a 00                	push   $0x0
  pushl $253
80105d51:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105d56:	e9 8f f1 ff ff       	jmp    80104eea <alltraps>

80105d5b <vector254>:
.globl vector254
vector254:
  pushl $0
80105d5b:	6a 00                	push   $0x0
  pushl $254
80105d5d:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105d62:	e9 83 f1 ff ff       	jmp    80104eea <alltraps>

80105d67 <vector255>:
.globl vector255
vector255:
  pushl $0
80105d67:	6a 00                	push   $0x0
  pushl $255
80105d69:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105d6e:	e9 77 f1 ff ff       	jmp    80104eea <alltraps>

80105d73 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105d73:	55                   	push   %ebp
80105d74:	89 e5                	mov    %esp,%ebp
80105d76:	57                   	push   %edi
80105d77:	56                   	push   %esi
80105d78:	53                   	push   %ebx
80105d79:	83 ec 0c             	sub    $0xc,%esp
80105d7c:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105d7e:	c1 ea 16             	shr    $0x16,%edx
80105d81:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105d84:	8b 1f                	mov    (%edi),%ebx
80105d86:	f6 c3 01             	test   $0x1,%bl
80105d89:	74 21                	je     80105dac <walkpgdir+0x39>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105d8b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105d91:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105d97:	c1 ee 0a             	shr    $0xa,%esi
80105d9a:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80105da0:	01 f3                	add    %esi,%ebx
}
80105da2:	89 d8                	mov    %ebx,%eax
80105da4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da7:	5b                   	pop    %ebx
80105da8:	5e                   	pop    %esi
80105da9:	5f                   	pop    %edi
80105daa:	5d                   	pop    %ebp
80105dab:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105dac:	85 c9                	test   %ecx,%ecx
80105dae:	74 2b                	je     80105ddb <walkpgdir+0x68>
80105db0:	e8 ab c3 ff ff       	call   80102160 <kalloc>
80105db5:	89 c3                	mov    %eax,%ebx
80105db7:	85 c0                	test   %eax,%eax
80105db9:	74 e7                	je     80105da2 <walkpgdir+0x2f>
    memset(pgtab, 0, PGSIZE);
80105dbb:	83 ec 04             	sub    $0x4,%esp
80105dbe:	68 00 10 00 00       	push   $0x1000
80105dc3:	6a 00                	push   $0x0
80105dc5:	50                   	push   %eax
80105dc6:	e8 95 e0 ff ff       	call   80103e60 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105dcb:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105dd1:	83 c8 07             	or     $0x7,%eax
80105dd4:	89 07                	mov    %eax,(%edi)
80105dd6:	83 c4 10             	add    $0x10,%esp
80105dd9:	eb bc                	jmp    80105d97 <walkpgdir+0x24>
      return 0;
80105ddb:	bb 00 00 00 00       	mov    $0x0,%ebx
80105de0:	eb c0                	jmp    80105da2 <walkpgdir+0x2f>

80105de2 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105de2:	55                   	push   %ebp
80105de3:	89 e5                	mov    %esp,%ebp
80105de5:	57                   	push   %edi
80105de6:	56                   	push   %esi
80105de7:	53                   	push   %ebx
80105de8:	83 ec 1c             	sub    $0x1c,%esp
80105deb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105dee:	89 d0                	mov    %edx,%eax
80105df0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105df5:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105df7:	8d 54 0a ff          	lea    -0x1(%edx,%ecx,1),%edx
80105dfb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80105e01:	89 55 e0             	mov    %edx,-0x20(%ebp)
80105e04:	8b 7d 08             	mov    0x8(%ebp),%edi
80105e07:	29 c7                	sub    %eax,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80105e09:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e0c:	83 c8 01             	or     $0x1,%eax
80105e0f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e12:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105e15:	b9 01 00 00 00       	mov    $0x1,%ecx
80105e1a:	89 da                	mov    %ebx,%edx
80105e1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e1f:	e8 4f ff ff ff       	call   80105d73 <walkpgdir>
80105e24:	85 c0                	test   %eax,%eax
80105e26:	74 24                	je     80105e4c <mappages+0x6a>
    if(*pte & PTE_P)
80105e28:	f6 00 01             	testb  $0x1,(%eax)
80105e2b:	75 12                	jne    80105e3f <mappages+0x5d>
    *pte = pa | perm | PTE_P;
80105e2d:	0b 75 dc             	or     -0x24(%ebp),%esi
80105e30:	89 30                	mov    %esi,(%eax)
    if(a == last)
80105e32:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
80105e35:	74 22                	je     80105e59 <mappages+0x77>
      break;
    a += PGSIZE;
80105e37:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105e3d:	eb d3                	jmp    80105e12 <mappages+0x30>
      panic("remap");
80105e3f:	83 ec 0c             	sub    $0xc,%esp
80105e42:	68 9c 6e 10 80       	push   $0x80106e9c
80105e47:	e8 f8 a4 ff ff       	call   80100344 <panic>
      return -1;
80105e4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    pa += PGSIZE;
  }
  return 0;
}
80105e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e54:	5b                   	pop    %ebx
80105e55:	5e                   	pop    %esi
80105e56:	5f                   	pop    %edi
80105e57:	5d                   	pop    %ebp
80105e58:	c3                   	ret    
  return 0;
80105e59:	b8 00 00 00 00       	mov    $0x0,%eax
80105e5e:	eb f1                	jmp    80105e51 <mappages+0x6f>

80105e60 <seginit>:
{
80105e60:	55                   	push   %ebp
80105e61:	89 e5                	mov    %esp,%ebp
80105e63:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80105e66:	e8 b5 d4 ff ff       	call   80103320 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105e6b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80105e71:	66 c7 80 58 38 11 80 	movw   $0xffff,-0x7feec7a8(%eax)
80105e78:	ff ff 
80105e7a:	66 c7 80 5a 38 11 80 	movw   $0x0,-0x7feec7a6(%eax)
80105e81:	00 00 
80105e83:	c6 80 5c 38 11 80 00 	movb   $0x0,-0x7feec7a4(%eax)
80105e8a:	c6 80 5d 38 11 80 9a 	movb   $0x9a,-0x7feec7a3(%eax)
80105e91:	c6 80 5e 38 11 80 cf 	movb   $0xcf,-0x7feec7a2(%eax)
80105e98:	c6 80 5f 38 11 80 00 	movb   $0x0,-0x7feec7a1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105e9f:	66 c7 80 60 38 11 80 	movw   $0xffff,-0x7feec7a0(%eax)
80105ea6:	ff ff 
80105ea8:	66 c7 80 62 38 11 80 	movw   $0x0,-0x7feec79e(%eax)
80105eaf:	00 00 
80105eb1:	c6 80 64 38 11 80 00 	movb   $0x0,-0x7feec79c(%eax)
80105eb8:	c6 80 65 38 11 80 92 	movb   $0x92,-0x7feec79b(%eax)
80105ebf:	c6 80 66 38 11 80 cf 	movb   $0xcf,-0x7feec79a(%eax)
80105ec6:	c6 80 67 38 11 80 00 	movb   $0x0,-0x7feec799(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105ecd:	66 c7 80 68 38 11 80 	movw   $0xffff,-0x7feec798(%eax)
80105ed4:	ff ff 
80105ed6:	66 c7 80 6a 38 11 80 	movw   $0x0,-0x7feec796(%eax)
80105edd:	00 00 
80105edf:	c6 80 6c 38 11 80 00 	movb   $0x0,-0x7feec794(%eax)
80105ee6:	c6 80 6d 38 11 80 fa 	movb   $0xfa,-0x7feec793(%eax)
80105eed:	c6 80 6e 38 11 80 cf 	movb   $0xcf,-0x7feec792(%eax)
80105ef4:	c6 80 6f 38 11 80 00 	movb   $0x0,-0x7feec791(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105efb:	66 c7 80 70 38 11 80 	movw   $0xffff,-0x7feec790(%eax)
80105f02:	ff ff 
80105f04:	66 c7 80 72 38 11 80 	movw   $0x0,-0x7feec78e(%eax)
80105f0b:	00 00 
80105f0d:	c6 80 74 38 11 80 00 	movb   $0x0,-0x7feec78c(%eax)
80105f14:	c6 80 75 38 11 80 f2 	movb   $0xf2,-0x7feec78b(%eax)
80105f1b:	c6 80 76 38 11 80 cf 	movb   $0xcf,-0x7feec78a(%eax)
80105f22:	c6 80 77 38 11 80 00 	movb   $0x0,-0x7feec789(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80105f29:	05 50 38 11 80       	add    $0x80113850,%eax
  pd[0] = size-1;
80105f2e:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80105f34:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80105f38:	c1 e8 10             	shr    $0x10,%eax
80105f3b:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80105f3f:	8d 45 f2             	lea    -0xe(%ebp),%eax
80105f42:	0f 01 10             	lgdtl  (%eax)
}
80105f45:	c9                   	leave  
80105f46:	c3                   	ret    

80105f47 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80105f47:	55                   	push   %ebp
80105f48:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80105f4a:	a1 84 45 11 80       	mov    0x80114584,%eax
80105f4f:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105f54:	0f 22 d8             	mov    %eax,%cr3
}
80105f57:	5d                   	pop    %ebp
80105f58:	c3                   	ret    

80105f59 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80105f59:	55                   	push   %ebp
80105f5a:	89 e5                	mov    %esp,%ebp
80105f5c:	57                   	push   %edi
80105f5d:	56                   	push   %esi
80105f5e:	53                   	push   %ebx
80105f5f:	83 ec 1c             	sub    $0x1c,%esp
80105f62:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80105f65:	85 f6                	test   %esi,%esi
80105f67:	0f 84 c3 00 00 00    	je     80106030 <switchuvm+0xd7>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80105f6d:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80105f71:	0f 84 c6 00 00 00    	je     8010603d <switchuvm+0xe4>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80105f77:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80105f7b:	0f 84 c9 00 00 00    	je     8010604a <switchuvm+0xf1>
    panic("switchuvm: no pgdir");

  pushcli();
80105f81:	e8 5b dd ff ff       	call   80103ce1 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80105f86:	e8 1e d3 ff ff       	call   801032a9 <mycpu>
80105f8b:	89 c3                	mov    %eax,%ebx
80105f8d:	e8 17 d3 ff ff       	call   801032a9 <mycpu>
80105f92:	89 c7                	mov    %eax,%edi
80105f94:	e8 10 d3 ff ff       	call   801032a9 <mycpu>
80105f99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105f9c:	e8 08 d3 ff ff       	call   801032a9 <mycpu>
80105fa1:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80105fa8:	67 00 
80105faa:	83 c7 08             	add    $0x8,%edi
80105fad:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80105fb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105fb7:	83 c2 08             	add    $0x8,%edx
80105fba:	c1 ea 10             	shr    $0x10,%edx
80105fbd:	88 93 9c 00 00 00    	mov    %dl,0x9c(%ebx)
80105fc3:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80105fca:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80105fd1:	83 c0 08             	add    $0x8,%eax
80105fd4:	c1 e8 18             	shr    $0x18,%eax
80105fd7:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80105fdd:	e8 c7 d2 ff ff       	call   801032a9 <mycpu>
80105fe2:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80105fe9:	e8 bb d2 ff ff       	call   801032a9 <mycpu>
80105fee:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80105ff4:	8b 5e 08             	mov    0x8(%esi),%ebx
80105ff7:	e8 ad d2 ff ff       	call   801032a9 <mycpu>
80105ffc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106002:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106005:	e8 9f d2 ff ff       	call   801032a9 <mycpu>
8010600a:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106010:	b8 28 00 00 00       	mov    $0x28,%eax
80106015:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106018:	8b 46 04             	mov    0x4(%esi),%eax
8010601b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106020:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106023:	e8 f6 dc ff ff       	call   80103d1e <popcli>
}
80106028:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010602b:	5b                   	pop    %ebx
8010602c:	5e                   	pop    %esi
8010602d:	5f                   	pop    %edi
8010602e:	5d                   	pop    %ebp
8010602f:	c3                   	ret    
    panic("switchuvm: no process");
80106030:	83 ec 0c             	sub    $0xc,%esp
80106033:	68 a2 6e 10 80       	push   $0x80106ea2
80106038:	e8 07 a3 ff ff       	call   80100344 <panic>
    panic("switchuvm: no kstack");
8010603d:	83 ec 0c             	sub    $0xc,%esp
80106040:	68 b8 6e 10 80       	push   $0x80106eb8
80106045:	e8 fa a2 ff ff       	call   80100344 <panic>
    panic("switchuvm: no pgdir");
8010604a:	83 ec 0c             	sub    $0xc,%esp
8010604d:	68 cd 6e 10 80       	push   $0x80106ecd
80106052:	e8 ed a2 ff ff       	call   80100344 <panic>

80106057 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106057:	55                   	push   %ebp
80106058:	89 e5                	mov    %esp,%ebp
8010605a:	56                   	push   %esi
8010605b:	53                   	push   %ebx
8010605c:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
8010605f:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106065:	77 4c                	ja     801060b3 <inituvm+0x5c>
    panic("inituvm: more than a page");
  mem = kalloc();
80106067:	e8 f4 c0 ff ff       	call   80102160 <kalloc>
8010606c:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010606e:	83 ec 04             	sub    $0x4,%esp
80106071:	68 00 10 00 00       	push   $0x1000
80106076:	6a 00                	push   $0x0
80106078:	50                   	push   %eax
80106079:	e8 e2 dd ff ff       	call   80103e60 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
8010607e:	83 c4 08             	add    $0x8,%esp
80106081:	6a 06                	push   $0x6
80106083:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106089:	50                   	push   %eax
8010608a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010608f:	ba 00 00 00 00       	mov    $0x0,%edx
80106094:	8b 45 08             	mov    0x8(%ebp),%eax
80106097:	e8 46 fd ff ff       	call   80105de2 <mappages>
  memmove(mem, init, sz);
8010609c:	83 c4 0c             	add    $0xc,%esp
8010609f:	56                   	push   %esi
801060a0:	ff 75 0c             	pushl  0xc(%ebp)
801060a3:	53                   	push   %ebx
801060a4:	e8 4c de ff ff       	call   80103ef5 <memmove>
}
801060a9:	83 c4 10             	add    $0x10,%esp
801060ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801060af:	5b                   	pop    %ebx
801060b0:	5e                   	pop    %esi
801060b1:	5d                   	pop    %ebp
801060b2:	c3                   	ret    
    panic("inituvm: more than a page");
801060b3:	83 ec 0c             	sub    $0xc,%esp
801060b6:	68 e1 6e 10 80       	push   $0x80106ee1
801060bb:	e8 84 a2 ff ff       	call   80100344 <panic>

801060c0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	57                   	push   %edi
801060c4:	56                   	push   %esi
801060c5:	53                   	push   %ebx
801060c6:	83 ec 1c             	sub    $0x1c,%esp
801060c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801060cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801060cf:	a9 ff 0f 00 00       	test   $0xfff,%eax
801060d4:	75 71                	jne    80106147 <loaduvm+0x87>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801060d6:	8b 75 18             	mov    0x18(%ebp),%esi
801060d9:	bb 00 00 00 00       	mov    $0x0,%ebx
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801060de:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i = 0; i < sz; i += PGSIZE){
801060e3:	85 f6                	test   %esi,%esi
801060e5:	74 7f                	je     80106166 <loaduvm+0xa6>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801060e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060ea:	8d 14 18             	lea    (%eax,%ebx,1),%edx
801060ed:	b9 00 00 00 00       	mov    $0x0,%ecx
801060f2:	8b 45 08             	mov    0x8(%ebp),%eax
801060f5:	e8 79 fc ff ff       	call   80105d73 <walkpgdir>
801060fa:	85 c0                	test   %eax,%eax
801060fc:	74 56                	je     80106154 <loaduvm+0x94>
    pa = PTE_ADDR(*pte);
801060fe:	8b 00                	mov    (%eax),%eax
80106100:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = sz - i;
80106105:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010610b:	bf 00 10 00 00       	mov    $0x1000,%edi
80106110:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106113:	57                   	push   %edi
80106114:	89 da                	mov    %ebx,%edx
80106116:	03 55 14             	add    0x14(%ebp),%edx
80106119:	52                   	push   %edx
8010611a:	05 00 00 00 80       	add    $0x80000000,%eax
8010611f:	50                   	push   %eax
80106120:	ff 75 10             	pushl  0x10(%ebp)
80106123:	e8 54 b6 ff ff       	call   8010177c <readi>
80106128:	83 c4 10             	add    $0x10,%esp
8010612b:	39 f8                	cmp    %edi,%eax
8010612d:	75 32                	jne    80106161 <loaduvm+0xa1>
  for(i = 0; i < sz; i += PGSIZE){
8010612f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106135:	81 ee 00 10 00 00    	sub    $0x1000,%esi
8010613b:	39 5d 18             	cmp    %ebx,0x18(%ebp)
8010613e:	77 a7                	ja     801060e7 <loaduvm+0x27>
  return 0;
80106140:	b8 00 00 00 00       	mov    $0x0,%eax
80106145:	eb 1f                	jmp    80106166 <loaduvm+0xa6>
    panic("loaduvm: addr must be page aligned");
80106147:	83 ec 0c             	sub    $0xc,%esp
8010614a:	68 9c 6f 10 80       	push   $0x80106f9c
8010614f:	e8 f0 a1 ff ff       	call   80100344 <panic>
      panic("loaduvm: address should exist");
80106154:	83 ec 0c             	sub    $0xc,%esp
80106157:	68 fb 6e 10 80       	push   $0x80106efb
8010615c:	e8 e3 a1 ff ff       	call   80100344 <panic>
      return -1;
80106161:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106166:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106169:	5b                   	pop    %ebx
8010616a:	5e                   	pop    %esi
8010616b:	5f                   	pop    %edi
8010616c:	5d                   	pop    %ebp
8010616d:	c3                   	ret    

8010616e <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010616e:	55                   	push   %ebp
8010616f:	89 e5                	mov    %esp,%ebp
80106171:	57                   	push   %edi
80106172:	56                   	push   %esi
80106173:	53                   	push   %ebx
80106174:	83 ec 0c             	sub    $0xc,%esp
80106177:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;
8010617a:	89 f8                	mov    %edi,%eax
  if(newsz >= oldsz)
8010617c:	39 7d 10             	cmp    %edi,0x10(%ebp)
8010617f:	73 16                	jae    80106197 <deallocuvm+0x29>

  a = PGROUNDUP(newsz);
80106181:	8b 45 10             	mov    0x10(%ebp),%eax
80106184:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010618a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106190:	39 df                	cmp    %ebx,%edi
80106192:	77 21                	ja     801061b5 <deallocuvm+0x47>
      char *v = P2V(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80106194:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106197:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010619a:	5b                   	pop    %ebx
8010619b:	5e                   	pop    %esi
8010619c:	5f                   	pop    %edi
8010619d:	5d                   	pop    %ebp
8010619e:	c3                   	ret    
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010619f:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801061a5:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801061ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801061b1:	39 df                	cmp    %ebx,%edi
801061b3:	76 df                	jbe    80106194 <deallocuvm+0x26>
    pte = walkpgdir(pgdir, (char*)a, 0);
801061b5:	b9 00 00 00 00       	mov    $0x0,%ecx
801061ba:	89 da                	mov    %ebx,%edx
801061bc:	8b 45 08             	mov    0x8(%ebp),%eax
801061bf:	e8 af fb ff ff       	call   80105d73 <walkpgdir>
801061c4:	89 c6                	mov    %eax,%esi
    if(!pte)
801061c6:	85 c0                	test   %eax,%eax
801061c8:	74 d5                	je     8010619f <deallocuvm+0x31>
    else if((*pte & PTE_P) != 0){
801061ca:	8b 00                	mov    (%eax),%eax
801061cc:	a8 01                	test   $0x1,%al
801061ce:	74 db                	je     801061ab <deallocuvm+0x3d>
      if(pa == 0)
801061d0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801061d5:	74 19                	je     801061f0 <deallocuvm+0x82>
      kfree(v);
801061d7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801061da:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801061df:	50                   	push   %eax
801061e0:	e8 56 be ff ff       	call   8010203b <kfree>
      *pte = 0;
801061e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801061eb:	83 c4 10             	add    $0x10,%esp
801061ee:	eb bb                	jmp    801061ab <deallocuvm+0x3d>
        panic("kfree");
801061f0:	83 ec 0c             	sub    $0xc,%esp
801061f3:	68 fa 67 10 80       	push   $0x801067fa
801061f8:	e8 47 a1 ff ff       	call   80100344 <panic>

801061fd <allocuvm>:
{
801061fd:	55                   	push   %ebp
801061fe:	89 e5                	mov    %esp,%ebp
80106200:	57                   	push   %edi
80106201:	56                   	push   %esi
80106202:	53                   	push   %ebx
80106203:	83 ec 1c             	sub    $0x1c,%esp
80106206:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106209:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010620c:	85 ff                	test   %edi,%edi
8010620e:	0f 88 c5 00 00 00    	js     801062d9 <allocuvm+0xdc>
  if(newsz < oldsz)
80106214:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106217:	72 60                	jb     80106279 <allocuvm+0x7c>
  a = PGROUNDUP(oldsz);
80106219:	8b 45 0c             	mov    0xc(%ebp),%eax
8010621c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106222:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106228:	39 df                	cmp    %ebx,%edi
8010622a:	0f 86 b0 00 00 00    	jbe    801062e0 <allocuvm+0xe3>
    mem = kalloc();
80106230:	e8 2b bf ff ff       	call   80102160 <kalloc>
80106235:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106237:	85 c0                	test   %eax,%eax
80106239:	74 46                	je     80106281 <allocuvm+0x84>
    memset(mem, 0, PGSIZE);
8010623b:	83 ec 04             	sub    $0x4,%esp
8010623e:	68 00 10 00 00       	push   $0x1000
80106243:	6a 00                	push   $0x0
80106245:	50                   	push   %eax
80106246:	e8 15 dc ff ff       	call   80103e60 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
8010624b:	83 c4 08             	add    $0x8,%esp
8010624e:	6a 06                	push   $0x6
80106250:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106256:	50                   	push   %eax
80106257:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010625c:	89 da                	mov    %ebx,%edx
8010625e:	8b 45 08             	mov    0x8(%ebp),%eax
80106261:	e8 7c fb ff ff       	call   80105de2 <mappages>
80106266:	83 c4 10             	add    $0x10,%esp
80106269:	85 c0                	test   %eax,%eax
8010626b:	78 3c                	js     801062a9 <allocuvm+0xac>
  for(; a < newsz; a += PGSIZE){
8010626d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106273:	39 df                	cmp    %ebx,%edi
80106275:	77 b9                	ja     80106230 <allocuvm+0x33>
80106277:	eb 67                	jmp    801062e0 <allocuvm+0xe3>
    return oldsz;
80106279:	8b 45 0c             	mov    0xc(%ebp),%eax
8010627c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010627f:	eb 5f                	jmp    801062e0 <allocuvm+0xe3>
      cprintf("allocuvm out of memory\n");
80106281:	83 ec 0c             	sub    $0xc,%esp
80106284:	68 19 6f 10 80       	push   $0x80106f19
80106289:	e8 53 a3 ff ff       	call   801005e1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010628e:	83 c4 0c             	add    $0xc,%esp
80106291:	ff 75 0c             	pushl  0xc(%ebp)
80106294:	57                   	push   %edi
80106295:	ff 75 08             	pushl  0x8(%ebp)
80106298:	e8 d1 fe ff ff       	call   8010616e <deallocuvm>
      return 0;
8010629d:	83 c4 10             	add    $0x10,%esp
801062a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801062a7:	eb 37                	jmp    801062e0 <allocuvm+0xe3>
      cprintf("allocuvm out of memory (2)\n");
801062a9:	83 ec 0c             	sub    $0xc,%esp
801062ac:	68 31 6f 10 80       	push   $0x80106f31
801062b1:	e8 2b a3 ff ff       	call   801005e1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801062b6:	83 c4 0c             	add    $0xc,%esp
801062b9:	ff 75 0c             	pushl  0xc(%ebp)
801062bc:	57                   	push   %edi
801062bd:	ff 75 08             	pushl  0x8(%ebp)
801062c0:	e8 a9 fe ff ff       	call   8010616e <deallocuvm>
      kfree(mem);
801062c5:	89 34 24             	mov    %esi,(%esp)
801062c8:	e8 6e bd ff ff       	call   8010203b <kfree>
      return 0;
801062cd:	83 c4 10             	add    $0x10,%esp
801062d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801062d7:	eb 07                	jmp    801062e0 <allocuvm+0xe3>
    return 0;
801062d9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801062e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801062e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062e6:	5b                   	pop    %ebx
801062e7:	5e                   	pop    %esi
801062e8:	5f                   	pop    %edi
801062e9:	5d                   	pop    %ebp
801062ea:	c3                   	ret    

801062eb <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801062eb:	55                   	push   %ebp
801062ec:	89 e5                	mov    %esp,%ebp
801062ee:	57                   	push   %edi
801062ef:	56                   	push   %esi
801062f0:	53                   	push   %ebx
801062f1:	83 ec 0c             	sub    $0xc,%esp
801062f4:	8b 7d 08             	mov    0x8(%ebp),%edi
  uint i;

  if(pgdir == 0)
801062f7:	85 ff                	test   %edi,%edi
801062f9:	74 1d                	je     80106318 <freevm+0x2d>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
801062fb:	83 ec 04             	sub    $0x4,%esp
801062fe:	6a 00                	push   $0x0
80106300:	68 00 00 00 80       	push   $0x80000000
80106305:	57                   	push   %edi
80106306:	e8 63 fe ff ff       	call   8010616e <deallocuvm>
8010630b:	89 fb                	mov    %edi,%ebx
8010630d:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
80106313:	83 c4 10             	add    $0x10,%esp
80106316:	eb 14                	jmp    8010632c <freevm+0x41>
    panic("freevm: no pgdir");
80106318:	83 ec 0c             	sub    $0xc,%esp
8010631b:	68 4d 6f 10 80       	push   $0x80106f4d
80106320:	e8 1f a0 ff ff       	call   80100344 <panic>
80106325:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80106328:	39 f3                	cmp    %esi,%ebx
8010632a:	74 1e                	je     8010634a <freevm+0x5f>
    if(pgdir[i] & PTE_P){
8010632c:	8b 03                	mov    (%ebx),%eax
8010632e:	a8 01                	test   $0x1,%al
80106330:	74 f3                	je     80106325 <freevm+0x3a>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106332:	83 ec 0c             	sub    $0xc,%esp
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106335:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010633a:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010633f:	50                   	push   %eax
80106340:	e8 f6 bc ff ff       	call   8010203b <kfree>
80106345:	83 c4 10             	add    $0x10,%esp
80106348:	eb db                	jmp    80106325 <freevm+0x3a>
    }
  }
  kfree((char*)pgdir);
8010634a:	83 ec 0c             	sub    $0xc,%esp
8010634d:	57                   	push   %edi
8010634e:	e8 e8 bc ff ff       	call   8010203b <kfree>
}
80106353:	83 c4 10             	add    $0x10,%esp
80106356:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106359:	5b                   	pop    %ebx
8010635a:	5e                   	pop    %esi
8010635b:	5f                   	pop    %edi
8010635c:	5d                   	pop    %ebp
8010635d:	c3                   	ret    

8010635e <setupkvm>:
{
8010635e:	55                   	push   %ebp
8010635f:	89 e5                	mov    %esp,%ebp
80106361:	56                   	push   %esi
80106362:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106363:	e8 f8 bd ff ff       	call   80102160 <kalloc>
80106368:	89 c6                	mov    %eax,%esi
8010636a:	85 c0                	test   %eax,%eax
8010636c:	74 42                	je     801063b0 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
8010636e:	83 ec 04             	sub    $0x4,%esp
80106371:	68 00 10 00 00       	push   $0x1000
80106376:	6a 00                	push   $0x0
80106378:	50                   	push   %eax
80106379:	e8 e2 da ff ff       	call   80103e60 <memset>
8010637e:	83 c4 10             	add    $0x10,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106381:	bb 20 94 10 80       	mov    $0x80109420,%ebx
                (uint)k->phys_start, k->perm) < 0) {
80106386:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106389:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010638c:	29 c1                	sub    %eax,%ecx
8010638e:	83 ec 08             	sub    $0x8,%esp
80106391:	ff 73 0c             	pushl  0xc(%ebx)
80106394:	50                   	push   %eax
80106395:	8b 13                	mov    (%ebx),%edx
80106397:	89 f0                	mov    %esi,%eax
80106399:	e8 44 fa ff ff       	call   80105de2 <mappages>
8010639e:	83 c4 10             	add    $0x10,%esp
801063a1:	85 c0                	test   %eax,%eax
801063a3:	78 14                	js     801063b9 <setupkvm+0x5b>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801063a5:	83 c3 10             	add    $0x10,%ebx
801063a8:	81 fb 60 94 10 80    	cmp    $0x80109460,%ebx
801063ae:	75 d6                	jne    80106386 <setupkvm+0x28>
}
801063b0:	89 f0                	mov    %esi,%eax
801063b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801063b5:	5b                   	pop    %ebx
801063b6:	5e                   	pop    %esi
801063b7:	5d                   	pop    %ebp
801063b8:	c3                   	ret    
      freevm(pgdir);
801063b9:	83 ec 0c             	sub    $0xc,%esp
801063bc:	56                   	push   %esi
801063bd:	e8 29 ff ff ff       	call   801062eb <freevm>
      return 0;
801063c2:	83 c4 10             	add    $0x10,%esp
801063c5:	be 00 00 00 00       	mov    $0x0,%esi
801063ca:	eb e4                	jmp    801063b0 <setupkvm+0x52>

801063cc <kvmalloc>:
{
801063cc:	55                   	push   %ebp
801063cd:	89 e5                	mov    %esp,%ebp
801063cf:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801063d2:	e8 87 ff ff ff       	call   8010635e <setupkvm>
801063d7:	a3 84 45 11 80       	mov    %eax,0x80114584
  switchkvm();
801063dc:	e8 66 fb ff ff       	call   80105f47 <switchkvm>
}
801063e1:	c9                   	leave  
801063e2:	c3                   	ret    

801063e3 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801063e3:	55                   	push   %ebp
801063e4:	89 e5                	mov    %esp,%ebp
801063e6:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801063e9:	b9 00 00 00 00       	mov    $0x0,%ecx
801063ee:	8b 55 0c             	mov    0xc(%ebp),%edx
801063f1:	8b 45 08             	mov    0x8(%ebp),%eax
801063f4:	e8 7a f9 ff ff       	call   80105d73 <walkpgdir>
  if(pte == 0)
801063f9:	85 c0                	test   %eax,%eax
801063fb:	74 05                	je     80106402 <clearpteu+0x1f>
    panic("clearpteu");
  *pte &= ~PTE_U;
801063fd:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106400:	c9                   	leave  
80106401:	c3                   	ret    
    panic("clearpteu");
80106402:	83 ec 0c             	sub    $0xc,%esp
80106405:	68 5e 6f 10 80       	push   $0x80106f5e
8010640a:	e8 35 9f ff ff       	call   80100344 <panic>

8010640f <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010640f:	55                   	push   %ebp
80106410:	89 e5                	mov    %esp,%ebp
80106412:	57                   	push   %edi
80106413:	56                   	push   %esi
80106414:	53                   	push   %ebx
80106415:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106418:	e8 41 ff ff ff       	call   8010635e <setupkvm>
8010641d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106420:	85 c0                	test   %eax,%eax
80106422:	0f 84 bb 00 00 00    	je     801064e3 <copyuvm+0xd4>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106428:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010642c:	0f 84 b1 00 00 00    	je     801064e3 <copyuvm+0xd4>
80106432:	bf 00 00 00 00       	mov    $0x0,%edi
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106437:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010643a:	b9 00 00 00 00       	mov    $0x0,%ecx
8010643f:	89 fa                	mov    %edi,%edx
80106441:	8b 45 08             	mov    0x8(%ebp),%eax
80106444:	e8 2a f9 ff ff       	call   80105d73 <walkpgdir>
80106449:	85 c0                	test   %eax,%eax
8010644b:	74 67                	je     801064b4 <copyuvm+0xa5>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
8010644d:	8b 00                	mov    (%eax),%eax
8010644f:	a8 01                	test   $0x1,%al
80106451:	74 6e                	je     801064c1 <copyuvm+0xb2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106453:	89 c6                	mov    %eax,%esi
80106455:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
8010645b:	25 ff 0f 00 00       	and    $0xfff,%eax
80106460:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
80106463:	e8 f8 bc ff ff       	call   80102160 <kalloc>
80106468:	89 c3                	mov    %eax,%ebx
8010646a:	85 c0                	test   %eax,%eax
8010646c:	74 60                	je     801064ce <copyuvm+0xbf>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010646e:	83 ec 04             	sub    $0x4,%esp
80106471:	68 00 10 00 00       	push   $0x1000
80106476:	81 c6 00 00 00 80    	add    $0x80000000,%esi
8010647c:	56                   	push   %esi
8010647d:	50                   	push   %eax
8010647e:	e8 72 da ff ff       	call   80103ef5 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106483:	83 c4 08             	add    $0x8,%esp
80106486:	ff 75 e0             	pushl  -0x20(%ebp)
80106489:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
8010648f:	53                   	push   %ebx
80106490:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106495:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106498:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010649b:	e8 42 f9 ff ff       	call   80105de2 <mappages>
801064a0:	83 c4 10             	add    $0x10,%esp
801064a3:	85 c0                	test   %eax,%eax
801064a5:	78 27                	js     801064ce <copyuvm+0xbf>
  for(i = 0; i < sz; i += PGSIZE){
801064a7:	81 c7 00 10 00 00    	add    $0x1000,%edi
801064ad:	39 7d 0c             	cmp    %edi,0xc(%ebp)
801064b0:	77 85                	ja     80106437 <copyuvm+0x28>
801064b2:	eb 2f                	jmp    801064e3 <copyuvm+0xd4>
      panic("copyuvm: pte should exist");
801064b4:	83 ec 0c             	sub    $0xc,%esp
801064b7:	68 68 6f 10 80       	push   $0x80106f68
801064bc:	e8 83 9e ff ff       	call   80100344 <panic>
      panic("copyuvm: page not present");
801064c1:	83 ec 0c             	sub    $0xc,%esp
801064c4:	68 82 6f 10 80       	push   $0x80106f82
801064c9:	e8 76 9e ff ff       	call   80100344 <panic>
      goto bad;
  }
  return d;

bad:
  freevm(d);
801064ce:	83 ec 0c             	sub    $0xc,%esp
801064d1:	ff 75 dc             	pushl  -0x24(%ebp)
801064d4:	e8 12 fe ff ff       	call   801062eb <freevm>
  return 0;
801064d9:	83 c4 10             	add    $0x10,%esp
801064dc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
801064e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801064e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064e9:	5b                   	pop    %ebx
801064ea:	5e                   	pop    %esi
801064eb:	5f                   	pop    %edi
801064ec:	5d                   	pop    %ebp
801064ed:	c3                   	ret    

801064ee <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801064ee:	55                   	push   %ebp
801064ef:	89 e5                	mov    %esp,%ebp
801064f1:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801064f4:	b9 00 00 00 00       	mov    $0x0,%ecx
801064f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801064fc:	8b 45 08             	mov    0x8(%ebp),%eax
801064ff:	e8 6f f8 ff ff       	call   80105d73 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106504:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106506:	89 c2                	mov    %eax,%edx
80106508:	83 e2 05             	and    $0x5,%edx
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010650b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106510:	05 00 00 00 80       	add    $0x80000000,%eax
80106515:	83 fa 05             	cmp    $0x5,%edx
80106518:	ba 00 00 00 00       	mov    $0x0,%edx
8010651d:	0f 45 c2             	cmovne %edx,%eax
}
80106520:	c9                   	leave  
80106521:	c3                   	ret    

80106522 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106522:	55                   	push   %ebp
80106523:	89 e5                	mov    %esp,%ebp
80106525:	57                   	push   %edi
80106526:	56                   	push   %esi
80106527:	53                   	push   %ebx
80106528:	83 ec 0c             	sub    $0xc,%esp
8010652b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010652e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80106532:	74 55                	je     80106589 <copyout+0x67>
    va0 = (uint)PGROUNDDOWN(va);
80106534:	89 df                	mov    %ebx,%edi
80106536:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
8010653c:	83 ec 08             	sub    $0x8,%esp
8010653f:	57                   	push   %edi
80106540:	ff 75 08             	pushl  0x8(%ebp)
80106543:	e8 a6 ff ff ff       	call   801064ee <uva2ka>
    if(pa0 == 0)
80106548:	83 c4 10             	add    $0x10,%esp
8010654b:	85 c0                	test   %eax,%eax
8010654d:	74 41                	je     80106590 <copyout+0x6e>
      return -1;
    n = PGSIZE - (va - va0);
8010654f:	89 fe                	mov    %edi,%esi
80106551:	29 de                	sub    %ebx,%esi
80106553:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106559:	3b 75 14             	cmp    0x14(%ebp),%esi
8010655c:	0f 47 75 14          	cmova  0x14(%ebp),%esi
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106560:	83 ec 04             	sub    $0x4,%esp
80106563:	56                   	push   %esi
80106564:	ff 75 10             	pushl  0x10(%ebp)
80106567:	29 fb                	sub    %edi,%ebx
80106569:	01 d8                	add    %ebx,%eax
8010656b:	50                   	push   %eax
8010656c:	e8 84 d9 ff ff       	call   80103ef5 <memmove>
    len -= n;
    buf += n;
80106571:	01 75 10             	add    %esi,0x10(%ebp)
    va = va0 + PGSIZE;
80106574:	8d 9f 00 10 00 00    	lea    0x1000(%edi),%ebx
  while(len > 0){
8010657a:	83 c4 10             	add    $0x10,%esp
8010657d:	29 75 14             	sub    %esi,0x14(%ebp)
80106580:	75 b2                	jne    80106534 <copyout+0x12>
  }
  return 0;
80106582:	b8 00 00 00 00       	mov    $0x0,%eax
80106587:	eb 0c                	jmp    80106595 <copyout+0x73>
80106589:	b8 00 00 00 00       	mov    $0x0,%eax
8010658e:	eb 05                	jmp    80106595 <copyout+0x73>
      return -1;
80106590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106595:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106598:	5b                   	pop    %ebx
80106599:	5e                   	pop    %esi
8010659a:	5f                   	pop    %edi
8010659b:	5d                   	pop    %ebp
8010659c:	c3                   	ret    
