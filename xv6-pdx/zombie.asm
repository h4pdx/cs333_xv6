
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 38 03 00 00       	call   34e <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7e 0d                	jle    27 <main+0x27>
    sleep(5);  // Let child exit before parent.
  1a:	83 ec 0c             	sub    $0xc,%esp
  1d:	6a 05                	push   $0x5
  1f:	e8 c2 03 00 00       	call   3e6 <sleep>
  24:	83 c4 10             	add    $0x10,%esp
  exit();
  27:	e8 2a 03 00 00       	call   356 <exit>

0000002c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  2c:	55                   	push   %ebp
  2d:	89 e5                	mov    %esp,%ebp
  2f:	57                   	push   %edi
  30:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 10             	mov    0x10(%ebp),%edx
  37:	8b 45 0c             	mov    0xc(%ebp),%eax
  3a:	89 cb                	mov    %ecx,%ebx
  3c:	89 df                	mov    %ebx,%edi
  3e:	89 d1                	mov    %edx,%ecx
  40:	fc                   	cld    
  41:	f3 aa                	rep stos %al,%es:(%edi)
  43:	89 ca                	mov    %ecx,%edx
  45:	89 fb                	mov    %edi,%ebx
  47:	89 5d 08             	mov    %ebx,0x8(%ebp)
  4a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  4d:	90                   	nop
  4e:	5b                   	pop    %ebx
  4f:	5f                   	pop    %edi
  50:	5d                   	pop    %ebp
  51:	c3                   	ret    

00000052 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  52:	55                   	push   %ebp
  53:	89 e5                	mov    %esp,%ebp
  55:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  58:	8b 45 08             	mov    0x8(%ebp),%eax
  5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5e:	90                   	nop
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	8d 50 01             	lea    0x1(%eax),%edx
  65:	89 55 08             	mov    %edx,0x8(%ebp)
  68:	8b 55 0c             	mov    0xc(%ebp),%edx
  6b:	8d 4a 01             	lea    0x1(%edx),%ecx
  6e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  71:	0f b6 12             	movzbl (%edx),%edx
  74:	88 10                	mov    %dl,(%eax)
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	84 c0                	test   %al,%al
  7b:	75 e2                	jne    5f <strcpy+0xd>
    ;
  return os;
  7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80:	c9                   	leave  
  81:	c3                   	ret    

00000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	55                   	push   %ebp
  83:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  85:	eb 08                	jmp    8f <strcmp+0xd>
    p++, q++;
  87:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 00             	movzbl (%eax),%eax
  95:	84 c0                	test   %al,%al
  97:	74 10                	je     a9 <strcmp+0x27>
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	0f b6 10             	movzbl (%eax),%edx
  9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	38 c2                	cmp    %al,%dl
  a7:	74 de                	je     87 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	0f b6 d0             	movzbl %al,%edx
  b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	0f b6 c0             	movzbl %al,%eax
  bb:	29 c2                	sub    %eax,%edx
  bd:	89 d0                	mov    %edx,%eax
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    

000000c1 <strlen>:

uint
strlen(char *s)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ce:	eb 04                	jmp    d4 <strlen+0x13>
  d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	01 d0                	add    %edx,%eax
  dc:	0f b6 00             	movzbl (%eax),%eax
  df:	84 c0                	test   %al,%al
  e1:	75 ed                	jne    d0 <strlen+0xf>
    ;
  return n;
  e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e6:	c9                   	leave  
  e7:	c3                   	ret    

