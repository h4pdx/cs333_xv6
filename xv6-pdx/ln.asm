
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
  19:	68 13 09 00 00       	push   $0x913
  1e:	6a 02                	push   $0x2
  20:	e8 38 05 00 00       	call   55d <printf>
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
  60:	68 26 09 00 00       	push   $0x926
  65:	6a 02                	push   $0x2
  67:	e8 f1 04 00 00       	call   55d <printf>
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

0000047e <setpriority>:
SYSCALL(setpriority)
 47e:	b8 1e 00 00 00       	mov    $0x1e,%eax
 483:	cd 40                	int    $0x40
 485:	c3                   	ret    

00000486 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 486:	55                   	push   %ebp
 487:	89 e5                	mov    %esp,%ebp
 489:	83 ec 18             	sub    $0x18,%esp
 48c:	8b 45 0c             	mov    0xc(%ebp),%eax
 48f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 492:	83 ec 04             	sub    $0x4,%esp
 495:	6a 01                	push   $0x1
 497:	8d 45 f4             	lea    -0xc(%ebp),%eax
 49a:	50                   	push   %eax
 49b:	ff 75 08             	pushl  0x8(%ebp)
 49e:	e8 1b ff ff ff       	call   3be <write>
 4a3:	83 c4 10             	add    $0x10,%esp
}
 4a6:	90                   	nop
 4a7:	c9                   	leave  
 4a8:	c3                   	ret    

000004a9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a9:	55                   	push   %ebp
 4aa:	89 e5                	mov    %esp,%ebp
 4ac:	53                   	push   %ebx
 4ad:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4b7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4bb:	74 17                	je     4d4 <printint+0x2b>
 4bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4c1:	79 11                	jns    4d4 <printint+0x2b>
    neg = 1;
 4c3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cd:	f7 d8                	neg    %eax
 4cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d2:	eb 06                	jmp    4da <printint+0x31>
  } else {
    x = xx;
 4d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4e1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4e4:	8d 41 01             	lea    0x1(%ecx),%eax
 4e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f0:	ba 00 00 00 00       	mov    $0x0,%edx
 4f5:	f7 f3                	div    %ebx
 4f7:	89 d0                	mov    %edx,%eax
 4f9:	0f b6 80 b0 0b 00 00 	movzbl 0xbb0(%eax),%eax
 500:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 504:	8b 5d 10             	mov    0x10(%ebp),%ebx
 507:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50a:	ba 00 00 00 00       	mov    $0x0,%edx
 50f:	f7 f3                	div    %ebx
 511:	89 45 ec             	mov    %eax,-0x14(%ebp)
 514:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 518:	75 c7                	jne    4e1 <printint+0x38>
  if(neg)
 51a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 51e:	74 2d                	je     54d <printint+0xa4>
    buf[i++] = '-';
 520:	8b 45 f4             	mov    -0xc(%ebp),%eax
 523:	8d 50 01             	lea    0x1(%eax),%edx
 526:	89 55 f4             	mov    %edx,-0xc(%ebp)
 529:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 52e:	eb 1d                	jmp    54d <printint+0xa4>
    putc(fd, buf[i]);
 530:	8d 55 dc             	lea    -0x24(%ebp),%edx
 533:	8b 45 f4             	mov    -0xc(%ebp),%eax
 536:	01 d0                	add    %edx,%eax
 538:	0f b6 00             	movzbl (%eax),%eax
 53b:	0f be c0             	movsbl %al,%eax
 53e:	83 ec 08             	sub    $0x8,%esp
 541:	50                   	push   %eax
 542:	ff 75 08             	pushl  0x8(%ebp)
 545:	e8 3c ff ff ff       	call   486 <putc>
 54a:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 54d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 551:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 555:	79 d9                	jns    530 <printint+0x87>
    putc(fd, buf[i]);
}
 557:	90                   	nop
 558:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 55b:	c9                   	leave  
 55c:	c3                   	ret    

