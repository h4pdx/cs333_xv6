
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

000003fe <getuid>:
SYSCALL(getuid)
 3fe:	b8 18 00 00 00       	mov    $0x18,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <getgid>:
SYSCALL(getgid)
 406:	b8 19 00 00 00       	mov    $0x19,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <getppid>:
SYSCALL(getppid)
 40e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <setuid>:
SYSCALL(setuid)
 416:	b8 1b 00 00 00       	mov    $0x1b,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <setgid>:
SYSCALL(setgid)
 41e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <getprocs>:
SYSCALL(getprocs)
 426:	b8 1d 00 00 00       	mov    $0x1d,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <setpriority>:
SYSCALL(setpriority)
 42e:	b8 1e 00 00 00       	mov    $0x1e,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <chmod>:
SYSCALL(chmod)
 436:	b8 1f 00 00 00       	mov    $0x1f,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <chown>:
SYSCALL(chown)
 43e:	b8 20 00 00 00       	mov    $0x20,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <chgrp>:
SYSCALL(chgrp)
 446:	b8 21 00 00 00       	mov    $0x21,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 44e:	55                   	push   %ebp
 44f:	89 e5                	mov    %esp,%ebp
 451:	83 ec 18             	sub    $0x18,%esp
 454:	8b 45 0c             	mov    0xc(%ebp),%eax
 457:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 45a:	83 ec 04             	sub    $0x4,%esp
 45d:	6a 01                	push   $0x1
 45f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 462:	50                   	push   %eax
 463:	ff 75 08             	pushl  0x8(%ebp)
 466:	e8 03 ff ff ff       	call   36e <write>
 46b:	83 c4 10             	add    $0x10,%esp
}
 46e:	90                   	nop
 46f:	c9                   	leave  
 470:	c3                   	ret    

00000471 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 471:	55                   	push   %ebp
 472:	89 e5                	mov    %esp,%ebp
 474:	53                   	push   %ebx
 475:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 478:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 47f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 483:	74 17                	je     49c <printint+0x2b>
 485:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 489:	79 11                	jns    49c <printint+0x2b>
    neg = 1;
 48b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 492:	8b 45 0c             	mov    0xc(%ebp),%eax
 495:	f7 d8                	neg    %eax
 497:	89 45 ec             	mov    %eax,-0x14(%ebp)
 49a:	eb 06                	jmp    4a2 <printint+0x31>
  } else {
    x = xx;
 49c:	8b 45 0c             	mov    0xc(%ebp),%eax
 49f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4a9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4ac:	8d 41 01             	lea    0x1(%ecx),%eax
 4af:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4b8:	ba 00 00 00 00       	mov    $0x0,%edx
 4bd:	f7 f3                	div    %ebx
 4bf:	89 d0                	mov    %edx,%eax
 4c1:	0f b6 80 54 0b 00 00 	movzbl 0xb54(%eax),%eax
 4c8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d2:	ba 00 00 00 00       	mov    $0x0,%edx
 4d7:	f7 f3                	div    %ebx
 4d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4e0:	75 c7                	jne    4a9 <printint+0x38>
  if(neg)
 4e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e6:	74 2d                	je     515 <printint+0xa4>
    buf[i++] = '-';
 4e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4eb:	8d 50 01             	lea    0x1(%eax),%edx
 4ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4f1:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4f6:	eb 1d                	jmp    515 <printint+0xa4>
    putc(fd, buf[i]);
 4f8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fe:	01 d0                	add    %edx,%eax
 500:	0f b6 00             	movzbl (%eax),%eax
 503:	0f be c0             	movsbl %al,%eax
 506:	83 ec 08             	sub    $0x8,%esp
 509:	50                   	push   %eax
 50a:	ff 75 08             	pushl  0x8(%ebp)
 50d:	e8 3c ff ff ff       	call   44e <putc>
 512:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 515:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 51d:	79 d9                	jns    4f8 <printint+0x87>
    putc(fd, buf[i]);
}
 51f:	90                   	nop
 520:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 523:	c9                   	leave  
 524:	c3                   	ret    

