
_halt:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// halt the system.
#include "types.h"
#include "user.h"

int
main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  halt();
  11:	e8 d8 03 00 00       	call   3ee <halt>
  return 0;
  16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1b:	83 c4 04             	add    $0x4,%esp
  1e:	59                   	pop    %ecx
  1f:	5d                   	pop    %ebp
  20:	8d 61 fc             	lea    -0x4(%ecx),%esp
  23:	c3                   	ret    

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	90                   	nop
  46:	5b                   	pop    %ebx
  47:	5f                   	pop    %edi
  48:	5d                   	pop    %ebp
  49:	c3                   	ret    

0000004a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4a:	55                   	push   %ebp
  4b:	89 e5                	mov    %esp,%ebp
  4d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  50:	8b 45 08             	mov    0x8(%ebp),%eax
  53:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  56:	90                   	nop
  57:	8b 45 08             	mov    0x8(%ebp),%eax
  5a:	8d 50 01             	lea    0x1(%eax),%edx
  5d:	89 55 08             	mov    %edx,0x8(%ebp)
  60:	8b 55 0c             	mov    0xc(%ebp),%edx
  63:	8d 4a 01             	lea    0x1(%edx),%ecx
  66:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  69:	0f b6 12             	movzbl (%edx),%edx
  6c:	88 10                	mov    %dl,(%eax)
  6e:	0f b6 00             	movzbl (%eax),%eax
  71:	84 c0                	test   %al,%al
  73:	75 e2                	jne    57 <strcpy+0xd>
    ;
  return os;
  75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  78:	c9                   	leave  
  79:	c3                   	ret    

0000007a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7a:	55                   	push   %ebp
  7b:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7d:	eb 08                	jmp    87 <strcmp+0xd>
    p++, q++;
  7f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  83:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  87:	8b 45 08             	mov    0x8(%ebp),%eax
  8a:	0f b6 00             	movzbl (%eax),%eax
  8d:	84 c0                	test   %al,%al
  8f:	74 10                	je     a1 <strcmp+0x27>
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	0f b6 10             	movzbl (%eax),%edx
  97:	8b 45 0c             	mov    0xc(%ebp),%eax
  9a:	0f b6 00             	movzbl (%eax),%eax
  9d:	38 c2                	cmp    %al,%dl
  9f:	74 de                	je     7f <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a1:	8b 45 08             	mov    0x8(%ebp),%eax
  a4:	0f b6 00             	movzbl (%eax),%eax
  a7:	0f b6 d0             	movzbl %al,%edx
  aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  ad:	0f b6 00             	movzbl (%eax),%eax
  b0:	0f b6 c0             	movzbl %al,%eax
  b3:	29 c2                	sub    %eax,%edx
  b5:	89 d0                	mov    %edx,%eax
}
  b7:	5d                   	pop    %ebp
  b8:	c3                   	ret    

000000b9 <strlen>:

