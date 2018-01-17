
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  11:	83 ec 08             	sub    $0x8,%esp
  14:	6a 02                	push   $0x2
  16:	68 6b 09 00 00       	push   $0x96b
  1b:	e8 4b 04 00 00       	call   46b <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 6b 09 00 00       	push   $0x96b
  33:	e8 3b 04 00 00       	call   473 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 6b 09 00 00       	push   $0x96b
  45:	e8 21 04 00 00       	call   46b <open>
  4a:	83 c4 10             	add    $0x10,%esp
  }
  dup(0);  // stdout
  4d:	83 ec 0c             	sub    $0xc,%esp
  50:	6a 00                	push   $0x0
  52:	e8 4c 04 00 00       	call   4a3 <dup>
  57:	83 c4 10             	add    $0x10,%esp
  dup(0);  // stderr
  5a:	83 ec 0c             	sub    $0xc,%esp
  5d:	6a 00                	push   $0x0
  5f:	e8 3f 04 00 00       	call   4a3 <dup>
  64:	83 c4 10             	add    $0x10,%esp

  for(;;){
    printf(1, "init: starting sh\n");
  67:	83 ec 08             	sub    $0x8,%esp
  6a:	68 73 09 00 00       	push   $0x973
  6f:	6a 01                	push   $0x1
  71:	e8 3c 05 00 00       	call   5b2 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 a5 03 00 00       	call   423 <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 86 09 00 00       	push   $0x986
  8f:	6a 01                	push   $0x1
  91:	e8 1c 05 00 00       	call   5b2 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 8d 03 00 00       	call   42b <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 28 0c 00 00       	push   $0xc28
  ac:	68 68 09 00 00       	push   $0x968
  b1:	e8 ad 03 00 00       	call   463 <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 99 09 00 00       	push   $0x999
  c1:	6a 01                	push   $0x1
  c3:	e8 ea 04 00 00       	call   5b2 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 5b 03 00 00       	call   42b <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 af 09 00 00       	push   $0x9af
  d8:	6a 01                	push   $0x1
  da:	e8 d3 04 00 00       	call   5b2 <printf>
  df:	83 c4 10             	add    $0x10,%esp
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  e2:	e8 4c 03 00 00       	call   433 <wait>
  e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  ee:	0f 88 73 ff ff ff    	js     67 <main+0x67>
  f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  fa:	75 d4                	jne    d0 <main+0xd0>
      printf(1, "zombie!\n");
  }
  fc:	e9 66 ff ff ff       	jmp    67 <main+0x67>

00000101 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 101:	55                   	push   %ebp
 102:	89 e5                	mov    %esp,%ebp
 104:	57                   	push   %edi
 105:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 106:	8b 4d 08             	mov    0x8(%ebp),%ecx
 109:	8b 55 10             	mov    0x10(%ebp),%edx
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	89 cb                	mov    %ecx,%ebx
 111:	89 df                	mov    %ebx,%edi
 113:	89 d1                	mov    %edx,%ecx
 115:	fc                   	cld    
 116:	f3 aa                	rep stos %al,%es:(%edi)
 118:	89 ca                	mov    %ecx,%edx
 11a:	89 fb                	mov    %edi,%ebx
 11c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 122:	90                   	nop
 123:	5b                   	pop    %ebx
 124:	5f                   	pop    %edi
 125:	5d                   	pop    %ebp
 126:	c3                   	ret    

00000127 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12d:	8b 45 08             	mov    0x8(%ebp),%eax
 130:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 133:	90                   	nop
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	8d 50 01             	lea    0x1(%eax),%edx
 13a:	89 55 08             	mov    %edx,0x8(%ebp)
 13d:	8b 55 0c             	mov    0xc(%ebp),%edx
 140:	8d 4a 01             	lea    0x1(%edx),%ecx
 143:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 146:	0f b6 12             	movzbl (%edx),%edx
 149:	88 10                	mov    %dl,(%eax)
 14b:	0f b6 00             	movzbl (%eax),%eax
 14e:	84 c0                	test   %al,%al
 150:	75 e2                	jne    134 <strcpy+0xd>
    ;
  return os;
 152:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 155:	c9                   	leave  
 156:	c3                   	ret    

