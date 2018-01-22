
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#ifdef CS333_P2
#include "types.h"
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
  printf(1, "Not imlpemented yet.\n");
  11:	83 ec 08             	sub    $0x8,%esp
  14:	68 b7 08 00 00       	push   $0x8b7
  19:	6a 01                	push   $0x1
  1b:	e8 e1 04 00 00       	call   501 <printf>
  20:	83 c4 10             	add    $0x10,%esp
  exit();
  23:	e8 2a 03 00 00       	call   352 <exit>

00000028 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  28:	55                   	push   %ebp
  29:	89 e5                	mov    %esp,%ebp
  2b:	57                   	push   %edi
  2c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  30:	8b 55 10             	mov    0x10(%ebp),%edx
  33:	8b 45 0c             	mov    0xc(%ebp),%eax
  36:	89 cb                	mov    %ecx,%ebx
  38:	89 df                	mov    %ebx,%edi
  3a:	89 d1                	mov    %edx,%ecx
  3c:	fc                   	cld    
  3d:	f3 aa                	rep stos %al,%es:(%edi)
  3f:	89 ca                	mov    %ecx,%edx
  41:	89 fb                	mov    %edi,%ebx
  43:	89 5d 08             	mov    %ebx,0x8(%ebp)
  46:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  49:	90                   	nop
  4a:	5b                   	pop    %ebx
  4b:	5f                   	pop    %edi
  4c:	5d                   	pop    %ebp
  4d:	c3                   	ret    

0000004e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  4e:	55                   	push   %ebp
  4f:	89 e5                	mov    %esp,%ebp
  51:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  54:	8b 45 08             	mov    0x8(%ebp),%eax
  57:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  5a:	90                   	nop
  5b:	8b 45 08             	mov    0x8(%ebp),%eax
  5e:	8d 50 01             	lea    0x1(%eax),%edx
  61:	89 55 08             	mov    %edx,0x8(%ebp)
  64:	8b 55 0c             	mov    0xc(%ebp),%edx
  67:	8d 4a 01             	lea    0x1(%edx),%ecx
  6a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  6d:	0f b6 12             	movzbl (%edx),%edx
  70:	88 10                	mov    %dl,(%eax)
  72:	0f b6 00             	movzbl (%eax),%eax
  75:	84 c0                	test   %al,%al
  77:	75 e2                	jne    5b <strcpy+0xd>
    ;
  return os;
  79:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  7c:	c9                   	leave  
  7d:	c3                   	ret    

0000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	55                   	push   %ebp
  7f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  81:	eb 08                	jmp    8b <strcmp+0xd>
    p++, q++;
  83:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  87:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  8b:	8b 45 08             	mov    0x8(%ebp),%eax
  8e:	0f b6 00             	movzbl (%eax),%eax
  91:	84 c0                	test   %al,%al
  93:	74 10                	je     a5 <strcmp+0x27>
  95:	8b 45 08             	mov    0x8(%ebp),%eax
  98:	0f b6 10             	movzbl (%eax),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	0f b6 00             	movzbl (%eax),%eax
  a1:	38 c2                	cmp    %al,%dl
  a3:	74 de                	je     83 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	0f b6 00             	movzbl (%eax),%eax
  ab:	0f b6 d0             	movzbl %al,%edx
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	0f b6 00             	movzbl (%eax),%eax
  b4:	0f b6 c0             	movzbl %al,%eax
  b7:	29 c2                	sub    %eax,%edx
  b9:	89 d0                	mov    %edx,%eax
}
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    

000000bd <strlen>:

