
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 0b 09 00 00       	push   $0x90b
  1e:	6a 02                	push   $0x2
  20:	e8 30 05 00 00       	call   555 <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 71 03 00 00       	call   39e <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 b7 03 00 00       	call   3fe <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 1e 09 00 00       	push   $0x91e
  65:	6a 02                	push   $0x2
  67:	e8 e9 04 00 00       	call   555 <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 2a 03 00 00       	call   39e <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	90                   	nop
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	8d 50 01             	lea    0x1(%eax),%edx
  ad:	89 55 08             	mov    %edx,0x8(%ebp)
  b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  b3:	8d 4a 01             	lea    0x1(%edx),%ecx
  b6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c0             	movzbl %al,%eax
 103:	29 c2                	sub    %eax,%edx
 105:	89 d0                	mov    %edx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	ff 75 0c             	pushl  0xc(%ebp)
 13a:	ff 75 08             	pushl  0x8(%ebp)
 13d:	e8 32 ff ff ff       	call   74 <stosb>
 142:	83 c4 0c             	add    $0xc,%esp
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18a:	eb 42                	jmp    1ce <gets+0x51>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	50                   	push   %eax
 195:	6a 00                	push   $0x0
 197:	e8 1a 02 00 00       	call   3b6 <read>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	7e 33                	jle    1db <gets+0x5e>
      break;
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 16                	je     1dc <gets+0x5f>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0e                	je     1dc <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d7:	7c b3                	jl     18c <gets+0xf>
 1d9:	eb 01                	jmp    1dc <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1db:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:

int
stat(char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	6a 00                	push   $0x0
 1f7:	ff 75 08             	pushl  0x8(%ebp)
 1fa:	e8 df 01 00 00       	call   3de <open>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x26>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 25                	jmp    237 <stat+0x4b>
  r = fstat(fd, st);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 f4             	pushl  -0xc(%ebp)
 21b:	e8 d6 01 00 00       	call   3f6 <fstat>
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 226:	83 ec 0c             	sub    $0xc,%esp
 229:	ff 75 f4             	pushl  -0xc(%ebp)
 22c:	e8 95 01 00 00       	call   3c6 <close>
 231:	83 c4 10             	add    $0x10,%esp
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 246:	eb 04                	jmp    24c <atoi+0x13>
 248:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	0f b6 00             	movzbl (%eax),%eax
 252:	3c 20                	cmp    $0x20,%al
 254:	74 f2                	je     248 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	0f b6 00             	movzbl (%eax),%eax
 25c:	3c 2d                	cmp    $0x2d,%al
 25e:	75 07                	jne    267 <atoi+0x2e>
 260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 265:	eb 05                	jmp    26c <atoi+0x33>
 267:	b8 01 00 00 00       	mov    $0x1,%eax
 26c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 26f:	8b 45 08             	mov    0x8(%ebp),%eax
 272:	0f b6 00             	movzbl (%eax),%eax
 275:	3c 2b                	cmp    $0x2b,%al
 277:	74 0a                	je     283 <atoi+0x4a>
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	0f b6 00             	movzbl (%eax),%eax
 27f:	3c 2d                	cmp    $0x2d,%al
 281:	75 2b                	jne    2ae <atoi+0x75>
    s++;
 283:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 287:	eb 25                	jmp    2ae <atoi+0x75>
    n = n*10 + *s++ - '0';
 289:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28c:	89 d0                	mov    %edx,%eax
 28e:	c1 e0 02             	shl    $0x2,%eax
 291:	01 d0                	add    %edx,%eax
 293:	01 c0                	add    %eax,%eax
 295:	89 c1                	mov    %eax,%ecx
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	8d 50 01             	lea    0x1(%eax),%edx
 29d:	89 55 08             	mov    %edx,0x8(%ebp)
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	0f be c0             	movsbl %al,%eax
 2a6:	01 c8                	add    %ecx,%eax
 2a8:	83 e8 30             	sub    $0x30,%eax
 2ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	0f b6 00             	movzbl (%eax),%eax
 2b4:	3c 2f                	cmp    $0x2f,%al
 2b6:	7e 0a                	jle    2c2 <atoi+0x89>
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	0f b6 00             	movzbl (%eax),%eax
 2be:	3c 39                	cmp    $0x39,%al
 2c0:	7e c7                	jle    289 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2c5:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2c9:	c9                   	leave  
 2ca:	c3                   	ret    

000002cb <atoo>:

int
atoo(const char *s)
{
 2cb:	55                   	push   %ebp
 2cc:	89 e5                	mov    %esp,%ebp
 2ce:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2d8:	eb 04                	jmp    2de <atoo+0x13>
 2da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	0f b6 00             	movzbl (%eax),%eax
 2e4:	3c 20                	cmp    $0x20,%al
 2e6:	74 f2                	je     2da <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	0f b6 00             	movzbl (%eax),%eax
 2ee:	3c 2d                	cmp    $0x2d,%al
 2f0:	75 07                	jne    2f9 <atoo+0x2e>
 2f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f7:	eb 05                	jmp    2fe <atoo+0x33>
 2f9:	b8 01 00 00 00       	mov    $0x1,%eax
 2fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 301:	8b 45 08             	mov    0x8(%ebp),%eax
 304:	0f b6 00             	movzbl (%eax),%eax
 307:	3c 2b                	cmp    $0x2b,%al
 309:	74 0a                	je     315 <atoo+0x4a>
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	3c 2d                	cmp    $0x2d,%al
 313:	75 27                	jne    33c <atoo+0x71>
    s++;
 315:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 319:	eb 21                	jmp    33c <atoo+0x71>
    n = n*8 + *s++ - '0';
 31b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 31e:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 325:	8b 45 08             	mov    0x8(%ebp),%eax
 328:	8d 50 01             	lea    0x1(%eax),%edx
 32b:	89 55 08             	mov    %edx,0x8(%ebp)
 32e:	0f b6 00             	movzbl (%eax),%eax
 331:	0f be c0             	movsbl %al,%eax
 334:	01 c8                	add    %ecx,%eax
 336:	83 e8 30             	sub    $0x30,%eax
 339:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	0f b6 00             	movzbl (%eax),%eax
 342:	3c 2f                	cmp    $0x2f,%al
 344:	7e 0a                	jle    350 <atoo+0x85>
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	0f b6 00             	movzbl (%eax),%eax
 34c:	3c 37                	cmp    $0x37,%al
 34e:	7e cb                	jle    31b <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 350:	8b 45 f8             	mov    -0x8(%ebp),%eax
 353:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 357:	c9                   	leave  
 358:	c3                   	ret    

00000359 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 359:	55                   	push   %ebp
 35a:	89 e5                	mov    %esp,%ebp
 35c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 365:	8b 45 0c             	mov    0xc(%ebp),%eax
 368:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 36b:	eb 17                	jmp    384 <memmove+0x2b>
    *dst++ = *src++;
 36d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 370:	8d 50 01             	lea    0x1(%eax),%edx
 373:	89 55 fc             	mov    %edx,-0x4(%ebp)
 376:	8b 55 f8             	mov    -0x8(%ebp),%edx
 379:	8d 4a 01             	lea    0x1(%edx),%ecx
 37c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 37f:	0f b6 12             	movzbl (%edx),%edx
 382:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 384:	8b 45 10             	mov    0x10(%ebp),%eax
 387:	8d 50 ff             	lea    -0x1(%eax),%edx
 38a:	89 55 10             	mov    %edx,0x10(%ebp)
 38d:	85 c0                	test   %eax,%eax
 38f:	7f dc                	jg     36d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 391:	8b 45 08             	mov    0x8(%ebp),%eax
}
 394:	c9                   	leave  
 395:	c3                   	ret    

00000396 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 396:	b8 01 00 00 00       	mov    $0x1,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <exit>:
SYSCALL(exit)
 39e:	b8 02 00 00 00       	mov    $0x2,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <wait>:
SYSCALL(wait)
 3a6:	b8 03 00 00 00       	mov    $0x3,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <pipe>:
SYSCALL(pipe)
 3ae:	b8 04 00 00 00       	mov    $0x4,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <read>:
SYSCALL(read)
 3b6:	b8 05 00 00 00       	mov    $0x5,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <write>:
SYSCALL(write)
 3be:	b8 10 00 00 00       	mov    $0x10,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <close>:
SYSCALL(close)
 3c6:	b8 15 00 00 00       	mov    $0x15,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <kill>:
SYSCALL(kill)
 3ce:	b8 06 00 00 00       	mov    $0x6,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <exec>:
SYSCALL(exec)
 3d6:	b8 07 00 00 00       	mov    $0x7,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <open>:
SYSCALL(open)
 3de:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <mknod>:
SYSCALL(mknod)
 3e6:	b8 11 00 00 00       	mov    $0x11,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <unlink>:
SYSCALL(unlink)
 3ee:	b8 12 00 00 00       	mov    $0x12,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <fstat>:
SYSCALL(fstat)
 3f6:	b8 08 00 00 00       	mov    $0x8,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <link>:
SYSCALL(link)
 3fe:	b8 13 00 00 00       	mov    $0x13,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <mkdir>:
SYSCALL(mkdir)
 406:	b8 14 00 00 00       	mov    $0x14,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <chdir>:
SYSCALL(chdir)
 40e:	b8 09 00 00 00       	mov    $0x9,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <dup>:
SYSCALL(dup)
 416:	b8 0a 00 00 00       	mov    $0xa,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <getpid>:
SYSCALL(getpid)
 41e:	b8 0b 00 00 00       	mov    $0xb,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <sbrk>:
SYSCALL(sbrk)
 426:	b8 0c 00 00 00       	mov    $0xc,%eax
 42b:	cd 40                	int    $0x40
 42d:	c3                   	ret    

0000042e <sleep>:
SYSCALL(sleep)
 42e:	b8 0d 00 00 00       	mov    $0xd,%eax
 433:	cd 40                	int    $0x40
 435:	c3                   	ret    

00000436 <uptime>:
SYSCALL(uptime)
 436:	b8 0e 00 00 00       	mov    $0xe,%eax
 43b:	cd 40                	int    $0x40
 43d:	c3                   	ret    

0000043e <halt>:
SYSCALL(halt)
 43e:	b8 16 00 00 00       	mov    $0x16,%eax
 443:	cd 40                	int    $0x40
 445:	c3                   	ret    

00000446 <date>:
SYSCALL(date)
 446:	b8 17 00 00 00       	mov    $0x17,%eax
 44b:	cd 40                	int    $0x40
 44d:	c3                   	ret    

0000044e <getuid>:
SYSCALL(getuid)
 44e:	b8 18 00 00 00       	mov    $0x18,%eax
 453:	cd 40                	int    $0x40
 455:	c3                   	ret    

00000456 <getgid>:
SYSCALL(getgid)
 456:	b8 19 00 00 00       	mov    $0x19,%eax
 45b:	cd 40                	int    $0x40
 45d:	c3                   	ret    

0000045e <getppid>:
SYSCALL(getppid)
 45e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 463:	cd 40                	int    $0x40
 465:	c3                   	ret    

00000466 <setuid>:
SYSCALL(setuid)
 466:	b8 1b 00 00 00       	mov    $0x1b,%eax
 46b:	cd 40                	int    $0x40
 46d:	c3                   	ret    

0000046e <setgid>:
SYSCALL(setgid)
 46e:	b8 1c 00 00 00       	mov    $0x1c,%eax
 473:	cd 40                	int    $0x40
 475:	c3                   	ret    

00000476 <getprocs>:
SYSCALL(getprocs)
 476:	b8 1d 00 00 00       	mov    $0x1d,%eax
 47b:	cd 40                	int    $0x40
 47d:	c3                   	ret    

0000047e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 47e:	55                   	push   %ebp
 47f:	89 e5                	mov    %esp,%ebp
 481:	83 ec 18             	sub    $0x18,%esp
 484:	8b 45 0c             	mov    0xc(%ebp),%eax
 487:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 48a:	83 ec 04             	sub    $0x4,%esp
 48d:	6a 01                	push   $0x1
 48f:	8d 45 f4             	lea    -0xc(%ebp),%eax
 492:	50                   	push   %eax
 493:	ff 75 08             	pushl  0x8(%ebp)
 496:	e8 23 ff ff ff       	call   3be <write>
 49b:	83 c4 10             	add    $0x10,%esp
}
 49e:	90                   	nop
 49f:	c9                   	leave  
 4a0:	c3                   	ret    

