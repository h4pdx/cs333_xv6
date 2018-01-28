
_echo:     file format elf32-i386


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

  for(i = 1; i < argc; i++)
  14:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  1b:	eb 3c                	jmp    59 <main+0x59>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  20:	83 c0 01             	add    $0x1,%eax
  23:	3b 03                	cmp    (%ebx),%eax
  25:	7d 07                	jge    2e <main+0x2e>
  27:	ba fc 08 00 00       	mov    $0x8fc,%edx
  2c:	eb 05                	jmp    33 <main+0x33>
  2e:	ba fe 08 00 00       	mov    $0x8fe,%edx
  33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  36:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  3d:	8b 43 04             	mov    0x4(%ebx),%eax
  40:	01 c8                	add    %ecx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	52                   	push   %edx
  45:	50                   	push   %eax
  46:	68 00 09 00 00       	push   $0x900
  4b:	6a 01                	push   $0x1
  4d:	e8 f4 04 00 00       	call   546 <printf>
  52:	83 c4 10             	add    $0x10,%esp
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  55:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5c:	3b 03                	cmp    (%ebx),%eax
  5e:	7c bd                	jl     1d <main+0x1d>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  60:	e8 2a 03 00 00       	call   38f <exit>

00000065 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  65:	55                   	push   %ebp
  66:	89 e5                	mov    %esp,%ebp
  68:	57                   	push   %edi
  69:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6d:	8b 55 10             	mov    0x10(%ebp),%edx
  70:	8b 45 0c             	mov    0xc(%ebp),%eax
  73:	89 cb                	mov    %ecx,%ebx
  75:	89 df                	mov    %ebx,%edi
  77:	89 d1                	mov    %edx,%ecx
  79:	fc                   	cld    
  7a:	f3 aa                	rep stos %al,%es:(%edi)
  7c:	89 ca                	mov    %ecx,%edx
  7e:	89 fb                	mov    %edi,%ebx
  80:	89 5d 08             	mov    %ebx,0x8(%ebp)
  83:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  86:	90                   	nop
  87:	5b                   	pop    %ebx
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    

0000008b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  91:	8b 45 08             	mov    0x8(%ebp),%eax
  94:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  97:	90                   	nop
  98:	8b 45 08             	mov    0x8(%ebp),%eax
  9b:	8d 50 01             	lea    0x1(%eax),%edx
  9e:	89 55 08             	mov    %edx,0x8(%ebp)
  a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  a4:	8d 4a 01             	lea    0x1(%edx),%ecx
  a7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	88 10                	mov    %dl,(%eax)
  af:	0f b6 00             	movzbl (%eax),%eax
  b2:	84 c0                	test   %al,%al
  b4:	75 e2                	jne    98 <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 08                	jmp    c8 <strcmp+0xd>
    p++, q++;
  c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c8:	8b 45 08             	mov    0x8(%ebp),%eax
  cb:	0f b6 00             	movzbl (%eax),%eax
  ce:	84 c0                	test   %al,%al
  d0:	74 10                	je     e2 <strcmp+0x27>
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 10             	movzbl (%eax),%edx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	0f b6 00             	movzbl (%eax),%eax
  de:	38 c2                	cmp    %al,%dl
  e0:	74 de                	je     c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	0f b6 d0             	movzbl %al,%edx
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	0f b6 00             	movzbl (%eax),%eax
  f1:	0f b6 c0             	movzbl %al,%eax
  f4:	29 c2                	sub    %eax,%edx
  f6:	89 d0                	mov    %edx,%eax
}
  f8:	5d                   	pop    %ebp
  f9:	c3                   	ret    

000000fa <strlen>:

uint
strlen(char *s)
{
  fa:	55                   	push   %ebp
  fb:	89 e5                	mov    %esp,%ebp
  fd:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 100:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 107:	eb 04                	jmp    10d <strlen+0x13>
 109:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 10d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	01 d0                	add    %edx,%eax
 115:	0f b6 00             	movzbl (%eax),%eax
 118:	84 c0                	test   %al,%al
 11a:	75 ed                	jne    109 <strlen+0xf>
    ;
  return n;
 11c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 11f:	c9                   	leave  
 120:	c3                   	ret    

00000121 <memset>:

void*
memset(void *dst, int c, uint n)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 124:	8b 45 10             	mov    0x10(%ebp),%eax
 127:	50                   	push   %eax
 128:	ff 75 0c             	pushl  0xc(%ebp)
 12b:	ff 75 08             	pushl  0x8(%ebp)
 12e:	e8 32 ff ff ff       	call   65 <stosb>
 133:	83 c4 0c             	add    $0xc,%esp
  return dst;
 136:	8b 45 08             	mov    0x8(%ebp),%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <strchr>:

char*
strchr(const char *s, char c)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 04             	sub    $0x4,%esp
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 147:	eb 14                	jmp    15d <strchr+0x22>
    if(*s == c)
 149:	8b 45 08             	mov    0x8(%ebp),%eax
 14c:	0f b6 00             	movzbl (%eax),%eax
 14f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 152:	75 05                	jne    159 <strchr+0x1e>
      return (char*)s;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	eb 13                	jmp    16c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 159:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 00             	movzbl (%eax),%eax
 163:	84 c0                	test   %al,%al
 165:	75 e2                	jne    149 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 167:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <gets>:

char*
gets(char *buf, int max)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 174:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 17b:	eb 42                	jmp    1bf <gets+0x51>
    cc = read(0, &c, 1);
 17d:	83 ec 04             	sub    $0x4,%esp
 180:	6a 01                	push   $0x1
 182:	8d 45 ef             	lea    -0x11(%ebp),%eax
 185:	50                   	push   %eax
 186:	6a 00                	push   $0x0
 188:	e8 1a 02 00 00       	call   3a7 <read>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 197:	7e 33                	jle    1cc <gets+0x5e>
      break;
    buf[i++] = c;
 199:	8b 45 f4             	mov    -0xc(%ebp),%eax
 19c:	8d 50 01             	lea    0x1(%eax),%edx
 19f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1a2:	89 c2                	mov    %eax,%edx
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	01 c2                	add    %eax,%edx
 1a9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ad:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1af:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b3:	3c 0a                	cmp    $0xa,%al
 1b5:	74 16                	je     1cd <gets+0x5f>
 1b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bb:	3c 0d                	cmp    $0xd,%al
 1bd:	74 0e                	je     1cd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c2:	83 c0 01             	add    $0x1,%eax
 1c5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1c8:	7c b3                	jl     17d <gets+0xf>
 1ca:	eb 01                	jmp    1cd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1cc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	83 ec 08             	sub    $0x8,%esp
 1e6:	6a 00                	push   $0x0
 1e8:	ff 75 08             	pushl  0x8(%ebp)
 1eb:	e8 df 01 00 00       	call   3cf <open>
 1f0:	83 c4 10             	add    $0x10,%esp
 1f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fa:	79 07                	jns    203 <stat+0x26>
    return -1;
 1fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 201:	eb 25                	jmp    228 <stat+0x4b>
  r = fstat(fd, st);
 203:	83 ec 08             	sub    $0x8,%esp
 206:	ff 75 0c             	pushl  0xc(%ebp)
 209:	ff 75 f4             	pushl  -0xc(%ebp)
 20c:	e8 d6 01 00 00       	call   3e7 <fstat>
 211:	83 c4 10             	add    $0x10,%esp
 214:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 217:	83 ec 0c             	sub    $0xc,%esp
 21a:	ff 75 f4             	pushl  -0xc(%ebp)
 21d:	e8 95 01 00 00       	call   3b7 <close>
 222:	83 c4 10             	add    $0x10,%esp
  return r;
 225:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <atoi>:

int
atoi(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 237:	eb 04                	jmp    23d <atoi+0x13>
 239:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	0f b6 00             	movzbl (%eax),%eax
 243:	3c 20                	cmp    $0x20,%al
 245:	74 f2                	je     239 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	0f b6 00             	movzbl (%eax),%eax
 24d:	3c 2d                	cmp    $0x2d,%al
 24f:	75 07                	jne    258 <atoi+0x2e>
 251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 256:	eb 05                	jmp    25d <atoi+0x33>
 258:	b8 01 00 00 00       	mov    $0x1,%eax
 25d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	0f b6 00             	movzbl (%eax),%eax
 266:	3c 2b                	cmp    $0x2b,%al
 268:	74 0a                	je     274 <atoi+0x4a>
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	3c 2d                	cmp    $0x2d,%al
 272:	75 2b                	jne    29f <atoi+0x75>
    s++;
 274:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 278:	eb 25                	jmp    29f <atoi+0x75>
    n = n*10 + *s++ - '0';
 27a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27d:	89 d0                	mov    %edx,%eax
 27f:	c1 e0 02             	shl    $0x2,%eax
 282:	01 d0                	add    %edx,%eax
 284:	01 c0                	add    %eax,%eax
 286:	89 c1                	mov    %eax,%ecx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	8d 50 01             	lea    0x1(%eax),%edx
 28e:	89 55 08             	mov    %edx,0x8(%ebp)
 291:	0f b6 00             	movzbl (%eax),%eax
 294:	0f be c0             	movsbl %al,%eax
 297:	01 c8                	add    %ecx,%eax
 299:	83 e8 30             	sub    $0x30,%eax
 29c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 00             	movzbl (%eax),%eax
 2a5:	3c 2f                	cmp    $0x2f,%al
 2a7:	7e 0a                	jle    2b3 <atoi+0x89>
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	3c 39                	cmp    $0x39,%al
 2b1:	7e c7                	jle    27a <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b6:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2ba:	c9                   	leave  
 2bb:	c3                   	ret    

000002bc <atoo>:

int
atoo(const char *s)
{
 2bc:	55                   	push   %ebp
 2bd:	89 e5                	mov    %esp,%ebp
 2bf:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2c9:	eb 04                	jmp    2cf <atoo+0x13>
 2cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	3c 20                	cmp    $0x20,%al
 2d7:	74 f2                	je     2cb <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 2d                	cmp    $0x2d,%al
 2e1:	75 07                	jne    2ea <atoo+0x2e>
 2e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e8:	eb 05                	jmp    2ef <atoo+0x33>
 2ea:	b8 01 00 00 00       	mov    $0x1,%eax
 2ef:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	0f b6 00             	movzbl (%eax),%eax
 2f8:	3c 2b                	cmp    $0x2b,%al
 2fa:	74 0a                	je     306 <atoo+0x4a>
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 00             	movzbl (%eax),%eax
 302:	3c 2d                	cmp    $0x2d,%al
 304:	75 27                	jne    32d <atoo+0x71>
    s++;
 306:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 30a:	eb 21                	jmp    32d <atoo+0x71>
    n = n*8 + *s++ - '0';
 30c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 30f:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	8d 50 01             	lea    0x1(%eax),%edx
 31c:	89 55 08             	mov    %edx,0x8(%ebp)
 31f:	0f b6 00             	movzbl (%eax),%eax
 322:	0f be c0             	movsbl %al,%eax
 325:	01 c8                	add    %ecx,%eax
 327:	83 e8 30             	sub    $0x30,%eax
 32a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	0f b6 00             	movzbl (%eax),%eax
 333:	3c 2f                	cmp    $0x2f,%al
 335:	7e 0a                	jle    341 <atoo+0x85>
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	0f b6 00             	movzbl (%eax),%eax
 33d:	3c 37                	cmp    $0x37,%al
 33f:	7e cb                	jle    30c <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 341:	8b 45 f8             	mov    -0x8(%ebp),%eax
 344:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 348:	c9                   	leave  
 349:	c3                   	ret    

0000034a <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 34a:	55                   	push   %ebp
 34b:	89 e5                	mov    %esp,%ebp
 34d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 356:	8b 45 0c             	mov    0xc(%ebp),%eax
 359:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 35c:	eb 17                	jmp    375 <memmove+0x2b>
    *dst++ = *src++;
 35e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 361:	8d 50 01             	lea    0x1(%eax),%edx
 364:	89 55 fc             	mov    %edx,-0x4(%ebp)
 367:	8b 55 f8             	mov    -0x8(%ebp),%edx
 36a:	8d 4a 01             	lea    0x1(%edx),%ecx
 36d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 370:	0f b6 12             	movzbl (%edx),%edx
 373:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 375:	8b 45 10             	mov    0x10(%ebp),%eax
 378:	8d 50 ff             	lea    -0x1(%eax),%edx
 37b:	89 55 10             	mov    %edx,0x10(%ebp)
 37e:	85 c0                	test   %eax,%eax
 380:	7f dc                	jg     35e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 382:	8b 45 08             	mov    0x8(%ebp),%eax
}
 385:	c9                   	leave  
 386:	c3                   	ret    

00000387 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 387:	b8 01 00 00 00       	mov    $0x1,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <exit>:
SYSCALL(exit)
 38f:	b8 02 00 00 00       	mov    $0x2,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <wait>:
SYSCALL(wait)
 397:	b8 03 00 00 00       	mov    $0x3,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <pipe>:
SYSCALL(pipe)
 39f:	b8 04 00 00 00       	mov    $0x4,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <read>:
SYSCALL(read)
 3a7:	b8 05 00 00 00       	mov    $0x5,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <write>:
SYSCALL(write)
 3af:	b8 10 00 00 00       	mov    $0x10,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <close>:
SYSCALL(close)
 3b7:	b8 15 00 00 00       	mov    $0x15,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <kill>:
SYSCALL(kill)
 3bf:	b8 06 00 00 00       	mov    $0x6,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <exec>:
SYSCALL(exec)
 3c7:	b8 07 00 00 00       	mov    $0x7,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <open>:
SYSCALL(open)
 3cf:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d4:	cd 40                	int    $0x40
 3d6:	c3                   	ret    

000003d7 <mknod>:
SYSCALL(mknod)
 3d7:	b8 11 00 00 00       	mov    $0x11,%eax
 3dc:	cd 40                	int    $0x40
 3de:	c3                   	ret    

000003df <unlink>:
SYSCALL(unlink)
 3df:	b8 12 00 00 00       	mov    $0x12,%eax
 3e4:	cd 40                	int    $0x40
 3e6:	c3                   	ret    

000003e7 <fstat>:
SYSCALL(fstat)
 3e7:	b8 08 00 00 00       	mov    $0x8,%eax
 3ec:	cd 40                	int    $0x40
 3ee:	c3                   	ret    

000003ef <link>:
SYSCALL(link)
 3ef:	b8 13 00 00 00       	mov    $0x13,%eax
 3f4:	cd 40                	int    $0x40
 3f6:	c3                   	ret    

000003f7 <mkdir>:
SYSCALL(mkdir)
 3f7:	b8 14 00 00 00       	mov    $0x14,%eax
 3fc:	cd 40                	int    $0x40
 3fe:	c3                   	ret    

000003ff <chdir>:
SYSCALL(chdir)
 3ff:	b8 09 00 00 00       	mov    $0x9,%eax
 404:	cd 40                	int    $0x40
 406:	c3                   	ret    

00000407 <dup>:
SYSCALL(dup)
 407:	b8 0a 00 00 00       	mov    $0xa,%eax
 40c:	cd 40                	int    $0x40
 40e:	c3                   	ret    

0000040f <getpid>:
SYSCALL(getpid)
 40f:	b8 0b 00 00 00       	mov    $0xb,%eax
 414:	cd 40                	int    $0x40
 416:	c3                   	ret    

00000417 <sbrk>:
SYSCALL(sbrk)
 417:	b8 0c 00 00 00       	mov    $0xc,%eax
 41c:	cd 40                	int    $0x40
 41e:	c3                   	ret    

0000041f <sleep>:
SYSCALL(sleep)
 41f:	b8 0d 00 00 00       	mov    $0xd,%eax
 424:	cd 40                	int    $0x40
 426:	c3                   	ret    

00000427 <uptime>:
SYSCALL(uptime)
 427:	b8 0e 00 00 00       	mov    $0xe,%eax
 42c:	cd 40                	int    $0x40
 42e:	c3                   	ret    

0000042f <halt>:
SYSCALL(halt)
 42f:	b8 16 00 00 00       	mov    $0x16,%eax
 434:	cd 40                	int    $0x40
 436:	c3                   	ret    

00000437 <date>:
SYSCALL(date)
 437:	b8 17 00 00 00       	mov    $0x17,%eax
 43c:	cd 40                	int    $0x40
 43e:	c3                   	ret    

0000043f <getuid>:
SYSCALL(getuid)
 43f:	b8 18 00 00 00       	mov    $0x18,%eax
 444:	cd 40                	int    $0x40
 446:	c3                   	ret    

00000447 <getgid>:
SYSCALL(getgid)
 447:	b8 19 00 00 00       	mov    $0x19,%eax
 44c:	cd 40                	int    $0x40
 44e:	c3                   	ret    

0000044f <getppid>:
SYSCALL(getppid)
 44f:	b8 1a 00 00 00       	mov    $0x1a,%eax
 454:	cd 40                	int    $0x40
 456:	c3                   	ret    

00000457 <setuid>:
SYSCALL(setuid)
 457:	b8 1b 00 00 00       	mov    $0x1b,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <setgid>:
SYSCALL(setgid)
 45f:	b8 1c 00 00 00       	mov    $0x1c,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <getprocs>:
SYSCALL(getprocs)
 467:	b8 1d 00 00 00       	mov    $0x1d,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 46f:	55                   	push   %ebp
 470:	89 e5                	mov    %esp,%ebp
 472:	83 ec 18             	sub    $0x18,%esp
 475:	8b 45 0c             	mov    0xc(%ebp),%eax
 478:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 47b:	83 ec 04             	sub    $0x4,%esp
 47e:	6a 01                	push   $0x1
 480:	8d 45 f4             	lea    -0xc(%ebp),%eax
 483:	50                   	push   %eax
 484:	ff 75 08             	pushl  0x8(%ebp)
 487:	e8 23 ff ff ff       	call   3af <write>
 48c:	83 c4 10             	add    $0x10,%esp
}
 48f:	90                   	nop
 490:	c9                   	leave  
 491:	c3                   	ret    

00000492 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 492:	55                   	push   %ebp
 493:	89 e5                	mov    %esp,%ebp
 495:	53                   	push   %ebx
 496:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 499:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4a0:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4a4:	74 17                	je     4bd <printint+0x2b>
 4a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4aa:	79 11                	jns    4bd <printint+0x2b>
    neg = 1;
 4ac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b6:	f7 d8                	neg    %eax
 4b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4bb:	eb 06                	jmp    4c3 <printint+0x31>
  } else {
    x = xx;
 4bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4ca:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4cd:	8d 41 01             	lea    0x1(%ecx),%eax
 4d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4d3:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4d9:	ba 00 00 00 00       	mov    $0x0,%edx
 4de:	f7 f3                	div    %ebx
 4e0:	89 d0                	mov    %edx,%eax
 4e2:	0f b6 80 78 0b 00 00 	movzbl 0xb78(%eax),%eax
 4e9:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f3:	ba 00 00 00 00       	mov    $0x0,%edx
 4f8:	f7 f3                	div    %ebx
 4fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4fd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 501:	75 c7                	jne    4ca <printint+0x38>
  if(neg)
 503:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 507:	74 2d                	je     536 <printint+0xa4>
    buf[i++] = '-';
 509:	8b 45 f4             	mov    -0xc(%ebp),%eax
 50c:	8d 50 01             	lea    0x1(%eax),%edx
 50f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 512:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 517:	eb 1d                	jmp    536 <printint+0xa4>
    putc(fd, buf[i]);
 519:	8d 55 dc             	lea    -0x24(%ebp),%edx
 51c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51f:	01 d0                	add    %edx,%eax
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	0f be c0             	movsbl %al,%eax
 527:	83 ec 08             	sub    $0x8,%esp
 52a:	50                   	push   %eax
 52b:	ff 75 08             	pushl  0x8(%ebp)
 52e:	e8 3c ff ff ff       	call   46f <putc>
 533:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 536:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 53a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 53e:	79 d9                	jns    519 <printint+0x87>
    putc(fd, buf[i]);
}
 540:	90                   	nop
 541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 544:	c9                   	leave  
 545:	c3                   	ret    