000000e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e8:	55                   	push   %ebp
  e9:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  eb:	8b 45 10             	mov    0x10(%ebp),%eax
  ee:	50                   	push   %eax
  ef:	ff 75 0c             	pushl  0xc(%ebp)
  f2:	ff 75 08             	pushl  0x8(%ebp)
  f5:	e8 32 ff ff ff       	call   2c <stosb>
  fa:	83 c4 0c             	add    $0xc,%esp
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 42                	jmp    186 <gets+0x51>
    cc = read(0, &c, 1);
 144:	83 ec 04             	sub    $0x4,%esp
 147:	6a 01                	push   $0x1
 149:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14c:	50                   	push   %eax
 14d:	6a 00                	push   $0x0
 14f:	e8 1a 02 00 00       	call   36e <read>
 154:	83 c4 10             	add    $0x10,%esp
 157:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 15a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15e:	7e 33                	jle    193 <gets+0x5e>
      break;
    buf[i++] = c;
 160:	8b 45 f4             	mov    -0xc(%ebp),%eax
 163:	8d 50 01             	lea    0x1(%eax),%edx
 166:	89 55 f4             	mov    %edx,-0xc(%ebp)
 169:	89 c2                	mov    %eax,%edx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	01 c2                	add    %eax,%edx
 170:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 174:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0a                	cmp    $0xa,%al
 17c:	74 16                	je     194 <gets+0x5f>
 17e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 182:	3c 0d                	cmp    $0xd,%al
 184:	74 0e                	je     194 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
 189:	83 c0 01             	add    $0x1,%eax
 18c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18f:	7c b3                	jl     144 <gets+0xf>
 191:	eb 01                	jmp    194 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 193:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 194:	8b 55 f4             	mov    -0xc(%ebp),%edx
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	01 d0                	add    %edx,%eax
 19c:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a2:	c9                   	leave  
 1a3:	c3                   	ret    

000001a4 <stat>:

int
stat(char *n, struct stat *st)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	83 ec 08             	sub    $0x8,%esp
 1ad:	6a 00                	push   $0x0
 1af:	ff 75 08             	pushl  0x8(%ebp)
 1b2:	e8 df 01 00 00       	call   396 <open>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c1:	79 07                	jns    1ca <stat+0x26>
    return -1;
 1c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c8:	eb 25                	jmp    1ef <stat+0x4b>
  r = fstat(fd, st);
 1ca:	83 ec 08             	sub    $0x8,%esp
 1cd:	ff 75 0c             	pushl  0xc(%ebp)
 1d0:	ff 75 f4             	pushl  -0xc(%ebp)
 1d3:	e8 d6 01 00 00       	call   3ae <fstat>
 1d8:	83 c4 10             	add    $0x10,%esp
 1db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1de:	83 ec 0c             	sub    $0xc,%esp
 1e1:	ff 75 f4             	pushl  -0xc(%ebp)
 1e4:	e8 95 01 00 00       	call   37e <close>
 1e9:	83 c4 10             	add    $0x10,%esp
  return r;
 1ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1ef:	c9                   	leave  
 1f0:	c3                   	ret    

000001f1 <atoi>:

int
atoi(const char *s)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 1f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 1fe:	eb 04                	jmp    204 <atoi+0x13>
 200:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	3c 20                	cmp    $0x20,%al
 20c:	74 f2                	je     200 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	0f b6 00             	movzbl (%eax),%eax
 214:	3c 2d                	cmp    $0x2d,%al
 216:	75 07                	jne    21f <atoi+0x2e>
 218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21d:	eb 05                	jmp    224 <atoi+0x33>
 21f:	b8 01 00 00 00       	mov    $0x1,%eax
 224:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 00             	movzbl (%eax),%eax
 22d:	3c 2b                	cmp    $0x2b,%al
 22f:	74 0a                	je     23b <atoi+0x4a>
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	0f b6 00             	movzbl (%eax),%eax
 237:	3c 2d                	cmp    $0x2d,%al
 239:	75 2b                	jne    266 <atoi+0x75>
    s++;
 23b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 23f:	eb 25                	jmp    266 <atoi+0x75>
    n = n*10 + *s++ - '0';
 241:	8b 55 fc             	mov    -0x4(%ebp),%edx
 244:	89 d0                	mov    %edx,%eax
 246:	c1 e0 02             	shl    $0x2,%eax
 249:	01 d0                	add    %edx,%eax
 24b:	01 c0                	add    %eax,%eax
 24d:	89 c1                	mov    %eax,%ecx
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	8d 50 01             	lea    0x1(%eax),%edx
 255:	89 55 08             	mov    %edx,0x8(%ebp)
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	0f be c0             	movsbl %al,%eax
 25e:	01 c8                	add    %ecx,%eax
 260:	83 e8 30             	sub    $0x30,%eax
 263:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	3c 2f                	cmp    $0x2f,%al
 26e:	7e 0a                	jle    27a <atoi+0x89>
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	0f b6 00             	movzbl (%eax),%eax
 276:	3c 39                	cmp    $0x39,%al
 278:	7e c7                	jle    241 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 27a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 27d:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    

