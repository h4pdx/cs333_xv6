
_p4test2:     file format elf32-i386


Disassembly of section .text:

00000000 <countForever>:
#define PrioCount 1
#define numChildren 5

void
countForever(int i)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    int j, p, rc;
    unsigned long count = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    j = getpid();
   d:	e8 b5 04 00 00       	call   4c7 <getpid>
  12:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = i%PrioCount;
  15:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    rc = setpriority(j, p);
  1c:	83 ec 08             	sub    $0x8,%esp
  1f:	ff 75 ec             	pushl  -0x14(%ebp)
  22:	ff 75 f0             	pushl  -0x10(%ebp)
  25:	e8 fd 04 00 00       	call   527 <setpriority>
  2a:	83 c4 10             	add    $0x10,%esp
  2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (rc == 0) 
  30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  34:	75 17                	jne    4d <countForever+0x4d>
        printf(1, "%d: start prio %d\n", j, p);
  36:	ff 75 ec             	pushl  -0x14(%ebp)
  39:	ff 75 f0             	pushl  -0x10(%ebp)
  3c:	68 bc 09 00 00       	push   $0x9bc
  41:	6a 01                	push   $0x1
  43:	e8 be 05 00 00       	call   606 <printf>
  48:	83 c4 10             	add    $0x10,%esp
  4b:	eb 1b                	jmp    68 <countForever+0x68>
    else {
        printf(1, "setpriority failed. file %s at %d\n", __FILE__, __LINE__);
  4d:	6a 13                	push   $0x13
  4f:	68 cf 09 00 00       	push   $0x9cf
  54:	68 dc 09 00 00       	push   $0x9dc
  59:	6a 01                	push   $0x1
  5b:	e8 a6 05 00 00       	call   606 <printf>
  60:	83 c4 10             	add    $0x10,%esp
        exit();
  63:	e8 df 03 00 00       	call   447 <exit>
    }

    while (1) {
        count++;
  68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        if ((count & (0x1FFFFFFF)) == 0) {
  6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6f:	25 ff ff ff 1f       	and    $0x1fffffff,%eax
  74:	85 c0                	test   %eax,%eax
  76:	75 f0                	jne    68 <countForever+0x68>
            p = (p+1) % PrioCount;
  78:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
            rc = setpriority(j, p);
  7f:	83 ec 08             	sub    $0x8,%esp
  82:	ff 75 ec             	pushl  -0x14(%ebp)
  85:	ff 75 f0             	pushl  -0x10(%ebp)
  88:	e8 9a 04 00 00       	call   527 <setpriority>
  8d:	83 c4 10             	add    $0x10,%esp
  90:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (rc == 0) 
  93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  97:	75 17                	jne    b0 <countForever+0xb0>
                printf(1, "%d: new prio %d\n", j, p);
  99:	ff 75 ec             	pushl  -0x14(%ebp)
  9c:	ff 75 f0             	pushl  -0x10(%ebp)
  9f:	68 ff 09 00 00       	push   $0x9ff
  a4:	6a 01                	push   $0x1
  a6:	e8 5b 05 00 00       	call   606 <printf>
  ab:	83 c4 10             	add    $0x10,%esp
  ae:	eb b8                	jmp    68 <countForever+0x68>
            else {
                printf(1, "setpriority failed. file %s at %d\n", __FILE__, __LINE__);
  b0:	6a 1f                	push   $0x1f
  b2:	68 cf 09 00 00       	push   $0x9cf
  b7:	68 dc 09 00 00       	push   $0x9dc
  bc:	6a 01                	push   $0x1
  be:	e8 43 05 00 00       	call   606 <printf>
  c3:	83 c4 10             	add    $0x10,%esp
                exit();
  c6:	e8 7c 03 00 00       	call   447 <exit>

000000cb <main>:
    }
}

    int
main(void)
{
  cb:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  cf:	83 e4 f0             	and    $0xfffffff0,%esp
  d2:	ff 71 fc             	pushl  -0x4(%ecx)
  d5:	55                   	push   %ebp
  d6:	89 e5                	mov    %esp,%ebp
  d8:	51                   	push   %ecx
  d9:	83 ec 14             	sub    $0x14,%esp
    int i, rc;

    for (i=0; i<numChildren; i++) {
  dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  e3:	eb 20                	jmp    105 <main+0x3a>
        rc = fork();
  e5:	e8 55 03 00 00       	call   43f <fork>
  ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (!rc) { // child
  ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  f1:	75 0e                	jne    101 <main+0x36>
            countForever(i);
  f3:	83 ec 0c             	sub    $0xc,%esp
  f6:	ff 75 f4             	pushl  -0xc(%ebp)
  f9:	e8 02 ff ff ff       	call   0 <countForever>
  fe:	83 c4 10             	add    $0x10,%esp
    int
main(void)
{
    int i, rc;

    for (i=0; i<numChildren; i++) {
 101:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 105:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
 109:	7e da                	jle    e5 <main+0x1a>
        if (!rc) { // child
            countForever(i);
        }
    }
    // what the heck, let's have the parent waste time as well!
    countForever(1);
 10b:	83 ec 0c             	sub    $0xc,%esp
 10e:	6a 01                	push   $0x1
 110:	e8 eb fe ff ff       	call   0 <countForever>
 115:	83 c4 10             	add    $0x10,%esp
    exit();
 118:	e8 2a 03 00 00       	call   447 <exit>

0000011d <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 11d:	55                   	push   %ebp
 11e:	89 e5                	mov    %esp,%ebp
 120:	57                   	push   %edi
 121:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 122:	8b 4d 08             	mov    0x8(%ebp),%ecx
 125:	8b 55 10             	mov    0x10(%ebp),%edx
 128:	8b 45 0c             	mov    0xc(%ebp),%eax
 12b:	89 cb                	mov    %ecx,%ebx
 12d:	89 df                	mov    %ebx,%edi
 12f:	89 d1                	mov    %edx,%ecx
 131:	fc                   	cld    
 132:	f3 aa                	rep stos %al,%es:(%edi)
 134:	89 ca                	mov    %ecx,%edx
 136:	89 fb                	mov    %edi,%ebx
 138:	89 5d 08             	mov    %ebx,0x8(%ebp)
 13b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 13e:	90                   	nop
 13f:	5b                   	pop    %ebx
 140:	5f                   	pop    %edi
 141:	5d                   	pop    %ebp
 142:	c3                   	ret    

00000143 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
 146:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 14f:	90                   	nop
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	8d 50 01             	lea    0x1(%eax),%edx
 156:	89 55 08             	mov    %edx,0x8(%ebp)
 159:	8b 55 0c             	mov    0xc(%ebp),%edx
 15c:	8d 4a 01             	lea    0x1(%edx),%ecx
 15f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 162:	0f b6 12             	movzbl (%edx),%edx
 165:	88 10                	mov    %dl,(%eax)
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	75 e2                	jne    150 <strcpy+0xd>
    ;
  return os;
 16e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 171:	c9                   	leave  
 172:	c3                   	ret    

00000173 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 173:	55                   	push   %ebp
 174:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 176:	eb 08                	jmp    180 <strcmp+0xd>
    p++, q++;
 178:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 180:	8b 45 08             	mov    0x8(%ebp),%eax
 183:	0f b6 00             	movzbl (%eax),%eax
 186:	84 c0                	test   %al,%al
 188:	74 10                	je     19a <strcmp+0x27>
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 10             	movzbl (%eax),%edx
 190:	8b 45 0c             	mov    0xc(%ebp),%eax
 193:	0f b6 00             	movzbl (%eax),%eax
 196:	38 c2                	cmp    %al,%dl
 198:	74 de                	je     178 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	0f b6 00             	movzbl (%eax),%eax
 1a0:	0f b6 d0             	movzbl %al,%edx
 1a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a6:	0f b6 00             	movzbl (%eax),%eax
 1a9:	0f b6 c0             	movzbl %al,%eax
 1ac:	29 c2                	sub    %eax,%edx
 1ae:	89 d0                	mov    %edx,%eax
}
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret    

000001b2 <strlen>:

uint
strlen(char *s)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1bf:	eb 04                	jmp    1c5 <strlen+0x13>
 1c1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	01 d0                	add    %edx,%eax
 1cd:	0f b6 00             	movzbl (%eax),%eax
 1d0:	84 c0                	test   %al,%al
 1d2:	75 ed                	jne    1c1 <strlen+0xf>
    ;
  return n;
 1d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d7:	c9                   	leave  
 1d8:	c3                   	ret    

000001d9 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1dc:	8b 45 10             	mov    0x10(%ebp),%eax
 1df:	50                   	push   %eax
 1e0:	ff 75 0c             	pushl  0xc(%ebp)
 1e3:	ff 75 08             	pushl  0x8(%ebp)
 1e6:	e8 32 ff ff ff       	call   11d <stosb>
 1eb:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f1:	c9                   	leave  
 1f2:	c3                   	ret    

000001f3 <strchr>:

char*
strchr(const char *s, char c)
{
 1f3:	55                   	push   %ebp
 1f4:	89 e5                	mov    %esp,%ebp
 1f6:	83 ec 04             	sub    $0x4,%esp
 1f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1ff:	eb 14                	jmp    215 <strchr+0x22>
    if(*s == c)
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	0f b6 00             	movzbl (%eax),%eax
 207:	3a 45 fc             	cmp    -0x4(%ebp),%al
 20a:	75 05                	jne    211 <strchr+0x1e>
      return (char*)s;
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	eb 13                	jmp    224 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 211:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	0f b6 00             	movzbl (%eax),%eax
 21b:	84 c0                	test   %al,%al
 21d:	75 e2                	jne    201 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 21f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 224:	c9                   	leave  
 225:	c3                   	ret    

00000226 <gets>:

char*
gets(char *buf, int max)
{
 226:	55                   	push   %ebp
 227:	89 e5                	mov    %esp,%ebp
 229:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 233:	eb 42                	jmp    277 <gets+0x51>
    cc = read(0, &c, 1);
 235:	83 ec 04             	sub    $0x4,%esp
 238:	6a 01                	push   $0x1
 23a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23d:	50                   	push   %eax
 23e:	6a 00                	push   $0x0
 240:	e8 1a 02 00 00       	call   45f <read>
 245:	83 c4 10             	add    $0x10,%esp
 248:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24f:	7e 33                	jle    284 <gets+0x5e>
      break;
    buf[i++] = c;
 251:	8b 45 f4             	mov    -0xc(%ebp),%eax
 254:	8d 50 01             	lea    0x1(%eax),%edx
 257:	89 55 f4             	mov    %edx,-0xc(%ebp)
 25a:	89 c2                	mov    %eax,%edx
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	01 c2                	add    %eax,%edx
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 267:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26b:	3c 0a                	cmp    $0xa,%al
 26d:	74 16                	je     285 <gets+0x5f>
 26f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 273:	3c 0d                	cmp    $0xd,%al
 275:	74 0e                	je     285 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 277:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27a:	83 c0 01             	add    $0x1,%eax
 27d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 280:	7c b3                	jl     235 <gets+0xf>
 282:	eb 01                	jmp    285 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 284:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 285:	8b 55 f4             	mov    -0xc(%ebp),%edx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	01 d0                	add    %edx,%eax
 28d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 290:	8b 45 08             	mov    0x8(%ebp),%eax
}
 293:	c9                   	leave  
 294:	c3                   	ret    

00000295 <stat>:

int
stat(char *n, struct stat *st)
{
 295:	55                   	push   %ebp
 296:	89 e5                	mov    %esp,%ebp
 298:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29b:	83 ec 08             	sub    $0x8,%esp
 29e:	6a 00                	push   $0x0
 2a0:	ff 75 08             	pushl  0x8(%ebp)
 2a3:	e8 df 01 00 00       	call   487 <open>
 2a8:	83 c4 10             	add    $0x10,%esp
 2ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b2:	79 07                	jns    2bb <stat+0x26>
    return -1;
 2b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b9:	eb 25                	jmp    2e0 <stat+0x4b>
  r = fstat(fd, st);
 2bb:	83 ec 08             	sub    $0x8,%esp
 2be:	ff 75 0c             	pushl  0xc(%ebp)
 2c1:	ff 75 f4             	pushl  -0xc(%ebp)
 2c4:	e8 d6 01 00 00       	call   49f <fstat>
 2c9:	83 c4 10             	add    $0x10,%esp
 2cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2cf:	83 ec 0c             	sub    $0xc,%esp
 2d2:	ff 75 f4             	pushl  -0xc(%ebp)
 2d5:	e8 95 01 00 00       	call   46f <close>
 2da:	83 c4 10             	add    $0x10,%esp
  return r;
 2dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <atoi>:

int
atoi(const char *s)
{
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2ef:	eb 04                	jmp    2f5 <atoi+0x13>
 2f1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
 2f8:	0f b6 00             	movzbl (%eax),%eax
 2fb:	3c 20                	cmp    $0x20,%al
 2fd:	74 f2                	je     2f1 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	0f b6 00             	movzbl (%eax),%eax
 305:	3c 2d                	cmp    $0x2d,%al
 307:	75 07                	jne    310 <atoi+0x2e>
 309:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 30e:	eb 05                	jmp    315 <atoi+0x33>
 310:	b8 01 00 00 00       	mov    $0x1,%eax
 315:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 318:	8b 45 08             	mov    0x8(%ebp),%eax
 31b:	0f b6 00             	movzbl (%eax),%eax
 31e:	3c 2b                	cmp    $0x2b,%al
 320:	74 0a                	je     32c <atoi+0x4a>
 322:	8b 45 08             	mov    0x8(%ebp),%eax
 325:	0f b6 00             	movzbl (%eax),%eax
 328:	3c 2d                	cmp    $0x2d,%al
 32a:	75 2b                	jne    357 <atoi+0x75>
    s++;
 32c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 330:	eb 25                	jmp    357 <atoi+0x75>
    n = n*10 + *s++ - '0';
 332:	8b 55 fc             	mov    -0x4(%ebp),%edx
 335:	89 d0                	mov    %edx,%eax
 337:	c1 e0 02             	shl    $0x2,%eax
 33a:	01 d0                	add    %edx,%eax
 33c:	01 c0                	add    %eax,%eax
 33e:	89 c1                	mov    %eax,%ecx
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	8d 50 01             	lea    0x1(%eax),%edx
 346:	89 55 08             	mov    %edx,0x8(%ebp)
 349:	0f b6 00             	movzbl (%eax),%eax
 34c:	0f be c0             	movsbl %al,%eax
 34f:	01 c8                	add    %ecx,%eax
 351:	83 e8 30             	sub    $0x30,%eax
 354:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	0f b6 00             	movzbl (%eax),%eax
 35d:	3c 2f                	cmp    $0x2f,%al
 35f:	7e 0a                	jle    36b <atoi+0x89>
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	0f b6 00             	movzbl (%eax),%eax
 367:	3c 39                	cmp    $0x39,%al
 369:	7e c7                	jle    332 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 36b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 36e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 372:	c9                   	leave  
 373:	c3                   	ret    

00000374 <atoo>:

int
atoo(const char *s)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 37a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 381:	eb 04                	jmp    387 <atoo+0x13>
 383:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	0f b6 00             	movzbl (%eax),%eax
 38d:	3c 20                	cmp    $0x20,%al
 38f:	74 f2                	je     383 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 391:	8b 45 08             	mov    0x8(%ebp),%eax
 394:	0f b6 00             	movzbl (%eax),%eax
 397:	3c 2d                	cmp    $0x2d,%al
 399:	75 07                	jne    3a2 <atoo+0x2e>
 39b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3a0:	eb 05                	jmp    3a7 <atoo+0x33>
 3a2:	b8 01 00 00 00       	mov    $0x1,%eax
 3a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3aa:	8b 45 08             	mov    0x8(%ebp),%eax
 3ad:	0f b6 00             	movzbl (%eax),%eax
 3b0:	3c 2b                	cmp    $0x2b,%al
 3b2:	74 0a                	je     3be <atoo+0x4a>
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	0f b6 00             	movzbl (%eax),%eax
 3ba:	3c 2d                	cmp    $0x2d,%al
 3bc:	75 27                	jne    3e5 <atoo+0x71>
    s++;
 3be:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3c2:	eb 21                	jmp    3e5 <atoo+0x71>
    n = n*8 + *s++ - '0';
 3c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3c7:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3ce:	8b 45 08             	mov    0x8(%ebp),%eax
 3d1:	8d 50 01             	lea    0x1(%eax),%edx
 3d4:	89 55 08             	mov    %edx,0x8(%ebp)
 3d7:	0f b6 00             	movzbl (%eax),%eax
 3da:	0f be c0             	movsbl %al,%eax
 3dd:	01 c8                	add    %ecx,%eax
 3df:	83 e8 30             	sub    $0x30,%eax
 3e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
 3e8:	0f b6 00             	movzbl (%eax),%eax
 3eb:	3c 2f                	cmp    $0x2f,%al
 3ed:	7e 0a                	jle    3f9 <atoo+0x85>
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
 3f2:	0f b6 00             	movzbl (%eax),%eax
 3f5:	3c 37                	cmp    $0x37,%al
 3f7:	7e cb                	jle    3c4 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3fc:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 400:	c9                   	leave  
 401:	c3                   	ret    

00000402 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
 405:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 40e:	8b 45 0c             	mov    0xc(%ebp),%eax
 411:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 414:	eb 17                	jmp    42d <memmove+0x2b>
    *dst++ = *src++;
 416:	8b 45 fc             	mov    -0x4(%ebp),%eax
 419:	8d 50 01             	lea    0x1(%eax),%edx
 41c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 41f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 422:	8d 4a 01             	lea    0x1(%edx),%ecx
 425:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 428:	0f b6 12             	movzbl (%edx),%edx
 42b:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 42d:	8b 45 10             	mov    0x10(%ebp),%eax
 430:	8d 50 ff             	lea    -0x1(%eax),%edx
 433:	89 55 10             	mov    %edx,0x10(%ebp)
 436:	85 c0                	test   %eax,%eax
 438:	7f dc                	jg     416 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 43a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 43f:	b8 01 00 00 00       	mov    $0x1,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <exit>:
SYSCALL(exit)
 447:	b8 02 00 00 00       	mov    $0x2,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <wait>:
SYSCALL(wait)
 44f:	b8 03 00 00 00       	mov    $0x3,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <pipe>:
SYSCALL(pipe)
 457:	b8 04 00 00 00       	mov    $0x4,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <read>:
SYSCALL(read)
 45f:	b8 05 00 00 00       	mov    $0x5,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <write>:
SYSCALL(write)
 467:	b8 10 00 00 00       	mov    $0x10,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <close>:
SYSCALL(close)
 46f:	b8 15 00 00 00       	mov    $0x15,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <kill>:
SYSCALL(kill)
 477:	b8 06 00 00 00       	mov    $0x6,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <exec>:
SYSCALL(exec)
 47f:	b8 07 00 00 00       	mov    $0x7,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <open>:
SYSCALL(open)
 487:	b8 0f 00 00 00       	mov    $0xf,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <mknod>:
SYSCALL(mknod)
 48f:	b8 11 00 00 00       	mov    $0x11,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <unlink>:
SYSCALL(unlink)
 497:	b8 12 00 00 00       	mov    $0x12,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <fstat>:
SYSCALL(fstat)
 49f:	b8 08 00 00 00       	mov    $0x8,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <link>:
SYSCALL(link)
 4a7:	b8 13 00 00 00       	mov    $0x13,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <mkdir>:
SYSCALL(mkdir)
 4af:	b8 14 00 00 00       	mov    $0x14,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <chdir>:
SYSCALL(chdir)
 4b7:	b8 09 00 00 00       	mov    $0x9,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <dup>:
SYSCALL(dup)
 4bf:	b8 0a 00 00 00       	mov    $0xa,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <getpid>:
SYSCALL(getpid)
 4c7:	b8 0b 00 00 00       	mov    $0xb,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <sbrk>:
SYSCALL(sbrk)
 4cf:	b8 0c 00 00 00       	mov    $0xc,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <sleep>:
SYSCALL(sleep)
 4d7:	b8 0d 00 00 00       	mov    $0xd,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <uptime>:
SYSCALL(uptime)
 4df:	b8 0e 00 00 00       	mov    $0xe,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <halt>:
SYSCALL(halt)
 4e7:	b8 16 00 00 00       	mov    $0x16,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <date>:
SYSCALL(date)
 4ef:	b8 17 00 00 00       	mov    $0x17,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <getuid>:
SYSCALL(getuid)
 4f7:	b8 18 00 00 00       	mov    $0x18,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <getgid>:
SYSCALL(getgid)
 4ff:	b8 19 00 00 00       	mov    $0x19,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <getppid>:
SYSCALL(getppid)
 507:	b8 1a 00 00 00       	mov    $0x1a,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <setuid>:
SYSCALL(setuid)
 50f:	b8 1b 00 00 00       	mov    $0x1b,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <setgid>:
SYSCALL(setgid)
 517:	b8 1c 00 00 00       	mov    $0x1c,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <getprocs>:
SYSCALL(getprocs)
 51f:	b8 1d 00 00 00       	mov    $0x1d,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <setpriority>:
SYSCALL(setpriority)
 527:	b8 1e 00 00 00       	mov    $0x1e,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 52f:	55                   	push   %ebp
 530:	89 e5                	mov    %esp,%ebp
 532:	83 ec 18             	sub    $0x18,%esp
 535:	8b 45 0c             	mov    0xc(%ebp),%eax
 538:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 53b:	83 ec 04             	sub    $0x4,%esp
 53e:	6a 01                	push   $0x1
 540:	8d 45 f4             	lea    -0xc(%ebp),%eax
 543:	50                   	push   %eax
 544:	ff 75 08             	pushl  0x8(%ebp)
 547:	e8 1b ff ff ff       	call   467 <write>
 54c:	83 c4 10             	add    $0x10,%esp
}
 54f:	90                   	nop
 550:	c9                   	leave  
 551:	c3                   	ret    

00000552 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 552:	55                   	push   %ebp
 553:	89 e5                	mov    %esp,%ebp
 555:	53                   	push   %ebx
 556:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 559:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 560:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 564:	74 17                	je     57d <printint+0x2b>
 566:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 56a:	79 11                	jns    57d <printint+0x2b>
    neg = 1;
 56c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 573:	8b 45 0c             	mov    0xc(%ebp),%eax
 576:	f7 d8                	neg    %eax
 578:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57b:	eb 06                	jmp    583 <printint+0x31>
  } else {
    x = xx;
 57d:	8b 45 0c             	mov    0xc(%ebp),%eax
 580:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 58a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 58d:	8d 41 01             	lea    0x1(%ecx),%eax
 590:	89 45 f4             	mov    %eax,-0xc(%ebp)
 593:	8b 5d 10             	mov    0x10(%ebp),%ebx
 596:	8b 45 ec             	mov    -0x14(%ebp),%eax
 599:	ba 00 00 00 00       	mov    $0x0,%edx
 59e:	f7 f3                	div    %ebx
 5a0:	89 d0                	mov    %edx,%eax
 5a2:	0f b6 80 9c 0c 00 00 	movzbl 0xc9c(%eax),%eax
 5a9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b3:	ba 00 00 00 00       	mov    $0x0,%edx
 5b8:	f7 f3                	div    %ebx
 5ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c1:	75 c7                	jne    58a <printint+0x38>
  if(neg)
 5c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5c7:	74 2d                	je     5f6 <printint+0xa4>
    buf[i++] = '-';
 5c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cc:	8d 50 01             	lea    0x1(%eax),%edx
 5cf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5d2:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5d7:	eb 1d                	jmp    5f6 <printint+0xa4>
    putc(fd, buf[i]);
 5d9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5df:	01 d0                	add    %edx,%eax
 5e1:	0f b6 00             	movzbl (%eax),%eax
 5e4:	0f be c0             	movsbl %al,%eax
 5e7:	83 ec 08             	sub    $0x8,%esp
 5ea:	50                   	push   %eax
 5eb:	ff 75 08             	pushl  0x8(%ebp)
 5ee:	e8 3c ff ff ff       	call   52f <putc>
 5f3:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5f6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5fe:	79 d9                	jns    5d9 <printint+0x87>
    putc(fd, buf[i]);
}
 600:	90                   	nop
 601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 604:	c9                   	leave  
 605:	c3                   	ret    

00000606 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 606:	55                   	push   %ebp
 607:	89 e5                	mov    %esp,%ebp
 609:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 60c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 613:	8d 45 0c             	lea    0xc(%ebp),%eax
 616:	83 c0 04             	add    $0x4,%eax
 619:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 61c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 623:	e9 59 01 00 00       	jmp    781 <printf+0x17b>
    c = fmt[i] & 0xff;
 628:	8b 55 0c             	mov    0xc(%ebp),%edx
 62b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62e:	01 d0                	add    %edx,%eax
 630:	0f b6 00             	movzbl (%eax),%eax
 633:	0f be c0             	movsbl %al,%eax
 636:	25 ff 00 00 00       	and    $0xff,%eax
 63b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 63e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 642:	75 2c                	jne    670 <printf+0x6a>
      if(c == '%'){
 644:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 648:	75 0c                	jne    656 <printf+0x50>
        state = '%';
 64a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 651:	e9 27 01 00 00       	jmp    77d <printf+0x177>
      } else {
        putc(fd, c);
 656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 659:	0f be c0             	movsbl %al,%eax
 65c:	83 ec 08             	sub    $0x8,%esp
 65f:	50                   	push   %eax
 660:	ff 75 08             	pushl  0x8(%ebp)
 663:	e8 c7 fe ff ff       	call   52f <putc>
 668:	83 c4 10             	add    $0x10,%esp
 66b:	e9 0d 01 00 00       	jmp    77d <printf+0x177>
      }
    } else if(state == '%'){
 670:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 674:	0f 85 03 01 00 00    	jne    77d <printf+0x177>
      if(c == 'd'){
 67a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 67e:	75 1e                	jne    69e <printf+0x98>
        printint(fd, *ap, 10, 1);
 680:	8b 45 e8             	mov    -0x18(%ebp),%eax
 683:	8b 00                	mov    (%eax),%eax
 685:	6a 01                	push   $0x1
 687:	6a 0a                	push   $0xa
 689:	50                   	push   %eax
 68a:	ff 75 08             	pushl  0x8(%ebp)
 68d:	e8 c0 fe ff ff       	call   552 <printint>
 692:	83 c4 10             	add    $0x10,%esp
        ap++;
 695:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 699:	e9 d8 00 00 00       	jmp    776 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 69e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6a2:	74 06                	je     6aa <printf+0xa4>
 6a4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6a8:	75 1e                	jne    6c8 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ad:	8b 00                	mov    (%eax),%eax
 6af:	6a 00                	push   $0x0
 6b1:	6a 10                	push   $0x10
 6b3:	50                   	push   %eax
 6b4:	ff 75 08             	pushl  0x8(%ebp)
 6b7:	e8 96 fe ff ff       	call   552 <printint>
 6bc:	83 c4 10             	add    $0x10,%esp
        ap++;
 6bf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c3:	e9 ae 00 00 00       	jmp    776 <printf+0x170>
      } else if(c == 's'){
 6c8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6cc:	75 43                	jne    711 <printf+0x10b>
        s = (char*)*ap;
 6ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d1:	8b 00                	mov    (%eax),%eax
 6d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6de:	75 25                	jne    705 <printf+0xff>
          s = "(null)";
 6e0:	c7 45 f4 10 0a 00 00 	movl   $0xa10,-0xc(%ebp)
        while(*s != 0){
 6e7:	eb 1c                	jmp    705 <printf+0xff>
          putc(fd, *s);
 6e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ec:	0f b6 00             	movzbl (%eax),%eax
 6ef:	0f be c0             	movsbl %al,%eax
 6f2:	83 ec 08             	sub    $0x8,%esp
 6f5:	50                   	push   %eax
 6f6:	ff 75 08             	pushl  0x8(%ebp)
 6f9:	e8 31 fe ff ff       	call   52f <putc>
 6fe:	83 c4 10             	add    $0x10,%esp
          s++;
 701:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 705:	8b 45 f4             	mov    -0xc(%ebp),%eax
 708:	0f b6 00             	movzbl (%eax),%eax
 70b:	84 c0                	test   %al,%al
 70d:	75 da                	jne    6e9 <printf+0xe3>
 70f:	eb 65                	jmp    776 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 711:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 715:	75 1d                	jne    734 <printf+0x12e>
        putc(fd, *ap);
 717:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71a:	8b 00                	mov    (%eax),%eax
 71c:	0f be c0             	movsbl %al,%eax
 71f:	83 ec 08             	sub    $0x8,%esp
 722:	50                   	push   %eax
 723:	ff 75 08             	pushl  0x8(%ebp)
 726:	e8 04 fe ff ff       	call   52f <putc>
 72b:	83 c4 10             	add    $0x10,%esp
        ap++;
 72e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 732:	eb 42                	jmp    776 <printf+0x170>
      } else if(c == '%'){
 734:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 738:	75 17                	jne    751 <printf+0x14b>
        putc(fd, c);
 73a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 73d:	0f be c0             	movsbl %al,%eax
 740:	83 ec 08             	sub    $0x8,%esp
 743:	50                   	push   %eax
 744:	ff 75 08             	pushl  0x8(%ebp)
 747:	e8 e3 fd ff ff       	call   52f <putc>
 74c:	83 c4 10             	add    $0x10,%esp
 74f:	eb 25                	jmp    776 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 751:	83 ec 08             	sub    $0x8,%esp
 754:	6a 25                	push   $0x25
 756:	ff 75 08             	pushl  0x8(%ebp)
 759:	e8 d1 fd ff ff       	call   52f <putc>
 75e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 761:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 764:	0f be c0             	movsbl %al,%eax
 767:	83 ec 08             	sub    $0x8,%esp
 76a:	50                   	push   %eax
 76b:	ff 75 08             	pushl  0x8(%ebp)
 76e:	e8 bc fd ff ff       	call   52f <putc>
 773:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 776:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 77d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 781:	8b 55 0c             	mov    0xc(%ebp),%edx
 784:	8b 45 f0             	mov    -0x10(%ebp),%eax
 787:	01 d0                	add    %edx,%eax
 789:	0f b6 00             	movzbl (%eax),%eax
 78c:	84 c0                	test   %al,%al
 78e:	0f 85 94 fe ff ff    	jne    628 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 794:	90                   	nop
 795:	c9                   	leave  
 796:	c3                   	ret    

00000797 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 797:	55                   	push   %ebp
 798:	89 e5                	mov    %esp,%ebp
 79a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79d:	8b 45 08             	mov    0x8(%ebp),%eax
 7a0:	83 e8 08             	sub    $0x8,%eax
 7a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a6:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 7ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ae:	eb 24                	jmp    7d4 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b3:	8b 00                	mov    (%eax),%eax
 7b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b8:	77 12                	ja     7cc <free+0x35>
 7ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c0:	77 24                	ja     7e6 <free+0x4f>
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	8b 00                	mov    (%eax),%eax
 7c7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ca:	77 1a                	ja     7e6 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 00                	mov    (%eax),%eax
 7d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7da:	76 d4                	jbe    7b0 <free+0x19>
 7dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7df:	8b 00                	mov    (%eax),%eax
 7e1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e4:	76 ca                	jbe    7b0 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e9:	8b 40 04             	mov    0x4(%eax),%eax
 7ec:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f6:	01 c2                	add    %eax,%edx
 7f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fb:	8b 00                	mov    (%eax),%eax
 7fd:	39 c2                	cmp    %eax,%edx
 7ff:	75 24                	jne    825 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 801:	8b 45 f8             	mov    -0x8(%ebp),%eax
 804:	8b 50 04             	mov    0x4(%eax),%edx
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	8b 00                	mov    (%eax),%eax
 80c:	8b 40 04             	mov    0x4(%eax),%eax
 80f:	01 c2                	add    %eax,%edx
 811:	8b 45 f8             	mov    -0x8(%ebp),%eax
 814:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 817:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81a:	8b 00                	mov    (%eax),%eax
 81c:	8b 10                	mov    (%eax),%edx
 81e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 821:	89 10                	mov    %edx,(%eax)
 823:	eb 0a                	jmp    82f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 825:	8b 45 fc             	mov    -0x4(%ebp),%eax
 828:	8b 10                	mov    (%eax),%edx
 82a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	8b 40 04             	mov    0x4(%eax),%eax
 835:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 83c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83f:	01 d0                	add    %edx,%eax
 841:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 844:	75 20                	jne    866 <free+0xcf>
    p->s.size += bp->s.size;
 846:	8b 45 fc             	mov    -0x4(%ebp),%eax
 849:	8b 50 04             	mov    0x4(%eax),%edx
 84c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84f:	8b 40 04             	mov    0x4(%eax),%eax
 852:	01 c2                	add    %eax,%edx
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 85a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85d:	8b 10                	mov    (%eax),%edx
 85f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 862:	89 10                	mov    %edx,(%eax)
 864:	eb 08                	jmp    86e <free+0xd7>
  } else
    p->s.ptr = bp;
 866:	8b 45 fc             	mov    -0x4(%ebp),%eax
 869:	8b 55 f8             	mov    -0x8(%ebp),%edx
 86c:	89 10                	mov    %edx,(%eax)
  freep = p;
 86e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 871:	a3 b8 0c 00 00       	mov    %eax,0xcb8
}
 876:	90                   	nop
 877:	c9                   	leave  
 878:	c3                   	ret    

00000879 <morecore>:

static Header*
morecore(uint nu)
{
 879:	55                   	push   %ebp
 87a:	89 e5                	mov    %esp,%ebp
 87c:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 87f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 886:	77 07                	ja     88f <morecore+0x16>
    nu = 4096;
 888:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 88f:	8b 45 08             	mov    0x8(%ebp),%eax
 892:	c1 e0 03             	shl    $0x3,%eax
 895:	83 ec 0c             	sub    $0xc,%esp
 898:	50                   	push   %eax
 899:	e8 31 fc ff ff       	call   4cf <sbrk>
 89e:	83 c4 10             	add    $0x10,%esp
 8a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8a4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8a8:	75 07                	jne    8b1 <morecore+0x38>
    return 0;
 8aa:	b8 00 00 00 00       	mov    $0x0,%eax
 8af:	eb 26                	jmp    8d7 <morecore+0x5e>
  hp = (Header*)p;
 8b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ba:	8b 55 08             	mov    0x8(%ebp),%edx
 8bd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c3:	83 c0 08             	add    $0x8,%eax
 8c6:	83 ec 0c             	sub    $0xc,%esp
 8c9:	50                   	push   %eax
 8ca:	e8 c8 fe ff ff       	call   797 <free>
 8cf:	83 c4 10             	add    $0x10,%esp
  return freep;
 8d2:	a1 b8 0c 00 00       	mov    0xcb8,%eax
}
 8d7:	c9                   	leave  
 8d8:	c3                   	ret    

000008d9 <malloc>:

void*
malloc(uint nbytes)
{
 8d9:	55                   	push   %ebp
 8da:	89 e5                	mov    %esp,%ebp
 8dc:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8df:	8b 45 08             	mov    0x8(%ebp),%eax
 8e2:	83 c0 07             	add    $0x7,%eax
 8e5:	c1 e8 03             	shr    $0x3,%eax
 8e8:	83 c0 01             	add    $0x1,%eax
 8eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8ee:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 8f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8fa:	75 23                	jne    91f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8fc:	c7 45 f0 b0 0c 00 00 	movl   $0xcb0,-0x10(%ebp)
 903:	8b 45 f0             	mov    -0x10(%ebp),%eax
 906:	a3 b8 0c 00 00       	mov    %eax,0xcb8
 90b:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 910:	a3 b0 0c 00 00       	mov    %eax,0xcb0
    base.s.size = 0;
 915:	c7 05 b4 0c 00 00 00 	movl   $0x0,0xcb4
 91c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 922:	8b 00                	mov    (%eax),%eax
 924:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 927:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92a:	8b 40 04             	mov    0x4(%eax),%eax
 92d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 930:	72 4d                	jb     97f <malloc+0xa6>
      if(p->s.size == nunits)
 932:	8b 45 f4             	mov    -0xc(%ebp),%eax
 935:	8b 40 04             	mov    0x4(%eax),%eax
 938:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93b:	75 0c                	jne    949 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 93d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 940:	8b 10                	mov    (%eax),%edx
 942:	8b 45 f0             	mov    -0x10(%ebp),%eax
 945:	89 10                	mov    %edx,(%eax)
 947:	eb 26                	jmp    96f <malloc+0x96>
      else {
        p->s.size -= nunits;
 949:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94c:	8b 40 04             	mov    0x4(%eax),%eax
 94f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 952:	89 c2                	mov    %eax,%edx
 954:	8b 45 f4             	mov    -0xc(%ebp),%eax
 957:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 95a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95d:	8b 40 04             	mov    0x4(%eax),%eax
 960:	c1 e0 03             	shl    $0x3,%eax
 963:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 966:	8b 45 f4             	mov    -0xc(%ebp),%eax
 969:	8b 55 ec             	mov    -0x14(%ebp),%edx
 96c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 96f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 972:	a3 b8 0c 00 00       	mov    %eax,0xcb8
      return (void*)(p + 1);
 977:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97a:	83 c0 08             	add    $0x8,%eax
 97d:	eb 3b                	jmp    9ba <malloc+0xe1>
    }
    if(p == freep)
 97f:	a1 b8 0c 00 00       	mov    0xcb8,%eax
 984:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 987:	75 1e                	jne    9a7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 989:	83 ec 0c             	sub    $0xc,%esp
 98c:	ff 75 ec             	pushl  -0x14(%ebp)
 98f:	e8 e5 fe ff ff       	call   879 <morecore>
 994:	83 c4 10             	add    $0x10,%esp
 997:	89 45 f4             	mov    %eax,-0xc(%ebp)
 99a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 99e:	75 07                	jne    9a7 <malloc+0xce>
        return 0;
 9a0:	b8 00 00 00 00       	mov    $0x0,%eax
 9a5:	eb 13                	jmp    9ba <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b0:	8b 00                	mov    (%eax),%eax
 9b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9b5:	e9 6d ff ff ff       	jmp    927 <malloc+0x4e>
}
 9ba:	c9                   	leave  
 9bb:	c3                   	ret    
