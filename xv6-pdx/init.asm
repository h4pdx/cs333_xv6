
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
  16:	68 bb 09 00 00       	push   $0x9bb
  1b:	e8 4b 04 00 00       	call   46b <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 bb 09 00 00       	push   $0x9bb
  33:	e8 3b 04 00 00       	call   473 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 bb 09 00 00       	push   $0x9bb
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
  6a:	68 c3 09 00 00       	push   $0x9c3
  6f:	6a 01                	push   $0x1
  71:	e8 8c 05 00 00       	call   602 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 a5 03 00 00       	call   423 <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 d6 09 00 00       	push   $0x9d6
  8f:	6a 01                	push   $0x1
  91:	e8 6c 05 00 00       	call   602 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 8d 03 00 00       	call   42b <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 78 0c 00 00       	push   $0xc78
  ac:	68 b8 09 00 00       	push   $0x9b8
  b1:	e8 ad 03 00 00       	call   463 <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 e9 09 00 00       	push   $0x9e9
  c1:	6a 01                	push   $0x1
  c3:	e8 3a 05 00 00       	call   602 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 5b 03 00 00       	call   42b <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 ff 09 00 00       	push   $0x9ff
  d8:	6a 01                	push   $0x1
  da:	e8 23 05 00 00       	call   602 <printf>
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

000004db <getuid>:
SYSCALL(getuid)
 4db:	b8 18 00 00 00       	mov    $0x18,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <getgid>:
SYSCALL(getgid)
 4e3:	b8 19 00 00 00       	mov    $0x19,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <getppid>:
SYSCALL(getppid)
 4eb:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <setuid>:
SYSCALL(setuid)
 4f3:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <setgid>:
SYSCALL(setgid)
 4fb:	b8 1c 00 00 00       	mov    $0x1c,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <getprocs>:
SYSCALL(getprocs)
 503:	b8 1d 00 00 00       	mov    $0x1d,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <setpriority>:
SYSCALL(setpriority)
 50b:	b8 1e 00 00 00       	mov    $0x1e,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <chmod>:
SYSCALL(chmod)
 513:	b8 1f 00 00 00       	mov    $0x1f,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <chown>:
SYSCALL(chown)
 51b:	b8 20 00 00 00       	mov    $0x20,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <chgrp>:
SYSCALL(chgrp)
 523:	b8 21 00 00 00       	mov    $0x21,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 52b:	55                   	push   %ebp
 52c:	89 e5                	mov    %esp,%ebp
 52e:	83 ec 18             	sub    $0x18,%esp
 531:	8b 45 0c             	mov    0xc(%ebp),%eax
 534:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 537:	83 ec 04             	sub    $0x4,%esp
 53a:	6a 01                	push   $0x1
 53c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 53f:	50                   	push   %eax
 540:	ff 75 08             	pushl  0x8(%ebp)
 543:	e8 03 ff ff ff       	call   44b <write>
 548:	83 c4 10             	add    $0x10,%esp
}
 54b:	90                   	nop
 54c:	c9                   	leave  
 54d:	c3                   	ret    