00000546 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 546:	55                   	push   %ebp
 547:	89 e5                	mov    %esp,%ebp
 549:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 54c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 553:	8d 45 0c             	lea    0xc(%ebp),%eax
 556:	83 c0 04             	add    $0x4,%eax
 559:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 55c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 563:	e9 59 01 00 00       	jmp    6c1 <printf+0x17b>
    c = fmt[i] & 0xff;
 568:	8b 55 0c             	mov    0xc(%ebp),%edx
 56b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 56e:	01 d0                	add    %edx,%eax
 570:	0f b6 00             	movzbl (%eax),%eax
 573:	0f be c0             	movsbl %al,%eax
 576:	25 ff 00 00 00       	and    $0xff,%eax
 57b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 57e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 582:	75 2c                	jne    5b0 <printf+0x6a>
      if(c == '%'){
 584:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 588:	75 0c                	jne    596 <printf+0x50>
        state = '%';
 58a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 591:	e9 27 01 00 00       	jmp    6bd <printf+0x177>
      } else {
        putc(fd, c);
 596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 599:	0f be c0             	movsbl %al,%eax
 59c:	83 ec 08             	sub    $0x8,%esp
 59f:	50                   	push   %eax
 5a0:	ff 75 08             	pushl  0x8(%ebp)
 5a3:	e8 c7 fe ff ff       	call   46f <putc>
 5a8:	83 c4 10             	add    $0x10,%esp
 5ab:	e9 0d 01 00 00       	jmp    6bd <printf+0x177>
      }
    } else if(state == '%'){
 5b0:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5b4:	0f 85 03 01 00 00    	jne    6bd <printf+0x177>
      if(c == 'd'){
 5ba:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5be:	75 1e                	jne    5de <printf+0x98>
        printint(fd, *ap, 10, 1);
 5c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c3:	8b 00                	mov    (%eax),%eax
 5c5:	6a 01                	push   $0x1
 5c7:	6a 0a                	push   $0xa
 5c9:	50                   	push   %eax
 5ca:	ff 75 08             	pushl  0x8(%ebp)
 5cd:	e8 c0 fe ff ff       	call   492 <printint>
 5d2:	83 c4 10             	add    $0x10,%esp
        ap++;
 5d5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d9:	e9 d8 00 00 00       	jmp    6b6 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5de:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5e2:	74 06                	je     5ea <printf+0xa4>
 5e4:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e8:	75 1e                	jne    608 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ed:	8b 00                	mov    (%eax),%eax
 5ef:	6a 00                	push   $0x0
 5f1:	6a 10                	push   $0x10
 5f3:	50                   	push   %eax
 5f4:	ff 75 08             	pushl  0x8(%ebp)
 5f7:	e8 96 fe ff ff       	call   492 <printint>
 5fc:	83 c4 10             	add    $0x10,%esp
        ap++;
 5ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 603:	e9 ae 00 00 00       	jmp    6b6 <printf+0x170>
      } else if(c == 's'){
 608:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 60c:	75 43                	jne    651 <printf+0x10b>
        s = (char*)*ap;
 60e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 611:	8b 00                	mov    (%eax),%eax
 613:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 616:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 61a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 61e:	75 25                	jne    645 <printf+0xff>
          s = "(null)";
 620:	c7 45 f4 05 09 00 00 	movl   $0x905,-0xc(%ebp)
        while(*s != 0){
 627:	eb 1c                	jmp    645 <printf+0xff>
          putc(fd, *s);
 629:	8b 45 f4             	mov    -0xc(%ebp),%eax
 62c:	0f b6 00             	movzbl (%eax),%eax
 62f:	0f be c0             	movsbl %al,%eax
 632:	83 ec 08             	sub    $0x8,%esp
 635:	50                   	push   %eax
 636:	ff 75 08             	pushl  0x8(%ebp)
 639:	e8 31 fe ff ff       	call   46f <putc>
 63e:	83 c4 10             	add    $0x10,%esp
          s++;
 641:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 645:	8b 45 f4             	mov    -0xc(%ebp),%eax
 648:	0f b6 00             	movzbl (%eax),%eax
 64b:	84 c0                	test   %al,%al
 64d:	75 da                	jne    629 <printf+0xe3>
 64f:	eb 65                	jmp    6b6 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 651:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 655:	75 1d                	jne    674 <printf+0x12e>
        putc(fd, *ap);
 657:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	0f be c0             	movsbl %al,%eax
 65f:	83 ec 08             	sub    $0x8,%esp
 662:	50                   	push   %eax
 663:	ff 75 08             	pushl  0x8(%ebp)
 666:	e8 04 fe ff ff       	call   46f <putc>
 66b:	83 c4 10             	add    $0x10,%esp
        ap++;
 66e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 672:	eb 42                	jmp    6b6 <printf+0x170>
      } else if(c == '%'){
 674:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 678:	75 17                	jne    691 <printf+0x14b>
        putc(fd, c);
 67a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67d:	0f be c0             	movsbl %al,%eax
 680:	83 ec 08             	sub    $0x8,%esp
 683:	50                   	push   %eax
 684:	ff 75 08             	pushl  0x8(%ebp)
 687:	e8 e3 fd ff ff       	call   46f <putc>
 68c:	83 c4 10             	add    $0x10,%esp
 68f:	eb 25                	jmp    6b6 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 691:	83 ec 08             	sub    $0x8,%esp
 694:	6a 25                	push   $0x25
 696:	ff 75 08             	pushl  0x8(%ebp)
 699:	e8 d1 fd ff ff       	call   46f <putc>
 69e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a4:	0f be c0             	movsbl %al,%eax
 6a7:	83 ec 08             	sub    $0x8,%esp
 6aa:	50                   	push   %eax
 6ab:	ff 75 08             	pushl  0x8(%ebp)
 6ae:	e8 bc fd ff ff       	call   46f <putc>
 6b3:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6b6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6bd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6c1:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c7:	01 d0                	add    %edx,%eax
 6c9:	0f b6 00             	movzbl (%eax),%eax
 6cc:	84 c0                	test   %al,%al
 6ce:	0f 85 94 fe ff ff    	jne    568 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6d4:	90                   	nop
 6d5:	c9                   	leave  
 6d6:	c3                   	ret    

000006d7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6d7:	55                   	push   %ebp
 6d8:	89 e5                	mov    %esp,%ebp
 6da:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6dd:	8b 45 08             	mov    0x8(%ebp),%eax
 6e0:	83 e8 08             	sub    $0x8,%eax
 6e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e6:	a1 94 0b 00 00       	mov    0xb94,%eax
 6eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ee:	eb 24                	jmp    714 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f3:	8b 00                	mov    (%eax),%eax
 6f5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6f8:	77 12                	ja     70c <free+0x35>
 6fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 700:	77 24                	ja     726 <free+0x4f>
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 00                	mov    (%eax),%eax
 707:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 70a:	77 1a                	ja     726 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 00                	mov    (%eax),%eax
 711:	89 45 fc             	mov    %eax,-0x4(%ebp)
 714:	8b 45 f8             	mov    -0x8(%ebp),%eax
 717:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71a:	76 d4                	jbe    6f0 <free+0x19>
 71c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71f:	8b 00                	mov    (%eax),%eax
 721:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 724:	76 ca                	jbe    6f0 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	8b 40 04             	mov    0x4(%eax),%eax
 72c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	01 c2                	add    %eax,%edx
 738:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73b:	8b 00                	mov    (%eax),%eax
 73d:	39 c2                	cmp    %eax,%edx
 73f:	75 24                	jne    765 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 741:	8b 45 f8             	mov    -0x8(%ebp),%eax
 744:	8b 50 04             	mov    0x4(%eax),%edx
 747:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74a:	8b 00                	mov    (%eax),%eax
 74c:	8b 40 04             	mov    0x4(%eax),%eax
 74f:	01 c2                	add    %eax,%edx
 751:	8b 45 f8             	mov    -0x8(%ebp),%eax
 754:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 757:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75a:	8b 00                	mov    (%eax),%eax
 75c:	8b 10                	mov    (%eax),%edx
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	89 10                	mov    %edx,(%eax)
 763:	eb 0a                	jmp    76f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	8b 10                	mov    (%eax),%edx
 76a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	8b 40 04             	mov    0x4(%eax),%eax
 775:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	01 d0                	add    %edx,%eax
 781:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 784:	75 20                	jne    7a6 <free+0xcf>
    p->s.size += bp->s.size;
 786:	8b 45 fc             	mov    -0x4(%ebp),%eax
 789:	8b 50 04             	mov    0x4(%eax),%edx
 78c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78f:	8b 40 04             	mov    0x4(%eax),%eax
 792:	01 c2                	add    %eax,%edx
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 79a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79d:	8b 10                	mov    (%eax),%edx
 79f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a2:	89 10                	mov    %edx,(%eax)
 7a4:	eb 08                	jmp    7ae <free+0xd7>
  } else
    p->s.ptr = bp;
 7a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7ac:	89 10                	mov    %edx,(%eax)
  freep = p;
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	a3 94 0b 00 00       	mov    %eax,0xb94
}
 7b6:	90                   	nop
 7b7:	c9                   	leave  
 7b8:	c3                   	ret    

000007b9 <morecore>:

static Header*
morecore(uint nu)
{
 7b9:	55                   	push   %ebp
 7ba:	89 e5                	mov    %esp,%ebp
 7bc:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7bf:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c6:	77 07                	ja     7cf <morecore+0x16>
    nu = 4096;
 7c8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7cf:	8b 45 08             	mov    0x8(%ebp),%eax
 7d2:	c1 e0 03             	shl    $0x3,%eax
 7d5:	83 ec 0c             	sub    $0xc,%esp
 7d8:	50                   	push   %eax
 7d9:	e8 39 fc ff ff       	call   417 <sbrk>
 7de:	83 c4 10             	add    $0x10,%esp
 7e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7e8:	75 07                	jne    7f1 <morecore+0x38>
    return 0;
 7ea:	b8 00 00 00 00       	mov    $0x0,%eax
 7ef:	eb 26                	jmp    817 <morecore+0x5e>
  hp = (Header*)p;
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fa:	8b 55 08             	mov    0x8(%ebp),%edx
 7fd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 800:	8b 45 f0             	mov    -0x10(%ebp),%eax
 803:	83 c0 08             	add    $0x8,%eax
 806:	83 ec 0c             	sub    $0xc,%esp
 809:	50                   	push   %eax
 80a:	e8 c8 fe ff ff       	call   6d7 <free>
 80f:	83 c4 10             	add    $0x10,%esp
  return freep;
 812:	a1 94 0b 00 00       	mov    0xb94,%eax
}
 817:	c9                   	leave  
 818:	c3                   	ret    

00000819 <malloc>:

void*
malloc(uint nbytes)
{
 819:	55                   	push   %ebp
 81a:	89 e5                	mov    %esp,%ebp
 81c:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81f:	8b 45 08             	mov    0x8(%ebp),%eax
 822:	83 c0 07             	add    $0x7,%eax
 825:	c1 e8 03             	shr    $0x3,%eax
 828:	83 c0 01             	add    $0x1,%eax
 82b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 82e:	a1 94 0b 00 00       	mov    0xb94,%eax
 833:	89 45 f0             	mov    %eax,-0x10(%ebp)
 836:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 83a:	75 23                	jne    85f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 83c:	c7 45 f0 8c 0b 00 00 	movl   $0xb8c,-0x10(%ebp)
 843:	8b 45 f0             	mov    -0x10(%ebp),%eax
 846:	a3 94 0b 00 00       	mov    %eax,0xb94
 84b:	a1 94 0b 00 00       	mov    0xb94,%eax
 850:	a3 8c 0b 00 00       	mov    %eax,0xb8c
    base.s.size = 0;
 855:	c7 05 90 0b 00 00 00 	movl   $0x0,0xb90
 85c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 862:	8b 00                	mov    (%eax),%eax
 864:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 867:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86a:	8b 40 04             	mov    0x4(%eax),%eax
 86d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 870:	72 4d                	jb     8bf <malloc+0xa6>
      if(p->s.size == nunits)
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	8b 40 04             	mov    0x4(%eax),%eax
 878:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87b:	75 0c                	jne    889 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	8b 10                	mov    (%eax),%edx
 882:	8b 45 f0             	mov    -0x10(%ebp),%eax
 885:	89 10                	mov    %edx,(%eax)
 887:	eb 26                	jmp    8af <malloc+0x96>
      else {
        p->s.size -= nunits;
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	8b 40 04             	mov    0x4(%eax),%eax
 88f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 892:	89 c2                	mov    %eax,%edx
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 89a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89d:	8b 40 04             	mov    0x4(%eax),%eax
 8a0:	c1 e0 03             	shl    $0x3,%eax
 8a3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ac:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b2:	a3 94 0b 00 00       	mov    %eax,0xb94
      return (void*)(p + 1);
 8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ba:	83 c0 08             	add    $0x8,%eax
 8bd:	eb 3b                	jmp    8fa <malloc+0xe1>
    }
    if(p == freep)
 8bf:	a1 94 0b 00 00       	mov    0xb94,%eax
 8c4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c7:	75 1e                	jne    8e7 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8c9:	83 ec 0c             	sub    $0xc,%esp
 8cc:	ff 75 ec             	pushl  -0x14(%ebp)
 8cf:	e8 e5 fe ff ff       	call   7b9 <morecore>
 8d4:	83 c4 10             	add    $0x10,%esp
 8d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8de:	75 07                	jne    8e7 <malloc+0xce>
        return 0;
 8e0:	b8 00 00 00 00       	mov    $0x0,%eax
 8e5:	eb 13                	jmp    8fa <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f0:	8b 00                	mov    (%eax),%eax
 8f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8f5:	e9 6d ff ff ff       	jmp    867 <malloc+0x4e>
}
 8fa:	c9                   	leave  
 8fb:	c3                   	ret    
