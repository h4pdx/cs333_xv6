
_testsetuid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
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
  printf(1, "***** In %s: my uid is %d\n\n", argv[0], getuid());
  11:	e8 f7 03 00 00       	call   40d <getuid>
  16:	89 c2                	mov    %eax,%edx
  18:	8b 43 04             	mov    0x4(%ebx),%eax
  1b:	8b 00                	mov    (%eax),%eax
  1d:	52                   	push   %edx
  1e:	50                   	push   %eax
  1f:	68 ea 08 00 00       	push   $0x8ea
  24:	6a 01                	push   $0x1
  26:	e8 09 05 00 00       	call   534 <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  exit();
  2e:	e8 2a 03 00 00       	call   35d <exit>

00000033 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  33:	55                   	push   %ebp
  34:	89 e5                	mov    %esp,%ebp
  36:	57                   	push   %edi
  37:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  3b:	8b 55 10             	mov    0x10(%ebp),%edx
  3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  41:	89 cb                	mov    %ecx,%ebx
  43:	89 df                	mov    %ebx,%edi
  45:	89 d1                	mov    %edx,%ecx
  47:	fc                   	cld    
  48:	f3 aa                	rep stos %al,%es:(%edi)
  4a:	89 ca                	mov    %ecx,%edx
  4c:	89 fb                	mov    %edi,%ebx
  4e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  51:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  54:	90                   	nop
  55:	5b                   	pop    %ebx
  56:	5f                   	pop    %edi
  57:	5d                   	pop    %ebp
  58:	c3                   	ret    

00000059 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  59:	55                   	push   %ebp
  5a:	89 e5                	mov    %esp,%ebp
  5c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  5f:	8b 45 08             	mov    0x8(%ebp),%eax
  62:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  65:	90                   	nop
  66:	8b 45 08             	mov    0x8(%ebp),%eax
  69:	8d 50 01             	lea    0x1(%eax),%edx
  6c:	89 55 08             	mov    %edx,0x8(%ebp)
  6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  72:	8d 4a 01             	lea    0x1(%edx),%ecx
  75:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  78:	0f b6 12             	movzbl (%edx),%edx
  7b:	88 10                	mov    %dl,(%eax)
  7d:	0f b6 00             	movzbl (%eax),%eax
  80:	84 c0                	test   %al,%al
  82:	75 e2                	jne    66 <strcpy+0xd>
    ;
  return os;
  84:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  87:	c9                   	leave  
  88:	c3                   	ret    

00000089 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  89:	55                   	push   %ebp
  8a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  8c:	eb 08                	jmp    96 <strcmp+0xd>
    p++, q++;
  8e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  92:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  96:	8b 45 08             	mov    0x8(%ebp),%eax
  99:	0f b6 00             	movzbl (%eax),%eax
  9c:	84 c0                	test   %al,%al
  9e:	74 10                	je     b0 <strcmp+0x27>
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	0f b6 10             	movzbl (%eax),%edx
  a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  a9:	0f b6 00             	movzbl (%eax),%eax
  ac:	38 c2                	cmp    %al,%dl
  ae:	74 de                	je     8e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	0f b6 00             	movzbl (%eax),%eax
  b6:	0f b6 d0             	movzbl %al,%edx
  b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	0f b6 c0             	movzbl %al,%eax
  c2:	29 c2                	sub    %eax,%edx
  c4:	89 d0                	mov    %edx,%eax
}
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret    

000000c8 <strlen>:

uint
strlen(char *s)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  cb:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  d5:	eb 04                	jmp    db <strlen+0x13>
  d7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  de:	8b 45 08             	mov    0x8(%ebp),%eax
  e1:	01 d0                	add    %edx,%eax
  e3:	0f b6 00             	movzbl (%eax),%eax
  e6:	84 c0                	test   %al,%al
  e8:	75 ed                	jne    d7 <strlen+0xf>
    ;
  return n;
  ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  ed:	c9                   	leave  
  ee:	c3                   	ret    

000000ef <memset>:

void*
memset(void *dst, int c, uint n)
{
  ef:	55                   	push   %ebp
  f0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
  f2:	8b 45 10             	mov    0x10(%ebp),%eax
  f5:	50                   	push   %eax
  f6:	ff 75 0c             	pushl  0xc(%ebp)
  f9:	ff 75 08             	pushl  0x8(%ebp)
  fc:	e8 32 ff ff ff       	call   33 <stosb>
 101:	83 c4 0c             	add    $0xc,%esp
  return dst;
 104:	8b 45 08             	mov    0x8(%ebp),%eax
}
 107:	c9                   	leave  
 108:	c3                   	ret    

00000109 <strchr>:

char*
strchr(const char *s, char c)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 04             	sub    $0x4,%esp
 10f:	8b 45 0c             	mov    0xc(%ebp),%eax
 112:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 115:	eb 14                	jmp    12b <strchr+0x22>
    if(*s == c)
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	0f b6 00             	movzbl (%eax),%eax
 11d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 120:	75 05                	jne    127 <strchr+0x1e>
      return (char*)s;
 122:	8b 45 08             	mov    0x8(%ebp),%eax
 125:	eb 13                	jmp    13a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 127:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	0f b6 00             	movzbl (%eax),%eax
 131:	84 c0                	test   %al,%al
 133:	75 e2                	jne    117 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 135:	b8 00 00 00 00       	mov    $0x0,%eax
}
 13a:	c9                   	leave  
 13b:	c3                   	ret    

0000013c <gets>:

char*
gets(char *buf, int max)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 142:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 149:	eb 42                	jmp    18d <gets+0x51>
    cc = read(0, &c, 1);
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	6a 01                	push   $0x1
 150:	8d 45 ef             	lea    -0x11(%ebp),%eax
 153:	50                   	push   %eax
 154:	6a 00                	push   $0x0
 156:	e8 1a 02 00 00       	call   375 <read>
 15b:	83 c4 10             	add    $0x10,%esp
 15e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 161:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 165:	7e 33                	jle    19a <gets+0x5e>
      break;
    buf[i++] = c;
 167:	8b 45 f4             	mov    -0xc(%ebp),%eax
 16a:	8d 50 01             	lea    0x1(%eax),%edx
 16d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 170:	89 c2                	mov    %eax,%edx
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	01 c2                	add    %eax,%edx
 177:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 17d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 181:	3c 0a                	cmp    $0xa,%al
 183:	74 16                	je     19b <gets+0x5f>
 185:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 189:	3c 0d                	cmp    $0xd,%al
 18b:	74 0e                	je     19b <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 18d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 190:	83 c0 01             	add    $0x1,%eax
 193:	3b 45 0c             	cmp    0xc(%ebp),%eax
 196:	7c b3                	jl     14b <gets+0xf>
 198:	eb 01                	jmp    19b <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 19a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 19b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	01 d0                	add    %edx,%eax
 1a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <stat>:

int
stat(char *n, struct stat *st)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b1:	83 ec 08             	sub    $0x8,%esp
 1b4:	6a 00                	push   $0x0
 1b6:	ff 75 08             	pushl  0x8(%ebp)
 1b9:	e8 df 01 00 00       	call   39d <open>
 1be:	83 c4 10             	add    $0x10,%esp
 1c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1c8:	79 07                	jns    1d1 <stat+0x26>
    return -1;
 1ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1cf:	eb 25                	jmp    1f6 <stat+0x4b>
  r = fstat(fd, st);
 1d1:	83 ec 08             	sub    $0x8,%esp
 1d4:	ff 75 0c             	pushl  0xc(%ebp)
 1d7:	ff 75 f4             	pushl  -0xc(%ebp)
 1da:	e8 d6 01 00 00       	call   3b5 <fstat>
 1df:	83 c4 10             	add    $0x10,%esp
 1e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1e5:	83 ec 0c             	sub    $0xc,%esp
 1e8:	ff 75 f4             	pushl  -0xc(%ebp)
 1eb:	e8 95 01 00 00       	call   385 <close>
 1f0:	83 c4 10             	add    $0x10,%esp
  return r;
 1f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f6:	c9                   	leave  
 1f7:	c3                   	ret    

000001f8 <atoi>:

