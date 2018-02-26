
_tspin:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "param.h"

int
main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
    int i = 0, j;
  11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (i < 5) {
  18:	eb 27                	jmp    41 <main+0x41>
        j = fork();
  1a:	e8 5f 03 00 00       	call   37e <fork>
  1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        setpriority(getpid(), MAX);
  22:	e8 df 03 00 00       	call   406 <getpid>
  27:	83 ec 08             	sub    $0x8,%esp
  2a:	6a 02                	push   $0x2
  2c:	50                   	push   %eax
  2d:	e8 34 04 00 00       	call   466 <setpriority>
  32:	83 c4 10             	add    $0x10,%esp
        if (!j) {
  35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  39:	75 02                	jne    3d <main+0x3d>
            for(;;);
  3b:	eb fe                	jmp    3b <main+0x3b>
        }
        ++i;
  3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
#include "param.h"

int
main(void) {
    int i = 0, j;
    while (i < 5) {
  41:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
  45:	7e d3                	jle    1a <main+0x1a>
        if (!j) {
            for(;;);
        }
        ++i;
    }
    setpriority(getpid(), MAX);
  47:	e8 ba 03 00 00       	call   406 <getpid>
  4c:	83 ec 08             	sub    $0x8,%esp
  4f:	6a 02                	push   $0x2
  51:	50                   	push   %eax
  52:	e8 0f 04 00 00       	call   466 <setpriority>
  57:	83 c4 10             	add    $0x10,%esp
    for(;;);
  5a:	eb fe                	jmp    5a <main+0x5a>

0000005c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	57                   	push   %edi
  60:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  64:	8b 55 10             	mov    0x10(%ebp),%edx
  67:	8b 45 0c             	mov    0xc(%ebp),%eax
  6a:	89 cb                	mov    %ecx,%ebx
  6c:	89 df                	mov    %ebx,%edi
  6e:	89 d1                	mov    %edx,%ecx
  70:	fc                   	cld    
  71:	f3 aa                	rep stos %al,%es:(%edi)
  73:	89 ca                	mov    %ecx,%edx
  75:	89 fb                	mov    %edi,%ebx
  77:	89 5d 08             	mov    %ebx,0x8(%ebp)
  7a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  7d:	90                   	nop
  7e:	5b                   	pop    %ebx
  7f:	5f                   	pop    %edi
  80:	5d                   	pop    %ebp
  81:	c3                   	ret    

00000082 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  85:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  88:	8b 45 08             	mov    0x8(%ebp),%eax
  8b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  8e:	90                   	nop
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	8d 50 01             	lea    0x1(%eax),%edx
  95:	89 55 08             	mov    %edx,0x8(%ebp)
  98:	8b 55 0c             	mov    0xc(%ebp),%edx
  9b:	8d 4a 01             	lea    0x1(%edx),%ecx
  9e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  a1:	0f b6 12             	movzbl (%edx),%edx
  a4:	88 10                	mov    %dl,(%eax)
  a6:	0f b6 00             	movzbl (%eax),%eax
  a9:	84 c0                	test   %al,%al
  ab:	75 e2                	jne    8f <strcpy+0xd>
    ;
  return os;
  ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b0:	c9                   	leave  
  b1:	c3                   	ret    

000000b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b2:	55                   	push   %ebp
  b3:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  b5:	eb 08                	jmp    bf <strcmp+0xd>
    p++, q++;
  b7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  bb:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  bf:	8b 45 08             	mov    0x8(%ebp),%eax
  c2:	0f b6 00             	movzbl (%eax),%eax
  c5:	84 c0                	test   %al,%al
  c7:	74 10                	je     d9 <strcmp+0x27>
  c9:	8b 45 08             	mov    0x8(%ebp),%eax
  cc:	0f b6 10             	movzbl (%eax),%edx
  cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  d2:	0f b6 00             	movzbl (%eax),%eax
  d5:	38 c2                	cmp    %al,%dl
  d7:	74 de                	je     b7 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  d9:	8b 45 08             	mov    0x8(%ebp),%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	0f b6 d0             	movzbl %al,%edx
  e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	0f b6 c0             	movzbl %al,%eax
  eb:	29 c2                	sub    %eax,%edx
  ed:	89 d0                	mov    %edx,%eax
}
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    

000000f1 <strlen>:

uint
strlen(char *s)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  fe:	eb 04                	jmp    104 <strlen+0x13>
 100:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 104:	8b 55 fc             	mov    -0x4(%ebp),%edx
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	01 d0                	add    %edx,%eax
 10c:	0f b6 00             	movzbl (%eax),%eax
 10f:	84 c0                	test   %al,%al
 111:	75 ed                	jne    100 <strlen+0xf>
    ;
  return n;
 113:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 116:	c9                   	leave  
 117:	c3                   	ret    

00000118 <memset>:

void*
memset(void *dst, int c, uint n)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 11b:	8b 45 10             	mov    0x10(%ebp),%eax
 11e:	50                   	push   %eax
 11f:	ff 75 0c             	pushl  0xc(%ebp)
 122:	ff 75 08             	pushl  0x8(%ebp)
 125:	e8 32 ff ff ff       	call   5c <stosb>
 12a:	83 c4 0c             	add    $0xc,%esp
  return dst;
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 130:	c9                   	leave  
 131:	c3                   	ret    

00000132 <strchr>:

char*
strchr(const char *s, char c)
{
 132:	55                   	push   %ebp
 133:	89 e5                	mov    %esp,%ebp
 135:	83 ec 04             	sub    $0x4,%esp
 138:	8b 45 0c             	mov    0xc(%ebp),%eax
 13b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 13e:	eb 14                	jmp    154 <strchr+0x22>
    if(*s == c)
 140:	8b 45 08             	mov    0x8(%ebp),%eax
 143:	0f b6 00             	movzbl (%eax),%eax
 146:	3a 45 fc             	cmp    -0x4(%ebp),%al
 149:	75 05                	jne    150 <strchr+0x1e>
      return (char*)s;
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	eb 13                	jmp    163 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 150:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	84 c0                	test   %al,%al
 15c:	75 e2                	jne    140 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 15e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <gets>:

char*
gets(char *buf, int max)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 172:	eb 42                	jmp    1b6 <gets+0x51>
    cc = read(0, &c, 1);
 174:	83 ec 04             	sub    $0x4,%esp
 177:	6a 01                	push   $0x1
 179:	8d 45 ef             	lea    -0x11(%ebp),%eax
 17c:	50                   	push   %eax
 17d:	6a 00                	push   $0x0
 17f:	e8 1a 02 00 00       	call   39e <read>
 184:	83 c4 10             	add    $0x10,%esp
 187:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 18a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 18e:	7e 33                	jle    1c3 <gets+0x5e>
      break;
    buf[i++] = c;
 190:	8b 45 f4             	mov    -0xc(%ebp),%eax
 193:	8d 50 01             	lea    0x1(%eax),%edx
 196:	89 55 f4             	mov    %edx,-0xc(%ebp)
 199:	89 c2                	mov    %eax,%edx
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
 19e:	01 c2                	add    %eax,%edx
 1a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1a4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1a6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1aa:	3c 0a                	cmp    $0xa,%al
 1ac:	74 16                	je     1c4 <gets+0x5f>
 1ae:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b2:	3c 0d                	cmp    $0xd,%al
 1b4:	74 0e                	je     1c4 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b9:	83 c0 01             	add    $0x1,%eax
 1bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1bf:	7c b3                	jl     174 <gets+0xf>
 1c1:	eb 01                	jmp    1c4 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1c3:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1c7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ca:	01 d0                	add    %edx,%eax
 1cc:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d2:	c9                   	leave  
 1d3:	c3                   	ret    

000001d4 <stat>:

int
stat(char *n, struct stat *st)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1da:	83 ec 08             	sub    $0x8,%esp
 1dd:	6a 00                	push   $0x0
 1df:	ff 75 08             	pushl  0x8(%ebp)
 1e2:	e8 df 01 00 00       	call   3c6 <open>
 1e7:	83 c4 10             	add    $0x10,%esp
 1ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1f1:	79 07                	jns    1fa <stat+0x26>
    return -1;
 1f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1f8:	eb 25                	jmp    21f <stat+0x4b>
  r = fstat(fd, st);
 1fa:	83 ec 08             	sub    $0x8,%esp
 1fd:	ff 75 0c             	pushl  0xc(%ebp)
 200:	ff 75 f4             	pushl  -0xc(%ebp)
 203:	e8 d6 01 00 00       	call   3de <fstat>
 208:	83 c4 10             	add    $0x10,%esp
 20b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 20e:	83 ec 0c             	sub    $0xc,%esp
 211:	ff 75 f4             	pushl  -0xc(%ebp)
 214:	e8 95 01 00 00       	call   3ae <close>
 219:	83 c4 10             	add    $0x10,%esp
  return r;
 21c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 21f:	c9                   	leave  
 220:	c3                   	ret    

00000221 <atoi>:

int
atoi(const char *s)
{
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 227:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 22e:	eb 04                	jmp    234 <atoi+0x13>
 230:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	0f b6 00             	movzbl (%eax),%eax
 23a:	3c 20                	cmp    $0x20,%al
 23c:	74 f2                	je     230 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	0f b6 00             	movzbl (%eax),%eax
 244:	3c 2d                	cmp    $0x2d,%al
 246:	75 07                	jne    24f <atoi+0x2e>
 248:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 24d:	eb 05                	jmp    254 <atoi+0x33>
 24f:	b8 01 00 00 00       	mov    $0x1,%eax
 254:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 257:	8b 45 08             	mov    0x8(%ebp),%eax
 25a:	0f b6 00             	movzbl (%eax),%eax
 25d:	3c 2b                	cmp    $0x2b,%al
 25f:	74 0a                	je     26b <atoi+0x4a>
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	3c 2d                	cmp    $0x2d,%al
 269:	75 2b                	jne    296 <atoi+0x75>
    s++;
 26b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 26f:	eb 25                	jmp    296 <atoi+0x75>
    n = n*10 + *s++ - '0';
 271:	8b 55 fc             	mov    -0x4(%ebp),%edx
 274:	89 d0                	mov    %edx,%eax
 276:	c1 e0 02             	shl    $0x2,%eax
 279:	01 d0                	add    %edx,%eax
 27b:	01 c0                	add    %eax,%eax
 27d:	89 c1                	mov    %eax,%ecx
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	8d 50 01             	lea    0x1(%eax),%edx
 285:	89 55 08             	mov    %edx,0x8(%ebp)
 288:	0f b6 00             	movzbl (%eax),%eax
 28b:	0f be c0             	movsbl %al,%eax
 28e:	01 c8                	add    %ecx,%eax
 290:	83 e8 30             	sub    $0x30,%eax
 293:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	0f b6 00             	movzbl (%eax),%eax
 29c:	3c 2f                	cmp    $0x2f,%al
 29e:	7e 0a                	jle    2aa <atoi+0x89>
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	3c 39                	cmp    $0x39,%al
 2a8:	7e c7                	jle    271 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2ad:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2b1:	c9                   	leave  
 2b2:	c3                   	ret    

000002b3 <atoo>:

int
atoo(const char *s)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
 2b6:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2c0:	eb 04                	jmp    2c6 <atoo+0x13>
 2c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	0f b6 00             	movzbl (%eax),%eax
 2cc:	3c 20                	cmp    $0x20,%al
 2ce:	74 f2                	je     2c2 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	0f b6 00             	movzbl (%eax),%eax
 2d6:	3c 2d                	cmp    $0x2d,%al
 2d8:	75 07                	jne    2e1 <atoo+0x2e>
 2da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2df:	eb 05                	jmp    2e6 <atoo+0x33>
 2e1:	b8 01 00 00 00       	mov    $0x1,%eax
 2e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	3c 2b                	cmp    $0x2b,%al
 2f1:	74 0a                	je     2fd <atoo+0x4a>
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	0f b6 00             	movzbl (%eax),%eax
 2f9:	3c 2d                	cmp    $0x2d,%al
 2fb:	75 27                	jne    324 <atoo+0x71>
    s++;
 2fd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 301:	eb 21                	jmp    324 <atoo+0x71>
    n = n*8 + *s++ - '0';
 303:	8b 45 fc             	mov    -0x4(%ebp),%eax
 306:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	8d 50 01             	lea    0x1(%eax),%edx
 313:	89 55 08             	mov    %edx,0x8(%ebp)
 316:	0f b6 00             	movzbl (%eax),%eax
 319:	0f be c0             	movsbl %al,%eax
 31c:	01 c8                	add    %ecx,%eax
 31e:	83 e8 30             	sub    $0x30,%eax
 321:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	0f b6 00             	movzbl (%eax),%eax
 32a:	3c 2f                	cmp    $0x2f,%al
 32c:	7e 0a                	jle    338 <atoo+0x85>
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	0f b6 00             	movzbl (%eax),%eax
 334:	3c 37                	cmp    $0x37,%al
 336:	7e cb                	jle    303 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 338:	8b 45 f8             	mov    -0x8(%ebp),%eax
 33b:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 33f:	c9                   	leave  
 340:	c3                   	ret    

00000341 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 341:	55                   	push   %ebp
 342:	89 e5                	mov    %esp,%ebp
 344:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 34d:	8b 45 0c             	mov    0xc(%ebp),%eax
 350:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 353:	eb 17                	jmp    36c <memmove+0x2b>
    *dst++ = *src++;
 355:	8b 45 fc             	mov    -0x4(%ebp),%eax
 358:	8d 50 01             	lea    0x1(%eax),%edx
 35b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 35e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 361:	8d 4a 01             	lea    0x1(%edx),%ecx
 364:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 367:	0f b6 12             	movzbl (%edx),%edx
 36a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 36c:	8b 45 10             	mov    0x10(%ebp),%eax
 36f:	8d 50 ff             	lea    -0x1(%eax),%edx
 372:	89 55 10             	mov    %edx,0x10(%ebp)
 375:	85 c0                	test   %eax,%eax
 377:	7f dc                	jg     355 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 379:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37c:	c9                   	leave  
 37d:	c3                   	ret    

0000037e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37e:	b8 01 00 00 00       	mov    $0x1,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <exit>:
SYSCALL(exit)
 386:	b8 02 00 00 00       	mov    $0x2,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <wait>:
SYSCALL(wait)
 38e:	b8 03 00 00 00       	mov    $0x3,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <pipe>:
SYSCALL(pipe)
 396:	b8 04 00 00 00       	mov    $0x4,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <read>:
SYSCALL(read)
 39e:	b8 05 00 00 00       	mov    $0x5,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <write>:
SYSCALL(write)
 3a6:	b8 10 00 00 00       	mov    $0x10,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <close>:
SYSCALL(close)
 3ae:	b8 15 00 00 00       	mov    $0x15,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <kill>:
SYSCALL(kill)
 3b6:	b8 06 00 00 00       	mov    $0x6,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <exec>:
SYSCALL(exec)
 3be:	b8 07 00 00 00       	mov    $0x7,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <open>:
SYSCALL(open)
 3c6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <mknod>:
SYSCALL(mknod)
 3ce:	b8 11 00 00 00       	mov    $0x11,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <unlink>:
SYSCALL(unlink)
 3d6:	b8 12 00 00 00       	mov    $0x12,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <fstat>:
SYSCALL(fstat)
 3de:	b8 08 00 00 00       	mov    $0x8,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <link>:
SYSCALL(link)
 3e6:	b8 13 00 00 00       	mov    $0x13,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <mkdir>:
SYSCALL(mkdir)
 3ee:	b8 14 00 00 00       	mov    $0x14,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <chdir>:
SYSCALL(chdir)
 3f6:	b8 09 00 00 00       	mov    $0x9,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <dup>:
SYSCALL(dup)
 3fe:	b8 0a 00 00 00       	mov    $0xa,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <getpid>:
SYSCALL(getpid)
 406:	b8 0b 00 00 00       	mov    $0xb,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <sbrk>:
SYSCALL(sbrk)
 40e:	b8 0c 00 00 00       	mov    $0xc,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <sleep>:
SYSCALL(sleep)
 416:	b8 0d 00 00 00       	mov    $0xd,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <uptime>:
SYSCALL(uptime)
 41e:	b8 0e 00 00 00       	mov    $0xe,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <halt>:
SYSCALL(halt)
 426:	b8 16 00 00 00       	mov    $0x16,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <date>:
SYSCALL(date)
 42e:	b8 17 00 00 00       	mov    $0x17,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <getuid>:
SYSCALL(getuid)
 436:	b8 18 00 00 00       	mov    $0x18,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <getgid>:
SYSCALL(getgid)
 43e:	b8 19 00 00 00       	mov    $0x19,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <getppid>:
SYSCALL(getppid)
 446:	b8 1a 00 00 00       	mov    $0x1a,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <setuid>:
SYSCALL(setuid)
 44e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <setgid>:
SYSCALL(setgid)
 456:	b8 1c 00 00 00       	mov    $0x1c,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <getprocs>:
SYSCALL(getprocs)
 45e:	b8 1d 00 00 00       	mov    $0x1d,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <setpriority>:
SYSCALL(setpriority)
 466:	b8 1e 00 00 00       	mov    $0x1e,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 46e:	55                   	push   %ebp
 46f:	89 e5                	mov    %esp,%ebp
 471:	83 ec 18             	sub    $0x18,%esp
 474:	8b 45 0c             	mov    0xc(%ebp),%eax
 477:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 47a:	83 ec 04             	sub    $0x4,%esp
 47d:	6a 01                	push   $0x1
 47f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 482:	50                   	push   %eax
 483:	ff 75 08             	pushl  0x8(%ebp)
 486:	e8 1b ff ff ff       	call   3a6 <write>
 48b:	83 c4 10             	add    $0x10,%esp
}
 48e:	90                   	nop
 48f:	c9                   	leave  
 490:	c3                   	ret    

00000491 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 491:	55                   	push   %ebp
 492:	89 e5                	mov    %esp,%ebp
 494:	53                   	push   %ebx
 495:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 498:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 49f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4a3:	74 17                	je     4bc <printint+0x2b>
 4a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4a9:	79 11                	jns    4bc <printint+0x2b>
    neg = 1;
 4ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b5:	f7 d8                	neg    %eax
 4b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ba:	eb 06                	jmp    4c2 <printint+0x31>
  } else {
    x = xx;
 4bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4c9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4cc:	8d 41 01             	lea    0x1(%ecx),%eax
 4cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d8:	ba 00 00 00 00       	mov    $0x0,%edx
 4dd:	f7 f3                	div    %ebx
 4df:	89 d0                	mov    %edx,%eax
 4e1:	0f b6 80 6c 0b 00 00 	movzbl 0xb6c(%eax),%eax
 4e8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f2:	ba 00 00 00 00       	mov    $0x0,%edx
 4f7:	f7 f3                	div    %ebx
 4f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 500:	75 c7                	jne    4c9 <printint+0x38>
  if(neg)
 502:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 506:	74 2d                	je     535 <printint+0xa4>
    buf[i++] = '-';
 508:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50b:	8d 50 01             	lea    0x1(%eax),%edx
 50e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 511:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 516:	eb 1d                	jmp    535 <printint+0xa4>
    putc(fd, buf[i]);
 518:	8d 55 dc             	lea    -0x24(%ebp),%edx
 51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51e:	01 d0                	add    %edx,%eax
 520:	0f b6 00             	movzbl (%eax),%eax
 523:	0f be c0             	movsbl %al,%eax
 526:	83 ec 08             	sub    $0x8,%esp
 529:	50                   	push   %eax
 52a:	ff 75 08             	pushl  0x8(%ebp)
 52d:	e8 3c ff ff ff       	call   46e <putc>
 532:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 535:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 539:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53d:	79 d9                	jns    518 <printint+0x87>
    putc(fd, buf[i]);
}
 53f:	90                   	nop
 540:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 543:	c9                   	leave  
 544:	c3                   	ret    

00000545 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 545:	55                   	push   %ebp
 546:	89 e5                	mov    %esp,%ebp
 548:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 54b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 552:	8d 45 0c             	lea    0xc(%ebp),%eax
 555:	83 c0 04             	add    $0x4,%eax
 558:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 55b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 562:	e9 59 01 00 00       	jmp    6c0 <printf+0x17b>
    c = fmt[i] & 0xff;
 567:	8b 55 0c             	mov    0xc(%ebp),%edx
 56a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 56d:	01 d0                	add    %edx,%eax
 56f:	0f b6 00             	movzbl (%eax),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	25 ff 00 00 00       	and    $0xff,%eax
 57a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 57d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 581:	75 2c                	jne    5af <printf+0x6a>
      if(c == '%'){
 583:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 587:	75 0c                	jne    595 <printf+0x50>
        state = '%';
 589:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 590:	e9 27 01 00 00       	jmp    6bc <printf+0x177>
      } else {
        putc(fd, c);
 595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 598:	0f be c0             	movsbl %al,%eax
 59b:	83 ec 08             	sub    $0x8,%esp
 59e:	50                   	push   %eax
 59f:	ff 75 08             	pushl  0x8(%ebp)
 5a2:	e8 c7 fe ff ff       	call   46e <putc>
 5a7:	83 c4 10             	add    $0x10,%esp
 5aa:	e9 0d 01 00 00       	jmp    6bc <printf+0x177>
      }
    } else if(state == '%'){
 5af:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5b3:	0f 85 03 01 00 00    	jne    6bc <printf+0x177>
      if(c == 'd'){
 5b9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5bd:	75 1e                	jne    5dd <printf+0x98>
        printint(fd, *ap, 10, 1);
 5bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c2:	8b 00                	mov    (%eax),%eax
 5c4:	6a 01                	push   $0x1
 5c6:	6a 0a                	push   $0xa
 5c8:	50                   	push   %eax
 5c9:	ff 75 08             	pushl  0x8(%ebp)
 5cc:	e8 c0 fe ff ff       	call   491 <printint>
 5d1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d8:	e9 d8 00 00 00       	jmp    6b5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5dd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5e1:	74 06                	je     5e9 <printf+0xa4>
 5e3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e7:	75 1e                	jne    607 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	6a 00                	push   $0x0
 5f0:	6a 10                	push   $0x10
 5f2:	50                   	push   %eax
 5f3:	ff 75 08             	pushl  0x8(%ebp)
 5f6:	e8 96 fe ff ff       	call   491 <printint>
 5fb:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 602:	e9 ae 00 00 00       	jmp    6b5 <printf+0x170>
      } else if(c == 's'){
 607:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 60b:	75 43                	jne    650 <printf+0x10b>
        s = (char*)*ap;
 60d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 610:	8b 00                	mov    (%eax),%eax
 612:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 615:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 61d:	75 25                	jne    644 <printf+0xff>
          s = "(null)";
 61f:	c7 45 f4 fb 08 00 00 	movl   $0x8fb,-0xc(%ebp)
        while(*s != 0){
 626:	eb 1c                	jmp    644 <printf+0xff>
          putc(fd, *s);
 628:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62b:	0f b6 00             	movzbl (%eax),%eax
 62e:	0f be c0             	movsbl %al,%eax
 631:	83 ec 08             	sub    $0x8,%esp
 634:	50                   	push   %eax
 635:	ff 75 08             	pushl  0x8(%ebp)
 638:	e8 31 fe ff ff       	call   46e <putc>
 63d:	83 c4 10             	add    $0x10,%esp
          s++;
 640:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 644:	8b 45 f4             	mov    -0xc(%ebp),%eax
 647:	0f b6 00             	movzbl (%eax),%eax
 64a:	84 c0                	test   %al,%al
 64c:	75 da                	jne    628 <printf+0xe3>
 64e:	eb 65                	jmp    6b5 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 650:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 654:	75 1d                	jne    673 <printf+0x12e>
        putc(fd, *ap);
 656:	8b 45 e8             	mov    -0x18(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	0f be c0             	movsbl %al,%eax
 65e:	83 ec 08             	sub    $0x8,%esp
 661:	50                   	push   %eax
 662:	ff 75 08             	pushl  0x8(%ebp)
 665:	e8 04 fe ff ff       	call   46e <putc>
 66a:	83 c4 10             	add    $0x10,%esp
        ap++;
 66d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 671:	eb 42                	jmp    6b5 <printf+0x170>
      } else if(c == '%'){
 673:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 677:	75 17                	jne    690 <printf+0x14b>
        putc(fd, c);
 679:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67c:	0f be c0             	movsbl %al,%eax
 67f:	83 ec 08             	sub    $0x8,%esp
 682:	50                   	push   %eax
 683:	ff 75 08             	pushl  0x8(%ebp)
 686:	e8 e3 fd ff ff       	call   46e <putc>
 68b:	83 c4 10             	add    $0x10,%esp
 68e:	eb 25                	jmp    6b5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 690:	83 ec 08             	sub    $0x8,%esp
 693:	6a 25                	push   $0x25
 695:	ff 75 08             	pushl  0x8(%ebp)
 698:	e8 d1 fd ff ff       	call   46e <putc>
 69d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a3:	0f be c0             	movsbl %al,%eax
 6a6:	83 ec 08             	sub    $0x8,%esp
 6a9:	50                   	push   %eax
 6aa:	ff 75 08             	pushl  0x8(%ebp)
 6ad:	e8 bc fd ff ff       	call   46e <putc>
 6b2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6b5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6bc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6c0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c6:	01 d0                	add    %edx,%eax
 6c8:	0f b6 00             	movzbl (%eax),%eax
 6cb:	84 c0                	test   %al,%al
 6cd:	0f 85 94 fe ff ff    	jne    567 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d3:	90                   	nop
 6d4:	c9                   	leave  
 6d5:	c3                   	ret    

000006d6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d6:	55                   	push   %ebp
 6d7:	89 e5                	mov    %esp,%ebp
 6d9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	83 e8 08             	sub    $0x8,%eax
 6e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e5:	a1 88 0b 00 00       	mov    0xb88,%eax
 6ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ed:	eb 24                	jmp    713 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f2:	8b 00                	mov    (%eax),%eax
 6f4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f7:	77 12                	ja     70b <free+0x35>
 6f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ff:	77 24                	ja     725 <free+0x4f>
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 709:	77 1a                	ja     725 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	8b 00                	mov    (%eax),%eax
 710:	89 45 fc             	mov    %eax,-0x4(%ebp)
 713:	8b 45 f8             	mov    -0x8(%ebp),%eax
 716:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 719:	76 d4                	jbe    6ef <free+0x19>
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 00                	mov    (%eax),%eax
 720:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 723:	76 ca                	jbe    6ef <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	8b 40 04             	mov    0x4(%eax),%eax
 72b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	01 c2                	add    %eax,%edx
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	8b 00                	mov    (%eax),%eax
 73c:	39 c2                	cmp    %eax,%edx
 73e:	75 24                	jne    764 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 740:	8b 45 f8             	mov    -0x8(%ebp),%eax
 743:	8b 50 04             	mov    0x4(%eax),%edx
 746:	8b 45 fc             	mov    -0x4(%ebp),%eax
 749:	8b 00                	mov    (%eax),%eax
 74b:	8b 40 04             	mov    0x4(%eax),%eax
 74e:	01 c2                	add    %eax,%edx
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 756:	8b 45 fc             	mov    -0x4(%ebp),%eax
 759:	8b 00                	mov    (%eax),%eax
 75b:	8b 10                	mov    (%eax),%edx
 75d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 760:	89 10                	mov    %edx,(%eax)
 762:	eb 0a                	jmp    76e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 10                	mov    (%eax),%edx
 769:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 76e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 771:	8b 40 04             	mov    0x4(%eax),%eax
 774:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	01 d0                	add    %edx,%eax
 780:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 783:	75 20                	jne    7a5 <free+0xcf>
    p->s.size += bp->s.size;
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 50 04             	mov    0x4(%eax),%edx
 78b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78e:	8b 40 04             	mov    0x4(%eax),%eax
 791:	01 c2                	add    %eax,%edx
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 799:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79c:	8b 10                	mov    (%eax),%edx
 79e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a1:	89 10                	mov    %edx,(%eax)
 7a3:	eb 08                	jmp    7ad <free+0xd7>
  } else
    p->s.ptr = bp;
 7a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7ab:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	a3 88 0b 00 00       	mov    %eax,0xb88
}
 7b5:	90                   	nop
 7b6:	c9                   	leave  
 7b7:	c3                   	ret    

000007b8 <morecore>:

static Header*
morecore(uint nu)
{
 7b8:	55                   	push   %ebp
 7b9:	89 e5                	mov    %esp,%ebp
 7bb:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7be:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c5:	77 07                	ja     7ce <morecore+0x16>
    nu = 4096;
 7c7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ce:	8b 45 08             	mov    0x8(%ebp),%eax
 7d1:	c1 e0 03             	shl    $0x3,%eax
 7d4:	83 ec 0c             	sub    $0xc,%esp
 7d7:	50                   	push   %eax
 7d8:	e8 31 fc ff ff       	call   40e <sbrk>
 7dd:	83 c4 10             	add    $0x10,%esp
 7e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7e7:	75 07                	jne    7f0 <morecore+0x38>
    return 0;
 7e9:	b8 00 00 00 00       	mov    $0x0,%eax
 7ee:	eb 26                	jmp    816 <morecore+0x5e>
  hp = (Header*)p;
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f9:	8b 55 08             	mov    0x8(%ebp),%edx
 7fc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 802:	83 c0 08             	add    $0x8,%eax
 805:	83 ec 0c             	sub    $0xc,%esp
 808:	50                   	push   %eax
 809:	e8 c8 fe ff ff       	call   6d6 <free>
 80e:	83 c4 10             	add    $0x10,%esp
  return freep;
 811:	a1 88 0b 00 00       	mov    0xb88,%eax
}
 816:	c9                   	leave  
 817:	c3                   	ret    

00000818 <malloc>:

void*
malloc(uint nbytes)
{
 818:	55                   	push   %ebp
 819:	89 e5                	mov    %esp,%ebp
 81b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81e:	8b 45 08             	mov    0x8(%ebp),%eax
 821:	83 c0 07             	add    $0x7,%eax
 824:	c1 e8 03             	shr    $0x3,%eax
 827:	83 c0 01             	add    $0x1,%eax
 82a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 82d:	a1 88 0b 00 00       	mov    0xb88,%eax
 832:	89 45 f0             	mov    %eax,-0x10(%ebp)
 835:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 839:	75 23                	jne    85e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 83b:	c7 45 f0 80 0b 00 00 	movl   $0xb80,-0x10(%ebp)
 842:	8b 45 f0             	mov    -0x10(%ebp),%eax
 845:	a3 88 0b 00 00       	mov    %eax,0xb88
 84a:	a1 88 0b 00 00       	mov    0xb88,%eax
 84f:	a3 80 0b 00 00       	mov    %eax,0xb80
    base.s.size = 0;
 854:	c7 05 84 0b 00 00 00 	movl   $0x0,0xb84
 85b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 861:	8b 00                	mov    (%eax),%eax
 863:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 866:	8b 45 f4             	mov    -0xc(%ebp),%eax
 869:	8b 40 04             	mov    0x4(%eax),%eax
 86c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86f:	72 4d                	jb     8be <malloc+0xa6>
      if(p->s.size == nunits)
 871:	8b 45 f4             	mov    -0xc(%ebp),%eax
 874:	8b 40 04             	mov    0x4(%eax),%eax
 877:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87a:	75 0c                	jne    888 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	8b 10                	mov    (%eax),%edx
 881:	8b 45 f0             	mov    -0x10(%ebp),%eax
 884:	89 10                	mov    %edx,(%eax)
 886:	eb 26                	jmp    8ae <malloc+0x96>
      else {
        p->s.size -= nunits;
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	8b 40 04             	mov    0x4(%eax),%eax
 88e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 891:	89 c2                	mov    %eax,%edx
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	8b 40 04             	mov    0x4(%eax),%eax
 89f:	c1 e0 03             	shl    $0x3,%eax
 8a2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ab:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b1:	a3 88 0b 00 00       	mov    %eax,0xb88
      return (void*)(p + 1);
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	83 c0 08             	add    $0x8,%eax
 8bc:	eb 3b                	jmp    8f9 <malloc+0xe1>
    }
    if(p == freep)
 8be:	a1 88 0b 00 00       	mov    0xb88,%eax
 8c3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c6:	75 1e                	jne    8e6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8c8:	83 ec 0c             	sub    $0xc,%esp
 8cb:	ff 75 ec             	pushl  -0x14(%ebp)
 8ce:	e8 e5 fe ff ff       	call   7b8 <morecore>
 8d3:	83 c4 10             	add    $0x10,%esp
 8d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8dd:	75 07                	jne    8e6 <malloc+0xce>
        return 0;
 8df:	b8 00 00 00 00       	mov    $0x0,%eax
 8e4:	eb 13                	jmp    8f9 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 00                	mov    (%eax),%eax
 8f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8f4:	e9 6d ff ff ff       	jmp    866 <malloc+0x4e>
}
 8f9:	c9                   	leave  
 8fa:	c3                   	ret    