uint
strlen(char *s)
{
  b9:	55                   	push   %ebp
  ba:	89 e5                	mov    %esp,%ebp
  bc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c6:	eb 04                	jmp    cc <strlen+0x13>
  c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	01 d0                	add    %edx,%eax
  d4:	0f b6 00             	movzbl (%eax),%eax
  d7:	84 c0                	test   %al,%al
  d9:	75 ed                	jne    c8 <strlen+0xf>
    ;
  return n;
  db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  de:	c9                   	leave  
  df:	c3                   	ret    

000000e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e3:	8b 45 10             	mov    0x10(%ebp),%eax
  e6:	50                   	push   %eax
  e7:	ff 75 0c             	pushl  0xc(%ebp)
  ea:	ff 75 08             	pushl  0x8(%ebp)
  ed:	e8 32 ff ff ff       	call   24 <stosb>
  f2:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f8:	c9                   	leave  
  f9:	c3                   	ret    

000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 04             	sub    $0x4,%esp
 100:	8b 45 0c             	mov    0xc(%ebp),%eax
 103:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 106:	eb 14                	jmp    11c <strchr+0x22>
    if(*s == c)
 108:	8b 45 08             	mov    0x8(%ebp),%eax
 10b:	0f b6 00             	movzbl (%eax),%eax
 10e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 111:	75 05                	jne    118 <strchr+0x1e>
      return (char*)s;
 113:	8b 45 08             	mov    0x8(%ebp),%eax
 116:	eb 13                	jmp    12b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 118:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	0f b6 00             	movzbl (%eax),%eax
 122:	84 c0                	test   %al,%al
 124:	75 e2                	jne    108 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 126:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12b:	c9                   	leave  
 12c:	c3                   	ret    

0000012d <gets>:

char*
gets(char *buf, int max)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 133:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13a:	eb 42                	jmp    17e <gets+0x51>
    cc = read(0, &c, 1);
 13c:	83 ec 04             	sub    $0x4,%esp
 13f:	6a 01                	push   $0x1
 141:	8d 45 ef             	lea    -0x11(%ebp),%eax
 144:	50                   	push   %eax
 145:	6a 00                	push   $0x0
 147:	e8 1a 02 00 00       	call   366 <read>
 14c:	83 c4 10             	add    $0x10,%esp
 14f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 152:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 156:	7e 33                	jle    18b <gets+0x5e>
      break;
    buf[i++] = c;
 158:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15b:	8d 50 01             	lea    0x1(%eax),%edx
 15e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 161:	89 c2                	mov    %eax,%edx
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	01 c2                	add    %eax,%edx
 168:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 16c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 16e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 172:	3c 0a                	cmp    $0xa,%al
 174:	74 16                	je     18c <gets+0x5f>
 176:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17a:	3c 0d                	cmp    $0xd,%al
 17c:	74 0e                	je     18c <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 181:	83 c0 01             	add    $0x1,%eax
 184:	3b 45 0c             	cmp    0xc(%ebp),%eax
 187:	7c b3                	jl     13c <gets+0xf>
 189:	eb 01                	jmp    18c <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 18b:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 18c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18f:	8b 45 08             	mov    0x8(%ebp),%eax
 192:	01 d0                	add    %edx,%eax
 194:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 197:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19a:	c9                   	leave  
 19b:	c3                   	ret    

0000019c <stat>:

int
stat(char *n, struct stat *st)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a2:	83 ec 08             	sub    $0x8,%esp
 1a5:	6a 00                	push   $0x0
 1a7:	ff 75 08             	pushl  0x8(%ebp)
 1aa:	e8 df 01 00 00       	call   38e <open>
 1af:	83 c4 10             	add    $0x10,%esp
 1b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b9:	79 07                	jns    1c2 <stat+0x26>
    return -1;
 1bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c0:	eb 25                	jmp    1e7 <stat+0x4b>
  r = fstat(fd, st);
 1c2:	83 ec 08             	sub    $0x8,%esp
 1c5:	ff 75 0c             	pushl  0xc(%ebp)
 1c8:	ff 75 f4             	pushl  -0xc(%ebp)
 1cb:	e8 d6 01 00 00       	call   3a6 <fstat>
 1d0:	83 c4 10             	add    $0x10,%esp
 1d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d6:	83 ec 0c             	sub    $0xc,%esp
 1d9:	ff 75 f4             	pushl  -0xc(%ebp)
 1dc:	e8 95 01 00 00       	call   376 <close>
 1e1:	83 c4 10             	add    $0x10,%esp
  return r;
 1e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e7:	c9                   	leave  
 1e8:	c3                   	ret    

000001e9 <atoi>:

int
atoi(const char *s)
{
 1e9:	55                   	push   %ebp
 1ea:	89 e5                	mov    %esp,%ebp
 1ec:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 1ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 1f6:	eb 04                	jmp    1fc <atoi+0x13>
 1f8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	0f b6 00             	movzbl (%eax),%eax
 202:	3c 20                	cmp    $0x20,%al
 204:	74 f2                	je     1f8 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 206:	8b 45 08             	mov    0x8(%ebp),%eax
 209:	0f b6 00             	movzbl (%eax),%eax
 20c:	3c 2d                	cmp    $0x2d,%al
 20e:	75 07                	jne    217 <atoi+0x2e>
 210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 215:	eb 05                	jmp    21c <atoi+0x33>
 217:	b8 01 00 00 00       	mov    $0x1,%eax
 21c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 00             	movzbl (%eax),%eax
 225:	3c 2b                	cmp    $0x2b,%al
 227:	74 0a                	je     233 <atoi+0x4a>
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	0f b6 00             	movzbl (%eax),%eax
 22f:	3c 2d                	cmp    $0x2d,%al
 231:	75 2b                	jne    25e <atoi+0x75>
    s++;
 233:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 237:	eb 25                	jmp    25e <atoi+0x75>
    n = n*10 + *s++ - '0';
 239:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23c:	89 d0                	mov    %edx,%eax
 23e:	c1 e0 02             	shl    $0x2,%eax
 241:	01 d0                	add    %edx,%eax
 243:	01 c0                	add    %eax,%eax
 245:	89 c1                	mov    %eax,%ecx
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8d 50 01             	lea    0x1(%eax),%edx
 24d:	89 55 08             	mov    %edx,0x8(%ebp)
 250:	0f b6 00             	movzbl (%eax),%eax
 253:	0f be c0             	movsbl %al,%eax
 256:	01 c8                	add    %ecx,%eax
 258:	83 e8 30             	sub    $0x30,%eax
 25b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	3c 2f                	cmp    $0x2f,%al
 266:	7e 0a                	jle    272 <atoi+0x89>
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 39                	cmp    $0x39,%al
 270:	7e c7                	jle    239 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 272:	8b 45 f8             	mov    -0x8(%ebp),%eax
 275:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <atoo>:

int
atoo(const char *s)
{
 27b:	55                   	push   %ebp
 27c:	89 e5                	mov    %esp,%ebp
 27e:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 281:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 288:	eb 04                	jmp    28e <atoo+0x13>
 28a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	0f b6 00             	movzbl (%eax),%eax
 294:	3c 20                	cmp    $0x20,%al
 296:	74 f2                	je     28a <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	0f b6 00             	movzbl (%eax),%eax
 29e:	3c 2d                	cmp    $0x2d,%al
 2a0:	75 07                	jne    2a9 <atoo+0x2e>
 2a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a7:	eb 05                	jmp    2ae <atoo+0x33>
 2a9:	b8 01 00 00 00       	mov    $0x1,%eax
 2ae:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	0f b6 00             	movzbl (%eax),%eax
 2b7:	3c 2b                	cmp    $0x2b,%al
 2b9:	74 0a                	je     2c5 <atoo+0x4a>
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
 2be:	0f b6 00             	movzbl (%eax),%eax
 2c1:	3c 2d                	cmp    $0x2d,%al
 2c3:	75 27                	jne    2ec <atoo+0x71>
    s++;
 2c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 2c9:	eb 21                	jmp    2ec <atoo+0x71>
    n = n*8 + *s++ - '0';
 2cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ce:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	8d 50 01             	lea    0x1(%eax),%edx
 2db:	89 55 08             	mov    %edx,0x8(%ebp)
 2de:	0f b6 00             	movzbl (%eax),%eax
 2e1:	0f be c0             	movsbl %al,%eax
 2e4:	01 c8                	add    %ecx,%eax
 2e6:	83 e8 30             	sub    $0x30,%eax
 2e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	0f b6 00             	movzbl (%eax),%eax
 2f2:	3c 2f                	cmp    $0x2f,%al
 2f4:	7e 0a                	jle    300 <atoo+0x85>
 2f6:	8b 45 08             	mov    0x8(%ebp),%eax
 2f9:	0f b6 00             	movzbl (%eax),%eax
 2fc:	3c 37                	cmp    $0x37,%al
 2fe:	7e cb                	jle    2cb <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 300:	8b 45 f8             	mov    -0x8(%ebp),%eax
 303:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 307:	c9                   	leave  
 308:	c3                   	ret    

00000309 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 309:	55                   	push   %ebp
 30a:	89 e5                	mov    %esp,%ebp
 30c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 315:	8b 45 0c             	mov    0xc(%ebp),%eax
 318:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 31b:	eb 17                	jmp    334 <memmove+0x2b>
    *dst++ = *src++;
 31d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 320:	8d 50 01             	lea    0x1(%eax),%edx
 323:	89 55 fc             	mov    %edx,-0x4(%ebp)
 326:	8b 55 f8             	mov    -0x8(%ebp),%edx
 329:	8d 4a 01             	lea    0x1(%edx),%ecx
 32c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 32f:	0f b6 12             	movzbl (%edx),%edx
 332:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 334:	8b 45 10             	mov    0x10(%ebp),%eax
 337:	8d 50 ff             	lea    -0x1(%eax),%edx
 33a:	89 55 10             	mov    %edx,0x10(%ebp)
 33d:	85 c0                	test   %eax,%eax
 33f:	7f dc                	jg     31d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 341:	8b 45 08             	mov    0x8(%ebp),%eax
}
 344:	c9                   	leave  
 345:	c3                   	ret    

00000346 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 346:	b8 01 00 00 00       	mov    $0x1,%eax
 34b:	cd 40                	int    $0x40
 34d:	c3                   	ret    

0000034e <exit>:
SYSCALL(exit)
 34e:	b8 02 00 00 00       	mov    $0x2,%eax
 353:	cd 40                	int    $0x40
 355:	c3                   	ret    

00000356 <wait>:
SYSCALL(wait)
 356:	b8 03 00 00 00       	mov    $0x3,%eax
 35b:	cd 40                	int    $0x40
 35d:	c3                   	ret    

0000035e <pipe>:
SYSCALL(pipe)
 35e:	b8 04 00 00 00       	mov    $0x4,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <read>:
SYSCALL(read)
 366:	b8 05 00 00 00       	mov    $0x5,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <write>:
SYSCALL(write)
 36e:	b8 10 00 00 00       	mov    $0x10,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <close>:
SYSCALL(close)
 376:	b8 15 00 00 00       	mov    $0x15,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <kill>:
SYSCALL(kill)
 37e:	b8 06 00 00 00       	mov    $0x6,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <exec>:
SYSCALL(exec)
 386:	b8 07 00 00 00       	mov    $0x7,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <open>:
SYSCALL(open)
 38e:	b8 0f 00 00 00       	mov    $0xf,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <mknod>:
SYSCALL(mknod)
 396:	b8 11 00 00 00       	mov    $0x11,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <unlink>:
SYSCALL(unlink)
 39e:	b8 12 00 00 00       	mov    $0x12,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <fstat>:
SYSCALL(fstat)
 3a6:	b8 08 00 00 00       	mov    $0x8,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <link>:
SYSCALL(link)
 3ae:	b8 13 00 00 00       	mov    $0x13,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <mkdir>:
SYSCALL(mkdir)
 3b6:	b8 14 00 00 00       	mov    $0x14,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <chdir>:
SYSCALL(chdir)
 3be:	b8 09 00 00 00       	mov    $0x9,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <dup>:
SYSCALL(dup)
 3c6:	b8 0a 00 00 00       	mov    $0xa,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <getpid>:
SYSCALL(getpid)
 3ce:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <sbrk>:
SYSCALL(sbrk)
 3d6:	b8 0c 00 00 00       	mov    $0xc,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <sleep>:
SYSCALL(sleep)
 3de:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <uptime>:
SYSCALL(uptime)
 3e6:	b8 0e 00 00 00       	mov    $0xe,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <halt>:
SYSCALL(halt)
 3ee:	b8 16 00 00 00       	mov    $0x16,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <date>:
SYSCALL(date)
 3f6:	b8 17 00 00 00       	mov    $0x17,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3fe:	55                   	push   %ebp
 3ff:	89 e5                	mov    %esp,%ebp
 401:	83 ec 18             	sub    $0x18,%esp
 404:	8b 45 0c             	mov    0xc(%ebp),%eax
 407:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 40a:	83 ec 04             	sub    $0x4,%esp
 40d:	6a 01                	push   $0x1
 40f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 412:	50                   	push   %eax
 413:	ff 75 08             	pushl  0x8(%ebp)
 416:	e8 53 ff ff ff       	call   36e <write>
 41b:	83 c4 10             	add    $0x10,%esp
}
 41e:	90                   	nop
 41f:	c9                   	leave  
 420:	c3                   	ret    

00000421 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 421:	55                   	push   %ebp
 422:	89 e5                	mov    %esp,%ebp
 424:	53                   	push   %ebx
 425:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 428:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 42f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 433:	74 17                	je     44c <printint+0x2b>
 435:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 439:	79 11                	jns    44c <printint+0x2b>
    neg = 1;
 43b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 442:	8b 45 0c             	mov    0xc(%ebp),%eax
 445:	f7 d8                	neg    %eax
 447:	89 45 ec             	mov    %eax,-0x14(%ebp)
 44a:	eb 06                	jmp    452 <printint+0x31>
  } else {
    x = xx;
 44c:	8b 45 0c             	mov    0xc(%ebp),%eax
 44f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 452:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 459:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 45c:	8d 41 01             	lea    0x1(%ecx),%eax
 45f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 462:	8b 5d 10             	mov    0x10(%ebp),%ebx
 465:	8b 45 ec             	mov    -0x14(%ebp),%eax
 468:	ba 00 00 00 00       	mov    $0x0,%edx
 46d:	f7 f3                	div    %ebx
 46f:	89 d0                	mov    %edx,%eax
 471:	0f b6 80 04 0b 00 00 	movzbl 0xb04(%eax),%eax
 478:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 47c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 47f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 482:	ba 00 00 00 00       	mov    $0x0,%edx
 487:	f7 f3                	div    %ebx
 489:	89 45 ec             	mov    %eax,-0x14(%ebp)
 48c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 490:	75 c7                	jne    459 <printint+0x38>
  if(neg)
 492:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 496:	74 2d                	je     4c5 <printint+0xa4>
    buf[i++] = '-';
 498:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49b:	8d 50 01             	lea    0x1(%eax),%edx
 49e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4a1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4a6:	eb 1d                	jmp    4c5 <printint+0xa4>
    putc(fd, buf[i]);
 4a8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ae:	01 d0                	add    %edx,%eax
 4b0:	0f b6 00             	movzbl (%eax),%eax
 4b3:	0f be c0             	movsbl %al,%eax
 4b6:	83 ec 08             	sub    $0x8,%esp
 4b9:	50                   	push   %eax
 4ba:	ff 75 08             	pushl  0x8(%ebp)
 4bd:	e8 3c ff ff ff       	call   3fe <putc>
 4c2:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4c5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4cd:	79 d9                	jns    4a8 <printint+0x87>
    putc(fd, buf[i]);
}
 4cf:	90                   	nop
 4d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4d3:	c9                   	leave  
 4d4:	c3                   	ret    