00000283 <atoo>:

int
atoo(const char *s)
{
 283:	55                   	push   %ebp
 284:	89 e5                	mov    %esp,%ebp
 286:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 289:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 290:	eb 04                	jmp    296 <atoo+0x13>
 292:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	0f b6 00             	movzbl (%eax),%eax
 29c:	3c 20                	cmp    $0x20,%al
 29e:	74 f2                	je     292 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	3c 2d                	cmp    $0x2d,%al
 2a8:	75 07                	jne    2b1 <atoo+0x2e>
 2aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2af:	eb 05                	jmp    2b6 <atoo+0x33>
 2b1:	b8 01 00 00 00       	mov    $0x1,%eax
 2b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	0f b6 00             	movzbl (%eax),%eax
 2bf:	3c 2b                	cmp    $0x2b,%al
 2c1:	74 0a                	je     2cd <atoo+0x4a>
 2c3:	8b 45 08             	mov    0x8(%ebp),%eax
 2c6:	0f b6 00             	movzbl (%eax),%eax
 2c9:	3c 2d                	cmp    $0x2d,%al
 2cb:	75 27                	jne    2f4 <atoo+0x71>
    s++;
 2cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 2d1:	eb 21                	jmp    2f4 <atoo+0x71>
    n = n*8 + *s++ - '0';
 2d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	8d 50 01             	lea    0x1(%eax),%edx
 2e3:	89 55 08             	mov    %edx,0x8(%ebp)
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	0f be c0             	movsbl %al,%eax
 2ec:	01 c8                	add    %ecx,%eax
 2ee:	83 e8 30             	sub    $0x30,%eax
 2f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	0f b6 00             	movzbl (%eax),%eax
 2fa:	3c 2f                	cmp    $0x2f,%al
 2fc:	7e 0a                	jle    308 <atoo+0x85>
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
 301:	0f b6 00             	movzbl (%eax),%eax
 304:	3c 37                	cmp    $0x37,%al
 306:	7e cb                	jle    2d3 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 308:	8b 45 f8             	mov    -0x8(%ebp),%eax
 30b:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 30f:	c9                   	leave  
 310:	c3                   	ret    

00000311 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 311:	55                   	push   %ebp
 312:	89 e5                	mov    %esp,%ebp
 314:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 317:	8b 45 08             	mov    0x8(%ebp),%eax
 31a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 31d:	8b 45 0c             	mov    0xc(%ebp),%eax
 320:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 323:	eb 17                	jmp    33c <memmove+0x2b>
    *dst++ = *src++;
 325:	8b 45 fc             	mov    -0x4(%ebp),%eax
 328:	8d 50 01             	lea    0x1(%eax),%edx
 32b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 32e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 331:	8d 4a 01             	lea    0x1(%edx),%ecx
 334:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 337:	0f b6 12             	movzbl (%edx),%edx
 33a:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 33c:	8b 45 10             	mov    0x10(%ebp),%eax
 33f:	8d 50 ff             	lea    -0x1(%eax),%edx
 342:	89 55 10             	mov    %edx,0x10(%ebp)
 345:	85 c0                	test   %eax,%eax
 347:	7f dc                	jg     325 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 349:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34c:	c9                   	leave  
 34d:	c3                   	ret    

0000034e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34e:	b8 01 00 00 00       	mov    $0x1,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <exit>:
SYSCALL(exit)
 356:	b8 02 00 00 00       	mov    $0x2,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <wait>:
SYSCALL(wait)
 35e:	b8 03 00 00 00       	mov    $0x3,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <pipe>:
SYSCALL(pipe)
 366:	b8 04 00 00 00       	mov    $0x4,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <read>:
SYSCALL(read)
 36e:	b8 05 00 00 00       	mov    $0x5,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <write>:
SYSCALL(write)
 376:	b8 10 00 00 00       	mov    $0x10,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <close>:
SYSCALL(close)
 37e:	b8 15 00 00 00       	mov    $0x15,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <kill>:
SYSCALL(kill)
 386:	b8 06 00 00 00       	mov    $0x6,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <exec>:
SYSCALL(exec)
 38e:	b8 07 00 00 00       	mov    $0x7,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <open>:
SYSCALL(open)
 396:	b8 0f 00 00 00       	mov    $0xf,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <mknod>:
SYSCALL(mknod)
 39e:	b8 11 00 00 00       	mov    $0x11,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <unlink>:
SYSCALL(unlink)
 3a6:	b8 12 00 00 00       	mov    $0x12,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <fstat>:
SYSCALL(fstat)
 3ae:	b8 08 00 00 00       	mov    $0x8,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <link>:
SYSCALL(link)
 3b6:	b8 13 00 00 00       	mov    $0x13,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <mkdir>:
SYSCALL(mkdir)
 3be:	b8 14 00 00 00       	mov    $0x14,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <chdir>:
SYSCALL(chdir)
 3c6:	b8 09 00 00 00       	mov    $0x9,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <dup>:
SYSCALL(dup)
 3ce:	b8 0a 00 00 00       	mov    $0xa,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <getpid>:
SYSCALL(getpid)
 3d6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <sbrk>:
SYSCALL(sbrk)
 3de:	b8 0c 00 00 00       	mov    $0xc,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <sleep>:
SYSCALL(sleep)
 3e6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <uptime>:
SYSCALL(uptime)
 3ee:	b8 0e 00 00 00       	mov    $0xe,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <halt>:
SYSCALL(halt)
 3f6:	b8 16 00 00 00       	mov    $0x16,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <date>:
SYSCALL(date)
 3fe:	b8 17 00 00 00       	mov    $0x17,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <getuid>:
SYSCALL(getuid)
 406:	b8 18 00 00 00       	mov    $0x18,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <getgid>:
SYSCALL(getgid)
 40e:	b8 19 00 00 00       	mov    $0x19,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <getppid>:
SYSCALL(getppid)
 416:	b8 1a 00 00 00       	mov    $0x1a,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <setuid>:
SYSCALL(setuid)
 41e:	b8 1b 00 00 00       	mov    $0x1b,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <setgid>:
SYSCALL(setgid)
 426:	b8 1c 00 00 00       	mov    $0x1c,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 42e:	55                   	push   %ebp
 42f:	89 e5                	mov    %esp,%ebp
 431:	83 ec 18             	sub    $0x18,%esp
 434:	8b 45 0c             	mov    0xc(%ebp),%eax
 437:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 43a:	83 ec 04             	sub    $0x4,%esp
 43d:	6a 01                	push   $0x1
 43f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 442:	50                   	push   %eax
 443:	ff 75 08             	pushl  0x8(%ebp)
 446:	e8 2b ff ff ff       	call   376 <write>
 44b:	83 c4 10             	add    $0x10,%esp
}
 44e:	90                   	nop
 44f:	c9                   	leave  
 450:	c3                   	ret    

