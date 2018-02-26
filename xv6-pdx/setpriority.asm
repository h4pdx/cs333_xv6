
_setpriority:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"


// set priority from the xv6 shell
int
main(int argc, char* argv[]) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
    if (argc <= 0) {
  14:	83 3b 00             	cmpl   $0x0,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
        printf(1, "Invaid arguments.\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 2e 09 00 00       	push   $0x92e
  21:	6a 01                	push   $0x1
  23:	e8 50 05 00 00       	call   578 <printf>
  28:	83 c4 10             	add    $0x10,%esp
        exit();
  2b:	e8 89 03 00 00       	call   3b9 <exit>
    }
    int i, n, rc;
    i = atoi(argv[1]);
  30:	8b 43 04             	mov    0x4(%ebx),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	50                   	push   %eax
  3c:	e8 13 02 00 00       	call   254 <atoi>
  41:	83 c4 10             	add    $0x10,%esp
  44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    n = atoi(argv[2]);
  47:	8b 43 04             	mov    0x4(%ebx),%eax
  4a:	83 c0 08             	add    $0x8,%eax
  4d:	8b 00                	mov    (%eax),%eax
  4f:	83 ec 0c             	sub    $0xc,%esp
  52:	50                   	push   %eax
  53:	e8 fc 01 00 00       	call   254 <atoi>
  58:	83 c4 10             	add    $0x10,%esp
  5b:	89 45 f0             	mov    %eax,-0x10(%ebp)

    rc = setpriority(i, n);
  5e:	83 ec 08             	sub    $0x8,%esp
  61:	ff 75 f0             	pushl  -0x10(%ebp)
  64:	ff 75 f4             	pushl  -0xc(%ebp)
  67:	e8 2d 04 00 00       	call   499 <setpriority>
  6c:	83 c4 10             	add    $0x10,%esp
  6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (rc < 0) {
  72:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  76:	79 12                	jns    8a <main+0x8a>
        printf(1, "Setpriority failed.\n");
  78:	83 ec 08             	sub    $0x8,%esp
  7b:	68 41 09 00 00       	push   $0x941
  80:	6a 01                	push   $0x1
  82:	e8 f1 04 00 00       	call   578 <printf>
  87:	83 c4 10             	add    $0x10,%esp
    }
    exit();
  8a:	e8 2a 03 00 00       	call   3b9 <exit>

0000008f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	57                   	push   %edi
  93:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  97:	8b 55 10             	mov    0x10(%ebp),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	89 cb                	mov    %ecx,%ebx
  9f:	89 df                	mov    %ebx,%edi
  a1:	89 d1                	mov    %edx,%ecx
  a3:	fc                   	cld    
  a4:	f3 aa                	rep stos %al,%es:(%edi)
  a6:	89 ca                	mov    %ecx,%edx
  a8:	89 fb                	mov    %edi,%ebx
  aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b0:	90                   	nop
  b1:	5b                   	pop    %ebx
  b2:	5f                   	pop    %edi
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c1:	90                   	nop
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	8d 50 01             	lea    0x1(%eax),%edx
  c8:	89 55 08             	mov    %edx,0x8(%ebp)
  cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d4:	0f b6 12             	movzbl (%edx),%edx
  d7:	88 10                	mov    %dl,(%eax)
  d9:	0f b6 00             	movzbl (%eax),%eax
  dc:	84 c0                	test   %al,%al
  de:	75 e2                	jne    c2 <strcpy+0xd>
    ;
  return os;
  e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e3:	c9                   	leave  
  e4:	c3                   	ret    

000000e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e8:	eb 08                	jmp    f2 <strcmp+0xd>
    p++, q++;
  ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	84 c0                	test   %al,%al
  fa:	74 10                	je     10c <strcmp+0x27>
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	0f b6 10             	movzbl (%eax),%edx
 102:	8b 45 0c             	mov    0xc(%ebp),%eax
 105:	0f b6 00             	movzbl (%eax),%eax
 108:	38 c2                	cmp    %al,%dl
 10a:	74 de                	je     ea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	0f b6 00             	movzbl (%eax),%eax
 112:	0f b6 d0             	movzbl %al,%edx
 115:	8b 45 0c             	mov    0xc(%ebp),%eax
 118:	0f b6 00             	movzbl (%eax),%eax
 11b:	0f b6 c0             	movzbl %al,%eax
 11e:	29 c2                	sub    %eax,%edx
 120:	89 d0                	mov    %edx,%eax
}
 122:	5d                   	pop    %ebp
 123:	c3                   	ret    

