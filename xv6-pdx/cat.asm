
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	pushl  -0xc(%ebp)
   e:	68 80 0c 00 00       	push   $0xc80
  13:	6a 01                	push   $0x1
  15:	e8 3f 04 00 00       	call   459 <write>
  1a:	83 c4 10             	add    $0x10,%esp
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 80 0c 00 00       	push   $0xc80
  2a:	ff 75 08             	pushl  0x8(%ebp)
  2d:	e8 1f 04 00 00       	call   451 <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
    write(1, buf, n);
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 76 09 00 00       	push   $0x976
  4c:	6a 01                	push   $0x1
  4e:	e8 6d 05 00 00       	call   5c0 <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 de 03 00 00       	call   439 <exit>
  }
}
  5b:	90                   	nop
  5c:	c9                   	leave  
  5d:	c3                   	ret    

0000005e <main>:

int
main(int argc, char *argv[])
{
  5e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  62:	83 e4 f0             	and    $0xfffffff0,%esp
  65:	ff 71 fc             	pushl  -0x4(%ecx)
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	53                   	push   %ebx
  6c:	51                   	push   %ecx
  6d:	83 ec 10             	sub    $0x10,%esp
  70:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  72:	83 3b 01             	cmpl   $0x1,(%ebx)
  75:	7f 12                	jg     89 <main+0x2b>
    cat(0);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	6a 00                	push   $0x0
  7c:	e8 7f ff ff ff       	call   0 <cat>
  81:	83 c4 10             	add    $0x10,%esp
    exit();
  84:	e8 b0 03 00 00       	call   439 <exit>
  }

  for(i = 1; i < argc; i++){
  89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  90:	eb 71                	jmp    103 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9c:	8b 43 04             	mov    0x4(%ebx),%eax
  9f:	01 d0                	add    %edx,%eax
  a1:	8b 00                	mov    (%eax),%eax
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	6a 00                	push   $0x0
  a8:	50                   	push   %eax
  a9:	e8 cb 03 00 00       	call   479 <open>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b8:	79 29                	jns    e3 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c4:	8b 43 04             	mov    0x4(%ebx),%eax
  c7:	01 d0                	add    %edx,%eax
  c9:	8b 00                	mov    (%eax),%eax
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	50                   	push   %eax
  cf:	68 87 09 00 00       	push   $0x987
  d4:	6a 01                	push   $0x1
  d6:	e8 e5 04 00 00       	call   5c0 <printf>
  db:	83 c4 10             	add    $0x10,%esp
      exit();
  de:	e8 56 03 00 00       	call   439 <exit>
    }
    cat(fd);
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	ff 75 f0             	pushl  -0x10(%ebp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
  ee:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 f0             	pushl  -0x10(%ebp)
  f7:	e8 65 03 00 00       	call   461 <close>
  fc:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 103:	8b 45 f4             	mov    -0xc(%ebp),%eax
 106:	3b 03                	cmp    (%ebx),%eax
 108:	7c 88                	jl     92 <main+0x34>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 10a:	e8 2a 03 00 00       	call   439 <exit>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	90                   	nop
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 45 08             	mov    0x8(%ebp),%eax
 145:	8d 50 01             	lea    0x1(%eax),%edx
 148:	89 55 08             	mov    %edx,0x8(%ebp)
 14b:	8b 55 0c             	mov    0xc(%ebp),%edx
 14e:	8d 4a 01             	lea    0x1(%edx),%ecx
 151:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c0             	movzbl %al,%eax
 19e:	29 c2                	sub    %eax,%edx
 1a0:	89 d0                	mov    %edx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	ff 75 0c             	pushl  0xc(%ebp)
 1d5:	ff 75 08             	pushl  0x8(%ebp)
 1d8:	e8 32 ff ff ff       	call   10f <stosb>
 1dd:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <strchr>:

char*
strchr(const char *s, char c)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ee:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f1:	eb 14                	jmp    207 <strchr+0x22>
    if(*s == c)
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1fc:	75 05                	jne    203 <strchr+0x1e>
      return (char*)s;
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	eb 13                	jmp    216 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 e2                	jne    1f3 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 211:	b8 00 00 00 00       	mov    $0x0,%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 225:	eb 42                	jmp    269 <gets+0x51>
    cc = read(0, &c, 1);
 227:	83 ec 04             	sub    $0x4,%esp
 22a:	6a 01                	push   $0x1
 22c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22f:	50                   	push   %eax
 230:	6a 00                	push   $0x0
 232:	e8 1a 02 00 00       	call   451 <read>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 241:	7e 33                	jle    276 <gets+0x5e>
      break;
    buf[i++] = c;
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 f4             	mov    %edx,-0xc(%ebp)
 24c:	89 c2                	mov    %eax,%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 c2                	add    %eax,%edx
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 16                	je     277 <gets+0x5f>
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 0e                	je     277 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	83 c0 01             	add    $0x1,%eax
 26f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 272:	7c b3                	jl     227 <gets+0xf>
 274:	eb 01                	jmp    277 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 276:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 277:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <stat>:

int
stat(char *n, struct stat *st)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	6a 00                	push   $0x0
 292:	ff 75 08             	pushl  0x8(%ebp)
 295:	e8 df 01 00 00       	call   479 <open>
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a4:	79 07                	jns    2ad <stat+0x26>
    return -1;
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 25                	jmp    2d2 <stat+0x4b>
  r = fstat(fd, st);
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	ff 75 0c             	pushl  0xc(%ebp)
 2b3:	ff 75 f4             	pushl  -0xc(%ebp)
 2b6:	e8 d6 01 00 00       	call   491 <fstat>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	ff 75 f4             	pushl  -0xc(%ebp)
 2c7:	e8 95 01 00 00       	call   461 <close>
 2cc:	83 c4 10             	add    $0x10,%esp
  return r;
 2cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2e1:	eb 04                	jmp    2e7 <atoi+0x13>
 2e3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	0f b6 00             	movzbl (%eax),%eax
 2ed:	3c 20                	cmp    $0x20,%al
 2ef:	74 f2                	je     2e3 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	0f b6 00             	movzbl (%eax),%eax
 2f7:	3c 2d                	cmp    $0x2d,%al
 2f9:	75 07                	jne    302 <atoi+0x2e>
 2fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 300:	eb 05                	jmp    307 <atoi+0x33>
 302:	b8 01 00 00 00       	mov    $0x1,%eax
 307:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 30a:	8b 45 08             	mov    0x8(%ebp),%eax
 30d:	0f b6 00             	movzbl (%eax),%eax
 310:	3c 2b                	cmp    $0x2b,%al
 312:	74 0a                	je     31e <atoi+0x4a>
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	0f b6 00             	movzbl (%eax),%eax
 31a:	3c 2d                	cmp    $0x2d,%al
 31c:	75 2b                	jne    349 <atoi+0x75>
    s++;
 31e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 322:	eb 25                	jmp    349 <atoi+0x75>
    n = n*10 + *s++ - '0';
 324:	8b 55 fc             	mov    -0x4(%ebp),%edx
 327:	89 d0                	mov    %edx,%eax
 329:	c1 e0 02             	shl    $0x2,%eax
 32c:	01 d0                	add    %edx,%eax
 32e:	01 c0                	add    %eax,%eax
 330:	89 c1                	mov    %eax,%ecx
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	8d 50 01             	lea    0x1(%eax),%edx
 338:	89 55 08             	mov    %edx,0x8(%ebp)
 33b:	0f b6 00             	movzbl (%eax),%eax
 33e:	0f be c0             	movsbl %al,%eax
 341:	01 c8                	add    %ecx,%eax
 343:	83 e8 30             	sub    $0x30,%eax
 346:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	0f b6 00             	movzbl (%eax),%eax
 34f:	3c 2f                	cmp    $0x2f,%al
 351:	7e 0a                	jle    35d <atoi+0x89>
 353:	8b 45 08             	mov    0x8(%ebp),%eax
 356:	0f b6 00             	movzbl (%eax),%eax
 359:	3c 39                	cmp    $0x39,%al
 35b:	7e c7                	jle    324 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 35d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 360:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 364:	c9                   	leave  
 365:	c3                   	ret    

00000366 <atoo>:

int
atoo(const char *s)
{
 366:	55                   	push   %ebp
 367:	89 e5                	mov    %esp,%ebp
 369:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 36c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 373:	eb 04                	jmp    379 <atoo+0x13>
 375:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	0f b6 00             	movzbl (%eax),%eax
 37f:	3c 20                	cmp    $0x20,%al
 381:	74 f2                	je     375 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	0f b6 00             	movzbl (%eax),%eax
 389:	3c 2d                	cmp    $0x2d,%al
 38b:	75 07                	jne    394 <atoo+0x2e>
 38d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 392:	eb 05                	jmp    399 <atoo+0x33>
 394:	b8 01 00 00 00       	mov    $0x1,%eax
 399:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 39c:	8b 45 08             	mov    0x8(%ebp),%eax
 39f:	0f b6 00             	movzbl (%eax),%eax
 3a2:	3c 2b                	cmp    $0x2b,%al
 3a4:	74 0a                	je     3b0 <atoo+0x4a>
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	0f b6 00             	movzbl (%eax),%eax
 3ac:	3c 2d                	cmp    $0x2d,%al
 3ae:	75 27                	jne    3d7 <atoo+0x71>
    s++;
 3b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3b4:	eb 21                	jmp    3d7 <atoo+0x71>
    n = n*8 + *s++ - '0';
 3b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3b9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	8d 50 01             	lea    0x1(%eax),%edx
 3c6:	89 55 08             	mov    %edx,0x8(%ebp)
 3c9:	0f b6 00             	movzbl (%eax),%eax
 3cc:	0f be c0             	movsbl %al,%eax
 3cf:	01 c8                	add    %ecx,%eax
 3d1:	83 e8 30             	sub    $0x30,%eax
 3d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	0f b6 00             	movzbl (%eax),%eax
 3dd:	3c 2f                	cmp    $0x2f,%al
 3df:	7e 0a                	jle    3eb <atoo+0x85>
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	0f b6 00             	movzbl (%eax),%eax
 3e7:	3c 37                	cmp    $0x37,%al
 3e9:	7e cb                	jle    3b6 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ee:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3f2:	c9                   	leave  
 3f3:	c3                   	ret    

000003f4 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3fa:	8b 45 08             	mov    0x8(%ebp),%eax
 3fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 400:	8b 45 0c             	mov    0xc(%ebp),%eax
 403:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 406:	eb 17                	jmp    41f <memmove+0x2b>
    *dst++ = *src++;
 408:	8b 45 fc             	mov    -0x4(%ebp),%eax
 40b:	8d 50 01             	lea    0x1(%eax),%edx
 40e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 411:	8b 55 f8             	mov    -0x8(%ebp),%edx
 414:	8d 4a 01             	lea    0x1(%edx),%ecx
 417:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 41a:	0f b6 12             	movzbl (%edx),%edx
 41d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 41f:	8b 45 10             	mov    0x10(%ebp),%eax
 422:	8d 50 ff             	lea    -0x1(%eax),%edx
 425:	89 55 10             	mov    %edx,0x10(%ebp)
 428:	85 c0                	test   %eax,%eax
 42a:	7f dc                	jg     408 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 42c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 42f:	c9                   	leave  
 430:	c3                   	ret    

00000431 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 431:	b8 01 00 00 00       	mov    $0x1,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <exit>:
SYSCALL(exit)
 439:	b8 02 00 00 00       	mov    $0x2,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <wait>:
SYSCALL(wait)
 441:	b8 03 00 00 00       	mov    $0x3,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <pipe>:
SYSCALL(pipe)
 449:	b8 04 00 00 00       	mov    $0x4,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <read>:
SYSCALL(read)
 451:	b8 05 00 00 00       	mov    $0x5,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <write>:
SYSCALL(write)
 459:	b8 10 00 00 00       	mov    $0x10,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <close>:
SYSCALL(close)
 461:	b8 15 00 00 00       	mov    $0x15,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <kill>:
SYSCALL(kill)
 469:	b8 06 00 00 00       	mov    $0x6,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <exec>:
SYSCALL(exec)
 471:	b8 07 00 00 00       	mov    $0x7,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <open>:
SYSCALL(open)
 479:	b8 0f 00 00 00       	mov    $0xf,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <mknod>:
SYSCALL(mknod)
 481:	b8 11 00 00 00       	mov    $0x11,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <unlink>:
SYSCALL(unlink)
 489:	b8 12 00 00 00       	mov    $0x12,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <fstat>:
SYSCALL(fstat)
 491:	b8 08 00 00 00       	mov    $0x8,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <link>:
SYSCALL(link)
 499:	b8 13 00 00 00       	mov    $0x13,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <mkdir>:
SYSCALL(mkdir)
 4a1:	b8 14 00 00 00       	mov    $0x14,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <chdir>:
SYSCALL(chdir)
 4a9:	b8 09 00 00 00       	mov    $0x9,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <dup>:
SYSCALL(dup)
 4b1:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <getpid>:
SYSCALL(getpid)
 4b9:	b8 0b 00 00 00       	mov    $0xb,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <sbrk>:
SYSCALL(sbrk)
 4c1:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <sleep>:
SYSCALL(sleep)
 4c9:	b8 0d 00 00 00       	mov    $0xd,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <uptime>:
SYSCALL(uptime)
 4d1:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <halt>:
SYSCALL(halt)
 4d9:	b8 16 00 00 00       	mov    $0x16,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <date>:
SYSCALL(date)
 4e1:	b8 17 00 00 00       	mov    $0x17,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4e9:	55                   	push   %ebp
 4ea:	89 e5                	mov    %esp,%ebp
 4ec:	83 ec 18             	sub    $0x18,%esp
 4ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4f5:	83 ec 04             	sub    $0x4,%esp
 4f8:	6a 01                	push   $0x1
 4fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4fd:	50                   	push   %eax
 4fe:	ff 75 08             	pushl  0x8(%ebp)
 501:	e8 53 ff ff ff       	call   459 <write>
 506:	83 c4 10             	add    $0x10,%esp
}
 509:	90                   	nop
 50a:	c9                   	leave  
 50b:	c3                   	ret    

0000050c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 50c:	55                   	push   %ebp
 50d:	89 e5                	mov    %esp,%ebp
 50f:	53                   	push   %ebx
 510:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 513:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 51a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 51e:	74 17                	je     537 <printint+0x2b>
 520:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 524:	79 11                	jns    537 <printint+0x2b>
    neg = 1;
 526:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 52d:	8b 45 0c             	mov    0xc(%ebp),%eax
 530:	f7 d8                	neg    %eax
 532:	89 45 ec             	mov    %eax,-0x14(%ebp)
 535:	eb 06                	jmp    53d <printint+0x31>
  } else {
    x = xx;
 537:	8b 45 0c             	mov    0xc(%ebp),%eax
 53a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 53d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 544:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 547:	8d 41 01             	lea    0x1(%ecx),%eax
 54a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 54d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 550:	8b 45 ec             	mov    -0x14(%ebp),%eax
 553:	ba 00 00 00 00       	mov    $0x0,%edx
 558:	f7 f3                	div    %ebx
 55a:	89 d0                	mov    %edx,%eax
 55c:	0f b6 80 30 0c 00 00 	movzbl 0xc30(%eax),%eax
 563:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 567:	8b 5d 10             	mov    0x10(%ebp),%ebx
 56a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 56d:	ba 00 00 00 00       	mov    $0x0,%edx
 572:	f7 f3                	div    %ebx
 574:	89 45 ec             	mov    %eax,-0x14(%ebp)
 577:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 57b:	75 c7                	jne    544 <printint+0x38>
  if(neg)
 57d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 581:	74 2d                	je     5b0 <printint+0xa4>
    buf[i++] = '-';
 583:	8b 45 f4             	mov    -0xc(%ebp),%eax
 586:	8d 50 01             	lea    0x1(%eax),%edx
 589:	89 55 f4             	mov    %edx,-0xc(%ebp)
 58c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 591:	eb 1d                	jmp    5b0 <printint+0xa4>
    putc(fd, buf[i]);
 593:	8d 55 dc             	lea    -0x24(%ebp),%edx
 596:	8b 45 f4             	mov    -0xc(%ebp),%eax
 599:	01 d0                	add    %edx,%eax
 59b:	0f b6 00             	movzbl (%eax),%eax
 59e:	0f be c0             	movsbl %al,%eax
 5a1:	83 ec 08             	sub    $0x8,%esp
 5a4:	50                   	push   %eax
 5a5:	ff 75 08             	pushl  0x8(%ebp)
 5a8:	e8 3c ff ff ff       	call   4e9 <putc>
 5ad:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5b0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5b8:	79 d9                	jns    593 <printint+0x87>
    putc(fd, buf[i]);
}
 5ba:	90                   	nop
 5bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5be:	c9                   	leave  
 5bf:	c3                   	ret    