000004a1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a1:	55                   	push   %ebp
 4a2:	89 e5                	mov    %esp,%ebp
 4a4:	53                   	push   %ebx
 4a5:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4af:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4b3:	74 17                	je     4cc <printint+0x2b>
 4b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4b9:	79 11                	jns    4cc <printint+0x2b>
    neg = 1;
 4bb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c5:	f7 d8                	neg    %eax
 4c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ca:	eb 06                	jmp    4d2 <printint+0x31>
  } else {
    x = xx;
 4cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4d9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4dc:	8d 41 01             	lea    0x1(%ecx),%eax
 4df:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e8:	ba 00 00 00 00       	mov    $0x0,%edx
 4ed:	f7 f3                	div    %ebx
 4ef:	89 d0                	mov    %edx,%eax
 4f1:	0f b6 80 a8 0b 00 00 	movzbl 0xba8(%eax),%eax
 4f8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 502:	ba 00 00 00 00       	mov    $0x0,%edx
 507:	f7 f3                	div    %ebx
 509:	89 45 ec             	mov    %eax,-0x14(%ebp)
 50c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 510:	75 c7                	jne    4d9 <printint+0x38>
  if(neg)
 512:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 516:	74 2d                	je     545 <printint+0xa4>
    buf[i++] = '-';
 518:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51b:	8d 50 01             	lea    0x1(%eax),%edx
 51e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 521:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 526:	eb 1d                	jmp    545 <printint+0xa4>
    putc(fd, buf[i]);
 528:	8d 55 dc             	lea    -0x24(%ebp),%edx
 52b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52e:	01 d0                	add    %edx,%eax
 530:	0f b6 00             	movzbl (%eax),%eax
 533:	0f be c0             	movsbl %al,%eax
 536:	83 ec 08             	sub    $0x8,%esp
 539:	50                   	push   %eax
 53a:	ff 75 08             	pushl  0x8(%ebp)
 53d:	e8 3c ff ff ff       	call   47e <putc>
 542:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 545:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 549:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 54d:	79 d9                	jns    528 <printint+0x87>
    putc(fd, buf[i]);
}
 54f:	90                   	nop
 550:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 553:	c9                   	leave  
 554:	c3                   	ret    