int
atoi(const char *s)
{
 1f8:	55                   	push   %ebp
 1f9:	89 e5                	mov    %esp,%ebp
 1fb:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 1fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 205:	eb 04                	jmp    20b <atoi+0x13>
 207:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	0f b6 00             	movzbl (%eax),%eax
 211:	3c 20                	cmp    $0x20,%al
 213:	74 f2                	je     207 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	0f b6 00             	movzbl (%eax),%eax
 21b:	3c 2d                	cmp    $0x2d,%al
 21d:	75 07                	jne    226 <atoi+0x2e>
 21f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 224:	eb 05                	jmp    22b <atoi+0x33>
 226:	b8 01 00 00 00       	mov    $0x1,%eax
 22b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	0f b6 00             	movzbl (%eax),%eax
 234:	3c 2b                	cmp    $0x2b,%al
 236:	74 0a                	je     242 <atoi+0x4a>
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	3c 2d                	cmp    $0x2d,%al
 240:	75 2b                	jne    26d <atoi+0x75>
    s++;
 242:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 25                	jmp    26d <atoi+0x75>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	89 c1                	mov    %eax,%ecx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 08             	mov    %edx,0x8(%ebp)
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f be c0             	movsbl %al,%eax
 265:	01 c8                	add    %ecx,%eax
 267:	83 e8 30             	sub    $0x30,%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x89>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c7                	jle    248 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 281:	8b 45 f8             	mov    -0x8(%ebp),%eax
 284:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <atoo>:

int
atoo(const char *s)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 290:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 297:	eb 04                	jmp    29d <atoo+0x13>
 299:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	3c 20                	cmp    $0x20,%al
 2a5:	74 f2                	je     299 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	3c 2d                	cmp    $0x2d,%al
 2af:	75 07                	jne    2b8 <atoo+0x2e>
 2b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2b6:	eb 05                	jmp    2bd <atoo+0x33>
 2b8:	b8 01 00 00 00       	mov    $0x1,%eax
 2bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	0f b6 00             	movzbl (%eax),%eax
 2c6:	3c 2b                	cmp    $0x2b,%al
 2c8:	74 0a                	je     2d4 <atoo+0x4a>
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
 2cd:	0f b6 00             	movzbl (%eax),%eax
 2d0:	3c 2d                	cmp    $0x2d,%al
 2d2:	75 27                	jne    2fb <atoo+0x71>
    s++;
 2d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 2d8:	eb 21                	jmp    2fb <atoo+0x71>
    n = n*8 + *s++ - '0';
 2da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2dd:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	8d 50 01             	lea    0x1(%eax),%edx
 2ea:	89 55 08             	mov    %edx,0x8(%ebp)
 2ed:	0f b6 00             	movzbl (%eax),%eax
 2f0:	0f be c0             	movsbl %al,%eax
 2f3:	01 c8                	add    %ecx,%eax
 2f5:	83 e8 30             	sub    $0x30,%eax
 2f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 2fb:	8b 45 08             	mov    0x8(%ebp),%eax
 2fe:	0f b6 00             	movzbl (%eax),%eax
 301:	3c 2f                	cmp    $0x2f,%al
 303:	7e 0a                	jle    30f <atoo+0x85>
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	0f b6 00             	movzbl (%eax),%eax
 30b:	3c 37                	cmp    $0x37,%al
 30d:	7e cb                	jle    2da <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 30f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 312:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 316:	c9                   	leave  
 317:	c3                   	ret    

00000318 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 324:	8b 45 0c             	mov    0xc(%ebp),%eax
 327:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 32a:	eb 17                	jmp    343 <memmove+0x2b>
    *dst++ = *src++;
 32c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 32f:	8d 50 01             	lea    0x1(%eax),%edx
 332:	89 55 fc             	mov    %edx,-0x4(%ebp)
 335:	8b 55 f8             	mov    -0x8(%ebp),%edx
 338:	8d 4a 01             	lea    0x1(%edx),%ecx
 33b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 33e:	0f b6 12             	movzbl (%edx),%edx
 341:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 343:	8b 45 10             	mov    0x10(%ebp),%eax
 346:	8d 50 ff             	lea    -0x1(%eax),%edx
 349:	89 55 10             	mov    %edx,0x10(%ebp)
 34c:	85 c0                	test   %eax,%eax
 34e:	7f dc                	jg     32c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 355:	b8 01 00 00 00       	mov    $0x1,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <exit>:
SYSCALL(exit)
 35d:	b8 02 00 00 00       	mov    $0x2,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <wait>:
SYSCALL(wait)
 365:	b8 03 00 00 00       	mov    $0x3,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <pipe>:
SYSCALL(pipe)
 36d:	b8 04 00 00 00       	mov    $0x4,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <read>:
SYSCALL(read)
 375:	b8 05 00 00 00       	mov    $0x5,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <write>:
SYSCALL(write)
 37d:	b8 10 00 00 00       	mov    $0x10,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <close>:
SYSCALL(close)
 385:	b8 15 00 00 00       	mov    $0x15,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <kill>:
SYSCALL(kill)
 38d:	b8 06 00 00 00       	mov    $0x6,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <exec>:
SYSCALL(exec)
 395:	b8 07 00 00 00       	mov    $0x7,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <open>:
SYSCALL(open)
 39d:	b8 0f 00 00 00       	mov    $0xf,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <mknod>:
SYSCALL(mknod)
 3a5:	b8 11 00 00 00       	mov    $0x11,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <unlink>:
SYSCALL(unlink)
 3ad:	b8 12 00 00 00       	mov    $0x12,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <fstat>:
SYSCALL(fstat)
 3b5:	b8 08 00 00 00       	mov    $0x8,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <link>:
SYSCALL(link)
 3bd:	b8 13 00 00 00       	mov    $0x13,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <mkdir>:
SYSCALL(mkdir)
 3c5:	b8 14 00 00 00       	mov    $0x14,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <chdir>:
SYSCALL(chdir)
 3cd:	b8 09 00 00 00       	mov    $0x9,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <dup>:
SYSCALL(dup)
 3d5:	b8 0a 00 00 00       	mov    $0xa,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <getpid>:
SYSCALL(getpid)
 3dd:	b8 0b 00 00 00       	mov    $0xb,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <sbrk>:
SYSCALL(sbrk)
 3e5:	b8 0c 00 00 00       	mov    $0xc,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <sleep>:
SYSCALL(sleep)
 3ed:	b8 0d 00 00 00       	mov    $0xd,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <uptime>:
SYSCALL(uptime)
 3f5:	b8 0e 00 00 00       	mov    $0xe,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <halt>:
SYSCALL(halt)
 3fd:	b8 16 00 00 00       	mov    $0x16,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <date>:
SYSCALL(date)
 405:	b8 17 00 00 00       	mov    $0x17,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <getuid>:
SYSCALL(getuid)
 40d:	b8 18 00 00 00       	mov    $0x18,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <getgid>:
SYSCALL(getgid)
 415:	b8 19 00 00 00       	mov    $0x19,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <getppid>:
SYSCALL(getppid)
 41d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <setuid>:
SYSCALL(setuid)
 425:	b8 1b 00 00 00       	mov    $0x1b,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <setgid>:
SYSCALL(setgid)
 42d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <getprocs>:
SYSCALL(getprocs)
 435:	b8 1d 00 00 00       	mov    $0x1d,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <setpriority>:
SYSCALL(setpriority)
 43d:	b8 1e 00 00 00       	mov    $0x1e,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <chmod>:
SYSCALL(chmod)
 445:	b8 1f 00 00 00       	mov    $0x1f,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <chown>:
SYSCALL(chown)
 44d:	b8 20 00 00 00       	mov    $0x20,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <chgrp>:
SYSCALL(chgrp)
 455:	b8 21 00 00 00       	mov    $0x21,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 45d:	55                   	push   %ebp
 45e:	89 e5                	mov    %esp,%ebp
 460:	83 ec 18             	sub    $0x18,%esp
 463:	8b 45 0c             	mov    0xc(%ebp),%eax
 466:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 469:	83 ec 04             	sub    $0x4,%esp
 46c:	6a 01                	push   $0x1
 46e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 471:	50                   	push   %eax
 472:	ff 75 08             	pushl  0x8(%ebp)
 475:	e8 03 ff ff ff       	call   37d <write>
 47a:	83 c4 10             	add    $0x10,%esp
}
 47d:	90                   	nop
 47e:	c9                   	leave  
 47f:	c3                   	ret    