uint
strlen(char *s)
{
  bd:	55                   	push   %ebp
  be:	89 e5                	mov    %esp,%ebp
  c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  ca:	eb 04                	jmp    d0 <strlen+0x13>
  cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	01 d0                	add    %edx,%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	75 ed                	jne    cc <strlen+0xf>
    ;
  return n;
  df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e2:	c9                   	leave  
  e3:	c3                   	ret    

000000e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  e7:	8b 45 10             	mov    0x10(%ebp),%eax
  ea:	50                   	push   %eax
  eb:	ff 75 0c             	pushl  0xc(%ebp)
  ee:	ff 75 08             	pushl  0x8(%ebp)
  f1:	e8 32 ff ff ff       	call   28 <stosb>
  f6:	83 c4 0c             	add    $0xc,%esp
  return dst;
  f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <strchr>:

char*
strchr(const char *s, char c)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	83 ec 04             	sub    $0x4,%esp
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10a:	eb 14                	jmp    120 <strchr+0x22>
    if(*s == c)
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	3a 45 fc             	cmp    -0x4(%ebp),%al
 115:	75 05                	jne    11c <strchr+0x1e>
      return (char*)s;
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	eb 13                	jmp    12f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 11c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 120:	8b 45 08             	mov    0x8(%ebp),%eax
 123:	0f b6 00             	movzbl (%eax),%eax
 126:	84 c0                	test   %al,%al
 128:	75 e2                	jne    10c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 12a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12f:	c9                   	leave  
 130:	c3                   	ret    

00000131 <gets>:

char*
gets(char *buf, int max)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 137:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 13e:	eb 42                	jmp    182 <gets+0x51>
    cc = read(0, &c, 1);
 140:	83 ec 04             	sub    $0x4,%esp
 143:	6a 01                	push   $0x1
 145:	8d 45 ef             	lea    -0x11(%ebp),%eax
 148:	50                   	push   %eax
 149:	6a 00                	push   $0x0
 14b:	e8 1a 02 00 00       	call   36a <read>
 150:	83 c4 10             	add    $0x10,%esp
 153:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 156:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 15a:	7e 33                	jle    18f <gets+0x5e>
      break;
    buf[i++] = c;
 15c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15f:	8d 50 01             	lea    0x1(%eax),%edx
 162:	89 55 f4             	mov    %edx,-0xc(%ebp)
 165:	89 c2                	mov    %eax,%edx
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	01 c2                	add    %eax,%edx
 16c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 170:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 172:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 176:	3c 0a                	cmp    $0xa,%al
 178:	74 16                	je     190 <gets+0x5f>
 17a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17e:	3c 0d                	cmp    $0xd,%al
 180:	74 0e                	je     190 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	83 c0 01             	add    $0x1,%eax
 188:	3b 45 0c             	cmp    0xc(%ebp),%eax
 18b:	7c b3                	jl     140 <gets+0xf>
 18d:	eb 01                	jmp    190 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 18f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 190:	8b 55 f4             	mov    -0xc(%ebp),%edx
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	01 d0                	add    %edx,%eax
 198:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19e:	c9                   	leave  
 19f:	c3                   	ret    

000001a0 <stat>:

int
stat(char *n, struct stat *st)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1a6:	83 ec 08             	sub    $0x8,%esp
 1a9:	6a 00                	push   $0x0
 1ab:	ff 75 08             	pushl  0x8(%ebp)
 1ae:	e8 df 01 00 00       	call   392 <open>
 1b3:	83 c4 10             	add    $0x10,%esp
 1b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1bd:	79 07                	jns    1c6 <stat+0x26>
    return -1;
 1bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c4:	eb 25                	jmp    1eb <stat+0x4b>
  r = fstat(fd, st);
 1c6:	83 ec 08             	sub    $0x8,%esp
 1c9:	ff 75 0c             	pushl  0xc(%ebp)
 1cc:	ff 75 f4             	pushl  -0xc(%ebp)
 1cf:	e8 d6 01 00 00       	call   3aa <fstat>
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1da:	83 ec 0c             	sub    $0xc,%esp
 1dd:	ff 75 f4             	pushl  -0xc(%ebp)
 1e0:	e8 95 01 00 00       	call   37a <close>
 1e5:	83 c4 10             	add    $0x10,%esp
  return r;
 1e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1eb:	c9                   	leave  
 1ec:	c3                   	ret    

000001ed <atoi>:

int
atoi(const char *s)
{
 1ed:	55                   	push   %ebp
 1ee:	89 e5                	mov    %esp,%ebp
 1f0:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 1f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 1fa:	eb 04                	jmp    200 <atoi+0x13>
 1fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	0f b6 00             	movzbl (%eax),%eax
 206:	3c 20                	cmp    $0x20,%al
 208:	74 f2                	je     1fc <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	0f b6 00             	movzbl (%eax),%eax
 210:	3c 2d                	cmp    $0x2d,%al
 212:	75 07                	jne    21b <atoi+0x2e>
 214:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 219:	eb 05                	jmp    220 <atoi+0x33>
 21b:	b8 01 00 00 00       	mov    $0x1,%eax
 220:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	3c 2b                	cmp    $0x2b,%al
 22b:	74 0a                	je     237 <atoi+0x4a>
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 2d                	cmp    $0x2d,%al
 235:	75 2b                	jne    262 <atoi+0x75>
    s++;
 237:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 23b:	eb 25                	jmp    262 <atoi+0x75>
    n = n*10 + *s++ - '0';
 23d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 240:	89 d0                	mov    %edx,%eax
 242:	c1 e0 02             	shl    $0x2,%eax
 245:	01 d0                	add    %edx,%eax
 247:	01 c0                	add    %eax,%eax
 249:	89 c1                	mov    %eax,%ecx
 24b:	8b 45 08             	mov    0x8(%ebp),%eax
 24e:	8d 50 01             	lea    0x1(%eax),%edx
 251:	89 55 08             	mov    %edx,0x8(%ebp)
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	0f be c0             	movsbl %al,%eax
 25a:	01 c8                	add    %ecx,%eax
 25c:	83 e8 30             	sub    $0x30,%eax
 25f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 262:	8b 45 08             	mov    0x8(%ebp),%eax
 265:	0f b6 00             	movzbl (%eax),%eax
 268:	3c 2f                	cmp    $0x2f,%al
 26a:	7e 0a                	jle    276 <atoi+0x89>
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	0f b6 00             	movzbl (%eax),%eax
 272:	3c 39                	cmp    $0x39,%al
 274:	7e c7                	jle    23d <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 276:	8b 45 f8             	mov    -0x8(%ebp),%eax
 279:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 27d:	c9                   	leave  
 27e:	c3                   	ret    

0000027f <atoo>:

int
atoo(const char *s)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 285:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 28c:	eb 04                	jmp    292 <atoo+0x13>
 28e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	0f b6 00             	movzbl (%eax),%eax
 298:	3c 20                	cmp    $0x20,%al
 29a:	74 f2                	je     28e <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	0f b6 00             	movzbl (%eax),%eax
 2a2:	3c 2d                	cmp    $0x2d,%al
 2a4:	75 07                	jne    2ad <atoo+0x2e>
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 05                	jmp    2b2 <atoo+0x33>
 2ad:	b8 01 00 00 00       	mov    $0x1,%eax
 2b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	3c 2b                	cmp    $0x2b,%al
 2bd:	74 0a                	je     2c9 <atoo+0x4a>
 2bf:	8b 45 08             	mov    0x8(%ebp),%eax
 2c2:	0f b6 00             	movzbl (%eax),%eax
 2c5:	3c 2d                	cmp    $0x2d,%al
 2c7:	75 27                	jne    2f0 <atoo+0x71>
    s++;
 2c9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 2cd:	eb 21                	jmp    2f0 <atoo+0x71>
    n = n*8 + *s++ - '0';
 2cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d2:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	8d 50 01             	lea    0x1(%eax),%edx
 2df:	89 55 08             	mov    %edx,0x8(%ebp)
 2e2:	0f b6 00             	movzbl (%eax),%eax
 2e5:	0f be c0             	movsbl %al,%eax
 2e8:	01 c8                	add    %ecx,%eax
 2ea:	83 e8 30             	sub    $0x30,%eax
 2ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 2f0:	8b 45 08             	mov    0x8(%ebp),%eax
 2f3:	0f b6 00             	movzbl (%eax),%eax
 2f6:	3c 2f                	cmp    $0x2f,%al
 2f8:	7e 0a                	jle    304 <atoo+0x85>
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	3c 37                	cmp    $0x37,%al
 302:	7e cb                	jle    2cf <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 304:	8b 45 f8             	mov    -0x8(%ebp),%eax
 307:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 30b:	c9                   	leave  
 30c:	c3                   	ret    

0000030d <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 30d:	55                   	push   %ebp
 30e:	89 e5                	mov    %esp,%ebp
 310:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 319:	8b 45 0c             	mov    0xc(%ebp),%eax
 31c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 31f:	eb 17                	jmp    338 <memmove+0x2b>
    *dst++ = *src++;
 321:	8b 45 fc             	mov    -0x4(%ebp),%eax
 324:	8d 50 01             	lea    0x1(%eax),%edx
 327:	89 55 fc             	mov    %edx,-0x4(%ebp)
 32a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32d:	8d 4a 01             	lea    0x1(%edx),%ecx
 330:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 333:	0f b6 12             	movzbl (%edx),%edx
 336:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 338:	8b 45 10             	mov    0x10(%ebp),%eax
 33b:	8d 50 ff             	lea    -0x1(%eax),%edx
 33e:	89 55 10             	mov    %edx,0x10(%ebp)
 341:	85 c0                	test   %eax,%eax
 343:	7f dc                	jg     321 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 345:	8b 45 08             	mov    0x8(%ebp),%eax
}
 348:	c9                   	leave  
 349:	c3                   	ret    

0000034a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34a:	b8 01 00 00 00       	mov    $0x1,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <exit>:
SYSCALL(exit)
 352:	b8 02 00 00 00       	mov    $0x2,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <wait>:
SYSCALL(wait)
 35a:	b8 03 00 00 00       	mov    $0x3,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <pipe>:
SYSCALL(pipe)
 362:	b8 04 00 00 00       	mov    $0x4,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <read>:
SYSCALL(read)
 36a:	b8 05 00 00 00       	mov    $0x5,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <write>:
SYSCALL(write)
 372:	b8 10 00 00 00       	mov    $0x10,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <close>:
SYSCALL(close)
 37a:	b8 15 00 00 00       	mov    $0x15,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <kill>:
SYSCALL(kill)
 382:	b8 06 00 00 00       	mov    $0x6,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <exec>:
SYSCALL(exec)
 38a:	b8 07 00 00 00       	mov    $0x7,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <open>:
SYSCALL(open)
 392:	b8 0f 00 00 00       	mov    $0xf,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <mknod>:
SYSCALL(mknod)
 39a:	b8 11 00 00 00       	mov    $0x11,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <unlink>:
SYSCALL(unlink)
 3a2:	b8 12 00 00 00       	mov    $0x12,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <fstat>:
SYSCALL(fstat)
 3aa:	b8 08 00 00 00       	mov    $0x8,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <link>:
SYSCALL(link)
 3b2:	b8 13 00 00 00       	mov    $0x13,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <mkdir>:
SYSCALL(mkdir)
 3ba:	b8 14 00 00 00       	mov    $0x14,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <chdir>:
SYSCALL(chdir)
 3c2:	b8 09 00 00 00       	mov    $0x9,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <dup>:
SYSCALL(dup)
 3ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <getpid>:
SYSCALL(getpid)
 3d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <sbrk>:
SYSCALL(sbrk)
 3da:	b8 0c 00 00 00       	mov    $0xc,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <sleep>:
SYSCALL(sleep)
 3e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <uptime>:
SYSCALL(uptime)
 3ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <halt>:
SYSCALL(halt)
 3f2:	b8 16 00 00 00       	mov    $0x16,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <date>:
SYSCALL(date)
 3fa:	b8 17 00 00 00       	mov    $0x17,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <getuid>:
SYSCALL(getuid)
 402:	b8 18 00 00 00       	mov    $0x18,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <getgid>:
SYSCALL(getgid)
 40a:	b8 19 00 00 00       	mov    $0x19,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <getppid>:
SYSCALL(getppid)
 412:	b8 1a 00 00 00       	mov    $0x1a,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <setuid>:
SYSCALL(setuid)
 41a:	b8 1b 00 00 00       	mov    $0x1b,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <setgid>:
SYSCALL(setgid)
 422:	b8 1c 00 00 00       	mov    $0x1c,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 42a:	55                   	push   %ebp
 42b:	89 e5                	mov    %esp,%ebp
 42d:	83 ec 18             	sub    $0x18,%esp
 430:	8b 45 0c             	mov    0xc(%ebp),%eax
 433:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 436:	83 ec 04             	sub    $0x4,%esp
 439:	6a 01                	push   $0x1
 43b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 43e:	50                   	push   %eax
 43f:	ff 75 08             	pushl  0x8(%ebp)
 442:	e8 2b ff ff ff       	call   372 <write>
 447:	83 c4 10             	add    $0x10,%esp
}
 44a:	90                   	nop
 44b:	c9                   	leave  
 44c:	c3                   	ret    