00000555 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 555:	55                   	push   %ebp
 556:	89 e5                	mov    %esp,%ebp
 558:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 55b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 562:	8d 45 0c             	lea    0xc(%ebp),%eax
 565:	83 c0 04             	add    $0x4,%eax
 568:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 56b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 572:	e9 59 01 00 00       	jmp    6d0 <printf+0x17b>
    c = fmt[i] & 0xff;
 577:	8b 55 0c             	mov    0xc(%ebp),%edx
 57a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 57d:	01 d0                	add    %edx,%eax
 57f:	0f b6 00             	movzbl (%eax),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	25 ff 00 00 00       	and    $0xff,%eax
 58a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 58d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 591:	75 2c                	jne    5bf <printf+0x6a>
      if(c == '%'){
 593:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 597:	75 0c                	jne    5a5 <printf+0x50>
        state = '%';
 599:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5a0:	e9 27 01 00 00       	jmp    6cc <printf+0x177>
      } else {
        putc(fd, c);
 5a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a8:	0f be c0             	movsbl %al,%eax
 5ab:	83 ec 08             	sub    $0x8,%esp
 5ae:	50                   	push   %eax
 5af:	ff 75 08             	pushl  0x8(%ebp)
 5b2:	e8 c7 fe ff ff       	call   47e <putc>
 5b7:	83 c4 10             	add    $0x10,%esp
 5ba:	e9 0d 01 00 00       	jmp    6cc <printf+0x177>
      }
    } else if(state == '%'){
 5bf:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5c3:	0f 85 03 01 00 00    	jne    6cc <printf+0x177>
      if(c == 'd'){
 5c9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5cd:	75 1e                	jne    5ed <printf+0x98>
        printint(fd, *ap, 10, 1);
 5cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d2:	8b 00                	mov    (%eax),%eax
 5d4:	6a 01                	push   $0x1
 5d6:	6a 0a                	push   $0xa
 5d8:	50                   	push   %eax
 5d9:	ff 75 08             	pushl  0x8(%ebp)
 5dc:	e8 c0 fe ff ff       	call   4a1 <printint>
 5e1:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e8:	e9 d8 00 00 00       	jmp    6c5 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5ed:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5f1:	74 06                	je     5f9 <printf+0xa4>
 5f3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5f7:	75 1e                	jne    617 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fc:	8b 00                	mov    (%eax),%eax
 5fe:	6a 00                	push   $0x0
 600:	6a 10                	push   $0x10
 602:	50                   	push   %eax
 603:	ff 75 08             	pushl  0x8(%ebp)
 606:	e8 96 fe ff ff       	call   4a1 <printint>
 60b:	83 c4 10             	add    $0x10,%esp
        ap++;
 60e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 612:	e9 ae 00 00 00       	jmp    6c5 <printf+0x170>
      } else if(c == 's'){
 617:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 61b:	75 43                	jne    660 <printf+0x10b>
        s = (char*)*ap;
 61d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 625:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 629:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 62d:	75 25                	jne    654 <printf+0xff>
          s = "(null)";
 62f:	c7 45 f4 32 09 00 00 	movl   $0x932,-0xc(%ebp)
        while(*s != 0){
 636:	eb 1c                	jmp    654 <printf+0xff>
          putc(fd, *s);
 638:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63b:	0f b6 00             	movzbl (%eax),%eax
 63e:	0f be c0             	movsbl %al,%eax
 641:	83 ec 08             	sub    $0x8,%esp
 644:	50                   	push   %eax
 645:	ff 75 08             	pushl  0x8(%ebp)
 648:	e8 31 fe ff ff       	call   47e <putc>
 64d:	83 c4 10             	add    $0x10,%esp
          s++;
 650:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 654:	8b 45 f4             	mov    -0xc(%ebp),%eax
 657:	0f b6 00             	movzbl (%eax),%eax
 65a:	84 c0                	test   %al,%al
 65c:	75 da                	jne    638 <printf+0xe3>
 65e:	eb 65                	jmp    6c5 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 660:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 664:	75 1d                	jne    683 <printf+0x12e>
        putc(fd, *ap);
 666:	8b 45 e8             	mov    -0x18(%ebp),%eax
 669:	8b 00                	mov    (%eax),%eax
 66b:	0f be c0             	movsbl %al,%eax
 66e:	83 ec 08             	sub    $0x8,%esp
 671:	50                   	push   %eax
 672:	ff 75 08             	pushl  0x8(%ebp)
 675:	e8 04 fe ff ff       	call   47e <putc>
 67a:	83 c4 10             	add    $0x10,%esp
        ap++;
 67d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 681:	eb 42                	jmp    6c5 <printf+0x170>
      } else if(c == '%'){
 683:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 687:	75 17                	jne    6a0 <printf+0x14b>
        putc(fd, c);
 689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68c:	0f be c0             	movsbl %al,%eax
 68f:	83 ec 08             	sub    $0x8,%esp
 692:	50                   	push   %eax
 693:	ff 75 08             	pushl  0x8(%ebp)
 696:	e8 e3 fd ff ff       	call   47e <putc>
 69b:	83 c4 10             	add    $0x10,%esp
 69e:	eb 25                	jmp    6c5 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a0:	83 ec 08             	sub    $0x8,%esp
 6a3:	6a 25                	push   $0x25
 6a5:	ff 75 08             	pushl  0x8(%ebp)
 6a8:	e8 d1 fd ff ff       	call   47e <putc>
 6ad:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b3:	0f be c0             	movsbl %al,%eax
 6b6:	83 ec 08             	sub    $0x8,%esp
 6b9:	50                   	push   %eax
 6ba:	ff 75 08             	pushl  0x8(%ebp)
 6bd:	e8 bc fd ff ff       	call   47e <putc>
 6c2:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6c5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6cc:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6d0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d6:	01 d0                	add    %edx,%eax
 6d8:	0f b6 00             	movzbl (%eax),%eax
 6db:	84 c0                	test   %al,%al
 6dd:	0f 85 94 fe ff ff    	jne    577 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6e3:	90                   	nop
 6e4:	c9                   	leave  
 6e5:	c3                   	ret    

000006e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e6:	55                   	push   %ebp
 6e7:	89 e5                	mov    %esp,%ebp
 6e9:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ec:	8b 45 08             	mov    0x8(%ebp),%eax
 6ef:	83 e8 08             	sub    $0x8,%eax
 6f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f5:	a1 c4 0b 00 00       	mov    0xbc4,%eax
 6fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6fd:	eb 24                	jmp    723 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 00                	mov    (%eax),%eax
 704:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 707:	77 12                	ja     71b <free+0x35>
 709:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70f:	77 24                	ja     735 <free+0x4f>
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 00                	mov    (%eax),%eax
 716:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 719:	77 1a                	ja     735 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71e:	8b 00                	mov    (%eax),%eax
 720:	89 45 fc             	mov    %eax,-0x4(%ebp)
 723:	8b 45 f8             	mov    -0x8(%ebp),%eax
 726:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 729:	76 d4                	jbe    6ff <free+0x19>
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	8b 00                	mov    (%eax),%eax
 730:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 733:	76 ca                	jbe    6ff <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 735:	8b 45 f8             	mov    -0x8(%ebp),%eax
 738:	8b 40 04             	mov    0x4(%eax),%eax
 73b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 742:	8b 45 f8             	mov    -0x8(%ebp),%eax
 745:	01 c2                	add    %eax,%edx
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	8b 00                	mov    (%eax),%eax
 74c:	39 c2                	cmp    %eax,%edx
 74e:	75 24                	jne    774 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 750:	8b 45 f8             	mov    -0x8(%ebp),%eax
 753:	8b 50 04             	mov    0x4(%eax),%edx
 756:	8b 45 fc             	mov    -0x4(%ebp),%eax
 759:	8b 00                	mov    (%eax),%eax
 75b:	8b 40 04             	mov    0x4(%eax),%eax
 75e:	01 c2                	add    %eax,%edx
 760:	8b 45 f8             	mov    -0x8(%ebp),%eax
 763:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 766:	8b 45 fc             	mov    -0x4(%ebp),%eax
 769:	8b 00                	mov    (%eax),%eax
 76b:	8b 10                	mov    (%eax),%edx
 76d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 770:	89 10                	mov    %edx,(%eax)
 772:	eb 0a                	jmp    77e <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 10                	mov    (%eax),%edx
 779:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77c:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 77e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 781:	8b 40 04             	mov    0x4(%eax),%eax
 784:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	01 d0                	add    %edx,%eax
 790:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 793:	75 20                	jne    7b5 <free+0xcf>
    p->s.size += bp->s.size;
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 50 04             	mov    0x4(%eax),%edx
 79b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79e:	8b 40 04             	mov    0x4(%eax),%eax
 7a1:	01 c2                	add    %eax,%edx
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ac:	8b 10                	mov    (%eax),%edx
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	89 10                	mov    %edx,(%eax)
 7b3:	eb 08                	jmp    7bd <free+0xd7>
  } else
    p->s.ptr = bp;
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7bb:	89 10                	mov    %edx,(%eax)
  freep = p;
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	a3 c4 0b 00 00       	mov    %eax,0xbc4
}
 7c5:	90                   	nop
 7c6:	c9                   	leave  
 7c7:	c3                   	ret    

000007c8 <morecore>:

static Header*
morecore(uint nu)
{
 7c8:	55                   	push   %ebp
 7c9:	89 e5                	mov    %esp,%ebp
 7cb:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ce:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7d5:	77 07                	ja     7de <morecore+0x16>
    nu = 4096;
 7d7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7de:	8b 45 08             	mov    0x8(%ebp),%eax
 7e1:	c1 e0 03             	shl    $0x3,%eax
 7e4:	83 ec 0c             	sub    $0xc,%esp
 7e7:	50                   	push   %eax
 7e8:	e8 39 fc ff ff       	call   426 <sbrk>
 7ed:	83 c4 10             	add    $0x10,%esp
 7f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7f3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7f7:	75 07                	jne    800 <morecore+0x38>
    return 0;
 7f9:	b8 00 00 00 00       	mov    $0x0,%eax
 7fe:	eb 26                	jmp    826 <morecore+0x5e>
  hp = (Header*)p;
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 806:	8b 45 f0             	mov    -0x10(%ebp),%eax
 809:	8b 55 08             	mov    0x8(%ebp),%edx
 80c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 80f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 812:	83 c0 08             	add    $0x8,%eax
 815:	83 ec 0c             	sub    $0xc,%esp
 818:	50                   	push   %eax
 819:	e8 c8 fe ff ff       	call   6e6 <free>
 81e:	83 c4 10             	add    $0x10,%esp
  return freep;
 821:	a1 c4 0b 00 00       	mov    0xbc4,%eax
}
 826:	c9                   	leave  
 827:	c3                   	ret    

00000828 <malloc>:

void*
malloc(uint nbytes)
{
 828:	55                   	push   %ebp
 829:	89 e5                	mov    %esp,%ebp
 82b:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82e:	8b 45 08             	mov    0x8(%ebp),%eax
 831:	83 c0 07             	add    $0x7,%eax
 834:	c1 e8 03             	shr    $0x3,%eax
 837:	83 c0 01             	add    $0x1,%eax
 83a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 83d:	a1 c4 0b 00 00       	mov    0xbc4,%eax
 842:	89 45 f0             	mov    %eax,-0x10(%ebp)
 845:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 849:	75 23                	jne    86e <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 84b:	c7 45 f0 bc 0b 00 00 	movl   $0xbbc,-0x10(%ebp)
 852:	8b 45 f0             	mov    -0x10(%ebp),%eax
 855:	a3 c4 0b 00 00       	mov    %eax,0xbc4
 85a:	a1 c4 0b 00 00       	mov    0xbc4,%eax
 85f:	a3 bc 0b 00 00       	mov    %eax,0xbbc
    base.s.size = 0;
 864:	c7 05 c0 0b 00 00 00 	movl   $0x0,0xbc0
 86b:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 871:	8b 00                	mov    (%eax),%eax
 873:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 876:	8b 45 f4             	mov    -0xc(%ebp),%eax
 879:	8b 40 04             	mov    0x4(%eax),%eax
 87c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87f:	72 4d                	jb     8ce <malloc+0xa6>
      if(p->s.size == nunits)
 881:	8b 45 f4             	mov    -0xc(%ebp),%eax
 884:	8b 40 04             	mov    0x4(%eax),%eax
 887:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 88a:	75 0c                	jne    898 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	8b 10                	mov    (%eax),%edx
 891:	8b 45 f0             	mov    -0x10(%ebp),%eax
 894:	89 10                	mov    %edx,(%eax)
 896:	eb 26                	jmp    8be <malloc+0x96>
      else {
        p->s.size -= nunits;
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	8b 40 04             	mov    0x4(%eax),%eax
 89e:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8a1:	89 c2                	mov    %eax,%edx
 8a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a6:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ac:	8b 40 04             	mov    0x4(%eax),%eax
 8af:	c1 e0 03             	shl    $0x3,%eax
 8b2:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8bb:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c1:	a3 c4 0b 00 00       	mov    %eax,0xbc4
      return (void*)(p + 1);
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	83 c0 08             	add    $0x8,%eax
 8cc:	eb 3b                	jmp    909 <malloc+0xe1>
    }
    if(p == freep)
 8ce:	a1 c4 0b 00 00       	mov    0xbc4,%eax
 8d3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8d6:	75 1e                	jne    8f6 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8d8:	83 ec 0c             	sub    $0xc,%esp
 8db:	ff 75 ec             	pushl  -0x14(%ebp)
 8de:	e8 e5 fe ff ff       	call   7c8 <morecore>
 8e3:	83 c4 10             	add    $0x10,%esp
 8e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ed:	75 07                	jne    8f6 <malloc+0xce>
        return 0;
 8ef:	b8 00 00 00 00       	mov    $0x0,%eax
 8f4:	eb 13                	jmp    909 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ff:	8b 00                	mov    (%eax),%eax
 901:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 904:	e9 6d ff ff ff       	jmp    876 <malloc+0x4e>
}
 909:	c9                   	leave  
 90a:	c3                   	ret    