00000124 <strlen>:

uint
strlen(char *s)
{
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 12a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 131:	eb 04                	jmp    137 <strlen+0x13>
 133:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 137:	8b 55 fc             	mov    -0x4(%ebp),%edx
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	01 d0                	add    %edx,%eax
 13f:	0f b6 00             	movzbl (%eax),%eax
 142:	84 c0                	test   %al,%al
 144:	75 ed                	jne    133 <strlen+0xf>
    ;
  return n;
 146:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <memset>:

void*
memset(void *dst, int c, uint n)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 14e:	8b 45 10             	mov    0x10(%ebp),%eax
 151:	50                   	push   %eax
 152:	ff 75 0c             	pushl  0xc(%ebp)
 155:	ff 75 08             	pushl  0x8(%ebp)
 158:	e8 32 ff ff ff       	call   8f <stosb>
 15d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 160:	8b 45 08             	mov    0x8(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strchr>:

char*
strchr(const char *s, char c)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	83 ec 04             	sub    $0x4,%esp
 16b:	8b 45 0c             	mov    0xc(%ebp),%eax
 16e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 171:	eb 14                	jmp    187 <strchr+0x22>
    if(*s == c)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 00             	movzbl (%eax),%eax
 179:	3a 45 fc             	cmp    -0x4(%ebp),%al
 17c:	75 05                	jne    183 <strchr+0x1e>
      return (char*)s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	eb 13                	jmp    196 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 183:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	84 c0                	test   %al,%al
 18f:	75 e2                	jne    173 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 191:	b8 00 00 00 00       	mov    $0x0,%eax
}
 196:	c9                   	leave  
 197:	c3                   	ret    

00000198 <gets>:

char*
gets(char *buf, int max)
{
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 19e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1a5:	eb 42                	jmp    1e9 <gets+0x51>
    cc = read(0, &c, 1);
 1a7:	83 ec 04             	sub    $0x4,%esp
 1aa:	6a 01                	push   $0x1
 1ac:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1af:	50                   	push   %eax
 1b0:	6a 00                	push   $0x0
 1b2:	e8 1a 02 00 00       	call   3d1 <read>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c1:	7e 33                	jle    1f6 <gets+0x5e>
      break;
    buf[i++] = c;
 1c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c6:	8d 50 01             	lea    0x1(%eax),%edx
 1c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1cc:	89 c2                	mov    %eax,%edx
 1ce:	8b 45 08             	mov    0x8(%ebp),%eax
 1d1:	01 c2                	add    %eax,%edx
 1d3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1d9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1dd:	3c 0a                	cmp    $0xa,%al
 1df:	74 16                	je     1f7 <gets+0x5f>
 1e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e5:	3c 0d                	cmp    $0xd,%al
 1e7:	74 0e                	je     1f7 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ec:	83 c0 01             	add    $0x1,%eax
 1ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1f2:	7c b3                	jl     1a7 <gets+0xf>
 1f4:	eb 01                	jmp    1f7 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
 1fd:	01 d0                	add    %edx,%eax
 1ff:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 202:	8b 45 08             	mov    0x8(%ebp),%eax
}
 205:	c9                   	leave  
 206:	c3                   	ret    

00000207 <stat>:

int
stat(char *n, struct stat *st)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
 20a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 20d:	83 ec 08             	sub    $0x8,%esp
 210:	6a 00                	push   $0x0
 212:	ff 75 08             	pushl  0x8(%ebp)
 215:	e8 df 01 00 00       	call   3f9 <open>
 21a:	83 c4 10             	add    $0x10,%esp
 21d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 220:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 224:	79 07                	jns    22d <stat+0x26>
    return -1;
 226:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22b:	eb 25                	jmp    252 <stat+0x4b>
  r = fstat(fd, st);
 22d:	83 ec 08             	sub    $0x8,%esp
 230:	ff 75 0c             	pushl  0xc(%ebp)
 233:	ff 75 f4             	pushl  -0xc(%ebp)
 236:	e8 d6 01 00 00       	call   411 <fstat>
 23b:	83 c4 10             	add    $0x10,%esp
 23e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 241:	83 ec 0c             	sub    $0xc,%esp
 244:	ff 75 f4             	pushl  -0xc(%ebp)
 247:	e8 95 01 00 00       	call   3e1 <close>
 24c:	83 c4 10             	add    $0x10,%esp
  return r;
 24f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 252:	c9                   	leave  
 253:	c3                   	ret    

00000254 <atoi>:

int
atoi(const char *s)
{
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 25a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 261:	eb 04                	jmp    267 <atoi+0x13>
 263:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	0f b6 00             	movzbl (%eax),%eax
 26d:	3c 20                	cmp    $0x20,%al
 26f:	74 f2                	je     263 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 271:	8b 45 08             	mov    0x8(%ebp),%eax
 274:	0f b6 00             	movzbl (%eax),%eax
 277:	3c 2d                	cmp    $0x2d,%al
 279:	75 07                	jne    282 <atoi+0x2e>
 27b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 280:	eb 05                	jmp    287 <atoi+0x33>
 282:	b8 01 00 00 00       	mov    $0x1,%eax
 287:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	0f b6 00             	movzbl (%eax),%eax
 290:	3c 2b                	cmp    $0x2b,%al
 292:	74 0a                	je     29e <atoi+0x4a>
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	0f b6 00             	movzbl (%eax),%eax
 29a:	3c 2d                	cmp    $0x2d,%al
 29c:	75 2b                	jne    2c9 <atoi+0x75>
    s++;
 29e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2a2:	eb 25                	jmp    2c9 <atoi+0x75>
    n = n*10 + *s++ - '0';
 2a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a7:	89 d0                	mov    %edx,%eax
 2a9:	c1 e0 02             	shl    $0x2,%eax
 2ac:	01 d0                	add    %edx,%eax
 2ae:	01 c0                	add    %eax,%eax
 2b0:	89 c1                	mov    %eax,%ecx
 2b2:	8b 45 08             	mov    0x8(%ebp),%eax
 2b5:	8d 50 01             	lea    0x1(%eax),%edx
 2b8:	89 55 08             	mov    %edx,0x8(%ebp)
 2bb:	0f b6 00             	movzbl (%eax),%eax
 2be:	0f be c0             	movsbl %al,%eax
 2c1:	01 c8                	add    %ecx,%eax
 2c3:	83 e8 30             	sub    $0x30,%eax
 2c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	0f b6 00             	movzbl (%eax),%eax
 2cf:	3c 2f                	cmp    $0x2f,%al
 2d1:	7e 0a                	jle    2dd <atoi+0x89>
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	0f b6 00             	movzbl (%eax),%eax
 2d9:	3c 39                	cmp    $0x39,%al
 2db:	7e c7                	jle    2a4 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2e0:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <atoo>:

int
atoo(const char *s)
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2f3:	eb 04                	jmp    2f9 <atoo+0x13>
 2f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	0f b6 00             	movzbl (%eax),%eax
 2ff:	3c 20                	cmp    $0x20,%al
 301:	74 f2                	je     2f5 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 303:	8b 45 08             	mov    0x8(%ebp),%eax
 306:	0f b6 00             	movzbl (%eax),%eax
 309:	3c 2d                	cmp    $0x2d,%al
 30b:	75 07                	jne    314 <atoo+0x2e>
 30d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 312:	eb 05                	jmp    319 <atoo+0x33>
 314:	b8 01 00 00 00       	mov    $0x1,%eax
 319:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	0f b6 00             	movzbl (%eax),%eax
 322:	3c 2b                	cmp    $0x2b,%al
 324:	74 0a                	je     330 <atoo+0x4a>
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	0f b6 00             	movzbl (%eax),%eax
 32c:	3c 2d                	cmp    $0x2d,%al
 32e:	75 27                	jne    357 <atoo+0x71>
    s++;
 330:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 334:	eb 21                	jmp    357 <atoo+0x71>
    n = n*8 + *s++ - '0';
 336:	8b 45 fc             	mov    -0x4(%ebp),%eax
 339:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	8d 50 01             	lea    0x1(%eax),%edx
 346:	89 55 08             	mov    %edx,0x8(%ebp)
 349:	0f b6 00             	movzbl (%eax),%eax
 34c:	0f be c0             	movsbl %al,%eax
 34f:	01 c8                	add    %ecx,%eax
 351:	83 e8 30             	sub    $0x30,%eax
 354:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	0f b6 00             	movzbl (%eax),%eax
 35d:	3c 2f                	cmp    $0x2f,%al
 35f:	7e 0a                	jle    36b <atoo+0x85>
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	0f b6 00             	movzbl (%eax),%eax
 367:	3c 37                	cmp    $0x37,%al
 369:	7e cb                	jle    336 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 36b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 36e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 372:	c9                   	leave  
 373:	c3                   	ret    

00000374 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 37a:	8b 45 08             	mov    0x8(%ebp),%eax
 37d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 380:	8b 45 0c             	mov    0xc(%ebp),%eax
 383:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 386:	eb 17                	jmp    39f <memmove+0x2b>
    *dst++ = *src++;
 388:	8b 45 fc             	mov    -0x4(%ebp),%eax
 38b:	8d 50 01             	lea    0x1(%eax),%edx
 38e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 391:	8b 55 f8             	mov    -0x8(%ebp),%edx
 394:	8d 4a 01             	lea    0x1(%edx),%ecx
 397:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 39a:	0f b6 12             	movzbl (%edx),%edx
 39d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 39f:	8b 45 10             	mov    0x10(%ebp),%eax
 3a2:	8d 50 ff             	lea    -0x1(%eax),%edx
 3a5:	89 55 10             	mov    %edx,0x10(%ebp)
 3a8:	85 c0                	test   %eax,%eax
 3aa:	7f dc                	jg     388 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3af:	c9                   	leave  
 3b0:	c3                   	ret    

000003b1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3b1:	b8 01 00 00 00       	mov    $0x1,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <exit>:
SYSCALL(exit)
 3b9:	b8 02 00 00 00       	mov    $0x2,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <wait>:
SYSCALL(wait)
 3c1:	b8 03 00 00 00       	mov    $0x3,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <pipe>:
SYSCALL(pipe)
 3c9:	b8 04 00 00 00       	mov    $0x4,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <read>:
SYSCALL(read)
 3d1:	b8 05 00 00 00       	mov    $0x5,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <write>:
SYSCALL(write)
 3d9:	b8 10 00 00 00       	mov    $0x10,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <close>:
SYSCALL(close)
 3e1:	b8 15 00 00 00       	mov    $0x15,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <kill>:
SYSCALL(kill)
 3e9:	b8 06 00 00 00       	mov    $0x6,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <exec>:
SYSCALL(exec)
 3f1:	b8 07 00 00 00       	mov    $0x7,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <open>:
SYSCALL(open)
 3f9:	b8 0f 00 00 00       	mov    $0xf,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <mknod>:
SYSCALL(mknod)
 401:	b8 11 00 00 00       	mov    $0x11,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <unlink>:
SYSCALL(unlink)
 409:	b8 12 00 00 00       	mov    $0x12,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <fstat>:
SYSCALL(fstat)
 411:	b8 08 00 00 00       	mov    $0x8,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <link>:
SYSCALL(link)
 419:	b8 13 00 00 00       	mov    $0x13,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <mkdir>:
SYSCALL(mkdir)
 421:	b8 14 00 00 00       	mov    $0x14,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <chdir>:
SYSCALL(chdir)
 429:	b8 09 00 00 00       	mov    $0x9,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <dup>:
SYSCALL(dup)
 431:	b8 0a 00 00 00       	mov    $0xa,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <getpid>:
SYSCALL(getpid)
 439:	b8 0b 00 00 00       	mov    $0xb,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <sbrk>:
SYSCALL(sbrk)
 441:	b8 0c 00 00 00       	mov    $0xc,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <sleep>:
SYSCALL(sleep)
 449:	b8 0d 00 00 00       	mov    $0xd,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <uptime>:
SYSCALL(uptime)
 451:	b8 0e 00 00 00       	mov    $0xe,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <halt>:
SYSCALL(halt)
 459:	b8 16 00 00 00       	mov    $0x16,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <date>:
SYSCALL(date)
 461:	b8 17 00 00 00       	mov    $0x17,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <getuid>:
SYSCALL(getuid)
 469:	b8 18 00 00 00       	mov    $0x18,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <getgid>:
SYSCALL(getgid)
 471:	b8 19 00 00 00       	mov    $0x19,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <getppid>:
SYSCALL(getppid)
 479:	b8 1a 00 00 00       	mov    $0x1a,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <setuid>:
SYSCALL(setuid)
 481:	b8 1b 00 00 00       	mov    $0x1b,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <setgid>:
SYSCALL(setgid)
 489:	b8 1c 00 00 00       	mov    $0x1c,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <getprocs>:
SYSCALL(getprocs)
 491:	b8 1d 00 00 00       	mov    $0x1d,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <setpriority>:
SYSCALL(setpriority)
 499:	b8 1e 00 00 00       	mov    $0x1e,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a1:	55                   	push   %ebp
 4a2:	89 e5                	mov    %esp,%ebp
 4a4:	83 ec 18             	sub    $0x18,%esp
 4a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4aa:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ad:	83 ec 04             	sub    $0x4,%esp
 4b0:	6a 01                	push   $0x1
 4b2:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b5:	50                   	push   %eax
 4b6:	ff 75 08             	pushl  0x8(%ebp)
 4b9:	e8 1b ff ff ff       	call   3d9 <write>
 4be:	83 c4 10             	add    $0x10,%esp
}
 4c1:	90                   	nop
 4c2:	c9                   	leave  
 4c3:	c3                   	ret    

000004c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	53                   	push   %ebx
 4c8:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4d2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4d6:	74 17                	je     4ef <printint+0x2b>
 4d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4dc:	79 11                	jns    4ef <printint+0x2b>
    neg = 1;
 4de:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e8:	f7 d8                	neg    %eax
 4ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ed:	eb 06                	jmp    4f5 <printint+0x31>
  } else {
    x = xx;
 4ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4fc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4ff:	8d 41 01             	lea    0x1(%ecx),%eax
 502:	89 45 f4             	mov    %eax,-0xc(%ebp)
 505:	8b 5d 10             	mov    0x10(%ebp),%ebx
 508:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50b:	ba 00 00 00 00       	mov    $0x0,%edx
 510:	f7 f3                	div    %ebx
 512:	89 d0                	mov    %edx,%eax
 514:	0f b6 80 cc 0b 00 00 	movzbl 0xbcc(%eax),%eax
 51b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 51f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 522:	8b 45 ec             	mov    -0x14(%ebp),%eax
 525:	ba 00 00 00 00       	mov    $0x0,%edx
 52a:	f7 f3                	div    %ebx
 52c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 52f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 533:	75 c7                	jne    4fc <printint+0x38>
  if(neg)
 535:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 539:	74 2d                	je     568 <printint+0xa4>
    buf[i++] = '-';
 53b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53e:	8d 50 01             	lea    0x1(%eax),%edx
 541:	89 55 f4             	mov    %edx,-0xc(%ebp)
 544:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 549:	eb 1d                	jmp    568 <printint+0xa4>
    putc(fd, buf[i]);
 54b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 551:	01 d0                	add    %edx,%eax
 553:	0f b6 00             	movzbl (%eax),%eax
 556:	0f be c0             	movsbl %al,%eax
 559:	83 ec 08             	sub    $0x8,%esp
 55c:	50                   	push   %eax
 55d:	ff 75 08             	pushl  0x8(%ebp)
 560:	e8 3c ff ff ff       	call   4a1 <putc>
 565:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 568:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 56c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 570:	79 d9                	jns    54b <printint+0x87>
    putc(fd, buf[i]);
}
 572:	90                   	nop
 573:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 576:	c9                   	leave  
 577:	c3                   	ret    

