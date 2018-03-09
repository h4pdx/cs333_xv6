
_mkdir:     file format elf32-i386


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
    printf(2, "Usage: mkdir files...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 47 09 00 00       	push   $0x947
  21:	6a 02                	push   $0x2
  23:	e8 69 05 00 00       	call   591 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 8a 03 00 00       	call   3ba <exit>
  }

  for(i = 1; i < argc; i++){
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 4b                	jmp    84 <main+0x84>
    if(mkdir(argv[i]) < 0){
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 cf 03 00 00       	call   422 <mkdir>
  53:	83 c4 10             	add    $0x10,%esp
  56:	85 c0                	test   %eax,%eax
  58:	79 26                	jns    80 <main+0x80>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  64:	8b 43 04             	mov    0x4(%ebx),%eax
  67:	01 d0                	add    %edx,%eax
  69:	8b 00                	mov    (%eax),%eax
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	50                   	push   %eax
  6f:	68 5e 09 00 00       	push   $0x95e
  74:	6a 02                	push   $0x2
  76:	e8 16 05 00 00       	call   591 <printf>
  7b:	83 c4 10             	add    $0x10,%esp
      break;
  7e:	eb 0b                	jmp    8b <main+0x8b>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  80:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  87:	3b 03                	cmp    (%ebx),%eax
  89:	7c ae                	jl     39 <main+0x39>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
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

00000462 <date>:
SYSCALL(date)
 462:	b8 17 00 00 00       	mov    $0x17,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <getuid>:
SYSCALL(getuid)
 46a:	b8 18 00 00 00       	mov    $0x18,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <getgid>:
SYSCALL(getgid)
 472:	b8 19 00 00 00       	mov    $0x19,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <getppid>:
SYSCALL(getppid)
 47a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <setuid>:
SYSCALL(setuid)
 482:	b8 1b 00 00 00       	mov    $0x1b,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <setgid>:
SYSCALL(setgid)
 48a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <getprocs>:
SYSCALL(getprocs)
 492:	b8 1d 00 00 00       	mov    $0x1d,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <setpriority>:
SYSCALL(setpriority)
 49a:	b8 1e 00 00 00       	mov    $0x1e,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <chmod>:
SYSCALL(chmod)
 4a2:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <chown>:
SYSCALL(chown)
 4aa:	b8 20 00 00 00       	mov    $0x20,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <chgrp>:
SYSCALL(chgrp)
 4b2:	b8 21 00 00 00       	mov    $0x21,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4ba:	55                   	push   %ebp
 4bb:	89 e5                	mov    %esp,%ebp
 4bd:	83 ec 18             	sub    $0x18,%esp
 4c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c3:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4c6:	83 ec 04             	sub    $0x4,%esp
 4c9:	6a 01                	push   $0x1
 4cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4ce:	50                   	push   %eax
 4cf:	ff 75 08             	pushl  0x8(%ebp)
 4d2:	e8 03 ff ff ff       	call   3da <write>
 4d7:	83 c4 10             	add    $0x10,%esp
}
 4da:	90                   	nop
 4db:	c9                   	leave  
 4dc:	c3                   	ret    

000004dd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4dd:	55                   	push   %ebp
 4de:	89 e5                	mov    %esp,%ebp
 4e0:	53                   	push   %ebx
 4e1:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4eb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4ef:	74 17                	je     508 <printint+0x2b>
 4f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4f5:	79 11                	jns    508 <printint+0x2b>
    neg = 1;
 4f7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 501:	f7 d8                	neg    %eax
 503:	89 45 ec             	mov    %eax,-0x14(%ebp)
 506:	eb 06                	jmp    50e <printint+0x31>
  } else {
    x = xx;
 508:	8b 45 0c             	mov    0xc(%ebp),%eax
 50b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 50e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 515:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 518:	8d 41 01             	lea    0x1(%ecx),%eax
 51b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 51e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 521:	8b 45 ec             	mov    -0x14(%ebp),%eax
 524:	ba 00 00 00 00       	mov    $0x0,%edx
 529:	f7 f3                	div    %ebx
 52b:	89 d0                	mov    %edx,%eax
 52d:	0f b6 80 f0 0b 00 00 	movzbl 0xbf0(%eax),%eax
 534:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 538:	8b 5d 10             	mov    0x10(%ebp),%ebx
 53b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 53e:	ba 00 00 00 00       	mov    $0x0,%edx
 543:	f7 f3                	div    %ebx
 545:	89 45 ec             	mov    %eax,-0x14(%ebp)
 548:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 54c:	75 c7                	jne    515 <printint+0x38>
  if(neg)
 54e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 552:	74 2d                	je     581 <printint+0xa4>
    buf[i++] = '-';
 554:	8b 45 f4             	mov    -0xc(%ebp),%eax
 557:	8d 50 01             	lea    0x1(%eax),%edx
 55a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 55d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 562:	eb 1d                	jmp    581 <printint+0xa4>
    putc(fd, buf[i]);
 564:	8d 55 dc             	lea    -0x24(%ebp),%edx
 567:	8b 45 f4             	mov    -0xc(%ebp),%eax
 56a:	01 d0                	add    %edx,%eax
 56c:	0f b6 00             	movzbl (%eax),%eax
 56f:	0f be c0             	movsbl %al,%eax
 572:	83 ec 08             	sub    $0x8,%esp
 575:	50                   	push   %eax
 576:	ff 75 08             	pushl  0x8(%ebp)
 579:	e8 3c ff ff ff       	call   4ba <putc>
 57e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 581:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 585:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 589:	79 d9                	jns    564 <printint+0x87>
    putc(fd, buf[i]);
}
 58b:	90                   	nop
 58c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 58f:	c9                   	leave  
 590:	c3                   	ret    