00000157 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 15a:	eb 08                	jmp    164 <strcmp+0xd>
    p++, q++;
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	84 c0                	test   %al,%al
 16c:	74 10                	je     17e <strcmp+0x27>
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 10             	movzbl (%eax),%edx
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	38 c2                	cmp    %al,%dl
 17c:	74 de                	je     15c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	0f b6 d0             	movzbl %al,%edx
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	0f b6 00             	movzbl (%eax),%eax
 18d:	0f b6 c0             	movzbl %al,%eax
 190:	29 c2                	sub    %eax,%edx
 192:	89 d0                	mov    %edx,%eax
}
 194:	5d                   	pop    %ebp
 195:	c3                   	ret    

00000196 <strlen>:

uint
strlen(char *s)
{
 196:	55                   	push   %ebp
 197:	89 e5                	mov    %esp,%ebp
 199:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a3:	eb 04                	jmp    1a9 <strlen+0x13>
 1a5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 d0                	add    %edx,%eax
 1b1:	0f b6 00             	movzbl (%eax),%eax
 1b4:	84 c0                	test   %al,%al
 1b6:	75 ed                	jne    1a5 <strlen+0xf>
    ;
  return n;
 1b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c0:	8b 45 10             	mov    0x10(%ebp),%eax
 1c3:	50                   	push   %eax
 1c4:	ff 75 0c             	pushl  0xc(%ebp)
 1c7:	ff 75 08             	pushl  0x8(%ebp)
 1ca:	e8 32 ff ff ff       	call   101 <stosb>
 1cf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <strchr>:

char*
strchr(const char *s, char c)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e3:	eb 14                	jmp    1f9 <strchr+0x22>
    if(*s == c)
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	0f b6 00             	movzbl (%eax),%eax
 1eb:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ee:	75 05                	jne    1f5 <strchr+0x1e>
      return (char*)s;
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	eb 13                	jmp    208 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f9:	8b 45 08             	mov    0x8(%ebp),%eax
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 203:	b8 00 00 00 00       	mov    $0x0,%eax
}
 208:	c9                   	leave  
 209:	c3                   	ret    

0000020a <gets>:

char*
gets(char *buf, int max)
{
 20a:	55                   	push   %ebp
 20b:	89 e5                	mov    %esp,%ebp
 20d:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 217:	eb 42                	jmp    25b <gets+0x51>
    cc = read(0, &c, 1);
 219:	83 ec 04             	sub    $0x4,%esp
 21c:	6a 01                	push   $0x1
 21e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 221:	50                   	push   %eax
 222:	6a 00                	push   $0x0
 224:	e8 1a 02 00 00       	call   443 <read>
 229:	83 c4 10             	add    $0x10,%esp
 22c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 233:	7e 33                	jle    268 <gets+0x5e>
      break;
    buf[i++] = c;
 235:	8b 45 f4             	mov    -0xc(%ebp),%eax
 238:	8d 50 01             	lea    0x1(%eax),%edx
 23b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23e:	89 c2                	mov    %eax,%edx
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	01 c2                	add    %eax,%edx
 245:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 249:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 24b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24f:	3c 0a                	cmp    $0xa,%al
 251:	74 16                	je     269 <gets+0x5f>
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	3c 0d                	cmp    $0xd,%al
 259:	74 0e                	je     269 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25e:	83 c0 01             	add    $0x1,%eax
 261:	3b 45 0c             	cmp    0xc(%ebp),%eax
 264:	7c b3                	jl     219 <gets+0xf>
 266:	eb 01                	jmp    269 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 268:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 269:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	01 d0                	add    %edx,%eax
 271:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 274:	8b 45 08             	mov    0x8(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <stat>:

int
stat(char *n, struct stat *st)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	6a 00                	push   $0x0
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 df 01 00 00       	call   46b <open>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 292:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 296:	79 07                	jns    29f <stat+0x26>
    return -1;
 298:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29d:	eb 25                	jmp    2c4 <stat+0x4b>
  r = fstat(fd, st);
 29f:	83 ec 08             	sub    $0x8,%esp
 2a2:	ff 75 0c             	pushl  0xc(%ebp)
 2a5:	ff 75 f4             	pushl  -0xc(%ebp)
 2a8:	e8 d6 01 00 00       	call   483 <fstat>
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b3:	83 ec 0c             	sub    $0xc,%esp
 2b6:	ff 75 f4             	pushl  -0xc(%ebp)
 2b9:	e8 95 01 00 00       	call   453 <close>
 2be:	83 c4 10             	add    $0x10,%esp
  return r;
 2c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <atoi>:

int
atoi(const char *s)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2d3:	eb 04                	jmp    2d9 <atoi+0x13>
 2d5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 20                	cmp    $0x20,%al
 2e1:	74 f2                	je     2d5 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	3c 2d                	cmp    $0x2d,%al
 2eb:	75 07                	jne    2f4 <atoi+0x2e>
 2ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f2:	eb 05                	jmp    2f9 <atoi+0x33>
 2f4:	b8 01 00 00 00       	mov    $0x1,%eax
 2f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 00             	movzbl (%eax),%eax
 302:	3c 2b                	cmp    $0x2b,%al
 304:	74 0a                	je     310 <atoi+0x4a>
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	0f b6 00             	movzbl (%eax),%eax
 30c:	3c 2d                	cmp    $0x2d,%al
 30e:	75 2b                	jne    33b <atoi+0x75>
    s++;
 310:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 314:	eb 25                	jmp    33b <atoi+0x75>
    n = n*10 + *s++ - '0';
 316:	8b 55 fc             	mov    -0x4(%ebp),%edx
 319:	89 d0                	mov    %edx,%eax
 31b:	c1 e0 02             	shl    $0x2,%eax
 31e:	01 d0                	add    %edx,%eax
 320:	01 c0                	add    %eax,%eax
 322:	89 c1                	mov    %eax,%ecx
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	8d 50 01             	lea    0x1(%eax),%edx
 32a:	89 55 08             	mov    %edx,0x8(%ebp)
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	0f be c0             	movsbl %al,%eax
 333:	01 c8                	add    %ecx,%eax
 335:	83 e8 30             	sub    $0x30,%eax
 338:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	0f b6 00             	movzbl (%eax),%eax
 341:	3c 2f                	cmp    $0x2f,%al
 343:	7e 0a                	jle    34f <atoi+0x89>
 345:	8b 45 08             	mov    0x8(%ebp),%eax
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	3c 39                	cmp    $0x39,%al
 34d:	7e c7                	jle    316 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 34f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 352:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 356:	c9                   	leave  
 357:	c3                   	ret    

00000358 <atoo>:

int
atoo(const char *s)
{
 358:	55                   	push   %ebp
 359:	89 e5                	mov    %esp,%ebp
 35b:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 35e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 365:	eb 04                	jmp    36b <atoo+0x13>
 367:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
 36e:	0f b6 00             	movzbl (%eax),%eax
 371:	3c 20                	cmp    $0x20,%al
 373:	74 f2                	je     367 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	0f b6 00             	movzbl (%eax),%eax
 37b:	3c 2d                	cmp    $0x2d,%al
 37d:	75 07                	jne    386 <atoo+0x2e>
 37f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 384:	eb 05                	jmp    38b <atoo+0x33>
 386:	b8 01 00 00 00       	mov    $0x1,%eax
 38b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	0f b6 00             	movzbl (%eax),%eax
 394:	3c 2b                	cmp    $0x2b,%al
 396:	74 0a                	je     3a2 <atoo+0x4a>
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	0f b6 00             	movzbl (%eax),%eax
 39e:	3c 2d                	cmp    $0x2d,%al
 3a0:	75 27                	jne    3c9 <atoo+0x71>
    s++;
 3a2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3a6:	eb 21                	jmp    3c9 <atoo+0x71>
    n = n*8 + *s++ - '0';
 3a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ab:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	8d 50 01             	lea    0x1(%eax),%edx
 3b8:	89 55 08             	mov    %edx,0x8(%ebp)
 3bb:	0f b6 00             	movzbl (%eax),%eax
 3be:	0f be c0             	movsbl %al,%eax
 3c1:	01 c8                	add    %ecx,%eax
 3c3:	83 e8 30             	sub    $0x30,%eax
 3c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	3c 2f                	cmp    $0x2f,%al
 3d1:	7e 0a                	jle    3dd <atoo+0x85>
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	3c 37                	cmp    $0x37,%al
 3db:	7e cb                	jle    3a8 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3e0:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3e4:	c9                   	leave  
 3e5:	c3                   	ret    

000003e6 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3ec:	8b 45 08             	mov    0x8(%ebp),%eax
 3ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3f8:	eb 17                	jmp    411 <memmove+0x2b>
    *dst++ = *src++;
 3fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fd:	8d 50 01             	lea    0x1(%eax),%edx
 400:	89 55 fc             	mov    %edx,-0x4(%ebp)
 403:	8b 55 f8             	mov    -0x8(%ebp),%edx
 406:	8d 4a 01             	lea    0x1(%edx),%ecx
 409:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 40c:	0f b6 12             	movzbl (%edx),%edx
 40f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 411:	8b 45 10             	mov    0x10(%ebp),%eax
 414:	8d 50 ff             	lea    -0x1(%eax),%edx
 417:	89 55 10             	mov    %edx,0x10(%ebp)
 41a:	85 c0                	test   %eax,%eax
 41c:	7f dc                	jg     3fa <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 41e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 421:	c9                   	leave  
 422:	c3                   	ret    

00000423 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 423:	b8 01 00 00 00       	mov    $0x1,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <exit>:
SYSCALL(exit)
 42b:	b8 02 00 00 00       	mov    $0x2,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <wait>:
SYSCALL(wait)
 433:	b8 03 00 00 00       	mov    $0x3,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <pipe>:
SYSCALL(pipe)
 43b:	b8 04 00 00 00       	mov    $0x4,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <read>:
SYSCALL(read)
 443:	b8 05 00 00 00       	mov    $0x5,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <write>:
SYSCALL(write)
 44b:	b8 10 00 00 00       	mov    $0x10,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <close>:
SYSCALL(close)
 453:	b8 15 00 00 00       	mov    $0x15,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <kill>:
SYSCALL(kill)
 45b:	b8 06 00 00 00       	mov    $0x6,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <exec>:
SYSCALL(exec)
 463:	b8 07 00 00 00       	mov    $0x7,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <open>:
SYSCALL(open)
 46b:	b8 0f 00 00 00       	mov    $0xf,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <mknod>:
SYSCALL(mknod)
 473:	b8 11 00 00 00       	mov    $0x11,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <unlink>:
SYSCALL(unlink)
 47b:	b8 12 00 00 00       	mov    $0x12,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <fstat>:
SYSCALL(fstat)
 483:	b8 08 00 00 00       	mov    $0x8,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <link>:
SYSCALL(link)
 48b:	b8 13 00 00 00       	mov    $0x13,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <mkdir>:
SYSCALL(mkdir)
 493:	b8 14 00 00 00       	mov    $0x14,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <chdir>:
SYSCALL(chdir)
 49b:	b8 09 00 00 00       	mov    $0x9,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <dup>:
SYSCALL(dup)
 4a3:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <getpid>:
SYSCALL(getpid)
 4ab:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <sbrk>:
SYSCALL(sbrk)
 4b3:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <sleep>:
SYSCALL(sleep)
 4bb:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <uptime>:
SYSCALL(uptime)
 4c3:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <halt>:
SYSCALL(halt)
 4cb:	b8 16 00 00 00       	mov    $0x16,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <date>:
SYSCALL(date)
 4d3:	b8 17 00 00 00       	mov    $0x17,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4db:	55                   	push   %ebp
 4dc:	89 e5                	mov    %esp,%ebp
 4de:	83 ec 18             	sub    $0x18,%esp
 4e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4e7:	83 ec 04             	sub    $0x4,%esp
 4ea:	6a 01                	push   $0x1
 4ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4ef:	50                   	push   %eax
 4f0:	ff 75 08             	pushl  0x8(%ebp)
 4f3:	e8 53 ff ff ff       	call   44b <write>
 4f8:	83 c4 10             	add    $0x10,%esp
}
 4fb:	90                   	nop
 4fc:	c9                   	leave  
 4fd:	c3                   	ret    

000004fe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4fe:	55                   	push   %ebp
 4ff:	89 e5                	mov    %esp,%ebp
 501:	53                   	push   %ebx
 502:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 505:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 50c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 510:	74 17                	je     529 <printint+0x2b>
 512:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 516:	79 11                	jns    529 <printint+0x2b>
    neg = 1;
 518:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 51f:	8b 45 0c             	mov    0xc(%ebp),%eax
 522:	f7 d8                	neg    %eax
 524:	89 45 ec             	mov    %eax,-0x14(%ebp)
 527:	eb 06                	jmp    52f <printint+0x31>
  } else {
    x = xx;
 529:	8b 45 0c             	mov    0xc(%ebp),%eax
 52c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 52f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 536:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 539:	8d 41 01             	lea    0x1(%ecx),%eax
 53c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 53f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 542:	8b 45 ec             	mov    -0x14(%ebp),%eax
 545:	ba 00 00 00 00       	mov    $0x0,%edx
 54a:	f7 f3                	div    %ebx
 54c:	89 d0                	mov    %edx,%eax
 54e:	0f b6 80 30 0c 00 00 	movzbl 0xc30(%eax),%eax
 555:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 559:	8b 5d 10             	mov    0x10(%ebp),%ebx
 55c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 55f:	ba 00 00 00 00       	mov    $0x0,%edx
 564:	f7 f3                	div    %ebx
 566:	89 45 ec             	mov    %eax,-0x14(%ebp)
 569:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56d:	75 c7                	jne    536 <printint+0x38>
  if(neg)
 56f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 573:	74 2d                	je     5a2 <printint+0xa4>
    buf[i++] = '-';
 575:	8b 45 f4             	mov    -0xc(%ebp),%eax
 578:	8d 50 01             	lea    0x1(%eax),%edx
 57b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 57e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 583:	eb 1d                	jmp    5a2 <printint+0xa4>
    putc(fd, buf[i]);
 585:	8d 55 dc             	lea    -0x24(%ebp),%edx
 588:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58b:	01 d0                	add    %edx,%eax
 58d:	0f b6 00             	movzbl (%eax),%eax
 590:	0f be c0             	movsbl %al,%eax
 593:	83 ec 08             	sub    $0x8,%esp
 596:	50                   	push   %eax
 597:	ff 75 08             	pushl  0x8(%ebp)
 59a:	e8 3c ff ff ff       	call   4db <putc>
 59f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5a2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5aa:	79 d9                	jns    585 <printint+0x87>
    putc(fd, buf[i]);
}
 5ac:	90                   	nop
 5ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5b0:	c9                   	leave  
 5b1:	c3                   	ret    

000005b2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5b2:	55                   	push   %ebp
 5b3:	89 e5                	mov    %esp,%ebp
 5b5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5bf:	8d 45 0c             	lea    0xc(%ebp),%eax
 5c2:	83 c0 04             	add    $0x4,%eax
 5c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5cf:	e9 59 01 00 00       	jmp    72d <printf+0x17b>
    c = fmt[i] & 0xff;
 5d4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5da:	01 d0                	add    %edx,%eax
 5dc:	0f b6 00             	movzbl (%eax),%eax
 5df:	0f be c0             	movsbl %al,%eax
 5e2:	25 ff 00 00 00       	and    $0xff,%eax
 5e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ee:	75 2c                	jne    61c <printf+0x6a>
      if(c == '%'){
 5f0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5f4:	75 0c                	jne    602 <printf+0x50>
        state = '%';
 5f6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5fd:	e9 27 01 00 00       	jmp    729 <printf+0x177>
      } else {
        putc(fd, c);
 602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 605:	0f be c0             	movsbl %al,%eax
 608:	83 ec 08             	sub    $0x8,%esp
 60b:	50                   	push   %eax
 60c:	ff 75 08             	pushl  0x8(%ebp)
 60f:	e8 c7 fe ff ff       	call   4db <putc>
 614:	83 c4 10             	add    $0x10,%esp
 617:	e9 0d 01 00 00       	jmp    729 <printf+0x177>
      }
    } else if(state == '%'){
 61c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 620:	0f 85 03 01 00 00    	jne    729 <printf+0x177>
      if(c == 'd'){
 626:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 62a:	75 1e                	jne    64a <printf+0x98>
        printint(fd, *ap, 10, 1);
 62c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	6a 01                	push   $0x1
 633:	6a 0a                	push   $0xa
 635:	50                   	push   %eax
 636:	ff 75 08             	pushl  0x8(%ebp)
 639:	e8 c0 fe ff ff       	call   4fe <printint>
 63e:	83 c4 10             	add    $0x10,%esp
        ap++;
 641:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 645:	e9 d8 00 00 00       	jmp    722 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 64a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 64e:	74 06                	je     656 <printf+0xa4>
 650:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 654:	75 1e                	jne    674 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 656:	8b 45 e8             	mov    -0x18(%ebp),%eax
 659:	8b 00                	mov    (%eax),%eax
 65b:	6a 00                	push   $0x0
 65d:	6a 10                	push   $0x10
 65f:	50                   	push   %eax
 660:	ff 75 08             	pushl  0x8(%ebp)
 663:	e8 96 fe ff ff       	call   4fe <printint>
 668:	83 c4 10             	add    $0x10,%esp
        ap++;
 66b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66f:	e9 ae 00 00 00       	jmp    722 <printf+0x170>
      } else if(c == 's'){
 674:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 678:	75 43                	jne    6bd <printf+0x10b>
        s = (char*)*ap;
 67a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67d:	8b 00                	mov    (%eax),%eax
 67f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 682:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 686:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 68a:	75 25                	jne    6b1 <printf+0xff>
          s = "(null)";
 68c:	c7 45 f4 b8 09 00 00 	movl   $0x9b8,-0xc(%ebp)
        while(*s != 0){
 693:	eb 1c                	jmp    6b1 <printf+0xff>
          putc(fd, *s);
 695:	8b 45 f4             	mov    -0xc(%ebp),%eax
 698:	0f b6 00             	movzbl (%eax),%eax
 69b:	0f be c0             	movsbl %al,%eax
 69e:	83 ec 08             	sub    $0x8,%esp
 6a1:	50                   	push   %eax
 6a2:	ff 75 08             	pushl  0x8(%ebp)
 6a5:	e8 31 fe ff ff       	call   4db <putc>
 6aa:	83 c4 10             	add    $0x10,%esp
          s++;
 6ad:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b4:	0f b6 00             	movzbl (%eax),%eax
 6b7:	84 c0                	test   %al,%al
 6b9:	75 da                	jne    695 <printf+0xe3>
 6bb:	eb 65                	jmp    722 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6bd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6c1:	75 1d                	jne    6e0 <printf+0x12e>
        putc(fd, *ap);
 6c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c6:	8b 00                	mov    (%eax),%eax
 6c8:	0f be c0             	movsbl %al,%eax
 6cb:	83 ec 08             	sub    $0x8,%esp
 6ce:	50                   	push   %eax
 6cf:	ff 75 08             	pushl  0x8(%ebp)
 6d2:	e8 04 fe ff ff       	call   4db <putc>
 6d7:	83 c4 10             	add    $0x10,%esp
        ap++;
 6da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6de:	eb 42                	jmp    722 <printf+0x170>
      } else if(c == '%'){
 6e0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6e4:	75 17                	jne    6fd <printf+0x14b>
        putc(fd, c);
 6e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e9:	0f be c0             	movsbl %al,%eax
 6ec:	83 ec 08             	sub    $0x8,%esp
 6ef:	50                   	push   %eax
 6f0:	ff 75 08             	pushl  0x8(%ebp)
 6f3:	e8 e3 fd ff ff       	call   4db <putc>
 6f8:	83 c4 10             	add    $0x10,%esp
 6fb:	eb 25                	jmp    722 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6fd:	83 ec 08             	sub    $0x8,%esp
 700:	6a 25                	push   $0x25
 702:	ff 75 08             	pushl  0x8(%ebp)
 705:	e8 d1 fd ff ff       	call   4db <putc>
 70a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 70d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 710:	0f be c0             	movsbl %al,%eax
 713:	83 ec 08             	sub    $0x8,%esp
 716:	50                   	push   %eax
 717:	ff 75 08             	pushl  0x8(%ebp)
 71a:	e8 bc fd ff ff       	call   4db <putc>
 71f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 722:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 729:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 72d:	8b 55 0c             	mov    0xc(%ebp),%edx
 730:	8b 45 f0             	mov    -0x10(%ebp),%eax
 733:	01 d0                	add    %edx,%eax
 735:	0f b6 00             	movzbl (%eax),%eax
 738:	84 c0                	test   %al,%al
 73a:	0f 85 94 fe ff ff    	jne    5d4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 740:	90                   	nop
 741:	c9                   	leave  
 742:	c3                   	ret    

00000743 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 743:	55                   	push   %ebp
 744:	89 e5                	mov    %esp,%ebp
 746:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 749:	8b 45 08             	mov    0x8(%ebp),%eax
 74c:	83 e8 08             	sub    $0x8,%eax
 74f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 752:	a1 4c 0c 00 00       	mov    0xc4c,%eax
 757:	89 45 fc             	mov    %eax,-0x4(%ebp)
 75a:	eb 24                	jmp    780 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75f:	8b 00                	mov    (%eax),%eax
 761:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 764:	77 12                	ja     778 <free+0x35>
 766:	8b 45 f8             	mov    -0x8(%ebp),%eax
 769:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76c:	77 24                	ja     792 <free+0x4f>
 76e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 771:	8b 00                	mov    (%eax),%eax
 773:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 776:	77 1a                	ja     792 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 778:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77b:	8b 00                	mov    (%eax),%eax
 77d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 780:	8b 45 f8             	mov    -0x8(%ebp),%eax
 783:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 786:	76 d4                	jbe    75c <free+0x19>
 788:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78b:	8b 00                	mov    (%eax),%eax
 78d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 790:	76 ca                	jbe    75c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 792:	8b 45 f8             	mov    -0x8(%ebp),%eax
 795:	8b 40 04             	mov    0x4(%eax),%eax
 798:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 79f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a2:	01 c2                	add    %eax,%edx
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	39 c2                	cmp    %eax,%edx
 7ab:	75 24                	jne    7d1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b0:	8b 50 04             	mov    0x4(%eax),%edx
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	8b 40 04             	mov    0x4(%eax),%eax
 7bb:	01 c2                	add    %eax,%edx
 7bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 00                	mov    (%eax),%eax
 7c8:	8b 10                	mov    (%eax),%edx
 7ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cd:	89 10                	mov    %edx,(%eax)
 7cf:	eb 0a                	jmp    7db <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 10                	mov    (%eax),%edx
 7d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7db:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7de:	8b 40 04             	mov    0x4(%eax),%eax
 7e1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	01 d0                	add    %edx,%eax
 7ed:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7f0:	75 20                	jne    812 <free+0xcf>
    p->s.size += bp->s.size;
 7f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f5:	8b 50 04             	mov    0x4(%eax),%edx
 7f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fb:	8b 40 04             	mov    0x4(%eax),%eax
 7fe:	01 c2                	add    %eax,%edx
 800:	8b 45 fc             	mov    -0x4(%ebp),%eax
 803:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 806:	8b 45 f8             	mov    -0x8(%ebp),%eax
 809:	8b 10                	mov    (%eax),%edx
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	89 10                	mov    %edx,(%eax)
 810:	eb 08                	jmp    81a <free+0xd7>
  } else
    p->s.ptr = bp;
 812:	8b 45 fc             	mov    -0x4(%ebp),%eax
 815:	8b 55 f8             	mov    -0x8(%ebp),%edx
 818:	89 10                	mov    %edx,(%eax)
  freep = p;
 81a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81d:	a3 4c 0c 00 00       	mov    %eax,0xc4c
}
 822:	90                   	nop
 823:	c9                   	leave  
 824:	c3                   	ret    

00000825 <morecore>:

static Header*
morecore(uint nu)
{
 825:	55                   	push   %ebp
 826:	89 e5                	mov    %esp,%ebp
 828:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 82b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 832:	77 07                	ja     83b <morecore+0x16>
    nu = 4096;
 834:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 83b:	8b 45 08             	mov    0x8(%ebp),%eax
 83e:	c1 e0 03             	shl    $0x3,%eax
 841:	83 ec 0c             	sub    $0xc,%esp
 844:	50                   	push   %eax
 845:	e8 69 fc ff ff       	call   4b3 <sbrk>
 84a:	83 c4 10             	add    $0x10,%esp
 84d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 850:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 854:	75 07                	jne    85d <morecore+0x38>
    return 0;
 856:	b8 00 00 00 00       	mov    $0x0,%eax
 85b:	eb 26                	jmp    883 <morecore+0x5e>
  hp = (Header*)p;
 85d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 860:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 863:	8b 45 f0             	mov    -0x10(%ebp),%eax
 866:	8b 55 08             	mov    0x8(%ebp),%edx
 869:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 86c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86f:	83 c0 08             	add    $0x8,%eax
 872:	83 ec 0c             	sub    $0xc,%esp
 875:	50                   	push   %eax
 876:	e8 c8 fe ff ff       	call   743 <free>
 87b:	83 c4 10             	add    $0x10,%esp
  return freep;
 87e:	a1 4c 0c 00 00       	mov    0xc4c,%eax
}
 883:	c9                   	leave  
 884:	c3                   	ret    

00000885 <malloc>:

void*
malloc(uint nbytes)
{
 885:	55                   	push   %ebp
 886:	89 e5                	mov    %esp,%ebp
 888:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 88b:	8b 45 08             	mov    0x8(%ebp),%eax
 88e:	83 c0 07             	add    $0x7,%eax
 891:	c1 e8 03             	shr    $0x3,%eax
 894:	83 c0 01             	add    $0x1,%eax
 897:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 89a:	a1 4c 0c 00 00       	mov    0xc4c,%eax
 89f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8a6:	75 23                	jne    8cb <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8a8:	c7 45 f0 44 0c 00 00 	movl   $0xc44,-0x10(%ebp)
 8af:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b2:	a3 4c 0c 00 00       	mov    %eax,0xc4c
 8b7:	a1 4c 0c 00 00       	mov    0xc4c,%eax
 8bc:	a3 44 0c 00 00       	mov    %eax,0xc44
    base.s.size = 0;
 8c1:	c7 05 48 0c 00 00 00 	movl   $0x0,0xc48
 8c8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ce:	8b 00                	mov    (%eax),%eax
 8d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d6:	8b 40 04             	mov    0x4(%eax),%eax
 8d9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8dc:	72 4d                	jb     92b <malloc+0xa6>
      if(p->s.size == nunits)
 8de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e1:	8b 40 04             	mov    0x4(%eax),%eax
 8e4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e7:	75 0c                	jne    8f5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	8b 10                	mov    (%eax),%edx
 8ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f1:	89 10                	mov    %edx,(%eax)
 8f3:	eb 26                	jmp    91b <malloc+0x96>
      else {
        p->s.size -= nunits;
 8f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f8:	8b 40 04             	mov    0x4(%eax),%eax
 8fb:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8fe:	89 c2                	mov    %eax,%edx
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 906:	8b 45 f4             	mov    -0xc(%ebp),%eax
 909:	8b 40 04             	mov    0x4(%eax),%eax
 90c:	c1 e0 03             	shl    $0x3,%eax
 90f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 912:	8b 45 f4             	mov    -0xc(%ebp),%eax
 915:	8b 55 ec             	mov    -0x14(%ebp),%edx
 918:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 91b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91e:	a3 4c 0c 00 00       	mov    %eax,0xc4c
      return (void*)(p + 1);
 923:	8b 45 f4             	mov    -0xc(%ebp),%eax
 926:	83 c0 08             	add    $0x8,%eax
 929:	eb 3b                	jmp    966 <malloc+0xe1>
    }
    if(p == freep)
 92b:	a1 4c 0c 00 00       	mov    0xc4c,%eax
 930:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 933:	75 1e                	jne    953 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 935:	83 ec 0c             	sub    $0xc,%esp
 938:	ff 75 ec             	pushl  -0x14(%ebp)
 93b:	e8 e5 fe ff ff       	call   825 <morecore>
 940:	83 c4 10             	add    $0x10,%esp
 943:	89 45 f4             	mov    %eax,-0xc(%ebp)
 946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 94a:	75 07                	jne    953 <malloc+0xce>
        return 0;
 94c:	b8 00 00 00 00       	mov    $0x0,%eax
 951:	eb 13                	jmp    966 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 953:	8b 45 f4             	mov    -0xc(%ebp),%eax
 956:	89 45 f0             	mov    %eax,-0x10(%ebp)
 959:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95c:	8b 00                	mov    (%eax),%eax
 95e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 961:	e9 6d ff ff ff       	jmp    8d3 <malloc+0x4e>
}
 966:	c9                   	leave  
 967:	c3                   	ret    