00000578 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 578:	55                   	push   %ebp
 579:	89 e5                	mov    %esp,%ebp
 57b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 57e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 585:	8d 45 0c             	lea    0xc(%ebp),%eax
 588:	83 c0 04             	add    $0x4,%eax
 58b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 58e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 595:	e9 59 01 00 00       	jmp    6f3 <printf+0x17b>
    c = fmt[i] & 0xff;
 59a:	8b 55 0c             	mov    0xc(%ebp),%edx
 59d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a0:	01 d0                	add    %edx,%eax
 5a2:	0f b6 00             	movzbl (%eax),%eax
 5a5:	0f be c0             	movsbl %al,%eax
 5a8:	25 ff 00 00 00       	and    $0xff,%eax
 5ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5b4:	75 2c                	jne    5e2 <printf+0x6a>
      if(c == '%'){
 5b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ba:	75 0c                	jne    5c8 <printf+0x50>
        state = '%';
 5bc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5c3:	e9 27 01 00 00       	jmp    6ef <printf+0x177>
      } else {
        putc(fd, c);
 5c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5cb:	0f be c0             	movsbl %al,%eax
 5ce:	83 ec 08             	sub    $0x8,%esp
 5d1:	50                   	push   %eax
 5d2:	ff 75 08             	pushl  0x8(%ebp)
 5d5:	e8 c7 fe ff ff       	call   4a1 <putc>
 5da:	83 c4 10             	add    $0x10,%esp
 5dd:	e9 0d 01 00 00       	jmp    6ef <printf+0x177>
      }
    } else if(state == '%'){
 5e2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5e6:	0f 85 03 01 00 00    	jne    6ef <printf+0x177>
      if(c == 'd'){
 5ec:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f0:	75 1e                	jne    610 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5f5:	8b 00                	mov    (%eax),%eax
 5f7:	6a 01                	push   $0x1
 5f9:	6a 0a                	push   $0xa
 5fb:	50                   	push   %eax
 5fc:	ff 75 08             	pushl  0x8(%ebp)
 5ff:	e8 c0 fe ff ff       	call   4c4 <printint>
 604:	83 c4 10             	add    $0x10,%esp
        ap++;
 607:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60b:	e9 d8 00 00 00       	jmp    6e8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 610:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 614:	74 06                	je     61c <printf+0xa4>
 616:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 61a:	75 1e                	jne    63a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 61c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	6a 00                	push   $0x0
 623:	6a 10                	push   $0x10
 625:	50                   	push   %eax
 626:	ff 75 08             	pushl  0x8(%ebp)
 629:	e8 96 fe ff ff       	call   4c4 <printint>
 62e:	83 c4 10             	add    $0x10,%esp
        ap++;
 631:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 635:	e9 ae 00 00 00       	jmp    6e8 <printf+0x170>
      } else if(c == 's'){
 63a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 63e:	75 43                	jne    683 <printf+0x10b>
        s = (char*)*ap;
 640:	8b 45 e8             	mov    -0x18(%ebp),%eax
 643:	8b 00                	mov    (%eax),%eax
 645:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 648:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 64c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 650:	75 25                	jne    677 <printf+0xff>
          s = "(null)";
 652:	c7 45 f4 56 09 00 00 	movl   $0x956,-0xc(%ebp)
        while(*s != 0){
 659:	eb 1c                	jmp    677 <printf+0xff>
          putc(fd, *s);
 65b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65e:	0f b6 00             	movzbl (%eax),%eax
 661:	0f be c0             	movsbl %al,%eax
 664:	83 ec 08             	sub    $0x8,%esp
 667:	50                   	push   %eax
 668:	ff 75 08             	pushl  0x8(%ebp)
 66b:	e8 31 fe ff ff       	call   4a1 <putc>
 670:	83 c4 10             	add    $0x10,%esp
          s++;
 673:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 677:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67a:	0f b6 00             	movzbl (%eax),%eax
 67d:	84 c0                	test   %al,%al
 67f:	75 da                	jne    65b <printf+0xe3>
 681:	eb 65                	jmp    6e8 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 683:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 687:	75 1d                	jne    6a6 <printf+0x12e>
        putc(fd, *ap);
 689:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	0f be c0             	movsbl %al,%eax
 691:	83 ec 08             	sub    $0x8,%esp
 694:	50                   	push   %eax
 695:	ff 75 08             	pushl  0x8(%ebp)
 698:	e8 04 fe ff ff       	call   4a1 <putc>
 69d:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a4:	eb 42                	jmp    6e8 <printf+0x170>
      } else if(c == '%'){
 6a6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6aa:	75 17                	jne    6c3 <printf+0x14b>
        putc(fd, c);
 6ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6af:	0f be c0             	movsbl %al,%eax
 6b2:	83 ec 08             	sub    $0x8,%esp
 6b5:	50                   	push   %eax
 6b6:	ff 75 08             	pushl  0x8(%ebp)
 6b9:	e8 e3 fd ff ff       	call   4a1 <putc>
 6be:	83 c4 10             	add    $0x10,%esp
 6c1:	eb 25                	jmp    6e8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c3:	83 ec 08             	sub    $0x8,%esp
 6c6:	6a 25                	push   $0x25
 6c8:	ff 75 08             	pushl  0x8(%ebp)
 6cb:	e8 d1 fd ff ff       	call   4a1 <putc>
 6d0:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d6:	0f be c0             	movsbl %al,%eax
 6d9:	83 ec 08             	sub    $0x8,%esp
 6dc:	50                   	push   %eax
 6dd:	ff 75 08             	pushl  0x8(%ebp)
 6e0:	e8 bc fd ff ff       	call   4a1 <putc>
 6e5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ef:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6f3:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f9:	01 d0                	add    %edx,%eax
 6fb:	0f b6 00             	movzbl (%eax),%eax
 6fe:	84 c0                	test   %al,%al
 700:	0f 85 94 fe ff ff    	jne    59a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 706:	90                   	nop
 707:	c9                   	leave  
 708:	c3                   	ret    

00000709 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 70f:	8b 45 08             	mov    0x8(%ebp),%eax
 712:	83 e8 08             	sub    $0x8,%eax
 715:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 718:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 71d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 720:	eb 24                	jmp    746 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 722:	8b 45 fc             	mov    -0x4(%ebp),%eax
 725:	8b 00                	mov    (%eax),%eax
 727:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72a:	77 12                	ja     73e <free+0x35>
 72c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 732:	77 24                	ja     758 <free+0x4f>
 734:	8b 45 fc             	mov    -0x4(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73c:	77 1a                	ja     758 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 741:	8b 00                	mov    (%eax),%eax
 743:	89 45 fc             	mov    %eax,-0x4(%ebp)
 746:	8b 45 f8             	mov    -0x8(%ebp),%eax
 749:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74c:	76 d4                	jbe    722 <free+0x19>
 74e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 751:	8b 00                	mov    (%eax),%eax
 753:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 756:	76 ca                	jbe    722 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 758:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75b:	8b 40 04             	mov    0x4(%eax),%eax
 75e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	01 c2                	add    %eax,%edx
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	8b 00                	mov    (%eax),%eax
 76f:	39 c2                	cmp    %eax,%edx
 771:	75 24                	jne    797 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	8b 50 04             	mov    0x4(%eax),%edx
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	8b 40 04             	mov    0x4(%eax),%eax
 781:	01 c2                	add    %eax,%edx
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 00                	mov    (%eax),%eax
 78e:	8b 10                	mov    (%eax),%edx
 790:	8b 45 f8             	mov    -0x8(%ebp),%eax
 793:	89 10                	mov    %edx,(%eax)
 795:	eb 0a                	jmp    7a1 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	8b 10                	mov    (%eax),%edx
 79c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 40 04             	mov    0x4(%eax),%eax
 7a7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	01 d0                	add    %edx,%eax
 7b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b6:	75 20                	jne    7d8 <free+0xcf>
    p->s.size += bp->s.size;
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 50 04             	mov    0x4(%eax),%edx
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	8b 40 04             	mov    0x4(%eax),%eax
 7c4:	01 c2                	add    %eax,%edx
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cf:	8b 10                	mov    (%eax),%edx
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	89 10                	mov    %edx,(%eax)
 7d6:	eb 08                	jmp    7e0 <free+0xd7>
  } else
    p->s.ptr = bp;
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7de:	89 10                	mov    %edx,(%eax)
  freep = p;
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	a3 e8 0b 00 00       	mov    %eax,0xbe8
}
 7e8:	90                   	nop
 7e9:	c9                   	leave  
 7ea:	c3                   	ret    

000007eb <morecore>:

static Header*
morecore(uint nu)
{
 7eb:	55                   	push   %ebp
 7ec:	89 e5                	mov    %esp,%ebp
 7ee:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7f1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7f8:	77 07                	ja     801 <morecore+0x16>
    nu = 4096;
 7fa:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 801:	8b 45 08             	mov    0x8(%ebp),%eax
 804:	c1 e0 03             	shl    $0x3,%eax
 807:	83 ec 0c             	sub    $0xc,%esp
 80a:	50                   	push   %eax
 80b:	e8 31 fc ff ff       	call   441 <sbrk>
 810:	83 c4 10             	add    $0x10,%esp
 813:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 816:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 81a:	75 07                	jne    823 <morecore+0x38>
    return 0;
 81c:	b8 00 00 00 00       	mov    $0x0,%eax
 821:	eb 26                	jmp    849 <morecore+0x5e>
  hp = (Header*)p;
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 829:	8b 45 f0             	mov    -0x10(%ebp),%eax
 82c:	8b 55 08             	mov    0x8(%ebp),%edx
 82f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 832:	8b 45 f0             	mov    -0x10(%ebp),%eax
 835:	83 c0 08             	add    $0x8,%eax
 838:	83 ec 0c             	sub    $0xc,%esp
 83b:	50                   	push   %eax
 83c:	e8 c8 fe ff ff       	call   709 <free>
 841:	83 c4 10             	add    $0x10,%esp
  return freep;
 844:	a1 e8 0b 00 00       	mov    0xbe8,%eax
}
 849:	c9                   	leave  
 84a:	c3                   	ret    

0000084b <malloc>:

void*
malloc(uint nbytes)
{
 84b:	55                   	push   %ebp
 84c:	89 e5                	mov    %esp,%ebp
 84e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 851:	8b 45 08             	mov    0x8(%ebp),%eax
 854:	83 c0 07             	add    $0x7,%eax
 857:	c1 e8 03             	shr    $0x3,%eax
 85a:	83 c0 01             	add    $0x1,%eax
 85d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 860:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 865:	89 45 f0             	mov    %eax,-0x10(%ebp)
 868:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 86c:	75 23                	jne    891 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 86e:	c7 45 f0 e0 0b 00 00 	movl   $0xbe0,-0x10(%ebp)
 875:	8b 45 f0             	mov    -0x10(%ebp),%eax
 878:	a3 e8 0b 00 00       	mov    %eax,0xbe8
 87d:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 882:	a3 e0 0b 00 00       	mov    %eax,0xbe0
    base.s.size = 0;
 887:	c7 05 e4 0b 00 00 00 	movl   $0x0,0xbe4
 88e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 891:	8b 45 f0             	mov    -0x10(%ebp),%eax
 894:	8b 00                	mov    (%eax),%eax
 896:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 899:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89c:	8b 40 04             	mov    0x4(%eax),%eax
 89f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8a2:	72 4d                	jb     8f1 <malloc+0xa6>
      if(p->s.size == nunits)
 8a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a7:	8b 40 04             	mov    0x4(%eax),%eax
 8aa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ad:	75 0c                	jne    8bb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b2:	8b 10                	mov    (%eax),%edx
 8b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b7:	89 10                	mov    %edx,(%eax)
 8b9:	eb 26                	jmp    8e1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	8b 40 04             	mov    0x4(%eax),%eax
 8c1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8c4:	89 c2                	mov    %eax,%edx
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cf:	8b 40 04             	mov    0x4(%eax),%eax
 8d2:	c1 e0 03             	shl    $0x3,%eax
 8d5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8db:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8de:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e4:	a3 e8 0b 00 00       	mov    %eax,0xbe8
      return (void*)(p + 1);
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	83 c0 08             	add    $0x8,%eax
 8ef:	eb 3b                	jmp    92c <malloc+0xe1>
    }
    if(p == freep)
 8f1:	a1 e8 0b 00 00       	mov    0xbe8,%eax
 8f6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8f9:	75 1e                	jne    919 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8fb:	83 ec 0c             	sub    $0xc,%esp
 8fe:	ff 75 ec             	pushl  -0x14(%ebp)
 901:	e8 e5 fe ff ff       	call   7eb <morecore>
 906:	83 c4 10             	add    $0x10,%esp
 909:	89 45 f4             	mov    %eax,-0xc(%ebp)
 90c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 910:	75 07                	jne    919 <malloc+0xce>
        return 0;
 912:	b8 00 00 00 00       	mov    $0x0,%eax
 917:	eb 13                	jmp    92c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 919:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	8b 00                	mov    (%eax),%eax
 924:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 927:	e9 6d ff ff ff       	jmp    899 <malloc+0x4e>
}
 92c:	c9                   	leave  
 92d:	c3                   	ret    