00000451 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 451:	55                   	push   %ebp
 452:	89 e5                	mov    %esp,%ebp
 454:	53                   	push   %ebx
 455:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 458:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 45f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 463:	74 17                	je     47c <printint+0x2b>
 465:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 469:	79 11                	jns    47c <printint+0x2b>
    neg = 1;
 46b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 472:	8b 45 0c             	mov    0xc(%ebp),%eax
 475:	f7 d8                	neg    %eax
 477:	89 45 ec             	mov    %eax,-0x14(%ebp)
 47a:	eb 06                	jmp    482 <printint+0x31>
  } else {
    x = xx;
 47c:	8b 45 0c             	mov    0xc(%ebp),%eax
 47f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 482:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 489:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 48c:	8d 41 01             	lea    0x1(%ecx),%eax
 48f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 492:	8b 5d 10             	mov    0x10(%ebp),%ebx
 495:	8b 45 ec             	mov    -0x14(%ebp),%eax
 498:	ba 00 00 00 00       	mov    $0x0,%edx
 49d:	f7 f3                	div    %ebx
 49f:	89 d0                	mov    %edx,%eax
 4a1:	0f b6 80 2c 0b 00 00 	movzbl 0xb2c(%eax),%eax
 4a8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b2:	ba 00 00 00 00       	mov    $0x0,%edx
 4b7:	f7 f3                	div    %ebx
 4b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4c0:	75 c7                	jne    489 <printint+0x38>
  if(neg)
 4c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c6:	74 2d                	je     4f5 <printint+0xa4>
    buf[i++] = '-';
 4c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cb:	8d 50 01             	lea    0x1(%eax),%edx
 4ce:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4d1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4d6:	eb 1d                	jmp    4f5 <printint+0xa4>
    putc(fd, buf[i]);
 4d8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4de:	01 d0                	add    %edx,%eax
 4e0:	0f b6 00             	movzbl (%eax),%eax
 4e3:	0f be c0             	movsbl %al,%eax
 4e6:	83 ec 08             	sub    $0x8,%esp
 4e9:	50                   	push   %eax
 4ea:	ff 75 08             	pushl  0x8(%ebp)
 4ed:	e8 3c ff ff ff       	call   42e <putc>
 4f2:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4f5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4fd:	79 d9                	jns    4d8 <printint+0x87>
    putc(fd, buf[i]);
}
 4ff:	90                   	nop
 500:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 503:	c9                   	leave  
 504:	c3                   	ret    