0000044d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 44d:	55                   	push   %ebp
 44e:	89 e5                	mov    %esp,%ebp
 450:	53                   	push   %ebx
 451:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 454:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 45b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 45f:	74 17                	je     478 <printint+0x2b>
 461:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 465:	79 11                	jns    478 <printint+0x2b>
    neg = 1;
 467:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 46e:	8b 45 0c             	mov    0xc(%ebp),%eax
 471:	f7 d8                	neg    %eax
 473:	89 45 ec             	mov    %eax,-0x14(%ebp)
 476:	eb 06                	jmp    47e <printint+0x31>
  } else {
    x = xx;
 478:	8b 45 0c             	mov    0xc(%ebp),%eax
 47b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 47e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 485:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 488:	8d 41 01             	lea    0x1(%ecx),%eax
 48b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 48e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 491:	8b 45 ec             	mov    -0x14(%ebp),%eax
 494:	ba 00 00 00 00       	mov    $0x0,%edx
 499:	f7 f3                	div    %ebx
 49b:	89 d0                	mov    %edx,%eax
 49d:	0f b6 80 3c 0b 00 00 	movzbl 0xb3c(%eax),%eax
 4a4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4ae:	ba 00 00 00 00       	mov    $0x0,%edx
 4b3:	f7 f3                	div    %ebx
 4b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4bc:	75 c7                	jne    485 <printint+0x38>
  if(neg)
 4be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4c2:	74 2d                	je     4f1 <printint+0xa4>
    buf[i++] = '-';
 4c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c7:	8d 50 01             	lea    0x1(%eax),%edx
 4ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4cd:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4d2:	eb 1d                	jmp    4f1 <printint+0xa4>
    putc(fd, buf[i]);
 4d4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4da:	01 d0                	add    %edx,%eax
 4dc:	0f b6 00             	movzbl (%eax),%eax
 4df:	0f be c0             	movsbl %al,%eax
 4e2:	83 ec 08             	sub    $0x8,%esp
 4e5:	50                   	push   %eax
 4e6:	ff 75 08             	pushl  0x8(%ebp)
 4e9:	e8 3c ff ff ff       	call   42a <putc>
 4ee:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 4f1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f9:	79 d9                	jns    4d4 <printint+0x87>
    putc(fd, buf[i]);
}
 4fb:	90                   	nop
 4fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4ff:	c9                   	leave  
 500:	c3                   	ret    