0000054e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 54e:	55                   	push   %ebp
 54f:	89 e5                	mov    %esp,%ebp
 551:	53                   	push   %ebx
 552:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 555:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 55c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 560:	74 17                	je     579 <printint+0x2b>
 562:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 566:	79 11                	jns    579 <printint+0x2b>
    neg = 1;
 568:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 56f:	8b 45 0c             	mov    0xc(%ebp),%eax
 572:	f7 d8                	neg    %eax
 574:	89 45 ec             	mov    %eax,-0x14(%ebp)
 577:	eb 06                	jmp    57f <printint+0x31>
  } else {
    x = xx;
 579:	8b 45 0c             	mov    0xc(%ebp),%eax
 57c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 57f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 586:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 589:	8d 41 01             	lea    0x1(%ecx),%eax
 58c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 58f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 592:	8b 45 ec             	mov    -0x14(%ebp),%eax
 595:	ba 00 00 00 00       	mov    $0x0,%edx
 59a:	f7 f3                	div    %ebx
 59c:	89 d0                	mov    %edx,%eax
 59e:	0f b6 80 80 0c 00 00 	movzbl 0xc80(%eax),%eax
 5a5:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5af:	ba 00 00 00 00       	mov    $0x0,%edx
 5b4:	f7 f3                	div    %ebx
 5b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5bd:	75 c7                	jne    586 <printint+0x38>
  if(neg)
 5bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5c3:	74 2d                	je     5f2 <printint+0xa4>
    buf[i++] = '-';
 5c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c8:	8d 50 01             	lea    0x1(%eax),%edx
 5cb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5ce:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5d3:	eb 1d                	jmp    5f2 <printint+0xa4>
    putc(fd, buf[i]);
 5d5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5db:	01 d0                	add    %edx,%eax
 5dd:	0f b6 00             	movzbl (%eax),%eax
 5e0:	0f be c0             	movsbl %al,%eax
 5e3:	83 ec 08             	sub    $0x8,%esp
 5e6:	50                   	push   %eax
 5e7:	ff 75 08             	pushl  0x8(%ebp)
 5ea:	e8 3c ff ff ff       	call   52b <putc>
 5ef:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5f2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5fa:	79 d9                	jns    5d5 <printint+0x87>
    putc(fd, buf[i]);
}
 5fc:	90                   	nop
 5fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 600:	c9                   	leave  
 601:	c3                   	ret    

