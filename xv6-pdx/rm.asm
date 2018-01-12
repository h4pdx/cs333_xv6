
_rm:     file format elf32-i386


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
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
    printf(2, "Usage: rm files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 ef 08 00 00       	push   $0x8ef
  21:	6a 02                	push   $0x2
  23:	e8 11 05 00 00       	call   539 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 8a 03 00 00       	call   3ba <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 4b                	jmp    84 <main+0x84>
    if(unlink(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 b7 03 00 00       	call   40a <unlink>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 26                	jns    80 <main+0x80>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 43 04             	mov    0x4(%ebx),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	50                   	push   %eax
  6f:	68 03 09 00 00       	push   $0x903
  74:	6a 02                	push   $0x2
  76:	e8 be 04 00 00       	call   539 <printf>
  7b:	83 c4 10             	add    $0x10,%esp
      break;
  7e:	eb 0b                	jmp    8b <main+0x8b>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  87:	3b 03                	cmp    (%ebx),%eax
  89:	7c ae                	jl     39 <main+0x39>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  8b:	e8 2a 03 00 00       	call   3ba <exit>

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	90                   	nop
  b2:	5b                   	pop    %ebx
  b3:	5f                   	pop    %edi
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret    

000000b6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c2:	90                   	nop
  c3:	8b 45 08             	mov    0x8(%ebp),%eax
  c6:	8d 50 01             	lea    0x1(%eax),%edx
  c9:	89 55 08             	mov    %edx,0x8(%ebp)
  cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  d2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d5:	0f b6 12             	movzbl (%edx),%edx
  d8:	88 10                	mov    %dl,(%eax)
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	75 e2                	jne    c3 <strcpy+0xd>
    ;
  return os;
  e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e4:	c9                   	leave  
  e5:	c3                   	ret    

000000e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e9:	eb 08                	jmp    f3 <strcmp+0xd>
    p++, q++;
  eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ef:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	0f b6 00             	movzbl (%eax),%eax
  f9:	84 c0                	test   %al,%al
  fb:	74 10                	je     10d <strcmp+0x27>
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	0f b6 10             	movzbl (%eax),%edx
 103:	8b 45 0c             	mov    0xc(%ebp),%eax
 106:	0f b6 00             	movzbl (%eax),%eax
 109:	38 c2                	cmp    %al,%dl
 10b:	74 de                	je     eb <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 10d:	8b 45 08             	mov    0x8(%ebp),%eax
 110:	0f b6 00             	movzbl (%eax),%eax
 113:	0f b6 d0             	movzbl %al,%edx
 116:	8b 45 0c             	mov    0xc(%ebp),%eax
 119:	0f b6 00             	movzbl (%eax),%eax
 11c:	0f b6 c0             	movzbl %al,%eax
 11f:	29 c2                	sub    %eax,%edx
 121:	89 d0                	mov    %edx,%eax
}
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    

00000125 <strlen>:

uint
strlen(char *s)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 132:	eb 04                	jmp    138 <strlen+0x13>
 134:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 138:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	01 d0                	add    %edx,%eax
 140:	0f b6 00             	movzbl (%eax),%eax
 143:	84 c0                	test   %al,%al
 145:	75 ed                	jne    134 <strlen+0xf>
    ;
  return n;
 147:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14a:	c9                   	leave  
 14b:	c3                   	ret    

0000014c <memset>:

void*
memset(void *dst, int c, uint n)
{
 14c:	55                   	push   %ebp
 14d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 14f:	8b 45 10             	mov    0x10(%ebp),%eax
 152:	50                   	push   %eax
 153:	ff 75 0c             	pushl  0xc(%ebp)
 156:	ff 75 08             	pushl  0x8(%ebp)
 159:	e8 32 ff ff ff       	call   90 <stosb>
 15e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 04             	sub    $0x4,%esp
 16c:	8b 45 0c             	mov    0xc(%ebp),%eax
 16f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 172:	eb 14                	jmp    188 <strchr+0x22>
    if(*s == c)
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17d:	75 05                	jne    184 <strchr+0x1e>
      return (char*)s;
 17f:	8b 45 08             	mov    0x8(%ebp),%eax
 182:	eb 13                	jmp    197 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 00             	movzbl (%eax),%eax
 18e:	84 c0                	test   %al,%al
 190:	75 e2                	jne    174 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 192:	b8 00 00 00 00       	mov    $0x0,%eax
}
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <gets>:

char*
gets(char *buf, int max)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a6:	eb 42                	jmp    1ea <gets+0x51>
    cc = read(0, &c, 1);
 1a8:	83 ec 04             	sub    $0x4,%esp
 1ab:	6a 01                	push   $0x1
 1ad:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1b0:	50                   	push   %eax
 1b1:	6a 00                	push   $0x0
 1b3:	e8 1a 02 00 00       	call   3d2 <read>
 1b8:	83 c4 10             	add    $0x10,%esp
 1bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c2:	7e 33                	jle    1f7 <gets+0x5e>
      break;
    buf[i++] = c;
 1c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c7:	8d 50 01             	lea    0x1(%eax),%edx
 1ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cd:	89 c2                	mov    %eax,%edx
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	01 c2                	add    %eax,%edx
 1d4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1da:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1de:	3c 0a                	cmp    $0xa,%al
 1e0:	74 16                	je     1f8 <gets+0x5f>
 1e2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e6:	3c 0d                	cmp    $0xd,%al
 1e8:	74 0e                	je     1f8 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f3:	7c b3                	jl     1a8 <gets+0xf>
 1f5:	eb 01                	jmp    1f8 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f7:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	01 d0                	add    %edx,%eax
 200:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 203:	8b 45 08             	mov    0x8(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <stat>:

int
stat(char *n, struct stat *st)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20e:	83 ec 08             	sub    $0x8,%esp
 211:	6a 00                	push   $0x0
 213:	ff 75 08             	pushl  0x8(%ebp)
 216:	e8 df 01 00 00       	call   3fa <open>
 21b:	83 c4 10             	add    $0x10,%esp
 21e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 221:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 225:	79 07                	jns    22e <stat+0x26>
    return -1;
 227:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22c:	eb 25                	jmp    253 <stat+0x4b>
  r = fstat(fd, st);
 22e:	83 ec 08             	sub    $0x8,%esp
 231:	ff 75 0c             	pushl  0xc(%ebp)
 234:	ff 75 f4             	pushl  -0xc(%ebp)
 237:	e8 d6 01 00 00       	call   412 <fstat>
 23c:	83 c4 10             	add    $0x10,%esp
 23f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 242:	83 ec 0c             	sub    $0xc,%esp
 245:	ff 75 f4             	pushl  -0xc(%ebp)
 248:	e8 95 01 00 00       	call   3e2 <close>
 24d:	83 c4 10             	add    $0x10,%esp
  return r;
 250:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 253:	c9                   	leave  
 254:	c3                   	ret    

00000255 <atoi>:

int
atoi(const char *s)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 25b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 262:	eb 04                	jmp    268 <atoi+0x13>
 264:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	0f b6 00             	movzbl (%eax),%eax
 26e:	3c 20                	cmp    $0x20,%al
 270:	74 f2                	je     264 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	0f b6 00             	movzbl (%eax),%eax
 278:	3c 2d                	cmp    $0x2d,%al
 27a:	75 07                	jne    283 <atoi+0x2e>
 27c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 281:	eb 05                	jmp    288 <atoi+0x33>
 283:	b8 01 00 00 00       	mov    $0x1,%eax
 288:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	0f b6 00             	movzbl (%eax),%eax
 291:	3c 2b                	cmp    $0x2b,%al
 293:	74 0a                	je     29f <atoi+0x4a>
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	0f b6 00             	movzbl (%eax),%eax
 29b:	3c 2d                	cmp    $0x2d,%al
 29d:	75 2b                	jne    2ca <atoi+0x75>
    s++;
 29f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2a3:	eb 25                	jmp    2ca <atoi+0x75>
    n = n*10 + *s++ - '0';
 2a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a8:	89 d0                	mov    %edx,%eax
 2aa:	c1 e0 02             	shl    $0x2,%eax
 2ad:	01 d0                	add    %edx,%eax
 2af:	01 c0                	add    %eax,%eax
 2b1:	89 c1                	mov    %eax,%ecx
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	8d 50 01             	lea    0x1(%eax),%edx
 2b9:	89 55 08             	mov    %edx,0x8(%ebp)
 2bc:	0f b6 00             	movzbl (%eax),%eax
 2bf:	0f be c0             	movsbl %al,%eax
 2c2:	01 c8                	add    %ecx,%eax
 2c4:	83 e8 30             	sub    $0x30,%eax
 2c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
 2cd:	0f b6 00             	movzbl (%eax),%eax
 2d0:	3c 2f                	cmp    $0x2f,%al
 2d2:	7e 0a                	jle    2de <atoi+0x89>
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	0f b6 00             	movzbl (%eax),%eax
 2da:	3c 39                	cmp    $0x39,%al
 2dc:	7e c7                	jle    2a5 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2e1:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2e5:	c9                   	leave  
 2e6:	c3                   	ret    

000002e7 <atoo>:

int
atoo(const char *s)
{
 2e7:	55                   	push   %ebp
 2e8:	89 e5                	mov    %esp,%ebp
 2ea:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2f4:	eb 04                	jmp    2fa <atoo+0x13>
 2f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	3c 20                	cmp    $0x20,%al
 302:	74 f2                	je     2f6 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	3c 2d                	cmp    $0x2d,%al
 30c:	75 07                	jne    315 <atoo+0x2e>
 30e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 313:	eb 05                	jmp    31a <atoo+0x33>
 315:	b8 01 00 00 00       	mov    $0x1,%eax
 31a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	0f b6 00             	movzbl (%eax),%eax
 323:	3c 2b                	cmp    $0x2b,%al
 325:	74 0a                	je     331 <atoo+0x4a>
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	3c 2d                	cmp    $0x2d,%al
 32f:	75 27                	jne    358 <atoo+0x71>
    s++;
 331:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 335:	eb 21                	jmp    358 <atoo+0x71>
    n = n*8 + *s++ - '0';
 337:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	8d 50 01             	lea    0x1(%eax),%edx
 347:	89 55 08             	mov    %edx,0x8(%ebp)
 34a:	0f b6 00             	movzbl (%eax),%eax
 34d:	0f be c0             	movsbl %al,%eax
 350:	01 c8                	add    %ecx,%eax
 352:	83 e8 30             	sub    $0x30,%eax
 355:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	0f b6 00             	movzbl (%eax),%eax
 35e:	3c 2f                	cmp    $0x2f,%al
 360:	7e 0a                	jle    36c <atoo+0x85>
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	0f b6 00             	movzbl (%eax),%eax
 368:	3c 37                	cmp    $0x37,%al
 36a:	7e cb                	jle    337 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 36c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 36f:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 373:	c9                   	leave  
 374:	c3                   	ret    

00000375 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 375:	55                   	push   %ebp
 376:	89 e5                	mov    %esp,%ebp
 378:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 387:	eb 17                	jmp    3a0 <memmove+0x2b>
    *dst++ = *src++;
 389:	8b 45 fc             	mov    -0x4(%ebp),%eax
 38c:	8d 50 01             	lea    0x1(%eax),%edx
 38f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 392:	8b 55 f8             	mov    -0x8(%ebp),%edx
 395:	8d 4a 01             	lea    0x1(%edx),%ecx
 398:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 39b:	0f b6 12             	movzbl (%edx),%edx
 39e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3a0:	8b 45 10             	mov    0x10(%ebp),%eax
 3a3:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a6:	89 55 10             	mov    %edx,0x10(%ebp)
 3a9:	85 c0                	test   %eax,%eax
 3ab:	7f dc                	jg     389 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3b0:	c9                   	leave  
 3b1:	c3                   	ret    

000003b2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3b2:	b8 01 00 00 00       	mov    $0x1,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <exit>:
SYSCALL(exit)
 3ba:	b8 02 00 00 00       	mov    $0x2,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <wait>:
SYSCALL(wait)
 3c2:	b8 03 00 00 00       	mov    $0x3,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <pipe>:
SYSCALL(pipe)
 3ca:	b8 04 00 00 00       	mov    $0x4,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <read>:
SYSCALL(read)
 3d2:	b8 05 00 00 00       	mov    $0x5,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <write>:
SYSCALL(write)
 3da:	b8 10 00 00 00       	mov    $0x10,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <close>:
SYSCALL(close)
 3e2:	b8 15 00 00 00       	mov    $0x15,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <kill>:
SYSCALL(kill)
 3ea:	b8 06 00 00 00       	mov    $0x6,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <exec>:
SYSCALL(exec)
 3f2:	b8 07 00 00 00       	mov    $0x7,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <open>:
SYSCALL(open)
 3fa:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <mknod>:
SYSCALL(mknod)
 402:	b8 11 00 00 00       	mov    $0x11,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <unlink>:
SYSCALL(unlink)
 40a:	b8 12 00 00 00       	mov    $0x12,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <fstat>:
SYSCALL(fstat)
 412:	b8 08 00 00 00       	mov    $0x8,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <link>:
SYSCALL(link)
 41a:	b8 13 00 00 00       	mov    $0x13,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <mkdir>:
SYSCALL(mkdir)
 422:	b8 14 00 00 00       	mov    $0x14,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <chdir>:
SYSCALL(chdir)
 42a:	b8 09 00 00 00       	mov    $0x9,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <dup>:
SYSCALL(dup)
 432:	b8 0a 00 00 00       	mov    $0xa,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <getpid>:
SYSCALL(getpid)
 43a:	b8 0b 00 00 00       	mov    $0xb,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <sbrk>:
SYSCALL(sbrk)
 442:	b8 0c 00 00 00       	mov    $0xc,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <sleep>:
SYSCALL(sleep)
 44a:	b8 0d 00 00 00       	mov    $0xd,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <uptime>:
SYSCALL(uptime)
 452:	b8 0e 00 00 00       	mov    $0xe,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <halt>:
SYSCALL(halt)
 45a:	b8 16 00 00 00       	mov    $0x16,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 462:	55                   	push   %ebp
 463:	89 e5                	mov    %esp,%ebp
 465:	83 ec 18             	sub    $0x18,%esp
 468:	8b 45 0c             	mov    0xc(%ebp),%eax
 46b:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 46e:	83 ec 04             	sub    $0x4,%esp
 471:	6a 01                	push   $0x1
 473:	8d 45 f4             	lea    -0xc(%ebp),%eax
 476:	50                   	push   %eax
 477:	ff 75 08             	pushl  0x8(%ebp)
 47a:	e8 5b ff ff ff       	call   3da <write>
 47f:	83 c4 10             	add    $0x10,%esp
}
 482:	90                   	nop
 483:	c9                   	leave  
 484:	c3                   	ret    

00000485 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 485:	55                   	push   %ebp
 486:	89 e5                	mov    %esp,%ebp
 488:	53                   	push   %ebx
 489:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 48c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 493:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 497:	74 17                	je     4b0 <printint+0x2b>
 499:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 49d:	79 11                	jns    4b0 <printint+0x2b>
    neg = 1;
 49f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a9:	f7 d8                	neg    %eax
 4ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ae:	eb 06                	jmp    4b6 <printint+0x31>
  } else {
    x = xx;
 4b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4bd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4c0:	8d 41 01             	lea    0x1(%ecx),%eax
 4c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4cc:	ba 00 00 00 00       	mov    $0x0,%edx
 4d1:	f7 f3                	div    %ebx
 4d3:	89 d0                	mov    %edx,%eax
 4d5:	0f b6 80 90 0b 00 00 	movzbl 0xb90(%eax),%eax
 4dc:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e6:	ba 00 00 00 00       	mov    $0x0,%edx
 4eb:	f7 f3                	div    %ebx
 4ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f4:	75 c7                	jne    4bd <printint+0x38>
  if(neg)
 4f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fa:	74 2d                	je     529 <printint+0xa4>
    buf[i++] = '-';
 4fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4ff:	8d 50 01             	lea    0x1(%eax),%edx
 502:	89 55 f4             	mov    %edx,-0xc(%ebp)
 505:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 50a:	eb 1d                	jmp    529 <printint+0xa4>
    putc(fd, buf[i]);
 50c:	8d 55 dc             	lea    -0x24(%ebp),%edx
 50f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 512:	01 d0                	add    %edx,%eax
 514:	0f b6 00             	movzbl (%eax),%eax
 517:	0f be c0             	movsbl %al,%eax
 51a:	83 ec 08             	sub    $0x8,%esp
 51d:	50                   	push   %eax
 51e:	ff 75 08             	pushl  0x8(%ebp)
 521:	e8 3c ff ff ff       	call   462 <putc>
 526:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 529:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 52d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 531:	79 d9                	jns    50c <printint+0x87>
    putc(fd, buf[i]);
}
 533:	90                   	nop
 534:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 537:	c9                   	leave  
 538:	c3                   	ret    

00000539 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 539:	55                   	push   %ebp
 53a:	89 e5                	mov    %esp,%ebp
 53c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 53f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 546:	8d 45 0c             	lea    0xc(%ebp),%eax
 549:	83 c0 04             	add    $0x4,%eax
 54c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 54f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 556:	e9 59 01 00 00       	jmp    6b4 <printf+0x17b>
    c = fmt[i] & 0xff;
 55b:	8b 55 0c             	mov    0xc(%ebp),%edx
 55e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 561:	01 d0                	add    %edx,%eax
 563:	0f b6 00             	movzbl (%eax),%eax
 566:	0f be c0             	movsbl %al,%eax
 569:	25 ff 00 00 00       	and    $0xff,%eax
 56e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 571:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 575:	75 2c                	jne    5a3 <printf+0x6a>
      if(c == '%'){
 577:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57b:	75 0c                	jne    589 <printf+0x50>
        state = '%';
 57d:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 584:	e9 27 01 00 00       	jmp    6b0 <printf+0x177>
      } else {
        putc(fd, c);
 589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58c:	0f be c0             	movsbl %al,%eax
 58f:	83 ec 08             	sub    $0x8,%esp
 592:	50                   	push   %eax
 593:	ff 75 08             	pushl  0x8(%ebp)
 596:	e8 c7 fe ff ff       	call   462 <putc>
 59b:	83 c4 10             	add    $0x10,%esp
 59e:	e9 0d 01 00 00       	jmp    6b0 <printf+0x177>
      }
    } else if(state == '%'){
 5a3:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5a7:	0f 85 03 01 00 00    	jne    6b0 <printf+0x177>
      if(c == 'd'){
 5ad:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b1:	75 1e                	jne    5d1 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b6:	8b 00                	mov    (%eax),%eax
 5b8:	6a 01                	push   $0x1
 5ba:	6a 0a                	push   $0xa
 5bc:	50                   	push   %eax
 5bd:	ff 75 08             	pushl  0x8(%ebp)
 5c0:	e8 c0 fe ff ff       	call   485 <printint>
 5c5:	83 c4 10             	add    $0x10,%esp
        ap++;
 5c8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5cc:	e9 d8 00 00 00       	jmp    6a9 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5d1:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5d5:	74 06                	je     5dd <printf+0xa4>
 5d7:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5db:	75 1e                	jne    5fb <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e0:	8b 00                	mov    (%eax),%eax
 5e2:	6a 00                	push   $0x0
 5e4:	6a 10                	push   $0x10
 5e6:	50                   	push   %eax
 5e7:	ff 75 08             	pushl  0x8(%ebp)
 5ea:	e8 96 fe ff ff       	call   485 <printint>
 5ef:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f6:	e9 ae 00 00 00       	jmp    6a9 <printf+0x170>
      } else if(c == 's'){
 5fb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5ff:	75 43                	jne    644 <printf+0x10b>
        s = (char*)*ap;
 601:	8b 45 e8             	mov    -0x18(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 609:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 60d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 611:	75 25                	jne    638 <printf+0xff>
          s = "(null)";
 613:	c7 45 f4 1c 09 00 00 	movl   $0x91c,-0xc(%ebp)
        while(*s != 0){
 61a:	eb 1c                	jmp    638 <printf+0xff>
          putc(fd, *s);
 61c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61f:	0f b6 00             	movzbl (%eax),%eax
 622:	0f be c0             	movsbl %al,%eax
 625:	83 ec 08             	sub    $0x8,%esp
 628:	50                   	push   %eax
 629:	ff 75 08             	pushl  0x8(%ebp)
 62c:	e8 31 fe ff ff       	call   462 <putc>
 631:	83 c4 10             	add    $0x10,%esp
          s++;
 634:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 638:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63b:	0f b6 00             	movzbl (%eax),%eax
 63e:	84 c0                	test   %al,%al
 640:	75 da                	jne    61c <printf+0xe3>
 642:	eb 65                	jmp    6a9 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 644:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 648:	75 1d                	jne    667 <printf+0x12e>
        putc(fd, *ap);
 64a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64d:	8b 00                	mov    (%eax),%eax
 64f:	0f be c0             	movsbl %al,%eax
 652:	83 ec 08             	sub    $0x8,%esp
 655:	50                   	push   %eax
 656:	ff 75 08             	pushl  0x8(%ebp)
 659:	e8 04 fe ff ff       	call   462 <putc>
 65e:	83 c4 10             	add    $0x10,%esp
        ap++;
 661:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 665:	eb 42                	jmp    6a9 <printf+0x170>
      } else if(c == '%'){
 667:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66b:	75 17                	jne    684 <printf+0x14b>
        putc(fd, c);
 66d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 670:	0f be c0             	movsbl %al,%eax
 673:	83 ec 08             	sub    $0x8,%esp
 676:	50                   	push   %eax
 677:	ff 75 08             	pushl  0x8(%ebp)
 67a:	e8 e3 fd ff ff       	call   462 <putc>
 67f:	83 c4 10             	add    $0x10,%esp
 682:	eb 25                	jmp    6a9 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 684:	83 ec 08             	sub    $0x8,%esp
 687:	6a 25                	push   $0x25
 689:	ff 75 08             	pushl  0x8(%ebp)
 68c:	e8 d1 fd ff ff       	call   462 <putc>
 691:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 694:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 697:	0f be c0             	movsbl %al,%eax
 69a:	83 ec 08             	sub    $0x8,%esp
 69d:	50                   	push   %eax
 69e:	ff 75 08             	pushl  0x8(%ebp)
 6a1:	e8 bc fd ff ff       	call   462 <putc>
 6a6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6b0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6b4:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6ba:	01 d0                	add    %edx,%eax
 6bc:	0f b6 00             	movzbl (%eax),%eax
 6bf:	84 c0                	test   %al,%al
 6c1:	0f 85 94 fe ff ff    	jne    55b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6c7:	90                   	nop
 6c8:	c9                   	leave  
 6c9:	c3                   	ret    

000006ca <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ca:	55                   	push   %ebp
 6cb:	89 e5                	mov    %esp,%ebp
 6cd:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d0:	8b 45 08             	mov    0x8(%ebp),%eax
 6d3:	83 e8 08             	sub    $0x8,%eax
 6d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d9:	a1 ac 0b 00 00       	mov    0xbac,%eax
 6de:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6e1:	eb 24                	jmp    707 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e6:	8b 00                	mov    (%eax),%eax
 6e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6eb:	77 12                	ja     6ff <free+0x35>
 6ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f3:	77 24                	ja     719 <free+0x4f>
 6f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f8:	8b 00                	mov    (%eax),%eax
 6fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6fd:	77 1a                	ja     719 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	8b 00                	mov    (%eax),%eax
 704:	89 45 fc             	mov    %eax,-0x4(%ebp)
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70d:	76 d4                	jbe    6e3 <free+0x19>
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 00                	mov    (%eax),%eax
 714:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 717:	76 ca                	jbe    6e3 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 719:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71c:	8b 40 04             	mov    0x4(%eax),%eax
 71f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	01 c2                	add    %eax,%edx
 72b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72e:	8b 00                	mov    (%eax),%eax
 730:	39 c2                	cmp    %eax,%edx
 732:	75 24                	jne    758 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 734:	8b 45 f8             	mov    -0x8(%ebp),%eax
 737:	8b 50 04             	mov    0x4(%eax),%edx
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 00                	mov    (%eax),%eax
 73f:	8b 40 04             	mov    0x4(%eax),%eax
 742:	01 c2                	add    %eax,%edx
 744:	8b 45 f8             	mov    -0x8(%ebp),%eax
 747:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	8b 10                	mov    (%eax),%edx
 751:	8b 45 f8             	mov    -0x8(%ebp),%eax
 754:	89 10                	mov    %edx,(%eax)
 756:	eb 0a                	jmp    762 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 758:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75b:	8b 10                	mov    (%eax),%edx
 75d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 760:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 762:	8b 45 fc             	mov    -0x4(%ebp),%eax
 765:	8b 40 04             	mov    0x4(%eax),%eax
 768:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	01 d0                	add    %edx,%eax
 774:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 777:	75 20                	jne    799 <free+0xcf>
    p->s.size += bp->s.size;
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 50 04             	mov    0x4(%eax),%edx
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 782:	8b 40 04             	mov    0x4(%eax),%eax
 785:	01 c2                	add    %eax,%edx
 787:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 78d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 790:	8b 10                	mov    (%eax),%edx
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	89 10                	mov    %edx,(%eax)
 797:	eb 08                	jmp    7a1 <free+0xd7>
  } else
    p->s.ptr = bp;
 799:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 79f:	89 10                	mov    %edx,(%eax)
  freep = p;
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	a3 ac 0b 00 00       	mov    %eax,0xbac
}
 7a9:	90                   	nop
 7aa:	c9                   	leave  
 7ab:	c3                   	ret    

000007ac <morecore>:

static Header*
morecore(uint nu)
{
 7ac:	55                   	push   %ebp
 7ad:	89 e5                	mov    %esp,%ebp
 7af:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7b2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7b9:	77 07                	ja     7c2 <morecore+0x16>
    nu = 4096;
 7bb:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7c2:	8b 45 08             	mov    0x8(%ebp),%eax
 7c5:	c1 e0 03             	shl    $0x3,%eax
 7c8:	83 ec 0c             	sub    $0xc,%esp
 7cb:	50                   	push   %eax
 7cc:	e8 71 fc ff ff       	call   442 <sbrk>
 7d1:	83 c4 10             	add    $0x10,%esp
 7d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7d7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7db:	75 07                	jne    7e4 <morecore+0x38>
    return 0;
 7dd:	b8 00 00 00 00       	mov    $0x0,%eax
 7e2:	eb 26                	jmp    80a <morecore+0x5e>
  hp = (Header*)p;
 7e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ed:	8b 55 08             	mov    0x8(%ebp),%edx
 7f0:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f6:	83 c0 08             	add    $0x8,%eax
 7f9:	83 ec 0c             	sub    $0xc,%esp
 7fc:	50                   	push   %eax
 7fd:	e8 c8 fe ff ff       	call   6ca <free>
 802:	83 c4 10             	add    $0x10,%esp
  return freep;
 805:	a1 ac 0b 00 00       	mov    0xbac,%eax
}
 80a:	c9                   	leave  
 80b:	c3                   	ret    

0000080c <malloc>:

void*
malloc(uint nbytes)
{
 80c:	55                   	push   %ebp
 80d:	89 e5                	mov    %esp,%ebp
 80f:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 812:	8b 45 08             	mov    0x8(%ebp),%eax
 815:	83 c0 07             	add    $0x7,%eax
 818:	c1 e8 03             	shr    $0x3,%eax
 81b:	83 c0 01             	add    $0x1,%eax
 81e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 821:	a1 ac 0b 00 00       	mov    0xbac,%eax
 826:	89 45 f0             	mov    %eax,-0x10(%ebp)
 829:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82d:	75 23                	jne    852 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 82f:	c7 45 f0 a4 0b 00 00 	movl   $0xba4,-0x10(%ebp)
 836:	8b 45 f0             	mov    -0x10(%ebp),%eax
 839:	a3 ac 0b 00 00       	mov    %eax,0xbac
 83e:	a1 ac 0b 00 00       	mov    0xbac,%eax
 843:	a3 a4 0b 00 00       	mov    %eax,0xba4
    base.s.size = 0;
 848:	c7 05 a8 0b 00 00 00 	movl   $0x0,0xba8
 84f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 852:	8b 45 f0             	mov    -0x10(%ebp),%eax
 855:	8b 00                	mov    (%eax),%eax
 857:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 85a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85d:	8b 40 04             	mov    0x4(%eax),%eax
 860:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 863:	72 4d                	jb     8b2 <malloc+0xa6>
      if(p->s.size == nunits)
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	8b 40 04             	mov    0x4(%eax),%eax
 86b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86e:	75 0c                	jne    87c <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	8b 10                	mov    (%eax),%edx
 875:	8b 45 f0             	mov    -0x10(%ebp),%eax
 878:	89 10                	mov    %edx,(%eax)
 87a:	eb 26                	jmp    8a2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	8b 40 04             	mov    0x4(%eax),%eax
 882:	2b 45 ec             	sub    -0x14(%ebp),%eax
 885:	89 c2                	mov    %eax,%edx
 887:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	8b 40 04             	mov    0x4(%eax),%eax
 893:	c1 e0 03             	shl    $0x3,%eax
 896:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	8b 55 ec             	mov    -0x14(%ebp),%edx
 89f:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a5:	a3 ac 0b 00 00       	mov    %eax,0xbac
      return (void*)(p + 1);
 8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ad:	83 c0 08             	add    $0x8,%eax
 8b0:	eb 3b                	jmp    8ed <malloc+0xe1>
    }
    if(p == freep)
 8b2:	a1 ac 0b 00 00       	mov    0xbac,%eax
 8b7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8ba:	75 1e                	jne    8da <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8bc:	83 ec 0c             	sub    $0xc,%esp
 8bf:	ff 75 ec             	pushl  -0x14(%ebp)
 8c2:	e8 e5 fe ff ff       	call   7ac <morecore>
 8c7:	83 c4 10             	add    $0x10,%esp
 8ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d1:	75 07                	jne    8da <malloc+0xce>
        return 0;
 8d3:	b8 00 00 00 00       	mov    $0x0,%eax
 8d8:	eb 13                	jmp    8ed <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e3:	8b 00                	mov    (%eax),%eax
 8e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8e8:	e9 6d ff ff ff       	jmp    85a <malloc+0x4e>
}
 8ed:	c9                   	leave  
 8ee:	c3                   	ret    