00000591 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 591:	55                   	push   %ebp
 592:	89 e5                	mov    %esp,%ebp
 594:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 597:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 59e:	8d 45 0c             	lea    0xc(%ebp),%eax
 5a1:	83 c0 04             	add    $0x4,%eax
 5a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5ae:	e9 59 01 00 00       	jmp    70c <printf+0x17b>
    c = fmt[i] & 0xff;
 5b3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b9:	01 d0                	add    %edx,%eax
 5bb:	0f b6 00             	movzbl (%eax),%eax
 5be:	0f be c0             	movsbl %al,%eax
 5c1:	25 ff 00 00 00       	and    $0xff,%eax
 5c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5cd:	75 2c                	jne    5fb <printf+0x6a>
      if(c == '%'){
 5cf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d3:	75 0c                	jne    5e1 <printf+0x50>
        state = '%';
 5d5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5dc:	e9 27 01 00 00       	jmp    708 <printf+0x177>
      } else {
        putc(fd, c);
 5e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e4:	0f be c0             	movsbl %al,%eax
 5e7:	83 ec 08             	sub    $0x8,%esp
 5ea:	50                   	push   %eax
 5eb:	ff 75 08             	pushl  0x8(%ebp)
 5ee:	e8 c7 fe ff ff       	call   4ba <putc>
 5f3:	83 c4 10             	add    $0x10,%esp
 5f6:	e9 0d 01 00 00       	jmp    708 <printf+0x177>
      }
    } else if(state == '%'){
 5fb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ff:	0f 85 03 01 00 00    	jne    708 <printf+0x177>
      if(c == 'd'){
 605:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 609:	75 1e                	jne    629 <printf+0x98>
        printint(fd, *ap, 10, 1);
 60b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	6a 01                	push   $0x1
 612:	6a 0a                	push   $0xa
 614:	50                   	push   %eax
 615:	ff 75 08             	pushl  0x8(%ebp)
 618:	e8 c0 fe ff ff       	call   4dd <printint>
 61d:	83 c4 10             	add    $0x10,%esp
        ap++;
 620:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 624:	e9 d8 00 00 00       	jmp    701 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 629:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 62d:	74 06                	je     635 <printf+0xa4>
 62f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 633:	75 1e                	jne    653 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 635:	8b 45 e8             	mov    -0x18(%ebp),%eax
 638:	8b 00                	mov    (%eax),%eax
 63a:	6a 00                	push   $0x0
 63c:	6a 10                	push   $0x10
 63e:	50                   	push   %eax
 63f:	ff 75 08             	pushl  0x8(%ebp)
 642:	e8 96 fe ff ff       	call   4dd <printint>
 647:	83 c4 10             	add    $0x10,%esp
        ap++;
 64a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 64e:	e9 ae 00 00 00       	jmp    701 <printf+0x170>
      } else if(c == 's'){
 653:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 657:	75 43                	jne    69c <printf+0x10b>
        s = (char*)*ap;
 659:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65c:	8b 00                	mov    (%eax),%eax
 65e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 661:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 665:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 669:	75 25                	jne    690 <printf+0xff>
          s = "(null)";
 66b:	c7 45 f4 7a 09 00 00 	movl   $0x97a,-0xc(%ebp)
        while(*s != 0){
 672:	eb 1c                	jmp    690 <printf+0xff>
          putc(fd, *s);
 674:	8b 45 f4             	mov    -0xc(%ebp),%eax
 677:	0f b6 00             	movzbl (%eax),%eax
 67a:	0f be c0             	movsbl %al,%eax
 67d:	83 ec 08             	sub    $0x8,%esp
 680:	50                   	push   %eax
 681:	ff 75 08             	pushl  0x8(%ebp)
 684:	e8 31 fe ff ff       	call   4ba <putc>
 689:	83 c4 10             	add    $0x10,%esp
          s++;
 68c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 690:	8b 45 f4             	mov    -0xc(%ebp),%eax
 693:	0f b6 00             	movzbl (%eax),%eax
 696:	84 c0                	test   %al,%al
 698:	75 da                	jne    674 <printf+0xe3>
 69a:	eb 65                	jmp    701 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 69c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6a0:	75 1d                	jne    6bf <printf+0x12e>
        putc(fd, *ap);
 6a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a5:	8b 00                	mov    (%eax),%eax
 6a7:	0f be c0             	movsbl %al,%eax
 6aa:	83 ec 08             	sub    $0x8,%esp
 6ad:	50                   	push   %eax
 6ae:	ff 75 08             	pushl  0x8(%ebp)
 6b1:	e8 04 fe ff ff       	call   4ba <putc>
 6b6:	83 c4 10             	add    $0x10,%esp
        ap++;
 6b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6bd:	eb 42                	jmp    701 <printf+0x170>
      } else if(c == '%'){
 6bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6c3:	75 17                	jne    6dc <printf+0x14b>
        putc(fd, c);
 6c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c8:	0f be c0             	movsbl %al,%eax
 6cb:	83 ec 08             	sub    $0x8,%esp
 6ce:	50                   	push   %eax
 6cf:	ff 75 08             	pushl  0x8(%ebp)
 6d2:	e8 e3 fd ff ff       	call   4ba <putc>
 6d7:	83 c4 10             	add    $0x10,%esp
 6da:	eb 25                	jmp    701 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6dc:	83 ec 08             	sub    $0x8,%esp
 6df:	6a 25                	push   $0x25
 6e1:	ff 75 08             	pushl  0x8(%ebp)
 6e4:	e8 d1 fd ff ff       	call   4ba <putc>
 6e9:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6ef:	0f be c0             	movsbl %al,%eax
 6f2:	83 ec 08             	sub    $0x8,%esp
 6f5:	50                   	push   %eax
 6f6:	ff 75 08             	pushl  0x8(%ebp)
 6f9:	e8 bc fd ff ff       	call   4ba <putc>
 6fe:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 701:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 708:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 70c:	8b 55 0c             	mov    0xc(%ebp),%edx
 70f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 712:	01 d0                	add    %edx,%eax
 714:	0f b6 00             	movzbl (%eax),%eax
 717:	84 c0                	test   %al,%al
 719:	0f 85 94 fe ff ff    	jne    5b3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 71f:	90                   	nop
 720:	c9                   	leave  
 721:	c3                   	ret    

00000722 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 722:	55                   	push   %ebp
 723:	89 e5                	mov    %esp,%ebp
 725:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 728:	8b 45 08             	mov    0x8(%ebp),%eax
 72b:	83 e8 08             	sub    $0x8,%eax
 72e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 731:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 736:	89 45 fc             	mov    %eax,-0x4(%ebp)
 739:	eb 24                	jmp    75f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 00                	mov    (%eax),%eax
 740:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 743:	77 12                	ja     757 <free+0x35>
 745:	8b 45 f8             	mov    -0x8(%ebp),%eax
 748:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74b:	77 24                	ja     771 <free+0x4f>
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 00                	mov    (%eax),%eax
 752:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 755:	77 1a                	ja     771 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	8b 00                	mov    (%eax),%eax
 75c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 765:	76 d4                	jbe    73b <free+0x19>
 767:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 76f:	76 ca                	jbe    73b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	8b 40 04             	mov    0x4(%eax),%eax
 777:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 781:	01 c2                	add    %eax,%edx
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	39 c2                	cmp    %eax,%edx
 78a:	75 24                	jne    7b0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 78c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78f:	8b 50 04             	mov    0x4(%eax),%edx
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	8b 40 04             	mov    0x4(%eax),%eax
 79a:	01 c2                	add    %eax,%edx
 79c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	8b 00                	mov    (%eax),%eax
 7a7:	8b 10                	mov    (%eax),%edx
 7a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ac:	89 10                	mov    %edx,(%eax)
 7ae:	eb 0a                	jmp    7ba <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b3:	8b 10                	mov    (%eax),%edx
 7b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	8b 40 04             	mov    0x4(%eax),%eax
 7c0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ca:	01 d0                	add    %edx,%eax
 7cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7cf:	75 20                	jne    7f1 <free+0xcf>
    p->s.size += bp->s.size;
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 50 04             	mov    0x4(%eax),%edx
 7d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7da:	8b 40 04             	mov    0x4(%eax),%eax
 7dd:	01 c2                	add    %eax,%edx
 7df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e8:	8b 10                	mov    (%eax),%edx
 7ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ed:	89 10                	mov    %edx,(%eax)
 7ef:	eb 08                	jmp    7f9 <free+0xd7>
  } else
    p->s.ptr = bp;
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7f7:	89 10                	mov    %edx,(%eax)
  freep = p;
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	a3 0c 0c 00 00       	mov    %eax,0xc0c
}
 801:	90                   	nop
 802:	c9                   	leave  
 803:	c3                   	ret    

00000804 <morecore>:

static Header*
morecore(uint nu)
{
 804:	55                   	push   %ebp
 805:	89 e5                	mov    %esp,%ebp
 807:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 80a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 811:	77 07                	ja     81a <morecore+0x16>
    nu = 4096;
 813:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 81a:	8b 45 08             	mov    0x8(%ebp),%eax
 81d:	c1 e0 03             	shl    $0x3,%eax
 820:	83 ec 0c             	sub    $0xc,%esp
 823:	50                   	push   %eax
 824:	e8 19 fc ff ff       	call   442 <sbrk>
 829:	83 c4 10             	add    $0x10,%esp
 82c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 82f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 833:	75 07                	jne    83c <morecore+0x38>
    return 0;
 835:	b8 00 00 00 00       	mov    $0x0,%eax
 83a:	eb 26                	jmp    862 <morecore+0x5e>
  hp = (Header*)p;
 83c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 842:	8b 45 f0             	mov    -0x10(%ebp),%eax
 845:	8b 55 08             	mov    0x8(%ebp),%edx
 848:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 84b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84e:	83 c0 08             	add    $0x8,%eax
 851:	83 ec 0c             	sub    $0xc,%esp
 854:	50                   	push   %eax
 855:	e8 c8 fe ff ff       	call   722 <free>
 85a:	83 c4 10             	add    $0x10,%esp
  return freep;
 85d:	a1 0c 0c 00 00       	mov    0xc0c,%eax
}
 862:	c9                   	leave  
 863:	c3                   	ret    

00000864 <malloc>:

void*
malloc(uint nbytes)
{
 864:	55                   	push   %ebp
 865:	89 e5                	mov    %esp,%ebp
 867:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 86a:	8b 45 08             	mov    0x8(%ebp),%eax
 86d:	83 c0 07             	add    $0x7,%eax
 870:	c1 e8 03             	shr    $0x3,%eax
 873:	83 c0 01             	add    $0x1,%eax
 876:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 879:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 87e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 881:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 885:	75 23                	jne    8aa <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 887:	c7 45 f0 04 0c 00 00 	movl   $0xc04,-0x10(%ebp)
 88e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 891:	a3 0c 0c 00 00       	mov    %eax,0xc0c
 896:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 89b:	a3 04 0c 00 00       	mov    %eax,0xc04
    base.s.size = 0;
 8a0:	c7 05 08 0c 00 00 00 	movl   $0x0,0xc08
 8a7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ad:	8b 00                	mov    (%eax),%eax
 8af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b5:	8b 40 04             	mov    0x4(%eax),%eax
 8b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8bb:	72 4d                	jb     90a <malloc+0xa6>
      if(p->s.size == nunits)
 8bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c0:	8b 40 04             	mov    0x4(%eax),%eax
 8c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c6:	75 0c                	jne    8d4 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	8b 10                	mov    (%eax),%edx
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	89 10                	mov    %edx,(%eax)
 8d2:	eb 26                	jmp    8fa <malloc+0x96>
      else {
        p->s.size -= nunits;
 8d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d7:	8b 40 04             	mov    0x4(%eax),%eax
 8da:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8dd:	89 c2                	mov    %eax,%edx
 8df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e8:	8b 40 04             	mov    0x4(%eax),%eax
 8eb:	c1 e0 03             	shl    $0x3,%eax
 8ee:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8f7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fd:	a3 0c 0c 00 00       	mov    %eax,0xc0c
      return (void*)(p + 1);
 902:	8b 45 f4             	mov    -0xc(%ebp),%eax
 905:	83 c0 08             	add    $0x8,%eax
 908:	eb 3b                	jmp    945 <malloc+0xe1>
    }
    if(p == freep)
 90a:	a1 0c 0c 00 00       	mov    0xc0c,%eax
 90f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 912:	75 1e                	jne    932 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 914:	83 ec 0c             	sub    $0xc,%esp
 917:	ff 75 ec             	pushl  -0x14(%ebp)
 91a:	e8 e5 fe ff ff       	call   804 <morecore>
 91f:	83 c4 10             	add    $0x10,%esp
 922:	89 45 f4             	mov    %eax,-0xc(%ebp)
 925:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 929:	75 07                	jne    932 <malloc+0xce>
        return 0;
 92b:	b8 00 00 00 00       	mov    $0x0,%eax
 930:	eb 13                	jmp    945 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 932:	8b 45 f4             	mov    -0xc(%ebp),%eax
 935:	89 45 f0             	mov    %eax,-0x10(%ebp)
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	8b 00                	mov    (%eax),%eax
 93d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 940:	e9 6d ff ff ff       	jmp    8b2 <malloc+0x4e>
}
 945:	c9                   	leave  
 946:	c3                   	ret    