00000480 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	53                   	push   %ebx
 484:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 487:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 48e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 492:	74 17                	je     4ab <printint+0x2b>
 494:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 498:	79 11                	jns    4ab <printint+0x2b>
    neg = 1;
 49a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a4:	f7 d8                	neg    %eax
 4a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a9:	eb 06                	jmp    4b1 <printint+0x31>
  } else {
    x = xx;
 4ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4bb:	8d 41 01             	lea    0x1(%ecx),%eax
 4be:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c7:	ba 00 00 00 00       	mov    $0x0,%edx
 4cc:	f7 f3                	div    %ebx
 4ce:	89 d0                	mov    %edx,%eax
 4d0:	0f b6 80 7c 0b 00 00 	movzbl 0xb7c(%eax),%eax
 4d7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4db:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4de:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e1:	ba 00 00 00 00       	mov    $0x0,%edx
 4e6:	f7 f3                	div    %ebx
 4e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ef:	75 c7                	jne    4b8 <printint+0x38>
  if(neg)
 4f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f5:	74 2d                	je     524 <printint+0xa4>
    buf[i++] = '-';
 4f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fa:	8d 50 01             	lea    0x1(%eax),%edx
 4fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 500:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 505:	eb 1d                	jmp    524 <printint+0xa4>
    putc(fd, buf[i]);
 507:	8d 55 dc             	lea    -0x24(%ebp),%edx
 50a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50d:	01 d0                	add    %edx,%eax
 50f:	0f b6 00             	movzbl (%eax),%eax
 512:	0f be c0             	movsbl %al,%eax
 515:	83 ec 08             	sub    $0x8,%esp
 518:	50                   	push   %eax
 519:	ff 75 08             	pushl  0x8(%ebp)
 51c:	e8 3c ff ff ff       	call   45d <putc>
 521:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 524:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 528:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52c:	79 d9                	jns    507 <printint+0x87>
    putc(fd, buf[i]);
}
 52e:	90                   	nop
 52f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 532:	c9                   	leave  
 533:	c3                   	ret    