000005c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5c6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5cd:	8d 45 0c             	lea    0xc(%ebp),%eax
 5d0:	83 c0 04             	add    $0x4,%eax
 5d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5dd:	e9 59 01 00 00       	jmp    73b <printf+0x17b>
    c = fmt[i] & 0xff;
 5e2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e8:	01 d0                	add    %edx,%eax
 5ea:	0f b6 00             	movzbl (%eax),%eax
 5ed:	0f be c0             	movsbl %al,%eax
 5f0:	25 ff 00 00 00       	and    $0xff,%eax
 5f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5fc:	75 2c                	jne    62a <printf+0x6a>
      if(c == '%'){
 5fe:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 602:	75 0c                	jne    610 <printf+0x50>
        state = '%';
 604:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 60b:	e9 27 01 00 00       	jmp    737 <printf+0x177>
      } else {
        putc(fd, c);
 610:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 613:	0f be c0             	movsbl %al,%eax
 616:	83 ec 08             	sub    $0x8,%esp
 619:	50                   	push   %eax
 61a:	ff 75 08             	pushl  0x8(%ebp)
 61d:	e8 c7 fe ff ff       	call   4e9 <putc>
 622:	83 c4 10             	add    $0x10,%esp
 625:	e9 0d 01 00 00       	jmp    737 <printf+0x177>
      }
    } else if(state == '%'){
 62a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 62e:	0f 85 03 01 00 00    	jne    737 <printf+0x177>
      if(c == 'd'){
 634:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 638:	75 1e                	jne    658 <printf+0x98>
        printint(fd, *ap, 10, 1);
 63a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 63d:	8b 00                	mov    (%eax),%eax
 63f:	6a 01                	push   $0x1
 641:	6a 0a                	push   $0xa
 643:	50                   	push   %eax
 644:	ff 75 08             	pushl  0x8(%ebp)
 647:	e8 c0 fe ff ff       	call   50c <printint>
 64c:	83 c4 10             	add    $0x10,%esp
        ap++;
 64f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 653:	e9 d8 00 00 00       	jmp    730 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 658:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 65c:	74 06                	je     664 <printf+0xa4>
 65e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 662:	75 1e                	jne    682 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 664:	8b 45 e8             	mov    -0x18(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	6a 00                	push   $0x0
 66b:	6a 10                	push   $0x10
 66d:	50                   	push   %eax
 66e:	ff 75 08             	pushl  0x8(%ebp)
 671:	e8 96 fe ff ff       	call   50c <printint>
 676:	83 c4 10             	add    $0x10,%esp
        ap++;
 679:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67d:	e9 ae 00 00 00       	jmp    730 <printf+0x170>
      } else if(c == 's'){
 682:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 686:	75 43                	jne    6cb <printf+0x10b>
        s = (char*)*ap;
 688:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68b:	8b 00                	mov    (%eax),%eax
 68d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 690:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 698:	75 25                	jne    6bf <printf+0xff>
          s = "(null)";
 69a:	c7 45 f4 9c 09 00 00 	movl   $0x99c,-0xc(%ebp)
        while(*s != 0){
 6a1:	eb 1c                	jmp    6bf <printf+0xff>
          putc(fd, *s);
 6a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a6:	0f b6 00             	movzbl (%eax),%eax
 6a9:	0f be c0             	movsbl %al,%eax
 6ac:	83 ec 08             	sub    $0x8,%esp
 6af:	50                   	push   %eax
 6b0:	ff 75 08             	pushl  0x8(%ebp)
 6b3:	e8 31 fe ff ff       	call   4e9 <putc>
 6b8:	83 c4 10             	add    $0x10,%esp
          s++;
 6bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c2:	0f b6 00             	movzbl (%eax),%eax
 6c5:	84 c0                	test   %al,%al
 6c7:	75 da                	jne    6a3 <printf+0xe3>
 6c9:	eb 65                	jmp    730 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6cb:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6cf:	75 1d                	jne    6ee <printf+0x12e>
        putc(fd, *ap);
 6d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	0f be c0             	movsbl %al,%eax
 6d9:	83 ec 08             	sub    $0x8,%esp
 6dc:	50                   	push   %eax
 6dd:	ff 75 08             	pushl  0x8(%ebp)
 6e0:	e8 04 fe ff ff       	call   4e9 <putc>
 6e5:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ec:	eb 42                	jmp    730 <printf+0x170>
      } else if(c == '%'){
 6ee:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6f2:	75 17                	jne    70b <printf+0x14b>
        putc(fd, c);
 6f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f7:	0f be c0             	movsbl %al,%eax
 6fa:	83 ec 08             	sub    $0x8,%esp
 6fd:	50                   	push   %eax
 6fe:	ff 75 08             	pushl  0x8(%ebp)
 701:	e8 e3 fd ff ff       	call   4e9 <putc>
 706:	83 c4 10             	add    $0x10,%esp
 709:	eb 25                	jmp    730 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 70b:	83 ec 08             	sub    $0x8,%esp
 70e:	6a 25                	push   $0x25
 710:	ff 75 08             	pushl  0x8(%ebp)
 713:	e8 d1 fd ff ff       	call   4e9 <putc>
 718:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 71b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71e:	0f be c0             	movsbl %al,%eax
 721:	83 ec 08             	sub    $0x8,%esp
 724:	50                   	push   %eax
 725:	ff 75 08             	pushl  0x8(%ebp)
 728:	e8 bc fd ff ff       	call   4e9 <putc>
 72d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 730:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 737:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 73b:	8b 55 0c             	mov    0xc(%ebp),%edx
 73e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 741:	01 d0                	add    %edx,%eax
 743:	0f b6 00             	movzbl (%eax),%eax
 746:	84 c0                	test   %al,%al
 748:	0f 85 94 fe ff ff    	jne    5e2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 74e:	90                   	nop
 74f:	c9                   	leave  
 750:	c3                   	ret    

00000751 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 751:	55                   	push   %ebp
 752:	89 e5                	mov    %esp,%ebp
 754:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 757:	8b 45 08             	mov    0x8(%ebp),%eax
 75a:	83 e8 08             	sub    $0x8,%eax
 75d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 760:	a1 68 0c 00 00       	mov    0xc68,%eax
 765:	89 45 fc             	mov    %eax,-0x4(%ebp)
 768:	eb 24                	jmp    78e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 76a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76d:	8b 00                	mov    (%eax),%eax
 76f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 772:	77 12                	ja     786 <free+0x35>
 774:	8b 45 f8             	mov    -0x8(%ebp),%eax
 777:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 77a:	77 24                	ja     7a0 <free+0x4f>
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	8b 00                	mov    (%eax),%eax
 781:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 784:	77 1a                	ja     7a0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 786:	8b 45 fc             	mov    -0x4(%ebp),%eax
 789:	8b 00                	mov    (%eax),%eax
 78b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 791:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 794:	76 d4                	jbe    76a <free+0x19>
 796:	8b 45 fc             	mov    -0x4(%ebp),%eax
 799:	8b 00                	mov    (%eax),%eax
 79b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 79e:	76 ca                	jbe    76a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a3:	8b 40 04             	mov    0x4(%eax),%eax
 7a6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b0:	01 c2                	add    %eax,%edx
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	8b 00                	mov    (%eax),%eax
 7b7:	39 c2                	cmp    %eax,%edx
 7b9:	75 24                	jne    7df <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	8b 50 04             	mov    0x4(%eax),%edx
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	8b 40 04             	mov    0x4(%eax),%eax
 7c9:	01 c2                	add    %eax,%edx
 7cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ce:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	8b 10                	mov    (%eax),%edx
 7d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7db:	89 10                	mov    %edx,(%eax)
 7dd:	eb 0a                	jmp    7e9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e2:	8b 10                	mov    (%eax),%edx
 7e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8b 40 04             	mov    0x4(%eax),%eax
 7ef:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f9:	01 d0                	add    %edx,%eax
 7fb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7fe:	75 20                	jne    820 <free+0xcf>
    p->s.size += bp->s.size;
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	8b 50 04             	mov    0x4(%eax),%edx
 806:	8b 45 f8             	mov    -0x8(%ebp),%eax
 809:	8b 40 04             	mov    0x4(%eax),%eax
 80c:	01 c2                	add    %eax,%edx
 80e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 811:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 814:	8b 45 f8             	mov    -0x8(%ebp),%eax
 817:	8b 10                	mov    (%eax),%edx
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	89 10                	mov    %edx,(%eax)
 81e:	eb 08                	jmp    828 <free+0xd7>
  } else
    p->s.ptr = bp;
 820:	8b 45 fc             	mov    -0x4(%ebp),%eax
 823:	8b 55 f8             	mov    -0x8(%ebp),%edx
 826:	89 10                	mov    %edx,(%eax)
  freep = p;
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	a3 68 0c 00 00       	mov    %eax,0xc68
}
 830:	90                   	nop
 831:	c9                   	leave  
 832:	c3                   	ret    

00000833 <morecore>:

static Header*
morecore(uint nu)
{
 833:	55                   	push   %ebp
 834:	89 e5                	mov    %esp,%ebp
 836:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 839:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 840:	77 07                	ja     849 <morecore+0x16>
    nu = 4096;
 842:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 849:	8b 45 08             	mov    0x8(%ebp),%eax
 84c:	c1 e0 03             	shl    $0x3,%eax
 84f:	83 ec 0c             	sub    $0xc,%esp
 852:	50                   	push   %eax
 853:	e8 69 fc ff ff       	call   4c1 <sbrk>
 858:	83 c4 10             	add    $0x10,%esp
 85b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 85e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 862:	75 07                	jne    86b <morecore+0x38>
    return 0;
 864:	b8 00 00 00 00       	mov    $0x0,%eax
 869:	eb 26                	jmp    891 <morecore+0x5e>
  hp = (Header*)p;
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 871:	8b 45 f0             	mov    -0x10(%ebp),%eax
 874:	8b 55 08             	mov    0x8(%ebp),%edx
 877:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 87a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87d:	83 c0 08             	add    $0x8,%eax
 880:	83 ec 0c             	sub    $0xc,%esp
 883:	50                   	push   %eax
 884:	e8 c8 fe ff ff       	call   751 <free>
 889:	83 c4 10             	add    $0x10,%esp
  return freep;
 88c:	a1 68 0c 00 00       	mov    0xc68,%eax
}
 891:	c9                   	leave  
 892:	c3                   	ret    

00000893 <malloc>:

void*
malloc(uint nbytes)
{
 893:	55                   	push   %ebp
 894:	89 e5                	mov    %esp,%ebp
 896:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 899:	8b 45 08             	mov    0x8(%ebp),%eax
 89c:	83 c0 07             	add    $0x7,%eax
 89f:	c1 e8 03             	shr    $0x3,%eax
 8a2:	83 c0 01             	add    $0x1,%eax
 8a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a8:	a1 68 0c 00 00       	mov    0xc68,%eax
 8ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8b4:	75 23                	jne    8d9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8b6:	c7 45 f0 60 0c 00 00 	movl   $0xc60,-0x10(%ebp)
 8bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c0:	a3 68 0c 00 00       	mov    %eax,0xc68
 8c5:	a1 68 0c 00 00       	mov    0xc68,%eax
 8ca:	a3 60 0c 00 00       	mov    %eax,0xc60
    base.s.size = 0;
 8cf:	c7 05 64 0c 00 00 00 	movl   $0x0,0xc64
 8d6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8dc:	8b 00                	mov    (%eax),%eax
 8de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e4:	8b 40 04             	mov    0x4(%eax),%eax
 8e7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ea:	72 4d                	jb     939 <malloc+0xa6>
      if(p->s.size == nunits)
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	8b 40 04             	mov    0x4(%eax),%eax
 8f2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f5:	75 0c                	jne    903 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	8b 10                	mov    (%eax),%edx
 8fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ff:	89 10                	mov    %edx,(%eax)
 901:	eb 26                	jmp    929 <malloc+0x96>
      else {
        p->s.size -= nunits;
 903:	8b 45 f4             	mov    -0xc(%ebp),%eax
 906:	8b 40 04             	mov    0x4(%eax),%eax
 909:	2b 45 ec             	sub    -0x14(%ebp),%eax
 90c:	89 c2                	mov    %eax,%edx
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	8b 40 04             	mov    0x4(%eax),%eax
 91a:	c1 e0 03             	shl    $0x3,%eax
 91d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 920:	8b 45 f4             	mov    -0xc(%ebp),%eax
 923:	8b 55 ec             	mov    -0x14(%ebp),%edx
 926:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 929:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92c:	a3 68 0c 00 00       	mov    %eax,0xc68
      return (void*)(p + 1);
 931:	8b 45 f4             	mov    -0xc(%ebp),%eax
 934:	83 c0 08             	add    $0x8,%eax
 937:	eb 3b                	jmp    974 <malloc+0xe1>
    }
    if(p == freep)
 939:	a1 68 0c 00 00       	mov    0xc68,%eax
 93e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 941:	75 1e                	jne    961 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 943:	83 ec 0c             	sub    $0xc,%esp
 946:	ff 75 ec             	pushl  -0x14(%ebp)
 949:	e8 e5 fe ff ff       	call   833 <morecore>
 94e:	83 c4 10             	add    $0x10,%esp
 951:	89 45 f4             	mov    %eax,-0xc(%ebp)
 954:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 958:	75 07                	jne    961 <malloc+0xce>
        return 0;
 95a:	b8 00 00 00 00       	mov    $0x0,%eax
 95f:	eb 13                	jmp    974 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 961:	8b 45 f4             	mov    -0xc(%ebp),%eax
 964:	89 45 f0             	mov    %eax,-0x10(%ebp)
 967:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96a:	8b 00                	mov    (%eax),%eax
 96c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 96f:	e9 6d ff ff ff       	jmp    8e1 <malloc+0x4e>
}
 974:	c9                   	leave  
 975:	c3                   	ret    
