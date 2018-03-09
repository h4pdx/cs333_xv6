
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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
    printf(2, "usage: kill pid...\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 29 09 00 00       	push   $0x929
  21:	6a 02                	push   $0x2
  23:	e8 4b 05 00 00       	call   573 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 6c 03 00 00       	call   39c <exit>
  }
  for(i=1; i<argc; i++)
  30:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  37:	eb 2d                	jmp    66 <main+0x66>
    kill(atoi(argv[i]));
  39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  43:	8b 43 04             	mov    0x4(%ebx),%eax
  46:	01 d0                	add    %edx,%eax
  48:	8b 00                	mov    (%eax),%eax
  4a:	83 ec 0c             	sub    $0xc,%esp
  4d:	50                   	push   %eax
  4e:	e8 e4 01 00 00       	call   237 <atoi>
  53:	83 c4 10             	add    $0x10,%esp
  56:	83 ec 0c             	sub    $0xc,%esp
  59:	50                   	push   %eax
  5a:	e8 6d 03 00 00       	call   3cc <kill>
  5f:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  69:	3b 03                	cmp    (%ebx),%eax
  6b:	7c cc                	jl     39 <main+0x39>
    kill(atoi(argv[i]));
  exit();
  6d:	e8 2a 03 00 00       	call   39c <exit>

00000072 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	57                   	push   %edi
  76:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  77:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7a:	8b 55 10             	mov    0x10(%ebp),%edx
  7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  80:	89 cb                	mov    %ecx,%ebx
  82:	89 df                	mov    %ebx,%edi
  84:	89 d1                	mov    %edx,%ecx
  86:	fc                   	cld    
  87:	f3 aa                	rep stos %al,%es:(%edi)
  89:	89 ca                	mov    %ecx,%edx
  8b:	89 fb                	mov    %edi,%ebx
  8d:	89 5d 08             	mov    %ebx,0x8(%ebp)
  90:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  93:	90                   	nop
  94:	5b                   	pop    %ebx
  95:	5f                   	pop    %edi
  96:	5d                   	pop    %ebp
  97:	c3                   	ret    

00000098 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  98:	55                   	push   %ebp
  99:	89 e5                	mov    %esp,%ebp
  9b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a4:	90                   	nop
  a5:	8b 45 08             	mov    0x8(%ebp),%eax
  a8:	8d 50 01             	lea    0x1(%eax),%edx
  ab:	89 55 08             	mov    %edx,0x8(%ebp)
  ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  b1:	8d 4a 01             	lea    0x1(%edx),%ecx
  b4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b7:	0f b6 12             	movzbl (%edx),%edx
  ba:	88 10                	mov    %dl,(%eax)
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	75 e2                	jne    a5 <strcpy+0xd>
    ;
  return os;
  c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c6:	c9                   	leave  
  c7:	c3                   	ret    

000000c8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c8:	55                   	push   %ebp
  c9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cb:	eb 08                	jmp    d5 <strcmp+0xd>
    p++, q++;
  cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	74 10                	je     ef <strcmp+0x27>
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	0f b6 10             	movzbl (%eax),%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	0f b6 00             	movzbl (%eax),%eax
  eb:	38 c2                	cmp    %al,%dl
  ed:	74 de                	je     cd <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ef:	8b 45 08             	mov    0x8(%ebp),%eax
  f2:	0f b6 00             	movzbl (%eax),%eax
  f5:	0f b6 d0             	movzbl %al,%edx
  f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  fb:	0f b6 00             	movzbl (%eax),%eax
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strlen>:

uint
strlen(char *s)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 114:	eb 04                	jmp    11a <strlen+0x13>
 116:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	01 d0                	add    %edx,%eax
 122:	0f b6 00             	movzbl (%eax),%eax
 125:	84 c0                	test   %al,%al
 127:	75 ed                	jne    116 <strlen+0xf>
    ;
  return n;
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12c:	c9                   	leave  
 12d:	c3                   	ret    

0000012e <memset>:

void*
memset(void *dst, int c, uint n)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 131:	8b 45 10             	mov    0x10(%ebp),%eax
 134:	50                   	push   %eax
 135:	ff 75 0c             	pushl  0xc(%ebp)
 138:	ff 75 08             	pushl  0x8(%ebp)
 13b:	e8 32 ff ff ff       	call   72 <stosb>
 140:	83 c4 0c             	add    $0xc,%esp
  return dst;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
}
 146:	c9                   	leave  
 147:	c3                   	ret    