00000602 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 602:	55                   	push   %ebp
 603:	89 e5                	mov    %esp,%ebp
 605:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 608:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 60f:	8d 45 0c             	lea    0xc(%ebp),%eax
 612:	83 c0 04             	add    $0x4,%eax
 615:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 618:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 61f:	e9 59 01 00 00       	jmp    77d <printf+0x17b>
    c = fmt[i] & 0xff;
 624:	8b 55 0c             	mov    0xc(%ebp),%edx
 627:	8b 45 f0             	mov    -0x10(%ebp),%eax
 62a:	01 d0                	add    %edx,%eax
 62c:	0f b6 00             	movzbl (%eax),%eax
 62f:	0f be c0             	movsbl %al,%eax
 632:	25 ff 00 00 00       	and    $0xff,%eax
 637:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 63a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 63e:	75 2c                	jne    66c <printf+0x6a>
      if(c == '%'){
 640:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 644:	75 0c                	jne    652 <printf+0x50>
        state = '%';
 646:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 64d:	e9 27 01 00 00       	jmp    779 <printf+0x177>
      } else {
        putc(fd, c);
 652:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 655:	0f be c0             	movsbl %al,%eax
 658:	83 ec 08             	sub    $0x8,%esp
 65b:	50                   	push   %eax
 65c:	ff 75 08             	pushl  0x8(%ebp)
 65f:	e8 c7 fe ff ff       	call   52b <putc>
 664:	83 c4 10             	add    $0x10,%esp
 667:	e9 0d 01 00 00       	jmp    779 <printf+0x177>
      }
    } else if(state == '%'){
 66c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 670:	0f 85 03 01 00 00    	jne    779 <printf+0x177>
      if(c == 'd'){
 676:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 67a:	75 1e                	jne    69a <printf+0x98>
        printint(fd, *ap, 10, 1);
 67c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 67f:	8b 00                	mov    (%eax),%eax
 681:	6a 01                	push   $0x1
 683:	6a 0a                	push   $0xa
 685:	50                   	push   %eax
 686:	ff 75 08             	pushl  0x8(%ebp)
 689:	e8 c0 fe ff ff       	call   54e <printint>
 68e:	83 c4 10             	add    $0x10,%esp
        ap++;
 691:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 695:	e9 d8 00 00 00       	jmp    772 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 69a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 69e:	74 06                	je     6a6 <printf+0xa4>
 6a0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6a4:	75 1e                	jne    6c4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a9:	8b 00                	mov    (%eax),%eax
 6ab:	6a 00                	push   $0x0
 6ad:	6a 10                	push   $0x10
 6af:	50                   	push   %eax
 6b0:	ff 75 08             	pushl  0x8(%ebp)
 6b3:	e8 96 fe ff ff       	call   54e <printint>
 6b8:	83 c4 10             	add    $0x10,%esp
        ap++;
 6bb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6bf:	e9 ae 00 00 00       	jmp    772 <printf+0x170>
      } else if(c == 's'){
 6c4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6c8:	75 43                	jne    70d <printf+0x10b>
        s = (char*)*ap;
 6ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6cd:	8b 00                	mov    (%eax),%eax
 6cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6d2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6da:	75 25                	jne    701 <printf+0xff>
          s = "(null)";
 6dc:	c7 45 f4 08 0a 00 00 	movl   $0xa08,-0xc(%ebp)
        while(*s != 0){
 6e3:	eb 1c                	jmp    701 <printf+0xff>
          putc(fd, *s);
 6e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e8:	0f b6 00             	movzbl (%eax),%eax
 6eb:	0f be c0             	movsbl %al,%eax
 6ee:	83 ec 08             	sub    $0x8,%esp
 6f1:	50                   	push   %eax
 6f2:	ff 75 08             	pushl  0x8(%ebp)
 6f5:	e8 31 fe ff ff       	call   52b <putc>
 6fa:	83 c4 10             	add    $0x10,%esp
          s++;
 6fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 701:	8b 45 f4             	mov    -0xc(%ebp),%eax
 704:	0f b6 00             	movzbl (%eax),%eax
 707:	84 c0                	test   %al,%al
 709:	75 da                	jne    6e5 <printf+0xe3>
 70b:	eb 65                	jmp    772 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 70d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 711:	75 1d                	jne    730 <printf+0x12e>
        putc(fd, *ap);
 713:	8b 45 e8             	mov    -0x18(%ebp),%eax
 716:	8b 00                	mov    (%eax),%eax
 718:	0f be c0             	movsbl %al,%eax
 71b:	83 ec 08             	sub    $0x8,%esp
 71e:	50                   	push   %eax
 71f:	ff 75 08             	pushl  0x8(%ebp)
 722:	e8 04 fe ff ff       	call   52b <putc>
 727:	83 c4 10             	add    $0x10,%esp
        ap++;
 72a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 72e:	eb 42                	jmp    772 <printf+0x170>
      } else if(c == '%'){
 730:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 734:	75 17                	jne    74d <printf+0x14b>
        putc(fd, c);
 736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 739:	0f be c0             	movsbl %al,%eax
 73c:	83 ec 08             	sub    $0x8,%esp
 73f:	50                   	push   %eax
 740:	ff 75 08             	pushl  0x8(%ebp)
 743:	e8 e3 fd ff ff       	call   52b <putc>
 748:	83 c4 10             	add    $0x10,%esp
 74b:	eb 25                	jmp    772 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 74d:	83 ec 08             	sub    $0x8,%esp
 750:	6a 25                	push   $0x25
 752:	ff 75 08             	pushl  0x8(%ebp)
 755:	e8 d1 fd ff ff       	call   52b <putc>
 75a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 75d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 760:	0f be c0             	movsbl %al,%eax
 763:	83 ec 08             	sub    $0x8,%esp
 766:	50                   	push   %eax
 767:	ff 75 08             	pushl  0x8(%ebp)
 76a:	e8 bc fd ff ff       	call   52b <putc>
 76f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 772:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 779:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 77d:	8b 55 0c             	mov    0xc(%ebp),%edx
 780:	8b 45 f0             	mov    -0x10(%ebp),%eax
 783:	01 d0                	add    %edx,%eax
 785:	0f b6 00             	movzbl (%eax),%eax
 788:	84 c0                	test   %al,%al
 78a:	0f 85 94 fe ff ff    	jne    624 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 790:	90                   	nop
 791:	c9                   	leave  
 792:	c3                   	ret    

00000793 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 793:	55                   	push   %ebp
 794:	89 e5                	mov    %esp,%ebp
 796:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 799:	8b 45 08             	mov    0x8(%ebp),%eax
 79c:	83 e8 08             	sub    $0x8,%eax
 79f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a2:	a1 9c 0c 00 00       	mov    0xc9c,%eax
 7a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7aa:	eb 24                	jmp    7d0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7af:	8b 00                	mov    (%eax),%eax
 7b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b4:	77 12                	ja     7c8 <free+0x35>
 7b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bc:	77 24                	ja     7e2 <free+0x4f>
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c6:	77 1a                	ja     7e2 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	8b 00                	mov    (%eax),%eax
 7cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7d6:	76 d4                	jbe    7ac <free+0x19>
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e0:	76 ca                	jbe    7ac <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e5:	8b 40 04             	mov    0x4(%eax),%eax
 7e8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f2:	01 c2                	add    %eax,%edx
 7f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f7:	8b 00                	mov    (%eax),%eax
 7f9:	39 c2                	cmp    %eax,%edx
 7fb:	75 24                	jne    821 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 800:	8b 50 04             	mov    0x4(%eax),%edx
 803:	8b 45 fc             	mov    -0x4(%ebp),%eax
 806:	8b 00                	mov    (%eax),%eax
 808:	8b 40 04             	mov    0x4(%eax),%eax
 80b:	01 c2                	add    %eax,%edx
 80d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 810:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 813:	8b 45 fc             	mov    -0x4(%ebp),%eax
 816:	8b 00                	mov    (%eax),%eax
 818:	8b 10                	mov    (%eax),%edx
 81a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81d:	89 10                	mov    %edx,(%eax)
 81f:	eb 0a                	jmp    82b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 821:	8b 45 fc             	mov    -0x4(%ebp),%eax
 824:	8b 10                	mov    (%eax),%edx
 826:	8b 45 f8             	mov    -0x8(%ebp),%eax
 829:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	8b 40 04             	mov    0x4(%eax),%eax
 831:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 838:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83b:	01 d0                	add    %edx,%eax
 83d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 840:	75 20                	jne    862 <free+0xcf>
    p->s.size += bp->s.size;
 842:	8b 45 fc             	mov    -0x4(%ebp),%eax
 845:	8b 50 04             	mov    0x4(%eax),%edx
 848:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84b:	8b 40 04             	mov    0x4(%eax),%eax
 84e:	01 c2                	add    %eax,%edx
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 856:	8b 45 f8             	mov    -0x8(%ebp),%eax
 859:	8b 10                	mov    (%eax),%edx
 85b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85e:	89 10                	mov    %edx,(%eax)
 860:	eb 08                	jmp    86a <free+0xd7>
  } else
    p->s.ptr = bp;
 862:	8b 45 fc             	mov    -0x4(%ebp),%eax
 865:	8b 55 f8             	mov    -0x8(%ebp),%edx
 868:	89 10                	mov    %edx,(%eax)
  freep = p;
 86a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86d:	a3 9c 0c 00 00       	mov    %eax,0xc9c
}
 872:	90                   	nop
 873:	c9                   	leave  
 874:	c3                   	ret    

00000875 <morecore>:

static Header*
morecore(uint nu)
{
 875:	55                   	push   %ebp
 876:	89 e5                	mov    %esp,%ebp
 878:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 87b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 882:	77 07                	ja     88b <morecore+0x16>
    nu = 4096;
 884:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 88b:	8b 45 08             	mov    0x8(%ebp),%eax
 88e:	c1 e0 03             	shl    $0x3,%eax
 891:	83 ec 0c             	sub    $0xc,%esp
 894:	50                   	push   %eax
 895:	e8 19 fc ff ff       	call   4b3 <sbrk>
 89a:	83 c4 10             	add    $0x10,%esp
 89d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8a0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8a4:	75 07                	jne    8ad <morecore+0x38>
    return 0;
 8a6:	b8 00 00 00 00       	mov    $0x0,%eax
 8ab:	eb 26                	jmp    8d3 <morecore+0x5e>
  hp = (Header*)p;
 8ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b6:	8b 55 08             	mov    0x8(%ebp),%edx
 8b9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bf:	83 c0 08             	add    $0x8,%eax
 8c2:	83 ec 0c             	sub    $0xc,%esp
 8c5:	50                   	push   %eax
 8c6:	e8 c8 fe ff ff       	call   793 <free>
 8cb:	83 c4 10             	add    $0x10,%esp
  return freep;
 8ce:	a1 9c 0c 00 00       	mov    0xc9c,%eax
}
 8d3:	c9                   	leave  
 8d4:	c3                   	ret    

000008d5 <malloc>:

void*
malloc(uint nbytes)
{
 8d5:	55                   	push   %ebp
 8d6:	89 e5                	mov    %esp,%ebp
 8d8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8db:	8b 45 08             	mov    0x8(%ebp),%eax
 8de:	83 c0 07             	add    $0x7,%eax
 8e1:	c1 e8 03             	shr    $0x3,%eax
 8e4:	83 c0 01             	add    $0x1,%eax
 8e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8ea:	a1 9c 0c 00 00       	mov    0xc9c,%eax
 8ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8f6:	75 23                	jne    91b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8f8:	c7 45 f0 94 0c 00 00 	movl   $0xc94,-0x10(%ebp)
 8ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
 902:	a3 9c 0c 00 00       	mov    %eax,0xc9c
 907:	a1 9c 0c 00 00       	mov    0xc9c,%eax
 90c:	a3 94 0c 00 00       	mov    %eax,0xc94
    base.s.size = 0;
 911:	c7 05 98 0c 00 00 00 	movl   $0x0,0xc98
 918:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 91b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91e:	8b 00                	mov    (%eax),%eax
 920:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 923:	8b 45 f4             	mov    -0xc(%ebp),%eax
 926:	8b 40 04             	mov    0x4(%eax),%eax
 929:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 92c:	72 4d                	jb     97b <malloc+0xa6>
      if(p->s.size == nunits)
 92e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 931:	8b 40 04             	mov    0x4(%eax),%eax
 934:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 937:	75 0c                	jne    945 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 939:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93c:	8b 10                	mov    (%eax),%edx
 93e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 941:	89 10                	mov    %edx,(%eax)
 943:	eb 26                	jmp    96b <malloc+0x96>
      else {
        p->s.size -= nunits;
 945:	8b 45 f4             	mov    -0xc(%ebp),%eax
 948:	8b 40 04             	mov    0x4(%eax),%eax
 94b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 94e:	89 c2                	mov    %eax,%edx
 950:	8b 45 f4             	mov    -0xc(%ebp),%eax
 953:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 956:	8b 45 f4             	mov    -0xc(%ebp),%eax
 959:	8b 40 04             	mov    0x4(%eax),%eax
 95c:	c1 e0 03             	shl    $0x3,%eax
 95f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	8b 55 ec             	mov    -0x14(%ebp),%edx
 968:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 96b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96e:	a3 9c 0c 00 00       	mov    %eax,0xc9c
      return (void*)(p + 1);
 973:	8b 45 f4             	mov    -0xc(%ebp),%eax
 976:	83 c0 08             	add    $0x8,%eax
 979:	eb 3b                	jmp    9b6 <malloc+0xe1>
    }
    if(p == freep)
 97b:	a1 9c 0c 00 00       	mov    0xc9c,%eax
 980:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 983:	75 1e                	jne    9a3 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 985:	83 ec 0c             	sub    $0xc,%esp
 988:	ff 75 ec             	pushl  -0x14(%ebp)
 98b:	e8 e5 fe ff ff       	call   875 <morecore>
 990:	83 c4 10             	add    $0x10,%esp
 993:	89 45 f4             	mov    %eax,-0xc(%ebp)
 996:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 99a:	75 07                	jne    9a3 <malloc+0xce>
        return 0;
 99c:	b8 00 00 00 00       	mov    $0x0,%eax
 9a1:	eb 13                	jmp    9b6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ac:	8b 00                	mov    (%eax),%eax
 9ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9b1:	e9 6d ff ff ff       	jmp    923 <malloc+0x4e>
}
 9b6:	c9                   	leave  
 9b7:	c3                   	ret    
