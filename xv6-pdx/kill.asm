
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
  1c:	68 09 09 00 00       	push   $0x909
  21:	6a 02                	push   $0x2
  23:	e8 2b 05 00 00       	call   553 <printf>
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

0000047c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 47c:	55                   	push   %ebp
 47d:	89 e5                	mov    %esp,%ebp
 47f:	83 ec 18             	sub    $0x18,%esp
 482:	8b 45 0c             	mov    0xc(%ebp),%eax
 485:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 488:	83 ec 04             	sub    $0x4,%esp
 48b:	6a 01                	push   $0x1
 48d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 490:	50                   	push   %eax
 491:	ff 75 08             	pushl  0x8(%ebp)
 494:	e8 23 ff ff ff       	call   3bc <write>
 499:	83 c4 10             	add    $0x10,%esp
}
 49c:	90                   	nop
 49d:	c9                   	leave  
 49e:	c3                   	ret    

0000049f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 49f:	55                   	push   %ebp
 4a0:	89 e5                	mov    %esp,%ebp
 4a2:	53                   	push   %ebx
 4a3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4ad:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4b1:	74 17                	je     4ca <printint+0x2b>
 4b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4b7:	79 11                	jns    4ca <printint+0x2b>
    neg = 1;
 4b9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c3:	f7 d8                	neg    %eax
 4c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4c8:	eb 06                	jmp    4d0 <printint+0x31>
  } else {
    x = xx;
 4ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4d7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4da:	8d 41 01             	lea    0x1(%ecx),%eax
 4dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e6:	ba 00 00 00 00       	mov    $0x0,%edx
 4eb:	f7 f3                	div    %ebx
 4ed:	89 d0                	mov    %edx,%eax
 4ef:	0f b6 80 90 0b 00 00 	movzbl 0xb90(%eax),%eax
 4f6:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 500:	ba 00 00 00 00       	mov    $0x0,%edx
 505:	f7 f3                	div    %ebx
 507:	89 45 ec             	mov    %eax,-0x14(%ebp)
 50a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 50e:	75 c7                	jne    4d7 <printint+0x38>
  if(neg)
 510:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 514:	74 2d                	je     543 <printint+0xa4>
    buf[i++] = '-';
 516:	8b 45 f4             	mov    -0xc(%ebp),%eax
 519:	8d 50 01             	lea    0x1(%eax),%edx
 51c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 51f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 524:	eb 1d                	jmp    543 <printint+0xa4>
    putc(fd, buf[i]);
 526:	8d 55 dc             	lea    -0x24(%ebp),%edx
 529:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52c:	01 d0                	add    %edx,%eax
 52e:	0f b6 00             	movzbl (%eax),%eax
 531:	0f be c0             	movsbl %al,%eax
 534:	83 ec 08             	sub    $0x8,%esp
 537:	50                   	push   %eax
 538:	ff 75 08             	pushl  0x8(%ebp)
 53b:	e8 3c ff ff ff       	call   47c <putc>
 540:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 543:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 547:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 54b:	79 d9                	jns    526 <printint+0x87>
    putc(fd, buf[i]);
}
 54d:	90                   	nop
 54e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 551:	c9                   	leave  
 552:	c3                   	ret    