00000148 <strchr>:

char*
strchr(const char *s, char c)
{
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	83 ec 04             	sub    $0x4,%esp
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 154:	eb 14                	jmp    16a <strchr+0x22>
    if(*s == c)
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15f:	75 05                	jne    166 <strchr+0x1e>
      return (char*)s;
 161:	8b 45 08             	mov    0x8(%ebp),%eax
 164:	eb 13                	jmp    179 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 166:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	75 e2                	jne    156 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 174:	b8 00 00 00 00       	mov    $0x0,%eax
}
 179:	c9                   	leave  
 17a:	c3                   	ret    

0000017b <gets>:

char*
gets(char *buf, int max)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 181:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 188:	eb 42                	jmp    1cc <gets+0x51>
    cc = read(0, &c, 1);
 18a:	83 ec 04             	sub    $0x4,%esp
 18d:	6a 01                	push   $0x1
 18f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 192:	50                   	push   %eax
 193:	6a 00                	push   $0x0
 195:	e8 1a 02 00 00       	call   3b4 <read>
 19a:	83 c4 10             	add    $0x10,%esp
 19d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a4:	7e 33                	jle    1d9 <gets+0x5e>
      break;
    buf[i++] = c;
 1a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a9:	8d 50 01             	lea    0x1(%eax),%edx
 1ac:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1af:	89 c2                	mov    %eax,%edx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	01 c2                	add    %eax,%edx
 1b6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ba:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1bc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c0:	3c 0a                	cmp    $0xa,%al
 1c2:	74 16                	je     1da <gets+0x5f>
 1c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c8:	3c 0d                	cmp    $0xd,%al
 1ca:	74 0e                	je     1da <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cf:	83 c0 01             	add    $0x1,%eax
 1d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d5:	7c b3                	jl     18a <gets+0xf>
 1d7:	eb 01                	jmp    1da <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1da:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	01 d0                	add    %edx,%eax
 1e2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e8:	c9                   	leave  
 1e9:	c3                   	ret    

000001ea <stat>:

int
stat(char *n, struct stat *st)
{
 1ea:	55                   	push   %ebp
 1eb:	89 e5                	mov    %esp,%ebp
 1ed:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	6a 00                	push   $0x0
 1f5:	ff 75 08             	pushl  0x8(%ebp)
 1f8:	e8 df 01 00 00       	call   3dc <open>
 1fd:	83 c4 10             	add    $0x10,%esp
 200:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 203:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 207:	79 07                	jns    210 <stat+0x26>
    return -1;
 209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20e:	eb 25                	jmp    235 <stat+0x4b>
  r = fstat(fd, st);
 210:	83 ec 08             	sub    $0x8,%esp
 213:	ff 75 0c             	pushl  0xc(%ebp)
 216:	ff 75 f4             	pushl  -0xc(%ebp)
 219:	e8 d6 01 00 00       	call   3f4 <fstat>
 21e:	83 c4 10             	add    $0x10,%esp
 221:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 224:	83 ec 0c             	sub    $0xc,%esp
 227:	ff 75 f4             	pushl  -0xc(%ebp)
 22a:	e8 95 01 00 00       	call   3c4 <close>
 22f:	83 c4 10             	add    $0x10,%esp
  return r;
 232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 235:	c9                   	leave  
 236:	c3                   	ret    

00000237 <atoi>:

int
atoi(const char *s)
{
 237:	55                   	push   %ebp
 238:	89 e5                	mov    %esp,%ebp
 23a:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 23d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 244:	eb 04                	jmp    24a <atoi+0x13>
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	3c 20                	cmp    $0x20,%al
 252:	74 f2                	je     246 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	0f b6 00             	movzbl (%eax),%eax
 25a:	3c 2d                	cmp    $0x2d,%al
 25c:	75 07                	jne    265 <atoi+0x2e>
 25e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 263:	eb 05                	jmp    26a <atoi+0x33>
 265:	b8 01 00 00 00       	mov    $0x1,%eax
 26a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2b                	cmp    $0x2b,%al
 275:	74 0a                	je     281 <atoi+0x4a>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 2d                	cmp    $0x2d,%al
 27f:	75 2b                	jne    2ac <atoi+0x75>
    s++;
 281:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 285:	eb 25                	jmp    2ac <atoi+0x75>
    n = n*10 + *s++ - '0';
 287:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28a:	89 d0                	mov    %edx,%eax
 28c:	c1 e0 02             	shl    $0x2,%eax
 28f:	01 d0                	add    %edx,%eax
 291:	01 c0                	add    %eax,%eax
 293:	89 c1                	mov    %eax,%ecx
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	8d 50 01             	lea    0x1(%eax),%edx
 29b:	89 55 08             	mov    %edx,0x8(%ebp)
 29e:	0f b6 00             	movzbl (%eax),%eax
 2a1:	0f be c0             	movsbl %al,%eax
 2a4:	01 c8                	add    %ecx,%eax
 2a6:	83 e8 30             	sub    $0x30,%eax
 2a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	0f b6 00             	movzbl (%eax),%eax
 2b2:	3c 2f                	cmp    $0x2f,%al
 2b4:	7e 0a                	jle    2c0 <atoi+0x89>
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 00             	movzbl (%eax),%eax
 2bc:	3c 39                	cmp    $0x39,%al
 2be:	7e c7                	jle    287 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2c3:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2c7:	c9                   	leave  
 2c8:	c3                   	ret    

000002c9 <atoo>:

int
atoo(const char *s)
{
 2c9:	55                   	push   %ebp
 2ca:	89 e5                	mov    %esp,%ebp
 2cc:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2d6:	eb 04                	jmp    2dc <atoo+0x13>
 2d8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	0f b6 00             	movzbl (%eax),%eax
 2e2:	3c 20                	cmp    $0x20,%al
 2e4:	74 f2                	je     2d8 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	0f b6 00             	movzbl (%eax),%eax
 2ec:	3c 2d                	cmp    $0x2d,%al
 2ee:	75 07                	jne    2f7 <atoo+0x2e>
 2f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f5:	eb 05                	jmp    2fc <atoo+0x33>
 2f7:	b8 01 00 00 00       	mov    $0x1,%eax
 2fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	0f b6 00             	movzbl (%eax),%eax
 305:	3c 2b                	cmp    $0x2b,%al
 307:	74 0a                	je     313 <atoo+0x4a>
 309:	8b 45 08             	mov    0x8(%ebp),%eax
 30c:	0f b6 00             	movzbl (%eax),%eax
 30f:	3c 2d                	cmp    $0x2d,%al
 311:	75 27                	jne    33a <atoo+0x71>
    s++;
 313:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 317:	eb 21                	jmp    33a <atoo+0x71>
    n = n*8 + *s++ - '0';
 319:	8b 45 fc             	mov    -0x4(%ebp),%eax
 31c:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	8d 50 01             	lea    0x1(%eax),%edx
 329:	89 55 08             	mov    %edx,0x8(%ebp)
 32c:	0f b6 00             	movzbl (%eax),%eax
 32f:	0f be c0             	movsbl %al,%eax
 332:	01 c8                	add    %ecx,%eax
 334:	83 e8 30             	sub    $0x30,%eax
 337:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	0f b6 00             	movzbl (%eax),%eax
 340:	3c 2f                	cmp    $0x2f,%al
 342:	7e 0a                	jle    34e <atoo+0x85>
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	0f b6 00             	movzbl (%eax),%eax
 34a:	3c 37                	cmp    $0x37,%al
 34c:	7e cb                	jle    319 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 34e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 351:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 355:	c9                   	leave  
 356:	c3                   	ret    

00000357 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 357:	55                   	push   %ebp
 358:	89 e5                	mov    %esp,%ebp
 35a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
 360:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 363:	8b 45 0c             	mov    0xc(%ebp),%eax
 366:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 369:	eb 17                	jmp    382 <memmove+0x2b>
    *dst++ = *src++;
 36b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 36e:	8d 50 01             	lea    0x1(%eax),%edx
 371:	89 55 fc             	mov    %edx,-0x4(%ebp)
 374:	8b 55 f8             	mov    -0x8(%ebp),%edx
 377:	8d 4a 01             	lea    0x1(%edx),%ecx
 37a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 37d:	0f b6 12             	movzbl (%edx),%edx
 380:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 382:	8b 45 10             	mov    0x10(%ebp),%eax
 385:	8d 50 ff             	lea    -0x1(%eax),%edx
 388:	89 55 10             	mov    %edx,0x10(%ebp)
 38b:	85 c0                	test   %eax,%eax
 38d:	7f dc                	jg     36b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 392:	c9                   	leave  
 393:	c3                   	ret    

00000394 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 394:	b8 01 00 00 00       	mov    $0x1,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <exit>:
SYSCALL(exit)
 39c:	b8 02 00 00 00       	mov    $0x2,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <wait>:
SYSCALL(wait)
 3a4:	b8 03 00 00 00       	mov    $0x3,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <pipe>:
SYSCALL(pipe)
 3ac:	b8 04 00 00 00       	mov    $0x4,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <read>:
SYSCALL(read)
 3b4:	b8 05 00 00 00       	mov    $0x5,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <write>:
SYSCALL(write)
 3bc:	b8 10 00 00 00       	mov    $0x10,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <close>:
SYSCALL(close)
 3c4:	b8 15 00 00 00       	mov    $0x15,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <kill>:
SYSCALL(kill)
 3cc:	b8 06 00 00 00       	mov    $0x6,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <exec>:
SYSCALL(exec)
 3d4:	b8 07 00 00 00       	mov    $0x7,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <open>:
SYSCALL(open)
 3dc:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <mknod>:
SYSCALL(mknod)
 3e4:	b8 11 00 00 00       	mov    $0x11,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <unlink>:
SYSCALL(unlink)
 3ec:	b8 12 00 00 00       	mov    $0x12,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <fstat>:
SYSCALL(fstat)
 3f4:	b8 08 00 00 00       	mov    $0x8,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <link>:
SYSCALL(link)
 3fc:	b8 13 00 00 00       	mov    $0x13,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <mkdir>:
SYSCALL(mkdir)
 404:	b8 14 00 00 00       	mov    $0x14,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <chdir>:
SYSCALL(chdir)
 40c:	b8 09 00 00 00       	mov    $0x9,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <dup>:
SYSCALL(dup)
 414:	b8 0a 00 00 00       	mov    $0xa,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <getpid>:
SYSCALL(getpid)
 41c:	b8 0b 00 00 00       	mov    $0xb,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <sbrk>:
SYSCALL(sbrk)
 424:	b8 0c 00 00 00       	mov    $0xc,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <sleep>:
SYSCALL(sleep)
 42c:	b8 0d 00 00 00       	mov    $0xd,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <uptime>:
SYSCALL(uptime)
 434:	b8 0e 00 00 00       	mov    $0xe,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <halt>:
SYSCALL(halt)
 43c:	b8 16 00 00 00       	mov    $0x16,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <date>:
SYSCALL(date)
 444:	b8 17 00 00 00       	mov    $0x17,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <getuid>:
SYSCALL(getuid)
 44c:	b8 18 00 00 00       	mov    $0x18,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <getgid>:
SYSCALL(getgid)
 454:	b8 19 00 00 00       	mov    $0x19,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <getppid>:
SYSCALL(getppid)
 45c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <setuid>:
SYSCALL(setuid)
 464:	b8 1b 00 00 00       	mov    $0x1b,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <setgid>:
SYSCALL(setgid)
 46c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <getprocs>:
SYSCALL(getprocs)
 474:	b8 1d 00 00 00       	mov    $0x1d,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <setpriority>:
SYSCALL(setpriority)
 47c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <chmod>:
SYSCALL(chmod)
 484:	b8 1f 00 00 00       	mov    $0x1f,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <chown>:
SYSCALL(chown)
 48c:	b8 20 00 00 00       	mov    $0x20,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <chgrp>:
SYSCALL(chgrp)
 494:	b8 21 00 00 00       	mov    $0x21,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 49c:	55                   	push   %ebp
 49d:	89 e5                	mov    %esp,%ebp
 49f:	83 ec 18             	sub    $0x18,%esp
 4a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4a8:	83 ec 04             	sub    $0x4,%esp
 4ab:	6a 01                	push   $0x1
 4ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b0:	50                   	push   %eax
 4b1:	ff 75 08             	pushl  0x8(%ebp)
 4b4:	e8 03 ff ff ff       	call   3bc <write>
 4b9:	83 c4 10             	add    $0x10,%esp
}
 4bc:	90                   	nop
 4bd:	c9                   	leave  
 4be:	c3                   	ret    

000004bf <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4bf:	55                   	push   %ebp
 4c0:	89 e5                	mov    %esp,%ebp
 4c2:	53                   	push   %ebx
 4c3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4c6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4cd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4d1:	74 17                	je     4ea <printint+0x2b>
 4d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4d7:	79 11                	jns    4ea <printint+0x2b>
    neg = 1;
 4d9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e3:	f7 d8                	neg    %eax
 4e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4e8:	eb 06                	jmp    4f0 <printint+0x31>
  } else {
    x = xx;
 4ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4f0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4f7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4fa:	8d 41 01             	lea    0x1(%ecx),%eax
 4fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 500:	8b 5d 10             	mov    0x10(%ebp),%ebx
 503:	8b 45 ec             	mov    -0x14(%ebp),%eax
 506:	ba 00 00 00 00       	mov    $0x0,%edx
 50b:	f7 f3                	div    %ebx
 50d:	89 d0                	mov    %edx,%eax
 50f:	0f b6 80 b0 0b 00 00 	movzbl 0xbb0(%eax),%eax
 516:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 51a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 51d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 520:	ba 00 00 00 00       	mov    $0x0,%edx
 525:	f7 f3                	div    %ebx
 527:	89 45 ec             	mov    %eax,-0x14(%ebp)
 52a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 52e:	75 c7                	jne    4f7 <printint+0x38>
  if(neg)
 530:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 534:	74 2d                	je     563 <printint+0xa4>
    buf[i++] = '-';
 536:	8b 45 f4             	mov    -0xc(%ebp),%eax
 539:	8d 50 01             	lea    0x1(%eax),%edx
 53c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 53f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 544:	eb 1d                	jmp    563 <printint+0xa4>
    putc(fd, buf[i]);
 546:	8d 55 dc             	lea    -0x24(%ebp),%edx
 549:	8b 45 f4             	mov    -0xc(%ebp),%eax
 54c:	01 d0                	add    %edx,%eax
 54e:	0f b6 00             	movzbl (%eax),%eax
 551:	0f be c0             	movsbl %al,%eax
 554:	83 ec 08             	sub    $0x8,%esp
 557:	50                   	push   %eax
 558:	ff 75 08             	pushl  0x8(%ebp)
 55b:	e8 3c ff ff ff       	call   49c <putc>
 560:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 563:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 567:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 56b:	79 d9                	jns    546 <printint+0x87>
    putc(fd, buf[i]);
}
 56d:	90                   	nop
 56e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 571:	c9                   	leave  
 572:	c3                   	ret    

00000573 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 573:	55                   	push   %ebp
 574:	89 e5                	mov    %esp,%ebp
 576:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 579:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 580:	8d 45 0c             	lea    0xc(%ebp),%eax
 583:	83 c0 04             	add    $0x4,%eax
 586:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 589:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 590:	e9 59 01 00 00       	jmp    6ee <printf+0x17b>
    c = fmt[i] & 0xff;
 595:	8b 55 0c             	mov    0xc(%ebp),%edx
 598:	8b 45 f0             	mov    -0x10(%ebp),%eax
 59b:	01 d0                	add    %edx,%eax
 59d:	0f b6 00             	movzbl (%eax),%eax
 5a0:	0f be c0             	movsbl %al,%eax
 5a3:	25 ff 00 00 00       	and    $0xff,%eax
 5a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5af:	75 2c                	jne    5dd <printf+0x6a>
      if(c == '%'){
 5b1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5b5:	75 0c                	jne    5c3 <printf+0x50>
        state = '%';
 5b7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5be:	e9 27 01 00 00       	jmp    6ea <printf+0x177>
      } else {
        putc(fd, c);
 5c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5c6:	0f be c0             	movsbl %al,%eax
 5c9:	83 ec 08             	sub    $0x8,%esp
 5cc:	50                   	push   %eax
 5cd:	ff 75 08             	pushl  0x8(%ebp)
 5d0:	e8 c7 fe ff ff       	call   49c <putc>
 5d5:	83 c4 10             	add    $0x10,%esp
 5d8:	e9 0d 01 00 00       	jmp    6ea <printf+0x177>
      }
    } else if(state == '%'){
 5dd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5e1:	0f 85 03 01 00 00    	jne    6ea <printf+0x177>
      if(c == 'd'){
 5e7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5eb:	75 1e                	jne    60b <printf+0x98>
        printint(fd, *ap, 10, 1);
 5ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f0:	8b 00                	mov    (%eax),%eax
 5f2:	6a 01                	push   $0x1
 5f4:	6a 0a                	push   $0xa
 5f6:	50                   	push   %eax
 5f7:	ff 75 08             	pushl  0x8(%ebp)
 5fa:	e8 c0 fe ff ff       	call   4bf <printint>
 5ff:	83 c4 10             	add    $0x10,%esp
        ap++;
 602:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 606:	e9 d8 00 00 00       	jmp    6e3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 60b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 60f:	74 06                	je     617 <printf+0xa4>
 611:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 615:	75 1e                	jne    635 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 617:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61a:	8b 00                	mov    (%eax),%eax
 61c:	6a 00                	push   $0x0
 61e:	6a 10                	push   $0x10
 620:	50                   	push   %eax
 621:	ff 75 08             	pushl  0x8(%ebp)
 624:	e8 96 fe ff ff       	call   4bf <printint>
 629:	83 c4 10             	add    $0x10,%esp
        ap++;
 62c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 630:	e9 ae 00 00 00       	jmp    6e3 <printf+0x170>
      } else if(c == 's'){
 635:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 639:	75 43                	jne    67e <printf+0x10b>
        s = (char*)*ap;
 63b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63e:	8b 00                	mov    (%eax),%eax
 640:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 643:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 647:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 64b:	75 25                	jne    672 <printf+0xff>
          s = "(null)";
 64d:	c7 45 f4 3d 09 00 00 	movl   $0x93d,-0xc(%ebp)
        while(*s != 0){
 654:	eb 1c                	jmp    672 <printf+0xff>
          putc(fd, *s);
 656:	8b 45 f4             	mov    -0xc(%ebp),%eax
 659:	0f b6 00             	movzbl (%eax),%eax
 65c:	0f be c0             	movsbl %al,%eax
 65f:	83 ec 08             	sub    $0x8,%esp
 662:	50                   	push   %eax
 663:	ff 75 08             	pushl  0x8(%ebp)
 666:	e8 31 fe ff ff       	call   49c <putc>
 66b:	83 c4 10             	add    $0x10,%esp
          s++;
 66e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 672:	8b 45 f4             	mov    -0xc(%ebp),%eax
 675:	0f b6 00             	movzbl (%eax),%eax
 678:	84 c0                	test   %al,%al
 67a:	75 da                	jne    656 <printf+0xe3>
 67c:	eb 65                	jmp    6e3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 67e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 682:	75 1d                	jne    6a1 <printf+0x12e>
        putc(fd, *ap);
 684:	8b 45 e8             	mov    -0x18(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	0f be c0             	movsbl %al,%eax
 68c:	83 ec 08             	sub    $0x8,%esp
 68f:	50                   	push   %eax
 690:	ff 75 08             	pushl  0x8(%ebp)
 693:	e8 04 fe ff ff       	call   49c <putc>
 698:	83 c4 10             	add    $0x10,%esp
        ap++;
 69b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69f:	eb 42                	jmp    6e3 <printf+0x170>
      } else if(c == '%'){
 6a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a5:	75 17                	jne    6be <printf+0x14b>
        putc(fd, c);
 6a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6aa:	0f be c0             	movsbl %al,%eax
 6ad:	83 ec 08             	sub    $0x8,%esp
 6b0:	50                   	push   %eax
 6b1:	ff 75 08             	pushl  0x8(%ebp)
 6b4:	e8 e3 fd ff ff       	call   49c <putc>
 6b9:	83 c4 10             	add    $0x10,%esp
 6bc:	eb 25                	jmp    6e3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6be:	83 ec 08             	sub    $0x8,%esp
 6c1:	6a 25                	push   $0x25
 6c3:	ff 75 08             	pushl  0x8(%ebp)
 6c6:	e8 d1 fd ff ff       	call   49c <putc>
 6cb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d1:	0f be c0             	movsbl %al,%eax
 6d4:	83 ec 08             	sub    $0x8,%esp
 6d7:	50                   	push   %eax
 6d8:	ff 75 08             	pushl  0x8(%ebp)
 6db:	e8 bc fd ff ff       	call   49c <putc>
 6e0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ea:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f4:	01 d0                	add    %edx,%eax
 6f6:	0f b6 00             	movzbl (%eax),%eax
 6f9:	84 c0                	test   %al,%al
 6fb:	0f 85 94 fe ff ff    	jne    595 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 701:	90                   	nop
 702:	c9                   	leave  
 703:	c3                   	ret    

00000704 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 704:	55                   	push   %ebp
 705:	89 e5                	mov    %esp,%ebp
 707:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70a:	8b 45 08             	mov    0x8(%ebp),%eax
 70d:	83 e8 08             	sub    $0x8,%eax
 710:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 713:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 718:	89 45 fc             	mov    %eax,-0x4(%ebp)
 71b:	eb 24                	jmp    741 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 725:	77 12                	ja     739 <free+0x35>
 727:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72d:	77 24                	ja     753 <free+0x4f>
 72f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 732:	8b 00                	mov    (%eax),%eax
 734:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 737:	77 1a                	ja     753 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 739:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73c:	8b 00                	mov    (%eax),%eax
 73e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 741:	8b 45 f8             	mov    -0x8(%ebp),%eax
 744:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 747:	76 d4                	jbe    71d <free+0x19>
 749:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74c:	8b 00                	mov    (%eax),%eax
 74e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 751:	76 ca                	jbe    71d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	8b 40 04             	mov    0x4(%eax),%eax
 759:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 760:	8b 45 f8             	mov    -0x8(%ebp),%eax
 763:	01 c2                	add    %eax,%edx
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	8b 00                	mov    (%eax),%eax
 76a:	39 c2                	cmp    %eax,%edx
 76c:	75 24                	jne    792 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 76e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 771:	8b 50 04             	mov    0x4(%eax),%edx
 774:	8b 45 fc             	mov    -0x4(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	8b 40 04             	mov    0x4(%eax),%eax
 77c:	01 c2                	add    %eax,%edx
 77e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 781:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 784:	8b 45 fc             	mov    -0x4(%ebp),%eax
 787:	8b 00                	mov    (%eax),%eax
 789:	8b 10                	mov    (%eax),%edx
 78b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78e:	89 10                	mov    %edx,(%eax)
 790:	eb 0a                	jmp    79c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	8b 10                	mov    (%eax),%edx
 797:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	8b 40 04             	mov    0x4(%eax),%eax
 7a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	01 d0                	add    %edx,%eax
 7ae:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b1:	75 20                	jne    7d3 <free+0xcf>
    p->s.size += bp->s.size;
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	8b 50 04             	mov    0x4(%eax),%edx
 7b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bc:	8b 40 04             	mov    0x4(%eax),%eax
 7bf:	01 c2                	add    %eax,%edx
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ca:	8b 10                	mov    (%eax),%edx
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	89 10                	mov    %edx,(%eax)
 7d1:	eb 08                	jmp    7db <free+0xd7>
  } else
    p->s.ptr = bp;
 7d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7d9:	89 10                	mov    %edx,(%eax)
  freep = p;
 7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7de:	a3 cc 0b 00 00       	mov    %eax,0xbcc
}
 7e3:	90                   	nop
 7e4:	c9                   	leave  
 7e5:	c3                   	ret    

000007e6 <morecore>:

static Header*
morecore(uint nu)
{
 7e6:	55                   	push   %ebp
 7e7:	89 e5                	mov    %esp,%ebp
 7e9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7ec:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7f3:	77 07                	ja     7fc <morecore+0x16>
    nu = 4096;
 7f5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7fc:	8b 45 08             	mov    0x8(%ebp),%eax
 7ff:	c1 e0 03             	shl    $0x3,%eax
 802:	83 ec 0c             	sub    $0xc,%esp
 805:	50                   	push   %eax
 806:	e8 19 fc ff ff       	call   424 <sbrk>
 80b:	83 c4 10             	add    $0x10,%esp
 80e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 811:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 815:	75 07                	jne    81e <morecore+0x38>
    return 0;
 817:	b8 00 00 00 00       	mov    $0x0,%eax
 81c:	eb 26                	jmp    844 <morecore+0x5e>
  hp = (Header*)p;
 81e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 821:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 824:	8b 45 f0             	mov    -0x10(%ebp),%eax
 827:	8b 55 08             	mov    0x8(%ebp),%edx
 82a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 82d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 830:	83 c0 08             	add    $0x8,%eax
 833:	83 ec 0c             	sub    $0xc,%esp
 836:	50                   	push   %eax
 837:	e8 c8 fe ff ff       	call   704 <free>
 83c:	83 c4 10             	add    $0x10,%esp
  return freep;
 83f:	a1 cc 0b 00 00       	mov    0xbcc,%eax
}
 844:	c9                   	leave  
 845:	c3                   	ret    

00000846 <malloc>:

void*
malloc(uint nbytes)
{
 846:	55                   	push   %ebp
 847:	89 e5                	mov    %esp,%ebp
 849:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84c:	8b 45 08             	mov    0x8(%ebp),%eax
 84f:	83 c0 07             	add    $0x7,%eax
 852:	c1 e8 03             	shr    $0x3,%eax
 855:	83 c0 01             	add    $0x1,%eax
 858:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 85b:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 860:	89 45 f0             	mov    %eax,-0x10(%ebp)
 863:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 867:	75 23                	jne    88c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 869:	c7 45 f0 c4 0b 00 00 	movl   $0xbc4,-0x10(%ebp)
 870:	8b 45 f0             	mov    -0x10(%ebp),%eax
 873:	a3 cc 0b 00 00       	mov    %eax,0xbcc
 878:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 87d:	a3 c4 0b 00 00       	mov    %eax,0xbc4
    base.s.size = 0;
 882:	c7 05 c8 0b 00 00 00 	movl   $0x0,0xbc8
 889:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 88c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88f:	8b 00                	mov    (%eax),%eax
 891:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	8b 40 04             	mov    0x4(%eax),%eax
 89a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 89d:	72 4d                	jb     8ec <malloc+0xa6>
      if(p->s.size == nunits)
 89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a2:	8b 40 04             	mov    0x4(%eax),%eax
 8a5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a8:	75 0c                	jne    8b6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ad:	8b 10                	mov    (%eax),%edx
 8af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b2:	89 10                	mov    %edx,(%eax)
 8b4:	eb 26                	jmp    8dc <malloc+0x96>
      else {
        p->s.size -= nunits;
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	8b 40 04             	mov    0x4(%eax),%eax
 8bc:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8bf:	89 c2                	mov    %eax,%edx
 8c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ca:	8b 40 04             	mov    0x4(%eax),%eax
 8cd:	c1 e0 03             	shl    $0x3,%eax
 8d0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8d9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8df:	a3 cc 0b 00 00       	mov    %eax,0xbcc
      return (void*)(p + 1);
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	83 c0 08             	add    $0x8,%eax
 8ea:	eb 3b                	jmp    927 <malloc+0xe1>
    }
    if(p == freep)
 8ec:	a1 cc 0b 00 00       	mov    0xbcc,%eax
 8f1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f4:	75 1e                	jne    914 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8f6:	83 ec 0c             	sub    $0xc,%esp
 8f9:	ff 75 ec             	pushl  -0x14(%ebp)
 8fc:	e8 e5 fe ff ff       	call   7e6 <morecore>
 901:	83 c4 10             	add    $0x10,%esp
 904:	89 45 f4             	mov    %eax,-0xc(%ebp)
 907:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 90b:	75 07                	jne    914 <malloc+0xce>
        return 0;
 90d:	b8 00 00 00 00       	mov    $0x0,%eax
 912:	eb 13                	jmp    927 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	8b 00                	mov    (%eax),%eax
 91f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 922:	e9 6d ff ff ff       	jmp    894 <malloc+0x4e>
}
 927:	c9                   	leave  
 928:	c3                   	ret    