0000055d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 55d:	55                   	push   %ebp
 55e:	89 e5                	mov    %esp,%ebp
 560:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 563:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 56a:	8d 45 0c             	lea    0xc(%ebp),%eax
 56d:	83 c0 04             	add    $0x4,%eax
 570:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 573:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 57a:	e9 59 01 00 00       	jmp    6d8 <printf+0x17b>
    c = fmt[i] & 0xff;
 57f:	8b 55 0c             	mov    0xc(%ebp),%edx
 582:	8b 45 f0             	mov    -0x10(%ebp),%eax
 585:	01 d0                	add    %edx,%eax
 587:	0f b6 00             	movzbl (%eax),%eax
 58a:	0f be c0             	movsbl %al,%eax
 58d:	25 ff 00 00 00       	and    $0xff,%eax
 592:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 595:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 599:	75 2c                	jne    5c7 <printf+0x6a>
      if(c == '%'){
 59b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 59f:	75 0c                	jne    5ad <printf+0x50>
        state = '%';
 5a1:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5a8:	e9 27 01 00 00       	jmp    6d4 <printf+0x177>
      } else {
        putc(fd, c);
 5ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	83 ec 08             	sub    $0x8,%esp
 5b6:	50                   	push   %eax
 5b7:	ff 75 08             	pushl  0x8(%ebp)
 5ba:	e8 c7 fe ff ff       	call   486 <putc>
 5bf:	83 c4 10             	add    $0x10,%esp
 5c2:	e9 0d 01 00 00       	jmp    6d4 <printf+0x177>
      }
    } else if(state == '%'){
 5c7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5cb:	0f 85 03 01 00 00    	jne    6d4 <printf+0x177>
      if(c == 'd'){
 5d1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5d5:	75 1e                	jne    5f5 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5da:	8b 00                	mov    (%eax),%eax
 5dc:	6a 01                	push   $0x1
 5de:	6a 0a                	push   $0xa
 5e0:	50                   	push   %eax
 5e1:	ff 75 08             	pushl  0x8(%ebp)
 5e4:	e8 c0 fe ff ff       	call   4a9 <printint>
 5e9:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f0:	e9 d8 00 00 00       	jmp    6cd <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5f5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5f9:	74 06                	je     601 <printf+0xa4>
 5fb:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5ff:	75 1e                	jne    61f <printf+0xc2>
        printint(fd, *ap, 16, 0);
 601:	8b 45 e8             	mov    -0x18(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	6a 00                	push   $0x0
 608:	6a 10                	push   $0x10
 60a:	50                   	push   %eax
 60b:	ff 75 08             	pushl  0x8(%ebp)
 60e:	e8 96 fe ff ff       	call   4a9 <printint>
 613:	83 c4 10             	add    $0x10,%esp
        ap++;
 616:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 61a:	e9 ae 00 00 00       	jmp    6cd <printf+0x170>
      } else if(c == 's'){
 61f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 623:	75 43                	jne    668 <printf+0x10b>
        s = (char*)*ap;
 625:	8b 45 e8             	mov    -0x18(%ebp),%eax
 628:	8b 00                	mov    (%eax),%eax
 62a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 62d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 635:	75 25                	jne    65c <printf+0xff>
          s = "(null)";
 637:	c7 45 f4 3a 09 00 00 	movl   $0x93a,-0xc(%ebp)
        while(*s != 0){
 63e:	eb 1c                	jmp    65c <printf+0xff>
          putc(fd, *s);
 640:	8b 45 f4             	mov    -0xc(%ebp),%eax
 643:	0f b6 00             	movzbl (%eax),%eax
 646:	0f be c0             	movsbl %al,%eax
 649:	83 ec 08             	sub    $0x8,%esp
 64c:	50                   	push   %eax
 64d:	ff 75 08             	pushl  0x8(%ebp)
 650:	e8 31 fe ff ff       	call   486 <putc>
 655:	83 c4 10             	add    $0x10,%esp
          s++;
 658:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 65c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65f:	0f b6 00             	movzbl (%eax),%eax
 662:	84 c0                	test   %al,%al
 664:	75 da                	jne    640 <printf+0xe3>
 666:	eb 65                	jmp    6cd <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 668:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 66c:	75 1d                	jne    68b <printf+0x12e>
        putc(fd, *ap);
 66e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 671:	8b 00                	mov    (%eax),%eax
 673:	0f be c0             	movsbl %al,%eax
 676:	83 ec 08             	sub    $0x8,%esp
 679:	50                   	push   %eax
 67a:	ff 75 08             	pushl  0x8(%ebp)
 67d:	e8 04 fe ff ff       	call   486 <putc>
 682:	83 c4 10             	add    $0x10,%esp
        ap++;
 685:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 689:	eb 42                	jmp    6cd <printf+0x170>
      } else if(c == '%'){
 68b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 68f:	75 17                	jne    6a8 <printf+0x14b>
        putc(fd, c);
 691:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 694:	0f be c0             	movsbl %al,%eax
 697:	83 ec 08             	sub    $0x8,%esp
 69a:	50                   	push   %eax
 69b:	ff 75 08             	pushl  0x8(%ebp)
 69e:	e8 e3 fd ff ff       	call   486 <putc>
 6a3:	83 c4 10             	add    $0x10,%esp
 6a6:	eb 25                	jmp    6cd <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a8:	83 ec 08             	sub    $0x8,%esp
 6ab:	6a 25                	push   $0x25
 6ad:	ff 75 08             	pushl  0x8(%ebp)
 6b0:	e8 d1 fd ff ff       	call   486 <putc>
 6b5:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6bb:	0f be c0             	movsbl %al,%eax
 6be:	83 ec 08             	sub    $0x8,%esp
 6c1:	50                   	push   %eax
 6c2:	ff 75 08             	pushl  0x8(%ebp)
 6c5:	e8 bc fd ff ff       	call   486 <putc>
 6ca:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6d4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6d8:	8b 55 0c             	mov    0xc(%ebp),%edx
 6db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6de:	01 d0                	add    %edx,%eax
 6e0:	0f b6 00             	movzbl (%eax),%eax
 6e3:	84 c0                	test   %al,%al
 6e5:	0f 85 94 fe ff ff    	jne    57f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6eb:	90                   	nop
 6ec:	c9                   	leave  
 6ed:	c3                   	ret    

000006ee <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ee:	55                   	push   %ebp
 6ef:	89 e5                	mov    %esp,%ebp
 6f1:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f4:	8b 45 08             	mov    0x8(%ebp),%eax
 6f7:	83 e8 08             	sub    $0x8,%eax
 6fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fd:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 702:	89 45 fc             	mov    %eax,-0x4(%ebp)
 705:	eb 24                	jmp    72b <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 707:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70f:	77 12                	ja     723 <free+0x35>
 711:	8b 45 f8             	mov    -0x8(%ebp),%eax
 714:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 717:	77 24                	ja     73d <free+0x4f>
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 721:	77 1a                	ja     73d <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 723:	8b 45 fc             	mov    -0x4(%ebp),%eax
 726:	8b 00                	mov    (%eax),%eax
 728:	89 45 fc             	mov    %eax,-0x4(%ebp)
 72b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 731:	76 d4                	jbe    707 <free+0x19>
 733:	8b 45 fc             	mov    -0x4(%ebp),%eax
 736:	8b 00                	mov    (%eax),%eax
 738:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73b:	76 ca                	jbe    707 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 73d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 740:	8b 40 04             	mov    0x4(%eax),%eax
 743:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 74a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74d:	01 c2                	add    %eax,%edx
 74f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 752:	8b 00                	mov    (%eax),%eax
 754:	39 c2                	cmp    %eax,%edx
 756:	75 24                	jne    77c <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 758:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75b:	8b 50 04             	mov    0x4(%eax),%edx
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	8b 00                	mov    (%eax),%eax
 763:	8b 40 04             	mov    0x4(%eax),%eax
 766:	01 c2                	add    %eax,%edx
 768:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76b:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 76e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 771:	8b 00                	mov    (%eax),%eax
 773:	8b 10                	mov    (%eax),%edx
 775:	8b 45 f8             	mov    -0x8(%ebp),%eax
 778:	89 10                	mov    %edx,(%eax)
 77a:	eb 0a                	jmp    786 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	8b 10                	mov    (%eax),%edx
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 786:	8b 45 fc             	mov    -0x4(%ebp),%eax
 789:	8b 40 04             	mov    0x4(%eax),%eax
 78c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	01 d0                	add    %edx,%eax
 798:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79b:	75 20                	jne    7bd <free+0xcf>
    p->s.size += bp->s.size;
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 50 04             	mov    0x4(%eax),%edx
 7a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a6:	8b 40 04             	mov    0x4(%eax),%eax
 7a9:	01 c2                	add    %eax,%edx
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b4:	8b 10                	mov    (%eax),%edx
 7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b9:	89 10                	mov    %edx,(%eax)
 7bb:	eb 08                	jmp    7c5 <free+0xd7>
  } else
    p->s.ptr = bp;
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c3:	89 10                	mov    %edx,(%eax)
  freep = p;
 7c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c8:	a3 cc 0b 00 00       	mov    %eax,0xbcc
}
 7cd:	90                   	nop
 7ce:	c9                   	leave  
 7cf:	c3                   	ret    

000007d0 <morecore>:

static Header*
morecore(uint nu)
{
 7d0:	55                   	push   %ebp
 7d1:	89 e5                	mov    %esp,%ebp
 7d3:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7d6:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7dd:	77 07                	ja     7e6 <morecore+0x16>
    nu = 4096;
 7df:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7e6:	8b 45 08             	mov    0x8(%ebp),%eax
 7e9:	c1 e0 03             	shl    $0x3,%eax
 7ec:	83 ec 0c             	sub    $0xc,%esp
 7ef:	50                   	push   %eax
 7f0:	e8 31 fc ff ff       	call   426 <sbrk>
 7f5:	83 c4 10             	add    $0x10,%esp
 7f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7fb:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ff:	75 07                	jne    808 <morecore+0x38>
    return 0;
 801:	b8 00 00 00 00       	mov    $0x0,%eax
 806:	eb 26                	jmp    82e <morecore+0x5e>
  hp = (Header*)p;
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 80e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 811:	8b 55 08             	mov    0x8(%ebp),%edx
 814:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 817:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81a:	83 c0 08             	add    $0x8,%eax
 81d:	83 ec 0c             	sub    $0xc,%esp
 820:	50                   	push   %eax
 821:	e8 c8 fe ff ff       	call   6ee <free>
 826:	83 c4 10             	add    $0x10,%esp
  return freep;
 829:	a1 cc 0b 00 00       	mov    0xbcc,%eax
}
 82e:	c9                   	leave  
 82f:	c3                   	ret    

00000830 <malloc>:

void*
malloc(uint nbytes)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 836:	8b 45 08             	mov    0x8(%ebp),%eax
 839:	83 c0 07             	add    $0x7,%eax
 83c:	c1 e8 03             	shr    $0x3,%eax
 83f:	83 c0 01             	add    $0x1,%eax
 842:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 845:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 84a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 84d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 851:	75 23                	jne    876 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 853:	c7 45 f0 c4 0b 00 00 	movl   $0xbc4,-0x10(%ebp)
 85a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85d:	a3 cc 0b 00 00       	mov    %eax,0xbcc
 862:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 867:	a3 c4 0b 00 00       	mov    %eax,0xbc4
    base.s.size = 0;
 86c:	c7 05 c8 0b 00 00 00 	movl   $0x0,0xbc8
 873:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 876:	8b 45 f0             	mov    -0x10(%ebp),%eax
 879:	8b 00                	mov    (%eax),%eax
 87b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 87e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 881:	8b 40 04             	mov    0x4(%eax),%eax
 884:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 887:	72 4d                	jb     8d6 <malloc+0xa6>
      if(p->s.size == nunits)
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	8b 40 04             	mov    0x4(%eax),%eax
 88f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 892:	75 0c                	jne    8a0 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	8b 10                	mov    (%eax),%edx
 899:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89c:	89 10                	mov    %edx,(%eax)
 89e:	eb 26                	jmp    8c6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	8b 40 04             	mov    0x4(%eax),%eax
 8a6:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8a9:	89 c2                	mov    %eax,%edx
 8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ae:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b4:	8b 40 04             	mov    0x4(%eax),%eax
 8b7:	c1 e0 03             	shl    $0x3,%eax
 8ba:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8c3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c9:	a3 cc 0b 00 00       	mov    %eax,0xbcc
      return (void*)(p + 1);
 8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d1:	83 c0 08             	add    $0x8,%eax
 8d4:	eb 3b                	jmp    911 <malloc+0xe1>
    }
    if(p == freep)
 8d6:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 8db:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8de:	75 1e                	jne    8fe <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8e0:	83 ec 0c             	sub    $0xc,%esp
 8e3:	ff 75 ec             	pushl  -0x14(%ebp)
 8e6:	e8 e5 fe ff ff       	call   7d0 <morecore>
 8eb:	83 c4 10             	add    $0x10,%esp
 8ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8f5:	75 07                	jne    8fe <malloc+0xce>
        return 0;
 8f7:	b8 00 00 00 00       	mov    $0x0,%eax
 8fc:	eb 13                	jmp    911 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 901:	89 45 f0             	mov    %eax,-0x10(%ebp)
 904:	8b 45 f4             	mov    -0xc(%ebp),%eax
 907:	8b 00                	mov    (%eax),%eax
 909:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 90c:	e9 6d ff ff ff       	jmp    87e <malloc+0x4e>
}
 911:	c9                   	leave  
 912:	c3                   	ret    
