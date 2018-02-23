
_p4test2:     file format elf32-i386


Disassembly of section .text:

00000000 <countForever>:
#define PrioCount 7
#define numChildren 10

void
countForever(int i)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    int j, p, rc;
    unsigned long count = 0;
   6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    j = getpid();
   d:	e8 04 05 00 00       	call   516 <getpid>
  12:	89 45 ec             	mov    %eax,-0x14(%ebp)
    p = i%PrioCount;
  15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  18:	ba 93 24 49 92       	mov    $0x92492493,%edx
  1d:	89 c8                	mov    %ecx,%eax
  1f:	f7 ea                	imul   %edx
  21:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  24:	c1 f8 02             	sar    $0x2,%eax
  27:	89 c2                	mov    %eax,%edx
  29:	89 c8                	mov    %ecx,%eax
  2b:	c1 f8 1f             	sar    $0x1f,%eax
  2e:	29 c2                	sub    %eax,%edx
  30:	89 d0                	mov    %edx,%eax
  32:	c1 e0 03             	shl    $0x3,%eax
  35:	29 d0                	sub    %edx,%eax
  37:	29 c1                	sub    %eax,%ecx
  39:	89 c8                	mov    %ecx,%eax
  3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    rc = setpriority(j, p);
  3e:	83 ec 08             	sub    $0x8,%esp
  41:	ff 75 f4             	pushl  -0xc(%ebp)
  44:	ff 75 ec             	pushl  -0x14(%ebp)
  47:	e8 2a 05 00 00       	call   576 <setpriority>
  4c:	83 c4 10             	add    $0x10,%esp
  4f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (rc == 0) 
  52:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  56:	75 17                	jne    6f <countForever+0x6f>
        printf(1, "%d: start prio %d\n", j, p);
  58:	ff 75 f4             	pushl  -0xc(%ebp)
  5b:	ff 75 ec             	pushl  -0x14(%ebp)
  5e:	68 0c 0a 00 00       	push   $0xa0c
  63:	6a 01                	push   $0x1
  65:	e8 eb 05 00 00       	call   655 <printf>
  6a:	83 c4 10             	add    $0x10,%esp
  6d:	eb 1b                	jmp    8a <countForever+0x8a>
    else {
        printf(1, "setpriority failed. file %s at %d\n", __FILE__, __LINE__);
  6f:	6a 13                	push   $0x13
  71:	68 1f 0a 00 00       	push   $0xa1f
  76:	68 2c 0a 00 00       	push   $0xa2c
  7b:	6a 01                	push   $0x1
  7d:	e8 d3 05 00 00       	call   655 <printf>
  82:	83 c4 10             	add    $0x10,%esp
        exit();
  85:	e8 0c 04 00 00       	call   496 <exit>
    }

    while (1) {
        count++;
  8a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
        if ((count & (0x1FFFFFFF)) == 0) {
  8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  91:	25 ff ff ff 1f       	and    $0x1fffffff,%eax
  96:	85 c0                	test   %eax,%eax
  98:	75 f0                	jne    8a <countForever+0x8a>
            p = (p+1) % PrioCount;
  9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9d:	8d 48 01             	lea    0x1(%eax),%ecx
  a0:	ba 93 24 49 92       	mov    $0x92492493,%edx
  a5:	89 c8                	mov    %ecx,%eax
  a7:	f7 ea                	imul   %edx
  a9:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  ac:	c1 f8 02             	sar    $0x2,%eax
  af:	89 c2                	mov    %eax,%edx
  b1:	89 c8                	mov    %ecx,%eax
  b3:	c1 f8 1f             	sar    $0x1f,%eax
  b6:	29 c2                	sub    %eax,%edx
  b8:	89 d0                	mov    %edx,%eax
  ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  c0:	89 d0                	mov    %edx,%eax
  c2:	c1 e0 03             	shl    $0x3,%eax
  c5:	29 d0                	sub    %edx,%eax
  c7:	29 c1                	sub    %eax,%ecx
  c9:	89 c8                	mov    %ecx,%eax
  cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
            rc = setpriority(j, p);
  ce:	83 ec 08             	sub    $0x8,%esp
  d1:	ff 75 f4             	pushl  -0xc(%ebp)
  d4:	ff 75 ec             	pushl  -0x14(%ebp)
  d7:	e8 9a 04 00 00       	call   576 <setpriority>
  dc:	83 c4 10             	add    $0x10,%esp
  df:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (rc == 0) 
  e2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  e6:	75 17                	jne    ff <countForever+0xff>
                printf(1, "%d: new prio %d\n", j, p);
  e8:	ff 75 f4             	pushl  -0xc(%ebp)
  eb:	ff 75 ec             	pushl  -0x14(%ebp)
  ee:	68 4f 0a 00 00       	push   $0xa4f
  f3:	6a 01                	push   $0x1
  f5:	e8 5b 05 00 00       	call   655 <printf>
  fa:	83 c4 10             	add    $0x10,%esp
  fd:	eb 8b                	jmp    8a <countForever+0x8a>
            else {
                printf(1, "setpriority failed. file %s at %d\n", __FILE__, __LINE__);
  ff:	6a 1f                	push   $0x1f
 101:	68 1f 0a 00 00       	push   $0xa1f
 106:	68 2c 0a 00 00       	push   $0xa2c
 10b:	6a 01                	push   $0x1
 10d:	e8 43 05 00 00       	call   655 <printf>
 112:	83 c4 10             	add    $0x10,%esp
                exit();
 115:	e8 7c 03 00 00       	call   496 <exit>

0000011a <main>:
    }
}

    int
main(void)
{
 11a:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 11e:	83 e4 f0             	and    $0xfffffff0,%esp
 121:	ff 71 fc             	pushl  -0x4(%ecx)
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	51                   	push   %ecx
 128:	83 ec 14             	sub    $0x14,%esp
    int i, rc;

    for (i=0; i<numChildren; i++) {
 12b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 132:	eb 20                	jmp    154 <main+0x3a>
        rc = fork();
 134:	e8 55 03 00 00       	call   48e <fork>
 139:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (!rc) { // child
 13c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 140:	75 0e                	jne    150 <main+0x36>
            countForever(i);
 142:	83 ec 0c             	sub    $0xc,%esp
 145:	ff 75 f4             	pushl  -0xc(%ebp)
 148:	e8 b3 fe ff ff       	call   0 <countForever>
 14d:	83 c4 10             	add    $0x10,%esp
    int
main(void)
{
    int i, rc;

    for (i=0; i<numChildren; i++) {
 150:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 154:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
 158:	7e da                	jle    134 <main+0x1a>
        if (!rc) { // child
            countForever(i);
        }
    }
    // what the heck, let's have the parent waste time as well!
    countForever(1);
 15a:	83 ec 0c             	sub    $0xc,%esp
 15d:	6a 01                	push   $0x1
 15f:	e8 9c fe ff ff       	call   0 <countForever>
 164:	83 c4 10             	add    $0x10,%esp
    exit();
 167:	e8 2a 03 00 00       	call   496 <exit>

0000016c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
 16f:	57                   	push   %edi
 170:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 171:	8b 4d 08             	mov    0x8(%ebp),%ecx
 174:	8b 55 10             	mov    0x10(%ebp),%edx
 177:	8b 45 0c             	mov    0xc(%ebp),%eax
 17a:	89 cb                	mov    %ecx,%ebx
 17c:	89 df                	mov    %ebx,%edi
 17e:	89 d1                	mov    %edx,%ecx
 180:	fc                   	cld    
 181:	f3 aa                	rep stos %al,%es:(%edi)
 183:	89 ca                	mov    %ecx,%edx
 185:	89 fb                	mov    %edi,%ebx
 187:	89 5d 08             	mov    %ebx,0x8(%ebp)
 18a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 18d:	90                   	nop
 18e:	5b                   	pop    %ebx
 18f:	5f                   	pop    %edi
 190:	5d                   	pop    %ebp
 191:	c3                   	ret    

00000192 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
 195:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 19e:	90                   	nop
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	8d 50 01             	lea    0x1(%eax),%edx
 1a5:	89 55 08             	mov    %edx,0x8(%ebp)
 1a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ab:	8d 4a 01             	lea    0x1(%edx),%ecx
 1ae:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1b1:	0f b6 12             	movzbl (%edx),%edx
 1b4:	88 10                	mov    %dl,(%eax)
 1b6:	0f b6 00             	movzbl (%eax),%eax
 1b9:	84 c0                	test   %al,%al
 1bb:	75 e2                	jne    19f <strcpy+0xd>
    ;
  return os;
 1bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c0:	c9                   	leave  
 1c1:	c3                   	ret    

000001c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c2:	55                   	push   %ebp
 1c3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1c5:	eb 08                	jmp    1cf <strcmp+0xd>
    p++, q++;
 1c7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1cb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	84 c0                	test   %al,%al
 1d7:	74 10                	je     1e9 <strcmp+0x27>
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
 1dc:	0f b6 10             	movzbl (%eax),%edx
 1df:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e2:	0f b6 00             	movzbl (%eax),%eax
 1e5:	38 c2                	cmp    %al,%dl
 1e7:	74 de                	je     1c7 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	0f b6 00             	movzbl (%eax),%eax
 1ef:	0f b6 d0             	movzbl %al,%edx
 1f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f5:	0f b6 00             	movzbl (%eax),%eax
 1f8:	0f b6 c0             	movzbl %al,%eax
 1fb:	29 c2                	sub    %eax,%edx
 1fd:	89 d0                	mov    %edx,%eax
}
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    

00000201 <strlen>:

uint
strlen(char *s)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 207:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 20e:	eb 04                	jmp    214 <strlen+0x13>
 210:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 214:	8b 55 fc             	mov    -0x4(%ebp),%edx
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	01 d0                	add    %edx,%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	84 c0                	test   %al,%al
 221:	75 ed                	jne    210 <strlen+0xf>
    ;
  return n;
 223:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <memset>:

void*
memset(void *dst, int c, uint n)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 22b:	8b 45 10             	mov    0x10(%ebp),%eax
 22e:	50                   	push   %eax
 22f:	ff 75 0c             	pushl  0xc(%ebp)
 232:	ff 75 08             	pushl  0x8(%ebp)
 235:	e8 32 ff ff ff       	call   16c <stosb>
 23a:	83 c4 0c             	add    $0xc,%esp
  return dst;
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 240:	c9                   	leave  
 241:	c3                   	ret    

00000242 <strchr>:

char*
strchr(const char *s, char c)
{
 242:	55                   	push   %ebp
 243:	89 e5                	mov    %esp,%ebp
 245:	83 ec 04             	sub    $0x4,%esp
 248:	8b 45 0c             	mov    0xc(%ebp),%eax
 24b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 24e:	eb 14                	jmp    264 <strchr+0x22>
    if(*s == c)
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	0f b6 00             	movzbl (%eax),%eax
 256:	3a 45 fc             	cmp    -0x4(%ebp),%al
 259:	75 05                	jne    260 <strchr+0x1e>
      return (char*)s;
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	eb 13                	jmp    273 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 260:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	0f b6 00             	movzbl (%eax),%eax
 26a:	84 c0                	test   %al,%al
 26c:	75 e2                	jne    250 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 26e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <gets>:

char*
gets(char *buf, int max)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 282:	eb 42                	jmp    2c6 <gets+0x51>
    cc = read(0, &c, 1);
 284:	83 ec 04             	sub    $0x4,%esp
 287:	6a 01                	push   $0x1
 289:	8d 45 ef             	lea    -0x11(%ebp),%eax
 28c:	50                   	push   %eax
 28d:	6a 00                	push   $0x0
 28f:	e8 1a 02 00 00       	call   4ae <read>
 294:	83 c4 10             	add    $0x10,%esp
 297:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 29a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 29e:	7e 33                	jle    2d3 <gets+0x5e>
      break;
    buf[i++] = c;
 2a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a3:	8d 50 01             	lea    0x1(%eax),%edx
 2a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2a9:	89 c2                	mov    %eax,%edx
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	01 c2                	add    %eax,%edx
 2b0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ba:	3c 0a                	cmp    $0xa,%al
 2bc:	74 16                	je     2d4 <gets+0x5f>
 2be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2c2:	3c 0d                	cmp    $0xd,%al
 2c4:	74 0e                	je     2d4 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c9:	83 c0 01             	add    $0x1,%eax
 2cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2cf:	7c b3                	jl     284 <gets+0xf>
 2d1:	eb 01                	jmp    2d4 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2d3:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	01 d0                	add    %edx,%eax
 2dc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e2:	c9                   	leave  
 2e3:	c3                   	ret    

000002e4 <stat>:

int
stat(char *n, struct stat *st)
{
 2e4:	55                   	push   %ebp
 2e5:	89 e5                	mov    %esp,%ebp
 2e7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ea:	83 ec 08             	sub    $0x8,%esp
 2ed:	6a 00                	push   $0x0
 2ef:	ff 75 08             	pushl  0x8(%ebp)
 2f2:	e8 df 01 00 00       	call   4d6 <open>
 2f7:	83 c4 10             	add    $0x10,%esp
 2fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 301:	79 07                	jns    30a <stat+0x26>
    return -1;
 303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 308:	eb 25                	jmp    32f <stat+0x4b>
  r = fstat(fd, st);
 30a:	83 ec 08             	sub    $0x8,%esp
 30d:	ff 75 0c             	pushl  0xc(%ebp)
 310:	ff 75 f4             	pushl  -0xc(%ebp)
 313:	e8 d6 01 00 00       	call   4ee <fstat>
 318:	83 c4 10             	add    $0x10,%esp
 31b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 31e:	83 ec 0c             	sub    $0xc,%esp
 321:	ff 75 f4             	pushl  -0xc(%ebp)
 324:	e8 95 01 00 00       	call   4be <close>
 329:	83 c4 10             	add    $0x10,%esp
  return r;
 32c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 32f:	c9                   	leave  
 330:	c3                   	ret    

00000331 <atoi>:

int
atoi(const char *s)
{
 331:	55                   	push   %ebp
 332:	89 e5                	mov    %esp,%ebp
 334:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 337:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 33e:	eb 04                	jmp    344 <atoi+0x13>
 340:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	0f b6 00             	movzbl (%eax),%eax
 34a:	3c 20                	cmp    $0x20,%al
 34c:	74 f2                	je     340 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	0f b6 00             	movzbl (%eax),%eax
 354:	3c 2d                	cmp    $0x2d,%al
 356:	75 07                	jne    35f <atoi+0x2e>
 358:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 35d:	eb 05                	jmp    364 <atoi+0x33>
 35f:	b8 01 00 00 00       	mov    $0x1,%eax
 364:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	0f b6 00             	movzbl (%eax),%eax
 36d:	3c 2b                	cmp    $0x2b,%al
 36f:	74 0a                	je     37b <atoi+0x4a>
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	0f b6 00             	movzbl (%eax),%eax
 377:	3c 2d                	cmp    $0x2d,%al
 379:	75 2b                	jne    3a6 <atoi+0x75>
    s++;
 37b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 37f:	eb 25                	jmp    3a6 <atoi+0x75>
    n = n*10 + *s++ - '0';
 381:	8b 55 fc             	mov    -0x4(%ebp),%edx
 384:	89 d0                	mov    %edx,%eax
 386:	c1 e0 02             	shl    $0x2,%eax
 389:	01 d0                	add    %edx,%eax
 38b:	01 c0                	add    %eax,%eax
 38d:	89 c1                	mov    %eax,%ecx
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	8d 50 01             	lea    0x1(%eax),%edx
 395:	89 55 08             	mov    %edx,0x8(%ebp)
 398:	0f b6 00             	movzbl (%eax),%eax
 39b:	0f be c0             	movsbl %al,%eax
 39e:	01 c8                	add    %ecx,%eax
 3a0:	83 e8 30             	sub    $0x30,%eax
 3a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	0f b6 00             	movzbl (%eax),%eax
 3ac:	3c 2f                	cmp    $0x2f,%al
 3ae:	7e 0a                	jle    3ba <atoi+0x89>
 3b0:	8b 45 08             	mov    0x8(%ebp),%eax
 3b3:	0f b6 00             	movzbl (%eax),%eax
 3b6:	3c 39                	cmp    $0x39,%al
 3b8:	7e c7                	jle    381 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3bd:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3c1:	c9                   	leave  
 3c2:	c3                   	ret    

000003c3 <atoo>:

int
atoo(const char *s)
{
 3c3:	55                   	push   %ebp
 3c4:	89 e5                	mov    %esp,%ebp
 3c6:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3d0:	eb 04                	jmp    3d6 <atoo+0x13>
 3d2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	0f b6 00             	movzbl (%eax),%eax
 3dc:	3c 20                	cmp    $0x20,%al
 3de:	74 f2                	je     3d2 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	0f b6 00             	movzbl (%eax),%eax
 3e6:	3c 2d                	cmp    $0x2d,%al
 3e8:	75 07                	jne    3f1 <atoo+0x2e>
 3ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ef:	eb 05                	jmp    3f6 <atoo+0x33>
 3f1:	b8 01 00 00 00       	mov    $0x1,%eax
 3f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
 3fc:	0f b6 00             	movzbl (%eax),%eax
 3ff:	3c 2b                	cmp    $0x2b,%al
 401:	74 0a                	je     40d <atoo+0x4a>
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	0f b6 00             	movzbl (%eax),%eax
 409:	3c 2d                	cmp    $0x2d,%al
 40b:	75 27                	jne    434 <atoo+0x71>
    s++;
 40d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 411:	eb 21                	jmp    434 <atoo+0x71>
    n = n*8 + *s++ - '0';
 413:	8b 45 fc             	mov    -0x4(%ebp),%eax
 416:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 41d:	8b 45 08             	mov    0x8(%ebp),%eax
 420:	8d 50 01             	lea    0x1(%eax),%edx
 423:	89 55 08             	mov    %edx,0x8(%ebp)
 426:	0f b6 00             	movzbl (%eax),%eax
 429:	0f be c0             	movsbl %al,%eax
 42c:	01 c8                	add    %ecx,%eax
 42e:	83 e8 30             	sub    $0x30,%eax
 431:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	0f b6 00             	movzbl (%eax),%eax
 43a:	3c 2f                	cmp    $0x2f,%al
 43c:	7e 0a                	jle    448 <atoo+0x85>
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	0f b6 00             	movzbl (%eax),%eax
 444:	3c 37                	cmp    $0x37,%al
 446:	7e cb                	jle    413 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 448:	8b 45 f8             	mov    -0x8(%ebp),%eax
 44b:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 44f:	c9                   	leave  
 450:	c3                   	ret    

00000451 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 451:	55                   	push   %ebp
 452:	89 e5                	mov    %esp,%ebp
 454:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 45d:	8b 45 0c             	mov    0xc(%ebp),%eax
 460:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 463:	eb 17                	jmp    47c <memmove+0x2b>
    *dst++ = *src++;
 465:	8b 45 fc             	mov    -0x4(%ebp),%eax
 468:	8d 50 01             	lea    0x1(%eax),%edx
 46b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 46e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 471:	8d 4a 01             	lea    0x1(%edx),%ecx
 474:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 477:	0f b6 12             	movzbl (%edx),%edx
 47a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 47c:	8b 45 10             	mov    0x10(%ebp),%eax
 47f:	8d 50 ff             	lea    -0x1(%eax),%edx
 482:	89 55 10             	mov    %edx,0x10(%ebp)
 485:	85 c0                	test   %eax,%eax
 487:	7f dc                	jg     465 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 489:	8b 45 08             	mov    0x8(%ebp),%eax
}
 48c:	c9                   	leave  
 48d:	c3                   	ret    

0000048e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 48e:	b8 01 00 00 00       	mov    $0x1,%eax
 493:	cd 40                	int    $0x40
 495:	c3                   	ret    

00000496 <exit>:
SYSCALL(exit)
 496:	b8 02 00 00 00       	mov    $0x2,%eax
 49b:	cd 40                	int    $0x40
 49d:	c3                   	ret    

0000049e <wait>:
SYSCALL(wait)
 49e:	b8 03 00 00 00       	mov    $0x3,%eax
 4a3:	cd 40                	int    $0x40
 4a5:	c3                   	ret    

000004a6 <pipe>:
SYSCALL(pipe)
 4a6:	b8 04 00 00 00       	mov    $0x4,%eax
 4ab:	cd 40                	int    $0x40
 4ad:	c3                   	ret    

000004ae <read>:
SYSCALL(read)
 4ae:	b8 05 00 00 00       	mov    $0x5,%eax
 4b3:	cd 40                	int    $0x40
 4b5:	c3                   	ret    

000004b6 <write>:
SYSCALL(write)
 4b6:	b8 10 00 00 00       	mov    $0x10,%eax
 4bb:	cd 40                	int    $0x40
 4bd:	c3                   	ret    

000004be <close>:
SYSCALL(close)
 4be:	b8 15 00 00 00       	mov    $0x15,%eax
 4c3:	cd 40                	int    $0x40
 4c5:	c3                   	ret    

000004c6 <kill>:
SYSCALL(kill)
 4c6:	b8 06 00 00 00       	mov    $0x6,%eax
 4cb:	cd 40                	int    $0x40
 4cd:	c3                   	ret    

000004ce <exec>:
SYSCALL(exec)
 4ce:	b8 07 00 00 00       	mov    $0x7,%eax
 4d3:	cd 40                	int    $0x40
 4d5:	c3                   	ret    

000004d6 <open>:
SYSCALL(open)
 4d6:	b8 0f 00 00 00       	mov    $0xf,%eax
 4db:	cd 40                	int    $0x40
 4dd:	c3                   	ret    

000004de <mknod>:
SYSCALL(mknod)
 4de:	b8 11 00 00 00       	mov    $0x11,%eax
 4e3:	cd 40                	int    $0x40
 4e5:	c3                   	ret    

000004e6 <unlink>:
SYSCALL(unlink)
 4e6:	b8 12 00 00 00       	mov    $0x12,%eax
 4eb:	cd 40                	int    $0x40
 4ed:	c3                   	ret    

000004ee <fstat>:
SYSCALL(fstat)
 4ee:	b8 08 00 00 00       	mov    $0x8,%eax
 4f3:	cd 40                	int    $0x40
 4f5:	c3                   	ret    

000004f6 <link>:
SYSCALL(link)
 4f6:	b8 13 00 00 00       	mov    $0x13,%eax
 4fb:	cd 40                	int    $0x40
 4fd:	c3                   	ret    

000004fe <mkdir>:
SYSCALL(mkdir)
 4fe:	b8 14 00 00 00       	mov    $0x14,%eax
 503:	cd 40                	int    $0x40
 505:	c3                   	ret    

00000506 <chdir>:
SYSCALL(chdir)
 506:	b8 09 00 00 00       	mov    $0x9,%eax
 50b:	cd 40                	int    $0x40
 50d:	c3                   	ret    

0000050e <dup>:
SYSCALL(dup)
 50e:	b8 0a 00 00 00       	mov    $0xa,%eax
 513:	cd 40                	int    $0x40
 515:	c3                   	ret    

00000516 <getpid>:
SYSCALL(getpid)
 516:	b8 0b 00 00 00       	mov    $0xb,%eax
 51b:	cd 40                	int    $0x40
 51d:	c3                   	ret    

0000051e <sbrk>:
SYSCALL(sbrk)
 51e:	b8 0c 00 00 00       	mov    $0xc,%eax
 523:	cd 40                	int    $0x40
 525:	c3                   	ret    

00000526 <sleep>:
SYSCALL(sleep)
 526:	b8 0d 00 00 00       	mov    $0xd,%eax
 52b:	cd 40                	int    $0x40
 52d:	c3                   	ret    

0000052e <uptime>:
SYSCALL(uptime)
 52e:	b8 0e 00 00 00       	mov    $0xe,%eax
 533:	cd 40                	int    $0x40
 535:	c3                   	ret    

00000536 <halt>:
SYSCALL(halt)
 536:	b8 16 00 00 00       	mov    $0x16,%eax
 53b:	cd 40                	int    $0x40
 53d:	c3                   	ret    

0000053e <date>:
SYSCALL(date)
 53e:	b8 17 00 00 00       	mov    $0x17,%eax
 543:	cd 40                	int    $0x40
 545:	c3                   	ret    

00000546 <getuid>:
SYSCALL(getuid)
 546:	b8 18 00 00 00       	mov    $0x18,%eax
 54b:	cd 40                	int    $0x40
 54d:	c3                   	ret    

0000054e <getgid>:
SYSCALL(getgid)
 54e:	b8 19 00 00 00       	mov    $0x19,%eax
 553:	cd 40                	int    $0x40
 555:	c3                   	ret    

00000556 <getppid>:
SYSCALL(getppid)
 556:	b8 1a 00 00 00       	mov    $0x1a,%eax
 55b:	cd 40                	int    $0x40
 55d:	c3                   	ret    

0000055e <setuid>:
SYSCALL(setuid)
 55e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 563:	cd 40                	int    $0x40
 565:	c3                   	ret    

00000566 <setgid>:
SYSCALL(setgid)
 566:	b8 1c 00 00 00       	mov    $0x1c,%eax
 56b:	cd 40                	int    $0x40
 56d:	c3                   	ret    

0000056e <getprocs>:
SYSCALL(getprocs)
 56e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret    

00000576 <setpriority>:
SYSCALL(setpriority)
 576:	b8 1e 00 00 00       	mov    $0x1e,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret    

0000057e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 57e:	55                   	push   %ebp
 57f:	89 e5                	mov    %esp,%ebp
 581:	83 ec 18             	sub    $0x18,%esp
 584:	8b 45 0c             	mov    0xc(%ebp),%eax
 587:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 58a:	83 ec 04             	sub    $0x4,%esp
 58d:	6a 01                	push   $0x1
 58f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 592:	50                   	push   %eax
 593:	ff 75 08             	pushl  0x8(%ebp)
 596:	e8 1b ff ff ff       	call   4b6 <write>
 59b:	83 c4 10             	add    $0x10,%esp
}
 59e:	90                   	nop
 59f:	c9                   	leave  
 5a0:	c3                   	ret    

000005a1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a1:	55                   	push   %ebp
 5a2:	89 e5                	mov    %esp,%ebp
 5a4:	53                   	push   %ebx
 5a5:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5af:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5b3:	74 17                	je     5cc <printint+0x2b>
 5b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5b9:	79 11                	jns    5cc <printint+0x2b>
    neg = 1;
 5bb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c5:	f7 d8                	neg    %eax
 5c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5ca:	eb 06                	jmp    5d2 <printint+0x31>
  } else {
    x = xx;
 5cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 5cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5d9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5dc:	8d 41 01             	lea    0x1(%ecx),%eax
 5df:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5e8:	ba 00 00 00 00       	mov    $0x0,%edx
 5ed:	f7 f3                	div    %ebx
 5ef:	89 d0                	mov    %edx,%eax
 5f1:	0f b6 80 ec 0c 00 00 	movzbl 0xcec(%eax),%eax
 5f8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 602:	ba 00 00 00 00       	mov    $0x0,%edx
 607:	f7 f3                	div    %ebx
 609:	89 45 ec             	mov    %eax,-0x14(%ebp)
 60c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 610:	75 c7                	jne    5d9 <printint+0x38>
  if(neg)
 612:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 616:	74 2d                	je     645 <printint+0xa4>
    buf[i++] = '-';
 618:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61b:	8d 50 01             	lea    0x1(%eax),%edx
 61e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 621:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 626:	eb 1d                	jmp    645 <printint+0xa4>
    putc(fd, buf[i]);
 628:	8d 55 dc             	lea    -0x24(%ebp),%edx
 62b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62e:	01 d0                	add    %edx,%eax
 630:	0f b6 00             	movzbl (%eax),%eax
 633:	0f be c0             	movsbl %al,%eax
 636:	83 ec 08             	sub    $0x8,%esp
 639:	50                   	push   %eax
 63a:	ff 75 08             	pushl  0x8(%ebp)
 63d:	e8 3c ff ff ff       	call   57e <putc>
 642:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 645:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 64d:	79 d9                	jns    628 <printint+0x87>
    putc(fd, buf[i]);
}
 64f:	90                   	nop
 650:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 653:	c9                   	leave  
 654:	c3                   	ret    

00000655 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 655:	55                   	push   %ebp
 656:	89 e5                	mov    %esp,%ebp
 658:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 65b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 662:	8d 45 0c             	lea    0xc(%ebp),%eax
 665:	83 c0 04             	add    $0x4,%eax
 668:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 66b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 672:	e9 59 01 00 00       	jmp    7d0 <printf+0x17b>
    c = fmt[i] & 0xff;
 677:	8b 55 0c             	mov    0xc(%ebp),%edx
 67a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 67d:	01 d0                	add    %edx,%eax
 67f:	0f b6 00             	movzbl (%eax),%eax
 682:	0f be c0             	movsbl %al,%eax
 685:	25 ff 00 00 00       	and    $0xff,%eax
 68a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 68d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 691:	75 2c                	jne    6bf <printf+0x6a>
      if(c == '%'){
 693:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 697:	75 0c                	jne    6a5 <printf+0x50>
        state = '%';
 699:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6a0:	e9 27 01 00 00       	jmp    7cc <printf+0x177>
      } else {
        putc(fd, c);
 6a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a8:	0f be c0             	movsbl %al,%eax
 6ab:	83 ec 08             	sub    $0x8,%esp
 6ae:	50                   	push   %eax
 6af:	ff 75 08             	pushl  0x8(%ebp)
 6b2:	e8 c7 fe ff ff       	call   57e <putc>
 6b7:	83 c4 10             	add    $0x10,%esp
 6ba:	e9 0d 01 00 00       	jmp    7cc <printf+0x177>
      }
    } else if(state == '%'){
 6bf:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6c3:	0f 85 03 01 00 00    	jne    7cc <printf+0x177>
      if(c == 'd'){
 6c9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6cd:	75 1e                	jne    6ed <printf+0x98>
        printint(fd, *ap, 10, 1);
 6cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d2:	8b 00                	mov    (%eax),%eax
 6d4:	6a 01                	push   $0x1
 6d6:	6a 0a                	push   $0xa
 6d8:	50                   	push   %eax
 6d9:	ff 75 08             	pushl  0x8(%ebp)
 6dc:	e8 c0 fe ff ff       	call   5a1 <printint>
 6e1:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e8:	e9 d8 00 00 00       	jmp    7c5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6ed:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6f1:	74 06                	je     6f9 <printf+0xa4>
 6f3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6f7:	75 1e                	jne    717 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	6a 00                	push   $0x0
 700:	6a 10                	push   $0x10
 702:	50                   	push   %eax
 703:	ff 75 08             	pushl  0x8(%ebp)
 706:	e8 96 fe ff ff       	call   5a1 <printint>
 70b:	83 c4 10             	add    $0x10,%esp
        ap++;
 70e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 712:	e9 ae 00 00 00       	jmp    7c5 <printf+0x170>
      } else if(c == 's'){
 717:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 71b:	75 43                	jne    760 <printf+0x10b>
        s = (char*)*ap;
 71d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 725:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 72d:	75 25                	jne    754 <printf+0xff>
          s = "(null)";
 72f:	c7 45 f4 60 0a 00 00 	movl   $0xa60,-0xc(%ebp)
        while(*s != 0){
 736:	eb 1c                	jmp    754 <printf+0xff>
          putc(fd, *s);
 738:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73b:	0f b6 00             	movzbl (%eax),%eax
 73e:	0f be c0             	movsbl %al,%eax
 741:	83 ec 08             	sub    $0x8,%esp
 744:	50                   	push   %eax
 745:	ff 75 08             	pushl  0x8(%ebp)
 748:	e8 31 fe ff ff       	call   57e <putc>
 74d:	83 c4 10             	add    $0x10,%esp
          s++;
 750:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 754:	8b 45 f4             	mov    -0xc(%ebp),%eax
 757:	0f b6 00             	movzbl (%eax),%eax
 75a:	84 c0                	test   %al,%al
 75c:	75 da                	jne    738 <printf+0xe3>
 75e:	eb 65                	jmp    7c5 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 760:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 764:	75 1d                	jne    783 <printf+0x12e>
        putc(fd, *ap);
 766:	8b 45 e8             	mov    -0x18(%ebp),%eax
 769:	8b 00                	mov    (%eax),%eax
 76b:	0f be c0             	movsbl %al,%eax
 76e:	83 ec 08             	sub    $0x8,%esp
 771:	50                   	push   %eax
 772:	ff 75 08             	pushl  0x8(%ebp)
 775:	e8 04 fe ff ff       	call   57e <putc>
 77a:	83 c4 10             	add    $0x10,%esp
        ap++;
 77d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 781:	eb 42                	jmp    7c5 <printf+0x170>
      } else if(c == '%'){
 783:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 787:	75 17                	jne    7a0 <printf+0x14b>
        putc(fd, c);
 789:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78c:	0f be c0             	movsbl %al,%eax
 78f:	83 ec 08             	sub    $0x8,%esp
 792:	50                   	push   %eax
 793:	ff 75 08             	pushl  0x8(%ebp)
 796:	e8 e3 fd ff ff       	call   57e <putc>
 79b:	83 c4 10             	add    $0x10,%esp
 79e:	eb 25                	jmp    7c5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a0:	83 ec 08             	sub    $0x8,%esp
 7a3:	6a 25                	push   $0x25
 7a5:	ff 75 08             	pushl  0x8(%ebp)
 7a8:	e8 d1 fd ff ff       	call   57e <putc>
 7ad:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b3:	0f be c0             	movsbl %al,%eax
 7b6:	83 ec 08             	sub    $0x8,%esp
 7b9:	50                   	push   %eax
 7ba:	ff 75 08             	pushl  0x8(%ebp)
 7bd:	e8 bc fd ff ff       	call   57e <putc>
 7c2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7cc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7d0:	8b 55 0c             	mov    0xc(%ebp),%edx
 7d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d6:	01 d0                	add    %edx,%eax
 7d8:	0f b6 00             	movzbl (%eax),%eax
 7db:	84 c0                	test   %al,%al
 7dd:	0f 85 94 fe ff ff    	jne    677 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7e3:	90                   	nop
 7e4:	c9                   	leave  
 7e5:	c3                   	ret    

000007e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e6:	55                   	push   %ebp
 7e7:	89 e5                	mov    %esp,%ebp
 7e9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ec:	8b 45 08             	mov    0x8(%ebp),%eax
 7ef:	83 e8 08             	sub    $0x8,%eax
 7f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f5:	a1 08 0d 00 00       	mov    0xd08,%eax
 7fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7fd:	eb 24                	jmp    823 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	8b 00                	mov    (%eax),%eax
 804:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 807:	77 12                	ja     81b <free+0x35>
 809:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 80f:	77 24                	ja     835 <free+0x4f>
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 00                	mov    (%eax),%eax
 816:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 819:	77 1a                	ja     835 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81e:	8b 00                	mov    (%eax),%eax
 820:	89 45 fc             	mov    %eax,-0x4(%ebp)
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 829:	76 d4                	jbe    7ff <free+0x19>
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 833:	76 ca                	jbe    7ff <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 835:	8b 45 f8             	mov    -0x8(%ebp),%eax
 838:	8b 40 04             	mov    0x4(%eax),%eax
 83b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 842:	8b 45 f8             	mov    -0x8(%ebp),%eax
 845:	01 c2                	add    %eax,%edx
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	8b 00                	mov    (%eax),%eax
 84c:	39 c2                	cmp    %eax,%edx
 84e:	75 24                	jne    874 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 850:	8b 45 f8             	mov    -0x8(%ebp),%eax
 853:	8b 50 04             	mov    0x4(%eax),%edx
 856:	8b 45 fc             	mov    -0x4(%ebp),%eax
 859:	8b 00                	mov    (%eax),%eax
 85b:	8b 40 04             	mov    0x4(%eax),%eax
 85e:	01 c2                	add    %eax,%edx
 860:	8b 45 f8             	mov    -0x8(%ebp),%eax
 863:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 866:	8b 45 fc             	mov    -0x4(%ebp),%eax
 869:	8b 00                	mov    (%eax),%eax
 86b:	8b 10                	mov    (%eax),%edx
 86d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 870:	89 10                	mov    %edx,(%eax)
 872:	eb 0a                	jmp    87e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 874:	8b 45 fc             	mov    -0x4(%ebp),%eax
 877:	8b 10                	mov    (%eax),%edx
 879:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 87e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 881:	8b 40 04             	mov    0x4(%eax),%eax
 884:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 88b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88e:	01 d0                	add    %edx,%eax
 890:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 893:	75 20                	jne    8b5 <free+0xcf>
    p->s.size += bp->s.size;
 895:	8b 45 fc             	mov    -0x4(%ebp),%eax
 898:	8b 50 04             	mov    0x4(%eax),%edx
 89b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89e:	8b 40 04             	mov    0x4(%eax),%eax
 8a1:	01 c2                	add    %eax,%edx
 8a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ac:	8b 10                	mov    (%eax),%edx
 8ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b1:	89 10                	mov    %edx,(%eax)
 8b3:	eb 08                	jmp    8bd <free+0xd7>
  } else
    p->s.ptr = bp;
 8b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8bb:	89 10                	mov    %edx,(%eax)
  freep = p;
 8bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c0:	a3 08 0d 00 00       	mov    %eax,0xd08
}
 8c5:	90                   	nop
 8c6:	c9                   	leave  
 8c7:	c3                   	ret    

000008c8 <morecore>:

static Header*
morecore(uint nu)
{
 8c8:	55                   	push   %ebp
 8c9:	89 e5                	mov    %esp,%ebp
 8cb:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8ce:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8d5:	77 07                	ja     8de <morecore+0x16>
    nu = 4096;
 8d7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8de:	8b 45 08             	mov    0x8(%ebp),%eax
 8e1:	c1 e0 03             	shl    $0x3,%eax
 8e4:	83 ec 0c             	sub    $0xc,%esp
 8e7:	50                   	push   %eax
 8e8:	e8 31 fc ff ff       	call   51e <sbrk>
 8ed:	83 c4 10             	add    $0x10,%esp
 8f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8f3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8f7:	75 07                	jne    900 <morecore+0x38>
    return 0;
 8f9:	b8 00 00 00 00       	mov    $0x0,%eax
 8fe:	eb 26                	jmp    926 <morecore+0x5e>
  hp = (Header*)p;
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 906:	8b 45 f0             	mov    -0x10(%ebp),%eax
 909:	8b 55 08             	mov    0x8(%ebp),%edx
 90c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 90f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 912:	83 c0 08             	add    $0x8,%eax
 915:	83 ec 0c             	sub    $0xc,%esp
 918:	50                   	push   %eax
 919:	e8 c8 fe ff ff       	call   7e6 <free>
 91e:	83 c4 10             	add    $0x10,%esp
  return freep;
 921:	a1 08 0d 00 00       	mov    0xd08,%eax
}
 926:	c9                   	leave  
 927:	c3                   	ret    

00000928 <malloc>:

void*
malloc(uint nbytes)
{
 928:	55                   	push   %ebp
 929:	89 e5                	mov    %esp,%ebp
 92b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 92e:	8b 45 08             	mov    0x8(%ebp),%eax
 931:	83 c0 07             	add    $0x7,%eax
 934:	c1 e8 03             	shr    $0x3,%eax
 937:	83 c0 01             	add    $0x1,%eax
 93a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 93d:	a1 08 0d 00 00       	mov    0xd08,%eax
 942:	89 45 f0             	mov    %eax,-0x10(%ebp)
 945:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 949:	75 23                	jne    96e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 94b:	c7 45 f0 00 0d 00 00 	movl   $0xd00,-0x10(%ebp)
 952:	8b 45 f0             	mov    -0x10(%ebp),%eax
 955:	a3 08 0d 00 00       	mov    %eax,0xd08
 95a:	a1 08 0d 00 00       	mov    0xd08,%eax
 95f:	a3 00 0d 00 00       	mov    %eax,0xd00
    base.s.size = 0;
 964:	c7 05 04 0d 00 00 00 	movl   $0x0,0xd04
 96b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 971:	8b 00                	mov    (%eax),%eax
 973:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 976:	8b 45 f4             	mov    -0xc(%ebp),%eax
 979:	8b 40 04             	mov    0x4(%eax),%eax
 97c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 97f:	72 4d                	jb     9ce <malloc+0xa6>
      if(p->s.size == nunits)
 981:	8b 45 f4             	mov    -0xc(%ebp),%eax
 984:	8b 40 04             	mov    0x4(%eax),%eax
 987:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 98a:	75 0c                	jne    998 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 98c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98f:	8b 10                	mov    (%eax),%edx
 991:	8b 45 f0             	mov    -0x10(%ebp),%eax
 994:	89 10                	mov    %edx,(%eax)
 996:	eb 26                	jmp    9be <malloc+0x96>
      else {
        p->s.size -= nunits;
 998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99b:	8b 40 04             	mov    0x4(%eax),%eax
 99e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9a1:	89 c2                	mov    %eax,%edx
 9a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ac:	8b 40 04             	mov    0x4(%eax),%eax
 9af:	c1 e0 03             	shl    $0x3,%eax
 9b2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9bb:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c1:	a3 08 0d 00 00       	mov    %eax,0xd08
      return (void*)(p + 1);
 9c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c9:	83 c0 08             	add    $0x8,%eax
 9cc:	eb 3b                	jmp    a09 <malloc+0xe1>
    }
    if(p == freep)
 9ce:	a1 08 0d 00 00       	mov    0xd08,%eax
 9d3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9d6:	75 1e                	jne    9f6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9d8:	83 ec 0c             	sub    $0xc,%esp
 9db:	ff 75 ec             	pushl  -0x14(%ebp)
 9de:	e8 e5 fe ff ff       	call   8c8 <morecore>
 9e3:	83 c4 10             	add    $0x10,%esp
 9e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ed:	75 07                	jne    9f6 <malloc+0xce>
        return 0;
 9ef:	b8 00 00 00 00       	mov    $0x0,%eax
 9f4:	eb 13                	jmp    a09 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ff:	8b 00                	mov    (%eax),%eax
 a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a04:	e9 6d ff ff ff       	jmp    976 <malloc+0x4e>
}
 a09:	c9                   	leave  
 a0a:	c3                   	ret    