00000525 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 525:	55                   	push   %ebp
 526:	89 e5                	mov    %esp,%ebp
 528:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 52b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 532:	8d 45 0c             	lea    0xc(%ebp),%eax
 535:	83 c0 04             	add    $0x4,%eax
 538:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 53b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 542:	e9 59 01 00 00       	jmp    6a0 <printf+0x17b>
    c = fmt[i] & 0xff;
 547:	8b 55 0c             	mov    0xc(%ebp),%edx
 54a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 54d:	01 d0                	add    %edx,%eax
 54f:	0f b6 00             	movzbl (%eax),%eax
 552:	0f be c0             	movsbl %al,%eax
 555:	25 ff 00 00 00       	and    $0xff,%eax
 55a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 55d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 561:	75 2c                	jne    58f <printf+0x6a>
      if(c == '%'){
 563:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 567:	75 0c                	jne    575 <printf+0x50>
        state = '%';
 569:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 570:	e9 27 01 00 00       	jmp    69c <printf+0x177>
      } else {
        putc(fd, c);
 575:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 578:	0f be c0             	movsbl %al,%eax
 57b:	83 ec 08             	sub    $0x8,%esp
 57e:	50                   	push   %eax
 57f:	ff 75 08             	pushl  0x8(%ebp)
 582:	e8 c7 fe ff ff       	call   44e <putc>
 587:	83 c4 10             	add    $0x10,%esp
 58a:	e9 0d 01 00 00       	jmp    69c <printf+0x177>
      }
    } else if(state == '%'){
 58f:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 593:	0f 85 03 01 00 00    	jne    69c <printf+0x177>
      if(c == 'd'){
 599:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 59d:	75 1e                	jne    5bd <printf+0x98>
        printint(fd, *ap, 10, 1);
 59f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a2:	8b 00                	mov    (%eax),%eax
 5a4:	6a 01                	push   $0x1
 5a6:	6a 0a                	push   $0xa
 5a8:	50                   	push   %eax
 5a9:	ff 75 08             	pushl  0x8(%ebp)
 5ac:	e8 c0 fe ff ff       	call   471 <printint>
 5b1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b8:	e9 d8 00 00 00       	jmp    695 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5bd:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5c1:	74 06                	je     5c9 <printf+0xa4>
 5c3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5c7:	75 1e                	jne    5e7 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cc:	8b 00                	mov    (%eax),%eax
 5ce:	6a 00                	push   $0x0
 5d0:	6a 10                	push   $0x10
 5d2:	50                   	push   %eax
 5d3:	ff 75 08             	pushl  0x8(%ebp)
 5d6:	e8 96 fe ff ff       	call   471 <printint>
 5db:	83 c4 10             	add    $0x10,%esp
        ap++;
 5de:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e2:	e9 ae 00 00 00       	jmp    695 <printf+0x170>
      } else if(c == 's'){
 5e7:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5eb:	75 43                	jne    630 <printf+0x10b>
        s = (char*)*ap;
 5ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5fd:	75 25                	jne    624 <printf+0xff>
          s = "(null)";
 5ff:	c7 45 f4 db 08 00 00 	movl   $0x8db,-0xc(%ebp)
        while(*s != 0){
 606:	eb 1c                	jmp    624 <printf+0xff>
          putc(fd, *s);
 608:	8b 45 f4             	mov    -0xc(%ebp),%eax
 60b:	0f b6 00             	movzbl (%eax),%eax
 60e:	0f be c0             	movsbl %al,%eax
 611:	83 ec 08             	sub    $0x8,%esp
 614:	50                   	push   %eax
 615:	ff 75 08             	pushl  0x8(%ebp)
 618:	e8 31 fe ff ff       	call   44e <putc>
 61d:	83 c4 10             	add    $0x10,%esp
          s++;
 620:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 624:	8b 45 f4             	mov    -0xc(%ebp),%eax
 627:	0f b6 00             	movzbl (%eax),%eax
 62a:	84 c0                	test   %al,%al
 62c:	75 da                	jne    608 <printf+0xe3>
 62e:	eb 65                	jmp    695 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 630:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 634:	75 1d                	jne    653 <printf+0x12e>
        putc(fd, *ap);
 636:	8b 45 e8             	mov    -0x18(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	0f be c0             	movsbl %al,%eax
 63e:	83 ec 08             	sub    $0x8,%esp
 641:	50                   	push   %eax
 642:	ff 75 08             	pushl  0x8(%ebp)
 645:	e8 04 fe ff ff       	call   44e <putc>
 64a:	83 c4 10             	add    $0x10,%esp
        ap++;
 64d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 651:	eb 42                	jmp    695 <printf+0x170>
      } else if(c == '%'){
 653:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 657:	75 17                	jne    670 <printf+0x14b>
        putc(fd, c);
 659:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65c:	0f be c0             	movsbl %al,%eax
 65f:	83 ec 08             	sub    $0x8,%esp
 662:	50                   	push   %eax
 663:	ff 75 08             	pushl  0x8(%ebp)
 666:	e8 e3 fd ff ff       	call   44e <putc>
 66b:	83 c4 10             	add    $0x10,%esp
 66e:	eb 25                	jmp    695 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 670:	83 ec 08             	sub    $0x8,%esp
 673:	6a 25                	push   $0x25
 675:	ff 75 08             	pushl  0x8(%ebp)
 678:	e8 d1 fd ff ff       	call   44e <putc>
 67d:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 680:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 683:	0f be c0             	movsbl %al,%eax
 686:	83 ec 08             	sub    $0x8,%esp
 689:	50                   	push   %eax
 68a:	ff 75 08             	pushl  0x8(%ebp)
 68d:	e8 bc fd ff ff       	call   44e <putc>
 692:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 695:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 69c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6a0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6a6:	01 d0                	add    %edx,%eax
 6a8:	0f b6 00             	movzbl (%eax),%eax
 6ab:	84 c0                	test   %al,%al
 6ad:	0f 85 94 fe ff ff    	jne    547 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6b3:	90                   	nop
 6b4:	c9                   	leave  
 6b5:	c3                   	ret    

000006b6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6b6:	55                   	push   %ebp
 6b7:	89 e5                	mov    %esp,%ebp
 6b9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6bc:	8b 45 08             	mov    0x8(%ebp),%eax
 6bf:	83 e8 08             	sub    $0x8,%eax
 6c2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c5:	a1 70 0b 00 00       	mov    0xb70,%eax
 6ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cd:	eb 24                	jmp    6f3 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d2:	8b 00                	mov    (%eax),%eax
 6d4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d7:	77 12                	ja     6eb <free+0x35>
 6d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6df:	77 24                	ja     705 <free+0x4f>
 6e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e4:	8b 00                	mov    (%eax),%eax
 6e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6e9:	77 1a                	ja     705 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ee:	8b 00                	mov    (%eax),%eax
 6f0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f9:	76 d4                	jbe    6cf <free+0x19>
 6fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 703:	76 ca                	jbe    6cf <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 705:	8b 45 f8             	mov    -0x8(%ebp),%eax
 708:	8b 40 04             	mov    0x4(%eax),%eax
 70b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 712:	8b 45 f8             	mov    -0x8(%ebp),%eax
 715:	01 c2                	add    %eax,%edx
 717:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71a:	8b 00                	mov    (%eax),%eax
 71c:	39 c2                	cmp    %eax,%edx
 71e:	75 24                	jne    744 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 720:	8b 45 f8             	mov    -0x8(%ebp),%eax
 723:	8b 50 04             	mov    0x4(%eax),%edx
 726:	8b 45 fc             	mov    -0x4(%ebp),%eax
 729:	8b 00                	mov    (%eax),%eax
 72b:	8b 40 04             	mov    0x4(%eax),%eax
 72e:	01 c2                	add    %eax,%edx
 730:	8b 45 f8             	mov    -0x8(%ebp),%eax
 733:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 736:	8b 45 fc             	mov    -0x4(%ebp),%eax
 739:	8b 00                	mov    (%eax),%eax
 73b:	8b 10                	mov    (%eax),%edx
 73d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 740:	89 10                	mov    %edx,(%eax)
 742:	eb 0a                	jmp    74e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 10                	mov    (%eax),%edx
 749:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	8b 40 04             	mov    0x4(%eax),%eax
 754:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	01 d0                	add    %edx,%eax
 760:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 763:	75 20                	jne    785 <free+0xcf>
    p->s.size += bp->s.size;
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	8b 50 04             	mov    0x4(%eax),%edx
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76e:	8b 40 04             	mov    0x4(%eax),%eax
 771:	01 c2                	add    %eax,%edx
 773:	8b 45 fc             	mov    -0x4(%ebp),%eax
 776:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 779:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77c:	8b 10                	mov    (%eax),%edx
 77e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 781:	89 10                	mov    %edx,(%eax)
 783:	eb 08                	jmp    78d <free+0xd7>
  } else
    p->s.ptr = bp;
 785:	8b 45 fc             	mov    -0x4(%ebp),%eax
 788:	8b 55 f8             	mov    -0x8(%ebp),%edx
 78b:	89 10                	mov    %edx,(%eax)
  freep = p;
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	a3 70 0b 00 00       	mov    %eax,0xb70
}
 795:	90                   	nop
 796:	c9                   	leave  
 797:	c3                   	ret    

00000798 <morecore>:

static Header*
morecore(uint nu)
{
 798:	55                   	push   %ebp
 799:	89 e5                	mov    %esp,%ebp
 79b:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 79e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7a5:	77 07                	ja     7ae <morecore+0x16>
    nu = 4096;
 7a7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ae:	8b 45 08             	mov    0x8(%ebp),%eax
 7b1:	c1 e0 03             	shl    $0x3,%eax
 7b4:	83 ec 0c             	sub    $0xc,%esp
 7b7:	50                   	push   %eax
 7b8:	e8 19 fc ff ff       	call   3d6 <sbrk>
 7bd:	83 c4 10             	add    $0x10,%esp
 7c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7c3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7c7:	75 07                	jne    7d0 <morecore+0x38>
    return 0;
 7c9:	b8 00 00 00 00       	mov    $0x0,%eax
 7ce:	eb 26                	jmp    7f6 <morecore+0x5e>
  hp = (Header*)p;
 7d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d9:	8b 55 08             	mov    0x8(%ebp),%edx
 7dc:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e2:	83 c0 08             	add    $0x8,%eax
 7e5:	83 ec 0c             	sub    $0xc,%esp
 7e8:	50                   	push   %eax
 7e9:	e8 c8 fe ff ff       	call   6b6 <free>
 7ee:	83 c4 10             	add    $0x10,%esp
  return freep;
 7f1:	a1 70 0b 00 00       	mov    0xb70,%eax
}
 7f6:	c9                   	leave  
 7f7:	c3                   	ret    

000007f8 <malloc>:

void*
malloc(uint nbytes)
{
 7f8:	55                   	push   %ebp
 7f9:	89 e5                	mov    %esp,%ebp
 7fb:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7fe:	8b 45 08             	mov    0x8(%ebp),%eax
 801:	83 c0 07             	add    $0x7,%eax
 804:	c1 e8 03             	shr    $0x3,%eax
 807:	83 c0 01             	add    $0x1,%eax
 80a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 80d:	a1 70 0b 00 00       	mov    0xb70,%eax
 812:	89 45 f0             	mov    %eax,-0x10(%ebp)
 815:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 819:	75 23                	jne    83e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 81b:	c7 45 f0 68 0b 00 00 	movl   $0xb68,-0x10(%ebp)
 822:	8b 45 f0             	mov    -0x10(%ebp),%eax
 825:	a3 70 0b 00 00       	mov    %eax,0xb70
 82a:	a1 70 0b 00 00       	mov    0xb70,%eax
 82f:	a3 68 0b 00 00       	mov    %eax,0xb68
    base.s.size = 0;
 834:	c7 05 6c 0b 00 00 00 	movl   $0x0,0xb6c
 83b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 83e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 841:	8b 00                	mov    (%eax),%eax
 843:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	8b 40 04             	mov    0x4(%eax),%eax
 84c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 84f:	72 4d                	jb     89e <malloc+0xa6>
      if(p->s.size == nunits)
 851:	8b 45 f4             	mov    -0xc(%ebp),%eax
 854:	8b 40 04             	mov    0x4(%eax),%eax
 857:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85a:	75 0c                	jne    868 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 85c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85f:	8b 10                	mov    (%eax),%edx
 861:	8b 45 f0             	mov    -0x10(%ebp),%eax
 864:	89 10                	mov    %edx,(%eax)
 866:	eb 26                	jmp    88e <malloc+0x96>
      else {
        p->s.size -= nunits;
 868:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86b:	8b 40 04             	mov    0x4(%eax),%eax
 86e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 871:	89 c2                	mov    %eax,%edx
 873:	8b 45 f4             	mov    -0xc(%ebp),%eax
 876:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 879:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87c:	8b 40 04             	mov    0x4(%eax),%eax
 87f:	c1 e0 03             	shl    $0x3,%eax
 882:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 885:	8b 45 f4             	mov    -0xc(%ebp),%eax
 888:	8b 55 ec             	mov    -0x14(%ebp),%edx
 88b:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 88e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 891:	a3 70 0b 00 00       	mov    %eax,0xb70
      return (void*)(p + 1);
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	83 c0 08             	add    $0x8,%eax
 89c:	eb 3b                	jmp    8d9 <malloc+0xe1>
    }
    if(p == freep)
 89e:	a1 70 0b 00 00       	mov    0xb70,%eax
 8a3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8a6:	75 1e                	jne    8c6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8a8:	83 ec 0c             	sub    $0xc,%esp
 8ab:	ff 75 ec             	pushl  -0x14(%ebp)
 8ae:	e8 e5 fe ff ff       	call   798 <morecore>
 8b3:	83 c4 10             	add    $0x10,%esp
 8b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8bd:	75 07                	jne    8c6 <malloc+0xce>
        return 0;
 8bf:	b8 00 00 00 00       	mov    $0x0,%eax
 8c4:	eb 13                	jmp    8d9 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cf:	8b 00                	mov    (%eax),%eax
 8d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8d4:	e9 6d ff ff ff       	jmp    846 <malloc+0x4e>
}
 8d9:	c9                   	leave  
 8da:	c3                   	ret    