000004d5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4d5:	55                   	push   %ebp
 4d6:	89 e5                	mov    %esp,%ebp
 4d8:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 4db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4e2:	8d 45 0c             	lea    0xc(%ebp),%eax
 4e5:	83 c0 04             	add    $0x4,%eax
 4e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4f2:	e9 59 01 00 00       	jmp    650 <printf+0x17b>
    c = fmt[i] & 0xff;
 4f7:	8b 55 0c             	mov    0xc(%ebp),%edx
 4fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4fd:	01 d0                	add    %edx,%eax
 4ff:	0f b6 00             	movzbl (%eax),%eax
 502:	0f be c0             	movsbl %al,%eax
 505:	25 ff 00 00 00       	and    $0xff,%eax
 50a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 50d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 511:	75 2c                	jne    53f <printf+0x6a>
      if(c == '%'){
 513:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 517:	75 0c                	jne    525 <printf+0x50>
        state = '%';
 519:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 520:	e9 27 01 00 00       	jmp    64c <printf+0x177>
      } else {
        putc(fd, c);
 525:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 528:	0f be c0             	movsbl %al,%eax
 52b:	83 ec 08             	sub    $0x8,%esp
 52e:	50                   	push   %eax
 52f:	ff 75 08             	pushl  0x8(%ebp)
 532:	e8 c7 fe ff ff       	call   3fe <putc>
 537:	83 c4 10             	add    $0x10,%esp
 53a:	e9 0d 01 00 00       	jmp    64c <printf+0x177>
      }
    } else if(state == '%'){
 53f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 543:	0f 85 03 01 00 00    	jne    64c <printf+0x177>
      if(c == 'd'){
 549:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 54d:	75 1e                	jne    56d <printf+0x98>
        printint(fd, *ap, 10, 1);
 54f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 552:	8b 00                	mov    (%eax),%eax
 554:	6a 01                	push   $0x1
 556:	6a 0a                	push   $0xa
 558:	50                   	push   %eax
 559:	ff 75 08             	pushl  0x8(%ebp)
 55c:	e8 c0 fe ff ff       	call   421 <printint>
 561:	83 c4 10             	add    $0x10,%esp
        ap++;
 564:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 568:	e9 d8 00 00 00       	jmp    645 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 56d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 571:	74 06                	je     579 <printf+0xa4>
 573:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 577:	75 1e                	jne    597 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 579:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57c:	8b 00                	mov    (%eax),%eax
 57e:	6a 00                	push   $0x0
 580:	6a 10                	push   $0x10
 582:	50                   	push   %eax
 583:	ff 75 08             	pushl  0x8(%ebp)
 586:	e8 96 fe ff ff       	call   421 <printint>
 58b:	83 c4 10             	add    $0x10,%esp
        ap++;
 58e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 592:	e9 ae 00 00 00       	jmp    645 <printf+0x170>
      } else if(c == 's'){
 597:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 59b:	75 43                	jne    5e0 <printf+0x10b>
        s = (char*)*ap;
 59d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a0:	8b 00                	mov    (%eax),%eax
 5a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5a5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ad:	75 25                	jne    5d4 <printf+0xff>
          s = "(null)";
 5af:	c7 45 f4 8b 08 00 00 	movl   $0x88b,-0xc(%ebp)
        while(*s != 0){
 5b6:	eb 1c                	jmp    5d4 <printf+0xff>
          putc(fd, *s);
 5b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bb:	0f b6 00             	movzbl (%eax),%eax
 5be:	0f be c0             	movsbl %al,%eax
 5c1:	83 ec 08             	sub    $0x8,%esp
 5c4:	50                   	push   %eax
 5c5:	ff 75 08             	pushl  0x8(%ebp)
 5c8:	e8 31 fe ff ff       	call   3fe <putc>
 5cd:	83 c4 10             	add    $0x10,%esp
          s++;
 5d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d7:	0f b6 00             	movzbl (%eax),%eax
 5da:	84 c0                	test   %al,%al
 5dc:	75 da                	jne    5b8 <printf+0xe3>
 5de:	eb 65                	jmp    645 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5e0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5e4:	75 1d                	jne    603 <printf+0x12e>
        putc(fd, *ap);
 5e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e9:	8b 00                	mov    (%eax),%eax
 5eb:	0f be c0             	movsbl %al,%eax
 5ee:	83 ec 08             	sub    $0x8,%esp
 5f1:	50                   	push   %eax
 5f2:	ff 75 08             	pushl  0x8(%ebp)
 5f5:	e8 04 fe ff ff       	call   3fe <putc>
 5fa:	83 c4 10             	add    $0x10,%esp
        ap++;
 5fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 601:	eb 42                	jmp    645 <printf+0x170>
      } else if(c == '%'){
 603:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 607:	75 17                	jne    620 <printf+0x14b>
        putc(fd, c);
 609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 60c:	0f be c0             	movsbl %al,%eax
 60f:	83 ec 08             	sub    $0x8,%esp
 612:	50                   	push   %eax
 613:	ff 75 08             	pushl  0x8(%ebp)
 616:	e8 e3 fd ff ff       	call   3fe <putc>
 61b:	83 c4 10             	add    $0x10,%esp
 61e:	eb 25                	jmp    645 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 620:	83 ec 08             	sub    $0x8,%esp
 623:	6a 25                	push   $0x25
 625:	ff 75 08             	pushl  0x8(%ebp)
 628:	e8 d1 fd ff ff       	call   3fe <putc>
 62d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 633:	0f be c0             	movsbl %al,%eax
 636:	83 ec 08             	sub    $0x8,%esp
 639:	50                   	push   %eax
 63a:	ff 75 08             	pushl  0x8(%ebp)
 63d:	e8 bc fd ff ff       	call   3fe <putc>
 642:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 645:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 64c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 650:	8b 55 0c             	mov    0xc(%ebp),%edx
 653:	8b 45 f0             	mov    -0x10(%ebp),%eax
 656:	01 d0                	add    %edx,%eax
 658:	0f b6 00             	movzbl (%eax),%eax
 65b:	84 c0                	test   %al,%al
 65d:	0f 85 94 fe ff ff    	jne    4f7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 663:	90                   	nop
 664:	c9                   	leave  
 665:	c3                   	ret    

00000666 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 666:	55                   	push   %ebp
 667:	89 e5                	mov    %esp,%ebp
 669:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 66c:	8b 45 08             	mov    0x8(%ebp),%eax
 66f:	83 e8 08             	sub    $0x8,%eax
 672:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 675:	a1 20 0b 00 00       	mov    0xb20,%eax
 67a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 67d:	eb 24                	jmp    6a3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 00                	mov    (%eax),%eax
 684:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 687:	77 12                	ja     69b <free+0x35>
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68f:	77 24                	ja     6b5 <free+0x4f>
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 699:	77 1a                	ja     6b5 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	8b 00                	mov    (%eax),%eax
 6a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6a9:	76 d4                	jbe    67f <free+0x19>
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6b3:	76 ca                	jbe    67f <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	8b 40 04             	mov    0x4(%eax),%eax
 6bb:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	01 c2                	add    %eax,%edx
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	39 c2                	cmp    %eax,%edx
 6ce:	75 24                	jne    6f4 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d3:	8b 50 04             	mov    0x4(%eax),%edx
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	8b 40 04             	mov    0x4(%eax),%eax
 6de:	01 c2                	add    %eax,%edx
 6e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e3:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e9:	8b 00                	mov    (%eax),%eax
 6eb:	8b 10                	mov    (%eax),%edx
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	89 10                	mov    %edx,(%eax)
 6f2:	eb 0a                	jmp    6fe <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f7:	8b 10                	mov    (%eax),%edx
 6f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fc:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 701:	8b 40 04             	mov    0x4(%eax),%eax
 704:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 70b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70e:	01 d0                	add    %edx,%eax
 710:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 713:	75 20                	jne    735 <free+0xcf>
    p->s.size += bp->s.size;
 715:	8b 45 fc             	mov    -0x4(%ebp),%eax
 718:	8b 50 04             	mov    0x4(%eax),%edx
 71b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71e:	8b 40 04             	mov    0x4(%eax),%eax
 721:	01 c2                	add    %eax,%edx
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 729:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72c:	8b 10                	mov    (%eax),%edx
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	89 10                	mov    %edx,(%eax)
 733:	eb 08                	jmp    73d <free+0xd7>
  } else
    p->s.ptr = bp;
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	8b 55 f8             	mov    -0x8(%ebp),%edx
 73b:	89 10                	mov    %edx,(%eax)
  freep = p;
 73d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 740:	a3 20 0b 00 00       	mov    %eax,0xb20
}
 745:	90                   	nop
 746:	c9                   	leave  
 747:	c3                   	ret    

00000748 <morecore>:

static Header*
morecore(uint nu)
{
 748:	55                   	push   %ebp
 749:	89 e5                	mov    %esp,%ebp
 74b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 74e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 755:	77 07                	ja     75e <morecore+0x16>
    nu = 4096;
 757:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	c1 e0 03             	shl    $0x3,%eax
 764:	83 ec 0c             	sub    $0xc,%esp
 767:	50                   	push   %eax
 768:	e8 69 fc ff ff       	call   3d6 <sbrk>
 76d:	83 c4 10             	add    $0x10,%esp
 770:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 773:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 777:	75 07                	jne    780 <morecore+0x38>
    return 0;
 779:	b8 00 00 00 00       	mov    $0x0,%eax
 77e:	eb 26                	jmp    7a6 <morecore+0x5e>
  hp = (Header*)p;
 780:	8b 45 f4             	mov    -0xc(%ebp),%eax
 783:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 786:	8b 45 f0             	mov    -0x10(%ebp),%eax
 789:	8b 55 08             	mov    0x8(%ebp),%edx
 78c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 78f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 792:	83 c0 08             	add    $0x8,%eax
 795:	83 ec 0c             	sub    $0xc,%esp
 798:	50                   	push   %eax
 799:	e8 c8 fe ff ff       	call   666 <free>
 79e:	83 c4 10             	add    $0x10,%esp
  return freep;
 7a1:	a1 20 0b 00 00       	mov    0xb20,%eax
}
 7a6:	c9                   	leave  
 7a7:	c3                   	ret    

000007a8 <malloc>:

void*
malloc(uint nbytes)
{
 7a8:	55                   	push   %ebp
 7a9:	89 e5                	mov    %esp,%ebp
 7ab:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ae:	8b 45 08             	mov    0x8(%ebp),%eax
 7b1:	83 c0 07             	add    $0x7,%eax
 7b4:	c1 e8 03             	shr    $0x3,%eax
 7b7:	83 c0 01             	add    $0x1,%eax
 7ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7bd:	a1 20 0b 00 00       	mov    0xb20,%eax
 7c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7c9:	75 23                	jne    7ee <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7cb:	c7 45 f0 18 0b 00 00 	movl   $0xb18,-0x10(%ebp)
 7d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d5:	a3 20 0b 00 00       	mov    %eax,0xb20
 7da:	a1 20 0b 00 00       	mov    0xb20,%eax
 7df:	a3 18 0b 00 00       	mov    %eax,0xb18
    base.s.size = 0;
 7e4:	c7 05 1c 0b 00 00 00 	movl   $0x0,0xb1c
 7eb:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f1:	8b 00                	mov    (%eax),%eax
 7f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	8b 40 04             	mov    0x4(%eax),%eax
 7fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7ff:	72 4d                	jb     84e <malloc+0xa6>
      if(p->s.size == nunits)
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	8b 40 04             	mov    0x4(%eax),%eax
 807:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 80a:	75 0c                	jne    818 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80f:	8b 10                	mov    (%eax),%edx
 811:	8b 45 f0             	mov    -0x10(%ebp),%eax
 814:	89 10                	mov    %edx,(%eax)
 816:	eb 26                	jmp    83e <malloc+0x96>
      else {
        p->s.size -= nunits;
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	8b 40 04             	mov    0x4(%eax),%eax
 81e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 821:	89 c2                	mov    %eax,%edx
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	8b 40 04             	mov    0x4(%eax),%eax
 82f:	c1 e0 03             	shl    $0x3,%eax
 832:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8b 55 ec             	mov    -0x14(%ebp),%edx
 83b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 83e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 841:	a3 20 0b 00 00       	mov    %eax,0xb20
      return (void*)(p + 1);
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	83 c0 08             	add    $0x8,%eax
 84c:	eb 3b                	jmp    889 <malloc+0xe1>
    }
    if(p == freep)
 84e:	a1 20 0b 00 00       	mov    0xb20,%eax
 853:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 856:	75 1e                	jne    876 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 858:	83 ec 0c             	sub    $0xc,%esp
 85b:	ff 75 ec             	pushl  -0x14(%ebp)
 85e:	e8 e5 fe ff ff       	call   748 <morecore>
 863:	83 c4 10             	add    $0x10,%esp
 866:	89 45 f4             	mov    %eax,-0xc(%ebp)
 869:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86d:	75 07                	jne    876 <malloc+0xce>
        return 0;
 86f:	b8 00 00 00 00       	mov    $0x0,%eax
 874:	eb 13                	jmp    889 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	89 45 f0             	mov    %eax,-0x10(%ebp)
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	8b 00                	mov    (%eax),%eax
 881:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 884:	e9 6d ff ff ff       	jmp    7f6 <malloc+0x4e>
}
 889:	c9                   	leave  
 88a:	c3                   	ret    