00000553 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 553:	55                   	push   %ebp
 554:	89 e5                	mov    %esp,%ebp
 556:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 559:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 560:	8d 45 0c             	lea    0xc(%ebp),%eax
 563:	83 c0 04             	add    $0x4,%eax
 566:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 569:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 570:	e9 59 01 00 00       	jmp    6ce <printf+0x17b>
    c = fmt[i] & 0xff;
 575:	8b 55 0c             	mov    0xc(%ebp),%edx
 578:	8b 45 f0             	mov    -0x10(%ebp),%eax
 57b:	01 d0                	add    %edx,%eax
 57d:	0f b6 00             	movzbl (%eax),%eax
 580:	0f be c0             	movsbl %al,%eax
 583:	25 ff 00 00 00       	and    $0xff,%eax
 588:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 58b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 58f:	75 2c                	jne    5bd <printf+0x6a>
      if(c == '%'){
 591:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 595:	75 0c                	jne    5a3 <printf+0x50>
        state = '%';
 597:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 59e:	e9 27 01 00 00       	jmp    6ca <printf+0x177>
      } else {
        putc(fd, c);
 5a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a6:	0f be c0             	movsbl %al,%eax
 5a9:	83 ec 08             	sub    $0x8,%esp
 5ac:	50                   	push   %eax
 5ad:	ff 75 08             	pushl  0x8(%ebp)
 5b0:	e8 c7 fe ff ff       	call   47c <putc>
 5b5:	83 c4 10             	add    $0x10,%esp
 5b8:	e9 0d 01 00 00       	jmp    6ca <printf+0x177>
      }
    } else if(state == '%'){
 5bd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5c1:	0f 85 03 01 00 00    	jne    6ca <printf+0x177>
      if(c == 'd'){
 5c7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5cb:	75 1e                	jne    5eb <printf+0x98>
        printint(fd, *ap, 10, 1);
 5cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d0:	8b 00                	mov    (%eax),%eax
 5d2:	6a 01                	push   $0x1
 5d4:	6a 0a                	push   $0xa
 5d6:	50                   	push   %eax
 5d7:	ff 75 08             	pushl  0x8(%ebp)
 5da:	e8 c0 fe ff ff       	call   49f <printint>
 5df:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e6:	e9 d8 00 00 00       	jmp    6c3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5eb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5ef:	74 06                	je     5f7 <printf+0xa4>
 5f1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5f5:	75 1e                	jne    615 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fa:	8b 00                	mov    (%eax),%eax
 5fc:	6a 00                	push   $0x0
 5fe:	6a 10                	push   $0x10
 600:	50                   	push   %eax
 601:	ff 75 08             	pushl  0x8(%ebp)
 604:	e8 96 fe ff ff       	call   49f <printint>
 609:	83 c4 10             	add    $0x10,%esp
        ap++;
 60c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 610:	e9 ae 00 00 00       	jmp    6c3 <printf+0x170>
      } else if(c == 's'){
 615:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 619:	75 43                	jne    65e <printf+0x10b>
        s = (char*)*ap;
 61b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61e:	8b 00                	mov    (%eax),%eax
 620:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 623:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 627:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 62b:	75 25                	jne    652 <printf+0xff>
          s = "(null)";
 62d:	c7 45 f4 1d 09 00 00 	movl   $0x91d,-0xc(%ebp)
        while(*s != 0){
 634:	eb 1c                	jmp    652 <printf+0xff>
          putc(fd, *s);
 636:	8b 45 f4             	mov    -0xc(%ebp),%eax
 639:	0f b6 00             	movzbl (%eax),%eax
 63c:	0f be c0             	movsbl %al,%eax
 63f:	83 ec 08             	sub    $0x8,%esp
 642:	50                   	push   %eax
 643:	ff 75 08             	pushl  0x8(%ebp)
 646:	e8 31 fe ff ff       	call   47c <putc>
 64b:	83 c4 10             	add    $0x10,%esp
          s++;
 64e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 652:	8b 45 f4             	mov    -0xc(%ebp),%eax
 655:	0f b6 00             	movzbl (%eax),%eax
 658:	84 c0                	test   %al,%al
 65a:	75 da                	jne    636 <printf+0xe3>
 65c:	eb 65                	jmp    6c3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 65e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 662:	75 1d                	jne    681 <printf+0x12e>
        putc(fd, *ap);
 664:	8b 45 e8             	mov    -0x18(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	0f be c0             	movsbl %al,%eax
 66c:	83 ec 08             	sub    $0x8,%esp
 66f:	50                   	push   %eax
 670:	ff 75 08             	pushl  0x8(%ebp)
 673:	e8 04 fe ff ff       	call   47c <putc>
 678:	83 c4 10             	add    $0x10,%esp
        ap++;
 67b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67f:	eb 42                	jmp    6c3 <printf+0x170>
      } else if(c == '%'){
 681:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 685:	75 17                	jne    69e <printf+0x14b>
        putc(fd, c);
 687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68a:	0f be c0             	movsbl %al,%eax
 68d:	83 ec 08             	sub    $0x8,%esp
 690:	50                   	push   %eax
 691:	ff 75 08             	pushl  0x8(%ebp)
 694:	e8 e3 fd ff ff       	call   47c <putc>
 699:	83 c4 10             	add    $0x10,%esp
 69c:	eb 25                	jmp    6c3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 69e:	83 ec 08             	sub    $0x8,%esp
 6a1:	6a 25                	push   $0x25
 6a3:	ff 75 08             	pushl  0x8(%ebp)
 6a6:	e8 d1 fd ff ff       	call   47c <putc>
 6ab:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b1:	0f be c0             	movsbl %al,%eax
 6b4:	83 ec 08             	sub    $0x8,%esp
 6b7:	50                   	push   %eax
 6b8:	ff 75 08             	pushl  0x8(%ebp)
 6bb:	e8 bc fd ff ff       	call   47c <putc>
 6c0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ca:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ce:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d4:	01 d0                	add    %edx,%eax
 6d6:	0f b6 00             	movzbl (%eax),%eax
 6d9:	84 c0                	test   %al,%al
 6db:	0f 85 94 fe ff ff    	jne    575 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6e1:	90                   	nop
 6e2:	c9                   	leave  
 6e3:	c3                   	ret    

000006e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ea:	8b 45 08             	mov    0x8(%ebp),%eax
 6ed:	83 e8 08             	sub    $0x8,%eax
 6f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f3:	a1 ac 0b 00 00       	mov    0xbac,%eax
 6f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6fb:	eb 24                	jmp    721 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 00                	mov    (%eax),%eax
 702:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 705:	77 12                	ja     719 <free+0x35>
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70d:	77 24                	ja     733 <free+0x4f>
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 00                	mov    (%eax),%eax
 714:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 717:	77 1a                	ja     733 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 721:	8b 45 f8             	mov    -0x8(%ebp),%eax
 724:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 727:	76 d4                	jbe    6fd <free+0x19>
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 00                	mov    (%eax),%eax
 72e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 731:	76 ca                	jbe    6fd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	8b 40 04             	mov    0x4(%eax),%eax
 739:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 740:	8b 45 f8             	mov    -0x8(%ebp),%eax
 743:	01 c2                	add    %eax,%edx
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 00                	mov    (%eax),%eax
 74a:	39 c2                	cmp    %eax,%edx
 74c:	75 24                	jne    772 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 74e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 751:	8b 50 04             	mov    0x4(%eax),%edx
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	8b 40 04             	mov    0x4(%eax),%eax
 75c:	01 c2                	add    %eax,%edx
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 00                	mov    (%eax),%eax
 769:	8b 10                	mov    (%eax),%edx
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76e:	89 10                	mov    %edx,(%eax)
 770:	eb 0a                	jmp    77c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 10                	mov    (%eax),%edx
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	8b 40 04             	mov    0x4(%eax),%eax
 782:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	01 d0                	add    %edx,%eax
 78e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 791:	75 20                	jne    7b3 <free+0xcf>
    p->s.size += bp->s.size;
 793:	8b 45 fc             	mov    -0x4(%ebp),%eax
 796:	8b 50 04             	mov    0x4(%eax),%edx
 799:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79c:	8b 40 04             	mov    0x4(%eax),%eax
 79f:	01 c2                	add    %eax,%edx
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	8b 10                	mov    (%eax),%edx
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	89 10                	mov    %edx,(%eax)
 7b1:	eb 08                	jmp    7bb <free+0xd7>
  } else
    p->s.ptr = bp;
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b9:	89 10                	mov    %edx,(%eax)
  freep = p;
 7bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7be:	a3 ac 0b 00 00       	mov    %eax,0xbac
}
 7c3:	90                   	nop
 7c4:	c9                   	leave  
 7c5:	c3                   	ret    

000007c6 <morecore>:

static Header*
morecore(uint nu)
{
 7c6:	55                   	push   %ebp
 7c7:	89 e5                	mov    %esp,%ebp
 7c9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7cc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7d3:	77 07                	ja     7dc <morecore+0x16>
    nu = 4096;
 7d5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7dc:	8b 45 08             	mov    0x8(%ebp),%eax
 7df:	c1 e0 03             	shl    $0x3,%eax
 7e2:	83 ec 0c             	sub    $0xc,%esp
 7e5:	50                   	push   %eax
 7e6:	e8 39 fc ff ff       	call   424 <sbrk>
 7eb:	83 c4 10             	add    $0x10,%esp
 7ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7f1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7f5:	75 07                	jne    7fe <morecore+0x38>
    return 0;
 7f7:	b8 00 00 00 00       	mov    $0x0,%eax
 7fc:	eb 26                	jmp    824 <morecore+0x5e>
  hp = (Header*)p;
 7fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 801:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 804:	8b 45 f0             	mov    -0x10(%ebp),%eax
 807:	8b 55 08             	mov    0x8(%ebp),%edx
 80a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 80d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 810:	83 c0 08             	add    $0x8,%eax
 813:	83 ec 0c             	sub    $0xc,%esp
 816:	50                   	push   %eax
 817:	e8 c8 fe ff ff       	call   6e4 <free>
 81c:	83 c4 10             	add    $0x10,%esp
  return freep;
 81f:	a1 ac 0b 00 00       	mov    0xbac,%eax
}
 824:	c9                   	leave  
 825:	c3                   	ret    

00000826 <malloc>:

void*
malloc(uint nbytes)
{
 826:	55                   	push   %ebp
 827:	89 e5                	mov    %esp,%ebp
 829:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82c:	8b 45 08             	mov    0x8(%ebp),%eax
 82f:	83 c0 07             	add    $0x7,%eax
 832:	c1 e8 03             	shr    $0x3,%eax
 835:	83 c0 01             	add    $0x1,%eax
 838:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 83b:	a1 ac 0b 00 00       	mov    0xbac,%eax
 840:	89 45 f0             	mov    %eax,-0x10(%ebp)
 843:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 847:	75 23                	jne    86c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 849:	c7 45 f0 a4 0b 00 00 	movl   $0xba4,-0x10(%ebp)
 850:	8b 45 f0             	mov    -0x10(%ebp),%eax
 853:	a3 ac 0b 00 00       	mov    %eax,0xbac
 858:	a1 ac 0b 00 00       	mov    0xbac,%eax
 85d:	a3 a4 0b 00 00       	mov    %eax,0xba4
    base.s.size = 0;
 862:	c7 05 a8 0b 00 00 00 	movl   $0x0,0xba8
 869:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86f:	8b 00                	mov    (%eax),%eax
 871:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 874:	8b 45 f4             	mov    -0xc(%ebp),%eax
 877:	8b 40 04             	mov    0x4(%eax),%eax
 87a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87d:	72 4d                	jb     8cc <malloc+0xa6>
      if(p->s.size == nunits)
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	8b 40 04             	mov    0x4(%eax),%eax
 885:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 888:	75 0c                	jne    896 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	8b 10                	mov    (%eax),%edx
 88f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 892:	89 10                	mov    %edx,(%eax)
 894:	eb 26                	jmp    8bc <malloc+0x96>
      else {
        p->s.size -= nunits;
 896:	8b 45 f4             	mov    -0xc(%ebp),%eax
 899:	8b 40 04             	mov    0x4(%eax),%eax
 89c:	2b 45 ec             	sub    -0x14(%ebp),%eax
 89f:	89 c2                	mov    %eax,%edx
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	8b 40 04             	mov    0x4(%eax),%eax
 8ad:	c1 e0 03             	shl    $0x3,%eax
 8b0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8b9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bf:	a3 ac 0b 00 00       	mov    %eax,0xbac
      return (void*)(p + 1);
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	83 c0 08             	add    $0x8,%eax
 8ca:	eb 3b                	jmp    907 <malloc+0xe1>
    }
    if(p == freep)
 8cc:	a1 ac 0b 00 00       	mov    0xbac,%eax
 8d1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8d4:	75 1e                	jne    8f4 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8d6:	83 ec 0c             	sub    $0xc,%esp
 8d9:	ff 75 ec             	pushl  -0x14(%ebp)
 8dc:	e8 e5 fe ff ff       	call   7c6 <morecore>
 8e1:	83 c4 10             	add    $0x10,%esp
 8e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8eb:	75 07                	jne    8f4 <malloc+0xce>
        return 0;
 8ed:	b8 00 00 00 00       	mov    $0x0,%eax
 8f2:	eb 13                	jmp    907 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fd:	8b 00                	mov    (%eax),%eax
 8ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 902:	e9 6d ff ff ff       	jmp    874 <malloc+0x4e>
}
 907:	c9                   	leave  
 908:	c3                   	ret    