00000505 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 505:	55                   	push   %ebp
 506:	89 e5                	mov    %esp,%ebp
 508:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 50b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 512:	8d 45 0c             	lea    0xc(%ebp),%eax
 515:	83 c0 04             	add    $0x4,%eax
 518:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 51b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 522:	e9 59 01 00 00       	jmp    680 <printf+0x17b>
    c = fmt[i] & 0xff;
 527:	8b 55 0c             	mov    0xc(%ebp),%edx
 52a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 52d:	01 d0                	add    %edx,%eax
 52f:	0f b6 00             	movzbl (%eax),%eax
 532:	0f be c0             	movsbl %al,%eax
 535:	25 ff 00 00 00       	and    $0xff,%eax
 53a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 53d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 541:	75 2c                	jne    56f <printf+0x6a>
      if(c == '%'){
 543:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 547:	75 0c                	jne    555 <printf+0x50>
        state = '%';
 549:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 550:	e9 27 01 00 00       	jmp    67c <printf+0x177>
      } else {
        putc(fd, c);
 555:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 558:	0f be c0             	movsbl %al,%eax
 55b:	83 ec 08             	sub    $0x8,%esp
 55e:	50                   	push   %eax
 55f:	ff 75 08             	pushl  0x8(%ebp)
 562:	e8 c7 fe ff ff       	call   42e <putc>
 567:	83 c4 10             	add    $0x10,%esp
 56a:	e9 0d 01 00 00       	jmp    67c <printf+0x177>
      }
    } else if(state == '%'){
 56f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 573:	0f 85 03 01 00 00    	jne    67c <printf+0x177>
      if(c == 'd'){
 579:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 57d:	75 1e                	jne    59d <printf+0x98>
        printint(fd, *ap, 10, 1);
 57f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 582:	8b 00                	mov    (%eax),%eax
 584:	6a 01                	push   $0x1
 586:	6a 0a                	push   $0xa
 588:	50                   	push   %eax
 589:	ff 75 08             	pushl  0x8(%ebp)
 58c:	e8 c0 fe ff ff       	call   451 <printint>
 591:	83 c4 10             	add    $0x10,%esp
        ap++;
 594:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 598:	e9 d8 00 00 00       	jmp    675 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 59d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5a1:	74 06                	je     5a9 <printf+0xa4>
 5a3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5a7:	75 1e                	jne    5c7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ac:	8b 00                	mov    (%eax),%eax
 5ae:	6a 00                	push   $0x0
 5b0:	6a 10                	push   $0x10
 5b2:	50                   	push   %eax
 5b3:	ff 75 08             	pushl  0x8(%ebp)
 5b6:	e8 96 fe ff ff       	call   451 <printint>
 5bb:	83 c4 10             	add    $0x10,%esp
        ap++;
 5be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c2:	e9 ae 00 00 00       	jmp    675 <printf+0x170>
      } else if(c == 's'){
 5c7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5cb:	75 43                	jne    610 <printf+0x10b>
        s = (char*)*ap;
 5cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d0:	8b 00                	mov    (%eax),%eax
 5d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5dd:	75 25                	jne    604 <printf+0xff>
          s = "(null)";
 5df:	c7 45 f4 bb 08 00 00 	movl   $0x8bb,-0xc(%ebp)
        while(*s != 0){
 5e6:	eb 1c                	jmp    604 <printf+0xff>
          putc(fd, *s);
 5e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5eb:	0f b6 00             	movzbl (%eax),%eax
 5ee:	0f be c0             	movsbl %al,%eax
 5f1:	83 ec 08             	sub    $0x8,%esp
 5f4:	50                   	push   %eax
 5f5:	ff 75 08             	pushl  0x8(%ebp)
 5f8:	e8 31 fe ff ff       	call   42e <putc>
 5fd:	83 c4 10             	add    $0x10,%esp
          s++;
 600:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 604:	8b 45 f4             	mov    -0xc(%ebp),%eax
 607:	0f b6 00             	movzbl (%eax),%eax
 60a:	84 c0                	test   %al,%al
 60c:	75 da                	jne    5e8 <printf+0xe3>
 60e:	eb 65                	jmp    675 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 610:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 614:	75 1d                	jne    633 <printf+0x12e>
        putc(fd, *ap);
 616:	8b 45 e8             	mov    -0x18(%ebp),%eax
 619:	8b 00                	mov    (%eax),%eax
 61b:	0f be c0             	movsbl %al,%eax
 61e:	83 ec 08             	sub    $0x8,%esp
 621:	50                   	push   %eax
 622:	ff 75 08             	pushl  0x8(%ebp)
 625:	e8 04 fe ff ff       	call   42e <putc>
 62a:	83 c4 10             	add    $0x10,%esp
        ap++;
 62d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 631:	eb 42                	jmp    675 <printf+0x170>
      } else if(c == '%'){
 633:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 637:	75 17                	jne    650 <printf+0x14b>
        putc(fd, c);
 639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63c:	0f be c0             	movsbl %al,%eax
 63f:	83 ec 08             	sub    $0x8,%esp
 642:	50                   	push   %eax
 643:	ff 75 08             	pushl  0x8(%ebp)
 646:	e8 e3 fd ff ff       	call   42e <putc>
 64b:	83 c4 10             	add    $0x10,%esp
 64e:	eb 25                	jmp    675 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 650:	83 ec 08             	sub    $0x8,%esp
 653:	6a 25                	push   $0x25
 655:	ff 75 08             	pushl  0x8(%ebp)
 658:	e8 d1 fd ff ff       	call   42e <putc>
 65d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 660:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 663:	0f be c0             	movsbl %al,%eax
 666:	83 ec 08             	sub    $0x8,%esp
 669:	50                   	push   %eax
 66a:	ff 75 08             	pushl  0x8(%ebp)
 66d:	e8 bc fd ff ff       	call   42e <putc>
 672:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 675:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 67c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 680:	8b 55 0c             	mov    0xc(%ebp),%edx
 683:	8b 45 f0             	mov    -0x10(%ebp),%eax
 686:	01 d0                	add    %edx,%eax
 688:	0f b6 00             	movzbl (%eax),%eax
 68b:	84 c0                	test   %al,%al
 68d:	0f 85 94 fe ff ff    	jne    527 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 693:	90                   	nop
 694:	c9                   	leave  
 695:	c3                   	ret    

00000696 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 696:	55                   	push   %ebp
 697:	89 e5                	mov    %esp,%ebp
 699:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 69c:	8b 45 08             	mov    0x8(%ebp),%eax
 69f:	83 e8 08             	sub    $0x8,%eax
 6a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a5:	a1 48 0b 00 00       	mov    0xb48,%eax
 6aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ad:	eb 24                	jmp    6d3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b2:	8b 00                	mov    (%eax),%eax
 6b4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b7:	77 12                	ja     6cb <free+0x35>
 6b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6bc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bf:	77 24                	ja     6e5 <free+0x4f>
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 00                	mov    (%eax),%eax
 6c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c9:	77 1a                	ja     6e5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ce:	8b 00                	mov    (%eax),%eax
 6d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d9:	76 d4                	jbe    6af <free+0x19>
 6db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6de:	8b 00                	mov    (%eax),%eax
 6e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e3:	76 ca                	jbe    6af <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e8:	8b 40 04             	mov    0x4(%eax),%eax
 6eb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f5:	01 c2                	add    %eax,%edx
 6f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fa:	8b 00                	mov    (%eax),%eax
 6fc:	39 c2                	cmp    %eax,%edx
 6fe:	75 24                	jne    724 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 700:	8b 45 f8             	mov    -0x8(%ebp),%eax
 703:	8b 50 04             	mov    0x4(%eax),%edx
 706:	8b 45 fc             	mov    -0x4(%ebp),%eax
 709:	8b 00                	mov    (%eax),%eax
 70b:	8b 40 04             	mov    0x4(%eax),%eax
 70e:	01 c2                	add    %eax,%edx
 710:	8b 45 f8             	mov    -0x8(%ebp),%eax
 713:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	8b 00                	mov    (%eax),%eax
 71b:	8b 10                	mov    (%eax),%edx
 71d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 720:	89 10                	mov    %edx,(%eax)
 722:	eb 0a                	jmp    72e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 10                	mov    (%eax),%edx
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	8b 40 04             	mov    0x4(%eax),%eax
 734:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	01 d0                	add    %edx,%eax
 740:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 743:	75 20                	jne    765 <free+0xcf>
    p->s.size += bp->s.size;
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 50 04             	mov    0x4(%eax),%edx
 74b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74e:	8b 40 04             	mov    0x4(%eax),%eax
 751:	01 c2                	add    %eax,%edx
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 759:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75c:	8b 10                	mov    (%eax),%edx
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	89 10                	mov    %edx,(%eax)
 763:	eb 08                	jmp    76d <free+0xd7>
  } else
    p->s.ptr = bp;
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	8b 55 f8             	mov    -0x8(%ebp),%edx
 76b:	89 10                	mov    %edx,(%eax)
  freep = p;
 76d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 770:	a3 48 0b 00 00       	mov    %eax,0xb48
}
 775:	90                   	nop
 776:	c9                   	leave  
 777:	c3                   	ret    

00000778 <morecore>:

static Header*
morecore(uint nu)
{
 778:	55                   	push   %ebp
 779:	89 e5                	mov    %esp,%ebp
 77b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 77e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 785:	77 07                	ja     78e <morecore+0x16>
    nu = 4096;
 787:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 78e:	8b 45 08             	mov    0x8(%ebp),%eax
 791:	c1 e0 03             	shl    $0x3,%eax
 794:	83 ec 0c             	sub    $0xc,%esp
 797:	50                   	push   %eax
 798:	e8 41 fc ff ff       	call   3de <sbrk>
 79d:	83 c4 10             	add    $0x10,%esp
 7a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7a3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7a7:	75 07                	jne    7b0 <morecore+0x38>
    return 0;
 7a9:	b8 00 00 00 00       	mov    $0x0,%eax
 7ae:	eb 26                	jmp    7d6 <morecore+0x5e>
  hp = (Header*)p;
 7b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b9:	8b 55 08             	mov    0x8(%ebp),%edx
 7bc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c2:	83 c0 08             	add    $0x8,%eax
 7c5:	83 ec 0c             	sub    $0xc,%esp
 7c8:	50                   	push   %eax
 7c9:	e8 c8 fe ff ff       	call   696 <free>
 7ce:	83 c4 10             	add    $0x10,%esp
  return freep;
 7d1:	a1 48 0b 00 00       	mov    0xb48,%eax
}
 7d6:	c9                   	leave  
 7d7:	c3                   	ret    

000007d8 <malloc>:

void*
malloc(uint nbytes)
{
 7d8:	55                   	push   %ebp
 7d9:	89 e5                	mov    %esp,%ebp
 7db:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7de:	8b 45 08             	mov    0x8(%ebp),%eax
 7e1:	83 c0 07             	add    $0x7,%eax
 7e4:	c1 e8 03             	shr    $0x3,%eax
 7e7:	83 c0 01             	add    $0x1,%eax
 7ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7ed:	a1 48 0b 00 00       	mov    0xb48,%eax
 7f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f9:	75 23                	jne    81e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7fb:	c7 45 f0 40 0b 00 00 	movl   $0xb40,-0x10(%ebp)
 802:	8b 45 f0             	mov    -0x10(%ebp),%eax
 805:	a3 48 0b 00 00       	mov    %eax,0xb48
 80a:	a1 48 0b 00 00       	mov    0xb48,%eax
 80f:	a3 40 0b 00 00       	mov    %eax,0xb40
    base.s.size = 0;
 814:	c7 05 44 0b 00 00 00 	movl   $0x0,0xb44
 81b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 821:	8b 00                	mov    (%eax),%eax
 823:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 826:	8b 45 f4             	mov    -0xc(%ebp),%eax
 829:	8b 40 04             	mov    0x4(%eax),%eax
 82c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 82f:	72 4d                	jb     87e <malloc+0xa6>
      if(p->s.size == nunits)
 831:	8b 45 f4             	mov    -0xc(%ebp),%eax
 834:	8b 40 04             	mov    0x4(%eax),%eax
 837:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 83a:	75 0c                	jne    848 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	8b 10                	mov    (%eax),%edx
 841:	8b 45 f0             	mov    -0x10(%ebp),%eax
 844:	89 10                	mov    %edx,(%eax)
 846:	eb 26                	jmp    86e <malloc+0x96>
      else {
        p->s.size -= nunits;
 848:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84b:	8b 40 04             	mov    0x4(%eax),%eax
 84e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 851:	89 c2                	mov    %eax,%edx
 853:	8b 45 f4             	mov    -0xc(%ebp),%eax
 856:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 859:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85c:	8b 40 04             	mov    0x4(%eax),%eax
 85f:	c1 e0 03             	shl    $0x3,%eax
 862:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	8b 55 ec             	mov    -0x14(%ebp),%edx
 86b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 86e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 871:	a3 48 0b 00 00       	mov    %eax,0xb48
      return (void*)(p + 1);
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	83 c0 08             	add    $0x8,%eax
 87c:	eb 3b                	jmp    8b9 <malloc+0xe1>
    }
    if(p == freep)
 87e:	a1 48 0b 00 00       	mov    0xb48,%eax
 883:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 886:	75 1e                	jne    8a6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 888:	83 ec 0c             	sub    $0xc,%esp
 88b:	ff 75 ec             	pushl  -0x14(%ebp)
 88e:	e8 e5 fe ff ff       	call   778 <morecore>
 893:	83 c4 10             	add    $0x10,%esp
 896:	89 45 f4             	mov    %eax,-0xc(%ebp)
 899:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 89d:	75 07                	jne    8a6 <malloc+0xce>
        return 0;
 89f:	b8 00 00 00 00       	mov    $0x0,%eax
 8a4:	eb 13                	jmp    8b9 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	8b 00                	mov    (%eax),%eax
 8b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8b4:	e9 6d ff ff ff       	jmp    826 <malloc+0x4e>
}
 8b9:	c9                   	leave  
 8ba:	c3                   	ret    