00000501 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 501:	55                   	push   %ebp
 502:	89 e5                	mov    %esp,%ebp
 504:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 507:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 50e:	8d 45 0c             	lea    0xc(%ebp),%eax
 511:	83 c0 04             	add    $0x4,%eax
 514:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 517:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 51e:	e9 59 01 00 00       	jmp    67c <printf+0x17b>
    c = fmt[i] & 0xff;
 523:	8b 55 0c             	mov    0xc(%ebp),%edx
 526:	8b 45 f0             	mov    -0x10(%ebp),%eax
 529:	01 d0                	add    %edx,%eax
 52b:	0f b6 00             	movzbl (%eax),%eax
 52e:	0f be c0             	movsbl %al,%eax
 531:	25 ff 00 00 00       	and    $0xff,%eax
 536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 539:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 53d:	75 2c                	jne    56b <printf+0x6a>
      if(c == '%'){
 53f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 543:	75 0c                	jne    551 <printf+0x50>
        state = '%';
 545:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 54c:	e9 27 01 00 00       	jmp    678 <printf+0x177>
      } else {
        putc(fd, c);
 551:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 554:	0f be c0             	movsbl %al,%eax
 557:	83 ec 08             	sub    $0x8,%esp
 55a:	50                   	push   %eax
 55b:	ff 75 08             	pushl  0x8(%ebp)
 55e:	e8 c7 fe ff ff       	call   42a <putc>
 563:	83 c4 10             	add    $0x10,%esp
 566:	e9 0d 01 00 00       	jmp    678 <printf+0x177>
      }
    } else if(state == '%'){
 56b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 56f:	0f 85 03 01 00 00    	jne    678 <printf+0x177>
      if(c == 'd'){
 575:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 579:	75 1e                	jne    599 <printf+0x98>
        printint(fd, *ap, 10, 1);
 57b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57e:	8b 00                	mov    (%eax),%eax
 580:	6a 01                	push   $0x1
 582:	6a 0a                	push   $0xa
 584:	50                   	push   %eax
 585:	ff 75 08             	pushl  0x8(%ebp)
 588:	e8 c0 fe ff ff       	call   44d <printint>
 58d:	83 c4 10             	add    $0x10,%esp
        ap++;
 590:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 594:	e9 d8 00 00 00       	jmp    671 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 599:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 59d:	74 06                	je     5a5 <printf+0xa4>
 59f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5a3:	75 1e                	jne    5c3 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a8:	8b 00                	mov    (%eax),%eax
 5aa:	6a 00                	push   $0x0
 5ac:	6a 10                	push   $0x10
 5ae:	50                   	push   %eax
 5af:	ff 75 08             	pushl  0x8(%ebp)
 5b2:	e8 96 fe ff ff       	call   44d <printint>
 5b7:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5be:	e9 ae 00 00 00       	jmp    671 <printf+0x170>
      } else if(c == 's'){
 5c3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5c7:	75 43                	jne    60c <printf+0x10b>
        s = (char*)*ap;
 5c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cc:	8b 00                	mov    (%eax),%eax
 5ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d9:	75 25                	jne    600 <printf+0xff>
          s = "(null)";
 5db:	c7 45 f4 cd 08 00 00 	movl   $0x8cd,-0xc(%ebp)
        while(*s != 0){
 5e2:	eb 1c                	jmp    600 <printf+0xff>
          putc(fd, *s);
 5e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e7:	0f b6 00             	movzbl (%eax),%eax
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	83 ec 08             	sub    $0x8,%esp
 5f0:	50                   	push   %eax
 5f1:	ff 75 08             	pushl  0x8(%ebp)
 5f4:	e8 31 fe ff ff       	call   42a <putc>
 5f9:	83 c4 10             	add    $0x10,%esp
          s++;
 5fc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 600:	8b 45 f4             	mov    -0xc(%ebp),%eax
 603:	0f b6 00             	movzbl (%eax),%eax
 606:	84 c0                	test   %al,%al
 608:	75 da                	jne    5e4 <printf+0xe3>
 60a:	eb 65                	jmp    671 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 60c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 610:	75 1d                	jne    62f <printf+0x12e>
        putc(fd, *ap);
 612:	8b 45 e8             	mov    -0x18(%ebp),%eax
 615:	8b 00                	mov    (%eax),%eax
 617:	0f be c0             	movsbl %al,%eax
 61a:	83 ec 08             	sub    $0x8,%esp
 61d:	50                   	push   %eax
 61e:	ff 75 08             	pushl  0x8(%ebp)
 621:	e8 04 fe ff ff       	call   42a <putc>
 626:	83 c4 10             	add    $0x10,%esp
        ap++;
 629:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62d:	eb 42                	jmp    671 <printf+0x170>
      } else if(c == '%'){
 62f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 633:	75 17                	jne    64c <printf+0x14b>
        putc(fd, c);
 635:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 638:	0f be c0             	movsbl %al,%eax
 63b:	83 ec 08             	sub    $0x8,%esp
 63e:	50                   	push   %eax
 63f:	ff 75 08             	pushl  0x8(%ebp)
 642:	e8 e3 fd ff ff       	call   42a <putc>
 647:	83 c4 10             	add    $0x10,%esp
 64a:	eb 25                	jmp    671 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 64c:	83 ec 08             	sub    $0x8,%esp
 64f:	6a 25                	push   $0x25
 651:	ff 75 08             	pushl  0x8(%ebp)
 654:	e8 d1 fd ff ff       	call   42a <putc>
 659:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 65c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65f:	0f be c0             	movsbl %al,%eax
 662:	83 ec 08             	sub    $0x8,%esp
 665:	50                   	push   %eax
 666:	ff 75 08             	pushl  0x8(%ebp)
 669:	e8 bc fd ff ff       	call   42a <putc>
 66e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 671:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 678:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 67c:	8b 55 0c             	mov    0xc(%ebp),%edx
 67f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 682:	01 d0                	add    %edx,%eax
 684:	0f b6 00             	movzbl (%eax),%eax
 687:	84 c0                	test   %al,%al
 689:	0f 85 94 fe ff ff    	jne    523 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 68f:	90                   	nop
 690:	c9                   	leave  
 691:	c3                   	ret    

00000692 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 692:	55                   	push   %ebp
 693:	89 e5                	mov    %esp,%ebp
 695:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 698:	8b 45 08             	mov    0x8(%ebp),%eax
 69b:	83 e8 08             	sub    $0x8,%eax
 69e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a1:	a1 58 0b 00 00       	mov    0xb58,%eax
 6a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a9:	eb 24                	jmp    6cf <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b3:	77 12                	ja     6c7 <free+0x35>
 6b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6bb:	77 24                	ja     6e1 <free+0x4f>
 6bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c0:	8b 00                	mov    (%eax),%eax
 6c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6c5:	77 1a                	ja     6e1 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6d5:	76 d4                	jbe    6ab <free+0x19>
 6d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6df:	76 ca                	jbe    6ab <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 6e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6e4:	8b 40 04             	mov    0x4(%eax),%eax
 6e7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f1:	01 c2                	add    %eax,%edx
 6f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f6:	8b 00                	mov    (%eax),%eax
 6f8:	39 c2                	cmp    %eax,%edx
 6fa:	75 24                	jne    720 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ff:	8b 50 04             	mov    0x4(%eax),%edx
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 00                	mov    (%eax),%eax
 707:	8b 40 04             	mov    0x4(%eax),%eax
 70a:	01 c2                	add    %eax,%edx
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 712:	8b 45 fc             	mov    -0x4(%ebp),%eax
 715:	8b 00                	mov    (%eax),%eax
 717:	8b 10                	mov    (%eax),%edx
 719:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71c:	89 10                	mov    %edx,(%eax)
 71e:	eb 0a                	jmp    72a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 10                	mov    (%eax),%edx
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	8b 40 04             	mov    0x4(%eax),%eax
 730:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	01 d0                	add    %edx,%eax
 73c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73f:	75 20                	jne    761 <free+0xcf>
    p->s.size += bp->s.size;
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	8b 50 04             	mov    0x4(%eax),%edx
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	8b 40 04             	mov    0x4(%eax),%eax
 74d:	01 c2                	add    %eax,%edx
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 755:	8b 45 f8             	mov    -0x8(%ebp),%eax
 758:	8b 10                	mov    (%eax),%edx
 75a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75d:	89 10                	mov    %edx,(%eax)
 75f:	eb 08                	jmp    769 <free+0xd7>
  } else
    p->s.ptr = bp;
 761:	8b 45 fc             	mov    -0x4(%ebp),%eax
 764:	8b 55 f8             	mov    -0x8(%ebp),%edx
 767:	89 10                	mov    %edx,(%eax)
  freep = p;
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	a3 58 0b 00 00       	mov    %eax,0xb58
}
 771:	90                   	nop
 772:	c9                   	leave  
 773:	c3                   	ret    

00000774 <morecore>:

static Header*
morecore(uint nu)
{
 774:	55                   	push   %ebp
 775:	89 e5                	mov    %esp,%ebp
 777:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 77a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 781:	77 07                	ja     78a <morecore+0x16>
    nu = 4096;
 783:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 78a:	8b 45 08             	mov    0x8(%ebp),%eax
 78d:	c1 e0 03             	shl    $0x3,%eax
 790:	83 ec 0c             	sub    $0xc,%esp
 793:	50                   	push   %eax
 794:	e8 41 fc ff ff       	call   3da <sbrk>
 799:	83 c4 10             	add    $0x10,%esp
 79c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 79f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7a3:	75 07                	jne    7ac <morecore+0x38>
    return 0;
 7a5:	b8 00 00 00 00       	mov    $0x0,%eax
 7aa:	eb 26                	jmp    7d2 <morecore+0x5e>
  hp = (Header*)p;
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b5:	8b 55 08             	mov    0x8(%ebp),%edx
 7b8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7be:	83 c0 08             	add    $0x8,%eax
 7c1:	83 ec 0c             	sub    $0xc,%esp
 7c4:	50                   	push   %eax
 7c5:	e8 c8 fe ff ff       	call   692 <free>
 7ca:	83 c4 10             	add    $0x10,%esp
  return freep;
 7cd:	a1 58 0b 00 00       	mov    0xb58,%eax
}
 7d2:	c9                   	leave  
 7d3:	c3                   	ret    

000007d4 <malloc>:

void*
malloc(uint nbytes)
{
 7d4:	55                   	push   %ebp
 7d5:	89 e5                	mov    %esp,%ebp
 7d7:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7da:	8b 45 08             	mov    0x8(%ebp),%eax
 7dd:	83 c0 07             	add    $0x7,%eax
 7e0:	c1 e8 03             	shr    $0x3,%eax
 7e3:	83 c0 01             	add    $0x1,%eax
 7e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7e9:	a1 58 0b 00 00       	mov    0xb58,%eax
 7ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f5:	75 23                	jne    81a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7f7:	c7 45 f0 50 0b 00 00 	movl   $0xb50,-0x10(%ebp)
 7fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 801:	a3 58 0b 00 00       	mov    %eax,0xb58
 806:	a1 58 0b 00 00       	mov    0xb58,%eax
 80b:	a3 50 0b 00 00       	mov    %eax,0xb50
    base.s.size = 0;
 810:	c7 05 54 0b 00 00 00 	movl   $0x0,0xb54
 817:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 822:	8b 45 f4             	mov    -0xc(%ebp),%eax
 825:	8b 40 04             	mov    0x4(%eax),%eax
 828:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 82b:	72 4d                	jb     87a <malloc+0xa6>
      if(p->s.size == nunits)
 82d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 830:	8b 40 04             	mov    0x4(%eax),%eax
 833:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 836:	75 0c                	jne    844 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 838:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83b:	8b 10                	mov    (%eax),%edx
 83d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 840:	89 10                	mov    %edx,(%eax)
 842:	eb 26                	jmp    86a <malloc+0x96>
      else {
        p->s.size -= nunits;
 844:	8b 45 f4             	mov    -0xc(%ebp),%eax
 847:	8b 40 04             	mov    0x4(%eax),%eax
 84a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 84d:	89 c2                	mov    %eax,%edx
 84f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 852:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	8b 40 04             	mov    0x4(%eax),%eax
 85b:	c1 e0 03             	shl    $0x3,%eax
 85e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	8b 55 ec             	mov    -0x14(%ebp),%edx
 867:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 86a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86d:	a3 58 0b 00 00       	mov    %eax,0xb58
      return (void*)(p + 1);
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	83 c0 08             	add    $0x8,%eax
 878:	eb 3b                	jmp    8b5 <malloc+0xe1>
    }
    if(p == freep)
 87a:	a1 58 0b 00 00       	mov    0xb58,%eax
 87f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 882:	75 1e                	jne    8a2 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 884:	83 ec 0c             	sub    $0xc,%esp
 887:	ff 75 ec             	pushl  -0x14(%ebp)
 88a:	e8 e5 fe ff ff       	call   774 <morecore>
 88f:	83 c4 10             	add    $0x10,%esp
 892:	89 45 f4             	mov    %eax,-0xc(%ebp)
 895:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 899:	75 07                	jne    8a2 <malloc+0xce>
        return 0;
 89b:	b8 00 00 00 00       	mov    $0x0,%eax
 8a0:	eb 13                	jmp    8b5 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ab:	8b 00                	mov    (%eax),%eax
 8ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8b0:	e9 6d ff ff ff       	jmp    822 <malloc+0x4e>
}
 8b5:	c9                   	leave  
 8b6:	c3                   	ret    