00000534 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 53a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 541:	8d 45 0c             	lea    0xc(%ebp),%eax
 544:	83 c0 04             	add    $0x4,%eax
 547:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 54a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 551:	e9 59 01 00 00       	jmp    6af <printf+0x17b>
    c = fmt[i] & 0xff;
 556:	8b 55 0c             	mov    0xc(%ebp),%edx
 559:	8b 45 f0             	mov    -0x10(%ebp),%eax
 55c:	01 d0                	add    %edx,%eax
 55e:	0f b6 00             	movzbl (%eax),%eax
 561:	0f be c0             	movsbl %al,%eax
 564:	25 ff 00 00 00       	and    $0xff,%eax
 569:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 56c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 570:	75 2c                	jne    59e <printf+0x6a>
      if(c == '%'){
 572:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 576:	75 0c                	jne    584 <printf+0x50>
        state = '%';
 578:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 57f:	e9 27 01 00 00       	jmp    6ab <printf+0x177>
      } else {
        putc(fd, c);
 584:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 587:	0f be c0             	movsbl %al,%eax
 58a:	83 ec 08             	sub    $0x8,%esp
 58d:	50                   	push   %eax
 58e:	ff 75 08             	pushl  0x8(%ebp)
 591:	e8 c7 fe ff ff       	call   45d <putc>
 596:	83 c4 10             	add    $0x10,%esp
 599:	e9 0d 01 00 00       	jmp    6ab <printf+0x177>
      }
    } else if(state == '%'){
 59e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5a2:	0f 85 03 01 00 00    	jne    6ab <printf+0x177>
      if(c == 'd'){
 5a8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ac:	75 1e                	jne    5cc <printf+0x98>
        printint(fd, *ap, 10, 1);
 5ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b1:	8b 00                	mov    (%eax),%eax
 5b3:	6a 01                	push   $0x1
 5b5:	6a 0a                	push   $0xa
 5b7:	50                   	push   %eax
 5b8:	ff 75 08             	pushl  0x8(%ebp)
 5bb:	e8 c0 fe ff ff       	call   480 <printint>
 5c0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5c7:	e9 d8 00 00 00       	jmp    6a4 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5cc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5d0:	74 06                	je     5d8 <printf+0xa4>
 5d2:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5d6:	75 1e                	jne    5f6 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5db:	8b 00                	mov    (%eax),%eax
 5dd:	6a 00                	push   $0x0
 5df:	6a 10                	push   $0x10
 5e1:	50                   	push   %eax
 5e2:	ff 75 08             	pushl  0x8(%ebp)
 5e5:	e8 96 fe ff ff       	call   480 <printint>
 5ea:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f1:	e9 ae 00 00 00       	jmp    6a4 <printf+0x170>
      } else if(c == 's'){
 5f6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5fa:	75 43                	jne    63f <printf+0x10b>
        s = (char*)*ap;
 5fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ff:	8b 00                	mov    (%eax),%eax
 601:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 604:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60c:	75 25                	jne    633 <printf+0xff>
          s = "(null)";
 60e:	c7 45 f4 06 09 00 00 	movl   $0x906,-0xc(%ebp)
        while(*s != 0){
 615:	eb 1c                	jmp    633 <printf+0xff>
          putc(fd, *s);
 617:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61a:	0f b6 00             	movzbl (%eax),%eax
 61d:	0f be c0             	movsbl %al,%eax
 620:	83 ec 08             	sub    $0x8,%esp
 623:	50                   	push   %eax
 624:	ff 75 08             	pushl  0x8(%ebp)
 627:	e8 31 fe ff ff       	call   45d <putc>
 62c:	83 c4 10             	add    $0x10,%esp
          s++;
 62f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 633:	8b 45 f4             	mov    -0xc(%ebp),%eax
 636:	0f b6 00             	movzbl (%eax),%eax
 639:	84 c0                	test   %al,%al
 63b:	75 da                	jne    617 <printf+0xe3>
 63d:	eb 65                	jmp    6a4 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 643:	75 1d                	jne    662 <printf+0x12e>
        putc(fd, *ap);
 645:	8b 45 e8             	mov    -0x18(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	0f be c0             	movsbl %al,%eax
 64d:	83 ec 08             	sub    $0x8,%esp
 650:	50                   	push   %eax
 651:	ff 75 08             	pushl  0x8(%ebp)
 654:	e8 04 fe ff ff       	call   45d <putc>
 659:	83 c4 10             	add    $0x10,%esp
        ap++;
 65c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 660:	eb 42                	jmp    6a4 <printf+0x170>
      } else if(c == '%'){
 662:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 666:	75 17                	jne    67f <printf+0x14b>
        putc(fd, c);
 668:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 66b:	0f be c0             	movsbl %al,%eax
 66e:	83 ec 08             	sub    $0x8,%esp
 671:	50                   	push   %eax
 672:	ff 75 08             	pushl  0x8(%ebp)
 675:	e8 e3 fd ff ff       	call   45d <putc>
 67a:	83 c4 10             	add    $0x10,%esp
 67d:	eb 25                	jmp    6a4 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 67f:	83 ec 08             	sub    $0x8,%esp
 682:	6a 25                	push   $0x25
 684:	ff 75 08             	pushl  0x8(%ebp)
 687:	e8 d1 fd ff ff       	call   45d <putc>
 68c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 68f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 692:	0f be c0             	movsbl %al,%eax
 695:	83 ec 08             	sub    $0x8,%esp
 698:	50                   	push   %eax
 699:	ff 75 08             	pushl  0x8(%ebp)
 69c:	e8 bc fd ff ff       	call   45d <putc>
 6a1:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ab:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6af:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b5:	01 d0                	add    %edx,%eax
 6b7:	0f b6 00             	movzbl (%eax),%eax
 6ba:	84 c0                	test   %al,%al
 6bc:	0f 85 94 fe ff ff    	jne    556 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c2:	90                   	nop
 6c3:	c9                   	leave  
 6c4:	c3                   	ret    

000006c5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c5:	55                   	push   %ebp
 6c6:	89 e5                	mov    %esp,%ebp
 6c8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6cb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ce:	83 e8 08             	sub    $0x8,%eax
 6d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d4:	a1 98 0b 00 00       	mov    0xb98,%eax
 6d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6dc:	eb 24                	jmp    702 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e1:	8b 00                	mov    (%eax),%eax
 6e3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6e6:	77 12                	ja     6fa <free+0x35>
 6e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6ee:	77 24                	ja     714 <free+0x4f>
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 00                	mov    (%eax),%eax
 6f5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6f8:	77 1a                	ja     714 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fd:	8b 00                	mov    (%eax),%eax
 6ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
 702:	8b 45 f8             	mov    -0x8(%ebp),%eax
 705:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 708:	76 d4                	jbe    6de <free+0x19>
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	8b 00                	mov    (%eax),%eax
 70f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 712:	76 ca                	jbe    6de <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 714:	8b 45 f8             	mov    -0x8(%ebp),%eax
 717:	8b 40 04             	mov    0x4(%eax),%eax
 71a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 721:	8b 45 f8             	mov    -0x8(%ebp),%eax
 724:	01 c2                	add    %eax,%edx
 726:	8b 45 fc             	mov    -0x4(%ebp),%eax
 729:	8b 00                	mov    (%eax),%eax
 72b:	39 c2                	cmp    %eax,%edx
 72d:	75 24                	jne    753 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	8b 50 04             	mov    0x4(%eax),%edx
 735:	8b 45 fc             	mov    -0x4(%ebp),%eax
 738:	8b 00                	mov    (%eax),%eax
 73a:	8b 40 04             	mov    0x4(%eax),%eax
 73d:	01 c2                	add    %eax,%edx
 73f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 742:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 00                	mov    (%eax),%eax
 74a:	8b 10                	mov    (%eax),%edx
 74c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74f:	89 10                	mov    %edx,(%eax)
 751:	eb 0a                	jmp    75d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 753:	8b 45 fc             	mov    -0x4(%ebp),%eax
 756:	8b 10                	mov    (%eax),%edx
 758:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 40 04             	mov    0x4(%eax),%eax
 763:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	01 d0                	add    %edx,%eax
 76f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 772:	75 20                	jne    794 <free+0xcf>
    p->s.size += bp->s.size;
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 50 04             	mov    0x4(%eax),%edx
 77a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77d:	8b 40 04             	mov    0x4(%eax),%eax
 780:	01 c2                	add    %eax,%edx
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 788:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78b:	8b 10                	mov    (%eax),%edx
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	89 10                	mov    %edx,(%eax)
 792:	eb 08                	jmp    79c <free+0xd7>
  } else
    p->s.ptr = bp;
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	8b 55 f8             	mov    -0x8(%ebp),%edx
 79a:	89 10                	mov    %edx,(%eax)
  freep = p;
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	a3 98 0b 00 00       	mov    %eax,0xb98
}
 7a4:	90                   	nop
 7a5:	c9                   	leave  
 7a6:	c3                   	ret    

000007a7 <morecore>:

static Header*
morecore(uint nu)
{
 7a7:	55                   	push   %ebp
 7a8:	89 e5                	mov    %esp,%ebp
 7aa:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ad:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7b4:	77 07                	ja     7bd <morecore+0x16>
    nu = 4096;
 7b6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7bd:	8b 45 08             	mov    0x8(%ebp),%eax
 7c0:	c1 e0 03             	shl    $0x3,%eax
 7c3:	83 ec 0c             	sub    $0xc,%esp
 7c6:	50                   	push   %eax
 7c7:	e8 19 fc ff ff       	call   3e5 <sbrk>
 7cc:	83 c4 10             	add    $0x10,%esp
 7cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7d6:	75 07                	jne    7df <morecore+0x38>
    return 0;
 7d8:	b8 00 00 00 00       	mov    $0x0,%eax
 7dd:	eb 26                	jmp    805 <morecore+0x5e>
  hp = (Header*)p;
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e8:	8b 55 08             	mov    0x8(%ebp),%edx
 7eb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f1:	83 c0 08             	add    $0x8,%eax
 7f4:	83 ec 0c             	sub    $0xc,%esp
 7f7:	50                   	push   %eax
 7f8:	e8 c8 fe ff ff       	call   6c5 <free>
 7fd:	83 c4 10             	add    $0x10,%esp
  return freep;
 800:	a1 98 0b 00 00       	mov    0xb98,%eax
}
 805:	c9                   	leave  
 806:	c3                   	ret    

00000807 <malloc>:

void*
malloc(uint nbytes)
{
 807:	55                   	push   %ebp
 808:	89 e5                	mov    %esp,%ebp
 80a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 80d:	8b 45 08             	mov    0x8(%ebp),%eax
 810:	83 c0 07             	add    $0x7,%eax
 813:	c1 e8 03             	shr    $0x3,%eax
 816:	83 c0 01             	add    $0x1,%eax
 819:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 81c:	a1 98 0b 00 00       	mov    0xb98,%eax
 821:	89 45 f0             	mov    %eax,-0x10(%ebp)
 824:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 828:	75 23                	jne    84d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 82a:	c7 45 f0 90 0b 00 00 	movl   $0xb90,-0x10(%ebp)
 831:	8b 45 f0             	mov    -0x10(%ebp),%eax
 834:	a3 98 0b 00 00       	mov    %eax,0xb98
 839:	a1 98 0b 00 00       	mov    0xb98,%eax
 83e:	a3 90 0b 00 00       	mov    %eax,0xb90
    base.s.size = 0;
 843:	c7 05 94 0b 00 00 00 	movl   $0x0,0xb94
 84a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 84d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 850:	8b 00                	mov    (%eax),%eax
 852:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 855:	8b 45 f4             	mov    -0xc(%ebp),%eax
 858:	8b 40 04             	mov    0x4(%eax),%eax
 85b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 85e:	72 4d                	jb     8ad <malloc+0xa6>
      if(p->s.size == nunits)
 860:	8b 45 f4             	mov    -0xc(%ebp),%eax
 863:	8b 40 04             	mov    0x4(%eax),%eax
 866:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 869:	75 0c                	jne    877 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	8b 10                	mov    (%eax),%edx
 870:	8b 45 f0             	mov    -0x10(%ebp),%eax
 873:	89 10                	mov    %edx,(%eax)
 875:	eb 26                	jmp    89d <malloc+0x96>
      else {
        p->s.size -= nunits;
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	8b 40 04             	mov    0x4(%eax),%eax
 87d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 880:	89 c2                	mov    %eax,%edx
 882:	8b 45 f4             	mov    -0xc(%ebp),%eax
 885:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	8b 40 04             	mov    0x4(%eax),%eax
 88e:	c1 e0 03             	shl    $0x3,%eax
 891:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	8b 55 ec             	mov    -0x14(%ebp),%edx
 89a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 89d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a0:	a3 98 0b 00 00       	mov    %eax,0xb98
      return (void*)(p + 1);
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	83 c0 08             	add    $0x8,%eax
 8ab:	eb 3b                	jmp    8e8 <malloc+0xe1>
    }
    if(p == freep)
 8ad:	a1 98 0b 00 00       	mov    0xb98,%eax
 8b2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8b5:	75 1e                	jne    8d5 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8b7:	83 ec 0c             	sub    $0xc,%esp
 8ba:	ff 75 ec             	pushl  -0x14(%ebp)
 8bd:	e8 e5 fe ff ff       	call   7a7 <morecore>
 8c2:	83 c4 10             	add    $0x10,%esp
 8c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8cc:	75 07                	jne    8d5 <malloc+0xce>
        return 0;
 8ce:	b8 00 00 00 00       	mov    $0x0,%eax
 8d3:	eb 13                	jmp    8e8 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8de:	8b 00                	mov    (%eax),%eax
 8e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e3:	e9 6d ff ff ff       	jmp    855 <malloc+0x4e>
}
 8e8:	c9                   	leave  
 8e9:	c3                   	ret    
